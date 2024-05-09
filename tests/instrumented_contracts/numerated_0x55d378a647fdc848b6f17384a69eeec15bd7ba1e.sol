1 pragma solidity ^0.4.20;
2 
3 /// @title defined the interface that will be referenced in main Cutie contract
4 /// @author https://BlockChainArchitect.io
5 contract GeneMixerInterface {
6     /// @dev simply a boolean to indicate this is the contract we expect to be
7     function isGeneMixer() external pure returns (bool);
8 
9     /// @dev given genes of cutie 1 & 2, return a genetic combination - may have a random factor
10     /// @param genes1 genes of mom
11     /// @param genes2 genes of dad
12     /// @return the genes that are supposed to be passed down the child
13     function mixGenes(uint256 genes1, uint256 genes2) public view returns (uint256);
14 
15     function canBreed(uint40 momId, uint256 genes1, uint40 dadId, uint256 genes2) public view returns (bool);
16 }
17 
18 
19 
20 /// @author https://BlockChainArchitect.io
21 contract PluginInterface
22 {
23     /// @dev simply a boolean to indicate this is the contract we expect to be
24     function isPluginInterface() public pure returns (bool);
25 
26     function onRemove() public;
27 
28     /// @dev Begins new feature.
29     /// @param _cutieId - ID of token to auction, sender must be owner.
30     /// @param _parameter - arbitrary parameter
31     /// @param _seller - Old owner, if not the message sender
32     function run(
33         uint40 _cutieId,
34         uint256 _parameter,
35         address _seller
36     ) 
37     public
38     payable;
39 
40     /// @dev Begins new feature, approved and signed by COO.
41     /// @param _cutieId - ID of token to auction, sender must be owner.
42     /// @param _parameter - arbitrary parameter
43     function runSigned(
44         uint40 _cutieId,
45         uint256 _parameter,
46         address _owner
47     )
48     external
49     payable;
50 
51     function withdraw() public;
52 }
53 
54 
55 
56 /// @title Auction Market for Blockchain Cuties.
57 /// @author https://BlockChainArchitect.io
58 contract MarketInterface 
59 {
60     function withdrawEthFromBalance() external;    
61 
62     function createAuction(uint40 _cutieId, uint128 _startPrice, uint128 _endPrice, uint40 _duration, address _seller) public payable;
63 
64     function bid(uint40 _cutieId) public payable;
65 }
66 
67 
68 
69 /// @dev Note: the ERC-165 identifier for this interface is 0xf0b9e5ba
70 interface ERC721TokenReceiver {
71     /// @notice Handle the receipt of an NFT
72     /// @dev The ERC721 smart contract calls this function on the recipient
73     ///  after a `transfer`. This function MAY throw to revert and reject the
74     ///  transfer. This function MUST use 50,000 gas or less. Return of other
75     ///  than the magic value MUST result in the transaction being reverted.
76     ///  Note: the contract address is always the message sender.
77     /// @param _from The sending address 
78     /// @param _tokenId The NFT identifier which is being transfered
79     /// @param data Additional data with no specified format
80     /// @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
81     ///  unless throwing
82     function onERC721Received(address _from, uint256 _tokenId, bytes data) external returns(bytes4);
83 }
84 
85 
86 /// @title BlockchainCuties: Collectible and breedable cuties on the Ethereum blockchain.
87 /// @author https://BlockChainArchitect.io
88 /// @dev This is the main BlockchainCuties contract. For separated logical sections the code is divided in 
89 // several separately-instantiated sibling contracts that handle auctions and the genetic combination algorithm. 
90 // By keeping auctions separate it is possible to upgrade them without disrupting the main contract that tracks
91 // the ownership of the cutie. The genetic combination algorithm is kept separate so that all of the rest of the 
92 // code can be open-sourced.
93 // The contracts:
94 //
95 //      - BlockchainCuties: The fundamental code, including main data storage, constants and data types, as well as
96 //             internal functions for managing these items ans ERC-721 implementation.
97 //             Various addresses and constraints for operations can be executed only by specific roles - 
98 //             Owner, Operator and Parties.
99 //             Methods for interacting with additional features (Plugins).
100 //             The methods for breeding and keeping track of breeding offers, relies on external genetic combination 
101 //             contract.
102 //             Public methods for auctioning or bidding or breeding. 
103 //
104 //      - SaleMarket and BreedingMarket: The actual auction functionality is handled in two sibling contracts - one
105 //             for sales and one for breeding. Auction creation and bidding is mostly mediated through this side of 
106 //             the core contract.
107 //
108 //      - Effects: Contracts allow to use item effects on cuties, implemented as plugins. Items are not stored in 
109 //             blockchain to not overload Ethereum network. Operator generates signatures, and Plugins check it
110 //             and perform effect.
111 //
112 //      - ItemMarket: Plugin contract used to transfer money from buyer to seller.
113 //
114 //      - Bank: Plugin contract used to receive payments for payed features.
115 
116 contract BlockchainCutiesCore /*is ERC721, CutieCoreInterface*/
117 {
118     /// @notice A descriptive name for a collection of NFTs in this contract
119     function name() external pure returns (string _name) 
120     {
121         return "BlockchainCuties"; 
122     }
123 
124     /// @notice An abbreviated name for NFTs in this contract
125     function symbol() external pure returns (string _symbol)
126     {
127         return "BC";
128     }
129     
130     /// @notice Query if a contract implements an interface
131     /// @param interfaceID The interface identifier, as specified in ERC-165
132     /// @dev Interface identification is specified in ERC-165. This function
133     ///  uses less than 30,000 gas.
134     /// @return `true` if the contract implements `interfaceID` and
135     ///  `interfaceID` is not 0xffffffff, `false` otherwise
136     function supportsInterface(bytes4 interfaceID) external pure returns (bool)
137     {
138         return
139             interfaceID == 0x6466353c || 
140             interfaceID == bytes4(keccak256('supportsInterface(bytes4)'));
141     }
142 
143     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
144     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
145     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
146 
147     /// @dev The Birth event is fired as soon as a new cutie is created. This
148     ///  is any time a cutie comes into existence through the giveBirth method, as well as
149     ///  when a new gen0 cutie is created.
150     event Birth(address indexed owner, uint40 cutieId, uint40 momId, uint40 dadId, uint256 genes);
151 
152     /// @dev This struct represents a blockchain Cutie. It was ensured that struct fits well into
153     ///  exactly two 256-bit words. The order of the members in this structure
154     ///  matters because of the Ethereum byte-packing rules.
155     ///  Reference: http://solidity.readthedocs.io/en/develop/miscellaneous.html
156     struct Cutie
157     {
158         // The Cutie's genetic code is in these 256-bits. Cutie's genes never change.
159         uint256 genes;
160 
161         // The timestamp from the block when this cutie was created.
162         uint40 birthTime;
163 
164         // The minimum timestamp after which the cutie can start breeding
165         // again.
166         uint40 cooldownEndTime;
167 
168         // The cutie's parents ID is set to 0 for gen0 cuties.
169         // Because of using 32-bit unsigned integers the limit is 4 billion cuties. 
170         // Current Ethereum annual limit is about 500 million transactions.
171         uint40 momId;
172         uint40 dadId;
173 
174         // Set the index in the cooldown array (see below) that means
175         // the current cooldown duration for this Cutie. Starts at 0
176         // for gen0 cats, and is initialized to floor(generation/2) for others.
177         // Incremented by one for each successful breeding, regardless
178         // of being cutie mom or cutie dad.
179         uint16 cooldownIndex;
180 
181         // The "generation number" of the cutie. Cutioes minted by the contract
182         // for sale are called "gen0" with generation number of 0. All other cuties' 
183         // generation number is the larger of their parents' two generation
184         // numbers, plus one (i.e. max(mom.generation, dad.generation) + 1)
185         uint16 generation;
186 
187         // Some optional data used by external contracts
188         // Cutie struct is 2x256 bits long.
189         uint64 optional;
190     }
191 
192     /// @dev An array containing the Cutie struct for all Cuties in existence. The ID
193     ///  of each cutie is actually an index into this array. ID 0 is the parent 
194     /// of all generation 0 cats, and both parents to itself. It is an invalid genetic code.
195     Cutie[] public cuties;
196 
197     /// @dev A mapping from cutie IDs to the address that owns them. All cuties have
198     ///  some valid owner address, even gen0 cuties are created with a non-zero owner.
199     mapping (uint40 => address) public cutieIndexToOwner;
200 
201     // @dev A mapping from owner address to count of tokens that address owns.
202     //  Used internally inside balanceOf() to resolve ownership count.
203     mapping (address => uint256) ownershipTokenCount;
204 
205     /// @dev A mapping from CutieIDs to an address that has been approved to call
206     ///  transferFrom(). A Cutie can have one approved address for transfer
207     ///  at any time. A zero value means that there is no outstanding approval.
208     mapping (uint40 => address) public cutieIndexToApproved;
209 
210     /// @dev A mapping from CutieIDs to an address that has been approved to use
211     ///  this Cutie for breeding via breedWith(). A Cutie can have one approved
212     ///  address for breeding at any time. A zero value means that there is no outstanding approval.
213     mapping (uint40 => address) public sireAllowedToAddress;
214 
215 
216     /// @dev The address of the Market contract used to sell cuties. This
217     ///  contract used both peer-to-peer sales and the gen0 sales that are
218     ///  initiated each 15 minutes.
219     MarketInterface public saleMarket;
220 
221     /// @dev The address of a custom Market subclassed contract used for breeding
222     ///  auctions. Is to be separated from saleMarket as the actions taken on success
223     ///  after a sales and breeding auction are quite different.
224     MarketInterface public breedingMarket;
225 
226 
227     // Modifiers to check that inputs can be safely stored with a certain
228     // number of bits.
229     modifier canBeStoredIn40Bits(uint256 _value) {
230         require(_value <= 0xFFFFFFFFFF);
231         _;
232     }    
233 
234     /// @notice Returns the total number of Cuties in existence.
235     /// @dev Required for ERC-721 compliance.
236     function totalSupply() external view returns (uint256)
237     {
238         return cuties.length - 1;
239     }
240 
241     /// @notice Returns the total number of Cuties in existence.
242     /// @dev Required for ERC-721 compliance.
243     function _totalSupply() internal view returns (uint256)
244     {
245         return cuties.length - 1;
246     }
247     
248     // Internal utility functions assume that their input arguments
249     // are valid. Public methods sanitize their inputs and follow
250     // the required logic.
251 
252     /// @dev Checks if a given address is the current owner of a certain Cutie.
253     /// @param _claimant the address we are validating against.
254     /// @param _cutieId cutie id, only valid when > 0
255     function _isOwner(address _claimant, uint40 _cutieId) internal view returns (bool)
256     {
257         return cutieIndexToOwner[_cutieId] == _claimant;
258     }
259 
260     /// @dev Checks if a given address currently has transferApproval for a certain Cutie.
261     /// @param _claimant the address we are confirming the cutie is approved for.
262     /// @param _cutieId cutie id, only valid when > 0
263     function _approvedFor(address _claimant, uint40 _cutieId) internal view returns (bool)
264     {
265         return cutieIndexToApproved[_cutieId] == _claimant;
266     }
267 
268     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
269     ///  approval. Setting _approved to address(0) clears all transfer approval.
270     ///  NOTE: _approve() does NOT send the Approval event. This is done on purpose:
271     ///  _approve() and transferFrom() are used together for putting Cuties on auction. 
272     ///  There is no value in spamming the log with Approval events in that case.
273     function _approve(uint40 _cutieId, address _approved) internal
274     {
275         cutieIndexToApproved[_cutieId] = _approved;
276     }
277 
278     /// @notice Returns the number of Cuties owned by a specific address.
279     /// @param _owner The owner address to check.
280     /// @dev Required for ERC-721 compliance
281     function balanceOf(address _owner) external view returns (uint256 count)
282     {
283         return ownershipTokenCount[_owner];
284     }
285 
286     /// @notice Transfers a Cutie to another address. When transferring to a smart
287     ///  contract, ensure that it is aware of ERC-721 (or
288     ///  BlockchainCuties specifically), otherwise the Cutie may be lost forever.
289     /// @param _to The address of the recipient, can be a user or contract.
290     /// @param _cutieId The ID of the Cutie to transfer.
291     /// @dev Required for ERC-721 compliance.
292     function transfer(address _to, uint256 _cutieId) external whenNotPaused canBeStoredIn40Bits(_cutieId)
293     {
294         // You can only send your own cutie.
295         require(_isOwner(msg.sender, uint40(_cutieId)));
296 
297         // Reassign ownership, clear pending approvals, emit Transfer event.
298         _transfer(msg.sender, _to, uint40(_cutieId));
299     }
300 
301     /// @notice Grant another address the right to transfer a perticular Cutie via transferFrom().
302     /// This flow is preferred for transferring NFTs to contracts.
303     /// @param _to The address to be granted transfer approval. Pass address(0) to clear all approvals.
304     /// @param _cutieId The ID of the Cutie that can be transferred if this call succeeds.
305     /// @dev Required for ERC-721 compliance.
306     function approve(address _to, uint256 _cutieId) external whenNotPaused canBeStoredIn40Bits(_cutieId)
307     {
308         // Only cutie's owner can grant transfer approval.
309         require(_isOwner(msg.sender, uint40(_cutieId)));
310 
311         // Registering approval replaces any previous approval.
312         _approve(uint40(_cutieId), _to);
313 
314         // Emit approval event.
315         emit Approval(msg.sender, _to, _cutieId);
316     }
317 
318     /// @notice Transfers the ownership of an NFT from one address to another address.
319     /// @dev Throws unless `msg.sender` is the current owner, an authorized
320     ///  operator, or the approved address for this NFT. Throws if `_from` is
321     ///  not the current owner. Throws if `_to` is the zero address. Throws if
322     ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
323     ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
324     ///  `onERC721Received` on `_to` and throws if the return value is not
325     ///  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
326     /// @param _from The current owner of the NFT
327     /// @param _to The new owner
328     /// @param _tokenId The NFT to transfer
329     /// @param data Additional data with no specified format, sent in call to `_to`
330     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) 
331         external whenNotPaused canBeStoredIn40Bits(_tokenId)
332     {
333         require(_to != address(0));
334         require(_to != address(this));
335         require(_to != address(saleMarket));
336         require(_to != address(breedingMarket));
337        
338         // Check for approval and valid ownership
339         require(_approvedFor(msg.sender, uint40(_tokenId)) || _isApprovedForAll(_from, msg.sender));
340         require(_isOwner(_from, uint40(_tokenId)));
341 
342         // Reassign ownership, clearing pending approvals and emitting Transfer event.
343         _transfer(_from, _to, uint40(_tokenId));
344         ERC721TokenReceiver (_to).onERC721Received(_from, _tokenId, data);
345     }
346 
347     /// @notice Transfers the ownership of an NFT from one address to another address
348     /// @dev This works identically to the other function with an extra data parameter,
349     ///  except this function just sets data to ""
350     /// @param _from The current owner of the NFT
351     /// @param _to The new owner
352     /// @param _tokenId The NFT to transfer
353     function safeTransferFrom(address _from, address _to, uint256 _tokenId) 
354         external whenNotPaused canBeStoredIn40Bits(_tokenId)
355     {
356         require(_to != address(0));
357         require(_to != address(this));
358         require(_to != address(saleMarket));
359         require(_to != address(breedingMarket));
360        
361         // Check for approval and valid ownership
362         require(_approvedFor(msg.sender, uint40(_tokenId)) || _isApprovedForAll(_from, msg.sender));
363         require(_isOwner(_from, uint40(_tokenId)));
364 
365         // Reassign ownership, clearing pending approvals and emitting Transfer event.
366         _transfer(_from, _to, uint40(_tokenId));
367     }
368 
369     /// @notice Transfer a Cutie owned by another address, for which the calling address
370     ///  has been granted transfer approval by the owner.
371     /// @param _from The address that owns the Cutie to be transfered.
372     /// @param _to Any address, including the caller address, can take ownership of the Cutie.
373     /// @param _tokenId The ID of the Cutie to be transferred.
374     /// @dev Required for ERC-721 compliance.
375     function transferFrom(address _from, address _to, uint256 _tokenId) 
376         external whenNotPaused canBeStoredIn40Bits(_tokenId) 
377     {
378         // Check for approval and valid ownership
379         require(_approvedFor(msg.sender, uint40(_tokenId)) || _isApprovedForAll(_from, msg.sender));
380         require(_isOwner(_from, uint40(_tokenId)));
381 
382         // Reassign ownership, clearing pending approvals and emitting Transfer event.
383         _transfer(_from, _to, uint40(_tokenId));
384     }
385 
386     /// @notice Returns the address currently assigned ownership of a given Cutie.
387     /// @dev Required for ERC-721 compliance.
388     function ownerOf(uint256 _cutieId)
389         external
390         view
391         canBeStoredIn40Bits(_cutieId)
392         returns (address owner)
393     {
394         owner = cutieIndexToOwner[uint40(_cutieId)];
395 
396         require(owner != address(0));
397     }
398 
399     /// @notice Returns the nth Cutie assigned to an address, with n specified by the
400     ///  _index argument.
401     /// @param _owner The owner of the Cuties we are interested in.
402     /// @param _index The zero-based index of the cutie within the owner's list of cuties.
403     ///  Must be less than balanceOf(_owner).
404     /// @dev This method must not be called by smart contract code. It will almost
405     ///  certainly blow past the block gas limit once there are a large number of
406     ///  Cuties in existence. Exists only to allow off-chain queries of ownership.
407     ///  Optional method for ERC-721.
408     function tokenOfOwnerByIndex(address _owner, uint256 _index)
409         external
410         view
411         returns (uint256 cutieId)
412     {
413         uint40 count = 0;
414         for (uint40 i = 1; i <= _totalSupply(); ++i) {
415             if (cutieIndexToOwner[i] == _owner) {
416                 if (count == _index) {
417                     return i;
418                 } else {
419                     count++;
420                 }
421             }
422         }
423         revert();
424     }
425 
426     /// @notice Enumerate valid NFTs
427     /// @dev Throws if `_index` >= `totalSupply()`.
428     /// @param _index A counter less than `totalSupply()`
429     /// @return The token identifier for the `_index`th NFT,
430     ///  (sort order not specified)
431     function tokenByIndex(uint256 _index) external pure returns (uint256)
432     {
433         return _index;
434     }
435 
436     /// @dev A mapping from Cuties owner (account) to an address that has been approved to call
437     ///  transferFrom() for all cuties, owned by owner.
438     ///  Only one approved address is permitted for each account for transfer
439     ///  at any time. A zero value means there is no outstanding approval.
440     mapping (address => address) public addressToApprovedAll;
441 
442     /// @notice Enable or disable approval for a third party ("operator") to manage
443     ///  all your asset.
444     /// @dev Emits the ApprovalForAll event
445     /// @param _operator Address to add to the set of authorized operators.
446     /// @param _approved True if the operators is approved, false to revoke approval
447     function setApprovalForAll(address _operator, bool _approved) external
448     {
449         if (_approved)
450         {
451             addressToApprovedAll[msg.sender] = _operator;
452         }
453         else
454         {
455             delete addressToApprovedAll[msg.sender];
456         }
457         emit ApprovalForAll(msg.sender, _operator, _approved);
458     }
459 
460     /// @notice Get the approved address for a single NFT
461     /// @dev Throws if `_tokenId` is not a valid NFT
462     /// @param _tokenId The NFT to find the approved address for
463     /// @return The approved address for this NFT, or the zero address if there is none
464     function getApproved(uint256 _tokenId) 
465         external view canBeStoredIn40Bits(_tokenId) 
466         returns (address)
467     {
468         require(_tokenId <= _totalSupply());
469 
470         if (cutieIndexToApproved[uint40(_tokenId)] != address(0))
471         {
472             return cutieIndexToApproved[uint40(_tokenId)];
473         }
474 
475         address owner = cutieIndexToOwner[uint40(_tokenId)];
476         return addressToApprovedAll[owner];
477     }
478 
479     /// @notice Query if an address is an authorized operator for another address
480     /// @param _owner The address that owns the NFTs
481     /// @param _operator The address that acts on behalf of the owner
482     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
483     function isApprovedForAll(address _owner, address _operator) external view returns (bool)
484     {
485         return addressToApprovedAll[_owner] == _operator;
486     }
487 
488     function _isApprovedForAll(address _owner, address _operator) internal view returns (bool)
489     {
490         return addressToApprovedAll[_owner] == _operator;
491     }
492 
493     /// @dev A lookup table that shows the cooldown duration after a successful
494     ///  breeding action, called "breeding cooldown". The cooldown roughly doubles each time
495     /// a cutie is bred, so that owners don't breed the same cutie continuously. Maximum cooldown is seven days.
496     uint32[14] public cooldowns = [
497         uint32(1 minutes),
498         uint32(2 minutes),
499         uint32(5 minutes),
500         uint32(10 minutes),
501         uint32(30 minutes),
502         uint32(1 hours),
503         uint32(2 hours),
504         uint32(4 hours),
505         uint32(8 hours),
506         uint32(16 hours),
507         uint32(1 days),
508         uint32(2 days),
509         uint32(4 days),
510         uint32(7 days)
511     ];
512 
513     function setCooldown(uint16 index, uint32 newCooldown) public onlyOwner
514     {
515         cooldowns[index] = newCooldown;
516     }
517 
518     /// @dev An internal method that creates a new cutie and stores it. This
519     ///  method does not check anything and should only be called when the
520     ///  input data is valid for sure. Will generate both a Birth event
521     ///  and a Transfer event.
522     /// @param _momId The cutie ID of the mom of this cutie (zero for gen0)
523     /// @param _dadId The cutie ID of the dad of this cutie (zero for gen0)
524     /// @param _generation The generation number of this cutie, must be computed by caller.
525     /// @param _genes The cutie's genetic code.
526     /// @param _owner The initial owner of this cutie, must be non-zero (except for the unCutie, ID 0)
527     function _createCutie(
528         uint40 _momId,
529         uint40 _dadId,
530         uint16 _generation,
531         uint256 _genes,
532         address _owner,
533         uint40 _birthTime
534     )
535         internal
536         returns (uint40)
537     {
538         // New cutie starts with the same cooldown as parent gen/2
539         uint16 cooldownIndex = uint16(_generation / 2);
540         if (cooldownIndex > cooldowns.length) {
541             cooldownIndex = uint16(cooldowns.length - 1);
542         }
543 
544         Cutie memory _cutie = Cutie({
545             genes: _genes, 
546             birthTime: _birthTime, 
547             cooldownEndTime: 0, 
548             momId: _momId, 
549             dadId: _dadId, 
550             cooldownIndex: cooldownIndex, 
551             generation: _generation,
552             optional: 0
553         });
554         uint256 newCutieId256 = cuties.push(_cutie) - 1;
555 
556         // Check if id can fit into 40 bits
557         require(newCutieId256 <= 0xFFFFFFFFFF);
558 
559         uint40 newCutieId = uint40(newCutieId256);
560 
561         // emit the birth event
562         emit Birth(_owner, newCutieId, _cutie.momId, _cutie.dadId, _cutie.genes);
563 
564         // This will assign ownership, as well as emit the Transfer event as
565         // per ERC721 draft
566         _transfer(0, _owner, newCutieId);
567 
568         return newCutieId;
569     }
570   
571     /// @notice Returns all the relevant information about a certain cutie.
572     /// @param _id The ID of the cutie of interest.
573     function getCutie(uint40 _id)
574         external
575         view
576         returns (
577         uint256 genes,
578         uint40 birthTime,
579         uint40 cooldownEndTime,
580         uint40 momId,
581         uint40 dadId,
582         uint16 cooldownIndex,
583         uint16 generation
584     ) {
585         Cutie storage cutie = cuties[_id];
586 
587         genes = cutie.genes;
588         birthTime = cutie.birthTime;
589         cooldownEndTime = cutie.cooldownEndTime;
590         momId = cutie.momId;
591         dadId = cutie.dadId;
592         cooldownIndex = cutie.cooldownIndex;
593         generation = cutie.generation;
594     }    
595     
596     /// @dev Assigns ownership of a particular Cutie to an address.
597     function _transfer(address _from, address _to, uint40 _cutieId) internal {
598         // since the number of cuties is capped to 2^40
599         // there is no way to overflow this
600         ownershipTokenCount[_to]++;
601         // transfer ownership
602         cutieIndexToOwner[_cutieId] = _to;
603         // When creating new cuties _from is 0x0, but we cannot account that address.
604         if (_from != address(0)) {
605             ownershipTokenCount[_from]--;
606             // once the cutie is transferred also clear breeding allowances
607             delete sireAllowedToAddress[_cutieId];
608             // clear any previously approved ownership exchange
609             delete cutieIndexToApproved[_cutieId];
610         }
611         // Emit the transfer event.
612         emit Transfer(_from, _to, _cutieId);
613     }
614 
615     /// @dev For transferring a cutie owned by this contract to the specified address.
616     ///  Used to rescue lost cuties. (There is no "proper" flow where this contract
617     ///  should be the owner of any Cutie. This function exists for us to reassign
618     ///  the ownership of Cuties that users may have accidentally sent to our address.)
619     /// @param _cutieId - ID of cutie
620     /// @param _recipient - Address to send the cutie to
621     function restoreCutieToAddress(uint40 _cutieId, address _recipient) public onlyOperator whenNotPaused {
622         require(_isOwner(this, _cutieId));
623         _transfer(this, _recipient, _cutieId);
624     }
625 
626     address ownerAddress;
627     address operatorAddress;
628 
629     bool public paused = false;
630 
631     modifier onlyOwner()
632     {
633         require(msg.sender == ownerAddress);
634         _;
635     }
636 
637     function setOwner(address _newOwner) public onlyOwner
638     {
639         require(_newOwner != address(0));
640 
641         ownerAddress = _newOwner;
642     }
643 
644     modifier onlyOperator() {
645         require(msg.sender == operatorAddress || msg.sender == ownerAddress);
646         _;
647     }
648 
649     function setOperator(address _newOperator) public onlyOwner {
650         require(_newOperator != address(0));
651 
652         operatorAddress = _newOperator;
653     }
654 
655     modifier whenNotPaused()
656     {
657         require(!paused);
658         _;
659     }
660 
661     modifier whenPaused
662     {
663         require(paused);
664         _;
665     }
666 
667     function pause() public onlyOwner whenNotPaused
668     {
669         paused = true;
670     }
671 
672     string public metadataUrlPrefix = "https://blockchaincuties.co/cutie/";
673     string public metadataUrlSuffix = ".svg";
674 
675     /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
676     /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
677     ///  3986. The URI may point to a JSON file that conforms to the "ERC721
678     ///  Metadata JSON Schema".
679     function tokenURI(uint256 _tokenId) external view returns (string infoUrl)
680     {
681         return 
682             concat(toSlice(metadataUrlPrefix), 
683                 toSlice(concat(toSlice(uintToString(_tokenId)), toSlice(metadataUrlSuffix))));
684     }
685 
686     function setMetadataUrl(string _metadataUrlPrefix, string _metadataUrlSuffix) public onlyOwner
687     {
688         metadataUrlPrefix = _metadataUrlPrefix;
689         metadataUrlSuffix = _metadataUrlSuffix;
690     }
691 
692 
693     mapping(address => PluginInterface) public plugins;
694     PluginInterface[] public pluginsArray;
695     mapping(uint40 => address) public usedSignes;
696     uint40 public minSignId;
697 
698     event GenesChanged(uint40 indexed cutieId, uint256 oldValue, uint256 newValue);
699     event CooldownEndTimeChanged(uint40 indexed cutieId, uint40 oldValue, uint40 newValue);
700     event CooldownIndexChanged(uint40 indexed cutieId, uint16 ololdValue, uint16 newValue);
701     event GenerationChanged(uint40 indexed cutieId, uint16 oldValue, uint16 newValue);
702     event OptionalChanged(uint40 indexed cutieId, uint64 oldValue, uint64 newValue);
703     event SignUsed(uint40 signId, address sender);
704     event MinSignSet(uint40 signId);
705 
706     /// @dev Sets the reference to the plugin contract.
707     /// @param _address - Address of plugin contract.
708     function addPlugin(address _address) public onlyOwner
709     {
710         PluginInterface candidateContract = PluginInterface(_address);
711 
712         // verify that a contract is what we expect
713         require(candidateContract.isPluginInterface());
714 
715         // Set the new contract address
716         plugins[_address] = candidateContract;
717         pluginsArray.push(candidateContract);
718     }
719 
720     /// @dev Remove plugin and calls onRemove to cleanup
721     function removePlugin(address _address) public onlyOwner
722     {
723         plugins[_address].onRemove();
724         delete plugins[_address];
725 
726         uint256 kindex = 0;
727         while (kindex < pluginsArray.length)
728         {
729             if (address(pluginsArray[kindex]) == _address)
730             {
731                 pluginsArray[kindex] = pluginsArray[pluginsArray.length-1];
732                 pluginsArray.length--;
733             }
734             else
735             {
736                 kindex++;
737             }
738         }
739     }
740 
741     /// @dev Put a cutie up for plugin feature.
742     function runPlugin(
743         address _pluginAddress,
744         uint40 _cutieId,
745         uint256 _parameter
746     )
747         public
748         whenNotPaused
749         payable
750     {
751         // If cutie is already on any auction or in adventure, this will throw
752         // because it will be owned by the other contract.
753         // If _cutieId is 0, then cutie is not used on this feature.
754         require(_cutieId == 0 || _isOwner(msg.sender, _cutieId));
755         require(address(plugins[_pluginAddress]) != address(0));
756         if (_cutieId > 0)
757         {
758             _approve(_cutieId, _pluginAddress);
759         }
760 
761         // Plugin contract throws if inputs are invalid and clears
762         // transfer after escrowing the cutie.
763         plugins[_pluginAddress].run.value(msg.value)(
764             _cutieId,
765             _parameter,
766             msg.sender
767         );
768     }
769 
770     /// @dev Called from plugin contract when using items as effect
771     function getGenes(uint40 _id)
772         public
773         view
774         returns (
775         uint256 genes
776     )
777     {
778         Cutie storage cutie = cuties[_id];
779         genes = cutie.genes;
780     }
781 
782     /// @dev Called from plugin contract when using items as effect
783     function changeGenes(
784         uint40 _cutieId,
785         uint256 _genes)
786         public
787         whenNotPaused
788     {
789         // if caller is registered plugin contract
790         require(address(plugins[msg.sender]) != address(0));
791 
792         Cutie storage cutie = cuties[_cutieId];
793         if (cutie.genes != _genes)
794         {
795             emit GenesChanged(_cutieId, cutie.genes, _genes);
796             cutie.genes = _genes;
797         }
798     }
799 
800     function getCooldownEndTime(uint40 _id)
801         public
802         view
803         returns (
804         uint40 cooldownEndTime
805     ) {
806         Cutie storage cutie = cuties[_id];
807 
808         cooldownEndTime = cutie.cooldownEndTime;
809     }
810 
811     function changeCooldownEndTime(
812         uint40 _cutieId,
813         uint40 _cooldownEndTime)
814         public
815         whenNotPaused
816     {
817         require(address(plugins[msg.sender]) != address(0));
818 
819         Cutie storage cutie = cuties[_cutieId];
820         if (cutie.cooldownEndTime != _cooldownEndTime)
821         {
822             emit CooldownEndTimeChanged(_cutieId, cutie.cooldownEndTime, _cooldownEndTime);
823             cutie.cooldownEndTime = _cooldownEndTime;
824         }
825     }
826 
827     function getCooldownIndex(uint40 _id)
828         public
829         view
830         returns (
831         uint16 cooldownIndex
832     ) {
833         Cutie storage cutie = cuties[_id];
834 
835         cooldownIndex = cutie.cooldownIndex;
836     }
837 
838     function changeCooldownIndex(
839         uint40 _cutieId,
840         uint16 _cooldownIndex)
841         public
842         whenNotPaused
843     {
844         require(address(plugins[msg.sender]) != address(0));
845 
846         Cutie storage cutie = cuties[_cutieId];
847         if (cutie.cooldownIndex != _cooldownIndex)
848         {
849             emit CooldownIndexChanged(_cutieId, cutie.cooldownIndex, _cooldownIndex);
850             cutie.cooldownIndex = _cooldownIndex;
851         }
852     }
853 
854     function changeGeneration(
855         uint40 _cutieId,
856         uint16 _generation)
857         public
858         whenNotPaused
859     {
860         require(address(plugins[msg.sender]) != address(0));
861 
862         Cutie storage cutie = cuties[_cutieId];
863         if (cutie.generation != _generation)
864         {
865             emit GenerationChanged(_cutieId, cutie.generation, _generation);
866             cutie.generation = _generation;
867         }
868     }
869 
870     function getGeneration(uint40 _id)
871         public
872         view
873         returns (uint16 generation)
874     {
875         Cutie storage cutie = cuties[_id];
876         generation = cutie.generation;
877     }
878 
879     function changeOptional(
880         uint40 _cutieId,
881         uint64 _optional)
882         public
883         whenNotPaused
884     {
885         require(address(plugins[msg.sender]) != address(0));
886 
887         Cutie storage cutie = cuties[_cutieId];
888         if (cutie.optional != _optional)
889         {
890             emit OptionalChanged(_cutieId, cutie.optional, _optional);
891             cutie.optional = _optional;
892         }
893     }
894 
895     function getOptional(uint40 _id)
896         public
897         view
898         returns (uint64 optional)
899     {
900         Cutie storage cutie = cuties[_id];
901         optional = cutie.optional;
902     }
903 
904     /// @dev Common function to be used also in backend
905     function hashArguments(
906         address _pluginAddress,
907         uint40 _signId,
908         uint40 _cutieId,
909         uint128 _value,
910         uint256 _parameter)
911         public pure returns (bytes32 msgHash)
912     {
913         msgHash = keccak256(_pluginAddress, _signId, _cutieId, _value, _parameter);
914     }
915 
916     /// @dev Common function to be used also in backend
917     function getSigner(
918         address _pluginAddress,
919         uint40 _signId,
920         uint40 _cutieId,
921         uint128 _value,
922         uint256 _parameter,
923         uint8 _v,
924         bytes32 _r,
925         bytes32 _s
926         )
927         public pure returns (address)
928     {
929         bytes32 msgHash = hashArguments(_pluginAddress, _signId, _cutieId, _value, _parameter);
930         return ecrecover(msgHash, _v, _r, _s);
931     }
932 
933     /// @dev Common function to be used also in backend
934     function isValidSignature(
935         address _pluginAddress,
936         uint40 _signId,
937         uint40 _cutieId,
938         uint128 _value,
939         uint256 _parameter,
940         uint8 _v,
941         bytes32 _r,
942         bytes32 _s
943         )
944         public
945         view
946         returns (bool)
947     {
948         return getSigner(_pluginAddress, _signId, _cutieId, _value, _parameter, _v, _r, _s) == operatorAddress;
949     }
950 
951     /// @dev Put a cutie up for plugin feature with signature.
952     ///  Can be used for items equip, item sales and other features.
953     ///  Signatures are generated by Operator role.
954     function runPluginSigned(
955         address _pluginAddress,
956         uint40 _signId,
957         uint40 _cutieId,
958         uint128 _value,
959         uint256 _parameter,
960         uint8 _v,
961         bytes32 _r,
962         bytes32 _s
963     )
964         public
965         whenNotPaused
966         payable
967     {
968         // If cutie is already on any auction or in adventure, this will throw
969         // as it will be owned by the other contract.
970         // If _cutieId is 0, then cutie is not used on this feature.
971         require(_cutieId == 0 || _isOwner(msg.sender, _cutieId));
972     
973         require(address(plugins[_pluginAddress]) != address(0));    
974 
975         require (usedSignes[_signId] == address(0));
976         require (_signId >= minSignId);
977         // value can also be zero for free calls
978         require (_value <= msg.value);
979 
980         require (isValidSignature(_pluginAddress, _signId, _cutieId, _value, _parameter, _v, _r, _s));
981         
982         usedSignes[_signId] = msg.sender;
983         emit SignUsed(_signId, msg.sender);
984 
985         // Plugin contract throws if inputs are invalid and clears
986         // transfer after escrowing the cutie.
987         plugins[_pluginAddress].runSigned.value(_value)(
988             _cutieId,
989             _parameter,
990             msg.sender
991         );
992     }
993 
994     /// @dev Sets minimal signId, than can be used.
995     ///       All unused signatures less than signId will be cancelled on off-chain server
996     ///       and unused items will be transfered back to owner.
997     function setMinSign(uint40 _newMinSignId)
998         public
999         onlyOperator
1000     {
1001         require (_newMinSignId > minSignId);
1002         minSignId = _newMinSignId;
1003         emit MinSignSet(minSignId);
1004     }
1005 
1006 
1007     event BreedingApproval(address indexed _owner, address indexed _approved, uint256 _tokenId);
1008 
1009     // Set in case the core contract is broken and an upgrade is required
1010     address public upgradedContractAddress;
1011 
1012     function isCutieCore() pure public returns (bool) { return true; }
1013 
1014     /// @notice Creates the main BlockchainCuties smart contract instance.
1015     function BlockchainCutiesCore() public
1016     {
1017         // Starts paused.
1018         paused = true;
1019 
1020         // the creator of the contract is the initial owner
1021         ownerAddress = msg.sender;
1022 
1023         // the creator of the contract is also the initial operator
1024         operatorAddress = msg.sender;
1025 
1026         // start with the mythical cutie 0 - so there are no generation-0 parent issues
1027         _createCutie(0, 0, 0, uint256(-1), address(0), 0);
1028     }
1029 
1030     event ContractUpgrade(address newContract);
1031 
1032     /// @dev Aimed to mark the smart contract as upgraded if there is a crucial
1033     ///  bug. This keeps track of the new contract and indicates that the new address is set. 
1034     /// Updating to the new contract address is up to the clients. (This contract will
1035     ///  be paused indefinitely if such an upgrade takes place.)
1036     /// @param _newAddress new address
1037     function setUpgradedAddress(address _newAddress) public onlyOwner whenPaused
1038     {
1039         require(_newAddress != address(0));
1040         upgradedContractAddress = _newAddress;
1041         emit ContractUpgrade(upgradedContractAddress);
1042     }
1043 
1044     /// @dev Override unpause so it requires upgradedContractAddress not set, because then the contract was upgraded.
1045     function unpause() public onlyOwner whenPaused
1046     {
1047         require(upgradedContractAddress == address(0));
1048 
1049         paused = false;
1050     }
1051 
1052     // Counts the number of cuties the contract owner has created.
1053     uint40 public promoCutieCreatedCount;
1054     uint40 public gen0CutieCreatedCount;
1055     uint40 public gen0Limit = 50000;
1056     uint40 public promoLimit = 5000;
1057 
1058     /// @dev Creates a new gen0 cutie with the given genes and
1059     ///  creates an auction for it.
1060     function createGen0Auction(uint256 _genes, uint128 startPrice, uint128 endPrice, uint40 duration) public onlyOperator
1061     {
1062         require(gen0CutieCreatedCount < gen0Limit);
1063         uint40 cutieId = _createCutie(0, 0, 0, _genes, address(this), uint40(now));
1064         _approve(cutieId, saleMarket);
1065 
1066         saleMarket.createAuction(
1067             cutieId,
1068             startPrice,
1069             endPrice,
1070             duration,
1071             address(this)
1072         );
1073 
1074         gen0CutieCreatedCount++;
1075     }
1076 
1077     function createPromoCutie(uint256 _genes, address _owner) public onlyOperator
1078     {
1079         require(promoCutieCreatedCount < promoLimit);
1080         if (_owner == address(0)) {
1081              _owner = operatorAddress;
1082         }
1083         promoCutieCreatedCount++;
1084         gen0CutieCreatedCount++;
1085         _createCutie(0, 0, 0, _genes, _owner, uint40(now));
1086     }
1087 
1088     /// @dev Put a cutie up for auction to be dad.
1089     ///  Performs checks to ensure the cutie can be dad, then
1090     ///  delegates to reverse auction.
1091     ///  Optional money amount can be sent to contract to feature auction.
1092     ///  Pricea are available on web.
1093     function createBreedingAuction(
1094         uint40 _cutieId,
1095         uint128 _startPrice,
1096         uint128 _endPrice,
1097         uint40 _duration
1098     )
1099         public
1100         whenNotPaused
1101         payable
1102     {
1103         // Auction contract checks input sizes
1104         // If cutie is already on any auction, this will throw
1105         // because it will be owned by the auction contract.
1106         require(_isOwner(msg.sender, _cutieId));
1107         require(canBreed(_cutieId));
1108         _approve(_cutieId, breedingMarket);
1109         // breeding auction function is called if inputs are invalid and clears
1110         // transfer and sire approval after escrowing the cutie.
1111         breedingMarket.createAuction.value(msg.value)(
1112             _cutieId,
1113             _startPrice,
1114             _endPrice,
1115             _duration,
1116             msg.sender
1117         );
1118     }
1119 
1120     /// @dev Sets the reference to the breeding auction.
1121     /// @param _breedingAddress - Address of breeding market contract.
1122     /// @param _saleAddress - Address of sale market contract.
1123     function setMarketAddress(address _breedingAddress, address _saleAddress) public onlyOwner
1124     {
1125         //require(address(breedingMarket) == address(0));
1126         //require(address(saleMarket) == address(0));
1127 
1128         breedingMarket = MarketInterface(_breedingAddress);
1129         saleMarket = MarketInterface(_saleAddress);
1130     }
1131 
1132     /// @dev Completes a breeding auction by bidding.
1133     ///  Immediately breeds the winning mom with the dad on auction.
1134     /// @param _dadId - ID of the dad on auction.
1135     /// @param _momId - ID of the mom owned by the bidder.
1136     function bidOnBreedingAuction(
1137         uint40 _dadId,
1138         uint40 _momId
1139     )
1140         public
1141         payable
1142         whenNotPaused
1143         returns (uint256)
1144     {
1145         // Auction contract checks input sizes
1146         require(_isOwner(msg.sender, _momId));
1147         require(canBreed(_momId));
1148         require(_canMateViaMarketplace(_momId, _dadId));
1149 
1150         // breeding auction will throw if the bid fails.
1151         breedingMarket.bid.value(msg.value)(_dadId);
1152         return _breedWith(_momId, _dadId);
1153     }
1154 
1155     /// @dev Put a cutie up for auction.
1156     ///  Does some ownership trickery for creating auctions in one transaction.
1157     ///  Optional money amount can be sent to contract to feature auction.
1158     ///  Pricea are available on web.
1159     function createSaleAuction(
1160         uint40 _cutieId,
1161         uint128 _startPrice,
1162         uint128 _endPrice,
1163         uint40 _duration
1164     )
1165         public
1166         whenNotPaused
1167         payable
1168     {
1169         // Auction contract checks input sizes
1170         // If cutie is already on any auction, this will throw
1171         // because it will be owned by the auction contract.
1172         require(_isOwner(msg.sender, _cutieId));
1173         _approve(_cutieId, saleMarket);
1174         // Sale auction throws if inputs are invalid and clears
1175         // transfer and sire approval after escrowing the cutie.
1176         saleMarket.createAuction.value(msg.value)(
1177             _cutieId,
1178             _startPrice,
1179             _endPrice,
1180             _duration,
1181             msg.sender
1182         );
1183     }
1184 
1185     /// @dev The address of the sibling contract that is used to implement the genetic combination algorithm.
1186     GeneMixerInterface geneMixer;
1187 
1188     /// @dev Check if dad has authorized breeding with the mom. True if both dad
1189     ///  and mom have the same owner, or if the dad has given breeding permission to
1190     ///  the mom's owner (via approveBreeding()).
1191     function _isBreedingPermitted(uint40 _dadId, uint40 _momId) internal view returns (bool)
1192     {
1193         address momOwner = cutieIndexToOwner[_momId];
1194         address dadOwner = cutieIndexToOwner[_dadId];
1195 
1196         // Breeding is approved if they have same owner, or if the mom's owner was given
1197         // permission to breed with the dad.
1198         return (momOwner == dadOwner || sireAllowedToAddress[_dadId] == momOwner);
1199     }
1200 
1201     /// @dev Update the address of the genetic contract.
1202     /// @param _address An address of a GeneMixer contract instance to be used from this point forward.
1203     function setGeneMixerAddress(address _address) public onlyOwner
1204     {
1205         GeneMixerInterface candidateContract = GeneMixerInterface(_address);
1206 
1207         require(candidateContract.isGeneMixer());
1208 
1209         // Set the new contract address
1210         geneMixer = candidateContract;
1211     }
1212 
1213     /// @dev Checks that a given cutie is able to breed. Requires that the
1214     ///  current cooldown is finished (for dads)
1215     function _canBreed(Cutie _cutie) internal view returns (bool)
1216     {
1217         return _cutie.cooldownEndTime <= now;
1218     }
1219 
1220     /// @notice Grants approval to another user to sire with one of your Cuties.
1221     /// @param _addr The address that will be able to sire with your Cutie. Set to
1222     ///  address(0) to clear all breeding approvals for this Cutie.
1223     /// @param _dadId A Cutie that you own that _addr will now be able to dad with.
1224     function approveBreeding(address _addr, uint40 _dadId) public whenNotPaused
1225     {
1226         require(_isOwner(msg.sender, _dadId));
1227         sireAllowedToAddress[_dadId] = _addr;
1228         emit BreedingApproval(msg.sender, _addr, _dadId);
1229     }
1230 
1231     /// @dev Set the cooldownEndTime for the given Cutie, based on its current cooldownIndex.
1232     ///  Also increments the cooldownIndex (unless it has hit the cap).
1233     /// @param _cutie A reference to the Cutie in storage which needs its timer started.
1234     function _triggerCooldown(uint40 _cutieId, Cutie storage _cutie) internal
1235     {
1236         // Compute the end of the cooldown time, based on current cooldownIndex
1237         uint40 oldValue = _cutie.cooldownIndex;
1238         _cutie.cooldownEndTime = uint40(now + cooldowns[_cutie.cooldownIndex]);
1239         emit CooldownEndTimeChanged(_cutieId, oldValue, _cutie.cooldownEndTime);
1240 
1241         // Increment the breeding count.
1242         if (_cutie.cooldownIndex + 1 < cooldowns.length) {
1243             uint16 oldValue2 = _cutie.cooldownIndex;
1244             _cutie.cooldownIndex++;
1245             emit CooldownIndexChanged(_cutieId, oldValue2, _cutie.cooldownIndex);
1246         }
1247     }
1248 
1249     /// @notice Checks that a certain cutie is not
1250     ///  in the middle of a breeding cooldown and is able to breed.
1251     /// @param _cutieId reference the id of the cutie, any user can inquire about it
1252     function canBreed(uint40 _cutieId)
1253         public
1254         view
1255         returns (bool)
1256     {
1257         require(_cutieId > 0);
1258         Cutie storage cutie = cuties[_cutieId];
1259         return _canBreed(cutie);
1260     }
1261 
1262     /// @dev Check if given mom and dad are a valid mating pair.
1263     function _canPairMate(
1264         Cutie storage _mom,
1265         uint40 _momId,
1266         Cutie storage _dad,
1267         uint40 _dadId
1268     )
1269         private
1270         view
1271         returns(bool)
1272     {
1273         // A Cutie can't breed with itself.
1274         if (_dadId == _momId) { 
1275             return false; 
1276         }
1277 
1278         // Cuties can't breed with their parents.
1279         if (_mom.momId == _dadId) {
1280             return false;
1281         }
1282         if (_mom.dadId == _dadId) {
1283             return false;
1284         }
1285 
1286         if (_dad.momId == _momId) {
1287             return false;
1288         }
1289         if (_dad.dadId == _momId) {
1290             return false;
1291         }
1292 
1293         // We can short circuit the sibling check (below) if either cat is
1294         // gen zero (has a mom ID of zero).
1295         if (_dad.momId == 0) {
1296             return true;
1297         }
1298         if (_mom.momId == 0) {
1299             return true;
1300         }
1301 
1302         // Cuties can't breed with full or half siblings.
1303         if (_dad.momId == _mom.momId) {
1304             return false;
1305         }
1306         if (_dad.momId == _mom.dadId) {
1307             return false;
1308         }
1309         if (_dad.dadId == _mom.momId) {
1310             return false;
1311         }
1312         if (_dad.dadId == _mom.dadId) {
1313             return false;
1314         }
1315 
1316         if (geneMixer.canBreed(_momId, _mom.genes, _dadId, _dad.genes)) {
1317             return true;
1318         }
1319         return false;
1320     }
1321 
1322     /// @notice Checks to see if two cuties can breed together (checks both
1323     ///  ownership and breeding approvals, but does not check if both cuties are ready for
1324     ///  breeding).
1325     /// @param _momId The ID of the proposed mom.
1326     /// @param _dadId The ID of the proposed dad.
1327     function canBreedWith(uint40 _momId, uint40 _dadId)
1328         public
1329         view
1330         returns(bool)
1331     {
1332         require(_momId > 0);
1333         require(_dadId > 0);
1334         Cutie storage mom = cuties[_momId];
1335         Cutie storage dad = cuties[_dadId];
1336         return _canPairMate(mom, _momId, dad, _dadId) && _isBreedingPermitted(_dadId, _momId);
1337     }
1338     
1339     /// @dev Internal check to see if a given dad and mom are a valid mating pair for
1340     ///  breeding via market (this method doesn't check ownership and if mating is allowed).
1341     function _canMateViaMarketplace(uint40 _momId, uint40 _dadId)
1342         internal
1343         view
1344         returns (bool)
1345     {
1346         Cutie storage mom = cuties[_momId];
1347         Cutie storage dad = cuties[_dadId];
1348         return _canPairMate(mom, _momId, dad, _dadId);
1349     }
1350 
1351     /// @notice Breed cuties that you own, or for which you
1352     ///  have previously been given Breeding approval. Will either make your cutie give birth, or will
1353     ///  fail.
1354     /// @param _momId The ID of the Cutie acting as mom (will end up give birth if successful)
1355     /// @param _dadId The ID of the Cutie acting as dad (will begin its breeding cooldown if successful)
1356     function breedWith(uint40 _momId, uint40 _dadId) public whenNotPaused returns (uint40)
1357     {
1358         // Caller must own the mom.
1359         require(_isOwner(msg.sender, _momId));
1360 
1361         // Neither dad nor mom can be on auction during
1362         // breeding.
1363         // For mom: The caller of this function can't be the owner of the mom
1364         //   because the owner of a Cutie on auction is the auction house, and the
1365         //   auction house will never call breedWith().
1366         // For dad: Similarly, a dad on auction will be owned by the auction house
1367         //   and the act of transferring ownership will have cleared any outstanding
1368         //   breeding approval.
1369         // Thus we don't need check if either cutie
1370         // is on auction.
1371 
1372         // Check that mom and dad are both owned by caller, or that the dad
1373         // has given breeding permission to caller (i.e. mom's owner).
1374         // Will fail for _dadId = 0
1375         require(_isBreedingPermitted(_dadId, _momId));
1376 
1377         // Grab a reference to the potential mom
1378         Cutie storage mom = cuties[_momId];
1379 
1380         // Make sure mom's cooldown isn't active, or in the middle of a breeding cooldown
1381         require(_canBreed(mom));
1382 
1383         // Grab a reference to the potential dad
1384         Cutie storage dad = cuties[_dadId];
1385 
1386         // Make sure dad cooldown isn't active, or in the middle of a breeding cooldown
1387         require(_canBreed(dad));
1388 
1389         // Test that these cuties are a valid mating pair.
1390         require(_canPairMate(
1391             mom,
1392             _momId,
1393             dad,
1394             _dadId
1395         ));
1396 
1397         return _breedWith(_momId, _dadId);
1398     }
1399 
1400     /// @dev Internal utility function to start breeding, assumes that all breeding
1401     ///  requirements have been checked.
1402     function _breedWith(uint40 _momId, uint40 _dadId) internal returns (uint40)
1403     {
1404         // Grab a reference to the Cuties from storage.
1405         Cutie storage dad = cuties[_dadId];
1406         Cutie storage mom = cuties[_momId];
1407 
1408         // Trigger the cooldown for both parents.
1409         _triggerCooldown(_dadId, dad);
1410         _triggerCooldown(_momId, mom);
1411 
1412         // Clear breeding permission for both parents.
1413         delete sireAllowedToAddress[_momId];
1414         delete sireAllowedToAddress[_dadId];
1415 
1416         // Check that the mom is a valid cutie.
1417         require(mom.birthTime != 0);
1418 
1419         // Determine the higher generation number of the two parents
1420         uint16 parentGen = mom.generation;
1421         if (dad.generation > mom.generation) {
1422             parentGen = dad.generation;
1423         }
1424 
1425         // Call the gene mixing operation.
1426         uint256 childGenes = geneMixer.mixGenes(mom.genes, dad.genes);
1427 
1428         // Make the new cutie
1429         address owner = cutieIndexToOwner[_momId];
1430         uint40 cutieId = _createCutie(_momId, _dadId, parentGen + 1, childGenes, owner, mom.cooldownEndTime);
1431 
1432         // return the new cutie's ID
1433         return cutieId;
1434     }
1435 
1436     mapping(address => uint40) isTutorialPetUsed;
1437 
1438     /// @dev Completes a breeding tutorial cutie (non existing in blockchain)
1439     ///  with auction by bidding. Immediately breeds with dad on auction.
1440     /// @param _dadId - ID of the dad on auction.
1441     function bidOnBreedingAuctionTutorial(
1442         uint40 _dadId
1443     )
1444         public
1445         payable
1446         whenNotPaused
1447         returns (uint)
1448     {
1449         require(isTutorialPetUsed[msg.sender] == 0);
1450 
1451         // breeding auction will throw if the bid fails.
1452         breedingMarket.bid.value(msg.value)(_dadId);
1453 
1454         // Grab a reference to the Cuties from storage.
1455         Cutie storage dad = cuties[_dadId];
1456 
1457         // Trigger the cooldown for parent.
1458         _triggerCooldown(_dadId, dad);
1459 
1460         // Clear breeding permission for parent.
1461         delete sireAllowedToAddress[_dadId];
1462 
1463         // Tutorial pet gen is 26
1464         uint16 parentGen = 26;
1465         if (dad.generation > parentGen) {
1466             parentGen = dad.generation;
1467         }
1468 
1469         // tutorial pet genome is zero
1470         uint256 childGenes = geneMixer.mixGenes(0x0, dad.genes);
1471 
1472         // tutorial pet id is zero
1473         uint40 cutieId = _createCutie(0, _dadId, parentGen + 1, childGenes, msg.sender, 12);
1474 
1475         isTutorialPetUsed[msg.sender] = cutieId;
1476 
1477         // return the new cutie's ID
1478         return cutieId;
1479     }
1480 
1481     address party1address;
1482     address party2address;
1483     address party3address;
1484     address party4address;
1485     address party5address;
1486 
1487     /// @dev Setup project owners
1488     function setParties(address _party1, address _party2, address _party3, address _party4, address _party5) public onlyOwner
1489     {
1490         require(_party1 != address(0));
1491         require(_party2 != address(0));
1492         require(_party3 != address(0));
1493         require(_party4 != address(0));
1494         require(_party5 != address(0));
1495 
1496         party1address = _party1;
1497         party2address = _party2;
1498         party3address = _party3;
1499         party4address = _party4;
1500         party5address = _party5;
1501     }
1502 
1503     /// @dev Reject all Ether which is not from game contracts from being sent here.
1504     function() external payable {
1505         require(
1506             msg.sender == address(saleMarket) ||
1507             msg.sender == address(breedingMarket) ||
1508             address(plugins[msg.sender]) != address(0)
1509         );
1510     }
1511 
1512     /// @dev The balance transfer from the market and plugins contract
1513     /// to the CutieCore contract.
1514     function withdrawBalances() external
1515     {
1516         require(
1517             msg.sender == ownerAddress || 
1518             msg.sender == operatorAddress);
1519 
1520         saleMarket.withdrawEthFromBalance();
1521         breedingMarket.withdrawEthFromBalance();
1522         for (uint32 i = 0; i < pluginsArray.length; ++i)        
1523         {
1524             pluginsArray[i].withdraw();
1525         }
1526     }
1527 
1528     /// @dev The balance transfer from CutieCore contract to project owners
1529     function withdrawEthFromBalance() external
1530     {
1531         require(
1532             msg.sender == party1address ||
1533             msg.sender == party2address ||
1534             msg.sender == party3address ||
1535             msg.sender == party4address ||
1536             msg.sender == party5address ||
1537             msg.sender == ownerAddress || 
1538             msg.sender == operatorAddress);
1539 
1540         require(party1address != 0);
1541         require(party2address != 0);
1542         require(party3address != 0);
1543         require(party4address != 0);
1544         require(party5address != 0);
1545 
1546         uint256 total = address(this).balance;
1547 
1548         party1address.transfer(total*105/1000);
1549         party2address.transfer(total*105/1000);
1550         party3address.transfer(total*140/1000);
1551         party4address.transfer(total*140/1000);
1552         party5address.transfer(total*510/1000);
1553     }
1554 
1555 /*
1556  * @title String & slice utility library for Solidity contracts.
1557  * @author Nick Johnson <arachnid@notdot.net>
1558  *
1559  * @dev Functionality in this library is largely implemented using an
1560  *      abstraction called a 'slice'. A slice represents a part of a string -
1561  *      anything from the entire string to a single character, or even no
1562  *      characters at all (a 0-length slice). Since a slice only has to specify
1563  *      an offset and a length, copying and manipulating slices is a lot less
1564  *      expensive than copying and manipulating the strings they reference.
1565  *
1566  *      To further reduce gas costs, most functions on slice that need to return
1567  *      a slice modify the original one instead of allocating a new one; for
1568  *      instance, `s.split(".")` will return the text up to the first '.',
1569  *      modifying s to only contain the remainder of the string after the '.'.
1570  *      In situations where you do not want to modify the original slice, you
1571  *      can make a copy first with `.copy()`, for example:
1572  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
1573  *      Solidity has no memory management, it will result in allocating many
1574  *      short-lived slices that are later discarded.
1575  *
1576  *      Functions that return two slices come in two versions: a non-allocating
1577  *      version that takes the second slice as an argument, modifying it in
1578  *      place, and an allocating version that allocates and returns the second
1579  *      slice; see `nextRune` for example.
1580  *
1581  *      Functions that have to copy string data will return strings rather than
1582  *      slices; these can be cast back to slices for further processing if
1583  *      required.
1584  *
1585  *      For convenience, some functions are provided with non-modifying
1586  *      variants that create a new slice and return both; for instance,
1587  *      `s.splitNew('.')` leaves s unmodified, and returns two values
1588  *      corresponding to the left and right parts of the string.
1589  */
1590 
1591     struct slice
1592     {
1593         uint _len;
1594         uint _ptr;
1595     }
1596 
1597     /*
1598      * @dev Returns a slice containing the entire string.
1599      * @param self The string to make a slice from.
1600      * @return A newly allocated slice containing the entire string.
1601      */
1602     function toSlice(string self) internal pure returns (slice)
1603     {
1604         uint ptr;
1605         assembly {
1606             ptr := add(self, 0x20)
1607         }
1608         return slice(bytes(self).length, ptr);
1609     }
1610 
1611     function memcpy(uint dest, uint src, uint len) private pure
1612     {
1613         // Copy word-length chunks while possible
1614         for(; len >= 32; len -= 32) {
1615             assembly {
1616                 mstore(dest, mload(src))
1617             }
1618             dest += 32;
1619             src += 32;
1620         }
1621 
1622         // Copy remaining bytes
1623         uint mask = 256 ** (32 - len) - 1;
1624         assembly {
1625             let srcpart := and(mload(src), not(mask))
1626             let destpart := and(mload(dest), mask)
1627             mstore(dest, or(destpart, srcpart))
1628         }
1629     }
1630 
1631     /*
1632      * @dev Returns a newly allocated string containing the concatenation of
1633      *      `self` and `other`.
1634      * @param self The first slice to concatenate.
1635      * @param other The second slice to concatenate.
1636      * @return The concatenation of the two strings.
1637      */
1638     function concat(slice self, slice other) internal pure returns (string)
1639     {
1640         string memory ret = new string(self._len + other._len);
1641         uint retptr;
1642         assembly { retptr := add(ret, 32) }
1643         memcpy(retptr, self._ptr, self._len);
1644         memcpy(retptr + self._len, other._ptr, other._len);
1645         return ret;
1646     }
1647 
1648 
1649     function uintToString(uint256 a) internal pure returns (string result)
1650     {
1651         string memory r = "";
1652         do
1653         {
1654             uint b = a % 10;
1655             a /= 10;
1656 
1657             string memory c = "";
1658 
1659             if (b == 0) c = "0";
1660             else if (b == 1) c = "1";
1661             else if (b == 2) c = "2";
1662             else if (b == 3) c = "3";
1663             else if (b == 4) c = "4";
1664             else if (b == 5) c = "5";
1665             else if (b == 6) c = "6";
1666             else if (b == 7) c = "7";
1667             else if (b == 8) c = "8";
1668             else if (b == 9) c = "9";
1669 
1670             r = concat(toSlice(c), toSlice(r));
1671         }
1672         while (a > 0);
1673         result = r;
1674     }
1675 }