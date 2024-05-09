1 library OwnershipTypes{
2     using Serializer for Serializer.DataComponent;
3 
4     struct Ownership
5     {
6         address m_Owner; // 0
7         uint32 m_OwnerInventoryIndex; // 20
8     }
9 
10     function SerializeOwnership(Ownership ownership) internal pure returns (bytes32)
11     {
12         Serializer.DataComponent memory data;
13         data.WriteAddress(0, ownership.m_Owner);
14         data.WriteUint32(20, ownership.m_OwnerInventoryIndex);
15 
16         return data.m_Raw;
17     }
18 
19     function DeserializeOwnership(bytes32 raw) internal pure returns (Ownership)
20     {
21         Ownership memory ownership;
22 
23         Serializer.DataComponent memory data;
24         data.m_Raw = raw;
25 
26         ownership.m_Owner = data.ReadAddress(0);
27         ownership.m_OwnerInventoryIndex = data.ReadUint32(20);
28 
29         return ownership;
30     }
31 }
32 library LibStructs{
33     using Serializer for Serializer.DataComponent;
34     // HEROES
35 
36     struct Hero {
37         uint16 stockID;
38         uint8 rarity;
39         uint16 hp;
40         uint16 atk;
41         uint16 def;
42         uint16 agi;
43         uint16 intel;
44         uint16 cHp;
45         //uint8 cenas;
46         // uint8 critic;
47         // uint8 healbonus;
48         // uint8 atackbonus;
49         // uint8 defensebonus;
50 
51         uint8 isForSale;
52         uint8 lvl;
53         uint16 xp;
54     }
55     struct StockHero {uint16 price;uint8 stars;uint8 mainOnePosition;uint8 mainTwoPosition;uint16 stock;uint8 class;}
56 
57     function SerializeHero(Hero hero) internal pure returns (bytes32){
58         Serializer.DataComponent memory data;
59         data.WriteUint16(0, hero.stockID);
60         data.WriteUint8(2, hero.rarity);
61         //data.WriteUint8(2, hero.m_IsForSale);
62         //data.WriteUint8(3, rocket.m_Unused3);
63         data.WriteUint16(4, hero.hp);
64         data.WriteUint16(6, hero.atk);
65         data.WriteUint16(8, hero.def);
66         data.WriteUint16(10, hero.agi);
67         data.WriteUint16(12, hero.intel);
68         data.WriteUint16(14, hero.cHp);
69 
70         // data.WriteUint8(16, hero.class);
71         // data.WriteUint8(17, hero.healbonus);
72         // data.WriteUint8(18, hero.atackbonus);
73         // data.WriteUint8(19, hero.defensebonus);
74 
75         data.WriteUint8(20, hero.isForSale);
76         data.WriteUint8(21, hero.lvl);
77         data.WriteUint16(23, hero.xp);
78 
79         return data.m_Raw;
80     }
81     function DeserializeHero(bytes32 raw) internal pure returns (Hero){
82         Hero memory hero;
83 
84         Serializer.DataComponent memory data;
85         data.m_Raw = raw;
86 
87         hero.stockID = data.ReadUint16(0);
88         //hero.rarity = data.ReadUint8(1);
89         hero.rarity = data.ReadUint8(2);
90         //rocket.m_Unused3 = data.ReadUint8(3);
91         hero.hp = data.ReadUint16(4);
92         hero.atk = data.ReadUint16(6);
93         hero.def = data.ReadUint16(8);
94         hero.agi = data.ReadUint16(10);
95         hero.intel = data.ReadUint16(12);
96         hero.cHp = data.ReadUint16(14);
97 
98         // hero.class = data.ReadUint8(16);
99         // hero.healbonus = data.ReadUint8(17);
100         // hero.atackbonus = data.ReadUint8(18);
101         // hero.defensebonus = data.ReadUint8(19);
102 
103         hero.isForSale = data.ReadUint8(20);
104         hero.lvl = data.ReadUint8(21);
105         hero.xp = data.ReadUint16(23);
106 
107         return hero;
108     }
109     function SerializeStockHero(StockHero stockhero) internal pure returns (bytes32){
110         // string name;uint64 price;uint8 stars;uint8 mainOnePosition;uint8 mainTwoPosition;
111 
112         Serializer.DataComponent memory data;
113         data.WriteUint16(0, stockhero.price);
114         data.WriteUint8(2, stockhero.stars);
115         data.WriteUint8(3, stockhero.mainOnePosition);
116         data.WriteUint8(4, stockhero.mainTwoPosition);
117         data.WriteUint16(5, stockhero.stock);
118         data.WriteUint8(7, stockhero.class);
119 
120 
121         return data.m_Raw;
122     }
123     function DeserializeStockHero(bytes32 raw) internal pure returns (StockHero){
124         StockHero memory stockhero;
125 
126         Serializer.DataComponent memory data;
127         data.m_Raw = raw;
128 
129         stockhero.price = data.ReadUint16(0);
130         stockhero.stars = data.ReadUint8(2);
131         stockhero.mainOnePosition = data.ReadUint8(3);
132         stockhero.mainTwoPosition = data.ReadUint8(4);
133         stockhero.stock = data.ReadUint16(5);
134         stockhero.class = data.ReadUint8(7);
135 
136         return stockhero;
137     }
138     // ITEMS
139     struct Item {
140         uint16 stockID;
141         uint8 lvl;
142         uint8 rarity;
143         uint16 hp;
144         uint16 atk;
145         uint16 def;
146         uint16 agi;
147         uint16 intel;
148 
149         uint8 critic;
150         uint8 healbonus;
151         uint8 atackbonus;
152         uint8 defensebonus;
153 
154         uint8 isForSale;
155         uint8 grade;
156     }
157     struct StockItem {uint16 price;uint8 stars;uint8 lvl;uint8 mainOnePosition;uint8 mainTwoPosition;uint16[5] stats;uint8[4] secstats;uint8 cat;uint8 subcat;} // 1 finney = 0.0001 ether
158 
159     function SerializeItem(Item item) internal pure returns (bytes32){
160         Serializer.DataComponent memory data;
161 
162         data.WriteUint16(0, item.stockID);
163         data.WriteUint8(4, item.lvl);
164         data.WriteUint8(5, item.rarity);
165         data.WriteUint16(6, item.hp);
166         data.WriteUint16(8, item.atk);
167         data.WriteUint16(10, item.def);
168         data.WriteUint16(12, item.agi);
169         data.WriteUint16(14, item.intel);
170         // data.WriteUint32(14, item.cHp);
171 
172         data.WriteUint8(16, item.critic);
173         data.WriteUint8(17, item.healbonus);
174         data.WriteUint8(18, item.atackbonus);
175         data.WriteUint8(19, item.defensebonus);
176 
177         data.WriteUint8(20, item.isForSale);
178         data.WriteUint8(21, item.grade);
179 
180 
181         return data.m_Raw;
182 
183     }
184     function DeserializeItem(bytes32 raw) internal pure returns (Item){
185         Item memory item;
186 
187         Serializer.DataComponent memory data;
188         data.m_Raw = raw;
189 
190         item.stockID = data.ReadUint16(0);
191 
192         item.lvl = data.ReadUint8(4);
193         item.rarity = data.ReadUint8(5);
194         item.hp = data.ReadUint16(6);
195         item.atk = data.ReadUint16(8);
196         item.def = data.ReadUint16(10);
197         item.agi = data.ReadUint16(12);
198         item.intel = data.ReadUint16(14);
199 
200         item.critic = data.ReadUint8(16);
201         item.healbonus = data.ReadUint8(17);
202         item.atackbonus = data.ReadUint8(18);
203         item.defensebonus = data.ReadUint8(19);
204 
205         item.isForSale = data.ReadUint8(20);
206         item.grade = data.ReadUint8(21);
207 
208 
209         return item;
210     }
211     function SerializeStockItem(StockItem stockitem) internal pure returns (bytes32){
212         // string name;uint64 price;uint8 stars;uint8 mainOnePosition;uint8 mainTwoPosition;uint8 mainThreePosition;
213         // uint16[] stats;uint8[] secstats;
214 
215         Serializer.DataComponent memory data;
216         data.WriteUint16(0, stockitem.price);
217         data.WriteUint8(2, stockitem.stars);
218         data.WriteUint8(3, stockitem.lvl);
219         data.WriteUint8(4, stockitem.mainOnePosition);
220         data.WriteUint8(5, stockitem.mainTwoPosition);
221         //data.WriteUint8(12, stockitem.mainThreePosition);
222         //stats
223         data.WriteUint16(6, stockitem.stats[0]);
224         data.WriteUint16(8, stockitem.stats[1]);
225         data.WriteUint16(10, stockitem.stats[2]);
226         data.WriteUint16(12, stockitem.stats[3]);
227         data.WriteUint16(14, stockitem.stats[4]);
228         //secstats
229         data.WriteUint8(16, stockitem.secstats[0]);
230         data.WriteUint8(17, stockitem.secstats[1]);
231         data.WriteUint8(18, stockitem.secstats[2]);
232         data.WriteUint8(19, stockitem.secstats[3]);
233 
234         data.WriteUint8(20, stockitem.cat);
235         data.WriteUint8(21, stockitem.subcat);
236 
237 
238         return data.m_Raw;
239     }
240     function DeserializeStockItem(bytes32 raw) internal pure returns (StockItem){
241         StockItem memory stockitem;
242 
243         Serializer.DataComponent memory data;
244         data.m_Raw = raw;
245 
246         stockitem.price = data.ReadUint16(0);
247         stockitem.stars = data.ReadUint8(2);
248         stockitem.lvl = data.ReadUint8(3);
249         stockitem.mainOnePosition = data.ReadUint8(4);
250         stockitem.mainTwoPosition = data.ReadUint8(5);
251         //stockitem.mainThreePosition = data.ReadUint8(12);
252 
253         stockitem.stats[0] = data.ReadUint16(6);
254         stockitem.stats[1] = data.ReadUint16(8);
255         stockitem.stats[2] = data.ReadUint16(10);
256         stockitem.stats[3] = data.ReadUint16(12);
257         stockitem.stats[4] = data.ReadUint16(14);
258 
259         stockitem.secstats[0] = data.ReadUint8(16);
260         stockitem.secstats[1] = data.ReadUint8(17);
261         stockitem.secstats[2] = data.ReadUint8(18);
262         stockitem.secstats[3] = data.ReadUint8(19);
263 
264         stockitem.cat = data.ReadUint8(20);
265         stockitem.subcat = data.ReadUint8(21);
266 
267         return stockitem;
268     }
269 
270     struct Action {uint16 actionID;uint8 actionType;uint16 finneyCost;uint32 cooldown;uint8 lvl;uint8 looted;uint8 isDaily;}
271     function SerializeAction(Action action) internal pure returns (bytes32){
272         Serializer.DataComponent memory data;
273         data.WriteUint16(0, action.actionID);
274         data.WriteUint8(2, action.actionType);
275         data.WriteUint16(3, action.finneyCost);
276         data.WriteUint32(5, action.cooldown);
277         data.WriteUint8(9, action.lvl);
278         data.WriteUint8(10, action.looted);
279         data.WriteUint8(11, action.isDaily);
280 
281         return data.m_Raw;
282     }
283     function DeserializeAction(bytes32 raw) internal pure returns (Action){
284         Action memory action;
285 
286         Serializer.DataComponent memory data;
287         data.m_Raw = raw;
288 
289         action.actionID = data.ReadUint16(0);
290         action.actionType = data.ReadUint8(2);
291         action.finneyCost = data.ReadUint16(3);
292         action.cooldown = data.ReadUint32(5);
293         action.lvl = data.ReadUint8(9);
294         action.looted = data.ReadUint8(10);
295         action.isDaily = data.ReadUint8(11);
296 
297         return action;
298     }
299 
300     struct Mission {uint8 dificulty;uint16[4] stockitemId_drops;uint16[5] statsrequired;uint16 count;}
301     function SerializeMission(Mission mission) internal pure returns (bytes32){
302         Serializer.DataComponent memory data;
303         data.WriteUint8(0, mission.dificulty);
304         data.WriteUint16(1, mission.stockitemId_drops[0]);
305         data.WriteUint16(5, mission.stockitemId_drops[1]);
306         data.WriteUint16(9, mission.stockitemId_drops[2]);
307         data.WriteUint16(13, mission.stockitemId_drops[3]);
308 
309         data.WriteUint16(15, mission.statsrequired[0]);
310         data.WriteUint16(17, mission.statsrequired[1]);
311         data.WriteUint16(19, mission.statsrequired[2]);
312         data.WriteUint16(21, mission.statsrequired[3]);
313         data.WriteUint16(23, mission.statsrequired[4]);
314 
315         data.WriteUint16(25, mission.count);
316 
317         return data.m_Raw;
318     }
319     function DeserializeMission(bytes32 raw) internal pure returns (Mission){
320         Mission memory mission;
321 
322         Serializer.DataComponent memory data;
323         data.m_Raw = raw;
324 
325         mission.dificulty = data.ReadUint8(0);
326         mission.stockitemId_drops[0] = data.ReadUint16(1);
327         mission.stockitemId_drops[1] = data.ReadUint16(5);
328         mission.stockitemId_drops[2] = data.ReadUint16(9);
329         mission.stockitemId_drops[3] = data.ReadUint16(13);
330 
331         mission.statsrequired[0] = data.ReadUint16(15);
332         mission.statsrequired[1] = data.ReadUint16(17);
333         mission.statsrequired[2] = data.ReadUint16(19);
334         mission.statsrequired[3] = data.ReadUint16(21);
335         mission.statsrequired[4] = data.ReadUint16(23);
336 
337         mission.count = data.ReadUint16(25);
338 
339         return mission;
340     }
341 
342     function toWei(uint80 price) public returns(uint256 value){
343         value = price;
344         value = value * 1 finney;
345 
346     }
347 
348 }
349 library GlobalTypes{
350     using Serializer for Serializer.DataComponent;
351 
352     struct Global
353     {
354         uint32 m_LastHeroId; // 0
355         uint32 m_LastItem; // 4
356         uint8 m_Unused8; // 8
357         uint8 m_Unused9; // 9
358         uint8 m_Unused10; // 10
359         uint8 m_Unused11; // 11
360     }
361 
362     function SerializeGlobal(Global global) internal pure returns (bytes32)
363     {
364         Serializer.DataComponent memory data;
365         data.WriteUint32(0, global.m_LastHeroId);
366         data.WriteUint32(4, global.m_LastItem);
367         data.WriteUint8(8, global.m_Unused8);
368         data.WriteUint8(9, global.m_Unused9);
369         data.WriteUint8(10, global.m_Unused10);
370         data.WriteUint8(11, global.m_Unused11);
371 
372         return data.m_Raw;
373     }
374 
375     function DeserializeGlobal(bytes32 raw) internal pure returns (Global)
376     {
377         Global memory global;
378 
379         Serializer.DataComponent memory data;
380         data.m_Raw = raw;
381 
382         global.m_LastHeroId = data.ReadUint32(0);
383         global.m_LastItem = data.ReadUint32(4);
384         global.m_Unused8 = data.ReadUint8(8);
385         global.m_Unused9 = data.ReadUint8(9);
386         global.m_Unused10 = data.ReadUint8(10);
387         global.m_Unused11 = data.ReadUint8(11);
388 
389         return global;
390     }
391 
392 
393 }
394 library MarketTypes{
395     using Serializer for Serializer.DataComponent;
396 
397     struct MarketListing
398     {
399         uint128 m_Price; // 0
400     }
401 
402     function SerializeMarketListing(MarketListing listing) internal pure returns (bytes32)
403     {
404         Serializer.DataComponent memory data;
405         data.WriteUint128(0, listing.m_Price);
406 
407         return data.m_Raw;
408     }
409 
410     function DeserializeMarketListing(bytes32 raw) internal pure returns (MarketListing)
411     {
412         MarketListing memory listing;
413 
414         Serializer.DataComponent memory data;
415         data.m_Raw = raw;
416 
417         listing.m_Price = data.ReadUint128(0);
418 
419         return listing;
420     }
421 }
422 library Serializer{
423     struct DataComponent
424     {
425         bytes32 m_Raw;
426     }
427 
428     function ReadUint8(DataComponent memory self, uint32 offset) internal pure returns (uint8)
429     {
430         return uint8((self.m_Raw >> (offset * 8)) & 0xFF);
431     }
432 
433     function WriteUint8(DataComponent memory self, uint32 offset, uint8 value) internal pure
434     {
435         self.m_Raw |= (bytes32(value) << (offset * 8));
436     }
437 
438     function ReadUint16(DataComponent memory self, uint32 offset) internal pure returns (uint16)
439     {
440         return uint16((self.m_Raw >> (offset * 8)) & 0xFFFF);
441     }
442 
443     function WriteUint16(DataComponent memory self, uint32 offset, uint16 value) internal pure
444     {
445         self.m_Raw |= (bytes32(value) << (offset * 8));
446     }
447 
448     function ReadUint32(DataComponent memory self, uint32 offset) internal pure returns (uint32)
449     {
450         return uint32((self.m_Raw >> (offset * 8)) & 0xFFFFFFFF);
451     }
452 
453     function WriteUint32(DataComponent memory self, uint32 offset, uint32 value) internal pure
454     {
455         self.m_Raw |= (bytes32(value) << (offset * 8));
456     }
457 
458     function ReadUint64(DataComponent memory self, uint32 offset) internal pure returns (uint64)
459     {
460         return uint64((self.m_Raw >> (offset * 8)) & 0xFFFFFFFFFFFFFFFF);
461     }
462 
463     function WriteUint64(DataComponent memory self, uint32 offset, uint64 value) internal pure
464     {
465         self.m_Raw |= (bytes32(value) << (offset * 8));
466     }
467 
468     function ReadUint80(DataComponent memory self, uint32 offset) internal pure returns (uint80)
469     {
470         return uint80((self.m_Raw >> (offset * 8)) & 0xFFFFFFFFFFFFFFFFFFFF);
471     }
472 
473     function WriteUint80(DataComponent memory self, uint32 offset, uint80 value) internal pure
474     {
475         self.m_Raw |= (bytes32(value) << (offset * 8));
476     }
477 
478     function ReadUint128(DataComponent memory self, uint128 offset) internal pure returns (uint128)
479     {
480         return uint128((self.m_Raw >> (offset * 8)) & 0xFFFFFFFFFFFFFFFFFFFF);
481     }
482 
483     function WriteUint128(DataComponent memory self, uint32 offset, uint128 value) internal pure
484     {
485         self.m_Raw |= (bytes32(value) << (offset * 8));
486     }
487 
488     function ReadAddress(DataComponent memory self, uint32 offset) internal pure returns (address)
489     {
490         return address((self.m_Raw >> (offset * 8)) & (
491         (0xFFFFFFFF << 0)  |
492         (0xFFFFFFFF << 32) |
493         (0xFFFFFFFF << 64) |
494         (0xFFFFFFFF << 96) |
495         (0xFFFFFFFF << 128)
496         ));
497     }
498 
499     function WriteAddress(DataComponent memory self, uint32 offset, address value) internal pure
500     {
501         self.m_Raw |= (bytes32(value) << (offset * 8));
502     }
503 }
504 library SafeMath {
505 
506     /**
507      * @dev Multiplies two numbers, throws on overflow.
508      */
509     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
510         if (a == 0) {
511             return 0;
512         }
513         uint256 c = a * b;
514         assert(c / a == b);
515         return c;
516     }
517 
518     /**
519      * @dev Integer division of two numbers, truncating the quotient.
520      */
521     function div(uint256 a, uint256 b) internal pure returns (uint256) {
522         // assert(b > 0); // Solidity automatically throws when dividing by 0
523         uint256 c = a / b;
524         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
525         return c;
526     }
527 
528     /**
529      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
530      */
531     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
532         assert(b <= a);
533         return a - b;
534     }
535 
536     /**
537      * @dev Adds two numbers, throws on overflow.
538      */
539     function add(uint256 a, uint256 b) internal pure returns (uint256) {
540         uint256 c = a + b;
541         assert(c >= a);
542         return c;
543     }
544 }
545 library SafeMath32 {
546 
547     /**
548      * @dev Multiplies two numbers, throws on overflow.
549      */
550     function mul(uint32 a, uint32 b) internal pure returns (uint32) {
551         if (a == 0) {
552             return 0;
553         }
554         uint32 c = a * b;
555         assert(c / a == b);
556         return c;
557     }
558 
559     /**
560      * @dev Integer division of two numbers, truncating the quotient.
561      */
562     function div(uint32 a, uint32 b) internal pure returns (uint32) {
563         // assert(b > 0); // Solidity automatically throws when dividing by 0
564         uint32 c = a / b;
565         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
566         return c;
567     }
568 
569     /**
570      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
571      */
572     function sub(uint32 a, uint32 b) internal pure returns (uint32) {
573         assert(b <= a);
574         return a - b;
575     }
576 
577     /**
578      * @dev Adds two numbers, throws on overflow.
579      */
580     function add(uint32 a, uint32 b) internal pure returns (uint32) {
581         uint32 c = a + b;
582         assert(c >= a);
583         return c;
584     }
585 }
586 library SafeMath16 {
587 
588     /**
589      * @dev Multiplies two numbers, throws on overflow.
590      */
591     function mul(uint16 a, uint16 b) internal pure returns (uint16) {
592         if (a == 0) {
593             return 0;
594         }
595         uint16 c = a * b;
596         assert(c / a == b);
597         return c;
598     }
599 
600     /**
601      * @dev Integer division of two numbers, truncating the quotient.
602      */
603     function div(uint16 a, uint16 b) internal pure returns (uint16) {
604         // assert(b > 0); // Solidity automatically throws when dividing by 0
605         uint16 c = a / b;
606         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
607         return c;
608     }
609 
610     /**
611      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
612      */
613     function sub(uint16 a, uint16 b) internal pure returns (uint16) {
614         assert(b <= a);
615         return a - b;
616     }
617 
618     /**
619      * @dev Adds two numbers, throws on overflow.
620      */
621     function add(uint16 a, uint16 b) internal pure returns (uint16) {
622         uint16 c = a + b;
623         assert(c >= a);
624         return c;
625     }
626 }
627 library SafeMath8 {
628 
629     /**
630      * @dev Multiplies two numbers, throws on overflow.
631      */
632     function mul(uint8 a, uint8 b) internal pure returns (uint8) {
633         if (a == 0) {
634             return 0;
635         }
636         uint8 c = a * b;
637         assert(c / a == b);
638         return c;
639     }
640 
641     /**
642      * @dev Integer division of two numbers, truncating the quotient.
643      */
644     function div(uint8 a, uint8 b) internal pure returns (uint8) {
645         // assert(b > 0); // Solidity automatically throws when dividing by 0
646         uint8 c = a / b;
647         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
648         return c;
649     }
650 
651     /**
652      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
653      */
654     function sub(uint8 a, uint8 b) internal pure returns (uint8) {
655         assert(b <= a);
656         return a - b;
657     }
658 
659     /**
660      * @dev Adds two numbers, throws on overflow.
661      */
662     function add(uint8 a, uint8 b) internal pure returns (uint8) {
663         uint8 c = a + b;
664         assert(c >= a);
665         return c;
666     }
667 }
668 contract HeroHelperBuy
669 {
670     address public m_Owner;
671     address public partner1;
672     uint8 public percent1;
673     address public partner2;
674     uint8 public percent2;
675 
676     bool public m_Paused;
677     AbstractDatabase m_Database= AbstractDatabase(0x095cbb73c75d4e1c62c94e0b1d4d88f8194b1941);
678     address public bitGuildAddress = 0x89a196a34B7820bC985B98096ED5EFc7c4DC8363;
679     mapping(address => bool)  public trustedContracts;
680     using SafeMath for uint256;
681     using SafeMath32 for uint32;
682     using SafeMath16 for uint16;
683     using SafeMath8 for uint8;
684 
685     modifier OnlyOwner(){
686         require(msg.sender == m_Owner || trustedContracts[msg.sender]);
687         _;
688     }
689 
690     modifier onlyOwnerOf(uint _hero_id) {
691         OwnershipTypes.Ownership memory ownership = OwnershipTypes.DeserializeOwnership(m_Database.Load(NullAddress, OwnershipHeroCategory, _hero_id));
692         require(ownership.m_Owner == msg.sender);
693         _;
694     }
695     
696     function ChangeAddressTrust(address contract_address,bool trust_flag) public OnlyOwner()
697     {
698         trustedContracts[contract_address] = trust_flag;
699     }
700 
701     address constant NullAddress = 0;
702 
703     uint256 constant GlobalCategory = 0;
704 
705     //Hero
706     uint256 constant HeroCategory = 1;
707     uint256 constant HeroStockCategory = 2;
708     uint256 constant InventoryHeroCategory = 3;
709 
710     uint256 constant OwnershipHeroCategory = 10;
711     uint256 constant OwnershipItemCategory = 11;
712     uint256 constant OwnershipAbilitiesCategory = 12;
713 
714     //Market
715     uint256 constant ProfitFundsCategory = 14;
716     uint256 constant WithdrawalFundsCategory = 15;
717     uint256 constant HeroMarketCategory = 16;
718 
719     //Action
720     uint256 constant ActionCategory = 20;
721     uint256 constant MissionCategory = 17;
722     uint256 constant ActionHeroCategory = 18;
723 
724     //ReferalCategory
725     uint256 constant ReferalCategory = 237;
726 
727     using Serializer for Serializer.DataComponent;
728 
729     function ChangeOwner(address new_owner) public OnlyOwner(){
730         m_Owner = new_owner;
731     }
732 
733     function ChangePartners(address _partner1,uint8 _percent1,address _partner2,uint8 _percent2) public OnlyOwner(){
734         partner1 = _partner1;
735         percent1 = _percent1;
736         partner2 = _partner2;
737         percent2 = _percent2;
738     }
739     function ChangeDatabase(address db) public OnlyOwner(){
740         m_Database = AbstractDatabase(db);
741     }
742     // function ChangeHeroHelperOraclize(address new_heroOraclize) public OnlyOwner(){
743     //     m_HeroHelperOraclize = AbstractHeroHelperOraclize(new_heroOraclize);
744     // }
745     function HeroHelperBuy() public{
746         m_Owner = msg.sender;
747         m_Paused = true;
748     }
749 
750     
751     function GetHeroStock(uint16 stockhero_id)  private view returns (LibStructs.StockHero){
752         LibStructs.StockHero memory stockhero = LibStructs.DeserializeStockHero(m_Database.Load(NullAddress, HeroStockCategory, stockhero_id));
753         return stockhero;
754     }
755     
756     function GetHeroStockPrice(uint16 stockhero_id)  public view returns (uint){
757         LibStructs.StockHero memory stockhero = LibStructs.DeserializeStockHero(m_Database.Load(NullAddress, HeroStockCategory, stockhero_id));
758         return stockhero.price;
759     }
760 
761     function GetHeroCount(address _owner) public view returns (uint32){
762         return uint32(m_Database.Load(_owner, HeroCategory, 0));
763     }
764     
765     event BuyStockHeroEvent(address indexed buyer, uint32 stock_id, uint32 hero_id);
766     event showValues(uint256 _value,uint256 _price,uint256 _stock,uint256 hero_id);
767     
768     function BuyStockHeroP1(uint16 stock_id) public payable {
769         
770         LibStructs.StockHero memory prehero = GetHeroStock(stock_id);
771         uint256 finneyPrice = prehero.price;
772         finneyPrice = finneyPrice.mul(1 finney );
773         showValues(msg.value, finneyPrice,prehero.stock,stock_id);
774         
775         require(msg.value  == finneyPrice && prehero.stock > 0);
776         
777         
778         BuyStockHeroP2(msg.sender,stock_id,m_Database.getRandom(100,uint8(msg.sender)));
779         
780     }
781     function giveHeroRandomRarity(address target,uint16 stock_id,uint random) public OnlyOwner(){
782         BuyStockHeroP2(target,stock_id,random);
783     }
784     function BuyStockHeroP2(address target,uint16 stock_id,uint random) internal{
785         
786         uint256 inventory_count;
787         LibStructs.StockHero memory prehero = GetHeroStock(stock_id);
788         LibStructs.Hero memory hero = buyHero(prehero,stock_id,random);
789         GlobalTypes.Global memory global = GlobalTypes.DeserializeGlobal(m_Database.Load(NullAddress, GlobalCategory, 0));
790 
791         uint256 finneyPrice = prehero.price;
792         finneyPrice = finneyPrice.mul( 1 finney );
793         prehero.stock = prehero.stock.sub(1);
794 
795         global.m_LastHeroId = global.m_LastHeroId.add(1);
796         uint32 next_hero_id = global.m_LastHeroId;
797         inventory_count = GetInventoryHeroCount(target);
798 
799         inventory_count = inventory_count.add(1);
800 
801 
802         OwnershipTypes.Ownership memory ownership;
803         ownership.m_Owner = target;
804         ownership.m_OwnerInventoryIndex = uint32(inventory_count.sub(1));
805 
806         m_Database.Store(target, InventoryHeroCategory, inventory_count, bytes32(next_hero_id)); // coloca na posiçao nova o heroi
807         m_Database.Store(target, InventoryHeroCategory, 0, bytes32(inventory_count)); // coloco na posiçao zero o count do mapping :) admira te
808 
809         m_Database.Store(NullAddress, HeroStockCategory, stock_id, LibStructs.SerializeStockHero(prehero));
810         m_Database.Store(NullAddress, HeroCategory, next_hero_id, LibStructs.SerializeHero(hero));
811         m_Database.Store(NullAddress, OwnershipHeroCategory, next_hero_id, OwnershipTypes.SerializeOwnership(ownership));
812         m_Database.Store(NullAddress, GlobalCategory, 0, GlobalTypes.SerializeGlobal(global));
813        
814         divProfit(finneyPrice);
815 
816         BuyStockHeroEvent(target, stock_id, next_hero_id);
817 
818         
819     }
820     
821     function divProfit(uint _value) internal{
822      
823          uint256 profit_funds = uint256(m_Database.Load(bitGuildAddress, WithdrawalFundsCategory, 0));
824          profit_funds = profit_funds.add(_value.div(10).mul(3));//30%
825          m_Database.Store(bitGuildAddress, WithdrawalFundsCategory, 0, bytes32(profit_funds));
826     
827          profit_funds = uint256(m_Database.Load(NullAddress, ProfitFundsCategory, 0));
828          profit_funds = profit_funds.add(_value.div(10).mul(7));//70%
829          m_Database.Store(NullAddress, ProfitFundsCategory, 0, bytes32(profit_funds));
830          m_Database.transfer(_value);
831     }
832 
833     function GetInventoryHeroCount(address target) view public returns (uint256){
834         require(target != address(0));
835 
836         uint256 inventory_count = uint256(m_Database.Load(target, InventoryHeroCategory, 0));
837 
838         return inventory_count;
839     }
840     
841     function buyHero(LibStructs.StockHero prehero,uint16 stock_id,uint random) internal returns(LibStructs.Hero hero){
842         
843         uint8 rarity = 1;
844         if(random == 99){ // comum
845             rarity = 5;
846         }else if( random >= 54 && random <= 79  ){ // incomun
847             rarity = 2;
848         }else if(random >= 80 && random <= 92){ // raro
849             rarity = 3;
850         }else if(random >= 93 && random <= 98){ // epico
851             rarity = 4;
852         }else{
853             rarity = 1;
854         }
855         
856         uint16[5] memory mainStats = generateHeroStats(prehero,rarity);
857         hero = assembleHero(mainStats,rarity,stock_id);
858         return hero;
859 
860     }
861     
862     function assembleHero(uint16[5] _mainStats,uint8 _rarity,uint16 stock_id) private pure returns(LibStructs.Hero){
863         uint16 stockID = stock_id;
864         uint8 rarity= _rarity;
865         uint16 hp= _mainStats[0]; // Max Hp
866         uint16 atk= _mainStats[1];
867         uint16 def= _mainStats[2];
868         uint16 agi= _mainStats[3];
869         uint16 intel= _mainStats[4];
870         uint16 cHp= _mainStats[0]; // Current Hp
871         //others
872         uint8 critic= 0;
873         uint8 healbonus= 0;
874         uint8 atackbonus= 0;
875         uint8 defensebonus= 0;
876 
877         return LibStructs.Hero(stockID,rarity,hp,atk,def,agi,intel,cHp,0,1,0);
878     }
879 
880     function generateHeroStats(LibStructs.StockHero prehero, uint8 rarity) private view returns(uint16[5] ){
881 
882         uint32  goodPoints = 0;
883         uint32  normalPoints = 0;
884         uint8 i = 0;
885         uint16[5] memory arrayStartingStat;
886         i = i.add(1);
887         //uint8 rarity = getRarity(i);
888         uint32 points = prehero.stars.add(2).add(rarity);
889 
890         uint8[2] memory mainStats = [prehero.mainOnePosition,prehero.mainTwoPosition];//[prehero.hpMain,prehero.atkMain,prehero.defMain,prehero.agiMain,prehero.intelMain]; //prehero.mainStats;// warrior [true,true,false,false,false];
891 
892         goodPoints = points;
893         normalPoints = 8;
894         arrayStartingStat = spreadStats(mainStats,goodPoints,normalPoints,i);
895 
896         return arrayStartingStat;
897 
898     }
899    
900 
901     function spreadStats(uint8[2] mainStats,uint32 mainPoints,uint32 restPoints,uint index) private view returns(uint16[5]){
902         uint32 i = 0;
903         uint16[5] memory arr = [uint16(1),uint16(1),uint16(1),uint16(1),uint16(1)]; // 5
904         bytes32 blockx = block.blockhash(block.number.sub(1));
905         uint256 _seed = uint256(sha3(blockx, m_Database.getRandom(100,uint8(i))));
906 
907         while(i < mainPoints){ // goodppoints 4
908 
909             uint8 position = uint8(( _seed / (10 ** index)) %10);
910             if(position < 5){
911                 position = 0;
912             }
913             else{
914                 position = 1;
915             }
916 
917             arr[mainStats[position]] = arr[mainStats[position]].add(1);
918             i = i.add(1);
919             index = index.add(1);
920 
921         }
922         i=0;
923         while(i < restPoints){ // outros  8
924 
925             uint8 positionz = uint8(( _seed / (10 ** index)) %5);
926             arr[positionz] = arr[positionz].add(1);
927             i = i.add(1);
928             index = index.add(1);
929 
930         }
931 
932         return arr;
933     }
934 
935 }
936 
937 contract BitGuildToken{
938     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
939     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success);
940 }
941 
942 contract AbstractDatabase
943 {
944     function() public payable;
945     function ChangeOwner(address new_owner) public;
946     function ChangeOwner2(address new_owner) public;
947     function Store(address user, uint256 category, uint256 slot, bytes32 data) public;
948     function Load(address user, uint256 category, uint256 index) public view returns (bytes32);
949     function TransferFunds(address target, uint256 transfer_amount) public;
950     function getRandom(uint256 upper, uint8 seed) public returns (uint256 number);
951 }