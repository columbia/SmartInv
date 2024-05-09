1 pragma solidity ^0.4.24;
2 
3 
4 
5 contract Base
6 {
7     uint8 constant HEROLEVEL_MIN = 1;
8     uint8 constant HEROLEVEL_MAX = 5;
9 
10     uint8 constant LIMITCHIP_MINLEVEL = 3;
11     uint constant PARTWEIGHT_NORMAL = 100;
12     uint constant PARTWEIGHT_LIMIT = 40;
13 
14     address creator;
15 
16     constructor() public
17     {
18         creator = msg.sender;
19     }
20 
21     modifier MasterAble()
22     {
23         require(msg.sender == creator);
24         _;
25     }
26 
27     function IsLimitPart(uint8 level, uint part) internal pure returns(bool)
28     {
29         if (level < LIMITCHIP_MINLEVEL) return false;
30         if (part < GetPartNum(level)) return false;
31         return true;
32     }
33 
34     function GetPartWeight(uint8 level, uint part) internal pure returns(uint)
35     {
36         if (IsLimitPart(level, part)) return PARTWEIGHT_LIMIT;
37         return PARTWEIGHT_NORMAL;
38     }
39     
40     function GetPartNum(uint8 level) internal pure returns(uint)
41     {
42         if (level <= 2) return 3;
43         else if (level <= 4) return 4;
44         return 5;
45     }
46 
47 }
48 
49 contract BasicTime
50 {
51     uint constant DAY_SECONDS = 60 * 60 * 24;
52 
53     function GetDayCount(uint timestamp) pure internal returns(uint)
54     {
55         return timestamp/DAY_SECONDS;
56     }
57 
58     function GetExpireTime(uint timestamp, uint dayCnt) pure internal returns(uint)
59     {
60         uint dayEnd = GetDayCount(timestamp) + dayCnt;
61         return dayEnd * DAY_SECONDS;
62     }
63 
64 }
65 
66 contract BasicAuth is Base
67 {
68 
69     address master;
70     mapping(address => bool) auth_list;
71 
72     function InitMaster(address acc) internal
73     {
74         require(address(0) != acc);
75         master = acc;
76     }
77 
78     modifier MasterAble()
79     {
80         require(msg.sender == creator || msg.sender == master);
81         _;
82     }
83 
84     modifier OwnerAble(address acc)
85     {
86         require(acc == tx.origin);
87         _;
88     }
89 
90     modifier AuthAble()
91     {
92         require(auth_list[msg.sender]);
93         _;
94     }
95 
96     function CanHandleAuth(address from) internal view returns(bool)
97     {
98         return from == creator || from == master;
99     }
100     
101     function SetAuth(address target) external
102     {
103         require(CanHandleAuth(tx.origin) || CanHandleAuth(msg.sender));
104         auth_list[target] = true;
105     }
106 
107     function ClearAuth(address target) external
108     {
109         require(CanHandleAuth(tx.origin) || CanHandleAuth(msg.sender));
110         delete auth_list[target];
111     }
112 
113 }
114 
115 
116 
117 
118 library IndexList
119 {
120     function insert(uint32[] storage self, uint32 index, uint pos) external
121     {
122         require(self.length >= pos);
123         self.length++;
124         for (uint i=self.length; i>pos; i++)
125         {
126             self[i+1] = self[i];
127         }
128         self[pos] = index;
129     }
130 
131     function remove(uint32[] storage self, uint32 index) external returns(bool)
132     {
133         return remove(self,index,0);
134     }
135 
136     function remove(uint32[] storage self, uint32 index, uint startPos) public returns(bool)
137     {
138         for (uint i=startPos; i<self.length; i++)
139         {
140             if (self[i] != index) continue;
141             for (uint j=i; j<self.length-1; j++)
142             {
143                 self[j] = self[j+1];
144             }
145             delete self[self.length-1];
146             self.length--;
147             return true;
148         }
149         return false;
150     }
151 
152 }
153 
154 library ItemList {
155 
156     using IndexList for uint32[];
157     
158     struct Data {
159         uint32[] m_List;
160         mapping(uint32 => uint) m_Maps;
161     }
162 
163     function _insert(Data storage self, uint32 key, uint val) internal
164     {
165         self.m_List.push(key);
166         self.m_Maps[key] = val;
167     }
168 
169     function _delete(Data storage self, uint32 key) internal
170     {
171         self.m_List.remove(key);
172         delete self.m_Maps[key];
173     }
174 
175     function set(Data storage self, uint32 key, uint num) public
176     {
177         if (!has(self,key)) {
178             if (num == 0) return;
179             _insert(self,key,num);
180         }
181         else if (num == 0) {
182             _delete(self,key);
183         } 
184         else {
185             uint old = self.m_Maps[key];
186             if (old == num) return;
187             self.m_Maps[key] = num;
188         }
189     }
190 
191     function add(Data storage self, uint32 key, uint num) external
192     {
193         uint iOld = get(self,key);
194         uint iNow = iOld+num;
195         require(iNow >= iOld);
196         set(self,key,iNow);
197     }
198 
199     function sub(Data storage self, uint32 key, uint num) external
200     {
201         uint iOld = get(self,key);
202         require(iOld >= num);
203         set(self,key,iOld-num);
204     }
205 
206     function has(Data storage self, uint32 key) public view returns(bool)
207     {
208         return self.m_Maps[key] > 0;
209     }
210 
211     function get(Data storage self, uint32 key) public view returns(uint)
212     {
213         return self.m_Maps[key];
214     }
215 
216     function list(Data storage self) view external returns(uint32[],uint[])
217     {
218         uint len = self.m_List.length;
219         uint[] memory values = new uint[](len);
220         for (uint i=0; i<len; i++)
221         {
222             uint32 key = self.m_List[i];
223             values[i] = self.m_Maps[key];
224         }
225         return (self.m_List,values);
226     }
227 
228     function isEmpty(Data storage self) view external returns(bool)
229     {
230         return self.m_List.length == 0;
231     }
232 
233     function keys(Data storage self) view external returns(uint32[])
234     {
235         return self.m_List;
236     }
237 
238 }
239 
240 
241 
242 
243 contract MainBase is Base 
244 {
245     modifier ValidLevel(uint8 level)
246     {
247         require(level<=HEROLEVEL_MAX && level>=HEROLEVEL_MIN);
248         _;
249     }
250 
251     modifier ValidParts(uint8 level, uint32[] parts)
252     {
253         require(GetPartNum(level) == parts.length);
254         _;
255     }
256 
257     modifier ValidPart(uint8 level, uint part)
258     {
259         require(part > 0);
260         require(GetPartNum(level) >= part);
261         _;
262     }
263 
264 }
265 
266 
267 
268 
269 contract MainCard is BasicAuth,MainBase
270 {
271     struct Card {
272         uint32 m_Index;
273         uint32 m_Duration;
274         uint8 m_Level;
275         uint16 m_DP;  //DynamicProfit
276         uint16 m_DPK; //K is coefficient
277         uint16 m_SP;  //StaticProfit
278         uint16 m_IP;  //ImmediateProfit
279         uint32[] m_Parts;
280     }
281 
282     struct CardLib {
283         uint32[] m_List;
284         mapping(uint32 => Card) m_Lib;
285     }
286 
287     CardLib g_CardLib;
288 
289     function AddNewCard(uint32 iCard, uint32 duration, uint8 level, uint16 dp, uint16 dpk, uint16 sp, uint16 ip, uint32[] parts) external MasterAble ValidLevel(level) ValidParts(level,parts)
290     {
291         require(!CardExists(iCard));
292         g_CardLib.m_List.push(iCard);
293         g_CardLib.m_Lib[iCard] = Card({
294             m_Index   : iCard,
295             m_Duration: duration,
296             m_Level   : level,
297             m_DP      : dp,
298             m_DPK     : dpk,
299             m_SP      : sp,
300             m_IP      : ip,
301             m_Parts   : parts
302         });
303     }
304 
305     function CardExists(uint32 iCard) public view returns(bool)
306     {
307         Card storage obj = g_CardLib.m_Lib[iCard];
308         return obj.m_Index == iCard;
309     }
310 
311     function GetCard(uint32 iCard) internal view returns(Card storage)
312     {
313         return g_CardLib.m_Lib[iCard];
314     }
315 
316     function GetCardInfo(uint32 iCard) external view returns(uint32, uint32, uint8, uint16, uint16, uint16, uint16, uint32[])
317     {
318         Card storage obj = GetCard(iCard);
319         return (obj.m_Index, obj.m_Duration, obj.m_Level, obj.m_DP, obj.m_DPK, obj.m_SP, obj.m_IP, obj.m_Parts);
320     }
321 
322     function GetExistsCardList() external view returns(uint32[])
323     {
324         return g_CardLib.m_List;
325     }
326 
327 }
328 
329 
330 
331 
332 contract MainChip is BasicAuth,MainBase
333 {
334     using IndexList for uint32[];
335 
336     struct Chip
337     {
338         uint8 m_Level;
339         uint8 m_LimitNum;
340         uint8 m_Part;
341         uint32 m_Index;
342         uint256 m_UsedNum;
343     }
344 
345     struct PartManager
346     {
347         uint32[] m_IndexList;   //index list, player can obtain
348         uint32[] m_UnableList;  //player can't obtain
349     }
350 
351     struct ChipLib
352     {
353         uint32[] m_List;
354         mapping(uint32 => Chip) m_Lib;
355         mapping(uint32 => uint[]) m_TempList;
356         mapping(uint8 => mapping(uint => PartManager)) m_PartMap;//level -> level list
357     }
358 
359     ChipLib g_ChipLib;
360 
361     function AddNewChip(uint32 iChip, uint8 lv, uint8 limit, uint8 part) external MasterAble ValidLevel(lv) ValidPart(lv,part)
362     {
363         require(!ChipExists(iChip));
364         g_ChipLib.m_List.push(iChip);
365         g_ChipLib.m_Lib[iChip] = Chip({
366             m_Index       : iChip,
367             m_Level       : lv,
368             m_LimitNum    : limit,
369             m_Part        : part,
370             m_UsedNum     : 0
371         });
372         PartManager storage pm = GetPartManager(lv,part);
373         pm.m_IndexList.push(iChip);
374     }
375 
376     function GetChip(uint32 iChip) internal view returns(Chip storage)
377     {
378         return g_ChipLib.m_Lib[iChip];
379     }
380 
381     function GetPartManager(uint8 level, uint iPart) internal view returns(PartManager storage)
382     {
383         return g_ChipLib.m_PartMap[level][iPart];
384     }
385 
386     function ChipExists(uint32 iChip) public view returns(bool)
387     {
388         Chip storage obj = GetChip(iChip);
389         return obj.m_Index == iChip;
390     }
391 
392     function GetChipUsedNum(uint32 iChip) internal view returns(uint)
393     {
394         Chip storage obj = GetChip(iChip);
395         uint[] memory tempList = g_ChipLib.m_TempList[iChip];
396         uint num = tempList.length;
397         for (uint i=num; i>0; i--)
398         {
399             if(tempList[i-1]<=now) {
400                 num -= i;
401                 break;
402             }
403         }
404         return obj.m_UsedNum + num;
405     }
406 
407     function CanObtainChip(uint32 iChip) internal view returns(bool)
408     {
409         Chip storage obj = GetChip(iChip);
410         if (obj.m_LimitNum == 0) return true;
411         if (GetChipUsedNum(iChip) < obj.m_LimitNum) return true;
412         return false;
413     }
414 
415     function CostChip(uint32 iChip) internal
416     {
417         BeforeChipCost(iChip);
418         Chip storage obj = GetChip(iChip);
419         obj.m_UsedNum--;
420     }
421 
422     function ObtainChip(uint32 iChip) internal
423     {
424         BeforeChipObtain(iChip);
425         Chip storage obj = GetChip(iChip);
426         obj.m_UsedNum++;
427     }
428 
429     function BeforeChipObtain(uint32 iChip) internal
430     {
431         Chip storage obj = GetChip(iChip);
432         if (obj.m_LimitNum == 0) return;
433         uint usedNum = GetChipUsedNum(iChip);
434         require(obj.m_LimitNum >= usedNum+1);
435         if (obj.m_LimitNum == usedNum+1) {
436             PartManager storage pm = GetPartManager(obj.m_Level,obj.m_Part);
437             if (pm.m_IndexList.remove(iChip)){
438                 pm.m_UnableList.push(iChip);
439             }
440         }
441     }
442 
443     function BeforeChipCost(uint32 iChip) internal
444     {
445         Chip storage obj = GetChip(iChip);
446         if (obj.m_LimitNum == 0) return;
447         uint usedNum = GetChipUsedNum(iChip);
448         require(obj.m_LimitNum >= usedNum);
449         if (obj.m_LimitNum == usedNum) {
450             PartManager storage pm = GetPartManager(obj.m_Level,obj.m_Part);
451             if (pm.m_UnableList.remove(iChip)) {
452                 pm.m_IndexList.push(iChip);
453             }
454         }
455     }
456 
457     function AddChipTempTime(uint32 iChip, uint expireTime) internal
458     {
459         uint[] storage list = g_ChipLib.m_TempList[iChip];
460         require(list.length==0 || expireTime>=list[list.length-1]);
461         BeforeChipObtain(iChip);
462         list.push(expireTime);
463     }
464 
465     function RefreshChipUnableList(uint8 level) internal
466     {
467         uint partNum = GetPartNum(level);
468         for (uint iPart=1; iPart<=partNum; iPart++)
469         {
470             PartManager storage pm = GetPartManager(level,iPart);
471             for (uint i=pm.m_UnableList.length; i>0; i--)
472             {
473                 uint32 iChip = pm.m_UnableList[i-1];
474                 if (CanObtainChip(iChip)) {
475                     pm.m_IndexList.push(iChip);
476                     pm.m_UnableList.remove(iChip,i-1);
477                 }
478             }
479         }
480     }
481 
482     function GenChipByWeight(uint random, uint8 level, uint[] extWeight) internal view returns(uint32)
483     {
484         uint partNum = GetPartNum(level);
485         uint allWeight;
486         uint[] memory newWeight = new uint[](partNum+1);
487         uint[] memory realWeight = new uint[](partNum+1);
488         for (uint iPart=1; iPart<=partNum; iPart++)
489         {
490             PartManager storage pm = GetPartManager(level,iPart);
491             uint curWeight = extWeight[iPart-1]+GetPartWeight(level,iPart);
492             allWeight += pm.m_IndexList.length*curWeight;
493             newWeight[iPart] = allWeight;
494             realWeight[iPart] = curWeight;
495         }
496 
497         uint weight = random % allWeight;
498         for (iPart=1; iPart<=partNum; iPart++)
499         {
500             if (weight >= newWeight[iPart]) continue;
501             pm = GetPartManager(level,iPart);
502             uint idx = (weight-newWeight[iPart-1])/realWeight[iPart];
503             return pm.m_IndexList[idx];
504         }
505     }
506 
507     function GetChipInfo(uint32 iChip) external view returns(uint32, uint8, uint8, uint, uint8, uint)
508     {
509         Chip storage obj = GetChip(iChip);
510         return (obj.m_Index, obj.m_Level, obj.m_LimitNum, GetPartWeight(obj.m_Level,obj.m_Part), obj.m_Part, GetChipUsedNum(iChip));
511     }
512 
513     function GetExistsChipList() external view returns(uint32[])
514     {
515         return g_ChipLib.m_List;
516     }
517 
518 }
519 
520 
521 
522 
523 contract MainBonus is BasicTime,BasicAuth,MainBase,MainCard
524 {
525     uint constant BASERATIO = 10000;
526 
527     struct PlayerBonus
528     {
529         uint m_DrawedDay;
530         uint16 m_DDPermanent;// drawed day permanent
531         mapping(uint => uint16) m_DayStatic;
532         mapping(uint => uint16) m_DayPermanent;
533         mapping(uint => uint32[]) m_DayDynamic;
534     }
535 
536     struct DayRatio
537     {
538         uint16 m_Static;
539         uint16 m_Permanent;
540         uint32[] m_DynamicCard;
541         mapping(uint32 => uint) m_CardNum;
542     }
543 
544     struct BonusData
545     {
546         uint m_RewardBonus;//bonus pool,waiting for withdraw
547         uint m_RecordDay;// recordday
548         uint m_RecordBonus;//recordday bonus , to show
549         uint m_RecordPR;// recordday permanent ratio
550         mapping(uint => DayRatio) m_DayRatio;
551         mapping(uint => uint) m_DayBonus;// day final bonus
552         mapping(address => PlayerBonus) m_PlayerBonus;
553     }
554 
555     BonusData g_Bonus;
556 
557     constructor() public
558     {
559         g_Bonus.m_RecordDay = GetDayCount(now);
560     }
561 
562     function() external payable {}
563 
564     function NeedRefresh(uint dayNo) internal view returns(bool)
565     {
566         if (g_Bonus.m_RecordBonus == 0) return false;
567         if (g_Bonus.m_RecordDay == dayNo) return false;
568         return true;
569     }
570 
571     function PlayerNeedRefresh(address acc, uint dayNo) internal view returns(bool)
572     {
573         if (g_Bonus.m_RecordBonus == 0) return false;
574         PlayerBonus storage pb = g_Bonus.m_PlayerBonus[acc];
575         if (pb.m_DrawedDay == dayNo) return false;
576         return true;
577     }
578 
579     function GetDynamicRatio(uint dayNo) internal view returns(uint tempRatio)
580     {
581         DayRatio storage dr = g_Bonus.m_DayRatio[dayNo];
582         for (uint i=0; i<dr.m_DynamicCard.length; i++)
583         {
584             uint32 iCard = dr.m_DynamicCard[i];
585             uint num = dr.m_CardNum[iCard];
586             Card storage oCard = GetCard(iCard);
587             tempRatio += num*oCard.m_DP*oCard.m_DPK/(oCard.m_DPK+num);
588         }
589     }
590 
591     function GenDayRatio(uint dayNo) internal view returns(uint iDR)
592     {
593         DayRatio storage dr = g_Bonus.m_DayRatio[dayNo];
594         iDR += dr.m_Permanent;
595         iDR += dr.m_Static;
596         iDR += GetDynamicRatio(dayNo);
597     }
598 
599     function GetDynamicCardNum(uint32 iCard, uint dayNo) internal view returns(uint num)
600     {
601         DayRatio storage dr = g_Bonus.m_DayRatio[dayNo];
602         num = dr.m_CardNum[iCard];
603     }
604 
605     function GetPlayerDynamicRatio(address acc, uint dayNo) internal view returns(uint tempRatio)
606     {
607         PlayerBonus storage pb = g_Bonus.m_PlayerBonus[acc];
608         DayRatio storage dr = g_Bonus.m_DayRatio[dayNo];
609         uint32[] storage cards = pb.m_DayDynamic[dayNo];
610         for (uint idx=0; idx<cards.length; idx++)
611         {
612             uint32 iCard = cards[idx];
613             uint num = dr.m_CardNum[iCard];
614             Card storage oCard = GetCard(iCard);
615             tempRatio += oCard.m_DP*oCard.m_DPK/(oCard.m_DPK+num);
616         }
617     }
618 
619     function GenPlayerRatio(address acc, uint dayNo) internal view returns(uint tempRatio)
620     {
621         PlayerBonus storage pb = g_Bonus.m_PlayerBonus[acc];
622         tempRatio += pb.m_DayPermanent[dayNo];
623         tempRatio += pb.m_DayStatic[dayNo];
624         tempRatio += GetPlayerDynamicRatio(acc,dayNo);
625     }
626 
627     function RefreshDayBonus() internal
628     {
629         uint todayNo = GetDayCount(now);
630         if (!NeedRefresh(todayNo)) return;
631 
632         uint tempBonus = g_Bonus.m_RecordBonus;
633         uint tempPR = g_Bonus.m_RecordPR;
634         uint tempRatio;
635         for (uint dayNo=g_Bonus.m_RecordDay; dayNo<todayNo; dayNo++)
636         {
637             tempRatio = tempPR+GenDayRatio(dayNo);
638             if (tempRatio == 0) continue;
639             DayRatio storage dr = g_Bonus.m_DayRatio[dayNo];
640             tempPR += dr.m_Permanent;
641             g_Bonus.m_DayBonus[dayNo] = tempBonus;
642             tempBonus -= tempBonus*tempRatio/BASERATIO;
643         }
644 
645         g_Bonus.m_RecordPR = tempPR;
646         g_Bonus.m_RecordDay = todayNo;
647         g_Bonus.m_RecordBonus = tempBonus;
648     }
649 
650     function QueryPlayerBonus(address acc, uint todayNo) view internal returns(uint accBonus,uint16 accPR)
651     {
652         PlayerBonus storage pb = g_Bonus.m_PlayerBonus[acc];
653         accPR = pb.m_DDPermanent;
654 
655         if (!PlayerNeedRefresh(acc, todayNo)) return;
656 
657         uint tempBonus = g_Bonus.m_RecordBonus;
658         uint tempPR = g_Bonus.m_RecordPR;
659         uint dayNo = pb.m_DrawedDay;
660         if (dayNo == 0) return;
661         for (; dayNo<todayNo; dayNo++)
662         {
663             uint tempRatio = tempPR+GenDayRatio(dayNo);
664             if (tempRatio == 0) continue;
665 
666             uint accRatio = accPR+GenPlayerRatio(acc,dayNo);
667             accPR += pb.m_DayPermanent[dayNo];
668 
669             DayRatio storage dr = g_Bonus.m_DayRatio[dayNo];
670             if (dayNo >= g_Bonus.m_RecordDay) {
671                 tempPR += dr.m_Permanent;
672                 accBonus += tempBonus*accRatio/BASERATIO;
673                 tempBonus -= tempBonus*tempRatio/BASERATIO;
674             }
675             else {
676                 if (accRatio == 0) continue;
677                 accBonus += g_Bonus.m_DayBonus[dayNo]*accRatio/BASERATIO;
678             }
679         }
680     }
681 
682     function GetDynamicCardAmount(uint32 iCard, uint timestamp) external view returns(uint num)
683     {
684         num = GetDynamicCardNum(iCard, GetDayCount(timestamp));
685     }
686 
687     function AddDynamicProfit(address acc, uint32 iCard, uint duration) internal
688     {
689         RefreshDayBonus();
690         uint todayNo = GetDayCount(now);
691         PlayerBonus storage pb = g_Bonus.m_PlayerBonus[acc];
692         if (pb.m_DrawedDay == 0) pb.m_DrawedDay = todayNo;
693         for (uint dayNo=todayNo; dayNo<todayNo+duration; dayNo++)
694         {
695             pb.m_DayDynamic[dayNo].push(iCard);
696             DayRatio storage dr= g_Bonus.m_DayRatio[dayNo];
697             if (dr.m_CardNum[iCard] == 0) {
698                 dr.m_DynamicCard.push(iCard);
699             }
700             dr.m_CardNum[iCard]++;
701         }
702     }
703 
704     function AddStaticProfit(address acc,uint16 ratio,uint duration) internal
705     {
706         RefreshDayBonus();
707         uint todayNo = GetDayCount(now);
708         PlayerBonus storage pb = g_Bonus.m_PlayerBonus[acc];
709         if (pb.m_DrawedDay == 0) pb.m_DrawedDay = todayNo;
710         if (duration == 0) {
711             pb.m_DayPermanent[todayNo] += ratio;
712             g_Bonus.m_DayRatio[todayNo].m_Permanent += ratio;
713         }
714         else {
715             for (uint dayNo=todayNo; dayNo<todayNo+duration; dayNo++)
716             {
717                 pb.m_DayStatic[dayNo] += ratio;
718                 g_Bonus.m_DayRatio[dayNo].m_Static += ratio;
719             }
720         }
721     }
722 
723     function ImmediateProfit(address acc, uint ratio) internal
724     {
725         RefreshDayBonus();
726         uint bonus = ratio*g_Bonus.m_RecordBonus/BASERATIO;
727         g_Bonus.m_RecordBonus -= bonus;
728         g_Bonus.m_RewardBonus -= bonus;
729         if (bonus == 0) return
730         acc.transfer(bonus);
731     }
732 
733 
734     function ProfitByCard(address acc, uint32 iCard) internal
735     {
736         Card storage oCard = GetCard(iCard);
737         if (oCard.m_IP > 0) {
738             ImmediateProfit(acc,oCard.m_IP);
739         }
740         else if (oCard.m_SP > 0) {
741             AddStaticProfit(acc,oCard.m_SP,oCard.m_Duration);
742         }
743         else {
744             AddDynamicProfit(acc,iCard,oCard.m_Duration);
745         }
746     }
747 
748     function QueryBonus() external view returns(uint)
749     {
750         uint todayNo = GetDayCount(now);
751         if (!NeedRefresh(todayNo)) return g_Bonus.m_RecordBonus;
752 
753         uint tempBonus = g_Bonus.m_RecordBonus;
754         uint tempPR = g_Bonus.m_RecordPR;
755         uint tempRatio;
756         for (uint dayNo=g_Bonus.m_RecordDay; dayNo<todayNo; dayNo++)
757         {
758             tempRatio = tempPR+GenDayRatio(dayNo);
759             if (tempRatio == 0) continue;
760             DayRatio storage dr = g_Bonus.m_DayRatio[dayNo];
761             tempPR += dr.m_Permanent;
762             tempBonus -= tempBonus*tempRatio/BASERATIO;
763         }
764         return tempBonus;
765     }
766 
767     function QueryMyBonus(address acc) external view returns(uint bonus)
768     {
769         (bonus,) = QueryPlayerBonus(acc, GetDayCount(now));
770     }
771 
772     function AddBonus(uint bonus) external AuthAble
773     {
774         RefreshDayBonus();
775         g_Bonus.m_RewardBonus += bonus;
776         g_Bonus.m_RecordBonus += bonus;
777     }
778 
779     function Withdraw(address acc) external
780     {
781         RefreshDayBonus();
782         PlayerBonus storage pb = g_Bonus.m_PlayerBonus[acc];
783         uint bonus;
784         uint todayNo = GetDayCount(now);
785         (bonus, pb.m_DDPermanent) = QueryPlayerBonus(acc, todayNo);
786         require(bonus > 0);
787         pb.m_DrawedDay = todayNo;
788         acc.transfer(bonus);
789         g_Bonus.m_RewardBonus -= bonus;
790     }
791 
792     function MasterWithdraw() external
793     {
794         uint bonus = address(this).balance-g_Bonus.m_RewardBonus;
795         require(bonus > 0);
796         master.transfer(bonus);
797     }
798 
799 
800 }
801 
802 
803 
804 
805 contract MainBag is BasicTime,BasicAuth,MainChip,MainCard
806 {
807     using ItemList for ItemList.Data;
808 
809     struct Bag
810     {
811         ItemList.Data m_Stuff;
812         ItemList.Data m_TempStuff;
813         ItemList.Data m_Chips;
814         ItemList.Data m_TempCards; // temporary cards
815         ItemList.Data m_PermCards; // permanent cards
816     }
817 
818     mapping(address => Bag) g_BagList;
819 
820     function GainStuff(address acc, uint32 iStuff, uint iNum) external AuthAble OwnerAble(acc)
821     {
822         Bag storage obj = g_BagList[acc];
823         obj.m_Stuff.add(iStuff,iNum);
824     }
825 
826     function CostStuff(address acc, uint32 iStuff, uint iNum) external AuthAble OwnerAble(acc)
827     {
828         Bag storage obj = g_BagList[acc];
829         obj.m_Stuff.sub(iStuff,iNum);
830     }
831 
832     function GetStuffNum(address acc, uint32 iStuff) view external returns(uint)
833     {
834         Bag storage obj = g_BagList[acc];
835         return obj.m_Stuff.get(iStuff);
836     }
837 
838     function GetStuffList(address acc) external view returns(uint32[],uint[])
839     {
840         Bag storage obj = g_BagList[acc];
841         return obj.m_Stuff.list();
842     }
843 
844     function GainTempStuff(address acc, uint32 iStuff, uint dayCnt) external AuthAble OwnerAble(acc)
845     {
846         Bag storage obj = g_BagList[acc];
847         require(obj.m_TempStuff.get(iStuff) <= now);
848         obj.m_TempStuff.set(iStuff,now+dayCnt*DAY_SECONDS);
849     }
850 
851     function GetTempStuffExpire(address acc, uint32 iStuff) external view returns(uint expire)
852     {
853         Bag storage obj = g_BagList[acc];
854         expire = obj.m_TempStuff.get(iStuff);
855     }
856 
857     function GetTempStuffList(address acc) external view returns(uint32[],uint[])
858     {
859         Bag storage obj = g_BagList[acc];
860         return obj.m_TempStuff.list();
861     }
862 
863     function GainChip(address acc, uint32 iChip,bool bGenerated) external AuthAble OwnerAble(acc)
864     {
865         if (!bGenerated) {
866             require(CanObtainChip(iChip));
867             ObtainChip(iChip);
868         }
869         Bag storage obj = g_BagList[acc];
870         obj.m_Chips.add(iChip,1);
871     }
872 
873     function CostChip(address acc, uint32 iChip) external AuthAble OwnerAble(acc)
874     {
875         Bag storage obj = g_BagList[acc];
876         obj.m_Chips.sub(iChip,1);
877         CostChip(iChip);
878     }
879 
880     function GetChipNum(address acc, uint32 iChip) external view returns(uint)
881     {
882         Bag storage obj = g_BagList[acc];
883         return obj.m_Chips.get(iChip);
884     }
885 
886     function GetChipList(address acc) external view returns(uint32[],uint[])
887     {
888         Bag storage obj = g_BagList[acc];
889         return obj.m_Chips.list();
890     }
891 
892     function GainCard2(address acc, uint32 iCard) internal
893     {
894         Card storage oCard = GetCard(iCard);
895         if (oCard.m_IP > 0) return;
896         uint i;
897         uint32 iChip;
898         Bag storage obj = g_BagList[acc];
899         if (oCard.m_Duration > 0) {
900             // temporary
901             uint expireTime = GetExpireTime(now,oCard.m_Duration);
902             for (i=0; i<oCard.m_Parts.length; i++)
903             {
904                 iChip = oCard.m_Parts[i];
905                 AddChipTempTime(iChip,expireTime);
906             }
907             obj.m_TempCards.set(iCard,expireTime);
908         }
909         else {
910             // permanent
911             for (i=0; i<oCard.m_Parts.length; i++)
912             {
913                 iChip = oCard.m_Parts[i];
914                 ObtainChip(iChip);
915             }
916             obj.m_PermCards.set(iCard,1);
917         }
918     }
919 
920     function HasCard(address acc, uint32 iCard) public view returns(bool)
921     {
922         Bag storage obj = g_BagList[acc];
923         if (obj.m_TempCards.get(iCard) > now) return true;
924         if (obj.m_PermCards.has(iCard)) return true;
925         return false;
926     }
927 
928     function GetCardList(address acc) external view returns(uint32[] tempCards, uint[] cardsTime, uint32[] permCards)
929     {
930         Bag storage obj = g_BagList[acc];
931         (tempCards,cardsTime) = obj.m_TempCards.list();
932         permCards = obj.m_PermCards.keys();
933     }
934 
935 
936 }
937 
938 
939 
940 
941 contract Main is MainChip,MainCard,MainBag,MainBonus
942 {
943 
944     constructor(address Master) public
945     {
946         InitMaster(Master);
947     }
948 
949     function GainCard(address acc, uint32 iCard) external
950     {
951         require(CardExists(iCard) && !HasCard(acc,iCard));
952         GainCard2(acc,iCard);
953         ProfitByCard(acc,iCard);
954     }
955 
956     function GetDynamicCardAmountList(address acc) external view returns(uint[] amountList)
957     {
958         Bag storage oBag = g_BagList[acc];
959         uint len = oBag.m_TempCards.m_List.length;
960         amountList = new uint[](len);
961         for (uint i=0; i<len; i++)
962         {
963             uint32 iCard = oBag.m_TempCards.m_List[i];
964             amountList[i] = GetDynamicCardNum(iCard,GetDayCount(now));
965         }
966     }
967 
968     function GenChipByRandomWeight(uint random, uint8 level, uint[] extWeight) external AuthAble returns(uint32 iChip)
969     {
970         RefreshChipUnableList(level);
971         iChip = GenChipByWeight(random,level,extWeight);
972         ObtainChip(iChip);
973     }
974 
975     function CheckGenChip(uint32 iChip) external view returns(bool)
976     {
977         return CanObtainChip(iChip);
978     }
979 
980     function GenChip(uint32 iChip) external AuthAble
981     {
982         require(CanObtainChip(iChip));
983         ObtainChip(iChip);
984     }
985 
986 }
987 
988 
989 
990 
991 contract StoreGifts is BasicAuth
992 {
993     struct Gift
994     {
995         string m_Key;
996         uint m_Expire;
997         uint32[] m_ItemIdxList;
998         uint[] m_ItemNumlist;
999     }
1000 
1001     mapping(address => mapping(string => bool)) g_Exchange;
1002     mapping(string => Gift) g_Gifts;
1003 
1004     constructor(address Master) public
1005     {
1006         InitMaster(Master);
1007     }
1008 
1009     function HasGift(string key) public view returns(bool)
1010     {
1011         Gift storage obj = g_Gifts[key];
1012         if (bytes(obj.m_Key).length == 0) return false;
1013         if (obj.m_Expire!=0 && obj.m_Expire<now) return false;
1014         return true;
1015     }
1016 
1017     function AddGift(string key, uint expire, uint32[] idxList, uint[] numList) external MasterAble
1018     {
1019         require(!HasGift(key));
1020         require(now<expire || expire==0);
1021         g_Gifts[key] = Gift({
1022             m_Key           : key,
1023             m_Expire        : expire,
1024             m_ItemIdxList   : idxList,
1025             m_ItemNumlist   : numList
1026         });
1027     }
1028 
1029     function DelGift(string key) external MasterAble
1030     {
1031         delete g_Gifts[key];
1032     }
1033 
1034     function GetGiftInfo(string key) external view returns(uint, uint32[], uint[])
1035     {
1036         Gift storage obj = g_Gifts[key];
1037         return (obj.m_Expire, obj.m_ItemIdxList, obj.m_ItemNumlist);
1038     }
1039 
1040     function Exchange(address acc, string key) external OwnerAble(acc) AuthAble
1041     {
1042         g_Exchange[acc][key] = true;
1043     }
1044 
1045     function IsExchanged(address acc, string key) external view returns(bool)
1046     {
1047         return g_Exchange[acc][key];
1048     }
1049 
1050 }
1051 
1052 
1053 
1054 
1055 contract StoreGoods is BasicAuth
1056 {
1057     using ItemList for ItemList.Data;
1058 
1059     struct Goods
1060     {
1061         uint32 m_Index;
1062         uint32 m_CostItem;
1063         uint32 m_ItemRef;
1064         uint32 m_Amount;
1065         uint32 m_Duration;
1066         uint32 m_Expire;
1067         uint8 m_PurchaseLimit;
1068         uint8 m_DiscountLimit;
1069         uint8 m_DiscountRate;
1070         uint m_CostNum;
1071     }
1072 
1073     mapping(uint32 => Goods) g_Goods;
1074     mapping(address => ItemList.Data) g_PurchaseInfo;
1075 
1076     constructor(address Master) public
1077     {
1078         InitMaster(Master);
1079     }
1080 
1081     function AddGoods(
1082         uint32 iGoods,
1083         uint32 costItem,
1084         uint price,
1085         uint32 itemRef,
1086         uint32 amount,
1087         uint32 duration,
1088         uint32 expire,
1089         uint8 limit,
1090         uint8 disCount,
1091         uint8 disRate
1092     ) external MasterAble
1093     {
1094         require(!HasGoods(iGoods));
1095         g_Goods[iGoods] = Goods({
1096             m_Index         :iGoods,
1097             m_CostItem      :costItem,
1098             m_ItemRef       :itemRef,
1099             m_CostNum       :price,
1100             m_Amount        :amount,
1101             m_Duration      :duration,
1102             m_Expire        :expire,
1103             m_PurchaseLimit :limit,
1104             m_DiscountLimit :disCount,
1105             m_DiscountRate  :disRate
1106         });
1107     }
1108 
1109     function DelGoods(uint32 iGoods) external MasterAble
1110     {
1111         delete g_Goods[iGoods];
1112     }
1113 
1114     function HasGoods(uint32 iGoods) public view returns(bool)
1115     {
1116         Goods storage obj = g_Goods[iGoods];
1117         return obj.m_Index == iGoods;
1118     }
1119 
1120     function GetGoodsInfo(uint32 iGoods) external view returns(
1121         uint32,uint32,uint32,uint32,uint32,uint,uint8,uint8,uint8
1122     )
1123     {
1124         Goods storage obj = g_Goods[iGoods];
1125         return (
1126             obj.m_Index,
1127             obj.m_CostItem,
1128             obj.m_ItemRef,
1129             obj.m_Amount,
1130             obj.m_Duration,
1131             obj.m_CostNum,
1132             obj.m_PurchaseLimit,
1133             obj.m_DiscountLimit,
1134             obj.m_DiscountRate
1135         );
1136     }
1137 
1138     function GetRealCost(address acc, uint32 iGoods) external view returns(uint)
1139     {
1140         Goods storage obj = g_Goods[iGoods];
1141         if (g_PurchaseInfo[acc].get(iGoods) >= obj.m_DiscountLimit) {
1142             return obj.m_CostNum;
1143         }
1144         else {
1145             return obj.m_CostNum * obj.m_DiscountRate / 100;
1146         }
1147     }
1148 
1149     function BuyGoods(address acc, uint32 iGoods) external OwnerAble(acc) AuthAble
1150     {
1151         g_PurchaseInfo[acc].add(iGoods,1);
1152     }
1153 
1154     function IsOnSale(uint32 iGoods) external view returns(bool)
1155     {
1156         Goods storage obj = g_Goods[iGoods];
1157         if (obj.m_Expire == 0) return true;
1158         if (obj.m_Expire >= now) return true;
1159         return false;
1160     }
1161 
1162     function CheckPurchaseCount(address acc, uint32 iGoods) external view returns(bool)
1163     {
1164         Goods storage obj = g_Goods[iGoods];
1165         if (obj.m_PurchaseLimit == 0) return true;
1166         if (g_PurchaseInfo[acc].get(iGoods) < obj.m_PurchaseLimit) return true;
1167         return false;
1168     }
1169 
1170     function GetPurchaseInfo(address acc) external view returns(uint32[], uint[])
1171     {
1172         return g_PurchaseInfo[acc].list();
1173     }
1174 
1175 }
1176 
1177 
1178 
1179 
1180 contract Child is Base {
1181 
1182     Main g_Main;
1183 
1184     constructor(Main main) public
1185     {
1186         require(main != address(0));
1187         g_Main = main;
1188         g_Main.SetAuth(this);
1189     }
1190 
1191     function kill() external MasterAble
1192     {
1193         g_Main.ClearAuth(this);
1194         selfdestruct(creator);
1195     }
1196 
1197     function AddBonus(uint percent) internal
1198     {
1199         address(g_Main).transfer(msg.value);
1200         g_Main.AddBonus(msg.value * percent / 100);
1201     }
1202 
1203     function GenRandom(uint seed,uint base) internal view returns(uint,uint)
1204     {
1205         uint r = uint(keccak256(abi.encodePacked(msg.sender,seed,now)));
1206         if (base != 0) r %= base;
1207         return (r,seed+1);
1208     }
1209 
1210 }
1211 
1212 
1213 
1214 
1215 contract Store is Child
1216 {
1217     uint constant BONUS_PERCENT_PURCHASE = 80;
1218     uint constant CHIPGIFT_NORMALCHIP_RATE = 10000;
1219     uint32 constant CHIPGIFT_ITEMINDEX = 24001;
1220 
1221     uint8 constant EXCHANGE_OK = 0;
1222     uint8 constant EXCHANGE_KEYERR = 1;
1223     uint8 constant EXCHANGE_HADGOT = 2;
1224 
1225     StoreGoods g_Goods;
1226     StoreGifts g_Gifts;
1227 
1228     constructor(Main main, StoreGoods goods, StoreGifts gifts) public Child(main)
1229     {
1230         g_Goods = goods;
1231         g_Gifts = gifts;
1232         g_Goods.SetAuth(this);
1233         g_Gifts.SetAuth(this);
1234     }
1235     
1236     function kill() external MasterAble
1237     {
1238         g_Goods.ClearAuth(this);
1239     }
1240 
1241     function GenExtWeightList(uint8 level) internal pure returns(uint[] extList)
1242     {
1243         uint partNum = GetPartNum(level);
1244         extList = new uint[](partNum);
1245         for (uint i=0; i<partNum; i++)
1246         {
1247             uint iPart = i+1;
1248             if (!IsLimitPart(level,iPart)) {
1249                 extList[i] = GetPartWeight(level, iPart)*CHIPGIFT_NORMALCHIP_RATE;
1250             }
1251         }
1252     }
1253 
1254     function GiveChipGitf() internal
1255     {
1256         for (uint8 level=HEROLEVEL_MIN; level<=HEROLEVEL_MAX; level++)
1257         {
1258             (uint random,) = GenRandom(level, 0);
1259             uint32 iChip = g_Main.GenChipByRandomWeight(random, level, GenExtWeightList(level));
1260             g_Main.GainChip(msg.sender, iChip, true);
1261         }
1262     }
1263 
1264     function BuyGoods(uint32 iGoods) external payable
1265     {
1266         require(g_Goods.HasGoods(iGoods));
1267         require(g_Goods.IsOnSale(iGoods));
1268         require(g_Goods.CheckPurchaseCount(msg.sender, iGoods));
1269         (,uint32 iCostItem,uint32 iItemRef,uint32 iAmount,uint32 iDuration,,,,) = g_Goods.GetGoodsInfo(iGoods);
1270         uint iCostNum = g_Goods.GetRealCost(msg.sender, iGoods);
1271         if (iCostItem == 0) {
1272             // cost ether(wei)
1273             require(msg.value == iCostNum);
1274             AddBonus(BONUS_PERCENT_PURCHASE);
1275         }
1276         else {
1277             // cost other stuff
1278             g_Main.CostStuff(msg.sender,iCostItem,iCostNum);
1279         }
1280         g_Goods.BuyGoods(msg.sender, iGoods);
1281         if (iItemRef == CHIPGIFT_ITEMINDEX) {
1282             GiveChipGitf();
1283         }
1284         else {
1285             if (iDuration == 0) {
1286                 g_Main.GainStuff(msg.sender, iItemRef, iAmount);
1287             }
1288             else {
1289                 g_Main.GainTempStuff(msg.sender, iItemRef, iDuration);
1290             }
1291         }
1292     }
1293 
1294     function GetPurchaseInfo() external view returns(uint32[] goodsList, uint[] purchaseCountList)
1295     {
1296         (goodsList, purchaseCountList) = g_Goods.GetPurchaseInfo(msg.sender);
1297     }
1298 
1299     function CheckExchange(string key) public view returns(uint8)
1300     {
1301         if (!g_Gifts.HasGift(key)) return EXCHANGE_KEYERR;
1302         if (g_Gifts.IsExchanged(msg.sender, key)) return EXCHANGE_HADGOT;
1303         return EXCHANGE_OK;
1304     }
1305 
1306     function ExchangeGift(string key) external
1307     {
1308         require(CheckExchange(key) == EXCHANGE_OK);
1309         g_Gifts.Exchange(msg.sender, key);
1310         (, uint32[] memory idxList, uint[] memory numList) = g_Gifts.GetGiftInfo(key);
1311         for (uint i=0; i<idxList.length; i++)
1312         {
1313             g_Main.GainStuff(msg.sender, idxList[i], numList[i]);
1314         }
1315     }
1316 
1317 }