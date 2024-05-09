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
73     // The addresses of the accounts (or contracts) that can execute actions within each roles.
74     address public gameManagerPrimary;
75     address public gameManagerSecondary;
76     address public bankManager;
77 
78     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
79     bool public paused = false;
80 
81     /// @dev Operation modifiers for limiting access
82     modifier onlyGameManager() {
83         require(msg.sender == gameManagerPrimary || msg.sender == gameManagerSecondary);
84         _;
85     }
86 
87     /// @dev Operation modifiers for limiting access to only Banker
88     modifier onlyBanker() {
89         require(msg.sender == bankManager);
90         _;
91     }
92 
93     /// @dev Operation modifiers for access to any Manager
94     modifier anyOperator() {
95         require(
96             msg.sender == gameManagerPrimary ||
97             msg.sender == gameManagerSecondary ||
98             msg.sender == bankManager
99         );
100         _;
101     }
102 
103     /// @dev Assigns a new address to act as the GM.
104     function setPrimaryGameManager(address _newGM) external onlyGameManager {
105         require(_newGM != address(0));
106 
107         gameManagerPrimary = _newGM;
108     }
109 
110     /// @dev Assigns a new address to act as the GM.
111     function setSecondaryGameManager(address _newGM) external onlyGameManager {
112         require(_newGM != address(0));
113 
114         gameManagerSecondary = _newGM;
115     }
116 
117     /// @dev Assigns a new address to act as the Banker.
118     function setBanker(address _newBK) external onlyBanker {
119         require(_newBK != address(0));
120 
121         bankManager = _newBK;
122     }
123 
124     /*** Pausable functionality adapted from OpenZeppelin ***/
125 
126     /// @dev Modifier to allow actions only when the contract IS NOT paused
127     modifier whenNotPaused() {
128         require(!paused);
129         _;
130     }
131 
132     /// @dev Modifier to allow actions only when the contract IS paused
133     modifier whenPaused {
134         require(paused);
135         _;
136     }
137 
138     /// @dev Called by any Operator role to pause the contract.
139     /// Used only if a bug or exploit is discovered (Here to limit losses / damage)
140     function pause() external onlyGameManager whenNotPaused {
141         paused = true;
142     }
143 
144     /// @dev Unpauses the smart contract. Can only be called by the Game Master
145     /// @notice This is public rather than external so it can be called by derived contracts. 
146     function unpause() public onlyGameManager whenPaused {
147         // can't unpause if contract was upgraded
148         paused = false;
149     }
150 }
151 
152 /* @title Interface for MLBNFT Contract
153  * @author Fazri Zubair & Farhan Khwaja (Lucid Sight, Inc.)
154  */
155 contract MLBNFT {
156     function exists(uint256 _tokenId) public view returns (bool _exists);
157     function ownerOf(uint256 _tokenId) public view returns (address _owner);
158     function approve(address _to, uint256 _tokenId) public;
159     function setApprovalForAll(address _to, bool _approved) public;
160     function transferFrom(address _from, address _to, uint256 _tokenId) public;
161     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
162     function createPromoCollectible(uint8 _teamId, uint8 _posId, uint256 _attributes, address _owner, uint256 _gameId, uint256 _playerOverrideId, uint256 _mlbPlayerId) external returns (uint256);
163     function createSeedCollectible(uint8 _teamId, uint8 _posId, uint256 _attributes, address _owner, uint256 _gameId, uint256 _playerOverrideId, uint256 _mlbPlayerId) public returns (uint256);
164     function checkIsAttached(uint256 _tokenId) public view returns (uint256);
165     function getTeamId(uint256 _tokenId) external view returns (uint256);
166     function getPlayerId(uint256 _tokenId) external view returns (uint256 playerId);
167     function getApproved(uint256 _tokenId) public view returns (address _operator);
168     function isApprovedForAll(address _owner, address _operator) public view returns (bool);
169 }
170 
171 /**
172  * @title ERC721 token receiver interface
173  * @dev Interface for any contract that wants to support safeTransfers
174  *  from ERC721 asset contracts.
175  */
176 contract ERC721Receiver {
177     /**
178     * @dev Magic value to be returned upon successful reception of an NFT
179     *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
180     *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
181     */
182     bytes4 public constant ERC721_RECEIVED = 0x150b7a02;
183 
184     /**
185     * @notice Handle the receipt of an NFT
186     * @dev The ERC721 smart contract calls this function on the recipient
187     *  after a `safetransfer`. This function MAY throw to revert and reject the
188     *  transfer. This function MUST use 50,000 gas or less. Return of other
189     *  than the magic value MUST result in the transaction being reverted.
190     *  Note: the contract address is always the message sender.
191     * @param _from The sending address
192     * @param _tokenId The NFT identifier which is being transfered
193     * @param _data Additional data with no specified format
194     * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
195     */
196     function onERC721Received(
197         address _operator,
198         address _from,
199         uint256 _tokenId,
200         bytes _data
201     )
202         public
203         returns(bytes4);
204 }
205 
206 contract ERC721Holder is ERC721Receiver {
207     function onERC721Received(address,address, uint256, bytes) public returns(bytes4) {
208         return ERC721_RECEIVED;
209     }
210 }
211 
212 /* Contains models, variables, and internal methods for the ERC-721 sales.
213  * @title Sale Base
214  * @author Fazri Zubair & Farhan Khwaja (Lucid Sight, Inc.)
215  */
216 contract SaleBase is OperationalControl, ERC721Holder {
217     using SafeMath for uint256;
218     
219     /// EVENTS 
220 
221     event SaleCreated(uint256 tokenID, uint256 startingPrice, uint256 endingPrice, uint256 duration, uint256 startedAt);
222     event TeamSaleCreated(uint256[9] tokenIDs, uint256 startingPrice, uint256 endingPrice, uint256 duration, uint256 startedAt);
223     event SaleWinner(uint256 tokenID, uint256 totalPrice, address winner);
224     event TeamSaleWinner(uint256[9] tokenIDs, uint256 totalPrice, address winner);
225     event SaleCancelled(uint256 tokenID, address sellerAddress);
226     event EtherWithdrawed(uint256 value);
227 
228     /// STORAGE
229 
230     /**
231      * @dev        Represents an Sale on MLB CryptoBaseball (ERC721)
232      */
233     struct Sale {
234         // Current owner of NFT (ERC721)
235         address seller;
236         // Price (in wei) at beginning of sale
237         uint256 startingPrice;
238         // Price (in wei) at end of sale
239         uint256 endingPrice;
240         // Duration (in seconds) of sale
241         uint256 duration;
242         // Time when sale started
243         // NOTE: 0 if this sale has been concluded
244         uint256 startedAt;
245         // ERC721 AssetID
246         uint256[9] tokenIds;
247     }
248 
249     /**
250      * @dev        Reference to contract tracking ownership & asset details
251      */
252     MLBNFT public nonFungibleContract;
253 
254     // Cut owner takes on each sale, measured in basis points (1/100 of a percent).
255     // Values 0-10,000 map to 0%-100%
256     uint256 public ownerCut = 500; //5%
257 
258     // Map from token to their corresponding sale.
259     mapping (uint256 => Sale) tokenIdToSale;
260 
261     /**
262      * @dev        Returns true if the claimant owns the token.
263      * @param      _claimant  The claimant
264      * @param      _tokenId   The token identifier
265      */
266     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
267         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
268     }
269 
270     /**
271      * @dev        Internal function to ESCROW
272      * @notice     Escrows the ERC721 Token, assigning ownership to this contract. Throws if the escrow fails.
273      * @param      _owner    The owner
274      * @param      _tokenId  The token identifier
275      */
276     function _escrow(address _owner, uint256 _tokenId) internal {
277         nonFungibleContract.safeTransferFrom(_owner, this, _tokenId);
278     }
279 
280     /**
281      * @dev        Internal Transfer function
282      * @notice     Transfers an ERC721 Token owned by this contract to another address. Returns true if the transfer succeeds.
283      * @param      _owner     The owner
284      * @param      _receiver  The receiver
285      * @param      _tokenId   The token identifier
286      */
287     function _transfer(address _owner, address _receiver, uint256 _tokenId) internal {
288         nonFungibleContract.transferFrom(_owner, _receiver, _tokenId);
289     }
290 
291     /**
292      * @dev        Internal Function to add Sale, which duration check (atleast 1 min duration required)
293      * @notice     Adds an sale to the list of open sales. Also fires the SaleCreated event.
294      * @param      _tokenId  The token identifier
295      * @param      _sale     The sale
296      */
297     function _addSale(uint256 _tokenId, Sale _sale) internal {
298         // Require that all sales have a duration of
299         // at least one minute.
300         require(_sale.duration >= 1 minutes);
301         
302         tokenIdToSale[_tokenId] = _sale;
303 
304         emit SaleCreated(
305             uint256(_tokenId),
306             uint256(_sale.startingPrice),
307             uint256(_sale.endingPrice),
308             uint256(_sale.duration),
309             uint256(_sale.startedAt)
310         );
311     }
312 
313     /**
314      * @dev        Internal Function to add Team Sale, which duration check (atleast 1 min duration required)
315      * @notice     Adds an sale to the list of open sales. Also fires the SaleCreated event.
316      * @param      _tokenIds  The token identifiers
317      * @param      _sale      The sale
318      */
319     function _addTeamSale(uint256[9] _tokenIds, Sale _sale) internal {
320         // Require that all sales have a duration of
321         // at least one minute.
322         require(_sale.duration >= 1 minutes);
323         
324         for(uint ii = 0; ii < 9; ii++) {
325             require(_tokenIds[ii] != 0);
326             require(nonFungibleContract.exists(_tokenIds[ii]));
327 
328             tokenIdToSale[_tokenIds[ii]] = _sale;
329         }
330 
331         emit TeamSaleCreated(
332             _tokenIds,
333             uint256(_sale.startingPrice),
334             uint256(_sale.endingPrice),
335             uint256(_sale.duration),
336             uint256(_sale.startedAt)
337         );
338     }
339 
340     /**
341      * @dev        Facilites Sale cancellation. Also removed the Sale from the array
342      * @notice        Cancels an sale (given the collectibleID is not 0). SaleCancelled Event
343      * @param      _tokenId  The token identifier
344      * @param      _seller   The seller
345      */
346     function _cancelSale(uint256 _tokenId, address _seller) internal {
347         Sale memory saleItem = tokenIdToSale[_tokenId];
348 
349         //Check for team sale
350         if(saleItem.tokenIds[1] != 0) {
351             for(uint ii = 0; ii < 9; ii++) {
352                 _removeSale(saleItem.tokenIds[ii]);
353                 _transfer(address(this), _seller, saleItem.tokenIds[ii]);
354             }
355             emit SaleCancelled(_tokenId, _seller);
356         } else {
357             _removeSale(_tokenId);
358             _transfer(address(this), _seller, _tokenId);
359             emit SaleCancelled(_tokenId, _seller);
360         }
361     }
362 
363     /**
364      * @dev        Computes the price and transfers winnings. Does NOT transfer ownership of token.
365      * @param      _tokenId    The token identifier
366      * @param      _bidAmount  The bid amount
367      */
368     function _bid(uint256 _tokenId, uint256 _bidAmount)
369         internal
370         returns (uint256)
371     {
372         // Get a reference to the sale struct
373         Sale storage _sale = tokenIdToSale[_tokenId];
374         uint256[9] memory tokenIdsStore = tokenIdToSale[_tokenId].tokenIds;
375         // Explicitly check that this sale is currently live.
376         // (Because of how Ethereum mappings work, we can't just count
377         // on the lookup above failing. An invalid _tokenId will just
378         // return an sale object that is all zeros.)
379         require(_isOnSale(_sale));
380 
381         // Check that the bid is greater than or equal to the current price
382         uint256 price = _currentPrice(_sale);
383         require(_bidAmount >= price);
384 
385         // Grab a reference to the seller before the sale  struct
386         // gets deleted.
387         address seller = _sale.seller;
388 
389         if(tokenIdsStore[1] > 0) {
390             for(uint ii = 0; ii < 9; ii++) {
391                 // The bid is good! Remove the sale before sending the fees
392                 // to the sender so we can't have a reentrancy attack.
393                 _removeSale(tokenIdsStore[ii]);
394             }
395         } else {
396             // The bid is good! Remove the sale before sending the fees
397             // to the sender so we can't have a reentrancy attack.
398             _removeSale(_tokenId);
399         }
400 
401         
402 
403         // Transfer proceeds to seller (if there are any!)
404         if (price > 0) {
405             // Calculate the marketplace's cut.
406             // (NOTE: _computeCut() is guaranteed to return a
407             // value <= price, so this subtraction can't go negative.)
408             uint256 marketsCut = _computeCut(price);
409             uint256 sellerProceeds = price.sub(marketsCut);
410 
411             // NOTE: Doing a transfer() in the middle of a complex
412             // method like this is generally discouraged because of
413             // reentrancy attacks and DoS attacks if the seller is
414             // a contract with an invalid fallback function. We explicitly
415             // guard against reentrancy attacks by removing the sale
416             // before calling transfer(), and the only thing the seller
417             // can DoS is the sale of their own asset! (And if it's an
418             // accident, they can call cancelSale(). )
419             seller.transfer(sellerProceeds);
420         }
421 
422         // Calculate any excess funds included with the bid. If the excess
423         // is anything worth worrying about, transfer it back to bidder.
424         // NOTE: We checked above that the bid amount is greater than or
425         // equal to the price so this cannot underflow.
426         uint256 bidExcess = _bidAmount.sub(price);
427 
428         // Return the funds. Similar to the previous transfer, this is
429         // not susceptible to a re-entry attack because the sale is
430         // removed before any transfers occur.
431         msg.sender.transfer(bidExcess);
432 
433         // Tell the world!
434         // uint256 assetID, uint256 totalPrice, address winner, uint16 generation
435         if(tokenIdsStore[1] > 0) {
436             emit TeamSaleWinner(tokenIdsStore, price, msg.sender);
437         } else {
438             emit SaleWinner(_tokenId, price, msg.sender);
439         }
440         
441         return price;
442     }
443 
444     /**
445      * @dev        Removes an sale from the list of open sales.
446      * @param      _tokenId  The token identifier
447      */
448     function _removeSale(uint256 _tokenId) internal {
449         delete tokenIdToSale[_tokenId];
450     }
451 
452     /**
453      * @dev        Returns true if the FT (ERC721) is on sale.
454      * @param      _sale  The sale
455      */
456     function _isOnSale(Sale memory _sale) internal pure returns (bool) {
457         return (_sale.startedAt > 0);
458     }
459 
460     /** @dev Returns current price of an FT (ERC721) on sale. Broken into two
461      *  functions (this one, that computes the duration from the sale
462      *  structure, and the other that does the price computation) so we
463      *  can easily test that the price computation works correctly.
464      */
465     function _currentPrice(Sale memory _sale)
466         internal
467         view
468         returns (uint256)
469     {
470         uint256 secondsPassed = 0;
471 
472         // A bit of insurance against negative values (or wraparound).
473         // Probably not necessary (since Ethereum guarnatees that the
474         // now variable doesn't ever go backwards).
475         if (now > _sale.startedAt) {
476             secondsPassed = now - _sale.startedAt;
477         }
478 
479         return _computeCurrentPrice(
480             _sale.startingPrice,
481             _sale.endingPrice,
482             _sale.duration,
483             secondsPassed
484         );
485     }
486 
487     /** @dev Computes the current price of an sale. Factored out
488      *  from _currentPrice so we can run extensive unit tests.
489      *  When testing, make this function public and turn on
490      *  `Current price computation` test suite.
491      */
492     function _computeCurrentPrice(
493         uint256 _startingPrice,
494         uint256 _endingPrice,
495         uint256 _duration,
496         uint256 _secondsPassed
497     )
498         internal
499         pure
500         returns (uint256)
501     {
502         // NOTE: We don't use SafeMath (or similar) in this function because
503         //  all of our public functions carefully cap the maximum values for
504         //  time (at 64-bits) and currency (at 128-bits). _duration is
505         //  also known to be non-zero (see the require() statement in
506         //  _addSale())
507         if (_secondsPassed >= _duration) {
508             // We've reached the end of the dynamic pricing portion
509             // of the sale, just return the end price.
510             return _endingPrice;
511         } else {
512             // Starting price can be higher than ending price (and often is!), so
513             // this delta can be negative.
514             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
515 
516             // This multiplication can't overflow, _secondsPassed will easily fit within
517             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
518             // will always fit within 256-bits.
519             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
520 
521             // currentPriceChange can be negative, but if so, will have a magnitude
522             // less that _startingPrice. Thus, this result will always end up positive.
523             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
524 
525             return uint256(currentPrice);
526         }
527     }
528 
529     /**
530      * @dev        Computes owner's cut of a sale.
531      * @param      _price  The price
532      */
533     function _computeCut(uint256 _price) internal view returns (uint256) {
534         // NOTE: We don't use SafeMath (or similar) in this function because
535         //  all of our entry functions carefully cap the maximum values for
536         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
537         //  statement in the CSLClockSales constructor). The result of this
538         //  function is always guaranteed to be <= _price.
539         return _price.mul(ownerCut.div(10000));
540     }
541 }
542 
543 /* Clock sales functions and interfaces
544  * @title SaleManager
545  * @author Fazri Zubair & Farhan Khwaja (Lucid Sight, Inc.)
546  */
547 contract SaleManager is SaleBase {
548 
549     /// @dev MAPINGS
550     mapping (uint256 => uint256[3]) public lastTeamSalePrices;
551     mapping (uint256 => uint256) public lastSingleSalePrices;
552     mapping (uint256 => uint256) public seedTeamSaleCount;
553     uint256 public seedSingleSaleCount = 0;
554 
555     /// @dev CONSTANTS
556     uint256 public constant SINGLE_SALE_MULTIPLIER = 35;
557     uint256 public constant TEAM_SALE_MULTIPLIER = 12;
558     uint256 public constant STARTING_PRICE = 10 finney;
559     uint256 public constant SALES_DURATION = 1 days;
560 
561     bool public isBatchSupported = true;
562 
563     /**
564      * @dev        Constructor creates a reference to the MLB_NFT Sale Manager contract
565      */
566     constructor() public {
567         require(ownerCut <= 10000); // You can't collect more than 100% silly ;)
568         require(msg.sender != address(0));
569         paused = true;
570         gameManagerPrimary = msg.sender;
571         gameManagerSecondary = msg.sender;
572         bankManager = msg.sender;
573     }
574 
575     /// @dev Override unpause so it requires all external contract addresses
576     ///  to be set before contract can be unpaused. Also, we can't have
577     ///  newContractAddress set either, because then the contract was upgraded.
578     /// @notice This is public rather than external so we can call super.unpause
579     ///  without using an expensive CALL.
580     function unpause() public onlyGameManager whenPaused {
581         require(nonFungibleContract != address(0));
582 
583         // Actually unpause the contract.
584         super.unpause();
585     }
586 
587     /** @dev Remove all Ether from the contract, which is the owner's cuts
588      *  as well as any Ether sent directly to the contract address.
589      *  Always transfers to the NFT (ERC721) contract, but can be called either by
590      *  the owner or the NFT (ERC721) contract.
591      */
592     function _withdrawBalance() internal {
593         // We are using this boolean method to make sure that even if one fails it will still work
594         bankManager.transfer(address(this).balance);
595     }
596 
597 
598     /** @dev Reject all Ether from being sent here, unless it's from one of the
599      *  contracts. (Hopefully, we can prevent user accidents.)
600      *  @notice No tipping!
601      */
602     function() external payable {
603         address nftAddress = address(nonFungibleContract);
604         require(
605             msg.sender == address(this) || 
606             msg.sender == gameManagerPrimary ||
607             msg.sender == gameManagerSecondary ||
608             msg.sender == bankManager ||
609             msg.sender == nftAddress
610         );
611     }
612 
613     /**
614      * @dev        Creates and begins a new sale.
615      * @param      _tokenId        The token identifier
616      * @param      _startingPrice  The starting price
617      * @param      _endingPrice    The ending price
618      * @param      _duration       The duration
619      * @param      _seller         The seller
620      */
621     function _createSale(
622         uint256 _tokenId,
623         uint256 _startingPrice,
624         uint256 _endingPrice,
625         uint256 _duration,
626         address _seller
627     )
628         internal
629     {
630         Sale memory sale = Sale(
631             _seller,
632             _startingPrice,
633             _endingPrice,
634             _duration,
635             now,
636             [_tokenId,0,0,0,0,0,0,0,0]
637         );
638         _addSale(_tokenId, sale);
639     }
640 
641     /**
642      * @dev        Internal Function, helps in creating team sale
643      * @param      _tokenIds       The token identifiers
644      * @param      _startingPrice  The starting price
645      * @param      _endingPrice    The ending price
646      * @param      _duration       The duration
647      * @param      _seller         The seller
648      */
649     function _createTeamSale(
650         uint256[9] _tokenIds,
651         uint256 _startingPrice,
652         uint256 _endingPrice,
653         uint256 _duration,
654         address _seller)
655         internal {
656 
657         Sale memory sale = Sale(
658             _seller,
659             _startingPrice,
660             _endingPrice,
661             _duration,
662             now,
663             _tokenIds
664         );
665 
666         /// Add sale obj to all tokens
667         _addTeamSale(_tokenIds, sale);
668     }
669 
670     /** @dev            Cancels an sale that hasn't been won yet. Returns the MLBNFT (ERC721) to original owner.
671      *  @notice         This is a state-modifying function that can be called while the contract is paused.
672      */
673     function cancelSale(uint256 _tokenId) external whenNotPaused {
674         Sale memory sale = tokenIdToSale[_tokenId];
675         require(_isOnSale(sale));
676         address seller = sale.seller;
677         require(msg.sender == seller);
678         _cancelSale(_tokenId, seller);
679     }
680 
681     /** @dev        Cancels an sale that hasn't been won yet. Returns the MLBNFT (ERC721) to original owner.
682      *  @notice     This is a state-modifying function that can be called while the contract is paused. Can be only called by the GameManagers
683      */
684     function cancelSaleWhenPaused(uint256 _tokenId) external whenPaused onlyGameManager {
685         Sale memory sale = tokenIdToSale[_tokenId];
686         require(_isOnSale(sale));
687         address seller = sale.seller;
688         _cancelSale(_tokenId, seller);
689     }
690 
691     /** 
692      * @dev    Returns sales info for an CSLCollectibles (ERC721) on sale.
693      * @notice Fetches the details related to the Sale
694      * @param  _tokenId    ID of the token on sale
695      */
696     function getSale(uint256 _tokenId) external view returns (address seller, uint256 startingPrice, uint256 endingPrice, uint256 duration, uint256 startedAt, uint256[9] tokenIds) {
697         Sale memory sale = tokenIdToSale[_tokenId];
698         require(_isOnSale(sale));
699         return (
700             sale.seller,
701             sale.startingPrice,
702             sale.endingPrice,
703             sale.duration,
704             sale.startedAt,
705             sale.tokenIds
706         );
707     }
708 
709     /**
710      * @dev        Returns the current price of an sale.
711      * @param      _tokenId  The token identifier
712      */
713     function getCurrentPrice(uint256 _tokenId) external view returns (uint256) {
714         Sale memory sale = tokenIdToSale[_tokenId];
715         require(_isOnSale(sale));
716         return _currentPrice(sale);
717     }
718 
719     /** @dev Calculates the new price for Sale Item
720      * @param   _saleType     Sale Type Identifier (0 - Single Sale, 1 - Team Sale)
721      * @param   _teamId       Team Identifier
722      */
723     function _averageSalePrice(uint256 _saleType, uint256 _teamId) internal view returns (uint256) {
724         uint256 _price = 0;
725         if(_saleType == 0) {
726             for(uint256 ii = 0; ii < 10; ii++) {
727                 _price = _price.add(lastSingleSalePrices[ii]);
728             }
729             _price = (_price.div(10)).mul(SINGLE_SALE_MULTIPLIER.div(10));
730         } else {
731             for (uint256 i = 0; i < 3; i++) {
732                 _price = _price.add(lastTeamSalePrices[_teamId][i]);
733             }
734         
735             _price = (_price.div(3)).mul(TEAM_SALE_MULTIPLIER.div(10));
736             _price = _price.mul(9);
737         }
738 
739         return _price;
740     }
741     
742     /**
743      * @dev        Put a Collectible up for sale. Does some ownership trickery to create sale in one tx.
744      * @param      _tokenId        The token identifier
745      * @param      _startingPrice  The starting price
746      * @param      _endingPrice    The ending price
747      * @param      _duration       The duration
748      * @param      _owner          Owner of the token
749      */
750     function createSale(uint256 _tokenId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration, address _owner) external whenNotPaused {
751         require(msg.sender == address(nonFungibleContract));
752 
753         // Check whether the collectible is inPlay. If inPlay cant put it on Sale
754         require(nonFungibleContract.checkIsAttached(_tokenId) == 0);
755         
756         _escrow(_owner, _tokenId);
757 
758         // Sale throws if inputs are invalid and clears
759         // transfer and sire approval after escrowing the CSLCollectible.
760         _createSale(
761             _tokenId,
762             _startingPrice,
763             _endingPrice,
764             _duration,
765             _owner
766         );
767     }
768 
769     /**
770      * @dev        Put a Collectible up for sale. Only callable, if user approved contract for 1/All Collectibles
771      * @param      _tokenId        The token identifier
772      * @param      _startingPrice  The starting price
773      * @param      _endingPrice    The ending price
774      * @param      _duration       The duration
775      */
776     function userCreateSaleIfApproved (uint256 _tokenId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration) external whenNotPaused {
777         
778         require(nonFungibleContract.getApproved(_tokenId) == address(this) || nonFungibleContract.isApprovedForAll(msg.sender, address(this)));
779         
780         // Check whether the collectible is inPlay. If inPlay cant put it on Sale
781         require(nonFungibleContract.checkIsAttached(_tokenId) == 0);
782         
783         _escrow(msg.sender, _tokenId);
784 
785         // Sale throws if inputs are invalid and clears
786         // transfer and sire approval after escrowing the CSLCollectible.
787         _createSale(
788             _tokenId,
789             _startingPrice,
790             _endingPrice,
791             _duration,
792             msg.sender
793         );
794     }
795 
796     /** 
797      * @dev        Transfers the balance of the sales manager contract to the CSLCollectible contract. We use two-step withdrawal to
798      *              prevent two transfer calls in the sale bid function.
799      */
800     function withdrawSaleManagerBalances() public onlyBanker {
801         _withdrawBalance();
802     }
803 
804     /** 
805      *  @dev Function to chnage the OwnerCut only accessible by the Owner of the contract
806      *  @param _newCut - Sets the ownerCut to new value
807      */
808     function setOwnerCut(uint256 _newCut) external onlyBanker {
809         require(_newCut <= 10000);
810         ownerCut = _newCut;
811     }
812     
813     /**
814      * @dev        Facilitates seed collectible auction creation. Enforces strict check on the data being passed
815      * @notice     Creates a new Collectible and creates an auction for it.
816      * @param      _teamId            The team identifier
817      * @param      _posId             The position identifier
818      * @param      _attributes        The attributes
819      * @param      _playerOverrideId  The player override identifier
820      * @param      _mlbPlayerId       The mlb player identifier
821      * @param      _startPrice        The start price
822      * @param      _endPrice          The end price
823      * @param      _saleDuration      The sale duration
824      */
825     function createSingleSeedAuction(
826         uint8 _teamId,
827         uint8 _posId,
828         uint256 _attributes,
829         uint256 _playerOverrideId,
830         uint256 _mlbPlayerId,
831         uint256 _startPrice,
832         uint256 _endPrice,
833         uint256 _saleDuration)
834         public
835         onlyGameManager
836         whenNotPaused {
837         // Check to see the NFT address is not 0
838         require(nonFungibleContract != address(0));
839         require(_teamId != 0);
840 
841         uint256 nftId = nonFungibleContract.createSeedCollectible(_teamId,_posId,_attributes,address(this),0, _playerOverrideId, _mlbPlayerId);
842 
843         uint256 startPrice = 0;
844         uint256 endPrice = 0;
845         uint256 duration = 0;
846         
847         if(_startPrice == 0) {
848             startPrice = _computeNextSeedPrice(0, _teamId);
849         } else {
850             startPrice = _startPrice;
851         }
852 
853         if(_endPrice != 0) {
854             endPrice = _endPrice;
855         } else {
856             endPrice = 0;
857         }
858 
859         if(_saleDuration == 0) {
860             duration = SALES_DURATION;
861         } else {
862             duration = _saleDuration;
863         }
864 
865         _createSale(
866             nftId,
867             startPrice,
868             endPrice,
869             duration,
870             address(this)
871         );
872     }
873 
874     /**
875      * @dev        Facilitates promo collectible auction creation. Enforces strict check on the data being passed
876      * @notice     Creates a new Collectible and creates an auction for it.
877      * @param      _teamId            The team identifier
878      * @param      _posId             The position identifier
879      * @param      _attributes        The attributes
880      * @param      _playerOverrideId  The player override identifier
881      * @param      _mlbPlayerId       The mlb player identifier
882      * @param      _startPrice        The start price
883      * @param      _endPrice          The end price
884      * @param      _saleDuration      The sale duration
885      */
886     function createPromoSeedAuction(
887         uint8 _teamId,
888         uint8 _posId,
889         uint256 _attributes,
890         uint256 _playerOverrideId,
891         uint256 _mlbPlayerId,
892         uint256 _startPrice,
893         uint256 _endPrice,
894         uint256 _saleDuration)
895         public
896         onlyGameManager
897         whenNotPaused {
898         // Check to see the NFT address is not 0
899         require(nonFungibleContract != address(0));
900         require(_teamId != 0);
901 
902         uint256 nftId = nonFungibleContract.createPromoCollectible(_teamId, _posId, _attributes, address(this), 0, _playerOverrideId, _mlbPlayerId);
903 
904         uint256 startPrice = 0;
905         uint256 endPrice = 0;
906         uint256 duration = 0;
907         
908         if(_startPrice == 0) {
909             startPrice = _computeNextSeedPrice(0, _teamId);
910         } else {
911             startPrice = _startPrice;
912         }
913 
914         if(_endPrice != 0) {
915             endPrice = _endPrice;
916         } else {
917             endPrice = 0;
918         }
919 
920         if(_saleDuration == 0) {
921             duration = SALES_DURATION;
922         } else {
923             duration = _saleDuration;
924         }
925 
926         _createSale(
927             nftId,
928             startPrice,
929             endPrice,
930             duration,
931             address(this)
932         );
933     }
934 
935     /**
936      * @dev        Creates Team Sale Auction
937      * @param      _teamId        The team identifier
938      * @param      _tokenIds      The token identifiers
939      * @param      _startPrice    The start price
940      * @param      _endPrice      The end price
941      * @param      _saleDuration  The sale duration
942      */
943     function createTeamSaleAuction(
944         uint8 _teamId,
945         uint256[9] _tokenIds,
946         uint256 _startPrice,
947         uint256 _endPrice,
948         uint256 _saleDuration)
949         public
950         onlyGameManager
951         whenNotPaused {
952 
953         require(_teamId != 0);
954 
955         // Helps in not creating sale with wrong team and player combination
956         for(uint ii = 0; ii < _tokenIds.length; ii++){
957             require(nonFungibleContract.getTeamId(_tokenIds[ii]) == _teamId);
958         }
959         
960         uint256 startPrice = 0;
961         uint256 endPrice = 0;
962         uint256 duration = 0;
963         
964         if(_startPrice == 0) {
965             startPrice = _computeNextSeedPrice(1, _teamId).mul(9);
966         } else {
967             startPrice = _startPrice;
968         }
969 
970         if(_endPrice != 0) {
971             endPrice = _endPrice;
972         } else {
973             endPrice = 0;
974         }
975 
976         if(_saleDuration == 0) {
977             duration = SALES_DURATION;
978         } else {
979             duration = _saleDuration;
980         }
981 
982         _createTeamSale(
983             _tokenIds,
984             startPrice,
985             endPrice,
986             duration,
987             address(this)
988         );
989     }
990 
991     /**
992      * @dev        Computes the next auction starting price
993      * @param      _saleType     The sale type
994      * @param      _teamId       The team identifier
995      */
996     function _computeNextSeedPrice(uint256 _saleType, uint256 _teamId) internal view returns (uint256) {
997         uint256 nextPrice = _averageSalePrice(_saleType, _teamId);
998 
999         // Sanity check to ensure we don't overflow arithmetic
1000         require(nextPrice == nextPrice);
1001 
1002         // We never auction for less than starting price
1003         if (nextPrice < STARTING_PRICE) {
1004             nextPrice = STARTING_PRICE;
1005         }
1006 
1007         return nextPrice;
1008     }
1009 
1010     /**
1011      * @dev        Sanity check that allows us to ensure that we are pointing to the right sale call.
1012      */
1013     bool public isSalesManager = true;
1014 
1015     /**
1016      * @dev        works the same as default bid method.
1017      * @param      _tokenId  The token identifier
1018      */
1019     function bid(uint256 _tokenId) public whenNotPaused payable {
1020         
1021         Sale memory sale = tokenIdToSale[_tokenId];
1022         address seller = sale.seller;
1023         uint256 price = _bid(_tokenId, msg.value);
1024 
1025         //If multi token sale
1026         if(sale.tokenIds[1] > 0) {
1027             
1028             for (uint256 i = 0; i < 9; i++) {
1029                 _transfer(address(this), msg.sender, sale.tokenIds[i]);
1030             }
1031 
1032             //Gets Avg price
1033             price = price.div(9);
1034         } else {
1035             
1036             _transfer(address(this), msg.sender, _tokenId);
1037         }
1038         
1039         // If not a seed, exit
1040         if (seller == address(this)) {
1041             if(sale.tokenIds[1] > 0){
1042                 uint256 _teamId = nonFungibleContract.getTeamId(_tokenId);
1043 
1044                 lastTeamSalePrices[_teamId][seedTeamSaleCount[_teamId] % 3] = price;
1045 
1046                 seedTeamSaleCount[_teamId]++;
1047             } else {
1048                 lastSingleSalePrices[seedSingleSaleCount % 10] = price;
1049                 seedSingleSaleCount++;
1050             }
1051         }
1052     }
1053     
1054     /**
1055      * @dev        Sets the address for the NFT Contract
1056      * @param      _nftAddress  The nft address
1057      */
1058     function setNFTContractAddress(address _nftAddress) public onlyGameManager {
1059         require (_nftAddress != address(0));        
1060         nonFungibleContract = MLBNFT(_nftAddress);
1061     }
1062 
1063     /**
1064      * @dev        Added this module to allow retrieve of accidental asset transfer to contract
1065      * @param      _to       { parameter_description }
1066      * @param      _tokenId  The token identifier
1067      */
1068     function assetTransfer(address _to, uint256 _tokenId) public onlyGameManager {
1069         require(_tokenId != 0);
1070         nonFungibleContract.transferFrom(address(this), _to, _tokenId);
1071     }
1072 
1073      /**
1074      * @dev        Added this module to allow retrieve of accidental asset transfer to contract
1075      * @param      _to       { parameter_description }
1076      * @param      _tokenIds  The token identifiers
1077      */
1078     function batchAssetTransfer(address _to, uint256[] _tokenIds) public onlyGameManager {
1079         require(isBatchSupported);
1080         require (_tokenIds.length > 0);
1081         
1082         for(uint i = 0; i < _tokenIds.length; i++){
1083             require(_tokenIds[i] != 0);
1084             nonFungibleContract.transferFrom(address(this), _to, _tokenIds[i]);
1085         }
1086     }
1087 
1088     /**
1089      * @dev        Creates new Seed Team Colelctibles
1090      * @param      _teamId       The team identifier
1091      * @param      _attributes   The attributes
1092      * @param      _mlbPlayerId  The mlb player identifier
1093      */
1094     function createSeedTeam(uint8 _teamId, uint256[9] _attributes, uint256[9] _mlbPlayerId) public onlyGameManager whenNotPaused {
1095         require(_teamId != 0);
1096         
1097         for(uint ii = 0; ii < 9; ii++) {
1098             nonFungibleContract.createSeedCollectible(_teamId, uint8(ii.add(1)), _attributes[ii], address(this), 0, 0, _mlbPlayerId[ii]);
1099         }
1100     }
1101 
1102     /**
1103      * @dev            Cancels an sale that hasn't been won yet. Returns the MLBNFT (ERC721) to original owner.
1104      * @notice         This is a state-modifying function that can be called while the contract is paused.
1105      */
1106     function batchCancelSale(uint256[] _tokenIds) external whenNotPaused {
1107         require(isBatchSupported);
1108         require(_tokenIds.length > 0);
1109 
1110         for(uint ii = 0; ii < _tokenIds.length; ii++){
1111             Sale memory sale = tokenIdToSale[_tokenIds[ii]];
1112             require(_isOnSale(sale));
1113             
1114             address seller = sale.seller;
1115             require(msg.sender == seller);
1116 
1117             _cancelSale(_tokenIds[ii], seller);
1118         }
1119     }
1120 
1121     /**
1122      * @dev        Helps to toggle batch supported flag
1123      * @param      _flag  The flag
1124      */
1125     function updateBatchSupport(bool _flag) public onlyGameManager {
1126         isBatchSupported = _flag;
1127     }
1128 
1129     /**
1130      * @dev        Batching Operation: Creates a new Collectible and creates an auction for it.
1131      * @param      _teamIds            The team identifier
1132      * @param      _posIds            The position identifier
1133      * @param      _attributes        The attributes
1134      * @param      _playerOverrideIds  The player override identifier
1135      * @param      _mlbPlayerIds       The mlb player identifier
1136      * @param      _startPrice         The start price
1137      */
1138     function batchCreateSingleSeedAuction(
1139         uint8[] _teamIds,
1140         uint8[] _posIds,
1141         uint256[] _attributes,
1142         uint256[] _playerOverrideIds,
1143         uint256[] _mlbPlayerIds,
1144         uint256 _startPrice)
1145         public
1146         onlyGameManager
1147         whenNotPaused {
1148 
1149         require (isBatchSupported);
1150 
1151         require (_teamIds.length > 0 &&
1152             _posIds.length > 0 &&
1153             _attributes.length > 0 &&
1154             _playerOverrideIds.length > 0 &&
1155             _mlbPlayerIds.length > 0 );
1156         
1157         // Check to see the NFT address is not 0
1158         require(nonFungibleContract != address(0));
1159         
1160         uint256 nftId;
1161 
1162         require (_startPrice != 0);
1163 
1164         for(uint ii = 0; ii < _mlbPlayerIds.length; ii++){
1165             require(_teamIds[ii] != 0);
1166 
1167             nftId = nonFungibleContract.createSeedCollectible(
1168                         _teamIds[ii],
1169                         _posIds[ii],
1170                         _attributes[ii],
1171                         address(this),
1172                         0,
1173                         _playerOverrideIds[ii],
1174                         _mlbPlayerIds[ii]);
1175 
1176             _createSale(
1177                 nftId,
1178                 _startPrice,
1179                 0,
1180                 SALES_DURATION,
1181                 address(this)
1182             );
1183         }
1184     }
1185 }