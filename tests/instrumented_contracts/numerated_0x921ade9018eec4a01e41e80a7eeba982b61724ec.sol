1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
68 
69 /**
70  * @title Pausable
71  * @dev Base contract which allows children to implement an emergency stop mechanism.
72  */
73 contract Pausable is Ownable {
74   event Pause();
75   event Unpause();
76 
77   bool public paused = false;
78 
79 
80   /**
81    * @dev Modifier to make a function callable only when the contract is not paused.
82    */
83   modifier whenNotPaused() {
84     require(!paused);
85     _;
86   }
87 
88   /**
89    * @dev Modifier to make a function callable only when the contract is paused.
90    */
91   modifier whenPaused() {
92     require(paused);
93     _;
94   }
95 
96   /**
97    * @dev called by the owner to pause, triggers stopped state
98    */
99   function pause() public onlyOwner whenNotPaused {
100     paused = true;
101     emit Pause();
102   }
103 
104   /**
105    * @dev called by the owner to unpause, returns to normal state
106    */
107   function unpause() public onlyOwner whenPaused {
108     paused = false;
109     emit Unpause();
110   }
111 }
112 
113 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
114 
115 /**
116  * @title SafeMath
117  * @dev Math operations with safety checks that throw on error
118  */
119 library SafeMath {
120 
121   /**
122   * @dev Multiplies two numbers, throws on overflow.
123   */
124   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
125     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
126     // benefit is lost if 'b' is also tested.
127     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
128     if (_a == 0) {
129       return 0;
130     }
131 
132     c = _a * _b;
133     assert(c / _a == _b);
134     return c;
135   }
136 
137   /**
138   * @dev Integer division of two numbers, truncating the quotient.
139   */
140   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
141     // assert(_b > 0); // Solidity automatically throws when dividing by 0
142     // uint256 c = _a / _b;
143     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
144     return _a / _b;
145   }
146 
147   /**
148   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
149   */
150   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
151     assert(_b <= _a);
152     return _a - _b;
153   }
154 
155   /**
156   * @dev Adds two numbers, throws on overflow.
157   */
158   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
159     c = _a + _b;
160     assert(c >= _a);
161     return c;
162   }
163 }
164 
165 // File: contracts/v2/auctions/ArtistAcceptingBids.sol
166 
167 /**
168 * Auction interface definition - event and method definitions
169 *
170 * https://www.knownorigin.io/
171 */
172 interface IAuction {
173 
174   event BidPlaced(
175     address indexed _bidder,
176     uint256 indexed _editionNumber,
177     uint256 indexed _amount
178   );
179 
180   event BidIncreased(
181     address indexed _bidder,
182     uint256 indexed _editionNumber,
183     uint256 indexed _amount
184   );
185 
186   event BidWithdrawn(
187     address indexed _bidder,
188     uint256 indexed _editionNumber
189   );
190 
191   event BidAccepted(
192     address indexed _bidder,
193     uint256 indexed _editionNumber,
194     uint256 indexed _tokenId,
195     uint256 _amount
196   );
197 
198   event BidderRefunded(
199     uint256 indexed _editionNumber,
200     address indexed _bidder,
201     uint256 indexed _amount
202   );
203 
204   event AuctionCancelled(
205     uint256 indexed _editionNumber
206   );
207 
208   function placeBid(uint256 _editionNumber) public payable returns (bool success);
209 
210   function increaseBid(uint256 _editionNumber) public payable returns (bool success);
211 
212   function withdrawBid(uint256 _editionNumber) public returns (bool success);
213 
214   function acceptBid(uint256 _editionNumber) public returns (uint256 tokenId);
215 
216   function cancelAuction(uint256 _editionNumber) public returns (bool success);
217 }
218 
219 /**
220 * Minimal interface definition for KODA V2 contract calls
221 *
222 * https://www.knownorigin.io/
223 */
224 interface IKODAV2 {
225   function mint(address _to, uint256 _editionNumber) external returns (uint256);
226 
227   function editionExists(uint256 _editionNumber) external returns (bool);
228 
229   function totalRemaining(uint256 _editionNumber) external view returns (uint256);
230 
231   function artistCommission(uint256 _editionNumber) external view returns (address _artistAccount, uint256 _artistCommission);
232 }
233 
234 /**
235 * @title Artists accepting bidding contract for KnownOrigin (KODA)
236 *
237 * Rules:
238 * Can only bid for an edition which is enabled
239 * Can only add new bids higher than previous highest bid plus minimum bid amount
240 * Can increase your bid, only if you are the top current bidder
241 * Once outbid, original bidder has ETH returned
242 * Cannot double bid once you are already the highest bidder, can only call increaseBid()
243 * Only the defined controller address can accept the bid
244 * If a bid is revoked, the auction remains open however no highest bid exists
245 * If the contract is Paused, no public actions can happen e.g. bids, increases, withdrawals
246 * Managers of contract have full control over it act as a fallback in-case funds go missing or errors are found
247 * On accepting of any bid, funds are split to KO and Artists - optional 3rd party split not currently supported
248 * If an edition is sold out, the auction is stopped, manual refund required by bidder or owner
249 * Upon cancelling a bid which is in flight, funds are returned and contract stops further bids on the edition
250 * Artists commissions and address are pulled from the KODA contract and are not based on the controller address
251 *
252 * Scenario:
253 * 1) Config artist (Dave) & edition (1000)
254 * 2) Bob places a bid on edition 1000 for 1 ETH
255 * 3) Alice places a higher bid of 1.5ETH, overriding Bobs position as the leader, sends Bobs 1 ETH back and taking 1st place
256 * 4) Dave accepts Alice's bid
257 * 5) KODA token generated and transferred to Alice, funds are split between KO and Artist
258 *
259 * https://www.knownorigin.io/
260 *
261 * BE ORIGINAL. BUY ORIGINAL.
262 */
263 contract ArtistAcceptingBids is Ownable, Pausable, IAuction {
264   using SafeMath for uint256;
265 
266   // A mapping of the controller address to the edition number
267   mapping(uint256 => address) internal editionNumberToArtistControlAddress;
268 
269   // Enabled/disable the auction for the edition number
270   mapping(uint256 => bool) internal enabledEditions;
271 
272   // Edition to current highest bidders address
273   mapping(uint256 => address) internal editionHighestBid;
274 
275   // Mapping for edition -> bidder -> bid amount
276   mapping(uint256 => mapping(address => uint256)) internal editionBids;
277 
278   // Min increase in bid amount
279   uint256 public minBidAmount = 0.01 ether;
280 
281   // Interface into the KODA world
282   IKODAV2 public kodaAddress;
283 
284   // KO account which can receive commission
285   address public koCommissionAccount;
286 
287   ///////////////
288   // Modifiers //
289   ///////////////
290 
291   // Checks the auction is enabled
292   modifier whenAuctionEnabled(uint256 _editionNumber) {
293     require(enabledEditions[_editionNumber], "Edition is not enabled for auctions");
294     _;
295   }
296 
297   // Checks the msg.sender is the artists control address or the auction owner
298   modifier whenCallerIsController(uint256 _editionNumber) {
299     require(editionNumberToArtistControlAddress[_editionNumber] == msg.sender || msg.sender == owner, "Edition not managed by calling address");
300     _;
301   }
302 
303   // Checks the bid is higher than the current amount + min bid
304   modifier whenPlacedBidIsAboveMinAmount(uint256 _editionNumber) {
305     address currentHighestBidder = editionHighestBid[_editionNumber];
306     uint256 currentHighestBidderAmount = editionBids[_editionNumber][currentHighestBidder];
307     require(currentHighestBidderAmount.add(minBidAmount) <= msg.value, "Bids must be higher than previous bids plus minimum bid");
308     _;
309   }
310 
311   // Checks the bid is higher than the min bid
312   modifier whenBidIncreaseIsAboveMinAmount() {
313     require(minBidAmount <= msg.value, "Bids must be higher than minimum bid amount");
314     _;
315   }
316 
317   // Check the caller in not already the highest bidder
318   modifier whenCallerNotAlreadyTheHighestBidder(uint256 _editionNumber) {
319     address currentHighestBidder = editionHighestBid[_editionNumber];
320     require(currentHighestBidder != msg.sender, "Cant bid anymore, you are already the current highest");
321     _;
322   }
323 
324   // Checks msg.sender is the highest bidder
325   modifier whenCallerIsHighestBidder(uint256 _editionNumber) {
326     require(editionHighestBid[_editionNumber] == msg.sender, "Can only withdraw a bid if you are the highest bidder");
327     _;
328   }
329 
330   // Only when editions are not sold out in KODA
331   modifier whenEditionNotSoldOut(uint256 _editionNumber) {
332     uint256 totalRemaining = kodaAddress.totalRemaining(_editionNumber);
333     require(totalRemaining > 0, "Unable to accept any more bids, edition is sold out");
334     _;
335   }
336 
337   // Only when edition exists in KODA
338   modifier whenEditionExists(uint256 _editionNumber) {
339     bool editionExists = kodaAddress.editionExists(_editionNumber);
340     require(editionExists, "Edition does not exist");
341     _;
342   }
343 
344   /////////////////
345   // Constructor //
346   /////////////////
347 
348   // Set the caller as the default KO account
349   constructor(IKODAV2 _kodaAddress) public {
350     kodaAddress = _kodaAddress;
351     koCommissionAccount = msg.sender;
352   }
353 
354   //////////////////////////
355   // Core Auction Methods //
356   //////////////////////////
357 
358   /**
359    * @dev Public method for placing a bid, reverts if:
360    * - Contract is Paused
361    * - Edition provided is not valid
362    * - Edition provided is not configured for auctions
363    * - Edition provided is sold out
364    * - msg.sender is already the highest bidder
365    * - msg.value is not greater than highest bid + minimum amount
366    * @dev refunds the previous bidders ether if the bid is overwritten
367    * @return true on success
368    */
369   function placeBid(uint256 _editionNumber)
370   public
371   payable
372   whenNotPaused
373   whenEditionExists(_editionNumber)
374   whenAuctionEnabled(_editionNumber)
375   whenPlacedBidIsAboveMinAmount(_editionNumber)
376   whenCallerNotAlreadyTheHighestBidder(_editionNumber)
377   whenEditionNotSoldOut(_editionNumber)
378   returns (bool success)
379   {
380     // Grab the previous holders bid so we can refund it
381     _refundHighestBidder(_editionNumber);
382 
383     // Keep a record of the current users bid (previous bidder has been refunded)
384     editionBids[_editionNumber][msg.sender] = msg.value;
385 
386     // Update the highest bid to be the latest bidder
387     editionHighestBid[_editionNumber] = msg.sender;
388 
389     // Emit event
390     emit BidPlaced(msg.sender, _editionNumber, msg.value);
391 
392     return true;
393   }
394 
395   /**
396    * @dev Public method for increasing your bid, reverts if:
397    * - Contract is Paused
398    * - Edition provided is not valid
399    * - Edition provided is not configured for auctions
400    * - Edition provided is sold out
401    * - msg.sender is not the current highest bidder
402    * @return true on success
403    */
404   function increaseBid(uint256 _editionNumber)
405   public
406   payable
407   whenNotPaused
408   whenBidIncreaseIsAboveMinAmount
409   whenEditionExists(_editionNumber)
410   whenAuctionEnabled(_editionNumber)
411   whenEditionNotSoldOut(_editionNumber)
412   whenCallerIsHighestBidder(_editionNumber)
413   returns (bool success)
414   {
415     // Bump the current highest bid by provided amount
416     editionBids[_editionNumber][msg.sender] = editionBids[_editionNumber][msg.sender].add(msg.value);
417 
418     // Emit event
419     emit BidIncreased(msg.sender, _editionNumber, editionBids[_editionNumber][msg.sender]);
420 
421     return true;
422   }
423 
424   /**
425    * @dev Public method for withdrawing your bid, reverts if:
426    * - Contract is Paused
427    * - msg.sender is not the current highest bidder
428    * @dev removes current highest bid so there is no current highest bidder
429    * @return true on success
430    */
431   function withdrawBid(uint256 _editionNumber)
432   public
433   whenNotPaused
434   whenEditionExists(_editionNumber)
435   whenCallerIsHighestBidder(_editionNumber)
436   returns (bool success)
437   {
438     // get current highest bid and refund it
439     _refundHighestBidder(_editionNumber);
440 
441     // Fire event
442     emit BidWithdrawn(msg.sender, _editionNumber);
443 
444     return true;
445   }
446 
447   /**
448    * @dev Method for cancelling an auction, only called from contract owner
449    * @dev refunds previous highest bidders bid
450    * @dev removes current highest bid so there is no current highest bidder
451    * @return true on success
452    */
453   function cancelAuction(uint256 _editionNumber)
454   public
455   onlyOwner
456   whenEditionExists(_editionNumber)
457   returns (bool success)
458   {
459     // get current highest bid and refund it
460     _refundHighestBidder(_editionNumber);
461 
462     // Disable the auction
463     enabledEditions[_editionNumber] = false;
464 
465     // Fire event
466     emit AuctionCancelled(_editionNumber);
467 
468     return true;
469   }
470 
471   /**
472    * @dev Method for accepting the highest bid, only called by edition creator, reverts if:
473    * - Contract is Paused
474    * - msg.sender is not the edition controller
475    * - Edition provided is not valid
476    * @dev Mints a new token in KODA contract
477    * @dev Splits bid amount to KO and Artist, based on KODA contract defined values
478    * @dev Removes current highest bid so there is no current highest bidder
479    * @dev If no more editions are available the auction is stopped
480    * @return the generated tokenId on success
481    */
482   function acceptBid(uint256 _editionNumber)
483   public
484   whenNotPaused
485   whenCallerIsController(_editionNumber) // Checks only the controller can call this
486   whenAuctionEnabled(_editionNumber) // Checks auction is still enabled
487   returns (uint256 tokenId)
488   {
489     // Get total remaining here so we can use it below
490     uint256 totalRemaining = kodaAddress.totalRemaining(_editionNumber);
491     require(totalRemaining > 0, "Unable to accept bid, edition is sold out");
492 
493     // Get the winner of the bidding action
494     address winningAccount = editionHighestBid[_editionNumber];
495     require(winningAccount != address(0), "Cannot win an auction when there is no highest bidder");
496 
497     uint256 winningBidAmount = editionBids[_editionNumber][winningAccount];
498     require(winningBidAmount >= 0, "Cannot win an auction when no bid amount set");
499 
500     // Mint a new token to the winner
501     uint256 _tokenId = kodaAddress.mint(winningAccount, _editionNumber);
502     require(_tokenId != 0, "Failed to mint new token");
503 
504     // Get the commission and split bid amount accordingly
505     address artistAccount;
506     uint256 artistCommission;
507     (artistAccount, artistCommission) = kodaAddress.artistCommission(_editionNumber);
508 
509     // Extract the artists commission and send it
510     uint256 artistPayment = winningBidAmount.div(100).mul(artistCommission);
511     if (artistPayment > 0) {
512       artistAccount.transfer(artistPayment);
513     }
514 
515     // Send KO remaining amount
516     uint256 remainingCommission = winningBidAmount.sub(artistPayment);
517     if (remainingCommission > 0) {
518       koCommissionAccount.transfer(remainingCommission);
519     }
520 
521     // Clear out highest bidder for this auction
522     delete editionHighestBid[_editionNumber];
523 
524     // If the edition is sold out, disable the auction
525     if (totalRemaining.sub(1) == 0) {
526       enabledEditions[_editionNumber] = false;
527     }
528 
529     // Fire event
530     emit BidAccepted(winningAccount, _editionNumber, _tokenId, winningBidAmount);
531 
532     return _tokenId;
533   }
534 
535   /**
536    * Returns funds of the previous highest bidder back to them if present
537    */
538   function _refundHighestBidder(uint256 _editionNumber) internal {
539     // Get current highest bidder
540     address currentHighestBidder = editionHighestBid[_editionNumber];
541 
542     // Get current highest bid amount
543     uint256 currentHighestBiddersAmount = editionBids[_editionNumber][currentHighestBidder];
544 
545     if (currentHighestBidder != address(0) && currentHighestBiddersAmount > 0) {
546 
547       // Clear out highest bidder as there is no long one
548       delete editionHighestBid[_editionNumber];
549 
550       // Refund it
551       currentHighestBidder.transfer(currentHighestBiddersAmount);
552 
553       // Emit event
554       emit BidderRefunded(_editionNumber, currentHighestBidder, currentHighestBiddersAmount);
555     }
556   }
557 
558   ///////////////////////////////
559   // Public management methods //
560   ///////////////////////////////
561 
562   /**
563    * @dev Enables the edition for auctions
564    * @dev Only callable from owner
565    */
566   function enableEdition(uint256 _editionNumber) onlyOwner public returns (bool) {
567     enabledEditions[_editionNumber] = true;
568     return true;
569   }
570 
571   /**
572    * @dev Disables the edition for auctions
573    * @dev Only callable from owner
574    */
575   function disableEdition(uint256 _editionNumber) onlyOwner public returns (bool) {
576     enabledEditions[_editionNumber] = false;
577     return true;
578   }
579 
580   /**
581    * @dev Sets the edition artist control address
582    * @dev Only callable from owner
583    */
584   function setArtistsControlAddress(uint256 _editionNumber, address _address) onlyOwner public returns (bool) {
585     editionNumberToArtistControlAddress[_editionNumber] = _address;
586     return true;
587   }
588 
589   /**
590    * @dev Sets the edition artist control address and enables the edition for auction
591    * @dev Only callable from owner
592    */
593   function setArtistsControlAddressAndEnabledEdition(uint256 _editionNumber, address _address) onlyOwner public returns (bool) {
594     enabledEditions[_editionNumber] = true;
595     editionNumberToArtistControlAddress[_editionNumber] = _address;
596     return true;
597   }
598 
599   /**
600    * @dev Sets the minimum bid amount
601    * @dev Only callable from owner
602    */
603   function setMinBidAmount(uint256 _minBidAmount) onlyOwner public {
604     minBidAmount = _minBidAmount;
605   }
606 
607   /**
608    * @dev Sets the KODA address
609    * @dev Only callable from owner
610    */
611   function setKodavV2(IKODAV2 _kodaAddress) onlyOwner public {
612     kodaAddress = _kodaAddress;
613   }
614 
615   /**
616    * @dev Sets the KODA address
617    * @dev Only callable from owner
618    */
619   function setKoCommissionAccount(address _koCommissionAccount) public onlyOwner {
620     require(_koCommissionAccount != address(0), "Invalid address");
621     koCommissionAccount = _koCommissionAccount;
622   }
623 
624   /////////////////////////////
625   // Manual Override methods //
626   /////////////////////////////
627 
628   /**
629    * @dev Allows for the ability to extract ether so we can distribute to the correct bidders accordingly
630    * @dev Only callable from owner
631    */
632   function withdrawStuckEther(address _withdrawalAccount) onlyOwner public {
633     require(_withdrawalAccount != address(0), "Invalid address provided");
634     require(address(this).balance != 0, "No more ether to withdraw");
635     _withdrawalAccount.transfer(address(this).balance);
636   }
637 
638   /**
639    * @dev Allows for the ability to extract specific ether amounts so we can distribute to the correct bidders accordingly
640    * @dev Only callable from owner
641    */
642   function withdrawStuckEtherOfAmount(address _withdrawalAccount, uint256 _amount) onlyOwner public {
643     require(_withdrawalAccount != address(0), "Invalid address provided");
644     require(_amount != 0, "Invalid amount to withdraw");
645     require(address(this).balance >= _amount, "No more ether to withdraw");
646     _withdrawalAccount.transfer(_amount);
647   }
648 
649   /**
650    * @dev Manual override method for setting edition highest bid & the highest bidder to the provided address
651    * @dev Only callable from owner
652    */
653   function manualOverrideEditionHighestBidAndBidder(uint256 _editionNumber, address _bidder, uint256 _amount) onlyOwner public returns (bool) {
654     editionBids[_editionNumber][_bidder] = _amount;
655     editionHighestBid[_editionNumber] = _bidder;
656     return true;
657   }
658 
659   /**
660    * @dev Manual override method removing bidding values
661    * @dev Only callable from owner
662    */
663   function manualDeleteEditionBids(uint256 _editionNumber, address _bidder) onlyOwner public returns (bool) {
664     delete editionHighestBid[_editionNumber];
665     delete editionBids[_editionNumber][_bidder];
666     return true;
667   }
668 
669   //////////////////////////
670   // Public query methods //
671   //////////////////////////
672 
673   /**
674    * @dev Look up all the known data about the latest edition bidding round
675    * @dev Returns zeros for all values when not valid
676    */
677   function auctionDetails(uint256 _editionNumber) public view returns (bool _enabled, address _bidder, uint256 _value, address _controller) {
678     address highestBidder = editionHighestBid[_editionNumber];
679     uint256 bidValue = editionBids[_editionNumber][highestBidder];
680     address controlAddress = editionNumberToArtistControlAddress[_editionNumber];
681     return (
682     enabledEditions[_editionNumber],
683     highestBidder,
684     bidValue,
685     controlAddress
686     );
687   }
688 
689   /**
690    * @dev Look up all the current highest bidder for the latest edition
691    * @dev Returns zeros for all values when not valid
692    */
693   function highestBidForEdition(uint256 _editionNumber) public view returns (address _bidder, uint256 _value) {
694     address highestBidder = editionHighestBid[_editionNumber];
695     uint256 bidValue = editionBids[_editionNumber][highestBidder];
696     return (highestBidder, bidValue);
697   }
698 
699   /**
700    * @dev Check an edition is enabled for auction
701    */
702   function isEditionEnabled(uint256 _editionNumber) public view returns (bool) {
703     return enabledEditions[_editionNumber];
704   }
705 
706   /**
707    * @dev Check which address can action a bid for the given edition
708    */
709   function editionController(uint256 _editionNumber) public view returns (address) {
710     return editionNumberToArtistControlAddress[_editionNumber];
711   }
712 
713 }