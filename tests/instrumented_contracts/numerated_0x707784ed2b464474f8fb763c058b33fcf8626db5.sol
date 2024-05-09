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
98 library IndexList
99 {
100     function insert(uint32[] storage self, uint32 index, uint pos) external
101     {
102         require(self.length >= pos);
103         self.length++;
104         for (uint i=self.length; i>pos; i++)
105         {
106             self[i+1] = self[i];
107         }
108         self[pos] = index;
109     }
110 
111     function remove(uint32[] storage self, uint32 index) external returns(bool)
112     {
113         return remove(self,index,0);
114     }
115 
116     function remove(uint32[] storage self, uint32 index, uint startPos) public returns(bool)
117     {
118         for (uint i=startPos; i<self.length; i++)
119         {
120             if (self[i] != index) continue;
121             for (uint j=i; j<self.length-1; j++)
122             {
123                 self[j] = self[j+1];
124             }
125             delete self[self.length-1];
126             self.length--;
127             return true;
128         }
129         return false;
130     }
131 
132 }
133 
134 
135 
136 
137 contract MainCard is BasicAuth
138 {
139     struct Card {
140         uint32 m_Index;
141         uint32 m_Duration;
142         uint8 m_Level;
143         uint16 m_DP;  //DynamicProfit
144         uint16 m_DPK; //K is coefficient
145         uint16 m_SP;  //StaticProfit
146         uint16 m_IP;  //ImmediateProfit
147         uint32[] m_Parts;
148     }
149 
150     struct CardLib {
151         uint32[] m_List;
152         mapping(uint32 => Card) m_Lib;
153     }
154 
155     CardLib g_CardLib;
156 
157     function AddNewCard(uint32 iCard, uint32 duration, uint8 level, uint16 dp, uint16 dpk, uint16 sp, uint16 ip, uint32[] parts) internal
158     {
159         g_CardLib.m_List.push(iCard);
160         g_CardLib.m_Lib[iCard] = Card({
161             m_Index   : iCard,
162             m_Duration: duration,
163             m_Level   : level,
164             m_DP      : dp,
165             m_DPK     : dpk,
166             m_SP      : sp,
167             m_IP      : ip,
168             m_Parts   : parts
169         });
170     }
171 
172     function CardExists(uint32 iCard) public view returns(bool)
173     {
174         Card storage obj = g_CardLib.m_Lib[iCard];
175         return obj.m_Index == iCard;
176     }
177 
178     function GetCard(uint32 iCard) internal view returns(Card storage)
179     {
180         return g_CardLib.m_Lib[iCard];
181     }
182 
183     function GetCardInfo(uint32 iCard) external view returns(uint32, uint32, uint8, uint16, uint16, uint16, uint16, uint32[])
184     {
185         Card storage obj = GetCard(iCard);
186         return (obj.m_Index, obj.m_Duration, obj.m_Level, obj.m_DP, obj.m_DPK, obj.m_SP, obj.m_IP, obj.m_Parts);
187     }
188 
189     function GetExistsCardList() external view returns(uint32[])
190     {
191         return g_CardLib.m_List;
192     }
193 
194 }
195 
196 
197 
198 
199 contract MainChip is BasicAuth
200 {
201     using IndexList for uint32[];
202 
203     struct Chip
204     {
205         uint8 m_Level;
206         uint8 m_LimitNum;
207         uint8 m_Part;
208         uint32 m_Index;
209         uint256 m_UsedNum;
210     }
211 
212     struct PartManager
213     {
214         uint32[] m_IndexList;   //index list, player can obtain
215         uint32[] m_UnableList;  //player can't obtain
216     }
217 
218     struct ChipLib
219     {
220         uint32[] m_List;
221         mapping(uint32 => Chip) m_Lib;
222         mapping(uint32 => uint[]) m_TempList;
223         mapping(uint8 => mapping(uint => PartManager)) m_PartMap;//level -> level list
224     }
225 
226     ChipLib g_ChipLib;
227 
228     function AddNewChip(uint32 iChip, uint8 lv, uint8 limit, uint8 part) internal
229     {
230         require(!ChipExists(iChip));
231         g_ChipLib.m_List.push(iChip);
232         g_ChipLib.m_Lib[iChip] = Chip({
233             m_Index       : iChip,
234             m_Level       : lv,
235             m_LimitNum    : limit,
236             m_Part        : part,
237             m_UsedNum     : 0
238         });
239         PartManager storage pm = GetPartManager(lv,part);
240         pm.m_IndexList.push(iChip);
241     }
242 
243     function GetChip(uint32 iChip) internal view returns(Chip storage)
244     {
245         return g_ChipLib.m_Lib[iChip];
246     }
247 
248     function GetPartManager(uint8 level, uint iPart) internal view returns(PartManager storage)
249     {
250         return g_ChipLib.m_PartMap[level][iPart];
251     }
252 
253     function ChipExists(uint32 iChip) public view returns(bool)
254     {
255         Chip storage obj = GetChip(iChip);
256         return obj.m_Index == iChip;
257     }
258 
259     function GetChipUsedNum(uint32 iChip) internal view returns(uint)
260     {
261         Chip storage obj = GetChip(iChip);
262         uint[] memory tempList = g_ChipLib.m_TempList[iChip];
263         uint num = tempList.length;
264         for (uint i=num; i>0; i--)
265         {
266             if(tempList[i-1]<=now) {
267                 num -= i;
268                 break;
269             }
270         }
271         return obj.m_UsedNum + num;
272     }
273 
274     function CanObtainChip(uint32 iChip) internal view returns(bool)
275     {
276         Chip storage obj = GetChip(iChip);
277         if (obj.m_LimitNum == 0) return true;
278         if (GetChipUsedNum(iChip) < obj.m_LimitNum) return true;
279         return false;
280     }
281 
282     function CostChip(uint32 iChip) internal
283     {
284         BeforeChipCost(iChip);
285         Chip storage obj = GetChip(iChip);
286         obj.m_UsedNum--;
287     }
288 
289     function ObtainChip(uint32 iChip) internal
290     {
291         BeforeChipObtain(iChip);
292         Chip storage obj = GetChip(iChip);
293         obj.m_UsedNum++;
294     }
295 
296     function BeforeChipObtain(uint32 iChip) internal
297     {
298         Chip storage obj = GetChip(iChip);
299         if (obj.m_LimitNum == 0) return;
300         uint usedNum = GetChipUsedNum(iChip);
301         require(obj.m_LimitNum >= usedNum+1);
302         if (obj.m_LimitNum == usedNum+1) {
303             PartManager storage pm = GetPartManager(obj.m_Level,obj.m_Part);
304             if (pm.m_IndexList.remove(iChip)){
305                 pm.m_UnableList.push(iChip);
306             }
307         }
308     }
309 
310     function BeforeChipCost(uint32 iChip) internal
311     {
312         Chip storage obj = GetChip(iChip);
313         if (obj.m_LimitNum == 0) return;
314         uint usedNum = GetChipUsedNum(iChip);
315         require(obj.m_LimitNum >= usedNum);
316         if (obj.m_LimitNum == usedNum) {
317             PartManager storage pm = GetPartManager(obj.m_Level,obj.m_Part);
318             if (pm.m_UnableList.remove(iChip)) {
319                 pm.m_IndexList.push(iChip);
320             }
321         }
322     }
323 
324     function AddChipTempTime(uint32 iChip, uint expireTime) internal
325     {
326         uint[] storage list = g_ChipLib.m_TempList[iChip];
327         require(list.length==0 || expireTime>=list[list.length-1]);
328         BeforeChipObtain(iChip);
329         list.push(expireTime);
330     }
331 
332     function RefreshChipUnableList(uint8 level) internal
333     {
334         uint partNum = GetPartNum(level);
335         for (uint iPart=1; iPart<=partNum; iPart++)
336         {
337             PartManager storage pm = GetPartManager(level,iPart);
338             for (uint i=pm.m_UnableList.length; i>0; i--)
339             {
340                 uint32 iChip = pm.m_UnableList[i-1];
341                 if (CanObtainChip(iChip)) {
342                     pm.m_IndexList.push(iChip);
343                     pm.m_UnableList.remove(iChip,i-1);
344                 }
345             }
346         }
347     }
348 
349     function GenChipByWeight(uint random, uint8 level, uint[] extWeight) internal view returns(uint32)
350     {
351         uint partNum = GetPartNum(level);
352         uint allWeight;
353         uint[] memory newWeight = new uint[](partNum+1);
354         uint[] memory realWeight = new uint[](partNum+1);
355         for (uint iPart=1; iPart<=partNum; iPart++)
356         {
357             PartManager storage pm = GetPartManager(level,iPart);
358             uint curWeight = extWeight[iPart-1]+GetPartWeight(level,iPart);
359             allWeight += pm.m_IndexList.length*curWeight;
360             newWeight[iPart] = allWeight;
361             realWeight[iPart] = curWeight;
362         }
363 
364         uint weight = random % allWeight;
365         for (iPart=1; iPart<=partNum; iPart++)
366         {
367             if (weight >= newWeight[iPart]) continue;
368             pm = GetPartManager(level,iPart);
369             uint idx = (weight-newWeight[iPart-1])/realWeight[iPart];
370             return pm.m_IndexList[idx];
371         }
372     }
373 
374     function GetChipInfo(uint32 iChip) external view returns(uint32, uint8, uint8, uint, uint8, uint)
375     {
376         Chip storage obj = GetChip(iChip);
377         return (obj.m_Index, obj.m_Level, obj.m_LimitNum, GetPartWeight(obj.m_Level,obj.m_Part), obj.m_Part, GetChipUsedNum(iChip));
378     }
379 
380     function GetExistsChipList() external view returns(uint32[])
381     {
382         return g_ChipLib.m_List;
383     }
384 
385 }
386 
387 
388 
389 
390 contract BasicTime
391 {
392     uint constant DAY_SECONDS = 60 * 60 * 24;
393 
394     function GetDayCount(uint timestamp) pure internal returns(uint)
395     {
396         return timestamp/DAY_SECONDS;
397     }
398 
399     function GetExpireTime(uint timestamp, uint dayCnt) pure internal returns(uint)
400     {
401         uint dayEnd = GetDayCount(timestamp) + dayCnt;
402         return dayEnd * DAY_SECONDS;
403     }
404 
405 }
406 
407 
408 
409 
410 library ItemList {
411 
412     struct Data {
413         uint32[] m_List;
414         mapping(uint32 => uint) m_Maps;
415     }
416 
417     function set(Data storage self, uint32 key, uint num) public
418     {
419         if (!has(self,key)) {
420             if (num == 0) return;
421             self.m_List.push(key);
422             self.m_Maps[key] = num;
423         }
424         else if (num == 0) {
425             delete self.m_Maps[key];
426         } 
427         else {
428             uint old = self.m_Maps[key];
429             if (old == num) return;
430             self.m_Maps[key] = num;
431         }
432     }
433 
434     function add(Data storage self, uint32 key, uint num) external
435     {
436         uint iOld = get(self,key);
437         uint iNow = iOld+num;
438         require(iNow >= iOld);
439         set(self,key,iNow);
440     }
441 
442     function sub(Data storage self, uint32 key, uint num) external
443     {
444         uint iOld = get(self,key);
445         require(iOld >= num);
446         set(self,key,iOld-num);
447     }
448 
449     function has(Data storage self, uint32 key) public view returns(bool)
450     {
451         return self.m_Maps[key] > 0;
452     }
453 
454     function get(Data storage self, uint32 key) public view returns(uint)
455     {
456         return self.m_Maps[key];
457     }
458 
459     function list(Data storage self) view external returns(uint32[],uint[])
460     {
461         uint len = self.m_List.length;
462         uint[] memory values = new uint[](len);
463         for (uint i=0; i<len; i++)
464         {
465             uint32 key = self.m_List[i];
466             values[i] = self.m_Maps[key];
467         }
468         return (self.m_List,values);
469     }
470 
471     function isEmpty(Data storage self) view external returns(bool)
472     {
473         return self.m_List.length == 0;
474     }
475 
476     function keys(Data storage self) view external returns(uint32[])
477     {
478         return self.m_List;
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
1063 contract OldProductionBoiler
1064 {
1065     function GetBoilerInfo(address acc, uint idx) external view returns(uint, uint32[]);
1066 }
1067 
1068 contract ProductionBoiler is BasicAuth
1069 {
1070 
1071     struct Boiler
1072     {
1073         uint m_Expire;
1074         uint32[] m_Chips;
1075     }
1076 
1077     mapping(address => mapping(uint => Boiler)) g_Boilers;
1078 
1079     bool g_Synced = false;
1080     function SyncOldData(OldProductionBoiler oldBoiler, address[] accounts) external CreatorAble
1081     {
1082         require(!g_Synced);
1083         g_Synced = true;
1084         for (uint i=0; i<accounts.length; i++)
1085         {
1086             address acc = accounts[i];
1087             for (uint idx=0; idx<3; idx++)
1088             {
1089                 (uint expire, uint32[] memory chips) = oldBoiler.GetBoilerInfo(acc,idx);
1090                 if (expire == 0) continue;
1091                 g_Boilers[acc][idx].m_Expire = expire;
1092                 g_Boilers[acc][idx].m_Chips = chips;
1093             }
1094         }
1095     }
1096 
1097     //=========================================================================
1098     function IsBoilerValid(address acc, uint idx) external view returns(bool)
1099     {
1100         Boiler storage obj = g_Boilers[acc][idx];
1101         if (obj.m_Chips.length > 0) return false;
1102         return true;
1103     }
1104 
1105     function IsBoilerExpire(address acc, uint idx) external view returns(bool)
1106     {
1107         Boiler storage obj = g_Boilers[acc][idx];
1108         return obj.m_Expire <= now;
1109     }
1110 
1111     //=========================================================================
1112 
1113     function GenerateChips(address acc, uint idx, uint cd, uint32[] chips) external AuthAble OwnerAble(acc)
1114     {
1115         Boiler storage obj = g_Boilers[acc][idx];
1116         obj.m_Expire = cd+now;
1117         obj.m_Chips = chips;
1118     }
1119 
1120     function CollectChips(address acc, uint idx) external AuthAble OwnerAble(acc) returns(uint32[] chips)
1121     {
1122         Boiler storage obj = g_Boilers[acc][idx];
1123         chips = obj.m_Chips;
1124         delete g_Boilers[acc][idx];
1125     }
1126 
1127     function GetBoilerInfo(address acc, uint idx) external view returns(uint, uint32[])
1128     {
1129         Boiler storage obj = g_Boilers[acc][idx];
1130         return (obj.m_Expire,obj.m_Chips);
1131     }
1132 
1133 }
1134 
1135 
1136 
1137 
1138 contract Child is Base {
1139 
1140     Main g_Main;
1141 
1142     constructor(Main main) public
1143     {
1144         require(main != address(0));
1145         g_Main = main;
1146         g_Main.SetAuth(this);
1147     }
1148 
1149     function kill() external CreatorAble
1150     {
1151         g_Main.ClearAuth(this);
1152         selfdestruct(creator);
1153     }
1154 
1155     function AddBonus(uint percent) internal
1156     {
1157         address(g_Main).transfer(msg.value);
1158         g_Main.AddBonus(msg.value * percent / 100);
1159     }
1160 
1161     function GenRandom(uint seed,uint base) internal view returns(uint,uint)
1162     {
1163         uint r = uint(keccak256(abi.encodePacked(msg.sender,seed,now)));
1164         if (base != 0) r %= base;
1165         return (r,seed+1);
1166     }
1167 
1168 }
1169 
1170 
1171 
1172 
1173 contract Production is Child {
1174 
1175     uint32 constant STUFF_IDX_POINT = 22001;
1176     uint32 constant STUFF_IDX_GENRAL = 21000;
1177     uint32 constant STUFF_IDX_EXTRA = 21004;
1178 
1179     uint32 constant PERMISSION_1 = 23002;
1180     uint32 constant PERMISSION_2 = 23003;
1181 
1182     uint constant BASERATIO = 10000;
1183     uint constant BOILER_FREE_IDX = 0;
1184     uint constant BOILER_MAX_NUM = 3;
1185 
1186     uint constant CREATE_COST_MIN = 30;
1187     uint constant CREATE_COST_FEW = 60;
1188     uint constant CREATE_COST_MANY = 150;
1189     uint constant CREATE_COST_MAX = 300;
1190 
1191     uint constant COOLTIME_MIN = 60 * 60;
1192     uint constant COOLTIME_MID = 60 * 60 * 2;
1193     uint constant COOLTIME_MAX = 60 * 60 * 4;
1194 
1195     uint constant ACCELERATE_UNITTIME = 60 * 5;
1196     uint constant ACCELERATE_UNITFEE = 0.0013 ether;
1197     uint constant BONUS_PERCENT_ACCELERATE = 80;
1198 
1199     ProductionBoiler g_Boilers;
1200 
1201     constructor(Main main, ProductionBoiler pb) public Child(main)
1202     {
1203         g_Boilers = pb;
1204         g_Boilers.SetAuth(this);
1205     }
1206 
1207     function kill() external CreatorAble
1208     {
1209         g_Boilers.ClearAuth(this);
1210     }
1211 
1212     function GenChipIndex(
1213         uint seed,
1214         uint8 level,
1215         uint[] extWeight3,
1216         uint[] extWeight4,
1217         uint[] extWeight5
1218     ) internal returns(uint32,uint)
1219     {
1220         uint random;
1221         (random,seed) = GenRandom(seed,0);
1222         if (level==1 || level==2) {
1223             return (g_Main.GenChipByRandomWeight(random,level,extWeight3),seed);
1224         }
1225         else if (level==3 || level==4) {
1226             return (g_Main.GenChipByRandomWeight(random,level,extWeight4),seed);
1227         }
1228         else {
1229             return (g_Main.GenChipByRandomWeight(random,level,extWeight5),seed);
1230         }
1231     }
1232 
1233     function GenChipLevel_Special(uint costAll, uint x, uint seed) internal view returns(uint8,uint)
1234     {
1235         uint8 outLv;
1236         uint random;
1237         if (costAll <= CREATE_COST_FEW) {
1238             outLv = 3;
1239         }
1240         else {
1241             (random,seed) = GenRandom(seed,BASERATIO);
1242             uint baseR = BASERATIO*x/100;
1243             if (costAll <= CREATE_COST_MANY) {
1244                 baseR /= 10;
1245                 if (random <= BASERATIO*80/100-baseR) {
1246                     outLv = 3;
1247                 }
1248                 else if (random <= BASERATIO-baseR/4) {
1249                     outLv = 4;
1250                 }
1251                 else {
1252                     outLv = 5;
1253                 }
1254             }
1255             else {
1256                 baseR /= 10;
1257                 if (random <= BASERATIO*70/100-baseR) {
1258                     outLv = 3;
1259                 }
1260                 else if (random <= BASERATIO*95/100-baseR/5) {
1261                     outLv = 4;
1262                 }
1263                 else {
1264                     outLv = 5;
1265                 }
1266             }
1267         }
1268         return (outLv,seed);
1269     }
1270 
1271     function GenChipLevel_Extra(uint costAll, uint x, uint seed) internal view returns(uint8,uint)
1272     {
1273         uint8 outLv;
1274         uint random;
1275         uint baseR = BASERATIO*x/100;
1276         (random,seed) = GenRandom(seed,BASERATIO);
1277         if (costAll <= CREATE_COST_FEW) {
1278             baseR /= 4;
1279             if (random <= BASERATIO*80/100-baseR) {
1280                 outLv = 1;
1281             }
1282             else if (random <= BASERATIO*98/100-baseR*3/4) {
1283                 outLv = 2;
1284             }
1285             else if (random <= BASERATIO-baseR/4) {
1286                 outLv = 3;
1287             }
1288             else {
1289                 outLv = 4;
1290             }
1291         }
1292         else if (costAll <= CREATE_COST_MANY) {
1293             baseR /= 10;
1294             if (random <= BASERATIO*55/100-baseR) {
1295                 outLv = 1;
1296             }
1297             else if (random <= BASERATIO*85/100-baseR*4/5) {
1298                 outLv = 2;
1299             }
1300             else if (random <= BASERATIO*95/100-baseR*2/5) {
1301                 outLv = 3;
1302             }
1303             else if (random <= BASERATIO-baseR/5) {
1304                 outLv = 4;
1305             }
1306             else {
1307                 outLv = 5;
1308             }
1309         }
1310         else {
1311             baseR /= 10;
1312             if (random <= BASERATIO*30/100-baseR/2) {
1313                 outLv = 1;
1314             }
1315             else if (random <= BASERATIO*75/100-baseR) {
1316                 outLv = 2;
1317             }
1318             else if (random <= BASERATIO*88/100-baseR*4/7) {
1319                 outLv = 3;
1320             }
1321             else if (random <= BASERATIO*97/100-baseR/7) {
1322                 outLv = 4;
1323             }
1324             else {
1325                 outLv = 5;
1326             }
1327         }
1328         return (outLv,seed);
1329     }
1330 
1331     function GenChipLevel_General(uint costAll, uint x, uint seed) internal view returns(uint8,uint)
1332     {
1333         uint8 outLv;
1334         uint random;
1335         uint baseR = BASERATIO*x/100;
1336         (random,seed) = GenRandom(seed,BASERATIO);
1337         if (costAll <= CREATE_COST_FEW) {
1338             baseR /= 2;
1339             if (random <= BASERATIO - baseR) {
1340                 outLv = 1;
1341             }
1342             else {
1343                 outLv = 2;
1344             }
1345         }
1346         else if (costAll <= CREATE_COST_MANY) {
1347             baseR = baseR*14/100;
1348             if (random <= BASERATIO*70/100-baseR) {
1349                 outLv = 1;
1350             }
1351             else if (random <= BASERATIO*95/100-baseR/4) {
1352                 outLv = 2;
1353             }
1354             else {
1355                 outLv = 3;
1356             }
1357         }
1358         else {
1359             baseR = baseR*11/100;
1360             if (random <= BASERATIO*50/100-baseR) {
1361                 outLv = 1;
1362             }
1363             else if (random <= BASERATIO*90/100-baseR/3) {
1364                 outLv = 2;
1365             }
1366             else {
1367                 outLv = 3;
1368             }
1369         }
1370         return (outLv,seed);
1371     }
1372 
1373     function GenOutChipsNum(uint seed, uint costAll, uint x) internal view returns(uint,uint)
1374     {
1375         uint amount;
1376         uint random;
1377         uint baseR = BASERATIO*x/100;
1378         (random,seed) = GenRandom(seed,BASERATIO);
1379         if (costAll <= CREATE_COST_FEW) {
1380             if (random <= BASERATIO - baseR) {
1381                 amount = 3;
1382             }
1383             else {
1384                 amount = 4;
1385             }
1386         }
1387         else {
1388             baseR /= 10;
1389             if (costAll <= CREATE_COST_MANY) {
1390                 if (random <= BASERATIO*7/10 - baseR*2) {
1391                     amount = 3;
1392                 }
1393                 else if (random <= BASERATIO*3/10 + baseR) {
1394                     amount = 4;
1395                 }
1396                 else {
1397                     amount = 5;
1398                 }
1399             }
1400             else {
1401                 if (random <= BASERATIO*7/10 - baseR) {
1402                     amount = 4;
1403                 }
1404                 else {
1405                     amount = 5;
1406                 }
1407             }
1408         }
1409         return (amount,seed);
1410     }
1411 
1412     function GetMinCost(uint a, uint b, uint c) internal pure returns(uint)
1413     {
1414         if (a>b) {
1415             if (a>c) return a;
1416         }
1417         else if (b>c) return b;
1418         else return c;
1419     }
1420 
1421     function GenExtWeightList(uint costA, uint costB, uint costC) internal pure returns(uint[],uint[],uint[])
1422     {
1423         uint min = GetMinCost(costA,costB,costC);
1424         uint[] memory extWeight3 = new uint[](3);
1425         uint[] memory extWeight4 = new uint[](4);
1426         uint[] memory extWeight5 = new uint[](5);
1427         extWeight3[0] = costA;
1428         extWeight4[0] = costA;
1429         extWeight5[0] = costA;
1430         extWeight3[1] = costB;
1431         extWeight4[1] = costB;
1432         extWeight5[1] = costB;
1433         extWeight3[2] = costC;
1434         extWeight4[2] = costC;
1435         extWeight5[2] = costC;
1436         extWeight5[3] = min;
1437         min = min/2;
1438         extWeight4[3] = min;
1439         extWeight5[4] = min;
1440         return (extWeight3,extWeight4,extWeight5);
1441     }
1442 
1443     function GenChipsLevel(uint costAll,bool bUseX) internal view returns(uint8[] lvList, uint seed)
1444     {
1445         // calculate amount, chips by random
1446         uint x = costAll - CREATE_COST_MIN;
1447         uint i;
1448         uint amount;
1449         // cal chips amount
1450         (amount,seed) = GenOutChipsNum(0,costAll,x);
1451         lvList = new uint8[](amount);
1452         if (bUseX) {
1453             (lvList[0], seed) = GenChipLevel_Special(costAll,x,seed);
1454             for (i=1; i<amount; i++)
1455             {
1456                 (lvList[i], seed) = GenChipLevel_Extra(costAll,x,seed);
1457             }
1458         }
1459         else {
1460             for (i=0; i<amount; i++)
1461             {
1462                 (lvList[i], seed) = GenChipLevel_General(costAll,x,seed);
1463             }
1464         }
1465 
1466     }
1467 
1468     function CreateChips(uint costAll, uint costA, uint costB, uint costC, bool bUseX) internal returns(uint32[])
1469     {
1470         (uint[] memory ext3,
1471          uint[] memory ext4,
1472          uint[] memory ext5
1473         ) = GenExtWeightList(costA,costB,costC);
1474 
1475         (uint8[] memory lvList, uint seed) = GenChipsLevel(costAll,bUseX);
1476         uint32[] memory chips = new uint32[](lvList.length);
1477         for (uint i=0; i<lvList.length; i++)
1478         {
1479             uint8 chipLv = lvList[i];
1480             (chips[i], seed) = GenChipIndex(seed,chipLv,ext3,ext4,ext5);
1481         }
1482         return chips;
1483     }
1484 
1485     function GetPermissionIdx(uint idx) internal pure returns(uint32)
1486     {
1487         if (idx == 1) return PERMISSION_1;
1488         else if (idx == 2) return PERMISSION_2;
1489         return 0;
1490     }
1491 
1492     function IsBoilerValid(uint idx) internal view returns(bool)
1493     {
1494         if (idx != BOILER_FREE_IDX) {
1495             uint32 iStuff = GetPermissionIdx(idx);
1496             if (iStuff == 0) return false;
1497             if (g_Main.GetTempStuffExpire(msg.sender,iStuff) < now) return false;
1498         }
1499         return g_Boilers.IsBoilerValid(msg.sender,idx);
1500     }
1501 
1502     function CollectChips(uint idx) internal
1503     {
1504         uint32[] memory chips = g_Boilers.CollectChips(msg.sender,idx);
1505         for (uint i=0; i<chips.length; i++)
1506         {
1507             g_Main.GainChip(msg.sender,chips[i],true);
1508         }
1509     }
1510 
1511     function GetExchangePoint(uint8 chipLv) internal pure returns(uint)
1512     {
1513         if (chipLv == 1) return 1;
1514         else if (chipLv == 2) return 3;
1515         else if (chipLv == 3) return 10;
1516         else if (chipLv == 4) return 30;
1517         else if (chipLv == 5) return 120;
1518         return 0;
1519     }
1520 
1521     //=========================================================================
1522 
1523     function Create(uint idx,uint costA, uint costB, uint costC, bool bUseX) external
1524     {
1525         require(costA <= CREATE_COST_MAX);
1526         require(costB <= CREATE_COST_MAX);
1527         require(costC <= CREATE_COST_MAX);
1528         uint costAll = costA+costB+costC;
1529         require(costAll>=CREATE_COST_MIN && costAll<=CREATE_COST_MAX);
1530 
1531         require(IsBoilerValid(idx));
1532 
1533         g_Main.CostStuff(msg.sender,STUFF_IDX_GENRAL,costAll);
1534         if (bUseX) g_Main.CostStuff(msg.sender,STUFF_IDX_EXTRA,1);
1535         uint CD;
1536         if (costAll <= CREATE_COST_FEW) {
1537             CD = COOLTIME_MIN;
1538         }
1539         else if (costAll <= CREATE_COST_MANY) {
1540             CD = COOLTIME_MID;
1541         }
1542         else {
1543             CD = COOLTIME_MAX;
1544         }
1545 
1546         uint32[] memory chips = CreateChips(costAll,costA,costB,costC,bUseX);
1547         g_Boilers.GenerateChips(msg.sender,idx,CD,chips);
1548     }
1549 
1550     function GetBoilersInfo() external view returns(uint[], uint32[], uint32[], uint32[] )
1551     {
1552         uint[] memory expireList = new uint[](BOILER_MAX_NUM);
1553         uint32[][] memory allChips = new uint32[][](BOILER_MAX_NUM);
1554         for (uint i=BOILER_FREE_IDX; i<BOILER_MAX_NUM; i++)
1555         {
1556             (uint expire, uint32[] memory chips) = g_Boilers.GetBoilerInfo(msg.sender,i);
1557             expireList[i] = expire;
1558             allChips[i] = chips;
1559         }
1560         return (
1561             expireList,
1562             allChips[0],
1563             allChips[1],
1564             allChips[2]
1565         );
1566     }
1567 
1568     function ResolveChips(uint32[] chips) external
1569     {
1570         for (uint i=0; i<chips.length; i++)
1571         {
1572             uint32 iChip = chips[i];
1573             g_Main.CostChip(msg.sender,iChip);
1574             (,uint8 lv,,,,) = g_Main.GetChipInfo(iChip);
1575             uint point = GetExchangePoint(lv);
1576             g_Main.GainStuff(msg.sender,STUFF_IDX_POINT,point);
1577         }
1578     }
1579 
1580     function Collect(uint idx) external
1581     {
1582         require(g_Boilers.IsBoilerExpire(msg.sender,idx));
1583         require(!g_Boilers.IsBoilerValid(msg.sender,idx));
1584         CollectChips(idx);
1585     }
1586 
1587     function Accelerate(uint idx) external payable
1588     {
1589         (uint expire,) = g_Boilers.GetBoilerInfo(msg.sender,idx);
1590         require(expire > now);
1591         uint remain = expire-now;
1592         uint num = remain/ACCELERATE_UNITTIME;
1593         if (remain != num*ACCELERATE_UNITTIME) {
1594             num++;
1595         }
1596         uint fee = num*ACCELERATE_UNITFEE;
1597         require(fee == msg.value);
1598         AddBonus(BONUS_PERCENT_ACCELERATE);
1599         CollectChips(idx);
1600     }
1601 
1602 }