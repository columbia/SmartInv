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
642 /**
643  * @title Decimal
644  * @author dYdX
645  *
646  * Library that defines a fixed-point number with 18 decimal places.
647  */
648 library Decimal {
649     using SafeMath for uint256;
650 
651     // ============ Constants ============
652 
653     uint256 constant BASE = 10**18;
654 
655     // ============ Structs ============
656 
657     struct D256 {
658         uint256 value;
659     }
660 
661     // ============ Static Functions ============
662 
663     function zero() internal pure returns (D256 memory) {
664         return D256({value: 0});
665     }
666 
667     function one() internal pure returns (D256 memory) {
668         return D256({value: BASE});
669     }
670 
671     function from(uint256 a) internal pure returns (D256 memory) {
672         return D256({value: a.mul(BASE)});
673     }
674 
675     function ratio(uint256 a, uint256 b) internal pure returns (D256 memory) {
676         return D256({value: getPartial(a, BASE, b)});
677     }
678 
679     // ============ Self Functions ============
680 
681     function add(D256 memory self, uint256 b)
682         internal
683         pure
684         returns (D256 memory)
685     {
686         return D256({value: self.value.add(b.mul(BASE))});
687     }
688 
689     function sub(D256 memory self, uint256 b)
690         internal
691         pure
692         returns (D256 memory)
693     {
694         return D256({value: self.value.sub(b.mul(BASE))});
695     }
696 
697     function sub(
698         D256 memory self,
699         uint256 b,
700         string memory reason
701     ) internal pure returns (D256 memory) {
702         return D256({value: self.value.sub(b.mul(BASE), reason)});
703     }
704 
705     function mul(D256 memory self, uint256 b)
706         internal
707         pure
708         returns (D256 memory)
709     {
710         return D256({value: self.value.mul(b)});
711     }
712 
713     function div(D256 memory self, uint256 b)
714         internal
715         pure
716         returns (D256 memory)
717     {
718         return D256({value: self.value.div(b)});
719     }
720 
721     function pow(D256 memory self, uint256 b)
722         internal
723         pure
724         returns (D256 memory)
725     {
726         if (b == 0) {
727             return from(1);
728         }
729 
730         D256 memory temp = D256({value: self.value});
731         for (uint256 i = 1; i < b; i++) {
732             temp = mul(temp, self);
733         }
734 
735         return temp;
736     }
737 
738     function add(D256 memory self, D256 memory b)
739         internal
740         pure
741         returns (D256 memory)
742     {
743         return D256({value: self.value.add(b.value)});
744     }
745 
746     function sub(D256 memory self, D256 memory b)
747         internal
748         pure
749         returns (D256 memory)
750     {
751         return D256({value: self.value.sub(b.value)});
752     }
753 
754     function sub(
755         D256 memory self,
756         D256 memory b,
757         string memory reason
758     ) internal pure returns (D256 memory) {
759         return D256({value: self.value.sub(b.value, reason)});
760     }
761 
762     function mul(D256 memory self, D256 memory b)
763         internal
764         pure
765         returns (D256 memory)
766     {
767         return D256({value: getPartial(self.value, b.value, BASE)});
768     }
769 
770     function div(D256 memory self, D256 memory b)
771         internal
772         pure
773         returns (D256 memory)
774     {
775         return D256({value: getPartial(self.value, BASE, b.value)});
776     }
777 
778     function equals(D256 memory self, D256 memory b)
779         internal
780         pure
781         returns (bool)
782     {
783         return self.value == b.value;
784     }
785 
786     function greaterThan(D256 memory self, D256 memory b)
787         internal
788         pure
789         returns (bool)
790     {
791         return compareTo(self, b) == 2;
792     }
793 
794     function lessThan(D256 memory self, D256 memory b)
795         internal
796         pure
797         returns (bool)
798     {
799         return compareTo(self, b) == 0;
800     }
801 
802     function greaterThanOrEqualTo(D256 memory self, D256 memory b)
803         internal
804         pure
805         returns (bool)
806     {
807         return compareTo(self, b) > 0;
808     }
809 
810     function lessThanOrEqualTo(D256 memory self, D256 memory b)
811         internal
812         pure
813         returns (bool)
814     {
815         return compareTo(self, b) < 2;
816     }
817 
818     function isZero(D256 memory self) internal pure returns (bool) {
819         return self.value == 0;
820     }
821 
822     function asUint256(D256 memory self) internal pure returns (uint256) {
823         return self.value.div(BASE);
824     }
825 
826     // ============ Core Methods ============
827 
828     function getPartial(
829         uint256 target,
830         uint256 numerator,
831         uint256 denominator
832     ) private pure returns (uint256) {
833         return target.mul(numerator).div(denominator);
834     }
835 
836     function compareTo(D256 memory a, D256 memory b)
837         private
838         pure
839         returns (uint256)
840     {
841         if (a.value == b.value) {
842             return 1;
843         }
844         return a.value > b.value ? 2 : 0;
845     }
846 }
847 
848 library Constants {
849     /* Chain */
850     uint256 private constant CHAIN_ID = 1; // Mainnet
851 
852     /* Bootstrapping */
853     uint256 private constant BOOTSTRAPPING_PERIOD = 672; // 14 days
854     uint256 private constant BOOTSTRAPPING_PRICE = 1078280614764947472; // Should be 0.1 difference between peg
855 
856     /* Oracle */
857     address private constant CRV3 =
858         address(0x6c3F90f043a72FA612cbac8115EE7e52BDe6E490); // Anywhere the term CRV3 is refernenced, consider that as "peg", really
859     uint256 private constant ORACLE_RESERVE_MINIMUM = 1e22; // 10,000 T
860 
861     /* Bonding */
862     uint256 private constant INITIAL_STAKE_MULTIPLE = 1e6; // 100 T -> 100M TS
863 
864     /* Epoch */
865     struct EpochStrategy {
866         uint256 offset;
867         uint256 start;
868         uint256 period;
869     }
870 
871     uint256 private constant CURRENT_EPOCH_OFFSET = 0;
872     uint256 private constant CURRENT_EPOCH_START = 1667790000;
873     uint256 private constant CURRENT_EPOCH_PERIOD = 1800;
874 
875     /* Forge */
876     uint256 private constant ADVANCE_INCENTIVE_IN_3CRV = 75 * 10**18; // 75 3CRV
877     uint256 private constant ADVANCE_INCENTIVE_IN_T_MAX = 5000 * 10**18; // 5000 T
878 
879     uint256 private constant FORGE_EXIT_LOCKUP_EPOCHS = 240; // 5 days fluid
880 
881     /* Pool */
882     uint256 private constant POOL_EXIT_LOCKUP_EPOCHS = 144; // 3 days fluid
883 
884     /* Market */
885     uint256 private constant COUPON_EXPIRATION = 8640; // 180 days
886     uint256 private constant DEBT_RATIO_CAP = 20e16; // 20%
887 
888     /* Regulator */
889     uint256 private constant SUPPLY_CHANGE_LIMIT = 1e16; // 1%
890     uint256 private constant COUPON_SUPPLY_CHANGE_LIMIT = 2e16; // 2%
891     uint256 private constant ORACLE_POOL_RATIO = 50; // 50%
892     uint256 private constant TREASURY_RATIO = 0; // 0%
893 
894     /* Deployed */
895     address private constant TREASURY_ADDRESS =
896         address(0x0000000000000000000000000000000000000000);
897 
898     /**
899      * Getters
900      */
901 
902     function getCrv3Address() internal pure returns (address) {
903         return CRV3;
904     }
905 
906     function getOracleReserveMinimum() internal pure returns (uint256) {
907         return ORACLE_RESERVE_MINIMUM;
908     }
909 
910     function getCurrentEpochStrategy()
911         internal
912         pure
913         returns (EpochStrategy memory)
914     {
915         return
916             EpochStrategy({
917                 offset: CURRENT_EPOCH_OFFSET,
918                 start: CURRENT_EPOCH_START,
919                 period: CURRENT_EPOCH_PERIOD
920             });
921     }
922 
923     function getInitialStakeMultiple() internal pure returns (uint256) {
924         return INITIAL_STAKE_MULTIPLE;
925     }
926 
927     function getBootstrappingPeriod() internal pure returns (uint256) {
928         return BOOTSTRAPPING_PERIOD;
929     }
930 
931     function getBootstrappingPrice()
932         internal
933         pure
934         returns (Decimal.D256 memory)
935     {
936         return Decimal.D256({value: BOOTSTRAPPING_PRICE});
937     }
938 
939     function getAdvanceIncentive() internal pure returns (uint256) {
940         return ADVANCE_INCENTIVE_IN_3CRV;
941     }
942 
943     function getMaxAdvanceTIncentive() internal pure returns (uint256) {
944         return ADVANCE_INCENTIVE_IN_T_MAX;
945     }
946 
947     function getForgeExitLockupEpochs() internal pure returns (uint256) {
948         return FORGE_EXIT_LOCKUP_EPOCHS;
949     }
950 
951     function getPoolExitLockupEpochs() internal pure returns (uint256) {
952         return POOL_EXIT_LOCKUP_EPOCHS;
953     }
954 
955     function getCouponExpiration() internal pure returns (uint256) {
956         return COUPON_EXPIRATION;
957     }
958 
959     function getDebtRatioCap() internal pure returns (Decimal.D256 memory) {
960         return Decimal.D256({value: DEBT_RATIO_CAP});
961     }
962 
963     function getSupplyChangeLimit()
964         internal
965         pure
966         returns (Decimal.D256 memory)
967     {
968         return Decimal.D256({value: SUPPLY_CHANGE_LIMIT});
969     }
970 
971     function getCouponSupplyChangeLimit()
972         internal
973         pure
974         returns (Decimal.D256 memory)
975     {
976         return Decimal.D256({value: COUPON_SUPPLY_CHANGE_LIMIT});
977     }
978 
979     function getOraclePoolRatio() internal pure returns (uint256) {
980         return ORACLE_POOL_RATIO;
981     }
982 
983     function getTreasuryRatio() internal pure returns (uint256) {
984         return TREASURY_RATIO;
985     }
986 
987     function getChainId() internal pure returns (uint256) {
988         return CHAIN_ID;
989     }
990 
991     function getTreasuryAddress() internal pure returns (address) {
992         return TREASURY_ADDRESS;
993     }
994 }
995 
996 contract IDollar is IERC20 {
997     function burn(uint256 amount) public;
998 
999     function burnFrom(address account, uint256 amount) public;
1000 
1001     function mint(address account, uint256 amount) public returns (bool);
1002 }
1003 
1004 contract IForge {
1005     function epoch() external view returns (uint256);
1006 }
1007 
1008 contract PoolAccount {
1009     enum Status {
1010         Frozen,
1011         Fluid,
1012         Locked
1013     }
1014 
1015     struct State {
1016         uint256 staged;
1017         uint256 claimable;
1018         uint256 bonded;
1019         uint256 phantom;
1020         uint256 fluidUntil;
1021     }
1022 }
1023 
1024 contract PoolStorage {
1025     struct Provider {
1026         IForge dao;
1027         IDollar dollar;
1028         IERC20 lpToken;
1029     }
1030 
1031     struct Balance {
1032         uint256 staged;
1033         uint256 claimable;
1034         uint256 bonded;
1035         uint256 phantom;
1036     }
1037 
1038     struct State {
1039         Balance balance;
1040         Provider provider;
1041         bool paused;
1042         mapping(address => PoolAccount.State) accounts;
1043     }
1044 }
1045 
1046 contract PoolState {
1047     PoolStorage.State _state;
1048 }
1049 
1050 contract PoolGetters is PoolState {
1051     using SafeMath for uint256;
1052 
1053     /**
1054      * Global
1055      */
1056 
1057     function crv3() public view returns (address) {
1058         return Constants.getCrv3Address();
1059     }
1060 
1061     function dao() public view returns (IForge) {
1062         return _state.provider.dao;
1063     }
1064 
1065     function dollar() public view returns (IDollar) {
1066         return _state.provider.dollar;
1067     }
1068 
1069     function lpToken() public view returns (IERC20) {
1070         return _state.provider.lpToken;
1071     }
1072 
1073     function totalBonded() public view returns (uint256) {
1074         return _state.balance.bonded;
1075     }
1076 
1077     function totalStaged() public view returns (uint256) {
1078         return _state.balance.staged;
1079     }
1080 
1081     function totalClaimable() public view returns (uint256) {
1082         return _state.balance.claimable;
1083     }
1084 
1085     function totalPhantom() public view returns (uint256) {
1086         return _state.balance.phantom;
1087     }
1088 
1089     function totalRewarded() public view returns (uint256) {
1090         return dollar().balanceOf(address(this)).sub(totalClaimable());
1091     }
1092 
1093     function paused() public view returns (bool) {
1094         return _state.paused;
1095     }
1096 
1097     /**
1098      * Account
1099      */
1100 
1101     function balanceOfStaged(address account) public view returns (uint256) {
1102         return _state.accounts[account].staged;
1103     }
1104 
1105     function balanceOfClaimable(address account) public view returns (uint256) {
1106         return _state.accounts[account].claimable;
1107     }
1108 
1109     function balanceOfBonded(address account) public view returns (uint256) {
1110         return _state.accounts[account].bonded;
1111     }
1112 
1113     function balanceOfPhantom(address account) public view returns (uint256) {
1114         return _state.accounts[account].phantom;
1115     }
1116 
1117     function balanceOfRewarded(address account) public view returns (uint256) {
1118         uint256 totalBonded = totalBonded();
1119         if (totalBonded == 0) {
1120             return 0;
1121         }
1122 
1123         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom());
1124         uint256 balanceOfRewardedWithPhantom = totalRewardedWithPhantom
1125             .mul(balanceOfBonded(account))
1126             .div(totalBonded);
1127 
1128         uint256 balanceOfPhantom = balanceOfPhantom(account);
1129         if (balanceOfRewardedWithPhantom > balanceOfPhantom) {
1130             return balanceOfRewardedWithPhantom.sub(balanceOfPhantom);
1131         }
1132         return 0;
1133     }
1134 
1135     function fluidUntil(address account) public view returns (uint256) {
1136         return _state.accounts[account].fluidUntil;
1137     }
1138 
1139     function statusOf(address account)
1140         public
1141         view
1142         returns (PoolAccount.Status)
1143     {
1144         return
1145             epoch() >= _state.accounts[account].fluidUntil
1146                 ? PoolAccount.Status.Frozen
1147                 : PoolAccount.Status.Fluid;
1148     }
1149 
1150     /**
1151      * Epoch
1152      */
1153 
1154     function epoch() internal view returns (uint256) {
1155         return dao().epoch();
1156     }
1157 }
1158 
1159 contract PoolSetters is PoolState, PoolGetters {
1160     using SafeMath for uint256;
1161 
1162     /**
1163      * Global
1164      */
1165 
1166     function pause() internal {
1167         _state.paused = true;
1168     }
1169 
1170     /**
1171      * Account
1172      */
1173 
1174     function incrementBalanceOfBonded(address account, uint256 amount)
1175         internal
1176     {
1177         _state.accounts[account].bonded = _state.accounts[account].bonded.add(
1178             amount
1179         );
1180         _state.balance.bonded = _state.balance.bonded.add(amount);
1181     }
1182 
1183     function decrementBalanceOfBonded(
1184         address account,
1185         uint256 amount,
1186         string memory reason
1187     ) internal {
1188         _state.accounts[account].bonded = _state.accounts[account].bonded.sub(
1189             amount,
1190             reason
1191         );
1192         _state.balance.bonded = _state.balance.bonded.sub(amount, reason);
1193     }
1194 
1195     function incrementBalanceOfStaged(address account, uint256 amount)
1196         internal
1197     {
1198         _state.accounts[account].staged = _state.accounts[account].staged.add(
1199             amount
1200         );
1201         _state.balance.staged = _state.balance.staged.add(amount);
1202     }
1203 
1204     function decrementBalanceOfStaged(
1205         address account,
1206         uint256 amount,
1207         string memory reason
1208     ) internal {
1209         _state.accounts[account].staged = _state.accounts[account].staged.sub(
1210             amount,
1211             reason
1212         );
1213         _state.balance.staged = _state.balance.staged.sub(amount, reason);
1214     }
1215 
1216     function incrementBalanceOfClaimable(address account, uint256 amount)
1217         internal
1218     {
1219         _state.accounts[account].claimable = _state
1220             .accounts[account]
1221             .claimable
1222             .add(amount);
1223         _state.balance.claimable = _state.balance.claimable.add(amount);
1224     }
1225 
1226     function decrementBalanceOfClaimable(
1227         address account,
1228         uint256 amount,
1229         string memory reason
1230     ) internal {
1231         _state.accounts[account].claimable = _state
1232             .accounts[account]
1233             .claimable
1234             .sub(amount, reason);
1235         _state.balance.claimable = _state.balance.claimable.sub(amount, reason);
1236     }
1237 
1238     function incrementBalanceOfPhantom(address account, uint256 amount)
1239         internal
1240     {
1241         _state.accounts[account].phantom = _state.accounts[account].phantom.add(
1242             amount
1243         );
1244         _state.balance.phantom = _state.balance.phantom.add(amount);
1245     }
1246 
1247     function decrementBalanceOfPhantom(
1248         address account,
1249         uint256 amount,
1250         string memory reason
1251     ) internal {
1252         _state.accounts[account].phantom = _state.accounts[account].phantom.sub(
1253             amount,
1254             reason
1255         );
1256         _state.balance.phantom = _state.balance.phantom.sub(amount, reason);
1257     }
1258 
1259     function unfreeze(address account) internal {
1260         _state.accounts[account].fluidUntil = epoch().add(
1261             Constants.getPoolExitLockupEpochs()
1262         );
1263     }
1264 }
1265 
1266 interface IUniswapV2Pair {
1267     event Approval(address indexed owner, address indexed spender, uint value);
1268     event Transfer(address indexed from, address indexed to, uint value);
1269 
1270     function name() external pure returns (string memory);
1271     function symbol() external pure returns (string memory);
1272     function decimals() external pure returns (uint8);
1273     function totalSupply() external view returns (uint);
1274     function balanceOf(address owner) external view returns (uint);
1275     function allowance(address owner, address spender) external view returns (uint);
1276 
1277     function approve(address spender, uint value) external returns (bool);
1278     function transfer(address to, uint value) external returns (bool);
1279     function transferFrom(address from, address to, uint value) external returns (bool);
1280 
1281     function DOMAIN_SEPARATOR() external view returns (bytes32);
1282     function PERMIT_TYPEHASH() external pure returns (bytes32);
1283     function nonces(address owner) external view returns (uint);
1284 
1285     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1286 
1287     event Mint(address indexed sender, uint amount0, uint amount1);
1288     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1289     event Swap(
1290         address indexed sender,
1291         uint amount0In,
1292         uint amount1In,
1293         uint amount0Out,
1294         uint amount1Out,
1295         address indexed to
1296     );
1297     event Sync(uint112 reserve0, uint112 reserve1);
1298 
1299     function MINIMUM_LIQUIDITY() external pure returns (uint);
1300     function factory() external view returns (address);
1301     function token0() external view returns (address);
1302     function token1() external view returns (address);
1303     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1304     function price0CumulativeLast() external view returns (uint);
1305     function price1CumulativeLast() external view returns (uint);
1306     function kLast() external view returns (uint);
1307 
1308     function mint(address to) external returns (uint liquidity);
1309     function burn(address to) external returns (uint amount0, uint amount1);
1310     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1311     function skim(address to) external;
1312     function sync() external;
1313 
1314     function initialize(address, address) external;
1315 }
1316 
1317 library UniswapV2Library {
1318     using SafeMath for uint;
1319 
1320     // returns sorted token addresses, used to handle return values from pairs sorted in this order
1321     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
1322         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
1323         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
1324         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
1325     }
1326 
1327     // calculates the CREATE2 address for a pair without making any external calls
1328     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
1329         (address token0, address token1) = sortTokens(tokenA, tokenB);
1330         pair = address(uint(keccak256(abi.encodePacked(
1331                 hex'ff',
1332                 factory,
1333                 keccak256(abi.encodePacked(token0, token1)),
1334                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
1335             ))));
1336     }
1337 
1338     // fetches and sorts the reserves for a pair
1339     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
1340         (address token0,) = sortTokens(tokenA, tokenB);
1341         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
1342         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1343     }
1344 
1345     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
1346     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
1347         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
1348         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
1349         amountB = amountA.mul(reserveB) / reserveA;
1350     }
1351 }
1352 
1353 interface IMetaPool {
1354     event Transfer(
1355         address indexed sender,
1356         address indexed receiver,
1357         uint256 value
1358     );
1359     event Approval(
1360         address indexed owner,
1361         address indexed spender,
1362         uint256 value
1363     );
1364     event TokenExchange(
1365         address indexed buyer,
1366         int128 sold_id,
1367         uint256 tokens_sold,
1368         int128 bought_id,
1369         uint256 tokens_bought
1370     );
1371     event TokenExchangeUnderlying(
1372         address indexed buyer,
1373         int128 sold_id,
1374         uint256 tokens_sold,
1375         int128 bought_id,
1376         uint256 tokens_bought
1377     );
1378     event AddLiquidity(
1379         address indexed provider,
1380         uint256[2] token_amounts,
1381         uint256[2] fees,
1382         uint256 invariant,
1383         uint256 token_supply
1384     );
1385     event RemoveLiquidity(
1386         address indexed provider,
1387         uint256[2] token_amounts,
1388         uint256[2] fees,
1389         uint256 token_supply
1390     );
1391     event RemoveLiquidityOne(
1392         address indexed provider,
1393         uint256 token_amount,
1394         uint256 coin_amount,
1395         uint256 token_supply
1396     );
1397     event RemoveLiquidityImbalance(
1398         address indexed provider,
1399         uint256[2] token_amounts,
1400         uint256[2] fees,
1401         uint256 invariant,
1402         uint256 token_supply
1403     );
1404     event CommitNewAdmin(uint256 indexed deadline, address indexed admin);
1405     event NewAdmin(address indexed admin);
1406     event CommitNewFee(
1407         uint256 indexed deadline,
1408         uint256 fee,
1409         uint256 admin_fee
1410     );
1411     event NewFee(uint256 fee, uint256 admin_fee);
1412     event RampA(
1413         uint256 old_A,
1414         uint256 new_A,
1415         uint256 initial_time,
1416         uint256 future_time
1417     );
1418     event StopRampA(uint256 A, uint256 t);
1419 
1420     function initialize(
1421         string calldata _name,
1422         string calldata _symbol,
1423         address _coin,
1424         uint256 _decimals,
1425         uint256 _A,
1426         uint256 _fee,
1427         address _admin
1428     ) external;
1429 
1430     function decimals() external view returns (uint256);
1431 
1432     function transfer(address _to, uint256 _value) external returns (bool);
1433 
1434     function transferFrom(
1435         address _from,
1436         address _to,
1437         uint256 _value
1438     ) external returns (bool);
1439 
1440     function approve(address _spender, uint256 _value) external returns (bool);
1441 
1442     function get_previous_balances() external view returns (uint256[2] memory);
1443 
1444     function get_balances() external view returns (uint256[2] memory);
1445 
1446     function get_twap_balances(
1447         uint256[2] calldata _first_balances,
1448         uint256[2] calldata _last_balances,
1449         uint256 _time_elapsed
1450     ) external view returns (uint256[2] memory);
1451 
1452     function get_price_cumulative_last()
1453         external
1454         view
1455         returns (uint256[2] memory);
1456 
1457     function admin_fee() external view returns (uint256);
1458 
1459     function A() external view returns (uint256);
1460 
1461     function A_precise() external view returns (uint256);
1462 
1463     function get_virtual_price() external view returns (uint256);
1464 
1465     function calc_token_amount(uint256[2] calldata _amounts, bool _is_deposit)
1466         external
1467         view
1468         returns (uint256);
1469 
1470     function calc_token_amount(
1471         uint256[2] calldata _amounts,
1472         bool _is_deposit,
1473         bool _previous
1474     ) external view returns (uint256);
1475 
1476     function add_liquidity(
1477         uint256[2] calldata _amounts,
1478         uint256 _min_mint_amount
1479     ) external returns (uint256);
1480 
1481     function add_liquidity(
1482         uint256[2] calldata _amounts,
1483         uint256 _min_mint_amount,
1484         address _receiver
1485     ) external returns (uint256);
1486 
1487     function get_dy(
1488         int128 i,
1489         int128 j,
1490         uint256 dx
1491     ) external view returns (uint256);
1492 
1493     function get_dy(
1494         int128 i,
1495         int128 j,
1496         uint256 dx,
1497         uint256[2] calldata _balances
1498     ) external view returns (uint256);
1499 
1500     function get_dy_underlying(
1501         int128 i,
1502         int128 j,
1503         uint256 dx
1504     ) external view returns (uint256);
1505 
1506     function get_dy_underlying(
1507         int128 i,
1508         int128 j,
1509         uint256 dx,
1510         uint256[2] calldata _balances
1511     ) external view returns (uint256);
1512 
1513     function exchange(
1514         int128 i,
1515         int128 j,
1516         uint256 dx,
1517         uint256 min_dy
1518     ) external returns (uint256);
1519 
1520     function exchange(
1521         int128 i,
1522         int128 j,
1523         uint256 dx,
1524         uint256 min_dy,
1525         address _receiver
1526     ) external returns (uint256);
1527 
1528     function exchange_underlying(
1529         int128 i,
1530         int128 j,
1531         uint256 dx,
1532         uint256 min_dy
1533     ) external returns (uint256);
1534 
1535     function exchange_underlying(
1536         int128 i,
1537         int128 j,
1538         uint256 dx,
1539         uint256 min_dy,
1540         address _receiver
1541     ) external returns (uint256);
1542 
1543     function remove_liquidity(
1544         uint256 _burn_amount,
1545         uint256[2] calldata _min_amounts
1546     ) external returns (uint256[2] memory);
1547 
1548     function remove_liquidity(
1549         uint256 _burn_amount,
1550         uint256[2] calldata _min_amounts,
1551         address _receiver
1552     ) external returns (uint256[2] memory);
1553 
1554     function remove_liquidity_imbalance(
1555         uint256[2] calldata _amounts,
1556         uint256 _max_burn_amount
1557     ) external returns (uint256);
1558 
1559     function remove_liquidity_imbalance(
1560         uint256[2] calldata _amounts,
1561         uint256 _max_burn_amount,
1562         address _receiver
1563     ) external returns (uint256);
1564 
1565     function calc_withdraw_one_coin(uint256 _burn_amount, int128 i)
1566         external
1567         view
1568         returns (uint256);
1569 
1570     function calc_withdraw_one_coin(
1571         uint256 _burn_amount,
1572         int128 i,
1573         bool _previous
1574     ) external view returns (uint256);
1575 
1576     function remove_liquidity_one_coin(
1577         uint256 _burn_amount,
1578         int128 i,
1579         uint256 _min_received
1580     ) external returns (uint256);
1581 
1582     function remove_liquidity_one_coin(
1583         uint256 _burn_amount,
1584         int128 i,
1585         uint256 _min_received,
1586         address _receiver
1587     ) external returns (uint256);
1588 
1589     function ramp_A(uint256 _future_A, uint256 _future_time) external;
1590 
1591     function stop_ramp_A() external;
1592 
1593     function admin_balances(uint256 i) external view returns (uint256);
1594 
1595     function withdraw_admin_fees() external;
1596 
1597     function admin() external view returns (address);
1598 
1599     function coins(uint256 arg0) external view returns (address);
1600 
1601     function balances(uint256 arg0) external view returns (uint256);
1602 
1603     function fee() external view returns (uint256);
1604 
1605     function block_timestamp_last() external view returns (uint256);
1606 
1607     function initial_A() external view returns (uint256);
1608 
1609     function future_A() external view returns (uint256);
1610 
1611     function initial_A_time() external view returns (uint256);
1612 
1613     function future_A_time() external view returns (uint256);
1614 
1615     function name() external view returns (string memory);
1616 
1617     function symbol() external view returns (string memory);
1618 
1619     function balanceOf(address arg0) external view returns (uint256);
1620 
1621     function allowance(address arg0, address arg1)
1622         external
1623         view
1624         returns (uint256);
1625 
1626     function totalSupply() external view returns (uint256);
1627 }
1628 
1629 contract Liquidity is PoolGetters {
1630     function addLiquidity(uint256 dollarAmount, uint256 expectedReturn)
1631         internal
1632         returns (uint256, uint256)
1633     {
1634         IERC20 crv3Token = IERC20(crv3());
1635         address lpAddress = address(lpToken());
1636         uint256 balanceWas = lpToken().balanceOf(address(this));
1637 
1638         crv3Token.transferFrom(msg.sender, address(this), dollarAmount);
1639 
1640         if (crv3Token.allowance(address(this), lpAddress) < dollarAmount)
1641             dollar().approve(lpAddress, 2**256 - 1);
1642 
1643         uint256 crv3Allowed = crv3Token.allowance(address(this), lpAddress);
1644 
1645         if (crv3Allowed > 0 && crv3Allowed < dollarAmount)
1646             crv3Token.approve(lpAddress, 0);
1647 
1648         if (crv3Allowed == 0 || crv3Allowed < dollarAmount)
1649             crv3Token.approve(lpAddress, 2**256 - 1);
1650 
1651         IMetaPool(lpAddress).add_liquidity(
1652             [dollarAmount, dollarAmount],
1653             expectedReturn
1654         );
1655 
1656         return (
1657             dollarAmount,
1658             lpToken().balanceOf(address(this)).sub(balanceWas)
1659         );
1660     }
1661 }
1662 
1663 contract Pool is PoolSetters, Liquidity {
1664     using SafeMath for uint256;
1665 
1666     constructor(address dollar, address lpToken) public {
1667         _state.provider.dao = IForge(msg.sender);
1668         _state.provider.dollar = IDollar(dollar);
1669         _state.provider.lpToken = IERC20(lpToken);
1670     }
1671 
1672     bytes32 private constant FILE = "Pool";
1673 
1674     event Deposit(address indexed account, uint256 value);
1675     event Withdraw(address indexed account, uint256 value);
1676     event Claim(address indexed account, uint256 value);
1677     event Bond(address indexed account, uint256 start, uint256 value);
1678     event Unbond(
1679         address indexed account,
1680         uint256 start,
1681         uint256 value,
1682         uint256 newClaimable
1683     );
1684     event Provide(
1685         address indexed account,
1686         uint256 value,
1687         uint256 lessCrv3,
1688         uint256 lpAmount
1689     );
1690 
1691     function deposit(uint256 value) external onlyFrozen(msg.sender) notPaused {
1692         lpToken().transferFrom(msg.sender, address(this), value);
1693         incrementBalanceOfStaged(msg.sender, value);
1694 
1695         balanceCheck();
1696 
1697         emit Deposit(msg.sender, value);
1698     }
1699 
1700     function withdraw(uint256 value) external onlyFrozen(msg.sender) {
1701         lpToken().transfer(msg.sender, value);
1702         decrementBalanceOfStaged(
1703             msg.sender,
1704             value,
1705             "Pool: insufficient staged balance"
1706         );
1707 
1708         balanceCheck();
1709 
1710         emit Withdraw(msg.sender, value);
1711     }
1712 
1713     function claim(uint256 value) external onlyFrozen(msg.sender) {
1714         dollar().transfer(msg.sender, value);
1715         decrementBalanceOfClaimable(
1716             msg.sender,
1717             value,
1718             "Pool: insufficient claimable balance"
1719         );
1720 
1721         balanceCheck();
1722 
1723         emit Claim(msg.sender, value);
1724     }
1725 
1726     function bond(uint256 value) external notPaused {
1727         unfreeze(msg.sender);
1728 
1729         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom());
1730         uint256 newPhantom = totalBonded() == 0
1731             ? totalRewarded() == 0
1732                 ? Constants.getInitialStakeMultiple().mul(value)
1733                 : 0
1734             : totalRewardedWithPhantom.mul(value).div(totalBonded());
1735 
1736         incrementBalanceOfBonded(msg.sender, value);
1737         incrementBalanceOfPhantom(msg.sender, newPhantom);
1738         decrementBalanceOfStaged(
1739             msg.sender,
1740             value,
1741             "Pool: insufficient staged balance"
1742         );
1743 
1744         balanceCheck();
1745 
1746         emit Bond(msg.sender, epoch().add(1), value);
1747     }
1748 
1749     function unbond(uint256 value) external {
1750         unfreeze(msg.sender);
1751 
1752         uint256 balanceOfBonded = balanceOfBonded(msg.sender);
1753         Require.that(balanceOfBonded > 0, FILE, "insufficient bonded balance");
1754 
1755         uint256 newClaimable = balanceOfRewarded(msg.sender).mul(value).div(
1756             balanceOfBonded
1757         );
1758         uint256 lessPhantom = balanceOfPhantom(msg.sender).mul(value).div(
1759             balanceOfBonded
1760         );
1761 
1762         incrementBalanceOfStaged(msg.sender, value);
1763         incrementBalanceOfClaimable(msg.sender, newClaimable);
1764         decrementBalanceOfBonded(
1765             msg.sender,
1766             value,
1767             "Pool: insufficient bonded balance"
1768         );
1769         decrementBalanceOfPhantom(
1770             msg.sender,
1771             lessPhantom,
1772             "Pool: insufficient phantom balance"
1773         );
1774 
1775         balanceCheck();
1776 
1777         emit Unbond(msg.sender, epoch().add(1), value, newClaimable);
1778     }
1779 
1780     function provide(uint256 value, uint256 expectedReturn)
1781         external
1782         onlyFrozen(msg.sender)
1783         notPaused
1784     {
1785         Require.that(totalBonded() > 0, FILE, "insufficient total bonded");
1786 
1787         Require.that(totalRewarded() > 0, FILE, "insufficient total rewarded");
1788 
1789         Require.that(
1790             balanceOfRewarded(msg.sender) >= value,
1791             FILE,
1792             "insufficient rewarded balance"
1793         );
1794 
1795         (uint256 lessCrv3, uint256 lpAmount) = addLiquidity(
1796             value,
1797             expectedReturn
1798         );
1799 
1800         uint256 totalRewardedWithPhantom = totalRewarded()
1801             .add(totalPhantom())
1802             .add(value);
1803         uint256 newPhantomFromBonded = totalRewardedWithPhantom
1804             .mul(lpAmount)
1805             .div(totalBonded());
1806 
1807         incrementBalanceOfBonded(msg.sender, lpAmount);
1808         incrementBalanceOfPhantom(msg.sender, value.add(newPhantomFromBonded));
1809 
1810         balanceCheck();
1811 
1812         emit Provide(msg.sender, value, lessCrv3, lpAmount);
1813     }
1814 
1815     function setDao(IForge _dao) external onlyDao {
1816         _state.provider.dao = _dao;
1817     }
1818 
1819     function emergencyWithdraw(address token, uint256 value) external onlyDao {
1820         IERC20(token).transfer(address(dao()), value);
1821     }
1822 
1823     function emergencyPause() external onlyDao {
1824         pause();
1825     }
1826 
1827     function balanceCheck() private {
1828         Require.that(
1829             lpToken().balanceOf(address(this)) >=
1830                 totalStaged().add(totalBonded()),
1831             FILE,
1832             "Inconsistent UNI-V2 balances"
1833         );
1834     }
1835 
1836     modifier onlyFrozen(address account) {
1837         Require.that(
1838             statusOf(account) == PoolAccount.Status.Frozen,
1839             FILE,
1840             "Not frozen"
1841         );
1842 
1843         _;
1844     }
1845 
1846     modifier onlyDao() {
1847         Require.that(msg.sender == address(dao()), FILE, "Not dao");
1848 
1849         _;
1850     }
1851 
1852     modifier notPaused() {
1853         Require.that(!paused(), FILE, "Paused");
1854 
1855         _;
1856     }
1857 }