1 pragma solidity ^0.5.17;
2 pragma experimental ABIEncoderV2;
3 
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
160 /**
161  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
162  * the optional functions; to access them see {ERC20Detailed}.
163  */
164 interface IERC20 {
165     /**
166      * @dev Returns the amount of tokens in existence.
167      */
168     function totalSupply() external view returns (uint256);
169 
170     /**
171      * @dev Returns the amount of tokens owned by `account`.
172      */
173     function balanceOf(address account) external view returns (uint256);
174 
175     /**
176      * @dev Moves `amount` tokens from the caller's account to `recipient`.
177      *
178      * Returns a boolean value indicating whether the operation succeeded.
179      *
180      * Emits a {Transfer} event.
181      */
182     function transfer(address recipient, uint256 amount) external returns (bool);
183 
184     /**
185      * @dev Returns the remaining number of tokens that `spender` will be
186      * allowed to spend on behalf of `owner` through {transferFrom}. This is
187      * zero by default.
188      *
189      * This value changes when {approve} or {transferFrom} are called.
190      */
191     function allowance(address owner, address spender) external view returns (uint256);
192 
193     /**
194      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
195      *
196      * Returns a boolean value indicating whether the operation succeeded.
197      *
198      * IMPORTANT: Beware that changing an allowance with this method brings the risk
199      * that someone may use both the old and the new allowance by unfortunate
200      * transaction ordering. One possible solution to mitigate this race
201      * condition is to first reduce the spender's allowance to 0 and set the
202      * desired value afterwards:
203      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
204      *
205      * Emits an {Approval} event.
206      */
207     function approve(address spender, uint256 amount) external returns (bool);
208 
209     /**
210      * @dev Moves `amount` tokens from `sender` to `recipient` using the
211      * allowance mechanism. `amount` is then deducted from the caller's
212      * allowance.
213      *
214      * Returns a boolean value indicating whether the operation succeeded.
215      *
216      * Emits a {Transfer} event.
217      */
218     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
219 
220     /**
221      * @dev Emitted when `value` tokens are moved from one account (`from`) to
222      * another (`to`).
223      *
224      * Note that `value` may be zero.
225      */
226     event Transfer(address indexed from, address indexed to, uint256 value);
227 
228     /**
229      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
230      * a call to {approve}. `value` is the new allowance.
231      */
232     event Approval(address indexed owner, address indexed spender, uint256 value);
233 }
234 
235 /*
236     Copyright 2019 dYdX Trading Inc.
237 
238     Licensed under the Apache License, Version 2.0 (the "License");
239     you may not use this file except in compliance with the License.
240     You may obtain a copy of the License at
241 
242     http://www.apache.org/licenses/LICENSE-2.0
243 
244     Unless required by applicable law or agreed to in writing, software
245     distributed under the License is distributed on an "AS IS" BASIS,
246     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
247     See the License for the specific language governing permissions and
248     limitations under the License.
249 */
250 /**
251  * @title Require
252  * @author dYdX
253  *
254  * Stringifies parameters to pretty-print revert messages. Costs more gas than regular require()
255  */
256 library Require {
257 
258     // ============ Constants ============
259 
260     uint256 constant ASCII_ZERO = 48; // '0'
261     uint256 constant ASCII_RELATIVE_ZERO = 87; // 'a' - 10
262     uint256 constant ASCII_LOWER_EX = 120; // 'x'
263     bytes2 constant COLON = 0x3a20; // ': '
264     bytes2 constant COMMA = 0x2c20; // ', '
265     bytes2 constant LPAREN = 0x203c; // ' <'
266     byte constant RPAREN = 0x3e; // '>'
267     uint256 constant FOUR_BIT_MASK = 0xf;
268 
269     // ============ Library Functions ============
270 
271     function that(
272         bool must,
273         bytes32 file,
274         bytes32 reason
275     )
276     internal
277     pure
278     {
279         if (!must) {
280             revert(
281                 string(
282                     abi.encodePacked(
283                         stringifyTruncated(file),
284                         COLON,
285                         stringifyTruncated(reason)
286                     )
287                 )
288             );
289         }
290     }
291 
292     function that(
293         bool must,
294         bytes32 file,
295         bytes32 reason,
296         uint256 payloadA
297     )
298     internal
299     pure
300     {
301         if (!must) {
302             revert(
303                 string(
304                     abi.encodePacked(
305                         stringifyTruncated(file),
306                         COLON,
307                         stringifyTruncated(reason),
308                         LPAREN,
309                         stringify(payloadA),
310                         RPAREN
311                     )
312                 )
313             );
314         }
315     }
316 
317     function that(
318         bool must,
319         bytes32 file,
320         bytes32 reason,
321         uint256 payloadA,
322         uint256 payloadB
323     )
324     internal
325     pure
326     {
327         if (!must) {
328             revert(
329                 string(
330                     abi.encodePacked(
331                         stringifyTruncated(file),
332                         COLON,
333                         stringifyTruncated(reason),
334                         LPAREN,
335                         stringify(payloadA),
336                         COMMA,
337                         stringify(payloadB),
338                         RPAREN
339                     )
340                 )
341             );
342         }
343     }
344 
345     function that(
346         bool must,
347         bytes32 file,
348         bytes32 reason,
349         address payloadA
350     )
351     internal
352     pure
353     {
354         if (!must) {
355             revert(
356                 string(
357                     abi.encodePacked(
358                         stringifyTruncated(file),
359                         COLON,
360                         stringifyTruncated(reason),
361                         LPAREN,
362                         stringify(payloadA),
363                         RPAREN
364                     )
365                 )
366             );
367         }
368     }
369 
370     function that(
371         bool must,
372         bytes32 file,
373         bytes32 reason,
374         address payloadA,
375         uint256 payloadB
376     )
377     internal
378     pure
379     {
380         if (!must) {
381             revert(
382                 string(
383                     abi.encodePacked(
384                         stringifyTruncated(file),
385                         COLON,
386                         stringifyTruncated(reason),
387                         LPAREN,
388                         stringify(payloadA),
389                         COMMA,
390                         stringify(payloadB),
391                         RPAREN
392                     )
393                 )
394             );
395         }
396     }
397 
398     function that(
399         bool must,
400         bytes32 file,
401         bytes32 reason,
402         address payloadA,
403         uint256 payloadB,
404         uint256 payloadC
405     )
406     internal
407     pure
408     {
409         if (!must) {
410             revert(
411                 string(
412                     abi.encodePacked(
413                         stringifyTruncated(file),
414                         COLON,
415                         stringifyTruncated(reason),
416                         LPAREN,
417                         stringify(payloadA),
418                         COMMA,
419                         stringify(payloadB),
420                         COMMA,
421                         stringify(payloadC),
422                         RPAREN
423                     )
424                 )
425             );
426         }
427     }
428 
429     function that(
430         bool must,
431         bytes32 file,
432         bytes32 reason,
433         bytes32 payloadA
434     )
435     internal
436     pure
437     {
438         if (!must) {
439             revert(
440                 string(
441                     abi.encodePacked(
442                         stringifyTruncated(file),
443                         COLON,
444                         stringifyTruncated(reason),
445                         LPAREN,
446                         stringify(payloadA),
447                         RPAREN
448                     )
449                 )
450             );
451         }
452     }
453 
454     function that(
455         bool must,
456         bytes32 file,
457         bytes32 reason,
458         bytes32 payloadA,
459         uint256 payloadB,
460         uint256 payloadC
461     )
462     internal
463     pure
464     {
465         if (!must) {
466             revert(
467                 string(
468                     abi.encodePacked(
469                         stringifyTruncated(file),
470                         COLON,
471                         stringifyTruncated(reason),
472                         LPAREN,
473                         stringify(payloadA),
474                         COMMA,
475                         stringify(payloadB),
476                         COMMA,
477                         stringify(payloadC),
478                         RPAREN
479                     )
480                 )
481             );
482         }
483     }
484 
485     // ============ Private Functions ============
486 
487     function stringifyTruncated(
488         bytes32 input
489     )
490     private
491     pure
492     returns (bytes memory)
493     {
494         // put the input bytes into the result
495         bytes memory result = abi.encodePacked(input);
496 
497         // determine the length of the input by finding the location of the last non-zero byte
498         for (uint256 i = 32; i > 0; ) {
499             // reverse-for-loops with unsigned integer
500             /* solium-disable-next-line security/no-modify-for-iter-var */
501             i--;
502 
503             // find the last non-zero byte in order to determine the length
504             if (result[i] != 0) {
505                 uint256 length = i + 1;
506 
507                 /* solium-disable-next-line security/no-inline-assembly */
508                 assembly {
509                     mstore(result, length) // r.length = length;
510                 }
511 
512                 return result;
513             }
514         }
515 
516         // all bytes are zero
517         return new bytes(0);
518     }
519 
520     function stringify(
521         uint256 input
522     )
523     private
524     pure
525     returns (bytes memory)
526     {
527         if (input == 0) {
528             return "0";
529         }
530 
531         // get the final string length
532         uint256 j = input;
533         uint256 length;
534         while (j != 0) {
535             length++;
536             j /= 10;
537         }
538 
539         // allocate the string
540         bytes memory bstr = new bytes(length);
541 
542         // populate the string starting with the least-significant character
543         j = input;
544         for (uint256 i = length; i > 0; ) {
545             // reverse-for-loops with unsigned integer
546             /* solium-disable-next-line security/no-modify-for-iter-var */
547             i--;
548 
549             // take last decimal digit
550             bstr[i] = byte(uint8(ASCII_ZERO + (j % 10)));
551 
552             // remove the last decimal digit
553             j /= 10;
554         }
555 
556         return bstr;
557     }
558 
559     function stringify(
560         address input
561     )
562     private
563     pure
564     returns (bytes memory)
565     {
566         uint256 z = uint256(input);
567 
568         // addresses are "0x" followed by 20 bytes of data which take up 2 characters each
569         bytes memory result = new bytes(42);
570 
571         // populate the result with "0x"
572         result[0] = byte(uint8(ASCII_ZERO));
573         result[1] = byte(uint8(ASCII_LOWER_EX));
574 
575         // for each byte (starting from the lowest byte), populate the result with two characters
576         for (uint256 i = 0; i < 20; i++) {
577             // each byte takes two characters
578             uint256 shift = i * 2;
579 
580             // populate the least-significant character
581             result[41 - shift] = char(z & FOUR_BIT_MASK);
582             z = z >> 4;
583 
584             // populate the most-significant character
585             result[40 - shift] = char(z & FOUR_BIT_MASK);
586             z = z >> 4;
587         }
588 
589         return result;
590     }
591 
592     function stringify(
593         bytes32 input
594     )
595     private
596     pure
597     returns (bytes memory)
598     {
599         uint256 z = uint256(input);
600 
601         // bytes32 are "0x" followed by 32 bytes of data which take up 2 characters each
602         bytes memory result = new bytes(66);
603 
604         // populate the result with "0x"
605         result[0] = byte(uint8(ASCII_ZERO));
606         result[1] = byte(uint8(ASCII_LOWER_EX));
607 
608         // for each byte (starting from the lowest byte), populate the result with two characters
609         for (uint256 i = 0; i < 32; i++) {
610             // each byte takes two characters
611             uint256 shift = i * 2;
612 
613             // populate the least-significant character
614             result[65 - shift] = char(z & FOUR_BIT_MASK);
615             z = z >> 4;
616 
617             // populate the most-significant character
618             result[64 - shift] = char(z & FOUR_BIT_MASK);
619             z = z >> 4;
620         }
621 
622         return result;
623     }
624 
625     function char(
626         uint256 input
627     )
628     private
629     pure
630     returns (byte)
631     {
632         // return ASCII digit (0-9)
633         if (input < 10) {
634             return byte(uint8(input + ASCII_ZERO));
635         }
636 
637         // return ASCII letter (a-f)
638         return byte(uint8(input + ASCII_RELATIVE_ZERO));
639     }
640 }
641 
642 /*
643     Copyright 2019 dYdX Trading Inc.
644     Copyright 2020 VTD team, based on the works of Dynamic Dollar Devs and Empty Set Squad
645 
646     Licensed under the Apache License, Version 2.0 (the "License");
647     you may not use this file except in compliance with the License.
648     You may obtain a copy of the License at
649 
650     http://www.apache.org/licenses/LICENSE-2.0
651 
652     Unless required by applicable law or agreed to in writing, software
653     distributed under the License is distributed on an "AS IS" BASIS,
654     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
655     See the License for the specific language governing permissions and
656     limitations under the License.
657 */
658 /**
659  * @title Decimal
660  * @author dYdX
661  *
662  * Library that defines a fixed-point number with 18 decimal places.
663  */
664 library Decimal {
665     using SafeMath for uint256;
666 
667     // ============ Constants ============
668 
669     uint256 constant BASE = 10**18;
670 
671     // ============ Structs ============
672 
673 
674     struct D256 {
675         uint256 value;
676     }
677 
678     // ============ Static Functions ============
679 
680     function zero()
681     internal
682     pure
683     returns (D256 memory)
684     {
685         return D256({ value: 0 });
686     }
687 
688     function one()
689     internal
690     pure
691     returns (D256 memory)
692     {
693         return D256({ value: BASE });
694     }
695 
696     function from(
697         uint256 a
698     )
699     internal
700     pure
701     returns (D256 memory)
702     {
703         return D256({ value: a.mul(BASE) });
704     }
705 
706     function ratio(
707         uint256 a,
708         uint256 b
709     )
710     internal
711     pure
712     returns (D256 memory)
713     {
714         return D256({ value: getPartial(a, BASE, b) });
715     }
716 
717     // ============ Self Functions ============
718 
719     function add(
720         D256 memory self,
721         uint256 b
722     )
723     internal
724     pure
725     returns (D256 memory)
726     {
727         return D256({ value: self.value.add(b.mul(BASE)) });
728     }
729 
730     function sub(
731         D256 memory self,
732         uint256 b
733     )
734     internal
735     pure
736     returns (D256 memory)
737     {
738         return D256({ value: self.value.sub(b.mul(BASE)) });
739     }
740 
741     function sub(
742         D256 memory self,
743         uint256 b,
744         string memory reason
745     )
746     internal
747     pure
748     returns (D256 memory)
749     {
750         return D256({ value: self.value.sub(b.mul(BASE), reason) });
751     }
752 
753     function mul(
754         D256 memory self,
755         uint256 b
756     )
757     internal
758     pure
759     returns (D256 memory)
760     {
761         return D256({ value: self.value.mul(b) });
762     }
763 
764     function div(
765         D256 memory self,
766         uint256 b
767     )
768     internal
769     pure
770     returns (D256 memory)
771     {
772         return D256({ value: self.value.div(b) });
773     }
774 
775     function pow(
776         D256 memory self,
777         uint256 b
778     )
779     internal
780     pure
781     returns (D256 memory)
782     {
783         if (b == 0) {
784             return from(1);
785         }
786 
787         D256 memory temp = D256({ value: self.value });
788         for (uint256 i = 1; i < b; i++) {
789             temp = mul(temp, self);
790         }
791 
792         return temp;
793     }
794 
795     function add(
796         D256 memory self,
797         D256 memory b
798     )
799     internal
800     pure
801     returns (D256 memory)
802     {
803         return D256({ value: self.value.add(b.value) });
804     }
805 
806     function sub(
807         D256 memory self,
808         D256 memory b
809     )
810     internal
811     pure
812     returns (D256 memory)
813     {
814         return D256({ value: self.value.sub(b.value) });
815     }
816 
817     function sub(
818         D256 memory self,
819         D256 memory b,
820         string memory reason
821     )
822     internal
823     pure
824     returns (D256 memory)
825     {
826         return D256({ value: self.value.sub(b.value, reason) });
827     }
828 
829     function mul(
830         D256 memory self,
831         D256 memory b
832     )
833     internal
834     pure
835     returns (D256 memory)
836     {
837         return D256({ value: getPartial(self.value, b.value, BASE) });
838     }
839 
840     function div(
841         D256 memory self,
842         D256 memory b
843     )
844     internal
845     pure
846     returns (D256 memory)
847     {
848         return D256({ value: getPartial(self.value, BASE, b.value) });
849     }
850 
851     function equals(D256 memory self, D256 memory b) internal pure returns (bool) {
852         return self.value == b.value;
853     }
854 
855     function greaterThan(D256 memory self, D256 memory b) internal pure returns (bool) {
856         return compareTo(self, b) == 2;
857     }
858 
859     function lessThan(D256 memory self, D256 memory b) internal pure returns (bool) {
860         return compareTo(self, b) == 0;
861     }
862 
863     function greaterThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
864         return compareTo(self, b) > 0;
865     }
866 
867     function lessThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
868         return compareTo(self, b) < 2;
869     }
870 
871     function isZero(D256 memory self) internal pure returns (bool) {
872         return self.value == 0;
873     }
874 
875     function asUint256(D256 memory self) internal pure returns (uint256) {
876         return self.value.div(BASE);
877     }
878 
879     // ============ Core Methods ============
880 
881     function getPartial(
882         uint256 target,
883         uint256 numerator,
884         uint256 denominator
885     )
886     private
887     pure
888     returns (uint256)
889     {
890         return target.mul(numerator).div(denominator);
891     }
892 
893     function compareTo(
894         D256 memory a,
895         D256 memory b
896     )
897     private
898     pure
899     returns (uint256)
900     {
901         if (a.value == b.value) {
902             return 1;
903         }
904         return a.value > b.value ? 2 : 0;
905     }
906 }
907 
908 /*
909     Copyright 2020 VTD team, based on the works of Dynamic Dollar Devs and Empty Set Squad
910 
911     Licensed under the Apache License, Version 2.0 (the "License");
912     you may not use this file except in compliance with the License.
913     You may obtain a copy of the License at
914 
915     http://www.apache.org/licenses/LICENSE-2.0
916 
917     Unless required by applicable law or agreed to in writing, software
918     distributed under the License is distributed on an "AS IS" BASIS,
919     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
920     See the License for the specific language governing permissions and
921     limitations under the License.
922 */
923 contract IOracle {
924     function setup() public;
925     function capture() public returns (Decimal.D256 memory, bool);
926     function pair() external view returns (address);
927     function getLastVtdReserve() public view returns (uint256); 
928     function getLastPrice() public view returns (Decimal.D256 memory, bool);
929 }
930 
931 /*
932     Copyright 2020 VTD team, based on the works of Dynamic Dollar Devs and Empty Set Squad
933 
934     Licensed under the Apache License, Version 2.0 (the "License");
935     you may not use this file except in compliance with the License.
936     You may obtain a copy of the License at
937 
938     http://www.apache.org/licenses/LICENSE-2.0
939 
940     Unless required by applicable law or agreed to in writing, software
941     distributed under the License is distributed on an "AS IS" BASIS,
942     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
943     See the License for the specific language governing permissions and
944     limitations under the License.
945 */
946 library Constants {
947     /* Chain */
948     uint256 private constant CHAIN_ID = 1; // Mainnet
949 
950     /* Bootstrapping */
951     uint256 private constant BOOTSTRAPPING_PERIOD = 36; // 36 epochs IMPORTANT
952     uint256 private constant BOOTSTRAPPING_PERIOD_PHASE1 = 0; // set to 0
953     uint256 private constant BOOTSTRAPPING_PRICE = 196e16; // 1.96 pegged token (targeting 8% inflation)
954 
955     /* Oracle */
956     //IMPORTANT 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48 deprecated
957     address private constant USDC = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48); 
958     uint256 private constant ORACLE_RESERVE_MINIMUM = 1e9; // 1,000 pegged token, 1e9 IMPORTANT
959 
960     /* Bonding */
961     uint256 private constant INITIAL_STAKE_MULTIPLE = 1e6; // 100 VTD -> 100M VTDD
962 
963     /* Epoch */
964     uint256 private constant EPOCH_START = 1609405200;
965     uint256 private constant EPOCH_BASE = 7200; //two hours IMPORTANT
966     uint256 private constant EPOCH_GROWTH_CONSTANT = 12000; //1 hour
967     uint256 private constant P1_EPOCH_BASE = 300; // IMPORTANT
968     uint256 private constant P1_EPOCH_GROWTH_CONSTANT = 12000; // IMPORTANT 12000
969     uint256 private constant ADVANCE_LOTTERY_TIME = 91; // deprecated
970 
971     /* Governance */
972     uint256 private constant GOVERNANCE_PERIOD = 8; // 1 dayish governance period IMPORTANT
973     uint256 private constant GOVERNANCE_QUORUM = 20e16; // 20%
974     uint256 private constant GOVERNANCE_SUPER_MAJORITY = 51e16; // 51%
975     uint256 private constant GOVERNANCE_FASTTRACK_PERIOD = 3; // 3 epochs
976     uint256 private constant GOVERNANCE_EMERGENCY_DELAY = 14400; // 4 hours in case multi-lp has a critical bug
977 
978     /* DAO */
979     uint256 private constant ADVANCE_INCENTIVE = 50e18; // 50 VTD IMPORTANT
980     uint256 private constant ADVANCE_INCENTIVE_BOOTSTRAP = 50e18; // 50 VTD deprecated
981     uint256 private constant DAO_EXIT_LOCKUP_EPOCHS = 18; // 18 epoch fluid IMPORTANT
982 
983     /* Pool */
984     uint256 private constant POOL_EXIT_LOCKUP_EPOCHS = 9; // 9 epoch fluid IMPORTANT
985 
986     /* Market */
987     uint256 private constant COUPON_EXPIRATION = 180; //30 days
988     uint256 private constant DEBT_RATIO_CAP = 35e16; // 35%
989     uint256 private constant INITIAL_COUPON_REDEMPTION_PENALTY = 50e16; // 50%
990     uint256 private constant COUPON_REDEMPTION_PENALTY_DECAY = 3600; // 1 hour
991 
992     /* Regulator */
993     uint256 private constant SUPPLY_CHANGE_LIMIT = 10e16; // 10%
994     uint256 private constant EPOCH_GROWTH_BETA = 90e16; // 90%
995     uint256 private constant ORACLE_POOL_RATIO = 40; // 40% IMPORTANT Increased to 40% for 2 pools
996 
997     // Pegs
998     uint256 private constant USDC_START = 240;
999     uint256 private constant USDT_START = 120;
1000     uint256 private constant WBTC_START = 180;
1001 
1002     // IMPORTANT, double check addresses
1003     address private constant USDC_POOL = address(0xBD2F0Cd039E0BFcf88901C98c0bFAc5ab27566e3);
1004     address private constant USDT_POOL = address(0x6950929E1379E64DE376e56068103d145B81dC6A); 
1005     address private constant WETH_POOL = address(0x7a6fbec053D5475B2eb732239F794131cBFc172B); 
1006     address private constant WBTC_POOL = address(0x7023A104906Fc120b662ADE8Aeede41ba57F59e7); 
1007     address private constant DSD_POOL = address(0x623EA23a36bF98a065701B08Be1Ad17246d0E337);
1008 
1009     address private constant USDC_ORACLE = address(0xd51efebF258e2119Cc8a71A1c4406ec5BFD608Bc);
1010     address private constant USDT_ORACLE = address(0x16148886CEFF9baD1042a59Cd3E85Ac66f54D639); 
1011     address private constant WETH_ORACLE = address(0x7a6fbec053D5475B2eb732239F794131cBFc172B); 
1012     address private constant WBTC_ORACLE = address(0x7023A104906Fc120b662ADE8Aeede41ba57F59e7); 
1013     address private constant DSD_ORACLE = address(0x368897f053e9838db281751B722e7F6969802B31);
1014 
1015     /**
1016      * Getters
1017      */
1018     function getEpochStart() internal pure returns (uint256) {
1019         return EPOCH_START;
1020     }
1021 
1022     function getP1EpochBase() internal pure returns (uint256) {
1023         return P1_EPOCH_BASE;
1024     }
1025 
1026     function getP1EpochGrowthConstant() internal pure returns (uint256) {
1027         return P1_EPOCH_GROWTH_CONSTANT;
1028     }
1029 
1030     function getEpochBase() internal pure returns (uint256) {
1031         return EPOCH_BASE;
1032     }
1033 
1034     function getEpochGrowthConstant() internal pure returns (uint256) {
1035         return EPOCH_GROWTH_CONSTANT;
1036     }
1037 
1038     function getOracleReserveMinimum() internal pure returns (uint256) {
1039         return ORACLE_RESERVE_MINIMUM;
1040     }
1041 
1042     function getInitialStakeMultiple() internal pure returns (uint256) {
1043         return INITIAL_STAKE_MULTIPLE;
1044     }
1045 
1046     function getAdvanceLotteryTime() internal pure returns (uint256){
1047         return ADVANCE_LOTTERY_TIME;
1048     }
1049 
1050     function getBootstrappingPeriod() internal pure returns (uint256) {
1051         return BOOTSTRAPPING_PERIOD;
1052     }
1053 
1054     function getPhaseOnePeriod() internal pure returns (uint256) {
1055         return BOOTSTRAPPING_PERIOD_PHASE1;
1056     }
1057 
1058     function getBootstrappingPrice() internal pure returns (Decimal.D256 memory) {
1059         return Decimal.D256({value: BOOTSTRAPPING_PRICE});
1060     }
1061 
1062     function getGovernancePeriod() internal pure returns (uint256) {
1063         return GOVERNANCE_PERIOD;
1064     }
1065 
1066      function getFastTrackPeriod() internal pure returns (uint256) {
1067         return GOVERNANCE_FASTTRACK_PERIOD;
1068     }
1069 
1070     function getGovernanceQuorum() internal pure returns (Decimal.D256 memory) {
1071         return Decimal.D256({value: GOVERNANCE_QUORUM});
1072     }
1073 
1074     function getGovernanceSuperMajority() internal pure returns (Decimal.D256 memory) {
1075         return Decimal.D256({value: GOVERNANCE_SUPER_MAJORITY});
1076     }
1077 
1078     function getGovernanceEmergencyDelay() internal pure returns (uint256) {
1079         return GOVERNANCE_EMERGENCY_DELAY;
1080     }
1081 
1082     function getAdvanceIncentive() internal pure returns (uint256) {
1083         return ADVANCE_INCENTIVE;
1084     }
1085 
1086     function getAdvanceIncentiveBootstrap() internal pure returns (uint256) {
1087         return ADVANCE_INCENTIVE_BOOTSTRAP;
1088     }
1089 
1090     function getDAOExitLockupEpochs() internal pure returns (uint256) {
1091         return DAO_EXIT_LOCKUP_EPOCHS;
1092     }
1093 
1094     function getPoolExitLockupEpochs() internal pure returns (uint256) {
1095         return POOL_EXIT_LOCKUP_EPOCHS;
1096     }
1097 
1098     function getCouponExpiration() internal pure returns (uint256) {
1099         return COUPON_EXPIRATION;
1100     }
1101 
1102     function getDebtRatioCap() internal pure returns (Decimal.D256 memory) {
1103         return Decimal.D256({value: DEBT_RATIO_CAP});
1104     }
1105     
1106     function getInitialCouponRedemptionPenalty() internal pure returns (Decimal.D256 memory) {
1107         return Decimal.D256({value: INITIAL_COUPON_REDEMPTION_PENALTY});
1108     }
1109 
1110     function getCouponRedemptionPenaltyDecay() internal pure returns (uint256) {
1111         return COUPON_REDEMPTION_PENALTY_DECAY;
1112     }
1113 
1114     function getSupplyChangeLimit() internal pure returns (Decimal.D256 memory) {
1115         return Decimal.D256({value: SUPPLY_CHANGE_LIMIT});
1116     }
1117 
1118     function getEpochGrowthBeta() internal pure returns (Decimal.D256 memory) {
1119         return Decimal.D256({value: EPOCH_GROWTH_BETA});
1120     }
1121 
1122     function getOraclePoolRatio() internal pure returns (uint256) {
1123         return ORACLE_POOL_RATIO;
1124     }
1125 
1126     function getChainId() internal pure returns (uint256) {
1127         return CHAIN_ID;
1128     }
1129 
1130     function getWbtcStart() internal pure returns (uint256) {
1131         return WBTC_START;
1132     }
1133 
1134     function getUsdtStart() internal pure returns (uint256) {
1135         return USDT_START;
1136     }
1137 
1138     function getUsdcStart() internal pure returns (uint256) {
1139         return USDC_START;
1140     }
1141 
1142 // pools
1143     function getUsdcPool() internal pure returns (address) {
1144         return USDC_POOL;
1145     }
1146 
1147     function getUsdtPool() internal pure returns (address) {
1148         return USDT_POOL;
1149     }
1150 
1151     function getEthPool() internal pure returns (address) {
1152         return WETH_POOL;
1153     }
1154 
1155     function getWbtcPool() internal pure returns (address) {
1156         return WBTC_POOL;
1157     }
1158 
1159     function getDsdPool() internal pure returns (address) {
1160         return DSD_POOL;
1161     }
1162 
1163 // oracles
1164     function getUsdcOracle() internal pure returns (IOracle) {
1165         return IOracle(USDC_ORACLE);
1166     }
1167 
1168     function getUsdtOracle() internal pure returns (IOracle) {
1169         return IOracle(USDT_ORACLE);
1170     }
1171 
1172     function getEthOracle() internal pure returns (IOracle) {
1173         return IOracle(WETH_ORACLE);
1174     }
1175 
1176     function getWbtcOracle() internal pure returns (IOracle) {
1177         return IOracle(WBTC_ORACLE);
1178     }
1179 
1180     function getDsdOracle() internal pure returns (IOracle) {
1181         return IOracle(DSD_ORACLE);
1182     }
1183 }
1184 
1185 /*
1186     Copyright 2020 VTD team, based on the works of Dynamic Dollar Devs and Empty Set Squad
1187 
1188     Licensed under the Apache License, Version 2.0 (the "License");
1189     you may not use this file except in compliance with the License.
1190     You may obtain a copy of the License at
1191 
1192     http://www.apache.org/licenses/LICENSE-2.0
1193 
1194     Unless required by applicable law or agreed to in writing, software
1195     distributed under the License is distributed on an "AS IS" BASIS,
1196     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1197     See the License for the specific language governing permissions and
1198     limitations under the License.
1199 */
1200 contract IDollar is IERC20 {
1201     function burn(uint256 amount) public;
1202     function burnFrom(address account, uint256 amount) public;
1203     function mint(address account, uint256 amount) public returns (bool);
1204 }
1205 
1206 /*
1207     Copyright 2020 VTD team, based on the works of Dynamic Dollar Devs and Empty Set Squad
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
1221 contract IDAO {
1222     function epoch() external view returns (uint256);
1223 }
1224 
1225 /*
1226     Copyright 2020 VTD team, based on the works of Dynamic Dollar Devs and Empty Set Squad
1227 
1228     Licensed under the Apache License, Version 2.0 (the "License");
1229     you may not use this file except in compliance with the License.
1230     You may obtain a copy of the License at
1231 
1232     http://www.apache.org/licenses/LICENSE-2.0
1233 
1234     Unless required by applicable law or agreed to in writing, software
1235     distributed under the License is distributed on an "AS IS" BASIS,
1236     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1237     See the License for the specific language governing permissions and
1238     limitations under the License.
1239 */
1240 contract IUSDC {
1241     // function isBlacklisted(address _account) external view returns (bool);
1242 }
1243 
1244 /*
1245     Copyright 2020 VTD team, based on the works of Dynamic Dollar Devs and Empty Set Squad
1246 
1247     Licensed under the Apache License, Version 2.0 (the "License");
1248     you may not use this file except in compliance with the License.
1249     You may obtain a copy of the License at
1250 
1251     http://www.apache.org/licenses/LICENSE-2.0
1252 
1253     Unless required by applicable law or agreed to in writing, software
1254     distributed under the License is distributed on an "AS IS" BASIS,
1255     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1256     See the License for the specific language governing permissions and
1257     limitations under the License.
1258 */
1259 contract PoolAccount {
1260     enum Status {
1261         Frozen,
1262         Fluid,
1263         Locked
1264     }
1265 
1266     struct State {
1267         uint256 staged;
1268         uint256 claimable;
1269         uint256 bonded;
1270         uint256 phantom;
1271         uint256 fluidUntil;
1272     }
1273 }
1274 
1275 contract PoolStorage {
1276     struct Provider {
1277         IDAO dao;
1278         IDollar dollar;
1279         IERC20 univ2;
1280         address peggedToken;
1281     }
1282     
1283     struct Balance {
1284         uint256 staged;
1285         uint256 claimable;
1286         uint256 bonded;
1287         uint256 phantom;
1288     }
1289 
1290     struct State {
1291         Balance balance;
1292         Provider provider;
1293 
1294         bool paused;
1295 
1296         mapping(address => PoolAccount.State) accounts;
1297     }
1298 }
1299 
1300 contract PoolState {
1301     PoolStorage.State _state;
1302 }
1303 
1304 /*
1305     Copyright 2020 VTD team, based on the works of Dynamic Dollar Devs and Empty Set Squad
1306 
1307     Licensed under the Apache License, Version 2.0 (the "License");
1308     you may not use this file except in compliance with the License.
1309     You may obtain a copy of the License at
1310 
1311     http://www.apache.org/licenses/LICENSE-2.0
1312 
1313     Unless required by applicable law or agreed to in writing, software
1314     distributed under the License is distributed on an "AS IS" BASIS,
1315     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1316     See the License for the specific language governing permissions and
1317     limitations under the License.
1318 */
1319 contract PoolGetters is PoolState {
1320     using SafeMath for uint256;
1321 
1322     /**
1323      * Global
1324      */
1325     function peggedToken() public view returns (address) {
1326         return _state.provider.peggedToken;
1327     }
1328 
1329     function dao() public view returns (IDAO) {
1330         return _state.provider.dao;
1331     }
1332 
1333     function dollar() public view returns (IDollar) {
1334         return _state.provider.dollar;
1335     }
1336 
1337     function univ2() public view returns (IERC20) {
1338         return _state.provider.univ2;
1339     }
1340 
1341     function totalBonded() public view returns (uint256) {
1342         return _state.balance.bonded;
1343     }
1344 
1345     function totalStaged() public view returns (uint256) {
1346         return _state.balance.staged;
1347     }
1348 
1349     function totalClaimable() public view returns (uint256) {
1350         return _state.balance.claimable;
1351     }
1352 
1353     function totalPhantom() public view returns (uint256) {
1354         return _state.balance.phantom;
1355     }
1356 
1357     function totalRewarded() public view returns (uint256) {
1358         return dollar().balanceOf(address(this)).sub(totalClaimable());
1359     }
1360 
1361     function paused() public view returns (bool) {
1362         return _state.paused;
1363     }
1364 
1365     /**
1366      * Account
1367      */
1368 
1369     function balanceOfStaged(address account) public view returns (uint256) {
1370         return _state.accounts[account].staged;
1371     }
1372 
1373     function balanceOfClaimable(address account) public view returns (uint256) {
1374         return _state.accounts[account].claimable;
1375     }
1376 
1377     function balanceOfBonded(address account) public view returns (uint256) {
1378         return _state.accounts[account].bonded;
1379     }
1380 
1381     function balanceOfPhantom(address account) public view returns (uint256) {
1382         return _state.accounts[account].phantom;
1383     }
1384 
1385     function balanceOfRewarded(address account) public view returns (uint256) {
1386         uint256 totalBonded = totalBonded();
1387         if (totalBonded == 0) {
1388             return 0;
1389         }
1390 
1391         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom());
1392         uint256 balanceOfRewardedWithPhantom = totalRewardedWithPhantom
1393             .mul(balanceOfBonded(account))
1394             .div(totalBonded);
1395 
1396         uint256 balanceOfPhantom = balanceOfPhantom(account);
1397         if (balanceOfRewardedWithPhantom > balanceOfPhantom) {
1398             return balanceOfRewardedWithPhantom.sub(balanceOfPhantom);
1399         }
1400         return 0;
1401     }
1402 
1403     function fluidUntil(address account) public view returns (uint256) {
1404         return _state.accounts[account].fluidUntil;
1405     }
1406 
1407     function statusOf(address account) public view returns (PoolAccount.Status) {
1408         return epoch() >= _state.accounts[account].fluidUntil ?
1409             PoolAccount.Status.Frozen :
1410             PoolAccount.Status.Fluid;
1411     }
1412 
1413     /**
1414      * Epoch
1415      */
1416 
1417     function epoch() internal view returns (uint256) {
1418         return dao().epoch();
1419     }
1420 }
1421 
1422 /*
1423     Copyright 2020 VTD team, based on the works of Dynamic Dollar Devs and Empty Set Squad
1424 
1425     Licensed under the Apache License, Version 2.0 (the "License");
1426     you may not use this file except in compliance with the License.
1427     You may obtain a copy of the License at
1428 
1429     http://www.apache.org/licenses/LICENSE-2.0
1430 
1431     Unless required by applicable law or agreed to in writing, software
1432     distributed under the License is distributed on an "AS IS" BASIS,
1433     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1434     See the License for the specific language governing permissions and
1435     limitations under the License.
1436 */
1437 contract PoolSetters is PoolState, PoolGetters {
1438     using SafeMath for uint256;
1439 
1440     /**
1441      * Global
1442      */
1443 
1444     function pause() internal {
1445         _state.paused = true;
1446     }
1447 
1448     /**
1449      * Account
1450      */
1451 
1452     function incrementBalanceOfBonded(address account, uint256 amount) internal {
1453         _state.accounts[account].bonded = _state.accounts[account].bonded.add(amount);
1454         _state.balance.bonded = _state.balance.bonded.add(amount);
1455     }
1456 
1457     function decrementBalanceOfBonded(address account, uint256 amount, string memory reason) internal {
1458         _state.accounts[account].bonded = _state.accounts[account].bonded.sub(amount, reason);
1459         _state.balance.bonded = _state.balance.bonded.sub(amount, reason);
1460     }
1461 
1462     function incrementBalanceOfStaged(address account, uint256 amount) internal {
1463         _state.accounts[account].staged = _state.accounts[account].staged.add(amount);
1464         _state.balance.staged = _state.balance.staged.add(amount);
1465     }
1466 
1467     function decrementBalanceOfStaged(address account, uint256 amount, string memory reason) internal {
1468         _state.accounts[account].staged = _state.accounts[account].staged.sub(amount, reason);
1469         _state.balance.staged = _state.balance.staged.sub(amount, reason);
1470     }
1471 
1472     function incrementBalanceOfClaimable(address account, uint256 amount) internal {
1473         _state.accounts[account].claimable = _state.accounts[account].claimable.add(amount);
1474         _state.balance.claimable = _state.balance.claimable.add(amount);
1475     }
1476 
1477     function decrementBalanceOfClaimable(address account, uint256 amount, string memory reason) internal {
1478         _state.accounts[account].claimable = _state.accounts[account].claimable.sub(amount, reason);
1479         _state.balance.claimable = _state.balance.claimable.sub(amount, reason);
1480     }
1481 
1482     function incrementBalanceOfPhantom(address account, uint256 amount) internal {
1483         _state.accounts[account].phantom = _state.accounts[account].phantom.add(amount);
1484         _state.balance.phantom = _state.balance.phantom.add(amount);
1485     }
1486 
1487     function decrementBalanceOfPhantom(address account, uint256 amount, string memory reason) internal {
1488         _state.accounts[account].phantom = _state.accounts[account].phantom.sub(amount, reason);
1489         _state.balance.phantom = _state.balance.phantom.sub(amount, reason);
1490     }
1491 
1492     function unfreeze(address account) internal {
1493         _state.accounts[account].fluidUntil = epoch().add(Constants.getPoolExitLockupEpochs());
1494     }
1495 }
1496 
1497 interface IUniswapV2Pair {
1498     event Approval(address indexed owner, address indexed spender, uint value);
1499     event Transfer(address indexed from, address indexed to, uint value);
1500 
1501     function name() external pure returns (string memory);
1502     function symbol() external pure returns (string memory);
1503     function decimals() external pure returns (uint8);
1504     function totalSupply() external view returns (uint);
1505     function balanceOf(address owner) external view returns (uint);
1506     function allowance(address owner, address spender) external view returns (uint);
1507 
1508     function approve(address spender, uint value) external returns (bool);
1509     function transfer(address to, uint value) external returns (bool);
1510     function transferFrom(address from, address to, uint value) external returns (bool);
1511 
1512     function DOMAIN_SEPARATOR() external view returns (bytes32);
1513     function PERMIT_TYPEHASH() external pure returns (bytes32);
1514     function nonces(address owner) external view returns (uint);
1515 
1516     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1517 
1518     event Mint(address indexed sender, uint amount0, uint amount1);
1519     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1520     event Swap(
1521         address indexed sender,
1522         uint amount0In,
1523         uint amount1In,
1524         uint amount0Out,
1525         uint amount1Out,
1526         address indexed to
1527     );
1528     event Sync(uint112 reserve0, uint112 reserve1);
1529 
1530     function MINIMUM_LIQUIDITY() external pure returns (uint);
1531     function factory() external view returns (address);
1532     function token0() external view returns (address);
1533     function token1() external view returns (address);
1534     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1535     function price0CumulativeLast() external view returns (uint);
1536     function price1CumulativeLast() external view returns (uint);
1537     function kLast() external view returns (uint);
1538 
1539     function mint(address to) external returns (uint liquidity);
1540     function burn(address to) external returns (uint amount0, uint amount1);
1541     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1542     function skim(address to) external;
1543     function sync() external;
1544 
1545     function initialize(address, address) external;
1546 }
1547 
1548 library UniswapV2Library {
1549     using SafeMath for uint;
1550 
1551     // returns sorted token addresses, used to handle return values from pairs sorted in this order
1552     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
1553         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
1554         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
1555         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
1556     }
1557 
1558     // calculates the CREATE2 address for a pair without making any external calls
1559     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
1560         (address token0, address token1) = sortTokens(tokenA, tokenB);
1561         pair = address(uint(keccak256(abi.encodePacked(
1562                 hex'ff',
1563                 factory,
1564                 keccak256(abi.encodePacked(token0, token1)),
1565                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
1566             ))));
1567     }
1568 
1569     // fetches and sorts the reserves for a pair
1570     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
1571         (address token0,) = sortTokens(tokenA, tokenB);
1572         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
1573         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1574     }
1575 
1576     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
1577     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
1578         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
1579         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
1580         amountB = amountA.mul(reserveB) / reserveA;
1581     }
1582 }
1583 
1584 /*
1585     Copyright 2020 VTD team, based on the works of Dynamic Dollar Devs and Empty Set Squad
1586 
1587     Licensed under the Apache License, Version 2.0 (the "License");
1588     you may not use this file except in compliance with the License.
1589     You may obtain a copy of the License at
1590 
1591     http://www.apache.org/licenses/LICENSE-2.0
1592 
1593     Unless required by applicable law or agreed to in writing, software
1594     distributed under the License is distributed on an "AS IS" BASIS,
1595     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1596     See the License for the specific language governing permissions and
1597     limitations under the License.
1598 */
1599 contract Liquidity is PoolGetters {
1600     address private constant UNISWAP_FACTORY = address(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
1601 
1602     function addLiquidity(uint256 dollarAmount) internal returns (uint256, uint256) {
1603         (address dollar, address peggedToken) = (address(dollar()), peggedToken());
1604         (uint reserveA, uint reserveB) = getReserves(dollar, peggedToken);
1605 
1606         uint256 pegAmount = (reserveA == 0 && reserveB == 0) ?
1607              dollarAmount :
1608              UniswapV2Library.quote(dollarAmount, reserveA, reserveB);
1609 
1610         address pair = address(univ2());
1611         IERC20(dollar).transfer(pair, dollarAmount);
1612         IERC20(peggedToken).transferFrom(msg.sender, pair, pegAmount);
1613         return (pegAmount, IUniswapV2Pair(pair).mint(address(this)));
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
1624 /*
1625     Copyright 2020 VTD team, based on the works of Dynamic Dollar Devs and Empty Set Squad
1626 
1627     Licensed under the Apache License, Version 2.0 (the "License");
1628     you may not use this file except in compliance with the License.
1629     You may obtain a copy of the License at
1630 
1631     http://www.apache.org/licenses/LICENSE-2.0
1632 
1633     Unless required by applicable law or agreed to in writing, software
1634     distributed under the License is distributed on an "AS IS" BASIS,
1635     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1636     See the License for the specific language governing permissions and
1637     limitations under the License.
1638 */
1639 contract Pool is PoolSetters, Liquidity {
1640     using SafeMath for uint256;
1641 
1642     constructor(address dollar, address univ2, address peggedToken) public {
1643         // IMPORTANT only use msg.sender if deploying from the proxy factory
1644         // _state.provider.dao = IDAO(msg.sender);
1645         _state.provider.dao= IDAO(address(0x530608409991C36Ba922B69623BEc57e22B8d331));
1646         _state.provider.dollar = IDollar(dollar);
1647         _state.provider.univ2 = IERC20(univ2);
1648         _state.provider.peggedToken = peggedToken;
1649     }
1650 
1651     bytes32 private constant FILE = "Pool";
1652 
1653     event Deposit(address indexed account, uint256 value);
1654     event Withdraw(address indexed account, uint256 value);
1655     event Claim(address indexed account, uint256 value);
1656     event Bond(address indexed account, uint256 start, uint256 value);
1657     event Unbond(address indexed account, uint256 start, uint256 value, uint256 newClaimable);
1658     event Provide(address indexed account, uint256 value, uint256 lessUsdc, uint256 newUniv2);
1659 
1660     function deposit(uint256 value) external onlyFrozen(msg.sender) notPaused {
1661         univ2().transferFrom(msg.sender, address(this), value);
1662         incrementBalanceOfStaged(msg.sender, value);
1663 
1664         balanceCheck();
1665 
1666         emit Deposit(msg.sender, value);
1667     }
1668 
1669     function withdraw(uint256 value) external onlyFrozen(msg.sender) {
1670         univ2().transfer(msg.sender, value);
1671         decrementBalanceOfStaged(msg.sender, value, "Pool: insufficient staged balance");
1672 
1673         balanceCheck();
1674 
1675         emit Withdraw(msg.sender, value);
1676     }
1677 
1678     function claim(uint256 value) external onlyFrozen(msg.sender) {
1679         dollar().transfer(msg.sender, value);
1680         decrementBalanceOfClaimable(msg.sender, value, "Pool: insufficient claimable balance");
1681 
1682         balanceCheck();
1683 
1684         emit Claim(msg.sender, value);
1685     }
1686 
1687     function bond(uint256 value) external notPaused {
1688         unfreeze(msg.sender);
1689 
1690         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom());
1691         uint256 newPhantom = totalBonded() == 0 ?
1692             totalRewarded() == 0 ? Constants.getInitialStakeMultiple().mul(value) : 0 :
1693             totalRewardedWithPhantom.mul(value).div(totalBonded());
1694 
1695         incrementBalanceOfBonded(msg.sender, value);
1696         incrementBalanceOfPhantom(msg.sender, newPhantom);
1697         decrementBalanceOfStaged(msg.sender, value, "Pool: insufficient staged balance");
1698 
1699         balanceCheck();
1700 
1701         emit Bond(msg.sender, epoch().add(1), value);
1702     }
1703 
1704     function unbond(uint256 value) external {
1705         unfreeze(msg.sender);
1706 
1707         uint256 balanceOfBonded = balanceOfBonded(msg.sender);
1708         Require.that(
1709             balanceOfBonded > 0,
1710             FILE,
1711             "insufficient bonded balance"
1712         );
1713 
1714         uint256 newClaimable = balanceOfRewarded(msg.sender).mul(value).div(balanceOfBonded);
1715         uint256 lessPhantom = balanceOfPhantom(msg.sender).mul(value).div(balanceOfBonded);
1716 
1717         incrementBalanceOfStaged(msg.sender, value);
1718         incrementBalanceOfClaimable(msg.sender, newClaimable);
1719         decrementBalanceOfBonded(msg.sender, value, "Pool: insufficient bonded balance");
1720         decrementBalanceOfPhantom(msg.sender, lessPhantom, "Pool: insufficient phantom balance");
1721 
1722         balanceCheck();
1723 
1724         emit Unbond(msg.sender, epoch().add(1), value, newClaimable);
1725     }
1726 
1727     function provide(uint256 value) external onlyFrozen(msg.sender) notPaused {
1728         Require.that(
1729             totalBonded() > 0,
1730             FILE,
1731             "insufficient total bonded"
1732         );
1733 
1734         Require.that(
1735             totalRewarded() > 0,
1736             FILE,
1737             "insufficient total rewarded"
1738         );
1739 
1740         Require.that(
1741             balanceOfRewarded(msg.sender) >= value,
1742             FILE,
1743             "insufficient rewarded balance"
1744         );
1745 
1746         (uint256 lessUsdc, uint256 newUniv2) = addLiquidity(value);
1747 
1748         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom()).add(value);
1749         uint256 newPhantomFromBonded = totalRewardedWithPhantom.mul(newUniv2).div(totalBonded());
1750 
1751         incrementBalanceOfBonded(msg.sender, newUniv2);
1752         incrementBalanceOfPhantom(msg.sender, value.add(newPhantomFromBonded));
1753 
1754 
1755         balanceCheck();
1756 
1757         emit Provide(msg.sender, value, lessUsdc, newUniv2);
1758     }
1759 
1760     function emergencyWithdraw(address token, uint256 value) external onlyDao {
1761         IERC20(token).transfer(address(dao()), value);
1762     }
1763 
1764     function emergencyPause() external onlyDao {
1765         pause();
1766     }
1767 
1768     function balanceCheck() private {
1769         Require.that(
1770             univ2().balanceOf(address(this)) >= totalStaged().add(totalBonded()),
1771             FILE,
1772             "Inconsistent UNI-V2 balances"
1773         );
1774     }
1775 
1776     modifier onlyFrozen(address account) {
1777         Require.that(
1778             statusOf(account) == PoolAccount.Status.Frozen,
1779             FILE,
1780             "Not frozen"
1781         );
1782 
1783         _;
1784     }
1785 
1786     modifier onlyDao() {
1787         Require.that(
1788             msg.sender == address(dao()),
1789             FILE,
1790             "Not dao"
1791         );
1792 
1793         _;
1794     }
1795 
1796     modifier notPaused() {
1797         Require.that(
1798             !paused(),
1799             FILE,
1800             "Paused"
1801         );
1802 
1803         _;
1804     }
1805 }