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
701 contract CardPackFour {
702 
703     MigrationInterface public migration;
704     uint public creationBlock;
705 
706     constructor(MigrationInterface _core) public payable {
707         migration = _core;
708         creationBlock = 5939061 + 2000; // set to creation block of first contracts + 8 hours for down time
709     }
710 
711     event Referral(address indexed referrer, uint value, address purchaser);
712 
713     /**
714     * purchase 'count' of this type of pack
715     */
716     function purchase(uint16 packCount, address referrer) public payable;
717 
718     // store purity and shine as one number to save users gas
719     function _getPurity(uint16 randOne, uint16 randTwo) internal pure returns (uint16) {
720         if (randOne >= 998) {
721             return 3000 + randTwo;
722         } else if (randOne >= 988) {
723             return 2000 + randTwo;
724         } else if (randOne >= 938) {
725             return 1000 + randTwo;
726         } else {
727             return randTwo;
728         }
729     }
730 
731 }
732 
733 contract FirstPheonix is Pausable {
734 
735     MigrationInterface core;
736 
737     constructor(MigrationInterface _core) public {
738         core = _core;
739     }
740 
741     address[] public approved;
742 
743     uint16 PHEONIX_PROTO = 380;
744 
745     mapping(address => bool) public claimed;
746 
747     function approvePack(address toApprove) public onlyOwner {
748         approved.push(toApprove);
749     }
750 
751     function isApproved(address test) public view returns (bool) {
752         for (uint i = 0; i < approved.length; i++) {
753             if (approved[i] == test) {
754                 return true;
755             }
756         }
757         return false;
758     }
759 
760     // pause once cards become tradable
761     function claimPheonix(address user) public returns (bool){
762 
763         require(isApproved(msg.sender));
764 
765         if (claimed[user] || paused){
766             return false;
767         }
768 
769         claimed[user] = true;
770 
771         core.createCard(user, PHEONIX_PROTO, 0);
772 
773         return true;
774     }
775 
776 }
777 
778 contract PresalePackFour is CardPackFour, Pausable {
779 
780     CappedVault public vault;
781 
782     Purchase[] public purchases;
783 
784     function getPurchaseCount() public view returns (uint) {
785         return purchases.length;
786     }
787 
788     struct Purchase {
789         uint16 current;
790         uint16 count;
791         address user;
792         uint randomness;
793         uint64 commit;
794     }
795 
796     event PacksPurchased(uint indexed id, address indexed user, uint16 count);
797     event PackOpened(uint indexed id, uint16 startIndex, address indexed user, uint[] cardIDs);
798     event RandomnessReceived(uint indexed id, address indexed user, uint16 count, uint randomness);
799     event Recommit(uint indexed id);
800 
801     constructor(MigrationInterface _core, CappedVault _vault) public payable CardPackFour(_core) {
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
812     uint16 public perClaim = 15;
813 
814     function setPacksPerClaim(uint16 _perClaim) public onlyOwner {
815         perClaim = _perClaim;
816     }
817 
818     function packsPerClaim() public view returns (uint16) {
819         return perClaim;
820     }
821 
822     // start in bytes, length in bytes
823     function extract(uint num, uint length, uint start) internal pure returns (uint) {
824         return (((1 << (length * 8)) - 1) & (num >> ((start * 8) - 1)));
825     }
826 
827     function purchaseFor(address user, uint16 packCount, address referrer) whenNotPaused public payable {
828         _purchase(user, packCount, referrer);
829     }
830 
831     function purchase(uint16 packCount, address referrer) whenNotPaused public payable {
832         _purchase(msg.sender, packCount, referrer);
833     }
834 
835     function _purchase(address user, uint16 packCount, address referrer) internal {
836         require(packCount > 0);
837         require(referrer != user);
838 
839         uint price = calculatePrice(basePrice(), packCount);
840 
841         require(msg.value >= price);
842 
843         Purchase memory p = Purchase({
844             user: user,
845             count: packCount,
846             commit: uint64(block.number),
847             randomness: 0,
848             current: 0
849         });
850 
851         uint id = purchases.push(p) - 1;
852 
853         emit PacksPurchased(id, user, packCount);
854 
855         if (referrer != address(0)) {
856             uint commission = price / 10;
857             referrer.transfer(commission);
858             price -= commission;
859             emit Referral(referrer, commission, user);
860         }
861         
862         address(vault).transfer(price);
863     }
864 
865     // can recommit
866     // this gives you more chances
867     // if no-one else sends the callback (should never happen)
868     // still only get a random extra chance
869     function recommit(uint id) public {
870 
871         Purchase storage p = purchases[id];
872 
873         require(p.randomness == 0);
874 
875         require(block.number >= p.commit + 256);
876 
877         p.commit = uint64(block.number);
878 
879         emit Recommit(id);
880     }
881 
882     // can be called by anybody
883     // can miners withhold blocks --> not really
884     // giving up block reward for extra chance --> still really low
885     function callback(uint id) public {
886 
887         Purchase storage p = purchases[id];
888 
889         require(p.randomness == 0);
890 
891         // must be within last 256 blocks, otherwise recommit
892         require(block.number - 256 < p.commit);
893 
894         // can't callback on the original block
895         require(uint64(block.number) != p.commit);
896 
897         bytes32 bhash = blockhash(p.commit);
898         // will get the same on every block
899         // only use properties which can't be altered by the user
900         uint random = uint(keccak256(abi.encodePacked(bhash, p.user, address(this), p.count)));
901 
902         require(uint(bhash) != 0);
903 
904         p.randomness = random;
905 
906         emit RandomnessReceived(id, p.user, p.count, p.randomness);
907     }
908 
909     function claim(uint id) public {
910         
911         Purchase storage p = purchases[id];
912 
913         require(canClaim);
914 
915         uint16 proto;
916         uint16 purity;
917         uint16 count = p.count;
918         uint result = p.randomness;
919         uint8 size = packSize();
920 
921         address user = p.user;
922         uint16 current = p.current;
923 
924         require(result != 0); // have to wait for the callback
925         // require(user == msg.sender); // not needed
926         require(count > 0);
927 
928         uint[] memory ids = new uint[](size);
929 
930         uint16 end = current + packsPerClaim() > count ? count : current + packsPerClaim();
931 
932         require(end > current);
933 
934         for (uint16 i = current; i < end; i++) {
935             for (uint8 j = 0; j < size; j++) {
936                 (proto, purity) = getCardDetails(i, j, result);
937                 ids[j] = migration.createCard(user, proto, purity);
938             }
939             emit PackOpened(id, (i * size), user, ids);
940         }
941         p.current += (end - current);
942     }
943 
944     function predictPacks(uint id) external view returns (uint16[] protos, uint16[] purities) {
945 
946         Purchase memory p = purchases[id];
947 
948         uint16 proto;
949         uint16 purity;
950         uint16 count = p.count;
951         uint result = p.randomness;
952         uint8 size = packSize();
953 
954         purities = new uint16[](size * count);
955         protos = new uint16[](size * count);
956 
957         for (uint16 i = 0; i < count; i++) {
958             for (uint8 j = 0; j < size; j++) {
959                 (proto, purity) = getCardDetails(i, j, result);
960                 purities[(i * size) + j] = purity;
961                 protos[(i * size) + j] = proto;
962             }
963         }
964         return (protos, purities);
965     }
966 
967     function calculatePrice(uint base, uint16 packCount) public view returns (uint) {
968         // roughly 6k blocks per day
969         uint difference = block.number - creationBlock;
970         uint numDays = difference / 6000;
971         if (20 > numDays) {
972             return (base - (((20 - numDays) * base) / 100)) * packCount;
973         }
974         return base * packCount;
975     }
976 
977     function _getCommonPlusRarity(uint32 rand) internal pure returns (CardProto.Rarity) {
978         if (rand == 999999) {
979             return CardProto.Rarity.Mythic;
980         } else if (rand >= 998345) {
981             return CardProto.Rarity.Legendary;
982         } else if (rand >= 986765) {
983             return CardProto.Rarity.Epic;
984         } else if (rand >= 924890) {
985             return CardProto.Rarity.Rare;
986         } else {
987             return CardProto.Rarity.Common;
988         }
989     }
990 
991     function _getRarePlusRarity(uint32 rand) internal pure returns (CardProto.Rarity) {
992         if (rand == 999999) {
993             return CardProto.Rarity.Mythic;
994         } else if (rand >= 981615) {
995             return CardProto.Rarity.Legendary;
996         } else if (rand >= 852940) {
997             return CardProto.Rarity.Epic;
998         } else {
999             return CardProto.Rarity.Rare;
1000         } 
1001     }
1002 
1003     function _getEpicPlusRarity(uint32 rand) internal pure returns (CardProto.Rarity) {
1004         if (rand == 999999) {
1005             return CardProto.Rarity.Mythic;
1006         } else if (rand >= 981615) {
1007             return CardProto.Rarity.Legendary;
1008         } else {
1009             return CardProto.Rarity.Epic;
1010         }
1011     }
1012 
1013     function _getLegendaryPlusRarity(uint32 rand) internal pure returns (CardProto.Rarity) {
1014         if (rand == 999999) {
1015             return CardProto.Rarity.Mythic;
1016         } else {
1017             return CardProto.Rarity.Legendary;
1018         } 
1019     }
1020 
1021     bool public canClaim = true;
1022 
1023     function setCanClaim(bool claim) public onlyOwner {
1024         canClaim = claim;
1025     }
1026 
1027     function getComponents(
1028         uint16 i, uint8 j, uint rand
1029     ) internal returns (
1030         uint random, uint32 rarityRandom, uint16 purityOne, uint16 purityTwo, uint16 protoRandom
1031     ) {
1032         random = uint(keccak256(abi.encodePacked(i, rand, j)));
1033         rarityRandom = uint32(extract(random, 4, 10) % 1000000);
1034         purityOne = uint16(extract(random, 2, 4) % 1000);
1035         purityTwo = uint16(extract(random, 2, 6) % 1000);
1036         protoRandom = uint16(extract(random, 2, 8) % (2**16-1));
1037         return (random, rarityRandom, purityOne, purityTwo, protoRandom);
1038     }
1039 
1040     function withdraw() public onlyOwner {
1041         owner.transfer(address(this).balance);
1042     }
1043 
1044 }
1045 
1046 contract PackFourMultiplier is PresalePackFour {
1047 
1048     address[] public packs;
1049     uint16 public multiplier = 3;
1050     FirstPheonix pheonix;
1051     PreviousInterface old;
1052 
1053     uint16 public packLimit = 5;
1054 
1055     constructor(PreviousInterface _old, address[] _packs, MigrationInterface _core, CappedVault vault, FirstPheonix _pheonix) 
1056         public PresalePackFour(_core, vault) 
1057     {
1058         packs = _packs;
1059         pheonix = _pheonix;
1060         old = _old;
1061     }
1062 
1063     function getCardCount() internal view returns (uint) {
1064         return old.totalSupply() + old.burnCount();
1065     }
1066 
1067     function isPriorPack(address test) public view returns(bool) {
1068         for (uint i = 0; i < packs.length; i++) {
1069             if (packs[i] == test) {
1070                 return true;
1071             }
1072         }
1073         return false;
1074     }
1075 
1076     event Status(uint before, uint aft);
1077 
1078     function claimMultiple(address pack, uint purchaseID) public returns (uint16, address) {
1079 
1080         require(isPriorPack(pack));
1081 
1082         uint length = getCardCount();
1083 
1084         PresalePackFour(pack).claim(purchaseID);
1085 
1086         uint lengthAfter = getCardCount();
1087 
1088         require(lengthAfter > length);
1089 
1090         uint16 cardDifference = uint16(lengthAfter - length);
1091 
1092         require(cardDifference % 5 == 0);
1093 
1094         uint16 packCount = cardDifference / 5;
1095 
1096         uint16 extra = packCount * multiplier;
1097 
1098         address lastCardOwner = old.ownerOf(lengthAfter - 1);
1099 
1100         Purchase memory p = Purchase({
1101             user: lastCardOwner,
1102             count: extra,
1103             commit: uint64(block.number),
1104             randomness: 0,
1105             current: 0
1106         });
1107 
1108         uint id = purchases.push(p) - 1;
1109 
1110         emit PacksPurchased(id, lastCardOwner, extra);
1111 
1112         // try to give them a first pheonix
1113         pheonix.claimPheonix(lastCardOwner);
1114 
1115         emit Status(length, lengthAfter);
1116 
1117 
1118         if (packCount <= packLimit) {
1119             for (uint i = 0; i < cardDifference; i++) {
1120                 migration.migrate(lengthAfter - 1 - i);
1121             }
1122         }
1123 
1124         return (extra, lastCardOwner);
1125     }
1126 
1127     function setPackLimit(uint16 limit) public onlyOwner {
1128         packLimit = limit;
1129     }
1130 
1131 
1132 }
1133 
1134 contract LegendaryPackFour is PackFourMultiplier {
1135     
1136     function basePrice() public returns (uint) {
1137         return 112 finney;
1138     }
1139 
1140     TournamentPass public tournament;
1141 
1142     constructor(PreviousInterface _old, address[] _packs, MigrationInterface _core, CappedVault vault, TournamentPass _tournament, FirstPheonix _pheonix) 
1143         public PackFourMultiplier(_old, _packs, _core, vault, _pheonix) {
1144         
1145         tournament = _tournament;
1146     }
1147 
1148     function purchase(uint16 packCount, address referrer) public payable {
1149         super.purchase(packCount, referrer);
1150         tournament.mint(msg.sender, packCount);
1151     }
1152 
1153     function claimMultiple(address pack, uint purchaseID) public returns (uint16, address) {
1154         uint16 extra;
1155         address user;
1156         (extra, user) = super.claimMultiple(pack, purchaseID);
1157         tournament.mint(user, extra);
1158     }
1159 
1160     function getCardDetails(uint16 packIndex, uint8 cardIndex, uint result) public view returns (uint16 proto, uint16 purity) {
1161         uint random;
1162         uint32 rarityRandom;
1163         uint16 protoRandom;
1164         uint16 purityOne;
1165         uint16 purityTwo;
1166 
1167         CardProto.Rarity rarity;
1168 
1169         (random, rarityRandom, purityOne, purityTwo, protoRandom) = getComponents(packIndex, cardIndex, result);
1170 
1171         if (cardIndex == 4) {
1172             rarity = _getLegendaryPlusRarity(rarityRandom);
1173         } else if (cardIndex == 3) {
1174             rarity = _getRarePlusRarity(rarityRandom);
1175         } else {
1176             rarity = _getCommonPlusRarity(rarityRandom);
1177         }
1178 
1179         purity = _getPurity(purityOne, purityTwo);
1180     
1181         proto = migration.getRandomCard(rarity, protoRandom);
1182 
1183         return (proto, purity);
1184     } 
1185     
1186 }