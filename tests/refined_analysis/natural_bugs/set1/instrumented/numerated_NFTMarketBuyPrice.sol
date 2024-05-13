1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 
3 pragma solidity ^0.8.0;
4 
5 import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
6 import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
7 
8 import "./Constants.sol";
9 import "./NFTMarketCore.sol";
10 import "./NFTMarketFees.sol";
11 
12 import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
13 
14 /// @param buyPrice The current buy price set for this NFT.
15 error NFTMarketBuyPrice_Cannot_Buy_At_Lower_Price(uint256 buyPrice);
16 error NFTMarketBuyPrice_Cannot_Buy_Unset_Price();
17 error NFTMarketBuyPrice_Cannot_Cancel_Unset_Price();
18 /// @param owner The current owner of this NFT.
19 error NFTMarketBuyPrice_Only_Owner_Can_Cancel_Price(address owner);
20 /// @param owner The current owner of this NFT.
21 error NFTMarketBuyPrice_Only_Owner_Can_Set_Price(address owner);
22 error NFTMarketBuyPrice_Price_Too_High();
23 /// @param seller The current owner of this NFT.
24 error NFTMarketBuyPrice_Seller_Mismatch(address seller);
25 
26 /**
27  * @title Allows sellers to set a buy price of their NFTs that may be accepted and instantly transferred to the buyer.
28  * @notice NFTs with a buy price set are escrowed in the market contract.
29  */
30 abstract contract NFTMarketBuyPrice is NFTMarketCore, NFTMarketFees {
31   using AddressUpgradeable for address payable;
32 
33   /// @notice Stores the buy price details for a specific NFT.
34   /// @dev The struct is packed into a single slot to optimize gas.
35   struct BuyPrice {
36     /// @notice The current owner of this NFT which set a buy price.
37     /// @dev A zero price is acceptable so a non-zero address determines whether a price has been set.
38     address payable seller;
39     /// @notice The current buy price set for this NFT.
40     uint96 price;
41   }
42 
43   /// @notice Stores the current buy price for each NFT.
44   mapping(address => mapping(uint256 => BuyPrice)) private nftContractToTokenIdToBuyPrice;
45 
46   /**
47    * @notice Emitted when an NFT is bought by accepting the buy price,
48    * indicating that the NFT has been transferred and revenue from the sale distributed.
49    * @dev The total buy price that was accepted is `f8nFee` + `creatorFee` + `ownerRev`.
50    * @param nftContract The address of the NFT contract.
51    * @param tokenId The id of the NFT.
52    * @param buyer The address of the collector that purchased the NFT using `buy`.
53    * @param seller The address of the seller which originally set the buy price.
54    * @param f8nFee The amount of ETH that was sent to Foundation for this sale.
55    * @param creatorFee The amount of ETH that was sent to the creator for this sale.
56    * @param ownerRev The amount of ETH that was sent to the owner for this sale.
57    */
58   event BuyPriceAccepted(
59     address indexed nftContract,
60     uint256 indexed tokenId,
61     address indexed seller,
62     address buyer,
63     uint256 f8nFee,
64     uint256 creatorFee,
65     uint256 ownerRev
66   );
67   /**
68    * @notice Emitted when the buy price is removed by the owner of an NFT.
69    * @dev The NFT is transferred back to the owner unless it's still escrowed for another market tool,
70    * e.g. listed for sale in an auction.
71    * @param nftContract The address of the NFT contract.
72    * @param tokenId The id of the NFT.
73    */
74   event BuyPriceCanceled(address indexed nftContract, uint256 indexed tokenId);
75   /**
76    * @notice Emitted when a buy price is invalidated due to other market activity.
77    * @dev This occurs when the buy price is no longer eligible to be accepted,
78    * e.g. when a bid is placed in an auction for this NFT.
79    * @param nftContract The address of the NFT contract.
80    * @param tokenId The id of the NFT.
81    */
82   event BuyPriceInvalidated(address indexed nftContract, uint256 indexed tokenId);
83   /**
84    * @notice Emitted when a buy price is set by the owner of an NFT.
85    * @dev The NFT is transferred into the market contract for escrow unless it was already escrowed,
86    * e.g. for auction listing.
87    * @param nftContract The address of the NFT contract.
88    * @param tokenId The id of the NFT.
89    * @param seller The address of the NFT owner which set the buy price.
90    * @param price The price of the NFT.
91    */
92   event BuyPriceSet(address indexed nftContract, uint256 indexed tokenId, address indexed seller, uint256 price);
93 
94   /**
95    * @notice Buy the NFT at the set buy price.
96    * `msg.value` must be <= `maxPrice` and any delta will be taken from the account's available FETH balance.
97    * @dev `maxPrice` protects the buyer in case a the price is increased but allows the transaction to continue
98    * when the price is reduced (and any surplus funds provided are refunded).
99    * @param nftContract The address of the NFT contract.
100    * @param tokenId The id of the NFT.
101    * @param maxPrice The maximum price to pay for the NFT.
102    */
103   function buy(
104     address nftContract,
105     uint256 tokenId,
106     uint256 maxPrice
107   ) external payable {
108     BuyPrice storage buyPrice = nftContractToTokenIdToBuyPrice[nftContract][tokenId];
109     if (buyPrice.price > maxPrice) {
110       revert NFTMarketBuyPrice_Cannot_Buy_At_Lower_Price(buyPrice.price);
111     } else if (buyPrice.seller == address(0)) {
112       revert NFTMarketBuyPrice_Cannot_Buy_Unset_Price();
113     }
114 
115     _buy(nftContract, tokenId);
116   }
117 
118   /**
119    * @notice Removes the buy price set for an NFT.
120    * @dev The NFT is transferred back to the owner unless it's still escrowed for another market tool,
121    * e.g. listed for sale in an auction.
122    * @param nftContract The address of the NFT contract.
123    * @param tokenId The id of the NFT.
124    */
125   function cancelBuyPrice(address nftContract, uint256 tokenId) external nonReentrant {
126     BuyPrice storage buyPrice = nftContractToTokenIdToBuyPrice[nftContract][tokenId];
127     if (buyPrice.seller == address(0)) {
128       // This check is redundant with the next one, but done in order to provide a more clear error message.
129       revert NFTMarketBuyPrice_Cannot_Cancel_Unset_Price();
130     } else if (buyPrice.seller != msg.sender) {
131       revert NFTMarketBuyPrice_Only_Owner_Can_Cancel_Price(buyPrice.seller);
132     }
133 
134     // Remove the buy price
135     delete nftContractToTokenIdToBuyPrice[nftContract][tokenId];
136 
137     // Transfer the NFT back to the owner if it is not listed in auction.
138     _transferFromEscrowIfAvailable(nftContract, tokenId, msg.sender);
139 
140     emit BuyPriceCanceled(nftContract, tokenId);
141   }
142 
143   /**
144    * @notice Sets the buy price for an NFT and escrows it in the market contract.
145    * @dev If there is an offer for this amount or higher, that will be accepted instead of setting a buy price.
146    * @param nftContract The address of the NFT contract.
147    * @param tokenId The id of the NFT.
148    * @param price The price at which someone could buy this NFT.
149    */
150   function setBuyPrice(
151     address nftContract,
152     uint256 tokenId,
153     uint256 price
154   ) external nonReentrant {
155     // If there is a valid offer at this price or higher, accept that instead.
156     if (_autoAcceptOffer(nftContract, tokenId, price)) {
157       return;
158     }
159 
160     if (price > type(uint96).max) {
161       // This ensures that no data is lost when storing the price as `uint96`.
162       revert NFTMarketBuyPrice_Price_Too_High();
163     }
164 
165     BuyPrice storage buyPrice = nftContractToTokenIdToBuyPrice[nftContract][tokenId];
166 
167     // Store the new price for this NFT.
168     buyPrice.price = uint96(price);
169 
170     if (buyPrice.seller == address(0)) {
171       // Transfer the NFT into escrow, if it's already in escrow confirm the `msg.sender` is the owner.
172       _transferToEscrow(nftContract, tokenId);
173 
174       // The price was not previously set for this NFT, store the seller.
175       buyPrice.seller = payable(msg.sender);
176     } else if (buyPrice.seller != msg.sender) {
177       // Buy price was previously set by a different user
178       revert NFTMarketBuyPrice_Only_Owner_Can_Set_Price(buyPrice.seller);
179     }
180 
181     emit BuyPriceSet(nftContract, tokenId, msg.sender, price);
182   }
183 
184   /**
185    * @inheritdoc NFTMarketCore
186    * @dev Invalidates the buy price on a auction start, if one is found.
187    */
188   function _afterAuctionStarted(address nftContract, uint256 tokenId) internal virtual override {
189     BuyPrice storage buyPrice = nftContractToTokenIdToBuyPrice[nftContract][tokenId];
190     if (buyPrice.seller != address(0)) {
191       // A buy price was set for this NFT, invalidate it.
192       _invalidateBuyPrice(nftContract, tokenId);
193     }
194     super._afterAuctionStarted(nftContract, tokenId);
195   }
196 
197   /**
198    * @notice If there is a buy price at this price or lower, accept that and return true.
199    */
200   function _autoAcceptBuyPrice(
201     address nftContract,
202     uint256 tokenId,
203     uint256 maxPrice
204   ) internal override returns (bool) {
205     BuyPrice storage buyPrice = nftContractToTokenIdToBuyPrice[nftContract][tokenId];
206     if (buyPrice.seller == address(0) || buyPrice.price > maxPrice) {
207       // No buy price was found, or the price is too high.
208       return false;
209     }
210 
211     _buy(nftContract, tokenId);
212     return true;
213   }
214 
215   /**
216    * @notice Process the purchase of an NFT at the current buy price.
217    * @dev The caller must confirm that the seller != address(0) before calling this function.
218    */
219   function _buy(address nftContract, uint256 tokenId) private nonReentrant {
220     BuyPrice memory buyPrice = nftContractToTokenIdToBuyPrice[nftContract][tokenId];
221 
222     // Remove the buy now price
223     delete nftContractToTokenIdToBuyPrice[nftContract][tokenId];
224 
225     if (buyPrice.price > msg.value) {
226       // Withdraw additional ETH required from their available FETH balance.
227 
228       // Cancel the buyer's offer if there is one in order to free up their FETH balance.
229       _cancelBuyersOffer(nftContract, tokenId);
230 
231       unchecked {
232         // The if above ensures delta will not underflow.
233         uint256 delta = buyPrice.price - msg.value;
234         // Withdraw ETH from the buyer's account in the FETH token contract,
235         // making the ETH available for `_distributeFunds` below.
236         feth.marketWithdrawFrom(msg.sender, delta);
237       }
238     } else if (buyPrice.price < msg.value) {
239       // Return any surplus funds to the buyer.
240 
241       unchecked {
242         // The if above ensures this will not underflow
243         payable(msg.sender).sendValue(msg.value - buyPrice.price);
244       }
245     }
246 
247     // Transfer the NFT to the buyer.
248     // This should revert if the `msg.sender` is not the owner of this NFT.
249     _transferFromEscrow(nftContract, tokenId, msg.sender, buyPrice.seller);
250 
251     // Distribute revenue for this sale.
252     (uint256 f8nFee, uint256 creatorFee, uint256 ownerRev) = _distributeFunds(
253       address(nftContract),
254       tokenId,
255       buyPrice.seller,
256       buyPrice.price
257     );
258 
259     emit BuyPriceAccepted(nftContract, tokenId, buyPrice.seller, msg.sender, f8nFee, creatorFee, ownerRev);
260   }
261 
262   /**
263    * @notice Clear a buy price and emit BuyPriceInvalidated.
264    * @dev The caller must confirm the buy price is set before calling this function.
265    */
266   function _invalidateBuyPrice(address nftContract, uint256 tokenId) private {
267     delete nftContractToTokenIdToBuyPrice[nftContract][tokenId];
268     emit BuyPriceInvalidated(nftContract, tokenId);
269   }
270 
271   /**
272    * @inheritdoc NFTMarketCore
273    * @dev Invalidates the buy price if one is found before transferring the NFT.
274    * This will revert if there is a buy price set but the `msg.sender` is not the owner.
275    */
276   function _transferFromEscrow(
277     address nftContract,
278     uint256 tokenId,
279     address recipient,
280     address seller
281   ) internal virtual override {
282     BuyPrice storage buyPrice = nftContractToTokenIdToBuyPrice[nftContract][tokenId];
283     if (buyPrice.seller != address(0)) {
284       // A buy price was set for this NFT.
285       if (buyPrice.seller != seller) {
286         // When there is a buy price set, the `buyPrice.seller` is the owner of the NFT.
287         revert NFTMarketBuyPrice_Seller_Mismatch(buyPrice.seller);
288       }
289 
290       // Invalidate the buy price as the NFT will no longer be in escrow.
291       _invalidateBuyPrice(nftContract, tokenId);
292     }
293     super._transferFromEscrow(nftContract, tokenId, recipient, seller);
294   }
295 
296   /**
297    * @inheritdoc NFTMarketCore
298    * @dev Checks if there is a buy price set, if not then allow the transfer to proceed.
299    */
300   function _transferFromEscrowIfAvailable(
301     address nftContract,
302     uint256 tokenId,
303     address recipient
304   ) internal virtual override {
305     BuyPrice storage buyPrice = nftContractToTokenIdToBuyPrice[nftContract][tokenId];
306     if (buyPrice.seller == address(0)) {
307       // A buy price has been set for this NFT so it should remain in escrow.
308       super._transferFromEscrowIfAvailable(nftContract, tokenId, recipient);
309     }
310   }
311 
312   /**
313    * @inheritdoc NFTMarketCore
314    * @dev Checks if the NFT is already in escrow for buy now.
315    */
316   function _transferToEscrow(address nftContract, uint256 tokenId) internal virtual override {
317     BuyPrice storage buyPrice = nftContractToTokenIdToBuyPrice[nftContract][tokenId];
318     if (buyPrice.seller == address(0)) {
319       // The NFT is not in escrow for buy now.
320       super._transferToEscrow(nftContract, tokenId);
321     } else if (buyPrice.seller != msg.sender) {
322       // When there is a buy price set, the `buyPrice.seller` is the owner of the NFT.
323       revert NFTMarketBuyPrice_Seller_Mismatch(buyPrice.seller);
324     }
325   }
326 
327   /**
328    * @notice Returns the buy price details for an NFT if one is available.
329    * @dev If no price is found, seller will be address(0) and price will be max uint256.
330    * @param nftContract The address of the NFT contract.
331    * @param tokenId The id of the NFT.
332    * @return seller The address of the owner that listed a buy price for this NFT.
333    * Returns `address(0)` if there is no buy price set for this NFT.
334    * @return price The price of the NFT.
335    * Returns `0` if there is no buy price set for this NFT.
336    */
337   function getBuyPrice(address nftContract, uint256 tokenId) external view returns (address seller, uint256 price) {
338     BuyPrice storage buyPrice = nftContractToTokenIdToBuyPrice[nftContract][tokenId];
339     if (buyPrice.seller == address(0)) {
340       return (address(0), type(uint256).max);
341     }
342     return (buyPrice.seller, buyPrice.price);
343   }
344 
345   /**
346    * @inheritdoc NFTMarketCore
347    * @dev Returns the seller if there is a buy price set for this NFT, otherwise
348    * bubbles the call up for other considerations.
349    */
350   function _getSellerFor(address nftContract, uint256 tokenId)
351     internal
352     view
353     virtual
354     override
355     returns (address payable seller)
356   {
357     seller = nftContractToTokenIdToBuyPrice[nftContract][tokenId].seller;
358     if (seller == address(0)) {
359       seller = super._getSellerFor(nftContract, tokenId);
360     }
361   }
362 
363   /**
364    * @notice This empty reserved space is put in place to allow future versions to add new
365    * variables without shifting down storage in the inheritance chain.
366    * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
367    */
368   uint256[1000] private __gap;
369 }
