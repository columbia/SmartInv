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
22 contract Vault is Ownable { 
23 
24     function () public payable {
25 
26     }
27 
28     function getBalance() public view returns (uint) {
29         return address(this).balance;
30     }
31 
32     function withdraw(uint amount) public onlyOwner {
33         require(address(this).balance >= amount);
34         owner.transfer(amount);
35     }
36 
37     function withdrawAll() public onlyOwner {
38         withdraw(address(this).balance);
39     }
40 }
41 
42 
43 contract CappedVault is Vault { 
44 
45     uint public limit;
46     uint withdrawn = 0;
47 
48     constructor() public {
49         limit = 33333 ether;
50     }
51 
52     function () public payable {
53         require(total() + msg.value <= limit);
54     }
55 
56     function total() public view returns(uint) {
57         return getBalance() + withdrawn;
58     }
59 
60     function withdraw(uint amount) public onlyOwner {
61         require(address(this).balance >= amount);
62         owner.transfer(amount);
63         withdrawn += amount;
64     }
65 
66 }
67 
68 
69 contract PreviousInterface {
70 
71     function ownerOf(uint id) public view returns (address);
72 
73     function getCard(uint id) public view returns (uint16, uint16);
74 
75     function totalSupply() public view returns (uint);
76 
77     function burnCount() public view returns (uint);
78 
79 }
80 
81 contract Pausable is Ownable {
82     
83     event Pause();
84     event Unpause();
85 
86     bool public paused = false;
87 
88 
89     /**
90     * @dev Modifier to make a function callable only when the contract is not paused.
91     */
92     modifier whenNotPaused() {
93         require(!paused);
94         _;
95     }
96 
97     /**
98     * @dev Modifier to make a function callable only when the contract is paused.
99     */
100     modifier whenPaused() {
101         require(paused);
102         _;
103     }
104 
105     /**
106     * @dev called by the owner to pause, triggers stopped state
107     */
108     function pause() onlyOwner whenNotPaused public {
109         paused = true;
110         emit Pause();
111     }
112 
113     /**
114     * @dev called by the owner to unpause, returns to normal state
115     */
116     function unpause() onlyOwner whenPaused public {
117         paused = false;
118         emit Unpause();
119     }
120 }
121 
122 contract Governable {
123 
124     event Pause();
125     event Unpause();
126 
127     address public governor;
128     bool public paused = false;
129 
130     constructor() public {
131         governor = msg.sender;
132     }
133 
134     function setGovernor(address _gov) public onlyGovernor {
135         governor = _gov;
136     }
137 
138     modifier onlyGovernor {
139         require(msg.sender == governor);
140         _;
141     }
142 
143     /**
144     * @dev Modifier to make a function callable only when the contract is not paused.
145     */
146     modifier whenNotPaused() {
147         require(!paused);
148         _;
149     }
150 
151     /**
152     * @dev Modifier to make a function callable only when the contract is paused.
153     */
154     modifier whenPaused() {
155         require(paused);
156         _;
157     }
158 
159     /**
160     * @dev called by the owner to pause, triggers stopped state
161     */
162     function pause() onlyGovernor whenNotPaused public {
163         paused = true;
164         emit Pause();
165     }
166 
167     /**
168     * @dev called by the owner to unpause, returns to normal state
169     */
170     function unpause() onlyGovernor whenPaused public {
171         paused = false;
172         emit Unpause();
173     }
174 
175 }
176 
177 contract CardBase is Governable {
178 
179 
180     struct Card {
181         uint16 proto;
182         uint16 purity;
183     }
184 
185     function getCard(uint id) public view returns (uint16 proto, uint16 purity) {
186         Card memory card = cards[id];
187         return (card.proto, card.purity);
188     }
189 
190     function getShine(uint16 purity) public pure returns (uint8) {
191         return uint8(purity / 1000);
192     }
193 
194     Card[] public cards;
195     
196 }
197 
198 contract CardProto is CardBase {
199 
200     event NewProtoCard(
201         uint16 id, uint8 season, uint8 god, 
202         Rarity rarity, uint8 mana, uint8 attack, 
203         uint8 health, uint8 cardType, uint8 tribe, bool packable
204     );
205 
206     struct Limit {
207         uint64 limit;
208         bool exists;
209     }
210 
211     // limits for mythic cards
212     mapping(uint16 => Limit) public limits;
213 
214     // can only set limits once
215     function setLimit(uint16 id, uint64 limit) public onlyGovernor {
216         Limit memory l = limits[id];
217         require(!l.exists);
218         limits[id] = Limit({
219             limit: limit,
220             exists: true
221         });
222     }
223 
224     function getLimit(uint16 id) public view returns (uint64 limit, bool set) {
225         Limit memory l = limits[id];
226         return (l.limit, l.exists);
227     }
228 
229     // could make these arrays to save gas
230     // not really necessary - will be update a very limited no of times
231     mapping(uint8 => bool) public seasonTradable;
232     mapping(uint8 => bool) public seasonTradabilityLocked;
233     uint8 public currentSeason;
234 
235     function makeTradable(uint8 season) public onlyGovernor {
236         seasonTradable[season] = true;
237     }
238 
239     function makeUntradable(uint8 season) public onlyGovernor {
240         require(!seasonTradabilityLocked[season]);
241         seasonTradable[season] = false;
242     }
243 
244     function makePermanantlyTradable(uint8 season) public onlyGovernor {
245         require(seasonTradable[season]);
246         seasonTradabilityLocked[season] = true;
247     }
248 
249     function isTradable(uint16 proto) public view returns (bool) {
250         return seasonTradable[protos[proto].season];
251     }
252 
253     function nextSeason() public onlyGovernor {
254         //Seasons shouldn't go to 0 if there is more than the uint8 should hold, the governor should know this ¯\_(ツ)_/¯ -M
255         require(currentSeason <= 255); 
256 
257         currentSeason++;
258         mythic.length = 0;
259         legendary.length = 0;
260         epic.length = 0;
261         rare.length = 0;
262         common.length = 0;
263     }
264 
265     enum Rarity {
266         Common,
267         Rare,
268         Epic,
269         Legendary, 
270         Mythic
271     }
272 
273     uint8 constant SPELL = 1;
274     uint8 constant MINION = 2;
275     uint8 constant WEAPON = 3;
276     uint8 constant HERO = 4;
277 
278     struct ProtoCard {
279         bool exists;
280         uint8 god;
281         uint8 season;
282         uint8 cardType;
283         Rarity rarity;
284         uint8 mana;
285         uint8 attack;
286         uint8 health;
287         uint8 tribe;
288     }
289 
290     // there is a particular design decision driving this:
291     // need to be able to iterate over mythics only for card generation
292     // don't store 5 different arrays: have to use 2 ids
293     // better to bear this cost (2 bytes per proto card)
294     // rather than 1 byte per instance
295 
296     uint16 public protoCount;
297     
298     mapping(uint16 => ProtoCard) protos;
299 
300     uint16[] public mythic;
301     uint16[] public legendary;
302     uint16[] public epic;
303     uint16[] public rare;
304     uint16[] public common;
305 
306     function addProtos(
307         uint16[] externalIDs, uint8[] gods, Rarity[] rarities, uint8[] manas, uint8[] attacks, 
308         uint8[] healths, uint8[] cardTypes, uint8[] tribes, bool[] packable
309     ) public onlyGovernor returns(uint16) {
310 
311         for (uint i = 0; i < externalIDs.length; i++) {
312 
313             ProtoCard memory card = ProtoCard({
314                 exists: true,
315                 god: gods[i],
316                 season: currentSeason,
317                 cardType: cardTypes[i],
318                 rarity: rarities[i],
319                 mana: manas[i],
320                 attack: attacks[i],
321                 health: healths[i],
322                 tribe: tribes[i]
323             });
324 
325             _addProto(externalIDs[i], card, packable[i]);
326         }
327         
328     }
329 
330     function addProto(
331         uint16 externalID, uint8 god, Rarity rarity, uint8 mana, uint8 attack, uint8 health, uint8 cardType, uint8 tribe, bool packable
332     ) public onlyGovernor returns(uint16) {
333         ProtoCard memory card = ProtoCard({
334             exists: true,
335             god: god,
336             season: currentSeason,
337             cardType: cardType,
338             rarity: rarity,
339             mana: mana,
340             attack: attack,
341             health: health,
342             tribe: tribe
343         });
344 
345         _addProto(externalID, card, packable);
346     }
347 
348     function addWeapon(
349         uint16 externalID, uint8 god, Rarity rarity, uint8 mana, uint8 attack, uint8 durability, bool packable
350     ) public onlyGovernor returns(uint16) {
351 
352         ProtoCard memory card = ProtoCard({
353             exists: true,
354             god: god,
355             season: currentSeason,
356             cardType: WEAPON,
357             rarity: rarity,
358             mana: mana,
359             attack: attack,
360             health: durability,
361             tribe: 0
362         });
363 
364         _addProto(externalID, card, packable);
365     }
366 
367     function addSpell(uint16 externalID, uint8 god, Rarity rarity, uint8 mana, bool packable) public onlyGovernor returns(uint16) {
368 
369         ProtoCard memory card = ProtoCard({
370             exists: true,
371             god: god,
372             season: currentSeason,
373             cardType: SPELL,
374             rarity: rarity,
375             mana: mana,
376             attack: 0,
377             health: 0,
378             tribe: 0
379         });
380 
381         _addProto(externalID, card, packable);
382     }
383 
384     function addMinion(
385         uint16 externalID, uint8 god, Rarity rarity, uint8 mana, uint8 attack, uint8 health, uint8 tribe, bool packable
386     ) public onlyGovernor returns(uint16) {
387 
388         ProtoCard memory card = ProtoCard({
389             exists: true,
390             god: god,
391             season: currentSeason,
392             cardType: MINION,
393             rarity: rarity,
394             mana: mana,
395             attack: attack,
396             health: health,
397             tribe: tribe
398         });
399 
400         _addProto(externalID, card, packable);
401     }
402 
403     function _addProto(uint16 externalID, ProtoCard memory card, bool packable) internal {
404 
405         require(!protos[externalID].exists);
406 
407         card.exists = true;
408 
409         protos[externalID] = card;
410 
411         protoCount++;
412 
413         emit NewProtoCard(
414             externalID, currentSeason, card.god, 
415             card.rarity, card.mana, card.attack, 
416             card.health, card.cardType, card.tribe, packable
417         );
418 
419         if (packable) {
420             Rarity rarity = card.rarity;
421             if (rarity == Rarity.Common) {
422                 common.push(externalID);
423             } else if (rarity == Rarity.Rare) {
424                 rare.push(externalID);
425             } else if (rarity == Rarity.Epic) {
426                 epic.push(externalID);
427             } else if (rarity == Rarity.Legendary) {
428                 legendary.push(externalID);
429             } else if (rarity == Rarity.Mythic) {
430                 mythic.push(externalID);
431             } else {
432                 require(false);
433             }
434         }
435     }
436 
437     function getProto(uint16 id) public view returns(
438         bool exists, uint8 god, uint8 season, uint8 cardType, Rarity rarity, uint8 mana, uint8 attack, uint8 health, uint8 tribe
439     ) {
440         ProtoCard memory proto = protos[id];
441         return (
442             proto.exists,
443             proto.god,
444             proto.season,
445             proto.cardType,
446             proto.rarity,
447             proto.mana,
448             proto.attack,
449             proto.health,
450             proto.tribe
451         );
452     }
453 
454     function getRandomCard(Rarity rarity, uint16 random) public view returns (uint16) {
455         // modulo bias is fine - creates rarity tiers etc
456         // will obviously revert is there are no cards of that type: this is expected - should never happen
457         if (rarity == Rarity.Common) {
458             return common[random % common.length];
459         } else if (rarity == Rarity.Rare) {
460             return rare[random % rare.length];
461         } else if (rarity == Rarity.Epic) {
462             return epic[random % epic.length];
463         } else if (rarity == Rarity.Legendary) {
464             return legendary[random % legendary.length];
465         } else if (rarity == Rarity.Mythic) {
466             // make sure a mythic is available
467             uint16 id;
468             uint64 limit;
469             bool set;
470             for (uint i = 0; i < mythic.length; i++) {
471                 id = mythic[(random + i) % mythic.length];
472                 (limit, set) = getLimit(id);
473                 if (set && limit > 0){
474                     return id;
475                 }
476             }
477             // if not, they get a legendary :(
478             return legendary[random % legendary.length];
479         }
480         require(false);
481         return 0;
482     }
483 
484     // can never adjust tradable cards
485     // each season gets a 'balancing beta'
486     // totally immutable: season, rarity
487     function replaceProto(
488         uint16 index, uint8 god, uint8 cardType, uint8 mana, uint8 attack, uint8 health, uint8 tribe
489     ) public onlyGovernor {
490         ProtoCard memory pc = protos[index];
491         require(!seasonTradable[pc.season]);
492         protos[index] = ProtoCard({
493             exists: true,
494             god: god,
495             season: pc.season,
496             cardType: cardType,
497             rarity: pc.rarity,
498             mana: mana,
499             attack: attack,
500             health: health,
501             tribe: tribe
502         });
503     }
504 
505 }
506 
507 contract MigrationInterface {
508 
509     function createCard(address user, uint16 proto, uint16 purity) public returns (uint);
510 
511     function getRandomCard(CardProto.Rarity rarity, uint16 random) public view returns (uint16);
512 
513     function migrate(uint id) public;
514 
515 }
516 
517 contract CardPackThree {
518 
519     MigrationInterface public migration;
520     uint public creationBlock;
521 
522     constructor(MigrationInterface _core) public payable {
523         migration = _core;
524         creationBlock = 5939061 + 2000; // set to creation block of first contracts + 8 hours for down time
525     }
526 
527     event Referral(address indexed referrer, uint value, address purchaser);
528 
529     /**
530     * purchase 'count' of this type of pack
531     */
532     function purchase(uint16 packCount, address referrer) public payable;
533 
534     // store purity and shine as one number to save users gas
535     function _getPurity(uint16 randOne, uint16 randTwo) internal pure returns (uint16) {
536         if (randOne >= 998) {
537             return 3000 + randTwo;
538         } else if (randOne >= 988) {
539             return 2000 + randTwo;
540         } else if (randOne >= 938) {
541             return 1000 + randTwo;
542         } else {
543             return randTwo;
544         }
545     }
546 
547 }
548 
549 contract FirstPheonix is Pausable {
550 
551     MigrationInterface core;
552 
553     constructor(MigrationInterface _core) public {
554         core = _core;
555     }
556 
557     address[] public approved;
558 
559     uint16 PHEONIX_PROTO = 380;
560 
561     mapping(address => bool) public claimed;
562 
563     function approvePack(address toApprove) public onlyOwner {
564         approved.push(toApprove);
565     }
566 
567     function isApproved(address test) public view returns (bool) {
568         for (uint i = 0; i < approved.length; i++) {
569             if (approved[i] == test) {
570                 return true;
571             }
572         }
573         return false;
574     }
575 
576     // pause once cards become tradable
577     function claimPheonix(address user) public returns (bool){
578 
579         require(isApproved(msg.sender));
580 
581         if (claimed[user] || paused){
582             return false;
583         }
584 
585         claimed[user] = true;
586 
587         core.createCard(user, PHEONIX_PROTO, 0);
588 
589         return true;
590     }
591 
592 }
593 
594 
595 
596 contract PresalePackThree is CardPackThree, Pausable {
597 
598     CappedVault public vault;
599 
600     Purchase[] public purchases;
601 
602     function getPurchaseCount() public view returns (uint) {
603         return purchases.length;
604     }
605 
606     struct Purchase {
607         uint16 current;
608         uint16 count;
609         address user;
610         uint randomness;
611         uint64 commit;
612     }
613 
614     event PacksPurchased(uint indexed id, address indexed user, uint16 count);
615     event PackOpened(uint indexed id, uint16 startIndex, address indexed user, uint[] cardIDs);
616     event RandomnessReceived(uint indexed id, address indexed user, uint16 count, uint randomness);
617 
618     constructor(MigrationInterface _core, CappedVault _vault) public payable CardPackThree(_core) {
619         vault = _vault;
620     }
621 
622     function basePrice() public returns (uint);
623     function getCardDetails(uint16 packIndex, uint8 cardIndex, uint result) public view returns (uint16 proto, uint16 purity);
624     
625     function packSize() public view returns (uint8) {
626         return 5;
627     }
628 
629     function packsPerClaim() public view returns (uint16) {
630         return 15;
631     }
632 
633     // start in bytes, length in bytes
634     function extract(uint num, uint length, uint start) internal pure returns (uint) {
635         return (((1 << (length * 8)) - 1) & (num >> ((start * 8) - 1)));
636     }
637 
638     function purchase(uint16 packCount, address referrer) whenNotPaused public payable {
639 
640         require(packCount > 0);
641         require(referrer != msg.sender);
642 
643         uint price = calculatePrice(basePrice(), packCount);
644 
645         require(msg.value >= price);
646 
647         Purchase memory p = Purchase({
648             user: msg.sender,
649             count: packCount,
650             commit: uint64(block.number),
651             randomness: 0,
652             current: 0
653         });
654 
655         uint id = purchases.push(p) - 1;
656 
657         emit PacksPurchased(id, msg.sender, packCount);
658 
659         if (referrer != address(0)) {
660             uint commission = price / 10;
661             referrer.transfer(commission);
662             price -= commission;
663             emit Referral(referrer, commission, msg.sender);
664         }
665         
666         address(vault).transfer(price); 
667     }
668 
669     // can be called by anybody
670     // can miners withhold blocks --> not really
671     // giving up block reward for extra chance --> still really low
672     function callback(uint id) public {
673 
674         Purchase storage p = purchases[id];
675 
676         require(p.randomness == 0);
677 
678         bytes32 bhash = blockhash(p.commit);
679         // will get the same on every block
680         // only use properties which can't be altered by the user
681         uint random = uint(keccak256(abi.encodePacked(bhash, p.user, address(this), p.count)));
682 
683         // can't callback on the original block
684         require(uint64(block.number) != p.commit);
685 
686         if (uint(bhash) == 0) {
687             // should never happen (must call within next 256 blocks)
688             // if it does, just give them 1: will become common and therefore less valuable
689             // set to 1 rather than 0 to avoid calling claim before randomness
690             p.randomness = 1;
691         } else {
692             p.randomness = random;
693         }
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
835 contract PackMultiplier is PresalePackThree {
836 
837     address[] public packs;
838     uint16 public multiplier = 3;
839     FirstPheonix pheonix;
840     PreviousInterface old;
841 
842     uint16 public packLimit = 5;
843 
844     constructor(PreviousInterface _old, address[] _packs, MigrationInterface _core, CappedVault vault, FirstPheonix _pheonix) 
845         public PresalePackThree(_core, vault) 
846     {
847         packs = _packs;
848         pheonix = _pheonix;
849         old = _old;
850     }
851 
852     function getCardCount() internal view returns (uint) {
853         return old.totalSupply() + old.burnCount();
854     }
855 
856     function isPriorPack(address test) public view returns(bool) {
857         for (uint i = 0; i < packs.length; i++) {
858             if (packs[i] == test) {
859                 return true;
860             }
861         }
862         return false;
863     }
864 
865     event Status(uint before, uint aft);
866 
867     function claimMultiple(address pack, uint purchaseID) public returns (uint16, address) {
868 
869         require(isPriorPack(pack));
870 
871         uint length = getCardCount();
872 
873         PresalePackThree(pack).claim(purchaseID);
874 
875         uint lengthAfter = getCardCount();
876 
877         require(lengthAfter > length);
878 
879         uint16 cardDifference = uint16(lengthAfter - length);
880 
881         require(cardDifference % 5 == 0);
882 
883         uint16 packCount = cardDifference / 5;
884 
885         uint16 extra = packCount * multiplier;
886 
887         address lastCardOwner = old.ownerOf(lengthAfter - 1);
888 
889         Purchase memory p = Purchase({
890             user: lastCardOwner,
891             count: extra,
892             commit: uint64(block.number),
893             randomness: 0,
894             current: 0
895         });
896 
897         uint id = purchases.push(p) - 1;
898 
899         emit PacksPurchased(id, lastCardOwner, extra);
900 
901         // try to give them a first pheonix
902         pheonix.claimPheonix(lastCardOwner);
903 
904         emit Status(length, lengthAfter);
905 
906 
907         if (packCount <= packLimit) {
908             for (uint i = 0; i < cardDifference; i++) {
909                 migration.migrate(lengthAfter - 1 - i);
910             }
911         }
912 
913         return (extra, lastCardOwner);
914     }
915 
916     function setPackLimit(uint16 limit) public onlyOwner {
917         packLimit = limit;
918     }
919 
920 
921 }
922 
923 contract EpicPackThree is PackMultiplier {
924     
925     function basePrice() public returns (uint) {
926         return 75 finney;
927     }
928 
929     constructor(PreviousInterface _old, address[] _packs, MigrationInterface _core, CappedVault vault, FirstPheonix _pheonix) 
930         public PackMultiplier(_old, _packs, _core, vault, _pheonix) {
931         
932     }  
933     
934     function getCardDetails(uint16 packIndex, uint8 cardIndex, uint result) public view returns (uint16 proto, uint16 purity) {
935         uint random;
936         uint32 rarityRandom;
937         uint16 protoRandom;
938         uint16 purityOne;
939         uint16 purityTwo;
940         CardProto.Rarity rarity;
941 
942         (random, rarityRandom, purityOne, purityTwo, protoRandom) = getComponents(packIndex, cardIndex, result);
943 
944         if (cardIndex == 4) {
945             rarity = _getEpicPlusRarity(rarityRandom);
946         } else {
947             rarity = _getCommonPlusRarity(rarityRandom);
948         }
949 
950         purity = _getPurity(purityOne, purityTwo);
951     
952         proto = migration.getRandomCard(rarity, protoRandom);
953 
954         return (proto, purity);
955     } 
956 
957     
958 }