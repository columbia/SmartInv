1 pragma solidity ^0.4.23;
2 
3 /// @title BlockchainCuties: Collectible and breedable cuties on the Ethereum blockchain.
4 /// @author https://BlockChainArchitect.io
5 /// @dev This is the BlockchainCuties configuration. It can be changed redeploying another version.
6 interface ConfigInterface
7 {
8     function isConfig() external pure returns (bool);
9 
10     function getCooldownIndexFromGeneration(uint16 _generation, uint40 _cutieId) external view returns (uint16);
11     function getCooldownEndTimeFromIndex(uint16 _cooldownIndex, uint40 _cutieId) external view returns (uint40);
12     function getCooldownIndexFromGeneration(uint16 _generation) external view returns (uint16);
13     function getCooldownEndTimeFromIndex(uint16 _cooldownIndex) external view returns (uint40);
14 
15     function getCooldownIndexCount() external view returns (uint256);
16 
17     function getBabyGenFromId(uint40 _momId, uint40 _dadId) external view returns (uint16);
18     function getBabyGen(uint16 _momGen, uint16 _dadGen) external pure returns (uint16);
19 
20     function getTutorialBabyGen(uint16 _dadGen) external pure returns (uint16);
21 
22     function getBreedingFee(uint40 _momId, uint40 _dadId) external view returns (uint256);
23 }
24 
25 
26 contract CutieCoreInterface
27 {
28     function isCutieCore() pure public returns (bool);
29 
30     ConfigInterface public config;
31 
32     function transferFrom(address _from, address _to, uint256 _cutieId) external;
33     function transfer(address _to, uint256 _cutieId) external;
34 
35     function ownerOf(uint256 _cutieId)
36         external
37         view
38         returns (address owner);
39 
40     function getCutie(uint40 _id)
41         external
42         view
43         returns (
44         uint256 genes,
45         uint40 birthTime,
46         uint40 cooldownEndTime,
47         uint40 momId,
48         uint40 dadId,
49         uint16 cooldownIndex,
50         uint16 generation
51     );
52 
53     function getGenes(uint40 _id)
54         public
55         view
56         returns (
57         uint256 genes
58     );
59 
60 
61     function getCooldownEndTime(uint40 _id)
62         public
63         view
64         returns (
65         uint40 cooldownEndTime
66     );
67 
68     function getCooldownIndex(uint40 _id)
69         public
70         view
71         returns (
72         uint16 cooldownIndex
73     );
74 
75 
76     function getGeneration(uint40 _id)
77         public
78         view
79         returns (
80         uint16 generation
81     );
82 
83     function getOptional(uint40 _id)
84         public
85         view
86         returns (
87         uint64 optional
88     );
89 
90 
91     function changeGenes(
92         uint40 _cutieId,
93         uint256 _genes)
94         public;
95 
96     function changeCooldownEndTime(
97         uint40 _cutieId,
98         uint40 _cooldownEndTime)
99         public;
100 
101     function changeCooldownIndex(
102         uint40 _cutieId,
103         uint16 _cooldownIndex)
104         public;
105 
106     function changeOptional(
107         uint40 _cutieId,
108         uint64 _optional)
109         public;
110 
111     function changeGeneration(
112         uint40 _cutieId,
113         uint16 _generation)
114         public;
115 
116     function createSaleAuction(
117         uint40 _cutieId,
118         uint128 _startPrice,
119         uint128 _endPrice,
120         uint40 _duration
121     )
122     public;
123 
124     function getApproved(uint256 _tokenId) external returns (address);
125     function totalSupply() view external returns (uint256);
126     function createPromoCutie(uint256 _genes, address _owner) external;
127     function checkOwnerAndApprove(address _claimant, uint40 _cutieId, address _pluginsContract) external view;
128     function breedWith(uint40 _momId, uint40 _dadId) public payable returns (uint40);
129     function getBreedingFee(uint40 _momId, uint40 _dadId) public view returns (uint256);
130 }
131 
132 pragma solidity ^0.4.23;
133 
134 
135 pragma solidity ^0.4.23;
136 
137 
138 /**
139  * @title Ownable
140  * @dev The Ownable contract has an owner address, and provides basic authorization control
141  * functions, this simplifies the implementation of "user permissions".
142  */
143 contract Ownable {
144   address public owner;
145 
146 
147   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
148 
149 
150   /**
151    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
152    * account.
153    */
154   constructor() public {
155     owner = msg.sender;
156   }
157 
158   /**
159    * @dev Throws if called by any account other than the owner.
160    */
161   modifier onlyOwner() {
162     require(msg.sender == owner);
163     _;
164   }
165 
166   /**
167    * @dev Allows the current owner to transfer control of the contract to a newOwner.
168    * @param newOwner The address to transfer ownership to.
169    */
170   function transferOwnership(address newOwner) public onlyOwner {
171     require(newOwner != address(0));
172     emit OwnershipTransferred(owner, newOwner);
173     owner = newOwner;
174   }
175 
176 }
177 
178 
179 
180 /**
181  * @title Pausable
182  * @dev Base contract which allows children to implement an emergency stop mechanism.
183  */
184 contract Pausable is Ownable {
185   event Pause();
186   event Unpause();
187 
188   bool public paused = false;
189 
190 
191   /**
192    * @dev Modifier to make a function callable only when the contract is not paused.
193    */
194   modifier whenNotPaused() {
195     require(!paused);
196     _;
197   }
198 
199   /**
200    * @dev Modifier to make a function callable only when the contract is paused.
201    */
202   modifier whenPaused() {
203     require(paused);
204     _;
205   }
206 
207   /**
208    * @dev called by the owner to pause, triggers stopped state
209    */
210   function pause() onlyOwner whenNotPaused public {
211     paused = true;
212     emit Pause();
213   }
214 
215   /**
216    * @dev called by the owner to unpause, returns to normal state
217    */
218   function unpause() onlyOwner whenPaused public {
219     paused = false;
220     emit Unpause();
221   }
222 }
223 
224 pragma solidity ^0.4.23;
225 
226 /// @title Auction Market for Blockchain Cuties.
227 /// @author https://BlockChainArchitect.io
228 contract MarketInterface 
229 {
230     function withdrawEthFromBalance() external;
231 
232     function createAuction(uint40 _cutieId, uint128 _startPrice, uint128 _endPrice, uint40 _duration, address _seller) public payable;
233     function createAuctionWithTokens(uint40 _cutieId, uint128 _startPrice, uint128 _endPrice, uint40 _duration, address _seller, address[] allowedTokens) public payable;
234 
235     function bid(uint40 _cutieId) public payable;
236 
237     function cancelActiveAuctionWhenPaused(uint40 _cutieId) public;
238 
239 	function getAuctionInfo(uint40 _cutieId)
240         public
241         view
242         returns
243     (
244         address seller,
245         uint128 startPrice,
246         uint128 endPrice,
247         uint40 duration,
248         uint40 startedAt,
249         uint128 featuringFee,
250         address[] allowedTokens
251     );
252 }
253 
254 pragma solidity ^0.4.23;
255 
256 interface Gen0CallbackInterface
257 {
258     function onGen0Created(uint40 _cutieId) external;
259 }
260 
261 pragma solidity ^0.4.23;
262 
263 // ----------------------------------------------------------------------------
264 // Contract function to receive approval and execute function in one call
265 //
266 // Borrowed from MiniMeToken
267 
268 interface TokenRecipientInterface
269 {
270     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
271 }
272 
273 pragma solidity ^0.4.23;
274 
275 // https://github.com/ethereum/EIPs/issues/223
276 interface TokenFallback
277 {
278     function tokenFallback(address _from, uint _value, bytes _data) external;
279 }
280 
281 pragma solidity ^0.4.23;
282 
283 pragma solidity ^0.4.23;
284 
285 // ----------------------------------------------------------------------------
286 contract ERC20 {
287 
288     // ERC Token Standard #223 Interface
289     // https://github.com/ethereum/EIPs/issues/223
290 
291     string public symbol;
292     string public  name;
293     uint8 public decimals;
294 
295     function transfer(address _to, uint _value, bytes _data) external returns (bool success);
296 
297     // approveAndCall
298     function approveAndCall(address spender, uint tokens, bytes data) external returns (bool success);
299 
300     // ERC Token Standard #20 Interface
301     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
302 
303 
304     function totalSupply() public constant returns (uint);
305     function balanceOf(address tokenOwner) public constant returns (uint balance);
306     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
307     function transfer(address to, uint tokens) public returns (bool success);
308     function approve(address spender, uint tokens) public returns (bool success);
309     function transferFrom(address from, address to, uint tokens) public returns (bool success);
310     event Transfer(address indexed from, address indexed to, uint tokens);
311     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
312 
313     // bulk operations
314     function transferBulk(address[] to, uint[] tokens) public;
315     function approveBulk(address[] spender, uint[] tokens) public;
316 }
317 
318 
319 interface TokenRegistryInterface
320 {
321     function getPriceInToken(ERC20 tokenContract, uint128 priceWei) external view returns (uint128);
322     function areAllTokensAllowed(address[] tokens) external view returns (bool);
323     function isTokenInList(address[] allowedTokens, address currentToken) external pure returns (bool);
324     function getDefaultTokens() external view returns (address[]);
325     function getDefaultCreatorTokens() external view returns (address[]);
326     function onTokensReceived(ERC20 tokenContract, uint tokenCount) external;
327     function withdrawEthFromBalance() external;
328     function canConvertToEth(ERC20 tokenContract) external view returns (bool);
329     function convertTokensToEth(ERC20 tokenContract, address seller, uint sellerValue, uint fee) external;
330 }
331 
332 
333 /// @title Auction Market for Blockchain Cuties.
334 /// @author https://BlockChainArchitect.io
335 contract Market is MarketInterface, Pausable, TokenRecipientInterface, TokenFallback
336 {
337     // Shows the auction on an Cutie Token
338     struct Auction {
339         // Price (in wei or tokens) at the beginning of auction
340         uint128 startPrice;
341         // Price (in wei or tokens) at the end of auction
342         uint128 endPrice;
343         // Current owner of Token
344         address seller;
345         // Auction duration in seconds
346         uint40 duration;
347         // Time when auction started
348         // NOTE: 0 if this auction has been concluded
349         uint40 startedAt;
350         // Featuring fee (in wei, optional)
351         uint128 featuringFee;
352         // list of erc20 tokens addresses, that is allowed to bid with
353         address[] allowedTokens;
354     }
355 
356     // Reference to contract that tracks ownership
357     CutieCoreInterface public coreContract;
358     Gen0CallbackInterface public gen0Callback;
359 
360     // Cut owner takes on each auction, in basis points - 1/100 of a per cent.
361     // Values 0-10,000 map to 0%-100%
362     uint16 public ownerFee;
363 
364     // Map from token ID to their corresponding auction.
365     mapping (uint40 => Auction) public cutieIdToAuction;
366     TokenRegistryInterface public tokenRegistry;
367 
368 
369     address operatorAddress;
370 
371     event AuctionCreatedWithTokens(uint40 indexed cutieId, uint128 startPrice, uint128 endPrice, uint40 duration, uint128 fee, address[] allowedTokens);
372     event AuctionSuccessful(uint40 indexed cutieId, uint128 totalPriceWei, address indexed winner);
373     event AuctionSuccessfulForToken(uint40 indexed cutieId, uint128 totalPriceWei, address indexed winner, uint128 priceInTokens, address indexed token);
374     event AuctionCancelled(uint40 indexed cutieId);
375 
376     modifier onlyOperator() {
377         require(msg.sender == operatorAddress || msg.sender == owner);
378         _;
379     }
380 
381     function setOperator(address _newOperator) public onlyOwner {
382         require(_newOperator != address(0));
383 
384         operatorAddress = _newOperator;
385     }
386 
387     /// @dev enable sending fund to this contract
388     function() external payable {}
389 
390     modifier canBeStoredIn128Bits(uint256 _value)
391     {
392         require(_value <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
393         _;
394     }
395 
396     // @dev Adds to the list of open auctions and fires the
397     //  AuctionCreated event.
398     // @param _cutieId The token ID is to be put on auction.
399     // @param _auction To add an auction.
400     // @param _fee Amount of money to feature auction
401     function _addAuction(uint40 _cutieId, Auction _auction) internal
402     {
403         if (_auction.seller == address(coreContract))
404         {
405             if (address(gen0Callback) != 0x0)
406             {
407                 gen0Callback.onGen0Created(_cutieId);
408             }
409             if (_auction.duration == 0)
410             {
411                 _transfer(operatorAddress, _cutieId);
412                 return;
413             }
414         }
415         // Require that all auctions have a duration of
416         // at least one minute. (Keeps our math from getting hairy!)
417         require(_auction.duration >= 1 minutes);
418 
419         cutieIdToAuction[_cutieId] = _auction;
420         
421         emit AuctionCreatedWithTokens(
422             _cutieId,
423             _auction.startPrice,
424             _auction.endPrice,
425             _auction.duration,
426             _auction.featuringFee,
427             _auction.allowedTokens
428         );
429     }
430 
431     // @dev Returns true if the token is claimed by the claimant.
432     // @param _claimant - Address claiming to own the token.
433     function _isOwner(address _claimant, uint256 _cutieId) internal view returns (bool)
434     {
435         return (coreContract.ownerOf(_cutieId) == _claimant);
436     }
437 
438     // @dev Transfers the token owned by this contract to another address.
439     // Returns true when the transfer succeeds.
440     // @param _receiver - Address to transfer token to.
441     // @param _cutieId - Token ID to transfer.
442     function _transfer(address _receiver, uint40 _cutieId) internal
443     {
444         // it will throw if transfer fails
445         coreContract.transfer(_receiver, _cutieId);
446     }
447 
448     // @dev Escrows the token and assigns ownership to this contract.
449     // Throws if the escrow fails.
450     // @param _owner - Current owner address of token to escrow.
451     // @param _cutieId - Token ID the approval of which is to be verified.
452     function _escrow(address _owner, uint40 _cutieId) internal
453     {
454         // it will throw if transfer fails
455         coreContract.transferFrom(_owner, this, _cutieId);
456     }
457 
458     // @dev just cancel auction.
459     function _cancelActiveAuction(uint40 _cutieId, address _seller) internal
460     {
461         _removeAuction(_cutieId);
462         _transfer(_seller, _cutieId);
463         emit AuctionCancelled(_cutieId);
464     }
465 
466     // @dev Calculates the price and transfers winnings.
467     // Does not transfer token ownership.
468     function _bid(uint40 _cutieId, uint128 _bidAmount)
469         internal
470         returns (uint128)
471     {
472         // Get a reference to the auction struct
473         Auction storage auction = cutieIdToAuction[_cutieId];
474 
475         require(_isOnAuction(auction));
476 
477         // Check that bid > current price
478         uint128 price = _currentPrice(auction);
479         require(_bidAmount >= price);
480 
481         // Provide a reference to the seller before the auction struct is deleted.
482         address seller = auction.seller;
483 
484         _removeAuction(_cutieId);
485 
486         // Transfer proceeds to seller (if there are any!)
487         if (price > 0 && seller != address(coreContract)) {
488             uint128 fee = _computeFee(price);
489             uint128 sellerValue = price - fee;
490 
491             seller.transfer(sellerValue);
492         }
493 
494         emit AuctionSuccessful(_cutieId, price, msg.sender);
495 
496         return price;
497     }
498 
499     // @dev Removes from the list of open auctions.
500     // @param _cutieId - ID of token on auction.
501     function _removeAuction(uint40 _cutieId) internal
502     {
503         delete cutieIdToAuction[_cutieId];
504     }
505 
506     // @dev Returns true if the token is on auction.
507     // @param _auction - Auction to check.
508     function _isOnAuction(Auction storage _auction) internal view returns (bool)
509     {
510         return (_auction.startedAt > 0);
511     }
512 
513     // @dev calculate current price of auction. 
514     //  When testing, make this function public and turn on
515     //  `Current price calculation` test suite.
516     function _computeCurrentPrice(
517         uint128 _startPrice,
518         uint128 _endPrice,
519         uint40 _duration,
520         uint40 _secondsPassed
521     )
522         internal
523         pure
524         returns (uint128)
525     {
526         if (_secondsPassed >= _duration) {
527             return _endPrice;
528         } else {
529             int256 totalPriceChange = int256(_endPrice) - int256(_startPrice);
530             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
531             uint128 currentPrice = _startPrice + uint128(currentPriceChange);
532             
533             return currentPrice;
534         }
535     }
536     // @dev return current price of token.
537     function _currentPrice(Auction storage _auction)
538         internal
539         view
540         returns (uint128)
541     {
542         uint40 secondsPassed = 0;
543 
544         uint40 timeNow = uint40(now);
545         if (timeNow > _auction.startedAt) {
546             secondsPassed = timeNow - _auction.startedAt;
547         }
548 
549         return _computeCurrentPrice(
550             _auction.startPrice,
551             _auction.endPrice,
552             _auction.duration,
553             secondsPassed
554         );
555     }
556 
557     // @dev Calculates owner's cut of a sale.
558     // @param _price - Sale price of cutie.
559     function _computeFee(uint128 _price) internal view returns (uint128)
560     {
561         return _price * ownerFee / 10000;
562     }
563 
564     // @dev Remove all Ether from the contract with the owner's cuts. Also, remove any Ether sent directly to the contract address.
565     //  Transfers to the token contract, but can be called by
566     //  the owner or the token contract.
567     function withdrawEthFromBalance() external
568     {
569         address coreAddress = address(coreContract);
570 
571         require(
572             msg.sender == owner ||
573             msg.sender == coreAddress
574         );
575 
576         tokenRegistry.withdrawEthFromBalance();
577         coreAddress.transfer(address(this).balance);
578     }
579 
580     // @dev create and start a new auction
581     // @param _cutieId - ID of cutie to auction, sender must be owner.
582     // @param _startPrice - Price of item (in wei) at the beginning of auction.
583     // @param _endPrice - Price of item (in wei) at the end of auction.
584     // @param _duration - Length of auction (in seconds). Most significant bit od duration is to allow sell for all tokens.
585     // @param _seller - Seller
586     function createAuction(uint40 _cutieId, uint128 _startPrice, uint128 _endPrice, uint40 _duration, address _seller)
587         public whenNotPaused payable
588     {
589         require(_isOwner(_seller, _cutieId));
590         _escrow(_seller, _cutieId);
591 
592         bool allowTokens = _duration < 0x8000000000; // first bit of duration is boolean flag (1 to disable tokens)
593         _duration = _duration % 0x8000000000; // clear flag from duration
594 
595         Auction memory auction = Auction(
596             _startPrice,
597             _endPrice,
598             _seller,
599             _duration,
600             uint40(now),
601             uint128(msg.value),
602             allowTokens ?
603                 (_seller == address(coreContract) ? tokenRegistry.getDefaultCreatorTokens() : tokenRegistry.getDefaultTokens())
604                 : new address[](0)
605         );
606         _addAuction(_cutieId, auction);
607     }
608 
609     // @dev create and start a new auction
610     // @param _cutieId - ID of cutie to auction, sender must be owner.
611     // @param _startPrice - Price of item (in wei) at the beginning of auction.
612     // @param _endPrice - Price of item (in wei) at the end of auction.
613     // @param _duration - Length of auction (in seconds).
614     // @param _seller - Seller
615     // @param _allowedTokens - list of tokens addresses, that can be used as currency to buy cutie.
616     function createAuctionWithTokens(
617         uint40 _cutieId,
618         uint128 _startPrice,
619         uint128 _endPrice,
620         uint40 _duration,
621         address _seller,
622         address[] _allowedTokens) public payable
623     {
624         require(tokenRegistry.areAllTokensAllowed(_allowedTokens));
625         require(_isOwner(_seller, _cutieId));
626         _escrow(_seller, _cutieId);
627 
628         Auction memory auction = Auction(
629             _startPrice,
630             _endPrice,
631             _seller,
632             _duration,
633             uint40(now),
634             uint128(msg.value),
635             _allowedTokens
636         );
637         _addAuction(_cutieId, auction);
638     }
639 
640     // @dev Set the reference to cutie ownership contract. Verify the owner's fee.
641     //  @param fee should be between 0-10,000.
642     function setup(address _coreContractAddress, TokenRegistryInterface _tokenRegistry, uint16 _fee) public onlyOwner
643     {
644         require(_fee <= 10000);
645 
646         ownerFee = _fee;
647 
648         CutieCoreInterface candidateContract = CutieCoreInterface(_coreContractAddress);
649         require(candidateContract.isCutieCore());
650         coreContract = candidateContract;
651         tokenRegistry = _tokenRegistry;
652     }
653 
654     function setGen0Callback(Gen0CallbackInterface _gen0Callback) public onlyOwner
655     {
656         gen0Callback = _gen0Callback;
657     }
658 
659     // @dev Set the owner's fee.
660     //  @param fee should be between 0-10,000.
661     function setFee(uint16 _fee) public onlyOwner
662     {
663         require(_fee <= 10000);
664 
665         ownerFee = _fee;
666     }
667 
668     // @dev bid on auction. Complete it and transfer ownership of cutie if enough ether was given.
669     function bid(uint40 _cutieId) public payable whenNotPaused canBeStoredIn128Bits(msg.value)
670     {
671         // _bid throws if something failed.
672         _bid(_cutieId, uint128(msg.value));
673         _transfer(msg.sender, _cutieId);
674     }
675 
676     function getCutieId(bytes _extraData) pure internal returns (uint40)
677     {
678         require(_extraData.length == 5); // 40 bits
679 
680         return
681             uint40(_extraData[0]) +
682             uint40(_extraData[1]) * 0x100 +
683             uint40(_extraData[2]) * 0x10000 +
684             uint40(_extraData[3]) * 0x100000 +
685             uint40(_extraData[4]) * 0x10000000;
686     }
687 
688     function bidWithToken(address _tokenContract, uint40 _cutieId) external whenNotPaused
689     {
690         _bidWithToken(_tokenContract, _cutieId, msg.sender);
691     }
692 
693     function tokenFallback(address _sender, uint _value, bytes _extraData) external whenNotPaused
694     {
695         uint40 cutieId = getCutieId(_extraData);
696         address tokenContractAddress = msg.sender;
697         ERC20 tokenContract = ERC20(tokenContractAddress);
698 
699         // Get a reference to the auction struct
700         Auction storage auction = cutieIdToAuction[cutieId];
701 
702         require(tokenRegistry.isTokenInList(auction.allowedTokens, tokenContractAddress)); // buy for token is allowed
703 
704         require(_isOnAuction(auction));
705 
706         uint128 priceWei = _currentPrice(auction);
707 
708         uint128 priceInTokens = tokenRegistry.getPriceInToken(tokenContract, priceWei);
709 
710         // Check that bid > current price (this tokens are already sent to currect contract)
711         require(_value >= priceInTokens);
712 
713         // Provide a reference to the seller before the auction struct is deleted.
714         address seller = auction.seller;
715 
716         _removeAuction(cutieId);
717 
718         // send tokens to seller
719         if (seller != address(coreContract))
720         {
721             uint128 fee = _computeFee(priceInTokens);
722             uint128 sellerValue = priceInTokens - fee;
723 
724             tokenContract.transfer(seller, sellerValue);
725         }
726 
727         emit AuctionSuccessfulForToken(cutieId, priceWei, _sender, priceInTokens, tokenContractAddress);
728         _transfer(_sender, cutieId);
729     }
730 
731     // https://github.com/BitGuildPlatform/Documentation/blob/master/README.md#2-required-game-smart-contract-changes
732     // Function that is called when trying to use PLAT for payments from approveAndCall
733     function receiveApproval(address _sender, uint256 _value, address _tokenContract, bytes _extraData)
734         external
735         canBeStoredIn128Bits(_value)
736         whenNotPaused
737     {
738         uint40 cutieId = getCutieId(_extraData);
739         _bidWithToken(_tokenContract, cutieId, _sender);
740     }
741 
742     function _bidWithToken(address _tokenContract, uint40 _cutieId, address _sender) internal
743     {
744         ERC20 tokenContract = ERC20(_tokenContract);
745 
746         // Get a reference to the auction struct
747         Auction storage auction = cutieIdToAuction[_cutieId];
748 
749         bool allowTokens = tokenRegistry.isTokenInList(auction.allowedTokens, _tokenContract); // buy for token is allowed
750         bool allowConvertToEth = tokenRegistry.canConvertToEth(tokenContract);
751 
752         require(allowTokens || allowConvertToEth);
753 
754         require(_isOnAuction(auction));
755 
756         uint128 priceWei = _currentPrice(auction);
757 
758         uint128 priceInTokens = tokenRegistry.getPriceInToken(tokenContract, priceWei);
759 
760         // Provide a reference to the seller before the auction struct is deleted.
761         address seller = auction.seller;
762 
763         _removeAuction(_cutieId);
764 
765         if (seller != address(coreContract))
766         {
767             uint128 fee = _computeFee(priceInTokens);
768             uint128 sellerValueTokens = priceInTokens - fee;
769 
770             if (allowTokens)
771             {
772                 // seller income - tokens
773                 require(tokenContract.transferFrom(_sender, seller, sellerValueTokens));
774 
775                 // market fee - convert tokens to eth
776                 require(tokenContract.transferFrom(_sender, address(tokenRegistry), fee));
777                 tokenRegistry.onTokensReceived(tokenContract, fee);
778             }
779             else
780             {
781                 // seller income
782                 require(tokenContract.transferFrom(_sender, address(tokenRegistry), priceInTokens)); // sellerValueTokens + fee
783                 tokenRegistry.convertTokensToEth(tokenContract, seller, priceInTokens, ownerFee); // sellerValueTokens = priceInTokens * (100% - fee)
784             }
785         }
786         else
787         {
788             require(tokenContract.transferFrom(_sender, address(tokenRegistry), priceInTokens));
789             tokenRegistry.onTokensReceived(tokenContract, priceInTokens);
790         }
791         emit AuctionSuccessfulForToken(_cutieId, priceWei, _sender, priceInTokens, _tokenContract);
792         _transfer(_sender, _cutieId);
793     }
794 
795     // @dev Returns auction info for a token on auction.
796     // @param _cutieId - ID of token on auction.
797     function getAuctionInfo(uint40 _cutieId)
798         public
799         view
800         returns
801     (
802         address seller,
803         uint128 startPrice,
804         uint128 endPrice,
805         uint40 duration,
806         uint40 startedAt,
807         uint128 featuringFee,
808         address[] allowedTokens
809     ) {
810         Auction storage auction = cutieIdToAuction[_cutieId];
811         require(_isOnAuction(auction));
812         return (
813             auction.seller,
814             auction.startPrice,
815             auction.endPrice,
816             auction.duration,
817             auction.startedAt,
818             auction.featuringFee,
819             auction.allowedTokens
820         );
821     }
822 
823     // @dev Returns auction info for a token on auction.
824     // @param _cutieId - ID of token on auction.
825     function isOnAuction(uint40 _cutieId)
826         public
827         view
828         returns (bool) 
829     {
830         return cutieIdToAuction[_cutieId].startedAt > 0;
831     }
832 
833 /*
834     /// @dev Import cuties from previous version of Core contract.
835     /// @param _oldAddress Old core contract address
836     /// @param _fromIndex (inclusive)
837     /// @param _toIndex (inclusive)
838     function migrate(address _oldAddress, uint40 _fromIndex, uint40 _toIndex) public onlyOwner whenPaused
839     {
840         Market old = Market(_oldAddress);
841 
842         for (uint40 i = _fromIndex; i <= _toIndex; i++)
843         {
844             if (coreContract.ownerOf(i) == _oldAddress)
845             {
846                 address seller;
847                 uint128 startPrice;
848                 uint128 endPrice;
849                 uint40 duration;
850                 uint40 startedAt;
851                 uint128 featuringFee;   
852                 (seller, startPrice, endPrice, duration, startedAt, featuringFee) = old.getAuctionInfo(i);
853 
854                 Auction memory auction = Auction({
855                     seller: seller, 
856                     startPrice: startPrice, 
857                     endPrice: endPrice, 
858                     duration: duration, 
859                     startedAt: startedAt, 
860                     featuringFee: featuringFee
861                 });
862                 _addAuction(i, auction);
863             }
864         }
865     }*/
866 
867     // @dev Returns the current price of an auction.
868     function getCurrentPrice(uint40 _cutieId)
869         public
870         view
871         returns (uint128)
872     {
873         Auction storage auction = cutieIdToAuction[_cutieId];
874         require(_isOnAuction(auction));
875         return _currentPrice(auction);
876     }
877 
878     // @dev Cancels unfinished auction and returns token to owner. 
879     // Can be called when contract is paused.
880     function cancelActiveAuction(uint40 _cutieId) public
881     {
882         Auction storage auction = cutieIdToAuction[_cutieId];
883         require(_isOnAuction(auction));
884         address seller = auction.seller;
885         require(msg.sender == seller);
886         _cancelActiveAuction(_cutieId, seller);
887     }
888 
889     // @dev Cancels auction when contract is on pause. Option is available only to owners in urgent situations. Tokens returned to seller.
890     //  Used on Core contract upgrade.
891     function cancelActiveAuctionWhenPaused(uint40 _cutieId) whenPaused onlyOwner public
892     {
893         Auction storage auction = cutieIdToAuction[_cutieId];
894         require(_isOnAuction(auction));
895         _cancelActiveAuction(_cutieId, auction.seller);
896     }
897 
898     // @dev Cancels unfinished auction and returns token to owner.
899     // Can be called when contract is paused.
900     function cancelCreatorAuction(uint40 _cutieId) public onlyOperator
901     {
902         Auction storage auction = cutieIdToAuction[_cutieId];
903         require(_isOnAuction(auction));
904         address seller = auction.seller;
905         require(seller == address(coreContract));
906         _cancelActiveAuction(_cutieId, msg.sender);
907     }
908 
909     // @dev Transfers to _withdrawToAddress all tokens controlled by
910     // contract _tokenContract.
911     function withdrawTokenFromBalance(ERC20 _tokenContract, address _withdrawToAddress) external
912     {
913         address coreAddress = address(coreContract);
914 
915         require(
916             msg.sender == owner ||
917             msg.sender == operatorAddress ||
918             msg.sender == coreAddress
919         );
920         uint256 balance = _tokenContract.balanceOf(address(this));
921         _tokenContract.transfer(_withdrawToAddress, balance);
922     }
923 
924     function isPluginInterface() public pure returns (bool)
925     {
926         return true;
927     }
928 
929     function onRemove() public {}
930 
931     function run(
932         uint40 /*_cutieId*/,
933         uint256 /*_parameter*/,
934         address /*_seller*/
935     )
936     public
937     payable
938     {
939         revert();
940     }
941 
942     function runSigned(
943         uint40 /*_cutieId*/,
944         uint256 /*_parameter*/,
945         address /*_owner*/
946     )
947         external
948         payable
949     {
950         revert();
951     }
952 
953     function withdraw() public
954     {
955         require(
956             msg.sender == owner ||
957             msg.sender == address(coreContract)
958         );
959         if (address(this).balance > 0)
960         {
961             address(coreContract).transfer(address(this).balance);
962         }
963     }
964 }
965 
966 
967 /// @title Auction market for cuties sale 
968 /// @author https://BlockChainArchitect.io
969 contract SaleMarket is Market
970 {
971     // @dev Sanity check reveals that the
972     //  auction in our setSaleAuctionAddress() call is right.
973     bool public isSaleMarket = true;
974 
975     // @dev LastSalePrice is updated if seller is the token contract.
976     // Otherwise, default bid method is used.
977     function bid(uint40 _cutieId)
978         public
979         payable
980         canBeStoredIn128Bits(msg.value)
981     {
982         // _bid verifies token ID size
983         _bid(_cutieId, uint128(msg.value));
984         _transfer(msg.sender, _cutieId);
985     }
986 }