1 pragma solidity 0.4.24;
2 
3 
4 contract Governable {
5 
6     event Pause();
7     event Unpause();
8 
9     address public governor;
10     bool public paused = false;
11 
12     constructor() public {
13         governor = msg.sender;
14     }
15 
16     function setGovernor(address _gov) public onlyGovernor {
17         governor = _gov;
18     }
19 
20     modifier onlyGovernor {
21         require(msg.sender == governor);
22         _;
23     }
24 
25     /**
26     * @dev Modifier to make a function callable only when the contract is not paused.
27     */
28     modifier whenNotPaused() {
29         require(!paused);
30         _;
31     }
32 
33     /**
34     * @dev Modifier to make a function callable only when the contract is paused.
35     */
36     modifier whenPaused() {
37         require(paused);
38         _;
39     }
40 
41     /**
42     * @dev called by the owner to pause, triggers stopped state
43     */
44     function pause() onlyGovernor whenNotPaused public {
45         paused = true;
46         emit Pause();
47     }
48 
49     /**
50     * @dev called by the owner to unpause, returns to normal state
51     */
52     function unpause() onlyGovernor whenPaused public {
53         paused = false;
54         emit Unpause();
55     }
56 
57 }
58 
59 contract CardBase is Governable {
60 
61 
62     struct Card {
63         uint16 proto;
64         uint16 purity;
65     }
66 
67     function getCard(uint id) public view returns (uint16 proto, uint16 purity) {
68         Card memory card = cards[id];
69         return (card.proto, card.purity);
70     }
71 
72     function getShine(uint16 purity) public pure returns (uint8) {
73         return uint8(purity / 1000);
74     }
75 
76     Card[] public cards;
77     
78 }
79 
80 contract CardProto is CardBase {
81 
82     event NewProtoCard(
83         uint16 id, uint8 season, uint8 god, 
84         Rarity rarity, uint8 mana, uint8 attack, 
85         uint8 health, uint8 cardType, uint8 tribe, bool packable
86     );
87 
88     struct Limit {
89         uint64 limit;
90         bool exists;
91     }
92 
93     // limits for mythic cards
94     mapping(uint16 => Limit) public limits;
95 
96     // can only set limits once
97     function setLimit(uint16 id, uint64 limit) public onlyGovernor {
98         Limit memory l = limits[id];
99         require(!l.exists);
100         limits[id] = Limit({
101             limit: limit,
102             exists: true
103         });
104     }
105 
106     function getLimit(uint16 id) public view returns (uint64 limit, bool set) {
107         Limit memory l = limits[id];
108         return (l.limit, l.exists);
109     }
110 
111     // could make these arrays to save gas
112     // not really necessary - will be update a very limited no of times
113     mapping(uint8 => bool) public seasonTradable;
114     mapping(uint8 => bool) public seasonTradabilityLocked;
115     uint8 public currentSeason;
116 
117     function makeTradable(uint8 season) public onlyGovernor {
118         seasonTradable[season] = true;
119     }
120 
121     function makeUntradable(uint8 season) public onlyGovernor {
122         require(!seasonTradabilityLocked[season]);
123         seasonTradable[season] = false;
124     }
125 
126     function makePermanantlyTradable(uint8 season) public onlyGovernor {
127         require(seasonTradable[season]);
128         seasonTradabilityLocked[season] = true;
129     }
130 
131     function isTradable(uint16 proto) public view returns (bool) {
132         return seasonTradable[protos[proto].season];
133     }
134 
135     function nextSeason() public onlyGovernor {
136         //Seasons shouldn't go to 0 if there is more than the uint8 should hold, the governor should know this ¯\_(ツ)_/¯ -M
137         require(currentSeason <= 255); 
138 
139         currentSeason++;
140         mythic.length = 0;
141         legendary.length = 0;
142         epic.length = 0;
143         rare.length = 0;
144         common.length = 0;
145     }
146 
147     enum Rarity {
148         Common,
149         Rare,
150         Epic,
151         Legendary, 
152         Mythic
153     }
154 
155     uint8 constant SPELL = 1;
156     uint8 constant MINION = 2;
157     uint8 constant WEAPON = 3;
158     uint8 constant HERO = 4;
159 
160     struct ProtoCard {
161         bool exists;
162         uint8 god;
163         uint8 season;
164         uint8 cardType;
165         Rarity rarity;
166         uint8 mana;
167         uint8 attack;
168         uint8 health;
169         uint8 tribe;
170     }
171 
172     // there is a particular design decision driving this:
173     // need to be able to iterate over mythics only for card generation
174     // don't store 5 different arrays: have to use 2 ids
175     // better to bear this cost (2 bytes per proto card)
176     // rather than 1 byte per instance
177 
178     uint16 public protoCount;
179     
180     mapping(uint16 => ProtoCard) protos;
181 
182     uint16[] public mythic;
183     uint16[] public legendary;
184     uint16[] public epic;
185     uint16[] public rare;
186     uint16[] public common;
187 
188     function addProtos(
189         uint16[] externalIDs, uint8[] gods, Rarity[] rarities, uint8[] manas, uint8[] attacks, 
190         uint8[] healths, uint8[] cardTypes, uint8[] tribes, bool[] packable
191     ) public onlyGovernor returns(uint16) {
192 
193         for (uint i = 0; i < externalIDs.length; i++) {
194 
195             ProtoCard memory card = ProtoCard({
196                 exists: true,
197                 god: gods[i],
198                 season: currentSeason,
199                 cardType: cardTypes[i],
200                 rarity: rarities[i],
201                 mana: manas[i],
202                 attack: attacks[i],
203                 health: healths[i],
204                 tribe: tribes[i]
205             });
206 
207             _addProto(externalIDs[i], card, packable[i]);
208         }
209         
210     }
211 
212     function addProto(
213         uint16 externalID, uint8 god, Rarity rarity, uint8 mana, uint8 attack, uint8 health, uint8 cardType, uint8 tribe, bool packable
214     ) public onlyGovernor returns(uint16) {
215         ProtoCard memory card = ProtoCard({
216             exists: true,
217             god: god,
218             season: currentSeason,
219             cardType: cardType,
220             rarity: rarity,
221             mana: mana,
222             attack: attack,
223             health: health,
224             tribe: tribe
225         });
226 
227         _addProto(externalID, card, packable);
228     }
229 
230     function addWeapon(
231         uint16 externalID, uint8 god, Rarity rarity, uint8 mana, uint8 attack, uint8 durability, bool packable
232     ) public onlyGovernor returns(uint16) {
233 
234         ProtoCard memory card = ProtoCard({
235             exists: true,
236             god: god,
237             season: currentSeason,
238             cardType: WEAPON,
239             rarity: rarity,
240             mana: mana,
241             attack: attack,
242             health: durability,
243             tribe: 0
244         });
245 
246         _addProto(externalID, card, packable);
247     }
248 
249     function addSpell(uint16 externalID, uint8 god, Rarity rarity, uint8 mana, bool packable) public onlyGovernor returns(uint16) {
250 
251         ProtoCard memory card = ProtoCard({
252             exists: true,
253             god: god,
254             season: currentSeason,
255             cardType: SPELL,
256             rarity: rarity,
257             mana: mana,
258             attack: 0,
259             health: 0,
260             tribe: 0
261         });
262 
263         _addProto(externalID, card, packable);
264     }
265 
266     function addMinion(
267         uint16 externalID, uint8 god, Rarity rarity, uint8 mana, uint8 attack, uint8 health, uint8 tribe, bool packable
268     ) public onlyGovernor returns(uint16) {
269 
270         ProtoCard memory card = ProtoCard({
271             exists: true,
272             god: god,
273             season: currentSeason,
274             cardType: MINION,
275             rarity: rarity,
276             mana: mana,
277             attack: attack,
278             health: health,
279             tribe: tribe
280         });
281 
282         _addProto(externalID, card, packable);
283     }
284 
285     function _addProto(uint16 externalID, ProtoCard memory card, bool packable) internal {
286 
287         require(!protos[externalID].exists);
288 
289         card.exists = true;
290 
291         protos[externalID] = card;
292 
293         protoCount++;
294 
295         emit NewProtoCard(
296             externalID, currentSeason, card.god, 
297             card.rarity, card.mana, card.attack, 
298             card.health, card.cardType, card.tribe, packable
299         );
300 
301         if (packable) {
302             Rarity rarity = card.rarity;
303             if (rarity == Rarity.Common) {
304                 common.push(externalID);
305             } else if (rarity == Rarity.Rare) {
306                 rare.push(externalID);
307             } else if (rarity == Rarity.Epic) {
308                 epic.push(externalID);
309             } else if (rarity == Rarity.Legendary) {
310                 legendary.push(externalID);
311             } else if (rarity == Rarity.Mythic) {
312                 mythic.push(externalID);
313             } else {
314                 require(false);
315             }
316         }
317     }
318 
319     function getProto(uint16 id) public view returns(
320         bool exists, uint8 god, uint8 season, uint8 cardType, Rarity rarity, uint8 mana, uint8 attack, uint8 health, uint8 tribe
321     ) {
322         ProtoCard memory proto = protos[id];
323         return (
324             proto.exists,
325             proto.god,
326             proto.season,
327             proto.cardType,
328             proto.rarity,
329             proto.mana,
330             proto.attack,
331             proto.health,
332             proto.tribe
333         );
334     }
335 
336     function getRandomCard(Rarity rarity, uint16 random) public view returns (uint16) {
337         // modulo bias is fine - creates rarity tiers etc
338         // will obviously revert is there are no cards of that type: this is expected - should never happen
339         if (rarity == Rarity.Common) {
340             return common[random % common.length];
341         } else if (rarity == Rarity.Rare) {
342             return rare[random % rare.length];
343         } else if (rarity == Rarity.Epic) {
344             return epic[random % epic.length];
345         } else if (rarity == Rarity.Legendary) {
346             return legendary[random % legendary.length];
347         } else if (rarity == Rarity.Mythic) {
348             // make sure a mythic is available
349             uint16 id;
350             uint64 limit;
351             bool set;
352             for (uint i = 0; i < mythic.length; i++) {
353                 id = mythic[(random + i) % mythic.length];
354                 (limit, set) = getLimit(id);
355                 if (set && limit > 0){
356                     return id;
357                 }
358             }
359             // if not, they get a legendary :(
360             return legendary[random % legendary.length];
361         }
362         require(false);
363         return 0;
364     }
365 
366     // can never adjust tradable cards
367     // each season gets a 'balancing beta'
368     // totally immutable: season, rarity
369     function replaceProto(
370         uint16 index, uint8 god, uint8 cardType, uint8 mana, uint8 attack, uint8 health, uint8 tribe
371     ) public onlyGovernor {
372         ProtoCard memory pc = protos[index];
373         require(!seasonTradable[pc.season]);
374         protos[index] = ProtoCard({
375             exists: true,
376             god: god,
377             season: pc.season,
378             cardType: cardType,
379             rarity: pc.rarity,
380             mana: mana,
381             attack: attack,
382             health: health,
383             tribe: tribe
384         });
385     }
386 
387 }
388 
389 contract MigrationInterface {
390 
391     function createCard(address user, uint16 proto, uint16 purity) public returns (uint);
392 
393     function getRandomCard(CardProto.Rarity rarity, uint16 random) public view returns (uint16);
394 
395     function migrate(uint id) public;
396 
397 }
398 
399 contract CardPackFour {
400 
401     MigrationInterface public migration;
402     uint public creationBlock;
403 
404     constructor(MigrationInterface _core) public payable {
405         migration = _core;
406         creationBlock = 5939061 + 2000; // set to creation block of first contracts + 8 hours for down time
407     }
408 
409     event Referral(address indexed referrer, uint value, address purchaser);
410 
411     /**
412     * purchase 'count' of this type of pack
413     */
414     function purchase(uint16 packCount, address referrer) public payable;
415 
416     // store purity and shine as one number to save users gas
417     function _getPurity(uint16 randOne, uint16 randTwo) internal pure returns (uint16) {
418         if (randOne >= 998) {
419             return 3000 + randTwo;
420         } else if (randOne >= 988) {
421             return 2000 + randTwo;
422         } else if (randOne >= 938) {
423             return 1000 + randTwo;
424         } else {
425             return randTwo;
426         }
427     }
428 
429 }
430 
431 contract Ownable {
432 
433     address public owner;
434 
435     constructor() public {
436         owner = msg.sender;
437     }
438 
439     function setOwner(address _owner) public onlyOwner {
440         owner = _owner;
441     }
442 
443     modifier onlyOwner {
444         require(msg.sender == owner);
445         _;
446     }
447 
448 }
449 
450 contract Pausable is Ownable {
451     
452     event Pause();
453     event Unpause();
454 
455     bool public paused = false;
456 
457 
458     /**
459     * @dev Modifier to make a function callable only when the contract is not paused.
460     */
461     modifier whenNotPaused() {
462         require(!paused);
463         _;
464     }
465 
466     /**
467     * @dev Modifier to make a function callable only when the contract is paused.
468     */
469     modifier whenPaused() {
470         require(paused);
471         _;
472     }
473 
474     /**
475     * @dev called by the owner to pause, triggers stopped state
476     */
477     function pause() onlyOwner whenNotPaused public {
478         paused = true;
479         emit Pause();
480     }
481 
482     /**
483     * @dev called by the owner to unpause, returns to normal state
484     */
485     function unpause() onlyOwner whenPaused public {
486         paused = false;
487         emit Unpause();
488     }
489 }
490 
491 library SafeMath {
492 
493   /**
494   * @dev Multiplies two numbers, throws on overflow.
495   */
496   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
497     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
498     // benefit is lost if 'b' is also tested.
499     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
500     if (a == 0) {
501       return 0;
502     }
503 
504     c = a * b;
505     assert(c / a == b);
506     return c;
507   }
508 
509   /**
510   * @dev Integer division of two numbers, truncating the quotient.
511   */
512   function div(uint256 a, uint256 b) internal pure returns (uint256) {
513     // assert(b > 0); // Solidity automatically throws when dividing by 0
514     // uint256 c = a / b;
515     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
516     return a / b;
517   }
518 
519   /**
520   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
521   */
522   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
523     assert(b <= a);
524     return a - b;
525   }
526 
527   /**
528   * @dev Adds two numbers, throws on overflow.
529   */
530   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
531     c = a + b;
532     assert(c >= a);
533     return c;
534   }
535 }
536 
537 library SafeMath64 {
538 
539   /**
540   * @dev Multiplies two numbers, throws on overflow.
541   */
542   function mul(uint64 a, uint64 b) internal pure returns (uint64 c) {
543     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
544     // benefit is lost if 'b' is also tested.
545     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
546     if (a == 0) {
547       return 0;
548     }
549 
550     c = a * b;
551     assert(c / a == b);
552     return c;
553   }
554 
555   /**
556   * @dev Integer division of two numbers, truncating the quotient.
557   */
558   function div(uint64 a, uint64 b) internal pure returns (uint64) {
559     // assert(b > 0); // Solidity automatically throws when dividing by 0
560     // uint64 c = a / b;
561     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
562     return a / b;
563   }
564 
565   /**
566   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
567   */
568   function sub(uint64 a, uint64 b) internal pure returns (uint64) {
569     assert(b <= a);
570     return a - b;
571   }
572 
573   /**
574   * @dev Adds two numbers, throws on overflow.
575   */
576   function add(uint64 a, uint64 b) internal pure returns (uint64 c) {
577     c = a + b;
578     assert(c >= a);
579     return c;
580   }
581 }
582 
583 contract AuctionPack is CardPackFour, Pausable {
584 
585     using SafeMath for uint;
586     // probably a better way to do this/don't need to do it at all
587     using SafeMath64 for uint64;
588 
589     mapping(address => uint) owed;
590 
591     event Created(uint indexed id, uint16 proto, uint16 purity, uint minBid, uint length);
592     event Opened(uint indexed id, uint64 start);
593     event Extended(uint indexed id, uint64 length);
594     event Bid(uint indexed id, address indexed bidder, uint value);
595     event Claimed(uint indexed id, uint indexed cardID, address indexed bidder, uint value, uint16 proto, uint16 purity);
596     event Bonus(uint indexed id, uint indexed cardID, address indexed bidder, uint16 proto, uint16 purity);
597 
598     enum Status {
599         Closed,
600         Open,
601         Claimed
602     }
603 
604     struct Auction {
605         Status status;
606         uint16 proto;
607         uint16 purity;
608         uint highestBid;
609         address highestBidder;
610         uint64 start;
611         uint64 length;
612         address beneficiary;
613         uint16 bonusProto;
614         uint16 bonusPurity;
615         uint64 bufferPeriod;
616         uint minIncreasePercent;
617     }
618 
619     Auction[] auctions;
620 
621     constructor(MigrationInterface _migration) public CardPackFour(_migration) {
622         
623     }
624 
625     function getAuction(uint id) public view returns (
626         Status status,
627         uint16 proto,
628         uint16 purity,
629         uint highestBid,
630         address highestBidder,
631         uint64 start,
632         uint64 length,
633         uint16 bonusProto,
634         uint16 bonusPurity,
635         uint64 bufferPeriod,
636         uint minIncreasePercent,
637         address beneficiary
638     ) {
639         require(auctions.length > id);
640         Auction memory a = auctions[id];
641         return (
642             a.status, a.proto, a.purity, a.highestBid, 
643             a.highestBidder, a.start, a.length, a.bonusProto, 
644             a.bonusPurity, a.bufferPeriod, a.minIncreasePercent, a.beneficiary
645         );
646     }
647 
648     function createAuction(
649         address beneficiary, uint16 proto, uint16 purity, 
650         uint minBid, uint64 length, uint16 bonusProto, uint16 bonusPurity,
651         uint64 bufferPeriod, uint minIncrease
652     ) public onlyOwner whenNotPaused returns (uint) {
653 
654         require(beneficiary != address(0));
655         require(minBid >= 100 wei);
656 
657         Auction memory auction = Auction({
658             status: Status.Closed,
659             proto: proto,
660             purity: purity,
661             highestBid: minBid,
662             highestBidder: address(0),
663             start: 0,
664             length: length,
665             beneficiary: beneficiary,
666             bonusProto: bonusProto,
667             bonusPurity: bonusPurity,
668             bufferPeriod: bufferPeriod,
669             minIncreasePercent: minIncrease
670         });
671 
672         uint id = auctions.push(auction) - 1;
673 
674         emit Created(id, proto, purity, minBid, length);
675 
676         return id;
677     }
678 
679     function openAuction(uint id) public onlyOwner {
680         Auction storage auction = auctions[id];
681         require(auction.status == Status.Closed);
682         auction.status = Status.Open;
683         auction.start = uint64(block.number);
684         emit Opened(id, auction.start);
685     }
686 
687     // dummy implementation to support interface
688     function purchase(uint16, address) public payable { 
689         
690     }
691 
692     function getMinBid(uint id) public view returns (uint) {
693 
694         Auction memory auction = auctions[id];
695 
696         uint highest = auction.highestBid;
697         
698         // calculate one percent of the number
699         // highest will always be >= 100
700         uint numerator = highest.div(100);
701 
702         // calculate the minimum increase required
703         uint minIncrease = numerator.mul(auction.minIncreasePercent);
704 
705         uint threshold = highest + minIncrease;
706 
707         return threshold;
708     }
709 
710     function bid(uint id) public payable {
711 
712         Auction storage auction = auctions[id];
713 
714         require(auction.status == Status.Open);
715 
716         uint64 end = auction.start.add(auction.length);
717 
718         require(end >= block.number);
719 
720         uint threshold = getMinBid(id);
721         
722         require(msg.value >= threshold);
723 
724         
725         // if within the buffer period of the auction
726         // extend to the buffer period of blocks
727 
728         uint64 differenceToEnd = end.sub(uint64(block.number));
729 
730         if (auction.bufferPeriod > differenceToEnd) {
731             
732             // extend the auction period to be at least the buffer period
733             uint64 toAdd = auction.bufferPeriod.sub(differenceToEnd);
734 
735             auction.length = auction.length.add(toAdd);
736 
737             emit Extended(id, auction.length);
738         }
739 
740         emit Bid(id, msg.sender, msg.value);
741 
742         if (auction.highestBidder != address(0)) {
743 
744             // let's just go with the safe option rather than using send(): probably fine but no loss
745             owed[auction.highestBidder] = owed[auction.highestBidder].add(auction.highestBid);
746 
747             // give the previous bidder their bonus/consolation card 
748             if (auction.bonusProto != 0) {
749                 uint cardID = migration.createCard(auction.highestBidder, auction.bonusProto, auction.bonusPurity);
750                 emit Bonus(id, cardID, auction.highestBidder, auction.bonusProto, auction.bonusPurity);
751             }
752         }
753 
754         auction.highestBid = msg.value;
755         auction.highestBidder = msg.sender;
756     }
757 
758     // anyone can claim the card/pay gas for them
759     function claim(uint id) public returns (uint) {
760 
761         Auction storage auction = auctions[id];
762 
763         uint64 end = auction.start.add(auction.length);
764 
765         require(block.number > end);
766 
767         require(auction.status == Status.Open);
768         
769         auction.status = Status.Claimed;
770 
771         uint cardID = migration.createCard(auction.highestBidder, auction.proto, auction.purity);
772 
773         emit Claimed(id, cardID, auction.highestBidder, auction.highestBid, auction.proto, auction.purity);
774 
775         // don't require this to be a trusted address
776         owed[auction.beneficiary] = owed[auction.beneficiary].add(auction.highestBid);
777 
778         return cardID;
779     }
780 
781     function withdraw(address user) public {
782         uint balance = owed[user];
783         require(balance > 0);
784         owed[user] = 0;
785         user.transfer(balance);
786     }
787 
788     function getOwed(address user) public view returns (uint) {
789         return owed[user];
790     }
791     
792 }