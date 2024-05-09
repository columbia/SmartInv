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
671 contract HeroHelperBuy
672 {
673     address public m_Owner;
674     address public partner1;
675     uint8 public percent1;
676     address public partner2;
677     uint8 public percent2;
678 
679     bool public m_Paused;
680     AbstractDatabase m_Database= AbstractDatabase(0x400d188e1c21d592820df1f2f8cf33b3a13a377e);
681     BitGuildToken public tokenContract = BitGuildToken(0x7E43581b19ab509BCF9397a2eFd1ab10233f27dE); // Predefined PLAT token address
682     address public bitGuildAddress = 0x89a196a34B7820bC985B98096ED5EFc7c4DC8363;
683     mapping(address => bool)  public trustedContracts;
684     using SafeMath for uint256;
685     using SafeMath32 for uint32;
686     using SafeMath16 for uint16;
687     using SafeMath8 for uint8;
688 
689     modifier OnlyOwner(){
690         require(msg.sender == m_Owner || trustedContracts[msg.sender]);
691         _;
692     }
693 
694     modifier onlyOwnerOf(uint _hero_id) {
695         OwnershipTypes.Ownership memory ownership = OwnershipTypes.DeserializeOwnership(m_Database.Load(NullAddress, OwnershipHeroCategory, _hero_id));
696         require(ownership.m_Owner == msg.sender);
697         _;
698     }
699     
700     function ChangeAddressTrust(address contract_address,bool trust_flag) public OnlyOwner()
701     {
702         trustedContracts[contract_address] = trust_flag;
703     }
704 
705     address constant NullAddress = 0;
706 
707     uint256 constant GlobalCategory = 0;
708 
709     //Hero
710     uint256 constant HeroCategory = 1;
711     uint256 constant HeroStockCategory = 2;
712     uint256 constant InventoryHeroCategory = 3;
713 
714     uint256 constant OwnershipHeroCategory = 10;
715     uint256 constant OwnershipItemCategory = 11;
716     uint256 constant OwnershipAbilitiesCategory = 12;
717 
718     //Market
719     uint256 constant ProfitFundsCategory = 14;
720     uint256 constant WithdrawalFundsCategory = 15;
721     uint256 constant HeroMarketCategory = 16;
722 
723     //Action
724     uint256 constant ActionCategory = 20;
725     uint256 constant MissionCategory = 17;
726     uint256 constant ActionHeroCategory = 18;
727 
728     //ReferalCategory
729     uint256 constant ReferalCategory = 237;
730 
731     using Serializer for Serializer.DataComponent;
732 
733     function ChangeOwner(address new_owner) public OnlyOwner(){
734         m_Owner = new_owner;
735     }
736 
737     function ChangePartners(address _partner1,uint8 _percent1,address _partner2,uint8 _percent2) public OnlyOwner(){
738         partner1 = _partner1;
739         percent1 = _percent1;
740         partner2 = _partner2;
741         percent2 = _percent2;
742     }
743     function ChangeDatabase(address db) public OnlyOwner(){
744         m_Database = AbstractDatabase(db);
745     }
746     // function ChangeHeroHelperOraclize(address new_heroOraclize) public OnlyOwner(){
747     //     m_HeroHelperOraclize = AbstractHeroHelperOraclize(new_heroOraclize);
748     // }
749     function HeroHelperBuy() public{
750         m_Owner = msg.sender;
751         m_Paused = true;
752     }
753 
754     
755     function GetHeroStock(uint16 stockhero_id)  private view returns (LibStructs.StockHero){
756         LibStructs.StockHero memory stockhero = LibStructs.DeserializeStockHero(m_Database.Load(NullAddress, HeroStockCategory, stockhero_id));
757         return stockhero;
758     }
759     
760     function GetHeroStockPrice(uint16 stockhero_id)  public view returns (uint){
761         LibStructs.StockHero memory stockhero = LibStructs.DeserializeStockHero(m_Database.Load(NullAddress, HeroStockCategory, stockhero_id));
762         return stockhero.price;
763     }
764 
765     function GetHeroCount(address _owner) public view returns (uint32){
766         return uint32(m_Database.Load(_owner, HeroCategory, 0));
767     }
768     
769     function receiveApproval(address _sender, uint256 _value, BitGuildToken _tokenContract, bytes _extraData) public {
770         require(_tokenContract == tokenContract);
771         require(_tokenContract.transferFrom(_sender, address(m_Database), _value));
772         require(_extraData.length != 0);
773           
774         uint16 hero_id = uint16(_bytesToUint(_extraData));    
775         
776         BuyStockHeroP1(hero_id,_value,_sender);
777     }
778     
779     event BuyStockHeroEvent(address indexed buyer, uint32 stock_id, uint32 hero_id);
780     event showValues(uint256 _value,uint256 _price,uint256 _stock,uint256 hero_id);
781     function _bytesToUint(bytes _b) public pure returns(uint256) {
782         uint256 number;
783         for (uint i=0; i < _b.length; i++) {
784             number = number + uint(_b[i]) * (2**(8 * (_b.length - (i+1))));
785         }
786         return number;
787     }
788     function BuyStockHeroP1(uint16 stock_id,uint256 _value,address _sender) public {
789         
790         LibStructs.StockHero memory prehero = GetHeroStock(stock_id);
791         uint256 finneyPrice = prehero.price;
792         finneyPrice = finneyPrice.mul( 1000000000000000000 );
793         showValues(_value, finneyPrice,prehero.stock,stock_id);
794         
795         require(_value  == finneyPrice && prehero.stock > 0);
796         
797         
798         BuyStockHeroP2(_sender,stock_id,m_Database.getRandom(100,uint8(_sender)));
799         
800     }
801     function giveHeroRandomRarity(address target,uint16 stock_id,uint random) public OnlyOwner(){
802         BuyStockHeroP2(target,stock_id,random);
803     }
804     function BuyStockHeroP2(address target,uint16 stock_id,uint random) internal{
805         
806         uint256 inventory_count;
807         LibStructs.StockHero memory prehero = GetHeroStock(stock_id);
808         LibStructs.Hero memory hero = buyHero(prehero,stock_id,random);
809         GlobalTypes.Global memory global = GlobalTypes.DeserializeGlobal(m_Database.Load(NullAddress, GlobalCategory, 0));
810 
811         uint256 finneyPrice = prehero.price*1000000000000000000;
812         prehero.stock = prehero.stock.sub(1);
813 
814         global.m_LastHeroId = global.m_LastHeroId.add(1);
815         uint32 next_hero_id = global.m_LastHeroId;
816         inventory_count = GetInventoryHeroCount(target);
817 
818         inventory_count = inventory_count.add(1);
819 
820 
821         OwnershipTypes.Ownership memory ownership;
822         ownership.m_Owner = target;
823         ownership.m_OwnerInventoryIndex = uint32(inventory_count.sub(1));
824 
825         m_Database.Store(target, InventoryHeroCategory, inventory_count, bytes32(next_hero_id)); // coloca na posiçao nova o heroi
826         m_Database.Store(target, InventoryHeroCategory, 0, bytes32(inventory_count)); // coloco na posiçao zero o count do mapping :) admira te
827 
828         m_Database.Store(NullAddress, HeroStockCategory, stock_id, LibStructs.SerializeStockHero(prehero));
829         m_Database.Store(NullAddress, HeroCategory, next_hero_id, LibStructs.SerializeHero(hero));
830         m_Database.Store(NullAddress, OwnershipHeroCategory, next_hero_id, OwnershipTypes.SerializeOwnership(ownership));
831         m_Database.Store(NullAddress, GlobalCategory, 0, GlobalTypes.SerializeGlobal(global));
832        
833         divProfit(finneyPrice);
834 
835         BuyStockHeroEvent(target, stock_id, next_hero_id);
836 
837         
838     }
839     
840     function divProfit(uint _value) internal{
841      
842          uint256 profit_funds = uint256(m_Database.Load(bitGuildAddress, WithdrawalFundsCategory, 0));
843          profit_funds = profit_funds.add(_value.div(10).mul(3));//30%
844          m_Database.Store(bitGuildAddress, WithdrawalFundsCategory, 0, bytes32(profit_funds));
845     
846          profit_funds = uint256(m_Database.Load(NullAddress, ProfitFundsCategory, 0));
847          profit_funds = profit_funds.add(_value.div(10).mul(7));//70%
848          m_Database.Store(NullAddress, ProfitFundsCategory, 0, bytes32(profit_funds));
849      
850     }
851 
852     function GetInventoryHeroCount(address target) view public returns (uint256){
853         require(target != address(0));
854 
855         uint256 inventory_count = uint256(m_Database.Load(target, InventoryHeroCategory, 0));
856 
857         return inventory_count;
858     }
859     
860     function buyHero(LibStructs.StockHero prehero,uint16 stock_id,uint random) internal returns(LibStructs.Hero hero){
861         
862         uint8 rarity = 1;
863         if(random == 99){ // comum
864             rarity = 5;
865         }else if( random >= 54 && random <= 79  ){ // incomun
866             rarity = 2;
867         }else if(random >= 80 && random <= 92){ // raro
868             rarity = 3;
869         }else if(random >= 93 && random <= 98){ // epico
870             rarity = 4;
871         }else{
872             rarity = 1;
873         }
874         
875         uint16[5] memory mainStats = generateHeroStats(prehero,rarity);
876         hero = assembleHero(mainStats,rarity,stock_id);
877         return hero;
878 
879     }
880     
881     function assembleHero(uint16[5] _mainStats,uint8 _rarity,uint16 stock_id) private pure returns(LibStructs.Hero){
882         uint16 stockID = stock_id;
883         uint8 rarity= _rarity;
884         uint16 hp= _mainStats[0]; // Max Hp
885         uint16 atk= _mainStats[1];
886         uint16 def= _mainStats[2];
887         uint16 agi= _mainStats[3];
888         uint16 intel= _mainStats[4];
889         uint16 cHp= _mainStats[0]; // Current Hp
890         //others
891         uint8 critic= 0;
892         uint8 healbonus= 0;
893         uint8 atackbonus= 0;
894         uint8 defensebonus= 0;
895 
896         return LibStructs.Hero(stockID,rarity,hp,atk,def,agi,intel,cHp,0,1,0);
897     }
898 
899     function generateHeroStats(LibStructs.StockHero prehero, uint8 rarity) private view returns(uint16[5] ){
900 
901         uint32  goodPoints = 0;
902         uint32  normalPoints = 0;
903         uint8 i = 0;
904         uint16[5] memory arrayStartingStat;
905         i = i.add(1);
906         //uint8 rarity = getRarity(i);
907         uint32 points = prehero.stars.add(2).add(rarity);
908 
909         uint8[2] memory mainStats = [prehero.mainOnePosition,prehero.mainTwoPosition];//[prehero.hpMain,prehero.atkMain,prehero.defMain,prehero.agiMain,prehero.intelMain]; //prehero.mainStats;// warrior [true,true,false,false,false];
910 
911         goodPoints = points;
912         normalPoints = 8;
913         arrayStartingStat = spreadStats(mainStats,goodPoints,normalPoints,i);
914 
915         return arrayStartingStat;
916 
917     }
918    
919 
920     function spreadStats(uint8[2] mainStats,uint32 mainPoints,uint32 restPoints,uint index) private view returns(uint16[5]){
921         uint32 i = 0;
922         uint16[5] memory arr = [uint16(1),uint16(1),uint16(1),uint16(1),uint16(1)]; // 5
923         bytes32 blockx = block.blockhash(block.number.sub(1));
924         uint256 _seed = uint256(sha3(blockx, m_Database.getRandom(100,uint8(i))));
925 
926         while(i < mainPoints){ // goodppoints 4
927 
928             uint8 position = uint8(( _seed / (10 ** index)) %10);
929             if(position < 5){
930                 position = 0;
931             }
932             else{
933                 position = 1;
934             }
935 
936             arr[mainStats[position]] = arr[mainStats[position]].add(1);
937             i = i.add(1);
938             index = index.add(1);
939 
940         }
941         i=0;
942         while(i < restPoints){ // outros  8
943 
944             uint8 positionz = uint8(( _seed / (10 ** index)) %5);
945             arr[positionz] = arr[positionz].add(1);
946             i = i.add(1);
947             index = index.add(1);
948 
949         }
950 
951         return arr;
952     }
953 
954 }
955 
956 contract BitGuildToken{
957     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
958     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success);
959 }
960 
961 contract AbstractDatabase
962 {
963     function() public payable;
964     function ChangeOwner(address new_owner) public;
965     function ChangeOwner2(address new_owner) public;
966     function Store(address user, uint256 category, uint256 slot, bytes32 data) public;
967     function Load(address user, uint256 category, uint256 index) public view returns (bytes32);
968     function TransferFunds(address target, uint256 transfer_amount) public;
969     function getRandom(uint256 upper, uint8 seed) public returns (uint256 number);
970 }