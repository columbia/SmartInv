1 pragma solidity ^0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 // input  /Users/howard/Documents/programming/dapperlabs/ck-offers-contracts/contracts/Offers.sol
6 // flattened :  Tuesday, 04-Dec-18 19:41:54 UTC
7 contract OffersAccessControl {
8 
9     // The address of the account that can replace ceo, coo, cfo, lostAndFound
10     address public ceoAddress;
11     // The address of the account that can adjust configuration variables and fulfill offer
12     address public cooAddress;
13     // The address of the CFO account that receives all the fees
14     address public cfoAddress;
15     // The address where funds of failed "push"es go to
16     address public lostAndFoundAddress;
17 
18     // The total amount of ether (in wei) in escrow owned by CFO
19     uint256 public totalCFOEarnings;
20     // The total amount of ether (in wei) in escrow owned by lostAndFound
21     uint256 public totalLostAndFoundBalance;
22 
23     /// @notice Keeps track whether the contract is frozen.
24     ///  When frozen is set to be true, it cannot be set back to false again,
25     ///  and all whenNotFrozen actions will be blocked.
26     bool public frozen = false;
27 
28     /// @notice Access modifier for CEO-only functionality
29     modifier onlyCEO() {
30         require(msg.sender == ceoAddress, "only CEO is allowed to perform this operation");
31         _;
32     }
33 
34     /// @notice Access modifier for COO-only functionality
35     modifier onlyCOO() {
36         require(msg.sender == cooAddress, "only COO is allowed to perform this operation");
37         _;
38     }
39 
40     /// @notice Access modifier for CFO-only functionality
41     modifier onlyCFO() {
42         require(
43             msg.sender == cfoAddress &&
44             msg.sender != address(0),
45             "only CFO is allowed to perform this operation"
46         );
47         _;
48     }
49 
50     /// @notice Access modifier for CEO-only or CFO-only functionality
51     modifier onlyCeoOrCfo() {
52         require(
53             msg.sender != address(0) &&
54             (
55                 msg.sender == ceoAddress ||
56                 msg.sender == cfoAddress
57             ),
58             "only CEO or CFO is allowed to perform this operation"
59         );
60         _;
61     }
62 
63     /// @notice Access modifier for LostAndFound-only functionality
64     modifier onlyLostAndFound() {
65         require(
66             msg.sender == lostAndFoundAddress &&
67             msg.sender != address(0),
68             "only LostAndFound is allowed to perform this operation"
69         );
70         _;
71     }
72 
73     /// @notice Assigns a new address to act as the CEO. Only available to the current CEO.
74     /// @param _newCEO The address of the new CEO
75     function setCEO(address _newCEO) external onlyCEO {
76         require(_newCEO != address(0), "new CEO address cannot be the zero-account");
77         ceoAddress = _newCEO;
78     }
79 
80     /// @notice Assigns a new address to act as the COO. Only available to the current CEO.
81     /// @param _newCOO The address of the new COO
82     function setCOO(address _newCOO) public onlyCEO {
83         require(_newCOO != address(0), "new COO address cannot be the zero-account");
84         cooAddress = _newCOO;
85     }
86 
87     /// @notice Assigns a new address to act as the CFO. Only available to the current CEO.
88     /// @param _newCFO The address of the new CFO
89     function setCFO(address _newCFO) external onlyCEO {
90         require(_newCFO != address(0), "new CFO address cannot be the zero-account");
91         cfoAddress = _newCFO;
92     }
93 
94     /// @notice Assigns a new address to act as the LostAndFound account. Only available to the current CEO.
95     /// @param _newLostAndFound The address of the new lostAndFound address
96     function setLostAndFound(address _newLostAndFound) external onlyCEO {
97         require(_newLostAndFound != address(0), "new lost and found cannot be the zero-account");
98         lostAndFoundAddress = _newLostAndFound;
99     }
100 
101     /// @notice CFO withdraws the CFO earnings
102     function withdrawTotalCFOEarnings() external onlyCFO {
103         // Obtain reference
104         uint256 balance = totalCFOEarnings;
105         totalCFOEarnings = 0;
106         cfoAddress.transfer(balance);
107     }
108 
109     /// @notice LostAndFound account withdraws all the lost and found amount
110     function withdrawTotalLostAndFoundBalance() external onlyLostAndFound {
111         // Obtain reference
112         uint256 balance = totalLostAndFoundBalance;
113         totalLostAndFoundBalance = 0;
114         lostAndFoundAddress.transfer(balance);
115     }
116 
117     /// @notice Modifier to allow actions only when the contract is not frozen
118     modifier whenNotFrozen() {
119         require(!frozen, "contract needs to not be frozen");
120         _;
121     }
122 
123     /// @notice Modifier to allow actions only when the contract is frozen
124     modifier whenFrozen() {
125         require(frozen, "contract needs to be frozen");
126         _;
127     }
128 
129     /// @notice Called by CEO or CFO role to freeze the contract.
130     ///  Only intended to be used if a serious exploit is detected.
131     /// @notice Allow two C-level roles to call this function in case either CEO or CFO key is compromised.
132     /// @notice This is a one-way process; there is no un-freezing.
133     /// @dev A frozen contract will be frozen forever, there's no way to undo this action.
134     function freeze() external onlyCeoOrCfo whenNotFrozen {
135         frozen = true;
136     }
137 
138 }
139 
140 contract ERC721 {
141     // Required methods
142     function totalSupply() public view returns (uint256 total);
143     function balanceOf(address _owner) public view returns (uint256 balance);
144     function ownerOf(uint256 _tokenId) external view returns (address owner);
145     function approve(address _to, uint256 _tokenId) external;
146     function transfer(address _to, uint256 _tokenId) external;
147     function transferFrom(address _from, address _to, uint256 _tokenId) external;
148 
149     // Events
150     event Transfer(address from, address to, uint256 tokenId);
151     event Approval(address owner, address approved, uint256 tokenId);
152 
153     // Optional
154     // function name() public view returns (string name);
155     // function symbol() public view returns (string symbol);
156     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
157     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
158 
159     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
160     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
161 }
162 
163 contract OffersConfig is OffersAccessControl {
164 
165     /* ************************* */
166     /* ADJUSTABLE CONFIGURATIONS */
167     /* ************************* */
168 
169     // The duration (in seconds) of all offers that are created. This parameter is also used in calculating
170     // new expiration times when extending offers.
171     uint256 public globalDuration;
172     // The global minimum offer value (price + offer fee, in wei)
173     uint256 public minimumTotalValue;
174     // The minimum overbid increment % (expressed in basis points, which is 1/100 of a percent)
175     // For basis points, values 0-10,000 map to 0%-100%
176     uint256 public minimumPriceIncrement;
177 
178     /* *************** */
179     /* ADJUSTABLE FEES */
180     /* *************** */
181 
182     // Throughout the various contracts there will be various symbols used for the purpose of a clear display
183     // of the underlying mathematical formulation. Specifically,
184     //
185     //          - T: This is the total amount of funds associated with an offer, comprised of 1) the offer
186     //                  price which the bidder is proposing the owner of the token receive, and 2) an amount
187     //                  that is the maximum the main Offers contract will ever take - this is when the offer
188     //                  is cancelled, or fulfilled. In other scenarios, the amount taken by the main contract
189     //                  may be less, depending on other configurations.
190     //
191     //          - S: This is called the offerCut, expressed as a basis point. This determines the maximum amount
192     //                  of ether the main contract can ever take in the various possible outcomes of an offer
193     //                  (cancelled, expired, overbid, fulfilled, updated).
194     //
195     //          - P: This simply refers to the price that the bidder is offering the owner receive, upon
196     //                  fulfillment of the offer process.
197     //
198     //          - Below is the formula that ties the symbols listed above together (S is % for brevity):
199     //                  T = P + S * P
200 
201     // Flat fee (in wei) the main contract takes when offer has been expired or overbid. The fee serves as a
202     // disincentive for abuse and allows recoupment of ether spent calling batchRemoveExpired on behalf of users.
203     uint256 public unsuccessfulFee;
204     // This is S, the maximum % the main contract takes on each offer. S represents the total amount paid when
205     // an offer has been fulfilled or cancelled.
206     uint256 public offerCut;
207 
208     /* ****** */
209     /* EVENTS */
210     /* ****** */
211 
212     event GlobalDurationUpdated(uint256 value);
213     event MinimumTotalValueUpdated(uint256 value);
214     event MinimumPriceIncrementUpdated(uint256 value);
215     event OfferCutUpdated(uint256 value);
216     event UnsuccessfulFeeUpdated(uint256 value);
217 
218     /* ********* */
219     /* FUNCTIONS */
220     /* ********* */
221 
222     /// @notice Sets the minimumTotalValue value. This would impact offers created after this has been set, but
223     ///  not existing offers.
224     /// @notice Only callable by COO, when not frozen.
225     /// @param _newMinTotal The minimumTotalValue value to set
226     function setMinimumTotalValue(uint256 _newMinTotal) external onlyCOO whenNotFrozen {
227         _setMinimumTotalValue(_newMinTotal, unsuccessfulFee);
228         emit MinimumTotalValueUpdated(_newMinTotal);
229     }
230 
231     /// @notice Sets the globalDuration value. All offers that are created or updated will compute a new expiration
232     ///  time based on this.
233     /// @notice Only callable by COO, when not frozen.
234     /// @dev Need to check for underflow since function argument is 256 bits, and the offer expiration time is
235     ///  packed into 64 bits in the Offer struct.
236     /// @param _newDuration The globalDuration value to set.
237     function setGlobalDuration(uint256 _newDuration) external onlyCOO whenNotFrozen {
238         require(_newDuration == uint256(uint64(_newDuration)), "new globalDuration value must not underflow");
239         globalDuration = _newDuration;
240         emit GlobalDurationUpdated(_newDuration);
241     }
242 
243     /// @notice Sets the offerCut value. All offers will compute a fee taken by this contract based on this
244     ///  configuration.
245     /// @notice Only callable by COO, when not frozen.
246     /// @dev As this configuration is a basis point, the value to set must be less than or equal to 10000.
247     /// @param _newOfferCut The offerCut value to set.
248     function setOfferCut(uint256 _newOfferCut) external onlyCOO whenNotFrozen {
249         _setOfferCut(_newOfferCut);
250         emit OfferCutUpdated(_newOfferCut);
251     }
252 
253     /// @notice Sets the unsuccessfulFee value. All offers that are unsuccessful (overbid or expired)
254     ///  will have a flat fee taken by the main contract before being refunded to bidders.
255     /// @notice Given Tmin (_minTotal), flat fee (_unsuccessfulFee),
256     ///  Tmin ≥ (2 * flat fee) guarantees that offer prices ≥ flat fee, always. This is important to prevent the
257     ///  existence of offers that, when overbid or expired, would result in the main contract taking too big of a cut.
258     ///  In the case of a sufficiently low offer price, eg. the same as unsuccessfulFee, the most the main contract can
259     ///  ever take is simply the amount of unsuccessfulFee.
260     /// @notice Only callable by COO, when not frozen.
261     /// @param _newUnsuccessfulFee The unsuccessfulFee value to set.
262     function setUnsuccessfulFee(uint256 _newUnsuccessfulFee) external onlyCOO whenNotFrozen {
263         require(minimumTotalValue >= (2 * _newUnsuccessfulFee), "unsuccessful value must be <= half of minimumTotalValue");
264         unsuccessfulFee = _newUnsuccessfulFee;
265         emit UnsuccessfulFeeUpdated(_newUnsuccessfulFee);
266     }
267 
268     /// @notice Sets the minimumPriceIncrement value. All offers that are overbid must have a price greater
269     ///  than the minimum increment computed from this basis point.
270     /// @notice Only callable by COO, when not frozen.
271     /// @dev As this configuration is a basis point, the value to set must be less than or equal to 10000.
272     /// @param _newMinimumPriceIncrement The minimumPriceIncrement value to set.
273     function setMinimumPriceIncrement(uint256 _newMinimumPriceIncrement) external onlyCOO whenNotFrozen {
274         _setMinimumPriceIncrement(_newMinimumPriceIncrement);
275         emit MinimumPriceIncrementUpdated(_newMinimumPriceIncrement);
276     }
277 
278     /// @notice Utility function used internally for the setMinimumTotalValue method.
279     /// @notice Given Tmin (_minTotal), flat fee (_unsuccessfulFee),
280     ///  Tmin ≥ (2 * flat fee) guarantees that offer prices ≥ flat fee, always. This is important to prevent the
281     ///  existence of offers that, when overbid or expired, would result in the main contract taking too big of a cut.
282     ///  In the case of a sufficiently low offer price, eg. the same as unsuccessfulFee, the most the main contract can
283     ///  ever take is simply the amount of unsuccessfulFee.
284     /// @param _newMinTotal The minimumTotalValue value to set.
285     /// @param _unsuccessfulFee The unsuccessfulFee value used to check if the _minTotal specified
286     ///  is too low.
287     function _setMinimumTotalValue(uint256 _newMinTotal, uint256 _unsuccessfulFee) internal {
288         require(_newMinTotal >= (2 * _unsuccessfulFee), "minimum value must be >= 2 * unsuccessful fee");
289         minimumTotalValue = _newMinTotal;
290     }
291 
292     /// @dev As offerCut is a basis point, the value to set must be less than or equal to 10000.
293     /// @param _newOfferCut The offerCut value to set.
294     function _setOfferCut(uint256 _newOfferCut) internal {
295         require(_newOfferCut <= 1e4, "offer cut must be a valid basis point");
296         offerCut = _newOfferCut;
297     }
298 
299     /// @dev As minimumPriceIncrement is a basis point, the value to set must be less than or equal to 10000.
300     /// @param _newMinimumPriceIncrement The minimumPriceIncrement value to set.
301     function _setMinimumPriceIncrement(uint256 _newMinimumPriceIncrement) internal {
302         require(_newMinimumPriceIncrement <= 1e4, "minimum price increment must be a valid basis point");
303         minimumPriceIncrement = _newMinimumPriceIncrement;
304     }
305 }
306 
307 contract OffersBase is OffersConfig {
308     /*** EVENTS ***/
309 
310     /// @notice The OfferCreated event is emitted when an offer is created through
311     ///  createOffer method.
312     /// @param tokenId The token id that a bidder is offering to buy from the owner.
313     /// @param bidder The creator of the offer.
314     /// @param expiresAt The timestamp when the offer will be expire.
315     /// @param total The total eth value the bidder sent to the Offer contract.
316     /// @param offerPrice The eth price that the owner of the token will receive
317     ///  if the offer is accepted.
318     event OfferCreated(
319         uint256 tokenId,
320         address bidder,
321         uint256 expiresAt,
322         uint256 total,
323         uint256 offerPrice
324     );
325 
326     /// @notice The OfferCancelled event is emitted when an offer is cancelled before expired.
327     /// @param tokenId The token id that the cancelled offer was offering to buy.
328     /// @param bidder The creator of the offer.
329     /// @param bidderReceived The eth amount that the bidder received as refund.
330     /// @param fee The eth amount that CFO received as the fee for the cancellation.
331     event OfferCancelled(
332         uint256 tokenId,
333         address bidder,
334         uint256 bidderReceived,
335         uint256 fee
336     );
337 
338     /// @notice The OfferFulfilled event is emitted when an active offer has been fulfilled, meaning
339     ///  the bidder now owns the token, and the orignal owner receives the eth amount from the offer.
340     /// @param tokenId The token id that the fulfilled offer was offering to buy.
341     /// @param bidder The creator of the offer.
342     /// @param owner The original owner of the token who accepted the offer.
343     /// @param ownerReceived The eth amount that the original owner received from the offer
344     /// @param fee The eth amount that CFO received as the fee for the successfully fulfilling.
345     event OfferFulfilled(
346         uint256 tokenId,
347         address bidder,
348         address owner,
349         uint256 ownerReceived,
350         uint256 fee
351     );
352 
353     /// @notice The OfferUpdated event is emitted when an active offer was either extended the expiry
354     ///  or raised the price.
355     /// @param tokenId The token id that the updated offer was offering to buy.
356     /// @param bidder The creator of the offer, also is whom updated the offer.
357     /// @param newExpiresAt The new expiry date of the updated offer.
358     /// @param totalRaised The total eth value the bidder sent to the Offer contract to raise the offer.
359     ///  if the totalRaised is 0, it means the offer was extended without raising the price.
360     event OfferUpdated(
361         uint256 tokenId,
362         address bidder,
363         uint256 newExpiresAt,
364         uint256 totalRaised
365     );
366 
367     /// @notice The ExpiredOfferRemoved event is emitted when an expired offer gets removed. The eth value will
368     ///  be returned to the bidder's account, excluding the fee.
369     /// @param tokenId The token id that the removed offer was offering to buy
370     /// @param bidder The creator of the offer.
371     /// @param bidderReceived The eth amount that the bidder received from the offer.
372     /// @param fee The eth amount that CFO received as the fee.
373     event ExpiredOfferRemoved(
374       uint256 tokenId,
375       address bidder,
376       uint256 bidderReceived,
377       uint256 fee
378     );
379 
380     /// @notice The BidderWithdrewFundsWhenFrozen event is emitted when a bidder withdrew their eth value of
381     ///  the offer when the contract is frozen.
382     /// @param tokenId The token id that withdrawed offer was offering to buy
383     /// @param bidder The creator of the offer, also is whom withdrawed the fund.
384     /// @param amount The total amount that the bidder received.
385     event BidderWithdrewFundsWhenFrozen(
386         uint256 tokenId,
387         address bidder,
388         uint256 amount
389     );
390 
391 
392     /// @dev The PushFundsFailed event is emitted when the Offer contract fails to send certain amount of eth
393     ///  to an address, e.g. sending the fund back to the bidder when the offer was overbidden by a higher offer.
394     /// @param tokenId The token id of an offer that the sending fund is involved.
395     /// @param to The address that is supposed to receive the fund but failed for any reason.
396     /// @param amount The eth amount that the receiver fails to receive.
397     event PushFundsFailed(
398         uint256 tokenId,
399         address to,
400         uint256 amount
401     );
402 
403     /*** DATA TYPES ***/
404 
405     /// @dev The Offer struct. The struct fits in two 256-bits words.
406     struct Offer {
407         // Time when offer expires
408         uint64 expiresAt;
409         // Bidder The creator of the offer
410         address bidder;
411         // Offer cut in basis points, which ranges from 0-10000.
412         // It's the cut that CFO takes when the offer is successfully accepted by the owner.
413         // This is stored in the offer struct so that it won't be changed if COO updates
414         // the `offerCut` for new offers.
415         uint16 offerCut;
416         // Total value (in wei) a bidder sent in msg.value to create the offer
417         uint128 total;
418         // Fee (in wei) that CFO takes when the offer is expired or overbid.
419         // This is stored in the offer struct so that it won't be changed if COO updates
420         // the `unsuccessfulFee` for new offers.
421         uint128 unsuccessfulFee;
422     }
423 
424     /*** STORAGE ***/
425     /// @notice Mapping from token id to its corresponding offer.
426     /// @dev One token can only have one offer.
427     ///  Making it public so that solc-0.4.24 will generate code to query offer by a given token id.
428     mapping (uint256 => Offer) public tokenIdToOffer;
429 
430     /// @notice computes the minimum offer price to overbid a given offer with its offer price.
431     ///  The new offer price has to be a certain percentage, which defined by `minimumPriceIncrement`,
432     ///  higher than the previous offer price.
433     /// @dev This won't overflow, because `_offerPrice` is in uint128, and `minimumPriceIncrement`
434     ///  is 16 bits max.
435     /// @param _offerPrice The amount of ether in wei as the offer price
436     /// @return The minimum amount of ether in wei to overbid the given offer price
437     function _computeMinimumOverbidPrice(uint256 _offerPrice) internal view returns (uint256) {
438         return _offerPrice * (1e4 + minimumPriceIncrement) / 1e4;
439     }
440 
441     /// @notice Computes the offer price that the owner will receive if the offer is accepted.
442     /// @dev This is safe against overflow because msg.value and the total supply of ether is capped within 128 bits.
443     /// @param _total The total value of the offer. Also is the msg.value that the bidder sent when
444     ///  creating the offer.
445     /// @param _offerCut The percentage in basis points that will be taken by the CFO if the offer is fulfilled.
446     /// @return The offer price that the owner will receive if the offer is fulfilled.
447     function _computeOfferPrice(uint256 _total, uint256 _offerCut) internal pure returns (uint256) {
448         return _total * 1e4 / (1e4 + _offerCut);
449     }
450 
451     /// @notice Check if an offer exists or not by checking the expiresAt field of the offer.
452     ///  True if exists, False if not.
453     /// @dev Assuming the expiresAt field is from the offer struct in storage.
454     /// @dev Since expiry check always come right after the offer existance check, it will save some gas by checking
455     /// both existance and expiry on one field, as it only reads from the storage once.
456     /// @param _expiresAt The time at which the offer we want to validate expires.
457     /// @return True or false (if the offer exists not).
458     function _offerExists(uint256 _expiresAt) internal pure returns (bool) {
459         return _expiresAt > 0;
460     }
461 
462     /// @notice Check if an offer is still active by checking the expiresAt field of the offer. True if the offer is,
463     ///  still active, False if the offer has expired,
464     /// @dev Assuming the expiresAt field is from the offer struct in storage.
465     /// @param _expiresAt The time at which the offer we want to validate expires.
466     /// @return True or false (if the offer has expired or not).
467     function _isOfferActive(uint256 _expiresAt) internal view returns (bool) {
468         return now < _expiresAt;
469     }
470 
471     /// @dev Try pushing the fund to an address.
472     /// @notice If sending the fund to the `_to` address fails for whatever reason, then the logic
473     ///  will continue and the amount will be kept under the LostAndFound account. Also an event `PushFundsFailed`
474     ///  will be emitted for notifying the failure.
475     /// @param _tokenId The token id for the offer.
476     /// @param _to The address the main contract is attempting to send funds to.
477     /// @param _amount The amount of funds (in wei) the main contract is attempting to send.
478     function _tryPushFunds(uint256 _tokenId, address _to, uint256 _amount) internal {
479         // Sending the amount of eth in wei, and handling the failure.
480         // The gas spent transferring funds has a set upper limit
481         bool success = _to.send(_amount);
482         if (!success) {
483             // If failed sending to the `_to` address, then keep the amount under the LostAndFound account by
484             // accumulating totalLostAndFoundBalance.
485             totalLostAndFoundBalance = totalLostAndFoundBalance + _amount;
486 
487             // Emitting the event lost amount.
488             emit PushFundsFailed(_tokenId, _to, _amount);
489         }
490     }
491 }
492 
493 contract Offers is OffersBase {
494 
495     // This is the main Offers contract. In order to keep our code separated into logical sections,
496     // we've broken it up into multiple files using inheritance. This allows us to keep related code
497     // collocated while still avoiding a single large file, which would be harder to maintain. The breakdown
498     // is as follows:
499     //
500     //      - OffersBase: This contract defines the fundamental code that the main contract uses.
501     //              This includes our main data storage, data types, events, and internal functions for
502     //              managing offers in their lifecycle.
503     //
504     //      - OffersConfig: This contract manages the various configuration values that determine the
505     //              details of the offers that get created, cancelled, overbid, expired, and fulfilled,
506     //              as well as the fee structure that the offers will be operating with.
507     //
508     //      - OffersAccessControl: This contract manages the various addresses and constraints for
509     //              operations that can be executed only by specific roles. The roles are: CEO, CFO,
510     //              COO, and LostAndFound. Additionally, this contract exposes functions for the CFO
511     //              to withdraw earnings and the LostAndFound account to withdraw any lost funds.
512 
513     /// @dev The ERC-165 interface signature for ERC-721.
514     ///  Ref: https://github.com/ethereum/EIPs/issues/165
515     ///  Ref: https://github.com/ethereum/EIPs/issues/721
516     bytes4 constant InterfaceSignature_ERC721 = bytes4(0x9a20483d);
517 
518     // Reference to contract tracking NFT ownership
519     ERC721 public nonFungibleContract;
520 
521     /// @notice Creates the main Offers smart contract instance and sets initial configuration values
522     /// @param _nftAddress The address of the ERC-721 contract managing NFT ownership
523     /// @param _cooAddress The address of the COO to set
524     /// @param _globalDuration The initial globalDuration value to set
525     /// @param _minimumTotalValue The initial minimumTotalValue value to set
526     /// @param _minimumPriceIncrement The initial minimumPriceIncrement value to set
527     /// @param _unsuccessfulFee The initial unsuccessfulFee value to set
528     /// @param _offerCut The initial offerCut value to set
529     constructor(
530       address _nftAddress,
531       address _cooAddress,
532       uint256 _globalDuration,
533       uint256 _minimumTotalValue,
534       uint256 _minimumPriceIncrement,
535       uint256 _unsuccessfulFee,
536       uint256 _offerCut
537     ) public {
538         // The creator of the contract is the ceo
539         ceoAddress = msg.sender;
540 
541         // Get reference of the address of the NFT contract
542         ERC721 candidateContract = ERC721(_nftAddress);
543         require(candidateContract.supportsInterface(InterfaceSignature_ERC721), "NFT Contract needs to support ERC721 Interface");
544         nonFungibleContract = candidateContract;
545 
546         setCOO(_cooAddress);
547 
548         // Set initial claw-figuration values
549         globalDuration = _globalDuration;
550         unsuccessfulFee = _unsuccessfulFee;
551         _setOfferCut(_offerCut);
552         _setMinimumPriceIncrement(_minimumPriceIncrement);
553         _setMinimumTotalValue(_minimumTotalValue, _unsuccessfulFee);
554     }
555 
556     /// @notice Creates an offer on a token. This contract receives bidders funds and refunds the previous bidder
557     ///  if this offer overbids a previously active (unexpired) offer.
558     /// @notice When this offer overbids a previously active offer, this offer must have a price greater than
559     ///  a certain percentage of the previous offer price, which the minimumOverbidPrice basis point specifies.
560     ///  A flat fee is also taken from the previous offer before refund the previous bidder.
561     /// @notice When there is a previous offer that has already expired but not yet been removed from storage,
562     ///  the new offer can be created with any total value as long as it is greater than the minimumTotalValue.
563     /// @notice Works only when contract is not frozen.
564     /// @param _tokenId The token a bidder wants to create an offer for
565     function createOffer(uint256 _tokenId) external payable whenNotFrozen {
566         // T = msg.value
567         // Check that the total amount of the offer isn't below the meow-nimum
568         require(msg.value >= minimumTotalValue, "offer total value must be above minimumTotalValue");
569 
570         uint256 _offerCut = offerCut;
571 
572         // P, the price that owner will see and receive if the offer is accepted.
573         uint256 offerPrice = _computeOfferPrice(msg.value, _offerCut);
574 
575         Offer storage previousOffer = tokenIdToOffer[_tokenId];
576         uint256 previousExpiresAt = previousOffer.expiresAt;
577 
578         uint256 toRefund = 0;
579 
580         // Check if tokenId already has an offer
581         if (_offerExists(previousExpiresAt)) {
582             uint256 previousOfferTotal = uint256(previousOffer.total);
583 
584             // If the previous offer is still active, the new offer needs to match the previous offer's price
585             // plus a minimum required increment (minimumOverbidPrice).
586             // We calculate the previous offer's price, the corresponding minimumOverbidPrice, and check if the
587             // new offerPrice is greater than or equal to the minimumOverbidPrice
588             // The owner is fur-tunate to have such a desirable kitty
589             if (_isOfferActive(previousExpiresAt)) {
590                 uint256 previousPriceForOwner = _computeOfferPrice(previousOfferTotal, uint256(previousOffer.offerCut));
591                 uint256 minimumOverbidPrice = _computeMinimumOverbidPrice(previousPriceForOwner);
592                 require(offerPrice >= minimumOverbidPrice, "overbid price must match minimum price increment criteria");
593             }
594 
595             uint256 cfoEarnings = previousOffer.unsuccessfulFee;
596             // Bidder gets refund: T - flat fee
597             // The in-fur-ior offer gets refunded for free, how nice.
598             toRefund = previousOfferTotal - cfoEarnings;
599 
600             totalCFOEarnings += cfoEarnings;
601         }
602 
603         uint256 newExpiresAt = now + globalDuration;
604 
605         // Get a reference of previous bidder address before overwriting with new offer.
606         // This is only needed if there is refund
607         address previousBidder;
608         if (toRefund > 0) {
609             previousBidder = previousOffer.bidder;
610         }
611 
612         tokenIdToOffer[_tokenId] = Offer(
613             uint64(newExpiresAt),
614             msg.sender,
615             uint16(_offerCut),
616             uint128(msg.value),
617             uint128(unsuccessfulFee)
618         );
619 
620         // Postpone the refund until the previous offer has been overwritten by the new offer.
621         if (toRefund > 0) {
622             // Finally, sending funds to this bidder. If failed, the fund will be kept in escrow
623             // under lostAndFound's address
624             _tryPushFunds(
625                 _tokenId,
626                 previousBidder,
627                 toRefund
628             );
629         }
630 
631         emit OfferCreated(
632             _tokenId,
633             msg.sender,
634             newExpiresAt,
635             msg.value,
636             offerPrice
637         );
638     }
639 
640     /// @notice Cancels an offer that must exist and be active currently. This moves funds from this contract
641     ///  back to the the bidder, after a cut has been taken.
642     /// @notice Works only when contract is not frozen.
643     /// @param _tokenId The token specified by the offer a bidder wants to cancel
644     function cancelOffer(uint256 _tokenId) external whenNotFrozen {
645         // Check that offer exists and is active currently
646         Offer storage offer = tokenIdToOffer[_tokenId];
647         uint256 expiresAt = offer.expiresAt;
648         require(_offerExists(expiresAt), "offer to cancel must exist");
649         require(_isOfferActive(expiresAt), "offer to cancel must not be expired");
650 
651         address bidder = offer.bidder;
652         require(msg.sender == bidder, "caller must be bidder of offer to be cancelled");
653 
654         // T
655         uint256 total = uint256(offer.total);
656         // P = T - S; Bidder gets all of P, CFO gets all of T - P
657         uint256 toRefund = _computeOfferPrice(total, offer.offerCut);
658         uint256 cfoEarnings = total - toRefund;
659 
660         // Remove offer from storage
661         delete tokenIdToOffer[_tokenId];
662 
663         // Add to CFO's balance
664         totalCFOEarnings += cfoEarnings;
665 
666         // Transfer money in escrow back to bidder
667         _tryPushFunds(_tokenId, bidder, toRefund);
668 
669         emit OfferCancelled(
670             _tokenId,
671             bidder,
672             toRefund,
673             cfoEarnings
674         );
675     }
676 
677     /// @notice Fulfills an offer that must exist and be active currently. This moves the funds of the
678     ///  offer held in escrow in this contract to the owner of the token, and atomically transfers the
679     ///  token from the owner to the bidder. A cut is taken by this contract.
680     /// @notice We also acknowledge the paw-sible difficulties of keeping in-sync with the Ethereum
681     ///  blockchain, and have allowed for fulfilling offers by specifying the _minOfferPrice at which the owner
682     ///  of the token is happy to accept the offer. Thus, the owner will always receive the latest offer
683     ///  price, which can only be at least the _minOfferPrice that was specified. Specifically, this
684     ///  implementation is designed to prevent the edge case where the owner accidentally accepts an offer
685     ///  with a price lower than intended. For example, this can happen when the owner fulfills the offer
686     ///  precisely when the offer expires and is subsequently replaced with a new offer priced lower.
687     /// @notice Works only when contract is not frozen.
688     /// @dev We make sure that the token is not on auction when we fulfill an offer, because the owner of the
689     ///  token would be the auction contract instead of the user. This function requires that this Offers contract
690     ///  is approved for the token in order to make the call to transfer token ownership. This is sufficient
691     ///  because approvals are cleared on transfer (including transfer to the auction).
692     /// @param _tokenId The token specified by the offer that will be fulfilled.
693     /// @param _minOfferPrice The minimum price at which the owner of the token is happy to accept the offer.
694     function fulfillOffer(uint256 _tokenId, uint128 _minOfferPrice) external whenNotFrozen {
695         // Check that offer exists and is active currently
696         Offer storage offer = tokenIdToOffer[_tokenId];
697         uint256 expiresAt = offer.expiresAt;
698         require(_offerExists(expiresAt), "offer to fulfill must exist");
699         require(_isOfferActive(expiresAt), "offer to fulfill must not be expired");
700 
701         // Get the owner of the token
702         address owner = nonFungibleContract.ownerOf(_tokenId);
703 
704         require(msg.sender == cooAddress || msg.sender == owner, "only COO or the owner can fulfill order");
705 
706         // T
707         uint256 total = uint256(offer.total);
708         // P = T - S
709         uint256 offerPrice = _computeOfferPrice(total, offer.offerCut);
710 
711         // Check if the offer price is below the minimum that the owner is happy to accept the offer for
712         require(offerPrice >= _minOfferPrice, "cannot fulfill offer – offer price too low");
713 
714         // Get a reference of the bidder address befur removing offer from storage
715         address bidder = offer.bidder;
716 
717         // Remove offer from storage
718         delete tokenIdToOffer[_tokenId];
719 
720         // Transfer token on behalf of owner to bidder
721         nonFungibleContract.transferFrom(owner, bidder, _tokenId);
722 
723         // NFT has been transferred! Now calculate fees and transfer fund to the owner
724         // T - P, the CFO's earnings
725         uint256 cfoEarnings = total - offerPrice;
726         totalCFOEarnings += cfoEarnings;
727 
728         // Transfer money in escrow to owner
729         _tryPushFunds(_tokenId, owner, offerPrice);
730 
731         emit OfferFulfilled(
732             _tokenId,
733             bidder,
734             owner,
735             offerPrice,
736             cfoEarnings
737         );
738     }
739 
740     /// @notice Removes any existing and inactive (expired) offers from storage. In doing so, this contract
741     ///  takes a flat fee from the total amount attached to each offer before sending the remaining funds
742     ///  back to the bidder.
743     /// @notice Nothing will be done if the offer for a token is either non-existent or active.
744     /// @param _tokenIds The array of tokenIds that will be removed from storage
745     function batchRemoveExpired(uint256[] _tokenIds) external whenNotFrozen {
746         uint256 len = _tokenIds.length;
747 
748         // Use temporary accumulator
749         uint256 cumulativeCFOEarnings = 0;
750 
751         for (uint256 i = 0; i < len; i++) {
752             uint256 tokenId = _tokenIds[i];
753             Offer storage offer = tokenIdToOffer[tokenId];
754             uint256 expiresAt = offer.expiresAt;
755 
756             // Skip the offer if not exist
757             if (!_offerExists(expiresAt)) {
758                 continue;
759             }
760             // Skip if the offer has not expired yet
761             if (_isOfferActive(expiresAt)) {
762                 continue;
763             }
764 
765             // Get a reference of the bidder address before removing offer from storage
766             address bidder = offer.bidder;
767 
768             // CFO gets the flat fee
769             uint256 cfoEarnings = uint256(offer.unsuccessfulFee);
770 
771             // Bidder gets refund: T - flat
772             uint256 toRefund = uint256(offer.total) - cfoEarnings;
773 
774             // Ensure the previous offer has been removed before refunding
775             delete tokenIdToOffer[tokenId];
776 
777             // Add to cumulative balance of CFO's earnings
778             cumulativeCFOEarnings += cfoEarnings;
779 
780             // Finally, sending funds to this bidder. If failed, the fund will be kept in escrow
781             // under lostAndFound's address
782             _tryPushFunds(
783                 tokenId,
784                 bidder,
785                 toRefund
786             );
787 
788             emit ExpiredOfferRemoved(
789                 tokenId,
790                 bidder,
791                 toRefund,
792                 cfoEarnings
793             );
794         }
795 
796         // Add to CFO's balance if any expired offer has been removed
797         if (cumulativeCFOEarnings > 0) {
798             totalCFOEarnings += cumulativeCFOEarnings;
799         }
800     }
801 
802     /// @notice Updates an existing and active offer by setting a new expiration time and, optionally, raise
803     ///  the price of the offer.
804     /// @notice As the offers are always using the configuration values currently in storage, the updated
805     ///  offer may be adhering to configuration values that are different at the time of its original creation.
806     /// @dev We check msg.value to determine if the offer price should be raised. If 0, only a new
807     ///  expiration time is set.
808     /// @param _tokenId The token specified by the offer that will be updated.
809     function updateOffer(uint256 _tokenId) external payable whenNotFrozen {
810         // Check that offer exists and is active currently
811         Offer storage offer = tokenIdToOffer[_tokenId];
812         uint256 expiresAt = uint256(offer.expiresAt);
813         require(_offerExists(expiresAt), "offer to update must exist");
814         require(_isOfferActive(expiresAt), "offer to update must not be expired");
815 
816         require(msg.sender == offer.bidder, "caller must be bidder of offer to be updated");
817 
818         uint256 newExpiresAt = now + globalDuration;
819 
820         // Check if the caller wants to raise the offer as well
821         if (msg.value > 0) {
822             // Set the new price
823             offer.total += uint128(msg.value);
824         }
825 
826         offer.expiresAt = uint64(newExpiresAt);
827 
828         emit OfferUpdated(_tokenId, msg.sender, newExpiresAt, msg.value);
829 
830     }
831 
832     /// @notice Sends funds of each existing offer held in escrow back to bidders. The function is callable
833     ///  by anyone.
834     /// @notice Works only when contract is frozen. In this case, we want to allow all funds to be returned
835     ///  without taking any fees.
836     /// @param _tokenId The token specified by the offer a bidder wants to withdraw funds for.
837     function bidderWithdrawFunds(uint256 _tokenId) external whenFrozen {
838         // Check that offer exists
839         Offer storage offer = tokenIdToOffer[_tokenId];
840         require(_offerExists(offer.expiresAt), "offer to withdraw funds from must exist");
841         require(msg.sender == offer.bidder, "only bidders can withdraw their funds in escrow");
842 
843         // Get a reference of the total to withdraw before removing offer from storage
844         uint256 total = uint256(offer.total);
845 
846         delete tokenIdToOffer[_tokenId];
847 
848         // Send funds back to bidders!
849         msg.sender.transfer(total);
850 
851         emit BidderWithdrewFundsWhenFrozen(_tokenId, msg.sender, total);
852     }
853 
854     /// @notice we don't accept any value transfer.
855     function() external payable {
856         revert("we don't accept any payments!");
857     }
858 }