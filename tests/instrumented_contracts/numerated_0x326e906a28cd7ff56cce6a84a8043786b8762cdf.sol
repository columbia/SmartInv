1 pragma solidity ^0.5.17;
2 pragma experimental ABIEncoderV2;
3 
4 /**
5  * @dev Wrappers over Solidity's arithmetic operations with added overflow
6  * checks.
7  *
8  * Arithmetic operations in Solidity wrap on overflow. This can easily result
9  * in bugs, because programmers usually assume that an overflow raises an
10  * error, which is the standard behavior in high level programming languages.
11  * `SafeMath` restores this intuition by reverting the transaction when an
12  * operation overflows.
13  *
14  * Using this library instead of the unchecked operations eliminates an entire
15  * class of bugs, so it's recommended to use it always.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, reverting on
20      * overflow.
21      *
22      * Counterpart to Solidity's `+` operator.
23      *
24      * Requirements:
25      * - Addition cannot overflow.
26      */
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30 
31         return c;
32     }
33 
34     /**
35      * @dev Returns the subtraction of two unsigned integers, reverting on
36      * overflow (when the result is negative).
37      *
38      * Counterpart to Solidity's `-` operator.
39      *
40      * Requirements:
41      * - Subtraction cannot overflow.
42      */
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         return sub(a, b, "SafeMath: subtraction overflow");
45     }
46 
47     /**
48      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
49      * overflow (when the result is negative).
50      *
51      * Counterpart to Solidity's `-` operator.
52      *
53      * Requirements:
54      * - Subtraction cannot overflow.
55      *
56      * _Available since v2.4.0._
57      */
58     function sub(
59         uint256 a,
60         uint256 b,
61         string memory errorMessage
62     ) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `*` operator.
74      *
75      * Requirements:
76      * - Multiplication cannot overflow.
77      */
78     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
80         // benefit is lost if 'b' is also tested.
81         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
82         if (a == 0) {
83             return 0;
84         }
85 
86         uint256 c = a * b;
87         require(c / a == b, "SafeMath: multiplication overflow");
88 
89         return c;
90     }
91 
92     /**
93      * @dev Returns the integer division of two unsigned integers. Reverts on
94      * division by zero. The result is rounded towards zero.
95      *
96      * Counterpart to Solidity's `/` operator. Note: this function uses a
97      * `revert` opcode (which leaves remaining gas untouched) while Solidity
98      * uses an invalid opcode to revert (consuming all remaining gas).
99      *
100      * Requirements:
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
109      * division by zero. The result is rounded towards zero.
110      *
111      * Counterpart to Solidity's `/` operator. Note: this function uses a
112      * `revert` opcode (which leaves remaining gas untouched) while Solidity
113      * uses an invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      * - The divisor cannot be zero.
117      *
118      * _Available since v2.4.0._
119      */
120     function div(
121         uint256 a,
122         uint256 b,
123         string memory errorMessage
124     ) internal pure returns (uint256) {
125         // Solidity only automatically asserts when dividing by 0
126         require(b > 0, errorMessage);
127         uint256 c = a / b;
128         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
129 
130         return c;
131     }
132 
133     /**
134      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
135      * Reverts when dividing by zero.
136      *
137      * Counterpart to Solidity's `%` operator. This function uses a `revert`
138      * opcode (which leaves remaining gas untouched) while Solidity uses an
139      * invalid opcode to revert (consuming all remaining gas).
140      *
141      * Requirements:
142      * - The divisor cannot be zero.
143      */
144     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
145         return mod(a, b, "SafeMath: modulo by zero");
146     }
147 
148     /**
149      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
150      * Reverts with custom message when dividing by zero.
151      *
152      * Counterpart to Solidity's `%` operator. This function uses a `revert`
153      * opcode (which leaves remaining gas untouched) while Solidity uses an
154      * invalid opcode to revert (consuming all remaining gas).
155      *
156      * Requirements:
157      * - The divisor cannot be zero.
158      *
159      * _Available since v2.4.0._
160      */
161     function mod(
162         uint256 a,
163         uint256 b,
164         string memory errorMessage
165     ) internal pure returns (uint256) {
166         require(b != 0, errorMessage);
167         return a % b;
168     }
169 }
170 
171 /**
172  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
173  * the optional functions; to access them see {ERC20Detailed}.
174  */
175 interface IERC20 {
176     /**
177      * @dev Returns the amount of tokens in existence.
178      */
179     function totalSupply() external view returns (uint256);
180 
181     /**
182      * @dev Returns the amount of tokens owned by `account`.
183      */
184     function balanceOf(address account) external view returns (uint256);
185 
186     /**
187      * @dev Moves `amount` tokens from the caller's account to `recipient`.
188      *
189      * Returns a boolean value indicating whether the operation succeeded.
190      *
191      * Emits a {Transfer} event.
192      */
193     function transfer(address recipient, uint256 amount)
194         external
195         returns (bool);
196 
197     /**
198      * @dev Returns the remaining number of tokens that `spender` will be
199      * allowed to spend on behalf of `owner` through {transferFrom}. This is
200      * zero by default.
201      *
202      * This value changes when {approve} or {transferFrom} are called.
203      */
204     function allowance(address owner, address spender)
205         external
206         view
207         returns (uint256);
208 
209     /**
210      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
211      *
212      * Returns a boolean value indicating whether the operation succeeded.
213      *
214      * IMPORTANT: Beware that changing an allowance with this method brings the risk
215      * that someone may use both the old and the new allowance by unfortunate
216      * transaction ordering. One possible solution to mitigate this race
217      * condition is to first reduce the spender's allowance to 0 and set the
218      * desired value afterwards:
219      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
220      *
221      * Emits an {Approval} event.
222      */
223     function approve(address spender, uint256 amount) external returns (bool);
224 
225     /**
226      * @dev Moves `amount` tokens from `sender` to `recipient` using the
227      * allowance mechanism. `amount` is then deducted from the caller's
228      * allowance.
229      *
230      * Returns a boolean value indicating whether the operation succeeded.
231      *
232      * Emits a {Transfer} event.
233      */
234     function transferFrom(
235         address sender,
236         address recipient,
237         uint256 amount
238     ) external returns (bool);
239 
240     /**
241      * @dev Emitted when `value` tokens are moved from one account (`from`) to
242      * another (`to`).
243      *
244      * Note that `value` may be zero.
245      */
246     event Transfer(address indexed from, address indexed to, uint256 value);
247 
248     /**
249      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
250      * a call to {approve}. `value` is the new allowance.
251      */
252     event Approval(
253         address indexed owner,
254         address indexed spender,
255         uint256 value
256     );
257 }
258 
259 /*
260     Copyright 2019 dYdX Trading Inc.
261 
262     Licensed under the Apache License, Version 2.0 (the "License");
263     you may not use this file except in compliance with the License.
264     You may obtain a copy of the License at
265 
266     http://www.apache.org/licenses/LICENSE-2.0
267 
268     Unless required by applicable law or agreed to in writing, software
269     distributed under the License is distributed on an "AS IS" BASIS,
270     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
271     See the License for the specific language governing permissions and
272     limitations under the License.
273 */
274 /**
275  * @title Require
276  * @author dYdX
277  *
278  * Stringifies parameters to pretty-print revert messages. Costs more gas than regular require()
279  */
280 library Require {
281     // ============ Constants ============
282 
283     uint256 constant ASCII_ZERO = 48; // '0'
284     uint256 constant ASCII_RELATIVE_ZERO = 87; // 'a' - 10
285     uint256 constant ASCII_LOWER_EX = 120; // 'x'
286     bytes2 constant COLON = 0x3a20; // ': '
287     bytes2 constant COMMA = 0x2c20; // ', '
288     bytes2 constant LPAREN = 0x203c; // ' <'
289     bytes1 constant RPAREN = 0x3e; // '>'
290     uint256 constant FOUR_BIT_MASK = 0xf;
291 
292     // ============ Library Functions ============
293 
294     function that(
295         bool must,
296         bytes32 file,
297         bytes32 reason
298     ) internal pure {
299         if (!must) {
300             revert(
301                 string(
302                     abi.encodePacked(
303                         stringifyTruncated(file),
304                         COLON,
305                         stringifyTruncated(reason)
306                     )
307                 )
308             );
309         }
310     }
311 
312     function that(
313         bool must,
314         bytes32 file,
315         bytes32 reason,
316         uint256 payloadA
317     ) internal pure {
318         if (!must) {
319             revert(
320                 string(
321                     abi.encodePacked(
322                         stringifyTruncated(file),
323                         COLON,
324                         stringifyTruncated(reason),
325                         LPAREN,
326                         stringify(payloadA),
327                         RPAREN
328                     )
329                 )
330             );
331         }
332     }
333 
334     function that(
335         bool must,
336         bytes32 file,
337         bytes32 reason,
338         uint256 payloadA,
339         uint256 payloadB
340     ) internal pure {
341         if (!must) {
342             revert(
343                 string(
344                     abi.encodePacked(
345                         stringifyTruncated(file),
346                         COLON,
347                         stringifyTruncated(reason),
348                         LPAREN,
349                         stringify(payloadA),
350                         COMMA,
351                         stringify(payloadB),
352                         RPAREN
353                     )
354                 )
355             );
356         }
357     }
358 
359     function that(
360         bool must,
361         bytes32 file,
362         bytes32 reason,
363         address payloadA
364     ) internal pure {
365         if (!must) {
366             revert(
367                 string(
368                     abi.encodePacked(
369                         stringifyTruncated(file),
370                         COLON,
371                         stringifyTruncated(reason),
372                         LPAREN,
373                         stringify(payloadA),
374                         RPAREN
375                     )
376                 )
377             );
378         }
379     }
380 
381     function that(
382         bool must,
383         bytes32 file,
384         bytes32 reason,
385         address payloadA,
386         uint256 payloadB
387     ) internal pure {
388         if (!must) {
389             revert(
390                 string(
391                     abi.encodePacked(
392                         stringifyTruncated(file),
393                         COLON,
394                         stringifyTruncated(reason),
395                         LPAREN,
396                         stringify(payloadA),
397                         COMMA,
398                         stringify(payloadB),
399                         RPAREN
400                     )
401                 )
402             );
403         }
404     }
405 
406     function that(
407         bool must,
408         bytes32 file,
409         bytes32 reason,
410         address payloadA,
411         uint256 payloadB,
412         uint256 payloadC
413     ) internal pure {
414         if (!must) {
415             revert(
416                 string(
417                     abi.encodePacked(
418                         stringifyTruncated(file),
419                         COLON,
420                         stringifyTruncated(reason),
421                         LPAREN,
422                         stringify(payloadA),
423                         COMMA,
424                         stringify(payloadB),
425                         COMMA,
426                         stringify(payloadC),
427                         RPAREN
428                     )
429                 )
430             );
431         }
432     }
433 
434     function that(
435         bool must,
436         bytes32 file,
437         bytes32 reason,
438         bytes32 payloadA
439     ) internal pure {
440         if (!must) {
441             revert(
442                 string(
443                     abi.encodePacked(
444                         stringifyTruncated(file),
445                         COLON,
446                         stringifyTruncated(reason),
447                         LPAREN,
448                         stringify(payloadA),
449                         RPAREN
450                     )
451                 )
452             );
453         }
454     }
455 
456     function that(
457         bool must,
458         bytes32 file,
459         bytes32 reason,
460         bytes32 payloadA,
461         uint256 payloadB,
462         uint256 payloadC
463     ) internal pure {
464         if (!must) {
465             revert(
466                 string(
467                     abi.encodePacked(
468                         stringifyTruncated(file),
469                         COLON,
470                         stringifyTruncated(reason),
471                         LPAREN,
472                         stringify(payloadA),
473                         COMMA,
474                         stringify(payloadB),
475                         COMMA,
476                         stringify(payloadC),
477                         RPAREN
478                     )
479                 )
480             );
481         }
482     }
483 
484     // ============ Private Functions ============
485 
486     function stringifyTruncated(bytes32 input)
487         private
488         pure
489         returns (bytes memory)
490     {
491         // put the input bytes into the result
492         bytes memory result = abi.encodePacked(input);
493 
494         // determine the length of the input by finding the location of the last non-zero byte
495         for (uint256 i = 32; i > 0; ) {
496             // reverse-for-loops with unsigned integer
497             /* solium-disable-next-line security/no-modify-for-iter-var */
498             i--;
499 
500             // find the last non-zero byte in order to determine the length
501             if (result[i] != 0) {
502                 uint256 length = i + 1;
503 
504                 /* solium-disable-next-line security/no-inline-assembly */
505                 assembly {
506                     mstore(result, length) // r.length = length;
507                 }
508 
509                 return result;
510             }
511         }
512 
513         // all bytes are zero
514         return new bytes(0);
515     }
516 
517     function stringify(uint256 input) private pure returns (bytes memory) {
518         if (input == 0) {
519             return "0";
520         }
521 
522         // get the final string length
523         uint256 j = input;
524         uint256 length;
525         while (j != 0) {
526             length++;
527             j /= 10;
528         }
529 
530         // allocate the string
531         bytes memory bstr = new bytes(length);
532 
533         // populate the string starting with the least-significant character
534         j = input;
535         for (uint256 i = length; i > 0; ) {
536             // reverse-for-loops with unsigned integer
537             /* solium-disable-next-line security/no-modify-for-iter-var */
538             i--;
539 
540             // take last decimal digit
541             bstr[i] = bytes1(uint8(ASCII_ZERO + (j % 10)));
542 
543             // remove the last decimal digit
544             j /= 10;
545         }
546 
547         return bstr;
548     }
549 
550     function stringify(address input) private pure returns (bytes memory) {
551         uint256 z = uint256(input);
552 
553         // addresses are "0x" followed by 20 bytes of data which take up 2 characters each
554         bytes memory result = new bytes(42);
555 
556         // populate the result with "0x"
557         result[0] = bytes1(uint8(ASCII_ZERO));
558         result[1] = bytes1(uint8(ASCII_LOWER_EX));
559 
560         // for each byte (starting from the lowest byte), populate the result with two characters
561         for (uint256 i = 0; i < 20; i++) {
562             // each byte takes two characters
563             uint256 shift = i * 2;
564 
565             // populate the least-significant character
566             result[41 - shift] = char(z & FOUR_BIT_MASK);
567             z = z >> 4;
568 
569             // populate the most-significant character
570             result[40 - shift] = char(z & FOUR_BIT_MASK);
571             z = z >> 4;
572         }
573 
574         return result;
575     }
576 
577     function stringify(bytes32 input) private pure returns (bytes memory) {
578         uint256 z = uint256(input);
579 
580         // bytes32 are "0x" followed by 32 bytes of data which take up 2 characters each
581         bytes memory result = new bytes(66);
582 
583         // populate the result with "0x"
584         result[0] = bytes1(uint8(ASCII_ZERO));
585         result[1] = bytes1(uint8(ASCII_LOWER_EX));
586 
587         // for each byte (starting from the lowest byte), populate the result with two characters
588         for (uint256 i = 0; i < 32; i++) {
589             // each byte takes two characters
590             uint256 shift = i * 2;
591 
592             // populate the least-significant character
593             result[65 - shift] = char(z & FOUR_BIT_MASK);
594             z = z >> 4;
595 
596             // populate the most-significant character
597             result[64 - shift] = char(z & FOUR_BIT_MASK);
598             z = z >> 4;
599         }
600 
601         return result;
602     }
603 
604     function char(uint256 input) private pure returns (bytes1) {
605         // return ASCII digit (0-9)
606         if (input < 10) {
607             return bytes1(uint8(input + ASCII_ZERO));
608         }
609 
610         // return ASCII letter (a-f)
611         return bytes1(uint8(input + ASCII_RELATIVE_ZERO));
612     }
613 }
614 
615 /*
616     Copyright 2019 dYdX Trading Inc.
617     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
618 
619     Licensed under the Apache License, Version 2.0 (the "License");
620     you may not use this file except in compliance with the License.
621     You may obtain a copy of the License at
622 
623     http://www.apache.org/licenses/LICENSE-2.0
624 
625     Unless required by applicable law or agreed to in writing, software
626     distributed under the License is distributed on an "AS IS" BASIS,
627     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
628     See the License for the specific language governing permissions and
629     limitations under the License.
630 */
631 /**
632  * @title Decimal
633  * @author dYdX
634  *
635  * Library that defines a fixed-point number with 18 decimal places.
636  */
637 library Decimal {
638     using SafeMath for uint256;
639 
640     // ============ Constants ============
641 
642     uint256 constant BASE = 10**18;
643 
644     // ============ Structs ============
645 
646     struct D256 {
647         uint256 value;
648     }
649 
650     // ============ Static Functions ============
651 
652     function zero() internal pure returns (D256 memory) {
653         return D256({value: 0});
654     }
655 
656     function one() internal pure returns (D256 memory) {
657         return D256({value: BASE});
658     }
659 
660     function from(uint256 a) internal pure returns (D256 memory) {
661         return D256({value: a.mul(BASE)});
662     }
663 
664     function ratio(uint256 a, uint256 b) internal pure returns (D256 memory) {
665         return D256({value: getPartial(a, BASE, b)});
666     }
667 
668     // ============ Self Functions ============
669 
670     function add(D256 memory self, uint256 b)
671         internal
672         pure
673         returns (D256 memory)
674     {
675         return D256({value: self.value.add(b.mul(BASE))});
676     }
677 
678     function sub(D256 memory self, uint256 b)
679         internal
680         pure
681         returns (D256 memory)
682     {
683         return D256({value: self.value.sub(b.mul(BASE))});
684     }
685 
686     function sub(
687         D256 memory self,
688         uint256 b,
689         string memory reason
690     ) internal pure returns (D256 memory) {
691         return D256({value: self.value.sub(b.mul(BASE), reason)});
692     }
693 
694     function mul(D256 memory self, uint256 b)
695         internal
696         pure
697         returns (D256 memory)
698     {
699         return D256({value: self.value.mul(b)});
700     }
701 
702     function div(D256 memory self, uint256 b)
703         internal
704         pure
705         returns (D256 memory)
706     {
707         return D256({value: self.value.div(b)});
708     }
709 
710     function pow(D256 memory self, uint256 b)
711         internal
712         pure
713         returns (D256 memory)
714     {
715         if (b == 0) {
716             return from(1);
717         }
718 
719         D256 memory temp = D256({value: self.value});
720         for (uint256 i = 1; i < b; i++) {
721             temp = mul(temp, self);
722         }
723 
724         return temp;
725     }
726 
727     function add(D256 memory self, D256 memory b)
728         internal
729         pure
730         returns (D256 memory)
731     {
732         return D256({value: self.value.add(b.value)});
733     }
734 
735     function sub(D256 memory self, D256 memory b)
736         internal
737         pure
738         returns (D256 memory)
739     {
740         return D256({value: self.value.sub(b.value)});
741     }
742 
743     function sub(
744         D256 memory self,
745         D256 memory b,
746         string memory reason
747     ) internal pure returns (D256 memory) {
748         return D256({value: self.value.sub(b.value, reason)});
749     }
750 
751     function mul(D256 memory self, D256 memory b)
752         internal
753         pure
754         returns (D256 memory)
755     {
756         return D256({value: getPartial(self.value, b.value, BASE)});
757     }
758 
759     function div(D256 memory self, D256 memory b)
760         internal
761         pure
762         returns (D256 memory)
763     {
764         return D256({value: getPartial(self.value, BASE, b.value)});
765     }
766 
767     function equals(D256 memory self, D256 memory b)
768         internal
769         pure
770         returns (bool)
771     {
772         return self.value == b.value;
773     }
774 
775     function greaterThan(D256 memory self, D256 memory b)
776         internal
777         pure
778         returns (bool)
779     {
780         return compareTo(self, b) == 2;
781     }
782 
783     function lessThan(D256 memory self, D256 memory b)
784         internal
785         pure
786         returns (bool)
787     {
788         return compareTo(self, b) == 0;
789     }
790 
791     function greaterThanOrEqualTo(D256 memory self, D256 memory b)
792         internal
793         pure
794         returns (bool)
795     {
796         return compareTo(self, b) > 0;
797     }
798 
799     function lessThanOrEqualTo(D256 memory self, D256 memory b)
800         internal
801         pure
802         returns (bool)
803     {
804         return compareTo(self, b) < 2;
805     }
806 
807     function isZero(D256 memory self) internal pure returns (bool) {
808         return self.value == 0;
809     }
810 
811     function asUint256(D256 memory self) internal pure returns (uint256) {
812         return self.value.div(BASE);
813     }
814 
815     // ============ Core Methods ============
816 
817     function getPartial(
818         uint256 target,
819         uint256 numerator,
820         uint256 denominator
821     ) private pure returns (uint256) {
822         return target.mul(numerator).div(denominator);
823     }
824 
825     function compareTo(D256 memory a, D256 memory b)
826         private
827         pure
828         returns (uint256)
829     {
830         if (a.value == b.value) {
831             return 1;
832         }
833         return a.value > b.value ? 2 : 0;
834     }
835 }
836 
837 /*
838     Copyright 2020 Zero Collateral Devs, standing on the shoulders of the Empty Set Squad <zaifinance@protonmail.com>
839 
840     Licensed under the Apache License, Version 2.0 (the "License");
841     you may not use this file except in compliance with the License.
842     You may obtain a copy of the License at
843 
844     http://www.apache.org/licenses/LICENSE-2.0
845 
846     Unless required by applicable law or agreed to in writing, software
847     distributed under the License is distributed on an "AS IS" BASIS,
848     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
849     See the License for the specific language governing permissions and
850     limitations under the License.
851 */
852 
853 library Constants {
854     /* Chain */
855     uint256 private constant CHAIN_ID = 1; // Mainnet
856 
857     /* Bootstrapping */
858     uint256 private constant BOOTSTRAPPING_PERIOD = 240; // 5 cycles
859     uint256 private constant BOOTSTRAPPING_PRICE = 11e17; // 1.10 DAI
860 
861     /* Oracle */
862     address private constant DAI_ADDRESS =
863         address(0x6B175474E89094C44Da98b954EedeAC495271d0F);
864     uint256 private constant ORACLE_RESERVE_MINIMUM = 1e22; // 10,000 DAI
865 
866     /* Bonding */
867     uint256 private constant INITIAL_STAKE_MULTIPLE = 1e6; // 100 ZAI -> 100M ZAIS
868 
869     /* Epoch */
870     struct EpochStrategy {
871         uint256 offset;
872         uint256 start;
873         uint256 period;
874     }
875 
876     uint256 private constant CURRENT_EPOCH_OFFSET = 0;
877     uint256 private constant CURRENT_EPOCH_START = 1611014400;
878     uint256 private constant CURRENT_EPOCH_PERIOD = 1800;
879 
880     /* Governance */
881     uint256 private constant GOVERNANCE_PERIOD = 144; // 3 cycles
882     uint256 private constant GOVERNANCE_EXPIRATION = 48;
883     uint256 private constant GOVERNANCE_QUORUM = 20e16; // 20%
884     uint256 private constant GOVERNANCE_PROPOSAL_THRESHOLD = 5e15; // 0.5%
885     uint256 private constant GOVERNANCE_SUPER_MAJORITY = 66e16; // 66%
886     uint256 private constant GOVERNANCE_EMERGENCY_DELAY = 96; // 2 cycles
887 
888     /* DAO */
889     uint256 private constant ADVANCE_INCENTIVE = 1e20; // 100 ZAI
890     uint256 private constant DAO_EXIT_LOCKUP_EPOCHS = 240; // 5 cycles fluid
891 
892     /* Pool */
893     uint256 private constant POOL_EXIT_LOCKUP_EPOCHS = 144; // 3 cycles fluid
894 
895     /* Market */
896     uint256 private constant COUPON_EXPIRATION = 17520; // 365 cycles
897     uint256 private constant DEBT_RATIO_CAP = 20e16; // 20%
898 
899     /* Regulator */
900     uint256 private constant SUPPLY_CHANGE_LIMIT = 1e16; // 1%
901     uint256 private constant COUPON_SUPPLY_CHANGE_LIMIT = 2e16; // 2%
902     uint256 private constant ORACLE_POOL_RATIO = 50; // 50%
903     uint256 private constant TREASURY_RATIO = 0; // 0%
904 
905     /* Deployed */
906     address private constant TREASURY_ADDRESS =
907         address(0x0000000000000000000000000000000000000000);
908 
909     /**
910      * Getters
911      */
912 
913     function getDaiAddress() internal pure returns (address) {
914         return DAI_ADDRESS;
915     }
916 
917     function getOracleReserveMinimum() internal pure returns (uint256) {
918         return ORACLE_RESERVE_MINIMUM;
919     }
920 
921     function getCurrentEpochStrategy()
922         internal
923         pure
924         returns (EpochStrategy memory)
925     {
926         return
927             EpochStrategy({
928                 offset: CURRENT_EPOCH_OFFSET,
929                 start: CURRENT_EPOCH_START,
930                 period: CURRENT_EPOCH_PERIOD
931             });
932     }
933 
934     function getInitialStakeMultiple() internal pure returns (uint256) {
935         return INITIAL_STAKE_MULTIPLE;
936     }
937 
938     function getBootstrappingPeriod() internal pure returns (uint256) {
939         return BOOTSTRAPPING_PERIOD;
940     }
941 
942     function getBootstrappingPrice()
943         internal
944         pure
945         returns (Decimal.D256 memory)
946     {
947         return Decimal.D256({value: BOOTSTRAPPING_PRICE});
948     }
949 
950     function getGovernancePeriod() internal pure returns (uint256) {
951         return GOVERNANCE_PERIOD;
952     }
953 
954     function getGovernanceExpiration() internal pure returns (uint256) {
955         return GOVERNANCE_EXPIRATION;
956     }
957 
958     function getGovernanceQuorum() internal pure returns (Decimal.D256 memory) {
959         return Decimal.D256({value: GOVERNANCE_QUORUM});
960     }
961 
962     function getGovernanceProposalThreshold()
963         internal
964         pure
965         returns (Decimal.D256 memory)
966     {
967         return Decimal.D256({value: GOVERNANCE_PROPOSAL_THRESHOLD});
968     }
969 
970     function getGovernanceSuperMajority()
971         internal
972         pure
973         returns (Decimal.D256 memory)
974     {
975         return Decimal.D256({value: GOVERNANCE_SUPER_MAJORITY});
976     }
977 
978     function getGovernanceEmergencyDelay() internal pure returns (uint256) {
979         return GOVERNANCE_EMERGENCY_DELAY;
980     }
981 
982     function getAdvanceIncentive() internal pure returns (uint256) {
983         return ADVANCE_INCENTIVE;
984     }
985 
986     function getDAOExitLockupEpochs() internal pure returns (uint256) {
987         return DAO_EXIT_LOCKUP_EPOCHS;
988     }
989 
990     function getPoolExitLockupEpochs() internal pure returns (uint256) {
991         return POOL_EXIT_LOCKUP_EPOCHS;
992     }
993 
994     function getCouponExpiration() internal pure returns (uint256) {
995         return COUPON_EXPIRATION;
996     }
997 
998     function getDebtRatioCap() internal pure returns (Decimal.D256 memory) {
999         return Decimal.D256({value: DEBT_RATIO_CAP});
1000     }
1001 
1002     function getSupplyChangeLimit()
1003         internal
1004         pure
1005         returns (Decimal.D256 memory)
1006     {
1007         return Decimal.D256({value: SUPPLY_CHANGE_LIMIT});
1008     }
1009 
1010     function getCouponSupplyChangeLimit()
1011         internal
1012         pure
1013         returns (Decimal.D256 memory)
1014     {
1015         return Decimal.D256({value: COUPON_SUPPLY_CHANGE_LIMIT});
1016     }
1017 
1018     function getOraclePoolRatio() internal pure returns (uint256) {
1019         return ORACLE_POOL_RATIO;
1020     }
1021 
1022     function getTreasuryRatio() internal pure returns (uint256) {
1023         return TREASURY_RATIO;
1024     }
1025 
1026     function getChainId() internal pure returns (uint256) {
1027         return CHAIN_ID;
1028     }
1029 
1030     function getTreasuryAddress() internal pure returns (address) {
1031         return TREASURY_ADDRESS;
1032     }
1033 }
1034 
1035 /*
1036     Copyright 2020 Zero Collateral Devs, standing on the shoulders of the Empty Set Squad <zaifinance@protonmail.com>
1037 
1038     Licensed under the Apache License, Version 2.0 (the "License");
1039     you may not use this file except in compliance with the License.
1040     You may obtain a copy of the License at
1041 
1042     http://www.apache.org/licenses/LICENSE-2.0
1043 
1044     Unless required by applicable law or agreed to in writing, software
1045     distributed under the License is distributed on an "AS IS" BASIS,
1046     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1047     See the License for the specific language governing permissions and
1048     limitations under the License.
1049 */
1050 
1051 contract IDollar is IERC20 {
1052     function burn(uint256 amount) public;
1053 
1054     function burnFrom(address account, uint256 amount) public;
1055 
1056     function mint(address account, uint256 amount) public returns (bool);
1057 }
1058 
1059 /*
1060     Copyright 2020 Zero Collateral Devs, standing on the shoulders of the Empty Set Squad <zaifinance@protonmail.com>
1061 
1062     Licensed under the Apache License, Version 2.0 (the "License");
1063     you may not use this file except in compliance with the License.
1064     You may obtain a copy of the License at
1065 
1066     http://www.apache.org/licenses/LICENSE-2.0
1067 
1068     Unless required by applicable law or agreed to in writing, software
1069     distributed under the License is distributed on an "AS IS" BASIS,
1070     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1071     See the License for the specific language governing permissions and
1072     limitations under the License.
1073 */
1074 
1075 contract IDAO {
1076     function epoch() external view returns (uint256);
1077 }
1078 
1079 /*
1080     Copyright 2020 Zero Collateral Devs, standing on the shoulders of the Empty Set Squad <zaifinance@protonmail.com>
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
1094 
1095 contract PoolAccount {
1096     enum Status {Frozen, Fluid, Locked}
1097 
1098     struct State {
1099         uint256 staged;
1100         uint256 claimable;
1101         uint256 bonded;
1102         uint256 phantom;
1103         uint256 fluidUntil;
1104     }
1105 }
1106 
1107 contract PoolStorage {
1108     struct Provider {
1109         IDAO dao;
1110         IDollar dollar;
1111         IERC20 univ2;
1112     }
1113 
1114     struct Balance {
1115         uint256 staged;
1116         uint256 claimable;
1117         uint256 bonded;
1118         uint256 phantom;
1119     }
1120 
1121     struct State {
1122         Balance balance;
1123         Provider provider;
1124         bool paused;
1125         mapping(address => PoolAccount.State) accounts;
1126     }
1127 }
1128 
1129 contract PoolState {
1130     PoolStorage.State _state;
1131 }
1132 
1133 /*
1134     Copyright 2020 Zero Collateral Devs, standing on the shoulders of the Empty Set Squad <zaifinance@protonmail.com>
1135 
1136     Licensed under the Apache License, Version 2.0 (the "License");
1137     you may not use this file except in compliance with the License.
1138     You may obtain a copy of the License at
1139 
1140     http://www.apache.org/licenses/LICENSE-2.0
1141 
1142     Unless required by applicable law or agreed to in writing, software
1143     distributed under the License is distributed on an "AS IS" BASIS,
1144     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1145     See the License for the specific language governing permissions and
1146     limitations under the License.
1147 */
1148 
1149 contract PoolGetters is PoolState {
1150     using SafeMath for uint256;
1151 
1152     /**
1153      * Global
1154      */
1155 
1156     function dai() public view returns (address) {
1157         return Constants.getDaiAddress();
1158     }
1159 
1160     function dao() public view returns (IDAO) {
1161         return _state.provider.dao;
1162     }
1163 
1164     function dollar() public view returns (IDollar) {
1165         return _state.provider.dollar;
1166     }
1167 
1168     function univ2() public view returns (IERC20) {
1169         return _state.provider.univ2;
1170     }
1171 
1172     function totalBonded() public view returns (uint256) {
1173         return _state.balance.bonded;
1174     }
1175 
1176     function totalStaged() public view returns (uint256) {
1177         return _state.balance.staged;
1178     }
1179 
1180     function totalClaimable() public view returns (uint256) {
1181         return _state.balance.claimable;
1182     }
1183 
1184     function totalPhantom() public view returns (uint256) {
1185         return _state.balance.phantom;
1186     }
1187 
1188     function totalRewarded() public view returns (uint256) {
1189         return dollar().balanceOf(address(this)).sub(totalClaimable());
1190     }
1191 
1192     function paused() public view returns (bool) {
1193         return _state.paused;
1194     }
1195 
1196     /**
1197      * Account
1198      */
1199 
1200     function balanceOfStaged(address account) public view returns (uint256) {
1201         return _state.accounts[account].staged;
1202     }
1203 
1204     function balanceOfClaimable(address account) public view returns (uint256) {
1205         return _state.accounts[account].claimable;
1206     }
1207 
1208     function balanceOfBonded(address account) public view returns (uint256) {
1209         return _state.accounts[account].bonded;
1210     }
1211 
1212     function balanceOfPhantom(address account) public view returns (uint256) {
1213         return _state.accounts[account].phantom;
1214     }
1215 
1216     function balanceOfRewarded(address account) public view returns (uint256) {
1217         uint256 totalBonded = totalBonded();
1218         if (totalBonded == 0) {
1219             return 0;
1220         }
1221 
1222         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom());
1223         uint256 balanceOfRewardedWithPhantom =
1224             totalRewardedWithPhantom.mul(balanceOfBonded(account)).div(
1225                 totalBonded
1226             );
1227 
1228         uint256 balanceOfPhantom = balanceOfPhantom(account);
1229         if (balanceOfRewardedWithPhantom > balanceOfPhantom) {
1230             return balanceOfRewardedWithPhantom.sub(balanceOfPhantom);
1231         }
1232         return 0;
1233     }
1234 
1235     function statusOf(address account)
1236         public
1237         view
1238         returns (PoolAccount.Status)
1239     {
1240         return
1241             epoch() >= _state.accounts[account].fluidUntil
1242                 ? PoolAccount.Status.Frozen
1243                 : PoolAccount.Status.Fluid;
1244     }
1245 
1246     /**
1247      * Epoch
1248      */
1249 
1250     function epoch() internal view returns (uint256) {
1251         return dao().epoch();
1252     }
1253 }
1254 
1255 
1256 /*
1257     Copyright 2020 Zero Collateral Devs, standing on the shoulders of the Empty Set Squad <zaifinance@protonmail.com>
1258 
1259     Licensed under the Apache License, Version 2.0 (the "License");
1260     you may not use this file except in compliance with the License.
1261     You may obtain a copy of the License at
1262 
1263     http://www.apache.org/licenses/LICENSE-2.0
1264 
1265     Unless required by applicable law or agreed to in writing, software
1266     distributed under the License is distributed on an "AS IS" BASIS,
1267     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1268     See the License for the specific language governing permissions and
1269     limitations under the License.
1270 */
1271 
1272 contract PoolSetters is PoolState, PoolGetters {
1273     using SafeMath for uint256;
1274 
1275     /**
1276      * Global
1277      */
1278 
1279     function pause() internal {
1280         _state.paused = true;
1281     }
1282 
1283     /**
1284      * Account
1285      */
1286 
1287     function incrementBalanceOfBonded(address account, uint256 amount)
1288         internal
1289     {
1290         _state.accounts[account].bonded = _state.accounts[account].bonded.add(
1291             amount
1292         );
1293         _state.balance.bonded = _state.balance.bonded.add(amount);
1294     }
1295 
1296     function decrementBalanceOfBonded(
1297         address account,
1298         uint256 amount,
1299         string memory reason
1300     ) internal {
1301         _state.accounts[account].bonded = _state.accounts[account].bonded.sub(
1302             amount,
1303             reason
1304         );
1305         _state.balance.bonded = _state.balance.bonded.sub(amount, reason);
1306     }
1307 
1308     function incrementBalanceOfStaged(address account, uint256 amount)
1309         internal
1310     {
1311         _state.accounts[account].staged = _state.accounts[account].staged.add(
1312             amount
1313         );
1314         _state.balance.staged = _state.balance.staged.add(amount);
1315     }
1316 
1317     function decrementBalanceOfStaged(
1318         address account,
1319         uint256 amount,
1320         string memory reason
1321     ) internal {
1322         _state.accounts[account].staged = _state.accounts[account].staged.sub(
1323             amount,
1324             reason
1325         );
1326         _state.balance.staged = _state.balance.staged.sub(amount, reason);
1327     }
1328 
1329     function incrementBalanceOfClaimable(address account, uint256 amount)
1330         internal
1331     {
1332         _state.accounts[account].claimable = _state.accounts[account]
1333             .claimable
1334             .add(amount);
1335         _state.balance.claimable = _state.balance.claimable.add(amount);
1336     }
1337 
1338     function decrementBalanceOfClaimable(
1339         address account,
1340         uint256 amount,
1341         string memory reason
1342     ) internal {
1343         _state.accounts[account].claimable = _state.accounts[account]
1344             .claimable
1345             .sub(amount, reason);
1346         _state.balance.claimable = _state.balance.claimable.sub(amount, reason);
1347     }
1348 
1349     function incrementBalanceOfPhantom(address account, uint256 amount)
1350         internal
1351     {
1352         _state.accounts[account].phantom = _state.accounts[account].phantom.add(
1353             amount
1354         );
1355         _state.balance.phantom = _state.balance.phantom.add(amount);
1356     }
1357 
1358     function decrementBalanceOfPhantom(
1359         address account,
1360         uint256 amount,
1361         string memory reason
1362     ) internal {
1363         _state.accounts[account].phantom = _state.accounts[account].phantom.sub(
1364             amount,
1365             reason
1366         );
1367         _state.balance.phantom = _state.balance.phantom.sub(amount, reason);
1368     }
1369 
1370     function unfreeze(address account) internal {
1371         _state.accounts[account].fluidUntil = epoch().add(
1372             Constants.getPoolExitLockupEpochs()
1373         );
1374     }
1375 }
1376 
1377 interface IUniswapV2Pair {
1378     event Approval(
1379         address indexed owner,
1380         address indexed spender,
1381         uint256 value
1382     );
1383     event Transfer(address indexed from, address indexed to, uint256 value);
1384 
1385     function name() external pure returns (string memory);
1386 
1387     function symbol() external pure returns (string memory);
1388 
1389     function decimals() external pure returns (uint8);
1390 
1391     function totalSupply() external view returns (uint256);
1392 
1393     function balanceOf(address owner) external view returns (uint256);
1394 
1395     function allowance(address owner, address spender)
1396         external
1397         view
1398         returns (uint256);
1399 
1400     function approve(address spender, uint256 value) external returns (bool);
1401 
1402     function transfer(address to, uint256 value) external returns (bool);
1403 
1404     function transferFrom(
1405         address from,
1406         address to,
1407         uint256 value
1408     ) external returns (bool);
1409 
1410     function DOMAIN_SEPARATOR() external view returns (bytes32);
1411 
1412     function PERMIT_TYPEHASH() external pure returns (bytes32);
1413 
1414     function nonces(address owner) external view returns (uint256);
1415 
1416     function permit(
1417         address owner,
1418         address spender,
1419         uint256 value,
1420         uint256 deadline,
1421         uint8 v,
1422         bytes32 r,
1423         bytes32 s
1424     ) external;
1425 
1426     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
1427     event Burn(
1428         address indexed sender,
1429         uint256 amount0,
1430         uint256 amount1,
1431         address indexed to
1432     );
1433     event Swap(
1434         address indexed sender,
1435         uint256 amount0In,
1436         uint256 amount1In,
1437         uint256 amount0Out,
1438         uint256 amount1Out,
1439         address indexed to
1440     );
1441     event Sync(uint112 reserve0, uint112 reserve1);
1442 
1443     function MINIMUM_LIQUIDITY() external pure returns (uint256);
1444 
1445     function factory() external view returns (address);
1446 
1447     function token0() external view returns (address);
1448 
1449     function token1() external view returns (address);
1450 
1451     function getReserves()
1452         external
1453         view
1454         returns (
1455             uint112 reserve0,
1456             uint112 reserve1,
1457             uint32 blockTimestampLast
1458         );
1459 
1460     function price0CumulativeLast() external view returns (uint256);
1461 
1462     function price1CumulativeLast() external view returns (uint256);
1463 
1464     function kLast() external view returns (uint256);
1465 
1466     function mint(address to) external returns (uint256 liquidity);
1467 
1468     function burn(address to)
1469         external
1470         returns (uint256 amount0, uint256 amount1);
1471 
1472     function swap(
1473         uint256 amount0Out,
1474         uint256 amount1Out,
1475         address to,
1476         bytes calldata data
1477     ) external;
1478 
1479     function skim(address to) external;
1480 
1481     function sync() external;
1482 
1483     function initialize(address, address) external;
1484 }
1485 
1486 library UniswapV2Library {
1487     using SafeMath for uint256;
1488 
1489     // returns sorted token addresses, used to handle return values from pairs sorted in this order
1490     function sortTokens(address tokenA, address tokenB)
1491         internal
1492         pure
1493         returns (address token0, address token1)
1494     {
1495         require(tokenA != tokenB, "UniswapV2Library: IDENTICAL_ADDRESSES");
1496         (token0, token1) = tokenA < tokenB
1497             ? (tokenA, tokenB)
1498             : (tokenB, tokenA);
1499         require(token0 != address(0), "UniswapV2Library: ZERO_ADDRESS");
1500     }
1501 
1502     // calculates the CREATE2 address for a pair without making any external calls
1503     function pairFor(
1504         address factory,
1505         address tokenA,
1506         address tokenB
1507     ) internal pure returns (address pair) {
1508         (address token0, address token1) = sortTokens(tokenA, tokenB);
1509         pair = address(
1510             uint256(
1511                 keccak256(
1512                     abi.encodePacked(
1513                         hex"ff",
1514                         factory,
1515                         keccak256(abi.encodePacked(token0, token1)),
1516                         hex"96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f" // init code hash
1517                     )
1518                 )
1519             )
1520         );
1521     }
1522 
1523     // fetches and sorts the reserves for a pair
1524     function getReserves(
1525         address factory,
1526         address tokenA,
1527         address tokenB
1528     ) internal view returns (uint256 reserveA, uint256 reserveB) {
1529         (address token0, ) = sortTokens(tokenA, tokenB);
1530         (uint256 reserve0, uint256 reserve1, ) =
1531             IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
1532         (reserveA, reserveB) = tokenA == token0
1533             ? (reserve0, reserve1)
1534             : (reserve1, reserve0);
1535     }
1536 
1537     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
1538     function quote(
1539         uint256 amountA,
1540         uint256 reserveA,
1541         uint256 reserveB
1542     ) internal pure returns (uint256 amountB) {
1543         require(amountA > 0, "UniswapV2Library: INSUFFICIENT_AMOUNT");
1544         require(
1545             reserveA > 0 && reserveB > 0,
1546             "UniswapV2Library: INSUFFICIENT_LIQUIDITY"
1547         );
1548         amountB = amountA.mul(reserveB) / reserveA;
1549     }
1550 }
1551 
1552 /*
1553     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
1554 
1555     Licensed under the Apache License, Version 2.0 (the "License");
1556     you may not use this file except in compliance with the License.
1557     You may obtain a copy of the License at
1558 
1559     http://www.apache.org/licenses/LICENSE-2.0
1560 
1561     Unless required by applicable law or agreed to in writing, software
1562     distributed under the License is distributed on an "AS IS" BASIS,
1563     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1564     See the License for the specific language governing permissions and
1565     limitations under the License.
1566 */
1567 contract Liquidity is PoolGetters {
1568     address private constant UNISWAP_FACTORY =
1569         address(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
1570 
1571     function addLiquidity(uint256 dollarAmount)
1572         internal
1573         returns (uint256, uint256)
1574     {
1575         (address dollar, address dai) = (address(dollar()), dai());
1576         (uint256 reserveA, uint256 reserveB) = getReserves(dollar, dai);
1577 
1578         uint256 daiAmount =
1579             (reserveA == 0 && reserveB == 0)
1580                 ? dollarAmount
1581                 : UniswapV2Library.quote(dollarAmount, reserveA, reserveB);
1582 
1583         address pair = address(univ2());
1584         IERC20(dollar).transfer(pair, dollarAmount);
1585         IERC20(dai).transferFrom(msg.sender, pair, daiAmount);
1586         return (daiAmount, IUniswapV2Pair(pair).mint(address(this)));
1587     }
1588 
1589     // overridable for testing
1590     function getReserves(address tokenA, address tokenB)
1591         internal
1592         view
1593         returns (uint256 reserveA, uint256 reserveB)
1594     {
1595         (address token0, ) = UniswapV2Library.sortTokens(tokenA, tokenB);
1596         (uint256 reserve0, uint256 reserve1, ) =
1597             IUniswapV2Pair(
1598                 UniswapV2Library.pairFor(UNISWAP_FACTORY, tokenA, tokenB)
1599             )
1600                 .getReserves();
1601         (reserveA, reserveB) = tokenA == token0
1602             ? (reserve0, reserve1)
1603             : (reserve1, reserve0);
1604     }
1605 }
1606 
1607 /*
1608     Copyright 2020 Zero Collateral Devs, standing on the shoulders of the Empty Set Squad <zaifinance@protonmail.com>
1609 
1610     Licensed under the Apache License, Version 2.0 (the "License");
1611     you may not use this file except in compliance with the License.
1612     You may obtain a copy of the License at
1613 
1614     http://www.apache.org/licenses/LICENSE-2.0
1615 
1616     Unless required by applicable law or agreed to in writing, software
1617     distributed under the License is distributed on an "AS IS" BASIS,
1618     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1619     See the License for the specific language governing permissions and
1620     limitations under the License.
1621 */
1622 
1623 contract Pool is PoolSetters, Liquidity {
1624     using SafeMath for uint256;
1625 
1626     constructor(address dollar, address univ2) public {
1627         _state.provider.dao = IDAO(msg.sender);
1628         _state.provider.dollar = IDollar(dollar);
1629         _state.provider.univ2 = IERC20(univ2);
1630     }
1631 
1632     bytes32 private constant FILE = "Pool";
1633 
1634     event Deposit(address indexed account, uint256 value);
1635     event Withdraw(address indexed account, uint256 value);
1636     event Claim(address indexed account, uint256 value);
1637     event Bond(address indexed account, uint256 start, uint256 value);
1638     event Unbond(
1639         address indexed account,
1640         uint256 start,
1641         uint256 value,
1642         uint256 newClaimable
1643     );
1644     event Provide(
1645         address indexed account,
1646         uint256 value,
1647         uint256 lessUsdc, // don't change this to "lessDai" - there are probably a lot of tools that rely on it for this kind of forked contract
1648         uint256 newUniv2
1649     );
1650 
1651     function deposit(uint256 value) external onlyFrozen(msg.sender) notPaused {
1652         univ2().transferFrom(msg.sender, address(this), value);
1653         incrementBalanceOfStaged(msg.sender, value);
1654 
1655         balanceCheck();
1656 
1657         emit Deposit(msg.sender, value);
1658     }
1659 
1660     function withdraw(uint256 value) external onlyFrozen(msg.sender) {
1661         univ2().transfer(msg.sender, value);
1662         decrementBalanceOfStaged(
1663             msg.sender,
1664             value,
1665             "Pool: insufficient staged balance"
1666         );
1667 
1668         balanceCheck();
1669 
1670         emit Withdraw(msg.sender, value);
1671     }
1672 
1673     function claim(uint256 value) external onlyFrozen(msg.sender) {
1674         dollar().transfer(msg.sender, value);
1675         decrementBalanceOfClaimable(
1676             msg.sender,
1677             value,
1678             "Pool: insufficient claimable balance"
1679         );
1680 
1681         balanceCheck();
1682 
1683         emit Claim(msg.sender, value);
1684     }
1685 
1686     function bond(uint256 value) external notPaused {
1687         unfreeze(msg.sender);
1688 
1689         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom());
1690         uint256 newPhantom =
1691             totalBonded() == 0
1692                 ? totalRewarded() == 0
1693                     ? Constants.getInitialStakeMultiple().mul(value)
1694                     : 0
1695                 : totalRewardedWithPhantom.mul(value).div(totalBonded());
1696 
1697         incrementBalanceOfBonded(msg.sender, value);
1698         incrementBalanceOfPhantom(msg.sender, newPhantom);
1699         decrementBalanceOfStaged(
1700             msg.sender,
1701             value,
1702             "Pool: insufficient staged balance"
1703         );
1704 
1705         balanceCheck();
1706 
1707         emit Bond(msg.sender, epoch().add(1), value);
1708     }
1709 
1710     function unbond(uint256 value) external {
1711         unfreeze(msg.sender);
1712 
1713         uint256 balanceOfBonded = balanceOfBonded(msg.sender);
1714         Require.that(balanceOfBonded > 0, FILE, "insufficient bonded balance");
1715 
1716         uint256 newClaimable =
1717             balanceOfRewarded(msg.sender).mul(value).div(balanceOfBonded);
1718         uint256 lessPhantom =
1719             balanceOfPhantom(msg.sender).mul(value).div(balanceOfBonded);
1720 
1721         incrementBalanceOfStaged(msg.sender, value);
1722         incrementBalanceOfClaimable(msg.sender, newClaimable);
1723         decrementBalanceOfBonded(
1724             msg.sender,
1725             value,
1726             "Pool: insufficient bonded balance"
1727         );
1728         decrementBalanceOfPhantom(
1729             msg.sender,
1730             lessPhantom,
1731             "Pool: insufficient phantom balance"
1732         );
1733 
1734         balanceCheck();
1735 
1736         emit Unbond(msg.sender, epoch().add(1), value, newClaimable);
1737     }
1738 
1739     function provide(uint256 value) external onlyFrozen(msg.sender) notPaused {
1740         Require.that(totalBonded() > 0, FILE, "insufficient total bonded");
1741 
1742         Require.that(totalRewarded() > 0, FILE, "insufficient total rewarded");
1743 
1744         Require.that(
1745             balanceOfRewarded(msg.sender) >= value,
1746             FILE,
1747             "insufficient rewarded balance"
1748         );
1749 
1750         (uint256 lessDai, uint256 newUniv2) = addLiquidity(value);
1751 
1752         uint256 totalRewardedWithPhantom =
1753             totalRewarded().add(totalPhantom()).add(value);
1754         uint256 newPhantomFromBonded =
1755             totalRewardedWithPhantom.mul(newUniv2).div(totalBonded());
1756 
1757         incrementBalanceOfBonded(msg.sender, newUniv2);
1758         incrementBalanceOfPhantom(msg.sender, value.add(newPhantomFromBonded));
1759 
1760         balanceCheck();
1761 
1762         emit Provide(msg.sender, value, lessDai, newUniv2); // though here the var name is fine
1763     }
1764 
1765     function emergencyWithdraw(address token, uint256 value) external onlyDao {
1766         IERC20(token).transfer(address(dao()), value);
1767     }
1768 
1769     function emergencyPause() external onlyDao {
1770         pause();
1771     }
1772 
1773     function balanceCheck() private {
1774         Require.that(
1775             univ2().balanceOf(address(this)) >=
1776                 totalStaged().add(totalBonded()),
1777             FILE,
1778             "Inconsistent UNI-V2 balances"
1779         );
1780     }
1781 
1782     modifier onlyFrozen(address account) {
1783         Require.that(
1784             statusOf(account) == PoolAccount.Status.Frozen,
1785             FILE,
1786             "Not frozen"
1787         );
1788 
1789         _;
1790     }
1791 
1792     modifier onlyDao() {
1793         Require.that(msg.sender == address(dao()), FILE, "Not dao");
1794 
1795         _;
1796     }
1797 
1798     modifier notPaused() {
1799         Require.that(!paused(), FILE, "Paused");
1800 
1801         _;
1802     }
1803 }