1 pragma solidity ^0.4.24;
2 
3 contract CutieCoreInterface
4 {
5     function isCutieCore() pure public returns (bool);
6 
7     function transferFrom(address _from, address _to, uint256 _cutieId) external;
8     function transfer(address _to, uint256 _cutieId) external;
9 
10     function ownerOf(uint256 _cutieId)
11         external
12         view
13         returns (address owner);
14 
15     function getCutie(uint40 _id)
16         external
17         view
18         returns (
19         uint256 genes,
20         uint40 birthTime,
21         uint40 cooldownEndTime,
22         uint40 momId,
23         uint40 dadId,
24         uint16 cooldownIndex,
25         uint16 generation
26     );
27 
28     function getGenes(uint40 _id)
29         public
30         view
31         returns (
32         uint256 genes
33     );
34 
35 
36     function getCooldownEndTime(uint40 _id)
37         public
38         view
39         returns (
40         uint40 cooldownEndTime
41     );
42 
43     function getCooldownIndex(uint40 _id)
44         public
45         view
46         returns (
47         uint16 cooldownIndex
48     );
49 
50 
51     function getGeneration(uint40 _id)
52         public
53         view
54         returns (
55         uint16 generation
56     );
57 
58     function getOptional(uint40 _id)
59         public
60         view
61         returns (
62         uint64 optional
63     );
64 
65 
66     function changeGenes(
67         uint40 _cutieId,
68         uint256 _genes)
69         public;
70 
71     function changeCooldownEndTime(
72         uint40 _cutieId,
73         uint40 _cooldownEndTime)
74         public;
75 
76     function changeCooldownIndex(
77         uint40 _cutieId,
78         uint16 _cooldownIndex)
79         public;
80 
81     function changeOptional(
82         uint40 _cutieId,
83         uint64 _optional)
84         public;
85 
86     function changeGeneration(
87         uint40 _cutieId,
88         uint16 _generation)
89         public;
90 }
91 
92 pragma solidity ^0.4.20;
93 
94 
95 pragma solidity ^0.4.24;
96 
97 
98 /**
99  * @title Ownable
100  * @dev The Ownable contract has an owner address, and provides basic authorization control
101  * functions, this simplifies the implementation of "user permissions".
102  */
103 contract Ownable {
104   address public owner;
105 
106 
107   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
108 
109 
110   /**
111    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
112    * account.
113    */
114   constructor() public {
115     owner = msg.sender;
116   }
117 
118   /**
119    * @dev Throws if called by any account other than the owner.
120    */
121   modifier onlyOwner() {
122     require(msg.sender == owner);
123     _;
124   }
125 
126   /**
127    * @dev Allows the current owner to transfer control of the contract to a newOwner.
128    * @param newOwner The address to transfer ownership to.
129    */
130   function transferOwnership(address newOwner) public onlyOwner {
131     require(newOwner != address(0));
132     emit OwnershipTransferred(owner, newOwner);
133     owner = newOwner;
134   }
135 
136 }
137 
138 
139 
140 /**
141  * @title Pausable
142  * @dev Base contract which allows children to implement an emergency stop mechanism.
143  */
144 contract Pausable is Ownable {
145   event Pause();
146   event Unpause();
147 
148   bool public paused = false;
149 
150 
151   /**
152    * @dev Modifier to make a function callable only when the contract is not paused.
153    */
154   modifier whenNotPaused() {
155     require(!paused);
156     _;
157   }
158 
159   /**
160    * @dev Modifier to make a function callable only when the contract is paused.
161    */
162   modifier whenPaused() {
163     require(paused);
164     _;
165   }
166 
167   /**
168    * @dev called by the owner to pause, triggers stopped state
169    */
170   function pause() onlyOwner whenNotPaused public {
171     paused = true;
172     emit Pause();
173   }
174 
175   /**
176    * @dev called by the owner to unpause, returns to normal state
177    */
178   function unpause() onlyOwner whenPaused public {
179     paused = false;
180     emit Unpause();
181   }
182 }
183 
184 pragma solidity ^0.4.24;
185 
186 /// @title Auction Market for Blockchain Cuties.
187 /// @author https://BlockChainArchitect.io
188 contract MarketInterface 
189 {
190     function withdrawEthFromBalance() external;    
191 
192     function createAuction(uint40 _cutieId, uint128 _startPrice, uint128 _endPrice, uint40 _duration, address _seller) public payable;
193 
194     function bid(uint40 _cutieId) public payable;
195 
196     function cancelActiveAuctionWhenPaused(uint40 _cutieId) public;
197 
198 	function getAuctionInfo(uint40 _cutieId)
199         public
200         view
201         returns
202     (
203         address seller,
204         uint128 startPrice,
205         uint128 endPrice,
206         uint40 duration,
207         uint40 startedAt,
208         uint128 featuringFee,
209         bool tokensAllowed
210     );
211 }
212 
213 pragma solidity ^0.4.24;
214 
215 // https://etherscan.io/address/0x4118d7f757ad5893b8fa2f95e067994e1f531371#code
216 interface ERC20 {
217 	
218 	 /**
219      * Transfer tokens from other address
220      *
221      * Send `_value` tokens to `_to` on behalf of `_from`
222      *
223      * @param _from The address of the sender
224      * @param _to The address of the recipient
225      * @param _value the amount to send
226      */
227 	function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
228 
229 	function approveAndCall(address _spender, uint256 _value, bytes _extraData) external
230         returns (bool success);
231 
232 	/**
233 	 * Transfer tokens
234 	 *
235 	 * Send `_value` tokens to `_to` from your account
236 	 *
237 	 * @param _to The address of the recipient
238 	 * @param _value the amount to send
239 	 */
240 	function transfer(address _to, uint256 _value) external;
241 
242     /// @notice Count all tokens assigned to an owner
243     function balanceOf(address _owner) external view returns (uint256);
244 }
245 
246 pragma solidity ^0.4.24;
247 
248 // https://etherscan.io/address/0x3127be52acba38beab6b4b3a406dc04e557c037c#code
249 contract PriceOracleInterface {
250 
251     // How much TOKENs you get for 1 ETH, multiplied by 10^18
252     uint256 public ETHPrice;
253 }
254 
255 pragma solidity ^0.4.24;
256 
257 interface TokenRecipientInterface
258 {
259         function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
260 }
261 
262 
263 /// @title Auction Market for Blockchain Cuties.
264 /// @author https://BlockChainArchitect.io
265 contract Market is MarketInterface, Pausable, TokenRecipientInterface
266 {
267     // Shows the auction on an Cutie Token
268     struct Auction {
269         // Price (in wei or tokens) at the beginning of auction
270         uint128 startPrice;
271         // Price (in wei or tokens) at the end of auction
272         uint128 endPrice;
273         // Current owner of Token
274         address seller;
275         // Auction duration in seconds
276         uint40 duration;
277         // Time when auction started
278         // NOTE: 0 if this auction has been concluded
279         uint40 startedAt;
280         // Featuring fee (in wei, optional)
281         uint128 featuringFee;
282         // is it allowed to bid with erc20 tokens
283         bool tokensAllowed;
284     }
285 
286     // Reference to contract that tracks ownership
287     CutieCoreInterface public coreContract;
288 
289     // Cut owner takes on each auction, in basis points - 1/100 of a per cent.
290     // Values 0-10,000 map to 0%-100%
291     uint16 public ownerFee;
292 
293     // Map from token ID to their corresponding auction.
294     mapping (uint40 => Auction) public cutieIdToAuction;
295     mapping (address => PriceOracleInterface) public priceOracle;
296 
297 
298     address operatorAddress;
299 
300     event AuctionCreated(uint40 indexed cutieId, uint128 startPrice, uint128 endPrice, uint40 duration, uint128 fee, bool tokensAllowed);
301     event AuctionSuccessful(uint40 indexed cutieId, uint128 totalPriceWei, address indexed winner);
302     event AuctionSuccessfulForToken(uint40 indexed cutieId, uint128 totalPriceWei, address indexed winner, uint128 priceInTokens, address indexed token);
303     event AuctionCancelled(uint40 indexed cutieId);
304 
305     modifier onlyOperator() {
306         require(msg.sender == operatorAddress || msg.sender == owner);
307         _;
308     }
309 
310     function setOperator(address _newOperator) public onlyOwner {
311         require(_newOperator != address(0));
312 
313         operatorAddress = _newOperator;
314     }
315 
316     /// @dev disables sending fund to this contract
317     function() external {}
318 
319     modifier canBeStoredIn128Bits(uint256 _value) 
320     {
321         require(_value <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
322         _;
323     }
324 
325     // @dev Adds to the list of open auctions and fires the
326     //  AuctionCreated event.
327     // @param _cutieId The token ID is to be put on auction.
328     // @param _auction To add an auction.
329     // @param _fee Amount of money to feature auction
330     function _addAuction(uint40 _cutieId, Auction _auction) internal
331     {
332         // Require that all auctions have a duration of
333         // at least one minute. (Keeps our math from getting hairy!)
334         require(_auction.duration >= 1 minutes);
335 
336         cutieIdToAuction[_cutieId] = _auction;
337         
338         emit AuctionCreated(
339             _cutieId,
340             _auction.startPrice,
341             _auction.endPrice,
342             _auction.duration,
343             _auction.featuringFee,
344             _auction.tokensAllowed
345         );
346     }
347 
348     // @dev Returns true if the token is claimed by the claimant.
349     // @param _claimant - Address claiming to own the token.
350     function _isOwner(address _claimant, uint256 _cutieId) internal view returns (bool)
351     {
352         return (coreContract.ownerOf(_cutieId) == _claimant);
353     }
354 
355     // @dev Transfers the token owned by this contract to another address.
356     // Returns true when the transfer succeeds.
357     // @param _receiver - Address to transfer token to.
358     // @param _cutieId - Token ID to transfer.
359     function _transfer(address _receiver, uint40 _cutieId) internal
360     {
361         // it will throw if transfer fails
362         coreContract.transfer(_receiver, _cutieId);
363     }
364 
365     // @dev Escrows the token and assigns ownership to this contract.
366     // Throws if the escrow fails.
367     // @param _owner - Current owner address of token to escrow.
368     // @param _cutieId - Token ID the approval of which is to be verified.
369     function _escrow(address _owner, uint40 _cutieId) internal
370     {
371         // it will throw if transfer fails
372         coreContract.transferFrom(_owner, this, _cutieId);
373     }
374 
375     // @dev just cancel auction.
376     function _cancelActiveAuction(uint40 _cutieId, address _seller) internal
377     {
378         _removeAuction(_cutieId);
379         _transfer(_seller, _cutieId);
380         emit AuctionCancelled(_cutieId);
381     }
382 
383     // @dev Calculates the price and transfers winnings.
384     // Does not transfer token ownership.
385     function _bid(uint40 _cutieId, uint128 _bidAmount)
386         internal
387         returns (uint128)
388     {
389         // Get a reference to the auction struct
390         Auction storage auction = cutieIdToAuction[_cutieId];
391 
392         require(_isOnAuction(auction));
393 
394         // Check that bid > current price
395         uint128 price = _currentPrice(auction);
396         require(_bidAmount >= price);
397 
398         // Provide a reference to the seller before the auction struct is deleted.
399         address seller = auction.seller;
400 
401         _removeAuction(_cutieId);
402 
403         // Transfer proceeds to seller (if there are any!)
404         if (price > 0 && seller != address(coreContract)) {
405             uint128 fee = _computeFee(price);
406             uint128 sellerValue = price - fee;
407 
408             seller.transfer(sellerValue);
409         }
410 
411         emit AuctionSuccessful(_cutieId, price, msg.sender);
412 
413         return price;
414     }
415 
416     // @dev Removes from the list of open auctions.
417     // @param _cutieId - ID of token on auction.
418     function _removeAuction(uint40 _cutieId) internal
419     {
420         delete cutieIdToAuction[_cutieId];
421     }
422 
423     // @dev Returns true if the token is on auction.
424     // @param _auction - Auction to check.
425     function _isOnAuction(Auction storage _auction) internal view returns (bool)
426     {
427         return (_auction.startedAt > 0);
428     }
429 
430     // @dev calculate current price of auction. 
431     //  When testing, make this function public and turn on
432     //  `Current price calculation` test suite.
433     function _computeCurrentPrice(
434         uint128 _startPrice,
435         uint128 _endPrice,
436         uint40 _duration,
437         uint40 _secondsPassed
438     )
439         internal
440         pure
441         returns (uint128)
442     {
443         if (_secondsPassed >= _duration) {
444             return _endPrice;
445         } else {
446             int256 totalPriceChange = int256(_endPrice) - int256(_startPrice);
447             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
448             uint128 currentPrice = _startPrice + uint128(currentPriceChange);
449             
450             return currentPrice;
451         }
452     }
453     // @dev return current price of token.
454     function _currentPrice(Auction storage _auction)
455         internal
456         view
457         returns (uint128)
458     {
459         uint40 secondsPassed = 0;
460 
461         uint40 timeNow = uint40(now);
462         if (timeNow > _auction.startedAt) {
463             secondsPassed = timeNow - _auction.startedAt;
464         }
465 
466         return _computeCurrentPrice(
467             _auction.startPrice,
468             _auction.endPrice,
469             _auction.duration,
470             secondsPassed
471         );
472     }
473 
474     // @dev Calculates owner's cut of a sale.
475     // @param _price - Sale price of cutie.
476     function _computeFee(uint128 _price) internal view returns (uint128)
477     {
478         return _price * ownerFee / 10000;
479     }
480 
481     // @dev Remove all Ether from the contract with the owner's cuts. Also, remove any Ether sent directly to the contract address.
482     //  Transfers to the token contract, but can be called by
483     //  the owner or the token contract.
484     function withdrawEthFromBalance() external
485     {
486         address coreAddress = address(coreContract);
487 
488         require(
489             msg.sender == owner ||
490             msg.sender == coreAddress
491         );
492         coreAddress.transfer(address(this).balance);
493     }
494 
495     // @dev create and begin new auction.
496     function createAuction(uint40 _cutieId, uint128 _startPrice, uint128 _endPrice, uint40 _duration, address _seller)
497         public whenNotPaused payable
498     {
499         require(_isOwner(msg.sender, _cutieId));
500         _escrow(msg.sender, _cutieId);
501 
502         bool allowTokens = _duration < 0x8000000000; // first bit of duration is boolean flag (1 to disable tokens)
503         _duration = _duration % 0x8000000000; // clear flag from duration
504 
505         Auction memory auction = Auction(
506             _startPrice,
507             _endPrice,
508             _seller,
509             _duration,
510             uint40(now),
511             uint128(msg.value),
512             allowTokens
513         );
514         _addAuction(_cutieId, auction);
515     }
516 
517     // @dev Set the reference to cutie ownership contract. Verify the owner's fee.
518     //  @param fee should be between 0-10,000.
519     function setup(address _coreContractAddress, uint16 _fee) public onlyOwner
520     {
521         require(_fee <= 10000);
522 
523         ownerFee = _fee;
524         
525         CutieCoreInterface candidateContract = CutieCoreInterface(_coreContractAddress);
526         require(candidateContract.isCutieCore());
527         coreContract = candidateContract;
528     }
529 
530     // @dev Set the owner's fee.
531     //  @param fee should be between 0-10,000.
532     function setFee(uint16 _fee) public onlyOwner
533     {
534         require(_fee <= 10000);
535 
536         ownerFee = _fee;
537     }
538 
539     // @dev bid on auction. Complete it and transfer ownership of cutie if enough ether was given.
540     function bid(uint40 _cutieId) public payable whenNotPaused canBeStoredIn128Bits(msg.value)
541     {
542         // _bid throws if something failed.
543         _bid(_cutieId, uint128(msg.value));
544         _transfer(msg.sender, _cutieId);
545     }
546 
547     function getPriceInToken(ERC20 _tokenContract, uint128 priceWei)
548         public
549         view
550         returns (uint128)
551     {
552         PriceOracleInterface oracle = priceOracle[address(_tokenContract)];
553         require(address(oracle) != address(0));
554 
555         uint256 ethPerToken = oracle.ETHPrice();
556         return uint128(uint256(priceWei) * ethPerToken / 1 ether);
557     }
558 
559     function getCutieId(bytes _extraData) internal returns (uint40)
560     {
561         return
562             uint40(_extraData[0]) +
563             uint40(_extraData[1]) * 0x100 +
564             uint40(_extraData[2]) * 0x10000 +
565             uint40(_extraData[3]) * 0x100000 +
566             uint40(_extraData[4]) * 0x10000000;
567     }
568 
569     // https://github.com/BitGuildPlatform/Documentation/blob/master/README.md#2-required-game-smart-contract-changes
570     // Function that is called when trying to use PLAT for payments from approveAndCall
571     function receiveApproval(address _sender, uint256 _value, address _tokenContract, bytes _extraData)
572         external
573         canBeStoredIn128Bits(_value)
574         whenNotPaused
575     {
576         ERC20 tokenContract = ERC20(_tokenContract);
577 
578         require(_extraData.length == 5); // 40 bits
579         uint40 cutieId = getCutieId(_extraData);
580 
581         // Get a reference to the auction struct
582         Auction storage auction = cutieIdToAuction[cutieId];
583         require(auction.tokensAllowed); // buy for token is allowed
584 
585         require(_isOnAuction(auction));
586 
587         uint128 priceWei = _currentPrice(auction);
588 
589         uint128 priceInTokens = getPriceInToken(tokenContract, priceWei);
590 
591         // Check that bid > current price
592         //require(_value >= priceInTokens);
593 
594         // Provide a reference to the seller before the auction struct is deleted.
595         address seller = auction.seller;
596 
597         _removeAuction(cutieId);
598 
599         // Transfer proceeds to seller (if there are any!)
600         if (priceInTokens > 0) {
601             uint128 fee = _computeFee(priceInTokens);
602             uint128 sellerValue = priceInTokens - fee;
603 
604             require(tokenContract.transferFrom(_sender, address(this), priceInTokens));
605             tokenContract.transfer(seller, sellerValue);
606         }
607         emit AuctionSuccessfulForToken(cutieId, priceWei, _sender, priceInTokens, _tokenContract);
608         _transfer(_sender, cutieId);
609     }
610 
611     // @dev Returns auction info for a token on auction.
612     // @param _cutieId - ID of token on auction.
613     function getAuctionInfo(uint40 _cutieId)
614         public
615         view
616         returns
617     (
618         address seller,
619         uint128 startPrice,
620         uint128 endPrice,
621         uint40 duration,
622         uint40 startedAt,
623         uint128 featuringFee,
624         bool tokensAllowed
625     ) {
626         Auction storage auction = cutieIdToAuction[_cutieId];
627         require(_isOnAuction(auction));
628         return (
629             auction.seller,
630             auction.startPrice,
631             auction.endPrice,
632             auction.duration,
633             auction.startedAt,
634             auction.featuringFee,
635             auction.tokensAllowed
636         );
637     }
638 
639     // @dev Returns auction info for a token on auction.
640     // @param _cutieId - ID of token on auction.
641     function isOnAuction(uint40 _cutieId)
642         public
643         view
644         returns (bool) 
645     {
646         return cutieIdToAuction[_cutieId].startedAt > 0;
647     }
648 
649 /*
650     /// @dev Import cuties from previous version of Core contract.
651     /// @param _oldAddress Old core contract address
652     /// @param _fromIndex (inclusive)
653     /// @param _toIndex (inclusive)
654     function migrate(address _oldAddress, uint40 _fromIndex, uint40 _toIndex) public onlyOwner whenPaused
655     {
656         Market old = Market(_oldAddress);
657 
658         for (uint40 i = _fromIndex; i <= _toIndex; i++)
659         {
660             if (coreContract.ownerOf(i) == _oldAddress)
661             {
662                 address seller;
663                 uint128 startPrice;
664                 uint128 endPrice;
665                 uint40 duration;
666                 uint40 startedAt;
667                 uint128 featuringFee;   
668                 (seller, startPrice, endPrice, duration, startedAt, featuringFee) = old.getAuctionInfo(i);
669 
670                 Auction memory auction = Auction({
671                     seller: seller, 
672                     startPrice: startPrice, 
673                     endPrice: endPrice, 
674                     duration: duration, 
675                     startedAt: startedAt, 
676                     featuringFee: featuringFee
677                 });
678                 _addAuction(i, auction);
679             }
680         }
681     }*/
682 
683     // @dev Returns the current price of an auction.
684     function getCurrentPrice(uint40 _cutieId)
685         public
686         view
687         returns (uint128)
688     {
689         Auction storage auction = cutieIdToAuction[_cutieId];
690         require(_isOnAuction(auction));
691         return _currentPrice(auction);
692     }
693 
694     // @dev Cancels unfinished auction and returns token to owner. 
695     // Can be called when contract is paused.
696     function cancelActiveAuction(uint40 _cutieId) public
697     {
698         Auction storage auction = cutieIdToAuction[_cutieId];
699         require(_isOnAuction(auction));
700         address seller = auction.seller;
701         require(msg.sender == seller);
702         _cancelActiveAuction(_cutieId, seller);
703     }
704 
705     // @dev Cancels auction when contract is on pause. Option is available only to owners in urgent situations. Tokens returned to seller.
706     //  Used on Core contract upgrade.
707     function cancelActiveAuctionWhenPaused(uint40 _cutieId) whenPaused onlyOwner public
708     {
709         Auction storage auction = cutieIdToAuction[_cutieId];
710         require(_isOnAuction(auction));
711         _cancelActiveAuction(_cutieId, auction.seller);
712     }
713 
714         // @dev Cancels unfinished auction and returns token to owner. 
715     // Can be called when contract is paused.
716     function cancelCreatorAuction(uint40 _cutieId) public onlyOperator
717     {
718         Auction storage auction = cutieIdToAuction[_cutieId];
719         require(_isOnAuction(auction));
720         address seller = auction.seller;
721         require(seller == address(coreContract));
722         _cancelActiveAuction(_cutieId, msg.sender);
723     }
724 
725     // @dev Transfers to _withdrawToAddress all tokens controlled by
726     // contract _tokenContract.
727     function withdrawTokenFromBalance(ERC20 _tokenContract, address _withdrawToAddress) external
728     {
729         address coreAddress = address(coreContract);
730 
731         require(
732             msg.sender == owner ||
733             msg.sender == operatorAddress ||
734             msg.sender == coreAddress
735         );
736         uint256 balance = _tokenContract.balanceOf(address(this));
737         _tokenContract.transfer(_withdrawToAddress, balance);
738     }
739 
740     /// @dev Allow buy cuties for token
741     function addToken(ERC20 _tokenContract, PriceOracleInterface _priceOracle) external onlyOwner
742     {
743         priceOracle[address(_tokenContract)] = _priceOracle;
744     }
745 
746     /// @dev Disallow buy cuties for token
747     function removeToken(ERC20 _tokenContract) external onlyOwner
748     {
749         delete priceOracle[address(_tokenContract)];
750     }
751 }
752 
753 
754 /// @title Auction market for cuties sale 
755 /// @author https://BlockChainArchitect.io
756 contract SaleMarket is Market
757 {
758     // @dev Sanity check reveals that the
759     //  auction in our setSaleAuctionAddress() call is right.
760     bool public isSaleMarket = true;
761     
762 
763     // @dev create and start a new auction
764     // @param _cutieId - ID of cutie to auction, sender must be owner.
765     // @param _startPrice - Price of item (in wei) at the beginning of auction.
766     // @param _endPrice - Price of item (in wei) at the end of auction.
767     // @param _duration - Length of auction (in seconds).
768     // @param _seller - Seller
769     function createAuction(
770         uint40 _cutieId,
771         uint128 _startPrice,
772         uint128 _endPrice,
773         uint40 _duration,
774         address _seller
775     )
776         public
777         payable
778     {
779         require(msg.sender == address(coreContract));
780         _escrow(_seller, _cutieId);
781 
782         bool allowTokens = _duration < 0x8000000000; // first bit of duration is boolean flag (1 to disable tokens)
783         _duration = _duration % 0x8000000000; // clear flag from duration
784 
785         Auction memory auction = Auction(
786             _startPrice,
787             _endPrice,
788             _seller,
789             _duration,
790             uint40(now),
791             uint128(msg.value),
792             allowTokens
793         );
794         _addAuction(_cutieId, auction);
795     }
796 
797     // @dev LastSalePrice is updated if seller is the token contract.
798     // Otherwise, default bid method is used.
799     function bid(uint40 _cutieId)
800         public
801         payable
802         canBeStoredIn128Bits(msg.value)
803     {
804         // _bid verifies token ID size
805         _bid(_cutieId, uint128(msg.value));
806         _transfer(msg.sender, _cutieId);
807     }
808 }