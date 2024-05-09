1 pragma solidity >=0.5.0 <0.6.0;
2 
3 contract InternalModule {
4 
5     address[] _authAddress;
6 
7     address payable public _defaultReciver = address(0x2E5600376D4F07F13Ea69Caf416FB2F7B6659897);
8 
9     address payable[] public _contractOwners = [
10         address(0xc99D13544297d5baD9e0b0Ca0E94A4E614312F33)
11     ];
12 
13     constructor() public {
14         _contractOwners.push(msg.sender);
15     }
16 
17     modifier OwnerOnly() {
18 
19         bool exist = false;
20         for ( uint i = 0; i < _contractOwners.length; i++ ) {
21             if ( _contractOwners[i] == msg.sender ) {
22                 exist = true;
23                 break;
24             }
25         }
26 
27         require(exist); _;
28     }
29 
30     modifier DAODefense() {
31         uint256 size;
32         address payable safeAddr = msg.sender;
33         assembly {size := extcodesize(safeAddr)}
34         require( size == 0, "DAO_Warning" );
35         _;
36     }
37 
38     modifier APIMethod() {
39 
40         bool exist = false;
41 
42         for (uint i = 0; i < _authAddress.length; i++) {
43             if ( _authAddress[i] == msg.sender ) {
44                 exist = true;
45                 break;
46             }
47         }
48 
49         require(exist); _;
50     }
51 
52     function AuthAddresses() external view returns (address[] memory authAddr) {
53         return _authAddress;
54     }
55 
56     function AddAuthAddress(address _addr) external OwnerOnly {
57         _authAddress.push(_addr);
58     }
59 
60     function DelAuthAddress(address _addr) external OwnerOnly {
61 
62         for (uint i = 0; i < _authAddress.length; i++) {
63             if (_authAddress[i] == _addr) {
64                 for (uint j = 0; j < _authAddress.length - 1; j++) {
65                     _authAddress[j] = _authAddress[j+1];
66                 }
67                 delete _authAddress[_authAddress.length - 1];
68                 _authAddress.length--;
69                 return ;
70             }
71         }
72 
73     }
74 
75 
76 
77 
78 
79 }
80 
81 
82 
83 pragma solidity >=0.5.1 <0.7.0;
84 
85 contract KState {
86 
87     address private _KDeveloper;
88     address internal _KIMPLAddress;
89 
90     address[] _KAuthAddress;
91 
92     address payable public _KDefaultReciver = address(0x2E5600376D4F07F13Ea69Caf416FB2F7B6659897);
93 
94     address payable[] public _KContractOwners = [
95         address(0xc99D13544297d5baD9e0b0Ca0E94A4E614312F33)
96     ];
97 
98     bool public _KContractBroken;
99     mapping (address => bool) _KWithdrawabledAddress;
100 
101     constructor() public {
102         _KDeveloper = msg.sender;
103         _KContractOwners.push(msg.sender);
104     }
105 
106     modifier KWhenBroken() {
107         require(_KContractBroken); _;
108     }
109 
110     modifier KWhenNotBroken() {
111         require(!_KContractBroken); _;
112     }
113 
114     modifier KOwnerOnly() {
115 
116         bool exist = false;
117 
118         for ( uint i = 0; i < _KContractOwners.length; i++ ) {
119             if ( _KContractOwners[i] == msg.sender ) {
120                 exist = true;
121                 break;
122             }
123         }
124 
125         require(exist); _;
126     }
127 
128     function KSetContractBroken(bool broken) external KOwnerOnly {
129         _KContractBroken = broken;
130     }
131 
132     modifier KDAODefense() {
133         uint256 size;
134         address payable safeAddr = msg.sender;
135         assembly {size := extcodesize(safeAddr)}
136         require( size == 0, "DAO_Warning" );
137         _;
138     }
139 
140     modifier KAPIMethod() {
141 
142         bool exist = false;
143 
144         for (uint i = 0; i < _KAuthAddress.length; i++) {
145             if ( _KAuthAddress[i] == msg.sender ) {
146                 exist = true;
147                 break;
148             }
149         }
150 
151         require(exist); _;
152     }
153 
154     function KAuthAddresses() external view returns (address[] memory authAddr) {
155         return _KAuthAddress;
156     }
157 
158     function KAddAuthAddress(address _addr) external KOwnerOnly {
159         _KAuthAddress.push(_addr);
160     }
161 
162     modifier KDeveloperOnly {
163         require(msg.sender == _KDeveloper); _;
164     }
165 
166     function KSetImplAddress(address impl) external KDeveloperOnly {
167         _KIMPLAddress = impl;
168     }
169 
170     function KGetImplAddress() external view KDeveloperOnly returns (address) {
171         return _KIMPLAddress;
172     }
173 
174 }
175 
176 contract KDoctor is KState {
177     modifier write {_;}
178 }
179 
180 contract KContract is KState {
181 
182     modifier write {
183 
184         if ( _KIMPLAddress != address(0x0) ) {
185 
186             (, bytes memory ret) = address(_KIMPLAddress).delegatecall(msg.data);
187 
188             assembly {
189                 return( add(ret, 0x20), mload(ret) )
190             }
191 
192         } else {
193             _;
194         }
195     }
196 }
197 
198 
199 
200 pragma solidity >=0.4.22 <0.7.0;
201 
202 library UserRelation {
203 
204     struct MainDB {
205 
206         uint totalAddresses;
207 
208         mapping ( address => address ) _recommerMapping;
209 
210         mapping ( address => address[] ) _recommerList;
211 
212         mapping ( address => uint256 ) _recommerCountMapping;
213 
214         mapping ( bytes6 => address ) _shortCodeMapping;
215 
216         mapping ( address => bytes6 ) _addressShotCodeMapping;
217     }
218 
219     function Init(MainDB storage self) internal {
220 
221         address rootAddr = address(0xdead);
222         bytes6 rootCode = 0x303030303030;
223 
224 
225         self._recommerMapping[rootAddr] = address(0xdeaddead);
226         self._shortCodeMapping[rootCode] = rootAddr;
227         self._addressShotCodeMapping[rootAddr] = rootCode;
228     }
229 
230 
231     function GetIntroducer( MainDB storage self, address _owner ) internal view returns (address) {
232         return self._recommerMapping[_owner];
233     }
234 
235 
236     function RecommendList( MainDB storage self, address _owner ) internal view returns ( address[] memory list, uint256 len ) {
237         return (self._recommerList[_owner], self._recommerList[_owner].length );
238     }
239 
240 
241     function RegisterShortCode( MainDB storage self, address _owner, bytes6 shortCode ) internal returns (bool) {
242 
243 
244         if ( self._shortCodeMapping[shortCode] != address(0x0) ) {
245             return false;
246         }
247 
248 
249         if ( self._addressShotCodeMapping[_owner] != bytes6(0x0) ) {
250             return false;
251         }
252 
253 
254         self._shortCodeMapping[shortCode] = _owner;
255         self._addressShotCodeMapping[_owner] = shortCode;
256 
257         return true;
258     }
259 
260 
261     function ShortCodeToAddress( MainDB storage self, bytes6 shortCode ) internal view returns (address) {
262         return self._shortCodeMapping[shortCode];
263     }
264 
265 
266     function AddressToShortCode( MainDB storage self, address addr ) internal view returns (bytes6) {
267         return self._addressShotCodeMapping[addr];
268     }
269 
270 
271 
272 
273 
274 
275 
276     function AddRelation( MainDB storage self, address owner, address recommer ) internal returns (int) {
277 
278 
279         if ( recommer == owner )  {
280             require(false, "-1");
281             return -1;
282         }
283 
284 
285         require( recommer != owner, "-1" );
286 
287 
288         require( self._recommerMapping[owner] == address(0x0), "-2");
289 
290 
291         if ( recommer != address(0xdead) ) {
292             require( self._recommerMapping[recommer] != address(0x0), "-3");
293         }
294 
295 
296         self._recommerMapping[owner] = recommer;
297 
298         self._recommerList[recommer].push(owner);
299 
300         self._recommerCountMapping[recommer] ++;
301 
302         self.totalAddresses++;
303 
304         return 0;
305     }
306 
307 
308 
309 
310 
311 
312 
313 
314     function AddRelationEx( MainDB storage self, address owner, address recommer, bytes6 regShoutCode ) internal returns (int) {
315 
316         if ( !RegisterShortCode(self, owner, regShoutCode) ) {
317             return -4;
318         }
319 
320         return AddRelation(self, owner, recommer);
321     }
322 
323 
324     function TeamMemberTotal( MainDB storage self, address _addr ) internal view returns (uint256) {
325         return self._recommerCountMapping[_addr];
326     }
327 
328 }
329 
330 
331 
332 pragma solidity >=0.4.22 <0.7.0;
333 
334 
335 library Achievement {
336 
337     using UserRelation for UserRelation.MainDB;
338 
339     struct MainDB {
340 
341 
342 
343         uint latestVersion;
344 
345 
346         uint currVersion;
347 
348 
349         mapping(uint => mapping(address => uint) ) achievementMapping;
350 
351 
352         mapping ( address => uint256 ) _vaildMemberCountMapping;
353 
354 
355         mapping ( address => bool ) _vaildMembersMapping;
356 
357 
358         mapping ( address => uint256 ) _despositTotalMapping;
359     }
360 
361 
362     function AppendAchievement( MainDB storage self, UserRelation.MainDB storage userRelation, address owner, uint value )
363     internal {
364 
365         require(value > 0, "ValueIsZero");
366 
367         for (
368             address parent = owner;
369             parent != address(0x0) && parent != address(0xdead);
370             parent = userRelation.GetIntroducer(parent)
371         ) {
372             self.achievementMapping[self.currVersion][parent] += value;
373         }
374 
375     }
376 
377 
378     function DivestmentAchievement( MainDB storage self, UserRelation.MainDB storage userRelation, address owner, uint value)
379     internal {
380 
381         for (
382             address parent = owner;
383             parent != address(0x0) && parent != address(0xdaed);
384             parent = userRelation.GetIntroducer(parent)
385         ) {
386             if ( self.achievementMapping[self.currVersion][parent] < value ) {
387                 self.achievementMapping[self.currVersion][parent] = 0;
388             } else {
389                 self.achievementMapping[self.currVersion][parent] -= value;
390             }
391         }
392     }
393 
394     function AchievementValueOfOwner( MainDB storage self, address owner )
395     internal view
396     returns (uint) {
397         return self.achievementMapping[self.currVersion][owner];
398     }
399 
400 
401     function AchievementDistribution( MainDB storage self, UserRelation.MainDB storage userRelation, address owner)
402     internal view
403     returns (
404 
405         uint totalSum,
406 
407         uint large,
408 
409         uint len,
410 
411         address[] memory addrs,
412 
413         uint[] memory values
414     ) {
415         totalSum = self.achievementMapping[self.currVersion][owner];
416 
417 
418         (addrs, len) = userRelation.RecommendList(owner);
419 
420         for ( uint i = 0; i < len; i++ ) {
421 
422             values[i] = self.achievementMapping[self.currVersion][addrs[i]];
423 
424             if ( self.achievementMapping[self.currVersion][addrs[i]] > large ) {
425                 large = self.achievementMapping[self.currVersion][addrs[i]];
426             }
427         }
428     }
429 
430 
431     function AchievementDynamicValue( MainDB storage self, UserRelation.MainDB storage userRelation, address owner)
432     internal view
433     returns (
434         uint v
435     ) {
436 
437         uint large;
438         uint largeId;
439         (address[] memory addrs, uint len) = userRelation.RecommendList(owner);
440         uint[] memory values = new uint[](len);
441 
442         for ( uint i = 0; i < len; i++ ) {
443 
444             values[i] = self.achievementMapping[self.currVersion][addrs[i]];
445 
446             if ( self.achievementMapping[self.currVersion][addrs[i]] > large ) {
447                 large = self.achievementMapping[self.currVersion][addrs[i]];
448                 largeId = i;
449             }
450         }
451 
452         for ( uint i = 0; i < len; i++ ) {
453 
454             if ( i != largeId ) {
455 
456                 if ( values[i] > 10000 ether ) {
457 
458                     v += ((values[i]) / 1 ether) + 90000;
459 
460                 } else {
461 
462                     v += (values[i] / 1 ether) * 10;
463                 }
464 
465             } else {
466 
467 
468                 v += (values[i] / 1 ether) / 1000;
469             }
470         }
471 
472     }
473 
474 
475     function ValidMembersCountOf( MainDB storage self, address _addr ) internal view returns (uint256) {
476         return self._vaildMemberCountMapping[_addr];
477     }
478 
479     function InvestTotalEtherOf( MainDB storage self, address _addr ) internal view returns (uint256) {
480         return self._despositTotalMapping[_addr];
481     }
482 
483     function DirectValidMembersCount( MainDB storage self, UserRelation.MainDB storage userRelation, address _addr ) internal view returns (uint256) {
484 
485         uint256 count = 0;
486         address[] storage rlist = userRelation._recommerList[_addr];
487         for ( uint i = 0; i < rlist.length; i++ ) {
488             if ( self._vaildMembersMapping[rlist[i]] ) {
489                 count ++;
490             }
491         }
492 
493         return count;
494     }
495 
496 
497     function IsValidMember( MainDB storage self, address _addr ) internal view returns (bool) {
498         return self._vaildMembersMapping[_addr];
499     }
500 
501     function MarkValidAddress( MainDB storage self, UserRelation.MainDB storage userRelation, address _addr, uint256 _evalue ) external {
502 
503         if ( self._vaildMembersMapping[_addr] == false ) {
504 
505 
506 
507             address parent = userRelation._recommerMapping[_addr];
508 
509             for ( uint i = 0; i < 15; i++ ) {
510 
511                 self._vaildMemberCountMapping[parent] ++;
512 
513                 parent = userRelation._recommerMapping[parent];
514 
515                 if ( parent == address(0x0) ) {
516                     break;
517                 }
518             }
519 
520             self._vaildMembersMapping[_addr] = true;
521         }
522 
523 
524         self._despositTotalMapping[_addr] += _evalue;
525     }
526 }
527 
528 
529 
530 pragma solidity >=0.5.1 <0.6.0;
531 
532 
533 
534 contract Recommend is KContract {
535 
536     UserRelation.MainDB _userRelation;
537     using UserRelation for UserRelation.MainDB;
538 
539     constructor() public {
540         _userRelation.Init();
541     }
542 
543     function GetIntroducer( address _owner ) external view returns (address) {
544         return _userRelation.GetIntroducer(_owner);
545     }
546 
547     function RecommendList( address _owner) external view returns ( address[] memory list, uint256 len ) {
548         return _userRelation.RecommendList(_owner);
549     }
550 
551     function ShortCodeToAddress( bytes6 shortCode ) external view returns (address) {
552         return _userRelation.ShortCodeToAddress(shortCode);
553     }
554 
555     function AddressToShortCode( address _addr ) external view returns (bytes6) {
556         return _userRelation.AddressToShortCode(_addr);
557     }
558 
559     function TeamMemberTotal( address _addr ) external view returns (uint256) {
560         return _userRelation.TeamMemberTotal(_addr);
561     }
562 
563     function RegisterShortCode( bytes6 shortCode ) external write {
564         require(_userRelation.RegisterShortCode(msg.sender, shortCode));
565     }
566 
567     function BindRelation( address _recommer ) external write {
568         require( _userRelation.AddRelation(msg.sender, _recommer) >= 0, "-1" );
569     }
570 
571     function BindRelationEx( address _recommer, bytes6 shortCode ) external write{
572         require( _userRelation.AddRelationEx(msg.sender, _recommer, shortCode) >= 0, "-1" );
573     }
574 
575     function AddressesCount() external view returns (uint) {
576         return _userRelation.totalAddresses;
577     }
578 }
579 
580 
581 
582 pragma solidity >=0.5.1 <0.6.0;
583 
584 
585 
586 
587 contract RecommendSmallTeam is Recommend {
588 
589     Achievement.MainDB _achievementer;
590     using Achievement for Achievement.MainDB;
591 
592 
593     function API_AppendAchievement( address owner, uint value )
594     external write KAPIMethod {
595         _achievementer.AppendAchievement( _userRelation, owner, value );
596     }
597 
598 
599     function API_DivestmentAchievement( address owner, uint value)
600     external write KAPIMethod {
601         _achievementer.DivestmentAchievement( _userRelation, owner, value );
602     }
603 
604 
605     function AchievementValueOf( address owner )
606     external view
607     returns (uint) {
608         return _achievementer.AchievementValueOfOwner(owner);
609     }
610 
611 
612     function AchievementDistributionOf( address owner)
613     external view
614     returns (
615 
616         uint totalSum,
617 
618         uint large,
619 
620         uint len,
621 
622         address[] memory addrs,
623 
624         uint[] memory values
625     ) {
626         return _achievementer.AchievementDistribution(_userRelation, owner );
627     }
628 
629 
630     function AchievementDynamicValue( address owner)
631     external view
632     returns ( uint ) {
633         return _achievementer.AchievementDynamicValue(_userRelation, owner);
634     }
635 
636 
637     function ValidMembersCountOf( address _addr ) external view returns (uint256) {
638         return _achievementer.ValidMembersCountOf(_addr);
639     }
640 
641     function InvestTotalEtherOf( address _addr ) external view returns (uint256) {
642         return _achievementer.InvestTotalEtherOf(_addr);
643     }
644 
645     function DirectValidMembersCount( address _addr ) external view returns (uint256) {
646         return _achievementer.DirectValidMembersCount(_userRelation, _addr);
647     }
648 
649 
650     function IsValidMember( address _addr ) external view returns (bool) {
651         return _achievementer.IsValidMember(_addr);
652     }
653 
654     function TotalAddresses() external view returns (uint) {
655         return _userRelation.totalAddresses;
656     }
657 
658 
659     function API_MarkValid( address _addr, uint256 _evalue ) external KAPIMethod {
660         return _achievementer.MarkValidAddress(_userRelation, _addr, _evalue);
661     }
662 
663 
664     function Developer_VersionInfo() external view returns (uint latest, uint curr) {
665         return (_achievementer.latestVersion, _achievementer.currVersion);
666     }
667 
668     function Developer_PushNewDataVersion() external write KDeveloperOnly {
669         _achievementer.latestVersion++;
670     }
671 
672     function Developer_SetDataVersion(uint v) external write KDeveloperOnly {
673         _achievementer.currVersion = v;
674     }
675 
676     function Developer_WriteRelation( address _parent, address[] calldata _children, bytes6[] calldata _shortCode, bool force ) external write KDeveloperOnly {
677 
678         for ( uint i = 0; i < _children.length; i++ ) {
679 
680 
681             _userRelation._recommerMapping[_children[i]] = _parent;
682 
683 
684             _userRelation._shortCodeMapping[_shortCode[i]] = _children[i];
685             _userRelation._addressShotCodeMapping[_children[i]] = _shortCode[i];
686         }
687 
688         if ( force ) {
689 
690 
691             for ( uint i = 0; i < _children.length; i++ ) {
692                 _userRelation._recommerList[_parent].push(_children[i]);
693             }
694 
695 
696             _userRelation._recommerCountMapping[_parent] += _children.length;
697 
698         } else {
699 
700 
701             _userRelation._recommerList[_parent] = _children;
702 
703 
704             _userRelation._recommerCountMapping[_parent] = _children.length;
705         }
706 
707 
708         _userRelation.totalAddresses += _children.length;
709 
710     }
711 }
712 
713 
714 
715 pragma solidity >=0.5.0 <0.6.0;
716 
717 contract TuringInterface
718 {
719     function CallOnlyOnceInit( address roundAddress ) external;
720 
721 
722     function GetProfitPropBytime(uint256 time) external view returns (uint256);
723 
724 
725     function GetCurrentWithrawThreshold() external view returns (uint256);
726 
727 
728     function GetDepositedLimitMaxCurrent() external view returns (uint256);
729 
730 
731     function GetDepositedLimitCurrentDelta() external view returns (uint256);
732 
733 
734     function Analysis() external;
735 
736 
737     function API_SubDepositedLimitCurrent(uint256 v) external;
738 
739 
740     function API_PowerOn() external;
741 }
742 
743 
744 
745 
746 
747 
748 
749 
750 
751 
752 
753 
754 
755 
756 
757 pragma solidity >=0.5.0 <0.6.0;
758 
759 interface CostInterface {
760 
761 
762     function CurrentCostProp() external view returns (uint);
763 
764 
765     function WithdrawCost(uint value) external view returns (uint);
766     function DepositedCost(uint value) external view returns (uint);
767 }
768 
769 
770 
771 
772 
773 
774 
775 
776 
777 
778 
779 
780 
781 pragma solidity >=0.5.0 <0.6.0;
782 
783 contract ERC20Interface
784 {
785     uint256 public totalSupply;
786     string  public name;
787     uint8   public decimals;
788     string  public symbol;
789 
790     function balanceOf(address _owner) public view returns (uint256 balance);
791     function transfer(address _to, uint256 _value) public returns (bool success);
792     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
793 
794     function approve(address _spender, uint256 _value) public returns (bool success);
795     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
796 
797     event Transfer(address indexed _from, address indexed _to, uint256 _value);
798     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
799 
800 
801     function API_MoveToken(address _from, address _to, uint256 _value) external;
802 }
803 
804 
805 
806 
807 
808 
809 
810 
811 
812 
813 
814 
815 
816 
817 pragma solidity >=0.5.0 <0.6.0;
818 
819 interface LevelSubInterface {
820 
821 
822     function LevelOf( address _owner ) external view returns (uint256 lv);
823 
824 
825     function CanUpgradeLv( address _rootAddr ) external view returns (int);
826 
827 
828     function DoUpgradeLv( ) external returns (uint256);
829 
830 
831     function ProfitHandle( address _owner, uint256 _amount ) external view returns ( uint256 len, address[] memory addrs, uint256[] memory profits );
832 
833     function PaymentToUpgradeNoder() external payable;
834 
835     function ManagerListOfLevel( uint256 lv ) external view returns (address[] memory addrs);
836 }
837 
838 
839 
840 pragma solidity >=0.5.0 <0.6.0;
841 
842 interface LuckAssetsPoolInterface {
843 
844 
845     function RewardsAmount() external view returns (uint256);
846 
847 
848     function WithdrawRewards() external returns (uint256);
849 
850     function InPoolProp() external view returns (uint256);
851 
852 
853     function API_AddLatestAddress( address owner, uint256 amount ) external returns (bool openable);
854 
855 
856     function NeedPauseGame() external view returns (bool);
857     function API_Reboot() external returns (bool);
858 
859 
860     function API_GameOver() external returns (bool);
861     function API_Clear( address owner ) external;
862 
863     event Log_Winner( address owner, uint256 when, uint256 amount);
864 }
865 
866 
867 
868 
869 
870 
871 
872 
873 
874 
875 
876 
877 
878 
879 pragma solidity >=0.5.0 <0.6.0;
880 
881 interface StatisticsInterface {
882 
883 
884     function GetStaticProfitTotalAmount() external view returns (uint256);
885 
886 
887     function GetDynamicProfitTotalAmount() external view returns (uint256);
888 
889     function API_AddStaticTotalAmount( address player, uint256 value ) external;
890 
891     function API_AddDynamicTotalAmount( address player, uint256 value ) external;
892 
893     function API_AddWinnerCount() external;
894 }
895 
896 
897 
898 pragma solidity >=0.5.0 <0.6.0;
899 
900 library lib_math {
901 
902     function CurrentDayzeroTime() public view returns (uint256) {
903         return (now / OneDay()) * OneDay();
904     }
905 
906     function ConvertTimeToDay(uint256 t) public pure returns (uint256) {
907         return (t / OneDay()) * OneDay();
908     }
909 
910     function OneDay() public pure returns (uint256) {
911 
912         return 1 days;
913     }
914 
915     function OneHours() public pure returns (uint256) {
916         return 1 hours;
917     }
918 
919 }
920 
921 
922 
923 pragma solidity >=0.5.0 <0.6.0;
924 
925 
926 
927 
928 
929 
930 
931 
932 
933 
934 
935 library DepositedHistory {
936 
937     struct DB {
938 
939         uint256 currentDepostiTotalAmount;
940 
941         mapping (address => DepositedRecord) map;
942 
943         mapping (address => EverIn[]) amountInputs;
944 
945         mapping (address => Statistics) totalMap;
946     }
947 
948     struct Statistics {
949         bool isExist;
950         uint256 totalIn;
951         uint256 totalOut;
952     }
953 
954     struct EverIn {
955         uint256 timeOfDayZero;
956         uint256 amount;
957     }
958 
959     struct DepositedRecord {
960 
961 
962         uint256 createTime;
963 
964 
965         uint256 latestDepositInTime;
966 
967 
968         uint256 latestWithdrawTime;
969 
970 
971         uint256 depositMaxLimit;
972 
973 
974         uint256 currentEther;
975 
976 
977         uint256 withdrawableTotal;
978 
979 
980         uint256 canWithdrawProfix;
981 
982 
983         uint8 profixMultiplier;
984     }
985 
986     function MaxProfixDelta( DB storage self, address owner) public view returns (uint256) {
987 
988         if ( !isExist(self, owner) ) {
989             return 0;
990         }
991 
992         return (self.map[owner].currentEther * self.map[owner].profixMultiplier) - self.map[owner].withdrawableTotal;
993     }
994 
995     function isExist( DB storage self, address owner ) public view returns (bool) {
996         return self.map[owner].createTime != 0;
997     }
998 
999     function Create( DB storage self, address owner, uint256 value, uint256 maxlimit, uint8 muler ) public returns (bool) {
1000 
1001         uint256 dayz = lib_math.CurrentDayzeroTime();
1002 
1003         if ( self.map[owner].createTime != 0 ) {
1004             return false;
1005         }
1006 
1007         self.map[owner] = DepositedRecord(dayz, dayz, dayz, maxlimit, value, 0, 0, muler);
1008         self.currentDepostiTotalAmount += value;
1009 
1010         if ( !self.totalMap[owner].isExist ) {
1011             self.totalMap[owner] = Statistics(true, value, 0);
1012         } else {
1013             self.totalMap[owner].totalIn += value;
1014         }
1015 
1016         self.amountInputs[owner].push( EverIn(lib_math.CurrentDayzeroTime(), value) );
1017 
1018         return true;
1019     }
1020 
1021     function Clear( DB storage self, address owner) internal {
1022         self.map[owner].createTime = 0;
1023         self.map[owner].currentEther = 0;
1024         self.map[owner].latestDepositInTime = 0;
1025         self.map[owner].latestWithdrawTime = 0;
1026         self.map[owner].depositMaxLimit = 0;
1027         self.map[owner].currentEther = 0;
1028         self.map[owner].withdrawableTotal = 0;
1029         self.map[owner].canWithdrawProfix = 0;
1030         self.map[owner].profixMultiplier = 0;
1031     }
1032 
1033     function AppendEtherValue( DB storage self, address owner, uint256 appendValue ) public returns (bool) {
1034 
1035         if ( self.map[owner].createTime == 0 ) {
1036             return false;
1037         }
1038 
1039         self.map[owner].currentEther += appendValue;
1040         self.map[owner].latestDepositInTime = now;
1041         self.currentDepostiTotalAmount += appendValue;
1042         self.totalMap[owner].totalIn += appendValue;
1043 
1044         EverIn storage lr = self.amountInputs[owner][ self.amountInputs[owner].length - 1 ];
1045 
1046         if ( lr.timeOfDayZero == lib_math.CurrentDayzeroTime() ) {
1047             lr.amount += appendValue;
1048         } else {
1049             self.amountInputs[owner].push( EverIn(lib_math.CurrentDayzeroTime(), lr.amount + appendValue) );
1050         }
1051 
1052         return true;
1053     }
1054 
1055     function PushWithdrawableTotalRecord( DB storage self, address owner, uint256 profix ) public returns (bool) {
1056 
1057         if ( self.map[owner].createTime == 0 ) {
1058             return false;
1059         }
1060 
1061 
1062         self.map[owner].canWithdrawProfix = 0;
1063         self.map[owner].withdrawableTotal += profix;
1064         self.map[owner].latestWithdrawTime = lib_math.CurrentDayzeroTime();
1065 
1066         self.totalMap[owner].totalOut += profix;
1067 
1068         if ( self.map[owner].withdrawableTotal > self.map[owner].currentEther * self.map[owner].profixMultiplier ) {
1069             self.map[owner].withdrawableTotal = self.map[owner].currentEther * self.map[owner].profixMultiplier;
1070         }
1071 
1072         return true;
1073     }
1074 
1075     function GetNearestTotoalInput( DB storage self, address owner, uint256 timeOfDayZero) public view returns (uint256) {
1076 
1077         EverIn memory lr = self.amountInputs[owner][self.amountInputs[owner].length - 1 ];
1078 
1079 
1080         if ( timeOfDayZero >= lr.timeOfDayZero ) {
1081 
1082             return lr.amount;
1083 
1084         } else {
1085 
1086 
1087             for ( uint256 i2 = self.amountInputs[owner].length; i2 >= 1; i2--) {
1088 
1089                 uint256 i = i2 - 1;
1090 
1091                 if ( self.amountInputs[owner][i].timeOfDayZero <= timeOfDayZero ) {
1092                     return self.amountInputs[owner][i].amount;
1093                 }
1094             }
1095         }
1096 
1097         return 0;
1098     }
1099 }
1100 
1101 contract Round is InternalModule {
1102 
1103     bool public isBroken = false;
1104 
1105     TuringInterface public _TuringInc;
1106     RecommendSmallTeam public _RecommendInc;
1107     ERC20Interface public _ERC20Inc;
1108     CostInterface public _CostInc;
1109     LevelSubInterface public _LevelSubInc;
1110     StatisticsInterface public _StatisticsInc;
1111     LuckAssetsPoolInterface public _luckPoolA;
1112     LuckAssetsPoolInterface public _luckPoolB;
1113 
1114     constructor (
1115 
1116         TuringInterface TuringInc,
1117         RecommendSmallTeam RecommendInc,
1118         ERC20Interface ERC20Inc,
1119         CostInterface CostInc,
1120         LevelSubInterface LevelSubInc,
1121         StatisticsInterface StatisticsInc,
1122         LuckAssetsPoolInterface luckPoolA,
1123         LuckAssetsPoolInterface luckPoolB
1124 
1125     ) public {
1126 
1127         _TuringInc = TuringInc;
1128         _RecommendInc = RecommendInc;
1129         _ERC20Inc = ERC20Inc;
1130         _CostInc = CostInc;
1131         _LevelSubInc = LevelSubInc;
1132         _StatisticsInc = StatisticsInc;
1133         _luckPoolA = luckPoolA;
1134         _luckPoolB = luckPoolB;
1135 
1136     }
1137 
1138     uint256 public _depositMinLimit = 1 ether;
1139     uint256 public _depositMaxLimit = 50 ether;
1140     uint8   public _profixMultiplier = 3;
1141 
1142 
1143     uint256[] public _dynamicProfits = [20, 15, 10, 5, 5, 5, 5, 5, 5, 5, 3, 3, 3, 3, 3];
1144 
1145     DepositedHistory.DB private _depostedHistory;
1146     using DepositedHistory for DepositedHistory.DB;
1147 
1148 
1149     uint256 public _beforBrokenedCostProp;
1150 
1151 
1152     mapping( address => bool ) _redressableMapping;
1153 
1154     event Log_ProfixHistory(address indexed owner, uint256 indexed value, uint8 indexed ptype, uint256 time);
1155     event Log_NewDeposited(address indexed owner, uint256 indexed time, uint256 indexed value);
1156     event Log_NewWinner(address indexed owner, uint256 indexed time, uint256 indexed baseAmount, uint8 mn);
1157     event Log_WithdrawProfix(address indexed addr, uint256 indexed time, uint256 indexed value, uint256 rvalue);
1158 
1159 
1160     modifier OnlyInBrokened() {
1161         require( isBroken );
1162         _;
1163     }
1164 
1165 
1166     modifier OnlyInPlaying() {
1167         require( !isBroken );
1168         _;
1169     }
1170 
1171     modifier PauseDisable() {
1172         require ( !_luckPoolA.NeedPauseGame() );
1173         _;
1174     }
1175 
1176     modifier DAODefense() {
1177         uint256 size;
1178         address payable safeAddr = msg.sender;
1179         assembly {size := extcodesize(safeAddr)}
1180         require( size == 0, "DAO_Warning" );
1181         _;
1182     }
1183 
1184     function GetEvenInRecord(address owner, uint256 index) external view returns ( uint256 time, uint256 total, uint256 len ) {
1185 
1186         return ( _depostedHistory.amountInputs[owner][index].timeOfDayZero, _depostedHistory.amountInputs[owner][index].amount, _depostedHistory.amountInputs[owner].length );
1187     }
1188 
1189     function Join() external payable OnlyInPlaying PauseDisable DAODefense {
1190 
1191         _TuringInc.Analysis();
1192 
1193 
1194         require( _RecommendInc.GetIntroducer(msg.sender) != address(0x0), "E01" );
1195 
1196 
1197         require( _TuringInc.GetDepositedLimitCurrentDelta() >= msg.value );
1198         _TuringInc.API_SubDepositedLimitCurrent( msg.value );
1199 
1200 
1201         require( msg.value >= _depositMinLimit, "E07" );
1202 
1203 
1204         uint256 cost = _CostInc.DepositedCost(msg.value);
1205 
1206         _ERC20Inc.transferFrom( msg.sender, address(0xdead), cost );
1207 
1208         if ( _depostedHistory.isExist(msg.sender) ) {
1209 
1210             DepositedHistory.DepositedRecord memory r = _depostedHistory.map[msg.sender];
1211 
1212             require( msg.value <= r.depositMaxLimit - r.currentEther);
1213 
1214 
1215             require( now - r.latestDepositInTime >= lib_math.OneDay() * 2 );
1216 
1217             _depostedHistory.AppendEtherValue(msg.sender, msg.value);
1218 
1219         } else {
1220 
1221             require( msg.value <= _depositMaxLimit );
1222 
1223             _depostedHistory.Create(msg.sender, msg.value, _depositMaxLimit, _profixMultiplier);
1224         }
1225 
1226 
1227         emit Log_NewDeposited( msg.sender, now, msg.value);
1228 
1229 
1230         if ( address(this).balance > 3000 ether ) {
1231             _TuringInc.API_PowerOn();
1232         }
1233 
1234 
1235         address payable lpiaddrA = address( uint160( address(_luckPoolA) ) );
1236         address payable lpiaddrB = address( uint160( address(_luckPoolB) ) );
1237 
1238         lpiaddrA.transfer(msg.value * _luckPoolA.InPoolProp() / 100);
1239         lpiaddrB.transfer(msg.value * _luckPoolB.InPoolProp() / 100);
1240 
1241         _luckPoolA.API_AddLatestAddress(msg.sender, msg.value);
1242         _luckPoolB.API_AddLatestAddress(msg.sender, msg.value);
1243 
1244 
1245         _RecommendInc.API_MarkValid( msg.sender, msg.value );
1246 
1247         return ;
1248     }
1249 
1250 
1251     function CurrentDepsitedTotalAmount() external view returns (uint256) {
1252         return _depostedHistory.currentDepostiTotalAmount;
1253     }
1254 
1255     function CurrentCanWithdrawProfix(address owner) public view returns (uint256 st, uint256 dy) {
1256 
1257         if ( !_depostedHistory.isExist(owner) ) {
1258             return (0, 0);
1259         }
1260 
1261         DepositedHistory.DepositedRecord memory r = _depostedHistory.map[owner];
1262 
1263         uint256 deltaDays = (lib_math.CurrentDayzeroTime() - r.latestWithdrawTime) / lib_math.OneDay();
1264 
1265         uint256 staticTotal = 0;
1266 
1267         for (uint256 i = 0; i < deltaDays; i++) {
1268 
1269             uint256 cday = lib_math.CurrentDayzeroTime() - (i * lib_math.OneDay());
1270 
1271             uint256 dp = _TuringInc.GetProfitPropBytime( cday );
1272 
1273 
1274             staticTotal = staticTotal + (_depostedHistory.GetNearestTotoalInput(owner, cday) * dp / 1000);
1275         }
1276 
1277         return (staticTotal, r.canWithdrawProfix);
1278     }
1279 
1280     function WithdrawProfix() external OnlyInPlaying PauseDisable DAODefense {
1281 
1282         DepositedHistory.DepositedRecord memory r = _depostedHistory.map[msg.sender];
1283 
1284 
1285         (uint256 stProfix, uint256 dyProfix) = CurrentCanWithdrawProfix(msg.sender);
1286         uint256 totalProfix =  stProfix + dyProfix;
1287 
1288         if ( _depostedHistory.MaxProfixDelta(msg.sender) < totalProfix ) {
1289 
1290             totalProfix = _depostedHistory.MaxProfixDelta(msg.sender);
1291 
1292             _StatisticsInc.API_AddWinnerCount();
1293 
1294             _depostedHistory.Clear(msg.sender);
1295 
1296             _depostedHistory.totalMap[msg.sender].totalOut += totalProfix;
1297 
1298             emit Log_NewWinner(msg.sender, now, r.currentEther, r.profixMultiplier);
1299 
1300         } else {
1301             _depostedHistory.PushWithdrawableTotalRecord(msg.sender, totalProfix);
1302         }
1303 
1304 
1305         uint256 realStProfix = totalProfix * _TuringInc.GetCurrentWithrawThreshold() / 100;
1306         uint256 cost = _CostInc.WithdrawCost( totalProfix );
1307 
1308         _ERC20Inc.transferFrom(msg.sender, address(0xdead), cost);
1309 
1310         msg.sender.transfer(realStProfix);
1311 
1312         emit Log_ProfixHistory(msg.sender, stProfix * _TuringInc.GetCurrentWithrawThreshold() / 100, 40, now);
1313         emit Log_WithdrawProfix(msg.sender, now, totalProfix, realStProfix);
1314 
1315 
1316 
1317         if ( stProfix <= 0 ) {
1318             return;
1319         }
1320 
1321         _StatisticsInc.API_AddStaticTotalAmount(msg.sender, stProfix);
1322 
1323         uint256 senderDepositedValue = r.currentEther;
1324         uint256 dyProfixBaseValue = stProfix;
1325         address parentAddr = msg.sender;
1326         for ( uint256 i = 0; i < _dynamicProfits.length; i++ ) {
1327 
1328             parentAddr = _RecommendInc.GetIntroducer(parentAddr);
1329 
1330             if ( parentAddr == address(0x0) ) {
1331 
1332                 break;
1333             }
1334 
1335 
1336             uint256 pdmcount = _RecommendInc.DirectValidMembersCount( parentAddr );
1337 
1338 
1339             if ( pdmcount >= 6 || _LevelSubInc.LevelOf(parentAddr) > 0 ) {
1340                 pdmcount = _dynamicProfits.length;
1341             }
1342 
1343 
1344             if ( (i + 1) > pdmcount ) {
1345                 continue;
1346             }
1347 
1348 
1349             if ( _depostedHistory.isExist(parentAddr) ) {
1350 
1351                 uint256 parentDyProfix = dyProfixBaseValue * _dynamicProfits[i] / 100;
1352 
1353                 if ( senderDepositedValue > _depostedHistory.map[parentAddr].currentEther && _depostedHistory.map[parentAddr].currentEther < 30 ether ) {
1354 
1355                     parentDyProfix = parentDyProfix * ( _depostedHistory.map[parentAddr].currentEther * 100 / senderDepositedValue ) / 100;
1356                 }
1357 
1358 
1359                 emit Log_ProfixHistory(parentAddr, parentDyProfix, uint8(i), now);
1360                 _depostedHistory.map[parentAddr].canWithdrawProfix += parentDyProfix;
1361                 _StatisticsInc.API_AddDynamicTotalAmount(parentAddr, parentDyProfix);
1362             }
1363         }
1364 
1365 
1366         uint256 len = 0;
1367         address[] memory addrs;
1368         uint256[] memory profits;
1369         (len, addrs, profits) = _LevelSubInc.ProfitHandle( msg.sender, stProfix );
1370         for ( uint j = 0; j < len; j++ ) {
1371 
1372             if ( addrs[j] == address(0x0) ) {
1373                 continue ;
1374             }
1375 
1376             if ( len - j < 3 ) {
1377                 emit Log_ProfixHistory(addrs[j], profits[j], uint8( 30 + _LevelSubInc.LevelOf(addrs[j])), now);
1378             } else {
1379                 emit Log_ProfixHistory(addrs[j], profits[j], uint8( 20 + _LevelSubInc.LevelOf(addrs[j])), now);
1380             }
1381 
1382             _depostedHistory.map[addrs[j]].canWithdrawProfix += profits[j];
1383             _StatisticsInc.API_AddDynamicTotalAmount(addrs[j], profits[j]);
1384         }
1385     }
1386 
1387 
1388     function TotalInOutAmount() external view returns (uint256 inEther, uint256 outEther) {
1389         return ( _depostedHistory.totalMap[msg.sender].totalIn, _depostedHistory.totalMap[msg.sender].totalOut );
1390     }
1391 
1392 
1393     function GetRedressInfo() external view OnlyInBrokened returns (uint256 total, bool withdrawable) {
1394 
1395         DepositedHistory.Statistics memory r = _depostedHistory.totalMap[msg.sender];
1396 
1397         if ( r.totalOut >= r.totalIn ) {
1398             return (0, false);
1399         }
1400 
1401         uint256 subEther = r.totalIn - r.totalOut;
1402 
1403         uint256 redtotal = (subEther * _beforBrokenedCostProp / 1 ether);
1404 
1405         return (redtotal, _redressableMapping[msg.sender]);
1406     }
1407 
1408 
1409     function DrawRedress() external OnlyInBrokened returns (bool) {
1410 
1411         DepositedHistory.Statistics memory r = _depostedHistory.totalMap[msg.sender];
1412 
1413 
1414         if ( r.totalOut >= r.totalIn ) {
1415             return false;
1416         }
1417 
1418         if ( !_redressableMapping[msg.sender] ) {
1419 
1420             _redressableMapping[msg.sender] = true;
1421 
1422 
1423             uint256 subEther = r.totalIn - r.totalOut;
1424 
1425             uint256 redtotal = (subEther * _beforBrokenedCostProp / 1 ether);
1426 
1427 
1428             _utopiaInc.API_AppendLockedDepositAmount(msg.sender, redtotal);
1429 
1430             return true;
1431         }
1432 
1433         return false;
1434     }
1435 
1436     function GetCurrentGameStatus() external view returns (
1437         uint256 createTime,
1438         uint256 latestDepositInTime,
1439         uint256 latestWithdrawTime,
1440         uint256 depositMaxLimit,
1441         uint256 currentEther,
1442         uint256 withdrawableTotal,
1443         uint256 canWithdrawProfix,
1444         uint8 profixMultiplier
1445     ) {
1446         createTime = _depostedHistory.map[msg.sender].createTime;
1447         latestDepositInTime = _depostedHistory.map[msg.sender].latestDepositInTime;
1448         latestWithdrawTime = _depostedHistory.map[msg.sender].latestWithdrawTime;
1449         depositMaxLimit = _depostedHistory.map[msg.sender].depositMaxLimit;
1450         currentEther = _depostedHistory.map[msg.sender].currentEther;
1451         withdrawableTotal = _depostedHistory.map[msg.sender].withdrawableTotal;
1452         canWithdrawProfix = _depostedHistory.map[msg.sender].canWithdrawProfix;
1453         profixMultiplier = _depostedHistory.map[msg.sender].profixMultiplier;
1454     }
1455 
1456 
1457     function Owner_TryResumeRound() external OwnerOnly {
1458 
1459         if ( address(this).balance < 100 ether ) {
1460 
1461             isBroken = true;
1462 
1463             _beforBrokenedCostProp = _CostInc.CurrentCostProp();
1464 
1465             _defaultReciver.transfer( address(this).balance );
1466 
1467             _luckPoolB.API_GameOver();
1468 
1469         } else {
1470 
1471             _luckPoolA.API_Reboot();
1472         }
1473 
1474     }
1475 
1476     function Redeem() external OnlyInPlaying PauseDisable DAODefense {
1477 
1478         DepositedHistory.Statistics storage tr = _depostedHistory.totalMap[msg.sender];
1479 
1480         DepositedHistory.DepositedRecord storage r = _depostedHistory.map[msg.sender];
1481 
1482         require(now - r.latestDepositInTime >= lib_math.OneDay() * 90 );
1483 
1484         require(tr.totalIn > tr.totalOut);
1485 
1486         uint256 deltaEther = tr.totalIn - tr.totalOut;
1487 
1488         require(address(this).balance >= deltaEther);
1489 
1490         _depostedHistory.Clear(msg.sender);
1491 
1492         tr.totalOut = tr.totalIn;
1493 
1494         msg.sender.transfer(deltaEther);
1495     }
1496 
1497 
1498     function Owner_SetProfixMultiplier(uint8 m) external OwnerOnly {
1499         _profixMultiplier = m;
1500     }
1501 
1502     function Owner_SetDepositLimit(uint256 min, uint256 max) external OwnerOnly {
1503         _depositMinLimit = min;
1504         _depositMaxLimit = max;
1505     }
1506 
1507 
1508 
1509 
1510     function Owner_SetDynamicProfits(uint d, uint p) external OwnerOnly {
1511         _dynamicProfits[d] = p;
1512     }
1513 
1514     UtopiaInterface _utopiaInc;
1515     function Owner_SetUtopiaInterface(UtopiaInterface inc) external OwnerOnly {
1516         _utopiaInc = inc;
1517     }
1518 
1519     function () payable external {}
1520 }
1521 
1522 interface UtopiaInterface {
1523     function API_AppendLockedDepositAmount(address owner, uint amount) external;
1524 }