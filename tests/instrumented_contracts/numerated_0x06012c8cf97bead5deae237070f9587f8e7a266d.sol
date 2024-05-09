1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) onlyOwner {
36     if (newOwner != address(0)) {
37       owner = newOwner;
38     }
39   }
40 
41 }
42 
43 
44 
45 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
46 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
47 contract ERC721 {
48     // Required methods
49     function totalSupply() public view returns (uint256 total);
50     function balanceOf(address _owner) public view returns (uint256 balance);
51     function ownerOf(uint256 _tokenId) external view returns (address owner);
52     function approve(address _to, uint256 _tokenId) external;
53     function transfer(address _to, uint256 _tokenId) external;
54     function transferFrom(address _from, address _to, uint256 _tokenId) external;
55 
56     // Events
57     event Transfer(address from, address to, uint256 tokenId);
58     event Approval(address owner, address approved, uint256 tokenId);
59 
60     // Optional
61     // function name() public view returns (string name);
62     // function symbol() public view returns (string symbol);
63     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
64     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
65 
66     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
67     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
68 }
69 
70 
71 // // Auction wrapper functions
72 
73 
74 // Auction wrapper functions
75 
76 
77 
78 
79 
80 
81 
82 /// @title SEKRETOOOO
83 contract GeneScienceInterface {
84     /// @dev simply a boolean to indicate this is the contract we expect to be
85     function isGeneScience() public pure returns (bool);
86 
87     /// @dev given genes of kitten 1 & 2, return a genetic combination - may have a random factor
88     /// @param genes1 genes of mom
89     /// @param genes2 genes of sire
90     /// @return the genes that are supposed to be passed down the child
91     function mixGenes(uint256 genes1, uint256 genes2, uint256 targetBlock) public returns (uint256);
92 }
93 
94 
95 
96 
97 
98 
99 
100 /// @title A facet of KittyCore that manages special access privileges.
101 /// @author Axiom Zen (https://www.axiomzen.co)
102 /// @dev See the KittyCore contract documentation to understand how the various contract facets are arranged.
103 contract KittyAccessControl {
104     // This facet controls access control for CryptoKitties. There are four roles managed here:
105     //
106     //     - The CEO: The CEO can reassign other roles and change the addresses of our dependent smart
107     //         contracts. It is also the only role that can unpause the smart contract. It is initially
108     //         set to the address that created the smart contract in the KittyCore constructor.
109     //
110     //     - The CFO: The CFO can withdraw funds from KittyCore and its auction contracts.
111     //
112     //     - The COO: The COO can release gen0 kitties to auction, and mint promo cats.
113     //
114     // It should be noted that these roles are distinct without overlap in their access abilities, the
115     // abilities listed for each role above are exhaustive. In particular, while the CEO can assign any
116     // address to any role, the CEO address itself doesn't have the ability to act in those roles. This
117     // restriction is intentional so that we aren't tempted to use the CEO address frequently out of
118     // convenience. The less we use an address, the less likely it is that we somehow compromise the
119     // account.
120 
121     /// @dev Emited when contract is upgraded - See README.md for updgrade plan
122     event ContractUpgrade(address newContract);
123 
124     // The addresses of the accounts (or contracts) that can execute actions within each roles.
125     address public ceoAddress;
126     address public cfoAddress;
127     address public cooAddress;
128 
129     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
130     bool public paused = false;
131 
132     /// @dev Access modifier for CEO-only functionality
133     modifier onlyCEO() {
134         require(msg.sender == ceoAddress);
135         _;
136     }
137 
138     /// @dev Access modifier for CFO-only functionality
139     modifier onlyCFO() {
140         require(msg.sender == cfoAddress);
141         _;
142     }
143 
144     /// @dev Access modifier for COO-only functionality
145     modifier onlyCOO() {
146         require(msg.sender == cooAddress);
147         _;
148     }
149 
150     modifier onlyCLevel() {
151         require(
152             msg.sender == cooAddress ||
153             msg.sender == ceoAddress ||
154             msg.sender == cfoAddress
155         );
156         _;
157     }
158 
159     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
160     /// @param _newCEO The address of the new CEO
161     function setCEO(address _newCEO) external onlyCEO {
162         require(_newCEO != address(0));
163 
164         ceoAddress = _newCEO;
165     }
166 
167     /// @dev Assigns a new address to act as the CFO. Only available to the current CEO.
168     /// @param _newCFO The address of the new CFO
169     function setCFO(address _newCFO) external onlyCEO {
170         require(_newCFO != address(0));
171 
172         cfoAddress = _newCFO;
173     }
174 
175     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
176     /// @param _newCOO The address of the new COO
177     function setCOO(address _newCOO) external onlyCEO {
178         require(_newCOO != address(0));
179 
180         cooAddress = _newCOO;
181     }
182 
183     /*** Pausable functionality adapted from OpenZeppelin ***/
184 
185     /// @dev Modifier to allow actions only when the contract IS NOT paused
186     modifier whenNotPaused() {
187         require(!paused);
188         _;
189     }
190 
191     /// @dev Modifier to allow actions only when the contract IS paused
192     modifier whenPaused {
193         require(paused);
194         _;
195     }
196 
197     /// @dev Called by any "C-level" role to pause the contract. Used only when
198     ///  a bug or exploit is detected and we need to limit damage.
199     function pause() external onlyCLevel whenNotPaused {
200         paused = true;
201     }
202 
203     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
204     ///  one reason we may pause the contract is when CFO or COO accounts are
205     ///  compromised.
206     /// @notice This is public rather than external so it can be called by
207     ///  derived contracts.
208     function unpause() public onlyCEO whenPaused {
209         // can't unpause if contract was upgraded
210         paused = false;
211     }
212 }
213 
214 
215 
216 
217 /// @title Base contract for CryptoKitties. Holds all common structs, events and base variables.
218 /// @author Axiom Zen (https://www.axiomzen.co)
219 /// @dev See the KittyCore contract documentation to understand how the various contract facets are arranged.
220 contract KittyBase is KittyAccessControl {
221     /*** EVENTS ***/
222 
223     /// @dev The Birth event is fired whenever a new kitten comes into existence. This obviously
224     ///  includes any time a cat is created through the giveBirth method, but it is also called
225     ///  when a new gen0 cat is created.
226     event Birth(address owner, uint256 kittyId, uint256 matronId, uint256 sireId, uint256 genes);
227 
228     /// @dev Transfer event as defined in current draft of ERC721. Emitted every time a kitten
229     ///  ownership is assigned, including births.
230     event Transfer(address from, address to, uint256 tokenId);
231 
232     /*** DATA TYPES ***/
233 
234     /// @dev The main Kitty struct. Every cat in CryptoKitties is represented by a copy
235     ///  of this structure, so great care was taken to ensure that it fits neatly into
236     ///  exactly two 256-bit words. Note that the order of the members in this structure
237     ///  is important because of the byte-packing rules used by Ethereum.
238     ///  Ref: http://solidity.readthedocs.io/en/develop/miscellaneous.html
239     struct Kitty {
240         // The Kitty's genetic code is packed into these 256-bits, the format is
241         // sooper-sekret! A cat's genes never change.
242         uint256 genes;
243 
244         // The timestamp from the block when this cat came into existence.
245         uint64 birthTime;
246 
247         // The minimum timestamp after which this cat can engage in breeding
248         // activities again. This same timestamp is used for the pregnancy
249         // timer (for matrons) as well as the siring cooldown.
250         uint64 cooldownEndBlock;
251 
252         // The ID of the parents of this kitty, set to 0 for gen0 cats.
253         // Note that using 32-bit unsigned integers limits us to a "mere"
254         // 4 billion cats. This number might seem small until you realize
255         // that Ethereum currently has a limit of about 500 million
256         // transactions per year! So, this definitely won't be a problem
257         // for several years (even as Ethereum learns to scale).
258         uint32 matronId;
259         uint32 sireId;
260 
261         // Set to the ID of the sire cat for matrons that are pregnant,
262         // zero otherwise. A non-zero value here is how we know a cat
263         // is pregnant. Used to retrieve the genetic material for the new
264         // kitten when the birth transpires.
265         uint32 siringWithId;
266 
267         // Set to the index in the cooldown array (see below) that represents
268         // the current cooldown duration for this Kitty. This starts at zero
269         // for gen0 cats, and is initialized to floor(generation/2) for others.
270         // Incremented by one for each successful breeding action, regardless
271         // of whether this cat is acting as matron or sire.
272         uint16 cooldownIndex;
273 
274         // The "generation number" of this cat. Cats minted by the CK contract
275         // for sale are called "gen0" and have a generation number of 0. The
276         // generation number of all other cats is the larger of the two generation
277         // numbers of their parents, plus one.
278         // (i.e. max(matron.generation, sire.generation) + 1)
279         uint16 generation;
280     }
281 
282     /*** CONSTANTS ***/
283 
284     /// @dev A lookup table indicating the cooldown duration after any successful
285     ///  breeding action, called "pregnancy time" for matrons and "siring cooldown"
286     ///  for sires. Designed such that the cooldown roughly doubles each time a cat
287     ///  is bred, encouraging owners not to just keep breeding the same cat over
288     ///  and over again. Caps out at one week (a cat can breed an unbounded number
289     ///  of times, and the maximum cooldown is always seven days).
290     uint32[14] public cooldowns = [
291         uint32(1 minutes),
292         uint32(2 minutes),
293         uint32(5 minutes),
294         uint32(10 minutes),
295         uint32(30 minutes),
296         uint32(1 hours),
297         uint32(2 hours),
298         uint32(4 hours),
299         uint32(8 hours),
300         uint32(16 hours),
301         uint32(1 days),
302         uint32(2 days),
303         uint32(4 days),
304         uint32(7 days)
305     ];
306 
307     // An approximation of currently how many seconds are in between blocks.
308     uint256 public secondsPerBlock = 15;
309 
310     /*** STORAGE ***/
311 
312     /// @dev An array containing the Kitty struct for all Kitties in existence. The ID
313     ///  of each cat is actually an index into this array. Note that ID 0 is a negacat,
314     ///  the unKitty, the mythical beast that is the parent of all gen0 cats. A bizarre
315     ///  creature that is both matron and sire... to itself! Has an invalid genetic code.
316     ///  In other words, cat ID 0 is invalid... ;-)
317     Kitty[] kitties;
318 
319     /// @dev A mapping from cat IDs to the address that owns them. All cats have
320     ///  some valid owner address, even gen0 cats are created with a non-zero owner.
321     mapping (uint256 => address) public kittyIndexToOwner;
322 
323     // @dev A mapping from owner address to count of tokens that address owns.
324     //  Used internally inside balanceOf() to resolve ownership count.
325     mapping (address => uint256) ownershipTokenCount;
326 
327     /// @dev A mapping from KittyIDs to an address that has been approved to call
328     ///  transferFrom(). Each Kitty can only have one approved address for transfer
329     ///  at any time. A zero value means no approval is outstanding.
330     mapping (uint256 => address) public kittyIndexToApproved;
331 
332     /// @dev A mapping from KittyIDs to an address that has been approved to use
333     ///  this Kitty for siring via breedWith(). Each Kitty can only have one approved
334     ///  address for siring at any time. A zero value means no approval is outstanding.
335     mapping (uint256 => address) public sireAllowedToAddress;
336 
337     /// @dev The address of the ClockAuction contract that handles sales of Kitties. This
338     ///  same contract handles both peer-to-peer sales as well as the gen0 sales which are
339     ///  initiated every 15 minutes.
340     SaleClockAuction public saleAuction;
341 
342     /// @dev The address of a custom ClockAuction subclassed contract that handles siring
343     ///  auctions. Needs to be separate from saleAuction because the actions taken on success
344     ///  after a sales and siring auction are quite different.
345     SiringClockAuction public siringAuction;
346 
347     /// @dev Assigns ownership of a specific Kitty to an address.
348     function _transfer(address _from, address _to, uint256 _tokenId) internal {
349         // Since the number of kittens is capped to 2^32 we can't overflow this
350         ownershipTokenCount[_to]++;
351         // transfer ownership
352         kittyIndexToOwner[_tokenId] = _to;
353         // When creating new kittens _from is 0x0, but we can't account that address.
354         if (_from != address(0)) {
355             ownershipTokenCount[_from]--;
356             // once the kitten is transferred also clear sire allowances
357             delete sireAllowedToAddress[_tokenId];
358             // clear any previously approved ownership exchange
359             delete kittyIndexToApproved[_tokenId];
360         }
361         // Emit the transfer event.
362         Transfer(_from, _to, _tokenId);
363     }
364 
365     /// @dev An internal method that creates a new kitty and stores it. This
366     ///  method doesn't do any checking and should only be called when the
367     ///  input data is known to be valid. Will generate both a Birth event
368     ///  and a Transfer event.
369     /// @param _matronId The kitty ID of the matron of this cat (zero for gen0)
370     /// @param _sireId The kitty ID of the sire of this cat (zero for gen0)
371     /// @param _generation The generation number of this cat, must be computed by caller.
372     /// @param _genes The kitty's genetic code.
373     /// @param _owner The inital owner of this cat, must be non-zero (except for the unKitty, ID 0)
374     function _createKitty(
375         uint256 _matronId,
376         uint256 _sireId,
377         uint256 _generation,
378         uint256 _genes,
379         address _owner
380     )
381         internal
382         returns (uint)
383     {
384         // These requires are not strictly necessary, our calling code should make
385         // sure that these conditions are never broken. However! _createKitty() is already
386         // an expensive call (for storage), and it doesn't hurt to be especially careful
387         // to ensure our data structures are always valid.
388         require(_matronId == uint256(uint32(_matronId)));
389         require(_sireId == uint256(uint32(_sireId)));
390         require(_generation == uint256(uint16(_generation)));
391 
392         // New kitty starts with the same cooldown as parent gen/2
393         uint16 cooldownIndex = uint16(_generation / 2);
394         if (cooldownIndex > 13) {
395             cooldownIndex = 13;
396         }
397 
398         Kitty memory _kitty = Kitty({
399             genes: _genes,
400             birthTime: uint64(now),
401             cooldownEndBlock: 0,
402             matronId: uint32(_matronId),
403             sireId: uint32(_sireId),
404             siringWithId: 0,
405             cooldownIndex: cooldownIndex,
406             generation: uint16(_generation)
407         });
408         uint256 newKittenId = kitties.push(_kitty) - 1;
409 
410         // It's probably never going to happen, 4 billion cats is A LOT, but
411         // let's just be 100% sure we never let this happen.
412         require(newKittenId == uint256(uint32(newKittenId)));
413 
414         // emit the birth event
415         Birth(
416             _owner,
417             newKittenId,
418             uint256(_kitty.matronId),
419             uint256(_kitty.sireId),
420             _kitty.genes
421         );
422 
423         // This will assign ownership, and also emit the Transfer event as
424         // per ERC721 draft
425         _transfer(0, _owner, newKittenId);
426 
427         return newKittenId;
428     }
429 
430     // Any C-level can fix how many seconds per blocks are currently observed.
431     function setSecondsPerBlock(uint256 secs) external onlyCLevel {
432         require(secs < cooldowns[0]);
433         secondsPerBlock = secs;
434     }
435 }
436 
437 
438 
439 
440 
441 /// @title The external contract that is responsible for generating metadata for the kitties,
442 ///  it has one function that will return the data as bytes.
443 contract ERC721Metadata {
444     /// @dev Given a token Id, returns a byte array that is supposed to be converted into string.
445     function getMetadata(uint256 _tokenId, string) public view returns (bytes32[4] buffer, uint256 count) {
446         if (_tokenId == 1) {
447             buffer[0] = "Hello World! :D";
448             count = 15;
449         } else if (_tokenId == 2) {
450             buffer[0] = "I would definitely choose a medi";
451             buffer[1] = "um length string.";
452             count = 49;
453         } else if (_tokenId == 3) {
454             buffer[0] = "Lorem ipsum dolor sit amet, mi e";
455             buffer[1] = "st accumsan dapibus augue lorem,";
456             buffer[2] = " tristique vestibulum id, libero";
457             buffer[3] = " suscipit varius sapien aliquam.";
458             count = 128;
459         }
460     }
461 }
462 
463 
464 /// @title The facet of the CryptoKitties core contract that manages ownership, ERC-721 (draft) compliant.
465 /// @author Axiom Zen (https://www.axiomzen.co)
466 /// @dev Ref: https://github.com/ethereum/EIPs/issues/721
467 ///  See the KittyCore contract documentation to understand how the various contract facets are arranged.
468 contract KittyOwnership is KittyBase, ERC721 {
469 
470     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
471     string public constant name = "CryptoKitties";
472     string public constant symbol = "CK";
473 
474     // The contract that will return kitty metadata
475     ERC721Metadata public erc721Metadata;
476 
477     bytes4 constant InterfaceSignature_ERC165 =
478         bytes4(keccak256('supportsInterface(bytes4)'));
479 
480     bytes4 constant InterfaceSignature_ERC721 =
481         bytes4(keccak256('name()')) ^
482         bytes4(keccak256('symbol()')) ^
483         bytes4(keccak256('totalSupply()')) ^
484         bytes4(keccak256('balanceOf(address)')) ^
485         bytes4(keccak256('ownerOf(uint256)')) ^
486         bytes4(keccak256('approve(address,uint256)')) ^
487         bytes4(keccak256('transfer(address,uint256)')) ^
488         bytes4(keccak256('transferFrom(address,address,uint256)')) ^
489         bytes4(keccak256('tokensOfOwner(address)')) ^
490         bytes4(keccak256('tokenMetadata(uint256,string)'));
491 
492     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
493     ///  Returns true for any standardized interfaces implemented by this contract. We implement
494     ///  ERC-165 (obviously!) and ERC-721.
495     function supportsInterface(bytes4 _interfaceID) external view returns (bool)
496     {
497         // DEBUG ONLY
498         //require((InterfaceSignature_ERC165 == 0x01ffc9a7) && (InterfaceSignature_ERC721 == 0x9a20483d));
499 
500         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
501     }
502 
503     /// @dev Set the address of the sibling contract that tracks metadata.
504     ///  CEO only.
505     function setMetadataAddress(address _contractAddress) public onlyCEO {
506         erc721Metadata = ERC721Metadata(_contractAddress);
507     }
508 
509     // Internal utility functions: These functions all assume that their input arguments
510     // are valid. We leave it to public methods to sanitize their inputs and follow
511     // the required logic.
512 
513     /// @dev Checks if a given address is the current owner of a particular Kitty.
514     /// @param _claimant the address we are validating against.
515     /// @param _tokenId kitten id, only valid when > 0
516     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
517         return kittyIndexToOwner[_tokenId] == _claimant;
518     }
519 
520     /// @dev Checks if a given address currently has transferApproval for a particular Kitty.
521     /// @param _claimant the address we are confirming kitten is approved for.
522     /// @param _tokenId kitten id, only valid when > 0
523     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
524         return kittyIndexToApproved[_tokenId] == _claimant;
525     }
526 
527     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
528     ///  approval. Setting _approved to address(0) clears all transfer approval.
529     ///  NOTE: _approve() does NOT send the Approval event. This is intentional because
530     ///  _approve() and transferFrom() are used together for putting Kitties on auction, and
531     ///  there is no value in spamming the log with Approval events in that case.
532     function _approve(uint256 _tokenId, address _approved) internal {
533         kittyIndexToApproved[_tokenId] = _approved;
534     }
535 
536     /// @notice Returns the number of Kitties owned by a specific address.
537     /// @param _owner The owner address to check.
538     /// @dev Required for ERC-721 compliance
539     function balanceOf(address _owner) public view returns (uint256 count) {
540         return ownershipTokenCount[_owner];
541     }
542 
543     /// @notice Transfers a Kitty to another address. If transferring to a smart
544     ///  contract be VERY CAREFUL to ensure that it is aware of ERC-721 (or
545     ///  CryptoKitties specifically) or your Kitty may be lost forever. Seriously.
546     /// @param _to The address of the recipient, can be a user or contract.
547     /// @param _tokenId The ID of the Kitty to transfer.
548     /// @dev Required for ERC-721 compliance.
549     function transfer(
550         address _to,
551         uint256 _tokenId
552     )
553         external
554         whenNotPaused
555     {
556         // Safety check to prevent against an unexpected 0x0 default.
557         require(_to != address(0));
558         // Disallow transfers to this contract to prevent accidental misuse.
559         // The contract should never own any kitties (except very briefly
560         // after a gen0 cat is created and before it goes on auction).
561         require(_to != address(this));
562         // Disallow transfers to the auction contracts to prevent accidental
563         // misuse. Auction contracts should only take ownership of kitties
564         // through the allow + transferFrom flow.
565         require(_to != address(saleAuction));
566         require(_to != address(siringAuction));
567 
568         // You can only send your own cat.
569         require(_owns(msg.sender, _tokenId));
570 
571         // Reassign ownership, clear pending approvals, emit Transfer event.
572         _transfer(msg.sender, _to, _tokenId);
573     }
574 
575     /// @notice Grant another address the right to transfer a specific Kitty via
576     ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
577     /// @param _to The address to be granted transfer approval. Pass address(0) to
578     ///  clear all approvals.
579     /// @param _tokenId The ID of the Kitty that can be transferred if this call succeeds.
580     /// @dev Required for ERC-721 compliance.
581     function approve(
582         address _to,
583         uint256 _tokenId
584     )
585         external
586         whenNotPaused
587     {
588         // Only an owner can grant transfer approval.
589         require(_owns(msg.sender, _tokenId));
590 
591         // Register the approval (replacing any previous approval).
592         _approve(_tokenId, _to);
593 
594         // Emit approval event.
595         Approval(msg.sender, _to, _tokenId);
596     }
597 
598     /// @notice Transfer a Kitty owned by another address, for which the calling address
599     ///  has previously been granted transfer approval by the owner.
600     /// @param _from The address that owns the Kitty to be transfered.
601     /// @param _to The address that should take ownership of the Kitty. Can be any address,
602     ///  including the caller.
603     /// @param _tokenId The ID of the Kitty to be transferred.
604     /// @dev Required for ERC-721 compliance.
605     function transferFrom(
606         address _from,
607         address _to,
608         uint256 _tokenId
609     )
610         external
611         whenNotPaused
612     {
613         // Safety check to prevent against an unexpected 0x0 default.
614         require(_to != address(0));
615         // Disallow transfers to this contract to prevent accidental misuse.
616         // The contract should never own any kitties (except very briefly
617         // after a gen0 cat is created and before it goes on auction).
618         require(_to != address(this));
619         // Check for approval and valid ownership
620         require(_approvedFor(msg.sender, _tokenId));
621         require(_owns(_from, _tokenId));
622 
623         // Reassign ownership (also clears pending approvals and emits Transfer event).
624         _transfer(_from, _to, _tokenId);
625     }
626 
627     /// @notice Returns the total number of Kitties currently in existence.
628     /// @dev Required for ERC-721 compliance.
629     function totalSupply() public view returns (uint) {
630         return kitties.length - 1;
631     }
632 
633     /// @notice Returns the address currently assigned ownership of a given Kitty.
634     /// @dev Required for ERC-721 compliance.
635     function ownerOf(uint256 _tokenId)
636         external
637         view
638         returns (address owner)
639     {
640         owner = kittyIndexToOwner[_tokenId];
641 
642         require(owner != address(0));
643     }
644 
645     /// @notice Returns a list of all Kitty IDs assigned to an address.
646     /// @param _owner The owner whose Kitties we are interested in.
647     /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
648     ///  expensive (it walks the entire Kitty array looking for cats belonging to owner),
649     ///  but it also returns a dynamic array, which is only supported for web3 calls, and
650     ///  not contract-to-contract calls.
651     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
652         uint256 tokenCount = balanceOf(_owner);
653 
654         if (tokenCount == 0) {
655             // Return an empty array
656             return new uint256[](0);
657         } else {
658             uint256[] memory result = new uint256[](tokenCount);
659             uint256 totalCats = totalSupply();
660             uint256 resultIndex = 0;
661 
662             // We count on the fact that all cats have IDs starting at 1 and increasing
663             // sequentially up to the totalCat count.
664             uint256 catId;
665 
666             for (catId = 1; catId <= totalCats; catId++) {
667                 if (kittyIndexToOwner[catId] == _owner) {
668                     result[resultIndex] = catId;
669                     resultIndex++;
670                 }
671             }
672 
673             return result;
674         }
675     }
676 
677     /// @dev Adapted from memcpy() by @arachnid (Nick Johnson <arachnid@notdot.net>)
678     ///  This method is licenced under the Apache License.
679     ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
680     function _memcpy(uint _dest, uint _src, uint _len) private view {
681         // Copy word-length chunks while possible
682         for(; _len >= 32; _len -= 32) {
683             assembly {
684                 mstore(_dest, mload(_src))
685             }
686             _dest += 32;
687             _src += 32;
688         }
689 
690         // Copy remaining bytes
691         uint256 mask = 256 ** (32 - _len) - 1;
692         assembly {
693             let srcpart := and(mload(_src), not(mask))
694             let destpart := and(mload(_dest), mask)
695             mstore(_dest, or(destpart, srcpart))
696         }
697     }
698 
699     /// @dev Adapted from toString(slice) by @arachnid (Nick Johnson <arachnid@notdot.net>)
700     ///  This method is licenced under the Apache License.
701     ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
702     function _toString(bytes32[4] _rawBytes, uint256 _stringLength) private view returns (string) {
703         var outputString = new string(_stringLength);
704         uint256 outputPtr;
705         uint256 bytesPtr;
706 
707         assembly {
708             outputPtr := add(outputString, 32)
709             bytesPtr := _rawBytes
710         }
711 
712         _memcpy(outputPtr, bytesPtr, _stringLength);
713 
714         return outputString;
715     }
716 
717     /// @notice Returns a URI pointing to a metadata package for this token conforming to
718     ///  ERC-721 (https://github.com/ethereum/EIPs/issues/721)
719     /// @param _tokenId The ID number of the Kitty whose metadata should be returned.
720     function tokenMetadata(uint256 _tokenId, string _preferredTransport) external view returns (string infoUrl) {
721         require(erc721Metadata != address(0));
722         bytes32[4] memory buffer;
723         uint256 count;
724         (buffer, count) = erc721Metadata.getMetadata(_tokenId, _preferredTransport);
725 
726         return _toString(buffer, count);
727     }
728 }
729 
730 
731 
732 /// @title A facet of KittyCore that manages Kitty siring, gestation, and birth.
733 /// @author Axiom Zen (https://www.axiomzen.co)
734 /// @dev See the KittyCore contract documentation to understand how the various contract facets are arranged.
735 contract KittyBreeding is KittyOwnership {
736 
737     /// @dev The Pregnant event is fired when two cats successfully breed and the pregnancy
738     ///  timer begins for the matron.
739     event Pregnant(address owner, uint256 matronId, uint256 sireId, uint256 cooldownEndBlock);
740 
741     /// @notice The minimum payment required to use breedWithAuto(). This fee goes towards
742     ///  the gas cost paid by whatever calls giveBirth(), and can be dynamically updated by
743     ///  the COO role as the gas price changes.
744     uint256 public autoBirthFee = 2 finney;
745 
746     // Keeps track of number of pregnant kitties.
747     uint256 public pregnantKitties;
748 
749     /// @dev The address of the sibling contract that is used to implement the sooper-sekret
750     ///  genetic combination algorithm.
751     GeneScienceInterface public geneScience;
752 
753     /// @dev Update the address of the genetic contract, can only be called by the CEO.
754     /// @param _address An address of a GeneScience contract instance to be used from this point forward.
755     function setGeneScienceAddress(address _address) external onlyCEO {
756         GeneScienceInterface candidateContract = GeneScienceInterface(_address);
757 
758         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
759         require(candidateContract.isGeneScience());
760 
761         // Set the new contract address
762         geneScience = candidateContract;
763     }
764 
765     /// @dev Checks that a given kitten is able to breed. Requires that the
766     ///  current cooldown is finished (for sires) and also checks that there is
767     ///  no pending pregnancy.
768     function _isReadyToBreed(Kitty _kit) internal view returns (bool) {
769         // In addition to checking the cooldownEndBlock, we also need to check to see if
770         // the cat has a pending birth; there can be some period of time between the end
771         // of the pregnacy timer and the birth event.
772         return (_kit.siringWithId == 0) && (_kit.cooldownEndBlock <= uint64(block.number));
773     }
774 
775     /// @dev Check if a sire has authorized breeding with this matron. True if both sire
776     ///  and matron have the same owner, or if the sire has given siring permission to
777     ///  the matron's owner (via approveSiring()).
778     function _isSiringPermitted(uint256 _sireId, uint256 _matronId) internal view returns (bool) {
779         address matronOwner = kittyIndexToOwner[_matronId];
780         address sireOwner = kittyIndexToOwner[_sireId];
781 
782         // Siring is okay if they have same owner, or if the matron's owner was given
783         // permission to breed with this sire.
784         return (matronOwner == sireOwner || sireAllowedToAddress[_sireId] == matronOwner);
785     }
786 
787     /// @dev Set the cooldownEndTime for the given Kitty, based on its current cooldownIndex.
788     ///  Also increments the cooldownIndex (unless it has hit the cap).
789     /// @param _kitten A reference to the Kitty in storage which needs its timer started.
790     function _triggerCooldown(Kitty storage _kitten) internal {
791         // Compute an estimation of the cooldown time in blocks (based on current cooldownIndex).
792         _kitten.cooldownEndBlock = uint64((cooldowns[_kitten.cooldownIndex]/secondsPerBlock) + block.number);
793 
794         // Increment the breeding count, clamping it at 13, which is the length of the
795         // cooldowns array. We could check the array size dynamically, but hard-coding
796         // this as a constant saves gas. Yay, Solidity!
797         if (_kitten.cooldownIndex < 13) {
798             _kitten.cooldownIndex += 1;
799         }
800     }
801 
802     /// @notice Grants approval to another user to sire with one of your Kitties.
803     /// @param _addr The address that will be able to sire with your Kitty. Set to
804     ///  address(0) to clear all siring approvals for this Kitty.
805     /// @param _sireId A Kitty that you own that _addr will now be able to sire with.
806     function approveSiring(address _addr, uint256 _sireId)
807         external
808         whenNotPaused
809     {
810         require(_owns(msg.sender, _sireId));
811         sireAllowedToAddress[_sireId] = _addr;
812     }
813 
814     /// @dev Updates the minimum payment required for calling giveBirthAuto(). Can only
815     ///  be called by the COO address. (This fee is used to offset the gas cost incurred
816     ///  by the autobirth daemon).
817     function setAutoBirthFee(uint256 val) external onlyCOO {
818         autoBirthFee = val;
819     }
820 
821     /// @dev Checks to see if a given Kitty is pregnant and (if so) if the gestation
822     ///  period has passed.
823     function _isReadyToGiveBirth(Kitty _matron) private view returns (bool) {
824         return (_matron.siringWithId != 0) && (_matron.cooldownEndBlock <= uint64(block.number));
825     }
826 
827     /// @notice Checks that a given kitten is able to breed (i.e. it is not pregnant or
828     ///  in the middle of a siring cooldown).
829     /// @param _kittyId reference the id of the kitten, any user can inquire about it
830     function isReadyToBreed(uint256 _kittyId)
831         public
832         view
833         returns (bool)
834     {
835         require(_kittyId > 0);
836         Kitty storage kit = kitties[_kittyId];
837         return _isReadyToBreed(kit);
838     }
839 
840     /// @dev Checks whether a kitty is currently pregnant.
841     /// @param _kittyId reference the id of the kitten, any user can inquire about it
842     function isPregnant(uint256 _kittyId)
843         public
844         view
845         returns (bool)
846     {
847         require(_kittyId > 0);
848         // A kitty is pregnant if and only if this field is set
849         return kitties[_kittyId].siringWithId != 0;
850     }
851 
852     /// @dev Internal check to see if a given sire and matron are a valid mating pair. DOES NOT
853     ///  check ownership permissions (that is up to the caller).
854     /// @param _matron A reference to the Kitty struct of the potential matron.
855     /// @param _matronId The matron's ID.
856     /// @param _sire A reference to the Kitty struct of the potential sire.
857     /// @param _sireId The sire's ID
858     function _isValidMatingPair(
859         Kitty storage _matron,
860         uint256 _matronId,
861         Kitty storage _sire,
862         uint256 _sireId
863     )
864         private
865         view
866         returns(bool)
867     {
868         // A Kitty can't breed with itself!
869         if (_matronId == _sireId) {
870             return false;
871         }
872 
873         // Kitties can't breed with their parents.
874         if (_matron.matronId == _sireId || _matron.sireId == _sireId) {
875             return false;
876         }
877         if (_sire.matronId == _matronId || _sire.sireId == _matronId) {
878             return false;
879         }
880 
881         // We can short circuit the sibling check (below) if either cat is
882         // gen zero (has a matron ID of zero).
883         if (_sire.matronId == 0 || _matron.matronId == 0) {
884             return true;
885         }
886 
887         // Kitties can't breed with full or half siblings.
888         if (_sire.matronId == _matron.matronId || _sire.matronId == _matron.sireId) {
889             return false;
890         }
891         if (_sire.sireId == _matron.matronId || _sire.sireId == _matron.sireId) {
892             return false;
893         }
894 
895         // Everything seems cool! Let's get DTF.
896         return true;
897     }
898 
899     /// @dev Internal check to see if a given sire and matron are a valid mating pair for
900     ///  breeding via auction (i.e. skips ownership and siring approval checks).
901     function _canBreedWithViaAuction(uint256 _matronId, uint256 _sireId)
902         internal
903         view
904         returns (bool)
905     {
906         Kitty storage matron = kitties[_matronId];
907         Kitty storage sire = kitties[_sireId];
908         return _isValidMatingPair(matron, _matronId, sire, _sireId);
909     }
910 
911     /// @notice Checks to see if two cats can breed together, including checks for
912     ///  ownership and siring approvals. Does NOT check that both cats are ready for
913     ///  breeding (i.e. breedWith could still fail until the cooldowns are finished).
914     ///  TODO: Shouldn't this check pregnancy and cooldowns?!?
915     /// @param _matronId The ID of the proposed matron.
916     /// @param _sireId The ID of the proposed sire.
917     function canBreedWith(uint256 _matronId, uint256 _sireId)
918         external
919         view
920         returns(bool)
921     {
922         require(_matronId > 0);
923         require(_sireId > 0);
924         Kitty storage matron = kitties[_matronId];
925         Kitty storage sire = kitties[_sireId];
926         return _isValidMatingPair(matron, _matronId, sire, _sireId) &&
927             _isSiringPermitted(_sireId, _matronId);
928     }
929 
930     /// @dev Internal utility function to initiate breeding, assumes that all breeding
931     ///  requirements have been checked.
932     function _breedWith(uint256 _matronId, uint256 _sireId) internal {
933         // Grab a reference to the Kitties from storage.
934         Kitty storage sire = kitties[_sireId];
935         Kitty storage matron = kitties[_matronId];
936 
937         // Mark the matron as pregnant, keeping track of who the sire is.
938         matron.siringWithId = uint32(_sireId);
939 
940         // Trigger the cooldown for both parents.
941         _triggerCooldown(sire);
942         _triggerCooldown(matron);
943 
944         // Clear siring permission for both parents. This may not be strictly necessary
945         // but it's likely to avoid confusion!
946         delete sireAllowedToAddress[_matronId];
947         delete sireAllowedToAddress[_sireId];
948 
949         // Every time a kitty gets pregnant, counter is incremented.
950         pregnantKitties++;
951 
952         // Emit the pregnancy event.
953         Pregnant(kittyIndexToOwner[_matronId], _matronId, _sireId, matron.cooldownEndBlock);
954     }
955 
956     /// @notice Breed a Kitty you own (as matron) with a sire that you own, or for which you
957     ///  have previously been given Siring approval. Will either make your cat pregnant, or will
958     ///  fail entirely. Requires a pre-payment of the fee given out to the first caller of giveBirth()
959     /// @param _matronId The ID of the Kitty acting as matron (will end up pregnant if successful)
960     /// @param _sireId The ID of the Kitty acting as sire (will begin its siring cooldown if successful)
961     function breedWithAuto(uint256 _matronId, uint256 _sireId)
962         external
963         payable
964         whenNotPaused
965     {
966         // Checks for payment.
967         require(msg.value >= autoBirthFee);
968 
969         // Caller must own the matron.
970         require(_owns(msg.sender, _matronId));
971 
972         // Neither sire nor matron are allowed to be on auction during a normal
973         // breeding operation, but we don't need to check that explicitly.
974         // For matron: The caller of this function can't be the owner of the matron
975         //   because the owner of a Kitty on auction is the auction house, and the
976         //   auction house will never call breedWith().
977         // For sire: Similarly, a sire on auction will be owned by the auction house
978         //   and the act of transferring ownership will have cleared any oustanding
979         //   siring approval.
980         // Thus we don't need to spend gas explicitly checking to see if either cat
981         // is on auction.
982 
983         // Check that matron and sire are both owned by caller, or that the sire
984         // has given siring permission to caller (i.e. matron's owner).
985         // Will fail for _sireId = 0
986         require(_isSiringPermitted(_sireId, _matronId));
987 
988         // Grab a reference to the potential matron
989         Kitty storage matron = kitties[_matronId];
990 
991         // Make sure matron isn't pregnant, or in the middle of a siring cooldown
992         require(_isReadyToBreed(matron));
993 
994         // Grab a reference to the potential sire
995         Kitty storage sire = kitties[_sireId];
996 
997         // Make sure sire isn't pregnant, or in the middle of a siring cooldown
998         require(_isReadyToBreed(sire));
999 
1000         // Test that these cats are a valid mating pair.
1001         require(_isValidMatingPair(
1002             matron,
1003             _matronId,
1004             sire,
1005             _sireId
1006         ));
1007 
1008         // All checks passed, kitty gets pregnant!
1009         _breedWith(_matronId, _sireId);
1010     }
1011 
1012     /// @notice Have a pregnant Kitty give birth!
1013     /// @param _matronId A Kitty ready to give birth.
1014     /// @return The Kitty ID of the new kitten.
1015     /// @dev Looks at a given Kitty and, if pregnant and if the gestation period has passed,
1016     ///  combines the genes of the two parents to create a new kitten. The new Kitty is assigned
1017     ///  to the current owner of the matron. Upon successful completion, both the matron and the
1018     ///  new kitten will be ready to breed again. Note that anyone can call this function (if they
1019     ///  are willing to pay the gas!), but the new kitten always goes to the mother's owner.
1020     function giveBirth(uint256 _matronId)
1021         external
1022         whenNotPaused
1023         returns(uint256)
1024     {
1025         // Grab a reference to the matron in storage.
1026         Kitty storage matron = kitties[_matronId];
1027 
1028         // Check that the matron is a valid cat.
1029         require(matron.birthTime != 0);
1030 
1031         // Check that the matron is pregnant, and that its time has come!
1032         require(_isReadyToGiveBirth(matron));
1033 
1034         // Grab a reference to the sire in storage.
1035         uint256 sireId = matron.siringWithId;
1036         Kitty storage sire = kitties[sireId];
1037 
1038         // Determine the higher generation number of the two parents
1039         uint16 parentGen = matron.generation;
1040         if (sire.generation > matron.generation) {
1041             parentGen = sire.generation;
1042         }
1043 
1044         // Call the sooper-sekret gene mixing operation.
1045         uint256 childGenes = geneScience.mixGenes(matron.genes, sire.genes, matron.cooldownEndBlock - 1);
1046 
1047         // Make the new kitten!
1048         address owner = kittyIndexToOwner[_matronId];
1049         uint256 kittenId = _createKitty(_matronId, matron.siringWithId, parentGen + 1, childGenes, owner);
1050 
1051         // Clear the reference to sire from the matron (REQUIRED! Having siringWithId
1052         // set is what marks a matron as being pregnant.)
1053         delete matron.siringWithId;
1054 
1055         // Every time a kitty gives birth counter is decremented.
1056         pregnantKitties--;
1057 
1058         // Send the balance fee to the person who made birth happen.
1059         msg.sender.send(autoBirthFee);
1060 
1061         // return the new kitten's ID
1062         return kittenId;
1063     }
1064 }
1065 
1066 
1067 
1068 
1069 
1070 
1071 
1072 
1073 
1074 
1075 /// @title Auction Core
1076 /// @dev Contains models, variables, and internal methods for the auction.
1077 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1078 contract ClockAuctionBase {
1079 
1080     // Represents an auction on an NFT
1081     struct Auction {
1082         // Current owner of NFT
1083         address seller;
1084         // Price (in wei) at beginning of auction
1085         uint128 startingPrice;
1086         // Price (in wei) at end of auction
1087         uint128 endingPrice;
1088         // Duration (in seconds) of auction
1089         uint64 duration;
1090         // Time when auction started
1091         // NOTE: 0 if this auction has been concluded
1092         uint64 startedAt;
1093     }
1094 
1095     // Reference to contract tracking NFT ownership
1096     ERC721 public nonFungibleContract;
1097 
1098     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
1099     // Values 0-10,000 map to 0%-100%
1100     uint256 public ownerCut;
1101 
1102     // Map from token ID to their corresponding auction.
1103     mapping (uint256 => Auction) tokenIdToAuction;
1104 
1105     event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
1106     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
1107     event AuctionCancelled(uint256 tokenId);
1108 
1109     /// @dev Returns true if the claimant owns the token.
1110     /// @param _claimant - Address claiming to own the token.
1111     /// @param _tokenId - ID of token whose ownership to verify.
1112     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
1113         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
1114     }
1115 
1116     /// @dev Escrows the NFT, assigning ownership to this contract.
1117     /// Throws if the escrow fails.
1118     /// @param _owner - Current owner address of token to escrow.
1119     /// @param _tokenId - ID of token whose approval to verify.
1120     function _escrow(address _owner, uint256 _tokenId) internal {
1121         // it will throw if transfer fails
1122         nonFungibleContract.transferFrom(_owner, this, _tokenId);
1123     }
1124 
1125     /// @dev Transfers an NFT owned by this contract to another address.
1126     /// Returns true if the transfer succeeds.
1127     /// @param _receiver - Address to transfer NFT to.
1128     /// @param _tokenId - ID of token to transfer.
1129     function _transfer(address _receiver, uint256 _tokenId) internal {
1130         // it will throw if transfer fails
1131         nonFungibleContract.transfer(_receiver, _tokenId);
1132     }
1133 
1134     /// @dev Adds an auction to the list of open auctions. Also fires the
1135     ///  AuctionCreated event.
1136     /// @param _tokenId The ID of the token to be put on auction.
1137     /// @param _auction Auction to add.
1138     function _addAuction(uint256 _tokenId, Auction _auction) internal {
1139         // Require that all auctions have a duration of
1140         // at least one minute. (Keeps our math from getting hairy!)
1141         require(_auction.duration >= 1 minutes);
1142 
1143         tokenIdToAuction[_tokenId] = _auction;
1144 
1145         AuctionCreated(
1146             uint256(_tokenId),
1147             uint256(_auction.startingPrice),
1148             uint256(_auction.endingPrice),
1149             uint256(_auction.duration)
1150         );
1151     }
1152 
1153     /// @dev Cancels an auction unconditionally.
1154     function _cancelAuction(uint256 _tokenId, address _seller) internal {
1155         _removeAuction(_tokenId);
1156         _transfer(_seller, _tokenId);
1157         AuctionCancelled(_tokenId);
1158     }
1159 
1160     /// @dev Computes the price and transfers winnings.
1161     /// Does NOT transfer ownership of token.
1162     function _bid(uint256 _tokenId, uint256 _bidAmount)
1163         internal
1164         returns (uint256)
1165     {
1166         // Get a reference to the auction struct
1167         Auction storage auction = tokenIdToAuction[_tokenId];
1168 
1169         // Explicitly check that this auction is currently live.
1170         // (Because of how Ethereum mappings work, we can't just count
1171         // on the lookup above failing. An invalid _tokenId will just
1172         // return an auction object that is all zeros.)
1173         require(_isOnAuction(auction));
1174 
1175         // Check that the bid is greater than or equal to the current price
1176         uint256 price = _currentPrice(auction);
1177         require(_bidAmount >= price);
1178 
1179         // Grab a reference to the seller before the auction struct
1180         // gets deleted.
1181         address seller = auction.seller;
1182 
1183         // The bid is good! Remove the auction before sending the fees
1184         // to the sender so we can't have a reentrancy attack.
1185         _removeAuction(_tokenId);
1186 
1187         // Transfer proceeds to seller (if there are any!)
1188         if (price > 0) {
1189             // Calculate the auctioneer's cut.
1190             // (NOTE: _computeCut() is guaranteed to return a
1191             // value <= price, so this subtraction can't go negative.)
1192             uint256 auctioneerCut = _computeCut(price);
1193             uint256 sellerProceeds = price - auctioneerCut;
1194 
1195             // NOTE: Doing a transfer() in the middle of a complex
1196             // method like this is generally discouraged because of
1197             // reentrancy attacks and DoS attacks if the seller is
1198             // a contract with an invalid fallback function. We explicitly
1199             // guard against reentrancy attacks by removing the auction
1200             // before calling transfer(), and the only thing the seller
1201             // can DoS is the sale of their own asset! (And if it's an
1202             // accident, they can call cancelAuction(). )
1203             seller.transfer(sellerProceeds);
1204         }
1205 
1206         // Calculate any excess funds included with the bid. If the excess
1207         // is anything worth worrying about, transfer it back to bidder.
1208         // NOTE: We checked above that the bid amount is greater than or
1209         // equal to the price so this cannot underflow.
1210         uint256 bidExcess = _bidAmount - price;
1211 
1212         // Return the funds. Similar to the previous transfer, this is
1213         // not susceptible to a re-entry attack because the auction is
1214         // removed before any transfers occur.
1215         msg.sender.transfer(bidExcess);
1216 
1217         // Tell the world!
1218         AuctionSuccessful(_tokenId, price, msg.sender);
1219 
1220         return price;
1221     }
1222 
1223     /// @dev Removes an auction from the list of open auctions.
1224     /// @param _tokenId - ID of NFT on auction.
1225     function _removeAuction(uint256 _tokenId) internal {
1226         delete tokenIdToAuction[_tokenId];
1227     }
1228 
1229     /// @dev Returns true if the NFT is on auction.
1230     /// @param _auction - Auction to check.
1231     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
1232         return (_auction.startedAt > 0);
1233     }
1234 
1235     /// @dev Returns current price of an NFT on auction. Broken into two
1236     ///  functions (this one, that computes the duration from the auction
1237     ///  structure, and the other that does the price computation) so we
1238     ///  can easily test that the price computation works correctly.
1239     function _currentPrice(Auction storage _auction)
1240         internal
1241         view
1242         returns (uint256)
1243     {
1244         uint256 secondsPassed = 0;
1245 
1246         // A bit of insurance against negative values (or wraparound).
1247         // Probably not necessary (since Ethereum guarnatees that the
1248         // now variable doesn't ever go backwards).
1249         if (now > _auction.startedAt) {
1250             secondsPassed = now - _auction.startedAt;
1251         }
1252 
1253         return _computeCurrentPrice(
1254             _auction.startingPrice,
1255             _auction.endingPrice,
1256             _auction.duration,
1257             secondsPassed
1258         );
1259     }
1260 
1261     /// @dev Computes the current price of an auction. Factored out
1262     ///  from _currentPrice so we can run extensive unit tests.
1263     ///  When testing, make this function public and turn on
1264     ///  `Current price computation` test suite.
1265     function _computeCurrentPrice(
1266         uint256 _startingPrice,
1267         uint256 _endingPrice,
1268         uint256 _duration,
1269         uint256 _secondsPassed
1270     )
1271         internal
1272         pure
1273         returns (uint256)
1274     {
1275         // NOTE: We don't use SafeMath (or similar) in this function because
1276         //  all of our public functions carefully cap the maximum values for
1277         //  time (at 64-bits) and currency (at 128-bits). _duration is
1278         //  also known to be non-zero (see the require() statement in
1279         //  _addAuction())
1280         if (_secondsPassed >= _duration) {
1281             // We've reached the end of the dynamic pricing portion
1282             // of the auction, just return the end price.
1283             return _endingPrice;
1284         } else {
1285             // Starting price can be higher than ending price (and often is!), so
1286             // this delta can be negative.
1287             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
1288 
1289             // This multiplication can't overflow, _secondsPassed will easily fit within
1290             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
1291             // will always fit within 256-bits.
1292             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
1293 
1294             // currentPriceChange can be negative, but if so, will have a magnitude
1295             // less that _startingPrice. Thus, this result will always end up positive.
1296             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
1297 
1298             return uint256(currentPrice);
1299         }
1300     }
1301 
1302     /// @dev Computes owner's cut of a sale.
1303     /// @param _price - Sale price of NFT.
1304     function _computeCut(uint256 _price) internal view returns (uint256) {
1305         // NOTE: We don't use SafeMath (or similar) in this function because
1306         //  all of our entry functions carefully cap the maximum values for
1307         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
1308         //  statement in the ClockAuction constructor). The result of this
1309         //  function is always guaranteed to be <= _price.
1310         return _price * ownerCut / 10000;
1311     }
1312 
1313 }
1314 
1315 
1316 
1317 
1318 
1319 
1320 
1321 /**
1322  * @title Pausable
1323  * @dev Base contract which allows children to implement an emergency stop mechanism.
1324  */
1325 contract Pausable is Ownable {
1326   event Pause();
1327   event Unpause();
1328 
1329   bool public paused = false;
1330 
1331 
1332   /**
1333    * @dev modifier to allow actions only when the contract IS paused
1334    */
1335   modifier whenNotPaused() {
1336     require(!paused);
1337     _;
1338   }
1339 
1340   /**
1341    * @dev modifier to allow actions only when the contract IS NOT paused
1342    */
1343   modifier whenPaused {
1344     require(paused);
1345     _;
1346   }
1347 
1348   /**
1349    * @dev called by the owner to pause, triggers stopped state
1350    */
1351   function pause() onlyOwner whenNotPaused returns (bool) {
1352     paused = true;
1353     Pause();
1354     return true;
1355   }
1356 
1357   /**
1358    * @dev called by the owner to unpause, returns to normal state
1359    */
1360   function unpause() onlyOwner whenPaused returns (bool) {
1361     paused = false;
1362     Unpause();
1363     return true;
1364   }
1365 }
1366 
1367 
1368 /// @title Clock auction for non-fungible tokens.
1369 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1370 contract ClockAuction is Pausable, ClockAuctionBase {
1371 
1372     /// @dev The ERC-165 interface signature for ERC-721.
1373     ///  Ref: https://github.com/ethereum/EIPs/issues/165
1374     ///  Ref: https://github.com/ethereum/EIPs/issues/721
1375     bytes4 constant InterfaceSignature_ERC721 = bytes4(0x9a20483d);
1376 
1377     /// @dev Constructor creates a reference to the NFT ownership contract
1378     ///  and verifies the owner cut is in the valid range.
1379     /// @param _nftAddress - address of a deployed contract implementing
1380     ///  the Nonfungible Interface.
1381     /// @param _cut - percent cut the owner takes on each auction, must be
1382     ///  between 0-10,000.
1383     function ClockAuction(address _nftAddress, uint256 _cut) public {
1384         require(_cut <= 10000);
1385         ownerCut = _cut;
1386 
1387         ERC721 candidateContract = ERC721(_nftAddress);
1388         require(candidateContract.supportsInterface(InterfaceSignature_ERC721));
1389         nonFungibleContract = candidateContract;
1390     }
1391 
1392     /// @dev Remove all Ether from the contract, which is the owner's cuts
1393     ///  as well as any Ether sent directly to the contract address.
1394     ///  Always transfers to the NFT contract, but can be called either by
1395     ///  the owner or the NFT contract.
1396     function withdrawBalance() external {
1397         address nftAddress = address(nonFungibleContract);
1398 
1399         require(
1400             msg.sender == owner ||
1401             msg.sender == nftAddress
1402         );
1403         // We are using this boolean method to make sure that even if one fails it will still work
1404         bool res = nftAddress.send(this.balance);
1405     }
1406 
1407     /// @dev Creates and begins a new auction.
1408     /// @param _tokenId - ID of token to auction, sender must be owner.
1409     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
1410     /// @param _endingPrice - Price of item (in wei) at end of auction.
1411     /// @param _duration - Length of time to move between starting
1412     ///  price and ending price (in seconds).
1413     /// @param _seller - Seller, if not the message sender
1414     function createAuction(
1415         uint256 _tokenId,
1416         uint256 _startingPrice,
1417         uint256 _endingPrice,
1418         uint256 _duration,
1419         address _seller
1420     )
1421         external
1422         whenNotPaused
1423     {
1424         // Sanity check that no inputs overflow how many bits we've allocated
1425         // to store them in the auction struct.
1426         require(_startingPrice == uint256(uint128(_startingPrice)));
1427         require(_endingPrice == uint256(uint128(_endingPrice)));
1428         require(_duration == uint256(uint64(_duration)));
1429 
1430         require(_owns(msg.sender, _tokenId));
1431         _escrow(msg.sender, _tokenId);
1432         Auction memory auction = Auction(
1433             _seller,
1434             uint128(_startingPrice),
1435             uint128(_endingPrice),
1436             uint64(_duration),
1437             uint64(now)
1438         );
1439         _addAuction(_tokenId, auction);
1440     }
1441 
1442     /// @dev Bids on an open auction, completing the auction and transferring
1443     ///  ownership of the NFT if enough Ether is supplied.
1444     /// @param _tokenId - ID of token to bid on.
1445     function bid(uint256 _tokenId)
1446         external
1447         payable
1448         whenNotPaused
1449     {
1450         // _bid will throw if the bid or funds transfer fails
1451         _bid(_tokenId, msg.value);
1452         _transfer(msg.sender, _tokenId);
1453     }
1454 
1455     /// @dev Cancels an auction that hasn't been won yet.
1456     ///  Returns the NFT to original owner.
1457     /// @notice This is a state-modifying function that can
1458     ///  be called while the contract is paused.
1459     /// @param _tokenId - ID of token on auction
1460     function cancelAuction(uint256 _tokenId)
1461         external
1462     {
1463         Auction storage auction = tokenIdToAuction[_tokenId];
1464         require(_isOnAuction(auction));
1465         address seller = auction.seller;
1466         require(msg.sender == seller);
1467         _cancelAuction(_tokenId, seller);
1468     }
1469 
1470     /// @dev Cancels an auction when the contract is paused.
1471     ///  Only the owner may do this, and NFTs are returned to
1472     ///  the seller. This should only be used in emergencies.
1473     /// @param _tokenId - ID of the NFT on auction to cancel.
1474     function cancelAuctionWhenPaused(uint256 _tokenId)
1475         whenPaused
1476         onlyOwner
1477         external
1478     {
1479         Auction storage auction = tokenIdToAuction[_tokenId];
1480         require(_isOnAuction(auction));
1481         _cancelAuction(_tokenId, auction.seller);
1482     }
1483 
1484     /// @dev Returns auction info for an NFT on auction.
1485     /// @param _tokenId - ID of NFT on auction.
1486     function getAuction(uint256 _tokenId)
1487         external
1488         view
1489         returns
1490     (
1491         address seller,
1492         uint256 startingPrice,
1493         uint256 endingPrice,
1494         uint256 duration,
1495         uint256 startedAt
1496     ) {
1497         Auction storage auction = tokenIdToAuction[_tokenId];
1498         require(_isOnAuction(auction));
1499         return (
1500             auction.seller,
1501             auction.startingPrice,
1502             auction.endingPrice,
1503             auction.duration,
1504             auction.startedAt
1505         );
1506     }
1507 
1508     /// @dev Returns the current price of an auction.
1509     /// @param _tokenId - ID of the token price we are checking.
1510     function getCurrentPrice(uint256 _tokenId)
1511         external
1512         view
1513         returns (uint256)
1514     {
1515         Auction storage auction = tokenIdToAuction[_tokenId];
1516         require(_isOnAuction(auction));
1517         return _currentPrice(auction);
1518     }
1519 
1520 }
1521 
1522 
1523 /// @title Reverse auction modified for siring
1524 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1525 contract SiringClockAuction is ClockAuction {
1526 
1527     // @dev Sanity check that allows us to ensure that we are pointing to the
1528     //  right auction in our setSiringAuctionAddress() call.
1529     bool public isSiringClockAuction = true;
1530 
1531     // Delegate constructor
1532     function SiringClockAuction(address _nftAddr, uint256 _cut) public
1533         ClockAuction(_nftAddr, _cut) {}
1534 
1535     /// @dev Creates and begins a new auction. Since this function is wrapped,
1536     /// require sender to be KittyCore contract.
1537     /// @param _tokenId - ID of token to auction, sender must be owner.
1538     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
1539     /// @param _endingPrice - Price of item (in wei) at end of auction.
1540     /// @param _duration - Length of auction (in seconds).
1541     /// @param _seller - Seller, if not the message sender
1542     function createAuction(
1543         uint256 _tokenId,
1544         uint256 _startingPrice,
1545         uint256 _endingPrice,
1546         uint256 _duration,
1547         address _seller
1548     )
1549         external
1550     {
1551         // Sanity check that no inputs overflow how many bits we've allocated
1552         // to store them in the auction struct.
1553         require(_startingPrice == uint256(uint128(_startingPrice)));
1554         require(_endingPrice == uint256(uint128(_endingPrice)));
1555         require(_duration == uint256(uint64(_duration)));
1556 
1557         require(msg.sender == address(nonFungibleContract));
1558         _escrow(_seller, _tokenId);
1559         Auction memory auction = Auction(
1560             _seller,
1561             uint128(_startingPrice),
1562             uint128(_endingPrice),
1563             uint64(_duration),
1564             uint64(now)
1565         );
1566         _addAuction(_tokenId, auction);
1567     }
1568 
1569     /// @dev Places a bid for siring. Requires the sender
1570     /// is the KittyCore contract because all bid methods
1571     /// should be wrapped. Also returns the kitty to the
1572     /// seller rather than the winner.
1573     function bid(uint256 _tokenId)
1574         external
1575         payable
1576     {
1577         require(msg.sender == address(nonFungibleContract));
1578         address seller = tokenIdToAuction[_tokenId].seller;
1579         // _bid checks that token ID is valid and will throw if bid fails
1580         _bid(_tokenId, msg.value);
1581         // We transfer the kitty back to the seller, the winner will get
1582         // the offspring
1583         _transfer(seller, _tokenId);
1584     }
1585 
1586 }
1587 
1588 
1589 
1590 
1591 
1592 /// @title Clock auction modified for sale of kitties
1593 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1594 contract SaleClockAuction is ClockAuction {
1595 
1596     // @dev Sanity check that allows us to ensure that we are pointing to the
1597     //  right auction in our setSaleAuctionAddress() call.
1598     bool public isSaleClockAuction = true;
1599 
1600     // Tracks last 5 sale price of gen0 kitty sales
1601     uint256 public gen0SaleCount;
1602     uint256[5] public lastGen0SalePrices;
1603 
1604     // Delegate constructor
1605     function SaleClockAuction(address _nftAddr, uint256 _cut) public
1606         ClockAuction(_nftAddr, _cut) {}
1607 
1608     /// @dev Creates and begins a new auction.
1609     /// @param _tokenId - ID of token to auction, sender must be owner.
1610     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
1611     /// @param _endingPrice - Price of item (in wei) at end of auction.
1612     /// @param _duration - Length of auction (in seconds).
1613     /// @param _seller - Seller, if not the message sender
1614     function createAuction(
1615         uint256 _tokenId,
1616         uint256 _startingPrice,
1617         uint256 _endingPrice,
1618         uint256 _duration,
1619         address _seller
1620     )
1621         external
1622     {
1623         // Sanity check that no inputs overflow how many bits we've allocated
1624         // to store them in the auction struct.
1625         require(_startingPrice == uint256(uint128(_startingPrice)));
1626         require(_endingPrice == uint256(uint128(_endingPrice)));
1627         require(_duration == uint256(uint64(_duration)));
1628 
1629         require(msg.sender == address(nonFungibleContract));
1630         _escrow(_seller, _tokenId);
1631         Auction memory auction = Auction(
1632             _seller,
1633             uint128(_startingPrice),
1634             uint128(_endingPrice),
1635             uint64(_duration),
1636             uint64(now)
1637         );
1638         _addAuction(_tokenId, auction);
1639     }
1640 
1641     /// @dev Updates lastSalePrice if seller is the nft contract
1642     /// Otherwise, works the same as default bid method.
1643     function bid(uint256 _tokenId)
1644         external
1645         payable
1646     {
1647         // _bid verifies token ID size
1648         address seller = tokenIdToAuction[_tokenId].seller;
1649         uint256 price = _bid(_tokenId, msg.value);
1650         _transfer(msg.sender, _tokenId);
1651 
1652         // If not a gen0 auction, exit
1653         if (seller == address(nonFungibleContract)) {
1654             // Track gen0 sale prices
1655             lastGen0SalePrices[gen0SaleCount % 5] = price;
1656             gen0SaleCount++;
1657         }
1658     }
1659 
1660     function averageGen0SalePrice() external view returns (uint256) {
1661         uint256 sum = 0;
1662         for (uint256 i = 0; i < 5; i++) {
1663             sum += lastGen0SalePrices[i];
1664         }
1665         return sum / 5;
1666     }
1667 
1668 }
1669 
1670 
1671 /// @title Handles creating auctions for sale and siring of kitties.
1672 ///  This wrapper of ReverseAuction exists only so that users can create
1673 ///  auctions with only one transaction.
1674 contract KittyAuction is KittyBreeding {
1675 
1676     // @notice The auction contract variables are defined in KittyBase to allow
1677     //  us to refer to them in KittyOwnership to prevent accidental transfers.
1678     // `saleAuction` refers to the auction for gen0 and p2p sale of kitties.
1679     // `siringAuction` refers to the auction for siring rights of kitties.
1680 
1681     /// @dev Sets the reference to the sale auction.
1682     /// @param _address - Address of sale contract.
1683     function setSaleAuctionAddress(address _address) external onlyCEO {
1684         SaleClockAuction candidateContract = SaleClockAuction(_address);
1685 
1686         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
1687         require(candidateContract.isSaleClockAuction());
1688 
1689         // Set the new contract address
1690         saleAuction = candidateContract;
1691     }
1692 
1693     /// @dev Sets the reference to the siring auction.
1694     /// @param _address - Address of siring contract.
1695     function setSiringAuctionAddress(address _address) external onlyCEO {
1696         SiringClockAuction candidateContract = SiringClockAuction(_address);
1697 
1698         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
1699         require(candidateContract.isSiringClockAuction());
1700 
1701         // Set the new contract address
1702         siringAuction = candidateContract;
1703     }
1704 
1705     /// @dev Put a kitty up for auction.
1706     ///  Does some ownership trickery to create auctions in one tx.
1707     function createSaleAuction(
1708         uint256 _kittyId,
1709         uint256 _startingPrice,
1710         uint256 _endingPrice,
1711         uint256 _duration
1712     )
1713         external
1714         whenNotPaused
1715     {
1716         // Auction contract checks input sizes
1717         // If kitty is already on any auction, this will throw
1718         // because it will be owned by the auction contract.
1719         require(_owns(msg.sender, _kittyId));
1720         // Ensure the kitty is not pregnant to prevent the auction
1721         // contract accidentally receiving ownership of the child.
1722         // NOTE: the kitty IS allowed to be in a cooldown.
1723         require(!isPregnant(_kittyId));
1724         _approve(_kittyId, saleAuction);
1725         // Sale auction throws if inputs are invalid and clears
1726         // transfer and sire approval after escrowing the kitty.
1727         saleAuction.createAuction(
1728             _kittyId,
1729             _startingPrice,
1730             _endingPrice,
1731             _duration,
1732             msg.sender
1733         );
1734     }
1735 
1736     /// @dev Put a kitty up for auction to be sire.
1737     ///  Performs checks to ensure the kitty can be sired, then
1738     ///  delegates to reverse auction.
1739     function createSiringAuction(
1740         uint256 _kittyId,
1741         uint256 _startingPrice,
1742         uint256 _endingPrice,
1743         uint256 _duration
1744     )
1745         external
1746         whenNotPaused
1747     {
1748         // Auction contract checks input sizes
1749         // If kitty is already on any auction, this will throw
1750         // because it will be owned by the auction contract.
1751         require(_owns(msg.sender, _kittyId));
1752         require(isReadyToBreed(_kittyId));
1753         _approve(_kittyId, siringAuction);
1754         // Siring auction throws if inputs are invalid and clears
1755         // transfer and sire approval after escrowing the kitty.
1756         siringAuction.createAuction(
1757             _kittyId,
1758             _startingPrice,
1759             _endingPrice,
1760             _duration,
1761             msg.sender
1762         );
1763     }
1764 
1765     /// @dev Completes a siring auction by bidding.
1766     ///  Immediately breeds the winning matron with the sire on auction.
1767     /// @param _sireId - ID of the sire on auction.
1768     /// @param _matronId - ID of the matron owned by the bidder.
1769     function bidOnSiringAuction(
1770         uint256 _sireId,
1771         uint256 _matronId
1772     )
1773         external
1774         payable
1775         whenNotPaused
1776     {
1777         // Auction contract checks input sizes
1778         require(_owns(msg.sender, _matronId));
1779         require(isReadyToBreed(_matronId));
1780         require(_canBreedWithViaAuction(_matronId, _sireId));
1781 
1782         // Define the current price of the auction.
1783         uint256 currentPrice = siringAuction.getCurrentPrice(_sireId);
1784         require(msg.value >= currentPrice + autoBirthFee);
1785 
1786         // Siring auction will throw if the bid fails.
1787         siringAuction.bid.value(msg.value - autoBirthFee)(_sireId);
1788         _breedWith(uint32(_matronId), uint32(_sireId));
1789     }
1790 
1791     /// @dev Transfers the balance of the sale auction contract
1792     /// to the KittyCore contract. We use two-step withdrawal to
1793     /// prevent two transfer calls in the auction bid function.
1794     function withdrawAuctionBalances() external onlyCLevel {
1795         saleAuction.withdrawBalance();
1796         siringAuction.withdrawBalance();
1797     }
1798 }
1799 
1800 
1801 /// @title all functions related to creating kittens
1802 contract KittyMinting is KittyAuction {
1803 
1804     // Limits the number of cats the contract owner can ever create.
1805     uint256 public constant PROMO_CREATION_LIMIT = 5000;
1806     uint256 public constant GEN0_CREATION_LIMIT = 45000;
1807 
1808     // Constants for gen0 auctions.
1809     uint256 public constant GEN0_STARTING_PRICE = 10 finney;
1810     uint256 public constant GEN0_AUCTION_DURATION = 1 days;
1811 
1812     // Counts the number of cats the contract owner has created.
1813     uint256 public promoCreatedCount;
1814     uint256 public gen0CreatedCount;
1815 
1816     /// @dev we can create promo kittens, up to a limit. Only callable by COO
1817     /// @param _genes the encoded genes of the kitten to be created, any value is accepted
1818     /// @param _owner the future owner of the created kittens. Default to contract COO
1819     function createPromoKitty(uint256 _genes, address _owner) external onlyCOO {
1820         address kittyOwner = _owner;
1821         if (kittyOwner == address(0)) {
1822              kittyOwner = cooAddress;
1823         }
1824         require(promoCreatedCount < PROMO_CREATION_LIMIT);
1825 
1826         promoCreatedCount++;
1827         _createKitty(0, 0, 0, _genes, kittyOwner);
1828     }
1829 
1830     /// @dev Creates a new gen0 kitty with the given genes and
1831     ///  creates an auction for it.
1832     function createGen0Auction(uint256 _genes) external onlyCOO {
1833         require(gen0CreatedCount < GEN0_CREATION_LIMIT);
1834 
1835         uint256 kittyId = _createKitty(0, 0, 0, _genes, address(this));
1836         _approve(kittyId, saleAuction);
1837 
1838         saleAuction.createAuction(
1839             kittyId,
1840             _computeNextGen0Price(),
1841             0,
1842             GEN0_AUCTION_DURATION,
1843             address(this)
1844         );
1845 
1846         gen0CreatedCount++;
1847     }
1848 
1849     /// @dev Computes the next gen0 auction starting price, given
1850     ///  the average of the past 5 prices + 50%.
1851     function _computeNextGen0Price() internal view returns (uint256) {
1852         uint256 avePrice = saleAuction.averageGen0SalePrice();
1853 
1854         // Sanity check to ensure we don't overflow arithmetic
1855         require(avePrice == uint256(uint128(avePrice)));
1856 
1857         uint256 nextPrice = avePrice + (avePrice / 2);
1858 
1859         // We never auction for less than starting price
1860         if (nextPrice < GEN0_STARTING_PRICE) {
1861             nextPrice = GEN0_STARTING_PRICE;
1862         }
1863 
1864         return nextPrice;
1865     }
1866 }
1867 
1868 
1869 /// @title CryptoKitties: Collectible, breedable, and oh-so-adorable cats on the Ethereum blockchain.
1870 /// @author Axiom Zen (https://www.axiomzen.co)
1871 /// @dev The main CryptoKitties contract, keeps track of kittens so they don't wander around and get lost.
1872 contract KittyCore is KittyMinting {
1873 
1874     // This is the main CryptoKitties contract. In order to keep our code seperated into logical sections,
1875     // we've broken it up in two ways. First, we have several seperately-instantiated sibling contracts
1876     // that handle auctions and our super-top-secret genetic combination algorithm. The auctions are
1877     // seperate since their logic is somewhat complex and there's always a risk of subtle bugs. By keeping
1878     // them in their own contracts, we can upgrade them without disrupting the main contract that tracks
1879     // kitty ownership. The genetic combination algorithm is kept seperate so we can open-source all of
1880     // the rest of our code without making it _too_ easy for folks to figure out how the genetics work.
1881     // Don't worry, I'm sure someone will reverse engineer it soon enough!
1882     //
1883     // Secondly, we break the core contract into multiple files using inheritence, one for each major
1884     // facet of functionality of CK. This allows us to keep related code bundled together while still
1885     // avoiding a single giant file with everything in it. The breakdown is as follows:
1886     //
1887     //      - KittyBase: This is where we define the most fundamental code shared throughout the core
1888     //             functionality. This includes our main data storage, constants and data types, plus
1889     //             internal functions for managing these items.
1890     //
1891     //      - KittyAccessControl: This contract manages the various addresses and constraints for operations
1892     //             that can be executed only by specific roles. Namely CEO, CFO and COO.
1893     //
1894     //      - KittyOwnership: This provides the methods required for basic non-fungible token
1895     //             transactions, following the draft ERC-721 spec (https://github.com/ethereum/EIPs/issues/721).
1896     //
1897     //      - KittyBreeding: This file contains the methods necessary to breed cats together, including
1898     //             keeping track of siring offers, and relies on an external genetic combination contract.
1899     //
1900     //      - KittyAuctions: Here we have the public methods for auctioning or bidding on cats or siring
1901     //             services. The actual auction functionality is handled in two sibling contracts (one
1902     //             for sales and one for siring), while auction creation and bidding is mostly mediated
1903     //             through this facet of the core contract.
1904     //
1905     //      - KittyMinting: This final facet contains the functionality we use for creating new gen0 cats.
1906     //             We can make up to 5000 "promo" cats that can be given away (especially important when
1907     //             the community is new), and all others can only be created and then immediately put up
1908     //             for auction via an algorithmically determined starting price. Regardless of how they
1909     //             are created, there is a hard limit of 50k gen0 cats. After that, it's all up to the
1910     //             community to breed, breed, breed!
1911 
1912     // Set in case the core contract is broken and an upgrade is required
1913     address public newContractAddress;
1914 
1915     /// @notice Creates the main CryptoKitties smart contract instance.
1916     function KittyCore() public {
1917         // Starts paused.
1918         paused = true;
1919 
1920         // the creator of the contract is the initial CEO
1921         ceoAddress = msg.sender;
1922 
1923         // the creator of the contract is also the initial COO
1924         cooAddress = msg.sender;
1925 
1926         // start with the mythical kitten 0 - so we don't have generation-0 parent issues
1927         _createKitty(0, 0, 0, uint256(-1), address(0));
1928     }
1929 
1930     /// @dev Used to mark the smart contract as upgraded, in case there is a serious
1931     ///  breaking bug. This method does nothing but keep track of the new contract and
1932     ///  emit a message indicating that the new address is set. It's up to clients of this
1933     ///  contract to update to the new contract address in that case. (This contract will
1934     ///  be paused indefinitely if such an upgrade takes place.)
1935     /// @param _v2Address new address
1936     function setNewAddress(address _v2Address) external onlyCEO whenPaused {
1937         // See README.md for updgrade plan
1938         newContractAddress = _v2Address;
1939         ContractUpgrade(_v2Address);
1940     }
1941 
1942     /// @notice No tipping!
1943     /// @dev Reject all Ether from being sent here, unless it's from one of the
1944     ///  two auction contracts. (Hopefully, we can prevent user accidents.)
1945     function() external payable {
1946         require(
1947             msg.sender == address(saleAuction) ||
1948             msg.sender == address(siringAuction)
1949         );
1950     }
1951 
1952     /// @notice Returns all the relevant information about a specific kitty.
1953     /// @param _id The ID of the kitty of interest.
1954     function getKitty(uint256 _id)
1955         external
1956         view
1957         returns (
1958         bool isGestating,
1959         bool isReady,
1960         uint256 cooldownIndex,
1961         uint256 nextActionAt,
1962         uint256 siringWithId,
1963         uint256 birthTime,
1964         uint256 matronId,
1965         uint256 sireId,
1966         uint256 generation,
1967         uint256 genes
1968     ) {
1969         Kitty storage kit = kitties[_id];
1970 
1971         // if this variable is 0 then it's not gestating
1972         isGestating = (kit.siringWithId != 0);
1973         isReady = (kit.cooldownEndBlock <= block.number);
1974         cooldownIndex = uint256(kit.cooldownIndex);
1975         nextActionAt = uint256(kit.cooldownEndBlock);
1976         siringWithId = uint256(kit.siringWithId);
1977         birthTime = uint256(kit.birthTime);
1978         matronId = uint256(kit.matronId);
1979         sireId = uint256(kit.sireId);
1980         generation = uint256(kit.generation);
1981         genes = kit.genes;
1982     }
1983 
1984     /// @dev Override unpause so it requires all external contract addresses
1985     ///  to be set before contract can be unpaused. Also, we can't have
1986     ///  newContractAddress set either, because then the contract was upgraded.
1987     /// @notice This is public rather than external so we can call super.unpause
1988     ///  without using an expensive CALL.
1989     function unpause() public onlyCEO whenPaused {
1990         require(saleAuction != address(0));
1991         require(siringAuction != address(0));
1992         require(geneScience != address(0));
1993         require(newContractAddress == address(0));
1994 
1995         // Actually unpause the contract.
1996         super.unpause();
1997     }
1998 
1999     // @dev Allows the CFO to capture the balance available to the contract.
2000     function withdrawBalance() external onlyCFO {
2001         uint256 balance = this.balance;
2002         // Subtract all the currently pregnant kittens we have, plus 1 of margin.
2003         uint256 subtractFees = (pregnantKitties + 1) * autoBirthFee;
2004 
2005         if (balance > subtractFees) {
2006             cfoAddress.send(balance - subtractFees);
2007         }
2008     }
2009 }