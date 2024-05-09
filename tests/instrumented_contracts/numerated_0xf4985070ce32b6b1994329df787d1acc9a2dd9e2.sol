1 pragma solidity ^0.4.19;
2 
3 // File: contracts/erc/erc721/IERC721Base.sol
4 
5 /// @title ERC-721 Non-Fungible Token Standard
6 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
7 ///  Note: the ERC-165 identifier for this interface is 0x6466353c
8 interface IERC721Base /* is IERC165  */ {
9   /// @dev This emits when ownership of any NFT changes by any mechanism.
10   ///  This event emits when NFTs are created (`from` == 0) and destroyed
11   ///  (`to` == 0). Exception: during contract creation, any number of NFTs
12   ///  may be created and assigned without emitting Transfer. At the time of
13   ///  any transfer, the approved address for that NFT (if any) is reset to none.
14   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
15 
16   /// @dev This emits when the approved address for an NFT is changed or
17   ///  reaffirmed. The zero address indicates there is no approved address.
18   ///  When a Transfer event emits, this also indicates that the approved
19   ///  address for that NFT (if any) is reset to none.
20   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
21 
22   /// @dev This emits when an operator is enabled or disabled for an owner.
23   ///  The operator can manage all NFTs of the owner.
24   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
25 
26   /// @notice Count all NFTs assigned to an owner
27   /// @dev NFTs assigned to the zero address are considered invalid, and this
28   ///  function throws for queries about the zero address.
29   /// @param _owner An address for whom to query the balance
30   /// @return The number of NFTs owned by `_owner`, possibly zero
31   function balanceOf(address _owner) external view returns (uint256);
32 
33   /// @notice Find the owner of an NFT
34   /// @param _tokenId The identifier for an NFT
35   /// @dev NFTs assigned to zero address are considered invalid, and queries
36   ///  about them do throw.
37   /// @return The address of the owner of the NFT
38   function ownerOf(uint256 _tokenId) external view returns (address);
39 
40   /// @notice Transfers the ownership of an NFT from one address to another address
41   /// @dev Throws unless `msg.sender` is the current owner, an authorized
42   ///  operator, or the approved address for this NFT. Throws if `_from` is
43   ///  not the current owner. Throws if `_to` is the zero address. Throws if
44   ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
45   ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
46   ///  `onERC721Received` on `_to` and throws if the return value is not
47   ///  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
48   /// @param _from The current owner of the NFT
49   /// @param _to The new owner
50   /// @param _tokenId The NFT to transfer
51   /// @param _data Additional data with no specified format, sent in call to `_to`
52   // solium-disable-next-line arg-overflow
53   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) external payable;
54 
55   /// @notice Transfers the ownership of an NFT from one address to another address
56   /// @dev This works identically to the other function with an extra data parameter,
57   ///  except this function just sets data to []
58   /// @param _from The current owner of the NFT
59   /// @param _to The new owner
60   /// @param _tokenId The NFT to transfer
61   function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
62 
63   /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
64   ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
65   ///  THEY MAY BE PERMANENTLY LOST
66   /// @dev Throws unless `msg.sender` is the current owner, an authorized
67   ///  operator, or the approved address for this NFT. Throws if `_from` is
68   ///  not the current owner. Throws if `_to` is the zero address. Throws if
69   ///  `_tokenId` is not a valid NFT.
70   /// @param _from The current owner of the NFT
71   /// @param _to The new owner
72   /// @param _tokenId The NFT to transfer
73   function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
74 
75   /// @notice Set or reaffirm the approved address for an NFT
76   /// @dev The zero address indicates there is no approved address.
77   /// @dev Throws unless `msg.sender` is the current NFT owner, or an authorized
78   ///  operator of the current owner.
79   /// @param _approved The new approved NFT controller
80   /// @param _tokenId The NFT to approve
81   function approve(address _approved, uint256 _tokenId) external payable;
82 
83   /// @notice Enable or disable approval for a third party ("operator") to manage
84   ///  all your asset.
85   /// @dev Emits the ApprovalForAll event
86   /// @param _operator Address to add to the set of authorized operators.
87   /// @param _approved True if the operators is approved, false to revoke approval
88   function setApprovalForAll(address _operator, bool _approved) external;
89 
90   /// @notice Get the approved address for a single NFT
91   /// @dev Throws if `_tokenId` is not a valid NFT
92   /// @param _tokenId The NFT to find the approved address for
93   /// @return The approved address for this NFT, or the zero address if there is none
94   function getApproved(uint256 _tokenId) external view returns (address);
95 
96   /// @notice Query if an address is an authorized operator for another address
97   /// @param _owner The address that owns the NFTs
98   /// @param _operator The address that acts on behalf of the owner
99   /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
100   function isApprovedForAll(address _owner, address _operator) external view returns (bool);
101 }
102 
103 // File: zeppelin/contracts/ownership/Ownable.sol
104 
105 /**
106  * @title Ownable
107  * @dev The Ownable contract has an owner address, and provides basic authorization control
108  * functions, this simplifies the implementation of "user permissions".
109  */
110 contract Ownable {
111   address public owner;
112 
113 
114   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
115 
116 
117   /**
118    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
119    * account.
120    */
121   function Ownable() {
122     owner = msg.sender;
123   }
124 
125 
126   /**
127    * @dev Throws if called by any account other than the owner.
128    */
129   modifier onlyOwner() {
130     require(msg.sender == owner);
131     _;
132   }
133 
134 
135   /**
136    * @dev Allows the current owner to transfer control of the contract to a newOwner.
137    * @param newOwner The address to transfer ownership to.
138    */
139   function transferOwnership(address newOwner) onlyOwner public {
140     require(newOwner != address(0));
141     OwnershipTransferred(owner, newOwner);
142     owner = newOwner;
143   }
144 
145 }
146 
147 // File: zeppelin/contracts/lifecycle/Pausable.sol
148 
149 /**
150  * @title Pausable
151  * @dev Base contract which allows children to implement an emergency stop mechanism.
152  */
153 contract Pausable is Ownable {
154   event Pause();
155   event Unpause();
156 
157   bool public paused = false;
158 
159 
160   /**
161    * @dev Modifier to make a function callable only when the contract is not paused.
162    */
163   modifier whenNotPaused() {
164     require(!paused);
165     _;
166   }
167 
168   /**
169    * @dev Modifier to make a function callable only when the contract is paused.
170    */
171   modifier whenPaused() {
172     require(paused);
173     _;
174   }
175 
176   /**
177    * @dev called by the owner to pause, triggers stopped state
178    */
179   function pause() onlyOwner whenNotPaused public {
180     paused = true;
181     Pause();
182   }
183 
184   /**
185    * @dev called by the owner to unpause, returns to normal state
186    */
187   function unpause() onlyOwner whenPaused public {
188     paused = false;
189     Unpause();
190   }
191 }
192 
193 // File: zeppelin/contracts/ownership/HasNoEther.sol
194 
195 /**
196  * @title Contracts that should not own Ether
197  * @author Remco Bloemen <remco@2π.com>
198  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
199  * in the contract, it will allow the owner to reclaim this ether.
200  * @notice Ether can still be send to this contract by:
201  * calling functions labeled `payable`
202  * `selfdestruct(contract_address)`
203  * mining directly to the contract address
204 */
205 contract HasNoEther is Ownable {
206 
207   /**
208   * @dev Constructor that rejects incoming Ether
209   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
210   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
211   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
212   * we could use assembly to access msg.value.
213   */
214   function HasNoEther() payable {
215     require(msg.value == 0);
216   }
217 
218   /**
219    * @dev Disallows direct send by settings a default function without the `payable` flag.
220    */
221   function() external {
222   }
223 
224   /**
225    * @dev Transfer all Ether held by the contract to the owner.
226    */
227   function reclaimEther() external onlyOwner {
228     assert(owner.send(this.balance));
229   }
230 }
231 
232 // File: contracts/marketplace/AxieClockAuction.sol
233 
234 /// @title Clock auction for non-fungible tokens.
235 contract AxieClockAuction is HasNoEther, Pausable {
236 
237   // Represents an auction on an NFT
238   struct Auction {
239     // Current owner of NFT
240     address seller;
241     // Price (in wei) at beginning of auction
242     uint128 startingPrice;
243     // Price (in wei) at end of auction
244     uint128 endingPrice;
245     // Duration (in seconds) of auction
246     uint64 duration;
247     // Time when auction started
248     // NOTE: 0 if this auction has been concluded
249     uint64 startedAt;
250   }
251 
252   // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
253   // Values 0-10,000 map to 0%-100%
254   uint256 public ownerCut;
255 
256   // Map from token ID to their corresponding auction.
257   mapping (address => mapping (uint256 => Auction)) public auctions;
258 
259   event AuctionCreated(
260     address indexed _nftAddress,
261     uint256 indexed _tokenId,
262     uint256 _startingPrice,
263     uint256 _endingPrice,
264     uint256 _duration,
265     address _seller
266   );
267 
268   event AuctionSuccessful(
269     address indexed _nftAddress,
270     uint256 indexed _tokenId,
271     uint256 _totalPrice,
272     address _winner
273   );
274 
275   event AuctionCancelled(
276     address indexed _nftAddress,
277     uint256 indexed _tokenId
278   );
279 
280   /// @dev Constructor creates a reference to the NFT ownership contract
281   ///  and verifies the owner cut is in the valid range.
282   /// @param _ownerCut - percent cut the owner takes on each auction, must be
283   ///  between 0-10,000.
284   function AxieClockAuction(uint256 _ownerCut) public {
285     require(_ownerCut <= 10000);
286     ownerCut = _ownerCut;
287   }
288 
289   /// @dev DON'T give me your money.
290   function () external {}
291 
292   // Modifiers to check that inputs can be safely stored with a certain
293   // number of bits. We use constants and multiple modifiers to save gas.
294   modifier canBeStoredWith64Bits(uint256 _value) {
295     require(_value <= 18446744073709551615);
296     _;
297   }
298 
299   modifier canBeStoredWith128Bits(uint256 _value) {
300     require(_value < 340282366920938463463374607431768211455);
301     _;
302   }
303 
304   /// @dev Returns auction info for an NFT on auction.
305   /// @param _nftAddress - Address of the NFT.
306   /// @param _tokenId - ID of NFT on auction.
307   function getAuction(
308     address _nftAddress,
309     uint256 _tokenId
310   )
311     external
312     view
313     returns (
314       address seller,
315       uint256 startingPrice,
316       uint256 endingPrice,
317       uint256 duration,
318       uint256 startedAt
319     )
320   {
321     Auction storage _auction = auctions[_nftAddress][_tokenId];
322     require(_isOnAuction(_auction));
323     return (
324       _auction.seller,
325       _auction.startingPrice,
326       _auction.endingPrice,
327       _auction.duration,
328       _auction.startedAt
329     );
330   }
331 
332   /// @dev Returns the current price of an auction.
333   /// @param _nftAddress - Address of the NFT.
334   /// @param _tokenId - ID of the token price we are checking.
335   function getCurrentPrice(
336     address _nftAddress,
337     uint256 _tokenId
338   )
339     external
340     view
341     returns (uint256)
342   {
343     Auction storage _auction = auctions[_nftAddress][_tokenId];
344     require(_isOnAuction(_auction));
345     return _getCurrentPrice(_auction);
346   }
347 
348   /// @dev Creates and begins a new auction.
349   /// @param _nftAddress - address of a deployed contract implementing
350   ///  the Nonfungible Interface.
351   /// @param _tokenId - ID of token to auction, sender must be owner.
352   /// @param _startingPrice - Price of item (in wei) at beginning of auction.
353   /// @param _endingPrice - Price of item (in wei) at end of auction.
354   /// @param _duration - Length of time to move between starting
355   ///  price and ending price (in seconds).
356   function createAuction(
357     address _nftAddress,
358     uint256 _tokenId,
359     uint256 _startingPrice,
360     uint256 _endingPrice,
361     uint256 _duration
362   )
363     external
364     whenNotPaused
365     canBeStoredWith128Bits(_startingPrice)
366     canBeStoredWith128Bits(_endingPrice)
367     canBeStoredWith64Bits(_duration)
368   {
369     address _seller = msg.sender;
370     require(_owns(_nftAddress, _seller, _tokenId));
371     _escrow(_nftAddress, _seller, _tokenId);
372     Auction memory _auction = Auction(
373       _seller,
374       uint128(_startingPrice),
375       uint128(_endingPrice),
376       uint64(_duration),
377       uint64(now)
378     );
379     _addAuction(_nftAddress, _tokenId, _auction, _seller);
380   }
381 
382   /// @dev Bids on an open auction, completing the auction and transferring
383   ///  ownership of the NFT if enough Ether is supplied.
384   /// @param _nftAddress - address of a deployed contract implementing
385   ///  the Nonfungible Interface.
386   /// @param _tokenId - ID of token to bid on.
387   function bid(
388     address _nftAddress,
389     uint256 _tokenId
390   )
391     external
392     payable
393     whenNotPaused
394   {
395     // _bid will throw if the bid or funds transfer fails
396     _bid(_nftAddress, _tokenId, msg.value);
397     _transfer(_nftAddress, msg.sender, _tokenId);
398   }
399 
400   /// @dev Cancels an auction that hasn't been won yet.
401   ///  Returns the NFT to original owner.
402   /// @notice This is a state-modifying function that can
403   ///  be called while the contract is paused.
404   /// @param _nftAddress - Address of the NFT.
405   /// @param _tokenId - ID of token on auction
406   function cancelAuction(address _nftAddress, uint256 _tokenId) external {
407     Auction storage _auction = auctions[_nftAddress][_tokenId];
408     require(_isOnAuction(_auction));
409     require(msg.sender == _auction.seller);
410     _cancelAuction(_nftAddress, _tokenId, _auction.seller);
411   }
412 
413   /// @dev Cancels an auction when the contract is paused.
414   ///  Only the owner may do this, and NFTs are returned to
415   ///  the seller. This should only be used in emergencies.
416   /// @param _nftAddress - Address of the NFT.
417   /// @param _tokenId - ID of the NFT on auction to cancel.
418   function cancelAuctionWhenPaused(
419     address _nftAddress,
420     uint256 _tokenId
421   )
422     external
423     whenPaused
424     onlyOwner
425   {
426     Auction storage _auction = auctions[_nftAddress][_tokenId];
427     require(_isOnAuction(_auction));
428     _cancelAuction(_nftAddress, _tokenId, _auction.seller);
429   }
430 
431   /// @dev Returns true if the NFT is on auction.
432   /// @param _auction - Auction to check.
433   function _isOnAuction(Auction storage _auction) internal view returns (bool) {
434     return (_auction.startedAt > 0);
435   }
436 
437   /// @dev Gets the NFT object from an address, validating that implementsERC721 is true.
438   /// @param _nftAddress - Address of the NFT.
439   function _getNftContract(address _nftAddress) internal pure returns (IERC721Base) {
440     IERC721Base candidateContract = IERC721Base(_nftAddress);
441     // require(candidateContract.implementsERC721());
442     return candidateContract;
443   }
444 
445   /// @dev Returns current price of an NFT on auction. Broken into two
446   ///  functions (this one, that computes the duration from the auction
447   ///  structure, and the other that does the price computation) so we
448   ///  can easily test that the price computation works correctly.
449   function _getCurrentPrice(
450     Auction storage _auction
451   )
452     internal
453     view
454     returns (uint256)
455   {
456     uint256 _secondsPassed = 0;
457 
458     // A bit of insurance against negative values (or wraparound).
459     // Probably not necessary (since Ethereum guarantees that the
460     // now variable doesn't ever go backwards).
461     if (now > _auction.startedAt) {
462       _secondsPassed = now - _auction.startedAt;
463     }
464 
465     return _computeCurrentPrice(
466       _auction.startingPrice,
467       _auction.endingPrice,
468       _auction.duration,
469       _secondsPassed
470     );
471   }
472 
473   /// @dev Computes the current price of an auction. Factored out
474   ///  from _currentPrice so we can run extensive unit tests.
475   ///  When testing, make this function external and turn on
476   ///  `Current price computation` test suite.
477   function _computeCurrentPrice(
478     uint256 _startingPrice,
479     uint256 _endingPrice,
480     uint256 _duration,
481     uint256 _secondsPassed
482   )
483     internal
484     pure
485     returns (uint256)
486   {
487     // NOTE: We don't use SafeMath (or similar) in this function because
488     //  all of our external functions carefully cap the maximum values for
489     //  time (at 64-bits) and currency (at 128-bits). _duration is
490     //  also known to be non-zero (see the require() statement in
491     //  _addAuction())
492     if (_secondsPassed >= _duration) {
493       // We've reached the end of the dynamic pricing portion
494       // of the auction, just return the end price.
495       return _endingPrice;
496     } else {
497       // Starting price can be higher than ending price (and often is!), so
498       // this delta can be negative.
499       int256 _totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
500 
501       // This multiplication can't overflow, _secondsPassed will easily fit within
502       // 64-bits, and _totalPriceChange will easily fit within 128-bits, their product
503       // will always fit within 256-bits.
504       int256 _currentPriceChange = _totalPriceChange * int256(_secondsPassed) / int256(_duration);
505 
506       // _currentPriceChange can be negative, but if so, will have a magnitude
507       // less that _startingPrice. Thus, this result will always end up positive.
508       int256 _currentPrice = int256(_startingPrice) + _currentPriceChange;
509 
510       return uint256(_currentPrice);
511     }
512   }
513 
514   /// @dev Returns true if the claimant owns the token.
515   /// @param _nftAddress - The address of the NFT.
516   /// @param _claimant - Address claiming to own the token.
517   /// @param _tokenId - ID of token whose ownership to verify.
518   function _owns(address _nftAddress, address _claimant, uint256 _tokenId) private view returns (bool) {
519     IERC721Base _nftContract = _getNftContract(_nftAddress);
520     return (_nftContract.ownerOf(_tokenId) == _claimant);
521   }
522 
523   /// @dev Adds an auction to the list of open auctions. Also fires the
524   ///  AuctionCreated event.
525   /// @param _tokenId The ID of the token to be put on auction.
526   /// @param _auction Auction to add.
527   function _addAuction(
528     address _nftAddress,
529     uint256 _tokenId,
530     Auction _auction,
531     address _seller
532   ) internal {
533     // Require that all auctions have a duration of
534     // at least one minute. (Keeps our math from getting hairy!)
535     require(_auction.duration >= 1 minutes);
536 
537     auctions[_nftAddress][_tokenId] = _auction;
538 
539     AuctionCreated(
540       _nftAddress,
541       _tokenId,
542       uint256(_auction.startingPrice),
543       uint256(_auction.endingPrice),
544       uint256(_auction.duration),
545       _seller
546     );
547   }
548 
549   /// @dev Removes an auction from the list of open auctions.
550   /// @param _tokenId - ID of NFT on auction.
551   function _removeAuction(address _nftAddress, uint256 _tokenId) internal {
552     delete auctions[_nftAddress][_tokenId];
553   }
554 
555   /// @dev Cancels an auction unconditionally.
556   function _cancelAuction(address _nftAddress, uint256 _tokenId, address _seller) internal {
557     _removeAuction(_nftAddress, _tokenId);
558     _transfer(_nftAddress, _seller, _tokenId);
559     AuctionCancelled(_nftAddress, _tokenId);
560   }
561 
562   /// @dev Escrows the NFT, assigning ownership to this contract.
563   /// Throws if the escrow fails.
564   /// @param _nftAddress - The address of the NFT.
565   /// @param _owner - Current owner address of token to escrow.
566   /// @param _tokenId - ID of token whose approval to verify.
567   function _escrow(address _nftAddress, address _owner, uint256 _tokenId) private {
568     IERC721Base _nftContract = _getNftContract(_nftAddress);
569 
570     // It will throw if transfer fails
571     _nftContract.transferFrom(_owner, this, _tokenId);
572   }
573 
574   /// @dev Transfers an NFT owned by this contract to another address.
575   /// Returns true if the transfer succeeds.
576   /// @param _nftAddress - The address of the NFT.
577   /// @param _receiver - Address to transfer NFT to.
578   /// @param _tokenId - ID of token to transfer.
579   function _transfer(address _nftAddress, address _receiver, uint256 _tokenId) internal {
580     IERC721Base _nftContract = _getNftContract(_nftAddress);
581 
582     // It will throw if transfer fails
583     _nftContract.transferFrom(this, _receiver, _tokenId);
584   }
585 
586   /// @dev Computes owner's cut of a sale.
587   /// @param _price - Sale price of NFT.
588   function _computeCut(uint256 _price) internal view returns (uint256) {
589     // NOTE: We don't use SafeMath (or similar) in this function because
590     //  all of our entry functions carefully cap the maximum values for
591     //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
592     //  statement in the ClockAuction constructor). The result of this
593     //  function is always guaranteed to be <= _price.
594     return _price * ownerCut / 10000;
595   }
596 
597   /// @dev Computes the price and transfers winnings.
598   /// Does NOT transfer ownership of token.
599   function _bid(
600     address _nftAddress,
601     uint256 _tokenId,
602     uint256 _bidAmount
603   )
604     internal
605     returns (uint256)
606   {
607     // Get a reference to the auction struct
608     Auction storage _auction = auctions[_nftAddress][_tokenId];
609 
610     // Explicitly check that this auction is currently live.
611     // (Because of how Ethereum mappings work, we can't just count
612     // on the lookup above failing. An invalid _tokenId will just
613     // return an auction object that is all zeros.)
614     require(_isOnAuction(_auction));
615 
616     // Check that the incoming bid is higher than the current
617     // price
618     uint256 _price = _getCurrentPrice(_auction);
619     require(_bidAmount >= _price);
620 
621     // Grab a reference to the seller before the auction struct
622     // gets deleted.
623     address _seller = _auction.seller;
624 
625     // The bid is good! Remove the auction before sending the fees
626     // to the sender so we can't have a reentrancy attack.
627     _removeAuction(_nftAddress, _tokenId);
628 
629     // Transfer proceeds to seller (if there are any!)
630     if (_price > 0) {
631       //  Calculate the auctioneer's cut.
632       // (NOTE: _computeCut() is guaranteed to return a
633       //  value <= price, so this subtraction can't go negative.)
634       uint256 _auctioneerCut = _computeCut(_price);
635       uint256 _sellerProceeds = _price - _auctioneerCut;
636 
637       // NOTE: Doing a transfer() in the middle of a complex
638       // method like this is generally discouraged because of
639       // reentrancy attacks and DoS attacks if the seller is
640       // a contract with an invalid fallback function. We explicitly
641       // guard against reentrancy attacks by removing the auction
642       // before calling transfer(), and the only thing the seller
643       // can DoS is the sale of their own asset! (And if it's an
644       // accident, they can call cancelAuction(). )
645       _seller.transfer(_sellerProceeds);
646     }
647 
648     if (_bidAmount > _price) {
649       // Calculate any excess funds included with the bid. If the excess
650       // is anything worth worrying about, transfer it back to bidder.
651       // NOTE: We checked above that the bid amount is greater than or
652       // equal to the price so this cannot underflow.
653       uint256 _bidExcess = _bidAmount - _price;
654 
655       // Return the funds. Similar to the previous transfer, this is
656       // not susceptible to a re-entry attack because the auction is
657       // removed before any transfers occur.
658       msg.sender.transfer(_bidExcess);
659     }
660 
661     // Tell the world!
662     AuctionSuccessful(_nftAddress, _tokenId, _price, msg.sender);
663 
664     return _price;
665   }
666 }