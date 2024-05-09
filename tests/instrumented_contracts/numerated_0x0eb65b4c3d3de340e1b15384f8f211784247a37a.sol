1 // File: contracts/marketplace/IKODAV3Marketplace.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity 0.8.4;
6 
7 interface IBuyNowMarketplace {
8     event ListedForBuyNow(uint256 indexed _id, uint256 _price, address _currentOwner, uint256 _startDate);
9     event BuyNowPriceChanged(uint256 indexed _id, uint256 _price);
10     event BuyNowDeListed(uint256 indexed _id);
11     event BuyNowPurchased(uint256 indexed _tokenId, address _buyer, address _currentOwner, uint256 _price);
12 
13     function listForBuyNow(address _creator, uint256 _id, uint128 _listingPrice, uint128 _startDate) external;
14 
15     function buyEditionToken(uint256 _id) external payable;
16     function buyEditionTokenFor(uint256 _id, address _recipient) external payable;
17 
18     function setBuyNowPriceListing(uint256 _editionId, uint128 _listingPrice) external;
19 }
20 
21 interface IEditionOffersMarketplace {
22     event EditionAcceptingOffer(uint256 indexed _editionId, uint128 _startDate);
23     event EditionBidPlaced(uint256 indexed _editionId, address _bidder, uint256 _amount);
24     event EditionBidWithdrawn(uint256 indexed _editionId, address _bidder);
25     event EditionBidAccepted(uint256 indexed _editionId, uint256 indexed _tokenId, address _bidder, uint256 _amount);
26     event EditionBidRejected(uint256 indexed _editionId, address _bidder, uint256 _amount);
27     event EditionConvertedFromOffersToBuyItNow(uint256 _editionId, uint128 _price, uint128 _startDate);
28 
29     function enableEditionOffers(uint256 _editionId, uint128 _startDate) external;
30 
31     function placeEditionBid(uint256 _editionId) external payable;
32     function placeEditionBidFor(uint256 _editionId, address _bidder) external payable;
33 
34     function withdrawEditionBid(uint256 _editionId) external;
35 
36     function rejectEditionBid(uint256 _editionId) external;
37 
38     function acceptEditionBid(uint256 _editionId, uint256 _offerPrice) external;
39 
40     function convertOffersToBuyItNow(uint256 _editionId, uint128 _listingPrice, uint128 _startDate) external;
41 }
42 
43 interface IEditionSteppedMarketplace {
44     event EditionSteppedSaleListed(uint256 indexed _editionId, uint128 _basePrice, uint128 _stepPrice, uint128 _startDate);
45     event EditionSteppedSaleBuy(uint256 indexed _editionId, uint256 indexed _tokenId, address _buyer, uint256 _price, uint16 _currentStep);
46     event EditionSteppedAuctionUpdated(uint256 indexed _editionId, uint128 _basePrice, uint128 _stepPrice);
47 
48     function listSteppedEditionAuction(address _creator, uint256 _editionId, uint128 _basePrice, uint128 _stepPrice, uint128 _startDate) external;
49 
50     function buyNextStep(uint256 _editionId) external payable;
51     function buyNextStepFor(uint256 _editionId, address _buyer) external payable;
52 
53     function convertSteppedAuctionToListing(uint256 _editionId, uint128 _listingPrice, uint128 _startDate) external;
54 
55     function convertSteppedAuctionToOffers(uint256 _editionId, uint128 _startDate) external;
56 
57     function updateSteppedAuction(uint256 _editionId, uint128 _basePrice, uint128 _stepPrice) external;
58 }
59 
60 interface IReserveAuctionMarketplace {
61     event ListedForReserveAuction(uint256 indexed _id, uint256 _reservePrice, uint128 _startDate);
62     event BidPlacedOnReserveAuction(uint256 indexed _id, address _currentOwner, address _bidder, uint256 _amount, uint256 _originalBiddingEnd, uint256 _currentBiddingEnd);
63     event ReserveAuctionResulted(uint256 indexed _id, uint256 _finalPrice, address _currentOwner, address _winner, address _resulter);
64     event BidWithdrawnFromReserveAuction(uint256 _id, address _bidder, uint128 _bid);
65     event ReservePriceUpdated(uint256 indexed _id, uint256 _reservePrice);
66     event ReserveAuctionConvertedToBuyItNow(uint256 indexed _id, uint128 _listingPrice, uint128 _startDate);
67     event EmergencyBidWithdrawFromReserveAuction(uint256 indexed _id, address _bidder, uint128 _bid);
68 
69     function placeBidOnReserveAuction(uint256 _id) external payable;
70     function placeBidOnReserveAuctionFor(uint256 _id, address _bidder) external payable;
71 
72     function listForReserveAuction(address _creator, uint256 _id, uint128 _reservePrice, uint128 _startDate) external;
73 
74     function resultReserveAuction(uint256 _id) external;
75 
76     function withdrawBidFromReserveAuction(uint256 _id) external;
77 
78     function updateReservePriceForReserveAuction(uint256 _id, uint128 _reservePrice) external;
79 
80     function emergencyExitBidFromReserveAuction(uint256 _id) external;
81 }
82 
83 interface IKODAV3PrimarySaleMarketplace is IEditionSteppedMarketplace, IEditionOffersMarketplace, IBuyNowMarketplace, IReserveAuctionMarketplace {
84     function convertReserveAuctionToBuyItNow(uint256 _editionId, uint128 _listingPrice, uint128 _startDate) external;
85 
86     function convertReserveAuctionToOffers(uint256 _editionId, uint128 _startDate) external;
87 }
88 
89 interface ITokenBuyNowMarketplace {
90     event TokenDeListed(uint256 indexed _tokenId);
91 
92     function delistToken(uint256 _tokenId) external;
93 }
94 
95 interface ITokenOffersMarketplace {
96     event TokenBidPlaced(uint256 indexed _tokenId, address _currentOwner, address _bidder, uint256 _amount);
97     event TokenBidAccepted(uint256 indexed _tokenId, address _currentOwner, address _bidder, uint256 _amount);
98     event TokenBidRejected(uint256 indexed _tokenId, address _currentOwner, address _bidder, uint256 _amount);
99     event TokenBidWithdrawn(uint256 indexed _tokenId, address _bidder);
100 
101     function acceptTokenBid(uint256 _tokenId, uint256 _offerPrice) external;
102 
103     function rejectTokenBid(uint256 _tokenId) external;
104 
105     function withdrawTokenBid(uint256 _tokenId) external;
106 
107     function placeTokenBid(uint256 _tokenId) external payable;
108     function placeTokenBidFor(uint256 _tokenId, address _bidder) external payable;
109 }
110 
111 interface IBuyNowSecondaryMarketplace {
112     function listTokenForBuyNow(uint256 _tokenId, uint128 _listingPrice, uint128 _startDate) external;
113 }
114 
115 interface IEditionOffersSecondaryMarketplace {
116     event EditionBidPlaced(uint256 indexed _editionId, address indexed _bidder, uint256 _bid);
117     event EditionBidWithdrawn(uint256 indexed _editionId, address _bidder);
118     event EditionBidAccepted(uint256 indexed _tokenId, address _currentOwner, address _bidder, uint256 _amount);
119 
120     function placeEditionBid(uint256 _editionId) external payable;
121     function placeEditionBidFor(uint256 _editionId, address _bidder) external payable;
122 
123     function withdrawEditionBid(uint256 _editionId) external;
124 
125     function acceptEditionBid(uint256 _tokenId, uint256 _offerPrice) external;
126 }
127 
128 interface IKODAV3SecondarySaleMarketplace is ITokenBuyNowMarketplace, ITokenOffersMarketplace, IEditionOffersSecondaryMarketplace, IBuyNowSecondaryMarketplace {
129     function convertReserveAuctionToBuyItNow(uint256 _tokenId, uint128 _listingPrice, uint128 _startDate) external;
130 
131     function convertReserveAuctionToOffers(uint256 _tokenId) external;
132 }
133 
134 // File: contracts/access/IKOAccessControlsLookup.sol
135 
136 
137 
138 pragma solidity 0.8.4;
139 
140 interface IKOAccessControlsLookup {
141     function hasAdminRole(address _address) external view returns (bool);
142 
143     function isVerifiedArtist(uint256 _index, address _account, bytes32[] calldata _merkleProof) external view returns (bool);
144 
145     function isVerifiedArtistProxy(address _artist, address _proxy) external view returns (bool);
146 
147     function hasLegacyMinterRole(address _address) external view returns (bool);
148 
149     function hasContractRole(address _address) external view returns (bool);
150 
151     function hasContractOrAdminRole(address _address) external view returns (bool);
152 }
153 
154 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
155 
156 
157 
158 pragma solidity ^0.8.0;
159 
160 /**
161  * @dev Interface of the ERC165 standard, as defined in the
162  * https://eips.ethereum.org/EIPS/eip-165[EIP].
163  *
164  * Implementers can declare support of contract interfaces, which can then be
165  * queried by others ({ERC165Checker}).
166  *
167  * For an implementation, see {ERC165}.
168  */
169 interface IERC165 {
170     /**
171      * @dev Returns true if this contract implements the interface defined by
172      * `interfaceId`. See the corresponding
173      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
174      * to learn more about how these ids are created.
175      *
176      * This function call must use less than 30 000 gas.
177      */
178     function supportsInterface(bytes4 interfaceId) external view returns (bool);
179 }
180 
181 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
182 
183 
184 
185 pragma solidity ^0.8.0;
186 
187 
188 /**
189  * @dev Required interface of an ERC721 compliant contract.
190  */
191 interface IERC721 is IERC165 {
192     /**
193      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
194      */
195     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
196 
197     /**
198      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
199      */
200     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
201 
202     /**
203      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
204      */
205     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
206 
207     /**
208      * @dev Returns the number of tokens in ``owner``'s account.
209      */
210     function balanceOf(address owner) external view returns (uint256 balance);
211 
212     /**
213      * @dev Returns the owner of the `tokenId` token.
214      *
215      * Requirements:
216      *
217      * - `tokenId` must exist.
218      */
219     function ownerOf(uint256 tokenId) external view returns (address owner);
220 
221     /**
222      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
223      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
224      *
225      * Requirements:
226      *
227      * - `from` cannot be the zero address.
228      * - `to` cannot be the zero address.
229      * - `tokenId` token must exist and be owned by `from`.
230      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
231      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
232      *
233      * Emits a {Transfer} event.
234      */
235     function safeTransferFrom(
236         address from,
237         address to,
238         uint256 tokenId
239     ) external;
240 
241     /**
242      * @dev Transfers `tokenId` token from `from` to `to`.
243      *
244      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
245      *
246      * Requirements:
247      *
248      * - `from` cannot be the zero address.
249      * - `to` cannot be the zero address.
250      * - `tokenId` token must be owned by `from`.
251      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
252      *
253      * Emits a {Transfer} event.
254      */
255     function transferFrom(
256         address from,
257         address to,
258         uint256 tokenId
259     ) external;
260 
261     /**
262      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
263      * The approval is cleared when the token is transferred.
264      *
265      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
266      *
267      * Requirements:
268      *
269      * - The caller must own the token or be an approved operator.
270      * - `tokenId` must exist.
271      *
272      * Emits an {Approval} event.
273      */
274     function approve(address to, uint256 tokenId) external;
275 
276     /**
277      * @dev Returns the account approved for `tokenId` token.
278      *
279      * Requirements:
280      *
281      * - `tokenId` must exist.
282      */
283     function getApproved(uint256 tokenId) external view returns (address operator);
284 
285     /**
286      * @dev Approve or remove `operator` as an operator for the caller.
287      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
288      *
289      * Requirements:
290      *
291      * - The `operator` cannot be the caller.
292      *
293      * Emits an {ApprovalForAll} event.
294      */
295     function setApprovalForAll(address operator, bool _approved) external;
296 
297     /**
298      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
299      *
300      * See {setApprovalForAll}
301      */
302     function isApprovedForAll(address owner, address operator) external view returns (bool);
303 
304     /**
305      * @dev Safely transfers `tokenId` token from `from` to `to`.
306      *
307      * Requirements:
308      *
309      * - `from` cannot be the zero address.
310      * - `to` cannot be the zero address.
311      * - `tokenId` token must exist and be owned by `from`.
312      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
313      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
314      *
315      * Emits a {Transfer} event.
316      */
317     function safeTransferFrom(
318         address from,
319         address to,
320         uint256 tokenId,
321         bytes calldata data
322     ) external;
323 }
324 
325 // File: contracts/core/IERC2309.sol
326 
327 
328 
329 pragma solidity 0.8.4;
330 
331 /**
332   @title ERC-2309: ERC-721 Batch Mint Extension
333   @dev https://github.com/ethereum/EIPs/issues/2309
334  */
335 interface IERC2309 {
336     /**
337       @notice This event is emitted when ownership of a batch of tokens changes by any mechanism.
338       This includes minting, transferring, and burning.
339 
340       @dev The address executing the transaction MUST own all the tokens within the range of
341       fromTokenId and toTokenId, or MUST be an approved operator to act on the owners behalf.
342       The fromTokenId and toTokenId MUST be a sequential range of tokens IDs.
343       When minting/creating tokens, the `fromAddress` argument MUST be set to `0x0` (i.e. zero address).
344       When burning/destroying tokens, the `toAddress` argument MUST be set to `0x0` (i.e. zero address).
345 
346       @param fromTokenId The token ID that begins the batch of tokens being transferred
347       @param toTokenId The token ID that ends the batch of tokens being transferred
348       @param fromAddress The address transferring ownership of the specified range of tokens
349       @param toAddress The address receiving ownership of the specified range of tokens.
350     */
351     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed fromAddress, address indexed toAddress);
352 }
353 
354 // File: contracts/core/IERC2981.sol
355 
356 
357 
358 pragma solidity 0.8.4;
359 
360 
361 /// @notice This is purely an extension for the KO platform
362 /// @notice Royalties on KO are defined at an edition level for all tokens from the same edition
363 interface IERC2981EditionExtension {
364 
365     /// @notice Does the edition have any royalties defined
366     function hasRoyalties(uint256 _editionId) external view returns (bool);
367 
368     /// @notice Get the royalty receiver - all royalties should be sent to this account if not zero address
369     function getRoyaltiesReceiver(uint256 _editionId) external view returns (address);
370 }
371 
372 /**
373  * ERC2981 standards interface for royalties
374  */
375 interface IERC2981 is IERC165, IERC2981EditionExtension {
376     /// ERC165 bytes to add to interface array - set in parent contract
377     /// implementing this standard
378     ///
379     /// bytes4(keccak256("royaltyInfo(uint256,uint256)")) == 0x2a55205a
380     /// bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
381     /// _registerInterface(_INTERFACE_ID_ERC2981);
382 
383     /// @notice Called with the sale price to determine how much royalty
384     //          is owed and to whom.
385     /// @param _tokenId - the NFT asset queried for royalty information
386     /// @param _value - the sale price of the NFT asset specified by _tokenId
387     /// @return _receiver - address of who should be sent the royalty payment
388     /// @return _royaltyAmount - the royalty payment amount for _value sale price
389     function royaltyInfo(
390         uint256 _tokenId,
391         uint256 _value
392     ) external view returns (
393         address _receiver,
394         uint256 _royaltyAmount
395     );
396 
397 }
398 
399 // File: contracts/core/IHasSecondarySaleFees.sol
400 
401 
402 
403 pragma solidity 0.8.4;
404 
405 
406 /// @title Royalties formats required for use on the Rarible platform
407 /// @dev https://docs.rarible.com/asset/royalties-schema
408 interface IHasSecondarySaleFees is IERC165 {
409 
410     event SecondarySaleFees(uint256 tokenId, address[] recipients, uint[] bps);
411 
412     function getFeeRecipients(uint256 id) external returns (address payable[] memory);
413 
414     function getFeeBps(uint256 id) external returns (uint[] memory);
415 }
416 
417 // File: contracts/core/IKODAV3.sol
418 
419 
420 
421 pragma solidity 0.8.4;
422 
423 
424 
425 
426 
427 
428 /// @title Core KODA V3 functionality
429 interface IKODAV3 is
430 IERC165, // Contract introspection
431 IERC721, // Core NFTs
432 IERC2309, // Consecutive batch mint
433 IERC2981, // Royalties
434 IHasSecondarySaleFees // Rariable / Foundation royalties
435 {
436     // edition utils
437 
438     function getCreatorOfEdition(uint256 _editionId) external view returns (address _originalCreator);
439 
440     function getCreatorOfToken(uint256 _tokenId) external view returns (address _originalCreator);
441 
442     function getSizeOfEdition(uint256 _editionId) external view returns (uint256 _size);
443 
444     function getEditionSizeOfToken(uint256 _tokenId) external view returns (uint256 _size);
445 
446     function editionExists(uint256 _editionId) external view returns (bool);
447 
448     // Has the edition been disabled / soft burnt
449     function isEditionSalesDisabled(uint256 _editionId) external view returns (bool);
450 
451     // Has the edition been disabled / soft burnt OR sold out
452     function isSalesDisabledOrSoldOut(uint256 _editionId) external view returns (bool);
453 
454     // Work out the max token ID for an edition ID
455     function maxTokenIdOfEdition(uint256 _editionId) external view returns (uint256 _tokenId);
456 
457     // Helper method for getting the next primary sale token from an edition starting low to high token IDs
458     function getNextAvailablePrimarySaleToken(uint256 _editionId) external returns (uint256 _tokenId);
459 
460     // Helper method for getting the next primary sale token from an edition starting high to low token IDs
461     function getReverseAvailablePrimarySaleToken(uint256 _editionId) external view returns (uint256 _tokenId);
462 
463     // Utility method to get all data needed for the next primary sale, low token ID to high
464     function facilitateNextPrimarySale(uint256 _editionId) external returns (address _receiver, address _creator, uint256 _tokenId);
465 
466     // Utility method to get all data needed for the next primary sale, high token ID to low
467     function facilitateReversePrimarySale(uint256 _editionId) external returns (address _receiver, address _creator, uint256 _tokenId);
468 
469     // Expanded royalty method for the edition, not token
470     function royaltyAndCreatorInfo(uint256 _editionId, uint256 _value) external returns (address _receiver, address _creator, uint256 _amount);
471 
472     // Allows the creator to correct mistakes until the first token from an edition is sold
473     function updateURIIfNoSaleMade(uint256 _editionId, string calldata _newURI) external;
474 
475     // Has any primary transfer happened from an edition
476     function hasMadePrimarySale(uint256 _editionId) external view returns (bool);
477 
478     // Has the edition sold out
479     function isEditionSoldOut(uint256 _editionId) external view returns (bool);
480 
481     // Toggle on/off the edition from being able to make sales
482     function toggleEditionSalesDisabled(uint256 _editionId) external;
483 
484     // token utils
485 
486     function exists(uint256 _tokenId) external view returns (bool);
487 
488     function getEditionIdOfToken(uint256 _tokenId) external pure returns (uint256 _editionId);
489 
490     function getEditionDetails(uint256 _tokenId) external view returns (address _originalCreator, address _owner, uint16 _size, uint256 _editionId, string memory _uri);
491 
492     function hadPrimarySaleOfToken(uint256 _tokenId) external view returns (bool);
493 
494 }
495 
496 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
497 
498 
499 
500 pragma solidity ^0.8.0;
501 
502 /**
503  * @dev Contract module that helps prevent reentrant calls to a function.
504  *
505  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
506  * available, which can be applied to functions to make sure there are no nested
507  * (reentrant) calls to them.
508  *
509  * Note that because there is a single `nonReentrant` guard, functions marked as
510  * `nonReentrant` may not call one another. This can be worked around by making
511  * those functions `private`, and then adding `external` `nonReentrant` entry
512  * points to them.
513  *
514  * TIP: If you would like to learn more about reentrancy and alternative ways
515  * to protect against it, check out our blog post
516  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
517  */
518 abstract contract ReentrancyGuard {
519     // Booleans are more expensive than uint256 or any type that takes up a full
520     // word because each write operation emits an extra SLOAD to first read the
521     // slot's contents, replace the bits taken up by the boolean, and then write
522     // back. This is the compiler's defense against contract upgrades and
523     // pointer aliasing, and it cannot be disabled.
524 
525     // The values being non-zero value makes deployment a bit more expensive,
526     // but in exchange the refund on every call to nonReentrant will be lower in
527     // amount. Since refunds are capped to a percentage of the total
528     // transaction's gas, it is best to keep them low in cases like this one, to
529     // increase the likelihood of the full refund coming into effect.
530     uint256 private constant _NOT_ENTERED = 1;
531     uint256 private constant _ENTERED = 2;
532 
533     uint256 private _status;
534 
535     constructor() {
536         _status = _NOT_ENTERED;
537     }
538 
539     /**
540      * @dev Prevents a contract from calling itself, directly or indirectly.
541      * Calling a `nonReentrant` function from another `nonReentrant`
542      * function is not supported. It is possible to prevent this from happening
543      * by making the `nonReentrant` function external, and make it call a
544      * `private` function that does the actual work.
545      */
546     modifier nonReentrant() {
547         // On the first call to nonReentrant, _notEntered will be true
548         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
549 
550         // Any calls to nonReentrant after this point will fail
551         _status = _ENTERED;
552 
553         _;
554 
555         // By storing the original value once again, a refund is triggered (see
556         // https://eips.ethereum.org/EIPS/eip-2200)
557         _status = _NOT_ENTERED;
558     }
559 }
560 
561 // File: @openzeppelin/contracts/utils/Context.sol
562 
563 
564 
565 pragma solidity ^0.8.0;
566 
567 /*
568  * @dev Provides information about the current execution context, including the
569  * sender of the transaction and its data. While these are generally available
570  * via msg.sender and msg.data, they should not be accessed in such a direct
571  * manner, since when dealing with meta-transactions the account sending and
572  * paying for execution may not be the actual sender (as far as an application
573  * is concerned).
574  *
575  * This contract is only required for intermediate, library-like contracts.
576  */
577 abstract contract Context {
578     function _msgSender() internal view virtual returns (address) {
579         return msg.sender;
580     }
581 
582     function _msgData() internal view virtual returns (bytes calldata) {
583         return msg.data;
584     }
585 }
586 
587 // File: @openzeppelin/contracts/security/Pausable.sol
588 
589 
590 
591 pragma solidity ^0.8.0;
592 
593 
594 /**
595  * @dev Contract module which allows children to implement an emergency stop
596  * mechanism that can be triggered by an authorized account.
597  *
598  * This module is used through inheritance. It will make available the
599  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
600  * the functions of your contract. Note that they will not be pausable by
601  * simply including this module, only once the modifiers are put in place.
602  */
603 abstract contract Pausable is Context {
604     /**
605      * @dev Emitted when the pause is triggered by `account`.
606      */
607     event Paused(address account);
608 
609     /**
610      * @dev Emitted when the pause is lifted by `account`.
611      */
612     event Unpaused(address account);
613 
614     bool private _paused;
615 
616     /**
617      * @dev Initializes the contract in unpaused state.
618      */
619     constructor() {
620         _paused = false;
621     }
622 
623     /**
624      * @dev Returns true if the contract is paused, and false otherwise.
625      */
626     function paused() public view virtual returns (bool) {
627         return _paused;
628     }
629 
630     /**
631      * @dev Modifier to make a function callable only when the contract is not paused.
632      *
633      * Requirements:
634      *
635      * - The contract must not be paused.
636      */
637     modifier whenNotPaused() {
638         require(!paused(), "Pausable: paused");
639         _;
640     }
641 
642     /**
643      * @dev Modifier to make a function callable only when the contract is paused.
644      *
645      * Requirements:
646      *
647      * - The contract must be paused.
648      */
649     modifier whenPaused() {
650         require(paused(), "Pausable: not paused");
651         _;
652     }
653 
654     /**
655      * @dev Triggers stopped state.
656      *
657      * Requirements:
658      *
659      * - The contract must not be paused.
660      */
661     function _pause() internal virtual whenNotPaused {
662         _paused = true;
663         emit Paused(_msgSender());
664     }
665 
666     /**
667      * @dev Returns to normal state.
668      *
669      * Requirements:
670      *
671      * - The contract must be paused.
672      */
673     function _unpause() internal virtual whenPaused {
674         _paused = false;
675         emit Unpaused(_msgSender());
676     }
677 }
678 
679 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
680 
681 
682 
683 pragma solidity ^0.8.0;
684 
685 /**
686  * @dev Interface of the ERC20 standard as defined in the EIP.
687  */
688 interface IERC20 {
689     /**
690      * @dev Returns the amount of tokens in existence.
691      */
692     function totalSupply() external view returns (uint256);
693 
694     /**
695      * @dev Returns the amount of tokens owned by `account`.
696      */
697     function balanceOf(address account) external view returns (uint256);
698 
699     /**
700      * @dev Moves `amount` tokens from the caller's account to `recipient`.
701      *
702      * Returns a boolean value indicating whether the operation succeeded.
703      *
704      * Emits a {Transfer} event.
705      */
706     function transfer(address recipient, uint256 amount) external returns (bool);
707 
708     /**
709      * @dev Returns the remaining number of tokens that `spender` will be
710      * allowed to spend on behalf of `owner` through {transferFrom}. This is
711      * zero by default.
712      *
713      * This value changes when {approve} or {transferFrom} are called.
714      */
715     function allowance(address owner, address spender) external view returns (uint256);
716 
717     /**
718      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
719      *
720      * Returns a boolean value indicating whether the operation succeeded.
721      *
722      * IMPORTANT: Beware that changing an allowance with this method brings the risk
723      * that someone may use both the old and the new allowance by unfortunate
724      * transaction ordering. One possible solution to mitigate this race
725      * condition is to first reduce the spender's allowance to 0 and set the
726      * desired value afterwards:
727      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
728      *
729      * Emits an {Approval} event.
730      */
731     function approve(address spender, uint256 amount) external returns (bool);
732 
733     /**
734      * @dev Moves `amount` tokens from `sender` to `recipient` using the
735      * allowance mechanism. `amount` is then deducted from the caller's
736      * allowance.
737      *
738      * Returns a boolean value indicating whether the operation succeeded.
739      *
740      * Emits a {Transfer} event.
741      */
742     function transferFrom(
743         address sender,
744         address recipient,
745         uint256 amount
746     ) external returns (bool);
747 
748     /**
749      * @dev Emitted when `value` tokens are moved from one account (`from`) to
750      * another (`to`).
751      *
752      * Note that `value` may be zero.
753      */
754     event Transfer(address indexed from, address indexed to, uint256 value);
755 
756     /**
757      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
758      * a call to {approve}. `value` is the new allowance.
759      */
760     event Approval(address indexed owner, address indexed spender, uint256 value);
761 }
762 
763 // File: contracts/marketplace/BaseMarketplace.sol
764 
765 
766 
767 pragma solidity 0.8.4;
768 
769 
770 
771 
772 
773 
774 /// @notice Core logic and state shared between both marketplaces
775 abstract contract BaseMarketplace is ReentrancyGuard, Pausable {
776 
777     event AdminUpdateModulo(uint256 _modulo);
778     event AdminUpdateMinBidAmount(uint256 _minBidAmount);
779     event AdminUpdateAccessControls(IKOAccessControlsLookup indexed _oldAddress, IKOAccessControlsLookup indexed _newAddress);
780     event AdminUpdatePlatformPrimarySaleCommission(uint256 _platformPrimarySaleCommission);
781     event AdminUpdateBidLockupPeriod(uint256 _bidLockupPeriod);
782     event AdminUpdatePlatformAccount(address indexed _oldAddress, address indexed _newAddress);
783     event AdminRecoverERC20(IERC20 indexed _token, address indexed _recipient, uint256 _amount);
784     event AdminRecoverETH(address payable indexed _recipient, uint256 _amount);
785 
786     event BidderRefunded(uint256 indexed _id, address _bidder, uint256 _bid, address _newBidder, uint256 _newOffer);
787     event BidderRefundedFailed(uint256 indexed _id, address _bidder, uint256 _bid, address _newBidder, uint256 _newOffer);
788 
789     // Only a whitelisted smart contract in the access controls contract
790     modifier onlyContract() {
791         _onlyContract();
792         _;
793     }
794 
795     function _onlyContract() private view {
796         require(accessControls.hasContractRole(_msgSender()), "Caller not contract");
797     }
798 
799     // Only admin defined in the access controls contract
800     modifier onlyAdmin() {
801         _onlyAdmin();
802         _;
803     }
804 
805     function _onlyAdmin() private view {
806         require(accessControls.hasAdminRole(_msgSender()), "Caller not admin");
807     }
808 
809     /// @notice Address of the access control contract
810     IKOAccessControlsLookup public accessControls;
811 
812     /// @notice KODA V3 token
813     IKODAV3 public koda;
814 
815     /// @notice platform funds collector
816     address public platformAccount;
817 
818     /// @notice precision 100.00000%
819     uint256 public modulo = 100_00000;
820 
821     /// @notice Minimum bid / minimum list amount
822     uint256 public minBidAmount = 0.01 ether;
823 
824     /// @notice Bid lockup period
825     uint256 public bidLockupPeriod = 6 hours;
826 
827     constructor(IKOAccessControlsLookup _accessControls, IKODAV3 _koda, address _platformAccount) {
828         koda = _koda;
829         accessControls = _accessControls;
830         platformAccount = _platformAccount;
831     }
832 
833     function recoverERC20(IERC20 _token, address _recipient, uint256 _amount) public onlyAdmin {
834         _token.transfer(_recipient, _amount);
835         emit AdminRecoverERC20(_token, _recipient, _amount);
836     }
837 
838     function recoverStuckETH(address payable _recipient, uint256 _amount) public onlyAdmin {
839         (bool success,) = _recipient.call{value : _amount}("");
840         require(success, "Unable to send recipient ETH");
841         emit AdminRecoverETH(_recipient, _amount);
842     }
843 
844     function updateAccessControls(IKOAccessControlsLookup _accessControls) public onlyAdmin {
845         require(_accessControls.hasAdminRole(_msgSender()), "Sender must have admin role in new contract");
846         emit AdminUpdateAccessControls(accessControls, _accessControls);
847         accessControls = _accessControls;
848     }
849 
850     function updateModulo(uint256 _modulo) public onlyAdmin {
851         require(_modulo > 0, "Modulo point cannot be zero");
852         modulo = _modulo;
853         emit AdminUpdateModulo(_modulo);
854     }
855 
856     function updateMinBidAmount(uint256 _minBidAmount) public onlyAdmin {
857         minBidAmount = _minBidAmount;
858         emit AdminUpdateMinBidAmount(_minBidAmount);
859     }
860 
861     function updateBidLockupPeriod(uint256 _bidLockupPeriod) public onlyAdmin {
862         bidLockupPeriod = _bidLockupPeriod;
863         emit AdminUpdateBidLockupPeriod(_bidLockupPeriod);
864     }
865 
866     function updatePlatformAccount(address _newPlatformAccount) public onlyAdmin {
867         emit AdminUpdatePlatformAccount(platformAccount, _newPlatformAccount);
868         platformAccount = _newPlatformAccount;
869     }
870 
871     function pause() public onlyAdmin {
872         super._pause();
873     }
874 
875     function unpause() public onlyAdmin {
876         super._unpause();
877     }
878 
879     function _getLockupTime() internal view returns (uint256 lockupUntil) {
880         lockupUntil = block.timestamp + bidLockupPeriod;
881     }
882 
883     function _refundBidder(uint256 _id, address _receiver, uint256 _paymentAmount, address _newBidder, uint256 _newOffer) internal {
884         (bool success,) = _receiver.call{value : _paymentAmount}("");
885         if (!success) {
886             emit BidderRefundedFailed(_id, _receiver, _paymentAmount, _newBidder, _newOffer);
887         } else {
888             emit BidderRefunded(_id, _receiver, _paymentAmount, _newBidder, _newOffer);
889         }
890     }
891 
892     /// @dev This allows the processing of a marketplace sale to be delegated higher up the inheritance hierarchy
893     function _processSale(
894         uint256 _id,
895         uint256 _paymentAmount,
896         address _buyer,
897         address _seller
898     ) internal virtual returns (uint256);
899 
900     /// @dev This allows an auction mechanic to ask a marketplace if a new listing is permitted i.e. this could be false if the edition or token is already listed under a different mechanic
901     function _isListingPermitted(uint256 _id) internal virtual returns (bool);
902 }
903 
904 // File: contracts/marketplace/BuyNowMarketplace.sol
905 
906 
907 
908 pragma solidity 0.8.4;
909 
910 
911 
912 // "buy now" sale flow
913 abstract contract BuyNowMarketplace is IBuyNowMarketplace, BaseMarketplace {
914     // Buy now listing definition
915     struct Listing {
916         uint128 price;
917         uint128 startDate;
918         address seller;
919     }
920 
921     /// @notice Edition or Token ID to Listing
922     mapping(uint256 => Listing) public editionOrTokenListings;
923 
924     // list edition with "buy now" price and start date
925     function listForBuyNow(address _seller, uint256 _id, uint128 _listingPrice, uint128 _startDate)
926     public
927     override
928     whenNotPaused {
929         require(_isListingPermitted(_id), "Listing is not permitted");
930         require(_isBuyNowListingPermitted(_id), "Buy now listing invalid");
931         require(_listingPrice >= minBidAmount, "Listing price not enough");
932 
933         // Store listing data
934         editionOrTokenListings[_id] = Listing(_listingPrice, _startDate, _seller);
935 
936         emit ListedForBuyNow(_id, _listingPrice, _seller, _startDate);
937     }
938 
939     // Buy an token from the edition on the primary market
940     function buyEditionToken(uint256 _id)
941     public
942     override
943     payable
944     whenNotPaused
945     nonReentrant {
946         _facilitateBuyNow(_id, _msgSender());
947     }
948 
949     // Buy an token from the edition on the primary market, ability to define the recipient
950     function buyEditionTokenFor(uint256 _id, address _recipient)
951     public
952     override
953     payable
954     whenNotPaused
955     nonReentrant {
956         _facilitateBuyNow(_id, _recipient);
957     }
958 
959     // update the "buy now" price
960     function setBuyNowPriceListing(uint256 _id, uint128 _listingPrice)
961     public
962     override
963     whenNotPaused {
964         require(
965             editionOrTokenListings[_id].seller == _msgSender()
966             || accessControls.isVerifiedArtistProxy(editionOrTokenListings[_id].seller, _msgSender()),
967             "Only seller can change price"
968         );
969 
970         // Set price
971         editionOrTokenListings[_id].price = _listingPrice;
972 
973         // Emit event
974         emit BuyNowPriceChanged(_id, _listingPrice);
975     }
976 
977     function _facilitateBuyNow(uint256 _id, address _recipient) internal {
978         Listing storage listing = editionOrTokenListings[_id];
979         require(address(0) != listing.seller, "No listing found");
980         require(msg.value >= listing.price, "List price not satisfied");
981         require(block.timestamp >= listing.startDate, "List not available yet");
982 
983         uint256 tokenId = _processSale(_id, msg.value, _recipient, listing.seller);
984 
985         emit BuyNowPurchased(tokenId, _recipient, listing.seller, msg.value);
986     }
987 
988     function _isBuyNowListingPermitted(uint256 _id) internal virtual returns (bool);
989 }
990 
991 // File: contracts/marketplace/ReserveAuctionMarketplace.sol
992 
993 
994 
995 pragma solidity 0.8.4;
996 
997 
998 
999 
1000 
1001 abstract contract ReserveAuctionMarketplace is IReserveAuctionMarketplace, BaseMarketplace {
1002     event AdminUpdateReserveAuctionBidExtensionWindow(uint128 _reserveAuctionBidExtensionWindow);
1003     event AdminUpdateReserveAuctionLengthOnceReserveMet(uint128 _reserveAuctionLengthOnceReserveMet);
1004 
1005     // Reserve auction definition
1006     struct ReserveAuction {
1007         address seller;
1008         address bidder;
1009         uint128 reservePrice;
1010         uint128 bid;
1011         uint128 startDate;
1012         uint128 biddingEnd;
1013     }
1014 
1015     /// @notice 1 of 1 edition ID to reserve auction definition
1016     mapping(uint256 => ReserveAuction) public editionOrTokenWithReserveAuctions;
1017 
1018     /// @notice A reserve auction will be extended by this amount of time if a bid is received near the end
1019     uint128 public reserveAuctionBidExtensionWindow = 15 minutes;
1020 
1021     /// @notice Length that bidding window remains open once the reserve price for an auction has been met
1022     uint128 public reserveAuctionLengthOnceReserveMet = 24 hours;
1023 
1024     function listForReserveAuction(
1025         address _creator,
1026         uint256 _id,
1027         uint128 _reservePrice,
1028         uint128 _startDate
1029     ) public
1030     override
1031     whenNotPaused {
1032         require(_isListingPermitted(_id), "Listing not permitted");
1033         require(_isReserveListingPermitted(_id), "Reserve listing not permitted");
1034         require(_reservePrice >= minBidAmount, "Reserve price must be at least min bid");
1035 
1036         editionOrTokenWithReserveAuctions[_id] = ReserveAuction({
1037         seller : _creator,
1038         bidder : address(0),
1039         reservePrice : _reservePrice,
1040         startDate : _startDate,
1041         biddingEnd : 0,
1042         bid : 0
1043         });
1044 
1045         emit ListedForReserveAuction(_id, _reservePrice, _startDate);
1046     }
1047 
1048     function placeBidOnReserveAuction(uint256 _id)
1049     public
1050     override
1051     payable
1052     whenNotPaused
1053     nonReentrant {
1054         _placeBidOnReserveAuction(_id, _msgSender());
1055     }
1056 
1057     function placeBidOnReserveAuctionFor(uint256 _id, address _bidder)
1058     public
1059     override
1060     payable
1061     whenNotPaused
1062     nonReentrant {
1063         _placeBidOnReserveAuction(_id, _bidder);
1064     }
1065 
1066     function _placeBidOnReserveAuction(uint256 _id, address _bidder) internal {
1067         ReserveAuction storage reserveAuction = editionOrTokenWithReserveAuctions[_id];
1068         require(reserveAuction.reservePrice > 0, "Not set up for reserve auction");
1069         require(block.timestamp >= reserveAuction.startDate, "Not accepting bids yet");
1070         require(msg.value >= reserveAuction.bid + minBidAmount, "You have not exceeded previous bid by min bid amount");
1071 
1072         uint128 originalBiddingEnd = reserveAuction.biddingEnd;
1073 
1074         // If the reserve has been met, then bidding will end in 24 hours
1075         // if we are near the end, we have bids, then extend the bidding end
1076         bool isCountDownTriggered = originalBiddingEnd > 0;
1077 
1078         if (msg.value >= reserveAuction.reservePrice && !isCountDownTriggered) {
1079             reserveAuction.biddingEnd = uint128(block.timestamp) + reserveAuctionLengthOnceReserveMet;
1080         }
1081         else if (isCountDownTriggered) {
1082 
1083             // if a bid has been placed, then we will have a bidding end timestamp
1084             // and we need to ensure no one can bid beyond this
1085             require(block.timestamp < originalBiddingEnd, "No longer accepting bids");
1086             uint128 secondsUntilBiddingEnd = originalBiddingEnd - uint128(block.timestamp);
1087 
1088             // If bid received with in the extension window, extend bidding end
1089             if (secondsUntilBiddingEnd <= reserveAuctionBidExtensionWindow) {
1090                 reserveAuction.biddingEnd = reserveAuction.biddingEnd + reserveAuctionBidExtensionWindow;
1091             }
1092         }
1093 
1094         // if someone else has previously bid, there is a bid we need to refund
1095         if (reserveAuction.bid > 0) {
1096             _refundBidder(_id, reserveAuction.bidder, reserveAuction.bid, _bidder, msg.value);
1097         }
1098 
1099         reserveAuction.bid = uint128(msg.value);
1100         reserveAuction.bidder = _bidder;
1101 
1102         emit BidPlacedOnReserveAuction(_id, reserveAuction.seller, _bidder, msg.value, originalBiddingEnd, reserveAuction.biddingEnd);
1103     }
1104 
1105     function resultReserveAuction(uint256 _id)
1106     public
1107     override
1108     whenNotPaused
1109     nonReentrant {
1110         ReserveAuction storage reserveAuction = editionOrTokenWithReserveAuctions[_id];
1111 
1112         require(reserveAuction.reservePrice > 0, "No active auction");
1113         require(reserveAuction.bid >= reserveAuction.reservePrice, "Reserve not met");
1114         require(block.timestamp > reserveAuction.biddingEnd, "Bidding has not yet ended");
1115 
1116         // N:B. anyone can result the action as only the winner and seller are compensated
1117 
1118         address winner = reserveAuction.bidder;
1119         address seller = reserveAuction.seller;
1120         uint256 winningBid = reserveAuction.bid;
1121         delete editionOrTokenWithReserveAuctions[_id];
1122 
1123         _processSale(_id, winningBid, winner, seller);
1124 
1125         emit ReserveAuctionResulted(_id, winningBid, seller, winner, _msgSender());
1126     }
1127 
1128     // Only permit bid withdrawals if reserve not met
1129     function withdrawBidFromReserveAuction(uint256 _id)
1130     public
1131     override
1132     whenNotPaused
1133     nonReentrant {
1134         ReserveAuction storage reserveAuction = editionOrTokenWithReserveAuctions[_id];
1135 
1136         require(reserveAuction.reservePrice > 0, "No reserve auction in flight");
1137         require(reserveAuction.bid < reserveAuction.reservePrice, "Bids can only be withdrawn if reserve not met");
1138         require(reserveAuction.bidder == _msgSender(), "Only the bidder can withdraw their bid");
1139 
1140         uint256 bidToRefund = reserveAuction.bid;
1141         _refundBidder(_id, reserveAuction.bidder, bidToRefund, address(0), 0);
1142 
1143         reserveAuction.bidder = address(0);
1144         reserveAuction.bid = 0;
1145 
1146         emit BidWithdrawnFromReserveAuction(_id, _msgSender(), uint128(bidToRefund));
1147     }
1148 
1149     // can only do this if the reserve has not been met
1150     function updateReservePriceForReserveAuction(uint256 _id, uint128 _reservePrice)
1151     public
1152     override
1153     whenNotPaused
1154     nonReentrant {
1155         ReserveAuction storage reserveAuction = editionOrTokenWithReserveAuctions[_id];
1156 
1157         require(
1158             reserveAuction.seller == _msgSender()
1159             || accessControls.isVerifiedArtistProxy(reserveAuction.seller, _msgSender()),
1160             "Not the seller"
1161         );
1162 
1163         require(reserveAuction.biddingEnd == 0, "Reserve countdown commenced");
1164         require(_reservePrice >= minBidAmount, "Reserve must be at least min bid");
1165 
1166         // Trigger countdown if new reserve price is greater than any current bids
1167         if (reserveAuction.bid >= _reservePrice) {
1168             reserveAuction.biddingEnd = uint128(block.timestamp) + reserveAuctionLengthOnceReserveMet;
1169         }
1170 
1171         reserveAuction.reservePrice = _reservePrice;
1172 
1173         emit ReservePriceUpdated(_id, _reservePrice);
1174     }
1175 
1176     function emergencyExitBidFromReserveAuction(uint256 _id)
1177     public
1178     override
1179     whenNotPaused
1180     nonReentrant {
1181         ReserveAuction storage reserveAuction = editionOrTokenWithReserveAuctions[_id];
1182 
1183         require(reserveAuction.bid > 0, "No bid in flight");
1184         require(_hasReserveListingBeenInvalidated(_id), "Bid cannot be withdrawn as reserve auction listing is valid");
1185 
1186         bool isSeller = reserveAuction.seller == _msgSender();
1187         bool isBidder = reserveAuction.bidder == _msgSender();
1188         require(
1189             isSeller
1190             || isBidder
1191             || accessControls.isVerifiedArtistProxy(reserveAuction.seller, _msgSender())
1192             || accessControls.hasContractOrAdminRole(_msgSender()),
1193             "Only seller, bidder, contract or platform admin"
1194         );
1195         // external call done last as a gas optimisation i.e. it wont be called if isSeller || isBidder is true
1196 
1197         _refundBidder(_id, reserveAuction.bidder, reserveAuction.bid, address(0), 0);
1198 
1199         emit EmergencyBidWithdrawFromReserveAuction(_id, reserveAuction.bidder, reserveAuction.bid);
1200 
1201         delete editionOrTokenWithReserveAuctions[_id];
1202     }
1203 
1204     function updateReserveAuctionBidExtensionWindow(uint128 _reserveAuctionBidExtensionWindow) onlyAdmin public {
1205         reserveAuctionBidExtensionWindow = _reserveAuctionBidExtensionWindow;
1206         emit AdminUpdateReserveAuctionBidExtensionWindow(_reserveAuctionBidExtensionWindow);
1207     }
1208 
1209     function updateReserveAuctionLengthOnceReserveMet(uint128 _reserveAuctionLengthOnceReserveMet) onlyAdmin public {
1210         reserveAuctionLengthOnceReserveMet = _reserveAuctionLengthOnceReserveMet;
1211         emit AdminUpdateReserveAuctionLengthOnceReserveMet(_reserveAuctionLengthOnceReserveMet);
1212     }
1213 
1214     function _isReserveListingPermitted(uint256 _id) internal virtual returns (bool);
1215 
1216     function _hasReserveListingBeenInvalidated(uint256 _id) internal virtual returns (bool);
1217 
1218     function _removeReserveAuctionListing(uint256 _id) internal {
1219         ReserveAuction storage reserveAuction = editionOrTokenWithReserveAuctions[_id];
1220 
1221         require(reserveAuction.reservePrice > 0, "No active auction");
1222         require(reserveAuction.bid < reserveAuction.reservePrice, "Can only convert before reserve met");
1223         require(reserveAuction.seller == _msgSender(), "Only the seller can convert");
1224 
1225         // refund any bids
1226         if (reserveAuction.bid > 0) {
1227             _refundBidder(_id, reserveAuction.bidder, reserveAuction.bid, address(0), 0);
1228         }
1229 
1230         delete editionOrTokenWithReserveAuctions[_id];
1231     }
1232 }
1233 
1234 // File: contracts/marketplace/KODAV3SecondaryMarketplace.sol
1235 
1236 
1237 
1238 pragma solidity 0.8.4;
1239 
1240 
1241 
1242 
1243 
1244 
1245 
1246 /// @title KnownOrigin Secondary Marketplace for all V3 tokens
1247 /// @notice The following listing types are supported: Buy now, Reserve and Offers
1248 /// @dev The contract is pausable and has reentrancy guards
1249 /// @author KnownOrigin Labs
1250 contract KODAV3SecondaryMarketplace is
1251 IKODAV3SecondarySaleMarketplace,
1252 BaseMarketplace,
1253 BuyNowMarketplace,
1254 ReserveAuctionMarketplace {
1255 
1256     event SecondaryMarketplaceDeployed();
1257     event AdminUpdateSecondarySaleCommission(uint256 _platformSecondarySaleCommission);
1258     event ConvertFromBuyNowToOffers(uint256 indexed _tokenId, uint128 _startDate);
1259     event ReserveAuctionConvertedToOffers(uint256 indexed _tokenId);
1260 
1261     struct Offer {
1262         uint256 offer;
1263         address bidder;
1264         uint256 lockupUntil;
1265     }
1266 
1267     // Token ID to Offer mapping
1268     mapping(uint256 => Offer) public tokenBids;
1269 
1270     // Edition ID to Offer (an offer on any token in an edition)
1271     mapping(uint256 => Offer) public editionBids;
1272 
1273     uint256 public platformSecondarySaleCommission = 2_50000;  // 2.50000%
1274 
1275     constructor(IKOAccessControlsLookup _accessControls, IKODAV3 _koda, address _platformAccount)
1276     BaseMarketplace(_accessControls, _koda, _platformAccount) {
1277         emit SecondaryMarketplaceDeployed();
1278     }
1279 
1280     function listTokenForBuyNow(uint256 _tokenId, uint128 _listingPrice, uint128 _startDate)
1281     public
1282     override
1283     whenNotPaused {
1284         listForBuyNow(_msgSender(), _tokenId, _listingPrice, _startDate);
1285     }
1286 
1287     function delistToken(uint256 _tokenId)
1288     public
1289     override
1290     whenNotPaused {
1291         // check listing found
1292         require(editionOrTokenListings[_tokenId].seller != address(0), "No listing found");
1293 
1294         // check owner is caller
1295         require(koda.ownerOf(_tokenId) == _msgSender(), "Not token owner");
1296 
1297         // remove the listing
1298         delete editionOrTokenListings[_tokenId];
1299 
1300         emit TokenDeListed(_tokenId);
1301     }
1302 
1303     // Secondary sale "offer" flow
1304 
1305     function placeEditionBid(uint256 _editionId)
1306     public
1307     payable
1308     override
1309     whenNotPaused
1310     nonReentrant {
1311         _placeEditionBidFor(_editionId, _msgSender());
1312     }
1313 
1314     function placeEditionBidFor(uint256 _editionId, address _bidder)
1315     public
1316     payable
1317     override
1318     whenNotPaused
1319     nonReentrant {
1320         _placeEditionBidFor(_editionId, _bidder);
1321     }
1322 
1323     function withdrawEditionBid(uint256 _editionId)
1324     public
1325     override
1326     whenNotPaused
1327     nonReentrant {
1328         Offer storage offer = editionBids[_editionId];
1329 
1330         // caller must be bidder
1331         require(offer.bidder == _msgSender(), "Not bidder");
1332 
1333         // cannot withdraw before lockup period elapses
1334         require(block.timestamp >= offer.lockupUntil, "Bid lockup not elapsed");
1335 
1336         // send money back to top bidder
1337         _refundBidder(_editionId, offer.bidder, offer.offer, address(0), 0);
1338 
1339         // delete offer
1340         delete editionBids[_editionId];
1341 
1342         emit EditionBidWithdrawn(_editionId, _msgSender());
1343     }
1344 
1345     function acceptEditionBid(uint256 _tokenId, uint256 _offerPrice)
1346     public
1347     override
1348     whenNotPaused
1349     nonReentrant {
1350         uint256 editionId = koda.getEditionIdOfToken(_tokenId);
1351 
1352         Offer memory offer = editionBids[editionId];
1353         require(offer.bidder != address(0), "No open bid");
1354         require(offer.offer >= _offerPrice, "Offer price has changed");
1355 
1356         address currentOwner = koda.ownerOf(_tokenId);
1357         require(currentOwner == _msgSender(), "Not current owner");
1358 
1359         require(!_isTokenListed(_tokenId), "The token is listed so cannot accept an edition bid");
1360 
1361         _facilitateSecondarySale(_tokenId, offer.offer, currentOwner, offer.bidder);
1362 
1363         // clear open offer
1364         delete editionBids[editionId];
1365 
1366         emit EditionBidAccepted(_tokenId, currentOwner, offer.bidder, offer.offer);
1367     }
1368 
1369     function placeTokenBid(uint256 _tokenId)
1370     public
1371     payable
1372     override
1373     whenNotPaused
1374     nonReentrant {
1375         _placeTokenBidFor(_tokenId, _msgSender());
1376     }
1377 
1378     function placeTokenBidFor(uint256 _tokenId, address _bidder)
1379     public
1380     payable
1381     override
1382     whenNotPaused
1383     nonReentrant {
1384         _placeTokenBidFor(_tokenId, _bidder);
1385     }
1386 
1387     function withdrawTokenBid(uint256 _tokenId)
1388     public
1389     override
1390     whenNotPaused
1391     nonReentrant {
1392         Offer storage offer = tokenBids[_tokenId];
1393 
1394         // caller must be bidder
1395         require(offer.bidder == _msgSender(), "Not bidder");
1396 
1397         // cannot withdraw before lockup period elapses
1398         require(block.timestamp >= offer.lockupUntil, "Bid lockup not elapsed");
1399 
1400         // send money back to top bidder
1401         _refundBidder(_tokenId, offer.bidder, offer.offer, address(0), 0);
1402 
1403         // delete offer
1404         delete tokenBids[_tokenId];
1405 
1406         emit TokenBidWithdrawn(_tokenId, _msgSender());
1407     }
1408 
1409     function rejectTokenBid(uint256 _tokenId)
1410     public
1411     override
1412     whenNotPaused
1413     nonReentrant {
1414         Offer memory offer = tokenBids[_tokenId];
1415         require(offer.bidder != address(0), "No open bid");
1416 
1417         address currentOwner = koda.ownerOf(_tokenId);
1418         require(currentOwner == _msgSender(), "Not current owner");
1419 
1420         // send money back to top bidder
1421         _refundBidder(_tokenId, offer.bidder, offer.offer, address(0), 0);
1422 
1423         // delete offer
1424         delete tokenBids[_tokenId];
1425 
1426         emit TokenBidRejected(_tokenId, currentOwner, offer.bidder, offer.offer);
1427     }
1428 
1429     function acceptTokenBid(uint256 _tokenId, uint256 _offerPrice)
1430     public
1431     override
1432     whenNotPaused
1433     nonReentrant {
1434         Offer memory offer = tokenBids[_tokenId];
1435         require(offer.bidder != address(0), "No open bid");
1436         require(offer.offer >= _offerPrice, "Offer price has changed");
1437 
1438         address currentOwner = koda.ownerOf(_tokenId);
1439         require(currentOwner == _msgSender(), "Not current owner");
1440 
1441         _facilitateSecondarySale(_tokenId, offer.offer, currentOwner, offer.bidder);
1442 
1443         // clear open offer
1444         delete tokenBids[_tokenId];
1445 
1446         emit TokenBidAccepted(_tokenId, currentOwner, offer.bidder, offer.offer);
1447     }
1448 
1449     // emergency admin "reject" button for stuck bids
1450     function adminRejectTokenBid(uint256 _tokenId)
1451     public
1452     nonReentrant
1453     onlyAdmin {
1454         Offer memory offer = tokenBids[_tokenId];
1455         require(offer.bidder != address(0), "No open bid");
1456 
1457         // send money back to top bidder
1458         if (offer.offer > 0) {
1459             _refundBidder(_tokenId, offer.bidder, offer.offer, address(0), 0);
1460         }
1461 
1462         // delete offer
1463         delete tokenBids[_tokenId];
1464 
1465         emit TokenBidRejected(_tokenId, koda.ownerOf(_tokenId), offer.bidder, offer.offer);
1466     }
1467 
1468     function convertReserveAuctionToBuyItNow(uint256 _tokenId, uint128 _listingPrice, uint128 _startDate)
1469     public
1470     override
1471     whenNotPaused
1472     nonReentrant {
1473         require(_listingPrice >= minBidAmount, "Listing price not enough");
1474         _removeReserveAuctionListing(_tokenId);
1475 
1476         editionOrTokenListings[_tokenId] = Listing(_listingPrice, _startDate, _msgSender());
1477 
1478         emit ReserveAuctionConvertedToBuyItNow(_tokenId, _listingPrice, _startDate);
1479     }
1480 
1481     function convertReserveAuctionToOffers(uint256 _tokenId)
1482     public
1483     override
1484     whenNotPaused
1485     nonReentrant {
1486         _removeReserveAuctionListing(_tokenId);
1487         emit ReserveAuctionConvertedToOffers(_tokenId);
1488     }
1489 
1490     //////////////////////////////
1491     // Secondary sale "helpers" //
1492     //////////////////////////////
1493 
1494     function _facilitateSecondarySale(uint256 _tokenId, uint256 _paymentAmount, address _seller, address _buyer) internal {
1495         (address _royaltyRecipient, uint256 _royaltyAmount) = koda.royaltyInfo(_tokenId, _paymentAmount);
1496 
1497         // split money
1498         handleSecondarySaleFunds(_seller, _royaltyRecipient, _paymentAmount, _royaltyAmount);
1499 
1500         // N:B. open offers are left for the bidder to withdraw or the new token owner to reject/accept
1501 
1502         // send token to buyer
1503         koda.safeTransferFrom(_seller, _buyer, _tokenId);
1504     }
1505 
1506     function handleSecondarySaleFunds(
1507         address _seller,
1508         address _royaltyRecipient,
1509         uint256 _paymentAmount,
1510         uint256 _creatorRoyalties
1511     ) internal {
1512         // pay royalties
1513         (bool creatorSuccess,) = _royaltyRecipient.call{value : _creatorRoyalties}("");
1514         require(creatorSuccess, "Token payment failed");
1515 
1516         // pay platform fee
1517         uint256 koCommission = (_paymentAmount / modulo) * platformSecondarySaleCommission;
1518         (bool koCommissionSuccess,) = platformAccount.call{value : koCommission}("");
1519         require(koCommissionSuccess, "Token commission payment failed");
1520 
1521         // pay seller
1522         (bool success,) = _seller.call{value : _paymentAmount - _creatorRoyalties - koCommission}("");
1523         require(success, "Token payment failed");
1524     }
1525 
1526     // Admin Methods
1527 
1528     function updatePlatformSecondarySaleCommission(uint256 _platformSecondarySaleCommission) public onlyAdmin {
1529         platformSecondarySaleCommission = _platformSecondarySaleCommission;
1530         emit AdminUpdateSecondarySaleCommission(_platformSecondarySaleCommission);
1531     }
1532 
1533     // internal
1534 
1535     function _isListingPermitted(uint256 _tokenId) internal view override returns (bool) {
1536         return !_isTokenListed(_tokenId);
1537     }
1538 
1539     function _isReserveListingPermitted(uint256 _tokenId) internal view override returns (bool) {
1540         return koda.ownerOf(_tokenId) == _msgSender();
1541     }
1542 
1543     function _hasReserveListingBeenInvalidated(uint256 _id) internal view override returns (bool) {
1544         bool isApprovalActiveForMarketplace = koda.isApprovedForAll(
1545             editionOrTokenWithReserveAuctions[_id].seller,
1546             address(this)
1547         );
1548 
1549         return !isApprovalActiveForMarketplace || koda.ownerOf(_id) != editionOrTokenWithReserveAuctions[_id].seller;
1550     }
1551 
1552     function _isBuyNowListingPermitted(uint256 _tokenId) internal view override returns (bool) {
1553         return koda.ownerOf(_tokenId) == _msgSender();
1554     }
1555 
1556     function _processSale(
1557         uint256 _tokenId,
1558         uint256 _paymentAmount,
1559         address _buyer,
1560         address _seller
1561     ) internal override returns (uint256) {
1562         _facilitateSecondarySale(_tokenId, _paymentAmount, _seller, _buyer);
1563         return _tokenId;
1564     }
1565 
1566     // as offers are always possible, we wont count it as a listing
1567     function _isTokenListed(uint256 _tokenId) internal view returns (bool) {
1568         address currentOwner = koda.ownerOf(_tokenId);
1569 
1570         // listing not set
1571         if (editionOrTokenListings[_tokenId].seller == currentOwner) {
1572             return true;
1573         }
1574 
1575         // listing not set
1576         if (editionOrTokenWithReserveAuctions[_tokenId].seller == currentOwner) {
1577             return true;
1578         }
1579 
1580         return false;
1581     }
1582 
1583     function _placeEditionBidFor(uint256 _editionId, address _bidder) internal {
1584         require(koda.editionExists(_editionId), "Edition does not exist");
1585 
1586         // Check for highest offer
1587         Offer storage offer = editionBids[_editionId];
1588         require(msg.value >= offer.offer + minBidAmount, "Bid not high enough");
1589 
1590         // send money back to top bidder if existing offer found
1591         if (offer.offer > 0) {
1592             _refundBidder(_editionId, offer.bidder, offer.offer, _bidder, msg.value);
1593         }
1594 
1595         // setup offer
1596         editionBids[_editionId] = Offer(msg.value, _bidder, _getLockupTime());
1597 
1598         emit EditionBidPlaced(_editionId, _bidder, msg.value);
1599     }
1600 
1601     function _placeTokenBidFor(uint256 _tokenId, address _bidder) internal {
1602         require(!_isTokenListed(_tokenId), "Token is listed");
1603 
1604         // Check for highest offer
1605         Offer storage offer = tokenBids[_tokenId];
1606         require(msg.value >= offer.offer + minBidAmount, "Bid not high enough");
1607 
1608         // send money back to top bidder if existing offer found
1609         if (offer.offer > 0) {
1610             _refundBidder(_tokenId, offer.bidder, offer.offer, _bidder, msg.value);
1611         }
1612 
1613         // setup offer
1614         tokenBids[_tokenId] = Offer(msg.value, _bidder, _getLockupTime());
1615 
1616         emit TokenBidPlaced(_tokenId, koda.ownerOf(_tokenId), _bidder, msg.value);
1617     }
1618 }