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
118 contract MainBase is Base 
119 {
120     modifier ValidLevel(uint8 level)
121     {
122         require(level<=HEROLEVEL_MAX && level>=HEROLEVEL_MIN);
123         _;
124     }
125 
126     modifier ValidParts(uint8 level, uint32[] parts)
127     {
128         require(GetPartNum(level) == parts.length);
129         _;
130     }
131 
132     modifier ValidPart(uint8 level, uint part)
133     {
134         require(part > 0);
135         require(GetPartNum(level) >= part);
136         _;
137     }
138 
139 }
140 
141 
142 
143 
144 library IndexList
145 {
146     function insert(uint32[] storage self, uint32 index, uint pos) external
147     {
148         require(self.length >= pos);
149         self.length++;
150         for (uint i=self.length; i>pos; i++)
151         {
152             self[i+1] = self[i];
153         }
154         self[pos] = index;
155     }
156 
157     function remove(uint32[] storage self, uint32 index) external returns(bool)
158     {
159         return remove(self,index,0);
160     }
161 
162     function remove(uint32[] storage self, uint32 index, uint startPos) public returns(bool)
163     {
164         for (uint i=startPos; i<self.length; i++)
165         {
166             if (self[i] != index) continue;
167             for (uint j=i; j<self.length-1; j++)
168             {
169                 self[j] = self[j+1];
170             }
171             delete self[self.length-1];
172             self.length--;
173             return true;
174         }
175         return false;
176     }
177 
178 }
179 
180 library ItemList {
181 
182     using IndexList for uint32[];
183     
184     struct Data {
185         uint32[] m_List;
186         mapping(uint32 => uint) m_Maps;
187     }
188 
189     function _insert(Data storage self, uint32 key, uint val) internal
190     {
191         self.m_List.push(key);
192         self.m_Maps[key] = val;
193     }
194 
195     function _delete(Data storage self, uint32 key) internal
196     {
197         self.m_List.remove(key);
198         delete self.m_Maps[key];
199     }
200 
201     function set(Data storage self, uint32 key, uint num) public
202     {
203         if (!has(self,key)) {
204             if (num == 0) return;
205             _insert(self,key,num);
206         }
207         else if (num == 0) {
208             _delete(self,key);
209         } 
210         else {
211             uint old = self.m_Maps[key];
212             if (old == num) return;
213             self.m_Maps[key] = num;
214         }
215     }
216 
217     function add(Data storage self, uint32 key, uint num) external
218     {
219         uint iOld = get(self,key);
220         uint iNow = iOld+num;
221         require(iNow >= iOld);
222         set(self,key,iNow);
223     }
224 
225     function sub(Data storage self, uint32 key, uint num) external
226     {
227         uint iOld = get(self,key);
228         require(iOld >= num);
229         set(self,key,iOld-num);
230     }
231 
232     function has(Data storage self, uint32 key) public view returns(bool)
233     {
234         return self.m_Maps[key] > 0;
235     }
236 
237     function get(Data storage self, uint32 key) public view returns(uint)
238     {
239         return self.m_Maps[key];
240     }
241 
242     function list(Data storage self) view external returns(uint32[],uint[])
243     {
244         uint len = self.m_List.length;
245         uint[] memory values = new uint[](len);
246         for (uint i=0; i<len; i++)
247         {
248             uint32 key = self.m_List[i];
249             values[i] = self.m_Maps[key];
250         }
251         return (self.m_List,values);
252     }
253 
254     function isEmpty(Data storage self) view external returns(bool)
255     {
256         return self.m_List.length == 0;
257     }
258 
259     function keys(Data storage self) view external returns(uint32[])
260     {
261         return self.m_List;
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
991 contract ProductionBoiler is BasicAuth
992 {
993 
994     struct Boiler
995     {
996         uint m_Expire;
997         uint32[] m_Chips;
998     }
999 
1000     mapping(address => mapping(uint => Boiler)) g_Boilers;
1001 
1002     constructor(address Master) public
1003     {
1004         InitMaster(Master);
1005     }
1006 
1007     function IsBoilerValid(address acc, uint idx) external view returns(bool)
1008     {
1009         Boiler storage obj = g_Boilers[acc][idx];
1010         if (obj.m_Chips.length > 0) return false;
1011         return true;
1012     }
1013 
1014     function IsBoilerExpire(address acc, uint idx) external view returns(bool)
1015     {
1016         Boiler storage obj = g_Boilers[acc][idx];
1017         return obj.m_Expire <= now;
1018     }
1019 
1020     //=========================================================================
1021 
1022     function GenerateChips(address acc, uint idx, uint cd, uint32[] chips) external AuthAble OwnerAble(acc)
1023     {
1024         Boiler storage obj = g_Boilers[acc][idx];
1025         obj.m_Expire = cd+now;
1026         obj.m_Chips = chips;
1027     }
1028 
1029     function CollectChips(address acc, uint idx) external AuthAble OwnerAble(acc) returns(uint32[] chips)
1030     {
1031         Boiler storage obj = g_Boilers[acc][idx];
1032         chips = new uint32[](obj.m_Chips.length);
1033         for (uint i=0; i<obj.m_Chips.length; i++)
1034         {
1035             chips[i] = obj.m_Chips[i];
1036             delete obj.m_Chips[i];
1037         }
1038         obj.m_Chips.length = 0;
1039         obj.m_Expire = 0;
1040     }
1041 
1042     function GetBoilerInfo(address acc, uint idx) external view returns(uint, uint32[])
1043     {
1044         Boiler storage obj = g_Boilers[acc][idx];
1045         return (obj.m_Expire,obj.m_Chips);
1046     }
1047 
1048 }
1049 
1050 
1051 
1052 
1053 contract Child is Base {
1054 
1055     Main g_Main;
1056 
1057     constructor(Main main) public
1058     {
1059         require(main != address(0));
1060         g_Main = main;
1061         g_Main.SetAuth(this);
1062     }
1063 
1064     function kill() external MasterAble
1065     {
1066         g_Main.ClearAuth(this);
1067         selfdestruct(creator);
1068     }
1069 
1070     function AddBonus(uint percent) internal
1071     {
1072         address(g_Main).transfer(msg.value);
1073         g_Main.AddBonus(msg.value * percent / 100);
1074     }
1075 
1076     function GenRandom(uint seed,uint base) internal view returns(uint,uint)
1077     {
1078         uint r = uint(keccak256(abi.encodePacked(msg.sender,seed,now)));
1079         if (base != 0) r %= base;
1080         return (r,seed+1);
1081     }
1082 
1083 }
1084 
1085 
1086 
1087 
1088 contract Production is Child {
1089 
1090     uint32 constant STUFF_IDX_POINT = 22001;
1091     uint32 constant STUFF_IDX_GENRAL = 21000;
1092     uint32 constant STUFF_IDX_EXTRA = 21004;
1093 
1094     uint32 constant PERMISSION_1 = 23002;
1095     uint32 constant PERMISSION_2 = 23003;
1096 
1097     uint constant BASERATIO = 10000;
1098     uint constant BOILER_FREE_IDX = 0;
1099     uint constant BOILER_MAX_NUM = 3;
1100 
1101     uint constant CREATE_COST_MIN = 30;
1102     uint constant CREATE_COST_FEW = 60;
1103     uint constant CREATE_COST_MANY = 150;
1104     uint constant CREATE_COST_MAX = 300;
1105 
1106     uint constant COOLTIME_MIN = 60 * 60;
1107     uint constant COOLTIME_MID = 60 * 60 * 2;
1108     uint constant COOLTIME_MAX = 60 * 60 * 4;
1109 
1110     uint constant ACCELERATE_UNITTIME = 60 * 5;
1111     uint constant ACCELERATE_UNITFEE = 0.0013 ether;
1112     uint constant BONUS_PERCENT_ACCELERATE = 80;
1113 
1114     ProductionBoiler g_Boilers;
1115 
1116     constructor(Main main, ProductionBoiler pb) public Child(main)
1117     {
1118         g_Boilers = pb;
1119         g_Boilers.SetAuth(this);
1120     }
1121 
1122     function kill() external MasterAble
1123     {
1124         g_Boilers.ClearAuth(this);
1125     }
1126 
1127     function GenChipIndex(
1128         uint seed,
1129         uint8 level,
1130         uint[] extWeight3,
1131         uint[] extWeight4,
1132         uint[] extWeight5
1133     ) internal returns(uint32,uint)
1134     {
1135         uint random;
1136         (random,seed) = GenRandom(seed,0);
1137         if (level==1 || level==2) {
1138             return (g_Main.GenChipByRandomWeight(random,level,extWeight3),seed);
1139         }
1140         else if (level==3 || level==4) {
1141             return (g_Main.GenChipByRandomWeight(random,level,extWeight4),seed);
1142         }
1143         else {
1144             return (g_Main.GenChipByRandomWeight(random,level,extWeight5),seed);
1145         }
1146     }
1147 
1148     function GenChipLevel_Special(uint costAll, uint x, uint seed) internal view returns(uint8,uint)
1149     {
1150         uint8 outLv;
1151         uint random;
1152         if (costAll <= CREATE_COST_FEW) {
1153             outLv = 3;
1154         }
1155         else {
1156             (random,seed) = GenRandom(seed,BASERATIO);
1157             uint baseR = BASERATIO*x/100;
1158             if (costAll <= CREATE_COST_MANY) {
1159                 baseR /= 10;
1160                 if (random <= BASERATIO*80/100-baseR) {
1161                     outLv = 3;
1162                 }
1163                 else if (random <= BASERATIO-baseR/4) {
1164                     outLv = 4;
1165                 }
1166                 else {
1167                     outLv = 5;
1168                 }
1169             }
1170             else {
1171                 baseR /= 10;
1172                 if (random <= BASERATIO*70/100-baseR) {
1173                     outLv = 3;
1174                 }
1175                 else if (random <= BASERATIO*95/100-baseR/5) {
1176                     outLv = 4;
1177                 }
1178                 else {
1179                     outLv = 5;
1180                 }
1181             }
1182         }
1183         return (outLv,seed);
1184     }
1185 
1186     function GenChipLevel_Extra(uint costAll, uint x, uint seed) internal view returns(uint8,uint)
1187     {
1188         uint8 outLv;
1189         uint random;
1190         uint baseR = BASERATIO*x/100;
1191         (random,seed) = GenRandom(seed,BASERATIO);
1192         if (costAll <= CREATE_COST_FEW) {
1193             baseR /= 4;
1194             if (random <= BASERATIO*80/100-baseR) {
1195                 outLv = 1;
1196             }
1197             else if (random <= BASERATIO*98/100-baseR*3/4) {
1198                 outLv = 2;
1199             }
1200             else if (random <= BASERATIO-baseR/4) {
1201                 outLv = 3;
1202             }
1203             else {
1204                 outLv = 4;
1205             }
1206         }
1207         else if (costAll <= CREATE_COST_MANY) {
1208             baseR /= 10;
1209             if (random <= BASERATIO*55/100-baseR) {
1210                 outLv = 1;
1211             }
1212             else if (random <= BASERATIO*85/100-baseR*4/5) {
1213                 outLv = 2;
1214             }
1215             else if (random <= BASERATIO*95/100-baseR*2/5) {
1216                 outLv = 3;
1217             }
1218             else if (random <= BASERATIO-baseR/5) {
1219                 outLv = 4;
1220             }
1221             else {
1222                 outLv = 5;
1223             }
1224         }
1225         else {
1226             baseR /= 10;
1227             if (random <= BASERATIO*30/100-baseR/2) {
1228                 outLv = 1;
1229             }
1230             else if (random <= BASERATIO*75/100-baseR) {
1231                 outLv = 2;
1232             }
1233             else if (random <= BASERATIO*88/100-baseR*4/7) {
1234                 outLv = 3;
1235             }
1236             else if (random <= BASERATIO*97/100-baseR/7) {
1237                 outLv = 4;
1238             }
1239             else {
1240                 outLv = 5;
1241             }
1242         }
1243         return (outLv,seed);
1244     }
1245 
1246     function GenChipLevel_General(uint costAll, uint x, uint seed) internal view returns(uint8,uint)
1247     {
1248         uint8 outLv;
1249         uint random;
1250         uint baseR = BASERATIO*x/100;
1251         (random,seed) = GenRandom(seed,BASERATIO);
1252         if (costAll <= CREATE_COST_FEW) {
1253             baseR /= 2;
1254             if (random <= BASERATIO - baseR) {
1255                 outLv = 1;
1256             }
1257             else {
1258                 outLv = 2;
1259             }
1260         }
1261         else if (costAll <= CREATE_COST_MANY) {
1262             baseR = baseR*14/100;
1263             if (random <= BASERATIO*70/100-baseR) {
1264                 outLv = 1;
1265             }
1266             else if (random <= BASERATIO*95/100-baseR/4) {
1267                 outLv = 2;
1268             }
1269             else {
1270                 outLv = 3;
1271             }
1272         }
1273         else {
1274             baseR = baseR*11/100;
1275             if (random <= BASERATIO*50/100-baseR) {
1276                 outLv = 1;
1277             }
1278             else if (random <= BASERATIO*90/100-baseR/3) {
1279                 outLv = 2;
1280             }
1281             else {
1282                 outLv = 3;
1283             }
1284         }
1285         return (outLv,seed);
1286     }
1287 
1288     function GenOutChipsNum(uint seed, uint costAll, uint x) internal view returns(uint,uint)
1289     {
1290         uint amount;
1291         uint random;
1292         uint baseR = BASERATIO*x/100;
1293         (random,seed) = GenRandom(seed,BASERATIO);
1294         if (costAll <= CREATE_COST_FEW) {
1295             if (random <= BASERATIO - baseR) {
1296                 amount = 3;
1297             }
1298             else {
1299                 amount = 4;
1300             }
1301         }
1302         else {
1303             baseR /= 10;
1304             if (costAll <= CREATE_COST_MANY) {
1305                 if (random <= BASERATIO*7/10 - baseR*2) {
1306                     amount = 3;
1307                 }
1308                 else if (random <= BASERATIO*3/10 + baseR) {
1309                     amount = 4;
1310                 }
1311                 else {
1312                     amount = 5;
1313                 }
1314             }
1315             else {
1316                 if (random <= BASERATIO*7/10 - baseR) {
1317                     amount = 4;
1318                 }
1319                 else {
1320                     amount = 5;
1321                 }
1322             }
1323         }
1324         return (amount,seed);
1325     }
1326 
1327     function GetMinCost(uint a, uint b, uint c) internal pure returns(uint)
1328     {
1329         if (a>b) {
1330             if (a>c) return a;
1331         }
1332         else if (b>c) return b;
1333         else return c;
1334     }
1335 
1336     function GenExtWeightList(uint costA, uint costB, uint costC) internal pure returns(uint[],uint[],uint[])
1337     {
1338         uint min = GetMinCost(costA,costB,costC);
1339         uint[] memory extWeight3 = new uint[](3);
1340         uint[] memory extWeight4 = new uint[](4);
1341         uint[] memory extWeight5 = new uint[](5);
1342         extWeight3[0] = costA;
1343         extWeight4[0] = costA;
1344         extWeight5[0] = costA;
1345         extWeight3[1] = costB;
1346         extWeight4[1] = costB;
1347         extWeight5[1] = costB;
1348         extWeight3[2] = costC;
1349         extWeight4[2] = costC;
1350         extWeight5[2] = costC;
1351         extWeight5[3] = min;
1352         min = min/2;
1353         extWeight4[3] = min;
1354         extWeight5[4] = min;
1355         return (extWeight3,extWeight4,extWeight5);
1356     }
1357 
1358     function GenChipsLevel(uint costAll,bool bUseX) internal view returns(uint8[] lvList, uint seed)
1359     {
1360         // calculate amount, chips by random
1361         uint x = costAll - CREATE_COST_MIN;
1362         uint i;
1363         uint amount;
1364         // cal chips amount
1365         (amount,seed) = GenOutChipsNum(0,costAll,x);
1366         lvList = new uint8[](amount);
1367         if (bUseX) {
1368             (lvList[0], seed) = GenChipLevel_Special(costAll,x,seed);
1369             for (i=1; i<amount; i++)
1370             {
1371                 (lvList[i], seed) = GenChipLevel_Extra(costAll,x,seed);
1372             }
1373         }
1374         else {
1375             for (i=0; i<amount; i++)
1376             {
1377                 (lvList[i], seed) = GenChipLevel_General(costAll,x,seed);
1378             }
1379         }
1380 
1381     }
1382 
1383     function CreateChips(uint costAll, uint costA, uint costB, uint costC, bool bUseX) internal returns(uint32[])
1384     {
1385         (uint[] memory ext3,
1386          uint[] memory ext4,
1387          uint[] memory ext5
1388         ) = GenExtWeightList(costA,costB,costC);
1389 
1390         (uint8[] memory lvList, uint seed) = GenChipsLevel(costAll,bUseX);
1391         uint32[] memory chips = new uint32[](lvList.length);
1392         for (uint i=0; i<lvList.length; i++)
1393         {
1394             uint8 chipLv = lvList[i];
1395             (chips[i], seed) = GenChipIndex(seed,chipLv,ext3,ext4,ext5);
1396         }
1397         return chips;
1398     }
1399 
1400     function GetPermissionIdx(uint idx) internal pure returns(uint32)
1401     {
1402         if (idx == 1) return PERMISSION_1;
1403         else if (idx == 2) return PERMISSION_2;
1404         return 0;
1405     }
1406 
1407     function IsBoilerValid(uint idx) internal view returns(bool)
1408     {
1409         if (idx != BOILER_FREE_IDX) {
1410             uint32 iStuff = GetPermissionIdx(idx);
1411             if (iStuff == 0) return false;
1412             if (g_Main.GetTempStuffExpire(msg.sender,iStuff) < now) return false;
1413         }
1414         return g_Boilers.IsBoilerValid(msg.sender,idx);
1415     }
1416 
1417     function CollectChips(uint idx) internal
1418     {
1419         uint32[] memory chips = g_Boilers.CollectChips(msg.sender,idx);
1420         for (uint i=0; i<chips.length; i++)
1421         {
1422             g_Main.GainChip(msg.sender,chips[i],true);
1423         }
1424     }
1425 
1426     function GetExchangePoint(uint8 chipLv) internal pure returns(uint)
1427     {
1428         if (chipLv == 1) return 1;
1429         else if (chipLv == 2) return 3;
1430         else if (chipLv == 3) return 10;
1431         else if (chipLv == 4) return 30;
1432         else if (chipLv == 5) return 120;
1433         return 0;
1434     }
1435 
1436     //=========================================================================
1437 
1438     function Create(uint idx,uint costA, uint costB, uint costC, bool bUseX) external
1439     {
1440         require(costA <= CREATE_COST_MAX);
1441         require(costB <= CREATE_COST_MAX);
1442         require(costC <= CREATE_COST_MAX);
1443         uint costAll = costA+costB+costC;
1444         require(costAll>=CREATE_COST_MIN && costAll<=CREATE_COST_MAX);
1445 
1446         require(IsBoilerValid(idx));
1447 
1448         g_Main.CostStuff(msg.sender,STUFF_IDX_GENRAL,costAll);
1449         if (bUseX) g_Main.CostStuff(msg.sender,STUFF_IDX_EXTRA,1);
1450         uint CD;
1451         if (costAll <= CREATE_COST_FEW) {
1452             CD = COOLTIME_MIN;
1453         }
1454         else if (costAll <= CREATE_COST_MANY) {
1455             CD = COOLTIME_MID;
1456         }
1457         else {
1458             CD = COOLTIME_MAX;
1459         }
1460 
1461         uint32[] memory chips = CreateChips(costAll,costA,costB,costC,bUseX);
1462         g_Boilers.GenerateChips(msg.sender,idx,CD,chips);
1463     }
1464 
1465     function GetBoilersInfo() external view returns(uint[], uint32[], uint32[], uint32[] )
1466     {
1467         uint[] memory expireList = new uint[](BOILER_MAX_NUM);
1468         uint32[][] memory allChips = new uint32[][](BOILER_MAX_NUM);
1469         for (uint i=BOILER_FREE_IDX; i<BOILER_MAX_NUM; i++)
1470         {
1471             (uint expire, uint32[] memory chips) = g_Boilers.GetBoilerInfo(msg.sender,i);
1472             expireList[i] = expire;
1473             allChips[i] = chips;
1474         }
1475         return (
1476             expireList,
1477             allChips[0],
1478             allChips[1],
1479             allChips[2]
1480         );
1481     }
1482 
1483     function ResolveChips(uint32[] chips) external
1484     {
1485         for (uint i=0; i<chips.length; i++)
1486         {
1487             uint32 iChip = chips[i];
1488             g_Main.CostChip(msg.sender,iChip);
1489             (,uint8 lv,,,,) = g_Main.GetChipInfo(iChip);
1490             uint point = GetExchangePoint(lv);
1491             g_Main.GainStuff(msg.sender,STUFF_IDX_POINT,point);
1492         }
1493     }
1494 
1495     function Collect(uint idx) external
1496     {
1497         require(g_Boilers.IsBoilerExpire(msg.sender,idx));
1498         CollectChips(idx);
1499     }
1500 
1501     function Accelerate(uint idx) external payable
1502     {
1503         (uint expire,) = g_Boilers.GetBoilerInfo(msg.sender,idx);
1504         require(expire > now);
1505         uint remain = expire-now;
1506         uint num = remain/ACCELERATE_UNITTIME;
1507         if (remain != num*ACCELERATE_UNITTIME) {
1508             num++;
1509         }
1510         uint fee = num*ACCELERATE_UNITFEE;
1511         require(fee == msg.value);
1512         AddBonus(BONUS_PERCENT_ACCELERATE);
1513         CollectChips(idx);
1514     }
1515 
1516 }