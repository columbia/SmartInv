1 pragma solidity ^0.4.18;
2 
3 contract BCFBase {
4 
5     address public owner;
6     address public editor;
7 
8     bool public paused = false;
9 
10     modifier onlyOwner() {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     modifier onlyEditor() {
16         require(msg.sender == editor);
17         _;
18     }
19 
20     function setOwner(address newOwner) public onlyOwner {
21         require(newOwner != address(0));
22         owner = newOwner;
23     }
24 
25     function setEditor(address newEditor) public onlyOwner {
26         require(newEditor != address(0));
27         editor = newEditor;
28     }
29     
30     modifier whenNotPaused() {
31         require(!paused);
32         _;
33     }
34     
35     modifier whenPaused() {
36         require(paused);
37         _;
38     }
39     
40     function pause() onlyOwner whenNotPaused public {
41         paused = true;
42     }
43     
44     function unpause() onlyOwner whenPaused public {
45         paused = false;
46     }
47 }
48 
49 contract ERC721 {
50 
51     // Events
52     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
53     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
54 
55     // Required
56     function totalSupply() public view returns (uint256 total);
57     function balanceOf(address _owner) public view returns (uint256 balance);
58     function ownerOf(uint256 _tokenId) public view returns (address owner);
59     function approve(address _to, uint256 _tokenId) public;
60     function getApproved(uint _tokenId) public view returns (address approved);
61     function transferFrom(address _from, address _to, uint256 _tokenId) public;
62     function transfer(address _to, uint256 _tokenId) public;
63     function implementsERC721() public pure returns (bool);
64 
65     // Optional
66     // function name() public view returns (string name);
67     // function symbol() public view returns (string symbol);
68     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
69     // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
70 }
71 
72 contract BCFData is BCFBase, ERC721 {
73 
74     // MetaData
75     string public constant NAME = "BlockchainFootball";
76     string public constant SYMBOL = "BCF";
77 
78     struct Player {
79 
80         // Attribute ratings
81         uint8 overall;
82         uint8 pace;
83         uint8 shooting;
84         uint8 passing;
85         uint8 dribbling;
86         uint8 defending;
87         uint8 physical;
88         uint8 form; // No plans to use this atm but offers useful dynamic attribute -- NOT used in v1 of match engine
89 
90         // Level could be stored as an enum but plain ol' uint gives us more flexibility to introduce new levels in future
91         uint8 level; // 1 = Superstar, 2 = Legend, 3 = Gold, 4 = Silver
92         bytes position; // Shortcode - GK, LB, CB, RB, RW, RM, LW, LM, CM, CDM, CAM, ST
93         string name; // First and last - arbitrary-length, hence string over bytes32
94     }
95     
96     struct PlayerCard {
97         uint playerId; // References the index of a player, i.e players[playerId] -- playerId = 0 invalid (non-existant)
98         address owner;
99         address approvedForTransfer;
100         bool isFirstGeneration;
101     }
102     
103     // Player + PlayerCards Database
104     Player[] public players; // Central DB of player attributes
105     PlayerCard[] public playerCards;
106 
107     // Utility mappings to make trading players and checking ownership gas-efficient
108     mapping(address => uint[]) internal ownerToCardsOwned;
109     mapping(uint => uint) internal cardIdToOwnerArrayIndex;
110 
111     // Extended attributes -- for now these are just an indexed list of values. Metadata will describe what each index represents.
112     mapping(uint => uint8[]) public playerIdToExtendedAttributes; // Each index a single unique value > 0 and < 100
113 
114     // ERC721
115     // Note: The standard is still in draft mode, so these are best efforts implementation based
116     // on currently direction of the community and existing contracts which reside in the "wild"
117     function implementsERC721() public pure returns (bool) {
118         return true;
119     }
120 
121     function totalSupply() public view returns (uint) {
122         return playerCards.length;
123     }
124 
125     function balanceOf(address _owner) public view returns (uint256 balance) {
126         return ownerToCardsOwned[_owner].length;
127     }
128 
129     function getApproved(uint _tokenId) public view returns (address approved) {
130         approved = playerCards[_tokenId].approvedForTransfer;
131     }
132 
133     function ownerOf(uint256 _tokenId) public view returns (address _owner) {
134         _owner = playerCards[_tokenId].owner;
135         require(_owner != address(0));
136     }
137 
138     function approve(address _to, uint256 _tokenId) public whenNotPaused {
139         require(ownsPlayerCard(msg.sender, _tokenId));
140         approveForTransferTo(_to, _tokenId);
141         Approval(msg.sender, _to, _tokenId);
142     }
143 
144     function transferFrom(address _from, address _to, uint256 _tokenId) public whenNotPaused {
145         require(_to != address(0));
146         require(_to != address(this));
147         require(ownsPlayerCard(_from, _tokenId));
148         require(isApprovedForTransferTo(_to, _tokenId));
149         
150         // As we've validate we can now call the universal transfer method
151         transferUnconditionally(_from, _to, _tokenId);
152     }
153 
154     function transfer(address _to, uint256 _tokenId) public whenNotPaused {
155         require(_to != address(0));
156         require(_to != address(this));
157         require(ownsPlayerCard(msg.sender, _tokenId));
158     
159         // As we've validate we can now call the universal transfer method
160         transferUnconditionally(msg.sender, _to, _tokenId);
161     }
162 
163     function name() public pure returns (string) {
164         return NAME;
165     }
166 
167     function symbol() public pure returns (string) {
168         return SYMBOL;
169     }
170 
171     function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds) {
172         return ownerToCardsOwned[_owner];
173     }
174 
175     function addCardToOwnersList(address _owner, uint _cardId) internal {
176         ownerToCardsOwned[_owner].push(_cardId);
177         cardIdToOwnerArrayIndex[_cardId] = ownerToCardsOwned[_owner].length - 1;
178     }
179 
180     function removeCardFromOwnersList(address _owner, uint _cardId) internal {
181         uint length = ownerToCardsOwned[_owner].length;
182         uint index = cardIdToOwnerArrayIndex[_cardId];
183         uint swapCard = ownerToCardsOwned[_owner][length - 1];
184 
185         ownerToCardsOwned[_owner][index] = swapCard;
186         cardIdToOwnerArrayIndex[swapCard] = index;
187 
188         delete ownerToCardsOwned[_owner][length - 1];
189         ownerToCardsOwned[_owner].length--;
190     }
191 
192     // Internal function to transfer without prior validation, requires callers to perform due-diligence
193     function transferUnconditionally(address _from, address _to, uint _cardId) internal {
194         
195         if (_from != address(0)) {
196             // Remove from current owner list first, otherwise we'll end up with invalid indexes
197             playerCards[_cardId].approvedForTransfer = address(0);
198             removeCardFromOwnersList(_from, _cardId);
199         }
200         
201         playerCards[_cardId].owner = _to;
202         addCardToOwnersList(_to, _cardId);
203 
204         Transfer(_from, _to, _cardId);
205     }
206 
207     function isApprovedForTransferTo(address _approved, uint _cardId) internal view returns (bool) {
208         return playerCards[_cardId].approvedForTransfer == _approved;
209     }
210 
211     function approveForTransferTo(address _approved, uint _cardId) internal {
212         playerCards[_cardId].approvedForTransfer = _approved;
213     }
214 
215     function ownsPlayerCard(address _cardOwner, uint _cardId) internal view returns (bool) {
216         return playerCards[_cardId].owner == _cardOwner;
217     }
218 
219     function setPlayerForm(uint _playerId, uint8 _form) external whenNotPaused onlyEditor {
220         require(players[_playerId].form > 0); // Check the player and form exist
221         require(_form > 0 && _form <= 200); // Max value is players can double their form
222         players[_playerId].form = _form;
223     }
224 
225     function createPlayerCard(uint _playerId, address _newOwner, bool isFirstOfKind) internal returns (uint) {
226         require(_playerId > 0); // disallow player cards for the first card - Thiago Messi
227         Player storage _player = players[_playerId];
228         require(_player.overall > 0); // Make sure the player exists
229 
230         PlayerCard memory _cardInstance = PlayerCard({
231              playerId: _playerId,
232              owner: _newOwner,
233              approvedForTransfer: address(0),
234              isFirstGeneration: isFirstOfKind
235         });
236 
237         uint cardId = playerCards.push(_cardInstance) - 1;
238 
239         // We send it with 0x0 FROM address so we don't reduce the total number of cards associated with this address 
240         transferUnconditionally(0, _newOwner, cardId);
241 
242         return cardId;
243     }
244 
245     // Public Functions - Non ERC721 specific
246     function totalPlayerCount() public view returns(uint) {
247         return players.length;
248     }
249     
250     function getPlayerForCard(uint _cardId) 
251         external
252         view
253         returns (
254         uint8 _overall,
255         uint8 _pace,
256         uint8 _shooting,
257         uint8 _passing,
258         uint8 _dribbling,
259         uint8 _defending,
260         uint8 _physical,
261         uint8 _level,
262         bytes _position,
263         string _fullName,
264         uint8 _form
265     ) {
266         // Fetch the card first
267         PlayerCard storage _playerCard = playerCards[_cardId];
268         
269         // Return the player returned here
270         // NOTE: if an invalid card is specified this may return index 0 result (Thiago Messi)
271         Player storage player = players[_playerCard.playerId];
272         _overall = player.overall;
273         _pace = player.pace;
274         _shooting = player.shooting;
275         _passing = player.passing;
276         _dribbling = player.dribbling;
277         _defending = player.defending;
278         _physical = player.physical;
279         _level = player.level;
280         _position = player.position;
281         _fullName = player.name;
282         _form = player.form;
283     }
284 
285     function isOwnerOfAllPlayerCards(uint256[] _cardIds, address owner) public view returns (bool) {
286         require(owner != address(0));
287 
288         // This function will return early if it finds any instance of a cardId not owned
289         for (uint i = 0; i < _cardIds.length; i++) {
290             if (!ownsPlayerCard(owner, _cardIds[i])) {
291                 return false;
292             }
293         }
294 
295         // Get's here, must own all cardIds
296         return true;
297     }
298 
299     // Extended attributes
300     function setExtendedPlayerAttributesForPlayer(uint playerId, uint8[] attributes) external whenNotPaused onlyEditor {
301         require(playerId > 0);
302         playerIdToExtendedAttributes[playerId] = attributes;
303     }
304 
305     function getExtendedAttributesForPlayer(uint playerId) public view returns (uint8[]) {
306         require(playerId > 0);
307         return playerIdToExtendedAttributes[playerId];
308     }
309 }
310 
311 contract BCFBuyMarket is BCFData {
312 
313     address public buyingEscrowAddress;
314     bool public isBCFBuyMarket = true;
315 
316     function setBuyingEscrowAddress(address _address) external onlyOwner {
317         buyingEscrowAddress = _address;
318     }
319     
320     function createCardForAcquiredPlayer(uint playerId, address newOwner) public whenNotPaused returns (uint) {
321         require(buyingEscrowAddress != address(0));
322         require(newOwner != address(0));
323         require(buyingEscrowAddress == msg.sender);
324         
325         uint cardId = createPlayerCard(playerId, newOwner, false);
326 
327         return cardId;
328     }
329 
330     function createCardForAcquiredPlayers(uint[] playerIds, address newOwner) public whenNotPaused returns (uint[]) {
331         require(buyingEscrowAddress != address(0));
332         require(newOwner != address(0));
333         require(buyingEscrowAddress == msg.sender);
334 
335         uint[] memory cardIds = new uint[](playerIds.length);
336 
337         // Create the players and store an array of their Ids
338         for (uint i = 0; i < playerIds.length; i++) {
339             uint cardId = createPlayerCard(playerIds[i], newOwner, false);
340             cardIds[i] = cardId;
341         }
342 
343         return cardIds;
344     }
345 }
346 
347 contract Ownable {
348 
349     address public owner;
350 
351     /**
352     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
353     * account.
354     */
355     function Ownable() public {
356         owner = msg.sender;
357     }
358 
359 
360     /**
361     * @dev Throws if called by any account other than the owner.
362     */
363     modifier onlyOwner() {
364         require(msg.sender == owner);
365         _;
366     }
367 
368     /**
369     * @dev Allows the current owner to transfer control of the contract to a newOwner.
370     * @param newOwner The address to transfer ownership to.
371     */
372     function transferOwnership(address newOwner) public onlyOwner {
373         require(newOwner != address(0));
374         owner = newOwner;
375   }
376 }
377 
378 contract Pausable is Ownable {
379     event Pause();
380     event Unpause();
381 
382     bool public paused = false;
383 
384     /**
385     * @dev modifier to allow actions only when the contract IS paused
386     */
387     modifier whenNotPaused() {
388         require(!paused);
389         _;
390     }
391 
392     /**
393     * @dev modifier to allow actions only when the contract IS NOT paused
394     */
395     modifier whenPaused {
396         require(paused);
397         _;
398     }
399 
400     /**
401     * @dev called by the owner to pause, triggers stopped state
402     */
403     function pause() onlyOwner whenNotPaused public returns (bool) {
404         paused = true;
405         Pause();
406         return true;
407     }
408 
409     /**
410     * @dev called by the owner to unpause, returns to normal state
411     */
412     function unpause() onlyOwner whenPaused public returns (bool) {
413         paused = false;
414         Unpause();
415         return true;
416     }
417 }
418 
419 contract BCFAuction is Pausable {
420 
421     struct CardAuction {
422         address seller;
423         uint128 startPrice; // in wei
424         uint128 endPrice;
425         uint64 duration;
426         uint64 startedAt;
427     }
428 
429     // To lookup owners 
430     ERC721 public dataStore;
431     uint256 public auctioneerCut;
432 
433     mapping (uint256 => CardAuction) playerCardIdToAuction;
434 
435     event AuctionCreated(uint256 cardId, uint256 startPrice, uint256 endPrice, uint256 duration);
436     event AuctionSuccessful(uint256 cardId, uint256 finalPrice, address winner);
437     event AuctionCancelled(uint256 cardId);
438 
439     function BCFAuction(address dataStoreAddress, uint cutValue) public {
440         require(cutValue <= 10000); // 100% == 10,000
441         auctioneerCut = cutValue;
442 
443         ERC721 candidateDataStoreContract = ERC721(dataStoreAddress);
444         require(candidateDataStoreContract.implementsERC721());
445         dataStore = candidateDataStoreContract;
446     }
447 
448     function withdrawBalance() external {
449         address storageAddress = address(dataStore);
450         require(msg.sender == owner || msg.sender == storageAddress);
451         storageAddress.transfer(this.balance);
452     }
453 
454     function createAuction(
455         uint256 cardId, 
456         uint256 startPrice, 
457         uint256 endPrice, 
458         uint256 duration, 
459         address seller
460     )
461         external
462         whenNotPaused
463     {
464         require(startPrice == uint256(uint128(startPrice)));
465         require(endPrice == uint256(uint128(endPrice)));
466         require(duration == uint256(uint64(duration)));
467         require(seller != address(0));
468         require(address(dataStore) != address(0));
469         require(msg.sender == address(dataStore));
470 
471         _escrow(seller, cardId);
472         CardAuction memory auction = CardAuction(
473             seller,
474             uint128(startPrice),
475             uint128(endPrice),
476             uint64(duration),
477             uint64(now)
478         );
479         _addAuction(cardId, auction);
480     }
481 
482     function bid(uint256 cardId) external payable whenNotPaused {
483         _bid(cardId, msg.value); // This function handles validation and throws
484         _transfer(msg.sender, cardId);
485     }
486 
487     function cancelAuction(uint256 cardId) external {
488         CardAuction storage auction = playerCardIdToAuction[cardId];
489         require(isOnAuction(auction));
490         address seller = auction.seller;
491         require(msg.sender == seller);
492         _cancelAuction(cardId, seller);
493     }
494 
495     function getAuction(uint256 cardId) external view returns
496     (
497         address seller,
498         uint256 startingPrice,
499         uint256 endingPrice,
500         uint256 duration,
501         uint256 startedAt
502     ) {
503         CardAuction storage auction = playerCardIdToAuction[cardId];
504         require(isOnAuction(auction));
505         return (auction.seller, auction.startPrice, auction.endPrice, auction.duration, auction.startedAt);
506     }
507 
508     function getCurrentPrice(uint256 cardId) external view returns (uint256) {
509         CardAuction storage auction = playerCardIdToAuction[cardId];
510         require(isOnAuction(auction));
511         return currentPrice(auction);
512     }
513 
514     // Internal utility functions
515     function ownsPlayerCard(address cardOwner, uint256 cardId) internal view returns (bool) {
516         return (dataStore.ownerOf(cardId) == cardOwner);
517     }
518 
519     function _escrow(address owner, uint256 cardId) internal {
520         dataStore.transferFrom(owner, this, cardId);
521     }
522 
523     function _transfer(address receiver, uint256 cardId) internal {
524         dataStore.transfer(receiver, cardId);
525     }
526 
527     function _addAuction(uint256 cardId, CardAuction auction) internal {
528         require(auction.duration >= 1 minutes && auction.duration <= 14 days);
529         playerCardIdToAuction[cardId] = auction;
530         AuctionCreated(cardId, auction.startPrice, auction.endPrice, auction.duration);
531     }
532 
533     function _removeAuction(uint256 cardId) internal {
534         delete playerCardIdToAuction[cardId];
535     }
536 
537     function _cancelAuction(uint256 cardId, address seller) internal {
538         _removeAuction(cardId);
539         _transfer(seller, cardId);
540         AuctionCancelled(cardId);
541     }
542 
543     function isOnAuction(CardAuction storage auction) internal view returns (bool) {
544         return (auction.startedAt > 0);
545     }
546 
547     function _bid(uint256 cardId, uint256 bidAmount) internal returns (uint256) {
548         CardAuction storage auction = playerCardIdToAuction[cardId];
549         require(isOnAuction(auction));
550 
551         uint256 price = currentPrice(auction);
552         require(bidAmount >= price);
553 
554         address seller = auction.seller;
555         _removeAuction(cardId);
556 
557         if (price > 0) {
558             uint256 handlerCut = calculateAuctioneerCut(price);
559             uint256 sellerProceeds = price - handlerCut;
560             seller.transfer(sellerProceeds);
561         } 
562 
563         uint256 bidExcess = bidAmount - price;
564         msg.sender.transfer(bidExcess);
565 
566         AuctionSuccessful(cardId, price, msg.sender); // Emit event/log
567 
568         return price;
569     }
570 
571     function currentPrice(CardAuction storage auction) internal view returns (uint256) {
572         uint256 secondsPassed = 0;
573         if (now > auction.startedAt) {
574             secondsPassed = now - auction.startedAt;
575         }
576 
577         return calculateCurrentPrice(auction.startPrice, auction.endPrice, auction.duration, secondsPassed);
578     }
579 
580     function calculateCurrentPrice(uint256 startPrice, uint256 endPrice, uint256 duration, uint256 secondsElapsed)
581         internal
582         pure
583         returns (uint256)
584     {
585         if (secondsElapsed >= duration) {
586             return endPrice;
587         } 
588 
589         int256 totalPriceChange = int256(endPrice) - int256(startPrice);
590         int256 currentPriceChange = totalPriceChange * int256(secondsElapsed) / int256(duration);
591         int256 _currentPrice = int256(startPrice) + currentPriceChange;
592 
593         return uint256(_currentPrice);
594     }
595 
596     function calculateAuctioneerCut(uint256 sellPrice) internal view returns (uint256) {
597         // 10,000 = 100%, ownerCut required'd <= 10,000 in the constructor so no requirement to validate here
598         uint finalCut = sellPrice * auctioneerCut / 10000;
599         return finalCut;
600     }    
601 }
602 
603 contract BCFTransferMarket is BCFBuyMarket {
604 
605     BCFAuction public auctionAddress;
606 
607     function setAuctionAddress(address newAddress) public onlyOwner {
608         require(newAddress != address(0));
609         BCFAuction candidateContract = BCFAuction(newAddress);
610         auctionAddress = candidateContract;
611     }
612 
613     function createTransferAuction(
614         uint playerCardId,
615         uint startPrice,
616         uint endPrice,
617         uint duration
618     )
619         public
620         whenNotPaused
621     {
622         require(auctionAddress != address(0));
623         require(ownsPlayerCard(msg.sender, playerCardId));
624         approveForTransferTo(auctionAddress, playerCardId);
625         auctionAddress.createAuction(
626             playerCardId,
627             startPrice,
628             endPrice,
629             duration,
630             msg.sender
631         );
632     }
633 
634     function withdrawAuctionBalance() external onlyOwner {
635         auctionAddress.withdrawBalance();
636     }
637 }
638 
639 contract BCFSeeding is BCFTransferMarket {
640 
641     function createPlayer(
642         uint8 _overall,
643         uint8 _pace,
644         uint8 _shooting,
645         uint8 _passing,
646         uint8 _dribbling,
647         uint8 _defending,
648         uint8 _physical,
649         uint8 _level,
650         bytes _position,
651         string _fullName
652     ) 
653         internal 
654         returns (uint) 
655     {
656         require(_overall > 0 && _overall < 100);
657         require(_pace > 0 && _pace < 100);
658         require(_shooting > 0 && _shooting < 100);
659         require(_passing > 0 && _passing < 100);
660         require(_dribbling > 0 && _dribbling < 100);
661         require(_defending > 0 && _defending < 100);
662         require(_physical > 0 && _physical < 100);
663         require(_level > 0 && _level < 100);
664         require(_position.length > 0);
665         require(bytes(_fullName).length > 0);
666         
667         Player memory _playerInstance = Player({
668             overall: _overall,
669             pace: _pace,
670             shooting: _shooting,
671             passing: _passing,
672             dribbling: _dribbling,
673             defending: _defending,
674             physical: _physical,
675             form: 100,
676             level: _level,
677             position: _position,
678             name: _fullName
679         });
680 
681         return players.push(_playerInstance) - 1;
682     }
683 
684     function createPlayerOnAuction(
685         uint8 _overall,
686         uint8 _pace,
687         uint8 _shooting,
688         uint8 _passing,
689         uint8 _dribbling,
690         uint8 _defending,
691         uint8 _physical,
692         uint8 _level,
693         bytes _position,
694         string _fullName,
695         uint _startPrice
696     ) 
697         public whenNotPaused onlyEditor
698         returns(uint)
699     {
700         uint playerId = createPlayer(
701             _overall, 
702             _pace, 
703             _shooting, 
704             _passing, 
705             _dribbling,
706             _defending,
707             _physical,
708             _level,
709             _position,
710             _fullName);
711 
712         uint cardId = createPlayerCard(playerId, address(this), true);
713         approveForTransferTo(auctionAddress, cardId);
714 
715         auctionAddress.createAuction(
716             cardId, // id
717             _startPrice, // start price
718             1 finney, // end price
719             7 days, // duration
720             address(this) // seller
721         );
722 
723         return cardId;
724     }
725     
726     function createPlayerAndAssign(
727         uint8 _overall,
728         uint8 _pace,
729         uint8 _shooting,
730         uint8 _passing,
731         uint8 _dribbling,
732         uint8 _defending,
733         uint8 _physical,
734         uint8 _level,
735         bytes _position,
736         string _fullName,
737         address assignee
738     ) 
739         public whenNotPaused onlyEditor
740         returns(uint) 
741     {
742         require(assignee != address(0));
743         
744         uint playerId = createPlayer(
745             _overall, 
746             _pace, 
747             _shooting, 
748             _passing, 
749             _dribbling,
750             _defending,
751             _physical,
752             _level,
753             _position,
754             _fullName);
755 
756         uint cardId = createPlayerCard(playerId, assignee, true);
757 
758         return cardId;
759     }
760 }
761 
762 contract BCFMain is BCFSeeding {
763 
764     function BCFMain() public {
765         owner = msg.sender;
766         editor = msg.sender;
767         paused = true;
768 
769         // We need to create an unacquirable index 0 player so we can use playerId > 0 check for valid playerCard structs
770         createPlayer(1, 4, 4, 2, 3, 5, 2, 11, "CAM", "Thiago Messi");
771     }
772 
773     function() external payable {
774         require(msg.sender == address(auctionAddress) || msg.sender == owner || msg.sender == buyingEscrowAddress);
775     }
776 
777     function withdrawBalance() external onlyOwner {
778         owner.transfer(this.balance);
779     }
780 }