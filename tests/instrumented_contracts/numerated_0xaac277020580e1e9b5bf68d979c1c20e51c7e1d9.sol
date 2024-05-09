1 // Base Minting Contract
2 contract CardMintingFacilitator {
3     CardConfig schema = CardConfig(0x08584271df3d0249c2c06ac1bc1237a1dd30cb9a); 
4     EtherGenCore storageContract = EtherGenCore(0x677aa1dc08b9429c595efd4425b2d218cc22fd6e);
5     address public owner = 0x08F4aE96b647B30177cc15B21195960625BA4163;
6     
7     function generateRandomCard(uint32 randomSeed) internal constant returns (uint8[14]) {
8         uint8[14] memory cardDetails;
9        
10         randomSeed = uint32(sha3(block.blockhash(block.number), randomSeed));
11         cardDetails[0] = schema.getType(randomSeed);
12 
13         if (cardDetails[0] == uint8(CardConfig.Type.Monster)) {
14             generateRandomMonster(cardDetails, randomSeed);
15         } else {
16             generateRandomSpell(cardDetails, randomSeed);
17         }
18         
19         randomSeed = uint32(sha3(block.blockhash(block.number), randomSeed));
20         if (randomSeed % 200 == 13) { // Lucky number 13
21             cardDetails[12] = 1; // Secret golden attribute
22         }
23         
24         return cardDetails;
25     }
26     
27     function generateRandomMonster(uint8[14] cardDetails, uint32 randomSeed) internal constant {
28         uint24 totalCost;
29         
30         randomSeed = uint32(sha3(block.blockhash(block.number), randomSeed));
31         cardDetails[1] = schema.getRace(randomSeed);
32         totalCost += schema.getCostForRace(cardDetails[1]);
33 
34         randomSeed = uint32(sha3(block.blockhash(block.number), randomSeed));
35         cardDetails[2] = schema.getTrait(randomSeed);
36         totalCost += schema.getCostForTrait(cardDetails[2]);
37 
38         uint8 newMutation;
39         uint24 newMutationCost;
40         randomSeed = uint32(sha3(block.blockhash(block.number), randomSeed));
41         
42         uint8 numMutations = uint8(randomSeed % 12); // 0 = 0 mutations, 1 = 1 mutation, 2-5 = 2 mutations, 6-11 = 3 mutations 
43         if (numMutations > 5) {
44             numMutations = 3;
45         } else if (numMutations > 2) {
46             numMutations = 2;
47         }
48         
49         for (uint8 i = 0; i < numMutations; i++) {
50             randomSeed = uint32(sha3(block.blockhash(block.number), randomSeed));
51             if (bool(randomSeed % 3 == 0)) { // 0: Race; 1-2: Neutral
52                 randomSeed = uint32(sha3(block.blockhash(block.number), randomSeed));
53 
54                 // Horribly add new mutations (rather than looping for a fresh one) this is cheaper
55                 (newMutationCost, newMutation) = schema.getMutationForRace(CardConfig.Race(cardDetails[1]), randomSeed);
56                 if (totalCost + newMutationCost < 290000) {
57                     if (cardDetails[6] == 0) {
58                         cardDetails[6] = newMutation;
59                         totalCost += newMutationCost;
60                     } else if (cardDetails[6] > 0 && cardDetails[7] == 0 && cardDetails[6] != newMutation) {
61                         cardDetails[7] = newMutation;
62                         totalCost += newMutationCost;
63                     } else if  (cardDetails[6] > 0 && cardDetails[7] > 0 && cardDetails[8] == 0 && cardDetails[6] != newMutation && cardDetails[7] != newMutation) {
64                         cardDetails[8] = newMutation;
65                         totalCost += newMutationCost;
66                     }
67                 }
68             } else {
69                 randomSeed = uint32(sha3(block.blockhash(block.number), randomSeed));
70 
71                 // Horribly add new mutations (rather than looping for a fresh one) this is cheaper
72                 (newMutationCost, newMutation) = schema.getNeutralMutation(randomSeed);
73                 if (totalCost + newMutationCost < 290000) {
74                     if (cardDetails[9] == 0) {
75                         cardDetails[9] = newMutation;
76                         totalCost += newMutationCost;
77                     } else if (cardDetails[9] > 0 && cardDetails[10] == 0 && cardDetails[9] != newMutation) {
78                         cardDetails[10] = newMutation;
79                         totalCost += newMutationCost;
80                     } else if (cardDetails[9] > 0 && cardDetails[10] > 0 && cardDetails[11] == 0 && cardDetails[9] != newMutation && cardDetails[10] != newMutation) {
81                         cardDetails[11] = newMutation;
82                         totalCost += newMutationCost;
83                     }
84                 }
85             }
86         }
87 
88         // For attack & health distribution
89         randomSeed = uint32(sha3(block.blockhash(block.number), randomSeed));
90         uint24 powerCost = schema.getCostForHealth(1) + uint24(randomSeed % (301000 - (totalCost + schema.getCostForHealth(1)))); // % upto 300999 will allow 30 cost cards
91 
92         if (totalCost + powerCost < 100000) { // Cards should cost at least 10 crystals (10*10000 exponant)
93             powerCost = 100000 - totalCost;
94         }
95         
96         randomSeed = uint32(sha3(block.blockhash(block.number), randomSeed));
97         cardDetails[5] = 1 + uint8(schema.getHealthForCost(randomSeed % powerCost)); // should be (1 + powerCost - schema.getCostForHealth(1))
98         totalCost += schema.getCostForHealth(cardDetails[5]);
99         
100         powerCost = powerCost - schema.getCostForHealth(cardDetails[5]); // Power left for attack
101         cardDetails[4] = uint8(schema.getAttackForCost(powerCost));
102         totalCost += schema.getCostForAttack(cardDetails[4]);
103        
104         // Remove exponent to get total card cost [10-30]
105         cardDetails[3] = uint8(totalCost / 10000);
106     }
107     
108     
109     function generateRandomSpell(uint8[14] cardDetails, uint32 randomSeed) internal constant {
110         uint24 totalCost;
111         
112         uint8 newAbility;
113         uint24 newAbilityCost;
114         randomSeed = uint32(sha3(block.blockhash(block.number), randomSeed));
115         
116         uint8 numAbilities = uint8(randomSeed % 16); // 0 = 1 ability, 1-8 = 2 abilities, 9-15 = 3 abilities 
117         if (numAbilities > 8) {
118             numAbilities = 3;
119         } else if (numAbilities > 0) {
120             numAbilities = 2;
121         } else {
122             numAbilities = 1;
123         }
124         
125         for (uint8 i = 0; i < numAbilities; i++) {
126             randomSeed = uint32(sha3(block.blockhash(block.number), randomSeed));
127 
128             // Horribly add new spell abilities (rather than looping for a fresh one) this is cheaper
129             (newAbilityCost, newAbility) = schema.getSpellAbility(randomSeed);
130             if (totalCost + newAbilityCost <= 300000) {
131                 if (cardDetails[9] == 0) {
132                     cardDetails[9] = newAbility;
133                     totalCost += newAbilityCost;
134                 } else if (cardDetails[9] > 0 && cardDetails[10] == 0 && cardDetails[9] != newAbility) {
135                     cardDetails[10] = newAbility;
136                     totalCost += newAbilityCost;
137                 } else if (cardDetails[9] > 0 && cardDetails[10] > 0 && cardDetails[11] == 0 && cardDetails[9] != newAbility && cardDetails[10] != newAbility) {
138                     cardDetails[11] = newAbility;
139                     totalCost += newAbilityCost;
140                 }
141             }
142         }
143         
144         // Remove exponent to get total card cost [10-30]
145         cardDetails[3] = uint8(totalCost / 10000);
146     }
147     
148     
149     function generateCostFromAttributes(uint8[14] cardDetails) internal constant returns (uint8 cost) {
150         uint24 exponentCost = 0;
151         if (cardDetails[0] == 1) { // Spell
152             exponentCost += schema.getSpellAbilityCost(cardDetails[9]);
153             exponentCost += schema.getSpellAbilityCost(cardDetails[10]);
154             exponentCost += schema.getSpellAbilityCost(cardDetails[11]);
155         } else {
156             exponentCost += schema.getCostForRace(cardDetails[1]);
157             exponentCost += schema.getCostForTrait(cardDetails[2]);
158             exponentCost += schema.getCostForAttack(cardDetails[4]);
159             exponentCost += schema.getCostForHealth(cardDetails[5]);
160             exponentCost += schema.getRaceMutationCost(CardConfig.Race(cardDetails[1]), cardDetails[6]);
161             exponentCost += schema.getRaceMutationCost(CardConfig.Race(cardDetails[1]), cardDetails[7]);
162             exponentCost += schema.getRaceMutationCost(CardConfig.Race(cardDetails[1]), cardDetails[8]);
163             exponentCost += schema.getNeutralMutationCost(cardDetails[9]);
164             exponentCost += schema.getNeutralMutationCost(cardDetails[10]);
165             exponentCost += schema.getNeutralMutationCost(cardDetails[11]);
166         }
167         return uint8(exponentCost / 10000); // Everything is factor 10000 for ease of autonomous Workshop cost-tuning
168     }
169     
170     // Allows future extensibility (New card mutations + Workshop updates)
171     function upgradeCardConfig(address newCardConfig) external {
172         require(msg.sender == owner);
173         schema = CardConfig(newCardConfig);
174     }
175     
176     function updateStorageContract(address newStorage) external {
177         require(msg.sender == owner);
178         storageContract = EtherGenCore(newStorage);
179     }
180     
181     function updateOwner(address newOwner) external {
182         require(msg.sender == owner);
183         owner = newOwner;
184     }
185 }
186 
187 
188 contract LimitedEditionSeedCardsDistributor is CardMintingFacilitator {
189     
190     // To kickstart marketplace 100,000 cards will be listed over time (starting at four per hour) 
191     // this is a tiny fraction of the rough 4,000,000,000 possible cards, we anticipate these to be
192     // VERY limited edition in future (as Workshop will autonomously adjust crystal costs for popular card-combinations)
193     // so may become impossible to craft some cards in this batch... Gift to our early adopters!
194     uint24 constant mintingLimit = 100000;
195     uint128 constant startingPriceMultiplier = 250 szabo; // Crystal cost * 250 szabo (aka 2500-7500 szabo)
196     uint128 constant endPriceMultiplier = 100 szabo; // (aka 1000-3000 szabo) ~$2 bargain!
197    
198     uint24 public cardsMinted = 0;
199     uint64[] private mintedCardIds;
200     uint128 private nextMarketListingTimeStamp;
201     
202     MappedMarketplace marketplaceContract = MappedMarketplace(0xc3d2736b3e4f0f78457d75b3b5f0191a14e8bd57);
203     
204     function mintNextCard() external {
205         require(cardsMinted < mintingLimit);
206         uint8[14] memory newCard = generateRandomCard(uint32(storageContract.totalSupply() * now));
207         cardsMinted++;
208         storageContract.mintCard(address(this), newCard);
209         mintedCardIds.push(uint64(storageContract.totalSupply() - 1));
210     }
211     
212     function listNextFourCards(uint128 nextDrop) external {
213         // Lists four cards on market (starting rate 4 cards per hour, fluctuating on demand)
214         // Until all 100,000 Rare Limited Edition have been listed.
215         // We estimate just 60-90 days before no more cards, forever (Excluding Workshop/Fusing of Cards)
216         require(msg.sender == owner);
217         require(mintedCardIds.length > 3);
218         require(nextDrop > nextMarketListingTimeStamp);
219         
220         listSingleCard();
221         listSingleCard();
222         listSingleCard();
223         listSingleCard();
224         
225         // Update timestamp for next batch
226         nextMarketListingTimeStamp = nextDrop;
227     }
228     
229     function listSingleCard() internal {
230         uint64 cardId = mintedCardIds[mintedCardIds.length - 1];
231         uint8[14] memory cardInfo = storageContract.getCard(cardId);
232         
233         uint128 startPrice = cardInfo[3] * startingPriceMultiplier;
234         uint128 endPrice = cardInfo[3] * endPriceMultiplier;
235         marketplaceContract.listCard(cardId, startPrice, endPrice, 24 hours);
236         
237         delete mintedCardIds[mintedCardIds.length - 1];
238         mintedCardIds.length--;
239     }
240     
241     function getNextDropTime() constant external returns (uint128) {
242         return nextMarketListingTimeStamp;
243     }
244     
245     function() public payable { }
246     
247     function withdrawBalance() external {
248         require(msg.sender == owner);
249         owner.transfer(this.balance);
250     }
251 
252     function updateMarketContract(address newMarketplace) external {
253         require(msg.sender == owner);
254         marketplaceContract = MappedMarketplace(newMarketplace);
255     }
256     
257 }
258 
259 // Interface for contracts conforming to ERC-721: Non-Fungible Tokens
260 contract ERC721 {
261 
262     // Required methods
263     function totalSupply() public view returns (uint256 cards);
264     function balanceOf(address player) public view returns (uint256 balance);
265     function ownerOf(uint256 cardId) external view returns (address owner);
266     function approve(address to, uint256 cardId) external;
267     function transfer(address to, uint256 cardId) external;
268     function transferFrom(address from, address to, uint256 cardId) external;
269 
270     // Events
271     event Transfer(address from, address to, uint256 cardId);
272     event Approval(address owner, address approved, uint256 cardId);
273 
274     // Name and symbol of the non fungible token, as defined in ERC721.
275     string public constant name = "EtherGen";
276     string public constant symbol = "ETG";
277 
278     // Optional methods
279     function tokensOfOwner(address player) external view returns (uint64[] cardIds);
280 }
281 
282 
283 contract PlayersCollectionStorage {
284     
285     mapping(address => PlayersCollection) internal playersCollections;
286     mapping(uint64 => Card) internal cardIdMapping;
287 
288     struct PlayersCollection {
289         uint64[] cardIds;
290         bool referalCardsUnlocked;
291     }
292 
293     struct Card {
294         uint64 id;
295         uint64 collectionPointer; // Index in player's collection
296         address owner;
297         
298         uint8 cardType;
299         uint8 race;
300         uint8 trait;
301 
302         uint8 cost; // [10-30]
303         uint8 attack; // [0-99]
304         uint8 health; // [1-99]
305 
306         uint8 raceMutation0; // Super ugly but dynamic length arrays are currently a no-go across contracts
307         uint8 raceMutation1; // + very expensive gas since cards are in nested structs (collection of cards)
308         uint8 raceMutation2;
309 
310         uint8 neutralMutation0;
311         uint8 neutralMutation1;
312         uint8 neutralMutation2;
313 
314         /**
315          * Initally referal (free) cards will be untradable (to stop abuse) however EtherGenCore has
316          * unlockUntradeableCards() to make them tradeable -triggered once player hits certain battle/game milestone
317          */
318         bool isReferalReward;
319         bool isGolden; // Top secret Q2 animated art
320     }
321     
322     function getPlayersCollection(address player) public constant returns (uint64[], uint8[14][]) {
323         uint8[14][] memory cardDetails = new uint8[14][](playersCollections[player].cardIds.length);
324         uint64[] memory cardIds = new uint64[](playersCollections[player].cardIds.length);
325 
326         for (uint32 i = 0; i < playersCollections[player].cardIds.length; i++) {
327             Card memory card = cardIdMapping[playersCollections[player].cardIds[i]];
328             cardDetails[i][0] = card.cardType;
329             cardDetails[i][1] = card.race;
330             cardDetails[i][2] = card.trait;
331             cardDetails[i][3] = card.cost;
332             cardDetails[i][4] = card.attack;
333             cardDetails[i][5] = card.health;
334             cardDetails[i][6] = card.raceMutation0;
335             cardDetails[i][7] = card.raceMutation1;
336             cardDetails[i][8] = card.raceMutation2;
337             cardDetails[i][9] = card.neutralMutation0;
338             cardDetails[i][10] = card.neutralMutation1;
339             cardDetails[i][11] = card.neutralMutation2;
340 
341             cardDetails[i][12] = card.isGolden ? 1 : 0; // Not ideal but web3.js didn't like returning multiple 2d arrays
342             cardDetails[i][13] = isCardTradeable(card) ? 1 : 0;
343             
344             cardIds[i] = card.id;
345         }
346         return (cardIds, cardDetails);
347     }
348     
349     function getCard(uint64 cardId) public constant returns (uint8[14]) {
350         Card memory card = cardIdMapping[cardId];
351         return ([card.cardType, card.race, card.trait, card.cost, card.attack, card.health,
352                  card.raceMutation0, card.raceMutation1, card.raceMutation2,
353                  card.neutralMutation0, card.neutralMutation1, card.neutralMutation2,
354                  card.isGolden ? 1 : 0, 
355                  isCardTradeable(card) ? 1 : 0]);
356     }
357     
358     function isCardTradeable(Card card) internal constant returns(bool) {
359         return (playersCollections[card.owner].referalCardsUnlocked || !card.isReferalReward);
360     }
361     
362     function isCardTradeable(uint64 cardId) external constant returns(bool) {
363         return isCardTradeable(cardIdMapping[cardId]);
364     }
365 }
366 
367 
368 
369 
370 contract EtherGenCore is PlayersCollectionStorage, ERC721 {
371     
372     mapping(address => bool) private privilegedTransferModules; // Marketplace ( + future features)
373     mapping(address => bool) private privilegedMintingModules; // Referals, Fusing, Workshop etc. ( + future features)
374     
375     mapping(uint64 => address) private cardIdApproveds; // Approval list (ERC721 transfers)
376     uint64 private totalCardSupply; // Also used for cardId incrementation
377     
378     TransferRestrictionVerifier transferRestrictionVerifier = TransferRestrictionVerifier(0xd9861d9a6111bfbb9235a71151f654d0fe7ed954); 
379     address public owner = 0x08F4aE96b647B30177cc15B21195960625BA4163;
380     bool public paused = false;
381     
382     function totalSupply() public view returns (uint256 cards) {
383         return totalCardSupply;
384     }
385     
386     function ownerOf(uint256 cardId) external view returns (address cardOwner) {
387         return cardIdMapping[uint64(cardId)].owner;
388     }
389     
390     function balanceOf(address player) public view returns (uint256 balance) {
391         return playersCollections[player].cardIds.length;
392     }
393     
394     function tokensOfOwner(address player) external view returns (uint64[] cardIds) {
395         return playersCollections[player].cardIds;
396     }
397     
398     function transfer(address newOwner, uint256 cardId) external {
399         uint64 castCardId = uint64(cardId);
400         require(cardIdMapping[castCardId].owner == msg.sender);
401         require(isCardTradeable(cardIdMapping[castCardId]));
402         require(transferRestrictionVerifier.isAvailableForTransfer(castCardId));
403         require(!paused);
404         
405         removeCardOwner(castCardId);
406         assignCardOwner(newOwner, castCardId);
407         Transfer(msg.sender, newOwner, castCardId); // Emit Event
408     }
409     
410     function transferFrom(address currentOwner, address newOwner, uint256 cardId) external {
411         uint64 castCardId = uint64(cardId);
412         require(cardIdMapping[castCardId].owner == currentOwner);
413         require(isApprovedTransferer(msg.sender, castCardId));
414         require(isCardTradeable(cardIdMapping[castCardId]));
415         require(transferRestrictionVerifier.isAvailableForTransfer(castCardId));
416         require(!paused);
417         
418         removeCardOwner(castCardId);
419         assignCardOwner(newOwner, castCardId);
420         Transfer(currentOwner, newOwner, castCardId); // Emit Event
421     }
422     
423     function approve(address approved, uint256 cardId) external {
424         uint64 castCardId = uint64(cardId);
425         require(cardIdMapping[castCardId].owner == msg.sender);
426         
427         cardIdApproveds[castCardId] = approved; // Register approval (replacing previous)
428         Approval(msg.sender, approved, castCardId); // Emit Event
429     }
430     
431     function isApprovedTransferer(address approvee, uint64 cardId) internal constant returns (bool) {
432         // Will only return true if approvee (msg.sender) is a privileged transfer address (Marketplace) or santioned by card's owner using ERC721's approve()
433         return privilegedTransferModules[approvee] || cardIdApproveds[cardId] == approvee;
434     }
435     
436     function removeCardOwner(uint64 cardId) internal {
437         address cardOwner = cardIdMapping[cardId].owner;
438 
439         if (playersCollections[cardOwner].cardIds.length > 1) {
440             uint64 rowToDelete = cardIdMapping[cardId].collectionPointer;
441             uint64 cardIdToMove = playersCollections[cardOwner].cardIds[playersCollections[cardOwner].cardIds.length - 1];
442             playersCollections[cardOwner].cardIds[rowToDelete] = cardIdToMove;
443             cardIdMapping[cardIdToMove].collectionPointer = rowToDelete;
444         }
445         
446         playersCollections[cardOwner].cardIds.length--;
447         cardIdMapping[cardId].owner = 0;
448     }
449     
450     function assignCardOwner(address newOwner, uint64 cardId) internal {
451         if (newOwner != address(0)) {
452             cardIdMapping[cardId].owner = newOwner;
453             cardIdMapping[cardId].collectionPointer = uint64(playersCollections[newOwner].cardIds.push(cardId) - 1);
454         }
455     }
456     
457     function mintCard(address recipient, uint8[14] cardDetails) external {
458         require(privilegedMintingModules[msg.sender]);
459         require(!paused);
460         
461         Card memory card;
462         card.owner = recipient;
463         
464         card.cardType = cardDetails[0];
465         card.race = cardDetails[1];
466         card.trait = cardDetails[2];
467         card.cost = cardDetails[3];
468         card.attack = cardDetails[4];
469         card.health = cardDetails[5];
470         card.raceMutation0 = cardDetails[6];
471         card.raceMutation1 = cardDetails[7];
472         card.raceMutation2 = cardDetails[8];
473         card.neutralMutation0 = cardDetails[9];
474         card.neutralMutation1 = cardDetails[10];
475         card.neutralMutation2 = cardDetails[11];
476         card.isGolden = cardDetails[12] == 1;
477         card.isReferalReward = cardDetails[13] == 1;
478         
479         card.id = totalCardSupply;
480         totalCardSupply++;
481 
482         cardIdMapping[card.id] = card;
483         cardIdMapping[card.id].collectionPointer = uint64(playersCollections[recipient].cardIds.push(card.id) - 1);
484     }
485     
486     // Management functions to facilitate future contract extensibility, unlocking of (untradable) referal bonus cards and contract ownership
487     
488     function unlockUntradeableCards(address player) external {
489         require(privilegedTransferModules[msg.sender]);
490         playersCollections[player].referalCardsUnlocked = true;
491     }
492     
493     function manageApprovedTransferModule(address moduleAddress, bool isApproved) external {
494         require(msg.sender == owner);
495         privilegedTransferModules[moduleAddress] = isApproved; 
496     }
497     
498      function manageApprovedMintingModule(address moduleAddress, bool isApproved) external {
499         require(msg.sender == owner);
500         privilegedMintingModules[moduleAddress] = isApproved; 
501     }
502     
503     function updateTransferRestrictionVerifier(address newTransferRestrictionVerifier) external {
504         require(msg.sender == owner);
505         transferRestrictionVerifier = TransferRestrictionVerifier(newTransferRestrictionVerifier);
506     }
507     
508     function setPaused(bool shouldPause) external {
509         require(msg.sender == owner);
510         paused = shouldPause;
511     }
512     
513     function updateOwner(address newOwner) external {
514         require(msg.sender == owner);
515         owner = newOwner;
516     }
517     
518 }
519 
520 
521 
522 
523 contract CardConfig {
524     enum Type {Monster, Spell} // More could come!
525 
526     enum Race {Dragon, Spiderling, Demon, Humanoid, Beast, Undead, Elemental, Vampire, Serpent, Mech, Golem, Parasite}
527     uint16 constant numRaces = 12;
528 
529     enum Trait {Normal, Fire, Poison, Lightning, Ice, Divine, Shadow, Arcane, Cursed, Void}
530     uint16 constant numTraits = 10;
531 
532     function getType(uint32 randomSeed) public constant returns (uint8) {
533         if (randomSeed % 5 > 0) { // 80% chance for monster (spells are less fun so make up for it in rarity)
534             return uint8(Type.Monster);
535         } else {
536             return uint8(Type.Spell);
537         }
538     }
539     
540     function getRace(uint32 randomSeed) public constant returns (uint8) {
541         return uint8(Race(randomSeed % numRaces));
542     }
543 
544     function getTrait(uint32 randomSeed) public constant returns (uint8) {
545         return uint8(Trait(randomSeed % numTraits));
546     }
547 
548     SpellAbilities spellAbilities = new SpellAbilities();
549     SharedNeutralMutations neutralMutations = new SharedNeutralMutations();
550     DragonMutations dragonMutations = new DragonMutations();
551     SpiderlingMutations spiderlingMutations = new SpiderlingMutations();
552     DemonMutations demonMutations = new DemonMutations();
553     HumanoidMutations humanoidMutations = new HumanoidMutations();
554     BeastMutations beastMutations = new BeastMutations();
555     UndeadMutations undeadMutations = new UndeadMutations();
556     ElementalMutations elementalMutations = new ElementalMutations();
557     VampireMutations vampireMutations = new VampireMutations();
558     SerpentMutations serpentMutations = new SerpentMutations();
559     MechMutations mechMutations = new MechMutations();
560     GolemMutations golemMutations = new GolemMutations();
561     ParasiteMutations parasiteMutations = new ParasiteMutations();
562     
563 
564     // The powerful schema that will allow the Workshop (crystal) prices to fluctuate based on performance, keeping the game fresh & evolve over time!
565     
566     function getCostForRace(uint8 race) public constant returns (uint8 cost) {
567         return 0; // born equal (under current config)
568     }
569     
570     function getCostForTrait(uint8 trait) public constant returns (uint24 cost) {
571         if (trait == uint8(CardConfig.Trait.Normal)) {
572             return 0;
573         }
574         return 40000;
575     }
576     
577     function getSpellAbility(uint32 randomSeed) public constant returns (uint24 cost, uint8 spell) {
578         spell = uint8(spellAbilities.getSpell(randomSeed)) + 1;
579         return (getSpellAbilityCost(spell), spell);
580     }
581     
582     function getSpellAbilityCost(uint8 spell) public constant returns (uint24 cost) {
583         return 100000;
584     }
585 
586     function getNeutralMutation(uint32 randomSeed) public constant returns (uint24 cost, uint8 mutation) {
587         mutation = uint8(neutralMutations.getMutation(randomSeed)) + 1;
588         return (getNeutralMutationCost(mutation), mutation);
589     }
590     
591     function getNeutralMutationCost(uint8 mutation) public constant returns (uint24 cost) {
592         if (mutation == 0) {
593             return 0;   
594         }
595         return 40000;
596     }
597 
598     function getMutationForRace(Race race, uint32 randomSeed) public constant returns (uint24 cost, uint8 mutation) {
599         if (race == Race.Dragon) {
600             mutation = uint8(dragonMutations.getRaceMutation(randomSeed)) + 1;
601         } else if (race == Race.Spiderling) {
602             mutation = uint8(spiderlingMutations.getRaceMutation(randomSeed)) + 1;
603         } else if (race == Race.Demon) {
604             mutation = uint8(demonMutations.getRaceMutation(randomSeed)) + 1;
605         } else if (race == Race.Humanoid) {
606             mutation = uint8(humanoidMutations.getRaceMutation(randomSeed)) + 1;
607         } else if (race == Race.Beast) {
608             mutation = uint8(beastMutations.getRaceMutation(randomSeed)) + 1;
609         } else if (race == Race.Undead) {
610             mutation = uint8(undeadMutations.getRaceMutation(randomSeed)) + 1;
611         } else if (race == Race.Elemental) {
612             mutation = uint8(elementalMutations.getRaceMutation(randomSeed)) + 1;
613         } else if (race == Race.Vampire) {
614             mutation = uint8(vampireMutations.getRaceMutation(randomSeed)) + 1;
615         } else if (race == Race.Serpent) {
616             mutation = uint8(serpentMutations.getRaceMutation(randomSeed)) + 1;
617         } else if (race == Race.Mech) {
618             mutation = uint8(mechMutations.getRaceMutation(randomSeed)) + 1;
619         } else if (race == Race.Golem) {
620             mutation = uint8(golemMutations.getRaceMutation(randomSeed)) + 1;
621         } else if (race == Race.Parasite) {
622             mutation = uint8(parasiteMutations.getRaceMutation(randomSeed)) + 1;
623         }
624         return (getRaceMutationCost(race, mutation), mutation);
625     }
626     
627     function getRaceMutationCost(Race race, uint8 mutation) public constant returns (uint24 cost) {
628         if (mutation == 0) {
629             return 0;   
630         }
631         return 40000;
632     }
633     
634     function getCostForHealth(uint8 health) public constant returns (uint24 cost) {
635         return health * uint24(2000);
636     }
637     
638     function getHealthForCost(uint32 cost) public constant returns (uint32 health) {
639         health = cost / 2000;
640         if (health > 98) { // 1+[0-98] (gotta have [1-99] health)
641             health = 98;
642         }
643         return health;
644     }
645     
646     function getCostForAttack(uint8 attack) public constant returns (uint24 cost) {
647         return attack * uint24(2000);
648     }
649     
650     function getAttackForCost(uint32 cost) public constant returns (uint32 attack) {
651        attack = cost / 2000;
652         if (attack > 99) {
653             attack = 99;
654         }
655         return attack;
656     }
657     
658 }
659 
660 contract SpellAbilities {
661     enum Spells {LavaBlast, FlameNova, Purify, IceBlast, FlashFrost, SnowStorm, FrostFlurry, ChargeFoward, DeepFreeze, ThawTarget,
662                  FlashOfLight, LightBeacon, BlackHole, Earthquake, EnchantArmor, EnchantWeapon, CallReinforcements, ParalysisPotion,
663                  InflictFear, ArcaneVision, KillShot, DragonsBreath, GlacialShard, BlackArrow, DivineKnowledge, LightningVortex,
664                  SolarFlare, PrimalBurst, RagingStorm, GiantCyclone, UnleashDarkness, ChargedOrb, UnholyMight, PowerShield, HallowedMist,
665                  EmbraceLight, AcidRain, BoneFlurry, Rejuvenation, DeathGrip, SummonSwarm, MagicalCharm, EnchantedSilence, SolemnStrike,
666                  ImpendingDoom, SpreadingFlames, ShadowLance, HauntedCurse, LightningShock, PowerSurge}
667     uint16 constant numSpells = 50;
668 
669     function getSpell(uint32 randomSeed) public constant returns (Spells spell) {
670         return Spells(randomSeed % numSpells);
671     }
672 }
673 
674 
675 contract SharedNeutralMutations {
676     enum Mutations {Frontline, CallReinforcements, ArmorPiercing, Battlecry, HealAlly, LevelUp, SecondWind, ChargingStrike, SpellShield, AugmentMagic, CrystalSiphon, 
677                     ManipulateCrystals, DeadlyDemise, FlameResistance, IceResistance, LightningResistance, PoisonResistance, CurseResistance, DragonSlayer, SpiderlingSlayer,
678                     VampireSlayer, DemonSlayer, HumanoidSlayer, BeastSlayer, UndeadSlayer, SerpentSlayer, MechSlayer, GolemSlayer, ElementalSlayer, ParasiteSlayer}
679     uint16 constant numMutations = 30;
680 
681     function getMutation(uint32 randomSeed) public constant returns (Mutations mutation) {
682         return Mutations(randomSeed % numMutations);
683     }
684 }
685 
686 
687 contract DragonMutations {
688     enum RaceMutations {FireBreath, HornedTail, BloodMagic, BarbedScales, WingedFlight, EggSpawn, Chronoshift, PhoenixFeathers}
689     uint16 constant numMutations = 8;
690 
691     function getRaceMutation(uint32 randomSeed) public constant returns (RaceMutations mutation) {
692         return RaceMutations(randomSeed % numMutations);
693     }
694 }
695 
696 contract SpiderlingMutations {
697     enum RaceMutations {CripplingBite, BurrowTrap, SkitteringFrenzy, EggSpawn, CritterRush, WebCocoon, SummonBroodmother, TremorSense}
698     uint16 constant numMutations = 8;
699 
700     function getRaceMutation(uint32 randomSeed) public constant returns (RaceMutations mutation) {
701         return RaceMutations(randomSeed % numMutations);
702     }
703 }
704 
705 contract VampireMutations {
706     enum RaceMutations {Bloodlink, LifeLeech, Bloodlust, DiamondSkin, TwilightVision, Regeneration, PiercingFangs, Shadowstrike}
707     uint16 constant numMutations = 8;
708 
709     function getRaceMutation(uint32 randomSeed) public constant returns (RaceMutations mutation) {
710         return RaceMutations(randomSeed % numMutations);
711     }
712 }
713 
714 contract DemonMutations {
715     enum RaceMutations {PyreScales, ShadowRealm, MenacingGaze, Hellfire, RaiseAsh, TailLash, ReapSouls, BladedTalons}
716     uint16 constant numMutations = 8;
717 
718     function getRaceMutation(uint32 randomSeed) public constant returns (RaceMutations mutation) {
719         return RaceMutations(randomSeed % numMutations);
720     }
721 }
722 
723 contract HumanoidMutations {
724     enum RaceMutations {Garrison, Entrench, Flagbearer, LegionCommander, ScoutAhead, Vengeance, EnchantedBlade, HorseRider}
725     uint16 constant numMutations = 8;
726 
727     function getRaceMutation(uint32 randomSeed) public constant returns (RaceMutations mutation) {
728         return RaceMutations(randomSeed % numMutations);
729     }
730 }
731 
732 contract BeastMutations {
733     enum RaceMutations {FeralRoar, FelineClaws, PrimitiveTusks, ArcticFur, PackHunter, FeignDeath, RavenousBite, NightProwl}
734     uint16 constant numMutations = 8;
735 
736     function getRaceMutation(uint32 randomSeed) public constant returns (RaceMutations mutation) {
737         return RaceMutations(randomSeed % numMutations);
738     }
739 }
740 
741 contract UndeadMutations {
742     enum RaceMutations {Reconstruct, AnimateDead, Pestilence, CrystalSkull, PsychicScreech, RavageSwipe, SpiritForm, BoneSpikes}
743     uint16 constant numMutations = 8;
744 
745     function getRaceMutation(uint32 randomSeed) public constant returns (RaceMutations mutation) {
746         return RaceMutations(randomSeed % numMutations);
747     }
748 }
749 
750 contract SerpentMutations {
751     enum RaceMutations {Constrict, BurrowingStrike, PetrifyingGaze, EggSpawn, ShedScales, StoneBasilisk, EngulfPrey, SprayVenom}
752     uint16 constant numMutations = 8;
753 
754     function getRaceMutation(uint32 randomSeed) public constant returns (RaceMutations mutation) {
755         return RaceMutations(randomSeed % numMutations);
756     }
757 }
758 
759 contract MechMutations {
760     enum RaceMutations {WhirlingBlade, RocketBoosters, SelfDestruct, EMPScramble, SpareParts, Deconstruct, TwinCannons, PowerShield}
761     uint16 constant numMutations = 8;
762 
763     function getRaceMutation(uint32 randomSeed) public constant returns (RaceMutations mutation) {
764         return RaceMutations(randomSeed % numMutations);
765     }
766 }
767 
768 contract GolemMutations {
769     enum RaceMutations {StoneSentinel, ShatteringSmash, AnimateMud, MoltenCore, TremorGround, VineSprouts, ElementalRoar, FossilArmy}
770     uint16 constant numMutations = 8;
771 
772     function getRaceMutation(uint32 randomSeed) public constant returns (RaceMutations mutation) {
773         return RaceMutations(randomSeed % numMutations);
774     }
775 }
776 
777 contract ElementalMutations {
778     enum RaceMutations {Sandstorm, SolarFlare, ElectricSurge, AquaRush, SpiritChannel, PhaseShift, CosmicAura, NaturesWrath}
779     uint16 constant numMutations = 8;
780 
781     function getRaceMutation(uint32 randomSeed) public constant returns (RaceMutations mutation) {
782         return RaceMutations(randomSeed % numMutations);
783     }
784 }
785 
786 contract ParasiteMutations {
787     enum RaceMutations {Infestation, BloodLeech, Corruption, ProtectiveShell, TailSwipe, ExposeWound, StingingTentacles, EruptiveGut}
788     uint16 constant numMutations = 8;
789 
790     function getRaceMutation(uint32 randomSeed) public constant returns (RaceMutations mutation) {
791         return RaceMutations(randomSeed % numMutations);
792     }
793 }
794 
795 // Pulling checks like this into secondary contract allows for more extensibility in future (LoanMarketplace and so forth.)
796 contract TransferRestrictionVerifier {
797     MappedMarketplace marketplaceContract = MappedMarketplace(0xc3d2736b3e4f0f78457d75b3b5f0191a14e8bd57);
798     
799     function isAvailableForTransfer(uint64 cardId) external constant returns(bool) {
800         return !marketplaceContract.isListed(cardId);
801     }
802 }
803 
804 contract MappedMarketplace {
805     EtherGenCore storageContract; // Main card storage and ERC721 transfer functionality
806     TransferRestrictionVerifier transferRestrictionVerifier; // Allows future stuff (loan marketplace etc.) to restrict listing same card twice
807     
808     uint24 private constant removalDuration = 14 days; // Listings can be pruned from market after 14 days
809     uint8 private constant marketCut = 100; // 1% (not 100% as it is divided)
810     address public owner = 0x08F4aE96b647B30177cc15B21195960625BA4163;
811     bool public paused = false;
812 
813     mapping(uint64 => Listing) private listings;
814     mapping(address => bool) private whitelistedContracts;
815     uint64[] private listedCardIds;
816 
817     struct Listing {
818         uint64 listingPointer; // Index in the Market's listings
819         
820         uint64 cardId;
821         uint64 listTime; // Seconds
822         uint128 startPrice;
823         uint128 endPrice;
824         uint24 priceChangeDuration; // Seconds
825     }
826     
827     function isListed(uint64 cardId) public constant returns(bool) {
828         if (listedCardIds.length == 0) return false;
829         return (listings[cardId].listTime > 0);
830     }
831     
832     function getMarketSize() external constant returns(uint) {
833         return listedCardIds.length;
834     }
835     
836     function listCard(uint64 cardId, uint128 startPrice, uint128 endPrice, uint24 priceChangeDuration) external {
837         require(storageContract.ownerOf(cardId) == msg.sender);
838         require(storageContract.isCardTradeable(cardId));
839         require(transferRestrictionVerifier.isAvailableForTransfer(cardId));
840         require(isWhitelisted(msg.sender));
841         require(!paused);
842         require(startPrice > 99 szabo && startPrice <= 10 ether);
843         require(endPrice > 99 szabo && endPrice <= 10 ether);
844         require(priceChangeDuration > 21599 && priceChangeDuration < 259201); // 6-72 Hours
845        
846         listings[cardId] = Listing(0, cardId, uint64(now), startPrice, endPrice, priceChangeDuration);
847         listings[cardId].listingPointer = uint64(listedCardIds.push(cardId) - 1);
848     }
849     
850     
851     function purchaseCard(uint64 cardId) payable external {
852         require(isListed(cardId));
853         require(!paused);
854 
855         uint256 price = getCurrentPrice(listings[cardId].startPrice, listings[cardId].endPrice, listings[cardId].priceChangeDuration, (uint64(now) - listings[cardId].listTime));
856         require(msg.value >= price);
857         
858         address seller = storageContract.ownerOf(cardId);
859         uint256 sellerProceeds = price - (price / marketCut); // 1% cut
860         
861         removeListingInternal(cardId);
862         seller.transfer(sellerProceeds);
863         
864         uint256 bidExcess = msg.value - price;
865         if (bidExcess > 1 szabo) { // Little point otherwise they'll just pay more in gas
866             msg.sender.transfer(bidExcess);
867         }
868         
869         storageContract.transferFrom(seller, msg.sender, cardId);
870     }
871     
872     function getCurrentPrice(uint128 startPrice, uint128 endPrice, uint24 priceChangeDuration, uint64 secondsSinceListing) public constant returns (uint256) {
873         if (secondsSinceListing >= priceChangeDuration) {
874             return endPrice;
875         } else {
876             int256 totalPriceChange = int256(endPrice) - int256(startPrice); // Can be negative
877             int256 currentPriceChange = totalPriceChange * int256(secondsSinceListing) / int256(priceChangeDuration);
878             return uint256(int256(startPrice) + currentPriceChange);
879         }
880     }
881     
882     function removeListing(uint64 cardId) external {
883         require(isListed(cardId));
884         require(!paused);
885         require(storageContract.ownerOf(cardId) == msg.sender || (now - listings[cardId].listTime) > removalDuration);
886         removeListingInternal(cardId);
887     }
888     
889     function removeListingInternal(uint64 cardId) internal {
890         if (listedCardIds.length > 1) {
891             uint64 rowToDelete = listings[cardId].listingPointer;
892             uint64 keyToMove = listedCardIds[listedCardIds.length - 1];
893             
894             listedCardIds[rowToDelete] = keyToMove;
895             listings[keyToMove].listingPointer = rowToDelete;
896         }
897         
898         listedCardIds.length--;
899         delete listings[cardId];
900     }
901     
902     
903     function getListings() external constant returns (uint64[], address[], uint64[], uint128[], uint128[], uint24[], uint8[14][]) {
904         uint64[] memory cardIds = new uint64[](listedCardIds.length); // Not ideal but web3.js didn't like returning multiple 2d arrays
905         address[] memory cardOwners = new address[](listedCardIds.length);
906         uint64[] memory listTimes = new uint64[](listedCardIds.length);
907         uint128[] memory startPrices = new uint128[](listedCardIds.length);
908         uint128[] memory endPrices = new uint128[](listedCardIds.length);
909         uint24[] memory priceChangeDurations = new uint24[](listedCardIds.length);
910         uint8[14][] memory cardDetails = new uint8[14][](listedCardIds.length);
911         
912         for (uint64 i = 0; i < listedCardIds.length; i++) {
913             Listing memory listing = listings[listedCardIds[i]];
914             cardDetails[i] = storageContract.getCard(listing.cardId);
915             cardOwners[i] = storageContract.ownerOf(listing.cardId);
916             cardIds[i] = listing.cardId;
917             listTimes[i] = listing.listTime;
918             startPrices[i] = listing.startPrice;
919             endPrices[i] = listing.endPrice;
920             priceChangeDurations[i] = listing.priceChangeDuration;
921         }
922         return (cardIds, cardOwners, listTimes, startPrices, endPrices, priceChangeDurations, cardDetails);
923     }
924     
925     function getListingAtPosition(uint64 i) external constant returns (uint128[5]) {
926         Listing memory listing = listings[listedCardIds[i]];
927         return ([listing.cardId, listing.listTime, listing.startPrice, listing.endPrice, listing.priceChangeDuration]);
928     }
929     
930     function getListing(uint64 cardId) external constant returns (uint128[5]) {
931         Listing memory listing = listings[cardId];
932         return ([listing.cardId, listing.listTime, listing.startPrice, listing.endPrice, listing.priceChangeDuration]);
933     }
934     
935     // Contracts can't list cards without contacting us (wallet addresses are unaffected)
936     function isWhitelisted(address seller) internal constant returns (bool) {
937         uint size;
938         assembly { size := extcodesize(seller) }
939         return size == 0 || whitelistedContracts[seller];
940     }
941     
942     function whitelistContract(address seller, bool whitelisted) external {
943         require(msg.sender == owner);
944         whitelistedContracts[seller] = whitelisted;
945     }
946     
947     function updateStorageContract(address newStorage) external {
948         require(msg.sender == owner);
949         storageContract = EtherGenCore(newStorage);
950     }
951     
952     function updateTransferRestrictionVerifier(address newTransferRestrictionVerifier) external {
953         require(msg.sender == owner);
954         transferRestrictionVerifier = TransferRestrictionVerifier(newTransferRestrictionVerifier);
955     }
956     
957     function setPaused(bool shouldPause) external {
958         require(msg.sender == owner);
959         paused = shouldPause;
960     }
961     
962     function updateOwner(address newOwner) external {
963         require(msg.sender == owner);
964         owner = newOwner;
965     }
966     
967     function withdrawBalance() external {
968         require(msg.sender == owner);
969         owner.transfer(this.balance);
970     }
971 
972 }