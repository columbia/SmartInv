1 pragma solidity ^0.4.0;
2 
3 library Math {
4   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
5     return a >= b ? a : b;
6   }
7 
8   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
9     return a < b ? a : b;
10   }
11 
12   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
13     return a >= b ? a : b;
14   }
15 
16   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
17     return a < b ? a : b;
18   }
19 }
20 
21 library SafeMath {
22 
23   /**
24   * @dev Multiplies two numbers, throws on overflow.
25   */
26   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
27     if (a == 0 || b == 0) {
28       return 0;
29     }
30     c = a * b;
31     assert(c / a == b);
32     return c;
33   }
34 
35   /**
36   * @dev Integer division of two numbers, truncating the quotient.
37   */
38   function div(uint256 a, uint256 b) internal pure returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     // uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return a / b;
43   }
44 
45   function muldiv(uint256 a, uint256 b, uint256 c) internal pure returns (uint256 d) {
46     if (a == 0 || b == 0) {
47       return 0;
48     }
49     d = a * b;
50     assert(d / a == b);
51     return d / c;
52   }
53 
54   /**
55   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
56   */
57   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58     assert(b <= a);
59     return a - b;
60   }
61 
62   /**
63   * @dev Adds two numbers, throws on overflow.
64   */
65   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
66     c = a + b;
67     assert(c >= a);
68     return c;
69   }
70 }
71 
72 contract EtherCityConfig
73 {
74     struct BuildingData
75     {
76         uint256 population;
77         uint256 creditsPerSec;   // *100
78         uint256 maxUpgrade;
79         uint256 constructCredit;
80         uint256 constructEther;
81         uint256 upgradeCredit;
82         uint256 demolishCredit;
83 
84         uint256 constructSale;
85         uint256 upgradeSale;
86         uint256 demolishSale;
87     }
88 
89     uint256 private initCredits;
90     uint256 private initLandCount;
91     uint256 private initcreditsPerSec;
92 
93     uint256 private maxLandCount;
94     uint256 private ethLandCost;
95 
96     uint256 private creditsPerEth;
97 
98     address private owner;
99     address private admin;
100 
101     mapping(uint256 => BuildingData) private buildingData;
102     
103     constructor() public payable
104     {
105         owner = msg.sender;
106         creditsPerEth = 1;
107     }
108 
109     function SetAdmin(address addr) external
110     {
111         assert(msg.sender == owner);
112 
113         admin = addr;
114     }
115     
116     function GetVersion() external pure returns(uint256)
117     {
118         return 1000;
119     }
120 
121     function GetInitData() external view returns(uint256 ethland, uint256 maxland, uint256 credits, uint256 crdtsec, uint256 landCount)
122     {
123         ethland = ethLandCost;
124         maxland = maxLandCount;
125         credits = initCredits;
126         crdtsec = initcreditsPerSec;
127         landCount = initLandCount;
128     }
129 
130     function SetInitData(uint256 ethland, uint256 maxland, uint256 credits, uint256 crdtsec, uint256 landCount) external
131     {
132         require(msg.sender == owner || msg.sender == admin);
133 
134         ethLandCost = ethland;
135         maxLandCount = maxland;
136         initCredits = credits;
137         initcreditsPerSec = crdtsec;
138         initLandCount = landCount;
139     }
140 
141     function GetCreditsPerEth() external view returns(uint256)
142     {
143         return creditsPerEth;
144     }
145 
146     function SetCreditsPerEth(uint256 crdteth) external
147     {
148         require(crdteth > 0);
149         require(msg.sender == owner || msg.sender == admin);
150 
151         creditsPerEth = crdteth;
152     }
153 
154     function GetLandData() external view returns(uint256 ethland, uint256 maxland)
155     {
156         ethland = ethLandCost;
157         maxland = maxLandCount;
158     }
159 
160     function GetBuildingData(uint256 id) external view returns(uint256 bid, uint256 population, uint256 crdtsec, 
161                             uint256 maxupd, uint256 cnstcrdt, uint256 cnsteth, uint256 updcrdt, uint256 dmlcrdt,
162                             uint256 cnstcrdtsale, uint256 cnstethsale, uint256 updcrdtsale, uint256 dmlcrdtsale)
163     {
164         BuildingData storage bdata = buildingData[id];
165 
166         bid = id;
167         population = bdata.population;   // *100
168         crdtsec = bdata.creditsPerSec;   // *100
169         maxupd = bdata.maxUpgrade;
170         cnstcrdt = bdata.constructCredit;
171         cnsteth = bdata.constructEther;
172         updcrdt = bdata.upgradeCredit;
173         dmlcrdt = bdata.demolishCredit;
174         cnstcrdtsale = bdata.constructCredit * bdata.constructSale / 100;
175         cnstethsale = bdata.constructEther * bdata.constructSale /100;
176         updcrdtsale = bdata.upgradeCredit * bdata.upgradeSale / 100;
177         dmlcrdtsale = bdata.demolishCredit * bdata.demolishSale / 100;
178     }
179 
180     function SetBuildingData(uint256 bid, uint256 pop, uint256 crdtsec, uint256 maxupd,
181                             uint256 cnstcrdt, uint256 cnsteth, uint256 updcrdt, uint256 dmlcrdt) external
182     {
183         require(msg.sender == owner || msg.sender == admin);
184 
185         buildingData[bid] = BuildingData({population:pop, creditsPerSec:crdtsec, maxUpgrade:maxupd,
186                             constructCredit:cnstcrdt, constructEther:cnsteth, upgradeCredit:updcrdt, demolishCredit:dmlcrdt,
187                             constructSale:100, upgradeSale:100, demolishSale:100
188                             });
189     }
190 
191     function SetBuildingSale(uint256 bid, uint256 cnstsale, uint256 updsale, uint256 dmlsale) external
192     {
193         BuildingData storage bdata = buildingData[bid];
194 
195         require(0 < cnstsale && cnstsale <= 100);
196         require(0 < updsale && updsale <= 100);
197         require(msg.sender == owner || msg.sender == admin);
198 
199         bdata.constructSale = cnstsale;
200         bdata.upgradeSale = updsale;
201         bdata.demolishSale = dmlsale;
202     }
203 
204     function SetBuildingDataArray(uint256[] data) external
205     {
206         require(data.length % 8 == 0);
207         require(msg.sender == owner || msg.sender == admin);
208 
209         for(uint256 index = 0; index < data.length; index += 8)
210         {
211             BuildingData storage bdata = buildingData[data[index]];
212 
213             bdata.population = data[index + 1];
214             bdata.creditsPerSec = data[index + 2];
215             bdata.maxUpgrade = data[index + 3];
216             bdata.constructCredit = data[index + 4];
217             bdata.constructEther = data[index + 5];
218             bdata.upgradeCredit = data[index + 6];
219             bdata.demolishCredit = data[index + 7];
220             bdata.constructSale = 100;
221             bdata.upgradeSale = 100;
222             bdata.demolishSale = 100;
223         }
224     }
225 
226     function GetBuildingParam(uint256 id) external view
227                 returns(uint256 population, uint256 crdtsec, uint256 maxupd)
228     {
229         BuildingData storage bdata = buildingData[id];
230 
231         population = bdata.population;   // *100
232         crdtsec = bdata.creditsPerSec;   // *100
233         maxupd = bdata.maxUpgrade;
234     }
235 
236     function GetConstructCost(uint256 id, uint256 count) external view
237                 returns(uint256 cnstcrdt, uint256 cnsteth)
238     {
239         BuildingData storage bdata = buildingData[id];
240 
241         cnstcrdt = bdata.constructCredit * bdata.constructSale / 100  * count;
242         cnsteth = bdata.constructEther * bdata.constructSale / 100  * count;
243     }
244 
245     function GetUpgradeCost(uint256 id, uint256 count) external view
246                 returns(uint256 updcrdt)
247     {
248         BuildingData storage bdata = buildingData[id];
249 
250         updcrdt = bdata.upgradeCredit * bdata.upgradeSale / 100 * count;
251     }
252 
253     function GetDemolishCost(uint256 id, uint256 count) external view
254                 returns(uint256)
255     {
256         BuildingData storage bdata = buildingData[id];
257 
258         return bdata.demolishCredit * bdata.demolishSale / 100 * count;
259    }
260 }
261 
262 contract EtherCityRank
263 {
264     struct LINKNODE
265     {
266         uint256 count;
267         uint256 leafLast;
268     }
269 
270     struct LEAFNODE
271     {
272         address player;
273         uint256 population;
274         uint256 time;
275 
276         uint256 prev;
277         uint256 next;
278     }
279 
280     uint256 private constant LINK_NULL = uint256(-1);
281     uint256 private constant LEAF_PER_LINK = 30;
282     uint256 private constant LINK_COUNT = 10;
283     uint256 private constant LINK_ENDIDX = LINK_COUNT - 1;
284 
285     mapping(uint256 => LINKNODE) private linkNodes; // 30 * 10 = 300rank
286     mapping(uint256 => LEAFNODE) private leafNodes;
287     uint256 private leafCount;
288 
289     address private owner;
290     address private admin;
291     address private city;
292     
293     constructor() public payable
294     {
295         owner = msg.sender;
296 
297         for(uint256 index = 1; index < LINK_COUNT; index++)
298             linkNodes[index] = LINKNODE({count:0, leafLast:LINK_NULL});
299 
300         // very first rank
301         linkNodes[0] = LINKNODE({count:1, leafLast:0});
302         leafNodes[0] = LEAFNODE({player:address(0), population:uint256(-1), time:0, prev:LINK_NULL, next:LINK_NULL});
303         leafCount = 1;
304     }
305 
306     function GetVersion() external pure returns(uint256)
307     {
308         return 1000;
309     }
310 
311     function GetRank(uint16 rankidx) external view returns(address player, uint256 pop, uint256 time, uint256 nextidx)
312     {
313         uint256 leafidx;
314 
315         if (rankidx == 0)
316             leafidx = leafNodes[0].next;
317         else
318             leafidx = rankidx;
319 
320         if (leafidx != LINK_NULL)
321         {
322             player = leafNodes[leafidx].player;
323             pop = leafNodes[leafidx].population;
324             time = leafNodes[leafidx].time;
325             nextidx = leafNodes[leafidx].next;
326         }
327         else
328         {
329             player = address(0);
330             pop = 0;
331             time = 0;
332             nextidx = 0;
333         }
334     }
335 
336     function UpdateRank(address player, uint256 pop_new, uint256 time_new) external
337     {
338         bool found;
339         uint256 linkidx;
340         uint256 leafidx;
341         uint256 emptyidx;
342 
343         require(owner == msg.sender || admin == msg.sender || city == msg.sender);
344 
345         emptyidx = RemovePlayer(player);
346 
347         (found, linkidx, leafidx) = findIndex(pop_new, time_new);
348         if (linkidx == LINK_NULL)
349             return;
350 
351         if (linkNodes[LINK_ENDIDX].count == LEAF_PER_LINK)
352         {   // remove overflow
353             emptyidx = linkNodes[LINK_ENDIDX].leafLast;
354             RemoveRank(LINK_ENDIDX, emptyidx);
355         }
356         else if (emptyidx == LINK_NULL)
357         {
358             emptyidx = leafCount;
359             leafCount++;
360         }
361 
362         leafNodes[emptyidx] = LEAFNODE({player:player, population:pop_new, time:time_new, prev:LINK_NULL, next:LINK_NULL});
363 
364         // insert emptyidx before leafidx
365         InsertRank(linkidx, leafidx, emptyidx);
366     }
367 
368     /////////////////////////////////////////////////////////////////
369     //
370     function adminSetAdmin(address addr) external
371     {
372         require(owner == msg.sender);
373 
374         admin = addr;
375     }
376 
377     function adminSetCity(address addr) external
378     {
379         require(owner == msg.sender || admin == msg.sender);
380 
381         city = addr;
382     }
383 
384     function adminResetRank() external
385     {
386         require(owner == msg.sender || admin == msg.sender);
387 
388         for(uint256 index = 1; index < LINK_COUNT; index++)
389             linkNodes[index] = LINKNODE({count:0, leafLast:LINK_NULL});
390 
391         // very first rank
392         linkNodes[0] = LINKNODE({count:1, leafLast:0});
393         leafNodes[0] = LEAFNODE({player:address(0), population:uint256(-1), time:0, prev:LINK_NULL, next:LINK_NULL});
394         leafCount = 1;
395     }
396 
397     /////////////////////////////////////////////////////////////////
398     //
399     function findIndex(uint256 pop, uint256 time) private view returns(bool found, uint256 linkidx, uint256 leafidx)
400     {
401         uint256 comp;
402 
403         found = false;
404 
405         for(linkidx = 0; linkidx < LINK_COUNT; linkidx++)
406         {
407             LINKNODE storage lknode = linkNodes[linkidx];
408             if (lknode.count < LEAF_PER_LINK)
409                 break;
410 
411             LEAFNODE storage lfnode = leafNodes[lknode.leafLast];
412             if ((compareLeaf(pop, time, lfnode.population, lfnode.time) >= 1))
413                 break;
414         }
415 
416         if (linkidx == LINK_COUNT)
417         {
418             linkidx = (linkNodes[LINK_ENDIDX].count < LEAF_PER_LINK) ? LINK_ENDIDX : LINK_NULL;
419             leafidx = LINK_NULL;
420             return;
421         }
422             
423         leafidx = lknode.leafLast;
424         for(uint256 index = 0; index < lknode.count; index++)
425         {
426             lfnode = leafNodes[leafidx];
427             comp = compareLeaf(pop, time, lfnode.population, lfnode.time);
428             if (comp == 0)  // <
429             {
430                 leafidx = lfnode.next;
431                 break;
432             }
433             else if (comp == 1) // ==
434             {
435                 found = true;
436                 break;
437             }
438 
439             if (index + 1 < lknode.count)
440                 leafidx = lfnode.prev;
441         }
442     }
443     
444     function InsertRank(uint256 linkidx, uint256 leafidx_before, uint256 leafidx_new) private
445     {
446         uint256 leafOnLink;
447         uint256 leafLast;
448 
449         if (leafidx_before == LINK_NULL)
450         {   // append
451             leafLast = linkNodes[linkidx].leafLast;
452             if (leafLast != LINK_NULL)
453                 ConnectLeaf(leafidx_new, leafNodes[leafLast].next);
454             else
455                 leafNodes[leafidx_new].next = LINK_NULL;
456 
457             ConnectLeaf(leafLast, leafidx_new);
458             linkNodes[linkidx].leafLast = leafidx_new;
459             linkNodes[linkidx].count++;
460             return;
461         }
462 
463         ConnectLeaf(leafNodes[leafidx_before].prev, leafidx_new);
464         ConnectLeaf(leafidx_new, leafidx_before);
465 
466         leafLast = LINK_NULL;
467         for(uint256 index = linkidx; index < LINK_COUNT; index++)
468         {
469             leafOnLink = linkNodes[index].count;
470             if (leafOnLink < LEAF_PER_LINK)
471             {
472                 if (leafOnLink == 0) // add new
473                     linkNodes[index].leafLast = leafLast;
474 
475                 linkNodes[index].count++;
476                 break;
477             }
478 
479             leafLast = linkNodes[index].leafLast;
480             linkNodes[index].leafLast = leafNodes[leafLast].prev;
481         }
482     }
483 
484     function RemoveRank(uint256 linkidx, uint256 leafidx) private
485     {
486         uint256 next;
487 
488         for(uint256 index = linkidx; index < LINK_COUNT; index++)
489         {
490             LINKNODE storage link = linkNodes[index];
491             
492             next = leafNodes[link.leafLast].next;
493             if (next == LINK_NULL)
494             {
495                 link.count--;
496                 if (link.count == 0)
497                     link.leafLast = LINK_NULL;
498                 break;
499             }
500             else
501                 link.leafLast = next;
502         }
503 
504         LEAFNODE storage leaf_cur = leafNodes[leafidx];
505         if (linkNodes[linkidx].leafLast == leafidx)
506             linkNodes[linkidx].leafLast = leaf_cur.prev;
507 
508         ConnectLeaf(leaf_cur.prev, leaf_cur.next);
509     }
510 
511     function RemovePlayer(address player) private returns(uint256 leafidx)
512     {
513         for(uint256 linkidx = 0; linkidx < LINK_COUNT; linkidx++)
514         {
515             LINKNODE storage lknode = linkNodes[linkidx];
516 
517             leafidx = lknode.leafLast;
518             for(uint256 index = 0; index < lknode.count; index++)
519             {
520                 LEAFNODE storage lfnode = leafNodes[leafidx];
521 
522                 if (lfnode.player == player)
523                 {
524                     RemoveRank(linkidx, leafidx);
525                     return;
526                 }
527 
528                 leafidx = lfnode.prev;
529             }
530         }
531 
532         return LINK_NULL;
533     }
534 
535     function ConnectLeaf(uint256 leafprev, uint256 leafnext) private
536     {
537         if (leafprev != LINK_NULL)
538             leafNodes[leafprev].next = leafnext;
539 
540         if (leafnext != LINK_NULL)
541             leafNodes[leafnext].prev = leafprev;
542     }
543 
544     function compareLeaf(uint256 pop1, uint256 time1, uint256 pop2, uint256 time2) private pure returns(uint256)
545     {
546         if (pop1 > pop2)
547             return 2;
548         else if (pop1 < pop2)
549             return 0;
550 
551         if (time1 > time2)
552             return 2;
553         else if (time1 < time2)
554             return 0;
555 
556         return 1;
557     }
558 }
559 
560 contract EtherCityData
561 {
562     struct WORLDDATA
563     {
564         uint256 ethBalance;
565         uint256 ethDev;
566 
567         uint256 population;
568         uint256 credits;
569 
570         uint256 starttime;
571     }
572 
573     struct WORLDSNAPSHOT
574     {
575         bool valid;
576         uint256 ethDay;
577         uint256 ethBalance;
578         uint256 ethRankFund;
579         uint256 ethShopFund;
580 
581         uint256 ethRankFundRemain;
582         uint256 ethShopFundRemain;
583 
584         uint256 population;
585         uint256 credits;
586 
587         uint256 lasttime;
588     }
589 
590     struct CITYDATA
591     {
592         bytes32 name;
593 
594         uint256 credits;
595 
596         uint256 population;
597         uint256 creditsPerSec;   // *100
598 
599         uint256 landOccupied;
600         uint256 landUnoccupied;
601 
602         uint256 starttime;
603         uint256 lasttime;
604         uint256 withdrawSS;
605     }
606 
607     struct CITYSNAPSHOT
608     {
609         bool valid;
610 
611         uint256 population;
612         uint256 credits;
613 
614         uint256 shopCredits;
615 
616         uint256 lasttime;
617     }
618 
619     struct BUILDINGDATA
620     {
621         uint256 constructCount;
622         uint256 upgradeCount;
623 
624         uint256 population;
625         uint256 creditsPerSec;   // *100
626     }
627 
628     uint256 private constant INTFLOATDIV = 100;
629 
630     address private owner;
631     address private admin;
632     address private city;
633     bool private enabled;
634 
635     WORLDDATA private worldData;
636     mapping(uint256 => WORLDSNAPSHOT) private worldSnapshot;
637 
638     address[] private playerlist;
639     mapping(address => CITYDATA) private cityData;
640     mapping(address => mapping(uint256 => CITYSNAPSHOT)) private citySnapshot;
641     mapping(address => mapping(uint256 => BUILDINGDATA)) private buildings;
642     mapping(address => uint256) private ethBalance;
643 
644 
645     constructor() public payable
646     {
647         owner = msg.sender;
648 
649         enabled = true;
650         worldData = WORLDDATA({ethBalance:0, ethDev:0, population:0, credits:0, starttime:block.timestamp});
651         worldSnapshot[nowday()] = WORLDSNAPSHOT({valid:true, ethDay:0, ethBalance:0, ethRankFund:0, ethShopFund:0, ethRankFundRemain:0, ethShopFundRemain:0, population:0, credits:0, lasttime:block.timestamp});
652     }
653 
654     function GetVersion() external pure returns(uint256)
655     {
656         return 1001;
657     }
658 
659     function IsPlayer(address player) external view returns(bool)
660     {
661         for(uint256 index = 0; index < playerlist.length; index++)
662          {
663              if (playerlist[index] == player)
664                 return true;
665          }
666 
667         return false;
668     }
669 
670     function IsCityNameExist(bytes32 cityname) external view returns(bool)
671     {
672         for(uint256 index = 0; index < playerlist.length; index++)
673         {
674             if (cityData[playerlist[index]].name == cityname)
675                return false;
676         }
677 
678         return true;
679     }
680 
681     function CreateCityData(address player, uint256 crdtsec, uint256 landcount) external
682     {
683         uint256 day;
684 
685         require(cityData[player].starttime == 0);
686         require(owner == msg.sender || admin == msg.sender || (enabled && city == msg.sender));
687 
688         playerlist.push(player);    // new player
689 
690         day = nowday();
691         cityData[player] = CITYDATA({name:0, credits:0, population:0, creditsPerSec:crdtsec, landOccupied:0, landUnoccupied:landcount, starttime:block.timestamp, lasttime:block.timestamp, withdrawSS:day});
692         citySnapshot[player][day] = CITYSNAPSHOT({valid:true, population:0, credits:0, shopCredits:0, lasttime:block.timestamp});
693     }
694 
695     function GetWorldData() external view returns(uint256 ethBal, uint256 ethDev, uint256 population, uint256 credits, uint256 starttime)
696     {
697         require(owner == msg.sender || admin == msg.sender || city == msg.sender);
698 
699         ethBal = worldData.ethBalance;
700         ethDev = worldData.ethDev;
701         population = worldData.population;
702         credits = worldData.credits;
703         starttime = worldData.starttime;
704     }
705 
706     function SetWorldData(uint256 ethBal, uint256 ethDev, uint256 population, uint256 credits, uint256 starttime) external
707     {
708         require(owner == msg.sender || admin == msg.sender || (enabled && city == msg.sender));
709 
710         worldData.ethBalance = ethBal;
711         worldData.ethDev = ethDev;
712         worldData.population = population;
713         worldData.credits = credits;
714         worldData.starttime = starttime;
715     }
716 
717     function SetWorldSnapshot(uint256 day, bool valid, uint256 population, uint256 credits, uint256 lasttime) external
718     {
719         WORLDSNAPSHOT storage wss = worldSnapshot[day];
720 
721         require(owner == msg.sender || admin == msg.sender || (enabled && city == msg.sender));
722 
723         wss.valid = valid;
724         wss.population = population;
725         wss.credits = credits;
726         wss.lasttime = lasttime;
727     }
728 
729     function GetCityData(address player) external view returns(uint256 credits, uint256 population, uint256 creditsPerSec,
730                                     uint256 landOccupied, uint256 landUnoccupied, uint256 lasttime)
731     {
732         CITYDATA storage cdata = cityData[player];
733 
734         require(owner == msg.sender || admin == msg.sender || city == msg.sender);
735 
736         credits = cdata.credits;
737         population = cdata.population;
738         creditsPerSec = cdata.creditsPerSec;
739         landOccupied = cdata.landOccupied;
740         landUnoccupied = cdata.landUnoccupied;
741         lasttime = cdata.lasttime;
742     }
743 
744     function SetCityData(address player, uint256 credits, uint256 population, uint256 creditsPerSec,
745                         uint256 landOccupied, uint256 landUnoccupied, uint256 lasttime) external
746     {
747         CITYDATA storage cdata = cityData[player];
748 
749         require(owner == msg.sender || admin == msg.sender || (enabled && city == msg.sender));
750 
751         cdata.credits = credits;
752         cdata.population = population;
753         cdata.creditsPerSec = creditsPerSec;
754         cdata.landOccupied = landOccupied;
755         cdata.landUnoccupied = landUnoccupied;
756         cdata.lasttime = lasttime;
757     }
758 
759     function GetCityName(address player) external view returns(bytes32)
760     {
761         return cityData[player].name;
762     }
763 
764     function SetCityName(address player, bytes32 name) external
765     {
766         require(owner == msg.sender || admin == msg.sender || (enabled && city == msg.sender));
767 
768         cityData[player].name = name;
769     }
770 
771     function GetCitySnapshot(address player, uint256 day) external view returns(bool valid, uint256 population, uint256 credits, uint256 shopCredits, uint256 lasttime)
772     {
773         CITYSNAPSHOT storage css = citySnapshot[player][day];
774 
775         require(owner == msg.sender || admin == msg.sender || city == msg.sender);
776 
777         valid = css.valid;
778         population = css.population;
779         credits = css.credits;
780         shopCredits = css.shopCredits;
781         lasttime = css.lasttime;
782     }
783 
784     function SetCitySnapshot(address player, uint256 day, bool valid, uint256 population, uint256 credits, uint256 shopCredits, uint256 lasttime) external
785     {
786         CITYSNAPSHOT storage css = citySnapshot[player][day];
787 
788         require(owner == msg.sender || admin == msg.sender || (enabled && city == msg.sender));
789 
790         css.valid = valid;
791         css.population = population;
792         css.credits = credits;
793         css.shopCredits = shopCredits;
794         css.lasttime = lasttime;
795     }
796 
797     function GetBuildingData(address player, uint256 id) external view returns(uint256 constructCount, uint256 upgradeCount, uint256 population, uint256 creditsPerSec)
798     {
799         BUILDINGDATA storage bdata = buildings[player][id];
800 
801         require(owner == msg.sender || admin == msg.sender || city == msg.sender);
802 
803         constructCount = bdata.constructCount;
804         upgradeCount = bdata.upgradeCount;
805         population = bdata.population;
806         creditsPerSec = bdata.creditsPerSec;
807     }
808 
809     function SetBuildingData(address player, uint256 id, uint256 constructCount, uint256 upgradeCount, uint256 population, uint256 creditsPerSec) external
810     {
811         BUILDINGDATA storage bdata = buildings[player][id];
812 
813         require(owner == msg.sender || admin == msg.sender || (enabled && city == msg.sender));
814 
815         bdata.constructCount = constructCount;
816         bdata.upgradeCount = upgradeCount;
817         bdata.population = population;
818         bdata.creditsPerSec = creditsPerSec;
819     }
820 
821     function GetEthBalance(address player) external view returns(uint256)
822     {
823         require(owner == msg.sender || admin == msg.sender || city == msg.sender);
824 
825         return ethBalance[player];
826     }
827 
828     function SetEthBalance(address player, uint256 eth) external
829     {
830         require(owner == msg.sender || admin == msg.sender || (enabled && city == msg.sender));
831 
832         ethBalance[player] = eth;
833     }
834 
835     function AddEthBalance(address player, uint256 eth) external
836     {
837         require(owner == msg.sender || admin == msg.sender || (enabled && city == msg.sender));
838 
839         ethBalance[player] += eth;
840     }
841 
842     function GetWithdrawBalance(address player) external view returns(uint256 ethBal)
843     {
844         uint256 startday;
845 
846         require(owner == msg.sender || admin == msg.sender || city == msg.sender);
847 
848         ethBal = ethBalance[player];
849 
850         startday = cityData[player].withdrawSS;
851         for(uint256 day = nowday() - 1; day >= startday; day--)
852         {
853             WORLDSNAPSHOT memory wss = TestWorldSnapshotInternal(day);
854             CITYSNAPSHOT memory css = TestCitySnapshotInternal(player, day);
855             ethBal += Math.min256(SafeMath.muldiv(wss.ethRankFund, css.population, wss.population), wss.ethRankFundRemain);
856         }
857     }
858 
859     function WithdrawEther(address player) external
860     {
861         uint256 startday;
862         uint256 ethBal;
863         uint256 eth;
864         CITYDATA storage cdata = cityData[player];
865 
866         require(owner == msg.sender || admin == msg.sender || (enabled && city == msg.sender));
867 
868         ethBal = ethBalance[player];
869 
870         startday = cdata.withdrawSS;
871         for(uint256 day = nowday() - 1; day >= startday; day--)
872         {
873             WORLDSNAPSHOT storage wss = ValidateWorldSnapshotInternal(day);
874             CITYSNAPSHOT storage css = ValidateCitySnapshotInternal(player, day);
875 
876             if (wss.ethRankFundRemain > 0)
877             {
878                 eth = Math.min256(SafeMath.muldiv(wss.ethRankFund, css.population, wss.population), wss.ethRankFundRemain);
879                 wss.ethRankFundRemain -= eth;
880                 ethBal += eth;
881             }
882         }
883 
884         require(0 < ethBal);
885 
886         ethBalance[player] = 0;
887         cdata.withdrawSS = nowday() - 1;
888 
889         player.transfer(ethBal);
890     }
891 
892     function GetEthShop(address player) external view returns(uint256 shopEth, uint256 shopCredits)
893     {
894         uint256 day;
895         CITYSNAPSHOT memory css;
896         WORLDSNAPSHOT memory wss;
897 
898         require(owner == msg.sender || admin == msg.sender || city == msg.sender);
899 
900         day = nowday() - 1;
901         if (day < cityData[player].starttime / 24 hours)
902         {
903             shopEth = 0;
904             shopCredits = 0;
905             return;
906         }
907 
908         wss = TestWorldSnapshotInternal(day);
909         css = TestCitySnapshotInternal(player, day);
910 
911         shopEth = Math.min256(SafeMath.muldiv(wss.ethShopFund, css.shopCredits, wss.credits), wss.ethShopFundRemain);
912         shopCredits = css.shopCredits;
913     }
914 
915     function TradeEthShop(address player, uint256 credits) external
916     {
917         uint256 day;
918         uint256 shopEth;
919 
920         require(owner == msg.sender || admin == msg.sender || (enabled && city == msg.sender));
921 
922         day = nowday() - 1;
923         require(day >= cityData[player].starttime / 24 hours);
924 
925         WORLDSNAPSHOT storage wss = ValidateWorldSnapshotInternal(day);
926         CITYSNAPSHOT storage css = ValidateCitySnapshotInternal(player, day);
927 
928         require(wss.ethShopFundRemain > 0);
929         require((0 < credits) && (credits <= css.shopCredits));
930 
931         shopEth = Math.min256(SafeMath.muldiv(wss.ethShopFund, css.shopCredits, wss.credits), wss.ethShopFundRemain);
932 
933         wss.ethShopFundRemain -= shopEth;
934         css.shopCredits -= credits;
935 
936         ethBalance[player] += shopEth;
937     }
938 
939     function UpdateEthBalance(uint256 bal, uint256 devf, uint256 rnkf, uint256 shpf) external payable
940     {
941         require(owner == msg.sender || admin == msg.sender || (enabled && city == msg.sender));
942 
943         worldData.ethBalance += bal + devf + rnkf + shpf;
944         worldData.ethDev += devf;
945 
946         WORLDSNAPSHOT storage wss = ValidateWorldSnapshotInternal(nowday());
947         wss.ethDay += bal + devf + rnkf + shpf;
948         wss.ethBalance += bal;
949         wss.ethRankFund += rnkf;
950         wss.ethShopFund += shpf;
951         wss.ethRankFundRemain += rnkf;
952         wss.ethShopFundRemain += shpf;
953         wss.lasttime = block.timestamp;
954 
955         ethBalance[owner] += devf;
956     }
957 
958     function ValidateWorldSnapshot(uint256 day) external returns(uint256 ethRankFund, uint256 population, uint256 credits, uint256 lasttime)
959     {
960         WORLDSNAPSHOT storage wss = ValidateWorldSnapshotInternal(day);
961 
962         require(owner == msg.sender || admin == msg.sender || (enabled && city == msg.sender));
963 
964         ethRankFund = wss.ethRankFund;
965         population = wss.population;
966         credits = wss.credits;
967         lasttime = wss.lasttime;
968     }
969 
970     function TestWorldSnapshot(uint256 day) external view returns(uint256 ethRankFund, uint256 population, uint256 credits, uint256 lasttime)
971     {
972         WORLDSNAPSHOT memory wss = TestWorldSnapshotInternal(day);
973 
974         require(owner == msg.sender || admin == msg.sender || city == msg.sender);
975 
976         ethRankFund = wss.ethRankFund;
977         population = wss.population;
978         credits = wss.credits;
979         lasttime = wss.lasttime;
980     }
981 
982     function ValidateCitySnapshot(address player, uint256 day) external returns(uint256 population, uint256 credits, uint256 shopCredits, uint256 lasttime)
983     {
984         CITYSNAPSHOT storage css = ValidateCitySnapshotInternal(player, day);
985     
986         require(owner == msg.sender || admin == msg.sender || (enabled && city == msg.sender));
987 
988         population = css.population;
989         credits = css.credits;
990         shopCredits = css.shopCredits;
991         lasttime = css.lasttime;
992     }
993 
994     function TestCitySnapshot(address player, uint256 day) external view returns(uint256 population, uint256 credits, uint256 shopCredits, uint256 lasttime)
995     {
996         CITYSNAPSHOT memory css = TestCitySnapshotInternal(player, day);
997 
998         require(owner == msg.sender || admin == msg.sender || city == msg.sender);
999 
1000         population = css.population;
1001         credits = css.credits;
1002         shopCredits = css.shopCredits;
1003         lasttime = css.lasttime;
1004     }
1005 
1006     /////////////////////////////////////////////////////////////////
1007     //
1008     function nowday() private view returns(uint256)
1009     {
1010         return block.timestamp / 24 hours;
1011     }
1012 
1013     function adminSetAdmin(address addr) external
1014     {
1015         require(owner == msg.sender);
1016 
1017         admin = addr;
1018     }
1019 
1020     function adminSetCity(address addr) external
1021     {
1022         require(owner == msg.sender || admin == msg.sender);
1023 
1024         city = addr;
1025     }
1026 
1027     function adminGetEnabled() external view returns(bool)
1028     {
1029         require(owner == msg.sender || admin == msg.sender);
1030 
1031         return enabled;
1032     }
1033 
1034     function adminSetEnabled(bool bval) external
1035     {
1036         require(owner == msg.sender || admin == msg.sender);
1037 
1038         enabled = bval;
1039     }
1040 
1041     function adminGetWorldData() external view returns(uint256 eth, uint256 ethDev,
1042                                                  uint256 population, uint256 credits, uint256 starttime)
1043     {
1044         require(msg.sender == owner || msg.sender == admin);
1045 
1046         eth = worldData.ethBalance;
1047         ethDev = worldData.ethDev;
1048         population = worldData.population;
1049         credits = worldData.credits;
1050         starttime = worldData.starttime;
1051     }
1052 
1053     function adminGetWorldSnapshot(uint256 day) external view returns(bool valid, uint256 ethDay, uint256 ethBal, uint256 ethRankFund, uint256 ethShopFund, uint256 ethRankFundRemain,
1054                                 uint256 ethShopFundRemain, uint256 population, uint256 credits, uint256 lasttime)
1055     {
1056         WORLDSNAPSHOT storage wss = worldSnapshot[day];
1057 
1058         require(owner == msg.sender || admin == msg.sender);
1059 
1060         valid = wss.valid;
1061         ethDay = wss.ethDay;
1062         ethBal = wss.ethBalance;
1063         ethRankFund = wss.ethRankFund;
1064         ethShopFund = wss.ethShopFund;
1065         ethRankFundRemain = wss.ethRankFundRemain;
1066         ethShopFundRemain = wss.ethShopFundRemain;
1067         population = wss.population;
1068         credits = wss.credits;
1069         lasttime = wss.lasttime;
1070     }
1071 
1072     function adminSetWorldSnapshot(uint256 day, bool valid, uint256 ethDay, uint256 ethBal, uint256 ethRankFund, uint256 ethShopFund, uint256 ethRankFundRemain,
1073                                 uint256 ethShopFundRemain, uint256 population, uint256 credits, uint256 lasttime) external
1074     {
1075         WORLDSNAPSHOT storage wss = worldSnapshot[day];
1076 
1077         require(owner == msg.sender || admin == msg.sender);
1078 
1079         wss.valid = valid;
1080         wss.ethDay = ethDay;
1081         wss.ethBalance = ethBal;
1082         wss.ethRankFund = ethRankFund;
1083         wss.ethShopFund = ethShopFund;
1084         wss.ethRankFundRemain = ethRankFundRemain;
1085         wss.ethShopFundRemain = ethShopFundRemain;
1086         wss.population = population;
1087         wss.credits = credits;
1088         wss.lasttime = lasttime;
1089     }
1090 
1091     function adminGetCityData(address player) external view returns(bytes32 name, uint256 credits, uint256 population, uint256 creditsPerSec,
1092                                     uint256 landOccupied, uint256 landUnoccupied, uint256 starttime, uint256 lasttime, uint256 withdrawSS)
1093     {
1094         CITYDATA storage cdata = cityData[player];
1095 
1096         require(owner == msg.sender || admin == msg.sender);
1097 
1098         name = cdata.name;
1099         credits = cdata.credits;
1100         population = cdata.population;
1101         creditsPerSec = cdata.creditsPerSec;
1102         landOccupied = cdata.landOccupied;
1103         landUnoccupied = cdata.landUnoccupied;
1104         starttime = cdata.starttime;
1105         lasttime = cdata.lasttime;
1106         withdrawSS = cdata.withdrawSS;
1107     }
1108 
1109     function adminSetCityData(address player, bytes32 name, uint256 credits, uint256 population, uint256 creditsPerSec,
1110                         uint256 landOccupied, uint256 landUnoccupied, uint256 starttime, uint256 lasttime, uint256 withdrawSS) external
1111     {
1112         CITYDATA storage cdata = cityData[player];
1113 
1114         require(owner == msg.sender || admin == msg.sender);
1115 
1116         cdata.name = name;
1117         cdata.credits = credits;
1118         cdata.population = population;
1119         cdata.creditsPerSec = creditsPerSec;
1120         cdata.landOccupied = landOccupied;
1121         cdata.landUnoccupied = landUnoccupied;
1122         cdata.starttime = starttime;
1123         cdata.lasttime = lasttime;
1124         cdata.withdrawSS = withdrawSS;
1125     }
1126 
1127     function adminUpdateWorldSnapshot() external
1128     {
1129         require(msg.sender == owner || msg.sender == admin);
1130 
1131         ValidateWorldSnapshotInternal(nowday());
1132     }
1133 
1134     function adminGetPastShopFund() external view returns(uint256 ethBal)
1135     {
1136         uint256 startday;
1137         WORLDSNAPSHOT memory wss;
1138 
1139         require(msg.sender == owner || msg.sender == admin);
1140 
1141         ethBal = 0;
1142 
1143         startday = worldData.starttime / 24 hours;
1144         for(uint256 day = nowday() - 2; day >= startday; day--)
1145         {
1146             wss = TestWorldSnapshotInternal(day);
1147             ethBal += wss.ethShopFundRemain;
1148         }
1149     }
1150 
1151     function adminCollectPastShopFund() external
1152     {
1153         uint256 startday;
1154         uint256 ethBal;
1155 
1156         require(msg.sender == owner || msg.sender == admin);
1157 
1158         ethBal = ethBalance[owner];
1159 
1160         startday = worldData.starttime / 24 hours;
1161         for(uint256 day = nowday() - 2; day >= startday; day--)
1162         {
1163             WORLDSNAPSHOT storage wss = ValidateWorldSnapshotInternal(day);
1164 
1165             ethBal += wss.ethShopFundRemain;
1166             wss.ethShopFundRemain = 0;
1167         }
1168 
1169         ethBalance[owner] = ethBal;
1170     }
1171 
1172     function adminSendWorldBalance() external payable
1173     {
1174         require(msg.sender == owner || msg.sender == admin);
1175 
1176         WORLDSNAPSHOT storage wss = ValidateWorldSnapshotInternal(nowday());
1177         wss.ethBalance += msg.value;
1178     }
1179 
1180     function adminTransferWorldBalance(uint256 eth) external
1181     {
1182         require(msg.sender == owner || msg.sender == admin);
1183 
1184         WORLDSNAPSHOT storage wss = ValidateWorldSnapshotInternal(nowday());
1185         require(eth <= wss.ethBalance);
1186 
1187         ethBalance[owner] += eth;
1188         wss.ethBalance -= eth;
1189     }
1190 
1191     function adminGetContractBalance() external view returns(uint256)
1192     {
1193         require(msg.sender == owner || msg.sender == admin);
1194 
1195         return address(this).balance;
1196     }
1197 
1198     function adminTransferContractBalance(uint256 eth) external
1199     {
1200         require(msg.sender == owner || msg.sender == admin);
1201         owner.transfer(eth);
1202     }
1203 
1204     function adminGetPlayerCount() external view returns(uint256)
1205     {
1206         require(msg.sender == owner || msg.sender == admin);
1207 
1208         return playerlist.length;
1209     }
1210 
1211     function adminGetPlayer(uint256 index) external view returns(address player, uint256 eth)
1212     {
1213         require(msg.sender == owner || msg.sender == admin);
1214 
1215         player = playerlist[index];
1216         eth = ethBalance[player];
1217     }
1218 
1219 
1220     /////////////////////////////////////////////////////////////////
1221     //
1222     function ValidateWorldSnapshotInternal(uint256 day) private returns(WORLDSNAPSHOT storage)
1223     {
1224         uint256 fndf;
1225         uint256 sday;
1226 
1227         sday = day;
1228         while (!worldSnapshot[sday].valid)
1229             sday--;
1230 
1231         WORLDSNAPSHOT storage prev = worldSnapshot[sday];
1232         sday++;
1233 
1234         while (sday <= day)
1235         {
1236             worldSnapshot[sday] = WORLDSNAPSHOT({valid:true, ethDay:0, ethBalance:0, ethRankFund:0, ethShopFund:0, ethRankFundRemain:0, ethShopFundRemain:0, population:prev.population, credits:prev.credits, lasttime:prev.lasttime / 24 hours + 1});
1237             WORLDSNAPSHOT storage wss = worldSnapshot[sday];
1238             wss.ethBalance = prev.ethBalance * 90 /100;
1239             fndf = prev.ethBalance - wss.ethBalance;
1240             wss.ethRankFund = fndf * 70 / 100;
1241             wss.ethShopFund = fndf - wss.ethRankFund;
1242             wss.ethRankFund = wss.ethRankFund;
1243             wss.ethShopFund = wss.ethShopFund;
1244             wss.ethRankFundRemain = wss.ethRankFund;
1245             wss.ethShopFundRemain = wss.ethShopFund;
1246 
1247             prev = wss;
1248             sday++;
1249         }
1250 
1251         return prev;
1252     }
1253 
1254     function TestWorldSnapshotInternal(uint256 day) private view returns(WORLDSNAPSHOT memory)
1255     {
1256         uint256 fndf;
1257         uint256 sday;
1258 
1259         sday = day;
1260         while (!worldSnapshot[sday].valid)
1261             sday--;
1262 
1263         WORLDSNAPSHOT memory prev = worldSnapshot[sday];
1264         sday++;
1265 
1266         while (sday <= day)
1267         {
1268             WORLDSNAPSHOT memory wss = WORLDSNAPSHOT({valid:true, ethDay:0, ethBalance:0, ethRankFund:0, ethShopFund:0, ethRankFundRemain:0, ethShopFundRemain:0, population:prev.population, credits:prev.credits, lasttime:prev.lasttime / 24 hours + 1});
1269             wss.ethBalance = prev.ethBalance * 90 /100;
1270             fndf = prev.ethBalance - wss.ethBalance;
1271             wss.ethRankFund = fndf * 70 / 100;
1272             wss.ethShopFund = fndf - wss.ethRankFund;
1273             wss.ethRankFund = wss.ethRankFund;
1274             wss.ethShopFund = wss.ethShopFund;
1275             wss.ethRankFundRemain = wss.ethRankFund;
1276             wss.ethShopFundRemain = wss.ethShopFund;
1277 
1278             prev = wss;
1279             sday++;
1280         }
1281 
1282         return prev;
1283     }
1284 
1285     function ValidateCitySnapshotInternal(address player, uint256 day) private returns(CITYSNAPSHOT storage)
1286     {
1287         uint256 sday;
1288 
1289         sday = day;
1290         while (!citySnapshot[player][sday].valid)
1291             sday--;
1292 
1293         CITYSNAPSHOT storage css = citySnapshot[player][sday];
1294         sday++;
1295 
1296         while (sday <= day)
1297         {
1298             citySnapshot[player][sday] = CITYSNAPSHOT({valid:true, population:css.population, credits:css.credits, shopCredits:css.credits, lasttime:sday * 24 hours});
1299             css = citySnapshot[player][sday];
1300             sday++;
1301         }
1302     
1303         return css;
1304     }
1305 
1306     function TestCitySnapshotInternal(address player, uint256 day) private view returns(CITYSNAPSHOT memory)
1307     {
1308         uint256 sday;
1309 
1310         sday = day;
1311         while (!citySnapshot[player][sday].valid)
1312             sday--;
1313 
1314         CITYSNAPSHOT memory css = citySnapshot[player][sday];
1315         sday++;
1316 
1317         while (sday <= day)
1318         {
1319             css = CITYSNAPSHOT({valid:true, population:css.population, credits:css.credits, shopCredits:css.credits, lasttime:sday * 24 hours});
1320             sday++;
1321         }
1322 
1323         return css;
1324     }
1325 }
1326 
1327 
1328 contract EtherCity
1329 {
1330     struct WORLDDATA
1331     {
1332         uint256 ethBalance;
1333         uint256 ethDev;
1334 
1335         uint256 population;
1336         uint256 credits;
1337 
1338         uint256 starttime;
1339     }
1340 
1341     struct WORLDSNAPSHOT
1342     {
1343         uint256 population;
1344         uint256 credits;
1345         uint256 lasttime;
1346     }
1347 
1348     struct CITYDATA
1349     {
1350         uint256 credits;
1351 
1352         uint256 population;
1353         uint256 creditsPerSec;   // *100
1354 
1355         uint256 landOccupied;
1356         uint256 landUnoccupied;
1357 
1358         uint256 lasttime;
1359     }
1360 
1361     struct CITYSNAPSHOT
1362     {
1363         uint256 population;
1364         uint256 credits;
1365 
1366         uint256 shopCredits;
1367 
1368         uint256 lasttime;
1369     }
1370 
1371     struct BUILDINGDATA
1372     {
1373         uint256 constructCount;
1374         uint256 upgradeCount;
1375 
1376         uint256 population;
1377         uint256 creditsPerSec;   // *100
1378     }
1379 
1380     uint256 private constant INTFLOATDIV = 100;
1381 
1382     address private owner;
1383     address private admin;
1384 
1385     EtherCityConfig private config;
1386     EtherCityData private data;
1387     EtherCityRank private rank;
1388 
1389     // events
1390     event OnConstructed(address player, uint256 id, uint256 count);
1391     event OnUpdated(address player, uint256 id, uint256 count);
1392     event OnDemolished(address player, uint256 id, uint256 count);
1393     event OnBuyLands(address player, uint256 count);
1394     event OnBuyCredits(address player, uint256 eth);
1395 
1396 
1397     constructor() public payable
1398     {
1399         owner = msg.sender;
1400     }
1401 
1402     function GetVersion() external pure returns(uint256)
1403     {
1404         return 1001;
1405     }
1406 
1407     function IsPlayer() external view returns(bool)
1408     {
1409         return data.IsPlayer(msg.sender);
1410     }
1411 
1412     function StartCity() external
1413     {
1414         uint256 ethland;
1415         uint256 maxland;
1416         uint256 initcrdt;
1417         uint256 crdtsec;
1418         uint256 landcount;
1419 
1420         (ethland, maxland, initcrdt, crdtsec, landcount) = config.GetInitData();
1421         CITYDATA memory cdata = dtCreateCityData(msg.sender, crdtsec, landcount);
1422 
1423         UpdateCityData(cdata, 0, initcrdt, 0, 0);
1424 
1425         dtSetCityData(msg.sender, cdata);
1426     }
1427 
1428     function GetCityName(address player) external view returns(bytes32)
1429     {
1430         return data.GetCityName(player);
1431     }
1432 
1433     function SetCityName(bytes32 name) external
1434     {
1435         data.SetCityName(msg.sender, name);
1436     }
1437 
1438     function GetWorldSnapshot() external view returns(uint256 ethFund, uint256 population, uint256 credits, 
1439                                                     uint256 lasttime, uint256 nexttime, uint256 timestamp)
1440     {
1441         WORLDSNAPSHOT memory wss;
1442         
1443         (ethFund, wss) = dtTestWorldSnapshot(nowday());
1444 
1445         population = wss.population;
1446         credits = wss.credits;
1447         lasttime = wss.lasttime;
1448         nexttime = daytime(nowday() + 1);
1449 
1450         timestamp = block.timestamp;
1451     }
1452 
1453     function GetCityData() external view returns(bytes32 cityname, uint256 population, uint256 credits, uint256 creditsPerSec,
1454                                                                     uint256 occupied, uint256 unoccupied, uint256 timestamp)
1455     {
1456         CITYDATA memory cdata = dtGetCityData(msg.sender);
1457 
1458         cityname = data.GetCityName(msg.sender);
1459         credits = CalcIncCredits(cdata) + cdata.credits;
1460         population = cdata.population;
1461         creditsPerSec = cdata.creditsPerSec;   // *100
1462         occupied = cdata.landOccupied;
1463         unoccupied = cdata.landUnoccupied;
1464         timestamp = block.timestamp;
1465     }
1466 
1467     function GetCitySnapshot() external view returns(uint256 population, uint256 credits, uint256 timestamp)
1468     {
1469         CITYSNAPSHOT memory css = dtTestCitySnapshot(msg.sender, nowday());
1470 
1471         population = css.population;
1472         credits = css.credits;
1473         timestamp = block.timestamp;
1474     }
1475 
1476     function GetBuildingData(uint256 id) external view returns(uint256 constructCount, uint256 upgradeCount, uint256 population, uint256 creditsPerSec)
1477     {
1478         BUILDINGDATA memory bdata = dtGetBuildingData(msg.sender, id);
1479 
1480         constructCount = bdata.constructCount;
1481         upgradeCount = bdata.upgradeCount;
1482         (population, creditsPerSec) = CalcBuildingParam(bdata);
1483     }
1484 
1485     function GetConstructCost(uint256 id, uint256 count) external view returns(uint256 cnstcrdt, uint256 cnsteth)
1486     {
1487         (cnstcrdt, cnsteth) = config.GetConstructCost(id, count);
1488     }
1489 
1490     function ConstructByCredits(uint256 id, uint256 count) external
1491     {
1492         CITYDATA memory cdata = dtGetCityData(msg.sender);
1493 
1494         require(count > 0);
1495         if (!ConstructBuilding(cdata, id, count, true))
1496             require(false);
1497 
1498         dtSetCityData(msg.sender, cdata);
1499 
1500         emit OnConstructed(msg.sender, id, count);
1501     }
1502 
1503     function ConstructByEth(uint256 id, uint256 count) external payable
1504     {
1505         CITYDATA memory cdata = dtGetCityData(msg.sender);
1506 
1507         require(count > 0);
1508         if (!ConstructBuilding(cdata, id, count, false))
1509             require(false);
1510 
1511         dtSetCityData(msg.sender, cdata);
1512 
1513         emit OnConstructed(msg.sender, id, count);
1514     }
1515 
1516     function BuyLandsByEth(uint256 count) external payable
1517     {
1518         uint256 ethland;
1519         uint256 maxland;
1520 
1521         require(count > 0);
1522 
1523         (ethland, maxland) = config.GetLandData();
1524 
1525         CITYDATA memory cdata = dtGetCityData(msg.sender);
1526         require(cdata.landOccupied + cdata.landUnoccupied + count <= maxland);
1527 
1528         UpdateEthBalance(ethland * count, msg.value);
1529         UpdateCityData(cdata, 0, 0, 0, 0);
1530 
1531         cdata.landUnoccupied += count;
1532 
1533         dtSetCityData(msg.sender, cdata);
1534 
1535         emit OnBuyLands(msg.sender, count);
1536     }
1537 
1538     function BuyCreditsByEth(uint256 eth) external payable
1539     {
1540         CITYDATA memory cdata = dtGetCityData(msg.sender);
1541 
1542         require(eth > 0);
1543 
1544         UpdateEthBalance(eth, msg.value);
1545         UpdateCityData(cdata, 0, 0, 0, 0);
1546 
1547         cdata.credits += eth * config.GetCreditsPerEth();
1548 
1549         dtSetCityData(msg.sender, cdata);
1550 
1551         emit OnBuyCredits(msg.sender, eth);
1552     }
1553 
1554     function GetUpgradeCost(uint256 id, uint256 count) external view returns(uint256)
1555     {
1556         return config.GetUpgradeCost(id, count);
1557     }
1558 
1559     function UpgradeByCredits(uint256 id, uint256 count) external
1560     {
1561         uint256 a_population;
1562         uint256 a_crdtsec;
1563         uint256 updcrdt;
1564         CITYDATA memory cdata = dtGetCityData(msg.sender);
1565         
1566         require(count > 0);
1567 
1568         (a_population, a_crdtsec) = UpdateBuildingParam(cdata, id, 0, count);
1569         require((a_population > 0) || (a_crdtsec > 0));
1570 
1571         updcrdt = config.GetUpgradeCost(id, count);
1572 
1573         UpdateCityData(cdata, a_population, 0, updcrdt, a_crdtsec);
1574         if (a_population != 0)
1575             rank.UpdateRank(msg.sender, cdata.population, cdata.lasttime);
1576 
1577         dtSetCityData(msg.sender, cdata);
1578 
1579         emit OnUpdated(msg.sender, id, count);
1580     }
1581 
1582     function GetDemolishCost(uint256 id, uint256 count) external view returns (uint256)
1583     {
1584         require(count > 0);
1585 
1586         return config.GetDemolishCost(id, count);
1587     }
1588 
1589     function DemolishByCredits(uint256 id, uint256 count) external
1590     {
1591         uint256 a_population;
1592         uint256 a_crdtsec;
1593         uint256 dmlcrdt;
1594         CITYDATA memory cdata = dtGetCityData(msg.sender);
1595         
1596         require(count > 0);
1597 
1598         (a_population, a_crdtsec) = UpdateBuildingParam(cdata, id, -count, 0);
1599         require((a_population > 0) || (a_crdtsec > 0));
1600 
1601         dmlcrdt = config.GetDemolishCost(id, count);
1602 
1603         UpdateCityData(cdata, a_population, 0, dmlcrdt, a_crdtsec);
1604         if (a_population != 0)
1605             rank.UpdateRank(msg.sender, cdata.population, cdata.lasttime);
1606 
1607         dtSetCityData(msg.sender, cdata);
1608 
1609         emit OnDemolished(msg.sender, id, count);
1610     }
1611 
1612     function GetEthBalance() external view returns(uint256 ethBal)
1613     {
1614         return data.GetWithdrawBalance(msg.sender);
1615     }
1616 
1617     function WithdrawEther() external
1618     {
1619         data.WithdrawEther(msg.sender);
1620 
1621         CITYDATA memory cdata = dtGetCityData(msg.sender);
1622         UpdateCityData(cdata, 0, 0, 0, 0);
1623         dtSetCityData(msg.sender, cdata);
1624     }
1625 
1626     function GetEthShop() external view returns(uint256 shopEth, uint256 shopCredits)
1627     {
1628         (shopEth, shopCredits) = data.GetEthShop(msg.sender);
1629     }
1630 
1631     function TradeEthShop(uint256 credits) external
1632     {
1633         data.TradeEthShop(msg.sender, credits);
1634 
1635         CITYDATA memory cdata = dtGetCityData(msg.sender);
1636         UpdateCityData(cdata, 0, 0, credits, 0);
1637         dtSetCityData(msg.sender, cdata);
1638     }
1639 
1640     /////////////////////////////////////////////////////////////////
1641     // admin
1642     function adminIsAdmin() external view returns(bool)
1643     {
1644         return msg.sender == owner || msg.sender == admin;
1645     }
1646 
1647     function adminSetAdmin(address addr) external
1648     {
1649         require(msg.sender == owner);
1650 
1651         admin = addr;
1652     }
1653 
1654     function adminSetConfig(address dta, address cfg, address rnk) external
1655     {
1656         require(msg.sender == owner || msg.sender == admin);
1657 
1658         data = EtherCityData(dta);
1659         config = EtherCityConfig(cfg);
1660         rank = EtherCityRank(rnk);
1661     }
1662 
1663     function adminAddWorldBalance() external payable
1664     {
1665         require(msg.value > 0);
1666         require(msg.sender == owner || msg.sender == admin);
1667 
1668         UpdateEthBalance(msg.value, msg.value);
1669     }
1670 
1671     function adminGetBalance() external view returns(uint256 dta_bal, uint256 cfg_bal, uint256 rnk_bal, uint256 cty_bal)
1672     {
1673         require(msg.sender == owner || msg.sender == admin);
1674 
1675         dta_bal = address(data).balance;
1676         cfg_bal = address(config).balance;
1677         rnk_bal = address(rank).balance;
1678         cty_bal = address(this).balance;
1679     }
1680 
1681     /////////////////////////////////////////////////////////////////
1682     // internal
1683     function nowday() private view returns(uint256)
1684     {
1685         return block.timestamp / 24 hours;
1686     }
1687 
1688     function daytime(uint256 day) private pure returns(uint256)
1689     {
1690         return day * 24 hours;
1691     }
1692 
1693     function ConstructBuilding(CITYDATA memory cdata, uint256 id, uint256 count, bool byCredit) private returns(bool)
1694     {
1695         uint256 a_population;
1696         uint256 a_crdtsec;
1697         uint256 cnstcrdt;
1698         uint256 cnsteth;
1699 
1700         if (count > cdata.landUnoccupied)
1701             return false;
1702 
1703         (a_population, a_crdtsec) = UpdateBuildingParam(cdata, id, count, 0);
1704 
1705         if ((a_population == 0) && (a_crdtsec == 0))
1706             return false;
1707 
1708         (cnstcrdt, cnsteth) = config.GetConstructCost(id, count);
1709 
1710         if (!byCredit)
1711             UpdateEthBalance(cnsteth, msg.value);
1712 
1713         UpdateCityData(cdata, a_population, 0, cnstcrdt, a_crdtsec);
1714         if (a_population != 0)
1715             rank.UpdateRank(msg.sender, cdata.population, cdata.lasttime);
1716 
1717         return true;            
1718     }
1719 
1720     function UpdateBuildingParam(CITYDATA memory cdata, uint256 id, uint256 cnstcount, uint256 updcount) private returns(uint256 a_population, uint256 a_crdtsec)
1721     {
1722         uint256 population;
1723         uint256 crdtsec;
1724         uint256 maxupd;
1725         BUILDINGDATA memory bdata = dtGetBuildingData(msg.sender, id);
1726 
1727         if (bdata.upgradeCount == 0)
1728             bdata.upgradeCount = 1;
1729 
1730         a_population = 0;
1731         a_crdtsec = 0;
1732 
1733         (population, crdtsec, maxupd) = config.GetBuildingParam(id);
1734         if (cnstcount > cdata.landUnoccupied)
1735             return;
1736 
1737         cdata.landOccupied += cnstcount;
1738         cdata.landUnoccupied -= cnstcount;
1739 
1740         if (bdata.upgradeCount + updcount > maxupd)
1741             return;
1742 
1743         (a_population, a_crdtsec) = CalcBuildingParam(bdata);
1744         bdata.population = population;
1745         bdata.creditsPerSec = crdtsec;
1746         bdata.constructCount += cnstcount;
1747         bdata.upgradeCount += updcount;
1748         (population, crdtsec) = CalcBuildingParam(bdata);
1749 
1750         dtSetBuildingData(msg.sender, id, bdata);
1751 
1752         a_population = population - a_population;
1753         a_crdtsec = crdtsec - a_crdtsec;
1754     }
1755 
1756     function CalcBuildingParam(BUILDINGDATA memory bdata) private pure returns(uint256 population, uint256 crdtsec)
1757     {
1758         uint256 count;
1759 
1760         count = bdata.constructCount * bdata.upgradeCount;
1761         population = bdata.population * count;
1762         crdtsec = bdata.creditsPerSec * count;
1763     }
1764 
1765     function CalcIncCredits(CITYDATA memory cdata) private view returns(uint256)
1766     {
1767         return SafeMath.muldiv(cdata.creditsPerSec, block.timestamp - cdata.lasttime, INTFLOATDIV);
1768     }
1769 
1770     function UpdateCityData(CITYDATA memory cdata, uint256 pop, uint256 inccrdt, uint256 deccrdt, uint256 crdtsec) private
1771     {
1772         uint256 day;
1773 
1774         day = nowday();
1775 
1776         inccrdt += CalcIncCredits(cdata);
1777         require((cdata.credits + inccrdt) >= deccrdt);
1778 
1779         inccrdt -= deccrdt;
1780 
1781         cdata.population += pop;
1782         cdata.credits += inccrdt;
1783         cdata.creditsPerSec += crdtsec;
1784         cdata.lasttime = block.timestamp;
1785 
1786         WORLDDATA memory wdata = dtGetWorldData();
1787         wdata.population += pop;
1788         wdata.credits += inccrdt;
1789         dtSetWorldData(wdata);
1790 
1791         WORLDSNAPSHOT memory wss = dtValidateWorldSnapshot(day);
1792         wss.population += pop;
1793         wss.credits += inccrdt;
1794         wss.lasttime = block.timestamp;
1795         dtSetWorldSnapshot(day, wss);
1796 
1797         CITYSNAPSHOT memory css = dtValidateCitySnapshot(msg.sender, day);
1798         css.population += pop;
1799         css.credits += inccrdt;
1800         css.shopCredits += inccrdt;
1801         css.lasttime = block.timestamp;
1802         dtSetCitySnapshot(msg.sender, day, css);
1803     }
1804 
1805     function UpdateEthBalance(uint256 eth, uint256 val) private returns(bool)
1806     {
1807         uint256 devf;
1808         uint256 fndf;
1809         uint256 rnkf;
1810 
1811         if (eth > val)
1812         {
1813             fndf = dtGetEthBalance(msg.sender);
1814             require(eth - val <= fndf);
1815             dtSetEthBalance(msg.sender, fndf - eth + val);
1816         }
1817 
1818         devf = eth * 17 / 100;
1819         fndf = eth * 33 / 100;
1820         rnkf = fndf * 70 / 100;
1821 
1822         data.UpdateEthBalance.value(val)(eth - devf - fndf, devf, rnkf, fndf - rnkf);
1823     }
1824 
1825     /////////////////////////////////////////////////////////////////
1826     //
1827     function dtGetWorldData() private view returns(WORLDDATA memory wdata)
1828     {
1829          (wdata.ethBalance, wdata.ethDev, wdata.population, wdata.credits, wdata.starttime) = data.GetWorldData();
1830     }
1831 
1832     function dtSetWorldData(WORLDDATA memory wdata) private
1833     {
1834         data.SetWorldData(wdata.ethBalance, wdata.ethDev, wdata.population, wdata.credits, wdata.starttime);
1835     }
1836 
1837     function dtSetWorldSnapshot(uint256 day, WORLDSNAPSHOT memory wss) private
1838     {
1839         data.SetWorldSnapshot(day, true, wss.population, wss.credits, wss.lasttime);
1840     }
1841 
1842     function dtCreateCityData(address player, uint256 crdtsec, uint256 landcount) private returns(CITYDATA memory)
1843     {
1844         data.CreateCityData(player, crdtsec, landcount);
1845         return dtGetCityData(player);
1846     }
1847 
1848     function dtGetCityData(address player) private view returns(CITYDATA memory cdata)
1849     {
1850         (cdata.credits, cdata.population, cdata.creditsPerSec, cdata.landOccupied, cdata.landUnoccupied, cdata.lasttime) = data.GetCityData(player);
1851     }
1852 
1853     function dtSetCityData(address player, CITYDATA memory cdata) private
1854     {
1855         data.SetCityData(player, cdata.credits, cdata.population, cdata.creditsPerSec, cdata.landOccupied, cdata.landUnoccupied, cdata.lasttime);
1856     }
1857 
1858     function dtSetCitySnapshot(address player, uint256 day, CITYSNAPSHOT memory css) private
1859     {
1860         data.SetCitySnapshot(player, day, true, css.population, css.credits, css.shopCredits, css.lasttime);
1861     }
1862 
1863     function dtGetBuildingData(address player, uint256 id) private view returns(BUILDINGDATA memory bdata)
1864     {
1865         (bdata.constructCount, bdata.upgradeCount, bdata.population, bdata.creditsPerSec) = data.GetBuildingData(player, id);
1866     }
1867 
1868     function dtSetBuildingData(address player, uint256 id, BUILDINGDATA memory bdata) private
1869     {
1870         data.SetBuildingData(player, id, bdata.constructCount, bdata.upgradeCount, bdata.population, bdata.creditsPerSec);
1871     }
1872 
1873     function dtGetEthBalance(address player) private view returns(uint256)
1874     {
1875         return data.GetEthBalance(player);
1876     }
1877 
1878     function dtSetEthBalance(address player, uint256 eth) private
1879     {
1880         data.SetEthBalance(player, eth);
1881     }
1882 
1883     function dtAddEthBalance(address player, uint256 eth) private
1884     {
1885         data.AddEthBalance(player, eth);
1886     }
1887 
1888     function dtValidateWorldSnapshot(uint256 day) private returns(WORLDSNAPSHOT memory wss)
1889     {
1890         uint256 ethRankFund;
1891 
1892         (ethRankFund, wss.population, wss.credits, wss.lasttime) = data.ValidateWorldSnapshot(day);
1893     }
1894 
1895     function dtTestWorldSnapshot(uint256 day) private view returns(uint256 ethRankFund, WORLDSNAPSHOT memory wss)
1896     {
1897         (ethRankFund, wss.population, wss.credits, wss.lasttime) = data.TestWorldSnapshot(day);
1898     }
1899 
1900     function dtValidateCitySnapshot(address player, uint256 day) private returns(CITYSNAPSHOT memory css)
1901     {
1902         (css.population, css.credits, css.shopCredits, css.lasttime) = data.ValidateCitySnapshot(player, day);
1903     }
1904 
1905     function dtTestCitySnapshot(address player, uint256 day) private view returns(CITYSNAPSHOT memory css)
1906     {
1907         (css.population, css.credits, css.shopCredits, css.lasttime) = data.TestCitySnapshot(player, day);
1908     }
1909 }