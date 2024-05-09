1 pragma solidity ^0.4.23;
2 
3 // File: contracts/breeding/AxieIncubatorInterface.sol
4 
5 interface AxieIncubatorInterface {
6   function breedingFee() external view returns (uint256);
7 
8   function requireEnoughExpForBreeding(
9     uint256 _axieId
10   )
11     external
12     view;
13 
14   function breedAxies(
15     uint256 _sireId,
16     uint256 _matronId,
17     uint256 _birthPlace
18   )
19     external
20     payable
21     returns (uint256 _axieId);
22 }
23 
24 // File: contracts/erc/erc721/IERC721Base.sol
25 
26 /// @title ERC-721 Non-Fungible Token Standard
27 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
28 ///  Note: the ERC-165 identifier for this interface is 0x6466353c
29 interface IERC721Base /* is IERC165  */ {
30   /// @dev This emits when ownership of any NFT changes by any mechanism.
31   ///  This event emits when NFTs are created (`from` == 0) and destroyed
32   ///  (`to` == 0). Exception: during contract creation, any number of NFTs
33   ///  may be created and assigned without emitting Transfer. At the time of
34   ///  any transfer, the approved address for that NFT (if any) is reset to none.
35   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
36 
37   /// @dev This emits when the approved address for an NFT is changed or
38   ///  reaffirmed. The zero address indicates there is no approved address.
39   ///  When a Transfer event emits, this also indicates that the approved
40   ///  address for that NFT (if any) is reset to none.
41   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
42 
43   /// @dev This emits when an operator is enabled or disabled for an owner.
44   ///  The operator can manage all NFTs of the owner.
45   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
46 
47   /// @notice Count all NFTs assigned to an owner
48   /// @dev NFTs assigned to the zero address are considered invalid, and this
49   ///  function throws for queries about the zero address.
50   /// @param _owner An address for whom to query the balance
51   /// @return The number of NFTs owned by `_owner`, possibly zero
52   function balanceOf(address _owner) external view returns (uint256);
53 
54   /// @notice Find the owner of an NFT
55   /// @param _tokenId The identifier for an NFT
56   /// @dev NFTs assigned to zero address are considered invalid, and queries
57   ///  about them do throw.
58   /// @return The address of the owner of the NFT
59   function ownerOf(uint256 _tokenId) external view returns (address);
60 
61   /// @notice Transfers the ownership of an NFT from one address to another address
62   /// @dev Throws unless `msg.sender` is the current owner, an authorized
63   ///  operator, or the approved address for this NFT. Throws if `_from` is
64   ///  not the current owner. Throws if `_to` is the zero address. Throws if
65   ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
66   ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
67   ///  `onERC721Received` on `_to` and throws if the return value is not
68   ///  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
69   /// @param _from The current owner of the NFT
70   /// @param _to The new owner
71   /// @param _tokenId The NFT to transfer
72   /// @param _data Additional data with no specified format, sent in call to `_to`
73   // solium-disable-next-line arg-overflow
74   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) external payable;
75 
76   /// @notice Transfers the ownership of an NFT from one address to another address
77   /// @dev This works identically to the other function with an extra data parameter,
78   ///  except this function just sets data to []
79   /// @param _from The current owner of the NFT
80   /// @param _to The new owner
81   /// @param _tokenId The NFT to transfer
82   function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
83 
84   /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
85   ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
86   ///  THEY MAY BE PERMANENTLY LOST
87   /// @dev Throws unless `msg.sender` is the current owner, an authorized
88   ///  operator, or the approved address for this NFT. Throws if `_from` is
89   ///  not the current owner. Throws if `_to` is the zero address. Throws if
90   ///  `_tokenId` is not a valid NFT.
91   /// @param _from The current owner of the NFT
92   /// @param _to The new owner
93   /// @param _tokenId The NFT to transfer
94   function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
95 
96   /// @notice Set or reaffirm the approved address for an NFT
97   /// @dev The zero address indicates there is no approved address.
98   /// @dev Throws unless `msg.sender` is the current NFT owner, or an authorized
99   ///  operator of the current owner.
100   /// @param _approved The new approved NFT controller
101   /// @param _tokenId The NFT to approve
102   function approve(address _approved, uint256 _tokenId) external payable;
103 
104   /// @notice Enable or disable approval for a third party ("operator") to manage
105   ///  all your asset.
106   /// @dev Emits the ApprovalForAll event
107   /// @param _operator Address to add to the set of authorized operators.
108   /// @param _approved True if the operators is approved, false to revoke approval
109   function setApprovalForAll(address _operator, bool _approved) external;
110 
111   /// @notice Get the approved address for a single NFT
112   /// @dev Throws if `_tokenId` is not a valid NFT
113   /// @param _tokenId The NFT to find the approved address for
114   /// @return The approved address for this NFT, or the zero address if there is none
115   function getApproved(uint256 _tokenId) external view returns (address);
116 
117   /// @notice Query if an address is an authorized operator for another address
118   /// @param _owner The address that owns the NFTs
119   /// @param _operator The address that acts on behalf of the owner
120   /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
121   function isApprovedForAll(address _owner, address _operator) external view returns (bool);
122 }
123 
124 // File: zeppelin/contracts/ownership/Ownable.sol
125 
126 /**
127  * @title Ownable
128  * @dev The Ownable contract has an owner address, and provides basic authorization control
129  * functions, this simplifies the implementation of "user permissions".
130  */
131 contract Ownable {
132   address public owner;
133 
134 
135   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
136 
137 
138   /**
139    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
140    * account.
141    */
142   function Ownable() {
143     owner = msg.sender;
144   }
145 
146 
147   /**
148    * @dev Throws if called by any account other than the owner.
149    */
150   modifier onlyOwner() {
151     require(msg.sender == owner);
152     _;
153   }
154 
155 
156   /**
157    * @dev Allows the current owner to transfer control of the contract to a newOwner.
158    * @param newOwner The address to transfer ownership to.
159    */
160   function transferOwnership(address newOwner) onlyOwner public {
161     require(newOwner != address(0));
162     OwnershipTransferred(owner, newOwner);
163     owner = newOwner;
164   }
165 
166 }
167 
168 // File: zeppelin/contracts/lifecycle/Pausable.sol
169 
170 /**
171  * @title Pausable
172  * @dev Base contract which allows children to implement an emergency stop mechanism.
173  */
174 contract Pausable is Ownable {
175   event Pause();
176   event Unpause();
177 
178   bool public paused = false;
179 
180 
181   /**
182    * @dev Modifier to make a function callable only when the contract is not paused.
183    */
184   modifier whenNotPaused() {
185     require(!paused);
186     _;
187   }
188 
189   /**
190    * @dev Modifier to make a function callable only when the contract is paused.
191    */
192   modifier whenPaused() {
193     require(paused);
194     _;
195   }
196 
197   /**
198    * @dev called by the owner to pause, triggers stopped state
199    */
200   function pause() onlyOwner whenNotPaused public {
201     paused = true;
202     Pause();
203   }
204 
205   /**
206    * @dev called by the owner to unpause, returns to normal state
207    */
208   function unpause() onlyOwner whenPaused public {
209     paused = false;
210     Unpause();
211   }
212 }
213 
214 // File: zeppelin/contracts/ownership/HasNoContracts.sol
215 
216 /**
217  * @title Contracts that should not own Contracts
218  * @author Remco Bloemen <remco@2π.com>
219  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
220  * of this contract to reclaim ownership of the contracts.
221  */
222 contract HasNoContracts is Ownable {
223 
224   /**
225    * @dev Reclaim ownership of Ownable contracts
226    * @param contractAddr The address of the Ownable to be reclaimed.
227    */
228   function reclaimContract(address contractAddr) external onlyOwner {
229     Ownable contractInst = Ownable(contractAddr);
230     contractInst.transferOwnership(owner);
231   }
232 }
233 
234 // File: zeppelin/contracts/token/ERC20Basic.sol
235 
236 /**
237  * @title ERC20Basic
238  * @dev Simpler version of ERC20 interface
239  * @dev see https://github.com/ethereum/EIPs/issues/179
240  */
241 contract ERC20Basic {
242   uint256 public totalSupply;
243   function balanceOf(address who) public constant returns (uint256);
244   function transfer(address to, uint256 value) public returns (bool);
245   event Transfer(address indexed from, address indexed to, uint256 value);
246 }
247 
248 // File: zeppelin/contracts/token/ERC20.sol
249 
250 /**
251  * @title ERC20 interface
252  * @dev see https://github.com/ethereum/EIPs/issues/20
253  */
254 contract ERC20 is ERC20Basic {
255   function allowance(address owner, address spender) public constant returns (uint256);
256   function transferFrom(address from, address to, uint256 value) public returns (bool);
257   function approve(address spender, uint256 value) public returns (bool);
258   event Approval(address indexed owner, address indexed spender, uint256 value);
259 }
260 
261 // File: zeppelin/contracts/token/SafeERC20.sol
262 
263 /**
264  * @title SafeERC20
265  * @dev Wrappers around ERC20 operations that throw on failure.
266  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
267  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
268  */
269 library SafeERC20 {
270   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
271     assert(token.transfer(to, value));
272   }
273 
274   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
275     assert(token.transferFrom(from, to, value));
276   }
277 
278   function safeApprove(ERC20 token, address spender, uint256 value) internal {
279     assert(token.approve(spender, value));
280   }
281 }
282 
283 // File: zeppelin/contracts/ownership/CanReclaimToken.sol
284 
285 /**
286  * @title Contracts that should be able to recover tokens
287  * @author SylTi
288  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
289  * This will prevent any accidental loss of tokens.
290  */
291 contract CanReclaimToken is Ownable {
292   using SafeERC20 for ERC20Basic;
293 
294   /**
295    * @dev Reclaim all ERC20Basic compatible tokens
296    * @param token ERC20Basic The address of the token contract
297    */
298   function reclaimToken(ERC20Basic token) external onlyOwner {
299     uint256 balance = token.balanceOf(this);
300     token.safeTransfer(owner, balance);
301   }
302 
303 }
304 
305 // File: zeppelin/contracts/ownership/HasNoTokens.sol
306 
307 /**
308  * @title Contracts that should not own Tokens
309  * @author Remco Bloemen <remco@2π.com>
310  * @dev This blocks incoming ERC23 tokens to prevent accidental loss of tokens.
311  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
312  * owner to reclaim the tokens.
313  */
314 contract HasNoTokens is CanReclaimToken {
315 
316  /**
317   * @dev Reject all ERC23 compatible tokens
318   * @param from_ address The address that is transferring the tokens
319   * @param value_ uint256 the amount of the specified token
320   * @param data_ Bytes The data passed from the caller.
321   */
322   function tokenFallback(address from_, uint256 value_, bytes data_) external {
323     revert();
324   }
325 
326 }
327 
328 // File: contracts/marketplace/AxieSiringClockAuction.sol
329 
330 /// @title Clock auction for Axie siring.
331 contract AxieSiringClockAuction is HasNoContracts, HasNoTokens, Pausable {
332   // Represents an auction on an NFT.
333   struct Auction {
334     // Current owner of NFT.
335     address seller;
336     // Price (in wei) at beginning of auction.
337     uint128 startingPrice;
338     // Price (in wei) at end of auction.
339     uint128 endingPrice;
340     // Duration (in seconds) of auction.
341     uint64 duration;
342     // Time when auction started.
343     // NOTE: 0 if this auction has been concluded.
344     uint64 startedAt;
345   }
346 
347   // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
348   // Values 0-10,000 map to 0%-100%.
349   uint256 public ownerCut;
350 
351   IERC721Base coreContract;
352   AxieIncubatorInterface incubatorContract;
353 
354   // Map from Axie ID to their corresponding auction.
355   mapping (uint256 => Auction) public auctions;
356 
357   event AuctionCreated(
358     uint256 indexed _axieId,
359     uint256 _startingPrice,
360     uint256 _endingPrice,
361     uint256 _duration,
362     address _seller
363   );
364 
365   event AuctionSuccessful(
366     uint256 indexed _sireId,
367     uint256 indexed _matronId,
368     uint256 _totalPrice,
369     address _winner
370   );
371 
372   event AuctionCancelled(uint256 indexed _axieId);
373 
374   /// @dev Constructor creates a reference to the NFT ownership contract
375   ///  and verifies the owner cut is in the valid range.
376   /// @param _ownerCut - percent cut the owner takes on each auction, must be
377   ///  between 0-10,000.
378   constructor(uint256 _ownerCut) public {
379     require(_ownerCut <= 10000);
380     ownerCut = _ownerCut;
381   }
382 
383   function () external payable onlyOwner {
384   }
385 
386   // Modifiers to check that inputs can be safely stored with a certain
387   // number of bits. We use constants and multiple modifiers to save gas.
388   modifier canBeStoredWith64Bits(uint256 _value) {
389     require(_value <= 18446744073709551615);
390     _;
391   }
392 
393   modifier canBeStoredWith128Bits(uint256 _value) {
394     require(_value < 340282366920938463463374607431768211455);
395     _;
396   }
397 
398   function reclaimEther() external onlyOwner {
399     owner.transfer(address(this).balance);
400   }
401 
402   function setCoreContract(address _coreAddress) external onlyOwner {
403     coreContract = IERC721Base(_coreAddress);
404   }
405 
406   function setIncubatorContract(address _incubatorAddress) external onlyOwner {
407     incubatorContract = AxieIncubatorInterface(_incubatorAddress);
408   }
409 
410   /// @dev Returns auction info for an NFT on auction.
411   /// @param _axieId - ID of NFT on auction.
412   function getAuction(
413     uint256 _axieId
414   )
415     external
416     view
417     returns (
418       address seller,
419       uint256 startingPrice,
420       uint256 endingPrice,
421       uint256 duration,
422       uint256 startedAt
423     )
424   {
425     Auction storage _auction = auctions[_axieId];
426     require(_isOnAuction(_auction));
427     return (
428       _auction.seller,
429       _auction.startingPrice,
430       _auction.endingPrice,
431       _auction.duration,
432       _auction.startedAt
433     );
434   }
435 
436   /// @dev Returns the current price of an auction.
437   /// @param _axieId - ID of the Axie price we are checking.
438   function getCurrentPrice(
439     uint256 _axieId
440   )
441     external
442     view
443     returns (uint256)
444   {
445     Auction storage _auction = auctions[_axieId];
446     require(_isOnAuction(_auction));
447     return _getCurrentPrice(_auction);
448   }
449 
450   /// @dev Creates and begins a new auction.
451   /// @param _axieId - ID of Axie to auction, sender must be owner.
452   /// @param _startingPrice - Price of item (in wei) at beginning of auction.
453   /// @param _endingPrice - Price of item (in wei) at end of auction.
454   /// @param _duration - Length of time to move between starting
455   ///  price and ending price (in seconds).
456   function createAuction(
457     uint256 _axieId,
458     uint256 _startingPrice,
459     uint256 _endingPrice,
460     uint256 _duration
461   )
462     external
463     whenNotPaused
464     canBeStoredWith128Bits(_startingPrice)
465     canBeStoredWith128Bits(_endingPrice)
466     canBeStoredWith64Bits(_duration)
467   {
468     address _seller = msg.sender;
469 
470     require(coreContract.ownerOf(_axieId) == _seller);
471     incubatorContract.requireEnoughExpForBreeding(_axieId); // Validate EXP for breeding.
472 
473     _escrow(_seller, _axieId);
474 
475     Auction memory _auction = Auction(
476       _seller,
477       uint128(_startingPrice),
478       uint128(_endingPrice),
479       uint64(_duration),
480       uint64(now)
481     );
482 
483     _addAuction(
484       _axieId,
485       _auction,
486       _seller
487     );
488   }
489 
490   /// @dev Bids on an siring auction and completing it.
491   /// @param _sireId - ID of Axie to bid on siring.
492   /// @param _matronId - ID of matron Axie.
493   function bidOnSiring(
494     uint256 _sireId,
495     uint256 _matronId,
496     uint256 _birthPlace
497   )
498     external
499     payable
500     whenNotPaused
501     returns (uint256 /* _axieId */)
502   {
503     Auction storage _auction = auctions[_sireId];
504     require(_isOnAuction(_auction));
505 
506     require(msg.sender == coreContract.ownerOf(_matronId));
507 
508     // Save seller address here since `_bid` will clear it.
509     address _seller = _auction.seller;
510 
511     // _bid will throw if the bid or funds transfer fails.
512     _bid(_sireId, _matronId, msg.value, _auction);
513 
514     uint256 _axieId = incubatorContract.breedAxies.value(
515       incubatorContract.breedingFee()
516     )(
517       _sireId,
518       _matronId,
519       _birthPlace
520     );
521 
522     _transfer(_seller, _sireId);
523 
524     return _axieId;
525   }
526 
527   /// @dev Cancels an auction that hasn't been won yet.
528   ///  Returns the NFT to original owner.
529   /// @notice This is a state-modifying function that can
530   ///  be called while the contract is paused.
531   /// @param _axieId - ID of Axie on auction.
532   function cancelAuction(uint256 _axieId) external {
533     Auction storage _auction = auctions[_axieId];
534     require(_isOnAuction(_auction));
535     require(msg.sender == _auction.seller);
536     _cancelAuction(_axieId, _auction.seller);
537   }
538 
539   /// @dev Cancels an auction when the contract is paused.
540   ///  Only the owner may do this, and NFTs are returned to
541   ///  the seller. This should only be used in emergencies.
542   /// @param _axieId - ID of the NFT on auction to cancel.
543   function cancelAuctionWhenPaused(
544     uint256 _axieId
545   )
546     external
547     whenPaused
548     onlyOwner
549   {
550     Auction storage _auction = auctions[_axieId];
551     require(_isOnAuction(_auction));
552     _cancelAuction(_axieId, _auction.seller);
553   }
554 
555   /// @dev Returns true if the NFT is on auction.
556   /// @param _auction - Auction to check.
557   function _isOnAuction(Auction storage _auction) internal view returns (bool) {
558     return (_auction.startedAt > 0);
559   }
560 
561   /// @dev Returns current price of an NFT on auction. Broken into two
562   ///  functions (this one, that computes the duration from the auction
563   ///  structure, and the other that does the price computation) so we
564   ///  can easily test that the price computation works correctly.
565   function _getCurrentPrice(
566     Auction storage _auction
567   )
568     internal
569     view
570     returns (uint256)
571   {
572     uint256 _secondsPassed = 0;
573 
574     // A bit of insurance against negative values (or wraparound).
575     // Probably not necessary (since Ethereum guarantees that the
576     // now variable doesn't ever go backwards).
577     if (now > _auction.startedAt) {
578       _secondsPassed = now - _auction.startedAt;
579     }
580 
581     return _computeCurrentPrice(
582       _auction.startingPrice,
583       _auction.endingPrice,
584       _auction.duration,
585       _secondsPassed
586     );
587   }
588 
589   /// @dev Computes the current price of an auction. Factored out
590   ///  from _currentPrice so we can run extensive unit tests.
591   ///  When testing, make this function external and turn on
592   ///  `Current price computation` test suite.
593   function _computeCurrentPrice(
594     uint256 _startingPrice,
595     uint256 _endingPrice,
596     uint256 _duration,
597     uint256 _secondsPassed
598   )
599     internal
600     pure
601     returns (uint256)
602   {
603     // NOTE: We don't use SafeMath (or similar) in this function because
604     //  all of our external functions carefully cap the maximum values for
605     //  time (at 64-bits) and currency (at 128-bits). _duration is
606     //  also known to be non-zero (see the require() statement in
607     //  _addAuction()).
608     if (_secondsPassed >= _duration) {
609       // We've reached the end of the dynamic pricing portion
610       // of the auction, just return the end price.
611       return _endingPrice;
612     } else {
613       // Starting price can be higher than ending price (and often is!), so
614       // this delta can be negative.
615       int256 _totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
616 
617       // This multiplication can't overflow, _secondsPassed will easily fit within
618       // 64-bits, and _totalPriceChange will easily fit within 128-bits, their product
619       // will always fit within 256-bits.
620       int256 _currentPriceChange = _totalPriceChange * int256(_secondsPassed) / int256(_duration);
621 
622       // _currentPriceChange can be negative, but if so, will have a magnitude
623       // less that _startingPrice. Thus, this result will always end up positive.
624       int256 _currentPrice = int256(_startingPrice) + _currentPriceChange;
625 
626       return uint256(_currentPrice);
627     }
628   }
629 
630   /// @dev Adds an auction to the list of open auctions. Also fires the
631   ///  AuctionCreated event.
632   /// @param _axieId The ID of the Axie to be put on auction.
633   /// @param _auction Auction to add.
634   function _addAuction(
635     uint256 _axieId,
636     Auction memory _auction,
637     address _seller
638   )
639     internal
640   {
641     // Require that all auctions have a duration of
642     // at least one minute. (Keeps our math from getting hairy!).
643     require(_auction.duration >= 1 minutes);
644 
645     auctions[_axieId] = _auction;
646 
647     emit AuctionCreated(
648       _axieId,
649       uint256(_auction.startingPrice),
650       uint256(_auction.endingPrice),
651       uint256(_auction.duration),
652       _seller
653     );
654   }
655 
656   /// @dev Removes an auction from the list of open auctions.
657   /// @param _axieId - ID of NFT on auction.
658   function _removeAuction(uint256 _axieId) internal {
659     delete auctions[_axieId];
660   }
661 
662   /// @dev Cancels an auction unconditionally.
663   function _cancelAuction(uint256 _axieId, address _seller) internal {
664     _removeAuction(_axieId);
665     _transfer(_seller, _axieId);
666     emit AuctionCancelled(_axieId);
667   }
668 
669   /// @dev Escrows the NFT, assigning ownership to this contract.
670   /// Throws if the escrow fails.
671   /// @param _owner - Current owner address of Axie to escrow.
672   /// @param _axieId - ID of Axie whose approval to verify.
673   function _escrow(address _owner, uint256 _axieId) internal {
674     // It will throw if transfer fails.
675     coreContract.transferFrom(_owner, this, _axieId);
676   }
677 
678   /// @dev Transfers an NFT owned by this contract to another address.
679   /// Returns true if the transfer succeeds.
680   /// @param _receiver - Address to transfer NFT to.
681   /// @param _axieId - ID of Axie to transfer.
682   function _transfer(address _receiver, uint256 _axieId) internal {
683     // It will throw if transfer fails
684     coreContract.transferFrom(this, _receiver, _axieId);
685   }
686 
687   /// @dev Computes owner's cut of a sale.
688   /// @param _price - Sale price of NFT.
689   function _computeCut(uint256 _price) internal view returns (uint256) {
690     // NOTE: We don't use SafeMath (or similar) in this function because
691     //  all of our entry functions carefully cap the maximum values for
692     //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
693     //  statement in the ClockAuction constructor). The result of this
694     //  function is always guaranteed to be <= _price.
695     return _price * ownerCut / 10000;
696   }
697 
698   /// @dev Computes the price and transfers winnings.
699   /// Does NOT transfer ownership of Axie.
700   function _bid(
701     uint256 _sireId,
702     uint256 _matronId,
703     uint256 _bidAmount,
704     Auction storage _auction
705   )
706     internal
707     returns (uint256)
708   {
709     // Check that the incoming bid is higher than the current price.
710     uint256 _price = _getCurrentPrice(_auction);
711     uint256 _priceWithFee = _price + incubatorContract.breedingFee();
712 
713     // Technically this shouldn't happen as `_price` fits in 128 bits.
714     // However, we could set `breedingFee` to a very large number accidentally.
715     assert(_priceWithFee >= _price);
716 
717     require(_bidAmount >= _priceWithFee);
718 
719     // Grab a reference to the seller before the auction struct
720     // gets deleted.
721     address _seller = _auction.seller;
722 
723     // The bid is good! Remove the auction before sending the fees
724     // to the sender so we can't have a reentrancy attack.
725     _removeAuction(_sireId);
726 
727     // Transfer proceeds to seller (if there are any!)
728     if (_price > 0) {
729       //  Calculate the auctioneer's cut.
730       // (NOTE: _computeCut() is guaranteed to return a
731       //  value <= price, so this subtraction can't go negative.)
732       uint256 _auctioneerCut = _computeCut(_price);
733       uint256 _sellerProceeds = _price - _auctioneerCut;
734 
735       // NOTE: Doing a transfer() in the middle of a complex
736       // method like this is generally discouraged because of
737       // reentrancy attacks and DoS attacks if the seller is
738       // a contract with an invalid fallback function. We explicitly
739       // guard against reentrancy attacks by removing the auction
740       // before calling transfer(), and the only thing the seller
741       // can DoS is the sale of their own asset! (And if it's an
742       // accident, they can call cancelAuction().)
743       _seller.transfer(_sellerProceeds);
744     }
745 
746     if (_bidAmount > _priceWithFee) {
747       // Calculate any excess funds included with the bid. If the excess
748       // is anything worth worrying about, transfer it back to bidder.
749       // NOTE: We checked above that the bid amount is greater than or
750       // equal to the price so this cannot underflow.
751       uint256 _bidExcess = _bidAmount - _priceWithFee;
752 
753       // Return the funds. Similar to the previous transfer, this is
754       // not susceptible to a re-entry attack because the auction is
755       // removed before any transfers occur.
756       msg.sender.transfer(_bidExcess);
757     }
758 
759     // Tell the world!
760     emit AuctionSuccessful(
761       _sireId,
762       _matronId,
763       _price,
764       msg.sender
765     );
766 
767     return _price;
768   }
769 }