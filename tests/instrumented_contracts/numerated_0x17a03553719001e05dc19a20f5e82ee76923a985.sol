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
228 contract ERC721Holder is ERC721TokenReceiver {
229     function onERC721Received(address, address, uint256, bytes) public returns (bytes4) {
230         return this.onERC721Received.selector;
231     }
232 }
233 
234 /**
235  * @title SafeMath
236  * @dev Math operations with safety checks that revert on error
237  */
238 library SafeMath {
239     /**
240     * @dev Multiplies two numbers, reverts on overflow.
241     */
242     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
243         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
244         // benefit is lost if 'b' is also tested.
245         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
246         if (a == 0) {
247             return 0;
248         }
249 
250         uint256 c = a * b;
251         require(c / a == b);
252 
253         return c;
254     }
255 
256     /**
257     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
258     */
259     function div(uint256 a, uint256 b) internal pure returns (uint256) {
260         // Solidity only automatically asserts when dividing by 0
261         require(b > 0);
262         uint256 c = a / b;
263         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
264 
265         return c;
266     }
267 
268     /**
269     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
270     */
271     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
272         require(b <= a);
273         uint256 c = a - b;
274 
275         return c;
276     }
277 
278     /**
279     * @dev Adds two numbers, reverts on overflow.
280     */
281     function add(uint256 a, uint256 b) internal pure returns (uint256) {
282         uint256 c = a + b;
283         require(c >= a);
284 
285         return c;
286     }
287 
288     /**
289     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
290     * reverts when dividing by zero.
291     */
292     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
293         require(b != 0);
294         return a % b;
295     }
296 }
297 
298 /**
299  * @title Base auction contract of the Dyverse
300  * @author VREX Lab Co., Ltd
301  * @dev Contains necessary functions and variables for the auction.
302  *  Inherits `ERC721Holder` contract which is the implementation of the `ERC721TokenReceiver`.
303  *  This is to accept safe transfers.
304  */
305 contract AuctionBase is ERC721Holder {
306     using SafeMath for uint256;
307 
308     // Represents an auction on an NFT
309     struct Auction {
310         // Current owner of NFT
311         address seller;
312         // Price (in wei) of NFT
313         uint128 price;
314         // Time when the auction started
315         // NOTE: 0 if this auction has been concluded
316         uint64 startedAt;
317     }
318 
319     // Reference to contract tracking NFT ownership
320     ERC721Basic public nonFungibleContract;
321 
322     // The amount owner takes from the sale, (in basis points, which are 1/100 of a percent).
323     uint256 public ownerCut;
324 
325     // Maps token ID to it's corresponding auction.
326     mapping (uint256 => Auction) tokenIdToAuction;
327 
328     event AuctionCreated(uint256 tokenId, uint256 price);
329     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address bidder);
330     event AuctionCanceled(uint256 tokenId);
331 
332     /// @dev Disables sending funds to this contract.
333     function() external {}
334 
335     /// @dev A modifier to check if the given value can fit in 64-bits.
336     modifier canBeStoredWith64Bits(uint256 _value) {
337         require(_value <= (2**64 - 1));
338         _;
339     }
340 
341     /// @dev A modifier to check if the given value can fit in 128-bits.
342     modifier canBeStoredWith128Bits(uint256 _value) {
343         require(_value <= (2**128 - 1));
344         _;
345     }
346 
347     /**
348      * @dev Returns true if the claimant owns the token.
349      * @param _claimant An address which to query the ownership of the token.
350      * @param _tokenId ID of the token to query the owner of.
351      */
352     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
353         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
354     }
355 
356     /**
357      * @dev Escrows the NFT. Grants the ownership of the NFT to this contract safely.
358      *  Throws if the escrow fails.
359      * @param _owner Current owner of the token.
360      * @param _tokenId ID of the token to escrow.
361      */
362     function _escrow(address _owner, uint256 _tokenId) internal {
363         nonFungibleContract.safeTransferFrom(_owner, this, _tokenId);
364     }
365 
366     /**
367      * @dev Transfers an NFT owned by this contract to another address safely.
368      * @param _receiver The receiving address of NFT.
369      * @param _tokenId ID of the token to transfer.
370      */
371     function _transfer(address _receiver, uint256 _tokenId) internal {
372         nonFungibleContract.safeTransferFrom(this, _receiver, _tokenId);
373     }
374 
375     /**
376      * @dev Adds an auction to the list of open auctions. 
377      * @param _tokenId ID of the token to be put on auction.
378      * @param _auction Auction information of this token to open.
379      */
380     function _addAuction(uint256 _tokenId, Auction _auction) internal {
381         tokenIdToAuction[_tokenId] = _auction;
382 
383         emit AuctionCreated(
384             uint256(_tokenId),
385             uint256(_auction.price)
386         );
387     }
388 
389     /// @dev Cancels the auction which the _seller wants.
390     function _cancelAuction(uint256 _tokenId, address _seller) internal {
391         _removeAuction(_tokenId);
392         _transfer(_seller, _tokenId);
393         emit AuctionCanceled(_tokenId);
394     }
395 
396     /**
397      * @dev Computes the price and sends it to the seller.
398      *  Note that this does NOT transfer the ownership of the token.
399      */
400     function _bid(uint256 _tokenId, uint256 _bidAmount)
401         internal
402         returns (uint256)
403     {
404         // Gets a reference of the token from auction storage.
405         Auction storage auction = tokenIdToAuction[_tokenId];
406 
407         // Checks that this auction is currently open
408         require(_isOnAuction(auction));
409 
410         // Checks that the bid is greater than or equal to the current token price.
411         uint256 price = _currentPrice(auction);
412         require(_bidAmount >= price);
413 
414         // Gets a reference of the seller before the auction gets deleted.
415         address seller = auction.seller;
416 
417         // Removes the auction before sending the proceeds to the sender
418         _removeAuction(_tokenId);
419 
420         // Transfers proceeds to the seller.
421         if (price > 0) {
422             uint256 auctioneerCut = _computeCut(price);
423             uint256 sellerProceeds = price.sub(auctioneerCut);
424 
425             seller.transfer(sellerProceeds);
426         }
427 
428         // Computes the excess funds included with the bid and transfers it back to bidder. 
429         uint256 bidExcess = _bidAmount - price;
430 
431         // Returns the exceeded funds.
432         msg.sender.transfer(bidExcess);
433 
434         // Emits the AuctionSuccessful event.
435         emit AuctionSuccessful(_tokenId, price, msg.sender);
436 
437         return price;
438     }
439 
440     /**
441      * @dev Removes an auction from the list of open auctions.
442      * @param _tokenId ID of the NFT on auction to be removed.
443      */
444     function _removeAuction(uint256 _tokenId) internal {
445         delete tokenIdToAuction[_tokenId];
446     }
447 
448     /**
449      * @dev Returns true if the NFT is on auction.
450      * @param _auction An auction to check if it exists.
451      */
452     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
453         return (_auction.startedAt > 0);
454     }
455 
456     /// @dev Returns the current price of an NFT on auction.
457     function _currentPrice(Auction storage _auction)
458         internal
459         view
460         returns (uint256)
461     {
462         return _auction.price;
463     }
464 
465     /**
466      * @dev Computes the owner's receiving amount from the sale.
467      * @param _price Sale price of the NFT.
468      */
469     function _computeCut(uint256 _price) internal view returns (uint256) {
470         return _price * ownerCut / 10000;
471     }
472 }
473 
474 contract Ownable {
475   address public owner;
476 
477 
478   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
479 
480 
481   constructor() public {
482     owner = msg.sender;
483   }
484 
485   modifier onlyOwner() {
486     require(msg.sender == owner);
487     _;
488   }
489 
490   function transferOwnership(address newOwner) public onlyOwner {
491     require(newOwner != address(0));
492     emit OwnershipTransferred(owner, newOwner);
493     owner = newOwner;
494   }
495 }
496 
497 contract Pausable is Ownable {
498   event Pause();
499   event Unpause();
500 
501   bool public paused = false;
502 
503   modifier whenNotPaused() {
504     require(!paused);
505     _;
506   }
507 
508   modifier whenPaused() {
509     require(paused);
510     _;
511   }
512 
513   function pause() onlyOwner whenNotPaused public {
514     paused = true;
515     emit Pause();
516   }
517 
518   function unpause() onlyOwner whenPaused public {
519     paused = false;
520     emit Unpause();
521   }
522 }
523 
524 /**
525  * @title Auction for NFT.
526  * @author VREX Lab Co., Ltd
527  */
528 contract Auction is Pausable, AuctionBase {
529 
530     /**
531      * @dev Removes all Ether from the contract to the NFT contract.
532      */
533     function withdrawBalance() external {
534         address nftAddress = address(nonFungibleContract);
535 
536         require(
537             msg.sender == owner ||
538             msg.sender == nftAddress
539         );
540         nftAddress.transfer(address(this).balance);
541     }
542 
543     /**
544      * @dev Creates and begins a new auction.
545      * @param _tokenId ID of the token to creat an auction, caller must be it's owner.
546      * @param _price Price of the token (in wei).
547      * @param _seller Seller of this token.
548      */
549     function createAuction(
550         uint256 _tokenId,
551         uint256 _price,
552         address _seller
553     )
554         external
555         whenNotPaused
556         canBeStoredWith128Bits(_price)
557     {
558         require(_owns(msg.sender, _tokenId));
559         _escrow(msg.sender, _tokenId);
560         Auction memory auction = Auction(
561             _seller,
562             uint128(_price),
563             uint64(now)
564         );
565         _addAuction(_tokenId, auction);
566     }
567 
568     /**
569      * @dev Bids on an open auction, completing the auction and transferring
570      *  ownership of the NFT if enough Ether is supplied.
571      * @param _tokenId - ID of token to bid on.
572      */
573     function bid(uint256 _tokenId)
574         external
575         payable
576         whenNotPaused
577     {
578         _bid(_tokenId, msg.value);
579         _transfer(msg.sender, _tokenId);
580     }
581 
582     /**
583      * @dev Cancels an auction and returns the NFT to the current owner.
584      * @param _tokenId ID of the token on auction to cancel.
585      * @param _seller The seller's address.
586      */
587     function cancelAuction(uint256 _tokenId, address _seller)
588         external
589     {
590         // Requires that this function should only be called from the
591         // `cancelSaleAuction()` of NFT ownership contract. This function gets
592         // the _seller directly from it's arguments, so if this check doesn't
593         // exist, then anyone can cancel the auction! OMG!
594         require(msg.sender == address(nonFungibleContract));
595         Auction storage auction = tokenIdToAuction[_tokenId];
596         require(_isOnAuction(auction));
597         address seller = auction.seller;
598         require(_seller == seller);
599         _cancelAuction(_tokenId, seller);
600     }
601 
602     /**
603      * @dev Cancels an auction when the contract is paused.
604      * Only the owner may do this, and NFTs are returned to the seller. 
605      * @param _tokenId ID of the token on auction to cancel.
606      */
607     function cancelAuctionWhenPaused(uint256 _tokenId)
608         external
609         whenPaused
610         onlyOwner
611     {
612         Auction storage auction = tokenIdToAuction[_tokenId];
613         require(_isOnAuction(auction));
614         _cancelAuction(_tokenId, auction.seller);
615     }
616 
617     /**
618      * @dev Returns the auction information for an NFT
619      * @param _tokenId ID of the NFT on auction
620      */
621     function getAuction(uint256 _tokenId)
622         external
623         view
624         returns
625     (
626         address seller,
627         uint256 price,
628         uint256 startedAt
629     ) {
630         Auction storage auction = tokenIdToAuction[_tokenId];
631         require(_isOnAuction(auction));
632         return (
633             auction.seller,
634             auction.price,
635             auction.startedAt
636         );
637     }
638 
639     /**
640      * @dev Returns the current price of the token on auction.
641      * @param _tokenId ID of the token
642      */
643     function getCurrentPrice(uint256 _tokenId)
644         external
645         view
646         returns (uint256)
647     {
648         Auction storage auction = tokenIdToAuction[_tokenId];
649         require(_isOnAuction(auction));
650         return _currentPrice(auction);
651     }
652 }
653 
654 /**
655  * @title Auction for sale of Kydys.
656  * @author VREX Lab Co., Ltd
657  */
658 contract SaleAuction is Auction {
659 
660     /**
661      * @dev To make sure we are addressing to the right auction. 
662      */
663     bool public isSaleAuction = true;
664 
665     // Last 5 sale price of Generation 0 Kydys.
666     uint256[5] public lastGen0SalePrices;
667     
668     // Total number of Generation 0 Kydys sold.
669     uint256 public gen0SaleCount;
670 
671     /**
672      * @dev Creates a reference to the NFT ownership contract and checks the owner cut is valid
673      * @param _nftAddress Address of a deployed NFT interface contract
674      * @param _cut Percent cut which the owner takes on each auction, between 0-10,000.
675      */
676     constructor(address _nftAddress, uint256 _cut) public {
677         require(_cut <= 10000);
678         ownerCut = _cut;
679 
680         ERC721Basic candidateContract = ERC721Basic(_nftAddress);
681         nonFungibleContract = candidateContract;
682     }
683 
684     /**
685      * @dev Creates and begins a new auction.
686      * @param _tokenId ID of token to auction, sender must be it's owner.
687      * @param _price Price of the token (in wei).
688      * @param _seller Seller of this token.
689      */
690     function createAuction(
691         uint256 _tokenId,
692         uint256 _price,
693         address _seller
694     )
695         external
696         canBeStoredWith128Bits(_price)
697     {
698         require(msg.sender == address(nonFungibleContract));
699         _escrow(_seller, _tokenId);
700         Auction memory auction = Auction(
701             _seller,
702             uint128(_price),
703             uint64(now)
704         );
705         _addAuction(_tokenId, auction);
706     }
707 
708     /**
709      * @dev Updates lastSalePrice only if the seller is nonFungibleContract. 
710      */
711     function bid(uint256 _tokenId)
712         external
713         payable
714     {
715         // _bid verifies token ID
716         address seller = tokenIdToAuction[_tokenId].seller;
717         uint256 price = _bid(_tokenId, msg.value);
718         _transfer(msg.sender, _tokenId);
719 
720         // If the last sale was not Generation 0 Kydy's, the lastSalePrice doesn't change.
721         if (seller == address(nonFungibleContract)) {
722             // Tracks gen0's latest sale prices.
723             lastGen0SalePrices[gen0SaleCount % 5] = price;
724             gen0SaleCount++;
725         }
726     }
727 
728     /// @dev Gives the new average Generation 0 sale price after each Generation 0 Kydy sale.
729     function averageGen0SalePrice() external view returns (uint256) {
730         uint256 sum = 0;
731         for (uint256 i = 0; i < 5; i++) {
732             sum = sum.add(lastGen0SalePrices[i]);
733         }
734         return sum / 5;
735     }
736 }