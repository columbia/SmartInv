1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
3 
4 /**
5  * @dev Interface of the ERC165 standard, as defined in the
6  * https://eips.ethereum.org/EIPS/eip-165[EIP].
7  *
8  * Implementers can declare support of contract interfaces, which can then be
9  * queried by others ({ERC165Checker}).
10  *
11  * For an implementation, see {ERC165}.
12  */
13 interface IERC165 {
14     /**
15      * @dev Returns true if this contract implements the interface defined by
16      * `interfaceId`. See the corresponding
17      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
18      * to learn more about how these ids are created.
19      *
20      * This function call must use less than 30 000 gas.
21      */
22     function supportsInterface(bytes4 interfaceId) external view returns (bool);
23 }
24 
25 /**
26  * @dev Required interface of an ERC1155 compliant contract, as defined in the
27  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
28  *
29  * _Available since v3.1._
30  */
31 interface IERC1155 is IERC165 {
32     /**
33      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
34      */
35     event TransferSingle(
36         address indexed operator,
37         address indexed from,
38         address indexed to,
39         uint256 id,
40         uint256 value
41     );
42 
43     /**
44      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
45      * transfers.
46      */
47     event TransferBatch(
48         address indexed operator,
49         address indexed from,
50         address indexed to,
51         uint256[] ids,
52         uint256[] values
53     );
54 
55     /**
56      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
57      * `approved`.
58      */
59     event ApprovalForAll(
60         address indexed account,
61         address indexed operator,
62         bool approved
63     );
64 
65     /**
66      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
67      *
68      * If an {URI} event was emitted for `id`, the standard
69      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
70      * returned by {IERC1155MetadataURI-uri}.
71      */
72     event URI(string value, uint256 indexed id);
73 
74     /**
75      * @dev Returns the amount of tokens of token type `id` owned by `account`.
76      *
77      * Requirements:
78      *
79      * - `account` cannot be the zero address.
80      */
81     function balanceOf(address account, uint256 id)
82         external
83         view
84         returns (uint256);
85 
86     /**
87      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
88      *
89      * Requirements:
90      *
91      * - `accounts` and `ids` must have the same length.
92      */
93     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
94         external
95         view
96         returns (uint256[] memory);
97 
98     /**
99      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
100      *
101      * Emits an {ApprovalForAll} event.
102      *
103      * Requirements:
104      *
105      * - `operator` cannot be the caller.
106      */
107     function setApprovalForAll(address operator, bool approved) external;
108 
109     /**
110      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
111      *
112      * See {setApprovalForAll}.
113      */
114     function isApprovedForAll(address account, address operator)
115         external
116         view
117         returns (bool);
118 
119     /**
120      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
121      *
122      * Emits a {TransferSingle} event.
123      *
124      * Requirements:
125      *
126      * - `to` cannot be the zero address.
127      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
128      * - `from` must have a balance of tokens of type `id` of at least `amount`.
129      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
130      * acceptance magic value.
131      */
132     function safeTransferFrom(
133         address from,
134         address to,
135         uint256 id,
136         uint256 amount,
137         bytes calldata data
138     ) external;
139 
140     /**
141      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
142      *
143      * Emits a {TransferBatch} event.
144      *
145      * Requirements:
146      *
147      * - `ids` and `amounts` must have the same length.
148      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
149      * acceptance magic value.
150      */
151     function safeBatchTransferFrom(
152         address from,
153         address to,
154         uint256[] calldata ids,
155         uint256[] calldata amounts,
156         bytes calldata data
157     ) external;
158 }
159 
160 /**
161  * @dev _Available since v3.1._
162  */
163 interface IERC1155Receiver is IERC165 {
164     /**
165         @dev Handles the receipt of a single ERC1155 token type. This function is
166         called at the end of a `safeTransferFrom` after the balance has been updated.
167         To accept the transfer, this must return
168         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
169         (i.e. 0xf23a6e61, or its own function selector).
170         @param operator The address which initiated the transfer (i.e. msg.sender)
171         @param from The address which previously owned the token
172         @param id The ID of the token being transferred
173         @param value The amount of tokens being transferred
174         @param data Additional data with no specified format
175         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
176     */
177     function onERC1155Received(
178         address operator,
179         address from,
180         uint256 id,
181         uint256 value,
182         bytes calldata data
183     ) external returns (bytes4);
184 
185     /**
186         @dev Handles the receipt of a multiple ERC1155 token types. This function
187         is called at the end of a `safeBatchTransferFrom` after the balances have
188         been updated. To accept the transfer(s), this must return
189         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
190         (i.e. 0xbc197c81, or its own function selector).
191         @param operator The address which initiated the batch transfer (i.e. msg.sender)
192         @param from The address which previously owned the token
193         @param ids An array containing ids of each token being transferred (order and length must match values array)
194         @param values An array containing amounts of each token being transferred (order and length must match ids array)
195         @param data Additional data with no specified format
196         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
197     */
198     function onERC1155BatchReceived(
199         address operator,
200         address from,
201         uint256[] calldata ids,
202         uint256[] calldata values,
203         bytes calldata data
204     ) external returns (bytes4);
205 }
206 
207 /**
208  * @dev Interface of the ERC20 standard as defined in the EIP.
209  */
210 interface IERC20 {
211     /**
212      * @dev Returns the amount of tokens in existence.
213      */
214     function totalSupply() external view returns (uint256);
215 
216     /**
217      * @dev Returns the amount of tokens owned by `account`.
218      */
219     function balanceOf(address account) external view returns (uint256);
220 
221     /**
222      * @dev Moves `amount` tokens from the caller's account to `recipient`.
223      *
224      * Returns a boolean value indicating whether the operation succeeded.
225      *
226      * Emits a {Transfer} event.
227      */
228     function transfer(address recipient, uint256 amount)
229         external
230         returns (bool);
231 
232     /**
233      * @dev Returns the remaining number of tokens that `spender` will be
234      * allowed to spend on behalf of `owner` through {transferFrom}. This is
235      * zero by default.
236      *
237      * This value changes when {approve} or {transferFrom} are called.
238      */
239     function allowance(address owner, address spender)
240         external
241         view
242         returns (uint256);
243 
244     /**
245      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
246      *
247      * Returns a boolean value indicating whether the operation succeeded.
248      *
249      * IMPORTANT: Beware that changing an allowance with this method brings the risk
250      * that someone may use both the old and the new allowance by unfortunate
251      * transaction ordering. One possible solution to mitigate this race
252      * condition is to first reduce the spender's allowance to 0 and set the
253      * desired value afterwards:
254      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
255      *
256      * Emits an {Approval} event.
257      */
258     function approve(address spender, uint256 amount) external returns (bool);
259 
260     /**
261      * @dev Moves `amount` tokens from `sender` to `recipient` using the
262      * allowance mechanism. `amount` is then deducted from the caller's
263      * allowance.
264      *
265      * Returns a boolean value indicating whether the operation succeeded.
266      *
267      * Emits a {Transfer} event.
268      */
269     function transferFrom(
270         address sender,
271         address recipient,
272         uint256 amount
273     ) external returns (bool);
274 
275     /**
276      * @dev Emitted when `value` tokens are moved from one account (`from`) to
277      * another (`to`).
278      *
279      * Note that `value` may be zero.
280      */
281     event Transfer(address indexed from, address indexed to, uint256 value);
282 
283     /**
284      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
285      * a call to {approve}. `value` is the new allowance.
286      */
287     event Approval(
288         address indexed owner,
289         address indexed spender,
290         uint256 value
291     );
292 }
293 
294 /**
295  * @dev Required interface of an ERC721 compliant contract.
296  */
297 interface IERC721 is IERC165 {
298     /**
299      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
300      */
301     event Transfer(
302         address indexed from,
303         address indexed to,
304         uint256 indexed tokenId
305     );
306 
307     /**
308      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
309      */
310     event Approval(
311         address indexed owner,
312         address indexed approved,
313         uint256 indexed tokenId
314     );
315 
316     /**
317      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
318      */
319     event ApprovalForAll(
320         address indexed owner,
321         address indexed operator,
322         bool approved
323     );
324 
325     /**
326      * @dev Returns the number of tokens in ``owner``'s account.
327      */
328     function balanceOf(address owner) external view returns (uint256 balance);
329 
330     /**
331      * @dev Returns the owner of the `tokenId` token.
332      *
333      * Requirements:
334      *
335      * - `tokenId` must exist.
336      */
337     function ownerOf(uint256 tokenId) external view returns (address owner);
338 
339     /**
340      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
341      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
342      *
343      * Requirements:
344      *
345      * - `from` cannot be the zero address.
346      * - `to` cannot be the zero address.
347      * - `tokenId` token must exist and be owned by `from`.
348      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
349      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
350      *
351      * Emits a {Transfer} event.
352      */
353     function safeTransferFrom(
354         address from,
355         address to,
356         uint256 tokenId
357     ) external;
358 
359     /**
360      * @dev Transfers `tokenId` token from `from` to `to`.
361      *
362      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
363      *
364      * Requirements:
365      *
366      * - `from` cannot be the zero address.
367      * - `to` cannot be the zero address.
368      * - `tokenId` token must be owned by `from`.
369      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
370      *
371      * Emits a {Transfer} event.
372      */
373     function transferFrom(
374         address from,
375         address to,
376         uint256 tokenId
377     ) external;
378 
379     /**
380      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
381      * The approval is cleared when the token is transferred.
382      *
383      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
384      *
385      * Requirements:
386      *
387      * - The caller must own the token or be an approved operator.
388      * - `tokenId` must exist.
389      *
390      * Emits an {Approval} event.
391      */
392     function approve(address to, uint256 tokenId) external;
393 
394     /**
395      * @dev Returns the account approved for `tokenId` token.
396      *
397      * Requirements:
398      *
399      * - `tokenId` must exist.
400      */
401     function getApproved(uint256 tokenId)
402         external
403         view
404         returns (address operator);
405 
406     /**
407      * @dev Approve or remove `operator` as an operator for the caller.
408      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
409      *
410      * Requirements:
411      *
412      * - The `operator` cannot be the caller.
413      *
414      * Emits an {ApprovalForAll} event.
415      */
416     function setApprovalForAll(address operator, bool _approved) external;
417 
418     /**
419      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
420      *
421      * See {setApprovalForAll}
422      */
423     function isApprovedForAll(address owner, address operator)
424         external
425         view
426         returns (bool);
427 
428     /**
429      * @dev Safely transfers `tokenId` token from `from` to `to`.
430      *
431      * Requirements:
432      *
433      * - `from` cannot be the zero address.
434      * - `to` cannot be the zero address.
435      * - `tokenId` token must exist and be owned by `from`.
436      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
437      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
438      *
439      * Emits a {Transfer} event.
440      */
441     function safeTransferFrom(
442         address from,
443         address to,
444         uint256 tokenId,
445         bytes calldata data
446     ) external;
447 }
448 
449 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
450 
451 /**
452  * @dev Contract module that helps prevent reentrant calls to a function.
453  *
454  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
455  * available, which can be applied to functions to make sure there are no nested
456  * (reentrant) calls to them.
457  *
458  * Note that because there is a single `nonReentrant` guard, functions marked as
459  * `nonReentrant` may not call one another. This can be worked around by making
460  * those functions `private`, and then adding `external` `nonReentrant` entry
461  * points to them.
462  *
463  * TIP: If you would like to learn more about reentrancy and alternative ways
464  * to protect against it, check out our blog post
465  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
466  */
467 abstract contract ReentrancyGuard {
468     // Booleans are more expensive than uint256 or any type that takes up a full
469     // word because each write operation emits an extra SLOAD to first read the
470     // slot's contents, replace the bits taken up by the boolean, and then write
471     // back. This is the compiler's defense against contract upgrades and
472     // pointer aliasing, and it cannot be disabled.
473 
474     // The values being non-zero value makes deployment a bit more expensive,
475     // but in exchange the refund on every call to nonReentrant will be lower in
476     // amount. Since refunds are capped to a percentage of the total
477     // transaction's gas, it is best to keep them low in cases like this one, to
478     // increase the likelihood of the full refund coming into effect.
479     uint256 private constant _NOT_ENTERED = 1;
480     uint256 private constant _ENTERED = 2;
481 
482     uint256 private _status;
483 
484     constructor() {
485         _status = _NOT_ENTERED;
486     }
487 
488     /**
489      * @dev Prevents a contract from calling itself, directly or indirectly.
490      * Calling a `nonReentrant` function from another `nonReentrant`
491      * function is not supported. It is possible to prevent this from happening
492      * by making the `nonReentrant` function external, and make it call a
493      * `private` function that does the actual work.
494      */
495     modifier nonReentrant() {
496         // On the first call to nonReentrant, _notEntered will be true
497         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
498 
499         // Any calls to nonReentrant after this point will fail
500         _status = _ENTERED;
501 
502         _;
503 
504         // By storing the original value once again, a refund is triggered (see
505         // https://eips.ethereum.org/EIPS/eip-2200)
506         _status = _NOT_ENTERED;
507     }
508 }
509 
510 // For future use to allow buyers to receive a discount depending on staking or other rules.
511 interface IDiscountManager {
512     function getDiscount(address buyer)
513         external
514         view
515         returns (uint256 discount);
516 }
517 
518 contract ShiryoMarket is IERC1155Receiver, ReentrancyGuard {
519     using SafeMath for uint256;
520 
521     modifier onlyOwner() {
522         require(msg.sender == owner);
523         _;
524     }
525 
526      modifier onlyClevel() {
527         require(msg.sender == walletA || msg.sender == walletB || msg.sender == owner);
528     _;
529     }
530 
531     address walletA;
532     address walletB;
533     uint256 walletBPercentage = 20;
534 
535     using Counters for Counters.Counter;
536     Counters.Counter public _itemIds; // Id for each individual item
537     Counters.Counter private _itemsSold; // Number of items sold
538     Counters.Counter private _itemsCancelled; // Number of items sold
539     Counters.Counter private _offerIds; // Tracking offers
540 
541     address payable public owner; // The owner of the market contract
542     address public discountManager = address(0x0); // a contract that can be callled to discover if there is a discount on the transaction fee.
543 
544     uint256 public saleFeePercentage = 5; // Percentage fee paid to team for each sale
545     uint256 public accumulatedFee = 0;
546 
547     uint256 public volumeTraded = 0; // Total amount traded
548 
549     enum TokenType {
550         ERC721, //0
551         ERC1155, //1
552         ERC20 //2
553     }
554 
555     constructor() {
556         owner = payable(msg.sender);
557     }
558 
559     struct MarketOffer {
560         uint256 offerId;
561         uint256 itemId;
562         address payable bidder;
563         uint256 offerAmount;
564         uint256 offerTime;
565         bool cancelled;
566         bool accepted;
567     }
568 
569     struct MarketItem {
570         uint256 itemId;
571         address tokenContract;
572         TokenType tokenType;
573         uint256 tokenId; // 0 If token is ERC20
574         uint256 amount; // 1 unless QTY of ERC20
575         address payable seller;
576         address payable buyer;
577         string category;
578         uint256 price;
579         bool isSold;
580         bool cancelled;
581     }
582 
583     mapping(uint256 => MarketItem) public idToMarketItem;
584 
585     mapping(uint256 => uint256[]) public itemIdToMarketOfferIds;
586 
587     mapping(uint256 => MarketOffer) public offerIdToMarketOffer;
588 
589     mapping(address => uint256[]) public bidderToMarketOfferIds;
590 
591     mapping(address => bool) public approvedSourceContracts;
592 
593     event MarketItemCreated(
594         uint256 indexed itemId,
595         address indexed tokenContract,
596         uint256 indexed tokenId,
597         uint256 amount,
598         address seller,
599         address owner,
600         string category,
601         uint256 price
602     );
603 
604     event MarketSaleCreated(
605         uint256 indexed itemId,
606         address indexed tokenContract,
607         uint256 indexed tokenId,
608         address seller,
609         address buyer,
610         string category,
611         uint256 price
612     );
613 
614     event ItemOfferCreated(
615         uint256 indexed itemId,
616         address indexed tokenContract,
617         address owner,
618         address bidder,
619         uint256 bidAmount
620     );
621 
622     // transfers one of the token types to/from the contracts
623     function transferAnyToken(
624         TokenType _tokenType,
625         address _tokenContract,
626         address _from,
627         address _to,
628         uint256 _tokenId,
629         uint256 _amount
630     ) internal {
631         // type = 0
632         if (_tokenType == TokenType.ERC721) {
633             //IERC721(_tokenContract).approve(address(this), _tokenId);
634             IERC721(_tokenContract).transferFrom(_from, _to, _tokenId);
635             return;
636         }
637 
638         // type = 1
639         if (_tokenType == TokenType.ERC1155) {
640             IERC1155(_tokenContract).safeTransferFrom(
641                 _from,
642                 _to,
643                 _tokenId,
644                 1,
645                 ""
646             ); // amount - only 1 of an ERC1155 per item
647             return;
648         }
649 
650         // type = 2
651         if (_tokenType == TokenType.ERC20) {
652             if (_from==address(this)){
653                 IERC20(_tokenContract).approve(address(this), _amount);
654             }
655             IERC20(_tokenContract).transferFrom(_from, _to, _amount); // amount - ERC20 can be multiple tokens per item (bundle)
656             return;
657         }
658     }
659 
660    // market item functions
661     
662     // creates a market item by transferring it from the originating contract
663     // the amount will be 1 for ERC721 or ERC1155
664     // amount could be more for ERC20
665     function createMarketItem(
666         address _tokenContract,
667         TokenType _tokenType,
668         uint256 _tokenId,
669         uint256 _amount,
670         uint256 _price,
671         string calldata _category
672     ) public nonReentrant {
673         require(_price > 0, "No item for free here");
674         require(_amount > 0, "At least one token");
675         require(approvedSourceContracts[_tokenContract]==true,"Token contract not approved");
676 
677         _itemIds.increment();
678         uint256 itemId = _itemIds.current();
679         idToMarketItem[itemId] = MarketItem(
680             itemId,
681             _tokenContract,
682             _tokenType,
683             _tokenId,
684             _amount,
685             payable(msg.sender),
686             payable(address(0)), // No owner for the item
687             _category,
688             _price,
689             false,
690             false
691         );
692 
693         transferAnyToken(
694             _tokenType,
695             _tokenContract,
696             msg.sender,
697             address(this),
698             _tokenId,
699             _amount
700         );
701 
702         emit MarketItemCreated(
703             itemId,
704             _tokenContract,
705             _tokenId,
706             _amount,
707             msg.sender,
708             address(0),
709             _category,
710             _price
711         );
712     }
713 
714     // cancels a market item that's for sale
715     function cancelMarketItem(uint256 itemId) public {
716         require(itemId <= _itemIds.current());
717         require(idToMarketItem[itemId].seller == msg.sender);
718         require(
719             idToMarketItem[itemId].cancelled == false &&
720                 idToMarketItem[itemId].isSold == false
721         );
722 
723         idToMarketItem[itemId].cancelled = true;
724         _itemsCancelled.increment();
725 
726         transferAnyToken(
727             idToMarketItem[itemId].tokenType,
728             idToMarketItem[itemId].tokenContract,
729             address(this),
730             msg.sender,
731             idToMarketItem[itemId].tokenId,
732             idToMarketItem[itemId].amount
733         );
734     }
735 
736     // buys an item at it's current sale value
737 
738     function createMarketSale(uint256 itemId) public payable nonReentrant {
739         uint256 price = idToMarketItem[itemId].price;
740         uint256 tokenId = idToMarketItem[itemId].tokenId;
741         require(
742             msg.value == price,
743             "Not the correct message value"
744         );
745         require(
746             idToMarketItem[itemId].isSold == false,
747             "This item is already sold."
748         );
749         require(
750             idToMarketItem[itemId].cancelled == false,
751             "This item is not for sale."
752         );
753         require(
754             idToMarketItem[itemId].seller != msg.sender,
755             "Cannot buy your own item."
756         );
757 
758         // take fees and transfer the balance to the seller (TODO)
759         uint256 fees = SafeMath.div(price, 100).mul(saleFeePercentage);
760 
761         if (discountManager != address(0x0)) {
762             // how much discount does this user get?
763             uint256 feeDiscountPercent = IDiscountManager(discountManager)
764                 .getDiscount(msg.sender);
765             fees = fees.div(100).mul(feeDiscountPercent);
766         }
767 
768         uint256 saleAmount = price.sub(fees);
769         idToMarketItem[itemId].seller.transfer(saleAmount);
770         accumulatedFee+=fees;
771 
772         transferAnyToken(
773             idToMarketItem[itemId].tokenType,
774             idToMarketItem[itemId].tokenContract,
775             address(this),
776             msg.sender,
777             tokenId,
778             idToMarketItem[itemId].amount
779         );
780 
781         idToMarketItem[itemId].isSold = true;
782         idToMarketItem[itemId].buyer = payable(msg.sender);
783 
784         _itemsSold.increment();
785         volumeTraded = volumeTraded.add(price);
786 
787         emit MarketSaleCreated(
788             itemId,
789             idToMarketItem[itemId].tokenContract,
790             tokenId,
791             idToMarketItem[itemId].seller,
792             msg.sender,
793             idToMarketItem[itemId].category,
794             price
795         );
796     }
797 
798     function getMarketItemsByPage(uint256 _from, uint256 _to) external view returns (MarketItem[] memory) {
799         require(_from < _itemIds.current() && _to <= _itemIds.current(), "Page out of range.");
800 
801         uint256 itemCount;
802         for (uint256 i = _from; i <= _to; i++) {
803             if (
804                 idToMarketItem[i].buyer == address(0) &&
805                 idToMarketItem[i].cancelled == false &&
806                 idToMarketItem[i].isSold == false
807             ){
808                 itemCount++;
809             }
810         }
811 
812         uint256 currentIndex = 0;
813         MarketItem[] memory marketItems = new MarketItem[](itemCount);
814         for (uint256 i = _from; i <= _to; i++) {
815 
816              if (
817                 idToMarketItem[i].buyer == address(0) &&
818                 idToMarketItem[i].cancelled == false &&
819                 idToMarketItem[i].isSold == false
820             ){
821                 uint256 currentId = idToMarketItem[i].itemId;
822                 MarketItem storage currentItem = idToMarketItem[currentId];
823                 marketItems[currentIndex] = currentItem;
824                 currentIndex += 1;
825             }
826 
827         }
828         return marketItems;
829     }
830 
831     // returns all of the current items for sale
832     function getMarketItems() external view returns (MarketItem[] memory) {
833         uint256 itemCount = _itemIds.current();
834         uint256 unsoldItemCount = _itemIds.current() -
835             (_itemsSold.current() + _itemsCancelled.current());
836         uint256 currentIndex = 0;
837 
838         MarketItem[] memory marketItems = new MarketItem[](unsoldItemCount);
839         for (uint256 i = 0; i < itemCount; i++) {
840             if (
841                 idToMarketItem[i + 1].buyer == address(0) &&
842                 idToMarketItem[i + 1].cancelled == false &&
843                 idToMarketItem[i + 1].isSold == false
844             ) {
845                 uint256 currentId = idToMarketItem[i + 1].itemId;
846                 MarketItem storage currentItem = idToMarketItem[currentId];
847                 marketItems[currentIndex] = currentItem;
848                 currentIndex += 1;
849             }
850         }
851         return marketItems;
852     }
853 
854     // returns all itemsby seller and
855     function getMarketItemsBySeller(address _seller)
856         external
857         view
858         returns (MarketItem[] memory)
859     {
860         uint256 totalItemCount = _itemIds.current();
861         uint256 itemCount = 0;
862         uint256 currentIndex = 0;
863 
864         for (uint256 i = 0; i < totalItemCount; i++) {
865             if (
866                 idToMarketItem[i + 1].seller == _seller &&
867                 idToMarketItem[i + 1].cancelled == false &&
868                 idToMarketItem[i + 1].isSold == false //&&
869                 //idToMarketItem[i + 1].tokenContract == _tokenContract
870             ) {
871                 itemCount += 1; // No dynamic length. Predefined length has to be made
872             }
873         }
874 
875         MarketItem[] memory marketItems = new MarketItem[](itemCount);
876         for (uint256 i = 0; i < totalItemCount; i++) {
877             if (
878                 idToMarketItem[i + 1].seller == _seller &&
879                 idToMarketItem[i + 1].cancelled == false &&
880                 idToMarketItem[i + 1].isSold == false //&&
881                 //idToMarketItem[i + 1].tokenContract == _tokenContract
882             ) {
883                 uint256 currentId = idToMarketItem[i + 1].itemId;
884                 MarketItem storage currentItem = idToMarketItem[currentId];
885                 marketItems[currentIndex] = currentItem;
886                 currentIndex += 1;
887             }
888         }
889         return marketItems;
890     }
891 
892        // returns all itemsby seller and
893     function getMarketItemsBySellerByPage(address _seller, uint256 _from , uint256 _to)
894         external
895         view
896         returns (MarketItem[] memory)
897     {
898         require(_from < _itemIds.current() && _to <= _itemIds.current(), "Page out of range.");
899 
900         uint256 itemCount = 0;
901         uint256 currentIndex = 0;
902 
903         for (uint256 i = _from; i <= _to; i++) {
904             if (
905                 idToMarketItem[i].seller == _seller &&
906                 idToMarketItem[i].cancelled == false &&
907                 idToMarketItem[i].isSold == false //&&
908             ) {
909                 itemCount += 1; // No dynamic length. Predefined length has to be made
910             }
911         }
912 
913         MarketItem[] memory marketItems = new MarketItem[](itemCount);
914         for (uint256 i =  _from; i <= _to; i++) {
915             if (
916                 idToMarketItem[i].seller == _seller &&
917                 idToMarketItem[i].cancelled == false &&
918                 idToMarketItem[i].isSold == false //&&
919             ) {
920                 uint256 currentId = idToMarketItem[i].itemId;
921                 MarketItem storage currentItem = idToMarketItem[currentId];
922                 marketItems[currentIndex] = currentItem;
923                 currentIndex += 1;
924             }
925         }
926         return marketItems;
927     }
928 
929     // Get items by category
930     // This could be used with different collections
931     function getItemsByCategory(string calldata category)
932         external
933         view
934         returns (MarketItem[] memory)
935     {
936         uint256 totalItemCount = _itemIds.current();
937         uint256 itemCount = 0;
938         uint256 currentIndex = 0;
939 
940         for (uint256 i = 0; i < totalItemCount; i++) {
941             if (
942                 keccak256(abi.encodePacked(idToMarketItem[i + 1].category)) ==
943                 keccak256(abi.encodePacked(category)) &&
944                 idToMarketItem[i + 1].buyer == address(0) &&
945                 idToMarketItem[i + 1].cancelled == false &&
946                 idToMarketItem[i + 1].isSold == false
947             ) {
948                 itemCount += 1;
949             }
950         }
951 
952         MarketItem[] memory marketItems = new MarketItem[](itemCount);
953         for (uint256 i = 0; i < totalItemCount; i++) {
954             if (
955                 keccak256(abi.encodePacked(idToMarketItem[i + 1].category)) ==
956                 keccak256(abi.encodePacked(category)) &&
957                 idToMarketItem[i + 1].buyer == address(0) &&
958                 idToMarketItem[i + 1].cancelled == false &&
959                 idToMarketItem[i + 1].isSold == false
960             ) {
961                 uint256 currentId = idToMarketItem[i + 1].itemId;
962                 MarketItem storage currentItem = idToMarketItem[currentId];
963                 marketItems[currentIndex] = currentItem;
964                 currentIndex += 1;
965             }
966         }
967         return marketItems;
968     }
969 
970        // returns the total number of items sold
971     function getItemsSold() external view returns (uint256) {
972         return _itemsSold.current();
973     }
974 
975     // returns the current number of listed items
976     function numberOfItemsListed() external view returns (uint256) {
977         uint256 unsoldItemCount = _itemIds.current() -
978             (_itemsSold.current() + _itemsCancelled.current());
979         return unsoldItemCount;
980     }
981 
982 
983 
984     // Offers functions
985     // make offer
986     // cancel offer
987     // accept offer
988     // offersByItem
989     // offersByBidder
990 
991 
992     function makeItemOffer(uint256 _itemId) public payable nonReentrant {
993         require(
994             idToMarketItem[_itemId].tokenContract != address(0x0) &&
995                 idToMarketItem[_itemId].isSold == false &&
996                 idToMarketItem[_itemId].cancelled == false,
997             "Invalid item id."
998         );
999         require(msg.value > 0, "Can't offer nothing.");
1000 
1001         _offerIds.increment();
1002         uint256 offerId = _offerIds.current();
1003 
1004         MarketOffer memory offer = MarketOffer(
1005             offerId,
1006             _itemId,
1007             payable(msg.sender),
1008             msg.value,
1009             block.timestamp,
1010             false,
1011             false
1012         );
1013 
1014         offerIdToMarketOffer[offerId] = offer;
1015         itemIdToMarketOfferIds[_itemId].push(offerId);
1016         bidderToMarketOfferIds[msg.sender].push(offerId);
1017 
1018         emit ItemOfferCreated(
1019             _itemId,
1020             idToMarketItem[_itemId].tokenContract,
1021             idToMarketItem[_itemId].seller,
1022             msg.sender,
1023             msg.value
1024         );
1025     }
1026 
1027     function acceptItemOffer(uint256 _offerId) public nonReentrant {
1028         uint256 itemId = offerIdToMarketOffer[_offerId].itemId;
1029 
1030         require(idToMarketItem[itemId].seller == msg.sender, "Not item seller");
1031 
1032         require(
1033             offerIdToMarketOffer[_offerId].accepted == false &&
1034                 offerIdToMarketOffer[_offerId].cancelled == false,
1035             "Already accepted or cancelled."
1036         );
1037 
1038         uint256 price = offerIdToMarketOffer[_offerId].offerAmount;
1039         address bidder = payable(offerIdToMarketOffer[_offerId].bidder);
1040 
1041         uint256 fees = SafeMath.div(price, 100).mul(saleFeePercentage);
1042 
1043         // fees and payment
1044         if (discountManager != address(0x0)) {
1045             // how much discount does this user get?
1046             uint256 feeDiscountPercent = IDiscountManager(discountManager)
1047                 .getDiscount(msg.sender);
1048             fees = fees.div(100).mul(feeDiscountPercent);
1049         }
1050 
1051         uint256 saleAmount = price.sub(fees);
1052         payable(msg.sender).transfer(saleAmount);
1053         if (fees > 0) {
1054             accumulatedFee+=fees;
1055         }
1056 
1057         transferAnyToken(
1058             idToMarketItem[itemId].tokenType,
1059             idToMarketItem[itemId].tokenContract,
1060             address(this),
1061             offerIdToMarketOffer[_offerId].bidder,
1062             idToMarketItem[itemId].tokenId,
1063             idToMarketItem[itemId].amount
1064         );
1065 
1066         offerIdToMarketOffer[_offerId].accepted = true;
1067         
1068         idToMarketItem[itemId].isSold = true;
1069         idToMarketItem[itemId].buyer = offerIdToMarketOffer[_offerId].bidder;
1070 
1071         _itemsSold.increment();
1072 
1073         emit MarketSaleCreated(
1074             itemId,
1075             idToMarketItem[itemId].tokenContract,
1076             idToMarketItem[itemId].tokenId,
1077             msg.sender,
1078             bidder,
1079             idToMarketItem[itemId].category,
1080             price
1081         );
1082 
1083         volumeTraded = volumeTraded.add(price);
1084     }
1085 
1086     function canceItemOffer(uint256 _offerId) public nonReentrant {
1087         require(
1088             offerIdToMarketOffer[_offerId].bidder == msg.sender &&
1089                 offerIdToMarketOffer[_offerId].cancelled == false,
1090             "Wrong bidder or offer is already cancelled"
1091         );
1092         require(
1093             offerIdToMarketOffer[_offerId].accepted == false,
1094             "Already accepted."
1095         );
1096 
1097         address bidder = offerIdToMarketOffer[_offerId].bidder;
1098 
1099         offerIdToMarketOffer[_offerId].cancelled = true;
1100         payable(bidder).transfer(offerIdToMarketOffer[_offerId].offerAmount);
1101 
1102         //TODO emit
1103     }
1104 
1105      function getOffersByBidder(address _bidder)
1106         external
1107         view
1108         returns (MarketOffer[] memory)
1109     {
1110         uint256 openOfferCount = 0;
1111         uint256[] memory itemOfferIds = bidderToMarketOfferIds[_bidder];
1112 
1113         for (uint256 i = 0; i < itemOfferIds.length; i++) {
1114             if (
1115                 offerIdToMarketOffer[itemOfferIds[i]].accepted == false &&
1116                 offerIdToMarketOffer[itemOfferIds[i]].cancelled == false
1117             ) {
1118                 openOfferCount++;
1119             }
1120         }
1121 
1122         MarketOffer[] memory openOffers = new MarketOffer[](openOfferCount);
1123         uint256 currentIndex = 0;
1124         for (uint256 i = 0; i < itemOfferIds.length; i++) {
1125             if (
1126                 offerIdToMarketOffer[itemOfferIds[i]].accepted == false &&
1127                 offerIdToMarketOffer[itemOfferIds[i]].cancelled == false
1128             ) {
1129                 MarketOffer memory currentItem = offerIdToMarketOffer[
1130                     itemOfferIds[i]
1131                 ];
1132                 openOffers[currentIndex] = currentItem;
1133                 currentIndex += 1;
1134             }
1135         }
1136 
1137         return openOffers;
1138     }
1139 
1140      function getTotalOffersMadeByBidder(address _bidder) external view returns (uint256){
1141          return bidderToMarketOfferIds[_bidder].length;
1142      }
1143 
1144      function getOpenOffersByBidderByPage(address _bidder, uint256 _from , uint256 _to)
1145         external
1146         view
1147         returns (MarketOffer[] memory)
1148     {
1149         uint256 openOfferCount = 0;
1150         uint256[] memory itemOfferIds = bidderToMarketOfferIds[_bidder];
1151 
1152         for (uint256 i = _from; i <= _to; i++) {
1153             if (
1154                 offerIdToMarketOffer[itemOfferIds[i]].accepted == false &&
1155                 offerIdToMarketOffer[itemOfferIds[i]].cancelled == false
1156             ) {
1157                 openOfferCount++;
1158             }
1159         }
1160 
1161         MarketOffer[] memory openOffers = new MarketOffer[](openOfferCount);
1162         uint256 currentIndex = 0;
1163         for (uint256 i = _from; i <= _to; i++) {
1164             if (
1165                 offerIdToMarketOffer[itemOfferIds[i]].accepted == false &&
1166                 offerIdToMarketOffer[itemOfferIds[i]].cancelled == false
1167             ) {
1168                 MarketOffer memory currentItem = offerIdToMarketOffer[
1169                     itemOfferIds[i]
1170                 ];
1171                 openOffers[currentIndex] = currentItem;
1172                 currentIndex += 1;
1173             }
1174         }
1175 
1176         return openOffers;
1177     }
1178 
1179     function getItemOffers(uint256 _itemId)
1180         external
1181         view
1182         returns (MarketOffer[] memory)
1183     {
1184         uint256 openOfferCount = 0;
1185         uint256[] memory itemOfferIds = itemIdToMarketOfferIds[_itemId];
1186 
1187         for (uint256 i = 0; i < itemOfferIds.length; i++) {
1188             if (
1189                 offerIdToMarketOffer[itemOfferIds[i]].accepted == false &&
1190                 offerIdToMarketOffer[itemOfferIds[i]].cancelled == false
1191             ) {
1192                 openOfferCount++;
1193             }
1194         }
1195 
1196         MarketOffer[] memory openOffers = new MarketOffer[](openOfferCount);
1197         uint256 currentIndex = 0;
1198         for (uint256 i = 0; i < itemOfferIds.length; i++) {
1199             if (
1200                 offerIdToMarketOffer[itemOfferIds[i]].accepted == false &&
1201                 offerIdToMarketOffer[itemOfferIds[i]].cancelled == false
1202             ) {
1203                 MarketOffer memory currentItem = offerIdToMarketOffer[
1204                     itemOfferIds[i]
1205                 ];
1206                 openOffers[currentIndex] = currentItem;
1207                 currentIndex += 1;
1208             }
1209         }
1210 
1211         return openOffers;
1212     }
1213 
1214     // administration functions
1215     function setSalePercentageFee(uint256 _amount) public onlyOwner {
1216         require(_amount <= 5, "5% maximum fee allowed.");
1217         saleFeePercentage = _amount;
1218     }
1219 
1220     function setOwner(address _owner) public onlyOwner {
1221         require(_owner != address(0x0), "0x0 address not permitted");
1222         owner = payable(_owner);
1223     }
1224 
1225     function setDiscountManager(address _discountManager) public onlyOwner {
1226         require(_discountManager != address(0x0), "0x0 address not permitted");
1227         discountManager = _discountManager;
1228     }
1229 
1230     function setSourceContractApproved(address _tokenContract, bool _approved) external onlyOwner {
1231         approvedSourceContracts[_tokenContract]=_approved;
1232     }
1233 
1234 
1235     // IERC1155Receiver implementations
1236 
1237     function onERC1155Received(
1238         address,
1239         address,
1240         uint256,
1241         uint256,
1242         bytes memory
1243     ) public virtual override returns (bytes4) {
1244         return this.onERC1155Received.selector;
1245     }
1246 
1247     function onERC1155BatchReceived(
1248         address,
1249         address,
1250         uint256[] memory,
1251         uint256[] memory,
1252         bytes memory
1253     ) public virtual override returns (bytes4) {
1254         return this.onERC1155BatchReceived.selector;
1255     }
1256 
1257 
1258     function supportsInterface(bytes4 interfaceId) override external pure returns (bool){
1259             return interfaceId == type(IERC1155Receiver).interfaceId
1260             || true;
1261     }
1262 
1263     function withdraw_all() external onlyClevel {
1264         require (accumulatedFee > 0);
1265         uint256 amountB = SafeMath.div(accumulatedFee,100).mul(walletBPercentage);
1266         uint256 amountA = accumulatedFee.sub(amountB);
1267         accumulatedFee = 0;
1268         payable(walletA).transfer(amountA);
1269         payable(walletB).transfer(amountB);
1270     }
1271 
1272     function setWalletA(address _walletA) external onlyOwner {
1273         require (_walletA != address(0x0), "Invalid wallet");
1274         walletA = _walletA;
1275     }
1276 
1277     function setWalletB(address _walletB) external onlyOwner {
1278         require (_walletB != address(0x0), "Invalid wallet.");
1279         walletB = _walletB;
1280     }
1281 
1282     function setWalletBPercentage(uint256 _percentage) external onlyOwner {
1283         require (_percentage>walletBPercentage && _percentage<=100, "Invalid new slice.");
1284         walletBPercentage = _percentage;
1285     }
1286 
1287 }
1288 
1289 /**
1290  * @title Counters
1291  * @author Matt Condon (@shrugs)
1292  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1293  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1294  *
1295  * Include with `using Counters for Counters.Counter;`
1296  */
1297 library Counters {
1298     struct Counter {
1299         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1300         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1301         // this feature: see https://github.com/ethereum/solidity/issues/4637
1302         uint256 _value; // default: 0
1303     }
1304 
1305     function current(Counter storage counter) internal view returns (uint256) {
1306         return counter._value;
1307     }
1308 
1309     function increment(Counter storage counter) internal {
1310         unchecked {
1311             counter._value += 1;
1312         }
1313     }
1314 
1315     function decrement(Counter storage counter) internal {
1316         uint256 value = counter._value;
1317         require(value > 0, "Counter: decrement overflow");
1318         unchecked {
1319             counter._value = value - 1;
1320         }
1321     }
1322 
1323     function reset(Counter storage counter) internal {
1324         counter._value = 0;
1325     }
1326 }
1327 
1328 library SafeMath {
1329     /**
1330      * @dev Multiplies two numbers, throws on overflow.
1331      */
1332     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1333         if (a == 0) {
1334             return 0;
1335         }
1336         uint256 c = a * b;
1337         assert(c / a == b);
1338         return c;
1339     }
1340 
1341     /**
1342      * @dev Integer division of two numbers, truncating the quotient.
1343      */
1344     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1345         // assert(b > 0); // Solidity automatically throws when dividing by 0
1346         uint256 c = a / b;
1347         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1348         return c;
1349     }
1350 
1351     /**
1352      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1353      */
1354     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1355         assert(b <= a);
1356         return a - b;
1357     }
1358 
1359     /**
1360      * @dev Adds two numbers, throws on overflow.
1361      */
1362     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1363         uint256 c = a + b;
1364         assert(c >= a);
1365         return c;
1366     }
1367 }