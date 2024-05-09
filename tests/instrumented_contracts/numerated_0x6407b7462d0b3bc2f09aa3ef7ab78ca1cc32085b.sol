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
21     modifier CreatorAble()
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
47     function GetPartLimit(uint8 level, uint part) internal pure returns(uint8)
48     {
49         if (!IsLimitPart(level, part)) return 0;
50         if (level == 5) return 1;
51         if (level == 4) return 8;
52         return 15;
53     }
54 
55 }
56 
57 
58 
59 
60 contract BasicAuth is Base
61 {
62 
63     mapping(address => bool) auth_list;
64 
65     modifier OwnerAble(address acc)
66     {
67         require(acc == tx.origin);
68         _;
69     }
70 
71     modifier AuthAble()
72     {
73         require(auth_list[msg.sender]);
74         _;
75     }
76 
77     modifier ValidHandleAuth()
78     {
79         require(tx.origin==creator || msg.sender==creator);
80         _;
81     }
82    
83     function SetAuth(address target) external ValidHandleAuth
84     {
85         auth_list[target] = true;
86     }
87 
88     function ClearAuth(address target) external ValidHandleAuth
89     {
90         delete auth_list[target];
91     }
92 
93 }
94 
95 
96 
97 
98 library ItemList {
99 
100     struct Data {
101         uint32[] m_List;
102         mapping(uint32 => uint) m_Maps;
103     }
104 
105     function set(Data storage self, uint32 key, uint num) public
106     {
107         if (!has(self,key)) {
108             if (num == 0) return;
109             self.m_List.push(key);
110             self.m_Maps[key] = num;
111         }
112         else if (num == 0) {
113             delete self.m_Maps[key];
114         } 
115         else {
116             uint old = self.m_Maps[key];
117             if (old == num) return;
118             self.m_Maps[key] = num;
119         }
120     }
121 
122     function add(Data storage self, uint32 key, uint num) external
123     {
124         uint iOld = get(self,key);
125         uint iNow = iOld+num;
126         require(iNow >= iOld);
127         set(self,key,iNow);
128     }
129 
130     function sub(Data storage self, uint32 key, uint num) external
131     {
132         uint iOld = get(self,key);
133         require(iOld >= num);
134         set(self,key,iOld-num);
135     }
136 
137     function has(Data storage self, uint32 key) public view returns(bool)
138     {
139         return self.m_Maps[key] > 0;
140     }
141 
142     function get(Data storage self, uint32 key) public view returns(uint)
143     {
144         return self.m_Maps[key];
145     }
146 
147     function list(Data storage self) view external returns(uint32[],uint[])
148     {
149         uint len = self.m_List.length;
150         uint[] memory values = new uint[](len);
151         for (uint i=0; i<len; i++)
152         {
153             uint32 key = self.m_List[i];
154             values[i] = self.m_Maps[key];
155         }
156         return (self.m_List,values);
157     }
158 
159     function isEmpty(Data storage self) view external returns(bool)
160     {
161         return self.m_List.length == 0;
162     }
163 
164     function keys(Data storage self) view external returns(uint32[])
165     {
166         return self.m_List;
167     }
168 
169 }
170 
171 
172 
173 
174 library IndexList
175 {
176     function insert(uint32[] storage self, uint32 index, uint pos) external
177     {
178         require(self.length >= pos);
179         self.length++;
180         for (uint i=self.length; i>pos; i++)
181         {
182             self[i+1] = self[i];
183         }
184         self[pos] = index;
185     }
186 
187     function remove(uint32[] storage self, uint32 index) external returns(bool)
188     {
189         return remove(self,index,0);
190     }
191 
192     function remove(uint32[] storage self, uint32 index, uint startPos) public returns(bool)
193     {
194         for (uint i=startPos; i<self.length; i++)
195         {
196             if (self[i] != index) continue;
197             for (uint j=i; j<self.length-1; j++)
198             {
199                 self[j] = self[j+1];
200             }
201             delete self[self.length-1];
202             self.length--;
203             return true;
204         }
205         return false;
206     }
207 
208 }
209 
210 
211 
212 
213 contract MainCard is BasicAuth
214 {
215     struct Card {
216         uint32 m_Index;
217         uint32 m_Duration;
218         uint8 m_Level;
219         uint16 m_DP;  //DynamicProfit
220         uint16 m_DPK; //K is coefficient
221         uint16 m_SP;  //StaticProfit
222         uint16 m_IP;  //ImmediateProfit
223         uint32[] m_Parts;
224     }
225 
226     struct CardLib {
227         uint32[] m_List;
228         mapping(uint32 => Card) m_Lib;
229     }
230 
231     CardLib g_CardLib;
232 
233     function AddNewCard(uint32 iCard, uint32 duration, uint8 level, uint16 dp, uint16 dpk, uint16 sp, uint16 ip, uint32[] parts) internal
234     {
235         g_CardLib.m_List.push(iCard);
236         g_CardLib.m_Lib[iCard] = Card({
237             m_Index   : iCard,
238             m_Duration: duration,
239             m_Level   : level,
240             m_DP      : dp,
241             m_DPK     : dpk,
242             m_SP      : sp,
243             m_IP      : ip,
244             m_Parts   : parts
245         });
246     }
247 
248     function CardExists(uint32 iCard) public view returns(bool)
249     {
250         Card storage obj = g_CardLib.m_Lib[iCard];
251         return obj.m_Index == iCard;
252     }
253 
254     function GetCard(uint32 iCard) internal view returns(Card storage)
255     {
256         return g_CardLib.m_Lib[iCard];
257     }
258 
259     function GetCardInfo(uint32 iCard) external view returns(uint32, uint32, uint8, uint16, uint16, uint16, uint16, uint32[])
260     {
261         Card storage obj = GetCard(iCard);
262         return (obj.m_Index, obj.m_Duration, obj.m_Level, obj.m_DP, obj.m_DPK, obj.m_SP, obj.m_IP, obj.m_Parts);
263     }
264 
265     function GetExistsCardList() external view returns(uint32[])
266     {
267         return g_CardLib.m_List;
268     }
269 
270 }
271 
272 
273 
274 
275 contract MainChip is BasicAuth
276 {
277     using IndexList for uint32[];
278 
279     struct Chip
280     {
281         uint8 m_Level;
282         uint8 m_LimitNum;
283         uint8 m_Part;
284         uint32 m_Index;
285         uint256 m_UsedNum;
286     }
287 
288     struct PartManager
289     {
290         uint32[] m_IndexList;   //index list, player can obtain
291         uint32[] m_UnableList;  //player can't obtain
292     }
293 
294     struct ChipLib
295     {
296         uint32[] m_List;
297         mapping(uint32 => Chip) m_Lib;
298         mapping(uint32 => uint[]) m_TempList;
299         mapping(uint8 => mapping(uint => PartManager)) m_PartMap;//level -> level list
300     }
301 
302     ChipLib g_ChipLib;
303 
304     function AddNewChip(uint32 iChip, uint8 lv, uint8 limit, uint8 part) internal
305     {
306         require(!ChipExists(iChip));
307         g_ChipLib.m_List.push(iChip);
308         g_ChipLib.m_Lib[iChip] = Chip({
309             m_Index       : iChip,
310             m_Level       : lv,
311             m_LimitNum    : limit,
312             m_Part        : part,
313             m_UsedNum     : 0
314         });
315         PartManager storage pm = GetPartManager(lv,part);
316         pm.m_IndexList.push(iChip);
317     }
318 
319     function GetChip(uint32 iChip) internal view returns(Chip storage)
320     {
321         return g_ChipLib.m_Lib[iChip];
322     }
323 
324     function GetPartManager(uint8 level, uint iPart) internal view returns(PartManager storage)
325     {
326         return g_ChipLib.m_PartMap[level][iPart];
327     }
328 
329     function ChipExists(uint32 iChip) public view returns(bool)
330     {
331         Chip storage obj = GetChip(iChip);
332         return obj.m_Index == iChip;
333     }
334 
335     function GetChipUsedNum(uint32 iChip) internal view returns(uint)
336     {
337         Chip storage obj = GetChip(iChip);
338         uint[] memory tempList = g_ChipLib.m_TempList[iChip];
339         uint num = tempList.length;
340         for (uint i=num; i>0; i--)
341         {
342             if(tempList[i-1]<=now) {
343                 num -= i;
344                 break;
345             }
346         }
347         return obj.m_UsedNum + num;
348     }
349 
350     function CanObtainChip(uint32 iChip) internal view returns(bool)
351     {
352         Chip storage obj = GetChip(iChip);
353         if (obj.m_LimitNum == 0) return true;
354         if (GetChipUsedNum(iChip) < obj.m_LimitNum) return true;
355         return false;
356     }
357 
358     function CostChip(uint32 iChip) internal
359     {
360         BeforeChipCost(iChip);
361         Chip storage obj = GetChip(iChip);
362         obj.m_UsedNum--;
363     }
364 
365     function ObtainChip(uint32 iChip) internal
366     {
367         BeforeChipObtain(iChip);
368         Chip storage obj = GetChip(iChip);
369         obj.m_UsedNum++;
370     }
371 
372     function BeforeChipObtain(uint32 iChip) internal
373     {
374         Chip storage obj = GetChip(iChip);
375         if (obj.m_LimitNum == 0) return;
376         uint usedNum = GetChipUsedNum(iChip);
377         require(obj.m_LimitNum >= usedNum+1);
378         if (obj.m_LimitNum == usedNum+1) {
379             PartManager storage pm = GetPartManager(obj.m_Level,obj.m_Part);
380             if (pm.m_IndexList.remove(iChip)){
381                 pm.m_UnableList.push(iChip);
382             }
383         }
384     }
385 
386     function BeforeChipCost(uint32 iChip) internal
387     {
388         Chip storage obj = GetChip(iChip);
389         if (obj.m_LimitNum == 0) return;
390         uint usedNum = GetChipUsedNum(iChip);
391         require(obj.m_LimitNum >= usedNum);
392         if (obj.m_LimitNum == usedNum) {
393             PartManager storage pm = GetPartManager(obj.m_Level,obj.m_Part);
394             if (pm.m_UnableList.remove(iChip)) {
395                 pm.m_IndexList.push(iChip);
396             }
397         }
398     }
399 
400     function AddChipTempTime(uint32 iChip, uint expireTime) internal
401     {
402         uint[] storage list = g_ChipLib.m_TempList[iChip];
403         require(list.length==0 || expireTime>=list[list.length-1]);
404         BeforeChipObtain(iChip);
405         list.push(expireTime);
406     }
407 
408     function RefreshChipUnableList(uint8 level) internal
409     {
410         uint partNum = GetPartNum(level);
411         for (uint iPart=1; iPart<=partNum; iPart++)
412         {
413             PartManager storage pm = GetPartManager(level,iPart);
414             for (uint i=pm.m_UnableList.length; i>0; i--)
415             {
416                 uint32 iChip = pm.m_UnableList[i-1];
417                 if (CanObtainChip(iChip)) {
418                     pm.m_IndexList.push(iChip);
419                     pm.m_UnableList.remove(iChip,i-1);
420                 }
421             }
422         }
423     }
424 
425     function GenChipByWeight(uint random, uint8 level, uint[] extWeight) internal view returns(uint32)
426     {
427         uint partNum = GetPartNum(level);
428         uint allWeight;
429         uint[] memory newWeight = new uint[](partNum+1);
430         uint[] memory realWeight = new uint[](partNum+1);
431         for (uint iPart=1; iPart<=partNum; iPart++)
432         {
433             PartManager storage pm = GetPartManager(level,iPart);
434             uint curWeight = extWeight[iPart-1]+GetPartWeight(level,iPart);
435             allWeight += pm.m_IndexList.length*curWeight;
436             newWeight[iPart] = allWeight;
437             realWeight[iPart] = curWeight;
438         }
439 
440         uint weight = random % allWeight;
441         for (iPart=1; iPart<=partNum; iPart++)
442         {
443             if (weight >= newWeight[iPart]) continue;
444             pm = GetPartManager(level,iPart);
445             uint idx = (weight-newWeight[iPart-1])/realWeight[iPart];
446             return pm.m_IndexList[idx];
447         }
448     }
449 
450     function GetChipInfo(uint32 iChip) external view returns(uint32, uint8, uint8, uint, uint8, uint)
451     {
452         Chip storage obj = GetChip(iChip);
453         return (obj.m_Index, obj.m_Level, obj.m_LimitNum, GetPartWeight(obj.m_Level,obj.m_Part), obj.m_Part, GetChipUsedNum(iChip));
454     }
455 
456     function GetExistsChipList() external view returns(uint32[])
457     {
458         return g_ChipLib.m_List;
459     }
460 
461 }
462 
463 
464 
465 
466 contract BasicTime
467 {
468     uint constant DAY_SECONDS = 60 * 60 * 24;
469 
470     function GetDayCount(uint timestamp) pure internal returns(uint)
471     {
472         return timestamp/DAY_SECONDS;
473     }
474 
475     function GetExpireTime(uint timestamp, uint dayCnt) pure internal returns(uint)
476     {
477         uint dayEnd = GetDayCount(timestamp) + dayCnt;
478         return dayEnd * DAY_SECONDS;
479     }
480 
481 }
482 
483 
484 
485 
486 contract MainBonus is BasicTime,BasicAuth,MainCard
487 {
488     uint constant BASERATIO = 10000;
489 
490     struct PlayerBonus
491     {
492         uint m_Bonus;       // bonus by immediateprofit
493         uint m_DrawedDay;
494         uint16 m_DDPermanent;// drawed day permanent
495         mapping(uint => uint16) m_DayStatic;
496         mapping(uint => uint16) m_DayPermanent;
497         mapping(uint => uint32[]) m_DayDynamic;
498     }
499 
500     struct DayRatio
501     {
502         uint16 m_Static;
503         uint16 m_Permanent;
504         uint32[] m_DynamicCard;
505         mapping(uint32 => uint) m_CardNum;
506     }
507 
508     struct BonusData
509     {
510         uint m_RewardBonus;//bonus pool,waiting for withdraw
511         uint m_RecordDay;// recordday
512         uint m_RecordBonus;//recordday bonus , to show
513         uint m_RecordPR;// recordday permanent ratio
514         mapping(uint => DayRatio) m_DayRatio;
515         mapping(uint => uint) m_DayBonus;// day final bonus
516         mapping(address => PlayerBonus) m_PlayerBonus;
517     }
518 
519     address receiver;
520     BonusData g_Bonus;
521 
522     constructor(address Receiver) public
523     {
524         g_Bonus.m_RecordDay = GetDayCount(now);
525         receiver = Receiver;
526     }
527 
528     function() external payable {}
529 
530     function NeedRefresh(uint dayNo) internal view returns(bool)
531     {
532         if (g_Bonus.m_RecordBonus == 0) return false;
533         if (g_Bonus.m_RecordDay == dayNo) return false;
534         return true;
535     }
536 
537     function PlayerNeedRefresh(address acc, uint dayNo) internal view returns(bool)
538     {
539         if (g_Bonus.m_RecordBonus == 0) return false;
540         PlayerBonus storage pb = g_Bonus.m_PlayerBonus[acc];
541         if (pb.m_DrawedDay == dayNo) return false;
542         return true;
543     }
544 
545     function GetDynamicRatio(uint dayNo) internal view returns(uint tempRatio)
546     {
547         DayRatio storage dr = g_Bonus.m_DayRatio[dayNo];
548         for (uint i=0; i<dr.m_DynamicCard.length; i++)
549         {
550             uint32 iCard = dr.m_DynamicCard[i];
551             uint num = dr.m_CardNum[iCard];
552             Card storage oCard = GetCard(iCard);
553             tempRatio += num*oCard.m_DP*oCard.m_DPK/(oCard.m_DPK+num);
554         }
555     }
556 
557     function GenDayRatio(uint dayNo) internal view returns(uint iDR)
558     {
559         DayRatio storage dr = g_Bonus.m_DayRatio[dayNo];
560         iDR += dr.m_Permanent;
561         iDR += dr.m_Static;
562         iDR += GetDynamicRatio(dayNo);
563     }
564 
565     function GetDynamicCardNum(uint32 iCard, uint dayNo) internal view returns(uint num)
566     {
567         DayRatio storage dr = g_Bonus.m_DayRatio[dayNo];
568         num = dr.m_CardNum[iCard];
569     }
570 
571     function GetPlayerDynamicRatio(address acc, uint dayNo) internal view returns(uint tempRatio)
572     {
573         PlayerBonus storage pb = g_Bonus.m_PlayerBonus[acc];
574         DayRatio storage dr = g_Bonus.m_DayRatio[dayNo];
575         uint32[] storage cards = pb.m_DayDynamic[dayNo];
576         for (uint idx=0; idx<cards.length; idx++)
577         {
578             uint32 iCard = cards[idx];
579             uint num = dr.m_CardNum[iCard];
580             Card storage oCard = GetCard(iCard);
581             tempRatio += oCard.m_DP*oCard.m_DPK/(oCard.m_DPK+num);
582         }
583     }
584 
585     function GenPlayerRatio(address acc, uint dayNo) internal view returns(uint tempRatio)
586     {
587         PlayerBonus storage pb = g_Bonus.m_PlayerBonus[acc];
588         tempRatio += pb.m_DayPermanent[dayNo];
589         tempRatio += pb.m_DayStatic[dayNo];
590         tempRatio += GetPlayerDynamicRatio(acc,dayNo);
591     }
592 
593     function RefreshDayBonus() internal
594     {
595         uint todayNo = GetDayCount(now);
596         if (!NeedRefresh(todayNo)) return;
597 
598         uint tempBonus = g_Bonus.m_RecordBonus;
599         uint tempPR = g_Bonus.m_RecordPR;
600         uint tempRatio;
601         for (uint dayNo=g_Bonus.m_RecordDay; dayNo<todayNo; dayNo++)
602         {
603             tempRatio = tempPR+GenDayRatio(dayNo);
604             if (tempRatio == 0) continue;
605             DayRatio storage dr = g_Bonus.m_DayRatio[dayNo];
606             tempPR += dr.m_Permanent;
607             g_Bonus.m_DayBonus[dayNo] = tempBonus;
608             tempBonus -= tempBonus*tempRatio/BASERATIO;
609         }
610 
611         g_Bonus.m_RecordPR = tempPR;
612         g_Bonus.m_RecordDay = todayNo;
613         g_Bonus.m_RecordBonus = tempBonus;
614     }
615 
616     function QueryPlayerBonus(address acc, uint todayNo) view internal returns(uint accBonus,uint16 accPR)
617     {
618         PlayerBonus storage pb = g_Bonus.m_PlayerBonus[acc];
619         accPR = pb.m_DDPermanent;
620         accBonus = pb.m_Bonus;
621 
622         if (!PlayerNeedRefresh(acc, todayNo)) return;
623 
624         uint tempBonus = g_Bonus.m_RecordBonus;
625         uint tempPR = g_Bonus.m_RecordPR;
626         uint dayNo = pb.m_DrawedDay;
627         if (dayNo == 0) return;
628         for (; dayNo<todayNo; dayNo++)
629         {
630             uint tempRatio = tempPR+GenDayRatio(dayNo);
631             if (tempRatio == 0) continue;
632 
633             uint accRatio = accPR+GenPlayerRatio(acc,dayNo);
634             accPR += pb.m_DayPermanent[dayNo];
635 
636             DayRatio storage dr = g_Bonus.m_DayRatio[dayNo];
637             if (dayNo >= g_Bonus.m_RecordDay) {
638                 tempPR += dr.m_Permanent;
639                 accBonus += tempBonus*accRatio/BASERATIO;
640                 tempBonus -= tempBonus*tempRatio/BASERATIO;
641             }
642             else {
643                 if (accRatio == 0) continue;
644                 accBonus += g_Bonus.m_DayBonus[dayNo]*accRatio/BASERATIO;
645             }
646         }
647     }
648 
649     function GetDynamicCardAmount(uint32 iCard, uint timestamp) external view returns(uint num)
650     {
651         num = GetDynamicCardNum(iCard, GetDayCount(timestamp));
652     }
653 
654     function AddDynamicProfit(address acc, uint32 iCard, uint duration) internal
655     {
656         RefreshDayBonus();
657         uint todayNo = GetDayCount(now);
658         PlayerBonus storage pb = g_Bonus.m_PlayerBonus[acc];
659         if (pb.m_DrawedDay == 0) pb.m_DrawedDay = todayNo;
660         for (uint dayNo=todayNo; dayNo<todayNo+duration; dayNo++)
661         {
662             pb.m_DayDynamic[dayNo].push(iCard);
663             DayRatio storage dr= g_Bonus.m_DayRatio[dayNo];
664             if (dr.m_CardNum[iCard] == 0) {
665                 dr.m_DynamicCard.push(iCard);
666             }
667             dr.m_CardNum[iCard]++;
668         }
669     }
670 
671     function AddStaticProfit(address acc,uint16 ratio,uint duration) internal
672     {
673         RefreshDayBonus();
674         uint todayNo = GetDayCount(now);
675         PlayerBonus storage pb = g_Bonus.m_PlayerBonus[acc];
676         if (pb.m_DrawedDay == 0) pb.m_DrawedDay = todayNo;
677         if (duration == 0) {
678             pb.m_DayPermanent[todayNo] += ratio;
679             g_Bonus.m_DayRatio[todayNo].m_Permanent += ratio;
680         }
681         else {
682             for (uint dayNo=todayNo; dayNo<todayNo+duration; dayNo++)
683             {
684                 pb.m_DayStatic[dayNo] += ratio;
685                 g_Bonus.m_DayRatio[dayNo].m_Static += ratio;
686             }
687         }
688     }
689 
690     function ImmediateProfit(address acc, uint ratio) internal
691     {
692         RefreshDayBonus();
693         if (g_Bonus.m_RecordBonus == 0) return;
694         uint bonus = ratio*g_Bonus.m_RecordBonus/BASERATIO;
695         g_Bonus.m_RecordBonus -= bonus;
696         g_Bonus.m_RewardBonus -= bonus;
697         g_Bonus.m_PlayerBonus[acc].m_Bonus += bonus;
698     }
699 
700     function ProfitByCard(address acc, uint32 iCard) internal
701     {
702         Card storage oCard = GetCard(iCard);
703         if (oCard.m_IP > 0) {
704             ImmediateProfit(acc,oCard.m_IP);
705         }
706         else if (oCard.m_SP > 0) {
707             AddStaticProfit(acc,oCard.m_SP,oCard.m_Duration);
708         }
709         else {
710             AddDynamicProfit(acc,iCard,oCard.m_Duration);
711         }
712     }
713 
714     function QueryBonus() external view returns(uint)
715     {
716         uint todayNo = GetDayCount(now);
717         if (!NeedRefresh(todayNo)) return g_Bonus.m_RecordBonus;
718 
719         uint tempBonus = g_Bonus.m_RecordBonus;
720         uint tempPR = g_Bonus.m_RecordPR;
721         uint tempRatio;
722         for (uint dayNo=g_Bonus.m_RecordDay; dayNo<todayNo; dayNo++)
723         {
724             tempRatio = tempPR+GenDayRatio(dayNo);
725             if (tempRatio == 0) continue;
726             DayRatio storage dr = g_Bonus.m_DayRatio[dayNo];
727             tempPR += dr.m_Permanent;
728             tempBonus -= tempBonus*tempRatio/BASERATIO;
729         }
730         return tempBonus;
731     }
732 
733     function QueryMyBonus(address acc) external view returns(uint bonus)
734     {
735         (bonus,) = QueryPlayerBonus(acc, GetDayCount(now));
736     }
737 
738     function AddBonus(uint bonus) external AuthAble
739     {
740         RefreshDayBonus();
741         g_Bonus.m_RewardBonus += bonus;
742         g_Bonus.m_RecordBonus += bonus;
743     }
744 
745     function Withdraw(address acc) external OwnerAble(acc)
746     {
747         RefreshDayBonus();
748         PlayerBonus storage pb = g_Bonus.m_PlayerBonus[acc];
749         uint bonus;
750         uint todayNo = GetDayCount(now);
751         (bonus, pb.m_DDPermanent) = QueryPlayerBonus(acc, todayNo);
752         require(bonus > 0);
753         pb.m_Bonus = 0;
754         pb.m_DrawedDay = todayNo;
755         g_Bonus.m_RewardBonus -= bonus;
756         acc.transfer(bonus);
757     }
758 
759     function MasterWithdraw() external
760     {
761         uint bonus = address(this).balance-g_Bonus.m_RewardBonus;
762         require(bonus > 0);
763         receiver.transfer(bonus);
764     }
765 
766 
767 }
768 
769 
770 
771 
772 contract MainBag is BasicTime,BasicAuth,MainChip,MainCard
773 {
774     using ItemList for ItemList.Data;
775 
776     struct Bag
777     {
778         ItemList.Data m_Stuff;
779         ItemList.Data m_TempStuff;
780         ItemList.Data m_Chips;
781         ItemList.Data m_TempCards; // temporary cards
782         ItemList.Data m_PermCards; // permanent cards
783     }
784 
785     mapping(address => Bag) g_BagList;
786 
787     function GainStuff(address acc, uint32 iStuff, uint iNum) external AuthAble OwnerAble(acc)
788     {
789         Bag storage obj = g_BagList[acc];
790         obj.m_Stuff.add(iStuff,iNum);
791     }
792 
793     function CostStuff(address acc, uint32 iStuff, uint iNum) external AuthAble OwnerAble(acc)
794     {
795         Bag storage obj = g_BagList[acc];
796         obj.m_Stuff.sub(iStuff,iNum);
797     }
798 
799     function GetStuffNum(address acc, uint32 iStuff) view external returns(uint)
800     {
801         Bag storage obj = g_BagList[acc];
802         return obj.m_Stuff.get(iStuff);
803     }
804 
805     function GetStuffList(address acc) external view returns(uint32[],uint[])
806     {
807         Bag storage obj = g_BagList[acc];
808         return obj.m_Stuff.list();
809     }
810 
811     function GainTempStuff(address acc, uint32 iStuff, uint dayCnt) external AuthAble OwnerAble(acc)
812     {
813         Bag storage obj = g_BagList[acc];
814         require(obj.m_TempStuff.get(iStuff) <= now);
815         obj.m_TempStuff.set(iStuff,now+dayCnt*DAY_SECONDS);
816     }
817 
818     function GetTempStuffExpire(address acc, uint32 iStuff) external view returns(uint expire)
819     {
820         Bag storage obj = g_BagList[acc];
821         expire = obj.m_TempStuff.get(iStuff);
822     }
823 
824     function GetTempStuffList(address acc) external view returns(uint32[],uint[])
825     {
826         Bag storage obj = g_BagList[acc];
827         return obj.m_TempStuff.list();
828     }
829 
830     function GainChip(address acc, uint32 iChip,bool bGenerated) external AuthAble OwnerAble(acc)
831     {
832         if (!bGenerated) {
833             require(CanObtainChip(iChip));
834             ObtainChip(iChip);
835         }
836         Bag storage obj = g_BagList[acc];
837         obj.m_Chips.add(iChip,1);
838     }
839 
840     function CostChip(address acc, uint32 iChip) external AuthAble OwnerAble(acc)
841     {
842         Bag storage obj = g_BagList[acc];
843         obj.m_Chips.sub(iChip,1);
844         CostChip(iChip);
845     }
846 
847     function GetChipNum(address acc, uint32 iChip) external view returns(uint)
848     {
849         Bag storage obj = g_BagList[acc];
850         return obj.m_Chips.get(iChip);
851     }
852 
853     function GetChipList(address acc) external view returns(uint32[],uint[])
854     {
855         Bag storage obj = g_BagList[acc];
856         return obj.m_Chips.list();
857     }
858 
859     function GainCard2(address acc, uint32 iCard) internal
860     {
861         Card storage oCard = GetCard(iCard);
862         if (oCard.m_IP > 0) return;
863         uint i;
864         uint32 iChip;
865         Bag storage obj = g_BagList[acc];
866         if (oCard.m_Duration > 0) {
867             // temporary
868             uint expireTime = GetExpireTime(now,oCard.m_Duration);
869             for (i=0; i<oCard.m_Parts.length; i++)
870             {
871                 iChip = oCard.m_Parts[i];
872                 AddChipTempTime(iChip,expireTime);
873             }
874             obj.m_TempCards.set(iCard,expireTime);
875         }
876         else {
877             // permanent
878             for (i=0; i<oCard.m_Parts.length; i++)
879             {
880                 iChip = oCard.m_Parts[i];
881                 ObtainChip(iChip);
882             }
883             obj.m_PermCards.set(iCard,1);
884         }
885     }
886 
887     function HasCard(address acc, uint32 iCard) public view returns(bool)
888     {
889         Bag storage obj = g_BagList[acc];
890         if (obj.m_TempCards.get(iCard) > now) return true;
891         if (obj.m_PermCards.has(iCard)) return true;
892         return false;
893     }
894 
895     function GetCardList(address acc) external view returns(uint32[] tempCards, uint[] cardsTime, uint32[] permCards)
896     {
897         Bag storage obj = g_BagList[acc];
898         (tempCards,cardsTime) = obj.m_TempCards.list();
899         permCards = obj.m_PermCards.keys();
900     }
901 
902 
903 }
904 
905 
906 
907 
908 contract OldMain
909 {
910     function GetStuffList(address) external view returns(uint32[], uint[]);
911     function GetTempStuffList(address acc) external view returns(uint32[], uint[]);
912     function GetChipList(address acc) external view returns(uint32[], uint[]);
913     function GetCardList(address acc) external view returns(uint32[] tempCards, uint[] cardsTime, uint32[] permCards);
914 }
915 
916 contract Main is MainChip,MainCard,MainBag,MainBonus
917 {
918     using ItemList for ItemList.Data;
919 
920     constructor(address Receiver) public MainBonus(Receiver) {}
921 
922     ///==================================================================
923     bool g_Synced = false;
924     function SyncOldData(OldMain oldMain, address[] accounts) external CreatorAble
925     {
926         // transfer itemdata
927         require(!g_Synced);
928         g_Synced = true;
929         for (uint i=0; i<accounts.length; i++)
930         {
931             address acc = accounts[i];
932             SyncStuff(oldMain, acc);
933             SyncTempStuff(oldMain, acc);
934             SyncChip(oldMain, acc);
935             SyncCard(oldMain, acc);
936         }
937     }
938 
939     function SyncItemData(ItemList.Data storage Data, uint32[] idxList, uint[] valList) internal
940     {
941         if (idxList.length == 0) return;
942         for (uint i=0; i<idxList.length; i++)
943         {
944             uint32 index = idxList[i];
945             uint val = valList[i];
946             Data.set(index, val);
947         }
948     }
949 
950     function SyncStuff(OldMain oldMain, address acc) internal
951     {
952         (uint32[] memory idxList, uint[] memory valList) = oldMain.GetStuffList(acc);
953         SyncItemData(g_BagList[acc].m_Stuff, idxList, valList);
954     }
955 
956     function SyncTempStuff(OldMain oldMain, address acc) internal
957     {
958         (uint32[] memory idxList, uint[] memory valList) = oldMain.GetTempStuffList(acc);
959         SyncItemData(g_BagList[acc].m_TempStuff, idxList, valList);
960     }
961 
962     function SyncChip(OldMain oldMain, address acc) internal
963     {
964         (uint32[] memory idxList, uint[] memory valList) = oldMain.GetChipList(acc);
965         SyncItemData(g_BagList[acc].m_Chips, idxList, valList);
966     }
967 
968     function CompensateChips(address acc, uint32[] idxList) internal
969     {
970         for (uint i=0; i<idxList.length; i++)
971         {
972             uint32 iCard = idxList[i];
973             if (iCard == 0) return;
974             Card storage obj = GetCard(iCard);
975             for (uint j=0; j<obj.m_Parts.length; j++)
976             {
977                 uint32 iChip = obj.m_Parts[j];
978                 g_BagList[acc].m_Chips.add(iChip,1);
979             }
980         }
981     }
982 
983     function SyncCard(OldMain oldMain, address acc) internal
984     {
985         (uint32[] memory idxList, uint[] memory valList ,uint32[] memory permCards) = oldMain.GetCardList(acc);
986         uint32[] memory allCards = new uint32[](idxList.length+permCards.length);
987         uint i=0;
988         uint j=0;
989         for (j=0; j<idxList.length; j++)
990         {
991             uint expire = valList[j];
992             if (expire < now) continue;
993             allCards[i] = idxList[j];
994             i++;
995         }
996         for (j=0; j<permCards.length; j++)
997         {
998             allCards[i] = permCards[j];
999             i++;
1000         }
1001         CompensateChips(acc, allCards);
1002     }
1003 
1004     ///==================================================================
1005 
1006     function InsertCard(uint32 iCard, uint32 duration, uint8 level, uint16 dp, uint16 dpk, uint16 sp, uint16 ip, uint32[] parts) external CreatorAble
1007     {
1008         require(!CardExists(iCard));
1009         require(level<=HEROLEVEL_MAX && level>=HEROLEVEL_MIN);
1010         require(GetPartNum(level) == parts.length);
1011         AddNewCard(iCard, duration, level, dp, dpk, sp, ip, parts);
1012         for (uint8 iPart=1; iPart<=parts.length; iPart++)
1013         {
1014             uint idx = iPart-1;
1015             uint32 iChip = parts[idx];
1016             uint8 limit = GetPartLimit(level, iPart);
1017             AddNewChip(iChip, level, limit, iPart);
1018         }
1019     }
1020 
1021     function GainCard(address acc, uint32 iCard) external AuthAble OwnerAble(acc)
1022     {
1023         require(CardExists(iCard) && !HasCard(acc,iCard));
1024         GainCard2(acc,iCard);
1025         ProfitByCard(acc,iCard);
1026     }
1027 
1028     function GetDynamicCardAmountList(address acc) external view returns(uint[] amountList)
1029     {
1030         Bag storage oBag = g_BagList[acc];
1031         uint len = oBag.m_TempCards.m_List.length;
1032         amountList = new uint[](len);
1033         for (uint i=0; i<len; i++)
1034         {
1035             uint32 iCard = oBag.m_TempCards.m_List[i];
1036             amountList[i] = GetDynamicCardNum(iCard,GetDayCount(now));
1037         }
1038     }
1039 
1040     function GenChipByRandomWeight(uint random, uint8 level, uint[] extWeight) external AuthAble returns(uint32 iChip)
1041     {
1042         RefreshChipUnableList(level);
1043         iChip = GenChipByWeight(random,level,extWeight);
1044         ObtainChip(iChip);
1045     }
1046 
1047     function CheckGenChip(uint32 iChip) external view returns(bool)
1048     {
1049         return CanObtainChip(iChip);
1050     }
1051 
1052     function GenChip(uint32 iChip) external AuthAble
1053     {
1054         require(CanObtainChip(iChip));
1055         ObtainChip(iChip);
1056     }
1057 
1058 }
1059 
1060 
1061 
1062 
1063 contract StoreChipBag is BasicAuth
1064 {
1065 
1066     mapping(address => uint32[]) g_ChipBag;
1067 
1068     function AddChip(address acc, uint32 iChip) external OwnerAble(acc) AuthAble
1069     {
1070         g_ChipBag[acc].push(iChip);
1071     }
1072 
1073     function CollectChips(address acc) external OwnerAble(acc) AuthAble returns(uint32[] chips)
1074     {
1075         chips = g_ChipBag[acc];
1076         delete g_ChipBag[acc];
1077     }
1078 
1079     function GetChipsInfo(address acc) external view returns(uint32[] chips)
1080     {
1081         chips = g_ChipBag[acc];
1082     }
1083 
1084 }
1085 
1086 
1087 
1088 
1089 contract StoreGift is BasicAuth
1090 {
1091     struct Gift
1092     {
1093         string m_Key;
1094         uint m_Expire;
1095         uint32[] m_ItemIdxList;
1096         uint[] m_ItemNumlist;
1097     }
1098 
1099     mapping(address => mapping(string => bool)) g_Exchange;
1100     mapping(string => Gift) g_Gifts;
1101 
1102     function HasGift(string key) public view returns(bool)
1103     {
1104         Gift storage obj = g_Gifts[key];
1105         if (bytes(obj.m_Key).length == 0) return false;
1106         if (obj.m_Expire!=0 && obj.m_Expire<now) return false;
1107         return true;
1108     }
1109 
1110     function AddGift(string key, uint expire, uint32[] idxList, uint[] numList) external CreatorAble
1111     {
1112         require(!HasGift(key));
1113         require(now<expire || expire==0);
1114         g_Gifts[key] = Gift({
1115             m_Key           : key,
1116             m_Expire        : expire,
1117             m_ItemIdxList   : idxList,
1118             m_ItemNumlist   : numList
1119         });
1120     }
1121 
1122     function DelGift(string key) external CreatorAble
1123     {
1124         delete g_Gifts[key];
1125     }
1126 
1127     function GetGiftInfo(string key) external view returns(uint, uint32[], uint[])
1128     {
1129         Gift storage obj = g_Gifts[key];
1130         return (obj.m_Expire, obj.m_ItemIdxList, obj.m_ItemNumlist);
1131     }
1132 
1133     function Exchange(address acc, string key) external OwnerAble(acc) AuthAble
1134     {
1135         g_Exchange[acc][key] = true;
1136     }
1137 
1138     function IsExchanged(address acc, string key) external view returns(bool)
1139     {
1140         return g_Exchange[acc][key];
1141     }
1142 
1143 }
1144 
1145 
1146 
1147 
1148 contract StoreGoods is BasicAuth
1149 {
1150     using ItemList for ItemList.Data;
1151 
1152     struct Goods
1153     {
1154         uint32 m_Index;
1155         uint32 m_CostItem;
1156         uint32 m_ItemRef;
1157         uint32 m_Amount;
1158         uint32 m_Duration;
1159         uint32 m_Expire;
1160         uint8 m_PurchaseLimit;
1161         uint8 m_DiscountLimit;
1162         uint8 m_DiscountRate;
1163         uint m_CostNum;
1164     }
1165 
1166     mapping(uint32 => Goods) g_Goods;
1167     mapping(address => ItemList.Data) g_PurchaseInfo;
1168 
1169     function AddGoods(uint32 iGoods, uint32 costItem, uint price, uint32 itemRef, uint32 amount, uint32 duration, uint32 expire, uint8 limit, uint8 disCount, uint8 disRate) external CreatorAble
1170     {
1171         require(!HasGoods(iGoods));
1172         g_Goods[iGoods] = Goods({
1173             m_Index         :iGoods,
1174             m_CostItem      :costItem,
1175             m_ItemRef       :itemRef,
1176             m_CostNum       :price,
1177             m_Amount        :amount,
1178             m_Duration      :duration,
1179             m_Expire        :expire,
1180             m_PurchaseLimit :limit,
1181             m_DiscountLimit :disCount,
1182             m_DiscountRate  :disRate
1183         });
1184     }
1185 
1186     function DelGoods(uint32 iGoods) external CreatorAble
1187     {
1188         delete g_Goods[iGoods];
1189     }
1190 
1191     function HasGoods(uint32 iGoods) public view returns(bool)
1192     {
1193         Goods storage obj = g_Goods[iGoods];
1194         return obj.m_Index == iGoods;
1195     }
1196 
1197     function GetGoodsInfo(uint32 iGoods) external view returns(
1198         uint32,uint32,uint32,uint32,uint32,uint,uint8,uint8,uint8
1199     )
1200     {
1201         Goods storage obj = g_Goods[iGoods];
1202         return (
1203             obj.m_Index,
1204             obj.m_CostItem,
1205             obj.m_ItemRef,
1206             obj.m_Amount,
1207             obj.m_Duration,
1208             obj.m_CostNum,
1209             obj.m_PurchaseLimit,
1210             obj.m_DiscountLimit,
1211             obj.m_DiscountRate
1212         );
1213     }
1214 
1215     function GetRealCost(address acc, uint32 iGoods) external view returns(uint)
1216     {
1217         Goods storage obj = g_Goods[iGoods];
1218         if (g_PurchaseInfo[acc].get(iGoods) >= obj.m_DiscountLimit) {
1219             return obj.m_CostNum;
1220         }
1221         else {
1222             return obj.m_CostNum * obj.m_DiscountRate / 100;
1223         }
1224     }
1225 
1226     function BuyGoods(address acc, uint32 iGoods) external OwnerAble(acc) AuthAble
1227     {
1228         g_PurchaseInfo[acc].add(iGoods,1);
1229     }
1230 
1231     function IsOnSale(uint32 iGoods) external view returns(bool)
1232     {
1233         Goods storage obj = g_Goods[iGoods];
1234         if (obj.m_Expire == 0) return true;
1235         if (obj.m_Expire >= now) return true;
1236         return false;
1237     }
1238 
1239     function CheckPurchaseCount(address acc, uint32 iGoods) external view returns(bool)
1240     {
1241         Goods storage obj = g_Goods[iGoods];
1242         if (obj.m_PurchaseLimit == 0) return true;
1243         if (g_PurchaseInfo[acc].get(iGoods) < obj.m_PurchaseLimit) return true;
1244         return false;
1245     }
1246 
1247     function GetPurchaseInfo(address acc) external view returns(uint32[], uint[])
1248     {
1249         return g_PurchaseInfo[acc].list();
1250     }
1251 
1252 }
1253 
1254 
1255 
1256 
1257 contract Child is Base {
1258 
1259     Main g_Main;
1260 
1261     constructor(Main main) public
1262     {
1263         require(main != address(0));
1264         g_Main = main;
1265         g_Main.SetAuth(this);
1266     }
1267 
1268     function kill() external CreatorAble
1269     {
1270         g_Main.ClearAuth(this);
1271         selfdestruct(creator);
1272     }
1273 
1274     function AddBonus(uint percent) internal
1275     {
1276         address(g_Main).transfer(msg.value);
1277         g_Main.AddBonus(msg.value * percent / 100);
1278     }
1279 
1280     function GenRandom(uint seed,uint base) internal view returns(uint,uint)
1281     {
1282         uint r = uint(keccak256(abi.encodePacked(msg.sender,seed,now)));
1283         if (base != 0) r %= base;
1284         return (r,seed+1);
1285     }
1286 
1287 }
1288 
1289 
1290 
1291 
1292 contract Store is Child
1293 {
1294     uint constant BONUS_PERCENT_PURCHASE = 80;
1295     uint constant CHIPGIFT_NORMALCHIP_RATE = 10000;
1296     uint32 constant CHIPGIFT_ITEMINDEX = 24001;
1297 
1298     uint8 constant EXCHANGE_OK = 0;
1299     uint8 constant EXCHANGE_KEYERR = 1;
1300     uint8 constant EXCHANGE_HADGOT = 2;
1301 
1302     StoreGift g_Gifts;
1303     StoreGoods g_Goods;
1304     StoreChipBag g_ChipBag;
1305 
1306     constructor(Main main, StoreGoods goods, StoreGift gifts, StoreChipBag chipbag) public Child(main)
1307     {
1308         g_Goods = goods;
1309         g_Gifts = gifts;
1310         g_ChipBag = chipbag;
1311         g_Goods.SetAuth(this);
1312         g_Gifts.SetAuth(this);
1313         g_ChipBag.SetAuth(this);
1314     }
1315     
1316     function kill() external CreatorAble
1317     {
1318         g_Goods.ClearAuth(this);
1319     }
1320 
1321     function GenExtWeightList(uint8 level) internal pure returns(uint[] extList)
1322     {
1323         uint partNum = GetPartNum(level);
1324         extList = new uint[](partNum);
1325         for (uint i=0; i<partNum; i++)
1326         {
1327             uint iPart = i+1;
1328             if (!IsLimitPart(level,iPart)) {
1329                 extList[i] = GetPartWeight(level, iPart)*CHIPGIFT_NORMALCHIP_RATE;
1330             }
1331         }
1332     }
1333 
1334     function GiveChipGitf() internal
1335     {
1336         for (uint8 level=HEROLEVEL_MIN; level<=HEROLEVEL_MAX; level++)
1337         {
1338             (uint random,) = GenRandom(level, 0);
1339             uint32 iChip = g_Main.GenChipByRandomWeight(random, level, GenExtWeightList(level));
1340             g_ChipBag.AddChip(msg.sender,iChip);
1341         }
1342     }
1343 
1344     function BuyGoods(uint32 iGoods) external payable
1345     {
1346         require(g_Goods.HasGoods(iGoods));
1347         require(g_Goods.IsOnSale(iGoods));
1348         require(g_Goods.CheckPurchaseCount(msg.sender, iGoods));
1349         (,uint32 iCostItem,uint32 iItemRef,uint32 iAmount,uint32 iDuration,,,,) = g_Goods.GetGoodsInfo(iGoods);
1350         uint iCostNum = g_Goods.GetRealCost(msg.sender, iGoods);
1351         if (iCostItem == 0) {
1352             // cost ether(wei)
1353             require(msg.value == iCostNum);
1354             AddBonus(BONUS_PERCENT_PURCHASE);
1355         }
1356         else {
1357             // cost other stuff
1358             g_Main.CostStuff(msg.sender,iCostItem,iCostNum);
1359         }
1360         g_Goods.BuyGoods(msg.sender, iGoods);
1361         if (iItemRef == CHIPGIFT_ITEMINDEX) {
1362             GiveChipGitf();
1363         }
1364         else {
1365             if (iDuration == 0) {
1366                 g_Main.GainStuff(msg.sender, iItemRef, iAmount);
1367             }
1368             else {
1369                 g_Main.GainTempStuff(msg.sender, iItemRef, iDuration);
1370             }
1371         }
1372     }
1373 
1374     function CheckExchange(string key) public view returns(uint8)
1375     {
1376         if (!g_Gifts.HasGift(key)) return EXCHANGE_KEYERR;
1377         if (g_Gifts.IsExchanged(msg.sender, key)) return EXCHANGE_HADGOT;
1378         return EXCHANGE_OK;
1379     }
1380 
1381     function ExchangeGift(string key) external
1382     {
1383         require(CheckExchange(key) == EXCHANGE_OK);
1384         g_Gifts.Exchange(msg.sender, key);
1385         (, uint32[] memory idxList, uint[] memory numList) = g_Gifts.GetGiftInfo(key);
1386         for (uint i=0; i<idxList.length; i++)
1387         {
1388             g_Main.GainStuff(msg.sender, idxList[i], numList[i]);
1389         }
1390     }
1391 
1392     function CollectChipBag() external
1393     {
1394         uint32[] memory chips = g_ChipBag.CollectChips(msg.sender);
1395         require(chips.length > 0);
1396         for (uint i=0; i<chips.length; i++)
1397         {
1398             g_Main.GainChip(msg.sender, chips[i], true);
1399         }
1400     }
1401 
1402     function GetStoreInfo() external view returns(uint32[] goodsList, uint[] purchaseCountList, uint32[] chips)
1403     {
1404         (goodsList, purchaseCountList) = g_Goods.GetPurchaseInfo(msg.sender);
1405         chips = g_ChipBag.GetChipsInfo(msg.sender);
1406     }
1407 
1408 }