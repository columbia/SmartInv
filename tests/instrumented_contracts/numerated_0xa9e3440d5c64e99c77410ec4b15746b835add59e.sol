1 pragma solidity ^0.4.21;
2 
3 contract Ownable {
4     address public owner;
5 
6     event OwnershipTransferred(address previousOwner, address newOwner);
7 
8     function Ownable() public {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner() {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     function transferOwnership(address newOwner) public onlyOwner {
18         require(newOwner != address(0));
19         emit OwnershipTransferred(owner, newOwner);
20         owner = newOwner;
21     }
22 }
23 
24 contract StorageBase is Ownable {
25 
26     function withdrawBalance() external onlyOwner returns (bool) {
27         // The owner has a method to withdraw balance from multiple contracts together,
28         // use send here to make sure even if one withdrawBalance fails the others will still work
29         bool res = msg.sender.send(address(this).balance);
30         return res;
31     }
32 }
33 
34 // owner of ActivityStorage should be ActivityCore contract address
35 contract ActivityStorage is StorageBase {
36 
37     struct Activity {
38         // accept bid or not
39         bool isPause;
40         // limit max num of monster buyable per address
41         uint16 buyLimit;
42         // price (in wei)
43         uint128 packPrice;
44         // startDate (in seconds)
45         uint64 startDate;
46         // endDate (in seconds)
47         uint64 endDate;
48         // packId => address of bid winner
49         mapping(uint16 => address) soldPackToAddress;
50         // address => number of success bid
51         mapping(address => uint16) addressBoughtCount;
52     }
53 
54     // limit max activityId to 65536, big enough
55     mapping(uint16 => Activity) public activities;
56 
57     function createActivity(
58         uint16 _activityId,
59         uint16 _buyLimit,
60         uint128 _packPrice,
61         uint64 _startDate,
62         uint64 _endDate
63     ) 
64         external
65         onlyOwner
66     {
67         // activity should not exist and can only be initialized once
68         require(activities[_activityId].buyLimit == 0);
69 
70         activities[_activityId] = Activity({
71             isPause: false,
72             buyLimit: _buyLimit,
73             packPrice: _packPrice,
74             startDate: _startDate,
75             endDate: _endDate
76         });
77     }
78 
79     function sellPackToAddress(
80         uint16 _activityId, 
81         uint16 _packId, 
82         address buyer
83     ) 
84         external 
85         onlyOwner
86     {
87         Activity storage activity = activities[_activityId];
88         activity.soldPackToAddress[_packId] = buyer;
89         activity.addressBoughtCount[buyer]++;
90     }
91 
92     function pauseActivity(uint16 _activityId) external onlyOwner {
93         activities[_activityId].isPause = true;
94     }
95 
96     function unpauseActivity(uint16 _activityId) external onlyOwner {
97         activities[_activityId].isPause = false;
98     }
99 
100     function deleteActivity(uint16 _activityId) external onlyOwner {
101         delete activities[_activityId];
102     }
103 
104     function getAddressBoughtCount(uint16 _activityId, address buyer) external view returns (uint16) {
105         return activities[_activityId].addressBoughtCount[buyer];
106     }
107 
108     function getBuyerAddress(uint16 _activityId, uint16 packId) external view returns (address) {
109         return activities[_activityId].soldPackToAddress[packId];
110     }
111 }
112 
113 contract Pausable is Ownable {
114     event Pause();
115     event Unpause();
116 
117     bool public paused = false;
118 
119     modifier whenNotPaused() {
120         require(!paused);
121         _;
122     }
123 
124     modifier whenPaused {
125         require(paused);
126         _;
127     }
128 
129     function pause() public onlyOwner whenNotPaused {
130         paused = true;
131         emit Pause();
132     }
133 
134     function unpause() public onlyOwner whenPaused {
135         paused = false;
136         emit Unpause();
137     }
138 }
139 
140 contract HasNoContracts is Pausable {
141 
142     function reclaimContract(address _contractAddr) external onlyOwner whenPaused {
143         Ownable contractInst = Ownable(_contractAddr);
144         contractInst.transferOwnership(owner);
145     }
146 }
147 
148 contract ERC721 {
149     // Required methods
150     function totalSupply() public view returns (uint256 total);
151     function balanceOf(address _owner) public view returns (uint256 balance);
152     function ownerOf(uint256 _tokenId) external view returns (address owner);
153     function approve(address _to, uint256 _tokenId) external;
154     function transfer(address _to, uint256 _tokenId) external;
155     function transferFrom(address _from, address _to, uint256 _tokenId) external;
156 
157     // Events
158     event Transfer(address from, address to, uint256 tokenId);
159     event Approval(address owner, address approved, uint256 tokenId);
160 
161     // Optional
162     // function name() public view returns (string name);
163     // function symbol() public view returns (string symbol);
164     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
165     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
166 
167     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
168     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
169 }
170 
171 contract LogicBase is HasNoContracts {
172 
173     /// The ERC-165 interface signature for ERC-721.
174     ///  Ref: https://github.com/ethereum/EIPs/issues/165
175     ///  Ref: https://github.com/ethereum/EIPs/issues/721
176     bytes4 constant InterfaceSignature_NFC = bytes4(0x9f40b779);
177 
178     // Reference to contract tracking NFT ownership
179     ERC721 public nonFungibleContract;
180 
181     // Reference to storage contract
182     StorageBase public storageContract;
183 
184     function LogicBase(address _nftAddress, address _storageAddress) public {
185         // paused by default
186         paused = true;
187 
188         setNFTAddress(_nftAddress);
189 
190         require(_storageAddress != address(0));
191         storageContract = StorageBase(_storageAddress);
192     }
193 
194     // Very dangerous action, only when new contract has been proved working
195     // Requires storageContract already transferOwnership to the new contract
196     // This method is only used to transfer the balance to owner
197     function destroy() external onlyOwner whenPaused {
198         address storageOwner = storageContract.owner();
199         // owner of storageContract must not be the current contract otherwise the storageContract will forever not accessible
200         require(storageOwner != address(this));
201         // Transfers the current balance to the owner and terminates the contract
202         selfdestruct(owner);
203     }
204 
205     // Very dangerous action, only when new contract has been proved working
206     // Requires storageContract already transferOwnership to the new contract
207     // This method is only used to transfer the balance to the new contract
208     function destroyAndSendToStorageOwner() external onlyOwner whenPaused {
209         address storageOwner = storageContract.owner();
210         // owner of storageContract must not be the current contract otherwise the storageContract will forever not accessible
211         require(storageOwner != address(this));
212         // Transfers the current balance to the new owner of the storage contract and terminates the contract
213         selfdestruct(storageOwner);
214     }
215 
216     // override to make sure everything is initialized before the unpause
217     function unpause() public onlyOwner whenPaused {
218         // can not unpause when the logic contract is not initialzed
219         require(nonFungibleContract != address(0));
220         require(storageContract != address(0));
221         // can not unpause when ownership of storage contract is not the current contract
222         require(storageContract.owner() == address(this));
223 
224         super.unpause();
225     }
226 
227     function setNFTAddress(address _nftAddress) public onlyOwner {
228         require(_nftAddress != address(0));
229         ERC721 candidateContract = ERC721(_nftAddress);
230         require(candidateContract.supportsInterface(InterfaceSignature_NFC));
231         nonFungibleContract = candidateContract;
232     }
233 
234     // Withdraw balance to the Core Contract
235     function withdrawBalance() external returns (bool) {
236         address nftAddress = address(nonFungibleContract);
237         // either Owner or Core Contract can trigger the withdraw
238         require(msg.sender == owner || msg.sender == nftAddress);
239         // The owner has a method to withdraw balance from multiple contracts together,
240         // use send here to make sure even if one withdrawBalance fails the others will still work
241         bool res = nftAddress.send(address(this).balance);
242         return res;
243     }
244 
245     function withdrawBalanceFromStorageContract() external returns (bool) {
246         address nftAddress = address(nonFungibleContract);
247         // either Owner or Core Contract can trigger the withdraw
248         require(msg.sender == owner || msg.sender == nftAddress);
249         // The owner has a method to withdraw balance from multiple contracts together,
250         // use send here to make sure even if one withdrawBalance fails the others will still work
251         bool res = storageContract.withdrawBalance();
252         return res;
253     }
254 }
255 
256 contract ActivityCore is LogicBase {
257 
258     bool public isActivityCore = true;
259 
260     ActivityStorage activityStorage;
261 
262     event ActivityCreated(uint16 activityId);
263     event ActivityBidSuccess(uint16 activityId, uint16 packId, address winner);
264 
265     function ActivityCore(address _nftAddress, address _storageAddress) 
266         LogicBase(_nftAddress, _storageAddress) public {
267             
268         activityStorage = ActivityStorage(_storageAddress);
269     }
270 
271     function createActivity(
272         uint16 _activityId,
273         uint16 _buyLimit,
274         uint128 _packPrice,
275         uint64 _startDate,
276         uint64 _endDate
277     ) 
278         external
279         onlyOwner
280         whenNotPaused
281     {
282         activityStorage.createActivity(_activityId, _buyLimit, _packPrice, _startDate, _endDate);
283 
284         emit ActivityCreated(_activityId);
285     }
286 
287     // Very dangerous action and should be only used for testing
288     // Must pause the contract first 
289     function deleteActivity(
290         uint16 _activityId
291     )
292         external 
293         onlyOwner
294         whenPaused
295     {
296         activityStorage.deleteActivity(_activityId);
297     }
298 
299     function getActivity(
300         uint16 _activityId
301     ) 
302         external 
303         view  
304         returns (
305             bool isPause,
306             uint16 buyLimit,
307             uint128 packPrice,
308             uint64 startDate,
309             uint64 endDate
310         )
311     {
312         return activityStorage.activities(_activityId);
313     }
314     
315     function bid(uint16 _activityId, uint16 _packId)
316         external
317         payable
318         whenNotPaused
319     {
320         bool isPause;
321         uint16 buyLimit;
322         uint128 packPrice;
323         uint64 startDate;
324         uint64 endDate;
325         (isPause, buyLimit, packPrice, startDate, endDate) = activityStorage.activities(_activityId);
326         // not allow to bid when activity is paused
327         require(!isPause);
328         // not allow to bid when activity is not initialized (buyLimit == 0)
329         require(buyLimit > 0);
330         // should send enough ether
331         require(msg.value >= packPrice);
332         // verify startDate & endDate
333         require(now >= startDate && now <= endDate);
334         // this pack is not sold out
335         require(activityStorage.getBuyerAddress(_activityId, _packId) == address(0));
336         // buyer not exceed buyLimit
337         require(activityStorage.getAddressBoughtCount(_activityId, msg.sender) < buyLimit);
338         // record in blockchain
339         activityStorage.sellPackToAddress(_activityId, _packId, msg.sender);
340         // emit the success event
341         emit ActivityBidSuccess(_activityId, _packId, msg.sender);
342     }
343 }
344 
345 contract CryptoStorage is StorageBase {
346 
347     struct Monster {
348         uint32 matronId;
349         uint32 sireId;
350         uint32 siringWithId;
351         uint16 cooldownIndex;
352         uint16 generation;
353         uint64 cooldownEndBlock;
354         uint64 birthTime;
355         uint16 monsterId;
356         uint32 monsterNum;
357         bytes properties;
358     }
359 
360     // ERC721 tokens
361     Monster[] internal monsters;
362 
363     // total number of monster created from system instead of breeding
364     uint256 public promoCreatedCount;
365 
366     // total number of monster created by system sale address
367     uint256 public systemCreatedCount;
368 
369     // number of monsters in pregnant
370     uint256 public pregnantMonsters;
371     
372     // monsterId => total number
373     mapping (uint256 => uint32) public monsterCurrentNumber;
374     
375     // tokenId => owner address
376     mapping (uint256 => address) public monsterIndexToOwner;
377 
378     // owner address => balance of tokens
379     mapping (address => uint256) public ownershipTokenCount;
380 
381     // tokenId => approved address
382     mapping (uint256 => address) public monsterIndexToApproved;
383 
384     function CryptoStorage() public {
385         // placeholder to make the first available monster to have a tokenId starts from 1
386         createMonster(0, 0, 0, 0, 0, "");
387     }
388 
389     function createMonster(
390         uint256 _matronId,
391         uint256 _sireId,
392         uint256 _generation,
393         uint256 _birthTime,
394         uint256 _monsterId,
395         bytes _properties
396     ) 
397         public 
398         onlyOwner
399         returns (uint256)
400     {
401         require(_matronId == uint256(uint32(_matronId)));
402         require(_sireId == uint256(uint32(_sireId)));
403         require(_generation == uint256(uint16(_generation)));
404         require(_birthTime == uint256(uint64(_birthTime)));
405         require(_monsterId == uint256(uint16(_monsterId)));
406 
407         monsterCurrentNumber[_monsterId]++;
408 
409         Monster memory monster = Monster({
410             matronId: uint32(_matronId),
411             sireId: uint32(_sireId),
412             siringWithId: 0,
413             cooldownIndex: 0,
414             generation: uint16(_generation),
415             cooldownEndBlock: 0,
416             birthTime: uint64(_birthTime),
417             monsterId: uint16(_monsterId),
418             monsterNum: monsterCurrentNumber[_monsterId],
419             properties: _properties
420         });
421         uint256 tokenId = monsters.push(monster) - 1;
422 
423         // overflow check
424         require(tokenId == uint256(uint32(tokenId)));
425 
426         return tokenId;
427     }
428 
429     function getMonster(uint256 _tokenId)
430         external
431         view
432         returns (
433             bool isGestating,
434             bool isReady,
435             uint16 cooldownIndex,
436             uint64 nextActionAt,
437             uint32 siringWithId,
438             uint32 matronId,
439             uint32 sireId,
440             uint64 cooldownEndBlock,
441             uint16 generation,
442             uint64 birthTime,
443             uint32 monsterNum,
444             uint16 monsterId,
445             bytes properties
446         ) 
447     {
448         Monster storage monster = monsters[_tokenId];
449 
450         isGestating = (monster.siringWithId != 0);
451         isReady = (monster.cooldownEndBlock <= block.number);
452         cooldownIndex = monster.cooldownIndex;
453         nextActionAt = monster.cooldownEndBlock;
454         siringWithId = monster.siringWithId;
455         matronId = monster.matronId;
456         sireId = monster.sireId;
457         cooldownEndBlock = monster.cooldownEndBlock;
458         generation = monster.generation;
459         birthTime = monster.birthTime;
460         monsterNum = monster.monsterNum;
461         monsterId = monster.monsterId;
462         properties = monster.properties;
463     }
464 
465     function getMonsterCount() external view returns (uint256) {
466         return monsters.length - 1;
467     }
468 
469     function getMatronId(uint256 _tokenId) external view returns (uint32) {
470         return monsters[_tokenId].matronId;
471     }
472 
473     function getSireId(uint256 _tokenId) external view returns (uint32) {
474         return monsters[_tokenId].sireId;
475     }
476 
477     function getSiringWithId(uint256 _tokenId) external view returns (uint32) {
478         return monsters[_tokenId].siringWithId;
479     }
480     
481     function setSiringWithId(uint256 _tokenId, uint32 _siringWithId) external onlyOwner {
482         monsters[_tokenId].siringWithId = _siringWithId;
483     }
484 
485     function deleteSiringWithId(uint256 _tokenId) external onlyOwner {
486         delete monsters[_tokenId].siringWithId;
487     }
488 
489     function getCooldownIndex(uint256 _tokenId) external view returns (uint16) {
490         return monsters[_tokenId].cooldownIndex;
491     }
492 
493     function setCooldownIndex(uint256 _tokenId) external onlyOwner {
494         monsters[_tokenId].cooldownIndex += 1;
495     }
496 
497     function getGeneration(uint256 _tokenId) external view returns (uint16) {
498         return monsters[_tokenId].generation;
499     }
500 
501     function getCooldownEndBlock(uint256 _tokenId) external view returns (uint64) {
502         return monsters[_tokenId].cooldownEndBlock;
503     }
504 
505     function setCooldownEndBlock(uint256 _tokenId, uint64 _cooldownEndBlock) external onlyOwner {
506         monsters[_tokenId].cooldownEndBlock = _cooldownEndBlock;
507     }
508 
509     function getBirthTime(uint256 _tokenId) external view returns (uint64) {
510         return monsters[_tokenId].birthTime;
511     }
512 
513     function getMonsterId(uint256 _tokenId) external view returns (uint16) {
514         return monsters[_tokenId].monsterId;
515     }
516 
517     function getMonsterNum(uint256 _tokenId) external view returns (uint32) {
518         return monsters[_tokenId].monsterNum;
519     }
520 
521     function getProperties(uint256 _tokenId) external view returns (bytes) {
522         return monsters[_tokenId].properties;
523     }
524 
525     function updateProperties(uint256 _tokenId, bytes _properties) external onlyOwner {
526         monsters[_tokenId].properties = _properties;
527     }
528     
529     function setMonsterIndexToOwner(uint256 _tokenId, address _owner) external onlyOwner {
530         monsterIndexToOwner[_tokenId] = _owner;
531     }
532 
533     function increaseOwnershipTokenCount(address _owner) external onlyOwner {
534         ownershipTokenCount[_owner]++;
535     }
536 
537     function decreaseOwnershipTokenCount(address _owner) external onlyOwner {
538         ownershipTokenCount[_owner]--;
539     }
540 
541     function setMonsterIndexToApproved(uint256 _tokenId, address _approved) external onlyOwner {
542         monsterIndexToApproved[_tokenId] = _approved;
543     }
544     
545     function deleteMonsterIndexToApproved(uint256 _tokenId) external onlyOwner {
546         delete monsterIndexToApproved[_tokenId];
547     }
548 
549     function increasePromoCreatedCount() external onlyOwner {
550         promoCreatedCount++;
551     }
552 
553     function increaseSystemCreatedCount() external onlyOwner {
554         systemCreatedCount++;
555     }
556 
557     function increasePregnantCounter() external onlyOwner {
558         pregnantMonsters++;
559     }
560 
561     function decreasePregnantCounter() external onlyOwner {
562         pregnantMonsters--;
563     }
564 }
565 
566 contract ClockAuctionStorage is StorageBase {
567 
568     // Represents an auction on an NFT
569     struct Auction {
570         // Current owner of NFT
571         address seller;
572         // Price (in wei) at beginning of auction
573         uint128 startingPrice;
574         // Price (in wei) at end of auction
575         uint128 endingPrice;
576         // Duration (in seconds) of auction
577         uint64 duration;
578         // Time when auction started
579         // NOTE: 0 if this auction has been concluded
580         uint64 startedAt;
581     }
582 
583     // Map from token ID to their corresponding auction.
584     mapping (uint256 => Auction) tokenIdToAuction;
585 
586     function addAuction(
587         uint256 _tokenId,
588         address _seller,
589         uint128 _startingPrice,
590         uint128 _endingPrice,
591         uint64 _duration,
592         uint64 _startedAt
593     )
594         external
595         onlyOwner
596     {
597         tokenIdToAuction[_tokenId] = Auction(
598             _seller,
599             _startingPrice,
600             _endingPrice,
601             _duration,
602             _startedAt
603         );
604     }
605 
606     function removeAuction(uint256 _tokenId) public onlyOwner {
607         delete tokenIdToAuction[_tokenId];
608     }
609 
610     function getAuction(uint256 _tokenId)
611         external
612         view
613         returns (
614             address seller,
615             uint128 startingPrice,
616             uint128 endingPrice,
617             uint64 duration,
618             uint64 startedAt
619         )
620     {
621         Auction storage auction = tokenIdToAuction[_tokenId];
622         return (
623             auction.seller,
624             auction.startingPrice,
625             auction.endingPrice,
626             auction.duration,
627             auction.startedAt
628         );
629     }
630 
631     function isOnAuction(uint256 _tokenId) external view returns (bool) {
632         return (tokenIdToAuction[_tokenId].startedAt > 0);
633     }
634 
635     function getSeller(uint256 _tokenId) external view returns (address) {
636         return tokenIdToAuction[_tokenId].seller;
637     }
638 
639     function transfer(ERC721 _nonFungibleContract, address _receiver, uint256 _tokenId) external onlyOwner {
640         // it will throw if transfer fails
641         _nonFungibleContract.transfer(_receiver, _tokenId);
642     }
643 }
644 
645 contract SaleClockAuctionStorage is ClockAuctionStorage {
646     bool public isSaleClockAuctionStorage = true;
647 
648     // total accumulate sold count
649     uint256 public totalSoldCount;
650 
651     // last 3 sale price
652     uint256[3] public lastSoldPrices;
653 
654     // current on sale auction count from system
655     uint256 public systemOnSaleCount;
656 
657     // map of on sale token ids from system
658     mapping (uint256 => bool) systemOnSaleTokens;
659 
660     function removeAuction(uint256 _tokenId) public onlyOwner {
661         // first remove auction from state variable
662         super.removeAuction(_tokenId);
663 
664         // update system on sale record
665         if (systemOnSaleTokens[_tokenId]) {
666             delete systemOnSaleTokens[_tokenId];
667             
668             if (systemOnSaleCount > 0) {
669                 systemOnSaleCount--;
670             }
671         }
672     }
673 
674     function recordSystemOnSaleToken(uint256 _tokenId) external onlyOwner {
675         if (!systemOnSaleTokens[_tokenId]) {
676             systemOnSaleTokens[_tokenId] = true;
677             systemOnSaleCount++;
678         }
679     }
680 
681     function recordSoldPrice(uint256 _price) external onlyOwner {
682         lastSoldPrices[totalSoldCount % 3] = _price;
683         totalSoldCount++;
684     }
685 
686     function averageSoldPrice() external view returns (uint256) {
687         if (totalSoldCount == 0) return 0;
688         
689         uint256 sum = 0;
690         uint256 len = (totalSoldCount < 3 ? totalSoldCount : 3);
691         for (uint256 i = 0; i < len; i++) {
692             sum += lastSoldPrices[i];
693         }
694         return sum / len;
695     }
696 }
697 
698 contract ClockAuction is LogicBase {
699     
700     // Reference to contract tracking auction state variables
701     ClockAuctionStorage public clockAuctionStorage;
702 
703     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
704     // Values 0-10,000 map to 0%-100%
705     uint256 public ownerCut;
706 
707     // Minimum cut value on each auction (in WEI)
708     uint256 public minCutValue;
709 
710     event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
711     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner, address seller, uint256 sellerProceeds);
712     event AuctionCancelled(uint256 tokenId);
713 
714     function ClockAuction(address _nftAddress, address _storageAddress, uint256 _cut, uint256 _minCutValue) 
715         LogicBase(_nftAddress, _storageAddress) public
716     {
717         setOwnerCut(_cut);
718         setMinCutValue(_minCutValue);
719 
720         clockAuctionStorage = ClockAuctionStorage(_storageAddress);
721     }
722 
723     function setOwnerCut(uint256 _cut) public onlyOwner {
724         require(_cut <= 10000);
725         ownerCut = _cut;
726     }
727 
728     function setMinCutValue(uint256 _minCutValue) public onlyOwner {
729         minCutValue = _minCutValue;
730     }
731 
732     function getMinPrice() public view returns (uint256) {
733         // return ownerCut > 0 ? (minCutValue / ownerCut * 10000) : 0;
734         // use minCutValue directly, when the price == minCutValue seller will get no profit
735         return minCutValue;
736     }
737 
738     // Only auction from none system user need to verify the price
739     // System auction can set any price
740     function isValidPrice(uint256 _startingPrice, uint256 _endingPrice) public view returns (bool) {
741         return (_startingPrice < _endingPrice ? _startingPrice : _endingPrice) >= getMinPrice();
742     }
743 
744     function createAuction(
745         uint256 _tokenId,
746         uint256 _startingPrice,
747         uint256 _endingPrice,
748         uint256 _duration,
749         address _seller
750     )
751         public
752         whenNotPaused
753     {
754         require(_startingPrice == uint256(uint128(_startingPrice)));
755         require(_endingPrice == uint256(uint128(_endingPrice)));
756         require(_duration == uint256(uint64(_duration)));
757 
758         require(msg.sender == address(nonFungibleContract));
759         
760         // assigning ownership to this clockAuctionStorage when in auction
761         // it will throw if transfer fails
762         nonFungibleContract.transferFrom(_seller, address(clockAuctionStorage), _tokenId);
763 
764         // Require that all auctions have a duration of at least one minute.
765         require(_duration >= 1 minutes);
766 
767         clockAuctionStorage.addAuction(
768             _tokenId,
769             _seller,
770             uint128(_startingPrice),
771             uint128(_endingPrice),
772             uint64(_duration),
773             uint64(now)
774         );
775 
776         emit AuctionCreated(_tokenId, _startingPrice, _endingPrice, _duration);
777     }
778 
779     function cancelAuction(uint256 _tokenId) external {
780         require(clockAuctionStorage.isOnAuction(_tokenId));
781         address seller = clockAuctionStorage.getSeller(_tokenId);
782         require(msg.sender == seller);
783         _cancelAuction(_tokenId, seller);
784     }
785 
786     function cancelAuctionWhenPaused(uint256 _tokenId) external whenPaused onlyOwner {
787         require(clockAuctionStorage.isOnAuction(_tokenId));
788         address seller = clockAuctionStorage.getSeller(_tokenId);
789         _cancelAuction(_tokenId, seller);
790     }
791 
792     function getAuction(uint256 _tokenId)
793         public
794         view
795         returns
796     (
797         address seller,
798         uint256 startingPrice,
799         uint256 endingPrice,
800         uint256 duration,
801         uint256 startedAt
802     ) {
803         require(clockAuctionStorage.isOnAuction(_tokenId));
804         return clockAuctionStorage.getAuction(_tokenId);
805     }
806 
807     function getCurrentPrice(uint256 _tokenId)
808         external
809         view
810         returns (uint256)
811     {
812         require(clockAuctionStorage.isOnAuction(_tokenId));
813         return _currentPrice(_tokenId);
814     }
815 
816     function _cancelAuction(uint256 _tokenId, address _seller) internal {
817         clockAuctionStorage.removeAuction(_tokenId);
818         clockAuctionStorage.transfer(nonFungibleContract, _seller, _tokenId);
819         emit AuctionCancelled(_tokenId);
820     }
821 
822     function _bid(uint256 _tokenId, uint256 _bidAmount, address bidder) internal returns (uint256) {
823 
824         require(clockAuctionStorage.isOnAuction(_tokenId));
825 
826         // Check that the bid is greater than or equal to the current price
827         uint256 price = _currentPrice(_tokenId);
828         require(_bidAmount >= price);
829 
830         address seller = clockAuctionStorage.getSeller(_tokenId);
831         uint256 sellerProceeds = 0;
832 
833         // Remove the auction before sending the fees to the sender so we can't have a reentrancy attack
834         clockAuctionStorage.removeAuction(_tokenId);
835 
836         // Transfer proceeds to seller (if there are any!)
837         if (price > 0) {
838             // Calculate the auctioneer's cut, so this subtraction can't go negative
839             uint256 auctioneerCut = _computeCut(price);
840             sellerProceeds = price - auctioneerCut;
841 
842             // transfer the sellerProceeds
843             seller.transfer(sellerProceeds);
844         }
845 
846         // Calculate any excess funds included with the bid
847         // transfer it back to bidder.
848         // this cannot underflow.
849         uint256 bidExcess = _bidAmount - price;
850         bidder.transfer(bidExcess);
851 
852         emit AuctionSuccessful(_tokenId, price, bidder, seller, sellerProceeds);
853 
854         return price;
855     }
856 
857     function _currentPrice(uint256 _tokenId) internal view returns (uint256) {
858 
859         uint256 secondsPassed = 0;
860 
861         address seller;
862         uint128 startingPrice;
863         uint128 endingPrice;
864         uint64 duration;
865         uint64 startedAt;
866         (seller, startingPrice, endingPrice, duration, startedAt) = clockAuctionStorage.getAuction(_tokenId);
867 
868         if (now > startedAt) {
869             secondsPassed = now - startedAt;
870         }
871 
872         return _computeCurrentPrice(
873             startingPrice,
874             endingPrice,
875             duration,
876             secondsPassed
877         );
878     }
879 
880     function _computeCurrentPrice(
881         uint256 _startingPrice,
882         uint256 _endingPrice,
883         uint256 _duration,
884         uint256 _secondsPassed
885     )
886         internal
887         pure
888         returns (uint256)
889     {
890         if (_secondsPassed >= _duration) {
891             return _endingPrice;
892         } else {
893             // this delta can be negative.
894             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
895 
896             // This multiplication can't overflow, _secondsPassed will easily fit within
897             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
898             // will always fit within 256-bits.
899             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
900 
901             // this result will always end up positive.
902             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
903 
904             return uint256(currentPrice);
905         }
906     }
907 
908     function _computeCut(uint256 _price) internal view returns (uint256) {
909         uint256 cutValue = _price * ownerCut / 10000;
910         if (_price < minCutValue) return cutValue;
911         if (cutValue > minCutValue) return cutValue;
912         return minCutValue;
913     }
914 }
915 
916 contract SaleClockAuction is ClockAuction {
917 
918     bool public isSaleClockAuction = true;
919 
920     address public systemSaleAddress;
921     uint256 public systemStartingPriceMin = 20 finney;
922     uint256 public systemEndingPrice = 0;
923     uint256 public systemAuctionDuration = 1 days;
924 
925     function SaleClockAuction(address _nftAddr, address _storageAddress, address _systemSaleAddress, uint256 _cut, uint256 _minCutValue) 
926         ClockAuction(_nftAddr, _storageAddress, _cut, _minCutValue) public
927     {
928         require(SaleClockAuctionStorage(_storageAddress).isSaleClockAuctionStorage());
929         
930         setSystemSaleAddress(_systemSaleAddress);
931     }
932   
933     function bid(uint256 _tokenId) external payable {
934         uint256 price = _bid(_tokenId, msg.value, msg.sender);
935         
936         clockAuctionStorage.transfer(nonFungibleContract, msg.sender, _tokenId);
937         
938         SaleClockAuctionStorage(clockAuctionStorage).recordSoldPrice(price);
939     }
940 
941     function createSystemAuction(uint256 _tokenId) external {
942         require(msg.sender == address(nonFungibleContract));
943 
944         createAuction(
945             _tokenId,
946             computeNextSystemSalePrice(),
947             systemEndingPrice,
948             systemAuctionDuration,
949             systemSaleAddress
950         );
951 
952         SaleClockAuctionStorage(clockAuctionStorage).recordSystemOnSaleToken(_tokenId);
953     }
954 
955     function setSystemSaleAddress(address _systemSaleAddress) public onlyOwner {
956         require(_systemSaleAddress != address(0));
957         systemSaleAddress = _systemSaleAddress;
958     }
959 
960     function setSystemStartingPriceMin(uint256 _startingPrice) external onlyOwner {
961         require(_startingPrice == uint256(uint128(_startingPrice)));
962         systemStartingPriceMin = _startingPrice;
963     }
964 
965     function setSystemEndingPrice(uint256 _endingPrice) external onlyOwner {
966         require(_endingPrice == uint256(uint128(_endingPrice)));
967         systemEndingPrice = _endingPrice;
968     }
969 
970     function setSystemAuctionDuration(uint256 _duration) external onlyOwner {
971         require(_duration == uint256(uint64(_duration)));
972         systemAuctionDuration = _duration;
973     }
974 
975     function totalSoldCount() external view returns (uint256) {
976         return SaleClockAuctionStorage(clockAuctionStorage).totalSoldCount();
977     }
978 
979     function systemOnSaleCount() external view returns (uint256) {
980         return SaleClockAuctionStorage(clockAuctionStorage).systemOnSaleCount();
981     }
982 
983     function averageSoldPrice() external view returns (uint256) {
984         return SaleClockAuctionStorage(clockAuctionStorage).averageSoldPrice();
985     }
986 
987     function computeNextSystemSalePrice() public view returns (uint256) {
988         uint256 avePrice = SaleClockAuctionStorage(clockAuctionStorage).averageSoldPrice();
989 
990         require(avePrice == uint256(uint128(avePrice)));
991 
992         uint256 nextPrice = avePrice + (avePrice / 2);
993 
994         if (nextPrice < systemStartingPriceMin) {
995             nextPrice = systemStartingPriceMin;
996         }
997 
998         return nextPrice;
999     }
1000 }
1001 
1002 contract SiringClockAuctionStorage is ClockAuctionStorage {
1003     bool public isSiringClockAuctionStorage = true;
1004 }
1005 
1006 contract SiringClockAuction is ClockAuction {
1007 
1008     bool public isSiringClockAuction = true;
1009 
1010     function SiringClockAuction(address _nftAddr, address _storageAddress, uint256 _cut, uint256 _minCutValue) 
1011         ClockAuction(_nftAddr, _storageAddress, _cut, _minCutValue) public
1012     {
1013         require(SiringClockAuctionStorage(_storageAddress).isSiringClockAuctionStorage());
1014     }
1015 
1016     function bid(uint256 _tokenId, address bidder) external payable {
1017         // can only be called by CryptoZoo
1018         require(msg.sender == address(nonFungibleContract));
1019         // get seller before the _bid for the auction will be removed once the bid success
1020         address seller = clockAuctionStorage.getSeller(_tokenId);
1021         // _bid checks that token ID is valid and will throw if bid fails
1022         _bid(_tokenId, msg.value, bidder);
1023         // transfer the monster back to the seller, the winner will get the child
1024         clockAuctionStorage.transfer(nonFungibleContract, seller, _tokenId);
1025     }
1026 }
1027 
1028 contract ZooAccessControl is HasNoContracts {
1029 
1030     address public ceoAddress;
1031     address public cfoAddress;
1032     address public cooAddress;
1033 
1034     modifier onlyCEO() {
1035         require(msg.sender == ceoAddress);
1036         _;
1037     }
1038 
1039     modifier onlyCFO() {
1040         require(msg.sender == cfoAddress);
1041         _;
1042     }
1043 
1044     modifier onlyCOO() {
1045         require(msg.sender == cooAddress);
1046         _;
1047     }
1048 
1049     modifier onlyCLevel() {
1050         require(
1051             msg.sender == cooAddress ||
1052             msg.sender == ceoAddress ||
1053             msg.sender == cfoAddress
1054         );
1055         _;
1056     }
1057 
1058     function setCEO(address _newCEO) public onlyCEO {
1059         require(_newCEO != address(0));
1060         ceoAddress = _newCEO;
1061     }
1062 
1063     function setCFO(address _newCFO) public onlyCEO {
1064         require(_newCFO != address(0));
1065         cfoAddress = _newCFO;
1066     }
1067     
1068     function setCOO(address _newCOO) public onlyCEO {
1069         require(_newCOO != address(0));
1070         cooAddress = _newCOO;
1071     }
1072 }
1073 
1074 contract Zoo721 is ZooAccessControl, ERC721 {
1075 
1076     // ERC721 Required
1077     string public constant name = "Giftomon";
1078     // ERC721 Required
1079     string public constant symbol = "GTOM";
1080 
1081     bytes4 constant InterfaceSignature_ERC165 =
1082         bytes4(keccak256("supportsInterface(bytes4)"));
1083 
1084     bytes4 constant InterfaceSignature_ERC721 =
1085         bytes4(keccak256('name()')) ^
1086         bytes4(keccak256('symbol()')) ^
1087         bytes4(keccak256('totalSupply()')) ^
1088         bytes4(keccak256('balanceOf(address)')) ^
1089         bytes4(keccak256('ownerOf(uint256)')) ^
1090         bytes4(keccak256('approve(address,uint256)')) ^
1091         bytes4(keccak256('transfer(address,uint256)')) ^
1092         bytes4(keccak256('transferFrom(address,address,uint256)')) ^
1093         bytes4(keccak256('tokensOfOwner(address)'));
1094 
1095     CryptoStorage public cryptoStorage;
1096 
1097     function Zoo721(address _storageAddress) public {
1098         require(_storageAddress != address(0));
1099         cryptoStorage = CryptoStorage(_storageAddress);
1100     }
1101 
1102     // ERC165 Required
1103     function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
1104         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
1105     }
1106 
1107     // ERC721 Required
1108     function totalSupply() public view returns (uint) {
1109         return cryptoStorage.getMonsterCount();
1110     }
1111     
1112     // ERC721 Required
1113     function balanceOf(address _owner) public view returns (uint256 count) {
1114         return cryptoStorage.ownershipTokenCount(_owner);
1115     }
1116 
1117     // ERC721 Required
1118     function ownerOf(uint256 _tokenId) external view returns (address owner) {
1119         owner = cryptoStorage.monsterIndexToOwner(_tokenId);
1120         require(owner != address(0));
1121     }
1122 
1123     // ERC721 Required
1124     function approve(address _to, uint256 _tokenId) external whenNotPaused {
1125         require(_owns(msg.sender, _tokenId));
1126         _approve(_tokenId, _to);
1127         emit Approval(msg.sender, _to, _tokenId);
1128     }
1129 
1130     // ERC721 Required
1131     function transfer(address _to, uint256 _tokenId) external whenNotPaused {
1132         // Safety check to prevent against an unexpected 0x0 default.
1133         require(_to != address(0));
1134         // Not allow to transfer to the contract itself except for system sale monsters
1135         require(_to != address(this));
1136         // You can only send your own cat.
1137         require(_owns(msg.sender, _tokenId));
1138 
1139         // Reassign ownership, clear pending approvals, emit Transfer event.
1140         _transfer(msg.sender, _to, _tokenId);
1141     }
1142 
1143     // ERC721 Required
1144     function transferFrom(address _from, address _to, uint256 _tokenId) external whenNotPaused {
1145         // Safety check to prevent against an unexpected 0x0 default.
1146         require(_to != address(0));
1147         require(_to != address(this));
1148         // Check for approval and valid ownership
1149         require(_approvedFor(msg.sender, _tokenId));
1150         require(_owns(_from, _tokenId));
1151         // Reassign ownership (also clears pending approvals and emits Transfer event).
1152         _transfer(_from, _to, _tokenId);
1153     }
1154 
1155     // ERC721 Optional
1156     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
1157         uint256 tokenCount = balanceOf(_owner);
1158 
1159         if (tokenCount == 0) {
1160             return new uint256[](0);
1161         } else {
1162             uint256[] memory result = new uint256[](tokenCount);
1163             uint256 totalTokens = totalSupply();
1164             uint256 resultIndex = 0;
1165 
1166             uint256 tokenId;
1167 
1168             for (tokenId = 1; tokenId <= totalTokens; tokenId++) {
1169                 if (cryptoStorage.monsterIndexToOwner(tokenId) == _owner) {
1170                     result[resultIndex] = tokenId;
1171                     resultIndex++;
1172                 }
1173             }
1174 
1175             return result;
1176         }
1177     }
1178 
1179     function _transfer(address _from, address _to, uint256 _tokenId) internal {
1180         // increase number of token owned by _to
1181         cryptoStorage.increaseOwnershipTokenCount(_to);
1182 
1183         // transfer ownership
1184         cryptoStorage.setMonsterIndexToOwner(_tokenId, _to);
1185 
1186         // new monster born does not have previous owner
1187         if (_from != address(0)) {
1188             // decrease number of token owned by _from
1189             cryptoStorage.decreaseOwnershipTokenCount(_from);
1190             // clear any previously approved ownership exchange
1191             cryptoStorage.deleteMonsterIndexToApproved(_tokenId);
1192         }
1193         
1194         emit Transfer(_from, _to, _tokenId);
1195     }
1196 
1197     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
1198         return cryptoStorage.monsterIndexToOwner(_tokenId) == _claimant;
1199     }
1200 
1201     function _approve(uint256 _tokenId, address _approved) internal {
1202         cryptoStorage.setMonsterIndexToApproved(_tokenId, _approved);
1203     }
1204 
1205     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
1206         return cryptoStorage.monsterIndexToApproved(_tokenId) == _claimant;
1207     }
1208 }
1209 
1210 contract CryptoZoo is Zoo721 {
1211 
1212     uint256 public constant SYSTEM_CREATION_LIMIT = 10000;
1213 
1214     // new monster storage fee for the coo
1215     uint256 public autoBirthFee = 2 finney;
1216 
1217     // an approximation of currently how many seconds are in between blocks.
1218     uint256 public secondsPerBlock = 15;
1219 
1220     // hatch duration in second by hatch times (start from 0)
1221     // default to 1 minute if not set and minimum to 1 minute 
1222     // must be an integral multiple of 1 minute
1223     uint32[] public hatchDurationByTimes = [uint32(1 minutes)];
1224 
1225     // hatch duration multiple value by generation (start from 0)
1226     // multiple = value / 60, 60 is the base value
1227     // default to 60 if not set and minimum to 60
1228     // must be an integral multiple of secondsPerBlock
1229     uint32[] public hatchDurationMultiByGeneration = [uint32(60)];
1230 
1231     // sale auctions
1232     SaleClockAuction public saleAuction;
1233     
1234     // siring auctions
1235     SiringClockAuction public siringAuction;
1236 
1237     // activity core
1238     ActivityCore public activityCore;
1239 
1240     // events
1241     event Pregnant(address owner, uint256 matronId, uint256 sireId, uint256 matronCooldownEndBlock, uint256 sireCooldownEndBlock, uint256 breedCost);
1242     event Birth(address owner, uint256 tokenId, uint256 matronId, uint256 sireId);
1243 
1244     // Core Contract of Giftomon
1245     function CryptoZoo(address _storageAddress, address _cooAddress, address _cfoAddress) Zoo721(_storageAddress) public {
1246         // paused by default
1247         paused = true;
1248         // ceo defaults the the contract creator
1249         ceoAddress = msg.sender;
1250 
1251         setCOO(_cooAddress);
1252         setCFO(_cfoAddress);
1253     }
1254 
1255     function() external payable {
1256         require(
1257             msg.sender == address(saleAuction) ||
1258             msg.sender == address(siringAuction) ||
1259             msg.sender == address(activityCore) || 
1260             msg.sender == cooAddress
1261         );
1262     }
1263 
1264     // override to allow any CLevel to pause the contract
1265     function pause() public onlyCLevel whenNotPaused {
1266         super.pause();
1267     }
1268 
1269     // override to make sure everything is initialized before the unpause
1270     function unpause() public onlyCEO whenPaused {
1271         // can not unpause when CLevel addresses is not initialized
1272         require(ceoAddress != address(0));
1273         require(cooAddress != address(0));
1274         require(cfoAddress != address(0));
1275         // can not unpause when the logic contract is not initialzed
1276         require(saleAuction != address(0));
1277         require(siringAuction != address(0));
1278         require(activityCore != address(0));
1279         require(cryptoStorage != address(0));
1280         // can not unpause when ownership of storage contract is not the current contract
1281         require(cryptoStorage.owner() == address(this));
1282 
1283         super.unpause();
1284     }
1285 
1286     // Very dangerous action, only when new contract has been proved working
1287     // Requires cryptoStorage already transferOwnership to the new contract
1288     // This method is only used to transfer the balance (authBirthFee used for giveBirth) to ceo
1289     function destroy() external onlyCEO whenPaused {
1290         address storageOwner = cryptoStorage.owner();
1291         // owner of cryptoStorage must not be the current contract otherwise the cryptoStorage will forever in accessable
1292         require(storageOwner != address(this));
1293         // Transfers the current balance to the ceo and terminates the contract
1294         selfdestruct(ceoAddress);
1295     }
1296 
1297     // Very dangerous action, only when new contract has been proved working
1298     // Requires cryptoStorage already transferOwnership to the new contract
1299     // This method is only used to transfer the balance (authBirthFee used for giveBirth) to the new contract
1300     function destroyAndSendToStorageOwner() external onlyCEO whenPaused {
1301         address storageOwner = cryptoStorage.owner();
1302         // owner of cryptoStorage must not be the current contract otherwise the cryptoStorage will forever in accessable
1303         require(storageOwner != address(this));
1304         // Transfers the current balance to the new owner of the storage contract and terminates the contract
1305         selfdestruct(storageOwner);
1306     }
1307 
1308     function setSaleAuctionAddress(address _address) external onlyCEO {
1309         SaleClockAuction candidateContract = SaleClockAuction(_address);
1310         require(candidateContract.isSaleClockAuction());
1311         saleAuction = candidateContract;
1312     }
1313 
1314     function setSiringAuctionAddress(address _address) external onlyCEO {
1315         SiringClockAuction candidateContract = SiringClockAuction(_address);
1316         require(candidateContract.isSiringClockAuction());
1317         siringAuction = candidateContract;
1318     }
1319 
1320     function setActivityCoreAddress(address _address) external onlyCEO {
1321         ActivityCore candidateContract = ActivityCore(_address);
1322         require(candidateContract.isActivityCore());
1323         activityCore = candidateContract;
1324     }
1325 
1326     function withdrawBalance() external onlyCLevel {
1327         uint256 balance = address(this).balance;
1328         // Subtract all the currently pregnant kittens we have, plus 1 of margin.
1329         uint256 subtractFees = (cryptoStorage.pregnantMonsters() + 1) * autoBirthFee;
1330 
1331         if (balance > subtractFees) {
1332             cfoAddress.transfer(balance - subtractFees);
1333         }
1334     }
1335 
1336     function withdrawBalancesToNFC() external onlyCLevel {
1337         saleAuction.withdrawBalance();
1338         siringAuction.withdrawBalance();
1339         activityCore.withdrawBalance();
1340         cryptoStorage.withdrawBalance();
1341     }
1342 
1343     function withdrawBalancesToLogic() external onlyCLevel {
1344         saleAuction.withdrawBalanceFromStorageContract();
1345         siringAuction.withdrawBalanceFromStorageContract();
1346         activityCore.withdrawBalanceFromStorageContract();
1347     }
1348 
1349     function setAutoBirthFee(uint256 val) external onlyCOO {
1350         autoBirthFee = val;
1351     }
1352 
1353     function setAllHatchConfigs(
1354         uint32[] _durationByTimes,
1355         uint256 _secs,
1356         uint32[] _multiByGeneration
1357     )
1358         external 
1359         onlyCLevel 
1360     {
1361         setHatchDurationByTimes(_durationByTimes);
1362         setSecondsPerBlock(_secs);
1363         setHatchDurationMultiByGeneration(_multiByGeneration);
1364     }
1365 
1366     function setSecondsPerBlock(uint256 _secs) public onlyCLevel {
1367         require(_secs < hatchDurationByTimes[0]);
1368         secondsPerBlock = _secs;
1369     }
1370 
1371     // we must do a carefully check when set hatch duration configuration, since wrong value may break the whole cooldown logic
1372     function setHatchDurationByTimes(uint32[] _durationByTimes) public onlyCLevel {
1373         uint256 len = _durationByTimes.length;
1374         // hatch duration should not be empty
1375         require(len > 0);
1376         // check overflow
1377         require(len == uint256(uint16(len)));
1378         
1379         delete hatchDurationByTimes;
1380         
1381         uint32 value;
1382         for (uint256 idx = 0; idx < len; idx++) {
1383             value = _durationByTimes[idx];
1384             
1385             // duration must be larger than 1 minute, and must be an integral multiple of 1 minute
1386             require(value >= 1 minutes && value % 1 minutes == 0);
1387             
1388             hatchDurationByTimes.push(value);
1389         }
1390     }
1391     
1392     function getHatchDurationByTimes() external view returns (uint32[]) {
1393         return hatchDurationByTimes;
1394     }
1395 
1396     // we must do a carefully check when set hatch duration multi configuration, since wrong value may break the whole cooldown logic
1397     function setHatchDurationMultiByGeneration(uint32[] _multiByGeneration) public onlyCLevel {
1398         uint256 len = _multiByGeneration.length;
1399         // multi configuration should not be empty
1400         require(len > 0);
1401         // check overflow
1402         require(len == uint256(uint16(len)));
1403         
1404         delete hatchDurationMultiByGeneration;
1405         
1406         uint32 value;
1407         for (uint256 idx = 0; idx < len; idx++) {
1408             value = _multiByGeneration[idx];
1409             
1410             // multiple must be larger than 60, and must be an integral multiple of secondsPerBlock
1411             require(value >= 60 && value % secondsPerBlock == 0);
1412             
1413             hatchDurationMultiByGeneration.push(value);
1414         }
1415     }
1416 
1417     function getHatchDurationMultiByGeneration() external view returns (uint32[]) {
1418         return hatchDurationMultiByGeneration;
1419     }
1420 
1421     function createPromoMonster(
1422         uint32 _monsterId, 
1423         bytes _properties, 
1424         address _owner
1425     )
1426         public 
1427         onlyCOO 
1428         whenNotPaused 
1429     {
1430         require(_owner != address(0));
1431 
1432         _createMonster(
1433             0, 
1434             0, 
1435             0, 
1436             uint64(now), 
1437             _monsterId, 
1438             _properties, 
1439             _owner
1440         );
1441 
1442         cryptoStorage.increasePromoCreatedCount();
1443     }
1444 
1445     function createPromoMonsterWithTokenId(
1446         uint32 _monsterId, 
1447         bytes _properties, 
1448         address _owner, 
1449         uint256 _tokenId
1450     ) 
1451         external 
1452         onlyCOO 
1453         whenNotPaused 
1454     {
1455         require(_tokenId > 0 && cryptoStorage.getMonsterCount() + 1 == _tokenId);
1456         
1457         createPromoMonster(_monsterId, _properties, _owner);
1458     }
1459 
1460     function createSystemSaleAuction(
1461         uint32 _monsterId, 
1462         bytes _properties, 
1463         uint16 _generation
1464     )
1465         external 
1466         onlyCOO
1467         whenNotPaused
1468     {
1469         require(cryptoStorage.systemCreatedCount() < SYSTEM_CREATION_LIMIT);
1470 
1471         uint256 tokenId = _createMonster(
1472             0, 
1473             0, 
1474             _generation, 
1475             uint64(now), 
1476             _monsterId, 
1477             _properties, 
1478             saleAuction.systemSaleAddress()
1479         );
1480 
1481         _approve(tokenId, saleAuction);
1482 
1483         saleAuction.createSystemAuction(tokenId);
1484 
1485         cryptoStorage.increaseSystemCreatedCount();
1486     }
1487 
1488     function createSaleAuction(
1489         uint256 _tokenId,
1490         uint256 _startingPrice,
1491         uint256 _endingPrice,
1492         uint256 _duration
1493     )
1494         external
1495         whenNotPaused
1496     {
1497         require(_tokenId > 0);
1498         require(_owns(msg.sender, _tokenId));
1499         // the monster must not pregnant othewise the birth child may owned by the the sale auction or the buyer
1500         require(!isPregnant(_tokenId));
1501         require(saleAuction.isValidPrice(_startingPrice, _endingPrice));
1502         _approve(_tokenId, saleAuction);
1503         // Sale auction throws if inputs are invalid and approve status will be reverted
1504         saleAuction.createAuction(
1505             _tokenId,
1506             _startingPrice,
1507             _endingPrice,
1508             _duration,
1509             msg.sender
1510         );
1511     }
1512 
1513     function createSiringAuction(
1514         uint256 _tokenId,
1515         uint256 _startingPrice,
1516         uint256 _endingPrice,
1517         uint256 _duration
1518     )
1519         external
1520         whenNotPaused
1521     {
1522         require(_tokenId > 0);
1523         require(_owns(msg.sender, _tokenId));
1524         require(isReadyToBreed(_tokenId));
1525         require(siringAuction.isValidPrice(_startingPrice, _endingPrice));
1526         _approve(_tokenId, siringAuction);
1527         // Siring auction throws if inputs are invalid and approve status will be reverted
1528         siringAuction.createAuction(
1529             _tokenId,
1530             _startingPrice,
1531             _endingPrice,
1532             _duration,
1533             msg.sender
1534         );
1535     }
1536 
1537     // breed with the monster siring on market
1538     function bidOnSiringAuction(
1539         uint256 _sireId,
1540         uint256 _matronId
1541     )
1542         external
1543         payable
1544         whenNotPaused
1545     {
1546         require(_matronId > 0);
1547         require(_owns(msg.sender, _matronId));
1548         require(isReadyToBreed(_matronId));
1549         require(isValidMatingPair(_matronId, _sireId));
1550 
1551         // Define the current price of the auction.
1552         uint256 currentPrice = siringAuction.getCurrentPrice(_sireId);
1553         uint256 breedCost = currentPrice + autoBirthFee;
1554         require(msg.value >= breedCost);
1555 
1556         // Siring auction will throw if the bid fails.
1557         siringAuction.bid.value(msg.value - autoBirthFee)(_sireId, msg.sender);
1558         _breedWith(_matronId, _sireId, breedCost);
1559     }
1560 
1561     // breed with the monster of one's own
1562     function breedWithAuto(uint256 _matronId, uint256 _sireId)
1563         external
1564         payable
1565         whenNotPaused
1566     {
1567         // Checks for payment.
1568         require(msg.value >= autoBirthFee);
1569 
1570         // Caller must own the matron and sire
1571         require(_owns(msg.sender, _matronId));
1572         require(_owns(msg.sender, _sireId));
1573 
1574         // any monster in auction will be owned by the auction contract address,
1575         // so the monster must not in auction if it's owned by the msg.sender
1576 
1577         // Make sure matron isn't pregnant, or in the middle of a siring cooldown
1578         require(isReadyToBreed(_matronId));
1579 
1580         // Make sure sire isn't pregnant, or in the middle of a siring cooldown
1581         require(isReadyToBreed(_sireId));
1582 
1583         // Test that these cats are a valid mating pair.
1584         require(isValidMatingPair(_matronId, _sireId));
1585 
1586         // All checks passed, monster gets pregnant!
1587         _breedWith(_matronId, _sireId, autoBirthFee);
1588     }
1589 
1590     function giveBirth(uint256 _matronId, uint256 _monsterId, uint256 _birthTime, bytes _properties)
1591         external
1592         whenNotPaused
1593         onlyCOO
1594         returns (uint256)
1595     {
1596         // the matron is a valid monster
1597         require(cryptoStorage.getBirthTime(_matronId) != 0);
1598 
1599         uint256 sireId = cryptoStorage.getSiringWithId(_matronId);
1600         // the matron is pregnant if and only if this field is set
1601         require(sireId != 0);
1602 
1603         // no need to check cooldown of matron or sire 
1604         // since giveBirth can only be called by COO
1605 
1606         // determine higher generation of the parents
1607         uint16 parentGen = cryptoStorage.getGeneration(_matronId);
1608         uint16 sireGen = cryptoStorage.getGeneration(sireId);
1609         if (sireGen > parentGen) parentGen = sireGen;
1610 
1611         address owner = cryptoStorage.monsterIndexToOwner(_matronId);
1612         uint256 tokenId = _createMonster(
1613             _matronId, 
1614             sireId,
1615             parentGen + 1, 
1616             _birthTime, 
1617             _monsterId, 
1618             _properties, 
1619             owner
1620         );
1621 
1622         // clear pregnant related info
1623         cryptoStorage.deleteSiringWithId(_matronId);
1624 
1625         // decrease pregnant counter.
1626         cryptoStorage.decreasePregnantCounter();
1627 
1628         // send the blockchain storage fee to the coo
1629         msg.sender.transfer(autoBirthFee);
1630 
1631         return tokenId;
1632     }
1633 
1634     function computeCooldownSeconds(uint16 _hatchTimes, uint16 _generation) public view returns (uint32) {
1635         require(hatchDurationByTimes.length > 0);
1636         require(hatchDurationMultiByGeneration.length > 0);
1637 
1638         uint16 hatchTimesMax = uint16(hatchDurationByTimes.length - 1);
1639         uint16 hatchTimes = (_hatchTimes > hatchTimesMax ? hatchTimesMax : _hatchTimes);
1640         
1641         uint16 generationMax = uint16(hatchDurationMultiByGeneration.length - 1);
1642         uint16 generation = (_generation > generationMax ? generationMax : _generation);
1643 
1644         return hatchDurationByTimes[hatchTimes] * hatchDurationMultiByGeneration[generation] / 60;
1645     }
1646 
1647     function isReadyToBreed(uint256 _tokenId) public view returns (bool) {
1648         // not pregnant and not in cooldown
1649         return (cryptoStorage.getSiringWithId(_tokenId) == 0) && (cryptoStorage.getCooldownEndBlock(_tokenId) <= uint64(block.number));
1650     }
1651 
1652     function isPregnant(uint256 _tokenId) public view returns (bool) {
1653         // A monster is pregnant if and only if this field is set
1654         return cryptoStorage.getSiringWithId(_tokenId) != 0;
1655     }
1656 
1657     function isValidMatingPair(uint256 _matronId, uint256 _sireId) public view returns (bool) {
1658         // can't breed with itself!
1659         if (_matronId == _sireId) {
1660             return false;
1661         }
1662         uint32 matron_of_matron = cryptoStorage.getMatronId(_matronId);
1663         uint32 sire_of_matron = cryptoStorage.getSireId(_matronId);
1664         uint32 matron_of_sire = cryptoStorage.getMatronId(_sireId);
1665         uint32 sire_of_sire = cryptoStorage.getSireId(_sireId);
1666         // can't breed with their parents.
1667         if (matron_of_matron == _sireId || sire_of_matron == _sireId) return false;
1668         if (matron_of_sire == _matronId || sire_of_sire == _matronId) return false;
1669         // if either cat is gen zero, they can breed without siblings check
1670         if (matron_of_sire == 0 || matron_of_matron == 0) return true;
1671         // can't breed with full or half siblings.
1672         if (matron_of_sire == matron_of_matron || matron_of_sire == sire_of_matron) return false;
1673         if (sire_of_sire == matron_of_matron || sire_of_sire == sire_of_matron) return false;    
1674         return true;
1675     }
1676 
1677     function _createMonster(
1678         uint256 _matronId,
1679         uint256 _sireId,
1680         uint256 _generation,
1681         uint256 _birthTime,
1682         uint256 _monsterId,
1683         bytes _properties,
1684         address _owner
1685     )
1686         internal
1687         returns (uint256)
1688     {
1689         uint256 tokenId = cryptoStorage.createMonster(
1690             _matronId,
1691             _sireId,
1692             _generation,
1693             _birthTime,
1694             _monsterId,
1695             _properties
1696         );
1697 
1698         _transfer(0, _owner, tokenId);
1699         
1700         emit Birth(_owner, tokenId, _matronId, _sireId);
1701 
1702         return tokenId;
1703     }
1704 
1705     function _breedWith(uint256 _matronId, uint256 _sireId, uint256 _breedCost) internal {
1706         // Mark the matron as pregnant, keeping track of who the sire is.
1707         cryptoStorage.setSiringWithId(_matronId, uint32(_sireId));
1708 
1709         // Trigger the cooldown for both parents.
1710         uint64 sireCooldownEndBlock = _triggerCooldown(_sireId);
1711         uint64 matronCooldownEndBlock = _triggerCooldown(_matronId);
1712 
1713         // increase pregnant counter.
1714         cryptoStorage.increasePregnantCounter();
1715         
1716         // give birth time depends on the shorter cooldown of the two parents
1717         emit Pregnant(
1718             cryptoStorage.monsterIndexToOwner(_matronId),
1719             _matronId,
1720             _sireId,
1721             matronCooldownEndBlock,
1722             sireCooldownEndBlock,
1723             _breedCost
1724         );
1725     }
1726 
1727     // Compute an estimation of the cooldown time in blocks (based on current cooldownIndex).
1728     function _triggerCooldown(uint256 _tokenId) internal returns (uint64) {
1729         uint32 cooldownSeconds = computeCooldownSeconds(cryptoStorage.getCooldownIndex(_tokenId), cryptoStorage.getGeneration(_tokenId));
1730         uint64 cooldownEndBlock = uint64((cooldownSeconds / secondsPerBlock) + block.number);
1731         cryptoStorage.setCooldownEndBlock(_tokenId, cooldownEndBlock);
1732         // increate hatch times by 1
1733         cryptoStorage.setCooldownIndex(_tokenId);
1734         return cooldownEndBlock;
1735     }
1736 }