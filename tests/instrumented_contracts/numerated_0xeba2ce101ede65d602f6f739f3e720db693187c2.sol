1 pragma solidity ^0.5.0;
2 
3 library SafeMath {
4 
5     /**
6     * @dev Multiplies two numbers, throws on overflow.
7     */
8     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10         // benefit is lost if 'b' is also tested.
11         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12         if (a == 0) {
13             return 0;
14         }
15 
16         c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         // uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return a / b;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43         c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 library SafeMath64 {
50 
51     /**
52     * @dev Multiplies two numbers, throws on overflow.
53     */
54     function mul(uint64 a, uint64 b) internal pure returns (uint64 c) {
55         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
56         // benefit is lost if 'b' is also tested.
57         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
58         if (a == 0) {
59             return 0;
60         }
61 
62         c = a * b;
63         assert(c / a == b);
64         return c;
65     }
66 
67     /**
68     * @dev Integer division of two numbers, truncating the quotient.
69     */
70     function div(uint64 a, uint64 b) internal pure returns (uint64) {
71         // assert(b > 0); // Solidity automatically throws when dividing by 0
72         // uint64 c = a / b;
73         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74         return a / b;
75     }
76 
77     /**
78     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
79     */
80     function sub(uint64 a, uint64 b) internal pure returns (uint64) {
81         assert(b <= a);
82         return a - b;
83     }
84 
85     /**
86     * @dev Adds two numbers, throws on overflow.
87     */
88     function add(uint64 a, uint64 b) internal pure returns (uint64 c) {
89         c = a + b;
90         assert(c >= a);
91         return c;
92     }
93 }
94 
95 interface EBInterface {
96     
97     function owns(address, uint) external returns (bool);
98 
99     function getPartById(uint) external returns (
100         uint32 tokenId, 
101         uint8 partType, 
102         uint8 partSubType,  
103         uint8 rarity, 
104         uint8 element,
105         uint32 battlesLastDay, 
106         uint32 experience, 
107         uint32 forgeTime, 
108         uint32 battlesLastReset
109     );
110 }
111 
112 interface EBMarketplace {
113 
114     function getAuction(uint id) external returns (address, uint, uint, uint, uint);
115  
116 }
117 
118 contract Ownable {
119 
120     address payable public owner;
121 
122     constructor() public {
123         owner = msg.sender;
124     }
125 
126     function setOwner(address payable _owner) public onlyOwner {
127         owner = _owner;
128     }
129 
130     function getOwner() public view returns (address payable) {
131         return owner;
132     }
133 
134     modifier onlyOwner {
135         require(msg.sender == owner, "must be owner to call this function");
136         _;
137     }
138 
139 }
140 
141 contract ICards {
142 
143     enum Rarity {
144         Common, Rare, Epic, Legendary, Mythic
145     }
146 
147     function getRandomCard(Rarity rarity, uint16 random) public view returns (uint16);
148     function createCard(address user, uint16 proto, uint16 purity) public returns (uint);
149 
150 
151 }
152 
153 contract Pack {
154 
155     enum Type {
156         Rare, Epic, Legendary, Shiny
157     }
158 
159 }
160 
161 contract RarityProvider {
162 
163     ICards cards;
164 
165     constructor(ICards _cards) public {
166         cards = _cards;
167     }
168 
169     struct RandomnessComponents {
170         uint random;
171         uint32 rarity;
172         uint16 quality;
173         uint16 purity;
174         uint16 proto;
175     }
176 
177     // return 'length' bytes of 'num' starting at 'start'
178     function extract(uint num, uint length, uint start) internal pure returns (uint) {
179         return (((1 << (length * 8)) - 1) & (num >> ((start - 1) * 8)));
180     }
181 
182     // divides the random seed into components
183     function getComponents(
184         uint cardIndex, uint rand
185     ) internal pure returns (
186         RandomnessComponents memory
187     ) {
188         uint random = uint(keccak256(abi.encodePacked(cardIndex, rand)));
189         return RandomnessComponents({
190             random: random,
191             rarity: uint32(extract(random, 4, 10) % 1000000),
192             quality: uint16(extract(random, 2, 4) % 1000),
193             purity: uint16(extract(random, 2, 6) % 1000),
194             proto: uint16(extract(random, 2, 8) % (2**16-1))
195         });
196     }
197 
198     function getCardDetails(Pack.Type packType, uint cardIndex, uint result) internal view returns (uint16, uint16) {
199         if (packType == Pack.Type.Shiny) {
200             return _getShinyCardDetails(cardIndex, result);
201         } else if (packType == Pack.Type.Legendary) {
202             return _getLegendaryCardDetails(cardIndex, result);
203         } else if (packType == Pack.Type.Epic) {
204             return _getEpicCardDetails(cardIndex, result);
205         }
206         return _getRareCardDetails(cardIndex, result);
207     }
208 
209     function _getShinyCardDetails(uint cardIndex, uint result) internal view returns (uint16 proto, uint16 purity) {
210         
211         RandomnessComponents memory rc = getComponents(cardIndex, result); 
212 
213         ICards.Rarity rarity;
214 
215         if (cardIndex == 4) {
216             rarity = _getLegendaryPlusRarity(rc.rarity);
217             purity = _getShinyPurityBase(rc.quality) + rc.purity;
218         } else if (cardIndex == 3) {
219             rarity = _getRarePlusRarity(rc.rarity);
220             purity = _getPurityBase(rc.quality) + rc.purity;
221         } else {
222             rarity = _getCommonPlusRarity(rc.rarity);
223             purity = _getPurityBase(rc.quality) + rc.purity;
224         }
225         proto = cards.getRandomCard(rarity, rc.proto);
226         return (proto, purity);
227     }
228 
229     function _getLegendaryCardDetails(uint cardIndex, uint result) internal view returns (uint16 proto, uint16 purity) {
230         
231         RandomnessComponents memory rc = getComponents(cardIndex, result);
232 
233         ICards.Rarity rarity;
234 
235         if (cardIndex == 4) {
236             rarity = _getLegendaryPlusRarity(rc.rarity);
237         } else if (cardIndex == 3) {
238             rarity = _getRarePlusRarity(rc.rarity);
239         } else {
240             rarity = _getCommonPlusRarity(rc.rarity);
241         }
242 
243         purity = _getPurityBase(rc.quality) + rc.purity;
244     
245         proto = cards.getRandomCard(rarity, rc.proto);
246 
247         return (proto, purity);
248     } 
249 
250 
251     function _getEpicCardDetails(uint cardIndex, uint result) internal view returns (uint16 proto, uint16 purity) {
252         
253         RandomnessComponents memory rc = getComponents(cardIndex, result);
254 
255         ICards.Rarity rarity;
256 
257         if (cardIndex == 4) {
258             rarity = _getEpicPlusRarity(rc.rarity);
259         } else {
260             rarity = _getCommonPlusRarity(rc.rarity);
261         }
262 
263         purity = _getPurityBase(rc.quality) + rc.purity;
264     
265         proto = cards.getRandomCard(rarity, rc.proto);
266 
267         return (proto, purity);
268     } 
269 
270     function _getRareCardDetails(uint cardIndex, uint result) internal view returns (uint16 proto, uint16 purity) {
271 
272         RandomnessComponents memory rc = getComponents(cardIndex, result);
273 
274         ICards.Rarity rarity;
275 
276         if (cardIndex == 4) {
277             rarity = _getRarePlusRarity(rc.rarity);
278         } else {
279             rarity = _getCommonPlusRarity(rc.rarity);
280         }
281 
282         purity = _getPurityBase(rc.quality) + rc.purity;
283     
284         proto = cards.getRandomCard(rarity, rc.proto);
285         return (proto, purity);
286     }  
287 
288 
289     function _getCommonPlusRarity(uint32 rand) internal pure returns (ICards.Rarity) {
290         if (rand == 999999) {
291             return ICards.Rarity.Mythic;
292         } else if (rand >= 998345) {
293             return ICards.Rarity.Legendary;
294         } else if (rand >= 986765) {
295             return ICards.Rarity.Epic;
296         } else if (rand >= 924890) {
297             return ICards.Rarity.Rare;
298         } else {
299             return ICards.Rarity.Common;
300         }
301     }
302 
303     function _getRarePlusRarity(uint32 rand) internal pure returns (ICards.Rarity) {
304         if (rand == 999999) {
305             return ICards.Rarity.Mythic;
306         } else if (rand >= 981615) {
307             return ICards.Rarity.Legendary;
308         } else if (rand >= 852940) {
309             return ICards.Rarity.Epic;
310         } else {
311             return ICards.Rarity.Rare;
312         } 
313     }
314 
315     function _getEpicPlusRarity(uint32 rand) internal pure returns (ICards.Rarity) {
316         if (rand == 999999) {
317             return ICards.Rarity.Mythic;
318         } else if (rand >= 981615) {
319             return ICards.Rarity.Legendary;
320         } else {
321             return ICards.Rarity.Epic;
322         }
323     }
324 
325     function _getLegendaryPlusRarity(uint32 rand) internal pure returns (ICards.Rarity) {
326         if (rand == 999999) {
327             return ICards.Rarity.Mythic;
328         } else {
329             return ICards.Rarity.Legendary;
330         } 
331     }
332 
333     // store purity and shine as one number to save users gas
334     function _getPurityBase(uint16 randOne) internal pure returns (uint16) {
335         if (randOne >= 998) {
336             return 3000;
337         } else if (randOne >= 988) {
338             return 2000;
339         } else if (randOne >= 938) {
340             return 1000;
341         }
342         return 0;
343     }
344 
345     function _getShinyPurityBase(uint16 randOne) internal pure returns (uint16) {
346         if (randOne >= 998) {
347             return 3000;
348         } else if (randOne >= 748) {
349             return 2000;
350         } else {
351             return 1000;
352         }
353     }
354 
355     function getShine(uint16 purity) public pure returns (uint8) {
356         return uint8(purity / 1000);
357     }
358 
359 }
360 
361 contract EtherbotsPack is Ownable, RarityProvider {
362 
363     using SafeMath for uint256;
364     using SafeMath64 for uint64;
365 
366     // fired after user purchases count packs, producing purchase with id 
367     event ClaimMade(uint indexed id, address user, uint count, uint[] partIDs);
368     // fired after the callback transaction is successful, replaces RandomnessReceived
369     event CallbackMade(uint indexed id, address indexed user, uint count, uint randomness);
370     // fired after a recommit for a purchase
371     event Recommit(uint indexed id, address indexed user, uint count);
372     // fired after a card is activated, replaces PacksOpened
373     event CardActivated(uint indexed claimID, uint cardIndex, uint indexed cardID, uint16 proto, uint16 purity);
374 
375     // Rex, Arcane Sphere, Pyrocannon, Aetherrust, Magic Missile Launcher, Firewall
376     uint16[] commons = [400, 413, 414, 421, 427, 428]; 
377     // Banisher, Daemonbot, Nethersaur, Trident
378     uint16[] rares = [389, 415, 416, 422]; 
379     // Golden Sabre, Howler Golem, Hasty Trade
380     uint16[] epics = [424, 425, 426]; 
381     // Iron Horse, Chest
382     uint16[] legendaries = [382, 420]; 
383     // Golden Golem
384     uint16 exclusive = 417;
385 
386     uint public commitLag = 0;
387     uint16 public activationLimit = 40;
388     uint16 public multiplier = 4;
389     bool public canClaim = true;
390 
391     struct Claim {
392         uint randomness;
393         uint[] state;
394         address user;
395         uint64 commit;
396         uint16 count;
397         uint16[3] exCounts;
398         uint16[3] counts;        
399     }
400 
401     mapping(uint => bool) public claimed;
402 
403     // TODO: should this be public?
404     Claim[] public claims;
405 
406     EBInterface public eb; 
407     EBMarketplace public em; 
408 
409     constructor(ICards _cards, EBInterface _eb, EBMarketplace _em) RarityProvider(_cards) public payable {
410         eb = _eb;
411         em = _em;
412     }
413 
414     function setCommitLag(uint lag) public onlyOwner {
415         require(commitLag < 100, "can't have a commit lag of >100 blocks");
416         commitLag = lag;
417     }
418 
419     function setActivationLimit(uint16 _limit) public onlyOwner {
420         activationLimit = _limit;
421     }
422 
423     function setCanClaim(bool _can) public onlyOwner {
424         canClaim = _can;
425     }
426 
427     function claimParts(uint[] memory parts) public {
428         
429         require(parts.length > 0, "must submit some parts");
430         require(parts.length <= 1000, "must submit <=1000 parts per purchase");
431         require(parts.length % 4 == 0, "must submit a multiple of 4 parts at a time");
432         require(canClaim, "must be able to claim");
433 
434         require(ownsOrAuctioning(parts), "user must control all parts");
435         require(canBeClaimed(parts), "at least one part was already claimed");
436 
437         uint packs = parts.length.div(4).mul(multiplier);
438 
439         Claim memory claim = Claim({ 
440             user: msg.sender,
441             count: uint16(packs),
442             randomness: 0,
443             commit: getCommitBlock(),
444             exCounts: [uint16(0), 0, 0],
445             counts: [uint16(0), 0, 0],
446             state: new uint256[](getStateSize(packs))
447         });
448 
449         uint8 partType;
450         uint8 subType;
451         uint8 rarity;
452 
453         for (uint i = 0; i < parts.length; i++) {
454             (, partType, subType, rarity, , , , ,) = eb.getPartById(parts[i]);
455             require(rarity > 0, "invalid rarity");
456             // rarity is (1, 2, 3)
457             if (isExclusive(partType, subType)) {
458                 claim.exCounts[rarity-1] += multiplier;
459             } else {
460                 claim.counts[rarity-1] += multiplier;
461             }
462         }
463 
464         uint id = claims.push(claim) - 1;
465 
466         emit ClaimMade(id, msg.sender, packs, parts);
467     }
468 
469     function ownsOrAuctioning(uint[] memory parts) public returns (bool) {
470         for (uint i = 0; i < parts.length; i++) {
471             uint id = parts[i];
472             if (!eb.owns(msg.sender, id)) {
473                 address seller;
474                 // returns an active auction 
475                 // will revert if inactive - this is fine, they don't own it then
476                 (seller, , , , ) = em.getAuction(id);
477                 if (seller != msg.sender) {
478                     return false;
479                 }
480             }
481         }
482         return true;
483     }
484 
485     function canBeClaimed(uint[] memory parts) public returns (bool) {
486         for (uint i = 0; i < parts.length; i++) {
487             uint id = parts[i];
488             if (id > 18214) {
489                 return false;
490             }
491             if (claimed[id]) {
492                 return false;
493             }
494             claimed[id] = true;
495         }
496         return true;
497     }
498 
499     function getCounts(uint id) public view returns (uint16[3] memory counts, uint16[3] memory exCounts) {
500         Claim memory c = claims[id];
501         return (c.counts, c.exCounts);
502     }
503 
504     function callback(uint id) public {
505 
506         Claim storage c = claims[id];
507 
508         require(c.randomness == 0, "can only callback once");
509         require(uint64(block.number) > c.commit, "cannot callback before commit");
510         require(c.commit.add(uint64(256)) >= block.number, "must recommit");
511 
512         bytes32 bhash = blockhash(c.commit);
513         require(uint(bhash) != 0, "blockhash must not be zero");
514 
515         c.randomness = uint(keccak256(abi.encodePacked(id, bhash, address(this))));
516 
517         emit CallbackMade(id, c.user, c.count, c.randomness);
518     }
519 
520     function recommit(uint id) public {
521         Claim storage c = claims[id];
522         require(c.randomness == 0, "randomness already set");
523         require(block.number >= c.commit.add(uint64(256)), "no need to recommit");
524         c.commit = getCommitBlock();
525         emit Recommit(id, c.user, c.count);
526     }
527 
528     function predictPacks(uint id) external view returns (uint16[] memory protos, uint16[] memory purities) {
529 
530         Claim memory c = claims[id];
531 
532         require(c.randomness != 0, "randomness not yet set");
533 
534         uint result = c.randomness;
535 
536         uint cardCount = uint(c.count).mul(5);
537 
538         purities = new uint16[](cardCount);
539         protos = new uint16[](cardCount);
540 
541         for (uint i = 0; i < cardCount; i++) {
542             (protos[i], purities[i]) = getCard(c, i, result);
543         }
544 
545         return (protos, purities);
546     }
547 
548     function getCommitBlock() internal view returns (uint64) {
549         return uint64(block.number.add(commitLag));
550     }
551 
552     function getStateSize(uint count) public pure returns (uint) {
553         return count.mul(5).sub(1).div(256).add(1);
554     }
555 
556     function isExclusive(uint partType, uint partSubType) public pure returns (bool) {
557         // checks whether the part is a lambo or AP
558         return (partType == 3) && (partSubType == 14 || partSubType == 16);
559     }
560 
561     function getCard(Claim memory c, uint index, uint result) internal view returns (uint16 proto, uint16 purity) {
562 
563         RandomnessComponents memory rc = getComponents(index, result);
564 
565         uint16 progress = c.exCounts[0];
566 
567         if (progress > index) {
568             proto = exclusive;
569             purity = _getPurityBase(rc.quality) + rc.purity;
570             return (proto, purity);
571         }
572 
573         progress += c.exCounts[1];
574         if (progress > index) {
575             proto = exclusive;
576             // will be a random shadow
577             purity = _getPurityBase(940) + rc.purity;
578             return (proto, purity);
579         } 
580 
581         progress += c.exCounts[2];
582         if (progress > index) {
583             proto = exclusive;
584             // will be a random gold
585             purity = _getPurityBase(990) + rc.purity;
586             return (proto, purity);
587         }
588 
589         progress += c.counts[0];
590         if (progress > index) {
591             proto = getRandomCard(rc.rarity, rc.proto);
592             purity = _getPurityBase(rc.quality) + rc.purity;
593             return (proto, purity);
594         }
595 
596         progress += c.counts[1];
597         if (progress > index) {
598             proto = getRandomCard(rc.rarity, rc.proto);
599             // will be a random shadow
600             purity = _getPurityBase(940) + rc.purity;
601             return (proto, purity);
602         } 
603 
604         progress += c.counts[2];
605         if (progress > index) {
606             proto = getRandomCard(rc.rarity, rc.proto);
607             // will be a random gold
608             purity = _getPurityBase(990) + rc.purity;
609             return (proto, purity);
610         }
611 
612         // 5 cards for 4 parts --> left over cards just get base stats
613         proto = getRandomCard(rc.rarity, rc.proto);
614         purity = _getPurityBase(rc.quality) + rc.purity;
615 
616         return (proto, purity);
617     }  
618 
619     function getRandomCard(uint32 rarityRandom, uint16 protoRandom) internal view returns (uint16) {
620         // adjusted from normal probabilities to ensure more appropriate distribution of cards
621         if (rarityRandom >= 970000) {
622             return legendaries[protoRandom % legendaries.length];
623         } else if (rarityRandom >= 890000) {
624             return epics[protoRandom % epics.length];
625         } else if (rarityRandom >= 670000) {
626             return rares[protoRandom % rares.length];
627         } else {
628             return commons[protoRandom % commons.length];
629         }
630     }
631 
632     function activateMultiple(uint[] memory pIDs, uint[] memory cardIndices) 
633         public returns (uint[] memory ids, uint16[] memory protos, uint16[] memory purities) {
634         uint len = pIDs.length;
635         require(len > 0, "can't activate no cards");
636         require(len <= activationLimit, "can't activate more than the activation limit");
637         require(len == cardIndices.length, "must have the same length");
638         ids = new uint[](len);
639         protos = new uint16[](len);
640         purities = new uint16[](len);
641         for (uint i = 0; i < len; i++) {
642             (ids[i], protos[i], purities[i]) = activate(pIDs[i], cardIndices[i]);
643         }
644         return (ids, protos, purities);
645     }
646 
647     function activate(uint claimID, uint cardIndex) public returns (uint id, uint16 proto, uint16 purity) {
648         Claim storage c = claims[claimID];
649         
650         require(c.randomness != 0, "must have been a callback");
651         uint cardCount = uint(c.count).mul(5);
652         require(cardIndex < cardCount, "not a valid card index");
653         uint bit = getStateBit(claimID, cardIndex);
654         // can only activate each card once
655         require(bit == 0, "card has already been activated");
656         uint x = cardIndex.div(256);
657         uint pos = cardIndex % 256;
658         // mark the card as activated by flipping the relevant bit
659         c.state[x] ^= uint(1) << pos;
660         // create the card
661         (proto, purity) = getCard(c, cardIndex, c.randomness);
662         id = cards.createCard(c.user, proto, purity);
663         emit CardActivated(claimID, cardIndex, id, proto, purity);
664         return (id, proto, purity);
665     }
666 
667     function isActivated(uint purchaseID, uint cardIndex) public view returns (bool) {
668         return getStateBit(purchaseID, cardIndex) != 0;
669     }
670 
671     function getStateBit(uint claimID, uint cardIndex) public view returns (uint) {
672         Claim memory c = claims[claimID];
673         uint x = cardIndex.div(256);
674         uint slot = c.state[x];
675         uint pos = cardIndex % 256;
676         uint bit = (slot >> pos) & uint(1);
677         return bit;
678     }
679 
680 }