1 // File: contracts/access/IKOAccessControlsLookup.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity 0.8.4;
6 
7 interface IKOAccessControlsLookup {
8     function hasAdminRole(address _address) external view returns (bool);
9 
10     function isVerifiedArtist(uint256 _index, address _account, bytes32[] calldata _merkleProof) external view returns (bool);
11 
12     function isVerifiedArtistProxy(address _artist, address _proxy) external view returns (bool);
13 
14     function hasLegacyMinterRole(address _address) external view returns (bool);
15 
16     function hasContractRole(address _address) external view returns (bool);
17 
18     function hasContractOrAdminRole(address _address) external view returns (bool);
19 }
20 
21 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
22 
23 
24 
25 pragma solidity ^0.8.0;
26 
27 /**
28  * @dev Interface of the ERC165 standard, as defined in the
29  * https://eips.ethereum.org/EIPS/eip-165[EIP].
30  *
31  * Implementers can declare support of contract interfaces, which can then be
32  * queried by others ({ERC165Checker}).
33  *
34  * For an implementation, see {ERC165}.
35  */
36 interface IERC165 {
37     /**
38      * @dev Returns true if this contract implements the interface defined by
39      * `interfaceId`. See the corresponding
40      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
41      * to learn more about how these ids are created.
42      *
43      * This function call must use less than 30 000 gas.
44      */
45     function supportsInterface(bytes4 interfaceId) external view returns (bool);
46 }
47 
48 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
49 
50 
51 
52 pragma solidity ^0.8.0;
53 
54 
55 /**
56  * @dev Required interface of an ERC721 compliant contract.
57  */
58 interface IERC721 is IERC165 {
59     /**
60      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
61      */
62     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
63 
64     /**
65      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
66      */
67     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
68 
69     /**
70      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
71      */
72     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
73 
74     /**
75      * @dev Returns the number of tokens in ``owner``'s account.
76      */
77     function balanceOf(address owner) external view returns (uint256 balance);
78 
79     /**
80      * @dev Returns the owner of the `tokenId` token.
81      *
82      * Requirements:
83      *
84      * - `tokenId` must exist.
85      */
86     function ownerOf(uint256 tokenId) external view returns (address owner);
87 
88     /**
89      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
90      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
91      *
92      * Requirements:
93      *
94      * - `from` cannot be the zero address.
95      * - `to` cannot be the zero address.
96      * - `tokenId` token must exist and be owned by `from`.
97      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
98      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
99      *
100      * Emits a {Transfer} event.
101      */
102     function safeTransferFrom(
103         address from,
104         address to,
105         uint256 tokenId
106     ) external;
107 
108     /**
109      * @dev Transfers `tokenId` token from `from` to `to`.
110      *
111      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
112      *
113      * Requirements:
114      *
115      * - `from` cannot be the zero address.
116      * - `to` cannot be the zero address.
117      * - `tokenId` token must be owned by `from`.
118      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
119      *
120      * Emits a {Transfer} event.
121      */
122     function transferFrom(
123         address from,
124         address to,
125         uint256 tokenId
126     ) external;
127 
128     /**
129      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
130      * The approval is cleared when the token is transferred.
131      *
132      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
133      *
134      * Requirements:
135      *
136      * - The caller must own the token or be an approved operator.
137      * - `tokenId` must exist.
138      *
139      * Emits an {Approval} event.
140      */
141     function approve(address to, uint256 tokenId) external;
142 
143     /**
144      * @dev Returns the account approved for `tokenId` token.
145      *
146      * Requirements:
147      *
148      * - `tokenId` must exist.
149      */
150     function getApproved(uint256 tokenId) external view returns (address operator);
151 
152     /**
153      * @dev Approve or remove `operator` as an operator for the caller.
154      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
155      *
156      * Requirements:
157      *
158      * - The `operator` cannot be the caller.
159      *
160      * Emits an {ApprovalForAll} event.
161      */
162     function setApprovalForAll(address operator, bool _approved) external;
163 
164     /**
165      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
166      *
167      * See {setApprovalForAll}
168      */
169     function isApprovedForAll(address owner, address operator) external view returns (bool);
170 
171     /**
172      * @dev Safely transfers `tokenId` token from `from` to `to`.
173      *
174      * Requirements:
175      *
176      * - `from` cannot be the zero address.
177      * - `to` cannot be the zero address.
178      * - `tokenId` token must exist and be owned by `from`.
179      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
180      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
181      *
182      * Emits a {Transfer} event.
183      */
184     function safeTransferFrom(
185         address from,
186         address to,
187         uint256 tokenId,
188         bytes calldata data
189     ) external;
190 }
191 
192 // File: contracts/core/IERC2309.sol
193 
194 
195 
196 pragma solidity 0.8.4;
197 
198 /**
199   @title ERC-2309: ERC-721 Batch Mint Extension
200   @dev https://github.com/ethereum/EIPs/issues/2309
201  */
202 interface IERC2309 {
203     /**
204       @notice This event is emitted when ownership of a batch of tokens changes by any mechanism.
205       This includes minting, transferring, and burning.
206 
207       @dev The address executing the transaction MUST own all the tokens within the range of
208       fromTokenId and toTokenId, or MUST be an approved operator to act on the owners behalf.
209       The fromTokenId and toTokenId MUST be a sequential range of tokens IDs.
210       When minting/creating tokens, the `fromAddress` argument MUST be set to `0x0` (i.e. zero address).
211       When burning/destroying tokens, the `toAddress` argument MUST be set to `0x0` (i.e. zero address).
212 
213       @param fromTokenId The token ID that begins the batch of tokens being transferred
214       @param toTokenId The token ID that ends the batch of tokens being transferred
215       @param fromAddress The address transferring ownership of the specified range of tokens
216       @param toAddress The address receiving ownership of the specified range of tokens.
217     */
218     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed fromAddress, address indexed toAddress);
219 }
220 
221 // File: contracts/core/IERC2981.sol
222 
223 
224 
225 pragma solidity 0.8.4;
226 
227 
228 /// @notice This is purely an extension for the KO platform
229 /// @notice Royalties on KO are defined at an edition level for all tokens from the same edition
230 interface IERC2981EditionExtension {
231 
232     /// @notice Does the edition have any royalties defined
233     function hasRoyalties(uint256 _editionId) external view returns (bool);
234 
235     /// @notice Get the royalty receiver - all royalties should be sent to this account if not zero address
236     function getRoyaltiesReceiver(uint256 _editionId) external view returns (address);
237 }
238 
239 /**
240  * ERC2981 standards interface for royalties
241  */
242 interface IERC2981 is IERC165, IERC2981EditionExtension {
243     /// ERC165 bytes to add to interface array - set in parent contract
244     /// implementing this standard
245     ///
246     /// bytes4(keccak256("royaltyInfo(uint256,uint256)")) == 0x2a55205a
247     /// bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
248     /// _registerInterface(_INTERFACE_ID_ERC2981);
249 
250     /// @notice Called with the sale price to determine how much royalty
251     //          is owed and to whom.
252     /// @param _tokenId - the NFT asset queried for royalty information
253     /// @param _value - the sale price of the NFT asset specified by _tokenId
254     /// @return _receiver - address of who should be sent the royalty payment
255     /// @return _royaltyAmount - the royalty payment amount for _value sale price
256     function royaltyInfo(
257         uint256 _tokenId,
258         uint256 _value
259     ) external view returns (
260         address _receiver,
261         uint256 _royaltyAmount
262     );
263 
264 }
265 
266 // File: contracts/core/IHasSecondarySaleFees.sol
267 
268 
269 
270 pragma solidity 0.8.4;
271 
272 
273 /// @title Royalties formats required for use on the Rarible platform
274 /// @dev https://docs.rarible.com/asset/royalties-schema
275 interface IHasSecondarySaleFees is IERC165 {
276 
277     event SecondarySaleFees(uint256 tokenId, address[] recipients, uint[] bps);
278 
279     function getFeeRecipients(uint256 id) external returns (address payable[] memory);
280 
281     function getFeeBps(uint256 id) external returns (uint[] memory);
282 }
283 
284 // File: contracts/core/IKODAV3.sol
285 
286 
287 
288 pragma solidity 0.8.4;
289 
290 
291 
292 
293 
294 
295 /// @title Core KODA V3 functionality
296 interface IKODAV3 is
297 IERC165, // Contract introspection
298 IERC721, // Core NFTs
299 IERC2309, // Consecutive batch mint
300 IERC2981, // Royalties
301 IHasSecondarySaleFees // Rariable / Foundation royalties
302 {
303     // edition utils
304 
305     function getCreatorOfEdition(uint256 _editionId) external view returns (address _originalCreator);
306 
307     function getCreatorOfToken(uint256 _tokenId) external view returns (address _originalCreator);
308 
309     function getSizeOfEdition(uint256 _editionId) external view returns (uint256 _size);
310 
311     function getEditionSizeOfToken(uint256 _tokenId) external view returns (uint256 _size);
312 
313     function editionExists(uint256 _editionId) external view returns (bool);
314 
315     // Has the edition been disabled / soft burnt
316     function isEditionSalesDisabled(uint256 _editionId) external view returns (bool);
317 
318     // Has the edition been disabled / soft burnt OR sold out
319     function isSalesDisabledOrSoldOut(uint256 _editionId) external view returns (bool);
320 
321     // Work out the max token ID for an edition ID
322     function maxTokenIdOfEdition(uint256 _editionId) external view returns (uint256 _tokenId);
323 
324     // Helper method for getting the next primary sale token from an edition starting low to high token IDs
325     function getNextAvailablePrimarySaleToken(uint256 _editionId) external returns (uint256 _tokenId);
326 
327     // Helper method for getting the next primary sale token from an edition starting high to low token IDs
328     function getReverseAvailablePrimarySaleToken(uint256 _editionId) external view returns (uint256 _tokenId);
329 
330     // Utility method to get all data needed for the next primary sale, low token ID to high
331     function facilitateNextPrimarySale(uint256 _editionId) external returns (address _receiver, address _creator, uint256 _tokenId);
332 
333     // Utility method to get all data needed for the next primary sale, high token ID to low
334     function facilitateReversePrimarySale(uint256 _editionId) external returns (address _receiver, address _creator, uint256 _tokenId);
335 
336     // Expanded royalty method for the edition, not token
337     function royaltyAndCreatorInfo(uint256 _editionId, uint256 _value) external returns (address _receiver, address _creator, uint256 _amount);
338 
339     // Allows the creator to correct mistakes until the first token from an edition is sold
340     function updateURIIfNoSaleMade(uint256 _editionId, string calldata _newURI) external;
341 
342     // Has any primary transfer happened from an edition
343     function hasMadePrimarySale(uint256 _editionId) external view returns (bool);
344 
345     // Has the edition sold out
346     function isEditionSoldOut(uint256 _editionId) external view returns (bool);
347 
348     // Toggle on/off the edition from being able to make sales
349     function toggleEditionSalesDisabled(uint256 _editionId) external;
350 
351     // token utils
352 
353     function exists(uint256 _tokenId) external view returns (bool);
354 
355     function getEditionIdOfToken(uint256 _tokenId) external pure returns (uint256 _editionId);
356 
357     function getEditionDetails(uint256 _tokenId) external view returns (address _originalCreator, address _owner, uint16 _size, uint256 _editionId, string memory _uri);
358 
359     function hadPrimarySaleOfToken(uint256 _tokenId) external view returns (bool);
360 
361 }
362 
363 // File: contracts/marketplace/IKODAV3Marketplace.sol
364 
365 
366 pragma solidity 0.8.4;
367 
368 interface IBuyNowMarketplace {
369     event ListedForBuyNow(uint256 indexed _id, uint256 _price, address _currentOwner, uint256 _startDate);
370     event BuyNowPriceChanged(uint256 indexed _id, uint256 _price);
371     event BuyNowDeListed(uint256 indexed _id);
372     event BuyNowPurchased(uint256 indexed _tokenId, address _buyer, address _currentOwner, uint256 _price);
373 
374     function listForBuyNow(address _creator, uint256 _id, uint128 _listingPrice, uint128 _startDate) external;
375 
376     function buyEditionToken(uint256 _id) external payable;
377     function buyEditionTokenFor(uint256 _id, address _recipient) external payable;
378 
379     function setBuyNowPriceListing(uint256 _editionId, uint128 _listingPrice) external;
380 }
381 
382 interface IEditionOffersMarketplace {
383     event EditionAcceptingOffer(uint256 indexed _editionId, uint128 _startDate);
384     event EditionBidPlaced(uint256 indexed _editionId, address _bidder, uint256 _amount);
385     event EditionBidWithdrawn(uint256 indexed _editionId, address _bidder);
386     event EditionBidAccepted(uint256 indexed _editionId, uint256 indexed _tokenId, address _bidder, uint256 _amount);
387     event EditionBidRejected(uint256 indexed _editionId, address _bidder, uint256 _amount);
388     event EditionConvertedFromOffersToBuyItNow(uint256 _editionId, uint128 _price, uint128 _startDate);
389 
390     function enableEditionOffers(uint256 _editionId, uint128 _startDate) external;
391 
392     function placeEditionBid(uint256 _editionId) external payable;
393     function placeEditionBidFor(uint256 _editionId, address _bidder) external payable;
394 
395     function withdrawEditionBid(uint256 _editionId) external;
396 
397     function rejectEditionBid(uint256 _editionId) external;
398 
399     function acceptEditionBid(uint256 _editionId, uint256 _offerPrice) external;
400 
401     function convertOffersToBuyItNow(uint256 _editionId, uint128 _listingPrice, uint128 _startDate) external;
402 }
403 
404 interface IEditionSteppedMarketplace {
405     event EditionSteppedSaleListed(uint256 indexed _editionId, uint128 _basePrice, uint128 _stepPrice, uint128 _startDate);
406     event EditionSteppedSaleBuy(uint256 indexed _editionId, uint256 indexed _tokenId, address _buyer, uint256 _price, uint16 _currentStep);
407     event EditionSteppedAuctionUpdated(uint256 indexed _editionId, uint128 _basePrice, uint128 _stepPrice);
408 
409     function listSteppedEditionAuction(address _creator, uint256 _editionId, uint128 _basePrice, uint128 _stepPrice, uint128 _startDate) external;
410 
411     function buyNextStep(uint256 _editionId) external payable;
412     function buyNextStepFor(uint256 _editionId, address _buyer) external payable;
413 
414     function convertSteppedAuctionToListing(uint256 _editionId, uint128 _listingPrice, uint128 _startDate) external;
415 
416     function convertSteppedAuctionToOffers(uint256 _editionId, uint128 _startDate) external;
417 
418     function updateSteppedAuction(uint256 _editionId, uint128 _basePrice, uint128 _stepPrice) external;
419 }
420 
421 interface IReserveAuctionMarketplace {
422     event ListedForReserveAuction(uint256 indexed _id, uint256 _reservePrice, uint128 _startDate);
423     event BidPlacedOnReserveAuction(uint256 indexed _id, address _currentOwner, address _bidder, uint256 _amount, uint256 _originalBiddingEnd, uint256 _currentBiddingEnd);
424     event ReserveAuctionResulted(uint256 indexed _id, uint256 _finalPrice, address _currentOwner, address _winner, address _resulter);
425     event BidWithdrawnFromReserveAuction(uint256 _id, address _bidder, uint128 _bid);
426     event ReservePriceUpdated(uint256 indexed _id, uint256 _reservePrice);
427     event ReserveAuctionConvertedToBuyItNow(uint256 indexed _id, uint128 _listingPrice, uint128 _startDate);
428     event EmergencyBidWithdrawFromReserveAuction(uint256 indexed _id, address _bidder, uint128 _bid);
429 
430     function placeBidOnReserveAuction(uint256 _id) external payable;
431     function placeBidOnReserveAuctionFor(uint256 _id, address _bidder) external payable;
432 
433     function listForReserveAuction(address _creator, uint256 _id, uint128 _reservePrice, uint128 _startDate) external;
434 
435     function resultReserveAuction(uint256 _id) external;
436 
437     function withdrawBidFromReserveAuction(uint256 _id) external;
438 
439     function updateReservePriceForReserveAuction(uint256 _id, uint128 _reservePrice) external;
440 
441     function emergencyExitBidFromReserveAuction(uint256 _id) external;
442 }
443 
444 interface IKODAV3PrimarySaleMarketplace is IEditionSteppedMarketplace, IEditionOffersMarketplace, IBuyNowMarketplace, IReserveAuctionMarketplace {
445     function convertReserveAuctionToBuyItNow(uint256 _editionId, uint128 _listingPrice, uint128 _startDate) external;
446 
447     function convertReserveAuctionToOffers(uint256 _editionId, uint128 _startDate) external;
448 }
449 
450 interface ITokenBuyNowMarketplace {
451     event TokenDeListed(uint256 indexed _tokenId);
452 
453     function delistToken(uint256 _tokenId) external;
454 }
455 
456 interface ITokenOffersMarketplace {
457     event TokenBidPlaced(uint256 indexed _tokenId, address _currentOwner, address _bidder, uint256 _amount);
458     event TokenBidAccepted(uint256 indexed _tokenId, address _currentOwner, address _bidder, uint256 _amount);
459     event TokenBidRejected(uint256 indexed _tokenId, address _currentOwner, address _bidder, uint256 _amount);
460     event TokenBidWithdrawn(uint256 indexed _tokenId, address _bidder);
461 
462     function acceptTokenBid(uint256 _tokenId, uint256 _offerPrice) external;
463 
464     function rejectTokenBid(uint256 _tokenId) external;
465 
466     function withdrawTokenBid(uint256 _tokenId) external;
467 
468     function placeTokenBid(uint256 _tokenId) external payable;
469     function placeTokenBidFor(uint256 _tokenId, address _bidder) external payable;
470 }
471 
472 interface IBuyNowSecondaryMarketplace {
473     function listTokenForBuyNow(uint256 _tokenId, uint128 _listingPrice, uint128 _startDate) external;
474 }
475 
476 interface IEditionOffersSecondaryMarketplace {
477     event EditionBidPlaced(uint256 indexed _editionId, address indexed _bidder, uint256 _bid);
478     event EditionBidWithdrawn(uint256 indexed _editionId, address _bidder);
479     event EditionBidAccepted(uint256 indexed _tokenId, address _currentOwner, address _bidder, uint256 _amount);
480 
481     function placeEditionBid(uint256 _editionId) external payable;
482     function placeEditionBidFor(uint256 _editionId, address _bidder) external payable;
483 
484     function withdrawEditionBid(uint256 _editionId) external;
485 
486     function acceptEditionBid(uint256 _tokenId, uint256 _offerPrice) external;
487 }
488 
489 interface IKODAV3SecondarySaleMarketplace is ITokenBuyNowMarketplace, ITokenOffersMarketplace, IEditionOffersSecondaryMarketplace, IBuyNowSecondaryMarketplace {
490     function convertReserveAuctionToBuyItNow(uint256 _tokenId, uint128 _listingPrice, uint128 _startDate) external;
491 
492     function convertReserveAuctionToOffers(uint256 _tokenId) external;
493 }
494 
495 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
496 
497 
498 
499 pragma solidity ^0.8.0;
500 
501 /**
502  * @dev Contract module that helps prevent reentrant calls to a function.
503  *
504  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
505  * available, which can be applied to functions to make sure there are no nested
506  * (reentrant) calls to them.
507  *
508  * Note that because there is a single `nonReentrant` guard, functions marked as
509  * `nonReentrant` may not call one another. This can be worked around by making
510  * those functions `private`, and then adding `external` `nonReentrant` entry
511  * points to them.
512  *
513  * TIP: If you would like to learn more about reentrancy and alternative ways
514  * to protect against it, check out our blog post
515  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
516  */
517 abstract contract ReentrancyGuard {
518     // Booleans are more expensive than uint256 or any type that takes up a full
519     // word because each write operation emits an extra SLOAD to first read the
520     // slot's contents, replace the bits taken up by the boolean, and then write
521     // back. This is the compiler's defense against contract upgrades and
522     // pointer aliasing, and it cannot be disabled.
523 
524     // The values being non-zero value makes deployment a bit more expensive,
525     // but in exchange the refund on every call to nonReentrant will be lower in
526     // amount. Since refunds are capped to a percentage of the total
527     // transaction's gas, it is best to keep them low in cases like this one, to
528     // increase the likelihood of the full refund coming into effect.
529     uint256 private constant _NOT_ENTERED = 1;
530     uint256 private constant _ENTERED = 2;
531 
532     uint256 private _status;
533 
534     constructor() {
535         _status = _NOT_ENTERED;
536     }
537 
538     /**
539      * @dev Prevents a contract from calling itself, directly or indirectly.
540      * Calling a `nonReentrant` function from another `nonReentrant`
541      * function is not supported. It is possible to prevent this from happening
542      * by making the `nonReentrant` function external, and make it call a
543      * `private` function that does the actual work.
544      */
545     modifier nonReentrant() {
546         // On the first call to nonReentrant, _notEntered will be true
547         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
548 
549         // Any calls to nonReentrant after this point will fail
550         _status = _ENTERED;
551 
552         _;
553 
554         // By storing the original value once again, a refund is triggered (see
555         // https://eips.ethereum.org/EIPS/eip-2200)
556         _status = _NOT_ENTERED;
557     }
558 }
559 
560 // File: @openzeppelin/contracts/utils/Context.sol
561 
562 
563 
564 pragma solidity ^0.8.0;
565 
566 /*
567  * @dev Provides information about the current execution context, including the
568  * sender of the transaction and its data. While these are generally available
569  * via msg.sender and msg.data, they should not be accessed in such a direct
570  * manner, since when dealing with meta-transactions the account sending and
571  * paying for execution may not be the actual sender (as far as an application
572  * is concerned).
573  *
574  * This contract is only required for intermediate, library-like contracts.
575  */
576 abstract contract Context {
577     function _msgSender() internal view virtual returns (address) {
578         return msg.sender;
579     }
580 
581     function _msgData() internal view virtual returns (bytes calldata) {
582         return msg.data;
583     }
584 }
585 
586 // File: @openzeppelin/contracts/security/Pausable.sol
587 
588 
589 
590 pragma solidity ^0.8.0;
591 
592 
593 /**
594  * @dev Contract module which allows children to implement an emergency stop
595  * mechanism that can be triggered by an authorized account.
596  *
597  * This module is used through inheritance. It will make available the
598  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
599  * the functions of your contract. Note that they will not be pausable by
600  * simply including this module, only once the modifiers are put in place.
601  */
602 abstract contract Pausable is Context {
603     /**
604      * @dev Emitted when the pause is triggered by `account`.
605      */
606     event Paused(address account);
607 
608     /**
609      * @dev Emitted when the pause is lifted by `account`.
610      */
611     event Unpaused(address account);
612 
613     bool private _paused;
614 
615     /**
616      * @dev Initializes the contract in unpaused state.
617      */
618     constructor() {
619         _paused = false;
620     }
621 
622     /**
623      * @dev Returns true if the contract is paused, and false otherwise.
624      */
625     function paused() public view virtual returns (bool) {
626         return _paused;
627     }
628 
629     /**
630      * @dev Modifier to make a function callable only when the contract is not paused.
631      *
632      * Requirements:
633      *
634      * - The contract must not be paused.
635      */
636     modifier whenNotPaused() {
637         require(!paused(), "Pausable: paused");
638         _;
639     }
640 
641     /**
642      * @dev Modifier to make a function callable only when the contract is paused.
643      *
644      * Requirements:
645      *
646      * - The contract must be paused.
647      */
648     modifier whenPaused() {
649         require(paused(), "Pausable: not paused");
650         _;
651     }
652 
653     /**
654      * @dev Triggers stopped state.
655      *
656      * Requirements:
657      *
658      * - The contract must not be paused.
659      */
660     function _pause() internal virtual whenNotPaused {
661         _paused = true;
662         emit Paused(_msgSender());
663     }
664 
665     /**
666      * @dev Returns to normal state.
667      *
668      * Requirements:
669      *
670      * - The contract must be paused.
671      */
672     function _unpause() internal virtual whenPaused {
673         _paused = false;
674         emit Unpaused(_msgSender());
675     }
676 }
677 
678 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
679 
680 
681 
682 pragma solidity ^0.8.0;
683 
684 /**
685  * @dev Interface of the ERC20 standard as defined in the EIP.
686  */
687 interface IERC20 {
688     /**
689      * @dev Returns the amount of tokens in existence.
690      */
691     function totalSupply() external view returns (uint256);
692 
693     /**
694      * @dev Returns the amount of tokens owned by `account`.
695      */
696     function balanceOf(address account) external view returns (uint256);
697 
698     /**
699      * @dev Moves `amount` tokens from the caller's account to `recipient`.
700      *
701      * Returns a boolean value indicating whether the operation succeeded.
702      *
703      * Emits a {Transfer} event.
704      */
705     function transfer(address recipient, uint256 amount) external returns (bool);
706 
707     /**
708      * @dev Returns the remaining number of tokens that `spender` will be
709      * allowed to spend on behalf of `owner` through {transferFrom}. This is
710      * zero by default.
711      *
712      * This value changes when {approve} or {transferFrom} are called.
713      */
714     function allowance(address owner, address spender) external view returns (uint256);
715 
716     /**
717      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
718      *
719      * Returns a boolean value indicating whether the operation succeeded.
720      *
721      * IMPORTANT: Beware that changing an allowance with this method brings the risk
722      * that someone may use both the old and the new allowance by unfortunate
723      * transaction ordering. One possible solution to mitigate this race
724      * condition is to first reduce the spender's allowance to 0 and set the
725      * desired value afterwards:
726      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
727      *
728      * Emits an {Approval} event.
729      */
730     function approve(address spender, uint256 amount) external returns (bool);
731 
732     /**
733      * @dev Moves `amount` tokens from `sender` to `recipient` using the
734      * allowance mechanism. `amount` is then deducted from the caller's
735      * allowance.
736      *
737      * Returns a boolean value indicating whether the operation succeeded.
738      *
739      * Emits a {Transfer} event.
740      */
741     function transferFrom(
742         address sender,
743         address recipient,
744         uint256 amount
745     ) external returns (bool);
746 
747     /**
748      * @dev Emitted when `value` tokens are moved from one account (`from`) to
749      * another (`to`).
750      *
751      * Note that `value` may be zero.
752      */
753     event Transfer(address indexed from, address indexed to, uint256 value);
754 
755     /**
756      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
757      * a call to {approve}. `value` is the new allowance.
758      */
759     event Approval(address indexed owner, address indexed spender, uint256 value);
760 }
761 
762 // File: contracts/marketplace/BaseMarketplace.sol
763 
764 
765 
766 pragma solidity 0.8.4;
767 
768 
769 
770 
771 
772 
773 /// @notice Core logic and state shared between both marketplaces
774 abstract contract BaseMarketplace is ReentrancyGuard, Pausable {
775 
776     event AdminUpdateModulo(uint256 _modulo);
777     event AdminUpdateMinBidAmount(uint256 _minBidAmount);
778     event AdminUpdateAccessControls(IKOAccessControlsLookup indexed _oldAddress, IKOAccessControlsLookup indexed _newAddress);
779     event AdminUpdatePlatformPrimarySaleCommission(uint256 _platformPrimarySaleCommission);
780     event AdminUpdateBidLockupPeriod(uint256 _bidLockupPeriod);
781     event AdminUpdatePlatformAccount(address indexed _oldAddress, address indexed _newAddress);
782     event AdminRecoverERC20(IERC20 indexed _token, address indexed _recipient, uint256 _amount);
783     event AdminRecoverETH(address payable indexed _recipient, uint256 _amount);
784 
785     event BidderRefunded(uint256 indexed _id, address _bidder, uint256 _bid, address _newBidder, uint256 _newOffer);
786     event BidderRefundedFailed(uint256 indexed _id, address _bidder, uint256 _bid, address _newBidder, uint256 _newOffer);
787 
788     // Only a whitelisted smart contract in the access controls contract
789     modifier onlyContract() {
790         _onlyContract();
791         _;
792     }
793 
794     function _onlyContract() private view {
795         require(accessControls.hasContractRole(_msgSender()), "Caller not contract");
796     }
797 
798     // Only admin defined in the access controls contract
799     modifier onlyAdmin() {
800         _onlyAdmin();
801         _;
802     }
803 
804     function _onlyAdmin() private view {
805         require(accessControls.hasAdminRole(_msgSender()), "Caller not admin");
806     }
807 
808     /// @notice Address of the access control contract
809     IKOAccessControlsLookup public accessControls;
810 
811     /// @notice KODA V3 token
812     IKODAV3 public koda;
813 
814     /// @notice platform funds collector
815     address public platformAccount;
816 
817     /// @notice precision 100.00000%
818     uint256 public modulo = 100_00000;
819 
820     /// @notice Minimum bid / minimum list amount
821     uint256 public minBidAmount = 0.01 ether;
822 
823     /// @notice Bid lockup period
824     uint256 public bidLockupPeriod = 6 hours;
825 
826     constructor(IKOAccessControlsLookup _accessControls, IKODAV3 _koda, address _platformAccount) {
827         koda = _koda;
828         accessControls = _accessControls;
829         platformAccount = _platformAccount;
830     }
831 
832     function recoverERC20(IERC20 _token, address _recipient, uint256 _amount) public onlyAdmin {
833         _token.transfer(_recipient, _amount);
834         emit AdminRecoverERC20(_token, _recipient, _amount);
835     }
836 
837     function recoverStuckETH(address payable _recipient, uint256 _amount) public onlyAdmin {
838         (bool success,) = _recipient.call{value : _amount}("");
839         require(success, "Unable to send recipient ETH");
840         emit AdminRecoverETH(_recipient, _amount);
841     }
842 
843     function updateAccessControls(IKOAccessControlsLookup _accessControls) public onlyAdmin {
844         require(_accessControls.hasAdminRole(_msgSender()), "Sender must have admin role in new contract");
845         emit AdminUpdateAccessControls(accessControls, _accessControls);
846         accessControls = _accessControls;
847     }
848 
849     function updateModulo(uint256 _modulo) public onlyAdmin {
850         require(_modulo > 0, "Modulo point cannot be zero");
851         modulo = _modulo;
852         emit AdminUpdateModulo(_modulo);
853     }
854 
855     function updateMinBidAmount(uint256 _minBidAmount) public onlyAdmin {
856         minBidAmount = _minBidAmount;
857         emit AdminUpdateMinBidAmount(_minBidAmount);
858     }
859 
860     function updateBidLockupPeriod(uint256 _bidLockupPeriod) public onlyAdmin {
861         bidLockupPeriod = _bidLockupPeriod;
862         emit AdminUpdateBidLockupPeriod(_bidLockupPeriod);
863     }
864 
865     function updatePlatformAccount(address _newPlatformAccount) public onlyAdmin {
866         emit AdminUpdatePlatformAccount(platformAccount, _newPlatformAccount);
867         platformAccount = _newPlatformAccount;
868     }
869 
870     function pause() public onlyAdmin {
871         super._pause();
872     }
873 
874     function unpause() public onlyAdmin {
875         super._unpause();
876     }
877 
878     function _getLockupTime() internal view returns (uint256 lockupUntil) {
879         lockupUntil = block.timestamp + bidLockupPeriod;
880     }
881 
882     function _refundBidder(uint256 _id, address _receiver, uint256 _paymentAmount, address _newBidder, uint256 _newOffer) internal {
883         (bool success,) = _receiver.call{value : _paymentAmount}("");
884         if (!success) {
885             emit BidderRefundedFailed(_id, _receiver, _paymentAmount, _newBidder, _newOffer);
886         } else {
887             emit BidderRefunded(_id, _receiver, _paymentAmount, _newBidder, _newOffer);
888         }
889     }
890 
891     /// @dev This allows the processing of a marketplace sale to be delegated higher up the inheritance hierarchy
892     function _processSale(
893         uint256 _id,
894         uint256 _paymentAmount,
895         address _buyer,
896         address _seller
897     ) internal virtual returns (uint256);
898 
899     /// @dev This allows an auction mechanic to ask a marketplace if a new listing is permitted i.e. this could be false if the edition or token is already listed under a different mechanic
900     function _isListingPermitted(uint256 _id) internal virtual returns (bool);
901 }
902 
903 // File: contracts/marketplace/BuyNowMarketplace.sol
904 
905 
906 
907 pragma solidity 0.8.4;
908 
909 
910 
911 // "buy now" sale flow
912 abstract contract BuyNowMarketplace is IBuyNowMarketplace, BaseMarketplace {
913     // Buy now listing definition
914     struct Listing {
915         uint128 price;
916         uint128 startDate;
917         address seller;
918     }
919 
920     /// @notice Edition or Token ID to Listing
921     mapping(uint256 => Listing) public editionOrTokenListings;
922 
923     // list edition with "buy now" price and start date
924     function listForBuyNow(address _seller, uint256 _id, uint128 _listingPrice, uint128 _startDate)
925     public
926     override
927     whenNotPaused {
928         require(_isListingPermitted(_id), "Listing is not permitted");
929         require(_isBuyNowListingPermitted(_id), "Buy now listing invalid");
930         require(_listingPrice >= minBidAmount, "Listing price not enough");
931 
932         // Store listing data
933         editionOrTokenListings[_id] = Listing(_listingPrice, _startDate, _seller);
934 
935         emit ListedForBuyNow(_id, _listingPrice, _seller, _startDate);
936     }
937 
938     // Buy an token from the edition on the primary market
939     function buyEditionToken(uint256 _id)
940     public
941     override
942     payable
943     whenNotPaused
944     nonReentrant {
945         _facilitateBuyNow(_id, _msgSender());
946     }
947 
948     // Buy an token from the edition on the primary market, ability to define the recipient
949     function buyEditionTokenFor(uint256 _id, address _recipient)
950     public
951     override
952     payable
953     whenNotPaused
954     nonReentrant {
955         _facilitateBuyNow(_id, _recipient);
956     }
957 
958     // update the "buy now" price
959     function setBuyNowPriceListing(uint256 _id, uint128 _listingPrice)
960     public
961     override
962     whenNotPaused {
963         require(
964             editionOrTokenListings[_id].seller == _msgSender()
965             || accessControls.isVerifiedArtistProxy(editionOrTokenListings[_id].seller, _msgSender()),
966             "Only seller can change price"
967         );
968 
969         // Set price
970         editionOrTokenListings[_id].price = _listingPrice;
971 
972         // Emit event
973         emit BuyNowPriceChanged(_id, _listingPrice);
974     }
975 
976     function _facilitateBuyNow(uint256 _id, address _recipient) internal {
977         Listing storage listing = editionOrTokenListings[_id];
978         require(address(0) != listing.seller, "No listing found");
979         require(msg.value >= listing.price, "List price not satisfied");
980         require(block.timestamp >= listing.startDate, "List not available yet");
981 
982         uint256 tokenId = _processSale(_id, msg.value, _recipient, listing.seller);
983 
984         emit BuyNowPurchased(tokenId, _recipient, listing.seller, msg.value);
985     }
986 
987     function _isBuyNowListingPermitted(uint256 _id) internal virtual returns (bool);
988 }
989 
990 // File: contracts/marketplace/ReserveAuctionMarketplace.sol
991 
992 
993 
994 pragma solidity 0.8.4;
995 
996 
997 
998 
999 
1000 abstract contract ReserveAuctionMarketplace is IReserveAuctionMarketplace, BaseMarketplace {
1001     event AdminUpdateReserveAuctionBidExtensionWindow(uint128 _reserveAuctionBidExtensionWindow);
1002     event AdminUpdateReserveAuctionLengthOnceReserveMet(uint128 _reserveAuctionLengthOnceReserveMet);
1003 
1004     // Reserve auction definition
1005     struct ReserveAuction {
1006         address seller;
1007         address bidder;
1008         uint128 reservePrice;
1009         uint128 bid;
1010         uint128 startDate;
1011         uint128 biddingEnd;
1012     }
1013 
1014     /// @notice 1 of 1 edition ID to reserve auction definition
1015     mapping(uint256 => ReserveAuction) public editionOrTokenWithReserveAuctions;
1016 
1017     /// @notice A reserve auction will be extended by this amount of time if a bid is received near the end
1018     uint128 public reserveAuctionBidExtensionWindow = 15 minutes;
1019 
1020     /// @notice Length that bidding window remains open once the reserve price for an auction has been met
1021     uint128 public reserveAuctionLengthOnceReserveMet = 24 hours;
1022 
1023     function listForReserveAuction(
1024         address _creator,
1025         uint256 _id,
1026         uint128 _reservePrice,
1027         uint128 _startDate
1028     ) public
1029     override
1030     whenNotPaused {
1031         require(_isListingPermitted(_id), "Listing not permitted");
1032         require(_isReserveListingPermitted(_id), "Reserve listing not permitted");
1033         require(_reservePrice >= minBidAmount, "Reserve price must be at least min bid");
1034 
1035         editionOrTokenWithReserveAuctions[_id] = ReserveAuction({
1036         seller : _creator,
1037         bidder : address(0),
1038         reservePrice : _reservePrice,
1039         startDate : _startDate,
1040         biddingEnd : 0,
1041         bid : 0
1042         });
1043 
1044         emit ListedForReserveAuction(_id, _reservePrice, _startDate);
1045     }
1046 
1047     function placeBidOnReserveAuction(uint256 _id)
1048     public
1049     override
1050     payable
1051     whenNotPaused
1052     nonReentrant {
1053         _placeBidOnReserveAuction(_id, _msgSender());
1054     }
1055 
1056     function placeBidOnReserveAuctionFor(uint256 _id, address _bidder)
1057     public
1058     override
1059     payable
1060     whenNotPaused
1061     nonReentrant {
1062         _placeBidOnReserveAuction(_id, _bidder);
1063     }
1064 
1065     function _placeBidOnReserveAuction(uint256 _id, address _bidder) internal {
1066         ReserveAuction storage reserveAuction = editionOrTokenWithReserveAuctions[_id];
1067         require(reserveAuction.reservePrice > 0, "Not set up for reserve auction");
1068         require(block.timestamp >= reserveAuction.startDate, "Not accepting bids yet");
1069         require(msg.value >= reserveAuction.bid + minBidAmount, "You have not exceeded previous bid by min bid amount");
1070 
1071         uint128 originalBiddingEnd = reserveAuction.biddingEnd;
1072 
1073         // If the reserve has been met, then bidding will end in 24 hours
1074         // if we are near the end, we have bids, then extend the bidding end
1075         bool isCountDownTriggered = originalBiddingEnd > 0;
1076 
1077         if (msg.value >= reserveAuction.reservePrice && !isCountDownTriggered) {
1078             reserveAuction.biddingEnd = uint128(block.timestamp) + reserveAuctionLengthOnceReserveMet;
1079         }
1080         else if (isCountDownTriggered) {
1081 
1082             // if a bid has been placed, then we will have a bidding end timestamp
1083             // and we need to ensure no one can bid beyond this
1084             require(block.timestamp < originalBiddingEnd, "No longer accepting bids");
1085             uint128 secondsUntilBiddingEnd = originalBiddingEnd - uint128(block.timestamp);
1086 
1087             // If bid received with in the extension window, extend bidding end
1088             if (secondsUntilBiddingEnd <= reserveAuctionBidExtensionWindow) {
1089                 reserveAuction.biddingEnd = reserveAuction.biddingEnd + reserveAuctionBidExtensionWindow;
1090             }
1091         }
1092 
1093         // if someone else has previously bid, there is a bid we need to refund
1094         if (reserveAuction.bid > 0) {
1095             _refundBidder(_id, reserveAuction.bidder, reserveAuction.bid, _bidder, msg.value);
1096         }
1097 
1098         reserveAuction.bid = uint128(msg.value);
1099         reserveAuction.bidder = _bidder;
1100 
1101         emit BidPlacedOnReserveAuction(_id, reserveAuction.seller, _bidder, msg.value, originalBiddingEnd, reserveAuction.biddingEnd);
1102     }
1103 
1104     function resultReserveAuction(uint256 _id)
1105     public
1106     override
1107     whenNotPaused
1108     nonReentrant {
1109         ReserveAuction storage reserveAuction = editionOrTokenWithReserveAuctions[_id];
1110 
1111         require(reserveAuction.reservePrice > 0, "No active auction");
1112         require(reserveAuction.bid >= reserveAuction.reservePrice, "Reserve not met");
1113         require(block.timestamp > reserveAuction.biddingEnd, "Bidding has not yet ended");
1114 
1115         // N:B. anyone can result the action as only the winner and seller are compensated
1116 
1117         address winner = reserveAuction.bidder;
1118         address seller = reserveAuction.seller;
1119         uint256 winningBid = reserveAuction.bid;
1120         delete editionOrTokenWithReserveAuctions[_id];
1121 
1122         _processSale(_id, winningBid, winner, seller);
1123 
1124         emit ReserveAuctionResulted(_id, winningBid, seller, winner, _msgSender());
1125     }
1126 
1127     // Only permit bid withdrawals if reserve not met
1128     function withdrawBidFromReserveAuction(uint256 _id)
1129     public
1130     override
1131     whenNotPaused
1132     nonReentrant {
1133         ReserveAuction storage reserveAuction = editionOrTokenWithReserveAuctions[_id];
1134 
1135         require(reserveAuction.reservePrice > 0, "No reserve auction in flight");
1136         require(reserveAuction.bid < reserveAuction.reservePrice, "Bids can only be withdrawn if reserve not met");
1137         require(reserveAuction.bidder == _msgSender(), "Only the bidder can withdraw their bid");
1138 
1139         uint256 bidToRefund = reserveAuction.bid;
1140         _refundBidder(_id, reserveAuction.bidder, bidToRefund, address(0), 0);
1141 
1142         reserveAuction.bidder = address(0);
1143         reserveAuction.bid = 0;
1144 
1145         emit BidWithdrawnFromReserveAuction(_id, _msgSender(), uint128(bidToRefund));
1146     }
1147 
1148     // can only do this if the reserve has not been met
1149     function updateReservePriceForReserveAuction(uint256 _id, uint128 _reservePrice)
1150     public
1151     override
1152     whenNotPaused
1153     nonReentrant {
1154         ReserveAuction storage reserveAuction = editionOrTokenWithReserveAuctions[_id];
1155 
1156         require(
1157             reserveAuction.seller == _msgSender()
1158             || accessControls.isVerifiedArtistProxy(reserveAuction.seller, _msgSender()),
1159             "Not the seller"
1160         );
1161 
1162         require(reserveAuction.biddingEnd == 0, "Reserve countdown commenced");
1163         require(_reservePrice >= minBidAmount, "Reserve must be at least min bid");
1164 
1165         // Trigger countdown if new reserve price is greater than any current bids
1166         if (reserveAuction.bid >= _reservePrice) {
1167             reserveAuction.biddingEnd = uint128(block.timestamp) + reserveAuctionLengthOnceReserveMet;
1168         }
1169 
1170         reserveAuction.reservePrice = _reservePrice;
1171 
1172         emit ReservePriceUpdated(_id, _reservePrice);
1173     }
1174 
1175     function emergencyExitBidFromReserveAuction(uint256 _id)
1176     public
1177     override
1178     whenNotPaused
1179     nonReentrant {
1180         ReserveAuction storage reserveAuction = editionOrTokenWithReserveAuctions[_id];
1181 
1182         require(reserveAuction.bid > 0, "No bid in flight");
1183         require(_hasReserveListingBeenInvalidated(_id), "Bid cannot be withdrawn as reserve auction listing is valid");
1184 
1185         bool isSeller = reserveAuction.seller == _msgSender();
1186         bool isBidder = reserveAuction.bidder == _msgSender();
1187         require(
1188             isSeller
1189             || isBidder
1190             || accessControls.isVerifiedArtistProxy(reserveAuction.seller, _msgSender())
1191             || accessControls.hasContractOrAdminRole(_msgSender()),
1192             "Only seller, bidder, contract or platform admin"
1193         );
1194         // external call done last as a gas optimisation i.e. it wont be called if isSeller || isBidder is true
1195 
1196         _refundBidder(_id, reserveAuction.bidder, reserveAuction.bid, address(0), 0);
1197 
1198         emit EmergencyBidWithdrawFromReserveAuction(_id, reserveAuction.bidder, reserveAuction.bid);
1199 
1200         delete editionOrTokenWithReserveAuctions[_id];
1201     }
1202 
1203     function updateReserveAuctionBidExtensionWindow(uint128 _reserveAuctionBidExtensionWindow) onlyAdmin public {
1204         reserveAuctionBidExtensionWindow = _reserveAuctionBidExtensionWindow;
1205         emit AdminUpdateReserveAuctionBidExtensionWindow(_reserveAuctionBidExtensionWindow);
1206     }
1207 
1208     function updateReserveAuctionLengthOnceReserveMet(uint128 _reserveAuctionLengthOnceReserveMet) onlyAdmin public {
1209         reserveAuctionLengthOnceReserveMet = _reserveAuctionLengthOnceReserveMet;
1210         emit AdminUpdateReserveAuctionLengthOnceReserveMet(_reserveAuctionLengthOnceReserveMet);
1211     }
1212 
1213     function _isReserveListingPermitted(uint256 _id) internal virtual returns (bool);
1214 
1215     function _hasReserveListingBeenInvalidated(uint256 _id) internal virtual returns (bool);
1216 
1217     function _removeReserveAuctionListing(uint256 _id) internal {
1218         ReserveAuction storage reserveAuction = editionOrTokenWithReserveAuctions[_id];
1219 
1220         require(reserveAuction.reservePrice > 0, "No active auction");
1221         require(reserveAuction.bid < reserveAuction.reservePrice, "Can only convert before reserve met");
1222         require(reserveAuction.seller == _msgSender(), "Only the seller can convert");
1223 
1224         // refund any bids
1225         if (reserveAuction.bid > 0) {
1226             _refundBidder(_id, reserveAuction.bidder, reserveAuction.bid, address(0), 0);
1227         }
1228 
1229         delete editionOrTokenWithReserveAuctions[_id];
1230     }
1231 }
1232 
1233 // File: contracts/marketplace/KODAV3PrimaryMarketplace.sol
1234 
1235 
1236 
1237 pragma solidity 0.8.4;
1238 
1239 
1240 
1241 
1242 
1243 
1244 
1245 /// @title KnownOrigin Primary Marketplace for all V3 tokens
1246 /// @notice The following listing types are supported: Buy now, Stepped, Reserve and Offers
1247 /// @dev The contract is pausable and has reentrancy guards
1248 /// @author KnownOrigin Labs
1249 contract KODAV3PrimaryMarketplace is
1250 IKODAV3PrimarySaleMarketplace,
1251 BaseMarketplace,
1252 ReserveAuctionMarketplace,
1253 BuyNowMarketplace {
1254 
1255     event PrimaryMarketplaceDeployed();
1256     event AdminSetKoCommissionOverrideForCreator(address indexed _creator, uint256 _koCommission);
1257     event AdminSetKoCommissionOverrideForEdition(uint256 indexed _editionId, uint256 _koCommission);
1258     event ConvertFromBuyNowToOffers(uint256 indexed _editionId, uint128 _startDate);
1259     event ConvertSteppedAuctionToBuyNow(uint256 indexed _editionId, uint128 _listingPrice, uint128 _startDate);
1260     event ReserveAuctionConvertedToOffers(uint256 indexed _editionId, uint128 _startDate);
1261 
1262     // KO Commission override definition for a given creator
1263     struct KOCommissionOverride {
1264         bool active;
1265         uint256 koCommission;
1266     }
1267 
1268     // Offer / Bid definition placed on an edition
1269     struct Offer {
1270         uint256 offer;
1271         address bidder;
1272         uint256 lockupUntil;
1273     }
1274 
1275     // Stepped auction definition
1276     struct Stepped {
1277         uint128 basePrice;
1278         uint128 stepPrice;
1279         uint128 startDate;
1280         address seller;
1281         uint16 currentStep;
1282     }
1283 
1284     /// @notice Edition ID -> KO commission override set by admin
1285     mapping(uint256 => KOCommissionOverride) public koCommissionOverrideForEditions;
1286 
1287     /// @notice primary sale creator -> KO commission override set by admin
1288     mapping(address => KOCommissionOverride) public koCommissionOverrideForCreators;
1289 
1290     /// @notice Edition ID to Offer mapping
1291     mapping(uint256 => Offer) public editionOffers;
1292 
1293     /// @notice Edition ID to StartDate
1294     mapping(uint256 => uint256) public editionOffersStartDate;
1295 
1296     /// @notice Edition ID to stepped auction
1297     mapping(uint256 => Stepped) public editionStep;
1298 
1299     /// @notice KO commission on every sale
1300     uint256 public platformPrimarySaleCommission = 15_00000;  // 15.00000%
1301 
1302     constructor(IKOAccessControlsLookup _accessControls, IKODAV3 _koda, address _platformAccount)
1303     BaseMarketplace(_accessControls, _koda, _platformAccount) {
1304         emit PrimaryMarketplaceDeployed();
1305     }
1306 
1307     // convert from a "buy now" listing and converting to "accepting offers" with an optional start date
1308     function convertFromBuyNowToOffers(uint256 _editionId, uint128 _startDate)
1309     public
1310     whenNotPaused {
1311         require(
1312             editionOrTokenListings[_editionId].seller == _msgSender()
1313             || accessControls.isVerifiedArtistProxy(editionOrTokenListings[_editionId].seller, _msgSender()),
1314             "Only seller can convert"
1315         );
1316 
1317         // clear listing
1318         delete editionOrTokenListings[_editionId];
1319 
1320         // set the start date for the offer (optional)
1321         editionOffersStartDate[_editionId] = _startDate;
1322 
1323         // Emit event
1324         emit ConvertFromBuyNowToOffers(_editionId, _startDate);
1325     }
1326 
1327     // Primary "offers" sale flow
1328 
1329     function enableEditionOffers(uint256 _editionId, uint128 _startDate)
1330     external
1331     override
1332     whenNotPaused
1333     onlyContract {
1334         // Set the start date if one supplied
1335         editionOffersStartDate[_editionId] = _startDate;
1336 
1337         // Emit event
1338         emit EditionAcceptingOffer(_editionId, _startDate);
1339     }
1340 
1341     function placeEditionBid(uint256 _editionId)
1342     public
1343     override
1344     payable
1345     whenNotPaused
1346     nonReentrant {
1347         _placeEditionBid(_editionId, _msgSender());
1348     }
1349 
1350     function placeEditionBidFor(uint256 _editionId, address _bidder)
1351     public
1352     override
1353     payable
1354     whenNotPaused
1355     nonReentrant {
1356         _placeEditionBid(_editionId, _bidder);
1357     }
1358 
1359     function withdrawEditionBid(uint256 _editionId)
1360     public
1361     override
1362     whenNotPaused
1363     nonReentrant {
1364         Offer storage offer = editionOffers[_editionId];
1365         require(offer.offer > 0, "No open bid");
1366         require(offer.bidder == _msgSender(), "Not the top bidder");
1367         require(block.timestamp >= offer.lockupUntil, "Bid lockup not elapsed");
1368 
1369         // send money back to top bidder
1370         _refundBidder(_editionId, offer.bidder, offer.offer, address(0), 0);
1371 
1372         // emit event
1373         emit EditionBidWithdrawn(_editionId, _msgSender());
1374 
1375         // delete offer
1376         delete editionOffers[_editionId];
1377     }
1378 
1379     function rejectEditionBid(uint256 _editionId)
1380     public
1381     override
1382     whenNotPaused
1383     nonReentrant {
1384         Offer storage offer = editionOffers[_editionId];
1385         require(offer.bidder != address(0), "No open bid");
1386 
1387         address creatorOfEdition = koda.getCreatorOfEdition(_editionId);
1388         require(
1389             creatorOfEdition == _msgSender()
1390             || accessControls.isVerifiedArtistProxy(creatorOfEdition, _msgSender()),
1391             "Caller not the creator"
1392         );
1393 
1394         // send money back to top bidder
1395         _refundBidder(_editionId, offer.bidder, offer.offer, address(0), 0);
1396 
1397         // emit event
1398         emit EditionBidRejected(_editionId, offer.bidder, offer.offer);
1399 
1400         // delete offer
1401         delete editionOffers[_editionId];
1402     }
1403 
1404     function acceptEditionBid(uint256 _editionId, uint256 _offerPrice)
1405     public
1406     override
1407     whenNotPaused
1408     nonReentrant {
1409         Offer storage offer = editionOffers[_editionId];
1410         require(offer.bidder != address(0), "No open bid");
1411         require(offer.offer >= _offerPrice, "Offer price has changed");
1412 
1413         address creatorOfEdition = koda.getCreatorOfEdition(_editionId);
1414         require(
1415             creatorOfEdition == _msgSender()
1416             || accessControls.isVerifiedArtistProxy(creatorOfEdition, _msgSender()),
1417             "Not creator"
1418         );
1419 
1420         // get a new token from the edition to transfer ownership
1421         uint256 tokenId = _facilitateNextPrimarySale(_editionId, offer.offer, offer.bidder, false);
1422 
1423         // emit event
1424         emit EditionBidAccepted(_editionId, tokenId, offer.bidder, offer.offer);
1425 
1426         // clear open offer
1427         delete editionOffers[_editionId];
1428     }
1429 
1430     // emergency admin "reject" button for stuck bids
1431     function adminRejectEditionBid(uint256 _editionId) public onlyAdmin nonReentrant {
1432         Offer storage offer = editionOffers[_editionId];
1433         require(offer.bidder != address(0), "No open bid");
1434 
1435         // send money back to top bidder
1436         if (offer.offer > 0) {
1437             _refundBidder(_editionId, offer.bidder, offer.offer, address(0), 0);
1438         }
1439 
1440         emit EditionBidRejected(_editionId, offer.bidder, offer.offer);
1441 
1442         // delete offer
1443         delete editionOffers[_editionId];
1444     }
1445 
1446     function convertOffersToBuyItNow(uint256 _editionId, uint128 _listingPrice, uint128 _startDate)
1447     public
1448     override
1449     whenNotPaused
1450     nonReentrant {
1451         require(!_isEditionListed(_editionId), "Edition is listed");
1452 
1453         address creatorOfEdition = koda.getCreatorOfEdition(_editionId);
1454         require(
1455             creatorOfEdition == _msgSender()
1456             || accessControls.isVerifiedArtistProxy(creatorOfEdition, _msgSender()),
1457             "Not creator"
1458         );
1459 
1460         require(_listingPrice >= minBidAmount, "Listing price not enough");
1461 
1462         // send money back to top bidder if existing offer found
1463         Offer storage offer = editionOffers[_editionId];
1464         if (offer.offer > 0) {
1465             _refundBidder(_editionId, offer.bidder, offer.offer, address(0), 0);
1466         }
1467 
1468         // delete offer
1469         delete editionOffers[_editionId];
1470 
1471         // delete rest of offer information
1472         delete editionOffersStartDate[_editionId];
1473 
1474         // Store listing data
1475         editionOrTokenListings[_editionId] = Listing(_listingPrice, _startDate, _msgSender());
1476 
1477         emit EditionConvertedFromOffersToBuyItNow(_editionId, _listingPrice, _startDate);
1478     }
1479 
1480     // Primary sale "stepped pricing" flow
1481     function listSteppedEditionAuction(address _creator, uint256 _editionId, uint128 _basePrice, uint128 _stepPrice, uint128 _startDate)
1482     public
1483     override
1484     whenNotPaused
1485     onlyContract {
1486         require(_basePrice >= minBidAmount, "Base price not enough");
1487 
1488         // Store listing data
1489         editionStep[_editionId] = Stepped(
1490             _basePrice,
1491             _stepPrice,
1492             _startDate,
1493             _creator,
1494             uint16(0)
1495         );
1496 
1497         emit EditionSteppedSaleListed(_editionId, _basePrice, _stepPrice, _startDate);
1498     }
1499 
1500     function updateSteppedAuction(uint256 _editionId, uint128 _basePrice, uint128 _stepPrice)
1501     public
1502     override
1503     whenNotPaused {
1504         Stepped storage steppedAuction = editionStep[_editionId];
1505 
1506         require(
1507             steppedAuction.seller == _msgSender()
1508             || accessControls.isVerifiedArtistProxy(steppedAuction.seller, _msgSender()),
1509             "Only seller"
1510         );
1511 
1512         require(steppedAuction.currentStep == 0, "Only when no sales");
1513         require(_basePrice >= minBidAmount, "Base price not enough");
1514 
1515         steppedAuction.basePrice = _basePrice;
1516         steppedAuction.stepPrice = _stepPrice;
1517 
1518         emit EditionSteppedAuctionUpdated(_editionId, _basePrice, _stepPrice);
1519     }
1520 
1521     function buyNextStep(uint256 _editionId)
1522     public
1523     override
1524     payable
1525     whenNotPaused
1526     nonReentrant {
1527         _buyNextStep(_editionId, _msgSender());
1528     }
1529 
1530     function buyNextStepFor(uint256 _editionId, address _buyer)
1531     public
1532     override
1533     payable
1534     whenNotPaused
1535     nonReentrant {
1536         _buyNextStep(_editionId, _buyer);
1537     }
1538 
1539     function _buyNextStep(uint256 _editionId, address _buyer) internal {
1540         Stepped storage steppedAuction = editionStep[_editionId];
1541         require(steppedAuction.seller != address(0), "Edition not listed for stepped auction");
1542         require(steppedAuction.startDate <= block.timestamp, "Not started yet");
1543 
1544         uint256 expectedPrice = _getNextEditionSteppedPrice(_editionId);
1545         require(msg.value >= expectedPrice, "Expected price not met");
1546 
1547         uint256 tokenId = _facilitateNextPrimarySale(_editionId, expectedPrice, _buyer, true);
1548 
1549         // Bump the current step
1550         uint16 step = steppedAuction.currentStep;
1551 
1552         // no safemath for uint16
1553         steppedAuction.currentStep = step + 1;
1554 
1555         // send back excess if supplied - will allow UX flow of setting max price to pay
1556         if (msg.value > expectedPrice) {
1557             (bool success,) = _msgSender().call{value : msg.value - expectedPrice}("");
1558             require(success, "failed to send overspend back");
1559         }
1560 
1561         emit EditionSteppedSaleBuy(_editionId, tokenId, _buyer, expectedPrice, step);
1562     }
1563 
1564     // creates an exit from a step if required but forces a buy now price
1565     function convertSteppedAuctionToListing(uint256 _editionId, uint128 _listingPrice, uint128 _startDate)
1566     public
1567     override
1568     nonReentrant
1569     whenNotPaused {
1570         Stepped storage steppedAuction = editionStep[_editionId];
1571         require(_listingPrice >= minBidAmount, "List price not enough");
1572 
1573         require(
1574             steppedAuction.seller == _msgSender()
1575             || accessControls.isVerifiedArtistProxy(steppedAuction.seller, _msgSender()),
1576             "Only seller can convert"
1577         );
1578 
1579         // Store listing data
1580         editionOrTokenListings[_editionId] = Listing(_listingPrice, _startDate, steppedAuction.seller);
1581 
1582         // emit event
1583         emit ConvertSteppedAuctionToBuyNow(_editionId, _listingPrice, _startDate);
1584 
1585         // Clear up the step logic
1586         delete editionStep[_editionId];
1587     }
1588 
1589     function convertSteppedAuctionToOffers(uint256 _editionId, uint128 _startDate)
1590     public
1591     override
1592     whenNotPaused {
1593         Stepped storage steppedAuction = editionStep[_editionId];
1594 
1595         require(
1596             steppedAuction.seller == _msgSender()
1597             || accessControls.isVerifiedArtistProxy(steppedAuction.seller, _msgSender()),
1598             "Only seller can convert"
1599         );
1600 
1601         // set the start date for the offer (optional)
1602         editionOffersStartDate[_editionId] = _startDate;
1603 
1604         // Clear up the step logic
1605         delete editionStep[_editionId];
1606 
1607         emit ConvertFromBuyNowToOffers(_editionId, _startDate);
1608     }
1609 
1610     // Get the next
1611     function getNextEditionSteppedPrice(uint256 _editionId) public view returns (uint256 price) {
1612         price = _getNextEditionSteppedPrice(_editionId);
1613     }
1614 
1615     function _getNextEditionSteppedPrice(uint256 _editionId) internal view returns (uint256 price) {
1616         Stepped storage steppedAuction = editionStep[_editionId];
1617         uint256 stepAmount = uint256(steppedAuction.stepPrice) * uint256(steppedAuction.currentStep);
1618         price = uint256(steppedAuction.basePrice) + stepAmount;
1619     }
1620 
1621     function convertReserveAuctionToBuyItNow(uint256 _editionId, uint128 _listingPrice, uint128 _startDate)
1622     public
1623     override
1624     whenNotPaused
1625     nonReentrant {
1626         require(_listingPrice >= minBidAmount, "Listing price not enough");
1627         _removeReserveAuctionListing(_editionId);
1628 
1629         editionOrTokenListings[_editionId] = Listing(_listingPrice, _startDate, _msgSender());
1630 
1631         emit ReserveAuctionConvertedToBuyItNow(_editionId, _listingPrice, _startDate);
1632     }
1633 
1634     function convertReserveAuctionToOffers(uint256 _editionId, uint128 _startDate)
1635     public
1636     override
1637     whenNotPaused
1638     nonReentrant {
1639         _removeReserveAuctionListing(_editionId);
1640 
1641         // set the start date for the offer (optional)
1642         editionOffersStartDate[_editionId] = _startDate;
1643 
1644         emit ReserveAuctionConvertedToOffers(_editionId, _startDate);
1645     }
1646 
1647     // admin
1648 
1649     function updatePlatformPrimarySaleCommission(uint256 _platformPrimarySaleCommission) public onlyAdmin {
1650         platformPrimarySaleCommission = _platformPrimarySaleCommission;
1651         emit AdminUpdatePlatformPrimarySaleCommission(_platformPrimarySaleCommission);
1652     }
1653 
1654     function setKoCommissionOverrideForCreator(address _creator, bool _active, uint256 _koCommission) public onlyAdmin {
1655         KOCommissionOverride storage koCommissionOverride = koCommissionOverrideForCreators[_creator];
1656         koCommissionOverride.active = _active;
1657         koCommissionOverride.koCommission = _koCommission;
1658 
1659         emit AdminSetKoCommissionOverrideForCreator(_creator, _koCommission);
1660     }
1661 
1662     function setKoCommissionOverrideForEdition(uint256 _editionId, bool _active, uint256 _koCommission) public onlyAdmin {
1663         KOCommissionOverride storage koCommissionOverride = koCommissionOverrideForEditions[_editionId];
1664         koCommissionOverride.active = _active;
1665         koCommissionOverride.koCommission = _koCommission;
1666 
1667         emit AdminSetKoCommissionOverrideForEdition(_editionId, _koCommission);
1668     }
1669 
1670     // internal
1671 
1672     function _isListingPermitted(uint256 _editionId) internal view override returns (bool) {
1673         return !_isEditionListed(_editionId);
1674     }
1675 
1676     function _isReserveListingPermitted(uint256 _editionId) internal view override returns (bool) {
1677         return koda.getSizeOfEdition(_editionId) == 1 && accessControls.hasContractRole(_msgSender());
1678     }
1679 
1680     function _hasReserveListingBeenInvalidated(uint256 _id) internal view override returns (bool) {
1681         bool isApprovalActiveForMarketplace = koda.isApprovedForAll(
1682             editionOrTokenWithReserveAuctions[_id].seller,
1683             address(this)
1684         );
1685 
1686         return !isApprovalActiveForMarketplace || koda.isSalesDisabledOrSoldOut(_id);
1687     }
1688 
1689     function _isBuyNowListingPermitted(uint256) internal view override returns (bool) {
1690         return accessControls.hasContractRole(_msgSender());
1691     }
1692 
1693     function _processSale(uint256 _id, uint256 _paymentAmount, address _buyer, address) internal override returns (uint256) {
1694         return _facilitateNextPrimarySale(_id, _paymentAmount, _buyer, false);
1695     }
1696 
1697     function _facilitateNextPrimarySale(uint256 _editionId, uint256 _paymentAmount, address _buyer, bool _reverse) internal returns (uint256) {
1698         // for stepped sales, should they be sold in reverse order ie. 10...1 and not 1...10?
1699         // get next token to sell along with the royalties recipient and the original creator
1700         (address receiver, address creator, uint256 tokenId) = _reverse
1701         ? koda.facilitateReversePrimarySale(_editionId)
1702         : koda.facilitateNextPrimarySale(_editionId);
1703 
1704         // split money
1705         _handleEditionSaleFunds(_editionId, creator, receiver, _paymentAmount);
1706 
1707         // send token to buyer (assumes approval has been made, if not then this will fail)
1708         koda.safeTransferFrom(creator, _buyer, tokenId);
1709 
1710         // N:B. open offers are left once sold out for the bidder to withdraw or the artist to reject
1711 
1712         return tokenId;
1713     }
1714 
1715     function _handleEditionSaleFunds(uint256 _editionId, address _creator, address _receiver, uint256 _paymentAmount) internal {
1716         uint256 primarySaleCommission;
1717 
1718         if (koCommissionOverrideForEditions[_editionId].active) {
1719             primarySaleCommission = koCommissionOverrideForEditions[_editionId].koCommission;
1720         }
1721         else if (koCommissionOverrideForCreators[_creator].active) {
1722             primarySaleCommission = koCommissionOverrideForCreators[_creator].koCommission;
1723         }
1724         else {
1725             primarySaleCommission = platformPrimarySaleCommission;
1726         }
1727 
1728         uint256 koCommission = (_paymentAmount / modulo) * primarySaleCommission;
1729         if (koCommission > 0) {
1730             (bool koCommissionSuccess,) = platformAccount.call{value : koCommission}("");
1731             require(koCommissionSuccess, "Edition commission payment failed");
1732         }
1733 
1734         (bool success,) = _receiver.call{value : _paymentAmount - koCommission}("");
1735         require(success, "Edition payment failed");
1736     }
1737 
1738     // as offers are always possible, we wont count it as a listing
1739     function _isEditionListed(uint256 _editionId) internal view returns (bool) {
1740         if (editionOrTokenListings[_editionId].seller != address(0)) {
1741             return true;
1742         }
1743 
1744         if (editionStep[_editionId].seller != address(0)) {
1745             return true;
1746         }
1747 
1748         if (editionOrTokenWithReserveAuctions[_editionId].seller != address(0)) {
1749             return true;
1750         }
1751 
1752         return false;
1753     }
1754 
1755     function _placeEditionBid(uint256 _editionId, address _bidder) internal {
1756         require(!_isEditionListed(_editionId), "Edition is listed");
1757 
1758         Offer storage offer = editionOffers[_editionId];
1759         require(msg.value >= offer.offer + minBidAmount, "Bid not high enough");
1760 
1761         // Honor start date if set
1762         uint256 startDate = editionOffersStartDate[_editionId];
1763         if (startDate > 0) {
1764             require(block.timestamp >= startDate, "Not yet accepting offers");
1765 
1766             // elapsed, so free storage
1767             delete editionOffersStartDate[_editionId];
1768         }
1769 
1770         // send money back to top bidder if existing offer found
1771         if (offer.offer > 0) {
1772             _refundBidder(_editionId, offer.bidder, offer.offer, _msgSender(), msg.value);
1773         }
1774 
1775         // setup offer
1776         editionOffers[_editionId] = Offer(msg.value, _bidder, _getLockupTime());
1777 
1778         emit EditionBidPlaced(_editionId, _bidder, msg.value);
1779     }
1780 }