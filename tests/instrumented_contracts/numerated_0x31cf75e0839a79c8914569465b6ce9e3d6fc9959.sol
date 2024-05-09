1 // EtherGen Contract: 
2 
3 // Base Minting Contract
4 
5 contract CardMintingFacilitator {
6     CardConfig schema = CardConfig(0x08584271df3d0249c2c06ac1bc1237a1dd30cb9a); 
7     EtherGenCore storageContract = EtherGenCore(0x677aa1dc08b9429c595efd4425b2d218cc22fd6e);
8     address public owner = 0x08F4aE96b647B30177cc15B21195960625BA4163;
9     
10     function generateRandomCard(uint32 randomSeed) internal constant returns (uint8[14]) {
11         uint8[14] memory cardDetails;
12        
13         randomSeed = uint32(sha3(block.blockhash(block.number), randomSeed));
14         cardDetails[0] = schema.getType(randomSeed);
15 
16         if (cardDetails[0] == uint8(CardConfig.Type.Monster)) {
17             generateRandomMonster(cardDetails, randomSeed);
18         } else {
19             generateRandomSpell(cardDetails, randomSeed);
20         }
21         
22         randomSeed = uint32(sha3(block.blockhash(block.number), randomSeed));
23         if (randomSeed % 200 == 13) { // Lucky number 13
24             cardDetails[12] = 1; // Secret golden attribute
25         }
26         
27         return cardDetails;
28     }
29     
30     function generateRandomMonster(uint8[14] cardDetails, uint32 randomSeed) internal constant {
31         uint24 totalCost;
32         
33         randomSeed = uint32(sha3(block.blockhash(block.number), randomSeed));
34         cardDetails[1] = schema.getRace(randomSeed);
35         totalCost += schema.getCostForRace(cardDetails[1]);
36 
37         randomSeed = uint32(sha3(block.blockhash(block.number), randomSeed));
38         cardDetails[2] = schema.getTrait(randomSeed);
39         totalCost += schema.getCostForTrait(cardDetails[2]);
40 
41         uint8 newMutation;
42         uint24 newMutationCost;
43         randomSeed = uint32(sha3(block.blockhash(block.number), randomSeed));
44         
45         uint8 numMutations = uint8(randomSeed % 12); // 0 = 0 mutations, 1 = 1 mutation, 2-5 = 2 mutations, 6-11 = 3 mutations 
46         if (numMutations > 5) {
47             numMutations = 3;
48         } else if (numMutations > 2) {
49             numMutations = 2;
50         }
51         
52         for (uint8 i = 0; i < numMutations; i++) {
53             randomSeed = uint32(sha3(block.blockhash(block.number), randomSeed));
54             if (bool(randomSeed % 3 == 0)) { // 0: Race; 1-2: Neutral
55                 randomSeed = uint32(sha3(block.blockhash(block.number), randomSeed));
56 
57                 // Horribly add new mutations (rather than looping for a fresh one) this is cheaper
58                 (newMutationCost, newMutation) = schema.getMutationForRace(CardConfig.Race(cardDetails[1]), randomSeed);
59                 if (totalCost + newMutationCost < 290000) {
60                     if (cardDetails[6] == 0) {
61                         cardDetails[6] = newMutation;
62                         totalCost += newMutationCost;
63                     } else if (cardDetails[6] > 0 && cardDetails[7] == 0 && cardDetails[6] != newMutation) {
64                         cardDetails[7] = newMutation;
65                         totalCost += newMutationCost;
66                     } else if  (cardDetails[6] > 0 && cardDetails[7] > 0 && cardDetails[8] == 0 && cardDetails[6] != newMutation && cardDetails[7] != newMutation) {
67                         cardDetails[8] = newMutation;
68                         totalCost += newMutationCost;
69                     }
70                 }
71             } else {
72                 randomSeed = uint32(sha3(block.blockhash(block.number), randomSeed));
73 
74                 // Horribly add new mutations (rather than looping for a fresh one) this is cheaper
75                 (newMutationCost, newMutation) = schema.getNeutralMutation(randomSeed);
76                 if (totalCost + newMutationCost < 290000) {
77                     if (cardDetails[9] == 0) {
78                         cardDetails[9] = newMutation;
79                         totalCost += newMutationCost;
80                     } else if (cardDetails[9] > 0 && cardDetails[10] == 0 && cardDetails[9] != newMutation) {
81                         cardDetails[10] = newMutation;
82                         totalCost += newMutationCost;
83                     } else if (cardDetails[9] > 0 && cardDetails[10] > 0 && cardDetails[11] == 0 && cardDetails[9] != newMutation && cardDetails[10] != newMutation) {
84                         cardDetails[11] = newMutation;
85                         totalCost += newMutationCost;
86                     }
87                 }
88             }
89         }
90 
91         // For attack & health distribution
92         randomSeed = uint32(sha3(block.blockhash(block.number), randomSeed));
93         uint24 powerCost = schema.getCostForHealth(1) + uint24(randomSeed % (301000 - (totalCost + schema.getCostForHealth(1)))); // % upto 300999 will allow 30 cost cards
94 
95         if (totalCost + powerCost < 100000) { // Cards should cost at least 10 crystals (10*10000 exponant)
96             powerCost = 100000 - totalCost;
97         }
98         
99         randomSeed = uint32(sha3(block.blockhash(block.number), randomSeed));
100         cardDetails[5] = 1 + uint8(schema.getHealthForCost(randomSeed % powerCost)); // should be (1 + powerCost - schema.getCostForHealth(1))
101         totalCost += schema.getCostForHealth(cardDetails[5]);
102         
103         powerCost = powerCost - schema.getCostForHealth(cardDetails[5]); // Power left for attack
104         cardDetails[4] = uint8(schema.getAttackForCost(powerCost));
105         totalCost += schema.getCostForAttack(cardDetails[4]);
106        
107         // Remove exponent to get total card cost [10-30]
108         cardDetails[3] = uint8(totalCost / 10000);
109     }
110     
111     
112     function generateRandomSpell(uint8[14] cardDetails, uint32 randomSeed) internal constant {
113         uint24 totalCost;
114         
115         uint8 newAbility;
116         uint24 newAbilityCost;
117         randomSeed = uint32(sha3(block.blockhash(block.number), randomSeed));
118         
119         uint8 numAbilities = uint8(randomSeed % 16); // 0 = 1 ability, 1-8 = 2 abilities, 9-15 = 3 abilities 
120         if (numAbilities > 8) {
121             numAbilities = 3;
122         } else if (numAbilities > 0) {
123             numAbilities = 2;
124         } else {
125             numAbilities = 1;
126         }
127         
128         for (uint8 i = 0; i < numAbilities; i++) {
129             randomSeed = uint32(sha3(block.blockhash(block.number), randomSeed));
130 
131             // Horribly add new spell abilities (rather than looping for a fresh one) this is cheaper
132             (newAbilityCost, newAbility) = schema.getSpellAbility(randomSeed);
133             if (totalCost + newAbilityCost <= 300000) {
134                 if (cardDetails[9] == 0) {
135                     cardDetails[9] = newAbility;
136                     totalCost += newAbilityCost;
137                 } else if (cardDetails[9] > 0 && cardDetails[10] == 0 && cardDetails[9] != newAbility) {
138                     cardDetails[10] = newAbility;
139                     totalCost += newAbilityCost;
140                 } else if (cardDetails[9] > 0 && cardDetails[10] > 0 && cardDetails[11] == 0 && cardDetails[9] != newAbility && cardDetails[10] != newAbility) {
141                     cardDetails[11] = newAbility;
142                     totalCost += newAbilityCost;
143                 }
144             }
145         }
146         
147         // Remove exponent to get total card cost [10-30]
148         cardDetails[3] = uint8(totalCost / 10000);
149     }
150     
151     
152     function generateCostFromAttributes(uint8[14] cardDetails) internal constant returns (uint8 cost) {
153         uint24 exponentCost = 0;
154         if (cardDetails[0] == 1) { // Spell
155             exponentCost += schema.getSpellAbilityCost(cardDetails[9]);
156             exponentCost += schema.getSpellAbilityCost(cardDetails[10]);
157             exponentCost += schema.getSpellAbilityCost(cardDetails[11]);
158         } else {
159             exponentCost += schema.getCostForRace(cardDetails[1]);
160             exponentCost += schema.getCostForTrait(cardDetails[2]);
161             exponentCost += schema.getCostForAttack(cardDetails[4]);
162             exponentCost += schema.getCostForHealth(cardDetails[5]);
163             exponentCost += schema.getRaceMutationCost(CardConfig.Race(cardDetails[1]), cardDetails[6]);
164             exponentCost += schema.getRaceMutationCost(CardConfig.Race(cardDetails[1]), cardDetails[7]);
165             exponentCost += schema.getRaceMutationCost(CardConfig.Race(cardDetails[1]), cardDetails[8]);
166             exponentCost += schema.getNeutralMutationCost(cardDetails[9]);
167             exponentCost += schema.getNeutralMutationCost(cardDetails[10]);
168             exponentCost += schema.getNeutralMutationCost(cardDetails[11]);
169         }
170         return uint8(exponentCost / 10000); // Everything is factor 10000 for ease of autonomous Workshop cost-tuning
171     }
172     
173     // Allows future extensibility (New card mutations + Workshop updates)
174     function upgradeCardConfig(address newCardConfig) external {
175         require(msg.sender == owner);
176         schema = CardConfig(newCardConfig);
177     }
178     
179     function updateStorageContract(address newStorage) external {
180         require(msg.sender == owner);
181         storageContract = EtherGenCore(newStorage);
182     }
183     
184     function updateOwner(address newOwner) external {
185         require(msg.sender == owner);
186         owner = newOwner;
187     }
188 }
189 
190 
191 
192 
193 
194 
195 //// Card Promotion + Referrals
196 
197 contract NewUserBonusDistributor is CardMintingFacilitator {
198     mapping(address => bool) private claimedAddresses; // You only get one free card for 'signing up'
199     bool public newUserBonusCardTradable = true; // If people abuse new user bonus they will be made untradable (but unlocked via battle)
200     
201     address[] public referals; // Array to store all unpaid referal cards
202     
203     function claimFreeFirstCard(address referer) external {
204         require(!claimedAddresses[msg.sender]);
205         
206         uint8[14] memory newCard = generateRandomCard(uint32(msg.sender));
207         if (!newUserBonusCardTradable) {
208             newCard[13] = 1;
209         }
210         claimedAddresses[msg.sender] = true;
211         storageContract.mintCard(msg.sender, newCard);
212         allocateReferalBonus(referer);
213     }
214     
215     function hasAlreadyClaimed() external constant returns (bool) {
216         return claimedAddresses[msg.sender];
217     }
218     
219     function allocateReferalBonus(address referer) internal {
220         // To save new players gas, referals will be async and payed out manually by our team
221         if (referer != address(0) && referer != msg.sender) {
222             referals.push(referer);
223             referals.push(msg.sender);
224         }
225     }
226     
227     function awardReferalBonus() external {
228         // To save new players gas, referals are payed out below manually (by our team + kind gas donors)
229         require(referals.length > 0);
230         address recipient = referals[referals.length - 1];
231         uint8[14] memory newCard = generateRandomCard(uint32(storageContract.totalSupply() * now));
232         newCard[13] = 1; // Referal cards untradable to prevent abuse (unlocked via battle)
233         
234         delete referals[referals.length - 1];
235         referals.length--;
236         storageContract.mintCard(recipient, newCard);
237     }
238     
239     function setNewUserBonusCardTradable(bool tradable) external {
240         require(msg.sender == owner);
241         newUserBonusCardTradable = tradable;
242     }
243     
244 }
245 
246 
247 
248 
249 
250 
251 
252 
253 
254 
255 // Interface for contracts conforming to ERC-721: Non-Fungible Tokens
256 contract ERC721 {
257 
258     // Required methods
259     function totalSupply() public view returns (uint256 cards);
260     function balanceOf(address player) public view returns (uint256 balance);
261     function ownerOf(uint256 cardId) external view returns (address owner);
262     function approve(address to, uint256 cardId) external;
263     function transfer(address to, uint256 cardId) external;
264     function transferFrom(address from, address to, uint256 cardId) external;
265 
266     // Events
267     event Transfer(address from, address to, uint256 cardId);
268     event Approval(address owner, address approved, uint256 cardId);
269 
270     // Name and symbol of the non fungible token, as defined in ERC721.
271     string public constant name = "EtherGen";
272     string public constant symbol = "ETG";
273 
274     // Optional methods
275     function tokensOfOwner(address player) external view returns (uint64[] cardIds);
276 }
277 
278 
279 // Base Storage for EtherGen
280 contract PlayersCollectionStorage {
281     
282     mapping(address => PlayersCollection) internal playersCollections;
283     mapping(uint64 => Card) internal cardIdMapping;
284 
285     struct PlayersCollection {
286         uint64[] cardIds;
287         bool referalCardsUnlocked;
288     }
289 
290     struct Card {
291         uint64 id;
292         uint64 collectionPointer; // Index in player's collection
293         address owner;
294         
295         uint8 cardType;
296         uint8 race;
297         uint8 trait;
298 
299         uint8 cost; // [10-30]
300         uint8 attack; // [0-99]
301         uint8 health; // [1-99]
302 
303         uint8 raceMutation0; // Super ugly but dynamic length arrays are currently a no-go across contracts
304         uint8 raceMutation1; // + very expensive gas since cards are in nested structs (collection of cards)
305         uint8 raceMutation2;
306 
307         uint8 neutralMutation0;
308         uint8 neutralMutation1;
309         uint8 neutralMutation2;
310 
311         /**
312          * Initally referal (free) cards will be untradable (to stop abuse) however EtherGenCore has
313          * unlockUntradeableCards() to make them tradeable -triggered once player hits certain battle/game milestone
314          */
315         bool isReferalReward;
316         bool isGolden; // Top secret Q2 animated art
317     }
318     
319     function getPlayersCollection(address player) public constant returns (uint64[], uint8[14][]) {
320         uint8[14][] memory cardDetails = new uint8[14][](playersCollections[player].cardIds.length);
321         uint64[] memory cardIds = new uint64[](playersCollections[player].cardIds.length);
322 
323         for (uint32 i = 0; i < playersCollections[player].cardIds.length; i++) {
324             Card memory card = cardIdMapping[playersCollections[player].cardIds[i]];
325             cardDetails[i][0] = card.cardType;
326             cardDetails[i][1] = card.race;
327             cardDetails[i][2] = card.trait;
328             cardDetails[i][3] = card.cost;
329             cardDetails[i][4] = card.attack;
330             cardDetails[i][5] = card.health;
331             cardDetails[i][6] = card.raceMutation0;
332             cardDetails[i][7] = card.raceMutation1;
333             cardDetails[i][8] = card.raceMutation2;
334             cardDetails[i][9] = card.neutralMutation0;
335             cardDetails[i][10] = card.neutralMutation1;
336             cardDetails[i][11] = card.neutralMutation2;
337 
338             cardDetails[i][12] = card.isGolden ? 1 : 0; // Not ideal but web3.js didn't like returning multiple 2d arrays
339             cardDetails[i][13] = isCardTradeable(card) ? 1 : 0;
340             
341             cardIds[i] = card.id;
342         }
343         return (cardIds, cardDetails);
344     }
345     
346     function getCard(uint64 cardId) public constant returns (uint8[14]) {
347         Card memory card = cardIdMapping[cardId];
348         return ([card.cardType, card.race, card.trait, card.cost, card.attack, card.health,
349                  card.raceMutation0, card.raceMutation1, card.raceMutation2,
350                  card.neutralMutation0, card.neutralMutation1, card.neutralMutation2,
351                  card.isGolden ? 1 : 0, 
352                  isCardTradeable(card) ? 1 : 0]);
353     }
354     
355     function isCardTradeable(Card card) internal constant returns(bool) {
356         return (playersCollections[card.owner].referalCardsUnlocked || !card.isReferalReward);
357     }
358     
359     function isCardTradeable(uint64 cardId) external constant returns(bool) {
360         return isCardTradeable(cardIdMapping[cardId]);
361     }
362 }
363 
364 
365 
366 // Extensibility of storage + ERCness
367 contract EtherGenCore is PlayersCollectionStorage, ERC721 {
368     
369     mapping(address => bool) private privilegedTransferModules; // Marketplace ( + future features)
370     mapping(address => bool) private privilegedMintingModules; // Referals, Fusing, Workshop etc. ( + future features)
371     
372     mapping(uint64 => address) private cardIdApproveds; // Approval list (ERC721 transfers)
373     uint64 private totalCardSupply; // Also used for cardId incrementation
374     
375     TransferRestrictionVerifier transferRestrictionVerifier = TransferRestrictionVerifier(0xd9861d9a6111bfbb9235a71151f654d0fe7ed954); 
376     address public owner = 0x08F4aE96b647B30177cc15B21195960625BA4163;
377     bool public paused = false;
378     
379     function totalSupply() public view returns (uint256 cards) {
380         return totalCardSupply;
381     }
382     
383     function ownerOf(uint256 cardId) external view returns (address cardOwner) {
384         return cardIdMapping[uint64(cardId)].owner;
385     }
386     
387     function balanceOf(address player) public view returns (uint256 balance) {
388         return playersCollections[player].cardIds.length;
389     }
390     
391     function tokensOfOwner(address player) external view returns (uint64[] cardIds) {
392         return playersCollections[player].cardIds;
393     }
394     
395     function transfer(address newOwner, uint256 cardId) external {
396         uint64 castCardId = uint64(cardId);
397         require(cardIdMapping[castCardId].owner == msg.sender);
398         require(isCardTradeable(cardIdMapping[castCardId]));
399         require(transferRestrictionVerifier.isAvailableForTransfer(castCardId));
400         require(!paused);
401         
402         removeCardOwner(castCardId);
403         assignCardOwner(newOwner, castCardId);
404         Transfer(msg.sender, newOwner, castCardId); // Emit Event
405     }
406     
407     function transferFrom(address currentOwner, address newOwner, uint256 cardId) external {
408         uint64 castCardId = uint64(cardId);
409         require(cardIdMapping[castCardId].owner == currentOwner);
410         require(isApprovedTransferer(msg.sender, castCardId));
411         require(isCardTradeable(cardIdMapping[castCardId]));
412         require(transferRestrictionVerifier.isAvailableForTransfer(castCardId));
413         require(!paused);
414         
415         removeCardOwner(castCardId);
416         assignCardOwner(newOwner, castCardId);
417         Transfer(currentOwner, newOwner, castCardId); // Emit Event
418     }
419     
420     function approve(address approved, uint256 cardId) external {
421         uint64 castCardId = uint64(cardId);
422         require(cardIdMapping[castCardId].owner == msg.sender);
423         
424         cardIdApproveds[castCardId] = approved; // Register approval (replacing previous)
425         Approval(msg.sender, approved, castCardId); // Emit Event
426     }
427     
428     function isApprovedTransferer(address approvee, uint64 cardId) internal constant returns (bool) {
429         // Will only return true if approvee (msg.sender) is a privileged transfer address (Marketplace) or santioned by card's owner using ERC721's approve()
430         return privilegedTransferModules[approvee] || cardIdApproveds[cardId] == approvee;
431     }
432     
433     function removeCardOwner(uint64 cardId) internal {
434         address cardOwner = cardIdMapping[cardId].owner;
435 
436         if (playersCollections[cardOwner].cardIds.length > 1) {
437             uint64 rowToDelete = cardIdMapping[cardId].collectionPointer;
438             uint64 cardIdToMove = playersCollections[cardOwner].cardIds[playersCollections[cardOwner].cardIds.length - 1];
439             playersCollections[cardOwner].cardIds[rowToDelete] = cardIdToMove;
440             cardIdMapping[cardIdToMove].collectionPointer = rowToDelete;
441         }
442         
443         playersCollections[cardOwner].cardIds.length--;
444         cardIdMapping[cardId].owner = 0;
445     }
446     
447     function assignCardOwner(address newOwner, uint64 cardId) internal {
448         if (newOwner != address(0)) {
449             cardIdMapping[cardId].owner = newOwner;
450             cardIdMapping[cardId].collectionPointer = uint64(playersCollections[newOwner].cardIds.push(cardId) - 1);
451         }
452     }
453     
454     function mintCard(address recipient, uint8[14] cardDetails) external {
455         require(privilegedMintingModules[msg.sender]);
456         require(!paused);
457         
458         Card memory card;
459         card.owner = recipient;
460         
461         card.cardType = cardDetails[0];
462         card.race = cardDetails[1];
463         card.trait = cardDetails[2];
464         card.cost = cardDetails[3];
465         card.attack = cardDetails[4];
466         card.health = cardDetails[5];
467         card.raceMutation0 = cardDetails[6];
468         card.raceMutation1 = cardDetails[7];
469         card.raceMutation2 = cardDetails[8];
470         card.neutralMutation0 = cardDetails[9];
471         card.neutralMutation1 = cardDetails[10];
472         card.neutralMutation2 = cardDetails[11];
473         card.isGolden = cardDetails[12] == 1;
474         card.isReferalReward = cardDetails[13] == 1;
475         
476         card.id = totalCardSupply;
477         totalCardSupply++;
478 
479         cardIdMapping[card.id] = card;
480         cardIdMapping[card.id].collectionPointer = uint64(playersCollections[recipient].cardIds.push(card.id) - 1);
481     }
482     
483     // Management functions to facilitate future contract extensibility, unlocking of (untradable) referal bonus cards and contract ownership
484     
485     function unlockUntradeableCards(address player) external {
486         require(privilegedTransferModules[msg.sender]);
487         playersCollections[player].referalCardsUnlocked = true;
488     }
489     
490     function manageApprovedTransferModule(address moduleAddress, bool isApproved) external {
491         require(msg.sender == owner);
492         privilegedTransferModules[moduleAddress] = isApproved; 
493     }
494     
495      function manageApprovedMintingModule(address moduleAddress, bool isApproved) external {
496         require(msg.sender == owner);
497         privilegedMintingModules[moduleAddress] = isApproved; 
498     }
499     
500     function updateTransferRestrictionVerifier(address newTransferRestrictionVerifier) external {
501         require(msg.sender == owner);
502         transferRestrictionVerifier = TransferRestrictionVerifier(newTransferRestrictionVerifier);
503     }
504     
505     function setPaused(bool shouldPause) external {
506         require(msg.sender == owner);
507         paused = shouldPause;
508     }
509     
510     function updateOwner(address newOwner) external {
511         require(msg.sender == owner);
512         owner = newOwner;
513     }
514     
515 }
516 
517 
518 
519 
520 contract CardConfig {
521     enum Type {Monster, Spell} // More could come!
522 
523     enum Race {Dragon, Spiderling, Demon, Humanoid, Beast, Undead, Elemental, Vampire, Serpent, Mech, Golem, Parasite}
524     uint16 constant numRaces = 12;
525 
526     enum Trait {Normal, Fire, Poison, Lightning, Ice, Divine, Shadow, Arcane, Cursed, Void}
527     uint16 constant numTraits = 10;
528 
529     function getType(uint32 randomSeed) public constant returns (uint8) {
530         if (randomSeed % 5 > 0) { // 80% chance for monster (spells are less fun so make up for it in rarity)
531             return uint8(Type.Monster);
532         } else {
533             return uint8(Type.Spell);
534         }
535     }
536     
537     function getRace(uint32 randomSeed) public constant returns (uint8) {
538         return uint8(Race(randomSeed % numRaces));
539     }
540 
541     function getTrait(uint32 randomSeed) public constant returns (uint8) {
542         return uint8(Trait(randomSeed % numTraits));
543     }
544 
545     SpellAbilities spellAbilities = new SpellAbilities();
546     SharedNeutralMutations neutralMutations = new SharedNeutralMutations();
547     DragonMutations dragonMutations = new DragonMutations();
548     SpiderlingMutations spiderlingMutations = new SpiderlingMutations();
549     DemonMutations demonMutations = new DemonMutations();
550     HumanoidMutations humanoidMutations = new HumanoidMutations();
551     BeastMutations beastMutations = new BeastMutations();
552     UndeadMutations undeadMutations = new UndeadMutations();
553     ElementalMutations elementalMutations = new ElementalMutations();
554     VampireMutations vampireMutations = new VampireMutations();
555     SerpentMutations serpentMutations = new SerpentMutations();
556     MechMutations mechMutations = new MechMutations();
557     GolemMutations golemMutations = new GolemMutations();
558     ParasiteMutations parasiteMutations = new ParasiteMutations();
559     
560 
561     // The powerful schema that will allow the Workshop (crystal) prices to fluctuate based on performance, keeping the game fresh & evolve over time!
562     
563     function getCostForRace(uint8 race) public constant returns (uint8 cost) {
564         return 0; // born equal (under current config)
565     }
566     
567     function getCostForTrait(uint8 trait) public constant returns (uint24 cost) {
568         if (trait == uint8(CardConfig.Trait.Normal)) {
569             return 0;
570         }
571         return 40000;
572     }
573     
574     function getSpellAbility(uint32 randomSeed) public constant returns (uint24 cost, uint8 spell) {
575         spell = uint8(spellAbilities.getSpell(randomSeed)) + 1;
576         return (getSpellAbilityCost(spell), spell);
577     }
578     
579     function getSpellAbilityCost(uint8 spell) public constant returns (uint24 cost) {
580         return 100000;
581     }
582 
583     function getNeutralMutation(uint32 randomSeed) public constant returns (uint24 cost, uint8 mutation) {
584         mutation = uint8(neutralMutations.getMutation(randomSeed)) + 1;
585         return (getNeutralMutationCost(mutation), mutation);
586     }
587     
588     function getNeutralMutationCost(uint8 mutation) public constant returns (uint24 cost) {
589         if (mutation == 0) {
590             return 0;   
591         }
592         return 40000;
593     }
594 
595     function getMutationForRace(Race race, uint32 randomSeed) public constant returns (uint24 cost, uint8 mutation) {
596         if (race == Race.Dragon) {
597             mutation = uint8(dragonMutations.getRaceMutation(randomSeed)) + 1;
598         } else if (race == Race.Spiderling) {
599             mutation = uint8(spiderlingMutations.getRaceMutation(randomSeed)) + 1;
600         } else if (race == Race.Demon) {
601             mutation = uint8(demonMutations.getRaceMutation(randomSeed)) + 1;
602         } else if (race == Race.Humanoid) {
603             mutation = uint8(humanoidMutations.getRaceMutation(randomSeed)) + 1;
604         } else if (race == Race.Beast) {
605             mutation = uint8(beastMutations.getRaceMutation(randomSeed)) + 1;
606         } else if (race == Race.Undead) {
607             mutation = uint8(undeadMutations.getRaceMutation(randomSeed)) + 1;
608         } else if (race == Race.Elemental) {
609             mutation = uint8(elementalMutations.getRaceMutation(randomSeed)) + 1;
610         } else if (race == Race.Vampire) {
611             mutation = uint8(vampireMutations.getRaceMutation(randomSeed)) + 1;
612         } else if (race == Race.Serpent) {
613             mutation = uint8(serpentMutations.getRaceMutation(randomSeed)) + 1;
614         } else if (race == Race.Mech) {
615             mutation = uint8(mechMutations.getRaceMutation(randomSeed)) + 1;
616         } else if (race == Race.Golem) {
617             mutation = uint8(golemMutations.getRaceMutation(randomSeed)) + 1;
618         } else if (race == Race.Parasite) {
619             mutation = uint8(parasiteMutations.getRaceMutation(randomSeed)) + 1;
620         }
621         return (getRaceMutationCost(race, mutation), mutation);
622     }
623     
624     function getRaceMutationCost(Race race, uint8 mutation) public constant returns (uint24 cost) {
625         if (mutation == 0) {
626             return 0;   
627         }
628         return 40000;
629     }
630     
631     function getCostForHealth(uint8 health) public constant returns (uint24 cost) {
632         return health * uint24(2000);
633     }
634     
635     function getHealthForCost(uint32 cost) public constant returns (uint32 health) {
636         health = cost / 2000;
637         if (health > 98) { // 1+[0-98] (gotta have [1-99] health)
638             health = 98;
639         }
640         return health;
641     }
642     
643     function getCostForAttack(uint8 attack) public constant returns (uint24 cost) {
644         return attack * uint24(2000);
645     }
646     
647     function getAttackForCost(uint32 cost) public constant returns (uint32 attack) {
648        attack = cost / 2000;
649         if (attack > 99) {
650             attack = 99;
651         }
652         return attack;
653     }
654     
655 }
656 
657 contract SpellAbilities {
658     enum Spells {LavaBlast, FlameNova, Purify, IceBlast, FlashFrost, SnowStorm, FrostFlurry, ChargeFoward, DeepFreeze, ThawTarget,
659                  FlashOfLight, LightBeacon, BlackHole, Earthquake, EnchantArmor, EnchantWeapon, CallReinforcements, ParalysisPotion,
660                  InflictFear, ArcaneVision, KillShot, DragonsBreath, GlacialShard, BlackArrow, DivineKnowledge, LightningVortex,
661                  SolarFlare, PrimalBurst, RagingStorm, GiantCyclone, UnleashDarkness, ChargedOrb, UnholyMight, PowerShield, HallowedMist,
662                  EmbraceLight, AcidRain, BoneFlurry, Rejuvenation, DeathGrip, SummonSwarm, MagicalCharm, EnchantedSilence, SolemnStrike,
663                  ImpendingDoom, SpreadingFlames, ShadowLance, HauntedCurse, LightningShock, PowerSurge}
664     uint16 constant numSpells = 50;
665 
666     function getSpell(uint32 randomSeed) public constant returns (Spells spell) {
667         return Spells(randomSeed % numSpells);
668     }
669 }
670 
671 
672 contract SharedNeutralMutations {
673     enum Mutations {Frontline, CallReinforcements, ArmorPiercing, Battlecry, HealAlly, LevelUp, SecondWind, ChargingStrike, SpellShield, AugmentMagic, CrystalSiphon, 
674                     ManipulateCrystals, DeadlyDemise, FlameResistance, IceResistance, LightningResistance, PoisonResistance, CurseResistance, DragonSlayer, SpiderlingSlayer,
675                     VampireSlayer, DemonSlayer, HumanoidSlayer, BeastSlayer, UndeadSlayer, SerpentSlayer, MechSlayer, GolemSlayer, ElementalSlayer, ParasiteSlayer}
676     uint16 constant numMutations = 30;
677 
678     function getMutation(uint32 randomSeed) public constant returns (Mutations mutation) {
679         return Mutations(randomSeed % numMutations);
680     }
681 }
682 
683 
684 contract DragonMutations {
685     enum RaceMutations {FireBreath, HornedTail, BloodMagic, BarbedScales, WingedFlight, EggSpawn, Chronoshift, PhoenixFeathers}
686     uint16 constant numMutations = 8;
687 
688     function getRaceMutation(uint32 randomSeed) public constant returns (RaceMutations mutation) {
689         return RaceMutations(randomSeed % numMutations);
690     }
691 }
692 
693 contract SpiderlingMutations {
694     enum RaceMutations {CripplingBite, BurrowTrap, SkitteringFrenzy, EggSpawn, CritterRush, WebCocoon, SummonBroodmother, TremorSense}
695     uint16 constant numMutations = 8;
696 
697     function getRaceMutation(uint32 randomSeed) public constant returns (RaceMutations mutation) {
698         return RaceMutations(randomSeed % numMutations);
699     }
700 }
701 
702 contract VampireMutations {
703     enum RaceMutations {Bloodlink, LifeLeech, Bloodlust, DiamondSkin, TwilightVision, Regeneration, PiercingFangs, Shadowstrike}
704     uint16 constant numMutations = 8;
705 
706     function getRaceMutation(uint32 randomSeed) public constant returns (RaceMutations mutation) {
707         return RaceMutations(randomSeed % numMutations);
708     }
709 }
710 
711 contract DemonMutations {
712     enum RaceMutations {PyreScales, ShadowRealm, MenacingGaze, Hellfire, RaiseAsh, TailLash, ReapSouls, BladedTalons}
713     uint16 constant numMutations = 8;
714 
715     function getRaceMutation(uint32 randomSeed) public constant returns (RaceMutations mutation) {
716         return RaceMutations(randomSeed % numMutations);
717     }
718 }
719 
720 contract HumanoidMutations {
721     enum RaceMutations {Garrison, Entrench, Flagbearer, LegionCommander, ScoutAhead, Vengeance, EnchantedBlade, HorseRider}
722     uint16 constant numMutations = 8;
723 
724     function getRaceMutation(uint32 randomSeed) public constant returns (RaceMutations mutation) {
725         return RaceMutations(randomSeed % numMutations);
726     }
727 }
728 
729 contract BeastMutations {
730     enum RaceMutations {FeralRoar, FelineClaws, PrimitiveTusks, ArcticFur, PackHunter, FeignDeath, RavenousBite, NightProwl}
731     uint16 constant numMutations = 8;
732 
733     function getRaceMutation(uint32 randomSeed) public constant returns (RaceMutations mutation) {
734         return RaceMutations(randomSeed % numMutations);
735     }
736 }
737 
738 contract UndeadMutations {
739     enum RaceMutations {Reconstruct, AnimateDead, Pestilence, CrystalSkull, PsychicScreech, RavageSwipe, SpiritForm, BoneSpikes}
740     uint16 constant numMutations = 8;
741 
742     function getRaceMutation(uint32 randomSeed) public constant returns (RaceMutations mutation) {
743         return RaceMutations(randomSeed % numMutations);
744     }
745 }
746 
747 contract SerpentMutations {
748     enum RaceMutations {Constrict, BurrowingStrike, PetrifyingGaze, EggSpawn, ShedScales, StoneBasilisk, EngulfPrey, SprayVenom}
749     uint16 constant numMutations = 8;
750 
751     function getRaceMutation(uint32 randomSeed) public constant returns (RaceMutations mutation) {
752         return RaceMutations(randomSeed % numMutations);
753     }
754 }
755 
756 contract MechMutations {
757     enum RaceMutations {WhirlingBlade, RocketBoosters, SelfDestruct, EMPScramble, SpareParts, Deconstruct, TwinCannons, PowerShield}
758     uint16 constant numMutations = 8;
759 
760     function getRaceMutation(uint32 randomSeed) public constant returns (RaceMutations mutation) {
761         return RaceMutations(randomSeed % numMutations);
762     }
763 }
764 
765 contract GolemMutations {
766     enum RaceMutations {StoneSentinel, ShatteringSmash, AnimateMud, MoltenCore, TremorGround, VineSprouts, ElementalRoar, FossilArmy}
767     uint16 constant numMutations = 8;
768 
769     function getRaceMutation(uint32 randomSeed) public constant returns (RaceMutations mutation) {
770         return RaceMutations(randomSeed % numMutations);
771     }
772 }
773 
774 contract ElementalMutations {
775     enum RaceMutations {Sandstorm, SolarFlare, ElectricSurge, AquaRush, SpiritChannel, PhaseShift, CosmicAura, NaturesWrath}
776     uint16 constant numMutations = 8;
777 
778     function getRaceMutation(uint32 randomSeed) public constant returns (RaceMutations mutation) {
779         return RaceMutations(randomSeed % numMutations);
780     }
781 }
782 
783 contract ParasiteMutations {
784     enum RaceMutations {Infestation, BloodLeech, Corruption, ProtectiveShell, TailSwipe, ExposeWound, StingingTentacles, EruptiveGut}
785     uint16 constant numMutations = 8;
786 
787     function getRaceMutation(uint32 randomSeed) public constant returns (RaceMutations mutation) {
788         return RaceMutations(randomSeed % numMutations);
789     }
790 }
791 
792 // Pulling checks like this into secondary contract allows for more extensibility in future (LoanMarketplace and so forth.)
793 contract TransferRestrictionVerifier {
794     MappedMarketplace marketplaceContract = MappedMarketplace(0xc3d2736b3e4f0f78457d75b3b5f0191a14e8bd57);
795     
796     function isAvailableForTransfer(uint64 cardId) external constant returns(bool) {
797         return !marketplaceContract.isListed(cardId);
798     }
799 }
800 
801 
802 
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