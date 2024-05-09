1 /**
2  *Submitted for verification at Etherscan.io on 2022-11-11
3 */
4 
5 // SPDX-License-Identifier: UNLICENSED
6 pragma solidity ^0.8.15;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 /**
72  * @dev Provides information about the current execution context, including the
73  * sender of the transaction and its data. While these are generally available
74  * via msg.sender and msg.data, they should not be accessed in such a direct
75  * manner, since when dealing with meta-transactions the account sending and
76  * paying for execution may not be the actual sender (as far as an application
77  * is concerned).
78  *
79  * This contract is only required for intermediate, library-like contracts.
80  */
81 abstract contract Context {
82     function _msgSender() internal view virtual returns (address) {
83         return msg.sender;
84     }
85 
86     function _msgData() internal view virtual returns (bytes calldata) {
87         return msg.data;
88     }
89 }
90 
91 /**
92  * @dev Contract module which provides a basic access control mechanism, where
93  * there is an account (an owner) that can be granted exclusive access to
94  * specific functions.
95  *
96  * By default, the owner account will be the one that deploys the contract. This
97  * can later be changed with {transferOwnership}.
98  *
99  * This module is used through inheritance. It will make available the modifier
100  * `onlyOwner`, which can be applied to your functions to restrict their use to
101  * the owner.
102  */
103 abstract contract Ownable is Context {
104     address private _owner;
105 
106     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
107 
108     /**
109      * @dev Initializes the contract setting the deployer as the initial owner.
110      */
111     constructor() {
112         _transferOwnership(_msgSender());
113     }
114 
115     /**
116      * @dev Returns the address of the current owner.
117      */
118     function owner() public view virtual returns (address) {
119         return _owner;
120     }
121 
122     /**
123      * @dev Throws if called by any account other than the owner.
124      */
125     modifier onlyOwner() {
126         require(owner() == _msgSender(), "Ownable: caller is not the owner");
127         _;
128     }
129 
130     /**
131      * @dev Leaves the contract without owner. It will not be possible to call
132      * `onlyOwner` functions anymore. Can only be called by the current owner.
133      *
134      * NOTE: Renouncing ownership will leave the contract without an owner,
135      * thereby removing any functionality that is only available to the owner.
136      */
137     function renounceOwnership() public virtual onlyOwner {
138         _transferOwnership(address(0));
139     }
140 
141     /**
142      * @dev Transfers ownership of the contract to a new account (`newOwner`).
143      * Can only be called by the current owner.
144      */
145     function transferOwnership(address newOwner) public virtual onlyOwner {
146         require(newOwner != address(0), "Ownable: new owner is the zero address");
147         _transferOwnership(newOwner);
148     }
149 
150     /**
151      * @dev Transfers ownership of the contract to a new account (`newOwner`).
152      * Internal function without access restriction.
153      */
154     function _transferOwnership(address newOwner) internal virtual {
155         address oldOwner = _owner;
156         _owner = newOwner;
157         emit OwnershipTransferred(oldOwner, newOwner);
158     }
159 }
160 
161 /**
162  * @dev Contract module which allows children to implement an emergency stop
163  * mechanism that can be triggered by an authorized account.
164  *
165  * This module is used through inheritance. It will make available the
166  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
167  * the functions of your contract. Note that they will not be pausable by
168  * simply including this module, only once the modifiers are put in place.
169  */
170  contract Pausable is Ownable {
171     /**
172      * @dev Emitted when the pause is triggered by `account`.
173      */
174     event Paused(address account);
175 
176     /**
177      * @dev Emitted when the pause is lifted by `account`.
178      */
179     event Unpaused(address account);
180 
181     bool private _paused;
182 
183     /**
184      * @dev Initializes the contract in unpaused state.
185      */
186     constructor() {
187         _paused = false;
188     }
189 
190     /**
191      * @dev Returns true if the contract is paused, and false otherwise.
192      */
193     function paused() public view virtual returns (bool) {
194         return _paused;
195     }
196 
197     /**
198      * @dev Modifier to make a function callable only when the contract is not paused.
199      *
200      * Requirements:
201      *
202      * - The contract must not be paused.
203      */
204     modifier whenNotPaused() {
205         require(!paused(), "Pausable: paused");
206         _;
207     }
208 
209     /**
210      * @dev Modifier to make a function callable only when the contract is paused.
211      *
212      * Requirements:
213      *
214      * - The contract must be paused.
215      */
216     modifier whenPaused() {
217         require(paused(), "Pausable: not paused");
218         _;
219     }
220 
221     /**
222      * @dev Triggers stopped state.
223      *
224      * Requirements:
225      *
226      * - The contract must not be paused.
227      */
228     function pause() external onlyOwner whenNotPaused {
229         _paused = true;
230         emit Paused(msg.sender);
231     }
232 
233     /**
234      * @dev Returns to normal state.
235      *
236      * Requirements:
237      *
238      * - The contract must be paused.
239      */
240     function unpause() external onlyOwner whenPaused {
241         _paused = false;
242         emit Unpaused(msg.sender);
243     }
244 }
245 
246 /// @title Interface for ERC-721: Non-Fungible Tokens
247 interface InterfaceERC721 {
248     // Required methods
249     function totalSupply() external view returns (uint256 total);
250     function balanceOf(address _owner) external view returns (uint256 balance);
251     function ownerOf(uint256 _tokenId) external view returns (address owner);
252     function approve(address _to, uint256 _tokenId) external;
253     function transfer(address _to, uint256 _tokenId) external;
254     function transferFrom(address _from, address _to, uint256 _tokenId) external;
255 
256     // Events
257     event Transfer(address from, address to, uint256 tokenId);
258     event Approval(address owner, address approved, uint256 tokenId);
259 
260    
261 }
262 
263 /**
264  * @dev Interface of the ERC20 standard as defined in the EIP.
265  */
266 interface IERC20 {
267     /**
268      * @dev Emitted when `value` tokens are moved from one account (`from`) to
269      * another (`to`).
270      *
271      * Note that `value` may be zero.
272      */
273     event Transfer(address indexed from, address indexed to, uint256 value);
274 
275     /**
276      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
277      * a call to {approve}. `value` is the new allowance.
278      */
279     event Approval(address indexed owner, address indexed spender, uint256 value);
280 
281     /**
282      * @dev Returns the amount of tokens in existence.
283      */
284     function totalSupply() external view returns (uint256);
285 
286     /**
287      * @dev Returns the amount of tokens owned by `account`.
288      */
289     function balanceOf(address account) external view returns (uint256);
290 
291     /**
292      * @dev Moves `amount` tokens from the caller's account to `to`.
293      *
294      * Returns a boolean value indicating whether the operation succeeded.
295      *
296      * Emits a {Transfer} event.
297      */
298     function transfer(address to, uint256 amount) external returns (bool);
299 
300     /**
301      * @dev Returns the remaining number of tokens that `spender` will be
302      * allowed to spend on behalf of `owner` through {transferFrom}. This is
303      * zero by default.
304      *
305      * This value changes when {approve} or {transferFrom} are called.
306      */
307     function allowance(address owner, address spender) external view returns (uint256);
308 
309     /**
310      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
311      *
312      * Returns a boolean value indicating whether the operation succeeded.
313      *
314      * IMPORTANT: Beware that changing an allowance with this method brings the risk
315      * that someone may use both the old and the new allowance by unfortunate
316      * transaction ordering. One possible solution to mitigate this race
317      * condition is to first reduce the spender's allowance to 0 and set the
318      * desired value afterwards:
319      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
320      *
321      * Emits an {Approval} event.
322      */
323     function approve(address spender, uint256 amount) external returns (bool);
324 
325     /**
326      * @dev Moves `amount` tokens from `from` to `to` using the
327      * allowance mechanism. `amount` is then deducted from the caller's
328      * allowance.
329      *
330      * Returns a boolean value indicating whether the operation succeeded.
331      *
332      * Emits a {Transfer} event.
333      */
334     function transferFrom(
335         address from,
336         address to,
337         uint256 amount
338     ) external returns (bool);
339 }
340 
341 /// @title Auction Core
342 /// @dev Contains models, variables, and internal methods for the auction.
343 /// @notice We omit a fallback function to prevent accidental sends to this contract.
344 contract ClockAuctionBase {
345 
346     // Represents an auction on an NFT
347     struct Auction {
348         // Current owner of NFT
349         address seller;
350         // Price (in wei) at beginning of auction
351         uint128 startingPrice;
352         // Price (in wei) at end of auction
353         uint128 endingPrice;
354         // Duration (in seconds) of auction
355         uint64 duration;
356         // Time when auction started
357         // NOTE: 0 if this auction has been concluded
358         uint64 startedAt;
359 
360         address tokenAddress;
361     }
362 
363     // Reference to contract tracking NFT ownership
364     InterfaceERC721 public nonFungibleContract;
365 
366     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
367     uint256 public ownerCut;
368 
369     // Map from token ID to their corresponding auction.
370     mapping (uint256 => Auction) tokenIdToAuction;
371 
372     event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
373     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
374     event AuctionCancelled(uint256 tokenId);
375 
376     /// @dev Returns true if the claimant owns the token.
377     /// @param _claimant - Address claiming to own the token.
378     /// @param _tokenId - ID of token whose ownership to verify.
379     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
380         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
381     }
382 
383     /// @dev Escrows the NFT, assigning ownership to this contract.
384     /// Throws if the escrow fails.
385     /// @param _owner - Current owner address of token to escrow.
386     /// @param _tokenId - ID of token whose approval to verify.
387     function _escrow(address _owner, uint256 _tokenId) internal {
388         // it will throw if transfer fails
389         nonFungibleContract.transferFrom(_owner, address(this), _tokenId);
390     }
391 
392     /// @dev Transfers an NFT owned by this contract to another address.
393     /// Returns true if the transfer succeeds.
394     /// @param _receiver - Address to transfer NFT to.
395     /// @param _tokenId - ID of token to transfer.
396     function _transfer(address _receiver, uint256 _tokenId) internal {
397         // it will throw if transfer fails
398         nonFungibleContract.transferFrom(address(this), _receiver, _tokenId);
399     }
400 
401     /// @dev Adds an auction to the list of open auctions. Also fires the
402     ///  AuctionCreated event.
403     /// @param _tokenId The ID of the token to be put on auction.
404     /// @param _auction Auction to add.
405     function _addAuction(uint256 _tokenId, Auction memory _auction) internal {
406         // Require that all auctions have a duration of
407         // at least one minute.
408         require(_auction.duration >= 1 minutes);
409 
410         tokenIdToAuction[_tokenId] = _auction;
411 
412         emit AuctionCreated(
413             uint256(_tokenId),
414             uint256(_auction.startingPrice),
415             uint256(_auction.endingPrice),
416             uint256(_auction.duration)
417         );
418     }
419 
420     /// @dev Cancels an auction unconditionally.
421     function _cancelAuction(uint256 _tokenId, address _seller) internal {
422         _removeAuction(_tokenId);
423         _transfer(_seller, _tokenId);
424         emit AuctionCancelled(_tokenId);
425     }
426 
427     /// @dev Computes the price and transfers winnings.
428     function _bid(uint256 _tokenId, uint256 _bidAmount)
429         internal
430         returns (uint256)
431     {
432         // Get a reference to the auction struct
433         Auction storage auction = tokenIdToAuction[_tokenId];
434 
435         // Explicitly check that this auction is currently live.
436         require(_isOnAuction(auction));
437 
438         // Check that the bid is greater than or equal to the current price
439         uint256 price = _currentPrice(auction);
440         require(_bidAmount >= price);
441 
442         address seller = auction.seller;
443 
444         // Remove the auction before sending the fees
445         _removeAuction(_tokenId);
446 
447         // Transfer proceeds to seller (if there are any!)
448         if (price > 0) {
449           
450             uint256 auctioneerCut = _computeCut(price);
451             uint256 sellerProceeds = price - auctioneerCut;
452 
453             payable(seller).transfer(sellerProceeds);
454         }
455 
456         // Calculate any excess funds        
457         uint256 bidExcess = _bidAmount - price;
458         // Return the funds.
459         payable(msg.sender).transfer(bidExcess);
460 
461         // Tell the world!
462         emit AuctionSuccessful(_tokenId, price, msg.sender);
463 
464         return price;
465     }
466 
467     /// @dev Removes an auction from the list of open auctions.
468     /// @param _tokenId - ID of NFT on auction.
469     function _removeAuction(uint256 _tokenId) internal {
470         delete tokenIdToAuction[_tokenId];
471     }
472 
473     /// @dev Returns true if the NFT is on auction.
474     /// @param _auction - Auction to check.
475     function _isOnAuction(Auction memory _auction) internal pure returns (bool) {
476         return (_auction.startedAt > 0);
477     }
478 
479     /// @dev Returns current price of an NFT on auction. 
480     function _currentPrice(Auction memory _auction)
481         internal
482         view
483         returns (uint256)
484     {
485         uint256 secondsPassed = 0;
486         if (block.timestamp > _auction.startedAt) {
487             secondsPassed = block.timestamp - _auction.startedAt;
488         }
489 
490         return _computeCurrentPrice(
491             _auction.startingPrice,
492             _auction.endingPrice,
493             _auction.duration,
494             secondsPassed
495         );
496     }
497 
498     /// @dev Computes the current price of an auction.    
499     function _computeCurrentPrice(
500         uint256 _startingPrice,
501         uint256 _endingPrice,
502         uint256 _duration,
503         uint256 _secondsPassed
504     )
505         internal
506         pure
507         returns (uint256)
508     {
509         
510         if (_secondsPassed >= _duration) {
511             return _endingPrice;
512         } else {
513   
514             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);          
515             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
516             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
517             return uint256(currentPrice);
518         }
519     }
520 
521     /// @dev Computes owner's cut of a sale.
522     /// @param _price - Sale price of NFT.
523     function _computeCut(uint256 _price) internal view returns (uint256) {
524         return _price * ownerCut / 10000;
525     }
526 }
527 
528 
529 contract ClockAuction is Pausable, ClockAuctionBase {
530 
531      bytes4 constant InterfaceSignature_ERC721 = bytes4(0x9a20483d);
532 
533      constructor(address _nftAddress, uint256 _cut)  {
534         require(_cut <= 10000);
535         ownerCut = _cut;
536 
537         InterfaceERC721 candidateContract = InterfaceERC721(_nftAddress);
538         nonFungibleContract = candidateContract;
539     }
540 
541     /// @dev Remove all Ether from the contract, which is the owner's cuts
542     function withdrawBalance() external {
543         address nftAddress = address(nonFungibleContract);
544         require(
545             msg.sender == owner() ||
546             msg.sender == nftAddress
547         );
548         // We are using this boolean method to make sure that even if one fails it will still work
549         bool res = payable(nftAddress).send(address(this).balance);
550         require(res == true, "transfer failed");
551     }
552 
553     /// @dev Creates and begins a new auction.
554     /// @param _tokenId - ID of token to auction, sender must be owner.
555     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
556     /// @param _endingPrice - Price of item (in wei) at end of auction.
557     /// @param _duration - Length of time to move between starting
558     ///  price and ending price (in seconds).
559     /// @param _seller - Seller
560     function createAuction(
561         uint256 _tokenId,
562         uint256 _startingPrice,
563         uint256 _endingPrice,
564         uint256 _duration,
565         address _seller,
566         address _tokenAddress
567     )
568         external virtual
569         whenNotPaused
570     {
571         require(_startingPrice == uint256(uint128(_startingPrice)));
572         require(_endingPrice == uint256(uint128(_endingPrice)));
573         require(_duration == uint256(uint64(_duration)));
574 
575         require(_owns(msg.sender, _tokenId));
576         _escrow(msg.sender, _tokenId);
577         Auction memory auction = Auction(
578             _seller,
579             uint128(_startingPrice),
580             uint128(_endingPrice),
581             uint64(_duration),
582             uint64(block.timestamp),
583             _tokenAddress
584         );
585         _addAuction(_tokenId, auction);
586     }
587 
588     /// @dev Bids on an open auction, completing the auction and transferring
589     ///  ownership of the NFT if enough Ether is supplied.
590     /// @param _tokenId - ID of token to bid on.
591     function bid(uint256 _tokenId)
592         external
593         virtual 
594         payable
595         whenNotPaused
596     {
597         // _bid will throw if the bid or funds transfer fails
598         _bid(_tokenId, msg.value);
599         _transfer(msg.sender, _tokenId);
600     }
601 
602     /// @dev Cancels an auction that hasn't been won yet.
603     ///  Returns the NFT to original owner.
604     /// @notice This is a state-modifying function that can
605     ///  be called while the contract is paused.
606     /// @param _tokenId - ID of token on auction
607     function cancelAuction(uint256 _tokenId)
608         external
609         whenPaused
610     {
611         Auction storage auction = tokenIdToAuction[_tokenId];
612         require(_isOnAuction(auction),"not in auction");
613         address seller = auction.seller;
614         require(msg.sender == seller,"not a seller");
615         _cancelAuction(_tokenId, seller);
616     }
617 
618     /// @dev Cancels an auction when the contract is paused.
619     ///  Only the owner may do this, and NFTs are returned to
620     ///  the seller. This should only be used in emergencies.
621     /// @param _tokenId - ID of the NFT on auction to cancel.
622     function cancelAuctionWhenPaused(uint256 _tokenId)
623         whenPaused
624         onlyOwner
625         external
626     {
627         Auction storage auction = tokenIdToAuction[_tokenId];
628         require(_isOnAuction(auction),"not in auction");
629         _cancelAuction(_tokenId, auction.seller);
630     }
631 
632     /// @dev Returns auction info for an NFT on auction.
633     /// @param _tokenId - ID of NFT on auction.
634     function getAuction(uint256 _tokenId)
635         external
636         view
637         returns
638     (
639         address seller,
640         uint256 startingPrice,
641         uint256 endingPrice,
642         uint256 duration,
643         uint256 startedAt
644     ) {
645         Auction storage auction = tokenIdToAuction[_tokenId];
646         require(_isOnAuction(auction));
647         return (
648             auction.seller,
649             auction.startingPrice,
650             auction.endingPrice,
651             auction.duration,
652             auction.startedAt
653         );
654     }
655 
656     /// @dev Returns the current price of an auction.
657     /// @param _tokenId - ID of the token price we are checking.
658     function getCurrentPrice(uint256 _tokenId)
659         external
660         view
661         returns (uint256)
662     {
663         Auction storage auction = tokenIdToAuction[_tokenId];
664         require(_isOnAuction(auction));
665         return _currentPrice(auction);
666     }
667 
668 }
669 
670 contract SaleClockAuction is ClockAuction {
671 
672     bool public isSaleClockAuction = true;
673     
674     // Tracks last 5 sale price of gen0 rocket sales
675     uint256 public gen0SaleCount;
676     uint256[5] public lastGen0SalePrices;
677 
678     constructor(address _nftAddr, uint256 _cut) 
679         ClockAuction(_nftAddr, _cut) {}
680 
681     /// @dev Creates and begins a new auction.
682     /// @param _tokenId - ID of token to auction, sender must be owner.
683     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
684     /// @param _endingPrice - Price of item (in wei) at end of auction.
685     /// @param _duration - Length of auction (in seconds).
686     /// @param _seller - Seller, if not the message sender
687     function createAuction(
688         uint256 _tokenId,
689         uint256 _startingPrice,
690         uint256 _endingPrice,
691         uint256 _duration,
692         address _seller,
693         address _tokenAddress
694     )
695         external override virtual
696 
697     {
698         require(_startingPrice == uint256(uint128(_startingPrice)));
699         require(_endingPrice == uint256(uint128(_endingPrice)));
700         require(_duration == uint256(uint64(_duration)));
701 
702         require(msg.sender == address(nonFungibleContract),"Not a tokenContract");
703         _escrow(_seller, _tokenId);
704         Auction memory auction = Auction(
705             _seller,
706             uint128(_startingPrice),
707             uint128(_endingPrice),
708             uint64(_duration),
709             uint64(block.timestamp),
710             _tokenAddress
711         );
712         _addAuction(_tokenId, auction);
713     }
714 
715     /// @dev Updates lastSalePrice if seller is the nft contract
716     /// Otherwise, works the same as default bid method.
717     function bid(uint256 _tokenId)
718         external 
719         virtual 
720         override
721         payable
722     {
723         // _bid verifies token ID size
724         address seller = tokenIdToAuction[_tokenId].seller;
725         uint256 price = _bid(_tokenId, msg.value);
726         _transfer(msg.sender, _tokenId);
727 
728         // If not a gen0 auction, exit
729         if (seller == address(nonFungibleContract)) {
730             // Track gen0 sale prices
731             lastGen0SalePrices[gen0SaleCount % 5] = price;
732             gen0SaleCount++;
733         }
734     }
735 
736     function averageGen0SalePrice() external view returns (uint256) {
737         uint256 sum = 0;
738         for (uint256 i = 0; i < 5; i++) {
739             sum += lastGen0SalePrices[i];
740         }
741         return sum / 5;
742     }
743 
744 }
745 
746 /**
747  * @dev Collection of functions related to the address type
748  */
749 library Address {
750     /**
751      * @dev Returns true if `account` is a contract.
752      *
753      * [IMPORTANT]
754      * ====
755      * It is unsafe to assume that an address for which this function returns
756      * false is an externally-owned account (EOA) and not a contract.
757      *
758      * Among others, `isContract` will return false for the following
759      * types of addresses:
760      *
761      *  - an externally-owned account
762      *  - a contract in construction
763      *  - an address where a contract will be created
764      *  - an address where a contract lived, but was destroyed
765      * ====
766      *
767      * [IMPORTANT]
768      * ====
769      * You shouldn't rely on `isContract` to protect against flash loan attacks!
770      *
771      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
772      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
773      * constructor.
774      * ====
775      */
776     function isContract(address account) internal view returns (bool) {
777         // This method relies on extcodesize/address.code.length, which returns 0
778         // for contracts in construction, since the code is only stored at the end
779         // of the constructor execution.
780 
781         return account.code.length > 0;
782     }
783 
784     /**
785      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
786      * `recipient`, forwarding all available gas and reverting on errors.
787      *
788      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
789      * of certain opcodes, possibly making contracts go over the 2300 gas limit
790      * imposed by `transfer`, making them unable to receive funds via
791      * `transfer`. {sendValue} removes this limitation.
792      *
793      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
794      *
795      * IMPORTANT: because control is transferred to `recipient`, care must be
796      * taken to not create reentrancy vulnerabilities. Consider using
797      * {ReentrancyGuard} or the
798      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
799      */
800     function sendValue(address payable recipient, uint256 amount) internal {
801         require(address(this).balance >= amount, "Address: insufficient balance");
802 
803         (bool success, ) = recipient.call{value: amount}("");
804         require(success, "Address: unable to send value, recipient may have reverted");
805     }
806 
807     /**
808      * @dev Performs a Solidity function call using a low level `call`. A
809      * plain `call` is an unsafe replacement for a function call: use this
810      * function instead.
811      *
812      * If `target` reverts with a revert reason, it is bubbled up by this
813      * function (like regular Solidity function calls).
814      *
815      * Returns the raw returned data. To convert to the expected return value,
816      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
817      *
818      * Requirements:
819      *
820      * - `target` must be a contract.
821      * - calling `target` with `data` must not revert.
822      *
823      * _Available since v3.1._
824      */
825     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
826         return functionCall(target, data, "Address: low-level call failed");
827     }
828 
829     /**
830      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
831      * `errorMessage` as a fallback revert reason when `target` reverts.
832      *
833      * _Available since v3.1._
834      */
835     function functionCall(
836         address target,
837         bytes memory data,
838         string memory errorMessage
839     ) internal returns (bytes memory) {
840         return functionCallWithValue(target, data, 0, errorMessage);
841     }
842 
843     /**
844      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
845      * but also transferring `value` wei to `target`.
846      *
847      * Requirements:
848      *
849      * - the calling contract must have an ETH balance of at least `value`.
850      * - the called Solidity function must be `payable`.
851      *
852      * _Available since v3.1._
853      */
854     function functionCallWithValue(
855         address target,
856         bytes memory data,
857         uint256 value
858     ) internal returns (bytes memory) {
859         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
860     }
861 
862     /**
863      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
864      * with `errorMessage` as a fallback revert reason when `target` reverts.
865      *
866      * _Available since v3.1._
867      */
868     function functionCallWithValue(
869         address target,
870         bytes memory data,
871         uint256 value,
872         string memory errorMessage
873     ) internal returns (bytes memory) {
874         require(address(this).balance >= value, "Address: insufficient balance for call");
875         require(isContract(target), "Address: call to non-contract");
876 
877         (bool success, bytes memory returndata) = target.call{value: value}(data);
878         return verifyCallResult(success, returndata, errorMessage);
879     }
880 
881     /**
882      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
883      * but performing a static call.
884      *
885      * _Available since v3.3._
886      */
887     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
888         return functionStaticCall(target, data, "Address: low-level static call failed");
889     }
890 
891     /**
892      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
893      * but performing a static call.
894      *
895      * _Available since v3.3._
896      */
897     function functionStaticCall(
898         address target,
899         bytes memory data,
900         string memory errorMessage
901     ) internal view returns (bytes memory) {
902         require(isContract(target), "Address: static call to non-contract");
903 
904         (bool success, bytes memory returndata) = target.staticcall(data);
905         return verifyCallResult(success, returndata, errorMessage);
906     }
907 
908     /**
909      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
910      * but performing a delegate call.
911      *
912      * _Available since v3.4._
913      */
914     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
915         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
916     }
917 
918     /**
919      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
920      * but performing a delegate call.
921      *
922      * _Available since v3.4._
923      */
924     function functionDelegateCall(
925         address target,
926         bytes memory data,
927         string memory errorMessage
928     ) internal returns (bytes memory) {
929         require(isContract(target), "Address: delegate call to non-contract");
930 
931         (bool success, bytes memory returndata) = target.delegatecall(data);
932         return verifyCallResult(success, returndata, errorMessage);
933     }
934 
935     /**
936      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
937      * revert reason using the provided one.
938      *
939      * _Available since v4.3._
940      */
941     function verifyCallResult(
942         bool success,
943         bytes memory returndata,
944         string memory errorMessage
945     ) internal pure returns (bytes memory) {
946         if (success) {
947             return returndata;
948         } else {
949             // Look for revert reason and bubble it up if present
950             if (returndata.length > 0) {
951                 // The easiest way to bubble the revert reason is using memory via assembly
952 
953                 assembly {
954                     let returndata_size := mload(returndata)
955                     revert(add(32, returndata), returndata_size)
956                 }
957             } else {
958                 revert(errorMessage);
959             }
960         }
961     }
962 }
963 
964 /**
965  * @title ERC721 token receiver interface
966  * @dev Interface for any contract that wants to support safeTransfers
967  * from ERC721 asset contracts.
968  */
969 interface IERC721Receiver {
970     /**
971      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
972      * by `operator` from `from`, this function is called.
973      *
974      * It must return its Solidity selector to confirm the token transfer.
975      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
976      *
977      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
978      */
979     function onERC721Received(
980         address operator,
981         address from,
982         uint256 tokenId,
983         bytes calldata data
984     ) external returns (bytes4);
985 }
986 
987 /**
988  * @dev Interface of the ERC165 standard, as defined in the
989  * https://eips.ethereum.org/EIPS/eip-165[EIP].
990  *
991  * Implementers can declare support of contract interfaces, which can then be
992  * queried by others ({ERC165Checker}).
993  *
994  * For an implementation, see {ERC165}.
995  */
996 interface IERC165 {
997     /**
998      * @dev Returns true if this contract implements the interface defined by
999      * `interfaceId`. See the corresponding
1000      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1001      * to learn more about how these ids are created.
1002      *
1003      * This function call must use less than 30 000 gas.
1004      */
1005     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1006 }
1007 
1008 
1009 /**
1010  * @dev Implementation of the {IERC165} interface.
1011  *
1012  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1013  * for the additional interface id that will be supported. For example:
1014  *
1015  * ```solidity
1016  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1017  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1018  * }
1019  * ```
1020  *
1021  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1022  */
1023 abstract contract ERC165 is IERC165 {
1024     /**
1025      * @dev See {IERC165-supportsInterface}.
1026      */
1027     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1028         return interfaceId == type(IERC165).interfaceId;
1029     }
1030 }
1031 
1032 /**
1033  * @dev Required interface of an ERC721 compliant contract.
1034  */
1035 interface IERC721 is IERC165 {
1036     /**
1037      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1038      */
1039     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1040 
1041     /**
1042      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1043      */
1044     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1045 
1046     /**
1047      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1048      */
1049     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1050 
1051     /**
1052      * @dev Returns the number of tokens in ``owner``'s account.
1053      */
1054     function balanceOf(address owner) external view returns (uint256 balance);
1055 
1056     /**
1057      * @dev Returns the owner of the `tokenId` token.
1058      *
1059      * Requirements:
1060      *
1061      * - `tokenId` must exist.
1062      */
1063     function ownerOf(uint256 tokenId) external view returns (address owner);
1064 
1065     /**
1066      * @dev Safely transfers `tokenId` token from `from` to `to`.
1067      *
1068      * Requirements:
1069      *
1070      * - `from` cannot be the zero address.
1071      * - `to` cannot be the zero address.
1072      * - `tokenId` token must exist and be owned by `from`.
1073      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1074      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1075      *
1076      * Emits a {Transfer} event.
1077      */
1078     function safeTransferFrom(
1079         address from,
1080         address to,
1081         uint256 tokenId,
1082         bytes calldata data
1083     ) external;
1084 
1085     /**
1086      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1087      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1088      *
1089      * Requirements:
1090      *
1091      * - `from` cannot be the zero address.
1092      * - `to` cannot be the zero address.
1093      * - `tokenId` token must exist and be owned by `from`.
1094      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1095      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1096      *
1097      * Emits a {Transfer} event.
1098      */
1099     function safeTransferFrom(
1100         address from,
1101         address to,
1102         uint256 tokenId
1103     ) external;
1104 
1105     /**
1106      * @dev Transfers `tokenId` token from `from` to `to`.
1107      *
1108      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1109      *
1110      * Requirements:
1111      *
1112      * - `from` cannot be the zero address.
1113      * - `to` cannot be the zero address.
1114      * - `tokenId` token must be owned by `from`.
1115      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1116      *
1117      * Emits a {Transfer} event.
1118      */
1119     function transferFrom(
1120         address from,
1121         address to,
1122         uint256 tokenId
1123     ) external;
1124 
1125     /**
1126      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1127      * The approval is cleared when the token is transferred.
1128      *
1129      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1130      *
1131      * Requirements:
1132      *
1133      * - The caller must own the token or be an approved operator.
1134      * - `tokenId` must exist.
1135      *
1136      * Emits an {Approval} event.
1137      */
1138     function approve(address to, uint256 tokenId) external;
1139 
1140     /**
1141      * @dev Approve or remove `operator` as an operator for the caller.
1142      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1143      *
1144      * Requirements:
1145      *
1146      * - The `operator` cannot be the caller.
1147      *
1148      * Emits an {ApprovalForAll} event.
1149      */
1150     function setApprovalForAll(address operator, bool _approved) external;
1151 
1152     /**
1153      * @dev Returns the account approved for `tokenId` token.
1154      *
1155      * Requirements:
1156      *
1157      * - `tokenId` must exist.
1158      */
1159     function getApproved(uint256 tokenId) external view returns (address operator);
1160 
1161     /**
1162      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1163      *
1164      * See {setApprovalForAll}
1165      */
1166     function isApprovedForAll(address owner, address operator) external view returns (bool);
1167 }
1168 
1169 /**
1170  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1171  * @dev See https://eips.ethereum.org/EIPS/eip-721
1172  */
1173 interface IERC721Metadata is IERC721 {
1174     /**
1175      * @dev Returns the token collection name.
1176      */
1177     function name() external view returns (string memory);
1178 
1179     /**
1180      * @dev Returns the token collection symbol.
1181      */
1182     function symbol() external view returns (string memory);
1183 
1184     /**
1185      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1186      */
1187     function tokenURI(uint256 tokenId) external view returns (string memory);
1188 }
1189 
1190 /**
1191  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1192  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1193  * {ERC721Enumerable}.
1194  */
1195 contract ERC721Base is Context, ERC165, IERC721, IERC721Metadata , Pausable{
1196     using Address for address;
1197     using Strings for uint256;
1198 
1199     // Token name
1200     string private _name;
1201 
1202     // Token symbol
1203     string private _symbol;
1204 
1205     // Mapping from token ID to owner address
1206     mapping(uint256 => address) internal _owners;
1207 
1208     // Mapping owner address to token count
1209     mapping(address => uint256) internal _balances;
1210 
1211     // Mapping from token ID to approved address
1212     mapping(uint256 => address) internal _tokenApprovals;
1213 
1214     // Mapping from owner to operator approvals
1215     mapping(address => mapping(address => bool)) internal _operatorApprovals;
1216 
1217      // Base URI
1218     string private baseURI_;
1219 
1220     /**
1221      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1222      */
1223     constructor(string memory name_, string memory symbol_) {
1224         _name = name_;
1225         _symbol = symbol_;
1226     }
1227 
1228     /**
1229      * @dev See {IERC165-supportsInterface}.
1230      */
1231     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1232         return
1233             interfaceId == type(IERC721).interfaceId ||
1234             interfaceId == type(IERC721Metadata).interfaceId ||
1235             super.supportsInterface(interfaceId);
1236     }
1237 
1238     /**
1239      * @dev See {IERC721-balanceOf}.
1240      */
1241     function balanceOf(address owner) public view virtual override returns (uint256) {
1242         require(owner != address(0), "ERC721: balance query for the zero address");
1243         return _balances[owner];
1244     }
1245 
1246     /**
1247      * @dev See {IERC721-ownerOf}.
1248      */
1249     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1250         address owner = _owners[tokenId];
1251         require(owner != address(0), "ERC721: owner query for nonexistent token");
1252         return owner;
1253     }
1254 
1255     /**
1256      * @dev See {IERC721Metadata-name}.
1257      */
1258     function name() public view virtual override returns (string memory) {
1259         return _name;
1260     }
1261 
1262     /**
1263      * @dev See {IERC721Metadata-symbol}.
1264      */
1265     function symbol() public view virtual override returns (string memory) {
1266         return _symbol;
1267     }
1268 
1269     /**
1270      * @dev See {IERC721Metadata-tokenURI}.
1271      */
1272     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1273         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1274 
1275         string memory baseURI = _baseURI();
1276         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1277     }
1278 
1279     /**
1280      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1281      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1282      * by default, can be overriden in child contracts.
1283      */
1284     function _baseURI() internal view virtual  returns (string memory) {
1285         return baseURI_;
1286     }
1287 
1288     /**
1289      * @dev See {IERC721-approve}.
1290      */
1291     function approve(address to, uint256 tokenId) public virtual override {
1292         address owner = ownerOf(tokenId);
1293         require(to != owner, "ERC721: approval to current owner");
1294 
1295         require(
1296             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1297             "ERC721: approve caller is not owner nor approved for all"
1298         );
1299 
1300         _approve(to, tokenId);
1301     }
1302 
1303     /**
1304      * @dev See {IERC721-getApproved}.
1305      */
1306     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1307         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1308 
1309         return _tokenApprovals[tokenId];
1310     }
1311 
1312     /**
1313      * @dev See {IERC721-setApprovalForAll}.
1314      */
1315     function setApprovalForAll(address operator, bool approved) public virtual override {
1316         require(operator != _msgSender(), "ERC721: approve to caller");
1317 
1318         _operatorApprovals[_msgSender()][operator] = approved;
1319         emit ApprovalForAll(_msgSender(), operator, approved);
1320     }
1321 
1322     /**
1323      * @dev See {IERC721-isApprovedForAll}.
1324      */
1325     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1326         return _operatorApprovals[owner][operator];
1327     }
1328 
1329     /**
1330      * @dev See {IERC721-transferFrom}.
1331      */
1332     function transferFrom(
1333         address from,
1334         address to,
1335         uint256 tokenId
1336     ) public virtual override {
1337         //solhint-disable-next-line max-line-length
1338         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1339 
1340         _transfer(from, to, tokenId);
1341     }
1342 
1343     /**
1344      * @dev See {IERC721-safeTransferFrom}.
1345      */
1346     function safeTransferFrom(
1347         address from,
1348         address to,
1349         uint256 tokenId
1350     ) public virtual override {
1351         safeTransferFrom(from, to, tokenId, "");
1352     }
1353 
1354     /**
1355      * @dev See {IERC721-safeTransferFrom}.
1356      */
1357     function safeTransferFrom(
1358         address from,
1359         address to,
1360         uint256 tokenId,
1361         bytes memory _data
1362     ) public virtual override {
1363         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1364         _safeTransfer(from, to, tokenId, _data);
1365     }
1366 
1367     /**
1368      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1369      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1370      *
1371      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1372      *
1373      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1374      * implement alternative mechanisms to perform token transfer, such as signature-based.
1375      *
1376      * Requirements:
1377      *
1378      * - `from` cannot be the zero address.
1379      * - `to` cannot be the zero address.
1380      * - `tokenId` token must exist and be owned by `from`.
1381      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1382      *
1383      * Emits a {Transfer} event.
1384      */
1385     function _safeTransfer(
1386         address from,
1387         address to,
1388         uint256 tokenId,
1389         bytes memory _data
1390     ) internal virtual {
1391         _transfer(from, to, tokenId);
1392         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1393     }
1394 
1395     /**
1396      * @dev Returns whether `tokenId` exists.
1397      *
1398      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1399      *
1400      * Tokens start existing when they are minted (`_mint`),
1401      * and stop existing when they are burned (`_burn`).
1402      */
1403     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1404         return _owners[tokenId] != address(0);
1405     }
1406 
1407     /**
1408      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1409      *
1410      * Requirements:
1411      *
1412      * - `tokenId` must exist.
1413      */
1414     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1415         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1416         address owner = ownerOf(tokenId);
1417         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1418     }
1419 
1420     /**
1421      * @dev Safely mints `tokenId` and transfers it to `to`.
1422      *
1423      * Requirements:
1424      *
1425      * - `tokenId` must not exist.
1426      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1427      *
1428      * Emits a {Transfer} event.
1429      */
1430     function _safeMint(address to, uint256 tokenId) internal virtual {
1431         _safeMint(to, tokenId, "");
1432     }
1433 
1434     /**
1435      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1436      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1437      */
1438     function _safeMint(
1439         address to,
1440         uint256 tokenId,
1441         bytes memory _data
1442     ) internal virtual {
1443         _mint(to, tokenId);
1444         require(
1445             _checkOnERC721Received(address(0), to, tokenId, _data),
1446             "ERC721: transfer to non ERC721Receiver implementer"
1447         );
1448     }
1449 
1450     /**
1451      * @dev Mints `tokenId` and transfers it to `to`.
1452      *
1453      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1454      *
1455      * Requirements:
1456      *
1457      * - `tokenId` must not exist.
1458      * - `to` cannot be the zero address.
1459      *
1460      * Emits a {Transfer} event.
1461      */
1462     function _mint(address to, uint256 tokenId) internal virtual {
1463         if(tokenId != 0){
1464             require(to != address(0), "ERC721: mint to the zero address");
1465         }
1466         require(!_exists(tokenId), "ERC721: token already minted");
1467 
1468         _beforeTokenTransfer(address(0), to, tokenId);
1469 
1470         _balances[to] += 1;
1471         _owners[tokenId] = to;
1472 
1473         emit Transfer(address(0), to, tokenId);
1474     }
1475 
1476     /**
1477      * @dev Destroys `tokenId`.
1478      * The approval is cleared when the token is burned.
1479      *
1480      * Requirements:
1481      *
1482      * - `tokenId` must exist.
1483      *
1484      * Emits a {Transfer} event.
1485      */
1486     function _burn(uint256 tokenId) internal virtual {
1487         address owner = ownerOf(tokenId);
1488 
1489         _beforeTokenTransfer(owner, address(0), tokenId);
1490 
1491         // Clear approvals
1492         _approve(address(0), tokenId);
1493 
1494         _balances[owner] -= 1;
1495         delete _owners[tokenId];
1496 
1497         emit Transfer(owner, address(0), tokenId);
1498     }
1499 
1500     /**
1501      * @dev Transfers `tokenId` from `from` to `to`.
1502      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1503      *
1504      * Requirements:
1505      *
1506      * - `to` cannot be the zero address.
1507      * - `tokenId` token must be owned by `from`.
1508      *
1509      * Emits a {Transfer} event.
1510      */
1511     function _transfer(
1512         address from,
1513         address to,
1514         uint256 tokenId
1515     ) internal virtual {
1516         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1517         require(to != address(0), "ERC721: transfer to the zero address");
1518 
1519         _beforeTokenTransfer(from, to, tokenId);
1520 
1521         // Clear approvals from the previous owner
1522         _approve(address(0), tokenId);
1523 
1524         _balances[from] -= 1;
1525         _balances[to] += 1;
1526         _owners[tokenId] = to;
1527 
1528         emit Transfer(from, to, tokenId);
1529     }
1530 
1531     /**
1532      * @dev Approve `to` to operate on `tokenId`
1533      *
1534      * Emits a {Approval} event.
1535      */
1536     function _approve(address to, uint256 tokenId) internal virtual {
1537         _tokenApprovals[tokenId] = to;
1538         emit Approval(ownerOf(tokenId), to, tokenId);
1539     }
1540 
1541     /**
1542      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1543      * The call is not executed if the target address is not a contract.
1544      *
1545      * @param from address representing the previous owner of the given token ID
1546      * @param to target address that will receive the tokens
1547      * @param tokenId uint256 ID of the token to be transferred
1548      * @param _data bytes optional data to send along with the call
1549      * @return bool whether the call correctly returned the expected magic value
1550      */
1551     function _checkOnERC721Received(
1552         address from,
1553         address to,
1554         uint256 tokenId,
1555         bytes memory _data
1556     ) private returns (bool) {
1557         if (to.isContract()) {
1558             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1559                 return retval == IERC721Receiver(to).onERC721Received.selector;
1560             } catch (bytes memory reason) {
1561                 if (reason.length == 0) {
1562                     revert("ERC721: transfer to non ERC721Receiver implementer");
1563                 } else {
1564                     assembly {
1565                         revert(add(32, reason), mload(reason))
1566                     }
1567                 }
1568             }
1569         } else {
1570             return true;
1571         }
1572     }
1573 
1574     /**
1575      * @dev Hook that is called before any token transfer. This includes minting
1576      * and burning.
1577      *
1578      * Calling conditions:
1579      *
1580      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1581      * transferred to `to`.
1582      * - When `from` is zero, `tokenId` will be minted for `to`.
1583      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1584      * - `from` and `to` are never both zero.
1585      *
1586      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1587      */
1588     function _beforeTokenTransfer(
1589         address from,
1590         address to,
1591         uint256 tokenId
1592     ) internal virtual {}
1593 
1594        /**
1595      * @dev function to set the contract URI
1596      * @param _baseTokenURI string URI prefix to assign
1597      */
1598     function setBaseURI(string calldata _baseTokenURI) external onlyOwner {
1599         _setBaseURI(_baseTokenURI);
1600     }
1601 
1602     /**
1603      * @dev Internal function to set the base URI for all token IDs. It is
1604      * automatically added as a prefix to the value returned in {tokenURI},
1605      * or to the token ID if {tokenURI} is empty.
1606      */
1607     function _setBaseURI(string memory _baseUri) internal virtual {
1608         baseURI_ = _baseUri;
1609     }
1610 
1611     /**
1612      * @dev Returns the base URI set via {_setBaseURI}. This will be
1613      * automatically added as a prefix in {tokenURI} to each token's URI, or
1614      * to the token ID if no specific URI is set for that token ID.
1615      */
1616     function baseUri() public view returns (string memory) {
1617         return baseURI_;
1618     }    
1619 
1620 
1621 }
1622 
1623 
1624 contract RocketBase is ERC721Base("Rocket", "RocketDash") {
1625 
1626     /// @dev The Build event is fired whenever a new rocket comes into existence.
1627     event Build(address owner, uint256 rocketId, uint256 inventorModelId, uint256 architectModelId);
1628 
1629   
1630     struct Rocket {
1631 
1632         // The timestamp from the block when this rocketcame into existence.
1633         uint64 buildTime;
1634 
1635         // The minimum timestamp after which this rocket can able build
1636         // new rockets again.
1637         uint64 recoveryEndTime;
1638 
1639         // The ID of the originator of this rocket, set to 0 for gen0 rockets.
1640         uint32 inventorModelId;
1641         uint32 architectModelId;
1642 
1643         // Set to the ID of the architectModel rocketfor inventorModels that are preProduction,
1644         // zero otherwise. 
1645         uint32 ProcessingWithId;
1646 
1647         // Set to the index in the recovery array (see below) that represents
1648         // the current recovery duration for this Rocket. This starts at zero
1649         // for gen0 rockets, and is initialized to floor(generation/2) for others.
1650         // Incremented by one for each successful building action, regardless
1651         // of whether this rocketis acting as inventorModel or architectModel.
1652         uint16 recoveryIndex;
1653 
1654         // The "generation number" of this rocket.
1655         // for sale are called "gen0" and have a generation number of 0. The
1656         // generation number of all other rockets is the larger of the two generation
1657         // numbers of their originator, plus one.
1658         // (i.e. max(inventorModel.generation, architectModel.generation) + 1)
1659         uint16 generation;
1660     }
1661 
1662     /*** CONSTANTS ***/
1663 
1664     /// @dev A lookup table rocketing the recovery duration after any successful
1665     ///  building action, called "processing time" for inventorModels and "Processing recovery"
1666     ///  for architectModels. Designed such that the recovery roughly doubles each time a rocket
1667     ///  is build, encouraging owners not to just keep building the same rocketover
1668     ///  and over again. Caps out at one week (a rocketcan build an unbounded number
1669     ///  of times, and the maximum recovery is always seven days).
1670     uint32[14] public recovery = [
1671         uint32(1 minutes),
1672         uint32(2 minutes),
1673         uint32(5 minutes),
1674         uint32(10 minutes),
1675         uint32(30 minutes),
1676         uint32(1 hours),
1677         uint32(2 hours),
1678         uint32(4 hours),
1679         uint32(8 hours),
1680         uint32(16 hours),
1681         uint32(1 days),
1682         uint32(2 days),
1683         uint32(4 days),
1684         uint32(7 days)
1685     ];
1686 
1687     /*** STORAGE ***/
1688 
1689     /// @dev An array containing the Rocket struct for all rockets in existence. The ID
1690     ///  of each rocketis actually an index into this array. 
1691     Rocket[] rockets;
1692 
1693     /// @dev A mapping from RocketIDs to an address that has been approved to use
1694     ///  this Rocket for Processing via buildWith(). Each Rocket can only have one approved
1695     ///  address for Processing at any time. A zero value means no approval is outstanding.
1696     mapping (uint256 => address) public architectModelAllowedToAddress;
1697 
1698     /// @dev The address of the ClockAuction contract that handles sales of rockets. This
1699     ///  same contract handles both peer-to-peer sales as well as the gen0 sales. 
1700     SaleClockAuction public saleAuction;
1701 
1702     constructor(){
1703 
1704     }
1705 
1706      function _transfer(
1707         address from,
1708         address to,
1709         uint256 tokenId
1710     ) internal virtual override {
1711         super._transfer(from, to, tokenId);
1712         // once the rocket is transferred also clear architectModel allowances
1713         delete architectModelAllowedToAddress[tokenId];
1714     }
1715 
1716     /// @dev An internal method that creates a new rocket and stores it. This
1717     /// @param _inventorModelId The rocket ID of the inventorModel of this rocket(zero for gen0)
1718     /// @param _architectModelId The rocket ID of the architectModel of this rocket(zero for gen0)
1719     /// @param _generation The generation number of this rocket, must be computed by caller.
1720     /// @param _owner The inital owner of this rocket, must be non-zero (except for the unRocket, ID 0)
1721     function _createRocket(
1722         uint256 _inventorModelId,
1723         uint256 _architectModelId,
1724         uint256 _generation,
1725         address _owner
1726     )
1727         internal
1728         returns (uint)
1729     {
1730 
1731         require(_inventorModelId == uint256(uint32(_inventorModelId)));
1732         require(_architectModelId == uint256(uint32(_architectModelId)));
1733         require(_generation == uint256(uint16(_generation)));
1734 
1735         // New rocket starts with the same recovery as parent gen/2
1736         uint16 recoveryIndex = uint16(_generation / 2);
1737         if (recoveryIndex > 13) {
1738             recoveryIndex = 13;
1739         }
1740 
1741         Rocket memory _rocket = Rocket({
1742             buildTime: uint64(block.timestamp),
1743             recoveryEndTime: 0,
1744             inventorModelId: uint32(_inventorModelId),
1745             architectModelId: uint32(_architectModelId),
1746             ProcessingWithId: 0,
1747             recoveryIndex: recoveryIndex,
1748             generation: uint16(_generation)
1749         });
1750         rockets.push(_rocket);
1751         uint256 newrocketId =  rockets.length;
1752 
1753       
1754         require(newrocketId == uint256(uint32(newrocketId)));
1755 
1756         // emit the build event
1757         emit Build(
1758             _owner,
1759             newrocketId,
1760             uint256(_rocket.inventorModelId),
1761             uint256(_rocket.architectModelId)
1762         );
1763 
1764         // This will assign ownership, and also emit the Transfer event as
1765         // per ERC721 draft
1766         _mint(_owner, newrocketId);
1767 
1768         return newrocketId;
1769     }
1770 
1771     /// @notice Returns the total number of rockets currently in existence.
1772     /// @dev Required for ERC-721 compliance.
1773     function totalSupply() public view returns (uint) {
1774         return rockets.length - 1;
1775     }
1776 
1777     /// @notice Returns a list of all Rocket IDs assigned to an address.
1778     /// @param _owner The owner whose rockets we are interested in.
1779     /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
1780     ///  expensive (it walks the entire Rocket array looking for rockets belonging to owner),
1781     ///  but it also returns a dynamic array, which is only supported for web3 calls, and
1782     ///  not contract-to-contract calls.
1783     function tokensOfOwner(address _owner) external view returns(uint256[] memory ownerTokens) {
1784         uint256 tokenCount = balanceOf(_owner);
1785 
1786         if (tokenCount == 0) {
1787             // Return an empty array
1788             return new uint256[](0);
1789         } else {
1790             uint256[] memory result = new uint256[](tokenCount);
1791             uint256 totalRockets = totalSupply();
1792             uint256 resultIndex = 0;
1793 
1794             // We count on the fact that all rockets have IDs starting at 1 and increasing
1795             // sequentially up to the totalRocketcount.
1796             uint256 rocketId;
1797 
1798             for (rocketId = 1; rocketId <= totalRockets; rocketId++) {
1799                 if (_owners[rocketId] == _owner) {
1800                     result[resultIndex] = rocketId;
1801                     resultIndex++;
1802                 }
1803             }
1804 
1805             return result;
1806         }
1807     }
1808 
1809   function setRecovery(uint32[14] calldata  _recovery) external onlyOwner {
1810         recovery = _recovery;
1811     }
1812 }
1813 
1814 contract RocketBuildBase is RocketBase{
1815 
1816     event Inventing(address owner, uint256 inventorModelId, uint256 architectModelId, uint256 recoveryEndTime);
1817 
1818     /// @notice The minimum payment required to use build new rocket 
1819     uint256 public autoBuildFee = 2e15;
1820     // platform charge percentage
1821     uint256 public charge = 10; // 10 equals 1% 
1822     // Keeps track of number of preProduction rocket.
1823     uint256 public preProductionRockets;
1824  
1825     /// @dev Checks that a given rocket is able to build. Requires that the
1826     ///  current recovery is finished (for architectModels) and also checks that there is
1827     ///  no pending processing.
1828     function _isReadyToBuild(Rocket memory _rocket) internal view returns (bool) {
1829         // In addition to checking the recoveryEndTime, we also need to check to see if
1830         // the rockethas a pending launch; there can be some period of time between the end
1831         // of the processing timer and the build event.
1832         return (_rocket.ProcessingWithId == 0) && (_rocket.recoveryEndTime <= uint64(block.timestamp));
1833     }
1834 
1835     /// @dev Check if a architectModel has authorized building with this inventorModel. True if both architectModel
1836     ///  and inventorModel have the same owner, or if the architectModel has given build permission to
1837     ///  the inventorModel's owner (via approveArchitectModel()).
1838     function _isArchitectModelPermitted(uint256 _architectModelId, uint256 _inventorModelId) internal view returns (bool) {
1839         address inventorModelOwner = _owners[_inventorModelId];
1840         address architectModelOwner = _owners[_architectModelId];
1841 
1842         // ArchitectModel is okay if they have same owner, or if the inventorModel's owner was given
1843         // permission to build with this architectModel.
1844         return (inventorModelOwner == architectModelOwner || architectModelAllowedToAddress[_architectModelId] == inventorModelOwner);
1845     }
1846 
1847     /// @dev Set the recoveryEndTime for the given Rocket, based on its current recoveryIndex.
1848     ///  Also increments the recoveryIndex (unless it has hit the cap).
1849     /// @param _rocket A reference to the Rocket in storage which needs its timer started.
1850     function _triggerRecovery(Rocket storage _rocket) internal {
1851         // Compute an estimation of the recovery time in blocks (based on current recoveryIndex).
1852         _rocket.recoveryEndTime = uint64((recovery[_rocket.recoveryIndex]) + block.timestamp);
1853 
1854         // Increment the building count, clamping it at 13
1855         if (_rocket.recoveryIndex < 13) {
1856             _rocket.recoveryIndex += 1;
1857         }
1858     }
1859 
1860     /// @notice Grants approval to another user to architectModel with one of your Rocket.
1861     /// @param _addr The address that will be able to  create new rocket using architectModel with your Rocket. Set to
1862     ///  address(0) to clear all Processing approvals for this Rocket.
1863     /// @param _architectModelId A Rocket that you own that _addr will now be able to architectModel with.
1864     function approveArchitectModel(address _addr, uint256 _architectModelId)
1865         external
1866         whenNotPaused
1867     {
1868         require(_owns(msg.sender, _architectModelId));
1869         architectModelAllowedToAddress[_architectModelId] = _addr;
1870     }
1871 
1872     /// @dev Updates the minimum payment required for building new rocket. 
1873     function setAutoBuildFee(uint256 val) external onlyOwner {
1874         autoBuildFee = val;
1875     }
1876 
1877     /// @dev Checks to see if a given Rocket is preProduction and (if so) if the processing
1878     ///  period has passed.
1879     function _isReadyToLaunch(Rocket memory _inventorModel) private view returns (bool) {
1880         return (_inventorModel.ProcessingWithId != 0) && (_inventorModel.recoveryEndTime <= uint64(block.timestamp));
1881     }
1882 
1883     /// @notice Checks that a given rocket is able to build (i.e. it is not preProduction or
1884     ///  in the middle of a Processing recovery).
1885     /// @param _rocketId reference the id of the rocket, any user can inquire about it
1886     function isReadyToBuild(uint256 _rocketId)
1887         public
1888         view
1889         returns (bool)
1890     {
1891         require(_rocketId > 0);
1892         Rocket storage _rocket = rockets[_rocketId];
1893         return _isReadyToBuild(_rocket);
1894     }
1895 
1896     /// @dev Checks whether a rocket is currently preProduction.
1897     /// @param _rocketId reference the id of the rocket, any user can inquire about it
1898     function isInventing(uint256 _rocketId)
1899         public
1900         view
1901         returns (bool)
1902     {
1903         require(_rocketId > 0);
1904         // A rocket is preProduction if and only if this field is set
1905         return rockets[_rocketId].ProcessingWithId != 0;
1906     }
1907 
1908     /// @dev Internal check to see if a given architectModel and inventorModel are a valid inventor model.
1909     /// @param _inventorModel A reference to the Rocket struct of the potential inventorModel.
1910     /// @param _inventorModelId The inventorModel's ID.
1911     /// @param _architectModel A reference to the Rocket struct of the potential architectModel.
1912     /// @param _architectModelId The architectModel's ID
1913     function _isValidInventorModel(
1914         Rocket storage _inventorModel,
1915         uint256 _inventorModelId,
1916         Rocket storage _architectModel,
1917         uint256 _architectModelId
1918     )
1919         private
1920         view
1921         returns(bool)
1922     {
1923         // A Rocket can't build with itself!
1924         if (_inventorModelId == _architectModelId) {
1925             return false;
1926         }
1927 
1928         // Rocket can't build with inventor .
1929         if (_inventorModel.inventorModelId == _architectModelId || _inventorModel.architectModelId == _architectModelId) {
1930             return false;
1931         }
1932         if (_architectModel.inventorModelId == _inventorModelId || _architectModel.architectModelId == _inventorModelId) {
1933             return false;
1934         }
1935 
1936         // We can short circuit the  co model check (below) if either rocketis
1937         // gen zero (has a inventorModel ID of zero).
1938         if (_architectModel.inventorModelId == 0 || _inventorModel.inventorModelId == 0) {
1939             return true;
1940         }
1941 
1942         // Rocket can't build with full or half co models.
1943         if (_architectModel.inventorModelId == _inventorModel.inventorModelId || _architectModel.inventorModelId == _inventorModel.architectModelId) {
1944             return false;
1945         }
1946         if (_architectModel.architectModelId == _inventorModel.inventorModelId || _architectModel.architectModelId == _inventorModel.architectModelId) {
1947             return false;
1948         }
1949 
1950         return true;
1951     }
1952 
1953     /// @dev Internal check to see if a given architectModel and inventorModel are a valid inventor model for
1954     ///  building via auction (i.e. skips ownership and Processing approval checks).
1955     function _canBuildWithViaAuction(uint256 _inventorModelId, uint256 _architectModelId)
1956         internal
1957         view
1958         returns (bool)
1959     {
1960         Rocket storage inventorModel = rockets[_inventorModelId];
1961         Rocket storage architectModel = rockets[_architectModelId];
1962         return _isValidInventorModel(inventorModel, _inventorModelId, architectModel, _architectModelId);
1963     }
1964 
1965     /// @notice Checks to see if two rocket can build together, including checks for
1966     ///  ownership and Processing approvals. 
1967     /// @param _inventorModelId The ID of the proposed inventorModel.
1968     /// @param _architectModelId The ID of the proposed architectModel.
1969     function canBuildWith(uint256 _inventorModelId, uint256 _architectModelId)
1970         external
1971         view
1972         returns(bool)
1973     {
1974         require(_inventorModelId > 0);
1975         require(_architectModelId > 0);
1976         Rocket storage inventorModel = rockets[_inventorModelId];
1977         Rocket storage architectModel = rockets[_architectModelId];
1978         return _isValidInventorModel(inventorModel, _inventorModelId, architectModel, _architectModelId) &&
1979             _isArchitectModelPermitted(_architectModelId, _inventorModelId);
1980     }
1981 
1982     /// @dev Internal utility function to initiate building, assumes that all building
1983     ///  requirements have been checked.
1984     function _buildWith(uint256 _inventorModelId, uint256 _architectModelId) internal {
1985         // Grab a reference to the Rocket from storage.
1986         Rocket storage architectModel = rockets[_architectModelId];
1987         Rocket storage inventorModel = rockets[_inventorModelId];
1988 
1989         inventorModel.ProcessingWithId = uint32(_architectModelId);
1990 
1991         // Trigger the recovery for both inventor .
1992         _triggerRecovery(architectModel);
1993         _triggerRecovery(inventorModel);
1994 
1995         // Clear Processing permission for both inventor . This may not be strictly necessary
1996         delete architectModelAllowedToAddress[_inventorModelId];
1997         delete architectModelAllowedToAddress[_architectModelId];
1998 
1999         // Every time a new rocket gets in preProduction, counter is incremented.
2000         preProductionRockets++;
2001 
2002         // Emit the processing event.
2003         emit Inventing(_owners[_inventorModelId], _inventorModelId, _architectModelId, inventorModel.recoveryEndTime);
2004     }
2005 
2006     /// @notice Build a Rocket you own (as inventorModel) with a architectModel that you own, or for which you
2007     ///  have previously been given ArchitectModel approval. Will either make your rocket preProduction, or will
2008     ///  fail entirely. Requires a pre-payment of the fee given out to the first caller of giveBuild()
2009     /// @param _inventorModelId The ID of the Rocket acting as inventorModel (will end up preProduction if successful)
2010     /// @param _architectModelId The ID of the Rocket acting as architectModel (will begin its Processing recovery if successful)
2011     function buildNewRocket(uint256 _inventorModelId, uint256 _architectModelId)
2012         external
2013         payable
2014         whenNotPaused
2015     {
2016         // Checks for payment.
2017         require(msg.value >= autoBuildFee);
2018 
2019         // Caller must own the inventorModel.
2020         require(_owns(msg.sender, _inventorModelId));
2021       
2022         // Check that inventorModel and architectModel are both owned by caller, or that the architectModel
2023         // has given Processing permission to caller (i.e. inventorModel's owner).
2024         // Will fail for _architectModelId = 0
2025         require(_isArchitectModelPermitted(_architectModelId, _inventorModelId));
2026 
2027         // Grab a reference to the potential inventorModel
2028         Rocket storage inventorModel = rockets[_inventorModelId];
2029 
2030         // Make sure inventorModel isn't preProduction, or in the middle of a Processing recovery
2031         require(_isReadyToBuild(inventorModel));
2032 
2033         // Grab a reference to the potential architectModel
2034         Rocket storage architectModel = rockets[_architectModelId];
2035 
2036         // Make sure architectModel isn't preProduction, or in the middle of a Processing recovery
2037         require(_isReadyToBuild(architectModel));
2038 
2039         // Test that these rocket are a valid inventor model.
2040         require(_isValidInventorModel(
2041             inventorModel,
2042             _inventorModelId,
2043             architectModel,
2044             _architectModelId
2045         ));
2046 
2047         // All checks passed, rocket gets preProduction!
2048         _buildWith(_inventorModelId, _architectModelId);
2049     }
2050 
2051     /// @notice Have a preProduction Rocket give build!
2052     /// @param _inventorModelId A Rocket ready to give build.
2053     /// @return The Rocket ID of the new rocket.
2054     /// @dev Looks at a given Rocket and, if preProduction and if the processing period has passed,
2055     ///  combines the  of the two inventor  to create a new rocket. The new Rocket is assigned
2056     ///  to the current owner of the inventorModel. Upon successful completion, both the inventorModel and the
2057     ///  new rocket will be ready to build again. Note that anyone can call this function (if they
2058     ///  are willing to pay the gas!), but the new rocket always goes to the inventorModel's owner.
2059     function LaunchRocket(uint256 _inventorModelId)
2060         external
2061         whenNotPaused
2062         returns(uint256)
2063     {
2064         // Grab a reference to the inventorModel in storage.
2065         Rocket storage inventorModel = rockets[_inventorModelId];
2066 
2067         // Check that the inventorModel is a valid rocket.
2068         require(inventorModel.buildTime != 0);
2069 
2070         // Check that its time has come!
2071         require(_isReadyToLaunch(inventorModel));
2072 
2073         // Grab a reference to the architectModel in storage.
2074         uint256 architectModelId = inventorModel.ProcessingWithId;
2075         Rocket storage architectModel = rockets[architectModelId];
2076 
2077         // Determine the higher generation number of the two inventor 
2078         uint16 parentGen = inventorModel.generation;
2079         if (architectModel.generation > inventorModel.generation) {
2080             parentGen = architectModel.generation;
2081         }
2082 
2083 
2084         // Make the new rocket!
2085         address owner = _owners[_inventorModelId];
2086         uint256 rocketId = _createRocket(_inventorModelId, inventorModel.ProcessingWithId, parentGen + 1,  owner);
2087 
2088         delete inventorModel.ProcessingWithId;
2089 
2090         // Every time a rocket gives build counter is decremented.
2091         preProductionRockets--;
2092 
2093         // Send the balance fee to the person who made build happen.
2094         payable(msg.sender).transfer(autoBuildFee-(autoBuildFee*charge/1000));
2095 
2096         // return the new rocket's ID
2097         return rocketId;
2098     }
2099 
2100     /// @dev Returns true if the claimant owns the token.
2101     /// @param _claimant - Address claiming to own the token.
2102     /// @param _tokenId - ID of token whose ownership to verify.
2103     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
2104         return (ownerOf(_tokenId) == _claimant);
2105     }
2106 
2107 }
2108 
2109 contract AuctionBase is RocketBuildBase {
2110 
2111     /// @dev Sets the reference to the sale auction.
2112     /// @param _address - Address of sale contract.
2113     function setSaleAuctionAddress(address _address) external onlyOwner {
2114         SaleClockAuction candidateContract = SaleClockAuction(_address);
2115 
2116         require(candidateContract.isSaleClockAuction());
2117 
2118         // Set the new contract address
2119         saleAuction = candidateContract;
2120     }
2121 
2122     /// @dev Put a rocket up for auction.
2123     ///  Does some ownership trickery to create auctions in one tx.
2124     function createSaleAuction(
2125         uint256 _rocketId,
2126         uint256 _startingPrice,
2127         uint256 _endingPrice,
2128         uint256 _duration,
2129         address _tokenAddress
2130     )
2131         external
2132         whenNotPaused
2133     {
2134         // Auction contract checks input sizes
2135         // If rocket is already on any auction, this will throw
2136         // because it will be owned by the auction contract.
2137         require(_owns(msg.sender, _rocketId));
2138         // Ensure the rocket is not inventing to prevent the auction
2139         // contract accidentally receiving ownership of the child.
2140         // NOTE: the rocket IS allowed to be in a recovery.
2141         require(!isInventing(_rocketId));
2142         _approve(address(saleAuction),_rocketId);
2143         // Sale auction throws if inputs are invalid and clears
2144         // transfer and architectModel approval after escrowing the rocket.
2145         saleAuction.createAuction(
2146             _rocketId,
2147             _startingPrice,
2148             _endingPrice,
2149             _duration,
2150             msg.sender,
2151             _tokenAddress
2152         );
2153     }
2154     
2155     /// @dev Transfers the balance of the sale auction contract
2156     /// to the RocketCore contract. We use two-step withdrawal to
2157     /// prevent two transfer calls in the auction bid function.
2158     function withdrawAuctionBalances() external onlyOwner {
2159         saleAuction.withdrawBalance();
2160     }
2161 }
2162 
2163 contract RocketdashMinting is AuctionBase {
2164 
2165     // Constants for gen0 auctions.
2166     uint256 public constant GEN0_STARTING_PRICE = 10e15;
2167     uint256 public constant GEN0_AUCTION_DURATION = 1 days;
2168 
2169     // Counts the number of rockets the contract owner has created.
2170     uint256 public promoCreatedCount;
2171     uint256 public gen0CreatedCount;
2172     uint256 public elononeCreatedCount;
2173 
2174     uint256 public initTime;
2175 
2176     address elonone = 0x97b65710D03E12775189F0D113202cc1443b0aa2;
2177     uint256 elononeRequirement = 40000000000 * 10**9; // 40b
2178 
2179     // for future business collab partner rockets
2180     // vars needed to split mint fees with partners and set price, time frame
2181     uint256 mintPrice;
2182     uint256 mintInit;
2183     uint256 mintPeriod;
2184     address payable partnerAddress;
2185     address payable teamAddress;
2186 
2187     mapping(address => bool) hasMinted;
2188 
2189     constructor (string memory _baseUri) {
2190         _setBaseURI(_baseUri);
2191     }
2192 
2193     IERC20 _elonone = IERC20(elonone);
2194 
2195     // to stop bot smart contracts from frontrunning minting
2196     modifier noContract(address account) {
2197         require(Address.isContract(account) == false, "Contracts are not allowed to interact with the farm");
2198         _;
2199     }
2200 
2201     function initElononeMint() external onlyOwner {
2202         initTime = block.timestamp;
2203     }
2204 
2205     function mintElononeRocket() external noContract(msg.sender) {
2206         uint256 bal = _elonone.balanceOf(msg.sender);
2207         require(bal >= elononeRequirement, "you need more ELONONE!");
2208         require(block.timestamp < initTime + 3 days, "ELONONE mint is over!");
2209         require(!hasMinted[msg.sender], "already minted");
2210         _createRocket(0, 0, 0, msg.sender);
2211         hasMinted[msg.sender] = true;
2212         gen0CreatedCount++;
2213         elononeCreatedCount++;
2214     }
2215 
2216     // 1 partner mint event at a time only
2217     function initPartnershipMintWithParams(uint256 _mintPrice, uint256 _mintPeriod, address payable _partnerAddress, address payable _teamAddress) external onlyOwner {
2218         mintPrice = _mintPrice;
2219         mintInit = block.timestamp;
2220         mintPeriod = _mintPeriod;
2221         partnerAddress = _partnerAddress;
2222         teamAddress = _teamAddress;
2223     }
2224 
2225     function mintPartnershipRocket() external payable noContract(msg.sender) {
2226         require(block.timestamp < mintInit + mintPeriod, "mint is over");
2227         require(msg.value >= mintPrice, "not enough ether supplied");
2228         _createRocket(0, 0, 0, msg.sender);
2229         gen0CreatedCount++;
2230         uint256 divi = msg.value / 2;
2231         partnerAddress.transfer(divi);
2232         teamAddress.transfer(divi);
2233     }
2234 
2235     function createMultipleRocket(address[] memory _owner,uint256 _count) external onlyOwner {
2236         require(_owner.length == _count,"Invalid count of minting");
2237         uint i;
2238         for(i = 0; i < _owner.length; i++){
2239 
2240             address rocketOwner = _owner[i];
2241             if (rocketOwner == address(0)) {
2242                 rocketOwner = owner();
2243             }
2244 
2245             promoCreatedCount++;
2246             _createRocket(0, 0, 0,  rocketOwner);
2247         }
2248     }
2249 
2250     /// @dev Creates a new gen0 rocket
2251     ///  creates an auction for it.
2252     function createGen0Auction(address _tokenAddress) external onlyOwner {
2253 
2254         uint256 rocketId = _createRocket(0, 0, 0, address(this));
2255         _approve(address(saleAuction), rocketId);
2256 
2257         saleAuction.createAuction(
2258             rocketId,
2259             _computeNextGen0Price(),
2260             0,
2261             GEN0_AUCTION_DURATION,
2262             address(this),
2263             _tokenAddress
2264         );
2265 
2266         gen0CreatedCount++;
2267     }
2268 
2269     /// @dev Computes the next gen0 auction starting price, given
2270     ///  the average of the past 5 prices + 50%.
2271     function _computeNextGen0Price() internal view returns (uint256) {
2272         uint256 avePrice = saleAuction.averageGen0SalePrice();
2273 
2274         // Sanity check to ensure we don't overflow arithmetic
2275         require(avePrice == uint256(uint128(avePrice)));
2276         uint256 nextPrice = avePrice + (avePrice / 2);
2277 
2278         // We never auction for less than starting price
2279         if (nextPrice < GEN0_STARTING_PRICE) {
2280             nextPrice = GEN0_STARTING_PRICE;
2281         }
2282         return nextPrice;
2283     }
2284 
2285 
2286     /// @notice Returns all the relevant information about a specific rocket.
2287     /// @param _id The ID of the rocket of interest.
2288     function getRocket(uint256 _id)
2289         external
2290         view
2291         returns (
2292         bool isProcessing,
2293         bool isReady,
2294         uint256 recoveryIndex,
2295         uint256 nextActionAt,
2296         uint256 ProcessingWithId,
2297         uint256 buildTime,
2298         uint256 inventorModelId,
2299         uint256 architectModelId,
2300         uint256 generation
2301     ) {
2302         Rocket storage _rocket = rockets[_id];
2303 
2304         // if this variable is 0 then it's not building 
2305         isProcessing = (_rocket.ProcessingWithId != 0);
2306         isReady = (_rocket.recoveryEndTime <= block.timestamp);
2307         recoveryIndex = uint256(_rocket.recoveryIndex);
2308         nextActionAt = uint256(_rocket.recoveryEndTime);
2309         ProcessingWithId = uint256(_rocket.ProcessingWithId);
2310         buildTime = uint256(_rocket.buildTime);
2311         inventorModelId = uint256(_rocket.inventorModelId);
2312         architectModelId = uint256(_rocket.architectModelId);
2313         generation = uint256(_rocket.generation);
2314     }
2315 
2316      // @dev Allows the owner to capture the balance available to the contract.
2317     function withdrawBalance() external onlyOwner {
2318         uint256 balance = address(this).balance;
2319         // Subtract all the currently preProduction rockets we have, plus 1 of margin.
2320         uint256 subtractFees = (preProductionRockets + 1) * autoBuildFee;
2321 
2322         if (balance > subtractFees) {
2323             payable(msg.sender).transfer(balance - subtractFees);
2324         }
2325     }
2326     
2327     // @dev allow contract to receive ether 
2328     receive () external payable {}
2329 
2330 }