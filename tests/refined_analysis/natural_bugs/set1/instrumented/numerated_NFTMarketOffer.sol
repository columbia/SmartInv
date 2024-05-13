1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 
3 pragma solidity ^0.8.0;
4 
5 import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
6 import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
7 
8 import "./FoundationTreasuryNode.sol";
9 import "./NFTMarketCore.sol";
10 import "./NFTMarketFees.sol";
11 
12 import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
13 
14 error NFTMarketOffer_Cannot_Be_Accepted_While_In_Auction();
15 /// @param currentOfferAmount The current highest offer available for this NFT.
16 error NFTMarketOffer_Offer_Below_Min_Amount(uint256 currentOfferAmount);
17 /// @param expiry The time at which the offer had expired.
18 error NFTMarketOffer_Offer_Expired(uint256 expiry);
19 /// @param currentOfferFrom The address of the collector which has made the current highest offer.
20 error NFTMarketOffer_Offer_From_Does_Not_Match(address currentOfferFrom);
21 /// @param minOfferAmount The minimum amount that must be offered in order for it to be accepted.
22 error NFTMarketOffer_Offer_Must_Be_At_Least_Min_Amount(uint256 minOfferAmount);
23 error NFTMarketOffer_Reason_Required();
24 
25 /**
26  * @title Allows collectors to make an offer for an NFT, valid for 24-25 hours.
27  * @notice Funds are escrowed in the FETH ERC-20 token contract.
28  */
29 abstract contract NFTMarketOffer is FoundationTreasuryNode, NFTMarketCore, ReentrancyGuardUpgradeable, NFTMarketFees {
30   using AddressUpgradeable for address;
31 
32   /// @notice Stores offer details for a specific NFT.
33   struct Offer {
34     // Slot 1: When increasing an offer, only this slot is updated.
35     /// @notice The expiration timestamp of when this offer expires.
36     uint32 expiration;
37     /// @notice The amount, in wei, of the highest offer.
38     uint96 amount;
39     // 128 bits are available in slot 1
40 
41     // Slot 2: When the buyer changes, both slots need updating
42     /// @notice The address of the collector who made this offer.
43     address buyer;
44   }
45 
46   /// @notice Stores the highest offer for each NFT.
47   mapping(address => mapping(uint256 => Offer)) private nftContractToIdToOffer;
48 
49   /**
50    * @notice Emitted when an offer is accepted,
51    * indicating that the NFT has been transferred and revenue from the sale distributed.
52    * @dev The accepted total offer amount is `f8nFee` + `creatorFee` + `ownerRev`.
53    * @param nftContract The address of the NFT contract.
54    * @param tokenId The id of the NFT.
55    * @param buyer The address of the collector that made the offer which was accepted.
56    * @param seller The address of the seller which accepted the offer.
57    * @param f8nFee The amount of ETH that was sent to Foundation for this sale.
58    * @param creatorFee The amount of ETH that was sent to the creator for this sale.
59    * @param ownerRev The amount of ETH that was sent to the owner for this sale.
60    */
61   event OfferAccepted(
62     address indexed nftContract,
63     uint256 indexed tokenId,
64     address indexed buyer,
65     address seller,
66     uint256 f8nFee,
67     uint256 creatorFee,
68     uint256 ownerRev
69   );
70   /**
71    * @notice Emitted when an offer is canceled by a Foundation admin.
72    * @dev This should only be used for extreme cases such as DMCA takedown requests.
73    * @param nftContract The address of the NFT contract.
74    * @param tokenId The id of the NFT.
75    * @param reason The reason for the cancellation (a required field).
76    */
77   event OfferCanceledByAdmin(address indexed nftContract, uint256 indexed tokenId, string reason);
78   /**
79    * @notice Emitted when an offer is invalidated due to other market activity.
80    * When this occurs, the collector which made the offer has their FETH balance unlocked
81    * and the funds are available to place other offers or to be withdrawn.
82    * @dev This occurs when the offer is no longer eligible to be accepted,
83    * e.g. when a bid is placed in an auction for this NFT.
84    * @param nftContract The address of the NFT contract.
85    * @param tokenId The id of the NFT.
86    */
87   event OfferInvalidated(address indexed nftContract, uint256 indexed tokenId);
88   /**
89    * @notice Emitted when an offer is made.
90    * @dev The `amount` of the offer is locked in the FETH ERC-20 contract, guaranteeing that the funds
91    * remain available until the `expiration` date.
92    * @param nftContract The address of the NFT contract.
93    * @param tokenId The id of the NFT.
94    * @param buyer The address of the collector that made the offer to buy this NFT.
95    * @param amount The amount, in wei, of the offer.
96    * @param expiration The expiration timestamp for the offer.
97    */
98   event OfferMade(
99     address indexed nftContract,
100     uint256 indexed tokenId,
101     address indexed buyer,
102     uint256 amount,
103     uint256 expiration
104   );
105 
106   /**
107    * @notice Accept the highest offer for an NFT.
108    * @dev The offer must not be expired and the NFT owned + approved by the seller or
109    * available in the market contract's escrow.
110    * @param nftContract The address of the NFT contract.
111    * @param tokenId The id of the NFT.
112    * @param offerFrom The address of the collector that you wish to sell to.
113    * If the current highest offer is not from this user, the transaction will revert.
114    * This could happen if a last minute offer was made by another collector,
115    * and would require the seller to try accepting again.
116    * @param minAmount The minimum value of the highest offer for it to be accepted.
117    * If the value is less than this amount, the transaction will revert.
118    * This could happen if the original offer expires and is replaced with a smaller offer.
119    */
120   function acceptOffer(
121     address nftContract,
122     uint256 tokenId,
123     address offerFrom,
124     uint256 minAmount
125   ) external nonReentrant {
126     Offer storage offer = nftContractToIdToOffer[nftContract][tokenId];
127     // Validate offer expiry and amount
128     if (offer.expiration < block.timestamp) {
129       revert NFTMarketOffer_Offer_Expired(offer.expiration);
130     } else if (offer.amount < minAmount) {
131       revert NFTMarketOffer_Offer_Below_Min_Amount(offer.amount);
132     }
133     // Validate the buyer
134     if (offer.buyer != offerFrom) {
135       revert NFTMarketOffer_Offer_From_Does_Not_Match(offer.buyer);
136     }
137 
138     _acceptOffer(nftContract, tokenId);
139   }
140 
141   /**
142    * @notice Allows Foundation to cancel offers.
143    * This will unlock the funds in the FETH ERC-20 contract for the highest offer
144    * and prevent the offer from being accepted.
145    * @dev This should only be used for extreme cases such as DMCA takedown requests.
146    * @param nftContracts The addresses of the NFT contracts to cancel. This must be the same length as `tokenIds`.
147    * @param tokenIds The ids of the NFTs to cancel. This must be the same length as `nftContracts`.
148    * @param reason The reason for the cancellation (a required field).
149    */
150   function adminCancelOffers(
151     address[] calldata nftContracts,
152     uint256[] calldata tokenIds,
153     string calldata reason
154   ) external onlyFoundationAdmin nonReentrant {
155     if (bytes(reason).length == 0) {
156       revert NFTMarketOffer_Reason_Required();
157     }
158 
159     // The array length cannot overflow 256 bits
160     unchecked {
161       for (uint256 i = 0; i < nftContracts.length; ++i) {
162         Offer memory offer = nftContractToIdToOffer[nftContracts[i]][tokenIds[i]];
163         delete nftContractToIdToOffer[nftContracts[i]][tokenIds[i]];
164 
165         if (offer.expiration >= block.timestamp) {
166           // Unlock from escrow and emit an event only if the offer is still active
167           feth.marketUnlockFor(offer.buyer, offer.expiration, offer.amount);
168           emit OfferCanceledByAdmin(nftContracts[i], tokenIds[i], reason);
169         }
170         // Else continue on so the rest of the batch transaction can process successfully
171       }
172     }
173   }
174 
175   /**
176    * @notice Make an offer for any NFT which is valid for 24-25 hours.
177    * The funds will be locked in the FETH token contract and become available once the offer is outbid or has expired.
178    * @dev An offer may be made for an NFT before it is minted, although we generally not recommend you do that.
179    * If there is a buy price set at this price or lower, that will be accepted instead of making an offer.
180    * `msg.value` must be <= `amount` and any delta will be taken from the account's available FETH balance.
181    * @param nftContract The address of the NFT contract.
182    * @param tokenId The id of the NFT.
183    * @param amount The amount to offer for this NFT.
184    * @return expiration The timestamp for when this offer will expire.
185    * This is provided as a return value in case another contract would like to leverage this information,
186    * user's should refer to the expiration in the `OfferMade` event log.
187    * If the buy price is accepted instead, `0` is returned as the expiration since that's n/a.
188    */
189   function makeOffer(
190     address nftContract,
191     uint256 tokenId,
192     uint256 amount
193   ) external payable returns (uint256 expiration) {
194     // If there is a buy price set at this price or lower, accept that instead.
195     if (_autoAcceptBuyPrice(nftContract, tokenId, amount)) {
196       // If the buy price is accepted, `0` is returned as the expiration since that's n/a.
197       return 0;
198     }
199 
200     if (_isInActiveAuction(nftContract, tokenId)) {
201       revert NFTMarketOffer_Cannot_Be_Accepted_While_In_Auction();
202     }
203 
204     Offer storage offer = nftContractToIdToOffer[nftContract][tokenId];
205 
206     if (offer.expiration < block.timestamp) {
207       // This is a new offer for the NFT (no other offer found or the previous offer expired)
208 
209       // Lock the offer amount in FETH until the offer expires in 24-25 hours.
210       expiration = feth.marketLockupFor{ value: msg.value }(msg.sender, amount);
211     } else {
212       // A previous offer exists and has not expired
213 
214       if (amount < _getMinIncrement(offer.amount)) {
215         // A non-trivial increase in price is required to avoid sniping
216         revert NFTMarketOffer_Offer_Must_Be_At_Least_Min_Amount(_getMinIncrement(offer.amount));
217       }
218 
219       // Unlock the previous offer so that the FETH tokens are available for other offers or to transfer / withdraw
220       // and lock the new offer amount in FETH until the offer expires in 24-25 hours.
221       expiration = feth.marketChangeLockup{ value: msg.value }(
222         offer.buyer,
223         offer.expiration,
224         offer.amount,
225         msg.sender,
226         amount
227       );
228     }
229 
230     // Record offer details
231     offer.buyer = msg.sender;
232     // The FETH contract guarantees that the expiration fits into 32 bits.
233     offer.expiration = uint32(expiration);
234     // `amount` is capped by the ETH provided, which cannot realistically overflow 96 bits.
235     offer.amount = uint96(amount);
236 
237     emit OfferMade(nftContract, tokenId, msg.sender, amount, expiration);
238   }
239 
240   /**
241    * @notice Accept the highest offer for an NFT from the `msg.sender` account.
242    * The NFT will be transferred to the buyer and revenue from the sale will be distributed.
243    * @dev The caller must validate the expiry and amount before calling this helper.
244    * This may invalidate other market tools, such as clearing the buy price if set.
245    */
246   function _acceptOffer(address nftContract, uint256 tokenId) private {
247     Offer memory offer = nftContractToIdToOffer[nftContract][tokenId];
248 
249     // Remove offer
250     delete nftContractToIdToOffer[nftContract][tokenId];
251     // Withdraw ETH from the buyer's account in the FETH token contract.
252     feth.marketWithdrawLocked(offer.buyer, offer.expiration, offer.amount);
253 
254     // Distribute revenue for this sale leveraging the ETH received from the FETH contract in the line above.
255     (uint256 f8nFee, uint256 creatorFee, uint256 ownerRev) = _distributeFunds(
256       nftContract,
257       tokenId,
258       payable(msg.sender),
259       offer.amount
260     );
261 
262     // Transfer the NFT to the buyer.
263     try
264       IERC721(nftContract).transferFrom(msg.sender, offer.buyer, tokenId) // solhint-disable-next-line no-empty-blocks
265     {
266       // NFT was in the seller's wallet so the transfer is complete.
267     } catch {
268       // If the transfer fails then attempt to transfer from escrow instead.
269       // This should revert if the NFT is not in escrow of the `msg.sender` is not the owner of this NFT.
270       _transferFromEscrow(nftContract, tokenId, offer.buyer, msg.sender);
271     }
272 
273     emit OfferAccepted(nftContract, tokenId, offer.buyer, msg.sender, f8nFee, creatorFee, ownerRev);
274   }
275 
276   /**
277    * @inheritdoc NFTMarketCore
278    * @dev Invalidates the highest offer when an auction is kicked off, if one is found.
279    */
280   function _afterAuctionStarted(address nftContract, uint256 tokenId) internal virtual override {
281     _invalidateOffer(nftContract, tokenId);
282     super._afterAuctionStarted(nftContract, tokenId);
283   }
284 
285   /**
286    * @inheritdoc NFTMarketCore
287    * @dev Invalidates the highest offer if it's from the same user that purchased the NFT
288    * using a different market tool such as accepting the buy price.
289    */
290   function _transferFromEscrow(
291     address nftContract,
292     uint256 tokenId,
293     address buyer,
294     address seller
295   ) internal virtual override {
296     Offer storage offer = nftContractToIdToOffer[nftContract][tokenId];
297     if (offer.buyer == buyer) {
298       // The highest offer is from the same user that purchased the NFT using a different market tool.
299       _invalidateOffer(nftContract, tokenId);
300     }
301     // For other users, the offer remains valid for consideration by the new owner.
302     super._transferFromEscrow(nftContract, tokenId, buyer, seller);
303   }
304 
305   /**
306    * @inheritdoc NFTMarketCore
307    */
308   function _autoAcceptOffer(
309     address nftContract,
310     uint256 tokenId,
311     uint256 minAmount
312   ) internal override returns (bool) {
313     Offer storage offer = nftContractToIdToOffer[nftContract][tokenId];
314     if (offer.expiration < block.timestamp || offer.amount < minAmount) {
315       // No offer found, the most recent offer is now expired, or the highest offer is below the minimum amount.
316       return false;
317     }
318 
319     _acceptOffer(nftContract, tokenId);
320     return true;
321   }
322 
323   /**
324    * @inheritdoc NFTMarketCore
325    */
326   function _cancelBuyersOffer(address nftContract, uint256 tokenId) internal override {
327     Offer storage offer = nftContractToIdToOffer[nftContract][tokenId];
328     if (offer.buyer == msg.sender) {
329       _invalidateOffer(nftContract, tokenId);
330     }
331   }
332 
333   /**
334    * @notice Invalidates the offer and frees ETH from escrow, if the offer has not already expired.
335    */
336   function _invalidateOffer(address nftContract, uint256 tokenId) private {
337     if (nftContractToIdToOffer[nftContract][tokenId].expiration >= block.timestamp) {
338       // An offer was found and it has not already expired
339       Offer memory offer = nftContractToIdToOffer[nftContract][tokenId];
340 
341       // Remove offer
342       delete nftContractToIdToOffer[nftContract][tokenId];
343       // Unlock the offer so that the FETH tokens are available for other offers or to transfer / withdraw
344       feth.marketUnlockFor(offer.buyer, offer.expiration, offer.amount);
345 
346       emit OfferInvalidated(nftContract, tokenId);
347     }
348   }
349 
350   /**
351    * @notice Returns the minimum amount a collector must offer for this NFT in order for the offer to be valid.
352    * @dev Offers for this NFT which are less than this value will revert.
353    * Once the previous offer has expired smaller offers can be made.
354    * @param nftContract The address of the NFT contract.
355    * @param tokenId The id of the NFT.
356    * @return minimum The minimum amount that must be offered for this NFT.
357    */
358   function getMinOfferAmount(address nftContract, uint256 tokenId) external view returns (uint256 minimum) {
359     Offer storage offer = nftContractToIdToOffer[nftContract][tokenId];
360     if (offer.expiration >= block.timestamp) {
361       return _getMinIncrement(offer.amount);
362     }
363     // Absolute min is anything > 0
364     return 1;
365   }
366 
367   /**
368    * @notice Returns details about the current highest offer for an NFT.
369    * @dev Default values are returned if there is no offer or the offer has expired.
370    * @param nftContract The address of the NFT contract.
371    * @param tokenId The id of the NFT.
372    * @return buyer The address of the buyer that made the current highest offer.
373    * Returns `address(0)` if there is no offer or the most recent offer has expired.
374    * @return expiration The timestamp that the current highest offer expires.
375    * Returns `0` if there is no offer or the most recent offer has expired.
376    * @return amount The amount being offered for this NFT.
377    * Returns `0` if there is no offer or the most recent offer has expired.
378    */
379   function getOffer(address nftContract, uint256 tokenId)
380     external
381     view
382     returns (
383       address buyer,
384       uint256 expiration,
385       uint256 amount
386     )
387   {
388     Offer storage offer = nftContractToIdToOffer[nftContract][tokenId];
389     if (offer.expiration < block.timestamp) {
390       // Offer not found or has expired
391       return (address(0), 0, 0);
392     }
393 
394     // An offer was found and it has not yet expired.
395     return (offer.buyer, offer.expiration, offer.amount);
396   }
397 
398   /**
399    * @notice This empty reserved space is put in place to allow future versions to add new
400    * variables without shifting down storage in the inheritance chain.
401    * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
402    */
403   uint256[1000] private __gap;
404 }
