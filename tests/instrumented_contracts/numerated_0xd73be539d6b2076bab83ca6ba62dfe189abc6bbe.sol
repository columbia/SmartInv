1 pragma solidity ^0.4.20;
2 
3 /// BlockchainCuties: Collectible and breedable cuties on the Ethereum blockchain.
4 /// https://blockchaincuties.co/
5 
6 
7 /// @title defined the interface that will be referenced in main Cutie contract
8 contract GeneMixerInterface {
9     /// @dev simply a boolean to indicate this is the contract we expect to be
10     function isGeneMixer() external pure returns (bool);
11 
12     /// @dev given genes of cutie 1 & 2, return a genetic combination - may have a random factor
13     /// @param genes1 genes of mom
14     /// @param genes2 genes of dad
15     /// @return the genes that are supposed to be passed down the child
16     function mixGenes(uint256 genes1, uint256 genes2) public view returns (uint256);
17 
18     function canBreed(uint40 momId, uint256 genes1, uint40 dadId, uint256 genes2) public view returns (bool);
19 }
20 
21 
22 
23 /// @author https://BlockChainArchitect.iocontract Bank is CutiePluginBase
24 contract PluginInterface
25 {
26     /// @dev simply a boolean to indicate this is the contract we expect to be
27     function isPluginInterface() public pure returns (bool);
28 
29     function onRemove() public;
30 
31     /// @dev Begins new feature.
32     /// @param _cutieId - ID of token to auction, sender must be owner.
33     /// @param _parameter - arbitrary parameter
34     /// @param _seller - Old owner, if not the message sender
35     function run(
36         uint40 _cutieId,
37         uint256 _parameter,
38         address _seller
39     ) 
40     public
41     payable;
42 
43     /// @dev Begins new feature, approved and signed by COO.
44     /// @param _cutieId - ID of token to auction, sender must be owner.
45     /// @param _parameter - arbitrary parameter
46     function runSigned(
47         uint40 _cutieId,
48         uint256 _parameter,
49         address _owner
50     )
51     external
52     payable;
53 
54     function withdraw() public;
55 }
56 
57 
58 
59 /// @title Auction Market for Blockchain Cuties.
60 /// @author https://BlockChainArchitect.io
61 contract MarketInterface 
62 {
63     function withdrawEthFromBalance() external;    
64 
65     function createAuction(uint40 _cutieId, uint128 _startPrice, uint128 _endPrice, uint40 _duration, address _seller) public payable;
66 
67     function bid(uint40 _cutieId) public payable;
68 
69     function cancelActiveAuctionWhenPaused(uint40 _cutieId) public;
70 
71 	function getAuctionInfo(uint40 _cutieId)
72         public
73         view
74         returns
75     (
76         address seller,
77         uint128 startPrice,
78         uint128 endPrice,
79         uint40 duration,
80         uint40 startedAt,
81         uint128 featuringFee
82     );
83 }
84 
85 
86 
87 /// @title BlockchainCuties: Collectible and breedable cuties on the Ethereum blockchain.
88 /// @author https://BlockChainArchitect.io
89 /// @dev This is the BlockchainCuties configuration. It can be changed redeploying another version.
90 contract ConfigInterface
91 {
92     function isConfig() public pure returns (bool);
93 
94     function getCooldownIndexFromGeneration(uint16 _generation) public view returns (uint16);
95     
96     function getCooldownEndTimeFromIndex(uint16 _cooldownIndex) public view returns (uint40);
97 
98     function getCooldownIndexCount() public view returns (uint256);
99     
100     function getBabyGen(uint16 _momGen, uint16 _dadGen) public pure returns (uint16);
101 
102     function getTutorialBabyGen(uint16 _dadGen) public pure returns (uint16);
103 
104     function getBreedingFee(uint40 _momId, uint40 _dadId) public pure returns (uint256);
105 }
106 
107 
108 
109 /// @dev Note: the ERC-165 identifier for this interface is 0xf0b9e5ba
110 interface ERC721TokenReceiver {
111     /// @notice Handle the receipt of an NFT
112     /// @dev The ERC721 smart contract calls this function on the recipient
113     ///  after a `transfer`. This function MAY throw to revert and reject the
114     ///  transfer. This function MUST use 50,000 gas or less. Return of other
115     ///  than the magic value MUST result in the transaction being reverted.
116     ///  Note: the contract address is always the message sender.
117     /// @param _from The sending address 
118     /// @param _tokenId The NFT identifier which is being transfered
119     /// @param data Additional data with no specified format
120     /// @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
121     ///  unless throwing
122     function onERC721Received(address _from, uint256 _tokenId, bytes data) external returns(bytes4);
123 }
124 
125 
126 /// @title BlockchainCuties: Collectible and breedable cuties on the Ethereum blockchain.
127 /// @author https://BlockChainArchitect.io
128 /// @dev This is the main BlockchainCuties contract. For separated logical sections the code is divided in 
129 // several separately-instantiated sibling contracts that handle auctions and the genetic combination algorithm. 
130 // By keeping auctions separate it is possible to upgrade them without disrupting the main contract that tracks
131 // the ownership of the cutie. The genetic combination algorithm is kept separate so that all of the rest of the 
132 // code can be open-sourced.
133 // The contracts:
134 //
135 //      - BlockchainCuties: The fundamental code, including main data storage, constants and data types, as well as
136 //             internal functions for managing these items ans ERC-721 implementation.
137 //             Various addresses and constraints for operations can be executed only by specific roles - 
138 //             Owner, Operator and Parties.
139 //             Methods for interacting with additional features (Plugins).
140 //             The methods for breeding and keeping track of breeding offers, relies on external genetic combination 
141 //             contract.
142 //             Public methods for auctioning or bidding or breeding. 
143 //
144 //      - SaleMarket and BreedingMarket: The actual auction functionality is handled in two sibling contracts - one
145 //             for sales and one for breeding. Auction creation and bidding is mostly mediated through this side of 
146 //             the core contract.
147 //
148 //      - Effects: Contracts allow to use item effects on cuties, implemented as plugins. Items are not stored in 
149 //             blockchain to not overload Ethereum network. Operator generates signatures, and Plugins check it
150 //             and perform effect.
151 //
152 //      - ItemMarket: Plugin contract used to transfer money from buyer to seller.
153 //
154 //      - Bank: Plugin contract used to receive payments for payed features.
155 
156 contract BlockchainCutiesCore /*is ERC721, CutieCoreInterface*/
157 {
158     /// @notice A descriptive name for a collection of NFTs in this contract
159     function name() external pure returns (string _name) 
160     {
161         return "BlockchainCuties"; 
162     }
163 
164     /// @notice An abbreviated name for NFTs in this contract
165     function symbol() external pure returns (string _symbol)
166     {
167         return "BC";
168     }
169     
170     /// @notice Query if a contract implements an interface
171     /// @param interfaceID The interface identifier, as specified in ERC-165
172     /// @dev Interface identification is specified in ERC-165. This function
173     ///  uses less than 30,000 gas.
174     /// @return `true` if the contract implements `interfaceID` and
175     ///  `interfaceID` is not 0xffffffff, `false` otherwise
176     function supportsInterface(bytes4 interfaceID) external pure returns (bool)
177     {
178         return
179             interfaceID == 0x6466353c || 
180             interfaceID == bytes4(keccak256('supportsInterface(bytes4)'));
181     }
182 
183     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
184     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
185     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
186 
187     /// @dev The Birth event is fired as soon as a new cutie is created. This
188     ///  is any time a cutie comes into existence through the giveBirth method, as well as
189     ///  when a new gen0 cutie is created.
190     event Birth(address indexed owner, uint40 cutieId, uint40 momId, uint40 dadId, uint256 genes);
191 
192     /// @dev This struct represents a blockchain Cutie. It was ensured that struct fits well into
193     ///  exactly two 256-bit words. The order of the members in this structure
194     ///  matters because of the Ethereum byte-packing rules.
195     ///  Reference: http://solidity.readthedocs.io/en/develop/miscellaneous.html
196     struct Cutie
197     {
198         // The Cutie's genetic code is in these 256-bits. Cutie's genes never change.
199         uint256 genes;
200 
201         // The timestamp from the block when this cutie was created.
202         uint40 birthTime;
203 
204         // The minimum timestamp after which the cutie can start breeding
205         // again.
206         uint40 cooldownEndTime;
207 
208         // The cutie's parents ID is set to 0 for gen0 cuties.
209         // Because of using 32-bit unsigned integers the limit is 4 billion cuties. 
210         // Current Ethereum annual limit is about 500 million transactions.
211         uint40 momId;
212         uint40 dadId;
213 
214         // Set the index in the cooldown array (see below) that means
215         // the current cooldown duration for this Cutie. Starts at 0
216         // for gen0 cats, and is initialized to floor(generation/2) for others.
217         // Incremented by one for each successful breeding, regardless
218         // of being cutie mom or cutie dad.
219         uint16 cooldownIndex;
220 
221         // The "generation number" of the cutie. Cutioes minted by the contract
222         // for sale are called "gen0" with generation number of 0. All other cuties' 
223         // generation number is the larger of their parents' two generation
224         // numbers, plus one (i.e. max(mom.generation, dad.generation) + 1)
225         uint16 generation;
226 
227         // Some optional data used by external contracts
228         // Cutie struct is 2x256 bits long.
229         uint64 optional;
230     }
231 
232     /// @dev An array containing the Cutie struct for all Cuties in existence. The ID
233     ///  of each cutie is actually an index into this array. ID 0 is the parent 
234     /// of all generation 0 cats, and both parents to itself. It is an invalid genetic code.
235     Cutie[] public cuties;
236 
237     /// @dev A mapping from cutie IDs to the address that owns them. All cuties have
238     ///  some valid owner address, even gen0 cuties are created with a non-zero owner.
239     mapping (uint40 => address) public cutieIndexToOwner;
240 
241     // @dev A mapping from owner address to count of tokens that address owns.
242     //  Used internally inside balanceOf() to resolve ownership count.
243     mapping (address => uint256) ownershipTokenCount;
244 
245     /// @dev A mapping from CutieIDs to an address that has been approved to call
246     ///  transferFrom(). A Cutie can have one approved address for transfer
247     ///  at any time. A zero value means that there is no outstanding approval.
248     mapping (uint40 => address) public cutieIndexToApproved;
249 
250     /// @dev A mapping from CutieIDs to an address that has been approved to use
251     ///  this Cutie for breeding via breedWith(). A Cutie can have one approved
252     ///  address for breeding at any time. A zero value means that there is no outstanding approval.
253     mapping (uint40 => address) public sireAllowedToAddress;
254 
255 
256     /// @dev The address of the Market contract used to sell cuties. This
257     ///  contract used both peer-to-peer sales and the gen0 sales that are
258     ///  initiated each 15 minutes.
259     MarketInterface public saleMarket;
260 
261     /// @dev The address of a custom Market subclassed contract used for breeding
262     ///  auctions. Is to be separated from saleMarket as the actions taken on success
263     ///  after a sales and breeding auction are quite different.
264     MarketInterface public breedingMarket;
265 
266 
267     // Modifiers to check that inputs can be safely stored with a certain
268     // number of bits.
269     modifier canBeStoredIn40Bits(uint256 _value) {
270         require(_value <= 0xFFFFFFFFFF);
271         _;
272     }    
273 
274     /// @notice Returns the total number of Cuties in existence.
275     /// @dev Required for ERC-721 compliance.
276     function totalSupply() external view returns (uint256)
277     {
278         return cuties.length - 1;
279     }
280 
281     /// @notice Returns the total number of Cuties in existence.
282     /// @dev Required for ERC-721 compliance.
283     function _totalSupply() internal view returns (uint256)
284     {
285         return cuties.length - 1;
286     }
287     
288     // Internal utility functions assume that their input arguments
289     // are valid. Public methods sanitize their inputs and follow
290     // the required logic.
291 
292     /// @dev Checks if a given address is the current owner of a certain Cutie.
293     /// @param _claimant the address we are validating against.
294     /// @param _cutieId cutie id, only valid when > 0
295     function _isOwner(address _claimant, uint40 _cutieId) internal view returns (bool)
296     {
297         return cutieIndexToOwner[_cutieId] == _claimant;
298     }
299 
300     /// @dev Checks if a given address currently has transferApproval for a certain Cutie.
301     /// @param _claimant the address we are confirming the cutie is approved for.
302     /// @param _cutieId cutie id, only valid when > 0
303     function _approvedFor(address _claimant, uint40 _cutieId) internal view returns (bool)
304     {
305         return cutieIndexToApproved[_cutieId] == _claimant;
306     }
307 
308     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
309     ///  approval. Setting _approved to address(0) clears all transfer approval.
310     ///  NOTE: _approve() does NOT send the Approval event. This is done on purpose:
311     ///  _approve() and transferFrom() are used together for putting Cuties on auction. 
312     ///  There is no value in spamming the log with Approval events in that case.
313     function _approve(uint40 _cutieId, address _approved) internal
314     {
315         cutieIndexToApproved[_cutieId] = _approved;
316     }
317 
318     /// @notice Returns the number of Cuties owned by a specific address.
319     /// @param _owner The owner address to check.
320     /// @dev Required for ERC-721 compliance
321     function balanceOf(address _owner) external view returns (uint256 count)
322     {
323         return ownershipTokenCount[_owner];
324     }
325 
326     /// @notice Transfers a Cutie to another address. When transferring to a smart
327     ///  contract, ensure that it is aware of ERC-721 (or
328     ///  BlockchainCuties specifically), otherwise the Cutie may be lost forever.
329     /// @param _to The address of the recipient, can be a user or contract.
330     /// @param _cutieId The ID of the Cutie to transfer.
331     /// @dev Required for ERC-721 compliance.
332     function transfer(address _to, uint256 _cutieId) external whenNotPaused canBeStoredIn40Bits(_cutieId)
333     {
334         // You can only send your own cutie.
335         require(_isOwner(msg.sender, uint40(_cutieId)));
336 
337         // Reassign ownership, clear pending approvals, emit Transfer event.
338         _transfer(msg.sender, _to, uint40(_cutieId));
339     }
340 
341     /// @notice Grant another address the right to transfer a perticular Cutie via transferFrom().
342     /// This flow is preferred for transferring NFTs to contracts.
343     /// @param _to The address to be granted transfer approval. Pass address(0) to clear all approvals.
344     /// @param _cutieId The ID of the Cutie that can be transferred if this call succeeds.
345     /// @dev Required for ERC-721 compliance.
346     function approve(address _to, uint256 _cutieId) external whenNotPaused canBeStoredIn40Bits(_cutieId)
347     {
348         // Only cutie's owner can grant transfer approval.
349         require(_isOwner(msg.sender, uint40(_cutieId)));
350 
351         // Registering approval replaces any previous approval.
352         _approve(uint40(_cutieId), _to);
353 
354         // Emit approval event.
355         emit Approval(msg.sender, _to, _cutieId);
356     }
357 
358     /// @notice Transfers the ownership of an NFT from one address to another address.
359     /// @dev Throws unless `msg.sender` is the current owner, an authorized
360     ///  operator, or the approved address for this NFT. Throws if `_from` is
361     ///  not the current owner. Throws if `_to` is the zero address. Throws if
362     ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
363     ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
364     ///  `onERC721Received` on `_to` and throws if the return value is not
365     ///  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
366     /// @param _from The current owner of the NFT
367     /// @param _to The new owner
368     /// @param _tokenId The NFT to transfer
369     /// @param data Additional data with no specified format, sent in call to `_to`
370     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) 
371         external whenNotPaused canBeStoredIn40Bits(_tokenId)
372     {
373         require(_to != address(0));
374         require(_to != address(this));
375         require(_to != address(saleMarket));
376         require(_to != address(breedingMarket));
377        
378         // Check for approval and valid ownership
379         require(_approvedFor(msg.sender, uint40(_tokenId)) || _isApprovedForAll(_from, msg.sender));
380         require(_isOwner(_from, uint40(_tokenId)));
381 
382         // Reassign ownership, clearing pending approvals and emitting Transfer event.
383         _transfer(_from, _to, uint40(_tokenId));
384         ERC721TokenReceiver (_to).onERC721Received(_from, _tokenId, data);
385     }
386 
387     /// @notice Transfers the ownership of an NFT from one address to another address
388     /// @dev This works identically to the other function with an extra data parameter,
389     ///  except this function just sets data to ""
390     /// @param _from The current owner of the NFT
391     /// @param _to The new owner
392     /// @param _tokenId The NFT to transfer
393     function safeTransferFrom(address _from, address _to, uint256 _tokenId) 
394         external whenNotPaused canBeStoredIn40Bits(_tokenId)
395     {
396         require(_to != address(0));
397         require(_to != address(this));
398         require(_to != address(saleMarket));
399         require(_to != address(breedingMarket));
400        
401         // Check for approval and valid ownership
402         require(_approvedFor(msg.sender, uint40(_tokenId)) || _isApprovedForAll(_from, msg.sender));
403         require(_isOwner(_from, uint40(_tokenId)));
404 
405         // Reassign ownership, clearing pending approvals and emitting Transfer event.
406         _transfer(_from, _to, uint40(_tokenId));
407     }
408 
409     /// @notice Transfer a Cutie owned by another address, for which the calling address
410     ///  has been granted transfer approval by the owner.
411     /// @param _from The address that owns the Cutie to be transfered.
412     /// @param _to Any address, including the caller address, can take ownership of the Cutie.
413     /// @param _tokenId The ID of the Cutie to be transferred.
414     /// @dev Required for ERC-721 compliance.
415     function transferFrom(address _from, address _to, uint256 _tokenId) 
416         external whenNotPaused canBeStoredIn40Bits(_tokenId) 
417     {
418         // Check for approval and valid ownership
419         require(_approvedFor(msg.sender, uint40(_tokenId)) || _isApprovedForAll(_from, msg.sender));
420         require(_isOwner(_from, uint40(_tokenId)));
421 
422         // Reassign ownership, clearing pending approvals and emitting Transfer event.
423         _transfer(_from, _to, uint40(_tokenId));
424     }
425 
426     /// @notice Returns the address currently assigned ownership of a given Cutie.
427     /// @dev Required for ERC-721 compliance.
428     function ownerOf(uint256 _cutieId)
429         external
430         view
431         canBeStoredIn40Bits(_cutieId)
432         returns (address owner)
433     {
434         owner = cutieIndexToOwner[uint40(_cutieId)];
435 
436         require(owner != address(0));
437     }
438 
439     /// @notice Returns the nth Cutie assigned to an address, with n specified by the
440     ///  _index argument.
441     /// @param _owner The owner of the Cuties we are interested in.
442     /// @param _index The zero-based index of the cutie within the owner's list of cuties.
443     ///  Must be less than balanceOf(_owner).
444     /// @dev This method must not be called by smart contract code. It will almost
445     ///  certainly blow past the block gas limit once there are a large number of
446     ///  Cuties in existence. Exists only to allow off-chain queries of ownership.
447     ///  Optional method for ERC-721.
448     function tokenOfOwnerByIndex(address _owner, uint256 _index)
449         external
450         view
451         returns (uint256 cutieId)
452     {
453         uint40 count = 0;
454         for (uint40 i = 1; i <= _totalSupply(); ++i) {
455             if (cutieIndexToOwner[i] == _owner) {
456                 if (count == _index) {
457                     return i;
458                 } else {
459                     count++;
460                 }
461             }
462         }
463         revert();
464     }
465 
466     /// @notice Enumerate valid NFTs
467     /// @dev Throws if `_index` >= `totalSupply()`.
468     /// @param _index A counter less than `totalSupply()`
469     /// @return The token identifier for the `_index`th NFT,
470     ///  (sort order not specified)
471     function tokenByIndex(uint256 _index) external pure returns (uint256)
472     {
473         return _index;
474     }
475 
476     /// @dev A mapping from Cuties owner (account) to an address that has been approved to call
477     ///  transferFrom() for all cuties, owned by owner.
478     ///  Only one approved address is permitted for each account for transfer
479     ///  at any time. A zero value means there is no outstanding approval.
480     mapping (address => address) public addressToApprovedAll;
481 
482     /// @notice Enable or disable approval for a third party ("operator") to manage
483     ///  all your asset.
484     /// @dev Emits the ApprovalForAll event
485     /// @param _operator Address to add to the set of authorized operators.
486     /// @param _approved True if the operators is approved, false to revoke approval
487     function setApprovalForAll(address _operator, bool _approved) external
488     {
489         if (_approved)
490         {
491             addressToApprovedAll[msg.sender] = _operator;
492         }
493         else
494         {
495             delete addressToApprovedAll[msg.sender];
496         }
497         emit ApprovalForAll(msg.sender, _operator, _approved);
498     }
499 
500     /// @notice Get the approved address for a single NFT
501     /// @dev Throws if `_tokenId` is not a valid NFT
502     /// @param _tokenId The NFT to find the approved address for
503     /// @return The approved address for this NFT, or the zero address if there is none
504     function getApproved(uint256 _tokenId) 
505         external view canBeStoredIn40Bits(_tokenId) 
506         returns (address)
507     {
508         require(_tokenId <= _totalSupply());
509 
510         if (cutieIndexToApproved[uint40(_tokenId)] != address(0))
511         {
512             return cutieIndexToApproved[uint40(_tokenId)];
513         }
514 
515         address owner = cutieIndexToOwner[uint40(_tokenId)];
516         return addressToApprovedAll[owner];
517     }
518 
519     /// @notice Query if an address is an authorized operator for another address
520     /// @param _owner The address that owns the NFTs
521     /// @param _operator The address that acts on behalf of the owner
522     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
523     function isApprovedForAll(address _owner, address _operator) external view returns (bool)
524     {
525         return addressToApprovedAll[_owner] == _operator;
526     }
527 
528     function _isApprovedForAll(address _owner, address _operator) internal view returns (bool)
529     {
530         return addressToApprovedAll[_owner] == _operator;
531     }
532 
533     ConfigInterface public config;
534 
535     /// @dev Update the address of the config contract.
536     /// @param _address An address of a ConfigInterface contract instance to be used from this point forward.
537     function setConfigAddress(address _address) public onlyOwner
538     {
539         ConfigInterface candidateContract = ConfigInterface(_address);
540 
541         require(candidateContract.isConfig());
542 
543         // Set the new contract address
544         config = candidateContract;
545     }
546 
547     function getCooldownIndexFromGeneration(uint16 _generation) internal view returns (uint16)
548     {
549         return config.getCooldownIndexFromGeneration(_generation);
550     }
551 
552     /// @dev An internal method that creates a new cutie and stores it. This
553     ///  method does not check anything and should only be called when the
554     ///  input data is valid for sure. Will generate both a Birth event
555     ///  and a Transfer event.
556     /// @param _momId The cutie ID of the mom of this cutie (zero for gen0)
557     /// @param _dadId The cutie ID of the dad of this cutie (zero for gen0)
558     /// @param _generation The generation number of this cutie, must be computed by caller.
559     /// @param _genes The cutie's genetic code.
560     /// @param _owner The initial owner of this cutie, must be non-zero (except for the unCutie, ID 0)
561     function _createCutie(
562         uint40 _momId,
563         uint40 _dadId,
564         uint16 _generation,
565         uint16 _cooldownIndex,
566         uint256 _genes,
567         address _owner,
568         uint40 _birthTime
569     )
570         internal
571         returns (uint40)
572     {
573         Cutie memory _cutie = Cutie({
574             genes: _genes, 
575             birthTime: _birthTime, 
576             cooldownEndTime: 0, 
577             momId: _momId, 
578             dadId: _dadId, 
579             cooldownIndex: _cooldownIndex, 
580             generation: _generation,
581             optional: 0
582         });
583         uint256 newCutieId256 = cuties.push(_cutie) - 1;
584 
585         // Check if id can fit into 40 bits
586         require(newCutieId256 <= 0xFFFFFFFFFF);
587 
588         uint40 newCutieId = uint40(newCutieId256);
589 
590         // emit the birth event
591         emit Birth(_owner, newCutieId, _cutie.momId, _cutie.dadId, _cutie.genes);
592 
593         // This will assign ownership, as well as emit the Transfer event as
594         // per ERC721 draft
595         _transfer(0, _owner, newCutieId);
596 
597         return newCutieId;
598     }
599   
600     /// @notice Returns all the relevant information about a certain cutie.
601     /// @param _id The ID of the cutie of interest.
602     function getCutie(uint40 _id)
603         external
604         view
605         returns (
606         uint256 genes,
607         uint40 birthTime,
608         uint40 cooldownEndTime,
609         uint40 momId,
610         uint40 dadId,
611         uint16 cooldownIndex,
612         uint16 generation
613     ) {
614         Cutie storage cutie = cuties[_id];
615 
616         genes = cutie.genes;
617         birthTime = cutie.birthTime;
618         cooldownEndTime = cutie.cooldownEndTime;
619         momId = cutie.momId;
620         dadId = cutie.dadId;
621         cooldownIndex = cutie.cooldownIndex;
622         generation = cutie.generation;
623     }    
624     
625     /// @dev Assigns ownership of a particular Cutie to an address.
626     function _transfer(address _from, address _to, uint40 _cutieId) internal {
627         // since the number of cuties is capped to 2^40
628         // there is no way to overflow this
629         ownershipTokenCount[_to]++;
630         // transfer ownership
631         cutieIndexToOwner[_cutieId] = _to;
632         // When creating new cuties _from is 0x0, but we cannot account that address.
633         if (_from != address(0)) {
634             ownershipTokenCount[_from]--;
635             // once the cutie is transferred also clear breeding allowances
636             delete sireAllowedToAddress[_cutieId];
637             // clear any previously approved ownership exchange
638             delete cutieIndexToApproved[_cutieId];
639         }
640         // Emit the transfer event.
641         emit Transfer(_from, _to, _cutieId);
642     }
643 
644     /// @dev For transferring a cutie owned by this contract to the specified address.
645     ///  Used to rescue lost cuties. (There is no "proper" flow where this contract
646     ///  should be the owner of any Cutie. This function exists for us to reassign
647     ///  the ownership of Cuties that users may have accidentally sent to our address.)
648     /// @param _cutieId - ID of cutie
649     /// @param _recipient - Address to send the cutie to
650     function restoreCutieToAddress(uint40 _cutieId, address _recipient) public onlyOperator whenNotPaused {
651         require(_isOwner(this, _cutieId));
652         _transfer(this, _recipient, _cutieId);
653     }
654 
655     address ownerAddress;
656     address operatorAddress;
657 
658     bool public paused = false;
659 
660     modifier onlyOwner()
661     {
662         require(msg.sender == ownerAddress);
663         _;
664     }
665 
666     function setOwner(address _newOwner) public onlyOwner
667     {
668         require(_newOwner != address(0));
669 
670         ownerAddress = _newOwner;
671     }
672 
673     modifier onlyOperator() {
674         require(msg.sender == operatorAddress || msg.sender == ownerAddress);
675         _;
676     }
677 
678     function setOperator(address _newOperator) public onlyOwner {
679         require(_newOperator != address(0));
680 
681         operatorAddress = _newOperator;
682     }
683 
684     modifier whenNotPaused()
685     {
686         require(!paused);
687         _;
688     }
689 
690     modifier whenPaused
691     {
692         require(paused);
693         _;
694     }
695 
696     function pause() public onlyOwner whenNotPaused
697     {
698         paused = true;
699     }
700 
701     string public metadataUrlPrefix = "https://blockchaincuties.co/cutie/";
702     string public metadataUrlSuffix = ".svg";
703 
704     /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
705     /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
706     ///  3986. The URI may point to a JSON file that conforms to the "ERC721
707     ///  Metadata JSON Schema".
708     function tokenURI(uint256 _tokenId) external view returns (string infoUrl)
709     {
710         return 
711             concat(toSlice(metadataUrlPrefix), 
712                 toSlice(concat(toSlice(uintToString(_tokenId)), toSlice(metadataUrlSuffix))));
713     }
714 
715     function setMetadataUrl(string _metadataUrlPrefix, string _metadataUrlSuffix) public onlyOwner
716     {
717         metadataUrlPrefix = _metadataUrlPrefix;
718         metadataUrlSuffix = _metadataUrlSuffix;
719     }
720 
721 
722     mapping(address => PluginInterface) public plugins;
723     PluginInterface[] public pluginsArray;
724     mapping(uint40 => address) public usedSignes;
725     uint40 public minSignId;
726 
727     event GenesChanged(uint40 indexed cutieId, uint256 oldValue, uint256 newValue);
728     event CooldownEndTimeChanged(uint40 indexed cutieId, uint40 oldValue, uint40 newValue);
729     event CooldownIndexChanged(uint40 indexed cutieId, uint16 ololdValue, uint16 newValue);
730     event GenerationChanged(uint40 indexed cutieId, uint16 oldValue, uint16 newValue);
731     event OptionalChanged(uint40 indexed cutieId, uint64 oldValue, uint64 newValue);
732     event SignUsed(uint40 signId, address sender);
733     event MinSignSet(uint40 signId);
734 
735     /// @dev Sets the reference to the plugin contract.
736     /// @param _address - Address of plugin contract.
737     function addPlugin(address _address) public onlyOwner
738     {
739         PluginInterface candidateContract = PluginInterface(_address);
740 
741         // verify that a contract is what we expect
742         require(candidateContract.isPluginInterface());
743 
744         // Set the new contract address
745         plugins[_address] = candidateContract;
746         pluginsArray.push(candidateContract);
747     }
748 
749     /// @dev Remove plugin and calls onRemove to cleanup
750     function removePlugin(address _address) public onlyOwner
751     {
752         plugins[_address].onRemove();
753         delete plugins[_address];
754 
755         uint256 kindex = 0;
756         while (kindex < pluginsArray.length)
757         {
758             if (address(pluginsArray[kindex]) == _address)
759             {
760                 pluginsArray[kindex] = pluginsArray[pluginsArray.length-1];
761                 pluginsArray.length--;
762             }
763             else
764             {
765                 kindex++;
766             }
767         }
768     }
769 
770     /// @dev Put a cutie up for plugin feature.
771     function runPlugin(
772         address _pluginAddress,
773         uint40 _cutieId,
774         uint256 _parameter
775     )
776         public
777         whenNotPaused
778         payable
779     {
780         // If cutie is already on any auction or in adventure, this will throw
781         // because it will be owned by the other contract.
782         // If _cutieId is 0, then cutie is not used on this feature.
783         require(_cutieId == 0 || _isOwner(msg.sender, _cutieId));
784         require(address(plugins[_pluginAddress]) != address(0));
785         if (_cutieId > 0)
786         {
787             _approve(_cutieId, _pluginAddress);
788         }
789 
790         // Plugin contract throws if inputs are invalid and clears
791         // transfer after escrowing the cutie.
792         plugins[_pluginAddress].run.value(msg.value)(
793             _cutieId,
794             _parameter,
795             msg.sender
796         );
797     }
798 
799     /// @dev Called from plugin contract when using items as effect
800     function getGenes(uint40 _id)
801         public
802         view
803         returns (
804         uint256 genes
805     )
806     {
807         Cutie storage cutie = cuties[_id];
808         genes = cutie.genes;
809     }
810 
811     /// @dev Called from plugin contract when using items as effect
812     function changeGenes(
813         uint40 _cutieId,
814         uint256 _genes)
815         public
816         whenNotPaused
817     {
818         // if caller is registered plugin contract
819         require(address(plugins[msg.sender]) != address(0));
820 
821         Cutie storage cutie = cuties[_cutieId];
822         if (cutie.genes != _genes)
823         {
824             emit GenesChanged(_cutieId, cutie.genes, _genes);
825             cutie.genes = _genes;
826         }
827     }
828 
829     function getCooldownEndTime(uint40 _id)
830         public
831         view
832         returns (
833         uint40 cooldownEndTime
834     ) {
835         Cutie storage cutie = cuties[_id];
836 
837         cooldownEndTime = cutie.cooldownEndTime;
838     }
839 
840     function changeCooldownEndTime(
841         uint40 _cutieId,
842         uint40 _cooldownEndTime)
843         public
844         whenNotPaused
845     {
846         require(address(plugins[msg.sender]) != address(0));
847 
848         Cutie storage cutie = cuties[_cutieId];
849         if (cutie.cooldownEndTime != _cooldownEndTime)
850         {
851             emit CooldownEndTimeChanged(_cutieId, cutie.cooldownEndTime, _cooldownEndTime);
852             cutie.cooldownEndTime = _cooldownEndTime;
853         }
854     }
855 
856     function getCooldownIndex(uint40 _id)
857         public
858         view
859         returns (
860         uint16 cooldownIndex
861     ) {
862         Cutie storage cutie = cuties[_id];
863 
864         cooldownIndex = cutie.cooldownIndex;
865     }
866 
867     function changeCooldownIndex(
868         uint40 _cutieId,
869         uint16 _cooldownIndex)
870         public
871         whenNotPaused
872     {
873         require(address(plugins[msg.sender]) != address(0));
874 
875         Cutie storage cutie = cuties[_cutieId];
876         if (cutie.cooldownIndex != _cooldownIndex)
877         {
878             emit CooldownIndexChanged(_cutieId, cutie.cooldownIndex, _cooldownIndex);
879             cutie.cooldownIndex = _cooldownIndex;
880         }
881     }
882 
883     function changeGeneration(
884         uint40 _cutieId,
885         uint16 _generation)
886         public
887         whenNotPaused
888     {
889         require(address(plugins[msg.sender]) != address(0));
890 
891         Cutie storage cutie = cuties[_cutieId];
892         if (cutie.generation != _generation)
893         {
894             emit GenerationChanged(_cutieId, cutie.generation, _generation);
895             cutie.generation = _generation;
896         }
897     }
898 
899     function getGeneration(uint40 _id)
900         public
901         view
902         returns (uint16 generation)
903     {
904         Cutie storage cutie = cuties[_id];
905         generation = cutie.generation;
906     }
907 
908     function changeOptional(
909         uint40 _cutieId,
910         uint64 _optional)
911         public
912         whenNotPaused
913     {
914         require(address(plugins[msg.sender]) != address(0));
915 
916         Cutie storage cutie = cuties[_cutieId];
917         if (cutie.optional != _optional)
918         {
919             emit OptionalChanged(_cutieId, cutie.optional, _optional);
920             cutie.optional = _optional;
921         }
922     }
923 
924     function getOptional(uint40 _id)
925         public
926         view
927         returns (uint64 optional)
928     {
929         Cutie storage cutie = cuties[_id];
930         optional = cutie.optional;
931     }
932 
933     /// @dev Common function to be used also in backend
934     function hashArguments(
935         address _pluginAddress,
936         uint40 _signId,
937         uint40 _cutieId,
938         uint128 _value,
939         uint256 _parameter)
940         public pure returns (bytes32 msgHash)
941     {
942         msgHash = keccak256(_pluginAddress, _signId, _cutieId, _value, _parameter);
943     }
944 
945     /// @dev Common function to be used also in backend
946     function getSigner(
947         address _pluginAddress,
948         uint40 _signId,
949         uint40 _cutieId,
950         uint128 _value,
951         uint256 _parameter,
952         uint8 _v,
953         bytes32 _r,
954         bytes32 _s
955         )
956         public pure returns (address)
957     {
958         bytes32 msgHash = hashArguments(_pluginAddress, _signId, _cutieId, _value, _parameter);
959         return ecrecover(msgHash, _v, _r, _s);
960     }
961 
962     /// @dev Common function to be used also in backend
963     function isValidSignature(
964         address _pluginAddress,
965         uint40 _signId,
966         uint40 _cutieId,
967         uint128 _value,
968         uint256 _parameter,
969         uint8 _v,
970         bytes32 _r,
971         bytes32 _s
972         )
973         public
974         view
975         returns (bool)
976     {
977         return getSigner(_pluginAddress, _signId, _cutieId, _value, _parameter, _v, _r, _s) == operatorAddress;
978     }
979 
980     /// @dev Put a cutie up for plugin feature with signature.
981     ///  Can be used for items equip, item sales and other features.
982     ///  Signatures are generated by Operator role.
983     function runPluginSigned(
984         address _pluginAddress,
985         uint40 _signId,
986         uint40 _cutieId,
987         uint128 _value,
988         uint256 _parameter,
989         uint8 _v,
990         bytes32 _r,
991         bytes32 _s
992     )
993         public
994         whenNotPaused
995         payable
996     {
997         // If cutie is already on any auction or in adventure, this will throw
998         // as it will be owned by the other contract.
999         // If _cutieId is 0, then cutie is not used on this feature.
1000         require(_cutieId == 0 || _isOwner(msg.sender, _cutieId));
1001     
1002         require(address(plugins[_pluginAddress]) != address(0));    
1003 
1004         require (usedSignes[_signId] == address(0));
1005         require (_signId >= minSignId);
1006         // value can also be zero for free calls
1007         require (_value <= msg.value);
1008 
1009         require (isValidSignature(_pluginAddress, _signId, _cutieId, _value, _parameter, _v, _r, _s));
1010         
1011         usedSignes[_signId] = msg.sender;
1012         emit SignUsed(_signId, msg.sender);
1013 
1014         // Plugin contract throws if inputs are invalid and clears
1015         // transfer after escrowing the cutie.
1016         plugins[_pluginAddress].runSigned.value(_value)(
1017             _cutieId,
1018             _parameter,
1019             msg.sender
1020         );
1021     }
1022 
1023     /// @dev Sets minimal signId, than can be used.
1024     ///       All unused signatures less than signId will be cancelled on off-chain server
1025     ///       and unused items will be transfered back to owner.
1026     function setMinSign(uint40 _newMinSignId)
1027         public
1028         onlyOperator
1029     {
1030         require (_newMinSignId > minSignId);
1031         minSignId = _newMinSignId;
1032         emit MinSignSet(minSignId);
1033     }
1034 
1035 
1036     event BreedingApproval(address indexed _owner, address indexed _approved, uint256 _tokenId);
1037 
1038     // Set in case the core contract is broken and an upgrade is required
1039     address public upgradedContractAddress;
1040 
1041     function isCutieCore() pure public returns (bool) { return true; }
1042 
1043     /// @notice Creates the main BlockchainCuties smart contract instance.
1044     function BlockchainCutiesCore() public
1045     {
1046         // Starts paused.
1047         paused = true;
1048 
1049         // the creator of the contract is the initial owner
1050         ownerAddress = msg.sender;
1051 
1052         // the creator of the contract is also the initial operator
1053         operatorAddress = msg.sender;
1054 
1055         // start with the mythical cutie 0 - so there are no generation-0 parent issues
1056         _createCutie(0, 0, 0, 0, uint256(-1), address(0), 0);
1057     }
1058 
1059     event ContractUpgrade(address newContract);
1060 
1061     /// @dev Aimed to mark the smart contract as upgraded if there is a crucial
1062     ///  bug. This keeps track of the new contract and indicates that the new address is set. 
1063     /// Updating to the new contract address is up to the clients. (This contract will
1064     ///  be paused indefinitely if such an upgrade takes place.)
1065     /// @param _newAddress new address
1066     function setUpgradedAddress(address _newAddress) public onlyOwner whenPaused
1067     {
1068         require(_newAddress != address(0));
1069         upgradedContractAddress = _newAddress;
1070         emit ContractUpgrade(upgradedContractAddress);
1071     }
1072 
1073     /// @dev Import cuties from previous version of Core contract.
1074     /// @param _oldAddress Old core contract address
1075     /// @param _fromIndex (inclusive)
1076     /// @param _toIndex (inclusive)
1077     function migrate(address _oldAddress, uint40 _fromIndex, uint40 _toIndex) public onlyOwner whenPaused
1078     {
1079         require(_totalSupply() + 1 == _fromIndex);
1080 
1081         BlockchainCutiesCore old = BlockchainCutiesCore(_oldAddress);
1082 
1083         for (uint40 i = _fromIndex; i <= _toIndex; i++)
1084         {
1085             uint256 genes;
1086             uint40 birthTime;
1087             uint40 cooldownEndTime;
1088             uint40 momId;
1089             uint40 dadId;
1090             uint16 cooldownIndex;
1091             uint16 generation;            
1092             (genes, birthTime, cooldownEndTime, momId, dadId, cooldownIndex, generation) = old.getCutie(i);
1093 
1094             Cutie memory _cutie = Cutie({
1095                 genes: genes, 
1096                 birthTime: birthTime, 
1097                 cooldownEndTime: cooldownEndTime, 
1098                 momId: momId, 
1099                 dadId: dadId, 
1100                 cooldownIndex: cooldownIndex, 
1101                 generation: generation,
1102                 optional: 0
1103             });
1104             cuties.push(_cutie);
1105         }
1106     }
1107 
1108     /// @dev Import cuties from previous version of Core contract (part 2).
1109     /// @param _oldAddress Old core contract address
1110     /// @param _fromIndex (inclusive)
1111     /// @param _toIndex (inclusive)
1112     function migrate2(address _oldAddress, uint40 _fromIndex, uint40 _toIndex, address saleAddress, address breedingAddress) public onlyOwner whenPaused
1113     {
1114         BlockchainCutiesCore old = BlockchainCutiesCore(_oldAddress);
1115         MarketInterface oldSaleMarket = MarketInterface(saleAddress);
1116         MarketInterface oldBreedingMarket = MarketInterface(breedingAddress);
1117 
1118         for (uint40 i = _fromIndex; i <= _toIndex; i++)
1119         {
1120             address owner = old.ownerOf(i);
1121 
1122             if (owner == saleAddress)
1123             {
1124                 (owner,,,,,) = oldSaleMarket.getAuctionInfo(i);
1125             }
1126 
1127             if (owner == breedingAddress)
1128             {
1129                 (owner,,,,,) = oldBreedingMarket.getAuctionInfo(i);
1130             }
1131             _transfer(0, owner, i);
1132         }
1133     }
1134 
1135     /// @dev Override unpause so it requires upgradedContractAddress not set, because then the contract was upgraded.
1136     function unpause() public onlyOwner whenPaused
1137     {
1138         require(upgradedContractAddress == address(0));
1139 
1140         paused = false;
1141     }
1142 
1143     // Counts the number of cuties the contract owner has created.
1144     uint40 public promoCutieCreatedCount;
1145     uint40 public gen0CutieCreatedCount;
1146     uint40 public gen0Limit = 50000;
1147     uint40 public promoLimit = 5000;
1148 
1149     /// @dev Creates a new gen0 cutie with the given genes and
1150     ///  creates an auction for it.
1151     function createGen0Auction(uint256 _genes, uint128 startPrice, uint128 endPrice, uint40 duration) public onlyOperator
1152     {
1153         require(gen0CutieCreatedCount < gen0Limit);
1154         uint40 cutieId = _createCutie(0, 0, 0, 0, _genes, address(this), uint40(now));
1155         _approve(cutieId, saleMarket);
1156 
1157         saleMarket.createAuction(
1158             cutieId,
1159             startPrice,
1160             endPrice,
1161             duration,
1162             address(this)
1163         );
1164 
1165         gen0CutieCreatedCount++;
1166     }
1167 
1168     function createPromoCutie(uint256 _genes, address _owner) public onlyOperator
1169     {
1170         require(promoCutieCreatedCount < promoLimit);
1171         if (_owner == address(0)) {
1172              _owner = operatorAddress;
1173         }
1174         promoCutieCreatedCount++;
1175         gen0CutieCreatedCount++;
1176         _createCutie(0, 0, 0, 0, _genes, _owner, uint40(now));
1177     }
1178 
1179     /// @dev Put a cutie up for auction to be dad.
1180     ///  Performs checks to ensure the cutie can be dad, then
1181     ///  delegates to reverse auction.
1182     ///  Optional money amount can be sent to contract to feature auction.
1183     ///  Pricea are available on web.
1184     function createBreedingAuction(
1185         uint40 _cutieId,
1186         uint128 _startPrice,
1187         uint128 _endPrice,
1188         uint40 _duration
1189     )
1190         public
1191         whenNotPaused
1192         payable
1193     {
1194         // Auction contract checks input sizes
1195         // If cutie is already on any auction, this will throw
1196         // because it will be owned by the auction contract.
1197         require(_isOwner(msg.sender, _cutieId));
1198         require(canBreed(_cutieId));
1199         _approve(_cutieId, breedingMarket);
1200         // breeding auction function is called if inputs are invalid and clears
1201         // transfer and sire approval after escrowing the cutie.
1202         breedingMarket.createAuction.value(msg.value)(
1203             _cutieId,
1204             _startPrice,
1205             _endPrice,
1206             _duration,
1207             msg.sender
1208         );
1209     }
1210 
1211     /// @dev Sets the reference to the breeding auction.
1212     /// @param _breedingAddress - Address of breeding market contract.
1213     /// @param _saleAddress - Address of sale market contract.
1214     function setMarketAddress(address _breedingAddress, address _saleAddress) public onlyOwner
1215     {
1216         //require(address(breedingMarket) == address(0));
1217         //require(address(saleMarket) == address(0));
1218 
1219         breedingMarket = MarketInterface(_breedingAddress);
1220         saleMarket = MarketInterface(_saleAddress);
1221     }
1222 
1223     /// @dev Completes a breeding auction by bidding.
1224     ///  Immediately breeds the winning mom with the dad on auction.
1225     /// @param _dadId - ID of the dad on auction.
1226     /// @param _momId - ID of the mom owned by the bidder.
1227     function bidOnBreedingAuction(
1228         uint40 _dadId,
1229         uint40 _momId
1230     )
1231         public
1232         payable
1233         whenNotPaused
1234         returns (uint256)
1235     {
1236         // Auction contract checks input sizes
1237         require(_isOwner(msg.sender, _momId));
1238         require(canBreed(_momId));
1239         require(_canMateViaMarketplace(_momId, _dadId));
1240         // Take breeding fee
1241         uint256 fee = getBreedingFee(_momId, _dadId);
1242         require(msg.value >= fee);
1243 
1244         // breeding auction will throw if the bid fails.
1245         breedingMarket.bid.value(msg.value - fee)(_dadId);
1246         return _breedWith(_momId, _dadId);
1247     }
1248 
1249     /// @dev Put a cutie up for auction.
1250     ///  Does some ownership trickery for creating auctions in one transaction.
1251     ///  Optional money amount can be sent to contract to feature auction.
1252     ///  Pricea are available on web.
1253     function createSaleAuction(
1254         uint40 _cutieId,
1255         uint128 _startPrice,
1256         uint128 _endPrice,
1257         uint40 _duration
1258     )
1259         public
1260         whenNotPaused
1261         payable
1262     {
1263         // Auction contract checks input sizes
1264         // If cutie is already on any auction, this will throw
1265         // because it will be owned by the auction contract.
1266         require(_isOwner(msg.sender, _cutieId));
1267         _approve(_cutieId, saleMarket);
1268         // Sale auction throws if inputs are invalid and clears
1269         // transfer and sire approval after escrowing the cutie.
1270         saleMarket.createAuction.value(msg.value)(
1271             _cutieId,
1272             _startPrice,
1273             _endPrice,
1274             _duration,
1275             msg.sender
1276         );
1277     }
1278 
1279     /// @dev The address of the sibling contract that is used to implement the genetic combination algorithm.
1280     GeneMixerInterface geneMixer;
1281 
1282     /// @dev Check if dad has authorized breeding with the mom. True if both dad
1283     ///  and mom have the same owner, or if the dad has given breeding permission to
1284     ///  the mom's owner (via approveBreeding()).
1285     function _isBreedingPermitted(uint40 _dadId, uint40 _momId) internal view returns (bool)
1286     {
1287         address momOwner = cutieIndexToOwner[_momId];
1288         address dadOwner = cutieIndexToOwner[_dadId];
1289 
1290         // Breeding is approved if they have same owner, or if the mom's owner was given
1291         // permission to breed with the dad.
1292         return (momOwner == dadOwner || sireAllowedToAddress[_dadId] == momOwner);
1293     }
1294 
1295     /// @dev Update the address of the genetic contract.
1296     /// @param _address An address of a GeneMixer contract instance to be used from this point forward.
1297     function setGeneMixerAddress(address _address) public onlyOwner
1298     {
1299         GeneMixerInterface candidateContract = GeneMixerInterface(_address);
1300 
1301         require(candidateContract.isGeneMixer());
1302 
1303         // Set the new contract address
1304         geneMixer = candidateContract;
1305     }
1306 
1307     /// @dev Checks that a given cutie is able to breed. Requires that the
1308     ///  current cooldown is finished (for dads)
1309     function _canBreed(Cutie _cutie) internal view returns (bool)
1310     {
1311         return _cutie.cooldownEndTime <= now;
1312     }
1313 
1314     /// @notice Grants approval to another user to sire with one of your Cuties.
1315     /// @param _addr The address that will be able to sire with your Cutie. Set to
1316     ///  address(0) to clear all breeding approvals for this Cutie.
1317     /// @param _dadId A Cutie that you own that _addr will now be able to dad with.
1318     function approveBreeding(address _addr, uint40 _dadId) public whenNotPaused
1319     {
1320         require(_isOwner(msg.sender, _dadId));
1321         sireAllowedToAddress[_dadId] = _addr;
1322         emit BreedingApproval(msg.sender, _addr, _dadId);
1323     }
1324 
1325     /// @dev Set the cooldownEndTime for the given Cutie, based on its current cooldownIndex.
1326     ///  Also increments the cooldownIndex (unless it has hit the cap).
1327     /// @param _cutie A reference to the Cutie in storage which needs its timer started.
1328     function _triggerCooldown(uint40 _cutieId, Cutie storage _cutie) internal
1329     {
1330         // Compute the end of the cooldown time, based on current cooldownIndex
1331         uint40 oldValue = _cutie.cooldownIndex;
1332         _cutie.cooldownEndTime = config.getCooldownEndTimeFromIndex(_cutie.cooldownIndex);
1333         emit CooldownEndTimeChanged(_cutieId, oldValue, _cutie.cooldownEndTime);
1334 
1335         // Increment the breeding count.
1336         if (_cutie.cooldownIndex + 1 < config.getCooldownIndexCount()) {
1337             uint16 oldValue2 = _cutie.cooldownIndex;
1338             _cutie.cooldownIndex++;
1339             emit CooldownIndexChanged(_cutieId, oldValue2, _cutie.cooldownIndex);
1340         }
1341     }
1342 
1343     /// @notice Checks that a certain cutie is not
1344     ///  in the middle of a breeding cooldown and is able to breed.
1345     /// @param _cutieId reference the id of the cutie, any user can inquire about it
1346     function canBreed(uint40 _cutieId)
1347         public
1348         view
1349         returns (bool)
1350     {
1351         require(_cutieId > 0);
1352         Cutie storage cutie = cuties[_cutieId];
1353         return _canBreed(cutie);
1354     }
1355 
1356     /// @dev Check if given mom and dad are a valid mating pair.
1357     function _canPairMate(
1358         Cutie storage _mom,
1359         uint40 _momId,
1360         Cutie storage _dad,
1361         uint40 _dadId
1362     )
1363         private
1364         view
1365         returns(bool)
1366     {
1367         // A Cutie can't breed with itself.
1368         if (_dadId == _momId) { 
1369             return false; 
1370         }
1371 
1372         // Cuties can't breed with their parents.
1373         if (_mom.momId == _dadId) {
1374             return false;
1375         }
1376         if (_mom.dadId == _dadId) {
1377             return false;
1378         }
1379 
1380         if (_dad.momId == _momId) {
1381             return false;
1382         }
1383         if (_dad.dadId == _momId) {
1384             return false;
1385         }
1386 
1387         // We can short circuit the sibling check (below) if either cat is
1388         // gen zero (has a mom ID of zero).
1389         if (_dad.momId == 0) {
1390             return true;
1391         }
1392         if (_mom.momId == 0) {
1393             return true;
1394         }
1395 
1396         // Cuties can't breed with full or half siblings.
1397         if (_dad.momId == _mom.momId) {
1398             return false;
1399         }
1400         if (_dad.momId == _mom.dadId) {
1401             return false;
1402         }
1403         if (_dad.dadId == _mom.momId) {
1404             return false;
1405         }
1406         if (_dad.dadId == _mom.dadId) {
1407             return false;
1408         }
1409 
1410         if (geneMixer.canBreed(_momId, _mom.genes, _dadId, _dad.genes)) {
1411             return true;
1412         }
1413         return false;
1414     }
1415 
1416     /// @notice Checks to see if two cuties can breed together (checks both
1417     ///  ownership and breeding approvals, but does not check if both cuties are ready for
1418     ///  breeding).
1419     /// @param _momId The ID of the proposed mom.
1420     /// @param _dadId The ID of the proposed dad.
1421     function canBreedWith(uint40 _momId, uint40 _dadId)
1422         public
1423         view
1424         returns(bool)
1425     {
1426         require(_momId > 0);
1427         require(_dadId > 0);
1428         Cutie storage mom = cuties[_momId];
1429         Cutie storage dad = cuties[_dadId];
1430         return _canPairMate(mom, _momId, dad, _dadId) && _isBreedingPermitted(_dadId, _momId);
1431     }
1432     
1433     /// @dev Internal check to see if a given dad and mom are a valid mating pair for
1434     ///  breeding via market (this method doesn't check ownership and if mating is allowed).
1435     function _canMateViaMarketplace(uint40 _momId, uint40 _dadId)
1436         internal
1437         view
1438         returns (bool)
1439     {
1440         Cutie storage mom = cuties[_momId];
1441         Cutie storage dad = cuties[_dadId];
1442         return _canPairMate(mom, _momId, dad, _dadId);
1443     }
1444 
1445     function getBreedingFee(uint40 _momId, uint40 _dadId)
1446         public
1447         view
1448         returns (uint256)
1449     {
1450         return config.getBreedingFee(_momId, _dadId);
1451     }
1452 
1453 
1454     /// @notice Breed cuties that you own, or for which you
1455     ///  have previously been given Breeding approval. Will either make your cutie give birth, or will
1456     ///  fail.
1457     /// @param _momId The ID of the Cutie acting as mom (will end up give birth if successful)
1458     /// @param _dadId The ID of the Cutie acting as dad (will begin its breeding cooldown if successful)
1459     function breedWith(uint40 _momId, uint40 _dadId) 
1460         public
1461         whenNotPaused
1462         payable
1463         returns (uint40)
1464     {
1465         // Caller must own the mom.
1466         require(_isOwner(msg.sender, _momId));
1467 
1468         // Neither dad nor mom can be on auction during
1469         // breeding.
1470         // For mom: The caller of this function can't be the owner of the mom
1471         //   because the owner of a Cutie on auction is the auction house, and the
1472         //   auction house will never call breedWith().
1473         // For dad: Similarly, a dad on auction will be owned by the auction house
1474         //   and the act of transferring ownership will have cleared any outstanding
1475         //   breeding approval.
1476         // Thus we don't need check if either cutie
1477         // is on auction.
1478 
1479         // Check that mom and dad are both owned by caller, or that the dad
1480         // has given breeding permission to caller (i.e. mom's owner).
1481         // Will fail for _dadId = 0
1482         require(_isBreedingPermitted(_dadId, _momId));
1483 
1484         // Check breeding fee
1485         require(getBreedingFee(_momId, _dadId) <= msg.value);
1486 
1487         // Grab a reference to the potential mom
1488         Cutie storage mom = cuties[_momId];
1489 
1490         // Make sure mom's cooldown isn't active, or in the middle of a breeding cooldown
1491         require(_canBreed(mom));
1492 
1493         // Grab a reference to the potential dad
1494         Cutie storage dad = cuties[_dadId];
1495 
1496         // Make sure dad cooldown isn't active, or in the middle of a breeding cooldown
1497         require(_canBreed(dad));
1498 
1499         // Test that these cuties are a valid mating pair.
1500         require(_canPairMate(
1501             mom,
1502             _momId,
1503             dad,
1504             _dadId
1505         ));
1506 
1507         return _breedWith(_momId, _dadId);
1508     }
1509 
1510     /// @dev Internal utility function to start breeding, assumes that all breeding
1511     ///  requirements have been checked.
1512     function _breedWith(uint40 _momId, uint40 _dadId) internal returns (uint40)
1513     {
1514         // Grab a reference to the Cuties from storage.
1515         Cutie storage dad = cuties[_dadId];
1516         Cutie storage mom = cuties[_momId];
1517 
1518         // Trigger the cooldown for both parents.
1519         _triggerCooldown(_dadId, dad);
1520         _triggerCooldown(_momId, mom);
1521 
1522         // Clear breeding permission for both parents.
1523         delete sireAllowedToAddress[_momId];
1524         delete sireAllowedToAddress[_dadId];
1525 
1526         // Check that the mom is a valid cutie.
1527         require(mom.birthTime != 0);
1528 
1529         // Determine the higher generation number of the two parents
1530         uint16 babyGen = config.getBabyGen(mom.generation, dad.generation);
1531 
1532         // Call the gene mixing operation.
1533         uint256 childGenes = geneMixer.mixGenes(mom.genes, dad.genes);
1534 
1535         // Make the new cutie
1536         address owner = cutieIndexToOwner[_momId];
1537         uint40 cutieId = _createCutie(_momId, _dadId, babyGen, getCooldownIndexFromGeneration(babyGen), childGenes, owner, mom.cooldownEndTime);
1538 
1539         // return the new cutie's ID
1540         return cutieId;
1541     }
1542 
1543     mapping(address => uint40) isTutorialPetUsed;
1544 
1545     /// @dev Completes a breeding tutorial cutie (non existing in blockchain)
1546     ///  with auction by bidding. Immediately breeds with dad on auction.
1547     /// @param _dadId - ID of the dad on auction.
1548     function bidOnBreedingAuctionTutorial(
1549         uint40 _dadId
1550     )
1551         public
1552         payable
1553         whenNotPaused
1554         returns (uint)
1555     {
1556         require(isTutorialPetUsed[msg.sender] == 0);
1557 
1558         // Take breeding fee
1559         uint256 fee = getBreedingFee(0, _dadId);
1560         require(msg.value >= fee);
1561 
1562         // breeding auction will throw if the bid fails.
1563         breedingMarket.bid.value(msg.value - fee)(_dadId);
1564 
1565         // Grab a reference to the Cuties from storage.
1566         Cutie storage dad = cuties[_dadId];
1567 
1568         // Trigger the cooldown for parent.
1569         _triggerCooldown(_dadId, dad);
1570 
1571         // Clear breeding permission for parent.
1572         delete sireAllowedToAddress[_dadId];
1573 
1574         uint16 babyGen = config.getTutorialBabyGen(dad.generation);
1575 
1576         // tutorial pet genome is zero
1577         uint256 childGenes = geneMixer.mixGenes(0x0, dad.genes);
1578 
1579         // tutorial pet id is zero
1580         uint40 cutieId = _createCutie(0, _dadId, babyGen, getCooldownIndexFromGeneration(babyGen), childGenes, msg.sender, 12);
1581 
1582         isTutorialPetUsed[msg.sender] = cutieId;
1583 
1584         // return the new cutie's ID
1585         return cutieId;
1586     }
1587 
1588     address party1address;
1589     address party2address;
1590     address party3address;
1591     address party4address;
1592     address party5address;
1593 
1594     /// @dev Setup project owners
1595     function setParties(address _party1, address _party2, address _party3, address _party4, address _party5) public onlyOwner
1596     {
1597         require(_party1 != address(0));
1598         require(_party2 != address(0));
1599         require(_party3 != address(0));
1600         require(_party4 != address(0));
1601         require(_party5 != address(0));
1602 
1603         party1address = _party1;
1604         party2address = _party2;
1605         party3address = _party3;
1606         party4address = _party4;
1607         party5address = _party5;
1608     }
1609 
1610     /// @dev Reject all Ether which is not from game contracts from being sent here.
1611     function() external payable {
1612         require(
1613             msg.sender == address(saleMarket) ||
1614             msg.sender == address(breedingMarket) ||
1615             address(plugins[msg.sender]) != address(0)
1616         );
1617     }
1618 
1619     /// @dev The balance transfer from the market and plugins contract
1620     /// to the CutieCore contract.
1621     function withdrawBalances() external
1622     {
1623         require(
1624             msg.sender == ownerAddress || 
1625             msg.sender == operatorAddress);
1626 
1627         saleMarket.withdrawEthFromBalance();
1628         breedingMarket.withdrawEthFromBalance();
1629         for (uint32 i = 0; i < pluginsArray.length; ++i)        
1630         {
1631             pluginsArray[i].withdraw();
1632         }
1633     }
1634 
1635     /// @dev The balance transfer from CutieCore contract to project owners
1636     function withdrawEthFromBalance() external
1637     {
1638         require(
1639             msg.sender == party1address ||
1640             msg.sender == party2address ||
1641             msg.sender == party3address ||
1642             msg.sender == party4address ||
1643             msg.sender == party5address ||
1644             msg.sender == ownerAddress || 
1645             msg.sender == operatorAddress);
1646 
1647         require(party1address != 0);
1648         require(party2address != 0);
1649         require(party3address != 0);
1650         require(party4address != 0);
1651         require(party5address != 0);
1652 
1653         uint256 total = address(this).balance;
1654 
1655         party1address.transfer(total*105/1000);
1656         party2address.transfer(total*105/1000);
1657         party3address.transfer(total*140/1000);
1658         party4address.transfer(total*140/1000);
1659         party5address.transfer(total*510/1000);
1660     }
1661 
1662 /*
1663  * @title String & slice utility library for Solidity contracts.
1664  * @author Nick Johnson <arachnid@notdot.net>
1665  *
1666  * @dev Functionality in this library is largely implemented using an
1667  *      abstraction called a 'slice'. A slice represents a part of a string -
1668  *      anything from the entire string to a single character, or even no
1669  *      characters at all (a 0-length slice). Since a slice only has to specify
1670  *      an offset and a length, copying and manipulating slices is a lot less
1671  *      expensive than copying and manipulating the strings they reference.
1672  *
1673  *      To further reduce gas costs, most functions on slice that need to return
1674  *      a slice modify the original one instead of allocating a new one; for
1675  *      instance, `s.split(".")` will return the text up to the first '.',
1676  *      modifying s to only contain the remainder of the string after the '.'.
1677  *      In situations where you do not want to modify the original slice, you
1678  *      can make a copy first with `.copy()`, for example:
1679  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
1680  *      Solidity has no memory management, it will result in allocating many
1681  *      short-lived slices that are later discarded.
1682  *
1683  *      Functions that return two slices come in two versions: a non-allocating
1684  *      version that takes the second slice as an argument, modifying it in
1685  *      place, and an allocating version that allocates and returns the second
1686  *      slice; see `nextRune` for example.
1687  *
1688  *      Functions that have to copy string data will return strings rather than
1689  *      slices; these can be cast back to slices for further processing if
1690  *      required.
1691  *
1692  *      For convenience, some functions are provided with non-modifying
1693  *      variants that create a new slice and return both; for instance,
1694  *      `s.splitNew('.')` leaves s unmodified, and returns two values
1695  *      corresponding to the left and right parts of the string.
1696  */
1697 
1698     struct slice
1699     {
1700         uint _len;
1701         uint _ptr;
1702     }
1703 
1704     /*
1705      * @dev Returns a slice containing the entire string.
1706      * @param self The string to make a slice from.
1707      * @return A newly allocated slice containing the entire string.
1708      */
1709     function toSlice(string self) internal pure returns (slice)
1710     {
1711         uint ptr;
1712         assembly {
1713             ptr := add(self, 0x20)
1714         }
1715         return slice(bytes(self).length, ptr);
1716     }
1717 
1718     function memcpy(uint dest, uint src, uint len) private pure
1719     {
1720         // Copy word-length chunks while possible
1721         for(; len >= 32; len -= 32) {
1722             assembly {
1723                 mstore(dest, mload(src))
1724             }
1725             dest += 32;
1726             src += 32;
1727         }
1728 
1729         // Copy remaining bytes
1730         uint mask = 256 ** (32 - len) - 1;
1731         assembly {
1732             let srcpart := and(mload(src), not(mask))
1733             let destpart := and(mload(dest), mask)
1734             mstore(dest, or(destpart, srcpart))
1735         }
1736     }
1737 
1738     /*
1739      * @dev Returns a newly allocated string containing the concatenation of
1740      *      `self` and `other`.
1741      * @param self The first slice to concatenate.
1742      * @param other The second slice to concatenate.
1743      * @return The concatenation of the two strings.
1744      */
1745     function concat(slice self, slice other) internal pure returns (string)
1746     {
1747         string memory ret = new string(self._len + other._len);
1748         uint retptr;
1749         assembly { retptr := add(ret, 32) }
1750         memcpy(retptr, self._ptr, self._len);
1751         memcpy(retptr + self._len, other._ptr, other._len);
1752         return ret;
1753     }
1754 
1755 
1756     function uintToString(uint256 a) internal pure returns (string result)
1757     {
1758         string memory r = "";
1759         do
1760         {
1761             uint b = a % 10;
1762             a /= 10;
1763 
1764             string memory c = "";
1765 
1766             if (b == 0) c = "0";
1767             else if (b == 1) c = "1";
1768             else if (b == 2) c = "2";
1769             else if (b == 3) c = "3";
1770             else if (b == 4) c = "4";
1771             else if (b == 5) c = "5";
1772             else if (b == 6) c = "6";
1773             else if (b == 7) c = "7";
1774             else if (b == 8) c = "8";
1775             else if (b == 9) c = "9";
1776 
1777             r = concat(toSlice(c), toSlice(r));
1778         }
1779         while (a > 0);
1780         result = r;
1781     }
1782 }