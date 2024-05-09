1 /*
2 
3     Copyright 2019 dYdX Trading Inc.
4 
5     Licensed under the Apache License, Version 2.0 (the "License");
6     you may not use this file except in compliance with the License.
7     You may obtain a copy of the License at
8 
9     http://www.apache.org/licenses/LICENSE-2.0
10 
11     Unless required by applicable law or agreed to in writing, software
12     distributed under the License is distributed on an "AS IS" BASIS,
13     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14     See the License for the specific language governing permissions and
15     limitations under the License.
16 
17 */
18 
19 pragma solidity 0.5.7;
20 pragma experimental ABIEncoderV2;
21 
22 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
23 
24 /**
25  * @title SafeMath
26  * @dev Unsigned math operations with safety checks that revert on error
27  */
28 library SafeMath {
29     /**
30     * @dev Multiplies two unsigned integers, reverts on overflow.
31     */
32     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
34         // benefit is lost if 'b' is also tested.
35         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
36         if (a == 0) {
37             return 0;
38         }
39 
40         uint256 c = a * b;
41         require(c / a == b);
42 
43         return c;
44     }
45 
46     /**
47     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
48     */
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         // Solidity only automatically asserts when dividing by 0
51         require(b > 0);
52         uint256 c = a / b;
53         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54 
55         return c;
56     }
57 
58     /**
59     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
60     */
61     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b <= a);
63         uint256 c = a - b;
64 
65         return c;
66     }
67 
68     /**
69     * @dev Adds two unsigned integers, reverts on overflow.
70     */
71     function add(uint256 a, uint256 b) internal pure returns (uint256) {
72         uint256 c = a + b;
73         require(c >= a);
74 
75         return c;
76     }
77 
78     /**
79     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
80     * reverts when dividing by zero.
81     */
82     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
83         require(b != 0);
84         return a % b;
85     }
86 }
87 
88 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
89 
90 /**
91  * @title Helps contracts guard against reentrancy attacks.
92  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
93  * @dev If you mark a function `nonReentrant`, you should also
94  * mark it `external`.
95  */
96 contract ReentrancyGuard {
97     /// @dev counter to allow mutex lock with only one SSTORE operation
98     uint256 private _guardCounter;
99 
100     constructor () internal {
101         // The counter starts at one to prevent changing it from zero to a non-zero
102         // value, which is a more expensive operation.
103         _guardCounter = 1;
104     }
105 
106     /**
107      * @dev Prevents a contract from calling itself, directly or indirectly.
108      * Calling a `nonReentrant` function from another `nonReentrant`
109      * function is not supported. It is possible to prevent this from happening
110      * by making the `nonReentrant` function external, and make it call a
111      * `private` function that does the actual work.
112      */
113     modifier nonReentrant() {
114         _guardCounter += 1;
115         uint256 localCounter = _guardCounter;
116         _;
117         require(localCounter == _guardCounter);
118     }
119 }
120 
121 // File: contracts/protocol/lib/Require.sol
122 
123 /**
124  * @title Require
125  * @author dYdX
126  *
127  * Stringifies parameters to pretty-print revert messages. Costs more gas than regular require()
128  */
129 library Require {
130 
131     // ============ Constants ============
132 
133     uint256 constant ASCII_ZERO = 48; // '0'
134     uint256 constant ASCII_RELATIVE_ZERO = 87; // 'a' - 10
135     uint256 constant ASCII_LOWER_EX = 120; // 'x'
136     bytes2 constant COLON = 0x3a20; // ': '
137     bytes2 constant COMMA = 0x2c20; // ', '
138     bytes2 constant LPAREN = 0x203c; // ' <'
139     byte constant RPAREN = 0x3e; // '>'
140     uint256 constant FOUR_BIT_MASK = 0xf;
141 
142     // ============ Library Functions ============
143 
144     function that(
145         bool must,
146         bytes32 file,
147         bytes32 reason
148     )
149         internal
150         pure
151     {
152         if (!must) {
153             revert(
154                 string(
155                     abi.encodePacked(
156                         stringify(file),
157                         COLON,
158                         stringify(reason)
159                     )
160                 )
161             );
162         }
163     }
164 
165     function that(
166         bool must,
167         bytes32 file,
168         bytes32 reason,
169         uint256 payloadA
170     )
171         internal
172         pure
173     {
174         if (!must) {
175             revert(
176                 string(
177                     abi.encodePacked(
178                         stringify(file),
179                         COLON,
180                         stringify(reason),
181                         LPAREN,
182                         stringify(payloadA),
183                         RPAREN
184                     )
185                 )
186             );
187         }
188     }
189 
190     function that(
191         bool must,
192         bytes32 file,
193         bytes32 reason,
194         uint256 payloadA,
195         uint256 payloadB
196     )
197         internal
198         pure
199     {
200         if (!must) {
201             revert(
202                 string(
203                     abi.encodePacked(
204                         stringify(file),
205                         COLON,
206                         stringify(reason),
207                         LPAREN,
208                         stringify(payloadA),
209                         COMMA,
210                         stringify(payloadB),
211                         RPAREN
212                     )
213                 )
214             );
215         }
216     }
217 
218     function that(
219         bool must,
220         bytes32 file,
221         bytes32 reason,
222         address payloadA
223     )
224         internal
225         pure
226     {
227         if (!must) {
228             revert(
229                 string(
230                     abi.encodePacked(
231                         stringify(file),
232                         COLON,
233                         stringify(reason),
234                         LPAREN,
235                         stringify(payloadA),
236                         RPAREN
237                     )
238                 )
239             );
240         }
241     }
242 
243     function that(
244         bool must,
245         bytes32 file,
246         bytes32 reason,
247         address payloadA,
248         uint256 payloadB
249     )
250         internal
251         pure
252     {
253         if (!must) {
254             revert(
255                 string(
256                     abi.encodePacked(
257                         stringify(file),
258                         COLON,
259                         stringify(reason),
260                         LPAREN,
261                         stringify(payloadA),
262                         COMMA,
263                         stringify(payloadB),
264                         RPAREN
265                     )
266                 )
267             );
268         }
269     }
270 
271     function that(
272         bool must,
273         bytes32 file,
274         bytes32 reason,
275         address payloadA,
276         uint256 payloadB,
277         uint256 payloadC
278     )
279         internal
280         pure
281     {
282         if (!must) {
283             revert(
284                 string(
285                     abi.encodePacked(
286                         stringify(file),
287                         COLON,
288                         stringify(reason),
289                         LPAREN,
290                         stringify(payloadA),
291                         COMMA,
292                         stringify(payloadB),
293                         COMMA,
294                         stringify(payloadC),
295                         RPAREN
296                     )
297                 )
298             );
299         }
300     }
301 
302     // ============ Private Functions ============
303 
304     function stringify(
305         bytes32 input
306     )
307         private
308         pure
309         returns (bytes memory)
310     {
311         // put the input bytes into the result
312         bytes memory result = abi.encodePacked(input);
313 
314         // determine the length of the input by finding the location of the last non-zero byte
315         for (uint256 i = 32; i > 0; ) {
316             // reverse-for-loops with unsigned integer
317             /* solium-disable-next-line security/no-modify-for-iter-var */
318             i--;
319 
320             // find the last non-zero byte in order to determine the length
321             if (result[i] != 0) {
322                 uint256 length = i + 1;
323 
324                 /* solium-disable-next-line security/no-inline-assembly */
325                 assembly {
326                     mstore(result, length) // r.length = length;
327                 }
328 
329                 return result;
330             }
331         }
332 
333         // all bytes are zero
334         return new bytes(0);
335     }
336 
337     function stringify(
338         uint256 input
339     )
340         private
341         pure
342         returns (bytes memory)
343     {
344         if (input == 0) {
345             return "0";
346         }
347 
348         // get the final string length
349         uint256 j = input;
350         uint256 length;
351         while (j != 0) {
352             length++;
353             j /= 10;
354         }
355 
356         // allocate the string
357         bytes memory bstr = new bytes(length);
358 
359         // populate the string starting with the least-significant character
360         j = input;
361         for (uint256 i = length; i > 0; ) {
362             // reverse-for-loops with unsigned integer
363             /* solium-disable-next-line security/no-modify-for-iter-var */
364             i--;
365 
366             // take last decimal digit
367             bstr[i] = byte(uint8(ASCII_ZERO + (j % 10)));
368 
369             // remove the last decimal digit
370             j /= 10;
371         }
372 
373         return bstr;
374     }
375 
376     function stringify(
377         address input
378     )
379         private
380         pure
381         returns (bytes memory)
382     {
383         uint256 z = uint256(input);
384 
385         // addresses are "0x" followed by 20 bytes of data which take up 2 characters each
386         bytes memory result = new bytes(42);
387 
388         // populate the result with "0x"
389         result[0] = byte(uint8(ASCII_ZERO));
390         result[1] = byte(uint8(ASCII_LOWER_EX));
391 
392         // for each byte (starting from the lowest byte), populate the result with two characters
393         for (uint256 i = 0; i < 20; i++) {
394             // each byte takes two characters
395             uint256 shift = i * 2;
396 
397             // populate the least-significant character
398             result[41 - shift] = char(z & FOUR_BIT_MASK);
399             z = z >> 4;
400 
401             // populate the most-significant character
402             result[40 - shift] = char(z & FOUR_BIT_MASK);
403             z = z >> 4;
404         }
405 
406         return result;
407     }
408 
409     function char(
410         uint256 input
411     )
412         private
413         pure
414         returns (byte)
415     {
416         // return ASCII digit (0-9)
417         if (input < 10) {
418             return byte(uint8(input + ASCII_ZERO));
419         }
420 
421         // return ASCII letter (a-f)
422         return byte(uint8(input + ASCII_RELATIVE_ZERO));
423     }
424 }
425 
426 // File: contracts/protocol/lib/Math.sol
427 
428 /**
429  * @title Math
430  * @author dYdX
431  *
432  * Library for non-standard Math functions
433  */
434 library Math {
435     using SafeMath for uint256;
436 
437     // ============ Constants ============
438 
439     bytes32 constant FILE = "Math";
440 
441     // ============ Library Functions ============
442 
443     /*
444      * Return target * (numerator / denominator).
445      */
446     function getPartial(
447         uint256 target,
448         uint256 numerator,
449         uint256 denominator
450     )
451         internal
452         pure
453         returns (uint256)
454     {
455         return target.mul(numerator).div(denominator);
456     }
457 
458     /*
459      * Return target * (numerator / denominator), but rounded up.
460      */
461     function getPartialRoundUp(
462         uint256 target,
463         uint256 numerator,
464         uint256 denominator
465     )
466         internal
467         pure
468         returns (uint256)
469     {
470         if (target == 0 || numerator == 0) {
471             // SafeMath will check for zero denominator
472             return SafeMath.div(0, denominator);
473         }
474         return target.mul(numerator).sub(1).div(denominator).add(1);
475     }
476 
477     function to128(
478         uint256 number
479     )
480         internal
481         pure
482         returns (uint128)
483     {
484         uint128 result = uint128(number);
485         Require.that(
486             result == number,
487             FILE,
488             "Unsafe cast to uint128"
489         );
490         return result;
491     }
492 
493     function to96(
494         uint256 number
495     )
496         internal
497         pure
498         returns (uint96)
499     {
500         uint96 result = uint96(number);
501         Require.that(
502             result == number,
503             FILE,
504             "Unsafe cast to uint96"
505         );
506         return result;
507     }
508 
509     function to32(
510         uint256 number
511     )
512         internal
513         pure
514         returns (uint32)
515     {
516         uint32 result = uint32(number);
517         Require.that(
518             result == number,
519             FILE,
520             "Unsafe cast to uint32"
521         );
522         return result;
523     }
524 
525     function min(
526         uint256 a,
527         uint256 b
528     )
529         internal
530         pure
531         returns (uint256)
532     {
533         return a < b ? a : b;
534     }
535 
536     function max(
537         uint256 a,
538         uint256 b
539     )
540         internal
541         pure
542         returns (uint256)
543     {
544         return a > b ? a : b;
545     }
546 }
547 
548 // File: contracts/protocol/lib/Types.sol
549 
550 /**
551  * @title Types
552  * @author dYdX
553  *
554  * Library for interacting with the basic structs used in Solo
555  */
556 library Types {
557     using Math for uint256;
558 
559     // ============ AssetAmount ============
560 
561     enum AssetDenomination {
562         Wei, // the amount is denominated in wei
563         Par  // the amount is denominated in par
564     }
565 
566     enum AssetReference {
567         Delta, // the amount is given as a delta from the current value
568         Target // the amount is given as an exact number to end up at
569     }
570 
571     struct AssetAmount {
572         bool sign; // true if positive
573         AssetDenomination denomination;
574         AssetReference ref;
575         uint256 value;
576     }
577 
578     // ============ Par (Principal Amount) ============
579 
580     // Total borrow and supply values for a market
581     struct TotalPar {
582         uint128 borrow;
583         uint128 supply;
584     }
585 
586     // Individual principal amount for an account
587     struct Par {
588         bool sign; // true if positive
589         uint128 value;
590     }
591 
592     function zeroPar()
593         internal
594         pure
595         returns (Par memory)
596     {
597         return Par({
598             sign: false,
599             value: 0
600         });
601     }
602 
603     function sub(
604         Par memory a,
605         Par memory b
606     )
607         internal
608         pure
609         returns (Par memory)
610     {
611         return add(a, negative(b));
612     }
613 
614     function add(
615         Par memory a,
616         Par memory b
617     )
618         internal
619         pure
620         returns (Par memory)
621     {
622         Par memory result;
623         if (a.sign == b.sign) {
624             result.sign = a.sign;
625             result.value = SafeMath.add(a.value, b.value).to128();
626         } else {
627             if (a.value >= b.value) {
628                 result.sign = a.sign;
629                 result.value = SafeMath.sub(a.value, b.value).to128();
630             } else {
631                 result.sign = b.sign;
632                 result.value = SafeMath.sub(b.value, a.value).to128();
633             }
634         }
635         return result;
636     }
637 
638     function equals(
639         Par memory a,
640         Par memory b
641     )
642         internal
643         pure
644         returns (bool)
645     {
646         if (a.value == b.value) {
647             if (a.value == 0) {
648                 return true;
649             }
650             return a.sign == b.sign;
651         }
652         return false;
653     }
654 
655     function negative(
656         Par memory a
657     )
658         internal
659         pure
660         returns (Par memory)
661     {
662         return Par({
663             sign: !a.sign,
664             value: a.value
665         });
666     }
667 
668     function isNegative(
669         Par memory a
670     )
671         internal
672         pure
673         returns (bool)
674     {
675         return !a.sign && a.value > 0;
676     }
677 
678     function isPositive(
679         Par memory a
680     )
681         internal
682         pure
683         returns (bool)
684     {
685         return a.sign && a.value > 0;
686     }
687 
688     function isZero(
689         Par memory a
690     )
691         internal
692         pure
693         returns (bool)
694     {
695         return a.value == 0;
696     }
697 
698     // ============ Wei (Token Amount) ============
699 
700     // Individual token amount for an account
701     struct Wei {
702         bool sign; // true if positive
703         uint256 value;
704     }
705 
706     function zeroWei()
707         internal
708         pure
709         returns (Wei memory)
710     {
711         return Wei({
712             sign: false,
713             value: 0
714         });
715     }
716 
717     function sub(
718         Wei memory a,
719         Wei memory b
720     )
721         internal
722         pure
723         returns (Wei memory)
724     {
725         return add(a, negative(b));
726     }
727 
728     function add(
729         Wei memory a,
730         Wei memory b
731     )
732         internal
733         pure
734         returns (Wei memory)
735     {
736         Wei memory result;
737         if (a.sign == b.sign) {
738             result.sign = a.sign;
739             result.value = SafeMath.add(a.value, b.value);
740         } else {
741             if (a.value >= b.value) {
742                 result.sign = a.sign;
743                 result.value = SafeMath.sub(a.value, b.value);
744             } else {
745                 result.sign = b.sign;
746                 result.value = SafeMath.sub(b.value, a.value);
747             }
748         }
749         return result;
750     }
751 
752     function equals(
753         Wei memory a,
754         Wei memory b
755     )
756         internal
757         pure
758         returns (bool)
759     {
760         if (a.value == b.value) {
761             if (a.value == 0) {
762                 return true;
763             }
764             return a.sign == b.sign;
765         }
766         return false;
767     }
768 
769     function negative(
770         Wei memory a
771     )
772         internal
773         pure
774         returns (Wei memory)
775     {
776         return Wei({
777             sign: !a.sign,
778             value: a.value
779         });
780     }
781 
782     function isNegative(
783         Wei memory a
784     )
785         internal
786         pure
787         returns (bool)
788     {
789         return !a.sign && a.value > 0;
790     }
791 
792     function isPositive(
793         Wei memory a
794     )
795         internal
796         pure
797         returns (bool)
798     {
799         return a.sign && a.value > 0;
800     }
801 
802     function isZero(
803         Wei memory a
804     )
805         internal
806         pure
807         returns (bool)
808     {
809         return a.value == 0;
810     }
811 }
812 
813 // File: contracts/protocol/lib/Account.sol
814 
815 /**
816  * @title Account
817  * @author dYdX
818  *
819  * Library of structs and functions that represent an account
820  */
821 library Account {
822     // ============ Enums ============
823 
824     /*
825      * Most-recently-cached account status.
826      *
827      * Normal: Can only be liquidated if the account values are violating the global margin-ratio.
828      * Liquid: Can be liquidated no matter the account values.
829      *         Can be vaporized if there are no more positive account values.
830      * Vapor:  Has only negative (or zeroed) account values. Can be vaporized.
831      *
832      */
833     enum Status {
834         Normal,
835         Liquid,
836         Vapor
837     }
838 
839     // ============ Structs ============
840 
841     // Represents the unique key that specifies an account
842     struct Info {
843         address owner;  // The address that owns the account
844         uint256 number; // A nonce that allows a single address to control many accounts
845     }
846 
847     // The complete storage for any account
848     struct Storage {
849         mapping (uint256 => Types.Par) balances; // Mapping from marketId to principal
850         Status status;
851     }
852 }
853 
854 // File: contracts/protocol/lib/Monetary.sol
855 
856 /**
857  * @title Monetary
858  * @author dYdX
859  *
860  * Library for types involving money
861  */
862 library Monetary {
863 
864     /*
865      * The price of a base-unit of an asset.
866      */
867     struct Price {
868         uint256 value;
869     }
870 
871     /*
872      * Total value of an some amount of an asset. Equal to (price * amount).
873      */
874     struct Value {
875         uint256 value;
876     }
877 }
878 
879 // File: contracts/protocol/lib/Decimal.sol
880 
881 /**
882  * @title Decimal
883  * @author dYdX
884  *
885  * Library that defines a fixed-point number with 18 decimal places.
886  */
887 library Decimal {
888     using SafeMath for uint256;
889 
890     // ============ Constants ============
891 
892     uint256 constant BASE = 10**18;
893 
894     // ============ Structs ============
895 
896     struct D256 {
897         uint256 value;
898     }
899 
900     // ============ Functions ============
901 
902     function one()
903         internal
904         pure
905         returns (D256 memory)
906     {
907         return D256({ value: BASE });
908     }
909 
910     function onePlus(
911         D256 memory d
912     )
913         internal
914         pure
915         returns (D256 memory)
916     {
917         return D256({ value: d.value.add(BASE) });
918     }
919 
920     function mul(
921         uint256 target,
922         D256 memory d
923     )
924         internal
925         pure
926         returns (uint256)
927     {
928         return Math.getPartial(target, d.value, BASE);
929     }
930 
931     function div(
932         uint256 target,
933         D256 memory d
934     )
935         internal
936         pure
937         returns (uint256)
938     {
939         return Math.getPartial(target, BASE, d.value);
940     }
941 }
942 
943 // File: contracts/protocol/lib/Time.sol
944 
945 /**
946  * @title Time
947  * @author dYdX
948  *
949  * Library for dealing with time, assuming timestamps fit within 32 bits (valid until year 2106)
950  */
951 library Time {
952 
953     // ============ Library Functions ============
954 
955     function currentTime()
956         internal
957         view
958         returns (uint32)
959     {
960         return Math.to32(block.timestamp);
961     }
962 }
963 
964 // File: contracts/protocol/lib/Interest.sol
965 
966 /**
967  * @title Interest
968  * @author dYdX
969  *
970  * Library for managing the interest rate and interest indexes of Solo
971  */
972 library Interest {
973     using Math for uint256;
974     using SafeMath for uint256;
975 
976     // ============ Constants ============
977 
978     bytes32 constant FILE = "Interest";
979     uint64 constant BASE = 10**18;
980 
981     // ============ Structs ============
982 
983     struct Rate {
984         uint256 value;
985     }
986 
987     struct Index {
988         uint96 borrow;
989         uint96 supply;
990         uint32 lastUpdate;
991     }
992 
993     // ============ Library Functions ============
994 
995     /**
996      * Get a new market Index based on the old index and market interest rate.
997      * Calculate interest for borrowers by using the formula rate * time. Approximates
998      * continuously-compounded interest when called frequently, but is much more
999      * gas-efficient to calculate. For suppliers, the interest rate is adjusted by the earningsRate,
1000      * then prorated the across all suppliers.
1001      *
1002      * @param  index         The old index for a market
1003      * @param  rate          The current interest rate of the market
1004      * @param  totalPar      The total supply and borrow par values of the market
1005      * @param  earningsRate  The portion of the interest that is forwarded to the suppliers
1006      * @return               The updated index for a market
1007      */
1008     function calculateNewIndex(
1009         Index memory index,
1010         Rate memory rate,
1011         Types.TotalPar memory totalPar,
1012         Decimal.D256 memory earningsRate
1013     )
1014         internal
1015         view
1016         returns (Index memory)
1017     {
1018         (
1019             Types.Wei memory supplyWei,
1020             Types.Wei memory borrowWei
1021         ) = totalParToWei(totalPar, index);
1022 
1023         // get interest increase for borrowers
1024         uint32 currentTime = Time.currentTime();
1025         uint256 borrowInterest = rate.value.mul(uint256(currentTime).sub(index.lastUpdate));
1026 
1027         // get interest increase for suppliers
1028         uint256 supplyInterest;
1029         if (Types.isZero(supplyWei)) {
1030             supplyInterest = 0;
1031         } else {
1032             supplyInterest = Decimal.mul(borrowInterest, earningsRate);
1033             if (borrowWei.value < supplyWei.value) {
1034                 supplyInterest = Math.getPartial(supplyInterest, borrowWei.value, supplyWei.value);
1035             }
1036         }
1037         assert(supplyInterest <= borrowInterest);
1038 
1039         return Index({
1040             borrow: Math.getPartial(index.borrow, borrowInterest, BASE).add(index.borrow).to96(),
1041             supply: Math.getPartial(index.supply, supplyInterest, BASE).add(index.supply).to96(),
1042             lastUpdate: currentTime
1043         });
1044     }
1045 
1046     function newIndex()
1047         internal
1048         view
1049         returns (Index memory)
1050     {
1051         return Index({
1052             borrow: BASE,
1053             supply: BASE,
1054             lastUpdate: Time.currentTime()
1055         });
1056     }
1057 
1058     /*
1059      * Convert a principal amount to a token amount given an index.
1060      */
1061     function parToWei(
1062         Types.Par memory input,
1063         Index memory index
1064     )
1065         internal
1066         pure
1067         returns (Types.Wei memory)
1068     {
1069         uint256 inputValue = uint256(input.value);
1070         if (input.sign) {
1071             return Types.Wei({
1072                 sign: true,
1073                 value: inputValue.getPartial(index.supply, BASE)
1074             });
1075         } else {
1076             return Types.Wei({
1077                 sign: false,
1078                 value: inputValue.getPartialRoundUp(index.borrow, BASE)
1079             });
1080         }
1081     }
1082 
1083     /*
1084      * Convert a token amount to a principal amount given an index.
1085      */
1086     function weiToPar(
1087         Types.Wei memory input,
1088         Index memory index
1089     )
1090         internal
1091         pure
1092         returns (Types.Par memory)
1093     {
1094         if (input.sign) {
1095             return Types.Par({
1096                 sign: true,
1097                 value: input.value.getPartial(BASE, index.supply).to128()
1098             });
1099         } else {
1100             return Types.Par({
1101                 sign: false,
1102                 value: input.value.getPartialRoundUp(BASE, index.borrow).to128()
1103             });
1104         }
1105     }
1106 
1107     /*
1108      * Convert the total supply and borrow principal amounts of a market to total supply and borrow
1109      * token amounts.
1110      */
1111     function totalParToWei(
1112         Types.TotalPar memory totalPar,
1113         Index memory index
1114     )
1115         internal
1116         pure
1117         returns (Types.Wei memory, Types.Wei memory)
1118     {
1119         Types.Par memory supplyPar = Types.Par({
1120             sign: true,
1121             value: totalPar.supply
1122         });
1123         Types.Par memory borrowPar = Types.Par({
1124             sign: false,
1125             value: totalPar.borrow
1126         });
1127         Types.Wei memory supplyWei = parToWei(supplyPar, index);
1128         Types.Wei memory borrowWei = parToWei(borrowPar, index);
1129         return (supplyWei, borrowWei);
1130     }
1131 }
1132 
1133 // File: contracts/protocol/interfaces/IInterestSetter.sol
1134 
1135 /**
1136  * @title IInterestSetter
1137  * @author dYdX
1138  *
1139  * Interface that Interest Setters for Solo must implement in order to report interest rates.
1140  */
1141 interface IInterestSetter {
1142 
1143     // ============ Public Functions ============
1144 
1145     /**
1146      * Get the interest rate of a token given some borrowed and supplied amounts
1147      *
1148      * @param  token        The address of the ERC20 token for the market
1149      * @param  borrowWei    The total borrowed token amount for the market
1150      * @param  supplyWei    The total supplied token amount for the market
1151      * @return              The interest rate per second
1152      */
1153     function getInterestRate(
1154         address token,
1155         uint256 borrowWei,
1156         uint256 supplyWei
1157     )
1158         external
1159         view
1160         returns (Interest.Rate memory);
1161 }
1162 
1163 // File: contracts/protocol/interfaces/IPriceOracle.sol
1164 
1165 /**
1166  * @title IPriceOracle
1167  * @author dYdX
1168  *
1169  * Interface that Price Oracles for Solo must implement in order to report prices.
1170  */
1171 contract IPriceOracle {
1172 
1173     // ============ Constants ============
1174 
1175     uint256 public constant ONE_DOLLAR = 10 ** 36;
1176 
1177     // ============ Public Functions ============
1178 
1179     /**
1180      * Get the price of a token
1181      *
1182      * @param  token  The ERC20 token address of the market
1183      * @return        The USD price of a base unit of the token, then multiplied by 10^36.
1184      *                So a USD-stable coin with 18 decimal places would return 10^18.
1185      *                This is the price of the base unit rather than the price of a "human-readable"
1186      *                token amount. Every ERC20 may have a different number of decimals.
1187      */
1188     function getPrice(
1189         address token
1190     )
1191         public
1192         view
1193         returns (Monetary.Price memory);
1194 }
1195 
1196 // File: contracts/protocol/lib/Storage.sol
1197 
1198 /**
1199  * @title Storage
1200  * @author dYdX
1201  *
1202  * Functions for reading, writing, and verifying state in Solo
1203  */
1204 library Storage {
1205 
1206     // ============ Structs ============
1207 
1208     // All information necessary for tracking a market
1209     struct Market {
1210         // Contract address of the associated ERC20 token
1211         address token;
1212 
1213         // Total aggregated supply and borrow amount of the entire market
1214         Types.TotalPar totalPar;
1215 
1216         // Interest index of the market
1217         Interest.Index index;
1218 
1219         // Contract address of the price oracle for this market
1220         IPriceOracle priceOracle;
1221 
1222         // Contract address of the interest setter for this market
1223         IInterestSetter interestSetter;
1224 
1225         // Multiplier on the marginRatio for this market
1226         Decimal.D256 marginPremium;
1227 
1228         // Multiplier on the liquidationSpread for this market
1229         Decimal.D256 spreadPremium;
1230 
1231         // Whether additional borrows are allowed for this market
1232         bool isClosing;
1233     }
1234 
1235     // The global risk parameters that govern the health and security of the system
1236     struct RiskParams {
1237         // Required ratio of over-collateralization
1238         Decimal.D256 marginRatio;
1239 
1240         // Percentage penalty incurred by liquidated accounts
1241         Decimal.D256 liquidationSpread;
1242 
1243         // Percentage of the borrower's interest fee that gets passed to the suppliers
1244         Decimal.D256 earningsRate;
1245 
1246         // The minimum absolute borrow value of an account
1247         // There must be sufficient incentivize to liquidate undercollateralized accounts
1248         Monetary.Value minBorrowedValue;
1249     }
1250 
1251     // The maximum RiskParam values that can be set
1252     struct RiskLimits {
1253         uint64 marginRatioMax;
1254         uint64 liquidationSpreadMax;
1255         uint64 earningsRateMax;
1256         uint64 marginPremiumMax;
1257         uint64 spreadPremiumMax;
1258         uint128 minBorrowedValueMax;
1259     }
1260 
1261     // The entire storage state of Solo
1262     struct State {
1263         // number of markets
1264         uint256 numMarkets;
1265 
1266         // marketId => Market
1267         mapping (uint256 => Market) markets;
1268 
1269         // owner => account number => Account
1270         mapping (address => mapping (uint256 => Account.Storage)) accounts;
1271 
1272         // Addresses that can control other users accounts
1273         mapping (address => mapping (address => bool)) operators;
1274 
1275         // Addresses that can control all users accounts
1276         mapping (address => bool) globalOperators;
1277 
1278         // mutable risk parameters of the system
1279         RiskParams riskParams;
1280 
1281         // immutable risk limits of the system
1282         RiskLimits riskLimits;
1283     }
1284 }
1285 
1286 // File: contracts/protocol/State.sol
1287 
1288 /**
1289  * @title State
1290  * @author dYdX
1291  *
1292  * Base-level contract that holds the state of Solo
1293  */
1294 contract State
1295 {
1296     Storage.State g_state;
1297 }
1298 
1299 // File: contracts/protocol/Getters.sol
1300 
1301 /**
1302  * @title Getters
1303  * @author dYdX
1304  *
1305  * Public read-only functions that allow transparency into the state of Solo
1306  */
1307 contract Getters is
1308     State
1309 {
1310     // ============ Getters for Risk ============
1311 
1312     /**
1313      * Get the global minimum margin-ratio that every position must maintain to prevent being
1314      * liquidated.
1315      *
1316      * @return  The global margin-ratio
1317      */
1318     function getMarginRatio()
1319         public
1320         view
1321         returns (Decimal.D256 memory);
1322 
1323     /**
1324      * Get the global liquidation spread. This is the spread between oracle prices that incentivizes
1325      * the liquidation of risky positions.
1326      *
1327      * @return  The global liquidation spread
1328      */
1329     function getLiquidationSpread()
1330         public
1331         view
1332         returns (Decimal.D256 memory);
1333 
1334     /**
1335      * Get the global earnings-rate variable that determines what percentage of the interest paid
1336      * by borrowers gets passed-on to suppliers.
1337      *
1338      * @return  The global earnings rate
1339      */
1340     function getEarningsRate()
1341         public
1342         view
1343         returns (Decimal.D256 memory);
1344 
1345     /**
1346      * Get the global minimum-borrow value which is the minimum value of any new borrow on Solo.
1347      *
1348      * @return  The global minimum borrow value
1349      */
1350     function getMinBorrowedValue()
1351         public
1352         view
1353         returns (Monetary.Value memory);
1354 
1355     /**
1356      * Get all risk parameters in a single struct.
1357      *
1358      * @return  All global risk parameters
1359      */
1360     function getRiskParams()
1361         public
1362         view
1363         returns (Storage.RiskParams memory);
1364 
1365     /**
1366      * Get all risk parameter limits in a single struct. These are the maximum limits at which the
1367      * risk parameters can be set by the admin of Solo.
1368      *
1369      * @return  All global risk parameter limnits
1370      */
1371     function getRiskLimits()
1372         public
1373         view
1374         returns (Storage.RiskLimits memory);
1375 
1376     // ============ Getters for Markets ============
1377 
1378     /**
1379      * Get the total number of markets.
1380      *
1381      * @return  The number of markets
1382      */
1383     function getNumMarkets()
1384         public
1385         view
1386         returns (uint256);
1387 
1388     /**
1389      * Get the ERC20 token address for a market.
1390      *
1391      * @param  marketId  The market to query
1392      * @return           The token address
1393      */
1394     function getMarketTokenAddress(
1395         uint256 marketId
1396     )
1397         public
1398         view
1399         returns (address);
1400 
1401     /**
1402      * Get the total principal amounts (borrowed and supplied) for a market.
1403      *
1404      * @param  marketId  The market to query
1405      * @return           The total principal amounts
1406      */
1407     function getMarketTotalPar(
1408         uint256 marketId
1409     )
1410         public
1411         view
1412         returns (Types.TotalPar memory);
1413 
1414     /**
1415      * Get the most recently cached interest index for a market.
1416      *
1417      * @param  marketId  The market to query
1418      * @return           The most recent index
1419      */
1420     function getMarketCachedIndex(
1421         uint256 marketId
1422     )
1423         public
1424         view
1425         returns (Interest.Index memory);
1426 
1427     /**
1428      * Get the interest index for a market if it were to be updated right now.
1429      *
1430      * @param  marketId  The market to query
1431      * @return           The estimated current index
1432      */
1433     function getMarketCurrentIndex(
1434         uint256 marketId
1435     )
1436         public
1437         view
1438         returns (Interest.Index memory);
1439 
1440     /**
1441      * Get the price oracle address for a market.
1442      *
1443      * @param  marketId  The market to query
1444      * @return           The price oracle address
1445      */
1446     function getMarketPriceOracle(
1447         uint256 marketId
1448     )
1449         public
1450         view
1451         returns (IPriceOracle);
1452 
1453     /**
1454      * Get the interest-setter address for a market.
1455      *
1456      * @param  marketId  The market to query
1457      * @return           The interest-setter address
1458      */
1459     function getMarketInterestSetter(
1460         uint256 marketId
1461     )
1462         public
1463         view
1464         returns (IInterestSetter);
1465 
1466     /**
1467      * Get the margin premium for a market. A margin premium makes it so that any positions that
1468      * include the market require a higher collateralization to avoid being liquidated.
1469      *
1470      * @param  marketId  The market to query
1471      * @return           The market's margin premium
1472      */
1473     function getMarketMarginPremium(
1474         uint256 marketId
1475     )
1476         public
1477         view
1478         returns (Decimal.D256 memory);
1479 
1480     /**
1481      * Get the spread premium for a market. A spread premium makes it so that any liquidations
1482      * that include the market have a higher spread than the global default.
1483      *
1484      * @param  marketId  The market to query
1485      * @return           The market's spread premium
1486      */
1487     function getMarketSpreadPremium(
1488         uint256 marketId
1489     )
1490         public
1491         view
1492         returns (Decimal.D256 memory);
1493 
1494     /**
1495      * Return true if a particular market is in closing mode. Additional borrows cannot be taken
1496      * from a market that is closing.
1497      *
1498      * @param  marketId  The market to query
1499      * @return           True if the market is closing
1500      */
1501     function getMarketIsClosing(
1502         uint256 marketId
1503     )
1504         public
1505         view
1506         returns (bool);
1507 
1508     /**
1509      * Get the price of the token for a market.
1510      *
1511      * @param  marketId  The market to query
1512      * @return           The price of each atomic unit of the token
1513      */
1514     function getMarketPrice(
1515         uint256 marketId
1516     )
1517         public
1518         view
1519         returns (Monetary.Price memory);
1520 
1521     /**
1522      * Get the current borrower interest rate for a market.
1523      *
1524      * @param  marketId  The market to query
1525      * @return           The current interest rate
1526      */
1527     function getMarketInterestRate(
1528         uint256 marketId
1529     )
1530         public
1531         view
1532         returns (Interest.Rate memory);
1533 
1534     /**
1535      * Get the adjusted liquidation spread for some market pair. This is equal to the global
1536      * liquidation spread multiplied by (1 + spreadPremium) for each of the two markets.
1537      *
1538      * @param  heldMarketId  The market for which the account has collateral
1539      * @param  owedMarketId  The market for which the account has borrowed tokens
1540      * @return               The adjusted liquidation spread
1541      */
1542     function getLiquidationSpreadForPair(
1543         uint256 heldMarketId,
1544         uint256 owedMarketId
1545     )
1546         public
1547         view
1548         returns (Decimal.D256 memory);
1549 
1550     /**
1551      * Get basic information about a particular market.
1552      *
1553      * @param  marketId  The market to query
1554      * @return           A Storage.Market struct with the current state of the market
1555      */
1556     function getMarket(
1557         uint256 marketId
1558     )
1559         public
1560         view
1561         returns (Storage.Market memory);
1562 
1563     /**
1564      * Get comprehensive information about a particular market.
1565      *
1566      * @param  marketId  The market to query
1567      * @return           A tuple containing the values:
1568      *                    - A Storage.Market struct with the current state of the market
1569      *                    - The current estimated interest index
1570      *                    - The current token price
1571      *                    - The current market interest rate
1572      */
1573     function getMarketWithInfo(
1574         uint256 marketId
1575     )
1576         public
1577         view
1578         returns (
1579             Storage.Market memory,
1580             Interest.Index memory,
1581             Monetary.Price memory,
1582             Interest.Rate memory
1583         );
1584 
1585     /**
1586      * Get the number of excess tokens for a market. The number of excess tokens is calculated
1587      * by taking the current number of tokens held in Solo, adding the number of tokens owed to Solo
1588      * by borrowers, and subtracting the number of tokens owed to suppliers by Solo.
1589      *
1590      * @param  marketId  The market to query
1591      * @return           The number of excess tokens
1592      */
1593     function getNumExcessTokens(
1594         uint256 marketId
1595     )
1596         public
1597         view
1598         returns (Types.Wei memory);
1599 
1600     // ============ Getters for Accounts ============
1601 
1602     /**
1603      * Get the principal value for a particular account and market.
1604      *
1605      * @param  account   The account to query
1606      * @param  marketId  The market to query
1607      * @return           The principal value
1608      */
1609     function getAccountPar(
1610         Account.Info memory account,
1611         uint256 marketId
1612     )
1613         public
1614         view
1615         returns (Types.Par memory);
1616 
1617     /**
1618      * Get the token balance for a particular account and market.
1619      *
1620      * @param  account   The account to query
1621      * @param  marketId  The market to query
1622      * @return           The token amount
1623      */
1624     function getAccountWei(
1625         Account.Info memory account,
1626         uint256 marketId
1627     )
1628         public
1629         view
1630         returns (Types.Wei memory);
1631 
1632     /**
1633      * Get the status of an account (Normal, Liquidating, or Vaporizing).
1634      *
1635      * @param  account  The account to query
1636      * @return          The account's status
1637      */
1638     function getAccountStatus(
1639         Account.Info memory account
1640     )
1641         public
1642         view
1643         returns (Account.Status);
1644 
1645     /**
1646      * Get the total supplied and total borrowed value of an account.
1647      *
1648      * @param  account  The account to query
1649      * @return          The following values:
1650      *                   - The supplied value of the account
1651      *                   - The borrowed value of the account
1652      */
1653     function getAccountValues(
1654         Account.Info memory account
1655     )
1656         public
1657         view
1658         returns (Monetary.Value memory, Monetary.Value memory);
1659 
1660     /**
1661      * Get the total supplied and total borrowed values of an account adjusted by the marginPremium
1662      * of each market. Supplied values are divided by (1 + marginPremium) for each market and
1663      * borrowed values are multiplied by (1 + marginPremium) for each market. Comparing these
1664      * adjusted values gives the margin-ratio of the account which will be compared to the global
1665      * margin-ratio when determining if the account can be liquidated.
1666      *
1667      * @param  account  The account to query
1668      * @return          The following values:
1669      *                   - The supplied value of the account (adjusted for marginPremium)
1670      *                   - The borrowed value of the account (adjusted for marginPremium)
1671      */
1672     function getAdjustedAccountValues(
1673         Account.Info memory account
1674     )
1675         public
1676         view
1677         returns (Monetary.Value memory, Monetary.Value memory);
1678 
1679     /**
1680      * Get an account's summary for each market.
1681      *
1682      * @param  account  The account to query
1683      * @return          The following values:
1684      *                   - The ERC20 token address for each market
1685      *                   - The account's principal value for each market
1686      *                   - The account's (supplied or borrowed) number of tokens for each market
1687      */
1688     function getAccountBalances(
1689         Account.Info memory account
1690     )
1691         public
1692         view
1693         returns (
1694             address[] memory,
1695             Types.Par[] memory,
1696             Types.Wei[] memory
1697         );
1698 
1699     // ============ Getters for Permissions ============
1700 
1701     /**
1702      * Return true if a particular address is approved as an operator for an owner's accounts.
1703      * Approved operators can act on the accounts of the owner as if it were the operator's own.
1704      *
1705      * @param  owner     The owner of the accounts
1706      * @param  operator  The possible operator
1707      * @return           True if operator is approved for owner's accounts
1708      */
1709     function getIsLocalOperator(
1710         address owner,
1711         address operator
1712     )
1713         public
1714         view
1715         returns (bool);
1716 
1717     /**
1718      * Return true if a particular address is approved as a global operator. Such an address can
1719      * act on any account as if it were the operator's own.
1720      *
1721      * @param  operator  The address to query
1722      * @return           True if operator is a global operator
1723      */
1724     function getIsGlobalOperator(
1725         address operator
1726     )
1727         public
1728         view
1729         returns (bool);
1730 }
1731 
1732 // File: contracts/protocol/lib/Actions.sol
1733 
1734 /**
1735  * @title Actions
1736  * @author dYdX
1737  *
1738  * Library that defines and parses valid Actions
1739  */
1740 library Actions {
1741 
1742     // ============ Enums ============
1743 
1744     enum ActionType {
1745         Deposit,   // supply tokens
1746         Withdraw,  // borrow tokens
1747         Transfer,  // transfer balance between accounts
1748         Buy,       // buy an amount of some token (externally)
1749         Sell,      // sell an amount of some token (externally)
1750         Trade,     // trade tokens against another account
1751         Liquidate, // liquidate an undercollateralized or expiring account
1752         Vaporize,  // use excess tokens to zero-out a completely negative account
1753         Call       // send arbitrary data to an address
1754     }
1755 
1756     // ============ Structs ============
1757 
1758     /*
1759      * Arguments that are passed to Solo in an ordered list as part of a single operation.
1760      * Each ActionArgs has an actionType which specifies which action struct that this data will be
1761      * parsed into before being processed.
1762      */
1763     struct ActionArgs {
1764         ActionType actionType;
1765         uint256 accountId;
1766         Types.AssetAmount amount;
1767         uint256 primaryMarketId;
1768         uint256 secondaryMarketId;
1769         address otherAddress;
1770         uint256 otherAccountId;
1771         bytes data;
1772     }
1773 }
1774 
1775 // File: contracts/protocol/Operation.sol
1776 
1777 /**
1778  * @title Operation
1779  * @author dYdX
1780  *
1781  * Primary public function for allowing users and contracts to manage accounts within Solo
1782  */
1783 contract Operation is
1784     State,
1785     ReentrancyGuard
1786 {
1787     // ============ Public Functions ============
1788 
1789     /**
1790      * The main entry-point to Solo that allows users and contracts to manage accounts.
1791      * Take one or more actions on one or more accounts. The msg.sender must be the owner or
1792      * operator of all accounts except for those being liquidated, vaporized, or traded with.
1793      * One call to operate() is considered a singular "operation". Account collateralization is
1794      * ensured only after the completion of the entire operation.
1795      *
1796      * @param  accounts  A list of all accounts that will be used in this operation. Cannot contain
1797      *                   duplicates. In each action, the relevant account will be referred-to by its
1798      *                   index in the list.
1799      * @param  actions   An ordered list of all actions that will be taken in this operation. The
1800      *                   actions will be processed in order.
1801      */
1802     function operate(
1803         Account.Info[] memory accounts,
1804         Actions.ActionArgs[] memory actions
1805     )
1806         public;
1807 }
1808 
1809 // File: contracts/protocol/SoloMargin.sol
1810 
1811 /**
1812  * @title SoloMargin
1813  * @author dYdX
1814  *
1815  * Main contract that inherits from other contracts
1816  */
1817 contract SoloMargin is
1818     State,
1819     Getters,
1820     Operation
1821 {
1822 }
1823 
1824 // File: contracts/external/helpers/OnlySolo.sol
1825 
1826 /**
1827  * @title OnlySolo
1828  * @author dYdX
1829  *
1830  * Inheritable contract that restricts the calling of certain functions to Solo only
1831  */
1832 contract OnlySolo {
1833 
1834     // ============ Constants ============
1835 
1836     bytes32 constant FILE = "OnlySolo";
1837 
1838     // ============ Storage ============
1839 
1840     SoloMargin public SOLO_MARGIN;
1841 
1842     // ============ Constructor ============
1843 
1844     constructor (
1845         address soloMargin
1846     )
1847         public
1848     {
1849         SOLO_MARGIN = SoloMargin(soloMargin);
1850     }
1851 
1852     // ============ Modifiers ============
1853 
1854     modifier onlySolo(address from) {
1855         Require.that(
1856             from == address(SOLO_MARGIN),
1857             FILE,
1858             "Only Solo can call function",
1859             from
1860         );
1861         _;
1862     }
1863 }
1864 
1865 // File: contracts/external/proxies/LiquidatorProxyV1ForSoloMargin.sol
1866 
1867 /**
1868  * @title LiquidatorProxyV1ForSoloMargin
1869  * @author dYdX
1870  *
1871  * Contract for liquidating other accounts in Solo. Does not take marginPremium into account.
1872  */
1873 contract LiquidatorProxyV1ForSoloMargin is
1874     OnlySolo,
1875     ReentrancyGuard
1876 {
1877     using Math for uint256;
1878     using SafeMath for uint256;
1879     using Types for Types.Par;
1880     using Types for Types.Wei;
1881 
1882     // ============ Constants ============
1883 
1884     bytes32 constant FILE = "LiquidatorProxyV1ForSoloMargin";
1885 
1886     // ============ Structs ============
1887 
1888     struct Constants {
1889         Account.Info fromAccount;
1890         Account.Info liquidAccount;
1891         Decimal.D256 minLiquidatorRatio;
1892         MarketInfo[] markets;
1893     }
1894 
1895     struct MarketInfo {
1896         Monetary.Price price;
1897         Interest.Index index;
1898     }
1899 
1900     struct Cache {
1901         // mutable
1902         uint256 toLiquidate;
1903         Types.Wei heldWei;
1904         Types.Wei owedWei;
1905         uint256 supplyValue;
1906         uint256 borrowValue;
1907 
1908         // immutable
1909         Decimal.D256 spread;
1910         uint256 heldMarket;
1911         uint256 owedMarket;
1912         uint256 heldPrice;
1913         uint256 owedPrice;
1914         uint256 owedPriceAdj;
1915     }
1916 
1917     // ============ Constructor ============
1918 
1919     constructor (
1920         address soloMargin
1921     )
1922         public
1923         OnlySolo(soloMargin)
1924     {} /* solium-disable-line no-empty-blocks */
1925 
1926     // ============ Public Functions ============
1927 
1928     /**
1929      * Liquidate liquidAccount using fromAccount. This contract and the msg.sender to this contract
1930      * must both be operators for the fromAccount.
1931      *
1932      * @param  fromAccount         The account that will do the liquidating
1933      * @param  liquidAccount       The account that will be liquidated
1934      * @param  minLiquidatorRatio  The minimum collateralization ratio to leave the fromAccount at
1935      * @param  owedPreferences     Ordered list of markets to repay first
1936      * @param  heldPreferences     Ordered list of markets to recieve payout for first
1937      */
1938     function liquidate(
1939         Account.Info memory fromAccount,
1940         Account.Info memory liquidAccount,
1941         Decimal.D256 memory minLiquidatorRatio,
1942         uint256 minValueLiquidated,
1943         uint256[] memory owedPreferences,
1944         uint256[] memory heldPreferences
1945     )
1946         public
1947         nonReentrant
1948     {
1949         // put all values that will not change into a single struct
1950         Constants memory constants = Constants({
1951             fromAccount: fromAccount,
1952             liquidAccount: liquidAccount,
1953             minLiquidatorRatio: minLiquidatorRatio,
1954             markets: getMarketsInfo()
1955         });
1956 
1957         // validate the msg.sender and that the liquidAccount can be liquidated
1958         checkRequirements(constants);
1959 
1960         // keep a running tally of how much value will be attempted to be liquidated
1961         uint256 totalValueLiquidated = 0;
1962 
1963         // for each owedMarket
1964         for (uint256 owedIndex = 0; owedIndex < owedPreferences.length; owedIndex++) {
1965             uint256 owedMarket = owedPreferences[owedIndex];
1966 
1967             // for each heldMarket
1968             for (uint256 heldIndex = 0; heldIndex < heldPreferences.length; heldIndex++) {
1969                 uint256 heldMarket = heldPreferences[heldIndex];
1970 
1971                 // cannot use the same market
1972                 if (heldMarket == owedMarket) {
1973                     continue;
1974                 }
1975 
1976                 // cannot liquidate non-negative markets
1977                 if (!SOLO_MARGIN.getAccountPar(liquidAccount, owedMarket).isNegative()) {
1978                     break;
1979                 }
1980 
1981                 // cannot use non-positive markets as collateral
1982                 if (!SOLO_MARGIN.getAccountPar(liquidAccount, heldMarket).isPositive()) {
1983                     continue;
1984                 }
1985 
1986                 // get all relevant values
1987                 Cache memory cache = initializeCache(
1988                     constants,
1989                     heldMarket,
1990                     owedMarket
1991                 );
1992 
1993                 // get the liquidation amount (before liquidator decreases in collateralization)
1994                 calculateSafeLiquidationAmount(cache);
1995 
1996                 // get the max liquidation amount (before liquidator reaches minLiquidatorRatio)
1997                 calculateMaxLiquidationAmount(constants, cache);
1998 
1999                 // if nothing to liquidate, do nothing
2000                 if (cache.toLiquidate == 0) {
2001                     continue;
2002                 }
2003 
2004                 // execute the liquidations
2005                 SOLO_MARGIN.operate(
2006                     constructAccountsArray(constants),
2007                     constructActionsArray(cache)
2008                 );
2009 
2010                 // increment the total value liquidated
2011                 totalValueLiquidated =
2012                     totalValueLiquidated.add(cache.toLiquidate.mul(cache.owedPrice));
2013             }
2014         }
2015 
2016         // revert if liquidator account does not have a lot of overhead to liquidate these pairs
2017         Require.that(
2018             totalValueLiquidated >= minValueLiquidated,
2019             FILE,
2020             "Not enough liquidatable value",
2021             totalValueLiquidated,
2022             minValueLiquidated
2023         );
2024     }
2025 
2026     // ============ Calculation Functions ============
2027 
2028     /**
2029      * Calculate the owedAmount that can be liquidated until the liquidator account will be left
2030      * with BOTH a non-negative balance of heldMarket AND a non-positive balance of owedMarket.
2031      * This is the amount that can be liquidated until the collateralization of the liquidator
2032      * account will begin to decrease.
2033      */
2034     function calculateSafeLiquidationAmount(
2035         Cache memory cache
2036     )
2037         private
2038         pure
2039     {
2040         bool negOwed = !cache.owedWei.isPositive();
2041         bool posHeld = !cache.heldWei.isNegative();
2042 
2043         // owedWei is already negative and heldWei is already positive
2044         if (negOwed && posHeld) {
2045             return;
2046         }
2047 
2048         // true if it takes longer for the liquidator owed balance to become negative than it takes
2049         // the liquidator held balance to become positive.
2050         bool owedGoesToZeroLast;
2051         if (negOwed) {
2052             owedGoesToZeroLast = false;
2053         } else if (posHeld) {
2054             owedGoesToZeroLast = true;
2055         } else {
2056             // owed is still positive and held is still negative
2057             owedGoesToZeroLast =
2058                 cache.owedWei.value.mul(cache.owedPriceAdj) >
2059                 cache.heldWei.value.mul(cache.heldPrice);
2060         }
2061 
2062         if (owedGoesToZeroLast) {
2063             // calculate the change in heldWei to get owedWei to zero
2064             Types.Wei memory heldWeiDelta = Types.Wei({
2065                 sign: cache.owedWei.sign,
2066                 value: cache.owedWei.value.getPartial(cache.owedPriceAdj, cache.heldPrice)
2067             });
2068             setCacheWeiValues(
2069                 cache,
2070                 cache.heldWei.add(heldWeiDelta),
2071                 Types.zeroWei()
2072             );
2073         } else {
2074             // calculate the change in owedWei to get heldWei to zero
2075             Types.Wei memory owedWeiDelta = Types.Wei({
2076                 sign: cache.heldWei.sign,
2077                 value: cache.heldWei.value.getPartial(cache.heldPrice, cache.owedPriceAdj)
2078             });
2079             setCacheWeiValues(
2080                 cache,
2081                 Types.zeroWei(),
2082                 cache.owedWei.add(owedWeiDelta)
2083             );
2084         }
2085     }
2086 
2087     /**
2088      * Calculate the additional owedAmount that can be liquidated until the collateralization of the
2089      * liquidator account reaches the minLiquidatorRatio. By this point, the cache will be set such
2090      * that the amount of owedMarket is non-positive and the amount of heldMarket is non-negative.
2091      */
2092     function calculateMaxLiquidationAmount(
2093         Constants memory constants,
2094         Cache memory cache
2095     )
2096         private
2097         pure
2098     {
2099         assert(!cache.heldWei.isNegative());
2100         assert(!cache.owedWei.isPositive());
2101 
2102         // if the liquidator account is already not above the collateralization requirement, return
2103         bool liquidatorAboveCollateralization = isCollateralized(
2104             cache.supplyValue,
2105             cache.borrowValue,
2106             constants.minLiquidatorRatio
2107         );
2108         if (!liquidatorAboveCollateralization) {
2109             cache.toLiquidate = 0;
2110             return;
2111         }
2112 
2113         // find the value difference between the current margin and the margin at minLiquidatorRatio
2114         uint256 requiredOverhead = Decimal.mul(cache.borrowValue, constants.minLiquidatorRatio);
2115         uint256 requiredSupplyValue = cache.borrowValue.add(requiredOverhead);
2116         uint256 remainingValueBuffer = cache.supplyValue.sub(requiredSupplyValue);
2117 
2118         // get the absolute difference between the minLiquidatorRatio and the liquidation spread
2119         Decimal.D256 memory spreadMarginDiff = Decimal.D256({
2120             value: constants.minLiquidatorRatio.value.sub(cache.spread.value)
2121         });
2122 
2123         // get the additional value of owedToken I can borrow to liquidate this position
2124         uint256 owedValueToTakeOn = Decimal.div(remainingValueBuffer, spreadMarginDiff);
2125 
2126         // get the additional amount of owedWei to liquidate
2127         uint256 owedWeiToLiquidate = owedValueToTakeOn.div(cache.owedPrice);
2128 
2129         // store the additional amount in the cache
2130         cache.toLiquidate = cache.toLiquidate.add(owedWeiToLiquidate);
2131     }
2132 
2133     // ============ Helper Functions ============
2134 
2135     /**
2136      * Make some basic checks before attempting to liquidate an account.
2137      *  - Require that the msg.sender is permissioned to use the liquidator account
2138      *  - Require that the liquid account is liquidatable
2139      */
2140     function checkRequirements(
2141         Constants memory constants
2142     )
2143         private
2144         view
2145     {
2146         // check credentials for msg.sender
2147         Require.that(
2148             constants.fromAccount.owner == msg.sender
2149             || SOLO_MARGIN.getIsLocalOperator(constants.fromAccount.owner, msg.sender),
2150             FILE,
2151             "Sender not operator",
2152             constants.fromAccount.owner
2153         );
2154 
2155         // require that the liquidAccount is liquidatable
2156         (
2157             Monetary.Value memory liquidSupplyValue,
2158             Monetary.Value memory liquidBorrowValue
2159         ) = getCurrentAccountValues(constants, constants.liquidAccount);
2160         Require.that(
2161             liquidSupplyValue.value != 0,
2162             FILE,
2163             "Liquid account no supply"
2164         );
2165         Require.that(
2166             SOLO_MARGIN.getAccountStatus(constants.liquidAccount) == Account.Status.Liquid
2167             || !isCollateralized(
2168                 liquidSupplyValue.value,
2169                 liquidBorrowValue.value,
2170                 SOLO_MARGIN.getMarginRatio()
2171             ),
2172             FILE,
2173             "Liquid account not liquidatable",
2174             liquidSupplyValue.value,
2175             liquidBorrowValue.value
2176         );
2177     }
2178 
2179     /**
2180      * Changes the cache values to reflect changing the heldWei and owedWei of the liquidator
2181      * account. Changes toLiquidate, heldWei, owedWei, supplyValue, and borrowValue.
2182      */
2183     function setCacheWeiValues(
2184         Cache memory cache,
2185         Types.Wei memory newHeldWei,
2186         Types.Wei memory newOwedWei
2187     )
2188         private
2189         pure
2190     {
2191         // roll-back the old held value
2192         uint256 oldHeldValue = cache.heldWei.value.mul(cache.heldPrice);
2193         if (cache.heldWei.sign) {
2194             cache.supplyValue = cache.supplyValue.sub(oldHeldValue);
2195         } else {
2196             cache.borrowValue = cache.borrowValue.sub(oldHeldValue);
2197         }
2198 
2199         // add the new held value
2200         uint256 newHeldValue = newHeldWei.value.mul(cache.heldPrice);
2201         if (newHeldWei.sign) {
2202             cache.supplyValue = cache.supplyValue.add(newHeldValue);
2203         } else {
2204             cache.borrowValue = cache.borrowValue.add(newHeldValue);
2205         }
2206 
2207         // roll-back the old owed value
2208         uint256 oldOwedValue = cache.owedWei.value.mul(cache.owedPrice);
2209         if (cache.owedWei.sign) {
2210             cache.supplyValue = cache.supplyValue.sub(oldOwedValue);
2211         } else {
2212             cache.borrowValue = cache.borrowValue.sub(oldOwedValue);
2213         }
2214 
2215         // add the new owed value
2216         uint256 newOwedValue = newOwedWei.value.mul(cache.owedPrice);
2217         if (newOwedWei.sign) {
2218             cache.supplyValue = cache.supplyValue.add(newOwedValue);
2219         } else {
2220             cache.borrowValue = cache.borrowValue.add(newOwedValue);
2221         }
2222 
2223         // update toLiquidate, heldWei, and owedWei
2224         Types.Wei memory delta = cache.owedWei.sub(newOwedWei);
2225         assert(!delta.isNegative());
2226         cache.toLiquidate = cache.toLiquidate.add(delta.value);
2227         cache.heldWei = newHeldWei;
2228         cache.owedWei = newOwedWei;
2229     }
2230 
2231     /**
2232      * Returns true if the supplyValue over-collateralizes the borrowValue by the ratio.
2233      */
2234     function isCollateralized(
2235         uint256 supplyValue,
2236         uint256 borrowValue,
2237         Decimal.D256 memory ratio
2238     )
2239         private
2240         pure
2241         returns(bool)
2242     {
2243         uint256 requiredMargin = Decimal.mul(borrowValue, ratio);
2244         return supplyValue >= borrowValue.add(requiredMargin);
2245     }
2246 
2247     // ============ Getter Functions ============
2248 
2249     /**
2250      * Gets the current total supplyValue and borrowValue for some account. Takes into account what
2251      * the current index will be once updated.
2252      */
2253     function getCurrentAccountValues(
2254         Constants memory constants,
2255         Account.Info memory account
2256     )
2257         private
2258         view
2259         returns (
2260             Monetary.Value memory,
2261             Monetary.Value memory
2262         )
2263     {
2264         Monetary.Value memory supplyValue;
2265         Monetary.Value memory borrowValue;
2266 
2267         for (uint256 m = 0; m < constants.markets.length; m++) {
2268             Types.Par memory par = SOLO_MARGIN.getAccountPar(account, m);
2269             if (par.isZero()) {
2270                 continue;
2271             }
2272             Types.Wei memory userWei = Interest.parToWei(par, constants.markets[m].index);
2273             uint256 assetValue = userWei.value.mul(constants.markets[m].price.value);
2274             if (userWei.sign) {
2275                 supplyValue.value = supplyValue.value.add(assetValue);
2276             } else {
2277                 borrowValue.value = borrowValue.value.add(assetValue);
2278             }
2279         }
2280 
2281         return (supplyValue, borrowValue);
2282     }
2283 
2284     /**
2285      * Get the updated index and price for every market.
2286      */
2287     function getMarketsInfo()
2288         private
2289         view
2290         returns (MarketInfo[] memory)
2291     {
2292         uint256 numMarkets = SOLO_MARGIN.getNumMarkets();
2293         MarketInfo[] memory markets = new MarketInfo[](numMarkets);
2294         for (uint256 m = 0; m < numMarkets; m++) {
2295             markets[m] = MarketInfo({
2296                 price: SOLO_MARGIN.getMarketPrice(m),
2297                 index: SOLO_MARGIN.getMarketCurrentIndex(m)
2298             });
2299         }
2300         return markets;
2301     }
2302 
2303     /**
2304      * Pre-populates cache values for some pair of markets.
2305      */
2306     function initializeCache(
2307         Constants memory constants,
2308         uint256 heldMarket,
2309         uint256 owedMarket
2310     )
2311         private
2312         view
2313         returns (Cache memory)
2314     {
2315         (
2316             Monetary.Value memory supplyValue,
2317             Monetary.Value memory borrowValue
2318         ) = getCurrentAccountValues(constants, constants.fromAccount);
2319 
2320         uint256 heldPrice = constants.markets[heldMarket].price.value;
2321         uint256 owedPrice = constants.markets[owedMarket].price.value;
2322         Decimal.D256 memory spread =
2323             SOLO_MARGIN.getLiquidationSpreadForPair(heldMarket, owedMarket);
2324 
2325         return Cache({
2326             heldWei: Interest.parToWei(
2327                 SOLO_MARGIN.getAccountPar(constants.fromAccount, heldMarket),
2328                 constants.markets[heldMarket].index
2329             ),
2330             owedWei: Interest.parToWei(
2331                 SOLO_MARGIN.getAccountPar(constants.fromAccount, owedMarket),
2332                 constants.markets[owedMarket].index
2333             ),
2334             toLiquidate: 0,
2335             supplyValue: supplyValue.value,
2336             borrowValue: borrowValue.value,
2337             heldMarket: heldMarket,
2338             owedMarket: owedMarket,
2339             spread: spread,
2340             heldPrice: heldPrice,
2341             owedPrice: owedPrice,
2342             owedPriceAdj: Decimal.mul(owedPrice, Decimal.onePlus(spread))
2343         });
2344     }
2345 
2346     // ============ Operation-Construction Functions ============
2347 
2348     function constructAccountsArray(
2349         Constants memory constants
2350     )
2351         private
2352         pure
2353         returns (Account.Info[] memory)
2354     {
2355         Account.Info[] memory accounts = new Account.Info[](2);
2356         accounts[0] = constants.fromAccount;
2357         accounts[1] = constants.liquidAccount;
2358         return accounts;
2359     }
2360 
2361     function constructActionsArray(
2362         Cache memory cache
2363     )
2364         private
2365         pure
2366         returns (Actions.ActionArgs[] memory)
2367     {
2368         Actions.ActionArgs[] memory actions = new Actions.ActionArgs[](1);
2369         actions[0] = Actions.ActionArgs({
2370             actionType: Actions.ActionType.Liquidate,
2371             accountId: 0,
2372             amount: Types.AssetAmount({
2373                 sign: true,
2374                 denomination: Types.AssetDenomination.Wei,
2375                 ref: Types.AssetReference.Delta,
2376                 value: cache.toLiquidate
2377             }),
2378             primaryMarketId: cache.owedMarket,
2379             secondaryMarketId: cache.heldMarket,
2380             otherAddress: address(0),
2381             otherAccountId: 1,
2382             data: new bytes(0)
2383         });
2384         return actions;
2385     }
2386 }