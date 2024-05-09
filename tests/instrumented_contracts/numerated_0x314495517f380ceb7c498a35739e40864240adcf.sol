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
42 contract ERC20 {
43 
44     event Approval(address indexed owner, address indexed spender, uint256 value);
45     event Transfer(address indexed from, address indexed to, uint256 value);
46     
47     function allowance(address owner, address spender) public view returns (uint256);
48     
49     function transferFrom(address from, address to, uint256 value) public returns (bool);
50 
51     function approve(address spender, uint256 value) public returns (bool);
52 
53     function totalSupply() public view returns (uint256);
54 
55     function balanceOf(address who) public view returns (uint256);
56     
57     function transfer(address to, uint256 value) public returns (bool);
58     
59 }
60 
61 library SafeMath {
62 
63   /**
64   * @dev Multiplies two numbers, throws on overflow.
65   */
66   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
67     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
68     // benefit is lost if 'b' is also tested.
69     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
70     if (a == 0) {
71       return 0;
72     }
73 
74     c = a * b;
75     assert(c / a == b);
76     return c;
77   }
78 
79   /**
80   * @dev Integer division of two numbers, truncating the quotient.
81   */
82   function div(uint256 a, uint256 b) internal pure returns (uint256) {
83     // assert(b > 0); // Solidity automatically throws when dividing by 0
84     // uint256 c = a / b;
85     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
86     return a / b;
87   }
88 
89   /**
90   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
91   */
92   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93     assert(b <= a);
94     return a - b;
95   }
96 
97   /**
98   * @dev Adds two numbers, throws on overflow.
99   */
100   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
101     c = a + b;
102     assert(c >= a);
103     return c;
104   }
105 }
106 
107 contract TournamentPass is ERC20, Ownable {
108 
109     using SafeMath for uint256;
110 
111     Vault vault;
112 
113     constructor(Vault _vault) public {
114         vault = _vault;
115     }
116 
117     mapping(address => uint256) balances;
118     mapping (address => mapping (address => uint256)) internal allowed;
119     address[] public minters;
120     uint256 supply;
121     uint mintLimit = 20000;
122     
123     function name() public view returns (string){
124         return "GU Tournament Passes";
125     }
126 
127     function symbol() public view returns (string) {
128         return "PASS";
129     }
130 
131     function addMinter(address minter) public onlyOwner {
132         minters.push(minter);
133     }
134 
135     function totalSupply() public view returns (uint256) {
136         return supply;
137     }
138 
139     function transfer(address _to, uint256 _value) public returns (bool) {
140         require(_to != address(0));
141         require(_value <= balances[msg.sender]);
142 
143         balances[msg.sender] = balances[msg.sender].sub(_value);
144         balances[_to] = balances[_to].add(_value);
145         emit Transfer(msg.sender, _to, _value);
146         return true;
147     }
148 
149     function balanceOf(address _owner) public view returns (uint256) {
150         return balances[_owner];
151     }
152 
153     function isMinter(address test) internal view returns (bool) {
154         for (uint i = 0; i < minters.length; i++) {
155             if (minters[i] == test) {
156                 return true;
157             }
158         }
159         return false;
160     }
161 
162     function mint(address to, uint amount) public returns (bool) {
163         require(isMinter(msg.sender));
164         if (amount.add(supply) > mintLimit) {
165             return false;
166         } 
167         supply = supply.add(amount);
168         balances[to] = balances[to].add(amount);
169         emit Transfer(address(0), to, amount);
170         return true;
171     }
172 
173     function approve(address _spender, uint256 _value) public returns (bool) {
174         allowed[msg.sender][_spender] = _value;
175         emit Approval(msg.sender, _spender, _value);
176         return true;
177     }
178 
179     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
180         require(_to != address(0));
181         require(_value <= balances[_from]);
182         require(_value <= allowed[_from][msg.sender]);
183 
184         balances[_from] = balances[_from].sub(_value);
185         balances[_to] = balances[_to].add(_value);
186         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
187         emit Transfer(_from, _to, _value);
188         return true;
189     }
190 
191     function increaseApproval(address spender, uint256 addedValue) public returns (bool) {
192         allowed[msg.sender][spender] = allowed[msg.sender][spender].add(addedValue);
193         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
194         return true;
195     }
196 
197     function decreaseApproval(address spender, uint256 subtractedValue) public returns (bool) {
198         uint256 oldValue = allowed[msg.sender][spender];
199         if (subtractedValue > oldValue) {
200             allowed[msg.sender][spender] = 0;
201         } else {
202             allowed[msg.sender][spender] = oldValue.sub(subtractedValue);
203         }
204         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
205         return true;
206     }
207 
208     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
209         return allowed[_owner][_spender];
210     }
211 
212     uint public price = 250 finney;
213 
214     function purchase(uint amount) public payable {
215         
216         require(msg.value >= price.mul(amount));
217         require(supply.add(amount) <= mintLimit);
218 
219         supply = supply.add(amount);
220         balances[msg.sender] = balances[msg.sender].add(amount);
221         emit Transfer(address(0), msg.sender, amount);
222 
223         address(vault).transfer(msg.value);
224     }
225 
226 }
227 
228 contract CappedVault is Vault { 
229 
230     uint public limit;
231     uint withdrawn = 0;
232 
233     constructor() public {
234         limit = 33333 ether;
235     }
236 
237     function () public payable {
238         require(total() + msg.value <= limit);
239     }
240 
241     function total() public view returns(uint) {
242         return getBalance() + withdrawn;
243     }
244 
245     function withdraw(uint amount) public onlyOwner {
246         require(address(this).balance >= amount);
247         owner.transfer(amount);
248         withdrawn += amount;
249     }
250 
251 }
252 
253 
254 contract PreviousInterface {
255 
256     function ownerOf(uint id) public view returns (address);
257 
258     function getCard(uint id) public view returns (uint16, uint16);
259 
260     function totalSupply() public view returns (uint);
261 
262     function burnCount() public view returns (uint);
263 
264 }
265 
266 contract Pausable is Ownable {
267     
268     event Pause();
269     event Unpause();
270 
271     bool public paused = false;
272 
273 
274     /**
275     * @dev Modifier to make a function callable only when the contract is not paused.
276     */
277     modifier whenNotPaused() {
278         require(!paused);
279         _;
280     }
281 
282     /**
283     * @dev Modifier to make a function callable only when the contract is paused.
284     */
285     modifier whenPaused() {
286         require(paused);
287         _;
288     }
289 
290     /**
291     * @dev called by the owner to pause, triggers stopped state
292     */
293     function pause() onlyOwner whenNotPaused public {
294         paused = true;
295         emit Pause();
296     }
297 
298     /**
299     * @dev called by the owner to unpause, returns to normal state
300     */
301     function unpause() onlyOwner whenPaused public {
302         paused = false;
303         emit Unpause();
304     }
305 }
306 
307 contract Governable {
308 
309     event Pause();
310     event Unpause();
311 
312     address public governor;
313     bool public paused = false;
314 
315     constructor() public {
316         governor = msg.sender;
317     }
318 
319     function setGovernor(address _gov) public onlyGovernor {
320         governor = _gov;
321     }
322 
323     modifier onlyGovernor {
324         require(msg.sender == governor);
325         _;
326     }
327 
328     /**
329     * @dev Modifier to make a function callable only when the contract is not paused.
330     */
331     modifier whenNotPaused() {
332         require(!paused);
333         _;
334     }
335 
336     /**
337     * @dev Modifier to make a function callable only when the contract is paused.
338     */
339     modifier whenPaused() {
340         require(paused);
341         _;
342     }
343 
344     /**
345     * @dev called by the owner to pause, triggers stopped state
346     */
347     function pause() onlyGovernor whenNotPaused public {
348         paused = true;
349         emit Pause();
350     }
351 
352     /**
353     * @dev called by the owner to unpause, returns to normal state
354     */
355     function unpause() onlyGovernor whenPaused public {
356         paused = false;
357         emit Unpause();
358     }
359 
360 }
361 
362 contract CardBase is Governable {
363 
364 
365     struct Card {
366         uint16 proto;
367         uint16 purity;
368     }
369 
370     function getCard(uint id) public view returns (uint16 proto, uint16 purity) {
371         Card memory card = cards[id];
372         return (card.proto, card.purity);
373     }
374 
375     function getShine(uint16 purity) public pure returns (uint8) {
376         return uint8(purity / 1000);
377     }
378 
379     Card[] public cards;
380     
381 }
382 
383 contract CardProto is CardBase {
384 
385     event NewProtoCard(
386         uint16 id, uint8 season, uint8 god, 
387         Rarity rarity, uint8 mana, uint8 attack, 
388         uint8 health, uint8 cardType, uint8 tribe, bool packable
389     );
390 
391     struct Limit {
392         uint64 limit;
393         bool exists;
394     }
395 
396     // limits for mythic cards
397     mapping(uint16 => Limit) public limits;
398 
399     // can only set limits once
400     function setLimit(uint16 id, uint64 limit) public onlyGovernor {
401         Limit memory l = limits[id];
402         require(!l.exists);
403         limits[id] = Limit({
404             limit: limit,
405             exists: true
406         });
407     }
408 
409     function getLimit(uint16 id) public view returns (uint64 limit, bool set) {
410         Limit memory l = limits[id];
411         return (l.limit, l.exists);
412     }
413 
414     // could make these arrays to save gas
415     // not really necessary - will be update a very limited no of times
416     mapping(uint8 => bool) public seasonTradable;
417     mapping(uint8 => bool) public seasonTradabilityLocked;
418     uint8 public currentSeason;
419 
420     function makeTradable(uint8 season) public onlyGovernor {
421         seasonTradable[season] = true;
422     }
423 
424     function makeUntradable(uint8 season) public onlyGovernor {
425         require(!seasonTradabilityLocked[season]);
426         seasonTradable[season] = false;
427     }
428 
429     function makePermanantlyTradable(uint8 season) public onlyGovernor {
430         require(seasonTradable[season]);
431         seasonTradabilityLocked[season] = true;
432     }
433 
434     function isTradable(uint16 proto) public view returns (bool) {
435         return seasonTradable[protos[proto].season];
436     }
437 
438     function nextSeason() public onlyGovernor {
439         //Seasons shouldn't go to 0 if there is more than the uint8 should hold, the governor should know this ¯\_(ツ)_/¯ -M
440         require(currentSeason <= 255); 
441 
442         currentSeason++;
443         mythic.length = 0;
444         legendary.length = 0;
445         epic.length = 0;
446         rare.length = 0;
447         common.length = 0;
448     }
449 
450     enum Rarity {
451         Common,
452         Rare,
453         Epic,
454         Legendary, 
455         Mythic
456     }
457 
458     uint8 constant SPELL = 1;
459     uint8 constant MINION = 2;
460     uint8 constant WEAPON = 3;
461     uint8 constant HERO = 4;
462 
463     struct ProtoCard {
464         bool exists;
465         uint8 god;
466         uint8 season;
467         uint8 cardType;
468         Rarity rarity;
469         uint8 mana;
470         uint8 attack;
471         uint8 health;
472         uint8 tribe;
473     }
474 
475     // there is a particular design decision driving this:
476     // need to be able to iterate over mythics only for card generation
477     // don't store 5 different arrays: have to use 2 ids
478     // better to bear this cost (2 bytes per proto card)
479     // rather than 1 byte per instance
480 
481     uint16 public protoCount;
482     
483     mapping(uint16 => ProtoCard) protos;
484 
485     uint16[] public mythic;
486     uint16[] public legendary;
487     uint16[] public epic;
488     uint16[] public rare;
489     uint16[] public common;
490 
491     function addProtos(
492         uint16[] externalIDs, uint8[] gods, Rarity[] rarities, uint8[] manas, uint8[] attacks, 
493         uint8[] healths, uint8[] cardTypes, uint8[] tribes, bool[] packable
494     ) public onlyGovernor returns(uint16) {
495 
496         for (uint i = 0; i < externalIDs.length; i++) {
497 
498             ProtoCard memory card = ProtoCard({
499                 exists: true,
500                 god: gods[i],
501                 season: currentSeason,
502                 cardType: cardTypes[i],
503                 rarity: rarities[i],
504                 mana: manas[i],
505                 attack: attacks[i],
506                 health: healths[i],
507                 tribe: tribes[i]
508             });
509 
510             _addProto(externalIDs[i], card, packable[i]);
511         }
512         
513     }
514 
515     function addProto(
516         uint16 externalID, uint8 god, Rarity rarity, uint8 mana, uint8 attack, uint8 health, uint8 cardType, uint8 tribe, bool packable
517     ) public onlyGovernor returns(uint16) {
518         ProtoCard memory card = ProtoCard({
519             exists: true,
520             god: god,
521             season: currentSeason,
522             cardType: cardType,
523             rarity: rarity,
524             mana: mana,
525             attack: attack,
526             health: health,
527             tribe: tribe
528         });
529 
530         _addProto(externalID, card, packable);
531     }
532 
533     function addWeapon(
534         uint16 externalID, uint8 god, Rarity rarity, uint8 mana, uint8 attack, uint8 durability, bool packable
535     ) public onlyGovernor returns(uint16) {
536 
537         ProtoCard memory card = ProtoCard({
538             exists: true,
539             god: god,
540             season: currentSeason,
541             cardType: WEAPON,
542             rarity: rarity,
543             mana: mana,
544             attack: attack,
545             health: durability,
546             tribe: 0
547         });
548 
549         _addProto(externalID, card, packable);
550     }
551 
552     function addSpell(uint16 externalID, uint8 god, Rarity rarity, uint8 mana, bool packable) public onlyGovernor returns(uint16) {
553 
554         ProtoCard memory card = ProtoCard({
555             exists: true,
556             god: god,
557             season: currentSeason,
558             cardType: SPELL,
559             rarity: rarity,
560             mana: mana,
561             attack: 0,
562             health: 0,
563             tribe: 0
564         });
565 
566         _addProto(externalID, card, packable);
567     }
568 
569     function addMinion(
570         uint16 externalID, uint8 god, Rarity rarity, uint8 mana, uint8 attack, uint8 health, uint8 tribe, bool packable
571     ) public onlyGovernor returns(uint16) {
572 
573         ProtoCard memory card = ProtoCard({
574             exists: true,
575             god: god,
576             season: currentSeason,
577             cardType: MINION,
578             rarity: rarity,
579             mana: mana,
580             attack: attack,
581             health: health,
582             tribe: tribe
583         });
584 
585         _addProto(externalID, card, packable);
586     }
587 
588     function _addProto(uint16 externalID, ProtoCard memory card, bool packable) internal {
589 
590         require(!protos[externalID].exists);
591 
592         card.exists = true;
593 
594         protos[externalID] = card;
595 
596         protoCount++;
597 
598         emit NewProtoCard(
599             externalID, currentSeason, card.god, 
600             card.rarity, card.mana, card.attack, 
601             card.health, card.cardType, card.tribe, packable
602         );
603 
604         if (packable) {
605             Rarity rarity = card.rarity;
606             if (rarity == Rarity.Common) {
607                 common.push(externalID);
608             } else if (rarity == Rarity.Rare) {
609                 rare.push(externalID);
610             } else if (rarity == Rarity.Epic) {
611                 epic.push(externalID);
612             } else if (rarity == Rarity.Legendary) {
613                 legendary.push(externalID);
614             } else if (rarity == Rarity.Mythic) {
615                 mythic.push(externalID);
616             } else {
617                 require(false);
618             }
619         }
620     }
621 
622     function getProto(uint16 id) public view returns(
623         bool exists, uint8 god, uint8 season, uint8 cardType, Rarity rarity, uint8 mana, uint8 attack, uint8 health, uint8 tribe
624     ) {
625         ProtoCard memory proto = protos[id];
626         return (
627             proto.exists,
628             proto.god,
629             proto.season,
630             proto.cardType,
631             proto.rarity,
632             proto.mana,
633             proto.attack,
634             proto.health,
635             proto.tribe
636         );
637     }
638 
639     function getRandomCard(Rarity rarity, uint16 random) public view returns (uint16) {
640         // modulo bias is fine - creates rarity tiers etc
641         // will obviously revert is there are no cards of that type: this is expected - should never happen
642         if (rarity == Rarity.Common) {
643             return common[random % common.length];
644         } else if (rarity == Rarity.Rare) {
645             return rare[random % rare.length];
646         } else if (rarity == Rarity.Epic) {
647             return epic[random % epic.length];
648         } else if (rarity == Rarity.Legendary) {
649             return legendary[random % legendary.length];
650         } else if (rarity == Rarity.Mythic) {
651             // make sure a mythic is available
652             uint16 id;
653             uint64 limit;
654             bool set;
655             for (uint i = 0; i < mythic.length; i++) {
656                 id = mythic[(random + i) % mythic.length];
657                 (limit, set) = getLimit(id);
658                 if (set && limit > 0){
659                     return id;
660                 }
661             }
662             // if not, they get a legendary :(
663             return legendary[random % legendary.length];
664         }
665         require(false);
666         return 0;
667     }
668 
669     // can never adjust tradable cards
670     // each season gets a 'balancing beta'
671     // totally immutable: season, rarity
672     function replaceProto(
673         uint16 index, uint8 god, uint8 cardType, uint8 mana, uint8 attack, uint8 health, uint8 tribe
674     ) public onlyGovernor {
675         ProtoCard memory pc = protos[index];
676         require(!seasonTradable[pc.season]);
677         protos[index] = ProtoCard({
678             exists: true,
679             god: god,
680             season: pc.season,
681             cardType: cardType,
682             rarity: pc.rarity,
683             mana: mana,
684             attack: attack,
685             health: health,
686             tribe: tribe
687         });
688     }
689 
690 }
691 
692 contract MigrationInterface {
693 
694     function createCard(address user, uint16 proto, uint16 purity) public returns (uint);
695 
696     function getRandomCard(CardProto.Rarity rarity, uint16 random) public view returns (uint16);
697 
698     function migrate(uint id) public;
699 
700 }
701 
702 contract CardPackThree {
703 
704     MigrationInterface public migration;
705     uint public creationBlock;
706 
707     constructor(MigrationInterface _core) public payable {
708         migration = _core;
709         creationBlock = 5939061 + 2000; // set to creation block of first contracts + 8 hours for down time
710     }
711 
712     event Referral(address indexed referrer, uint value, address purchaser);
713 
714     /**
715     * purchase 'count' of this type of pack
716     */
717     function purchase(uint16 packCount, address referrer) public payable;
718 
719     // store purity and shine as one number to save users gas
720     function _getPurity(uint16 randOne, uint16 randTwo) internal pure returns (uint16) {
721         if (randOne >= 998) {
722             return 3000 + randTwo;
723         } else if (randOne >= 988) {
724             return 2000 + randTwo;
725         } else if (randOne >= 938) {
726             return 1000 + randTwo;
727         } else {
728             return randTwo;
729         }
730     }
731 
732 }
733 
734 contract FirstPheonix is Pausable {
735 
736     MigrationInterface core;
737 
738     constructor(MigrationInterface _core) public {
739         core = _core;
740     }
741 
742     address[] public approved;
743 
744     uint16 PHEONIX_PROTO = 380;
745 
746     mapping(address => bool) public claimed;
747 
748     function approvePack(address toApprove) public onlyOwner {
749         approved.push(toApprove);
750     }
751 
752     function isApproved(address test) public view returns (bool) {
753         for (uint i = 0; i < approved.length; i++) {
754             if (approved[i] == test) {
755                 return true;
756             }
757         }
758         return false;
759     }
760 
761     // pause once cards become tradable
762     function claimPheonix(address user) public returns (bool){
763 
764         require(isApproved(msg.sender));
765 
766         if (claimed[user] || paused){
767             return false;
768         }
769 
770         claimed[user] = true;
771 
772         core.createCard(user, PHEONIX_PROTO, 0);
773 
774         return true;
775     }
776 
777 }
778 
779 contract PresalePackThree is CardPackThree, Pausable {
780 
781     CappedVault public vault;
782 
783     Purchase[] public purchases;
784 
785     function getPurchaseCount() public view returns (uint) {
786         return purchases.length;
787     }
788 
789     struct Purchase {
790         uint16 current;
791         uint16 count;
792         address user;
793         uint randomness;
794         uint64 commit;
795     }
796 
797     event PacksPurchased(uint indexed id, address indexed user, uint16 count);
798     event PackOpened(uint indexed id, uint16 startIndex, address indexed user, uint[] cardIDs);
799     event RandomnessReceived(uint indexed id, address indexed user, uint16 count, uint randomness);
800 
801     constructor(MigrationInterface _core, CappedVault _vault) public payable CardPackThree(_core) {
802         vault = _vault;
803     }
804 
805     function basePrice() public returns (uint);
806     function getCardDetails(uint16 packIndex, uint8 cardIndex, uint result) public view returns (uint16 proto, uint16 purity);
807     
808     function packSize() public view returns (uint8) {
809         return 5;
810     }
811 
812     function packsPerClaim() public view returns (uint16) {
813         return 15;
814     }
815 
816     // start in bytes, length in bytes
817     function extract(uint num, uint length, uint start) internal pure returns (uint) {
818         return (((1 << (length * 8)) - 1) & (num >> ((start * 8) - 1)));
819     }
820 
821     function purchase(uint16 packCount, address referrer) whenNotPaused public payable {
822 
823         require(packCount > 0);
824         require(referrer != msg.sender);
825 
826         uint price = calculatePrice(basePrice(), packCount);
827 
828         require(msg.value >= price);
829 
830         Purchase memory p = Purchase({
831             user: msg.sender,
832             count: packCount,
833             commit: uint64(block.number),
834             randomness: 0,
835             current: 0
836         });
837 
838         uint id = purchases.push(p) - 1;
839 
840         emit PacksPurchased(id, msg.sender, packCount);
841 
842         if (referrer != address(0)) {
843             uint commission = price / 10;
844             referrer.transfer(commission);
845             price -= commission;
846             emit Referral(referrer, commission, msg.sender);
847         }
848         
849         address(vault).transfer(price); 
850     }
851 
852     // can be called by anybody
853     // can miners withhold blocks --> not really
854     // giving up block reward for extra chance --> still really low
855     function callback(uint id) public {
856 
857         Purchase storage p = purchases[id];
858 
859         require(p.randomness == 0);
860 
861         bytes32 bhash = blockhash(p.commit);
862         // will get the same on every block
863         // only use properties which can't be altered by the user
864         uint random = uint(keccak256(abi.encodePacked(bhash, p.user, address(this), p.count)));
865 
866         // can't callback on the original block
867         require(uint64(block.number) != p.commit);
868 
869         if (uint(bhash) == 0) {
870             // should never happen (must call within next 256 blocks)
871             // if it does, just give them 1: will become common and therefore less valuable
872             // set to 1 rather than 0 to avoid calling claim before randomness
873             p.randomness = 1;
874         } else {
875             p.randomness = random;
876         }
877 
878         emit RandomnessReceived(id, p.user, p.count, p.randomness);
879     }
880 
881     function claim(uint id) public {
882         
883         Purchase storage p = purchases[id];
884 
885         require(canClaim);
886 
887         uint16 proto;
888         uint16 purity;
889         uint16 count = p.count;
890         uint result = p.randomness;
891         uint8 size = packSize();
892 
893         address user = p.user;
894         uint16 current = p.current;
895 
896         require(result != 0); // have to wait for the callback
897         // require(user == msg.sender); // not needed
898         require(count > 0);
899 
900         uint[] memory ids = new uint[](size);
901 
902         uint16 end = current + packsPerClaim() > count ? count : current + packsPerClaim();
903 
904         require(end > current);
905 
906         for (uint16 i = current; i < end; i++) {
907             for (uint8 j = 0; j < size; j++) {
908                 (proto, purity) = getCardDetails(i, j, result);
909                 ids[j] = migration.createCard(user, proto, purity);
910             }
911             emit PackOpened(id, (i * size), user, ids);
912         }
913         p.current += (end - current);
914     }
915 
916     function predictPacks(uint id) external view returns (uint16[] protos, uint16[] purities) {
917 
918         Purchase memory p = purchases[id];
919 
920         uint16 proto;
921         uint16 purity;
922         uint16 count = p.count;
923         uint result = p.randomness;
924         uint8 size = packSize();
925 
926         purities = new uint16[](size * count);
927         protos = new uint16[](size * count);
928 
929         for (uint16 i = 0; i < count; i++) {
930             for (uint8 j = 0; j < size; j++) {
931                 (proto, purity) = getCardDetails(i, j, result);
932                 purities[(i * size) + j] = purity;
933                 protos[(i * size) + j] = proto;
934             }
935         }
936         return (protos, purities);
937     }
938 
939     function calculatePrice(uint base, uint16 packCount) public view returns (uint) {
940         // roughly 6k blocks per day
941         uint difference = block.number - creationBlock;
942         uint numDays = difference / 6000;
943         if (20 > numDays) {
944             return (base - (((20 - numDays) * base) / 100)) * packCount;
945         }
946         return base * packCount;
947     }
948 
949     function _getCommonPlusRarity(uint32 rand) internal pure returns (CardProto.Rarity) {
950         if (rand == 999999) {
951             return CardProto.Rarity.Mythic;
952         } else if (rand >= 998345) {
953             return CardProto.Rarity.Legendary;
954         } else if (rand >= 986765) {
955             return CardProto.Rarity.Epic;
956         } else if (rand >= 924890) {
957             return CardProto.Rarity.Rare;
958         } else {
959             return CardProto.Rarity.Common;
960         }
961     }
962 
963     function _getRarePlusRarity(uint32 rand) internal pure returns (CardProto.Rarity) {
964         if (rand == 999999) {
965             return CardProto.Rarity.Mythic;
966         } else if (rand >= 981615) {
967             return CardProto.Rarity.Legendary;
968         } else if (rand >= 852940) {
969             return CardProto.Rarity.Epic;
970         } else {
971             return CardProto.Rarity.Rare;
972         } 
973     }
974 
975     function _getEpicPlusRarity(uint32 rand) internal pure returns (CardProto.Rarity) {
976         if (rand == 999999) {
977             return CardProto.Rarity.Mythic;
978         } else if (rand >= 981615) {
979             return CardProto.Rarity.Legendary;
980         } else {
981             return CardProto.Rarity.Epic;
982         }
983     }
984 
985     function _getLegendaryPlusRarity(uint32 rand) internal pure returns (CardProto.Rarity) {
986         if (rand == 999999) {
987             return CardProto.Rarity.Mythic;
988         } else {
989             return CardProto.Rarity.Legendary;
990         } 
991     }
992 
993     bool public canClaim = true;
994 
995     function setCanClaim(bool claim) public onlyOwner {
996         canClaim = claim;
997     }
998 
999     function getComponents(
1000         uint16 i, uint8 j, uint rand
1001     ) internal returns (
1002         uint random, uint32 rarityRandom, uint16 purityOne, uint16 purityTwo, uint16 protoRandom
1003     ) {
1004         random = uint(keccak256(abi.encodePacked(i, rand, j)));
1005         rarityRandom = uint32(extract(random, 4, 10) % 1000000);
1006         purityOne = uint16(extract(random, 2, 4) % 1000);
1007         purityTwo = uint16(extract(random, 2, 6) % 1000);
1008         protoRandom = uint16(extract(random, 2, 8) % (2**16-1));
1009         return (random, rarityRandom, purityOne, purityTwo, protoRandom);
1010     }
1011 
1012     function withdraw() public onlyOwner {
1013         owner.transfer(address(this).balance);
1014     }
1015 
1016 }
1017 
1018 contract PackMultiplier is PresalePackThree {
1019 
1020     address[] public packs;
1021     uint16 public multiplier = 3;
1022     FirstPheonix pheonix;
1023     PreviousInterface old;
1024 
1025     uint16 public packLimit = 5;
1026 
1027     constructor(PreviousInterface _old, address[] _packs, MigrationInterface _core, CappedVault vault, FirstPheonix _pheonix) 
1028         public PresalePackThree(_core, vault) 
1029     {
1030         packs = _packs;
1031         pheonix = _pheonix;
1032         old = _old;
1033     }
1034 
1035     function getCardCount() internal view returns (uint) {
1036         return old.totalSupply() + old.burnCount();
1037     }
1038 
1039     function isPriorPack(address test) public view returns(bool) {
1040         for (uint i = 0; i < packs.length; i++) {
1041             if (packs[i] == test) {
1042                 return true;
1043             }
1044         }
1045         return false;
1046     }
1047 
1048     event Status(uint before, uint aft);
1049 
1050     function claimMultiple(address pack, uint purchaseID) public returns (uint16, address) {
1051 
1052         require(isPriorPack(pack));
1053 
1054         uint length = getCardCount();
1055 
1056         PresalePackThree(pack).claim(purchaseID);
1057 
1058         uint lengthAfter = getCardCount();
1059 
1060         require(lengthAfter > length);
1061 
1062         uint16 cardDifference = uint16(lengthAfter - length);
1063 
1064         require(cardDifference % 5 == 0);
1065 
1066         uint16 packCount = cardDifference / 5;
1067 
1068         uint16 extra = packCount * multiplier;
1069 
1070         address lastCardOwner = old.ownerOf(lengthAfter - 1);
1071 
1072         Purchase memory p = Purchase({
1073             user: lastCardOwner,
1074             count: extra,
1075             commit: uint64(block.number),
1076             randomness: 0,
1077             current: 0
1078         });
1079 
1080         uint id = purchases.push(p) - 1;
1081 
1082         emit PacksPurchased(id, lastCardOwner, extra);
1083 
1084         // try to give them a first pheonix
1085         pheonix.claimPheonix(lastCardOwner);
1086 
1087         emit Status(length, lengthAfter);
1088 
1089 
1090         if (packCount <= packLimit) {
1091             for (uint i = 0; i < cardDifference; i++) {
1092                 migration.migrate(lengthAfter - 1 - i);
1093             }
1094         }
1095 
1096         return (extra, lastCardOwner);
1097     }
1098 
1099     function setPackLimit(uint16 limit) public onlyOwner {
1100         packLimit = limit;
1101     }
1102 
1103 
1104 }
1105 
1106 contract ShinyLegendaryPackThree is PackMultiplier {
1107     
1108     function basePrice() public returns (uint) {
1109         return 1 ether;
1110     }
1111 
1112     TournamentPass public tournament;
1113 
1114     constructor(PreviousInterface _old, address[] _packs, MigrationInterface _core, CappedVault vault, TournamentPass _tournament, FirstPheonix _pheonix) 
1115         public PackMultiplier(_old, _packs, _core, vault, _pheonix) {
1116         
1117         tournament = _tournament;
1118     }
1119     
1120 
1121     function claimMultiple(address pack, uint purchaseID) public returns (uint16, address) {
1122         uint16 extra;
1123         address user;
1124         (extra, user) = super.claimMultiple(pack, purchaseID);
1125         tournament.mint(user, extra);
1126     }
1127 
1128     function getCardDetails(uint16 packIndex, uint8 cardIndex, uint result) public view returns (uint16 proto, uint16 purity) {
1129         uint random;
1130         uint32 rarityRandom;
1131         uint16 protoRandom;
1132         uint16 purityOne;
1133         uint16 purityTwo;
1134         CardProto.Rarity rarity;
1135 
1136         (random, rarityRandom, purityOne, purityTwo, protoRandom) = getComponents(packIndex, cardIndex, result);
1137 
1138         if (cardIndex == 4) {
1139             rarity = _getLegendaryPlusRarity(rarityRandom);
1140             purity = _getShinyPurity(purityOne, purityTwo);
1141         } else if (cardIndex == 3) {
1142             rarity = _getRarePlusRarity(rarityRandom);
1143             purity = _getPurity(purityOne, purityTwo);
1144         } else {
1145             rarity = _getCommonPlusRarity(rarityRandom);
1146             purity = _getPurity(purityOne, purityTwo);
1147         }
1148     
1149         proto = migration.getRandomCard(rarity, protoRandom);
1150 
1151         return (proto, purity);
1152     } 
1153 
1154     function _getShinyPurity(uint16 randOne, uint16 randTwo) public pure returns (uint16) {
1155         if (randOne >= 998) {
1156             return 3000 + randTwo;
1157         } else if (randOne >= 748) {
1158             return 2000 + randTwo;
1159         } else {
1160             return 1000 + randTwo;
1161         }
1162     }
1163     
1164 }