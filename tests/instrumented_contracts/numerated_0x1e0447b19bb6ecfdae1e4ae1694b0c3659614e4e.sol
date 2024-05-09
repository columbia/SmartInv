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
22 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
23 
24 /**
25  * @title Ownable
26  * @dev The Ownable contract has an owner address, and provides basic authorization control
27  * functions, this simplifies the implementation of "user permissions".
28  */
29 contract Ownable {
30     address private _owner;
31 
32     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34     /**
35      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36      * account.
37      */
38     constructor () internal {
39         _owner = msg.sender;
40         emit OwnershipTransferred(address(0), _owner);
41     }
42 
43     /**
44      * @return the address of the owner.
45      */
46     function owner() public view returns (address) {
47         return _owner;
48     }
49 
50     /**
51      * @dev Throws if called by any account other than the owner.
52      */
53     modifier onlyOwner() {
54         require(isOwner());
55         _;
56     }
57 
58     /**
59      * @return true if `msg.sender` is the owner of the contract.
60      */
61     function isOwner() public view returns (bool) {
62         return msg.sender == _owner;
63     }
64 
65     /**
66      * @dev Allows the current owner to relinquish control of the contract.
67      * @notice Renouncing to ownership will leave the contract without an owner.
68      * It will not be possible to call the functions with the `onlyOwner`
69      * modifier anymore.
70      */
71     function renounceOwnership() public onlyOwner {
72         emit OwnershipTransferred(_owner, address(0));
73         _owner = address(0);
74     }
75 
76     /**
77      * @dev Allows the current owner to transfer control of the contract to a newOwner.
78      * @param newOwner The address to transfer ownership to.
79      */
80     function transferOwnership(address newOwner) public onlyOwner {
81         _transferOwnership(newOwner);
82     }
83 
84     /**
85      * @dev Transfers control of the contract to a newOwner.
86      * @param newOwner The address to transfer ownership to.
87      */
88     function _transferOwnership(address newOwner) internal {
89         require(newOwner != address(0));
90         emit OwnershipTransferred(_owner, newOwner);
91         _owner = newOwner;
92     }
93 }
94 
95 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
96 
97 /**
98  * @title Helps contracts guard against reentrancy attacks.
99  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
100  * @dev If you mark a function `nonReentrant`, you should also
101  * mark it `external`.
102  */
103 contract ReentrancyGuard {
104     /// @dev counter to allow mutex lock with only one SSTORE operation
105     uint256 private _guardCounter;
106 
107     constructor () internal {
108         // The counter starts at one to prevent changing it from zero to a non-zero
109         // value, which is a more expensive operation.
110         _guardCounter = 1;
111     }
112 
113     /**
114      * @dev Prevents a contract from calling itself, directly or indirectly.
115      * Calling a `nonReentrant` function from another `nonReentrant`
116      * function is not supported. It is possible to prevent this from happening
117      * by making the `nonReentrant` function external, and make it call a
118      * `private` function that does the actual work.
119      */
120     modifier nonReentrant() {
121         _guardCounter += 1;
122         uint256 localCounter = _guardCounter;
123         _;
124         require(localCounter == _guardCounter);
125     }
126 }
127 
128 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
129 
130 /**
131  * @title SafeMath
132  * @dev Unsigned math operations with safety checks that revert on error
133  */
134 library SafeMath {
135     /**
136     * @dev Multiplies two unsigned integers, reverts on overflow.
137     */
138     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
139         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
140         // benefit is lost if 'b' is also tested.
141         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
142         if (a == 0) {
143             return 0;
144         }
145 
146         uint256 c = a * b;
147         require(c / a == b);
148 
149         return c;
150     }
151 
152     /**
153     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
154     */
155     function div(uint256 a, uint256 b) internal pure returns (uint256) {
156         // Solidity only automatically asserts when dividing by 0
157         require(b > 0);
158         uint256 c = a / b;
159         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
160 
161         return c;
162     }
163 
164     /**
165     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
166     */
167     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
168         require(b <= a);
169         uint256 c = a - b;
170 
171         return c;
172     }
173 
174     /**
175     * @dev Adds two unsigned integers, reverts on overflow.
176     */
177     function add(uint256 a, uint256 b) internal pure returns (uint256) {
178         uint256 c = a + b;
179         require(c >= a);
180 
181         return c;
182     }
183 
184     /**
185     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
186     * reverts when dividing by zero.
187     */
188     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
189         require(b != 0);
190         return a % b;
191     }
192 }
193 
194 // File: contracts/protocol/lib/Require.sol
195 
196 /**
197  * @title Require
198  * @author dYdX
199  *
200  * Stringifies parameters to pretty-print revert messages. Costs more gas than regular require()
201  */
202 library Require {
203 
204     // ============ Constants ============
205 
206     uint256 constant ASCII_ZERO = 48; // '0'
207     uint256 constant ASCII_RELATIVE_ZERO = 87; // 'a' - 10
208     uint256 constant ASCII_LOWER_EX = 120; // 'x'
209     bytes2 constant COLON = 0x3a20; // ': '
210     bytes2 constant COMMA = 0x2c20; // ', '
211     bytes2 constant LPAREN = 0x203c; // ' <'
212     byte constant RPAREN = 0x3e; // '>'
213     uint256 constant FOUR_BIT_MASK = 0xf;
214 
215     // ============ Library Functions ============
216 
217     function that(
218         bool must,
219         bytes32 file,
220         bytes32 reason
221     )
222         internal
223         pure
224     {
225         if (!must) {
226             revert(
227                 string(
228                     abi.encodePacked(
229                         stringify(file),
230                         COLON,
231                         stringify(reason)
232                     )
233                 )
234             );
235         }
236     }
237 
238     function that(
239         bool must,
240         bytes32 file,
241         bytes32 reason,
242         uint256 payloadA
243     )
244         internal
245         pure
246     {
247         if (!must) {
248             revert(
249                 string(
250                     abi.encodePacked(
251                         stringify(file),
252                         COLON,
253                         stringify(reason),
254                         LPAREN,
255                         stringify(payloadA),
256                         RPAREN
257                     )
258                 )
259             );
260         }
261     }
262 
263     function that(
264         bool must,
265         bytes32 file,
266         bytes32 reason,
267         uint256 payloadA,
268         uint256 payloadB
269     )
270         internal
271         pure
272     {
273         if (!must) {
274             revert(
275                 string(
276                     abi.encodePacked(
277                         stringify(file),
278                         COLON,
279                         stringify(reason),
280                         LPAREN,
281                         stringify(payloadA),
282                         COMMA,
283                         stringify(payloadB),
284                         RPAREN
285                     )
286                 )
287             );
288         }
289     }
290 
291     function that(
292         bool must,
293         bytes32 file,
294         bytes32 reason,
295         address payloadA
296     )
297         internal
298         pure
299     {
300         if (!must) {
301             revert(
302                 string(
303                     abi.encodePacked(
304                         stringify(file),
305                         COLON,
306                         stringify(reason),
307                         LPAREN,
308                         stringify(payloadA),
309                         RPAREN
310                     )
311                 )
312             );
313         }
314     }
315 
316     function that(
317         bool must,
318         bytes32 file,
319         bytes32 reason,
320         address payloadA,
321         uint256 payloadB
322     )
323         internal
324         pure
325     {
326         if (!must) {
327             revert(
328                 string(
329                     abi.encodePacked(
330                         stringify(file),
331                         COLON,
332                         stringify(reason),
333                         LPAREN,
334                         stringify(payloadA),
335                         COMMA,
336                         stringify(payloadB),
337                         RPAREN
338                     )
339                 )
340             );
341         }
342     }
343 
344     function that(
345         bool must,
346         bytes32 file,
347         bytes32 reason,
348         address payloadA,
349         uint256 payloadB,
350         uint256 payloadC
351     )
352         internal
353         pure
354     {
355         if (!must) {
356             revert(
357                 string(
358                     abi.encodePacked(
359                         stringify(file),
360                         COLON,
361                         stringify(reason),
362                         LPAREN,
363                         stringify(payloadA),
364                         COMMA,
365                         stringify(payloadB),
366                         COMMA,
367                         stringify(payloadC),
368                         RPAREN
369                     )
370                 )
371             );
372         }
373     }
374 
375     // ============ Private Functions ============
376 
377     function stringify(
378         bytes32 input
379     )
380         private
381         pure
382         returns (bytes memory)
383     {
384         // put the input bytes into the result
385         bytes memory result = abi.encodePacked(input);
386 
387         // determine the length of the input by finding the location of the last non-zero byte
388         for (uint256 i = 32; i > 0; ) {
389             // reverse-for-loops with unsigned integer
390             /* solium-disable-next-line security/no-modify-for-iter-var */
391             i--;
392 
393             // find the last non-zero byte in order to determine the length
394             if (result[i] != 0) {
395                 uint256 length = i + 1;
396 
397                 /* solium-disable-next-line security/no-inline-assembly */
398                 assembly {
399                     mstore(result, length) // r.length = length;
400                 }
401 
402                 return result;
403             }
404         }
405 
406         // all bytes are zero
407         return new bytes(0);
408     }
409 
410     function stringify(
411         uint256 input
412     )
413         private
414         pure
415         returns (bytes memory)
416     {
417         if (input == 0) {
418             return "0";
419         }
420 
421         // get the final string length
422         uint256 j = input;
423         uint256 length;
424         while (j != 0) {
425             length++;
426             j /= 10;
427         }
428 
429         // allocate the string
430         bytes memory bstr = new bytes(length);
431 
432         // populate the string starting with the least-significant character
433         j = input;
434         for (uint256 i = length; i > 0; ) {
435             // reverse-for-loops with unsigned integer
436             /* solium-disable-next-line security/no-modify-for-iter-var */
437             i--;
438 
439             // take last decimal digit
440             bstr[i] = byte(uint8(ASCII_ZERO + (j % 10)));
441 
442             // remove the last decimal digit
443             j /= 10;
444         }
445 
446         return bstr;
447     }
448 
449     function stringify(
450         address input
451     )
452         private
453         pure
454         returns (bytes memory)
455     {
456         uint256 z = uint256(input);
457 
458         // addresses are "0x" followed by 20 bytes of data which take up 2 characters each
459         bytes memory result = new bytes(42);
460 
461         // populate the result with "0x"
462         result[0] = byte(uint8(ASCII_ZERO));
463         result[1] = byte(uint8(ASCII_LOWER_EX));
464 
465         // for each byte (starting from the lowest byte), populate the result with two characters
466         for (uint256 i = 0; i < 20; i++) {
467             // each byte takes two characters
468             uint256 shift = i * 2;
469 
470             // populate the least-significant character
471             result[41 - shift] = char(z & FOUR_BIT_MASK);
472             z = z >> 4;
473 
474             // populate the most-significant character
475             result[40 - shift] = char(z & FOUR_BIT_MASK);
476             z = z >> 4;
477         }
478 
479         return result;
480     }
481 
482     function char(
483         uint256 input
484     )
485         private
486         pure
487         returns (byte)
488     {
489         // return ASCII digit (0-9)
490         if (input < 10) {
491             return byte(uint8(input + ASCII_ZERO));
492         }
493 
494         // return ASCII letter (a-f)
495         return byte(uint8(input + ASCII_RELATIVE_ZERO));
496     }
497 }
498 
499 // File: contracts/protocol/lib/Math.sol
500 
501 /**
502  * @title Math
503  * @author dYdX
504  *
505  * Library for non-standard Math functions
506  */
507 library Math {
508     using SafeMath for uint256;
509 
510     // ============ Constants ============
511 
512     bytes32 constant FILE = "Math";
513 
514     // ============ Library Functions ============
515 
516     /*
517      * Return target * (numerator / denominator).
518      */
519     function getPartial(
520         uint256 target,
521         uint256 numerator,
522         uint256 denominator
523     )
524         internal
525         pure
526         returns (uint256)
527     {
528         return target.mul(numerator).div(denominator);
529     }
530 
531     /*
532      * Return target * (numerator / denominator), but rounded up.
533      */
534     function getPartialRoundUp(
535         uint256 target,
536         uint256 numerator,
537         uint256 denominator
538     )
539         internal
540         pure
541         returns (uint256)
542     {
543         if (target == 0 || numerator == 0) {
544             // SafeMath will check for zero denominator
545             return SafeMath.div(0, denominator);
546         }
547         return target.mul(numerator).sub(1).div(denominator).add(1);
548     }
549 
550     function to128(
551         uint256 number
552     )
553         internal
554         pure
555         returns (uint128)
556     {
557         uint128 result = uint128(number);
558         Require.that(
559             result == number,
560             FILE,
561             "Unsafe cast to uint128"
562         );
563         return result;
564     }
565 
566     function to96(
567         uint256 number
568     )
569         internal
570         pure
571         returns (uint96)
572     {
573         uint96 result = uint96(number);
574         Require.that(
575             result == number,
576             FILE,
577             "Unsafe cast to uint96"
578         );
579         return result;
580     }
581 
582     function to32(
583         uint256 number
584     )
585         internal
586         pure
587         returns (uint32)
588     {
589         uint32 result = uint32(number);
590         Require.that(
591             result == number,
592             FILE,
593             "Unsafe cast to uint32"
594         );
595         return result;
596     }
597 
598     function min(
599         uint256 a,
600         uint256 b
601     )
602         internal
603         pure
604         returns (uint256)
605     {
606         return a < b ? a : b;
607     }
608 
609     function max(
610         uint256 a,
611         uint256 b
612     )
613         internal
614         pure
615         returns (uint256)
616     {
617         return a > b ? a : b;
618     }
619 }
620 
621 // File: contracts/protocol/lib/Types.sol
622 
623 /**
624  * @title Types
625  * @author dYdX
626  *
627  * Library for interacting with the basic structs used in Solo
628  */
629 library Types {
630     using Math for uint256;
631 
632     // ============ AssetAmount ============
633 
634     enum AssetDenomination {
635         Wei, // the amount is denominated in wei
636         Par  // the amount is denominated in par
637     }
638 
639     enum AssetReference {
640         Delta, // the amount is given as a delta from the current value
641         Target // the amount is given as an exact number to end up at
642     }
643 
644     struct AssetAmount {
645         bool sign; // true if positive
646         AssetDenomination denomination;
647         AssetReference ref;
648         uint256 value;
649     }
650 
651     // ============ Par (Principal Amount) ============
652 
653     // Total borrow and supply values for a market
654     struct TotalPar {
655         uint128 borrow;
656         uint128 supply;
657     }
658 
659     // Individual principal amount for an account
660     struct Par {
661         bool sign; // true if positive
662         uint128 value;
663     }
664 
665     function zeroPar()
666         internal
667         pure
668         returns (Par memory)
669     {
670         return Par({
671             sign: false,
672             value: 0
673         });
674     }
675 
676     function sub(
677         Par memory a,
678         Par memory b
679     )
680         internal
681         pure
682         returns (Par memory)
683     {
684         return add(a, negative(b));
685     }
686 
687     function add(
688         Par memory a,
689         Par memory b
690     )
691         internal
692         pure
693         returns (Par memory)
694     {
695         Par memory result;
696         if (a.sign == b.sign) {
697             result.sign = a.sign;
698             result.value = SafeMath.add(a.value, b.value).to128();
699         } else {
700             if (a.value >= b.value) {
701                 result.sign = a.sign;
702                 result.value = SafeMath.sub(a.value, b.value).to128();
703             } else {
704                 result.sign = b.sign;
705                 result.value = SafeMath.sub(b.value, a.value).to128();
706             }
707         }
708         return result;
709     }
710 
711     function equals(
712         Par memory a,
713         Par memory b
714     )
715         internal
716         pure
717         returns (bool)
718     {
719         if (a.value == b.value) {
720             if (a.value == 0) {
721                 return true;
722             }
723             return a.sign == b.sign;
724         }
725         return false;
726     }
727 
728     function negative(
729         Par memory a
730     )
731         internal
732         pure
733         returns (Par memory)
734     {
735         return Par({
736             sign: !a.sign,
737             value: a.value
738         });
739     }
740 
741     function isNegative(
742         Par memory a
743     )
744         internal
745         pure
746         returns (bool)
747     {
748         return !a.sign && a.value > 0;
749     }
750 
751     function isPositive(
752         Par memory a
753     )
754         internal
755         pure
756         returns (bool)
757     {
758         return a.sign && a.value > 0;
759     }
760 
761     function isZero(
762         Par memory a
763     )
764         internal
765         pure
766         returns (bool)
767     {
768         return a.value == 0;
769     }
770 
771     // ============ Wei (Token Amount) ============
772 
773     // Individual token amount for an account
774     struct Wei {
775         bool sign; // true if positive
776         uint256 value;
777     }
778 
779     function zeroWei()
780         internal
781         pure
782         returns (Wei memory)
783     {
784         return Wei({
785             sign: false,
786             value: 0
787         });
788     }
789 
790     function sub(
791         Wei memory a,
792         Wei memory b
793     )
794         internal
795         pure
796         returns (Wei memory)
797     {
798         return add(a, negative(b));
799     }
800 
801     function add(
802         Wei memory a,
803         Wei memory b
804     )
805         internal
806         pure
807         returns (Wei memory)
808     {
809         Wei memory result;
810         if (a.sign == b.sign) {
811             result.sign = a.sign;
812             result.value = SafeMath.add(a.value, b.value);
813         } else {
814             if (a.value >= b.value) {
815                 result.sign = a.sign;
816                 result.value = SafeMath.sub(a.value, b.value);
817             } else {
818                 result.sign = b.sign;
819                 result.value = SafeMath.sub(b.value, a.value);
820             }
821         }
822         return result;
823     }
824 
825     function equals(
826         Wei memory a,
827         Wei memory b
828     )
829         internal
830         pure
831         returns (bool)
832     {
833         if (a.value == b.value) {
834             if (a.value == 0) {
835                 return true;
836             }
837             return a.sign == b.sign;
838         }
839         return false;
840     }
841 
842     function negative(
843         Wei memory a
844     )
845         internal
846         pure
847         returns (Wei memory)
848     {
849         return Wei({
850             sign: !a.sign,
851             value: a.value
852         });
853     }
854 
855     function isNegative(
856         Wei memory a
857     )
858         internal
859         pure
860         returns (bool)
861     {
862         return !a.sign && a.value > 0;
863     }
864 
865     function isPositive(
866         Wei memory a
867     )
868         internal
869         pure
870         returns (bool)
871     {
872         return a.sign && a.value > 0;
873     }
874 
875     function isZero(
876         Wei memory a
877     )
878         internal
879         pure
880         returns (bool)
881     {
882         return a.value == 0;
883     }
884 }
885 
886 // File: contracts/protocol/lib/Account.sol
887 
888 /**
889  * @title Account
890  * @author dYdX
891  *
892  * Library of structs and functions that represent an account
893  */
894 library Account {
895     // ============ Enums ============
896 
897     /*
898      * Most-recently-cached account status.
899      *
900      * Normal: Can only be liquidated if the account values are violating the global margin-ratio.
901      * Liquid: Can be liquidated no matter the account values.
902      *         Can be vaporized if there are no more positive account values.
903      * Vapor:  Has only negative (or zeroed) account values. Can be vaporized.
904      *
905      */
906     enum Status {
907         Normal,
908         Liquid,
909         Vapor
910     }
911 
912     // ============ Structs ============
913 
914     // Represents the unique key that specifies an account
915     struct Info {
916         address owner;  // The address that owns the account
917         uint256 number; // A nonce that allows a single address to control many accounts
918     }
919 
920     // The complete storage for any account
921     struct Storage {
922         mapping (uint256 => Types.Par) balances; // Mapping from marketId to principal
923         Status status;
924     }
925 
926     // ============ Library Functions ============
927 
928     function equals(
929         Info memory a,
930         Info memory b
931     )
932         internal
933         pure
934         returns (bool)
935     {
936         return a.owner == b.owner && a.number == b.number;
937     }
938 }
939 
940 // File: contracts/protocol/lib/Monetary.sol
941 
942 /**
943  * @title Monetary
944  * @author dYdX
945  *
946  * Library for types involving money
947  */
948 library Monetary {
949 
950     /*
951      * The price of a base-unit of an asset.
952      */
953     struct Price {
954         uint256 value;
955     }
956 
957     /*
958      * Total value of an some amount of an asset. Equal to (price * amount).
959      */
960     struct Value {
961         uint256 value;
962     }
963 }
964 
965 // File: contracts/protocol/lib/Cache.sol
966 
967 /**
968  * @title Cache
969  * @author dYdX
970  *
971  * Library for caching information about markets
972  */
973 library Cache {
974     using Cache for MarketCache;
975     using Storage for Storage.State;
976 
977     // ============ Structs ============
978 
979     struct MarketInfo {
980         bool isClosing;
981         uint128 borrowPar;
982         Monetary.Price price;
983     }
984 
985     struct MarketCache {
986         MarketInfo[] markets;
987     }
988 
989     // ============ Setter Functions ============
990 
991     /**
992      * Initialize an empty cache for some given number of total markets.
993      */
994     function create(
995         uint256 numMarkets
996     )
997         internal
998         pure
999         returns (MarketCache memory)
1000     {
1001         return MarketCache({
1002             markets: new MarketInfo[](numMarkets)
1003         });
1004     }
1005 
1006     /**
1007      * Add market information (price and total borrowed par if the market is closing) to the cache.
1008      * Return true if the market information did not previously exist in the cache.
1009      */
1010     function addMarket(
1011         MarketCache memory cache,
1012         Storage.State storage state,
1013         uint256 marketId
1014     )
1015         internal
1016         view
1017         returns (bool)
1018     {
1019         if (cache.hasMarket(marketId)) {
1020             return false;
1021         }
1022         cache.markets[marketId].price = state.fetchPrice(marketId);
1023         if (state.markets[marketId].isClosing) {
1024             cache.markets[marketId].isClosing = true;
1025             cache.markets[marketId].borrowPar = state.getTotalPar(marketId).borrow;
1026         }
1027         return true;
1028     }
1029 
1030     // ============ Getter Functions ============
1031 
1032     function getNumMarkets(
1033         MarketCache memory cache
1034     )
1035         internal
1036         pure
1037         returns (uint256)
1038     {
1039         return cache.markets.length;
1040     }
1041 
1042     function hasMarket(
1043         MarketCache memory cache,
1044         uint256 marketId
1045     )
1046         internal
1047         pure
1048         returns (bool)
1049     {
1050         return cache.markets[marketId].price.value != 0;
1051     }
1052 
1053     function getIsClosing(
1054         MarketCache memory cache,
1055         uint256 marketId
1056     )
1057         internal
1058         pure
1059         returns (bool)
1060     {
1061         return cache.markets[marketId].isClosing;
1062     }
1063 
1064     function getPrice(
1065         MarketCache memory cache,
1066         uint256 marketId
1067     )
1068         internal
1069         pure
1070         returns (Monetary.Price memory)
1071     {
1072         return cache.markets[marketId].price;
1073     }
1074 
1075     function getBorrowPar(
1076         MarketCache memory cache,
1077         uint256 marketId
1078     )
1079         internal
1080         pure
1081         returns (uint128)
1082     {
1083         return cache.markets[marketId].borrowPar;
1084     }
1085 }
1086 
1087 // File: contracts/protocol/lib/Decimal.sol
1088 
1089 /**
1090  * @title Decimal
1091  * @author dYdX
1092  *
1093  * Library that defines a fixed-point number with 18 decimal places.
1094  */
1095 library Decimal {
1096     using SafeMath for uint256;
1097 
1098     // ============ Constants ============
1099 
1100     uint256 constant BASE = 10**18;
1101 
1102     // ============ Structs ============
1103 
1104     struct D256 {
1105         uint256 value;
1106     }
1107 
1108     // ============ Functions ============
1109 
1110     function one()
1111         internal
1112         pure
1113         returns (D256 memory)
1114     {
1115         return D256({ value: BASE });
1116     }
1117 
1118     function onePlus(
1119         D256 memory d
1120     )
1121         internal
1122         pure
1123         returns (D256 memory)
1124     {
1125         return D256({ value: d.value.add(BASE) });
1126     }
1127 
1128     function mul(
1129         uint256 target,
1130         D256 memory d
1131     )
1132         internal
1133         pure
1134         returns (uint256)
1135     {
1136         return Math.getPartial(target, d.value, BASE);
1137     }
1138 
1139     function div(
1140         uint256 target,
1141         D256 memory d
1142     )
1143         internal
1144         pure
1145         returns (uint256)
1146     {
1147         return Math.getPartial(target, BASE, d.value);
1148     }
1149 }
1150 
1151 // File: contracts/protocol/lib/Time.sol
1152 
1153 /**
1154  * @title Time
1155  * @author dYdX
1156  *
1157  * Library for dealing with time, assuming timestamps fit within 32 bits (valid until year 2106)
1158  */
1159 library Time {
1160 
1161     // ============ Library Functions ============
1162 
1163     function currentTime()
1164         internal
1165         view
1166         returns (uint32)
1167     {
1168         return Math.to32(block.timestamp);
1169     }
1170 }
1171 
1172 // File: contracts/protocol/lib/Interest.sol
1173 
1174 /**
1175  * @title Interest
1176  * @author dYdX
1177  *
1178  * Library for managing the interest rate and interest indexes of Solo
1179  */
1180 library Interest {
1181     using Math for uint256;
1182     using SafeMath for uint256;
1183 
1184     // ============ Constants ============
1185 
1186     bytes32 constant FILE = "Interest";
1187     uint64 constant BASE = 10**18;
1188 
1189     // ============ Structs ============
1190 
1191     struct Rate {
1192         uint256 value;
1193     }
1194 
1195     struct Index {
1196         uint96 borrow;
1197         uint96 supply;
1198         uint32 lastUpdate;
1199     }
1200 
1201     // ============ Library Functions ============
1202 
1203     /**
1204      * Get a new market Index based on the old index and market interest rate.
1205      * Calculate interest for borrowers by using the formula rate * time. Approximates
1206      * continuously-compounded interest when called frequently, but is much more
1207      * gas-efficient to calculate. For suppliers, the interest rate is adjusted by the earningsRate,
1208      * then prorated the across all suppliers.
1209      *
1210      * @param  index         The old index for a market
1211      * @param  rate          The current interest rate of the market
1212      * @param  totalPar      The total supply and borrow par values of the market
1213      * @param  earningsRate  The portion of the interest that is forwarded to the suppliers
1214      * @return               The updated index for a market
1215      */
1216     function calculateNewIndex(
1217         Index memory index,
1218         Rate memory rate,
1219         Types.TotalPar memory totalPar,
1220         Decimal.D256 memory earningsRate
1221     )
1222         internal
1223         view
1224         returns (Index memory)
1225     {
1226         (
1227             Types.Wei memory supplyWei,
1228             Types.Wei memory borrowWei
1229         ) = totalParToWei(totalPar, index);
1230 
1231         // get interest increase for borrowers
1232         uint32 currentTime = Time.currentTime();
1233         uint256 borrowInterest = rate.value.mul(uint256(currentTime).sub(index.lastUpdate));
1234 
1235         // get interest increase for suppliers
1236         uint256 supplyInterest;
1237         if (Types.isZero(supplyWei)) {
1238             supplyInterest = 0;
1239         } else {
1240             supplyInterest = Decimal.mul(borrowInterest, earningsRate);
1241             if (borrowWei.value < supplyWei.value) {
1242                 supplyInterest = Math.getPartial(supplyInterest, borrowWei.value, supplyWei.value);
1243             }
1244         }
1245         assert(supplyInterest <= borrowInterest);
1246 
1247         return Index({
1248             borrow: Math.getPartial(index.borrow, borrowInterest, BASE).add(index.borrow).to96(),
1249             supply: Math.getPartial(index.supply, supplyInterest, BASE).add(index.supply).to96(),
1250             lastUpdate: currentTime
1251         });
1252     }
1253 
1254     function newIndex()
1255         internal
1256         view
1257         returns (Index memory)
1258     {
1259         return Index({
1260             borrow: BASE,
1261             supply: BASE,
1262             lastUpdate: Time.currentTime()
1263         });
1264     }
1265 
1266     /*
1267      * Convert a principal amount to a token amount given an index.
1268      */
1269     function parToWei(
1270         Types.Par memory input,
1271         Index memory index
1272     )
1273         internal
1274         pure
1275         returns (Types.Wei memory)
1276     {
1277         uint256 inputValue = uint256(input.value);
1278         if (input.sign) {
1279             return Types.Wei({
1280                 sign: true,
1281                 value: inputValue.getPartial(index.supply, BASE)
1282             });
1283         } else {
1284             return Types.Wei({
1285                 sign: false,
1286                 value: inputValue.getPartialRoundUp(index.borrow, BASE)
1287             });
1288         }
1289     }
1290 
1291     /*
1292      * Convert a token amount to a principal amount given an index.
1293      */
1294     function weiToPar(
1295         Types.Wei memory input,
1296         Index memory index
1297     )
1298         internal
1299         pure
1300         returns (Types.Par memory)
1301     {
1302         if (input.sign) {
1303             return Types.Par({
1304                 sign: true,
1305                 value: input.value.getPartial(BASE, index.supply).to128()
1306             });
1307         } else {
1308             return Types.Par({
1309                 sign: false,
1310                 value: input.value.getPartialRoundUp(BASE, index.borrow).to128()
1311             });
1312         }
1313     }
1314 
1315     /*
1316      * Convert the total supply and borrow principal amounts of a market to total supply and borrow
1317      * token amounts.
1318      */
1319     function totalParToWei(
1320         Types.TotalPar memory totalPar,
1321         Index memory index
1322     )
1323         internal
1324         pure
1325         returns (Types.Wei memory, Types.Wei memory)
1326     {
1327         Types.Par memory supplyPar = Types.Par({
1328             sign: true,
1329             value: totalPar.supply
1330         });
1331         Types.Par memory borrowPar = Types.Par({
1332             sign: false,
1333             value: totalPar.borrow
1334         });
1335         Types.Wei memory supplyWei = parToWei(supplyPar, index);
1336         Types.Wei memory borrowWei = parToWei(borrowPar, index);
1337         return (supplyWei, borrowWei);
1338     }
1339 }
1340 
1341 // File: contracts/protocol/interfaces/IErc20.sol
1342 
1343 /**
1344  * @title IErc20
1345  * @author dYdX
1346  *
1347  * Interface for using ERC20 Tokens. We have to use a special interface to call ERC20 functions so
1348  * that we don't automatically revert when calling non-compliant tokens that have no return value for
1349  * transfer(), transferFrom(), or approve().
1350  */
1351 interface IErc20 {
1352     event Transfer(
1353         address indexed from,
1354         address indexed to,
1355         uint256 value
1356     );
1357 
1358     event Approval(
1359         address indexed owner,
1360         address indexed spender,
1361         uint256 value
1362     );
1363 
1364     function totalSupply(
1365     )
1366         external
1367         view
1368         returns (uint256);
1369 
1370     function balanceOf(
1371         address who
1372     )
1373         external
1374         view
1375         returns (uint256);
1376 
1377     function allowance(
1378         address owner,
1379         address spender
1380     )
1381         external
1382         view
1383         returns (uint256);
1384 
1385     function transfer(
1386         address to,
1387         uint256 value
1388     )
1389         external;
1390 
1391     function transferFrom(
1392         address from,
1393         address to,
1394         uint256 value
1395     )
1396         external;
1397 
1398     function approve(
1399         address spender,
1400         uint256 value
1401     )
1402         external;
1403 
1404     function name()
1405         external
1406         view
1407         returns (string memory);
1408 
1409     function symbol()
1410         external
1411         view
1412         returns (string memory);
1413 
1414     function decimals()
1415         external
1416         view
1417         returns (uint8);
1418 }
1419 
1420 // File: contracts/protocol/lib/Token.sol
1421 
1422 /**
1423  * @title Token
1424  * @author dYdX
1425  *
1426  * This library contains basic functions for interacting with ERC20 tokens. Modified to work with
1427  * tokens that don't adhere strictly to the ERC20 standard (for example tokens that don't return a
1428  * boolean value on success).
1429  */
1430 library Token {
1431 
1432     // ============ Constants ============
1433 
1434     bytes32 constant FILE = "Token";
1435 
1436     // ============ Library Functions ============
1437 
1438     function balanceOf(
1439         address token,
1440         address owner
1441     )
1442         internal
1443         view
1444         returns (uint256)
1445     {
1446         return IErc20(token).balanceOf(owner);
1447     }
1448 
1449     function allowance(
1450         address token,
1451         address owner,
1452         address spender
1453     )
1454         internal
1455         view
1456         returns (uint256)
1457     {
1458         return IErc20(token).allowance(owner, spender);
1459     }
1460 
1461     function approve(
1462         address token,
1463         address spender,
1464         uint256 amount
1465     )
1466         internal
1467     {
1468         IErc20(token).approve(spender, amount);
1469 
1470         Require.that(
1471             checkSuccess(),
1472             FILE,
1473             "Approve failed"
1474         );
1475     }
1476 
1477     function approveMax(
1478         address token,
1479         address spender
1480     )
1481         internal
1482     {
1483         approve(
1484             token,
1485             spender,
1486             uint256(-1)
1487         );
1488     }
1489 
1490     function transfer(
1491         address token,
1492         address to,
1493         uint256 amount
1494     )
1495         internal
1496     {
1497         if (amount == 0 || to == address(this)) {
1498             return;
1499         }
1500 
1501         IErc20(token).transfer(to, amount);
1502 
1503         Require.that(
1504             checkSuccess(),
1505             FILE,
1506             "Transfer failed"
1507         );
1508     }
1509 
1510     function transferFrom(
1511         address token,
1512         address from,
1513         address to,
1514         uint256 amount
1515     )
1516         internal
1517     {
1518         if (amount == 0 || to == from) {
1519             return;
1520         }
1521 
1522         IErc20(token).transferFrom(from, to, amount);
1523 
1524         Require.that(
1525             checkSuccess(),
1526             FILE,
1527             "TransferFrom failed"
1528         );
1529     }
1530 
1531     // ============ Private Functions ============
1532 
1533     /**
1534      * Check the return value of the previous function up to 32 bytes. Return true if the previous
1535      * function returned 0 bytes or 32 bytes that are not all-zero.
1536      */
1537     function checkSuccess(
1538     )
1539         private
1540         pure
1541         returns (bool)
1542     {
1543         uint256 returnValue = 0;
1544 
1545         /* solium-disable-next-line security/no-inline-assembly */
1546         assembly {
1547             // check number of bytes returned from last function call
1548             switch returndatasize
1549 
1550             // no bytes returned: assume success
1551             case 0x0 {
1552                 returnValue := 1
1553             }
1554 
1555             // 32 bytes returned: check if non-zero
1556             case 0x20 {
1557                 // copy 32 bytes into scratch space
1558                 returndatacopy(0x0, 0x0, 0x20)
1559 
1560                 // load those bytes into returnValue
1561                 returnValue := mload(0x0)
1562             }
1563 
1564             // not sure what was returned: don't mark as success
1565             default { }
1566         }
1567 
1568         return returnValue != 0;
1569     }
1570 }
1571 
1572 // File: contracts/protocol/interfaces/IInterestSetter.sol
1573 
1574 /**
1575  * @title IInterestSetter
1576  * @author dYdX
1577  *
1578  * Interface that Interest Setters for Solo must implement in order to report interest rates.
1579  */
1580 interface IInterestSetter {
1581 
1582     // ============ Public Functions ============
1583 
1584     /**
1585      * Get the interest rate of a token given some borrowed and supplied amounts
1586      *
1587      * @param  token        The address of the ERC20 token for the market
1588      * @param  borrowWei    The total borrowed token amount for the market
1589      * @param  supplyWei    The total supplied token amount for the market
1590      * @return              The interest rate per second
1591      */
1592     function getInterestRate(
1593         address token,
1594         uint256 borrowWei,
1595         uint256 supplyWei
1596     )
1597         external
1598         view
1599         returns (Interest.Rate memory);
1600 }
1601 
1602 // File: contracts/protocol/interfaces/IPriceOracle.sol
1603 
1604 /**
1605  * @title IPriceOracle
1606  * @author dYdX
1607  *
1608  * Interface that Price Oracles for Solo must implement in order to report prices.
1609  */
1610 contract IPriceOracle {
1611 
1612     // ============ Constants ============
1613 
1614     uint256 public constant ONE_DOLLAR = 10 ** 36;
1615 
1616     // ============ Public Functions ============
1617 
1618     /**
1619      * Get the price of a token
1620      *
1621      * @param  token  The ERC20 token address of the market
1622      * @return        The USD price of a base unit of the token, then multiplied by 10^36.
1623      *                So a USD-stable coin with 18 decimal places would return 10^18.
1624      *                This is the price of the base unit rather than the price of a "human-readable"
1625      *                token amount. Every ERC20 may have a different number of decimals.
1626      */
1627     function getPrice(
1628         address token
1629     )
1630         public
1631         view
1632         returns (Monetary.Price memory);
1633 }
1634 
1635 // File: contracts/protocol/lib/Storage.sol
1636 
1637 /**
1638  * @title Storage
1639  * @author dYdX
1640  *
1641  * Functions for reading, writing, and verifying state in Solo
1642  */
1643 library Storage {
1644     using Cache for Cache.MarketCache;
1645     using Storage for Storage.State;
1646     using Math for uint256;
1647     using Types for Types.Par;
1648     using Types for Types.Wei;
1649     using SafeMath for uint256;
1650 
1651     // ============ Constants ============
1652 
1653     bytes32 constant FILE = "Storage";
1654 
1655     // ============ Structs ============
1656 
1657     // All information necessary for tracking a market
1658     struct Market {
1659         // Contract address of the associated ERC20 token
1660         address token;
1661 
1662         // Total aggregated supply and borrow amount of the entire market
1663         Types.TotalPar totalPar;
1664 
1665         // Interest index of the market
1666         Interest.Index index;
1667 
1668         // Contract address of the price oracle for this market
1669         IPriceOracle priceOracle;
1670 
1671         // Contract address of the interest setter for this market
1672         IInterestSetter interestSetter;
1673 
1674         // Multiplier on the marginRatio for this market
1675         Decimal.D256 marginPremium;
1676 
1677         // Multiplier on the liquidationSpread for this market
1678         Decimal.D256 spreadPremium;
1679 
1680         // Whether additional borrows are allowed for this market
1681         bool isClosing;
1682     }
1683 
1684     // The global risk parameters that govern the health and security of the system
1685     struct RiskParams {
1686         // Required ratio of over-collateralization
1687         Decimal.D256 marginRatio;
1688 
1689         // Percentage penalty incurred by liquidated accounts
1690         Decimal.D256 liquidationSpread;
1691 
1692         // Percentage of the borrower's interest fee that gets passed to the suppliers
1693         Decimal.D256 earningsRate;
1694 
1695         // The minimum absolute borrow value of an account
1696         // There must be sufficient incentivize to liquidate undercollateralized accounts
1697         Monetary.Value minBorrowedValue;
1698     }
1699 
1700     // The maximum RiskParam values that can be set
1701     struct RiskLimits {
1702         uint64 marginRatioMax;
1703         uint64 liquidationSpreadMax;
1704         uint64 earningsRateMax;
1705         uint64 marginPremiumMax;
1706         uint64 spreadPremiumMax;
1707         uint128 minBorrowedValueMax;
1708     }
1709 
1710     // The entire storage state of Solo
1711     struct State {
1712         // number of markets
1713         uint256 numMarkets;
1714 
1715         // marketId => Market
1716         mapping (uint256 => Market) markets;
1717 
1718         // owner => account number => Account
1719         mapping (address => mapping (uint256 => Account.Storage)) accounts;
1720 
1721         // Addresses that can control other users accounts
1722         mapping (address => mapping (address => bool)) operators;
1723 
1724         // Addresses that can control all users accounts
1725         mapping (address => bool) globalOperators;
1726 
1727         // mutable risk parameters of the system
1728         RiskParams riskParams;
1729 
1730         // immutable risk limits of the system
1731         RiskLimits riskLimits;
1732     }
1733 
1734     // ============ Functions ============
1735 
1736     function getToken(
1737         Storage.State storage state,
1738         uint256 marketId
1739     )
1740         internal
1741         view
1742         returns (address)
1743     {
1744         return state.markets[marketId].token;
1745     }
1746 
1747     function getTotalPar(
1748         Storage.State storage state,
1749         uint256 marketId
1750     )
1751         internal
1752         view
1753         returns (Types.TotalPar memory)
1754     {
1755         return state.markets[marketId].totalPar;
1756     }
1757 
1758     function getIndex(
1759         Storage.State storage state,
1760         uint256 marketId
1761     )
1762         internal
1763         view
1764         returns (Interest.Index memory)
1765     {
1766         return state.markets[marketId].index;
1767     }
1768 
1769     function getNumExcessTokens(
1770         Storage.State storage state,
1771         uint256 marketId
1772     )
1773         internal
1774         view
1775         returns (Types.Wei memory)
1776     {
1777         Interest.Index memory index = state.getIndex(marketId);
1778         Types.TotalPar memory totalPar = state.getTotalPar(marketId);
1779 
1780         address token = state.getToken(marketId);
1781 
1782         Types.Wei memory balanceWei = Types.Wei({
1783             sign: true,
1784             value: Token.balanceOf(token, address(this))
1785         });
1786 
1787         (
1788             Types.Wei memory supplyWei,
1789             Types.Wei memory borrowWei
1790         ) = Interest.totalParToWei(totalPar, index);
1791 
1792         // borrowWei is negative, so subtracting it makes the value more positive
1793         return balanceWei.sub(borrowWei).sub(supplyWei);
1794     }
1795 
1796     function getStatus(
1797         Storage.State storage state,
1798         Account.Info memory account
1799     )
1800         internal
1801         view
1802         returns (Account.Status)
1803     {
1804         return state.accounts[account.owner][account.number].status;
1805     }
1806 
1807     function getPar(
1808         Storage.State storage state,
1809         Account.Info memory account,
1810         uint256 marketId
1811     )
1812         internal
1813         view
1814         returns (Types.Par memory)
1815     {
1816         return state.accounts[account.owner][account.number].balances[marketId];
1817     }
1818 
1819     function getWei(
1820         Storage.State storage state,
1821         Account.Info memory account,
1822         uint256 marketId
1823     )
1824         internal
1825         view
1826         returns (Types.Wei memory)
1827     {
1828         Types.Par memory par = state.getPar(account, marketId);
1829 
1830         if (par.isZero()) {
1831             return Types.zeroWei();
1832         }
1833 
1834         Interest.Index memory index = state.getIndex(marketId);
1835         return Interest.parToWei(par, index);
1836     }
1837 
1838     function getLiquidationSpreadForPair(
1839         Storage.State storage state,
1840         uint256 heldMarketId,
1841         uint256 owedMarketId
1842     )
1843         internal
1844         view
1845         returns (Decimal.D256 memory)
1846     {
1847         uint256 result = state.riskParams.liquidationSpread.value;
1848         result = Decimal.mul(result, Decimal.onePlus(state.markets[heldMarketId].spreadPremium));
1849         result = Decimal.mul(result, Decimal.onePlus(state.markets[owedMarketId].spreadPremium));
1850         return Decimal.D256({
1851             value: result
1852         });
1853     }
1854 
1855     function fetchNewIndex(
1856         Storage.State storage state,
1857         uint256 marketId,
1858         Interest.Index memory index
1859     )
1860         internal
1861         view
1862         returns (Interest.Index memory)
1863     {
1864         Interest.Rate memory rate = state.fetchInterestRate(marketId, index);
1865 
1866         return Interest.calculateNewIndex(
1867             index,
1868             rate,
1869             state.getTotalPar(marketId),
1870             state.riskParams.earningsRate
1871         );
1872     }
1873 
1874     function fetchInterestRate(
1875         Storage.State storage state,
1876         uint256 marketId,
1877         Interest.Index memory index
1878     )
1879         internal
1880         view
1881         returns (Interest.Rate memory)
1882     {
1883         Types.TotalPar memory totalPar = state.getTotalPar(marketId);
1884         (
1885             Types.Wei memory supplyWei,
1886             Types.Wei memory borrowWei
1887         ) = Interest.totalParToWei(totalPar, index);
1888 
1889         Interest.Rate memory rate = state.markets[marketId].interestSetter.getInterestRate(
1890             state.getToken(marketId),
1891             borrowWei.value,
1892             supplyWei.value
1893         );
1894 
1895         return rate;
1896     }
1897 
1898     function fetchPrice(
1899         Storage.State storage state,
1900         uint256 marketId
1901     )
1902         internal
1903         view
1904         returns (Monetary.Price memory)
1905     {
1906         IPriceOracle oracle = IPriceOracle(state.markets[marketId].priceOracle);
1907         Monetary.Price memory price = oracle.getPrice(state.getToken(marketId));
1908         Require.that(
1909             price.value != 0,
1910             FILE,
1911             "Price cannot be zero",
1912             marketId
1913         );
1914         return price;
1915     }
1916 
1917     function getAccountValues(
1918         Storage.State storage state,
1919         Account.Info memory account,
1920         Cache.MarketCache memory cache,
1921         bool adjustForLiquidity
1922     )
1923         internal
1924         view
1925         returns (Monetary.Value memory, Monetary.Value memory)
1926     {
1927         Monetary.Value memory supplyValue;
1928         Monetary.Value memory borrowValue;
1929 
1930         uint256 numMarkets = cache.getNumMarkets();
1931         for (uint256 m = 0; m < numMarkets; m++) {
1932             if (!cache.hasMarket(m)) {
1933                 continue;
1934             }
1935 
1936             Types.Wei memory userWei = state.getWei(account, m);
1937 
1938             if (userWei.isZero()) {
1939                 continue;
1940             }
1941 
1942             uint256 assetValue = userWei.value.mul(cache.getPrice(m).value);
1943             Decimal.D256 memory adjust = Decimal.one();
1944             if (adjustForLiquidity) {
1945                 adjust = Decimal.onePlus(state.markets[m].marginPremium);
1946             }
1947 
1948             if (userWei.sign) {
1949                 supplyValue.value = supplyValue.value.add(Decimal.div(assetValue, adjust));
1950             } else {
1951                 borrowValue.value = borrowValue.value.add(Decimal.mul(assetValue, adjust));
1952             }
1953         }
1954 
1955         return (supplyValue, borrowValue);
1956     }
1957 
1958     function isCollateralized(
1959         Storage.State storage state,
1960         Account.Info memory account,
1961         Cache.MarketCache memory cache,
1962         bool requireMinBorrow
1963     )
1964         internal
1965         view
1966         returns (bool)
1967     {
1968         // get account values (adjusted for liquidity)
1969         (
1970             Monetary.Value memory supplyValue,
1971             Monetary.Value memory borrowValue
1972         ) = state.getAccountValues(account, cache, /* adjustForLiquidity = */ true);
1973 
1974         if (borrowValue.value == 0) {
1975             return true;
1976         }
1977 
1978         if (requireMinBorrow) {
1979             Require.that(
1980                 borrowValue.value >= state.riskParams.minBorrowedValue.value,
1981                 FILE,
1982                 "Borrow value too low",
1983                 account.owner,
1984                 account.number,
1985                 borrowValue.value
1986             );
1987         }
1988 
1989         uint256 requiredMargin = Decimal.mul(borrowValue.value, state.riskParams.marginRatio);
1990 
1991         return supplyValue.value >= borrowValue.value.add(requiredMargin);
1992     }
1993 
1994     function isGlobalOperator(
1995         Storage.State storage state,
1996         address operator
1997     )
1998         internal
1999         view
2000         returns (bool)
2001     {
2002         return state.globalOperators[operator];
2003     }
2004 
2005     function isLocalOperator(
2006         Storage.State storage state,
2007         address owner,
2008         address operator
2009     )
2010         internal
2011         view
2012         returns (bool)
2013     {
2014         return state.operators[owner][operator];
2015     }
2016 
2017     function requireIsOperator(
2018         Storage.State storage state,
2019         Account.Info memory account,
2020         address operator
2021     )
2022         internal
2023         view
2024     {
2025         bool isValidOperator =
2026             operator == account.owner
2027             || state.isGlobalOperator(operator)
2028             || state.isLocalOperator(account.owner, operator);
2029 
2030         Require.that(
2031             isValidOperator,
2032             FILE,
2033             "Unpermissioned operator",
2034             operator
2035         );
2036     }
2037 
2038     /**
2039      * Determine and set an account's balance based on the intended balance change. Return the
2040      * equivalent amount in wei
2041      */
2042     function getNewParAndDeltaWei(
2043         Storage.State storage state,
2044         Account.Info memory account,
2045         uint256 marketId,
2046         Types.AssetAmount memory amount
2047     )
2048         internal
2049         view
2050         returns (Types.Par memory, Types.Wei memory)
2051     {
2052         Types.Par memory oldPar = state.getPar(account, marketId);
2053 
2054         if (amount.value == 0 && amount.ref == Types.AssetReference.Delta) {
2055             return (oldPar, Types.zeroWei());
2056         }
2057 
2058         Interest.Index memory index = state.getIndex(marketId);
2059         Types.Wei memory oldWei = Interest.parToWei(oldPar, index);
2060         Types.Par memory newPar;
2061         Types.Wei memory deltaWei;
2062 
2063         if (amount.denomination == Types.AssetDenomination.Wei) {
2064             deltaWei = Types.Wei({
2065                 sign: amount.sign,
2066                 value: amount.value
2067             });
2068             if (amount.ref == Types.AssetReference.Target) {
2069                 deltaWei = deltaWei.sub(oldWei);
2070             }
2071             newPar = Interest.weiToPar(oldWei.add(deltaWei), index);
2072         } else { // AssetDenomination.Par
2073             newPar = Types.Par({
2074                 sign: amount.sign,
2075                 value: amount.value.to128()
2076             });
2077             if (amount.ref == Types.AssetReference.Delta) {
2078                 newPar = oldPar.add(newPar);
2079             }
2080             deltaWei = Interest.parToWei(newPar, index).sub(oldWei);
2081         }
2082 
2083         return (newPar, deltaWei);
2084     }
2085 
2086     function getNewParAndDeltaWeiForLiquidation(
2087         Storage.State storage state,
2088         Account.Info memory account,
2089         uint256 marketId,
2090         Types.AssetAmount memory amount
2091     )
2092         internal
2093         view
2094         returns (Types.Par memory, Types.Wei memory)
2095     {
2096         Types.Par memory oldPar = state.getPar(account, marketId);
2097 
2098         Require.that(
2099             !oldPar.isPositive(),
2100             FILE,
2101             "Owed balance cannot be positive",
2102             account.owner,
2103             account.number,
2104             marketId
2105         );
2106 
2107         (
2108             Types.Par memory newPar,
2109             Types.Wei memory deltaWei
2110         ) = state.getNewParAndDeltaWei(
2111             account,
2112             marketId,
2113             amount
2114         );
2115 
2116         // if attempting to over-repay the owed asset, bound it by the maximum
2117         if (newPar.isPositive()) {
2118             newPar = Types.zeroPar();
2119             deltaWei = state.getWei(account, marketId).negative();
2120         }
2121 
2122         Require.that(
2123             !deltaWei.isNegative() && oldPar.value >= newPar.value,
2124             FILE,
2125             "Owed balance cannot increase",
2126             account.owner,
2127             account.number,
2128             marketId
2129         );
2130 
2131         // if not paying back enough wei to repay any par, then bound wei to zero
2132         if (oldPar.equals(newPar)) {
2133             deltaWei = Types.zeroWei();
2134         }
2135 
2136         return (newPar, deltaWei);
2137     }
2138 
2139     function isVaporizable(
2140         Storage.State storage state,
2141         Account.Info memory account,
2142         Cache.MarketCache memory cache
2143     )
2144         internal
2145         view
2146         returns (bool)
2147     {
2148         bool hasNegative = false;
2149         uint256 numMarkets = cache.getNumMarkets();
2150         for (uint256 m = 0; m < numMarkets; m++) {
2151             if (!cache.hasMarket(m)) {
2152                 continue;
2153             }
2154             Types.Par memory par = state.getPar(account, m);
2155             if (par.isZero()) {
2156                 continue;
2157             } else if (par.sign) {
2158                 return false;
2159             } else {
2160                 hasNegative = true;
2161             }
2162         }
2163         return hasNegative;
2164     }
2165 
2166     // =============== Setter Functions ===============
2167 
2168     function updateIndex(
2169         Storage.State storage state,
2170         uint256 marketId
2171     )
2172         internal
2173         returns (Interest.Index memory)
2174     {
2175         Interest.Index memory index = state.getIndex(marketId);
2176         if (index.lastUpdate == Time.currentTime()) {
2177             return index;
2178         }
2179         return state.markets[marketId].index = state.fetchNewIndex(marketId, index);
2180     }
2181 
2182     function setStatus(
2183         Storage.State storage state,
2184         Account.Info memory account,
2185         Account.Status status
2186     )
2187         internal
2188     {
2189         state.accounts[account.owner][account.number].status = status;
2190     }
2191 
2192     function setPar(
2193         Storage.State storage state,
2194         Account.Info memory account,
2195         uint256 marketId,
2196         Types.Par memory newPar
2197     )
2198         internal
2199     {
2200         Types.Par memory oldPar = state.getPar(account, marketId);
2201 
2202         if (Types.equals(oldPar, newPar)) {
2203             return;
2204         }
2205 
2206         // updateTotalPar
2207         Types.TotalPar memory totalPar = state.getTotalPar(marketId);
2208 
2209         // roll-back oldPar
2210         if (oldPar.sign) {
2211             totalPar.supply = uint256(totalPar.supply).sub(oldPar.value).to128();
2212         } else {
2213             totalPar.borrow = uint256(totalPar.borrow).sub(oldPar.value).to128();
2214         }
2215 
2216         // roll-forward newPar
2217         if (newPar.sign) {
2218             totalPar.supply = uint256(totalPar.supply).add(newPar.value).to128();
2219         } else {
2220             totalPar.borrow = uint256(totalPar.borrow).add(newPar.value).to128();
2221         }
2222 
2223         state.markets[marketId].totalPar = totalPar;
2224         state.accounts[account.owner][account.number].balances[marketId] = newPar;
2225     }
2226 
2227     /**
2228      * Determine and set an account's balance based on a change in wei
2229      */
2230     function setParFromDeltaWei(
2231         Storage.State storage state,
2232         Account.Info memory account,
2233         uint256 marketId,
2234         Types.Wei memory deltaWei
2235     )
2236         internal
2237     {
2238         if (deltaWei.isZero()) {
2239             return;
2240         }
2241         Interest.Index memory index = state.getIndex(marketId);
2242         Types.Wei memory oldWei = state.getWei(account, marketId);
2243         Types.Wei memory newWei = oldWei.add(deltaWei);
2244         Types.Par memory newPar = Interest.weiToPar(newWei, index);
2245         state.setPar(
2246             account,
2247             marketId,
2248             newPar
2249         );
2250     }
2251 }
2252 
2253 // File: contracts/protocol/State.sol
2254 
2255 /**
2256  * @title State
2257  * @author dYdX
2258  *
2259  * Base-level contract that holds the state of Solo
2260  */
2261 contract State
2262 {
2263     Storage.State g_state;
2264 }
2265 
2266 // File: contracts/protocol/impl/AdminImpl.sol
2267 
2268 /**
2269  * @title AdminImpl
2270  * @author dYdX
2271  *
2272  * Administrative functions to keep the protocol updated
2273  */
2274 library AdminImpl {
2275     using Storage for Storage.State;
2276     using Token for address;
2277     using Types for Types.Wei;
2278 
2279     // ============ Constants ============
2280 
2281     bytes32 constant FILE = "AdminImpl";
2282 
2283     // ============ Events ============
2284 
2285     event LogWithdrawExcessTokens(
2286         address token,
2287         uint256 amount
2288     );
2289 
2290     event LogAddMarket(
2291         uint256 marketId,
2292         address token
2293     );
2294 
2295     event LogSetIsClosing(
2296         uint256 marketId,
2297         bool isClosing
2298     );
2299 
2300     event LogSetPriceOracle(
2301         uint256 marketId,
2302         address priceOracle
2303     );
2304 
2305     event LogSetInterestSetter(
2306         uint256 marketId,
2307         address interestSetter
2308     );
2309 
2310     event LogSetMarginPremium(
2311         uint256 marketId,
2312         Decimal.D256 marginPremium
2313     );
2314 
2315     event LogSetSpreadPremium(
2316         uint256 marketId,
2317         Decimal.D256 spreadPremium
2318     );
2319 
2320     event LogSetMarginRatio(
2321         Decimal.D256 marginRatio
2322     );
2323 
2324     event LogSetLiquidationSpread(
2325         Decimal.D256 liquidationSpread
2326     );
2327 
2328     event LogSetEarningsRate(
2329         Decimal.D256 earningsRate
2330     );
2331 
2332     event LogSetMinBorrowedValue(
2333         Monetary.Value minBorrowedValue
2334     );
2335 
2336     event LogSetGlobalOperator(
2337         address operator,
2338         bool approved
2339     );
2340 
2341     // ============ Token Functions ============
2342 
2343     function ownerWithdrawExcessTokens(
2344         Storage.State storage state,
2345         uint256 marketId,
2346         address recipient
2347     )
2348         public
2349         returns (uint256)
2350     {
2351         _validateMarketId(state, marketId);
2352         Types.Wei memory excessWei = state.getNumExcessTokens(marketId);
2353 
2354         Require.that(
2355             !excessWei.isNegative(),
2356             FILE,
2357             "Negative excess"
2358         );
2359 
2360         address token = state.getToken(marketId);
2361 
2362         uint256 actualBalance = token.balanceOf(address(this));
2363         if (excessWei.value > actualBalance) {
2364             excessWei.value = actualBalance;
2365         }
2366 
2367         token.transfer(recipient, excessWei.value);
2368 
2369         emit LogWithdrawExcessTokens(token, excessWei.value);
2370 
2371         return excessWei.value;
2372     }
2373 
2374     function ownerWithdrawUnsupportedTokens(
2375         Storage.State storage state,
2376         address token,
2377         address recipient
2378     )
2379         public
2380         returns (uint256)
2381     {
2382         _requireNoMarket(state, token);
2383 
2384         uint256 balance = token.balanceOf(address(this));
2385         token.transfer(recipient, balance);
2386 
2387         emit LogWithdrawExcessTokens(token, balance);
2388 
2389         return balance;
2390     }
2391 
2392     // ============ Market Functions ============
2393 
2394     function ownerAddMarket(
2395         Storage.State storage state,
2396         address token,
2397         IPriceOracle priceOracle,
2398         IInterestSetter interestSetter,
2399         Decimal.D256 memory marginPremium,
2400         Decimal.D256 memory spreadPremium
2401     )
2402         public
2403     {
2404         _requireNoMarket(state, token);
2405 
2406         uint256 marketId = state.numMarkets;
2407 
2408         state.numMarkets++;
2409         state.markets[marketId].token = token;
2410         state.markets[marketId].index = Interest.newIndex();
2411 
2412         emit LogAddMarket(marketId, token);
2413 
2414         _setPriceOracle(state, marketId, priceOracle);
2415         _setInterestSetter(state, marketId, interestSetter);
2416         _setMarginPremium(state, marketId, marginPremium);
2417         _setSpreadPremium(state, marketId, spreadPremium);
2418     }
2419 
2420     function ownerSetIsClosing(
2421         Storage.State storage state,
2422         uint256 marketId,
2423         bool isClosing
2424     )
2425         public
2426     {
2427         _validateMarketId(state, marketId);
2428         state.markets[marketId].isClosing = isClosing;
2429         emit LogSetIsClosing(marketId, isClosing);
2430     }
2431 
2432     function ownerSetPriceOracle(
2433         Storage.State storage state,
2434         uint256 marketId,
2435         IPriceOracle priceOracle
2436     )
2437         public
2438     {
2439         _validateMarketId(state, marketId);
2440         _setPriceOracle(state, marketId, priceOracle);
2441     }
2442 
2443     function ownerSetInterestSetter(
2444         Storage.State storage state,
2445         uint256 marketId,
2446         IInterestSetter interestSetter
2447     )
2448         public
2449     {
2450         _validateMarketId(state, marketId);
2451         _setInterestSetter(state, marketId, interestSetter);
2452     }
2453 
2454     function ownerSetMarginPremium(
2455         Storage.State storage state,
2456         uint256 marketId,
2457         Decimal.D256 memory marginPremium
2458     )
2459         public
2460     {
2461         _validateMarketId(state, marketId);
2462         _setMarginPremium(state, marketId, marginPremium);
2463     }
2464 
2465     function ownerSetSpreadPremium(
2466         Storage.State storage state,
2467         uint256 marketId,
2468         Decimal.D256 memory spreadPremium
2469     )
2470         public
2471     {
2472         _validateMarketId(state, marketId);
2473         _setSpreadPremium(state, marketId, spreadPremium);
2474     }
2475 
2476     // ============ Risk Functions ============
2477 
2478     function ownerSetMarginRatio(
2479         Storage.State storage state,
2480         Decimal.D256 memory ratio
2481     )
2482         public
2483     {
2484         Require.that(
2485             ratio.value <= state.riskLimits.marginRatioMax,
2486             FILE,
2487             "Ratio too high"
2488         );
2489         Require.that(
2490             ratio.value > state.riskParams.liquidationSpread.value,
2491             FILE,
2492             "Ratio cannot be <= spread"
2493         );
2494         state.riskParams.marginRatio = ratio;
2495         emit LogSetMarginRatio(ratio);
2496     }
2497 
2498     function ownerSetLiquidationSpread(
2499         Storage.State storage state,
2500         Decimal.D256 memory spread
2501     )
2502         public
2503     {
2504         Require.that(
2505             spread.value <= state.riskLimits.liquidationSpreadMax,
2506             FILE,
2507             "Spread too high"
2508         );
2509         Require.that(
2510             spread.value < state.riskParams.marginRatio.value,
2511             FILE,
2512             "Spread cannot be >= ratio"
2513         );
2514         state.riskParams.liquidationSpread = spread;
2515         emit LogSetLiquidationSpread(spread);
2516     }
2517 
2518     function ownerSetEarningsRate(
2519         Storage.State storage state,
2520         Decimal.D256 memory earningsRate
2521     )
2522         public
2523     {
2524         Require.that(
2525             earningsRate.value <= state.riskLimits.earningsRateMax,
2526             FILE,
2527             "Rate too high"
2528         );
2529         state.riskParams.earningsRate = earningsRate;
2530         emit LogSetEarningsRate(earningsRate);
2531     }
2532 
2533     function ownerSetMinBorrowedValue(
2534         Storage.State storage state,
2535         Monetary.Value memory minBorrowedValue
2536     )
2537         public
2538     {
2539         Require.that(
2540             minBorrowedValue.value <= state.riskLimits.minBorrowedValueMax,
2541             FILE,
2542             "Value too high"
2543         );
2544         state.riskParams.minBorrowedValue = minBorrowedValue;
2545         emit LogSetMinBorrowedValue(minBorrowedValue);
2546     }
2547 
2548     // ============ Global Operator Functions ============
2549 
2550     function ownerSetGlobalOperator(
2551         Storage.State storage state,
2552         address operator,
2553         bool approved
2554     )
2555         public
2556     {
2557         state.globalOperators[operator] = approved;
2558 
2559         emit LogSetGlobalOperator(operator, approved);
2560     }
2561 
2562     // ============ Private Functions ============
2563 
2564     function _setPriceOracle(
2565         Storage.State storage state,
2566         uint256 marketId,
2567         IPriceOracle priceOracle
2568     )
2569         private
2570     {
2571         // require oracle can return non-zero price
2572         address token = state.markets[marketId].token;
2573 
2574         Require.that(
2575             priceOracle.getPrice(token).value != 0,
2576             FILE,
2577             "Invalid oracle price"
2578         );
2579 
2580         state.markets[marketId].priceOracle = priceOracle;
2581 
2582         emit LogSetPriceOracle(marketId, address(priceOracle));
2583     }
2584 
2585     function _setInterestSetter(
2586         Storage.State storage state,
2587         uint256 marketId,
2588         IInterestSetter interestSetter
2589     )
2590         private
2591     {
2592         // ensure interestSetter can return a value without reverting
2593         address token = state.markets[marketId].token;
2594         interestSetter.getInterestRate(token, 0, 0);
2595 
2596         state.markets[marketId].interestSetter = interestSetter;
2597 
2598         emit LogSetInterestSetter(marketId, address(interestSetter));
2599     }
2600 
2601     function _setMarginPremium(
2602         Storage.State storage state,
2603         uint256 marketId,
2604         Decimal.D256 memory marginPremium
2605     )
2606         private
2607     {
2608         Require.that(
2609             marginPremium.value <= state.riskLimits.marginPremiumMax,
2610             FILE,
2611             "Margin premium too high"
2612         );
2613         state.markets[marketId].marginPremium = marginPremium;
2614 
2615         emit LogSetMarginPremium(marketId, marginPremium);
2616     }
2617 
2618     function _setSpreadPremium(
2619         Storage.State storage state,
2620         uint256 marketId,
2621         Decimal.D256 memory spreadPremium
2622     )
2623         private
2624     {
2625         Require.that(
2626             spreadPremium.value <= state.riskLimits.spreadPremiumMax,
2627             FILE,
2628             "Spread premium too high"
2629         );
2630         state.markets[marketId].spreadPremium = spreadPremium;
2631 
2632         emit LogSetSpreadPremium(marketId, spreadPremium);
2633     }
2634 
2635     function _requireNoMarket(
2636         Storage.State storage state,
2637         address token
2638     )
2639         private
2640         view
2641     {
2642         uint256 numMarkets = state.numMarkets;
2643 
2644         bool marketExists = false;
2645 
2646         for (uint256 m = 0; m < numMarkets; m++) {
2647             if (state.markets[m].token == token) {
2648                 marketExists = true;
2649                 break;
2650             }
2651         }
2652 
2653         Require.that(
2654             !marketExists,
2655             FILE,
2656             "Market exists"
2657         );
2658     }
2659 
2660     function _validateMarketId(
2661         Storage.State storage state,
2662         uint256 marketId
2663     )
2664         private
2665         view
2666     {
2667         Require.that(
2668             marketId < state.numMarkets,
2669             FILE,
2670             "Market OOB",
2671             marketId
2672         );
2673     }
2674 }
2675 
2676 // File: contracts/protocol/Admin.sol
2677 
2678 /**
2679  * @title Admin
2680  * @author dYdX
2681  *
2682  * Public functions that allow the privileged owner address to manage Solo
2683  */
2684 contract Admin is
2685     State,
2686     Ownable,
2687     ReentrancyGuard
2688 {
2689     // ============ Token Functions ============
2690 
2691     /**
2692      * Withdraw an ERC20 token for which there is an associated market. Only excess tokens can be
2693      * withdrawn. The number of excess tokens is calculated by taking the current number of tokens
2694      * held in Solo, adding the number of tokens owed to Solo by borrowers, and subtracting the
2695      * number of tokens owed to suppliers by Solo.
2696      */
2697     function ownerWithdrawExcessTokens(
2698         uint256 marketId,
2699         address recipient
2700     )
2701         public
2702         onlyOwner
2703         nonReentrant
2704         returns (uint256)
2705     {
2706         return AdminImpl.ownerWithdrawExcessTokens(
2707             g_state,
2708             marketId,
2709             recipient
2710         );
2711     }
2712 
2713     /**
2714      * Withdraw an ERC20 token for which there is no associated market.
2715      */
2716     function ownerWithdrawUnsupportedTokens(
2717         address token,
2718         address recipient
2719     )
2720         public
2721         onlyOwner
2722         nonReentrant
2723         returns (uint256)
2724     {
2725         return AdminImpl.ownerWithdrawUnsupportedTokens(
2726             g_state,
2727             token,
2728             recipient
2729         );
2730     }
2731 
2732     // ============ Market Functions ============
2733 
2734     /**
2735      * Add a new market to Solo. Must be for a previously-unsupported ERC20 token.
2736      */
2737     function ownerAddMarket(
2738         address token,
2739         IPriceOracle priceOracle,
2740         IInterestSetter interestSetter,
2741         Decimal.D256 memory marginPremium,
2742         Decimal.D256 memory spreadPremium
2743     )
2744         public
2745         onlyOwner
2746         nonReentrant
2747     {
2748         AdminImpl.ownerAddMarket(
2749             g_state,
2750             token,
2751             priceOracle,
2752             interestSetter,
2753             marginPremium,
2754             spreadPremium
2755         );
2756     }
2757 
2758     /**
2759      * Set (or unset) the status of a market to "closing". The borrowedValue of a market cannot
2760      * increase while its status is "closing".
2761      */
2762     function ownerSetIsClosing(
2763         uint256 marketId,
2764         bool isClosing
2765     )
2766         public
2767         onlyOwner
2768         nonReentrant
2769     {
2770         AdminImpl.ownerSetIsClosing(
2771             g_state,
2772             marketId,
2773             isClosing
2774         );
2775     }
2776 
2777     /**
2778      * Set the price oracle for a market.
2779      */
2780     function ownerSetPriceOracle(
2781         uint256 marketId,
2782         IPriceOracle priceOracle
2783     )
2784         public
2785         onlyOwner
2786         nonReentrant
2787     {
2788         AdminImpl.ownerSetPriceOracle(
2789             g_state,
2790             marketId,
2791             priceOracle
2792         );
2793     }
2794 
2795     /**
2796      * Set the interest-setter for a market.
2797      */
2798     function ownerSetInterestSetter(
2799         uint256 marketId,
2800         IInterestSetter interestSetter
2801     )
2802         public
2803         onlyOwner
2804         nonReentrant
2805     {
2806         AdminImpl.ownerSetInterestSetter(
2807             g_state,
2808             marketId,
2809             interestSetter
2810         );
2811     }
2812 
2813     /**
2814      * Set a premium on the minimum margin-ratio for a market. This makes it so that any positions
2815      * that include this market require a higher collateralization to avoid being liquidated.
2816      */
2817     function ownerSetMarginPremium(
2818         uint256 marketId,
2819         Decimal.D256 memory marginPremium
2820     )
2821         public
2822         onlyOwner
2823         nonReentrant
2824     {
2825         AdminImpl.ownerSetMarginPremium(
2826             g_state,
2827             marketId,
2828             marginPremium
2829         );
2830     }
2831 
2832     /**
2833      * Set a premium on the liquidation spread for a market. This makes it so that any liquidations
2834      * that include this market have a higher spread than the global default.
2835      */
2836     function ownerSetSpreadPremium(
2837         uint256 marketId,
2838         Decimal.D256 memory spreadPremium
2839     )
2840         public
2841         onlyOwner
2842         nonReentrant
2843     {
2844         AdminImpl.ownerSetSpreadPremium(
2845             g_state,
2846             marketId,
2847             spreadPremium
2848         );
2849     }
2850 
2851     // ============ Risk Functions ============
2852 
2853     /**
2854      * Set the global minimum margin-ratio that every position must maintain to prevent being
2855      * liquidated.
2856      */
2857     function ownerSetMarginRatio(
2858         Decimal.D256 memory ratio
2859     )
2860         public
2861         onlyOwner
2862         nonReentrant
2863     {
2864         AdminImpl.ownerSetMarginRatio(
2865             g_state,
2866             ratio
2867         );
2868     }
2869 
2870     /**
2871      * Set the global liquidation spread. This is the spread between oracle prices that incentivizes
2872      * the liquidation of risky positions.
2873      */
2874     function ownerSetLiquidationSpread(
2875         Decimal.D256 memory spread
2876     )
2877         public
2878         onlyOwner
2879         nonReentrant
2880     {
2881         AdminImpl.ownerSetLiquidationSpread(
2882             g_state,
2883             spread
2884         );
2885     }
2886 
2887     /**
2888      * Set the global earnings-rate variable that determines what percentage of the interest paid
2889      * by borrowers gets passed-on to suppliers.
2890      */
2891     function ownerSetEarningsRate(
2892         Decimal.D256 memory earningsRate
2893     )
2894         public
2895         onlyOwner
2896         nonReentrant
2897     {
2898         AdminImpl.ownerSetEarningsRate(
2899             g_state,
2900             earningsRate
2901         );
2902     }
2903 
2904     /**
2905      * Set the global minimum-borrow value which is the minimum value of any new borrow on Solo.
2906      */
2907     function ownerSetMinBorrowedValue(
2908         Monetary.Value memory minBorrowedValue
2909     )
2910         public
2911         onlyOwner
2912         nonReentrant
2913     {
2914         AdminImpl.ownerSetMinBorrowedValue(
2915             g_state,
2916             minBorrowedValue
2917         );
2918     }
2919 
2920     // ============ Global Operator Functions ============
2921 
2922     /**
2923      * Approve (or disapprove) an address that is permissioned to be an operator for all accounts in
2924      * Solo. Intended only to approve smart-contracts.
2925      */
2926     function ownerSetGlobalOperator(
2927         address operator,
2928         bool approved
2929     )
2930         public
2931         onlyOwner
2932         nonReentrant
2933     {
2934         AdminImpl.ownerSetGlobalOperator(
2935             g_state,
2936             operator,
2937             approved
2938         );
2939     }
2940 }
2941 
2942 // File: contracts/protocol/Getters.sol
2943 
2944 /**
2945  * @title Getters
2946  * @author dYdX
2947  *
2948  * Public read-only functions that allow transparency into the state of Solo
2949  */
2950 contract Getters is
2951     State
2952 {
2953     using Cache for Cache.MarketCache;
2954     using Storage for Storage.State;
2955     using Types for Types.Par;
2956 
2957     // ============ Constants ============
2958 
2959     bytes32 FILE = "Getters";
2960 
2961     // ============ Getters for Risk ============
2962 
2963     /**
2964      * Get the global minimum margin-ratio that every position must maintain to prevent being
2965      * liquidated.
2966      *
2967      * @return  The global margin-ratio
2968      */
2969     function getMarginRatio()
2970         public
2971         view
2972         returns (Decimal.D256 memory)
2973     {
2974         return g_state.riskParams.marginRatio;
2975     }
2976 
2977     /**
2978      * Get the global liquidation spread. This is the spread between oracle prices that incentivizes
2979      * the liquidation of risky positions.
2980      *
2981      * @return  The global liquidation spread
2982      */
2983     function getLiquidationSpread()
2984         public
2985         view
2986         returns (Decimal.D256 memory)
2987     {
2988         return g_state.riskParams.liquidationSpread;
2989     }
2990 
2991     /**
2992      * Get the global earnings-rate variable that determines what percentage of the interest paid
2993      * by borrowers gets passed-on to suppliers.
2994      *
2995      * @return  The global earnings rate
2996      */
2997     function getEarningsRate()
2998         public
2999         view
3000         returns (Decimal.D256 memory)
3001     {
3002         return g_state.riskParams.earningsRate;
3003     }
3004 
3005     /**
3006      * Get the global minimum-borrow value which is the minimum value of any new borrow on Solo.
3007      *
3008      * @return  The global minimum borrow value
3009      */
3010     function getMinBorrowedValue()
3011         public
3012         view
3013         returns (Monetary.Value memory)
3014     {
3015         return g_state.riskParams.minBorrowedValue;
3016     }
3017 
3018     /**
3019      * Get all risk parameters in a single struct.
3020      *
3021      * @return  All global risk parameters
3022      */
3023     function getRiskParams()
3024         public
3025         view
3026         returns (Storage.RiskParams memory)
3027     {
3028         return g_state.riskParams;
3029     }
3030 
3031     /**
3032      * Get all risk parameter limits in a single struct. These are the maximum limits at which the
3033      * risk parameters can be set by the admin of Solo.
3034      *
3035      * @return  All global risk parameter limnits
3036      */
3037     function getRiskLimits()
3038         public
3039         view
3040         returns (Storage.RiskLimits memory)
3041     {
3042         return g_state.riskLimits;
3043     }
3044 
3045     // ============ Getters for Markets ============
3046 
3047     /**
3048      * Get the total number of markets.
3049      *
3050      * @return  The number of markets
3051      */
3052     function getNumMarkets()
3053         public
3054         view
3055         returns (uint256)
3056     {
3057         return g_state.numMarkets;
3058     }
3059 
3060     /**
3061      * Get the ERC20 token address for a market.
3062      *
3063      * @param  marketId  The market to query
3064      * @return           The token address
3065      */
3066     function getMarketTokenAddress(
3067         uint256 marketId
3068     )
3069         public
3070         view
3071         returns (address)
3072     {
3073         _requireValidMarket(marketId);
3074         return g_state.getToken(marketId);
3075     }
3076 
3077     /**
3078      * Get the total principal amounts (borrowed and supplied) for a market.
3079      *
3080      * @param  marketId  The market to query
3081      * @return           The total principal amounts
3082      */
3083     function getMarketTotalPar(
3084         uint256 marketId
3085     )
3086         public
3087         view
3088         returns (Types.TotalPar memory)
3089     {
3090         _requireValidMarket(marketId);
3091         return g_state.getTotalPar(marketId);
3092     }
3093 
3094     /**
3095      * Get the most recently cached interest index for a market.
3096      *
3097      * @param  marketId  The market to query
3098      * @return           The most recent index
3099      */
3100     function getMarketCachedIndex(
3101         uint256 marketId
3102     )
3103         public
3104         view
3105         returns (Interest.Index memory)
3106     {
3107         _requireValidMarket(marketId);
3108         return g_state.getIndex(marketId);
3109     }
3110 
3111     /**
3112      * Get the interest index for a market if it were to be updated right now.
3113      *
3114      * @param  marketId  The market to query
3115      * @return           The estimated current index
3116      */
3117     function getMarketCurrentIndex(
3118         uint256 marketId
3119     )
3120         public
3121         view
3122         returns (Interest.Index memory)
3123     {
3124         _requireValidMarket(marketId);
3125         return g_state.fetchNewIndex(marketId, g_state.getIndex(marketId));
3126     }
3127 
3128     /**
3129      * Get the price oracle address for a market.
3130      *
3131      * @param  marketId  The market to query
3132      * @return           The price oracle address
3133      */
3134     function getMarketPriceOracle(
3135         uint256 marketId
3136     )
3137         public
3138         view
3139         returns (IPriceOracle)
3140     {
3141         _requireValidMarket(marketId);
3142         return g_state.markets[marketId].priceOracle;
3143     }
3144 
3145     /**
3146      * Get the interest-setter address for a market.
3147      *
3148      * @param  marketId  The market to query
3149      * @return           The interest-setter address
3150      */
3151     function getMarketInterestSetter(
3152         uint256 marketId
3153     )
3154         public
3155         view
3156         returns (IInterestSetter)
3157     {
3158         _requireValidMarket(marketId);
3159         return g_state.markets[marketId].interestSetter;
3160     }
3161 
3162     /**
3163      * Get the margin premium for a market. A margin premium makes it so that any positions that
3164      * include the market require a higher collateralization to avoid being liquidated.
3165      *
3166      * @param  marketId  The market to query
3167      * @return           The market's margin premium
3168      */
3169     function getMarketMarginPremium(
3170         uint256 marketId
3171     )
3172         public
3173         view
3174         returns (Decimal.D256 memory)
3175     {
3176         _requireValidMarket(marketId);
3177         return g_state.markets[marketId].marginPremium;
3178     }
3179 
3180     /**
3181      * Get the spread premium for a market. A spread premium makes it so that any liquidations
3182      * that include the market have a higher spread than the global default.
3183      *
3184      * @param  marketId  The market to query
3185      * @return           The market's spread premium
3186      */
3187     function getMarketSpreadPremium(
3188         uint256 marketId
3189     )
3190         public
3191         view
3192         returns (Decimal.D256 memory)
3193     {
3194         _requireValidMarket(marketId);
3195         return g_state.markets[marketId].spreadPremium;
3196     }
3197 
3198     /**
3199      * Return true if a particular market is in closing mode. Additional borrows cannot be taken
3200      * from a market that is closing.
3201      *
3202      * @param  marketId  The market to query
3203      * @return           True if the market is closing
3204      */
3205     function getMarketIsClosing(
3206         uint256 marketId
3207     )
3208         public
3209         view
3210         returns (bool)
3211     {
3212         _requireValidMarket(marketId);
3213         return g_state.markets[marketId].isClosing;
3214     }
3215 
3216     /**
3217      * Get the price of the token for a market.
3218      *
3219      * @param  marketId  The market to query
3220      * @return           The price of each atomic unit of the token
3221      */
3222     function getMarketPrice(
3223         uint256 marketId
3224     )
3225         public
3226         view
3227         returns (Monetary.Price memory)
3228     {
3229         _requireValidMarket(marketId);
3230         return g_state.fetchPrice(marketId);
3231     }
3232 
3233     /**
3234      * Get the current borrower interest rate for a market.
3235      *
3236      * @param  marketId  The market to query
3237      * @return           The current interest rate
3238      */
3239     function getMarketInterestRate(
3240         uint256 marketId
3241     )
3242         public
3243         view
3244         returns (Interest.Rate memory)
3245     {
3246         _requireValidMarket(marketId);
3247         return g_state.fetchInterestRate(
3248             marketId,
3249             g_state.getIndex(marketId)
3250         );
3251     }
3252 
3253     /**
3254      * Get the adjusted liquidation spread for some market pair. This is equal to the global
3255      * liquidation spread multiplied by (1 + spreadPremium) for each of the two markets.
3256      *
3257      * @param  heldMarketId  The market for which the account has collateral
3258      * @param  owedMarketId  The market for which the account has borrowed tokens
3259      * @return               The adjusted liquidation spread
3260      */
3261     function getLiquidationSpreadForPair(
3262         uint256 heldMarketId,
3263         uint256 owedMarketId
3264     )
3265         public
3266         view
3267         returns (Decimal.D256 memory)
3268     {
3269         _requireValidMarket(heldMarketId);
3270         _requireValidMarket(owedMarketId);
3271         return g_state.getLiquidationSpreadForPair(heldMarketId, owedMarketId);
3272     }
3273 
3274     /**
3275      * Get basic information about a particular market.
3276      *
3277      * @param  marketId  The market to query
3278      * @return           A Storage.Market struct with the current state of the market
3279      */
3280     function getMarket(
3281         uint256 marketId
3282     )
3283         public
3284         view
3285         returns (Storage.Market memory)
3286     {
3287         _requireValidMarket(marketId);
3288         return g_state.markets[marketId];
3289     }
3290 
3291     /**
3292      * Get comprehensive information about a particular market.
3293      *
3294      * @param  marketId  The market to query
3295      * @return           A tuple containing the values:
3296      *                    - A Storage.Market struct with the current state of the market
3297      *                    - The current estimated interest index
3298      *                    - The current token price
3299      *                    - The current market interest rate
3300      */
3301     function getMarketWithInfo(
3302         uint256 marketId
3303     )
3304         public
3305         view
3306         returns (
3307             Storage.Market memory,
3308             Interest.Index memory,
3309             Monetary.Price memory,
3310             Interest.Rate memory
3311         )
3312     {
3313         _requireValidMarket(marketId);
3314         return (
3315             getMarket(marketId),
3316             getMarketCurrentIndex(marketId),
3317             getMarketPrice(marketId),
3318             getMarketInterestRate(marketId)
3319         );
3320     }
3321 
3322     /**
3323      * Get the number of excess tokens for a market. The number of excess tokens is calculated
3324      * by taking the current number of tokens held in Solo, adding the number of tokens owed to Solo
3325      * by borrowers, and subtracting the number of tokens owed to suppliers by Solo.
3326      *
3327      * @param  marketId  The market to query
3328      * @return           The number of excess tokens
3329      */
3330     function getNumExcessTokens(
3331         uint256 marketId
3332     )
3333         public
3334         view
3335         returns (Types.Wei memory)
3336     {
3337         _requireValidMarket(marketId);
3338         return g_state.getNumExcessTokens(marketId);
3339     }
3340 
3341     // ============ Getters for Accounts ============
3342 
3343     /**
3344      * Get the principal value for a particular account and market.
3345      *
3346      * @param  account   The account to query
3347      * @param  marketId  The market to query
3348      * @return           The principal value
3349      */
3350     function getAccountPar(
3351         Account.Info memory account,
3352         uint256 marketId
3353     )
3354         public
3355         view
3356         returns (Types.Par memory)
3357     {
3358         _requireValidMarket(marketId);
3359         return g_state.getPar(account, marketId);
3360     }
3361 
3362     /**
3363      * Get the token balance for a particular account and market.
3364      *
3365      * @param  account   The account to query
3366      * @param  marketId  The market to query
3367      * @return           The token amount
3368      */
3369     function getAccountWei(
3370         Account.Info memory account,
3371         uint256 marketId
3372     )
3373         public
3374         view
3375         returns (Types.Wei memory)
3376     {
3377         _requireValidMarket(marketId);
3378         return Interest.parToWei(
3379             g_state.getPar(account, marketId),
3380             g_state.fetchNewIndex(marketId, g_state.getIndex(marketId))
3381         );
3382     }
3383 
3384     /**
3385      * Get the status of an account (Normal, Liquidating, or Vaporizing).
3386      *
3387      * @param  account  The account to query
3388      * @return          The account's status
3389      */
3390     function getAccountStatus(
3391         Account.Info memory account
3392     )
3393         public
3394         view
3395         returns (Account.Status)
3396     {
3397         return g_state.getStatus(account);
3398     }
3399 
3400     /**
3401      * Get the total supplied and total borrowed value of an account.
3402      *
3403      * @param  account  The account to query
3404      * @return          The following values:
3405      *                   - The supplied value of the account
3406      *                   - The borrowed value of the account
3407      */
3408     function getAccountValues(
3409         Account.Info memory account
3410     )
3411         public
3412         view
3413         returns (Monetary.Value memory, Monetary.Value memory)
3414     {
3415         return getAccountValuesInternal(account, /* adjustForLiquidity = */ false);
3416     }
3417 
3418     /**
3419      * Get the total supplied and total borrowed values of an account adjusted by the marginPremium
3420      * of each market. Supplied values are divided by (1 + marginPremium) for each market and
3421      * borrowed values are multiplied by (1 + marginPremium) for each market. Comparing these
3422      * adjusted values gives the margin-ratio of the account which will be compared to the global
3423      * margin-ratio when determining if the account can be liquidated.
3424      *
3425      * @param  account  The account to query
3426      * @return          The following values:
3427      *                   - The supplied value of the account (adjusted for marginPremium)
3428      *                   - The borrowed value of the account (adjusted for marginPremium)
3429      */
3430     function getAdjustedAccountValues(
3431         Account.Info memory account
3432     )
3433         public
3434         view
3435         returns (Monetary.Value memory, Monetary.Value memory)
3436     {
3437         return getAccountValuesInternal(account, /* adjustForLiquidity = */ true);
3438     }
3439 
3440     /**
3441      * Get an account's summary for each market.
3442      *
3443      * @param  account  The account to query
3444      * @return          The following values:
3445      *                   - The ERC20 token address for each market
3446      *                   - The account's principal value for each market
3447      *                   - The account's (supplied or borrowed) number of tokens for each market
3448      */
3449     function getAccountBalances(
3450         Account.Info memory account
3451     )
3452         public
3453         view
3454         returns (
3455             address[] memory,
3456             Types.Par[] memory,
3457             Types.Wei[] memory
3458         )
3459     {
3460         uint256 numMarkets = g_state.numMarkets;
3461         address[] memory tokens = new address[](numMarkets);
3462         Types.Par[] memory pars = new Types.Par[](numMarkets);
3463         Types.Wei[] memory weis = new Types.Wei[](numMarkets);
3464 
3465         for (uint256 m = 0; m < numMarkets; m++) {
3466             tokens[m] = getMarketTokenAddress(m);
3467             pars[m] = getAccountPar(account, m);
3468             weis[m] = getAccountWei(account, m);
3469         }
3470 
3471         return (
3472             tokens,
3473             pars,
3474             weis
3475         );
3476     }
3477 
3478     // ============ Getters for Permissions ============
3479 
3480     /**
3481      * Return true if a particular address is approved as an operator for an owner's accounts.
3482      * Approved operators can act on the accounts of the owner as if it were the operator's own.
3483      *
3484      * @param  owner     The owner of the accounts
3485      * @param  operator  The possible operator
3486      * @return           True if operator is approved for owner's accounts
3487      */
3488     function getIsLocalOperator(
3489         address owner,
3490         address operator
3491     )
3492         public
3493         view
3494         returns (bool)
3495     {
3496         return g_state.isLocalOperator(owner, operator);
3497     }
3498 
3499     /**
3500      * Return true if a particular address is approved as a global operator. Such an address can
3501      * act on any account as if it were the operator's own.
3502      *
3503      * @param  operator  The address to query
3504      * @return           True if operator is a global operator
3505      */
3506     function getIsGlobalOperator(
3507         address operator
3508     )
3509         public
3510         view
3511         returns (bool)
3512     {
3513         return g_state.isGlobalOperator(operator);
3514     }
3515 
3516     // ============ Private Helper Functions ============
3517 
3518     /**
3519      * Revert if marketId is invalid.
3520      */
3521     function _requireValidMarket(
3522         uint256 marketId
3523     )
3524         private
3525         view
3526     {
3527         Require.that(
3528             marketId < g_state.numMarkets,
3529             FILE,
3530             "Market OOB"
3531         );
3532     }
3533 
3534     /**
3535      * Private helper for getting the monetary values of an account.
3536      */
3537     function getAccountValuesInternal(
3538         Account.Info memory account,
3539         bool adjustForLiquidity
3540     )
3541         private
3542         view
3543         returns (Monetary.Value memory, Monetary.Value memory)
3544     {
3545         uint256 numMarkets = g_state.numMarkets;
3546 
3547         // populate cache
3548         Cache.MarketCache memory cache = Cache.create(numMarkets);
3549         for (uint256 m = 0; m < numMarkets; m++) {
3550             if (!g_state.getPar(account, m).isZero()) {
3551                 cache.addMarket(g_state, m);
3552             }
3553         }
3554 
3555         return g_state.getAccountValues(account, cache, adjustForLiquidity);
3556     }
3557 }
3558 
3559 // File: contracts/protocol/interfaces/IAutoTrader.sol
3560 
3561 /**
3562  * @title IAutoTrader
3563  * @author dYdX
3564  *
3565  * Interface that Auto-Traders for Solo must implement in order to approve trades.
3566  */
3567 contract IAutoTrader {
3568 
3569     // ============ Public Functions ============
3570 
3571     /**
3572      * Allows traders to make trades approved by this smart contract. The active trader's account is
3573      * the takerAccount and the passive account (for which this contract approves trades
3574      * on-behalf-of) is the makerAccount.
3575      *
3576      * @param  inputMarketId   The market for which the trader specified the original amount
3577      * @param  outputMarketId  The market for which the trader wants the resulting amount specified
3578      * @param  makerAccount    The account for which this contract is making trades
3579      * @param  takerAccount    The account requesting the trade
3580      * @param  oldInputPar     The old principal amount for the makerAccount for the inputMarketId
3581      * @param  newInputPar     The new principal amount for the makerAccount for the inputMarketId
3582      * @param  inputWei        The change in token amount for the makerAccount for the inputMarketId
3583      * @param  data            Arbitrary data passed in by the trader
3584      * @return                 The AssetAmount for the makerAccount for the outputMarketId
3585      */
3586     function getTradeCost(
3587         uint256 inputMarketId,
3588         uint256 outputMarketId,
3589         Account.Info memory makerAccount,
3590         Account.Info memory takerAccount,
3591         Types.Par memory oldInputPar,
3592         Types.Par memory newInputPar,
3593         Types.Wei memory inputWei,
3594         bytes memory data
3595     )
3596         public
3597         returns (Types.AssetAmount memory);
3598 }
3599 
3600 // File: contracts/protocol/interfaces/ICallee.sol
3601 
3602 /**
3603  * @title ICallee
3604  * @author dYdX
3605  *
3606  * Interface that Callees for Solo must implement in order to ingest data.
3607  */
3608 contract ICallee {
3609 
3610     // ============ Public Functions ============
3611 
3612     /**
3613      * Allows users to send this contract arbitrary data.
3614      *
3615      * @param  sender       The msg.sender to Solo
3616      * @param  accountInfo  The account from which the data is being sent
3617      * @param  data         Arbitrary data given by the sender
3618      */
3619     function callFunction(
3620         address sender,
3621         Account.Info memory accountInfo,
3622         bytes memory data
3623     )
3624         public;
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