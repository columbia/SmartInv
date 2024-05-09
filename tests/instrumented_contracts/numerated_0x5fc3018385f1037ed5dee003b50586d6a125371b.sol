1 pragma solidity ^0.4.19;
2 library OwnershipTypes{
3     using Serializer for Serializer.DataComponent;
4 
5     struct Ownership
6     {
7         address m_Owner; // 0
8         uint32 m_OwnerInventoryIndex; // 20
9     }
10 
11     function SerializeOwnership(Ownership ownership) internal pure returns (bytes32)
12     {
13         Serializer.DataComponent memory data;
14         data.WriteAddress(0, ownership.m_Owner);
15         data.WriteUint32(20, ownership.m_OwnerInventoryIndex);
16 
17         return data.m_Raw;
18     }
19 
20     function DeserializeOwnership(bytes32 raw) internal pure returns (Ownership)
21     {
22         Ownership memory ownership;
23 
24         Serializer.DataComponent memory data;
25         data.m_Raw = raw;
26 
27         ownership.m_Owner = data.ReadAddress(0);
28         ownership.m_OwnerInventoryIndex = data.ReadUint32(20);
29 
30         return ownership;
31     }
32 }
33 library LibStructs{
34     using Serializer for Serializer.DataComponent;
35     // HEROES
36 
37     struct Hero {
38         uint16 stockID;
39         uint8 rarity;
40         uint16 hp;
41         uint16 atk;
42         uint16 def;
43         uint16 agi;
44         uint16 intel;
45         uint16 cHp;
46         //uint8 cenas;
47         // uint8 critic;
48         // uint8 healbonus;
49         // uint8 atackbonus;
50         // uint8 defensebonus;
51 
52         uint8 isForSale;
53         uint8 lvl;
54         uint16 xp;
55     }
56     struct StockHero {uint16 price;uint8 stars;uint8 mainOnePosition;uint8 mainTwoPosition;uint16 stock;uint8 class;}
57 
58     function SerializeHero(Hero hero) internal pure returns (bytes32){
59         Serializer.DataComponent memory data;
60         data.WriteUint16(0, hero.stockID);
61         data.WriteUint8(2, hero.rarity);
62         //data.WriteUint8(2, hero.m_IsForSale);
63         //data.WriteUint8(3, rocket.m_Unused3);
64         data.WriteUint16(4, hero.hp);
65         data.WriteUint16(6, hero.atk);
66         data.WriteUint16(8, hero.def);
67         data.WriteUint16(10, hero.agi);
68         data.WriteUint16(12, hero.intel);
69         data.WriteUint16(14, hero.cHp);
70 
71         // data.WriteUint8(16, hero.class);
72         // data.WriteUint8(17, hero.healbonus);
73         // data.WriteUint8(18, hero.atackbonus);
74         // data.WriteUint8(19, hero.defensebonus);
75 
76         data.WriteUint8(20, hero.isForSale);
77         data.WriteUint8(21, hero.lvl);
78         data.WriteUint16(23, hero.xp);
79 
80         return data.m_Raw;
81     }
82     function DeserializeHero(bytes32 raw) internal pure returns (Hero){
83         Hero memory hero;
84 
85         Serializer.DataComponent memory data;
86         data.m_Raw = raw;
87 
88         hero.stockID = data.ReadUint16(0);
89         //hero.rarity = data.ReadUint8(1);
90         hero.rarity = data.ReadUint8(2);
91         //rocket.m_Unused3 = data.ReadUint8(3);
92         hero.hp = data.ReadUint16(4);
93         hero.atk = data.ReadUint16(6);
94         hero.def = data.ReadUint16(8);
95         hero.agi = data.ReadUint16(10);
96         hero.intel = data.ReadUint16(12);
97         hero.cHp = data.ReadUint16(14);
98 
99         // hero.class = data.ReadUint8(16);
100         // hero.healbonus = data.ReadUint8(17);
101         // hero.atackbonus = data.ReadUint8(18);
102         // hero.defensebonus = data.ReadUint8(19);
103 
104         hero.isForSale = data.ReadUint8(20);
105         hero.lvl = data.ReadUint8(21);
106         hero.xp = data.ReadUint16(23);
107 
108         return hero;
109     }
110     function SerializeStockHero(StockHero stockhero) internal pure returns (bytes32){
111         // string name;uint64 price;uint8 stars;uint8 mainOnePosition;uint8 mainTwoPosition;
112 
113         Serializer.DataComponent memory data;
114         data.WriteUint16(0, stockhero.price);
115         data.WriteUint8(2, stockhero.stars);
116         data.WriteUint8(3, stockhero.mainOnePosition);
117         data.WriteUint8(4, stockhero.mainTwoPosition);
118         data.WriteUint16(5, stockhero.stock);
119         data.WriteUint8(7, stockhero.class);
120 
121 
122         return data.m_Raw;
123     }
124     function DeserializeStockHero(bytes32 raw) internal pure returns (StockHero){
125         StockHero memory stockhero;
126 
127         Serializer.DataComponent memory data;
128         data.m_Raw = raw;
129 
130         stockhero.price = data.ReadUint16(0);
131         stockhero.stars = data.ReadUint8(2);
132         stockhero.mainOnePosition = data.ReadUint8(3);
133         stockhero.mainTwoPosition = data.ReadUint8(4);
134         stockhero.stock = data.ReadUint16(5);
135         stockhero.class = data.ReadUint8(7);
136 
137         return stockhero;
138     }
139     // ITEMS
140     struct Item {
141         uint16 stockID;
142         uint8 lvl;
143         uint8 rarity;
144         uint16 hp;
145         uint16 atk;
146         uint16 def;
147         uint16 agi;
148         uint16 intel;
149 
150         uint8 critic;
151         uint8 healbonus;
152         uint8 atackbonus;
153         uint8 defensebonus;
154 
155         uint8 isForSale;
156         uint8 grade;
157     }
158     struct StockItem {uint16 price;uint8 stars;uint8 lvl;uint8 mainOnePosition;uint8 mainTwoPosition;uint16[5] stats;uint8[4] secstats;uint8 cat;uint8 subcat;} // 1 finney = 0.0001 ether
159 
160     function SerializeItem(Item item) internal pure returns (bytes32){
161         Serializer.DataComponent memory data;
162 
163         data.WriteUint16(0, item.stockID);
164         data.WriteUint8(4, item.lvl);
165         data.WriteUint8(5, item.rarity);
166         data.WriteUint16(6, item.hp);
167         data.WriteUint16(8, item.atk);
168         data.WriteUint16(10, item.def);
169         data.WriteUint16(12, item.agi);
170         data.WriteUint16(14, item.intel);
171         // data.WriteUint32(14, item.cHp);
172 
173         data.WriteUint8(16, item.critic);
174         data.WriteUint8(17, item.healbonus);
175         data.WriteUint8(18, item.atackbonus);
176         data.WriteUint8(19, item.defensebonus);
177 
178         data.WriteUint8(20, item.isForSale);
179         data.WriteUint8(21, item.grade);
180 
181 
182         return data.m_Raw;
183 
184     }
185     function DeserializeItem(bytes32 raw) internal pure returns (Item){
186         Item memory item;
187 
188         Serializer.DataComponent memory data;
189         data.m_Raw = raw;
190 
191         item.stockID = data.ReadUint16(0);
192 
193         item.lvl = data.ReadUint8(4);
194         item.rarity = data.ReadUint8(5);
195         item.hp = data.ReadUint16(6);
196         item.atk = data.ReadUint16(8);
197         item.def = data.ReadUint16(10);
198         item.agi = data.ReadUint16(12);
199         item.intel = data.ReadUint16(14);
200 
201         item.critic = data.ReadUint8(16);
202         item.healbonus = data.ReadUint8(17);
203         item.atackbonus = data.ReadUint8(18);
204         item.defensebonus = data.ReadUint8(19);
205 
206         item.isForSale = data.ReadUint8(20);
207         item.grade = data.ReadUint8(21);
208 
209 
210         return item;
211     }
212     function SerializeStockItem(StockItem stockitem) internal pure returns (bytes32){
213         // string name;uint64 price;uint8 stars;uint8 mainOnePosition;uint8 mainTwoPosition;uint8 mainThreePosition;
214         // uint16[] stats;uint8[] secstats;
215 
216         Serializer.DataComponent memory data;
217         data.WriteUint16(0, stockitem.price);
218         data.WriteUint8(2, stockitem.stars);
219         data.WriteUint8(3, stockitem.lvl);
220         data.WriteUint8(4, stockitem.mainOnePosition);
221         data.WriteUint8(5, stockitem.mainTwoPosition);
222         //data.WriteUint8(12, stockitem.mainThreePosition);
223         //stats
224         data.WriteUint16(6, stockitem.stats[0]);
225         data.WriteUint16(8, stockitem.stats[1]);
226         data.WriteUint16(10, stockitem.stats[2]);
227         data.WriteUint16(12, stockitem.stats[3]);
228         data.WriteUint16(14, stockitem.stats[4]);
229         //secstats
230         data.WriteUint8(16, stockitem.secstats[0]);
231         data.WriteUint8(17, stockitem.secstats[1]);
232         data.WriteUint8(18, stockitem.secstats[2]);
233         data.WriteUint8(19, stockitem.secstats[3]);
234 
235         data.WriteUint8(20, stockitem.cat);
236         data.WriteUint8(21, stockitem.subcat);
237 
238 
239         return data.m_Raw;
240     }
241     function DeserializeStockItem(bytes32 raw) internal pure returns (StockItem){
242         StockItem memory stockitem;
243 
244         Serializer.DataComponent memory data;
245         data.m_Raw = raw;
246 
247         stockitem.price = data.ReadUint16(0);
248         stockitem.stars = data.ReadUint8(2);
249         stockitem.lvl = data.ReadUint8(3);
250         stockitem.mainOnePosition = data.ReadUint8(4);
251         stockitem.mainTwoPosition = data.ReadUint8(5);
252         //stockitem.mainThreePosition = data.ReadUint8(12);
253 
254         stockitem.stats[0] = data.ReadUint16(6);
255         stockitem.stats[1] = data.ReadUint16(8);
256         stockitem.stats[2] = data.ReadUint16(10);
257         stockitem.stats[3] = data.ReadUint16(12);
258         stockitem.stats[4] = data.ReadUint16(14);
259 
260         stockitem.secstats[0] = data.ReadUint8(16);
261         stockitem.secstats[1] = data.ReadUint8(17);
262         stockitem.secstats[2] = data.ReadUint8(18);
263         stockitem.secstats[3] = data.ReadUint8(19);
264 
265         stockitem.cat = data.ReadUint8(20);
266         stockitem.subcat = data.ReadUint8(21);
267 
268         return stockitem;
269     }
270 
271     struct Action {uint16 actionID;uint8 actionType;uint16 finneyCost;uint32 cooldown;uint8 lvl;uint8 looted;uint8 isDaily;}
272     function SerializeAction(Action action) internal pure returns (bytes32){
273         Serializer.DataComponent memory data;
274         data.WriteUint16(0, action.actionID);
275         data.WriteUint8(2, action.actionType);
276         data.WriteUint16(3, action.finneyCost);
277         data.WriteUint32(5, action.cooldown);
278         data.WriteUint8(9, action.lvl);
279         data.WriteUint8(10, action.looted);
280         data.WriteUint8(11, action.isDaily);
281 
282         return data.m_Raw;
283     }
284     function DeserializeAction(bytes32 raw) internal pure returns (Action){
285         Action memory action;
286 
287         Serializer.DataComponent memory data;
288         data.m_Raw = raw;
289 
290         action.actionID = data.ReadUint16(0);
291         action.actionType = data.ReadUint8(2);
292         action.finneyCost = data.ReadUint16(3);
293         action.cooldown = data.ReadUint32(5);
294         action.lvl = data.ReadUint8(9);
295         action.looted = data.ReadUint8(10);
296         action.isDaily = data.ReadUint8(11);
297 
298         return action;
299     }
300 
301     struct Mission {uint8 dificulty;uint16[4] stockitemId_drops;uint16[5] statsrequired;uint16 count;}
302     function SerializeMission(Mission mission) internal pure returns (bytes32){
303         Serializer.DataComponent memory data;
304         data.WriteUint8(0, mission.dificulty);
305         data.WriteUint16(1, mission.stockitemId_drops[0]);
306         data.WriteUint16(5, mission.stockitemId_drops[1]);
307         data.WriteUint16(9, mission.stockitemId_drops[2]);
308         data.WriteUint16(13, mission.stockitemId_drops[3]);
309 
310         data.WriteUint16(15, mission.statsrequired[0]);
311         data.WriteUint16(17, mission.statsrequired[1]);
312         data.WriteUint16(19, mission.statsrequired[2]);
313         data.WriteUint16(21, mission.statsrequired[3]);
314         data.WriteUint16(23, mission.statsrequired[4]);
315 
316         data.WriteUint16(25, mission.count);
317 
318         return data.m_Raw;
319     }
320     function DeserializeMission(bytes32 raw) internal pure returns (Mission){
321         Mission memory mission;
322 
323         Serializer.DataComponent memory data;
324         data.m_Raw = raw;
325 
326         mission.dificulty = data.ReadUint8(0);
327         mission.stockitemId_drops[0] = data.ReadUint16(1);
328         mission.stockitemId_drops[1] = data.ReadUint16(5);
329         mission.stockitemId_drops[2] = data.ReadUint16(9);
330         mission.stockitemId_drops[3] = data.ReadUint16(13);
331 
332         mission.statsrequired[0] = data.ReadUint16(15);
333         mission.statsrequired[1] = data.ReadUint16(17);
334         mission.statsrequired[2] = data.ReadUint16(19);
335         mission.statsrequired[3] = data.ReadUint16(21);
336         mission.statsrequired[4] = data.ReadUint16(23);
337 
338         mission.count = data.ReadUint16(25);
339 
340         return mission;
341     }
342 
343     function toWei(uint80 price) public returns(uint256 value){
344         value = price;
345         value = value * 1 finney;
346 
347     }
348 
349 }
350 library GlobalTypes{
351     using Serializer for Serializer.DataComponent;
352 
353     struct Global
354     {
355         uint32 m_LastHeroId; // 0
356         uint32 m_LastItem; // 4
357         uint8 m_Unused8; // 8
358         uint8 m_Unused9; // 9
359         uint8 m_Unused10; // 10
360         uint8 m_Unused11; // 11
361     }
362 
363     function SerializeGlobal(Global global) internal pure returns (bytes32)
364     {
365         Serializer.DataComponent memory data;
366         data.WriteUint32(0, global.m_LastHeroId);
367         data.WriteUint32(4, global.m_LastItem);
368         data.WriteUint8(8, global.m_Unused8);
369         data.WriteUint8(9, global.m_Unused9);
370         data.WriteUint8(10, global.m_Unused10);
371         data.WriteUint8(11, global.m_Unused11);
372 
373         return data.m_Raw;
374     }
375 
376     function DeserializeGlobal(bytes32 raw) internal pure returns (Global)
377     {
378         Global memory global;
379 
380         Serializer.DataComponent memory data;
381         data.m_Raw = raw;
382 
383         global.m_LastHeroId = data.ReadUint32(0);
384         global.m_LastItem = data.ReadUint32(4);
385         global.m_Unused8 = data.ReadUint8(8);
386         global.m_Unused9 = data.ReadUint8(9);
387         global.m_Unused10 = data.ReadUint8(10);
388         global.m_Unused11 = data.ReadUint8(11);
389 
390         return global;
391     }
392 
393 
394 }
395 library MarketTypes{
396     using Serializer for Serializer.DataComponent;
397 
398     struct MarketListing
399     {
400         uint128 m_Price; // 0
401     }
402 
403     function SerializeMarketListing(MarketListing listing) internal pure returns (bytes32)
404     {
405         Serializer.DataComponent memory data;
406         data.WriteUint128(0, listing.m_Price);
407 
408         return data.m_Raw;
409     }
410 
411     function DeserializeMarketListing(bytes32 raw) internal pure returns (MarketListing)
412     {
413         MarketListing memory listing;
414 
415         Serializer.DataComponent memory data;
416         data.m_Raw = raw;
417 
418         listing.m_Price = data.ReadUint128(0);
419 
420         return listing;
421     }
422 }
423 library Serializer{
424     struct DataComponent
425     {
426         bytes32 m_Raw;
427     }
428 
429     function ReadUint8(DataComponent memory self, uint32 offset) internal pure returns (uint8)
430     {
431         return uint8((self.m_Raw >> (offset * 8)) & 0xFF);
432     }
433 
434     function WriteUint8(DataComponent memory self, uint32 offset, uint8 value) internal pure
435     {
436         self.m_Raw |= (bytes32(value) << (offset * 8));
437     }
438 
439     function ReadUint16(DataComponent memory self, uint32 offset) internal pure returns (uint16)
440     {
441         return uint16((self.m_Raw >> (offset * 8)) & 0xFFFF);
442     }
443 
444     function WriteUint16(DataComponent memory self, uint32 offset, uint16 value) internal pure
445     {
446         self.m_Raw |= (bytes32(value) << (offset * 8));
447     }
448 
449     function ReadUint32(DataComponent memory self, uint32 offset) internal pure returns (uint32)
450     {
451         return uint32((self.m_Raw >> (offset * 8)) & 0xFFFFFFFF);
452     }
453 
454     function WriteUint32(DataComponent memory self, uint32 offset, uint32 value) internal pure
455     {
456         self.m_Raw |= (bytes32(value) << (offset * 8));
457     }
458 
459     function ReadUint64(DataComponent memory self, uint32 offset) internal pure returns (uint64)
460     {
461         return uint64((self.m_Raw >> (offset * 8)) & 0xFFFFFFFFFFFFFFFF);
462     }
463 
464     function WriteUint64(DataComponent memory self, uint32 offset, uint64 value) internal pure
465     {
466         self.m_Raw |= (bytes32(value) << (offset * 8));
467     }
468 
469     function ReadUint80(DataComponent memory self, uint32 offset) internal pure returns (uint80)
470     {
471         return uint80((self.m_Raw >> (offset * 8)) & 0xFFFFFFFFFFFFFFFFFFFF);
472     }
473 
474     function WriteUint80(DataComponent memory self, uint32 offset, uint80 value) internal pure
475     {
476         self.m_Raw |= (bytes32(value) << (offset * 8));
477     }
478 
479     function ReadUint128(DataComponent memory self, uint128 offset) internal pure returns (uint128)
480     {
481         return uint128((self.m_Raw >> (offset * 8)) & 0xFFFFFFFFFFFFFFFFFFFF);
482     }
483 
484     function WriteUint128(DataComponent memory self, uint32 offset, uint128 value) internal pure
485     {
486         self.m_Raw |= (bytes32(value) << (offset * 8));
487     }
488 
489     function ReadAddress(DataComponent memory self, uint32 offset) internal pure returns (address)
490     {
491         return address((self.m_Raw >> (offset * 8)) & (
492         (0xFFFFFFFF << 0)  |
493         (0xFFFFFFFF << 32) |
494         (0xFFFFFFFF << 64) |
495         (0xFFFFFFFF << 96) |
496         (0xFFFFFFFF << 128)
497         ));
498     }
499 
500     function WriteAddress(DataComponent memory self, uint32 offset, address value) internal pure
501     {
502         self.m_Raw |= (bytes32(value) << (offset * 8));
503     }
504 }
505 library SafeMath {
506 
507     /**
508      * @dev Multiplies two numbers, throws on overflow.
509      */
510     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
511         if (a == 0) {
512             return 0;
513         }
514         uint256 c = a * b;
515         assert(c / a == b);
516         return c;
517     }
518 
519     /**
520      * @dev Integer division of two numbers, truncating the quotient.
521      */
522     function div(uint256 a, uint256 b) internal pure returns (uint256) {
523         // assert(b > 0); // Solidity automatically throws when dividing by 0
524         uint256 c = a / b;
525         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
526         return c;
527     }
528 
529     /**
530      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
531      */
532     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
533         assert(b <= a);
534         return a - b;
535     }
536 
537     /**
538      * @dev Adds two numbers, throws on overflow.
539      */
540     function add(uint256 a, uint256 b) internal pure returns (uint256) {
541         uint256 c = a + b;
542         assert(c >= a);
543         return c;
544     }
545 }
546 library SafeMath32 {
547 
548     /**
549      * @dev Multiplies two numbers, throws on overflow.
550      */
551     function mul(uint32 a, uint32 b) internal pure returns (uint32) {
552         if (a == 0) {
553             return 0;
554         }
555         uint32 c = a * b;
556         assert(c / a == b);
557         return c;
558     }
559 
560     /**
561      * @dev Integer division of two numbers, truncating the quotient.
562      */
563     function div(uint32 a, uint32 b) internal pure returns (uint32) {
564         // assert(b > 0); // Solidity automatically throws when dividing by 0
565         uint32 c = a / b;
566         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
567         return c;
568     }
569 
570     /**
571      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
572      */
573     function sub(uint32 a, uint32 b) internal pure returns (uint32) {
574         assert(b <= a);
575         return a - b;
576     }
577 
578     /**
579      * @dev Adds two numbers, throws on overflow.
580      */
581     function add(uint32 a, uint32 b) internal pure returns (uint32) {
582         uint32 c = a + b;
583         assert(c >= a);
584         return c;
585     }
586 }
587 library SafeMath16 {
588 
589     /**
590      * @dev Multiplies two numbers, throws on overflow.
591      */
592     function mul(uint16 a, uint16 b) internal pure returns (uint16) {
593         if (a == 0) {
594             return 0;
595         }
596         uint16 c = a * b;
597         assert(c / a == b);
598         return c;
599     }
600 
601     /**
602      * @dev Integer division of two numbers, truncating the quotient.
603      */
604     function div(uint16 a, uint16 b) internal pure returns (uint16) {
605         // assert(b > 0); // Solidity automatically throws when dividing by 0
606         uint16 c = a / b;
607         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
608         return c;
609     }
610 
611     /**
612      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
613      */
614     function sub(uint16 a, uint16 b) internal pure returns (uint16) {
615         assert(b <= a);
616         return a - b;
617     }
618 
619     /**
620      * @dev Adds two numbers, throws on overflow.
621      */
622     function add(uint16 a, uint16 b) internal pure returns (uint16) {
623         uint16 c = a + b;
624         assert(c >= a);
625         return c;
626     }
627 }
628 library SafeMath8 {
629 
630     /**
631      * @dev Multiplies two numbers, throws on overflow.
632      */
633     function mul(uint8 a, uint8 b) internal pure returns (uint8) {
634         if (a == 0) {
635             return 0;
636         }
637         uint8 c = a * b;
638         assert(c / a == b);
639         return c;
640     }
641 
642     /**
643      * @dev Integer division of two numbers, truncating the quotient.
644      */
645     function div(uint8 a, uint8 b) internal pure returns (uint8) {
646         // assert(b > 0); // Solidity automatically throws when dividing by 0
647         uint8 c = a / b;
648         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
649         return c;
650     }
651 
652     /**
653      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
654      */
655     function sub(uint8 a, uint8 b) internal pure returns (uint8) {
656         assert(b <= a);
657         return a - b;
658     }
659 
660     /**
661      * @dev Adds two numbers, throws on overflow.
662      */
663     function add(uint8 a, uint8 b) internal pure returns (uint8) {
664         uint8 c = a + b;
665         assert(c >= a);
666         return c;
667     }
668 }
669 
670 contract HeroHelper
671 {
672     address public m_Owner;
673     address public m_Owner2;
674 
675     bool public m_Paused;
676     AbstractDatabase m_Database= AbstractDatabase(0x400d188e1c21d592820df1f2f8cf33b3a13a377e);
677     using SafeMath for uint256;
678     using SafeMath32 for uint32;
679     using SafeMath16 for uint16;
680     using SafeMath8 for uint8;
681 
682     modifier OnlyOwner(){
683         require(msg.sender == m_Owner || msg.sender == m_Owner2);
684         _;
685     }
686 
687     modifier onlyOwnerOf(uint _hero_id) {
688         OwnershipTypes.Ownership memory ownership = OwnershipTypes.DeserializeOwnership(m_Database.Load(NullAddress, OwnershipHeroCategory, _hero_id));
689         require(ownership.m_Owner == msg.sender);
690         _;
691     }
692 
693     address constant NullAddress = 0;
694 
695     uint256 constant GlobalCategory = 0;
696 
697     //Hero
698     uint256 constant HeroCategory = 1;
699     uint256 constant HeroStockCategory = 2;
700     uint256 constant InventoryHeroCategory = 3;
701 
702     uint256 constant OwnershipHeroCategory = 10;
703     uint256 constant OwnershipItemCategory = 11;
704     uint256 constant OwnershipAbilitiesCategory = 12;
705 
706     //Market
707     uint256 constant ProfitFundsCategory = 14;
708     uint256 constant WithdrawalFundsCategory = 15;
709     uint256 constant HeroMarketCategory = 16;
710 
711     //Action
712     uint256 constant ActionCategory = 20;
713     uint256 constant MissionCategory = 17;
714     uint256 constant ActionHeroCategory = 18;
715 
716     //ReferalCategory
717     uint256 constant ReferalCategory = 237;
718 
719     using Serializer for Serializer.DataComponent;
720 
721     function ChangeOwner(address new_owner) public OnlyOwner(){
722         m_Owner = new_owner;
723     }
724 
725     function ChangeOwner2(address new_owner) public OnlyOwner(){
726         m_Owner2 = new_owner;
727     }
728 
729     function ChangeDatabase(address db) public OnlyOwner(){
730         m_Database = AbstractDatabase(db);
731     }
732 
733     function HeroHelper() public{
734         m_Owner = msg.sender;
735         m_Paused = true;
736     }
737 
738     function addHeroToCatalog(uint32 stock_id,uint16 _finneyCost,uint8 _stars,uint8 _mainOnePosition,uint8 _mainTwoPosition,uint16 _stock,uint8 _class) OnlyOwner() public {
739 
740         LibStructs.StockHero memory stockhero = LibStructs.StockHero( _finneyCost, _stars, _mainOnePosition, _mainTwoPosition,_stock,_class);
741         m_Database.Store(NullAddress, HeroStockCategory, stock_id, LibStructs.SerializeStockHero(stockhero));
742 
743     }
744 
745     function GetHeroStockStats(uint16 stockhero_id) public view returns (uint64 price,uint8 stars,uint8 mainOnePosition,uint8 mainTwoPosition,uint16 stock,uint8 class){
746         LibStructs.StockHero memory stockhero = GetHeroStock(stockhero_id);
747         price = stockhero.price;
748         stars = stockhero.stars;
749         mainOnePosition = stockhero.mainOnePosition;
750         mainTwoPosition = stockhero.mainTwoPosition;
751         stock = stockhero.stock;
752         class = stockhero.class;
753 
754     }
755     function GetHeroStock(uint16 stockhero_id)  private view returns (LibStructs.StockHero){
756         LibStructs.StockHero memory stockhero = LibStructs.DeserializeStockHero(m_Database.Load(NullAddress, HeroStockCategory, stockhero_id));
757         return stockhero;
758     }
759 
760     function GetHeroStockPrice(uint16 stockhero_id)  public view returns (uint weiPrice){
761         LibStructs.StockHero memory stockhero = LibStructs.DeserializeStockHero(m_Database.Load(NullAddress, HeroStockCategory, stockhero_id));
762         return stockhero.price;
763     }
764 
765     function GetHeroCount(address _owner) public view returns (uint32){
766         return uint32(m_Database.Load(_owner, HeroCategory, 0));
767     }
768     function GetHero(uint32 hero_id) public view returns(uint16[14] values){
769 
770         LibStructs.Hero memory hero = LibStructs.DeserializeHero(m_Database.Load(NullAddress, HeroCategory, hero_id));
771         bytes32 base = m_Database.Load(NullAddress, ActionHeroCategory, hero_id);
772         LibStructs.Action memory action = LibStructs.DeserializeAction( base );
773 
774         uint8 actStat = 0;
775         uint16 minLeft = 0;
776         if(uint32(base) != 0){
777             if(action.cooldown > now){
778                 actStat = 1;
779                 minLeft = uint16( (action.cooldown - now).div(60 seconds));
780             }
781         }
782         values = [hero.stockID,uint16(hero.rarity),hero.hp,hero.atk,hero.def,hero.agi,hero.intel,hero.lvl,hero.isForSale,hero.cHp,hero.xp,action.actionID,uint16(actStat),minLeft];
783 
784     }
785 
786 
787     function GetInventoryHeroCount(address target) view public returns (uint256){
788         require(target != address(0));
789 
790         uint256 inventory_count = uint256(m_Database.Load(target, InventoryHeroCategory, 0));
791 
792         return inventory_count;
793     }
794     function GetInventoryHero(address target, uint256 start_index) view public returns (uint32[8] hero_ids){
795         require(target != address(0));
796 
797         uint256 inventory_count = GetInventoryHeroCount(target);
798 
799         uint256 end = start_index.add(8);
800         if (end > inventory_count)
801             end = inventory_count;
802 
803         for (uint256 i = start_index; i < end; i++)
804         {
805             hero_ids[i - start_index] = uint32(uint256(m_Database.Load(target, InventoryHeroCategory, i.add(1) )));
806         }
807     }
808 
809 
810     function GetAuction(uint32 hero_id) view public returns (bool is_for_sale, address owner, uint128 price,uint16[14] herostats) {
811         LibStructs.Hero memory hero = LibStructs.DeserializeHero(m_Database.Load(NullAddress, HeroCategory, hero_id));
812         is_for_sale = hero.isForSale == 1;
813 
814         OwnershipTypes.Ownership memory ownership = OwnershipTypes.DeserializeOwnership(m_Database.Load(NullAddress, OwnershipHeroCategory, hero_id));
815         owner = ownership.m_Owner;
816 
817         MarketTypes.MarketListing memory listing = MarketTypes.DeserializeMarketListing(m_Database.Load(NullAddress, HeroMarketCategory, hero_id));
818         price = listing.m_Price;
819 
820         herostats = GetHero(hero_id);
821     }
822 
823 }
824 
825 contract AbstractDatabase
826 {
827     function() public payable;
828     function ChangeOwner(address new_owner) public;
829     function ChangeOwner2(address new_owner) public;
830     function Store(address user, uint256 category, uint256 slot, bytes32 data) public;
831     function Load(address user, uint256 category, uint256 index) public view returns (bytes32);
832     function TransferFunds(address target, uint256 transfer_amount) public;
833     function getRandom(uint256 upper, uint8 seed) public returns (uint256 number);
834     function setHeroApproval(address _to, uint256 _tokenId);
835     function getHeroApproval(uint256 _tokenId) public returns(address approved);
836 }