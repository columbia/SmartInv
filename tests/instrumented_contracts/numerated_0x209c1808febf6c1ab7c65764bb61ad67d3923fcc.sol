1 /*
2 
3  * This file was generated by MyWish Platform (https://mywish.io/)
4 
5  * The complete code could be found at https://github.com/MyWishPlatform/
6 
7  * Copyright (C) 2020 MyWish
8 
9  *
10 
11  * This program is free software: you can redistribute it and/or modify
12 
13  * it under the terms of the GNU Lesser General Public License as published by
14 
15  * the Free Software Foundation, either version 3 of the License, or
16 
17  * (at your option) any later version.
18 
19  *
20 
21  * This program is distributed in the hope that it will be useful,
22 
23  * but WITHOUT ANY WARRANTY; without even the implied warranty of
24 
25  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
26 
27  * GNU Lesser General Public License for more details.
28 
29  *
30 
31  * You should have received a copy of the GNU Lesser General Public License
32 
33  * along with this program. If not, see <http://www.gnu.org/licenses/>.
34 
35  */
36 
37 pragma solidity ^0.4.24;
38 
39 
40 
41 
42 
43 /**
44 
45  * @title ERC20Basic
46 
47  * @dev Simpler version of ERC20 interface
48 
49  * @dev see https://github.com/ethereum/EIPs/issues/179
50 
51  */
52 
53 contract ERC20Basic {
54 
55   function totalSupply() public view returns (uint256);
56 
57   function balanceOf(address who) public view returns (uint256);
58 
59   function transfer(address to, uint256 value) public returns (bool);
60 
61   event Transfer(address indexed from, address indexed to, uint256 value);
62 
63 }
64 
65 
66 
67 
68 
69 
70 
71 /**
72 
73  * @title SafeMath
74 
75  * @dev Math operations with safety checks that throw on error
76 
77  */
78 
79 library SafeMath {
80 
81 
82 
83   /**
84 
85   * @dev Multiplies two numbers, throws on overflow.
86 
87   */
88 
89   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
90 
91     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
92 
93     // benefit is lost if 'b' is also tested.
94 
95     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
96 
97     if (a == 0) {
98 
99       return 0;
100 
101     }
102 
103 
104 
105     c = a * b;
106 
107     assert(c / a == b);
108 
109     return c;
110 
111   }
112 
113 
114 
115   /**
116 
117   * @dev Integer division of two numbers, truncating the quotient.
118 
119   */
120 
121   function div(uint256 a, uint256 b) internal pure returns (uint256) {
122 
123     // assert(b > 0); // Solidity automatically throws when dividing by 0
124 
125     // uint256 c = a / b;
126 
127     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
128 
129     return a / b;
130 
131   }
132 
133 
134 
135   /**
136 
137   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
138 
139   */
140 
141   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
142 
143     assert(b <= a);
144 
145     return a - b;
146 
147   }
148 
149 
150 
151   /**
152 
153   * @dev Adds two numbers, throws on overflow.
154 
155   */
156 
157   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
158 
159     c = a + b;
160 
161     assert(c >= a);
162 
163     return c;
164 
165   }
166 
167 }
168 
169 
170 
171 
172 
173 
174 
175 /**
176 
177  * @title Basic token
178 
179  * @dev Basic version of StandardToken, with no allowances.
180 
181  */
182 
183 contract BasicToken is ERC20Basic {
184 
185   using SafeMath for uint256;
186 
187 
188 
189   mapping(address => uint256) balances;
190 
191 
192 
193   uint256 totalSupply_;
194 
195 
196 
197   /**
198 
199   * @dev total number of tokens in existence
200 
201   */
202 
203   function totalSupply() public view returns (uint256) {
204 
205     return totalSupply_;
206 
207   }
208 
209 
210 
211   /**
212 
213   * @dev transfer token for a specified address
214 
215   * @param _to The address to transfer to.
216 
217   * @param _value The amount to be transferred.
218 
219   */
220 
221   function transfer(address _to, uint256 _value) public returns (bool) {
222 
223     require(_to != address(0));
224 
225     require(_value <= balances[msg.sender]);
226 
227 
228 
229     balances[msg.sender] = balances[msg.sender].sub(_value);
230 
231     balances[_to] = balances[_to].add(_value);
232 
233     emit Transfer(msg.sender, _to, _value);
234 
235     return true;
236 
237   }
238 
239 
240 
241   /**
242 
243   * @dev Gets the balance of the specified address.
244 
245   * @param _owner The address to query the the balance of.
246 
247   * @return An uint256 representing the amount owned by the passed address.
248 
249   */
250 
251   function balanceOf(address _owner) public view returns (uint256) {
252 
253     return balances[_owner];
254 
255   }
256 
257 
258 
259 }
260 
261 
262 
263 
264 
265 /**
266 
267  * @title ERC20 interface
268 
269  * @dev see https://github.com/ethereum/EIPs/issues/20
270 
271  */
272 
273 contract ERC20 is ERC20Basic {
274 
275   function allowance(address owner, address spender)
276 
277     public view returns (uint256);
278 
279 
280 
281   function transferFrom(address from, address to, uint256 value)
282 
283     public returns (bool);
284 
285 
286 
287   function approve(address spender, uint256 value) public returns (bool);
288 
289   event Approval(
290 
291     address indexed owner,
292 
293     address indexed spender,
294 
295     uint256 value
296 
297   );
298 
299 }
300 
301 
302 
303 
304 
305 /**
306 
307  * @title Standard ERC20 token
308 
309  *
310 
311  * @dev Implementation of the basic standard token.
312 
313  * @dev https://github.com/ethereum/EIPs/issues/20
314 
315  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
316 
317  */
318 
319 contract StandardToken is ERC20, BasicToken {
320 
321 
322 
323   mapping (address => mapping (address => uint256)) internal allowed;
324 
325 
326 
327 
328 
329   /**
330 
331    * @dev Transfer tokens from one address to another
332 
333    * @param _from address The address which you want to send tokens from
334 
335    * @param _to address The address which you want to transfer to
336 
337    * @param _value uint256 the amount of tokens to be transferred
338 
339    */
340 
341   function transferFrom(
342 
343     address _from,
344 
345     address _to,
346 
347     uint256 _value
348 
349   )
350 
351     public
352 
353     returns (bool)
354 
355   {
356 
357     require(_to != address(0));
358 
359     require(_value <= balances[_from]);
360 
361     require(_value <= allowed[_from][msg.sender]);
362 
363 
364 
365     balances[_from] = balances[_from].sub(_value);
366 
367     balances[_to] = balances[_to].add(_value);
368 
369     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
370 
371     emit Transfer(_from, _to, _value);
372 
373     return true;
374 
375   }
376 
377 
378 
379   /**
380 
381    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
382 
383    *
384 
385    * Beware that changing an allowance with this method brings the risk that someone may use both the old
386 
387    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
388 
389    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
390 
391    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
392 
393    * @param _spender The address which will spend the funds.
394 
395    * @param _value The amount of tokens to be spent.
396 
397    */
398 
399   function approve(address _spender, uint256 _value) public returns (bool) {
400 
401     allowed[msg.sender][_spender] = _value;
402 
403     emit Approval(msg.sender, _spender, _value);
404 
405     return true;
406 
407   }
408 
409 
410 
411   /**
412 
413    * @dev Function to check the amount of tokens that an owner allowed to a spender.
414 
415    * @param _owner address The address which owns the funds.
416 
417    * @param _spender address The address which will spend the funds.
418 
419    * @return A uint256 specifying the amount of tokens still available for the spender.
420 
421    */
422 
423   function allowance(
424 
425     address _owner,
426 
427     address _spender
428 
429    )
430 
431     public
432 
433     view
434 
435     returns (uint256)
436 
437   {
438 
439     return allowed[_owner][_spender];
440 
441   }
442 
443 
444 
445   /**
446 
447    * @dev Increase the amount of tokens that an owner allowed to a spender.
448 
449    *
450 
451    * approve should be called when allowed[_spender] == 0. To increment
452 
453    * allowed value is better to use this function to avoid 2 calls (and wait until
454 
455    * the first transaction is mined)
456 
457    * From MonolithDAO Token.sol
458 
459    * @param _spender The address which will spend the funds.
460 
461    * @param _addedValue The amount of tokens to increase the allowance by.
462 
463    */
464 
465   function increaseApproval(
466 
467     address _spender,
468 
469     uint _addedValue
470 
471   )
472 
473     public
474 
475     returns (bool)
476 
477   {
478 
479     allowed[msg.sender][_spender] = (
480 
481       allowed[msg.sender][_spender].add(_addedValue));
482 
483     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
484 
485     return true;
486 
487   }
488 
489 
490 
491   /**
492 
493    * @dev Decrease the amount of tokens that an owner allowed to a spender.
494 
495    *
496 
497    * approve should be called when allowed[_spender] == 0. To decrement
498 
499    * allowed value is better to use this function to avoid 2 calls (and wait until
500 
501    * the first transaction is mined)
502 
503    * From MonolithDAO Token.sol
504 
505    * @param _spender The address which will spend the funds.
506 
507    * @param _subtractedValue The amount of tokens to decrease the allowance by.
508 
509    */
510 
511   function decreaseApproval(
512 
513     address _spender,
514 
515     uint _subtractedValue
516 
517   )
518 
519     public
520 
521     returns (bool)
522 
523   {
524 
525     uint oldValue = allowed[msg.sender][_spender];
526 
527     if (_subtractedValue > oldValue) {
528 
529       allowed[msg.sender][_spender] = 0;
530 
531     } else {
532 
533       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
534 
535     }
536 
537     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
538 
539     return true;
540 
541   }
542 
543 
544 
545 }
546 
547 
548 
549 
550 
551 
552 
553 /**
554 
555  * @title Ownable
556 
557  * @dev The Ownable contract has an owner address, and provides basic authorization control
558 
559  * functions, this simplifies the implementation of "user permissions".
560 
561  */
562 
563 contract Ownable {
564 
565   address public owner;
566 
567 
568 
569 
570 
571   event OwnershipRenounced(address indexed previousOwner);
572 
573   event OwnershipTransferred(
574 
575     address indexed previousOwner,
576 
577     address indexed newOwner
578 
579   );
580 
581 
582 
583 
584 
585   /**
586 
587    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
588 
589    * account.
590 
591    */
592 
593   constructor() public {
594 
595     owner = msg.sender;
596 
597   }
598 
599 
600 
601   /**
602 
603    * @dev Throws if called by any account other than the owner.
604 
605    */
606 
607   modifier onlyOwner() {
608 
609     require(msg.sender == owner);
610 
611     _;
612 
613   }
614 
615 
616 
617   /**
618 
619    * @dev Allows the current owner to relinquish control of the contract.
620 
621    */
622 
623   function renounceOwnership() public onlyOwner {
624 
625     emit OwnershipRenounced(owner);
626 
627     owner = address(0);
628 
629   }
630 
631 
632 
633   /**
634 
635    * @dev Allows the current owner to transfer control of the contract to a newOwner.
636 
637    * @param _newOwner The address to transfer ownership to.
638 
639    */
640 
641   function transferOwnership(address _newOwner) public onlyOwner {
642 
643     _transferOwnership(_newOwner);
644 
645   }
646 
647 
648 
649   /**
650 
651    * @dev Transfers control of the contract to a newOwner.
652 
653    * @param _newOwner The address to transfer ownership to.
654 
655    */
656 
657   function _transferOwnership(address _newOwner) internal {
658 
659     require(_newOwner != address(0));
660 
661     emit OwnershipTransferred(owner, _newOwner);
662 
663     owner = _newOwner;
664 
665   }
666 
667 }
668 
669 
670 
671 
672 
673 /**
674 
675  * @title Mintable token
676 
677  * @dev Simple ERC20 Token example, with mintable token creation
678 
679  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
680 
681  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
682 
683  */
684 
685 contract MintableToken is StandardToken, Ownable {
686 
687   event Mint(address indexed to, uint256 amount);
688 
689   event MintFinished();
690 
691 
692 
693   bool public mintingFinished = false;
694 
695 
696 
697 
698 
699   modifier canMint() {
700 
701     require(!mintingFinished);
702 
703     _;
704 
705   }
706 
707 
708 
709   modifier hasMintPermission() {
710 
711     require(msg.sender == owner);
712 
713     _;
714 
715   }
716 
717 
718 
719   /**
720 
721    * @dev Function to mint tokens
722 
723    * @param _to The address that will receive the minted tokens.
724 
725    * @param _amount The amount of tokens to mint.
726 
727    * @return A boolean that indicates if the operation was successful.
728 
729    */
730 
731   function mint(
732 
733     address _to,
734 
735     uint256 _amount
736 
737   )
738 
739     hasMintPermission
740 
741     canMint
742 
743     public
744 
745     returns (bool)
746 
747   {
748 
749     totalSupply_ = totalSupply_.add(_amount);
750 
751     balances[_to] = balances[_to].add(_amount);
752 
753     emit Mint(_to, _amount);
754 
755     emit Transfer(address(0), _to, _amount);
756 
757     return true;
758 
759   }
760 
761 
762 
763   /**
764 
765    * @dev Function to stop minting new tokens.
766 
767    * @return True if the operation was successful.
768 
769    */
770 
771   function finishMinting() onlyOwner canMint public returns (bool) {
772 
773     mintingFinished = true;
774 
775     emit MintFinished();
776 
777     return true;
778 
779   }
780 
781 }
782 
783 
784 
785 
786 
787 contract FreezableToken is StandardToken {
788 
789     // freezing chains
790 
791     mapping (bytes32 => uint64) internal chains;
792 
793     // freezing amounts for each chain
794 
795     mapping (bytes32 => uint) internal freezings;
796 
797     // total freezing balance per address
798 
799     mapping (address => uint) internal freezingBalance;
800 
801 
802 
803     event Freezed(address indexed to, uint64 release, uint amount);
804 
805     event Released(address indexed owner, uint amount);
806 
807 
808 
809     /**
810 
811      * @dev Gets the balance of the specified address include freezing tokens.
812 
813      * @param _owner The address to query the the balance of.
814 
815      * @return An uint256 representing the amount owned by the passed address.
816 
817      */
818 
819     function balanceOf(address _owner) public view returns (uint256 balance) {
820 
821         return super.balanceOf(_owner) + freezingBalance[_owner];
822 
823     }
824 
825 
826 
827     /**
828 
829      * @dev Gets the balance of the specified address without freezing tokens.
830 
831      * @param _owner The address to query the the balance of.
832 
833      * @return An uint256 representing the amount owned by the passed address.
834 
835      */
836 
837     function actualBalanceOf(address _owner) public view returns (uint256 balance) {
838 
839         return super.balanceOf(_owner);
840 
841     }
842 
843 
844 
845     function freezingBalanceOf(address _owner) public view returns (uint256 balance) {
846 
847         return freezingBalance[_owner];
848 
849     }
850 
851 
852 
853     /**
854 
855      * @dev gets freezing count
856 
857      * @param _addr Address of freeze tokens owner.
858 
859      */
860 
861     function freezingCount(address _addr) public view returns (uint count) {
862 
863         uint64 release = chains[toKey(_addr, 0)];
864 
865         while (release != 0) {
866 
867             count++;
868 
869             release = chains[toKey(_addr, release)];
870 
871         }
872 
873     }
874 
875 
876 
877     /**
878 
879      * @dev gets freezing end date and freezing balance for the freezing portion specified by index.
880 
881      * @param _addr Address of freeze tokens owner.
882 
883      * @param _index Freezing portion index. It ordered by release date descending.
884 
885      */
886 
887     function getFreezing(address _addr, uint _index) public view returns (uint64 _release, uint _balance) {
888 
889         for (uint i = 0; i < _index + 1; i++) {
890 
891             _release = chains[toKey(_addr, _release)];
892 
893             if (_release == 0) {
894 
895                 return;
896 
897             }
898 
899         }
900 
901         _balance = freezings[toKey(_addr, _release)];
902 
903     }
904 
905 
906 
907     /**
908 
909      * @dev freeze your tokens to the specified address.
910 
911      *      Be careful, gas usage is not deterministic,
912 
913      *      and depends on how many freezes _to address already has.
914 
915      * @param _to Address to which token will be freeze.
916 
917      * @param _amount Amount of token to freeze.
918 
919      * @param _until Release date, must be in future.
920 
921      */
922 
923     function freezeTo(address _to, uint _amount, uint64 _until) public {
924 
925         require(_to != address(0));
926 
927         require(_amount <= balances[msg.sender]);
928 
929 
930 
931         balances[msg.sender] = balances[msg.sender].sub(_amount);
932 
933 
934 
935         bytes32 currentKey = toKey(_to, _until);
936 
937         freezings[currentKey] = freezings[currentKey].add(_amount);
938 
939         freezingBalance[_to] = freezingBalance[_to].add(_amount);
940 
941 
942 
943         freeze(_to, _until);
944 
945         emit Transfer(msg.sender, _to, _amount);
946 
947         emit Freezed(_to, _until, _amount);
948 
949     }
950 
951 
952 
953     /**
954 
955      * @dev release first available freezing tokens.
956 
957      */
958 
959     function releaseOnce() public {
960 
961         bytes32 headKey = toKey(msg.sender, 0);
962 
963         uint64 head = chains[headKey];
964 
965         require(head != 0);
966 
967         require(uint64(block.timestamp) > head);
968 
969         bytes32 currentKey = toKey(msg.sender, head);
970 
971 
972 
973         uint64 next = chains[currentKey];
974 
975 
976 
977         uint amount = freezings[currentKey];
978 
979         delete freezings[currentKey];
980 
981 
982 
983         balances[msg.sender] = balances[msg.sender].add(amount);
984 
985         freezingBalance[msg.sender] = freezingBalance[msg.sender].sub(amount);
986 
987 
988 
989         if (next == 0) {
990 
991             delete chains[headKey];
992 
993         } else {
994 
995             chains[headKey] = next;
996 
997             delete chains[currentKey];
998 
999         }
1000 
1001         emit Released(msg.sender, amount);
1002 
1003     }
1004 
1005 
1006 
1007     /**
1008 
1009      * @dev release all available for release freezing tokens. Gas usage is not deterministic!
1010 
1011      * @return how many tokens was released
1012 
1013      */
1014 
1015     function releaseAll() public returns (uint tokens) {
1016 
1017         uint release;
1018 
1019         uint balance;
1020 
1021         (release, balance) = getFreezing(msg.sender, 0);
1022 
1023         while (release != 0 && block.timestamp > release) {
1024 
1025             releaseOnce();
1026 
1027             tokens += balance;
1028 
1029             (release, balance) = getFreezing(msg.sender, 0);
1030 
1031         }
1032 
1033     }
1034 
1035 
1036 
1037     function toKey(address _addr, uint _release) internal pure returns (bytes32 result) {
1038 
1039         // WISH masc to increase entropy
1040 
1041         result = 0x5749534800000000000000000000000000000000000000000000000000000000;
1042 
1043         assembly {
1044 
1045             result := or(result, mul(_addr, 0x10000000000000000))
1046 
1047             result := or(result, _release)
1048 
1049         }
1050 
1051     }
1052 
1053 
1054 
1055     function freeze(address _to, uint64 _until) internal {
1056 
1057         require(_until > block.timestamp);
1058 
1059         bytes32 key = toKey(_to, _until);
1060 
1061         bytes32 parentKey = toKey(_to, uint64(0));
1062 
1063         uint64 next = chains[parentKey];
1064 
1065 
1066 
1067         if (next == 0) {
1068 
1069             chains[parentKey] = _until;
1070 
1071             return;
1072 
1073         }
1074 
1075 
1076 
1077         bytes32 nextKey = toKey(_to, next);
1078 
1079         uint parent;
1080 
1081 
1082 
1083         while (next != 0 && _until > next) {
1084 
1085             parent = next;
1086 
1087             parentKey = nextKey;
1088 
1089 
1090 
1091             next = chains[nextKey];
1092 
1093             nextKey = toKey(_to, next);
1094 
1095         }
1096 
1097 
1098 
1099         if (_until == next) {
1100 
1101             return;
1102 
1103         }
1104 
1105 
1106 
1107         if (next != 0) {
1108 
1109             chains[key] = next;
1110 
1111         }
1112 
1113 
1114 
1115         chains[parentKey] = _until;
1116 
1117     }
1118 
1119 }
1120 
1121 
1122 
1123 
1124 
1125 /**
1126 
1127  * @title Burnable Token
1128 
1129  * @dev Token that can be irreversibly burned (destroyed).
1130 
1131  */
1132 
1133 contract BurnableToken is BasicToken {
1134 
1135 
1136 
1137   event Burn(address indexed burner, uint256 value);
1138 
1139 
1140 
1141   /**
1142 
1143    * @dev Burns a specific amount of tokens.
1144 
1145    * @param _value The amount of token to be burned.
1146 
1147    */
1148 
1149   function burn(uint256 _value) public {
1150 
1151     _burn(msg.sender, _value);
1152 
1153   }
1154 
1155 
1156 
1157   function _burn(address _who, uint256 _value) internal {
1158 
1159     require(_value <= balances[_who]);
1160 
1161     // no need to require value <= totalSupply, since that would imply the
1162 
1163     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
1164 
1165 
1166 
1167     balances[_who] = balances[_who].sub(_value);
1168 
1169     totalSupply_ = totalSupply_.sub(_value);
1170 
1171     emit Burn(_who, _value);
1172 
1173     emit Transfer(_who, address(0), _value);
1174 
1175   }
1176 
1177 }
1178 
1179 
1180 
1181 
1182 
1183 
1184 
1185 /**
1186 
1187  * @title Pausable
1188 
1189  * @dev Base contract which allows children to implement an emergency stop mechanism.
1190 
1191  */
1192 
1193 contract Pausable is Ownable {
1194 
1195   event Pause();
1196 
1197   event Unpause();
1198 
1199 
1200 
1201   bool public paused = false;
1202 
1203 
1204 
1205 
1206 
1207   /**
1208 
1209    * @dev Modifier to make a function callable only when the contract is not paused.
1210 
1211    */
1212 
1213   modifier whenNotPaused() {
1214 
1215     require(!paused);
1216 
1217     _;
1218 
1219   }
1220 
1221 
1222 
1223   /**
1224 
1225    * @dev Modifier to make a function callable only when the contract is paused.
1226 
1227    */
1228 
1229   modifier whenPaused() {
1230 
1231     require(paused);
1232 
1233     _;
1234 
1235   }
1236 
1237 
1238 
1239   /**
1240 
1241    * @dev called by the owner to pause, triggers stopped state
1242 
1243    */
1244 
1245   function pause() onlyOwner whenNotPaused public {
1246 
1247     paused = true;
1248 
1249     emit Pause();
1250 
1251   }
1252 
1253 
1254 
1255   /**
1256 
1257    * @dev called by the owner to unpause, returns to normal state
1258 
1259    */
1260 
1261   function unpause() onlyOwner whenPaused public {
1262 
1263     paused = false;
1264 
1265     emit Unpause();
1266 
1267   }
1268 
1269 }
1270 
1271 
1272 
1273 
1274 
1275 contract FreezableMintableToken is FreezableToken, MintableToken {
1276 
1277     /**
1278 
1279      * @dev Mint the specified amount of token to the specified address and freeze it until the specified date.
1280 
1281      *      Be careful, gas usage is not deterministic,
1282 
1283      *      and depends on how many freezes _to address already has.
1284 
1285      * @param _to Address to which token will be freeze.
1286 
1287      * @param _amount Amount of token to mint and freeze.
1288 
1289      * @param _until Release date, must be in future.
1290 
1291      * @return A boolean that indicates if the operation was successful.
1292 
1293      */
1294 
1295     function mintAndFreeze(address _to, uint _amount, uint64 _until) public onlyOwner canMint returns (bool) {
1296 
1297         totalSupply_ = totalSupply_.add(_amount);
1298 
1299 
1300 
1301         bytes32 currentKey = toKey(_to, _until);
1302 
1303         freezings[currentKey] = freezings[currentKey].add(_amount);
1304 
1305         freezingBalance[_to] = freezingBalance[_to].add(_amount);
1306 
1307 
1308 
1309         freeze(_to, _until);
1310 
1311         emit Mint(_to, _amount);
1312 
1313         emit Freezed(_to, _until, _amount);
1314 
1315         emit Transfer(msg.sender, _to, _amount);
1316 
1317         return true;
1318 
1319     }
1320 
1321 }
1322 
1323 
1324 
1325 
1326 
1327 
1328 
1329 contract Consts {
1330 
1331     uint public constant TOKEN_DECIMALS = 18;
1332 
1333     uint8 public constant TOKEN_DECIMALS_UINT8 = 18;
1334 
1335     uint public constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
1336 
1337 
1338 
1339     string public constant TOKEN_NAME = "APEcoin";
1340 
1341     string public constant TOKEN_SYMBOL = "APE";
1342 
1343     bool public constant PAUSED = false;
1344 
1345     address public constant TARGET_USER = 0x1456887aFF1DBf8Cc3a4022D79712c887bD8AAdb;
1346 
1347     
1348 
1349     bool public constant CONTINUE_MINTING = true;
1350 
1351 }
1352 
1353 
1354 
1355 
1356 
1357 
1358 
1359 
1360 
1361 contract MainToken is Consts, FreezableMintableToken, BurnableToken, Pausable
1362 
1363     
1364 
1365 {
1366 
1367     
1368 
1369     event Initialized();
1370 
1371     bool public initialized = false;
1372 
1373 
1374 
1375     constructor() public {
1376 
1377         init();
1378 
1379         transferOwnership(TARGET_USER);
1380 
1381     }
1382 
1383     
1384 
1385 
1386 
1387     function name() public pure returns (string _name) {
1388 
1389         return TOKEN_NAME;
1390 
1391     }
1392 
1393 
1394 
1395     function symbol() public pure returns (string _symbol) {
1396 
1397         return TOKEN_SYMBOL;
1398 
1399     }
1400 
1401 
1402 
1403     function decimals() public pure returns (uint8 _decimals) {
1404 
1405         return TOKEN_DECIMALS_UINT8;
1406 
1407     }
1408 
1409 
1410 
1411     function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {
1412 
1413         require(!paused);
1414 
1415         return super.transferFrom(_from, _to, _value);
1416 
1417     }
1418 
1419 
1420 
1421     function transfer(address _to, uint256 _value) public returns (bool _success) {
1422 
1423         require(!paused);
1424 
1425         return super.transfer(_to, _value);
1426 
1427     }
1428 
1429 
1430 
1431     
1432 
1433     function init() private {
1434 
1435         require(!initialized);
1436 
1437         initialized = true;
1438 
1439 
1440 
1441         if (PAUSED) {
1442 
1443             pause();
1444 
1445         }
1446 
1447 
1448 
1449         
1450 
1451 
1452 
1453         if (!CONTINUE_MINTING) {
1454 
1455             finishMinting();
1456 
1457         }
1458 
1459 
1460 
1461         emit Initialized();
1462 
1463     }
1464 
1465     
1466 
1467 }