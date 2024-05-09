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
172 // File: @0xcert/ethereum-erc721/contracts/tokens/ERC721Enumerable.sol
173 
174 pragma solidity ^0.4.24;
175 
176 /**
177  * @dev Optional enumeration extension for ERC-721 non-fungible token standard.
178  * See https://goo.gl/pc9yoS.
179  */
180 interface ERC721Enumerable {
181 
182   /**
183    * @dev Returns a count of valid NFTs tracked by this contract, where each one of them has an
184    * assigned and queryable owner not equal to the zero address.
185    */
186   function totalSupply()
187     external
188     view
189     returns (uint256);
190 
191   /**
192    * @dev Returns the token identifier for the `_index`th NFT. Sort order is not specified.
193    * @param _index A counter less than `totalSupply()`.
194    */
195   function tokenByIndex(
196     uint256 _index
197   )
198     external
199     view
200     returns (uint256);
201 
202   /**
203    * @dev Returns the token identifier for the `_index`th NFT assigned to `_owner`. Sort order is
204    * not specified. It throws if `_index` >= `balanceOf(_owner)` or if `_owner` is the zero address,
205    * representing invalid NFTs.
206    * @param _owner An address where we are interested in NFTs owned by them.
207    * @param _index A counter less than `balanceOf(_owner)`.
208    */
209   function tokenOfOwnerByIndex(
210     address _owner,
211     uint256 _index
212   )
213     external
214     view
215     returns (uint256);
216 
217 }
218 
219 // File: @0xcert/ethereum-erc721/contracts/tokens/ERC721Metadata.sol
220 
221 pragma solidity ^0.4.24;
222 
223 /**
224  * @dev Optional metadata extension for ERC-721 non-fungible token standard.
225  * See https://goo.gl/pc9yoS.
226  */
227 interface ERC721Metadata {
228 
229   /**
230    * @dev Returns a descriptive name for a collection of NFTs in this contract.
231    */
232   function name()
233     external
234     view
235     returns (string _name);
236 
237   /**
238    * @dev Returns a abbreviated name for a collection of NFTs in this contract.
239    */
240   function symbol()
241     external
242     view
243     returns (string _symbol);
244 
245   /**
246    * @dev Returns a distinct Uniform Resource Identifier (URI) for a given asset. It Throws if
247    * `_tokenId` is not a valid NFT. URIs are defined in RFC3986. The URI may point to a JSON file
248    * that conforms to the "ERC721 Metadata JSON Schema".
249    */
250   function tokenURI(uint256 _tokenId)
251     external
252     view
253     returns (string);
254 
255 }
256 
257 // File: @0xcert/ethereum-utils/contracts/utils/ERC165.sol
258 
259 pragma solidity ^0.4.24;
260 
261 /**
262  * @dev A standard for detecting smart contract interfaces. See https://goo.gl/cxQCse.
263  */
264 interface ERC165 {
265 
266   /**
267    * @dev Checks if the smart contract includes a specific interface.
268    * @notice This function uses less than 30,000 gas.
269    * @param _interfaceID The interface identifier, as specified in ERC-165.
270    */
271   function supportsInterface(
272     bytes4 _interfaceID
273   )
274     external
275     view
276     returns (bool);
277 
278 }
279 
280 // File: @0xcert/ethereum-utils/contracts/utils/SupportsInterface.sol
281 
282 pragma solidity ^0.4.24;
283 
284 
285 /**
286  * @dev Implementation of standard for detect smart contract interfaces.
287  */
288 contract SupportsInterface is
289   ERC165
290 {
291 
292   /**
293    * @dev Mapping of supported intefraces.
294    * @notice You must not set element 0xffffffff to true.
295    */
296   mapping(bytes4 => bool) internal supportedInterfaces;
297 
298   /**
299    * @dev Contract constructor.
300    */
301   constructor()
302     public
303   {
304     supportedInterfaces[0x01ffc9a7] = true; // ERC165
305   }
306 
307   /**
308    * @dev Function to check which interfaces are suported by this contract.
309    * @param _interfaceID Id of the interface.
310    */
311   function supportsInterface(
312     bytes4 _interfaceID
313   )
314     external
315     view
316     returns (bool)
317   {
318     return supportedInterfaces[_interfaceID];
319   }
320 
321 }
322 
323 // File: @0xcert/ethereum-utils/contracts/math/SafeMath.sol
324 
325 pragma solidity ^0.4.24;
326 
327 /**
328  * @dev Math operations with safety checks that throw on error. This contract is based
329  * on the source code at https://goo.gl/iyQsmU.
330  */
331 library SafeMath {
332 
333   /**
334    * @dev Multiplies two numbers, throws on overflow.
335    * @param _a Factor number.
336    * @param _b Factor number.
337    */
338   function mul(
339     uint256 _a,
340     uint256 _b
341   )
342     internal
343     pure
344     returns (uint256)
345   {
346     if (_a == 0) {
347       return 0;
348     }
349     uint256 c = _a * _b;
350     assert(c / _a == _b);
351     return c;
352   }
353 
354   /**
355    * @dev Integer division of two numbers, truncating the quotient.
356    * @param _a Dividend number.
357    * @param _b Divisor number.
358    */
359   function div(
360     uint256 _a,
361     uint256 _b
362   )
363     internal
364     pure
365     returns (uint256)
366   {
367     uint256 c = _a / _b;
368     // assert(b > 0); // Solidity automatically throws when dividing by 0
369     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
370     return c;
371   }
372 
373   /**
374    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
375    * @param _a Minuend number.
376    * @param _b Subtrahend number.
377    */
378   function sub(
379     uint256 _a,
380     uint256 _b
381   )
382     internal
383     pure
384     returns (uint256)
385   {
386     assert(_b <= _a);
387     return _a - _b;
388   }
389 
390   /**
391    * @dev Adds two numbers, throws on overflow.
392    * @param _a Number.
393    * @param _b Number.
394    */
395   function add(
396     uint256 _a,
397     uint256 _b
398   )
399     internal
400     pure
401     returns (uint256)
402   {
403     uint256 c = _a + _b;
404     assert(c >= _a);
405     return c;
406   }
407 
408 }
409 
410 // File: @0xcert/ethereum-utils/contracts/ownership/Ownable.sol
411 
412 pragma solidity ^0.4.24;
413 
414 /**
415  * @dev The contract has an owner address, and provides basic authorization control whitch
416  * simplifies the implementation of user permissions. This contract is based on the source code
417  * at https://goo.gl/n2ZGVt.
418  */
419 contract Ownable {
420   address public owner;
421 
422   /**
423    * @dev An event which is triggered when the owner is changed.
424    * @param previousOwner The address of the previous owner.
425    * @param newOwner The address of the new owner.
426    */
427   event OwnershipTransferred(
428     address indexed previousOwner,
429     address indexed newOwner
430   );
431 
432   /**
433    * @dev The constructor sets the original `owner` of the contract to the sender account.
434    */
435   constructor()
436     public
437   {
438     owner = msg.sender;
439   }
440 
441   /**
442    * @dev Throws if called by any account other than the owner.
443    */
444   modifier onlyOwner() {
445     require(msg.sender == owner);
446     _;
447   }
448 
449   /**
450    * @dev Allows the current owner to transfer control of the contract to a newOwner.
451    * @param _newOwner The address to transfer ownership to.
452    */
453   function transferOwnership(
454     address _newOwner
455   )
456     onlyOwner
457     public
458   {
459     require(_newOwner != address(0));
460     emit OwnershipTransferred(owner, _newOwner);
461     owner = _newOwner;
462   }
463 
464 }
465 
466 // File: @0xcert/ethereum-utils/contracts/ownership/Claimable.sol
467 
468 pragma solidity ^0.4.24;
469 
470 
471 /**
472  * @dev The contract has an owner address, and provides basic authorization control whitch
473  * simplifies the implementation of user permissions. This contract is based on the source code
474  * at goo.gl/CfEAkv and upgrades Ownable contracts with additional claim step which makes ownership
475  * transfers less prone to errors.
476  */
477 contract Claimable is Ownable {
478   address public pendingOwner;
479 
480   /**
481    * @dev An event which is triggered when the owner is changed.
482    * @param previousOwner The address of the previous owner.
483    * @param newOwner The address of the new owner.
484    */
485   event OwnershipTransferred(
486     address indexed previousOwner,
487     address indexed newOwner
488   );
489 
490   /**
491    * @dev Allows the current owner to give new owner ability to claim the ownership of the contract.
492    * This differs from the Owner's function in that it allows setting pedingOwner address to 0x0,
493    * which effectively cancels an active claim.
494    * @param _newOwner The address which can claim ownership of the contract.
495    */
496   function transferOwnership(
497     address _newOwner
498   )
499     onlyOwner
500     public
501   {
502     pendingOwner = _newOwner;
503   }
504 
505   /**
506    * @dev Allows the current pending owner to claim the ownership of the contract. It emits
507    * OwnershipTransferred event and resets pending owner to 0.
508    */
509   function claimOwnership()
510     public
511   {
512     require(msg.sender == pendingOwner);
513     address previousOwner = owner;
514     owner = pendingOwner;
515     pendingOwner = 0;
516     emit OwnershipTransferred(previousOwner, owner);
517   }
518 }
519 
520 // File: contracts/Adminable.sol
521 
522 pragma solidity ^0.4.24;
523 
524 
525 /**
526  * @title Adminable
527  * @dev Allows to manage privilages to special contract functionality.
528  */
529 contract Adminable is Claimable {
530   mapping(address => uint) public adminsMap;
531   address[] public adminList;
532 
533   /**
534    * @dev Returns true, if provided address has special privilages, otherwise false
535    * @param adminAddress - address to check
536    */
537   function isAdmin(address adminAddress)
538     public
539     view
540     returns(bool isIndeed)
541   {
542     if (adminAddress == owner) return true;
543 
544     if (adminList.length == 0) return false;
545     return (adminList[adminsMap[adminAddress]] == adminAddress);
546   }
547 
548   /**
549    * @dev Grants special rights for address holder
550    * @param adminAddress - address of future admin
551    */
552   function addAdmin(address adminAddress)
553     public
554     onlyOwner
555     returns(uint index)
556   {
557     require(!isAdmin(adminAddress), "Address already has admin rights!");
558 
559     adminsMap[adminAddress] = adminList.push(adminAddress)-1;
560 
561     return adminList.length-1;
562   }
563 
564   /**
565    * @dev Removes special rights for provided address
566    * @param adminAddress - address of current admin
567    */
568   function removeAdmin(address adminAddress)
569     public
570     onlyOwner
571     returns(uint index)
572   {
573     // we can not remove owner from admin role
574     require(owner != adminAddress, "Owner can not be removed from admin role!");
575     require(isAdmin(adminAddress), "Provided address is not admin.");
576 
577     uint rowToDelete = adminsMap[adminAddress];
578     address keyToMove = adminList[adminList.length-1];
579     adminList[rowToDelete] = keyToMove;
580     adminsMap[keyToMove] = rowToDelete;
581     adminList.length--;
582 
583     return rowToDelete;
584   }
585 
586   /**
587    * @dev modifier Throws if called by any account other than the owner.
588    */
589   modifier onlyAdmin() {
590     require(isAdmin(msg.sender), "Can be executed only by admin accounts!");
591     _;
592   }
593 }
594 
595 // File: contracts/Pausable.sol
596 
597 pragma solidity ^0.4.24;
598 
599 
600 /**
601  * @title Pausable
602  * @dev Base contract which allows children to implement an emergency stop mechanism for mainenance purposes
603  */
604 contract Pausable is Ownable {
605   event Pause();
606   event Unpause();
607 
608   bool public paused = false;
609 
610 
611   /**
612    * @dev modifier to allow actions only when the contract IS paused
613    */
614   modifier whenNotPaused() {
615     require(!paused);
616     _;
617   }
618 
619   /**
620    * @dev modifier to allow actions only when the contract IS NOT paused
621    */
622   modifier whenPaused {
623     require(paused);
624     _;
625   }
626 
627   /**
628    * @dev called by the owner to pause, triggers stopped state
629    */
630   function pause()
631     external
632     onlyOwner
633     whenNotPaused
634     returns (bool)
635   {
636     paused = true;
637     emit Pause();
638     return true;
639   }
640 
641   /**
642    * @dev called by the owner to unpause, returns to normal state
643    */
644   function unpause()
645     external
646     onlyOwner
647     whenPaused
648     returns (bool)
649   {
650     paused = false;
651     emit Unpause();
652     return true;
653   }
654 }
655 
656 // File: contracts/MarbleNFTCandidateInterface.sol
657 
658 pragma solidity ^0.4.24;
659 
660 /**
661  * @title Marble NFT Candidate Contract
662  * @dev Contracts allows public audiance to create Marble NFT candidates. All our candidates for NFT goes through our services to figure out if they are suitable for Marble NFT.
663  * once their are picked our other contract will create NFT with same owner as candite and plcae it to minting auction. In minitng auction everyone can buy created NFT until duration period.
664  * If duration is over, and noone has bought NFT, then creator of candidate can take Marble NFT from minting auction to his collection.
665  */
666 interface MarbleNFTCandidateInterface {
667 
668   /**
669    * @dev Sets minimal price for creating Marble NFT Candidate
670    * @param _minimalMintingPrice Minimal price asked from creator of Marble NFT candidate (weis)
671    */
672   function setMinimalPrice(uint256 _minimalMintingPrice)
673     external;
674 
675   /**
676    * @dev Returns true if URI is already a candidate. Otherwise false.
677    * @param _uri URI to check
678    */
679   function isCandidate(string _uri)
680     external
681     view
682     returns(bool isIndeed);
683 
684 
685   /**
686    * @dev Creates Marble NFT Candidate. This candidate will go through our processing. If it's suitable, then Marble NFT is created.
687    * @param _uri URI of resource you want to transform to Marble NFT
688    */
689   function createCandidate(string _uri)
690     external
691     payable
692     returns(uint index);
693 
694   /**
695    * @dev Removes URI from candidate list.
696    * @param _uri URI to be removed from candidate list.
697    */
698   function removeCandidate(string _uri)
699     external;
700 
701   /**
702    * @dev Returns total count of candidates.
703    */
704   function getCandidatesCount()
705     external
706     view
707     returns(uint256 count);
708 
709   /**
710    * @dev Transforms URI to hash.
711    * @param _uri URI to be transformed to hash.
712    */
713   function getUriHash(string _uri)
714     external
715     view
716     returns(uint256 hash);
717 
718   /**
719    * @dev Returns Candidate model by URI
720    * @param _uri URI representing candidate
721    */
722   function getCandidate(string _uri)
723     external
724     view
725     returns(
726     uint256 index,
727     address owner,
728     uint256 mintingPrice,
729     string url,
730     uint256 created);
731 }
732 
733 // File: contracts/MarbleDutchAuctionInterface.sol
734 
735 pragma solidity ^0.4.24;
736 
737 /**
738  * @title Marble Dutch Auction Interface
739  * @dev describes all externaly accessible functions neccessery to run Marble Auctions
740  */
741 interface MarbleDutchAuctionInterface {
742 
743   /**
744    * @dev Sets new auctioneer cut, in case we are to cheap :))
745    * @param _cut - percent cut the auctioneer takes on each auction, must be between 0-100. Values 0-10,000 map to 0%-100%.
746    */
747   function setAuctioneerCut(
748     uint256 _cut
749   )
750    external;
751 
752   /**
753   * @dev Sets new auctioneer delayed cut, in case we are not earning much during creating NFTs initial auctions!
754   * @param _cut Percent cut the auctioneer takes on each auction, must be between 0-10000. Values 0-10,000 map to 0%-100%.
755   */
756   function setAuctioneerDelayedCancelCut(
757     uint256 _cut
758   )
759    external;
760 
761   /**
762    * @dev Sets an addresses of ERC 721 contract owned/admined by same entity.
763    * @param _nftAddress Address of ERC 721 contract
764    */
765   function setNFTContract(address _nftAddress)
766     external;
767 
768 
769   /**
770    * @dev Creates new auction without special logic. It allows user to sell owned Marble NFTs
771    * @param _tokenId ID of token to auction, sender must be owner.
772    * @param _startingPrice Price of item (in wei) at beginning of auction.
773    * @param _endingPrice Price of item (in wei) at end of auction.
774    * @param _duration Length of time to move between starting price and ending price (in seconds) - it determines dynamic state of auction
775    */
776   function createAuction(
777     uint256 _tokenId,
778     uint256 _startingPrice,
779     uint256 _endingPrice,
780     uint256 _duration
781   )
782     external;
783 
784   /**
785    * @dev Creates and begins a new minting auction. Minitng auction is initial auction allowing to challenge newly Minted Marble NFT.
786    * If no-one buy NFT during dynamic state of auction, then seller (original creator of NFT) will be allowed to become owner of NFT. It means during dynamic (duration)
787    * state of auction, it won't be possible to use cancelAuction function by seller!
788    * @param _tokenId - ID of token to auction, sender must be owner.
789    * @param _startingPrice - Price of item (in wei) at beginning of auction.
790    * @param _endingPrice - Price of item (in wei) at end of auction.
791    * @param _duration - Length of time to move between starting price and ending price (in seconds).
792    * @param _seller - Seller, if not the message sender
793    */
794   function createMintingAuction(
795     uint256 _tokenId,
796     uint256 _startingPrice,
797     uint256 _endingPrice,
798     uint256 _duration,
799     address _seller
800   )
801     external;
802 
803   /**
804    * @dev It allows seller to cancel auction and get back Marble NFT.
805    * @param _tokenId ID of token on auction
806    */
807   function cancelAuction(
808     uint256 _tokenId
809   )
810     external;
811 
812   /**
813    * @dev It allows seller to cancel auction and get back Marble NFT.
814    * @param _tokenId ID of token on auction
815    */
816   function cancelAuctionWhenPaused(
817     uint256 _tokenId
818   )
819     external;
820 
821   /**
822    * @dev Bids on an open auction, completing the auction and transferring ownership of the NFT if enough Ether is supplied.
823    * @param _tokenId ID of token to bid on.
824    */
825   function bid(
826     uint256 _tokenId
827   )
828     external
829     payable;
830 
831   /**
832    * @dev Returns the current price of an auction.
833    * @param _tokenId ID of the token price we are checking.
834    */
835   function getCurrentPrice(uint256 _tokenId)
836     external
837     view
838     returns (uint256);
839 
840   /**
841    * @dev Returns the count of all existing auctions.
842    */
843   function totalAuctions()
844     external
845     view
846     returns (uint256);
847 
848   /**
849    * @dev Returns NFT ID by its index.
850    * @param _index A counter less than `totalSupply()`.
851    */
852   function tokenInAuctionByIndex(
853     uint256 _index
854   )
855     external
856     view
857     returns (uint256);
858 
859   /**
860    * @dev Returns the n-th NFT ID from a list of owner's tokens.
861    * @param _seller Token owner's address.
862    * @param _index Index number representing n-th token in owner's list of tokens.
863    */
864   function tokenOfSellerByIndex(
865     address _seller,
866     uint256 _index
867   )
868     external
869     view
870     returns (uint256);
871 
872   /**
873    * @dev Returns the count of all existing auctions.
874    */
875   function totalAuctionsBySeller(
876     address _seller
877   )
878     external
879     view
880     returns (uint256);
881 
882   /**
883    * @dev Returns true if the NFT is on auction.
884    * @param _tokenId ID of the token to be checked.
885    */
886   function isOnAuction(uint256 _tokenId)
887     external
888     view
889     returns (bool isIndeed);
890 
891   /**
892    * @dev Returns auction info for an NFT on auction.
893    * @param _tokenId ID of NFT placed in auction
894    */
895   function getAuction(uint256 _tokenId)
896     external
897     view
898     returns
899   (
900     address seller,
901     uint256 startingPrice,
902     uint256 endingPrice,
903     uint256 duration,
904     uint256 startedAt,
905     bool canBeCanceled
906   );
907 
908   /**
909    * @dev remove NFT reference from auction conrtact, should be use only when NFT is being burned
910    * @param _tokenId ID of token on auction
911    */
912   function removeAuction(
913     uint256 _tokenId
914   )
915     external;
916 }
917 
918 // File: @0xcert/ethereum-erc721/contracts/tokens/ERC721TokenReceiver.sol
919 
920 pragma solidity ^0.4.24;
921 
922 /**
923  * @dev ERC-721 interface for accepting safe transfers. See https://goo.gl/pc9yoS.
924  */
925 interface ERC721TokenReceiver {
926 
927   /**
928    * @dev Handle the receipt of a NFT. The ERC721 smart contract calls this function on the
929    * recipient after a `transfer`. This function MAY throw to revert and reject the transfer. Return
930    * of other than the magic value MUST result in the transaction being reverted.
931    * Returns `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))` unless throwing.
932    * @notice The contract address is always the message sender. A wallet/broker/auction application
933    * MUST implement the wallet interface if it will accept safe transfers.
934    * @param _operator The address which called `safeTransferFrom` function.
935    * @param _from The address which previously owned the token.
936    * @param _tokenId The NFT identifier which is being transferred.
937    * @param _data Additional data with no specified format.
938    */
939   function onERC721Received(
940     address _operator,
941     address _from,
942     uint256 _tokenId,
943     bytes _data
944   )
945     external
946     returns(bytes4);
947     
948 }
949 
950 // File: @0xcert/ethereum-utils/contracts/utils/AddressUtils.sol
951 
952 pragma solidity ^0.4.24;
953 
954 /**
955  * @dev Utility library of inline functions on addresses.
956  */
957 library AddressUtils {
958 
959   /**
960    * @dev Returns whether the target address is a contract.
961    * @param _addr Address to check.
962    */
963   function isContract(
964     address _addr
965   )
966     internal
967     view
968     returns (bool)
969   {
970     uint256 size;
971 
972     /**
973      * XXX Currently there is no better way to check if there is a contract in an address than to
974      * check the size of the code at that address.
975      * See https://ethereum.stackexchange.com/a/14016/36603 for more details about how this works.
976      * TODO: Check this again before the Serenity release, because all addresses will be
977      * contracts then.
978      */
979     assembly { size := extcodesize(_addr) } // solium-disable-line security/no-inline-assembly
980     return size > 0;
981   }
982 
983 }
984 
985 // File: @0xcert/ethereum-erc721/contracts/tokens/NFToken.sol
986 
987 pragma solidity ^0.4.24;
988 
989 
990 
991 
992 
993 
994 /**
995  * @dev Implementation of ERC-721 non-fungible token standard.
996  */
997 contract NFToken is
998   ERC721,
999   SupportsInterface
1000 {
1001   using SafeMath for uint256;
1002   using AddressUtils for address;
1003 
1004   /**
1005    * @dev A mapping from NFT ID to the address that owns it.
1006    */
1007   mapping (uint256 => address) internal idToOwner;
1008 
1009   /**
1010    * @dev Mapping from NFT ID to approved address.
1011    */
1012   mapping (uint256 => address) internal idToApprovals;
1013 
1014    /**
1015    * @dev Mapping from owner address to count of his tokens.
1016    */
1017   mapping (address => uint256) internal ownerToNFTokenCount;
1018 
1019   /**
1020    * @dev Mapping from owner address to mapping of operator addresses.
1021    */
1022   mapping (address => mapping (address => bool)) internal ownerToOperators;
1023 
1024   /**
1025    * @dev Magic value of a smart contract that can recieve NFT.
1026    * Equal to: bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")).
1027    */
1028   bytes4 constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;
1029 
1030   /**
1031    * @dev Emits when ownership of any NFT changes by any mechanism. This event emits when NFTs are
1032    * created (`from` == 0) and destroyed (`to` == 0). Exception: during contract creation, any
1033    * number of NFTs may be created and assigned without emitting Transfer. At the time of any
1034    * transfer, the approved address for that NFT (if any) is reset to none.
1035    * @param _from Sender of NFT (if address is zero address it indicates token creation).
1036    * @param _to Receiver of NFT (if address is zero address it indicates token destruction).
1037    * @param _tokenId The NFT that got transfered.
1038    */
1039   event Transfer(
1040     address indexed _from,
1041     address indexed _to,
1042     uint256 indexed _tokenId
1043   );
1044 
1045   /**
1046    * @dev This emits when the approved address for an NFT is changed or reaffirmed. The zero
1047    * address indicates there is no approved address. When a Transfer event emits, this also
1048    * indicates that the approved address for that NFT (if any) is reset to none.
1049    * @param _owner Owner of NFT.
1050    * @param _approved Address that we are approving.
1051    * @param _tokenId NFT which we are approving.
1052    */
1053   event Approval(
1054     address indexed _owner,
1055     address indexed _approved,
1056     uint256 indexed _tokenId
1057   );
1058 
1059   /**
1060    * @dev This emits when an operator is enabled or disabled for an owner. The operator can manage
1061    * all NFTs of the owner.
1062    * @param _owner Owner of NFT.
1063    * @param _operator Address to which we are setting operator rights.
1064    * @param _approved Status of operator rights(true if operator rights are given and false if
1065    * revoked).
1066    */
1067   event ApprovalForAll(
1068     address indexed _owner,
1069     address indexed _operator,
1070     bool _approved
1071   );
1072 
1073   /**
1074    * @dev Guarantees that the msg.sender is an owner or operator of the given NFT.
1075    * @param _tokenId ID of the NFT to validate.
1076    */
1077   modifier canOperate(
1078     uint256 _tokenId
1079   ) {
1080     address tokenOwner = idToOwner[_tokenId];
1081     require(tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender]);
1082     _;
1083   }
1084 
1085   /**
1086    * @dev Guarantees that the msg.sender is allowed to transfer NFT.
1087    * @param _tokenId ID of the NFT to transfer.
1088    */
1089   modifier canTransfer(
1090     uint256 _tokenId
1091   ) {
1092     address tokenOwner = idToOwner[_tokenId];
1093     require(
1094       tokenOwner == msg.sender
1095       || getApproved(_tokenId) == msg.sender
1096       || ownerToOperators[tokenOwner][msg.sender]
1097     );
1098 
1099     _;
1100   }
1101 
1102   /**
1103    * @dev Guarantees that _tokenId is a valid Token.
1104    * @param _tokenId ID of the NFT to validate.
1105    */
1106   modifier validNFToken(
1107     uint256 _tokenId
1108   ) {
1109     require(idToOwner[_tokenId] != address(0));
1110     _;
1111   }
1112 
1113   /**
1114    * @dev Contract constructor.
1115    */
1116   constructor()
1117     public
1118   {
1119     supportedInterfaces[0x80ac58cd] = true; // ERC721
1120   }
1121 
1122   /**
1123    * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
1124    * considered invalid, and this function throws for queries about the zero address.
1125    * @param _owner Address for whom to query the balance.
1126    */
1127   function balanceOf(
1128     address _owner
1129   )
1130     external
1131     view
1132     returns (uint256)
1133   {
1134     require(_owner != address(0));
1135     return ownerToNFTokenCount[_owner];
1136   }
1137 
1138   /**
1139    * @dev Returns the address of the owner of the NFT. NFTs assigned to zero address are considered
1140    * invalid, and queries about them do throw.
1141    * @param _tokenId The identifier for an NFT.
1142    */
1143   function ownerOf(
1144     uint256 _tokenId
1145   )
1146     external
1147     view
1148     returns (address _owner)
1149   {
1150     _owner = idToOwner[_tokenId];
1151     require(_owner != address(0));
1152   }
1153 
1154   /**
1155    * @dev Transfers the ownership of an NFT from one address to another address.
1156    * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
1157    * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
1158    * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
1159    * function checks if `_to` is a smart contract (code size > 0). If so, it calls `onERC721Received`
1160    * on `_to` and throws if the return value is not `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
1161    * @param _from The current owner of the NFT.
1162    * @param _to The new owner.
1163    * @param _tokenId The NFT to transfer.
1164    * @param _data Additional data with no specified format, sent in call to `_to`.
1165    */
1166   function safeTransferFrom(
1167     address _from,
1168     address _to,
1169     uint256 _tokenId,
1170     bytes _data
1171   )
1172     external
1173   {
1174     _safeTransferFrom(_from, _to, _tokenId, _data);
1175   }
1176 
1177   /**
1178    * @dev Transfers the ownership of an NFT from one address to another address.
1179    * @notice This works identically to the other function with an extra data parameter, except this
1180    * function just sets data to ""
1181    * @param _from The current owner of the NFT.
1182    * @param _to The new owner.
1183    * @param _tokenId The NFT to transfer.
1184    */
1185   function safeTransferFrom(
1186     address _from,
1187     address _to,
1188     uint256 _tokenId
1189   )
1190     external
1191   {
1192     _safeTransferFrom(_from, _to, _tokenId, "");
1193   }
1194 
1195   /**
1196    * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
1197    * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
1198    * address. Throws if `_tokenId` is not a valid NFT.
1199    * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
1200    * they maybe be permanently lost.
1201    * @param _from The current owner of the NFT.
1202    * @param _to The new owner.
1203    * @param _tokenId The NFT to transfer.
1204    */
1205   function transferFrom(
1206     address _from,
1207     address _to,
1208     uint256 _tokenId
1209   )
1210     external
1211     canTransfer(_tokenId)
1212     validNFToken(_tokenId)
1213   {
1214     address tokenOwner = idToOwner[_tokenId];
1215     require(tokenOwner == _from);
1216     require(_to != address(0));
1217 
1218     _transfer(_to, _tokenId);
1219   }
1220 
1221   /**
1222    * @dev Set or reaffirm the approved address for an NFT.
1223    * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
1224    * the current NFT owner, or an authorized operator of the current owner.
1225    * @param _approved Address to be approved for the given NFT ID.
1226    * @param _tokenId ID of the token to be approved.
1227    */
1228   function approve(
1229     address _approved,
1230     uint256 _tokenId
1231   )
1232     external
1233     canOperate(_tokenId)
1234     validNFToken(_tokenId)
1235   {
1236     address tokenOwner = idToOwner[_tokenId];
1237     require(_approved != tokenOwner);
1238 
1239     idToApprovals[_tokenId] = _approved;
1240     emit Approval(tokenOwner, _approved, _tokenId);
1241   }
1242 
1243   /**
1244    * @dev Enables or disables approval for a third party ("operator") to manage all of
1245    * `msg.sender`'s assets. It also emits the ApprovalForAll event.
1246    * @notice This works even if sender doesn't own any tokens at the time.
1247    * @param _operator Address to add to the set of authorized operators.
1248    * @param _approved True if the operators is approved, false to revoke approval.
1249    */
1250   function setApprovalForAll(
1251     address _operator,
1252     bool _approved
1253   )
1254     external
1255   {
1256     require(_operator != address(0));
1257     ownerToOperators[msg.sender][_operator] = _approved;
1258     emit ApprovalForAll(msg.sender, _operator, _approved);
1259   }
1260 
1261   /**
1262    * @dev Get the approved address for a single NFT.
1263    * @notice Throws if `_tokenId` is not a valid NFT.
1264    * @param _tokenId ID of the NFT to query the approval of.
1265    */
1266   function getApproved(
1267     uint256 _tokenId
1268   )
1269     public
1270     view
1271     validNFToken(_tokenId)
1272     returns (address)
1273   {
1274     return idToApprovals[_tokenId];
1275   }
1276 
1277   /**
1278    * @dev Checks if `_operator` is an approved operator for `_owner`.
1279    * @param _owner The address that owns the NFTs.
1280    * @param _operator The address that acts on behalf of the owner.
1281    */
1282   function isApprovedForAll(
1283     address _owner,
1284     address _operator
1285   )
1286     external
1287     view
1288     returns (bool)
1289   {
1290     require(_owner != address(0));
1291     require(_operator != address(0));
1292     return ownerToOperators[_owner][_operator];
1293   }
1294 
1295   /**
1296    * @dev Actually perform the safeTransferFrom.
1297    * @param _from The current owner of the NFT.
1298    * @param _to The new owner.
1299    * @param _tokenId The NFT to transfer.
1300    * @param _data Additional data with no specified format, sent in call to `_to`.
1301    */
1302   function _safeTransferFrom(
1303     address _from,
1304     address _to,
1305     uint256 _tokenId,
1306     bytes _data
1307   )
1308     internal
1309     canTransfer(_tokenId)
1310     validNFToken(_tokenId)
1311   {
1312     address tokenOwner = idToOwner[_tokenId];
1313     require(tokenOwner == _from);
1314     require(_to != address(0));
1315 
1316     _transfer(_to, _tokenId);
1317 
1318     if (_to.isContract()) {
1319       bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
1320       require(retval == MAGIC_ON_ERC721_RECEIVED);
1321     }
1322   }
1323 
1324   /**
1325    * @dev Actually preforms the transfer.
1326    * @notice Does NO checks.
1327    * @param _to Address of a new owner.
1328    * @param _tokenId The NFT that is being transferred.
1329    */
1330   function _transfer(
1331     address _to,
1332     uint256 _tokenId
1333   )
1334     private
1335   {
1336     address from = idToOwner[_tokenId];
1337     clearApproval(_tokenId);
1338 
1339     removeNFToken(from, _tokenId);
1340     addNFToken(_to, _tokenId);
1341 
1342     emit Transfer(from, _to, _tokenId);
1343   }
1344    
1345   /**
1346    * @dev Mints a new NFT.
1347    * @notice This is a private function which should be called from user-implemented external
1348    * mint function. Its purpose is to show and properly initialize data structures when using this
1349    * implementation.
1350    * @param _to The address that will own the minted NFT.
1351    * @param _tokenId of the NFT to be minted by the msg.sender.
1352    */
1353   function _mint(
1354     address _to,
1355     uint256 _tokenId
1356   )
1357     internal
1358   {
1359     require(_to != address(0));
1360     require(_tokenId != 0);
1361     require(idToOwner[_tokenId] == address(0));
1362 
1363     addNFToken(_to, _tokenId);
1364 
1365     emit Transfer(address(0), _to, _tokenId);
1366   }
1367 
1368   /**
1369    * @dev Burns a NFT.
1370    * @notice This is a private function which should be called from user-implemented external
1371    * burn function. Its purpose is to show and properly initialize data structures when using this
1372    * implementation.
1373    * @param _owner Address of the NFT owner.
1374    * @param _tokenId ID of the NFT to be burned.
1375    */
1376   function _burn(
1377     address _owner,
1378     uint256 _tokenId
1379   )
1380     validNFToken(_tokenId)
1381     internal
1382   {
1383     clearApproval(_tokenId);
1384     removeNFToken(_owner, _tokenId);
1385     emit Transfer(_owner, address(0), _tokenId);
1386   }
1387 
1388   /** 
1389    * @dev Clears the current approval of a given NFT ID.
1390    * @param _tokenId ID of the NFT to be transferred.
1391    */
1392   function clearApproval(
1393     uint256 _tokenId
1394   )
1395     private
1396   {
1397     if(idToApprovals[_tokenId] != 0)
1398     {
1399       delete idToApprovals[_tokenId];
1400     }
1401   }
1402 
1403   /**
1404    * @dev Removes a NFT from owner.
1405    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
1406    * @param _from Address from wich we want to remove the NFT.
1407    * @param _tokenId Which NFT we want to remove.
1408    */
1409   function removeNFToken(
1410     address _from,
1411     uint256 _tokenId
1412   )
1413    internal
1414   {
1415     require(idToOwner[_tokenId] == _from);
1416     assert(ownerToNFTokenCount[_from] > 0);
1417     ownerToNFTokenCount[_from] = ownerToNFTokenCount[_from].sub(1);
1418     delete idToOwner[_tokenId];
1419   }
1420 
1421   /**
1422    * @dev Assignes a new NFT to owner.
1423    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
1424    * @param _to Address to wich we want to add the NFT.
1425    * @param _tokenId Which NFT we want to add.
1426    */
1427   function addNFToken(
1428     address _to,
1429     uint256 _tokenId
1430   )
1431     internal
1432   {
1433     require(idToOwner[_tokenId] == address(0));
1434 
1435     idToOwner[_tokenId] = _to;
1436     ownerToNFTokenCount[_to] = ownerToNFTokenCount[_to].add(1);
1437   }
1438 
1439 }
1440 
1441 // File: @0xcert/ethereum-erc721/contracts/tokens/NFTokenMetadata.sol
1442 
1443 pragma solidity ^0.4.24;
1444 
1445 
1446 
1447 /**
1448  * @dev Optional metadata implementation for ERC-721 non-fungible token standard.
1449  */
1450 contract NFTokenMetadata is
1451   NFToken,
1452   ERC721Metadata
1453 {
1454 
1455   /**
1456    * @dev A descriptive name for a collection of NFTs.
1457    */
1458   string internal nftName;
1459 
1460   /**
1461    * @dev An abbreviated name for NFTokens.
1462    */
1463   string internal nftSymbol;
1464 
1465   /**
1466    * @dev Mapping from NFT ID to metadata uri.
1467    */
1468   mapping (uint256 => string) internal idToUri;
1469 
1470   /**
1471    * @dev Contract constructor.
1472    * @notice When implementing this contract don't forget to set nftName and nftSymbol.
1473    */
1474   constructor()
1475     public
1476   {
1477     supportedInterfaces[0x5b5e139f] = true; // ERC721Metadata
1478   }
1479 
1480   /**
1481    * @dev Burns a NFT.
1482    * @notice This is a internal function which should be called from user-implemented external
1483    * burn function. Its purpose is to show and properly initialize data structures when using this
1484    * implementation.
1485    * @param _owner Address of the NFT owner.
1486    * @param _tokenId ID of the NFT to be burned.
1487    */
1488   function _burn(
1489     address _owner,
1490     uint256 _tokenId
1491   )
1492     internal
1493   {
1494     super._burn(_owner, _tokenId);
1495 
1496     if (bytes(idToUri[_tokenId]).length != 0) {
1497       delete idToUri[_tokenId];
1498     }
1499   }
1500 
1501   /**
1502    * @dev Set a distinct URI (RFC 3986) for a given NFT ID.
1503    * @notice this is a internal function which should be called from user-implemented external
1504    * function. Its purpose is to show and properly initialize data structures when using this
1505    * implementation.
1506    * @param _tokenId Id for which we want uri.
1507    * @param _uri String representing RFC 3986 URI.
1508    */
1509   function _setTokenUri(
1510     uint256 _tokenId,
1511     string _uri
1512   )
1513     validNFToken(_tokenId)
1514     internal
1515   {
1516     idToUri[_tokenId] = _uri;
1517   }
1518 
1519   /**
1520    * @dev Returns a descriptive name for a collection of NFTokens.
1521    */
1522   function name()
1523     external
1524     view
1525     returns (string _name)
1526   {
1527     _name = nftName;
1528   }
1529 
1530   /**
1531    * @dev Returns an abbreviated name for NFTokens.
1532    */
1533   function symbol()
1534     external
1535     view
1536     returns (string _symbol)
1537   {
1538     _symbol = nftSymbol;
1539   }
1540 
1541   /**
1542    * @dev A distinct URI (RFC 3986) for a given NFT.
1543    * @param _tokenId Id for which we want uri.
1544    */
1545   function tokenURI(
1546     uint256 _tokenId
1547   )
1548     validNFToken(_tokenId)
1549     external
1550     view
1551     returns (string)
1552   {
1553     return idToUri[_tokenId];
1554   }
1555 
1556 }
1557 
1558 // File: @0xcert/ethereum-erc721/contracts/tokens/NFTokenEnumerable.sol
1559 
1560 pragma solidity ^0.4.24;
1561 
1562 
1563 
1564 /**
1565  * @dev Optional enumeration implementation for ERC-721 non-fungible token standard.
1566  */
1567 contract NFTokenEnumerable is
1568   NFToken,
1569   ERC721Enumerable
1570 {
1571 
1572   /**
1573    * @dev Array of all NFT IDs.
1574    */
1575   uint256[] internal tokens;
1576 
1577   /**
1578    * @dev Mapping from token ID its index in global tokens array.
1579    */
1580   mapping(uint256 => uint256) internal idToIndex;
1581 
1582   /**
1583    * @dev Mapping from owner to list of owned NFT IDs.
1584    */
1585   mapping(address => uint256[]) internal ownerToIds;
1586 
1587   /**
1588    * @dev Mapping from NFT ID to its index in the owner tokens list.
1589    */
1590   mapping(uint256 => uint256) internal idToOwnerIndex;
1591 
1592   /**
1593    * @dev Contract constructor.
1594    */
1595   constructor()
1596     public
1597   {
1598     supportedInterfaces[0x780e9d63] = true; // ERC721Enumerable
1599   }
1600 
1601   /**
1602    * @dev Mints a new NFT.
1603    * @notice This is a private function which should be called from user-implemented external
1604    * mint function. Its purpose is to show and properly initialize data structures when using this
1605    * implementation.
1606    * @param _to The address that will own the minted NFT.
1607    * @param _tokenId of the NFT to be minted by the msg.sender.
1608    */
1609   function _mint(
1610     address _to,
1611     uint256 _tokenId
1612   )
1613     internal
1614   {
1615     super._mint(_to, _tokenId);
1616     tokens.push(_tokenId);
1617     idToIndex[_tokenId] = tokens.length.sub(1);
1618   }
1619 
1620   /**
1621    * @dev Burns a NFT.
1622    * @notice This is a private function which should be called from user-implemented external
1623    * burn function. Its purpose is to show and properly initialize data structures when using this
1624    * implementation.
1625    * @param _owner Address of the NFT owner.
1626    * @param _tokenId ID of the NFT to be burned.
1627    */
1628   function _burn(
1629     address _owner,
1630     uint256 _tokenId
1631   )
1632     internal
1633   {
1634     super._burn(_owner, _tokenId);
1635     assert(tokens.length > 0);
1636 
1637     uint256 tokenIndex = idToIndex[_tokenId];
1638     // Sanity check. This could be removed in the future.
1639     assert(tokens[tokenIndex] == _tokenId);
1640     uint256 lastTokenIndex = tokens.length.sub(1);
1641     uint256 lastToken = tokens[lastTokenIndex];
1642 
1643     tokens[tokenIndex] = lastToken;
1644 
1645     tokens.length--;
1646     // Consider adding a conditional check for the last token in order to save GAS.
1647     idToIndex[lastToken] = tokenIndex;
1648     idToIndex[_tokenId] = 0;
1649   }
1650 
1651   /**
1652    * @dev Removes a NFT from an address.
1653    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
1654    * @param _from Address from wich we want to remove the NFT.
1655    * @param _tokenId Which NFT we want to remove.
1656    */
1657   function removeNFToken(
1658     address _from,
1659     uint256 _tokenId
1660   )
1661    internal
1662   {
1663     super.removeNFToken(_from, _tokenId);
1664     assert(ownerToIds[_from].length > 0);
1665 
1666     uint256 tokenToRemoveIndex = idToOwnerIndex[_tokenId];
1667     uint256 lastTokenIndex = ownerToIds[_from].length.sub(1);
1668     uint256 lastToken = ownerToIds[_from][lastTokenIndex];
1669 
1670     ownerToIds[_from][tokenToRemoveIndex] = lastToken;
1671 
1672     ownerToIds[_from].length--;
1673     // Consider adding a conditional check for the last token in order to save GAS.
1674     idToOwnerIndex[lastToken] = tokenToRemoveIndex;
1675     idToOwnerIndex[_tokenId] = 0;
1676   }
1677 
1678   /**
1679    * @dev Assignes a new NFT to an address.
1680    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
1681    * @param _to Address to wich we want to add the NFT.
1682    * @param _tokenId Which NFT we want to add.
1683    */
1684   function addNFToken(
1685     address _to,
1686     uint256 _tokenId
1687   )
1688     internal
1689   {
1690     super.addNFToken(_to, _tokenId);
1691 
1692     uint256 length = ownerToIds[_to].length;
1693     ownerToIds[_to].push(_tokenId);
1694     idToOwnerIndex[_tokenId] = length;
1695   }
1696 
1697   /**
1698    * @dev Returns the count of all existing NFTokens.
1699    */
1700   function totalSupply()
1701     external
1702     view
1703     returns (uint256)
1704   {
1705     return tokens.length;
1706   }
1707 
1708   /**
1709    * @dev Returns NFT ID by its index.
1710    * @param _index A counter less than `totalSupply()`.
1711    */
1712   function tokenByIndex(
1713     uint256 _index
1714   )
1715     external
1716     view
1717     returns (uint256)
1718   {
1719     require(_index < tokens.length);
1720     // Sanity check. This could be removed in the future.
1721     assert(idToIndex[tokens[_index]] == _index);
1722     return tokens[_index];
1723   }
1724 
1725   /**
1726    * @dev returns the n-th NFT ID from a list of owner's tokens.
1727    * @param _owner Token owner's address.
1728    * @param _index Index number representing n-th token in owner's list of tokens.
1729    */
1730   function tokenOfOwnerByIndex(
1731     address _owner,
1732     uint256 _index
1733   )
1734     external
1735     view
1736     returns (uint256)
1737   {
1738     require(_index < ownerToIds[_owner].length);
1739     return ownerToIds[_owner][_index];
1740   }
1741 
1742 }
1743 
1744 // File: contracts/MarbleNFTInterface.sol
1745 
1746 pragma solidity ^0.4.24;
1747 
1748 /**
1749  * @title Marble NFT Interface
1750  * @dev Defines Marbles unique extension of NFT.
1751  * ...It contains methodes returning core properties what describe Marble NFTs and provides management options to create,
1752  * burn NFT or change approvals of it.
1753  */
1754 interface MarbleNFTInterface {
1755 
1756   /**
1757    * @dev Mints Marble NFT.
1758    * @notice This is a external function which should be called just by the owner of contract or any other user who has priviladge of being resposible
1759    * of creating valid Marble NFT. Valid token contains all neccessary information to be able recreate marble card image.
1760    * @param _tokenId The ID of new NFT.
1761    * @param _owner Address of the NFT owner.
1762    * @param _uri Unique URI proccessed by Marble services to be sure it is valid NFTs DNA. Most likely it is URL pointing to some website address.
1763    * @param _metadataUri URI pointing to "ERC721 Metadata JSON Schema"
1764    * @param _tokenId ID of the NFT to be burned.
1765    */
1766   function mint(
1767     uint256 _tokenId,
1768     address _owner,
1769     address _creator,
1770     string _uri,
1771     string _metadataUri,
1772     uint256 _created
1773   )
1774     external;
1775 
1776   /**
1777    * @dev Burns Marble NFT. Should be fired only by address with proper authority as contract owner or etc.
1778    * @param _tokenId ID of the NFT to be burned.
1779    */
1780   function burn(
1781     uint256 _tokenId
1782   )
1783     external;
1784 
1785   /**
1786    * @dev Allowes to change approval for change of ownership even when sender is not NFT holder. Sender has to have special role granted by contract to use this tool.
1787    * @notice Careful with this!!!! :))
1788    * @param _tokenId ID of the NFT to be updated.
1789    * @param _approved ETH address what supposed to gain approval to take ownership of NFT.
1790    */
1791   function forceApproval(
1792     uint256 _tokenId,
1793     address _approved
1794   )
1795     external;
1796 
1797   /**
1798    * @dev Returns properties used for generating NFT metadata image (a.k.a. card).
1799    * @param _tokenId ID of the NFT.
1800    */
1801   function tokenSource(uint256 _tokenId)
1802     external
1803     view
1804     returns (
1805       string uri,
1806       address creator,
1807       uint256 created
1808     );
1809 
1810   /**
1811    * @dev Returns ID of NFT what matches provided source URI.
1812    * @param _uri URI of source website.
1813    */
1814   function tokenBySourceUri(string _uri)
1815     external
1816     view
1817     returns (uint256 tokenId);
1818 
1819   /**
1820    * @dev Returns all properties of Marble NFT. Lets call it Marble NFT Model with properties described below:
1821    * @param _tokenId ID  of NFT
1822    * Returned model:
1823    * uint256 id ID of NFT
1824    * string uri  URI of source website. Website is used to mine data to crate NFT metadata image.
1825    * string metadataUri URI to NFT metadata assets. In our case to our websevice providing JSON with additional information based on "ERC721 Metadata JSON Schema".
1826    * address owner NFT owner address.
1827    * address creator Address of creator of this NFT. It means that this addres placed sourceURI to candidate contract.
1828    * uint256 created Date and time of creation of NFT candidate.
1829    *
1830    * (id, uri, metadataUri, owner, creator, created)
1831    */
1832   function getNFT(uint256 _tokenId)
1833     external
1834     view
1835     returns(
1836       uint256 id,
1837       string uri,
1838       string metadataUri,
1839       address owner,
1840       address creator,
1841       uint256 created
1842     );
1843 
1844 
1845     /**
1846      * @dev Transforms URI to hash.
1847      * @param _uri URI to be transformed to hash.
1848      */
1849     function getSourceUriHash(string _uri)
1850       external
1851       view
1852       returns(uint256 hash);
1853 }
1854 
1855 // File: contracts/MarbleNFT.sol
1856 
1857 pragma solidity ^0.4.24;
1858 
1859 
1860 
1861 
1862 
1863 /**
1864  * @title MARBLE NFT CONTRACT
1865  * @notice We omit a fallback function to prevent accidental sends to this contract.
1866  */
1867 contract MarbleNFT is
1868   Adminable,
1869   NFTokenMetadata,
1870   NFTokenEnumerable,
1871   MarbleNFTInterface
1872 {
1873 
1874   /*
1875    * @dev structure storing additional information about created NFT
1876    * uri: URI used as source/key/representation of NFT, it can be considered as tokens DNA
1877    * creator:  address of candidate creator - a.k.a. address of person who initialy provided source URI
1878    * created: date of NFT creation
1879    */
1880   struct MarbleNFTSource {
1881 
1882     // URI used as source/key of NFT, we can consider it as tokens DNA
1883     string uri;
1884 
1885     // address of candidate creator - a.k.a. address of person who initialy provided source URI
1886     address creator;
1887 
1888     // date of NFT creation
1889     uint256 created;
1890   }
1891 
1892   /**
1893    * @dev Mapping from NFT ID to marble NFT source.
1894    */
1895   mapping (uint256 => MarbleNFTSource) public idToMarbleNFTSource;
1896   /**
1897    * @dev Mapping from marble NFT source uri hash TO NFT ID .
1898    */
1899   mapping (uint256 => uint256) public sourceUriHashToId;
1900 
1901   constructor()
1902     public
1903   {
1904     nftName = "MARBLE-NFT";
1905     nftSymbol = "MRBLNFT";
1906   }
1907 
1908   /**
1909    * @dev Mints a new NFT.
1910    * @param _tokenId The unique number representing NFT
1911    * @param _owner Holder of Marble NFT
1912    * @param _creator Creator of Marble NFT
1913    * @param _uri URI representing NFT
1914    * @param _metadataUri URI pointing to "ERC721 Metadata JSON Schema"
1915    * @param _created date of creation of NFT candidate
1916    */
1917   function mint(
1918     uint256 _tokenId,
1919     address _owner,
1920     address _creator,
1921     string _uri,
1922     string _metadataUri,
1923     uint256 _created
1924   )
1925     external
1926     onlyAdmin
1927   {
1928     uint256 uriHash = _getSourceUriHash(_uri);
1929 
1930     require(uriHash != _getSourceUriHash(""), "NFT URI can not be empty!");
1931     require(sourceUriHashToId[uriHash] == 0, "NFT with same URI already exists!");
1932 
1933     _mint(_owner, _tokenId);
1934     _setTokenUri(_tokenId, _metadataUri);
1935 
1936     idToMarbleNFTSource[_tokenId] = MarbleNFTSource(_uri, _creator, _created);
1937     sourceUriHashToId[uriHash] = _tokenId;
1938   }
1939 
1940   /**
1941    * @dev Burns NFT. Sadly, trully.. ...probably someone marbled something ugly!!!! :)
1942    * @param _tokenId ID of ugly NFT
1943    */
1944   function burn(
1945     uint256 _tokenId
1946   )
1947     external
1948     onlyAdmin
1949   {
1950     address owner = idToOwner[_tokenId];
1951 
1952     MarbleNFTSource memory marbleNFTSource = idToMarbleNFTSource[_tokenId];
1953 
1954     if (bytes(marbleNFTSource.uri).length != 0) {
1955       uint256 uriHash = _getSourceUriHash(marbleNFTSource.uri);
1956       delete sourceUriHashToId[uriHash];
1957       delete idToMarbleNFTSource[_tokenId];
1958     }
1959 
1960     _burn(owner, _tokenId);
1961   }
1962 
1963   /**
1964    * @dev Tool to manage misstreated NFTs or to be able to extend our services for new cool stuff like auctions, weird games and so on......
1965    * @param _tokenId ID of the NFT to be update.
1966    * @param _approved Address to replace current approved address on NFT
1967    */
1968   function forceApproval(
1969     uint256 _tokenId,
1970     address _approved
1971   )
1972     external
1973     onlyAdmin
1974   {
1975     address tokenOwner = idToOwner[_tokenId];
1976     require(_approved != tokenOwner,"Owner can not be become new owner!");
1977 
1978     idToApprovals[_tokenId] = _approved;
1979     emit Approval(tokenOwner, _approved, _tokenId);
1980   }
1981 
1982   /**
1983    * @dev Returns model of Marble NFT source properties
1984    * @param _tokenId ID of the NFT
1985    */
1986   function tokenSource(uint256 _tokenId)
1987     external
1988     view
1989     returns (
1990       string uri,
1991       address creator,
1992       uint256 created)
1993   {
1994     MarbleNFTSource memory marbleNFTSource = idToMarbleNFTSource[_tokenId];
1995     return (marbleNFTSource.uri, marbleNFTSource.creator, marbleNFTSource.created);
1996   }
1997 
1998   /**
1999    * @dev Returns token ID related to provided source uri
2000    * @param _uri URI representing created NFT
2001    */
2002   function tokenBySourceUri(string _uri)
2003     external
2004     view
2005     returns (uint256 tokenId)
2006   {
2007     return sourceUriHashToId[_getSourceUriHash(_uri)];
2008   }
2009 
2010   /**
2011    * @dev Returns whole Marble NFT model
2012    * --------------------
2013    *   MARBLE NFT MODEL
2014    * --------------------
2015    * uint256 id NFT unique identification
2016    * string uri NFT source URI, source is whole site what was proccessed by marble to create this NFT, it is URI representation of NFT (call it DNA)
2017    * string metadataUri  URI pointint to token NFT metadata shcema
2018    * address owner Current NFT owner
2019    * address creator First NFT owner
2020    * uint256 created Date of NFT candidate creation
2021    *
2022    * (id, uri, metadataUri, owner, creator, created)
2023    */
2024   function getNFT(uint256 _tokenId)
2025     external
2026     view
2027     returns(
2028       uint256 id,
2029       string uri,
2030       string metadataUri,
2031       address owner,
2032       address creator,
2033       uint256 created
2034     )
2035   {
2036 
2037     MarbleNFTSource memory marbleNFTSource = idToMarbleNFTSource[_tokenId];
2038 
2039     return (
2040       _tokenId,
2041       marbleNFTSource.uri,
2042       idToUri[_tokenId],
2043       idToOwner[_tokenId],
2044       marbleNFTSource.creator,
2045       marbleNFTSource.created);
2046   }
2047 
2048 
2049   /**
2050    * @dev Transforms URI to hash.
2051    * @param _uri URI to be transformed to hash.
2052    */
2053   function getSourceUriHash(string _uri)
2054      external
2055      view
2056      returns(uint256 hash)
2057   {
2058      return _getSourceUriHash(_uri);
2059   }
2060 
2061   /**
2062    * @dev Transforms URI to hash.
2063    * @param _uri URI to be transformed to hash.
2064    */
2065   function _getSourceUriHash(string _uri)
2066     internal
2067     pure
2068     returns(uint256 hash)
2069   {
2070     return uint256(keccak256(abi.encodePacked(_uri)));
2071   }
2072 }
2073 
2074 // File: contracts/MarbleNFTFactory.sol
2075 
2076 pragma solidity ^0.4.24;
2077 
2078 
2079 
2080 
2081 
2082 
2083 
2084 
2085 
2086 
2087 
2088 /**
2089  * @title Marble NFT Factory
2090  * @dev Covers all parts of creating new NFT token. Contains references to all involved contracts and giving possibility of burning NFT corretly.
2091  */
2092 contract MarbleNFTFactory is
2093   Adminable,
2094   Pausable,
2095   SupportsInterface
2096 {
2097 
2098   using SafeMath for uint256;
2099 
2100   MarbleNFT public marbleNFTContract;
2101   MarbleNFTCandidateInterface public marbleNFTCandidateContract;
2102   MarbleDutchAuctionInterface public marbleDutchAuctionContract;
2103 
2104   /**
2105    * @dev property holding last created NFT ID
2106    * - it's  separeted from Marble NFT contract in case that we will want to change NFT id strategy in the future. Currently no idea why we would do it! :)
2107    */
2108   uint256 public lastMintedNFTId;
2109 
2110   constructor(uint256 _lastMintedNFTId)
2111     public
2112   {
2113     lastMintedNFTId = _lastMintedNFTId;
2114   }
2115 
2116   /**
2117    * @dev Emits when new marble when is minted
2118    */
2119   event MarbleNFTCreated(
2120     address indexed _creator,
2121     uint256 indexed _tokenId
2122   );
2123 
2124   /**
2125    * @dev Emits when new marble is minted
2126    */
2127   event MarbleNFTBurned(
2128     uint256 indexed _tokenId,
2129     address indexed _owner,
2130     address indexed _creator
2131   );
2132 
2133 
2134   /**
2135    * @dev Creates Marble NFT from Candidate and returns NFTs owner. Was created, bc of deep stack error over mint function.
2136    * @param _id ID of Marble NFT
2137    * @param _uri URI determining Marble NFT, lets say this is our DNA...
2138    * @param _metadataUri URI pointing to "ERC721 Metadata JSON Schema"
2139    * @param _candidateUri URI initially provided to user for purposes of creation Marble NFT
2140    */
2141   function _mint(
2142     uint256 _id,
2143     string _uri,
2144     string _metadataUri,
2145     string _candidateUri
2146   )
2147     internal
2148     returns (address owner)
2149   {
2150     require(marbleNFTCandidateContract.isCandidate(_candidateUri), "There is no candidate with this URL!!");
2151     uint256 created;
2152 
2153     (, owner, , , created) = marbleNFTCandidateContract.getCandidate(_candidateUri);
2154 
2155     marbleNFTContract.mint(
2156       _id,
2157       owner,
2158       owner,
2159       _uri,
2160       _metadataUri,
2161       now
2162     );
2163   }
2164 
2165   /**
2166    * @dev Sets new last minted ID, !! use careful
2167    * @param _lastMintedNFTId New value of last mineted NFT
2168    */
2169   function setLastMintedNFTId(uint256 _lastMintedNFTId)
2170      external
2171      onlyOwner
2172      whenPaused
2173   {
2174       lastMintedNFTId = _lastMintedNFTId;
2175   }
2176 
2177   /**
2178    * @dev Sets auction contract
2179    * @param _address Contract address
2180    */
2181   function setMarbleDutchAuctionContract(address _address)
2182      external
2183      onlyAdmin
2184      whenNotPaused
2185   {
2186       marbleDutchAuctionContract = MarbleDutchAuctionInterface(_address);
2187   }
2188 
2189   /**
2190    * @dev Sets Marble NFT contract
2191    * @param _address Contract address
2192    */
2193   function setNFTContract(address _address)
2194      external
2195      onlyAdmin
2196      whenNotPaused
2197   {
2198       marbleNFTContract = MarbleNFT(_address);
2199   }
2200 
2201   /**
2202    * @dev Sets Candidate contract
2203    * @param _address Contract address
2204    */
2205   function setCandidateContract(address _address)
2206     external
2207     onlyAdmin
2208     whenNotPaused
2209   {
2210      marbleNFTCandidateContract = MarbleNFTCandidateInterface(_address);
2211   }
2212 
2213   /**
2214    * @dev Creates Marble NFT. Then place it over auction in special fashion and remove candidate entry.
2215    * NOTE: we are not removing candidates, should we or should we not??
2216    * @param _uri URI determining Marble NFT, lets say this is our DNA...
2217    * @param _metadataUri URI pointing to "ERC721 Metadata JSON Schema"
2218    * @param _candidateUri URI initially provided to user for purposes of creation Marble NFT
2219    * @param _auctionStartingPrice Starting price of auction.
2220    * @param _auctionMinimalPrice Ending price of auction.
2221    * @param _auctionDuration Duration (in seconds) of auction when price is moving, lets say, it determines dynamic part of auction price creation.
2222    */
2223   function mint(
2224     string _uri,
2225     string _metadataUri,
2226     string _candidateUri,
2227     uint256 _auctionStartingPrice,
2228     uint256 _auctionMinimalPrice,
2229     uint256 _auctionDuration
2230   )
2231     external
2232     onlyAdmin
2233     whenNotPaused
2234   {
2235     uint256 id = lastMintedNFTId.add(1);
2236 
2237     address owner = _mint(
2238       id,
2239       _uri,
2240       _metadataUri,
2241       _candidateUri
2242     );
2243 
2244     marbleDutchAuctionContract.createMintingAuction(
2245       id,
2246       _auctionStartingPrice,
2247       _auctionMinimalPrice,
2248       _auctionDuration,
2249       owner
2250     );
2251 
2252     lastMintedNFTId = id;
2253 
2254     emit MarbleNFTCreated(owner, id);
2255   }
2256 
2257   /**
2258    * @dev Creates Marble NFT. Then place it over auction in special fashion and remove candidate entry......hmm removing of candidate is not important and we can remove it from the minting process.
2259    * NOTE: !! rather careful with this stuff, it burns
2260    * @param _tokenId Id of Marble NFT to burn
2261    */
2262   function burn(
2263     uint256 _tokenId
2264   )
2265     external
2266     onlyAdmin
2267     whenNotPaused
2268   {
2269 
2270     require(marbleNFTContract.ownerOf(_tokenId) != address(0) , "Marble NFT doesnt not exists!");
2271     address owner;
2272     address creator;
2273 
2274     // get some info about NFT to tell the world whos NFT we are burning!!
2275     (, , , owner, creator, ) = marbleNFTContract.getNFT(_tokenId);
2276 
2277     Pausable auctionContractToBePaused = Pausable(address(marbleDutchAuctionContract));
2278 
2279     // If NFT is on our auction contract, we have to remove it first
2280     if (marbleDutchAuctionContract.isOnAuction(_tokenId)) {
2281       require(auctionContractToBePaused.paused(), "Auction contract has to be paused!");
2282       marbleDutchAuctionContract.removeAuction(_tokenId);
2283     }
2284 
2285     // burn NFT
2286     marbleNFTContract.burn(_tokenId);
2287 
2288     // Let's everyone to know that we burn things....! :)
2289     emit MarbleNFTBurned(_tokenId, owner, creator);
2290   }
2291 }