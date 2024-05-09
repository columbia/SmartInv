1 // File: contracts/InternalModule.sol
2 
3 pragma solidity >=0.5.0 <0.6.0;
4 
5 contract InternalModule {
6 
7     address[] _authAddress;
8 
9     address payable[] public _contractOwners = [
10         address(0xD04C3c9eEC7BE36d28a925598B909954b4fd83cB)   // Prod
11         // address(0x4ad16f3f6B4C1C48C644756979f96bcd0bfa077B)   // Truffle Develop
12     ];
13 
14     address payable public _defaultReciver;
15 
16     constructor() public {
17 
18         require(_contractOwners.length > 0);
19 
20         _defaultReciver = _contractOwners[0];
21 
22         _contractOwners.push(msg.sender);
23     }
24 
25     modifier OwnerOnly() {
26 
27         bool exist = false;
28         for ( uint i = 0; i < _contractOwners.length; i++ ) {
29             if ( _contractOwners[i] == msg.sender ) {
30                 exist = true;
31                 break;
32             }
33         }
34 
35         require(exist); _;
36     }
37 
38     modifier DAODefense() {
39         uint256 size;
40         address payable safeAddr = msg.sender;
41         assembly {size := extcodesize(safeAddr)}
42         require( size == 0, "DAO_Warning" );
43         _;
44     }
45 
46     modifier APIMethod() {
47 
48         bool exist = false;
49 
50         for (uint i = 0; i < _authAddress.length; i++) {
51             if ( _authAddress[i] == msg.sender ) {
52                 exist = true;
53                 break;
54             }
55         }
56 
57         require(exist); _;
58     }
59 
60     function AuthAddresses() external view returns (address[] memory authAddr) {
61         return _authAddress;
62     }
63 
64     function AddAuthAddress(address _addr) external OwnerOnly {
65         _authAddress.push(_addr);
66     }
67 
68     function DelAuthAddress(address _addr) external OwnerOnly {
69 
70         for (uint i = 0; i < _authAddress.length; i++) {
71             if (_authAddress[i] == _addr) {
72                 for (uint j = 0; j < _authAddress.length - 1; j++) {
73                     _authAddress[j] = _authAddress[j+1];
74                 }
75                 delete _authAddress[_authAddress.length - 1];
76                 _authAddress.length--;
77                 return ;
78             }
79         }
80 
81     }
82 }
83 
84 // File: contracts/interface/ERC20Interface.sol
85 
86 interface ERC20Interface {
87     /**
88      * @dev Returns the amount of tokens in existence.
89      */
90     function totalSupply() external view returns (uint256);
91 
92     /**
93      * @dev Returns the amount of tokens owned by `account`.
94      */
95     function balanceOf(address account) external view returns (uint256);
96 
97     /**
98      * @dev Moves `amount` tokens from the caller's account to `recipient`.
99      *
100      * Returns a boolean value indicating whether the operation succeeded.
101      *
102      * Emits a `Transfer` event.
103      */
104     function transfer(address recipient, uint256 amount) external returns (bool);
105 
106     /**
107      * @dev Returns the remaining number of tokens that `spender` will be
108      * allowed to spend on behalf of `owner` through `transferFrom`. This is
109      * zero by default.
110      *
111      * This value changes when `approve` or `transferFrom` are called.
112      */
113     function allowance(address owner, address spender) external view returns (uint256);
114 
115     /**
116      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
117      *
118      * Returns a boolean value indicating whether the operation succeeded.
119      *
120      * > Beware that changing an allowance with this method brings the risk
121      * that someone may use both the old and the new allowance by unfortunate
122      * transaction ordering. One possible solution to mitigate this race
123      * condition is to first reduce the spender's allowance to 0 and set the
124      * desired value afterwards:
125      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
126      *
127      * Emits an `Approval` event.
128      */
129     function approve(address spender, uint256 amount) external returns (bool);
130 
131     /**
132      * @dev Moves `amount` tokens from `sender` to `recipient` using the
133      * allowance mechanism. `amount` is then deducted from the caller's
134      * allowance.
135      *
136      * Returns a boolean value indicating whether the operation succeeded.
137      *
138      * Emits a `Transfer` event.
139      */
140     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
141 
142     /**
143      * @dev Emitted when `value` tokens are moved from one account (`from`) to
144      * another (`to`).
145      *
146      * Note that `value` may be zero.
147      */
148     event Transfer(address indexed from, address indexed to, uint256 value);
149 
150     /**
151      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
152      * a call to `approve`. `value` is the new allowance.
153      */
154     event Approval(address indexed owner, address indexed spender, uint256 value);
155 }
156 
157 // File: contracts/interface/RecommendInterface.sol
158 
159 interface RecommendInterface {
160 
161 
162     function GetIntroducer( address _owner ) external view returns (address);
163 
164 
165     function RecommendList( address _owner, uint256 depth ) external view returns ( address[] memory list, uint256 len );
166 
167 
168     function ShortCodeToAddress( bytes6 shortCode ) external view returns (address);
169 
170 
171     function AddressToShortCode( address _addr ) external view returns (bytes6);
172 
173 
174     function TeamMemberTotal( address _addr ) external view returns (uint256);
175 
176 
177     function IsValidMember( address _addr ) external view returns (bool);
178 
179 
180     function IsValidMemberEx( address _addr ) external view returns (bool, uint256);
181 
182 
183     function DirectValidMembersCount( address _addr ) external view returns (uint256);
184 
185 
186     function RegisterShortCode( bytes6 shortCode ) external;
187 
188 
189     function BindRelation(address _recommer ) external;
190 
191 
192     function BindRelationEx(address _recommer, bytes6 shortCode ) external;
193 
194 
195     function GetSearchDepthMaxLimit() external view returns (uint256);
196 
197 
198     function API_MakeAddressToValid( address _owner ) external;
199 }
200 
201 // File: contracts/library/RoundController.sol
202 
203 library Times {
204     function OneDay() public pure returns (uint256) {
205         return 1 days;
206     }
207 }
208 
209 library TokenAssetPool {
210 
211     uint constant UINT_MAX = 2 ** 256 - 1;
212 
213     struct MainDB {
214 
215         mapping(address => uint256) totalAmountsMapping;
216 
217         mapping(address => uint256) assetsAmountMapping;
218     }
219 
220     function TotalAmount(MainDB storage self, address owner) internal view returns (uint256) {
221         return self.assetsAmountMapping[owner];
222     }
223 
224     function TotalSum(MainDB storage self, address owner ) internal view returns (uint256) {
225         return self.totalAmountsMapping[owner];
226     }
227 
228     function AddAmount(MainDB storage self, address owner, uint256 amount) internal {
229 
230         require( amount <= UINT_MAX );
231 
232         self.assetsAmountMapping[owner] += amount;
233 
234         self.totalAmountsMapping[owner] += amount;
235     }
236 
237     function SubAmount(MainDB storage self, address owner, uint256 amount) internal {
238 
239         require( amount <= UINT_MAX );
240         require( TotalAmount(self,owner) >= amount );
241 
242         self.assetsAmountMapping[owner] -= amount;
243     }
244 
245 }
246 
247 library StaticMath {
248 
249     function S(uint256 ir) internal pure returns (uint256 s) {
250 
251         s = 1000 ether;
252 
253         for (uint i = 0; i < ir; i ++ ) {
254             s = s * 1300000 / 1000000;
255         }
256 
257         /// INT
258         s = s / 1 ether * 1 ether;
259     }
260 
261     function P(uint256 ir) internal pure returns (uint256 r) {
262 
263         if ( ir >= 4 ) {
264 
265             for ( uint ji = 0; ji < ir - 3; ji++ ) {
266                 r += S(ji) * 300000 / 1000000;
267             }
268 
269             for ( uint i = ir - 3; i < ir; i++ ) {
270                 r += S(i) * 80000 / 1000000;
271             }
272 
273         } else if ( ir != 0 && ir < 4 ) {
274 
275             for ( uint i = 0; i < ir; i++ ) {
276                 r += S(i) * 80000 / 1000000;
277             }
278 
279         } else {
280 
281             return 0;
282         }
283 
284     }
285 
286     function O(uint256 ir, uint256 n) internal pure returns (uint256) {
287 
288         if (ir - n == 1 ) {
289             return 400000;
290         } else if (ir - n == 2 ) {
291             return 350000;
292         } else if (ir - n == 3 ) {
293             return 250000;
294         } else {
295             return 0;
296         }
297 
298     }
299 
300     function T(uint256 ir, uint256 n) internal pure returns (uint256) {
301         return P(ir) * O(ir, n) / 1000000;
302     }
303 
304     function W(uint256 ir, uint256 n) internal pure returns (uint256) {
305 
306         if ( ir - n <= 3 ) {
307 
308             uint256 subp = T(ir, n) * 1000000 / S(n);
309             if ( subp != 0 ) {
310                 subp ++;
311             }
312 
313             return 1000000 - subp;
314 
315         } else {
316 
317             return 1100000;
318         }
319     }
320 
321     function ProfitHandle(uint256 ir, bool irTimeoutable, uint256 n, uint256 ns) internal pure returns (uint256) {
322 
323         if ( (ir - n <= 3 && !irTimeoutable) || n > ir ) {
324             return 0;
325         }
326 
327         return ns * W(ir, n) / 1000000;
328     }
329 }
330 
331 library DynamicMath {
332 
333     struct MainDB {
334 
335         RecommendInterface RCMINC;
336 
337         uint[] dyp;
338     }
339 
340     struct Request {
341         address owner;
342         uint oid;
343         uint ownerDepositAmount;
344         uint stProfix;
345     }
346 
347     function Init( MainDB storage self, RecommendInterface rcminc ) internal {
348 
349         self.RCMINC = rcminc;
350 
351         self.dyp = [20, 15, 10, 10, 10, 5, 5, 5, 5, 5];
352     }
353 
354     function ProfitHandle(
355         MainDB storage self,
356         RoundController.MainDB storage RCDB,
357         Request memory req
358     )
359     internal view
360     returns (
361         uint256 len,
362         address [] memory addrs,
363         uint256 [] memory profixs
364     ) {
365         address parent = req.owner;
366         len = self.dyp.length;
367         addrs = new address[](len);
368         profixs = new uint256[](len);
369 
370         for ( (uint i, uint j) = (0,0); i < self.RCMINC.GetSearchDepthMaxLimit() && j < self.dyp.length; i++ ) {
371 
372             parent = self.RCMINC.GetIntroducer(parent);
373 
374             if ( parent != address(0x0) && parent != address(0xFF) ) {
375 
376 
377                 uint s = self.RCMINC.DirectValidMembersCount(parent);
378                 if ( self.RCMINC.IsValidMember(parent) && ( s >= j+1 || s >= 6 ) ) {
379 
380 
381                     addrs[j] = parent;
382                     profixs[j] = req.stProfix * self.dyp[j] / 100;
383 
384 
385                     if ( RCDB.roundList[req.oid].depositedMapping[parent].totalAmount * 2 < req.ownerDepositAmount ) {
386 
387                         uint bp = RCDB.roundList[req.oid].depositedMapping[parent].totalAmount * 200000 / req.ownerDepositAmount;
388 
389                         profixs[j] = profixs[j] * bp / 100000;
390                     }
391 
392                     ++j;
393                 }
394 
395             } else {
396 
397                 break;
398             }
399         }
400 
401     }
402 
403     function uint2str(uint i) internal pure returns (string memory c) {
404 
405         if (i == 0) return "0";
406         uint j = i;
407         uint length;
408         while (j != 0){
409             length++;
410             j /= 10;
411         }
412         bytes memory bstr = new bytes(length);
413         uint k = length - 1;
414 
415         while (i != 0){
416             bstr[k--] = byte( uint8(48 + i % 10) );
417             i /= 10;
418         }
419         c = string(bstr);
420     }
421 
422 }
423 
424 library LevelMath {
425 
426     struct MainDB {
427 
428         RecommendInterface RCMINC;
429 
430         uint256[] lvProfits;
431 
432         mapping(uint256 => mapping(address => uint256)) achievementMapping;
433 
434         uint256 searchDepth;
435     }
436 
437     function Init( MainDB storage self, RecommendInterface _RINC ) internal {
438         self.RCMINC = _RINC;
439         self.lvProfits = [0, 10, 5, 5, 5, 5];
440         self.searchDepth = 1024;
441     }
442 
443 
444     function SetSearchDepth( MainDB storage self, uint256 d) internal {
445         self.searchDepth = d;
446     }
447 
448 
449     function AddAchievement( MainDB storage self, address owner, uint256 oid, uint256 amount) internal {
450 
451 
452         address parent = owner;
453 
454         for ( uint i = 0; i < self.searchDepth; i++ ) {
455 
456             if ( parent != address(0x0) && parent != address(0xFF) ) {
457 
458                 self.achievementMapping[oid][parent] += amount;
459 
460             } else {
461 
462                 return ;
463             }
464 
465 
466             parent = self.RCMINC.GetIntroducer(parent);
467         }
468     }
469 
470 
471     function ProfitHandle( MainDB storage self, address owner, uint256 oid, uint256 totalRoundCount, uint staticProfixAmount )
472     internal view
473     returns (
474         uint256 len,
475         address [] memory addrs,
476         uint [] memory profitAmounts
477     ) {
478         len = self.lvProfits.length;
479         addrs = new address[](len);
480         profitAmounts = new uint[](len);
481 
482 
483         address parent = owner;
484 
485         uint256[] memory copyProfits = self.lvProfits;
486 
487         for ( uint i = 0; i < self.searchDepth; i++ ) {
488 
489             parent = self.RCMINC.GetIntroducer(parent);
490 
491             if ( parent == address(0x0) || parent == address(0xFF) ) {
492                 break;
493             }
494 
495 
496             if ( !self.RCMINC.IsValidMember(parent) ) {
497                 continue;
498             }
499 
500 
501             uint parentLv = CurrentLevelOf(self, parent, oid, totalRoundCount);
502 
503 
504             uint psum = 0;
505             for ( uint p = 0; p <= parentLv; p++ ) {
506 
507                 psum += copyProfits[p];
508 
509 
510                 copyProfits[p] = 0;
511             }
512 
513 
514             if ( psum > 0 ) {
515                 addrs[parentLv] = parent;
516                 profitAmounts[parentLv] = staticProfixAmount * psum / 100;
517             }
518 
519 
520             if ( parentLv >= self.lvProfits.length - 1 ) {
521                 break;
522             }
523 
524         }
525     }
526 
527 
528     function CurrentLevelOf( MainDB storage self, address owner, uint256 oid, uint256 totalRoundCount )
529     internal view
530     returns (uint256) {
531 
532 
533         (address [] memory communityList, uint256 rlen) = self.RCMINC.RecommendList(owner, 0);
534 
535 
536         uint256 achievementSum = 0;
537         uint256 maxCommunityAmount = 0;
538 
539         for ( uint i = 0; i < rlen; i++) {
540 
541             uint256 communitySum = 0;
542 
543             for ( uint o = oid; o < oid + 4 && o < totalRoundCount; o++ ) {
544                 communitySum += self.achievementMapping[o][communityList[i]];
545             }
546 
547             achievementSum += communitySum;
548 
549             if ( communitySum > maxCommunityAmount ) {
550                 maxCommunityAmount = communitySum;
551             }
552         }
553 
554         achievementSum -= maxCommunityAmount;
555 
556 
557         uint256 lv = 0;
558 
559         if ( achievementSum >= 100 ether ) {
560             lv = 1;
561         }
562 
563         if ( achievementSum >= 300 ether ) {
564             lv = 2;
565         }
566 
567         if ( achievementSum >= 1000 ether ) {
568             lv = 3;
569         }
570 
571         if ( achievementSum >= 3000 ether ) {
572             lv = 4;
573         }
574 
575         if ( achievementSum >= 9000 ether ) {
576             lv = 5;
577         }
578 
579         return lv;
580     }
581 
582     function uint2str(uint i) internal pure returns (string memory c) {
583 
584         if (i == 0) return "0";
585         uint j = i;
586         uint length;
587         while (j != 0){
588             length++;
589             j /= 10;
590         }
591         bytes memory bstr = new bytes(length);
592         uint k = length - 1;
593 
594         while (i != 0){
595             bstr[k--] = byte( uint8(48 + i % 10) );
596             i /= 10;
597         }
598         c = string(bstr);
599     }
600 
601 }
602 
603 library LuckAssetPool {
604 
605     using TokenAssetPool for TokenAssetPool.MainDB;
606 
607 
608     uint constant UINT_MAX = 2 ** 256 - 1;
609 
610     struct MainDB {
611 
612 
613         uint256 currentRoundTempAmount;
614 
615 
616         uint256 rewardAmountTotal;
617 
618 
619         uint256 currentRID;
620 
621 
622         mapping(uint256 => uint256) assetAmountMapping;
623 
624 
625         mapping(uint256 => uint256) rollbackAmountMapping;
626 
627 
628         mapping(uint256 => Invest[]) investMapping;
629     }
630 
631     struct Invest {
632         address who;
633         uint256 when;
634         uint256 amount;
635     }
636 
637     function RoundTimeOutDelegate(MainDB storage self, uint256 timeoutable_oid, TokenAssetPool.MainDB storage userPool)
638     internal
639     returns (
640         address[20] memory luckyOnes,
641         uint256[20] memory rewardAmounts
642     )
643     {
644         self.rollbackAmountMapping[timeoutable_oid] = self.currentRoundTempAmount;
645 
646         self.currentRoundTempAmount = 0;
647 
648 
649         (luckyOnes, rewardAmounts) = winningThePrizeAtRID(self, self.currentRID, userPool);
650 
651         self.currentRID ++;
652     }
653 
654     function RoundSuccessDelegate(MainDB storage self) internal {
655 
656 
657         self.assetAmountMapping[self.currentRID] += self.currentRoundTempAmount;
658 
659         self.currentRoundTempAmount = 0;
660     }
661 
662 
663     function BalanceOfRID(MainDB storage self, uint256 rid) internal view returns (uint256) {
664         return self.assetAmountMapping[rid];
665     }
666 
667     function DoRollback(MainDB storage self, uint256 oid, uint256 amount) internal returns (uint256 realAmount) {
668 
669         if ( self.rollbackAmountMapping[oid] >= amount ) {
670 
671             self.rollbackAmountMapping[oid] -= amount;
672 
673             realAmount = amount;
674 
675         } else {
676 
677             realAmount = self.rollbackAmountMapping[oid];
678 
679             self.rollbackAmountMapping[oid] = 0;
680         }
681 
682     }
683 
684 
685     function AppendingAmount(MainDB storage self, uint256 amount) internal {
686         self.assetAmountMapping[self.currentRID] += amount;
687     }
688 
689 
690     function AddAmountAndTryGetReward(MainDB storage self, address who, uint256 amount) internal returns (uint256 reward) {
691 
692         require( amount <= UINT_MAX );
693 
694 
695         self.currentRoundTempAmount += (amount * 30000 / 1000000);
696 
697         self.investMapping[self.currentRID].push( Invest(who, now, amount) );
698 
699 
700         reward = amount * 5 / 100;
701         if ( self.rewardAmountTotal >= reward ) {
702 
703             self.rewardAmountTotal -= reward;
704 
705         } else {
706 
707             reward = self.rewardAmountTotal;
708             self.rewardAmountTotal = 0;
709         }
710     }
711 
712 
713     function SubAmount(MainDB storage self, uint256 rid, uint256 amount) internal {
714 
715         require( amount <= UINT_MAX );
716         require( BalanceOfRID(self, rid) >= amount );
717 
718         self.assetAmountMapping[rid] -= amount;
719     }
720 
721 
722     function winningThePrizeAtRID(MainDB storage self, uint256 rid, TokenAssetPool.MainDB storage userPool )
723     private
724     returns (
725         address[20] memory luckyOnes,
726         uint256[20] memory rewardAmounts
727     )
728     {
729         uint256 ridTotalAmount = self.assetAmountMapping[rid];
730         uint256 ridTotalAmountDelta = ridTotalAmount;
731 
732         Invest[] storage _investList = self.investMapping[rid];
733 
734 
735         if ( _investList.length == 0 ) {
736 
737             self.assetAmountMapping[rid] = 0;
738 
739             self.assetAmountMapping[rid+1] += ridTotalAmountDelta;
740 
741             return (luckyOnes, rewardAmounts);
742         }
743 
744 
745         uint8[20] memory rewardsDescProps = [
746             50, /// desc 1
747             10,10,10,10, /// desc 2 - 5
748             5,5,5,5,5,5,5,5,5,5,5,5,5,5,5 /// desc 6-20
749         ];
750 
751 
752         uint256 descIndex = 0;
753 
754         for ( int li = int(_investList.length - 1); li >= 0 && descIndex < 20; li-- ) {
755 
756             Invest storage invest = _investList[uint(li)];
757 
758 
759             bool exist = false;
760             for ( uint exid = 0; exid < descIndex; exid ++ ) {
761 
762                 if ( luckyOnes[exid] == invest.who ) {
763                     exist = true;
764                     break;
765                 }
766 
767             }
768 
769 
770             if (exist) {
771                 continue;
772             }
773 
774 
775             uint256 rewardAmount = invest.amount * rewardsDescProps[descIndex];
776 
777 
778             if ( descIndex == 0 && rewardAmount > ridTotalAmount * 10 / 100 ) { /// desc 1
779 
780                 rewardAmount = ridTotalAmount * 10 / 100;
781 
782             } else if ( descIndex >= 1 && descIndex <= 4 && rewardAmount > ridTotalAmount * 5 / 100 ) { /// desc 2-5
783 
784                 rewardAmount = ridTotalAmount * 5 / 100;
785 
786             } else if ( descIndex >= 5 && rewardAmount > ridTotalAmount * 2 / 100 ) {
787 
788                 rewardAmount = ridTotalAmount * 2 / 100;
789             }
790 
791 
792             if ( rewardAmount < ridTotalAmountDelta ) {
793 
794                 userPool.AddAmount( invest.who, rewardAmount );
795                 ridTotalAmountDelta -= rewardAmount;
796 
797 
798                 luckyOnes[descIndex] = invest.who;
799                 rewardAmounts[descIndex] = rewardAmount;
800                 ++descIndex;
801             }
802 
803             else {
804 
805                 userPool.AddAmount( invest.who, ridTotalAmountDelta );
806                 ridTotalAmountDelta = 0;
807 
808                 luckyOnes[descIndex] = invest.who;
809                 rewardAmounts[descIndex] = ridTotalAmountDelta;
810 
811                 break;
812             }
813         }
814 
815 
816         if ( ridTotalAmountDelta > 0 ) {
817             self.rewardAmountTotal += ridTotalAmountDelta;
818         }
819 
820 
821         self.assetAmountMapping[rid] = 0;
822     }
823 }
824 
825 library OwnerAssetPool {
826 
827 
828     uint constant UINT_MAX = 2 ** 256 - 1;
829 
830     address constant OwnerAddress = address(0xD04C3c9eEC7BE36d28a925598B909954b4fd83cB);
831 
832     struct MainDB {
833 
834         ERC20Interface ERC20Inc;
835 
836 
837         uint256 currentRoundTempAmount;
838     }
839 
840     function Init(MainDB storage self, ERC20Interface _erc20inc) internal {
841         self.ERC20Inc = _erc20inc;
842     }
843 
844     function RoundTimeOutDelegate(MainDB storage self) internal {
845         self.currentRoundTempAmount = 0;
846     }
847 
848     function RoundSuccessDelegate(MainDB storage self) internal {
849 
850         self.ERC20Inc.transfer( OwnerAddress, self.currentRoundTempAmount );
851 
852         self.currentRoundTempAmount = 0;
853     }
854 
855 
856     function AddAmount(MainDB storage self, uint256 amount) internal {
857 
858         require( amount <= UINT_MAX );
859 
860         self.currentRoundTempAmount += (amount * 50000 / 1000000);
861     }
862 
863 }
864 
865 library RoundController {
866 
867     using TokenAssetPool for TokenAssetPool.MainDB;
868     using LevelMath for LevelMath.MainDB;
869     using DynamicMath for DynamicMath.MainDB;
870     using LuckAssetPool for LuckAssetPool.MainDB;
871     using OwnerAssetPool for OwnerAssetPool.MainDB;
872 
873     struct Deposited {
874 
875         address owner;
876 
877         uint256 totalAmount;
878 
879         uint256 latestDepositedTime;
880 
881         bool autoReDepostied;
882 
883         uint256 toOID;
884 
885         uint256 totalStProfit;
886 
887         uint256 totalDyProfit;
888 
889         uint256 totalMrgProfit;
890     }
891 
892     struct Round {
893 
894         uint256 rid;
895 
896         uint256 internalRoundID;
897 
898         uint8 status;
899 
900         uint256 totalAmount;
901 
902         uint256 currentAmount;
903 
904         uint256 createTime;
905 
906         uint256 startTime;
907 
908         uint256 endTime;
909 
910         mapping(address => Deposited) depositedMapping;
911     }
912 
913     struct MainDB {
914 
915 
916         uint256 newRIDInitProp;
917 
918         RecommendInterface RCMINC;
919         ERC20Interface ERC20INC;
920 
921         LuckAssetPool.MainDB luckAssetPool;
922         OwnerAssetPool.MainDB ownerAssetPool;
923         TokenAssetPool.MainDB userTokenPool;
924 
925         Round[] roundList;
926 
927 
928         mapping(uint256 => address[]) autoRedepositAddressMapping;
929     }
930 
931     event LogsToken(
932         address indexed owner,
933         uint256 when,
934         int256  amount,
935         uint256 indexed oid,
936         uint16 indexed typeID
937     );
938 
939     event LogsAmount(
940         address indexed owner,
941         uint256 when,
942         int256  amount,
943         uint256 indexed oid,
944         uint16 indexed typeID
945     );
946 
947     function InitFristRound(
948         MainDB storage self,
949         uint256 atTime,
950         RecommendInterface _rcminc,
951         ERC20Interface _erc20inc
952 
953     ) internal returns (bool) {
954 
955         if ( self.roundList.length > 0 ) {
956             return false;
957         }
958 
959         self.newRIDInitProp = 10;
960 
961         self.RCMINC = _rcminc;
962 
963         self.ERC20INC = _erc20inc;
964 
965         self.ownerAssetPool.Init(_erc20inc);
966 
967         self.roundList.push(
968             Round(
969                 0,///rid
970                 0,/// internalRoundID
971                 1,/// status
972                 1000 ether, /// totalAmount
973                 0, /// currentAmount
974                 atTime, /// createTime
975                 atTime + Times.OneDay() * 1, /// startTime
976                 atTime + Times.OneDay() * 8 /// endTime
977             )
978         );
979     }
980 
981     function EnableAutoRedeposit(MainDB storage self, address owner, uint256 fromRoundIdx) internal returns (bool) {
982 
983 
984         if ( !(self.roundList[fromRoundIdx].status == 2 || self.roundList[fromRoundIdx].status == 3) ) {
985             return false;
986         }
987 
988 
989         Deposited storage ownerDepositedRecord = self.roundList[fromRoundIdx].depositedMapping[owner];
990 
991 
992         address[] storage autoAddresses = self.autoRedepositAddressMapping[fromRoundIdx];
993 
994 
995         if ( !ownerDepositedRecord.autoReDepostied ) {
996 
997             ownerDepositedRecord.autoReDepostied = true;
998             autoAddresses.push(owner);
999 
1000             return true;
1001         }
1002 
1003         return false;
1004     }
1005 
1006     function TotalCount(MainDB storage self) internal view returns (uint256) {
1007         return self.roundList.length;
1008     }
1009 
1010     function RoundAt(MainDB storage self, uint i) internal view returns (Round storage) {
1011         require( i >= 0 && i < self.roundList.length );
1012         return self.roundList[i];
1013     }
1014 
1015     function CurrentRound(MainDB storage self) internal view returns (Round storage r) {
1016         return self.roundList[self.roundList.length - 1];
1017     }
1018 
1019     function CurrentRountOID(MainDB storage self) internal view returns (uint256) {
1020         return self.roundList.length - 1;
1021     }
1022 
1023     function CurrentRoundIID(MainDB storage self) internal view returns (uint256) {
1024         return CurrentRound(self).internalRoundID;
1025     }
1026 
1027     function CurrentRoundRID(MainDB storage self) internal view returns (uint256) {
1028         return CurrentRound(self).rid;
1029     }
1030 
1031     function InternalRoundCount(MainDB storage self, uint256 oid) internal view returns (uint256) {
1032 
1033         uint256 iid = self.roundList[oid].internalRoundID;
1034 
1035         for ( uint i = oid + 1; i < self.roundList.length; i++ ) {
1036             if ( self.roundList[i].internalRoundID - iid == 1 ) {
1037                 iid = self.roundList[i].internalRoundID;
1038             } else {
1039                 break;
1040             }
1041         }
1042 
1043         return iid + 1;
1044     }
1045 
1046     function CurrentRoundStatus(MainDB storage self) internal view returns (uint8) {
1047 
1048         Round storage currRound = CurrentRound(self);
1049 
1050         if ( currRound.status == 1 ) {
1051 
1052             if ( now >= currRound.startTime && now < currRound.endTime ) {
1053                 return 2;
1054             } else if ( now >= currRound.endTime ) {
1055                 return 4;
1056             }
1057         }
1058         else if ( currRound.status == 2 ) {
1059 
1060             if ( now >= currRound.endTime ) {
1061                 return 4;
1062             }
1063 
1064             if ( currRound.currentAmount >= currRound.totalAmount ) {
1065                 return 3;
1066             }
1067         }
1068 
1069         return currRound.status;
1070     }
1071 
1072     function UpdateRoundStatus(MainDB storage self) internal {
1073 
1074         Round memory mRound = self.roundList[self.roundList.length - 1];
1075         Round storage sRound = self.roundList[self.roundList.length - 1];
1076 
1077         sRound.status = CurrentRoundStatus(self);
1078 
1079         if ( mRound.status == 2 && sRound.status == 3 ) {
1080 
1081             sRound.endTime = now;
1082 
1083             if ( sRound.internalRoundID >= 3 ) {
1084                 self.roundList[ self.roundList.length - 1 - 3 ].status = 5;
1085             }
1086 
1087         }
1088         else if ( (mRound.status == 2 || mRound.status == 1) && sRound.status == 4 ) {
1089 
1090             uint256 internalRoundCount = InternalRoundCount( self, self.roundList.length - 1 );
1091             uint n = 0;
1092             if ( internalRoundCount > 4 ) {
1093                 n = internalRoundCount - 4;
1094             }
1095             for ( uint i = n; i < self.roundList.length && i < n + 3; i++ ) {
1096                 self.roundList[i].status = 6;
1097             }
1098 
1099         }
1100 
1101         CheckAndCreateNewRound(self);
1102     }
1103 
1104     function HasPriorityabPermission(MainDB storage self, address owner) internal view returns (bool) {
1105 
1106         if ( self.roundList[self.roundList.length - 1].internalRoundID != 0 ||
1107              self.roundList.length < 3 ) {
1108             return false;
1109         }
1110 
1111         for ( int i = int(self.roundList.length) - (1 + 2); i >= 0 && i > int(self.roundList.length) - (1 + 4); i-- ) {
1112 
1113             Round storage r = self.roundList[uint(i)];
1114 
1115             if ( r.status == 6 && r.depositedMapping[owner].totalAmount > 0 ) {
1116                 return true;
1117             }
1118 
1119         }
1120 
1121         return false;
1122     }
1123 
1124     function DepositedToCurrentRound(MainDB storage self, address owner, uint256 amount, bool priorityab) internal returns (bool) {
1125 
1126         UpdateRoundStatus(self);
1127 
1128         Round storage currRound = CurrentRound(self);
1129 
1130         if ( currRound.currentAmount + amount > currRound.totalAmount ) {
1131 
1132             return false;
1133 
1134         } else if ( currRound.status != 2 && !priorityab ) {
1135 
1136             return false;
1137         }
1138 
1139         currRound.depositedMapping[owner].owner = owner;
1140         currRound.depositedMapping[owner].totalAmount += amount;
1141         currRound.depositedMapping[owner].latestDepositedTime = now;
1142 
1143         currRound.currentAmount += amount;
1144 
1145         self.ownerAssetPool.AddAmount( amount );
1146 
1147         uint256 reward = self.luckAssetPool.AddAmountAndTryGetReward( owner, amount );
1148         if ( reward > 0 ) {
1149 
1150             self.ERC20INC.transfer(owner, reward);
1151 
1152             emit LogsToken(owner, now, int256(reward), CurrentRountOID(self), 7);
1153         }
1154 
1155         UpdateRoundStatus(self);
1156 
1157         emit LogsToken(owner, now, -int256(amount), CurrentRountOID(self), 1);
1158 
1159         return true;
1160     }
1161 
1162     function SettlementRoundOf(
1163         MainDB storage self,
1164         DynamicMath.MainDB storage DyMath,
1165         LevelMath.MainDB storage LVMath,
1166         address owner,
1167         uint256 oid
1168     )
1169     internal
1170     returns (
1171         PESResponse memory rsp
1172     ) {
1173         UpdateRoundStatus(self);
1174 
1175         Round storage settRound = RoundAt(self, oid);
1176 
1177         Deposited storage depositedRecord = settRound.depositedMapping[owner];
1178 
1179         require( depositedRecord.totalStProfit == 0 );
1180 
1181         require( settRound.status == 4 || settRound.status == 5 || settRound.status == 6, "RoundStatusExpection");
1182 
1183         rsp = PreExecSettlementRoundOf(self, DyMath, LVMath, owner, oid );
1184 
1185         uint256 maxProfitLimitDelta = depositedRecord.totalAmount * 120000 / 1000000;
1186 
1187         depositedRecord.totalStProfit = rsp.originalAmount + rsp.staticProfix;
1188 
1189         for ( uint di = 0; di < rsp.dyLen; di++ ) {
1190 
1191             if ( rsp.dyAddrs[di] == address(0x0) || rsp.dyProfits[di] <= 0 ) {
1192                 continue;
1193             }
1194 
1195             settRound.depositedMapping[rsp.dyAddrs[di]].totalDyProfit += rsp.dyProfits[di];
1196 
1197             if ( maxProfitLimitDelta < rsp.dyProfits[di] ) {
1198                 maxProfitLimitDelta = 0;
1199             } else {
1200                 maxProfitLimitDelta -= rsp.dyProfits[di];
1201             }
1202 
1203             if ( rsp.dyProfits[di] > 0 ) {
1204 
1205                 self.userTokenPool.AddAmount(rsp.dyAddrs[di], rsp.dyProfits[di]);
1206 
1207                 /// logs
1208                 emit LogsAmount(rsp.dyAddrs[di], now, int256(rsp.dyProfits[di]), oid, uint16(200 + di));
1209             }
1210         }
1211 
1212         for ( uint mi = 0; mi < rsp.managerLen; mi++ ) {
1213 
1214             if ( rsp.managers[mi] == address(0x0) || rsp.managers[mi] == address(0xFF) || rsp.managerProfits[mi] == 0 ) {
1215                 continue;
1216             }
1217 
1218             settRound.depositedMapping[rsp.managers[mi]].totalMrgProfit += rsp.managerProfits[mi];
1219 
1220             if ( maxProfitLimitDelta < rsp.managerProfits[mi] ) {
1221                 maxProfitLimitDelta = 0;
1222             } else {
1223                 maxProfitLimitDelta -= rsp.managerProfits[mi];
1224             }
1225 
1226             self.userTokenPool.AddAmount(rsp.managers[mi], rsp.managerProfits[mi]);
1227 
1228             /// logs
1229             emit LogsAmount(rsp.managers[mi], now, int256(rsp.managerProfits[mi]), oid, uint16(300 + mi));
1230         }
1231 
1232         if ( settRound.status == 5 ) {
1233 
1234             self.luckAssetPool.AppendingAmount( maxProfitLimitDelta );
1235 
1236             if ( !depositedRecord.autoReDepostied ) {
1237 
1238                 self.ERC20INC.transfer(owner, depositedRecord.totalStProfit);
1239 
1240                 /// logs
1241                 emit LogsToken(owner, now, int(depositedRecord.totalStProfit), oid, 2);
1242 
1243             } else {
1244 
1245                 Round storage targetRound = CurrentRound(self);
1246 
1247                 if ((targetRound.status == 1 || targetRound.status == 2) &&
1248                     targetRound.totalAmount - targetRound.currentAmount >= depositedRecord.totalStProfit ) {
1249 
1250                     depositedRecord.toOID = self.roundList.length - 1;
1251                     DepositedToCurrentRound(self, owner, depositedRecord.totalStProfit, true);
1252 
1253                 } else {
1254 
1255                     self.ERC20INC.transfer(owner, depositedRecord.totalStProfit);
1256 
1257                     depositedRecord.toOID = 1;
1258 
1259                     /// logs
1260                     emit LogsToken(owner, now, int(depositedRecord.totalStProfit), oid, 2);
1261                 }
1262             }
1263         }
1264         else if ( settRound.status == 4 ) {
1265 
1266             uint256 rollbackLuckAmount = self.luckAssetPool.DoRollback( oid, depositedRecord.totalStProfit * 30000 / 1000000 );
1267 
1268             self.ERC20INC.transfer(owner, depositedRecord.totalStProfit * 970000 / 1000000 + rollbackLuckAmount );
1269 
1270             /// logs
1271             emit LogsToken(owner, now, int(depositedRecord.totalStProfit), oid, 5);
1272 
1273         }
1274         else if (settRound.status == 6 ) {
1275 
1276             self.ERC20INC.transfer(owner, depositedRecord.totalStProfit);
1277 
1278             /// logs
1279             emit LogsToken(owner, now, int(depositedRecord.totalStProfit), oid, 6);
1280         }
1281 
1282     }
1283 
1284     struct PESResponse {
1285         uint256 originalAmount;
1286         uint256 staticProfix;
1287         uint256 dyLen;
1288         address [] dyAddrs;
1289         uint256 [] dyProfits;
1290         uint256 managerLen;
1291         address [] managers;
1292         uint256 [] managerProfits;
1293     }
1294     function PreExecSettlementRoundOf(
1295         MainDB storage self,
1296         DynamicMath.MainDB storage DyMath,
1297         LevelMath.MainDB storage LVMath,
1298         address owner,
1299         uint256 oid
1300     )
1301     internal view
1302     returns (PESResponse memory rsp) {
1303 
1304         Round storage settRound = RoundAt(self, oid);
1305         // Round storage currRound = CurrentRound(self);
1306 
1307         uint internalCount = InternalRoundCount(self, oid);
1308         Round memory settMaxRound = self.roundList[ oid + (internalCount - settRound.internalRoundID - 1) ];
1309 
1310         rsp.originalAmount = settRound.depositedMapping[owner].totalAmount;
1311 
1312         // ProfitHandle(uint256 ir, bool irTimeoutable, uint256 n, uint256 ns) internal pure returns (uint256) {
1313         uint256 nowAmount = StaticMath.ProfitHandle(
1314             settMaxRound.internalRoundID,
1315             (settMaxRound.status == 4),
1316             settRound.internalRoundID,
1317             rsp.originalAmount
1318         );
1319 
1320         if ( nowAmount < rsp.originalAmount ) {
1321             rsp.originalAmount = nowAmount;
1322             return rsp;
1323         }
1324 
1325         rsp.staticProfix = nowAmount - rsp.originalAmount;
1326 
1327         ( rsp.dyLen, rsp.dyAddrs, rsp.dyProfits ) = DyMath.ProfitHandle(
1328             self,
1329             DynamicMath.Request(
1330                 owner,
1331                 oid,
1332                 settRound.depositedMapping[owner].totalAmount,
1333                 rsp.staticProfix
1334             )
1335         );
1336 
1337         (rsp.managerLen, rsp.managers, rsp.managerProfits) = LVMath.ProfitHandle( owner, oid, self.roundList.length, rsp.staticProfix );
1338     }
1339 
1340     function CheckAndCreateNewRound(MainDB storage self) internal {
1341 
1342         Round memory latestRound = self.roundList[self.roundList.length - 1];
1343 
1344         if ( latestRound.status == 3 ) {
1345 
1346             if ( latestRound.endTime - latestRound.createTime < 2 * Times.OneDay() ) {
1347 
1348                 self.roundList.push(
1349                     Round(
1350                         latestRound.rid,
1351                         latestRound.internalRoundID + 1,
1352                         1, /// status
1353                         ((latestRound.totalAmount * 130) / 100) / 1 ether * 1 ether, /// totalAmount
1354                         0, /// currentAmount
1355                         latestRound.createTime + Times.OneDay() * 2, /// createTime
1356                         latestRound.createTime + Times.OneDay() * (2 + 1), /// startTime
1357                         latestRound.createTime + Times.OneDay() * (2 + 8) /// endTime
1358                     )
1359                 );
1360 
1361             } else {
1362 
1363                 self.roundList.push(
1364                     Round(
1365                         latestRound.rid, /// rid
1366                         latestRound.internalRoundID + 1, ///internalRoundID
1367                         1, /// status
1368                         ((latestRound.totalAmount * 130) / 100) / 1 ether * 1 ether, /// totalAmount
1369                         0, /// currentAmount
1370                         now, /// createTime
1371                         now + Times.OneDay() * 1, /// startTime
1372                         now + Times.OneDay() * 8 /// endTime
1373                     )
1374                 );
1375             }
1376 
1377             self.luckAssetPool.RoundSuccessDelegate();
1378             self.ownerAssetPool.RoundSuccessDelegate();
1379         }
1380         else if ( latestRound.status == 4 ) {
1381 
1382             uint256 totalAmount = (latestRound.totalAmount - latestRound.currentAmount) * self.newRIDInitProp / 100;
1383 
1384             if ( totalAmount < 1000 ether ) {
1385                 totalAmount = 1000 ether;
1386             }
1387 
1388             self.roundList.push(
1389                 Round(
1390                     latestRound.rid + 1, /// rid
1391                     0, /// internalRoundID
1392                     1, /// status
1393                     totalAmount / 1 ether * 1 ether, /// totalAmount
1394                     0, /// currentAmount
1395                     now, /// createTime
1396                     now + Times.OneDay() * 1, /// startTime
1397                     now + Times.OneDay() * 8 /// endTime
1398                 )
1399             );
1400 
1401             self.ownerAssetPool.RoundTimeOutDelegate();
1402 
1403             (address[20] memory addrs, uint256[20] memory amounts) = self.luckAssetPool.RoundTimeOutDelegate( self.roundList.length - 2, self.userTokenPool );
1404 
1405             for ( uint s = 0; s < 20; s++ ) {
1406                 /// logs
1407                 if ( addrs[s] != address(0x0) && addrs[s] != address(0xFF) ) {
1408                     emit LogsAmount( addrs[s], now, int(amounts[s]), self.roundList.length - 2, 100 );
1409                 }
1410             }
1411         }
1412     }
1413 
1414     function PoolBalanceOf(MainDB storage self, address owner) internal view returns (uint256) {
1415         return self.userTokenPool.TotalAmount(owner);
1416     }
1417 
1418     function PoolWithdraw(MainDB storage self, address owner, uint256 amount) internal returns (bool) {
1419 
1420         if (self.userTokenPool.TotalAmount(owner) < amount ) {
1421             return false;
1422         }
1423 
1424         self.userTokenPool.SubAmount(owner, amount);
1425 
1426         self.ERC20INC.transfer(owner, amount - amount / 100);
1427 
1428         self.ERC20INC.transfer(address(0xdead), amount / 100);
1429 
1430         /// logs
1431         emit LogsAmount( owner, now, -int256(amount), 0, 6 );
1432 
1433         /// logs
1434         emit LogsToken( owner, now, int(amount), 0, 6 );
1435 
1436         return true;
1437     }
1438 
1439     function TotalDyAmountSum(MainDB storage self, address owner) internal view returns (uint256) {
1440         return self.userTokenPool.TotalSum(owner);
1441     }
1442 }
1443 
1444 // File: contracts/MainContract.sol
1445 contract MainContract is InternalModule {
1446 
1447     RoundController.MainDB private _controller;
1448     using RoundController for RoundController.MainDB;
1449 
1450     DynamicMath.MainDB private _dyMath;
1451     using DynamicMath for DynamicMath.MainDB;
1452 
1453     LevelMath.MainDB private _levelMath;
1454     using LevelMath for LevelMath.MainDB;
1455 
1456     ERC20Interface public _Token;
1457     RecommendInterface public _RCMINC;
1458 
1459     uint256 public _depositMinLimit = 1 ether;
1460 
1461 
1462     uint256 public _depositMaxLimitProp = 1;
1463 
1464     constructor( RecommendInterface rinc, ERC20Interface tinc ) public {
1465 
1466         _RCMINC = rinc;
1467         _Token = tinc;
1468 
1469         _controller.InitFristRound(now, rinc, _Token);
1470         _dyMath.Init(rinc);
1471         _levelMath.Init(rinc);
1472     }
1473 
1474     function CurrentAllowance() public view returns (uint256) {
1475         return _Token.allowance(msg.sender, address(this));
1476     }
1477 
1478 
1479     function HasPriorityabPermission( address owner ) external view returns (bool) {
1480         return _controller.HasPriorityabPermission(owner);
1481     }
1482 
1483 
1484     function DoDeposit( uint256 amount ) external DAODefense {
1485 
1486 
1487         require( _RCMINC.GetIntroducer( msg.sender ) != address(0x0), "-0" );
1488 
1489 
1490         require( CurrentAllowance() >= amount, "-1" );
1491 
1492 
1493         require( amount % 0.001 ether == 0 );
1494 
1495 
1496         RoundController.Round storage currRound = _controller.CurrentRound();
1497         if ( currRound.totalAmount - currRound.currentAmount > 1 ether ) {
1498             require( amount >= _depositMinLimit, "Less then minlimit." );
1499         }
1500 
1501 
1502         require( amount <= currRound.totalAmount - currRound.currentAmount, "-2" );
1503 
1504 
1505         require( currRound.depositedMapping[msg.sender].totalAmount + amount <= currRound.totalAmount * _depositMaxLimitProp / 100, "-3" );
1506 
1507 
1508         require( _Token.transferFrom( msg.sender, address(this), amount ), "-4" );
1509 
1510 
1511         bool hasPriorityab = _controller.HasPriorityabPermission(msg.sender);
1512 
1513 
1514         require( _controller.DepositedToCurrentRound(msg.sender, amount, hasPriorityab), "-5" );
1515 
1516 
1517         _levelMath.AddAchievement(msg.sender, _controller.CurrentRountOID(), amount );
1518 
1519 
1520         if ( amount >= 10 ether ) {
1521             _RCMINC.API_MakeAddressToValid(msg.sender);
1522         }
1523 
1524     }
1525 
1526 
1527     function DoSettlement( uint256 oid )
1528     external DAODefense
1529     returns (
1530         uint256 originalAmount,
1531         uint256 staticProfix,
1532         address [] memory dyAddrs,
1533         uint256 [] memory dyProfits,
1534         address [] memory managers,
1535         uint256 [] memory managerProfits
1536     ) {
1537 
1538         RoundController.PESResponse memory rsp = _controller.SettlementRoundOf(
1539             _dyMath,
1540             _levelMath,
1541             msg.sender,
1542             oid
1543         );
1544 
1545         return (
1546             rsp.originalAmount,
1547             rsp.staticProfix,
1548             rsp.dyAddrs,
1549             rsp.dyProfits,
1550             rsp.managers,
1551             rsp.managerProfits
1552         );
1553     }
1554 
1555     function RoundTotalCount() external view returns (uint256) {
1556         return _controller.TotalCount();
1557     }
1558 
1559     function RoundStatusAt( uint256 oid ) external view returns (
1560         /// inside round id
1561         uint256 iid,
1562 
1563         uint8 status,
1564 
1565         uint256 totalAmount,
1566 
1567         uint256 currentAmount,
1568 
1569         uint256 createTime,
1570 
1571         uint256 startTime,
1572 
1573         uint256 endTime
1574     ) {
1575         uint256 id = oid;
1576 
1577         RoundController.Round memory round;
1578 
1579         if ( id >= _controller.TotalCount() ) {
1580             id = _controller.CurrentRountOID();
1581         }
1582 
1583         round = _controller.RoundAt(id);
1584 
1585         if ( id == _controller.CurrentRountOID() ) {
1586             status = _controller.CurrentRoundStatus();
1587         } else {
1588             status = round.status;
1589         }
1590 
1591         iid = round.internalRoundID;
1592         totalAmount = round.totalAmount;
1593         currentAmount = round.currentAmount;
1594         createTime = round.createTime;
1595         startTime = round.startTime;
1596         endTime = round.endTime;
1597     }
1598 
1599     function EnableAutoRedepostied( uint256 oid ) external {
1600         require( _controller.EnableAutoRedeposit( msg.sender, oid ) );
1601     }
1602 
1603     function DepositedRoundOIDS( address owner ) public view returns (uint256[] memory ids, uint256 len) {
1604 
1605         uint256[] memory tempIds = new uint256[](_controller.TotalCount());
1606 
1607         len = 0;
1608 
1609         for (uint i = 0; i < _controller.TotalCount(); i++ ) {
1610             if ( _controller.RoundAt(i).depositedMapping[owner].owner == owner ) {
1611                 tempIds[len++] = i;
1612             }
1613         }
1614 
1615         if (len == 0) {
1616             return (new uint256[](0), 0);
1617         }
1618 
1619         ids = new uint256[](len);
1620         for ( uint256 si = 0; si < len; si++ ) {
1621             ids[si] = tempIds[si];
1622         }
1623 
1624     }
1625 
1626     function DepositedInfo( address owner, uint256 oid ) external view returns (
1627 
1628         uint256 statuse,
1629 
1630         uint256 totalAmount,
1631 
1632         uint256 latestDepositedTime,
1633 
1634         bool autoReDepostied,
1635 
1636         uint256 redepositedToOID,
1637 
1638         uint256 totalStProfit,
1639 
1640         uint256 totalDyProfit,
1641 
1642         uint256 totalMrgProfit,
1643 
1644         uint256 lv
1645     ) {
1646         require (oid < _controller.TotalCount() );
1647 
1648         RoundController.Round storage r = _controller.RoundAt(oid);
1649         RoundController.Deposited memory d = r.depositedMapping[owner];
1650 
1651         statuse = r.status;
1652         totalAmount = d.totalAmount;
1653         latestDepositedTime = d.latestDepositedTime;
1654         autoReDepostied = d.autoReDepostied;
1655         totalStProfit = d.totalStProfit;
1656         totalDyProfit = d.totalDyProfit;
1657         totalMrgProfit = d.totalMrgProfit;
1658         redepositedToOID = d.toOID;
1659         lv = _levelMath.CurrentLevelOf(owner, oid, _controller.TotalCount());
1660     }
1661 
1662     function CurrentDepositedTotalCount(address owner) external view returns (uint256 total) {
1663 
1664         (uint256[] memory allIDS, uint256 len) = DepositedRoundOIDS(owner);
1665 
1666         for ( uint i = 0; i < len; i++ ) {
1667 
1668             RoundController.Deposited memory d = _controller.RoundAt(allIDS[i]).depositedMapping[owner];
1669 
1670             if ( d.totalStProfit == 0 ) {
1671                 total += d.totalAmount;
1672             }
1673 
1674         }
1675     }
1676 
1677     /// About LuckAsset Pool
1678     using LuckAssetPool for LuckAssetPool.MainDB;
1679     function BalanceOfLuckAssetPoolAtRID(uint256 rid) external view returns (uint256 ridTotal, uint256 rewardTotal) {
1680 
1681         uint i = rid;
1682 
1683         if ( rid > _controller.CurrentRoundRID() ) {
1684             i = _controller.CurrentRoundRID();
1685         }
1686 
1687         return (_controller.luckAssetPool.BalanceOfRID(i), _controller.luckAssetPool.rewardAmountTotal);
1688     }
1689 
1690     function PoolBalanceOf(address owner) external view returns (uint256) {
1691         return _controller.PoolBalanceOf(owner);
1692     }
1693 
1694     function PoolWithdraw(uint256 amount) external DAODefense {
1695         require( _controller.PoolWithdraw(msg.sender, amount) );
1696     }
1697 
1698     function TotalDyAmountSum(address owner) external view returns (uint256) {
1699         return _controller.TotalDyAmountSum(owner);
1700     }
1701 
1702     function Owner_SetDepositedMinLimit(uint256 a) external OwnerOnly {
1703 
1704         require(a > 0.001 ether);
1705 
1706         _depositMinLimit = a;
1707     }
1708 
1709     function Owner_SetDepositedMaxLimitProp(uint256 a) external OwnerOnly {
1710 
1711         require( a <= 100 );
1712 
1713         _depositMaxLimitProp = a;
1714     }
1715 
1716     function Owner_UpdateRoundStatus() external OwnerOnly {
1717         _controller.UpdateRoundStatus();
1718     }
1719 
1720     function Owner_SetNewRIDProp(uint256 p) external OwnerOnly {
1721         _controller.newRIDInitProp = p;
1722     }
1723 
1724     function Dev_QueryAchievement(address owner, uint256 oid) external view returns (uint256) {
1725         return _levelMath.achievementMapping[oid][owner];
1726     }
1727 
1728 }