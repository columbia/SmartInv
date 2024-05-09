1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.0;
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
160 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
161 
162 pragma solidity ^0.5.0;
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
241 /*
242     Copyright 2019 dYdX Trading Inc.
243 
244     Licensed under the Apache License, Version 2.0 (the "License");
245     you may not use this file except in compliance with the License.
246     You may obtain a copy of the License at
247 
248     http://www.apache.org/licenses/LICENSE-2.0
249 
250     Unless required by applicable law or agreed to in writing, software
251     distributed under the License is distributed on an "AS IS" BASIS,
252     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
253     See the License for the specific language governing permissions and
254     limitations under the License.
255 */
256 
257 pragma solidity ^0.5.7;
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
285     internal
286     pure
287     {
288         if (!must) {
289             revert(
290                 string(
291                     abi.encodePacked(
292                         stringifyTruncated(file),
293                         COLON,
294                         stringifyTruncated(reason)
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
307     internal
308     pure
309     {
310         if (!must) {
311             revert(
312                 string(
313                     abi.encodePacked(
314                         stringifyTruncated(file),
315                         COLON,
316                         stringifyTruncated(reason),
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
333     internal
334     pure
335     {
336         if (!must) {
337             revert(
338                 string(
339                     abi.encodePacked(
340                         stringifyTruncated(file),
341                         COLON,
342                         stringifyTruncated(reason),
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
360     internal
361     pure
362     {
363         if (!must) {
364             revert(
365                 string(
366                     abi.encodePacked(
367                         stringifyTruncated(file),
368                         COLON,
369                         stringifyTruncated(reason),
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
386     internal
387     pure
388     {
389         if (!must) {
390             revert(
391                 string(
392                     abi.encodePacked(
393                         stringifyTruncated(file),
394                         COLON,
395                         stringifyTruncated(reason),
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
415     internal
416     pure
417     {
418         if (!must) {
419             revert(
420                 string(
421                     abi.encodePacked(
422                         stringifyTruncated(file),
423                         COLON,
424                         stringifyTruncated(reason),
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
438     function that(
439         bool must,
440         bytes32 file,
441         bytes32 reason,
442         bytes32 payloadA
443     )
444     internal
445     pure
446     {
447         if (!must) {
448             revert(
449                 string(
450                     abi.encodePacked(
451                         stringifyTruncated(file),
452                         COLON,
453                         stringifyTruncated(reason),
454                         LPAREN,
455                         stringify(payloadA),
456                         RPAREN
457                     )
458                 )
459             );
460         }
461     }
462 
463     function that(
464         bool must,
465         bytes32 file,
466         bytes32 reason,
467         bytes32 payloadA,
468         uint256 payloadB,
469         uint256 payloadC
470     )
471     internal
472     pure
473     {
474         if (!must) {
475             revert(
476                 string(
477                     abi.encodePacked(
478                         stringifyTruncated(file),
479                         COLON,
480                         stringifyTruncated(reason),
481                         LPAREN,
482                         stringify(payloadA),
483                         COMMA,
484                         stringify(payloadB),
485                         COMMA,
486                         stringify(payloadC),
487                         RPAREN
488                     )
489                 )
490             );
491         }
492     }
493 
494     // ============ Private Functions ============
495 
496     function stringifyTruncated(
497         bytes32 input
498     )
499     private
500     pure
501     returns (bytes memory)
502     {
503         // put the input bytes into the result
504         bytes memory result = abi.encodePacked(input);
505 
506         // determine the length of the input by finding the location of the last non-zero byte
507         for (uint256 i = 32; i > 0; ) {
508             // reverse-for-loops with unsigned integer
509             /* solium-disable-next-line security/no-modify-for-iter-var */
510             i--;
511 
512             // find the last non-zero byte in order to determine the length
513             if (result[i] != 0) {
514                 uint256 length = i + 1;
515 
516                 /* solium-disable-next-line security/no-inline-assembly */
517                 assembly {
518                     mstore(result, length) // r.length = length;
519                 }
520 
521                 return result;
522             }
523         }
524 
525         // all bytes are zero
526         return new bytes(0);
527     }
528 
529     function stringify(
530         uint256 input
531     )
532     private
533     pure
534     returns (bytes memory)
535     {
536         if (input == 0) {
537             return "0";
538         }
539 
540         // get the final string length
541         uint256 j = input;
542         uint256 length;
543         while (j != 0) {
544             length++;
545             j /= 10;
546         }
547 
548         // allocate the string
549         bytes memory bstr = new bytes(length);
550 
551         // populate the string starting with the least-significant character
552         j = input;
553         for (uint256 i = length; i > 0; ) {
554             // reverse-for-loops with unsigned integer
555             /* solium-disable-next-line security/no-modify-for-iter-var */
556             i--;
557 
558             // take last decimal digit
559             bstr[i] = byte(uint8(ASCII_ZERO + (j % 10)));
560 
561             // remove the last decimal digit
562             j /= 10;
563         }
564 
565         return bstr;
566     }
567 
568     function stringify(
569         address input
570     )
571     private
572     pure
573     returns (bytes memory)
574     {
575         uint256 z = uint256(input);
576 
577         // addresses are "0x" followed by 20 bytes of data which take up 2 characters each
578         bytes memory result = new bytes(42);
579 
580         // populate the result with "0x"
581         result[0] = byte(uint8(ASCII_ZERO));
582         result[1] = byte(uint8(ASCII_LOWER_EX));
583 
584         // for each byte (starting from the lowest byte), populate the result with two characters
585         for (uint256 i = 0; i < 20; i++) {
586             // each byte takes two characters
587             uint256 shift = i * 2;
588 
589             // populate the least-significant character
590             result[41 - shift] = char(z & FOUR_BIT_MASK);
591             z = z >> 4;
592 
593             // populate the most-significant character
594             result[40 - shift] = char(z & FOUR_BIT_MASK);
595             z = z >> 4;
596         }
597 
598         return result;
599     }
600 
601     function stringify(
602         bytes32 input
603     )
604     private
605     pure
606     returns (bytes memory)
607     {
608         uint256 z = uint256(input);
609 
610         // bytes32 are "0x" followed by 32 bytes of data which take up 2 characters each
611         bytes memory result = new bytes(66);
612 
613         // populate the result with "0x"
614         result[0] = byte(uint8(ASCII_ZERO));
615         result[1] = byte(uint8(ASCII_LOWER_EX));
616 
617         // for each byte (starting from the lowest byte), populate the result with two characters
618         for (uint256 i = 0; i < 32; i++) {
619             // each byte takes two characters
620             uint256 shift = i * 2;
621 
622             // populate the least-significant character
623             result[65 - shift] = char(z & FOUR_BIT_MASK);
624             z = z >> 4;
625 
626             // populate the most-significant character
627             result[64 - shift] = char(z & FOUR_BIT_MASK);
628             z = z >> 4;
629         }
630 
631         return result;
632     }
633 
634     function char(
635         uint256 input
636     )
637     private
638     pure
639     returns (byte)
640     {
641         // return ASCII digit (0-9)
642         if (input < 10) {
643             return byte(uint8(input + ASCII_ZERO));
644         }
645 
646         // return ASCII letter (a-f)
647         return byte(uint8(input + ASCII_RELATIVE_ZERO));
648     }
649 }
650 
651 // File: contracts/external/Decimal.sol
652 
653 /*
654     Copyright 2019 dYdX Trading Inc.
655     Copyright 2020 True Seigniorage Dollar Devs, based on the works of the Empty Set Squad and Dynamic Dollar Devs
656 
657     Licensed under the Apache License, Version 2.0 (the "License");
658     you may not use this file except in compliance with the License.
659     You may obtain a copy of the License at
660 
661     http://www.apache.org/licenses/LICENSE-2.0
662 
663     Unless required by applicable law or agreed to in writing, software
664     distributed under the License is distributed on an "AS IS" BASIS,
665     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
666     See the License for the specific language governing permissions and
667     limitations under the License.
668 */
669 
670 pragma solidity ^0.5.7;
671 pragma experimental ABIEncoderV2;
672 
673 
674 /**
675  * @title Decimal
676  * @author dYdX
677  *
678  * Library that defines a fixed-point number with 18 decimal places.
679  */
680 library Decimal {
681     using SafeMath for uint256;
682 
683     // ============ Constants ============
684 
685     uint256 constant BASE = 10**18;
686 
687     // ============ Structs ============
688 
689 
690     struct D256 {
691         uint256 value;
692     }
693 
694     // ============ Static Functions ============
695 
696     function zero()
697     internal
698     pure
699     returns (D256 memory)
700     {
701         return D256({ value: 0 });
702     }
703 
704     function one()
705     internal
706     pure
707     returns (D256 memory)
708     {
709         return D256({ value: BASE });
710     }
711 
712     function from(
713         uint256 a
714     )
715     internal
716     pure
717     returns (D256 memory)
718     {
719         return D256({ value: a.mul(BASE) });
720     }
721 
722     function ratio(
723         uint256 a,
724         uint256 b
725     )
726     internal
727     pure
728     returns (D256 memory)
729     {
730         return D256({ value: getPartial(a, BASE, b) });
731     }
732 
733     // ============ Self Functions ============
734 
735     function add(
736         D256 memory self,
737         uint256 b
738     )
739     internal
740     pure
741     returns (D256 memory)
742     {
743         return D256({ value: self.value.add(b.mul(BASE)) });
744     }
745 
746     function sub(
747         D256 memory self,
748         uint256 b
749     )
750     internal
751     pure
752     returns (D256 memory)
753     {
754         return D256({ value: self.value.sub(b.mul(BASE)) });
755     }
756 
757     function sub(
758         D256 memory self,
759         uint256 b,
760         string memory reason
761     )
762     internal
763     pure
764     returns (D256 memory)
765     {
766         return D256({ value: self.value.sub(b.mul(BASE), reason) });
767     }
768 
769     function mul(
770         D256 memory self,
771         uint256 b
772     )
773     internal
774     pure
775     returns (D256 memory)
776     {
777         return D256({ value: self.value.mul(b) });
778     }
779 
780     function div(
781         D256 memory self,
782         uint256 b
783     )
784     internal
785     pure
786     returns (D256 memory)
787     {
788         return D256({ value: self.value.div(b) });
789     }
790 
791     function pow(
792         D256 memory self,
793         uint256 b
794     )
795     internal
796     pure
797     returns (D256 memory)
798     {
799         if (b == 0) {
800             return from(1);
801         }
802 
803         D256 memory temp = D256({ value: self.value });
804         for (uint256 i = 1; i < b; i++) {
805             temp = mul(temp, self);
806         }
807 
808         return temp;
809     }
810 
811     function add(
812         D256 memory self,
813         D256 memory b
814     )
815     internal
816     pure
817     returns (D256 memory)
818     {
819         return D256({ value: self.value.add(b.value) });
820     }
821 
822     function sub(
823         D256 memory self,
824         D256 memory b
825     )
826     internal
827     pure
828     returns (D256 memory)
829     {
830         return D256({ value: self.value.sub(b.value) });
831     }
832 
833     function sub(
834         D256 memory self,
835         D256 memory b,
836         string memory reason
837     )
838     internal
839     pure
840     returns (D256 memory)
841     {
842         return D256({ value: self.value.sub(b.value, reason) });
843     }
844 
845     function mul(
846         D256 memory self,
847         D256 memory b
848     )
849     internal
850     pure
851     returns (D256 memory)
852     {
853         return D256({ value: getPartial(self.value, b.value, BASE) });
854     }
855 
856     function div(
857         D256 memory self,
858         D256 memory b
859     )
860     internal
861     pure
862     returns (D256 memory)
863     {
864         return D256({ value: getPartial(self.value, BASE, b.value) });
865     }
866 
867     function equals(D256 memory self, D256 memory b) internal pure returns (bool) {
868         return self.value == b.value;
869     }
870 
871     function greaterThan(D256 memory self, D256 memory b) internal pure returns (bool) {
872         return compareTo(self, b) == 2;
873     }
874 
875     function lessThan(D256 memory self, D256 memory b) internal pure returns (bool) {
876         return compareTo(self, b) == 0;
877     }
878 
879     function greaterThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
880         return compareTo(self, b) > 0;
881     }
882 
883     function lessThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
884         return compareTo(self, b) < 2;
885     }
886 
887     function isZero(D256 memory self) internal pure returns (bool) {
888         return self.value == 0;
889     }
890 
891     function asUint256(D256 memory self) internal pure returns (uint256) {
892         return self.value.div(BASE);
893     }
894 
895     // ============ Core Methods ============
896 
897     function getPartial(
898         uint256 target,
899         uint256 numerator,
900         uint256 denominator
901     )
902     private
903     pure
904     returns (uint256)
905     {
906         return target.mul(numerator).div(denominator);
907     }
908 
909     function compareTo(
910         D256 memory a,
911         D256 memory b
912     )
913     private
914     pure
915     returns (uint256)
916     {
917         if (a.value == b.value) {
918             return 1;
919         }
920         return a.value > b.value ? 2 : 0;
921     }
922 }
923 
924 // File: contracts/Constants.sol
925 
926 
927 library Constants {
928     /* Chain */
929     uint256 private constant CHAIN_ID = 1; // Mainnet
930 
931     /* Bootstrapping */
932     uint256 private constant BOOTSTRAPPING_PERIOD = 240; // 240 epochs
933     uint256 private constant BOOTSTRAPPING_PRICE = 144e16; // 1.44 USDC
934 
935     /* Oracle */
936     address private constant USDC = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
937     uint256 private constant ORACLE_RESERVE_MINIMUM = 1e10; // 10,000 USDC
938 
939     /* Bonding */
940     uint256 private constant INITIAL_STAKE_MULTIPLE = 1e6; // 100 TSD -> 100M TSDS
941 
942     /* Epoch */
943     struct EpochStrategy {
944         uint256 offset;
945         uint256 start;
946         uint256 period;
947     }
948 
949     uint256 private constant EPOCH_OFFSET = 0;
950     uint256 private constant EPOCH_START = 1609473600;
951     uint256 private constant EPOCH_PERIOD = 3600;
952 
953     /* Governance */
954     uint256 private constant GOVERNANCE_PERIOD = 36;
955     uint256 private constant GOVERNANCE_QUORUM = 33e16; // 33%
956     uint256 private constant GOVERNANCE_SUPER_MAJORITY = 66e16; // 66%
957     uint256 private constant GOVERNANCE_EMERGENCY_DELAY = 6; // 6 epochs
958 
959     /* DAO */
960     uint256 private constant ADVANCE_INCENTIVE = 25e18; // 25 TSD
961     uint256 private constant DAO_EXIT_LOCKUP_EPOCHS = 72; // 72 epochs fluid
962 
963     /* Pool */
964     uint256 private constant POOL_EXIT_LOCKUP_EPOCHS = 24; // 24 epochs fluid
965 
966     /* Market */
967     uint256 private constant COUPON_EXPIRATION = 720;
968     uint256 private constant DEBT_RATIO_CAP = 35e16; // 35%
969     uint256 private constant INITIAL_COUPON_REDEMPTION_PENALTY = 50e16; // 50%
970     uint256 private constant COUPON_REDEMPTION_PENALTY_DECAY = 3600; // 1 hour
971 
972     /* Regulator */
973     uint256 private constant SUPPLY_CHANGE_DIVISOR = 10e18; // 10
974     uint256 private constant SUPPLY_CHANGE_LIMIT = 4e16; // 4%
975     uint256 private constant ORACLE_POOL_RATIO = 40; // 40%
976 
977     /**
978      * Getters
979      */
980     function getUsdcAddress() internal pure returns (address) {
981         return USDC;
982     }
983 
984     function getOracleReserveMinimum() internal pure returns (uint256) {
985         return ORACLE_RESERVE_MINIMUM;
986     }
987 
988     function getEpochStrategy() internal pure returns (EpochStrategy memory) {
989         return EpochStrategy({
990             offset: EPOCH_OFFSET,
991             start: EPOCH_START,
992             period: EPOCH_PERIOD
993         });
994     }
995 
996     function getInitialStakeMultiple() internal pure returns (uint256) {
997         return INITIAL_STAKE_MULTIPLE;
998     }
999 
1000     function getBootstrappingPeriod() internal pure returns (uint256) {
1001         return BOOTSTRAPPING_PERIOD;
1002     }
1003 
1004     function getBootstrappingPrice() internal pure returns (Decimal.D256 memory) {
1005         return Decimal.D256({value: BOOTSTRAPPING_PRICE});
1006     }
1007 
1008     function getGovernancePeriod() internal pure returns (uint256) {
1009         return GOVERNANCE_PERIOD;
1010     }
1011 
1012     function getGovernanceQuorum() internal pure returns (Decimal.D256 memory) {
1013         return Decimal.D256({value: GOVERNANCE_QUORUM});
1014     }
1015 
1016     function getGovernanceSuperMajority() internal pure returns (Decimal.D256 memory) {
1017         return Decimal.D256({value: GOVERNANCE_SUPER_MAJORITY});
1018     }
1019 
1020     function getGovernanceEmergencyDelay() internal pure returns (uint256) {
1021         return GOVERNANCE_EMERGENCY_DELAY;
1022     }
1023 
1024     function getAdvanceIncentive() internal pure returns (uint256) {
1025         return ADVANCE_INCENTIVE;
1026     }
1027 
1028     function getDAOExitLockupEpochs() internal pure returns (uint256) {
1029         return DAO_EXIT_LOCKUP_EPOCHS;
1030     }
1031 
1032     function getPoolExitLockupEpochs() internal pure returns (uint256) {
1033         return POOL_EXIT_LOCKUP_EPOCHS;
1034     }
1035 
1036     function getCouponExpiration() internal pure returns (uint256) {
1037         return COUPON_EXPIRATION;
1038     }
1039 
1040     function getDebtRatioCap() internal pure returns (Decimal.D256 memory) {
1041         return Decimal.D256({value: DEBT_RATIO_CAP});
1042     }
1043     
1044     function getInitialCouponRedemptionPenalty() internal pure returns (Decimal.D256 memory) {
1045         return Decimal.D256({value: INITIAL_COUPON_REDEMPTION_PENALTY});
1046     }
1047 
1048     function getCouponRedemptionPenaltyDecay() internal pure returns (uint256) {
1049         return COUPON_REDEMPTION_PENALTY_DECAY;
1050     }
1051 
1052     function getSupplyChangeLimit() internal pure returns (Decimal.D256 memory) {
1053         return Decimal.D256({value: SUPPLY_CHANGE_LIMIT});
1054     }
1055 
1056     function getSupplyChangeDivisor() internal pure returns (Decimal.D256 memory) {
1057         return Decimal.D256({value: SUPPLY_CHANGE_DIVISOR});
1058     }
1059 
1060     function getOraclePoolRatio() internal pure returns (uint256) {
1061         return ORACLE_POOL_RATIO;
1062     }
1063 
1064     function getChainId() internal pure returns (uint256) {
1065         return CHAIN_ID;
1066     }
1067 }
1068 
1069 // File: contracts/token/IDollar.sol
1070 
1071 
1072 contract IDollar is IERC20 {
1073     function burn(uint256 amount) public;
1074     function burnFrom(address account, uint256 amount) public;
1075     function mint(address account, uint256 amount) public returns (bool);
1076 }
1077 
1078 // File: contracts/oracle/IDAO.sol
1079 
1080 /*
1081     Copyright 2020 True Seigniorage Dollar Devs, based on the works of the Empty Set Squad and Dynamic Dollar Devs
1082 
1083     Licensed under the Apache License, Version 2.0 (the "License");
1084     you may not use this file except in compliance with the License.
1085     You may obtain a copy of the License at
1086 
1087     http://www.apache.org/licenses/LICENSE-2.0
1088 
1089     Unless required by applicable law or agreed to in writing, software
1090     distributed under the License is distributed on an "AS IS" BASIS,
1091     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1092     See the License for the specific language governing permissions and
1093     limitations under the License.
1094 */
1095 
1096 pragma solidity ^0.5.17;
1097 
1098 contract IDAO {
1099     function epoch() external view returns (uint256);
1100 }
1101 
1102 // File: contracts/oracle/IUSDC.sol
1103 
1104 /*
1105     Copyright 2020 True Seigniorage Dollar Devs, based on the works of the Empty Set Squad and Dynamic Dollar Devs
1106 
1107     Licensed under the Apache License, Version 2.0 (the "License");
1108     you may not use this file except in compliance with the License.
1109     You may obtain a copy of the License at
1110 
1111     http://www.apache.org/licenses/LICENSE-2.0
1112 
1113     Unless required by applicable law or agreed to in writing, software
1114     distributed under the License is distributed on an "AS IS" BASIS,
1115     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1116     See the License for the specific language governing permissions and
1117     limitations under the License.
1118 */
1119 
1120 pragma solidity ^0.5.17;
1121 
1122 contract IUSDC {
1123     function isBlacklisted(address _account) external view returns (bool);
1124 }
1125 
1126 // File: contracts/oracle/PoolState.sol
1127 
1128 
1129 
1130 
1131 
1132 contract PoolAccount {
1133     enum Status {
1134         Frozen,
1135         Fluid,
1136         Locked
1137     }
1138 
1139     struct State {
1140         uint256 staged;
1141         uint256 claimable;
1142         uint256 bonded;
1143         uint256 phantom;
1144         uint256 fluidUntil;
1145     }
1146 }
1147 
1148 contract PoolStorage {
1149     struct Provider {
1150         IDAO dao;
1151         IDollar dollar;
1152         IERC20 univ2;
1153     }
1154     
1155     struct Balance {
1156         uint256 staged;
1157         uint256 claimable;
1158         uint256 bonded;
1159         uint256 phantom;
1160     }
1161 
1162     struct State {
1163         Balance balance;
1164         Provider provider;
1165 
1166         bool paused;
1167 
1168         mapping(address => PoolAccount.State) accounts;
1169     }
1170 }
1171 
1172 contract PoolState {
1173     PoolStorage.State _state;
1174 }
1175 
1176 // File: contracts/oracle/PoolGetters.sol
1177 
1178 
1179 
1180 contract PoolGetters is PoolState {
1181     using SafeMath for uint256;
1182 
1183     /**
1184      * Global
1185      */
1186 
1187     function usdc() public view returns (address) {
1188         return Constants.getUsdcAddress();
1189     }
1190 
1191     function dao() public view returns (IDAO) {
1192         return _state.provider.dao;
1193     }
1194 
1195     function dollar() public view returns (IDollar) {
1196         return _state.provider.dollar;
1197     }
1198 
1199     function univ2() public view returns (IERC20) {
1200         return _state.provider.univ2;
1201     }
1202 
1203     function totalBonded() public view returns (uint256) {
1204         return _state.balance.bonded;
1205     }
1206 
1207     function totalStaged() public view returns (uint256) {
1208         return _state.balance.staged;
1209     }
1210 
1211     function totalClaimable() public view returns (uint256) {
1212         return _state.balance.claimable;
1213     }
1214 
1215     function totalPhantom() public view returns (uint256) {
1216         return _state.balance.phantom;
1217     }
1218 
1219     function totalRewarded() public view returns (uint256) {
1220         return dollar().balanceOf(address(this)).sub(totalClaimable());
1221     }
1222 
1223     function paused() public view returns (bool) {
1224         return _state.paused;
1225     }
1226 
1227     /**
1228      * Account
1229      */
1230 
1231     function balanceOfStaged(address account) public view returns (uint256) {
1232         return _state.accounts[account].staged;
1233     }
1234 
1235     function balanceOfClaimable(address account) public view returns (uint256) {
1236         return _state.accounts[account].claimable;
1237     }
1238 
1239     function balanceOfBonded(address account) public view returns (uint256) {
1240         return _state.accounts[account].bonded;
1241     }
1242 
1243     function balanceOfPhantom(address account) public view returns (uint256) {
1244         return _state.accounts[account].phantom;
1245     }
1246 
1247     function balanceOfRewarded(address account) public view returns (uint256) {
1248         uint256 totalBonded = totalBonded();
1249         if (totalBonded == 0) {
1250             return 0;
1251         }
1252 
1253         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom());
1254         uint256 balanceOfRewardedWithPhantom = totalRewardedWithPhantom
1255             .mul(balanceOfBonded(account))
1256             .div(totalBonded);
1257 
1258         uint256 balanceOfPhantom = balanceOfPhantom(account);
1259         if (balanceOfRewardedWithPhantom > balanceOfPhantom) {
1260             return balanceOfRewardedWithPhantom.sub(balanceOfPhantom);
1261         }
1262         return 0;
1263     }
1264 
1265     function statusOf(address account) public view returns (PoolAccount.Status) {
1266         return epoch() >= _state.accounts[account].fluidUntil ?
1267             PoolAccount.Status.Frozen :
1268             PoolAccount.Status.Fluid;
1269     }
1270 
1271     /**
1272      * Epoch
1273      */
1274 
1275     function epoch() internal view returns (uint256) {
1276         return dao().epoch();
1277     }
1278 }
1279 
1280 // File: contracts/oracle/PoolSetters.sol
1281 
1282 
1283 
1284 
1285 contract PoolSetters is PoolState, PoolGetters {
1286     using SafeMath for uint256;
1287 
1288     /**
1289      * Global
1290      */
1291 
1292     function pause() internal {
1293         _state.paused = true;
1294     }
1295 
1296     /**
1297      * Account
1298      */
1299 
1300     function incrementBalanceOfBonded(address account, uint256 amount) internal {
1301         _state.accounts[account].bonded = _state.accounts[account].bonded.add(amount);
1302         _state.balance.bonded = _state.balance.bonded.add(amount);
1303     }
1304 
1305     function decrementBalanceOfBonded(address account, uint256 amount, string memory reason) internal {
1306         _state.accounts[account].bonded = _state.accounts[account].bonded.sub(amount, reason);
1307         _state.balance.bonded = _state.balance.bonded.sub(amount, reason);
1308     }
1309 
1310     function incrementBalanceOfStaged(address account, uint256 amount) internal {
1311         _state.accounts[account].staged = _state.accounts[account].staged.add(amount);
1312         _state.balance.staged = _state.balance.staged.add(amount);
1313     }
1314 
1315     function decrementBalanceOfStaged(address account, uint256 amount, string memory reason) internal {
1316         _state.accounts[account].staged = _state.accounts[account].staged.sub(amount, reason);
1317         _state.balance.staged = _state.balance.staged.sub(amount, reason);
1318     }
1319 
1320     function incrementBalanceOfClaimable(address account, uint256 amount) internal {
1321         _state.accounts[account].claimable = _state.accounts[account].claimable.add(amount);
1322         _state.balance.claimable = _state.balance.claimable.add(amount);
1323     }
1324 
1325     function decrementBalanceOfClaimable(address account, uint256 amount, string memory reason) internal {
1326         _state.accounts[account].claimable = _state.accounts[account].claimable.sub(amount, reason);
1327         _state.balance.claimable = _state.balance.claimable.sub(amount, reason);
1328     }
1329 
1330     function incrementBalanceOfPhantom(address account, uint256 amount) internal {
1331         _state.accounts[account].phantom = _state.accounts[account].phantom.add(amount);
1332         _state.balance.phantom = _state.balance.phantom.add(amount);
1333     }
1334 
1335     function decrementBalanceOfPhantom(address account, uint256 amount, string memory reason) internal {
1336         _state.accounts[account].phantom = _state.accounts[account].phantom.sub(amount, reason);
1337         _state.balance.phantom = _state.balance.phantom.sub(amount, reason);
1338     }
1339 
1340     function unfreeze(address account) internal {
1341         _state.accounts[account].fluidUntil = epoch().add(Constants.getPoolExitLockupEpochs());
1342     }
1343 }
1344 
1345 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
1346 
1347 pragma solidity >=0.5.0;
1348 
1349 interface IUniswapV2Pair {
1350     event Approval(address indexed owner, address indexed spender, uint value);
1351     event Transfer(address indexed from, address indexed to, uint value);
1352 
1353     function name() external pure returns (string memory);
1354     function symbol() external pure returns (string memory);
1355     function decimals() external pure returns (uint8);
1356     function totalSupply() external view returns (uint);
1357     function balanceOf(address owner) external view returns (uint);
1358     function allowance(address owner, address spender) external view returns (uint);
1359 
1360     function approve(address spender, uint value) external returns (bool);
1361     function transfer(address to, uint value) external returns (bool);
1362     function transferFrom(address from, address to, uint value) external returns (bool);
1363 
1364     function DOMAIN_SEPARATOR() external view returns (bytes32);
1365     function PERMIT_TYPEHASH() external pure returns (bytes32);
1366     function nonces(address owner) external view returns (uint);
1367 
1368     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1369 
1370     event Mint(address indexed sender, uint amount0, uint amount1);
1371     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1372     event Swap(
1373         address indexed sender,
1374         uint amount0In,
1375         uint amount1In,
1376         uint amount0Out,
1377         uint amount1Out,
1378         address indexed to
1379     );
1380     event Sync(uint112 reserve0, uint112 reserve1);
1381 
1382     function MINIMUM_LIQUIDITY() external pure returns (uint);
1383     function factory() external view returns (address);
1384     function token0() external view returns (address);
1385     function token1() external view returns (address);
1386     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1387     function price0CumulativeLast() external view returns (uint);
1388     function price1CumulativeLast() external view returns (uint);
1389     function kLast() external view returns (uint);
1390 
1391     function mint(address to) external returns (uint liquidity);
1392     function burn(address to) external returns (uint amount0, uint amount1);
1393     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1394     function skim(address to) external;
1395     function sync() external;
1396 
1397     function initialize(address, address) external;
1398 }
1399 
1400 // File: contracts/external/UniswapV2Library.sol
1401 
1402 pragma solidity >=0.5.0;
1403 
1404 
1405 
1406 library UniswapV2Library {
1407     using SafeMath for uint;
1408 
1409     // returns sorted token addresses, used to handle return values from pairs sorted in this order
1410     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
1411         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
1412         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
1413         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
1414     }
1415 
1416     // calculates the CREATE2 address for a pair without making any external calls
1417     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
1418         (address token0, address token1) = sortTokens(tokenA, tokenB);
1419         pair = address(uint(keccak256(abi.encodePacked(
1420                 hex'ff',
1421                 factory,
1422                 keccak256(abi.encodePacked(token0, token1)),
1423                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
1424             ))));
1425     }
1426 
1427     // fetches and sorts the reserves for a pair
1428     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
1429         (address token0,) = sortTokens(tokenA, tokenB);
1430         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
1431         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1432     }
1433 
1434     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
1435     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
1436         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
1437         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
1438         amountB = amountA.mul(reserveB) / reserveA;
1439     }
1440 }
1441 
1442 // File: contracts/oracle/Liquidity.sol
1443 
1444 
1445 
1446 
1447 
1448 contract Liquidity is PoolGetters {
1449     address private constant UNISWAP_FACTORY = address(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
1450 
1451     function addLiquidity(uint256 dollarAmount) internal returns (uint256, uint256) {
1452         (address dollar, address usdc) = (address(dollar()), usdc());
1453         (uint reserveA, uint reserveB) = getReserves(dollar, usdc);
1454 
1455         uint256 usdcAmount = (reserveA == 0 && reserveB == 0) ?
1456              dollarAmount :
1457              UniswapV2Library.quote(dollarAmount, reserveA, reserveB);
1458 
1459         address pair = address(univ2());
1460         IERC20(dollar).transfer(pair, dollarAmount);
1461         IERC20(usdc).transferFrom(msg.sender, pair, usdcAmount);
1462         return (usdcAmount, IUniswapV2Pair(pair).mint(address(this)));
1463     }
1464 
1465     // overridable for testing
1466     function getReserves(address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
1467         (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
1468         (uint reserve0, uint reserve1,) = IUniswapV2Pair(UniswapV2Library.pairFor(UNISWAP_FACTORY, tokenA, tokenB)).getReserves();
1469         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1470     }
1471 }
1472 
1473 // File: contracts/oracle/Pool.sol
1474 
1475 
1476 
1477 
1478 
1479 
1480 
1481 contract Pool is PoolSetters, Liquidity {
1482     using SafeMath for uint256;
1483 
1484     constructor(address dollar, address univ2) public {
1485         _state.provider.dao = IDAO(msg.sender);
1486         _state.provider.dollar = IDollar(dollar);
1487         _state.provider.univ2 = IERC20(univ2);
1488     }
1489 
1490     bytes32 private constant FILE = "Pool";
1491 
1492     event Deposit(address indexed account, uint256 value);
1493     event Withdraw(address indexed account, uint256 value);
1494     event Claim(address indexed account, uint256 value);
1495     event Bond(address indexed account, uint256 start, uint256 value);
1496     event Unbond(address indexed account, uint256 start, uint256 value, uint256 newClaimable);
1497     event Provide(address indexed account, uint256 value, uint256 lessUsdc, uint256 newUniv2);
1498 
1499     function deposit(uint256 value) external onlyFrozen(msg.sender) notPaused {
1500         univ2().transferFrom(msg.sender, address(this), value);
1501         incrementBalanceOfStaged(msg.sender, value);
1502 
1503         balanceCheck();
1504 
1505         emit Deposit(msg.sender, value);
1506     }
1507 
1508     function withdraw(uint256 value) external onlyFrozen(msg.sender) {
1509         univ2().transfer(msg.sender, value);
1510         decrementBalanceOfStaged(msg.sender, value, "Pool: insufficient staged balance");
1511 
1512         balanceCheck();
1513 
1514         emit Withdraw(msg.sender, value);
1515     }
1516 
1517     function claim(uint256 value) external onlyFrozen(msg.sender) {
1518         dollar().transfer(msg.sender, value);
1519         decrementBalanceOfClaimable(msg.sender, value, "Pool: insufficient claimable balance");
1520 
1521         balanceCheck();
1522 
1523         emit Claim(msg.sender, value);
1524     }
1525 
1526     function bond(uint256 value) external notPaused {
1527         unfreeze(msg.sender);
1528 
1529         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom());
1530         uint256 newPhantom = totalBonded() == 0 ?
1531             totalRewarded() == 0 ? Constants.getInitialStakeMultiple().mul(value) : 0 :
1532             totalRewardedWithPhantom.mul(value).div(totalBonded());
1533 
1534         incrementBalanceOfBonded(msg.sender, value);
1535         incrementBalanceOfPhantom(msg.sender, newPhantom);
1536         decrementBalanceOfStaged(msg.sender, value, "Pool: insufficient staged balance");
1537 
1538         balanceCheck();
1539 
1540         emit Bond(msg.sender, epoch().add(1), value);
1541     }
1542 
1543     function unbond(uint256 value) external {
1544         unfreeze(msg.sender);
1545 
1546         uint256 balanceOfBonded = balanceOfBonded(msg.sender);
1547         Require.that(
1548             balanceOfBonded > 0,
1549             FILE,
1550             "insufficient bonded balance"
1551         );
1552 
1553         uint256 newClaimable = balanceOfRewarded(msg.sender).mul(value).div(balanceOfBonded);
1554         uint256 lessPhantom = balanceOfPhantom(msg.sender).mul(value).div(balanceOfBonded);
1555 
1556         incrementBalanceOfStaged(msg.sender, value);
1557         incrementBalanceOfClaimable(msg.sender, newClaimable);
1558         decrementBalanceOfBonded(msg.sender, value, "Pool: insufficient bonded balance");
1559         decrementBalanceOfPhantom(msg.sender, lessPhantom, "Pool: insufficient phantom balance");
1560 
1561         balanceCheck();
1562 
1563         emit Unbond(msg.sender, epoch().add(1), value, newClaimable);
1564     }
1565 
1566     function provide(uint256 value) external onlyFrozen(msg.sender) notPaused {
1567         Require.that(
1568             totalBonded() > 0,
1569             FILE,
1570             "insufficient total bonded"
1571         );
1572 
1573         Require.that(
1574             totalRewarded() > 0,
1575             FILE,
1576             "insufficient total rewarded"
1577         );
1578 
1579         Require.that(
1580             balanceOfRewarded(msg.sender) >= value,
1581             FILE,
1582             "insufficient rewarded balance"
1583         );
1584 
1585         (uint256 lessUsdc, uint256 newUniv2) = addLiquidity(value);
1586 
1587         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom()).add(value);
1588         uint256 newPhantomFromBonded = totalRewardedWithPhantom.mul(newUniv2).div(totalBonded());
1589 
1590         incrementBalanceOfBonded(msg.sender, newUniv2);
1591         incrementBalanceOfPhantom(msg.sender, value.add(newPhantomFromBonded));
1592 
1593 
1594         balanceCheck();
1595 
1596         emit Provide(msg.sender, value, lessUsdc, newUniv2);
1597     }
1598 
1599     function emergencyWithdraw(address token, uint256 value) external onlyDao {
1600         IERC20(token).transfer(address(dao()), value);
1601     }
1602 
1603     function emergencyPause() external onlyDao {
1604         pause();
1605     }
1606 
1607     function balanceCheck() private {
1608         Require.that(
1609             univ2().balanceOf(address(this)) >= totalStaged().add(totalBonded()),
1610             FILE,
1611             "Inconsistent UNI-V2 balances"
1612         );
1613     }
1614 
1615     modifier onlyFrozen(address account) {
1616         Require.that(
1617             statusOf(account) == PoolAccount.Status.Frozen,
1618             FILE,
1619             "Not frozen"
1620         );
1621 
1622         _;
1623     }
1624 
1625     modifier onlyDao() {
1626         Require.that(
1627             msg.sender == address(dao()),
1628             FILE,
1629             "Not dao"
1630         );
1631 
1632         _;
1633     }
1634 
1635     modifier notPaused() {
1636         Require.that(
1637             !paused(),
1638             FILE,
1639             "Paused"
1640         );
1641 
1642         _;
1643     }
1644 }