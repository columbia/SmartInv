1 // CryptoPuppies Source code
2 // Copied from: https://etherscan.io/address/0x06012c8cf97bead5deae237070f9587f8e7a266d#code
3 
4 pragma solidity ^0.4.11;
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) onlyOwner {
38     if (newOwner != address(0)) {
39       owner = newOwner;
40     }
41   }
42 
43 }
44 
45 
46 
47 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
48 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
49 contract ERC721 {
50     // Required methods
51     function totalSupply() public view returns (uint256 total);
52     function balanceOf(address _owner) public view returns (uint256 balance);
53     function ownerOf(uint256 _tokenId) external view returns (address owner);
54     function approve(address _to, uint256 _tokenId) external;
55     function transfer(address _to, uint256 _tokenId) external;
56     function transferFrom(address _from, address _to, uint256 _tokenId) external;
57 
58     // Events
59     event Transfer(address from, address to, uint256 tokenId);
60     event Approval(address owner, address approved, uint256 tokenId);
61 
62     // Optional
63     // function name() public view returns (string name);
64     // function symbol() public view returns (string symbol);
65     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
66     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
67 
68     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
69     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
70 }
71 
72 
73 // // Auction wrapper functions
74 
75 
76 // Auction wrapper functions
77 
78 
79 /// @title SEKRETOOOO
80 contract GeneScience {
81     /// @dev simply a boolean to indicate this is the contract we expect to be
82     function isGeneScience() public pure returns (bool);
83 
84     /// @dev given genes of puppies 1 & 2, return a genetic combination - may have a random factor
85     /// @param genes1 genes of mom
86     /// @param genes2 genes of sire
87     /// @return the genes that are supposed to be passed down the child
88     function mixGenes(uint256 genes1, uint256 genes2, uint256 targetBlock) public returns (uint256);
89 }
90 
91 /// @title Puppy sports contract
92 contract PuppySports {
93     /// @dev simply a boolean to indipuppye this is the contract we expect to be
94     function isPuppySports() public pure returns (bool);
95 
96     /// @dev contract that provides gaming functionality
97     /// @param puppyId - id of the puppy
98     /// @param gameId - id of the game
99     /// @param targetBlock - proof of randomness
100     /// @return true if puppy won the game, false otherwise
101     function playGame(uint256 puppyId, uint256 gameId, uint256 targetBlock) public returns (bool);
102 }
103 
104 
105 /// @title A facet of PuppiesCore that manages special access privileges.
106 /// @author SmartFoxLabs
107 /// @dev See the PuppiesCore contract documentation to understand how the various contract facets are arranged.
108 contract PuppyAccessControl {
109     // This facet controls access control for CryptoPuppies. There are four roles managed here:
110     //
111     //     - The CEO: The CEO can reassign other roles and change the addresses of our dependent smart
112     //         contracts. It is also the only role that can unpause the smart contract. It is initially
113     //         set to the address that created the smart contract in the PuppiesCore constructor.
114     //
115     //     - The CFO: The CFO can withdraw funds from PuppiesCore and its auction contracts.
116     //
117     //     - The COO: The COO can release gen0 puppies to auction, and mint promo puppys.
118     //
119     // It should be noted that these roles are distinct without overlap in their access abilities, the
120     // abilities listed for each role above are exhaustive. In particular, while the CEO can assign any
121     // address to any role, the CEO address itself doesn't have the ability to act in those roles. This
122     // restriction is intentional so that we aren't tempted to use the CEO address frequently out of
123     // convenience. The less we use an address, the less likely it is that we somehow compromise the
124     // account.
125 
126     /// @dev Emited when contract is upgraded - See README.md for updgrade plan
127     event ContractUpgrade(address newContract);
128 
129     // The addresses of the accounts (or contracts) that can execute actions within each roles.
130     address public ceoAddress;
131     address public cfoAddress;
132     address public cooAddress;
133 
134     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
135     bool public paused = false;
136 
137     /// @dev Access modifier for CEO-only functionality
138     modifier onlyCEO() {
139         require(msg.sender == ceoAddress);
140         _;
141     }
142 
143     /// @dev Access modifier for CFO-only functionality
144     modifier onlyCFO() {
145         require(msg.sender == cfoAddress);
146         _;
147     }
148 
149     /// @dev Access modifier for COO-only functionality
150     modifier onlyCOO() {
151         require(msg.sender == cooAddress);
152         _;
153     }
154 
155     modifier onlyCLevel() {
156         require(msg.sender == cooAddress || msg.sender == ceoAddress || msg.sender == cfoAddress);
157         _;
158     }
159 
160     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
161     /// @param _newCEO The address of the new CEO
162     function setCEO(address _newCEO) external onlyCEO {
163         require(_newCEO != address(0));
164 
165         ceoAddress = _newCEO;
166     }
167 
168     /// @dev Assigns a new address to act as the CFO. Only available to the current CEO.
169     /// @param _newCFO The address of the new CFO
170     function setCFO(address _newCFO) external onlyCEO {
171         require(_newCFO != address(0));
172 
173         cfoAddress = _newCFO;
174     }
175 
176     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
177     /// @param _newCOO The address of the new COO
178     function setCOO(address _newCOO) external onlyCEO {
179         require(_newCOO != address(0));
180 
181         cooAddress = _newCOO;
182     }
183 
184     /*** Pausable functionality adapted from OpenZeppelin ***/
185 
186     /// @dev Modifier to allow actions only when the contract IS NOT paused
187     modifier whenNotPaused() {
188         require(!paused);
189         _;
190     }
191 
192     /// @dev Modifier to allow actions only when the contract IS paused
193     modifier whenPaused {
194         require(paused);
195         _;
196     }
197 
198     /// @dev Called by any "C-level" role to pause the contract. Used only when
199     ///  a bug or exploit is detected and we need to limit damage.
200     function pause() external onlyCLevel whenNotPaused {
201         paused = true;
202     }
203 
204     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
205     ///  one reason we may pause the contract is when CFO or COO accounts are
206     ///  compromised.
207     /// @notice This is public rather than external so it can be called by
208     ///  derived contracts.
209     function unpause() public onlyCEO whenPaused {
210         // can't unpause if contract was upgraded
211         paused = false;
212     }
213 }
214 
215 /// @title Base contract for CryptoPuppies. Holds all common structs, events and base variables.
216 /// @author Axiom Zen (https://www.axiomzen.co)
217 /// @dev See the PuppiesCore contract documentation to understand how the various contract facets are arranged.
218 contract PuppyBase is PuppyAccessControl {
219     /*** EVENTS ***/
220 
221     /// @dev The Birth event is fired whenever a new puppy comes into existence. This obviously
222     ///  includes any time a puppy is created through the giveBirth method, but it is also called
223     ///  when a new gen0 puppy is created.
224     event Birth(address owner, uint256 puppyId, uint256 matronId, uint256 sireId, uint256 genes);
225 
226     /// @dev Transfer event as defined in current draft of ERC721. Emitted every time a puppy
227     ///  ownership is assigned, including births.
228     event Transfer(address from, address to, uint256 tokenId);
229 
230     /*** DATA TYPES ***/
231 
232     /// @dev The main Puppy struct. Every puppy in CryptoPuppies is represented by a copy
233     ///  of this structure, so great care was taken to ensure that it fits neatly into
234     ///  exactly two 256-bit words. Note that the order of the members in this structure
235     ///  is important because of the byte-packing rules used by Ethereum.
236     ///  Ref: http://solidity.readthedocs.io/en/develop/miscellaneous.html
237     struct Puppy {
238         // The Puppy's genetic code is packed into these 256-bits, the format is
239         // sooper-sekret! A puppy's genes never change.
240         uint256 genes;
241 
242         // The timestamp from the block when this puppy came into existence.
243         uint64 birthTime;
244 
245         // The minimum timestamp after which this puppy can engage in breeding
246         // activities again. This same timestamp is used for the pregnancy
247         // timer (for matrons) as well as the siring cooldown.
248         uint64 cooldownEndBlock;
249 
250         // The ID of the parents of this Puppy, set to 0 for gen0 puppys.
251         // Note that using 32-bit unsigned integers limits us to a "mere"
252         // 4 billion puppys. This number might seem small until you realize
253         // that Ethereum currently has a limit of about 500 million
254         // transactions per year! So, this definitely won't be a problem
255         // for several years (even as Ethereum learns to scale).
256         uint32 matronId;
257         uint32 sireId;
258 
259         // Set to the ID of the sire puppy for matrons that are pregnant,
260         // zero otherwise. A non-zero value here is how we know a puppy
261         // is pregnant. Used to retrieve the genetic material for the new
262         // puppy when the birth transpires.
263         uint32 siringWithId;
264 
265         // Set to the index in the cooldown array (see below) that represents
266         // the current cooldown duration for this Puppy. This starts at zero
267         // for gen0 puppys, and is initialized to floor(generation/2) for others.
268         // Incremented by one for each successful breeding action, regardless
269         // of whether this puppy is acting as matron or sire.
270         uint16 cooldownIndex;
271 
272         // The "generation number" of this puppy. puppys minted by the CK contract
273         // for sale are called "gen0" and have a generation number of 0. The
274         // generation number of all other puppys is the larger of the two generation
275         // numbers of their parents, plus one.
276         // (i.e. max(matron.generation, sire.generation) + 1)
277         uint16 generation;
278 
279         uint16 childNumber;
280 
281         uint16 strength;
282 
283         uint16 agility;
284 
285         uint16 intelligence;
286 
287         uint16 speed;
288     }
289 
290     /*** CONSTANTS ***/
291 
292     /// @dev A lookup table indipuppying the cooldown duration after any successful
293     ///  breeding action, called "pregnancy time" for matrons and "siring cooldown"
294     ///  for sires. Designed such that the cooldown roughly doubles each time a puppy
295     ///  is bred, encouraging owners not to just keep breeding the same puppy over
296     ///  and over again. Caps out at one week (a puppy can breed an unbounded number
297     ///  of times, and the maximum cooldown is always seven days).
298     uint32[14] public cooldowns = [
299         uint32(1 minutes),
300         uint32(2 minutes),
301         uint32(5 minutes),
302         uint32(10 minutes),
303         uint32(30 minutes),
304         uint32(1 hours),
305         uint32(2 hours),
306         uint32(4 hours),
307         uint32(8 hours),
308         uint32(16 hours),
309         uint32(1 days),
310         uint32(2 days),
311         uint32(4 days),
312         uint32(7 days)
313     ];
314 
315     // An approximation of currently how many seconds are in between blocks.
316     uint256 public secondsPerBlock = 15;
317 
318     /*** STORAGE ***/
319 
320     /// @dev An array containing the Puppy struct for all puppies in existence. The ID
321     ///  of each puppy is actually an index into this array. Note that ID 0 is a negapuppy,
322     ///  the unPuppy, the mythical beast that is the parent of all gen0 puppys. A bizarre
323     ///  creature that is both matron and sire... to itself! Has an invalid genetic code.
324     ///  In other words, puppy ID 0 is invalid... ;-)
325     Puppy[] puppies;
326 
327     /// @dev A mapping from puppy IDs to the address that owns them. All puppys have
328     ///  some valid owner address, even gen0 puppys are created with a non-zero owner.
329     mapping (uint256 => address) public PuppyIndexToOwner;
330 
331     // @dev A mapping from owner address to count of tokens that address owns.
332     //  Used internally inside balanceOf() to resolve ownership count.
333     mapping (address => uint256) ownershipTokenCount;
334 
335     /// @dev A mapping from puppyIds to an address that has been approved to call
336     ///  transferFrom(). Each Puppy can only have one approved address for transfer
337     ///  at any time. A zero value means no approval is outstanding.
338     mapping (uint256 => address) public PuppyIndexToApproved;
339 
340     /// @dev A mapping from puppyIds to an address that has been approved to use
341     ///  this Puppy for siring via breedWith(). Each Puppy can only have one approved
342     ///  address for siring at any time. A zero value means no approval is outstanding.
343     mapping (uint256 => address) public sireAllowedToAddress;
344 
345     /// @dev The address of the ClockAuction contract that handles sales of puppies. This
346     ///  same contract handles both peer-to-peer sales as well as the gen0 sales which are
347     ///  initiated every 15 minutes.
348     SaleClockAuction public saleAuction;
349 
350     /// @dev The address of a custom ClockAuction subclassed contract that handles siring
351     ///  auctions. Needs to be separate from saleAuction because the actions taken on success
352     ///  after a sales and siring auction are quite different.
353     SiringClockAuction public siringAuction;
354 
355     /// @dev Assigns ownership of a specific Puppy to an address.
356     function _transfer(address _from, address _to, uint256 _tokenId) internal {
357         // Since the number of puppys is capped to 2^32 we can't overflow this
358         ownershipTokenCount[_to]++;
359         // transfer ownership
360         PuppyIndexToOwner[_tokenId] = _to;
361         // When creating new puppys _from is 0x0, but we can't account that address.
362         if (_from != address(0)) {
363             ownershipTokenCount[_from]--;
364             // once the puppy is transferred also clear sire allowances
365             delete sireAllowedToAddress[_tokenId];
366             // clear any previously approved ownership exchange
367             delete PuppyIndexToApproved[_tokenId];
368         }
369         // Emit the transfer event.
370         Transfer(_from, _to, _tokenId);
371     }
372 
373     /// @dev An internal method that creates a new Puppy and stores it. This
374     ///  method doesn't do any checking and should only be called when the
375     ///  input data is known to be valid. Will generate both a Birth event
376     ///  and a Transfer event.
377     /// @param _matronId The Puppy ID of the matron of this puppy (zero for gen0)
378     /// @param _sireId The Puppy ID of the sire of this puppy (zero for gen0)
379     /// @param _generation The generation number of this puppy, must be computed by caller.
380     /// @param _genes The Puppy's genetic code.
381     /// @param _owner The inital owner of this puppy, must be non-zero (except for the unPuppy, ID 0)
382     function _createPuppy(
383         uint256 _matronId,
384         uint256 _sireId,
385         uint256 _generation,
386         uint256 _genes,
387         address _owner,
388         uint16 _strength,
389         uint16 _agility,
390         uint16 _intelligence,
391         uint16 _speed
392     )
393         internal
394         returns (uint)
395     {
396         // These requires are not strictly necessary, our calling code should make
397         // sure that these conditions are never broken. However! _createPuppy() is already
398         // an expensive call (for storage), and it doesn't hurt to be especially careful
399         // to ensure our data structures are always valid.
400         require(_matronId == uint256(uint32(_matronId)));
401         require(_sireId == uint256(uint32(_sireId)));
402         require(_generation == uint256(uint16(_generation)));
403 
404         // New Puppy starts with the same cooldown as parent gen/2
405         uint16 cooldownIndex = uint16(_generation / 2);
406         if (cooldownIndex > 13) {
407             cooldownIndex = 13;
408         }
409 
410         Puppy memory _puppy = Puppy({
411             genes: _genes,
412             birthTime: uint64(now),
413             cooldownEndBlock: 0,
414             matronId: uint32(_matronId),
415             sireId: uint32(_sireId),
416             siringWithId: 0,
417             cooldownIndex: cooldownIndex,
418             generation: uint16(_generation),
419             childNumber: 0,
420             strength: _strength,
421             agility: _agility,
422             intelligence: _intelligence,
423             speed: _speed
424         });
425 
426         uint256 newpuppyId = puppies.push(_puppy) - 1;
427 
428         // It's probably never going to happen, 4 billion puppys is A LOT, but
429         // let's just be 100% sure we never let this happen.
430         require(newpuppyId == uint256(uint32(newpuppyId)));
431 
432         // emit the birth event
433         Birth(
434             _owner,
435             newpuppyId,
436             uint256(_puppy.matronId),
437             uint256(_puppy.sireId),
438             _puppy.genes
439         );
440 
441         // This will assign ownership, and also emit the Transfer event as
442         // per ERC721 draft
443         _transfer(0, _owner, newpuppyId);
444 
445         return newpuppyId;
446     }
447 
448     // Any C-level can fix how many seconds per blocks are currently observed.
449     function setSecondsPerBlock(uint256 secs) external onlyCLevel {
450         require(secs < cooldowns[0]);
451         secondsPerBlock = secs;
452     }
453 }
454 
455 
456 
457 
458 
459 /// @title The external contract that is responsible for generating metadata for the puppies,
460 ///  it has one function that will return the data as bytes.
461 contract ERC721Metadata {
462     /// @dev Given a token Id, returns a byte array that is supposed to be converted into string.
463     function getMetadata(uint256 _tokenId, string) public view returns (bytes32[4] buffer, uint256 count) {
464         if (_tokenId == 1) {
465             buffer[0] = "Hello World! :D";
466             count = 15;
467         } else if (_tokenId == 2) {
468             buffer[0] = "I would definitely choose a medi";
469             buffer[1] = "um length string.";
470             count = 49;
471         } else if (_tokenId == 3) {
472             buffer[0] = "Lorem ipsum dolor sit amet, mi e";
473             buffer[1] = "st accumsan dapibus augue lorem,";
474             buffer[2] = " tristique vestibulum id, libero";
475             buffer[3] = " suscipit varius sapien aliquam.";
476             count = 128;
477         }
478     }
479 }
480 
481 
482 /// @title The facet of the CryptoPuppies core contract that manages ownership, ERC-721 (draft) compliant.
483 /// @author Axiom Zen (https://www.axiomzen.co)
484 /// @dev Ref: https://github.com/ethereum/EIPs/issues/721
485 ///  See the PuppiesCore contract documentation to understand how the various contract facets are arranged.
486 contract PuppyOwnership is PuppyBase, ERC721 {
487 
488     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
489     string public constant name = "CryptoPuppies";
490     string public constant symbol = "CP";
491 
492     // The contract that will return Puppy metadata
493     ERC721Metadata public erc721Metadata;
494 
495     bytes4 constant InterfaceSignature_ERC165 =
496         bytes4(keccak256("supportsInterface(bytes4)"));
497 
498     bytes4 constant InterfaceSignature_ERC721 =
499         bytes4(keccak256("name()")) ^
500         bytes4(keccak256("symbol()")) ^
501         bytes4(keccak256("totalSupply()")) ^
502         bytes4(keccak256("balanceOf(address)")) ^
503         bytes4(keccak256("ownerOf(uint256)")) ^
504         bytes4(keccak256("approve(address,uint256)")) ^
505         bytes4(keccak256("transfer(address,uint256)")) ^
506         bytes4(keccak256("transferFrom(address,address,uint256)")) ^
507         bytes4(keccak256("tokensOfOwner(address)")) ^
508         bytes4(keccak256("tokenMetadata(uint256,string)"));
509 
510     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
511     ///  Returns true for any standardized interfaces implemented by this contract. We implement
512     ///  ERC-165 (obviously!) and ERC-721.
513     function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
514         // DEBUG ONLY
515         //require((InterfaceSignature_ERC165 == 0x01ffc9a7) && (InterfaceSignature_ERC721 == 0x9a20483d));
516 
517         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
518     }
519 
520     /// @dev Set the address of the sibling contract that tracks metadata.
521     ///  CEO only.
522     function setMetadataAddress(address _contractAddress) public onlyCEO {
523         erc721Metadata = ERC721Metadata(_contractAddress);
524     }
525 
526     // Internal utility functions: These functions all assume that their input arguments
527     // are valid. We leave it to public methods to sanitize their inputs and follow
528     // the required logic.
529 
530     /// @dev Checks if a given address is the current owner of a particular Puppy.
531     /// @param _claimant the address we are validating against.
532     /// @param _tokenId puppy id, only valid when > 0
533     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
534         return PuppyIndexToOwner[_tokenId] == _claimant;
535     }
536 
537     /// @dev Checks if a given address currently has transferApproval for a particular Puppy.
538     /// @param _claimant the address we are confirming puppy is approved for.
539     /// @param _tokenId puppy id, only valid when > 0
540     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
541         return PuppyIndexToApproved[_tokenId] == _claimant;
542     }
543 
544     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
545     ///  approval. Setting _approved to address(0) clears all transfer approval.
546     ///  NOTE: _approve() does NOT send the Approval event. This is intentional because
547     ///  _approve() and transferFrom() are used together for putting puppies on auction, and
548     ///  there is no value in spamming the log with Approval events in that case.
549     function _approve(uint256 _tokenId, address _approved) internal {
550         PuppyIndexToApproved[_tokenId] = _approved;
551     }
552 
553     /// @notice Returns the number of puppies owned by a specific address.
554     /// @param _owner The owner address to check.
555     /// @dev Required for ERC-721 compliance
556     function balanceOf(address _owner) public view returns (uint256 count) {
557         return ownershipTokenCount[_owner];
558     }
559 
560     /// @notice Transfers a Puppy to another address. If transferring to a smart
561     ///  contract be VERY CAREFUL to ensure that it is aware of ERC-721 (or
562     ///  CryptoPuppies specifically) or your Puppy may be lost forever. Seriously.
563     /// @param _to The address of the recipient, can be a user or contract.
564     /// @param _tokenId The ID of the Puppy to transfer.
565     /// @dev Required for ERC-721 compliance.
566     function transfer(
567         address _to,
568         uint256 _tokenId
569     )
570         external
571         whenNotPaused
572     {
573         // Safety check to prevent against an unexpected 0x0 default.
574         require(_to != address(0));
575         // Disallow transfers to this contract to prevent accidental misuse.
576         // The contract should never own any puppies (except very briefly
577         // after a gen0 puppy is created and before it goes on auction).
578         require(_to != address(this));
579         // Disallow transfers to the auction contracts to prevent accidental
580         // misuse. Auction contracts should only take ownership of puppies
581         // through the allow + transferFrom flow.
582         require(_to != address(saleAuction));
583         require(_to != address(siringAuction));
584 
585         // You can only send your own puppy.
586         require(_owns(msg.sender, _tokenId));
587 
588         // Reassign ownership, clear pending approvals, emit Transfer event.
589         _transfer(msg.sender, _to, _tokenId);
590     }
591 
592     /// @notice Grant another address the right to transfer a specific Puppy via
593     ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
594     /// @param _to The address to be granted transfer approval. Pass address(0) to
595     ///  clear all approvals.
596     /// @param _tokenId The ID of the Puppy that can be transferred if this call succeeds.
597     /// @dev Required for ERC-721 compliance.
598     function approve(
599         address _to,
600         uint256 _tokenId
601     )
602         external
603         whenNotPaused
604     {
605         // Only an owner can grant transfer approval.
606         require(_owns(msg.sender, _tokenId));
607 
608         // Register the approval (replacing any previous approval).
609         _approve(_tokenId, _to);
610 
611         // Emit approval event.
612         Approval(msg.sender, _to, _tokenId);
613     }
614 
615     /// @notice Transfer a Puppy owned by another address, for which the calling address
616     ///  has previously been granted transfer approval by the owner.
617     /// @param _from The address that owns the Puppy to be transfered.
618     /// @param _to The address that should take ownership of the Puppy. Can be any address,
619     ///  including the caller.
620     /// @param _tokenId The ID of the Puppy to be transferred.
621     /// @dev Required for ERC-721 compliance.
622     function transferFrom(
623         address _from,
624         address _to,
625         uint256 _tokenId
626     )
627         external
628         whenNotPaused
629     {
630         // Safety check to prevent against an unexpected 0x0 default.
631         require(_to != address(0));
632         // Disallow transfers to this contract to prevent accidental misuse.
633         // The contract should never own any puppies (except very briefly
634         // after a gen0 puppy is created and before it goes on auction).
635         require(_to != address(this));
636         // Check for approval and valid ownership
637         require(_approvedFor(msg.sender, _tokenId));
638         require(_owns(_from, _tokenId));
639 
640         // Reassign ownership (also clears pending approvals and emits Transfer event).
641         _transfer(_from, _to, _tokenId);
642     }
643 
644     /// @notice Returns the total number of puppies currently in existence.
645     /// @dev Required for ERC-721 compliance.
646     function totalSupply() public view returns (uint) {
647         return puppies.length - 1;
648     }
649 
650     /// @notice Returns the address currently assigned ownership of a given Puppy.
651     /// @dev Required for ERC-721 compliance.
652     function ownerOf(uint256 _tokenId)
653         external
654         view
655         returns (address owner)
656     {
657         owner = PuppyIndexToOwner[_tokenId];
658 
659         require(owner != address(0));
660     }
661 
662     /// @notice Returns a list of all Puppy IDs assigned to an address.
663     /// @param _owner The owner whose puppies we are interested in.
664     /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
665     ///  expensive (it walks the entire Puppy array looking for puppys belonging to owner),
666     ///  but it also returns a dynamic array, which is only supported for web3 calls, and
667     ///  not contract-to-contract calls.
668     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
669         uint256 tokenCount = balanceOf(_owner);
670 
671         if (tokenCount == 0) {
672             // Return an empty array
673             return new uint256[](0);
674         } else {
675             uint256[] memory result = new uint256[](tokenCount);
676             uint256 totalpuppys = totalSupply();
677             uint256 resultIndex = 0;
678 
679             // We count on the fact that all puppys have IDs starting at 1 and increasing
680             // sequentially up to the totalpuppy count.
681             uint256 puppyId;
682 
683             for (puppyId = 1; puppyId <= totalpuppys; puppyId++) {
684                 if (PuppyIndexToOwner[puppyId] == _owner) {
685                     result[resultIndex] = puppyId;
686                     resultIndex++;
687                 }
688             }
689 
690             return result;
691         }
692     }
693 
694     /// @dev Adapted from memcpy() by @arachnid (Nick Johnson <arachnid@notdot.net>)
695     ///  This method is licenced under the Apache License.
696     ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
697     function _memcpy(uint _dest, uint _src, uint _len) private view {
698         // Copy word-length chunks while possible
699         for(; _len >= 32; _len -= 32) {
700             assembly {
701                 mstore(_dest, mload(_src))
702             }
703             _dest += 32;
704             _src += 32;
705         }
706 
707         // Copy remaining bytes
708         uint256 mask = 256 ** (32 - _len) - 1;
709         assembly {
710             let srcpart := and(mload(_src), not(mask))
711             let destpart := and(mload(_dest), mask)
712             mstore(_dest, or(destpart, srcpart))
713         }
714     }
715 
716     /// @dev Adapted from toString(slice) by @arachnid (Nick Johnson <arachnid@notdot.net>)
717     ///  This method is licenced under the Apache License.
718     ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
719     function _toString(bytes32[4] _rawBytes, uint256 _stringLength) private view returns (string) {
720         var outputString = new string(_stringLength);
721         uint256 outputPtr;
722         uint256 bytesPtr;
723 
724         assembly {
725             outputPtr := add(outputString, 32)
726             bytesPtr := _rawBytes
727         }
728 
729         _memcpy(outputPtr, bytesPtr, _stringLength);
730 
731         return outputString;
732     }
733 
734     /// @notice Returns a URI pointing to a metadata package for this token conforming to
735     ///  ERC-721 (https://github.com/ethereum/EIPs/issues/721)
736     /// @param _tokenId The ID number of the Puppy whose metadata should be returned.
737     function tokenMetadata(uint256 _tokenId, string _preferredTransport) external view returns (string infoUrl) {
738         require(erc721Metadata != address(0));
739         bytes32[4] memory buffer;
740         uint256 count;
741         (buffer, count) = erc721Metadata.getMetadata(_tokenId, _preferredTransport);
742 
743         return _toString(buffer, count);
744     }
745 }
746 
747 /// @title A facet of PuppiesCore that manages Puppy siring, gestation, and birth.
748 /// @author Axiom Zen (https://www.axiomzen.co)
749 /// @dev See the PuppiesCore contract documentation to understand how the various contract facets are arranged.
750 contract PuppyBreeding is PuppyOwnership {
751 
752     /// @dev The Pregnant event is fired when two puppys successfully breed and the pregnancy
753     ///  timer begins for the matron.
754     event Pregnant(address owner, uint256 matronId, uint256 sireId, uint256 cooldownEndBlock);
755 
756     /// @notice The minimum payment required to use breedWithAuto(). This fee goes towards
757     ///  the gas cost paid by whatever calls giveBirth(), and can be dynamically updated by
758     ///  the COO role as the gas price changes.
759     uint256 public autoBirthFee = 8 finney;
760 
761     // Keeps track of number of pregnant puppies.
762     uint256 public pregnantpuppies;
763 
764     uint256 public minChildCount = 2;
765 
766     uint256 public maxChildCount = 14;
767 
768     uint randNonce = 0;
769 
770     /// @dev The address of the sibling contract that is used to implement the sooper-sekret
771     ///  genetic combination algorithm.
772 
773     GeneScience public geneScience;
774 
775     PuppySports public puppySports;
776 
777     function setMinChildCount(uint256 _minChildCount) onlyCOO whenNotPaused {
778         require(_minChildCount >= 2);
779         minChildCount = _minChildCount;
780     }
781 
782     function setMaxChildCount(uint256 _maxChildCount) onlyCOO whenNotPaused {
783         require(_maxChildCount > minChildCount);
784         maxChildCount = _maxChildCount;
785     }
786 
787     function setGeneScienceAddress(address _address) external onlyCEO {
788         GeneScience candidateContract = GeneScience(_address);
789 
790         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
791         require(candidateContract.isGeneScience());
792 
793         // Set the new contract address
794         geneScience = candidateContract;
795     }
796 
797     function setPuppySports(address _address) external onlyCEO {
798         PuppySports candidateContract = PuppySports(_address);
799 
800         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
801         require(candidateContract.isPuppySports());
802 
803         // Set the new contract address
804         puppySports = candidateContract;
805     }
806 
807     /// @dev Checks that a given puppy is able to breed. Requires that the
808     ///  current cooldown is finished (for sires) and also checks that there is
809     ///  no pending pregnancy.
810     function _isReadyToBreed(Puppy _pup) internal view returns (bool) {
811         // In addition to checking the cooldownEndBlock, we also need to check to see if
812         // the puppy has a pending birth; there can be some period of time between the end
813         // of the pregnacy timer and the birth event.
814         uint256 numberOfAllowedChild = maxChildCount - _pup.generation * 2;
815         if (numberOfAllowedChild < minChildCount) {
816             numberOfAllowedChild = minChildCount;
817         }
818 
819         bool isChildLimitNotReached = _pup.childNumber < numberOfAllowedChild;
820 
821         return (_pup.siringWithId == 0) && (_pup.cooldownEndBlock <= uint64(block.number)) && isChildLimitNotReached;
822     }
823 
824     /// @dev Check if a sire has authorized breeding with this matron. True if both sire
825     ///  and matron have the same owner, or if the sire has given siring permission to
826     ///  the matron's owner (via approveSiring()).
827     function _isSiringPermitted(uint256 _sireId, uint256 _matronId) internal view returns (bool) {
828         address matronOwner = PuppyIndexToOwner[_matronId];
829         address sireOwner = PuppyIndexToOwner[_sireId];
830 
831         // Siring is okay if they have same owner, or if the matron's owner was given
832         // permission to breed with this sire.
833         return (matronOwner == sireOwner || sireAllowedToAddress[_sireId] == matronOwner);
834     }
835 
836     /// @dev Set the cooldownEndTime for the given Puppy, based on its current cooldownIndex.
837     ///  Also increments the cooldownIndex (unless it has hit the cap).
838     /// @param _puppy A reference to the Puppy in storage which needs its timer started.
839     function _triggerCooldown(Puppy storage _puppy) internal {
840         // Compute an estimation of the cooldown time in blocks (based on current cooldownIndex).
841         _puppy.cooldownEndBlock = uint64((cooldowns[_puppy.cooldownIndex]/secondsPerBlock) + block.number);
842 
843         // Increment the breeding count, clamping it at 13, which is the length of the
844         // cooldowns array. We could check the array size dynamically, but hard-coding
845         // this as a constant saves gas. Yay, Solidity!
846         if (_puppy.cooldownIndex < 13) {
847             _puppy.cooldownIndex += 1;
848         }
849     }
850 
851     /// @dev Set the cooldownEndTime for the given Puppy, based on its current cooldownIndex.
852     ///  Also increments the cooldownIndex (unless it has hit the cap).
853     /// @param _puppy A reference to the Puppy in storage which needs its timer started.
854     function _triggerChildCount(Puppy storage _puppy) internal {
855         // Increment the child count
856         _puppy.childNumber += 1;
857     }
858 
859     /// @notice Grants approval to another user to sire with one of your puppies.
860     /// @param _addr The address that will be able to sire with your Puppy. Set to
861     ///  address(0) to clear all siring approvals for this Puppy.
862     /// @param _sireId A Puppy that you own that _addr will now be able to sire with.
863     function approveSiring(address _addr, uint256 _sireId)
864         external
865         whenNotPaused
866     {
867         require(_owns(msg.sender, _sireId));
868         sireAllowedToAddress[_sireId] = _addr;
869     }
870 
871     /// @dev Updates the minimum payment required for calling giveBirthAuto(). Can only
872     ///  be called by the COO address. (This fee is used to offset the gas cost incurred
873     ///  by the autobirth daemon).
874     function setAutoBirthFee(uint256 val) external onlyCOO {
875         autoBirthFee = val;
876     }
877 
878     /// @dev Checks to see if a given Puppy is pregnant and (if so) if the gestation
879     ///  period has passed.
880     function _isReadyToGiveBirth(Puppy _matron) private view returns (bool) {
881         return (_matron.siringWithId != 0) && (_matron.cooldownEndBlock <= uint64(block.number));
882     }
883 
884     /// @notice Checks that a given puppy is able to breed (i.e. it is not pregnant or
885     ///  in the middle of a siring cooldown).
886     /// @param _puppyId reference the id of the puppy, any user can inquire about it
887     function isReadyToBreed(uint256 _puppyId)
888         public
889         view
890         returns (bool)
891     {
892         require(_puppyId > 0);
893         Puppy storage pup = puppies[_puppyId];
894         return _isReadyToBreed(pup);
895     }
896 
897     /// @dev Checks whether a Puppy is currently pregnant.
898     /// @param _puppyId reference the id of the puppy, any user can inquire about it
899     function isPregnant(uint256 _puppyId)
900         public
901         view
902         returns (bool)
903     {
904         require(_puppyId > 0);
905         // A Puppy is pregnant if and only if this field is set
906         return puppies[_puppyId].siringWithId != 0;
907     }
908 
909     /// @dev Internal check to see if a given sire and matron are a valid mating pair. DOES NOT
910     ///  check ownership permissions (that is up to the caller).
911     /// @param _matron A reference to the Puppy struct of the potential matron.
912     /// @param _matronId The matron's ID.
913     /// @param _sire A reference to the Puppy struct of the potential sire.
914     /// @param _sireId The sire's ID
915     function _isValidMatingPair(
916         Puppy storage _matron,
917         uint256 _matronId,
918         Puppy storage _sire,
919         uint256 _sireId
920     )
921         private
922         view
923         returns(bool)
924     {
925         // A Puppy can't breed with itself!
926         if (_matronId == _sireId) {
927             return false;
928         }
929 
930         // puppies can't breed with their parents.
931         if (_matron.matronId == _sireId || _matron.sireId == _sireId) {
932             return false;
933         }
934         if (_sire.matronId == _matronId || _sire.sireId == _matronId) {
935             return false;
936         }
937 
938         // We can short circuit the sibling check (below) if either puppy is
939         // gen zero (has a matron ID of zero).
940         if (_sire.matronId == 0 || _matron.matronId == 0) {
941             return true;
942         }
943 
944         // puppies can't breed with full or half siblings.
945         if (_sire.matronId == _matron.matronId || _sire.matronId == _matron.sireId) {
946             return false;
947         }
948         if (_sire.sireId == _matron.matronId || _sire.sireId == _matron.sireId) {
949             return false;
950         }
951 
952         // Everything seems cool! Let's get DTF.
953         return true;
954     }
955 
956     /// @dev Internal check to see if a given sire and matron are a valid mating pair for
957     ///  breeding via auction (i.e. skips ownership and siring approval checks).
958     function _canBreedWithViaAuction(uint256 _matronId, uint256 _sireId)
959         internal
960         view
961         returns (bool)
962     {
963         Puppy storage matron = puppies[_matronId];
964         Puppy storage sire = puppies[_sireId];
965         return _isValidMatingPair(matron, _matronId, sire, _sireId);
966     }
967 
968     /// @notice Checks to see if two puppys can breed together, including checks for
969     ///  ownership and siring approvals. Does NOT check that both puppys are ready for
970     ///  breeding (i.e. breedWith could still fail until the cooldowns are finished).
971     ///  TODO: Shouldn't this check pregnancy and cooldowns?!?
972     /// @param _matronId The ID of the proposed matron.
973     /// @param _sireId The ID of the proposed sire.
974     function canBreedWith(uint256 _matronId, uint256 _sireId)
975         external
976         view
977         returns(bool)
978     {
979         require(_matronId > 0);
980         require(_sireId > 0);
981         Puppy storage matron = puppies[_matronId];
982         Puppy storage sire = puppies[_sireId];
983         return _isValidMatingPair(matron, _matronId, sire, _sireId) &&
984             _isSiringPermitted(_sireId, _matronId);
985     }
986 
987     /// @dev Internal utility function to initiate breeding, assumes that all breeding
988     ///  requirements have been checked.
989     function _breedWith(uint256 _matronId, uint256 _sireId) internal {
990         // Grab a reference to the puppies from storage.
991         Puppy storage sire = puppies[_sireId];
992         Puppy storage matron = puppies[_matronId];
993 
994         // Mark the matron as pregnant, keeping track of who the sire is.
995         matron.siringWithId = uint32(_sireId);
996 
997         // Trigger the cooldown for both parents.
998         _triggerCooldown(sire);
999         _triggerCooldown(matron);
1000         _triggerChildCount(sire);
1001         _triggerChildCount(matron);
1002 
1003         // Clear siring permission for both parents. This may not be strictly necessary
1004         // but it's likely to avoid confusion!
1005         delete sireAllowedToAddress[_matronId];
1006         delete sireAllowedToAddress[_sireId];
1007 
1008         // Every time a Puppy gets pregnant, counter is incremented.
1009         pregnantpuppies++;
1010 
1011         // Emit the pregnancy event.
1012         Pregnant(PuppyIndexToOwner[_matronId], _matronId, _sireId, matron.cooldownEndBlock);
1013     }
1014 
1015     /// @notice Breed a Puppy you own (as matron) with a sire that you own, or for which you
1016     ///  have previously been given Siring approval. Will either make your puppy pregnant, or will
1017     ///  fail entirely. Requires a pre-payment of the fee given out to the first caller of giveBirth()
1018     /// @param _matronId The ID of the Puppy acting as matron (will end up pregnant if successful)
1019     /// @param _sireId The ID of the Puppy acting as sire (will begin its siring cooldown if successful)
1020     function breedWithAuto(uint256 _matronId, uint256 _sireId)
1021         external
1022         payable
1023         whenNotPaused
1024     {
1025         // Checks for payment.
1026         require(msg.value >= autoBirthFee);
1027 
1028         // Caller must own the matron.
1029         require(_owns(msg.sender, _matronId));
1030 
1031         // Neither sire nor matron are allowed to be on auction during a normal
1032         // breeding operation, but we don't need to check that explicitly.
1033         // For matron: The caller of this function can't be the owner of the matron
1034         //   because the owner of a Puppy on auction is the auction house, and the
1035         //   auction house will never call breedWith().
1036         // For sire: Similarly, a sire on auction will be owned by the auction house
1037         //   and the act of transferring ownership will have cleared any oustanding
1038         //   siring approval.
1039         // Thus we don't need to spend gas explicitly checking to see if either puppy
1040         // is on auction.
1041 
1042         // Check that matron and sire are both owned by caller, or that the sire
1043         // has given siring permission to caller (i.e. matron's owner).
1044         // Will fail for _sireId = 0
1045         require(_isSiringPermitted(_sireId, _matronId));
1046 
1047         // Grab a reference to the potential matron
1048         Puppy storage matron = puppies[_matronId];
1049 
1050         // Make sure matron isn't pregnant, or in the middle of a siring cooldown
1051         require(_isReadyToBreed(matron));
1052 
1053         // Grab a reference to the potential sire
1054         Puppy storage sire = puppies[_sireId];
1055 
1056         // Make sure sire isn't pregnant, or in the middle of a siring cooldown
1057         require(_isReadyToBreed(sire));
1058 
1059         // Test that these puppys are a valid mating pair.
1060         require(_isValidMatingPair(
1061             matron,
1062             _matronId,
1063             sire,
1064             _sireId
1065         ));
1066 
1067         // All checks passed, Puppy gets pregnant!
1068         _breedWith(_matronId, _sireId);
1069     }
1070 
1071     function playGame(uint256 _puppyId, uint256 _gameId)
1072         external
1073         whenNotPaused
1074         returns(bool)
1075     {
1076         require(puppySports != address(0));
1077         require(_owns(msg.sender, _puppyId));
1078 
1079         return puppySports.playGame(_puppyId, _gameId, block.number);
1080     }
1081 
1082     /// @notice Have a pregnant Puppy give birth!
1083     /// @param _matronId A Puppy ready to give birth.
1084     /// @return The Puppy ID of the new puppy.
1085     /// @dev Looks at a given Puppy and, if pregnant and if the gestation period has passed,
1086     ///  combines the genes of the two parents to create a new puppy. The new Puppy is assigned
1087     ///  to the current owner of the matron. Upon successful completion, both the matron and the
1088     ///  new puppy will be ready to breed again. Note that anyone can call this function (if they
1089     ///  are willing to pay the gas!), but the new puppy always goes to the mother's owner.
1090     function giveBirth(uint256 _matronId) payable
1091         external
1092         whenNotPaused
1093         returns(uint256)
1094     {
1095         // Grab a reference to the matron in storage.
1096         Puppy storage matron = puppies[_matronId];
1097 
1098         // Check that the matron is a valid puppy.
1099         require(matron.birthTime != 0);
1100 
1101         // Check that the matron is pregnant, and that its time has come!
1102         require(_isReadyToGiveBirth(matron));
1103 
1104         // Grab a reference to the sire in storage.
1105         uint256 sireId = matron.siringWithId;
1106         Puppy storage sire = puppies[sireId];
1107 
1108         // Determine the higher generation number of the two parents
1109         uint16 parentGen = matron.generation;
1110         if (sire.generation > matron.generation) {
1111             parentGen = sire.generation;
1112         }
1113 
1114         // Call the sooper-sekret gene mixing operation.
1115         //uint256 childGenes = _babyGenes;
1116         uint256 childGenes = geneScience.mixGenes(matron.genes, sire.genes, matron.cooldownEndBlock - 1);
1117 
1118         // Make the new puppy!
1119         address owner = PuppyIndexToOwner[_matronId];
1120         // Add randomizer for attributes
1121         uint16 strength = uint16(random(_matronId));
1122         uint16 agility = uint16(random(strength));
1123         uint16 intelligence = uint16(random(agility));
1124         uint16 speed = uint16(random(intelligence));
1125 
1126         uint256 puppyId = _createPuppy(_matronId, matron.siringWithId, parentGen + 1, childGenes, owner, strength, agility, intelligence, speed);
1127 
1128         // Clear the reference to sire from the matron (REQUIRED! Having siringWithId
1129         // set is what marks a matron as being pregnant.)
1130         delete matron.siringWithId;
1131 
1132         // Every time a Puppy gives birth counter is decremented.
1133         pregnantpuppies--;
1134 
1135         // Send the balance fee to the person who made birth happen.
1136         msg.sender.send(autoBirthFee);
1137 
1138         // return the new puppy's ID
1139         return puppyId;
1140     }
1141 
1142     //random
1143     function random(uint256 seed) public view returns (uint8 randomNumber) {
1144         uint8 rnd = uint8(keccak256(
1145             seed,
1146             block.blockhash(block.number - 1),
1147             block.coinbase,
1148             block.difficulty
1149         )) % 100 + uint8(1);
1150         return rnd % 100 + 1;
1151     }
1152 }
1153 
1154 /// @title Auction Core
1155 /// @dev Contains models, variables, and internal methods for the auction.
1156 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1157 contract ClockAuctionBase {
1158 
1159     // Represents an auction on an NFT
1160     struct Auction {
1161         // Current owner of NFT
1162         address seller;
1163         // Price (in wei) at beginning of auction
1164         uint128 startingPrice;
1165         // Price (in wei) at end of auction
1166         uint128 endingPrice;
1167         // Duration (in seconds) of auction
1168         uint64 duration;
1169         // Time when auction started
1170         // NOTE: 0 if this auction has been concluded
1171         uint64 startedAt;
1172     }
1173 
1174     // Reference to contract tracking NFT ownership
1175     ERC721 public nonFungibleContract;
1176 
1177     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
1178     // Values 0-10,000 map to 0%-100%
1179     uint256 public ownerCut;
1180 
1181     // Map from token ID to their corresponding auction.
1182     mapping (uint256 => Auction) tokenIdToAuction;
1183 
1184     event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
1185     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
1186     event AuctionCancelled(uint256 tokenId);
1187 
1188     /// @dev Returns true if the claimant owns the token.
1189     /// @param _claimant - Address claiming to own the token.
1190     /// @param _tokenId - ID of token whose ownership to verify.
1191     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
1192         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
1193     }
1194 
1195     /// @dev Escrows the NFT, assigning ownership to this contract.
1196     /// Throws if the escrow fails.
1197     /// @param _owner - Current owner address of token to escrow.
1198     /// @param _tokenId - ID of token whose approval to verify.
1199     function _escrow(address _owner, uint256 _tokenId) internal {
1200         // it will throw if transfer fails
1201         nonFungibleContract.transferFrom(_owner, this, _tokenId);
1202     }
1203 
1204     /// @dev Transfers an NFT owned by this contract to another address.
1205     /// Returns true if the transfer succeeds.
1206     /// @param _receiver - Address to transfer NFT to.
1207     /// @param _tokenId - ID of token to transfer.
1208     function _transfer(address _receiver, uint256 _tokenId) internal {
1209         // it will throw if transfer fails
1210         nonFungibleContract.transfer(_receiver, _tokenId);
1211     }
1212 
1213     /// @dev Adds an auction to the list of open auctions. Also fires the
1214     ///  AuctionCreated event.
1215     /// @param _tokenId The ID of the token to be put on auction.
1216     /// @param _auction Auction to add.
1217     function _addAuction(uint256 _tokenId, Auction _auction) internal {
1218         // Require that all auctions have a duration of
1219         // at least one minute. (Keeps our math from getting hairy!)
1220         require(_auction.duration >= 1 minutes);
1221 
1222         tokenIdToAuction[_tokenId] = _auction;
1223 
1224         AuctionCreated(
1225             uint256(_tokenId),
1226             uint256(_auction.startingPrice),
1227             uint256(_auction.endingPrice),
1228             uint256(_auction.duration)
1229         );
1230     }
1231 
1232     /// @dev Cancels an auction unconditionally.
1233     function _cancelAuction(uint256 _tokenId, address _seller) internal {
1234         _removeAuction(_tokenId);
1235         _transfer(_seller, _tokenId);
1236         AuctionCancelled(_tokenId);
1237     }
1238 
1239     /// @dev Computes the price and transfers winnings.
1240     /// Does NOT transfer ownership of token.
1241     function _bid(uint256 _tokenId, uint256 _bidAmount)
1242         internal
1243         returns (uint256)
1244     {
1245         // Get a reference to the auction struct
1246         Auction storage auction = tokenIdToAuction[_tokenId];
1247 
1248         // Explicitly check that this auction is currently live.
1249         // (Because of how Ethereum mappings work, we can't just count
1250         // on the lookup above failing. An invalid _tokenId will just
1251         // return an auction object that is all zeros.)
1252         require(_isOnAuction(auction));
1253 
1254         // Check that the bid is greater than or equal to the current price
1255         uint256 price = _currentPrice(auction);
1256         require(_bidAmount >= price);
1257 
1258         // Grab a reference to the seller before the auction struct
1259         // gets deleted.
1260         address seller = auction.seller;
1261 
1262         // The bid is good! Remove the auction before sending the fees
1263         // to the sender so we can't have a reentrancy attack.
1264         _removeAuction(_tokenId);
1265 
1266         // Transfer proceeds to seller (if there are any!)
1267         if (price > 0) {
1268             // Calculate the auctioneer's cut.
1269             // (NOTE: _computeCut() is guaranteed to return a
1270             // value <= price, so this subtraction can't go negative.)
1271             uint256 auctioneerCut = _computeCut(price);
1272             uint256 sellerProceeds = price - auctioneerCut;
1273 
1274             // NOTE: Doing a transfer() in the middle of a complex
1275             // method like this is generally discouraged because of
1276             // reentrancy attacks and DoS attacks if the seller is
1277             // a contract with an invalid fallback function. We explicitly
1278             // guard against reentrancy attacks by removing the auction
1279             // before calling transfer(), and the only thing the seller
1280             // can DoS is the sale of their own asset! (And if it's an
1281             // accident, they can call cancelAuction(). )
1282             seller.transfer(sellerProceeds);
1283         }
1284 
1285         // Calculate any excess funds included with the bid. If the excess
1286         // is anything worth worrying about, transfer it back to bidder.
1287         // NOTE: We checked above that the bid amount is greater than or
1288         // equal to the price so this cannot underflow.
1289         uint256 bidExcess = _bidAmount - price;
1290 
1291         // Return the funds. Similar to the previous transfer, this is
1292         // not susceptible to a re-entry attack because the auction is
1293         // removed before any transfers occur.
1294         msg.sender.transfer(bidExcess);
1295 
1296         // Tell the world!
1297         AuctionSuccessful(_tokenId, price, msg.sender);
1298 
1299         return price;
1300     }
1301 
1302     /// @dev Removes an auction from the list of open auctions.
1303     /// @param _tokenId - ID of NFT on auction.
1304     function _removeAuction(uint256 _tokenId) internal {
1305         delete tokenIdToAuction[_tokenId];
1306     }
1307 
1308     /// @dev Returns true if the NFT is on auction.
1309     /// @param _auction - Auction to check.
1310     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
1311         return (_auction.startedAt > 0);
1312     }
1313 
1314     /// @dev Returns current price of an NFT on auction. Broken into two
1315     ///  functions (this one, that computes the duration from the auction
1316     ///  structure, and the other that does the price computation) so we
1317     ///  can easily test that the price computation works correctly.
1318     function _currentPrice(Auction storage _auction)
1319         internal
1320         view
1321         returns (uint256)
1322     {
1323         uint256 secondsPassed = 0;
1324 
1325         // A bit of insurance against negative values (or wraparound).
1326         // Probably not necessary (since Ethereum guarnatees that the
1327         // now variable doesn't ever go backwards).
1328         if (now > _auction.startedAt) {
1329             secondsPassed = now - _auction.startedAt;
1330         }
1331 
1332         return _computeCurrentPrice(
1333             _auction.startingPrice,
1334             _auction.endingPrice,
1335             _auction.duration,
1336             secondsPassed
1337         );
1338     }
1339 
1340     /// @dev Computes the current price of an auction. Factored out
1341     ///  from _currentPrice so we can run extensive unit tests.
1342     ///  When testing, make this function public and turn on
1343     ///  `Current price computation` test suite.
1344     function _computeCurrentPrice(
1345         uint256 _startingPrice,
1346         uint256 _endingPrice,
1347         uint256 _duration,
1348         uint256 _secondsPassed
1349     )
1350         internal
1351         pure
1352         returns (uint256)
1353     {
1354         // NOTE: We don't use SafeMath (or similar) in this function because
1355         //  all of our public functions carefully cap the maximum values for
1356         //  time (at 64-bits) and currency (at 128-bits). _duration is
1357         //  also known to be non-zero (see the require() statement in
1358         //  _addAuction())
1359         if (_secondsPassed >= _duration) {
1360             // We've reached the end of the dynamic pricing portion
1361             // of the auction, just return the end price.
1362             return _endingPrice;
1363         } else {
1364             // Starting price can be higher than ending price (and often is!), so
1365             // this delta can be negative.
1366             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
1367 
1368             // This multiplipuppyion can't overflow, _secondsPassed will easily fit within
1369             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
1370             // will always fit within 256-bits.
1371             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
1372 
1373             // currentPriceChange can be negative, but if so, will have a magnitude
1374             // less that _startingPrice. Thus, this result will always end up positive.
1375             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
1376 
1377             return uint256(currentPrice);
1378         }
1379     }
1380 
1381     /// @dev Computes owner's cut of a sale.
1382     /// @param _price - Sale price of NFT.
1383     function _computeCut(uint256 _price) internal view returns (uint256) {
1384         // NOTE: We don't use SafeMath (or similar) in this function because
1385         //  all of our entry functions carefully cap the maximum values for
1386         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
1387         //  statement in the ClockAuction constructor). The result of this
1388         //  function is always guaranteed to be <= _price.
1389         return _price * ownerCut / 10000;
1390     }
1391 
1392 }
1393 
1394 /**
1395  * @title Pausable
1396  * @dev Base contract which allows children to implement an emergency stop mechanism.
1397  */
1398 contract Pausable is Ownable {
1399   event Pause();
1400   event Unpause();
1401 
1402   bool public paused = false;
1403 
1404 
1405   /**
1406    * @dev modifier to allow actions only when the contract IS paused
1407    */
1408   modifier whenNotPaused() {
1409     require(!paused);
1410     _;
1411   }
1412 
1413   /**
1414    * @dev modifier to allow actions only when the contract IS NOT paused
1415    */
1416   modifier whenPaused {
1417     require(paused);
1418     _;
1419   }
1420 
1421   /**
1422    * @dev called by the owner to pause, triggers stopped state
1423    */
1424   function pause() onlyOwner whenNotPaused returns (bool) {
1425     paused = true;
1426     Pause();
1427     return true;
1428   }
1429 
1430   /**
1431    * @dev called by the owner to unpause, returns to normal state
1432    */
1433   function unpause() onlyOwner whenPaused returns (bool) {
1434     paused = false;
1435     Unpause();
1436     return true;
1437   }
1438 }
1439 
1440 
1441 /// @title Clock auction for non-fungible tokens.
1442 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1443 contract ClockAuction is Pausable, ClockAuctionBase {
1444 
1445     /// @dev The ERC-165 interface signature for ERC-721.
1446     ///  Ref: https://github.com/ethereum/EIPs/issues/165
1447     ///  Ref: https://github.com/ethereum/EIPs/issues/721
1448     bytes4 constant InterfaceSignature_ERC721 = bytes4(0x9a20483d);
1449 
1450     /// @dev Constructor creates a reference to the NFT ownership contract
1451     ///  and verifies the owner cut is in the valid range.
1452     /// @param _nftAddress - address of a deployed contract implementing
1453     ///  the Nonfungible Interface.
1454     /// @param _cut - percent cut the owner takes on each auction, must be
1455     ///  between 0-10,000.
1456     function ClockAuction(address _nftAddress, uint256 _cut) public {
1457         require(_cut <= 10000);
1458         ownerCut = _cut;
1459 
1460         ERC721 candidateContract = ERC721(_nftAddress);
1461         require(candidateContract.supportsInterface(InterfaceSignature_ERC721));
1462         nonFungibleContract = candidateContract;
1463     }
1464 
1465     /// @dev Remove all Ether from the contract, which is the owner's cuts
1466     ///  as well as any Ether sent directly to the contract address.
1467     ///  Always transfers to the NFT contract, but can be called either by
1468     ///  the owner or the NFT contract.
1469     function withdrawBalance() external {
1470         address nftAddress = address(nonFungibleContract);
1471 
1472         require(
1473             msg.sender == owner ||
1474             msg.sender == nftAddress
1475         );
1476         // We are using this boolean method to make sure that even if one fails it will still work
1477         bool res = nftAddress.send(this.balance);
1478     }
1479 
1480     /// @dev Creates and begins a new auction.
1481     /// @param _tokenId - ID of token to auction, sender must be owner.
1482     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
1483     /// @param _endingPrice - Price of item (in wei) at end of auction.
1484     /// @param _duration - Length of time to move between starting
1485     ///  price and ending price (in seconds).
1486     /// @param _seller - Seller, if not the message sender
1487     function createAuction(
1488         uint256 _tokenId,
1489         uint256 _startingPrice,
1490         uint256 _endingPrice,
1491         uint256 _duration,
1492         address _seller
1493     )
1494         external
1495         whenNotPaused
1496     {
1497         // Sanity check that no inputs overflow how many bits we've allopuppyed
1498         // to store them in the auction struct.
1499         require(_startingPrice == uint256(uint128(_startingPrice)));
1500         require(_endingPrice == uint256(uint128(_endingPrice)));
1501         require(_duration == uint256(uint64(_duration)));
1502 
1503         require(_owns(msg.sender, _tokenId));
1504         _escrow(msg.sender, _tokenId);
1505         Auction memory auction = Auction(
1506             _seller,
1507             uint128(_startingPrice),
1508             uint128(_endingPrice),
1509             uint64(_duration),
1510             uint64(now)
1511         );
1512         _addAuction(_tokenId, auction);
1513     }
1514 
1515     /// @dev Bids on an open auction, completing the auction and transferring
1516     ///  ownership of the NFT if enough Ether is supplied.
1517     /// @param _tokenId - ID of token to bid on.
1518     function bid(uint256 _tokenId)
1519         external
1520         payable
1521         whenNotPaused
1522     {
1523         // _bid will throw if the bid or funds transfer fails
1524         _bid(_tokenId, msg.value);
1525         _transfer(msg.sender, _tokenId);
1526     }
1527 
1528     /// @dev Cancels an auction that hasn't been won yet.
1529     ///  Returns the NFT to original owner.
1530     /// @notice This is a state-modifying function that can
1531     ///  be called while the contract is paused.
1532     /// @param _tokenId - ID of token on auction
1533     function cancelAuction(uint256 _tokenId)
1534         external
1535     {
1536         Auction storage auction = tokenIdToAuction[_tokenId];
1537         require(_isOnAuction(auction));
1538         address seller = auction.seller;
1539         require(msg.sender == seller);
1540         _cancelAuction(_tokenId, seller);
1541     }
1542 
1543     /// @dev Cancels an auction when the contract is paused.
1544     ///  Only the owner may do this, and NFTs are returned to
1545     ///  the seller. This should only be used in emergencies.
1546     /// @param _tokenId - ID of the NFT on auction to cancel.
1547     function cancelAuctionWhenPaused(uint256 _tokenId)
1548         whenPaused
1549         onlyOwner
1550         external
1551     {
1552         Auction storage auction = tokenIdToAuction[_tokenId];
1553         require(_isOnAuction(auction));
1554         _cancelAuction(_tokenId, auction.seller);
1555     }
1556 
1557     /// @dev Returns auction info for an NFT on auction.
1558     /// @param _tokenId - ID of NFT on auction.
1559     function getAuction(uint256 _tokenId)
1560         external
1561         view
1562         returns
1563     (
1564         address seller,
1565         uint256 startingPrice,
1566         uint256 endingPrice,
1567         uint256 duration,
1568         uint256 startedAt
1569     ) {
1570         Auction storage auction = tokenIdToAuction[_tokenId];
1571         require(_isOnAuction(auction));
1572         return (
1573             auction.seller,
1574             auction.startingPrice,
1575             auction.endingPrice,
1576             auction.duration,
1577             auction.startedAt
1578         );
1579     }
1580 
1581     /// @dev Returns the current price of an auction.
1582     /// @param _tokenId - ID of the token price we are checking.
1583     function getCurrentPrice(uint256 _tokenId)
1584         external
1585         view
1586         returns (uint256)
1587     {
1588         Auction storage auction = tokenIdToAuction[_tokenId];
1589         require(_isOnAuction(auction));
1590         return _currentPrice(auction);
1591     }
1592 
1593 }
1594 
1595 
1596 /// @title Reverse auction modified for siring
1597 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1598 contract SiringClockAuction is ClockAuction {
1599 
1600     // @dev Sanity check that allows us to ensure that we are pointing to the
1601     //  right auction in our setSiringAuctionAddress() call.
1602     bool public isSiringClockAuction = true;
1603 
1604     // Delegate constructor
1605     function SiringClockAuction(address _nftAddr, uint256 _cut) public
1606         ClockAuction(_nftAddr, _cut)
1607     {
1608 
1609     }
1610 
1611     /// @dev Creates and begins a new auction. Since this function is wrapped,
1612     /// require sender to be PuppiesCore contract.
1613     /// @param _tokenId - ID of token to auction, sender must be owner.
1614     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
1615     /// @param _endingPrice - Price of item (in wei) at end of auction.
1616     /// @param _duration - Length of auction (in seconds).
1617     /// @param _seller - Seller, if not the message sender
1618     function createAuction(
1619         uint256 _tokenId,
1620         uint256 _startingPrice,
1621         uint256 _endingPrice,
1622         uint256 _duration,
1623         address _seller
1624     )
1625         external
1626     {
1627         // Sanity check that no inputs overflow how many bits we've allopuppyed
1628         // to store them in the auction struct.
1629         require(_startingPrice == uint256(uint128(_startingPrice)));
1630         require(_endingPrice == uint256(uint128(_endingPrice)));
1631         require(_duration == uint256(uint64(_duration)));
1632 
1633         require(msg.sender == address(nonFungibleContract));
1634         _escrow(_seller, _tokenId);
1635         Auction memory auction = Auction(
1636             _seller,
1637             uint128(_startingPrice),
1638             uint128(_endingPrice),
1639             uint64(_duration),
1640             uint64(now)
1641         );
1642         _addAuction(_tokenId, auction);
1643     }
1644 
1645     /// @dev Places a bid for siring. Requires the sender
1646     /// is the PuppiesCore contract because all bid methods
1647     /// should be wrapped. Also returns the Puppy to the
1648     /// seller rather than the winner.
1649     function bid(uint256 _tokenId)
1650         external
1651         payable
1652     {
1653         require(msg.sender == address(nonFungibleContract));
1654         address seller = tokenIdToAuction[_tokenId].seller;
1655         // _bid checks that token ID is valid and will throw if bid fails
1656         _bid(_tokenId, msg.value);
1657         // We transfer the Puppy back to the seller, the winner will get
1658         // the offspring
1659         _transfer(seller, _tokenId);
1660     }
1661 
1662 }
1663 
1664 
1665 
1666 
1667 
1668 /// @title Clock auction modified for sale of puppies
1669 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1670 contract SaleClockAuction is ClockAuction {
1671 
1672     // @dev Sanity check that allows us to ensure that we are pointing to the
1673     //  right auction in our setSaleAuctionAddress() call.
1674     bool public isSaleClockAuction = true;
1675 
1676     // Tracks last 5 sale price of gen0 Puppy sales
1677     uint256 public gen0SaleCount;
1678     uint256[5] public lastGen0SalePrices;
1679 
1680     // Delegate constructor
1681     function SaleClockAuction(address _nftAddr, uint256 _cut) public ClockAuction(_nftAddr, _cut) {}
1682 
1683     /// @dev Creates and begins a new auction.
1684     /// @param _tokenId - ID of token to auction, sender must be owner.
1685     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
1686     /// @param _endingPrice - Price of item (in wei) at end of auction.
1687     /// @param _duration - Length of auction (in seconds).
1688     /// @param _seller - Seller, if not the message sender
1689     function createAuction(
1690         uint256 _tokenId,
1691         uint256 _startingPrice,
1692         uint256 _endingPrice,
1693         uint256 _duration,
1694         address _seller
1695     )
1696         external
1697     {
1698         // Sanity check that no inputs overflow how many bits we've allopuppyed
1699         // to store them in the auction struct.
1700         require(_startingPrice == uint256(uint128(_startingPrice)));
1701         require(_endingPrice == uint256(uint128(_endingPrice)));
1702         require(_duration == uint256(uint64(_duration)));
1703 
1704         require(msg.sender == address(nonFungibleContract));
1705         _escrow(_seller, _tokenId);
1706         Auction memory auction = Auction(
1707             _seller,
1708             uint128(_startingPrice),
1709             uint128(_endingPrice),
1710             uint64(_duration),
1711             uint64(now)
1712         );
1713         _addAuction(_tokenId, auction);
1714     }
1715 
1716     /// @dev Updates lastSalePrice if seller is the nft contract
1717     /// Otherwise, works the same as default bid method.
1718     function bid(uint256 _tokenId)
1719         external
1720         payable
1721     {
1722         // _bid verifies token ID size
1723         address seller = tokenIdToAuction[_tokenId].seller;
1724         uint256 price = _bid(_tokenId, msg.value);
1725         _transfer(msg.sender, _tokenId);
1726 
1727         // If not a gen0 auction, exit
1728         if (seller == address(nonFungibleContract)) {
1729             // Track gen0 sale prices
1730             lastGen0SalePrices[gen0SaleCount % 5] = price;
1731             gen0SaleCount++;
1732         }
1733     }
1734 
1735     function averageGen0SalePrice() external view returns (uint256) {
1736         uint256 sum = 0;
1737         for (uint256 i = 0; i < 5; i++) {
1738             sum += lastGen0SalePrices[i];
1739         }
1740         return sum / 5;
1741     }
1742 
1743 }
1744 
1745 
1746 /// @title Handles creating auctions for sale and siring of puppies.
1747 ///  This wrapper of ReverseAuction exists only so that users can create
1748 ///  auctions with only one transaction.
1749 contract PuppiesAuction is PuppyBreeding {
1750 
1751     // @notice The auction contract variables are defined in PuppyBase to allow
1752     //  us to refer to them in PuppyOwnership to prevent accidental transfers.
1753     // `saleAuction` refers to the auction for gen0 and p2p sale of puppies.
1754     // `siringAuction` refers to the auction for siring rights of puppies.
1755 
1756     /// @dev Sets the reference to the sale auction.
1757     /// @param _address - Address of sale contract.
1758     function setSaleAuctionAddress(address _address) external onlyCEO {
1759         SaleClockAuction candidateContract = SaleClockAuction(_address);
1760 
1761         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
1762         require(candidateContract.isSaleClockAuction());
1763 
1764         // Set the new contract address
1765         saleAuction = candidateContract;
1766     }
1767 
1768     /// @dev Sets the reference to the siring auction.
1769     /// @param _address - Address of siring contract.
1770     function setSiringAuctionAddress(address _address) external onlyCEO {
1771         SiringClockAuction candidateContract = SiringClockAuction(_address);
1772 
1773         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
1774         require(candidateContract.isSiringClockAuction());
1775 
1776         // Set the new contract address
1777         siringAuction = candidateContract;
1778     }
1779 
1780     /// @dev Put a Puppy up for auction.
1781     ///  Does some ownership trickery to create auctions in one tx.
1782     function createPuppySaleAuction(
1783         uint256 _puppyId,
1784         uint256 _startingPrice,
1785         uint256 _endingPrice,
1786         uint256 _duration
1787     )
1788         external
1789         whenNotPaused
1790     {
1791         // Auction contract checks input sizes
1792         // If Puppy is already on any auction, this will throw
1793         // because it will be owned by the auction contract.
1794         require(_owns(msg.sender, _puppyId));
1795         // Ensure the Puppy is not pregnant to prevent the auction
1796         // contract accidentally receiving ownership of the child.
1797         // NOTE: the Puppy IS allowed to be in a cooldown.
1798         require(!isPregnant(_puppyId));
1799         _approve(_puppyId, saleAuction);
1800         // Sale auction throws if inputs are invalid and clears
1801         // transfer and sire approval after escrowing the Puppy.
1802         saleAuction.createAuction(
1803             _puppyId,
1804             _startingPrice,
1805             _endingPrice,
1806             _duration,
1807             msg.sender
1808         );
1809     }
1810 
1811     /// @dev Put a Puppy up for auction to be sire.
1812     ///  Performs checks to ensure the Puppy can be sired, then
1813     ///  delegates to reverse auction.
1814     function createPuppySiringAuctiona(
1815         uint256 _puppyId,
1816         uint256 _startingPrice,
1817         uint256 _endingPrice,
1818         uint256 _duration
1819     )
1820         external
1821         whenNotPaused
1822     {
1823         // Auction contract checks input sizes
1824         // If Puppy is already on any auction, this will throw
1825         // because it will be owned by the auction contract.
1826         require(_owns(msg.sender, _puppyId));
1827         require(isReadyToBreed(_puppyId));
1828         _approve(_puppyId, siringAuction);
1829         // Siring auction throws if inputs are invalid and clears
1830         // transfer and sire approval after escrowing the Puppy.
1831         siringAuction.createAuction(
1832             _puppyId,
1833             _startingPrice,
1834             _endingPrice,
1835             _duration,
1836             msg.sender
1837         );
1838     }
1839 
1840     /// @dev Completes a siring auction by bidding.
1841     ///  Immediately breeds the winning matron with the sire on auction.
1842     /// @param _sireId - ID of the sire on auction.
1843     /// @param _matronId - ID of the matron owned by the bidder.
1844     function bidOnSiringAuction(
1845         uint256 _sireId,
1846         uint256 _matronId
1847     )
1848         external
1849         payable
1850         whenNotPaused
1851     {
1852         // Auction contract checks input sizes
1853         require(_owns(msg.sender, _matronId));
1854         require(isReadyToBreed(_matronId));
1855         require(_canBreedWithViaAuction(_matronId, _sireId));
1856 
1857         // Define the current price of the auction.
1858         uint256 currentPrice = siringAuction.getCurrentPrice(_sireId);
1859         require(msg.value >= currentPrice + autoBirthFee);
1860 
1861         // Siring auction will throw if the bid fails.
1862         siringAuction.bid.value(msg.value - autoBirthFee)(_sireId);
1863         _breedWith(uint32(_matronId), uint32(_sireId));
1864     }
1865 
1866     /// @dev Transfers the balance of the sale auction contract
1867     /// to the PuppiesCore contract. We use two-step withdrawal to
1868     /// prevent two transfer calls in the auction bid function.
1869     function withdrawAuctionBalances() external onlyCLevel {
1870         saleAuction.withdrawBalance();
1871         siringAuction.withdrawBalance();
1872     }
1873 }
1874 
1875 
1876 /// @title all functions related to creating puppys
1877 contract PuppiesMinting is PuppiesAuction {
1878 
1879     // Limits the number of puppys the contract owner can ever create.
1880     uint256 public constant PROMO_CREATION_LIMIT = 5000;
1881     uint256 public constant GEN0_CREATION_LIMIT = 15000;
1882 
1883     // Constants for gen0 auctions.
1884     uint256 public constant GEN0_STARTING_PRICE = 100 finney;
1885     uint256 public constant GEN0_MINIMAL_PRICE = 10 finney;
1886     uint256 public constant GEN0_AUCTION_DURATION = 2 days;
1887 
1888     // Counts the number of puppys the contract owner has created.
1889     uint256 public promoCreatedCount;
1890     uint256 public gen0CreatedCount;
1891 
1892     /// @dev we can create promo puppys, up to a limit. Only callable by COO
1893     /// @param _genes the encoded genes of the puppy to be created, any value is accepted
1894     /// @param _owner the future owner of the created puppys. Default to contract COO
1895     function createPromoPuppy(uint256 _genes, address _owner, uint16 _strength, uint16 _agility, uint16 _intelligence, uint16 _speed) external onlyCOO {
1896         address puppyOwner = _owner;
1897         if (puppyOwner == address(0)) {
1898              puppyOwner = cooAddress;
1899         }
1900         require(promoCreatedCount < PROMO_CREATION_LIMIT);
1901 
1902         promoCreatedCount++;
1903         _createPuppy(0, 0, 0, _genes, puppyOwner, _strength, _agility, _intelligence, _speed);
1904     }
1905 
1906     /// @dev Creates a new gen0 Puppy with the given genes and
1907     ///  creates an auction for it.
1908     function createGen0Auction(uint256 _genes, uint16 _strength, uint16 _agility, uint16 _intelligence, uint16 _speed, uint16 _talent) external onlyCOO {
1909         require(gen0CreatedCount < GEN0_CREATION_LIMIT);
1910 
1911         uint256 puppyId = _createPuppy(0, 0, 0, _genes, address(this), _strength, _agility, _intelligence, _speed);
1912         _approve(puppyId, saleAuction);
1913 
1914         saleAuction.createAuction(
1915             puppyId,
1916             _computeNextGen0Price(),
1917             GEN0_MINIMAL_PRICE,
1918             GEN0_AUCTION_DURATION,
1919             address(this)
1920         );
1921 
1922         gen0CreatedCount++;
1923     }
1924 
1925     /// @dev Computes the next gen0 auction starting price, given
1926     ///  the average of the past 5 prices + 50%.
1927     function _computeNextGen0Price() internal view returns (uint256) {
1928         uint256 avePrice = saleAuction.averageGen0SalePrice();
1929 
1930         // Sanity check to ensure we don't overflow arithmetic
1931         require(avePrice == uint256(uint128(avePrice)));
1932 
1933         uint256 nextPrice = avePrice + (avePrice / 2);
1934 
1935         // We never auction for less than starting price
1936         if (nextPrice < GEN0_STARTING_PRICE) {
1937             nextPrice = GEN0_STARTING_PRICE;
1938         }
1939 
1940         return nextPrice;
1941     }
1942 }
1943 
1944 
1945 /// @title CryptoPuppies: Collectible, breedable, and oh-so-adorable puppys on the Ethereum blockchain.
1946 /// @author Axiom Zen (https://www.axiomzen.co)
1947 /// @dev The main CryptoPuppies contract, keeps track of puppys so they don't wander around and get lost.
1948 contract PuppiesCore is PuppiesMinting {
1949 
1950     // This is the main CryptoPuppies contract. In order to keep our code seperated into logical sections,
1951     // we've broken it up in two ways. First, we have several seperately-instantiated sibling contracts
1952     // that handle auctions and our super-top-secret genetic combination algorithm. The auctions are
1953     // seperate since their logic is somewhat complex and there's always a risk of subtle bugs. By keeping
1954     // them in their own contracts, we can upgrade them without disrupting the main contract that tracks
1955     // Puppy ownership. The genetic combination algorithm is kept seperate so we can open-source all of
1956     // the rest of our code without making it _too_ easy for folks to figure out how the genetics work.
1957     // Don't worry, I'm sure someone will reverse engineer it soon enough!
1958     //
1959     // Secondly, we break the core contract into multiple files using inheritence, one for each major
1960     // facet of functionality of CK. This allows us to keep related code bundled together while still
1961     // avoiding a single giant file with everything in it. The breakdown is as follows:
1962     //
1963     //      - PuppyBase: This is where we define the most fundamental code shared throughout the core
1964     //             functionality. This includes our main data storage, constants and data types, plus
1965     //             internal functions for managing these items.
1966     //
1967     //      - PuppyAccessControl: This contract manages the various addresses and constraints for operations
1968     //             that can be executed only by specific roles. Namely CEO, CFO and COO.
1969     //
1970     //      - PuppyOwnership: This provides the methods required for basic non-fungible token
1971     //             transactions, following the draft ERC-721 spec (https://github.com/ethereum/EIPs/issues/721).
1972     //
1973     //      - PuppyBreeding: This file contains the methods necessary to breed puppys together, including
1974     //             keeping track of siring offers, and relies on an external genetic combination contract.
1975     //
1976     //      - PuppyAuctions: Here we have the public methods for auctioning or bidding on puppys or siring
1977     //             services. The actual auction functionality is handled in two sibling contracts (one
1978     //             for sales and one for siring), while auction creation and bidding is mostly mediated
1979     //             through this facet of the core contract.
1980     //
1981     //      - PuppiesMinting: This final facet contains the functionality we use for creating new gen0 puppys.
1982     //             We can make up to 5000 "promo" puppys that can be given away (especially important when
1983     //             the community is new), and all others can only be created and then immediately put up
1984     //             for auction via an algorithmically determined starting price. Regardless of how they
1985     //             are created, there is a hard limit of 50k gen0 puppys. After that, it's all up to the
1986     //             community to breed, breed, breed!
1987 
1988     // Set in case the core contract is broken and an upgrade is required
1989     address public newContractAddress;
1990 
1991     /// @notice Creates the main CryptoPuppies smart contract instance.
1992     function PuppiesCore() public {
1993         // Starts paused.
1994         paused = true;
1995 
1996         // the creator of the contract is the initial CEO
1997         ceoAddress = msg.sender;
1998 
1999         // the creator of the contract is also the initial COO
2000         cooAddress = msg.sender;
2001 
2002         // start with the mythical puppy 0 - so we don't have generation-0 parent issues
2003         _createPuppy(0, 0, 0, uint256(-1), address(0), 0, 0, 0, 0);
2004     }
2005 
2006     /// @dev Used to mark the smart contract as upgraded, in case there is a serious
2007     ///  breaking bug. This method does nothing but keep track of the new contract and
2008     ///  emit a message indipuppying that the new address is set. It's up to clients of this
2009     ///  contract to update to the new contract address in that case. (This contract will
2010     ///  be paused indefinitely if such an upgrade takes place.)
2011     /// @param _v2Address new address
2012     function setNewAddress(address _v2Address) external onlyCEO whenPaused {
2013         // See README.md for updgrade plan
2014         newContractAddress = _v2Address;
2015         ContractUpgrade(_v2Address);
2016     }
2017 
2018     /// @notice No tipping!
2019     /// @dev Reject all Ether from being sent here, unless it's from one of the
2020     ///  two auction contracts. (Hopefully, we can prevent user accidents.)
2021     function() external payable {
2022         require(
2023             msg.sender == address(saleAuction) ||
2024             msg.sender == address(siringAuction)
2025         );
2026     }
2027 
2028     /// @notice Returns all the relevant information about a specific Puppy.
2029     /// @param _id The ID of the Puppy of interest.
2030     function getPuppy(uint256 _id)
2031         external
2032         view
2033         returns (
2034         bool isGestating,
2035         bool isReady,
2036         uint256 cooldownIndex,
2037         uint256 nextActionAt,
2038         uint256 siringWithId,
2039         uint256 birthTime,
2040         uint256 matronId,
2041         uint256 sireId,
2042         uint256 generation,
2043         uint256 genes
2044     ) {
2045         Puppy storage pup = puppies[_id];
2046 
2047         // if this variable is 0 then it's not gestating
2048         isGestating = (pup.siringWithId != 0);
2049         isReady = (pup.cooldownEndBlock <= block.number);
2050         cooldownIndex = uint256(pup.cooldownIndex);
2051         nextActionAt = uint256(pup.cooldownEndBlock);
2052         siringWithId = uint256(pup.siringWithId);
2053         birthTime = uint256(pup.birthTime);
2054         matronId = uint256(pup.matronId);
2055         sireId = uint256(pup.sireId);
2056         generation = uint256(pup.generation);
2057         genes = pup.genes;
2058     }
2059 
2060     function getPuppyAttributes(uint256 _id)
2061     external
2062         view
2063         returns (
2064         uint16 childNumber,
2065         uint16 strength,
2066         uint16 agility,
2067         uint16 intelligence,
2068         uint16 speed
2069     ) {
2070         Puppy storage pup = puppies[_id];
2071 
2072         // if this variable is 0 then it's not gestating
2073         childNumber = uint16(pup.childNumber);
2074         strength = uint16(pup.strength);
2075         agility = uint16(pup.agility);
2076         intelligence = uint16(pup.intelligence);
2077         speed = uint16(pup.speed);
2078     }
2079 
2080     /// @dev Override unpause so it requires all external contract addresses
2081     ///  to be set before contract can be unpaused. Also, we can't have
2082     ///  newContractAddress set either, because then the contract was upgraded.
2083     /// @notice This is public rather than external so we can call super.unpause
2084     ///  without using an expensive CALL.
2085     function unpause() public onlyCEO whenPaused {
2086         require(saleAuction != address(0));
2087         require(siringAuction != address(0));
2088         //require(geneScience != address(0));
2089         //require(newContractAddress == address(0));
2090 
2091         // Actually unpause the contract.
2092         super.unpause();
2093     }
2094 
2095     // @dev Allows the CFO to capture the balance available to the contract.
2096     function withdrawBalance() external onlyCFO {
2097         uint256 balance = this.balance;
2098         // Subtract all the currently pregnant puppys we have, plus 1 of margin.
2099         uint256 subtractFees = (pregnantpuppies + 1) * autoBirthFee;
2100 
2101         if (balance > subtractFees) {
2102             cfoAddress.send(balance - subtractFees);
2103         }
2104     }
2105 }