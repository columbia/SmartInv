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
88 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
89 
90 /**
91  * @title Ownable
92  * @dev The Ownable contract has an owner address, and provides basic authorization control
93  * functions, this simplifies the implementation of "user permissions".
94  */
95 contract Ownable {
96     address private _owner;
97 
98     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
99 
100     /**
101      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
102      * account.
103      */
104     constructor () internal {
105         _owner = msg.sender;
106         emit OwnershipTransferred(address(0), _owner);
107     }
108 
109     /**
110      * @return the address of the owner.
111      */
112     function owner() public view returns (address) {
113         return _owner;
114     }
115 
116     /**
117      * @dev Throws if called by any account other than the owner.
118      */
119     modifier onlyOwner() {
120         require(isOwner());
121         _;
122     }
123 
124     /**
125      * @return true if `msg.sender` is the owner of the contract.
126      */
127     function isOwner() public view returns (bool) {
128         return msg.sender == _owner;
129     }
130 
131     /**
132      * @dev Allows the current owner to relinquish control of the contract.
133      * @notice Renouncing to ownership will leave the contract without an owner.
134      * It will not be possible to call the functions with the `onlyOwner`
135      * modifier anymore.
136      */
137     function renounceOwnership() public onlyOwner {
138         emit OwnershipTransferred(_owner, address(0));
139         _owner = address(0);
140     }
141 
142     /**
143      * @dev Allows the current owner to transfer control of the contract to a newOwner.
144      * @param newOwner The address to transfer ownership to.
145      */
146     function transferOwnership(address newOwner) public onlyOwner {
147         _transferOwnership(newOwner);
148     }
149 
150     /**
151      * @dev Transfers control of the contract to a newOwner.
152      * @param newOwner The address to transfer ownership to.
153      */
154     function _transferOwnership(address newOwner) internal {
155         require(newOwner != address(0));
156         emit OwnershipTransferred(_owner, newOwner);
157         _owner = newOwner;
158     }
159 }
160 
161 // File: contracts/protocol/lib/Require.sol
162 
163 /**
164  * @title Require
165  * @author dYdX
166  *
167  * Stringifies parameters to pretty-print revert messages. Costs more gas than regular require()
168  */
169 library Require {
170 
171     // ============ Constants ============
172 
173     uint256 constant ASCII_ZERO = 48; // '0'
174     uint256 constant ASCII_RELATIVE_ZERO = 87; // 'a' - 10
175     uint256 constant ASCII_LOWER_EX = 120; // 'x'
176     bytes2 constant COLON = 0x3a20; // ': '
177     bytes2 constant COMMA = 0x2c20; // ', '
178     bytes2 constant LPAREN = 0x203c; // ' <'
179     byte constant RPAREN = 0x3e; // '>'
180     uint256 constant FOUR_BIT_MASK = 0xf;
181 
182     // ============ Library Functions ============
183 
184     function that(
185         bool must,
186         bytes32 file,
187         bytes32 reason
188     )
189         internal
190         pure
191     {
192         if (!must) {
193             revert(
194                 string(
195                     abi.encodePacked(
196                         stringify(file),
197                         COLON,
198                         stringify(reason)
199                     )
200                 )
201             );
202         }
203     }
204 
205     function that(
206         bool must,
207         bytes32 file,
208         bytes32 reason,
209         uint256 payloadA
210     )
211         internal
212         pure
213     {
214         if (!must) {
215             revert(
216                 string(
217                     abi.encodePacked(
218                         stringify(file),
219                         COLON,
220                         stringify(reason),
221                         LPAREN,
222                         stringify(payloadA),
223                         RPAREN
224                     )
225                 )
226             );
227         }
228     }
229 
230     function that(
231         bool must,
232         bytes32 file,
233         bytes32 reason,
234         uint256 payloadA,
235         uint256 payloadB
236     )
237         internal
238         pure
239     {
240         if (!must) {
241             revert(
242                 string(
243                     abi.encodePacked(
244                         stringify(file),
245                         COLON,
246                         stringify(reason),
247                         LPAREN,
248                         stringify(payloadA),
249                         COMMA,
250                         stringify(payloadB),
251                         RPAREN
252                     )
253                 )
254             );
255         }
256     }
257 
258     function that(
259         bool must,
260         bytes32 file,
261         bytes32 reason,
262         address payloadA
263     )
264         internal
265         pure
266     {
267         if (!must) {
268             revert(
269                 string(
270                     abi.encodePacked(
271                         stringify(file),
272                         COLON,
273                         stringify(reason),
274                         LPAREN,
275                         stringify(payloadA),
276                         RPAREN
277                     )
278                 )
279             );
280         }
281     }
282 
283     function that(
284         bool must,
285         bytes32 file,
286         bytes32 reason,
287         address payloadA,
288         uint256 payloadB
289     )
290         internal
291         pure
292     {
293         if (!must) {
294             revert(
295                 string(
296                     abi.encodePacked(
297                         stringify(file),
298                         COLON,
299                         stringify(reason),
300                         LPAREN,
301                         stringify(payloadA),
302                         COMMA,
303                         stringify(payloadB),
304                         RPAREN
305                     )
306                 )
307             );
308         }
309     }
310 
311     function that(
312         bool must,
313         bytes32 file,
314         bytes32 reason,
315         address payloadA,
316         uint256 payloadB,
317         uint256 payloadC
318     )
319         internal
320         pure
321     {
322         if (!must) {
323             revert(
324                 string(
325                     abi.encodePacked(
326                         stringify(file),
327                         COLON,
328                         stringify(reason),
329                         LPAREN,
330                         stringify(payloadA),
331                         COMMA,
332                         stringify(payloadB),
333                         COMMA,
334                         stringify(payloadC),
335                         RPAREN
336                     )
337                 )
338             );
339         }
340     }
341 
342     // ============ Private Functions ============
343 
344     function stringify(
345         bytes32 input
346     )
347         private
348         pure
349         returns (bytes memory)
350     {
351         // put the input bytes into the result
352         bytes memory result = abi.encodePacked(input);
353 
354         // determine the length of the input by finding the location of the last non-zero byte
355         for (uint256 i = 32; i > 0; ) {
356             // reverse-for-loops with unsigned integer
357             /* solium-disable-next-line security/no-modify-for-iter-var */
358             i--;
359 
360             // find the last non-zero byte in order to determine the length
361             if (result[i] != 0) {
362                 uint256 length = i + 1;
363 
364                 /* solium-disable-next-line security/no-inline-assembly */
365                 assembly {
366                     mstore(result, length) // r.length = length;
367                 }
368 
369                 return result;
370             }
371         }
372 
373         // all bytes are zero
374         return new bytes(0);
375     }
376 
377     function stringify(
378         uint256 input
379     )
380         private
381         pure
382         returns (bytes memory)
383     {
384         if (input == 0) {
385             return "0";
386         }
387 
388         // get the final string length
389         uint256 j = input;
390         uint256 length;
391         while (j != 0) {
392             length++;
393             j /= 10;
394         }
395 
396         // allocate the string
397         bytes memory bstr = new bytes(length);
398 
399         // populate the string starting with the least-significant character
400         j = input;
401         for (uint256 i = length; i > 0; ) {
402             // reverse-for-loops with unsigned integer
403             /* solium-disable-next-line security/no-modify-for-iter-var */
404             i--;
405 
406             // take last decimal digit
407             bstr[i] = byte(uint8(ASCII_ZERO + (j % 10)));
408 
409             // remove the last decimal digit
410             j /= 10;
411         }
412 
413         return bstr;
414     }
415 
416     function stringify(
417         address input
418     )
419         private
420         pure
421         returns (bytes memory)
422     {
423         uint256 z = uint256(input);
424 
425         // addresses are "0x" followed by 20 bytes of data which take up 2 characters each
426         bytes memory result = new bytes(42);
427 
428         // populate the result with "0x"
429         result[0] = byte(uint8(ASCII_ZERO));
430         result[1] = byte(uint8(ASCII_LOWER_EX));
431 
432         // for each byte (starting from the lowest byte), populate the result with two characters
433         for (uint256 i = 0; i < 20; i++) {
434             // each byte takes two characters
435             uint256 shift = i * 2;
436 
437             // populate the least-significant character
438             result[41 - shift] = char(z & FOUR_BIT_MASK);
439             z = z >> 4;
440 
441             // populate the most-significant character
442             result[40 - shift] = char(z & FOUR_BIT_MASK);
443             z = z >> 4;
444         }
445 
446         return result;
447     }
448 
449     function char(
450         uint256 input
451     )
452         private
453         pure
454         returns (byte)
455     {
456         // return ASCII digit (0-9)
457         if (input < 10) {
458             return byte(uint8(input + ASCII_ZERO));
459         }
460 
461         // return ASCII letter (a-f)
462         return byte(uint8(input + ASCII_RELATIVE_ZERO));
463     }
464 }
465 
466 // File: contracts/protocol/lib/Math.sol
467 
468 /**
469  * @title Math
470  * @author dYdX
471  *
472  * Library for non-standard Math functions
473  */
474 library Math {
475     using SafeMath for uint256;
476 
477     // ============ Constants ============
478 
479     bytes32 constant FILE = "Math";
480 
481     // ============ Library Functions ============
482 
483     /*
484      * Return target * (numerator / denominator).
485      */
486     function getPartial(
487         uint256 target,
488         uint256 numerator,
489         uint256 denominator
490     )
491         internal
492         pure
493         returns (uint256)
494     {
495         return target.mul(numerator).div(denominator);
496     }
497 
498     /*
499      * Return target * (numerator / denominator), but rounded up.
500      */
501     function getPartialRoundUp(
502         uint256 target,
503         uint256 numerator,
504         uint256 denominator
505     )
506         internal
507         pure
508         returns (uint256)
509     {
510         if (target == 0 || numerator == 0) {
511             // SafeMath will check for zero denominator
512             return SafeMath.div(0, denominator);
513         }
514         return target.mul(numerator).sub(1).div(denominator).add(1);
515     }
516 
517     function to128(
518         uint256 number
519     )
520         internal
521         pure
522         returns (uint128)
523     {
524         uint128 result = uint128(number);
525         Require.that(
526             result == number,
527             FILE,
528             "Unsafe cast to uint128"
529         );
530         return result;
531     }
532 
533     function to96(
534         uint256 number
535     )
536         internal
537         pure
538         returns (uint96)
539     {
540         uint96 result = uint96(number);
541         Require.that(
542             result == number,
543             FILE,
544             "Unsafe cast to uint96"
545         );
546         return result;
547     }
548 
549     function to32(
550         uint256 number
551     )
552         internal
553         pure
554         returns (uint32)
555     {
556         uint32 result = uint32(number);
557         Require.that(
558             result == number,
559             FILE,
560             "Unsafe cast to uint32"
561         );
562         return result;
563     }
564 
565     function min(
566         uint256 a,
567         uint256 b
568     )
569         internal
570         pure
571         returns (uint256)
572     {
573         return a < b ? a : b;
574     }
575 
576     function max(
577         uint256 a,
578         uint256 b
579     )
580         internal
581         pure
582         returns (uint256)
583     {
584         return a > b ? a : b;
585     }
586 }
587 
588 // File: contracts/protocol/lib/Types.sol
589 
590 /**
591  * @title Types
592  * @author dYdX
593  *
594  * Library for interacting with the basic structs used in Solo
595  */
596 library Types {
597     using Math for uint256;
598 
599     // ============ AssetAmount ============
600 
601     enum AssetDenomination {
602         Wei, // the amount is denominated in wei
603         Par  // the amount is denominated in par
604     }
605 
606     enum AssetReference {
607         Delta, // the amount is given as a delta from the current value
608         Target // the amount is given as an exact number to end up at
609     }
610 
611     struct AssetAmount {
612         bool sign; // true if positive
613         AssetDenomination denomination;
614         AssetReference ref;
615         uint256 value;
616     }
617 
618     // ============ Par (Principal Amount) ============
619 
620     // Total borrow and supply values for a market
621     struct TotalPar {
622         uint128 borrow;
623         uint128 supply;
624     }
625 
626     // Individual principal amount for an account
627     struct Par {
628         bool sign; // true if positive
629         uint128 value;
630     }
631 
632     function zeroPar()
633         internal
634         pure
635         returns (Par memory)
636     {
637         return Par({
638             sign: false,
639             value: 0
640         });
641     }
642 
643     function sub(
644         Par memory a,
645         Par memory b
646     )
647         internal
648         pure
649         returns (Par memory)
650     {
651         return add(a, negative(b));
652     }
653 
654     function add(
655         Par memory a,
656         Par memory b
657     )
658         internal
659         pure
660         returns (Par memory)
661     {
662         Par memory result;
663         if (a.sign == b.sign) {
664             result.sign = a.sign;
665             result.value = SafeMath.add(a.value, b.value).to128();
666         } else {
667             if (a.value >= b.value) {
668                 result.sign = a.sign;
669                 result.value = SafeMath.sub(a.value, b.value).to128();
670             } else {
671                 result.sign = b.sign;
672                 result.value = SafeMath.sub(b.value, a.value).to128();
673             }
674         }
675         return result;
676     }
677 
678     function equals(
679         Par memory a,
680         Par memory b
681     )
682         internal
683         pure
684         returns (bool)
685     {
686         if (a.value == b.value) {
687             if (a.value == 0) {
688                 return true;
689             }
690             return a.sign == b.sign;
691         }
692         return false;
693     }
694 
695     function negative(
696         Par memory a
697     )
698         internal
699         pure
700         returns (Par memory)
701     {
702         return Par({
703             sign: !a.sign,
704             value: a.value
705         });
706     }
707 
708     function isNegative(
709         Par memory a
710     )
711         internal
712         pure
713         returns (bool)
714     {
715         return !a.sign && a.value > 0;
716     }
717 
718     function isPositive(
719         Par memory a
720     )
721         internal
722         pure
723         returns (bool)
724     {
725         return a.sign && a.value > 0;
726     }
727 
728     function isZero(
729         Par memory a
730     )
731         internal
732         pure
733         returns (bool)
734     {
735         return a.value == 0;
736     }
737 
738     // ============ Wei (Token Amount) ============
739 
740     // Individual token amount for an account
741     struct Wei {
742         bool sign; // true if positive
743         uint256 value;
744     }
745 
746     function zeroWei()
747         internal
748         pure
749         returns (Wei memory)
750     {
751         return Wei({
752             sign: false,
753             value: 0
754         });
755     }
756 
757     function sub(
758         Wei memory a,
759         Wei memory b
760     )
761         internal
762         pure
763         returns (Wei memory)
764     {
765         return add(a, negative(b));
766     }
767 
768     function add(
769         Wei memory a,
770         Wei memory b
771     )
772         internal
773         pure
774         returns (Wei memory)
775     {
776         Wei memory result;
777         if (a.sign == b.sign) {
778             result.sign = a.sign;
779             result.value = SafeMath.add(a.value, b.value);
780         } else {
781             if (a.value >= b.value) {
782                 result.sign = a.sign;
783                 result.value = SafeMath.sub(a.value, b.value);
784             } else {
785                 result.sign = b.sign;
786                 result.value = SafeMath.sub(b.value, a.value);
787             }
788         }
789         return result;
790     }
791 
792     function equals(
793         Wei memory a,
794         Wei memory b
795     )
796         internal
797         pure
798         returns (bool)
799     {
800         if (a.value == b.value) {
801             if (a.value == 0) {
802                 return true;
803             }
804             return a.sign == b.sign;
805         }
806         return false;
807     }
808 
809     function negative(
810         Wei memory a
811     )
812         internal
813         pure
814         returns (Wei memory)
815     {
816         return Wei({
817             sign: !a.sign,
818             value: a.value
819         });
820     }
821 
822     function isNegative(
823         Wei memory a
824     )
825         internal
826         pure
827         returns (bool)
828     {
829         return !a.sign && a.value > 0;
830     }
831 
832     function isPositive(
833         Wei memory a
834     )
835         internal
836         pure
837         returns (bool)
838     {
839         return a.sign && a.value > 0;
840     }
841 
842     function isZero(
843         Wei memory a
844     )
845         internal
846         pure
847         returns (bool)
848     {
849         return a.value == 0;
850     }
851 }
852 
853 // File: contracts/protocol/lib/Account.sol
854 
855 /**
856  * @title Account
857  * @author dYdX
858  *
859  * Library of structs and functions that represent an account
860  */
861 library Account {
862     // ============ Enums ============
863 
864     /*
865      * Most-recently-cached account status.
866      *
867      * Normal: Can only be liquidated if the account values are violating the global margin-ratio.
868      * Liquid: Can be liquidated no matter the account values.
869      *         Can be vaporized if there are no more positive account values.
870      * Vapor:  Has only negative (or zeroed) account values. Can be vaporized.
871      *
872      */
873     enum Status {
874         Normal,
875         Liquid,
876         Vapor
877     }
878 
879     // ============ Structs ============
880 
881     // Represents the unique key that specifies an account
882     struct Info {
883         address owner;  // The address that owns the account
884         uint256 number; // A nonce that allows a single address to control many accounts
885     }
886 
887     // The complete storage for any account
888     struct Storage {
889         mapping (uint256 => Types.Par) balances; // Mapping from marketId to principal
890         Status status;
891     }
892 
893     // ============ Library Functions ============
894 
895     function equals(
896         Info memory a,
897         Info memory b
898     )
899         internal
900         pure
901         returns (bool)
902     {
903         return a.owner == b.owner && a.number == b.number;
904     }
905 }
906 
907 // File: contracts/protocol/interfaces/IAutoTrader.sol
908 
909 /**
910  * @title IAutoTrader
911  * @author dYdX
912  *
913  * Interface that Auto-Traders for Solo must implement in order to approve trades.
914  */
915 contract IAutoTrader {
916 
917     // ============ Public Functions ============
918 
919     /**
920      * Allows traders to make trades approved by this smart contract. The active trader's account is
921      * the takerAccount and the passive account (for which this contract approves trades
922      * on-behalf-of) is the makerAccount.
923      *
924      * @param  inputMarketId   The market for which the trader specified the original amount
925      * @param  outputMarketId  The market for which the trader wants the resulting amount specified
926      * @param  makerAccount    The account for which this contract is making trades
927      * @param  takerAccount    The account requesting the trade
928      * @param  oldInputPar     The old principal amount for the makerAccount for the inputMarketId
929      * @param  newInputPar     The new principal amount for the makerAccount for the inputMarketId
930      * @param  inputWei        The change in token amount for the makerAccount for the inputMarketId
931      * @param  data            Arbitrary data passed in by the trader
932      * @return                 The AssetAmount for the makerAccount for the outputMarketId
933      */
934     function getTradeCost(
935         uint256 inputMarketId,
936         uint256 outputMarketId,
937         Account.Info memory makerAccount,
938         Account.Info memory takerAccount,
939         Types.Par memory oldInputPar,
940         Types.Par memory newInputPar,
941         Types.Wei memory inputWei,
942         bytes memory data
943     )
944         public
945         returns (Types.AssetAmount memory);
946 }
947 
948 // File: contracts/protocol/interfaces/ICallee.sol
949 
950 /**
951  * @title ICallee
952  * @author dYdX
953  *
954  * Interface that Callees for Solo must implement in order to ingest data.
955  */
956 contract ICallee {
957 
958     // ============ Public Functions ============
959 
960     /**
961      * Allows users to send this contract arbitrary data.
962      *
963      * @param  sender       The msg.sender to Solo
964      * @param  accountInfo  The account from which the data is being sent
965      * @param  data         Arbitrary data given by the sender
966      */
967     function callFunction(
968         address sender,
969         Account.Info memory accountInfo,
970         bytes memory data
971     )
972         public;
973 }
974 
975 // File: contracts/protocol/lib/Decimal.sol
976 
977 /**
978  * @title Decimal
979  * @author dYdX
980  *
981  * Library that defines a fixed-point number with 18 decimal places.
982  */
983 library Decimal {
984     using SafeMath for uint256;
985 
986     // ============ Constants ============
987 
988     uint256 constant BASE = 10**18;
989 
990     // ============ Structs ============
991 
992     struct D256 {
993         uint256 value;
994     }
995 
996     // ============ Functions ============
997 
998     function one()
999         internal
1000         pure
1001         returns (D256 memory)
1002     {
1003         return D256({ value: BASE });
1004     }
1005 
1006     function onePlus(
1007         D256 memory d
1008     )
1009         internal
1010         pure
1011         returns (D256 memory)
1012     {
1013         return D256({ value: d.value.add(BASE) });
1014     }
1015 
1016     function mul(
1017         uint256 target,
1018         D256 memory d
1019     )
1020         internal
1021         pure
1022         returns (uint256)
1023     {
1024         return Math.getPartial(target, d.value, BASE);
1025     }
1026 
1027     function div(
1028         uint256 target,
1029         D256 memory d
1030     )
1031         internal
1032         pure
1033         returns (uint256)
1034     {
1035         return Math.getPartial(target, BASE, d.value);
1036     }
1037 }
1038 
1039 // File: contracts/protocol/lib/Monetary.sol
1040 
1041 /**
1042  * @title Monetary
1043  * @author dYdX
1044  *
1045  * Library for types involving money
1046  */
1047 library Monetary {
1048 
1049     /*
1050      * The price of a base-unit of an asset.
1051      */
1052     struct Price {
1053         uint256 value;
1054     }
1055 
1056     /*
1057      * Total value of an some amount of an asset. Equal to (price * amount).
1058      */
1059     struct Value {
1060         uint256 value;
1061     }
1062 }
1063 
1064 // File: contracts/protocol/lib/Time.sol
1065 
1066 /**
1067  * @title Time
1068  * @author dYdX
1069  *
1070  * Library for dealing with time, assuming timestamps fit within 32 bits (valid until year 2106)
1071  */
1072 library Time {
1073 
1074     // ============ Library Functions ============
1075 
1076     function currentTime()
1077         internal
1078         view
1079         returns (uint32)
1080     {
1081         return Math.to32(block.timestamp);
1082     }
1083 }
1084 
1085 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
1086 
1087 /**
1088  * @title Helps contracts guard against reentrancy attacks.
1089  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
1090  * @dev If you mark a function `nonReentrant`, you should also
1091  * mark it `external`.
1092  */
1093 contract ReentrancyGuard {
1094     /// @dev counter to allow mutex lock with only one SSTORE operation
1095     uint256 private _guardCounter;
1096 
1097     constructor () internal {
1098         // The counter starts at one to prevent changing it from zero to a non-zero
1099         // value, which is a more expensive operation.
1100         _guardCounter = 1;
1101     }
1102 
1103     /**
1104      * @dev Prevents a contract from calling itself, directly or indirectly.
1105      * Calling a `nonReentrant` function from another `nonReentrant`
1106      * function is not supported. It is possible to prevent this from happening
1107      * by making the `nonReentrant` function external, and make it call a
1108      * `private` function that does the actual work.
1109      */
1110     modifier nonReentrant() {
1111         _guardCounter += 1;
1112         uint256 localCounter = _guardCounter;
1113         _;
1114         require(localCounter == _guardCounter);
1115     }
1116 }
1117 
1118 // File: contracts/protocol/lib/Cache.sol
1119 
1120 /**
1121  * @title Cache
1122  * @author dYdX
1123  *
1124  * Library for caching information about markets
1125  */
1126 library Cache {
1127     using Cache for MarketCache;
1128     using Storage for Storage.State;
1129 
1130     // ============ Structs ============
1131 
1132     struct MarketInfo {
1133         bool isClosing;
1134         uint128 borrowPar;
1135         Monetary.Price price;
1136     }
1137 
1138     struct MarketCache {
1139         MarketInfo[] markets;
1140     }
1141 
1142     // ============ Setter Functions ============
1143 
1144     /**
1145      * Initialize an empty cache for some given number of total markets.
1146      */
1147     function create(
1148         uint256 numMarkets
1149     )
1150         internal
1151         pure
1152         returns (MarketCache memory)
1153     {
1154         return MarketCache({
1155             markets: new MarketInfo[](numMarkets)
1156         });
1157     }
1158 
1159     /**
1160      * Add market information (price and total borrowed par if the market is closing) to the cache.
1161      * Return true if the market information did not previously exist in the cache.
1162      */
1163     function addMarket(
1164         MarketCache memory cache,
1165         Storage.State storage state,
1166         uint256 marketId
1167     )
1168         internal
1169         view
1170         returns (bool)
1171     {
1172         if (cache.hasMarket(marketId)) {
1173             return false;
1174         }
1175         cache.markets[marketId].price = state.fetchPrice(marketId);
1176         if (state.markets[marketId].isClosing) {
1177             cache.markets[marketId].isClosing = true;
1178             cache.markets[marketId].borrowPar = state.getTotalPar(marketId).borrow;
1179         }
1180         return true;
1181     }
1182 
1183     // ============ Getter Functions ============
1184 
1185     function getNumMarkets(
1186         MarketCache memory cache
1187     )
1188         internal
1189         pure
1190         returns (uint256)
1191     {
1192         return cache.markets.length;
1193     }
1194 
1195     function hasMarket(
1196         MarketCache memory cache,
1197         uint256 marketId
1198     )
1199         internal
1200         pure
1201         returns (bool)
1202     {
1203         return cache.markets[marketId].price.value != 0;
1204     }
1205 
1206     function getIsClosing(
1207         MarketCache memory cache,
1208         uint256 marketId
1209     )
1210         internal
1211         pure
1212         returns (bool)
1213     {
1214         return cache.markets[marketId].isClosing;
1215     }
1216 
1217     function getPrice(
1218         MarketCache memory cache,
1219         uint256 marketId
1220     )
1221         internal
1222         pure
1223         returns (Monetary.Price memory)
1224     {
1225         return cache.markets[marketId].price;
1226     }
1227 
1228     function getBorrowPar(
1229         MarketCache memory cache,
1230         uint256 marketId
1231     )
1232         internal
1233         pure
1234         returns (uint128)
1235     {
1236         return cache.markets[marketId].borrowPar;
1237     }
1238 }
1239 
1240 // File: contracts/protocol/lib/Interest.sol
1241 
1242 /**
1243  * @title Interest
1244  * @author dYdX
1245  *
1246  * Library for managing the interest rate and interest indexes of Solo
1247  */
1248 library Interest {
1249     using Math for uint256;
1250     using SafeMath for uint256;
1251 
1252     // ============ Constants ============
1253 
1254     bytes32 constant FILE = "Interest";
1255     uint64 constant BASE = 10**18;
1256 
1257     // ============ Structs ============
1258 
1259     struct Rate {
1260         uint256 value;
1261     }
1262 
1263     struct Index {
1264         uint96 borrow;
1265         uint96 supply;
1266         uint32 lastUpdate;
1267     }
1268 
1269     // ============ Library Functions ============
1270 
1271     /**
1272      * Get a new market Index based on the old index and market interest rate.
1273      * Calculate interest for borrowers by using the formula rate * time. Approximates
1274      * continuously-compounded interest when called frequently, but is much more
1275      * gas-efficient to calculate. For suppliers, the interest rate is adjusted by the earningsRate,
1276      * then prorated the across all suppliers.
1277      *
1278      * @param  index         The old index for a market
1279      * @param  rate          The current interest rate of the market
1280      * @param  totalPar      The total supply and borrow par values of the market
1281      * @param  earningsRate  The portion of the interest that is forwarded to the suppliers
1282      * @return               The updated index for a market
1283      */
1284     function calculateNewIndex(
1285         Index memory index,
1286         Rate memory rate,
1287         Types.TotalPar memory totalPar,
1288         Decimal.D256 memory earningsRate
1289     )
1290         internal
1291         view
1292         returns (Index memory)
1293     {
1294         (
1295             Types.Wei memory supplyWei,
1296             Types.Wei memory borrowWei
1297         ) = totalParToWei(totalPar, index);
1298 
1299         // get interest increase for borrowers
1300         uint32 currentTime = Time.currentTime();
1301         uint256 borrowInterest = rate.value.mul(uint256(currentTime).sub(index.lastUpdate));
1302 
1303         // get interest increase for suppliers
1304         uint256 supplyInterest;
1305         if (Types.isZero(supplyWei)) {
1306             supplyInterest = 0;
1307         } else {
1308             supplyInterest = Decimal.mul(borrowInterest, earningsRate);
1309             if (borrowWei.value < supplyWei.value) {
1310                 supplyInterest = Math.getPartial(supplyInterest, borrowWei.value, supplyWei.value);
1311             }
1312         }
1313         assert(supplyInterest <= borrowInterest);
1314 
1315         return Index({
1316             borrow: Math.getPartial(index.borrow, borrowInterest, BASE).add(index.borrow).to96(),
1317             supply: Math.getPartial(index.supply, supplyInterest, BASE).add(index.supply).to96(),
1318             lastUpdate: currentTime
1319         });
1320     }
1321 
1322     function newIndex()
1323         internal
1324         view
1325         returns (Index memory)
1326     {
1327         return Index({
1328             borrow: BASE,
1329             supply: BASE,
1330             lastUpdate: Time.currentTime()
1331         });
1332     }
1333 
1334     /*
1335      * Convert a principal amount to a token amount given an index.
1336      */
1337     function parToWei(
1338         Types.Par memory input,
1339         Index memory index
1340     )
1341         internal
1342         pure
1343         returns (Types.Wei memory)
1344     {
1345         uint256 inputValue = uint256(input.value);
1346         if (input.sign) {
1347             return Types.Wei({
1348                 sign: true,
1349                 value: inputValue.getPartial(index.supply, BASE)
1350             });
1351         } else {
1352             return Types.Wei({
1353                 sign: false,
1354                 value: inputValue.getPartialRoundUp(index.borrow, BASE)
1355             });
1356         }
1357     }
1358 
1359     /*
1360      * Convert a token amount to a principal amount given an index.
1361      */
1362     function weiToPar(
1363         Types.Wei memory input,
1364         Index memory index
1365     )
1366         internal
1367         pure
1368         returns (Types.Par memory)
1369     {
1370         if (input.sign) {
1371             return Types.Par({
1372                 sign: true,
1373                 value: input.value.getPartial(BASE, index.supply).to128()
1374             });
1375         } else {
1376             return Types.Par({
1377                 sign: false,
1378                 value: input.value.getPartialRoundUp(BASE, index.borrow).to128()
1379             });
1380         }
1381     }
1382 
1383     /*
1384      * Convert the total supply and borrow principal amounts of a market to total supply and borrow
1385      * token amounts.
1386      */
1387     function totalParToWei(
1388         Types.TotalPar memory totalPar,
1389         Index memory index
1390     )
1391         internal
1392         pure
1393         returns (Types.Wei memory, Types.Wei memory)
1394     {
1395         Types.Par memory supplyPar = Types.Par({
1396             sign: true,
1397             value: totalPar.supply
1398         });
1399         Types.Par memory borrowPar = Types.Par({
1400             sign: false,
1401             value: totalPar.borrow
1402         });
1403         Types.Wei memory supplyWei = parToWei(supplyPar, index);
1404         Types.Wei memory borrowWei = parToWei(borrowPar, index);
1405         return (supplyWei, borrowWei);
1406     }
1407 }
1408 
1409 // File: contracts/protocol/interfaces/IErc20.sol
1410 
1411 /**
1412  * @title IErc20
1413  * @author dYdX
1414  *
1415  * Interface for using ERC20 Tokens. We have to use a special interface to call ERC20 functions so
1416  * that we don't automatically revert when calling non-compliant tokens that have no return value for
1417  * transfer(), transferFrom(), or approve().
1418  */
1419 interface IErc20 {
1420     event Transfer(
1421         address indexed from,
1422         address indexed to,
1423         uint256 value
1424     );
1425 
1426     event Approval(
1427         address indexed owner,
1428         address indexed spender,
1429         uint256 value
1430     );
1431 
1432     function totalSupply(
1433     )
1434         external
1435         view
1436         returns (uint256);
1437 
1438     function balanceOf(
1439         address who
1440     )
1441         external
1442         view
1443         returns (uint256);
1444 
1445     function allowance(
1446         address owner,
1447         address spender
1448     )
1449         external
1450         view
1451         returns (uint256);
1452 
1453     function transfer(
1454         address to,
1455         uint256 value
1456     )
1457         external;
1458 
1459     function transferFrom(
1460         address from,
1461         address to,
1462         uint256 value
1463     )
1464         external;
1465 
1466     function approve(
1467         address spender,
1468         uint256 value
1469     )
1470         external;
1471 
1472     function name()
1473         external
1474         view
1475         returns (string memory);
1476 
1477     function symbol()
1478         external
1479         view
1480         returns (string memory);
1481 
1482     function decimals()
1483         external
1484         view
1485         returns (uint8);
1486 }
1487 
1488 // File: contracts/protocol/lib/Token.sol
1489 
1490 /**
1491  * @title Token
1492  * @author dYdX
1493  *
1494  * This library contains basic functions for interacting with ERC20 tokens. Modified to work with
1495  * tokens that don't adhere strictly to the ERC20 standard (for example tokens that don't return a
1496  * boolean value on success).
1497  */
1498 library Token {
1499 
1500     // ============ Constants ============
1501 
1502     bytes32 constant FILE = "Token";
1503 
1504     // ============ Library Functions ============
1505 
1506     function balanceOf(
1507         address token,
1508         address owner
1509     )
1510         internal
1511         view
1512         returns (uint256)
1513     {
1514         return IErc20(token).balanceOf(owner);
1515     }
1516 
1517     function allowance(
1518         address token,
1519         address owner,
1520         address spender
1521     )
1522         internal
1523         view
1524         returns (uint256)
1525     {
1526         return IErc20(token).allowance(owner, spender);
1527     }
1528 
1529     function approve(
1530         address token,
1531         address spender,
1532         uint256 amount
1533     )
1534         internal
1535     {
1536         IErc20(token).approve(spender, amount);
1537 
1538         Require.that(
1539             checkSuccess(),
1540             FILE,
1541             "Approve failed"
1542         );
1543     }
1544 
1545     function approveMax(
1546         address token,
1547         address spender
1548     )
1549         internal
1550     {
1551         approve(
1552             token,
1553             spender,
1554             uint256(-1)
1555         );
1556     }
1557 
1558     function transfer(
1559         address token,
1560         address to,
1561         uint256 amount
1562     )
1563         internal
1564     {
1565         if (amount == 0 || to == address(this)) {
1566             return;
1567         }
1568 
1569         IErc20(token).transfer(to, amount);
1570 
1571         Require.that(
1572             checkSuccess(),
1573             FILE,
1574             "Transfer failed"
1575         );
1576     }
1577 
1578     function transferFrom(
1579         address token,
1580         address from,
1581         address to,
1582         uint256 amount
1583     )
1584         internal
1585     {
1586         if (amount == 0 || to == from) {
1587             return;
1588         }
1589 
1590         IErc20(token).transferFrom(from, to, amount);
1591 
1592         Require.that(
1593             checkSuccess(),
1594             FILE,
1595             "TransferFrom failed"
1596         );
1597     }
1598 
1599     // ============ Private Functions ============
1600 
1601     /**
1602      * Check the return value of the previous function up to 32 bytes. Return true if the previous
1603      * function returned 0 bytes or 32 bytes that are not all-zero.
1604      */
1605     function checkSuccess(
1606     )
1607         private
1608         pure
1609         returns (bool)
1610     {
1611         uint256 returnValue = 0;
1612 
1613         /* solium-disable-next-line security/no-inline-assembly */
1614         assembly {
1615             // check number of bytes returned from last function call
1616             switch returndatasize
1617 
1618             // no bytes returned: assume success
1619             case 0x0 {
1620                 returnValue := 1
1621             }
1622 
1623             // 32 bytes returned: check if non-zero
1624             case 0x20 {
1625                 // copy 32 bytes into scratch space
1626                 returndatacopy(0x0, 0x0, 0x20)
1627 
1628                 // load those bytes into returnValue
1629                 returnValue := mload(0x0)
1630             }
1631 
1632             // not sure what was returned: don't mark as success
1633             default { }
1634         }
1635 
1636         return returnValue != 0;
1637     }
1638 }
1639 
1640 // File: contracts/protocol/interfaces/IInterestSetter.sol
1641 
1642 /**
1643  * @title IInterestSetter
1644  * @author dYdX
1645  *
1646  * Interface that Interest Setters for Solo must implement in order to report interest rates.
1647  */
1648 interface IInterestSetter {
1649 
1650     // ============ Public Functions ============
1651 
1652     /**
1653      * Get the interest rate of a token given some borrowed and supplied amounts
1654      *
1655      * @param  token        The address of the ERC20 token for the market
1656      * @param  borrowWei    The total borrowed token amount for the market
1657      * @param  supplyWei    The total supplied token amount for the market
1658      * @return              The interest rate per second
1659      */
1660     function getInterestRate(
1661         address token,
1662         uint256 borrowWei,
1663         uint256 supplyWei
1664     )
1665         external
1666         view
1667         returns (Interest.Rate memory);
1668 }
1669 
1670 // File: contracts/protocol/interfaces/IPriceOracle.sol
1671 
1672 /**
1673  * @title IPriceOracle
1674  * @author dYdX
1675  *
1676  * Interface that Price Oracles for Solo must implement in order to report prices.
1677  */
1678 contract IPriceOracle {
1679 
1680     // ============ Constants ============
1681 
1682     uint256 public constant ONE_DOLLAR = 10 ** 36;
1683 
1684     // ============ Public Functions ============
1685 
1686     /**
1687      * Get the price of a token
1688      *
1689      * @param  token  The ERC20 token address of the market
1690      * @return        The USD price of a base unit of the token, then multiplied by 10^36.
1691      *                So a USD-stable coin with 18 decimal places would return 10^18.
1692      *                This is the price of the base unit rather than the price of a "human-readable"
1693      *                token amount. Every ERC20 may have a different number of decimals.
1694      */
1695     function getPrice(
1696         address token
1697     )
1698         public
1699         view
1700         returns (Monetary.Price memory);
1701 }
1702 
1703 // File: contracts/protocol/lib/Storage.sol
1704 
1705 /**
1706  * @title Storage
1707  * @author dYdX
1708  *
1709  * Functions for reading, writing, and verifying state in Solo
1710  */
1711 library Storage {
1712     using Cache for Cache.MarketCache;
1713     using Storage for Storage.State;
1714     using Math for uint256;
1715     using Types for Types.Par;
1716     using Types for Types.Wei;
1717     using SafeMath for uint256;
1718 
1719     // ============ Constants ============
1720 
1721     bytes32 constant FILE = "Storage";
1722 
1723     // ============ Structs ============
1724 
1725     // All information necessary for tracking a market
1726     struct Market {
1727         // Contract address of the associated ERC20 token
1728         address token;
1729 
1730         // Total aggregated supply and borrow amount of the entire market
1731         Types.TotalPar totalPar;
1732 
1733         // Interest index of the market
1734         Interest.Index index;
1735 
1736         // Contract address of the price oracle for this market
1737         IPriceOracle priceOracle;
1738 
1739         // Contract address of the interest setter for this market
1740         IInterestSetter interestSetter;
1741 
1742         // Multiplier on the marginRatio for this market
1743         Decimal.D256 marginPremium;
1744 
1745         // Multiplier on the liquidationSpread for this market
1746         Decimal.D256 spreadPremium;
1747 
1748         // Whether additional borrows are allowed for this market
1749         bool isClosing;
1750     }
1751 
1752     // The global risk parameters that govern the health and security of the system
1753     struct RiskParams {
1754         // Required ratio of over-collateralization
1755         Decimal.D256 marginRatio;
1756 
1757         // Percentage penalty incurred by liquidated accounts
1758         Decimal.D256 liquidationSpread;
1759 
1760         // Percentage of the borrower's interest fee that gets passed to the suppliers
1761         Decimal.D256 earningsRate;
1762 
1763         // The minimum absolute borrow value of an account
1764         // There must be sufficient incentivize to liquidate undercollateralized accounts
1765         Monetary.Value minBorrowedValue;
1766     }
1767 
1768     // The maximum RiskParam values that can be set
1769     struct RiskLimits {
1770         uint64 marginRatioMax;
1771         uint64 liquidationSpreadMax;
1772         uint64 earningsRateMax;
1773         uint64 marginPremiumMax;
1774         uint64 spreadPremiumMax;
1775         uint128 minBorrowedValueMax;
1776     }
1777 
1778     // The entire storage state of Solo
1779     struct State {
1780         // number of markets
1781         uint256 numMarkets;
1782 
1783         // marketId => Market
1784         mapping (uint256 => Market) markets;
1785 
1786         // owner => account number => Account
1787         mapping (address => mapping (uint256 => Account.Storage)) accounts;
1788 
1789         // Addresses that can control other users accounts
1790         mapping (address => mapping (address => bool)) operators;
1791 
1792         // Addresses that can control all users accounts
1793         mapping (address => bool) globalOperators;
1794 
1795         // mutable risk parameters of the system
1796         RiskParams riskParams;
1797 
1798         // immutable risk limits of the system
1799         RiskLimits riskLimits;
1800     }
1801 
1802     // ============ Functions ============
1803 
1804     function getToken(
1805         Storage.State storage state,
1806         uint256 marketId
1807     )
1808         internal
1809         view
1810         returns (address)
1811     {
1812         return state.markets[marketId].token;
1813     }
1814 
1815     function getTotalPar(
1816         Storage.State storage state,
1817         uint256 marketId
1818     )
1819         internal
1820         view
1821         returns (Types.TotalPar memory)
1822     {
1823         return state.markets[marketId].totalPar;
1824     }
1825 
1826     function getIndex(
1827         Storage.State storage state,
1828         uint256 marketId
1829     )
1830         internal
1831         view
1832         returns (Interest.Index memory)
1833     {
1834         return state.markets[marketId].index;
1835     }
1836 
1837     function getNumExcessTokens(
1838         Storage.State storage state,
1839         uint256 marketId
1840     )
1841         internal
1842         view
1843         returns (Types.Wei memory)
1844     {
1845         Interest.Index memory index = state.getIndex(marketId);
1846         Types.TotalPar memory totalPar = state.getTotalPar(marketId);
1847 
1848         address token = state.getToken(marketId);
1849 
1850         Types.Wei memory balanceWei = Types.Wei({
1851             sign: true,
1852             value: Token.balanceOf(token, address(this))
1853         });
1854 
1855         (
1856             Types.Wei memory supplyWei,
1857             Types.Wei memory borrowWei
1858         ) = Interest.totalParToWei(totalPar, index);
1859 
1860         // borrowWei is negative, so subtracting it makes the value more positive
1861         return balanceWei.sub(borrowWei).sub(supplyWei);
1862     }
1863 
1864     function getStatus(
1865         Storage.State storage state,
1866         Account.Info memory account
1867     )
1868         internal
1869         view
1870         returns (Account.Status)
1871     {
1872         return state.accounts[account.owner][account.number].status;
1873     }
1874 
1875     function getPar(
1876         Storage.State storage state,
1877         Account.Info memory account,
1878         uint256 marketId
1879     )
1880         internal
1881         view
1882         returns (Types.Par memory)
1883     {
1884         return state.accounts[account.owner][account.number].balances[marketId];
1885     }
1886 
1887     function getWei(
1888         Storage.State storage state,
1889         Account.Info memory account,
1890         uint256 marketId
1891     )
1892         internal
1893         view
1894         returns (Types.Wei memory)
1895     {
1896         Types.Par memory par = state.getPar(account, marketId);
1897 
1898         if (par.isZero()) {
1899             return Types.zeroWei();
1900         }
1901 
1902         Interest.Index memory index = state.getIndex(marketId);
1903         return Interest.parToWei(par, index);
1904     }
1905 
1906     function getLiquidationSpreadForPair(
1907         Storage.State storage state,
1908         uint256 heldMarketId,
1909         uint256 owedMarketId
1910     )
1911         internal
1912         view
1913         returns (Decimal.D256 memory)
1914     {
1915         uint256 result = state.riskParams.liquidationSpread.value;
1916         result = Decimal.mul(result, Decimal.onePlus(state.markets[heldMarketId].spreadPremium));
1917         result = Decimal.mul(result, Decimal.onePlus(state.markets[owedMarketId].spreadPremium));
1918         return Decimal.D256({
1919             value: result
1920         });
1921     }
1922 
1923     function fetchNewIndex(
1924         Storage.State storage state,
1925         uint256 marketId,
1926         Interest.Index memory index
1927     )
1928         internal
1929         view
1930         returns (Interest.Index memory)
1931     {
1932         Interest.Rate memory rate = state.fetchInterestRate(marketId, index);
1933 
1934         return Interest.calculateNewIndex(
1935             index,
1936             rate,
1937             state.getTotalPar(marketId),
1938             state.riskParams.earningsRate
1939         );
1940     }
1941 
1942     function fetchInterestRate(
1943         Storage.State storage state,
1944         uint256 marketId,
1945         Interest.Index memory index
1946     )
1947         internal
1948         view
1949         returns (Interest.Rate memory)
1950     {
1951         Types.TotalPar memory totalPar = state.getTotalPar(marketId);
1952         (
1953             Types.Wei memory supplyWei,
1954             Types.Wei memory borrowWei
1955         ) = Interest.totalParToWei(totalPar, index);
1956 
1957         Interest.Rate memory rate = state.markets[marketId].interestSetter.getInterestRate(
1958             state.getToken(marketId),
1959             borrowWei.value,
1960             supplyWei.value
1961         );
1962 
1963         return rate;
1964     }
1965 
1966     function fetchPrice(
1967         Storage.State storage state,
1968         uint256 marketId
1969     )
1970         internal
1971         view
1972         returns (Monetary.Price memory)
1973     {
1974         IPriceOracle oracle = IPriceOracle(state.markets[marketId].priceOracle);
1975         Monetary.Price memory price = oracle.getPrice(state.getToken(marketId));
1976         Require.that(
1977             price.value != 0,
1978             FILE,
1979             "Price cannot be zero",
1980             marketId
1981         );
1982         return price;
1983     }
1984 
1985     function getAccountValues(
1986         Storage.State storage state,
1987         Account.Info memory account,
1988         Cache.MarketCache memory cache,
1989         bool adjustForLiquidity
1990     )
1991         internal
1992         view
1993         returns (Monetary.Value memory, Monetary.Value memory)
1994     {
1995         Monetary.Value memory supplyValue;
1996         Monetary.Value memory borrowValue;
1997 
1998         uint256 numMarkets = cache.getNumMarkets();
1999         for (uint256 m = 0; m < numMarkets; m++) {
2000             if (!cache.hasMarket(m)) {
2001                 continue;
2002             }
2003 
2004             Types.Wei memory userWei = state.getWei(account, m);
2005 
2006             if (userWei.isZero()) {
2007                 continue;
2008             }
2009 
2010             uint256 assetValue = userWei.value.mul(cache.getPrice(m).value);
2011             Decimal.D256 memory adjust = Decimal.one();
2012             if (adjustForLiquidity) {
2013                 adjust = Decimal.onePlus(state.markets[m].marginPremium);
2014             }
2015 
2016             if (userWei.sign) {
2017                 supplyValue.value = supplyValue.value.add(Decimal.div(assetValue, adjust));
2018             } else {
2019                 borrowValue.value = borrowValue.value.add(Decimal.mul(assetValue, adjust));
2020             }
2021         }
2022 
2023         return (supplyValue, borrowValue);
2024     }
2025 
2026     function isCollateralized(
2027         Storage.State storage state,
2028         Account.Info memory account,
2029         Cache.MarketCache memory cache,
2030         bool requireMinBorrow
2031     )
2032         internal
2033         view
2034         returns (bool)
2035     {
2036         // get account values (adjusted for liquidity)
2037         (
2038             Monetary.Value memory supplyValue,
2039             Monetary.Value memory borrowValue
2040         ) = state.getAccountValues(account, cache, /* adjustForLiquidity = */ true);
2041 
2042         if (borrowValue.value == 0) {
2043             return true;
2044         }
2045 
2046         if (requireMinBorrow) {
2047             Require.that(
2048                 borrowValue.value >= state.riskParams.minBorrowedValue.value,
2049                 FILE,
2050                 "Borrow value too low",
2051                 account.owner,
2052                 account.number,
2053                 borrowValue.value
2054             );
2055         }
2056 
2057         uint256 requiredMargin = Decimal.mul(borrowValue.value, state.riskParams.marginRatio);
2058 
2059         return supplyValue.value >= borrowValue.value.add(requiredMargin);
2060     }
2061 
2062     function isGlobalOperator(
2063         Storage.State storage state,
2064         address operator
2065     )
2066         internal
2067         view
2068         returns (bool)
2069     {
2070         return state.globalOperators[operator];
2071     }
2072 
2073     function isLocalOperator(
2074         Storage.State storage state,
2075         address owner,
2076         address operator
2077     )
2078         internal
2079         view
2080         returns (bool)
2081     {
2082         return state.operators[owner][operator];
2083     }
2084 
2085     function requireIsOperator(
2086         Storage.State storage state,
2087         Account.Info memory account,
2088         address operator
2089     )
2090         internal
2091         view
2092     {
2093         bool isValidOperator =
2094             operator == account.owner
2095             || state.isGlobalOperator(operator)
2096             || state.isLocalOperator(account.owner, operator);
2097 
2098         Require.that(
2099             isValidOperator,
2100             FILE,
2101             "Unpermissioned operator",
2102             operator
2103         );
2104     }
2105 
2106     /**
2107      * Determine and set an account's balance based on the intended balance change. Return the
2108      * equivalent amount in wei
2109      */
2110     function getNewParAndDeltaWei(
2111         Storage.State storage state,
2112         Account.Info memory account,
2113         uint256 marketId,
2114         Types.AssetAmount memory amount
2115     )
2116         internal
2117         view
2118         returns (Types.Par memory, Types.Wei memory)
2119     {
2120         Types.Par memory oldPar = state.getPar(account, marketId);
2121 
2122         if (amount.value == 0 && amount.ref == Types.AssetReference.Delta) {
2123             return (oldPar, Types.zeroWei());
2124         }
2125 
2126         Interest.Index memory index = state.getIndex(marketId);
2127         Types.Wei memory oldWei = Interest.parToWei(oldPar, index);
2128         Types.Par memory newPar;
2129         Types.Wei memory deltaWei;
2130 
2131         if (amount.denomination == Types.AssetDenomination.Wei) {
2132             deltaWei = Types.Wei({
2133                 sign: amount.sign,
2134                 value: amount.value
2135             });
2136             if (amount.ref == Types.AssetReference.Target) {
2137                 deltaWei = deltaWei.sub(oldWei);
2138             }
2139             newPar = Interest.weiToPar(oldWei.add(deltaWei), index);
2140         } else { // AssetDenomination.Par
2141             newPar = Types.Par({
2142                 sign: amount.sign,
2143                 value: amount.value.to128()
2144             });
2145             if (amount.ref == Types.AssetReference.Delta) {
2146                 newPar = oldPar.add(newPar);
2147             }
2148             deltaWei = Interest.parToWei(newPar, index).sub(oldWei);
2149         }
2150 
2151         return (newPar, deltaWei);
2152     }
2153 
2154     function getNewParAndDeltaWeiForLiquidation(
2155         Storage.State storage state,
2156         Account.Info memory account,
2157         uint256 marketId,
2158         Types.AssetAmount memory amount
2159     )
2160         internal
2161         view
2162         returns (Types.Par memory, Types.Wei memory)
2163     {
2164         Types.Par memory oldPar = state.getPar(account, marketId);
2165 
2166         Require.that(
2167             !oldPar.isPositive(),
2168             FILE,
2169             "Owed balance cannot be positive",
2170             account.owner,
2171             account.number,
2172             marketId
2173         );
2174 
2175         (
2176             Types.Par memory newPar,
2177             Types.Wei memory deltaWei
2178         ) = state.getNewParAndDeltaWei(
2179             account,
2180             marketId,
2181             amount
2182         );
2183 
2184         // if attempting to over-repay the owed asset, bound it by the maximum
2185         if (newPar.isPositive()) {
2186             newPar = Types.zeroPar();
2187             deltaWei = state.getWei(account, marketId).negative();
2188         }
2189 
2190         Require.that(
2191             !deltaWei.isNegative() && oldPar.value >= newPar.value,
2192             FILE,
2193             "Owed balance cannot increase",
2194             account.owner,
2195             account.number,
2196             marketId
2197         );
2198 
2199         // if not paying back enough wei to repay any par, then bound wei to zero
2200         if (oldPar.equals(newPar)) {
2201             deltaWei = Types.zeroWei();
2202         }
2203 
2204         return (newPar, deltaWei);
2205     }
2206 
2207     function isVaporizable(
2208         Storage.State storage state,
2209         Account.Info memory account,
2210         Cache.MarketCache memory cache
2211     )
2212         internal
2213         view
2214         returns (bool)
2215     {
2216         bool hasNegative = false;
2217         uint256 numMarkets = cache.getNumMarkets();
2218         for (uint256 m = 0; m < numMarkets; m++) {
2219             if (!cache.hasMarket(m)) {
2220                 continue;
2221             }
2222             Types.Par memory par = state.getPar(account, m);
2223             if (par.isZero()) {
2224                 continue;
2225             } else if (par.sign) {
2226                 return false;
2227             } else {
2228                 hasNegative = true;
2229             }
2230         }
2231         return hasNegative;
2232     }
2233 
2234     // =============== Setter Functions ===============
2235 
2236     function updateIndex(
2237         Storage.State storage state,
2238         uint256 marketId
2239     )
2240         internal
2241         returns (Interest.Index memory)
2242     {
2243         Interest.Index memory index = state.getIndex(marketId);
2244         if (index.lastUpdate == Time.currentTime()) {
2245             return index;
2246         }
2247         return state.markets[marketId].index = state.fetchNewIndex(marketId, index);
2248     }
2249 
2250     function setStatus(
2251         Storage.State storage state,
2252         Account.Info memory account,
2253         Account.Status status
2254     )
2255         internal
2256     {
2257         state.accounts[account.owner][account.number].status = status;
2258     }
2259 
2260     function setPar(
2261         Storage.State storage state,
2262         Account.Info memory account,
2263         uint256 marketId,
2264         Types.Par memory newPar
2265     )
2266         internal
2267     {
2268         Types.Par memory oldPar = state.getPar(account, marketId);
2269 
2270         if (Types.equals(oldPar, newPar)) {
2271             return;
2272         }
2273 
2274         // updateTotalPar
2275         Types.TotalPar memory totalPar = state.getTotalPar(marketId);
2276 
2277         // roll-back oldPar
2278         if (oldPar.sign) {
2279             totalPar.supply = uint256(totalPar.supply).sub(oldPar.value).to128();
2280         } else {
2281             totalPar.borrow = uint256(totalPar.borrow).sub(oldPar.value).to128();
2282         }
2283 
2284         // roll-forward newPar
2285         if (newPar.sign) {
2286             totalPar.supply = uint256(totalPar.supply).add(newPar.value).to128();
2287         } else {
2288             totalPar.borrow = uint256(totalPar.borrow).add(newPar.value).to128();
2289         }
2290 
2291         state.markets[marketId].totalPar = totalPar;
2292         state.accounts[account.owner][account.number].balances[marketId] = newPar;
2293     }
2294 
2295     /**
2296      * Determine and set an account's balance based on a change in wei
2297      */
2298     function setParFromDeltaWei(
2299         Storage.State storage state,
2300         Account.Info memory account,
2301         uint256 marketId,
2302         Types.Wei memory deltaWei
2303     )
2304         internal
2305     {
2306         if (deltaWei.isZero()) {
2307             return;
2308         }
2309         Interest.Index memory index = state.getIndex(marketId);
2310         Types.Wei memory oldWei = state.getWei(account, marketId);
2311         Types.Wei memory newWei = oldWei.add(deltaWei);
2312         Types.Par memory newPar = Interest.weiToPar(newWei, index);
2313         state.setPar(
2314             account,
2315             marketId,
2316             newPar
2317         );
2318     }
2319 }
2320 
2321 // File: contracts/protocol/State.sol
2322 
2323 /**
2324  * @title State
2325  * @author dYdX
2326  *
2327  * Base-level contract that holds the state of Solo
2328  */
2329 contract State
2330 {
2331     Storage.State g_state;
2332 }
2333 
2334 // File: contracts/protocol/impl/AdminImpl.sol
2335 
2336 /**
2337  * @title AdminImpl
2338  * @author dYdX
2339  *
2340  * Administrative functions to keep the protocol updated
2341  */
2342 library AdminImpl {
2343     using Storage for Storage.State;
2344     using Token for address;
2345     using Types for Types.Wei;
2346 
2347     // ============ Constants ============
2348 
2349     bytes32 constant FILE = "AdminImpl";
2350 
2351     // ============ Events ============
2352 
2353     event LogWithdrawExcessTokens(
2354         address token,
2355         uint256 amount
2356     );
2357 
2358     event LogAddMarket(
2359         uint256 marketId,
2360         address token
2361     );
2362 
2363     event LogSetIsClosing(
2364         uint256 marketId,
2365         bool isClosing
2366     );
2367 
2368     event LogSetPriceOracle(
2369         uint256 marketId,
2370         address priceOracle
2371     );
2372 
2373     event LogSetInterestSetter(
2374         uint256 marketId,
2375         address interestSetter
2376     );
2377 
2378     event LogSetMarginPremium(
2379         uint256 marketId,
2380         Decimal.D256 marginPremium
2381     );
2382 
2383     event LogSetSpreadPremium(
2384         uint256 marketId,
2385         Decimal.D256 spreadPremium
2386     );
2387 
2388     event LogSetMarginRatio(
2389         Decimal.D256 marginRatio
2390     );
2391 
2392     event LogSetLiquidationSpread(
2393         Decimal.D256 liquidationSpread
2394     );
2395 
2396     event LogSetEarningsRate(
2397         Decimal.D256 earningsRate
2398     );
2399 
2400     event LogSetMinBorrowedValue(
2401         Monetary.Value minBorrowedValue
2402     );
2403 
2404     event LogSetGlobalOperator(
2405         address operator,
2406         bool approved
2407     );
2408 
2409     // ============ Token Functions ============
2410 
2411     function ownerWithdrawExcessTokens(
2412         Storage.State storage state,
2413         uint256 marketId,
2414         address recipient
2415     )
2416         public
2417         returns (uint256)
2418     {
2419         _validateMarketId(state, marketId);
2420         Types.Wei memory excessWei = state.getNumExcessTokens(marketId);
2421 
2422         Require.that(
2423             !excessWei.isNegative(),
2424             FILE,
2425             "Negative excess"
2426         );
2427 
2428         address token = state.getToken(marketId);
2429 
2430         uint256 actualBalance = token.balanceOf(address(this));
2431         if (excessWei.value > actualBalance) {
2432             excessWei.value = actualBalance;
2433         }
2434 
2435         token.transfer(recipient, excessWei.value);
2436 
2437         emit LogWithdrawExcessTokens(token, excessWei.value);
2438 
2439         return excessWei.value;
2440     }
2441 
2442     function ownerWithdrawUnsupportedTokens(
2443         Storage.State storage state,
2444         address token,
2445         address recipient
2446     )
2447         public
2448         returns (uint256)
2449     {
2450         _requireNoMarket(state, token);
2451 
2452         uint256 balance = token.balanceOf(address(this));
2453         token.transfer(recipient, balance);
2454 
2455         emit LogWithdrawExcessTokens(token, balance);
2456 
2457         return balance;
2458     }
2459 
2460     // ============ Market Functions ============
2461 
2462     function ownerAddMarket(
2463         Storage.State storage state,
2464         address token,
2465         IPriceOracle priceOracle,
2466         IInterestSetter interestSetter,
2467         Decimal.D256 memory marginPremium,
2468         Decimal.D256 memory spreadPremium
2469     )
2470         public
2471     {
2472         _requireNoMarket(state, token);
2473 
2474         uint256 marketId = state.numMarkets;
2475 
2476         state.numMarkets++;
2477         state.markets[marketId].token = token;
2478         state.markets[marketId].index = Interest.newIndex();
2479 
2480         emit LogAddMarket(marketId, token);
2481 
2482         _setPriceOracle(state, marketId, priceOracle);
2483         _setInterestSetter(state, marketId, interestSetter);
2484         _setMarginPremium(state, marketId, marginPremium);
2485         _setSpreadPremium(state, marketId, spreadPremium);
2486     }
2487 
2488     function ownerSetIsClosing(
2489         Storage.State storage state,
2490         uint256 marketId,
2491         bool isClosing
2492     )
2493         public
2494     {
2495         _validateMarketId(state, marketId);
2496         state.markets[marketId].isClosing = isClosing;
2497         emit LogSetIsClosing(marketId, isClosing);
2498     }
2499 
2500     function ownerSetPriceOracle(
2501         Storage.State storage state,
2502         uint256 marketId,
2503         IPriceOracle priceOracle
2504     )
2505         public
2506     {
2507         _validateMarketId(state, marketId);
2508         _setPriceOracle(state, marketId, priceOracle);
2509     }
2510 
2511     function ownerSetInterestSetter(
2512         Storage.State storage state,
2513         uint256 marketId,
2514         IInterestSetter interestSetter
2515     )
2516         public
2517     {
2518         _validateMarketId(state, marketId);
2519         _setInterestSetter(state, marketId, interestSetter);
2520     }
2521 
2522     function ownerSetMarginPremium(
2523         Storage.State storage state,
2524         uint256 marketId,
2525         Decimal.D256 memory marginPremium
2526     )
2527         public
2528     {
2529         _validateMarketId(state, marketId);
2530         _setMarginPremium(state, marketId, marginPremium);
2531     }
2532 
2533     function ownerSetSpreadPremium(
2534         Storage.State storage state,
2535         uint256 marketId,
2536         Decimal.D256 memory spreadPremium
2537     )
2538         public
2539     {
2540         _validateMarketId(state, marketId);
2541         _setSpreadPremium(state, marketId, spreadPremium);
2542     }
2543 
2544     // ============ Risk Functions ============
2545 
2546     function ownerSetMarginRatio(
2547         Storage.State storage state,
2548         Decimal.D256 memory ratio
2549     )
2550         public
2551     {
2552         Require.that(
2553             ratio.value <= state.riskLimits.marginRatioMax,
2554             FILE,
2555             "Ratio too high"
2556         );
2557         Require.that(
2558             ratio.value > state.riskParams.liquidationSpread.value,
2559             FILE,
2560             "Ratio cannot be <= spread"
2561         );
2562         state.riskParams.marginRatio = ratio;
2563         emit LogSetMarginRatio(ratio);
2564     }
2565 
2566     function ownerSetLiquidationSpread(
2567         Storage.State storage state,
2568         Decimal.D256 memory spread
2569     )
2570         public
2571     {
2572         Require.that(
2573             spread.value <= state.riskLimits.liquidationSpreadMax,
2574             FILE,
2575             "Spread too high"
2576         );
2577         Require.that(
2578             spread.value < state.riskParams.marginRatio.value,
2579             FILE,
2580             "Spread cannot be >= ratio"
2581         );
2582         state.riskParams.liquidationSpread = spread;
2583         emit LogSetLiquidationSpread(spread);
2584     }
2585 
2586     function ownerSetEarningsRate(
2587         Storage.State storage state,
2588         Decimal.D256 memory earningsRate
2589     )
2590         public
2591     {
2592         Require.that(
2593             earningsRate.value <= state.riskLimits.earningsRateMax,
2594             FILE,
2595             "Rate too high"
2596         );
2597         state.riskParams.earningsRate = earningsRate;
2598         emit LogSetEarningsRate(earningsRate);
2599     }
2600 
2601     function ownerSetMinBorrowedValue(
2602         Storage.State storage state,
2603         Monetary.Value memory minBorrowedValue
2604     )
2605         public
2606     {
2607         Require.that(
2608             minBorrowedValue.value <= state.riskLimits.minBorrowedValueMax,
2609             FILE,
2610             "Value too high"
2611         );
2612         state.riskParams.minBorrowedValue = minBorrowedValue;
2613         emit LogSetMinBorrowedValue(minBorrowedValue);
2614     }
2615 
2616     // ============ Global Operator Functions ============
2617 
2618     function ownerSetGlobalOperator(
2619         Storage.State storage state,
2620         address operator,
2621         bool approved
2622     )
2623         public
2624     {
2625         state.globalOperators[operator] = approved;
2626 
2627         emit LogSetGlobalOperator(operator, approved);
2628     }
2629 
2630     // ============ Private Functions ============
2631 
2632     function _setPriceOracle(
2633         Storage.State storage state,
2634         uint256 marketId,
2635         IPriceOracle priceOracle
2636     )
2637         private
2638     {
2639         // require oracle can return non-zero price
2640         address token = state.markets[marketId].token;
2641 
2642         Require.that(
2643             priceOracle.getPrice(token).value != 0,
2644             FILE,
2645             "Invalid oracle price"
2646         );
2647 
2648         state.markets[marketId].priceOracle = priceOracle;
2649 
2650         emit LogSetPriceOracle(marketId, address(priceOracle));
2651     }
2652 
2653     function _setInterestSetter(
2654         Storage.State storage state,
2655         uint256 marketId,
2656         IInterestSetter interestSetter
2657     )
2658         private
2659     {
2660         // ensure interestSetter can return a value without reverting
2661         address token = state.markets[marketId].token;
2662         interestSetter.getInterestRate(token, 0, 0);
2663 
2664         state.markets[marketId].interestSetter = interestSetter;
2665 
2666         emit LogSetInterestSetter(marketId, address(interestSetter));
2667     }
2668 
2669     function _setMarginPremium(
2670         Storage.State storage state,
2671         uint256 marketId,
2672         Decimal.D256 memory marginPremium
2673     )
2674         private
2675     {
2676         Require.that(
2677             marginPremium.value <= state.riskLimits.marginPremiumMax,
2678             FILE,
2679             "Margin premium too high"
2680         );
2681         state.markets[marketId].marginPremium = marginPremium;
2682 
2683         emit LogSetMarginPremium(marketId, marginPremium);
2684     }
2685 
2686     function _setSpreadPremium(
2687         Storage.State storage state,
2688         uint256 marketId,
2689         Decimal.D256 memory spreadPremium
2690     )
2691         private
2692     {
2693         Require.that(
2694             spreadPremium.value <= state.riskLimits.spreadPremiumMax,
2695             FILE,
2696             "Spread premium too high"
2697         );
2698         state.markets[marketId].spreadPremium = spreadPremium;
2699 
2700         emit LogSetSpreadPremium(marketId, spreadPremium);
2701     }
2702 
2703     function _requireNoMarket(
2704         Storage.State storage state,
2705         address token
2706     )
2707         private
2708         view
2709     {
2710         uint256 numMarkets = state.numMarkets;
2711 
2712         bool marketExists = false;
2713 
2714         for (uint256 m = 0; m < numMarkets; m++) {
2715             if (state.markets[m].token == token) {
2716                 marketExists = true;
2717                 break;
2718             }
2719         }
2720 
2721         Require.that(
2722             !marketExists,
2723             FILE,
2724             "Market exists"
2725         );
2726     }
2727 
2728     function _validateMarketId(
2729         Storage.State storage state,
2730         uint256 marketId
2731     )
2732         private
2733         view
2734     {
2735         Require.that(
2736             marketId < state.numMarkets,
2737             FILE,
2738             "Market OOB",
2739             marketId
2740         );
2741     }
2742 }
2743 
2744 // File: contracts/protocol/Admin.sol
2745 
2746 /**
2747  * @title Admin
2748  * @author dYdX
2749  *
2750  * Public functions that allow the privileged owner address to manage Solo
2751  */
2752 contract Admin is
2753     State,
2754     Ownable,
2755     ReentrancyGuard
2756 {
2757     // ============ Token Functions ============
2758 
2759     /**
2760      * Withdraw an ERC20 token for which there is an associated market. Only excess tokens can be
2761      * withdrawn. The number of excess tokens is calculated by taking the current number of tokens
2762      * held in Solo, adding the number of tokens owed to Solo by borrowers, and subtracting the
2763      * number of tokens owed to suppliers by Solo.
2764      */
2765     function ownerWithdrawExcessTokens(
2766         uint256 marketId,
2767         address recipient
2768     )
2769         public
2770         onlyOwner
2771         nonReentrant
2772         returns (uint256)
2773     {
2774         return AdminImpl.ownerWithdrawExcessTokens(
2775             g_state,
2776             marketId,
2777             recipient
2778         );
2779     }
2780 
2781     /**
2782      * Withdraw an ERC20 token for which there is no associated market.
2783      */
2784     function ownerWithdrawUnsupportedTokens(
2785         address token,
2786         address recipient
2787     )
2788         public
2789         onlyOwner
2790         nonReentrant
2791         returns (uint256)
2792     {
2793         return AdminImpl.ownerWithdrawUnsupportedTokens(
2794             g_state,
2795             token,
2796             recipient
2797         );
2798     }
2799 
2800     // ============ Market Functions ============
2801 
2802     /**
2803      * Add a new market to Solo. Must be for a previously-unsupported ERC20 token.
2804      */
2805     function ownerAddMarket(
2806         address token,
2807         IPriceOracle priceOracle,
2808         IInterestSetter interestSetter,
2809         Decimal.D256 memory marginPremium,
2810         Decimal.D256 memory spreadPremium
2811     )
2812         public
2813         onlyOwner
2814         nonReentrant
2815     {
2816         AdminImpl.ownerAddMarket(
2817             g_state,
2818             token,
2819             priceOracle,
2820             interestSetter,
2821             marginPremium,
2822             spreadPremium
2823         );
2824     }
2825 
2826     /**
2827      * Set (or unset) the status of a market to "closing". The borrowedValue of a market cannot
2828      * increase while its status is "closing".
2829      */
2830     function ownerSetIsClosing(
2831         uint256 marketId,
2832         bool isClosing
2833     )
2834         public
2835         onlyOwner
2836         nonReentrant
2837     {
2838         AdminImpl.ownerSetIsClosing(
2839             g_state,
2840             marketId,
2841             isClosing
2842         );
2843     }
2844 
2845     /**
2846      * Set the price oracle for a market.
2847      */
2848     function ownerSetPriceOracle(
2849         uint256 marketId,
2850         IPriceOracle priceOracle
2851     )
2852         public
2853         onlyOwner
2854         nonReentrant
2855     {
2856         AdminImpl.ownerSetPriceOracle(
2857             g_state,
2858             marketId,
2859             priceOracle
2860         );
2861     }
2862 
2863     /**
2864      * Set the interest-setter for a market.
2865      */
2866     function ownerSetInterestSetter(
2867         uint256 marketId,
2868         IInterestSetter interestSetter
2869     )
2870         public
2871         onlyOwner
2872         nonReentrant
2873     {
2874         AdminImpl.ownerSetInterestSetter(
2875             g_state,
2876             marketId,
2877             interestSetter
2878         );
2879     }
2880 
2881     /**
2882      * Set a premium on the minimum margin-ratio for a market. This makes it so that any positions
2883      * that include this market require a higher collateralization to avoid being liquidated.
2884      */
2885     function ownerSetMarginPremium(
2886         uint256 marketId,
2887         Decimal.D256 memory marginPremium
2888     )
2889         public
2890         onlyOwner
2891         nonReentrant
2892     {
2893         AdminImpl.ownerSetMarginPremium(
2894             g_state,
2895             marketId,
2896             marginPremium
2897         );
2898     }
2899 
2900     /**
2901      * Set a premium on the liquidation spread for a market. This makes it so that any liquidations
2902      * that include this market have a higher spread than the global default.
2903      */
2904     function ownerSetSpreadPremium(
2905         uint256 marketId,
2906         Decimal.D256 memory spreadPremium
2907     )
2908         public
2909         onlyOwner
2910         nonReentrant
2911     {
2912         AdminImpl.ownerSetSpreadPremium(
2913             g_state,
2914             marketId,
2915             spreadPremium
2916         );
2917     }
2918 
2919     // ============ Risk Functions ============
2920 
2921     /**
2922      * Set the global minimum margin-ratio that every position must maintain to prevent being
2923      * liquidated.
2924      */
2925     function ownerSetMarginRatio(
2926         Decimal.D256 memory ratio
2927     )
2928         public
2929         onlyOwner
2930         nonReentrant
2931     {
2932         AdminImpl.ownerSetMarginRatio(
2933             g_state,
2934             ratio
2935         );
2936     }
2937 
2938     /**
2939      * Set the global liquidation spread. This is the spread between oracle prices that incentivizes
2940      * the liquidation of risky positions.
2941      */
2942     function ownerSetLiquidationSpread(
2943         Decimal.D256 memory spread
2944     )
2945         public
2946         onlyOwner
2947         nonReentrant
2948     {
2949         AdminImpl.ownerSetLiquidationSpread(
2950             g_state,
2951             spread
2952         );
2953     }
2954 
2955     /**
2956      * Set the global earnings-rate variable that determines what percentage of the interest paid
2957      * by borrowers gets passed-on to suppliers.
2958      */
2959     function ownerSetEarningsRate(
2960         Decimal.D256 memory earningsRate
2961     )
2962         public
2963         onlyOwner
2964         nonReentrant
2965     {
2966         AdminImpl.ownerSetEarningsRate(
2967             g_state,
2968             earningsRate
2969         );
2970     }
2971 
2972     /**
2973      * Set the global minimum-borrow value which is the minimum value of any new borrow on Solo.
2974      */
2975     function ownerSetMinBorrowedValue(
2976         Monetary.Value memory minBorrowedValue
2977     )
2978         public
2979         onlyOwner
2980         nonReentrant
2981     {
2982         AdminImpl.ownerSetMinBorrowedValue(
2983             g_state,
2984             minBorrowedValue
2985         );
2986     }
2987 
2988     // ============ Global Operator Functions ============
2989 
2990     /**
2991      * Approve (or disapprove) an address that is permissioned to be an operator for all accounts in
2992      * Solo. Intended only to approve smart-contracts.
2993      */
2994     function ownerSetGlobalOperator(
2995         address operator,
2996         bool approved
2997     )
2998         public
2999         onlyOwner
3000         nonReentrant
3001     {
3002         AdminImpl.ownerSetGlobalOperator(
3003             g_state,
3004             operator,
3005             approved
3006         );
3007     }
3008 }
3009 
3010 // File: contracts/protocol/Getters.sol
3011 
3012 /**
3013  * @title Getters
3014  * @author dYdX
3015  *
3016  * Public read-only functions that allow transparency into the state of Solo
3017  */
3018 contract Getters is
3019     State
3020 {
3021     using Cache for Cache.MarketCache;
3022     using Storage for Storage.State;
3023     using Types for Types.Par;
3024 
3025     // ============ Constants ============
3026 
3027     bytes32 FILE = "Getters";
3028 
3029     // ============ Getters for Risk ============
3030 
3031     /**
3032      * Get the global minimum margin-ratio that every position must maintain to prevent being
3033      * liquidated.
3034      *
3035      * @return  The global margin-ratio
3036      */
3037     function getMarginRatio()
3038         public
3039         view
3040         returns (Decimal.D256 memory)
3041     {
3042         return g_state.riskParams.marginRatio;
3043     }
3044 
3045     /**
3046      * Get the global liquidation spread. This is the spread between oracle prices that incentivizes
3047      * the liquidation of risky positions.
3048      *
3049      * @return  The global liquidation spread
3050      */
3051     function getLiquidationSpread()
3052         public
3053         view
3054         returns (Decimal.D256 memory)
3055     {
3056         return g_state.riskParams.liquidationSpread;
3057     }
3058 
3059     /**
3060      * Get the global earnings-rate variable that determines what percentage of the interest paid
3061      * by borrowers gets passed-on to suppliers.
3062      *
3063      * @return  The global earnings rate
3064      */
3065     function getEarningsRate()
3066         public
3067         view
3068         returns (Decimal.D256 memory)
3069     {
3070         return g_state.riskParams.earningsRate;
3071     }
3072 
3073     /**
3074      * Get the global minimum-borrow value which is the minimum value of any new borrow on Solo.
3075      *
3076      * @return  The global minimum borrow value
3077      */
3078     function getMinBorrowedValue()
3079         public
3080         view
3081         returns (Monetary.Value memory)
3082     {
3083         return g_state.riskParams.minBorrowedValue;
3084     }
3085 
3086     /**
3087      * Get all risk parameters in a single struct.
3088      *
3089      * @return  All global risk parameters
3090      */
3091     function getRiskParams()
3092         public
3093         view
3094         returns (Storage.RiskParams memory)
3095     {
3096         return g_state.riskParams;
3097     }
3098 
3099     /**
3100      * Get all risk parameter limits in a single struct. These are the maximum limits at which the
3101      * risk parameters can be set by the admin of Solo.
3102      *
3103      * @return  All global risk parameter limnits
3104      */
3105     function getRiskLimits()
3106         public
3107         view
3108         returns (Storage.RiskLimits memory)
3109     {
3110         return g_state.riskLimits;
3111     }
3112 
3113     // ============ Getters for Markets ============
3114 
3115     /**
3116      * Get the total number of markets.
3117      *
3118      * @return  The number of markets
3119      */
3120     function getNumMarkets()
3121         public
3122         view
3123         returns (uint256)
3124     {
3125         return g_state.numMarkets;
3126     }
3127 
3128     /**
3129      * Get the ERC20 token address for a market.
3130      *
3131      * @param  marketId  The market to query
3132      * @return           The token address
3133      */
3134     function getMarketTokenAddress(
3135         uint256 marketId
3136     )
3137         public
3138         view
3139         returns (address)
3140     {
3141         _requireValidMarket(marketId);
3142         return g_state.getToken(marketId);
3143     }
3144 
3145     /**
3146      * Get the total principal amounts (borrowed and supplied) for a market.
3147      *
3148      * @param  marketId  The market to query
3149      * @return           The total principal amounts
3150      */
3151     function getMarketTotalPar(
3152         uint256 marketId
3153     )
3154         public
3155         view
3156         returns (Types.TotalPar memory)
3157     {
3158         _requireValidMarket(marketId);
3159         return g_state.getTotalPar(marketId);
3160     }
3161 
3162     /**
3163      * Get the most recently cached interest index for a market.
3164      *
3165      * @param  marketId  The market to query
3166      * @return           The most recent index
3167      */
3168     function getMarketCachedIndex(
3169         uint256 marketId
3170     )
3171         public
3172         view
3173         returns (Interest.Index memory)
3174     {
3175         _requireValidMarket(marketId);
3176         return g_state.getIndex(marketId);
3177     }
3178 
3179     /**
3180      * Get the interest index for a market if it were to be updated right now.
3181      *
3182      * @param  marketId  The market to query
3183      * @return           The estimated current index
3184      */
3185     function getMarketCurrentIndex(
3186         uint256 marketId
3187     )
3188         public
3189         view
3190         returns (Interest.Index memory)
3191     {
3192         _requireValidMarket(marketId);
3193         return g_state.fetchNewIndex(marketId, g_state.getIndex(marketId));
3194     }
3195 
3196     /**
3197      * Get the price oracle address for a market.
3198      *
3199      * @param  marketId  The market to query
3200      * @return           The price oracle address
3201      */
3202     function getMarketPriceOracle(
3203         uint256 marketId
3204     )
3205         public
3206         view
3207         returns (IPriceOracle)
3208     {
3209         _requireValidMarket(marketId);
3210         return g_state.markets[marketId].priceOracle;
3211     }
3212 
3213     /**
3214      * Get the interest-setter address for a market.
3215      *
3216      * @param  marketId  The market to query
3217      * @return           The interest-setter address
3218      */
3219     function getMarketInterestSetter(
3220         uint256 marketId
3221     )
3222         public
3223         view
3224         returns (IInterestSetter)
3225     {
3226         _requireValidMarket(marketId);
3227         return g_state.markets[marketId].interestSetter;
3228     }
3229 
3230     /**
3231      * Get the margin premium for a market. A margin premium makes it so that any positions that
3232      * include the market require a higher collateralization to avoid being liquidated.
3233      *
3234      * @param  marketId  The market to query
3235      * @return           The market's margin premium
3236      */
3237     function getMarketMarginPremium(
3238         uint256 marketId
3239     )
3240         public
3241         view
3242         returns (Decimal.D256 memory)
3243     {
3244         _requireValidMarket(marketId);
3245         return g_state.markets[marketId].marginPremium;
3246     }
3247 
3248     /**
3249      * Get the spread premium for a market. A spread premium makes it so that any liquidations
3250      * that include the market have a higher spread than the global default.
3251      *
3252      * @param  marketId  The market to query
3253      * @return           The market's spread premium
3254      */
3255     function getMarketSpreadPremium(
3256         uint256 marketId
3257     )
3258         public
3259         view
3260         returns (Decimal.D256 memory)
3261     {
3262         _requireValidMarket(marketId);
3263         return g_state.markets[marketId].spreadPremium;
3264     }
3265 
3266     /**
3267      * Return true if a particular market is in closing mode. Additional borrows cannot be taken
3268      * from a market that is closing.
3269      *
3270      * @param  marketId  The market to query
3271      * @return           True if the market is closing
3272      */
3273     function getMarketIsClosing(
3274         uint256 marketId
3275     )
3276         public
3277         view
3278         returns (bool)
3279     {
3280         _requireValidMarket(marketId);
3281         return g_state.markets[marketId].isClosing;
3282     }
3283 
3284     /**
3285      * Get the price of the token for a market.
3286      *
3287      * @param  marketId  The market to query
3288      * @return           The price of each atomic unit of the token
3289      */
3290     function getMarketPrice(
3291         uint256 marketId
3292     )
3293         public
3294         view
3295         returns (Monetary.Price memory)
3296     {
3297         _requireValidMarket(marketId);
3298         return g_state.fetchPrice(marketId);
3299     }
3300 
3301     /**
3302      * Get the current borrower interest rate for a market.
3303      *
3304      * @param  marketId  The market to query
3305      * @return           The current interest rate
3306      */
3307     function getMarketInterestRate(
3308         uint256 marketId
3309     )
3310         public
3311         view
3312         returns (Interest.Rate memory)
3313     {
3314         _requireValidMarket(marketId);
3315         return g_state.fetchInterestRate(
3316             marketId,
3317             g_state.getIndex(marketId)
3318         );
3319     }
3320 
3321     /**
3322      * Get the adjusted liquidation spread for some market pair. This is equal to the global
3323      * liquidation spread multiplied by (1 + spreadPremium) for each of the two markets.
3324      *
3325      * @param  heldMarketId  The market for which the account has collateral
3326      * @param  owedMarketId  The market for which the account has borrowed tokens
3327      * @return               The adjusted liquidation spread
3328      */
3329     function getLiquidationSpreadForPair(
3330         uint256 heldMarketId,
3331         uint256 owedMarketId
3332     )
3333         public
3334         view
3335         returns (Decimal.D256 memory)
3336     {
3337         _requireValidMarket(heldMarketId);
3338         _requireValidMarket(owedMarketId);
3339         return g_state.getLiquidationSpreadForPair(heldMarketId, owedMarketId);
3340     }
3341 
3342     /**
3343      * Get basic information about a particular market.
3344      *
3345      * @param  marketId  The market to query
3346      * @return           A Storage.Market struct with the current state of the market
3347      */
3348     function getMarket(
3349         uint256 marketId
3350     )
3351         public
3352         view
3353         returns (Storage.Market memory)
3354     {
3355         _requireValidMarket(marketId);
3356         return g_state.markets[marketId];
3357     }
3358 
3359     /**
3360      * Get comprehensive information about a particular market.
3361      *
3362      * @param  marketId  The market to query
3363      * @return           A tuple containing the values:
3364      *                    - A Storage.Market struct with the current state of the market
3365      *                    - The current estimated interest index
3366      *                    - The current token price
3367      *                    - The current market interest rate
3368      */
3369     function getMarketWithInfo(
3370         uint256 marketId
3371     )
3372         public
3373         view
3374         returns (
3375             Storage.Market memory,
3376             Interest.Index memory,
3377             Monetary.Price memory,
3378             Interest.Rate memory
3379         )
3380     {
3381         _requireValidMarket(marketId);
3382         return (
3383             getMarket(marketId),
3384             getMarketCurrentIndex(marketId),
3385             getMarketPrice(marketId),
3386             getMarketInterestRate(marketId)
3387         );
3388     }
3389 
3390     /**
3391      * Get the number of excess tokens for a market. The number of excess tokens is calculated
3392      * by taking the current number of tokens held in Solo, adding the number of tokens owed to Solo
3393      * by borrowers, and subtracting the number of tokens owed to suppliers by Solo.
3394      *
3395      * @param  marketId  The market to query
3396      * @return           The number of excess tokens
3397      */
3398     function getNumExcessTokens(
3399         uint256 marketId
3400     )
3401         public
3402         view
3403         returns (Types.Wei memory)
3404     {
3405         _requireValidMarket(marketId);
3406         return g_state.getNumExcessTokens(marketId);
3407     }
3408 
3409     // ============ Getters for Accounts ============
3410 
3411     /**
3412      * Get the principal value for a particular account and market.
3413      *
3414      * @param  account   The account to query
3415      * @param  marketId  The market to query
3416      * @return           The principal value
3417      */
3418     function getAccountPar(
3419         Account.Info memory account,
3420         uint256 marketId
3421     )
3422         public
3423         view
3424         returns (Types.Par memory)
3425     {
3426         _requireValidMarket(marketId);
3427         return g_state.getPar(account, marketId);
3428     }
3429 
3430     /**
3431      * Get the token balance for a particular account and market.
3432      *
3433      * @param  account   The account to query
3434      * @param  marketId  The market to query
3435      * @return           The token amount
3436      */
3437     function getAccountWei(
3438         Account.Info memory account,
3439         uint256 marketId
3440     )
3441         public
3442         view
3443         returns (Types.Wei memory)
3444     {
3445         _requireValidMarket(marketId);
3446         return Interest.parToWei(
3447             g_state.getPar(account, marketId),
3448             g_state.fetchNewIndex(marketId, g_state.getIndex(marketId))
3449         );
3450     }
3451 
3452     /**
3453      * Get the status of an account (Normal, Liquidating, or Vaporizing).
3454      *
3455      * @param  account  The account to query
3456      * @return          The account's status
3457      */
3458     function getAccountStatus(
3459         Account.Info memory account
3460     )
3461         public
3462         view
3463         returns (Account.Status)
3464     {
3465         return g_state.getStatus(account);
3466     }
3467 
3468     /**
3469      * Get the total supplied and total borrowed value of an account.
3470      *
3471      * @param  account  The account to query
3472      * @return          The following values:
3473      *                   - The supplied value of the account
3474      *                   - The borrowed value of the account
3475      */
3476     function getAccountValues(
3477         Account.Info memory account
3478     )
3479         public
3480         view
3481         returns (Monetary.Value memory, Monetary.Value memory)
3482     {
3483         return getAccountValuesInternal(account, /* adjustForLiquidity = */ false);
3484     }
3485 
3486     /**
3487      * Get the total supplied and total borrowed values of an account adjusted by the marginPremium
3488      * of each market. Supplied values are divided by (1 + marginPremium) for each market and
3489      * borrowed values are multiplied by (1 + marginPremium) for each market. Comparing these
3490      * adjusted values gives the margin-ratio of the account which will be compared to the global
3491      * margin-ratio when determining if the account can be liquidated.
3492      *
3493      * @param  account  The account to query
3494      * @return          The following values:
3495      *                   - The supplied value of the account (adjusted for marginPremium)
3496      *                   - The borrowed value of the account (adjusted for marginPremium)
3497      */
3498     function getAdjustedAccountValues(
3499         Account.Info memory account
3500     )
3501         public
3502         view
3503         returns (Monetary.Value memory, Monetary.Value memory)
3504     {
3505         return getAccountValuesInternal(account, /* adjustForLiquidity = */ true);
3506     }
3507 
3508     /**
3509      * Get an account's summary for each market.
3510      *
3511      * @param  account  The account to query
3512      * @return          The following values:
3513      *                   - The ERC20 token address for each market
3514      *                   - The account's principal value for each market
3515      *                   - The account's (supplied or borrowed) number of tokens for each market
3516      */
3517     function getAccountBalances(
3518         Account.Info memory account
3519     )
3520         public
3521         view
3522         returns (
3523             address[] memory,
3524             Types.Par[] memory,
3525             Types.Wei[] memory
3526         )
3527     {
3528         uint256 numMarkets = g_state.numMarkets;
3529         address[] memory tokens = new address[](numMarkets);
3530         Types.Par[] memory pars = new Types.Par[](numMarkets);
3531         Types.Wei[] memory weis = new Types.Wei[](numMarkets);
3532 
3533         for (uint256 m = 0; m < numMarkets; m++) {
3534             tokens[m] = getMarketTokenAddress(m);
3535             pars[m] = getAccountPar(account, m);
3536             weis[m] = getAccountWei(account, m);
3537         }
3538 
3539         return (
3540             tokens,
3541             pars,
3542             weis
3543         );
3544     }
3545 
3546     // ============ Getters for Permissions ============
3547 
3548     /**
3549      * Return true if a particular address is approved as an operator for an owner's accounts.
3550      * Approved operators can act on the accounts of the owner as if it were the operator's own.
3551      *
3552      * @param  owner     The owner of the accounts
3553      * @param  operator  The possible operator
3554      * @return           True if operator is approved for owner's accounts
3555      */
3556     function getIsLocalOperator(
3557         address owner,
3558         address operator
3559     )
3560         public
3561         view
3562         returns (bool)
3563     {
3564         return g_state.isLocalOperator(owner, operator);
3565     }
3566 
3567     /**
3568      * Return true if a particular address is approved as a global operator. Such an address can
3569      * act on any account as if it were the operator's own.
3570      *
3571      * @param  operator  The address to query
3572      * @return           True if operator is a global operator
3573      */
3574     function getIsGlobalOperator(
3575         address operator
3576     )
3577         public
3578         view
3579         returns (bool)
3580     {
3581         return g_state.isGlobalOperator(operator);
3582     }
3583 
3584     // ============ Private Helper Functions ============
3585 
3586     /**
3587      * Revert if marketId is invalid.
3588      */
3589     function _requireValidMarket(
3590         uint256 marketId
3591     )
3592         private
3593         view
3594     {
3595         Require.that(
3596             marketId < g_state.numMarkets,
3597             FILE,
3598             "Market OOB"
3599         );
3600     }
3601 
3602     /**
3603      * Private helper for getting the monetary values of an account.
3604      */
3605     function getAccountValuesInternal(
3606         Account.Info memory account,
3607         bool adjustForLiquidity
3608     )
3609         private
3610         view
3611         returns (Monetary.Value memory, Monetary.Value memory)
3612     {
3613         uint256 numMarkets = g_state.numMarkets;
3614 
3615         // populate cache
3616         Cache.MarketCache memory cache = Cache.create(numMarkets);
3617         for (uint256 m = 0; m < numMarkets; m++) {
3618             if (!g_state.getPar(account, m).isZero()) {
3619                 cache.addMarket(g_state, m);
3620             }
3621         }
3622 
3623         return g_state.getAccountValues(account, cache, adjustForLiquidity);
3624     }
3625 }
3626 
3627 // File: contracts/protocol/lib/Actions.sol
3628 
3629 /**
3630  * @title Actions
3631  * @author dYdX
3632  *
3633  * Library that defines and parses valid Actions
3634  */
3635 library Actions {
3636 
3637     // ============ Constants ============
3638 
3639     bytes32 constant FILE = "Actions";
3640 
3641     // ============ Enums ============
3642 
3643     enum ActionType {
3644         Deposit,   // supply tokens
3645         Withdraw,  // borrow tokens
3646         Transfer,  // transfer balance between accounts
3647         Buy,       // buy an amount of some token (externally)
3648         Sell,      // sell an amount of some token (externally)
3649         Trade,     // trade tokens against another account
3650         Liquidate, // liquidate an undercollateralized or expiring account
3651         Vaporize,  // use excess tokens to zero-out a completely negative account
3652         Call       // send arbitrary data to an address
3653     }
3654 
3655     enum AccountLayout {
3656         OnePrimary,
3657         TwoPrimary,
3658         PrimaryAndSecondary
3659     }
3660 
3661     enum MarketLayout {
3662         ZeroMarkets,
3663         OneMarket,
3664         TwoMarkets
3665     }
3666 
3667     // ============ Structs ============
3668 
3669     /*
3670      * Arguments that are passed to Solo in an ordered list as part of a single operation.
3671      * Each ActionArgs has an actionType which specifies which action struct that this data will be
3672      * parsed into before being processed.
3673      */
3674     struct ActionArgs {
3675         ActionType actionType;
3676         uint256 accountId;
3677         Types.AssetAmount amount;
3678         uint256 primaryMarketId;
3679         uint256 secondaryMarketId;
3680         address otherAddress;
3681         uint256 otherAccountId;
3682         bytes data;
3683     }
3684 
3685     // ============ Action Types ============
3686 
3687     /*
3688      * Moves tokens from an address to Solo. Can either repay a borrow or provide additional supply.
3689      */
3690     struct DepositArgs {
3691         Types.AssetAmount amount;
3692         Account.Info account;
3693         uint256 market;
3694         address from;
3695     }
3696 
3697     /*
3698      * Moves tokens from Solo to another address. Can either borrow tokens or reduce the amount
3699      * previously supplied.
3700      */
3701     struct WithdrawArgs {
3702         Types.AssetAmount amount;
3703         Account.Info account;
3704         uint256 market;
3705         address to;
3706     }
3707 
3708     /*
3709      * Transfers balance between two accounts. The msg.sender must be an operator for both accounts.
3710      * The amount field applies to accountOne.
3711      * This action does not require any token movement since the trade is done internally to Solo.
3712      */
3713     struct TransferArgs {
3714         Types.AssetAmount amount;
3715         Account.Info accountOne;
3716         Account.Info accountTwo;
3717         uint256 market;
3718     }
3719 
3720     /*
3721      * Acquires a certain amount of tokens by spending other tokens. Sends takerMarket tokens to the
3722      * specified exchangeWrapper contract and expects makerMarket tokens in return. The amount field
3723      * applies to the makerMarket.
3724      */
3725     struct BuyArgs {
3726         Types.AssetAmount amount;
3727         Account.Info account;
3728         uint256 makerMarket;
3729         uint256 takerMarket;
3730         address exchangeWrapper;
3731         bytes orderData;
3732     }
3733 
3734     /*
3735      * Spends a certain amount of tokens to acquire other tokens. Sends takerMarket tokens to the
3736      * specified exchangeWrapper and expects makerMarket tokens in return. The amount field applies
3737      * to the takerMarket.
3738      */
3739     struct SellArgs {
3740         Types.AssetAmount amount;
3741         Account.Info account;
3742         uint256 takerMarket;
3743         uint256 makerMarket;
3744         address exchangeWrapper;
3745         bytes orderData;
3746     }
3747 
3748     /*
3749      * Trades balances between two accounts using any external contract that implements the
3750      * AutoTrader interface. The AutoTrader contract must be an operator for the makerAccount (for
3751      * which it is trading on-behalf-of). The amount field applies to the makerAccount and the
3752      * inputMarket. This proposed change to the makerAccount is passed to the AutoTrader which will
3753      * quote a change for the makerAccount in the outputMarket (or will disallow the trade).
3754      * This action does not require any token movement since the trade is done internally to Solo.
3755      */
3756     struct TradeArgs {
3757         Types.AssetAmount amount;
3758         Account.Info takerAccount;
3759         Account.Info makerAccount;
3760         uint256 inputMarket;
3761         uint256 outputMarket;
3762         address autoTrader;
3763         bytes tradeData;
3764     }
3765 
3766     /*
3767      * Each account must maintain a certain margin-ratio (specified globally). If the account falls
3768      * below this margin-ratio, it can be liquidated by any other account. This allows anyone else
3769      * (arbitrageurs) to repay any borrowed asset (owedMarket) of the liquidating account in
3770      * exchange for any collateral asset (heldMarket) of the liquidAccount. The ratio is determined
3771      * by the price ratio (given by the oracles) plus a spread (specified globally). Liquidating an
3772      * account also sets a flag on the account that the account is being liquidated. This allows
3773      * anyone to continue liquidating the account until there are no more borrows being taken by the
3774      * liquidating account. Liquidators do not have to liquidate the entire account all at once but
3775      * can liquidate as much as they choose. The liquidating flag allows liquidators to continue
3776      * liquidating the account even if it becomes collateralized through partial liquidation or
3777      * price movement.
3778      */
3779     struct LiquidateArgs {
3780         Types.AssetAmount amount;
3781         Account.Info solidAccount;
3782         Account.Info liquidAccount;
3783         uint256 owedMarket;
3784         uint256 heldMarket;
3785     }
3786 
3787     /*
3788      * Similar to liquidate, but vaporAccounts are accounts that have only negative balances
3789      * remaining. The arbitrageur pays back the negative asset (owedMarket) of the vaporAccount in
3790      * exchange for a collateral asset (heldMarket) at a favorable spread. However, since the
3791      * liquidAccount has no collateral assets, the collateral must come from Solo's excess tokens.
3792      */
3793     struct VaporizeArgs {
3794         Types.AssetAmount amount;
3795         Account.Info solidAccount;
3796         Account.Info vaporAccount;
3797         uint256 owedMarket;
3798         uint256 heldMarket;
3799     }
3800 
3801     /*
3802      * Passes arbitrary bytes of data to an external contract that implements the Callee interface.
3803      * Does not change any asset amounts. This function may be useful for setting certain variables
3804      * on layer-two contracts for certain accounts without having to make a separate Ethereum
3805      * transaction for doing so. Also, the second-layer contracts can ensure that the call is coming
3806      * from an operator of the particular account.
3807      */
3808     struct CallArgs {
3809         Account.Info account;
3810         address callee;
3811         bytes data;
3812     }
3813 
3814     // ============ Helper Functions ============
3815 
3816     function getMarketLayout(
3817         ActionType actionType
3818     )
3819         internal
3820         pure
3821         returns (MarketLayout)
3822     {
3823         if (
3824             actionType == Actions.ActionType.Deposit
3825             || actionType == Actions.ActionType.Withdraw
3826             || actionType == Actions.ActionType.Transfer
3827         ) {
3828             return MarketLayout.OneMarket;
3829         }
3830         else if (actionType == Actions.ActionType.Call) {
3831             return MarketLayout.ZeroMarkets;
3832         }
3833         return MarketLayout.TwoMarkets;
3834     }
3835 
3836     function getAccountLayout(
3837         ActionType actionType
3838     )
3839         internal
3840         pure
3841         returns (AccountLayout)
3842     {
3843         if (
3844             actionType == Actions.ActionType.Transfer
3845             || actionType == Actions.ActionType.Trade
3846         ) {
3847             return AccountLayout.TwoPrimary;
3848         } else if (
3849             actionType == Actions.ActionType.Liquidate
3850             || actionType == Actions.ActionType.Vaporize
3851         ) {
3852             return AccountLayout.PrimaryAndSecondary;
3853         }
3854         return AccountLayout.OnePrimary;
3855     }
3856 
3857     // ============ Parsing Functions ============
3858 
3859     function parseDepositArgs(
3860         Account.Info[] memory accounts,
3861         ActionArgs memory args
3862     )
3863         internal
3864         pure
3865         returns (DepositArgs memory)
3866     {
3867         assert(args.actionType == ActionType.Deposit);
3868         return DepositArgs({
3869             amount: args.amount,
3870             account: accounts[args.accountId],
3871             market: args.primaryMarketId,
3872             from: args.otherAddress
3873         });
3874     }
3875 
3876     function parseWithdrawArgs(
3877         Account.Info[] memory accounts,
3878         ActionArgs memory args
3879     )
3880         internal
3881         pure
3882         returns (WithdrawArgs memory)
3883     {
3884         assert(args.actionType == ActionType.Withdraw);
3885         return WithdrawArgs({
3886             amount: args.amount,
3887             account: accounts[args.accountId],
3888             market: args.primaryMarketId,
3889             to: args.otherAddress
3890         });
3891     }
3892 
3893     function parseTransferArgs(
3894         Account.Info[] memory accounts,
3895         ActionArgs memory args
3896     )
3897         internal
3898         pure
3899         returns (TransferArgs memory)
3900     {
3901         assert(args.actionType == ActionType.Transfer);
3902         return TransferArgs({
3903             amount: args.amount,
3904             accountOne: accounts[args.accountId],
3905             accountTwo: accounts[args.otherAccountId],
3906             market: args.primaryMarketId
3907         });
3908     }
3909 
3910     function parseBuyArgs(
3911         Account.Info[] memory accounts,
3912         ActionArgs memory args
3913     )
3914         internal
3915         pure
3916         returns (BuyArgs memory)
3917     {
3918         assert(args.actionType == ActionType.Buy);
3919         return BuyArgs({
3920             amount: args.amount,
3921             account: accounts[args.accountId],
3922             makerMarket: args.primaryMarketId,
3923             takerMarket: args.secondaryMarketId,
3924             exchangeWrapper: args.otherAddress,
3925             orderData: args.data
3926         });
3927     }
3928 
3929     function parseSellArgs(
3930         Account.Info[] memory accounts,
3931         ActionArgs memory args
3932     )
3933         internal
3934         pure
3935         returns (SellArgs memory)
3936     {
3937         assert(args.actionType == ActionType.Sell);
3938         return SellArgs({
3939             amount: args.amount,
3940             account: accounts[args.accountId],
3941             takerMarket: args.primaryMarketId,
3942             makerMarket: args.secondaryMarketId,
3943             exchangeWrapper: args.otherAddress,
3944             orderData: args.data
3945         });
3946     }
3947 
3948     function parseTradeArgs(
3949         Account.Info[] memory accounts,
3950         ActionArgs memory args
3951     )
3952         internal
3953         pure
3954         returns (TradeArgs memory)
3955     {
3956         assert(args.actionType == ActionType.Trade);
3957         return TradeArgs({
3958             amount: args.amount,
3959             takerAccount: accounts[args.accountId],
3960             makerAccount: accounts[args.otherAccountId],
3961             inputMarket: args.primaryMarketId,
3962             outputMarket: args.secondaryMarketId,
3963             autoTrader: args.otherAddress,
3964             tradeData: args.data
3965         });
3966     }
3967 
3968     function parseLiquidateArgs(
3969         Account.Info[] memory accounts,
3970         ActionArgs memory args
3971     )
3972         internal
3973         pure
3974         returns (LiquidateArgs memory)
3975     {
3976         assert(args.actionType == ActionType.Liquidate);
3977         return LiquidateArgs({
3978             amount: args.amount,
3979             solidAccount: accounts[args.accountId],
3980             liquidAccount: accounts[args.otherAccountId],
3981             owedMarket: args.primaryMarketId,
3982             heldMarket: args.secondaryMarketId
3983         });
3984     }
3985 
3986     function parseVaporizeArgs(
3987         Account.Info[] memory accounts,
3988         ActionArgs memory args
3989     )
3990         internal
3991         pure
3992         returns (VaporizeArgs memory)
3993     {
3994         assert(args.actionType == ActionType.Vaporize);
3995         return VaporizeArgs({
3996             amount: args.amount,
3997             solidAccount: accounts[args.accountId],
3998             vaporAccount: accounts[args.otherAccountId],
3999             owedMarket: args.primaryMarketId,
4000             heldMarket: args.secondaryMarketId
4001         });
4002     }
4003 
4004     function parseCallArgs(
4005         Account.Info[] memory accounts,
4006         ActionArgs memory args
4007     )
4008         internal
4009         pure
4010         returns (CallArgs memory)
4011     {
4012         assert(args.actionType == ActionType.Call);
4013         return CallArgs({
4014             account: accounts[args.accountId],
4015             callee: args.otherAddress,
4016             data: args.data
4017         });
4018     }
4019 }
4020 
4021 // File: contracts/protocol/lib/Events.sol
4022 
4023 /**
4024  * @title Events
4025  * @author dYdX
4026  *
4027  * Library to parse and emit logs from which the state of all accounts and indexes can be followed
4028  */
4029 library Events {
4030     using Types for Types.Wei;
4031     using Storage for Storage.State;
4032 
4033     // ============ Events ============
4034 
4035     event LogIndexUpdate(
4036         uint256 indexed market,
4037         Interest.Index index
4038     );
4039 
4040     event LogOperation(
4041         address sender
4042     );
4043 
4044     event LogDeposit(
4045         address indexed accountOwner,
4046         uint256 accountNumber,
4047         uint256 market,
4048         BalanceUpdate update,
4049         address from
4050     );
4051 
4052     event LogWithdraw(
4053         address indexed accountOwner,
4054         uint256 accountNumber,
4055         uint256 market,
4056         BalanceUpdate update,
4057         address to
4058     );
4059 
4060     event LogTransfer(
4061         address indexed accountOneOwner,
4062         uint256 accountOneNumber,
4063         address indexed accountTwoOwner,
4064         uint256 accountTwoNumber,
4065         uint256 market,
4066         BalanceUpdate updateOne,
4067         BalanceUpdate updateTwo
4068     );
4069 
4070     event LogBuy(
4071         address indexed accountOwner,
4072         uint256 accountNumber,
4073         uint256 takerMarket,
4074         uint256 makerMarket,
4075         BalanceUpdate takerUpdate,
4076         BalanceUpdate makerUpdate,
4077         address exchangeWrapper
4078     );
4079 
4080     event LogSell(
4081         address indexed accountOwner,
4082         uint256 accountNumber,
4083         uint256 takerMarket,
4084         uint256 makerMarket,
4085         BalanceUpdate takerUpdate,
4086         BalanceUpdate makerUpdate,
4087         address exchangeWrapper
4088     );
4089 
4090     event LogTrade(
4091         address indexed takerAccountOwner,
4092         uint256 takerAccountNumber,
4093         address indexed makerAccountOwner,
4094         uint256 makerAccountNumber,
4095         uint256 inputMarket,
4096         uint256 outputMarket,
4097         BalanceUpdate takerInputUpdate,
4098         BalanceUpdate takerOutputUpdate,
4099         BalanceUpdate makerInputUpdate,
4100         BalanceUpdate makerOutputUpdate,
4101         address autoTrader
4102     );
4103 
4104     event LogCall(
4105         address indexed accountOwner,
4106         uint256 accountNumber,
4107         address callee
4108     );
4109 
4110     event LogLiquidate(
4111         address indexed solidAccountOwner,
4112         uint256 solidAccountNumber,
4113         address indexed liquidAccountOwner,
4114         uint256 liquidAccountNumber,
4115         uint256 heldMarket,
4116         uint256 owedMarket,
4117         BalanceUpdate solidHeldUpdate,
4118         BalanceUpdate solidOwedUpdate,
4119         BalanceUpdate liquidHeldUpdate,
4120         BalanceUpdate liquidOwedUpdate
4121     );
4122 
4123     event LogVaporize(
4124         address indexed solidAccountOwner,
4125         uint256 solidAccountNumber,
4126         address indexed vaporAccountOwner,
4127         uint256 vaporAccountNumber,
4128         uint256 heldMarket,
4129         uint256 owedMarket,
4130         BalanceUpdate solidHeldUpdate,
4131         BalanceUpdate solidOwedUpdate,
4132         BalanceUpdate vaporOwedUpdate
4133     );
4134 
4135     // ============ Structs ============
4136 
4137     struct BalanceUpdate {
4138         Types.Wei deltaWei;
4139         Types.Par newPar;
4140     }
4141 
4142     // ============ Internal Functions ============
4143 
4144     function logIndexUpdate(
4145         uint256 marketId,
4146         Interest.Index memory index
4147     )
4148         internal
4149     {
4150         emit LogIndexUpdate(
4151             marketId,
4152             index
4153         );
4154     }
4155 
4156     function logOperation()
4157         internal
4158     {
4159         emit LogOperation(msg.sender);
4160     }
4161 
4162     function logDeposit(
4163         Storage.State storage state,
4164         Actions.DepositArgs memory args,
4165         Types.Wei memory deltaWei
4166     )
4167         internal
4168     {
4169         emit LogDeposit(
4170             args.account.owner,
4171             args.account.number,
4172             args.market,
4173             getBalanceUpdate(
4174                 state,
4175                 args.account,
4176                 args.market,
4177                 deltaWei
4178             ),
4179             args.from
4180         );
4181     }
4182 
4183     function logWithdraw(
4184         Storage.State storage state,
4185         Actions.WithdrawArgs memory args,
4186         Types.Wei memory deltaWei
4187     )
4188         internal
4189     {
4190         emit LogWithdraw(
4191             args.account.owner,
4192             args.account.number,
4193             args.market,
4194             getBalanceUpdate(
4195                 state,
4196                 args.account,
4197                 args.market,
4198                 deltaWei
4199             ),
4200             args.to
4201         );
4202     }
4203 
4204     function logTransfer(
4205         Storage.State storage state,
4206         Actions.TransferArgs memory args,
4207         Types.Wei memory deltaWei
4208     )
4209         internal
4210     {
4211         emit LogTransfer(
4212             args.accountOne.owner,
4213             args.accountOne.number,
4214             args.accountTwo.owner,
4215             args.accountTwo.number,
4216             args.market,
4217             getBalanceUpdate(
4218                 state,
4219                 args.accountOne,
4220                 args.market,
4221                 deltaWei
4222             ),
4223             getBalanceUpdate(
4224                 state,
4225                 args.accountTwo,
4226                 args.market,
4227                 deltaWei.negative()
4228             )
4229         );
4230     }
4231 
4232     function logBuy(
4233         Storage.State storage state,
4234         Actions.BuyArgs memory args,
4235         Types.Wei memory takerWei,
4236         Types.Wei memory makerWei
4237     )
4238         internal
4239     {
4240         emit LogBuy(
4241             args.account.owner,
4242             args.account.number,
4243             args.takerMarket,
4244             args.makerMarket,
4245             getBalanceUpdate(
4246                 state,
4247                 args.account,
4248                 args.takerMarket,
4249                 takerWei
4250             ),
4251             getBalanceUpdate(
4252                 state,
4253                 args.account,
4254                 args.makerMarket,
4255                 makerWei
4256             ),
4257             args.exchangeWrapper
4258         );
4259     }
4260 
4261     function logSell(
4262         Storage.State storage state,
4263         Actions.SellArgs memory args,
4264         Types.Wei memory takerWei,
4265         Types.Wei memory makerWei
4266     )
4267         internal
4268     {
4269         emit LogSell(
4270             args.account.owner,
4271             args.account.number,
4272             args.takerMarket,
4273             args.makerMarket,
4274             getBalanceUpdate(
4275                 state,
4276                 args.account,
4277                 args.takerMarket,
4278                 takerWei
4279             ),
4280             getBalanceUpdate(
4281                 state,
4282                 args.account,
4283                 args.makerMarket,
4284                 makerWei
4285             ),
4286             args.exchangeWrapper
4287         );
4288     }
4289 
4290     function logTrade(
4291         Storage.State storage state,
4292         Actions.TradeArgs memory args,
4293         Types.Wei memory inputWei,
4294         Types.Wei memory outputWei
4295     )
4296         internal
4297     {
4298         BalanceUpdate[4] memory updates = [
4299             getBalanceUpdate(
4300                 state,
4301                 args.takerAccount,
4302                 args.inputMarket,
4303                 inputWei.negative()
4304             ),
4305             getBalanceUpdate(
4306                 state,
4307                 args.takerAccount,
4308                 args.outputMarket,
4309                 outputWei.negative()
4310             ),
4311             getBalanceUpdate(
4312                 state,
4313                 args.makerAccount,
4314                 args.inputMarket,
4315                 inputWei
4316             ),
4317             getBalanceUpdate(
4318                 state,
4319                 args.makerAccount,
4320                 args.outputMarket,
4321                 outputWei
4322             )
4323         ];
4324 
4325         emit LogTrade(
4326             args.takerAccount.owner,
4327             args.takerAccount.number,
4328             args.makerAccount.owner,
4329             args.makerAccount.number,
4330             args.inputMarket,
4331             args.outputMarket,
4332             updates[0],
4333             updates[1],
4334             updates[2],
4335             updates[3],
4336             args.autoTrader
4337         );
4338     }
4339 
4340     function logCall(
4341         Actions.CallArgs memory args
4342     )
4343         internal
4344     {
4345         emit LogCall(
4346             args.account.owner,
4347             args.account.number,
4348             args.callee
4349         );
4350     }
4351 
4352     function logLiquidate(
4353         Storage.State storage state,
4354         Actions.LiquidateArgs memory args,
4355         Types.Wei memory heldWei,
4356         Types.Wei memory owedWei
4357     )
4358         internal
4359     {
4360         BalanceUpdate memory solidHeldUpdate = getBalanceUpdate(
4361             state,
4362             args.solidAccount,
4363             args.heldMarket,
4364             heldWei.negative()
4365         );
4366         BalanceUpdate memory solidOwedUpdate = getBalanceUpdate(
4367             state,
4368             args.solidAccount,
4369             args.owedMarket,
4370             owedWei.negative()
4371         );
4372         BalanceUpdate memory liquidHeldUpdate = getBalanceUpdate(
4373             state,
4374             args.liquidAccount,
4375             args.heldMarket,
4376             heldWei
4377         );
4378         BalanceUpdate memory liquidOwedUpdate = getBalanceUpdate(
4379             state,
4380             args.liquidAccount,
4381             args.owedMarket,
4382             owedWei
4383         );
4384 
4385         emit LogLiquidate(
4386             args.solidAccount.owner,
4387             args.solidAccount.number,
4388             args.liquidAccount.owner,
4389             args.liquidAccount.number,
4390             args.heldMarket,
4391             args.owedMarket,
4392             solidHeldUpdate,
4393             solidOwedUpdate,
4394             liquidHeldUpdate,
4395             liquidOwedUpdate
4396         );
4397     }
4398 
4399     function logVaporize(
4400         Storage.State storage state,
4401         Actions.VaporizeArgs memory args,
4402         Types.Wei memory heldWei,
4403         Types.Wei memory owedWei,
4404         Types.Wei memory excessWei
4405     )
4406         internal
4407     {
4408         BalanceUpdate memory solidHeldUpdate = getBalanceUpdate(
4409             state,
4410             args.solidAccount,
4411             args.heldMarket,
4412             heldWei.negative()
4413         );
4414         BalanceUpdate memory solidOwedUpdate = getBalanceUpdate(
4415             state,
4416             args.solidAccount,
4417             args.owedMarket,
4418             owedWei.negative()
4419         );
4420         BalanceUpdate memory vaporOwedUpdate = getBalanceUpdate(
4421             state,
4422             args.vaporAccount,
4423             args.owedMarket,
4424             owedWei.add(excessWei)
4425         );
4426 
4427         emit LogVaporize(
4428             args.solidAccount.owner,
4429             args.solidAccount.number,
4430             args.vaporAccount.owner,
4431             args.vaporAccount.number,
4432             args.heldMarket,
4433             args.owedMarket,
4434             solidHeldUpdate,
4435             solidOwedUpdate,
4436             vaporOwedUpdate
4437         );
4438     }
4439 
4440     // ============ Private Functions ============
4441 
4442     function getBalanceUpdate(
4443         Storage.State storage state,
4444         Account.Info memory account,
4445         uint256 market,
4446         Types.Wei memory deltaWei
4447     )
4448         private
4449         view
4450         returns (BalanceUpdate memory)
4451     {
4452         return BalanceUpdate({
4453             deltaWei: deltaWei,
4454             newPar: state.getPar(account, market)
4455         });
4456     }
4457 }
4458 
4459 // File: contracts/protocol/interfaces/IExchangeWrapper.sol
4460 
4461 /**
4462  * @title IExchangeWrapper
4463  * @author dYdX
4464  *
4465  * Interface that Exchange Wrappers for Solo must implement in order to trade ERC20 tokens.
4466  */
4467 interface IExchangeWrapper {
4468 
4469     // ============ Public Functions ============
4470 
4471     /**
4472      * Exchange some amount of takerToken for makerToken.
4473      *
4474      * @param  tradeOriginator      Address of the initiator of the trade (however, this value
4475      *                              cannot always be trusted as it is set at the discretion of the
4476      *                              msg.sender)
4477      * @param  receiver             Address to set allowance on once the trade has completed
4478      * @param  makerToken           Address of makerToken, the token to receive
4479      * @param  takerToken           Address of takerToken, the token to pay
4480      * @param  requestedFillAmount  Amount of takerToken being paid
4481      * @param  orderData            Arbitrary bytes data for any information to pass to the exchange
4482      * @return                      The amount of makerToken received
4483      */
4484     function exchange(
4485         address tradeOriginator,
4486         address receiver,
4487         address makerToken,
4488         address takerToken,
4489         uint256 requestedFillAmount,
4490         bytes calldata orderData
4491     )
4492         external
4493         returns (uint256);
4494 
4495     /**
4496      * Get amount of takerToken required to buy a certain amount of makerToken for a given trade.
4497      * Should match the takerToken amount used in exchangeForAmount. If the order cannot provide
4498      * exactly desiredMakerToken, then it must return the price to buy the minimum amount greater
4499      * than desiredMakerToken
4500      *
4501      * @param  makerToken         Address of makerToken, the token to receive
4502      * @param  takerToken         Address of takerToken, the token to pay
4503      * @param  desiredMakerToken  Amount of makerToken requested
4504      * @param  orderData          Arbitrary bytes data for any information to pass to the exchange
4505      * @return                    Amount of takerToken the needed to complete the exchange
4506      */
4507     function getExchangeCost(
4508         address makerToken,
4509         address takerToken,
4510         uint256 desiredMakerToken,
4511         bytes calldata orderData
4512     )
4513         external
4514         view
4515         returns (uint256);
4516 }
4517 
4518 // File: contracts/protocol/lib/Exchange.sol
4519 
4520 /**
4521  * @title Exchange
4522  * @author dYdX
4523  *
4524  * Library for transferring tokens and interacting with ExchangeWrappers by using the Wei struct
4525  */
4526 library Exchange {
4527     using Types for Types.Wei;
4528 
4529     // ============ Constants ============
4530 
4531     bytes32 constant FILE = "Exchange";
4532 
4533     // ============ Library Functions ============
4534 
4535     function transferOut(
4536         address token,
4537         address to,
4538         Types.Wei memory deltaWei
4539     )
4540         internal
4541     {
4542         Require.that(
4543             !deltaWei.isPositive(),
4544             FILE,
4545             "Cannot transferOut positive",
4546             deltaWei.value
4547         );
4548 
4549         Token.transfer(
4550             token,
4551             to,
4552             deltaWei.value
4553         );
4554     }
4555 
4556     function transferIn(
4557         address token,
4558         address from,
4559         Types.Wei memory deltaWei
4560     )
4561         internal
4562     {
4563         Require.that(
4564             !deltaWei.isNegative(),
4565             FILE,
4566             "Cannot transferIn negative",
4567             deltaWei.value
4568         );
4569 
4570         Token.transferFrom(
4571             token,
4572             from,
4573             address(this),
4574             deltaWei.value
4575         );
4576     }
4577 
4578     function getCost(
4579         address exchangeWrapper,
4580         address supplyToken,
4581         address borrowToken,
4582         Types.Wei memory desiredAmount,
4583         bytes memory orderData
4584     )
4585         internal
4586         view
4587         returns (Types.Wei memory)
4588     {
4589         Require.that(
4590             !desiredAmount.isNegative(),
4591             FILE,
4592             "Cannot getCost negative",
4593             desiredAmount.value
4594         );
4595 
4596         Types.Wei memory result;
4597         result.sign = false;
4598         result.value = IExchangeWrapper(exchangeWrapper).getExchangeCost(
4599             supplyToken,
4600             borrowToken,
4601             desiredAmount.value,
4602             orderData
4603         );
4604 
4605         return result;
4606     }
4607 
4608     function exchange(
4609         address exchangeWrapper,
4610         address accountOwner,
4611         address supplyToken,
4612         address borrowToken,
4613         Types.Wei memory requestedFillAmount,
4614         bytes memory orderData
4615     )
4616         internal
4617         returns (Types.Wei memory)
4618     {
4619         Require.that(
4620             !requestedFillAmount.isPositive(),
4621             FILE,
4622             "Cannot exchange positive",
4623             requestedFillAmount.value
4624         );
4625 
4626         transferOut(borrowToken, exchangeWrapper, requestedFillAmount);
4627 
4628         Types.Wei memory result;
4629         result.sign = true;
4630         result.value = IExchangeWrapper(exchangeWrapper).exchange(
4631             accountOwner,
4632             address(this),
4633             supplyToken,
4634             borrowToken,
4635             requestedFillAmount.value,
4636             orderData
4637         );
4638 
4639         transferIn(supplyToken, exchangeWrapper, result);
4640 
4641         return result;
4642     }
4643 }
4644 
4645 // File: contracts/protocol/impl/OperationImpl.sol
4646 
4647 /**
4648  * @title OperationImpl
4649  * @author dYdX
4650  *
4651  * Logic for processing actions
4652  */
4653 library OperationImpl {
4654     using Cache for Cache.MarketCache;
4655     using SafeMath for uint256;
4656     using Storage for Storage.State;
4657     using Types for Types.Par;
4658     using Types for Types.Wei;
4659 
4660     // ============ Constants ============
4661 
4662     bytes32 constant FILE = "OperationImpl";
4663 
4664     // ============ Public Functions ============
4665 
4666     function operate(
4667         Storage.State storage state,
4668         Account.Info[] memory accounts,
4669         Actions.ActionArgs[] memory actions
4670     )
4671         public
4672     {
4673         Events.logOperation();
4674 
4675         _verifyInputs(accounts, actions);
4676 
4677         (
4678             bool[] memory primaryAccounts,
4679             Cache.MarketCache memory cache
4680         ) = _runPreprocessing(
4681             state,
4682             accounts,
4683             actions
4684         );
4685 
4686         _runActions(
4687             state,
4688             accounts,
4689             actions,
4690             cache
4691         );
4692 
4693         _verifyFinalState(
4694             state,
4695             accounts,
4696             primaryAccounts,
4697             cache
4698         );
4699     }
4700 
4701     // ============ Helper Functions ============
4702 
4703     function _verifyInputs(
4704         Account.Info[] memory accounts,
4705         Actions.ActionArgs[] memory actions
4706     )
4707         private
4708         pure
4709     {
4710         Require.that(
4711             actions.length != 0,
4712             FILE,
4713             "Cannot have zero actions"
4714         );
4715 
4716         Require.that(
4717             accounts.length != 0,
4718             FILE,
4719             "Cannot have zero accounts"
4720         );
4721 
4722         for (uint256 a = 0; a < accounts.length; a++) {
4723             for (uint256 b = a + 1; b < accounts.length; b++) {
4724                 Require.that(
4725                     !Account.equals(accounts[a], accounts[b]),
4726                     FILE,
4727                     "Cannot duplicate accounts",
4728                     a,
4729                     b
4730                 );
4731             }
4732         }
4733     }
4734 
4735     function _runPreprocessing(
4736         Storage.State storage state,
4737         Account.Info[] memory accounts,
4738         Actions.ActionArgs[] memory actions
4739     )
4740         private
4741         returns (
4742             bool[] memory,
4743             Cache.MarketCache memory
4744         )
4745     {
4746         uint256 numMarkets = state.numMarkets;
4747         bool[] memory primaryAccounts = new bool[](accounts.length);
4748         Cache.MarketCache memory cache = Cache.create(numMarkets);
4749 
4750         // keep track of primary accounts and indexes that need updating
4751         for (uint256 i = 0; i < actions.length; i++) {
4752             Actions.ActionArgs memory arg = actions[i];
4753             Actions.ActionType actionType = arg.actionType;
4754             Actions.MarketLayout marketLayout = Actions.getMarketLayout(actionType);
4755             Actions.AccountLayout accountLayout = Actions.getAccountLayout(actionType);
4756 
4757             // parse out primary accounts
4758             if (accountLayout != Actions.AccountLayout.OnePrimary) {
4759                 Require.that(
4760                     arg.accountId != arg.otherAccountId,
4761                     FILE,
4762                     "Duplicate accounts in action",
4763                     i
4764                 );
4765                 if (accountLayout == Actions.AccountLayout.TwoPrimary) {
4766                     primaryAccounts[arg.otherAccountId] = true;
4767                 } else {
4768                     assert(accountLayout == Actions.AccountLayout.PrimaryAndSecondary);
4769                     Require.that(
4770                         !primaryAccounts[arg.otherAccountId],
4771                         FILE,
4772                         "Requires non-primary account",
4773                         arg.otherAccountId
4774                     );
4775                 }
4776             }
4777             primaryAccounts[arg.accountId] = true;
4778 
4779             // keep track of indexes to update
4780             if (marketLayout == Actions.MarketLayout.OneMarket) {
4781                 _updateMarket(state, cache, arg.primaryMarketId);
4782             } else if (marketLayout == Actions.MarketLayout.TwoMarkets) {
4783                 Require.that(
4784                     arg.primaryMarketId != arg.secondaryMarketId,
4785                     FILE,
4786                     "Duplicate markets in action",
4787                     i
4788                 );
4789                 _updateMarket(state, cache, arg.primaryMarketId);
4790                 _updateMarket(state, cache, arg.secondaryMarketId);
4791             } else {
4792                 assert(marketLayout == Actions.MarketLayout.ZeroMarkets);
4793             }
4794         }
4795 
4796         // get any other markets for which an account has a balance
4797         for (uint256 m = 0; m < numMarkets; m++) {
4798             if (cache.hasMarket(m)) {
4799                 continue;
4800             }
4801             for (uint256 a = 0; a < accounts.length; a++) {
4802                 if (!state.getPar(accounts[a], m).isZero()) {
4803                     _updateMarket(state, cache, m);
4804                     break;
4805                 }
4806             }
4807         }
4808 
4809         return (primaryAccounts, cache);
4810     }
4811 
4812     function _updateMarket(
4813         Storage.State storage state,
4814         Cache.MarketCache memory cache,
4815         uint256 marketId
4816     )
4817         private
4818     {
4819         bool updated = cache.addMarket(state, marketId);
4820         if (updated) {
4821             Events.logIndexUpdate(marketId, state.updateIndex(marketId));
4822         }
4823     }
4824 
4825     function _runActions(
4826         Storage.State storage state,
4827         Account.Info[] memory accounts,
4828         Actions.ActionArgs[] memory actions,
4829         Cache.MarketCache memory cache
4830     )
4831         private
4832     {
4833         for (uint256 i = 0; i < actions.length; i++) {
4834             Actions.ActionArgs memory action = actions[i];
4835             Actions.ActionType actionType = action.actionType;
4836 
4837             if (actionType == Actions.ActionType.Deposit) {
4838                 _deposit(state, Actions.parseDepositArgs(accounts, action));
4839             }
4840             else if (actionType == Actions.ActionType.Withdraw) {
4841                 _withdraw(state, Actions.parseWithdrawArgs(accounts, action));
4842             }
4843             else if (actionType == Actions.ActionType.Transfer) {
4844                 _transfer(state, Actions.parseTransferArgs(accounts, action));
4845             }
4846             else if (actionType == Actions.ActionType.Buy) {
4847                 _buy(state, Actions.parseBuyArgs(accounts, action));
4848             }
4849             else if (actionType == Actions.ActionType.Sell) {
4850                 _sell(state, Actions.parseSellArgs(accounts, action));
4851             }
4852             else if (actionType == Actions.ActionType.Trade) {
4853                 _trade(state, Actions.parseTradeArgs(accounts, action));
4854             }
4855             else if (actionType == Actions.ActionType.Liquidate) {
4856                 _liquidate(state, Actions.parseLiquidateArgs(accounts, action), cache);
4857             }
4858             else if (actionType == Actions.ActionType.Vaporize) {
4859                 _vaporize(state, Actions.parseVaporizeArgs(accounts, action), cache);
4860             }
4861             else  {
4862                 assert(actionType == Actions.ActionType.Call);
4863                 _call(state, Actions.parseCallArgs(accounts, action));
4864             }
4865         }
4866     }
4867 
4868     function _verifyFinalState(
4869         Storage.State storage state,
4870         Account.Info[] memory accounts,
4871         bool[] memory primaryAccounts,
4872         Cache.MarketCache memory cache
4873     )
4874         private
4875     {
4876         // verify no increase in borrowPar for closing markets
4877         uint256 numMarkets = cache.getNumMarkets();
4878         for (uint256 m = 0; m < numMarkets; m++) {
4879             if (cache.getIsClosing(m)) {
4880                 Require.that(
4881                     state.getTotalPar(m).borrow <= cache.getBorrowPar(m),
4882                     FILE,
4883                     "Market is closing",
4884                     m
4885                 );
4886             }
4887         }
4888 
4889         // verify account collateralization
4890         for (uint256 a = 0; a < accounts.length; a++) {
4891             Account.Info memory account = accounts[a];
4892 
4893             // validate minBorrowedValue
4894             bool collateralized = state.isCollateralized(account, cache, true);
4895 
4896             // don't check collateralization for non-primary accounts
4897             if (!primaryAccounts[a]) {
4898                 continue;
4899             }
4900 
4901             // check collateralization for primary accounts
4902             Require.that(
4903                 collateralized,
4904                 FILE,
4905                 "Undercollateralized account",
4906                 account.owner,
4907                 account.number
4908             );
4909 
4910             // ensure status is normal for primary accounts
4911             if (state.getStatus(account) != Account.Status.Normal) {
4912                 state.setStatus(account, Account.Status.Normal);
4913             }
4914         }
4915     }
4916 
4917     // ============ Action Functions ============
4918 
4919     function _deposit(
4920         Storage.State storage state,
4921         Actions.DepositArgs memory args
4922     )
4923         private
4924     {
4925         state.requireIsOperator(args.account, msg.sender);
4926 
4927         Require.that(
4928             args.from == msg.sender || args.from == args.account.owner,
4929             FILE,
4930             "Invalid deposit source",
4931             args.from
4932         );
4933 
4934         (
4935             Types.Par memory newPar,
4936             Types.Wei memory deltaWei
4937         ) = state.getNewParAndDeltaWei(
4938             args.account,
4939             args.market,
4940             args.amount
4941         );
4942 
4943         state.setPar(
4944             args.account,
4945             args.market,
4946             newPar
4947         );
4948 
4949         // requires a positive deltaWei
4950         Exchange.transferIn(
4951             state.getToken(args.market),
4952             args.from,
4953             deltaWei
4954         );
4955 
4956         Events.logDeposit(
4957             state,
4958             args,
4959             deltaWei
4960         );
4961     }
4962 
4963     function _withdraw(
4964         Storage.State storage state,
4965         Actions.WithdrawArgs memory args
4966     )
4967         private
4968     {
4969         state.requireIsOperator(args.account, msg.sender);
4970 
4971         (
4972             Types.Par memory newPar,
4973             Types.Wei memory deltaWei
4974         ) = state.getNewParAndDeltaWei(
4975             args.account,
4976             args.market,
4977             args.amount
4978         );
4979 
4980         state.setPar(
4981             args.account,
4982             args.market,
4983             newPar
4984         );
4985 
4986         // requires a negative deltaWei
4987         Exchange.transferOut(
4988             state.getToken(args.market),
4989             args.to,
4990             deltaWei
4991         );
4992 
4993         Events.logWithdraw(
4994             state,
4995             args,
4996             deltaWei
4997         );
4998     }
4999 
5000     function _transfer(
5001         Storage.State storage state,
5002         Actions.TransferArgs memory args
5003     )
5004         private
5005     {
5006         state.requireIsOperator(args.accountOne, msg.sender);
5007         state.requireIsOperator(args.accountTwo, msg.sender);
5008 
5009         (
5010             Types.Par memory newPar,
5011             Types.Wei memory deltaWei
5012         ) = state.getNewParAndDeltaWei(
5013             args.accountOne,
5014             args.market,
5015             args.amount
5016         );
5017 
5018         state.setPar(
5019             args.accountOne,
5020             args.market,
5021             newPar
5022         );
5023 
5024         state.setParFromDeltaWei(
5025             args.accountTwo,
5026             args.market,
5027             deltaWei.negative()
5028         );
5029 
5030         Events.logTransfer(
5031             state,
5032             args,
5033             deltaWei
5034         );
5035     }
5036 
5037     function _buy(
5038         Storage.State storage state,
5039         Actions.BuyArgs memory args
5040     )
5041         private
5042     {
5043         state.requireIsOperator(args.account, msg.sender);
5044 
5045         address takerToken = state.getToken(args.takerMarket);
5046         address makerToken = state.getToken(args.makerMarket);
5047 
5048         (
5049             Types.Par memory makerPar,
5050             Types.Wei memory makerWei
5051         ) = state.getNewParAndDeltaWei(
5052             args.account,
5053             args.makerMarket,
5054             args.amount
5055         );
5056 
5057         Types.Wei memory takerWei = Exchange.getCost(
5058             args.exchangeWrapper,
5059             makerToken,
5060             takerToken,
5061             makerWei,
5062             args.orderData
5063         );
5064 
5065         Types.Wei memory tokensReceived = Exchange.exchange(
5066             args.exchangeWrapper,
5067             args.account.owner,
5068             makerToken,
5069             takerToken,
5070             takerWei,
5071             args.orderData
5072         );
5073 
5074         Require.that(
5075             tokensReceived.value >= makerWei.value,
5076             FILE,
5077             "Buy amount less than promised",
5078             tokensReceived.value,
5079             makerWei.value
5080         );
5081 
5082         state.setPar(
5083             args.account,
5084             args.makerMarket,
5085             makerPar
5086         );
5087 
5088         state.setParFromDeltaWei(
5089             args.account,
5090             args.takerMarket,
5091             takerWei
5092         );
5093 
5094         Events.logBuy(
5095             state,
5096             args,
5097             takerWei,
5098             makerWei
5099         );
5100     }
5101 
5102     function _sell(
5103         Storage.State storage state,
5104         Actions.SellArgs memory args
5105     )
5106         private
5107     {
5108         state.requireIsOperator(args.account, msg.sender);
5109 
5110         address takerToken = state.getToken(args.takerMarket);
5111         address makerToken = state.getToken(args.makerMarket);
5112 
5113         (
5114             Types.Par memory takerPar,
5115             Types.Wei memory takerWei
5116         ) = state.getNewParAndDeltaWei(
5117             args.account,
5118             args.takerMarket,
5119             args.amount
5120         );
5121 
5122         Types.Wei memory makerWei = Exchange.exchange(
5123             args.exchangeWrapper,
5124             args.account.owner,
5125             makerToken,
5126             takerToken,
5127             takerWei,
5128             args.orderData
5129         );
5130 
5131         state.setPar(
5132             args.account,
5133             args.takerMarket,
5134             takerPar
5135         );
5136 
5137         state.setParFromDeltaWei(
5138             args.account,
5139             args.makerMarket,
5140             makerWei
5141         );
5142 
5143         Events.logSell(
5144             state,
5145             args,
5146             takerWei,
5147             makerWei
5148         );
5149     }
5150 
5151     function _trade(
5152         Storage.State storage state,
5153         Actions.TradeArgs memory args
5154     )
5155         private
5156     {
5157         state.requireIsOperator(args.takerAccount, msg.sender);
5158         state.requireIsOperator(args.makerAccount, args.autoTrader);
5159 
5160         Types.Par memory oldInputPar = state.getPar(
5161             args.makerAccount,
5162             args.inputMarket
5163         );
5164         (
5165             Types.Par memory newInputPar,
5166             Types.Wei memory inputWei
5167         ) = state.getNewParAndDeltaWei(
5168             args.makerAccount,
5169             args.inputMarket,
5170             args.amount
5171         );
5172 
5173         Types.AssetAmount memory outputAmount = IAutoTrader(args.autoTrader).getTradeCost(
5174             args.inputMarket,
5175             args.outputMarket,
5176             args.makerAccount,
5177             args.takerAccount,
5178             oldInputPar,
5179             newInputPar,
5180             inputWei,
5181             args.tradeData
5182         );
5183 
5184         (
5185             Types.Par memory newOutputPar,
5186             Types.Wei memory outputWei
5187         ) = state.getNewParAndDeltaWei(
5188             args.makerAccount,
5189             args.outputMarket,
5190             outputAmount
5191         );
5192 
5193         Require.that(
5194             outputWei.isZero() || inputWei.isZero() || outputWei.sign != inputWei.sign,
5195             FILE,
5196             "Trades cannot be one-sided"
5197         );
5198 
5199         // set the balance for the maker
5200         state.setPar(
5201             args.makerAccount,
5202             args.inputMarket,
5203             newInputPar
5204         );
5205         state.setPar(
5206             args.makerAccount,
5207             args.outputMarket,
5208             newOutputPar
5209         );
5210 
5211         // set the balance for the taker
5212         state.setParFromDeltaWei(
5213             args.takerAccount,
5214             args.inputMarket,
5215             inputWei.negative()
5216         );
5217         state.setParFromDeltaWei(
5218             args.takerAccount,
5219             args.outputMarket,
5220             outputWei.negative()
5221         );
5222 
5223         Events.logTrade(
5224             state,
5225             args,
5226             inputWei,
5227             outputWei
5228         );
5229     }
5230 
5231     function _liquidate(
5232         Storage.State storage state,
5233         Actions.LiquidateArgs memory args,
5234         Cache.MarketCache memory cache
5235     )
5236         private
5237     {
5238         state.requireIsOperator(args.solidAccount, msg.sender);
5239 
5240         // verify liquidatable
5241         if (Account.Status.Liquid != state.getStatus(args.liquidAccount)) {
5242             Require.that(
5243                 !state.isCollateralized(args.liquidAccount, cache, /* requireMinBorrow = */ false),
5244                 FILE,
5245                 "Unliquidatable account",
5246                 args.liquidAccount.owner,
5247                 args.liquidAccount.number
5248             );
5249             state.setStatus(args.liquidAccount, Account.Status.Liquid);
5250         }
5251 
5252         Types.Wei memory maxHeldWei = state.getWei(
5253             args.liquidAccount,
5254             args.heldMarket
5255         );
5256 
5257         Require.that(
5258             !maxHeldWei.isNegative(),
5259             FILE,
5260             "Collateral cannot be negative",
5261             args.liquidAccount.owner,
5262             args.liquidAccount.number,
5263             args.heldMarket
5264         );
5265 
5266         (
5267             Types.Par memory owedPar,
5268             Types.Wei memory owedWei
5269         ) = state.getNewParAndDeltaWeiForLiquidation(
5270             args.liquidAccount,
5271             args.owedMarket,
5272             args.amount
5273         );
5274 
5275         (
5276             Monetary.Price memory heldPrice,
5277             Monetary.Price memory owedPrice
5278         ) = _getLiquidationPrices(
5279             state,
5280             cache,
5281             args.heldMarket,
5282             args.owedMarket
5283         );
5284 
5285         Types.Wei memory heldWei = _owedWeiToHeldWei(owedWei, heldPrice, owedPrice);
5286 
5287         // if attempting to over-borrow the held asset, bound it by the maximum
5288         if (heldWei.value > maxHeldWei.value) {
5289             heldWei = maxHeldWei.negative();
5290             owedWei = _heldWeiToOwedWei(heldWei, heldPrice, owedPrice);
5291 
5292             state.setPar(
5293                 args.liquidAccount,
5294                 args.heldMarket,
5295                 Types.zeroPar()
5296             );
5297             state.setParFromDeltaWei(
5298                 args.liquidAccount,
5299                 args.owedMarket,
5300                 owedWei
5301             );
5302         } else {
5303             state.setPar(
5304                 args.liquidAccount,
5305                 args.owedMarket,
5306                 owedPar
5307             );
5308             state.setParFromDeltaWei(
5309                 args.liquidAccount,
5310                 args.heldMarket,
5311                 heldWei
5312             );
5313         }
5314 
5315         // set the balances for the solid account
5316         state.setParFromDeltaWei(
5317             args.solidAccount,
5318             args.owedMarket,
5319             owedWei.negative()
5320         );
5321         state.setParFromDeltaWei(
5322             args.solidAccount,
5323             args.heldMarket,
5324             heldWei.negative()
5325         );
5326 
5327         Events.logLiquidate(
5328             state,
5329             args,
5330             heldWei,
5331             owedWei
5332         );
5333     }
5334 
5335     function _vaporize(
5336         Storage.State storage state,
5337         Actions.VaporizeArgs memory args,
5338         Cache.MarketCache memory cache
5339     )
5340         private
5341     {
5342         state.requireIsOperator(args.solidAccount, msg.sender);
5343 
5344         // verify vaporizable
5345         if (Account.Status.Vapor != state.getStatus(args.vaporAccount)) {
5346             Require.that(
5347                 state.isVaporizable(args.vaporAccount, cache),
5348                 FILE,
5349                 "Unvaporizable account",
5350                 args.vaporAccount.owner,
5351                 args.vaporAccount.number
5352             );
5353             state.setStatus(args.vaporAccount, Account.Status.Vapor);
5354         }
5355 
5356         // First, attempt to refund using the same token
5357         (
5358             bool fullyRepaid,
5359             Types.Wei memory excessWei
5360         ) = _vaporizeUsingExcess(state, args);
5361         if (fullyRepaid) {
5362             Events.logVaporize(
5363                 state,
5364                 args,
5365                 Types.zeroWei(),
5366                 Types.zeroWei(),
5367                 excessWei
5368             );
5369             return;
5370         }
5371 
5372         Types.Wei memory maxHeldWei = state.getNumExcessTokens(args.heldMarket);
5373 
5374         Require.that(
5375             !maxHeldWei.isNegative(),
5376             FILE,
5377             "Excess cannot be negative",
5378             args.heldMarket
5379         );
5380 
5381         (
5382             Types.Par memory owedPar,
5383             Types.Wei memory owedWei
5384         ) = state.getNewParAndDeltaWeiForLiquidation(
5385             args.vaporAccount,
5386             args.owedMarket,
5387             args.amount
5388         );
5389 
5390         (
5391             Monetary.Price memory heldPrice,
5392             Monetary.Price memory owedPrice
5393         ) = _getLiquidationPrices(
5394             state,
5395             cache,
5396             args.heldMarket,
5397             args.owedMarket
5398         );
5399 
5400         Types.Wei memory heldWei = _owedWeiToHeldWei(owedWei, heldPrice, owedPrice);
5401 
5402         // if attempting to over-borrow the held asset, bound it by the maximum
5403         if (heldWei.value > maxHeldWei.value) {
5404             heldWei = maxHeldWei.negative();
5405             owedWei = _heldWeiToOwedWei(heldWei, heldPrice, owedPrice);
5406 
5407             state.setParFromDeltaWei(
5408                 args.vaporAccount,
5409                 args.owedMarket,
5410                 owedWei
5411             );
5412         } else {
5413             state.setPar(
5414                 args.vaporAccount,
5415                 args.owedMarket,
5416                 owedPar
5417             );
5418         }
5419 
5420         // set the balances for the solid account
5421         state.setParFromDeltaWei(
5422             args.solidAccount,
5423             args.owedMarket,
5424             owedWei.negative()
5425         );
5426         state.setParFromDeltaWei(
5427             args.solidAccount,
5428             args.heldMarket,
5429             heldWei.negative()
5430         );
5431 
5432         Events.logVaporize(
5433             state,
5434             args,
5435             heldWei,
5436             owedWei,
5437             excessWei
5438         );
5439     }
5440 
5441     function _call(
5442         Storage.State storage state,
5443         Actions.CallArgs memory args
5444     )
5445         private
5446     {
5447         state.requireIsOperator(args.account, msg.sender);
5448 
5449         ICallee(args.callee).callFunction(
5450             msg.sender,
5451             args.account,
5452             args.data
5453         );
5454 
5455         Events.logCall(args);
5456     }
5457 
5458     // ============ Private Functions ============
5459 
5460     /**
5461      * For the purposes of liquidation or vaporization, get the value-equivalent amount of heldWei
5462      * given owedWei and the (spread-adjusted) prices of each asset.
5463      */
5464     function _owedWeiToHeldWei(
5465         Types.Wei memory owedWei,
5466         Monetary.Price memory heldPrice,
5467         Monetary.Price memory owedPrice
5468     )
5469         private
5470         pure
5471         returns (Types.Wei memory)
5472     {
5473         return Types.Wei({
5474             sign: false,
5475             value: Math.getPartial(owedWei.value, owedPrice.value, heldPrice.value)
5476         });
5477     }
5478 
5479     /**
5480      * For the purposes of liquidation or vaporization, get the value-equivalent amount of owedWei
5481      * given heldWei and the (spread-adjusted) prices of each asset.
5482      */
5483     function _heldWeiToOwedWei(
5484         Types.Wei memory heldWei,
5485         Monetary.Price memory heldPrice,
5486         Monetary.Price memory owedPrice
5487     )
5488         private
5489         pure
5490         returns (Types.Wei memory)
5491     {
5492         return Types.Wei({
5493             sign: true,
5494             value: Math.getPartialRoundUp(heldWei.value, heldPrice.value, owedPrice.value)
5495         });
5496     }
5497 
5498     /**
5499      * Attempt to vaporize an account's balance using the excess tokens in the protocol. Return a
5500      * bool and a wei value. The boolean is true if and only if the balance was fully vaporized. The
5501      * Wei value is how many excess tokens were used to partially or fully vaporize the account's
5502      * negative balance.
5503      */
5504     function _vaporizeUsingExcess(
5505         Storage.State storage state,
5506         Actions.VaporizeArgs memory args
5507     )
5508         internal
5509         returns (bool, Types.Wei memory)
5510     {
5511         Types.Wei memory excessWei = state.getNumExcessTokens(args.owedMarket);
5512 
5513         // There are no excess funds, return zero
5514         if (!excessWei.isPositive()) {
5515             return (false, Types.zeroWei());
5516         }
5517 
5518         Types.Wei memory maxRefundWei = state.getWei(args.vaporAccount, args.owedMarket);
5519         maxRefundWei.sign = true;
5520 
5521         // The account is fully vaporizable using excess funds
5522         if (excessWei.value >= maxRefundWei.value) {
5523             state.setPar(
5524                 args.vaporAccount,
5525                 args.owedMarket,
5526                 Types.zeroPar()
5527             );
5528             return (true, maxRefundWei);
5529         }
5530 
5531         // The account is only partially vaporizable using excess funds
5532         else {
5533             state.setParFromDeltaWei(
5534                 args.vaporAccount,
5535                 args.owedMarket,
5536                 excessWei
5537             );
5538             return (false, excessWei);
5539         }
5540     }
5541 
5542     /**
5543      * Return the (spread-adjusted) prices of two assets for the purposes of liquidation or
5544      * vaporization.
5545      */
5546     function _getLiquidationPrices(
5547         Storage.State storage state,
5548         Cache.MarketCache memory cache,
5549         uint256 heldMarketId,
5550         uint256 owedMarketId
5551     )
5552         internal
5553         view
5554         returns (
5555             Monetary.Price memory,
5556             Monetary.Price memory
5557         )
5558     {
5559         uint256 originalPrice = cache.getPrice(owedMarketId).value;
5560         Decimal.D256 memory spread = state.getLiquidationSpreadForPair(
5561             heldMarketId,
5562             owedMarketId
5563         );
5564 
5565         Monetary.Price memory owedPrice = Monetary.Price({
5566             value: originalPrice.add(Decimal.mul(originalPrice, spread))
5567         });
5568 
5569         return (cache.getPrice(heldMarketId), owedPrice);
5570     }
5571 }
5572 
5573 // File: contracts/protocol/Operation.sol
5574 
5575 /**
5576  * @title Operation
5577  * @author dYdX
5578  *
5579  * Primary public function for allowing users and contracts to manage accounts within Solo
5580  */
5581 contract Operation is
5582     State,
5583     ReentrancyGuard
5584 {
5585     // ============ Public Functions ============
5586 
5587     /**
5588      * The main entry-point to Solo that allows users and contracts to manage accounts.
5589      * Take one or more actions on one or more accounts. The msg.sender must be the owner or
5590      * operator of all accounts except for those being liquidated, vaporized, or traded with.
5591      * One call to operate() is considered a singular "operation". Account collateralization is
5592      * ensured only after the completion of the entire operation.
5593      *
5594      * @param  accounts  A list of all accounts that will be used in this operation. Cannot contain
5595      *                   duplicates. In each action, the relevant account will be referred-to by its
5596      *                   index in the list.
5597      * @param  actions   An ordered list of all actions that will be taken in this operation. The
5598      *                   actions will be processed in order.
5599      */
5600     function operate(
5601         Account.Info[] memory accounts,
5602         Actions.ActionArgs[] memory actions
5603     )
5604         public
5605         nonReentrant
5606     {
5607         OperationImpl.operate(
5608             g_state,
5609             accounts,
5610             actions
5611         );
5612     }
5613 }
5614 
5615 // File: contracts/protocol/Permission.sol
5616 
5617 /**
5618  * @title Permission
5619  * @author dYdX
5620  *
5621  * Public function that allows other addresses to manage accounts
5622  */
5623 contract Permission is
5624     State
5625 {
5626     // ============ Events ============
5627 
5628     event LogOperatorSet(
5629         address indexed owner,
5630         address operator,
5631         bool trusted
5632     );
5633 
5634     // ============ Structs ============
5635 
5636     struct OperatorArg {
5637         address operator;
5638         bool trusted;
5639     }
5640 
5641     // ============ Public Functions ============
5642 
5643     /**
5644      * Approves/disapproves any number of operators. An operator is an external address that has the
5645      * same permissions to manipulate an account as the owner of the account. Operators are simply
5646      * addresses and therefore may either be externally-owned Ethereum accounts OR smart contracts.
5647      *
5648      * Operators are also able to act as AutoTrader contracts on behalf of the account owner if the
5649      * operator is a smart contract and implements the IAutoTrader interface.
5650      *
5651      * @param  args  A list of OperatorArgs which have an address and a boolean. The boolean value
5652      *               denotes whether to approve (true) or revoke approval (false) for that address.
5653      */
5654     function setOperators(
5655         OperatorArg[] memory args
5656     )
5657         public
5658     {
5659         for (uint256 i = 0; i < args.length; i++) {
5660             address operator = args[i].operator;
5661             bool trusted = args[i].trusted;
5662             g_state.operators[msg.sender][operator] = trusted;
5663             emit LogOperatorSet(msg.sender, operator, trusted);
5664         }
5665     }
5666 }
5667 
5668 // File: contracts/protocol/SoloMargin.sol
5669 
5670 /**
5671  * @title SoloMargin
5672  * @author dYdX
5673  *
5674  * Main contract that inherits from other contracts
5675  */
5676 contract SoloMargin is
5677     State,
5678     Admin,
5679     Getters,
5680     Operation,
5681     Permission
5682 {
5683     // ============ Constructor ============
5684 
5685     constructor(
5686         Storage.RiskParams memory riskParams,
5687         Storage.RiskLimits memory riskLimits
5688     )
5689         public
5690     {
5691         g_state.riskParams = riskParams;
5692         g_state.riskLimits = riskLimits;
5693     }
5694 }
5695 
5696 // File: contracts/external/helpers/OnlySolo.sol
5697 
5698 /**
5699  * @title OnlySolo
5700  * @author dYdX
5701  *
5702  * Inheritable contract that restricts the calling of certain functions to Solo only
5703  */
5704 contract OnlySolo {
5705 
5706     // ============ Constants ============
5707 
5708     bytes32 constant FILE = "OnlySolo";
5709 
5710     // ============ Storage ============
5711 
5712     SoloMargin public SOLO_MARGIN;
5713 
5714     // ============ Constructor ============
5715 
5716     constructor (
5717         address soloMargin
5718     )
5719         public
5720     {
5721         SOLO_MARGIN = SoloMargin(soloMargin);
5722     }
5723 
5724     // ============ Modifiers ============
5725 
5726     modifier onlySolo(address from) {
5727         Require.that(
5728             from == address(SOLO_MARGIN),
5729             FILE,
5730             "Only Solo can call function",
5731             from
5732         );
5733         _;
5734     }
5735 }
5736 
5737 // File: contracts/external/traders/Expiry.sol
5738 
5739 /**
5740  * @title Expiry
5741  * @author dYdX
5742  *
5743  * Sets the negative balance for an account to expire at a certain time. This allows any other
5744  * account to repay that negative balance after expiry using any positive balance in the same
5745  * account. The arbitrage incentive is the same as liquidation in the base protocol.
5746  */
5747 contract Expiry is
5748     Ownable,
5749     OnlySolo,
5750     ICallee,
5751     IAutoTrader
5752 {
5753     using SafeMath for uint32;
5754     using SafeMath for uint256;
5755     using Types for Types.Par;
5756     using Types for Types.Wei;
5757 
5758     // ============ Constants ============
5759 
5760     bytes32 constant FILE = "Expiry";
5761 
5762     // ============ Events ============
5763 
5764     event ExpirySet(
5765         address owner,
5766         uint256 number,
5767         uint256 marketId,
5768         uint32 time
5769     );
5770 
5771     event LogExpiryRampTimeSet(
5772         uint256 expiryRampTime
5773     );
5774 
5775     // ============ Storage ============
5776 
5777     // owner => number => market => time
5778     mapping (address => mapping (uint256 => mapping (uint256 => uint32))) g_expiries;
5779 
5780     // time over which the liquidation ratio goes from zero to maximum
5781     uint256 public g_expiryRampTime;
5782 
5783     // ============ Constructor ============
5784 
5785     constructor (
5786         address soloMargin,
5787         uint256 expiryRampTime
5788     )
5789         public
5790         OnlySolo(soloMargin)
5791     {
5792         g_expiryRampTime = expiryRampTime;
5793     }
5794 
5795     // ============ Owner Functions ============
5796 
5797     function ownerSetExpiryRampTime(
5798         uint256 newExpiryRampTime
5799     )
5800         external
5801         onlyOwner
5802     {
5803         emit LogExpiryRampTimeSet(newExpiryRampTime);
5804         g_expiryRampTime = newExpiryRampTime;
5805     }
5806 
5807     // ============ Getters ============
5808 
5809     function getExpiry(
5810         Account.Info memory account,
5811         uint256 marketId
5812     )
5813         public
5814         view
5815         returns (uint32)
5816     {
5817         return g_expiries[account.owner][account.number][marketId];
5818     }
5819 
5820     function getSpreadAdjustedPrices(
5821         uint256 heldMarketId,
5822         uint256 owedMarketId,
5823         uint32 expiry
5824     )
5825         public
5826         view
5827         returns (
5828             Monetary.Price memory,
5829             Monetary.Price memory
5830         )
5831     {
5832         Decimal.D256 memory spread = SOLO_MARGIN.getLiquidationSpreadForPair(
5833             heldMarketId,
5834             owedMarketId
5835         );
5836 
5837         uint256 expiryAge = Time.currentTime().sub(expiry);
5838 
5839         if (expiryAge < g_expiryRampTime) {
5840             spread.value = Math.getPartial(spread.value, expiryAge, g_expiryRampTime);
5841         }
5842 
5843         Monetary.Price memory heldPrice = SOLO_MARGIN.getMarketPrice(heldMarketId);
5844         Monetary.Price memory owedPrice = SOLO_MARGIN.getMarketPrice(owedMarketId);
5845         owedPrice.value = owedPrice.value.add(Decimal.mul(owedPrice.value, spread));
5846 
5847         return (heldPrice, owedPrice);
5848     }
5849 
5850     // ============ Only-Solo Functions ============
5851 
5852     function callFunction(
5853         address /* sender */,
5854         Account.Info memory account,
5855         bytes memory data
5856     )
5857         public
5858         onlySolo(msg.sender)
5859     {
5860         (
5861             uint256 marketId,
5862             uint32 expiryTime
5863         ) = parseCallArgs(data);
5864 
5865         // don't set expiry time for accounts with positive balance
5866         if (expiryTime != 0 && !SOLO_MARGIN.getAccountPar(account, marketId).isNegative()) {
5867             return;
5868         }
5869 
5870         setExpiry(account, marketId, expiryTime);
5871     }
5872 
5873     function getTradeCost(
5874         uint256 inputMarketId,
5875         uint256 outputMarketId,
5876         Account.Info memory makerAccount,
5877         Account.Info memory /* takerAccount */,
5878         Types.Par memory oldInputPar,
5879         Types.Par memory newInputPar,
5880         Types.Wei memory inputWei,
5881         bytes memory data
5882     )
5883         public
5884         onlySolo(msg.sender)
5885         returns (Types.AssetAmount memory)
5886     {
5887         // return zero if input amount is zero
5888         if (inputWei.isZero()) {
5889             return Types.AssetAmount({
5890                 sign: true,
5891                 denomination: Types.AssetDenomination.Par,
5892                 ref: Types.AssetReference.Delta,
5893                 value: 0
5894             });
5895         }
5896 
5897         (
5898             uint256 owedMarketId,
5899             uint32 maxExpiry
5900         ) = parseTradeArgs(data);
5901 
5902         uint32 expiry = getExpiry(makerAccount, owedMarketId);
5903 
5904         // validate expiry
5905         Require.that(
5906             expiry != 0,
5907             FILE,
5908             "Expiry not set",
5909             makerAccount.owner,
5910             makerAccount.number,
5911             owedMarketId
5912         );
5913         Require.that(
5914             expiry <= Time.currentTime(),
5915             FILE,
5916             "Borrow not yet expired",
5917             expiry
5918         );
5919         Require.that(
5920             expiry <= maxExpiry,
5921             FILE,
5922             "Expiry past maxExpiry",
5923             expiry
5924         );
5925 
5926         return getTradeCostInternal(
5927             inputMarketId,
5928             outputMarketId,
5929             makerAccount,
5930             oldInputPar,
5931             newInputPar,
5932             inputWei,
5933             owedMarketId,
5934             expiry
5935         );
5936     }
5937 
5938     // ============ Private Functions ============
5939 
5940     function getTradeCostInternal(
5941         uint256 inputMarketId,
5942         uint256 outputMarketId,
5943         Account.Info memory makerAccount,
5944         Types.Par memory oldInputPar,
5945         Types.Par memory newInputPar,
5946         Types.Wei memory inputWei,
5947         uint256 owedMarketId,
5948         uint32 expiry
5949     )
5950         private
5951         returns (Types.AssetAmount memory)
5952     {
5953         Types.AssetAmount memory output;
5954         Types.Wei memory maxOutputWei = SOLO_MARGIN.getAccountWei(makerAccount, outputMarketId);
5955 
5956         if (inputWei.isPositive()) {
5957             Require.that(
5958                 inputMarketId == owedMarketId,
5959                 FILE,
5960                 "inputMarket mismatch",
5961                 inputMarketId
5962             );
5963             Require.that(
5964                 !newInputPar.isPositive(),
5965                 FILE,
5966                 "Borrows cannot be overpaid",
5967                 newInputPar.value
5968             );
5969             assert(oldInputPar.isNegative());
5970             Require.that(
5971                 maxOutputWei.isPositive(),
5972                 FILE,
5973                 "Collateral must be positive",
5974                 outputMarketId,
5975                 maxOutputWei.value
5976             );
5977             output = owedWeiToHeldWei(
5978                 inputWei,
5979                 outputMarketId,
5980                 inputMarketId,
5981                 expiry
5982             );
5983 
5984             // clear expiry if borrow is fully repaid
5985             if (newInputPar.isZero()) {
5986                 setExpiry(makerAccount, owedMarketId, 0);
5987             }
5988         } else {
5989             Require.that(
5990                 outputMarketId == owedMarketId,
5991                 FILE,
5992                 "outputMarket mismatch",
5993                 outputMarketId
5994             );
5995             Require.that(
5996                 !newInputPar.isNegative(),
5997                 FILE,
5998                 "Collateral cannot be overused",
5999                 newInputPar.value
6000             );
6001             assert(oldInputPar.isPositive());
6002             Require.that(
6003                 maxOutputWei.isNegative(),
6004                 FILE,
6005                 "Borrows must be negative",
6006                 outputMarketId,
6007                 maxOutputWei.value
6008             );
6009             output = heldWeiToOwedWei(
6010                 inputWei,
6011                 inputMarketId,
6012                 outputMarketId,
6013                 expiry
6014             );
6015 
6016             // clear expiry if borrow is fully repaid
6017             if (output.value == maxOutputWei.value) {
6018                 setExpiry(makerAccount, owedMarketId, 0);
6019             }
6020         }
6021 
6022         Require.that(
6023             output.value <= maxOutputWei.value,
6024             FILE,
6025             "outputMarket too small",
6026             output.value,
6027             maxOutputWei.value
6028         );
6029         assert(output.sign != maxOutputWei.sign);
6030 
6031         return output;
6032     }
6033 
6034     function setExpiry(
6035         Account.Info memory account,
6036         uint256 marketId,
6037         uint32 time
6038     )
6039         private
6040     {
6041         g_expiries[account.owner][account.number][marketId] = time;
6042 
6043         emit ExpirySet(
6044             account.owner,
6045             account.number,
6046             marketId,
6047             time
6048         );
6049     }
6050 
6051     function heldWeiToOwedWei(
6052         Types.Wei memory heldWei,
6053         uint256 heldMarketId,
6054         uint256 owedMarketId,
6055         uint32 expiry
6056     )
6057         private
6058         view
6059         returns (Types.AssetAmount memory)
6060     {
6061         (
6062             Monetary.Price memory heldPrice,
6063             Monetary.Price memory owedPrice
6064         ) = getSpreadAdjustedPrices(
6065             heldMarketId,
6066             owedMarketId,
6067             expiry
6068         );
6069 
6070         uint256 owedAmount = Math.getPartialRoundUp(
6071             heldWei.value,
6072             heldPrice.value,
6073             owedPrice.value
6074         );
6075 
6076         return Types.AssetAmount({
6077             sign: true,
6078             denomination: Types.AssetDenomination.Wei,
6079             ref: Types.AssetReference.Delta,
6080             value: owedAmount
6081         });
6082     }
6083 
6084     function owedWeiToHeldWei(
6085         Types.Wei memory owedWei,
6086         uint256 heldMarketId,
6087         uint256 owedMarketId,
6088         uint32 expiry
6089     )
6090         private
6091         view
6092         returns (Types.AssetAmount memory)
6093     {
6094         (
6095             Monetary.Price memory heldPrice,
6096             Monetary.Price memory owedPrice
6097         ) = getSpreadAdjustedPrices(
6098             heldMarketId,
6099             owedMarketId,
6100             expiry
6101         );
6102 
6103         uint256 heldAmount = Math.getPartial(
6104             owedWei.value,
6105             owedPrice.value,
6106             heldPrice.value
6107         );
6108 
6109         return Types.AssetAmount({
6110             sign: false,
6111             denomination: Types.AssetDenomination.Wei,
6112             ref: Types.AssetReference.Delta,
6113             value: heldAmount
6114         });
6115     }
6116 
6117     function parseCallArgs(
6118         bytes memory data
6119     )
6120         private
6121         pure
6122         returns (
6123             uint256,
6124             uint32
6125         )
6126     {
6127         Require.that(
6128             data.length == 64,
6129             FILE,
6130             "Call data invalid length",
6131             data.length
6132         );
6133 
6134         uint256 marketId;
6135         uint256 rawExpiry;
6136 
6137         /* solium-disable-next-line security/no-inline-assembly */
6138         assembly {
6139             marketId := mload(add(data, 32))
6140             rawExpiry := mload(add(data, 64))
6141         }
6142 
6143         return (
6144             marketId,
6145             Math.to32(rawExpiry)
6146         );
6147     }
6148 
6149     function parseTradeArgs(
6150         bytes memory data
6151     )
6152         private
6153         pure
6154         returns (
6155             uint256,
6156             uint32
6157         )
6158     {
6159         Require.that(
6160             data.length == 64,
6161             FILE,
6162             "Trade data invalid length",
6163             data.length
6164         );
6165 
6166         uint256 owedMarketId;
6167         uint256 rawExpiry;
6168 
6169         /* solium-disable-next-line security/no-inline-assembly */
6170         assembly {
6171             owedMarketId := mload(add(data, 32))
6172             rawExpiry := mload(add(data, 64))
6173         }
6174 
6175         return (
6176             owedMarketId,
6177             Math.to32(rawExpiry)
6178         );
6179     }
6180 }