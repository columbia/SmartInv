1 pragma solidity ^0.4.24;
2 
3 contract ERC165Interface {
4     /**
5      * @notice Query if a contract implements an interface
6      * @param interfaceID The interface identifier, as specified in ERC-165
7      * @dev Interface identification is specified in ERC-165. This function
8      *  uses less than 30,000 gas.
9      * @return `true` if the contract implements `interfaceID` and
10      *  `interfaceID` is not 0xffffffff, `false` otherwise
11      */
12     function supportsInterface(bytes4 interfaceID) external view returns (bool);
13 }
14 
15 contract ERC165 is ERC165Interface {
16     /**
17      * @dev a mapping of interface id to whether or not it's supported
18      */
19     mapping(bytes4 => bool) private _supportedInterfaces;
20 
21     /**
22      * @dev implement supportsInterface(bytes4) using a lookup table
23      */
24     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
25         return _supportedInterfaces[interfaceId];
26     }
27 
28     /**
29      * @dev internal method for registering an interface
30      */
31     function _registerInterface(bytes4 interfaceId) internal {
32         require(interfaceId != 0xffffffff);
33         _supportedInterfaces[interfaceId] = true;
34     }
35 }
36 
37 // Every ERC-721 compliant contract must implement the ERC721 and ERC165 interfaces.
38 /** 
39  * @title ERC-721 Non-Fungible Token Standard
40  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
41  * Note: the ERC-165 identifier for this interface is 0x80ac58cd.
42  */
43 contract ERC721Basic is ERC165 {
44     // Below is MUST
45 
46     /**
47      * @dev This emits when ownership of any NFT changes by any mechanism.
48      *  This event emits when NFTs are created (`from` == 0) and destroyed
49      *  (`to` == 0). Exception: during contract creation, any number of NFTs
50      *  may be created and assigned without emitting Transfer. At the time of
51      *  any transfer, the approved address for that NFT (if any) is reset to none.
52      */
53     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
54 
55     /**
56      * @dev This emits when the approved address for an NFT is changed or
57      *  reaffirmed. The zero address indicates there is no approved address.
58      *  When a Transfer event emits, this also indicates that the approved
59      *  address for that NFT (if any) is reset to none.
60      */
61     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
62 
63     /**
64      * @dev This emits when an operator is enabled or disabled for an owner.
65      *  The operator can manage all NFTs of the owner.
66      */
67     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
68 
69     /**
70      * @notice Count all NFTs assigned to an owner
71      * @dev NFTs assigned to the zero address are considered invalid, and this
72      *  function throws for queries about the zero address.
73      * @param _owner An address for whom to query the balance
74      * @return The number of NFTs owned by `_owner`, possibly zero
75      */
76     function balanceOf(address _owner) public view returns (uint256);
77 
78     /**
79      * @notice Find the owner of an NFT
80      * @dev NFTs assigned to zero address are considered invalid, and queries
81      *  about them do throw.
82      * @param _tokenId The identifier for an NFT
83      * @return The address of the owner of the NFT
84      */
85     function ownerOf(uint256 _tokenId) public view returns (address);
86 
87     /**
88      * @notice Transfers the ownership of an NFT from one address to another address
89      * @dev Throws unless `msg.sender` is the current owner, an authorized
90      *  operator, or the approved address for this NFT. Throws if `_from` is
91      *  not the current owner. Throws if `_to` is the zero address. Throws if
92      *  `_tokenId` is not a valid NFT. When transfer is complete, this function
93      *  checks if `_to` is a smart contract (code size > 0). If so, it calls
94      *  `onERC721Received` on `_to` and throws if the return value is not
95      *  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
96      * @param _from The current owner of the NFT
97      * @param _to The new owner
98      * @param _tokenId The NFT to transfer
99      * @param data Additional data with no specified format, sent in call to `_to`
100      */
101     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) public;
102 
103     /**
104      * @notice Transfers the ownership of an NFT from one address to another address
105      * @dev This works identically to the other function with an extra data parameter,
106      *  except this function just sets data to "".
107      * @param _from The current owner of the NFT
108      * @param _to The new owner
109      * @param _tokenId The NFT to transfer
110      */
111     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
112 
113     /**
114      * @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
115      *  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
116      *  THEY MAY BE PERMANENTLY LOST
117      * @dev Throws unless `msg.sender` is the current owner, an authorized
118      *  operator, or the approved address for this NFT. Throws if `_from` is
119      *  not the current owner. Throws if `_to` is the zero address. Throws if
120      *  `_tokenId` is not a valid NFT.
121      * @param _from The current owner of the NFT
122      * @param _to The new owner
123      * @param _tokenId The NFT to transfer
124      */
125     function transferFrom(address _from, address _to, uint256 _tokenId) public;
126 
127     /**
128      * @notice Change or reaffirm the approved address for an NFT
129      * @dev The zero address indicates there is no approved address.
130      *  Throws unless `msg.sender` is the current NFT owner, or an authorized
131      *  operator of the current owner.
132      * @param _approved The new approved NFT controller
133      * @param _tokenId The NFT to approve
134      */
135     function approve(address _approved, uint256 _tokenId) external;
136 
137     /**
138      * @notice Enable or disable approval for a third party ("operator") to manage
139      *  all of `msg.sender`'s assets
140      * @dev Emits the ApprovalForAll event. The contract MUST allow
141      *  multiple operators per owner.
142      * @param _operator Address to add to the set of authorized operators
143      * @param _approved True if the operator is approved, false to revoke approval
144      */
145     function setApprovalForAll(address _operator, bool _approved) external;
146 
147     /**
148      * @notice Get the approved address for a single NFT
149      * @dev Throws if `_tokenId` is not a valid NFT.
150      * @param _tokenId The NFT to find the approved address for
151      * @return The approved address for this NFT, or the zero address if there is none
152      */
153     function getApproved(uint256 _tokenId) public view returns (address);
154 
155     /**
156      * @notice Query if an address is an authorized operator for another address
157      * @param _owner The address that owns the NFTs
158      * @param _operator The address that acts on behalf of the owner
159      * @return True if `_operator` is an approved operator for `_owner`, false otherwise
160      */
161     function isApprovedForAll(address _owner, address _operator) public view returns (bool);
162 
163     // Below is OPTIONAL
164 
165     // ERC721Metadata
166     // The metadata extension is OPTIONAL for ERC-721 smart contracts (see "caveats", below). This allows your smart contract to be interrogated for its name and for details about the assets which your NFTs represent.
167     
168     /**
169      * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
170      * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
171      *  Note: the ERC-165 identifier for this interface is 0x5b5e139f.
172      */
173 
174     /// @notice A descriptive name for a collection of NFTs in this contract
175     function name() external view returns (string _name);
176 
177     /// @notice An abbreviated name for NFTs in this contract
178     function symbol() external view returns (string _symbol);
179 
180     /**
181      * @notice A distinct Uniform Resource Identifier (URI) for a given asset.
182      * @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
183      *  3986. The URI may point to a JSON file that conforms to the "ERC721
184      *  Metadata JSON Schema".
185      */
186     function tokenURI(uint256 _tokenId) external view returns (string);
187 
188     // ERC721Enumerable
189     // The enumeration extension is OPTIONAL for ERC-721 smart contracts (see "caveats", below). This allows your contract to publish its full list of NFTs and make them discoverable.
190 
191     /**
192      * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
193      * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
194      *  Note: the ERC-165 identifier for this interface is 0x780e9d63.
195      */
196 
197     /**
198      * @notice Count NFTs tracked by this contract
199      * @return A count of valid NFTs tracked by this contract, where each one of
200      *  them has an assigned and queryable owner not equal to the zero address
201      */
202     function totalSupply() public view returns (uint256);
203 }
204 
205 /**
206  * @notice This is MUST to be implemented.
207  *  A wallet/broker/auction application MUST implement the wallet interface if it will accept safe transfers.
208  * @dev Note: the ERC-165 identifier for this interface is 0x150b7a02.
209  */
210 contract ERC721TokenReceiver {
211     /**
212      * @notice Handle the receipt of an NFT
213      * @dev The ERC721 smart contract calls this function on the recipient
214      *  after a `transfer`. This function MAY throw to revert and reject the
215      *  transfer. Return of other than the magic value MUST result in the
216      *  transaction being reverted.
217      *  Note: the contract address is always the message sender.
218      * @param _operator The address which called `safeTransferFrom` function
219      * @param _from The address which previously owned the token
220      * @param _tokenId The NFT identifier which is being transferred
221      * @param _data Additional data with no specified format
222      * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
223      *  unless throwing
224      */
225     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) public returns (bytes4);
226 }
227 
228 // File: /Users/chunjunghyun/Vrexlab/kydy-solidity/contracts/ERC721Standard/ERC721Holder.sol
229 
230 contract ERC721Holder is ERC721TokenReceiver {
231     function onERC721Received(address, address, uint256, bytes) public returns (bytes4) {
232         return this.onERC721Received.selector;
233     }
234 }
235 
236 /**
237  * @title SafeMath
238  * @dev Math operations with safety checks that revert on error
239  */
240 library SafeMath {
241     /**
242     * @dev Multiplies two numbers, reverts on overflow.
243     */
244     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
245         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
246         // benefit is lost if 'b' is also tested.
247         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
248         if (a == 0) {
249             return 0;
250         }
251 
252         uint256 c = a * b;
253         require(c / a == b);
254 
255         return c;
256     }
257 
258     /**
259     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
260     */
261     function div(uint256 a, uint256 b) internal pure returns (uint256) {
262         // Solidity only automatically asserts when dividing by 0
263         require(b > 0);
264         uint256 c = a / b;
265         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
266 
267         return c;
268     }
269 
270     /**
271     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
272     */
273     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
274         require(b <= a);
275         uint256 c = a - b;
276 
277         return c;
278     }
279 
280     /**
281     * @dev Adds two numbers, reverts on overflow.
282     */
283     function add(uint256 a, uint256 b) internal pure returns (uint256) {
284         uint256 c = a + b;
285         require(c >= a);
286 
287         return c;
288     }
289 
290     /**
291     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
292     * reverts when dividing by zero.
293     */
294     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
295         require(b != 0);
296         return a % b;
297     }
298 }
299 
300 /**
301  * @title Base auction contract of the Dyverse
302  * @author VREX Lab Co., Ltd
303  * @dev Contains necessary functions and variables for the auction.
304  *  Inherits `ERC721Holder` contract which is the implementation of the `ERC721TokenReceiver`.
305  *  This is to accept safe transfers.
306  */
307 contract AuctionBase is ERC721Holder {
308     using SafeMath for uint256;
309 
310     // Represents an auction on an NFT
311     struct Auction {
312         // Current owner of NFT
313         address seller;
314         // Price (in wei) of NFT
315         uint128 price;
316         // Time when the auction started
317         // NOTE: 0 if this auction has been concluded
318         uint64 startedAt;
319     }
320 
321     // Reference to contract tracking NFT ownership
322     ERC721Basic public nonFungibleContract;
323 
324     // The amount owner takes from the sale, (in basis points, which are 1/100 of a percent).
325     uint256 public ownerCut;
326 
327     // Maps token ID to it's corresponding auction.
328     mapping (uint256 => Auction) tokenIdToAuction;
329 
330     event AuctionCreated(uint256 tokenId, uint256 price);
331     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address bidder);
332     event AuctionCanceled(uint256 tokenId);
333 
334     /// @dev Disables sending funds to this contract.
335     function() external {}
336 
337     /// @dev A modifier to check if the given value can fit in 64-bits.
338     modifier canBeStoredWith64Bits(uint256 _value) {
339         require(_value <= (2**64 - 1));
340         _;
341     }
342 
343     /// @dev A modifier to check if the given value can fit in 128-bits.
344     modifier canBeStoredWith128Bits(uint256 _value) {
345         require(_value <= (2**128 - 1));
346         _;
347     }
348 
349     /**
350      * @dev Returns true if the claimant owns the token.
351      * @param _claimant An address which to query the ownership of the token.
352      * @param _tokenId ID of the token to query the owner of.
353      */
354     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
355         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
356     }
357 
358     /**
359      * @dev Escrows the NFT. Grants the ownership of the NFT to this contract safely.
360      *  Throws if the escrow fails.
361      * @param _owner Current owner of the token.
362      * @param _tokenId ID of the token to escrow.
363      */
364     function _escrow(address _owner, uint256 _tokenId) internal {
365         nonFungibleContract.safeTransferFrom(_owner, this, _tokenId);
366     }
367 
368     /**
369      * @dev Transfers an NFT owned by this contract to another address.
370      * @param _receiver The receiving address of NFT.
371      * @param _tokenId ID of the token to transfer.
372      */
373     function _transfer(address _receiver, uint256 _tokenId) internal {
374         nonFungibleContract.transferFrom(this, _receiver, _tokenId);
375     }
376 
377     /**
378      * @dev Adds an auction to the list of open auctions. 
379      * @param _tokenId ID of the token to be put on auction.
380      * @param _auction Auction information of this token to open.
381      */
382     function _addAuction(uint256 _tokenId, Auction _auction) internal {
383         tokenIdToAuction[_tokenId] = _auction;
384 
385         emit AuctionCreated(
386             uint256(_tokenId),
387             uint256(_auction.price)
388         );
389     }
390 
391     /// @dev Cancels the auction which the _seller wants.
392     function _cancelAuction(uint256 _tokenId, address _seller) internal {
393         _removeAuction(_tokenId);
394         _transfer(_seller, _tokenId);
395         emit AuctionCanceled(_tokenId);
396     }
397 
398     /**
399      * @dev Computes the price and sends it to the seller.
400      *  Note that this does NOT transfer the ownership of the token.
401      */
402     function _bid(uint256 _tokenId, uint256 _bidAmount)
403         internal
404         returns (uint256)
405     {
406         // Gets a reference of the token from auction storage.
407         Auction storage auction = tokenIdToAuction[_tokenId];
408 
409         // Checks that this auction is currently open
410         require(_isOnAuction(auction));
411 
412         // Checks that the bid is greater than or equal to the current token price.
413         uint256 price = _currentPrice(auction);
414         require(_bidAmount >= price);
415 
416         // Gets a reference of the seller before the auction gets deleted.
417         address seller = auction.seller;
418 
419         // Removes the auction before sending the proceeds to the sender
420         _removeAuction(_tokenId);
421 
422         // Transfers proceeds to the seller.
423         if (price > 0) {
424             uint256 auctioneerCut = _computeCut(price);
425             uint256 sellerProceeds = price.sub(auctioneerCut);
426 
427             seller.transfer(sellerProceeds);
428         }
429 
430         // Computes the excess funds included with the bid and transfers it back to bidder. 
431         uint256 bidExcess = _bidAmount - price;
432 
433         // Returns the exceeded funds.
434         msg.sender.transfer(bidExcess);
435 
436         // Emits the AuctionSuccessful event.
437         emit AuctionSuccessful(_tokenId, price, msg.sender);
438 
439         return price;
440     }
441 
442     /**
443      * @dev Removes an auction from the list of open auctions.
444      * @param _tokenId ID of the NFT on auction to be removed.
445      */
446     function _removeAuction(uint256 _tokenId) internal {
447         delete tokenIdToAuction[_tokenId];
448     }
449 
450     /**
451      * @dev Returns true if the NFT is on auction.
452      * @param _auction An auction to check if it exists.
453      */
454     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
455         return (_auction.startedAt > 0);
456     }
457 
458     /// @dev Returns the current price of an NFT on auction.
459     function _currentPrice(Auction storage _auction)
460         internal
461         view
462         returns (uint256)
463     {
464         return _auction.price;
465     }
466 
467     /**
468      * @dev Computes the owner's receiving amount from the sale.
469      * @param _price Sale price of the NFT.
470      */
471     function _computeCut(uint256 _price) internal view returns (uint256) {
472         return _price * ownerCut / 10000;
473     }
474 }
475 
476 contract Ownable {
477   address public owner;
478 
479 
480   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
481 
482 
483   constructor() public {
484     owner = msg.sender;
485   }
486 
487   modifier onlyOwner() {
488     require(msg.sender == owner);
489     _;
490   }
491 
492   function transferOwnership(address newOwner) public onlyOwner {
493     require(newOwner != address(0));
494     emit OwnershipTransferred(owner, newOwner);
495     owner = newOwner;
496   }
497 }
498 
499 contract Pausable is Ownable {
500   event Pause();
501   event Unpause();
502 
503   bool public paused = false;
504 
505   modifier whenNotPaused() {
506     require(!paused);
507     _;
508   }
509 
510   modifier whenPaused() {
511     require(paused);
512     _;
513   }
514 
515   function pause() onlyOwner whenNotPaused public {
516     paused = true;
517     emit Pause();
518   }
519 
520   function unpause() onlyOwner whenPaused public {
521     paused = false;
522     emit Unpause();
523   }
524 }
525 
526 /**
527  * @title Auction for NFT.
528  * @author VREX Lab Co., Ltd
529  */
530 contract Auction is Pausable, AuctionBase {
531 
532     /**
533      * @dev Removes all Ether from the contract to the NFT contract.
534      */
535     function withdrawBalance() external {
536         address nftAddress = address(nonFungibleContract);
537 
538         require(
539             msg.sender == owner ||
540             msg.sender == nftAddress
541         );
542         nftAddress.transfer(address(this).balance);
543     }
544 
545     /**
546      * @dev Creates and begins a new auction.
547      * @param _tokenId ID of the token to creat an auction, caller must be it's owner.
548      * @param _price Price of the token (in wei).
549      * @param _seller Seller of this token.
550      */
551     function createAuction(
552         uint256 _tokenId,
553         uint256 _price,
554         address _seller
555     )
556         external
557         whenNotPaused
558         canBeStoredWith128Bits(_price)
559     {
560         require(_owns(msg.sender, _tokenId));
561         _escrow(msg.sender, _tokenId);
562         Auction memory auction = Auction(
563             _seller,
564             uint128(_price),
565             uint64(now)
566         );
567         _addAuction(_tokenId, auction);
568     }
569 
570     /**
571      * @dev Bids on an open auction, completing the auction and transferring
572      *  ownership of the NFT if enough Ether is supplied.
573      * @param _tokenId - ID of token to bid on.
574      */
575     function bid(uint256 _tokenId)
576         external
577         payable
578         whenNotPaused
579     {
580         _bid(_tokenId, msg.value);
581         _transfer(msg.sender, _tokenId);
582     }
583 
584     /**
585      * @dev Cancels an auction and returns the NFT to the current owner.
586      * @param _tokenId ID of the token on auction to cancel.
587      * @param _seller The seller's address.
588      */
589     function cancelAuction(uint256 _tokenId, address _seller)
590         external
591     {
592         // Requires that this function should only be called from the
593         // `cancelSaleAuction()` of NFT ownership contract. This function gets
594         // the _seller directly from it's arguments, so if this check doesn't
595         // exist, then anyone can cancel the auction! OMG!
596         require(msg.sender == address(nonFungibleContract));
597         Auction storage auction = tokenIdToAuction[_tokenId];
598         require(_isOnAuction(auction));
599         address seller = auction.seller;
600         require(_seller == seller);
601         _cancelAuction(_tokenId, seller);
602     }
603 
604     /**
605      * @dev Allows the Auction owner can cancel any auction.
606      * @notice This function is needed to set our Gen0 Sale price at the beginning of the SaleAuction upgrade.
607      *  We are going to use this function with utmost care and only when there is no other course of action to resolve a detrimental situation. 
608      */
609     function cancelAuctionForOwner(uint256 _tokenId)
610         external
611         onlyOwner
612     {
613         Auction storage auction = tokenIdToAuction[_tokenId];
614         require(_isOnAuction(auction));
615         _cancelAuction(_tokenId, auction.seller);
616     }
617 
618     /**
619      * @dev Cancels an auction when the contract is paused.
620      * Only the owner may do this, and NFTs are returned to the seller. 
621      * @param _tokenId ID of the token on auction to cancel.
622      */
623     function cancelAuctionWhenPaused(uint256 _tokenId)
624         external
625         whenPaused
626         onlyOwner
627     {
628         Auction storage auction = tokenIdToAuction[_tokenId];
629         require(_isOnAuction(auction));
630         _cancelAuction(_tokenId, auction.seller);
631     }
632 
633     /**
634      * @dev Returns the auction information for an NFT
635      * @param _tokenId ID of the NFT on auction
636      */
637     function getAuction(uint256 _tokenId)
638         external
639         view
640         returns
641     (
642         address seller,
643         uint256 price,
644         uint256 startedAt
645     ) {
646         Auction storage auction = tokenIdToAuction[_tokenId];
647         require(_isOnAuction(auction));
648         return (
649             auction.seller,
650             auction.price,
651             auction.startedAt
652         );
653     }
654 
655     /**
656      * @dev Returns the current price of the token on auction.
657      * @param _tokenId ID of the token
658      */
659     function getCurrentPrice(uint256 _tokenId)
660         external
661         view
662         returns (uint256)
663     {
664         Auction storage auction = tokenIdToAuction[_tokenId];
665         require(_isOnAuction(auction));
666         return _currentPrice(auction);
667     }
668 }
669 
670 /**
671  * @title Auction for sale of Kydys.
672  * @author VREX Lab Co., Ltd
673  */
674 contract SaleAuction is Auction {
675 
676     /**
677      * @dev To make sure we are addressing to the right auction. 
678      */
679     bool public isSaleAuction = true;
680 
681     // Last 5 sale price of Generation 0 Kydys.
682     uint256[5] public lastGen0SalePrices;
683     
684     // Total number of Generation 0 Kydys sold.
685     uint256 public gen0SaleCount;
686 
687     /**
688      * @dev Creates a reference to the NFT ownership contract and checks the owner cut is valid
689      * @param _nftAddress Address of a deployed NFT interface contract
690      * @param _cut Percent cut which the owner takes on each auction, between 0-10,000.
691      */
692     constructor(address _nftAddress, uint256 _cut) public {
693         require(_cut <= 10000);
694         ownerCut = _cut;
695 
696         ERC721Basic candidateContract = ERC721Basic(_nftAddress);
697         nonFungibleContract = candidateContract;
698     }
699 
700     /**
701      * @dev Creates and begins a new auction.
702      * @param _tokenId ID of token to auction, sender must be it's owner.
703      * @param _price Price of the token (in wei).
704      * @param _seller Seller of this token.
705      */
706     function createAuction(
707         uint256 _tokenId,
708         uint256 _price,
709         address _seller
710     )
711         external
712         canBeStoredWith128Bits(_price)
713     {
714         require(msg.sender == address(nonFungibleContract));
715         _escrow(_seller, _tokenId);
716         Auction memory auction = Auction(
717             _seller,
718             uint128(_price),
719             uint64(now)
720         );
721         _addAuction(_tokenId, auction);
722     }
723 
724     /**
725      * @dev Updates lastSalePrice only if the seller is nonFungibleContract. 
726      */
727     function bid(uint256 _tokenId)
728         external
729         payable
730     {
731         // _bid verifies token ID
732         address seller = tokenIdToAuction[_tokenId].seller;
733         uint256 price = _bid(_tokenId, msg.value);
734         _transfer(msg.sender, _tokenId);
735 
736         // If the last sale was not Generation 0 Kydy's, the lastSalePrice doesn't change.
737         // If seller of the Gen 0 is the SaleAuction owner, then the lastGen0SalePrice is updated.
738         // This is necessary for upgrading our SaleAuction.
739         if (seller == address(nonFungibleContract) || seller == owner) {
740             // We will fill lastGen0SalePrices array with 175 finney at very first bidding of Gen0 Kydy.
741             // 175 finney is to reflect the last active sale price before the contract was paused for the upgrade. 
742             for (uint256 i = 0; i < 5; i++) {
743                 if (lastGen0SalePrices[i] == 0) {
744                     lastGen0SalePrices[i] = 175 finney;
745                 }
746             }
747             // Tracks gen0's latest sale prices.
748             lastGen0SalePrices[gen0SaleCount % 5] = price;
749             gen0SaleCount++;
750         }
751     }
752     /**
753      * @dev Gives the new average Generation 0 sale price after each Generation 0 Kydy sale. 
754      *  We added a multiplier (685/1000) to control the speed of Gen 0 price movement.
755      */
756     function averageGen0SalePrice() external view returns (uint256) {
757         uint256 sum = 0;
758         for (uint256 i = 0; i < 5; i++) {
759             sum = sum.add(lastGen0SalePrices[i]);
760         }
761         return (sum / 5) * 685 / 1000;
762     }
763 }