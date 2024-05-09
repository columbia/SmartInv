1 pragma solidity ^0.4.23;
2 
3 
4 
5 
6 
7 
8 
9 /// @title BlockchainCuties: Collectible and breedable cuties on the Ethereum blockchain.
10 /// @author https://BlockChainArchitect.io
11 /// @dev This is the BlockchainCuties configuration. It can be changed redeploying another version.
12 interface ConfigInterface
13 {
14     function isConfig() external pure returns (bool);
15 
16     function getCooldownIndexFromGeneration(uint16 _generation, uint40 _cutieId) external view returns (uint16);
17     function getCooldownEndTimeFromIndex(uint16 _cooldownIndex, uint40 _cutieId) external view returns (uint40);
18     function getCooldownIndexFromGeneration(uint16 _generation) external view returns (uint16);
19     function getCooldownEndTimeFromIndex(uint16 _cooldownIndex) external view returns (uint40);
20 
21     function getCooldownIndexCount() external view returns (uint256);
22 
23     function getBabyGenFromId(uint40 _momId, uint40 _dadId) external view returns (uint16);
24     function getBabyGen(uint16 _momGen, uint16 _dadGen) external pure returns (uint16);
25 
26     function getTutorialBabyGen(uint16 _dadGen) external pure returns (uint16);
27 
28     function getBreedingFee(uint40 _momId, uint40 _dadId) external view returns (uint256);
29 }
30 
31 
32 contract CutieCoreInterface
33 {
34     function isCutieCore() pure public returns (bool);
35 
36     ConfigInterface public config;
37 
38     function transferFrom(address _from, address _to, uint256 _cutieId) external;
39     function transfer(address _to, uint256 _cutieId) external;
40 
41     function ownerOf(uint256 _cutieId)
42         external
43         view
44         returns (address owner);
45 
46     function getCutie(uint40 _id)
47         external
48         view
49         returns (
50         uint256 genes,
51         uint40 birthTime,
52         uint40 cooldownEndTime,
53         uint40 momId,
54         uint40 dadId,
55         uint16 cooldownIndex,
56         uint16 generation
57     );
58 
59     function getGenes(uint40 _id)
60         public
61         view
62         returns (
63         uint256 genes
64     );
65 
66 
67     function getCooldownEndTime(uint40 _id)
68         public
69         view
70         returns (
71         uint40 cooldownEndTime
72     );
73 
74     function getCooldownIndex(uint40 _id)
75         public
76         view
77         returns (
78         uint16 cooldownIndex
79     );
80 
81 
82     function getGeneration(uint40 _id)
83         public
84         view
85         returns (
86         uint16 generation
87     );
88 
89     function getOptional(uint40 _id)
90         public
91         view
92         returns (
93         uint64 optional
94     );
95 
96 
97     function changeGenes(
98         uint40 _cutieId,
99         uint256 _genes)
100         public;
101 
102     function changeCooldownEndTime(
103         uint40 _cutieId,
104         uint40 _cooldownEndTime)
105         public;
106 
107     function changeCooldownIndex(
108         uint40 _cutieId,
109         uint16 _cooldownIndex)
110         public;
111 
112     function changeOptional(
113         uint40 _cutieId,
114         uint64 _optional)
115         public;
116 
117     function changeGeneration(
118         uint40 _cutieId,
119         uint16 _generation)
120         public;
121 
122     function createSaleAuction(
123         uint40 _cutieId,
124         uint128 _startPrice,
125         uint128 _endPrice,
126         uint40 _duration
127     )
128     public;
129 
130     function getApproved(uint256 _tokenId) external returns (address);
131     function totalSupply() view external returns (uint256);
132     function createPromoCutie(uint256 _genes, address _owner) external;
133     function checkOwnerAndApprove(address _claimant, uint40 _cutieId, address _pluginsContract) external view;
134     function breedWith(uint40 _momId, uint40 _dadId) public payable returns (uint40);
135     function getBreedingFee(uint40 _momId, uint40 _dadId) public view returns (uint256);
136 }
137 
138 
139 
140 
141 
142 
143 
144 /**
145  * @title Ownable
146  * @dev The Ownable contract has an owner address, and provides basic authorization control
147  * functions, this simplifies the implementation of "user permissions".
148  */
149 contract Ownable {
150   address public owner;
151 
152 
153   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
154 
155 
156   /**
157    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
158    * account.
159    */
160   constructor() public {
161     owner = msg.sender;
162   }
163 
164   /**
165    * @dev Throws if called by any account other than the owner.
166    */
167   modifier onlyOwner() {
168     require(msg.sender == owner);
169     _;
170   }
171 
172   /**
173    * @dev Allows the current owner to transfer control of the contract to a newOwner.
174    * @param newOwner The address to transfer ownership to.
175    */
176   function transferOwnership(address newOwner) public onlyOwner {
177     require(newOwner != address(0));
178     emit OwnershipTransferred(owner, newOwner);
179     owner = newOwner;
180   }
181 
182 }
183 
184 
185 
186 /**
187  * @title Pausable
188  * @dev Base contract which allows children to implement an emergency stop mechanism.
189  */
190 contract Pausable is Ownable {
191   event Pause();
192   event Unpause();
193 
194   bool public paused = false;
195 
196 
197   /**
198    * @dev Modifier to make a function callable only when the contract is not paused.
199    */
200   modifier whenNotPaused() {
201     require(!paused);
202     _;
203   }
204 
205   /**
206    * @dev Modifier to make a function callable only when the contract is paused.
207    */
208   modifier whenPaused() {
209     require(paused);
210     _;
211   }
212 
213   /**
214    * @dev called by the owner to pause, triggers stopped state
215    */
216   function pause() onlyOwner whenNotPaused public {
217     paused = true;
218     emit Pause();
219   }
220 
221   /**
222    * @dev called by the owner to unpause, returns to normal state
223    */
224   function unpause() onlyOwner whenPaused public {
225     paused = false;
226     emit Unpause();
227   }
228 }
229 
230 
231 
232 /// @title Auction Market for Blockchain Cuties.
233 /// @author https://BlockChainArchitect.io
234 contract MarketInterface 
235 {
236     function withdrawEthFromBalance() external;
237 
238     function createAuction(uint40 _cutieId, uint128 _startPrice, uint128 _endPrice, uint40 _duration, address _seller) public payable;
239     function createAuctionWithTokens(uint40 _cutieId, uint128 _startPrice, uint128 _endPrice, uint40 _duration, address _seller, address[] allowedTokens) public payable;
240 
241     function bid(uint40 _cutieId) public payable;
242 
243     function cancelActiveAuctionWhenPaused(uint40 _cutieId) public;
244 
245 	function getAuctionInfo(uint40 _cutieId)
246         public
247         view
248         returns
249     (
250         address seller,
251         uint128 startPrice,
252         uint128 endPrice,
253         uint40 duration,
254         uint40 startedAt,
255         uint128 featuringFee,
256         address[] allowedTokens
257     );
258 }
259 
260 
261 
262 // ----------------------------------------------------------------------------
263 // Contract function to receive approval and execute function in one call
264 //
265 // Borrowed from MiniMeToken
266 
267 interface TokenRecipientInterface
268 {
269     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
270 }
271 
272 
273 
274 // https://github.com/ethereum/EIPs/issues/223
275 interface TokenFallback
276 {
277     function tokenFallback(address _from, uint _value, bytes _data) external;
278 }
279 
280 
281 
282 
283 
284 // ----------------------------------------------------------------------------
285 contract ERC20 {
286 
287     // ERC Token Standard #223 Interface
288     // https://github.com/ethereum/EIPs/issues/223
289 
290     string public symbol;
291     string public  name;
292     uint8 public decimals;
293 
294     function transfer(address _to, uint _value, bytes _data) external returns (bool success);
295 
296     // approveAndCall
297     function approveAndCall(address spender, uint tokens, bytes data) external returns (bool success);
298 
299     // ERC Token Standard #20 Interface
300     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
301 
302 
303     function totalSupply() public constant returns (uint);
304     function balanceOf(address tokenOwner) public constant returns (uint balance);
305     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
306     function transfer(address to, uint tokens) public returns (bool success);
307     function approve(address spender, uint tokens) public returns (bool success);
308     function transferFrom(address from, address to, uint tokens) public returns (bool success);
309     event Transfer(address indexed from, address indexed to, uint tokens);
310     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
311 
312     // bulk operations
313     function transferBulk(address[] to, uint[] tokens) public;
314     function approveBulk(address[] spender, uint[] tokens) public;
315 }
316 
317 
318 interface TokenRegistryInterface
319 {
320     function getPriceInToken(ERC20 _tokenContract, uint128 priceWei) external view returns (uint128);
321     function areAllTokensAllowed(address[] _tokens) external view returns (bool);
322     function isTokenInList(address[] _allowedTokens, address _currentToken) external pure returns (bool);
323     function getAllSupportedTokens() external view returns (address[]);
324 }
325 
326 
327 /// @title Auction Market for Blockchain Cuties.
328 /// @author https://BlockChainArchitect.io
329 contract Market is MarketInterface, Pausable, TokenRecipientInterface, TokenFallback
330 {
331     // Shows the auction on an Cutie Token
332     struct Auction {
333         // Price (in wei or tokens) at the beginning of auction
334         uint128 startPrice;
335         // Price (in wei or tokens) at the end of auction
336         uint128 endPrice;
337         // Current owner of Token
338         address seller;
339         // Auction duration in seconds
340         uint40 duration;
341         // Time when auction started
342         // NOTE: 0 if this auction has been concluded
343         uint40 startedAt;
344         // Featuring fee (in wei, optional)
345         uint128 featuringFee;
346         // list of erc20 tokens addresses, that is allowed to bid with
347         address[] allowedTokens;
348     }
349 
350     // Reference to contract that tracks ownership
351     CutieCoreInterface public coreContract;
352 
353     // Cut owner takes on each auction, in basis points - 1/100 of a per cent.
354     // Values 0-10,000 map to 0%-100%
355     uint16 public ownerFee;
356 
357     // Map from token ID to their corresponding auction.
358     mapping (uint40 => Auction) public cutieIdToAuction;
359     TokenRegistryInterface public tokenRegistry;
360 
361 
362     address operatorAddress;
363 
364     event AuctionCreatedWithTokens(uint40 indexed cutieId, uint128 startPrice, uint128 endPrice, uint40 duration, uint128 fee, address[] allowedTokens);
365     event AuctionSuccessful(uint40 indexed cutieId, uint128 totalPriceWei, address indexed winner);
366     event AuctionSuccessfulForToken(uint40 indexed cutieId, uint128 totalPriceWei, address indexed winner, uint128 priceInTokens, address indexed token);
367     event AuctionCancelled(uint40 indexed cutieId);
368 
369     modifier onlyOperator() {
370         require(msg.sender == operatorAddress || msg.sender == owner);
371         _;
372     }
373 
374     function setOperator(address _newOperator) public onlyOwner {
375         require(_newOperator != address(0));
376 
377         operatorAddress = _newOperator;
378     }
379 
380     /// @dev disables sending fund to this contract
381     function() external {}
382 
383     modifier canBeStoredIn128Bits(uint256 _value) 
384     {
385         require(_value <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
386         _;
387     }
388 
389     // @dev Adds to the list of open auctions and fires the
390     //  AuctionCreated event.
391     // @param _cutieId The token ID is to be put on auction.
392     // @param _auction To add an auction.
393     // @param _fee Amount of money to feature auction
394     function _addAuction(uint40 _cutieId, Auction _auction) internal
395     {
396         if (_auction.duration == 0 && _auction.seller == address(coreContract))
397         {
398             _transfer(operatorAddress, _cutieId);
399             return;
400         }
401         // Require that all auctions have a duration of
402         // at least one minute. (Keeps our math from getting hairy!)
403         require(_auction.duration >= 1 minutes);
404 
405         cutieIdToAuction[_cutieId] = _auction;
406         
407         emit AuctionCreatedWithTokens(
408             _cutieId,
409             _auction.startPrice,
410             _auction.endPrice,
411             _auction.duration,
412             _auction.featuringFee,
413             _auction.allowedTokens
414         );
415     }
416 
417     // @dev Returns true if the token is claimed by the claimant.
418     // @param _claimant - Address claiming to own the token.
419     function _isOwner(address _claimant, uint256 _cutieId) internal view returns (bool)
420     {
421         return (coreContract.ownerOf(_cutieId) == _claimant);
422     }
423 
424     // @dev Transfers the token owned by this contract to another address.
425     // Returns true when the transfer succeeds.
426     // @param _receiver - Address to transfer token to.
427     // @param _cutieId - Token ID to transfer.
428     function _transfer(address _receiver, uint40 _cutieId) internal
429     {
430         // it will throw if transfer fails
431         coreContract.transfer(_receiver, _cutieId);
432     }
433 
434     // @dev Escrows the token and assigns ownership to this contract.
435     // Throws if the escrow fails.
436     // @param _owner - Current owner address of token to escrow.
437     // @param _cutieId - Token ID the approval of which is to be verified.
438     function _escrow(address _owner, uint40 _cutieId) internal
439     {
440         // it will throw if transfer fails
441         coreContract.transferFrom(_owner, this, _cutieId);
442     }
443 
444     // @dev just cancel auction.
445     function _cancelActiveAuction(uint40 _cutieId, address _seller) internal
446     {
447         _removeAuction(_cutieId);
448         _transfer(_seller, _cutieId);
449         emit AuctionCancelled(_cutieId);
450     }
451 
452     // @dev Calculates the price and transfers winnings.
453     // Does not transfer token ownership.
454     function _bid(uint40 _cutieId, uint128 _bidAmount)
455         internal
456         returns (uint128)
457     {
458         // Get a reference to the auction struct
459         Auction storage auction = cutieIdToAuction[_cutieId];
460 
461         require(_isOnAuction(auction));
462 
463         // Check that bid > current price
464         uint128 price = _currentPrice(auction);
465         require(_bidAmount >= price);
466 
467         // Provide a reference to the seller before the auction struct is deleted.
468         address seller = auction.seller;
469 
470         _removeAuction(_cutieId);
471 
472         // Transfer proceeds to seller (if there are any!)
473         if (price > 0 && seller != address(coreContract)) {
474             uint128 fee = _computeFee(price);
475             uint128 sellerValue = price - fee;
476 
477             seller.transfer(sellerValue);
478         }
479 
480         emit AuctionSuccessful(_cutieId, price, msg.sender);
481 
482         return price;
483     }
484 
485     // @dev Removes from the list of open auctions.
486     // @param _cutieId - ID of token on auction.
487     function _removeAuction(uint40 _cutieId) internal
488     {
489         delete cutieIdToAuction[_cutieId];
490     }
491 
492     // @dev Returns true if the token is on auction.
493     // @param _auction - Auction to check.
494     function _isOnAuction(Auction storage _auction) internal view returns (bool)
495     {
496         return (_auction.startedAt > 0);
497     }
498 
499     // @dev calculate current price of auction. 
500     //  When testing, make this function public and turn on
501     //  `Current price calculation` test suite.
502     function _computeCurrentPrice(
503         uint128 _startPrice,
504         uint128 _endPrice,
505         uint40 _duration,
506         uint40 _secondsPassed
507     )
508         internal
509         pure
510         returns (uint128)
511     {
512         if (_secondsPassed >= _duration) {
513             return _endPrice;
514         } else {
515             int256 totalPriceChange = int256(_endPrice) - int256(_startPrice);
516             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
517             uint128 currentPrice = _startPrice + uint128(currentPriceChange);
518             
519             return currentPrice;
520         }
521     }
522     // @dev return current price of token.
523     function _currentPrice(Auction storage _auction)
524         internal
525         view
526         returns (uint128)
527     {
528         uint40 secondsPassed = 0;
529 
530         uint40 timeNow = uint40(now);
531         if (timeNow > _auction.startedAt) {
532             secondsPassed = timeNow - _auction.startedAt;
533         }
534 
535         return _computeCurrentPrice(
536             _auction.startPrice,
537             _auction.endPrice,
538             _auction.duration,
539             secondsPassed
540         );
541     }
542 
543     // @dev Calculates owner's cut of a sale.
544     // @param _price - Sale price of cutie.
545     function _computeFee(uint128 _price) internal view returns (uint128)
546     {
547         return _price * ownerFee / 10000;
548     }
549 
550     // @dev Remove all Ether from the contract with the owner's cuts. Also, remove any Ether sent directly to the contract address.
551     //  Transfers to the token contract, but can be called by
552     //  the owner or the token contract.
553     function withdrawEthFromBalance() external
554     {
555         address coreAddress = address(coreContract);
556 
557         require(
558             msg.sender == owner ||
559             msg.sender == coreAddress
560         );
561         coreAddress.transfer(address(this).balance);
562     }
563 
564     // @dev create and start a new auction
565     // @param _cutieId - ID of cutie to auction, sender must be owner.
566     // @param _startPrice - Price of item (in wei) at the beginning of auction.
567     // @param _endPrice - Price of item (in wei) at the end of auction.
568     // @param _duration - Length of auction (in seconds). Most significant bit od duration is to allow sell for all tokens.
569     // @param _seller - Seller
570     function createAuction(uint40 _cutieId, uint128 _startPrice, uint128 _endPrice, uint40 _duration, address _seller)
571         public whenNotPaused payable
572     {
573         require(_isOwner(_seller, _cutieId));
574         _escrow(_seller, _cutieId);
575 
576         bool allowTokens = _duration < 0x8000000000; // first bit of duration is boolean flag (1 to disable tokens)
577         _duration = _duration % 0x8000000000; // clear flag from duration
578 
579         Auction memory auction = Auction(
580             _startPrice,
581             _endPrice,
582             _seller,
583             _duration,
584             uint40(now),
585             uint128(msg.value),
586             allowTokens ? tokenRegistry.getAllSupportedTokens() : new address[](0)
587         );
588         _addAuction(_cutieId, auction);
589     }
590 
591     // @dev create and start a new auction
592     // @param _cutieId - ID of cutie to auction, sender must be owner.
593     // @param _startPrice - Price of item (in wei) at the beginning of auction.
594     // @param _endPrice - Price of item (in wei) at the end of auction.
595     // @param _duration - Length of auction (in seconds).
596     // @param _seller - Seller
597     // @param _allowedTokens - list of tokens addresses, that can be used as currency to buy cutie.
598     function createAuctionWithTokens(
599         uint40 _cutieId,
600         uint128 _startPrice,
601         uint128 _endPrice,
602         uint40 _duration,
603         address _seller,
604         address[] _allowedTokens) public payable
605     {
606         require(tokenRegistry.areAllTokensAllowed(_allowedTokens));
607         require(_isOwner(_seller, _cutieId));
608         _escrow(_seller, _cutieId);
609 
610         Auction memory auction = Auction(
611             _startPrice,
612             _endPrice,
613             _seller,
614             _duration,
615             uint40(now),
616             uint128(msg.value),
617             _allowedTokens
618         );
619         _addAuction(_cutieId, auction);
620     }
621 
622     // @dev Set the reference to cutie ownership contract. Verify the owner's fee.
623     //  @param fee should be between 0-10,000.
624     function setup(address _coreContractAddress, TokenRegistryInterface _tokenRegistry, uint16 _fee) public onlyOwner
625     {
626         require(_fee <= 10000);
627 
628         ownerFee = _fee;
629         
630         CutieCoreInterface candidateContract = CutieCoreInterface(_coreContractAddress);
631         require(candidateContract.isCutieCore());
632         coreContract = candidateContract;
633         tokenRegistry = _tokenRegistry;
634     }
635 
636     // @dev Set the owner's fee.
637     //  @param fee should be between 0-10,000.
638     function setFee(uint16 _fee) public onlyOwner
639     {
640         require(_fee <= 10000);
641 
642         ownerFee = _fee;
643     }
644 
645     // @dev bid on auction. Complete it and transfer ownership of cutie if enough ether was given.
646     function bid(uint40 _cutieId) public payable whenNotPaused canBeStoredIn128Bits(msg.value)
647     {
648         // _bid throws if something failed.
649         _bid(_cutieId, uint128(msg.value));
650         _transfer(msg.sender, _cutieId);
651     }
652 
653     function getCutieId(bytes _extraData) pure internal returns (uint40)
654     {
655         require(_extraData.length == 5); // 40 bits
656 
657         return
658             uint40(_extraData[0]) +
659             uint40(_extraData[1]) * 0x100 +
660             uint40(_extraData[2]) * 0x10000 +
661             uint40(_extraData[3]) * 0x100000 +
662             uint40(_extraData[4]) * 0x10000000;
663     }
664 
665     function bidWithToken(address _tokenContract, uint40 _cutieId) external whenNotPaused
666     {
667         _bidWithToken(_tokenContract, _cutieId, msg.sender);
668     }
669 
670     function tokenFallback(address _sender, uint _value, bytes _extraData) external whenNotPaused
671     {
672         uint40 cutieId = getCutieId(_extraData);
673         address tokenContractAddress = msg.sender;
674         ERC20 tokenContract = ERC20(tokenContractAddress);
675 
676         // Get a reference to the auction struct
677         Auction storage auction = cutieIdToAuction[cutieId];
678 
679         require(tokenRegistry.isTokenInList(auction.allowedTokens, tokenContractAddress)); // buy for token is allowed
680 
681         require(_isOnAuction(auction));
682 
683         uint128 priceWei = _currentPrice(auction);
684 
685         uint128 priceInTokens = tokenRegistry.getPriceInToken(tokenContract, priceWei);
686 
687         // Check that bid > current price (this tokens are already sent to currect contract)
688         require(_value >= priceInTokens);
689 
690         // Provide a reference to the seller before the auction struct is deleted.
691         address seller = auction.seller;
692 
693         _removeAuction(cutieId);
694 
695         // send tokens to seller
696         if (seller != address(coreContract))
697         {
698             uint128 fee = _computeFee(priceInTokens);
699             uint128 sellerValue = priceInTokens - fee;
700 
701             tokenContract.transfer(seller, sellerValue);
702         }
703 
704         emit AuctionSuccessfulForToken(cutieId, priceWei, _sender, priceInTokens, tokenContractAddress);
705         _transfer(_sender, cutieId);
706     }
707 
708     // https://github.com/BitGuildPlatform/Documentation/blob/master/README.md#2-required-game-smart-contract-changes
709     // Function that is called when trying to use PLAT for payments from approveAndCall
710     function receiveApproval(address _sender, uint256 _value, address _tokenContract, bytes _extraData)
711         external
712         canBeStoredIn128Bits(_value)
713         whenNotPaused
714     {
715         uint40 cutieId = getCutieId(_extraData);
716         _bidWithToken(_tokenContract, cutieId, _sender);
717     }
718 
719     function _bidWithToken(address _tokenContract, uint40 _cutieId, address _sender) internal
720     {
721         ERC20 tokenContract = ERC20(_tokenContract);
722 
723         // Get a reference to the auction struct
724         Auction storage auction = cutieIdToAuction[_cutieId];
725 
726         require(tokenRegistry.isTokenInList(auction.allowedTokens, _tokenContract)); // buy for token is allowed
727 
728         require(_isOnAuction(auction));
729 
730         uint128 priceWei = _currentPrice(auction);
731 
732         uint128 priceInTokens = tokenRegistry.getPriceInToken(tokenContract, priceWei);
733 
734         // Check that bid > current price
735         //require(_value >= priceInTokens);
736 
737         // Provide a reference to the seller before the auction struct is deleted.
738         address seller = auction.seller;
739 
740         _removeAuction(_cutieId);
741 
742         require(tokenContract.transferFrom(_sender, address(this), priceInTokens));
743 
744         if (seller != address(coreContract))
745         {
746             uint128 fee = _computeFee(priceInTokens);
747             uint128 sellerValue = priceInTokens - fee;
748 
749             tokenContract.transfer(seller, sellerValue);
750         }
751 
752         emit AuctionSuccessfulForToken(_cutieId, priceWei, _sender, priceInTokens, _tokenContract);
753         _transfer(_sender, _cutieId);
754     }
755 
756     // @dev Returns auction info for a token on auction.
757     // @param _cutieId - ID of token on auction.
758     function getAuctionInfo(uint40 _cutieId)
759         public
760         view
761         returns
762     (
763         address seller,
764         uint128 startPrice,
765         uint128 endPrice,
766         uint40 duration,
767         uint40 startedAt,
768         uint128 featuringFee,
769         address[] allowedTokens
770     ) {
771         Auction storage auction = cutieIdToAuction[_cutieId];
772         require(_isOnAuction(auction));
773         return (
774             auction.seller,
775             auction.startPrice,
776             auction.endPrice,
777             auction.duration,
778             auction.startedAt,
779             auction.featuringFee,
780             auction.allowedTokens
781         );
782     }
783 
784     // @dev Returns auction info for a token on auction.
785     // @param _cutieId - ID of token on auction.
786     function isOnAuction(uint40 _cutieId)
787         public
788         view
789         returns (bool) 
790     {
791         return cutieIdToAuction[_cutieId].startedAt > 0;
792     }
793 
794 /*
795     /// @dev Import cuties from previous version of Core contract.
796     /// @param _oldAddress Old core contract address
797     /// @param _fromIndex (inclusive)
798     /// @param _toIndex (inclusive)
799     function migrate(address _oldAddress, uint40 _fromIndex, uint40 _toIndex) public onlyOwner whenPaused
800     {
801         Market old = Market(_oldAddress);
802 
803         for (uint40 i = _fromIndex; i <= _toIndex; i++)
804         {
805             if (coreContract.ownerOf(i) == _oldAddress)
806             {
807                 address seller;
808                 uint128 startPrice;
809                 uint128 endPrice;
810                 uint40 duration;
811                 uint40 startedAt;
812                 uint128 featuringFee;   
813                 (seller, startPrice, endPrice, duration, startedAt, featuringFee) = old.getAuctionInfo(i);
814 
815                 Auction memory auction = Auction({
816                     seller: seller, 
817                     startPrice: startPrice, 
818                     endPrice: endPrice, 
819                     duration: duration, 
820                     startedAt: startedAt, 
821                     featuringFee: featuringFee
822                 });
823                 _addAuction(i, auction);
824             }
825         }
826     }*/
827 
828     // @dev Returns the current price of an auction.
829     function getCurrentPrice(uint40 _cutieId)
830         public
831         view
832         returns (uint128)
833     {
834         Auction storage auction = cutieIdToAuction[_cutieId];
835         require(_isOnAuction(auction));
836         return _currentPrice(auction);
837     }
838 
839     // @dev Cancels unfinished auction and returns token to owner. 
840     // Can be called when contract is paused.
841     function cancelActiveAuction(uint40 _cutieId) public
842     {
843         Auction storage auction = cutieIdToAuction[_cutieId];
844         require(_isOnAuction(auction));
845         address seller = auction.seller;
846         require(msg.sender == seller);
847         _cancelActiveAuction(_cutieId, seller);
848     }
849 
850     // @dev Cancels auction when contract is on pause. Option is available only to owners in urgent situations. Tokens returned to seller.
851     //  Used on Core contract upgrade.
852     function cancelActiveAuctionWhenPaused(uint40 _cutieId) whenPaused onlyOwner public
853     {
854         Auction storage auction = cutieIdToAuction[_cutieId];
855         require(_isOnAuction(auction));
856         _cancelActiveAuction(_cutieId, auction.seller);
857     }
858 
859     // @dev Cancels unfinished auction and returns token to owner.
860     // Can be called when contract is paused.
861     function cancelCreatorAuction(uint40 _cutieId) public onlyOperator
862     {
863         Auction storage auction = cutieIdToAuction[_cutieId];
864         require(_isOnAuction(auction));
865         address seller = auction.seller;
866         require(seller == address(coreContract));
867         _cancelActiveAuction(_cutieId, msg.sender);
868     }
869 
870     // @dev Transfers to _withdrawToAddress all tokens controlled by
871     // contract _tokenContract.
872     function withdrawTokenFromBalance(ERC20 _tokenContract, address _withdrawToAddress) external
873     {
874         address coreAddress = address(coreContract);
875 
876         require(
877             msg.sender == owner ||
878             msg.sender == operatorAddress ||
879             msg.sender == coreAddress
880         );
881         uint256 balance = _tokenContract.balanceOf(address(this));
882         _tokenContract.transfer(_withdrawToAddress, balance);
883     }
884 
885     function isPluginInterface() public pure returns (bool)
886     {
887         return true;
888     }
889 
890     function onRemove() public {}
891 
892     function run(
893         uint40 /*_cutieId*/,
894         uint256 /*_parameter*/,
895         address /*_seller*/
896     )
897     public
898     payable
899     {
900         revert();
901     }
902 
903     function runSigned(
904         uint40 /*_cutieId*/,
905         uint256 /*_parameter*/,
906         address /*_owner*/
907     )
908     external
909     payable
910     {
911         revert();
912     }
913 
914     function withdraw() public
915     {
916         require(
917             msg.sender == owner ||
918             msg.sender == address(coreContract)
919         );
920         if (address(this).balance > 0)
921         {
922             address(coreContract).transfer(address(this).balance);
923         }
924     }
925 }
926 
927 
928 /// @title Auction market for cuties sale 
929 /// @author https://BlockChainArchitect.io
930 contract SaleMarket is Market
931 {
932     // @dev Sanity check reveals that the
933     //  auction in our setSaleAuctionAddress() call is right.
934     bool public isSaleMarket = true;
935 
936     // @dev LastSalePrice is updated if seller is the token contract.
937     // Otherwise, default bid method is used.
938     function bid(uint40 _cutieId)
939         public
940         payable
941         canBeStoredIn128Bits(msg.value)
942     {
943         // _bid verifies token ID size
944         _bid(_cutieId, uint128(msg.value));
945         _transfer(msg.sender, _cutieId);
946     }
947 }