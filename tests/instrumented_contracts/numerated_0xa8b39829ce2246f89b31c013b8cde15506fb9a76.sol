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
22 // File: canonical-weth/contracts/WETH9.sol
23 
24 contract WETH9 {
25     string public name     = "Wrapped Ether";
26     string public symbol   = "WETH";
27     uint8  public decimals = 18;
28 
29     event  Approval(address indexed src, address indexed guy, uint wad);
30     event  Transfer(address indexed src, address indexed dst, uint wad);
31     event  Deposit(address indexed dst, uint wad);
32     event  Withdrawal(address indexed src, uint wad);
33 
34     mapping (address => uint)                       public  balanceOf;
35     mapping (address => mapping (address => uint))  public  allowance;
36 
37     function() external payable {
38         deposit();
39     }
40     function deposit() public payable {
41         balanceOf[msg.sender] += msg.value;
42         emit Deposit(msg.sender, msg.value);
43     }
44     function withdraw(uint wad) public {
45         require(balanceOf[msg.sender] >= wad);
46         balanceOf[msg.sender] -= wad;
47         msg.sender.transfer(wad);
48         emit Withdrawal(msg.sender, wad);
49     }
50 
51     function totalSupply() public view returns (uint) {
52         return address(this).balance;
53     }
54 
55     function approve(address guy, uint wad) public returns (bool) {
56         allowance[msg.sender][guy] = wad;
57         emit Approval(msg.sender, guy, wad);
58         return true;
59     }
60 
61     function transfer(address dst, uint wad) public returns (bool) {
62         return transferFrom(msg.sender, dst, wad);
63     }
64 
65     function transferFrom(address src, address dst, uint wad)
66         public
67         returns (bool)
68     {
69         require(balanceOf[src] >= wad);
70 
71         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
72             require(allowance[src][msg.sender] >= wad);
73             allowance[src][msg.sender] -= wad;
74         }
75 
76         balanceOf[src] -= wad;
77         balanceOf[dst] += wad;
78 
79         emit Transfer(src, dst, wad);
80 
81         return true;
82     }
83 }
84 
85 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
86 
87 /**
88  * @title Helps contracts guard against reentrancy attacks.
89  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
90  * @dev If you mark a function `nonReentrant`, you should also
91  * mark it `external`.
92  */
93 contract ReentrancyGuard {
94     /// @dev counter to allow mutex lock with only one SSTORE operation
95     uint256 private _guardCounter;
96 
97     constructor () internal {
98         // The counter starts at one to prevent changing it from zero to a non-zero
99         // value, which is a more expensive operation.
100         _guardCounter = 1;
101     }
102 
103     /**
104      * @dev Prevents a contract from calling itself, directly or indirectly.
105      * Calling a `nonReentrant` function from another `nonReentrant`
106      * function is not supported. It is possible to prevent this from happening
107      * by making the `nonReentrant` function external, and make it call a
108      * `private` function that does the actual work.
109      */
110     modifier nonReentrant() {
111         _guardCounter += 1;
112         uint256 localCounter = _guardCounter;
113         _;
114         require(localCounter == _guardCounter);
115     }
116 }
117 
118 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
119 
120 /**
121  * @title Ownable
122  * @dev The Ownable contract has an owner address, and provides basic authorization control
123  * functions, this simplifies the implementation of "user permissions".
124  */
125 contract Ownable {
126     address private _owner;
127 
128     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
129 
130     /**
131      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
132      * account.
133      */
134     constructor () internal {
135         _owner = msg.sender;
136         emit OwnershipTransferred(address(0), _owner);
137     }
138 
139     /**
140      * @return the address of the owner.
141      */
142     function owner() public view returns (address) {
143         return _owner;
144     }
145 
146     /**
147      * @dev Throws if called by any account other than the owner.
148      */
149     modifier onlyOwner() {
150         require(isOwner());
151         _;
152     }
153 
154     /**
155      * @return true if `msg.sender` is the owner of the contract.
156      */
157     function isOwner() public view returns (bool) {
158         return msg.sender == _owner;
159     }
160 
161     /**
162      * @dev Allows the current owner to relinquish control of the contract.
163      * @notice Renouncing to ownership will leave the contract without an owner.
164      * It will not be possible to call the functions with the `onlyOwner`
165      * modifier anymore.
166      */
167     function renounceOwnership() public onlyOwner {
168         emit OwnershipTransferred(_owner, address(0));
169         _owner = address(0);
170     }
171 
172     /**
173      * @dev Allows the current owner to transfer control of the contract to a newOwner.
174      * @param newOwner The address to transfer ownership to.
175      */
176     function transferOwnership(address newOwner) public onlyOwner {
177         _transferOwnership(newOwner);
178     }
179 
180     /**
181      * @dev Transfers control of the contract to a newOwner.
182      * @param newOwner The address to transfer ownership to.
183      */
184     function _transferOwnership(address newOwner) internal {
185         require(newOwner != address(0));
186         emit OwnershipTransferred(_owner, newOwner);
187         _owner = newOwner;
188     }
189 }
190 
191 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
192 
193 /**
194  * @title SafeMath
195  * @dev Unsigned math operations with safety checks that revert on error
196  */
197 library SafeMath {
198     /**
199     * @dev Multiplies two unsigned integers, reverts on overflow.
200     */
201     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
202         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
203         // benefit is lost if 'b' is also tested.
204         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
205         if (a == 0) {
206             return 0;
207         }
208 
209         uint256 c = a * b;
210         require(c / a == b);
211 
212         return c;
213     }
214 
215     /**
216     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
217     */
218     function div(uint256 a, uint256 b) internal pure returns (uint256) {
219         // Solidity only automatically asserts when dividing by 0
220         require(b > 0);
221         uint256 c = a / b;
222         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
223 
224         return c;
225     }
226 
227     /**
228     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
229     */
230     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
231         require(b <= a);
232         uint256 c = a - b;
233 
234         return c;
235     }
236 
237     /**
238     * @dev Adds two unsigned integers, reverts on overflow.
239     */
240     function add(uint256 a, uint256 b) internal pure returns (uint256) {
241         uint256 c = a + b;
242         require(c >= a);
243 
244         return c;
245     }
246 
247     /**
248     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
249     * reverts when dividing by zero.
250     */
251     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
252         require(b != 0);
253         return a % b;
254     }
255 }
256 
257 // File: contracts/protocol/lib/Require.sol
258 
259 /**
260  * @title Require
261  * @author dYdX
262  *
263  * Stringifies parameters to pretty-print revert messages. Costs more gas than regular require()
264  */
265 library Require {
266 
267     // ============ Constants ============
268 
269     uint256 constant ASCII_ZERO = 48; // '0'
270     uint256 constant ASCII_RELATIVE_ZERO = 87; // 'a' - 10
271     uint256 constant ASCII_LOWER_EX = 120; // 'x'
272     bytes2 constant COLON = 0x3a20; // ': '
273     bytes2 constant COMMA = 0x2c20; // ', '
274     bytes2 constant LPAREN = 0x203c; // ' <'
275     byte constant RPAREN = 0x3e; // '>'
276     uint256 constant FOUR_BIT_MASK = 0xf;
277 
278     // ============ Library Functions ============
279 
280     function that(
281         bool must,
282         bytes32 file,
283         bytes32 reason
284     )
285         internal
286         pure
287     {
288         if (!must) {
289             revert(
290                 string(
291                     abi.encodePacked(
292                         stringify(file),
293                         COLON,
294                         stringify(reason)
295                     )
296                 )
297             );
298         }
299     }
300 
301     function that(
302         bool must,
303         bytes32 file,
304         bytes32 reason,
305         uint256 payloadA
306     )
307         internal
308         pure
309     {
310         if (!must) {
311             revert(
312                 string(
313                     abi.encodePacked(
314                         stringify(file),
315                         COLON,
316                         stringify(reason),
317                         LPAREN,
318                         stringify(payloadA),
319                         RPAREN
320                     )
321                 )
322             );
323         }
324     }
325 
326     function that(
327         bool must,
328         bytes32 file,
329         bytes32 reason,
330         uint256 payloadA,
331         uint256 payloadB
332     )
333         internal
334         pure
335     {
336         if (!must) {
337             revert(
338                 string(
339                     abi.encodePacked(
340                         stringify(file),
341                         COLON,
342                         stringify(reason),
343                         LPAREN,
344                         stringify(payloadA),
345                         COMMA,
346                         stringify(payloadB),
347                         RPAREN
348                     )
349                 )
350             );
351         }
352     }
353 
354     function that(
355         bool must,
356         bytes32 file,
357         bytes32 reason,
358         address payloadA
359     )
360         internal
361         pure
362     {
363         if (!must) {
364             revert(
365                 string(
366                     abi.encodePacked(
367                         stringify(file),
368                         COLON,
369                         stringify(reason),
370                         LPAREN,
371                         stringify(payloadA),
372                         RPAREN
373                     )
374                 )
375             );
376         }
377     }
378 
379     function that(
380         bool must,
381         bytes32 file,
382         bytes32 reason,
383         address payloadA,
384         uint256 payloadB
385     )
386         internal
387         pure
388     {
389         if (!must) {
390             revert(
391                 string(
392                     abi.encodePacked(
393                         stringify(file),
394                         COLON,
395                         stringify(reason),
396                         LPAREN,
397                         stringify(payloadA),
398                         COMMA,
399                         stringify(payloadB),
400                         RPAREN
401                     )
402                 )
403             );
404         }
405     }
406 
407     function that(
408         bool must,
409         bytes32 file,
410         bytes32 reason,
411         address payloadA,
412         uint256 payloadB,
413         uint256 payloadC
414     )
415         internal
416         pure
417     {
418         if (!must) {
419             revert(
420                 string(
421                     abi.encodePacked(
422                         stringify(file),
423                         COLON,
424                         stringify(reason),
425                         LPAREN,
426                         stringify(payloadA),
427                         COMMA,
428                         stringify(payloadB),
429                         COMMA,
430                         stringify(payloadC),
431                         RPAREN
432                     )
433                 )
434             );
435         }
436     }
437 
438     // ============ Private Functions ============
439 
440     function stringify(
441         bytes32 input
442     )
443         private
444         pure
445         returns (bytes memory)
446     {
447         // put the input bytes into the result
448         bytes memory result = abi.encodePacked(input);
449 
450         // determine the length of the input by finding the location of the last non-zero byte
451         for (uint256 i = 32; i > 0; ) {
452             // reverse-for-loops with unsigned integer
453             /* solium-disable-next-line security/no-modify-for-iter-var */
454             i--;
455 
456             // find the last non-zero byte in order to determine the length
457             if (result[i] != 0) {
458                 uint256 length = i + 1;
459 
460                 /* solium-disable-next-line security/no-inline-assembly */
461                 assembly {
462                     mstore(result, length) // r.length = length;
463                 }
464 
465                 return result;
466             }
467         }
468 
469         // all bytes are zero
470         return new bytes(0);
471     }
472 
473     function stringify(
474         uint256 input
475     )
476         private
477         pure
478         returns (bytes memory)
479     {
480         if (input == 0) {
481             return "0";
482         }
483 
484         // get the final string length
485         uint256 j = input;
486         uint256 length;
487         while (j != 0) {
488             length++;
489             j /= 10;
490         }
491 
492         // allocate the string
493         bytes memory bstr = new bytes(length);
494 
495         // populate the string starting with the least-significant character
496         j = input;
497         for (uint256 i = length; i > 0; ) {
498             // reverse-for-loops with unsigned integer
499             /* solium-disable-next-line security/no-modify-for-iter-var */
500             i--;
501 
502             // take last decimal digit
503             bstr[i] = byte(uint8(ASCII_ZERO + (j % 10)));
504 
505             // remove the last decimal digit
506             j /= 10;
507         }
508 
509         return bstr;
510     }
511 
512     function stringify(
513         address input
514     )
515         private
516         pure
517         returns (bytes memory)
518     {
519         uint256 z = uint256(input);
520 
521         // addresses are "0x" followed by 20 bytes of data which take up 2 characters each
522         bytes memory result = new bytes(42);
523 
524         // populate the result with "0x"
525         result[0] = byte(uint8(ASCII_ZERO));
526         result[1] = byte(uint8(ASCII_LOWER_EX));
527 
528         // for each byte (starting from the lowest byte), populate the result with two characters
529         for (uint256 i = 0; i < 20; i++) {
530             // each byte takes two characters
531             uint256 shift = i * 2;
532 
533             // populate the least-significant character
534             result[41 - shift] = char(z & FOUR_BIT_MASK);
535             z = z >> 4;
536 
537             // populate the most-significant character
538             result[40 - shift] = char(z & FOUR_BIT_MASK);
539             z = z >> 4;
540         }
541 
542         return result;
543     }
544 
545     function char(
546         uint256 input
547     )
548         private
549         pure
550         returns (byte)
551     {
552         // return ASCII digit (0-9)
553         if (input < 10) {
554             return byte(uint8(input + ASCII_ZERO));
555         }
556 
557         // return ASCII letter (a-f)
558         return byte(uint8(input + ASCII_RELATIVE_ZERO));
559     }
560 }
561 
562 // File: contracts/protocol/lib/Math.sol
563 
564 /**
565  * @title Math
566  * @author dYdX
567  *
568  * Library for non-standard Math functions
569  */
570 library Math {
571     using SafeMath for uint256;
572 
573     // ============ Constants ============
574 
575     bytes32 constant FILE = "Math";
576 
577     // ============ Library Functions ============
578 
579     /*
580      * Return target * (numerator / denominator).
581      */
582     function getPartial(
583         uint256 target,
584         uint256 numerator,
585         uint256 denominator
586     )
587         internal
588         pure
589         returns (uint256)
590     {
591         return target.mul(numerator).div(denominator);
592     }
593 
594     /*
595      * Return target * (numerator / denominator), but rounded up.
596      */
597     function getPartialRoundUp(
598         uint256 target,
599         uint256 numerator,
600         uint256 denominator
601     )
602         internal
603         pure
604         returns (uint256)
605     {
606         if (target == 0 || numerator == 0) {
607             // SafeMath will check for zero denominator
608             return SafeMath.div(0, denominator);
609         }
610         return target.mul(numerator).sub(1).div(denominator).add(1);
611     }
612 
613     function to128(
614         uint256 number
615     )
616         internal
617         pure
618         returns (uint128)
619     {
620         uint128 result = uint128(number);
621         Require.that(
622             result == number,
623             FILE,
624             "Unsafe cast to uint128"
625         );
626         return result;
627     }
628 
629     function to96(
630         uint256 number
631     )
632         internal
633         pure
634         returns (uint96)
635     {
636         uint96 result = uint96(number);
637         Require.that(
638             result == number,
639             FILE,
640             "Unsafe cast to uint96"
641         );
642         return result;
643     }
644 
645     function to32(
646         uint256 number
647     )
648         internal
649         pure
650         returns (uint32)
651     {
652         uint32 result = uint32(number);
653         Require.that(
654             result == number,
655             FILE,
656             "Unsafe cast to uint32"
657         );
658         return result;
659     }
660 
661     function min(
662         uint256 a,
663         uint256 b
664     )
665         internal
666         pure
667         returns (uint256)
668     {
669         return a < b ? a : b;
670     }
671 
672     function max(
673         uint256 a,
674         uint256 b
675     )
676         internal
677         pure
678         returns (uint256)
679     {
680         return a > b ? a : b;
681     }
682 }
683 
684 // File: contracts/protocol/lib/Types.sol
685 
686 /**
687  * @title Types
688  * @author dYdX
689  *
690  * Library for interacting with the basic structs used in Solo
691  */
692 library Types {
693     using Math for uint256;
694 
695     // ============ AssetAmount ============
696 
697     enum AssetDenomination {
698         Wei, // the amount is denominated in wei
699         Par  // the amount is denominated in par
700     }
701 
702     enum AssetReference {
703         Delta, // the amount is given as a delta from the current value
704         Target // the amount is given as an exact number to end up at
705     }
706 
707     struct AssetAmount {
708         bool sign; // true if positive
709         AssetDenomination denomination;
710         AssetReference ref;
711         uint256 value;
712     }
713 
714     // ============ Par (Principal Amount) ============
715 
716     // Total borrow and supply values for a market
717     struct TotalPar {
718         uint128 borrow;
719         uint128 supply;
720     }
721 
722     // Individual principal amount for an account
723     struct Par {
724         bool sign; // true if positive
725         uint128 value;
726     }
727 
728     function zeroPar()
729         internal
730         pure
731         returns (Par memory)
732     {
733         return Par({
734             sign: false,
735             value: 0
736         });
737     }
738 
739     function sub(
740         Par memory a,
741         Par memory b
742     )
743         internal
744         pure
745         returns (Par memory)
746     {
747         return add(a, negative(b));
748     }
749 
750     function add(
751         Par memory a,
752         Par memory b
753     )
754         internal
755         pure
756         returns (Par memory)
757     {
758         Par memory result;
759         if (a.sign == b.sign) {
760             result.sign = a.sign;
761             result.value = SafeMath.add(a.value, b.value).to128();
762         } else {
763             if (a.value >= b.value) {
764                 result.sign = a.sign;
765                 result.value = SafeMath.sub(a.value, b.value).to128();
766             } else {
767                 result.sign = b.sign;
768                 result.value = SafeMath.sub(b.value, a.value).to128();
769             }
770         }
771         return result;
772     }
773 
774     function equals(
775         Par memory a,
776         Par memory b
777     )
778         internal
779         pure
780         returns (bool)
781     {
782         if (a.value == b.value) {
783             if (a.value == 0) {
784                 return true;
785             }
786             return a.sign == b.sign;
787         }
788         return false;
789     }
790 
791     function negative(
792         Par memory a
793     )
794         internal
795         pure
796         returns (Par memory)
797     {
798         return Par({
799             sign: !a.sign,
800             value: a.value
801         });
802     }
803 
804     function isNegative(
805         Par memory a
806     )
807         internal
808         pure
809         returns (bool)
810     {
811         return !a.sign && a.value > 0;
812     }
813 
814     function isPositive(
815         Par memory a
816     )
817         internal
818         pure
819         returns (bool)
820     {
821         return a.sign && a.value > 0;
822     }
823 
824     function isZero(
825         Par memory a
826     )
827         internal
828         pure
829         returns (bool)
830     {
831         return a.value == 0;
832     }
833 
834     // ============ Wei (Token Amount) ============
835 
836     // Individual token amount for an account
837     struct Wei {
838         bool sign; // true if positive
839         uint256 value;
840     }
841 
842     function zeroWei()
843         internal
844         pure
845         returns (Wei memory)
846     {
847         return Wei({
848             sign: false,
849             value: 0
850         });
851     }
852 
853     function sub(
854         Wei memory a,
855         Wei memory b
856     )
857         internal
858         pure
859         returns (Wei memory)
860     {
861         return add(a, negative(b));
862     }
863 
864     function add(
865         Wei memory a,
866         Wei memory b
867     )
868         internal
869         pure
870         returns (Wei memory)
871     {
872         Wei memory result;
873         if (a.sign == b.sign) {
874             result.sign = a.sign;
875             result.value = SafeMath.add(a.value, b.value);
876         } else {
877             if (a.value >= b.value) {
878                 result.sign = a.sign;
879                 result.value = SafeMath.sub(a.value, b.value);
880             } else {
881                 result.sign = b.sign;
882                 result.value = SafeMath.sub(b.value, a.value);
883             }
884         }
885         return result;
886     }
887 
888     function equals(
889         Wei memory a,
890         Wei memory b
891     )
892         internal
893         pure
894         returns (bool)
895     {
896         if (a.value == b.value) {
897             if (a.value == 0) {
898                 return true;
899             }
900             return a.sign == b.sign;
901         }
902         return false;
903     }
904 
905     function negative(
906         Wei memory a
907     )
908         internal
909         pure
910         returns (Wei memory)
911     {
912         return Wei({
913             sign: !a.sign,
914             value: a.value
915         });
916     }
917 
918     function isNegative(
919         Wei memory a
920     )
921         internal
922         pure
923         returns (bool)
924     {
925         return !a.sign && a.value > 0;
926     }
927 
928     function isPositive(
929         Wei memory a
930     )
931         internal
932         pure
933         returns (bool)
934     {
935         return a.sign && a.value > 0;
936     }
937 
938     function isZero(
939         Wei memory a
940     )
941         internal
942         pure
943         returns (bool)
944     {
945         return a.value == 0;
946     }
947 }
948 
949 // File: contracts/protocol/lib/Account.sol
950 
951 /**
952  * @title Account
953  * @author dYdX
954  *
955  * Library of structs and functions that represent an account
956  */
957 library Account {
958     // ============ Enums ============
959 
960     /*
961      * Most-recently-cached account status.
962      *
963      * Normal: Can only be liquidated if the account values are violating the global margin-ratio.
964      * Liquid: Can be liquidated no matter the account values.
965      *         Can be vaporized if there are no more positive account values.
966      * Vapor:  Has only negative (or zeroed) account values. Can be vaporized.
967      *
968      */
969     enum Status {
970         Normal,
971         Liquid,
972         Vapor
973     }
974 
975     // ============ Structs ============
976 
977     // Represents the unique key that specifies an account
978     struct Info {
979         address owner;  // The address that owns the account
980         uint256 number; // A nonce that allows a single address to control many accounts
981     }
982 
983     // The complete storage for any account
984     struct Storage {
985         mapping (uint256 => Types.Par) balances; // Mapping from marketId to principal
986         Status status;
987     }
988 
989     // ============ Library Functions ============
990 
991     function equals(
992         Info memory a,
993         Info memory b
994     )
995         internal
996         pure
997         returns (bool)
998     {
999         return a.owner == b.owner && a.number == b.number;
1000     }
1001 }
1002 
1003 // File: contracts/protocol/lib/Monetary.sol
1004 
1005 /**
1006  * @title Monetary
1007  * @author dYdX
1008  *
1009  * Library for types involving money
1010  */
1011 library Monetary {
1012 
1013     /*
1014      * The price of a base-unit of an asset.
1015      */
1016     struct Price {
1017         uint256 value;
1018     }
1019 
1020     /*
1021      * Total value of an some amount of an asset. Equal to (price * amount).
1022      */
1023     struct Value {
1024         uint256 value;
1025     }
1026 }
1027 
1028 // File: contracts/protocol/lib/Cache.sol
1029 
1030 /**
1031  * @title Cache
1032  * @author dYdX
1033  *
1034  * Library for caching information about markets
1035  */
1036 library Cache {
1037     using Cache for MarketCache;
1038     using Storage for Storage.State;
1039 
1040     // ============ Structs ============
1041 
1042     struct MarketInfo {
1043         bool isClosing;
1044         uint128 borrowPar;
1045         Monetary.Price price;
1046     }
1047 
1048     struct MarketCache {
1049         MarketInfo[] markets;
1050     }
1051 
1052     // ============ Setter Functions ============
1053 
1054     /**
1055      * Initialize an empty cache for some given number of total markets.
1056      */
1057     function create(
1058         uint256 numMarkets
1059     )
1060         internal
1061         pure
1062         returns (MarketCache memory)
1063     {
1064         return MarketCache({
1065             markets: new MarketInfo[](numMarkets)
1066         });
1067     }
1068 
1069     /**
1070      * Add market information (price and total borrowed par if the market is closing) to the cache.
1071      * Return true if the market information did not previously exist in the cache.
1072      */
1073     function addMarket(
1074         MarketCache memory cache,
1075         Storage.State storage state,
1076         uint256 marketId
1077     )
1078         internal
1079         view
1080         returns (bool)
1081     {
1082         if (cache.hasMarket(marketId)) {
1083             return false;
1084         }
1085         cache.markets[marketId].price = state.fetchPrice(marketId);
1086         if (state.markets[marketId].isClosing) {
1087             cache.markets[marketId].isClosing = true;
1088             cache.markets[marketId].borrowPar = state.getTotalPar(marketId).borrow;
1089         }
1090         return true;
1091     }
1092 
1093     // ============ Getter Functions ============
1094 
1095     function getNumMarkets(
1096         MarketCache memory cache
1097     )
1098         internal
1099         pure
1100         returns (uint256)
1101     {
1102         return cache.markets.length;
1103     }
1104 
1105     function hasMarket(
1106         MarketCache memory cache,
1107         uint256 marketId
1108     )
1109         internal
1110         pure
1111         returns (bool)
1112     {
1113         return cache.markets[marketId].price.value != 0;
1114     }
1115 
1116     function getIsClosing(
1117         MarketCache memory cache,
1118         uint256 marketId
1119     )
1120         internal
1121         pure
1122         returns (bool)
1123     {
1124         return cache.markets[marketId].isClosing;
1125     }
1126 
1127     function getPrice(
1128         MarketCache memory cache,
1129         uint256 marketId
1130     )
1131         internal
1132         pure
1133         returns (Monetary.Price memory)
1134     {
1135         return cache.markets[marketId].price;
1136     }
1137 
1138     function getBorrowPar(
1139         MarketCache memory cache,
1140         uint256 marketId
1141     )
1142         internal
1143         pure
1144         returns (uint128)
1145     {
1146         return cache.markets[marketId].borrowPar;
1147     }
1148 }
1149 
1150 // File: contracts/protocol/lib/Decimal.sol
1151 
1152 /**
1153  * @title Decimal
1154  * @author dYdX
1155  *
1156  * Library that defines a fixed-point number with 18 decimal places.
1157  */
1158 library Decimal {
1159     using SafeMath for uint256;
1160 
1161     // ============ Constants ============
1162 
1163     uint256 constant BASE = 10**18;
1164 
1165     // ============ Structs ============
1166 
1167     struct D256 {
1168         uint256 value;
1169     }
1170 
1171     // ============ Functions ============
1172 
1173     function one()
1174         internal
1175         pure
1176         returns (D256 memory)
1177     {
1178         return D256({ value: BASE });
1179     }
1180 
1181     function onePlus(
1182         D256 memory d
1183     )
1184         internal
1185         pure
1186         returns (D256 memory)
1187     {
1188         return D256({ value: d.value.add(BASE) });
1189     }
1190 
1191     function mul(
1192         uint256 target,
1193         D256 memory d
1194     )
1195         internal
1196         pure
1197         returns (uint256)
1198     {
1199         return Math.getPartial(target, d.value, BASE);
1200     }
1201 
1202     function div(
1203         uint256 target,
1204         D256 memory d
1205     )
1206         internal
1207         pure
1208         returns (uint256)
1209     {
1210         return Math.getPartial(target, BASE, d.value);
1211     }
1212 }
1213 
1214 // File: contracts/protocol/lib/Time.sol
1215 
1216 /**
1217  * @title Time
1218  * @author dYdX
1219  *
1220  * Library for dealing with time, assuming timestamps fit within 32 bits (valid until year 2106)
1221  */
1222 library Time {
1223 
1224     // ============ Library Functions ============
1225 
1226     function currentTime()
1227         internal
1228         view
1229         returns (uint32)
1230     {
1231         return Math.to32(block.timestamp);
1232     }
1233 }
1234 
1235 // File: contracts/protocol/lib/Interest.sol
1236 
1237 /**
1238  * @title Interest
1239  * @author dYdX
1240  *
1241  * Library for managing the interest rate and interest indexes of Solo
1242  */
1243 library Interest {
1244     using Math for uint256;
1245     using SafeMath for uint256;
1246 
1247     // ============ Constants ============
1248 
1249     bytes32 constant FILE = "Interest";
1250     uint64 constant BASE = 10**18;
1251 
1252     // ============ Structs ============
1253 
1254     struct Rate {
1255         uint256 value;
1256     }
1257 
1258     struct Index {
1259         uint96 borrow;
1260         uint96 supply;
1261         uint32 lastUpdate;
1262     }
1263 
1264     // ============ Library Functions ============
1265 
1266     /**
1267      * Get a new market Index based on the old index and market interest rate.
1268      * Calculate interest for borrowers by using the formula rate * time. Approximates
1269      * continuously-compounded interest when called frequently, but is much more
1270      * gas-efficient to calculate. For suppliers, the interest rate is adjusted by the earningsRate,
1271      * then prorated the across all suppliers.
1272      *
1273      * @param  index         The old index for a market
1274      * @param  rate          The current interest rate of the market
1275      * @param  totalPar      The total supply and borrow par values of the market
1276      * @param  earningsRate  The portion of the interest that is forwarded to the suppliers
1277      * @return               The updated index for a market
1278      */
1279     function calculateNewIndex(
1280         Index memory index,
1281         Rate memory rate,
1282         Types.TotalPar memory totalPar,
1283         Decimal.D256 memory earningsRate
1284     )
1285         internal
1286         view
1287         returns (Index memory)
1288     {
1289         (
1290             Types.Wei memory supplyWei,
1291             Types.Wei memory borrowWei
1292         ) = totalParToWei(totalPar, index);
1293 
1294         // get interest increase for borrowers
1295         uint32 currentTime = Time.currentTime();
1296         uint256 borrowInterest = rate.value.mul(uint256(currentTime).sub(index.lastUpdate));
1297 
1298         // get interest increase for suppliers
1299         uint256 supplyInterest;
1300         if (Types.isZero(supplyWei)) {
1301             supplyInterest = 0;
1302         } else {
1303             supplyInterest = Decimal.mul(borrowInterest, earningsRate);
1304             if (borrowWei.value < supplyWei.value) {
1305                 supplyInterest = Math.getPartial(supplyInterest, borrowWei.value, supplyWei.value);
1306             }
1307         }
1308         assert(supplyInterest <= borrowInterest);
1309 
1310         return Index({
1311             borrow: Math.getPartial(index.borrow, borrowInterest, BASE).add(index.borrow).to96(),
1312             supply: Math.getPartial(index.supply, supplyInterest, BASE).add(index.supply).to96(),
1313             lastUpdate: currentTime
1314         });
1315     }
1316 
1317     function newIndex()
1318         internal
1319         view
1320         returns (Index memory)
1321     {
1322         return Index({
1323             borrow: BASE,
1324             supply: BASE,
1325             lastUpdate: Time.currentTime()
1326         });
1327     }
1328 
1329     /*
1330      * Convert a principal amount to a token amount given an index.
1331      */
1332     function parToWei(
1333         Types.Par memory input,
1334         Index memory index
1335     )
1336         internal
1337         pure
1338         returns (Types.Wei memory)
1339     {
1340         uint256 inputValue = uint256(input.value);
1341         if (input.sign) {
1342             return Types.Wei({
1343                 sign: true,
1344                 value: inputValue.getPartial(index.supply, BASE)
1345             });
1346         } else {
1347             return Types.Wei({
1348                 sign: false,
1349                 value: inputValue.getPartialRoundUp(index.borrow, BASE)
1350             });
1351         }
1352     }
1353 
1354     /*
1355      * Convert a token amount to a principal amount given an index.
1356      */
1357     function weiToPar(
1358         Types.Wei memory input,
1359         Index memory index
1360     )
1361         internal
1362         pure
1363         returns (Types.Par memory)
1364     {
1365         if (input.sign) {
1366             return Types.Par({
1367                 sign: true,
1368                 value: input.value.getPartial(BASE, index.supply).to128()
1369             });
1370         } else {
1371             return Types.Par({
1372                 sign: false,
1373                 value: input.value.getPartialRoundUp(BASE, index.borrow).to128()
1374             });
1375         }
1376     }
1377 
1378     /*
1379      * Convert the total supply and borrow principal amounts of a market to total supply and borrow
1380      * token amounts.
1381      */
1382     function totalParToWei(
1383         Types.TotalPar memory totalPar,
1384         Index memory index
1385     )
1386         internal
1387         pure
1388         returns (Types.Wei memory, Types.Wei memory)
1389     {
1390         Types.Par memory supplyPar = Types.Par({
1391             sign: true,
1392             value: totalPar.supply
1393         });
1394         Types.Par memory borrowPar = Types.Par({
1395             sign: false,
1396             value: totalPar.borrow
1397         });
1398         Types.Wei memory supplyWei = parToWei(supplyPar, index);
1399         Types.Wei memory borrowWei = parToWei(borrowPar, index);
1400         return (supplyWei, borrowWei);
1401     }
1402 }
1403 
1404 // File: contracts/protocol/interfaces/IErc20.sol
1405 
1406 /**
1407  * @title IErc20
1408  * @author dYdX
1409  *
1410  * Interface for using ERC20 Tokens. We have to use a special interface to call ERC20 functions so
1411  * that we don't automatically revert when calling non-compliant tokens that have no return value for
1412  * transfer(), transferFrom(), or approve().
1413  */
1414 interface IErc20 {
1415     event Transfer(
1416         address indexed from,
1417         address indexed to,
1418         uint256 value
1419     );
1420 
1421     event Approval(
1422         address indexed owner,
1423         address indexed spender,
1424         uint256 value
1425     );
1426 
1427     function totalSupply(
1428     )
1429         external
1430         view
1431         returns (uint256);
1432 
1433     function balanceOf(
1434         address who
1435     )
1436         external
1437         view
1438         returns (uint256);
1439 
1440     function allowance(
1441         address owner,
1442         address spender
1443     )
1444         external
1445         view
1446         returns (uint256);
1447 
1448     function transfer(
1449         address to,
1450         uint256 value
1451     )
1452         external;
1453 
1454     function transferFrom(
1455         address from,
1456         address to,
1457         uint256 value
1458     )
1459         external;
1460 
1461     function approve(
1462         address spender,
1463         uint256 value
1464     )
1465         external;
1466 
1467     function name()
1468         external
1469         view
1470         returns (string memory);
1471 
1472     function symbol()
1473         external
1474         view
1475         returns (string memory);
1476 
1477     function decimals()
1478         external
1479         view
1480         returns (uint8);
1481 }
1482 
1483 // File: contracts/protocol/lib/Token.sol
1484 
1485 /**
1486  * @title Token
1487  * @author dYdX
1488  *
1489  * This library contains basic functions for interacting with ERC20 tokens. Modified to work with
1490  * tokens that don't adhere strictly to the ERC20 standard (for example tokens that don't return a
1491  * boolean value on success).
1492  */
1493 library Token {
1494 
1495     // ============ Constants ============
1496 
1497     bytes32 constant FILE = "Token";
1498 
1499     // ============ Library Functions ============
1500 
1501     function balanceOf(
1502         address token,
1503         address owner
1504     )
1505         internal
1506         view
1507         returns (uint256)
1508     {
1509         return IErc20(token).balanceOf(owner);
1510     }
1511 
1512     function allowance(
1513         address token,
1514         address owner,
1515         address spender
1516     )
1517         internal
1518         view
1519         returns (uint256)
1520     {
1521         return IErc20(token).allowance(owner, spender);
1522     }
1523 
1524     function approve(
1525         address token,
1526         address spender,
1527         uint256 amount
1528     )
1529         internal
1530     {
1531         IErc20(token).approve(spender, amount);
1532 
1533         Require.that(
1534             checkSuccess(),
1535             FILE,
1536             "Approve failed"
1537         );
1538     }
1539 
1540     function approveMax(
1541         address token,
1542         address spender
1543     )
1544         internal
1545     {
1546         approve(
1547             token,
1548             spender,
1549             uint256(-1)
1550         );
1551     }
1552 
1553     function transfer(
1554         address token,
1555         address to,
1556         uint256 amount
1557     )
1558         internal
1559     {
1560         if (amount == 0 || to == address(this)) {
1561             return;
1562         }
1563 
1564         IErc20(token).transfer(to, amount);
1565 
1566         Require.that(
1567             checkSuccess(),
1568             FILE,
1569             "Transfer failed"
1570         );
1571     }
1572 
1573     function transferFrom(
1574         address token,
1575         address from,
1576         address to,
1577         uint256 amount
1578     )
1579         internal
1580     {
1581         if (amount == 0 || to == from) {
1582             return;
1583         }
1584 
1585         IErc20(token).transferFrom(from, to, amount);
1586 
1587         Require.that(
1588             checkSuccess(),
1589             FILE,
1590             "TransferFrom failed"
1591         );
1592     }
1593 
1594     // ============ Private Functions ============
1595 
1596     /**
1597      * Check the return value of the previous function up to 32 bytes. Return true if the previous
1598      * function returned 0 bytes or 32 bytes that are not all-zero.
1599      */
1600     function checkSuccess(
1601     )
1602         private
1603         pure
1604         returns (bool)
1605     {
1606         uint256 returnValue = 0;
1607 
1608         /* solium-disable-next-line security/no-inline-assembly */
1609         assembly {
1610             // check number of bytes returned from last function call
1611             switch returndatasize
1612 
1613             // no bytes returned: assume success
1614             case 0x0 {
1615                 returnValue := 1
1616             }
1617 
1618             // 32 bytes returned: check if non-zero
1619             case 0x20 {
1620                 // copy 32 bytes into scratch space
1621                 returndatacopy(0x0, 0x0, 0x20)
1622 
1623                 // load those bytes into returnValue
1624                 returnValue := mload(0x0)
1625             }
1626 
1627             // not sure what was returned: don't mark as success
1628             default { }
1629         }
1630 
1631         return returnValue != 0;
1632     }
1633 }
1634 
1635 // File: contracts/protocol/interfaces/IInterestSetter.sol
1636 
1637 /**
1638  * @title IInterestSetter
1639  * @author dYdX
1640  *
1641  * Interface that Interest Setters for Solo must implement in order to report interest rates.
1642  */
1643 interface IInterestSetter {
1644 
1645     // ============ Public Functions ============
1646 
1647     /**
1648      * Get the interest rate of a token given some borrowed and supplied amounts
1649      *
1650      * @param  token        The address of the ERC20 token for the market
1651      * @param  borrowWei    The total borrowed token amount for the market
1652      * @param  supplyWei    The total supplied token amount for the market
1653      * @return              The interest rate per second
1654      */
1655     function getInterestRate(
1656         address token,
1657         uint256 borrowWei,
1658         uint256 supplyWei
1659     )
1660         external
1661         view
1662         returns (Interest.Rate memory);
1663 }
1664 
1665 // File: contracts/protocol/interfaces/IPriceOracle.sol
1666 
1667 /**
1668  * @title IPriceOracle
1669  * @author dYdX
1670  *
1671  * Interface that Price Oracles for Solo must implement in order to report prices.
1672  */
1673 contract IPriceOracle {
1674 
1675     // ============ Constants ============
1676 
1677     uint256 public constant ONE_DOLLAR = 10 ** 36;
1678 
1679     // ============ Public Functions ============
1680 
1681     /**
1682      * Get the price of a token
1683      *
1684      * @param  token  The ERC20 token address of the market
1685      * @return        The USD price of a base unit of the token, then multiplied by 10^36.
1686      *                So a USD-stable coin with 18 decimal places would return 10^18.
1687      *                This is the price of the base unit rather than the price of a "human-readable"
1688      *                token amount. Every ERC20 may have a different number of decimals.
1689      */
1690     function getPrice(
1691         address token
1692     )
1693         public
1694         view
1695         returns (Monetary.Price memory);
1696 }
1697 
1698 // File: contracts/protocol/lib/Storage.sol
1699 
1700 /**
1701  * @title Storage
1702  * @author dYdX
1703  *
1704  * Functions for reading, writing, and verifying state in Solo
1705  */
1706 library Storage {
1707     using Cache for Cache.MarketCache;
1708     using Storage for Storage.State;
1709     using Math for uint256;
1710     using Types for Types.Par;
1711     using Types for Types.Wei;
1712     using SafeMath for uint256;
1713 
1714     // ============ Constants ============
1715 
1716     bytes32 constant FILE = "Storage";
1717 
1718     // ============ Structs ============
1719 
1720     // All information necessary for tracking a market
1721     struct Market {
1722         // Contract address of the associated ERC20 token
1723         address token;
1724 
1725         // Total aggregated supply and borrow amount of the entire market
1726         Types.TotalPar totalPar;
1727 
1728         // Interest index of the market
1729         Interest.Index index;
1730 
1731         // Contract address of the price oracle for this market
1732         IPriceOracle priceOracle;
1733 
1734         // Contract address of the interest setter for this market
1735         IInterestSetter interestSetter;
1736 
1737         // Multiplier on the marginRatio for this market
1738         Decimal.D256 marginPremium;
1739 
1740         // Multiplier on the liquidationSpread for this market
1741         Decimal.D256 spreadPremium;
1742 
1743         // Whether additional borrows are allowed for this market
1744         bool isClosing;
1745     }
1746 
1747     // The global risk parameters that govern the health and security of the system
1748     struct RiskParams {
1749         // Required ratio of over-collateralization
1750         Decimal.D256 marginRatio;
1751 
1752         // Percentage penalty incurred by liquidated accounts
1753         Decimal.D256 liquidationSpread;
1754 
1755         // Percentage of the borrower's interest fee that gets passed to the suppliers
1756         Decimal.D256 earningsRate;
1757 
1758         // The minimum absolute borrow value of an account
1759         // There must be sufficient incentivize to liquidate undercollateralized accounts
1760         Monetary.Value minBorrowedValue;
1761     }
1762 
1763     // The maximum RiskParam values that can be set
1764     struct RiskLimits {
1765         uint64 marginRatioMax;
1766         uint64 liquidationSpreadMax;
1767         uint64 earningsRateMax;
1768         uint64 marginPremiumMax;
1769         uint64 spreadPremiumMax;
1770         uint128 minBorrowedValueMax;
1771     }
1772 
1773     // The entire storage state of Solo
1774     struct State {
1775         // number of markets
1776         uint256 numMarkets;
1777 
1778         // marketId => Market
1779         mapping (uint256 => Market) markets;
1780 
1781         // owner => account number => Account
1782         mapping (address => mapping (uint256 => Account.Storage)) accounts;
1783 
1784         // Addresses that can control other users accounts
1785         mapping (address => mapping (address => bool)) operators;
1786 
1787         // Addresses that can control all users accounts
1788         mapping (address => bool) globalOperators;
1789 
1790         // mutable risk parameters of the system
1791         RiskParams riskParams;
1792 
1793         // immutable risk limits of the system
1794         RiskLimits riskLimits;
1795     }
1796 
1797     // ============ Functions ============
1798 
1799     function getToken(
1800         Storage.State storage state,
1801         uint256 marketId
1802     )
1803         internal
1804         view
1805         returns (address)
1806     {
1807         return state.markets[marketId].token;
1808     }
1809 
1810     function getTotalPar(
1811         Storage.State storage state,
1812         uint256 marketId
1813     )
1814         internal
1815         view
1816         returns (Types.TotalPar memory)
1817     {
1818         return state.markets[marketId].totalPar;
1819     }
1820 
1821     function getIndex(
1822         Storage.State storage state,
1823         uint256 marketId
1824     )
1825         internal
1826         view
1827         returns (Interest.Index memory)
1828     {
1829         return state.markets[marketId].index;
1830     }
1831 
1832     function getNumExcessTokens(
1833         Storage.State storage state,
1834         uint256 marketId
1835     )
1836         internal
1837         view
1838         returns (Types.Wei memory)
1839     {
1840         Interest.Index memory index = state.getIndex(marketId);
1841         Types.TotalPar memory totalPar = state.getTotalPar(marketId);
1842 
1843         address token = state.getToken(marketId);
1844 
1845         Types.Wei memory balanceWei = Types.Wei({
1846             sign: true,
1847             value: Token.balanceOf(token, address(this))
1848         });
1849 
1850         (
1851             Types.Wei memory supplyWei,
1852             Types.Wei memory borrowWei
1853         ) = Interest.totalParToWei(totalPar, index);
1854 
1855         // borrowWei is negative, so subtracting it makes the value more positive
1856         return balanceWei.sub(borrowWei).sub(supplyWei);
1857     }
1858 
1859     function getStatus(
1860         Storage.State storage state,
1861         Account.Info memory account
1862     )
1863         internal
1864         view
1865         returns (Account.Status)
1866     {
1867         return state.accounts[account.owner][account.number].status;
1868     }
1869 
1870     function getPar(
1871         Storage.State storage state,
1872         Account.Info memory account,
1873         uint256 marketId
1874     )
1875         internal
1876         view
1877         returns (Types.Par memory)
1878     {
1879         return state.accounts[account.owner][account.number].balances[marketId];
1880     }
1881 
1882     function getWei(
1883         Storage.State storage state,
1884         Account.Info memory account,
1885         uint256 marketId
1886     )
1887         internal
1888         view
1889         returns (Types.Wei memory)
1890     {
1891         Types.Par memory par = state.getPar(account, marketId);
1892 
1893         if (par.isZero()) {
1894             return Types.zeroWei();
1895         }
1896 
1897         Interest.Index memory index = state.getIndex(marketId);
1898         return Interest.parToWei(par, index);
1899     }
1900 
1901     function getLiquidationSpreadForPair(
1902         Storage.State storage state,
1903         uint256 heldMarketId,
1904         uint256 owedMarketId
1905     )
1906         internal
1907         view
1908         returns (Decimal.D256 memory)
1909     {
1910         uint256 result = state.riskParams.liquidationSpread.value;
1911         result = Decimal.mul(result, Decimal.onePlus(state.markets[heldMarketId].spreadPremium));
1912         result = Decimal.mul(result, Decimal.onePlus(state.markets[owedMarketId].spreadPremium));
1913         return Decimal.D256({
1914             value: result
1915         });
1916     }
1917 
1918     function fetchNewIndex(
1919         Storage.State storage state,
1920         uint256 marketId,
1921         Interest.Index memory index
1922     )
1923         internal
1924         view
1925         returns (Interest.Index memory)
1926     {
1927         Interest.Rate memory rate = state.fetchInterestRate(marketId, index);
1928 
1929         return Interest.calculateNewIndex(
1930             index,
1931             rate,
1932             state.getTotalPar(marketId),
1933             state.riskParams.earningsRate
1934         );
1935     }
1936 
1937     function fetchInterestRate(
1938         Storage.State storage state,
1939         uint256 marketId,
1940         Interest.Index memory index
1941     )
1942         internal
1943         view
1944         returns (Interest.Rate memory)
1945     {
1946         Types.TotalPar memory totalPar = state.getTotalPar(marketId);
1947         (
1948             Types.Wei memory supplyWei,
1949             Types.Wei memory borrowWei
1950         ) = Interest.totalParToWei(totalPar, index);
1951 
1952         Interest.Rate memory rate = state.markets[marketId].interestSetter.getInterestRate(
1953             state.getToken(marketId),
1954             borrowWei.value,
1955             supplyWei.value
1956         );
1957 
1958         return rate;
1959     }
1960 
1961     function fetchPrice(
1962         Storage.State storage state,
1963         uint256 marketId
1964     )
1965         internal
1966         view
1967         returns (Monetary.Price memory)
1968     {
1969         IPriceOracle oracle = IPriceOracle(state.markets[marketId].priceOracle);
1970         Monetary.Price memory price = oracle.getPrice(state.getToken(marketId));
1971         Require.that(
1972             price.value != 0,
1973             FILE,
1974             "Price cannot be zero",
1975             marketId
1976         );
1977         return price;
1978     }
1979 
1980     function getAccountValues(
1981         Storage.State storage state,
1982         Account.Info memory account,
1983         Cache.MarketCache memory cache,
1984         bool adjustForLiquidity
1985     )
1986         internal
1987         view
1988         returns (Monetary.Value memory, Monetary.Value memory)
1989     {
1990         Monetary.Value memory supplyValue;
1991         Monetary.Value memory borrowValue;
1992 
1993         uint256 numMarkets = cache.getNumMarkets();
1994         for (uint256 m = 0; m < numMarkets; m++) {
1995             if (!cache.hasMarket(m)) {
1996                 continue;
1997             }
1998 
1999             Types.Wei memory userWei = state.getWei(account, m);
2000 
2001             if (userWei.isZero()) {
2002                 continue;
2003             }
2004 
2005             uint256 assetValue = userWei.value.mul(cache.getPrice(m).value);
2006             Decimal.D256 memory adjust = Decimal.one();
2007             if (adjustForLiquidity) {
2008                 adjust = Decimal.onePlus(state.markets[m].marginPremium);
2009             }
2010 
2011             if (userWei.sign) {
2012                 supplyValue.value = supplyValue.value.add(Decimal.div(assetValue, adjust));
2013             } else {
2014                 borrowValue.value = borrowValue.value.add(Decimal.mul(assetValue, adjust));
2015             }
2016         }
2017 
2018         return (supplyValue, borrowValue);
2019     }
2020 
2021     function isCollateralized(
2022         Storage.State storage state,
2023         Account.Info memory account,
2024         Cache.MarketCache memory cache,
2025         bool requireMinBorrow
2026     )
2027         internal
2028         view
2029         returns (bool)
2030     {
2031         // get account values (adjusted for liquidity)
2032         (
2033             Monetary.Value memory supplyValue,
2034             Monetary.Value memory borrowValue
2035         ) = state.getAccountValues(account, cache, /* adjustForLiquidity = */ true);
2036 
2037         if (borrowValue.value == 0) {
2038             return true;
2039         }
2040 
2041         if (requireMinBorrow) {
2042             Require.that(
2043                 borrowValue.value >= state.riskParams.minBorrowedValue.value,
2044                 FILE,
2045                 "Borrow value too low",
2046                 account.owner,
2047                 account.number,
2048                 borrowValue.value
2049             );
2050         }
2051 
2052         uint256 requiredMargin = Decimal.mul(borrowValue.value, state.riskParams.marginRatio);
2053 
2054         return supplyValue.value >= borrowValue.value.add(requiredMargin);
2055     }
2056 
2057     function isGlobalOperator(
2058         Storage.State storage state,
2059         address operator
2060     )
2061         internal
2062         view
2063         returns (bool)
2064     {
2065         return state.globalOperators[operator];
2066     }
2067 
2068     function isLocalOperator(
2069         Storage.State storage state,
2070         address owner,
2071         address operator
2072     )
2073         internal
2074         view
2075         returns (bool)
2076     {
2077         return state.operators[owner][operator];
2078     }
2079 
2080     function requireIsOperator(
2081         Storage.State storage state,
2082         Account.Info memory account,
2083         address operator
2084     )
2085         internal
2086         view
2087     {
2088         bool isValidOperator =
2089             operator == account.owner
2090             || state.isGlobalOperator(operator)
2091             || state.isLocalOperator(account.owner, operator);
2092 
2093         Require.that(
2094             isValidOperator,
2095             FILE,
2096             "Unpermissioned operator",
2097             operator
2098         );
2099     }
2100 
2101     /**
2102      * Determine and set an account's balance based on the intended balance change. Return the
2103      * equivalent amount in wei
2104      */
2105     function getNewParAndDeltaWei(
2106         Storage.State storage state,
2107         Account.Info memory account,
2108         uint256 marketId,
2109         Types.AssetAmount memory amount
2110     )
2111         internal
2112         view
2113         returns (Types.Par memory, Types.Wei memory)
2114     {
2115         Types.Par memory oldPar = state.getPar(account, marketId);
2116 
2117         if (amount.value == 0 && amount.ref == Types.AssetReference.Delta) {
2118             return (oldPar, Types.zeroWei());
2119         }
2120 
2121         Interest.Index memory index = state.getIndex(marketId);
2122         Types.Wei memory oldWei = Interest.parToWei(oldPar, index);
2123         Types.Par memory newPar;
2124         Types.Wei memory deltaWei;
2125 
2126         if (amount.denomination == Types.AssetDenomination.Wei) {
2127             deltaWei = Types.Wei({
2128                 sign: amount.sign,
2129                 value: amount.value
2130             });
2131             if (amount.ref == Types.AssetReference.Target) {
2132                 deltaWei = deltaWei.sub(oldWei);
2133             }
2134             newPar = Interest.weiToPar(oldWei.add(deltaWei), index);
2135         } else { // AssetDenomination.Par
2136             newPar = Types.Par({
2137                 sign: amount.sign,
2138                 value: amount.value.to128()
2139             });
2140             if (amount.ref == Types.AssetReference.Delta) {
2141                 newPar = oldPar.add(newPar);
2142             }
2143             deltaWei = Interest.parToWei(newPar, index).sub(oldWei);
2144         }
2145 
2146         return (newPar, deltaWei);
2147     }
2148 
2149     function getNewParAndDeltaWeiForLiquidation(
2150         Storage.State storage state,
2151         Account.Info memory account,
2152         uint256 marketId,
2153         Types.AssetAmount memory amount
2154     )
2155         internal
2156         view
2157         returns (Types.Par memory, Types.Wei memory)
2158     {
2159         Types.Par memory oldPar = state.getPar(account, marketId);
2160 
2161         Require.that(
2162             !oldPar.isPositive(),
2163             FILE,
2164             "Owed balance cannot be positive",
2165             account.owner,
2166             account.number,
2167             marketId
2168         );
2169 
2170         (
2171             Types.Par memory newPar,
2172             Types.Wei memory deltaWei
2173         ) = state.getNewParAndDeltaWei(
2174             account,
2175             marketId,
2176             amount
2177         );
2178 
2179         // if attempting to over-repay the owed asset, bound it by the maximum
2180         if (newPar.isPositive()) {
2181             newPar = Types.zeroPar();
2182             deltaWei = state.getWei(account, marketId).negative();
2183         }
2184 
2185         Require.that(
2186             !deltaWei.isNegative() && oldPar.value >= newPar.value,
2187             FILE,
2188             "Owed balance cannot increase",
2189             account.owner,
2190             account.number,
2191             marketId
2192         );
2193 
2194         // if not paying back enough wei to repay any par, then bound wei to zero
2195         if (oldPar.equals(newPar)) {
2196             deltaWei = Types.zeroWei();
2197         }
2198 
2199         return (newPar, deltaWei);
2200     }
2201 
2202     function isVaporizable(
2203         Storage.State storage state,
2204         Account.Info memory account,
2205         Cache.MarketCache memory cache
2206     )
2207         internal
2208         view
2209         returns (bool)
2210     {
2211         bool hasNegative = false;
2212         uint256 numMarkets = cache.getNumMarkets();
2213         for (uint256 m = 0; m < numMarkets; m++) {
2214             if (!cache.hasMarket(m)) {
2215                 continue;
2216             }
2217             Types.Par memory par = state.getPar(account, m);
2218             if (par.isZero()) {
2219                 continue;
2220             } else if (par.sign) {
2221                 return false;
2222             } else {
2223                 hasNegative = true;
2224             }
2225         }
2226         return hasNegative;
2227     }
2228 
2229     // =============== Setter Functions ===============
2230 
2231     function updateIndex(
2232         Storage.State storage state,
2233         uint256 marketId
2234     )
2235         internal
2236         returns (Interest.Index memory)
2237     {
2238         Interest.Index memory index = state.getIndex(marketId);
2239         if (index.lastUpdate == Time.currentTime()) {
2240             return index;
2241         }
2242         return state.markets[marketId].index = state.fetchNewIndex(marketId, index);
2243     }
2244 
2245     function setStatus(
2246         Storage.State storage state,
2247         Account.Info memory account,
2248         Account.Status status
2249     )
2250         internal
2251     {
2252         state.accounts[account.owner][account.number].status = status;
2253     }
2254 
2255     function setPar(
2256         Storage.State storage state,
2257         Account.Info memory account,
2258         uint256 marketId,
2259         Types.Par memory newPar
2260     )
2261         internal
2262     {
2263         Types.Par memory oldPar = state.getPar(account, marketId);
2264 
2265         if (Types.equals(oldPar, newPar)) {
2266             return;
2267         }
2268 
2269         // updateTotalPar
2270         Types.TotalPar memory totalPar = state.getTotalPar(marketId);
2271 
2272         // roll-back oldPar
2273         if (oldPar.sign) {
2274             totalPar.supply = uint256(totalPar.supply).sub(oldPar.value).to128();
2275         } else {
2276             totalPar.borrow = uint256(totalPar.borrow).sub(oldPar.value).to128();
2277         }
2278 
2279         // roll-forward newPar
2280         if (newPar.sign) {
2281             totalPar.supply = uint256(totalPar.supply).add(newPar.value).to128();
2282         } else {
2283             totalPar.borrow = uint256(totalPar.borrow).add(newPar.value).to128();
2284         }
2285 
2286         state.markets[marketId].totalPar = totalPar;
2287         state.accounts[account.owner][account.number].balances[marketId] = newPar;
2288     }
2289 
2290     /**
2291      * Determine and set an account's balance based on a change in wei
2292      */
2293     function setParFromDeltaWei(
2294         Storage.State storage state,
2295         Account.Info memory account,
2296         uint256 marketId,
2297         Types.Wei memory deltaWei
2298     )
2299         internal
2300     {
2301         if (deltaWei.isZero()) {
2302             return;
2303         }
2304         Interest.Index memory index = state.getIndex(marketId);
2305         Types.Wei memory oldWei = state.getWei(account, marketId);
2306         Types.Wei memory newWei = oldWei.add(deltaWei);
2307         Types.Par memory newPar = Interest.weiToPar(newWei, index);
2308         state.setPar(
2309             account,
2310             marketId,
2311             newPar
2312         );
2313     }
2314 }
2315 
2316 // File: contracts/protocol/State.sol
2317 
2318 /**
2319  * @title State
2320  * @author dYdX
2321  *
2322  * Base-level contract that holds the state of Solo
2323  */
2324 contract State
2325 {
2326     Storage.State g_state;
2327 }
2328 
2329 // File: contracts/protocol/impl/AdminImpl.sol
2330 
2331 /**
2332  * @title AdminImpl
2333  * @author dYdX
2334  *
2335  * Administrative functions to keep the protocol updated
2336  */
2337 library AdminImpl {
2338     using Storage for Storage.State;
2339     using Token for address;
2340     using Types for Types.Wei;
2341 
2342     // ============ Constants ============
2343 
2344     bytes32 constant FILE = "AdminImpl";
2345 
2346     // ============ Events ============
2347 
2348     event LogWithdrawExcessTokens(
2349         address token,
2350         uint256 amount
2351     );
2352 
2353     event LogAddMarket(
2354         uint256 marketId,
2355         address token
2356     );
2357 
2358     event LogSetIsClosing(
2359         uint256 marketId,
2360         bool isClosing
2361     );
2362 
2363     event LogSetPriceOracle(
2364         uint256 marketId,
2365         address priceOracle
2366     );
2367 
2368     event LogSetInterestSetter(
2369         uint256 marketId,
2370         address interestSetter
2371     );
2372 
2373     event LogSetMarginPremium(
2374         uint256 marketId,
2375         Decimal.D256 marginPremium
2376     );
2377 
2378     event LogSetSpreadPremium(
2379         uint256 marketId,
2380         Decimal.D256 spreadPremium
2381     );
2382 
2383     event LogSetMarginRatio(
2384         Decimal.D256 marginRatio
2385     );
2386 
2387     event LogSetLiquidationSpread(
2388         Decimal.D256 liquidationSpread
2389     );
2390 
2391     event LogSetEarningsRate(
2392         Decimal.D256 earningsRate
2393     );
2394 
2395     event LogSetMinBorrowedValue(
2396         Monetary.Value minBorrowedValue
2397     );
2398 
2399     event LogSetGlobalOperator(
2400         address operator,
2401         bool approved
2402     );
2403 
2404     // ============ Token Functions ============
2405 
2406     function ownerWithdrawExcessTokens(
2407         Storage.State storage state,
2408         uint256 marketId,
2409         address recipient
2410     )
2411         public
2412         returns (uint256)
2413     {
2414         _validateMarketId(state, marketId);
2415         Types.Wei memory excessWei = state.getNumExcessTokens(marketId);
2416 
2417         Require.that(
2418             !excessWei.isNegative(),
2419             FILE,
2420             "Negative excess"
2421         );
2422 
2423         address token = state.getToken(marketId);
2424 
2425         uint256 actualBalance = token.balanceOf(address(this));
2426         if (excessWei.value > actualBalance) {
2427             excessWei.value = actualBalance;
2428         }
2429 
2430         token.transfer(recipient, excessWei.value);
2431 
2432         emit LogWithdrawExcessTokens(token, excessWei.value);
2433 
2434         return excessWei.value;
2435     }
2436 
2437     function ownerWithdrawUnsupportedTokens(
2438         Storage.State storage state,
2439         address token,
2440         address recipient
2441     )
2442         public
2443         returns (uint256)
2444     {
2445         _requireNoMarket(state, token);
2446 
2447         uint256 balance = token.balanceOf(address(this));
2448         token.transfer(recipient, balance);
2449 
2450         emit LogWithdrawExcessTokens(token, balance);
2451 
2452         return balance;
2453     }
2454 
2455     // ============ Market Functions ============
2456 
2457     function ownerAddMarket(
2458         Storage.State storage state,
2459         address token,
2460         IPriceOracle priceOracle,
2461         IInterestSetter interestSetter,
2462         Decimal.D256 memory marginPremium,
2463         Decimal.D256 memory spreadPremium
2464     )
2465         public
2466     {
2467         _requireNoMarket(state, token);
2468 
2469         uint256 marketId = state.numMarkets;
2470 
2471         state.numMarkets++;
2472         state.markets[marketId].token = token;
2473         state.markets[marketId].index = Interest.newIndex();
2474 
2475         emit LogAddMarket(marketId, token);
2476 
2477         _setPriceOracle(state, marketId, priceOracle);
2478         _setInterestSetter(state, marketId, interestSetter);
2479         _setMarginPremium(state, marketId, marginPremium);
2480         _setSpreadPremium(state, marketId, spreadPremium);
2481     }
2482 
2483     function ownerSetIsClosing(
2484         Storage.State storage state,
2485         uint256 marketId,
2486         bool isClosing
2487     )
2488         public
2489     {
2490         _validateMarketId(state, marketId);
2491         state.markets[marketId].isClosing = isClosing;
2492         emit LogSetIsClosing(marketId, isClosing);
2493     }
2494 
2495     function ownerSetPriceOracle(
2496         Storage.State storage state,
2497         uint256 marketId,
2498         IPriceOracle priceOracle
2499     )
2500         public
2501     {
2502         _validateMarketId(state, marketId);
2503         _setPriceOracle(state, marketId, priceOracle);
2504     }
2505 
2506     function ownerSetInterestSetter(
2507         Storage.State storage state,
2508         uint256 marketId,
2509         IInterestSetter interestSetter
2510     )
2511         public
2512     {
2513         _validateMarketId(state, marketId);
2514         _setInterestSetter(state, marketId, interestSetter);
2515     }
2516 
2517     function ownerSetMarginPremium(
2518         Storage.State storage state,
2519         uint256 marketId,
2520         Decimal.D256 memory marginPremium
2521     )
2522         public
2523     {
2524         _validateMarketId(state, marketId);
2525         _setMarginPremium(state, marketId, marginPremium);
2526     }
2527 
2528     function ownerSetSpreadPremium(
2529         Storage.State storage state,
2530         uint256 marketId,
2531         Decimal.D256 memory spreadPremium
2532     )
2533         public
2534     {
2535         _validateMarketId(state, marketId);
2536         _setSpreadPremium(state, marketId, spreadPremium);
2537     }
2538 
2539     // ============ Risk Functions ============
2540 
2541     function ownerSetMarginRatio(
2542         Storage.State storage state,
2543         Decimal.D256 memory ratio
2544     )
2545         public
2546     {
2547         Require.that(
2548             ratio.value <= state.riskLimits.marginRatioMax,
2549             FILE,
2550             "Ratio too high"
2551         );
2552         Require.that(
2553             ratio.value > state.riskParams.liquidationSpread.value,
2554             FILE,
2555             "Ratio cannot be <= spread"
2556         );
2557         state.riskParams.marginRatio = ratio;
2558         emit LogSetMarginRatio(ratio);
2559     }
2560 
2561     function ownerSetLiquidationSpread(
2562         Storage.State storage state,
2563         Decimal.D256 memory spread
2564     )
2565         public
2566     {
2567         Require.that(
2568             spread.value <= state.riskLimits.liquidationSpreadMax,
2569             FILE,
2570             "Spread too high"
2571         );
2572         Require.that(
2573             spread.value < state.riskParams.marginRatio.value,
2574             FILE,
2575             "Spread cannot be >= ratio"
2576         );
2577         state.riskParams.liquidationSpread = spread;
2578         emit LogSetLiquidationSpread(spread);
2579     }
2580 
2581     function ownerSetEarningsRate(
2582         Storage.State storage state,
2583         Decimal.D256 memory earningsRate
2584     )
2585         public
2586     {
2587         Require.that(
2588             earningsRate.value <= state.riskLimits.earningsRateMax,
2589             FILE,
2590             "Rate too high"
2591         );
2592         state.riskParams.earningsRate = earningsRate;
2593         emit LogSetEarningsRate(earningsRate);
2594     }
2595 
2596     function ownerSetMinBorrowedValue(
2597         Storage.State storage state,
2598         Monetary.Value memory minBorrowedValue
2599     )
2600         public
2601     {
2602         Require.that(
2603             minBorrowedValue.value <= state.riskLimits.minBorrowedValueMax,
2604             FILE,
2605             "Value too high"
2606         );
2607         state.riskParams.minBorrowedValue = minBorrowedValue;
2608         emit LogSetMinBorrowedValue(minBorrowedValue);
2609     }
2610 
2611     // ============ Global Operator Functions ============
2612 
2613     function ownerSetGlobalOperator(
2614         Storage.State storage state,
2615         address operator,
2616         bool approved
2617     )
2618         public
2619     {
2620         state.globalOperators[operator] = approved;
2621 
2622         emit LogSetGlobalOperator(operator, approved);
2623     }
2624 
2625     // ============ Private Functions ============
2626 
2627     function _setPriceOracle(
2628         Storage.State storage state,
2629         uint256 marketId,
2630         IPriceOracle priceOracle
2631     )
2632         private
2633     {
2634         // require oracle can return non-zero price
2635         address token = state.markets[marketId].token;
2636 
2637         Require.that(
2638             priceOracle.getPrice(token).value != 0,
2639             FILE,
2640             "Invalid oracle price"
2641         );
2642 
2643         state.markets[marketId].priceOracle = priceOracle;
2644 
2645         emit LogSetPriceOracle(marketId, address(priceOracle));
2646     }
2647 
2648     function _setInterestSetter(
2649         Storage.State storage state,
2650         uint256 marketId,
2651         IInterestSetter interestSetter
2652     )
2653         private
2654     {
2655         // ensure interestSetter can return a value without reverting
2656         address token = state.markets[marketId].token;
2657         interestSetter.getInterestRate(token, 0, 0);
2658 
2659         state.markets[marketId].interestSetter = interestSetter;
2660 
2661         emit LogSetInterestSetter(marketId, address(interestSetter));
2662     }
2663 
2664     function _setMarginPremium(
2665         Storage.State storage state,
2666         uint256 marketId,
2667         Decimal.D256 memory marginPremium
2668     )
2669         private
2670     {
2671         Require.that(
2672             marginPremium.value <= state.riskLimits.marginPremiumMax,
2673             FILE,
2674             "Margin premium too high"
2675         );
2676         state.markets[marketId].marginPremium = marginPremium;
2677 
2678         emit LogSetMarginPremium(marketId, marginPremium);
2679     }
2680 
2681     function _setSpreadPremium(
2682         Storage.State storage state,
2683         uint256 marketId,
2684         Decimal.D256 memory spreadPremium
2685     )
2686         private
2687     {
2688         Require.that(
2689             spreadPremium.value <= state.riskLimits.spreadPremiumMax,
2690             FILE,
2691             "Spread premium too high"
2692         );
2693         state.markets[marketId].spreadPremium = spreadPremium;
2694 
2695         emit LogSetSpreadPremium(marketId, spreadPremium);
2696     }
2697 
2698     function _requireNoMarket(
2699         Storage.State storage state,
2700         address token
2701     )
2702         private
2703         view
2704     {
2705         uint256 numMarkets = state.numMarkets;
2706 
2707         bool marketExists = false;
2708 
2709         for (uint256 m = 0; m < numMarkets; m++) {
2710             if (state.markets[m].token == token) {
2711                 marketExists = true;
2712                 break;
2713             }
2714         }
2715 
2716         Require.that(
2717             !marketExists,
2718             FILE,
2719             "Market exists"
2720         );
2721     }
2722 
2723     function _validateMarketId(
2724         Storage.State storage state,
2725         uint256 marketId
2726     )
2727         private
2728         view
2729     {
2730         Require.that(
2731             marketId < state.numMarkets,
2732             FILE,
2733             "Market OOB",
2734             marketId
2735         );
2736     }
2737 }
2738 
2739 // File: contracts/protocol/Admin.sol
2740 
2741 /**
2742  * @title Admin
2743  * @author dYdX
2744  *
2745  * Public functions that allow the privileged owner address to manage Solo
2746  */
2747 contract Admin is
2748     State,
2749     Ownable,
2750     ReentrancyGuard
2751 {
2752     // ============ Token Functions ============
2753 
2754     /**
2755      * Withdraw an ERC20 token for which there is an associated market. Only excess tokens can be
2756      * withdrawn. The number of excess tokens is calculated by taking the current number of tokens
2757      * held in Solo, adding the number of tokens owed to Solo by borrowers, and subtracting the
2758      * number of tokens owed to suppliers by Solo.
2759      */
2760     function ownerWithdrawExcessTokens(
2761         uint256 marketId,
2762         address recipient
2763     )
2764         public
2765         onlyOwner
2766         nonReentrant
2767         returns (uint256)
2768     {
2769         return AdminImpl.ownerWithdrawExcessTokens(
2770             g_state,
2771             marketId,
2772             recipient
2773         );
2774     }
2775 
2776     /**
2777      * Withdraw an ERC20 token for which there is no associated market.
2778      */
2779     function ownerWithdrawUnsupportedTokens(
2780         address token,
2781         address recipient
2782     )
2783         public
2784         onlyOwner
2785         nonReentrant
2786         returns (uint256)
2787     {
2788         return AdminImpl.ownerWithdrawUnsupportedTokens(
2789             g_state,
2790             token,
2791             recipient
2792         );
2793     }
2794 
2795     // ============ Market Functions ============
2796 
2797     /**
2798      * Add a new market to Solo. Must be for a previously-unsupported ERC20 token.
2799      */
2800     function ownerAddMarket(
2801         address token,
2802         IPriceOracle priceOracle,
2803         IInterestSetter interestSetter,
2804         Decimal.D256 memory marginPremium,
2805         Decimal.D256 memory spreadPremium
2806     )
2807         public
2808         onlyOwner
2809         nonReentrant
2810     {
2811         AdminImpl.ownerAddMarket(
2812             g_state,
2813             token,
2814             priceOracle,
2815             interestSetter,
2816             marginPremium,
2817             spreadPremium
2818         );
2819     }
2820 
2821     /**
2822      * Set (or unset) the status of a market to "closing". The borrowedValue of a market cannot
2823      * increase while its status is "closing".
2824      */
2825     function ownerSetIsClosing(
2826         uint256 marketId,
2827         bool isClosing
2828     )
2829         public
2830         onlyOwner
2831         nonReentrant
2832     {
2833         AdminImpl.ownerSetIsClosing(
2834             g_state,
2835             marketId,
2836             isClosing
2837         );
2838     }
2839 
2840     /**
2841      * Set the price oracle for a market.
2842      */
2843     function ownerSetPriceOracle(
2844         uint256 marketId,
2845         IPriceOracle priceOracle
2846     )
2847         public
2848         onlyOwner
2849         nonReentrant
2850     {
2851         AdminImpl.ownerSetPriceOracle(
2852             g_state,
2853             marketId,
2854             priceOracle
2855         );
2856     }
2857 
2858     /**
2859      * Set the interest-setter for a market.
2860      */
2861     function ownerSetInterestSetter(
2862         uint256 marketId,
2863         IInterestSetter interestSetter
2864     )
2865         public
2866         onlyOwner
2867         nonReentrant
2868     {
2869         AdminImpl.ownerSetInterestSetter(
2870             g_state,
2871             marketId,
2872             interestSetter
2873         );
2874     }
2875 
2876     /**
2877      * Set a premium on the minimum margin-ratio for a market. This makes it so that any positions
2878      * that include this market require a higher collateralization to avoid being liquidated.
2879      */
2880     function ownerSetMarginPremium(
2881         uint256 marketId,
2882         Decimal.D256 memory marginPremium
2883     )
2884         public
2885         onlyOwner
2886         nonReentrant
2887     {
2888         AdminImpl.ownerSetMarginPremium(
2889             g_state,
2890             marketId,
2891             marginPremium
2892         );
2893     }
2894 
2895     /**
2896      * Set a premium on the liquidation spread for a market. This makes it so that any liquidations
2897      * that include this market have a higher spread than the global default.
2898      */
2899     function ownerSetSpreadPremium(
2900         uint256 marketId,
2901         Decimal.D256 memory spreadPremium
2902     )
2903         public
2904         onlyOwner
2905         nonReentrant
2906     {
2907         AdminImpl.ownerSetSpreadPremium(
2908             g_state,
2909             marketId,
2910             spreadPremium
2911         );
2912     }
2913 
2914     // ============ Risk Functions ============
2915 
2916     /**
2917      * Set the global minimum margin-ratio that every position must maintain to prevent being
2918      * liquidated.
2919      */
2920     function ownerSetMarginRatio(
2921         Decimal.D256 memory ratio
2922     )
2923         public
2924         onlyOwner
2925         nonReentrant
2926     {
2927         AdminImpl.ownerSetMarginRatio(
2928             g_state,
2929             ratio
2930         );
2931     }
2932 
2933     /**
2934      * Set the global liquidation spread. This is the spread between oracle prices that incentivizes
2935      * the liquidation of risky positions.
2936      */
2937     function ownerSetLiquidationSpread(
2938         Decimal.D256 memory spread
2939     )
2940         public
2941         onlyOwner
2942         nonReentrant
2943     {
2944         AdminImpl.ownerSetLiquidationSpread(
2945             g_state,
2946             spread
2947         );
2948     }
2949 
2950     /**
2951      * Set the global earnings-rate variable that determines what percentage of the interest paid
2952      * by borrowers gets passed-on to suppliers.
2953      */
2954     function ownerSetEarningsRate(
2955         Decimal.D256 memory earningsRate
2956     )
2957         public
2958         onlyOwner
2959         nonReentrant
2960     {
2961         AdminImpl.ownerSetEarningsRate(
2962             g_state,
2963             earningsRate
2964         );
2965     }
2966 
2967     /**
2968      * Set the global minimum-borrow value which is the minimum value of any new borrow on Solo.
2969      */
2970     function ownerSetMinBorrowedValue(
2971         Monetary.Value memory minBorrowedValue
2972     )
2973         public
2974         onlyOwner
2975         nonReentrant
2976     {
2977         AdminImpl.ownerSetMinBorrowedValue(
2978             g_state,
2979             minBorrowedValue
2980         );
2981     }
2982 
2983     // ============ Global Operator Functions ============
2984 
2985     /**
2986      * Approve (or disapprove) an address that is permissioned to be an operator for all accounts in
2987      * Solo. Intended only to approve smart-contracts.
2988      */
2989     function ownerSetGlobalOperator(
2990         address operator,
2991         bool approved
2992     )
2993         public
2994         onlyOwner
2995         nonReentrant
2996     {
2997         AdminImpl.ownerSetGlobalOperator(
2998             g_state,
2999             operator,
3000             approved
3001         );
3002     }
3003 }
3004 
3005 // File: contracts/protocol/Getters.sol
3006 
3007 /**
3008  * @title Getters
3009  * @author dYdX
3010  *
3011  * Public read-only functions that allow transparency into the state of Solo
3012  */
3013 contract Getters is
3014     State
3015 {
3016     using Cache for Cache.MarketCache;
3017     using Storage for Storage.State;
3018     using Types for Types.Par;
3019 
3020     // ============ Constants ============
3021 
3022     bytes32 FILE = "Getters";
3023 
3024     // ============ Getters for Risk ============
3025 
3026     /**
3027      * Get the global minimum margin-ratio that every position must maintain to prevent being
3028      * liquidated.
3029      *
3030      * @return  The global margin-ratio
3031      */
3032     function getMarginRatio()
3033         public
3034         view
3035         returns (Decimal.D256 memory)
3036     {
3037         return g_state.riskParams.marginRatio;
3038     }
3039 
3040     /**
3041      * Get the global liquidation spread. This is the spread between oracle prices that incentivizes
3042      * the liquidation of risky positions.
3043      *
3044      * @return  The global liquidation spread
3045      */
3046     function getLiquidationSpread()
3047         public
3048         view
3049         returns (Decimal.D256 memory)
3050     {
3051         return g_state.riskParams.liquidationSpread;
3052     }
3053 
3054     /**
3055      * Get the global earnings-rate variable that determines what percentage of the interest paid
3056      * by borrowers gets passed-on to suppliers.
3057      *
3058      * @return  The global earnings rate
3059      */
3060     function getEarningsRate()
3061         public
3062         view
3063         returns (Decimal.D256 memory)
3064     {
3065         return g_state.riskParams.earningsRate;
3066     }
3067 
3068     /**
3069      * Get the global minimum-borrow value which is the minimum value of any new borrow on Solo.
3070      *
3071      * @return  The global minimum borrow value
3072      */
3073     function getMinBorrowedValue()
3074         public
3075         view
3076         returns (Monetary.Value memory)
3077     {
3078         return g_state.riskParams.minBorrowedValue;
3079     }
3080 
3081     /**
3082      * Get all risk parameters in a single struct.
3083      *
3084      * @return  All global risk parameters
3085      */
3086     function getRiskParams()
3087         public
3088         view
3089         returns (Storage.RiskParams memory)
3090     {
3091         return g_state.riskParams;
3092     }
3093 
3094     /**
3095      * Get all risk parameter limits in a single struct. These are the maximum limits at which the
3096      * risk parameters can be set by the admin of Solo.
3097      *
3098      * @return  All global risk parameter limnits
3099      */
3100     function getRiskLimits()
3101         public
3102         view
3103         returns (Storage.RiskLimits memory)
3104     {
3105         return g_state.riskLimits;
3106     }
3107 
3108     // ============ Getters for Markets ============
3109 
3110     /**
3111      * Get the total number of markets.
3112      *
3113      * @return  The number of markets
3114      */
3115     function getNumMarkets()
3116         public
3117         view
3118         returns (uint256)
3119     {
3120         return g_state.numMarkets;
3121     }
3122 
3123     /**
3124      * Get the ERC20 token address for a market.
3125      *
3126      * @param  marketId  The market to query
3127      * @return           The token address
3128      */
3129     function getMarketTokenAddress(
3130         uint256 marketId
3131     )
3132         public
3133         view
3134         returns (address)
3135     {
3136         _requireValidMarket(marketId);
3137         return g_state.getToken(marketId);
3138     }
3139 
3140     /**
3141      * Get the total principal amounts (borrowed and supplied) for a market.
3142      *
3143      * @param  marketId  The market to query
3144      * @return           The total principal amounts
3145      */
3146     function getMarketTotalPar(
3147         uint256 marketId
3148     )
3149         public
3150         view
3151         returns (Types.TotalPar memory)
3152     {
3153         _requireValidMarket(marketId);
3154         return g_state.getTotalPar(marketId);
3155     }
3156 
3157     /**
3158      * Get the most recently cached interest index for a market.
3159      *
3160      * @param  marketId  The market to query
3161      * @return           The most recent index
3162      */
3163     function getMarketCachedIndex(
3164         uint256 marketId
3165     )
3166         public
3167         view
3168         returns (Interest.Index memory)
3169     {
3170         _requireValidMarket(marketId);
3171         return g_state.getIndex(marketId);
3172     }
3173 
3174     /**
3175      * Get the interest index for a market if it were to be updated right now.
3176      *
3177      * @param  marketId  The market to query
3178      * @return           The estimated current index
3179      */
3180     function getMarketCurrentIndex(
3181         uint256 marketId
3182     )
3183         public
3184         view
3185         returns (Interest.Index memory)
3186     {
3187         _requireValidMarket(marketId);
3188         return g_state.fetchNewIndex(marketId, g_state.getIndex(marketId));
3189     }
3190 
3191     /**
3192      * Get the price oracle address for a market.
3193      *
3194      * @param  marketId  The market to query
3195      * @return           The price oracle address
3196      */
3197     function getMarketPriceOracle(
3198         uint256 marketId
3199     )
3200         public
3201         view
3202         returns (IPriceOracle)
3203     {
3204         _requireValidMarket(marketId);
3205         return g_state.markets[marketId].priceOracle;
3206     }
3207 
3208     /**
3209      * Get the interest-setter address for a market.
3210      *
3211      * @param  marketId  The market to query
3212      * @return           The interest-setter address
3213      */
3214     function getMarketInterestSetter(
3215         uint256 marketId
3216     )
3217         public
3218         view
3219         returns (IInterestSetter)
3220     {
3221         _requireValidMarket(marketId);
3222         return g_state.markets[marketId].interestSetter;
3223     }
3224 
3225     /**
3226      * Get the margin premium for a market. A margin premium makes it so that any positions that
3227      * include the market require a higher collateralization to avoid being liquidated.
3228      *
3229      * @param  marketId  The market to query
3230      * @return           The market's margin premium
3231      */
3232     function getMarketMarginPremium(
3233         uint256 marketId
3234     )
3235         public
3236         view
3237         returns (Decimal.D256 memory)
3238     {
3239         _requireValidMarket(marketId);
3240         return g_state.markets[marketId].marginPremium;
3241     }
3242 
3243     /**
3244      * Get the spread premium for a market. A spread premium makes it so that any liquidations
3245      * that include the market have a higher spread than the global default.
3246      *
3247      * @param  marketId  The market to query
3248      * @return           The market's spread premium
3249      */
3250     function getMarketSpreadPremium(
3251         uint256 marketId
3252     )
3253         public
3254         view
3255         returns (Decimal.D256 memory)
3256     {
3257         _requireValidMarket(marketId);
3258         return g_state.markets[marketId].spreadPremium;
3259     }
3260 
3261     /**
3262      * Return true if a particular market is in closing mode. Additional borrows cannot be taken
3263      * from a market that is closing.
3264      *
3265      * @param  marketId  The market to query
3266      * @return           True if the market is closing
3267      */
3268     function getMarketIsClosing(
3269         uint256 marketId
3270     )
3271         public
3272         view
3273         returns (bool)
3274     {
3275         _requireValidMarket(marketId);
3276         return g_state.markets[marketId].isClosing;
3277     }
3278 
3279     /**
3280      * Get the price of the token for a market.
3281      *
3282      * @param  marketId  The market to query
3283      * @return           The price of each atomic unit of the token
3284      */
3285     function getMarketPrice(
3286         uint256 marketId
3287     )
3288         public
3289         view
3290         returns (Monetary.Price memory)
3291     {
3292         _requireValidMarket(marketId);
3293         return g_state.fetchPrice(marketId);
3294     }
3295 
3296     /**
3297      * Get the current borrower interest rate for a market.
3298      *
3299      * @param  marketId  The market to query
3300      * @return           The current interest rate
3301      */
3302     function getMarketInterestRate(
3303         uint256 marketId
3304     )
3305         public
3306         view
3307         returns (Interest.Rate memory)
3308     {
3309         _requireValidMarket(marketId);
3310         return g_state.fetchInterestRate(
3311             marketId,
3312             g_state.getIndex(marketId)
3313         );
3314     }
3315 
3316     /**
3317      * Get the adjusted liquidation spread for some market pair. This is equal to the global
3318      * liquidation spread multiplied by (1 + spreadPremium) for each of the two markets.
3319      *
3320      * @param  heldMarketId  The market for which the account has collateral
3321      * @param  owedMarketId  The market for which the account has borrowed tokens
3322      * @return               The adjusted liquidation spread
3323      */
3324     function getLiquidationSpreadForPair(
3325         uint256 heldMarketId,
3326         uint256 owedMarketId
3327     )
3328         public
3329         view
3330         returns (Decimal.D256 memory)
3331     {
3332         _requireValidMarket(heldMarketId);
3333         _requireValidMarket(owedMarketId);
3334         return g_state.getLiquidationSpreadForPair(heldMarketId, owedMarketId);
3335     }
3336 
3337     /**
3338      * Get basic information about a particular market.
3339      *
3340      * @param  marketId  The market to query
3341      * @return           A Storage.Market struct with the current state of the market
3342      */
3343     function getMarket(
3344         uint256 marketId
3345     )
3346         public
3347         view
3348         returns (Storage.Market memory)
3349     {
3350         _requireValidMarket(marketId);
3351         return g_state.markets[marketId];
3352     }
3353 
3354     /**
3355      * Get comprehensive information about a particular market.
3356      *
3357      * @param  marketId  The market to query
3358      * @return           A tuple containing the values:
3359      *                    - A Storage.Market struct with the current state of the market
3360      *                    - The current estimated interest index
3361      *                    - The current token price
3362      *                    - The current market interest rate
3363      */
3364     function getMarketWithInfo(
3365         uint256 marketId
3366     )
3367         public
3368         view
3369         returns (
3370             Storage.Market memory,
3371             Interest.Index memory,
3372             Monetary.Price memory,
3373             Interest.Rate memory
3374         )
3375     {
3376         _requireValidMarket(marketId);
3377         return (
3378             getMarket(marketId),
3379             getMarketCurrentIndex(marketId),
3380             getMarketPrice(marketId),
3381             getMarketInterestRate(marketId)
3382         );
3383     }
3384 
3385     /**
3386      * Get the number of excess tokens for a market. The number of excess tokens is calculated
3387      * by taking the current number of tokens held in Solo, adding the number of tokens owed to Solo
3388      * by borrowers, and subtracting the number of tokens owed to suppliers by Solo.
3389      *
3390      * @param  marketId  The market to query
3391      * @return           The number of excess tokens
3392      */
3393     function getNumExcessTokens(
3394         uint256 marketId
3395     )
3396         public
3397         view
3398         returns (Types.Wei memory)
3399     {
3400         _requireValidMarket(marketId);
3401         return g_state.getNumExcessTokens(marketId);
3402     }
3403 
3404     // ============ Getters for Accounts ============
3405 
3406     /**
3407      * Get the principal value for a particular account and market.
3408      *
3409      * @param  account   The account to query
3410      * @param  marketId  The market to query
3411      * @return           The principal value
3412      */
3413     function getAccountPar(
3414         Account.Info memory account,
3415         uint256 marketId
3416     )
3417         public
3418         view
3419         returns (Types.Par memory)
3420     {
3421         _requireValidMarket(marketId);
3422         return g_state.getPar(account, marketId);
3423     }
3424 
3425     /**
3426      * Get the token balance for a particular account and market.
3427      *
3428      * @param  account   The account to query
3429      * @param  marketId  The market to query
3430      * @return           The token amount
3431      */
3432     function getAccountWei(
3433         Account.Info memory account,
3434         uint256 marketId
3435     )
3436         public
3437         view
3438         returns (Types.Wei memory)
3439     {
3440         _requireValidMarket(marketId);
3441         return Interest.parToWei(
3442             g_state.getPar(account, marketId),
3443             g_state.fetchNewIndex(marketId, g_state.getIndex(marketId))
3444         );
3445     }
3446 
3447     /**
3448      * Get the status of an account (Normal, Liquidating, or Vaporizing).
3449      *
3450      * @param  account  The account to query
3451      * @return          The account's status
3452      */
3453     function getAccountStatus(
3454         Account.Info memory account
3455     )
3456         public
3457         view
3458         returns (Account.Status)
3459     {
3460         return g_state.getStatus(account);
3461     }
3462 
3463     /**
3464      * Get the total supplied and total borrowed value of an account.
3465      *
3466      * @param  account  The account to query
3467      * @return          The following values:
3468      *                   - The supplied value of the account
3469      *                   - The borrowed value of the account
3470      */
3471     function getAccountValues(
3472         Account.Info memory account
3473     )
3474         public
3475         view
3476         returns (Monetary.Value memory, Monetary.Value memory)
3477     {
3478         return getAccountValuesInternal(account, /* adjustForLiquidity = */ false);
3479     }
3480 
3481     /**
3482      * Get the total supplied and total borrowed values of an account adjusted by the marginPremium
3483      * of each market. Supplied values are divided by (1 + marginPremium) for each market and
3484      * borrowed values are multiplied by (1 + marginPremium) for each market. Comparing these
3485      * adjusted values gives the margin-ratio of the account which will be compared to the global
3486      * margin-ratio when determining if the account can be liquidated.
3487      *
3488      * @param  account  The account to query
3489      * @return          The following values:
3490      *                   - The supplied value of the account (adjusted for marginPremium)
3491      *                   - The borrowed value of the account (adjusted for marginPremium)
3492      */
3493     function getAdjustedAccountValues(
3494         Account.Info memory account
3495     )
3496         public
3497         view
3498         returns (Monetary.Value memory, Monetary.Value memory)
3499     {
3500         return getAccountValuesInternal(account, /* adjustForLiquidity = */ true);
3501     }
3502 
3503     /**
3504      * Get an account's summary for each market.
3505      *
3506      * @param  account  The account to query
3507      * @return          The following values:
3508      *                   - The ERC20 token address for each market
3509      *                   - The account's principal value for each market
3510      *                   - The account's (supplied or borrowed) number of tokens for each market
3511      */
3512     function getAccountBalances(
3513         Account.Info memory account
3514     )
3515         public
3516         view
3517         returns (
3518             address[] memory,
3519             Types.Par[] memory,
3520             Types.Wei[] memory
3521         )
3522     {
3523         uint256 numMarkets = g_state.numMarkets;
3524         address[] memory tokens = new address[](numMarkets);
3525         Types.Par[] memory pars = new Types.Par[](numMarkets);
3526         Types.Wei[] memory weis = new Types.Wei[](numMarkets);
3527 
3528         for (uint256 m = 0; m < numMarkets; m++) {
3529             tokens[m] = getMarketTokenAddress(m);
3530             pars[m] = getAccountPar(account, m);
3531             weis[m] = getAccountWei(account, m);
3532         }
3533 
3534         return (
3535             tokens,
3536             pars,
3537             weis
3538         );
3539     }
3540 
3541     // ============ Getters for Permissions ============
3542 
3543     /**
3544      * Return true if a particular address is approved as an operator for an owner's accounts.
3545      * Approved operators can act on the accounts of the owner as if it were the operator's own.
3546      *
3547      * @param  owner     The owner of the accounts
3548      * @param  operator  The possible operator
3549      * @return           True if operator is approved for owner's accounts
3550      */
3551     function getIsLocalOperator(
3552         address owner,
3553         address operator
3554     )
3555         public
3556         view
3557         returns (bool)
3558     {
3559         return g_state.isLocalOperator(owner, operator);
3560     }
3561 
3562     /**
3563      * Return true if a particular address is approved as a global operator. Such an address can
3564      * act on any account as if it were the operator's own.
3565      *
3566      * @param  operator  The address to query
3567      * @return           True if operator is a global operator
3568      */
3569     function getIsGlobalOperator(
3570         address operator
3571     )
3572         public
3573         view
3574         returns (bool)
3575     {
3576         return g_state.isGlobalOperator(operator);
3577     }
3578 
3579     // ============ Private Helper Functions ============
3580 
3581     /**
3582      * Revert if marketId is invalid.
3583      */
3584     function _requireValidMarket(
3585         uint256 marketId
3586     )
3587         private
3588         view
3589     {
3590         Require.that(
3591             marketId < g_state.numMarkets,
3592             FILE,
3593             "Market OOB"
3594         );
3595     }
3596 
3597     /**
3598      * Private helper for getting the monetary values of an account.
3599      */
3600     function getAccountValuesInternal(
3601         Account.Info memory account,
3602         bool adjustForLiquidity
3603     )
3604         private
3605         view
3606         returns (Monetary.Value memory, Monetary.Value memory)
3607     {
3608         uint256 numMarkets = g_state.numMarkets;
3609 
3610         // populate cache
3611         Cache.MarketCache memory cache = Cache.create(numMarkets);
3612         for (uint256 m = 0; m < numMarkets; m++) {
3613             if (!g_state.getPar(account, m).isZero()) {
3614                 cache.addMarket(g_state, m);
3615             }
3616         }
3617 
3618         return g_state.getAccountValues(account, cache, adjustForLiquidity);
3619     }
3620 }
3621 
3622 // File: contracts/protocol/interfaces/IAutoTrader.sol
3623 
3624 /**
3625  * @title IAutoTrader
3626  * @author dYdX
3627  *
3628  * Interface that Auto-Traders for Solo must implement in order to approve trades.
3629  */
3630 contract IAutoTrader {
3631 
3632     // ============ Public Functions ============
3633 
3634     /**
3635      * Allows traders to make trades approved by this smart contract. The active trader's account is
3636      * the takerAccount and the passive account (for which this contract approves trades
3637      * on-behalf-of) is the makerAccount.
3638      *
3639      * @param  inputMarketId   The market for which the trader specified the original amount
3640      * @param  outputMarketId  The market for which the trader wants the resulting amount specified
3641      * @param  makerAccount    The account for which this contract is making trades
3642      * @param  takerAccount    The account requesting the trade
3643      * @param  oldInputPar     The old principal amount for the makerAccount for the inputMarketId
3644      * @param  newInputPar     The new principal amount for the makerAccount for the inputMarketId
3645      * @param  inputWei        The change in token amount for the makerAccount for the inputMarketId
3646      * @param  data            Arbitrary data passed in by the trader
3647      * @return                 The AssetAmount for the makerAccount for the outputMarketId
3648      */
3649     function getTradeCost(
3650         uint256 inputMarketId,
3651         uint256 outputMarketId,
3652         Account.Info memory makerAccount,
3653         Account.Info memory takerAccount,
3654         Types.Par memory oldInputPar,
3655         Types.Par memory newInputPar,
3656         Types.Wei memory inputWei,
3657         bytes memory data
3658     )
3659         public
3660         returns (Types.AssetAmount memory);
3661 }
3662 
3663 // File: contracts/protocol/interfaces/ICallee.sol
3664 
3665 /**
3666  * @title ICallee
3667  * @author dYdX
3668  *
3669  * Interface that Callees for Solo must implement in order to ingest data.
3670  */
3671 contract ICallee {
3672 
3673     // ============ Public Functions ============
3674 
3675     /**
3676      * Allows users to send this contract arbitrary data.
3677      *
3678      * @param  sender       The msg.sender to Solo
3679      * @param  accountInfo  The account from which the data is being sent
3680      * @param  data         Arbitrary data given by the sender
3681      */
3682     function callFunction(
3683         address sender,
3684         Account.Info memory accountInfo,
3685         bytes memory data
3686     )
3687         public;
3688 }
3689 
3690 // File: contracts/protocol/lib/Actions.sol
3691 
3692 /**
3693  * @title Actions
3694  * @author dYdX
3695  *
3696  * Library that defines and parses valid Actions
3697  */
3698 library Actions {
3699 
3700     // ============ Constants ============
3701 
3702     bytes32 constant FILE = "Actions";
3703 
3704     // ============ Enums ============
3705 
3706     enum ActionType {
3707         Deposit,   // supply tokens
3708         Withdraw,  // borrow tokens
3709         Transfer,  // transfer balance between accounts
3710         Buy,       // buy an amount of some token (externally)
3711         Sell,      // sell an amount of some token (externally)
3712         Trade,     // trade tokens against another account
3713         Liquidate, // liquidate an undercollateralized or expiring account
3714         Vaporize,  // use excess tokens to zero-out a completely negative account
3715         Call       // send arbitrary data to an address
3716     }
3717 
3718     enum AccountLayout {
3719         OnePrimary,
3720         TwoPrimary,
3721         PrimaryAndSecondary
3722     }
3723 
3724     enum MarketLayout {
3725         ZeroMarkets,
3726         OneMarket,
3727         TwoMarkets
3728     }
3729 
3730     // ============ Structs ============
3731 
3732     /*
3733      * Arguments that are passed to Solo in an ordered list as part of a single operation.
3734      * Each ActionArgs has an actionType which specifies which action struct that this data will be
3735      * parsed into before being processed.
3736      */
3737     struct ActionArgs {
3738         ActionType actionType;
3739         uint256 accountId;
3740         Types.AssetAmount amount;
3741         uint256 primaryMarketId;
3742         uint256 secondaryMarketId;
3743         address otherAddress;
3744         uint256 otherAccountId;
3745         bytes data;
3746     }
3747 
3748     // ============ Action Types ============
3749 
3750     /*
3751      * Moves tokens from an address to Solo. Can either repay a borrow or provide additional supply.
3752      */
3753     struct DepositArgs {
3754         Types.AssetAmount amount;
3755         Account.Info account;
3756         uint256 market;
3757         address from;
3758     }
3759 
3760     /*
3761      * Moves tokens from Solo to another address. Can either borrow tokens or reduce the amount
3762      * previously supplied.
3763      */
3764     struct WithdrawArgs {
3765         Types.AssetAmount amount;
3766         Account.Info account;
3767         uint256 market;
3768         address to;
3769     }
3770 
3771     /*
3772      * Transfers balance between two accounts. The msg.sender must be an operator for both accounts.
3773      * The amount field applies to accountOne.
3774      * This action does not require any token movement since the trade is done internally to Solo.
3775      */
3776     struct TransferArgs {
3777         Types.AssetAmount amount;
3778         Account.Info accountOne;
3779         Account.Info accountTwo;
3780         uint256 market;
3781     }
3782 
3783     /*
3784      * Acquires a certain amount of tokens by spending other tokens. Sends takerMarket tokens to the
3785      * specified exchangeWrapper contract and expects makerMarket tokens in return. The amount field
3786      * applies to the makerMarket.
3787      */
3788     struct BuyArgs {
3789         Types.AssetAmount amount;
3790         Account.Info account;
3791         uint256 makerMarket;
3792         uint256 takerMarket;
3793         address exchangeWrapper;
3794         bytes orderData;
3795     }
3796 
3797     /*
3798      * Spends a certain amount of tokens to acquire other tokens. Sends takerMarket tokens to the
3799      * specified exchangeWrapper and expects makerMarket tokens in return. The amount field applies
3800      * to the takerMarket.
3801      */
3802     struct SellArgs {
3803         Types.AssetAmount amount;
3804         Account.Info account;
3805         uint256 takerMarket;
3806         uint256 makerMarket;
3807         address exchangeWrapper;
3808         bytes orderData;
3809     }
3810 
3811     /*
3812      * Trades balances between two accounts using any external contract that implements the
3813      * AutoTrader interface. The AutoTrader contract must be an operator for the makerAccount (for
3814      * which it is trading on-behalf-of). The amount field applies to the makerAccount and the
3815      * inputMarket. This proposed change to the makerAccount is passed to the AutoTrader which will
3816      * quote a change for the makerAccount in the outputMarket (or will disallow the trade).
3817      * This action does not require any token movement since the trade is done internally to Solo.
3818      */
3819     struct TradeArgs {
3820         Types.AssetAmount amount;
3821         Account.Info takerAccount;
3822         Account.Info makerAccount;
3823         uint256 inputMarket;
3824         uint256 outputMarket;
3825         address autoTrader;
3826         bytes tradeData;
3827     }
3828 
3829     /*
3830      * Each account must maintain a certain margin-ratio (specified globally). If the account falls
3831      * below this margin-ratio, it can be liquidated by any other account. This allows anyone else
3832      * (arbitrageurs) to repay any borrowed asset (owedMarket) of the liquidating account in
3833      * exchange for any collateral asset (heldMarket) of the liquidAccount. The ratio is determined
3834      * by the price ratio (given by the oracles) plus a spread (specified globally). Liquidating an
3835      * account also sets a flag on the account that the account is being liquidated. This allows
3836      * anyone to continue liquidating the account until there are no more borrows being taken by the
3837      * liquidating account. Liquidators do not have to liquidate the entire account all at once but
3838      * can liquidate as much as they choose. The liquidating flag allows liquidators to continue
3839      * liquidating the account even if it becomes collateralized through partial liquidation or
3840      * price movement.
3841      */
3842     struct LiquidateArgs {
3843         Types.AssetAmount amount;
3844         Account.Info solidAccount;
3845         Account.Info liquidAccount;
3846         uint256 owedMarket;
3847         uint256 heldMarket;
3848     }
3849 
3850     /*
3851      * Similar to liquidate, but vaporAccounts are accounts that have only negative balances
3852      * remaining. The arbitrageur pays back the negative asset (owedMarket) of the vaporAccount in
3853      * exchange for a collateral asset (heldMarket) at a favorable spread. However, since the
3854      * liquidAccount has no collateral assets, the collateral must come from Solo's excess tokens.
3855      */
3856     struct VaporizeArgs {
3857         Types.AssetAmount amount;
3858         Account.Info solidAccount;
3859         Account.Info vaporAccount;
3860         uint256 owedMarket;
3861         uint256 heldMarket;
3862     }
3863 
3864     /*
3865      * Passes arbitrary bytes of data to an external contract that implements the Callee interface.
3866      * Does not change any asset amounts. This function may be useful for setting certain variables
3867      * on layer-two contracts for certain accounts without having to make a separate Ethereum
3868      * transaction for doing so. Also, the second-layer contracts can ensure that the call is coming
3869      * from an operator of the particular account.
3870      */
3871     struct CallArgs {
3872         Account.Info account;
3873         address callee;
3874         bytes data;
3875     }
3876 
3877     // ============ Helper Functions ============
3878 
3879     function getMarketLayout(
3880         ActionType actionType
3881     )
3882         internal
3883         pure
3884         returns (MarketLayout)
3885     {
3886         if (
3887             actionType == Actions.ActionType.Deposit
3888             || actionType == Actions.ActionType.Withdraw
3889             || actionType == Actions.ActionType.Transfer
3890         ) {
3891             return MarketLayout.OneMarket;
3892         }
3893         else if (actionType == Actions.ActionType.Call) {
3894             return MarketLayout.ZeroMarkets;
3895         }
3896         return MarketLayout.TwoMarkets;
3897     }
3898 
3899     function getAccountLayout(
3900         ActionType actionType
3901     )
3902         internal
3903         pure
3904         returns (AccountLayout)
3905     {
3906         if (
3907             actionType == Actions.ActionType.Transfer
3908             || actionType == Actions.ActionType.Trade
3909         ) {
3910             return AccountLayout.TwoPrimary;
3911         } else if (
3912             actionType == Actions.ActionType.Liquidate
3913             || actionType == Actions.ActionType.Vaporize
3914         ) {
3915             return AccountLayout.PrimaryAndSecondary;
3916         }
3917         return AccountLayout.OnePrimary;
3918     }
3919 
3920     // ============ Parsing Functions ============
3921 
3922     function parseDepositArgs(
3923         Account.Info[] memory accounts,
3924         ActionArgs memory args
3925     )
3926         internal
3927         pure
3928         returns (DepositArgs memory)
3929     {
3930         assert(args.actionType == ActionType.Deposit);
3931         return DepositArgs({
3932             amount: args.amount,
3933             account: accounts[args.accountId],
3934             market: args.primaryMarketId,
3935             from: args.otherAddress
3936         });
3937     }
3938 
3939     function parseWithdrawArgs(
3940         Account.Info[] memory accounts,
3941         ActionArgs memory args
3942     )
3943         internal
3944         pure
3945         returns (WithdrawArgs memory)
3946     {
3947         assert(args.actionType == ActionType.Withdraw);
3948         return WithdrawArgs({
3949             amount: args.amount,
3950             account: accounts[args.accountId],
3951             market: args.primaryMarketId,
3952             to: args.otherAddress
3953         });
3954     }
3955 
3956     function parseTransferArgs(
3957         Account.Info[] memory accounts,
3958         ActionArgs memory args
3959     )
3960         internal
3961         pure
3962         returns (TransferArgs memory)
3963     {
3964         assert(args.actionType == ActionType.Transfer);
3965         return TransferArgs({
3966             amount: args.amount,
3967             accountOne: accounts[args.accountId],
3968             accountTwo: accounts[args.otherAccountId],
3969             market: args.primaryMarketId
3970         });
3971     }
3972 
3973     function parseBuyArgs(
3974         Account.Info[] memory accounts,
3975         ActionArgs memory args
3976     )
3977         internal
3978         pure
3979         returns (BuyArgs memory)
3980     {
3981         assert(args.actionType == ActionType.Buy);
3982         return BuyArgs({
3983             amount: args.amount,
3984             account: accounts[args.accountId],
3985             makerMarket: args.primaryMarketId,
3986             takerMarket: args.secondaryMarketId,
3987             exchangeWrapper: args.otherAddress,
3988             orderData: args.data
3989         });
3990     }
3991 
3992     function parseSellArgs(
3993         Account.Info[] memory accounts,
3994         ActionArgs memory args
3995     )
3996         internal
3997         pure
3998         returns (SellArgs memory)
3999     {
4000         assert(args.actionType == ActionType.Sell);
4001         return SellArgs({
4002             amount: args.amount,
4003             account: accounts[args.accountId],
4004             takerMarket: args.primaryMarketId,
4005             makerMarket: args.secondaryMarketId,
4006             exchangeWrapper: args.otherAddress,
4007             orderData: args.data
4008         });
4009     }
4010 
4011     function parseTradeArgs(
4012         Account.Info[] memory accounts,
4013         ActionArgs memory args
4014     )
4015         internal
4016         pure
4017         returns (TradeArgs memory)
4018     {
4019         assert(args.actionType == ActionType.Trade);
4020         return TradeArgs({
4021             amount: args.amount,
4022             takerAccount: accounts[args.accountId],
4023             makerAccount: accounts[args.otherAccountId],
4024             inputMarket: args.primaryMarketId,
4025             outputMarket: args.secondaryMarketId,
4026             autoTrader: args.otherAddress,
4027             tradeData: args.data
4028         });
4029     }
4030 
4031     function parseLiquidateArgs(
4032         Account.Info[] memory accounts,
4033         ActionArgs memory args
4034     )
4035         internal
4036         pure
4037         returns (LiquidateArgs memory)
4038     {
4039         assert(args.actionType == ActionType.Liquidate);
4040         return LiquidateArgs({
4041             amount: args.amount,
4042             solidAccount: accounts[args.accountId],
4043             liquidAccount: accounts[args.otherAccountId],
4044             owedMarket: args.primaryMarketId,
4045             heldMarket: args.secondaryMarketId
4046         });
4047     }
4048 
4049     function parseVaporizeArgs(
4050         Account.Info[] memory accounts,
4051         ActionArgs memory args
4052     )
4053         internal
4054         pure
4055         returns (VaporizeArgs memory)
4056     {
4057         assert(args.actionType == ActionType.Vaporize);
4058         return VaporizeArgs({
4059             amount: args.amount,
4060             solidAccount: accounts[args.accountId],
4061             vaporAccount: accounts[args.otherAccountId],
4062             owedMarket: args.primaryMarketId,
4063             heldMarket: args.secondaryMarketId
4064         });
4065     }
4066 
4067     function parseCallArgs(
4068         Account.Info[] memory accounts,
4069         ActionArgs memory args
4070     )
4071         internal
4072         pure
4073         returns (CallArgs memory)
4074     {
4075         assert(args.actionType == ActionType.Call);
4076         return CallArgs({
4077             account: accounts[args.accountId],
4078             callee: args.otherAddress,
4079             data: args.data
4080         });
4081     }
4082 }
4083 
4084 // File: contracts/protocol/lib/Events.sol
4085 
4086 /**
4087  * @title Events
4088  * @author dYdX
4089  *
4090  * Library to parse and emit logs from which the state of all accounts and indexes can be followed
4091  */
4092 library Events {
4093     using Types for Types.Wei;
4094     using Storage for Storage.State;
4095 
4096     // ============ Events ============
4097 
4098     event LogIndexUpdate(
4099         uint256 indexed market,
4100         Interest.Index index
4101     );
4102 
4103     event LogOperation(
4104         address sender
4105     );
4106 
4107     event LogDeposit(
4108         address indexed accountOwner,
4109         uint256 accountNumber,
4110         uint256 market,
4111         BalanceUpdate update,
4112         address from
4113     );
4114 
4115     event LogWithdraw(
4116         address indexed accountOwner,
4117         uint256 accountNumber,
4118         uint256 market,
4119         BalanceUpdate update,
4120         address to
4121     );
4122 
4123     event LogTransfer(
4124         address indexed accountOneOwner,
4125         uint256 accountOneNumber,
4126         address indexed accountTwoOwner,
4127         uint256 accountTwoNumber,
4128         uint256 market,
4129         BalanceUpdate updateOne,
4130         BalanceUpdate updateTwo
4131     );
4132 
4133     event LogBuy(
4134         address indexed accountOwner,
4135         uint256 accountNumber,
4136         uint256 takerMarket,
4137         uint256 makerMarket,
4138         BalanceUpdate takerUpdate,
4139         BalanceUpdate makerUpdate,
4140         address exchangeWrapper
4141     );
4142 
4143     event LogSell(
4144         address indexed accountOwner,
4145         uint256 accountNumber,
4146         uint256 takerMarket,
4147         uint256 makerMarket,
4148         BalanceUpdate takerUpdate,
4149         BalanceUpdate makerUpdate,
4150         address exchangeWrapper
4151     );
4152 
4153     event LogTrade(
4154         address indexed takerAccountOwner,
4155         uint256 takerAccountNumber,
4156         address indexed makerAccountOwner,
4157         uint256 makerAccountNumber,
4158         uint256 inputMarket,
4159         uint256 outputMarket,
4160         BalanceUpdate takerInputUpdate,
4161         BalanceUpdate takerOutputUpdate,
4162         BalanceUpdate makerInputUpdate,
4163         BalanceUpdate makerOutputUpdate,
4164         address autoTrader
4165     );
4166 
4167     event LogCall(
4168         address indexed accountOwner,
4169         uint256 accountNumber,
4170         address callee
4171     );
4172 
4173     event LogLiquidate(
4174         address indexed solidAccountOwner,
4175         uint256 solidAccountNumber,
4176         address indexed liquidAccountOwner,
4177         uint256 liquidAccountNumber,
4178         uint256 heldMarket,
4179         uint256 owedMarket,
4180         BalanceUpdate solidHeldUpdate,
4181         BalanceUpdate solidOwedUpdate,
4182         BalanceUpdate liquidHeldUpdate,
4183         BalanceUpdate liquidOwedUpdate
4184     );
4185 
4186     event LogVaporize(
4187         address indexed solidAccountOwner,
4188         uint256 solidAccountNumber,
4189         address indexed vaporAccountOwner,
4190         uint256 vaporAccountNumber,
4191         uint256 heldMarket,
4192         uint256 owedMarket,
4193         BalanceUpdate solidHeldUpdate,
4194         BalanceUpdate solidOwedUpdate,
4195         BalanceUpdate vaporOwedUpdate
4196     );
4197 
4198     // ============ Structs ============
4199 
4200     struct BalanceUpdate {
4201         Types.Wei deltaWei;
4202         Types.Par newPar;
4203     }
4204 
4205     // ============ Internal Functions ============
4206 
4207     function logIndexUpdate(
4208         uint256 marketId,
4209         Interest.Index memory index
4210     )
4211         internal
4212     {
4213         emit LogIndexUpdate(
4214             marketId,
4215             index
4216         );
4217     }
4218 
4219     function logOperation()
4220         internal
4221     {
4222         emit LogOperation(msg.sender);
4223     }
4224 
4225     function logDeposit(
4226         Storage.State storage state,
4227         Actions.DepositArgs memory args,
4228         Types.Wei memory deltaWei
4229     )
4230         internal
4231     {
4232         emit LogDeposit(
4233             args.account.owner,
4234             args.account.number,
4235             args.market,
4236             getBalanceUpdate(
4237                 state,
4238                 args.account,
4239                 args.market,
4240                 deltaWei
4241             ),
4242             args.from
4243         );
4244     }
4245 
4246     function logWithdraw(
4247         Storage.State storage state,
4248         Actions.WithdrawArgs memory args,
4249         Types.Wei memory deltaWei
4250     )
4251         internal
4252     {
4253         emit LogWithdraw(
4254             args.account.owner,
4255             args.account.number,
4256             args.market,
4257             getBalanceUpdate(
4258                 state,
4259                 args.account,
4260                 args.market,
4261                 deltaWei
4262             ),
4263             args.to
4264         );
4265     }
4266 
4267     function logTransfer(
4268         Storage.State storage state,
4269         Actions.TransferArgs memory args,
4270         Types.Wei memory deltaWei
4271     )
4272         internal
4273     {
4274         emit LogTransfer(
4275             args.accountOne.owner,
4276             args.accountOne.number,
4277             args.accountTwo.owner,
4278             args.accountTwo.number,
4279             args.market,
4280             getBalanceUpdate(
4281                 state,
4282                 args.accountOne,
4283                 args.market,
4284                 deltaWei
4285             ),
4286             getBalanceUpdate(
4287                 state,
4288                 args.accountTwo,
4289                 args.market,
4290                 deltaWei.negative()
4291             )
4292         );
4293     }
4294 
4295     function logBuy(
4296         Storage.State storage state,
4297         Actions.BuyArgs memory args,
4298         Types.Wei memory takerWei,
4299         Types.Wei memory makerWei
4300     )
4301         internal
4302     {
4303         emit LogBuy(
4304             args.account.owner,
4305             args.account.number,
4306             args.takerMarket,
4307             args.makerMarket,
4308             getBalanceUpdate(
4309                 state,
4310                 args.account,
4311                 args.takerMarket,
4312                 takerWei
4313             ),
4314             getBalanceUpdate(
4315                 state,
4316                 args.account,
4317                 args.makerMarket,
4318                 makerWei
4319             ),
4320             args.exchangeWrapper
4321         );
4322     }
4323 
4324     function logSell(
4325         Storage.State storage state,
4326         Actions.SellArgs memory args,
4327         Types.Wei memory takerWei,
4328         Types.Wei memory makerWei
4329     )
4330         internal
4331     {
4332         emit LogSell(
4333             args.account.owner,
4334             args.account.number,
4335             args.takerMarket,
4336             args.makerMarket,
4337             getBalanceUpdate(
4338                 state,
4339                 args.account,
4340                 args.takerMarket,
4341                 takerWei
4342             ),
4343             getBalanceUpdate(
4344                 state,
4345                 args.account,
4346                 args.makerMarket,
4347                 makerWei
4348             ),
4349             args.exchangeWrapper
4350         );
4351     }
4352 
4353     function logTrade(
4354         Storage.State storage state,
4355         Actions.TradeArgs memory args,
4356         Types.Wei memory inputWei,
4357         Types.Wei memory outputWei
4358     )
4359         internal
4360     {
4361         BalanceUpdate[4] memory updates = [
4362             getBalanceUpdate(
4363                 state,
4364                 args.takerAccount,
4365                 args.inputMarket,
4366                 inputWei.negative()
4367             ),
4368             getBalanceUpdate(
4369                 state,
4370                 args.takerAccount,
4371                 args.outputMarket,
4372                 outputWei.negative()
4373             ),
4374             getBalanceUpdate(
4375                 state,
4376                 args.makerAccount,
4377                 args.inputMarket,
4378                 inputWei
4379             ),
4380             getBalanceUpdate(
4381                 state,
4382                 args.makerAccount,
4383                 args.outputMarket,
4384                 outputWei
4385             )
4386         ];
4387 
4388         emit LogTrade(
4389             args.takerAccount.owner,
4390             args.takerAccount.number,
4391             args.makerAccount.owner,
4392             args.makerAccount.number,
4393             args.inputMarket,
4394             args.outputMarket,
4395             updates[0],
4396             updates[1],
4397             updates[2],
4398             updates[3],
4399             args.autoTrader
4400         );
4401     }
4402 
4403     function logCall(
4404         Actions.CallArgs memory args
4405     )
4406         internal
4407     {
4408         emit LogCall(
4409             args.account.owner,
4410             args.account.number,
4411             args.callee
4412         );
4413     }
4414 
4415     function logLiquidate(
4416         Storage.State storage state,
4417         Actions.LiquidateArgs memory args,
4418         Types.Wei memory heldWei,
4419         Types.Wei memory owedWei
4420     )
4421         internal
4422     {
4423         BalanceUpdate memory solidHeldUpdate = getBalanceUpdate(
4424             state,
4425             args.solidAccount,
4426             args.heldMarket,
4427             heldWei.negative()
4428         );
4429         BalanceUpdate memory solidOwedUpdate = getBalanceUpdate(
4430             state,
4431             args.solidAccount,
4432             args.owedMarket,
4433             owedWei.negative()
4434         );
4435         BalanceUpdate memory liquidHeldUpdate = getBalanceUpdate(
4436             state,
4437             args.liquidAccount,
4438             args.heldMarket,
4439             heldWei
4440         );
4441         BalanceUpdate memory liquidOwedUpdate = getBalanceUpdate(
4442             state,
4443             args.liquidAccount,
4444             args.owedMarket,
4445             owedWei
4446         );
4447 
4448         emit LogLiquidate(
4449             args.solidAccount.owner,
4450             args.solidAccount.number,
4451             args.liquidAccount.owner,
4452             args.liquidAccount.number,
4453             args.heldMarket,
4454             args.owedMarket,
4455             solidHeldUpdate,
4456             solidOwedUpdate,
4457             liquidHeldUpdate,
4458             liquidOwedUpdate
4459         );
4460     }
4461 
4462     function logVaporize(
4463         Storage.State storage state,
4464         Actions.VaporizeArgs memory args,
4465         Types.Wei memory heldWei,
4466         Types.Wei memory owedWei,
4467         Types.Wei memory excessWei
4468     )
4469         internal
4470     {
4471         BalanceUpdate memory solidHeldUpdate = getBalanceUpdate(
4472             state,
4473             args.solidAccount,
4474             args.heldMarket,
4475             heldWei.negative()
4476         );
4477         BalanceUpdate memory solidOwedUpdate = getBalanceUpdate(
4478             state,
4479             args.solidAccount,
4480             args.owedMarket,
4481             owedWei.negative()
4482         );
4483         BalanceUpdate memory vaporOwedUpdate = getBalanceUpdate(
4484             state,
4485             args.vaporAccount,
4486             args.owedMarket,
4487             owedWei.add(excessWei)
4488         );
4489 
4490         emit LogVaporize(
4491             args.solidAccount.owner,
4492             args.solidAccount.number,
4493             args.vaporAccount.owner,
4494             args.vaporAccount.number,
4495             args.heldMarket,
4496             args.owedMarket,
4497             solidHeldUpdate,
4498             solidOwedUpdate,
4499             vaporOwedUpdate
4500         );
4501     }
4502 
4503     // ============ Private Functions ============
4504 
4505     function getBalanceUpdate(
4506         Storage.State storage state,
4507         Account.Info memory account,
4508         uint256 market,
4509         Types.Wei memory deltaWei
4510     )
4511         private
4512         view
4513         returns (BalanceUpdate memory)
4514     {
4515         return BalanceUpdate({
4516             deltaWei: deltaWei,
4517             newPar: state.getPar(account, market)
4518         });
4519     }
4520 }
4521 
4522 // File: contracts/protocol/interfaces/IExchangeWrapper.sol
4523 
4524 /**
4525  * @title IExchangeWrapper
4526  * @author dYdX
4527  *
4528  * Interface that Exchange Wrappers for Solo must implement in order to trade ERC20 tokens.
4529  */
4530 interface IExchangeWrapper {
4531 
4532     // ============ Public Functions ============
4533 
4534     /**
4535      * Exchange some amount of takerToken for makerToken.
4536      *
4537      * @param  tradeOriginator      Address of the initiator of the trade (however, this value
4538      *                              cannot always be trusted as it is set at the discretion of the
4539      *                              msg.sender)
4540      * @param  receiver             Address to set allowance on once the trade has completed
4541      * @param  makerToken           Address of makerToken, the token to receive
4542      * @param  takerToken           Address of takerToken, the token to pay
4543      * @param  requestedFillAmount  Amount of takerToken being paid
4544      * @param  orderData            Arbitrary bytes data for any information to pass to the exchange
4545      * @return                      The amount of makerToken received
4546      */
4547     function exchange(
4548         address tradeOriginator,
4549         address receiver,
4550         address makerToken,
4551         address takerToken,
4552         uint256 requestedFillAmount,
4553         bytes calldata orderData
4554     )
4555         external
4556         returns (uint256);
4557 
4558     /**
4559      * Get amount of takerToken required to buy a certain amount of makerToken for a given trade.
4560      * Should match the takerToken amount used in exchangeForAmount. If the order cannot provide
4561      * exactly desiredMakerToken, then it must return the price to buy the minimum amount greater
4562      * than desiredMakerToken
4563      *
4564      * @param  makerToken         Address of makerToken, the token to receive
4565      * @param  takerToken         Address of takerToken, the token to pay
4566      * @param  desiredMakerToken  Amount of makerToken requested
4567      * @param  orderData          Arbitrary bytes data for any information to pass to the exchange
4568      * @return                    Amount of takerToken the needed to complete the exchange
4569      */
4570     function getExchangeCost(
4571         address makerToken,
4572         address takerToken,
4573         uint256 desiredMakerToken,
4574         bytes calldata orderData
4575     )
4576         external
4577         view
4578         returns (uint256);
4579 }
4580 
4581 // File: contracts/protocol/lib/Exchange.sol
4582 
4583 /**
4584  * @title Exchange
4585  * @author dYdX
4586  *
4587  * Library for transferring tokens and interacting with ExchangeWrappers by using the Wei struct
4588  */
4589 library Exchange {
4590     using Types for Types.Wei;
4591 
4592     // ============ Constants ============
4593 
4594     bytes32 constant FILE = "Exchange";
4595 
4596     // ============ Library Functions ============
4597 
4598     function transferOut(
4599         address token,
4600         address to,
4601         Types.Wei memory deltaWei
4602     )
4603         internal
4604     {
4605         Require.that(
4606             !deltaWei.isPositive(),
4607             FILE,
4608             "Cannot transferOut positive",
4609             deltaWei.value
4610         );
4611 
4612         Token.transfer(
4613             token,
4614             to,
4615             deltaWei.value
4616         );
4617     }
4618 
4619     function transferIn(
4620         address token,
4621         address from,
4622         Types.Wei memory deltaWei
4623     )
4624         internal
4625     {
4626         Require.that(
4627             !deltaWei.isNegative(),
4628             FILE,
4629             "Cannot transferIn negative",
4630             deltaWei.value
4631         );
4632 
4633         Token.transferFrom(
4634             token,
4635             from,
4636             address(this),
4637             deltaWei.value
4638         );
4639     }
4640 
4641     function getCost(
4642         address exchangeWrapper,
4643         address supplyToken,
4644         address borrowToken,
4645         Types.Wei memory desiredAmount,
4646         bytes memory orderData
4647     )
4648         internal
4649         view
4650         returns (Types.Wei memory)
4651     {
4652         Require.that(
4653             !desiredAmount.isNegative(),
4654             FILE,
4655             "Cannot getCost negative",
4656             desiredAmount.value
4657         );
4658 
4659         Types.Wei memory result;
4660         result.sign = false;
4661         result.value = IExchangeWrapper(exchangeWrapper).getExchangeCost(
4662             supplyToken,
4663             borrowToken,
4664             desiredAmount.value,
4665             orderData
4666         );
4667 
4668         return result;
4669     }
4670 
4671     function exchange(
4672         address exchangeWrapper,
4673         address accountOwner,
4674         address supplyToken,
4675         address borrowToken,
4676         Types.Wei memory requestedFillAmount,
4677         bytes memory orderData
4678     )
4679         internal
4680         returns (Types.Wei memory)
4681     {
4682         Require.that(
4683             !requestedFillAmount.isPositive(),
4684             FILE,
4685             "Cannot exchange positive",
4686             requestedFillAmount.value
4687         );
4688 
4689         transferOut(borrowToken, exchangeWrapper, requestedFillAmount);
4690 
4691         Types.Wei memory result;
4692         result.sign = true;
4693         result.value = IExchangeWrapper(exchangeWrapper).exchange(
4694             accountOwner,
4695             address(this),
4696             supplyToken,
4697             borrowToken,
4698             requestedFillAmount.value,
4699             orderData
4700         );
4701 
4702         transferIn(supplyToken, exchangeWrapper, result);
4703 
4704         return result;
4705     }
4706 }
4707 
4708 // File: contracts/protocol/impl/OperationImpl.sol
4709 
4710 /**
4711  * @title OperationImpl
4712  * @author dYdX
4713  *
4714  * Logic for processing actions
4715  */
4716 library OperationImpl {
4717     using Cache for Cache.MarketCache;
4718     using SafeMath for uint256;
4719     using Storage for Storage.State;
4720     using Types for Types.Par;
4721     using Types for Types.Wei;
4722 
4723     // ============ Constants ============
4724 
4725     bytes32 constant FILE = "OperationImpl";
4726 
4727     // ============ Public Functions ============
4728 
4729     function operate(
4730         Storage.State storage state,
4731         Account.Info[] memory accounts,
4732         Actions.ActionArgs[] memory actions
4733     )
4734         public
4735     {
4736         Events.logOperation();
4737 
4738         _verifyInputs(accounts, actions);
4739 
4740         (
4741             bool[] memory primaryAccounts,
4742             Cache.MarketCache memory cache
4743         ) = _runPreprocessing(
4744             state,
4745             accounts,
4746             actions
4747         );
4748 
4749         _runActions(
4750             state,
4751             accounts,
4752             actions,
4753             cache
4754         );
4755 
4756         _verifyFinalState(
4757             state,
4758             accounts,
4759             primaryAccounts,
4760             cache
4761         );
4762     }
4763 
4764     // ============ Helper Functions ============
4765 
4766     function _verifyInputs(
4767         Account.Info[] memory accounts,
4768         Actions.ActionArgs[] memory actions
4769     )
4770         private
4771         pure
4772     {
4773         Require.that(
4774             actions.length != 0,
4775             FILE,
4776             "Cannot have zero actions"
4777         );
4778 
4779         Require.that(
4780             accounts.length != 0,
4781             FILE,
4782             "Cannot have zero accounts"
4783         );
4784 
4785         for (uint256 a = 0; a < accounts.length; a++) {
4786             for (uint256 b = a + 1; b < accounts.length; b++) {
4787                 Require.that(
4788                     !Account.equals(accounts[a], accounts[b]),
4789                     FILE,
4790                     "Cannot duplicate accounts",
4791                     a,
4792                     b
4793                 );
4794             }
4795         }
4796     }
4797 
4798     function _runPreprocessing(
4799         Storage.State storage state,
4800         Account.Info[] memory accounts,
4801         Actions.ActionArgs[] memory actions
4802     )
4803         private
4804         returns (
4805             bool[] memory,
4806             Cache.MarketCache memory
4807         )
4808     {
4809         uint256 numMarkets = state.numMarkets;
4810         bool[] memory primaryAccounts = new bool[](accounts.length);
4811         Cache.MarketCache memory cache = Cache.create(numMarkets);
4812 
4813         // keep track of primary accounts and indexes that need updating
4814         for (uint256 i = 0; i < actions.length; i++) {
4815             Actions.ActionArgs memory arg = actions[i];
4816             Actions.ActionType actionType = arg.actionType;
4817             Actions.MarketLayout marketLayout = Actions.getMarketLayout(actionType);
4818             Actions.AccountLayout accountLayout = Actions.getAccountLayout(actionType);
4819 
4820             // parse out primary accounts
4821             if (accountLayout != Actions.AccountLayout.OnePrimary) {
4822                 Require.that(
4823                     arg.accountId != arg.otherAccountId,
4824                     FILE,
4825                     "Duplicate accounts in action",
4826                     i
4827                 );
4828                 if (accountLayout == Actions.AccountLayout.TwoPrimary) {
4829                     primaryAccounts[arg.otherAccountId] = true;
4830                 } else {
4831                     assert(accountLayout == Actions.AccountLayout.PrimaryAndSecondary);
4832                     Require.that(
4833                         !primaryAccounts[arg.otherAccountId],
4834                         FILE,
4835                         "Requires non-primary account",
4836                         arg.otherAccountId
4837                     );
4838                 }
4839             }
4840             primaryAccounts[arg.accountId] = true;
4841 
4842             // keep track of indexes to update
4843             if (marketLayout == Actions.MarketLayout.OneMarket) {
4844                 _updateMarket(state, cache, arg.primaryMarketId);
4845             } else if (marketLayout == Actions.MarketLayout.TwoMarkets) {
4846                 Require.that(
4847                     arg.primaryMarketId != arg.secondaryMarketId,
4848                     FILE,
4849                     "Duplicate markets in action",
4850                     i
4851                 );
4852                 _updateMarket(state, cache, arg.primaryMarketId);
4853                 _updateMarket(state, cache, arg.secondaryMarketId);
4854             } else {
4855                 assert(marketLayout == Actions.MarketLayout.ZeroMarkets);
4856             }
4857         }
4858 
4859         // get any other markets for which an account has a balance
4860         for (uint256 m = 0; m < numMarkets; m++) {
4861             if (cache.hasMarket(m)) {
4862                 continue;
4863             }
4864             for (uint256 a = 0; a < accounts.length; a++) {
4865                 if (!state.getPar(accounts[a], m).isZero()) {
4866                     _updateMarket(state, cache, m);
4867                     break;
4868                 }
4869             }
4870         }
4871 
4872         return (primaryAccounts, cache);
4873     }
4874 
4875     function _updateMarket(
4876         Storage.State storage state,
4877         Cache.MarketCache memory cache,
4878         uint256 marketId
4879     )
4880         private
4881     {
4882         bool updated = cache.addMarket(state, marketId);
4883         if (updated) {
4884             Events.logIndexUpdate(marketId, state.updateIndex(marketId));
4885         }
4886     }
4887 
4888     function _runActions(
4889         Storage.State storage state,
4890         Account.Info[] memory accounts,
4891         Actions.ActionArgs[] memory actions,
4892         Cache.MarketCache memory cache
4893     )
4894         private
4895     {
4896         for (uint256 i = 0; i < actions.length; i++) {
4897             Actions.ActionArgs memory action = actions[i];
4898             Actions.ActionType actionType = action.actionType;
4899 
4900             if (actionType == Actions.ActionType.Deposit) {
4901                 _deposit(state, Actions.parseDepositArgs(accounts, action));
4902             }
4903             else if (actionType == Actions.ActionType.Withdraw) {
4904                 _withdraw(state, Actions.parseWithdrawArgs(accounts, action));
4905             }
4906             else if (actionType == Actions.ActionType.Transfer) {
4907                 _transfer(state, Actions.parseTransferArgs(accounts, action));
4908             }
4909             else if (actionType == Actions.ActionType.Buy) {
4910                 _buy(state, Actions.parseBuyArgs(accounts, action));
4911             }
4912             else if (actionType == Actions.ActionType.Sell) {
4913                 _sell(state, Actions.parseSellArgs(accounts, action));
4914             }
4915             else if (actionType == Actions.ActionType.Trade) {
4916                 _trade(state, Actions.parseTradeArgs(accounts, action));
4917             }
4918             else if (actionType == Actions.ActionType.Liquidate) {
4919                 _liquidate(state, Actions.parseLiquidateArgs(accounts, action), cache);
4920             }
4921             else if (actionType == Actions.ActionType.Vaporize) {
4922                 _vaporize(state, Actions.parseVaporizeArgs(accounts, action), cache);
4923             }
4924             else  {
4925                 assert(actionType == Actions.ActionType.Call);
4926                 _call(state, Actions.parseCallArgs(accounts, action));
4927             }
4928         }
4929     }
4930 
4931     function _verifyFinalState(
4932         Storage.State storage state,
4933         Account.Info[] memory accounts,
4934         bool[] memory primaryAccounts,
4935         Cache.MarketCache memory cache
4936     )
4937         private
4938     {
4939         // verify no increase in borrowPar for closing markets
4940         uint256 numMarkets = cache.getNumMarkets();
4941         for (uint256 m = 0; m < numMarkets; m++) {
4942             if (cache.getIsClosing(m)) {
4943                 Require.that(
4944                     state.getTotalPar(m).borrow <= cache.getBorrowPar(m),
4945                     FILE,
4946                     "Market is closing",
4947                     m
4948                 );
4949             }
4950         }
4951 
4952         // verify account collateralization
4953         for (uint256 a = 0; a < accounts.length; a++) {
4954             Account.Info memory account = accounts[a];
4955 
4956             // validate minBorrowedValue
4957             bool collateralized = state.isCollateralized(account, cache, true);
4958 
4959             // don't check collateralization for non-primary accounts
4960             if (!primaryAccounts[a]) {
4961                 continue;
4962             }
4963 
4964             // check collateralization for primary accounts
4965             Require.that(
4966                 collateralized,
4967                 FILE,
4968                 "Undercollateralized account",
4969                 account.owner,
4970                 account.number
4971             );
4972 
4973             // ensure status is normal for primary accounts
4974             if (state.getStatus(account) != Account.Status.Normal) {
4975                 state.setStatus(account, Account.Status.Normal);
4976             }
4977         }
4978     }
4979 
4980     // ============ Action Functions ============
4981 
4982     function _deposit(
4983         Storage.State storage state,
4984         Actions.DepositArgs memory args
4985     )
4986         private
4987     {
4988         state.requireIsOperator(args.account, msg.sender);
4989 
4990         Require.that(
4991             args.from == msg.sender || args.from == args.account.owner,
4992             FILE,
4993             "Invalid deposit source",
4994             args.from
4995         );
4996 
4997         (
4998             Types.Par memory newPar,
4999             Types.Wei memory deltaWei
5000         ) = state.getNewParAndDeltaWei(
5001             args.account,
5002             args.market,
5003             args.amount
5004         );
5005 
5006         state.setPar(
5007             args.account,
5008             args.market,
5009             newPar
5010         );
5011 
5012         // requires a positive deltaWei
5013         Exchange.transferIn(
5014             state.getToken(args.market),
5015             args.from,
5016             deltaWei
5017         );
5018 
5019         Events.logDeposit(
5020             state,
5021             args,
5022             deltaWei
5023         );
5024     }
5025 
5026     function _withdraw(
5027         Storage.State storage state,
5028         Actions.WithdrawArgs memory args
5029     )
5030         private
5031     {
5032         state.requireIsOperator(args.account, msg.sender);
5033 
5034         (
5035             Types.Par memory newPar,
5036             Types.Wei memory deltaWei
5037         ) = state.getNewParAndDeltaWei(
5038             args.account,
5039             args.market,
5040             args.amount
5041         );
5042 
5043         state.setPar(
5044             args.account,
5045             args.market,
5046             newPar
5047         );
5048 
5049         // requires a negative deltaWei
5050         Exchange.transferOut(
5051             state.getToken(args.market),
5052             args.to,
5053             deltaWei
5054         );
5055 
5056         Events.logWithdraw(
5057             state,
5058             args,
5059             deltaWei
5060         );
5061     }
5062 
5063     function _transfer(
5064         Storage.State storage state,
5065         Actions.TransferArgs memory args
5066     )
5067         private
5068     {
5069         state.requireIsOperator(args.accountOne, msg.sender);
5070         state.requireIsOperator(args.accountTwo, msg.sender);
5071 
5072         (
5073             Types.Par memory newPar,
5074             Types.Wei memory deltaWei
5075         ) = state.getNewParAndDeltaWei(
5076             args.accountOne,
5077             args.market,
5078             args.amount
5079         );
5080 
5081         state.setPar(
5082             args.accountOne,
5083             args.market,
5084             newPar
5085         );
5086 
5087         state.setParFromDeltaWei(
5088             args.accountTwo,
5089             args.market,
5090             deltaWei.negative()
5091         );
5092 
5093         Events.logTransfer(
5094             state,
5095             args,
5096             deltaWei
5097         );
5098     }
5099 
5100     function _buy(
5101         Storage.State storage state,
5102         Actions.BuyArgs memory args
5103     )
5104         private
5105     {
5106         state.requireIsOperator(args.account, msg.sender);
5107 
5108         address takerToken = state.getToken(args.takerMarket);
5109         address makerToken = state.getToken(args.makerMarket);
5110 
5111         (
5112             Types.Par memory makerPar,
5113             Types.Wei memory makerWei
5114         ) = state.getNewParAndDeltaWei(
5115             args.account,
5116             args.makerMarket,
5117             args.amount
5118         );
5119 
5120         Types.Wei memory takerWei = Exchange.getCost(
5121             args.exchangeWrapper,
5122             makerToken,
5123             takerToken,
5124             makerWei,
5125             args.orderData
5126         );
5127 
5128         Types.Wei memory tokensReceived = Exchange.exchange(
5129             args.exchangeWrapper,
5130             args.account.owner,
5131             makerToken,
5132             takerToken,
5133             takerWei,
5134             args.orderData
5135         );
5136 
5137         Require.that(
5138             tokensReceived.value >= makerWei.value,
5139             FILE,
5140             "Buy amount less than promised",
5141             tokensReceived.value,
5142             makerWei.value
5143         );
5144 
5145         state.setPar(
5146             args.account,
5147             args.makerMarket,
5148             makerPar
5149         );
5150 
5151         state.setParFromDeltaWei(
5152             args.account,
5153             args.takerMarket,
5154             takerWei
5155         );
5156 
5157         Events.logBuy(
5158             state,
5159             args,
5160             takerWei,
5161             makerWei
5162         );
5163     }
5164 
5165     function _sell(
5166         Storage.State storage state,
5167         Actions.SellArgs memory args
5168     )
5169         private
5170     {
5171         state.requireIsOperator(args.account, msg.sender);
5172 
5173         address takerToken = state.getToken(args.takerMarket);
5174         address makerToken = state.getToken(args.makerMarket);
5175 
5176         (
5177             Types.Par memory takerPar,
5178             Types.Wei memory takerWei
5179         ) = state.getNewParAndDeltaWei(
5180             args.account,
5181             args.takerMarket,
5182             args.amount
5183         );
5184 
5185         Types.Wei memory makerWei = Exchange.exchange(
5186             args.exchangeWrapper,
5187             args.account.owner,
5188             makerToken,
5189             takerToken,
5190             takerWei,
5191             args.orderData
5192         );
5193 
5194         state.setPar(
5195             args.account,
5196             args.takerMarket,
5197             takerPar
5198         );
5199 
5200         state.setParFromDeltaWei(
5201             args.account,
5202             args.makerMarket,
5203             makerWei
5204         );
5205 
5206         Events.logSell(
5207             state,
5208             args,
5209             takerWei,
5210             makerWei
5211         );
5212     }
5213 
5214     function _trade(
5215         Storage.State storage state,
5216         Actions.TradeArgs memory args
5217     )
5218         private
5219     {
5220         state.requireIsOperator(args.takerAccount, msg.sender);
5221         state.requireIsOperator(args.makerAccount, args.autoTrader);
5222 
5223         Types.Par memory oldInputPar = state.getPar(
5224             args.makerAccount,
5225             args.inputMarket
5226         );
5227         (
5228             Types.Par memory newInputPar,
5229             Types.Wei memory inputWei
5230         ) = state.getNewParAndDeltaWei(
5231             args.makerAccount,
5232             args.inputMarket,
5233             args.amount
5234         );
5235 
5236         Types.AssetAmount memory outputAmount = IAutoTrader(args.autoTrader).getTradeCost(
5237             args.inputMarket,
5238             args.outputMarket,
5239             args.makerAccount,
5240             args.takerAccount,
5241             oldInputPar,
5242             newInputPar,
5243             inputWei,
5244             args.tradeData
5245         );
5246 
5247         (
5248             Types.Par memory newOutputPar,
5249             Types.Wei memory outputWei
5250         ) = state.getNewParAndDeltaWei(
5251             args.makerAccount,
5252             args.outputMarket,
5253             outputAmount
5254         );
5255 
5256         Require.that(
5257             outputWei.isZero() || inputWei.isZero() || outputWei.sign != inputWei.sign,
5258             FILE,
5259             "Trades cannot be one-sided"
5260         );
5261 
5262         // set the balance for the maker
5263         state.setPar(
5264             args.makerAccount,
5265             args.inputMarket,
5266             newInputPar
5267         );
5268         state.setPar(
5269             args.makerAccount,
5270             args.outputMarket,
5271             newOutputPar
5272         );
5273 
5274         // set the balance for the taker
5275         state.setParFromDeltaWei(
5276             args.takerAccount,
5277             args.inputMarket,
5278             inputWei.negative()
5279         );
5280         state.setParFromDeltaWei(
5281             args.takerAccount,
5282             args.outputMarket,
5283             outputWei.negative()
5284         );
5285 
5286         Events.logTrade(
5287             state,
5288             args,
5289             inputWei,
5290             outputWei
5291         );
5292     }
5293 
5294     function _liquidate(
5295         Storage.State storage state,
5296         Actions.LiquidateArgs memory args,
5297         Cache.MarketCache memory cache
5298     )
5299         private
5300     {
5301         state.requireIsOperator(args.solidAccount, msg.sender);
5302 
5303         // verify liquidatable
5304         if (Account.Status.Liquid != state.getStatus(args.liquidAccount)) {
5305             Require.that(
5306                 !state.isCollateralized(args.liquidAccount, cache, /* requireMinBorrow = */ false),
5307                 FILE,
5308                 "Unliquidatable account",
5309                 args.liquidAccount.owner,
5310                 args.liquidAccount.number
5311             );
5312             state.setStatus(args.liquidAccount, Account.Status.Liquid);
5313         }
5314 
5315         Types.Wei memory maxHeldWei = state.getWei(
5316             args.liquidAccount,
5317             args.heldMarket
5318         );
5319 
5320         Require.that(
5321             !maxHeldWei.isNegative(),
5322             FILE,
5323             "Collateral cannot be negative",
5324             args.liquidAccount.owner,
5325             args.liquidAccount.number,
5326             args.heldMarket
5327         );
5328 
5329         (
5330             Types.Par memory owedPar,
5331             Types.Wei memory owedWei
5332         ) = state.getNewParAndDeltaWeiForLiquidation(
5333             args.liquidAccount,
5334             args.owedMarket,
5335             args.amount
5336         );
5337 
5338         (
5339             Monetary.Price memory heldPrice,
5340             Monetary.Price memory owedPrice
5341         ) = _getLiquidationPrices(
5342             state,
5343             cache,
5344             args.heldMarket,
5345             args.owedMarket
5346         );
5347 
5348         Types.Wei memory heldWei = _owedWeiToHeldWei(owedWei, heldPrice, owedPrice);
5349 
5350         // if attempting to over-borrow the held asset, bound it by the maximum
5351         if (heldWei.value > maxHeldWei.value) {
5352             heldWei = maxHeldWei.negative();
5353             owedWei = _heldWeiToOwedWei(heldWei, heldPrice, owedPrice);
5354 
5355             state.setPar(
5356                 args.liquidAccount,
5357                 args.heldMarket,
5358                 Types.zeroPar()
5359             );
5360             state.setParFromDeltaWei(
5361                 args.liquidAccount,
5362                 args.owedMarket,
5363                 owedWei
5364             );
5365         } else {
5366             state.setPar(
5367                 args.liquidAccount,
5368                 args.owedMarket,
5369                 owedPar
5370             );
5371             state.setParFromDeltaWei(
5372                 args.liquidAccount,
5373                 args.heldMarket,
5374                 heldWei
5375             );
5376         }
5377 
5378         // set the balances for the solid account
5379         state.setParFromDeltaWei(
5380             args.solidAccount,
5381             args.owedMarket,
5382             owedWei.negative()
5383         );
5384         state.setParFromDeltaWei(
5385             args.solidAccount,
5386             args.heldMarket,
5387             heldWei.negative()
5388         );
5389 
5390         Events.logLiquidate(
5391             state,
5392             args,
5393             heldWei,
5394             owedWei
5395         );
5396     }
5397 
5398     function _vaporize(
5399         Storage.State storage state,
5400         Actions.VaporizeArgs memory args,
5401         Cache.MarketCache memory cache
5402     )
5403         private
5404     {
5405         state.requireIsOperator(args.solidAccount, msg.sender);
5406 
5407         // verify vaporizable
5408         if (Account.Status.Vapor != state.getStatus(args.vaporAccount)) {
5409             Require.that(
5410                 state.isVaporizable(args.vaporAccount, cache),
5411                 FILE,
5412                 "Unvaporizable account",
5413                 args.vaporAccount.owner,
5414                 args.vaporAccount.number
5415             );
5416             state.setStatus(args.vaporAccount, Account.Status.Vapor);
5417         }
5418 
5419         // First, attempt to refund using the same token
5420         (
5421             bool fullyRepaid,
5422             Types.Wei memory excessWei
5423         ) = _vaporizeUsingExcess(state, args);
5424         if (fullyRepaid) {
5425             Events.logVaporize(
5426                 state,
5427                 args,
5428                 Types.zeroWei(),
5429                 Types.zeroWei(),
5430                 excessWei
5431             );
5432             return;
5433         }
5434 
5435         Types.Wei memory maxHeldWei = state.getNumExcessTokens(args.heldMarket);
5436 
5437         Require.that(
5438             !maxHeldWei.isNegative(),
5439             FILE,
5440             "Excess cannot be negative",
5441             args.heldMarket
5442         );
5443 
5444         (
5445             Types.Par memory owedPar,
5446             Types.Wei memory owedWei
5447         ) = state.getNewParAndDeltaWeiForLiquidation(
5448             args.vaporAccount,
5449             args.owedMarket,
5450             args.amount
5451         );
5452 
5453         (
5454             Monetary.Price memory heldPrice,
5455             Monetary.Price memory owedPrice
5456         ) = _getLiquidationPrices(
5457             state,
5458             cache,
5459             args.heldMarket,
5460             args.owedMarket
5461         );
5462 
5463         Types.Wei memory heldWei = _owedWeiToHeldWei(owedWei, heldPrice, owedPrice);
5464 
5465         // if attempting to over-borrow the held asset, bound it by the maximum
5466         if (heldWei.value > maxHeldWei.value) {
5467             heldWei = maxHeldWei.negative();
5468             owedWei = _heldWeiToOwedWei(heldWei, heldPrice, owedPrice);
5469 
5470             state.setParFromDeltaWei(
5471                 args.vaporAccount,
5472                 args.owedMarket,
5473                 owedWei
5474             );
5475         } else {
5476             state.setPar(
5477                 args.vaporAccount,
5478                 args.owedMarket,
5479                 owedPar
5480             );
5481         }
5482 
5483         // set the balances for the solid account
5484         state.setParFromDeltaWei(
5485             args.solidAccount,
5486             args.owedMarket,
5487             owedWei.negative()
5488         );
5489         state.setParFromDeltaWei(
5490             args.solidAccount,
5491             args.heldMarket,
5492             heldWei.negative()
5493         );
5494 
5495         Events.logVaporize(
5496             state,
5497             args,
5498             heldWei,
5499             owedWei,
5500             excessWei
5501         );
5502     }
5503 
5504     function _call(
5505         Storage.State storage state,
5506         Actions.CallArgs memory args
5507     )
5508         private
5509     {
5510         state.requireIsOperator(args.account, msg.sender);
5511 
5512         ICallee(args.callee).callFunction(
5513             msg.sender,
5514             args.account,
5515             args.data
5516         );
5517 
5518         Events.logCall(args);
5519     }
5520 
5521     // ============ Private Functions ============
5522 
5523     /**
5524      * For the purposes of liquidation or vaporization, get the value-equivalent amount of heldWei
5525      * given owedWei and the (spread-adjusted) prices of each asset.
5526      */
5527     function _owedWeiToHeldWei(
5528         Types.Wei memory owedWei,
5529         Monetary.Price memory heldPrice,
5530         Monetary.Price memory owedPrice
5531     )
5532         private
5533         pure
5534         returns (Types.Wei memory)
5535     {
5536         return Types.Wei({
5537             sign: false,
5538             value: Math.getPartial(owedWei.value, owedPrice.value, heldPrice.value)
5539         });
5540     }
5541 
5542     /**
5543      * For the purposes of liquidation or vaporization, get the value-equivalent amount of owedWei
5544      * given heldWei and the (spread-adjusted) prices of each asset.
5545      */
5546     function _heldWeiToOwedWei(
5547         Types.Wei memory heldWei,
5548         Monetary.Price memory heldPrice,
5549         Monetary.Price memory owedPrice
5550     )
5551         private
5552         pure
5553         returns (Types.Wei memory)
5554     {
5555         return Types.Wei({
5556             sign: true,
5557             value: Math.getPartialRoundUp(heldWei.value, heldPrice.value, owedPrice.value)
5558         });
5559     }
5560 
5561     /**
5562      * Attempt to vaporize an account's balance using the excess tokens in the protocol. Return a
5563      * bool and a wei value. The boolean is true if and only if the balance was fully vaporized. The
5564      * Wei value is how many excess tokens were used to partially or fully vaporize the account's
5565      * negative balance.
5566      */
5567     function _vaporizeUsingExcess(
5568         Storage.State storage state,
5569         Actions.VaporizeArgs memory args
5570     )
5571         internal
5572         returns (bool, Types.Wei memory)
5573     {
5574         Types.Wei memory excessWei = state.getNumExcessTokens(args.owedMarket);
5575 
5576         // There are no excess funds, return zero
5577         if (!excessWei.isPositive()) {
5578             return (false, Types.zeroWei());
5579         }
5580 
5581         Types.Wei memory maxRefundWei = state.getWei(args.vaporAccount, args.owedMarket);
5582         maxRefundWei.sign = true;
5583 
5584         // The account is fully vaporizable using excess funds
5585         if (excessWei.value >= maxRefundWei.value) {
5586             state.setPar(
5587                 args.vaporAccount,
5588                 args.owedMarket,
5589                 Types.zeroPar()
5590             );
5591             return (true, maxRefundWei);
5592         }
5593 
5594         // The account is only partially vaporizable using excess funds
5595         else {
5596             state.setParFromDeltaWei(
5597                 args.vaporAccount,
5598                 args.owedMarket,
5599                 excessWei
5600             );
5601             return (false, excessWei);
5602         }
5603     }
5604 
5605     /**
5606      * Return the (spread-adjusted) prices of two assets for the purposes of liquidation or
5607      * vaporization.
5608      */
5609     function _getLiquidationPrices(
5610         Storage.State storage state,
5611         Cache.MarketCache memory cache,
5612         uint256 heldMarketId,
5613         uint256 owedMarketId
5614     )
5615         internal
5616         view
5617         returns (
5618             Monetary.Price memory,
5619             Monetary.Price memory
5620         )
5621     {
5622         uint256 originalPrice = cache.getPrice(owedMarketId).value;
5623         Decimal.D256 memory spread = state.getLiquidationSpreadForPair(
5624             heldMarketId,
5625             owedMarketId
5626         );
5627 
5628         Monetary.Price memory owedPrice = Monetary.Price({
5629             value: originalPrice.add(Decimal.mul(originalPrice, spread))
5630         });
5631 
5632         return (cache.getPrice(heldMarketId), owedPrice);
5633     }
5634 }
5635 
5636 // File: contracts/protocol/Operation.sol
5637 
5638 /**
5639  * @title Operation
5640  * @author dYdX
5641  *
5642  * Primary public function for allowing users and contracts to manage accounts within Solo
5643  */
5644 contract Operation is
5645     State,
5646     ReentrancyGuard
5647 {
5648     // ============ Public Functions ============
5649 
5650     /**
5651      * The main entry-point to Solo that allows users and contracts to manage accounts.
5652      * Take one or more actions on one or more accounts. The msg.sender must be the owner or
5653      * operator of all accounts except for those being liquidated, vaporized, or traded with.
5654      * One call to operate() is considered a singular "operation". Account collateralization is
5655      * ensured only after the completion of the entire operation.
5656      *
5657      * @param  accounts  A list of all accounts that will be used in this operation. Cannot contain
5658      *                   duplicates. In each action, the relevant account will be referred-to by its
5659      *                   index in the list.
5660      * @param  actions   An ordered list of all actions that will be taken in this operation. The
5661      *                   actions will be processed in order.
5662      */
5663     function operate(
5664         Account.Info[] memory accounts,
5665         Actions.ActionArgs[] memory actions
5666     )
5667         public
5668         nonReentrant
5669     {
5670         OperationImpl.operate(
5671             g_state,
5672             accounts,
5673             actions
5674         );
5675     }
5676 }
5677 
5678 // File: contracts/protocol/Permission.sol
5679 
5680 /**
5681  * @title Permission
5682  * @author dYdX
5683  *
5684  * Public function that allows other addresses to manage accounts
5685  */
5686 contract Permission is
5687     State
5688 {
5689     // ============ Events ============
5690 
5691     event LogOperatorSet(
5692         address indexed owner,
5693         address operator,
5694         bool trusted
5695     );
5696 
5697     // ============ Structs ============
5698 
5699     struct OperatorArg {
5700         address operator;
5701         bool trusted;
5702     }
5703 
5704     // ============ Public Functions ============
5705 
5706     /**
5707      * Approves/disapproves any number of operators. An operator is an external address that has the
5708      * same permissions to manipulate an account as the owner of the account. Operators are simply
5709      * addresses and therefore may either be externally-owned Ethereum accounts OR smart contracts.
5710      *
5711      * Operators are also able to act as AutoTrader contracts on behalf of the account owner if the
5712      * operator is a smart contract and implements the IAutoTrader interface.
5713      *
5714      * @param  args  A list of OperatorArgs which have an address and a boolean. The boolean value
5715      *               denotes whether to approve (true) or revoke approval (false) for that address.
5716      */
5717     function setOperators(
5718         OperatorArg[] memory args
5719     )
5720         public
5721     {
5722         for (uint256 i = 0; i < args.length; i++) {
5723             address operator = args[i].operator;
5724             bool trusted = args[i].trusted;
5725             g_state.operators[msg.sender][operator] = trusted;
5726             emit LogOperatorSet(msg.sender, operator, trusted);
5727         }
5728     }
5729 }
5730 
5731 // File: contracts/protocol/SoloMargin.sol
5732 
5733 /**
5734  * @title SoloMargin
5735  * @author dYdX
5736  *
5737  * Main contract that inherits from other contracts
5738  */
5739 contract SoloMargin is
5740     State,
5741     Admin,
5742     Getters,
5743     Operation,
5744     Permission
5745 {
5746     // ============ Constructor ============
5747 
5748     constructor(
5749         Storage.RiskParams memory riskParams,
5750         Storage.RiskLimits memory riskLimits
5751     )
5752         public
5753     {
5754         g_state.riskParams = riskParams;
5755         g_state.riskLimits = riskLimits;
5756     }
5757 }
5758 
5759 // File: contracts/external/helpers/OnlySolo.sol
5760 
5761 /**
5762  * @title OnlySolo
5763  * @author dYdX
5764  *
5765  * Inheritable contract that restricts the calling of certain functions to Solo only
5766  */
5767 contract OnlySolo {
5768 
5769     // ============ Constants ============
5770 
5771     bytes32 constant FILE = "OnlySolo";
5772 
5773     // ============ Storage ============
5774 
5775     SoloMargin public SOLO_MARGIN;
5776 
5777     // ============ Constructor ============
5778 
5779     constructor (
5780         address soloMargin
5781     )
5782         public
5783     {
5784         SOLO_MARGIN = SoloMargin(soloMargin);
5785     }
5786 
5787     // ============ Modifiers ============
5788 
5789     modifier onlySolo(address from) {
5790         Require.that(
5791             from == address(SOLO_MARGIN),
5792             FILE,
5793             "Only Solo can call function",
5794             from
5795         );
5796         _;
5797     }
5798 }
5799 
5800 // File: contracts/external/proxies/PayableProxyForSoloMargin.sol
5801 
5802 /**
5803  * @title PayableProxyForSoloMargin
5804  * @author dYdX
5805  *
5806  * Contract for wrapping/unwrapping ETH before/after interacting with Solo
5807  */
5808 contract PayableProxyForSoloMargin is
5809     OnlySolo,
5810     ReentrancyGuard
5811 {
5812     // ============ Constants ============
5813 
5814     bytes32 constant FILE = "PayableProxyForSoloMargin";
5815 
5816     // ============ Storage ============
5817 
5818     WETH9 public WETH;
5819 
5820     // ============ Constructor ============
5821 
5822     constructor (
5823         address soloMargin,
5824         address payable weth
5825     )
5826         public
5827         OnlySolo(soloMargin)
5828     {
5829         WETH = WETH9(weth);
5830         WETH.approve(soloMargin, uint256(-1));
5831     }
5832 
5833     // ============ Public Functions ============
5834 
5835     /**
5836      * Fallback function. Disallows ether to be sent to this contract without data except when
5837      * unwrapping WETH.
5838      */
5839     function ()
5840         external
5841         payable
5842     {
5843         require( // coverage-disable-line
5844             msg.sender == address(WETH),
5845             "Cannot receive ETH"
5846         );
5847     }
5848 
5849     function operate(
5850         Account.Info[] memory accounts,
5851         Actions.ActionArgs[] memory actions,
5852         address payable sendEthTo
5853     )
5854         public
5855         payable
5856         nonReentrant
5857     {
5858         WETH9 weth = WETH;
5859 
5860         // create WETH from ETH
5861         if (msg.value != 0) {
5862             weth.deposit.value(msg.value)();
5863         }
5864 
5865         // validate the input
5866         for (uint256 i = 0; i < actions.length; i++) {
5867             Actions.ActionArgs memory action = actions[i];
5868 
5869             // Can only operate on accounts owned by msg.sender
5870             address owner1 = accounts[action.accountId].owner;
5871             Require.that(
5872                 owner1 == msg.sender,
5873                 FILE,
5874                 "Sender must be primary account",
5875                 owner1
5876             );
5877 
5878             // For a transfer both accounts must be owned by msg.sender
5879             if (action.actionType == Actions.ActionType.Transfer) {
5880                 address owner2 = accounts[action.otherAccountId].owner;
5881                 Require.that(
5882                     owner2 == msg.sender,
5883                     FILE,
5884                     "Sender must be secondary account",
5885                     owner2
5886                 );
5887             }
5888         }
5889 
5890         SOLO_MARGIN.operate(accounts, actions);
5891 
5892         // return all remaining WETH to the sendEthTo as ETH
5893         uint256 remainingWeth = weth.balanceOf(address(this));
5894         if (remainingWeth != 0) {
5895             Require.that(
5896                 sendEthTo != address(0),
5897                 FILE,
5898                 "Must set sendEthTo"
5899             );
5900 
5901             weth.withdraw(remainingWeth);
5902             sendEthTo.transfer(remainingWeth);
5903         }
5904     }
5905 }