1 pragma solidity ^0.4.24;
2 
3 /// @title Contract that manages addresses and access modifiers for certain operations.
4 /// @author Dapper Labs Inc. (https://www.dapperlabs.com)
5 contract OffersAccessControl {
6 
7     // The address of the account that can replace ceo, coo, cfo, lostAndFound
8     address public ceoAddress;
9     // The address of the account that can adjust configuration variables and fulfill offer
10     address public cooAddress;
11     // The address of the CFO account that receives all the fees
12     address public cfoAddress;
13     // The address where funds of failed "push"es go to
14     address public lostAndFoundAddress;
15 
16     // The total amount of ether (in wei) in escrow owned by CFO
17     uint256 public totalCFOEarnings;
18     // The total amount of ether (in wei) in escrow owned by lostAndFound
19     uint256 public totalLostAndFoundBalance;
20 
21     /// @notice Keeps track whether the contract is frozen.
22     ///  When frozen is set to be true, it cannot be set back to false again,
23     ///  and all whenNotFrozen actions will be blocked.
24     bool public frozen = false;
25 
26     /// @notice Access modifier for CEO-only functionality
27     modifier onlyCEO() {
28         require(msg.sender == ceoAddress, "only CEO is allowed to perform this operation");
29         _;
30     }
31 
32     /// @notice Access modifier for COO-only functionality
33     modifier onlyCOO() {
34         require(msg.sender == cooAddress, "only COO is allowed to perform this operation");
35         _;
36     }
37 
38     /// @notice Access modifier for CFO-only functionality
39     modifier onlyCFO() {
40         require(
41             msg.sender == cfoAddress &&
42             msg.sender != address(0),
43             "only CFO is allowed to perform this operation"
44         );
45         _;
46     }
47 
48     /// @notice Access modifier for CEO-only or CFO-only functionality
49     modifier onlyCeoOrCfo() {
50         require(
51             msg.sender != address(0) &&
52             (
53                 msg.sender == ceoAddress ||
54                 msg.sender == cfoAddress
55             ),
56             "only CEO or CFO is allowed to perform this operation"
57         );
58         _;
59     }
60 
61     /// @notice Access modifier for LostAndFound-only functionality
62     modifier onlyLostAndFound() {
63         require(
64             msg.sender == lostAndFoundAddress &&
65             msg.sender != address(0),
66             "only LostAndFound is allowed to perform this operation"
67         );
68         _;
69     }
70 
71     /// @notice Assigns a new address to act as the CEO. Only available to the current CEO.
72     /// @param _newCEO The address of the new CEO
73     function setCEO(address _newCEO) external onlyCEO {
74         require(_newCEO != address(0), "new CEO address cannot be the zero-account");
75         ceoAddress = _newCEO;
76     }
77 
78     /// @notice Assigns a new address to act as the COO. Only available to the current CEO.
79     /// @param _newCOO The address of the new COO
80     function setCOO(address _newCOO) public onlyCEO {
81         require(_newCOO != address(0), "new COO address cannot be the zero-account");
82         cooAddress = _newCOO;
83     }
84 
85     /// @notice Assigns a new address to act as the CFO. Only available to the current CEO.
86     /// @param _newCFO The address of the new CFO
87     function setCFO(address _newCFO) external onlyCEO {
88         require(_newCFO != address(0), "new CFO address cannot be the zero-account");
89         cfoAddress = _newCFO;
90     }
91 
92     /// @notice Assigns a new address to act as the LostAndFound account. Only available to the current CEO.
93     /// @param _newLostAndFound The address of the new lostAndFound address
94     function setLostAndFound(address _newLostAndFound) external onlyCEO {
95         require(_newLostAndFound != address(0), "new lost and found cannot be the zero-account");
96         lostAndFoundAddress = _newLostAndFound;
97     }
98 
99     /// @notice CFO withdraws the CFO earnings
100     function withdrawTotalCFOEarnings() external onlyCFO {
101         // Obtain reference
102         uint256 balance = totalCFOEarnings;
103         totalCFOEarnings = 0;
104         cfoAddress.transfer(balance);
105     }
106 
107     /// @notice LostAndFound account withdraws all the lost and found amount
108     function withdrawTotalLostAndFoundBalance() external onlyLostAndFound {
109         // Obtain reference
110         uint256 balance = totalLostAndFoundBalance;
111         totalLostAndFoundBalance = 0;
112         lostAndFoundAddress.transfer(balance);
113     }
114 
115     /// @notice Modifier to allow actions only when the contract is not frozen
116     modifier whenNotFrozen() {
117         require(!frozen, "contract needs to not be frozen");
118         _;
119     }
120 
121     /// @notice Modifier to allow actions only when the contract is frozen
122     modifier whenFrozen() {
123         require(frozen, "contract needs to be frozen");
124         _;
125     }
126 
127     /// @notice Called by CEO or CFO role to freeze the contract.
128     ///  Only intended to be used if a serious exploit is detected.
129     /// @notice Allow two C-level roles to call this function in case either CEO or CFO key is compromised.
130     /// @notice This is a one-way process; there is no un-freezing.
131     /// @dev A frozen contract will be frozen forever, there's no way to undo this action.
132     function freeze() external onlyCeoOrCfo whenNotFrozen {
133         frozen = true;
134     }
135 
136 }
137 
138 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
139 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
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
163 /// @title Contract that manages configuration values and fee structure for offers.
164 /// @author Dapper Labs Inc. (https://www.dapperlabs.com)
165 contract OffersConfig is OffersAccessControl {
166 
167     /* ************************* */
168     /* ADJUSTABLE CONFIGURATIONS */
169     /* ************************* */
170 
171     // The duration (in seconds) of all offers that are created. This parameter is also used in calculating
172     // new expiration times when extending offers.
173     uint256 public globalDuration;
174     // The global minimum offer value (price + offer fee, in wei)
175     uint256 public minimumTotalValue;
176     // The minimum overbid increment % (expressed in basis points, which is 1/100 of a percent)
177     // For basis points, values 0-10,000 map to 0%-100%
178     uint256 public minimumPriceIncrement;
179 
180     /* *************** */
181     /* ADJUSTABLE FEES */
182     /* *************** */
183 
184     // Throughout the various contracts there will be various symbols used for the purpose of a clear display
185     // of the underlying mathematical formulation. Specifically,
186     //
187     //          - T: This is the total amount of funds associated with an offer, comprised of 1) the offer
188     //                  price which the bidder is proposing the owner of the token receive, and 2) an amount
189     //                  that is the maximum the main Offers contract will ever take - this is when the offer
190     //                  is cancelled, or fulfilled. In other scenarios, the amount taken by the main contract
191     //                  may be less, depending on other configurations.
192     //
193     //          - S: This is called the offerCut, expressed as a basis point. This determines the maximum amount
194     //                  of ether the main contract can ever take in the various possible outcomes of an offer
195     //                  (cancelled, expired, overbid, fulfilled, updated).
196     //
197     //          - P: This simply refers to the price that the bidder is offering the owner receive, upon
198     //                  fulfillment of the offer process.
199     //
200     //          - Below is the formula that ties the symbols listed above together (S is % for brevity):
201     //                  T = P + S * P
202 
203     // Flat fee (in wei) the main contract takes when offer has been expired or overbid. The fee serves as a
204     // disincentive for abuse and allows recoupment of ether spent calling batchRemoveExpired on behalf of users.
205     uint256 public unsuccessfulFee;
206     // This is S, the maximum % the main contract takes on each offer. S represents the total amount paid when
207     // an offer has been fulfilled or cancelled.
208     uint256 public offerCut;
209 
210     /* ****** */
211     /* EVENTS */
212     /* ****** */
213 
214     event GlobalDurationUpdated(uint256 value);
215     event MinimumTotalValueUpdated(uint256 value);
216     event MinimumPriceIncrementUpdated(uint256 value);
217     event OfferCutUpdated(uint256 value);
218     event UnsuccessfulFeeUpdated(uint256 value);
219 
220     /* ********* */
221     /* FUNCTIONS */
222     /* ********* */
223 
224     /// @notice Sets the minimumTotalValue value. This would impact offers created after this has been set, but
225     ///  not existing offers.
226     /// @notice Only callable by COO, when not frozen.
227     /// @param _newMinTotal The minimumTotalValue value to set
228     function setMinimumTotalValue(uint256 _newMinTotal) external onlyCOO whenNotFrozen {
229         _setMinimumTotalValue(_newMinTotal, unsuccessfulFee);
230         emit MinimumTotalValueUpdated(_newMinTotal);
231     }
232 
233     /// @notice Sets the globalDuration value. All offers that are created or updated will compute a new expiration
234     ///  time based on this.
235     /// @notice Only callable by COO, when not frozen.
236     /// @dev Need to check for underflow since function argument is 256 bits, and the offer expiration time is
237     ///  packed into 64 bits in the Offer struct.
238     /// @param _newDuration The globalDuration value to set.
239     function setGlobalDuration(uint256 _newDuration) external onlyCOO whenNotFrozen {
240         require(_newDuration == uint256(uint64(_newDuration)), "new globalDuration value must not underflow");
241         globalDuration = _newDuration;
242         emit GlobalDurationUpdated(_newDuration);
243     }
244 
245     /// @notice Sets the offerCut value. All offers will compute a fee taken by this contract based on this
246     ///  configuration.
247     /// @notice Only callable by COO, when not frozen.
248     /// @dev As this configuration is a basis point, the value to set must be less than or equal to 10000.
249     /// @param _newOfferCut The offerCut value to set.
250     function setOfferCut(uint256 _newOfferCut) external onlyCOO whenNotFrozen {
251         _setOfferCut(_newOfferCut);
252         emit OfferCutUpdated(_newOfferCut);
253     }
254 
255     /// @notice Sets the unsuccessfulFee value. All offers that are unsuccessful (overbid or expired)
256     ///  will have a flat fee taken by the main contract before being refunded to bidders.
257     /// @notice Given Tmin (_minTotal), flat fee (_unsuccessfulFee),
258     ///  Tmin ≥ (2 * flat fee) guarantees that offer prices ≥ flat fee, always. This is important to prevent the
259     ///  existence of offers that, when overbid or expired, would result in the main contract taking too big of a cut.
260     ///  In the case of a sufficiently low offer price, eg. the same as unsuccessfulFee, the most the main contract can
261     ///  ever take is simply the amount of unsuccessfulFee.
262     /// @notice Only callable by COO, when not frozen.
263     /// @param _newUnsuccessfulFee The unsuccessfulFee value to set.
264     function setUnsuccessfulFee(uint256 _newUnsuccessfulFee) external onlyCOO whenNotFrozen {
265         require(minimumTotalValue >= (2 * _newUnsuccessfulFee), "unsuccessful value must be <= half of minimumTotalValue");
266         unsuccessfulFee = _newUnsuccessfulFee;
267         emit UnsuccessfulFeeUpdated(_newUnsuccessfulFee);
268     }
269 
270     /// @notice Sets the minimumPriceIncrement value. All offers that are overbid must have a price greater
271     ///  than the minimum increment computed from this basis point.
272     /// @notice Only callable by COO, when not frozen.
273     /// @dev As this configuration is a basis point, the value to set must be less than or equal to 10000.
274     /// @param _newMinimumPriceIncrement The minimumPriceIncrement value to set.
275     function setMinimumPriceIncrement(uint256 _newMinimumPriceIncrement) external onlyCOO whenNotFrozen {
276         _setMinimumPriceIncrement(_newMinimumPriceIncrement);
277         emit MinimumPriceIncrementUpdated(_newMinimumPriceIncrement);
278     }
279 
280     /// @notice Utility function used internally for the setMinimumTotalValue method.
281     /// @notice Given Tmin (_minTotal), flat fee (_unsuccessfulFee),
282     ///  Tmin ≥ (2 * flat fee) guarantees that offer prices ≥ flat fee, always. This is important to prevent the
283     ///  existence of offers that, when overbid or expired, would result in the main contract taking too big of a cut.
284     ///  In the case of a sufficiently low offer price, eg. the same as unsuccessfulFee, the most the main contract can
285     ///  ever take is simply the amount of unsuccessfulFee.
286     /// @param _newMinTotal The minimumTotalValue value to set.
287     /// @param _unsuccessfulFee The unsuccessfulFee value used to check if the _minTotal specified
288     ///  is too low.
289     function _setMinimumTotalValue(uint256 _newMinTotal, uint256 _unsuccessfulFee) internal {
290         require(_newMinTotal >= (2 * _unsuccessfulFee), "minimum value must be >= 2 * unsuccessful fee");
291         minimumTotalValue = _newMinTotal;
292     }
293 
294     /// @dev As offerCut is a basis point, the value to set must be less than or equal to 10000.
295     /// @param _newOfferCut The offerCut value to set.
296     function _setOfferCut(uint256 _newOfferCut) internal {
297         require(_newOfferCut <= 1e4, "offer cut must be a valid basis point");
298         offerCut = _newOfferCut;
299     }
300 
301     /// @dev As minimumPriceIncrement is a basis point, the value to set must be less than or equal to 10000.
302     /// @param _newMinimumPriceIncrement The minimumPriceIncrement value to set.
303     function _setMinimumPriceIncrement(uint256 _newMinimumPriceIncrement) internal {
304         require(_newMinimumPriceIncrement <= 1e4, "minimum price increment must be a valid basis point");
305         minimumPriceIncrement = _newMinimumPriceIncrement;
306     }
307 }
308 
309 /// @title Base contract for CryptoKitties Offers. Holds all common structs, events, and base variables.
310 /// @author Dapper Labs Inc. (https://www.dapperlabs.com)
311 contract OffersBase is OffersConfig {
312     /*** EVENTS ***/
313 
314     /// @notice The OfferCreated event is emitted when an offer is created through
315     ///  createOffer method.
316     /// @param tokenId The token id that a bidder is offering to buy from the owner.
317     /// @param bidder The creator of the offer.
318     /// @param expiresAt The timestamp when the offer will be expire.
319     /// @param total The total eth value the bidder sent to the Offer contract.
320     /// @param offerPrice The eth price that the owner of the token will receive
321     ///  if the offer is accepted.
322     event OfferCreated(
323         uint256 tokenId,
324         address bidder,
325         uint256 expiresAt,
326         uint256 total,
327         uint256 offerPrice
328     );
329 
330     /// @notice The OfferCancelled event is emitted when an offer is cancelled before expired.
331     /// @param tokenId The token id that the cancelled offer was offering to buy.
332     /// @param bidder The creator of the offer.
333     /// @param bidderReceived The eth amount that the bidder received as refund.
334     /// @param fee The eth amount that CFO received as the fee for the cancellation.
335     event OfferCancelled(
336         uint256 tokenId,
337         address bidder,
338         uint256 bidderReceived,
339         uint256 fee
340     );
341 
342     /// @notice The OfferFulfilled event is emitted when an active offer has been fulfilled, meaning
343     ///  the bidder now owns the token, and the orignal owner receives the eth amount from the offer.
344     /// @param tokenId The token id that the fulfilled offer was offering to buy.
345     /// @param bidder The creator of the offer.
346     /// @param owner The original owner of the token who accepted the offer.
347     /// @param ownerReceived The eth amount that the original owner received from the offer
348     /// @param fee The eth amount that CFO received as the fee for the successfully fulfilling.
349     event OfferFulfilled(
350         uint256 tokenId,
351         address bidder,
352         address owner,
353         uint256 ownerReceived,
354         uint256 fee
355     );
356 
357     /// @notice The OfferUpdated event is emitted when an active offer was either extended the expiry
358     ///  or raised the price.
359     /// @param tokenId The token id that the updated offer was offering to buy.
360     /// @param bidder The creator of the offer, also is whom updated the offer.
361     /// @param newExpiresAt The new expiry date of the updated offer.
362     /// @param totalRaised The total eth value the bidder sent to the Offer contract to raise the offer.
363     ///  if the totalRaised is 0, it means the offer was extended without raising the price.
364     event OfferUpdated(
365         uint256 tokenId,
366         address bidder,
367         uint256 newExpiresAt,
368         uint256 totalRaised
369     );
370 
371     /// @notice The ExpiredOfferRemoved event is emitted when an expired offer gets removed. The eth value will
372     ///  be returned to the bidder's account, excluding the fee.
373     /// @param tokenId The token id that the removed offer was offering to buy
374     /// @param bidder The creator of the offer.
375     /// @param bidderReceived The eth amount that the bidder received from the offer.
376     /// @param fee The eth amount that CFO received as the fee.
377     event ExpiredOfferRemoved(
378       uint256 tokenId,
379       address bidder,
380       uint256 bidderReceived,
381       uint256 fee
382     );
383 
384     /// @notice The BidderWithdrewFundsWhenFrozen event is emitted when a bidder withdrew their eth value of
385     ///  the offer when the contract is frozen.
386     /// @param tokenId The token id that withdrawed offer was offering to buy
387     /// @param bidder The creator of the offer, also is whom withdrawed the fund.
388     /// @param amount The total amount that the bidder received.
389     event BidderWithdrewFundsWhenFrozen(
390         uint256 tokenId,
391         address bidder,
392         uint256 amount
393     );
394 
395 
396     /// @dev The PushFundsFailed event is emitted when the Offer contract fails to send certain amount of eth
397     ///  to an address, e.g. sending the fund back to the bidder when the offer was overbidden by a higher offer.
398     /// @param tokenId The token id of an offer that the sending fund is involved.
399     /// @param to The address that is supposed to receive the fund but failed for any reason.
400     /// @param amount The eth amount that the receiver fails to receive.
401     event PushFundsFailed(
402         uint256 tokenId,
403         address to,
404         uint256 amount
405     );
406 
407     /*** DATA TYPES ***/
408 
409     /// @dev The Offer struct. The struct fits in two 256-bits words.
410     struct Offer {
411         // Time when offer expires
412         uint64 expiresAt;
413         // Bidder The creator of the offer
414         address bidder;
415         // Offer cut in basis points, which ranges from 0-10000.
416         // It's the cut that CFO takes when the offer is successfully accepted by the owner.
417         // This is stored in the offer struct so that it won't be changed if COO updates
418         // the `offerCut` for new offers.
419         uint16 offerCut;
420         // Total value (in wei) a bidder sent in msg.value to create the offer
421         uint128 total;
422         // Fee (in wei) that CFO takes when the offer is expired or overbid.
423         // This is stored in the offer struct so that it won't be changed if COO updates
424         // the `unsuccessfulFee` for new offers.
425         uint128 unsuccessfulFee;
426     }
427 
428     /*** STORAGE ***/
429     /// @notice Mapping from token id to its corresponding offer.
430     /// @dev One token can only have one offer.
431     ///  Making it public so that solc-0.4.24 will generate code to query offer by a given token id.
432     mapping (uint256 => Offer) public tokenIdToOffer;
433 
434     /// @notice computes the minimum offer price to overbid a given offer with its offer price.
435     ///  The new offer price has to be a certain percentage, which defined by `minimumPriceIncrement`,
436     ///  higher than the previous offer price.
437     /// @dev This won't overflow, because `_offerPrice` is in uint128, and `minimumPriceIncrement`
438     ///  is 16 bits max.
439     /// @param _offerPrice The amount of ether in wei as the offer price
440     /// @return The minimum amount of ether in wei to overbid the given offer price
441     function _computeMinimumOverbidPrice(uint256 _offerPrice) internal view returns (uint256) {
442         return _offerPrice * (1e4 + minimumPriceIncrement) / 1e4;
443     }
444 
445     /// @notice Computes the offer price that the owner will receive if the offer is accepted.
446     /// @dev This is safe against overflow because msg.value and the total supply of ether is capped within 128 bits.
447     /// @param _total The total value of the offer. Also is the msg.value that the bidder sent when
448     ///  creating the offer.
449     /// @param _offerCut The percentage in basis points that will be taken by the CFO if the offer is fulfilled.
450     /// @return The offer price that the owner will receive if the offer is fulfilled.
451     function _computeOfferPrice(uint256 _total, uint256 _offerCut) internal pure returns (uint256) {
452         return _total * 1e4 / (1e4 + _offerCut);
453     }
454 
455     /// @notice Check if an offer exists or not by checking the expiresAt field of the offer.
456     ///  True if exists, False if not.
457     /// @dev Assuming the expiresAt field is from the offer struct in storage.
458     /// @dev Since expiry check always come right after the offer existance check, it will save some gas by checking
459     /// both existance and expiry on one field, as it only reads from the storage once.
460     /// @param _expiresAt The time at which the offer we want to validate expires.
461     /// @return True or false (if the offer exists not).
462     function _offerExists(uint256 _expiresAt) internal pure returns (bool) {
463         return _expiresAt > 0;
464     }
465 
466     /// @notice Check if an offer is still active by checking the expiresAt field of the offer. True if the offer is,
467     ///  still active, False if the offer has expired,
468     /// @dev Assuming the expiresAt field is from the offer struct in storage.
469     /// @param _expiresAt The time at which the offer we want to validate expires.
470     /// @return True or false (if the offer has expired or not).
471     function _isOfferActive(uint256 _expiresAt) internal view returns (bool) {
472         return now < _expiresAt;
473     }
474 
475     /// @dev Try pushing the fund to an address.
476     /// @notice If sending the fund to the `_to` address fails for whatever reason, then the logic
477     ///  will continue and the amount will be kept under the LostAndFound account. Also an event `PushFundsFailed`
478     ///  will be emitted for notifying the failure.
479     /// @param _tokenId The token id for the offer.
480     /// @param _to The address the main contract is attempting to send funds to.
481     /// @param _amount The amount of funds (in wei) the main contract is attempting to send.
482     function _tryPushFunds(uint256 _tokenId, address _to, uint256 _amount) internal {
483         // Sending the amount of eth in wei, and handling the failure.
484         // The gas spent transferring funds has a set upper limit
485         bool success = _to.send(_amount);
486         if (!success) {
487             // If failed sending to the `_to` address, then keep the amount under the LostAndFound account by
488             // accumulating totalLostAndFoundBalance.
489             totalLostAndFoundBalance = totalLostAndFoundBalance + _amount;
490 
491             // Emitting the event lost amount.
492             emit PushFundsFailed(_tokenId, _to, _amount);
493         }
494     }
495 }
496 
497 /// @title Contract that manages funds from creation to fulfillment for offers made on any ERC-721 token.
498 /// @author Dapper Labs Inc. (https://www.dapperlabs.com)
499 /// @notice This generic contract interfaces with any ERC-721 compliant contract
500 contract Offers is OffersBase {
501 
502     // This is the main Offers contract. In order to keep our code separated into logical sections,
503     // we've broken it up into multiple files using inheritance. This allows us to keep related code
504     // collocated while still avoiding a single large file, which would be harder to maintain. The breakdown
505     // is as follows:
506     //
507     //      - OffersBase: This contract defines the fundamental code that the main contract uses.
508     //              This includes our main data storage, data types, events, and internal functions for
509     //              managing offers in their lifecycle.
510     //
511     //      - OffersConfig: This contract manages the various configuration values that determine the
512     //              details of the offers that get created, cancelled, overbid, expired, and fulfilled,
513     //              as well as the fee structure that the offers will be operating with.
514     //
515     //      - OffersAccessControl: This contract manages the various addresses and constraints for
516     //              operations that can be executed only by specific roles. The roles are: CEO, CFO,
517     //              COO, and LostAndFound. Additionally, this contract exposes functions for the CFO
518     //              to withdraw earnings and the LostAndFound account to withdraw any lost funds.
519 
520     /// @dev The ERC-165 interface signature for ERC-721.
521     ///  Ref: https://github.com/ethereum/EIPs/issues/165
522     ///  Ref: https://github.com/ethereum/EIPs/issues/721
523     bytes4 constant InterfaceSignature_ERC721 = bytes4(0x9a20483d);
524 
525     // Reference to contract tracking NFT ownership
526     ERC721 public nonFungibleContract;
527 
528     /// @notice Creates the main Offers smart contract instance and sets initial configuration values
529     /// @param _nftAddress The address of the ERC-721 contract managing NFT ownership
530     /// @param _cooAddress The address of the COO to set
531     /// @param _globalDuration The initial globalDuration value to set
532     /// @param _minimumTotalValue The initial minimumTotalValue value to set
533     /// @param _minimumPriceIncrement The initial minimumPriceIncrement value to set
534     /// @param _unsuccessfulFee The initial unsuccessfulFee value to set
535     /// @param _offerCut The initial offerCut value to set
536     constructor(
537       address _nftAddress,
538       address _cooAddress,
539       uint256 _globalDuration,
540       uint256 _minimumTotalValue,
541       uint256 _minimumPriceIncrement,
542       uint256 _unsuccessfulFee,
543       uint256 _offerCut
544     ) public {
545         // The creator of the contract is the ceo
546         ceoAddress = msg.sender;
547 
548         // Get reference of the address of the NFT contract
549         ERC721 candidateContract = ERC721(_nftAddress);
550         require(candidateContract.supportsInterface(InterfaceSignature_ERC721), "NFT Contract needs to support ERC721 Interface");
551         nonFungibleContract = candidateContract;
552 
553         setCOO(_cooAddress);
554 
555         // Set initial claw-figuration values
556         globalDuration = _globalDuration;
557         unsuccessfulFee = _unsuccessfulFee;
558         _setOfferCut(_offerCut);
559         _setMinimumPriceIncrement(_minimumPriceIncrement);
560         _setMinimumTotalValue(_minimumTotalValue, _unsuccessfulFee);
561     }
562 
563     /// @notice Creates an offer on a token. This contract receives bidders funds and refunds the previous bidder
564     ///  if this offer overbids a previously active (unexpired) offer.
565     /// @notice When this offer overbids a previously active offer, this offer must have a price greater than
566     ///  a certain percentage of the previous offer price, which the minimumOverbidPrice basis point specifies.
567     ///  A flat fee is also taken from the previous offer before refund the previous bidder.
568     /// @notice When there is a previous offer that has already expired but not yet been removed from storage,
569     ///  the new offer can be created with any total value as long as it is greater than the minimumTotalValue.
570     /// @notice Works only when contract is not frozen.
571     /// @param _tokenId The token a bidder wants to create an offer for.
572     function createOffer(uint256 _tokenId) external payable whenNotFrozen {
573         // T = msg.value
574         // Check that the total amount of the offer isn't below the meow-nimum
575         require(msg.value >= minimumTotalValue, "offer total value must be above minimumTotalValue");
576 
577         uint256 _offerCut = offerCut;
578 
579         // P, the price that owner will see and receive if the offer is accepted.
580         uint256 offerPrice = _computeOfferPrice(msg.value, _offerCut);
581 
582         Offer storage previousOffer = tokenIdToOffer[_tokenId];
583         uint256 previousExpiresAt = previousOffer.expiresAt;
584 
585         uint256 toRefund = 0;
586 
587         // Check if tokenId already has an offer
588         if (_offerExists(previousExpiresAt)) {
589             uint256 previousOfferTotal = uint256(previousOffer.total);
590 
591             // If the previous offer is still active, the new offer needs to match the previous offer's price
592             // plus a minimum required increment (minimumOverbidPrice).
593             // We calculate the previous offer's price, the corresponding minimumOverbidPrice, and check if the
594             // new offerPrice is greater than or equal to the minimumOverbidPrice
595             // The owner is fur-tunate to have such a desirable kitty
596             if (_isOfferActive(previousExpiresAt)) {
597                 uint256 previousPriceForOwner = _computeOfferPrice(previousOfferTotal, uint256(previousOffer.offerCut));
598                 uint256 minimumOverbidPrice = _computeMinimumOverbidPrice(previousPriceForOwner);
599                 require(offerPrice >= minimumOverbidPrice, "overbid price must match minimum price increment criteria");
600             }
601 
602             uint256 cfoEarnings = previousOffer.unsuccessfulFee;
603             // Bidder gets refund: T - flat fee
604             // The in-fur-ior offer gets refunded for free, how nice.
605             toRefund = previousOfferTotal - cfoEarnings;
606 
607             totalCFOEarnings += cfoEarnings;
608         }
609 
610         uint256 newExpiresAt = now + globalDuration;
611 
612         // Get a reference of previous bidder address before overwriting with new offer.
613         // This is only needed if there is refund
614         address previousBidder;
615         if (toRefund > 0) {
616             previousBidder = previousOffer.bidder;
617         }
618 
619         tokenIdToOffer[_tokenId] = Offer(
620             uint64(newExpiresAt),
621             msg.sender,
622             uint16(_offerCut),
623             uint128(msg.value),
624             uint128(unsuccessfulFee)
625         );
626 
627         // Postpone the refund until the previous offer has been overwritten by the new offer.
628         if (toRefund > 0) {
629             // Finally, sending funds to this bidder. If failed, the fund will be kept in escrow
630             // under lostAndFound's address
631             _tryPushFunds(
632                 _tokenId,
633                 previousBidder,
634                 toRefund
635             );
636         }
637 
638         emit OfferCreated(
639             _tokenId,
640             msg.sender,
641             newExpiresAt,
642             msg.value,
643             offerPrice
644         );
645     }
646 
647     /// @notice Cancels an offer that must exist and be active currently. This moves funds from this contract
648     ///  back to the the bidder, after a cut has been taken.
649     /// @notice Works only when contract is not frozen.
650     /// @param _tokenId The token specified by the offer a bidder wants to cancel
651     function cancelOffer(uint256 _tokenId) external whenNotFrozen {
652         // Check that offer exists and is active currently
653         Offer storage offer = tokenIdToOffer[_tokenId];
654         uint256 expiresAt = offer.expiresAt;
655         require(_offerExists(expiresAt), "offer to cancel must exist");
656         require(_isOfferActive(expiresAt), "offer to cancel must not be expired");
657 
658         address bidder = offer.bidder;
659         require(msg.sender == bidder, "caller must be bidder of offer to be cancelled");
660 
661         // T
662         uint256 total = uint256(offer.total);
663         // P = T - S; Bidder gets all of P, CFO gets all of T - P
664         uint256 toRefund = _computeOfferPrice(total, offer.offerCut);
665         uint256 cfoEarnings = total - toRefund;
666 
667         // Remove offer from storage
668         delete tokenIdToOffer[_tokenId];
669 
670         // Add to CFO's balance
671         totalCFOEarnings += cfoEarnings;
672 
673         // Transfer money in escrow back to bidder
674         _tryPushFunds(_tokenId, bidder, toRefund);
675 
676         emit OfferCancelled(
677             _tokenId,
678             bidder,
679             toRefund,
680             cfoEarnings
681         );
682     }
683 
684     /// @notice Fulfills an offer that must exist and be active currently. This moves the funds of the
685     ///  offer held in escrow in this contract to the owner of the token, and atomically transfers the
686     ///  token from the owner to the bidder. A cut is taken by this contract.
687     /// @notice We also acknowledge the paw-sible difficulties of keeping in-sync with the Ethereum
688     ///  blockchain, and have allowed for fulfilling offers by specifying the _minOfferPrice at which the owner
689     ///  of the token is happy to accept the offer. Thus, the owner will always receive the latest offer
690     ///  price, which can only be at least the _minOfferPrice that was specified. Specifically, this
691     ///  implementation is designed to prevent the edge case where the owner accidentally accepts an offer
692     ///  with a price lower than intended. For example, this can happen when the owner fulfills the offer
693     ///  precisely when the offer expires and is subsequently replaced with a new offer priced lower.
694     /// @notice Works only when contract is not frozen.
695     /// @dev We make sure that the token is not on auction when we fulfill an offer, because the owner of the
696     ///  token would be the auction contract instead of the user. This function requires that this Offers contract
697     ///  is approved for the token in order to make the call to transfer token ownership. This is sufficient
698     ///  because approvals are cleared on transfer (including transfer to the auction).
699     /// @param _tokenId The token specified by the offer that will be fulfilled.
700     /// @param _minOfferPrice The minimum price at which the owner of the token is happy to accept the offer.
701     function fulfillOffer(uint256 _tokenId, uint128 _minOfferPrice) external whenNotFrozen {
702         // Check that offer exists and is active currently
703         Offer storage offer = tokenIdToOffer[_tokenId];
704         uint256 expiresAt = offer.expiresAt;
705         require(_offerExists(expiresAt), "offer to fulfill must exist");
706         require(_isOfferActive(expiresAt), "offer to fulfill must not be expired");
707 
708         // Get the owner of the token
709         address owner = nonFungibleContract.ownerOf(_tokenId);
710 
711         require(msg.sender == cooAddress || msg.sender == owner, "only COO or the owner can fulfill order");
712 
713         // T
714         uint256 total = uint256(offer.total);
715         // P = T - S
716         uint256 offerPrice = _computeOfferPrice(total, offer.offerCut);
717 
718         // Check if the offer price is below the minimum that the owner is happy to accept the offer for
719         require(offerPrice >= _minOfferPrice, "cannot fulfill offer – offer price too low");
720 
721         // Get a reference of the bidder address befur removing offer from storage
722         address bidder = offer.bidder;
723 
724         // Remove offer from storage
725         delete tokenIdToOffer[_tokenId];
726 
727         // Transfer token on behalf of owner to bidder
728         nonFungibleContract.transferFrom(owner, bidder, _tokenId);
729 
730         // NFT has been transferred! Now calculate fees and transfer fund to the owner
731         // T - P, the CFO's earnings
732         uint256 cfoEarnings = total - offerPrice;
733         totalCFOEarnings += cfoEarnings;
734 
735         // Transfer money in escrow to owner
736         _tryPushFunds(_tokenId, owner, offerPrice);
737 
738         emit OfferFulfilled(
739             _tokenId,
740             bidder,
741             owner,
742             offerPrice,
743             cfoEarnings
744         );
745     }
746 
747     /// @notice Removes any existing and inactive (expired) offers from storage. In doing so, this contract
748     ///  takes a flat fee from the total amount attached to each offer before sending the remaining funds
749     ///  back to the bidder.
750     /// @notice Nothing will be done if the offer for a token is either non-existent or active.
751     /// @param _tokenIds The array of tokenIds that will be removed from storage
752     function batchRemoveExpired(uint256[] _tokenIds) external whenNotFrozen {
753         uint256 len = _tokenIds.length;
754 
755         // Use temporary accumulator
756         uint256 cumulativeCFOEarnings = 0;
757 
758         for (uint256 i = 0; i < len; i++) {
759             uint256 tokenId = _tokenIds[i];
760             Offer storage offer = tokenIdToOffer[tokenId];
761             uint256 expiresAt = offer.expiresAt;
762 
763             // Skip the offer if not exist
764             if (!_offerExists(expiresAt)) {
765                 continue;
766             }
767             // Skip if the offer has not expired yet
768             if (_isOfferActive(expiresAt)) {
769                 continue;
770             }
771 
772             // Get a reference of the bidder address before removing offer from storage
773             address bidder = offer.bidder;
774 
775             // CFO gets the flat fee
776             uint256 cfoEarnings = uint256(offer.unsuccessfulFee);
777 
778             // Bidder gets refund: T - flat
779             uint256 toRefund = uint256(offer.total) - cfoEarnings;
780 
781             // Ensure the previous offer has been removed before refunding
782             delete tokenIdToOffer[tokenId];
783 
784             // Add to cumulative balance of CFO's earnings
785             cumulativeCFOEarnings += cfoEarnings;
786 
787             // Finally, sending funds to this bidder. If failed, the fund will be kept in escrow
788             // under lostAndFound's address
789             _tryPushFunds(
790                 tokenId,
791                 bidder,
792                 toRefund
793             );
794 
795             emit ExpiredOfferRemoved(
796                 tokenId,
797                 bidder,
798                 toRefund,
799                 cfoEarnings
800             );
801         }
802 
803         // Add to CFO's balance if any expired offer has been removed
804         if (cumulativeCFOEarnings > 0) {
805             totalCFOEarnings += cumulativeCFOEarnings;
806         }
807     }
808 
809     /// @notice Updates an existing and active offer by setting a new expiration time and, optionally, raise
810     ///  the price of the offer.
811     /// @notice As the offers are always using the configuration values currently in storage, the updated
812     ///  offer may be adhering to configuration values that are different at the time of its original creation.
813     /// @dev We check msg.value to determine if the offer price should be raised. If 0, only a new
814     ///  expiration time is set.
815     /// @param _tokenId The token specified by the offer that will be updated.
816     function updateOffer(uint256 _tokenId) external payable whenNotFrozen {
817         // Check that offer exists and is active currently
818         Offer storage offer = tokenIdToOffer[_tokenId];
819         uint256 expiresAt = uint256(offer.expiresAt);
820         require(_offerExists(expiresAt), "offer to update must exist");
821         require(_isOfferActive(expiresAt), "offer to update must not be expired");
822 
823         require(msg.sender == offer.bidder, "caller must be bidder of offer to be updated");
824 
825         uint256 newExpiresAt = now + globalDuration;
826 
827         // Check if the caller wants to raise the offer as well
828         if (msg.value > 0) {
829             // Set the new price
830             offer.total += uint128(msg.value);
831         }
832 
833         offer.expiresAt = uint64(newExpiresAt);
834 
835         emit OfferUpdated(_tokenId, msg.sender, newExpiresAt, msg.value);
836 
837     }
838 
839     /// @notice Sends funds of each existing offer held in escrow back to bidders. The function is callable
840     ///  by anyone.
841     /// @notice Works only when contract is frozen. In this case, we want to allow all funds to be returned
842     ///  without taking any fees.
843     /// @param _tokenId The token specified by the offer a bidder wants to withdraw funds for.
844     function bidderWithdrawFunds(uint256 _tokenId) external whenFrozen {
845         // Check that offer exists
846         Offer storage offer = tokenIdToOffer[_tokenId];
847         require(_offerExists(offer.expiresAt), "offer to withdraw funds from must exist");
848         require(msg.sender == offer.bidder, "only bidders can withdraw their funds in escrow");
849 
850         // Get a reference of the total to withdraw before removing offer from storage
851         uint256 total = uint256(offer.total);
852 
853         delete tokenIdToOffer[_tokenId];
854 
855         // Send funds back to bidders!
856         msg.sender.transfer(total);
857 
858         emit BidderWithdrewFundsWhenFrozen(_tokenId, msg.sender, total);
859     }
860 
861     /// @notice we don't accept any value transfer.
862     function() external payable {
863         revert("we don't accept any payments!");
864     }
865 }