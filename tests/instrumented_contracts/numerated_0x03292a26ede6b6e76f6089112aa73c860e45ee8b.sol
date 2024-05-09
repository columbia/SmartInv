1 pragma solidity ^0.5.17;
2 pragma experimental ABIEncoderV2;
3 
4 // File: @openzeppelin/contracts/math/SafeMath.sol
5 
6 /**
7  * @dev Wrappers over Solidity's arithmetic operations with added overflow
8  * checks.
9  *
10  * Arithmetic operations in Solidity wrap on overflow. This can easily result
11  * in bugs, because programmers usually assume that an overflow raises an
12  * error, which is the standard behavior in high level programming languages.
13  * `SafeMath` restores this intuition by reverting the transaction when an
14  * operation overflows.
15  *
16  * Using this library instead of the unchecked operations eliminates an entire
17  * class of bugs, so it's recommended to use it always.
18  */
19 library SafeMath {
20     /**
21      * @dev Returns the addition of two unsigned integers, reverting on
22      * overflow.
23      *
24      * Counterpart to Solidity's `+` operator.
25      *
26      * Requirements:
27      * - Addition cannot overflow.
28      */
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      * - Subtraction cannot overflow.
44      */
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         return sub(a, b, "SafeMath: subtraction overflow");
47     }
48 
49     /**
50      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
51      * overflow (when the result is negative).
52      *
53      * Counterpart to Solidity's `-` operator.
54      *
55      * Requirements:
56      * - Subtraction cannot overflow.
57      *
58      * _Available since v2.4.0._
59      */
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the multiplication of two unsigned integers, reverting on
69      * overflow.
70      *
71      * Counterpart to Solidity's `*` operator.
72      *
73      * Requirements:
74      * - Multiplication cannot overflow.
75      */
76     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
78         // benefit is lost if 'b' is also tested.
79         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
80         if (a == 0) {
81             return 0;
82         }
83 
84         uint256 c = a * b;
85         require(c / a == b, "SafeMath: multiplication overflow");
86 
87         return c;
88     }
89 
90     /**
91      * @dev Returns the integer division of two unsigned integers. Reverts on
92      * division by zero. The result is rounded towards zero.
93      *
94      * Counterpart to Solidity's `/` operator. Note: this function uses a
95      * `revert` opcode (which leaves remaining gas untouched) while Solidity
96      * uses an invalid opcode to revert (consuming all remaining gas).
97      *
98      * Requirements:
99      * - The divisor cannot be zero.
100      */
101     function div(uint256 a, uint256 b) internal pure returns (uint256) {
102         return div(a, b, "SafeMath: division by zero");
103     }
104 
105     /**
106      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
107      * division by zero. The result is rounded towards zero.
108      *
109      * Counterpart to Solidity's `/` operator. Note: this function uses a
110      * `revert` opcode (which leaves remaining gas untouched) while Solidity
111      * uses an invalid opcode to revert (consuming all remaining gas).
112      *
113      * Requirements:
114      * - The divisor cannot be zero.
115      *
116      * _Available since v2.4.0._
117      */
118     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
119         // Solidity only automatically asserts when dividing by 0
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      * - The divisor cannot be zero.
137      */
138     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
139         return mod(a, b, "SafeMath: modulo by zero");
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * Reverts with custom message when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      * - The divisor cannot be zero.
152      *
153      * _Available since v2.4.0._
154      */
155     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b != 0, errorMessage);
157         return a % b;
158     }
159 }
160 
161 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
162 
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
241 
242 /**
243  * @title Require
244  * @author dYdX
245  *
246  * Stringifies parameters to pretty-print revert messages. Costs more gas than regular require()
247  */
248 library Require {
249 
250     // ============ Constants ============
251 
252     uint256 constant ASCII_ZERO = 48; // '0'
253     uint256 constant ASCII_RELATIVE_ZERO = 87; // 'a' - 10
254     uint256 constant ASCII_LOWER_EX = 120; // 'x'
255     bytes2 constant COLON = 0x3a20; // ': '
256     bytes2 constant COMMA = 0x2c20; // ', '
257     bytes2 constant LPAREN = 0x203c; // ' <'
258     byte constant RPAREN = 0x3e; // '>'
259     uint256 constant FOUR_BIT_MASK = 0xf;
260 
261     // ============ Library Functions ============
262 
263     function that(
264         bool must,
265         bytes32 file,
266         bytes32 reason
267     )
268     internal
269     pure
270     {
271         if (!must) {
272             revert(
273                 string(
274                     abi.encodePacked(
275                         stringifyTruncated(file),
276                         COLON,
277                         stringifyTruncated(reason)
278                     )
279                 )
280             );
281         }
282     }
283 
284     function that(
285         bool must,
286         bytes32 file,
287         bytes32 reason,
288         uint256 payloadA
289     )
290     internal
291     pure
292     {
293         if (!must) {
294             revert(
295                 string(
296                     abi.encodePacked(
297                         stringifyTruncated(file),
298                         COLON,
299                         stringifyTruncated(reason),
300                         LPAREN,
301                         stringify(payloadA),
302                         RPAREN
303                     )
304                 )
305             );
306         }
307     }
308 
309     function that(
310         bool must,
311         bytes32 file,
312         bytes32 reason,
313         uint256 payloadA,
314         uint256 payloadB
315     )
316     internal
317     pure
318     {
319         if (!must) {
320             revert(
321                 string(
322                     abi.encodePacked(
323                         stringifyTruncated(file),
324                         COLON,
325                         stringifyTruncated(reason),
326                         LPAREN,
327                         stringify(payloadA),
328                         COMMA,
329                         stringify(payloadB),
330                         RPAREN
331                     )
332                 )
333             );
334         }
335     }
336 
337     function that(
338         bool must,
339         bytes32 file,
340         bytes32 reason,
341         address payloadA
342     )
343     internal
344     pure
345     {
346         if (!must) {
347             revert(
348                 string(
349                     abi.encodePacked(
350                         stringifyTruncated(file),
351                         COLON,
352                         stringifyTruncated(reason),
353                         LPAREN,
354                         stringify(payloadA),
355                         RPAREN
356                     )
357                 )
358             );
359         }
360     }
361 
362     function that(
363         bool must,
364         bytes32 file,
365         bytes32 reason,
366         address payloadA,
367         uint256 payloadB
368     )
369     internal
370     pure
371     {
372         if (!must) {
373             revert(
374                 string(
375                     abi.encodePacked(
376                         stringifyTruncated(file),
377                         COLON,
378                         stringifyTruncated(reason),
379                         LPAREN,
380                         stringify(payloadA),
381                         COMMA,
382                         stringify(payloadB),
383                         RPAREN
384                     )
385                 )
386             );
387         }
388     }
389 
390     function that(
391         bool must,
392         bytes32 file,
393         bytes32 reason,
394         address payloadA,
395         uint256 payloadB,
396         uint256 payloadC
397     )
398     internal
399     pure
400     {
401         if (!must) {
402             revert(
403                 string(
404                     abi.encodePacked(
405                         stringifyTruncated(file),
406                         COLON,
407                         stringifyTruncated(reason),
408                         LPAREN,
409                         stringify(payloadA),
410                         COMMA,
411                         stringify(payloadB),
412                         COMMA,
413                         stringify(payloadC),
414                         RPAREN
415                     )
416                 )
417             );
418         }
419     }
420 
421     function that(
422         bool must,
423         bytes32 file,
424         bytes32 reason,
425         bytes32 payloadA
426     )
427     internal
428     pure
429     {
430         if (!must) {
431             revert(
432                 string(
433                     abi.encodePacked(
434                         stringifyTruncated(file),
435                         COLON,
436                         stringifyTruncated(reason),
437                         LPAREN,
438                         stringify(payloadA),
439                         RPAREN
440                     )
441                 )
442             );
443         }
444     }
445 
446     function that(
447         bool must,
448         bytes32 file,
449         bytes32 reason,
450         bytes32 payloadA,
451         uint256 payloadB,
452         uint256 payloadC
453     )
454     internal
455     pure
456     {
457         if (!must) {
458             revert(
459                 string(
460                     abi.encodePacked(
461                         stringifyTruncated(file),
462                         COLON,
463                         stringifyTruncated(reason),
464                         LPAREN,
465                         stringify(payloadA),
466                         COMMA,
467                         stringify(payloadB),
468                         COMMA,
469                         stringify(payloadC),
470                         RPAREN
471                     )
472                 )
473             );
474         }
475     }
476 
477     // ============ Private Functions ============
478 
479     function stringifyTruncated(
480         bytes32 input
481     )
482     private
483     pure
484     returns (bytes memory)
485     {
486         // put the input bytes into the result
487         bytes memory result = abi.encodePacked(input);
488 
489         // determine the length of the input by finding the location of the last non-zero byte
490         for (uint256 i = 32; i > 0; ) {
491             // reverse-for-loops with unsigned integer
492             /* solium-disable-next-line security/no-modify-for-iter-var */
493             i--;
494 
495             // find the last non-zero byte in order to determine the length
496             if (result[i] != 0) {
497                 uint256 length = i + 1;
498 
499                 /* solium-disable-next-line security/no-inline-assembly */
500                 assembly {
501                     mstore(result, length) // r.length = length;
502                 }
503 
504                 return result;
505             }
506         }
507 
508         // all bytes are zero
509         return new bytes(0);
510     }
511 
512     function stringify(
513         uint256 input
514     )
515     private
516     pure
517     returns (bytes memory)
518     {
519         if (input == 0) {
520             return "0";
521         }
522 
523         // get the final string length
524         uint256 j = input;
525         uint256 length;
526         while (j != 0) {
527             length++;
528             j /= 10;
529         }
530 
531         // allocate the string
532         bytes memory bstr = new bytes(length);
533 
534         // populate the string starting with the least-significant character
535         j = input;
536         for (uint256 i = length; i > 0; ) {
537             // reverse-for-loops with unsigned integer
538             /* solium-disable-next-line security/no-modify-for-iter-var */
539             i--;
540 
541             // take last decimal digit
542             bstr[i] = byte(uint8(ASCII_ZERO + (j % 10)));
543 
544             // remove the last decimal digit
545             j /= 10;
546         }
547 
548         return bstr;
549     }
550 
551     function stringify(
552         address input
553     )
554     private
555     pure
556     returns (bytes memory)
557     {
558         uint256 z = uint256(input);
559 
560         // addresses are "0x" followed by 20 bytes of data which take up 2 characters each
561         bytes memory result = new bytes(42);
562 
563         // populate the result with "0x"
564         result[0] = byte(uint8(ASCII_ZERO));
565         result[1] = byte(uint8(ASCII_LOWER_EX));
566 
567         // for each byte (starting from the lowest byte), populate the result with two characters
568         for (uint256 i = 0; i < 20; i++) {
569             // each byte takes two characters
570             uint256 shift = i * 2;
571 
572             // populate the least-significant character
573             result[41 - shift] = char(z & FOUR_BIT_MASK);
574             z = z >> 4;
575 
576             // populate the most-significant character
577             result[40 - shift] = char(z & FOUR_BIT_MASK);
578             z = z >> 4;
579         }
580 
581         return result;
582     }
583 
584     function stringify(
585         bytes32 input
586     )
587     private
588     pure
589     returns (bytes memory)
590     {
591         uint256 z = uint256(input);
592 
593         // bytes32 are "0x" followed by 32 bytes of data which take up 2 characters each
594         bytes memory result = new bytes(66);
595 
596         // populate the result with "0x"
597         result[0] = byte(uint8(ASCII_ZERO));
598         result[1] = byte(uint8(ASCII_LOWER_EX));
599 
600         // for each byte (starting from the lowest byte), populate the result with two characters
601         for (uint256 i = 0; i < 32; i++) {
602             // each byte takes two characters
603             uint256 shift = i * 2;
604 
605             // populate the least-significant character
606             result[65 - shift] = char(z & FOUR_BIT_MASK);
607             z = z >> 4;
608 
609             // populate the most-significant character
610             result[64 - shift] = char(z & FOUR_BIT_MASK);
611             z = z >> 4;
612         }
613 
614         return result;
615     }
616 
617     function char(
618         uint256 input
619     )
620     private
621     pure
622     returns (byte)
623     {
624         // return ASCII digit (0-9)
625         if (input < 10) {
626             return byte(uint8(input + ASCII_ZERO));
627         }
628 
629         // return ASCII letter (a-f)
630         return byte(uint8(input + ASCII_RELATIVE_ZERO));
631     }
632 }
633 
634 // File: contracts/external/Decimal.sol
635 
636 /**
637  * @title Decimal
638  * @author dYdX
639  *
640  * Library that defines a fixed-point number with 18 decimal places.
641  */
642 library Decimal {
643     using SafeMath for uint256;
644 
645     // ============ Constants ============
646 
647     uint256 constant BASE = 10**18;
648 
649     // ============ Structs ============
650 
651 
652     struct D256 {
653         uint256 value;
654     }
655 
656     // ============ Static Functions ============
657 
658     function zero()
659     internal
660     pure
661     returns (D256 memory)
662     {
663         return D256({ value: 0 });
664     }
665 
666     function one()
667     internal
668     pure
669     returns (D256 memory)
670     {
671         return D256({ value: BASE });
672     }
673 
674     function from(
675         uint256 a
676     )
677     internal
678     pure
679     returns (D256 memory)
680     {
681         return D256({ value: a.mul(BASE) });
682     }
683 
684     function ratio(
685         uint256 a,
686         uint256 b
687     )
688     internal
689     pure
690     returns (D256 memory)
691     {
692         return D256({ value: getPartial(a, BASE, b) });
693     }
694 
695     // ============ Self Functions ============
696 
697     function add(
698         D256 memory self,
699         uint256 b
700     )
701     internal
702     pure
703     returns (D256 memory)
704     {
705         return D256({ value: self.value.add(b.mul(BASE)) });
706     }
707 
708     function sub(
709         D256 memory self,
710         uint256 b
711     )
712     internal
713     pure
714     returns (D256 memory)
715     {
716         return D256({ value: self.value.sub(b.mul(BASE)) });
717     }
718 
719     function sub(
720         D256 memory self,
721         uint256 b,
722         string memory reason
723     )
724     internal
725     pure
726     returns (D256 memory)
727     {
728         return D256({ value: self.value.sub(b.mul(BASE), reason) });
729     }
730 
731     function mul(
732         D256 memory self,
733         uint256 b
734     )
735     internal
736     pure
737     returns (D256 memory)
738     {
739         return D256({ value: self.value.mul(b) });
740     }
741 
742     function div(
743         D256 memory self,
744         uint256 b
745     )
746     internal
747     pure
748     returns (D256 memory)
749     {
750         return D256({ value: self.value.div(b) });
751     }
752 
753     function pow(
754         D256 memory self,
755         uint256 b
756     )
757     internal
758     pure
759     returns (D256 memory)
760     {
761         if (b == 0) {
762             return from(1);
763         }
764 
765         D256 memory temp = D256({ value: self.value });
766         for (uint256 i = 1; i < b; i++) {
767             temp = mul(temp, self);
768         }
769 
770         return temp;
771     }
772 
773     function add(
774         D256 memory self,
775         D256 memory b
776     )
777     internal
778     pure
779     returns (D256 memory)
780     {
781         return D256({ value: self.value.add(b.value) });
782     }
783 
784     function sub(
785         D256 memory self,
786         D256 memory b
787     )
788     internal
789     pure
790     returns (D256 memory)
791     {
792         return D256({ value: self.value.sub(b.value) });
793     }
794 
795     function sub(
796         D256 memory self,
797         D256 memory b,
798         string memory reason
799     )
800     internal
801     pure
802     returns (D256 memory)
803     {
804         return D256({ value: self.value.sub(b.value, reason) });
805     }
806 
807     function mul(
808         D256 memory self,
809         D256 memory b
810     )
811     internal
812     pure
813     returns (D256 memory)
814     {
815         return D256({ value: getPartial(self.value, b.value, BASE) });
816     }
817 
818     function div(
819         D256 memory self,
820         D256 memory b
821     )
822     internal
823     pure
824     returns (D256 memory)
825     {
826         return D256({ value: getPartial(self.value, BASE, b.value) });
827     }
828 
829     function equals(D256 memory self, D256 memory b) internal pure returns (bool) {
830         return self.value == b.value;
831     }
832 
833     function greaterThan(D256 memory self, D256 memory b) internal pure returns (bool) {
834         return compareTo(self, b) == 2;
835     }
836 
837     function lessThan(D256 memory self, D256 memory b) internal pure returns (bool) {
838         return compareTo(self, b) == 0;
839     }
840 
841     function greaterThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
842         return compareTo(self, b) > 0;
843     }
844 
845     function lessThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
846         return compareTo(self, b) < 2;
847     }
848 
849     function isZero(D256 memory self) internal pure returns (bool) {
850         return self.value == 0;
851     }
852 
853     function asUint256(D256 memory self) internal pure returns (uint256) {
854         return self.value.div(BASE);
855     }
856 
857     // ============ Core Methods ============
858 
859     function getPartial(
860         uint256 target,
861         uint256 numerator,
862         uint256 denominator
863     )
864     private
865     pure
866     returns (uint256)
867     {
868         return target.mul(numerator).div(denominator);
869     }
870 
871     function compareTo(
872         D256 memory a,
873         D256 memory b
874     )
875     private
876     pure
877     returns (uint256)
878     {
879         if (a.value == b.value) {
880             return 1;
881         }
882         return a.value > b.value ? 2 : 0;
883     }
884 }
885 
886 // File: contracts/Constants.sol
887 
888 
889 library Constants {
890     /* Chain */
891     uint256 private constant CHAIN_ID = 1; // Mainnet
892 
893     /* Bootstrapping */
894     uint256 private constant BOOTSTRAPPING_PERIOD = 56; // 14 days
895     uint256 private constant BOOTSTRAPPING_PRICE = 11e17; // ESG price == 1.10 * sXAU
896 
897     /* Oracle */
898     address private constant sXAU = address(0x261EfCdD24CeA98652B9700800a13DfBca4103fF);
899     uint256 private constant ORACLE_RESERVE_MINIMUM = 1e18;
900 
901     /* Bonding */
902     uint256 private constant INITIAL_STAKE_MULTIPLE = 1e6; // 100 ESG -> 100M ESGS
903 
904     /* Epoch */
905     struct EpochStrategy {
906         uint256 offset;
907         uint256 start;
908         uint256 period;
909     }
910 
911     uint256 private constant EPOCH_START = 1609027200; // 2020-12-27T00:00:00+00:00
912     uint256 private constant EPOCH_OFFSET = 0;
913     uint256 private constant EPOCH_PERIOD = 21600; // 6 hours
914 
915     /* Governance */
916     uint256 private constant GOVERNANCE_PERIOD = 9; // 9 epochs
917     uint256 private constant GOVERNANCE_EXPIRATION = 2; // 2 + 1 epochs
918     uint256 private constant GOVERNANCE_QUORUM = 20e16; // 20%
919     uint256 private constant GOVERNANCE_PROPOSAL_THRESHOLD = 5e15; // 0.5%
920     uint256 private constant GOVERNANCE_SUPER_MAJORITY = 66e16; // 66%
921     uint256 private constant GOVERNANCE_EMERGENCY_DELAY = 6; // 6 epochs
922 
923     /* DAO */
924     uint256 private constant ADVANCE_INCENTIVE = 1e17; // 0.1 ESG
925     uint256 private constant DAO_EXIT_LOCKUP_EPOCHS = 20; // 5 days
926 
927     /* Pool */
928     uint256 private constant POOL_EXIT_LOCKUP_EPOCHS = 8; // 2 days
929 
930     /* Market */
931     uint256 private constant COUPON_EXPIRATION = 120; // 30 days
932     uint256 private constant DEBT_RATIO_CAP = 35e16; // 35%
933 
934     /* Regulator */
935     uint256 private constant SUPPLY_CHANGE_LIMIT = 1e17; // 10%
936     uint256 private constant COUPON_SUPPLY_CHANGE_LIMIT = 6e16; // 6%
937     uint256 private constant ORACLE_POOL_RATIO = 20; // 20%
938     uint256 private constant TREASURY_RATIO = 250; // 2.5%, until TREASURY_ADDRESS is set, this portion is sent to LP
939 
940     // TODO: vote on recipient
941     address private constant TREASURY_ADDRESS = address(0x0000000000000000000000000000000000000000);
942 
943     function getSXAUAddress() internal pure returns (address) {
944         return sXAU;
945     }
946 
947     function getOracleReserveMinimum() internal pure returns (uint256) {
948         return ORACLE_RESERVE_MINIMUM;
949     }
950 
951     function getCurrentEpochStrategy() internal pure returns (EpochStrategy memory) {
952         return EpochStrategy({
953             offset: EPOCH_OFFSET,
954             start: EPOCH_START,
955             period: EPOCH_PERIOD
956         });
957     }
958 
959     function getInitialStakeMultiple() internal pure returns (uint256) {
960         return INITIAL_STAKE_MULTIPLE;
961     }
962 
963     function getBootstrappingPeriod() internal pure returns (uint256) {
964         return BOOTSTRAPPING_PERIOD;
965     }
966 
967     function getBootstrappingPrice() internal pure returns (Decimal.D256 memory) {
968         return Decimal.D256({value: BOOTSTRAPPING_PRICE});
969     }
970 
971     function getGovernancePeriod() internal pure returns (uint256) {
972         return GOVERNANCE_PERIOD;
973     }
974 
975     function getGovernanceExpiration() internal pure returns (uint256) {
976         return GOVERNANCE_EXPIRATION;
977     }
978 
979     function getGovernanceQuorum() internal pure returns (Decimal.D256 memory) {
980         return Decimal.D256({value: GOVERNANCE_QUORUM});
981     }
982 
983     function getGovernanceProposalThreshold() internal pure returns (Decimal.D256 memory) {
984         return Decimal.D256({value: GOVERNANCE_PROPOSAL_THRESHOLD});
985     }
986 
987     function getGovernanceSuperMajority() internal pure returns (Decimal.D256 memory) {
988         return Decimal.D256({value: GOVERNANCE_SUPER_MAJORITY});
989     }
990 
991     function getGovernanceEmergencyDelay() internal pure returns (uint256) {
992         return GOVERNANCE_EMERGENCY_DELAY;
993     }
994 
995     function getAdvanceIncentive() internal pure returns (uint256) {
996         return ADVANCE_INCENTIVE;
997     }
998 
999     function getDAOExitLockupEpochs() internal pure returns (uint256) {
1000         return DAO_EXIT_LOCKUP_EPOCHS;
1001     }
1002 
1003     function getPoolExitLockupEpochs() internal pure returns (uint256) {
1004         return POOL_EXIT_LOCKUP_EPOCHS;
1005     }
1006 
1007     function getCouponExpiration() internal pure returns (uint256) {
1008         return COUPON_EXPIRATION;
1009     }
1010 
1011     function getDebtRatioCap() internal pure returns (Decimal.D256 memory) {
1012         return Decimal.D256({value: DEBT_RATIO_CAP});
1013     }
1014 
1015     function getSupplyChangeLimit() internal pure returns (Decimal.D256 memory) {
1016         return Decimal.D256({value: SUPPLY_CHANGE_LIMIT});
1017     }
1018 
1019     function getCouponSupplyChangeLimit() internal pure returns (Decimal.D256 memory) {
1020         return Decimal.D256({value: COUPON_SUPPLY_CHANGE_LIMIT});
1021     }
1022 
1023     function getOraclePoolRatio() internal pure returns (uint256) {
1024         return ORACLE_POOL_RATIO;
1025     }
1026 
1027     function getTreasuryRatio() internal pure returns (uint256) {
1028         return TREASURY_RATIO;
1029     }
1030 
1031     function getChainId() internal pure returns (uint256) {
1032         return CHAIN_ID;
1033     }
1034 
1035     function getTreasuryAddress() internal pure returns (address) {
1036         return TREASURY_ADDRESS;
1037     }
1038 }
1039 
1040 // File: contracts/token/IGold.sol
1041 
1042 
1043 contract IGold is IERC20 {
1044     function burn(uint256 amount) public;
1045     function burnFrom(address account, uint256 amount) public;
1046     function mint(address account, uint256 amount) public returns (bool);
1047 }
1048 
1049 // File: contracts/oracle/IDAO.sol
1050 
1051 
1052 contract IDAO {
1053     function epoch() external view returns (uint256);
1054 }
1055 
1056 // File: contracts/oracle/PoolState.sol
1057 
1058 
1059 contract PoolAccount {
1060     enum Status {
1061         Frozen,
1062         Fluid,
1063         Locked
1064     }
1065 
1066     struct State {
1067         uint256 staged;
1068         uint256 claimable;
1069         uint256 bonded;
1070         uint256 phantom;
1071         uint256 fluidUntil;
1072     }
1073 }
1074 
1075 contract PoolStorage {
1076     struct Provider {
1077         IDAO dao;
1078         IGold gold;
1079         IERC20 univ2;
1080     }
1081 
1082     struct Balance {
1083         uint256 staged;
1084         uint256 claimable;
1085         uint256 bonded;
1086         uint256 phantom;
1087     }
1088 
1089     struct State {
1090         Balance balance;
1091         Provider provider;
1092         bool paused;
1093 
1094         mapping(address => PoolAccount.State) accounts;
1095     }
1096 }
1097 
1098 contract PoolState {
1099     PoolStorage.State _state;
1100 }
1101 
1102 // File: contracts/oracle/PoolGetters.sol
1103 
1104 
1105 
1106 contract PoolGetters is PoolState {
1107     using SafeMath for uint256;
1108 
1109     /**
1110      * Global
1111      */
1112 
1113     function sXAU() public view returns (address) {
1114         return Constants.getSXAUAddress();
1115     }
1116 
1117     function dao() public view returns (IDAO) {
1118         return _state.provider.dao;
1119     }
1120 
1121     function gold() public view returns (IGold) {
1122         return _state.provider.gold;
1123     }
1124 
1125     function univ2() public view returns (IERC20) {
1126         return _state.provider.univ2;
1127     }
1128 
1129     function totalBonded() public view returns (uint256) {
1130         return _state.balance.bonded;
1131     }
1132 
1133     function totalStaged() public view returns (uint256) {
1134         return _state.balance.staged;
1135     }
1136 
1137     function totalClaimable() public view returns (uint256) {
1138         return _state.balance.claimable;
1139     }
1140 
1141     function totalPhantom() public view returns (uint256) {
1142         return _state.balance.phantom;
1143     }
1144 
1145     function totalRewarded(IGold gold) public view returns (uint256) {
1146         return gold.balanceOf(address(this)).sub(totalClaimable());
1147     }
1148 
1149     function paused() public view returns (bool) {
1150         return _state.paused;
1151     }
1152 
1153     /**
1154      * Account
1155      */
1156 
1157     function balanceOfStaged(address account) public view returns (uint256) {
1158         return _state.accounts[account].staged;
1159     }
1160 
1161     function balanceOfClaimable(address account) public view returns (uint256) {
1162         return _state.accounts[account].claimable;
1163     }
1164 
1165     function balanceOfBonded(address account) public view returns (uint256) {
1166         return _state.accounts[account].bonded;
1167     }
1168 
1169     function balanceOfPhantom(address account) public view returns (uint256) {
1170         return _state.accounts[account].phantom;
1171     }
1172 
1173 
1174     function balanceOfRewarded(address account, IGold gold) public view returns (uint256) {
1175         uint256 totalBonded = totalBonded();
1176         if (totalBonded == 0) {
1177             return 0;
1178         }
1179 
1180         uint256 totalRewardedWithPhantom = totalRewarded(gold).add(totalPhantom());
1181         uint256 balanceOfRewardedWithPhantom = totalRewardedWithPhantom
1182         .mul(balanceOfBonded(account))
1183         .div(totalBonded);
1184 
1185         uint256 balanceOfPhantom = balanceOfPhantom(account);
1186         if (balanceOfRewardedWithPhantom > balanceOfPhantom) {
1187             return balanceOfRewardedWithPhantom.sub(balanceOfPhantom);
1188         }
1189         return 0;
1190     }
1191 
1192     function statusOf(address account, uint256 epoch) public view returns (PoolAccount.Status) {
1193         return epoch >= _state.accounts[account].fluidUntil ?
1194         PoolAccount.Status.Frozen :
1195         PoolAccount.Status.Fluid;
1196     }
1197 }
1198 
1199 // File: contracts/oracle/PoolSetters.sol
1200 
1201 
1202 
1203 contract PoolSetters is PoolState, PoolGetters {
1204     using SafeMath for uint256;
1205 
1206     /**
1207      * Global
1208      */
1209 
1210     function pause() internal {
1211         _state.paused = true;
1212     }
1213 
1214     /**
1215      * Account
1216      */
1217 
1218     function incrementBalanceOfBonded(address account, uint256 amount) internal {
1219         _state.accounts[account].bonded = _state.accounts[account].bonded.add(amount);
1220         _state.balance.bonded = _state.balance.bonded.add(amount);
1221     }
1222 
1223     function decrementBalanceOfBonded(address account, uint256 amount, string memory reason) internal {
1224         _state.accounts[account].bonded = _state.accounts[account].bonded.sub(amount, reason);
1225         _state.balance.bonded = _state.balance.bonded.sub(amount, reason);
1226     }
1227 
1228     function incrementBalanceOfStaged(address account, uint256 amount) internal {
1229         _state.accounts[account].staged = _state.accounts[account].staged.add(amount);
1230         _state.balance.staged = _state.balance.staged.add(amount);
1231     }
1232 
1233     function decrementBalanceOfStaged(address account, uint256 amount, string memory reason) internal {
1234         _state.accounts[account].staged = _state.accounts[account].staged.sub(amount, reason);
1235         _state.balance.staged = _state.balance.staged.sub(amount, reason);
1236     }
1237 
1238     function incrementBalanceOfClaimable(address account, uint256 amount) internal {
1239         _state.accounts[account].claimable = _state.accounts[account].claimable.add(amount);
1240         _state.balance.claimable = _state.balance.claimable.add(amount);
1241     }
1242 
1243     function decrementBalanceOfClaimable(address account, uint256 amount, string memory reason) internal {
1244         _state.accounts[account].claimable = _state.accounts[account].claimable.sub(amount, reason);
1245         _state.balance.claimable = _state.balance.claimable.sub(amount, reason);
1246     }
1247 
1248     function incrementBalanceOfPhantom(address account, uint256 amount) internal {
1249         _state.accounts[account].phantom = _state.accounts[account].phantom.add(amount);
1250         _state.balance.phantom = _state.balance.phantom.add(amount);
1251     }
1252 
1253     function decrementBalanceOfPhantom(address account, uint256 amount, string memory reason) internal {
1254         _state.accounts[account].phantom = _state.accounts[account].phantom.sub(amount, reason);
1255         _state.balance.phantom = _state.balance.phantom.sub(amount, reason);
1256     }
1257 
1258     function unfreeze(address account, uint256 epoch) internal {
1259         _state.accounts[account].fluidUntil = epoch.add(Constants.getPoolExitLockupEpochs());
1260     }
1261 }
1262 
1263 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
1264 
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
1317 // File: contracts/external/UniswapV2Library.sol
1318 
1319 
1320 
1321 
1322 library UniswapV2Library {
1323     using SafeMath for uint;
1324 
1325     // returns sorted token addresses, used to handle return values from pairs sorted in this order
1326     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
1327         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
1328         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
1329         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
1330     }
1331 
1332     // calculates the CREATE2 address for a pair without making any external calls
1333     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
1334         (address token0, address token1) = sortTokens(tokenA, tokenB);
1335         pair = address(uint(keccak256(abi.encodePacked(
1336                 hex'ff',
1337                 factory,
1338                 keccak256(abi.encodePacked(token0, token1)),
1339                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
1340             ))));
1341     }
1342 
1343     // fetches and sorts the reserves for a pair
1344     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
1345         (address token0,) = sortTokens(tokenA, tokenB);
1346         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
1347         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1348     }
1349 
1350     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
1351     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
1352         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
1353         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
1354         amountB = amountA.mul(reserveB) / reserveA;
1355     }
1356 }
1357 
1358 // File: contracts/oracle/Pool.sol
1359 
1360 
1361 
1362 
1363 
1364 
1365 
1366 
1367 contract Pool is PoolSetters {
1368     using SafeMath for uint256;
1369 
1370     constructor(address gold, address univ2) public {
1371         _state.provider.dao = IDAO(msg.sender);
1372         _state.provider.gold = IGold(gold);
1373         _state.provider.univ2 = IERC20(univ2);
1374     }
1375 
1376     address private constant UNISWAP_FACTORY = address(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
1377 
1378     function addLiquidity(uint256 goldAmount) internal returns (uint256, uint256) {
1379         (address gold, address sXAU) = (address(_state.provider.gold), sXAU());
1380         (uint reserveA, uint reserveB) = getReserves(gold, sXAU);
1381 
1382         uint256 sXAUAmount = (reserveA == 0 && reserveB == 0) ?
1383         goldAmount :
1384         UniswapV2Library.quote(goldAmount, reserveA, reserveB);
1385 
1386         address pair = address(_state.provider.univ2);
1387         IERC20(gold).transfer(pair, goldAmount);
1388         IERC20(sXAU).transferFrom(msg.sender, pair, sXAUAmount);
1389         return (sXAUAmount, IUniswapV2Pair(pair).mint(address(this)));
1390     }
1391 
1392     // overridable for testing
1393     function getReserves(address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
1394         (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
1395         (uint reserve0, uint reserve1,) = IUniswapV2Pair(UniswapV2Library.pairFor(UNISWAP_FACTORY, tokenA, tokenB)).getReserves();
1396         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1397     }
1398 
1399     bytes32 private constant FILE = "Pool";
1400 
1401     event Deposit(address indexed account, uint256 value);
1402     event Withdraw(address indexed account, uint256 value);
1403     event Claim(address indexed account, uint256 value);
1404     event Bond(address indexed account, uint256 start, uint256 value);
1405     event Unbond(address indexed account, uint256 start, uint256 value, uint256 newClaimable);
1406     event Provide(address indexed account, uint256 value, uint256 lessSXAU, uint256 newUniv2);
1407 
1408     function deposit(uint256 value) external onlyFrozen(msg.sender) notPaused {
1409         _state.provider.univ2.transferFrom(msg.sender, address(this), value);
1410         incrementBalanceOfStaged(msg.sender, value);
1411 
1412         balanceCheck();
1413 
1414         emit Deposit(msg.sender, value);
1415     }
1416 
1417     function withdraw(uint256 value) external onlyFrozen(msg.sender) {
1418         _state.provider.univ2.transfer(msg.sender, value);
1419         decrementBalanceOfStaged(msg.sender, value, "Pool: insufficient staged balance");
1420 
1421         balanceCheck();
1422 
1423         emit Withdraw(msg.sender, value);
1424     }
1425 
1426     function claim(uint256 value) external onlyFrozen(msg.sender) {
1427         _state.provider.gold.transfer(msg.sender, value);
1428         decrementBalanceOfClaimable(msg.sender, value, "Pool: insufficient claimable balance");
1429 
1430         balanceCheck();
1431 
1432         emit Claim(msg.sender, value);
1433     }
1434 
1435     function unfreeze(address account) internal {
1436         super.unfreeze(account, _state.provider.dao.epoch());
1437     }
1438 
1439     function bond(uint256 value) external notPaused {
1440         unfreeze(msg.sender);
1441 
1442         uint256 totalRewardedWithPhantom = totalRewarded(_state.provider.gold).add(totalPhantom());
1443         uint256 newPhantom = totalBonded() == 0 ?
1444         totalRewarded(_state.provider.gold) == 0 ? Constants.getInitialStakeMultiple().mul(value) : 0 :
1445         totalRewardedWithPhantom.mul(value).div(totalBonded());
1446 
1447         incrementBalanceOfBonded(msg.sender, value);
1448         incrementBalanceOfPhantom(msg.sender, newPhantom);
1449         decrementBalanceOfStaged(msg.sender, value, "Pool: insufficient staged balance");
1450 
1451         balanceCheck();
1452 
1453         emit Bond(msg.sender, _state.provider.dao.epoch().add(1), value);
1454     }
1455 
1456     function unbond(uint256 value) external {
1457         unfreeze(msg.sender);
1458 
1459         uint256 balanceOfBonded = balanceOfBonded(msg.sender);
1460         Require.that(
1461             balanceOfBonded > 0,
1462             FILE,
1463             "insufficient bonded balance"
1464         );
1465 
1466         uint256 newClaimable = balanceOfRewarded(msg.sender, _state.provider.gold).mul(value).div(balanceOfBonded);
1467         uint256 lessPhantom = balanceOfPhantom(msg.sender).mul(value).div(balanceOfBonded);
1468 
1469         incrementBalanceOfStaged(msg.sender, value);
1470         incrementBalanceOfClaimable(msg.sender, newClaimable);
1471         decrementBalanceOfBonded(msg.sender, value, "Pool: insufficient bonded balance");
1472         decrementBalanceOfPhantom(msg.sender, lessPhantom, "Pool: insufficient phantom balance");
1473 
1474         balanceCheck();
1475 
1476         emit Unbond(msg.sender, _state.provider.dao.epoch().add(1), value, newClaimable);
1477     }
1478 
1479     function provide(uint256 value) external onlyFrozen(msg.sender) notPaused {
1480         Require.that(
1481             totalBonded() > 0,
1482             FILE,
1483             "insufficient total bonded"
1484         );
1485 
1486         Require.that(
1487             totalRewarded(_state.provider.gold) > 0,
1488             FILE,
1489             "insufficient total rewarded"
1490         );
1491 
1492         Require.that(
1493             balanceOfRewarded(msg.sender, _state.provider.gold) >= value,
1494             FILE,
1495             "insufficient rewarded balance"
1496         );
1497 
1498         (uint256 lessSXAU, uint256 newUniv2) = addLiquidity(value);
1499 
1500         uint256 totalRewardedWithPhantom = totalRewarded(_state.provider.gold).add(totalPhantom()).add(value);
1501         uint256 newPhantomFromBonded = totalRewardedWithPhantom.mul(newUniv2).div(totalBonded());
1502 
1503         incrementBalanceOfBonded(msg.sender, newUniv2);
1504         incrementBalanceOfPhantom(msg.sender, value.add(newPhantomFromBonded));
1505 
1506 
1507         balanceCheck();
1508 
1509         emit Provide(msg.sender, value, lessSXAU, newUniv2);
1510     }
1511 
1512     function emergencyWithdraw(address token, uint256 value) external onlyDao {
1513         IERC20(token).transfer(address(_state.provider.dao), value);
1514     }
1515 
1516     function emergencyPause() external onlyDao {
1517         pause();
1518     }
1519 
1520     function balanceCheck() private {
1521         Require.that(
1522             _state.provider.univ2.balanceOf(address(this)) >= totalStaged().add(totalBonded()),
1523             FILE,
1524             "Inconsistent UNI-V2 balances"
1525         );
1526     }
1527 
1528     modifier onlyFrozen(address account) {
1529         Require.that(
1530             statusOf(account, _state.provider.dao.epoch()) == PoolAccount.Status.Frozen,
1531             FILE,
1532             "Not frozen"
1533         );
1534 
1535         _;
1536     }
1537 
1538     modifier onlyDao() {
1539         Require.that(
1540             msg.sender == address(_state.provider.dao),
1541             FILE,
1542             "Not dao"
1543         );
1544 
1545         _;
1546     }
1547 
1548     modifier notPaused() {
1549         Require.that(
1550             !paused(),
1551             FILE,
1552             "Paused"
1553         );
1554 
1555         _;
1556     }
1557 }