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
667 
668 
669 
670 contract AccessControl is Ownable {
671     // This facet controls access control for CryptoKitties. There are four roles managed here:
672     //
673     //     - The CEO: The CEO can reassign other roles and change the addresses of our dependent smart
674     //         contracts. It is also the only role that can unpause the smart contract. It is initially
675     //         set to the address that created the smart contract in the KittyCore constructor.
676     //
677     //     - The CFO: The CFO can withdraw funds from KittyCore and its auction contracts.
678     //
679     //     - The COO: The COO can release gen0 kitties to auction, and mint promo cats.
680     //
681     // It should be noted that these roles are distinct without overlap in their access abilities, the
682     // abilities listed for each role above are exhaustive. In particular, while the CEO can assign any
683     // address to any role, the CEO address itself doesn't have the ability to act in those roles. This
684     // restriction is intentional so that we aren't tempted to use the CEO address frequently out of
685     // convenience. The less we use an address, the less likely it is that we somehow compromise the
686     // account.
687 
688     // The addresses of the accounts (or contracts) that can execute actions within each roles.
689     address public ceoAddress;
690     address public cfoAddress;
691     address public cooAddress;
692 
693     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
694     bool public paused = false;
695 
696     /// @dev Access modifier for CEO-only functionality
697     modifier onlyCEO() {
698         require(msg.sender == ceoAddress);
699         _;
700     }
701 
702     /// @dev Access modifier for CFO-only functionality
703     modifier onlyCFO() {
704         require(msg.sender == cfoAddress);
705         _;
706     }
707 
708     /// @dev Access modifier for COO-only functionality
709     modifier onlyCOO() {
710         require(msg.sender == cooAddress);
711         _;
712     }
713 
714     modifier onlyCLevel() {
715         require(
716             msg.sender == cooAddress ||
717             msg.sender == ceoAddress ||
718             msg.sender == cfoAddress
719         );
720         _;
721     }
722 
723     constructor() public {
724         ceoAddress = owner;
725         cfoAddress = owner;
726         cooAddress = owner;
727     }
728 
729     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
730     /// @param _newCEO The address of the new CEO
731     function setCEO(address _newCEO) external onlyCEO {
732         require(_newCEO != address(0));
733 
734         ceoAddress = _newCEO;
735     }
736 
737     /// @dev Assigns a new address to act as the CFO. Only available to the current CEO.
738     /// @param _newCFO The address of the new CFO
739     function setCFO(address _newCFO) external onlyCEO {
740         require(_newCFO != address(0));
741 
742         cfoAddress = _newCFO;
743     }
744 
745     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
746     /// @param _newCOO The address of the new COO
747     function setCOO(address _newCOO) external onlyCEO {
748         require(_newCOO != address(0));
749 
750         cooAddress = _newCOO;
751     }
752 
753     /*** Pausable functionality adapted from OpenZeppelin ***/
754 
755     /// @dev Modifier to allow actions only when the contract IS NOT paused
756     modifier whenNotPaused() {
757         require(!paused);
758         _;
759     }
760 
761     /// @dev Modifier to allow actions only when the contract IS paused
762     modifier whenPaused {
763         require(paused);
764         _;
765     }
766 
767     /// @dev Called by any "C-level" role to pause the contract. Used only when
768     ///  a bug or exploit is detected and we need to limit damage.
769     function pause() external onlyCLevel whenNotPaused {
770         paused = true;
771     }
772 
773     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
774     ///  one reason we may pause the contract is when CFO or COO accounts are
775     ///  compromised.
776     /// @notice This is public rather than external so it can be called by
777     ///  derived contracts.
778     function unpause() public onlyCEO whenPaused {
779         // can't unpause if contract was upgraded
780         paused = false;
781     }
782 }
783 
784 interface ERC165 {
785     /// @notice Query if a contract implements an interface
786     /// @param interfaceID The interface identifier, as specified in ERC-165
787     /// @dev Interface identification is specified in ERC-165. This function
788     ///  uses less than 30,000 gas.
789     /// @return `true` if the contract implements `interfaceID` and
790     ///  `interfaceID` is not 0xffffffff, `false` otherwise
791     function supportsInterface(bytes4 interfaceID) external view returns (bool);
792 }
793 
794 contract ERC165MappingImplementation is ERC165 {
795     /// @dev You must not set element 0xffffffff to true
796     mapping(bytes4 => bool) internal supportedInterfaces;
797 
798     constructor() internal {
799         supportedInterfaces[this.supportsInterface.selector] = true;
800     }
801 
802     function supportsInterface(bytes4 interfaceID) external view returns (bool) {
803         return supportedInterfaces[interfaceID];
804     }
805 }
806 
807 library SafeMath {
808 
809     /**
810     * @dev Multiplies two numbers, throws on overflow.
811     */
812     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
813         if (a == 0) {
814             return 0;
815         }
816         c = a * b;
817         assert(c / a == b);
818         return c;
819     }
820 
821     /**
822     * @dev Integer division of two numbers, truncating the quotient.
823     */
824     function div(uint256 a, uint256 b) internal pure returns (uint256) {
825         // assert(b > 0); // Solidity automatically throws when dividing by 0
826         // uint256 c = a / b;
827         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
828         return a / b;
829     }
830 
831     /**
832     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
833     */
834     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
835         assert(b <= a);
836         return a - b;
837     }
838 
839     /**
840     * @dev Adds two numbers, throws on overflow.
841     */
842     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
843         c = a + b;
844         assert(c >= a);
845         return c;
846     }
847 
848     function toString(uint i) internal pure returns (string){
849         if (i == 0) return "0";
850         uint j = i;
851         uint length;
852         while (j != 0){
853             length++;
854             j /= 10;
855         }
856         bytes memory bstr = new bytes(length);
857         uint k = length - 1;
858         while (i != 0){
859             bstr[k--] = byte(48 + i % 10);
860             i /= 10;
861         }
862         return string(bstr);
863     }
864 
865 }
866 
867 library AddressUtils {
868 
869     /**
870      * Returns whether the target address is a contract
871      * @dev This function will return false if invoked during the constructor of a contract,
872      *  as the code is not actually created until after the constructor finishes.
873      * @param addr address to check
874      * @return whether the target address is a contract
875      */
876     function isContract(address addr) internal view returns (bool) {
877         uint256 size;
878         // XXX Currently there is no better way to check if there is a contract in an address
879         // than to check the size of the code at that address.
880         // See https://ethereum.stackexchange.com/a/14016/36603
881         // for more details about how this works.
882         // TODO Check this again before the Serenity release, because all addresses will be
883         // contracts then.
884         assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
885         return size > 0;
886     }
887 
888 }
889 
890 contract ERC721Receiver {
891     /**
892      * @dev Magic value to be returned upon successful reception of an NFT
893      *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
894      *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
895      */
896     bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
897 
898     /**
899      * @notice Handle the receipt of an NFT
900      * @dev The ERC721 smart contract calls this function on the recipient
901      *  after a `safetransfer`. This function MAY throw to revert and reject the
902      *  transfer. This function MUST use 50,000 gas or less. Return of other
903      *  than the magic value MUST result in the transaction being reverted.
904      *  Note: the contract address is always the message sender.
905      * @param _from The sending address
906      * @param _tokenId The NFT identifier which is being transfered
907      * @param _data Additional data with no specified format
908      * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
909      */
910     function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
911 }
912 
913 contract ERC721BasicToken is ERC721Basic, ERC165MappingImplementation {
914     using SafeMath for uint256;
915     using AddressUtils for address;
916 
917     // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
918     // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
919     bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
920 
921     // Mapping from token ID to owner
922     mapping(uint256 => address) internal tokenOwner;
923 
924     // Mapping from token ID to approved address
925     mapping(uint256 => address) internal tokenApprovals;
926 
927     // Mapping from owner to number of owned token
928     mapping(address => uint256) internal ownedTokensCount;
929 
930     // Mapping from owner to operator approvals
931     mapping(address => mapping(address => bool)) internal operatorApprovals;
932 
933     /**
934      * @dev Guarantees msg.sender is owner of the given token
935      * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
936      */
937     modifier onlyOwnerOf(uint256 _tokenId) {
938         require(ownerOf(_tokenId) == msg.sender);
939         _;
940     }
941 
942     constructor() public {
943         supportedInterfaces[0x80ac58cd] = true;
944     }
945 
946     /**
947      * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
948      * @param _tokenId uint256 ID of the token to validate
949      */
950     modifier canTransfer(uint256 _tokenId) {
951         require(isApprovedOrOwner(msg.sender, _tokenId));
952         _;
953     }
954 
955     /**
956      * @dev Gets the balance of the specified address
957      * @param _owner address to query the balance of
958      * @return uint256 representing the amount owned by the passed address
959      */
960     function balanceOf(address _owner) public view returns (uint256) {
961         require(_owner != address(0));
962         return ownedTokensCount[_owner];
963     }
964 
965     /**
966      * @dev Gets the owner of the specified token ID
967      * @param _tokenId uint256 ID of the token to query the owner of
968      * @return owner address currently marked as the owner of the given token ID
969      */
970     function ownerOf(uint256 _tokenId) public view returns (address) {
971         address owner = tokenOwner[_tokenId];
972         require(owner != address(0));
973         return owner;
974     }
975 
976     /**
977      * @dev Returns whether the specified token exists
978      * @param _tokenId uint256 ID of the token to query the existence of
979      * @return whether the token exists
980      */
981     function exists(uint256 _tokenId) public view returns (bool) {
982         address owner = tokenOwner[_tokenId];
983         return owner != address(0);
984     }
985 
986     /**
987      * @dev Approves another address to transfer the given token ID
988      * @dev The zero address indicates there is no approved address.
989      * @dev There can only be one approved address per token at a given time.
990      * @dev Can only be called by the token owner or an approved operator.
991      * @param _to address to be approved for the given token ID
992      * @param _tokenId uint256 ID of the token to be approved
993      */
994     function approve(address _to, uint256 _tokenId) public {
995         address owner = ownerOf(_tokenId);
996         require(_to != owner);
997         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
998 
999         if (getApproved(_tokenId) != address(0) || _to != address(0)) {
1000             tokenApprovals[_tokenId] = _to;
1001             emit Approval(owner, _to, _tokenId);
1002         }
1003     }
1004 
1005     /**
1006      * @dev Gets the approved address for a token ID, or zero if no address set
1007      * @param _tokenId uint256 ID of the token to query the approval of
1008      * @return address currently approved for the given token ID
1009      */
1010     function getApproved(uint256 _tokenId) public view returns (address) {
1011         return tokenApprovals[_tokenId];
1012     }
1013 
1014     /**
1015      * @dev Sets or unsets the approval of a given operator
1016      * @dev An operator is allowed to transfer all tokens of the sender on their behalf
1017      * @param _to operator address to set the approval
1018      * @param _approved representing the status of the approval to be set
1019      */
1020     function setApprovalForAll(address _to, bool _approved) public {
1021         require(_to != msg.sender);
1022         operatorApprovals[msg.sender][_to] = _approved;
1023         emit ApprovalForAll(msg.sender, _to, _approved);
1024     }
1025 
1026     /**
1027      * @dev Tells whether an operator is approved by a given owner
1028      * @param _owner owner address which you want to query the approval of
1029      * @param _operator operator address which you want to query the approval of
1030      * @return bool whether the given operator is approved by the given owner
1031      */
1032     function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
1033         return operatorApprovals[_owner][_operator];
1034     }
1035 
1036     /**
1037      * @dev Transfers the ownership of a given token ID to another address
1038      * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
1039      * @dev Requires the msg sender to be the owner, approved, or operator
1040      * @param _from current owner of the token
1041      * @param _to address to receive the ownership of the given token ID
1042      * @param _tokenId uint256 ID of the token to be transferred
1043     */
1044     function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
1045         require(_from != address(0));
1046         require(_to != address(0));
1047 
1048         clearApproval(_from, _tokenId);
1049         removeTokenFrom(_from, _tokenId);
1050         addTokenTo(_to, _tokenId);
1051 
1052         emit Transfer(_from, _to, _tokenId);
1053     }
1054 
1055     /**
1056      * @dev Safely transfers the ownership of a given token ID to another address
1057      * @dev If the target address is a contract, it must implement `onERC721Received`,
1058      *  which is called upon a safe transfer, and return the magic value
1059      *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
1060      *  the transfer is reverted.
1061      * @dev Requires the msg sender to be the owner, approved, or operator
1062      * @param _from current owner of the token
1063      * @param _to address to receive the ownership of the given token ID
1064      * @param _tokenId uint256 ID of the token to be transferred
1065     */
1066     function safeTransferFrom(
1067         address _from,
1068         address _to,
1069         uint256 _tokenId
1070     )
1071     public
1072     canTransfer(_tokenId)
1073     {
1074         // solium-disable-next-line arg-overflow
1075         safeTransferFrom(_from, _to, _tokenId, "");
1076     }
1077 
1078     /**
1079      * @dev Safely transfers the ownership of a given token ID to another address
1080      * @dev If the target address is a contract, it must implement `onERC721Received`,
1081      *  which is called upon a safe transfer, and return the magic value
1082      *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
1083      *  the transfer is reverted.
1084      * @dev Requires the msg sender to be the owner, approved, or operator
1085      * @param _from current owner of the token
1086      * @param _to address to receive the ownership of the given token ID
1087      * @param _tokenId uint256 ID of the token to be transferred
1088      * @param _data bytes data to send along with a safe transfer check
1089      */
1090     function safeTransferFrom(
1091         address _from,
1092         address _to,
1093         uint256 _tokenId,
1094         bytes _data
1095     )
1096     public
1097     canTransfer(_tokenId)
1098     {
1099         transferFrom(_from, _to, _tokenId);
1100         // solium-disable-next-line arg-overflow
1101         require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
1102     }
1103 
1104     /**
1105      * @dev Returns whether the given spender can transfer a given token ID
1106      * @param _spender address of the spender to query
1107      * @param _tokenId uint256 ID of the token to be transferred
1108      * @return bool whether the msg.sender is approved for the given token ID,
1109      *  is an operator of the owner, or is the owner of the token
1110      */
1111     function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
1112         address owner = ownerOf(_tokenId);
1113         return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
1114     }
1115 
1116     /**
1117      * @dev Internal function to mint a new token
1118      * @dev Reverts if the given token ID already exists
1119      * @param _to The address that will own the minted token
1120      * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1121      */
1122     function _mint(address _to, uint256 _tokenId) internal {
1123         require(_to != address(0));
1124         addTokenTo(_to, _tokenId);
1125         emit Transfer(address(0), _to, _tokenId);
1126     }
1127 
1128     /**
1129      * @dev Internal function to clear current approval of a given token ID
1130      * @dev Reverts if the given address is not indeed the owner of the token
1131      * @param _owner owner of the token
1132      * @param _tokenId uint256 ID of the token to be transferred
1133      */
1134     function clearApproval(address _owner, uint256 _tokenId) internal {
1135         require(ownerOf(_tokenId) == _owner);
1136         if (tokenApprovals[_tokenId] != address(0)) {
1137             tokenApprovals[_tokenId] = address(0);
1138             emit Approval(_owner, address(0), _tokenId);
1139         }
1140     }
1141 
1142     /**
1143      * @dev Internal function to add a token ID to the list of a given address
1144      * @param _to address representing the new owner of the given token ID
1145      * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1146      */
1147     function addTokenTo(address _to, uint256 _tokenId) internal {
1148         require(tokenOwner[_tokenId] == address(0));
1149         tokenOwner[_tokenId] = _to;
1150         ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
1151     }
1152 
1153     /**
1154      * @dev Internal function to remove a token ID from the list of a given address
1155      * @param _from address representing the previous owner of the given token ID
1156      * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1157      */
1158     function removeTokenFrom(address _from, uint256 _tokenId) internal {
1159         require(ownerOf(_tokenId) == _from);
1160         ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
1161         tokenOwner[_tokenId] = address(0);
1162     }
1163 
1164     /**
1165      * @dev Internal function to invoke `onERC721Received` on a target address
1166      * @dev The call is not executed if the target address is not a contract
1167      * @param _from address representing the previous owner of the given token ID
1168      * @param _to target address that will receive the tokens
1169      * @param _tokenId uint256 ID of the token to be transferred
1170      * @param _data bytes optional data to send along with the call
1171      * @return whether the call correctly returned the expected magic value
1172      */
1173     function checkAndCallSafeTransfer(
1174         address _from,
1175         address _to,
1176         uint256 _tokenId,
1177         bytes _data
1178     )
1179     internal
1180     returns (bool)
1181     {
1182         if (!_to.isContract()) {
1183             return true;
1184         }
1185         bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
1186         return (retval == ERC721_RECEIVED);
1187     }
1188 }
1189 
1190 contract ERC721Token is ERC721, ERC721BasicToken {
1191 
1192     // Token name
1193     string internal name_;
1194 
1195     // Token symbol
1196     string internal symbol_;
1197 
1198     // Mapping from owner to list of owned token IDs
1199     mapping(address => uint256[]) internal ownedTokens;
1200 
1201     // Mapping from token ID to index of the owner tokens list
1202     mapping(uint256 => uint256) internal ownedTokensIndex;
1203 
1204     /**
1205      * @dev Constructor function
1206      */
1207     constructor(string _name, string _symbol) public {
1208         supportedInterfaces[0x5b5e139f] = true; // ERC721Metadata
1209         supportedInterfaces[0x780e9d63] = true; // ERC721Enumerable
1210 
1211         name_ = _name;
1212         symbol_ = _symbol;
1213     }
1214 
1215     /**
1216      * @dev Gets the token name
1217      * @return string representing the token name
1218      */
1219     function name() public view returns (string) {
1220         return name_;
1221     }
1222 
1223     /**
1224      * @dev Gets the token symbol
1225      * @return string representing the token symbol
1226      */
1227     function symbol() public view returns (string) {
1228         return symbol_;
1229     }
1230 
1231     /**
1232      * @dev Returns an URI for a given token ID
1233      * @dev Throws if the token ID does not exist. May return an empty string.
1234      * @param _tokenId uint256 ID of the token to query
1235      */
1236     function tokenURI(uint256 _tokenId) public view returns (string);
1237 
1238     /**
1239      * @dev Gets the token ID at a given index of the tokens list of the requested owner
1240      * @param _owner address owning the tokens list to be accessed
1241      * @param _index uint256 representing the index to be accessed of the requested tokens list
1242      * @return uint256 token ID at the given index of the tokens list owned by the requested address
1243      */
1244     function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
1245         require(_index < balanceOf(_owner));
1246         return ownedTokens[_owner][_index];
1247     }
1248 
1249     /**
1250      * @dev Gets the total amount of tokens stored by the contract
1251      * @return uint256 representing the total amount of tokens
1252      */
1253     function totalSupply() public view returns (uint256);
1254 
1255     /**
1256      * @dev Gets the token ID at a given index of all the tokens in this contract
1257      * @dev Reverts if the index is greater or equal to the total number of tokens
1258      * @param _index uint256 representing the index to be accessed of the tokens list
1259      * @return uint256 token ID at the given index of the tokens list
1260      */
1261     function tokenByIndex(uint256 _index) public view returns (uint256) {
1262         require(_index < totalSupply());
1263 
1264         //In our case id is an index and vice versa.
1265         return _index;
1266     }
1267 
1268     /**
1269      * @dev Internal function to add a token ID to the list of a given address
1270      * @param _to address representing the new owner of the given token ID
1271      * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1272      */
1273     function addTokenTo(address _to, uint256 _tokenId) internal {
1274         super.addTokenTo(_to, _tokenId);
1275         uint256 length = ownedTokens[_to].length;
1276         ownedTokens[_to].push(_tokenId);
1277         ownedTokensIndex[_tokenId] = length;
1278     }
1279 
1280     /**
1281      * @dev Internal function to remove a token ID from the list of a given address
1282      * @param _from address representing the previous owner of the given token ID
1283      * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1284      */
1285     function removeTokenFrom(address _from, uint256 _tokenId) internal {
1286         super.removeTokenFrom(_from, _tokenId);
1287 
1288         uint256 tokenIndex = ownedTokensIndex[_tokenId];
1289         uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
1290         uint256 lastToken = ownedTokens[_from][lastTokenIndex];
1291 
1292         ownedTokens[_from][tokenIndex] = lastToken;
1293         ownedTokens[_from][lastTokenIndex] = 0;
1294         // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
1295         // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
1296         // the lastToken to the first position, and then dropping the element placed in the last position of the list
1297 
1298         ownedTokens[_from].length--;
1299         ownedTokensIndex[_tokenId] = 0;
1300         ownedTokensIndex[lastToken] = tokenIndex;
1301     }
1302 
1303 }
1304 
1305 library StringUtils {
1306 
1307     struct slice {
1308         uint _len;
1309         uint _ptr;
1310     }
1311 
1312     /*
1313      * @dev Returns a slice containing the entire string.
1314      * @param self The string to make a slice from.
1315      * @return A newly allocated slice containing the entire string.
1316      */
1317     function toSlice(string memory self) internal pure returns (slice memory) {
1318         uint ptr;
1319         assembly {
1320             ptr := add(self, 0x20)
1321         }
1322         return slice(bytes(self).length, ptr);
1323     }
1324 
1325     /*
1326      * @dev Returns a newly allocated string containing the concatenation of
1327      *      `self` and `other`.
1328      * @param self The first slice to concatenate.
1329      * @param other The second slice to concatenate.
1330      * @return The concatenation of the two strings.
1331      */
1332     function concat(slice memory self, slice memory other) internal pure returns (string memory) {
1333         string memory ret = new string(self._len + other._len);
1334         uint retptr;
1335         assembly { retptr := add(ret, 32) }
1336         memcpy(retptr, self._ptr, self._len);
1337         memcpy(retptr + self._len, other._ptr, other._len);
1338         return ret;
1339     }
1340 
1341     function memcpy(uint dest, uint src, uint len) private pure {
1342         // Copy word-length chunks while possible
1343         for(; len >= 32; len -= 32) {
1344             assembly {
1345                 mstore(dest, mload(src))
1346             }
1347             dest += 32;
1348             src += 32;
1349         }
1350 
1351         // Copy remaining bytes
1352         uint mask = 256 ** (32 - len) - 1;
1353         assembly {
1354             let srcpart := and(mload(src), not(mask))
1355             let destpart := and(mload(dest), mask)
1356             mstore(dest, or(destpart, srcpart))
1357         }
1358     }
1359 
1360 }
1361 
1362 contract ToonBase is ERC721Token, AccessControl, ToonInterface {
1363 
1364     using StringUtils for *;
1365     using SafeMath for uint;
1366 
1367     Toon[] private toons;
1368     uint public maxSupply;
1369     uint32 public maxPromoToons;
1370     address public authorAddress;
1371 
1372     string public endpoint = "https://mindhouse.io:3100/metadata/";
1373 
1374     constructor(string _name, string _symbol, uint _maxSupply, uint32 _maxPromoToons, address _author)
1375     public
1376     ERC721Token(_name, _symbol) {
1377         require(_maxPromoToons <= _maxSupply);
1378 
1379         maxSupply = _maxSupply;
1380         maxPromoToons = _maxPromoToons;
1381         authorAddress = _author;
1382     }
1383 
1384     function maxSupply() external view returns (uint) {
1385         return maxSupply;
1386     }
1387 
1388     /**
1389      * @dev Gets the total amount of tokens stored by the contract
1390      * @return uint256 representing the total amount of tokens
1391      */
1392     function totalSupply() public view returns (uint256) {
1393         return toons.length;
1394     }
1395 
1396     /**
1397      * @dev Returns an URI for a given token ID
1398      * @dev Throws if the token ID does not exist. May return an empty string.
1399      * @param _tokenId uint256 ID of the token to query
1400      */
1401     function tokenURI(uint256 _tokenId) public view returns (string) {
1402         require(exists(_tokenId));
1403         string memory slash = "/";
1404         return endpoint.toSlice().concat(name_.toSlice()).toSlice().concat(slash.toSlice()).toSlice().concat(_tokenId.toString().toSlice());
1405     }
1406 
1407     function authorAddress() external view returns (address) {
1408         return authorAddress;
1409     }
1410 
1411     function changeEndpoint(string newEndpoint) external onlyOwner {
1412         endpoint = newEndpoint;
1413     }
1414 
1415     function isToonInterface() external pure returns (bool) {
1416         return true;
1417     }
1418 
1419     function _getToon(uint _id) internal view returns (Toon){
1420         require(_id <= totalSupply());
1421         return toons[_id];
1422     }
1423 
1424     function _createToon(uint _genes, address _owner) internal {
1425         require(totalSupply() < maxSupply);
1426 
1427         Toon memory _toon = Toon(_genes, now);
1428         uint id = toons.push(_toon) - 1;
1429 
1430         _mint(_owner, id);
1431     }
1432 
1433     struct Toon {
1434         uint256 genes;
1435 
1436         uint256 birthTime;
1437     }
1438 }
1439 
1440 library SafeMath32 {
1441 
1442 
1443     /**
1444     * @dev Multiplies two numbers, throws on overflow.
1445     */
1446     function mul(uint32 a, uint32 b) internal pure returns (uint32 c) {
1447         if (a == 0) {
1448             return 0;
1449         }
1450         c = a * b;
1451         assert(c / a == b);
1452         return c;
1453     }
1454 
1455     /**
1456     * @dev Integer division of two numbers, truncating the quotient.
1457     */
1458     function div(uint32 a, uint32 b) internal pure returns (uint32) {
1459         // assert(b > 0); // Solidity automatically throws when dividing by 0
1460         // uint32 c = a / b;
1461         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1462         return a / b;
1463     }
1464 
1465     /**
1466     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1467     */
1468     function sub(uint32 a, uint32 b) internal pure returns (uint32) {
1469         assert(b <= a);
1470         return a - b;
1471     }
1472 
1473     /**
1474     * @dev Adds two numbers, throws on overflow.
1475     */
1476     function add(uint32 a, uint32 b) internal pure returns (uint32 c) {
1477         c = a + b;
1478         assert(c >= a);
1479         return c;
1480     }
1481 
1482 }
1483 
1484 contract ToonMinting is ToonBase {
1485     using SafeMath32 for uint32;
1486 
1487     uint32 public promoToonsMinted = 0;
1488 
1489     constructor(string _name, string _symbol, uint _maxSupply, uint32 _maxPromoToons, address _author)
1490     public
1491     ToonBase(_name, _symbol, _maxSupply, _maxPromoToons, _author) {
1492     }
1493 
1494     function createPromoToon(uint _genes, address _owner) external onlyCOO {
1495         require(promoToonsMinted < maxPromoToons);
1496         address _toonOwner = _owner;
1497         if (_toonOwner == 0x0) {
1498             _toonOwner = cooAddress;
1499         }
1500 
1501         _createToon(_genes, _toonOwner);
1502         promoToonsMinted = promoToonsMinted.add(1);
1503     }
1504 
1505 }
1506 
1507 contract ToonAuction is ToonMinting {
1508 
1509     ClockAuction public saleAuction;
1510 
1511     constructor(string _name, string _symbol, uint _maxSupply, uint32 _maxPromoToons, address _author)
1512     public
1513     ToonMinting(_name, _symbol, _maxSupply, _maxPromoToons, _author) {
1514     }
1515 
1516     function setSaleAuctionAddress(address _address) external onlyCEO {
1517         ClockAuction candidateContract = ClockAuction(_address);
1518         require(candidateContract.isSaleClockAuction());
1519 
1520         // Set the new contract address
1521         saleAuction = candidateContract;
1522     }
1523 
1524     function createSaleAuction(
1525         uint256 _toonId,
1526         uint256 _startingPrice,
1527         uint256 _endingPrice,
1528         uint256 _duration
1529     )
1530     external
1531     whenNotPaused
1532     {
1533         // Auction contract checks input sizes
1534         // If toon is already on any auction, this will throw
1535         // because it will be owned by the auction contract.
1536         require(ownerOf(_toonId) == msg.sender);
1537         approve(saleAuction, _toonId);
1538 
1539         // Sale auction throws if inputs are invalid and clears
1540         // transfer approval after escrowing the toon.
1541         saleAuction.createAuction(
1542             this,
1543             _toonId,
1544             _startingPrice,
1545             _endingPrice,
1546             _duration,
1547             msg.sender
1548         );
1549     }
1550 
1551 }
1552 
1553 contract CryptoToon is ToonAuction {
1554 
1555     constructor(string _name, string _symbol, uint _maxSupply, uint32 _maxPromoToons, address _author)
1556     public
1557     ToonAuction(_name, _symbol, _maxSupply, _maxPromoToons, _author) {
1558     }
1559 
1560     function getToonInfo(uint _id) external view returns (
1561         uint genes,
1562         uint birthTime,
1563         address owner
1564     ) {
1565         Toon memory _toon = _getToon(_id);
1566         return (_toon.genes, _toon.birthTime, ownerOf(_id));
1567     }
1568 
1569 }