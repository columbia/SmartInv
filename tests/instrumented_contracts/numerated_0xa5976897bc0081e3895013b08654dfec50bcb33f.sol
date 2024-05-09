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
644     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
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
909     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
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
923 library Constants {
924     /* Chain */
925     uint256 private constant CHAIN_ID = 1; // Mainnet
926 
927     /* Bootstrapping */
928     uint256 private constant BOOTSTRAPPING_PERIOD = 90;
929     uint256 private constant BOOTSTRAPPING_PRICE = 11e17; // 1.10 USDC
930     uint256 private constant BOOTSTRAPPING_SPEEDUP_FACTOR = 3; // 30 days @ 8 hours
931 
932     /* Oracle */
933     address private constant USDC = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
934     uint256 private constant ORACLE_RESERVE_MINIMUM = 1e10; // 10,000 USDC
935 
936     /* Bonding */
937     uint256 private constant INITIAL_STAKE_MULTIPLE = 1e6; // 100 ESD -> 100M ESDS
938 
939     /* Epoch */
940     uint256 private constant EPOCH_PERIOD = 86400; // 1 day
941 
942     /* Governance */
943     uint256 private constant GOVERNANCE_PERIOD = 7;
944     uint256 private constant GOVERNANCE_QUORUM = 33e16; // 33%
945 
946     /* DAO */
947     uint256 private constant ADVANCE_INCENTIVE = 1e20; // 100 ESD
948 
949     /* Market */
950     uint256 private constant COUPON_EXPIRATION = 90;
951 
952     /* Regulator */
953     uint256 private constant SUPPLY_CHANGE_LIMIT = 1e17; // 10%
954     uint256 private constant ORACLE_POOL_RATIO = 20; // 20%
955 
956     /* Deployed */
957     address private constant DAO_ADDRESS = address(0x443D2f2755DB5942601fa062Cc248aAA153313D3);
958     address private constant DOLLAR_ADDRESS = address(0x36F3FD68E7325a35EB768F1AedaAe9EA0689d723);
959     address private constant PAIR_ADDRESS = address(0x88ff79eB2Bc5850F27315415da8685282C7610F9);
960 
961     /* Pool Migration */
962     address private constant LEGACY_POOL_ADDRESS = address(0xdF0Ae5504A48ab9f913F8490fBef1b9333A68e68);
963     uint256 private constant LEGACY_POOL_REWARD = 1e18; // 1 ESD
964 
965     /**
966      * Getters
967      */
968 
969     function getUsdcAddress() internal pure returns (address) {
970         return USDC;
971     }
972 
973     function getOracleReserveMinimum() internal pure returns (uint256) {
974         return ORACLE_RESERVE_MINIMUM;
975     }
976 
977     function getEpochPeriod() internal pure returns (uint256) {
978         return EPOCH_PERIOD;
979     }
980 
981     function getInitialStakeMultiple() internal pure returns (uint256) {
982         return INITIAL_STAKE_MULTIPLE;
983     }
984 
985     function getBootstrappingPeriod() internal pure returns (uint256) {
986         return BOOTSTRAPPING_PERIOD;
987     }
988 
989     function getBootstrappingPrice() internal pure returns (Decimal.D256 memory) {
990         return Decimal.D256({value: BOOTSTRAPPING_PRICE});
991     }
992 
993     function getBootstrappingSpeedupFactor() internal pure returns (uint256) {
994         return BOOTSTRAPPING_SPEEDUP_FACTOR;
995     }
996 
997     function getGovernancePeriod() internal pure returns (uint256) {
998         return GOVERNANCE_PERIOD;
999     }
1000 
1001     function getGovernanceQuorum() internal pure returns (Decimal.D256 memory) {
1002         return Decimal.D256({value: GOVERNANCE_QUORUM});
1003     }
1004 
1005     function getAdvanceIncentive() internal pure returns (uint256) {
1006         return ADVANCE_INCENTIVE;
1007     }
1008 
1009     function getCouponExpiration() internal pure returns (uint256) {
1010         return COUPON_EXPIRATION;
1011     }
1012 
1013     function getSupplyChangeLimit() internal pure returns (Decimal.D256 memory) {
1014         return Decimal.D256({value: SUPPLY_CHANGE_LIMIT});
1015     }
1016 
1017     function getOraclePoolRatio() internal pure returns (uint256) {
1018         return ORACLE_POOL_RATIO;
1019     }
1020 
1021     function getChainId() internal pure returns (uint256) {
1022         return CHAIN_ID;
1023     }
1024 
1025     function getDaoAddress() internal pure returns (address) {
1026         return DAO_ADDRESS;
1027     }
1028 
1029     function getDollarAddress() internal pure returns (address) {
1030         return DOLLAR_ADDRESS;
1031     }
1032 
1033     function getPairAddress() internal pure returns (address) {
1034         return PAIR_ADDRESS;
1035     }
1036 
1037     function getLegacyPoolAddress() internal pure returns (address) {
1038         return LEGACY_POOL_ADDRESS;
1039     }
1040 
1041     function getLegacyPoolReward() internal pure returns (uint256) {
1042         return LEGACY_POOL_REWARD;
1043     }
1044 }
1045 
1046 /*
1047     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
1048 
1049     Licensed under the Apache License, Version 2.0 (the "License");
1050     you may not use this file except in compliance with the License.
1051     You may obtain a copy of the License at
1052 
1053     http://www.apache.org/licenses/LICENSE-2.0
1054 
1055     Unless required by applicable law or agreed to in writing, software
1056     distributed under the License is distributed on an "AS IS" BASIS,
1057     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1058     See the License for the specific language governing permissions and
1059     limitations under the License.
1060 */
1061 contract IDollar is IERC20 {
1062     function burn(uint256 amount) public;
1063     function burnFrom(address account, uint256 amount) public;
1064     function mint(address account, uint256 amount) public returns (bool);
1065 }
1066 
1067 /*
1068     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
1069 
1070     Licensed under the Apache License, Version 2.0 (the "License");
1071     you may not use this file except in compliance with the License.
1072     You may obtain a copy of the License at
1073 
1074     http://www.apache.org/licenses/LICENSE-2.0
1075 
1076     Unless required by applicable law or agreed to in writing, software
1077     distributed under the License is distributed on an "AS IS" BASIS,
1078     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1079     See the License for the specific language governing permissions and
1080     limitations under the License.
1081 */
1082 contract IDAO {
1083     function epoch() external view returns (uint256);
1084 }
1085 
1086 /*
1087     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
1088 
1089     Licensed under the Apache License, Version 2.0 (the "License");
1090     you may not use this file except in compliance with the License.
1091     You may obtain a copy of the License at
1092 
1093     http://www.apache.org/licenses/LICENSE-2.0
1094 
1095     Unless required by applicable law or agreed to in writing, software
1096     distributed under the License is distributed on an "AS IS" BASIS,
1097     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1098     See the License for the specific language governing permissions and
1099     limitations under the License.
1100 */
1101 contract IUSDC {
1102     function isBlacklisted(address _account) external view returns (bool);
1103 }
1104 
1105 /*
1106     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
1107 
1108     Licensed under the Apache License, Version 2.0 (the "License");
1109     you may not use this file except in compliance with the License.
1110     You may obtain a copy of the License at
1111 
1112     http://www.apache.org/licenses/LICENSE-2.0
1113 
1114     Unless required by applicable law or agreed to in writing, software
1115     distributed under the License is distributed on an "AS IS" BASIS,
1116     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1117     See the License for the specific language governing permissions and
1118     limitations under the License.
1119 */
1120 contract PoolAccount {
1121     enum Status {
1122         Frozen,
1123         Fluid,
1124         Locked
1125     }
1126 
1127     struct State {
1128         uint256 staged;
1129         uint256 claimable;
1130         uint256 bonded;
1131         uint256 phantom;
1132         uint256 fluidUntil;
1133     }
1134 }
1135 
1136 contract PoolStorage {
1137     struct Balance {
1138         uint256 staged;
1139         uint256 claimable;
1140         uint256 bonded;
1141         uint256 phantom;
1142     }
1143 
1144     struct State {
1145         Balance balance;
1146         bool paused;
1147 
1148         mapping(address => PoolAccount.State) accounts;
1149     }
1150 }
1151 
1152 contract PoolState {
1153     PoolStorage.State _state;
1154 }
1155 
1156 /*
1157     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
1158 
1159     Licensed under the Apache License, Version 2.0 (the "License");
1160     you may not use this file except in compliance with the License.
1161     You may obtain a copy of the License at
1162 
1163     http://www.apache.org/licenses/LICENSE-2.0
1164 
1165     Unless required by applicable law or agreed to in writing, software
1166     distributed under the License is distributed on an "AS IS" BASIS,
1167     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1168     See the License for the specific language governing permissions and
1169     limitations under the License.
1170 */
1171 contract PoolGetters is PoolState {
1172     using SafeMath for uint256;
1173 
1174     /**
1175      * Global
1176      */
1177 
1178     function usdc() public view returns (address) {
1179         return Constants.getUsdcAddress();
1180     }
1181 
1182     function dao() public view returns (IDAO) {
1183         return IDAO(Constants.getDaoAddress());
1184     }
1185 
1186     function dollar() public view returns (IDollar) {
1187         return IDollar(Constants.getDollarAddress());
1188     }
1189 
1190     function univ2() public view returns (IERC20) {
1191         return IERC20(Constants.getPairAddress());
1192     }
1193 
1194     function totalBonded() public view returns (uint256) {
1195         return _state.balance.bonded;
1196     }
1197 
1198     function totalStaged() public view returns (uint256) {
1199         return _state.balance.staged;
1200     }
1201 
1202     function totalClaimable() public view returns (uint256) {
1203         return _state.balance.claimable;
1204     }
1205 
1206     function totalPhantom() public view returns (uint256) {
1207         return _state.balance.phantom;
1208     }
1209 
1210     function totalRewarded() public view returns (uint256) {
1211         return dollar().balanceOf(address(this)).sub(totalClaimable());
1212     }
1213 
1214     function paused() public view returns (bool) {
1215         return _state.paused;
1216     }
1217 
1218     /**
1219      * Account
1220      */
1221 
1222     function balanceOfStaged(address account) public view returns (uint256) {
1223         return _state.accounts[account].staged;
1224     }
1225 
1226     function balanceOfClaimable(address account) public view returns (uint256) {
1227         return _state.accounts[account].claimable;
1228     }
1229 
1230     function balanceOfBonded(address account) public view returns (uint256) {
1231         return _state.accounts[account].bonded;
1232     }
1233 
1234     function balanceOfPhantom(address account) public view returns (uint256) {
1235         return _state.accounts[account].phantom;
1236     }
1237 
1238     function balanceOfRewarded(address account) public view returns (uint256) {
1239         uint256 totalBonded = totalBonded();
1240         if (totalBonded == 0) {
1241             return 0;
1242         }
1243 
1244         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom());
1245         uint256 balanceOfRewardedWithPhantom = totalRewardedWithPhantom
1246             .mul(balanceOfBonded(account))
1247             .div(totalBonded);
1248 
1249         uint256 balanceOfPhantom = balanceOfPhantom(account);
1250         if (balanceOfRewardedWithPhantom > balanceOfPhantom) {
1251             return balanceOfRewardedWithPhantom.sub(balanceOfPhantom);
1252         }
1253         return 0;
1254     }
1255 
1256     function statusOf(address account) public view returns (PoolAccount.Status) {
1257         return epoch() >= _state.accounts[account].fluidUntil ?
1258             PoolAccount.Status.Frozen :
1259             PoolAccount.Status.Fluid;
1260     }
1261 
1262     /**
1263      * Epoch
1264      */
1265 
1266     function epoch() internal view returns (uint256) {
1267         return dao().epoch();
1268     }
1269 }
1270 
1271 /*
1272     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
1273 
1274     Licensed under the Apache License, Version 2.0 (the "License");
1275     you may not use this file except in compliance with the License.
1276     You may obtain a copy of the License at
1277 
1278     http://www.apache.org/licenses/LICENSE-2.0
1279 
1280     Unless required by applicable law or agreed to in writing, software
1281     distributed under the License is distributed on an "AS IS" BASIS,
1282     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1283     See the License for the specific language governing permissions and
1284     limitations under the License.
1285 */
1286 contract PoolSetters is PoolState, PoolGetters {
1287     using SafeMath for uint256;
1288 
1289     /**
1290      * Global
1291      */
1292 
1293     function pause() internal {
1294         _state.paused = true;
1295     }
1296 
1297     /**
1298      * Account
1299      */
1300 
1301     function incrementBalanceOfBonded(address account, uint256 amount) internal {
1302         _state.accounts[account].bonded = _state.accounts[account].bonded.add(amount);
1303         _state.balance.bonded = _state.balance.bonded.add(amount);
1304     }
1305 
1306     function decrementBalanceOfBonded(address account, uint256 amount, string memory reason) internal {
1307         _state.accounts[account].bonded = _state.accounts[account].bonded.sub(amount, reason);
1308         _state.balance.bonded = _state.balance.bonded.sub(amount, reason);
1309     }
1310 
1311     function incrementBalanceOfStaged(address account, uint256 amount) internal {
1312         _state.accounts[account].staged = _state.accounts[account].staged.add(amount);
1313         _state.balance.staged = _state.balance.staged.add(amount);
1314     }
1315 
1316     function decrementBalanceOfStaged(address account, uint256 amount, string memory reason) internal {
1317         _state.accounts[account].staged = _state.accounts[account].staged.sub(amount, reason);
1318         _state.balance.staged = _state.balance.staged.sub(amount, reason);
1319     }
1320 
1321     function incrementBalanceOfClaimable(address account, uint256 amount) internal {
1322         _state.accounts[account].claimable = _state.accounts[account].claimable.add(amount);
1323         _state.balance.claimable = _state.balance.claimable.add(amount);
1324     }
1325 
1326     function decrementBalanceOfClaimable(address account, uint256 amount, string memory reason) internal {
1327         _state.accounts[account].claimable = _state.accounts[account].claimable.sub(amount, reason);
1328         _state.balance.claimable = _state.balance.claimable.sub(amount, reason);
1329     }
1330 
1331     function incrementBalanceOfPhantom(address account, uint256 amount) internal {
1332         _state.accounts[account].phantom = _state.accounts[account].phantom.add(amount);
1333         _state.balance.phantom = _state.balance.phantom.add(amount);
1334     }
1335 
1336     function decrementBalanceOfPhantom(address account, uint256 amount, string memory reason) internal {
1337         _state.accounts[account].phantom = _state.accounts[account].phantom.sub(amount, reason);
1338         _state.balance.phantom = _state.balance.phantom.sub(amount, reason);
1339     }
1340 
1341     function unfreeze(address account) internal {
1342         _state.accounts[account].fluidUntil = epoch().add(1);
1343     }
1344 }
1345 
1346 interface IUniswapV2Pair {
1347     event Approval(address indexed owner, address indexed spender, uint value);
1348     event Transfer(address indexed from, address indexed to, uint value);
1349 
1350     function name() external pure returns (string memory);
1351     function symbol() external pure returns (string memory);
1352     function decimals() external pure returns (uint8);
1353     function totalSupply() external view returns (uint);
1354     function balanceOf(address owner) external view returns (uint);
1355     function allowance(address owner, address spender) external view returns (uint);
1356 
1357     function approve(address spender, uint value) external returns (bool);
1358     function transfer(address to, uint value) external returns (bool);
1359     function transferFrom(address from, address to, uint value) external returns (bool);
1360 
1361     function DOMAIN_SEPARATOR() external view returns (bytes32);
1362     function PERMIT_TYPEHASH() external pure returns (bytes32);
1363     function nonces(address owner) external view returns (uint);
1364 
1365     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1366 
1367     event Mint(address indexed sender, uint amount0, uint amount1);
1368     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1369     event Swap(
1370         address indexed sender,
1371         uint amount0In,
1372         uint amount1In,
1373         uint amount0Out,
1374         uint amount1Out,
1375         address indexed to
1376     );
1377     event Sync(uint112 reserve0, uint112 reserve1);
1378 
1379     function MINIMUM_LIQUIDITY() external pure returns (uint);
1380     function factory() external view returns (address);
1381     function token0() external view returns (address);
1382     function token1() external view returns (address);
1383     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1384     function price0CumulativeLast() external view returns (uint);
1385     function price1CumulativeLast() external view returns (uint);
1386     function kLast() external view returns (uint);
1387 
1388     function mint(address to) external returns (uint liquidity);
1389     function burn(address to) external returns (uint amount0, uint amount1);
1390     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1391     function skim(address to) external;
1392     function sync() external;
1393 
1394     function initialize(address, address) external;
1395 }
1396 
1397 library UniswapV2Library {
1398     using SafeMath for uint;
1399 
1400     // returns sorted token addresses, used to handle return values from pairs sorted in this order
1401     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
1402         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
1403         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
1404         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
1405     }
1406 
1407     // calculates the CREATE2 address for a pair without making any external calls
1408     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
1409         (address token0, address token1) = sortTokens(tokenA, tokenB);
1410         pair = address(uint(keccak256(abi.encodePacked(
1411                 hex'ff',
1412                 factory,
1413                 keccak256(abi.encodePacked(token0, token1)),
1414                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
1415             ))));
1416     }
1417 
1418     // fetches and sorts the reserves for a pair
1419     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
1420         (address token0,) = sortTokens(tokenA, tokenB);
1421         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
1422         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1423     }
1424 
1425     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
1426     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
1427         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
1428         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
1429         amountB = amountA.mul(reserveB) / reserveA;
1430     }
1431 }
1432 
1433 /*
1434     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
1435 
1436     Licensed under the Apache License, Version 2.0 (the "License");
1437     you may not use this file except in compliance with the License.
1438     You may obtain a copy of the License at
1439 
1440     http://www.apache.org/licenses/LICENSE-2.0
1441 
1442     Unless required by applicable law or agreed to in writing, software
1443     distributed under the License is distributed on an "AS IS" BASIS,
1444     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1445     See the License for the specific language governing permissions and
1446     limitations under the License.
1447 */
1448 contract Liquidity is PoolGetters {
1449     address private constant UNISWAP_FACTORY = address(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
1450 
1451     function addLiquidity(uint256 dollarAmount) internal returns (uint256, uint256) {
1452         (address dollar, address usdc) = (address(dollar()), usdc());
1453         (uint reserveA, uint reserveB) = getReserves(dollar, usdc);
1454 
1455         uint256 usdcAmount = (reserveA == 0 && reserveB == 0) ?
1456              dollarAmount :
1457              UniswapV2Library.quote(dollarAmount, reserveA, reserveB);
1458 
1459         address pair = address(univ2());
1460         IERC20(dollar).transfer(pair, dollarAmount);
1461         IERC20(usdc).transferFrom(msg.sender, pair, usdcAmount);
1462         return (usdcAmount, IUniswapV2Pair(pair).mint(address(this)));
1463     }
1464 
1465     // overridable for testing
1466     function getReserves(address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
1467         (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
1468         (uint reserve0, uint reserve1,) = IUniswapV2Pair(UniswapV2Library.pairFor(UNISWAP_FACTORY, tokenA, tokenB)).getReserves();
1469         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1470     }
1471 }
1472 
1473 /*
1474     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
1475 
1476     Licensed under the Apache License, Version 2.0 (the "License");
1477     you may not use this file except in compliance with the License.
1478     You may obtain a copy of the License at
1479 
1480     http://www.apache.org/licenses/LICENSE-2.0
1481 
1482     Unless required by applicable law or agreed to in writing, software
1483     distributed under the License is distributed on an "AS IS" BASIS,
1484     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1485     See the License for the specific language governing permissions and
1486     limitations under the License.
1487 */
1488 contract Pool is PoolSetters, Liquidity {
1489     using SafeMath for uint256;
1490 
1491     constructor() public { }
1492 
1493     bytes32 private constant FILE = "Pool";
1494 
1495     event Deposit(address indexed account, uint256 value);
1496     event Withdraw(address indexed account, uint256 value);
1497     event Claim(address indexed account, uint256 value);
1498     event Bond(address indexed account, uint256 start, uint256 value);
1499     event Unbond(address indexed account, uint256 start, uint256 value, uint256 newClaimable);
1500     event Provide(address indexed account, uint256 value, uint256 lessUsdc, uint256 newUniv2);
1501 
1502     function deposit(uint256 value) external onlyFrozen(msg.sender) notPaused {
1503         univ2().transferFrom(msg.sender, address(this), value);
1504         incrementBalanceOfStaged(msg.sender, value);
1505 
1506         balanceCheck();
1507 
1508         emit Deposit(msg.sender, value);
1509     }
1510 
1511     function withdraw(uint256 value) external onlyFrozen(msg.sender) {
1512         univ2().transfer(msg.sender, value);
1513         decrementBalanceOfStaged(msg.sender, value, "Pool: insufficient staged balance");
1514 
1515         balanceCheck();
1516 
1517         emit Withdraw(msg.sender, value);
1518     }
1519 
1520     function claim(uint256 value) external onlyFrozen(msg.sender) {
1521         dollar().transfer(msg.sender, value);
1522         decrementBalanceOfClaimable(msg.sender, value, "Pool: insufficient claimable balance");
1523 
1524         balanceCheck();
1525 
1526         emit Claim(msg.sender, value);
1527     }
1528 
1529     function bond(uint256 value) external notPaused {
1530         unfreeze(msg.sender);
1531 
1532         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom());
1533         uint256 newPhantom = totalBonded() == 0 ?
1534             totalRewarded() == 0 ? Constants.getInitialStakeMultiple().mul(value) : 0 :
1535             totalRewardedWithPhantom.mul(value).div(totalBonded());
1536 
1537         incrementBalanceOfBonded(msg.sender, value);
1538         incrementBalanceOfPhantom(msg.sender, newPhantom);
1539         decrementBalanceOfStaged(msg.sender, value, "Pool: insufficient staged balance");
1540 
1541         balanceCheck();
1542 
1543         emit Bond(msg.sender, epoch().add(1), value);
1544     }
1545 
1546     function unbond(uint256 value) external {
1547         unfreeze(msg.sender);
1548 
1549         uint256 balanceOfBonded = balanceOfBonded(msg.sender);
1550         Require.that(
1551             balanceOfBonded > 0,
1552             FILE,
1553             "insufficient bonded balance"
1554         );
1555 
1556         uint256 newClaimable = balanceOfRewarded(msg.sender).mul(value).div(balanceOfBonded);
1557         uint256 lessPhantom = balanceOfPhantom(msg.sender).mul(value).div(balanceOfBonded);
1558 
1559         incrementBalanceOfStaged(msg.sender, value);
1560         incrementBalanceOfClaimable(msg.sender, newClaimable);
1561         decrementBalanceOfBonded(msg.sender, value, "Pool: insufficient bonded balance");
1562         decrementBalanceOfPhantom(msg.sender, lessPhantom, "Pool: insufficient phantom balance");
1563 
1564         balanceCheck();
1565 
1566         emit Unbond(msg.sender, epoch().add(1), value, newClaimable);
1567     }
1568 
1569     function provide(uint256 value) external onlyFrozen(msg.sender) notPaused {
1570         Require.that(
1571             totalBonded() > 0,
1572             FILE,
1573             "insufficient total bonded"
1574         );
1575 
1576         Require.that(
1577             totalRewarded() > 0,
1578             FILE,
1579             "insufficient total rewarded"
1580         );
1581 
1582         Require.that(
1583             balanceOfRewarded(msg.sender) >= value,
1584             FILE,
1585             "insufficient rewarded balance"
1586         );
1587 
1588         (uint256 lessUsdc, uint256 newUniv2) = addLiquidity(value);
1589 
1590         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom()).add(value);
1591         uint256 newPhantomFromBonded = totalRewardedWithPhantom.mul(newUniv2).div(totalBonded());
1592 
1593         incrementBalanceOfBonded(msg.sender, newUniv2);
1594         incrementBalanceOfPhantom(msg.sender, value.add(newPhantomFromBonded));
1595 
1596 
1597         balanceCheck();
1598 
1599         emit Provide(msg.sender, value, lessUsdc, newUniv2);
1600     }
1601 
1602     function emergencyWithdraw(address token, uint256 value) external onlyDao {
1603         IERC20(token).transfer(address(dao()), value);
1604     }
1605 
1606     function emergencyPause() external onlyDao {
1607         pause();
1608     }
1609 
1610     function balanceCheck() private {
1611         Require.that(
1612             dollar().balanceOf(address(this)) == totalRewarded().add(totalClaimable()),
1613             FILE,
1614             "Inconsistent ESD balances"
1615         );
1616 
1617         Require.that(
1618             univ2().balanceOf(address(this)) == totalStaged().add(totalBonded()),
1619             FILE,
1620             "Inconsistent UNI-V2 balances"
1621         );
1622     }
1623 
1624     modifier onlyFrozen(address account) {
1625         Require.that(
1626             statusOf(account) == PoolAccount.Status.Frozen,
1627             FILE,
1628             "Not frozen"
1629         );
1630 
1631         _;
1632     }
1633 
1634     modifier onlyDao() {
1635         Require.that(
1636             msg.sender == address(dao()),
1637             FILE,
1638             "Not dao"
1639         );
1640 
1641         _;
1642     }
1643 
1644     modifier notPaused() {
1645         Require.that(
1646             !paused(),
1647             FILE,
1648             "Paused"
1649         );
1650 
1651         _;
1652     }
1653 }