1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (_a == 0) {
17       return 0;
18     }
19 
20     uint256 c = _a * _b;
21     require(c / _a == _b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     require(_b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = _a / _b;
32     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     require(_b <= _a);
42     uint256 c = _a - _b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
51     uint256 c = _a + _b;
52     require(c >= _a);
53 
54     return c;
55   }
56 }
57 
58 /* Controls game play state and access rights for game functions
59  * @title Operational Control
60  * @author Fazri Zubair & Farhan Khwaja (Lucid Sight, Inc.)
61  * Inspired and adapted from contract created by OpenZeppelin
62  * Ref: https://github.com/OpenZeppelin/zeppelin-solidity/
63  */
64 contract OperationalControl {
65     // Facilitates access & control for the game.
66     // Roles:
67     //  -The Game Managers (Primary/Secondary): Has universal control of all game elements (No ability to withdraw)
68     //  -The Banker: The Bank can withdraw funds and adjust fees / prices.
69 
70     /// @dev Emited when contract is upgraded
71     event ContractUpgrade(address newContract);
72 
73     mapping (address => bool) allowedAddressList;
74     
75 
76     // The addresses of the accounts (or contracts) that can execute actions within each roles.
77     address public gameManagerPrimary;
78     address public gameManagerSecondary;
79     address public bankManager;
80 
81     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
82     bool public paused = false;
83 
84     /// @dev Operation modifiers for limiting access
85     modifier onlyGameManager() {
86         require(msg.sender == gameManagerPrimary || msg.sender == gameManagerSecondary);
87         _;
88     }
89 
90     /// @dev Operation modifiers for limiting access to only Banker
91     modifier onlyBanker() {
92         require(msg.sender == bankManager);
93         _;
94     }
95 
96     /// @dev Operation modifiers for access to any Manager
97     modifier anyOperator() {
98         require(
99             msg.sender == gameManagerPrimary ||
100             msg.sender == gameManagerSecondary ||
101             msg.sender == bankManager
102         );
103         _;
104     }
105 
106     /// @dev Assigns a new address to act as the GM.
107     function setPrimaryGameManager(address _newGM) external onlyGameManager {
108         require(_newGM != address(0));
109 
110         gameManagerPrimary = _newGM;
111     }
112 
113     /// @dev Assigns a new address to act as the GM.
114     function setSecondaryGameManager(address _newGM) external onlyGameManager {
115         require(_newGM != address(0));
116 
117         gameManagerSecondary = _newGM;
118     }
119 
120     /// @dev Assigns a new address to act as the Banker.
121     function setBanker(address _newBK) external onlyBanker {
122         require(_newBK != address(0));
123 
124         bankManager = _newBK;
125     }
126 
127     function updateAllowedAddressesList (address _newAddress, bool _value) external onlyGameManager {
128 
129         require (_newAddress != address(0));
130 
131         allowedAddressList[_newAddress] = _value;
132         
133     }
134 
135     modifier canTransact() { 
136         require (msg.sender == gameManagerPrimary
137             || msg.sender == gameManagerSecondary
138             || allowedAddressList[msg.sender]); 
139         _; 
140     }
141     
142 
143     /*** Pausable functionality adapted from OpenZeppelin ***/
144 
145     /// @dev Modifier to allow actions only when the contract IS NOT paused
146     modifier whenNotPaused() {
147         require(!paused);
148         _;
149     }
150 
151     /// @dev Modifier to allow actions only when the contract IS paused
152     modifier whenPaused {
153         require(paused);
154         _;
155     }
156 
157     /// @dev Called by any Operator role to pause the contract.
158     /// Used only if a bug or exploit is discovered (Here to limit losses / damage)
159     function pause() external onlyGameManager whenNotPaused {
160         paused = true;
161     }
162 
163     /// @dev Unpauses the smart contract. Can only be called by the Game Master
164     /// @notice This is public rather than external so it can be called by derived contracts. 
165     function unpause() public onlyGameManager whenPaused {
166         // can't unpause if contract was upgraded
167         paused = false;
168     }
169 }
170 
171 /* @title Interface for MLBNFT Contract
172  * @author Fazri Zubair & Farhan Khwaja (Lucid Sight, Inc.)
173  */
174 contract MLBNFT {
175     function exists(uint256 _tokenId) public view returns (bool _exists);
176     function ownerOf(uint256 _tokenId) public view returns (address _owner);
177     function approve(address _to, uint256 _tokenId) public;
178     function setApprovalForAll(address _to, bool _approved) public;
179     function transferFrom(address _from, address _to, uint256 _tokenId) public;
180     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
181     function createPromoCollectible(uint8 _teamId, uint8 _posId, uint256 _attributes, address _owner, uint256 _gameId, uint256 _playerOverrideId, uint256 _mlbPlayerId) external returns (uint256);
182     function createSeedCollectible(uint8 _teamId, uint8 _posId, uint256 _attributes, address _owner, uint256 _gameId, uint256 _playerOverrideId, uint256 _mlbPlayerId) public returns (uint256);
183     function checkIsAttached(uint256 _tokenId) public view returns (uint256);
184     function getTeamId(uint256 _tokenId) external view returns (uint256);
185     function getPlayerId(uint256 _tokenId) external view returns (uint256 playerId);
186     function getApproved(uint256 _tokenId) public view returns (address _operator);
187     function isApprovedForAll(address _owner, address _operator) public view returns (bool);
188 }
189 
190 /* @title Interface for ETH Escrow Contract
191  * @author Fazri Zubair & Farhan Khwaja (Lucid Sight, Inc.)
192  */
193 contract LSEscrow {
194     function escrowTransfer(address seller, address buyer, uint256 currentPrice, uint256 marketsCut) public returns(bool);
195 }
196 
197 
198 
199 /**
200  * @title ERC721 token receiver interface
201  * @dev Interface for any contract that wants to support safeTransfers
202  *  from ERC721 asset contracts.
203  */
204 contract ERC721Receiver {
205     /**
206     * @dev Magic value to be returned upon successful reception of an NFT
207     *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
208     *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
209     */
210     bytes4 public constant ERC721_RECEIVED = 0x150b7a02;
211 
212     /**
213     * @notice Handle the receipt of an NFT
214     * @dev The ERC721 smart contract calls this function on the recipient
215     *  after a `safetransfer`. This function MAY throw to revert and reject the
216     *  transfer. This function MUST use 50,000 gas or less. Return of other
217     *  than the magic value MUST result in the transaction being reverted.
218     *  Note: the contract address is always the message sender.
219     * @param _from The sending address
220     * @param _tokenId The NFT identifier which is being transfered
221     * @param _data Additional data with no specified format
222     * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
223     */
224     function onERC721Received(
225         address _operator,
226         address _from,
227         uint256 _tokenId,
228         bytes _data
229     )
230         public
231         returns(bytes4);
232 }
233 
234 contract ERC721Holder is ERC721Receiver {
235     function onERC721Received(address,address, uint256, bytes) public returns(bytes4) {
236         return ERC721_RECEIVED;
237     }
238 }
239 
240 /* Contains models, variables, and internal methods for the ERC-721 sales.
241  * @title Sale Base
242  * @author Fazri Zubair & Farhan Khwaja (Lucid Sight, Inc.)
243  */
244 contract SaleBase is OperationalControl, ERC721Holder {
245     using SafeMath for uint256;
246     
247     /// EVENTS 
248 
249     event SaleCreated(uint256 tokenID, uint256 startingPrice, uint256 endingPrice, uint256 duration, uint256 startedAt);
250     event TeamSaleCreated(uint256[9] tokenIDs, uint256 startingPrice, uint256 endingPrice, uint256 duration, uint256 startedAt);
251     event SaleWinner(uint256 tokenID, uint256 totalPrice, address winner);
252     event TeamSaleWinner(uint256[9] tokenIDs, uint256 totalPrice, address winner);
253     event SaleCancelled(uint256 tokenID, address sellerAddress);
254     event EtherWithdrawed(uint256 value);
255 
256     /// STORAGE
257 
258     /**
259      * @dev        Represents an Sale on MLB CryptoBaseball (ERC721)
260      */
261     struct Sale {
262         // Current owner of NFT (ERC721)
263         address seller;
264         // Price (in wei) at beginning of sale
265         uint256 startingPrice;
266         // Price (in wei) at end of sale
267         uint256 endingPrice;
268         // Duration (in seconds) of sale
269         uint256 duration;
270         // Time when sale started
271         // NOTE: 0 if this sale has been concluded
272         uint256 startedAt;
273         // ERC721 AssetID
274         uint256[9] tokenIds;
275     }
276 
277     /**
278      * @dev        Reference to contract tracking ownership & asset details
279      */
280     MLBNFT public nonFungibleContract;
281 
282     /**
283      * @dev        Reference to contract tracking ownership & asset details
284      */
285     LSEscrow public LSEscrowContract;
286 
287     /**
288      * @dev   Defining a GLOBAL delay time for the auctions to start accepting bidExcess
289      * @notice This variable is made to delay the bid process.
290      */
291     uint256 public BID_DELAY_TIME = 0;
292 
293     // Cut owner takes on each sale, measured in basis points (1/100 of a percent).
294     // Values 0-10,000 map to 0%-100%
295     uint256 public ownerCut = 500; //5%
296 
297     // Map from token to their corresponding sale.
298     mapping (uint256 => Sale) tokenIdToSale;
299 
300     /**
301      * @dev        Returns true if the claimant owns the token.
302      * @param      _claimant  The claimant
303      * @param      _tokenId   The token identifier
304      */
305     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
306         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
307     }
308 
309     /**
310      * @dev        Internal function to ESCROW
311      * @notice     Escrows the ERC721 Token, assigning ownership to this contract. Throws if the escrow fails.
312      * @param      _owner    The owner
313      * @param      _tokenId  The token identifier
314      */
315     function _escrow(address _owner, uint256 _tokenId) internal {
316         nonFungibleContract.safeTransferFrom(_owner, this, _tokenId);
317     }
318 
319     /**
320      * @dev        Internal Transfer function
321      * @notice     Transfers an ERC721 Token owned by this contract to another address. Returns true if the transfer succeeds.
322      * @param      _owner     The owner
323      * @param      _receiver  The receiver
324      * @param      _tokenId   The token identifier
325      */
326     function _transfer(address _owner, address _receiver, uint256 _tokenId) internal {
327         nonFungibleContract.transferFrom(_owner, _receiver, _tokenId);
328     }
329 
330     /**
331      * @dev        Internal Function to add Sale, which duration check (atleast 1 min duration required)
332      * @notice     Adds an sale to the list of open sales. Also fires the SaleCreated event.
333      * @param      _tokenId  The token identifier
334      * @param      _sale     The sale
335      */
336     function _addSale(uint256 _tokenId, Sale _sale) internal {
337         // Require that all sales have a duration of
338         // at least one minute.
339         require(_sale.duration >= 1 minutes);
340         
341         tokenIdToSale[_tokenId] = _sale;
342 
343         emit SaleCreated(
344             uint256(_tokenId),
345             uint256(_sale.startingPrice),
346             uint256(_sale.endingPrice),
347             uint256(_sale.duration),
348             uint256(_sale.startedAt)
349         );
350     }
351 
352     /**
353      * @dev        Internal Function to add Team Sale, which duration check (atleast 1 min duration required)
354      * @notice     Adds an sale to the list of open sales. Also fires the SaleCreated event.
355      * @param      _tokenIds  The token identifiers
356      * @param      _sale      The sale
357      */
358     function _addTeamSale(uint256[9] _tokenIds, Sale _sale) internal {
359         // Require that all sales have a duration of
360         // at least one minute.
361         require(_sale.duration >= 1 minutes);
362         
363         for(uint ii = 0; ii < 9; ii++) {
364             require(_tokenIds[ii] != 0);
365             require(nonFungibleContract.exists(_tokenIds[ii]));
366 
367             tokenIdToSale[_tokenIds[ii]] = _sale;
368         }
369 
370         emit TeamSaleCreated(
371             _tokenIds,
372             uint256(_sale.startingPrice),
373             uint256(_sale.endingPrice),
374             uint256(_sale.duration),
375             uint256(_sale.startedAt)
376         );
377     }
378 
379     /**
380      * @dev        Facilites Sale cancellation. Also removed the Sale from the array
381      * @notice     Cancels an sale (given the collectibleID is not 0). SaleCancelled Event
382      * @param      _tokenId  The token identifier
383      * @param      _seller   The seller
384      */
385     function _cancelSale(uint256 _tokenId, address _seller) internal {
386         Sale memory saleItem = tokenIdToSale[_tokenId];
387 
388         //Check for team sale
389         if(saleItem.tokenIds[1] != 0) {
390             for(uint ii = 0; ii < 9; ii++) {
391                 _removeSale(saleItem.tokenIds[ii]);
392                 _transfer(address(this), _seller, saleItem.tokenIds[ii]);
393             }
394             emit SaleCancelled(_tokenId, _seller);
395         } else {
396             _removeSale(_tokenId);
397             _transfer(address(this), _seller, _tokenId);
398             emit SaleCancelled(_tokenId, _seller);
399         }
400     }
401 
402     /**
403      * @dev        Computes the price and transfers winnings. Does NOT transfer ownership of token.
404      * @notice     Internal function, helps in making the bid and transferring asset if successful
405      * @param      _tokenId    The token identifier
406      * @param      _bidAmount  The bid amount
407      */
408     function _bid(uint256 _tokenId, uint256 _bidAmount)
409         internal
410         returns (uint256)
411     {
412         // Get a reference to the sale struct
413         Sale storage _sale = tokenIdToSale[_tokenId];
414         uint256[9] memory tokenIdsStore = tokenIdToSale[_tokenId].tokenIds;
415         
416         // Explicitly check that this sale is currently live.
417         require(_isOnSale(_sale));
418 
419         // Check that the bid is greater than or equal to the current price
420         uint256 price = _currentPrice(_sale);
421         require(_bidAmount >= price);
422 
423         // Grab a reference to the seller before the sale struct
424         // gets deleted.
425         address seller = _sale.seller;
426 
427         // The bid is good! Remove the sale before sending the fees
428         // to the sender so we can't have a reentrancy attack.
429         if(tokenIdsStore[1] > 0) {
430             for(uint ii = 0; ii < 9; ii++) {
431                 _removeSale(tokenIdsStore[ii]);
432             }
433         } else {
434             _removeSale(_tokenId);
435         }
436 
437         // Transfer proceeds to seller (if there are any!)
438         if (price > 0) {
439             // Calculate the marketplace's cut.
440             // (NOTE: _computeCut() is guaranteed to return a
441             // value <= price)
442             uint256 marketsCut = _computeCut(price);
443             uint256 sellerProceeds = price.sub(marketsCut);
444 
445             seller.transfer(sellerProceeds);
446         }
447 
448         // Calculate any excess funds included with the bid. If the excess
449         // is anything worth worrying about, transfer it back to bidder.
450         uint256 bidExcess = _bidAmount.sub(price);
451 
452         // Return the funds. Similar to the previous transfer.
453         msg.sender.transfer(bidExcess);
454 
455         // Tell the world!
456         // uint256 assetID, uint256 totalPrice, address winner, uint16 generation
457         if(tokenIdsStore[1] > 0) {
458             emit TeamSaleWinner(tokenIdsStore, price, msg.sender);
459         } else {
460             emit SaleWinner(_tokenId, price, msg.sender);
461         }
462         
463         return price;
464     }
465 
466     /**
467      * @dev        Removes an sale from the list of open sales.
468      * @notice     Internal Function to remove sales
469      * @param      _tokenId  The token identifier
470      */
471     function _removeSale(uint256 _tokenId) internal {
472         delete tokenIdToSale[_tokenId];
473     }
474 
475     /**
476      * @dev        Returns true if the FT (ERC721) is on sale.
477      * @notice     Internal function to check if an
478      * @param      _sale  The sale
479      */
480     function _isOnSale(Sale memory _sale) internal pure returns (bool) {
481         return (_sale.startedAt > 0);
482     }
483 
484     /** @dev Returns current price of an FT (ERC721) on sale. Broken into two
485      *  functions (this one, that computes the duration from the sale
486      *  structure, and the other that does the price computation) so we
487      *  can easily test that the price computation works correctly.
488      */
489     function _currentPrice(Sale memory _sale)
490         internal
491         view
492         returns (uint256)
493     {
494         uint256 secondsPassed = 0;
495 
496         // A bit of insurance against negative values (or wraparound).
497         // Probably not necessary (since Ethereum guarnatees that the
498         // now variable doesn't ever go backwards).
499         if (now > _sale.startedAt.add(BID_DELAY_TIME)) {
500             secondsPassed = now.sub(_sale.startedAt.add(BID_DELAY_TIME));
501         }
502 
503         return _computeCurrentPrice(
504             _sale.startingPrice,
505             _sale.endingPrice,
506             _sale.duration,
507             secondsPassed
508         );
509     }
510 
511     /** @dev Computes the current price of an sale. Factored out
512      *  from _currentPrice so we can run extensive unit tests.
513      *  When testing, make this function public and turn on
514      *  `Current price computation` test suite.
515      */
516     function _computeCurrentPrice(
517         uint256 _startingPrice,
518         uint256 _endingPrice,
519         uint256 _duration,
520         uint256 _secondsPassed
521     )
522         internal
523         pure
524         returns (uint256)
525     {
526         // NOTE: We don't use SafeMath (or similar) in this function because
527         //  all of our public functions carefully cap the maximum values for
528         //  time (at 64-bits) and currency (at 128-bits). _duration is
529         //  also known to be non-zero (see the require() statement in
530         //  _addSale())
531         if (_secondsPassed >= _duration) {
532             // We've reached the end of the dynamic pricing portion
533             // of the sale, just return the end price.
534             return _endingPrice;
535         } else {
536             // Starting price can be higher than ending price (and often is!), so
537             // this delta can be negative.
538             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
539 
540             // This multiplication can't overflow, _secondsPassed will easily fit within
541             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
542             // will always fit within 256-bits.
543             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
544 
545             // currentPriceChange can be negative, but if so, will have a magnitude
546             // less that _startingPrice. Thus, this result will always end up positive.
547             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
548 
549             return uint256(currentPrice);
550         }
551     }
552 
553     /**
554      * @dev        Computes owner's cut of a sale.
555      * @param      _price  The price
556      */
557     function _computeCut(uint256 _price) internal view returns (uint256) {
558         return _price.mul(ownerCut).div(10000);
559     }
560 }
561 
562 /* Clock sales functions and interfaces
563  * @title SaleManager
564  * @author Fazri Zubair & Farhan Khwaja (Lucid Sight, Inc.)
565  */
566 contract SaleManager is SaleBase {
567 
568     /// @dev MAPINGS
569     mapping (uint256 => uint256[3]) public lastTeamSalePrices;
570     mapping (uint256 => uint256) public lastSingleSalePrices;
571     mapping (uint256 => uint256) public seedTeamSaleCount;
572     uint256 public seedSingleSaleCount = 0;
573 
574     /// @dev CONSTANTS
575     uint256 public constant SINGLE_SALE_MULTIPLIER = 35;
576     uint256 public constant TEAM_SALE_MULTIPLIER = 12;
577     uint256 public constant STARTING_PRICE = 10 finney;
578     uint256 public constant SALES_DURATION = 1 days;
579 
580     bool public isBatchSupported = true;
581 
582     /**
583      * @dev        Constructor creates a reference to the MLB_NFT Sale Manager contract
584      */
585     constructor() public {
586         require(ownerCut <= 10000); // You can't collect more than 100% silly ;)
587         require(msg.sender != address(0));
588         paused = true;
589         gameManagerPrimary = msg.sender;
590         gameManagerSecondary = msg.sender;
591         bankManager = msg.sender;
592     }
593 
594     /// @dev Override unpause so it requires all external contract addresses
595     ///  to be set before contract can be unpaused. Also, we can't have
596     ///  newContractAddress set either, because then the contract was upgraded.
597     /// @notice This is public rather than external so we can call super.unpause
598     ///  without using an expensive CALL.
599     function unpause() public onlyGameManager whenPaused {
600         require(nonFungibleContract != address(0));
601 
602         // Actually unpause the contract.
603         super.unpause();
604     }
605 
606     /** @dev Remove all Ether from the contract, which is the owner's cuts
607      *  as well as any Ether sent directly to the contract address.
608      *  Always transfers to the NFT (ERC721) contract, but can be called either by
609      *  the owner or the NFT (ERC721) contract.
610      */
611     function _withdrawBalance() internal {
612         // We are using this boolean method to make sure that even if one fails it will still work
613         bankManager.transfer(address(this).balance);
614     }
615 
616 
617     /** @dev Reject all Ether from being sent here, unless it's from one of the
618      *  contracts. (Hopefully, we can prevent user accidents.)
619      *  @notice No tipping!
620      */
621     function() external payable {
622         address nftAddress = address(nonFungibleContract);
623         require(
624             msg.sender == address(this) || 
625             msg.sender == gameManagerPrimary ||
626             msg.sender == gameManagerSecondary ||
627             msg.sender == bankManager ||
628             msg.sender == nftAddress ||
629             msg.sender == address(LSEscrowContract)
630         );
631     }
632 
633     /**
634      * @dev        Creates and begins a new sale.
635      * @param      _tokenId        The token identifier
636      * @param      _startingPrice  The starting price
637      * @param      _endingPrice    The ending price
638      * @param      _duration       The duration
639      * @param      _seller         The seller
640      */
641     function _createSale(
642         uint256 _tokenId,
643         uint256 _startingPrice,
644         uint256 _endingPrice,
645         uint256 _duration,
646         address _seller
647     )
648         internal
649     {
650         Sale memory sale = Sale(
651             _seller,
652             _startingPrice,
653             _endingPrice,
654             _duration,
655             now,
656             [_tokenId,0,0,0,0,0,0,0,0]
657         );
658         _addSale(_tokenId, sale);
659     }
660 
661     /**
662      * @dev        Internal Function, helps in creating team sale
663      * @param      _tokenIds       The token identifiers
664      * @param      _startingPrice  The starting price
665      * @param      _endingPrice    The ending price
666      * @param      _duration       The duration
667      * @param      _seller         The seller
668      */
669     function _createTeamSale(
670         uint256[9] _tokenIds,
671         uint256 _startingPrice,
672         uint256 _endingPrice,
673         uint256 _duration,
674         address _seller)
675         internal {
676 
677         Sale memory sale = Sale(
678             _seller,
679             _startingPrice,
680             _endingPrice,
681             _duration,
682             now,
683             _tokenIds
684         );
685 
686         /// Add sale obj to all tokens
687         _addTeamSale(_tokenIds, sale);
688     }
689 
690     /** @dev            Cancels an sale that hasn't been won yet. Returns the MLBNFT (ERC721) to original owner.
691      *  @notice         This is a state-modifying function that can be called while the contract is paused.
692      */
693     function cancelSale(uint256 _tokenId) external whenNotPaused {
694         Sale memory sale = tokenIdToSale[_tokenId];
695         require(_isOnSale(sale));
696         address seller = sale.seller;
697         require(msg.sender == seller);
698         _cancelSale(_tokenId, seller);
699     }
700 
701     /** @dev        Cancels an sale that hasn't been won yet. Returns the MLBNFT (ERC721) to original owner.
702      *  @notice     This is a state-modifying function that can be called while the contract is paused. Can be only called by the GameManagers
703      */
704     function cancelSaleWhenPaused(uint256 _tokenId) external whenPaused onlyGameManager {
705         Sale memory sale = tokenIdToSale[_tokenId];
706         require(_isOnSale(sale));
707         address seller = sale.seller;
708         _cancelSale(_tokenId, seller);
709     }
710 
711     /** 
712      * @dev    Returns sales info for an CSLCollectibles (ERC721) on sale.
713      * @notice Fetches the details related to the Sale
714      * @param  _tokenId    ID of the token on sale
715      */
716     function getSale(uint256 _tokenId) external view returns (address seller, uint256 startingPrice, uint256 endingPrice, uint256 duration, uint256 startedAt, uint256[9] tokenIds) {
717         Sale memory sale = tokenIdToSale[_tokenId];
718         require(_isOnSale(sale));
719         return (
720             sale.seller,
721             sale.startingPrice,
722             sale.endingPrice,
723             sale.duration,
724             sale.startedAt,
725             sale.tokenIds
726         );
727     }
728 
729     /**
730      * @dev        Returns the current price of an sale.
731      * @param      _tokenId  The token identifier
732      */
733     function getCurrentPrice(uint256 _tokenId) external view returns (uint256) {
734         Sale memory sale = tokenIdToSale[_tokenId];
735         require(_isOnSale(sale));
736         return _currentPrice(sale);
737     }
738 
739     /** @dev Calculates the new price for Sale Item
740      * @param   _saleType     Sale Type Identifier (0 - Single Sale, 1 - Team Sale)
741      * @param   _teamId       Team Identifier
742      */
743     function _averageSalePrice(uint256 _saleType, uint256 _teamId) internal view returns (uint256) {
744         uint256 _price = 0;
745         if(_saleType == 0) {
746             for(uint256 ii = 0; ii < 10; ii++) {
747                 _price = _price.add(lastSingleSalePrices[ii]);
748             }
749             _price = _price.mul(SINGLE_SALE_MULTIPLIER).div(100);
750         } else {
751             for (uint256 i = 0; i < 3; i++) {
752                 _price = _price.add(lastTeamSalePrices[_teamId][i]);
753             }
754         
755             _price = _price.mul(TEAM_SALE_MULTIPLIER).div(30);
756             _price = _price.mul(9);
757         }
758 
759         return _price;
760     }
761     
762     /**
763      * @dev        Put a Collectible up for sale. Does some ownership trickery to create sale in one tx.
764      * @param      _tokenId        The token identifier
765      * @param      _startingPrice  The starting price
766      * @param      _endingPrice    The ending price
767      * @param      _duration       The duration
768      * @param      _owner          Owner of the token
769      */
770     function createSale(uint256 _tokenId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration, address _owner) external whenNotPaused {
771         require(msg.sender == address(nonFungibleContract));
772 
773         // Check whether the collectible is inPlay. If inPlay cant put it on Sale
774         require(nonFungibleContract.checkIsAttached(_tokenId) == 0);
775         
776         _escrow(_owner, _tokenId);
777 
778         // Sale throws if inputs are invalid and clears
779         // transfer and sire approval after escrowing the CSLCollectible.
780         _createSale(
781             _tokenId,
782             _startingPrice,
783             _endingPrice,
784             _duration,
785             _owner
786         );
787     }
788 
789     /**
790      * @dev        Put a Collectible up for sale. Only callable, if user approved contract for 1/All Collectibles
791      * @param      _tokenId        The token identifier
792      * @param      _startingPrice  The starting price
793      * @param      _endingPrice    The ending price
794      * @param      _duration       The duration
795      */
796     function userCreateSaleIfApproved (uint256 _tokenId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration) external whenNotPaused {
797         
798         require(nonFungibleContract.getApproved(_tokenId) == address(this) || nonFungibleContract.isApprovedForAll(msg.sender, address(this)));
799         
800         // Check whether the collectible is inPlay. If inPlay cant put it on Sale
801         require(nonFungibleContract.checkIsAttached(_tokenId) == 0);
802         
803         _escrow(msg.sender, _tokenId);
804 
805         // Sale throws if inputs are invalid and clears
806         // transfer and sire approval after escrowing the CSLCollectible.
807         _createSale(
808             _tokenId,
809             _startingPrice,
810             _endingPrice,
811             _duration,
812             msg.sender
813         );
814     }
815 
816     /** 
817      * @dev        Transfers the balance of the sales manager contract to the CSLCollectible contract. We use two-step withdrawal to
818      *              prevent two transfer calls in the sale bid function.
819      */
820     function withdrawSaleManagerBalances() public onlyBanker {
821         _withdrawBalance();
822     }
823 
824     /** 
825      *  @dev Function to chnage the OwnerCut only accessible by the Owner of the contract
826      *  @param _newCut - Sets the ownerCut to new value
827      */
828     function setOwnerCut(uint256 _newCut) external onlyBanker {
829         require(_newCut <= 10000);
830         ownerCut = _newCut;
831     }
832     
833     /**
834      * @dev        Facilitates seed collectible auction creation. Enforces strict check on the data being passed
835      * @notice     Creates a new Collectible and creates an auction for it.
836      * @param      _teamId            The team identifier
837      * @param      _posId             The position identifier
838      * @param      _attributes        The attributes
839      * @param      _playerOverrideId  The player override identifier
840      * @param      _mlbPlayerId       The mlb player identifier
841      * @param      _startPrice        The start price
842      * @param      _endPrice          The end price
843      * @param      _saleDuration      The sale duration
844      */
845     function createSingleSeedAuction(
846         uint8 _teamId,
847         uint8 _posId,
848         uint256 _attributes,
849         uint256 _playerOverrideId,
850         uint256 _mlbPlayerId,
851         uint256 _startPrice,
852         uint256 _endPrice,
853         uint256 _saleDuration)
854         public
855         onlyGameManager
856         whenNotPaused {
857         // Check to see the NFT address is not 0
858         require(nonFungibleContract != address(0));
859         require(_teamId != 0);
860 
861         uint256 nftId = nonFungibleContract.createSeedCollectible(_teamId,_posId,_attributes,address(this),0, _playerOverrideId, _mlbPlayerId);
862 
863         uint256 startPrice = 0;
864         uint256 endPrice = 0;
865         uint256 duration = 0;
866         
867         if(_startPrice == 0) {
868             startPrice = _computeNextSeedPrice(0, _teamId);
869         } else {
870             startPrice = _startPrice;
871         }
872 
873         if(_endPrice != 0) {
874             endPrice = _endPrice;
875         } else {
876             endPrice = 0;
877         }
878 
879         if(_saleDuration == 0) {
880             duration = SALES_DURATION;
881         } else {
882             duration = _saleDuration;
883         }
884 
885         _createSale(
886             nftId,
887             startPrice,
888             endPrice,
889             duration,
890             address(this)
891         );
892     }
893 
894     /**
895      * @dev        Facilitates promo collectible auction creation. Enforces strict check on the data being passed
896      * @notice     Creates a new Collectible and creates an auction for it.
897      * @param      _teamId            The team identifier
898      * @param      _posId             The position identifier
899      * @param      _attributes        The attributes
900      * @param      _playerOverrideId  The player override identifier
901      * @param      _mlbPlayerId       The mlb player identifier
902      * @param      _startPrice        The start price
903      * @param      _endPrice          The end price
904      * @param      _saleDuration      The sale duration
905      */
906     function createPromoSeedAuction(
907         uint8 _teamId,
908         uint8 _posId,
909         uint256 _attributes,
910         uint256 _playerOverrideId,
911         uint256 _mlbPlayerId,
912         uint256 _startPrice,
913         uint256 _endPrice,
914         uint256 _saleDuration)
915         public
916         onlyGameManager
917         whenNotPaused {
918         // Check to see the NFT address is not 0
919         require(nonFungibleContract != address(0));
920         require(_teamId != 0);
921 
922         uint256 nftId = nonFungibleContract.createPromoCollectible(_teamId, _posId, _attributes, address(this), 0, _playerOverrideId, _mlbPlayerId);
923 
924         uint256 startPrice = 0;
925         uint256 endPrice = 0;
926         uint256 duration = 0;
927         
928         if(_startPrice == 0) {
929             startPrice = _computeNextSeedPrice(0, _teamId);
930         } else {
931             startPrice = _startPrice;
932         }
933 
934         if(_endPrice != 0) {
935             endPrice = _endPrice;
936         } else {
937             endPrice = 0;
938         }
939 
940         if(_saleDuration == 0) {
941             duration = SALES_DURATION;
942         } else {
943             duration = _saleDuration;
944         }
945 
946         _createSale(
947             nftId,
948             startPrice,
949             endPrice,
950             duration,
951             address(this)
952         );
953     }
954 
955     /**
956      * @dev        Creates Team Sale Auction
957      * @param      _teamId        The team identifier
958      * @param      _tokenIds      The token identifiers
959      * @param      _startPrice    The start price
960      * @param      _endPrice      The end price
961      * @param      _saleDuration  The sale duration
962      */
963     function createTeamSaleAuction(
964         uint8 _teamId,
965         uint256[9] _tokenIds,
966         uint256 _startPrice,
967         uint256 _endPrice,
968         uint256 _saleDuration)
969         public
970         onlyGameManager
971         whenNotPaused {
972 
973         require(_teamId != 0);
974 
975         // Helps in not creating sale with wrong team and player combination
976         for(uint ii = 0; ii < _tokenIds.length; ii++){
977             require(nonFungibleContract.getTeamId(_tokenIds[ii]) == _teamId);
978         }
979         
980         uint256 startPrice = 0;
981         uint256 endPrice = 0;
982         uint256 duration = 0;
983         
984         if(_startPrice == 0) {
985             startPrice = _computeNextSeedPrice(1, _teamId).mul(9);
986         } else {
987             startPrice = _startPrice;
988         }
989 
990         if(_endPrice != 0) {
991             endPrice = _endPrice;
992         } else {
993             endPrice = 0;
994         }
995 
996         if(_saleDuration == 0) {
997             duration = SALES_DURATION;
998         } else {
999             duration = _saleDuration;
1000         }
1001 
1002         _createTeamSale(
1003             _tokenIds,
1004             startPrice,
1005             endPrice,
1006             duration,
1007             address(this)
1008         );
1009     }
1010 
1011     /**
1012      * @dev        Computes the next auction starting price
1013      * @param      _saleType     The sale type
1014      * @param      _teamId       The team identifier
1015      */
1016     function _computeNextSeedPrice(uint256 _saleType, uint256 _teamId) internal view returns (uint256) {
1017         uint256 nextPrice = _averageSalePrice(_saleType, _teamId);
1018 
1019         // Sanity check to ensure we don't overflow arithmetic
1020         require(nextPrice == nextPrice);
1021 
1022         // We never auction for less than starting price
1023         if (nextPrice < STARTING_PRICE) {
1024             nextPrice = STARTING_PRICE;
1025         }
1026 
1027         return nextPrice;
1028     }
1029 
1030     /**
1031      * @dev        Sanity check that allows us to ensure that we are pointing to the right sale call.
1032      */
1033     bool public isSalesManager = true;
1034 
1035     /**
1036      * @dev        works the same as default bid method.
1037      * @param      _tokenId  The token identifier
1038      */
1039     function bid(uint256 _tokenId) public whenNotPaused payable {
1040         
1041         Sale memory sale = tokenIdToSale[_tokenId];
1042         address seller = sale.seller;
1043 
1044         // This check is added to give all users a level playing field to think & bid on the player
1045         require (now > sale.startedAt.add(BID_DELAY_TIME));
1046         
1047         uint256 price = _bid(_tokenId, msg.value);
1048 
1049         //If multi token sale
1050         if(sale.tokenIds[1] > 0) {
1051             
1052             for (uint256 i = 0; i < 9; i++) {
1053                 _transfer(address(this), msg.sender, sale.tokenIds[i]);
1054             }
1055 
1056             // Avg price
1057             price = price.div(9);
1058         } else {
1059             
1060             _transfer(address(this), msg.sender, _tokenId);
1061         }
1062         
1063         // If not a seed, exit
1064         if (seller == address(this)) {
1065             if(sale.tokenIds[1] > 0){
1066                 uint256 _teamId = nonFungibleContract.getTeamId(_tokenId);
1067 
1068                 lastTeamSalePrices[_teamId][seedTeamSaleCount[_teamId] % 3] = price;
1069 
1070                 seedTeamSaleCount[_teamId]++;
1071             } else {
1072                 lastSingleSalePrices[seedSingleSaleCount % 10] = price;
1073                 seedSingleSaleCount++;
1074             }
1075         }
1076     }
1077     
1078     /**
1079      * @dev        Sets the address for the NFT Contract
1080      * @param      _nftAddress  The nft address
1081      */
1082     function setNFTContractAddress(address _nftAddress) public onlyGameManager {
1083         require (_nftAddress != address(0));        
1084         nonFungibleContract = MLBNFT(_nftAddress);
1085     }
1086 
1087     /**
1088      * @dev        Added this module to allow retrieve of accidental asset transfer to contract
1089      * @param      _to       { parameter_description }
1090      * @param      _tokenId  The token identifier
1091      */
1092     function assetTransfer(address _to, uint256 _tokenId) public onlyGameManager {
1093         require(_tokenId != 0);
1094         nonFungibleContract.transferFrom(address(this), _to, _tokenId);
1095     }
1096 
1097      /**
1098      * @dev        Added this module to allow retrieve of accidental asset transfer to contract
1099      * @param      _to       { parameter_description }
1100      * @param      _tokenIds  The token identifiers
1101      */
1102     function batchAssetTransfer(address _to, uint256[] _tokenIds) public onlyGameManager {
1103         require(isBatchSupported);
1104         require (_tokenIds.length > 0);
1105         
1106         for(uint i = 0; i < _tokenIds.length; i++){
1107             require(_tokenIds[i] != 0);
1108             nonFungibleContract.transferFrom(address(this), _to, _tokenIds[i]);
1109         }
1110     }
1111 
1112     /**
1113      * @dev        Creates new Seed Team Collectibles
1114      * @notice     Creates a team and transfers all minted assets to SaleManager
1115      * @param      _teamId       The team identifier
1116      * @param      _attributes   The attributes
1117      * @param      _mlbPlayerId  The mlb player identifier
1118      */
1119     function createSeedTeam(uint8 _teamId, uint256[9] _attributes, uint256[9] _mlbPlayerId) public onlyGameManager whenNotPaused {
1120         require(_teamId != 0);
1121         
1122         for(uint ii = 0; ii < 9; ii++) {
1123             nonFungibleContract.createSeedCollectible(_teamId, uint8(ii.add(1)), _attributes[ii], address(this), 0, 0, _mlbPlayerId[ii]);
1124         }
1125     }
1126 
1127     /**
1128      * @dev            Cancels an sale that hasn't been won yet. Returns the MLBNFT (ERC721) to original owner.
1129      * @notice         This is a state-modifying function that can be called while the contract is paused.
1130      */
1131     function batchCancelSale(uint256[] _tokenIds) external whenNotPaused {
1132         require(isBatchSupported);
1133         require(_tokenIds.length > 0);
1134 
1135         for(uint ii = 0; ii < _tokenIds.length; ii++){
1136             Sale memory sale = tokenIdToSale[_tokenIds[ii]];
1137             require(_isOnSale(sale));
1138             
1139             address seller = sale.seller;
1140             require(msg.sender == seller);
1141 
1142             _cancelSale(_tokenIds[ii], seller);
1143         }
1144     }
1145 
1146     /**
1147      * @dev        Helps to toggle batch supported flag
1148      * @param      _flag  The flag
1149      */
1150     function updateBatchSupport(bool _flag) public onlyGameManager {
1151         isBatchSupported = _flag;
1152     }
1153 
1154     /**
1155      * @dev        Batching Operation: Creates a new Collectible and creates an auction for it.
1156      * @notice     Helps in creating single seed auctions in batches
1157      * @param      _teamIds            The team identifier
1158      * @param      _posIds            The position identifier
1159      * @param      _attributes        The attributes
1160      * @param      _playerOverrideIds  The player override identifier
1161      * @param      _mlbPlayerIds       The mlb player identifier
1162      * @param      _startPrice         The start price
1163      */
1164     function batchCreateSingleSeedAuction(
1165         uint8[] _teamIds,
1166         uint8[] _posIds,
1167         uint256[] _attributes,
1168         uint256[] _playerOverrideIds,
1169         uint256[] _mlbPlayerIds,
1170         uint256 _startPrice)
1171         public
1172         onlyGameManager
1173         whenNotPaused {
1174 
1175         require (isBatchSupported);
1176 
1177         require (_teamIds.length > 0 &&
1178             _posIds.length > 0 &&
1179             _attributes.length > 0 &&
1180             _playerOverrideIds.length > 0 &&
1181             _mlbPlayerIds.length > 0 );
1182         
1183         // Check to see the NFT address is not 0
1184         require(nonFungibleContract != address(0));
1185         
1186         uint256 nftId;
1187 
1188         require (_startPrice != 0);
1189 
1190         for(uint ii = 0; ii < _mlbPlayerIds.length; ii++){
1191             require(_teamIds[ii] != 0);
1192 
1193             nftId = nonFungibleContract.createSeedCollectible(
1194                         _teamIds[ii],
1195                         _posIds[ii],
1196                         _attributes[ii],
1197                         address(this),
1198                         0,
1199                         _playerOverrideIds[ii],
1200                         _mlbPlayerIds[ii]);
1201 
1202             _createSale(
1203                 nftId,
1204                 _startPrice,
1205                 0,
1206                 SALES_DURATION,
1207                 address(this)
1208             );
1209         }
1210     }
1211 
1212     /**
1213      * @dev        Helps in incrementing the delay time to start bidding for any auctions
1214      * @notice     Function helps to update the delay time for bidding
1215      * @param      _newDelay       The new Delay time
1216      */
1217     function updateDelayTime(uint256 _newDelay) public onlyGameManager whenNotPaused {
1218 
1219         BID_DELAY_TIME = _newDelay;
1220     }
1221 
1222     function bidTransfer(uint256 _tokenId, address _buyer, uint256 _bidAmount) public canTransact {
1223 
1224         Sale memory sale = tokenIdToSale[_tokenId];
1225         address seller = sale.seller;
1226 
1227         // This check is added to give all users a level playing field to think & bid on the player
1228         require (now > sale.startedAt.add(BID_DELAY_TIME));
1229         
1230         uint256[9] memory tokenIdsStore = tokenIdToSale[_tokenId].tokenIds;
1231         
1232         // Explicitly check that this sale is currently live.
1233         require(_isOnSale(sale));
1234 
1235         // Check that the bid is greater than or equal to the current price
1236         uint256 price = _currentPrice(sale);
1237         require(_bidAmount >= price);
1238 
1239         // The bid is good! Remove the sale before sending the fees
1240         // to the sender so we can't have a reentrancy attack.
1241         if(tokenIdsStore[1] > 0) {
1242             for(uint ii = 0; ii < 9; ii++) {
1243                 _removeSale(tokenIdsStore[ii]);
1244             }
1245         } else {
1246             _removeSale(_tokenId);
1247         }
1248 
1249         uint256 marketsCut = 0;
1250         uint256 sellerProceeds = 0;
1251 
1252         // Transfer proceeds to seller (if there are any!)
1253         if (price > 0) {
1254             // Calculate the marketplace's cut.
1255             // (NOTE: _computeCut() is guaranteed to return a
1256             // value <= price)
1257             marketsCut = _computeCut(price);
1258             sellerProceeds = price.sub(marketsCut);
1259         }
1260 
1261         //escrowTransfer(address seller, address buyer, uint256 currentPrice) public returns(bool);
1262         require (LSEscrowContract.escrowTransfer(seller, _buyer, sellerProceeds, marketsCut));
1263         
1264         // Tell the world!
1265         // uint256 assetID, uint256 totalPrice, address winner, uint16 generation
1266         if(tokenIdsStore[1] > 0) {
1267             emit TeamSaleWinner(tokenIdsStore, price, _buyer);
1268         } else {
1269             emit SaleWinner(_tokenId, price, _buyer);
1270         }
1271 
1272         //If multi token sale
1273         if(sale.tokenIds[1] > 0) {
1274             
1275             for (uint256 i = 0; i < 9; i++) {
1276                 _transfer(address(this), _buyer, sale.tokenIds[i]);
1277             }
1278 
1279             // Avg price
1280             price = price.div(9);
1281         } else {
1282             
1283             _transfer(address(this), _buyer, _tokenId);
1284         }
1285         
1286         // If not a seed, exit
1287         if (seller == address(this)) {
1288             if(sale.tokenIds[1] > 0) {
1289                 uint256 _teamId = nonFungibleContract.getTeamId(_tokenId);
1290 
1291                 lastTeamSalePrices[_teamId][seedTeamSaleCount[_teamId] % 3] = price;
1292 
1293                 seedTeamSaleCount[_teamId]++;
1294             } else {
1295                 lastSingleSalePrices[seedSingleSaleCount % 10] = price;
1296                 seedSingleSaleCount++;
1297             }
1298         }
1299     }
1300 
1301     /**
1302      * @dev        Sets the address for the LS Escrow Contract
1303      * @param      _lsEscrowAddress  The nft address
1304      */
1305     function setLSEscrowContractAddress(address _lsEscrowAddress) public onlyGameManager {
1306         require (_lsEscrowAddress != address(0));        
1307         LSEscrowContract = LSEscrow(_lsEscrowAddress);
1308     }
1309 }