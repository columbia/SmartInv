1 pragma solidity 0.4.24;
2 
3 contract Ownable {
4 
5     address public owner;
6 
7     constructor() public {
8         owner = msg.sender;
9     }
10 
11     function setOwner(address _owner) public onlyOwner {
12         owner = _owner;
13     }
14 
15     modifier onlyOwner {
16         require(msg.sender == owner);
17         _;
18     }
19 
20 }
21 
22 
23 
24 
25 
26 
27 
28 
29 
30 contract Governable {
31 
32     event Pause();
33     event Unpause();
34 
35     address public governor;
36     bool public paused = false;
37 
38     constructor() public {
39         governor = msg.sender;
40     }
41 
42     function setGovernor(address _gov) public onlyGovernor {
43         governor = _gov;
44     }
45 
46     modifier onlyGovernor {
47         require(msg.sender == governor);
48         _;
49     }
50 
51     /**
52     * @dev Modifier to make a function callable only when the contract is not paused.
53     */
54     modifier whenNotPaused() {
55         require(!paused);
56         _;
57     }
58 
59     /**
60     * @dev Modifier to make a function callable only when the contract is paused.
61     */
62     modifier whenPaused() {
63         require(paused);
64         _;
65     }
66 
67     /**
68     * @dev called by the owner to pause, triggers stopped state
69     */
70     function pause() onlyGovernor whenNotPaused public {
71         paused = true;
72         emit Pause();
73     }
74 
75     /**
76     * @dev called by the owner to unpause, returns to normal state
77     */
78     function unpause() onlyGovernor whenPaused public {
79         paused = false;
80         emit Unpause();
81     }
82 
83 }
84 
85 
86 
87 contract CardBase is Governable {
88 
89 
90     struct Card {
91         uint16 proto;
92         uint16 purity;
93     }
94 
95     function getCard(uint id) public view returns (uint16 proto, uint16 purity) {
96         Card memory card = cards[id];
97         return (card.proto, card.purity);
98     }
99 
100     function getShine(uint16 purity) public pure returns (uint8) {
101         return uint8(purity / 1000);
102     }
103 
104     Card[] public cards;
105     
106 }
107 
108 
109 
110 contract CardProto is CardBase {
111 
112     event NewProtoCard(
113         uint16 id, uint8 season, uint8 god, 
114         Rarity rarity, uint8 mana, uint8 attack, 
115         uint8 health, uint8 cardType, uint8 tribe, bool packable
116     );
117 
118     struct Limit {
119         uint64 limit;
120         bool exists;
121     }
122 
123     // limits for mythic cards
124     mapping(uint16 => Limit) public limits;
125 
126     // can only set limits once
127     function setLimit(uint16 id, uint64 limit) public onlyGovernor {
128         Limit memory l = limits[id];
129         require(!l.exists);
130         limits[id] = Limit({
131             limit: limit,
132             exists: true
133         });
134     }
135 
136     function getLimit(uint16 id) public view returns (uint64 limit, bool set) {
137         Limit memory l = limits[id];
138         return (l.limit, l.exists);
139     }
140 
141     // could make these arrays to save gas
142     // not really necessary - will be update a very limited no of times
143     mapping(uint8 => bool) public seasonTradable;
144     mapping(uint8 => bool) public seasonTradabilityLocked;
145     uint8 public currentSeason;
146 
147     function makeTradeable(uint8 season) public onlyGovernor {
148         seasonTradable[season] = true;
149     }
150 
151     function makeUntradable(uint8 season) public onlyGovernor {
152         require(!seasonTradabilityLocked[season]);
153         seasonTradable[season] = false;
154     }
155 
156     function makePermanantlyTradable(uint8 season) public onlyGovernor {
157         require(seasonTradable[season]);
158         seasonTradabilityLocked[season] = true;
159     }
160 
161     function isTradable(uint16 proto) public view returns (bool) {
162         return seasonTradable[protos[proto].season];
163     }
164 
165     function nextSeason() public onlyGovernor {
166         //Seasons shouldn't go to 0 if there is more than the uint8 should hold, the governor should know this ¯\_(ツ)_/¯ -M
167         require(currentSeason <= 255); 
168 
169         currentSeason++;
170         mythic.length = 0;
171         legendary.length = 0;
172         epic.length = 0;
173         rare.length = 0;
174         common.length = 0;
175     }
176 
177     enum Rarity {
178         Common,
179         Rare,
180         Epic,
181         Legendary, 
182         Mythic
183     }
184 
185     uint8 constant SPELL = 1;
186     uint8 constant MINION = 2;
187     uint8 constant WEAPON = 3;
188     uint8 constant HERO = 4;
189 
190     struct ProtoCard {
191         bool exists;
192         uint8 god;
193         uint8 season;
194         uint8 cardType;
195         Rarity rarity;
196         uint8 mana;
197         uint8 attack;
198         uint8 health;
199         uint8 tribe;
200     }
201 
202     // there is a particular design decision driving this:
203     // need to be able to iterate over mythics only for card generation
204     // don't store 5 different arrays: have to use 2 ids
205     // better to bear this cost (2 bytes per proto card)
206     // rather than 1 byte per instance
207 
208     uint16 public protoCount;
209     
210     mapping(uint16 => ProtoCard) protos;
211 
212     uint16[] public mythic;
213     uint16[] public legendary;
214     uint16[] public epic;
215     uint16[] public rare;
216     uint16[] public common;
217 
218     function addProtos(
219         uint16[] externalIDs, uint8[] gods, Rarity[] rarities, uint8[] manas, uint8[] attacks, uint8[] healths, uint8[] cardTypes, uint8[] tribes, bool[] packable
220     ) public onlyGovernor returns(uint16) {
221 
222         for (uint i = 0; i < externalIDs.length; i++) {
223 
224             ProtoCard memory card = ProtoCard({
225                 exists: true,
226                 god: gods[i],
227                 season: currentSeason,
228                 cardType: cardTypes[i],
229                 rarity: rarities[i],
230                 mana: manas[i],
231                 attack: attacks[i],
232                 health: healths[i],
233                 tribe: tribes[i]
234             });
235 
236             _addProto(externalIDs[i], card, packable[i]);
237         }
238         
239     }
240 
241     function addProto(
242         uint16 externalID, uint8 god, Rarity rarity, uint8 mana, uint8 attack, uint8 health, uint8 cardType, uint8 tribe, bool packable
243     ) public onlyGovernor returns(uint16) {
244         ProtoCard memory card = ProtoCard({
245             exists: true,
246             god: god,
247             season: currentSeason,
248             cardType: cardType,
249             rarity: rarity,
250             mana: mana,
251             attack: attack,
252             health: health,
253             tribe: tribe
254         });
255 
256         _addProto(externalID, card, packable);
257     }
258 
259     function addWeapon(
260         uint16 externalID, uint8 god, Rarity rarity, uint8 mana, uint8 attack, uint8 durability, bool packable
261     ) public onlyGovernor returns(uint16) {
262 
263         ProtoCard memory card = ProtoCard({
264             exists: true,
265             god: god,
266             season: currentSeason,
267             cardType: WEAPON,
268             rarity: rarity,
269             mana: mana,
270             attack: attack,
271             health: durability,
272             tribe: 0
273         });
274 
275         _addProto(externalID, card, packable);
276     }
277 
278     function addSpell(uint16 externalID, uint8 god, Rarity rarity, uint8 mana, bool packable) public onlyGovernor returns(uint16) {
279 
280         ProtoCard memory card = ProtoCard({
281             exists: true,
282             god: god,
283             season: currentSeason,
284             cardType: SPELL,
285             rarity: rarity,
286             mana: mana,
287             attack: 0,
288             health: 0,
289             tribe: 0
290         });
291 
292         _addProto(externalID, card, packable);
293     }
294 
295     function addMinion(
296         uint16 externalID, uint8 god, Rarity rarity, uint8 mana, uint8 attack, uint8 health, uint8 tribe, bool packable
297     ) public onlyGovernor returns(uint16) {
298 
299         ProtoCard memory card = ProtoCard({
300             exists: true,
301             god: god,
302             season: currentSeason,
303             cardType: MINION,
304             rarity: rarity,
305             mana: mana,
306             attack: attack,
307             health: health,
308             tribe: tribe
309         });
310 
311         _addProto(externalID, card, packable);
312     }
313 
314     function _addProto(uint16 externalID, ProtoCard memory card, bool packable) internal {
315 
316         require(!protos[externalID].exists);
317 
318         card.exists = true;
319 
320         protos[externalID] = card;
321 
322         protoCount++;
323 
324         emit NewProtoCard(
325             externalID, currentSeason, card.god, 
326             card.rarity, card.mana, card.attack, 
327             card.health, card.cardType, card.tribe, packable
328         );
329 
330         if (packable) {
331             Rarity rarity = card.rarity;
332             if (rarity == Rarity.Common) {
333                 common.push(externalID);
334             } else if (rarity == Rarity.Rare) {
335                 rare.push(externalID);
336             } else if (rarity == Rarity.Epic) {
337                 epic.push(externalID);
338             } else if (rarity == Rarity.Legendary) {
339                 legendary.push(externalID);
340             } else if (rarity == Rarity.Mythic) {
341                 mythic.push(externalID);
342             } else {
343                 require(false);
344             }
345         }
346     }
347 
348     function getProto(uint16 id) public view returns(
349         bool exists, uint8 god, uint8 season, uint8 cardType, Rarity rarity, uint8 mana, uint8 attack, uint8 health, uint8 tribe
350     ) {
351         ProtoCard memory proto = protos[id];
352         return (
353             proto.exists,
354             proto.god,
355             proto.season,
356             proto.cardType,
357             proto.rarity,
358             proto.mana,
359             proto.attack,
360             proto.health,
361             proto.tribe
362         );
363     }
364 
365     function getRandomCard(Rarity rarity, uint16 random) public view returns (uint16) {
366         // modulo bias is fine - creates rarity tiers etc
367         // will obviously revert is there are no cards of that type: this is expected - should never happen
368         if (rarity == Rarity.Common) {
369             return common[random % common.length];
370         } else if (rarity == Rarity.Rare) {
371             return rare[random % rare.length];
372         } else if (rarity == Rarity.Epic) {
373             return epic[random % epic.length];
374         } else if (rarity == Rarity.Legendary) {
375             return legendary[random % legendary.length];
376         } else if (rarity == Rarity.Mythic) {
377             // make sure a mythic is available
378             uint16 id;
379             uint64 limit;
380             bool set;
381             for (uint i = 0; i < mythic.length; i++) {
382                 id = mythic[(random + i) % mythic.length];
383                 (limit, set) = getLimit(id);
384                 if (set && limit > 0){
385                     return id;
386                 }
387             }
388             // if not, they get a legendary :(
389             return legendary[random % legendary.length];
390         }
391         require(false);
392         return 0;
393     }
394 
395     // can never adjust tradable cards
396     // each season gets a 'balancing beta'
397     // totally immutable: season, rarity
398     function replaceProto(
399         uint16 index, uint8 god, uint8 cardType, uint8 mana, uint8 attack, uint8 health, uint8 tribe
400     ) public onlyGovernor {
401         ProtoCard memory pc = protos[index];
402         require(!seasonTradable[pc.season]);
403         protos[index] = ProtoCard({
404             exists: true,
405             god: god,
406             season: pc.season,
407             cardType: cardType,
408             rarity: pc.rarity,
409             mana: mana,
410             attack: attack,
411             health: health,
412             tribe: tribe
413         });
414     }
415 
416 }
417 
418 
419 contract MigrationInterface {
420 
421     function createCard(address user, uint16 proto, uint16 purity) public returns (uint);
422 
423     function getRandomCard(CardProto.Rarity rarity, uint16 random) public view returns (uint16);
424 
425     function migrate(uint id) public;
426 
427 }
428 
429 
430 
431 contract CardPackFour {
432 
433     MigrationInterface public migration;
434     uint public creationBlock;
435 
436     constructor(MigrationInterface _core) public payable {
437         migration = _core;
438         creationBlock = 5939061 + 2000; // set to creation block of first contracts + 8 hours for down time
439     }
440 
441     event Referral(address indexed referrer, uint value, address purchaser);
442 
443     /**
444     * purchase 'count' of this type of pack
445     */
446     function purchase(uint16 packCount, address referrer) public payable;
447 
448     // store purity and shine as one number to save users gas
449     function _getPurity(uint16 randOne, uint16 randTwo) internal pure returns (uint16) {
450         if (randOne >= 998) {
451             return 3000 + randTwo;
452         } else if (randOne >= 988) {
453             return 2000 + randTwo;
454         } else if (randOne >= 938) {
455             return 1000 + randTwo;
456         } else {
457             return randTwo;
458         }
459     }
460 
461 }
462 
463 
464 
465 
466 
467 
468 
469 
470 
471 contract Pausable is Ownable {
472     
473     event Pause();
474     event Unpause();
475 
476     bool public paused = false;
477 
478 
479     /**
480     * @dev Modifier to make a function callable only when the contract is not paused.
481     */
482     modifier whenNotPaused() {
483         require(!paused);
484         _;
485     }
486 
487     /**
488     * @dev Modifier to make a function callable only when the contract is paused.
489     */
490     modifier whenPaused() {
491         require(paused);
492         _;
493     }
494 
495     /**
496     * @dev called by the owner to pause, triggers stopped state
497     */
498     function pause() onlyOwner whenNotPaused public {
499         paused = true;
500         emit Pause();
501     }
502 
503     /**
504     * @dev called by the owner to unpause, returns to normal state
505     */
506     function unpause() onlyOwner whenPaused public {
507         paused = false;
508         emit Unpause();
509     }
510 }
511 
512 
513 
514 
515 
516 
517 
518 contract Vault is Ownable { 
519 
520     function () public payable {
521 
522     }
523 
524     function getBalance() public view returns (uint) {
525         return address(this).balance;
526     }
527 
528     function withdraw(uint amount) public onlyOwner {
529         require(address(this).balance >= amount);
530         owner.transfer(amount);
531     }
532 
533     function withdrawAll() public onlyOwner {
534         withdraw(address(this).balance);
535     }
536 }
537 
538 
539 
540 contract CappedVault is Vault { 
541 
542     uint public limit;
543     uint withdrawn = 0;
544 
545     constructor() public {
546         limit = 33333 ether;
547     }
548 
549     function () public payable {
550         require(total() + msg.value <= limit);
551     }
552 
553     function total() public view returns(uint) {
554         return getBalance() + withdrawn;
555     }
556 
557     function withdraw(uint amount) public onlyOwner {
558         require(address(this).balance >= amount);
559         owner.transfer(amount);
560         withdrawn += amount;
561     }
562 
563 }
564 
565 
566 contract PresalePackFour is CardPackFour, Pausable {
567 
568     CappedVault public vault;
569 
570     Purchase[] public purchases;
571 
572     function getPurchaseCount() public view returns (uint) {
573         return purchases.length;
574     }
575 
576     struct Purchase {
577         uint16 current;
578         uint16 count;
579         address user;
580         uint randomness;
581         uint64 commit;
582     }
583 
584     event PacksPurchased(uint indexed id, address indexed user, uint16 count);
585     event PackOpened(uint indexed id, uint16 startIndex, address indexed user, uint[] cardIDs);
586     event RandomnessReceived(uint indexed id, address indexed user, uint16 count, uint randomness);
587     event Recommit(uint indexed id);
588 
589     constructor(MigrationInterface _core, CappedVault _vault) public payable CardPackFour(_core) {
590         vault = _vault;
591     }
592 
593     function basePrice() public returns (uint);
594     function getCardDetails(uint16 packIndex, uint8 cardIndex, uint result) public view returns (uint16 proto, uint16 purity);
595     
596     function packSize() public view returns (uint8) {
597         return 5;
598     }
599 
600     uint16 public perClaim = 15;
601 
602     function setPacksPerClaim(uint16 _perClaim) public onlyOwner {
603         perClaim = _perClaim;
604     }
605 
606     function packsPerClaim() public view returns (uint16) {
607         return perClaim;
608     }
609 
610     // start in bytes, length in bytes
611     function extract(uint num, uint length, uint start) internal pure returns (uint) {
612         return (((1 << (length * 8)) - 1) & (num >> ((start * 8) - 1)));
613     }
614 
615     function purchaseFor(address user, uint16 packCount, address referrer) whenNotPaused public payable {
616         _purchase(user, packCount, referrer);
617     }
618 
619     function purchase(uint16 packCount, address referrer) whenNotPaused public payable {
620         _purchase(msg.sender, packCount, referrer);
621     }
622 
623     function _purchase(address user, uint16 packCount, address referrer) internal {
624         require(packCount > 0);
625         require(referrer != user);
626 
627         uint price = calculatePrice(basePrice(), packCount);
628         uint value = msg.value;
629 
630         require(value >= price);
631 
632         Purchase memory p = Purchase({
633             user: user,
634             count: packCount,
635             commit: uint64(block.number),
636             randomness: 0,
637             current: 0
638         });
639 
640         uint id = purchases.push(p) - 1;
641 
642         emit PacksPurchased(id, user, packCount);
643 
644         if (referrer != address(0)) {
645             uint commission = price / 10;
646             referrer.transfer(commission);
647             price -= commission;
648             emit Referral(referrer, commission, user);
649         }
650         
651         address(vault).transfer(price);
652     }
653 
654     // can recommit
655     // this gives you more chances
656     // if no-one else sends the callback (should never happen)
657     // still only get a random extra chance
658     function recommit(uint id) public {
659 
660         Purchase storage p = purchases[id];
661 
662         require(p.randomness == 0);
663 
664         require(block.number >= p.commit + 256);
665 
666         p.commit = uint64(block.number);
667 
668         emit Recommit(id);
669     }
670 
671     // can be called by anybody
672     // can miners withhold blocks --> not really
673     // giving up block reward for extra chance --> still really low
674     function callback(uint id) public {
675 
676         Purchase storage p = purchases[id];
677 
678         require(p.randomness == 0);
679 
680         // must be within last 256 blocks, otherwise recommit
681         require(block.number - 256 < p.commit);
682 
683         // can't callback on the original block
684         require(uint64(block.number) != p.commit);
685 
686         bytes32 bhash = blockhash(p.commit);
687         // will get the same on every block
688         // only use properties which can't be altered by the user
689         uint random = uint(keccak256(abi.encodePacked(bhash, p.user, address(this), p.count)));
690 
691         require(uint(bhash) != 0);
692 
693         p.randomness = random;
694 
695         emit RandomnessReceived(id, p.user, p.count, p.randomness);
696     }
697 
698     function claim(uint id) public {
699         
700         Purchase storage p = purchases[id];
701 
702         require(canClaim);
703 
704         uint16 proto;
705         uint16 purity;
706         uint16 count = p.count;
707         uint result = p.randomness;
708         uint8 size = packSize();
709 
710         address user = p.user;
711         uint16 current = p.current;
712 
713         require(result != 0); // have to wait for the callback
714         // require(user == msg.sender); // not needed
715         require(count > 0);
716 
717         uint[] memory ids = new uint[](size);
718 
719         uint16 end = current + packsPerClaim() > count ? count : current + packsPerClaim();
720 
721         require(end > current);
722 
723         for (uint16 i = current; i < end; i++) {
724             for (uint8 j = 0; j < size; j++) {
725                 (proto, purity) = getCardDetails(i, j, result);
726                 ids[j] = migration.createCard(user, proto, purity);
727             }
728             emit PackOpened(id, (i * size), user, ids);
729         }
730         p.current += (end - current);
731     }
732 
733     function predictPacks(uint id) external view returns (uint16[] protos, uint16[] purities) {
734 
735         Purchase memory p = purchases[id];
736 
737         uint16 proto;
738         uint16 purity;
739         uint16 count = p.count;
740         uint result = p.randomness;
741         uint8 size = packSize();
742 
743         purities = new uint16[](size * count);
744         protos = new uint16[](size * count);
745 
746         for (uint16 i = 0; i < count; i++) {
747             for (uint8 j = 0; j < size; j++) {
748                 (proto, purity) = getCardDetails(i, j, result);
749                 purities[(i * size) + j] = purity;
750                 protos[(i * size) + j] = proto;
751             }
752         }
753         return (protos, purities);
754     }
755 
756     function calculatePrice(uint base, uint16 packCount) public view returns (uint) {
757         // roughly 6k blocks per day
758         uint difference = block.number - creationBlock;
759         uint numDays = difference / 6000;
760         if (20 > numDays) {
761             return (base - (((20 - numDays) * base) / 100)) * packCount;
762         }
763         return base * packCount;
764     }
765 
766     function _getCommonPlusRarity(uint32 rand) internal pure returns (CardProto.Rarity) {
767         if (rand == 999999) {
768             return CardProto.Rarity.Mythic;
769         } else if (rand >= 998345) {
770             return CardProto.Rarity.Legendary;
771         } else if (rand >= 986765) {
772             return CardProto.Rarity.Epic;
773         } else if (rand >= 924890) {
774             return CardProto.Rarity.Rare;
775         } else {
776             return CardProto.Rarity.Common;
777         }
778     }
779 
780     function _getRarePlusRarity(uint32 rand) internal pure returns (CardProto.Rarity) {
781         if (rand == 999999) {
782             return CardProto.Rarity.Mythic;
783         } else if (rand >= 981615) {
784             return CardProto.Rarity.Legendary;
785         } else if (rand >= 852940) {
786             return CardProto.Rarity.Epic;
787         } else {
788             return CardProto.Rarity.Rare;
789         } 
790     }
791 
792     function _getEpicPlusRarity(uint32 rand) internal pure returns (CardProto.Rarity) {
793         if (rand == 999999) {
794             return CardProto.Rarity.Mythic;
795         } else if (rand >= 981615) {
796             return CardProto.Rarity.Legendary;
797         } else {
798             return CardProto.Rarity.Epic;
799         }
800     }
801 
802     function _getLegendaryPlusRarity(uint32 rand) internal pure returns (CardProto.Rarity) {
803         if (rand == 999999) {
804             return CardProto.Rarity.Mythic;
805         } else {
806             return CardProto.Rarity.Legendary;
807         } 
808     }
809 
810     bool public canClaim = true;
811 
812     function setCanClaim(bool claim) public onlyOwner {
813         canClaim = claim;
814     }
815 
816     function getComponents(
817         uint16 i, uint8 j, uint rand
818     ) internal returns (
819         uint random, uint32 rarityRandom, uint16 purityOne, uint16 purityTwo, uint16 protoRandom
820     ) {
821         random = uint(keccak256(abi.encodePacked(i, rand, j)));
822         rarityRandom = uint32(extract(random, 4, 10) % 1000000);
823         purityOne = uint16(extract(random, 2, 4) % 1000);
824         purityTwo = uint16(extract(random, 2, 6) % 1000);
825         protoRandom = uint16(extract(random, 2, 8) % (2**16-1));
826         return (random, rarityRandom, purityOne, purityTwo, protoRandom);
827     }
828 
829     function withdraw() public onlyOwner {
830         owner.transfer(address(this).balance);
831     }
832 
833 }
834 
835 
836 contract DiscountPack is Vault {
837 
838     PresalePackFour private pack;
839     uint public basePrice;
840     uint public baseDiscount;
841 
842     constructor(PresalePackFour packToDiscount) public {
843         pack = packToDiscount;
844 
845         baseDiscount = uint(7) * pack.basePrice() / uint(100);
846         basePrice = pack.basePrice() - baseDiscount;
847     }
848 
849     event PackDiscount(address purchaser, uint16 packs, uint discount);
850  
851     function() public payable {}
852 
853     function purchase(uint16 packs) public payable {
854         uint discountedPrice = packs * basePrice;
855         uint discount = packs * baseDiscount;
856         uint fullPrice = discountedPrice + discount;
857 
858         require(msg.value >= discountedPrice, "Not enough value for the desired pack count.");
859         require(address(this).balance >= discount, "This contract is out of front money.");
860 
861         // This should route the referral back to this contract
862         pack.purchaseFor.value(fullPrice)(msg.sender, packs, this);
863         emit PackDiscount(msg.sender, packs, discount);
864     }
865 
866     function fraction(uint value, uint8 num, uint8 denom) internal pure returns (uint) {
867         return (uint(num) * value) / uint(denom);
868     }
869 }