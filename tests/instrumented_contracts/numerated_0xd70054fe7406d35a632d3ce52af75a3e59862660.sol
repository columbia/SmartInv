1 pragma solidity ^0.4.23;
2 
3 /* Controls state and access rights for contract functions
4  * @title Operational Control
5  * @author Fazri Zubair & Farhan Khwaja (Lucid Sight, Inc.)
6  * Inspired and adapted from contract created by OpenZeppelin
7  * Ref: https://github.com/OpenZeppelin/zeppelin-solidity/
8  */
9 contract OperationalControl {
10     // Facilitates access & control for the game.
11     // Roles:
12     //  -The Managers (Primary/Secondary): Has universal control of all elements (No ability to withdraw)
13     //  -The Banker: The Bank can withdraw funds and adjust fees / prices.
14     //  -otherManagers: Contracts that need access to functions for gameplay
15 
16     /// @dev Emited when contract is upgraded
17     event ContractUpgrade(address newContract);
18 
19     // The addresses of the accounts (or contracts) that can execute actions within each roles.
20     address public managerPrimary;
21     address public managerSecondary;
22     address public bankManager;
23 
24     // Contracts that require access for gameplay
25     mapping(address => uint8) public otherManagers;
26 
27     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
28     bool public paused = false;
29 
30     // @dev Keeps track whether the contract erroredOut. When that is true, most actions are blocked & refund can be claimed
31     bool public error = false;
32 
33     /// @dev Operation modifiers for limiting access
34     modifier onlyManager() {
35         require(msg.sender == managerPrimary || msg.sender == managerSecondary);
36         _;
37     }
38 
39     modifier onlyBanker() {
40         require(msg.sender == bankManager);
41         _;
42     }
43 
44     modifier onlyOtherManagers() {
45         require(otherManagers[msg.sender] == 1);
46         _;
47     }
48 
49 
50     modifier anyOperator() {
51         require(
52             msg.sender == managerPrimary ||
53             msg.sender == managerSecondary ||
54             msg.sender == bankManager ||
55             otherManagers[msg.sender] == 1
56         );
57         _;
58     }
59 
60     /// @dev Assigns a new address to act as the Other Manager. (State = 1 is active, 0 is disabled)
61     function setOtherManager(address _newOp, uint8 _state) external onlyManager {
62         require(_newOp != address(0));
63 
64         otherManagers[_newOp] = _state;
65     }
66 
67     /// @dev Assigns a new address to act as the Primary Manager.
68     function setPrimaryManager(address _newGM) external onlyManager {
69         require(_newGM != address(0));
70 
71         managerPrimary = _newGM;
72     }
73 
74     /// @dev Assigns a new address to act as the Secondary Manager.
75     function setSecondaryManager(address _newGM) external onlyManager {
76         require(_newGM != address(0));
77 
78         managerSecondary = _newGM;
79     }
80 
81     /// @dev Assigns a new address to act as the Banker.
82     function setBanker(address _newBK) external onlyManager {
83         require(_newBK != address(0));
84 
85         bankManager = _newBK;
86     }
87 
88     /*** Pausable functionality adapted from OpenZeppelin ***/
89 
90     /// @dev Modifier to allow actions only when the contract IS NOT paused
91     modifier whenNotPaused() {
92         require(!paused);
93         _;
94     }
95 
96     /// @dev Modifier to allow actions only when the contract IS paused
97     modifier whenPaused {
98         require(paused);
99         _;
100     }
101 
102     /// @dev Modifier to allow actions only when the contract has Error
103     modifier whenError {
104         require(error);
105         _;
106     }
107 
108     /// @dev Called by any Operator role to pause the contract.
109     /// Used only if a bug or exploit is discovered (Here to limit losses / damage)
110     function pause() external onlyManager whenNotPaused {
111         paused = true;
112     }
113 
114     /// @dev Unpauses the smart contract. Can only be called by the Game Master
115     /// @notice This is public rather than external so it can be called by derived contracts. 
116     function unpause() public onlyManager whenPaused {
117         // can't unpause if contract was upgraded
118         paused = false;
119     }
120 
121     /// @dev Unpauses the smart contract. Can only be called by the Game Master
122     /// @notice This is public rather than external so it can be called by derived contracts. 
123     function hasError() public onlyManager whenPaused {
124         error = true;
125     }
126 
127     /// @dev Unpauses the smart contract. Can only be called by the Game Master
128     /// @notice This is public rather than external so it can be called by derived contracts. 
129     function noError() public onlyManager whenPaused {
130         error = false;
131     }
132 }
133 
134 contract CCNFTFactory {
135 
136    
137     /** Public Functions */
138 
139     function getAssetDetails(uint256 _assetId) public view returns(
140         uint256 assetId,
141         uint256 ownersIndex,
142         uint256 assetTypeSeqId,
143         uint256 assetType,
144         uint256 createdTimestamp,
145         uint256 isAttached,
146         address creator,
147         address owner
148     );
149 
150     function getAssetDetailsURI(uint256 _assetId) public view returns(
151         uint256 assetId,
152         uint256 ownersIndex,
153         uint256 assetTypeSeqId,
154         uint256 assetType,
155         uint256 createdTimestamp,
156         uint256 isAttached,
157         address creator,
158         address owner,
159         string metaUriAddress
160     );
161 
162     function getAssetRawMeta(uint256 _assetId) public view returns(
163         uint256 dataA,
164         uint128 dataB
165     );
166 
167     function getAssetIdItemType(uint256 _assetId) public view returns(
168         uint256 assetType
169     );
170 
171     function getAssetIdTypeSequenceId(uint256 _assetId) public view returns(
172         uint256 assetTypeSequenceId
173     );
174     
175     function getIsNFTAttached( uint256 _tokenId) 
176     public view returns(
177         uint256 isAttached
178     );
179 
180     function getAssetIdCreator(uint256 _assetId) public view returns(
181         address creator
182     );
183     function getAssetIdOwnerAndOIndex(uint256 _assetId) public view returns(
184         address owner,
185         uint256 ownerIndex
186     );
187     function getAssetIdOwnerIndex(uint256 _assetId) public view returns(
188         uint256 ownerIndex
189     );
190 
191     function getAssetIdOwner(uint256 _assetId) public view returns(
192         address owner
193     );
194 
195     function spawnAsset(address _to, uint256 _assetType, uint256 _assetID, uint256 _isAttached) public;
196 
197     function isAssetIdOwnerOrApproved(address requesterAddress, uint256 _assetId) public view returns(
198         bool
199     );
200     /// @param _owner The owner whose ships tokens we are interested in.
201     /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
202     ///  expensive (it walks the entire NFT owners array looking for NFT belonging to owner),
203     ///  but it also returns a dynamic array, which is only supported for web3 calls, and
204     ///  not contract-to-contract calls.
205     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens);
206     // Get the name of the Asset type
207     function getTypeName (uint32 _type) public returns(string);
208     function RequestDetachment(
209         uint256 _tokenId
210     )
211         public;
212     function AttachAsset(
213         uint256 _tokenId
214     )
215         public;
216     function BatchAttachAssets(uint256[10] _ids) public;
217     function BatchDetachAssets(uint256[10] _ids) public;
218     function RequestDetachmentOnPause (uint256 _tokenId) public;
219     function burnAsset(uint256 _assetID) public;
220     function balanceOf(address _owner) public view returns (uint256 _balance);
221     function ownerOf(uint256 _tokenId) public view returns (address _owner);
222     function exists(uint256 _tokenId) public view returns (bool _exists);
223     function approve(address _to, uint256 _tokenId) public;
224     function getApproved(uint256 _tokenId)
225         public view returns (address _operator);
226     function setApprovalForAll(address _operator, bool _approved) public;
227     function isApprovedForAll(address _owner, address _operator)
228         public view returns (bool);
229     function transferFrom(address _from, address _to, uint256 _tokenId) public;
230     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
231     function safeTransferFrom(
232         address _from,
233         address _to,
234         uint256 _tokenId,
235         bytes _data
236     )
237         public;
238 
239 }
240 
241 /**
242  * @title ERC721 token receiver interface
243  * @dev Interface for any contract that wants to support safeTransfers
244  *  from ERC721 asset contracts.
245  */
246 contract ERC721Receiver {
247     /**
248     * @dev Magic value to be returned upon successful reception of an NFT
249     *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
250     *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
251     */
252     bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
253 
254     /**
255     * @notice Handle the receipt of an NFT
256     * @dev The ERC721 smart contract calls this function on the recipient
257     *  after a `safetransfer`. This function MAY throw to revert and reject the
258     *  transfer. This function MUST use 50,000 gas or less. Return of other
259     *  than the magic value MUST result in the transaction being reverted.
260     *  Note: the contract address is always the message sender.
261     * @param _from The sending address
262     * @param _tokenId The NFT identifier which is being transfered
263     * @param _data Additional data with no specified format
264     * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
265     */
266     function onERC721Received(
267         address _from,
268         uint256 _tokenId,
269         bytes _data
270     )
271         public
272         returns(bytes4);
273 }
274 contract ERC721Holder is ERC721Receiver {
275     function onERC721Received(address, uint256, bytes) public returns(bytes4) {
276         return ERC721_RECEIVED;
277     }
278 }
279 
280 contract CCTimeSaleManager is ERC721Holder, OperationalControl {
281     //DATATYPES & CONSTANTS
282     struct CollectibleSale {
283         // Current owner of NFT (ERC721)
284         address seller;
285         // Price (in wei) at beginning of sale (For Buying)
286         uint256 startingPrice;
287         // Price (in wei) at end of sale (For Buying)
288         uint256 endingPrice;
289         // Duration (in seconds) of sale, 2592000 = 30 days
290         uint256 duration;
291         // Time when sale started
292         // NOTE: 0 if this sale has been concluded
293         uint64 startedAt;
294         // Flag denoting is the Sale still active
295         bool isActive;
296         // address of the wallet who bought the asset
297         address buyer;
298         // ERC721 AssetID
299         uint256 tokenId;
300     }
301     struct PastSales {
302         uint256[5] sales;
303     }
304 
305     // CCNTFAddress
306     address public NFTAddress;
307 
308     // Map from token to their corresponding sale.
309     mapping (uint256 => CollectibleSale) public tokenIdToSale;
310 
311     // Count of AssetType Sales
312     mapping (uint256 => uint256) public assetTypeSaleCount;
313 
314     // Last 5 Prices of AssetType Sales
315     mapping (uint256 => PastSales) internal assetTypeSalePrices;
316 
317     uint256 public avgSalesToCount = 5;
318 
319     // type to sales of type
320     mapping(uint256 => uint256[]) public assetTypeSalesTokenId;
321 
322     event SaleWinner(address owner, uint256 collectibleId, uint256 buyingPrice);
323     event SaleCreated(uint256 tokenID, uint256 startingPrice, uint256 endingPrice, uint256 duration, uint64 startedAt);
324     event SaleCancelled(address seller, uint256 collectibleId);
325 
326     // If > 0 then vending is enable for item type
327     mapping (uint256 => uint256) internal vendingAmountType;
328 
329     // If > 0 then vending is enable for item type
330     mapping (uint256 => uint256) internal vendingTypeSold;
331 
332     // Current Price for vending type 
333     mapping (uint256 => uint256) internal vendingPrice;
334 
335     // Price to step up for vending type
336     mapping (uint256 => uint256) internal vendingStepUpAmount;
337 
338     // Qty to step up vending item
339     mapping (uint256 => uint256) internal vendingStepUpQty;
340 
341     uint256 public startingIndex = 100000;
342 
343     uint256 public vendingAttachedState = 1;
344 
345 
346     constructor() public {
347         require(msg.sender != address(0));
348         paused = true;
349         error = false;
350         managerPrimary = msg.sender;
351         managerSecondary = msg.sender;
352         bankManager = msg.sender;
353     }
354 
355     function  setNFTAddress(address _address) public onlyManager {
356         NFTAddress = _address;
357     }
358 
359     function setAvgSalesCount(uint256 _count) public onlyManager  {
360         avgSalesToCount = _count;
361     }
362 
363     /// @dev Creates and begins a new sale.
364     function CreateSale(uint256 _tokenId, uint256 _startingPrice, uint256 _endingPrice, uint64 _duration, address _seller) public anyOperator {
365         _createSale(_tokenId, _startingPrice, _endingPrice, _duration, _seller);
366     }
367 
368     function BatchCreateSales(uint256[] _tokenIds, uint256 _startingPrice, uint256 _endingPrice, uint64 _duration, address _seller) public anyOperator {
369         uint256 _tokenId;
370         for (uint256 i = 0; i < _tokenIds.length; ++i) {
371             _tokenId = _tokenIds[i];
372             _createSale(_tokenId, _startingPrice, _endingPrice, _duration, _seller);
373         }
374     }
375 
376     function CreateSaleAvgPrice(uint256 _tokenId, uint256 _margin, uint _minPrice, uint256 _endingPrice, uint64 _duration, address _seller) public anyOperator {
377         var ccNFT = CCNFTFactory(NFTAddress);
378         uint256 assetType = ccNFT.getAssetIdItemType(_tokenId);
379         // Avg Price of last sales
380         uint256 salePrice = GetAssetTypeAverageSalePrice(assetType);
381 
382         //  0-10,000 is mapped to 0%-100% - will be typically 12000 or 120%
383         salePrice = salePrice * _margin / 10000;
384 
385         if(salePrice < _minPrice) {
386             salePrice = _minPrice;
387         } 
388        
389         _createSale(_tokenId, salePrice, _endingPrice, _duration, _seller);
390     }
391 
392     function BatchCreateSaleAvgPrice(uint256[] _tokenIds, uint256 _margin, uint _minPrice, uint256 _endingPrice, uint64 _duration, address _seller) public anyOperator {
393         var ccNFT = CCNFTFactory(NFTAddress);
394         uint256 assetType;
395         uint256 _tokenId;
396         uint256 salePrice;
397         for (uint256 i = 0; i < _tokenIds.length; ++i) {
398             _tokenId = _tokenIds[i];
399             assetType = ccNFT.getAssetIdItemType(_tokenId);
400             // Avg Price of last sales
401             salePrice = GetAssetTypeAverageSalePrice(assetType);
402 
403             //  0-10,000 is mapped to 0%-100% - will be typically 12000 or 120%
404             salePrice = salePrice * _margin / 10000;
405 
406             if(salePrice < _minPrice) {
407                 salePrice = _minPrice;
408             } 
409             
410             _tokenId = _tokenIds[i];
411             _createSale(_tokenId, salePrice, _endingPrice, _duration, _seller);
412         }
413     }
414 
415     function BatchCancelSales(uint256[] _tokenIds) public anyOperator {
416         uint256 _tokenId;
417         for (uint256 i = 0; i < _tokenIds.length; ++i) {
418             _tokenId = _tokenIds[i];
419             _cancelSale(_tokenId);
420         }
421     }
422 
423     function CancelSale(uint256 _assetId) public anyOperator {
424         _cancelSale(_assetId);
425     }
426 
427     function GetCurrentSalePrice(uint256 _assetId) external view returns(uint256 _price) {
428         CollectibleSale memory _sale = tokenIdToSale[_assetId];
429         
430         return _currentPrice(_sale);
431     }
432 
433     function GetCurrentTypeSalePrice(uint256 _assetType) external view returns(uint256 _price) {
434         CollectibleSale memory _sale = tokenIdToSale[assetTypeSalesTokenId[_assetType][0]];
435         return _currentPrice(_sale);
436     }
437 
438     function GetCurrentTypeDuration(uint256 _assetType) external view returns(uint256 _duration) {
439         CollectibleSale memory _sale = tokenIdToSale[assetTypeSalesTokenId[_assetType][0]];
440         return  _sale.duration;
441     }
442 
443     function GetCurrentTypeStartTime(uint256 _assetType) external view returns(uint256 _startedAt) {
444         CollectibleSale memory _sale = tokenIdToSale[assetTypeSalesTokenId[_assetType][0]];
445         return  _sale.startedAt;
446     }
447 
448     function GetCurrentTypeSaleItem(uint256 _assetType) external view returns(address seller, uint256 startingPrice, uint256 endingPrice, uint256 duration, uint256 startedAt, uint256 tokenId) {
449         CollectibleSale memory _sale = tokenIdToSale[assetTypeSalesTokenId[_assetType][0]];
450         return (
451             _sale.seller,
452             _sale.startingPrice,
453             _sale.endingPrice,
454             _sale.duration,
455             _sale.startedAt,
456             _sale.tokenId
457         );
458     }
459 
460     function GetCurrentTypeSaleCount(uint256 _assetType) external view returns(uint256 _count) {
461         return assetTypeSalesTokenId[_assetType].length;
462     }
463 
464     function BuyCurrentTypeOfAsset(uint256 _assetType) external whenNotPaused payable {
465         require(msg.sender != address(0));
466         require(msg.sender != address(this));
467 
468         CollectibleSale memory _sale = tokenIdToSale[assetTypeSalesTokenId[_assetType][0]];
469         require(_isOnSale(_sale));
470 
471         _buy(_sale.tokenId, msg.sender, msg.value);
472     }
473 
474     /// @dev BuyNow Function which call the interncal buy function
475     /// after doing all the pre-checks required to initiate a buy
476     function BuyAsset(uint256 _assetId) external whenNotPaused payable {
477         require(msg.sender != address(0));
478         require(msg.sender != address(this));
479         CollectibleSale memory _sale = tokenIdToSale[_assetId];
480         require(_isOnSale(_sale));
481         
482         //address seller = _sale.seller;
483 
484         _buy(_assetId, msg.sender, msg.value);
485     }
486 
487     function GetAssetTypeAverageSalePrice(uint256 _assetType) public view returns (uint256) {
488         uint256 sum = 0;
489         for (uint256 i = 0; i < avgSalesToCount; i++) {
490             sum += assetTypeSalePrices[_assetType].sales[i];
491         }
492         return sum / 5;
493     }
494 
495     /// @dev Override unpause so it requires all external contract addresses
496     ///  to be set before contract can be unpaused. Also, we can't have
497     ///  newContractAddress set either, because then the contract was upgraded.
498     /// @notice This is public rather than external so we can call super.unpause
499     ///  without using an expensive CALL.
500     function unpause() public anyOperator whenPaused {
501         // Actually unpause the contract.
502         super.unpause();
503     }
504 
505     /// @dev Remove all Ether from the contract, which is the owner's cuts
506     ///  as well as any Ether sent directly to the contract address.
507     ///  Always transfers to the NFT (ERC721) contract, but can be called either by
508     ///  the owner or the NFT (ERC721) contract.
509     function withdrawBalance() public onlyBanker {
510         // We are using this boolean method to make sure that even if one fails it will still work
511         bankManager.transfer(address(this).balance);
512     }
513 
514     /// @dev Returns sales info for an CSLCollectibles (ERC721) on sale.
515     /// @param _assetId - ID of the token on sale
516     function getSale(uint256 _assetId) external view returns (address seller, uint256 startingPrice, uint256 endingPrice, uint256 duration, uint256 startedAt, bool isActive, address buyer, uint256 tokenId) {
517         CollectibleSale memory sale = tokenIdToSale[_assetId];
518         require(_isOnSale(sale));
519         return (
520             sale.seller,
521             sale.startingPrice,
522             sale.endingPrice,
523             sale.duration,
524             sale.startedAt,
525             sale.isActive,
526             sale.buyer,
527             sale.tokenId
528         );
529     }
530 
531 
532     /** Internal Functions */
533 
534     function _createSale(uint256 _tokenId, uint256 _startingPrice, uint256 _endingPrice, uint64 _duration, address _seller) internal {
535         var ccNFT = CCNFTFactory(NFTAddress);
536 
537         require(ccNFT.isAssetIdOwnerOrApproved(this, _tokenId) == true);
538         
539         CollectibleSale memory onSale = tokenIdToSale[_tokenId];
540         require(onSale.isActive == false);
541 
542         // Sanity check that no inputs overflow how many bits we've allocated
543         // to store them in the sale struct.
544         require(_startingPrice == uint256(uint128(_startingPrice)));
545         require(_endingPrice == uint256(uint128(_endingPrice)));
546         require(_duration == uint256(uint64(_duration)));
547 
548         //Transfer ownership if needed
549         if(ccNFT.ownerOf(_tokenId) != address(this)) {
550             
551             require(ccNFT.isApprovedForAll(msg.sender, this) == true);
552 
553             ccNFT.safeTransferFrom(ccNFT.ownerOf(_tokenId), this, _tokenId);
554         }
555 
556         CollectibleSale memory sale = CollectibleSale(
557             _seller,
558             uint128(_startingPrice),
559             uint128(_endingPrice),
560             uint64(_duration),
561             uint64(now),
562             true,
563             address(0),
564             uint256(_tokenId)
565         );
566         _addSale(_tokenId, sale);
567     }
568 
569     /// @dev Adds an sale to the list of open sales. Also fires the
570     ///  SaleCreated event.
571     function _addSale(uint256 _assetId, CollectibleSale _sale) internal {
572         // Require that all sales have a duration of
573         // at least one minute.
574         require(_sale.duration >= 1 minutes);
575         
576         tokenIdToSale[_assetId] = _sale;
577 
578         var ccNFT = CCNFTFactory(NFTAddress);
579         uint256 assetType = ccNFT.getAssetIdItemType(_assetId);
580         assetTypeSalesTokenId[assetType].push(_assetId);
581 
582         SaleCreated(
583             uint256(_assetId),
584             uint256(_sale.startingPrice),
585             uint256(_sale.endingPrice),
586             uint256(_sale.duration),
587             uint64(_sale.startedAt)
588         );
589     }
590 
591     /// @dev Returns current price of a Collectible (ERC721) on sale. Broken into two
592     ///  functions (this one, that computes the duration from the sale
593     ///  structure, and the other that does the price computation) so we
594     ///  can easily test that the price computation works correctly.
595     function _currentPrice(CollectibleSale memory _sale) internal view returns (uint256) {
596         uint256 secondsPassed = 0;
597 
598         // A bit of insurance against negative values (or wraparound).
599         // Probably not necessary (since Ethereum guarnatees that the
600         // now variable doesn't ever go backwards).
601         if (now > _sale.startedAt) {
602             secondsPassed = now - _sale.startedAt;
603         }
604 
605         return _computeCurrentPrice(
606             _sale.startingPrice,
607             _sale.endingPrice,
608             _sale.duration,
609             secondsPassed
610         );
611     }
612 
613     /// @dev Computes the current price of an sale. Factored out
614     ///  from _currentPrice so we can run extensive unit tests.
615     ///  When testing, make this function public and turn on
616     ///  `Current price computation` test suite.
617     function _computeCurrentPrice(uint256 _startingPrice, uint256 _endingPrice, uint256 _duration, uint256 _secondsPassed) internal pure returns (uint256) {
618         // NOTE: We don't use SafeMath (or similar) in this function because
619         //  all of our public functions carefully cap the maximum values for
620         //  time (at 64-bits) and currency (at 128-bits). _duration is
621         //  also known to be non-zero (see the require() statement in
622         //  _addSale())
623         if (_secondsPassed >= _duration) {
624             // We've reached the end of the dynamic pricing portion
625             // of the sale, just return the end price.
626             return _endingPrice;
627         } else {
628             // Starting price can be higher than ending price (and often is!), so
629             // this delta can be negative.
630             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
631 
632             // This multiplication can't overflow, _secondsPassed will easily fit within
633             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
634             // will always fit within 256-bits.
635             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
636 
637             // currentPriceChange can be negative, but if so, will have a magnitude
638             // less that _startingPrice. Thus, this result will always end up positive.
639             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
640 
641             return uint256(currentPrice);
642         }
643     }
644 
645     function _buy(uint256 _assetId, address _buyer, uint256 _price) internal {
646 
647         CollectibleSale storage _sale = tokenIdToSale[_assetId];
648 
649         // Check that the bid is greater than or equal to the current buyOut price
650         uint256 currentPrice = _currentPrice(_sale);
651 
652         require(_price >= currentPrice);
653         _sale.buyer = _buyer;
654         _sale.isActive = false;
655 
656         _removeSale(_assetId);
657 
658         uint256 bidExcess = _price - currentPrice;
659         _buyer.transfer(bidExcess);
660 
661         var ccNFT = CCNFTFactory(NFTAddress);
662         uint256 assetType = ccNFT.getAssetIdItemType(_assetId);
663         _updateSaleAvgHistory(assetType, _price);
664         ccNFT.safeTransferFrom(this, _buyer, _assetId);
665 
666         emit SaleWinner(_buyer, _assetId, _price);
667     }
668 
669     function _cancelSale (uint256 _assetId) internal {
670         CollectibleSale storage _sale = tokenIdToSale[_assetId];
671 
672         require(_sale.isActive == true);
673 
674         address sellerAddress = _sale.seller;
675 
676         _removeSale(_assetId);
677 
678         var ccNFT = CCNFTFactory(NFTAddress);
679 
680         ccNFT.safeTransferFrom(this, sellerAddress, _assetId);
681 
682         emit SaleCancelled(sellerAddress, _assetId);
683     }
684     
685     /// @dev Returns true if the FT (ERC721) is on sale.
686     function _isOnSale(CollectibleSale memory _sale) internal view returns (bool) {
687         return (_sale.startedAt > 0 && _sale.isActive);
688     }
689 
690     function _updateSaleAvgHistory(uint256 _assetType, uint256 _price) internal {
691         assetTypeSaleCount[_assetType] += 1;
692         assetTypeSalePrices[_assetType].sales[assetTypeSaleCount[_assetType] % avgSalesToCount] = _price;
693     }
694 
695     /// @dev Removes an sale from the list of open sales.
696     /// @param _assetId - ID of the token on sale
697     function _removeSale(uint256 _assetId) internal {
698         delete tokenIdToSale[_assetId];
699 
700         var ccNFT = CCNFTFactory(NFTAddress);
701         uint256 assetType = ccNFT.getAssetIdItemType(_assetId);
702 
703         bool hasFound = false;
704         for (uint i = 0; i < assetTypeSalesTokenId[assetType].length; i++) {
705             if ( assetTypeSalesTokenId[assetType][i] == _assetId) {
706                 hasFound = true;
707             }
708             if(hasFound == true) {
709                 if(i+1 < assetTypeSalesTokenId[assetType].length)
710                     assetTypeSalesTokenId[assetType][i] = assetTypeSalesTokenId[assetType][i+1];
711                 else 
712                     delete assetTypeSalesTokenId[assetType][i];
713             }
714         }
715         assetTypeSalesTokenId[assetType].length--;
716     }
717 
718 
719     // Vending
720 
721     function setVendingAttachedState (uint256 _collectibleType, uint256 _state) external onlyManager {
722         vendingAttachedState = _state;
723     }
724 
725     /// @dev Function toggle vending for collectible
726     function setVendingAmount (uint256 _collectibleType, uint256 _vendingQty) external onlyManager {
727         vendingAmountType[_collectibleType] = _vendingQty;
728     }
729 
730     /// @dev Function sets the starting price / reset price
731     function setVendingStartPrice (uint256 _collectibleType, uint256 _startingPrice) external onlyManager {
732         vendingPrice[_collectibleType] = _startingPrice;
733     }
734 
735     /// @dev Sets Step Value
736     function setVendingStepValues(uint256 _collectibleType, uint256 _stepAmount, uint256 _stepQty) external onlyManager {
737         vendingStepUpQty[_collectibleType] = _stepQty;
738         vendingStepUpAmount[_collectibleType] = _stepAmount;
739     }
740 
741     /// @dev Create Vending Helper
742     function createVendingItem(uint256 _collectibleType, uint256 _vendingQty, uint256 _startingPrice, uint256 _stepAmount, uint256 _stepQty) external onlyManager {
743         vendingAmountType[_collectibleType] = _vendingQty;
744         vendingPrice[_collectibleType] = _startingPrice;
745         vendingStepUpQty[_collectibleType] = _stepQty;
746         vendingStepUpAmount[_collectibleType] = _stepAmount;
747     }
748 
749     /// @dev This helps in creating a collectible and then 
750     /// transfer it _toAddress
751     function vendingCreateCollectible(uint256 _collectibleType, address _toAddress) payable external whenNotPaused {
752         
753         //Only if Vending is Allowed for this Asset
754         require((vendingAmountType[_collectibleType] - vendingTypeSold[_collectibleType]) > 0);
755 
756         require(msg.value >= vendingPrice[_collectibleType]);
757 
758         require(msg.sender != address(0));
759         require(msg.sender != address(this));
760         
761         require(_toAddress != address(0));
762         require(_toAddress != address(this));
763 
764         var ccNFT = CCNFTFactory(NFTAddress);
765 
766         ccNFT.spawnAsset(_toAddress, _collectibleType, startingIndex, vendingAttachedState);
767 
768         startingIndex += 1;
769 
770         vendingTypeSold[_collectibleType] += 1;
771 
772         uint256 excessBid = msg.value - vendingPrice[_collectibleType];
773 
774         if(vendingTypeSold[_collectibleType] % vendingStepUpQty[_collectibleType] == 0) {
775             vendingPrice[_collectibleType] += vendingStepUpAmount[_collectibleType];
776         }
777 
778         if(excessBid > 0) {
779             msg.sender.transfer(excessBid);
780         }
781  
782     }
783 
784     function getVendingAmountLeft (uint256 _collectibleType) view public returns (uint256) {
785         return (vendingAmountType[_collectibleType] - vendingTypeSold[_collectibleType]);
786     }
787 
788     function getVendingAmountSold (uint256 _collectibleType) view public returns (uint256) {
789         return (vendingTypeSold[_collectibleType]);
790     }
791 
792     function getVendingPrice (uint256 _collectibleType) view public returns (uint256) {
793         return (vendingPrice[_collectibleType]);
794     }
795 
796     function getVendingStepPrice (uint256 _collectibleType) view public returns (uint256) {
797         return (vendingStepUpAmount[_collectibleType]);
798     }
799 
800     function getVendingStepQty (uint256 _collectibleType) view public returns (uint256) {
801         return (vendingStepUpQty[_collectibleType]);
802     }
803 
804     function getVendingInfo (uint256 _collectibleType) view public returns (uint256 amountRemaining, uint256 sold, uint256 price, uint256 stepPrice, uint256 stepQty) {
805         amountRemaining = (vendingAmountType[_collectibleType] - vendingTypeSold[_collectibleType]);
806         sold = vendingTypeSold[_collectibleType];
807         price = vendingPrice[_collectibleType];
808         stepPrice = vendingStepUpAmount[_collectibleType];
809         stepQty = vendingStepUpQty[_collectibleType];
810     }
811 
812 }