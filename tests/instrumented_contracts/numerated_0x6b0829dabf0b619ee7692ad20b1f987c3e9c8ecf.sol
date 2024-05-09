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
644     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
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
909     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
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
928     uint256 private constant BOOTSTRAPPING_PERIOD = 150; // 150 epochs
929     uint256 private constant BOOTSTRAPPING_PRICE = 154e16; // 1.54 USDC (targeting 4.5% inflation)
930 
931     /* Oracle */
932     address private constant USDC = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
933     uint256 private constant ORACLE_RESERVE_MINIMUM = 1e10; // 10,000 USDC
934 
935     /* Bonding */
936     uint256 private constant INITIAL_STAKE_MULTIPLE = 1e6; // 100 DSD -> 100M DSDS
937 
938     /* Epoch */
939     struct EpochStrategy {
940         uint256 offset;
941         uint256 start;
942         uint256 period;
943     }
944 
945     uint256 private constant EPOCH_OFFSET = 0;
946     uint256 private constant EPOCH_START = 1606348800;
947     uint256 private constant EPOCH_PERIOD = 7200;
948 
949     /* Governance */
950     uint256 private constant GOVERNANCE_PERIOD = 36;
951     uint256 private constant GOVERNANCE_QUORUM = 20e16; // 20%
952     uint256 private constant GOVERNANCE_PROPOSAL_THRESHOLD = 5e15; // 0.5%
953     uint256 private constant GOVERNANCE_SUPER_MAJORITY = 66e16; // 66%
954     uint256 private constant GOVERNANCE_EMERGENCY_DELAY = 6; // 6 epochs
955 
956     /* DAO */
957     uint256 private constant ADVANCE_INCENTIVE = 150e18; // 150 DSD
958     uint256 private constant DAO_EXIT_LOCKUP_EPOCHS = 36; // 36 epochs fluid
959 
960     /* Pool */
961     uint256 private constant POOL_EXIT_LOCKUP_EPOCHS = 12; // 12 epochs fluid
962 
963     /* Market */
964     uint256 private constant COUPON_EXPIRATION = 360;
965     uint256 private constant DEBT_RATIO_CAP = 35e16; // 35%
966     uint256 private constant INITIAL_COUPON_REDEMPTION_PENALTY = 50e16; // 50%
967     uint256 private constant COUPON_REDEMPTION_PENALTY_DECAY = 3600; // 1 hour
968 
969     /* Regulator */
970     uint256 private constant SUPPLY_CHANGE_LIMIT = 2e16; // 2%
971     uint256 private constant SUPPLY_CHANGE_DIVISOR = 25e18; // 25 > Max expansion at 1.5
972     uint256 private constant COUPON_SUPPLY_CHANGE_LIMIT = 3e16; // 3%
973     uint256 private constant COUPON_SUPPLY_CHANGE_DIVISOR = 1666e16; // 16.66 > Max expansion at ~1.5
974     uint256 private constant NEGATIVE_SUPPLY_CHANGE_DIVISOR = 5e18; // 5 > Max negative expansion at 0.9
975     uint256 private constant ORACLE_POOL_RATIO = 40; // 40%
976 
977     /* Deployed */
978     address private constant DAO_ADDRESS = address(0x6Bf977ED1A09214E6209F4EA5f525261f1A2690a);
979     address private constant DOLLAR_ADDRESS = address(0xBD2F0Cd039E0BFcf88901C98c0bFAc5ab27566e3);
980     address private constant PAIR_ADDRESS = address(0x66e33d2605c5fB25eBb7cd7528E7997b0afA55E8);
981 
982     /**
983      * Getters
984      */
985     function getUsdcAddress() internal pure returns (address) {
986         return USDC;
987     }
988 
989     function getOracleReserveMinimum() internal pure returns (uint256) {
990         return ORACLE_RESERVE_MINIMUM;
991     }
992 
993     function getEpochStrategy() internal pure returns (EpochStrategy memory) {
994         return EpochStrategy({
995             offset: EPOCH_OFFSET,
996             start: EPOCH_START,
997             period: EPOCH_PERIOD
998         });
999     }
1000 
1001     function getInitialStakeMultiple() internal pure returns (uint256) {
1002         return INITIAL_STAKE_MULTIPLE;
1003     }
1004 
1005     function getBootstrappingPeriod() internal pure returns (uint256) {
1006         return BOOTSTRAPPING_PERIOD;
1007     }
1008 
1009     function getBootstrappingPrice() internal pure returns (Decimal.D256 memory) {
1010         return Decimal.D256({value: BOOTSTRAPPING_PRICE});
1011     }
1012 
1013     function getGovernancePeriod() internal pure returns (uint256) {
1014         return GOVERNANCE_PERIOD;
1015     }
1016 
1017     function getGovernanceQuorum() internal pure returns (Decimal.D256 memory) {
1018         return Decimal.D256({value: GOVERNANCE_QUORUM});
1019     }
1020 
1021     function getGovernanceProposalThreshold() internal pure returns (Decimal.D256 memory) {
1022         return Decimal.D256({value: GOVERNANCE_PROPOSAL_THRESHOLD});
1023     }
1024 
1025     function getGovernanceSuperMajority() internal pure returns (Decimal.D256 memory) {
1026         return Decimal.D256({value: GOVERNANCE_SUPER_MAJORITY});
1027     }
1028 
1029     function getGovernanceEmergencyDelay() internal pure returns (uint256) {
1030         return GOVERNANCE_EMERGENCY_DELAY;
1031     }
1032 
1033     function getAdvanceIncentive() internal pure returns (uint256) {
1034         return ADVANCE_INCENTIVE;
1035     }
1036 
1037     function getDAOExitLockupEpochs() internal pure returns (uint256) {
1038         return DAO_EXIT_LOCKUP_EPOCHS;
1039     }
1040 
1041     function getPoolExitLockupEpochs() internal pure returns (uint256) {
1042         return POOL_EXIT_LOCKUP_EPOCHS;
1043     }
1044 
1045     function getCouponExpiration() internal pure returns (uint256) {
1046         return COUPON_EXPIRATION;
1047     }
1048 
1049     function getDebtRatioCap() internal pure returns (Decimal.D256 memory) {
1050         return Decimal.D256({value: DEBT_RATIO_CAP});
1051     }
1052     
1053     function getInitialCouponRedemptionPenalty() internal pure returns (Decimal.D256 memory) {
1054         return Decimal.D256({value: INITIAL_COUPON_REDEMPTION_PENALTY});
1055     }
1056 
1057     function getCouponRedemptionPenaltyDecay() internal pure returns (uint256) {
1058         return COUPON_REDEMPTION_PENALTY_DECAY;
1059     }
1060 
1061     function getSupplyChangeLimit() internal pure returns (Decimal.D256 memory) {
1062         return Decimal.D256({value: SUPPLY_CHANGE_LIMIT});
1063     }
1064 
1065     function getSupplyChangeDivisor() internal pure returns (Decimal.D256 memory) {
1066         return Decimal.D256({value: SUPPLY_CHANGE_DIVISOR});
1067     }
1068 
1069     function getCouponSupplyChangeLimit() internal pure returns (Decimal.D256 memory) {
1070         return Decimal.D256({value: COUPON_SUPPLY_CHANGE_LIMIT});
1071     }
1072 
1073     function getCouponSupplyChangeDivisor() internal pure returns (Decimal.D256 memory) {
1074         return Decimal.D256({value: COUPON_SUPPLY_CHANGE_DIVISOR});
1075     }
1076 
1077     function getNegativeSupplyChangeDivisor() internal pure returns (Decimal.D256 memory) {
1078         return Decimal.D256({value: NEGATIVE_SUPPLY_CHANGE_DIVISOR});
1079     }
1080 
1081     function getOraclePoolRatio() internal pure returns (uint256) {
1082         return ORACLE_POOL_RATIO;
1083     }
1084 
1085     function getChainId() internal pure returns (uint256) {
1086         return CHAIN_ID;
1087     }
1088 
1089     function getDaoAddress() internal pure returns (address) {
1090         return DAO_ADDRESS;
1091     }
1092 
1093     function getDollarAddress() internal pure returns (address) {
1094         return DOLLAR_ADDRESS;
1095     }
1096 
1097     function getPairAddress() internal pure returns (address) {
1098         return PAIR_ADDRESS;
1099     }
1100 }
1101 
1102 /*
1103     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
1104 
1105     Licensed under the Apache License, Version 2.0 (the "License");
1106     you may not use this file except in compliance with the License.
1107     You may obtain a copy of the License at
1108 
1109     http://www.apache.org/licenses/LICENSE-2.0
1110 
1111     Unless required by applicable law or agreed to in writing, software
1112     distributed under the License is distributed on an "AS IS" BASIS,
1113     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1114     See the License for the specific language governing permissions and
1115     limitations under the License.
1116 */
1117 contract IDollar is IERC20 {
1118     function burn(uint256 amount) public;
1119     function burnFrom(address account, uint256 amount) public;
1120     function mint(address account, uint256 amount) public returns (bool);
1121 }
1122 
1123 /*
1124     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
1125 
1126     Licensed under the Apache License, Version 2.0 (the "License");
1127     you may not use this file except in compliance with the License.
1128     You may obtain a copy of the License at
1129 
1130     http://www.apache.org/licenses/LICENSE-2.0
1131 
1132     Unless required by applicable law or agreed to in writing, software
1133     distributed under the License is distributed on an "AS IS" BASIS,
1134     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1135     See the License for the specific language governing permissions and
1136     limitations under the License.
1137 */
1138 contract IDAO {
1139     function epoch() external view returns (uint256);
1140 }
1141 
1142 /*
1143     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
1144 
1145     Licensed under the Apache License, Version 2.0 (the "License");
1146     you may not use this file except in compliance with the License.
1147     You may obtain a copy of the License at
1148 
1149     http://www.apache.org/licenses/LICENSE-2.0
1150 
1151     Unless required by applicable law or agreed to in writing, software
1152     distributed under the License is distributed on an "AS IS" BASIS,
1153     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1154     See the License for the specific language governing permissions and
1155     limitations under the License.
1156 */
1157 contract IUSDC {
1158     function isBlacklisted(address _account) external view returns (bool);
1159 }
1160 
1161 /*
1162     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
1163 
1164     Licensed under the Apache License, Version 2.0 (the "License");
1165     you may not use this file except in compliance with the License.
1166     You may obtain a copy of the License at
1167 
1168     http://www.apache.org/licenses/LICENSE-2.0
1169 
1170     Unless required by applicable law or agreed to in writing, software
1171     distributed under the License is distributed on an "AS IS" BASIS,
1172     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1173     See the License for the specific language governing permissions and
1174     limitations under the License.
1175 */
1176 contract PoolAccount {
1177     enum Status {
1178         Frozen,
1179         Fluid,
1180         Locked
1181     }
1182 
1183     struct State {
1184         uint256 staged;
1185         uint256 claimable;
1186         uint256 bonded;
1187         uint256 phantom;
1188         uint256 fluidUntil;
1189     }
1190 }
1191 
1192 contract PoolStorage {
1193     struct Provider {
1194         IDAO dao;
1195         IDollar dollar;
1196         IERC20 univ2;
1197     }
1198     
1199     struct Balance {
1200         uint256 staged;
1201         uint256 claimable;
1202         uint256 bonded;
1203         uint256 phantom;
1204     }
1205 
1206     struct State {
1207         Balance balance;
1208         Provider provider;
1209 
1210         bool paused;
1211 
1212         mapping(address => PoolAccount.State) accounts;
1213     }
1214 }
1215 
1216 contract PoolState {
1217     PoolStorage.State _state;
1218 }
1219 
1220 /*
1221     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
1222 
1223     Licensed under the Apache License, Version 2.0 (the "License");
1224     you may not use this file except in compliance with the License.
1225     You may obtain a copy of the License at
1226 
1227     http://www.apache.org/licenses/LICENSE-2.0
1228 
1229     Unless required by applicable law or agreed to in writing, software
1230     distributed under the License is distributed on an "AS IS" BASIS,
1231     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1232     See the License for the specific language governing permissions and
1233     limitations under the License.
1234 */
1235 contract PoolGetters is PoolState {
1236     using SafeMath for uint256;
1237 
1238     /**
1239      * Global
1240      */
1241 
1242     function usdc() public view returns (address) {
1243         return Constants.getUsdcAddress();
1244     }
1245 
1246     function dao() public view returns (IDAO) {
1247         return IDAO(Constants.getDaoAddress());
1248     }
1249 
1250     function dollar() public view returns (IDollar) {
1251         return IDollar(Constants.getDollarAddress());
1252     }
1253 
1254     function univ2() public view returns (IERC20) {
1255         return IERC20(Constants.getPairAddress());
1256     }
1257 
1258     function totalBonded() public view returns (uint256) {
1259         return _state.balance.bonded;
1260     }
1261 
1262     function totalStaged() public view returns (uint256) {
1263         return _state.balance.staged;
1264     }
1265 
1266     function totalClaimable() public view returns (uint256) {
1267         return _state.balance.claimable;
1268     }
1269 
1270     function totalPhantom() public view returns (uint256) {
1271         return _state.balance.phantom;
1272     }
1273 
1274     function totalRewarded() public view returns (uint256) {
1275         return dollar().balanceOf(address(this)).sub(totalClaimable());
1276     }
1277 
1278     function paused() public view returns (bool) {
1279         return _state.paused;
1280     }
1281 
1282     /**
1283      * Account
1284      */
1285 
1286     function balanceOfStaged(address account) public view returns (uint256) {
1287         return _state.accounts[account].staged;
1288     }
1289 
1290     function balanceOfClaimable(address account) public view returns (uint256) {
1291         return _state.accounts[account].claimable;
1292     }
1293 
1294     function balanceOfBonded(address account) public view returns (uint256) {
1295         return _state.accounts[account].bonded;
1296     }
1297 
1298     function balanceOfPhantom(address account) public view returns (uint256) {
1299         return _state.accounts[account].phantom;
1300     }
1301 
1302     function balanceOfRewarded(address account) public view returns (uint256) {
1303         uint256 totalBonded = totalBonded();
1304         if (totalBonded == 0) {
1305             return 0;
1306         }
1307 
1308         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom());
1309         uint256 balanceOfRewardedWithPhantom = totalRewardedWithPhantom
1310             .mul(balanceOfBonded(account))
1311             .div(totalBonded);
1312 
1313         uint256 balanceOfPhantom = balanceOfPhantom(account);
1314         if (balanceOfRewardedWithPhantom > balanceOfPhantom) {
1315             return balanceOfRewardedWithPhantom.sub(balanceOfPhantom);
1316         }
1317         return 0;
1318     }
1319 
1320     function fluidUntil(address account) public view returns (uint256) {
1321         return _state.accounts[account].fluidUntil;
1322     }
1323 
1324     function statusOf(address account) public view returns (PoolAccount.Status) {
1325         return epoch() >= _state.accounts[account].fluidUntil ?
1326             PoolAccount.Status.Frozen :
1327             PoolAccount.Status.Fluid;
1328     }
1329 
1330     /**
1331      * Epoch
1332      */
1333 
1334     function epoch() internal view returns (uint256) {
1335         return dao().epoch();
1336     }
1337 }
1338 
1339 /*
1340     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
1341 
1342     Licensed under the Apache License, Version 2.0 (the "License");
1343     you may not use this file except in compliance with the License.
1344     You may obtain a copy of the License at
1345 
1346     http://www.apache.org/licenses/LICENSE-2.0
1347 
1348     Unless required by applicable law or agreed to in writing, software
1349     distributed under the License is distributed on an "AS IS" BASIS,
1350     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1351     See the License for the specific language governing permissions and
1352     limitations under the License.
1353 */
1354 contract PoolSetters is PoolState, PoolGetters {
1355     using SafeMath for uint256;
1356 
1357     /**
1358      * Global
1359      */
1360 
1361     function pause() internal {
1362         _state.paused = true;
1363     }
1364 
1365     /**
1366      * Account
1367      */
1368 
1369     function incrementBalanceOfBonded(address account, uint256 amount) internal {
1370         _state.accounts[account].bonded = _state.accounts[account].bonded.add(amount);
1371         _state.balance.bonded = _state.balance.bonded.add(amount);
1372     }
1373 
1374     function decrementBalanceOfBonded(address account, uint256 amount, string memory reason) internal {
1375         _state.accounts[account].bonded = _state.accounts[account].bonded.sub(amount, reason);
1376         _state.balance.bonded = _state.balance.bonded.sub(amount, reason);
1377     }
1378 
1379     function incrementBalanceOfStaged(address account, uint256 amount) internal {
1380         _state.accounts[account].staged = _state.accounts[account].staged.add(amount);
1381         _state.balance.staged = _state.balance.staged.add(amount);
1382     }
1383 
1384     function decrementBalanceOfStaged(address account, uint256 amount, string memory reason) internal {
1385         _state.accounts[account].staged = _state.accounts[account].staged.sub(amount, reason);
1386         _state.balance.staged = _state.balance.staged.sub(amount, reason);
1387     }
1388 
1389     function incrementBalanceOfClaimable(address account, uint256 amount) internal {
1390         _state.accounts[account].claimable = _state.accounts[account].claimable.add(amount);
1391         _state.balance.claimable = _state.balance.claimable.add(amount);
1392     }
1393 
1394     function decrementBalanceOfClaimable(address account, uint256 amount, string memory reason) internal {
1395         _state.accounts[account].claimable = _state.accounts[account].claimable.sub(amount, reason);
1396         _state.balance.claimable = _state.balance.claimable.sub(amount, reason);
1397     }
1398 
1399     function incrementBalanceOfPhantom(address account, uint256 amount) internal {
1400         _state.accounts[account].phantom = _state.accounts[account].phantom.add(amount);
1401         _state.balance.phantom = _state.balance.phantom.add(amount);
1402     }
1403 
1404     function decrementBalanceOfPhantom(address account, uint256 amount, string memory reason) internal {
1405         _state.accounts[account].phantom = _state.accounts[account].phantom.sub(amount, reason);
1406         _state.balance.phantom = _state.balance.phantom.sub(amount, reason);
1407     }
1408 
1409     function unfreeze(address account) internal {
1410         _state.accounts[account].fluidUntil = epoch().add(Constants.getPoolExitLockupEpochs());
1411     }
1412 }
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
1465 library UniswapV2Library {
1466     using SafeMath for uint;
1467 
1468     // returns sorted token addresses, used to handle return values from pairs sorted in this order
1469     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
1470         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
1471         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
1472         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
1473     }
1474 
1475     // calculates the CREATE2 address for a pair without making any external calls
1476     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
1477         (address token0, address token1) = sortTokens(tokenA, tokenB);
1478         pair = address(uint(keccak256(abi.encodePacked(
1479                 hex'ff',
1480                 factory,
1481                 keccak256(abi.encodePacked(token0, token1)),
1482                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
1483             ))));
1484     }
1485 
1486     // fetches and sorts the reserves for a pair
1487     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
1488         (address token0,) = sortTokens(tokenA, tokenB);
1489         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
1490         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1491     }
1492 
1493     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
1494     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
1495         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
1496         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
1497         amountB = amountA.mul(reserveB) / reserveA;
1498     }
1499 }
1500 
1501 /*
1502     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
1503 
1504     Licensed under the Apache License, Version 2.0 (the "License");
1505     you may not use this file except in compliance with the License.
1506     You may obtain a copy of the License at
1507 
1508     http://www.apache.org/licenses/LICENSE-2.0
1509 
1510     Unless required by applicable law or agreed to in writing, software
1511     distributed under the License is distributed on an "AS IS" BASIS,
1512     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1513     See the License for the specific language governing permissions and
1514     limitations under the License.
1515 */
1516 contract Liquidity is PoolGetters {
1517     address private constant UNISWAP_FACTORY = address(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
1518 
1519     function addLiquidity(uint256 dollarAmount) internal returns (uint256, uint256) {
1520         (address dollar, address usdc) = (address(dollar()), usdc());
1521         (uint reserveA, uint reserveB) = getReserves(dollar, usdc);
1522 
1523         uint256 usdcAmount = (reserveA == 0 && reserveB == 0) ?
1524              dollarAmount :
1525              UniswapV2Library.quote(dollarAmount, reserveA, reserveB);
1526 
1527         address pair = address(univ2());
1528         IERC20(dollar).transfer(pair, dollarAmount);
1529         IERC20(usdc).transferFrom(msg.sender, pair, usdcAmount);
1530         return (usdcAmount, IUniswapV2Pair(pair).mint(address(this)));
1531     }
1532 
1533     // overridable for testing
1534     function getReserves(address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
1535         (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
1536         (uint reserve0, uint reserve1,) = IUniswapV2Pair(UniswapV2Library.pairFor(UNISWAP_FACTORY, tokenA, tokenB)).getReserves();
1537         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1538     }
1539 }
1540 
1541 /*
1542     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
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
1556 contract Pool is PoolSetters, Liquidity {
1557     using SafeMath for uint256;
1558 
1559     constructor() public { }
1560 
1561     bytes32 private constant FILE = "Pool";
1562 
1563     event Deposit(address indexed account, uint256 value);
1564     event Withdraw(address indexed account, uint256 value);
1565     event Claim(address indexed account, uint256 value);
1566     event Bond(address indexed account, uint256 start, uint256 value);
1567     event Unbond(address indexed account, uint256 start, uint256 value, uint256 newClaimable);
1568     event Provide(address indexed account, uint256 value, uint256 lessUsdc, uint256 newUniv2);
1569 
1570     function deposit(uint256 value) external onlyFrozen(msg.sender) notPaused {
1571         univ2().transferFrom(msg.sender, address(this), value);
1572         incrementBalanceOfStaged(msg.sender, value);
1573 
1574         balanceCheck();
1575 
1576         emit Deposit(msg.sender, value);
1577     }
1578 
1579     function withdraw(uint256 value) external onlyFrozen(msg.sender) {
1580         univ2().transfer(msg.sender, value);
1581         decrementBalanceOfStaged(msg.sender, value, "Pool: insufficient staged balance");
1582 
1583         balanceCheck();
1584 
1585         emit Withdraw(msg.sender, value);
1586     }
1587 
1588     function claim(uint256 value) external onlyFrozen(msg.sender) {
1589         dollar().transfer(msg.sender, value);
1590         decrementBalanceOfClaimable(msg.sender, value, "Pool: insufficient claimable balance");
1591 
1592         balanceCheck();
1593 
1594         emit Claim(msg.sender, value);
1595     }
1596 
1597     function bond(uint256 value) external notPaused {
1598         unfreeze(msg.sender);
1599 
1600         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom());
1601         uint256 newPhantom = totalBonded() == 0 ?
1602             totalRewarded() == 0 ? Constants.getInitialStakeMultiple().mul(value) : 0 :
1603             totalRewardedWithPhantom.mul(value).div(totalBonded());
1604 
1605         incrementBalanceOfBonded(msg.sender, value);
1606         incrementBalanceOfPhantom(msg.sender, newPhantom);
1607         decrementBalanceOfStaged(msg.sender, value, "Pool: insufficient staged balance");
1608 
1609         balanceCheck();
1610 
1611         emit Bond(msg.sender, epoch().add(1), value);
1612     }
1613 
1614     function unbond(uint256 value) external {
1615         unfreeze(msg.sender);
1616 
1617         uint256 balanceOfBonded = balanceOfBonded(msg.sender);
1618         Require.that(
1619             balanceOfBonded > 0,
1620             FILE,
1621             "insufficient bonded balance"
1622         );
1623 
1624         uint256 newClaimable = balanceOfRewarded(msg.sender).mul(value).div(balanceOfBonded);
1625         uint256 lessPhantom = balanceOfPhantom(msg.sender).mul(value).div(balanceOfBonded);
1626 
1627         incrementBalanceOfStaged(msg.sender, value);
1628         incrementBalanceOfClaimable(msg.sender, newClaimable);
1629         decrementBalanceOfBonded(msg.sender, value, "Pool: insufficient bonded balance");
1630         decrementBalanceOfPhantom(msg.sender, lessPhantom, "Pool: insufficient phantom balance");
1631 
1632         balanceCheck();
1633 
1634         emit Unbond(msg.sender, epoch().add(1), value, newClaimable);
1635     }
1636 
1637     function provide(uint256 value) external notPaused {
1638         Require.that(
1639             totalBonded() > 0,
1640             FILE,
1641             "insufficient total bonded"
1642         );
1643 
1644         Require.that(
1645             totalRewarded() > 0,
1646             FILE,
1647             "insufficient total rewarded"
1648         );
1649 
1650         Require.that(
1651             balanceOfRewarded(msg.sender) >= value,
1652             FILE,
1653             "insufficient rewarded balance"
1654         );
1655 
1656         (uint256 lessUsdc, uint256 newUniv2) = addLiquidity(value);
1657 
1658         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom()).add(value);
1659         uint256 newPhantomFromBonded = totalRewardedWithPhantom.mul(newUniv2).div(totalBonded());
1660 
1661         incrementBalanceOfBonded(msg.sender, newUniv2);
1662         incrementBalanceOfPhantom(msg.sender, value.add(newPhantomFromBonded));
1663 
1664 
1665         balanceCheck();
1666 
1667         emit Provide(msg.sender, value, lessUsdc, newUniv2);
1668     }
1669 
1670     function emergencyWithdraw(address token, uint256 value) external onlyDao {
1671         IERC20(token).transfer(address(dao()), value);
1672     }
1673 
1674     function emergencyPause() external onlyDao {
1675         pause();
1676     }
1677 
1678     function balanceCheck() private {
1679         Require.that(
1680             univ2().balanceOf(address(this)) >= totalStaged().add(totalBonded()),
1681             FILE,
1682             "Inconsistent UNI-V2 balances"
1683         );
1684     }
1685 
1686     modifier onlyFrozen(address account) {
1687         Require.that(
1688             statusOf(account) == PoolAccount.Status.Frozen,
1689             FILE,
1690             "Not frozen"
1691         );
1692 
1693         _;
1694     }
1695 
1696     modifier onlyDao() {
1697         Require.that(
1698             msg.sender == address(dao()),
1699             FILE,
1700             "Not dao"
1701         );
1702 
1703         _;
1704     }
1705 
1706     modifier notPaused() {
1707         Require.that(
1708             !paused(),
1709             FILE,
1710             "Paused"
1711         );
1712 
1713         _;
1714     }
1715 }