1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 
3 pragma solidity ^0.8.0;
4 
5 import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
6 
7 import "../libraries/AccountMigrationLibrary.sol";
8 import "./Constants.sol";
9 import "./FoundationTreasuryNode.sol";
10 import "./NFTMarketAuction.sol";
11 import "./NFTMarketCore.sol";
12 import "./NFTMarketFees.sol";
13 import "./SendValueWithFallbackWithdraw.sol";
14 
15 import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
16 
17 /// @param minAmount The minimum amount that must be bid in order for it to be accepted.
18 error NFTMarketReserveAuction_Bid_Must_Be_At_Least_Min_Amount(uint256 minAmount);
19 error NFTMarketReserveAuction_Cannot_Admin_Cancel_Without_Reason();
20 /// @param reservePrice The current reserve price.
21 error NFTMarketReserveAuction_Cannot_Bid_Lower_Than_Reserve_Price(uint256 reservePrice);
22 /// @param endTime The timestamp at which the auction had ended.
23 error NFTMarketReserveAuction_Cannot_Bid_On_Ended_Auction(uint256 endTime);
24 error NFTMarketReserveAuction_Cannot_Bid_On_Nonexistent_Auction();
25 error NFTMarketReserveAuction_Cannot_Cancel_Nonexistent_Auction();
26 error NFTMarketReserveAuction_Cannot_Finalize_Already_Settled_Auction();
27 /// @param endTime The timestamp at which the auction will end.
28 error NFTMarketReserveAuction_Cannot_Finalize_Auction_In_Progress(uint256 endTime);
29 /// @param seller The current owner of the NFT.
30 error NFTMarketReserveAuction_Cannot_Migrate_Non_Matching_Seller(address seller);
31 error NFTMarketReserveAuction_Cannot_Rebid_Over_Outstanding_Bid();
32 error NFTMarketReserveAuction_Cannot_Update_Auction_In_Progress();
33 /// @param maxDuration The maximum configuration for a duration of the auction, in seconds.
34 error NFTMarketReserveAuction_Exceeds_Max_Duration(uint256 maxDuration);
35 /// @param extensionDuration The extension duration, in seconds.
36 error NFTMarketReserveAuction_Less_Than_Extension_Duration(uint256 extensionDuration);
37 error NFTMarketReserveAuction_Must_Set_Non_Zero_Reserve_Price();
38 /// @param seller The current owner of the NFT.
39 error NFTMarketReserveAuction_Not_Matching_Seller(address seller);
40 /// @param owner The current owner of the NFT.
41 error NFTMarketReserveAuction_Only_Owner_Can_Update_Auction(address owner);
42 error NFTMarketReserveAuction_Too_Much_Value_Provided();
43 
44 /**
45  * @title Allows the owner of an NFT to list it in auction.
46  * @notice NFTs in auction are escrowed in the market contract.
47  * @dev There is room to optimize the storage for auctions, significantly reducing gas costs.
48  * This may be done in the future, but for now it will remain as is in order to ease upgrade compatibility.
49  */
50 abstract contract NFTMarketReserveAuction is
51   Constants,
52   FoundationTreasuryNode,
53   NFTMarketCore,
54   ReentrancyGuardUpgradeable,
55   SendValueWithFallbackWithdraw,
56   NFTMarketFees,
57   NFTMarketAuction
58 {
59   using AccountMigrationLibrary for address;
60 
61   /// @notice Stores the auction configuration for a specific NFT.
62   struct ReserveAuction {
63     /// @notice The address of the NFT contract.
64     address nftContract;
65     /// @notice The id of the NFT.
66     uint256 tokenId;
67     /// @notice The owner of the NFT which listed it in auction.
68     address payable seller;
69     /// @notice The duration for this auction.
70     uint256 duration;
71     /// @notice The extension window for this auction.
72     uint256 extensionDuration;
73     /// @notice The time at which this auction will not accept any new bids.
74     /// @dev This is `0` until the first bid is placed.
75     uint256 endTime;
76     /// @notice The current highest bidder in this auction.
77     /// @dev This is `address(0)` until the first bid is placed.
78     address payable bidder;
79     /// @notice The latest price of the NFT in this auction.
80     /// @dev This is set to the reserve price, and then to the highest bid once the auction has started.
81     uint256 amount;
82   }
83 
84   /// @notice The auction configuration for a specific auction id.
85   mapping(address => mapping(uint256 => uint256)) private nftContractToTokenIdToAuctionId;
86   /// @notice The auction id for a specific NFT.
87   /// @dev This is deleted when an auction is finalized or canceled.
88   mapping(uint256 => ReserveAuction) private auctionIdToAuction;
89 
90   /**
91    * @dev Removing old unused variables in an upgrade safe way. Was:
92    * uint256 private __gap_was_minPercentIncrementInBasisPoints;
93    * uint256 private __gap_was_maxBidIncrementRequirement;
94    * uint256 private __gap_was_duration;
95    * uint256 private __gap_was_extensionDuration;
96    * uint256 private __gap_was_goLiveDate;
97    */
98   uint256[5] private __gap_was_config;
99 
100   /// @notice How long an auction lasts for once the first bid has been received.
101   uint256 private immutable DURATION;
102 
103   /// @notice The window for auction extensions, any bid placed in the final 15 minutes
104   /// of an auction will reset the time remaining to 15 minutes.
105   uint256 private constant EXTENSION_DURATION = 15 minutes;
106 
107   /// @notice Caps the max duration that may be configured so that overflows will not occur.
108   uint256 private constant MAX_MAX_DURATION = 1000 days;
109 
110   /**
111    * @notice Emitted when a bid is placed.
112    * @param auctionId The id of the auction this bid was for.
113    * @param bidder The address of the bidder.
114    * @param amount The amount of the bid.
115    * @param endTime The new end time of the auction (which may have been set or extended by this bid).
116    */
117   event ReserveAuctionBidPlaced(uint256 indexed auctionId, address indexed bidder, uint256 amount, uint256 endTime);
118   /**
119    * @notice Emitted when an auction is cancelled.
120    * @dev This is only possible if the auction has not received any bids.
121    * @param auctionId The id of the auction that was cancelled.
122    */
123   event ReserveAuctionCanceled(uint256 indexed auctionId);
124   /**
125    * @notice Emitted when an auction is canceled by a Foundation admin.
126    * @dev When this occurs, the highest bidder (if there was a bid) is automatically refunded.
127    * @param auctionId The id of the auction that was cancelled.
128    * @param reason The reason for the cancellation.
129    */
130   event ReserveAuctionCanceledByAdmin(uint256 indexed auctionId, string reason);
131   /**
132    * @notice Emitted when an NFT is listed for auction.
133    * @param seller The address of the seller.
134    * @param nftContract The address of the NFT contract.
135    * @param tokenId The id of the NFT.
136    * @param duration The duration of the auction (always 24-hours).
137    * @param extensionDuration The duration of the auction extension window (always 15-minutes).
138    * @param reservePrice The reserve price to kick off the auction.
139    * @param auctionId The id of the auction that was created.
140    */
141   event ReserveAuctionCreated(
142     address indexed seller,
143     address indexed nftContract,
144     uint256 indexed tokenId,
145     uint256 duration,
146     uint256 extensionDuration,
147     uint256 reservePrice,
148     uint256 auctionId
149   );
150   /**
151    * @notice Emitted when an auction that has already ended is finalized,
152    * indicating that the NFT has been transferred and revenue from the sale distributed.
153    * @dev The amount of the highest bid / final sale price for this auction is `f8nFee` + `creatorFee` + `ownerRev`.
154    * @param auctionId The id of the auction that was finalized.
155    * @param seller The address of the seller.
156    * @param bidder The address of the highest bidder that won the NFT.
157    * @param f8nFee The amount of ETH that was sent to Foundation for this sale.
158    * @param creatorFee The amount of ETH that was sent to the creator for this sale.
159    * @param ownerRev The amount of ETH that was sent to the owner for this sale.
160    */
161   event ReserveAuctionFinalized(
162     uint256 indexed auctionId,
163     address indexed seller,
164     address indexed bidder,
165     uint256 f8nFee,
166     uint256 creatorFee,
167     uint256 ownerRev
168   );
169   /**
170    * @notice Emitted when an auction is invalidated due to other market activity.
171    * @dev This occurs when the NFT is sold another way, such as with `buy` or `acceptOffer`.
172    * @param auctionId The id of the auction that was invalidated.
173    */
174   event ReserveAuctionInvalidated(uint256 indexed auctionId);
175   /**
176    * @notice Emitted when the seller for an auction has been changed to a new account.
177    * @dev Account migrations require approval from both the original account and Foundation.
178    * @param auctionId The id of the auction that was updated.
179    * @param originalSellerAddress The original address of the auction's seller.
180    * @param newSellerAddress The new address for the auction's seller.
181    */
182   event ReserveAuctionSellerMigrated(
183     uint256 indexed auctionId,
184     address indexed originalSellerAddress,
185     address indexed newSellerAddress
186   );
187   /**
188    * @notice Emitted when the auction's reserve price is changed.
189    * @dev This is only possible if the auction has not received any bids.
190    * @param auctionId The id of the auction that was updated.
191    * @param reservePrice The new reserve price for the auction.
192    */
193   event ReserveAuctionUpdated(uint256 indexed auctionId, uint256 reservePrice);
194 
195   /// @notice Confirms that the reserve price is not zero.
196   modifier onlyValidAuctionConfig(uint256 reservePrice) {
197     if (reservePrice == 0) {
198       revert NFTMarketReserveAuction_Must_Set_Non_Zero_Reserve_Price();
199     }
200     _;
201   }
202 
203   /**
204    * @notice Configures the duration for auctions.
205    * @param duration The duration for auctions, in seconds.
206    */
207   constructor(uint256 duration) {
208     if (duration > MAX_MAX_DURATION) {
209       // This ensures that math in this file will not overflow due to a huge duration.
210       revert NFTMarketReserveAuction_Exceeds_Max_Duration(MAX_MAX_DURATION);
211     }
212     if (duration < EXTENSION_DURATION) {
213       // The auction duration configuration must be greater than the extension window of 15 minutes
214       revert NFTMarketReserveAuction_Less_Than_Extension_Duration(EXTENSION_DURATION);
215     }
216     DURATION = duration;
217   }
218 
219   /**
220    * @notice Allows Foundation to cancel an auction, refunding the bidder and returning the NFT to
221    * the seller (if not active buy price set).
222    * This should only be used for extreme cases such as DMCA takedown requests.
223    * @param auctionId The id of the auction to cancel.
224    * @param reason The reason for the cancellation (a required field).
225    */
226   function adminCancelReserveAuction(uint256 auctionId, string calldata reason)
227     external
228     onlyFoundationAdmin
229     nonReentrant
230   {
231     if (bytes(reason).length == 0) {
232       revert NFTMarketReserveAuction_Cannot_Admin_Cancel_Without_Reason();
233     }
234     ReserveAuction memory auction = auctionIdToAuction[auctionId];
235     if (auction.amount == 0) {
236       revert NFTMarketReserveAuction_Cannot_Cancel_Nonexistent_Auction();
237     }
238 
239     delete nftContractToTokenIdToAuctionId[auction.nftContract][auction.tokenId];
240     delete auctionIdToAuction[auctionId];
241 
242     // Return the NFT to the owner.
243     _transferFromEscrowIfAvailable(auction.nftContract, auction.tokenId, auction.seller);
244 
245     if (auction.bidder != address(0)) {
246       // Refund the highest bidder if any bids were placed in this auction.
247       _sendValueWithFallbackWithdraw(auction.bidder, auction.amount, SEND_VALUE_GAS_LIMIT_SINGLE_RECIPIENT);
248     }
249 
250     emit ReserveAuctionCanceledByAdmin(auctionId, reason);
251   }
252 
253   /**
254    * @notice Allows an NFT owner and Foundation to work together in order to update the seller
255    * for auctions they have listed to a new account.
256    * @dev This will gracefully skip any auctions that have already been finalized.
257    * @param listedAuctionIds The ids of the auctions to update.
258    * @param originalAddress The original address of the seller of these auctions.
259    * @param newAddress The new address for the seller of these auctions.
260    * @param signature Message `I authorize Foundation to migrate my account to ${newAccount.address.toLowerCase()}`
261    * signed by the original account.
262    */
263   function adminAccountMigration(
264     uint256[] calldata listedAuctionIds,
265     address originalAddress,
266     address payable newAddress,
267     bytes memory signature
268   ) external onlyFoundationOperator {
269     // Validate the owner of the original account has approved this change.
270     originalAddress.requireAuthorizedAccountMigration(newAddress, signature);
271 
272     unchecked {
273       // The array length cannot overflow 256 bits.
274       for (uint256 i = 0; i < listedAuctionIds.length; ++i) {
275         uint256 auctionId = listedAuctionIds[i];
276         ReserveAuction storage auction = auctionIdToAuction[auctionId];
277         if (auction.seller != address(0)) {
278           // Only if the auction was found and not finalized before this transaction.
279 
280           if (auction.seller != originalAddress) {
281             // Confirm that the signature approval was the correct owner of this auction.
282             revert NFTMarketReserveAuction_Cannot_Migrate_Non_Matching_Seller(auction.seller);
283           }
284 
285           // Update the auction's seller address.
286           auction.seller = newAddress;
287 
288           emit ReserveAuctionSellerMigrated(auctionId, originalAddress, newAddress);
289         }
290       }
291     }
292   }
293 
294   /**
295    * @notice If an auction has been created but has not yet received bids, it may be canceled by the seller.
296    * @dev The NFT is transferred back to the owner unless there is still has a buy price set.
297    * @param auctionId The id of the auction to cancel.
298    */
299   function cancelReserveAuction(uint256 auctionId) external nonReentrant {
300     ReserveAuction memory auction = auctionIdToAuction[auctionId];
301     if (auction.seller != msg.sender) {
302       revert NFTMarketReserveAuction_Only_Owner_Can_Update_Auction(auction.seller);
303     }
304     if (auction.endTime != 0) {
305       revert NFTMarketReserveAuction_Cannot_Update_Auction_In_Progress();
306     }
307 
308     // Remove the auction.
309     delete nftContractToTokenIdToAuctionId[auction.nftContract][auction.tokenId];
310     delete auctionIdToAuction[auctionId];
311 
312     // Transfer the NFT unless it still has a buy price set.
313     _transferFromEscrowIfAvailable(auction.nftContract, auction.tokenId, auction.seller);
314 
315     emit ReserveAuctionCanceled(auctionId);
316   }
317 
318   /**
319    * @notice Creates an auction for the given NFT.
320    * The NFT is held in escrow until the auction is finalized or canceled.
321    * @param nftContract The address of the NFT contract.
322    * @param tokenId The id of the NFT.
323    * @param reservePrice The initial reserve price for the auction.
324    */
325   function createReserveAuction(
326     address nftContract,
327     uint256 tokenId,
328     uint256 reservePrice
329   ) external nonReentrant onlyValidAuctionConfig(reservePrice) {
330     uint256 auctionId = _getNextAndIncrementAuctionId();
331 
332     // If the `msg.sender` is not the owner of the NFT, transferring into escrow should fail.
333     _transferToEscrow(nftContract, tokenId);
334 
335     // Store the auction details
336     nftContractToTokenIdToAuctionId[nftContract][tokenId] = auctionId;
337     auctionIdToAuction[auctionId] = ReserveAuction(
338       nftContract,
339       tokenId,
340       payable(msg.sender),
341       DURATION,
342       EXTENSION_DURATION,
343       0, // endTime is only known once the reserve price is met
344       payable(0), // bidder is only known once a bid has been placed
345       reservePrice
346     );
347 
348     emit ReserveAuctionCreated(msg.sender, nftContract, tokenId, DURATION, EXTENSION_DURATION, reservePrice, auctionId);
349   }
350 
351   /**
352    * @notice Once the countdown has expired for an auction, anyone can settle the auction.
353    * This will send the NFT to the highest bidder and distribute revenue for this sale.
354    * @param auctionId The id of the auction to settle.
355    */
356   function finalizeReserveAuction(uint256 auctionId) external nonReentrant {
357     if (auctionIdToAuction[auctionId].endTime == 0) {
358       revert NFTMarketReserveAuction_Cannot_Finalize_Already_Settled_Auction();
359     }
360     _finalizeReserveAuction(auctionId, false);
361   }
362 
363   /**
364    * @notice Place a bid in an auction.
365    * A bidder may place a bid which is at least the value defined by `getMinBidAmount`.
366    * If this is the first bid on the auction, the countdown will begin.
367    * If there is already an outstanding bid, the previous bidder will be refunded at this time
368    * and if the bid is placed in the final moments of the auction, the countdown may be extended.
369    * @param auctionId The id of the auction to bid on.
370    */
371   function placeBid(uint256 auctionId) external payable {
372     placeBidOf(auctionId, msg.value);
373   }
374 
375   /**
376    * @notice Place a bid in an auction.
377    * A bidder may place a bid which is at least the amount defined by `getMinBidAmount`.
378    * If this is the first bid on the auction, the countdown will begin.
379    * If there is already an outstanding bid, the previous bidder will be refunded at this time
380    * and if the bid is placed in the final moments of the auction, the countdown may be extended.
381    * @dev `amount` - `msg.value` is withdrawn from the bidder's FETH balance.
382    * @param auctionId The id of the auction to bid on.
383    * @param amount The amount to bid, if this is more than `msg.value` funds will be withdrawn from your FETH balance.
384    */
385   /* solhint-disable-next-line code-complexity */
386   function placeBidOf(uint256 auctionId, uint256 amount) public payable nonReentrant {
387     if (amount < msg.value) {
388       // The amount is specified by the bidder, so if too much ETH is sent then something went wrong.
389       revert NFTMarketReserveAuction_Too_Much_Value_Provided();
390     } else if (amount > msg.value) {
391       // Withdraw additional ETH required from their available FETH balance.
392 
393       unchecked {
394         // The if above ensures delta will not underflow.
395         uint256 delta = amount - msg.value;
396 
397         // Withdraw ETH from the buyer's account in the FETH token contract.
398         feth.marketWithdrawFrom(msg.sender, delta);
399       }
400     }
401 
402     ReserveAuction storage auction = auctionIdToAuction[auctionId];
403 
404     if (auction.amount == 0) {
405       // No auction found
406       revert NFTMarketReserveAuction_Cannot_Bid_On_Nonexistent_Auction();
407     }
408 
409     if (auction.endTime == 0) {
410       // This is the first bid, kicking off the auction.
411 
412       if (auction.amount > amount) {
413         // The bid must be >= the reserve price.
414         revert NFTMarketReserveAuction_Cannot_Bid_Lower_Than_Reserve_Price(auction.amount);
415       }
416 
417       // Notify other market tools that an auction for this NFT has been kicked off.
418       _afterAuctionStarted(auction.nftContract, auction.tokenId);
419 
420       // Store the bid details.
421       auction.amount = amount;
422       auction.bidder = payable(msg.sender);
423 
424       // On the first bid, set the endTime to now + duration.
425       unchecked {
426         // Duration is always set to 24hrs so the below can't overflow.
427         auction.endTime = block.timestamp + auction.duration;
428       }
429     } else {
430       if (auction.endTime < block.timestamp) {
431         // The auction has already ended.
432         revert NFTMarketReserveAuction_Cannot_Bid_On_Ended_Auction(auction.endTime);
433       } else if (auction.bidder == msg.sender) {
434         // We currently do not allow a bidder to increase their bid unless another user has outbid them first.
435         revert NFTMarketReserveAuction_Cannot_Rebid_Over_Outstanding_Bid();
436       } else if (amount < _getMinIncrement(auction.amount)) {
437         // If this bid outbids another, it must be at least 10% greater than the last bid.
438         revert NFTMarketReserveAuction_Bid_Must_Be_At_Least_Min_Amount(_getMinIncrement(auction.amount));
439       }
440 
441       // Cache and update bidder state
442       uint256 originalAmount = auction.amount;
443       address payable originalBidder = auction.bidder;
444       auction.amount = amount;
445       auction.bidder = payable(msg.sender);
446 
447       unchecked {
448         // When a bid outbids another, check to see if a time extension should apply.
449         // We confirmed that the auction has not ended, so endTime is always >= the current timestamp.
450         if (auction.endTime - block.timestamp < auction.extensionDuration) {
451           // Current time plus extension duration (always 15 mins) cannot overflow.
452           auction.endTime = block.timestamp + auction.extensionDuration;
453         }
454       }
455 
456       // Refund the previous bidder
457       _sendValueWithFallbackWithdraw(originalBidder, originalAmount, SEND_VALUE_GAS_LIMIT_SINGLE_RECIPIENT);
458     }
459 
460     emit ReserveAuctionBidPlaced(auctionId, msg.sender, amount, auction.endTime);
461   }
462 
463   /**
464    * @notice If an auction has been created but has not yet received bids, the reservePrice may be
465    * changed by the seller.
466    * @param auctionId The id of the auction to change.
467    * @param reservePrice The new reserve price for this auction.
468    */
469   function updateReserveAuction(uint256 auctionId, uint256 reservePrice) external onlyValidAuctionConfig(reservePrice) {
470     ReserveAuction storage auction = auctionIdToAuction[auctionId];
471     if (auction.seller != msg.sender) {
472       revert NFTMarketReserveAuction_Only_Owner_Can_Update_Auction(auction.seller);
473     } else if (auction.endTime != 0) {
474       revert NFTMarketReserveAuction_Cannot_Update_Auction_In_Progress();
475     }
476 
477     // Update the current reserve price.
478     auction.amount = reservePrice;
479 
480     emit ReserveAuctionUpdated(auctionId, reservePrice);
481   }
482 
483   /**
484    * @notice Settle an auction that has already ended.
485    * This will send the NFT to the highest bidder and distribute revenue for this sale.
486    * @param keepInEscrow If true, the NFT will be kept in escrow to save gas by avoiding
487    * redundant transfers if the NFT should remain in escrow, such as when the new owner
488    * sets a buy price or lists it in a new auction.
489    */
490   function _finalizeReserveAuction(uint256 auctionId, bool keepInEscrow) private {
491     ReserveAuction memory auction = auctionIdToAuction[auctionId];
492 
493     if (auction.endTime >= block.timestamp) {
494       revert NFTMarketReserveAuction_Cannot_Finalize_Auction_In_Progress(auction.endTime);
495     }
496 
497     // Remove the auction.
498     delete nftContractToTokenIdToAuctionId[auction.nftContract][auction.tokenId];
499     delete auctionIdToAuction[auctionId];
500 
501     if (!keepInEscrow) {
502       /*
503        * Save gas by calling core directly since it cannot have another escrow requirement
504        * (buy price set or another auction listed) until this one has been finalized.
505        */
506       NFTMarketCore._transferFromEscrow(auction.nftContract, auction.tokenId, auction.bidder, address(0));
507     }
508 
509     // Distribute revenue for this sale.
510     (uint256 f8nFee, uint256 creatorFee, uint256 ownerRev) = _distributeFunds(
511       auction.nftContract,
512       auction.tokenId,
513       auction.seller,
514       auction.amount
515     );
516 
517     emit ReserveAuctionFinalized(auctionId, auction.seller, auction.bidder, f8nFee, creatorFee, ownerRev);
518   }
519 
520   /**
521    * @inheritdoc NFTMarketCore
522    * @dev If an auction is found:
523    *  - If the auction is over, it will settle the auction and confirm the new seller won the auction.
524    *  - If the auction has not received a bid, it will invalidate the auction.
525    *  - If the auction is in progress, this will revert.
526    */
527   function _transferFromEscrow(
528     address nftContract,
529     uint256 tokenId,
530     address recipient,
531     address seller
532   ) internal virtual override {
533     uint256 auctionId = nftContractToTokenIdToAuctionId[nftContract][tokenId];
534     if (auctionId != 0) {
535       ReserveAuction storage auction = auctionIdToAuction[auctionId];
536       if (auction.endTime == 0) {
537         // The auction has not received any bids yet so it may be invalided.
538 
539         if (auction.seller != seller) {
540           // The account trying to transfer the NFT is not the current owner.
541           revert NFTMarketReserveAuction_Not_Matching_Seller(auction.seller);
542         }
543 
544         // Remove the auction.
545         delete nftContractToTokenIdToAuctionId[nftContract][tokenId];
546         delete auctionIdToAuction[auctionId];
547 
548         emit ReserveAuctionInvalidated(auctionId);
549       } else {
550         // If the auction has started, the highest bidder will be the new owner.
551 
552         if (auction.bidder != seller) {
553           revert NFTMarketReserveAuction_Not_Matching_Seller(auction.bidder);
554         }
555 
556         // Finalization will revert if the auction has not yet ended.
557         _finalizeReserveAuction(auctionId, false);
558 
559         // Finalize includes the transfer, so we are done here.
560         return;
561       }
562     }
563 
564     super._transferFromEscrow(nftContract, tokenId, recipient, seller);
565   }
566 
567   /**
568    * @inheritdoc NFTMarketCore
569    * @dev Checks if there is an auction for this NFT before allowing the transfer to continue.
570    */
571   function _transferFromEscrowIfAvailable(
572     address nftContract,
573     uint256 tokenId,
574     address recipient
575   ) internal virtual override {
576     if (nftContractToTokenIdToAuctionId[nftContract][tokenId] == 0) {
577       // No auction was found
578 
579       super._transferFromEscrowIfAvailable(nftContract, tokenId, recipient);
580     }
581   }
582 
583   /**
584    * @inheritdoc NFTMarketCore
585    */
586   function _transferToEscrow(address nftContract, uint256 tokenId) internal virtual override {
587     uint256 auctionId = nftContractToTokenIdToAuctionId[nftContract][tokenId];
588     if (auctionId == 0) {
589       // NFT is not in auction
590       super._transferToEscrow(nftContract, tokenId);
591       return;
592     }
593     // Using storage saves gas since most of the data is not needed
594     ReserveAuction storage auction = auctionIdToAuction[auctionId];
595     if (auction.endTime == 0) {
596       // Reserve price set, confirm the seller is a match
597       if (auction.seller != msg.sender) {
598         revert NFTMarketReserveAuction_Not_Matching_Seller(auction.seller);
599       }
600     } else {
601       // Auction in progress, confirm the highest bidder is a match
602       if (auction.bidder != msg.sender) {
603         revert NFTMarketReserveAuction_Not_Matching_Seller(auction.bidder);
604       }
605 
606       // Finalize auction but leave NFT in escrow, reverts if the auction has not ended
607       _finalizeReserveAuction(auctionId, true);
608     }
609   }
610 
611   /**
612    * @notice Returns the minimum amount a bidder must spend to participate in an auction.
613    * Bids must be greater than or equal to this value or they will revert.
614    * @param auctionId The id of the auction to check.
615    * @return minimum The minimum amount for a bid to be accepted.
616    */
617   function getMinBidAmount(uint256 auctionId) external view returns (uint256 minimum) {
618     ReserveAuction storage auction = auctionIdToAuction[auctionId];
619     if (auction.endTime == 0) {
620       return auction.amount;
621     }
622     return _getMinIncrement(auction.amount);
623   }
624 
625   /**
626    * @notice Returns auction details for a given auctionId.
627    * @param auctionId The id of the auction to lookup.
628    * @return auction The auction details.
629    */
630   function getReserveAuction(uint256 auctionId) external view returns (ReserveAuction memory auction) {
631     return auctionIdToAuction[auctionId];
632   }
633 
634   /**
635    * @notice Returns the auctionId for a given NFT, or 0 if no auction is found.
636    * @dev If an auction is canceled, it will not be returned. However the auction may be over and pending finalization.
637    * @param nftContract The address of the NFT contract.
638    * @param tokenId The id of the NFT.
639    * @return auctionId The id of the auction, or 0 if no auction is found.
640    */
641   function getReserveAuctionIdFor(address nftContract, uint256 tokenId) external view returns (uint256 auctionId) {
642     return nftContractToTokenIdToAuctionId[nftContract][tokenId];
643   }
644 
645   /**
646    * @inheritdoc NFTMarketCore
647    * @dev Returns the seller that has the given NFT in escrow for an auction,
648    * or bubbles the call up for other considerations.
649    */
650   function _getSellerFor(address nftContract, uint256 tokenId)
651     internal
652     view
653     virtual
654     override
655     returns (address payable seller)
656   {
657     seller = auctionIdToAuction[nftContractToTokenIdToAuctionId[nftContract][tokenId]].seller;
658     if (seller == address(0)) {
659       seller = super._getSellerFor(nftContract, tokenId);
660     }
661   }
662 
663   /**
664    * @inheritdoc NFTMarketCore
665    */
666   function _isInActiveAuction(address nftContract, uint256 tokenId) internal view override returns (bool) {
667     uint256 auctionId = nftContractToTokenIdToAuctionId[nftContract][tokenId];
668     return auctionId != 0 && auctionIdToAuction[auctionId].endTime >= block.timestamp;
669   }
670 
671   /**
672    * @notice This empty reserved space is put in place to allow future versions to add new
673    * variables without shifting down storage in the inheritance chain.
674    * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
675    */
676   uint256[1000] private __gap;
677 }
