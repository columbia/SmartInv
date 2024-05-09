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
134 contract CSCNFTFactory {
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
195     function isAssetIdOwnerOrApproved(address requesterAddress, uint256 _assetId) public view returns(
196         bool
197     );
198     /// @param _owner The owner whose ships tokens we are interested in.
199     /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
200     ///  expensive (it walks the entire NFT owners array looking for NFT belonging to owner),
201     ///  but it also returns a dynamic array, which is only supported for web3 calls, and
202     ///  not contract-to-contract calls.
203     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens);
204     // Get the name of the Asset type
205     function getTypeName (uint32 _type) public returns(string);
206     function RequestDetachment(
207         uint256 _tokenId
208     )
209         public;
210     function AttachAsset(
211         uint256 _tokenId
212     )
213         public;
214     function BatchAttachAssets(uint256[10] _ids) public;
215     function BatchDetachAssets(uint256[10] _ids) public;
216     function RequestDetachmentOnPause (uint256 _tokenId) public;
217     function burnAsset(uint256 _assetID) public;
218     function balanceOf(address _owner) public view returns (uint256 _balance);
219     function ownerOf(uint256 _tokenId) public view returns (address _owner);
220     function exists(uint256 _tokenId) public view returns (bool _exists);
221     function approve(address _to, uint256 _tokenId) public;
222     function getApproved(uint256 _tokenId)
223         public view returns (address _operator);
224     function setApprovalForAll(address _operator, bool _approved) public;
225     function isApprovedForAll(address _owner, address _operator)
226         public view returns (bool);
227     function transferFrom(address _from, address _to, uint256 _tokenId) public;
228     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
229     function safeTransferFrom(
230         address _from,
231         address _to,
232         uint256 _tokenId,
233         bytes _data
234     )
235         public;
236 
237 }
238 
239 /**
240  * @title ERC721 token receiver interface
241  * @dev Interface for any contract that wants to support safeTransfers
242  *  from ERC721 asset contracts.
243  */
244 contract ERC721Receiver {
245     /**
246     * @dev Magic value to be returned upon successful reception of an NFT
247     *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
248     *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
249     */
250     bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
251 
252     /**
253     * @notice Handle the receipt of an NFT
254     * @dev The ERC721 smart contract calls this function on the recipient
255     *  after a `safetransfer`. This function MAY throw to revert and reject the
256     *  transfer. This function MUST use 50,000 gas or less. Return of other
257     *  than the magic value MUST result in the transaction being reverted.
258     *  Note: the contract address is always the message sender.
259     * @param _from The sending address
260     * @param _tokenId The NFT identifier which is being transfered
261     * @param _data Additional data with no specified format
262     * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
263     */
264     function onERC721Received(
265         address _from,
266         uint256 _tokenId,
267         bytes _data
268     )
269         public
270         returns(bytes4);
271 }
272 contract ERC721Holder is ERC721Receiver {
273     function onERC721Received(address, uint256, bytes) public returns(bytes4) {
274         return ERC721_RECEIVED;
275     }
276 }
277 
278 contract CSCTimeSaleManager is ERC721Holder, OperationalControl {
279     //DATATYPES & CONSTANTS
280     struct CollectibleSale {
281         // Current owner of NFT (ERC721)
282         address seller;
283         // Price (in wei) at beginning of sale (For Buying)
284         uint256 startingPrice;
285         // Price (in wei) at end of sale (For Buying)
286         uint256 endingPrice;
287         // Duration (in seconds) of sale, 2592000 = 30 days
288         uint256 duration;
289         // Time when sale started
290         // NOTE: 0 if this sale has been concluded
291         uint64 startedAt;
292         // Flag denoting is the Sale still active
293         bool isActive;
294         // address of the wallet who bought the asset
295         address buyer;
296         // ERC721 AssetID
297         uint256 tokenId;
298     }
299     struct PastSales {
300         uint256[5] sales;
301     }
302 
303     // CSCNTFAddress
304     address public NFTAddress;
305 
306     // Map from token to their corresponding sale.
307     mapping (uint256 => CollectibleSale) public tokenIdToSale;
308 
309     // Count of AssetType Sales
310     mapping (uint256 => uint256) public assetTypeSaleCount;
311 
312     // Last 5 Prices of AssetType Sales
313     mapping (uint256 => PastSales) internal assetTypeSalePrices;
314 
315     uint256 public avgSalesToCount = 5;
316 
317     // type to sales of type
318     mapping(uint256 => uint256[]) public assetTypeSalesTokenId;
319 
320     event SaleWinner(address owner, uint256 collectibleId, uint256 buyingPrice);
321     event SaleCreated(uint256 tokenID, uint256 startingPrice, uint256 endingPrice, uint256 duration, uint64 startedAt);
322     event SaleCancelled(address seller, uint256 collectibleId);
323 
324     constructor() public {
325         require(msg.sender != address(0));
326         paused = true;
327         error = false;
328         managerPrimary = msg.sender;
329         managerSecondary = msg.sender;
330         bankManager = msg.sender;
331     }
332 
333     function  setNFTAddress(address _address) public onlyManager {
334         NFTAddress = _address;
335     }
336 
337     function setAvgSalesCount(uint256 _count) public onlyManager  {
338         avgSalesToCount = _count;
339     }
340 
341     /// @dev Creates and begins a new sale.
342     function CreateSale(uint256 _tokenId, uint256 _startingPrice, uint256 _endingPrice, uint64 _duration, address _seller) public anyOperator {
343         _createSale(_tokenId, _startingPrice, _endingPrice, _duration, _seller);
344     }
345 
346     function BatchCreateSales(uint256[] _tokenIds, uint256 _startingPrice, uint256 _endingPrice, uint64 _duration, address _seller) public anyOperator {
347         uint256 _tokenId;
348         for (uint256 i = 0; i < _tokenIds.length; ++i) {
349             _tokenId = _tokenIds[i];
350             _createSale(_tokenId, _startingPrice, _endingPrice, _duration, _seller);
351         }
352     }
353 
354     function CreateSaleAvgPrice(uint256 _tokenId, uint256 _margin, uint _minPrice, uint256 _endingPrice, uint64 _duration, address _seller) public anyOperator {
355         var cscNFT = CSCNFTFactory(NFTAddress);
356         uint256 assetType = cscNFT.getAssetIdItemType(_tokenId);
357         // Avg Price of last sales
358         uint256 salePrice = GetAssetTypeAverageSalePrice(assetType);
359 
360         //  0-10,000 is mapped to 0%-100% - will be typically 12000 or 120%
361         salePrice = salePrice * _margin / 10000;
362 
363         if(salePrice < _minPrice) {
364             salePrice = _minPrice;
365         } 
366        
367         _createSale(_tokenId, salePrice, _endingPrice, _duration, _seller);
368     }
369 
370     function BatchCreateSaleAvgPrice(uint256[] _tokenIds, uint256 _margin, uint _minPrice, uint256 _endingPrice, uint64 _duration, address _seller) public anyOperator {
371         var cscNFT = CSCNFTFactory(NFTAddress);
372         uint256 assetType;
373         uint256 _tokenId;
374         uint256 salePrice;
375         for (uint256 i = 0; i < _tokenIds.length; ++i) {
376             _tokenId = _tokenIds[i];
377             assetType = cscNFT.getAssetIdItemType(_tokenId);
378             // Avg Price of last sales
379             salePrice = GetAssetTypeAverageSalePrice(assetType);
380 
381             //  0-10,000 is mapped to 0%-100% - will be typically 12000 or 120%
382             salePrice = salePrice * _margin / 10000;
383 
384             if(salePrice < _minPrice) {
385                 salePrice = _minPrice;
386             } 
387             
388             _tokenId = _tokenIds[i];
389             _createSale(_tokenId, salePrice, _endingPrice, _duration, _seller);
390         }
391     }
392 
393     function BatchCancelSales(uint256[] _tokenIds) public anyOperator {
394         uint256 _tokenId;
395         for (uint256 i = 0; i < _tokenIds.length; ++i) {
396             _tokenId = _tokenIds[i];
397             _cancelSale(_tokenId);
398         }
399     }
400 
401     function CancelSale(uint256 _assetId) public anyOperator {
402         _cancelSale(_assetId);
403     }
404 
405     function GetCurrentSalePrice(uint256 _assetId) external view returns(uint256 _price) {
406         CollectibleSale memory _sale = tokenIdToSale[_assetId];
407         
408         return _currentPrice(_sale);
409     }
410 
411     function GetCurrentTypeSalePrice(uint256 _assetType) external view returns(uint256 _price) {
412         CollectibleSale memory _sale = tokenIdToSale[assetTypeSalesTokenId[_assetType][0]];
413         return _currentPrice(_sale);
414     }
415 
416     function GetCurrentTypeDuration(uint256 _assetType) external view returns(uint256 _duration) {
417         CollectibleSale memory _sale = tokenIdToSale[assetTypeSalesTokenId[_assetType][0]];
418         return  _sale.duration;
419     }
420 
421     function GetCurrentTypeStartTime(uint256 _assetType) external view returns(uint256 _startedAt) {
422         CollectibleSale memory _sale = tokenIdToSale[assetTypeSalesTokenId[_assetType][0]];
423         return  _sale.startedAt;
424     }
425 
426     function GetCurrentTypeSaleItem(uint256 _assetType) external view returns(address seller, uint256 startingPrice, uint256 endingPrice, uint256 duration, uint256 startedAt, uint256 tokenId) {
427         CollectibleSale memory _sale = tokenIdToSale[assetTypeSalesTokenId[_assetType][0]];
428         return (
429             _sale.seller,
430             _sale.startingPrice,
431             _sale.endingPrice,
432             _sale.duration,
433             _sale.startedAt,
434             _sale.tokenId
435         );
436     }
437 
438     function GetCurrentTypeSaleCount(uint256 _assetType) external view returns(uint256 _count) {
439         return assetTypeSalesTokenId[_assetType].length;
440     }
441 
442     function BuyCurrentTypeOfAsset(uint256 _assetType) external whenNotPaused payable {
443         require(msg.sender != address(0));
444         require(msg.sender != address(this));
445 
446         CollectibleSale memory _sale = tokenIdToSale[assetTypeSalesTokenId[_assetType][0]];
447         require(_isOnSale(_sale));
448 
449         _buy(_sale.tokenId, msg.sender, msg.value);
450     }
451 
452     /// @dev BuyNow Function which call the interncal buy function
453     /// after doing all the pre-checks required to initiate a buy
454     function BuyAsset(uint256 _assetId) external whenNotPaused payable {
455         require(msg.sender != address(0));
456         require(msg.sender != address(this));
457         CollectibleSale memory _sale = tokenIdToSale[_assetId];
458         require(_isOnSale(_sale));
459         
460         //address seller = _sale.seller;
461 
462         _buy(_assetId, msg.sender, msg.value);
463     }
464 
465     function GetAssetTypeAverageSalePrice(uint256 _assetType) public view returns (uint256) {
466         uint256 sum = 0;
467         for (uint256 i = 0; i < avgSalesToCount; i++) {
468             sum += assetTypeSalePrices[_assetType].sales[i];
469         }
470         return sum / 5;
471     }
472 
473     /// @dev Override unpause so it requires all external contract addresses
474     ///  to be set before contract can be unpaused. Also, we can't have
475     ///  newContractAddress set either, because then the contract was upgraded.
476     /// @notice This is public rather than external so we can call super.unpause
477     ///  without using an expensive CALL.
478     function unpause() public anyOperator whenPaused {
479         // Actually unpause the contract.
480         super.unpause();
481     }
482 
483     /// @dev Remove all Ether from the contract, which is the owner's cuts
484     ///  as well as any Ether sent directly to the contract address.
485     ///  Always transfers to the NFT (ERC721) contract, but can be called either by
486     ///  the owner or the NFT (ERC721) contract.
487     function withdrawBalance() public onlyBanker {
488         // We are using this boolean method to make sure that even if one fails it will still work
489         bankManager.transfer(address(this).balance);
490     }
491 
492     /// @dev Returns sales info for an CSLCollectibles (ERC721) on sale.
493     /// @param _assetId - ID of the token on sale
494     function getSale(uint256 _assetId) external view returns (address seller, uint256 startingPrice, uint256 endingPrice, uint256 duration, uint256 startedAt, bool isActive, address buyer, uint256 tokenId) {
495         CollectibleSale memory sale = tokenIdToSale[_assetId];
496         require(_isOnSale(sale));
497         return (
498             sale.seller,
499             sale.startingPrice,
500             sale.endingPrice,
501             sale.duration,
502             sale.startedAt,
503             sale.isActive,
504             sale.buyer,
505             sale.tokenId
506         );
507     }
508 
509 
510     /** Internal Functions */
511 
512     function _createSale(uint256 _tokenId, uint256 _startingPrice, uint256 _endingPrice, uint64 _duration, address _seller) internal {
513         var cscNFT = CSCNFTFactory(NFTAddress);
514 
515         require(cscNFT.isAssetIdOwnerOrApproved(this, _tokenId) == true);
516         
517         CollectibleSale memory onSale = tokenIdToSale[_tokenId];
518         require(onSale.isActive == false);
519 
520         // Sanity check that no inputs overflow how many bits we've allocated
521         // to store them in the sale struct.
522         require(_startingPrice == uint256(uint128(_startingPrice)));
523         require(_endingPrice == uint256(uint128(_endingPrice)));
524         require(_duration == uint256(uint64(_duration)));
525 
526         //Transfer ownership if needed
527         if(cscNFT.ownerOf(_tokenId) != address(this)) {
528             
529             require(cscNFT.isApprovedForAll(msg.sender, this) == true);
530 
531             cscNFT.safeTransferFrom(cscNFT.ownerOf(_tokenId), this, _tokenId);
532         }
533 
534         CollectibleSale memory sale = CollectibleSale(
535             _seller,
536             uint128(_startingPrice),
537             uint128(_endingPrice),
538             uint64(_duration),
539             uint64(now),
540             true,
541             address(0),
542             uint256(_tokenId)
543         );
544         _addSale(_tokenId, sale);
545     }
546 
547     /// @dev Adds an sale to the list of open sales. Also fires the
548     ///  SaleCreated event.
549     function _addSale(uint256 _assetId, CollectibleSale _sale) internal {
550         // Require that all sales have a duration of
551         // at least one minute.
552         require(_sale.duration >= 1 minutes);
553         
554         tokenIdToSale[_assetId] = _sale;
555 
556         var cscNFT = CSCNFTFactory(NFTAddress);
557         uint256 assetType = cscNFT.getAssetIdItemType(_assetId);
558         assetTypeSalesTokenId[assetType].push(_assetId);
559 
560         SaleCreated(
561             uint256(_assetId),
562             uint256(_sale.startingPrice),
563             uint256(_sale.endingPrice),
564             uint256(_sale.duration),
565             uint64(_sale.startedAt)
566         );
567     }
568 
569     /// @dev Returns current price of a Collectible (ERC721) on sale. Broken into two
570     ///  functions (this one, that computes the duration from the sale
571     ///  structure, and the other that does the price computation) so we
572     ///  can easily test that the price computation works correctly.
573     function _currentPrice(CollectibleSale memory _sale) internal view returns (uint256) {
574         uint256 secondsPassed = 0;
575 
576         // A bit of insurance against negative values (or wraparound).
577         // Probably not necessary (since Ethereum guarnatees that the
578         // now variable doesn't ever go backwards).
579         if (now > _sale.startedAt) {
580             secondsPassed = now - _sale.startedAt;
581         }
582 
583         return _computeCurrentPrice(
584             _sale.startingPrice,
585             _sale.endingPrice,
586             _sale.duration,
587             secondsPassed
588         );
589     }
590 
591     /// @dev Computes the current price of an sale. Factored out
592     ///  from _currentPrice so we can run extensive unit tests.
593     ///  When testing, make this function public and turn on
594     ///  `Current price computation` test suite.
595     function _computeCurrentPrice(uint256 _startingPrice, uint256 _endingPrice, uint256 _duration, uint256 _secondsPassed) internal pure returns (uint256) {
596         // NOTE: We don't use SafeMath (or similar) in this function because
597         //  all of our public functions carefully cap the maximum values for
598         //  time (at 64-bits) and currency (at 128-bits). _duration is
599         //  also known to be non-zero (see the require() statement in
600         //  _addSale())
601         if (_secondsPassed >= _duration) {
602             // We've reached the end of the dynamic pricing portion
603             // of the sale, just return the end price.
604             return _endingPrice;
605         } else {
606             // Starting price can be higher than ending price (and often is!), so
607             // this delta can be negative.
608             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
609 
610             // This multiplication can't overflow, _secondsPassed will easily fit within
611             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
612             // will always fit within 256-bits.
613             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
614 
615             // currentPriceChange can be negative, but if so, will have a magnitude
616             // less that _startingPrice. Thus, this result will always end up positive.
617             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
618 
619             return uint256(currentPrice);
620         }
621     }
622 
623     function _buy(uint256 _assetId, address _buyer, uint256 _price) internal {
624 
625         CollectibleSale storage _sale = tokenIdToSale[_assetId];
626 
627         // Check that the bid is greater than or equal to the current buyOut price
628         uint256 currentPrice = _currentPrice(_sale);
629 
630         require(_price >= currentPrice);
631         _sale.buyer = _buyer;
632         _sale.isActive = false;
633 
634         _removeSale(_assetId);
635 
636         uint256 bidExcess = _price - currentPrice;
637         _buyer.transfer(bidExcess);
638 
639         var cscNFT = CSCNFTFactory(NFTAddress);
640         uint256 assetType = cscNFT.getAssetIdItemType(_assetId);
641         _updateSaleAvgHistory(assetType, _price);
642         cscNFT.safeTransferFrom(this, _buyer, _assetId);
643 
644         emit SaleWinner(_buyer, _assetId, _price);
645     }
646 
647     function _cancelSale (uint256 _assetId) internal {
648         CollectibleSale storage _sale = tokenIdToSale[_assetId];
649 
650         require(_sale.isActive == true);
651 
652         address sellerAddress = _sale.seller;
653 
654         _removeSale(_assetId);
655 
656         var cscNFT = CSCNFTFactory(NFTAddress);
657 
658         cscNFT.safeTransferFrom(this, sellerAddress, _assetId);
659 
660         emit SaleCancelled(sellerAddress, _assetId);
661     }
662     
663     /// @dev Returns true if the FT (ERC721) is on sale.
664     function _isOnSale(CollectibleSale memory _sale) internal view returns (bool) {
665         return (_sale.startedAt > 0 && _sale.isActive);
666     }
667 
668     function _updateSaleAvgHistory(uint256 _assetType, uint256 _price) internal {
669         assetTypeSaleCount[_assetType] += 1;
670         assetTypeSalePrices[_assetType].sales[assetTypeSaleCount[_assetType] % avgSalesToCount] = _price;
671     }
672 
673     /// @dev Removes an sale from the list of open sales.
674     /// @param _assetId - ID of the token on sale
675     function _removeSale(uint256 _assetId) internal {
676         delete tokenIdToSale[_assetId];
677 
678         var cscNFT = CSCNFTFactory(NFTAddress);
679         uint256 assetType = cscNFT.getAssetIdItemType(_assetId);
680 
681         bool hasFound = false;
682         for (uint i = 0; i < assetTypeSalesTokenId[assetType].length; i++) {
683             if ( assetTypeSalesTokenId[assetType][i] == _assetId) {
684                 hasFound = true;
685             }
686             if(hasFound == true) {
687                 if(i+1 < assetTypeSalesTokenId[assetType].length)
688                     assetTypeSalesTokenId[assetType][i] = assetTypeSalesTokenId[assetType][i+1];
689                 else 
690                     delete assetTypeSalesTokenId[assetType][i];
691             }
692         }
693         assetTypeSalesTokenId[assetType].length--;
694     }
695 
696 }