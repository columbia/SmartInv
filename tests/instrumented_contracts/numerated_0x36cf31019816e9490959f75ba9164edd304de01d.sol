1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 // File: contracts/core/IKODAV3Minter.sol
28 
29 
30 
31 pragma solidity 0.8.4;
32 
33 interface IKODAV3Minter {
34 
35     function mintBatchEdition(uint16 _editionSize, address _to, string calldata _uri) external returns (uint256 _editionId);
36 
37     function mintBatchEditionAndComposeERC20s(uint16 _editionSize, address _to, string calldata _uri, address[] calldata _erc20s, uint256[] calldata _amounts) external returns (uint256 _editionId);
38 
39     function mintConsecutiveBatchEdition(uint16 _editionSize, address _to, string calldata _uri) external returns (uint256 _editionId);
40 }
41 
42 // File: contracts/access/IKOAccessControlsLookup.sol
43 
44 
45 
46 pragma solidity 0.8.4;
47 
48 interface IKOAccessControlsLookup {
49     function hasAdminRole(address _address) external view returns (bool);
50 
51     function isVerifiedArtist(uint256 _index, address _account, bytes32[] calldata _merkleProof) external view returns (bool);
52 
53     function isVerifiedArtistProxy(address _artist, address _proxy) external view returns (bool);
54 
55     function hasLegacyMinterRole(address _address) external view returns (bool);
56 
57     function hasContractRole(address _address) external view returns (bool);
58 
59     function hasContractOrAdminRole(address _address) external view returns (bool);
60 }
61 
62 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
63 
64 
65 
66 pragma solidity ^0.8.0;
67 
68 /**
69  * @dev Interface of the ERC165 standard, as defined in the
70  * https://eips.ethereum.org/EIPS/eip-165[EIP].
71  *
72  * Implementers can declare support of contract interfaces, which can then be
73  * queried by others ({ERC165Checker}).
74  *
75  * For an implementation, see {ERC165}.
76  */
77 interface IERC165 {
78     /**
79      * @dev Returns true if this contract implements the interface defined by
80      * `interfaceId`. See the corresponding
81      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
82      * to learn more about how these ids are created.
83      *
84      * This function call must use less than 30 000 gas.
85      */
86     function supportsInterface(bytes4 interfaceId) external view returns (bool);
87 }
88 
89 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
90 
91 
92 
93 pragma solidity ^0.8.0;
94 
95 
96 /**
97  * @dev Required interface of an ERC721 compliant contract.
98  */
99 interface IERC721 is IERC165 {
100     /**
101      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
102      */
103     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
104 
105     /**
106      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
107      */
108     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
109 
110     /**
111      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
112      */
113     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
114 
115     /**
116      * @dev Returns the number of tokens in ``owner``'s account.
117      */
118     function balanceOf(address owner) external view returns (uint256 balance);
119 
120     /**
121      * @dev Returns the owner of the `tokenId` token.
122      *
123      * Requirements:
124      *
125      * - `tokenId` must exist.
126      */
127     function ownerOf(uint256 tokenId) external view returns (address owner);
128 
129     /**
130      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
131      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
132      *
133      * Requirements:
134      *
135      * - `from` cannot be the zero address.
136      * - `to` cannot be the zero address.
137      * - `tokenId` token must exist and be owned by `from`.
138      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
139      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
140      *
141      * Emits a {Transfer} event.
142      */
143     function safeTransferFrom(
144         address from,
145         address to,
146         uint256 tokenId
147     ) external;
148 
149     /**
150      * @dev Transfers `tokenId` token from `from` to `to`.
151      *
152      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
153      *
154      * Requirements:
155      *
156      * - `from` cannot be the zero address.
157      * - `to` cannot be the zero address.
158      * - `tokenId` token must be owned by `from`.
159      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
160      *
161      * Emits a {Transfer} event.
162      */
163     function transferFrom(
164         address from,
165         address to,
166         uint256 tokenId
167     ) external;
168 
169     /**
170      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
171      * The approval is cleared when the token is transferred.
172      *
173      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
174      *
175      * Requirements:
176      *
177      * - The caller must own the token or be an approved operator.
178      * - `tokenId` must exist.
179      *
180      * Emits an {Approval} event.
181      */
182     function approve(address to, uint256 tokenId) external;
183 
184     /**
185      * @dev Returns the account approved for `tokenId` token.
186      *
187      * Requirements:
188      *
189      * - `tokenId` must exist.
190      */
191     function getApproved(uint256 tokenId) external view returns (address operator);
192 
193     /**
194      * @dev Approve or remove `operator` as an operator for the caller.
195      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
196      *
197      * Requirements:
198      *
199      * - The `operator` cannot be the caller.
200      *
201      * Emits an {ApprovalForAll} event.
202      */
203     function setApprovalForAll(address operator, bool _approved) external;
204 
205     /**
206      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
207      *
208      * See {setApprovalForAll}
209      */
210     function isApprovedForAll(address owner, address operator) external view returns (bool);
211 
212     /**
213      * @dev Safely transfers `tokenId` token from `from` to `to`.
214      *
215      * Requirements:
216      *
217      * - `from` cannot be the zero address.
218      * - `to` cannot be the zero address.
219      * - `tokenId` token must exist and be owned by `from`.
220      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
221      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
222      *
223      * Emits a {Transfer} event.
224      */
225     function safeTransferFrom(
226         address from,
227         address to,
228         uint256 tokenId,
229         bytes calldata data
230     ) external;
231 }
232 
233 // File: contracts/core/IERC2309.sol
234 
235 
236 
237 pragma solidity 0.8.4;
238 
239 /**
240   @title ERC-2309: ERC-721 Batch Mint Extension
241   @dev https://github.com/ethereum/EIPs/issues/2309
242  */
243 interface IERC2309 {
244     /**
245       @notice This event is emitted when ownership of a batch of tokens changes by any mechanism.
246       This includes minting, transferring, and burning.
247 
248       @dev The address executing the transaction MUST own all the tokens within the range of
249       fromTokenId and toTokenId, or MUST be an approved operator to act on the owners behalf.
250       The fromTokenId and toTokenId MUST be a sequential range of tokens IDs.
251       When minting/creating tokens, the `fromAddress` argument MUST be set to `0x0` (i.e. zero address).
252       When burning/destroying tokens, the `toAddress` argument MUST be set to `0x0` (i.e. zero address).
253 
254       @param fromTokenId The token ID that begins the batch of tokens being transferred
255       @param toTokenId The token ID that ends the batch of tokens being transferred
256       @param fromAddress The address transferring ownership of the specified range of tokens
257       @param toAddress The address receiving ownership of the specified range of tokens.
258     */
259     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed fromAddress, address indexed toAddress);
260 }
261 
262 // File: contracts/core/IERC2981.sol
263 
264 
265 
266 pragma solidity 0.8.4;
267 
268 
269 /// @notice This is purely an extension for the KO platform
270 /// @notice Royalties on KO are defined at an edition level for all tokens from the same edition
271 interface IERC2981EditionExtension {
272 
273     /// @notice Does the edition have any royalties defined
274     function hasRoyalties(uint256 _editionId) external view returns (bool);
275 
276     /// @notice Get the royalty receiver - all royalties should be sent to this account if not zero address
277     function getRoyaltiesReceiver(uint256 _editionId) external view returns (address);
278 }
279 
280 /**
281  * ERC2981 standards interface for royalties
282  */
283 interface IERC2981 is IERC165, IERC2981EditionExtension {
284     /// ERC165 bytes to add to interface array - set in parent contract
285     /// implementing this standard
286     ///
287     /// bytes4(keccak256("royaltyInfo(uint256,uint256)")) == 0x2a55205a
288     /// bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
289     /// _registerInterface(_INTERFACE_ID_ERC2981);
290 
291     /// @notice Called with the sale price to determine how much royalty
292     //          is owed and to whom.
293     /// @param _tokenId - the NFT asset queried for royalty information
294     /// @param _value - the sale price of the NFT asset specified by _tokenId
295     /// @return _receiver - address of who should be sent the royalty payment
296     /// @return _royaltyAmount - the royalty payment amount for _value sale price
297     function royaltyInfo(
298         uint256 _tokenId,
299         uint256 _value
300     ) external view returns (
301         address _receiver,
302         uint256 _royaltyAmount
303     );
304 
305 }
306 
307 // File: contracts/core/IHasSecondarySaleFees.sol
308 
309 
310 
311 pragma solidity 0.8.4;
312 
313 
314 /// @title Royalties formats required for use on the Rarible platform
315 /// @dev https://docs.rarible.com/asset/royalties-schema
316 interface IHasSecondarySaleFees is IERC165 {
317 
318     event SecondarySaleFees(uint256 tokenId, address[] recipients, uint[] bps);
319 
320     function getFeeRecipients(uint256 id) external returns (address payable[] memory);
321 
322     function getFeeBps(uint256 id) external returns (uint[] memory);
323 }
324 
325 // File: contracts/core/IKODAV3.sol
326 
327 
328 
329 pragma solidity 0.8.4;
330 
331 
332 
333 
334 
335 
336 /// @title Core KODA V3 functionality
337 interface IKODAV3 is
338 IERC165, // Contract introspection
339 IERC721, // Core NFTs
340 IERC2309, // Consecutive batch mint
341 IERC2981, // Royalties
342 IHasSecondarySaleFees // Rariable / Foundation royalties
343 {
344     // edition utils
345 
346     function getCreatorOfEdition(uint256 _editionId) external view returns (address _originalCreator);
347 
348     function getCreatorOfToken(uint256 _tokenId) external view returns (address _originalCreator);
349 
350     function getSizeOfEdition(uint256 _editionId) external view returns (uint256 _size);
351 
352     function getEditionSizeOfToken(uint256 _tokenId) external view returns (uint256 _size);
353 
354     function editionExists(uint256 _editionId) external view returns (bool);
355 
356     // Has the edition been disabled / soft burnt
357     function isEditionSalesDisabled(uint256 _editionId) external view returns (bool);
358 
359     // Has the edition been disabled / soft burnt OR sold out
360     function isSalesDisabledOrSoldOut(uint256 _editionId) external view returns (bool);
361 
362     // Work out the max token ID for an edition ID
363     function maxTokenIdOfEdition(uint256 _editionId) external view returns (uint256 _tokenId);
364 
365     // Helper method for getting the next primary sale token from an edition starting low to high token IDs
366     function getNextAvailablePrimarySaleToken(uint256 _editionId) external returns (uint256 _tokenId);
367 
368     // Helper method for getting the next primary sale token from an edition starting high to low token IDs
369     function getReverseAvailablePrimarySaleToken(uint256 _editionId) external view returns (uint256 _tokenId);
370 
371     // Utility method to get all data needed for the next primary sale, low token ID to high
372     function facilitateNextPrimarySale(uint256 _editionId) external returns (address _receiver, address _creator, uint256 _tokenId);
373 
374     // Utility method to get all data needed for the next primary sale, high token ID to low
375     function facilitateReversePrimarySale(uint256 _editionId) external returns (address _receiver, address _creator, uint256 _tokenId);
376 
377     // Expanded royalty method for the edition, not token
378     function royaltyAndCreatorInfo(uint256 _editionId, uint256 _value) external returns (address _receiver, address _creator, uint256 _amount);
379 
380     // Allows the creator to correct mistakes until the first token from an edition is sold
381     function updateURIIfNoSaleMade(uint256 _editionId, string calldata _newURI) external;
382 
383     // Has any primary transfer happened from an edition
384     function hasMadePrimarySale(uint256 _editionId) external view returns (bool);
385 
386     // Has the edition sold out
387     function isEditionSoldOut(uint256 _editionId) external view returns (bool);
388 
389     // Toggle on/off the edition from being able to make sales
390     function toggleEditionSalesDisabled(uint256 _editionId) external;
391 
392     // token utils
393 
394     function exists(uint256 _tokenId) external view returns (bool);
395 
396     function getEditionIdOfToken(uint256 _tokenId) external pure returns (uint256 _editionId);
397 
398     function getEditionDetails(uint256 _tokenId) external view returns (address _originalCreator, address _owner, uint16 _size, uint256 _editionId, string memory _uri);
399 
400     function hadPrimarySaleOfToken(uint256 _tokenId) external view returns (bool);
401 
402 }
403 
404 // File: contracts/marketplace/IKODAV3Marketplace.sol
405 
406 
407 pragma solidity 0.8.4;
408 
409 interface IBuyNowMarketplace {
410     event ListedForBuyNow(uint256 indexed _id, uint256 _price, address _currentOwner, uint256 _startDate);
411     event BuyNowPriceChanged(uint256 indexed _id, uint256 _price);
412     event BuyNowDeListed(uint256 indexed _id);
413     event BuyNowPurchased(uint256 indexed _tokenId, address _buyer, address _currentOwner, uint256 _price);
414 
415     function listForBuyNow(address _creator, uint256 _id, uint128 _listingPrice, uint128 _startDate) external;
416 
417     function buyEditionToken(uint256 _id) external payable;
418     function buyEditionTokenFor(uint256 _id, address _recipient) external payable;
419 
420     function setBuyNowPriceListing(uint256 _editionId, uint128 _listingPrice) external;
421 }
422 
423 interface IEditionOffersMarketplace {
424     event EditionAcceptingOffer(uint256 indexed _editionId, uint128 _startDate);
425     event EditionBidPlaced(uint256 indexed _editionId, address _bidder, uint256 _amount);
426     event EditionBidWithdrawn(uint256 indexed _editionId, address _bidder);
427     event EditionBidAccepted(uint256 indexed _editionId, uint256 indexed _tokenId, address _bidder, uint256 _amount);
428     event EditionBidRejected(uint256 indexed _editionId, address _bidder, uint256 _amount);
429     event EditionConvertedFromOffersToBuyItNow(uint256 _editionId, uint128 _price, uint128 _startDate);
430 
431     function enableEditionOffers(uint256 _editionId, uint128 _startDate) external;
432 
433     function placeEditionBid(uint256 _editionId) external payable;
434     function placeEditionBidFor(uint256 _editionId, address _bidder) external payable;
435 
436     function withdrawEditionBid(uint256 _editionId) external;
437 
438     function rejectEditionBid(uint256 _editionId) external;
439 
440     function acceptEditionBid(uint256 _editionId, uint256 _offerPrice) external;
441 
442     function convertOffersToBuyItNow(uint256 _editionId, uint128 _listingPrice, uint128 _startDate) external;
443 }
444 
445 interface IEditionSteppedMarketplace {
446     event EditionSteppedSaleListed(uint256 indexed _editionId, uint128 _basePrice, uint128 _stepPrice, uint128 _startDate);
447     event EditionSteppedSaleBuy(uint256 indexed _editionId, uint256 indexed _tokenId, address _buyer, uint256 _price, uint16 _currentStep);
448     event EditionSteppedAuctionUpdated(uint256 indexed _editionId, uint128 _basePrice, uint128 _stepPrice);
449 
450     function listSteppedEditionAuction(address _creator, uint256 _editionId, uint128 _basePrice, uint128 _stepPrice, uint128 _startDate) external;
451 
452     function buyNextStep(uint256 _editionId) external payable;
453     function buyNextStepFor(uint256 _editionId, address _buyer) external payable;
454 
455     function convertSteppedAuctionToListing(uint256 _editionId, uint128 _listingPrice, uint128 _startDate) external;
456 
457     function convertSteppedAuctionToOffers(uint256 _editionId, uint128 _startDate) external;
458 
459     function updateSteppedAuction(uint256 _editionId, uint128 _basePrice, uint128 _stepPrice) external;
460 }
461 
462 interface IReserveAuctionMarketplace {
463     event ListedForReserveAuction(uint256 indexed _id, uint256 _reservePrice, uint128 _startDate);
464     event BidPlacedOnReserveAuction(uint256 indexed _id, address _currentOwner, address _bidder, uint256 _amount, uint256 _originalBiddingEnd, uint256 _currentBiddingEnd);
465     event ReserveAuctionResulted(uint256 indexed _id, uint256 _finalPrice, address _currentOwner, address _winner, address _resulter);
466     event BidWithdrawnFromReserveAuction(uint256 _id, address _bidder, uint128 _bid);
467     event ReservePriceUpdated(uint256 indexed _id, uint256 _reservePrice);
468     event ReserveAuctionConvertedToBuyItNow(uint256 indexed _id, uint128 _listingPrice, uint128 _startDate);
469     event EmergencyBidWithdrawFromReserveAuction(uint256 indexed _id, address _bidder, uint128 _bid);
470 
471     function placeBidOnReserveAuction(uint256 _id) external payable;
472     function placeBidOnReserveAuctionFor(uint256 _id, address _bidder) external payable;
473 
474     function listForReserveAuction(address _creator, uint256 _id, uint128 _reservePrice, uint128 _startDate) external;
475 
476     function resultReserveAuction(uint256 _id) external;
477 
478     function withdrawBidFromReserveAuction(uint256 _id) external;
479 
480     function updateReservePriceForReserveAuction(uint256 _id, uint128 _reservePrice) external;
481 
482     function emergencyExitBidFromReserveAuction(uint256 _id) external;
483 }
484 
485 interface IKODAV3PrimarySaleMarketplace is IEditionSteppedMarketplace, IEditionOffersMarketplace, IBuyNowMarketplace, IReserveAuctionMarketplace {
486     function convertReserveAuctionToBuyItNow(uint256 _editionId, uint128 _listingPrice, uint128 _startDate) external;
487 
488     function convertReserveAuctionToOffers(uint256 _editionId, uint128 _startDate) external;
489 }
490 
491 interface ITokenBuyNowMarketplace {
492     event TokenDeListed(uint256 indexed _tokenId);
493 
494     function delistToken(uint256 _tokenId) external;
495 }
496 
497 interface ITokenOffersMarketplace {
498     event TokenBidPlaced(uint256 indexed _tokenId, address _currentOwner, address _bidder, uint256 _amount);
499     event TokenBidAccepted(uint256 indexed _tokenId, address _currentOwner, address _bidder, uint256 _amount);
500     event TokenBidRejected(uint256 indexed _tokenId, address _currentOwner, address _bidder, uint256 _amount);
501     event TokenBidWithdrawn(uint256 indexed _tokenId, address _bidder);
502 
503     function acceptTokenBid(uint256 _tokenId, uint256 _offerPrice) external;
504 
505     function rejectTokenBid(uint256 _tokenId) external;
506 
507     function withdrawTokenBid(uint256 _tokenId) external;
508 
509     function placeTokenBid(uint256 _tokenId) external payable;
510     function placeTokenBidFor(uint256 _tokenId, address _bidder) external payable;
511 }
512 
513 interface IBuyNowSecondaryMarketplace {
514     function listTokenForBuyNow(uint256 _tokenId, uint128 _listingPrice, uint128 _startDate) external;
515 }
516 
517 interface IEditionOffersSecondaryMarketplace {
518     event EditionBidPlaced(uint256 indexed _editionId, address indexed _bidder, uint256 _bid);
519     event EditionBidWithdrawn(uint256 indexed _editionId, address _bidder);
520     event EditionBidAccepted(uint256 indexed _tokenId, address _currentOwner, address _bidder, uint256 _amount);
521 
522     function placeEditionBid(uint256 _editionId) external payable;
523     function placeEditionBidFor(uint256 _editionId, address _bidder) external payable;
524 
525     function withdrawEditionBid(uint256 _editionId) external;
526 
527     function acceptEditionBid(uint256 _tokenId, uint256 _offerPrice) external;
528 }
529 
530 interface IKODAV3SecondarySaleMarketplace is ITokenBuyNowMarketplace, ITokenOffersMarketplace, IEditionOffersSecondaryMarketplace, IBuyNowSecondaryMarketplace {
531     function convertReserveAuctionToBuyItNow(uint256 _tokenId, uint128 _listingPrice, uint128 _startDate) external;
532 
533     function convertReserveAuctionToOffers(uint256 _tokenId) external;
534 }
535 
536 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
537 
538 
539 
540 pragma solidity ^0.8.0;
541 
542 /**
543  * @dev Contract module that helps prevent reentrant calls to a function.
544  *
545  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
546  * available, which can be applied to functions to make sure there are no nested
547  * (reentrant) calls to them.
548  *
549  * Note that because there is a single `nonReentrant` guard, functions marked as
550  * `nonReentrant` may not call one another. This can be worked around by making
551  * those functions `private`, and then adding `external` `nonReentrant` entry
552  * points to them.
553  *
554  * TIP: If you would like to learn more about reentrancy and alternative ways
555  * to protect against it, check out our blog post
556  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
557  */
558 abstract contract ReentrancyGuard {
559     // Booleans are more expensive than uint256 or any type that takes up a full
560     // word because each write operation emits an extra SLOAD to first read the
561     // slot's contents, replace the bits taken up by the boolean, and then write
562     // back. This is the compiler's defense against contract upgrades and
563     // pointer aliasing, and it cannot be disabled.
564 
565     // The values being non-zero value makes deployment a bit more expensive,
566     // but in exchange the refund on every call to nonReentrant will be lower in
567     // amount. Since refunds are capped to a percentage of the total
568     // transaction's gas, it is best to keep them low in cases like this one, to
569     // increase the likelihood of the full refund coming into effect.
570     uint256 private constant _NOT_ENTERED = 1;
571     uint256 private constant _ENTERED = 2;
572 
573     uint256 private _status;
574 
575     constructor() {
576         _status = _NOT_ENTERED;
577     }
578 
579     /**
580      * @dev Prevents a contract from calling itself, directly or indirectly.
581      * Calling a `nonReentrant` function from another `nonReentrant`
582      * function is not supported. It is possible to prevent this from happening
583      * by making the `nonReentrant` function external, and make it call a
584      * `private` function that does the actual work.
585      */
586     modifier nonReentrant() {
587         // On the first call to nonReentrant, _notEntered will be true
588         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
589 
590         // Any calls to nonReentrant after this point will fail
591         _status = _ENTERED;
592 
593         _;
594 
595         // By storing the original value once again, a refund is triggered (see
596         // https://eips.ethereum.org/EIPS/eip-2200)
597         _status = _NOT_ENTERED;
598     }
599 }
600 
601 // File: @openzeppelin/contracts/security/Pausable.sol
602 
603 
604 
605 pragma solidity ^0.8.0;
606 
607 
608 /**
609  * @dev Contract module which allows children to implement an emergency stop
610  * mechanism that can be triggered by an authorized account.
611  *
612  * This module is used through inheritance. It will make available the
613  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
614  * the functions of your contract. Note that they will not be pausable by
615  * simply including this module, only once the modifiers are put in place.
616  */
617 abstract contract Pausable is Context {
618     /**
619      * @dev Emitted when the pause is triggered by `account`.
620      */
621     event Paused(address account);
622 
623     /**
624      * @dev Emitted when the pause is lifted by `account`.
625      */
626     event Unpaused(address account);
627 
628     bool private _paused;
629 
630     /**
631      * @dev Initializes the contract in unpaused state.
632      */
633     constructor() {
634         _paused = false;
635     }
636 
637     /**
638      * @dev Returns true if the contract is paused, and false otherwise.
639      */
640     function paused() public view virtual returns (bool) {
641         return _paused;
642     }
643 
644     /**
645      * @dev Modifier to make a function callable only when the contract is not paused.
646      *
647      * Requirements:
648      *
649      * - The contract must not be paused.
650      */
651     modifier whenNotPaused() {
652         require(!paused(), "Pausable: paused");
653         _;
654     }
655 
656     /**
657      * @dev Modifier to make a function callable only when the contract is paused.
658      *
659      * Requirements:
660      *
661      * - The contract must be paused.
662      */
663     modifier whenPaused() {
664         require(paused(), "Pausable: not paused");
665         _;
666     }
667 
668     /**
669      * @dev Triggers stopped state.
670      *
671      * Requirements:
672      *
673      * - The contract must not be paused.
674      */
675     function _pause() internal virtual whenNotPaused {
676         _paused = true;
677         emit Paused(_msgSender());
678     }
679 
680     /**
681      * @dev Returns to normal state.
682      *
683      * Requirements:
684      *
685      * - The contract must be paused.
686      */
687     function _unpause() internal virtual whenPaused {
688         _paused = false;
689         emit Unpaused(_msgSender());
690     }
691 }
692 
693 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
694 
695 
696 
697 pragma solidity ^0.8.0;
698 
699 /**
700  * @dev Interface of the ERC20 standard as defined in the EIP.
701  */
702 interface IERC20 {
703     /**
704      * @dev Returns the amount of tokens in existence.
705      */
706     function totalSupply() external view returns (uint256);
707 
708     /**
709      * @dev Returns the amount of tokens owned by `account`.
710      */
711     function balanceOf(address account) external view returns (uint256);
712 
713     /**
714      * @dev Moves `amount` tokens from the caller's account to `recipient`.
715      *
716      * Returns a boolean value indicating whether the operation succeeded.
717      *
718      * Emits a {Transfer} event.
719      */
720     function transfer(address recipient, uint256 amount) external returns (bool);
721 
722     /**
723      * @dev Returns the remaining number of tokens that `spender` will be
724      * allowed to spend on behalf of `owner` through {transferFrom}. This is
725      * zero by default.
726      *
727      * This value changes when {approve} or {transferFrom} are called.
728      */
729     function allowance(address owner, address spender) external view returns (uint256);
730 
731     /**
732      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
733      *
734      * Returns a boolean value indicating whether the operation succeeded.
735      *
736      * IMPORTANT: Beware that changing an allowance with this method brings the risk
737      * that someone may use both the old and the new allowance by unfortunate
738      * transaction ordering. One possible solution to mitigate this race
739      * condition is to first reduce the spender's allowance to 0 and set the
740      * desired value afterwards:
741      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
742      *
743      * Emits an {Approval} event.
744      */
745     function approve(address spender, uint256 amount) external returns (bool);
746 
747     /**
748      * @dev Moves `amount` tokens from `sender` to `recipient` using the
749      * allowance mechanism. `amount` is then deducted from the caller's
750      * allowance.
751      *
752      * Returns a boolean value indicating whether the operation succeeded.
753      *
754      * Emits a {Transfer} event.
755      */
756     function transferFrom(
757         address sender,
758         address recipient,
759         uint256 amount
760     ) external returns (bool);
761 
762     /**
763      * @dev Emitted when `value` tokens are moved from one account (`from`) to
764      * another (`to`).
765      *
766      * Note that `value` may be zero.
767      */
768     event Transfer(address indexed from, address indexed to, uint256 value);
769 
770     /**
771      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
772      * a call to {approve}. `value` is the new allowance.
773      */
774     event Approval(address indexed owner, address indexed spender, uint256 value);
775 }
776 
777 // File: contracts/marketplace/BaseMarketplace.sol
778 
779 
780 
781 pragma solidity 0.8.4;
782 
783 
784 
785 
786 
787 
788 /// @notice Core logic and state shared between both marketplaces
789 abstract contract BaseMarketplace is ReentrancyGuard, Pausable {
790 
791     event AdminUpdateModulo(uint256 _modulo);
792     event AdminUpdateMinBidAmount(uint256 _minBidAmount);
793     event AdminUpdateAccessControls(IKOAccessControlsLookup indexed _oldAddress, IKOAccessControlsLookup indexed _newAddress);
794     event AdminUpdatePlatformPrimarySaleCommission(uint256 _platformPrimarySaleCommission);
795     event AdminUpdateBidLockupPeriod(uint256 _bidLockupPeriod);
796     event AdminUpdatePlatformAccount(address indexed _oldAddress, address indexed _newAddress);
797     event AdminRecoverERC20(IERC20 indexed _token, address indexed _recipient, uint256 _amount);
798     event AdminRecoverETH(address payable indexed _recipient, uint256 _amount);
799 
800     event BidderRefunded(uint256 indexed _id, address _bidder, uint256 _bid, address _newBidder, uint256 _newOffer);
801     event BidderRefundedFailed(uint256 indexed _id, address _bidder, uint256 _bid, address _newBidder, uint256 _newOffer);
802 
803     // Only a whitelisted smart contract in the access controls contract
804     modifier onlyContract() {
805         _onlyContract();
806         _;
807     }
808 
809     function _onlyContract() private view {
810         require(accessControls.hasContractRole(_msgSender()), "Caller not contract");
811     }
812 
813     // Only admin defined in the access controls contract
814     modifier onlyAdmin() {
815         _onlyAdmin();
816         _;
817     }
818 
819     function _onlyAdmin() private view {
820         require(accessControls.hasAdminRole(_msgSender()), "Caller not admin");
821     }
822 
823     /// @notice Address of the access control contract
824     IKOAccessControlsLookup public accessControls;
825 
826     /// @notice KODA V3 token
827     IKODAV3 public koda;
828 
829     /// @notice platform funds collector
830     address public platformAccount;
831 
832     /// @notice precision 100.00000%
833     uint256 public modulo = 100_00000;
834 
835     /// @notice Minimum bid / minimum list amount
836     uint256 public minBidAmount = 0.01 ether;
837 
838     /// @notice Bid lockup period
839     uint256 public bidLockupPeriod = 6 hours;
840 
841     constructor(IKOAccessControlsLookup _accessControls, IKODAV3 _koda, address _platformAccount) {
842         koda = _koda;
843         accessControls = _accessControls;
844         platformAccount = _platformAccount;
845     }
846 
847     function recoverERC20(IERC20 _token, address _recipient, uint256 _amount) public onlyAdmin {
848         _token.transfer(_recipient, _amount);
849         emit AdminRecoverERC20(_token, _recipient, _amount);
850     }
851 
852     function recoverStuckETH(address payable _recipient, uint256 _amount) public onlyAdmin {
853         (bool success,) = _recipient.call{value : _amount}("");
854         require(success, "Unable to send recipient ETH");
855         emit AdminRecoverETH(_recipient, _amount);
856     }
857 
858     function updateAccessControls(IKOAccessControlsLookup _accessControls) public onlyAdmin {
859         require(_accessControls.hasAdminRole(_msgSender()), "Sender must have admin role in new contract");
860         emit AdminUpdateAccessControls(accessControls, _accessControls);
861         accessControls = _accessControls;
862     }
863 
864     function updateModulo(uint256 _modulo) public onlyAdmin {
865         require(_modulo > 0, "Modulo point cannot be zero");
866         modulo = _modulo;
867         emit AdminUpdateModulo(_modulo);
868     }
869 
870     function updateMinBidAmount(uint256 _minBidAmount) public onlyAdmin {
871         minBidAmount = _minBidAmount;
872         emit AdminUpdateMinBidAmount(_minBidAmount);
873     }
874 
875     function updateBidLockupPeriod(uint256 _bidLockupPeriod) public onlyAdmin {
876         bidLockupPeriod = _bidLockupPeriod;
877         emit AdminUpdateBidLockupPeriod(_bidLockupPeriod);
878     }
879 
880     function updatePlatformAccount(address _newPlatformAccount) public onlyAdmin {
881         emit AdminUpdatePlatformAccount(platformAccount, _newPlatformAccount);
882         platformAccount = _newPlatformAccount;
883     }
884 
885     function pause() public onlyAdmin {
886         super._pause();
887     }
888 
889     function unpause() public onlyAdmin {
890         super._unpause();
891     }
892 
893     function _getLockupTime() internal view returns (uint256 lockupUntil) {
894         lockupUntil = block.timestamp + bidLockupPeriod;
895     }
896 
897     function _refundBidder(uint256 _id, address _receiver, uint256 _paymentAmount, address _newBidder, uint256 _newOffer) internal {
898         (bool success,) = _receiver.call{value : _paymentAmount}("");
899         if (!success) {
900             emit BidderRefundedFailed(_id, _receiver, _paymentAmount, _newBidder, _newOffer);
901         } else {
902             emit BidderRefunded(_id, _receiver, _paymentAmount, _newBidder, _newOffer);
903         }
904     }
905 
906     /// @dev This allows the processing of a marketplace sale to be delegated higher up the inheritance hierarchy
907     function _processSale(
908         uint256 _id,
909         uint256 _paymentAmount,
910         address _buyer,
911         address _seller
912     ) internal virtual returns (uint256);
913 
914     /// @dev This allows an auction mechanic to ask a marketplace if a new listing is permitted i.e. this could be false if the edition or token is already listed under a different mechanic
915     function _isListingPermitted(uint256 _id) internal virtual returns (bool);
916 }
917 
918 // File: contracts/marketplace/BuyNowMarketplace.sol
919 
920 
921 
922 pragma solidity 0.8.4;
923 
924 
925 
926 // "buy now" sale flow
927 abstract contract BuyNowMarketplace is IBuyNowMarketplace, BaseMarketplace {
928     // Buy now listing definition
929     struct Listing {
930         uint128 price;
931         uint128 startDate;
932         address seller;
933     }
934 
935     /// @notice Edition or Token ID to Listing
936     mapping(uint256 => Listing) public editionOrTokenListings;
937 
938     // list edition with "buy now" price and start date
939     function listForBuyNow(address _seller, uint256 _id, uint128 _listingPrice, uint128 _startDate)
940     public
941     override
942     whenNotPaused {
943         require(_isListingPermitted(_id), "Listing is not permitted");
944         require(_isBuyNowListingPermitted(_id), "Buy now listing invalid");
945         require(_listingPrice >= minBidAmount, "Listing price not enough");
946 
947         // Store listing data
948         editionOrTokenListings[_id] = Listing(_listingPrice, _startDate, _seller);
949 
950         emit ListedForBuyNow(_id, _listingPrice, _seller, _startDate);
951     }
952 
953     // Buy an token from the edition on the primary market
954     function buyEditionToken(uint256 _id)
955     public
956     override
957     payable
958     whenNotPaused
959     nonReentrant {
960         _facilitateBuyNow(_id, _msgSender());
961     }
962 
963     // Buy an token from the edition on the primary market, ability to define the recipient
964     function buyEditionTokenFor(uint256 _id, address _recipient)
965     public
966     override
967     payable
968     whenNotPaused
969     nonReentrant {
970         _facilitateBuyNow(_id, _recipient);
971     }
972 
973     // update the "buy now" price
974     function setBuyNowPriceListing(uint256 _id, uint128 _listingPrice)
975     public
976     override
977     whenNotPaused {
978         require(
979             editionOrTokenListings[_id].seller == _msgSender()
980             || accessControls.isVerifiedArtistProxy(editionOrTokenListings[_id].seller, _msgSender()),
981             "Only seller can change price"
982         );
983 
984         // Set price
985         editionOrTokenListings[_id].price = _listingPrice;
986 
987         // Emit event
988         emit BuyNowPriceChanged(_id, _listingPrice);
989     }
990 
991     function _facilitateBuyNow(uint256 _id, address _recipient) internal {
992         Listing storage listing = editionOrTokenListings[_id];
993         require(address(0) != listing.seller, "No listing found");
994         require(msg.value >= listing.price, "List price not satisfied");
995         require(block.timestamp >= listing.startDate, "List not available yet");
996 
997         uint256 tokenId = _processSale(_id, msg.value, _recipient, listing.seller);
998 
999         emit BuyNowPurchased(tokenId, _recipient, listing.seller, msg.value);
1000     }
1001 
1002     function _isBuyNowListingPermitted(uint256 _id) internal virtual returns (bool);
1003 }
1004 
1005 // File: contracts/marketplace/ReserveAuctionMarketplace.sol
1006 
1007 
1008 
1009 pragma solidity 0.8.4;
1010 
1011 
1012 
1013 
1014 
1015 abstract contract ReserveAuctionMarketplace is IReserveAuctionMarketplace, BaseMarketplace {
1016     event AdminUpdateReserveAuctionBidExtensionWindow(uint128 _reserveAuctionBidExtensionWindow);
1017     event AdminUpdateReserveAuctionLengthOnceReserveMet(uint128 _reserveAuctionLengthOnceReserveMet);
1018 
1019     // Reserve auction definition
1020     struct ReserveAuction {
1021         address seller;
1022         address bidder;
1023         uint128 reservePrice;
1024         uint128 bid;
1025         uint128 startDate;
1026         uint128 biddingEnd;
1027     }
1028 
1029     /// @notice 1 of 1 edition ID to reserve auction definition
1030     mapping(uint256 => ReserveAuction) public editionOrTokenWithReserveAuctions;
1031 
1032     /// @notice A reserve auction will be extended by this amount of time if a bid is received near the end
1033     uint128 public reserveAuctionBidExtensionWindow = 15 minutes;
1034 
1035     /// @notice Length that bidding window remains open once the reserve price for an auction has been met
1036     uint128 public reserveAuctionLengthOnceReserveMet = 24 hours;
1037 
1038     function listForReserveAuction(
1039         address _creator,
1040         uint256 _id,
1041         uint128 _reservePrice,
1042         uint128 _startDate
1043     ) public
1044     override
1045     whenNotPaused {
1046         require(_isListingPermitted(_id), "Listing not permitted");
1047         require(_isReserveListingPermitted(_id), "Reserve listing not permitted");
1048         require(_reservePrice >= minBidAmount, "Reserve price must be at least min bid");
1049 
1050         editionOrTokenWithReserveAuctions[_id] = ReserveAuction({
1051         seller : _creator,
1052         bidder : address(0),
1053         reservePrice : _reservePrice,
1054         startDate : _startDate,
1055         biddingEnd : 0,
1056         bid : 0
1057         });
1058 
1059         emit ListedForReserveAuction(_id, _reservePrice, _startDate);
1060     }
1061 
1062     function placeBidOnReserveAuction(uint256 _id)
1063     public
1064     override
1065     payable
1066     whenNotPaused
1067     nonReentrant {
1068         _placeBidOnReserveAuction(_id, _msgSender());
1069     }
1070 
1071     function placeBidOnReserveAuctionFor(uint256 _id, address _bidder)
1072     public
1073     override
1074     payable
1075     whenNotPaused
1076     nonReentrant {
1077         _placeBidOnReserveAuction(_id, _bidder);
1078     }
1079 
1080     function _placeBidOnReserveAuction(uint256 _id, address _bidder) internal {
1081         ReserveAuction storage reserveAuction = editionOrTokenWithReserveAuctions[_id];
1082         require(reserveAuction.reservePrice > 0, "Not set up for reserve auction");
1083         require(block.timestamp >= reserveAuction.startDate, "Not accepting bids yet");
1084         require(msg.value >= reserveAuction.bid + minBidAmount, "You have not exceeded previous bid by min bid amount");
1085 
1086         uint128 originalBiddingEnd = reserveAuction.biddingEnd;
1087 
1088         // If the reserve has been met, then bidding will end in 24 hours
1089         // if we are near the end, we have bids, then extend the bidding end
1090         bool isCountDownTriggered = originalBiddingEnd > 0;
1091 
1092         if (msg.value >= reserveAuction.reservePrice && !isCountDownTriggered) {
1093             reserveAuction.biddingEnd = uint128(block.timestamp) + reserveAuctionLengthOnceReserveMet;
1094         }
1095         else if (isCountDownTriggered) {
1096 
1097             // if a bid has been placed, then we will have a bidding end timestamp
1098             // and we need to ensure no one can bid beyond this
1099             require(block.timestamp < originalBiddingEnd, "No longer accepting bids");
1100             uint128 secondsUntilBiddingEnd = originalBiddingEnd - uint128(block.timestamp);
1101 
1102             // If bid received with in the extension window, extend bidding end
1103             if (secondsUntilBiddingEnd <= reserveAuctionBidExtensionWindow) {
1104                 reserveAuction.biddingEnd = reserveAuction.biddingEnd + reserveAuctionBidExtensionWindow;
1105             }
1106         }
1107 
1108         // if someone else has previously bid, there is a bid we need to refund
1109         if (reserveAuction.bid > 0) {
1110             _refundBidder(_id, reserveAuction.bidder, reserveAuction.bid, _bidder, msg.value);
1111         }
1112 
1113         reserveAuction.bid = uint128(msg.value);
1114         reserveAuction.bidder = _bidder;
1115 
1116         emit BidPlacedOnReserveAuction(_id, reserveAuction.seller, _bidder, msg.value, originalBiddingEnd, reserveAuction.biddingEnd);
1117     }
1118 
1119     function resultReserveAuction(uint256 _id)
1120     public
1121     override
1122     whenNotPaused
1123     nonReentrant {
1124         ReserveAuction storage reserveAuction = editionOrTokenWithReserveAuctions[_id];
1125 
1126         require(reserveAuction.reservePrice > 0, "No active auction");
1127         require(reserveAuction.bid >= reserveAuction.reservePrice, "Reserve not met");
1128         require(block.timestamp > reserveAuction.biddingEnd, "Bidding has not yet ended");
1129 
1130         // N:B. anyone can result the action as only the winner and seller are compensated
1131 
1132         address winner = reserveAuction.bidder;
1133         address seller = reserveAuction.seller;
1134         uint256 winningBid = reserveAuction.bid;
1135         delete editionOrTokenWithReserveAuctions[_id];
1136 
1137         _processSale(_id, winningBid, winner, seller);
1138 
1139         emit ReserveAuctionResulted(_id, winningBid, seller, winner, _msgSender());
1140     }
1141 
1142     // Only permit bid withdrawals if reserve not met
1143     function withdrawBidFromReserveAuction(uint256 _id)
1144     public
1145     override
1146     whenNotPaused
1147     nonReentrant {
1148         ReserveAuction storage reserveAuction = editionOrTokenWithReserveAuctions[_id];
1149 
1150         require(reserveAuction.reservePrice > 0, "No reserve auction in flight");
1151         require(reserveAuction.bid < reserveAuction.reservePrice, "Bids can only be withdrawn if reserve not met");
1152         require(reserveAuction.bidder == _msgSender(), "Only the bidder can withdraw their bid");
1153 
1154         uint256 bidToRefund = reserveAuction.bid;
1155         _refundBidder(_id, reserveAuction.bidder, bidToRefund, address(0), 0);
1156 
1157         reserveAuction.bidder = address(0);
1158         reserveAuction.bid = 0;
1159 
1160         emit BidWithdrawnFromReserveAuction(_id, _msgSender(), uint128(bidToRefund));
1161     }
1162 
1163     // can only do this if the reserve has not been met
1164     function updateReservePriceForReserveAuction(uint256 _id, uint128 _reservePrice)
1165     public
1166     override
1167     whenNotPaused
1168     nonReentrant {
1169         ReserveAuction storage reserveAuction = editionOrTokenWithReserveAuctions[_id];
1170 
1171         require(
1172             reserveAuction.seller == _msgSender()
1173             || accessControls.isVerifiedArtistProxy(reserveAuction.seller, _msgSender()),
1174             "Not the seller"
1175         );
1176 
1177         require(reserveAuction.biddingEnd == 0, "Reserve countdown commenced");
1178         require(_reservePrice >= minBidAmount, "Reserve must be at least min bid");
1179 
1180         // Trigger countdown if new reserve price is greater than any current bids
1181         if (reserveAuction.bid >= _reservePrice) {
1182             reserveAuction.biddingEnd = uint128(block.timestamp) + reserveAuctionLengthOnceReserveMet;
1183         }
1184 
1185         reserveAuction.reservePrice = _reservePrice;
1186 
1187         emit ReservePriceUpdated(_id, _reservePrice);
1188     }
1189 
1190     function emergencyExitBidFromReserveAuction(uint256 _id)
1191     public
1192     override
1193     whenNotPaused
1194     nonReentrant {
1195         ReserveAuction storage reserveAuction = editionOrTokenWithReserveAuctions[_id];
1196 
1197         require(reserveAuction.bid > 0, "No bid in flight");
1198         require(_hasReserveListingBeenInvalidated(_id), "Bid cannot be withdrawn as reserve auction listing is valid");
1199 
1200         bool isSeller = reserveAuction.seller == _msgSender();
1201         bool isBidder = reserveAuction.bidder == _msgSender();
1202         require(
1203             isSeller
1204             || isBidder
1205             || accessControls.isVerifiedArtistProxy(reserveAuction.seller, _msgSender())
1206             || accessControls.hasContractOrAdminRole(_msgSender()),
1207             "Only seller, bidder, contract or platform admin"
1208         );
1209         // external call done last as a gas optimisation i.e. it wont be called if isSeller || isBidder is true
1210 
1211         _refundBidder(_id, reserveAuction.bidder, reserveAuction.bid, address(0), 0);
1212 
1213         emit EmergencyBidWithdrawFromReserveAuction(_id, reserveAuction.bidder, reserveAuction.bid);
1214 
1215         delete editionOrTokenWithReserveAuctions[_id];
1216     }
1217 
1218     function updateReserveAuctionBidExtensionWindow(uint128 _reserveAuctionBidExtensionWindow) onlyAdmin public {
1219         reserveAuctionBidExtensionWindow = _reserveAuctionBidExtensionWindow;
1220         emit AdminUpdateReserveAuctionBidExtensionWindow(_reserveAuctionBidExtensionWindow);
1221     }
1222 
1223     function updateReserveAuctionLengthOnceReserveMet(uint128 _reserveAuctionLengthOnceReserveMet) onlyAdmin public {
1224         reserveAuctionLengthOnceReserveMet = _reserveAuctionLengthOnceReserveMet;
1225         emit AdminUpdateReserveAuctionLengthOnceReserveMet(_reserveAuctionLengthOnceReserveMet);
1226     }
1227 
1228     function _isReserveListingPermitted(uint256 _id) internal virtual returns (bool);
1229 
1230     function _hasReserveListingBeenInvalidated(uint256 _id) internal virtual returns (bool);
1231 
1232     function _removeReserveAuctionListing(uint256 _id) internal {
1233         ReserveAuction storage reserveAuction = editionOrTokenWithReserveAuctions[_id];
1234 
1235         require(reserveAuction.reservePrice > 0, "No active auction");
1236         require(reserveAuction.bid < reserveAuction.reservePrice, "Can only convert before reserve met");
1237         require(reserveAuction.seller == _msgSender(), "Only the seller can convert");
1238 
1239         // refund any bids
1240         if (reserveAuction.bid > 0) {
1241             _refundBidder(_id, reserveAuction.bidder, reserveAuction.bid, address(0), 0);
1242         }
1243 
1244         delete editionOrTokenWithReserveAuctions[_id];
1245     }
1246 }
1247 
1248 // File: contracts/marketplace/KODAV3PrimaryMarketplace.sol
1249 
1250 
1251 
1252 pragma solidity 0.8.4;
1253 
1254 
1255 
1256 
1257 
1258 
1259 
1260 /// @title KnownOrigin Primary Marketplace for all V3 tokens
1261 /// @notice The following listing types are supported: Buy now, Stepped, Reserve and Offers
1262 /// @dev The contract is pausable and has reentrancy guards
1263 /// @author KnownOrigin Labs
1264 contract KODAV3PrimaryMarketplace is
1265 IKODAV3PrimarySaleMarketplace,
1266 BaseMarketplace,
1267 ReserveAuctionMarketplace,
1268 BuyNowMarketplace {
1269 
1270     event PrimaryMarketplaceDeployed();
1271     event AdminSetKoCommissionOverrideForCreator(address indexed _creator, uint256 _koCommission);
1272     event AdminSetKoCommissionOverrideForEdition(uint256 indexed _editionId, uint256 _koCommission);
1273     event ConvertFromBuyNowToOffers(uint256 indexed _editionId, uint128 _startDate);
1274     event ConvertSteppedAuctionToBuyNow(uint256 indexed _editionId, uint128 _listingPrice, uint128 _startDate);
1275     event ReserveAuctionConvertedToOffers(uint256 indexed _editionId, uint128 _startDate);
1276 
1277     // KO Commission override definition for a given creator
1278     struct KOCommissionOverride {
1279         bool active;
1280         uint256 koCommission;
1281     }
1282 
1283     // Offer / Bid definition placed on an edition
1284     struct Offer {
1285         uint256 offer;
1286         address bidder;
1287         uint256 lockupUntil;
1288     }
1289 
1290     // Stepped auction definition
1291     struct Stepped {
1292         uint128 basePrice;
1293         uint128 stepPrice;
1294         uint128 startDate;
1295         address seller;
1296         uint16 currentStep;
1297     }
1298 
1299     /// @notice Edition ID -> KO commission override set by admin
1300     mapping(uint256 => KOCommissionOverride) public koCommissionOverrideForEditions;
1301 
1302     /// @notice primary sale creator -> KO commission override set by admin
1303     mapping(address => KOCommissionOverride) public koCommissionOverrideForCreators;
1304 
1305     /// @notice Edition ID to Offer mapping
1306     mapping(uint256 => Offer) public editionOffers;
1307 
1308     /// @notice Edition ID to StartDate
1309     mapping(uint256 => uint256) public editionOffersStartDate;
1310 
1311     /// @notice Edition ID to stepped auction
1312     mapping(uint256 => Stepped) public editionStep;
1313 
1314     /// @notice KO commission on every sale
1315     uint256 public platformPrimarySaleCommission = 15_00000;  // 15.00000%
1316 
1317     constructor(IKOAccessControlsLookup _accessControls, IKODAV3 _koda, address _platformAccount)
1318     BaseMarketplace(_accessControls, _koda, _platformAccount) {
1319         emit PrimaryMarketplaceDeployed();
1320     }
1321 
1322     // convert from a "buy now" listing and converting to "accepting offers" with an optional start date
1323     function convertFromBuyNowToOffers(uint256 _editionId, uint128 _startDate)
1324     public
1325     whenNotPaused {
1326         require(
1327             editionOrTokenListings[_editionId].seller == _msgSender()
1328             || accessControls.isVerifiedArtistProxy(editionOrTokenListings[_editionId].seller, _msgSender()),
1329             "Only seller can convert"
1330         );
1331 
1332         // clear listing
1333         delete editionOrTokenListings[_editionId];
1334 
1335         // set the start date for the offer (optional)
1336         editionOffersStartDate[_editionId] = _startDate;
1337 
1338         // Emit event
1339         emit ConvertFromBuyNowToOffers(_editionId, _startDate);
1340     }
1341 
1342     // Primary "offers" sale flow
1343 
1344     function enableEditionOffers(uint256 _editionId, uint128 _startDate)
1345     external
1346     override
1347     whenNotPaused
1348     onlyContract {
1349         // Set the start date if one supplied
1350         editionOffersStartDate[_editionId] = _startDate;
1351 
1352         // Emit event
1353         emit EditionAcceptingOffer(_editionId, _startDate);
1354     }
1355 
1356     function placeEditionBid(uint256 _editionId)
1357     public
1358     override
1359     payable
1360     whenNotPaused
1361     nonReentrant {
1362         _placeEditionBid(_editionId, _msgSender());
1363     }
1364 
1365     function placeEditionBidFor(uint256 _editionId, address _bidder)
1366     public
1367     override
1368     payable
1369     whenNotPaused
1370     nonReentrant {
1371         _placeEditionBid(_editionId, _bidder);
1372     }
1373 
1374     function withdrawEditionBid(uint256 _editionId)
1375     public
1376     override
1377     whenNotPaused
1378     nonReentrant {
1379         Offer storage offer = editionOffers[_editionId];
1380         require(offer.offer > 0, "No open bid");
1381         require(offer.bidder == _msgSender(), "Not the top bidder");
1382         require(block.timestamp >= offer.lockupUntil, "Bid lockup not elapsed");
1383 
1384         // send money back to top bidder
1385         _refundBidder(_editionId, offer.bidder, offer.offer, address(0), 0);
1386 
1387         // emit event
1388         emit EditionBidWithdrawn(_editionId, _msgSender());
1389 
1390         // delete offer
1391         delete editionOffers[_editionId];
1392     }
1393 
1394     function rejectEditionBid(uint256 _editionId)
1395     public
1396     override
1397     whenNotPaused
1398     nonReentrant {
1399         Offer storage offer = editionOffers[_editionId];
1400         require(offer.bidder != address(0), "No open bid");
1401 
1402         address creatorOfEdition = koda.getCreatorOfEdition(_editionId);
1403         require(
1404             creatorOfEdition == _msgSender()
1405             || accessControls.isVerifiedArtistProxy(creatorOfEdition, _msgSender()),
1406             "Caller not the creator"
1407         );
1408 
1409         // send money back to top bidder
1410         _refundBidder(_editionId, offer.bidder, offer.offer, address(0), 0);
1411 
1412         // emit event
1413         emit EditionBidRejected(_editionId, offer.bidder, offer.offer);
1414 
1415         // delete offer
1416         delete editionOffers[_editionId];
1417     }
1418 
1419     function acceptEditionBid(uint256 _editionId, uint256 _offerPrice)
1420     public
1421     override
1422     whenNotPaused
1423     nonReentrant {
1424         Offer storage offer = editionOffers[_editionId];
1425         require(offer.bidder != address(0), "No open bid");
1426         require(offer.offer >= _offerPrice, "Offer price has changed");
1427 
1428         address creatorOfEdition = koda.getCreatorOfEdition(_editionId);
1429         require(
1430             creatorOfEdition == _msgSender()
1431             || accessControls.isVerifiedArtistProxy(creatorOfEdition, _msgSender()),
1432             "Not creator"
1433         );
1434 
1435         // get a new token from the edition to transfer ownership
1436         uint256 tokenId = _facilitateNextPrimarySale(_editionId, offer.offer, offer.bidder, false);
1437 
1438         // emit event
1439         emit EditionBidAccepted(_editionId, tokenId, offer.bidder, offer.offer);
1440 
1441         // clear open offer
1442         delete editionOffers[_editionId];
1443     }
1444 
1445     // emergency admin "reject" button for stuck bids
1446     function adminRejectEditionBid(uint256 _editionId) public onlyAdmin nonReentrant {
1447         Offer storage offer = editionOffers[_editionId];
1448         require(offer.bidder != address(0), "No open bid");
1449 
1450         // send money back to top bidder
1451         if (offer.offer > 0) {
1452             _refundBidder(_editionId, offer.bidder, offer.offer, address(0), 0);
1453         }
1454 
1455         emit EditionBidRejected(_editionId, offer.bidder, offer.offer);
1456 
1457         // delete offer
1458         delete editionOffers[_editionId];
1459     }
1460 
1461     function convertOffersToBuyItNow(uint256 _editionId, uint128 _listingPrice, uint128 _startDate)
1462     public
1463     override
1464     whenNotPaused
1465     nonReentrant {
1466         require(!_isEditionListed(_editionId), "Edition is listed");
1467 
1468         address creatorOfEdition = koda.getCreatorOfEdition(_editionId);
1469         require(
1470             creatorOfEdition == _msgSender()
1471             || accessControls.isVerifiedArtistProxy(creatorOfEdition, _msgSender()),
1472             "Not creator"
1473         );
1474 
1475         require(_listingPrice >= minBidAmount, "Listing price not enough");
1476 
1477         // send money back to top bidder if existing offer found
1478         Offer storage offer = editionOffers[_editionId];
1479         if (offer.offer > 0) {
1480             _refundBidder(_editionId, offer.bidder, offer.offer, address(0), 0);
1481         }
1482 
1483         // delete offer
1484         delete editionOffers[_editionId];
1485 
1486         // delete rest of offer information
1487         delete editionOffersStartDate[_editionId];
1488 
1489         // Store listing data
1490         editionOrTokenListings[_editionId] = Listing(_listingPrice, _startDate, _msgSender());
1491 
1492         emit EditionConvertedFromOffersToBuyItNow(_editionId, _listingPrice, _startDate);
1493     }
1494 
1495     // Primary sale "stepped pricing" flow
1496     function listSteppedEditionAuction(address _creator, uint256 _editionId, uint128 _basePrice, uint128 _stepPrice, uint128 _startDate)
1497     public
1498     override
1499     whenNotPaused
1500     onlyContract {
1501         require(_basePrice >= minBidAmount, "Base price not enough");
1502 
1503         // Store listing data
1504         editionStep[_editionId] = Stepped(
1505             _basePrice,
1506             _stepPrice,
1507             _startDate,
1508             _creator,
1509             uint16(0)
1510         );
1511 
1512         emit EditionSteppedSaleListed(_editionId, _basePrice, _stepPrice, _startDate);
1513     }
1514 
1515     function updateSteppedAuction(uint256 _editionId, uint128 _basePrice, uint128 _stepPrice)
1516     public
1517     override
1518     whenNotPaused {
1519         Stepped storage steppedAuction = editionStep[_editionId];
1520 
1521         require(
1522             steppedAuction.seller == _msgSender()
1523             || accessControls.isVerifiedArtistProxy(steppedAuction.seller, _msgSender()),
1524             "Only seller"
1525         );
1526 
1527         require(steppedAuction.currentStep == 0, "Only when no sales");
1528         require(_basePrice >= minBidAmount, "Base price not enough");
1529 
1530         steppedAuction.basePrice = _basePrice;
1531         steppedAuction.stepPrice = _stepPrice;
1532 
1533         emit EditionSteppedAuctionUpdated(_editionId, _basePrice, _stepPrice);
1534     }
1535 
1536     function buyNextStep(uint256 _editionId)
1537     public
1538     override
1539     payable
1540     whenNotPaused
1541     nonReentrant {
1542         _buyNextStep(_editionId, _msgSender());
1543     }
1544 
1545     function buyNextStepFor(uint256 _editionId, address _buyer)
1546     public
1547     override
1548     payable
1549     whenNotPaused
1550     nonReentrant {
1551         _buyNextStep(_editionId, _buyer);
1552     }
1553 
1554     function _buyNextStep(uint256 _editionId, address _buyer) internal {
1555         Stepped storage steppedAuction = editionStep[_editionId];
1556         require(steppedAuction.seller != address(0), "Edition not listed for stepped auction");
1557         require(steppedAuction.startDate <= block.timestamp, "Not started yet");
1558 
1559         uint256 expectedPrice = _getNextEditionSteppedPrice(_editionId);
1560         require(msg.value >= expectedPrice, "Expected price not met");
1561 
1562         uint256 tokenId = _facilitateNextPrimarySale(_editionId, expectedPrice, _buyer, true);
1563 
1564         // Bump the current step
1565         uint16 step = steppedAuction.currentStep;
1566 
1567         // no safemath for uint16
1568         steppedAuction.currentStep = step + 1;
1569 
1570         // send back excess if supplied - will allow UX flow of setting max price to pay
1571         if (msg.value > expectedPrice) {
1572             (bool success,) = _msgSender().call{value : msg.value - expectedPrice}("");
1573             require(success, "failed to send overspend back");
1574         }
1575 
1576         emit EditionSteppedSaleBuy(_editionId, tokenId, _buyer, expectedPrice, step);
1577     }
1578 
1579     // creates an exit from a step if required but forces a buy now price
1580     function convertSteppedAuctionToListing(uint256 _editionId, uint128 _listingPrice, uint128 _startDate)
1581     public
1582     override
1583     nonReentrant
1584     whenNotPaused {
1585         Stepped storage steppedAuction = editionStep[_editionId];
1586         require(_listingPrice >= minBidAmount, "List price not enough");
1587 
1588         require(
1589             steppedAuction.seller == _msgSender()
1590             || accessControls.isVerifiedArtistProxy(steppedAuction.seller, _msgSender()),
1591             "Only seller can convert"
1592         );
1593 
1594         // Store listing data
1595         editionOrTokenListings[_editionId] = Listing(_listingPrice, _startDate, steppedAuction.seller);
1596 
1597         // emit event
1598         emit ConvertSteppedAuctionToBuyNow(_editionId, _listingPrice, _startDate);
1599 
1600         // Clear up the step logic
1601         delete editionStep[_editionId];
1602     }
1603 
1604     function convertSteppedAuctionToOffers(uint256 _editionId, uint128 _startDate)
1605     public
1606     override
1607     whenNotPaused {
1608         Stepped storage steppedAuction = editionStep[_editionId];
1609 
1610         require(
1611             steppedAuction.seller == _msgSender()
1612             || accessControls.isVerifiedArtistProxy(steppedAuction.seller, _msgSender()),
1613             "Only seller can convert"
1614         );
1615 
1616         // set the start date for the offer (optional)
1617         editionOffersStartDate[_editionId] = _startDate;
1618 
1619         // Clear up the step logic
1620         delete editionStep[_editionId];
1621 
1622         emit ConvertFromBuyNowToOffers(_editionId, _startDate);
1623     }
1624 
1625     // Get the next
1626     function getNextEditionSteppedPrice(uint256 _editionId) public view returns (uint256 price) {
1627         price = _getNextEditionSteppedPrice(_editionId);
1628     }
1629 
1630     function _getNextEditionSteppedPrice(uint256 _editionId) internal view returns (uint256 price) {
1631         Stepped storage steppedAuction = editionStep[_editionId];
1632         uint256 stepAmount = uint256(steppedAuction.stepPrice) * uint256(steppedAuction.currentStep);
1633         price = uint256(steppedAuction.basePrice) + stepAmount;
1634     }
1635 
1636     function convertReserveAuctionToBuyItNow(uint256 _editionId, uint128 _listingPrice, uint128 _startDate)
1637     public
1638     override
1639     whenNotPaused
1640     nonReentrant {
1641         require(_listingPrice >= minBidAmount, "Listing price not enough");
1642         _removeReserveAuctionListing(_editionId);
1643 
1644         editionOrTokenListings[_editionId] = Listing(_listingPrice, _startDate, _msgSender());
1645 
1646         emit ReserveAuctionConvertedToBuyItNow(_editionId, _listingPrice, _startDate);
1647     }
1648 
1649     function convertReserveAuctionToOffers(uint256 _editionId, uint128 _startDate)
1650     public
1651     override
1652     whenNotPaused
1653     nonReentrant {
1654         _removeReserveAuctionListing(_editionId);
1655 
1656         // set the start date for the offer (optional)
1657         editionOffersStartDate[_editionId] = _startDate;
1658 
1659         emit ReserveAuctionConvertedToOffers(_editionId, _startDate);
1660     }
1661 
1662     // admin
1663 
1664     function updatePlatformPrimarySaleCommission(uint256 _platformPrimarySaleCommission) public onlyAdmin {
1665         platformPrimarySaleCommission = _platformPrimarySaleCommission;
1666         emit AdminUpdatePlatformPrimarySaleCommission(_platformPrimarySaleCommission);
1667     }
1668 
1669     function setKoCommissionOverrideForCreator(address _creator, bool _active, uint256 _koCommission) public onlyAdmin {
1670         KOCommissionOverride storage koCommissionOverride = koCommissionOverrideForCreators[_creator];
1671         koCommissionOverride.active = _active;
1672         koCommissionOverride.koCommission = _koCommission;
1673 
1674         emit AdminSetKoCommissionOverrideForCreator(_creator, _koCommission);
1675     }
1676 
1677     function setKoCommissionOverrideForEdition(uint256 _editionId, bool _active, uint256 _koCommission) public onlyAdmin {
1678         KOCommissionOverride storage koCommissionOverride = koCommissionOverrideForEditions[_editionId];
1679         koCommissionOverride.active = _active;
1680         koCommissionOverride.koCommission = _koCommission;
1681 
1682         emit AdminSetKoCommissionOverrideForEdition(_editionId, _koCommission);
1683     }
1684 
1685     // internal
1686 
1687     function _isListingPermitted(uint256 _editionId) internal view override returns (bool) {
1688         return !_isEditionListed(_editionId);
1689     }
1690 
1691     function _isReserveListingPermitted(uint256 _editionId) internal view override returns (bool) {
1692         return koda.getSizeOfEdition(_editionId) == 1 && accessControls.hasContractRole(_msgSender());
1693     }
1694 
1695     function _hasReserveListingBeenInvalidated(uint256 _id) internal view override returns (bool) {
1696         bool isApprovalActiveForMarketplace = koda.isApprovedForAll(
1697             editionOrTokenWithReserveAuctions[_id].seller,
1698             address(this)
1699         );
1700 
1701         return !isApprovalActiveForMarketplace || koda.isSalesDisabledOrSoldOut(_id);
1702     }
1703 
1704     function _isBuyNowListingPermitted(uint256) internal view override returns (bool) {
1705         return accessControls.hasContractRole(_msgSender());
1706     }
1707 
1708     function _processSale(uint256 _id, uint256 _paymentAmount, address _buyer, address) internal override returns (uint256) {
1709         return _facilitateNextPrimarySale(_id, _paymentAmount, _buyer, false);
1710     }
1711 
1712     function _facilitateNextPrimarySale(uint256 _editionId, uint256 _paymentAmount, address _buyer, bool _reverse) internal returns (uint256) {
1713         // for stepped sales, should they be sold in reverse order ie. 10...1 and not 1...10?
1714         // get next token to sell along with the royalties recipient and the original creator
1715         (address receiver, address creator, uint256 tokenId) = _reverse
1716         ? koda.facilitateReversePrimarySale(_editionId)
1717         : koda.facilitateNextPrimarySale(_editionId);
1718 
1719         // split money
1720         _handleEditionSaleFunds(_editionId, creator, receiver, _paymentAmount);
1721 
1722         // send token to buyer (assumes approval has been made, if not then this will fail)
1723         koda.safeTransferFrom(creator, _buyer, tokenId);
1724 
1725         // N:B. open offers are left once sold out for the bidder to withdraw or the artist to reject
1726 
1727         return tokenId;
1728     }
1729 
1730     function _handleEditionSaleFunds(uint256 _editionId, address _creator, address _receiver, uint256 _paymentAmount) internal {
1731         uint256 primarySaleCommission;
1732 
1733         if (koCommissionOverrideForEditions[_editionId].active) {
1734             primarySaleCommission = koCommissionOverrideForEditions[_editionId].koCommission;
1735         }
1736         else if (koCommissionOverrideForCreators[_creator].active) {
1737             primarySaleCommission = koCommissionOverrideForCreators[_creator].koCommission;
1738         }
1739         else {
1740             primarySaleCommission = platformPrimarySaleCommission;
1741         }
1742 
1743         uint256 koCommission = (_paymentAmount / modulo) * primarySaleCommission;
1744         if (koCommission > 0) {
1745             (bool koCommissionSuccess,) = platformAccount.call{value : koCommission}("");
1746             require(koCommissionSuccess, "Edition commission payment failed");
1747         }
1748 
1749         (bool success,) = _receiver.call{value : _paymentAmount - koCommission}("");
1750         require(success, "Edition payment failed");
1751     }
1752 
1753     // as offers are always possible, we wont count it as a listing
1754     function _isEditionListed(uint256 _editionId) internal view returns (bool) {
1755         if (editionOrTokenListings[_editionId].seller != address(0)) {
1756             return true;
1757         }
1758 
1759         if (editionStep[_editionId].seller != address(0)) {
1760             return true;
1761         }
1762 
1763         if (editionOrTokenWithReserveAuctions[_editionId].seller != address(0)) {
1764             return true;
1765         }
1766 
1767         return false;
1768     }
1769 
1770     function _placeEditionBid(uint256 _editionId, address _bidder) internal {
1771         require(!_isEditionListed(_editionId), "Edition is listed");
1772 
1773         Offer storage offer = editionOffers[_editionId];
1774         require(msg.value >= offer.offer + minBidAmount, "Bid not high enough");
1775 
1776         // Honor start date if set
1777         uint256 startDate = editionOffersStartDate[_editionId];
1778         if (startDate > 0) {
1779             require(block.timestamp >= startDate, "Not yet accepting offers");
1780 
1781             // elapsed, so free storage
1782             delete editionOffersStartDate[_editionId];
1783         }
1784 
1785         // send money back to top bidder if existing offer found
1786         if (offer.offer > 0) {
1787             _refundBidder(_editionId, offer.bidder, offer.offer, _msgSender(), msg.value);
1788         }
1789 
1790         // setup offer
1791         editionOffers[_editionId] = Offer(msg.value, _bidder, _getLockupTime());
1792 
1793         emit EditionBidPlaced(_editionId, _bidder, msg.value);
1794     }
1795 }
1796 
1797 // File: contracts/collab/ICollabRoyaltiesRegistry.sol
1798 
1799 
1800 pragma solidity 0.8.4;
1801 
1802 /// @notice Common interface to the edition royalties registry
1803 interface ICollabRoyaltiesRegistry {
1804 
1805     /// @notice Creates & deploys a new royalties recipient, cloning _handle and setting it up with the provided _recipients and _splits
1806     function createRoyaltiesRecipient(
1807         address _handler,
1808         address[] calldata _recipients,
1809         uint256[] calldata _splits
1810     ) external returns (address deployedHandler);
1811 
1812     /// @notice Sets up the provided edition to use the provided _recipient
1813     function useRoyaltiesRecipient(uint256 _editionId, address _deployedHandler) external;
1814 
1815     /// @notice Setup a royalties handler but does not deploy it, uses predicable clone and sets this against the edition
1816     function usePredeterminedRoyaltiesRecipient(
1817         uint256 _editionId,
1818         address _handler,
1819         address[] calldata _recipients,
1820         uint256[] calldata _splits
1821     ) external;
1822 
1823     /// @notice Deploy and setup a royalties recipient for the given edition
1824     function createAndUseRoyaltiesRecipient(
1825         uint256 _editionId,
1826         address _handler,
1827         address[] calldata _recipients,
1828         uint256[] calldata _splits
1829     )
1830     external returns (address deployedHandler);
1831 
1832     /// @notice Predict the deployed clone address with the given parameters
1833     function predictedRoyaltiesHandler(
1834         address _handler,
1835         address[] calldata _recipients,
1836         uint256[] calldata _splits
1837     ) external view returns (address predictedHandler);
1838 
1839 }
1840 
1841 // File: contracts/minter/MintingFactory.sol
1842 
1843 
1844 
1845 pragma solidity 0.8.4;
1846 
1847 
1848 
1849 
1850 
1851 
1852 contract MintingFactory is Context {
1853 
1854     event EditionMintedAndListed(uint256 indexed _editionId, SaleType _saleType);
1855 
1856     event MintingFactoryCreated();
1857     event AdminMintingPeriodChanged(uint256 _mintingPeriod);
1858     event AdminMaxMintsInPeriodChanged(uint256 _maxMintsInPeriod);
1859     event AdminFrequencyOverrideChanged(address _account, bool _override);
1860     event AdminRoyaltiesRegistryChanged(address _royaltiesRegistry);
1861 
1862     modifier onlyAdmin() {
1863         require(accessControls.hasAdminRole(_msgSender()), "Caller must have admin role");
1864         _;
1865     }
1866 
1867     modifier canMintAgain(){
1868         require(_canCreateNewEdition(_msgSender()), "Caller unable to create yet");
1869         _;
1870     }
1871 
1872     IKOAccessControlsLookup public accessControls;
1873     IKODAV3Minter public koda;
1874     IKODAV3PrimarySaleMarketplace public marketplace;
1875     ICollabRoyaltiesRegistry public royaltiesRegistry;
1876 
1877     // Minting allowance period
1878     uint256 public mintingPeriod = 30 days;
1879 
1880     // Limit of mints with in the period
1881     uint256 public maxMintsInPeriod = 15;
1882 
1883     // Frequency override list for users - you can temporarily add in address which disables the freeze time check
1884     mapping(address => bool) public frequencyOverride;
1885 
1886     struct MintingPeriod {
1887         uint128 mints;
1888         uint128 firstMintInPeriod;
1889     }
1890 
1891     // How many mints within the current minting period
1892     mapping(address => MintingPeriod) mintingPeriodConfig;
1893 
1894     enum SaleType {
1895         BUY_NOW, OFFERS, STEPPED, RESERVE
1896     }
1897 
1898     constructor(
1899         IKOAccessControlsLookup _accessControls,
1900         IKODAV3Minter _koda,
1901         IKODAV3PrimarySaleMarketplace _marketplace,
1902         ICollabRoyaltiesRegistry _royaltiesRegistry
1903     ) {
1904         accessControls = _accessControls;
1905         koda = _koda;
1906         marketplace = _marketplace;
1907         royaltiesRegistry = _royaltiesRegistry;
1908 
1909         emit MintingFactoryCreated();
1910     }
1911 
1912     function mintToken(
1913         SaleType _saleType,
1914         uint128 _startDate,
1915         uint128 _basePrice,
1916         uint128 _stepPrice,
1917         string calldata _uri,
1918         uint256 _merkleIndex,
1919         bytes32[] calldata _merkleProof,
1920         address _deployedRoyaltiesHandler
1921     ) canMintAgain external {
1922         require(accessControls.isVerifiedArtist(_merkleIndex, _msgSender(), _merkleProof), "Caller must have minter role");
1923 
1924         // Make tokens & edition
1925         uint256 editionId = koda.mintBatchEdition(1, _msgSender(), _uri);
1926 
1927         _setupSalesMechanic(editionId, _saleType, _startDate, _basePrice, _stepPrice);
1928         _recordSuccessfulMint(_msgSender());
1929         _setupRoyalties(editionId, _deployedRoyaltiesHandler);
1930     }
1931 
1932     function mintTokenAsProxy(
1933         address _creator,
1934         SaleType _saleType,
1935         uint128 _startDate,
1936         uint128 _basePrice,
1937         uint128 _stepPrice,
1938         string calldata _uri,
1939         address _deployedRoyaltiesHandler
1940     ) canMintAgain external {
1941         require(accessControls.isVerifiedArtistProxy(_creator, _msgSender()), "Caller is not artist proxy");
1942 
1943         // Make tokens & edition
1944         uint256 editionId = koda.mintBatchEdition(1, _creator, _uri);
1945 
1946         _setupSalesMechanic(editionId, _saleType, _startDate, _basePrice, _stepPrice);
1947         _recordSuccessfulMint(_creator);
1948         _setupRoyalties(editionId, _deployedRoyaltiesHandler);
1949     }
1950 
1951     function mintBatchEdition(
1952         SaleType _saleType,
1953         uint16 _editionSize,
1954         uint128 _startDate,
1955         uint128 _basePrice,
1956         uint128 _stepPrice,
1957         string calldata _uri,
1958         uint256 _merkleIndex,
1959         bytes32[] calldata _merkleProof,
1960         address _deployedRoyaltiesHandler
1961     ) canMintAgain external {
1962         require(accessControls.isVerifiedArtist(_merkleIndex, _msgSender(), _merkleProof), "Caller must have minter role");
1963 
1964         // Make tokens & edition
1965         uint256 editionId = koda.mintBatchEdition(_editionSize, _msgSender(), _uri);
1966 
1967         _setupSalesMechanic(editionId, _saleType, _startDate, _basePrice, _stepPrice);
1968         _recordSuccessfulMint(_msgSender());
1969         _setupRoyalties(editionId, _deployedRoyaltiesHandler);
1970     }
1971 
1972     function mintBatchEditionAsProxy(
1973         address _creator,
1974         SaleType _saleType,
1975         uint16 _editionSize,
1976         uint128 _startDate,
1977         uint128 _basePrice,
1978         uint128 _stepPrice,
1979         string calldata _uri,
1980         address _deployedRoyaltiesHandler
1981     ) canMintAgain external {
1982         require(accessControls.isVerifiedArtistProxy(_creator, _msgSender()), "Caller is not artist proxy");
1983 
1984         // Make tokens & edition
1985         uint256 editionId = koda.mintBatchEdition(_editionSize, _creator, _uri);
1986 
1987         _setupSalesMechanic(editionId, _saleType, _startDate, _basePrice, _stepPrice);
1988         _recordSuccessfulMint(_creator);
1989         _setupRoyalties(editionId, _deployedRoyaltiesHandler);
1990     }
1991 
1992     function mintBatchEditionAndComposeERC20s(
1993         SaleType _saleType,
1994     // --- _config array (expected length of 5) ---
1995     // Index 0 - Merkle Index
1996     // Index 1 - Edition size
1997     // Index 2 - Start Date
1998     // Index 3 - Base price
1999     // Index 4 - Step price
2000     // ---------------------------------------------
2001         uint128[] calldata _config,
2002         string calldata _uri,
2003         address[] calldata _erc20s,
2004         uint256[] calldata _amounts,
2005         bytes32[] calldata _merkleProof
2006     ) canMintAgain external {
2007         require(accessControls.isVerifiedArtist(_config[0], _msgSender(), _merkleProof), "Caller must have minter role");
2008         require(_config.length == 5, "Config must consist of 5 elements in the array");
2009 
2010         uint256 editionId = koda.mintBatchEditionAndComposeERC20s(uint16(_config[1]), _msgSender(), _uri, _erc20s, _amounts);
2011 
2012         _setupSalesMechanic(editionId, _saleType, _config[2], _config[3], _config[4]);
2013         _recordSuccessfulMint(_msgSender());
2014     }
2015 
2016     function mintBatchEditionAndComposeERC20sAsProxy(
2017         address _creator,
2018         SaleType _saleType,
2019     // --- _config array (expected length of 4) ---
2020     // Index 0 - Edition size
2021     // Index 1 - Start Date
2022     // Index 2 - Base price
2023     // Index 3 - Step price
2024     // ---------------------------------------------
2025         uint128[] calldata _config,
2026         string calldata _uri,
2027         address[] calldata _erc20s,
2028         uint256[] calldata _amounts
2029     ) canMintAgain external {
2030         require(accessControls.isVerifiedArtistProxy(_creator, _msgSender()), "Caller is not artist proxy");
2031         require(_config.length == 4, "Config must consist of 4 elements in the array");
2032 
2033         uint256 editionId = koda.mintBatchEditionAndComposeERC20s(uint16(_config[0]), _creator, _uri, _erc20s, _amounts);
2034 
2035         _setupSalesMechanic(editionId, _saleType, _config[1], _config[2], _config[3]);
2036         _recordSuccessfulMint(_creator);
2037     }
2038 
2039     function mintConsecutiveBatchEdition(
2040         SaleType _saleType,
2041         uint16 _editionSize,
2042         uint128 _startDate,
2043         uint128 _basePrice,
2044         uint128 _stepPrice,
2045         string calldata _uri,
2046         uint256 _merkleIndex,
2047         bytes32[] calldata _merkleProof,
2048         address _deployedRoyaltiesHandler
2049     ) canMintAgain external {
2050         require(accessControls.isVerifiedArtist(_merkleIndex, _msgSender(), _merkleProof), "Caller must have minter role");
2051 
2052         // Make tokens & edition
2053         uint256 editionId = koda.mintConsecutiveBatchEdition(_editionSize, _msgSender(), _uri);
2054 
2055         _setupSalesMechanic(editionId, _saleType, _startDate, _basePrice, _stepPrice);
2056         _recordSuccessfulMint(_msgSender());
2057         _setupRoyalties(editionId, _deployedRoyaltiesHandler);
2058     }
2059 
2060     function mintConsecutiveBatchEditionAsProxy(
2061         address _creator,
2062         SaleType _saleType,
2063         uint16 _editionSize,
2064         uint128 _startDate,
2065         uint128 _basePrice,
2066         uint128 _stepPrice,
2067         string calldata _uri,
2068         address _deployedRoyaltiesHandler
2069     ) canMintAgain external {
2070         require(accessControls.isVerifiedArtistProxy(_creator, _msgSender()), "Caller is not artist proxy");
2071 
2072         // Make tokens & edition
2073         uint256 editionId = koda.mintConsecutiveBatchEdition(_editionSize, _creator, _uri);
2074 
2075         _setupSalesMechanic(editionId, _saleType, _startDate, _basePrice, _stepPrice);
2076         _recordSuccessfulMint(_creator);
2077         _setupRoyalties(editionId, _deployedRoyaltiesHandler);
2078     }
2079 
2080     function _setupSalesMechanic(uint256 _editionId, SaleType _saleType, uint128 _startDate, uint128 _basePrice, uint128 _stepPrice) internal {
2081         if (SaleType.BUY_NOW == _saleType) {
2082             marketplace.listForBuyNow(_msgSender(), _editionId, _basePrice, _startDate);
2083         }
2084         else if (SaleType.STEPPED == _saleType) {
2085             marketplace.listSteppedEditionAuction(_msgSender(), _editionId, _basePrice, _stepPrice, _startDate);
2086         }
2087         else if (SaleType.OFFERS == _saleType) {
2088             marketplace.enableEditionOffers(_editionId, _startDate);
2089         } else if (SaleType.RESERVE == _saleType) {
2090             // use base price for reserve price
2091             marketplace.listForReserveAuction(_msgSender(), _editionId, _basePrice, _startDate);
2092         }
2093 
2094         emit EditionMintedAndListed(_editionId, _saleType);
2095     }
2096 
2097     function _setupRoyalties(uint256 _editionId, address _deployedHandler) internal {
2098         if (_deployedHandler != address(0) && address(royaltiesRegistry) != address(0)) {
2099             royaltiesRegistry.useRoyaltiesRecipient(_editionId, _deployedHandler);
2100         }
2101     }
2102 
2103     /// Internal helpers
2104 
2105     function _canCreateNewEdition(address _account) internal view returns (bool) {
2106         // if frequency is overridden then assume they can mint
2107         if (frequencyOverride[_account]) {
2108             return true;
2109         }
2110 
2111         // if within the period range, check remaining allowance
2112         if (_getNow() <= mintingPeriodConfig[_account].firstMintInPeriod + mintingPeriod) {
2113             return mintingPeriodConfig[_account].mints < maxMintsInPeriod;
2114         }
2115 
2116         // if period expired - can mint another one
2117         return true;
2118     }
2119 
2120     function _recordSuccessfulMint(address _account) internal {
2121         MintingPeriod storage period = mintingPeriodConfig[_account];
2122 
2123         uint256 endOfCurrentMintingPeriodLimit = period.firstMintInPeriod + mintingPeriod;
2124 
2125         // if first time use, set the first timestamp to be now abd start counting
2126         if (period.firstMintInPeriod == 0) {
2127             period.firstMintInPeriod = _getNow();
2128             period.mints = period.mints + 1;
2129         }
2130         // if still within the minting period, record the new mint
2131         else if (_getNow() <= endOfCurrentMintingPeriodLimit) {
2132             period.mints = period.mints + 1;
2133         }
2134         // if we are outside of the window reset the limit and record a new single mint
2135         else if (endOfCurrentMintingPeriodLimit < _getNow()) {
2136             period.mints = 1;
2137             period.firstMintInPeriod = _getNow();
2138         }
2139     }
2140 
2141     function _getNow() internal virtual view returns (uint128) {
2142         return uint128(block.timestamp);
2143     }
2144 
2145     /// Public helpers
2146 
2147     function canCreateNewEdition(address _account) public view returns (bool) {
2148         return _canCreateNewEdition(_account);
2149     }
2150 
2151     function currentMintConfig(address _account) public view returns (uint128 mints, uint128 firstMintInPeriod) {
2152         MintingPeriod memory config = mintingPeriodConfig[_account];
2153         return (
2154         config.mints,
2155         config.firstMintInPeriod
2156         );
2157     }
2158 
2159     function setFrequencyOverride(address _account, bool _override) onlyAdmin public {
2160         frequencyOverride[_account] = _override;
2161         emit AdminFrequencyOverrideChanged(_account, _override);
2162     }
2163 
2164     function setMintingPeriod(uint256 _mintingPeriod) onlyAdmin public {
2165         mintingPeriod = _mintingPeriod;
2166         emit AdminMintingPeriodChanged(_mintingPeriod);
2167     }
2168 
2169     function setRoyaltiesRegistry(ICollabRoyaltiesRegistry _royaltiesRegistry) onlyAdmin public {
2170         royaltiesRegistry = _royaltiesRegistry;
2171         emit AdminRoyaltiesRegistryChanged(address(_royaltiesRegistry));
2172     }
2173 
2174     function setMaxMintsInPeriod(uint256 _maxMintsInPeriod) onlyAdmin public {
2175         maxMintsInPeriod = _maxMintsInPeriod;
2176         emit AdminMaxMintsInPeriodChanged(_maxMintsInPeriod);
2177     }
2178 
2179 }