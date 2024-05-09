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
940     struct EpochStrategy {
941         uint256 offset;
942         uint256 start;
943         uint256 period;
944     }
945 
946     uint256 private constant PREVIOUS_EPOCH_OFFSET = 91;
947     uint256 private constant PREVIOUS_EPOCH_START = 1600905600;
948     uint256 private constant PREVIOUS_EPOCH_PERIOD = 86400;
949 
950     uint256 private constant CURRENT_EPOCH_OFFSET = 106;
951     uint256 private constant CURRENT_EPOCH_START = 1602201600;
952     uint256 private constant CURRENT_EPOCH_PERIOD = 28800;
953 
954     /* Governance */
955     uint256 private constant GOVERNANCE_PERIOD = 9;
956     uint256 private constant GOVERNANCE_QUORUM = 33e16; // 33%
957     uint256 private constant GOVERNANCE_SUPER_MAJORITY = 66e16; // 66%
958     uint256 private constant GOVERNANCE_EMERGENCY_DELAY = 6; // 6 epochs
959 
960     /* DAO */
961     uint256 private constant ADVANCE_INCENTIVE = 1e20; // 100 ESD
962 
963     /* Market */
964     uint256 private constant COUPON_EXPIRATION = 90;
965     uint256 private constant DEBT_RATIO_CAP = 35e16; // 35%
966 
967     /* Regulator */
968     uint256 private constant SUPPLY_CHANGE_LIMIT = 1e17; // 10%
969     uint256 private constant ORACLE_POOL_RATIO = 20; // 20%
970 
971     /* Deployed */
972     address private constant DAO_ADDRESS = address(0x443D2f2755DB5942601fa062Cc248aAA153313D3);
973     address private constant DOLLAR_ADDRESS = address(0x36F3FD68E7325a35EB768F1AedaAe9EA0689d723);
974     address private constant PAIR_ADDRESS = address(0x88ff79eB2Bc5850F27315415da8685282C7610F9);
975 
976     /* Pool Migration */
977     address private constant LEGACY_POOL_ADDRESS = address(0xdF0Ae5504A48ab9f913F8490fBef1b9333A68e68);
978     uint256 private constant LEGACY_POOL_REWARD = 1e18; // 1 ESD
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
1056     function getOraclePoolRatio() internal pure returns (uint256) {
1057         return ORACLE_POOL_RATIO;
1058     }
1059 
1060     function getChainId() internal pure returns (uint256) {
1061         return CHAIN_ID;
1062     }
1063 
1064     function getDaoAddress() internal pure returns (address) {
1065         return DAO_ADDRESS;
1066     }
1067 
1068     function getDollarAddress() internal pure returns (address) {
1069         return DOLLAR_ADDRESS;
1070     }
1071 
1072     function getPairAddress() internal pure returns (address) {
1073         return PAIR_ADDRESS;
1074     }
1075 
1076     function getLegacyPoolAddress() internal pure returns (address) {
1077         return LEGACY_POOL_ADDRESS;
1078     }
1079 
1080     function getLegacyPoolReward() internal pure returns (uint256) {
1081         return LEGACY_POOL_REWARD;
1082     }
1083 }
1084 
1085 /*
1086     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
1087 
1088     Licensed under the Apache License, Version 2.0 (the "License");
1089     you may not use this file except in compliance with the License.
1090     You may obtain a copy of the License at
1091 
1092     http://www.apache.org/licenses/LICENSE-2.0
1093 
1094     Unless required by applicable law or agreed to in writing, software
1095     distributed under the License is distributed on an "AS IS" BASIS,
1096     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1097     See the License for the specific language governing permissions and
1098     limitations under the License.
1099 */
1100 contract IDollar is IERC20 {
1101     function burn(uint256 amount) public;
1102     function burnFrom(address account, uint256 amount) public;
1103     function mint(address account, uint256 amount) public returns (bool);
1104 }
1105 
1106 /*
1107     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
1108 
1109     Licensed under the Apache License, Version 2.0 (the "License");
1110     you may not use this file except in compliance with the License.
1111     You may obtain a copy of the License at
1112 
1113     http://www.apache.org/licenses/LICENSE-2.0
1114 
1115     Unless required by applicable law or agreed to in writing, software
1116     distributed under the License is distributed on an "AS IS" BASIS,
1117     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1118     See the License for the specific language governing permissions and
1119     limitations under the License.
1120 */
1121 contract IDAO {
1122     function epoch() external view returns (uint256);
1123 }
1124 
1125 /*
1126     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
1127 
1128     Licensed under the Apache License, Version 2.0 (the "License");
1129     you may not use this file except in compliance with the License.
1130     You may obtain a copy of the License at
1131 
1132     http://www.apache.org/licenses/LICENSE-2.0
1133 
1134     Unless required by applicable law or agreed to in writing, software
1135     distributed under the License is distributed on an "AS IS" BASIS,
1136     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1137     See the License for the specific language governing permissions and
1138     limitations under the License.
1139 */
1140 contract IUSDC {
1141     function isBlacklisted(address _account) external view returns (bool);
1142 }
1143 
1144 /*
1145     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
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
1159 contract PoolAccount {
1160     enum Status {
1161         Frozen,
1162         Fluid,
1163         Locked
1164     }
1165 
1166     struct State {
1167         uint256 staged;
1168         uint256 claimable;
1169         uint256 bonded;
1170         uint256 phantom;
1171         uint256 fluidUntil;
1172     }
1173 }
1174 
1175 contract PoolStorage {
1176     struct Balance {
1177         uint256 staged;
1178         uint256 claimable;
1179         uint256 bonded;
1180         uint256 phantom;
1181     }
1182 
1183     struct State {
1184         Balance balance;
1185         bool paused;
1186 
1187         mapping(address => PoolAccount.State) accounts;
1188     }
1189 }
1190 
1191 contract PoolState {
1192     PoolStorage.State _state;
1193 }
1194 
1195 /*
1196     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
1197 
1198     Licensed under the Apache License, Version 2.0 (the "License");
1199     you may not use this file except in compliance with the License.
1200     You may obtain a copy of the License at
1201 
1202     http://www.apache.org/licenses/LICENSE-2.0
1203 
1204     Unless required by applicable law or agreed to in writing, software
1205     distributed under the License is distributed on an "AS IS" BASIS,
1206     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1207     See the License for the specific language governing permissions and
1208     limitations under the License.
1209 */
1210 contract PoolGetters is PoolState {
1211     using SafeMath for uint256;
1212 
1213     /**
1214      * Global
1215      */
1216 
1217     function usdc() public view returns (address) {
1218         return Constants.getUsdcAddress();
1219     }
1220 
1221     function dao() public view returns (IDAO) {
1222         return IDAO(Constants.getDaoAddress());
1223     }
1224 
1225     function dollar() public view returns (IDollar) {
1226         return IDollar(Constants.getDollarAddress());
1227     }
1228 
1229     function univ2() public view returns (IERC20) {
1230         return IERC20(Constants.getPairAddress());
1231     }
1232 
1233     function totalBonded() public view returns (uint256) {
1234         return _state.balance.bonded;
1235     }
1236 
1237     function totalStaged() public view returns (uint256) {
1238         return _state.balance.staged;
1239     }
1240 
1241     function totalClaimable() public view returns (uint256) {
1242         return _state.balance.claimable;
1243     }
1244 
1245     function totalPhantom() public view returns (uint256) {
1246         return _state.balance.phantom;
1247     }
1248 
1249     function totalRewarded() public view returns (uint256) {
1250         return dollar().balanceOf(address(this)).sub(totalClaimable());
1251     }
1252 
1253     function paused() public view returns (bool) {
1254         return _state.paused;
1255     }
1256 
1257     /**
1258      * Account
1259      */
1260 
1261     function balanceOfStaged(address account) public view returns (uint256) {
1262         return _state.accounts[account].staged;
1263     }
1264 
1265     function balanceOfClaimable(address account) public view returns (uint256) {
1266         return _state.accounts[account].claimable;
1267     }
1268 
1269     function balanceOfBonded(address account) public view returns (uint256) {
1270         return _state.accounts[account].bonded;
1271     }
1272 
1273     function balanceOfPhantom(address account) public view returns (uint256) {
1274         return _state.accounts[account].phantom;
1275     }
1276 
1277     function balanceOfRewarded(address account) public view returns (uint256) {
1278         uint256 totalBonded = totalBonded();
1279         if (totalBonded == 0) {
1280             return 0;
1281         }
1282 
1283         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom());
1284         uint256 balanceOfRewardedWithPhantom = totalRewardedWithPhantom
1285             .mul(balanceOfBonded(account))
1286             .div(totalBonded);
1287 
1288         uint256 balanceOfPhantom = balanceOfPhantom(account);
1289         if (balanceOfRewardedWithPhantom > balanceOfPhantom) {
1290             return balanceOfRewardedWithPhantom.sub(balanceOfPhantom);
1291         }
1292         return 0;
1293     }
1294 
1295     function statusOf(address account) public view returns (PoolAccount.Status) {
1296         return epoch() >= _state.accounts[account].fluidUntil ?
1297             PoolAccount.Status.Frozen :
1298             PoolAccount.Status.Fluid;
1299     }
1300 
1301     /**
1302      * Epoch
1303      */
1304 
1305     function epoch() internal view returns (uint256) {
1306         return dao().epoch();
1307     }
1308 }
1309 
1310 /*
1311     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
1312 
1313     Licensed under the Apache License, Version 2.0 (the "License");
1314     you may not use this file except in compliance with the License.
1315     You may obtain a copy of the License at
1316 
1317     http://www.apache.org/licenses/LICENSE-2.0
1318 
1319     Unless required by applicable law or agreed to in writing, software
1320     distributed under the License is distributed on an "AS IS" BASIS,
1321     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1322     See the License for the specific language governing permissions and
1323     limitations under the License.
1324 */
1325 contract PoolSetters is PoolState, PoolGetters {
1326     using SafeMath for uint256;
1327 
1328     /**
1329      * Global
1330      */
1331 
1332     function pause() internal {
1333         _state.paused = true;
1334     }
1335 
1336     /**
1337      * Account
1338      */
1339 
1340     function incrementBalanceOfBonded(address account, uint256 amount) internal {
1341         _state.accounts[account].bonded = _state.accounts[account].bonded.add(amount);
1342         _state.balance.bonded = _state.balance.bonded.add(amount);
1343     }
1344 
1345     function decrementBalanceOfBonded(address account, uint256 amount, string memory reason) internal {
1346         _state.accounts[account].bonded = _state.accounts[account].bonded.sub(amount, reason);
1347         _state.balance.bonded = _state.balance.bonded.sub(amount, reason);
1348     }
1349 
1350     function incrementBalanceOfStaged(address account, uint256 amount) internal {
1351         _state.accounts[account].staged = _state.accounts[account].staged.add(amount);
1352         _state.balance.staged = _state.balance.staged.add(amount);
1353     }
1354 
1355     function decrementBalanceOfStaged(address account, uint256 amount, string memory reason) internal {
1356         _state.accounts[account].staged = _state.accounts[account].staged.sub(amount, reason);
1357         _state.balance.staged = _state.balance.staged.sub(amount, reason);
1358     }
1359 
1360     function incrementBalanceOfClaimable(address account, uint256 amount) internal {
1361         _state.accounts[account].claimable = _state.accounts[account].claimable.add(amount);
1362         _state.balance.claimable = _state.balance.claimable.add(amount);
1363     }
1364 
1365     function decrementBalanceOfClaimable(address account, uint256 amount, string memory reason) internal {
1366         _state.accounts[account].claimable = _state.accounts[account].claimable.sub(amount, reason);
1367         _state.balance.claimable = _state.balance.claimable.sub(amount, reason);
1368     }
1369 
1370     function incrementBalanceOfPhantom(address account, uint256 amount) internal {
1371         _state.accounts[account].phantom = _state.accounts[account].phantom.add(amount);
1372         _state.balance.phantom = _state.balance.phantom.add(amount);
1373     }
1374 
1375     function decrementBalanceOfPhantom(address account, uint256 amount, string memory reason) internal {
1376         _state.accounts[account].phantom = _state.accounts[account].phantom.sub(amount, reason);
1377         _state.balance.phantom = _state.balance.phantom.sub(amount, reason);
1378     }
1379 
1380     function unfreeze(address account) internal {
1381         _state.accounts[account].fluidUntil = epoch().add(1);
1382     }
1383 }
1384 
1385 interface IUniswapV2Pair {
1386     event Approval(address indexed owner, address indexed spender, uint value);
1387     event Transfer(address indexed from, address indexed to, uint value);
1388 
1389     function name() external pure returns (string memory);
1390     function symbol() external pure returns (string memory);
1391     function decimals() external pure returns (uint8);
1392     function totalSupply() external view returns (uint);
1393     function balanceOf(address owner) external view returns (uint);
1394     function allowance(address owner, address spender) external view returns (uint);
1395 
1396     function approve(address spender, uint value) external returns (bool);
1397     function transfer(address to, uint value) external returns (bool);
1398     function transferFrom(address from, address to, uint value) external returns (bool);
1399 
1400     function DOMAIN_SEPARATOR() external view returns (bytes32);
1401     function PERMIT_TYPEHASH() external pure returns (bytes32);
1402     function nonces(address owner) external view returns (uint);
1403 
1404     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1405 
1406     event Mint(address indexed sender, uint amount0, uint amount1);
1407     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1408     event Swap(
1409         address indexed sender,
1410         uint amount0In,
1411         uint amount1In,
1412         uint amount0Out,
1413         uint amount1Out,
1414         address indexed to
1415     );
1416     event Sync(uint112 reserve0, uint112 reserve1);
1417 
1418     function MINIMUM_LIQUIDITY() external pure returns (uint);
1419     function factory() external view returns (address);
1420     function token0() external view returns (address);
1421     function token1() external view returns (address);
1422     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1423     function price0CumulativeLast() external view returns (uint);
1424     function price1CumulativeLast() external view returns (uint);
1425     function kLast() external view returns (uint);
1426 
1427     function mint(address to) external returns (uint liquidity);
1428     function burn(address to) external returns (uint amount0, uint amount1);
1429     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1430     function skim(address to) external;
1431     function sync() external;
1432 
1433     function initialize(address, address) external;
1434 }
1435 
1436 library UniswapV2Library {
1437     using SafeMath for uint;
1438 
1439     // returns sorted token addresses, used to handle return values from pairs sorted in this order
1440     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
1441         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
1442         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
1443         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
1444     }
1445 
1446     // calculates the CREATE2 address for a pair without making any external calls
1447     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
1448         (address token0, address token1) = sortTokens(tokenA, tokenB);
1449         pair = address(uint(keccak256(abi.encodePacked(
1450                 hex'ff',
1451                 factory,
1452                 keccak256(abi.encodePacked(token0, token1)),
1453                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
1454             ))));
1455     }
1456 
1457     // fetches and sorts the reserves for a pair
1458     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
1459         (address token0,) = sortTokens(tokenA, tokenB);
1460         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
1461         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1462     }
1463 
1464     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
1465     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
1466         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
1467         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
1468         amountB = amountA.mul(reserveB) / reserveA;
1469     }
1470 }
1471 
1472 /*
1473     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
1474 
1475     Licensed under the Apache License, Version 2.0 (the "License");
1476     you may not use this file except in compliance with the License.
1477     You may obtain a copy of the License at
1478 
1479     http://www.apache.org/licenses/LICENSE-2.0
1480 
1481     Unless required by applicable law or agreed to in writing, software
1482     distributed under the License is distributed on an "AS IS" BASIS,
1483     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1484     See the License for the specific language governing permissions and
1485     limitations under the License.
1486 */
1487 contract Liquidity is PoolGetters {
1488     address private constant UNISWAP_FACTORY = address(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
1489 
1490     function addLiquidity(uint256 dollarAmount) internal returns (uint256, uint256) {
1491         (address dollar, address usdc) = (address(dollar()), usdc());
1492         (uint reserveA, uint reserveB) = getReserves(dollar, usdc);
1493 
1494         uint256 usdcAmount = (reserveA == 0 && reserveB == 0) ?
1495              dollarAmount :
1496              UniswapV2Library.quote(dollarAmount, reserveA, reserveB);
1497 
1498         address pair = address(univ2());
1499         IERC20(dollar).transfer(pair, dollarAmount);
1500         IERC20(usdc).transferFrom(msg.sender, pair, usdcAmount);
1501         return (usdcAmount, IUniswapV2Pair(pair).mint(address(this)));
1502     }
1503 
1504     // overridable for testing
1505     function getReserves(address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
1506         (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
1507         (uint reserve0, uint reserve1,) = IUniswapV2Pair(UniswapV2Library.pairFor(UNISWAP_FACTORY, tokenA, tokenB)).getReserves();
1508         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1509     }
1510 }
1511 
1512 /*
1513     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
1514 
1515     Licensed under the Apache License, Version 2.0 (the "License");
1516     you may not use this file except in compliance with the License.
1517     You may obtain a copy of the License at
1518 
1519     http://www.apache.org/licenses/LICENSE-2.0
1520 
1521     Unless required by applicable law or agreed to in writing, software
1522     distributed under the License is distributed on an "AS IS" BASIS,
1523     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1524     See the License for the specific language governing permissions and
1525     limitations under the License.
1526 */
1527 contract Pool is PoolSetters, Liquidity {
1528     using SafeMath for uint256;
1529 
1530     constructor() public { }
1531 
1532     bytes32 private constant FILE = "Pool";
1533 
1534     event Deposit(address indexed account, uint256 value);
1535     event Withdraw(address indexed account, uint256 value);
1536     event Claim(address indexed account, uint256 value);
1537     event Bond(address indexed account, uint256 start, uint256 value);
1538     event Unbond(address indexed account, uint256 start, uint256 value, uint256 newClaimable);
1539     event Provide(address indexed account, uint256 value, uint256 lessUsdc, uint256 newUniv2);
1540 
1541     function deposit(uint256 value) external onlyFrozen(msg.sender) notPaused {
1542         univ2().transferFrom(msg.sender, address(this), value);
1543         incrementBalanceOfStaged(msg.sender, value);
1544 
1545         balanceCheck();
1546 
1547         emit Deposit(msg.sender, value);
1548     }
1549 
1550     function withdraw(uint256 value) external onlyFrozen(msg.sender) {
1551         univ2().transfer(msg.sender, value);
1552         decrementBalanceOfStaged(msg.sender, value, "Pool: insufficient staged balance");
1553 
1554         balanceCheck();
1555 
1556         emit Withdraw(msg.sender, value);
1557     }
1558 
1559     function claim(uint256 value) external onlyFrozen(msg.sender) {
1560         dollar().transfer(msg.sender, value);
1561         decrementBalanceOfClaimable(msg.sender, value, "Pool: insufficient claimable balance");
1562 
1563         balanceCheck();
1564 
1565         emit Claim(msg.sender, value);
1566     }
1567 
1568     function bond(uint256 value) external notPaused {
1569         unfreeze(msg.sender);
1570 
1571         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom());
1572         uint256 newPhantom = totalBonded() == 0 ?
1573             totalRewarded() == 0 ? Constants.getInitialStakeMultiple().mul(value) : 0 :
1574             totalRewardedWithPhantom.mul(value).div(totalBonded());
1575 
1576         incrementBalanceOfBonded(msg.sender, value);
1577         incrementBalanceOfPhantom(msg.sender, newPhantom);
1578         decrementBalanceOfStaged(msg.sender, value, "Pool: insufficient staged balance");
1579 
1580         balanceCheck();
1581 
1582         emit Bond(msg.sender, epoch().add(1), value);
1583     }
1584 
1585     function unbond(uint256 value) external {
1586         unfreeze(msg.sender);
1587 
1588         uint256 balanceOfBonded = balanceOfBonded(msg.sender);
1589         Require.that(
1590             balanceOfBonded > 0,
1591             FILE,
1592             "insufficient bonded balance"
1593         );
1594 
1595         uint256 newClaimable = balanceOfRewarded(msg.sender).mul(value).div(balanceOfBonded);
1596         uint256 lessPhantom = balanceOfPhantom(msg.sender).mul(value).div(balanceOfBonded);
1597 
1598         incrementBalanceOfStaged(msg.sender, value);
1599         incrementBalanceOfClaimable(msg.sender, newClaimable);
1600         decrementBalanceOfBonded(msg.sender, value, "Pool: insufficient bonded balance");
1601         decrementBalanceOfPhantom(msg.sender, lessPhantom, "Pool: insufficient phantom balance");
1602 
1603         balanceCheck();
1604 
1605         emit Unbond(msg.sender, epoch().add(1), value, newClaimable);
1606     }
1607 
1608     function provide(uint256 value) external onlyFrozen(msg.sender) notPaused {
1609         Require.that(
1610             totalBonded() > 0,
1611             FILE,
1612             "insufficient total bonded"
1613         );
1614 
1615         Require.that(
1616             totalRewarded() > 0,
1617             FILE,
1618             "insufficient total rewarded"
1619         );
1620 
1621         Require.that(
1622             balanceOfRewarded(msg.sender) >= value,
1623             FILE,
1624             "insufficient rewarded balance"
1625         );
1626 
1627         (uint256 lessUsdc, uint256 newUniv2) = addLiquidity(value);
1628 
1629         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom()).add(value);
1630         uint256 newPhantomFromBonded = totalRewardedWithPhantom.mul(newUniv2).div(totalBonded());
1631 
1632         incrementBalanceOfBonded(msg.sender, newUniv2);
1633         incrementBalanceOfPhantom(msg.sender, value.add(newPhantomFromBonded));
1634 
1635 
1636         balanceCheck();
1637 
1638         emit Provide(msg.sender, value, lessUsdc, newUniv2);
1639     }
1640 
1641     function emergencyWithdraw(address token, uint256 value) external onlyDao {
1642         IERC20(token).transfer(address(dao()), value);
1643     }
1644 
1645     function emergencyPause() external onlyDao {
1646         pause();
1647     }
1648 
1649     function balanceCheck() private {
1650         Require.that(
1651             univ2().balanceOf(address(this)) >= totalStaged().add(totalBonded()),
1652             FILE,
1653             "Inconsistent UNI-V2 balances"
1654         );
1655     }
1656 
1657     modifier onlyFrozen(address account) {
1658         Require.that(
1659             statusOf(account) == PoolAccount.Status.Frozen,
1660             FILE,
1661             "Not frozen"
1662         );
1663 
1664         _;
1665     }
1666 
1667     modifier onlyDao() {
1668         Require.that(
1669             msg.sender == address(dao()),
1670             FILE,
1671             "Not dao"
1672         );
1673 
1674         _;
1675     }
1676 
1677     modifier notPaused() {
1678         Require.that(
1679             !paused(),
1680             FILE,
1681             "Paused"
1682         );
1683 
1684         _;
1685     }
1686 }