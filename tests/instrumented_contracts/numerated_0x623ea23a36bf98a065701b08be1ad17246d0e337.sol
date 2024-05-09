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
923 library Constants {
924     /* Chain */
925     uint256 private constant CHAIN_ID = 1; // Mainnet
926 
927     /* Bootstrapping */
928     uint256 private constant BOOTSTRAPPING_PERIOD = 36; // 36 epochs IMPORTANT
929     uint256 private constant BOOTSTRAPPING_PERIOD_PHASE1 = 11; // 12 epochs to speed up deployment IMPORTANT
930     uint256 private constant BOOTSTRAPPING_PRICE = 196e16; // 1.96 pegged token (targeting 8% inflation)
931 
932     /* Oracle */
933     //pegs to DSD during bootstrap. variable name not renamed on purpose until DAO votes on the peg.
934     //IMPORTANT 0xBD2F0Cd039E0BFcf88901C98c0bFAc5ab27566e3
935     address private constant USDC = address(0xBD2F0Cd039E0BFcf88901C98c0bFAc5ab27566e3); 
936     uint256 private constant ORACLE_RESERVE_MINIMUM = 1e9; // 1,000 pegged token, 1e9 IMPORTANT
937 
938     /* Bonding */
939     uint256 private constant INITIAL_STAKE_MULTIPLE = 1e6; // 100 VTD -> 100M VTDD
940 
941     /* Epoch */
942     uint256 private constant EPOCH_START = 1609405200;
943     uint256 private constant EPOCH_BASE = 7200; //two hours IMPORTANT
944     uint256 private constant EPOCH_GROWTH_CONSTANT = 12000; //3.3 hrs
945     uint256 private constant P1_EPOCH_BASE = 300; // IMPORTANT
946     uint256 private constant P1_EPOCH_GROWTH_CONSTANT = 2000; // IMPORTANT
947     uint256 private constant ADVANCE_LOTTERY_TIME = 91; // 7 average block lengths
948 
949     /* Governance */
950     uint256 private constant GOVERNANCE_PERIOD = 8; // 1 dayish governance period IMPORTANT
951     uint256 private constant GOVERNANCE_QUORUM = 20e16; // 20%
952     uint256 private constant GOVERNANCE_SUPER_MAJORITY = 51e16; // 51%
953     uint256 private constant GOVERNANCE_EMERGENCY_DELAY = 21600; // 6 hours
954 
955     /* DAO */
956     uint256 private constant ADVANCE_INCENTIVE = 50e18; // 50 VTD
957     uint256 private constant ADVANCE_INCENTIVE_BOOTSTRAP = 50e18; // 100 VTD during phase 1 bootstrap
958     uint256 private constant DAO_EXIT_LOCKUP_EPOCHS = 18; // 18 epoch fluid IMPORTANT
959 
960     /* Pool */
961     uint256 private constant POOL_EXIT_LOCKUP_EPOCHS = 9; // 9 epoch fluid IMPORTANT
962 
963     /* Market */
964     uint256 private constant COUPON_EXPIRATION = 180; //30 days
965     uint256 private constant DEBT_RATIO_CAP = 35e16; // 35%
966     uint256 private constant INITIAL_COUPON_REDEMPTION_PENALTY = 50e16; // 50%
967     uint256 private constant COUPON_REDEMPTION_PENALTY_DECAY = 3600; // 1 hour
968 
969     /* Regulator */
970     uint256 private constant SUPPLY_CHANGE_DIVISOR = 12e18; // 12
971     uint256 private constant SUPPLY_CHANGE_LIMIT = 10e16; // 10%
972     uint256 private constant ORACLE_POOL_RATIO = 30; // 30%
973 
974     /**
975      * Getters
976      */
977     function getEpochStart() internal pure returns (uint256) {
978         return EPOCH_START;
979     }
980 
981     function getP1EpochBase() internal pure returns (uint256) {
982         return P1_EPOCH_BASE;
983     }
984 
985     function getP1EpochGrowthConstant() internal pure returns (uint256) {
986         return P1_EPOCH_GROWTH_CONSTANT;
987     }
988 
989     function getEpochBase() internal pure returns (uint256) {
990         return EPOCH_BASE;
991     }
992 
993     function getEpochGrowthConstant() internal pure returns (uint256) {
994         return EPOCH_GROWTH_CONSTANT;
995     }
996 
997     function getUsdcAddress() internal pure returns (address) {
998         return USDC;
999     }
1000 
1001     function getOracleReserveMinimum() internal pure returns (uint256) {
1002         return ORACLE_RESERVE_MINIMUM;
1003     }
1004 
1005     function getInitialStakeMultiple() internal pure returns (uint256) {
1006         return INITIAL_STAKE_MULTIPLE;
1007     }
1008 
1009     function getAdvanceLotteryTime() internal pure returns (uint256){
1010         return ADVANCE_LOTTERY_TIME;
1011     }
1012 
1013     function getBootstrappingPeriod() internal pure returns (uint256) {
1014         return BOOTSTRAPPING_PERIOD;
1015     }
1016 
1017     function getPhaseOnePeriod() internal pure returns (uint256) {
1018         return BOOTSTRAPPING_PERIOD_PHASE1;
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
1045     function getAdvanceIncentiveBootstrap() internal pure returns (uint256) {
1046         return ADVANCE_INCENTIVE_BOOTSTRAP;
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
1069     function getCouponRedemptionPenaltyDecay() internal pure returns (uint256) {
1070         return COUPON_REDEMPTION_PENALTY_DECAY;
1071     }
1072 
1073     function getSupplyChangeLimit() internal pure returns (Decimal.D256 memory) {
1074         return Decimal.D256({value: SUPPLY_CHANGE_LIMIT});
1075     }
1076 
1077     function getSupplyChangeDivisor() internal pure returns (Decimal.D256 memory) {
1078         return Decimal.D256({value: SUPPLY_CHANGE_DIVISOR});
1079     }
1080 
1081     function getOraclePoolRatio() internal pure returns (uint256) {
1082         return ORACLE_POOL_RATIO;
1083     }
1084 
1085     function getChainId() internal pure returns (uint256) {
1086         return CHAIN_ID;
1087     }
1088 }
1089 
1090 /*
1091     Copyright 2020 VTD team, based on the works of Dynamic Dollar Devs and Empty Set Squad
1092 
1093     Licensed under the Apache License, Version 2.0 (the "License");
1094     you may not use this file except in compliance with the License.
1095     You may obtain a copy of the License at
1096 
1097     http://www.apache.org/licenses/LICENSE-2.0
1098 
1099     Unless required by applicable law or agreed to in writing, software
1100     distributed under the License is distributed on an "AS IS" BASIS,
1101     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1102     See the License for the specific language governing permissions and
1103     limitations under the License.
1104 */
1105 contract IDollar is IERC20 {
1106     function burn(uint256 amount) public;
1107     function burnFrom(address account, uint256 amount) public;
1108     function mint(address account, uint256 amount) public returns (bool);
1109 }
1110 
1111 /*
1112     Copyright 2020 VTD team, based on the works of Dynamic Dollar Devs and Empty Set Squad
1113 
1114     Licensed under the Apache License, Version 2.0 (the "License");
1115     you may not use this file except in compliance with the License.
1116     You may obtain a copy of the License at
1117 
1118     http://www.apache.org/licenses/LICENSE-2.0
1119 
1120     Unless required by applicable law or agreed to in writing, software
1121     distributed under the License is distributed on an "AS IS" BASIS,
1122     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1123     See the License for the specific language governing permissions and
1124     limitations under the License.
1125 */
1126 contract IDAO {
1127     function epoch() external view returns (uint256);
1128 }
1129 
1130 /*
1131     Copyright 2020 VTD team, based on the works of Dynamic Dollar Devs and Empty Set Squad
1132 
1133     Licensed under the Apache License, Version 2.0 (the "License");
1134     you may not use this file except in compliance with the License.
1135     You may obtain a copy of the License at
1136 
1137     http://www.apache.org/licenses/LICENSE-2.0
1138 
1139     Unless required by applicable law or agreed to in writing, software
1140     distributed under the License is distributed on an "AS IS" BASIS,
1141     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1142     See the License for the specific language governing permissions and
1143     limitations under the License.
1144 */
1145 contract IUSDC {
1146     // function isBlacklisted(address _account) external view returns (bool);
1147 }
1148 
1149 /*
1150     Copyright 2020 VTD team, based on the works of Dynamic Dollar Devs and Empty Set Squad
1151 
1152     Licensed under the Apache License, Version 2.0 (the "License");
1153     you may not use this file except in compliance with the License.
1154     You may obtain a copy of the License at
1155 
1156     http://www.apache.org/licenses/LICENSE-2.0
1157 
1158     Unless required by applicable law or agreed to in writing, software
1159     distributed under the License is distributed on an "AS IS" BASIS,
1160     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1161     See the License for the specific language governing permissions and
1162     limitations under the License.
1163 */
1164 contract PoolAccount {
1165     enum Status {
1166         Frozen,
1167         Fluid,
1168         Locked
1169     }
1170 
1171     struct State {
1172         uint256 staged;
1173         uint256 claimable;
1174         uint256 bonded;
1175         uint256 phantom;
1176         uint256 fluidUntil;
1177     }
1178 }
1179 
1180 contract PoolStorage {
1181     struct Provider {
1182         IDAO dao;
1183         IDollar dollar;
1184         IERC20 univ2;
1185     }
1186     
1187     struct Balance {
1188         uint256 staged;
1189         uint256 claimable;
1190         uint256 bonded;
1191         uint256 phantom;
1192     }
1193 
1194     struct State {
1195         Balance balance;
1196         Provider provider;
1197 
1198         bool paused;
1199 
1200         mapping(address => PoolAccount.State) accounts;
1201     }
1202 }
1203 
1204 contract PoolState {
1205     PoolStorage.State _state;
1206 }
1207 
1208 /*
1209     Copyright 2020 VTD team, based on the works of Dynamic Dollar Devs and Empty Set Squad
1210 
1211     Licensed under the Apache License, Version 2.0 (the "License");
1212     you may not use this file except in compliance with the License.
1213     You may obtain a copy of the License at
1214 
1215     http://www.apache.org/licenses/LICENSE-2.0
1216 
1217     Unless required by applicable law or agreed to in writing, software
1218     distributed under the License is distributed on an "AS IS" BASIS,
1219     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1220     See the License for the specific language governing permissions and
1221     limitations under the License.
1222 */
1223 contract PoolGetters is PoolState {
1224     using SafeMath for uint256;
1225 
1226     /**
1227      * Global
1228      */
1229 
1230     function usdc() public view returns (address) {
1231         return Constants.getUsdcAddress();
1232     }
1233 
1234     function dao() public view returns (IDAO) {
1235         return _state.provider.dao;
1236     }
1237 
1238     function dollar() public view returns (IDollar) {
1239         return _state.provider.dollar;
1240     }
1241 
1242     function univ2() public view returns (IERC20) {
1243         return _state.provider.univ2;
1244     }
1245 
1246     function totalBonded() public view returns (uint256) {
1247         return _state.balance.bonded;
1248     }
1249 
1250     function totalStaged() public view returns (uint256) {
1251         return _state.balance.staged;
1252     }
1253 
1254     function totalClaimable() public view returns (uint256) {
1255         return _state.balance.claimable;
1256     }
1257 
1258     function totalPhantom() public view returns (uint256) {
1259         return _state.balance.phantom;
1260     }
1261 
1262     function totalRewarded() public view returns (uint256) {
1263         return dollar().balanceOf(address(this)).sub(totalClaimable());
1264     }
1265 
1266     function paused() public view returns (bool) {
1267         return _state.paused;
1268     }
1269 
1270     /**
1271      * Account
1272      */
1273 
1274     function balanceOfStaged(address account) public view returns (uint256) {
1275         return _state.accounts[account].staged;
1276     }
1277 
1278     function balanceOfClaimable(address account) public view returns (uint256) {
1279         return _state.accounts[account].claimable;
1280     }
1281 
1282     function balanceOfBonded(address account) public view returns (uint256) {
1283         return _state.accounts[account].bonded;
1284     }
1285 
1286     function balanceOfPhantom(address account) public view returns (uint256) {
1287         return _state.accounts[account].phantom;
1288     }
1289 
1290     function balanceOfRewarded(address account) public view returns (uint256) {
1291         uint256 totalBonded = totalBonded();
1292         if (totalBonded == 0) {
1293             return 0;
1294         }
1295 
1296         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom());
1297         uint256 balanceOfRewardedWithPhantom = totalRewardedWithPhantom
1298             .mul(balanceOfBonded(account))
1299             .div(totalBonded);
1300 
1301         uint256 balanceOfPhantom = balanceOfPhantom(account);
1302         if (balanceOfRewardedWithPhantom > balanceOfPhantom) {
1303             return balanceOfRewardedWithPhantom.sub(balanceOfPhantom);
1304         }
1305         return 0;
1306     }
1307 
1308     function fluidUntil(address account) public view returns (uint256) {
1309         return _state.accounts[account].fluidUntil;
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
1327 /*
1328     Copyright 2020 VTD team, based on the works of Dynamic Dollar Devs and Empty Set Squad
1329 
1330     Licensed under the Apache License, Version 2.0 (the "License");
1331     you may not use this file except in compliance with the License.
1332     You may obtain a copy of the License at
1333 
1334     http://www.apache.org/licenses/LICENSE-2.0
1335 
1336     Unless required by applicable law or agreed to in writing, software
1337     distributed under the License is distributed on an "AS IS" BASIS,
1338     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1339     See the License for the specific language governing permissions and
1340     limitations under the License.
1341 */
1342 contract PoolSetters is PoolState, PoolGetters {
1343     using SafeMath for uint256;
1344 
1345     /**
1346      * Global
1347      */
1348 
1349     function pause() internal {
1350         _state.paused = true;
1351     }
1352 
1353     /**
1354      * Account
1355      */
1356 
1357     function incrementBalanceOfBonded(address account, uint256 amount) internal {
1358         _state.accounts[account].bonded = _state.accounts[account].bonded.add(amount);
1359         _state.balance.bonded = _state.balance.bonded.add(amount);
1360     }
1361 
1362     function decrementBalanceOfBonded(address account, uint256 amount, string memory reason) internal {
1363         _state.accounts[account].bonded = _state.accounts[account].bonded.sub(amount, reason);
1364         _state.balance.bonded = _state.balance.bonded.sub(amount, reason);
1365     }
1366 
1367     function incrementBalanceOfStaged(address account, uint256 amount) internal {
1368         _state.accounts[account].staged = _state.accounts[account].staged.add(amount);
1369         _state.balance.staged = _state.balance.staged.add(amount);
1370     }
1371 
1372     function decrementBalanceOfStaged(address account, uint256 amount, string memory reason) internal {
1373         _state.accounts[account].staged = _state.accounts[account].staged.sub(amount, reason);
1374         _state.balance.staged = _state.balance.staged.sub(amount, reason);
1375     }
1376 
1377     function incrementBalanceOfClaimable(address account, uint256 amount) internal {
1378         _state.accounts[account].claimable = _state.accounts[account].claimable.add(amount);
1379         _state.balance.claimable = _state.balance.claimable.add(amount);
1380     }
1381 
1382     function decrementBalanceOfClaimable(address account, uint256 amount, string memory reason) internal {
1383         _state.accounts[account].claimable = _state.accounts[account].claimable.sub(amount, reason);
1384         _state.balance.claimable = _state.balance.claimable.sub(amount, reason);
1385     }
1386 
1387     function incrementBalanceOfPhantom(address account, uint256 amount) internal {
1388         _state.accounts[account].phantom = _state.accounts[account].phantom.add(amount);
1389         _state.balance.phantom = _state.balance.phantom.add(amount);
1390     }
1391 
1392     function decrementBalanceOfPhantom(address account, uint256 amount, string memory reason) internal {
1393         _state.accounts[account].phantom = _state.accounts[account].phantom.sub(amount, reason);
1394         _state.balance.phantom = _state.balance.phantom.sub(amount, reason);
1395     }
1396 
1397     function unfreeze(address account) internal {
1398         _state.accounts[account].fluidUntil = epoch().add(Constants.getPoolExitLockupEpochs());
1399     }
1400 }
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
1453 library UniswapV2Library {
1454     using SafeMath for uint;
1455 
1456     // returns sorted token addresses, used to handle return values from pairs sorted in this order
1457     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
1458         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
1459         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
1460         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
1461     }
1462 
1463     // calculates the CREATE2 address for a pair without making any external calls
1464     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
1465         (address token0, address token1) = sortTokens(tokenA, tokenB);
1466         pair = address(uint(keccak256(abi.encodePacked(
1467                 hex'ff',
1468                 factory,
1469                 keccak256(abi.encodePacked(token0, token1)),
1470                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
1471             ))));
1472     }
1473 
1474     // fetches and sorts the reserves for a pair
1475     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
1476         (address token0,) = sortTokens(tokenA, tokenB);
1477         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
1478         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1479     }
1480 
1481     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
1482     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
1483         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
1484         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
1485         amountB = amountA.mul(reserveB) / reserveA;
1486     }
1487 }
1488 
1489 /*
1490     Copyright 2020 VTD team, based on the works of Dynamic Dollar Devs and Empty Set Squad
1491 
1492     Licensed under the Apache License, Version 2.0 (the "License");
1493     you may not use this file except in compliance with the License.
1494     You may obtain a copy of the License at
1495 
1496     http://www.apache.org/licenses/LICENSE-2.0
1497 
1498     Unless required by applicable law or agreed to in writing, software
1499     distributed under the License is distributed on an "AS IS" BASIS,
1500     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1501     See the License for the specific language governing permissions and
1502     limitations under the License.
1503 */
1504 contract Liquidity is PoolGetters {
1505     address private constant UNISWAP_FACTORY = address(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
1506 
1507     function addLiquidity(uint256 dollarAmount) internal returns (uint256, uint256) {
1508         (address dollar, address usdc) = (address(dollar()), usdc());
1509         (uint reserveA, uint reserveB) = getReserves(dollar, usdc);
1510 
1511         uint256 usdcAmount = (reserveA == 0 && reserveB == 0) ?
1512              dollarAmount :
1513              UniswapV2Library.quote(dollarAmount, reserveA, reserveB);
1514 
1515         address pair = address(univ2());
1516         IERC20(dollar).transfer(pair, dollarAmount);
1517         IERC20(usdc).transferFrom(msg.sender, pair, usdcAmount);
1518         return (usdcAmount, IUniswapV2Pair(pair).mint(address(this)));
1519     }
1520 
1521     // overridable for testing
1522     function getReserves(address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
1523         (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
1524         (uint reserve0, uint reserve1,) = IUniswapV2Pair(UniswapV2Library.pairFor(UNISWAP_FACTORY, tokenA, tokenB)).getReserves();
1525         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1526     }
1527 }
1528 
1529 /*
1530     Copyright 2020 VTD team, based on the works of Dynamic Dollar Devs and Empty Set Squad
1531 
1532     Licensed under the Apache License, Version 2.0 (the "License");
1533     you may not use this file except in compliance with the License.
1534     You may obtain a copy of the License at
1535 
1536     http://www.apache.org/licenses/LICENSE-2.0
1537 
1538     Unless required by applicable law or agreed to in writing, software
1539     distributed under the License is distributed on an "AS IS" BASIS,
1540     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1541     See the License for the specific language governing permissions and
1542     limitations under the License.
1543 */
1544 contract Pool is PoolSetters, Liquidity {
1545     using SafeMath for uint256;
1546 
1547     constructor(address dollar, address univ2) public {
1548         _state.provider.dao = IDAO(msg.sender);
1549         _state.provider.dollar = IDollar(dollar);
1550         _state.provider.univ2 = IERC20(univ2);
1551     }
1552 
1553     bytes32 private constant FILE = "Pool";
1554 
1555     event Deposit(address indexed account, uint256 value);
1556     event Withdraw(address indexed account, uint256 value);
1557     event Claim(address indexed account, uint256 value);
1558     event Bond(address indexed account, uint256 start, uint256 value);
1559     event Unbond(address indexed account, uint256 start, uint256 value, uint256 newClaimable);
1560     event Provide(address indexed account, uint256 value, uint256 lessUsdc, uint256 newUniv2);
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
1581         dollar().transfer(msg.sender, value);
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
1698     modifier notPaused() {
1699         Require.that(
1700             !paused(),
1701             FILE,
1702             "Paused"
1703         );
1704 
1705         _;
1706     }
1707 }