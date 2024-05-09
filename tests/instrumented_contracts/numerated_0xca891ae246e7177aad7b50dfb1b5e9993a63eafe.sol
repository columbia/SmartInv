1 pragma solidity ^0.4.24;
2 
3 
4 contract CutieCoreInterface
5 {
6     function isCutieCore() pure public returns (bool);
7 
8     function transferFrom(address _from, address _to, uint256 _cutieId) external;
9     function transfer(address _to, uint256 _cutieId) external;
10 
11     function ownerOf(uint256 _cutieId)
12         external
13         view
14         returns (address owner);
15 
16     function getCutie(uint40 _id)
17         external
18         view
19         returns (
20         uint256 genes,
21         uint40 birthTime,
22         uint40 cooldownEndTime,
23         uint40 momId,
24         uint40 dadId,
25         uint16 cooldownIndex,
26         uint16 generation
27     );
28 
29     function getGenes(uint40 _id)
30         public
31         view
32         returns (
33         uint256 genes
34     );
35 
36 
37     function getCooldownEndTime(uint40 _id)
38         public
39         view
40         returns (
41         uint40 cooldownEndTime
42     );
43 
44     function getCooldownIndex(uint40 _id)
45         public
46         view
47         returns (
48         uint16 cooldownIndex
49     );
50 
51 
52     function getGeneration(uint40 _id)
53         public
54         view
55         returns (
56         uint16 generation
57     );
58 
59     function getOptional(uint40 _id)
60         public
61         view
62         returns (
63         uint64 optional
64     );
65 
66 
67     function changeGenes(
68         uint40 _cutieId,
69         uint256 _genes)
70         public;
71 
72     function changeCooldownEndTime(
73         uint40 _cutieId,
74         uint40 _cooldownEndTime)
75         public;
76 
77     function changeCooldownIndex(
78         uint40 _cutieId,
79         uint16 _cooldownIndex)
80         public;
81 
82     function changeOptional(
83         uint40 _cutieId,
84         uint64 _optional)
85         public;
86 
87     function changeGeneration(
88         uint40 _cutieId,
89         uint16 _generation)
90         public;
91 
92     function createSaleAuction(
93         uint40 _cutieId,
94         uint128 _startPrice,
95         uint128 _endPrice,
96         uint40 _duration
97     )
98     public;
99 
100     function getApproved(uint256 _tokenId) external returns (address);
101 }
102 
103 
104 /**
105  * @title Ownable
106  * @dev The Ownable contract has an owner address, and provides basic authorization control
107  * functions, this simplifies the implementation of "user permissions".
108  */
109 contract Ownable {
110   address public owner;
111 
112 
113   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
114 
115 
116   /**
117    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
118    * account.
119    */
120   constructor() public {
121     owner = msg.sender;
122   }
123 
124   /**
125    * @dev Throws if called by any account other than the owner.
126    */
127   modifier onlyOwner() {
128     require(msg.sender == owner);
129     _;
130   }
131 
132   /**
133    * @dev Allows the current owner to transfer control of the contract to a newOwner.
134    * @param newOwner The address to transfer ownership to.
135    */
136   function transferOwnership(address newOwner) public onlyOwner {
137     require(newOwner != address(0));
138     emit OwnershipTransferred(owner, newOwner);
139     owner = newOwner;
140   }
141 
142 }
143 
144 
145 
146 /**
147  * @title Pausable
148  * @dev Base contract which allows children to implement an emergency stop mechanism.
149  */
150 contract Pausable is Ownable {
151   event Pause();
152   event Unpause();
153 
154   bool public paused = false;
155 
156 
157   /**
158    * @dev Modifier to make a function callable only when the contract is not paused.
159    */
160   modifier whenNotPaused() {
161     require(!paused);
162     _;
163   }
164 
165   /**
166    * @dev Modifier to make a function callable only when the contract is paused.
167    */
168   modifier whenPaused() {
169     require(paused);
170     _;
171   }
172 
173   /**
174    * @dev called by the owner to pause, triggers stopped state
175    */
176   function pause() onlyOwner whenNotPaused public {
177     paused = true;
178     emit Pause();
179   }
180 
181   /**
182    * @dev called by the owner to unpause, returns to normal state
183    */
184   function unpause() onlyOwner whenPaused public {
185     paused = false;
186     emit Unpause();
187   }
188 }
189 
190 pragma solidity ^0.4.24;
191 
192 /// @title Auction Market for Blockchain Cuties.
193 /// @author https://BlockChainArchitect.io
194 contract MarketInterface 
195 {
196     function withdrawEthFromBalance() external;    
197 
198     function createAuction(uint40 _cutieId, uint128 _startPrice, uint128 _endPrice, uint40 _duration, address _seller) public payable;
199 
200     function bid(uint40 _cutieId) public payable;
201 
202     function cancelActiveAuctionWhenPaused(uint40 _cutieId) public;
203 
204 	function getAuctionInfo(uint40 _cutieId)
205         public
206         view
207         returns
208     (
209         address seller,
210         uint128 startPrice,
211         uint128 endPrice,
212         uint40 duration,
213         uint40 startedAt,
214         uint128 featuringFee,
215         bool tokensAllowed
216     );
217 }
218 
219 pragma solidity ^0.4.24;
220 
221 // https://etherscan.io/address/0x4118d7f757ad5893b8fa2f95e067994e1f531371#code
222 contract ERC20 {
223 
224 	string public name;
225 
226 	string public symbol;
227 
228 	uint8 public decimals;
229 
230 	 /**
231      * Transfer tokens from other address
232      *
233      * Send `_value` tokens to `_to` on behalf of `_from`
234      *
235      * @param _from The address of the sender
236      * @param _to The address of the recipient
237      * @param _value the amount to send
238      */
239 	function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
240 
241 	function approveAndCall(address _spender, uint256 _value, bytes _extraData) external
242         returns (bool success);
243 
244 	/**
245 	 * Transfer tokens
246 	 *
247 	 * Send `_value` tokens to `_to` from your account
248 	 *
249 	 * @param _to The address of the recipient
250 	 * @param _value the amount to send
251 	 */
252 	function transfer(address _to, uint256 _value) external;
253 
254     /// @notice Count all tokens assigned to an owner
255     function balanceOf(address _owner) external view returns (uint256);
256 }
257 
258 pragma solidity ^0.4.24;
259 
260 // https://etherscan.io/address/0x3127be52acba38beab6b4b3a406dc04e557c037c#code
261 contract PriceOracleInterface {
262 
263     // How much TOKENs you get for 1 ETH, multiplied by 10^18
264     uint256 public ETHPrice;
265 }
266 
267 pragma solidity ^0.4.24;
268 
269 interface TokenRecipientInterface
270 {
271         function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
272 }
273 
274 
275 /// @title Auction Market for Blockchain Cuties.
276 /// @author https://BlockChainArchitect.io
277 contract Market is MarketInterface, Pausable, TokenRecipientInterface
278 {
279     // Shows the auction on an Cutie Token
280     struct Auction {
281         // Price (in wei or tokens) at the beginning of auction
282         uint128 startPrice;
283         // Price (in wei or tokens) at the end of auction
284         uint128 endPrice;
285         // Current owner of Token
286         address seller;
287         // Auction duration in seconds
288         uint40 duration;
289         // Time when auction started
290         // NOTE: 0 if this auction has been concluded
291         uint40 startedAt;
292         // Featuring fee (in wei, optional)
293         uint128 featuringFee;
294         // is it allowed to bid with erc20 tokens
295         bool tokensAllowed;
296     }
297 
298     // Reference to contract that tracks ownership
299     CutieCoreInterface public coreContract;
300 
301     // Cut owner takes on each auction, in basis points - 1/100 of a per cent.
302     // Values 0-10,000 map to 0%-100%
303     uint16 public ownerFee;
304 
305     // Map from token ID to their corresponding auction.
306     mapping (uint40 => Auction) public cutieIdToAuction;
307     mapping (address => PriceOracleInterface) public priceOracle;
308 
309 
310     address operatorAddress;
311 
312     event AuctionCreated(uint40 indexed cutieId, uint128 startPrice, uint128 endPrice, uint40 duration, uint128 fee, bool tokensAllowed);
313     event AuctionSuccessful(uint40 indexed cutieId, uint128 totalPriceWei, address indexed winner);
314     event AuctionSuccessfulForToken(uint40 indexed cutieId, uint128 totalPriceWei, address indexed winner, uint128 priceInTokens, address indexed token);
315     event AuctionCancelled(uint40 indexed cutieId);
316 
317     modifier onlyOperator() {
318         require(msg.sender == operatorAddress || msg.sender == owner);
319         _;
320     }
321 
322     function setOperator(address _newOperator) public onlyOwner {
323         require(_newOperator != address(0));
324 
325         operatorAddress = _newOperator;
326     }
327 
328     /// @dev disables sending fund to this contract
329     function() external {}
330 
331     modifier canBeStoredIn128Bits(uint256 _value) 
332     {
333         require(_value <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
334         _;
335     }
336 
337     // @dev Adds to the list of open auctions and fires the
338     //  AuctionCreated event.
339     // @param _cutieId The token ID is to be put on auction.
340     // @param _auction To add an auction.
341     // @param _fee Amount of money to feature auction
342     function _addAuction(uint40 _cutieId, Auction _auction) internal
343     {
344         // Require that all auctions have a duration of
345         // at least one minute. (Keeps our math from getting hairy!)
346         require(_auction.duration >= 1 minutes);
347 
348         cutieIdToAuction[_cutieId] = _auction;
349         
350         emit AuctionCreated(
351             _cutieId,
352             _auction.startPrice,
353             _auction.endPrice,
354             _auction.duration,
355             _auction.featuringFee,
356             _auction.tokensAllowed
357         );
358     }
359 
360     // @dev Returns true if the token is claimed by the claimant.
361     // @param _claimant - Address claiming to own the token.
362     function _isOwner(address _claimant, uint256 _cutieId) internal view returns (bool)
363     {
364         return (coreContract.ownerOf(_cutieId) == _claimant);
365     }
366 
367     // @dev Transfers the token owned by this contract to another address.
368     // Returns true when the transfer succeeds.
369     // @param _receiver - Address to transfer token to.
370     // @param _cutieId - Token ID to transfer.
371     function _transfer(address _receiver, uint40 _cutieId) internal
372     {
373         // it will throw if transfer fails
374         coreContract.transfer(_receiver, _cutieId);
375     }
376 
377     // @dev Escrows the token and assigns ownership to this contract.
378     // Throws if the escrow fails.
379     // @param _owner - Current owner address of token to escrow.
380     // @param _cutieId - Token ID the approval of which is to be verified.
381     function _escrow(address _owner, uint40 _cutieId) internal
382     {
383         // it will throw if transfer fails
384         coreContract.transferFrom(_owner, this, _cutieId);
385     }
386 
387     // @dev just cancel auction.
388     function _cancelActiveAuction(uint40 _cutieId, address _seller) internal
389     {
390         _removeAuction(_cutieId);
391         _transfer(_seller, _cutieId);
392         emit AuctionCancelled(_cutieId);
393     }
394 
395     // @dev Calculates the price and transfers winnings.
396     // Does not transfer token ownership.
397     function _bid(uint40 _cutieId, uint128 _bidAmount)
398         internal
399         returns (uint128)
400     {
401         // Get a reference to the auction struct
402         Auction storage auction = cutieIdToAuction[_cutieId];
403 
404         require(_isOnAuction(auction));
405 
406         // Check that bid > current price
407         uint128 price = _currentPrice(auction);
408         require(_bidAmount >= price);
409 
410         // Provide a reference to the seller before the auction struct is deleted.
411         address seller = auction.seller;
412 
413         _removeAuction(_cutieId);
414 
415         // Transfer proceeds to seller (if there are any!)
416         if (price > 0 && seller != address(coreContract)) {
417             uint128 fee = _computeFee(price);
418             uint128 sellerValue = price - fee;
419 
420             seller.transfer(sellerValue);
421         }
422 
423         emit AuctionSuccessful(_cutieId, price, msg.sender);
424 
425         return price;
426     }
427 
428     // @dev Removes from the list of open auctions.
429     // @param _cutieId - ID of token on auction.
430     function _removeAuction(uint40 _cutieId) internal
431     {
432         delete cutieIdToAuction[_cutieId];
433     }
434 
435     // @dev Returns true if the token is on auction.
436     // @param _auction - Auction to check.
437     function _isOnAuction(Auction storage _auction) internal view returns (bool)
438     {
439         return (_auction.startedAt > 0);
440     }
441 
442     // @dev calculate current price of auction. 
443     //  When testing, make this function public and turn on
444     //  `Current price calculation` test suite.
445     function _computeCurrentPrice(
446         uint128 _startPrice,
447         uint128 _endPrice,
448         uint40 _duration,
449         uint40 _secondsPassed
450     )
451         internal
452         pure
453         returns (uint128)
454     {
455         if (_secondsPassed >= _duration) {
456             return _endPrice;
457         } else {
458             int256 totalPriceChange = int256(_endPrice) - int256(_startPrice);
459             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
460             uint128 currentPrice = _startPrice + uint128(currentPriceChange);
461             
462             return currentPrice;
463         }
464     }
465     // @dev return current price of token.
466     function _currentPrice(Auction storage _auction)
467         internal
468         view
469         returns (uint128)
470     {
471         uint40 secondsPassed = 0;
472 
473         uint40 timeNow = uint40(now);
474         if (timeNow > _auction.startedAt) {
475             secondsPassed = timeNow - _auction.startedAt;
476         }
477 
478         return _computeCurrentPrice(
479             _auction.startPrice,
480             _auction.endPrice,
481             _auction.duration,
482             secondsPassed
483         );
484     }
485 
486     // @dev Calculates owner's cut of a sale.
487     // @param _price - Sale price of cutie.
488     function _computeFee(uint128 _price) internal view returns (uint128)
489     {
490         return _price * ownerFee / 10000;
491     }
492 
493     // @dev Remove all Ether from the contract with the owner's cuts. Also, remove any Ether sent directly to the contract address.
494     //  Transfers to the token contract, but can be called by
495     //  the owner or the token contract.
496     function withdrawEthFromBalance() external
497     {
498         address coreAddress = address(coreContract);
499 
500         require(
501             msg.sender == owner ||
502             msg.sender == coreAddress
503         );
504         coreAddress.transfer(address(this).balance);
505     }
506 
507     // @dev create and begin new auction.
508     function createAuction(uint40 _cutieId, uint128 _startPrice, uint128 _endPrice, uint40 _duration, address _seller)
509         public whenNotPaused payable
510     {
511         require(_isOwner(msg.sender, _cutieId));
512         _escrow(msg.sender, _cutieId);
513 
514         bool allowTokens = _duration < 0x8000000000; // first bit of duration is boolean flag (1 to disable tokens)
515         _duration = _duration % 0x8000000000; // clear flag from duration
516 
517         Auction memory auction = Auction(
518             _startPrice,
519             _endPrice,
520             _seller,
521             _duration,
522             uint40(now),
523             uint128(msg.value),
524             allowTokens
525         );
526         _addAuction(_cutieId, auction);
527     }
528 
529     // @dev Set the reference to cutie ownership contract. Verify the owner's fee.
530     //  @param fee should be between 0-10,000.
531     function setup(address _coreContractAddress, uint16 _fee) public onlyOwner
532     {
533         require(_fee <= 10000);
534 
535         ownerFee = _fee;
536         
537         CutieCoreInterface candidateContract = CutieCoreInterface(_coreContractAddress);
538         require(candidateContract.isCutieCore());
539         coreContract = candidateContract;
540     }
541 
542     // @dev Set the owner's fee.
543     //  @param fee should be between 0-10,000.
544     function setFee(uint16 _fee) public onlyOwner
545     {
546         require(_fee <= 10000);
547 
548         ownerFee = _fee;
549     }
550 
551     // @dev bid on auction. Complete it and transfer ownership of cutie if enough ether was given.
552     function bid(uint40 _cutieId) public payable whenNotPaused canBeStoredIn128Bits(msg.value)
553     {
554         // _bid throws if something failed.
555         _bid(_cutieId, uint128(msg.value));
556         _transfer(msg.sender, _cutieId);
557     }
558 
559     function getPriceInToken(ERC20 _tokenContract, uint128 priceWei)
560         public
561         view
562         returns (uint128)
563     {
564         PriceOracleInterface oracle = priceOracle[address(_tokenContract)];
565         require(address(oracle) != address(0));
566 
567         uint256 ethPerToken = oracle.ETHPrice();
568         int256 power = 36 - _tokenContract.decimals();
569         require(power > 0);
570         return uint128(uint256(priceWei) * ethPerToken / (10 ** uint256(power)));
571     }
572 
573     function getCutieId(bytes _extraData) pure internal returns (uint40)
574     {
575         return
576             uint40(_extraData[0]) +
577             uint40(_extraData[1]) * 0x100 +
578             uint40(_extraData[2]) * 0x10000 +
579             uint40(_extraData[3]) * 0x100000 +
580             uint40(_extraData[4]) * 0x10000000;
581     }
582 
583     // https://github.com/BitGuildPlatform/Documentation/blob/master/README.md#2-required-game-smart-contract-changes
584     // Function that is called when trying to use PLAT for payments from approveAndCall
585     function receiveApproval(address _sender, uint256 _value, address _tokenContract, bytes _extraData)
586         external
587         canBeStoredIn128Bits(_value)
588         whenNotPaused
589     {
590         ERC20 tokenContract = ERC20(_tokenContract);
591 
592         require(_extraData.length == 5); // 40 bits
593         uint40 cutieId = getCutieId(_extraData);
594 
595         // Get a reference to the auction struct
596         Auction storage auction = cutieIdToAuction[cutieId];
597         require(auction.tokensAllowed); // buy for token is allowed
598 
599         require(_isOnAuction(auction));
600 
601         uint128 priceWei = _currentPrice(auction);
602 
603         uint128 priceInTokens = getPriceInToken(tokenContract, priceWei);
604 
605         // Check that bid > current price
606         //require(_value >= priceInTokens);
607 
608         // Provide a reference to the seller before the auction struct is deleted.
609         address seller = auction.seller;
610 
611         _removeAuction(cutieId);
612 
613         require(tokenContract.transferFrom(_sender, address(this), priceInTokens));
614 
615         if (seller != address(coreContract))
616         {
617             uint128 fee = _computeFee(priceInTokens);
618             uint128 sellerValue = priceInTokens - fee;
619 
620             tokenContract.transfer(seller, sellerValue);
621         }
622 
623         emit AuctionSuccessfulForToken(cutieId, priceWei, _sender, priceInTokens, _tokenContract);
624         _transfer(_sender, cutieId);
625     }
626 
627     // @dev Returns auction info for a token on auction.
628     // @param _cutieId - ID of token on auction.
629     function getAuctionInfo(uint40 _cutieId)
630         public
631         view
632         returns
633     (
634         address seller,
635         uint128 startPrice,
636         uint128 endPrice,
637         uint40 duration,
638         uint40 startedAt,
639         uint128 featuringFee,
640         bool tokensAllowed
641     ) {
642         Auction storage auction = cutieIdToAuction[_cutieId];
643         require(_isOnAuction(auction));
644         return (
645             auction.seller,
646             auction.startPrice,
647             auction.endPrice,
648             auction.duration,
649             auction.startedAt,
650             auction.featuringFee,
651             auction.tokensAllowed
652         );
653     }
654 
655     // @dev Returns auction info for a token on auction.
656     // @param _cutieId - ID of token on auction.
657     function isOnAuction(uint40 _cutieId)
658         public
659         view
660         returns (bool) 
661     {
662         return cutieIdToAuction[_cutieId].startedAt > 0;
663     }
664 
665 /*
666     /// @dev Import cuties from previous version of Core contract.
667     /// @param _oldAddress Old core contract address
668     /// @param _fromIndex (inclusive)
669     /// @param _toIndex (inclusive)
670     function migrate(address _oldAddress, uint40 _fromIndex, uint40 _toIndex) public onlyOwner whenPaused
671     {
672         Market old = Market(_oldAddress);
673 
674         for (uint40 i = _fromIndex; i <= _toIndex; i++)
675         {
676             if (coreContract.ownerOf(i) == _oldAddress)
677             {
678                 address seller;
679                 uint128 startPrice;
680                 uint128 endPrice;
681                 uint40 duration;
682                 uint40 startedAt;
683                 uint128 featuringFee;   
684                 (seller, startPrice, endPrice, duration, startedAt, featuringFee) = old.getAuctionInfo(i);
685 
686                 Auction memory auction = Auction({
687                     seller: seller, 
688                     startPrice: startPrice, 
689                     endPrice: endPrice, 
690                     duration: duration, 
691                     startedAt: startedAt, 
692                     featuringFee: featuringFee
693                 });
694                 _addAuction(i, auction);
695             }
696         }
697     }*/
698 
699     // @dev Returns the current price of an auction.
700     function getCurrentPrice(uint40 _cutieId)
701         public
702         view
703         returns (uint128)
704     {
705         Auction storage auction = cutieIdToAuction[_cutieId];
706         require(_isOnAuction(auction));
707         return _currentPrice(auction);
708     }
709 
710     // @dev Cancels unfinished auction and returns token to owner. 
711     // Can be called when contract is paused.
712     function cancelActiveAuction(uint40 _cutieId) public
713     {
714         Auction storage auction = cutieIdToAuction[_cutieId];
715         require(_isOnAuction(auction));
716         address seller = auction.seller;
717         require(msg.sender == seller);
718         _cancelActiveAuction(_cutieId, seller);
719     }
720 
721     // @dev Cancels auction when contract is on pause. Option is available only to owners in urgent situations. Tokens returned to seller.
722     //  Used on Core contract upgrade.
723     function cancelActiveAuctionWhenPaused(uint40 _cutieId) whenPaused onlyOwner public
724     {
725         Auction storage auction = cutieIdToAuction[_cutieId];
726         require(_isOnAuction(auction));
727         _cancelActiveAuction(_cutieId, auction.seller);
728     }
729 
730         // @dev Cancels unfinished auction and returns token to owner. 
731     // Can be called when contract is paused.
732     function cancelCreatorAuction(uint40 _cutieId) public onlyOperator
733     {
734         Auction storage auction = cutieIdToAuction[_cutieId];
735         require(_isOnAuction(auction));
736         address seller = auction.seller;
737         require(seller == address(coreContract));
738         _cancelActiveAuction(_cutieId, msg.sender);
739     }
740 
741     // @dev Transfers to _withdrawToAddress all tokens controlled by
742     // contract _tokenContract.
743     function withdrawTokenFromBalance(ERC20 _tokenContract, address _withdrawToAddress) external
744     {
745         address coreAddress = address(coreContract);
746 
747         require(
748             msg.sender == owner ||
749             msg.sender == operatorAddress ||
750             msg.sender == coreAddress
751         );
752         uint256 balance = _tokenContract.balanceOf(address(this));
753         _tokenContract.transfer(_withdrawToAddress, balance);
754     }
755 
756     /// @dev Allow buy cuties for token
757     function addToken(ERC20 _tokenContract, PriceOracleInterface _priceOracle) external onlyOwner
758     {
759         priceOracle[address(_tokenContract)] = _priceOracle;
760     }
761 
762     /// @dev Disallow buy cuties for token
763     function removeToken(ERC20 _tokenContract) external onlyOwner
764     {
765         delete priceOracle[address(_tokenContract)];
766     }
767 
768     function isPluginInterface() public pure returns (bool)
769     {
770         return true;
771     }
772 
773     function onRemove() public pure {}
774 
775     function run(
776         uint40 /*_cutieId*/,
777         uint256 /*_parameter*/,
778         address /*_seller*/
779     )
780     public
781     payable
782     {
783         revert();
784     }
785 
786     function runSigned(
787         uint40 /*_cutieId*/,
788         uint256 /*_parameter*/,
789         address /*_owner*/
790     )
791     external
792     payable
793     {
794         revert();
795     }
796 
797     function withdraw() public
798     {
799         require(
800             msg.sender == owner ||
801             msg.sender == address(coreContract)
802         );
803         if (address(this).balance > 0)
804         {
805             address(coreContract).transfer(address(this).balance);
806         }
807     }
808 }
809 
810 
811 /// @title Auction market for cuties sale 
812 /// @author https://BlockChainArchitect.io
813 contract SaleMarket is Market
814 {
815     // @dev Sanity check reveals that the
816     //  auction in our setSaleAuctionAddress() call is right.
817     bool public isSaleMarket = true;
818     
819 
820     // @dev create and start a new auction
821     // @param _cutieId - ID of cutie to auction, sender must be owner.
822     // @param _startPrice - Price of item (in wei) at the beginning of auction.
823     // @param _endPrice - Price of item (in wei) at the end of auction.
824     // @param _duration - Length of auction (in seconds).
825     // @param _seller - Seller
826     function createAuction(
827         uint40 _cutieId,
828         uint128 _startPrice,
829         uint128 _endPrice,
830         uint40 _duration,
831         address _seller
832     )
833         public
834         payable
835     {
836         require(msg.sender == address(coreContract));
837         _escrow(_seller, _cutieId);
838 
839         bool allowTokens = _duration < 0x8000000000; // first bit of duration is boolean flag (1 to disable tokens)
840         _duration = _duration % 0x8000000000; // clear flag from duration
841 
842         Auction memory auction = Auction(
843             _startPrice,
844             _endPrice,
845             _seller,
846             _duration,
847             uint40(now),
848             uint128(msg.value),
849             allowTokens
850         );
851         _addAuction(_cutieId, auction);
852     }
853 
854     // @dev LastSalePrice is updated if seller is the token contract.
855     // Otherwise, default bid method is used.
856     function bid(uint40 _cutieId)
857         public
858         payable
859         canBeStoredIn128Bits(msg.value)
860     {
861         // _bid verifies token ID size
862         _bid(_cutieId, uint128(msg.value));
863         _transfer(msg.sender, _cutieId);
864     }
865 }