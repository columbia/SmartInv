1 // File: @0xcert/ethereum-erc721/contracts/tokens/ERC721.sol
2 
3 pragma solidity ^0.4.24;
4 
5 /**
6  * @dev ERC-721 non-fungible token standard. See https://goo.gl/pc9yoS.
7  */
8 interface ERC721 {
9 
10   /**
11    * @dev Emits when ownership of any NFT changes by any mechanism. This event emits when NFTs are
12    * created (`from` == 0) and destroyed (`to` == 0). Exception: during contract creation, any
13    * number of NFTs may be created and assigned without emitting Transfer. At the time of any
14    * transfer, the approved address for that NFT (if any) is reset to none.
15    */
16   event Transfer(
17     address indexed _from,
18     address indexed _to,
19     uint256 indexed _tokenId
20   );
21 
22   /**
23    * @dev This emits when the approved address for an NFT is changed or reaffirmed. The zero
24    * address indicates there is no approved address. When a Transfer event emits, this also
25    * indicates that the approved address for that NFT (if any) is reset to none.
26    */
27   event Approval(
28     address indexed _owner,
29     address indexed _approved,
30     uint256 indexed _tokenId
31   );
32 
33   /**
34    * @dev This emits when an operator is enabled or disabled for an owner. The operator can manage
35    * all NFTs of the owner.
36    */
37   event ApprovalForAll(
38     address indexed _owner,
39     address indexed _operator,
40     bool _approved
41   );
42 
43   /**
44    * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
45    * considered invalid, and this function throws for queries about the zero address.
46    * @param _owner Address for whom to query the balance.
47    */
48   function balanceOf(
49     address _owner
50   )
51     external
52     view
53     returns (uint256);
54 
55   /**
56    * @dev Returns the address of the owner of the NFT. NFTs assigned to zero address are considered
57    * invalid, and queries about them do throw.
58    * @param _tokenId The identifier for an NFT.
59    */
60   function ownerOf(
61     uint256 _tokenId
62   )
63     external
64     view
65     returns (address);
66 
67   /**
68    * @dev Transfers the ownership of an NFT from one address to another address.
69    * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
70    * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
71    * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
72    * function checks if `_to` is a smart contract (code size > 0). If so, it calls `onERC721Received`
73    * on `_to` and throws if the return value is not `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
74    * @param _from The current owner of the NFT.
75    * @param _to The new owner.
76    * @param _tokenId The NFT to transfer.
77    * @param _data Additional data with no specified format, sent in call to `_to`.
78    */
79   function safeTransferFrom(
80     address _from,
81     address _to,
82     uint256 _tokenId,
83     bytes _data
84   )
85     external;
86 
87   /**
88    * @dev Transfers the ownership of an NFT from one address to another address.
89    * @notice This works identically to the other function with an extra data parameter, except this
90    * function just sets data to ""
91    * @param _from The current owner of the NFT.
92    * @param _to The new owner.
93    * @param _tokenId The NFT to transfer.
94    */
95   function safeTransferFrom(
96     address _from,
97     address _to,
98     uint256 _tokenId
99   )
100     external;
101 
102   /**
103    * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
104    * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
105    * address. Throws if `_tokenId` is not a valid NFT.
106    * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
107    * they mayb be permanently lost.
108    * @param _from The current owner of the NFT.
109    * @param _to The new owner.
110    * @param _tokenId The NFT to transfer.
111    */
112   function transferFrom(
113     address _from,
114     address _to,
115     uint256 _tokenId
116   )
117     external;
118 
119   /**
120    * @dev Set or reaffirm the approved address for an NFT.
121    * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
122    * the current NFT owner, or an authorized operator of the current owner.
123    * @param _approved The new approved NFT controller.
124    * @param _tokenId The NFT to approve.
125    */
126   function approve(
127     address _approved,
128     uint256 _tokenId
129   )
130     external;
131 
132   /**
133    * @dev Enables or disables approval for a third party ("operator") to manage all of
134    * `msg.sender`'s assets. It also emits the ApprovalForAll event.
135    * @notice The contract MUST allow multiple operators per owner.
136    * @param _operator Address to add to the set of authorized operators.
137    * @param _approved True if the operators is approved, false to revoke approval.
138    */
139   function setApprovalForAll(
140     address _operator,
141     bool _approved
142   )
143     external;
144 
145   /**
146    * @dev Get the approved address for a single NFT.
147    * @notice Throws if `_tokenId` is not a valid NFT.
148    * @param _tokenId The NFT to find the approved address for.
149    */
150   function getApproved(
151     uint256 _tokenId
152   )
153     external
154     view
155     returns (address);
156 
157   /**
158    * @dev Returns true if `_operator` is an approved operator for `_owner`, false otherwise.
159    * @param _owner The address that owns the NFTs.
160    * @param _operator The address that acts on behalf of the owner.
161    */
162   function isApprovedForAll(
163     address _owner,
164     address _operator
165   )
166     external
167     view
168     returns (bool);
169 
170 }
171 
172 // File: @0xcert/ethereum-utils/contracts/utils/ERC165.sol
173 
174 pragma solidity ^0.4.24;
175 
176 /**
177  * @dev A standard for detecting smart contract interfaces. See https://goo.gl/cxQCse.
178  */
179 interface ERC165 {
180 
181   /**
182    * @dev Checks if the smart contract includes a specific interface.
183    * @notice This function uses less than 30,000 gas.
184    * @param _interfaceID The interface identifier, as specified in ERC-165.
185    */
186   function supportsInterface(
187     bytes4 _interfaceID
188   )
189     external
190     view
191     returns (bool);
192 
193 }
194 
195 // File: @0xcert/ethereum-utils/contracts/math/SafeMath.sol
196 
197 pragma solidity ^0.4.24;
198 
199 /**
200  * @dev Math operations with safety checks that throw on error. This contract is based
201  * on the source code at https://goo.gl/iyQsmU.
202  */
203 library SafeMath {
204 
205   /**
206    * @dev Multiplies two numbers, throws on overflow.
207    * @param _a Factor number.
208    * @param _b Factor number.
209    */
210   function mul(
211     uint256 _a,
212     uint256 _b
213   )
214     internal
215     pure
216     returns (uint256)
217   {
218     if (_a == 0) {
219       return 0;
220     }
221     uint256 c = _a * _b;
222     assert(c / _a == _b);
223     return c;
224   }
225 
226   /**
227    * @dev Integer division of two numbers, truncating the quotient.
228    * @param _a Dividend number.
229    * @param _b Divisor number.
230    */
231   function div(
232     uint256 _a,
233     uint256 _b
234   )
235     internal
236     pure
237     returns (uint256)
238   {
239     uint256 c = _a / _b;
240     // assert(b > 0); // Solidity automatically throws when dividing by 0
241     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
242     return c;
243   }
244 
245   /**
246    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
247    * @param _a Minuend number.
248    * @param _b Subtrahend number.
249    */
250   function sub(
251     uint256 _a,
252     uint256 _b
253   )
254     internal
255     pure
256     returns (uint256)
257   {
258     assert(_b <= _a);
259     return _a - _b;
260   }
261 
262   /**
263    * @dev Adds two numbers, throws on overflow.
264    * @param _a Number.
265    * @param _b Number.
266    */
267   function add(
268     uint256 _a,
269     uint256 _b
270   )
271     internal
272     pure
273     returns (uint256)
274   {
275     uint256 c = _a + _b;
276     assert(c >= _a);
277     return c;
278   }
279 
280 }
281 
282 // File: @0xcert/ethereum-utils/contracts/utils/SupportsInterface.sol
283 
284 pragma solidity ^0.4.24;
285 
286 
287 /**
288  * @dev Implementation of standard for detect smart contract interfaces.
289  */
290 contract SupportsInterface is
291   ERC165
292 {
293 
294   /**
295    * @dev Mapping of supported intefraces.
296    * @notice You must not set element 0xffffffff to true.
297    */
298   mapping(bytes4 => bool) internal supportedInterfaces;
299 
300   /**
301    * @dev Contract constructor.
302    */
303   constructor()
304     public
305   {
306     supportedInterfaces[0x01ffc9a7] = true; // ERC165
307   }
308 
309   /**
310    * @dev Function to check which interfaces are suported by this contract.
311    * @param _interfaceID Id of the interface.
312    */
313   function supportsInterface(
314     bytes4 _interfaceID
315   )
316     external
317     view
318     returns (bool)
319   {
320     return supportedInterfaces[_interfaceID];
321   }
322 
323 }
324 
325 // File: @0xcert/ethereum-utils/contracts/utils/AddressUtils.sol
326 
327 pragma solidity ^0.4.24;
328 
329 /**
330  * @dev Utility library of inline functions on addresses.
331  */
332 library AddressUtils {
333 
334   /**
335    * @dev Returns whether the target address is a contract.
336    * @param _addr Address to check.
337    */
338   function isContract(
339     address _addr
340   )
341     internal
342     view
343     returns (bool)
344   {
345     uint256 size;
346 
347     /**
348      * XXX Currently there is no better way to check if there is a contract in an address than to
349      * check the size of the code at that address.
350      * See https://ethereum.stackexchange.com/a/14016/36603 for more details about how this works.
351      * TODO: Check this again before the Serenity release, because all addresses will be
352      * contracts then.
353      */
354     assembly { size := extcodesize(_addr) } // solium-disable-line security/no-inline-assembly
355     return size > 0;
356   }
357 
358 }
359 
360 // File: contracts/DutchAuctionBase.sol
361 
362 pragma solidity ^0.4.24;
363 
364 
365 
366 
367 
368 /**
369  * @title Dutch Auction Base
370  * @dev Contains model defining Auction, public variables as reference to nftContract. It is expected that auctioneer is owner of the contract. Dutch auction by wiki - https://en.wikipedia.org/wiki/Dutch_auction. Contract is inspired by https://github.com/nedodn/NFT-Auction and https://github.com/dapperlabs/cryptokitties-bounty/tree/master/contracts/Auction/
371  * @notice Contract omits a fallback function to prevent accidental eth transfers.
372  */
373 contract DutchAuctionBase is
374   SupportsInterface
375 {
376 
377   using SafeMath for uint128;
378   using SafeMath for uint256;
379   using AddressUtils for address;
380 
381   // Model of NFt auction
382   struct Auction {
383       // Address of person who placed NFT to auction
384       address seller;
385 
386       // Price (in wei) at beginning of auction
387       uint128 startingPrice;
388 
389       // Price (in wei) at end of auction
390       uint128 endingPrice;
391 
392       // Duration (in seconds) of auction when price is moving, lets say, it determines dynamic part of auction price creation.
393       uint64 duration;
394 
395       // Time when auction started, yep 256, we consider ours NFTs almost immortal!!! :)
396       uint256 startedAt;
397 
398       // Determine if seller can cancel auction before dynamic part of auction ends!  Let have some hard core sellers!!!
399       bool delayedCancel;
400 
401   }
402 
403   // Owner of the contract is considered as Auctioneer, so it supposed to have some share from successful sale.
404   // Value in between 0-10000 (1% is equal to 100)
405   uint16 public auctioneerCut;
406 
407   // Cut representing auctioneers earnings from auction with delayed cancel
408   // Value in between 0-10000 (1% is equal to 100)
409   uint16 public auctioneerDelayedCancelCut;
410 
411   // Reference to contract tracking NFT ownership
412   ERC721 public nftContract;
413 
414   // Maps Token ID with Auction
415   mapping (uint256 => Auction) public tokenIdToAuction;
416 
417   event AuctionCreated(uint256 tokenId, address seller, uint256 startingPrice, uint256 endingPrice, uint256 duration, bool delayedCancel);
418   event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
419   event AuctionCancelled(uint256 tokenId);
420 
421   /**
422    * @dev Adds new auction and fires AuctionCreated event.
423    * @param _tokenId NFT ID
424    * @param _auction Auction to add.
425    */
426   function _addAuction(uint256 _tokenId, Auction _auction) internal {
427     // Dynamic part of acution hast to be at least 1 minute
428     require(_auction.duration >= 1 minutes);
429 
430     tokenIdToAuction[_tokenId] = _auction;
431 
432     emit AuctionCreated(
433         _tokenId,
434         _auction.seller,
435         uint256(_auction.startingPrice),
436         uint256(_auction.endingPrice),
437         uint256(_auction.duration),
438         _auction.delayedCancel
439     );
440   }
441 
442   /**
443    * @dev Cancels auction and transfer token to provided address
444    * @param _tokenId ID of NFT
445    */
446   function _cancelAuction(uint256 _tokenId) internal {
447     Auction storage auction = tokenIdToAuction[_tokenId];
448     address _seller = auction.seller;
449     _removeAuction(_tokenId);
450 
451     // return Token to seller
452     nftContract.transferFrom(address(this), _seller, _tokenId);
453     emit AuctionCancelled(_tokenId);
454   }
455 
456   /**
457    * @dev Handles bid placemant. If bid is valid then calculates auctioneers cut and sellers revenue.
458    * @param _tokenId ID of NFT
459    * @param _offer value in wei representing what buyer is willing to pay for NFT
460    */
461   function _bid(uint256 _tokenId, uint256 _offer)
462       internal
463   {
464       // Get a reference to the auction struct
465       Auction storage auction = tokenIdToAuction[_tokenId];
466       require(_isOnAuction(auction), "Can not place bid. NFT is not on auction!");
467 
468       // Check that the bid is greater than or equal to the current price
469       uint256 price = _currentPrice(auction);
470       require(_offer >= price, "Bid amount has to be higher or equal than current price!");
471 
472       // Put seller address before auction is deleted.
473       address seller = auction.seller;
474 
475       // Keep auction type even after auction is deleted.
476       bool isCancelDelayed = auction.delayedCancel;
477 
478       // Remove the auction before sending the fees to the sender so we can't have a reentrancy attack.
479       _removeAuction(_tokenId);
480 
481       // Transfer revenue to seller
482       if (price > 0) {
483           // Calculate the auctioneer's cut.
484           uint256 computedCut = _computeCut(price, isCancelDelayed);
485           uint256 sellerRevenue = price.sub(computedCut);
486 
487           /**
488            * NOTE: !! Doing a transfer() in the middle of a complex method is dangerous!!!
489            * because of reentrancy attacks and DoS attacks if the seller is a contract with an invalid fallback function. We explicitly
490            * guard against reentrancy attacks by removing the auction before calling transfer(),
491            * and the only thing the seller can DoS is the sale of their own asset! (And if it's an accident, they can call cancelAuction(). )
492            */
493           seller.transfer(sellerRevenue);
494       }
495 
496       // Calculate any excess funds included with the bid. Excess should be transfered back to bidder.
497       uint256 bidExcess = _offer.sub(price);
498 
499       // Return additional funds. This is not susceptible to a re-entry attack because the auction is removed before any transfers occur.
500       msg.sender.transfer(bidExcess);
501 
502       emit AuctionSuccessful(_tokenId, price, msg.sender);
503   }
504 
505   /**
506    * @dev Returns true if the NFT is on auction.
507    * @param _auction - Auction to check.
508    */
509   function _isOnAuction(Auction storage _auction)
510     internal
511     view
512     returns (bool)
513   {
514       return (_auction.seller != address(0));
515   }
516 
517   /**
518    * @dev Returns true if auction price is dynamic
519    * @param _auction Auction to check.
520    */
521   function _durationIsOver(Auction storage _auction)
522     internal
523     view
524     returns (bool)
525   {
526       uint256 secondsPassed = 0;
527       secondsPassed = now.sub(_auction.startedAt);
528 
529       // TODO - what about 30 seconds of tolerated difference of miners clocks??
530       return (secondsPassed >= _auction.duration);
531   }
532 
533   /**
534    * @dev Returns current price of auction.
535    * @param _auction Auction to check current price
536    */
537   function _currentPrice(Auction storage _auction)
538     internal
539     view
540     returns (uint256)
541   {
542     uint256 secondsPassed = 0;
543 
544     if (now > _auction.startedAt) {
545         secondsPassed = now.sub(_auction.startedAt);
546     }
547 
548     if (secondsPassed >= _auction.duration) {
549         // End of dynamic part of auction.
550         return _auction.endingPrice;
551     } else {
552         // Note - working with int256 not with uint256!! Delta can be negative.
553         int256 totalPriceChange = int256(_auction.endingPrice) - int256(_auction.startingPrice);
554         int256 currentPriceChange = totalPriceChange * int256(secondsPassed) / int256(_auction.duration);
555         int256 currentPrice = int256(_auction.startingPrice) + currentPriceChange;
556 
557         return uint256(currentPrice);
558     }
559   }
560 
561   /**
562    * @dev Computes auctioneer's cut of a sale.
563    * @param _price - Sale price of NFT.
564    * @param _isCancelDelayed - Determines what kind of cut is used for calculation
565    */
566   function _computeCut(uint256 _price, bool _isCancelDelayed)
567     internal
568     view
569     returns (uint256)
570   {
571 
572       if (_isCancelDelayed) {
573         return _price * auctioneerDelayedCancelCut / 10000;
574       }
575 
576       return _price * auctioneerCut / 10000;
577   }
578 
579   /*
580    * @dev Removes auction from auction list
581    * @param _tokenId NFT on auction
582    */
583    function _removeAuction(uint256 _tokenId)
584      internal
585    {
586      delete tokenIdToAuction[_tokenId];
587    }
588 }
589 
590 // File: contracts/DutchAuctionEnumerable.sol
591 
592 pragma solidity ^0.4.24;
593 
594 
595 /**
596  * @title Extension of Auction Base (core). Allows to enumarate auctions.
597  * @dev It's highly inspired by https://github.com/0xcert/ethereum-erc721/blob/master/contracts/tokens/NFTokenEnumerable.sol
598  */
599 contract DutchAuctionEnumerable
600   is DutchAuctionBase
601 {
602 
603   // array of tokens in auction
604   uint256[] public tokens;
605 
606   /**
607    * @dev Mapping from token ID its index in global tokens array.
608    */
609   mapping(uint256 => uint256) public tokenToIndex;
610 
611   /**
612    * @dev Mapping from owner to list of owned NFT IDs in this auction.
613    */
614   mapping(address => uint256[]) public sellerToTokens;
615 
616   /**
617    * @dev Mapping from NFT ID to its index in the seller tokens list.
618    */
619   mapping(uint256 => uint256) public tokenToSellerIndex;
620 
621   /**
622    * @dev Adds an auction to the list of open auctions. Also fires the
623    *  AuctionCreated event.
624    * @param _token The ID of the token to be put on auction.
625    * @param _auction Auction to add.
626    */
627   function _addAuction(uint256 _token, Auction _auction)
628     internal
629   {
630     super._addAuction(_token, _auction);
631 
632     uint256 length = tokens.push(_token);
633     tokenToIndex[_token] = length - 1;
634 
635     length = sellerToTokens[_auction.seller].push(_token);
636     tokenToSellerIndex[_token] = length - 1;
637   }
638 
639   /*
640    * @dev Removes an auction from the list of open auctions.
641    * @param _token - ID of NFT on auction.
642    */
643   function _removeAuction(uint256 _token)
644     internal
645   {
646     assert(tokens.length > 0);
647 
648     Auction memory auction = tokenIdToAuction[_token];
649     // auction has to be defined
650     assert(auction.seller != address(0));
651     assert(sellerToTokens[auction.seller].length > 0);
652 
653     uint256 sellersIndexOfTokenToRemove = tokenToSellerIndex[_token];
654 
655     uint256 lastSellersTokenIndex = sellerToTokens[auction.seller].length - 1;
656     uint256 lastSellerToken = sellerToTokens[auction.seller][lastSellersTokenIndex];
657 
658     sellerToTokens[auction.seller][sellersIndexOfTokenToRemove] = lastSellerToken;
659     sellerToTokens[auction.seller].length--;
660 
661     tokenToSellerIndex[lastSellerToken] = sellersIndexOfTokenToRemove;
662     tokenToSellerIndex[_token] = 0;
663 
664     uint256 tokenIndex = tokenToIndex[_token];
665     assert(tokens[tokenIndex] == _token);
666 
667     // Sanity check. This could be removed in the future.
668     uint256 lastTokenIndex = tokens.length - 1;
669     uint256 lastToken = tokens[lastTokenIndex];
670 
671     tokens[tokenIndex] = lastToken;
672     tokens.length--;
673 
674     // nullify token index reference
675     tokenToIndex[lastToken] = tokenIndex;
676     tokenToIndex[_token] = 0;
677 
678     super._removeAuction(_token);
679   }
680 
681 
682   /**
683    * @dev Returns the count of all existing auctions.
684    */
685   function totalAuctions()
686     external
687     view
688     returns (uint256)
689   {
690     return tokens.length;
691   }
692 
693   /**
694    * @dev Returns NFT ID by its index.
695    * @param _index A counter less than `totalSupply()`.
696    */
697   function tokenInAuctionByIndex(
698     uint256 _index
699   )
700     external
701     view
702     returns (uint256)
703   {
704     require(_index < tokens.length);
705     // Sanity check. This could be removed in the future.
706     assert(tokenToIndex[tokens[_index]] == _index);
707     return tokens[_index];
708   }
709 
710   /**
711    * @dev returns the n-th NFT ID from a list of owner's tokens.
712    * @param _seller Token owner's address.
713    * @param _index Index number representing n-th token in owner's list of tokens.
714    */
715   function tokenOfSellerByIndex(
716     address _seller,
717     uint256 _index
718   )
719     external
720     view
721     returns (uint256)
722   {
723     require(_index < sellerToTokens[_seller].length);
724     return sellerToTokens[_seller][_index];
725   }
726 
727   /**
728    * @dev Returns the count of all existing auctions.
729    */
730   function totalAuctionsBySeller(
731     address _seller
732   )
733     external
734     view
735     returns (uint256)
736   {
737     return sellerToTokens[_seller].length;
738   }
739 }
740 
741 // File: contracts/MarbleNFTInterface.sol
742 
743 pragma solidity ^0.4.24;
744 
745 /**
746  * @title Marble NFT Interface
747  * @dev Defines Marbles unique extension of NFT.
748  * ...It contains methodes returning core properties what describe Marble NFTs and provides management options to create,
749  * burn NFT or change approvals of it.
750  */
751 interface MarbleNFTInterface {
752 
753   /**
754    * @dev Mints Marble NFT.
755    * @notice This is a external function which should be called just by the owner of contract or any other user who has priviladge of being resposible
756    * of creating valid Marble NFT. Valid token contains all neccessary information to be able recreate marble card image.
757    * @param _tokenId The ID of new NFT.
758    * @param _owner Address of the NFT owner.
759    * @param _uri Unique URI proccessed by Marble services to be sure it is valid NFTs DNA. Most likely it is URL pointing to some website address.
760    * @param _metadataUri URI pointing to "ERC721 Metadata JSON Schema"
761    * @param _tokenId ID of the NFT to be burned.
762    */
763   function mint(
764     uint256 _tokenId,
765     address _owner,
766     address _creator,
767     string _uri,
768     string _metadataUri,
769     uint256 _created
770   )
771     external;
772 
773   /**
774    * @dev Burns Marble NFT. Should be fired only by address with proper authority as contract owner or etc.
775    * @param _tokenId ID of the NFT to be burned.
776    */
777   function burn(
778     uint256 _tokenId
779   )
780     external;
781 
782   /**
783    * @dev Allowes to change approval for change of ownership even when sender is not NFT holder. Sender has to have special role granted by contract to use this tool.
784    * @notice Careful with this!!!! :))
785    * @param _tokenId ID of the NFT to be updated.
786    * @param _approved ETH address what supposed to gain approval to take ownership of NFT.
787    */
788   function forceApproval(
789     uint256 _tokenId,
790     address _approved
791   )
792     external;
793 
794   /**
795    * @dev Returns properties used for generating NFT metadata image (a.k.a. card).
796    * @param _tokenId ID of the NFT.
797    */
798   function tokenSource(uint256 _tokenId)
799     external
800     view
801     returns (
802       string uri,
803       address creator,
804       uint256 created
805     );
806 
807   /**
808    * @dev Returns ID of NFT what matches provided source URI.
809    * @param _uri URI of source website.
810    */
811   function tokenBySourceUri(string _uri)
812     external
813     view
814     returns (uint256 tokenId);
815 
816   /**
817    * @dev Returns all properties of Marble NFT. Lets call it Marble NFT Model with properties described below:
818    * @param _tokenId ID  of NFT
819    * Returned model:
820    * uint256 id ID of NFT
821    * string uri  URI of source website. Website is used to mine data to crate NFT metadata image.
822    * string metadataUri URI to NFT metadata assets. In our case to our websevice providing JSON with additional information based on "ERC721 Metadata JSON Schema".
823    * address owner NFT owner address.
824    * address creator Address of creator of this NFT. It means that this addres placed sourceURI to candidate contract.
825    * uint256 created Date and time of creation of NFT candidate.
826    *
827    * (id, uri, metadataUri, owner, creator, created)
828    */
829   function getNFT(uint256 _tokenId)
830     external
831     view
832     returns(
833       uint256 id,
834       string uri,
835       string metadataUri,
836       address owner,
837       address creator,
838       uint256 created
839     );
840 
841 
842     /**
843      * @dev Transforms URI to hash.
844      * @param _uri URI to be transformed to hash.
845      */
846     function getSourceUriHash(string _uri)
847       external
848       view
849       returns(uint256 hash);
850 }
851 
852 // File: @0xcert/ethereum-utils/contracts/ownership/Ownable.sol
853 
854 pragma solidity ^0.4.24;
855 
856 /**
857  * @dev The contract has an owner address, and provides basic authorization control whitch
858  * simplifies the implementation of user permissions. This contract is based on the source code
859  * at https://goo.gl/n2ZGVt.
860  */
861 contract Ownable {
862   address public owner;
863 
864   /**
865    * @dev An event which is triggered when the owner is changed.
866    * @param previousOwner The address of the previous owner.
867    * @param newOwner The address of the new owner.
868    */
869   event OwnershipTransferred(
870     address indexed previousOwner,
871     address indexed newOwner
872   );
873 
874   /**
875    * @dev The constructor sets the original `owner` of the contract to the sender account.
876    */
877   constructor()
878     public
879   {
880     owner = msg.sender;
881   }
882 
883   /**
884    * @dev Throws if called by any account other than the owner.
885    */
886   modifier onlyOwner() {
887     require(msg.sender == owner);
888     _;
889   }
890 
891   /**
892    * @dev Allows the current owner to transfer control of the contract to a newOwner.
893    * @param _newOwner The address to transfer ownership to.
894    */
895   function transferOwnership(
896     address _newOwner
897   )
898     onlyOwner
899     public
900   {
901     require(_newOwner != address(0));
902     emit OwnershipTransferred(owner, _newOwner);
903     owner = _newOwner;
904   }
905 
906 }
907 
908 // File: @0xcert/ethereum-utils/contracts/ownership/Claimable.sol
909 
910 pragma solidity ^0.4.24;
911 
912 
913 /**
914  * @dev The contract has an owner address, and provides basic authorization control whitch
915  * simplifies the implementation of user permissions. This contract is based on the source code
916  * at goo.gl/CfEAkv and upgrades Ownable contracts with additional claim step which makes ownership
917  * transfers less prone to errors.
918  */
919 contract Claimable is Ownable {
920   address public pendingOwner;
921 
922   /**
923    * @dev An event which is triggered when the owner is changed.
924    * @param previousOwner The address of the previous owner.
925    * @param newOwner The address of the new owner.
926    */
927   event OwnershipTransferred(
928     address indexed previousOwner,
929     address indexed newOwner
930   );
931 
932   /**
933    * @dev Allows the current owner to give new owner ability to claim the ownership of the contract.
934    * This differs from the Owner's function in that it allows setting pedingOwner address to 0x0,
935    * which effectively cancels an active claim.
936    * @param _newOwner The address which can claim ownership of the contract.
937    */
938   function transferOwnership(
939     address _newOwner
940   )
941     onlyOwner
942     public
943   {
944     pendingOwner = _newOwner;
945   }
946 
947   /**
948    * @dev Allows the current pending owner to claim the ownership of the contract. It emits
949    * OwnershipTransferred event and resets pending owner to 0.
950    */
951   function claimOwnership()
952     public
953   {
954     require(msg.sender == pendingOwner);
955     address previousOwner = owner;
956     owner = pendingOwner;
957     pendingOwner = 0;
958     emit OwnershipTransferred(previousOwner, owner);
959   }
960 }
961 
962 // File: contracts/Adminable.sol
963 
964 pragma solidity ^0.4.24;
965 
966 
967 /**
968  * @title Adminable
969  * @dev Allows to manage privilages to special contract functionality.
970  */
971 contract Adminable is Claimable {
972   mapping(address => uint) public adminsMap;
973   address[] public adminList;
974 
975   /**
976    * @dev Returns true, if provided address has special privilages, otherwise false
977    * @param adminAddress - address to check
978    */
979   function isAdmin(address adminAddress)
980     public
981     view
982     returns(bool isIndeed)
983   {
984     if (adminAddress == owner) return true;
985 
986     if (adminList.length == 0) return false;
987     return (adminList[adminsMap[adminAddress]] == adminAddress);
988   }
989 
990   /**
991    * @dev Grants special rights for address holder
992    * @param adminAddress - address of future admin
993    */
994   function addAdmin(address adminAddress)
995     public
996     onlyOwner
997     returns(uint index)
998   {
999     require(!isAdmin(adminAddress), "Address already has admin rights!");
1000 
1001     adminsMap[adminAddress] = adminList.push(adminAddress)-1;
1002 
1003     return adminList.length-1;
1004   }
1005 
1006   /**
1007    * @dev Removes special rights for provided address
1008    * @param adminAddress - address of current admin
1009    */
1010   function removeAdmin(address adminAddress)
1011     public
1012     onlyOwner
1013     returns(uint index)
1014   {
1015     // we can not remove owner from admin role
1016     require(owner != adminAddress, "Owner can not be removed from admin role!");
1017     require(isAdmin(adminAddress), "Provided address is not admin.");
1018 
1019     uint rowToDelete = adminsMap[adminAddress];
1020     address keyToMove = adminList[adminList.length-1];
1021     adminList[rowToDelete] = keyToMove;
1022     adminsMap[keyToMove] = rowToDelete;
1023     adminList.length--;
1024 
1025     return rowToDelete;
1026   }
1027 
1028   /**
1029    * @dev modifier Throws if called by any account other than the owner.
1030    */
1031   modifier onlyAdmin() {
1032     require(isAdmin(msg.sender), "Can be executed only by admin accounts!");
1033     _;
1034   }
1035 }
1036 
1037 // File: contracts/Priceable.sol
1038 
1039 pragma solidity ^0.4.24;
1040 
1041 
1042 
1043 /**
1044  * @title Priceable
1045  * @dev Contracts allows to handle ETH resources of the contract.
1046  */
1047 contract Priceable is Claimable {
1048 
1049   using SafeMath for uint256;
1050 
1051   /**
1052    * @dev Emits when owner take ETH out of contract
1053    * @param balance - amount of ETh sent out from contract
1054    */
1055   event Withdraw(uint256 balance);
1056 
1057   /**
1058    * @dev modifier Checks minimal amount, what was sent to function call.
1059    * @param _minimalAmount - minimal amount neccessary to  continue function call
1060    */
1061   modifier minimalPrice(uint256 _minimalAmount) {
1062     require(msg.value >= _minimalAmount, "Not enough Ether provided.");
1063     _;
1064   }
1065 
1066   /**
1067    * @dev modifier Associete fee with a function call. If the caller sent too much, then is refunded, but only after the function body.
1068    * This was dangerous before Solidity version 0.4.0, where it was possible to skip the part after `_;`.
1069    * @param _amount - ether needed to call the function
1070    */
1071   modifier price(uint256 _amount) {
1072     require(msg.value >= _amount, "Not enough Ether provided.");
1073     _;
1074     if (msg.value > _amount) {
1075       msg.sender.transfer(msg.value.sub(_amount));
1076     }
1077   }
1078 
1079   /*
1080    * @dev Remove all Ether from the contract, and transfer it to account of owner
1081    */
1082   function withdrawBalance()
1083     external
1084     onlyOwner
1085   {
1086     uint256 balance = address(this).balance;
1087     msg.sender.transfer(balance);
1088 
1089     // Tell everyone !!!!!!!!!!!!!!!!!!!!!!
1090     emit Withdraw(balance);
1091   }
1092 
1093   // fallback function that allows contract to accept ETH
1094   function () public payable {}
1095 }
1096 
1097 // File: contracts/Pausable.sol
1098 
1099 pragma solidity ^0.4.24;
1100 
1101 
1102 /**
1103  * @title Pausable
1104  * @dev Base contract which allows children to implement an emergency stop mechanism for mainenance purposes
1105  */
1106 contract Pausable is Ownable {
1107   event Pause();
1108   event Unpause();
1109 
1110   bool public paused = false;
1111 
1112 
1113   /**
1114    * @dev modifier to allow actions only when the contract IS paused
1115    */
1116   modifier whenNotPaused() {
1117     require(!paused);
1118     _;
1119   }
1120 
1121   /**
1122    * @dev modifier to allow actions only when the contract IS NOT paused
1123    */
1124   modifier whenPaused {
1125     require(paused);
1126     _;
1127   }
1128 
1129   /**
1130    * @dev called by the owner to pause, triggers stopped state
1131    */
1132   function pause()
1133     external
1134     onlyOwner
1135     whenNotPaused
1136     returns (bool)
1137   {
1138     paused = true;
1139     emit Pause();
1140     return true;
1141   }
1142 
1143   /**
1144    * @dev called by the owner to unpause, returns to normal state
1145    */
1146   function unpause()
1147     external
1148     onlyOwner
1149     whenPaused
1150     returns (bool)
1151   {
1152     paused = false;
1153     emit Unpause();
1154     return true;
1155   }
1156 }
1157 
1158 // File: contracts/MarbleDutchAuctionInterface.sol
1159 
1160 pragma solidity ^0.4.24;
1161 
1162 /**
1163  * @title Marble Dutch Auction Interface
1164  * @dev describes all externaly accessible functions neccessery to run Marble Auctions
1165  */
1166 interface MarbleDutchAuctionInterface {
1167 
1168   /**
1169    * @dev Sets new auctioneer cut, in case we are to cheap :))
1170    * @param _cut - percent cut the auctioneer takes on each auction, must be between 0-100. Values 0-10,000 map to 0%-100%.
1171    */
1172   function setAuctioneerCut(
1173     uint256 _cut
1174   )
1175    external;
1176 
1177   /**
1178   * @dev Sets new auctioneer delayed cut, in case we are not earning much during creating NFTs initial auctions!
1179   * @param _cut Percent cut the auctioneer takes on each auction, must be between 0-10000. Values 0-10,000 map to 0%-100%.
1180   */
1181   function setAuctioneerDelayedCancelCut(
1182     uint256 _cut
1183   )
1184    external;
1185 
1186   /**
1187    * @dev Sets an addresses of ERC 721 contract owned/admined by same entity.
1188    * @param _nftAddress Address of ERC 721 contract
1189    */
1190   function setNFTContract(address _nftAddress)
1191     external;
1192 
1193 
1194   /**
1195    * @dev Creates new auction without special logic. It allows user to sell owned Marble NFTs
1196    * @param _tokenId ID of token to auction, sender must be owner.
1197    * @param _startingPrice Price of item (in wei) at beginning of auction.
1198    * @param _endingPrice Price of item (in wei) at end of auction.
1199    * @param _duration Length of time to move between starting price and ending price (in seconds) - it determines dynamic state of auction
1200    */
1201   function createAuction(
1202     uint256 _tokenId,
1203     uint256 _startingPrice,
1204     uint256 _endingPrice,
1205     uint256 _duration
1206   )
1207     external;
1208 
1209   /**
1210    * @dev Creates and begins a new minting auction. Minitng auction is initial auction allowing to challenge newly Minted Marble NFT.
1211    * If no-one buy NFT during dynamic state of auction, then seller (original creator of NFT) will be allowed to become owner of NFT. It means during dynamic (duration)
1212    * state of auction, it won't be possible to use cancelAuction function by seller!
1213    * @param _tokenId - ID of token to auction, sender must be owner.
1214    * @param _startingPrice - Price of item (in wei) at beginning of auction.
1215    * @param _endingPrice - Price of item (in wei) at end of auction.
1216    * @param _duration - Length of time to move between starting price and ending price (in seconds).
1217    * @param _seller - Seller, if not the message sender
1218    */
1219   function createMintingAuction(
1220     uint256 _tokenId,
1221     uint256 _startingPrice,
1222     uint256 _endingPrice,
1223     uint256 _duration,
1224     address _seller
1225   )
1226     external;
1227 
1228   /**
1229    * @dev It allows seller to cancel auction and get back Marble NFT.
1230    * @param _tokenId ID of token on auction
1231    */
1232   function cancelAuction(
1233     uint256 _tokenId
1234   )
1235     external;
1236 
1237   /**
1238    * @dev It allows seller to cancel auction and get back Marble NFT.
1239    * @param _tokenId ID of token on auction
1240    */
1241   function cancelAuctionWhenPaused(
1242     uint256 _tokenId
1243   )
1244     external;
1245 
1246   /**
1247    * @dev Bids on an open auction, completing the auction and transferring ownership of the NFT if enough Ether is supplied.
1248    * @param _tokenId ID of token to bid on.
1249    */
1250   function bid(
1251     uint256 _tokenId
1252   )
1253     external
1254     payable;
1255 
1256   /**
1257    * @dev Returns the current price of an auction.
1258    * @param _tokenId ID of the token price we are checking.
1259    */
1260   function getCurrentPrice(uint256 _tokenId)
1261     external
1262     view
1263     returns (uint256);
1264 
1265   /**
1266    * @dev Returns the count of all existing auctions.
1267    */
1268   function totalAuctions()
1269     external
1270     view
1271     returns (uint256);
1272 
1273   /**
1274    * @dev Returns NFT ID by its index.
1275    * @param _index A counter less than `totalSupply()`.
1276    */
1277   function tokenInAuctionByIndex(
1278     uint256 _index
1279   )
1280     external
1281     view
1282     returns (uint256);
1283 
1284   /**
1285    * @dev Returns the n-th NFT ID from a list of owner's tokens.
1286    * @param _seller Token owner's address.
1287    * @param _index Index number representing n-th token in owner's list of tokens.
1288    */
1289   function tokenOfSellerByIndex(
1290     address _seller,
1291     uint256 _index
1292   )
1293     external
1294     view
1295     returns (uint256);
1296 
1297   /**
1298    * @dev Returns the count of all existing auctions.
1299    */
1300   function totalAuctionsBySeller(
1301     address _seller
1302   )
1303     external
1304     view
1305     returns (uint256);
1306 
1307   /**
1308    * @dev Returns true if the NFT is on auction.
1309    * @param _tokenId ID of the token to be checked.
1310    */
1311   function isOnAuction(uint256 _tokenId)
1312     external
1313     view
1314     returns (bool isIndeed);
1315 
1316   /**
1317    * @dev Returns auction info for an NFT on auction.
1318    * @param _tokenId ID of NFT placed in auction
1319    */
1320   function getAuction(uint256 _tokenId)
1321     external
1322     view
1323     returns
1324   (
1325     address seller,
1326     uint256 startingPrice,
1327     uint256 endingPrice,
1328     uint256 duration,
1329     uint256 startedAt,
1330     bool canBeCanceled
1331   );
1332 
1333   /**
1334    * @dev remove NFT reference from auction conrtact, should be use only when NFT is being burned
1335    * @param _tokenId ID of token on auction
1336    */
1337   function removeAuction(
1338     uint256 _tokenId
1339   )
1340     external;
1341 }
1342 
1343 // File: contracts/MarbleDutchAuction.sol
1344 
1345 pragma solidity ^0.4.24;
1346 
1347 
1348 
1349 
1350 
1351 
1352 
1353 
1354 
1355 /**
1356  * @title Dutch auction for non-fungible tokens created by Marble.Cards.
1357  */
1358 contract MarbleDutchAuction is
1359   MarbleDutchAuctionInterface,
1360   Priceable,
1361   Adminable,
1362   Pausable,
1363   DutchAuctionEnumerable
1364 {
1365 
1366   /**
1367    * @dev The ERC-165 interface signature for ERC-721.
1368    *  Ref: https://github.com/ethereum/EIPs/issues/165
1369    *  Ref: https://github.com/ethereum/EIPs/issues/721
1370    */
1371   bytes4 constant InterfaceSignature_ERC721 = 0x80ac58cd;
1372 
1373   /**
1374    * @dev Reports change of auctioneer cut.
1375    * @param _auctioneerCut Number between 0-10000 (1% is equal to 100)
1376    */
1377   event AuctioneerCutChanged(uint256 _auctioneerCut);
1378 
1379   /**
1380    * @dev Reports change of auctioneer delayed cut.
1381    * @param _auctioneerDelayedCancelCut Number between 0-10000 (1% is equal to 100)
1382    */
1383   event AuctioneerDelayedCancelCutChanged(uint256 _auctioneerDelayedCancelCut);
1384 
1385   /**
1386    * @dev Reports removal of NFT from auction cotnract
1387    * @param _tokenId ID of token to auction, sender must be owner.
1388    */
1389   event AuctionRemoved(uint256 _tokenId);
1390 
1391   /**
1392    * @dev Creates new auction.
1393    * NOTE: !! Doing a dangerous stuff here!!! changing owner of NFT, be careful where u call this one !!!
1394    * TODO: in case of replacing forceApproval we can add our contracts as operators, but there is problem in possiblity of changing auction contract and we will be unable to transfer kards to new one
1395    * @param _tokenId ID of token to auction, sender must be owner.
1396    * @param _startingPrice Price of item (in wei) at beginning of auction.
1397    * @param _endingPrice Price of item (in wei) at end of auction.
1398    * @param _duration Length of time to move between starting
1399    * @param _delayedCancel If false seller can cancel auction any time, otherwise only after times up
1400    * @param _seller Seller, if not the message sender
1401    */
1402   function _createAuction(
1403       uint256 _tokenId,
1404       uint256 _startingPrice,
1405       uint256 _endingPrice,
1406       uint256 _duration,
1407       bool _delayedCancel,
1408       address _seller
1409   )
1410       internal
1411       whenNotPaused
1412   {
1413       MarbleNFTInterface marbleNFT = MarbleNFTInterface(address(nftContract));
1414 
1415       // Sanity check that no inputs overflow how many bits we've allocated
1416       // to store them as auction model.
1417       require(_startingPrice == uint256(uint128(_startingPrice)), "Starting price is too high!");
1418       require(_endingPrice == uint256(uint128(_endingPrice)), "Ending price is too high!");
1419       require(_duration == uint256(uint64(_duration)), "Duration exceeds allowed limit!");
1420 
1421       /**
1422        * NOTE: !! Doing a dangerous stuff here !!
1423        * before calling this should be clear that seller is owner of NFT
1424        */
1425       marbleNFT.forceApproval(_tokenId, address(this));
1426 
1427       // lets auctioneer to own NFT for purposes of auction
1428       nftContract.transferFrom(_seller, address(this), _tokenId);
1429 
1430       Auction memory auction = Auction(
1431         _seller,
1432         uint128(_startingPrice),
1433         uint128(_endingPrice),
1434         uint64(_duration),
1435         uint256(now),
1436         bool(_delayedCancel)
1437       );
1438 
1439       _addAuction(_tokenId, auction);
1440   }
1441 
1442   /**
1443    * @dev Sets new auctioneer cut, in case we are to cheap :))
1444    * @param _cut Percent cut the auctioneer takes on each auction, must be between 0-10000. Values 0-10,000 map to 0%-100%.
1445    */
1446   function setAuctioneerCut(uint256 _cut)
1447     external
1448     onlyAdmin
1449   {
1450     require(_cut <= 10000, "Cut should be in interval of 0-10000");
1451     auctioneerCut = uint16(_cut);
1452 
1453     emit AuctioneerCutChanged(auctioneerCut);
1454   }
1455 
1456   /**
1457    * @dev Sets new auctioneer delayed cut, in case we are not earning much during creating NFTs initial auctions!
1458    * @param _cut Percent cut the auctioneer takes on each auction, must be between 0-10000. Values 0-10,000 map to 0%-100%.
1459    */
1460   function setAuctioneerDelayedCancelCut(uint256 _cut)
1461     external
1462     onlyAdmin
1463   {
1464     require(_cut <= 10000, "Delayed cut should be in interval of 0-10000");
1465     auctioneerDelayedCancelCut = uint16(_cut);
1466 
1467     emit AuctioneerDelayedCancelCutChanged(auctioneerDelayedCancelCut);
1468   }
1469 
1470   /**
1471    * @dev Sets an addresses of ERC 721 contract owned/admined by same entity.
1472    * @param _nftAddress Address of ERC 721 contract
1473    */
1474   function setNFTContract(address _nftAddress)
1475     external
1476     onlyAdmin
1477   {
1478     ERC165 nftContractToCheck = ERC165(_nftAddress);
1479     require(nftContractToCheck.supportsInterface(InterfaceSignature_ERC721)); // ERC721 == 0x80ac58cd
1480     nftContract = ERC721(_nftAddress);
1481   }
1482 
1483   /**
1484    * @dev Creates and begins a new minting auction. Minitng auction is initial auction allowing to challenge newly Minted Marble NFT.
1485    * If no-one buy NFT during its dynamic state, then seller (original creator of NFT) will be allowed to become owner of NFT. It means during dynamic (duration)
1486    * state of auction, it won't be possible to use cancelAuction function by seller!
1487    * @param _tokenId ID of token to auction, sender must be owner.
1488    * @param _startingPrice Price of item (in wei) at beginning of auction.
1489    * @param _endingPrice Price of item (in wei) at end of auction.
1490    * @param _duration Length of time to move between starting price and ending price (in seconds).
1491    * @param _seller Seller, if not the message sender
1492    */
1493   function createMintingAuction(
1494       uint256 _tokenId,
1495       uint256 _startingPrice,
1496       uint256 _endingPrice,
1497       uint256 _duration,
1498       address _seller
1499   )
1500       external
1501       whenNotPaused
1502       onlyAdmin
1503   {
1504       // TODO minitingPrice vs mintintgFee require(_endingPrice > _mintingFee, "Ending price of minitng auction has to be bigger than minting fee!");
1505 
1506       // Sale auction throws if inputs are invalid and clears
1507       _createAuction(
1508         _tokenId,
1509         _startingPrice,
1510         _endingPrice,
1511         _duration,
1512         true, // seller can NOT cancel auction only after time is up! and bidders can be just over duration
1513         _seller
1514       );
1515   }
1516 
1517   /**
1518    * @dev Creates new auction without special logic.
1519    * @param _tokenId ID of token to auction, sender must be owner.
1520    * @param _startingPrice Price of item (in wei) at beginning of auction.
1521    * @param _endingPrice Price of item (in wei) at end of auction.
1522    * @param _duration Length of time to move between starting price and ending price (in seconds) - it determines dynamic state of auction
1523    */
1524   function createAuction(
1525       uint256 _tokenId,
1526       uint256 _startingPrice,
1527       uint256 _endingPrice,
1528       uint256 _duration
1529   )
1530       external
1531       whenNotPaused
1532   {
1533       require(nftContract.ownerOf(_tokenId) == msg.sender, "Only owner of the token can create auction!");
1534       // Sale auction throws if inputs are invalid and clears
1535       _createAuction(
1536         _tokenId,
1537         _startingPrice,
1538         _endingPrice,
1539         _duration,
1540         false, // seller can cancel auction any time
1541         msg.sender
1542       );
1543   }
1544 
1545   /**
1546    * @dev Bids on an open auction, completing the auction and transferring ownership of the NFT if enough Ether is supplied.
1547    * NOTE: Bid can be placed on normal auction any time,
1548    * but in case of "minting" auction (_delayedCancel == true) it can be placed only when call of _isTimeUp(auction) returns false
1549    * @param _tokenId ID of token to bid on.
1550    */
1551   function bid(uint256 _tokenId)
1552       external
1553       payable
1554       whenNotPaused
1555   {
1556     Auction storage auction = tokenIdToAuction[_tokenId];
1557     require(_isOnAuction(auction), "NFT is not on this auction!");
1558     require(!auction.delayedCancel || !_durationIsOver(auction), "You can not bid on this auction, because it has delayed cancel policy actived and after times up it belongs once again to seller!");
1559 
1560     // _bid will throw if the bid or funds transfer fails
1561     _bid(_tokenId, msg.value);
1562 
1563     // change the ownership of NFT
1564     nftContract.transferFrom(address(this), msg.sender, _tokenId);
1565   }
1566 
1567   /**
1568    * @dev It allows seller to cancel auction and get back Marble NFT, but it works only when delayedCancel property is false or when auction duratian time is up.
1569    * @param _tokenId ID of token on auction
1570    */
1571   function cancelAuction(uint256 _tokenId)
1572     external
1573     whenNotPaused
1574   {
1575       Auction storage auction = tokenIdToAuction[_tokenId];
1576       require(_isOnAuction(auction), "NFT is not auctioned over our contract!");
1577       require((!auction.delayedCancel || _durationIsOver(auction)) && msg.sender == auction.seller, "You have no rights to cancel this auction!");
1578 
1579       _cancelAuction(_tokenId);
1580   }
1581 
1582   /**
1583    * @dev Cancels an auction when the contract is paused.
1584    *  Only the admin may do this, and NFTs are returned to the seller. This should only be used in emergencies like moving to another auction contract.
1585    * @param _tokenId ID of the NFT on auction to cancel.
1586    */
1587   function cancelAuctionWhenPaused(uint256 _tokenId)
1588     external
1589     whenPaused
1590     onlyAdmin
1591   {
1592       Auction storage auction = tokenIdToAuction[_tokenId];
1593       require(_isOnAuction(auction), "NFT is not auctioned over our contract!");
1594       _cancelAuction(_tokenId);
1595   }
1596 
1597   /**
1598    * @dev Returns true if NFT is placed as auction over this contract, otherwise false.
1599    * @param _tokenId ID of NFT to check.
1600    */
1601   function isOnAuction(uint256 _tokenId)
1602     external
1603     view
1604     returns (bool isIndeed)
1605   {
1606     Auction storage auction = tokenIdToAuction[_tokenId];
1607     return _isOnAuction(auction);
1608   }
1609 
1610   /**
1611    * @dev Returns auction info for an NFT on auction.
1612    * @param _tokenId ID of NFT placed in auction
1613    */
1614   function getAuction(uint256 _tokenId)
1615     external
1616     view
1617     returns
1618   (
1619     address seller,
1620     uint256 startingPrice,
1621     uint256 endingPrice,
1622     uint256 duration,
1623     uint256 startedAt,
1624     bool delayedCancel
1625   ) {
1626       Auction storage auction = tokenIdToAuction[_tokenId];
1627       require(_isOnAuction(auction), "NFT is not auctioned over our contract!");
1628 
1629       return (
1630           auction.seller,
1631           auction.startingPrice,
1632           auction.endingPrice,
1633           auction.duration,
1634           auction.startedAt,
1635           auction.delayedCancel
1636       );
1637   }
1638 
1639   /**
1640    * @dev Returns the current price of an auction.
1641    * @param _tokenId ID of the token price we are checking.
1642    */
1643   function getCurrentPrice(uint256 _tokenId)
1644       external
1645       view
1646       returns (uint256)
1647   {
1648       Auction storage auction = tokenIdToAuction[_tokenId];
1649       require(_isOnAuction(auction), "NFT is not auctioned over our contract!");
1650       return _currentPrice(auction);
1651 
1652   }
1653 
1654   /**
1655    * @dev remove NFT reference from auction conrtact, should be use only when NFT is being burned
1656    * @param _tokenId ID of token on auction
1657    */
1658   function removeAuction(
1659     uint256 _tokenId
1660   )
1661     external
1662     whenPaused
1663     onlyAdmin
1664   {
1665     _removeAuction(_tokenId);
1666 
1667     emit AuctionRemoved(_tokenId);
1668   }
1669 }