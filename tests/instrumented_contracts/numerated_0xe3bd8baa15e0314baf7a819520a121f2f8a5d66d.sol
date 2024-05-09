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
90 
91     function createSaleAuction(
92         uint40 _cutieId,
93         uint128 _startPrice,
94         uint128 _endPrice,
95         uint40 _duration
96     )
97     public;
98 
99     function getApproved(uint256 _tokenId) external returns (address);
100 }
101 
102 pragma solidity ^0.4.24;
103 
104 
105 pragma solidity ^0.4.24;
106 
107 
108 /**
109  * @title Ownable
110  * @dev The Ownable contract has an owner address, and provides basic authorization control
111  * functions, this simplifies the implementation of "user permissions".
112  */
113 contract Ownable {
114   address public owner;
115 
116 
117   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
118 
119 
120   /**
121    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
122    * account.
123    */
124   constructor() public {
125     owner = msg.sender;
126   }
127 
128   /**
129    * @dev Throws if called by any account other than the owner.
130    */
131   modifier onlyOwner() {
132     require(msg.sender == owner);
133     _;
134   }
135 
136   /**
137    * @dev Allows the current owner to transfer control of the contract to a newOwner.
138    * @param newOwner The address to transfer ownership to.
139    */
140   function transferOwnership(address newOwner) public onlyOwner {
141     require(newOwner != address(0));
142     emit OwnershipTransferred(owner, newOwner);
143     owner = newOwner;
144   }
145 
146 }
147 
148 
149 
150 /**
151  * @title Pausable
152  * @dev Base contract which allows children to implement an emergency stop mechanism.
153  */
154 contract Pausable is Ownable {
155   event Pause();
156   event Unpause();
157 
158   bool public paused = false;
159 
160 
161   /**
162    * @dev Modifier to make a function callable only when the contract is not paused.
163    */
164   modifier whenNotPaused() {
165     require(!paused);
166     _;
167   }
168 
169   /**
170    * @dev Modifier to make a function callable only when the contract is paused.
171    */
172   modifier whenPaused() {
173     require(paused);
174     _;
175   }
176 
177   /**
178    * @dev called by the owner to pause, triggers stopped state
179    */
180   function pause() onlyOwner whenNotPaused public {
181     paused = true;
182     emit Pause();
183   }
184 
185   /**
186    * @dev called by the owner to unpause, returns to normal state
187    */
188   function unpause() onlyOwner whenPaused public {
189     paused = false;
190     emit Unpause();
191   }
192 }
193 
194 pragma solidity ^0.4.24;
195 
196 /// @title Auction Market for Blockchain Cuties.
197 /// @author https://BlockChainArchitect.io
198 contract MarketInterface 
199 {
200     function withdrawEthFromBalance() external;    
201 
202     function createAuction(uint40 _cutieId, uint128 _startPrice, uint128 _endPrice, uint40 _duration, address _seller) public payable;
203 
204     function bid(uint40 _cutieId) public payable;
205 
206     function cancelActiveAuctionWhenPaused(uint40 _cutieId) public;
207 
208 	function getAuctionInfo(uint40 _cutieId)
209         public
210         view
211         returns
212     (
213         address seller,
214         uint128 startPrice,
215         uint128 endPrice,
216         uint40 duration,
217         uint40 startedAt,
218         uint128 featuringFee,
219         bool tokensAllowed
220     );
221 }
222 
223 pragma solidity ^0.4.24;
224 
225 // https://etherscan.io/address/0x4118d7f757ad5893b8fa2f95e067994e1f531371#code
226 contract ERC20 {
227 
228 	string public name;
229 
230 	string public symbol;
231 
232 	uint8 public decimals;
233 
234 	 /**
235      * Transfer tokens from other address
236      *
237      * Send `_value` tokens to `_to` on behalf of `_from`
238      *
239      * @param _from The address of the sender
240      * @param _to The address of the recipient
241      * @param _value the amount to send
242      */
243 	function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
244 
245 	function approveAndCall(address _spender, uint256 _value, bytes _extraData) external
246         returns (bool success);
247 
248 	/**
249 	 * Transfer tokens
250 	 *
251 	 * Send `_value` tokens to `_to` from your account
252 	 *
253 	 * @param _to The address of the recipient
254 	 * @param _value the amount to send
255 	 */
256 	function transfer(address _to, uint256 _value) external;
257 
258     /// @notice Count all tokens assigned to an owner
259     function balanceOf(address _owner) external view returns (uint256);
260 }
261 
262 pragma solidity ^0.4.24;
263 
264 // https://etherscan.io/address/0x3127be52acba38beab6b4b3a406dc04e557c037c#code
265 contract PriceOracleInterface {
266 
267     // How much TOKENs you get for 1 ETH, multiplied by 10^18
268     uint256 public ETHPrice;
269 }
270 
271 pragma solidity ^0.4.24;
272 
273 interface TokenRecipientInterface
274 {
275         function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
276 }
277 
278 
279 /// @title Auction Market for Blockchain Cuties.
280 /// @author https://BlockChainArchitect.io
281 contract Market is MarketInterface, Pausable, TokenRecipientInterface
282 {
283     // Shows the auction on an Cutie Token
284     struct Auction {
285         // Price (in wei or tokens) at the beginning of auction
286         uint128 startPrice;
287         // Price (in wei or tokens) at the end of auction
288         uint128 endPrice;
289         // Current owner of Token
290         address seller;
291         // Auction duration in seconds
292         uint40 duration;
293         // Time when auction started
294         // NOTE: 0 if this auction has been concluded
295         uint40 startedAt;
296         // Featuring fee (in wei, optional)
297         uint128 featuringFee;
298         // is it allowed to bid with erc20 tokens
299         bool tokensAllowed;
300     }
301 
302     // Reference to contract that tracks ownership
303     CutieCoreInterface public coreContract;
304 
305     // Cut owner takes on each auction, in basis points - 1/100 of a per cent.
306     // Values 0-10,000 map to 0%-100%
307     uint16 public ownerFee;
308 
309     // Map from token ID to their corresponding auction.
310     mapping (uint40 => Auction) public cutieIdToAuction;
311     mapping (address => PriceOracleInterface) public priceOracle;
312 
313 
314     address operatorAddress;
315 
316     event AuctionCreated(uint40 indexed cutieId, uint128 startPrice, uint128 endPrice, uint40 duration, uint128 fee, bool tokensAllowed);
317     event AuctionSuccessful(uint40 indexed cutieId, uint128 totalPriceWei, address indexed winner);
318     event AuctionSuccessfulForToken(uint40 indexed cutieId, uint128 totalPriceWei, address indexed winner, uint128 priceInTokens, address indexed token);
319     event AuctionCancelled(uint40 indexed cutieId);
320 
321     modifier onlyOperator() {
322         require(msg.sender == operatorAddress || msg.sender == owner);
323         _;
324     }
325 
326     function setOperator(address _newOperator) public onlyOwner {
327         require(_newOperator != address(0));
328 
329         operatorAddress = _newOperator;
330     }
331 
332     /// @dev disables sending fund to this contract
333     function() external {}
334 
335     modifier canBeStoredIn128Bits(uint256 _value) 
336     {
337         require(_value <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
338         _;
339     }
340 
341     // @dev Adds to the list of open auctions and fires the
342     //  AuctionCreated event.
343     // @param _cutieId The token ID is to be put on auction.
344     // @param _auction To add an auction.
345     // @param _fee Amount of money to feature auction
346     function _addAuction(uint40 _cutieId, Auction _auction) internal
347     {
348         // Require that all auctions have a duration of
349         // at least one minute. (Keeps our math from getting hairy!)
350         require(_auction.duration >= 1 minutes);
351 
352         cutieIdToAuction[_cutieId] = _auction;
353         
354         emit AuctionCreated(
355             _cutieId,
356             _auction.startPrice,
357             _auction.endPrice,
358             _auction.duration,
359             _auction.featuringFee,
360             _auction.tokensAllowed
361         );
362     }
363 
364     // @dev Returns true if the token is claimed by the claimant.
365     // @param _claimant - Address claiming to own the token.
366     function _isOwner(address _claimant, uint256 _cutieId) internal view returns (bool)
367     {
368         return (coreContract.ownerOf(_cutieId) == _claimant);
369     }
370 
371     // @dev Transfers the token owned by this contract to another address.
372     // Returns true when the transfer succeeds.
373     // @param _receiver - Address to transfer token to.
374     // @param _cutieId - Token ID to transfer.
375     function _transfer(address _receiver, uint40 _cutieId) internal
376     {
377         // it will throw if transfer fails
378         coreContract.transfer(_receiver, _cutieId);
379     }
380 
381     // @dev Escrows the token and assigns ownership to this contract.
382     // Throws if the escrow fails.
383     // @param _owner - Current owner address of token to escrow.
384     // @param _cutieId - Token ID the approval of which is to be verified.
385     function _escrow(address _owner, uint40 _cutieId) internal
386     {
387         // it will throw if transfer fails
388         coreContract.transferFrom(_owner, this, _cutieId);
389     }
390 
391     // @dev just cancel auction.
392     function _cancelActiveAuction(uint40 _cutieId, address _seller) internal
393     {
394         _removeAuction(_cutieId);
395         _transfer(_seller, _cutieId);
396         emit AuctionCancelled(_cutieId);
397     }
398 
399     // @dev Calculates the price and transfers winnings.
400     // Does not transfer token ownership.
401     function _bid(uint40 _cutieId, uint128 _bidAmount)
402         internal
403         returns (uint128)
404     {
405         // Get a reference to the auction struct
406         Auction storage auction = cutieIdToAuction[_cutieId];
407 
408         require(_isOnAuction(auction));
409 
410         // Check that bid > current price
411         uint128 price = _currentPrice(auction);
412         require(_bidAmount >= price);
413 
414         // Provide a reference to the seller before the auction struct is deleted.
415         address seller = auction.seller;
416 
417         _removeAuction(_cutieId);
418 
419         // Transfer proceeds to seller (if there are any!)
420         if (price > 0) {
421             uint128 fee = _computeFee(price);
422             uint128 sellerValue = price - fee;
423 
424             seller.transfer(sellerValue);
425         }
426 
427         emit AuctionSuccessful(_cutieId, price, msg.sender);
428 
429         return price;
430     }
431 
432     // @dev Removes from the list of open auctions.
433     // @param _cutieId - ID of token on auction.
434     function _removeAuction(uint40 _cutieId) internal
435     {
436         delete cutieIdToAuction[_cutieId];
437     }
438 
439     // @dev Returns true if the token is on auction.
440     // @param _auction - Auction to check.
441     function _isOnAuction(Auction storage _auction) internal view returns (bool)
442     {
443         return (_auction.startedAt > 0);
444     }
445 
446     // @dev calculate current price of auction. 
447     //  When testing, make this function public and turn on
448     //  `Current price calculation` test suite.
449     function _computeCurrentPrice(
450         uint128 _startPrice,
451         uint128 _endPrice,
452         uint40 _duration,
453         uint40 _secondsPassed
454     )
455         internal
456         pure
457         returns (uint128)
458     {
459         if (_secondsPassed >= _duration) {
460             return _endPrice;
461         } else {
462             int256 totalPriceChange = int256(_endPrice) - int256(_startPrice);
463             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
464             uint128 currentPrice = _startPrice + uint128(currentPriceChange);
465             
466             return currentPrice;
467         }
468     }
469     // @dev return current price of token.
470     function _currentPrice(Auction storage _auction)
471         internal
472         view
473         returns (uint128)
474     {
475         uint40 secondsPassed = 0;
476 
477         uint40 timeNow = uint40(now);
478         if (timeNow > _auction.startedAt) {
479             secondsPassed = timeNow - _auction.startedAt;
480         }
481 
482         return _computeCurrentPrice(
483             _auction.startPrice,
484             _auction.endPrice,
485             _auction.duration,
486             secondsPassed
487         );
488     }
489 
490     // @dev Calculates owner's cut of a sale.
491     // @param _price - Sale price of cutie.
492     function _computeFee(uint128 _price) internal view returns (uint128)
493     {
494         return _price * ownerFee / 10000;
495     }
496 
497     // @dev Remove all Ether from the contract with the owner's cuts. Also, remove any Ether sent directly to the contract address.
498     //  Transfers to the token contract, but can be called by
499     //  the owner or the token contract.
500     function withdrawEthFromBalance() external
501     {
502         address coreAddress = address(coreContract);
503 
504         require(
505             msg.sender == owner ||
506             msg.sender == coreAddress
507         );
508         coreAddress.transfer(address(this).balance);
509     }
510 
511     // @dev create and begin new auction.
512     function createAuction(uint40 _cutieId, uint128 _startPrice, uint128 _endPrice, uint40 _duration, address _seller)
513         public whenNotPaused payable
514     {
515         require(_isOwner(msg.sender, _cutieId));
516         _escrow(msg.sender, _cutieId);
517 
518         bool allowTokens = _duration < 0x8000000000; // first bit of duration is boolean flag (1 to disable tokens)
519         _duration = _duration % 0x8000000000; // clear flag from duration
520 
521         Auction memory auction = Auction(
522             _startPrice,
523             _endPrice,
524             _seller,
525             _duration,
526             uint40(now),
527             uint128(msg.value),
528             allowTokens
529         );
530         _addAuction(_cutieId, auction);
531     }
532 
533     // @dev Set the reference to cutie ownership contract. Verify the owner's fee.
534     //  @param fee should be between 0-10,000.
535     function setup(address _coreContractAddress, uint16 _fee) public onlyOwner
536     {
537         require(_fee <= 10000);
538 
539         ownerFee = _fee;
540         
541         CutieCoreInterface candidateContract = CutieCoreInterface(_coreContractAddress);
542         require(candidateContract.isCutieCore());
543         coreContract = candidateContract;
544     }
545 
546     // @dev Set the owner's fee.
547     //  @param fee should be between 0-10,000.
548     function setFee(uint16 _fee) public onlyOwner
549     {
550         require(_fee <= 10000);
551 
552         ownerFee = _fee;
553     }
554 
555     // @dev bid on auction. Complete it and transfer ownership of cutie if enough ether was given.
556     function bid(uint40 _cutieId) public payable whenNotPaused canBeStoredIn128Bits(msg.value)
557     {
558         // _bid throws if something failed.
559         _bid(_cutieId, uint128(msg.value));
560         _transfer(msg.sender, _cutieId);
561     }
562 
563     function getPriceInToken(ERC20 _tokenContract, uint128 priceWei)
564         public
565         view
566         returns (uint128)
567     {
568         PriceOracleInterface oracle = priceOracle[address(_tokenContract)];
569         require(address(oracle) != address(0));
570 
571         uint256 ethPerToken = oracle.ETHPrice();
572         int256 power = 36 - _tokenContract.decimals();
573         require(power > 0);
574         return uint128(uint256(priceWei) * ethPerToken / (10 ** uint256(power)));
575     }
576 
577     function getCutieId(bytes _extraData) pure internal returns (uint40)
578     {
579         return
580             uint40(_extraData[0]) +
581             uint40(_extraData[1]) * 0x100 +
582             uint40(_extraData[2]) * 0x10000 +
583             uint40(_extraData[3]) * 0x100000 +
584             uint40(_extraData[4]) * 0x10000000;
585     }
586 
587     // https://github.com/BitGuildPlatform/Documentation/blob/master/README.md#2-required-game-smart-contract-changes
588     // Function that is called when trying to use PLAT for payments from approveAndCall
589     function receiveApproval(address _sender, uint256 _value, address _tokenContract, bytes _extraData)
590         external
591         canBeStoredIn128Bits(_value)
592         whenNotPaused
593     {
594         ERC20 tokenContract = ERC20(_tokenContract);
595 
596         require(_extraData.length == 5); // 40 bits
597         uint40 cutieId = getCutieId(_extraData);
598 
599         // Get a reference to the auction struct
600         Auction storage auction = cutieIdToAuction[cutieId];
601         require(auction.tokensAllowed); // buy for token is allowed
602 
603         require(_isOnAuction(auction));
604 
605         uint128 priceWei = _currentPrice(auction);
606 
607         uint128 priceInTokens = getPriceInToken(tokenContract, priceWei);
608 
609         // Check that bid > current price
610         //require(_value >= priceInTokens);
611 
612         // Provide a reference to the seller before the auction struct is deleted.
613         address seller = auction.seller;
614 
615         _removeAuction(cutieId);
616 
617         require(tokenContract.transferFrom(_sender, address(this), priceInTokens));
618 
619         if (seller != address(coreContract))
620         {
621             uint128 fee = _computeFee(priceInTokens);
622             uint128 sellerValue = priceInTokens - fee;
623 
624             tokenContract.transfer(seller, sellerValue);
625         }
626 
627         emit AuctionSuccessfulForToken(cutieId, priceWei, _sender, priceInTokens, _tokenContract);
628         _transfer(_sender, cutieId);
629     }
630 
631     // @dev Returns auction info for a token on auction.
632     // @param _cutieId - ID of token on auction.
633     function getAuctionInfo(uint40 _cutieId)
634         public
635         view
636         returns
637     (
638         address seller,
639         uint128 startPrice,
640         uint128 endPrice,
641         uint40 duration,
642         uint40 startedAt,
643         uint128 featuringFee,
644         bool tokensAllowed
645     ) {
646         Auction storage auction = cutieIdToAuction[_cutieId];
647         require(_isOnAuction(auction));
648         return (
649             auction.seller,
650             auction.startPrice,
651             auction.endPrice,
652             auction.duration,
653             auction.startedAt,
654             auction.featuringFee,
655             auction.tokensAllowed
656         );
657     }
658 
659     // @dev Returns auction info for a token on auction.
660     // @param _cutieId - ID of token on auction.
661     function isOnAuction(uint40 _cutieId)
662         public
663         view
664         returns (bool) 
665     {
666         return cutieIdToAuction[_cutieId].startedAt > 0;
667     }
668 
669 /*
670     /// @dev Import cuties from previous version of Core contract.
671     /// @param _oldAddress Old core contract address
672     /// @param _fromIndex (inclusive)
673     /// @param _toIndex (inclusive)
674     function migrate(address _oldAddress, uint40 _fromIndex, uint40 _toIndex) public onlyOwner whenPaused
675     {
676         Market old = Market(_oldAddress);
677 
678         for (uint40 i = _fromIndex; i <= _toIndex; i++)
679         {
680             if (coreContract.ownerOf(i) == _oldAddress)
681             {
682                 address seller;
683                 uint128 startPrice;
684                 uint128 endPrice;
685                 uint40 duration;
686                 uint40 startedAt;
687                 uint128 featuringFee;   
688                 (seller, startPrice, endPrice, duration, startedAt, featuringFee) = old.getAuctionInfo(i);
689 
690                 Auction memory auction = Auction({
691                     seller: seller, 
692                     startPrice: startPrice, 
693                     endPrice: endPrice, 
694                     duration: duration, 
695                     startedAt: startedAt, 
696                     featuringFee: featuringFee
697                 });
698                 _addAuction(i, auction);
699             }
700         }
701     }*/
702 
703     // @dev Returns the current price of an auction.
704     function getCurrentPrice(uint40 _cutieId)
705         public
706         view
707         returns (uint128)
708     {
709         Auction storage auction = cutieIdToAuction[_cutieId];
710         require(_isOnAuction(auction));
711         return _currentPrice(auction);
712     }
713 
714     // @dev Cancels unfinished auction and returns token to owner. 
715     // Can be called when contract is paused.
716     function cancelActiveAuction(uint40 _cutieId) public
717     {
718         Auction storage auction = cutieIdToAuction[_cutieId];
719         require(_isOnAuction(auction));
720         address seller = auction.seller;
721         require(msg.sender == seller);
722         _cancelActiveAuction(_cutieId, seller);
723     }
724 
725     // @dev Cancels auction when contract is on pause. Option is available only to owners in urgent situations. Tokens returned to seller.
726     //  Used on Core contract upgrade.
727     function cancelActiveAuctionWhenPaused(uint40 _cutieId) whenPaused onlyOwner public
728     {
729         Auction storage auction = cutieIdToAuction[_cutieId];
730         require(_isOnAuction(auction));
731         _cancelActiveAuction(_cutieId, auction.seller);
732     }
733 
734         // @dev Cancels unfinished auction and returns token to owner. 
735     // Can be called when contract is paused.
736     function cancelCreatorAuction(uint40 _cutieId) public onlyOperator
737     {
738         Auction storage auction = cutieIdToAuction[_cutieId];
739         require(_isOnAuction(auction));
740         address seller = auction.seller;
741         require(seller == address(coreContract));
742         _cancelActiveAuction(_cutieId, msg.sender);
743     }
744 
745     // @dev Transfers to _withdrawToAddress all tokens controlled by
746     // contract _tokenContract.
747     function withdrawTokenFromBalance(ERC20 _tokenContract, address _withdrawToAddress) external
748     {
749         address coreAddress = address(coreContract);
750 
751         require(
752             msg.sender == owner ||
753             msg.sender == operatorAddress ||
754             msg.sender == coreAddress
755         );
756         uint256 balance = _tokenContract.balanceOf(address(this));
757         _tokenContract.transfer(_withdrawToAddress, balance);
758     }
759 
760     /// @dev Allow buy cuties for token
761     function addToken(ERC20 _tokenContract, PriceOracleInterface _priceOracle) external onlyOwner
762     {
763         priceOracle[address(_tokenContract)] = _priceOracle;
764     }
765 
766     /// @dev Disallow buy cuties for token
767     function removeToken(ERC20 _tokenContract) external onlyOwner
768     {
769         delete priceOracle[address(_tokenContract)];
770     }
771 }
772 
773 
774 /// @title Auction market for cuties sale 
775 /// @author https://BlockChainArchitect.io
776 contract SaleMarket is Market
777 {
778     // @dev Sanity check reveals that the
779     //  auction in our setSaleAuctionAddress() call is right.
780     bool public isSaleMarket = true;
781     
782 
783     // @dev create and start a new auction
784     // @param _cutieId - ID of cutie to auction, sender must be owner.
785     // @param _startPrice - Price of item (in wei) at the beginning of auction.
786     // @param _endPrice - Price of item (in wei) at the end of auction.
787     // @param _duration - Length of auction (in seconds).
788     // @param _seller - Seller
789     function createAuction(
790         uint40 _cutieId,
791         uint128 _startPrice,
792         uint128 _endPrice,
793         uint40 _duration,
794         address _seller
795     )
796         public
797         payable
798     {
799         require(msg.sender == address(coreContract));
800         _escrow(_seller, _cutieId);
801 
802         bool allowTokens = _duration < 0x8000000000; // first bit of duration is boolean flag (1 to disable tokens)
803         _duration = _duration % 0x8000000000; // clear flag from duration
804 
805         Auction memory auction = Auction(
806             _startPrice,
807             _endPrice,
808             _seller,
809             _duration,
810             uint40(now),
811             uint128(msg.value),
812             allowTokens
813         );
814         _addAuction(_cutieId, auction);
815     }
816 
817     // @dev LastSalePrice is updated if seller is the token contract.
818     // Otherwise, default bid method is used.
819     function bid(uint40 _cutieId)
820         public
821         payable
822         canBeStoredIn128Bits(msg.value)
823     {
824         // _bid verifies token ID size
825         _bid(_cutieId, uint128(msg.value));
826         _transfer(msg.sender, _cutieId);
827     }
828 }