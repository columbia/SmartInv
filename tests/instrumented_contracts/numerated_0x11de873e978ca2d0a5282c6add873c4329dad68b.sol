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
644     Copyright 2020 Freq Set Dollar <freqsetdollar@gmail.com>
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
909     Copyright 2020 Freq Set Dollar <freqsetdollar@gmail.com>
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
928     uint256 private constant BOOTSTRAPPING_PERIOD = 168;
929     uint256 private constant BOOTSTRAPPING_PRICE = 220e16; // 2.2 USDC (targeting 5% inflation)
930 
931     /* Oracle */
932     address private constant USDC = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
933 
934     uint256 private constant ORACLE_RESERVE_MINIMUM = 1e10; // 10,000 USDC
935 
936     /* Bonding */
937     uint256 private constant INITIAL_STAKE_MULTIPLE = 1e6; // 100 FSD -> 100M FSDS
938 
939     /* Epoch */
940     struct EpochStrategy {
941         uint256 offset;
942         uint256 start;
943         uint256 period;
944     }
945 
946     uint256 private constant EPOCH_OFFSET = 0;
947     uint256 private constant EPOCH_START = 1609905600;
948     
949     uint256 private constant EPOCH_PERIOD = 3600; // 60 min
950 
951     /* Governance */
952     uint256 private constant GOVERNANCE_PERIOD = 24; // 24 epochs
953     uint256 private constant GOVERNANCE_QUORUM = 20e16; // 20%
954     uint256 private constant GOVERNANCE_SUPER_MAJORITY = 66e16; // 66%
955     uint256 private constant GOVERNANCE_EMERGENCY_DELAY = 6; // 6 epochs
956     uint256 private constant GOVERNANCE_PROPOSAL_THRESHOLD = 1e16; // 1%
957 
958     /* DAO */
959     uint256 private constant ADVANCE_INCENTIVE = 1e20; // 100 FSD
960 
961     uint256 private constant DAO_EXIT_LOCKUP_EPOCHS = 12; // 12 epochs fluid
962 
963     /* Pool */
964     uint256 private constant POOL_EXIT_LOCKUP_EPOCHS = 6; // 6 epochs fluid
965 
966     /* Market */
967     uint256 private constant COUPON_EXPIRATION = 720; //720 epoch
968 
969     uint256 private constant DEBT_RATIO_CAP = 50e16; // 50%
970 
971     uint256 private constant INITIAL_COUPON_REDEMPTION_PENALTY = 65e16; // 65%
972 
973     uint256 private constant COUPON_REDEMPTION_PENALTY_DECAY = 1800; // 30 minutes
974 
975     /* Regulator */
976     uint256 private constant SUPPLY_CHANGE_DIVISOR = 24e18; // 24
977 
978     //10% supply limit 
979     uint256 private constant SUPPLY_CHANGE_LIMIT = 10e16; // 10%
980 
981     uint256 private constant ORACLE_POOL_RATIO = 50; // 50%
982 
983     /**
984      * Getters
985      */
986 
987     function getUsdcAddress() internal pure returns (address) {
988         return USDC;
989     }
990 
991     function getOracleReserveMinimum() internal pure returns (uint256) {
992         return ORACLE_RESERVE_MINIMUM;
993     }
994 
995     function getEpochStrategy() internal pure returns (EpochStrategy memory) {
996         return EpochStrategy({
997             offset: EPOCH_OFFSET,
998             start: EPOCH_START,
999             period: EPOCH_PERIOD
1000         });
1001     }
1002 
1003     function getInitialStakeMultiple() internal pure returns (uint256) {
1004         return INITIAL_STAKE_MULTIPLE;
1005     }
1006 
1007     function getBootstrappingPeriod() internal pure returns (uint256) {
1008         return BOOTSTRAPPING_PERIOD;
1009     }
1010 
1011     function getBootstrappingPrice() internal pure returns (Decimal.D256 memory) {
1012         return Decimal.D256({value: BOOTSTRAPPING_PRICE});
1013     }
1014 
1015     function getGovernancePeriod() internal pure returns (uint256) {
1016         return GOVERNANCE_PERIOD;
1017     }
1018 
1019     function getGovernanceQuorum() internal pure returns (Decimal.D256 memory) {
1020         return Decimal.D256({value: GOVERNANCE_QUORUM});
1021     }
1022 
1023     function getGovernanceSuperMajority() internal pure returns (Decimal.D256 memory) {
1024         return Decimal.D256({value: GOVERNANCE_SUPER_MAJORITY});
1025     }
1026 
1027     function getGovernanceEmergencyDelay() internal pure returns (uint256) {
1028         return GOVERNANCE_EMERGENCY_DELAY;
1029     }
1030 
1031     function getGovernanceProposalThreshold() internal pure returns (Decimal.D256 memory) {
1032         return Decimal.D256({value: GOVERNANCE_PROPOSAL_THRESHOLD});
1033     }
1034 
1035     function getAdvanceIncentive() internal pure returns (uint256) {
1036         return ADVANCE_INCENTIVE;
1037     }
1038 
1039     function getDAOExitLockupEpochs() internal pure returns (uint256) {
1040         return DAO_EXIT_LOCKUP_EPOCHS;
1041     }
1042 
1043     function getPoolExitLockupEpochs() internal pure returns (uint256) {
1044         return POOL_EXIT_LOCKUP_EPOCHS;
1045     }
1046 
1047     function getCouponExpiration() internal pure returns (uint256) {
1048         return COUPON_EXPIRATION;
1049     }
1050 
1051     function getDebtRatioCap() internal pure returns (Decimal.D256 memory) {
1052         return Decimal.D256({value: DEBT_RATIO_CAP});
1053     }
1054 
1055     function getInitialCouponRedemptionPenalty() internal pure returns (Decimal.D256 memory) {
1056         return Decimal.D256({value: INITIAL_COUPON_REDEMPTION_PENALTY});
1057     }
1058     function getCouponRedemptionPenaltyDecay() internal pure returns (uint256) {
1059         return COUPON_REDEMPTION_PENALTY_DECAY;
1060     }
1061 
1062     function getSupplyChangeLimit() internal pure returns (Decimal.D256 memory) {
1063         return Decimal.D256({value: SUPPLY_CHANGE_LIMIT});
1064     }
1065 
1066 	function getSupplyChangeDivisor() internal pure returns (Decimal.D256 memory) {
1067         return Decimal.D256({value: SUPPLY_CHANGE_DIVISOR});
1068     }
1069 
1070     function getOraclePoolRatio() internal pure returns (uint256) {
1071         return ORACLE_POOL_RATIO;
1072     }
1073 
1074     function getChainId() internal pure returns (uint256) {
1075         return CHAIN_ID;
1076     }
1077 }
1078 
1079 /*
1080     Copyright 2020 Freq Set Dollar <freqsetdollar@gmail.com>
1081 
1082     Licensed under the Apache License, Version 2.0 (the "License");
1083     you may not use this file except in compliance with the License.
1084     You may obtain a copy of the License at
1085 
1086     http://www.apache.org/licenses/LICENSE-2.0
1087 
1088     Unless required by applicable law or agreed to in writing, software
1089     distributed under the License is distributed on an "AS IS" BASIS,
1090     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1091     See the License for the specific language governing permissions and
1092     limitations under the License.
1093 */
1094 contract IDollar is IERC20 {
1095     function burn(uint256 amount) public;
1096     function burnFrom(address account, uint256 amount) public;
1097     function mint(address account, uint256 amount) public returns (bool);
1098 }
1099 
1100 /*
1101     Copyright 2020 Freq Set Dollar <freqsetdollar@gmail.com>
1102 
1103     Licensed under the Apache License, Version 2.0 (the "License");
1104     you may not use this file except in compliance with the License.
1105     You may obtain a copy of the License at
1106 
1107     http://www.apache.org/licenses/LICENSE-2.0
1108 
1109     Unless required by applicable law or agreed to in writing, software
1110     distributed under the License is distributed on an "AS IS" BASIS,
1111     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1112     See the License for the specific language governing permissions and
1113     limitations under the License.
1114 */
1115 contract IDAO {
1116     function epoch() external view returns (uint256);
1117 }
1118 
1119 /*
1120     Copyright 2020 Freq Set Dollar <freqsetdollar@gmail.com>
1121 
1122     Licensed under the Apache License, Version 2.0 (the "License");
1123     you may not use this file except in compliance with the License.
1124     You may obtain a copy of the License at
1125 
1126     http://www.apache.org/licenses/LICENSE-2.0
1127 
1128     Unless required by applicable law or agreed to in writing, software
1129     distributed under the License is distributed on an "AS IS" BASIS,
1130     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1131     See the License for the specific language governing permissions and
1132     limitations under the License.
1133 */
1134 contract IUSDC {
1135     function isBlacklisted(address _account) external view returns (bool);
1136 }
1137 
1138 /*
1139     Copyright 2020 Freq Set Dollar <freqsetdollar@gmail.com>
1140 
1141     Licensed under the Apache License, Version 2.0 (the "License");
1142     you may not use this file except in compliance with the License.
1143     You may obtain a copy of the License at
1144 
1145     http://www.apache.org/licenses/LICENSE-2.0
1146 
1147     Unless required by applicable law or agreed to in writing, software
1148     distributed under the License is distributed on an "AS IS" BASIS,
1149     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1150     See the License for the specific language governing permissions and
1151     limitations under the License.
1152 */
1153 contract PoolAccount {
1154     enum Status {
1155         Frozen,
1156         Fluid,
1157         Locked
1158     }
1159 
1160     struct State {
1161         uint256 staged;
1162         uint256 claimable;
1163         uint256 bonded;
1164         uint256 phantom;
1165         uint256 fluidUntil;
1166     }
1167 }
1168 
1169 contract PoolStorage {
1170     struct Provider {
1171         IDAO dao;
1172         IDollar dollar;
1173         IERC20 univ2;
1174     }
1175 
1176     struct Balance {
1177         uint256 staged;
1178         uint256 claimable;
1179         uint256 bonded;
1180         uint256 phantom;
1181     }
1182 
1183     struct State {
1184         Balance balance;
1185         Provider provider;
1186 
1187         bool paused;
1188 
1189         mapping(address => PoolAccount.State) accounts;
1190     }
1191 }
1192 
1193 contract PoolState {
1194     PoolStorage.State _state;
1195 }
1196 
1197 /*
1198     Copyright 2020 Freq Set Dollar <freqsetdollar@gmail.com>
1199 
1200     Licensed under the Apache License, Version 2.0 (the "License");
1201     you may not use this file except in compliance with the License.
1202     You may obtain a copy of the License at
1203 
1204     http://www.apache.org/licenses/LICENSE-2.0
1205 
1206     Unless required by applicable law or agreed to in writing, software
1207     distributed under the License is distributed on an "AS IS" BASIS,
1208     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1209     See the License for the specific language governing permissions and
1210     limitations under the License.
1211 */
1212 contract PoolGetters is PoolState {
1213     using SafeMath for uint256;
1214 
1215     /**
1216      * Global
1217      */
1218 
1219     function usdc() public view returns (address) {
1220         return Constants.getUsdcAddress();
1221     }
1222 
1223     function dao() public view returns (IDAO) {
1224         return _state.provider.dao;
1225     }
1226 
1227     function dollar() public view returns (IDollar) {
1228         return _state.provider.dollar;
1229     }
1230 
1231     function univ2() public view returns (IERC20) {
1232         return _state.provider.univ2;
1233     }
1234 
1235     function totalBonded() public view returns (uint256) {
1236         return _state.balance.bonded;
1237     }
1238 
1239     function totalStaged() public view returns (uint256) {
1240         return _state.balance.staged;
1241     }
1242 
1243     function totalClaimable() public view returns (uint256) {
1244         return _state.balance.claimable;
1245     }
1246 
1247     function totalPhantom() public view returns (uint256) {
1248         return _state.balance.phantom;
1249     }
1250 
1251     function totalRewarded() public view returns (uint256) {
1252         return dollar().balanceOf(address(this)).sub(totalClaimable());
1253     }
1254 
1255     function paused() public view returns (bool) {
1256         return _state.paused;
1257     }
1258 
1259     /**
1260      * Account
1261      */
1262 
1263     function balanceOfStaged(address account) public view returns (uint256) {
1264         return _state.accounts[account].staged;
1265     }
1266 
1267     function balanceOfClaimable(address account) public view returns (uint256) {
1268         return _state.accounts[account].claimable;
1269     }
1270 
1271     function balanceOfBonded(address account) public view returns (uint256) {
1272         return _state.accounts[account].bonded;
1273     }
1274 
1275     function balanceOfPhantom(address account) public view returns (uint256) {
1276         return _state.accounts[account].phantom;
1277     }
1278 
1279     function balanceOfRewarded(address account) public view returns (uint256) {
1280         uint256 totalBonded = totalBonded();
1281         if (totalBonded == 0) {
1282             return 0;
1283         }
1284 
1285         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom());
1286         uint256 balanceOfRewardedWithPhantom = totalRewardedWithPhantom
1287             .mul(balanceOfBonded(account))
1288             .div(totalBonded);
1289 
1290         uint256 balanceOfPhantom = balanceOfPhantom(account);
1291         if (balanceOfRewardedWithPhantom > balanceOfPhantom) {
1292             return balanceOfRewardedWithPhantom.sub(balanceOfPhantom);
1293         }
1294         return 0;
1295     }
1296 
1297     function statusOf(address account) public view returns (PoolAccount.Status) {
1298         return epoch() >= _state.accounts[account].fluidUntil ?
1299             PoolAccount.Status.Frozen :
1300             PoolAccount.Status.Fluid;
1301     }
1302 
1303     /**
1304      * Epoch
1305      */
1306 
1307     function epoch() internal view returns (uint256) {
1308         return dao().epoch();
1309     }
1310 }
1311 
1312 /*
1313     Copyright 2020 Freq Set Dollar <freqsetdollar@gmail.com>
1314 
1315     Licensed under the Apache License, Version 2.0 (the "License");
1316     you may not use this file except in compliance with the License.
1317     You may obtain a copy of the License at
1318 
1319     http://www.apache.org/licenses/LICENSE-2.0
1320 
1321     Unless required by applicable law or agreed to in writing, software
1322     distributed under the License is distributed on an "AS IS" BASIS,
1323     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1324     See the License for the specific language governing permissions and
1325     limitations under the License.
1326 */
1327 contract PoolSetters is PoolState, PoolGetters {
1328     using SafeMath for uint256;
1329 
1330     /**
1331      * Global
1332      */
1333 
1334     function pause() internal {
1335         _state.paused = true;
1336     }
1337 
1338     /**
1339      * Account
1340      */
1341 
1342     function incrementBalanceOfBonded(address account, uint256 amount) internal {
1343         _state.accounts[account].bonded = _state.accounts[account].bonded.add(amount);
1344         _state.balance.bonded = _state.balance.bonded.add(amount);
1345     }
1346 
1347     function decrementBalanceOfBonded(address account, uint256 amount, string memory reason) internal {
1348         _state.accounts[account].bonded = _state.accounts[account].bonded.sub(amount, reason);
1349         _state.balance.bonded = _state.balance.bonded.sub(amount, reason);
1350     }
1351 
1352     function incrementBalanceOfStaged(address account, uint256 amount) internal {
1353         _state.accounts[account].staged = _state.accounts[account].staged.add(amount);
1354         _state.balance.staged = _state.balance.staged.add(amount);
1355     }
1356 
1357     function decrementBalanceOfStaged(address account, uint256 amount, string memory reason) internal {
1358         _state.accounts[account].staged = _state.accounts[account].staged.sub(amount, reason);
1359         _state.balance.staged = _state.balance.staged.sub(amount, reason);
1360     }
1361 
1362     function incrementBalanceOfClaimable(address account, uint256 amount) internal {
1363         _state.accounts[account].claimable = _state.accounts[account].claimable.add(amount);
1364         _state.balance.claimable = _state.balance.claimable.add(amount);
1365     }
1366 
1367     function decrementBalanceOfClaimable(address account, uint256 amount, string memory reason) internal {
1368         _state.accounts[account].claimable = _state.accounts[account].claimable.sub(amount, reason);
1369         _state.balance.claimable = _state.balance.claimable.sub(amount, reason);
1370     }
1371 
1372     function incrementBalanceOfPhantom(address account, uint256 amount) internal {
1373         _state.accounts[account].phantom = _state.accounts[account].phantom.add(amount);
1374         _state.balance.phantom = _state.balance.phantom.add(amount);
1375     }
1376 
1377     function decrementBalanceOfPhantom(address account, uint256 amount, string memory reason) internal {
1378         _state.accounts[account].phantom = _state.accounts[account].phantom.sub(amount, reason);
1379         _state.balance.phantom = _state.balance.phantom.sub(amount, reason);
1380     }
1381 
1382     function unfreeze(address account) internal {
1383         _state.accounts[account].fluidUntil = epoch().add(Constants.getPoolExitLockupEpochs());
1384     }
1385 }
1386 
1387 interface IUniswapV2Pair {
1388     event Approval(address indexed owner, address indexed spender, uint value);
1389     event Transfer(address indexed from, address indexed to, uint value);
1390 
1391     function name() external pure returns (string memory);
1392     function symbol() external pure returns (string memory);
1393     function decimals() external pure returns (uint8);
1394     function totalSupply() external view returns (uint);
1395     function balanceOf(address owner) external view returns (uint);
1396     function allowance(address owner, address spender) external view returns (uint);
1397 
1398     function approve(address spender, uint value) external returns (bool);
1399     function transfer(address to, uint value) external returns (bool);
1400     function transferFrom(address from, address to, uint value) external returns (bool);
1401 
1402     function DOMAIN_SEPARATOR() external view returns (bytes32);
1403     function PERMIT_TYPEHASH() external pure returns (bytes32);
1404     function nonces(address owner) external view returns (uint);
1405 
1406     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1407 
1408     event Mint(address indexed sender, uint amount0, uint amount1);
1409     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1410     event Swap(
1411         address indexed sender,
1412         uint amount0In,
1413         uint amount1In,
1414         uint amount0Out,
1415         uint amount1Out,
1416         address indexed to
1417     );
1418     event Sync(uint112 reserve0, uint112 reserve1);
1419 
1420     function MINIMUM_LIQUIDITY() external pure returns (uint);
1421     function factory() external view returns (address);
1422     function token0() external view returns (address);
1423     function token1() external view returns (address);
1424     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1425     function price0CumulativeLast() external view returns (uint);
1426     function price1CumulativeLast() external view returns (uint);
1427     function kLast() external view returns (uint);
1428 
1429     function mint(address to) external returns (uint liquidity);
1430     function burn(address to) external returns (uint amount0, uint amount1);
1431     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1432     function skim(address to) external;
1433     function sync() external;
1434 
1435     function initialize(address, address) external;
1436 }
1437 
1438 library UniswapV2Library {
1439     using SafeMath for uint;
1440 
1441     // returns sorted token addresses, used to handle return values from pairs sorted in this order
1442     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
1443         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
1444         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
1445         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
1446     }
1447 
1448     // calculates the CREATE2 address for a pair without making any external calls
1449     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
1450         (address token0, address token1) = sortTokens(tokenA, tokenB);
1451         pair = address(uint(keccak256(abi.encodePacked(
1452                 hex'ff',
1453                 factory,
1454                 keccak256(abi.encodePacked(token0, token1)),
1455                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
1456             ))));
1457     }
1458 
1459     // fetches and sorts the reserves for a pair
1460     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
1461         (address token0,) = sortTokens(tokenA, tokenB);
1462         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
1463         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1464     }
1465 
1466     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
1467     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
1468         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
1469         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
1470         amountB = amountA.mul(reserveB) / reserveA;
1471     }
1472 }
1473 
1474 /*
1475     Copyright 2020 Freq Set Dollar <freqsetdollar@gmail.com>
1476 
1477     Licensed under the Apache License, Version 2.0 (the "License");
1478     you may not use this file except in compliance with the License.
1479     You may obtain a copy of the License at
1480 
1481     http://www.apache.org/licenses/LICENSE-2.0
1482 
1483     Unless required by applicable law or agreed to in writing, software
1484     distributed under the License is distributed on an "AS IS" BASIS,
1485     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1486     See the License for the specific language governing permissions and
1487     limitations under the License.
1488 */
1489 contract Liquidity is PoolGetters {
1490     address private constant UNISWAP_FACTORY = address(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
1491 
1492     function addLiquidity(uint256 dollarAmount) internal returns (uint256, uint256) {
1493         (address dollar, address usdc) = (address(dollar()), usdc());
1494         (uint reserveA, uint reserveB) = getReserves(dollar, usdc);
1495 
1496         uint256 usdcAmount = (reserveA == 0 && reserveB == 0) ?
1497              dollarAmount :
1498              UniswapV2Library.quote(dollarAmount, reserveA, reserveB);
1499 
1500         address pair = address(univ2());
1501         IERC20(dollar).transfer(pair, dollarAmount);
1502         IERC20(usdc).transferFrom(msg.sender, pair, usdcAmount);
1503         return (usdcAmount, IUniswapV2Pair(pair).mint(address(this)));
1504     }
1505 
1506     // overridable for testing
1507     function getReserves(address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
1508         (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
1509         (uint reserve0, uint reserve1,) = IUniswapV2Pair(UniswapV2Library.pairFor(UNISWAP_FACTORY, tokenA, tokenB)).getReserves();
1510         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1511     }
1512 }
1513 
1514 /*
1515     Copyright 2020 Freq Set Dollar <freqsetdollar@gmail.com>
1516 
1517     Licensed under the Apache License, Version 2.0 (the "License");
1518     you may not use this file except in compliance with the License.
1519     You may obtain a copy of the License at
1520 
1521     http://www.apache.org/licenses/LICENSE-2.0
1522 
1523     Unless required by applicable law or agreed to in writing, software
1524     distributed under the License is distributed on an "AS IS" BASIS,
1525     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1526     See the License for the specific language governing permissions and
1527     limitations under the License.
1528 */
1529 contract Pool is PoolSetters, Liquidity {
1530     using SafeMath for uint256;
1531 
1532     constructor(address dollar, address univ2) public {
1533         _state.provider.dao = IDAO(msg.sender);
1534         _state.provider.dollar = IDollar(dollar);
1535         _state.provider.univ2 = IERC20(univ2);
1536     }
1537 
1538     bytes32 private constant FILE = "Pool";
1539 
1540     event Deposit(address indexed account, uint256 value);
1541     event Withdraw(address indexed account, uint256 value);
1542     event Claim(address indexed account, uint256 value);
1543     event Bond(address indexed account, uint256 start, uint256 value);
1544     event Unbond(address indexed account, uint256 start, uint256 value, uint256 newClaimable);
1545     event Provide(address indexed account, uint256 value, uint256 lessUsdc, uint256 newUniv2);
1546 
1547     function deposit(uint256 value) external onlyFrozen(msg.sender) notPaused {
1548         univ2().transferFrom(msg.sender, address(this), value);
1549         incrementBalanceOfStaged(msg.sender, value);
1550 
1551         balanceCheck();
1552 
1553         emit Deposit(msg.sender, value);
1554     }
1555 
1556     function withdraw(uint256 value) external onlyFrozen(msg.sender) {
1557         univ2().transfer(msg.sender, value);
1558         decrementBalanceOfStaged(msg.sender, value, "Pool: insufficient staged balance");
1559 
1560         balanceCheck();
1561 
1562         emit Withdraw(msg.sender, value);
1563     }
1564 
1565     function claim(uint256 value) external onlyFrozen(msg.sender) {
1566         dollar().transfer(msg.sender, value);
1567         decrementBalanceOfClaimable(msg.sender, value, "Pool: insufficient claimable balance");
1568 
1569         balanceCheck();
1570 
1571         emit Claim(msg.sender, value);
1572     }
1573 
1574     function bond(uint256 value) external notPaused {
1575         unfreeze(msg.sender);
1576 
1577         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom());
1578         uint256 newPhantom = totalBonded() == 0 ?
1579             totalRewarded() == 0 ? Constants.getInitialStakeMultiple().mul(value) : 0 :
1580             totalRewardedWithPhantom.mul(value).div(totalBonded());
1581 
1582         incrementBalanceOfBonded(msg.sender, value);
1583         incrementBalanceOfPhantom(msg.sender, newPhantom);
1584         decrementBalanceOfStaged(msg.sender, value, "Pool: insufficient staged balance");
1585 
1586         balanceCheck();
1587 
1588         emit Bond(msg.sender, epoch().add(1), value);
1589     }
1590 
1591     function unbond(uint256 value) external {
1592         unfreeze(msg.sender);
1593 
1594         uint256 balanceOfBonded = balanceOfBonded(msg.sender);
1595         Require.that(
1596             balanceOfBonded > 0,
1597             FILE,
1598             "insufficient bonded balance"
1599         );
1600 
1601         uint256 newClaimable = balanceOfRewarded(msg.sender).mul(value).div(balanceOfBonded);
1602         uint256 lessPhantom = balanceOfPhantom(msg.sender).mul(value).div(balanceOfBonded);
1603 
1604         incrementBalanceOfStaged(msg.sender, value);
1605         incrementBalanceOfClaimable(msg.sender, newClaimable);
1606         decrementBalanceOfBonded(msg.sender, value, "Pool: insufficient bonded balance");
1607         decrementBalanceOfPhantom(msg.sender, lessPhantom, "Pool: insufficient phantom balance");
1608 
1609         balanceCheck();
1610 
1611         emit Unbond(msg.sender, epoch().add(1), value, newClaimable);
1612     }
1613 
1614     function provide(uint256 value) external onlyFrozen(msg.sender) notPaused {
1615         Require.that(
1616             totalBonded() > 0,
1617             FILE,
1618             "insufficient total bonded"
1619         );
1620 
1621         Require.that(
1622             totalRewarded() > 0,
1623             FILE,
1624             "insufficient total rewarded"
1625         );
1626 
1627         Require.that(
1628             balanceOfRewarded(msg.sender) >= value,
1629             FILE,
1630             "insufficient rewarded balance"
1631         );
1632 
1633         (uint256 lessUsdc, uint256 newUniv2) = addLiquidity(value);
1634 
1635         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom()).add(value);
1636         uint256 newPhantomFromBonded = totalRewardedWithPhantom.mul(newUniv2).div(totalBonded());
1637 
1638         incrementBalanceOfBonded(msg.sender, newUniv2);
1639         incrementBalanceOfPhantom(msg.sender, value.add(newPhantomFromBonded));
1640 
1641 
1642         balanceCheck();
1643 
1644         emit Provide(msg.sender, value, lessUsdc, newUniv2);
1645     }
1646 
1647     function emergencyWithdraw(address token, uint256 value) external onlyDao {
1648         IERC20(token).transfer(address(dao()), value);
1649     }
1650 
1651     function emergencyPause() external onlyDao {
1652         pause();
1653     }
1654 
1655     function balanceCheck() private {
1656         Require.that(
1657             univ2().balanceOf(address(this)) >= totalStaged().add(totalBonded()),
1658             FILE,
1659             "Inconsistent UNI-V2 balances"
1660         );
1661     }
1662 
1663     modifier onlyFrozen(address account) {
1664         Require.that(
1665             statusOf(account) == PoolAccount.Status.Frozen,
1666             FILE,
1667             "Not frozen"
1668         );
1669 
1670         _;
1671     }
1672 
1673     modifier onlyDao() {
1674         Require.that(
1675             msg.sender == address(dao()),
1676             FILE,
1677             "Not dao"
1678         );
1679 
1680         _;
1681     }
1682 
1683     modifier notPaused() {
1684         Require.that(
1685             !paused(),
1686             FILE,
1687             "Paused"
1688         );
1689 
1690         _;
1691     }
1692 }