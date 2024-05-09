1 pragma solidity ^0.4.19;
2 
3 contract CraftingInterface {
4     function craft(uint16[16] leftParentRunes, uint16[16] leftParentPowers, uint16[16] rightParentRunes, uint16[16] rightParentPowers) public view returns (uint16[16], uint16[16]);
5 }
6 
7 contract DutchAuctionInterface {
8     function DutchAuction(address etherScrollsAddressess, address _master1, address _master2) public;
9     function payMasters() external;
10     function isForAuction(uint card) public view returns (bool);
11     function getCurrentPrice(uint cardNumber) public view returns (uint);
12     function isValidAuction(uint card) public view returns (bool);
13     function getAuction(uint cardNumber) public view returns(uint startingPrice, uint endingPrice, uint duration, address seller,uint startedAt );
14     function getSellerOfToken(uint cardNumber) public view returns (address);
15 }
16 
17 contract DutchAuctionToBuyInterface is DutchAuctionInterface {
18     function DutchAuctionToBuy(address etherScrollsAddress, address master1, address master2) public;// DutchAuctionInterface(etherScrollsAddress, master1, master2);
19     function startAuction(uint cardNumber, uint startPrice, uint endPrice, uint duration, address seller) public;
20     function priceOfOfficalCardSold() public view returns (uint);
21     function bidFromEtherScrolls(uint cardNumber, address buyer) public payable;
22     function cancelBuyAuction(uint cardNumber, address requestor) public;
23 }
24 
25 contract DutchAuctionToCraftInterface is DutchAuctionInterface {
26     function DutchAuctionToCraft(address etherScrollsAddress, address master1, address master2) public;// DutchAuctionInterface(etherScrollsAddress, master1, master2);
27     function startAuction(uint cardNumber, uint startPrice, uint endPrice, uint duration, address seller) public;
28     function priceOfOfficalCardSold() public view returns (uint);
29     function placeBidFromEtherScrolls(uint _tokenId) public payable;
30     function cancelCraftAuction(uint cardNumber, address requestor) public;
31 }
32 contract Card { 
33 
34     // the erc721 standard of an Ether Scrolls card
35     event Transfer(address indexed from, address indexed to, uint indexed tokenId);
36     event Approval(address indexed owner, address indexed approved, uint indexed tokenId);
37     event CardCreated(address indexed owner, uint cardNumber, uint craftedFromLeft, uint craftedFromRight);
38     event Gift(uint cardId, address sender, address reciever);
39 
40     address public masterAddress1;
41     address public masterAddress2;
42     address public withdrawAddress;
43 
44     struct CardStructure {
45         uint16[16] runes;
46         uint16[16] powers;
47         uint64 createdAt;
48         uint64 canCraftAt;
49         uint32 craftedFromLeft;
50         uint32 craftedFromRight;
51         uint difficulty;
52         uint16 generation;
53     }
54 
55     CardStructure[] allCards;
56 
57     // erc721 used to id owner
58     mapping (uint => address) public indexToOwner; 
59 
60     // part of erc721. used for balanceOf
61     mapping (address => uint) ownershipCount;
62 
63     // part of erc721 used for approval
64     mapping (uint => address) public indexToApproved;
65 
66     function _transfer(address _from, address _to, uint _tokenId) internal {
67      
68         ownershipCount[_to]++;
69         indexToOwner[_tokenId] = _to;
70         // dont record any transfers from the contract itself
71         if (_from != address(this)) {
72             ownershipCount[_from]--;
73         }
74         Transfer(_from, _to, _tokenId);
75     }
76  
77     modifier masterRestricted() {
78         require(msg.sender == masterAddress1 || msg.sender == masterAddress2);
79         _;
80     }
81 
82    function getCard(uint _id) public view returns ( uint difficulty, uint canCraftAt, 
83    uint createdAt, uint craftedFromLeft, uint craftedFromRight, uint generation, uint16[16] runes, uint16[16] powers,
84    address owner) {
85       CardStructure storage card = allCards[_id];
86       difficulty = uint(card.difficulty);
87       canCraftAt = uint(card.canCraftAt);
88       createdAt = uint(card.createdAt);
89       craftedFromLeft = uint(card.craftedFromLeft);
90       craftedFromRight = uint(card.craftedFromRight);
91       generation = uint(card.generation);
92       runes = card.runes;
93       powers = uint16[16](card.powers);
94       owner = address(indexToOwner[_id]);
95     }
96 
97     function _createCard(uint16[16] _runes, uint16[16] _powers, uint _craftedFromLeft, uint _craftedFromRight, uint _generation, 
98     address _owner) internal returns (uint) {
99 
100         CardStructure memory card = CardStructure({
101             runes: uint16[16](_runes),
102             powers: uint16[16](_powers),
103             createdAt: uint64(now),
104             canCraftAt: 0,
105             craftedFromLeft: uint32(_craftedFromLeft),
106             craftedFromRight: uint32(_craftedFromRight),
107             difficulty: 0,
108             generation: uint16(_generation)
109         });
110         
111         uint cardNumber = allCards.push(card) - 1;
112 
113         CardCreated(_owner, cardNumber, uint(card.craftedFromLeft), uint(card.craftedFromRight));
114         _transfer(this, _owner, cardNumber);
115         return cardNumber;
116     }
117 
118     string public name = "EtherScroll";
119     string public symbol = "ES";
120 
121     function implementsERC721() public pure returns (bool) {
122         return true;
123     }
124 
125     function _owns(address _claimant, uint _tokenId) internal view returns (bool) {
126         return indexToOwner[_tokenId] == _claimant;
127     }
128 
129     function hasBeenApproved(address _claimant, uint _tokenId) public view returns (bool) {
130         return indexToApproved[_tokenId] == _claimant;
131     }
132 
133     function _approve(uint _tokenId, address _approved) internal {
134         indexToApproved[_tokenId] = _approved;
135     }
136 
137     function balanceOf(address _owner) public view returns (uint count) {
138         return ownershipCount[_owner];
139     }
140 
141     function transfer(address _to, uint _tokenId) public {
142         require(_owns(msg.sender, _tokenId));
143         require(_to != address(0));
144         _transfer(msg.sender, _to, _tokenId);
145     }
146 
147     function approve(address _to, uint _tokenId) public {
148         require(_owns(msg.sender, _tokenId));
149         _approve(_tokenId, _to);
150         Approval(msg.sender, _to, _tokenId);
151     }
152 
153     function transferFrom(address _from, address _to, uint _tokenId) public {
154         require(_owns(_from, _tokenId));    
155         require(hasBeenApproved(msg.sender, _tokenId));
156         _transfer(_from, _to, _tokenId);
157     }
158 
159     function totalSupply() public view returns (uint) {
160         return allCards.length - 1;
161     }
162 
163     function ownerOf(uint _tokenId) public view returns (address) {
164         address owner = indexToOwner[_tokenId];
165         require(owner != address(0));
166         return owner;
167     }
168     
169 }
170 
171 contract CardMarket is Card { 
172 
173     mapping (uint => uint) public numberOfBasesSold;
174     mapping (uint => uint) public numberOfAbilitiesSold;
175     uint16 lastAbilityToBeAddedToCirculation;
176     uint16 lastBaseToBeAddedToCirculation;
177     uint16[] arrayOfPossibleBases;
178     uint16[] arrayOfPossibleAbilities;
179     CraftingInterface public crafting;
180     uint maxRunes;
181     uint numberOfSpecialCardsCreated;
182      
183     DutchAuctionToBuyInterface public dutchAuctionToBuy;
184     DutchAuctionToCraftInterface public dutchAuctionToCraft;
185 
186     function CardMarket(address master1, address master2, address inputWithdrawAddress) public {
187         
188         masterAddress1 = master1;
189         masterAddress2 = master2;
190         withdrawAddress = inputWithdrawAddress;
191 
192         uint16[16] memory firstCard;
193 
194         _createCard(firstCard, firstCard, 0, 0, 0, master1);
195 
196         maxRunes = 300;
197 
198         arrayOfPossibleBases = [uint16(0),uint16(1),uint16(2),uint16(3),uint16(4),uint16(5),
199         uint16(6),uint16(7),uint16(8),uint16(9),uint16(10),uint16(11),uint16(12),uint16(13),
200         uint16(14),uint16(15),uint16(16),uint16(17),uint16(18),uint16(19)];
201 
202         lastBaseToBeAddedToCirculation = 19;
203 
204         arrayOfPossibleAbilities = [uint16(0),uint16(1),uint16(2),uint16(3),uint16(4),uint16(5),
205         uint16(6),uint16(7),uint16(8),uint16(9),uint16(10),uint16(11),uint16(12),uint16(13),
206         uint16(14),uint16(15),uint16(16),uint16(17),uint16(18),uint16(19)];
207 
208         lastAbilityToBeAddedToCirculation = 19;
209     }
210 
211     function getBases() public view returns (uint16[]) {
212         return arrayOfPossibleBases;
213     }
214 
215      function getAbilities() public view returns (uint16[]) {
216         return arrayOfPossibleAbilities;
217     }
218 
219     // only a max of 250 speical cards can ever be created
220     function createSpecialCards(uint32 count, uint16 base, uint16 ability) public masterRestricted {
221 
222         uint16[16] memory bases = [uint16(0), uint16(1), uint16(2), uint16(3), uint16(4), uint16(5),uint16(6), uint16(0),
223         uint16(1), uint16(2), uint16(3),uint16(4), uint16(5),uint16(6), base, ability];
224         uint16[16] memory powers = [uint16(35), uint16(20), uint16(10), uint16(5), uint16(5), uint16(5), uint16(1), uint16(35),
225         uint16(21), uint16(14), uint16(10),uint16(9), uint16(8), uint16(3), uint16(9), uint16(7)];
226       
227         for (uint i = 0; i < count; i++) {
228            
229             if (base == 0) {
230                 bases[14] = uint16((uint(block.blockhash(block.number - i + 1)) % 20));
231                 bases[15] = uint16((uint(block.blockhash(block.number - i + 2)) % 20));
232             }
233             powers[14] = uint16((uint(block.blockhash(block.number - i + 3)) % 9) + 1);
234             powers[15] = uint16((uint(block.blockhash(block.number - i + 4)) % 9) + 1);
235 
236             if (numberOfSpecialCardsCreated < 250) {
237                 _createCard(bases, powers, 0, 0, 0, msg.sender);
238                 numberOfSpecialCardsCreated++;
239             }
240         }
241     }
242 
243     function withdraw() public {
244         require(msg.sender == masterAddress1 || msg.sender == masterAddress2 || msg.sender == withdrawAddress);
245         dutchAuctionToBuy.payMasters();
246         dutchAuctionToCraft.payMasters();
247         uint halfOfFunds = this.balance / 2;
248         masterAddress1.transfer(halfOfFunds);
249         masterAddress2.transfer(halfOfFunds);
250     }   
251 
252     function setBuyAuctionAddress(address _address) public masterRestricted {
253         dutchAuctionToBuy = DutchAuctionToBuyInterface(_address);
254     }
255 
256     function setCraftAuctionAddress(address _address) public masterRestricted {
257         dutchAuctionToCraft = DutchAuctionToCraftInterface(_address);
258     }
259 
260     function setMasterAddress1(address _newMaster) public {
261         require(msg.sender == masterAddress1);
262         masterAddress1 = _newMaster;
263     }
264 
265     function setMasterAddress2(address _newMaster) public {
266         require(msg.sender == masterAddress2);
267         masterAddress2 = _newMaster;
268     }
269 
270     function cancelAuctionToBuy(uint cardId) public {
271         dutchAuctionToBuy.cancelBuyAuction(cardId, msg.sender);
272     }
273 
274     function cancelCraftingAuction(uint cardId) public {
275         dutchAuctionToCraft.cancelCraftAuction(cardId, msg.sender);
276     }
277 
278     function createDutchAuctionToBuy(uint _cardNumber, uint startPrice, 
279     uint endPrice, uint _lentghOfTime) public {
280         require(_lentghOfTime >= 10 minutes);
281         require(dutchAuctionToBuy.isForAuction(_cardNumber) == false);
282         require(dutchAuctionToCraft.isForAuction(_cardNumber) == false);
283         require(_owns(msg.sender, _cardNumber));
284         _approve(_cardNumber, dutchAuctionToBuy);
285         dutchAuctionToBuy.startAuction(_cardNumber, startPrice, endPrice, _lentghOfTime, msg.sender);
286     }
287 
288     function startCraftingAuction(uint _cardNumber, uint startPrice, uint endPrice,
289     uint _lentghOfTime) public {
290         require(_lentghOfTime >= 1 minutes);
291         require(_owns(msg.sender, _cardNumber));
292         CardStructure storage card = allCards[_cardNumber];
293         require(card.canCraftAt <= now);
294         require(dutchAuctionToBuy.isForAuction(_cardNumber) == false);
295         require(dutchAuctionToCraft.isForAuction(_cardNumber) == false);
296         _approve(_cardNumber, dutchAuctionToCraft);
297         dutchAuctionToCraft.startAuction(_cardNumber, startPrice, endPrice, _lentghOfTime, msg.sender);
298     }
299 
300       // craft two cards. you will get a new card. 
301     function craftTwoCards(uint _craftedFromLeft, uint _craftedFromRight) public {
302         require(_owns(msg.sender, _craftedFromLeft));
303         require(_owns(msg.sender, _craftedFromRight));
304         // make sure that the card that will produce a new card is not up for auction
305         require((isOnAuctionToBuy(_craftedFromLeft) == false) && (isOnCraftingAuction(_craftedFromLeft) == false));
306         require(_craftedFromLeft != _craftedFromRight);
307         CardStructure storage leftCard = allCards[_craftedFromLeft];
308         CardStructure storage rightCard = allCards[_craftedFromRight];
309         require(leftCard.canCraftAt <= now);
310         require(rightCard.canCraftAt <= now);
311         spawnCard(_craftedFromLeft, _craftedFromRight);
312     }
313 
314     function isOnCraftingAuction(uint cardNumber) public view returns (bool) {
315         return (dutchAuctionToCraft.isForAuction(cardNumber) && dutchAuctionToCraft.isValidAuction(cardNumber));
316     }
317 
318     function isOnAuctionToBuy(uint cardNumber) public view returns (bool) {
319         return (dutchAuctionToBuy.isForAuction(cardNumber) && dutchAuctionToBuy.isValidAuction(cardNumber));
320     }
321 
322     function getCardBuyAuction(uint cardNumber) public view returns( uint startingPrice, uint endPrice, uint duration, address seller,
323     uint startedAt ) {
324         return dutchAuctionToBuy.getAuction(cardNumber);
325     }
326 
327     function getCraftingAuction(uint cardNumber) public view returns(uint startingPrice, uint endPrice, uint duration, address seller, 
328     uint startedAt ) {
329         return dutchAuctionToCraft.getAuction(cardNumber);
330     }
331     
332     function getActualPriceOfCardOnBuyAuction (uint cardNumber) public view returns (uint) {
333         return dutchAuctionToBuy.getCurrentPrice(cardNumber);
334     }
335 
336     function getActualPriceOfCardOnCraftAuction (uint cardNumber) public view returns (uint) {
337         return dutchAuctionToCraft.getCurrentPrice(cardNumber);
338     }
339 
340     function setCraftingAddress(address _address) public masterRestricted {
341         CraftingInterface candidateContract = CraftingInterface(_address);
342         crafting = candidateContract;
343     }
344 
345     function getDutchAuctionToCraftAddress() public view returns (address) {
346         return address(dutchAuctionToCraft);
347     }
348 
349      function getDutchAuctionToBuyAddress() public view returns (address) {
350         return address(dutchAuctionToBuy);
351     }
352 
353     function _startCraftRecovery(CardStructure storage card) internal {
354 
355         uint base = card.generation + card.difficulty + 1;
356         if (base < 6) {
357             base = base * (1 minutes);
358         } else if ( base < 11) {
359             base = (base - 5) * (1 hours);
360         } else {
361             base = (base - 10) * (1 days);
362         }
363         base = base * 2;
364         
365         card.canCraftAt = uint64(now + base);
366 
367         if (card.difficulty < 15) {
368             card.difficulty++;
369         }
370     }
371 
372      function bidOnCraftAuction(uint cardIdToBidOn, uint cardIdToCraftWith) public payable {
373         require(_owns(msg.sender, cardIdToCraftWith));
374         CardStructure storage cardToBidOn = allCards[cardIdToBidOn];
375         CardStructure storage cardToCraftWith = allCards[cardIdToCraftWith];
376         require(cardToCraftWith.canCraftAt <= now);
377         require(cardToBidOn.canCraftAt <= now);
378         require(cardIdToBidOn != cardIdToCraftWith);
379         uint bidAmount = msg.value;
380         // the bid funciton ensures that the seller acutally owns the card being sold
381         dutchAuctionToCraft.placeBidFromEtherScrolls.value(bidAmount)(cardIdToBidOn);
382         spawnCard(cardIdToCraftWith, cardIdToBidOn);
383     }
384     
385     function spawnCard(uint _craftedFromLeft, uint _craftedFromRight) internal returns(uint) {
386         CardStructure storage leftCard = allCards[_craftedFromLeft];
387         CardStructure storage rightCard = allCards[_craftedFromRight];
388 
389         _startCraftRecovery(rightCard);
390         _startCraftRecovery(leftCard);
391 
392         uint16 parentGen = leftCard.generation;
393         if (rightCard.generation > leftCard.generation) {
394             parentGen = rightCard.generation;
395         }
396 
397         parentGen += 1;
398         if (parentGen > 18) {
399             parentGen = 18;
400         }
401 
402         uint16[16] memory runes;
403         uint16[16] memory powers;
404 
405         (runes, powers) = crafting.craft(leftCard.runes, leftCard.powers, rightCard.runes, rightCard.powers);
406         address owner = indexToOwner[_craftedFromLeft];
407       
408         return _createCard(runes, powers, _craftedFromLeft, _craftedFromRight, parentGen, owner);
409     }
410 
411     function() external payable {}
412 
413     function bidOnAuctionToBuy(uint cardNumber) public payable {
414         address seller = dutchAuctionToBuy.getSellerOfToken(cardNumber);
415         // make sure that the seller still owns the card
416         uint bidAmount = msg.value;
417         dutchAuctionToBuy.bidFromEtherScrolls.value(bidAmount)(cardNumber, msg.sender);
418         // if a zero generation card was just bought
419         if (seller == address(this)) {
420             spawnNewZeroCardInternal();
421         }
422     }
423 
424     // 250 is the max number of cards that the developers are allowed to print themselves
425     function spawnNewZeroCard() public masterRestricted {
426         if (numberOfSpecialCardsCreated < 250) {
427             spawnNewZeroCardInternal();
428             numberOfSpecialCardsCreated++;
429         }
430     }
431 
432     function spawnNewZeroCardInternal() internal {
433 
434         uint16[16] memory runes = generateRunes();
435         uint16 x = uint16(uint(block.blockhash(block.number - 1)) % 9) + 1;
436         uint16 y = uint16(uint(block.blockhash(block.number - 2)) % 9) + 1;
437     
438         uint16[16] memory powers = [uint16(25), uint16(10), uint16(5), uint16(0), uint16(0), uint16(0), uint16(0),
439                                 uint16(25), uint16(10), uint16(5), uint16(0), uint16(0), uint16(0), uint16(0), x, y];
440         
441         uint cardNumber = _createCard(runes, powers, 0, 0, 0, address(this));
442 
443         _approve(cardNumber, dutchAuctionToBuy);
444 
445         uint price = dutchAuctionToBuy.priceOfOfficalCardSold() * 2;
446         // 11000000000000000 wei is .011 eth
447         if (price < 11000000000000000 ) {
448             price = 11000000000000000;
449         }
450 
451         dutchAuctionToBuy.startAuction(cardNumber, price, 0, 2 days, address(this));
452 
453     }
454 
455     function giftCard(uint cardId, address reciever) public {
456         require((isOnAuctionToBuy(cardId) == false) && (isOnCraftingAuction(cardId) == false));
457         require(ownerOf(cardId) == msg.sender);
458         transfer(reciever, cardId);
459         Gift(cardId, msg.sender, reciever);
460     }
461 
462     function generateRunes() internal returns (uint16[16]) {
463         
464         uint i = 1;
465         uint lastBaseIndex = arrayOfPossibleBases.length;
466         uint16 base1 = uint16(uint(block.blockhash(block.number - i)) % lastBaseIndex); 
467         i++;
468         uint16 base2 = uint16(uint(block.blockhash(block.number - i)) % lastBaseIndex);
469         i++;
470         uint16 base3 = uint16(uint(block.blockhash(block.number - i)) % lastBaseIndex);
471         i++;
472         
473         // ensure that each rune is distinct
474         while (base1 == base2 || base2 == base3 || base3 == base1) {
475             base1 = uint16(uint(block.blockhash(block.number - i)) % lastBaseIndex);
476             i++;
477             base2 = uint16(uint(block.blockhash(block.number - i)) % lastBaseIndex);
478             i++;
479             base3 = uint16(uint(block.blockhash(block.number - i)) % lastBaseIndex);
480             i++;
481         }
482         
483         base1 = arrayOfPossibleBases[base1];
484         base2 = arrayOfPossibleBases[base2];
485         base3 = arrayOfPossibleBases[base3];
486 
487         uint lastAbilityIndex = arrayOfPossibleAbilities.length;
488         uint16 ability1 = uint16(uint(block.blockhash(block.number - i)) % lastAbilityIndex);
489         i++;
490         uint16 ability2 = uint16(uint(block.blockhash(block.number - i)) % lastAbilityIndex);
491         i++;
492         uint16 ability3 = uint16(uint(block.blockhash(block.number - i)) % lastAbilityIndex);
493         i++;
494 
495         // ensure that each rune is distinct
496         while (ability1 == ability2 || ability2 == ability3 || ability3 == ability1) {
497             ability1 = uint16(uint(block.blockhash(block.number - i)) % lastAbilityIndex);
498             i++;
499             ability2 = uint16(uint(block.blockhash(block.number - i)) % lastAbilityIndex);
500             i++;
501             ability3 = uint16(uint(block.blockhash(block.number - i)) % lastAbilityIndex);
502             i++;
503         }
504         
505         ability1 = arrayOfPossibleAbilities[ability1];
506         ability2 = arrayOfPossibleAbilities[ability2];
507         ability3 = arrayOfPossibleAbilities[ability3];
508 
509         numberOfBasesSold[base1]++;
510         numberOfAbilitiesSold[ability1]++;
511 
512         // if we have reached the max number of runes
513         if (numberOfBasesSold[base1] > maxRunes) {
514             // remove the rune from the list of possible runes
515             for (i = 0; i < arrayOfPossibleBases.length; i++ ) {
516                 if (arrayOfPossibleBases[i] == base1) {
517                 // add a new rune to the list
518                 // we dont need a check here to see if lastBaseCardToBeAddedToCirculation overflows because
519                 // the 50k max card limit will expire well before this limit is reached
520                 lastBaseToBeAddedToCirculation++;
521                 arrayOfPossibleBases[i] = lastBaseToBeAddedToCirculation;
522                 break;
523                 }
524             }
525         }
526 
527         if (numberOfAbilitiesSold[ability1] > maxRunes) {
528             // remove the rune from the list of possible runes
529             for (i = 0; i < arrayOfPossibleAbilities.length; i++) {
530                 if (arrayOfPossibleAbilities[i] == ability1) {
531                 // we dont need to check for overflow here because of the 300 rune limits
532                 lastAbilityToBeAddedToCirculation++;
533                 arrayOfPossibleAbilities[i] = lastAbilityToBeAddedToCirculation;
534                 break;
535                 }
536             }
537         }
538 
539         return [base1, base2, base3, uint16(0), uint16(0), uint16(0), uint16(0), 
540                 ability1, ability2, ability3, uint16(0), uint16(0), uint16(0), uint16(0),  base1, ability1];
541     }
542 }
543 
544 
545 contract EtherScrolls is CardMarket {
546 
547     function EtherScrolls(address master1, address master2, address withdrawAddress) public CardMarket(master1, master2, withdrawAddress) {
548        
549     }
550 }