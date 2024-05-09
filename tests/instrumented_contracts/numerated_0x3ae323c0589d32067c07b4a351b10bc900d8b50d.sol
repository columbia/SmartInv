1 pragma solidity ^0.5.0;
2 
3 interface IProcessor {
4 
5     function processPayment(address user, uint cost, uint items, address referrer) external payable returns (uint id);
6     
7 }
8 
9 contract Pack {
10 
11     enum Type {
12         Rare, Epic, Legendary, Shiny
13     }
14 
15 }
16 
17 contract Ownable {
18 
19     address payable public owner;
20 
21     constructor() public {
22         owner = msg.sender;
23     }
24 
25     function setOwner(address payable _owner) public onlyOwner {
26         owner = _owner;
27     }
28 
29     function getOwner() public view returns (address payable) {
30         return owner;
31     }
32 
33     modifier onlyOwner {
34         require(msg.sender == owner, "must be owner to call this function");
35         _;
36     }
37 
38 }
39 
40 // from OZ
41 
42 /**
43  * @title SafeMath
44  * @dev Math operations with safety checks that throw on error
45  */
46 library SafeMath {
47 
48     /**
49     * @dev Multiplies two numbers, throws on overflow.
50     */
51     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
52         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
53         // benefit is lost if 'b' is also tested.
54         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
55         if (a == 0) {
56             return 0;
57         }
58 
59         c = a * b;
60         assert(c / a == b);
61         return c;
62     }
63 
64     /**
65     * @dev Integer division of two numbers, truncating the quotient.
66     */
67     function div(uint256 a, uint256 b) internal pure returns (uint256) {
68         // assert(b > 0); // Solidity automatically throws when dividing by 0
69         // uint256 c = a / b;
70         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
71         return a / b;
72     }
73 
74     /**
75     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
76     */
77     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78         assert(b <= a);
79         return a - b;
80     }
81 
82     /**
83     * @dev Adds two numbers, throws on overflow.
84     */
85     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
86         c = a + b;
87         assert(c >= a);
88         return c;
89     }
90 }
91 
92 // from OZ
93 
94 /**
95  * @title SafeMath
96  * @dev Math operations with safety checks that throw on error
97  */
98 library SafeMath64 {
99 
100     /**
101     * @dev Multiplies two numbers, throws on overflow.
102     */
103     function mul(uint64 a, uint64 b) internal pure returns (uint64 c) {
104         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
105         // benefit is lost if 'b' is also tested.
106         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
107         if (a == 0) {
108             return 0;
109         }
110 
111         c = a * b;
112         assert(c / a == b);
113         return c;
114     }
115 
116     /**
117     * @dev Integer division of two numbers, truncating the quotient.
118     */
119     function div(uint64 a, uint64 b) internal pure returns (uint64) {
120         // assert(b > 0); // Solidity automatically throws when dividing by 0
121         // uint64 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123         return a / b;
124     }
125 
126     /**
127     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
128     */
129     function sub(uint64 a, uint64 b) internal pure returns (uint64) {
130         assert(b <= a);
131         return a - b;
132     }
133 
134     /**
135     * @dev Adds two numbers, throws on overflow.
136     */
137     function add(uint64 a, uint64 b) internal pure returns (uint64 c) {
138         c = a + b;
139         assert(c >= a);
140         return c;
141     }
142 }
143 
144 contract ICards {
145 
146     enum Rarity {
147         Common, Rare, Epic, Legendary, Mythic
148     }
149 
150     function getRandomCard(Rarity rarity, uint16 random) public view returns (uint16);
151     function createCard(address user, uint16 proto, uint16 purity) public returns (uint);
152 
153 
154 }
155 
156 
157 contract RarityProvider {
158 
159     ICards cards;
160 
161     constructor(ICards _cards) public {
162         cards = _cards;
163     }
164 
165     struct RandomnessComponents {
166         uint random;
167         uint32 rarity;
168         uint16 quality;
169         uint16 purity;
170         uint16 proto;
171     }
172 
173     // return 'length' bytes of 'num' starting at 'start'
174     function extract(uint num, uint length, uint start) internal pure returns (uint) {
175         return (((1 << (length * 8)) - 1) & (num >> ((start - 1) * 8)));
176     }
177 
178     // divides the random seed into components
179     function getComponents(
180         uint cardIndex, uint rand
181     ) internal pure returns (
182         RandomnessComponents memory
183     ) {
184         uint random = uint(keccak256(abi.encodePacked(cardIndex, rand)));
185         return RandomnessComponents({
186             random: random,
187             rarity: uint32(extract(random, 4, 10) % 1000000),
188             quality: uint16(extract(random, 2, 4) % 1000),
189             purity: uint16(extract(random, 2, 6) % 1000),
190             proto: uint16(extract(random, 2, 8) % (2**16-1))
191         });
192     }
193 
194     function getCardDetails(Pack.Type packType, uint cardIndex, uint result) internal view returns (uint16, uint16) {
195         if (packType == Pack.Type.Shiny) {
196             return _getShinyCardDetails(cardIndex, result);
197         } else if (packType == Pack.Type.Legendary) {
198             return _getLegendaryCardDetails(cardIndex, result);
199         } else if (packType == Pack.Type.Epic) {
200             return _getEpicCardDetails(cardIndex, result);
201         }
202         return _getRareCardDetails(cardIndex, result);
203     }
204 
205     function _getShinyCardDetails(uint cardIndex, uint result) internal view returns (uint16 proto, uint16 purity) {
206         
207         RandomnessComponents memory rc = getComponents(cardIndex, result); 
208 
209         ICards.Rarity rarity;
210 
211         if (cardIndex % 5 == 0) {
212             rarity = _getLegendaryPlusRarity(rc.rarity);
213             purity = _getShinyPurityBase(rc.quality) + rc.purity;
214         } else if (cardIndex % 5 == 1) {
215             rarity = _getRarePlusRarity(rc.rarity);
216             purity = _getPurityBase(rc.quality) + rc.purity;
217         } else {
218             rarity = _getCommonPlusRarity(rc.rarity);
219             purity = _getPurityBase(rc.quality) + rc.purity;
220         }
221         proto = cards.getRandomCard(rarity, rc.proto);
222         return (proto, purity);
223     }
224 
225     function _getLegendaryCardDetails(uint cardIndex, uint result) internal view returns (uint16 proto, uint16 purity) {
226         
227         RandomnessComponents memory rc = getComponents(cardIndex, result);
228 
229         ICards.Rarity rarity;
230 
231         if (cardIndex % 5 == 0) {
232             rarity = _getLegendaryPlusRarity(rc.rarity);
233         } else if (cardIndex % 5 == 1) {
234             rarity = _getRarePlusRarity(rc.rarity);
235         } else {
236             rarity = _getCommonPlusRarity(rc.rarity);
237         }
238 
239         purity = _getPurityBase(rc.quality) + rc.purity;
240     
241         proto = cards.getRandomCard(rarity, rc.proto);
242 
243         return (proto, purity);
244     }
245 
246 
247     function _getEpicCardDetails(uint cardIndex, uint result) internal view returns (uint16 proto, uint16 purity) {
248         
249         RandomnessComponents memory rc = getComponents(cardIndex, result);
250 
251         ICards.Rarity rarity;
252 
253         if (cardIndex % 5 == 0) {
254             rarity = _getEpicPlusRarity(rc.rarity);
255         } else {
256             rarity = _getCommonPlusRarity(rc.rarity);
257         }
258 
259         purity = _getPurityBase(rc.quality) + rc.purity;
260     
261         proto = cards.getRandomCard(rarity, rc.proto);
262 
263         return (proto, purity);
264     } 
265 
266     function _getRareCardDetails(uint cardIndex, uint result) internal view returns (uint16 proto, uint16 purity) {
267 
268         RandomnessComponents memory rc = getComponents(cardIndex, result);
269 
270         ICards.Rarity rarity;
271 
272         if (cardIndex % 5 == 0) {
273             rarity = _getRarePlusRarity(rc.rarity);
274         } else {
275             rarity = _getCommonPlusRarity(rc.rarity);
276         }
277 
278         purity = _getPurityBase(rc.quality) + rc.purity;
279     
280         proto = cards.getRandomCard(rarity, rc.proto);
281         return (proto, purity);
282     }  
283 
284 
285     function _getCommonPlusRarity(uint32 rand) internal pure returns (ICards.Rarity) {
286         if (rand == 999999) {
287             return ICards.Rarity.Mythic;
288         } else if (rand >= 998345) {
289             return ICards.Rarity.Legendary;
290         } else if (rand >= 986765) {
291             return ICards.Rarity.Epic;
292         } else if (rand >= 924890) {
293             return ICards.Rarity.Rare;
294         } else {
295             return ICards.Rarity.Common;
296         }
297     }
298 
299     function _getRarePlusRarity(uint32 rand) internal pure returns (ICards.Rarity) {
300         if (rand == 999999) {
301             return ICards.Rarity.Mythic;
302         } else if (rand >= 981615) {
303             return ICards.Rarity.Legendary;
304         } else if (rand >= 852940) {
305             return ICards.Rarity.Epic;
306         } else {
307             return ICards.Rarity.Rare;
308         } 
309     }
310 
311     function _getEpicPlusRarity(uint32 rand) internal pure returns (ICards.Rarity) {
312         if (rand == 999999) {
313             return ICards.Rarity.Mythic;
314         } else if (rand >= 981615) {
315             return ICards.Rarity.Legendary;
316         } else {
317             return ICards.Rarity.Epic;
318         }
319     }
320 
321     function _getLegendaryPlusRarity(uint32 rand) internal pure returns (ICards.Rarity) {
322         if (rand == 999999) {
323             return ICards.Rarity.Mythic;
324         } else {
325             return ICards.Rarity.Legendary;
326         } 
327     }
328 
329     // store purity and shine as one number to save users gas
330     function _getPurityBase(uint16 randOne) internal pure returns (uint16) {
331         if (randOne >= 998) {
332             return 3000;
333         } else if (randOne >= 988) {
334             return 2000;
335         } else if (randOne >= 938) {
336             return 1000;
337         }
338         return 0;
339     }
340 
341     function _getShinyPurityBase(uint16 randOne) internal pure returns (uint16) {
342         if (randOne >= 998) {
343             return 3000;
344         } else if (randOne >= 748) {
345             return 2000;
346         } else {
347             return 1000;
348         }
349     }
350 
351     function getShine(uint16 purity) public pure returns (uint8) {
352         return uint8(purity / 1000);
353     }
354 
355 }
356 
357 
358 
359 
360 
361 
362 contract PackFive is Ownable, RarityProvider {
363 
364     using SafeMath for uint;
365     using SafeMath64 for uint64;
366 
367     // fired after user purchases count packs, producing purchase with id
368     event PacksPurchased(uint indexed paymentID, uint indexed id, Pack.Type indexed packType, address user, uint count, uint64 lockup);
369     // fired after the callback transaction is successful, replaces RandomnessReceived
370     event CallbackMade(uint indexed id, address indexed user, uint count, uint randomness);
371     // fired after a recommit for a purchase
372     event Recommit(uint indexed id, Pack.Type indexed packType, address indexed user, uint count, uint64 lockup);
373     // fired after a card is activated, replaces PacksOpened
374     event CardActivated(uint indexed purchaseID, uint cardIndex, uint indexed cardID, uint16 proto, uint16 purity);
375     // fired after a chest is opened
376     event ChestsOpened(uint indexed id, Pack.Type indexed packType, address indexed user, uint count, uint packCount);
377     // fired after a purchase is recorded (either buying packs directly or indirectly)
378     // callback sentinels should watch this event
379     event PurchaseRecorded(uint indexed id, Pack.Type indexed packType, address indexed user, uint count, uint64 lockup);
380     // fired after a purchase is revoked
381     event PurchaseRevoked(uint indexed paymentID, address indexed revoker);
382     // fired when a new pack is added
383     event PackAdded(Pack.Type indexed packType, uint price, address chest);
384 
385     struct Purchase {
386         uint count;
387         uint randomness;
388         uint[] state;
389         Pack.Type packType;
390         uint64 commit;
391         uint64 lockup;
392         bool revoked;
393         address user;
394     }
395 
396     struct PackInstance {
397         uint price;
398         uint chestSize;
399         address token;
400     }
401 
402     Purchase[] public purchases;
403     IProcessor public processor;
404     mapping(uint => PackInstance) public packs;
405     mapping(address => bool) public canLockup;
406     mapping(address => bool) public canRevoke;
407     uint public commitLag = 0;
408     // TODO: check this fits under mainnet gas limit
409     uint16 public activationLimit = 40;
410     // override switch in case of contract upgrade etc
411     bool public canActivate = false;
412     // maximum lockup length in blocks
413     uint64 public maxLockup = 600000;
414 
415     constructor(ICards _cards, IProcessor _processor) public RarityProvider(_cards) {
416         processor = _processor;
417     }
418 
419     // == Admin Functions ==
420     function setCanLockup(address user, bool can) public onlyOwner {
421         canLockup[user] = can;
422     }
423 
424     function setCanRevoke(address user, bool can) public onlyOwner {
425         canRevoke[user] = can;
426     }
427 
428     function setCommitLag(uint lag) public onlyOwner {
429         require(commitLag < 100, "can't have a commit lag of >100 blocks");
430         commitLag = lag;
431     }
432 
433     function setActivationLimit(uint16 _limit) public onlyOwner {
434         activationLimit = _limit;
435     }
436 
437     function setMaxLockup(uint64 _max) public onlyOwner {
438         maxLockup = _max;
439     }
440 
441     function setPack(
442         Pack.Type packType, uint price, address chest, uint chestSize
443     ) public onlyOwner {
444 
445         PackInstance memory p = getPack(packType);
446         require(p.token == address(0) && p.price == 0, "pack instance already set");
447 
448         require(price > 0, "price cannot be zero");
449         require(price % 100 == 0, "price must be a multiple of 100 wei");
450         require(address(processor) != address(0), "processor must be set");
451 
452         packs[uint(packType)] = PackInstance({
453             token: chest,
454             price: price,
455             chestSize: chestSize
456         });
457 
458         emit PackAdded(packType, price, chest);
459     }
460 
461     function setActivate(bool can) public onlyOwner {
462         canActivate = can;
463     }
464 
465     function canActivatePurchase(uint id) public view returns (bool) {
466         if (!canActivate) {
467             return false;
468         }
469         Purchase memory p = purchases[id];
470         if (p.lockup > 0) {
471             if (inLockupPeriod(p)) {
472                 return false;
473             }
474             return !p.revoked;
475         }
476         return true;
477     }
478 
479     function revoke(uint id) public {
480         require(canRevoke[msg.sender], "sender not approved to revoke");
481         Purchase storage p = purchases[id];
482         require(!p.revoked, "must not be revoked already");
483         require(p.lockup > 0, "must have lockup set");
484         require(inLockupPeriod(p), "must be in lockup period");
485         p.revoked = true;
486         emit PurchaseRevoked(id, msg.sender);
487     }
488 
489     // == User Functions ==
490 
491     function purchase(Pack.Type packType, uint16 count, address referrer) public payable returns (uint) {
492         return purchaseFor(packType, msg.sender, count, referrer, 0);
493     }
494 
495     function purchaseFor(Pack.Type packType, address user, uint16 count, address referrer, uint64 lockup) public payable returns (uint) {
496 
497         PackInstance memory pack = getPack(packType);
498 
499         uint purchaseID = _recordPurchase(packType, user, count, lockup);
500     
501         uint paymentID = processor.processPayment.value(msg.value)(msg.sender, pack.price, count, referrer);
502         
503         emit PacksPurchased(paymentID, purchaseID, packType, user, count, lockup);
504 
505         return purchaseID;
506     }
507 
508     function activateMultiple(uint[] memory pIDs, uint[] memory cardIndices)
509         public returns (uint[] memory ids, uint16[] memory protos, uint16[] memory purities) {
510         uint len = pIDs.length;
511         require(len > 0, "can't activate no cards");
512         require(len <= activationLimit, "can't activate more than the activation limit");
513         require(len == cardIndices.length, "must have the same length");
514         ids = new uint[](len);
515         protos = new uint16[](len);
516         purities = new uint16[](len);
517         for (uint i = 0; i < len; i++) {
518             (ids[i], protos[i], purities[i]) = activate(pIDs[i], cardIndices[i]);
519         }
520         return (ids, protos, purities);
521     }
522 
523     function activate(uint purchaseID, uint cardIndex) public returns (uint id, uint16 proto, uint16 purity) {
524         
525         require(canActivatePurchase(purchaseID), "can't activate purchase");
526         Purchase storage p = purchases[purchaseID];
527         
528         require(p.randomness != 0, "must have been a callback");
529         uint cardCount = uint(p.count).mul(5);
530         require(cardIndex < cardCount, "not a valid card index");
531         uint bit = getStateBit(purchaseID, cardIndex);
532         // can only activate each card once
533         require(bit == 0, "card has already been activated");
534         uint x = cardIndex.div(256);
535         uint pos = cardIndex % 256;
536         // mark the card as activated by flipping the relevant bit
537         p.state[x] ^= uint(1) << pos;
538         // create the card
539         (proto, purity) = getCardDetails(p.packType, cardIndex, p.randomness);
540         id = cards.createCard(p.user, proto, purity);
541         emit CardActivated(purchaseID, cardIndex, id, proto, purity);
542         return (id, proto, purity);
543     }
544 
545     // 'open' a number of chest tokens
546     function openChest(Pack.Type packType, address user, uint count) public returns (uint) {
547         
548         PackInstance memory pack = getPack(packType);
549 
550         require(msg.sender == pack.token, "can only open from the actual token packs");
551 
552         uint packCount = count.mul(pack.chestSize);
553         
554         uint id = _recordPurchase(packType, user, packCount, 0);
555 
556         emit ChestsOpened(id, packType, user, count, packCount);
557 
558         return id;
559     }
560 
561     function _recordPurchase(Pack.Type packType, address user, uint count, uint64 lockup) internal returns (uint) {
562 
563         if (lockup != 0) {
564             require(lockup < maxLockup, "lockup must be lower than maximum");
565             require(canLockup[msg.sender], "only some people can lockup cards");
566         }
567         
568         Purchase memory p = Purchase({
569             user: user,
570             count: count,
571             commit: getCommitBlock(),
572             randomness: 0,
573             packType: packType,
574             state: new uint256[](getStateSize(count)),
575             lockup: lockup,
576             revoked: false
577         });
578 
579         uint id = purchases.push(p).sub(1);
580 
581         emit PurchaseRecorded(id, packType, user, count, lockup);
582         return id;
583     }
584 
585     // can be called by anybody
586     function callback(uint id) public {
587 
588         Purchase storage p = purchases[id];
589 
590         require(p.randomness == 0, "randomness already set");
591 
592         require(uint64(block.number) > p.commit, "cannot callback before commit");
593 
594         // must be within last 256 blocks, otherwise recommit
595         require(p.commit.add(uint64(256)) >= block.number, "must recommit");
596 
597         bytes32 bhash = blockhash(p.commit);
598 
599         require(uint(bhash) != 0, "blockhash must not be zero");
600 
601         // only use properties which can't be altered by the user
602         // id and factory are determined before the reveal
603         // 'last' determined param must be random
604         p.randomness = uint(keccak256(abi.encodePacked(id, bhash, address(this))));
605 
606         emit CallbackMade(id, p.user, p.count, p.randomness);
607     }
608 
609     // can recommit
610     // this gives you more chances
611     // if no-one else sends the callback (should never happen)
612     // still only get a random extra chance
613     function recommit(uint id) public {
614         Purchase storage p = purchases[id];
615         require(p.randomness == 0, "randomness already set");
616         require(block.number >= p.commit.add(uint64(256)), "no need to recommit");
617         p.commit = getCommitBlock();
618         emit Recommit(id, p.packType, p.user, p.count, p.lockup);
619     }
620 
621     // == View Functions ==
622 
623     function getCommitBlock() internal view returns (uint64) {
624         return uint64(block.number.add(commitLag));
625     }
626 
627     function getStateSize(uint count) public pure returns (uint) {
628         return count.mul(5).sub(1).div(256).add(1);
629     }
630 
631     function getPurchaseState(uint purchaseID) public view returns (uint[] memory state) {
632         require(purchases.length > purchaseID, "invalid purchase id");
633         Purchase memory p = purchases[purchaseID];
634         return p.state;
635     }
636     
637     function getPackDetails(Pack.Type packType) public view returns (address token, uint price) {
638         PackInstance memory p = getPack(packType);
639         return (p.token, p.price);
640     }
641 
642     function getPack(Pack.Type packType) internal view returns (PackInstance memory) {
643         return packs[uint(packType)];
644     }
645 
646     function getPrice(Pack.Type packType) public view returns (uint) {
647         PackInstance memory p = getPack(packType);
648         require(p.price != 0, "price is not yet set");
649         return p.price;
650     }
651 
652     function getChestSize(Pack.Type packType) public view returns (uint) {
653         PackInstance memory p = getPack(packType);
654         require(p.chestSize != 0, "chest size is not yet set");
655         return p.chestSize;
656     }
657 
658     function isActivated(uint purchaseID, uint cardIndex) public view returns (bool) {
659         return getStateBit(purchaseID, cardIndex) != 0;
660     }
661 
662     function getStateBit(uint purchaseID, uint cardIndex) public view returns (uint) {
663         Purchase memory p = purchases[purchaseID];
664         uint x = cardIndex.div(256);
665         uint slot = p.state[x];
666         uint pos = cardIndex % 256;
667         uint bit = (slot >> pos) & uint(1);
668         return bit;
669     }
670 
671     function predictPacks(uint id) external view returns (uint16[] memory protos, uint16[] memory purities) {
672 
673         Purchase memory p = purchases[id];
674 
675         require(p.randomness != 0, "randomness not yet set");
676 
677         uint result = p.randomness;
678 
679         uint cardCount = uint(p.count).mul(5);
680 
681         purities = new uint16[](cardCount);
682         protos = new uint16[](cardCount);
683 
684         for (uint i = 0; i < cardCount; i++) {
685             (protos[i], purities[i]) = getCardDetails(p.packType, i, result);
686         }
687 
688         return (protos, purities);
689     }
690  
691     function inLockupPeriod(Purchase memory p) internal view returns (bool) {
692         return p.commit.add(p.lockup) >= block.number;
693     }
694 
695 }