1 pragma solidity ^0.4.24;
2 
3 contract ERC721Basic {
4     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
5     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
6     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
7 
8     function balanceOf(address _owner) public view returns (uint256 _balance);
9 
10     function ownerOf(uint256 _tokenId) public view returns (address _owner);
11 
12     function exists(uint256 _tokenId) public view returns (bool _exists);
13 
14     function approve(address _to, uint256 _tokenId) public;
15 
16     function getApproved(uint256 _tokenId) public view returns (address _operator);
17 
18     function setApprovalForAll(address _operator, bool _approved) public;
19 
20     function isApprovedForAll(address _owner, address _operator) public view returns (bool);
21 
22     function transferFrom(address _from, address _to, uint256 _tokenId) public;
23 
24     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
25 
26     //    function safeTransferFrom(
27     //        address _from,
28     //        address _to,
29     //        uint256 _tokenId,
30     //        bytes _data
31     //    )
32     //    public;
33 }
34 
35 /**
36  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
37  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
38  */
39 contract ERC721Enumerable is ERC721Basic {
40     function totalSupply() public view returns (uint256);
41 
42     function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
43 
44     function tokenByIndex(uint256 _index) public view returns (uint256);
45 }
46 
47 
48 /**
49  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
50  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
51  */
52 contract ERC721Metadata is ERC721Basic {
53     function name() public view returns (string _name);
54 
55     function symbol() public view returns (string _symbol);
56 
57     function tokenURI(uint256 _tokenId) public view returns (string);
58 }
59 
60 
61 /**
62  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
63  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
64  */
65 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
66 }
67 
68 contract ToonInterface is ERC721 {
69 
70     function isToonInterface() external pure returns (bool);
71 
72     /**
73     * @notice   Returns an address of the toon author. 0x0 if
74     *           the toon has been created by us.
75     */
76     function authorAddress() external view returns (address);
77 
78     /**
79     * @notice   Returns maximum supply. In other words there will
80     *           be never more toons that that number. It has to
81     *           be constant.
82     *           If there is no limit function returns 0.
83     */
84     function maxSupply() external view returns (uint256);
85 
86     function getToonInfo(uint _id) external view returns (
87         uint genes,
88         uint birthTime,
89         address owner
90     );
91 
92 }
93 
94 contract Ownable {
95     address public owner;
96 
97     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
98 
99     /**
100      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
101      * account.
102      */
103     constructor() public {
104         owner = msg.sender;
105     }
106 
107 
108     /**
109      * @dev Throws if called by any account other than the owner.
110      */
111     modifier onlyOwner() {
112         require(msg.sender == owner);
113         _;
114     }
115 
116 
117     /**
118      * @dev Allows the current owner to transfer control of the contract to a newOwner.
119      * @param newOwner The address to transfer ownership to.
120      */
121     function transferOwnership(address newOwner) public onlyOwner {
122         require(newOwner != address(0));
123         emit OwnershipTransferred(owner, newOwner);
124         owner = newOwner;
125     }
126 
127 }
128 
129 contract Pausable is Ownable {
130     event Pause();
131     event Unpause();
132 
133     bool public paused = false;
134 
135 
136     /**
137      * @dev modifier to allow actions only when the contract IS paused
138      */
139     modifier whenNotPaused() {
140         require(!paused);
141         _;
142     }
143 
144     /**
145      * @dev modifier to allow actions only when the contract IS NOT paused
146      */
147     modifier whenPaused {
148         require(paused);
149         _;
150     }
151 
152     /**
153      * @dev called by the owner to pause, triggers stopped state
154      */
155     function pause() public onlyOwner whenNotPaused returns (bool) {
156         paused = true;
157         emit Pause();
158         return true;
159     }
160 
161     /**
162      * @dev called by the owner to unpause, returns to normal state
163      */
164     function unpause() public onlyOwner whenPaused returns (bool) {
165         paused = false;
166         emit Unpause();
167         return true;
168     }
169 }
170 
171 contract Withdrawable {
172 
173     mapping(address => uint) private pendingWithdrawals;
174 
175     event Withdrawal(address indexed receiver, uint amount);
176     event BalanceChanged(address indexed _address, uint oldBalance, uint newBalance);
177 
178     /**
179     * Returns amount of wei that given address is able to withdraw.
180     */
181     function getPendingWithdrawal(address _address) public view returns (uint) {
182         return pendingWithdrawals[_address];
183     }
184 
185     /**
186     * Add pending withdrawal for an address.
187     */
188     function addPendingWithdrawal(address _address, uint _amount) internal {
189         require(_address != 0x0);
190 
191         uint oldBalance = pendingWithdrawals[_address];
192         pendingWithdrawals[_address] += _amount;
193 
194         emit BalanceChanged(_address, oldBalance, oldBalance + _amount);
195     }
196 
197     /**
198     * Withdraws all pending withdrawals.
199     */
200     function withdraw() external {
201         uint amount = getPendingWithdrawal(msg.sender);
202         require(amount > 0);
203 
204         pendingWithdrawals[msg.sender] = 0;
205         msg.sender.transfer(amount);
206 
207         emit Withdrawal(msg.sender, amount);
208         emit BalanceChanged(msg.sender, amount, 0);
209     }
210 
211 }
212 
213 contract ClockAuctionBase is Withdrawable, Pausable {
214 
215     // Represents an auction on an NFT
216     struct Auction {
217         // Address of a contract
218         address _contract;
219         // Current owner of NFT
220         address seller;
221         // Price (in wei) at beginning of auction
222         uint128 startingPrice;
223         // Price (in wei) at end of auction
224         uint128 endingPrice;
225         // Duration (in seconds) of auction
226         uint64 duration;
227         // Time when auction started
228         // NOTE: 0 if this auction has been concluded
229         uint64 startedAt;
230     }
231 
232     // Reference to contract tracking NFT ownership
233     ToonInterface[] public toonContracts;
234     mapping(address => uint256) addressToIndex;
235 
236     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
237     // Values 0-10,000 map to 0%-100%
238     uint256 public ownerCut;
239 
240     // Values 0-10,000 map to 0%-100%
241     // Author's share from the owner cut.
242     uint256 public authorShare;
243 
244     // Map from token ID to their corresponding auction.
245     //    mapping(uint256 => Auction) tokenIdToAuction;
246     mapping(address => mapping(uint256 => Auction)) tokenToAuction;
247 
248     event AuctionCreated(address indexed _contract, uint256 indexed tokenId,
249         uint256 startingPrice, uint256 endingPrice, uint256 duration);
250     event AuctionSuccessful(address indexed _contract, uint256 indexed tokenId,
251         uint256 totalPrice, address indexed winner);
252     event AuctionCancelled(address indexed _contract, uint256 indexed tokenId);
253 
254     /**
255     * @notice   Adds a new toon contract.
256     */
257     function addToonContract(address _toonContractAddress) external onlyOwner {
258         ToonInterface _interface = ToonInterface(_toonContractAddress);
259         require(_interface.isToonInterface());
260 
261         uint _index = toonContracts.push(_interface) - 1;
262         addressToIndex[_toonContractAddress] = _index;
263     }
264 
265     /// @dev Returns true if the claimant owns the token.
266     /// @param _contract - address of a toon contract
267     /// @param _claimant - Address claiming to own the token.
268     /// @param _tokenId - ID of token whose ownership to verify.
269     function _owns(address _contract, address _claimant, uint256 _tokenId)
270     internal
271     view
272     returns (bool) {
273         ToonInterface _interface = _interfaceByAddress(_contract);
274         address _owner = _interface.ownerOf(_tokenId);
275 
276         return (_owner == _claimant);
277     }
278 
279     /// @dev Escrows the NFT, assigning ownership to this contract.
280     /// Throws if the escrow fails.
281     /// @param _owner - Current owner address of token to escrow.
282     /// @param _tokenId - ID of token whose approval to verify.
283     function _escrow(address _contract, address _owner, uint256 _tokenId) internal {
284         ToonInterface _interface = _interfaceByAddress(_contract);
285         // it will throw if transfer fails
286         _interface.transferFrom(_owner, this, _tokenId);
287     }
288 
289     /// @dev Transfers an NFT owned by this contract to another address.
290     /// Returns true if the transfer succeeds.
291     /// @param _receiver - Address to transfer NFT to.
292     /// @param _tokenId - ID of token to transfer.
293     function _transfer(address _contract, address _receiver, uint256 _tokenId) internal {
294         ToonInterface _interface = _interfaceByAddress(_contract);
295         // it will throw if transfer fails
296         _interface.transferFrom(this, _receiver, _tokenId);
297     }
298 
299     /// @dev Adds an auction to the list of open auctions. Also fires the
300     ///  AuctionCreated event.
301     /// @param _tokenId The ID of the token to be put on auction.
302     /// @param _auction Auction to add.
303     function _addAuction(address _contract, uint256 _tokenId, Auction _auction) internal {
304         // Require that all auctions have a duration of
305         // at least one minute. (Keeps our math from getting hairy!)
306         require(_auction.duration >= 1 minutes);
307 
308         _isAddressSupportedContract(_contract);
309         tokenToAuction[_contract][_tokenId] = _auction;
310 
311         emit AuctionCreated(
312             _contract,
313             uint256(_tokenId),
314             uint256(_auction.startingPrice),
315             uint256(_auction.endingPrice),
316             uint256(_auction.duration)
317         );
318     }
319 
320     /// @dev Cancels an auction unconditionally.
321     function _cancelAuction(address _contract, uint256 _tokenId, address _seller) internal {
322         _removeAuction(_contract, _tokenId);
323         _transfer(_contract, _seller, _tokenId);
324         emit AuctionCancelled(_contract, _tokenId);
325     }
326 
327     /// @dev Computes the price and transfers winnings.
328     /// Does NOT transfer ownership of token.
329     function _bid(address _contract, uint256 _tokenId, uint256 _bidAmount)
330     internal
331     returns (uint256)
332     {
333         // Get a reference to the auction struct
334         Auction storage auction = tokenToAuction[_contract][_tokenId];
335         ToonInterface _interface = _interfaceByAddress(auction._contract);
336 
337         // Explicitly check that this auction is currently live.
338         // (Because of how Ethereum mappings work, we can't just count
339         // on the lookup above failing. An invalid _tokenId will just
340         // return an auction object that is all zeros.)
341         require(_isOnAuction(auction));
342 
343         // Check that the bid is greater than or equal to the current price
344         uint256 price = _currentPrice(auction);
345         require(_bidAmount >= price);
346 
347         // Grab a reference to the seller before the auction struct
348         // gets deleted.
349         address seller = auction.seller;
350 
351         // The bid is good! Remove the auction before sending the fees
352         // to the sender so we can't have a reentrancy attack.
353         _removeAuction(_contract, _tokenId);
354 
355         // Transfer proceeds to seller (if there are any!)
356         if (price > 0) {
357             // Calculate the auctioneer's cut.
358             // (NOTE: _computeCut() is guaranteed to return a
359             // value <= price, so this subtraction can't go negative.)
360             uint256 auctioneerCut;
361             uint256 authorCut;
362             uint256 sellerProceeds;
363             (auctioneerCut, authorCut, sellerProceeds) = _computeCut(_interface, price);
364 
365             if (authorCut > 0) {
366                 address authorAddress = _interface.authorAddress();
367                 addPendingWithdrawal(authorAddress, authorCut);
368             }
369 
370             addPendingWithdrawal(owner, auctioneerCut);
371 
372             // NOTE: Doing a transfer() in the middle of a complex
373             // method like this is generally discouraged because of
374             // reentrancy attacks and DoS attacks if the seller is
375             // a contract with an invalid fallback function. We explicitly
376             // guard against reentrancy attacks by removing the auction
377             // before calling transfer(), and the only thing the seller
378             // can DoS is the sale of their own asset! (And if it's an
379             // accident, they can call cancelAuction(). )
380             seller.transfer(sellerProceeds);
381         }
382 
383         // Calculate any excess funds included with the bid. If the excess
384         // is anything worth worrying about, transfer it back to bidder.
385         // NOTE: We checked above that the bid amount is greater than or
386         // equal to the price so this cannot underflow.
387         uint256 bidExcess = _bidAmount - price;
388 
389         // Return the funds. Similar to the previous transfer, this is
390         // not susceptible to a re-entry attack because the auction is
391         // removed before any transfers occur.
392         msg.sender.transfer(bidExcess);
393 
394         // Tell the world!
395         emit AuctionSuccessful(_contract, _tokenId, price, msg.sender);
396 
397         return price;
398     }
399 
400     /// @dev Removes an auction from the list of open auctions.
401     /// @param _tokenId - ID of NFT on auction.
402     function _removeAuction(address _contract, uint256 _tokenId) internal {
403         delete tokenToAuction[_contract][_tokenId];
404     }
405 
406     /// @dev Returns true if the NFT is on auction.
407     /// @param _auction - Auction to check.
408     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
409         return (_auction.startedAt > 0);
410     }
411 
412     /// @dev Returns current price of an NFT on auction. Broken into two
413     ///  functions (this one, that computes the duration from the auction
414     ///  structure, and the other that does the price computation) so we
415     ///  can easily test that the price computation works correctly.
416     function _currentPrice(Auction storage _auction)
417     internal
418     view
419     returns (uint256)
420     {
421         uint256 secondsPassed = 0;
422 
423         // A bit of insurance against negative values (or wraparound).
424         // Probably not necessary (since Ethereum guarnatees that the
425         // now variable doesn't ever go backwards).
426         if (now > _auction.startedAt) {
427             secondsPassed = now - _auction.startedAt;
428         }
429 
430         return _computeCurrentPrice(
431             _auction.startingPrice,
432             _auction.endingPrice,
433             _auction.duration,
434             secondsPassed
435         );
436     }
437 
438     /// @dev Computes the current price of an auction. Factored out
439     ///  from _currentPrice so we can run extensive unit tests.
440     ///  When testing, make this function public and turn on
441     ///  `Current price computation` test suite.
442     function _computeCurrentPrice(
443         uint256 _startingPrice,
444         uint256 _endingPrice,
445         uint256 _duration,
446         uint256 _secondsPassed
447     )
448     internal
449     pure
450     returns (uint256)
451     {
452         // NOTE: We don't use SafeMath (or similar) in this function because
453         //  all of our public functions carefully cap the maximum values for
454         //  time (at 64-bits) and currency (at 128-bits). _duration is
455         //  also known to be non-zero (see the require() statement in
456         //  _addAuction())
457         if (_secondsPassed >= _duration) {
458             // We've reached the end of the dynamic pricing portion
459             // of the auction, just return the end price.
460             return _endingPrice;
461         } else {
462             // Starting price can be higher than ending price (and often is!), so
463             // this delta can be negative.
464             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
465 
466             // This multiplication can't overflow, _secondsPassed will easily fit within
467             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
468             // will always fit within 256-bits.
469             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
470 
471             // currentPriceChange can be negative, but if so, will have a magnitude
472             // less that _startingPrice. Thus, this result will always end up positive.
473             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
474 
475             return uint256(currentPrice);
476         }
477     }
478 
479     /// @dev Computes owner's cut of a sale.
480     /// @param _price - Sale price of NFT.
481     function _computeCut(ToonInterface _interface, uint256 _price) internal view returns (
482         uint256 ownerCutValue,
483         uint256 authorCutValue,
484         uint256 sellerProceeds
485     ) {
486         // NOTE: We don't use SafeMath (or similar) in this function because
487         //  all of our entry functions carefully cap the maximum values for
488         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
489         //  statement in the ClockAuction constructor). The result of this
490         //  function is always guaranteed to be <= _price.
491 
492         uint256 _totalCut = _price * ownerCut / 10000;
493         uint256 _authorCut = 0;
494         uint256 _ownerCut = 0;
495         if (_interface.authorAddress() != 0x0) {
496             _authorCut = _totalCut * authorShare / 10000;
497         }
498 
499         _ownerCut = _totalCut - _authorCut;
500         uint256 _sellerProfit = _price - _ownerCut - _authorCut;
501         require(_sellerProfit + _ownerCut + _authorCut == _price);
502 
503         return (_ownerCut, _authorCut, _sellerProfit);
504     }
505 
506     function _interfaceByAddress(address _address) internal view returns (ToonInterface) {
507         uint _index = addressToIndex[_address];
508         ToonInterface _interface = toonContracts[_index];
509         require(_address == address(_interface));
510 
511         return _interface;
512     }
513 
514     function _isAddressSupportedContract(address _address) internal view returns (bool) {
515         uint _index = addressToIndex[_address];
516         ToonInterface _interface = toonContracts[_index];
517         return _address == address(_interface);
518     }
519 }
520 
521 contract ClockAuction is ClockAuctionBase {
522 
523     /// @dev The ERC-165 interface signature for ERC-721.
524     ///  Ref: https://github.com/ethereum/EIPs/issues/165
525     ///  Ref: https://github.com/ethereum/EIPs/issues/721
526     bytes4 constant InterfaceSignature_ERC721 = bytes4(0x9a20483d);
527 
528     bool public isSaleClockAuction = true;
529 
530     /// @dev Constructor creates a reference to the NFT ownership contract
531     ///  and verifies the owner cut is in the valid range.
532     /// @param _ownerCut - percent cut the owner takes on each auction, must be
533     ///  between 0-10,000.
534     /// @param _authorShare - percent share of the author of the toon.
535     ///  Calculated from the ownerCut
536     constructor(uint256 _ownerCut, uint256 _authorShare) public {
537         require(_ownerCut <= 10000);
538         require(_authorShare <= 10000);
539 
540         ownerCut = _ownerCut;
541         authorShare = _authorShare;
542     }
543 
544     /// @dev Creates and begins a new auction.
545     /// @param _tokenId - ID of token to auction, sender must be owner.
546     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
547     /// @param _endingPrice - Price of item (in wei) at end of auction.
548     /// @param _duration - Length of time to move between starting
549     ///  price and ending price (in seconds).
550     /// @param _seller - Seller, if not the message sender
551     function createAuction(
552         address _contract,
553         uint256 _tokenId,
554         uint256 _startingPrice,
555         uint256 _endingPrice,
556         uint256 _duration,
557         address _seller
558     )
559     external
560     whenNotPaused
561     {
562         require(_isAddressSupportedContract(_contract));
563         // Sanity check that no inputs overflow how many bits we've allocated
564         // to store them in the auction struct.
565         require(_startingPrice == uint256(uint128(_startingPrice)));
566         require(_endingPrice == uint256(uint128(_endingPrice)));
567         require(_duration == uint256(uint64(_duration)));
568 
569         _escrow(_contract, _seller, _tokenId);
570 
571         Auction memory auction = Auction(
572             _contract,
573             _seller,
574             uint128(_startingPrice),
575             uint128(_endingPrice),
576             uint64(_duration),
577             uint64(now)
578         );
579         _addAuction(_contract, _tokenId, auction);
580     }
581 
582     /// @dev Bids on an open auction, completing the auction and transferring
583     ///  ownership of the NFT if enough Ether is supplied.
584     /// @param _tokenId - ID of token to bid on.
585     function bid(address _contract, uint256 _tokenId)
586     external
587     payable
588     whenNotPaused
589     {
590         // _bid will throw if the bid or funds transfer fails
591         _bid(_contract, _tokenId, msg.value);
592         _transfer(_contract, msg.sender, _tokenId);
593     }
594 
595     /// @dev Cancels an auction that hasn't been won yet.
596     ///  Returns the NFT to original owner.
597     /// @notice This is a state-modifying function that can
598     ///  be called while the contract is paused.
599     /// @param _tokenId - ID of token on auction
600     function cancelAuction(address _contract, uint256 _tokenId)
601     external
602     {
603         Auction storage auction = tokenToAuction[_contract][_tokenId];
604         require(_isOnAuction(auction));
605         address seller = auction.seller;
606         require(msg.sender == seller);
607         _cancelAuction(_contract, _tokenId, seller);
608     }
609 
610     /// @dev Cancels an auction when the contract is paused.
611     ///  Only the owner may do this, and NFTs are returned to
612     ///  the seller. This should only be used in emergencies.
613     /// @param _tokenId - ID of the NFT on auction to cancel.
614     function cancelAuctionWhenPaused(address _contract, uint256 _tokenId)
615     whenPaused
616     onlyOwner
617     external
618     {
619         Auction storage auction = tokenToAuction[_contract][_tokenId];
620         require(_isOnAuction(auction));
621         _cancelAuction(_contract, _tokenId, auction.seller);
622     }
623 
624     /// @dev Returns auction info for an NFT on auction.
625     /// @param _tokenId - ID of NFT on auction.
626     function getAuction(address _contract, uint256 _tokenId)
627     external
628     view
629     returns
630     (
631         address seller,
632         uint256 startingPrice,
633         uint256 endingPrice,
634         uint256 duration,
635         uint256 startedAt,
636         uint256 currentPrice
637     ) {
638         Auction storage auction = tokenToAuction[_contract][_tokenId];
639 
640         if (!_isOnAuction(auction)) {
641             return (0x0, 0, 0, 0, 0, 0);
642         }
643 
644         return (
645         auction.seller,
646         auction.startingPrice,
647         auction.endingPrice,
648         auction.duration,
649         auction.startedAt,
650         getCurrentPrice(_contract, _tokenId)
651         );
652     }
653 
654     /// @dev Returns the current price of an auction.
655     /// @param _tokenId - ID of the token price we are checking.
656     function getCurrentPrice(address _contract, uint256 _tokenId)
657     public
658     view
659     returns (uint256)
660     {
661         Auction storage auction = tokenToAuction[_contract][_tokenId];
662         require(_isOnAuction(auction));
663         return _currentPrice(auction);
664     }
665 
666 }