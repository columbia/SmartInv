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
161 // File: contracts/protocol/interfaces/IErc20.sol
162 
163 /**
164  * @title IErc20
165  * @author dYdX
166  *
167  * Interface for using ERC20 Tokens. We have to use a special interface to call ERC20 functions so
168  * that we don't automatically revert when calling non-compliant tokens that have no return value for
169  * transfer(), transferFrom(), or approve().
170  */
171 interface IErc20 {
172     event Transfer(
173         address indexed from,
174         address indexed to,
175         uint256 value
176     );
177 
178     event Approval(
179         address indexed owner,
180         address indexed spender,
181         uint256 value
182     );
183 
184     function totalSupply(
185     )
186         external
187         view
188         returns (uint256);
189 
190     function balanceOf(
191         address who
192     )
193         external
194         view
195         returns (uint256);
196 
197     function allowance(
198         address owner,
199         address spender
200     )
201         external
202         view
203         returns (uint256);
204 
205     function transfer(
206         address to,
207         uint256 value
208     )
209         external;
210 
211     function transferFrom(
212         address from,
213         address to,
214         uint256 value
215     )
216         external;
217 
218     function approve(
219         address spender,
220         uint256 value
221     )
222         external;
223 
224     function name()
225         external
226         view
227         returns (string memory);
228 
229     function symbol()
230         external
231         view
232         returns (string memory);
233 
234     function decimals()
235         external
236         view
237         returns (uint8);
238 }
239 
240 // File: contracts/protocol/lib/Monetary.sol
241 
242 /**
243  * @title Monetary
244  * @author dYdX
245  *
246  * Library for types involving money
247  */
248 library Monetary {
249 
250     /*
251      * The price of a base-unit of an asset.
252      */
253     struct Price {
254         uint256 value;
255     }
256 
257     /*
258      * Total value of an some amount of an asset. Equal to (price * amount).
259      */
260     struct Value {
261         uint256 value;
262     }
263 }
264 
265 // File: contracts/protocol/interfaces/IPriceOracle.sol
266 
267 /**
268  * @title IPriceOracle
269  * @author dYdX
270  *
271  * Interface that Price Oracles for Solo must implement in order to report prices.
272  */
273 contract IPriceOracle {
274 
275     // ============ Constants ============
276 
277     uint256 public constant ONE_DOLLAR = 10 ** 36;
278 
279     // ============ Public Functions ============
280 
281     /**
282      * Get the price of a token
283      *
284      * @param  token  The ERC20 token address of the market
285      * @return        The USD price of a base unit of the token, then multiplied by 10^36.
286      *                So a USD-stable coin with 18 decimal places would return 10^18.
287      *                This is the price of the base unit rather than the price of a "human-readable"
288      *                token amount. Every ERC20 may have a different number of decimals.
289      */
290     function getPrice(
291         address token
292     )
293         public
294         view
295         returns (Monetary.Price memory);
296 }
297 
298 // File: contracts/protocol/lib/Require.sol
299 
300 /**
301  * @title Require
302  * @author dYdX
303  *
304  * Stringifies parameters to pretty-print revert messages. Costs more gas than regular require()
305  */
306 library Require {
307 
308     // ============ Constants ============
309 
310     uint256 constant ASCII_ZERO = 48; // '0'
311     uint256 constant ASCII_RELATIVE_ZERO = 87; // 'a' - 10
312     uint256 constant ASCII_LOWER_EX = 120; // 'x'
313     bytes2 constant COLON = 0x3a20; // ': '
314     bytes2 constant COMMA = 0x2c20; // ', '
315     bytes2 constant LPAREN = 0x203c; // ' <'
316     byte constant RPAREN = 0x3e; // '>'
317     uint256 constant FOUR_BIT_MASK = 0xf;
318 
319     // ============ Library Functions ============
320 
321     function that(
322         bool must,
323         bytes32 file,
324         bytes32 reason
325     )
326         internal
327         pure
328     {
329         if (!must) {
330             revert(
331                 string(
332                     abi.encodePacked(
333                         stringify(file),
334                         COLON,
335                         stringify(reason)
336                     )
337                 )
338             );
339         }
340     }
341 
342     function that(
343         bool must,
344         bytes32 file,
345         bytes32 reason,
346         uint256 payloadA
347     )
348         internal
349         pure
350     {
351         if (!must) {
352             revert(
353                 string(
354                     abi.encodePacked(
355                         stringify(file),
356                         COLON,
357                         stringify(reason),
358                         LPAREN,
359                         stringify(payloadA),
360                         RPAREN
361                     )
362                 )
363             );
364         }
365     }
366 
367     function that(
368         bool must,
369         bytes32 file,
370         bytes32 reason,
371         uint256 payloadA,
372         uint256 payloadB
373     )
374         internal
375         pure
376     {
377         if (!must) {
378             revert(
379                 string(
380                     abi.encodePacked(
381                         stringify(file),
382                         COLON,
383                         stringify(reason),
384                         LPAREN,
385                         stringify(payloadA),
386                         COMMA,
387                         stringify(payloadB),
388                         RPAREN
389                     )
390                 )
391             );
392         }
393     }
394 
395     function that(
396         bool must,
397         bytes32 file,
398         bytes32 reason,
399         address payloadA
400     )
401         internal
402         pure
403     {
404         if (!must) {
405             revert(
406                 string(
407                     abi.encodePacked(
408                         stringify(file),
409                         COLON,
410                         stringify(reason),
411                         LPAREN,
412                         stringify(payloadA),
413                         RPAREN
414                     )
415                 )
416             );
417         }
418     }
419 
420     function that(
421         bool must,
422         bytes32 file,
423         bytes32 reason,
424         address payloadA,
425         uint256 payloadB
426     )
427         internal
428         pure
429     {
430         if (!must) {
431             revert(
432                 string(
433                     abi.encodePacked(
434                         stringify(file),
435                         COLON,
436                         stringify(reason),
437                         LPAREN,
438                         stringify(payloadA),
439                         COMMA,
440                         stringify(payloadB),
441                         RPAREN
442                     )
443                 )
444             );
445         }
446     }
447 
448     function that(
449         bool must,
450         bytes32 file,
451         bytes32 reason,
452         address payloadA,
453         uint256 payloadB,
454         uint256 payloadC
455     )
456         internal
457         pure
458     {
459         if (!must) {
460             revert(
461                 string(
462                     abi.encodePacked(
463                         stringify(file),
464                         COLON,
465                         stringify(reason),
466                         LPAREN,
467                         stringify(payloadA),
468                         COMMA,
469                         stringify(payloadB),
470                         COMMA,
471                         stringify(payloadC),
472                         RPAREN
473                     )
474                 )
475             );
476         }
477     }
478 
479     // ============ Private Functions ============
480 
481     function stringify(
482         bytes32 input
483     )
484         private
485         pure
486         returns (bytes memory)
487     {
488         // put the input bytes into the result
489         bytes memory result = abi.encodePacked(input);
490 
491         // determine the length of the input by finding the location of the last non-zero byte
492         for (uint256 i = 32; i > 0; ) {
493             // reverse-for-loops with unsigned integer
494             /* solium-disable-next-line security/no-modify-for-iter-var */
495             i--;
496 
497             // find the last non-zero byte in order to determine the length
498             if (result[i] != 0) {
499                 uint256 length = i + 1;
500 
501                 /* solium-disable-next-line security/no-inline-assembly */
502                 assembly {
503                     mstore(result, length) // r.length = length;
504                 }
505 
506                 return result;
507             }
508         }
509 
510         // all bytes are zero
511         return new bytes(0);
512     }
513 
514     function stringify(
515         uint256 input
516     )
517         private
518         pure
519         returns (bytes memory)
520     {
521         if (input == 0) {
522             return "0";
523         }
524 
525         // get the final string length
526         uint256 j = input;
527         uint256 length;
528         while (j != 0) {
529             length++;
530             j /= 10;
531         }
532 
533         // allocate the string
534         bytes memory bstr = new bytes(length);
535 
536         // populate the string starting with the least-significant character
537         j = input;
538         for (uint256 i = length; i > 0; ) {
539             // reverse-for-loops with unsigned integer
540             /* solium-disable-next-line security/no-modify-for-iter-var */
541             i--;
542 
543             // take last decimal digit
544             bstr[i] = byte(uint8(ASCII_ZERO + (j % 10)));
545 
546             // remove the last decimal digit
547             j /= 10;
548         }
549 
550         return bstr;
551     }
552 
553     function stringify(
554         address input
555     )
556         private
557         pure
558         returns (bytes memory)
559     {
560         uint256 z = uint256(input);
561 
562         // addresses are "0x" followed by 20 bytes of data which take up 2 characters each
563         bytes memory result = new bytes(42);
564 
565         // populate the result with "0x"
566         result[0] = byte(uint8(ASCII_ZERO));
567         result[1] = byte(uint8(ASCII_LOWER_EX));
568 
569         // for each byte (starting from the lowest byte), populate the result with two characters
570         for (uint256 i = 0; i < 20; i++) {
571             // each byte takes two characters
572             uint256 shift = i * 2;
573 
574             // populate the least-significant character
575             result[41 - shift] = char(z & FOUR_BIT_MASK);
576             z = z >> 4;
577 
578             // populate the most-significant character
579             result[40 - shift] = char(z & FOUR_BIT_MASK);
580             z = z >> 4;
581         }
582 
583         return result;
584     }
585 
586     function char(
587         uint256 input
588     )
589         private
590         pure
591         returns (byte)
592     {
593         // return ASCII digit (0-9)
594         if (input < 10) {
595             return byte(uint8(input + ASCII_ZERO));
596         }
597 
598         // return ASCII letter (a-f)
599         return byte(uint8(input + ASCII_RELATIVE_ZERO));
600     }
601 }
602 
603 // File: contracts/protocol/lib/Math.sol
604 
605 /**
606  * @title Math
607  * @author dYdX
608  *
609  * Library for non-standard Math functions
610  */
611 library Math {
612     using SafeMath for uint256;
613 
614     // ============ Constants ============
615 
616     bytes32 constant FILE = "Math";
617 
618     // ============ Library Functions ============
619 
620     /*
621      * Return target * (numerator / denominator).
622      */
623     function getPartial(
624         uint256 target,
625         uint256 numerator,
626         uint256 denominator
627     )
628         internal
629         pure
630         returns (uint256)
631     {
632         return target.mul(numerator).div(denominator);
633     }
634 
635     /*
636      * Return target * (numerator / denominator), but rounded up.
637      */
638     function getPartialRoundUp(
639         uint256 target,
640         uint256 numerator,
641         uint256 denominator
642     )
643         internal
644         pure
645         returns (uint256)
646     {
647         if (target == 0 || numerator == 0) {
648             // SafeMath will check for zero denominator
649             return SafeMath.div(0, denominator);
650         }
651         return target.mul(numerator).sub(1).div(denominator).add(1);
652     }
653 
654     function to128(
655         uint256 number
656     )
657         internal
658         pure
659         returns (uint128)
660     {
661         uint128 result = uint128(number);
662         Require.that(
663             result == number,
664             FILE,
665             "Unsafe cast to uint128"
666         );
667         return result;
668     }
669 
670     function to96(
671         uint256 number
672     )
673         internal
674         pure
675         returns (uint96)
676     {
677         uint96 result = uint96(number);
678         Require.that(
679             result == number,
680             FILE,
681             "Unsafe cast to uint96"
682         );
683         return result;
684     }
685 
686     function to32(
687         uint256 number
688     )
689         internal
690         pure
691         returns (uint32)
692     {
693         uint32 result = uint32(number);
694         Require.that(
695             result == number,
696             FILE,
697             "Unsafe cast to uint32"
698         );
699         return result;
700     }
701 
702     function min(
703         uint256 a,
704         uint256 b
705     )
706         internal
707         pure
708         returns (uint256)
709     {
710         return a < b ? a : b;
711     }
712 
713     function max(
714         uint256 a,
715         uint256 b
716     )
717         internal
718         pure
719         returns (uint256)
720     {
721         return a > b ? a : b;
722     }
723 }
724 
725 // File: contracts/protocol/lib/Time.sol
726 
727 /**
728  * @title Time
729  * @author dYdX
730  *
731  * Library for dealing with time, assuming timestamps fit within 32 bits (valid until year 2106)
732  */
733 library Time {
734 
735     // ============ Library Functions ============
736 
737     function currentTime()
738         internal
739         view
740         returns (uint32)
741     {
742         return Math.to32(block.timestamp);
743     }
744 }
745 
746 // File: contracts/external/interfaces/IMakerOracle.sol
747 
748 /**
749  * @title IMakerOracle
750  * @author dYdX
751  *
752  * Interface for the price oracles run by MakerDao
753  */
754 interface IMakerOracle {
755 
756     // Event that is logged when the `note` modifier is used
757     event LogNote(
758         bytes4 indexed msgSig,
759         address indexed msgSender,
760         bytes32 indexed arg1,
761         bytes32 indexed arg2,
762         uint256 msgValue,
763         bytes msgData
764     ) anonymous;
765 
766     // returns the current value (ETH/USD * 10**18) as a bytes32
767     function peek()
768         external
769         view
770         returns (bytes32, bool);
771 
772     // requires a fresh price and then returns the current value
773     function read()
774         external
775         view
776         returns (bytes32);
777 }
778 
779 // File: contracts/external/interfaces/IOasisDex.sol
780 
781 /**
782  * @title IOasisDex
783  * @author dYdX
784  *
785  * Interface for the OasisDex contract
786  */
787 interface IOasisDex {
788 
789     // ============ Structs ================
790 
791     struct OfferInfo {
792         uint256 pay_amt;
793         address pay_gem;
794         uint256 buy_amt;
795         address buy_gem;
796         address owner;
797         uint64 timestamp;
798     }
799 
800     struct SortInfo {
801         uint256 next;  //points to id of next higher offer
802         uint256 prev;  //points to id of previous lower offer
803         uint256 delb;  //the blocknumber where this entry was marked for delete
804     }
805 
806     // ============ Storage Getters ================
807 
808     function last_offer_id()
809         external
810         view
811         returns (uint256);
812 
813     function offers(
814         uint256 id
815     )
816         external
817         view
818         returns (OfferInfo memory);
819 
820     function close_time()
821         external
822         view
823         returns (uint64);
824 
825     function stopped()
826         external
827         view
828         returns (bool);
829 
830     function buyEnabled()
831         external
832         view
833         returns (bool);
834 
835     function matchingEnabled()
836         external
837         view
838         returns (bool);
839 
840     function _rank(
841         uint256 id
842     )
843         external
844         view
845         returns (SortInfo memory);
846 
847     function _best(
848         address sell_gem,
849         address buy_gem
850     )
851         external
852         view
853         returns (uint256);
854 
855     function _span(
856         address sell_gem,
857         address buy_gem
858     )
859         external
860         view
861         returns (uint256);
862 
863     function _dust(
864         address gem
865     )
866         external
867         view
868         returns (uint256);
869 
870     function _near(
871         uint256 id
872     )
873         external
874         view
875         returns (uint256);
876 
877     // ============ Constant Functions ================
878 
879     function isActive(
880         uint256 id
881     )
882         external
883         view
884         returns (bool);
885 
886     function getOwner(
887         uint256 id
888     )
889         external
890         view
891         returns (address);
892 
893     function getOffer(
894         uint256 id
895     )
896         external
897         view
898         returns (uint256, address, uint256, address);
899 
900     function getMinSell(
901         address pay_gem
902     )
903         external
904         view
905         returns (uint256);
906 
907     function getBestOffer(
908         address sell_gem,
909         address buy_gem
910     )
911         external
912         view
913         returns (uint256);
914 
915     function getWorseOffer(
916         uint256 id
917     )
918         external
919         view
920         returns (uint256);
921 
922     function getBetterOffer(
923         uint256 id
924     )
925         external
926         view
927         returns (uint256);
928 
929     function getOfferCount(
930         address sell_gem,
931         address buy_gem
932     )
933         external
934         view
935         returns (uint256);
936 
937     function getFirstUnsortedOffer()
938         external
939         view
940         returns (uint256);
941 
942     function getNextUnsortedOffer(
943         uint256 id
944     )
945         external
946         view
947         returns (uint256);
948 
949     function isOfferSorted(
950         uint256 id
951     )
952         external
953         view
954         returns (bool);
955 
956     function getBuyAmount(
957         address buy_gem,
958         address pay_gem,
959         uint256 pay_amt
960     )
961         external
962         view
963         returns (uint256);
964 
965     function getPayAmount(
966         address pay_gem,
967         address buy_gem,
968         uint256 buy_amt
969     )
970         external
971         view
972         returns (uint256);
973 
974     function isClosed()
975         external
976         view
977         returns (bool);
978 
979     function getTime()
980         external
981         view
982         returns (uint64);
983 
984     // ============ Non-Constant Functions ================
985 
986     function bump(
987         bytes32 id_
988     )
989         external;
990 
991     function buy(
992         uint256 id,
993         uint256 quantity
994     )
995         external
996         returns (bool);
997 
998     function cancel(
999         uint256 id
1000     )
1001         external
1002         returns (bool);
1003 
1004     function kill(
1005         bytes32 id
1006     )
1007         external;
1008 
1009     function make(
1010         address  pay_gem,
1011         address  buy_gem,
1012         uint128  pay_amt,
1013         uint128  buy_amt
1014     )
1015         external
1016         returns (bytes32);
1017 
1018     function take(
1019         bytes32 id,
1020         uint128 maxTakeAmount
1021     )
1022         external;
1023 
1024     function offer(
1025         uint256 pay_amt,
1026         address pay_gem,
1027         uint256 buy_amt,
1028         address buy_gem
1029     )
1030         external
1031         returns (uint256);
1032 
1033     function offer(
1034         uint256 pay_amt,
1035         address pay_gem,
1036         uint256 buy_amt,
1037         address buy_gem,
1038         uint256 pos
1039     )
1040         external
1041         returns (uint256);
1042 
1043     function offer(
1044         uint256 pay_amt,
1045         address pay_gem,
1046         uint256 buy_amt,
1047         address buy_gem,
1048         uint256 pos,
1049         bool rounding
1050     )
1051         external
1052         returns (uint256);
1053 
1054     function insert(
1055         uint256 id,
1056         uint256 pos
1057     )
1058         external
1059         returns (bool);
1060 
1061     function del_rank(
1062         uint256 id
1063     )
1064         external
1065         returns (bool);
1066 
1067     function sellAllAmount(
1068         address pay_gem,
1069         uint256 pay_amt,
1070         address buy_gem,
1071         uint256 min_fill_amount
1072     )
1073         external
1074         returns (uint256);
1075 
1076     function buyAllAmount(
1077         address buy_gem,
1078         uint256 buy_amt,
1079         address pay_gem,
1080         uint256 max_fill_amount
1081     )
1082         external
1083         returns (uint256);
1084 }
1085 
1086 // File: contracts/external/oracles/DaiPriceOracle.sol
1087 
1088 /**
1089  * @title DaiPriceOracle
1090  * @author dYdX
1091  *
1092  * PriceOracle that gives the price of Dai in USD
1093  */
1094 contract DaiPriceOracle is
1095     Ownable,
1096     IPriceOracle
1097 {
1098     using SafeMath for uint256;
1099 
1100     // ============ Constants ============
1101 
1102     bytes32 constant FILE = "DaiPriceOracle";
1103 
1104     uint256 constant DECIMALS = 18;
1105 
1106     uint256 constant EXPECTED_PRICE = ONE_DOLLAR / (10 ** DECIMALS);
1107 
1108     // ============ Structs ============
1109 
1110     struct PriceInfo {
1111         uint128 price;
1112         uint32 lastUpdate;
1113     }
1114 
1115     struct DeviationParams {
1116         uint64 denominator;
1117         uint64 maximumPerSecond;
1118         uint64 maximumAbsolute;
1119     }
1120 
1121     // ============ Events ============
1122 
1123     event PriceSet(
1124         PriceInfo newPriceInfo
1125     );
1126 
1127     // ============ Storage ============
1128 
1129     PriceInfo public g_priceInfo;
1130 
1131     address public g_poker;
1132 
1133     DeviationParams public DEVIATION_PARAMS;
1134 
1135     uint256 public OASIS_ETH_AMOUNT;
1136 
1137     IErc20 public WETH;
1138 
1139     IErc20 public DAI;
1140 
1141     IMakerOracle public MEDIANIZER;
1142 
1143     IOasisDex public OASIS;
1144 
1145     address public UNISWAP;
1146 
1147     // ============ Constructor =============
1148 
1149     constructor(
1150         address poker,
1151         address weth,
1152         address dai,
1153         address medianizer,
1154         address oasis,
1155         address uniswap,
1156         uint256 oasisEthAmount,
1157         DeviationParams memory deviationParams
1158     )
1159         public
1160     {
1161         g_poker = poker;
1162         MEDIANIZER = IMakerOracle(medianizer);
1163         WETH = IErc20(weth);
1164         DAI = IErc20(dai);
1165         OASIS = IOasisDex(oasis);
1166         UNISWAP = uniswap;
1167         DEVIATION_PARAMS = deviationParams;
1168         OASIS_ETH_AMOUNT = oasisEthAmount;
1169         g_priceInfo = PriceInfo({
1170             lastUpdate: uint32(block.timestamp),
1171             price: uint128(EXPECTED_PRICE)
1172         });
1173     }
1174 
1175     // ============ Admin Functions ============
1176 
1177     function ownerSetPokerAddress(
1178         address newPoker
1179     )
1180         external
1181         onlyOwner
1182     {
1183         g_poker = newPoker;
1184     }
1185 
1186     // ============ Public Functions ============
1187 
1188     function updatePrice(
1189         Monetary.Price memory minimum,
1190         Monetary.Price memory maximum
1191     )
1192         public
1193         returns (PriceInfo memory)
1194     {
1195         Require.that(
1196             msg.sender == g_poker,
1197             FILE,
1198             "Only poker can call updatePrice",
1199             msg.sender
1200         );
1201 
1202         Monetary.Price memory newPrice = getBoundedTargetPrice();
1203 
1204         Require.that(
1205             newPrice.value >= minimum.value,
1206             FILE,
1207             "newPrice below minimum",
1208             newPrice.value,
1209             minimum.value
1210         );
1211 
1212         Require.that(
1213             newPrice.value <= maximum.value,
1214             FILE,
1215             "newPrice above maximum",
1216             newPrice.value,
1217             maximum.value
1218         );
1219 
1220         g_priceInfo = PriceInfo({
1221             price: Math.to128(newPrice.value),
1222             lastUpdate: Time.currentTime()
1223         });
1224 
1225         emit PriceSet(g_priceInfo);
1226         return g_priceInfo;
1227     }
1228 
1229     // ============ IPriceOracle Functions ============
1230 
1231     function getPrice(
1232         address /* token */
1233     )
1234         public
1235         view
1236         returns (Monetary.Price memory)
1237     {
1238         return Monetary.Price({
1239             value: g_priceInfo.price
1240         });
1241     }
1242 
1243     // ============ Price-Query Functions ============
1244 
1245     /**
1246      * Get the new price that would be stored if updated right now.
1247      */
1248     function getBoundedTargetPrice()
1249         public
1250         view
1251         returns (Monetary.Price memory)
1252     {
1253         Monetary.Price memory targetPrice = getTargetPrice();
1254 
1255         PriceInfo memory oldInfo = g_priceInfo;
1256         uint256 timeDelta = uint256(Time.currentTime()).sub(oldInfo.lastUpdate);
1257         (uint256 minPrice, uint256 maxPrice) = getPriceBounds(oldInfo.price, timeDelta);
1258         uint256 boundedTargetPrice = boundValue(targetPrice.value, minPrice, maxPrice);
1259 
1260         return Monetary.Price({
1261             value: boundedTargetPrice
1262         });
1263     }
1264 
1265     /**
1266      * Get the USD price of DAI that this contract will move towards when updated. This price is
1267      * not bounded by the variables governing the maximum deviation from the old price.
1268      */
1269     function getTargetPrice()
1270         public
1271         view
1272         returns (Monetary.Price memory)
1273     {
1274         Monetary.Price memory ethUsd = getMedianizerPrice();
1275 
1276         uint256 targetPrice = getMidValue(
1277             EXPECTED_PRICE,
1278             getOasisPrice(ethUsd).value,
1279             getUniswapPrice(ethUsd).value
1280         );
1281 
1282         return Monetary.Price({
1283             value: targetPrice
1284         });
1285     }
1286 
1287     /**
1288      * Get the USD price of ETH according the Maker Medianizer contract.
1289      */
1290     function getMedianizerPrice()
1291         public
1292         view
1293         returns (Monetary.Price memory)
1294     {
1295         // throws if the price is not fresh
1296         return Monetary.Price({
1297             value: uint256(MEDIANIZER.read())
1298         });
1299     }
1300 
1301     /**
1302      * Get the USD price of DAI according to OasisDEX given the USD price of ETH.
1303      */
1304     function getOasisPrice(
1305         Monetary.Price memory ethUsd
1306     )
1307         public
1308         view
1309         returns (Monetary.Price memory)
1310     {
1311         IOasisDex oasis = OASIS;
1312 
1313         // If exchange is not operational, return old value.
1314         // This allows the price to move only towards 1 USD
1315         if (
1316             oasis.isClosed()
1317             || !oasis.buyEnabled()
1318             || !oasis.matchingEnabled()
1319         ) {
1320             return Monetary.Price({
1321                 value: g_priceInfo.price
1322             });
1323         }
1324 
1325         uint256 numWei = OASIS_ETH_AMOUNT;
1326         address dai = address(DAI);
1327         address weth = address(WETH);
1328 
1329         // Assumes at least `numWei` of depth on both sides of the book if the exchange is active.
1330         // Will revert if not enough depth.
1331         uint256 daiAmt1 = oasis.getBuyAmount(dai, weth, numWei);
1332         uint256 daiAmt2 = oasis.getPayAmount(dai, weth, numWei);
1333 
1334         uint256 num = numWei.mul(daiAmt2).add(numWei.mul(daiAmt1));
1335         uint256 den = daiAmt1.mul(daiAmt2).mul(2);
1336         uint256 oasisPrice = Math.getPartial(ethUsd.value, num, den);
1337 
1338         return Monetary.Price({
1339             value: oasisPrice
1340         });
1341     }
1342 
1343     /**
1344      * Get the USD price of DAI according to Uniswap given the USD price of ETH.
1345      */
1346     function getUniswapPrice(
1347         Monetary.Price memory ethUsd
1348     )
1349         public
1350         view
1351         returns (Monetary.Price memory)
1352     {
1353         address uniswap = address(UNISWAP);
1354         uint256 ethAmt = uniswap.balance;
1355         uint256 daiAmt = DAI.balanceOf(uniswap);
1356         uint256 uniswapPrice = Math.getPartial(ethUsd.value, ethAmt, daiAmt);
1357 
1358         return Monetary.Price({
1359             value: uniswapPrice
1360         });
1361     }
1362 
1363     // ============ Helper Functions ============
1364 
1365     function getPriceBounds(
1366         uint256 oldPrice,
1367         uint256 timeDelta
1368     )
1369         private
1370         view
1371         returns (uint256, uint256)
1372     {
1373         DeviationParams memory deviation = DEVIATION_PARAMS;
1374 
1375         uint256 maxDeviation = Math.getPartial(
1376             oldPrice,
1377             Math.min(deviation.maximumAbsolute, timeDelta.mul(deviation.maximumPerSecond)),
1378             deviation.denominator
1379         );
1380 
1381         return (
1382             oldPrice.sub(maxDeviation),
1383             oldPrice.add(maxDeviation)
1384         );
1385     }
1386 
1387     function getMidValue(
1388         uint256 valueA,
1389         uint256 valueB,
1390         uint256 valueC
1391     )
1392         private
1393         pure
1394         returns (uint256)
1395     {
1396         uint256 maximum = Math.max(valueA, Math.max(valueB, valueC));
1397         if (maximum == valueA) {
1398             return Math.max(valueB, valueC);
1399         }
1400         if (maximum == valueB) {
1401             return Math.max(valueA, valueC);
1402         }
1403         return Math.max(valueA, valueB);
1404     }
1405 
1406     function boundValue(
1407         uint256 value,
1408         uint256 minimum,
1409         uint256 maximum
1410     )
1411         private
1412         pure
1413         returns (uint256)
1414     {
1415         assert(minimum <= maximum);
1416         return Math.max(minimum, Math.min(maximum, value));
1417     }
1418 }