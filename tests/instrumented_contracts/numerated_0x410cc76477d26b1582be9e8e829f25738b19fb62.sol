1 pragma solidity ^0.4.19;
2 
3 library OwnershipTypes{
4     using Serializer for Serializer.DataComponent;
5 
6     struct Ownership
7     {
8         address m_Owner; // 0
9         uint32 m_OwnerInventoryIndex; // 20
10     }
11 
12     function SerializeOwnership(Ownership ownership) internal pure returns (bytes32)
13     {
14         Serializer.DataComponent memory data;
15         data.WriteAddress(0, ownership.m_Owner);
16         data.WriteUint32(20, ownership.m_OwnerInventoryIndex);
17 
18         return data.m_Raw;
19     }
20 
21     function DeserializeOwnership(bytes32 raw) internal pure returns (Ownership)
22     {
23         Ownership memory ownership;
24 
25         Serializer.DataComponent memory data;
26         data.m_Raw = raw;
27 
28         ownership.m_Owner = data.ReadAddress(0);
29         ownership.m_OwnerInventoryIndex = data.ReadUint32(20);
30 
31         return ownership;
32     }
33 }
34 library LibStructs{
35     using Serializer for Serializer.DataComponent;
36     // HEROES
37 
38     struct Hero {
39         uint16 stockID;
40         uint8 rarity;
41         uint16 hp;
42         uint16 atk;
43         uint16 def;
44         uint16 agi;
45         uint16 intel;
46         uint16 cHp;
47         //uint8 cenas;
48         // uint8 critic;
49         // uint8 healbonus;
50         // uint8 atackbonus;
51         // uint8 defensebonus;
52 
53         uint8 isForSale;
54         uint8 lvl;
55         uint16 xp;
56     }
57     struct StockHero {uint16 price;uint8 stars;uint8 mainOnePosition;uint8 mainTwoPosition;uint16 stock;uint8 class;}
58 
59     function SerializeHero(Hero hero) internal pure returns (bytes32){
60         Serializer.DataComponent memory data;
61         data.WriteUint16(0, hero.stockID);
62         data.WriteUint8(2, hero.rarity);
63         //data.WriteUint8(2, hero.m_IsForSale);
64         //data.WriteUint8(3, rocket.m_Unused3);
65         data.WriteUint16(4, hero.hp);
66         data.WriteUint16(6, hero.atk);
67         data.WriteUint16(8, hero.def);
68         data.WriteUint16(10, hero.agi);
69         data.WriteUint16(12, hero.intel);
70         data.WriteUint16(14, hero.cHp);
71 
72         // data.WriteUint8(16, hero.class);
73         // data.WriteUint8(17, hero.healbonus);
74         // data.WriteUint8(18, hero.atackbonus);
75         // data.WriteUint8(19, hero.defensebonus);
76 
77         data.WriteUint8(20, hero.isForSale);
78         data.WriteUint8(21, hero.lvl);
79         data.WriteUint16(23, hero.xp);
80 
81         return data.m_Raw;
82     }
83     function DeserializeHero(bytes32 raw) internal pure returns (Hero){
84         Hero memory hero;
85 
86         Serializer.DataComponent memory data;
87         data.m_Raw = raw;
88 
89         hero.stockID = data.ReadUint16(0);
90         //hero.rarity = data.ReadUint8(1);
91         hero.rarity = data.ReadUint8(2);
92         //rocket.m_Unused3 = data.ReadUint8(3);
93         hero.hp = data.ReadUint16(4);
94         hero.atk = data.ReadUint16(6);
95         hero.def = data.ReadUint16(8);
96         hero.agi = data.ReadUint16(10);
97         hero.intel = data.ReadUint16(12);
98         hero.cHp = data.ReadUint16(14);
99 
100         // hero.class = data.ReadUint8(16);
101         // hero.healbonus = data.ReadUint8(17);
102         // hero.atackbonus = data.ReadUint8(18);
103         // hero.defensebonus = data.ReadUint8(19);
104 
105         hero.isForSale = data.ReadUint8(20);
106         hero.lvl = data.ReadUint8(21);
107         hero.xp = data.ReadUint16(23);
108 
109         return hero;
110     }
111     function SerializeStockHero(StockHero stockhero) internal pure returns (bytes32){
112         // string name;uint64 price;uint8 stars;uint8 mainOnePosition;uint8 mainTwoPosition;
113 
114         Serializer.DataComponent memory data;
115         data.WriteUint16(0, stockhero.price);
116         data.WriteUint8(2, stockhero.stars);
117         data.WriteUint8(3, stockhero.mainOnePosition);
118         data.WriteUint8(4, stockhero.mainTwoPosition);
119         data.WriteUint16(5, stockhero.stock);
120         data.WriteUint8(7, stockhero.class);
121 
122 
123         return data.m_Raw;
124     }
125     function DeserializeStockHero(bytes32 raw) internal pure returns (StockHero){
126         StockHero memory stockhero;
127 
128         Serializer.DataComponent memory data;
129         data.m_Raw = raw;
130 
131         stockhero.price = data.ReadUint16(0);
132         stockhero.stars = data.ReadUint8(2);
133         stockhero.mainOnePosition = data.ReadUint8(3);
134         stockhero.mainTwoPosition = data.ReadUint8(4);
135         stockhero.stock = data.ReadUint16(5);
136         stockhero.class = data.ReadUint8(7);
137 
138         return stockhero;
139     }
140     // ITEMS
141     struct Item {
142         uint16 stockID;
143         uint8 lvl;
144         uint8 rarity;
145         uint16 hp;
146         uint16 atk;
147         uint16 def;
148         uint16 agi;
149         uint16 intel;
150 
151         uint8 critic;
152         uint8 healbonus;
153         uint8 atackbonus;
154         uint8 defensebonus;
155 
156         uint8 isForSale;
157         uint8 grade;
158     }
159     struct StockItem {uint16 price;uint8 stars;uint8 lvl;uint8 mainOnePosition;uint8 mainTwoPosition;uint16[5] stats;uint8[4] secstats;uint8 cat;uint8 subcat;} // 1 finney = 0.0001 ether
160 
161     function SerializeItem(Item item) internal pure returns (bytes32){
162         Serializer.DataComponent memory data;
163 
164         data.WriteUint16(0, item.stockID);
165         data.WriteUint8(4, item.lvl);
166         data.WriteUint8(5, item.rarity);
167         data.WriteUint16(6, item.hp);
168         data.WriteUint16(8, item.atk);
169         data.WriteUint16(10, item.def);
170         data.WriteUint16(12, item.agi);
171         data.WriteUint16(14, item.intel);
172         // data.WriteUint32(14, item.cHp);
173 
174         data.WriteUint8(16, item.critic);
175         data.WriteUint8(17, item.healbonus);
176         data.WriteUint8(18, item.atackbonus);
177         data.WriteUint8(19, item.defensebonus);
178 
179         data.WriteUint8(20, item.isForSale);
180         data.WriteUint8(21, item.grade);
181 
182 
183         return data.m_Raw;
184 
185     }
186     function DeserializeItem(bytes32 raw) internal pure returns (Item){
187         Item memory item;
188 
189         Serializer.DataComponent memory data;
190         data.m_Raw = raw;
191 
192         item.stockID = data.ReadUint16(0);
193 
194         item.lvl = data.ReadUint8(4);
195         item.rarity = data.ReadUint8(5);
196         item.hp = data.ReadUint16(6);
197         item.atk = data.ReadUint16(8);
198         item.def = data.ReadUint16(10);
199         item.agi = data.ReadUint16(12);
200         item.intel = data.ReadUint16(14);
201 
202         item.critic = data.ReadUint8(16);
203         item.healbonus = data.ReadUint8(17);
204         item.atackbonus = data.ReadUint8(18);
205         item.defensebonus = data.ReadUint8(19);
206 
207         item.isForSale = data.ReadUint8(20);
208         item.grade = data.ReadUint8(21);
209 
210 
211         return item;
212     }
213     function SerializeStockItem(StockItem stockitem) internal pure returns (bytes32){
214         // string name;uint64 price;uint8 stars;uint8 mainOnePosition;uint8 mainTwoPosition;uint8 mainThreePosition;
215         // uint16[] stats;uint8[] secstats;
216 
217         Serializer.DataComponent memory data;
218         data.WriteUint16(0, stockitem.price);
219         data.WriteUint8(2, stockitem.stars);
220         data.WriteUint8(3, stockitem.lvl);
221         data.WriteUint8(4, stockitem.mainOnePosition);
222         data.WriteUint8(5, stockitem.mainTwoPosition);
223         //data.WriteUint8(12, stockitem.mainThreePosition);
224         //stats
225         data.WriteUint16(6, stockitem.stats[0]);
226         data.WriteUint16(8, stockitem.stats[1]);
227         data.WriteUint16(10, stockitem.stats[2]);
228         data.WriteUint16(12, stockitem.stats[3]);
229         data.WriteUint16(14, stockitem.stats[4]);
230         //secstats
231         data.WriteUint8(16, stockitem.secstats[0]);
232         data.WriteUint8(17, stockitem.secstats[1]);
233         data.WriteUint8(18, stockitem.secstats[2]);
234         data.WriteUint8(19, stockitem.secstats[3]);
235 
236         data.WriteUint8(20, stockitem.cat);
237         data.WriteUint8(21, stockitem.subcat);
238 
239 
240         return data.m_Raw;
241     }
242     function DeserializeStockItem(bytes32 raw) internal pure returns (StockItem){
243         StockItem memory stockitem;
244 
245         Serializer.DataComponent memory data;
246         data.m_Raw = raw;
247 
248         stockitem.price = data.ReadUint16(0);
249         stockitem.stars = data.ReadUint8(2);
250         stockitem.lvl = data.ReadUint8(3);
251         stockitem.mainOnePosition = data.ReadUint8(4);
252         stockitem.mainTwoPosition = data.ReadUint8(5);
253         //stockitem.mainThreePosition = data.ReadUint8(12);
254 
255         stockitem.stats[0] = data.ReadUint16(6);
256         stockitem.stats[1] = data.ReadUint16(8);
257         stockitem.stats[2] = data.ReadUint16(10);
258         stockitem.stats[3] = data.ReadUint16(12);
259         stockitem.stats[4] = data.ReadUint16(14);
260 
261         stockitem.secstats[0] = data.ReadUint8(16);
262         stockitem.secstats[1] = data.ReadUint8(17);
263         stockitem.secstats[2] = data.ReadUint8(18);
264         stockitem.secstats[3] = data.ReadUint8(19);
265 
266         stockitem.cat = data.ReadUint8(20);
267         stockitem.subcat = data.ReadUint8(21);
268 
269         return stockitem;
270     }
271 
272     struct Action {uint16 actionID;uint8 actionType;uint16 finneyCost;uint32 cooldown;uint8 lvl;uint8 looted;uint8 isDaily;}
273     function SerializeAction(Action action) internal pure returns (bytes32){
274         Serializer.DataComponent memory data;
275         data.WriteUint16(0, action.actionID);
276         data.WriteUint8(2, action.actionType);
277         data.WriteUint16(3, action.finneyCost);
278         data.WriteUint32(5, action.cooldown);
279         data.WriteUint8(9, action.lvl);
280         data.WriteUint8(10, action.looted);
281         data.WriteUint8(11, action.isDaily);
282 
283         return data.m_Raw;
284     }
285     function DeserializeAction(bytes32 raw) internal pure returns (Action){
286         Action memory action;
287 
288         Serializer.DataComponent memory data;
289         data.m_Raw = raw;
290 
291         action.actionID = data.ReadUint16(0);
292         action.actionType = data.ReadUint8(2);
293         action.finneyCost = data.ReadUint16(3);
294         action.cooldown = data.ReadUint32(5);
295         action.lvl = data.ReadUint8(9);
296         action.looted = data.ReadUint8(10);
297         action.isDaily = data.ReadUint8(11);
298 
299         return action;
300     }
301 
302     struct Mission {uint8 dificulty;uint16[4] stockitemId_drops;uint16[5] statsrequired;uint16 count;}
303     function SerializeMission(Mission mission) internal pure returns (bytes32){
304         Serializer.DataComponent memory data;
305         data.WriteUint8(0, mission.dificulty);
306         data.WriteUint16(1, mission.stockitemId_drops[0]);
307         data.WriteUint16(5, mission.stockitemId_drops[1]);
308         data.WriteUint16(9, mission.stockitemId_drops[2]);
309         data.WriteUint16(13, mission.stockitemId_drops[3]);
310 
311         data.WriteUint16(15, mission.statsrequired[0]);
312         data.WriteUint16(17, mission.statsrequired[1]);
313         data.WriteUint16(19, mission.statsrequired[2]);
314         data.WriteUint16(21, mission.statsrequired[3]);
315         data.WriteUint16(23, mission.statsrequired[4]);
316 
317         data.WriteUint16(25, mission.count);
318 
319         return data.m_Raw;
320     }
321     function DeserializeMission(bytes32 raw) internal pure returns (Mission){
322         Mission memory mission;
323 
324         Serializer.DataComponent memory data;
325         data.m_Raw = raw;
326 
327         mission.dificulty = data.ReadUint8(0);
328         mission.stockitemId_drops[0] = data.ReadUint16(1);
329         mission.stockitemId_drops[1] = data.ReadUint16(5);
330         mission.stockitemId_drops[2] = data.ReadUint16(9);
331         mission.stockitemId_drops[3] = data.ReadUint16(13);
332 
333         mission.statsrequired[0] = data.ReadUint16(15);
334         mission.statsrequired[1] = data.ReadUint16(17);
335         mission.statsrequired[2] = data.ReadUint16(19);
336         mission.statsrequired[3] = data.ReadUint16(21);
337         mission.statsrequired[4] = data.ReadUint16(23);
338 
339         mission.count = data.ReadUint16(25);
340 
341         return mission;
342     }
343 
344     function toWei(uint80 price) public returns(uint256 value){
345         value = price;
346         value = value * 1 finney;
347 
348     }
349 
350 }
351 library GlobalTypes{
352     using Serializer for Serializer.DataComponent;
353 
354     struct Global
355     {
356         uint32 m_LastHeroId; // 0
357         uint32 m_LastItem; // 4
358         uint8 m_Unused8; // 8
359         uint8 m_Unused9; // 9
360         uint8 m_Unused10; // 10
361         uint8 m_Unused11; // 11
362     }
363 
364     function SerializeGlobal(Global global) internal pure returns (bytes32)
365     {
366         Serializer.DataComponent memory data;
367         data.WriteUint32(0, global.m_LastHeroId);
368         data.WriteUint32(4, global.m_LastItem);
369         data.WriteUint8(8, global.m_Unused8);
370         data.WriteUint8(9, global.m_Unused9);
371         data.WriteUint8(10, global.m_Unused10);
372         data.WriteUint8(11, global.m_Unused11);
373 
374         return data.m_Raw;
375     }
376 
377     function DeserializeGlobal(bytes32 raw) internal pure returns (Global)
378     {
379         Global memory global;
380 
381         Serializer.DataComponent memory data;
382         data.m_Raw = raw;
383 
384         global.m_LastHeroId = data.ReadUint32(0);
385         global.m_LastItem = data.ReadUint32(4);
386         global.m_Unused8 = data.ReadUint8(8);
387         global.m_Unused9 = data.ReadUint8(9);
388         global.m_Unused10 = data.ReadUint8(10);
389         global.m_Unused11 = data.ReadUint8(11);
390 
391         return global;
392     }
393 
394 
395 }
396 library MarketTypes{
397     using Serializer for Serializer.DataComponent;
398 
399     struct MarketListing
400     {
401         uint128 m_Price; // 0
402     }
403 
404     function SerializeMarketListing(MarketListing listing) internal pure returns (bytes32)
405     {
406         Serializer.DataComponent memory data;
407         data.WriteUint128(0, listing.m_Price);
408 
409         return data.m_Raw;
410     }
411 
412     function DeserializeMarketListing(bytes32 raw) internal pure returns (MarketListing)
413     {
414         MarketListing memory listing;
415 
416         Serializer.DataComponent memory data;
417         data.m_Raw = raw;
418 
419         listing.m_Price = data.ReadUint128(0);
420 
421         return listing;
422     }
423 }
424 library Serializer{
425     struct DataComponent
426     {
427         bytes32 m_Raw;
428     }
429 
430     function ReadUint8(DataComponent memory self, uint32 offset) internal pure returns (uint8)
431     {
432         return uint8((self.m_Raw >> (offset * 8)) & 0xFF);
433     }
434 
435     function WriteUint8(DataComponent memory self, uint32 offset, uint8 value) internal pure
436     {
437         self.m_Raw |= (bytes32(value) << (offset * 8));
438     }
439 
440     function ReadUint16(DataComponent memory self, uint32 offset) internal pure returns (uint16)
441     {
442         return uint16((self.m_Raw >> (offset * 8)) & 0xFFFF);
443     }
444 
445     function WriteUint16(DataComponent memory self, uint32 offset, uint16 value) internal pure
446     {
447         self.m_Raw |= (bytes32(value) << (offset * 8));
448     }
449 
450     function ReadUint32(DataComponent memory self, uint32 offset) internal pure returns (uint32)
451     {
452         return uint32((self.m_Raw >> (offset * 8)) & 0xFFFFFFFF);
453     }
454 
455     function WriteUint32(DataComponent memory self, uint32 offset, uint32 value) internal pure
456     {
457         self.m_Raw |= (bytes32(value) << (offset * 8));
458     }
459 
460     function ReadUint64(DataComponent memory self, uint32 offset) internal pure returns (uint64)
461     {
462         return uint64((self.m_Raw >> (offset * 8)) & 0xFFFFFFFFFFFFFFFF);
463     }
464 
465     function WriteUint64(DataComponent memory self, uint32 offset, uint64 value) internal pure
466     {
467         self.m_Raw |= (bytes32(value) << (offset * 8));
468     }
469 
470     function ReadUint80(DataComponent memory self, uint32 offset) internal pure returns (uint80)
471     {
472         return uint80((self.m_Raw >> (offset * 8)) & 0xFFFFFFFFFFFFFFFFFFFF);
473     }
474 
475     function WriteUint80(DataComponent memory self, uint32 offset, uint80 value) internal pure
476     {
477         self.m_Raw |= (bytes32(value) << (offset * 8));
478     }
479 
480     function ReadUint128(DataComponent memory self, uint128 offset) internal pure returns (uint128)
481     {
482         return uint128((self.m_Raw >> (offset * 8)) & 0xFFFFFFFFFFFFFFFFFFFF);
483     }
484 
485     function WriteUint128(DataComponent memory self, uint32 offset, uint128 value) internal pure
486     {
487         self.m_Raw |= (bytes32(value) << (offset * 8));
488     }
489 
490     function ReadAddress(DataComponent memory self, uint32 offset) internal pure returns (address)
491     {
492         return address((self.m_Raw >> (offset * 8)) & (
493         (0xFFFFFFFF << 0)  |
494         (0xFFFFFFFF << 32) |
495         (0xFFFFFFFF << 64) |
496         (0xFFFFFFFF << 96) |
497         (0xFFFFFFFF << 128)
498         ));
499     }
500 
501     function WriteAddress(DataComponent memory self, uint32 offset, address value) internal pure
502     {
503         self.m_Raw |= (bytes32(value) << (offset * 8));
504     }
505 }
506 library SafeMath {
507 
508     /**
509      * @dev Multiplies two numbers, throws on overflow.
510      */
511     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
512         if (a == 0) {
513             return 0;
514         }
515         uint256 c = a * b;
516         assert(c / a == b);
517         return c;
518     }
519 
520     /**
521      * @dev Integer division of two numbers, truncating the quotient.
522      */
523     function div(uint256 a, uint256 b) internal pure returns (uint256) {
524         // assert(b > 0); // Solidity automatically throws when dividing by 0
525         uint256 c = a / b;
526         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
527         return c;
528     }
529 
530     /**
531      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
532      */
533     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
534         assert(b <= a);
535         return a - b;
536     }
537 
538     /**
539      * @dev Adds two numbers, throws on overflow.
540      */
541     function add(uint256 a, uint256 b) internal pure returns (uint256) {
542         uint256 c = a + b;
543         assert(c >= a);
544         return c;
545     }
546 }
547 library SafeMath32 {
548 
549     /**
550      * @dev Multiplies two numbers, throws on overflow.
551      */
552     function mul(uint32 a, uint32 b) internal pure returns (uint32) {
553         if (a == 0) {
554             return 0;
555         }
556         uint32 c = a * b;
557         assert(c / a == b);
558         return c;
559     }
560 
561     /**
562      * @dev Integer division of two numbers, truncating the quotient.
563      */
564     function div(uint32 a, uint32 b) internal pure returns (uint32) {
565         // assert(b > 0); // Solidity automatically throws when dividing by 0
566         uint32 c = a / b;
567         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
568         return c;
569     }
570 
571     /**
572      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
573      */
574     function sub(uint32 a, uint32 b) internal pure returns (uint32) {
575         assert(b <= a);
576         return a - b;
577     }
578 
579     /**
580      * @dev Adds two numbers, throws on overflow.
581      */
582     function add(uint32 a, uint32 b) internal pure returns (uint32) {
583         uint32 c = a + b;
584         assert(c >= a);
585         return c;
586     }
587 }
588 library SafeMath16 {
589 
590     /**
591      * @dev Multiplies two numbers, throws on overflow.
592      */
593     function mul(uint16 a, uint16 b) internal pure returns (uint16) {
594         if (a == 0) {
595             return 0;
596         }
597         uint16 c = a * b;
598         assert(c / a == b);
599         return c;
600     }
601 
602     /**
603      * @dev Integer division of two numbers, truncating the quotient.
604      */
605     function div(uint16 a, uint16 b) internal pure returns (uint16) {
606         // assert(b > 0); // Solidity automatically throws when dividing by 0
607         uint16 c = a / b;
608         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
609         return c;
610     }
611 
612     /**
613      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
614      */
615     function sub(uint16 a, uint16 b) internal pure returns (uint16) {
616         assert(b <= a);
617         return a - b;
618     }
619 
620     /**
621      * @dev Adds two numbers, throws on overflow.
622      */
623     function add(uint16 a, uint16 b) internal pure returns (uint16) {
624         uint16 c = a + b;
625         assert(c >= a);
626         return c;
627     }
628 }
629 library SafeMath8 {
630 
631     /**
632      * @dev Multiplies two numbers, throws on overflow.
633      */
634     function mul(uint8 a, uint8 b) internal pure returns (uint8) {
635         if (a == 0) {
636             return 0;
637         }
638         uint8 c = a * b;
639         assert(c / a == b);
640         return c;
641     }
642 
643     /**
644      * @dev Integer division of two numbers, truncating the quotient.
645      */
646     function div(uint8 a, uint8 b) internal pure returns (uint8) {
647         // assert(b > 0); // Solidity automatically throws when dividing by 0
648         uint8 c = a / b;
649         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
650         return c;
651     }
652 
653     /**
654      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
655      */
656     function sub(uint8 a, uint8 b) internal pure returns (uint8) {
657         assert(b <= a);
658         return a - b;
659     }
660 
661     /**
662      * @dev Adds two numbers, throws on overflow.
663      */
664     function add(uint8 a, uint8 b) internal pure returns (uint8) {
665         uint8 c = a + b;
666         assert(c >= a);
667         return c;
668     }
669 }
670 
671 contract ProfitManager
672 {
673     address public m_Owner;
674     bool public m_Paused;
675     AbstractDatabase m_Database= AbstractDatabase(0x400d188e1c21d592820df1f2f8cf33b3a13a377e);
676 
677     modifier NotWhilePaused()
678     {
679         require(m_Paused == false);
680         _;
681     }
682     modifier OnlyOwner(){
683     require(msg.sender == m_Owner);
684     _;
685 }
686 
687     address constant NullAddress = 0;
688 
689     //Market
690     uint256 constant ProfitFundsCategory = 14;
691     uint256 constant WithdrawalFundsCategory = 15;
692     uint256 constant HeroMarketCategory = 16;
693     
694     //ReferalCategory
695     uint256 constant ReferalCategory = 237;
696 
697     function ProfitManager() public {
698     m_Owner = msg.sender;
699     m_Paused = true;
700 }
701     function Unpause() public OnlyOwner()
702     {
703         m_Paused = false;
704     }
705 
706     function Pause() public OnlyOwner()
707     {
708         require(m_Paused == false);
709 
710         m_Paused = true;
711     }
712 
713     // 1 write
714     function WithdrawProfitFunds(uint256 withdraw_amount, address beneficiary) public NotWhilePaused() OnlyOwner()
715     {
716         uint256 profit_funds = uint256(m_Database.Load(NullAddress, ProfitFundsCategory, 0));
717         require(withdraw_amount > 0);
718         require(withdraw_amount <= profit_funds);
719         require(beneficiary != address(0));
720         require(beneficiary != address(this));
721         require(beneficiary != address(m_Database));
722 
723         profit_funds -= withdraw_amount;
724 
725         m_Database.Store(NullAddress, ProfitFundsCategory, 0, bytes32(profit_funds));
726 
727         m_Database.TransferFunds(beneficiary, withdraw_amount);
728     }
729 
730     // 1 write
731     function WithdrawWinnings(uint256 withdraw_amount) public NotWhilePaused()
732     {
733 
734         require(withdraw_amount > 0);
735 
736         uint256 withdrawal_funds = uint256(m_Database.Load(msg.sender, WithdrawalFundsCategory, 0));
737         require(withdraw_amount <= withdrawal_funds);
738 
739         withdrawal_funds -= withdraw_amount;
740 
741         m_Database.Store(msg.sender, WithdrawalFundsCategory, 0, bytes32(withdrawal_funds));
742 
743         m_Database.TransferFunds(msg.sender, withdraw_amount);
744     }
745 
746     function GetProfitFunds() view public OnlyOwner() returns (uint256 funds)
747     {
748         uint256 profit_funds = uint256(m_Database.Load(NullAddress, ProfitFundsCategory, 0));
749         return profit_funds;
750     }
751     function GetWithdrawalFunds(address target) view public NotWhilePaused() returns (uint256 funds)
752     {
753         funds = uint256(m_Database.Load(target, WithdrawalFundsCategory, 0));
754     }
755 
756 }
757 
758 contract AbstractDatabase
759 {
760     function() public payable;
761     function ChangeOwner(address new_owner) public;
762     function ChangeOwner2(address new_owner) public;
763     function Store(address user, uint256 category, uint256 slot, bytes32 data) public;
764     function Load(address user, uint256 category, uint256 index) public view returns (bytes32);
765     function TransferFunds(address target, uint256 transfer_amount) public;
766     function getRandom(uint256 upper, uint8 seed) public returns (uint256 number);
767 }