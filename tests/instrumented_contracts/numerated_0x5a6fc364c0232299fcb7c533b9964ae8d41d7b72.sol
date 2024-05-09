1 pragma solidity ^0.4.24;
2 
3 pragma solidity ^0.4.24;
4 
5 pragma solidity ^0.4.20;
6 
7 contract CutieCoreInterface
8 {
9     function isCutieCore() pure public returns (bool);
10 
11     function transferFrom(address _from, address _to, uint256 _cutieId) external;
12     function transfer(address _to, uint256 _cutieId) external;
13 
14     function ownerOf(uint256 _cutieId)
15         external
16         view
17         returns (address owner);
18 
19     function getCutie(uint40 _id)
20         external
21         view
22         returns (
23         uint256 genes,
24         uint40 birthTime,
25         uint40 cooldownEndTime,
26         uint40 momId,
27         uint40 dadId,
28         uint16 cooldownIndex,
29         uint16 generation
30     );
31 
32     function getGenes(uint40 _id)
33         public
34         view
35         returns (
36         uint256 genes
37     );
38 
39 
40     function getCooldownEndTime(uint40 _id)
41         public
42         view
43         returns (
44         uint40 cooldownEndTime
45     );
46 
47     function getCooldownIndex(uint40 _id)
48         public
49         view
50         returns (
51         uint16 cooldownIndex
52     );
53 
54 
55     function getGeneration(uint40 _id)
56         public
57         view
58         returns (
59         uint16 generation
60     );
61 
62     function getOptional(uint40 _id)
63         public
64         view
65         returns (
66         uint64 optional
67     );
68 
69 
70     function changeGenes(
71         uint40 _cutieId,
72         uint256 _genes)
73         public;
74 
75     function changeCooldownEndTime(
76         uint40 _cutieId,
77         uint40 _cooldownEndTime)
78         public;
79 
80     function changeCooldownIndex(
81         uint40 _cutieId,
82         uint16 _cooldownIndex)
83         public;
84 
85     function changeOptional(
86         uint40 _cutieId,
87         uint64 _optional)
88         public;
89 
90     function changeGeneration(
91         uint40 _cutieId,
92         uint16 _generation)
93         public;
94 }
95 
96 pragma solidity ^0.4.20;
97 
98 
99 pragma solidity ^0.4.24;
100 
101 
102 /**
103  * @title Ownable
104  * @dev The Ownable contract has an owner address, and provides basic authorization control
105  * functions, this simplifies the implementation of "user permissions".
106  */
107 contract Ownable {
108   address public owner;
109 
110 
111   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
112 
113 
114   /**
115    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
116    * account.
117    */
118   constructor() public {
119     owner = msg.sender;
120   }
121 
122   /**
123    * @dev Throws if called by any account other than the owner.
124    */
125   modifier onlyOwner() {
126     require(msg.sender == owner);
127     _;
128   }
129 
130   /**
131    * @dev Allows the current owner to transfer control of the contract to a newOwner.
132    * @param newOwner The address to transfer ownership to.
133    */
134   function transferOwnership(address newOwner) public onlyOwner {
135     require(newOwner != address(0));
136     emit OwnershipTransferred(owner, newOwner);
137     owner = newOwner;
138   }
139 
140 }
141 
142 
143 
144 /**
145  * @title Pausable
146  * @dev Base contract which allows children to implement an emergency stop mechanism.
147  */
148 contract Pausable is Ownable {
149   event Pause();
150   event Unpause();
151 
152   bool public paused = false;
153 
154 
155   /**
156    * @dev Modifier to make a function callable only when the contract is not paused.
157    */
158   modifier whenNotPaused() {
159     require(!paused);
160     _;
161   }
162 
163   /**
164    * @dev Modifier to make a function callable only when the contract is paused.
165    */
166   modifier whenPaused() {
167     require(paused);
168     _;
169   }
170 
171   /**
172    * @dev called by the owner to pause, triggers stopped state
173    */
174   function pause() onlyOwner whenNotPaused public {
175     paused = true;
176     emit Pause();
177   }
178 
179   /**
180    * @dev called by the owner to unpause, returns to normal state
181    */
182   function unpause() onlyOwner whenPaused public {
183     paused = false;
184     emit Unpause();
185   }
186 }
187 
188 pragma solidity ^0.4.24;
189 
190 /// @title Auction Market for Blockchain Cuties.
191 /// @author https://BlockChainArchitect.io
192 contract MarketInterface 
193 {
194     function withdrawEthFromBalance() external;    
195 
196     function createAuction(uint40 _cutieId, uint128 _startPrice, uint128 _endPrice, uint40 _duration, address _seller) public payable;
197 
198     function bid(uint40 _cutieId) public payable;
199 
200     function cancelActiveAuctionWhenPaused(uint40 _cutieId) public;
201 
202 	function getAuctionInfo(uint40 _cutieId)
203         public
204         view
205         returns
206     (
207         address seller,
208         uint128 startPrice,
209         uint128 endPrice,
210         uint40 duration,
211         uint40 startedAt,
212         uint128 featuringFee,
213         bool tokensAllowed
214     );
215 }
216 
217 pragma solidity ^0.4.24;
218 
219 // https://etherscan.io/address/0x4118d7f757ad5893b8fa2f95e067994e1f531371#code
220 interface ERC20 {
221 	
222 	 /**
223      * Transfer tokens from other address
224      *
225      * Send `_value` tokens to `_to` on behalf of `_from`
226      *
227      * @param _from The address of the sender
228      * @param _to The address of the recipient
229      * @param _value the amount to send
230      */
231 	function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
232 
233 	function approveAndCall(address _spender, uint256 _value, bytes _extraData) external
234         returns (bool success);
235 
236 	/**
237 	 * Transfer tokens
238 	 *
239 	 * Send `_value` tokens to `_to` from your account
240 	 *
241 	 * @param _to The address of the recipient
242 	 * @param _value the amount to send
243 	 */
244 	function transfer(address _to, uint256 _value) external;
245 
246     /// @notice Count all tokens assigned to an owner
247     function balanceOf(address _owner) external view returns (uint256);
248 }
249 
250 pragma solidity ^0.4.24;
251 
252 // https://etherscan.io/address/0x3127be52acba38beab6b4b3a406dc04e557c037c#code
253 contract PriceOracleInterface {
254 
255     // How much TOKENs you get for 1 ETH, multiplied by 10^18
256     uint256 public ETHPrice;
257 }
258 
259 pragma solidity ^0.4.24;
260 
261 interface TokenRecipientInterface
262 {
263         function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
264 }
265 
266 
267 /// @title Auction Market for Blockchain Cuties.
268 /// @author https://BlockChainArchitect.io
269 contract Market is MarketInterface, Pausable, TokenRecipientInterface
270 {
271     // Shows the auction on an Cutie Token
272     struct Auction {
273         // Price (in wei or tokens) at the beginning of auction
274         uint128 startPrice;
275         // Price (in wei or tokens) at the end of auction
276         uint128 endPrice;
277         // Current owner of Token
278         address seller;
279         // Auction duration in seconds
280         uint40 duration;
281         // Time when auction started
282         // NOTE: 0 if this auction has been concluded
283         uint40 startedAt;
284         // Featuring fee (in wei, optional)
285         uint128 featuringFee;
286         // is it allowed to bid with erc20 tokens
287         bool tokensAllowed;
288     }
289 
290     // Reference to contract that tracks ownership
291     CutieCoreInterface public coreContract;
292 
293     // Cut owner takes on each auction, in basis points - 1/100 of a per cent.
294     // Values 0-10,000 map to 0%-100%
295     uint16 public ownerFee;
296 
297     // Map from token ID to their corresponding auction.
298     mapping (uint40 => Auction) public cutieIdToAuction;
299     mapping (address => PriceOracleInterface) public priceOracle;
300 
301 
302     address operatorAddress;
303 
304     event AuctionCreated(uint40 indexed cutieId, uint128 startPrice, uint128 endPrice, uint40 duration, uint128 fee, bool tokensAllowed);
305     event AuctionSuccessful(uint40 indexed cutieId, uint128 totalPriceWei, address indexed winner);
306     event AuctionSuccessfulForToken(uint40 indexed cutieId, uint128 totalPriceWei, address indexed winner, uint128 priceInTokens, address indexed token);
307     event AuctionCancelled(uint40 indexed cutieId);
308 
309     modifier onlyOperator() {
310         require(msg.sender == operatorAddress || msg.sender == owner);
311         _;
312     }
313 
314     function setOperator(address _newOperator) public onlyOwner {
315         require(_newOperator != address(0));
316 
317         operatorAddress = _newOperator;
318     }
319 
320     /// @dev disables sending fund to this contract
321     function() external {}
322 
323     modifier canBeStoredIn128Bits(uint256 _value) 
324     {
325         require(_value <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
326         _;
327     }
328 
329     // @dev Adds to the list of open auctions and fires the
330     //  AuctionCreated event.
331     // @param _cutieId The token ID is to be put on auction.
332     // @param _auction To add an auction.
333     // @param _fee Amount of money to feature auction
334     function _addAuction(uint40 _cutieId, Auction _auction) internal
335     {
336         // Require that all auctions have a duration of
337         // at least one minute. (Keeps our math from getting hairy!)
338         require(_auction.duration >= 1 minutes);
339 
340         cutieIdToAuction[_cutieId] = _auction;
341         
342         emit AuctionCreated(
343             _cutieId,
344             _auction.startPrice,
345             _auction.endPrice,
346             _auction.duration,
347             _auction.featuringFee,
348             _auction.tokensAllowed
349         );
350     }
351 
352     // @dev Returns true if the token is claimed by the claimant.
353     // @param _claimant - Address claiming to own the token.
354     function _isOwner(address _claimant, uint256 _cutieId) internal view returns (bool)
355     {
356         return (coreContract.ownerOf(_cutieId) == _claimant);
357     }
358 
359     // @dev Transfers the token owned by this contract to another address.
360     // Returns true when the transfer succeeds.
361     // @param _receiver - Address to transfer token to.
362     // @param _cutieId - Token ID to transfer.
363     function _transfer(address _receiver, uint40 _cutieId) internal
364     {
365         // it will throw if transfer fails
366         coreContract.transfer(_receiver, _cutieId);
367     }
368 
369     // @dev Escrows the token and assigns ownership to this contract.
370     // Throws if the escrow fails.
371     // @param _owner - Current owner address of token to escrow.
372     // @param _cutieId - Token ID the approval of which is to be verified.
373     function _escrow(address _owner, uint40 _cutieId) internal
374     {
375         // it will throw if transfer fails
376         coreContract.transferFrom(_owner, this, _cutieId);
377     }
378 
379     // @dev just cancel auction.
380     function _cancelActiveAuction(uint40 _cutieId, address _seller) internal
381     {
382         _removeAuction(_cutieId);
383         _transfer(_seller, _cutieId);
384         emit AuctionCancelled(_cutieId);
385     }
386 
387     // @dev Calculates the price and transfers winnings.
388     // Does not transfer token ownership.
389     function _bid(uint40 _cutieId, uint128 _bidAmount)
390         internal
391         returns (uint128)
392     {
393         // Get a reference to the auction struct
394         Auction storage auction = cutieIdToAuction[_cutieId];
395 
396         require(_isOnAuction(auction));
397 
398         // Check that bid > current price
399         uint128 price = _currentPrice(auction);
400         require(_bidAmount >= price);
401 
402         // Provide a reference to the seller before the auction struct is deleted.
403         address seller = auction.seller;
404 
405         _removeAuction(_cutieId);
406 
407         // Transfer proceeds to seller (if there are any!)
408         if (price > 0) {
409             uint128 fee = _computeFee(price);
410             uint128 sellerValue = price - fee;
411 
412             seller.transfer(sellerValue);
413         }
414 
415         emit AuctionSuccessful(_cutieId, price, msg.sender);
416 
417         return price;
418     }
419 
420     // @dev Removes from the list of open auctions.
421     // @param _cutieId - ID of token on auction.
422     function _removeAuction(uint40 _cutieId) internal
423     {
424         delete cutieIdToAuction[_cutieId];
425     }
426 
427     // @dev Returns true if the token is on auction.
428     // @param _auction - Auction to check.
429     function _isOnAuction(Auction storage _auction) internal view returns (bool)
430     {
431         return (_auction.startedAt > 0);
432     }
433 
434     // @dev calculate current price of auction. 
435     //  When testing, make this function public and turn on
436     //  `Current price calculation` test suite.
437     function _computeCurrentPrice(
438         uint128 _startPrice,
439         uint128 _endPrice,
440         uint40 _duration,
441         uint40 _secondsPassed
442     )
443         internal
444         pure
445         returns (uint128)
446     {
447         if (_secondsPassed >= _duration) {
448             return _endPrice;
449         } else {
450             int256 totalPriceChange = int256(_endPrice) - int256(_startPrice);
451             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
452             uint128 currentPrice = _startPrice + uint128(currentPriceChange);
453             
454             return currentPrice;
455         }
456     }
457     // @dev return current price of token.
458     function _currentPrice(Auction storage _auction)
459         internal
460         view
461         returns (uint128)
462     {
463         uint40 secondsPassed = 0;
464 
465         uint40 timeNow = uint40(now);
466         if (timeNow > _auction.startedAt) {
467             secondsPassed = timeNow - _auction.startedAt;
468         }
469 
470         return _computeCurrentPrice(
471             _auction.startPrice,
472             _auction.endPrice,
473             _auction.duration,
474             secondsPassed
475         );
476     }
477 
478     // @dev Calculates owner's cut of a sale.
479     // @param _price - Sale price of cutie.
480     function _computeFee(uint128 _price) internal view returns (uint128)
481     {
482         return _price * ownerFee / 10000;
483     }
484 
485     // @dev Remove all Ether from the contract with the owner's cuts. Also, remove any Ether sent directly to the contract address.
486     //  Transfers to the token contract, but can be called by
487     //  the owner or the token contract.
488     function withdrawEthFromBalance() external
489     {
490         address coreAddress = address(coreContract);
491 
492         require(
493             msg.sender == owner ||
494             msg.sender == coreAddress
495         );
496         coreAddress.transfer(address(this).balance);
497     }
498 
499     // @dev create and begin new auction.
500     function createAuction(uint40 _cutieId, uint128 _startPrice, uint128 _endPrice, uint40 _duration, address _seller)
501         public whenNotPaused payable
502     {
503         require(_isOwner(msg.sender, _cutieId));
504         _escrow(msg.sender, _cutieId);
505 
506         bool allowTokens = _duration < 0x8000000000; // first bit of duration is boolean flag (1 to disable tokens)
507         _duration = _duration % 0x8000000000; // clear flag from duration
508 
509         Auction memory auction = Auction(
510             _startPrice,
511             _endPrice,
512             _seller,
513             _duration,
514             uint40(now),
515             uint128(msg.value),
516             allowTokens
517         );
518         _addAuction(_cutieId, auction);
519     }
520 
521     // @dev Set the reference to cutie ownership contract. Verify the owner's fee.
522     //  @param fee should be between 0-10,000.
523     function setup(address _coreContractAddress, uint16 _fee) public onlyOwner
524     {
525         require(_fee <= 10000);
526 
527         ownerFee = _fee;
528         
529         CutieCoreInterface candidateContract = CutieCoreInterface(_coreContractAddress);
530         require(candidateContract.isCutieCore());
531         coreContract = candidateContract;
532     }
533 
534     // @dev Set the owner's fee.
535     //  @param fee should be between 0-10,000.
536     function setFee(uint16 _fee) public onlyOwner
537     {
538         require(_fee <= 10000);
539 
540         ownerFee = _fee;
541     }
542 
543     // @dev bid on auction. Complete it and transfer ownership of cutie if enough ether was given.
544     function bid(uint40 _cutieId) public payable whenNotPaused canBeStoredIn128Bits(msg.value)
545     {
546         // _bid throws if something failed.
547         _bid(_cutieId, uint128(msg.value));
548         _transfer(msg.sender, _cutieId);
549     }
550 
551     function getPriceInToken(ERC20 _tokenContract, uint128 priceWei)
552         public
553         view
554         returns (uint128)
555     {
556         PriceOracleInterface oracle = priceOracle[address(_tokenContract)];
557         require(address(oracle) != address(0));
558 
559         uint256 ethPerToken = oracle.ETHPrice();
560         return uint128(uint256(priceWei) * ethPerToken / 1 ether);
561     }
562 
563     function getCutieId(bytes _extraData) pure internal returns (uint40)
564     {
565         return
566             uint40(_extraData[0]) +
567             uint40(_extraData[1]) * 0x100 +
568             uint40(_extraData[2]) * 0x10000 +
569             uint40(_extraData[3]) * 0x100000 +
570             uint40(_extraData[4]) * 0x10000000;
571     }
572 
573     // https://github.com/BitGuildPlatform/Documentation/blob/master/README.md#2-required-game-smart-contract-changes
574     // Function that is called when trying to use PLAT for payments from approveAndCall
575     function receiveApproval(address _sender, uint256 _value, address _tokenContract, bytes _extraData)
576         external
577         canBeStoredIn128Bits(_value)
578         whenNotPaused
579     {
580         ERC20 tokenContract = ERC20(_tokenContract);
581 
582         require(_extraData.length == 5); // 40 bits
583         uint40 cutieId = getCutieId(_extraData);
584 
585         // Get a reference to the auction struct
586         Auction storage auction = cutieIdToAuction[cutieId];
587         require(auction.tokensAllowed); // buy for token is allowed
588 
589         require(_isOnAuction(auction));
590 
591         uint128 priceWei = _currentPrice(auction);
592 
593         uint128 priceInTokens = getPriceInToken(tokenContract, priceWei);
594 
595         // Check that bid > current price
596         //require(_value >= priceInTokens);
597 
598         // Provide a reference to the seller before the auction struct is deleted.
599         address seller = auction.seller;
600 
601         _removeAuction(cutieId);
602 
603         require(tokenContract.transferFrom(_sender, address(this), priceInTokens));
604 
605         if (seller != address(coreContract))
606         {
607             uint128 fee = _computeFee(priceInTokens);
608             uint128 sellerValue = priceInTokens - fee;
609 
610             tokenContract.transfer(seller, sellerValue);
611         }
612 
613         emit AuctionSuccessfulForToken(cutieId, priceWei, _sender, priceInTokens, _tokenContract);
614         _transfer(_sender, cutieId);
615     }
616 
617     // @dev Returns auction info for a token on auction.
618     // @param _cutieId - ID of token on auction.
619     function getAuctionInfo(uint40 _cutieId)
620         public
621         view
622         returns
623     (
624         address seller,
625         uint128 startPrice,
626         uint128 endPrice,
627         uint40 duration,
628         uint40 startedAt,
629         uint128 featuringFee,
630         bool tokensAllowed
631     ) {
632         Auction storage auction = cutieIdToAuction[_cutieId];
633         require(_isOnAuction(auction));
634         return (
635             auction.seller,
636             auction.startPrice,
637             auction.endPrice,
638             auction.duration,
639             auction.startedAt,
640             auction.featuringFee,
641             auction.tokensAllowed
642         );
643     }
644 
645     // @dev Returns auction info for a token on auction.
646     // @param _cutieId - ID of token on auction.
647     function isOnAuction(uint40 _cutieId)
648         public
649         view
650         returns (bool) 
651     {
652         return cutieIdToAuction[_cutieId].startedAt > 0;
653     }
654 
655 /*
656     /// @dev Import cuties from previous version of Core contract.
657     /// @param _oldAddress Old core contract address
658     /// @param _fromIndex (inclusive)
659     /// @param _toIndex (inclusive)
660     function migrate(address _oldAddress, uint40 _fromIndex, uint40 _toIndex) public onlyOwner whenPaused
661     {
662         Market old = Market(_oldAddress);
663 
664         for (uint40 i = _fromIndex; i <= _toIndex; i++)
665         {
666             if (coreContract.ownerOf(i) == _oldAddress)
667             {
668                 address seller;
669                 uint128 startPrice;
670                 uint128 endPrice;
671                 uint40 duration;
672                 uint40 startedAt;
673                 uint128 featuringFee;   
674                 (seller, startPrice, endPrice, duration, startedAt, featuringFee) = old.getAuctionInfo(i);
675 
676                 Auction memory auction = Auction({
677                     seller: seller, 
678                     startPrice: startPrice, 
679                     endPrice: endPrice, 
680                     duration: duration, 
681                     startedAt: startedAt, 
682                     featuringFee: featuringFee
683                 });
684                 _addAuction(i, auction);
685             }
686         }
687     }*/
688 
689     // @dev Returns the current price of an auction.
690     function getCurrentPrice(uint40 _cutieId)
691         public
692         view
693         returns (uint128)
694     {
695         Auction storage auction = cutieIdToAuction[_cutieId];
696         require(_isOnAuction(auction));
697         return _currentPrice(auction);
698     }
699 
700     // @dev Cancels unfinished auction and returns token to owner. 
701     // Can be called when contract is paused.
702     function cancelActiveAuction(uint40 _cutieId) public
703     {
704         Auction storage auction = cutieIdToAuction[_cutieId];
705         require(_isOnAuction(auction));
706         address seller = auction.seller;
707         require(msg.sender == seller);
708         _cancelActiveAuction(_cutieId, seller);
709     }
710 
711     // @dev Cancels auction when contract is on pause. Option is available only to owners in urgent situations. Tokens returned to seller.
712     //  Used on Core contract upgrade.
713     function cancelActiveAuctionWhenPaused(uint40 _cutieId) whenPaused onlyOwner public
714     {
715         Auction storage auction = cutieIdToAuction[_cutieId];
716         require(_isOnAuction(auction));
717         _cancelActiveAuction(_cutieId, auction.seller);
718     }
719 
720         // @dev Cancels unfinished auction and returns token to owner. 
721     // Can be called when contract is paused.
722     function cancelCreatorAuction(uint40 _cutieId) public onlyOperator
723     {
724         Auction storage auction = cutieIdToAuction[_cutieId];
725         require(_isOnAuction(auction));
726         address seller = auction.seller;
727         require(seller == address(coreContract));
728         _cancelActiveAuction(_cutieId, msg.sender);
729     }
730 
731     // @dev Transfers to _withdrawToAddress all tokens controlled by
732     // contract _tokenContract.
733     function withdrawTokenFromBalance(ERC20 _tokenContract, address _withdrawToAddress) external
734     {
735         address coreAddress = address(coreContract);
736 
737         require(
738             msg.sender == owner ||
739             msg.sender == operatorAddress ||
740             msg.sender == coreAddress
741         );
742         uint256 balance = _tokenContract.balanceOf(address(this));
743         _tokenContract.transfer(_withdrawToAddress, balance);
744     }
745 
746     /// @dev Allow buy cuties for token
747     function addToken(ERC20 _tokenContract, PriceOracleInterface _priceOracle) external onlyOwner
748     {
749         priceOracle[address(_tokenContract)] = _priceOracle;
750     }
751 
752     /// @dev Disallow buy cuties for token
753     function removeToken(ERC20 _tokenContract) external onlyOwner
754     {
755         delete priceOracle[address(_tokenContract)];
756     }
757 }
758 
759 
760 /// @title Auction market for cuties sale 
761 /// @author https://BlockChainArchitect.io
762 contract SaleMarket is Market
763 {
764     // @dev Sanity check reveals that the
765     //  auction in our setSaleAuctionAddress() call is right.
766     bool public isSaleMarket = true;
767     
768 
769     // @dev create and start a new auction
770     // @param _cutieId - ID of cutie to auction, sender must be owner.
771     // @param _startPrice - Price of item (in wei) at the beginning of auction.
772     // @param _endPrice - Price of item (in wei) at the end of auction.
773     // @param _duration - Length of auction (in seconds).
774     // @param _seller - Seller
775     function createAuction(
776         uint40 _cutieId,
777         uint128 _startPrice,
778         uint128 _endPrice,
779         uint40 _duration,
780         address _seller
781     )
782         public
783         payable
784     {
785         require(msg.sender == address(coreContract));
786         _escrow(_seller, _cutieId);
787 
788         bool allowTokens = _duration < 0x8000000000; // first bit of duration is boolean flag (1 to disable tokens)
789         _duration = _duration % 0x8000000000; // clear flag from duration
790 
791         Auction memory auction = Auction(
792             _startPrice,
793             _endPrice,
794             _seller,
795             _duration,
796             uint40(now),
797             uint128(msg.value),
798             allowTokens
799         );
800         _addAuction(_cutieId, auction);
801     }
802 
803     // @dev LastSalePrice is updated if seller is the token contract.
804     // Otherwise, default bid method is used.
805     function bid(uint40 _cutieId)
806         public
807         payable
808         canBeStoredIn128Bits(msg.value)
809     {
810         // _bid verifies token ID size
811         _bid(_cutieId, uint128(msg.value));
812         _transfer(msg.sender, _cutieId);
813     }
814 }