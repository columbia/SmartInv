1 pragma solidity ^0.4.11;
2 
3 
4 contract ERC20 {
5     function totalSupply() constant returns (uint supply);
6     function balanceOf( address who ) constant returns (uint value);
7     function allowance( address owner, address spender ) constant returns (uint _allowance);
8 
9     function transfer( address to, uint value) returns (bool ok);
10     function transferFrom( address from, address to, uint value) returns (bool ok);
11     function approve( address spender, uint value ) returns (bool ok);
12 
13     event Transfer( address indexed from, address indexed to, uint value);
14     event Approval( address indexed owner, address indexed spender, uint value);
15 }
16 /**
17  * @title Ownable
18  * @dev The Ownable contract has an owner address, and provides basic authorization control
19  * functions, this simplifies the implementation of "user permissions".
20  */
21 contract Ownable {
22   address public owner;
23 
24 
25   /**
26    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
27    * account.
28    */
29   function Ownable() {
30     owner = msg.sender;
31   }
32 
33 
34   /**
35    * @dev Throws if called by any account other than the owner.
36    */
37   modifier onlyOwner() {
38     require(msg.sender == owner);
39     _;
40   }
41 
42 
43   /**
44    * @dev Allows the current owner to transfer control of the contract to a newOwner.
45    * @param newOwner The address to transfer ownership to.
46    */
47   function transferOwnership(address newOwner) onlyOwner {
48     if (newOwner != address(0)) {
49       owner = newOwner;
50     }
51   }
52 
53 }
54 
55 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
56 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
57 contract ERC721 {
58     // Required methods
59     function totalSupply() public view returns (uint256 total);
60     function balanceOf(address _owner) public view returns (uint256 balance);
61     function ownerOf(uint256 _tokenId) external view returns (address owner);
62     function approve(address _to, uint256 _tokenId) external;
63     function transfer(address _to, uint256 _tokenId) external;
64     function transferFrom(address _from, address _to, uint256 _tokenId) external;
65 
66     // Events
67     event Transfer(address from, address to, uint256 tokenId);
68     event Approval(address owner, address approved, uint256 tokenId);
69 
70     // Optional
71     // function name() public view returns (string name);
72     // function symbol() public view returns (string symbol);
73     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
74     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
75 
76     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
77     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
78 }
79 
80 contract GeneScienceInterface {
81     /// @dev simply a boolean to indicate this is the contract we expect to be
82     function isGeneScience() public pure returns (bool);
83 
84     /// @dev given genes of kitten 1 & 2, return a genetic combination - may have a random factor
85     /// @param genes1 genes of mom
86     /// @param genes2 genes of sire
87     /// @return the genes that are supposed to be passed down the child
88     function mixGenes(uint256[2] genes1, uint256[2] genes2,uint256 g1,uint256 g2, uint256 targetBlock) public returns (uint256[2]);
89 
90     function getPureFromGene(uint256[2] gene) public view returns(uint256);
91 
92     /// @dev get sex from genes 0: female 1: male
93     function getSex(uint256[2] gene) public view returns(uint256);
94 
95     /// @dev get wizz type from gene
96     function getWizzType(uint256[2] gene) public view returns(uint256);
97 
98     function clearWizzType(uint256[2] _gene) public returns(uint256[2]);
99 }
100 
101 /// @title A facet of PandaCore that manages special access privileges.
102 /// @author Axiom Zen (https://www.axiomzen.co)
103 /// @dev See the PandaCore contract documentation to understand how the various contract facets are arranged.
104 contract PandaAccessControl {
105     // This facet controls access control for CryptoPandas. There are four roles managed here:
106     //
107     //     - The CEO: The CEO can reassign other roles and change the addresses of our dependent smart
108     //         contracts. It is also the only role that can unpause the smart contract. It is initially
109     //         set to the address that created the smart contract in the PandaCore constructor.
110     //
111     //     - The CFO: The CFO can withdraw funds from PandaCore and its auction contracts.
112     //
113     //     - The COO: The COO can release gen0 pandas to auction, and mint promo cats.
114     //
115     // It should be noted that these roles are distinct without overlap in their access abilities, the
116     // abilities listed for each role above are exhaustive. In particular, while the CEO can assign any
117     // address to any role, the CEO address itself doesn't have the ability to act in those roles. This
118     // restriction is intentional so that we aren't tempted to use the CEO address frequently out of
119     // convenience. The less we use an address, the less likely it is that we somehow compromise the
120     // account.
121 
122     /// @dev Emited when contract is upgraded - See README.md for updgrade plan
123     event ContractUpgrade(address newContract);
124 
125     // The addresses of the accounts (or contracts) that can execute actions within each roles.
126     address public ceoAddress;
127     address public cfoAddress;
128     address public cooAddress;
129 
130     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
131     bool public paused = false;
132 
133     /// @dev Access modifier for CEO-only functionality
134     modifier onlyCEO() {
135         require(msg.sender == ceoAddress);
136         _;
137     }
138 
139     /// @dev Access modifier for CFO-only functionality
140     modifier onlyCFO() {
141         require(msg.sender == cfoAddress);
142         _;
143     }
144 
145     /// @dev Access modifier for COO-only functionality
146     modifier onlyCOO() {
147         require(msg.sender == cooAddress);
148         _;
149     }
150 
151     modifier onlyCLevel() {
152         require(
153             msg.sender == cooAddress ||
154             msg.sender == ceoAddress ||
155             msg.sender == cfoAddress
156         );
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
215 
216 
217 
218 
219 
220 
221 
222 /// @title Base contract for CryptoPandas. Holds all common structs, events and base variables.
223 /// @author Axiom Zen (https://www.axiomzen.co)
224 /// @dev See the PandaCore contract documentation to understand how the various contract facets are arranged.
225 contract PandaBase is PandaAccessControl {
226     /*** EVENTS ***/
227 
228     uint256 public constant GEN0_TOTAL_COUNT = 16200;
229     uint256 public gen0CreatedCount;
230 
231     /// @dev The Birth event is fired whenever a new kitten comes into existence. This obviously
232     ///  includes any time a cat is created through the giveBirth method, but it is also called
233     ///  when a new gen0 cat is created.
234     event Birth(address owner, uint256 pandaId, uint256 matronId, uint256 sireId, uint256[2] genes);
235 
236     /// @dev Transfer event as defined in current draft of ERC721. Emitted every time a kitten
237     ///  ownership is assigned, including births.
238     event Transfer(address from, address to, uint256 tokenId);
239 
240     /*** DATA TYPES ***/
241 
242     /// @dev The main Panda struct. Every cat in CryptoPandas is represented by a copy
243     ///  of this structure, so great care was taken to ensure that it fits neatly into
244     ///  exactly two 256-bit words. Note that the order of the members in this structure
245     ///  Ref: http://solidity.readthedocs.io/en/develop/miscellaneous.html
246     struct Panda {
247         // The Panda's genetic code is packed into these 256-bits, the format is
248         // sooper-sekret! A cat's genes never change.
249         uint256[2] genes;
250 
251         // The timestamp from the block when this cat came into existence.
252         uint64 birthTime;
253 
254         // The minimum timestamp after which this cat can engage in breeding
255         // activities again. This same timestamp is used for the pregnancy
256         // timer (for matrons) as well as the siring cooldown.
257         uint64 cooldownEndBlock;
258 
259         // The ID of the parents of this panda, set to 0 for gen0 cats.
260         // Note that using 32-bit unsigned integers limits us to a "mere"
261         // 4 billion cats. This number might seem small until you realize
262         // that Ethereum currently has a limit of about 500 million
263         // transactions per year! So, this definitely won't be a problem
264         // for several years (even as Ethereum learns to scale).
265         uint32 matronId;
266         uint32 sireId;
267 
268         // Set to the ID of the sire cat for matrons that are pregnant,
269         // zero otherwise. A non-zero value here is how we know a cat
270         // is pregnant. Used to retrieve the genetic material for the new
271         // kitten when the birth transpires.
272         uint32 siringWithId;
273 
274         // Set to the index in the cooldown array (see below) that represents
275         // the current cooldown duration for this Panda. This starts at zero
276         // for gen0 cats, and is initialized to floor(generation/2) for others.
277         // Incremented by one for each successful breeding action, regardless
278         // of whether this cat is acting as matron or sire.
279         uint16 cooldownIndex;
280 
281         // The "generation number" of this cat. Cats minted by the CK contract
282         // for sale are called "gen0" and have a generation number of 0. The
283         // generation number of all other cats is the larger of the two generation
284         // numbers of their parents, plus one.
285         // (i.e. max(matron.generation, sire.generation) + 1)
286         uint16 generation;
287     }
288 
289     /*** CONSTANTS ***/
290 
291     /// @dev A lookup table indicating the cooldown duration after any successful
292     ///  breeding action, called "pregnancy time" for matrons and "siring cooldown"
293     ///  for sires. Designed such that the cooldown roughly doubles each time a cat
294     ///  is bred, encouraging owners not to just keep breeding the same cat over
295     ///  and over again. Caps out at one week (a cat can breed an unbounded number
296     ///  of times, and the maximum cooldown is always seven days).
297     uint32[9] public cooldowns = [
298         uint32(5 minutes),
299         uint32(30 minutes),
300         uint32(2 hours),
301         uint32(4 hours),    
302         uint32(8 hours),
303         uint32(24 hours),
304         uint32(48 hours),
305         uint32(72 hours),
306         uint32(7 days)
307     ];
308 
309     // An approximation of currently how many seconds are in between blocks.
310     uint256 public secondsPerBlock = 15;
311 
312     /*** STORAGE ***/
313 
314     /// @dev An array containing the Panda struct for all Pandas in existence. The ID
315     ///  of each cat is actually an index into this array. Note that ID 0 is a negacat,
316     ///  the unPanda, the mythical beast that is the parent of all gen0 cats. A bizarre
317     ///  creature that is both matron and sire... to itself! Has an invalid genetic code.
318     ///  In other words, cat ID 0 is invalid... ;-)
319     Panda[] pandas;
320 
321     /// @dev A mapping from cat IDs to the address that owns them. All cats have
322     ///  some valid owner address, even gen0 cats are created with a non-zero owner.
323     mapping (uint256 => address) public pandaIndexToOwner;
324 
325     // @dev A mapping from owner address to count of tokens that address owns.
326     //  Used internally inside balanceOf() to resolve ownership count.
327     mapping (address => uint256) ownershipTokenCount;
328 
329     /// @dev A mapping from PandaIDs to an address that has been approved to call
330     ///  transferFrom(). Each Panda can only have one approved address for transfer
331     ///  at any time. A zero value means no approval is outstanding.
332     mapping (uint256 => address) public pandaIndexToApproved;
333 
334     /// @dev A mapping from PandaIDs to an address that has been approved to use
335     ///  this Panda for siring via breedWith(). Each Panda can only have one approved
336     ///  address for siring at any time. A zero value means no approval is outstanding.
337     mapping (uint256 => address) public sireAllowedToAddress;
338 
339     /// @dev The address of the ClockAuction contract that handles sales of Pandas. This
340     ///  same contract handles both peer-to-peer sales as well as the gen0 sales which are
341     ///  initiated every 15 minutes.
342     SaleClockAuction public saleAuction;
343 
344     /// @dev The address of a custom ClockAuction subclassed contract that handles siring
345     ///  auctions. Needs to be separate from saleAuction because the actions taken on success
346     ///  after a sales and siring auction are quite different.
347     SiringClockAuction public siringAuction;
348 
349 
350     /// @dev The address of the sibling contract that is used to implement the sooper-sekret
351     ///  genetic combination algorithm.
352     GeneScienceInterface public geneScience;
353 
354 
355     SaleClockAuctionERC20 public saleAuctionERC20;
356 
357 
358     // wizz panda total
359     mapping (uint256 => uint256) public wizzPandaQuota;
360     mapping (uint256 => uint256) public wizzPandaCount;
361 
362     
363     /// wizz panda control
364     function getWizzPandaQuotaOf(uint256 _tp) view external returns(uint256) {
365         return wizzPandaQuota[_tp];
366     }
367 
368     function getWizzPandaCountOf(uint256 _tp) view external returns(uint256) {
369         return wizzPandaCount[_tp];
370     }
371 
372     function setTotalWizzPandaOf(uint256 _tp,uint256 _total) external onlyCLevel {
373         require (wizzPandaQuota[_tp]==0);
374         require (_total==uint256(uint32(_total)));
375         wizzPandaQuota[_tp] = _total;
376     }
377 
378     function getWizzTypeOf(uint256 _id) view external returns(uint256) {
379         Panda memory _p = pandas[_id];
380         return geneScience.getWizzType(_p.genes);
381     }
382 
383     /// @dev Assigns ownership of a specific Panda to an address.
384     function _transfer(address _from, address _to, uint256 _tokenId) internal {
385         // Since the number of kittens is capped to 2^32 we can't overflow this
386         ownershipTokenCount[_to]++;
387         // transfer ownership
388         pandaIndexToOwner[_tokenId] = _to;
389         // When creating new kittens _from is 0x0, but we can't account that address.
390         if (_from != address(0)) {
391             ownershipTokenCount[_from]--;
392             // once the kitten is transferred also clear sire allowances
393             delete sireAllowedToAddress[_tokenId];
394             // clear any previously approved ownership exchange
395             delete pandaIndexToApproved[_tokenId];
396         }
397         // Emit the transfer event.
398         Transfer(_from, _to, _tokenId);
399     }
400 
401     /// @dev An internal method that creates a new panda and stores it. This
402     ///  method doesn't do any checking and should only be called when the
403     ///  input data is known to be valid. Will generate both a Birth event
404     ///  and a Transfer event.
405     /// @param _matronId The panda ID of the matron of this cat (zero for gen0)
406     /// @param _sireId The panda ID of the sire of this cat (zero for gen0)
407     /// @param _generation The generation number of this cat, must be computed by caller.
408     /// @param _genes The panda's genetic code.
409     /// @param _owner The inital owner of this cat, must be non-zero (except for the unPanda, ID 0)
410     function _createPanda(
411         uint256 _matronId,
412         uint256 _sireId,
413         uint256 _generation,
414         uint256[2] _genes,
415         address _owner
416     )
417         internal
418         returns (uint)
419     {
420         // These requires are not strictly necessary, our calling code should make
421         // sure that these conditions are never broken. However! _createPanda() is already
422         // an expensive call (for storage), and it doesn't hurt to be especially careful
423         // to ensure our data structures are always valid.
424         require(_matronId == uint256(uint32(_matronId)));
425         require(_sireId == uint256(uint32(_sireId)));
426         require(_generation == uint256(uint16(_generation)));
427 
428 
429         // New panda starts with the same cooldown as parent gen/2
430         uint16 cooldownIndex = 0;
431         // when contract creation, geneScience ref is null 
432         if (pandas.length>0){
433             uint16 pureDegree = uint16(geneScience.getPureFromGene(_genes));
434             if (pureDegree==0) {
435                 pureDegree = 1;
436             }
437             cooldownIndex = 1000/pureDegree;
438             if (cooldownIndex%10 < 5){
439                 cooldownIndex = cooldownIndex/10;
440             }else{
441                 cooldownIndex = cooldownIndex/10 + 1;
442             }
443             cooldownIndex = cooldownIndex - 1;
444             if (cooldownIndex > 8) {
445                 cooldownIndex = 8;
446             }
447             uint256 _tp = geneScience.getWizzType(_genes);
448             if (_tp>0 && wizzPandaQuota[_tp]<=wizzPandaCount[_tp]) {
449                 _genes = geneScience.clearWizzType(_genes);
450                 _tp = 0;
451             }
452             // gensis panda cooldownIndex should be 24 hours
453             if (_tp == 1){
454                 cooldownIndex = 5;
455             }
456 
457             // increase wizz counter
458             if (_tp>0){
459                 wizzPandaCount[_tp] = wizzPandaCount[_tp] + 1;
460             }
461             // all gen0&gen1 except gensis
462             if (_generation <= 1 && _tp != 1){
463                 require(gen0CreatedCount<GEN0_TOTAL_COUNT);
464                 gen0CreatedCount++;
465             }
466         }
467 
468         Panda memory _panda = Panda({
469             genes: _genes,
470             birthTime: uint64(now),
471             cooldownEndBlock: 0,
472             matronId: uint32(_matronId),
473             sireId: uint32(_sireId),
474             siringWithId: 0,
475             cooldownIndex: cooldownIndex,
476             generation: uint16(_generation)
477         });
478         uint256 newKittenId = pandas.push(_panda) - 1;
479 
480         // It's probably never going to happen, 4 billion cats is A LOT, but
481         // let's just be 100% sure we never let this happen.
482         require(newKittenId == uint256(uint32(newKittenId)));
483 
484         // emit the birth event
485         Birth(
486             _owner,
487             newKittenId,
488             uint256(_panda.matronId),
489             uint256(_panda.sireId),
490             _panda.genes
491         );
492 
493         // This will assign ownership, and also emit the Transfer event as
494         // per ERC721 draft
495         _transfer(0, _owner, newKittenId);
496         
497         return newKittenId;
498     }
499 
500     // Any C-level can fix how many seconds per blocks are currently observed.
501     function setSecondsPerBlock(uint256 secs) external onlyCLevel {
502         require(secs < cooldowns[0]);
503         secondsPerBlock = secs;
504     }
505 }
506 /// @title The external contract that is responsible for generating metadata for the pandas,
507 ///  it has one function that will return the data as bytes.
508 contract ERC721Metadata {
509     /// @dev Given a token Id, returns a byte array that is supposed to be converted into string.
510     function getMetadata(uint256 _tokenId, string) public view returns (bytes32[4] buffer, uint256 count) {
511         if (_tokenId == 1) {
512             buffer[0] = "Hello World! :D";
513             count = 15;
514         } else if (_tokenId == 2) {
515             buffer[0] = "I would definitely choose a medi";
516             buffer[1] = "um length string.";
517             count = 49;
518         } else if (_tokenId == 3) {
519             buffer[0] = "Lorem ipsum dolor sit amet, mi e";
520             buffer[1] = "st accumsan dapibus augue lorem,";
521             buffer[2] = " tristique vestibulum id, libero";
522             buffer[3] = " suscipit varius sapien aliquam.";
523             count = 128;
524         }
525     }
526 }
527 
528 
529 
530 
531 
532 
533 
534 /// @title The facet of the CryptoPandas core contract that manages ownership, ERC-721 (draft) compliant.
535 /// @author Axiom Zen (https://www.axiomzen.co)
536 /// @dev Ref: https://github.com/ethereum/EIPs/issues/721
537 ///  See the PandaCore contract documentation to understand how the various contract facets are arranged.
538 contract PandaOwnership is PandaBase, ERC721 {
539 
540     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
541     string public constant name = "PandaEarth";
542     string public constant symbol = "PE";
543 
544     bytes4 constant InterfaceSignature_ERC165 =
545         bytes4(keccak256('supportsInterface(bytes4)'));
546 
547     bytes4 constant InterfaceSignature_ERC721 =
548         bytes4(keccak256('name()')) ^
549         bytes4(keccak256('symbol()')) ^
550         bytes4(keccak256('totalSupply()')) ^
551         bytes4(keccak256('balanceOf(address)')) ^
552         bytes4(keccak256('ownerOf(uint256)')) ^
553         bytes4(keccak256('approve(address,uint256)')) ^
554         bytes4(keccak256('transfer(address,uint256)')) ^
555         bytes4(keccak256('transferFrom(address,address,uint256)')) ^
556         bytes4(keccak256('tokensOfOwner(address)')) ^
557         bytes4(keccak256('tokenMetadata(uint256,string)'));
558 
559     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
560     ///  Returns true for any standardized interfaces implemented by this contract. We implement
561     ///  ERC-165 (obviously!) and ERC-721.
562     function supportsInterface(bytes4 _interfaceID) external view returns (bool)
563     {
564         // DEBUG ONLY
565         //require((InterfaceSignature_ERC165 == 0x01ffc9a7) && (InterfaceSignature_ERC721 == 0x9a20483d));
566 
567         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
568     }
569 
570     // Internal utility functions: These functions all assume that their input arguments
571     // are valid. We leave it to public methods to sanitize their inputs and follow
572     // the required logic.
573 
574     /// @dev Checks if a given address is the current owner of a particular Panda.
575     /// @param _claimant the address we are validating against.
576     /// @param _tokenId kitten id, only valid when > 0
577     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
578         return pandaIndexToOwner[_tokenId] == _claimant;
579     }
580 
581     /// @dev Checks if a given address currently has transferApproval for a particular Panda.
582     /// @param _claimant the address we are confirming kitten is approved for.
583     /// @param _tokenId kitten id, only valid when > 0
584     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
585         return pandaIndexToApproved[_tokenId] == _claimant;
586     }
587 
588     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
589     ///  approval. Setting _approved to address(0) clears all transfer approval.
590     ///  NOTE: _approve() does NOT send the Approval event. This is intentional because
591     ///  _approve() and transferFrom() are used together for putting Pandas on auction, and
592     ///  there is no value in spamming the log with Approval events in that case.
593     function _approve(uint256 _tokenId, address _approved) internal {
594         pandaIndexToApproved[_tokenId] = _approved;
595     }
596 
597     /// @notice Returns the number of Pandas owned by a specific address.
598     /// @param _owner The owner address to check.
599     /// @dev Required for ERC-721 compliance
600     function balanceOf(address _owner) public view returns (uint256 count) {
601         return ownershipTokenCount[_owner];
602     }
603 
604     /// @notice Transfers a Panda to another address. If transferring to a smart
605     ///  contract be VERY CAREFUL to ensure that it is aware of ERC-721 (or
606     ///  CryptoPandas specifically) or your Panda may be lost forever. Seriously.
607     /// @param _to The address of the recipient, can be a user or contract.
608     /// @param _tokenId The ID of the Panda to transfer.
609     /// @dev Required for ERC-721 compliance.
610     function transfer(
611         address _to,
612         uint256 _tokenId
613     )
614         external
615         whenNotPaused
616     {
617         // Safety check to prevent against an unexpected 0x0 default.
618         require(_to != address(0));
619         // Disallow transfers to this contract to prevent accidental misuse.
620         // The contract should never own any pandas (except very briefly
621         // after a gen0 cat is created and before it goes on auction).
622         require(_to != address(this));
623         // Disallow transfers to the auction contracts to prevent accidental
624         // misuse. Auction contracts should only take ownership of pandas
625         // through the allow + transferFrom flow.
626         require(_to != address(saleAuction));
627         require(_to != address(siringAuction));
628 
629         // You can only send your own cat.
630         require(_owns(msg.sender, _tokenId));
631 
632         // Reassign ownership, clear pending approvals, emit Transfer event.
633         _transfer(msg.sender, _to, _tokenId);
634     }
635 
636     /// @notice Grant another address the right to transfer a specific Panda via
637     ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
638     /// @param _to The address to be granted transfer approval. Pass address(0) to
639     ///  clear all approvals.
640     /// @param _tokenId The ID of the Panda that can be transferred if this call succeeds.
641     /// @dev Required for ERC-721 compliance.
642     function approve(
643         address _to,
644         uint256 _tokenId
645     )
646         external
647         whenNotPaused
648     {
649         // Only an owner can grant transfer approval.
650         require(_owns(msg.sender, _tokenId));
651 
652         // Register the approval (replacing any previous approval).
653         _approve(_tokenId, _to);
654 
655         // Emit approval event.
656         Approval(msg.sender, _to, _tokenId);
657     }
658 
659     /// @notice Transfer a Panda owned by another address, for which the calling address
660     ///  has previously been granted transfer approval by the owner.
661     /// @param _from The address that owns the Panda to be transfered.
662     /// @param _to The address that should take ownership of the Panda. Can be any address,
663     ///  including the caller.
664     /// @param _tokenId The ID of the Panda to be transferred.
665     /// @dev Required for ERC-721 compliance.
666     function transferFrom(
667         address _from,
668         address _to,
669         uint256 _tokenId
670     )
671         external
672         whenNotPaused
673     {
674         // Safety check to prevent against an unexpected 0x0 default.
675         require(_to != address(0));
676         // Disallow transfers to this contract to prevent accidental misuse.
677         // The contract should never own any pandas (except very briefly
678         // after a gen0 cat is created and before it goes on auction).
679         require(_to != address(this));
680         // Check for approval and valid ownership
681         require(_approvedFor(msg.sender, _tokenId));
682         require(_owns(_from, _tokenId));
683 
684         // Reassign ownership (also clears pending approvals and emits Transfer event).
685         _transfer(_from, _to, _tokenId);
686     }
687 
688     /// @notice Returns the total number of Pandas currently in existence.
689     /// @dev Required for ERC-721 compliance.
690     function totalSupply() public view returns (uint) {
691         return pandas.length - 1;
692     }
693 
694     /// @notice Returns the address currently assigned ownership of a given Panda.
695     /// @dev Required for ERC-721 compliance.
696     function ownerOf(uint256 _tokenId)
697         external
698         view
699         returns (address owner)
700     {
701         owner = pandaIndexToOwner[_tokenId];
702 
703         require(owner != address(0));
704     }
705 
706     /// @notice Returns a list of all Panda IDs assigned to an address.
707     /// @param _owner The owner whose Pandas we are interested in.
708     /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
709     ///  expensive (it walks the entire Panda array looking for cats belonging to owner),
710     ///  but it also returns a dynamic array, which is only supported for web3 calls, and
711     ///  not contract-to-contract calls.
712     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
713         uint256 tokenCount = balanceOf(_owner);
714 
715         if (tokenCount == 0) {
716             // Return an empty array
717             return new uint256[](0);
718         } else {
719             uint256[] memory result = new uint256[](tokenCount);
720             uint256 totalCats = totalSupply();
721             uint256 resultIndex = 0;
722 
723             // We count on the fact that all cats have IDs starting at 1 and increasing
724             // sequentially up to the totalCat count.
725             uint256 catId;
726 
727             for (catId = 1; catId <= totalCats; catId++) {
728                 if (pandaIndexToOwner[catId] == _owner) {
729                     result[resultIndex] = catId;
730                     resultIndex++;
731                 }
732             }
733 
734             return result;
735         }
736     }
737 
738     /// @dev Adapted from memcpy() by @arachnid (Nick Johnson <arachnid@notdot.net>)
739     ///  This method is licenced under the Apache License.
740     ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
741     function _memcpy(uint _dest, uint _src, uint _len) private view {
742         // Copy word-length chunks while possible
743         for(; _len >= 32; _len -= 32) {
744             assembly {
745                 mstore(_dest, mload(_src))
746             }
747             _dest += 32;
748             _src += 32;
749         }
750 
751         // Copy remaining bytes
752         uint256 mask = 256 ** (32 - _len) - 1;
753         assembly {
754             let srcpart := and(mload(_src), not(mask))
755             let destpart := and(mload(_dest), mask)
756             mstore(_dest, or(destpart, srcpart))
757         }
758     }
759 
760     /// @dev Adapted from toString(slice) by @arachnid (Nick Johnson <arachnid@notdot.net>)
761     ///  This method is licenced under the Apache License.
762     ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
763     function _toString(bytes32[4] _rawBytes, uint256 _stringLength) private view returns (string) {
764         var outputString = new string(_stringLength);
765         uint256 outputPtr;
766         uint256 bytesPtr;
767 
768         assembly {
769             outputPtr := add(outputString, 32)
770             bytesPtr := _rawBytes
771         }
772 
773         _memcpy(outputPtr, bytesPtr, _stringLength);
774 
775         return outputString;
776     }
777 
778 }
779 
780 
781 
782 
783 /// @title A facet of PandaCore that manages Panda siring, gestation, and birth.
784 /// @author Axiom Zen (https://www.axiomzen.co)
785 /// @dev See the PandaCore contract documentation to understand how the various contract facets are arranged.
786 contract PandaBreeding is PandaOwnership {
787 
788     uint256 public constant GENSIS_TOTAL_COUNT = 100;
789 
790     /// @dev The Pregnant event is fired when two cats successfully breed and the pregnancy
791     ///  timer begins for the matron.
792     event Pregnant(address owner, uint256 matronId, uint256 sireId, uint256 cooldownEndBlock);
793     /// @dev The Abortion event is fired when two cats breed failed.
794     event Abortion(address owner, uint256 matronId, uint256 sireId);
795 
796     /// @notice The minimum payment required to use breedWithAuto(). This fee goes towards
797     ///  the gas cost paid by whatever calls giveBirth(), and can be dynamically updated by
798     ///  the COO role as the gas price changes.
799     uint256 public autoBirthFee = 2 finney;
800 
801     // Keeps track of number of pregnant pandas.
802     uint256 public pregnantPandas;
803 
804     mapping(uint256 => address) childOwner;
805 
806 
807     /// @dev Update the address of the genetic contract, can only be called by the CEO.
808     /// @param _address An address of a GeneScience contract instance to be used from this point forward.
809     function setGeneScienceAddress(address _address) external onlyCEO {
810         GeneScienceInterface candidateContract = GeneScienceInterface(_address);
811 
812         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
813         require(candidateContract.isGeneScience());
814 
815         // Set the new contract address
816         geneScience = candidateContract;
817     }
818 
819     /// @dev Checks that a given kitten is able to breed. Requires that the
820     ///  current cooldown is finished (for sires) and also checks that there is
821     ///  no pending pregnancy.
822     function _isReadyToBreed(Panda _kit) internal view returns(bool) {
823         // In addition to checking the cooldownEndBlock, we also need to check to see if
824         // the cat has a pending birth; there can be some period of time between the end
825         // of the pregnacy timer and the birth event.
826         return (_kit.siringWithId == 0) && (_kit.cooldownEndBlock <= uint64(block.number));
827     }
828 
829     /// @dev Check if a sire has authorized breeding with this matron. True if both sire
830     ///  and matron have the same owner, or if the sire has given siring permission to
831     ///  the matron's owner (via approveSiring()).
832     function _isSiringPermitted(uint256 _sireId, uint256 _matronId) internal view returns(bool) {
833         address matronOwner = pandaIndexToOwner[_matronId];
834         address sireOwner = pandaIndexToOwner[_sireId];
835 
836         // Siring is okay if they have same owner, or if the matron's owner was given
837         // permission to breed with this sire.
838         return (matronOwner == sireOwner || sireAllowedToAddress[_sireId] == matronOwner);
839     }
840 
841     /// @dev Set the cooldownEndTime for the given Panda, based on its current cooldownIndex.
842     ///  Also increments the cooldownIndex (unless it has hit the cap).
843     /// @param _kitten A reference to the Panda in storage which needs its timer started.
844     function _triggerCooldown(Panda storage _kitten) internal {
845         // Compute an estimation of the cooldown time in blocks (based on current cooldownIndex).
846         _kitten.cooldownEndBlock = uint64((cooldowns[_kitten.cooldownIndex] / secondsPerBlock) + block.number);
847 
848 
849         // Increment the breeding count, clamping it at 13, which is the length of the
850         // cooldowns array. We could check the array size dynamically, but hard-coding
851         // this as a constant saves gas. Yay, Solidity!
852         if (_kitten.cooldownIndex < 8 && geneScience.getWizzType(_kitten.genes) != 1) {
853             _kitten.cooldownIndex += 1;
854         }
855     }
856 
857     /// @notice Grants approval to another user to sire with one of your Pandas.
858     /// @param _addr The address that will be able to sire with your Panda. Set to
859     ///  address(0) to clear all siring approvals for this Panda.
860     /// @param _sireId A Panda that you own that _addr will now be able to sire with.
861     function approveSiring(address _addr, uint256 _sireId)
862     external
863     whenNotPaused {
864         require(_owns(msg.sender, _sireId));
865         sireAllowedToAddress[_sireId] = _addr;
866     }
867 
868     /// @dev Updates the minimum payment required for calling giveBirthAuto(). Can only
869     ///  be called by the COO address. (This fee is used to offset the gas cost incurred
870     ///  by the autobirth daemon).
871     function setAutoBirthFee(uint256 val) external onlyCOO {
872         autoBirthFee = val;
873     }
874 
875     /// @dev Checks to see if a given Panda is pregnant and (if so) if the gestation
876     ///  period has passed.
877     function _isReadyToGiveBirth(Panda _matron) private view returns(bool) {
878         return (_matron.siringWithId != 0) && (_matron.cooldownEndBlock <= uint64(block.number));
879     }
880 
881     /// @notice Checks that a given kitten is able to breed (i.e. it is not pregnant or
882     ///  in the middle of a siring cooldown).
883     /// @param _pandaId reference the id of the kitten, any user can inquire about it
884     function isReadyToBreed(uint256 _pandaId)
885     public
886     view
887     returns(bool) {
888         require(_pandaId > 0);
889         Panda storage kit = pandas[_pandaId];
890         return _isReadyToBreed(kit);
891     }
892 
893     /// @dev Checks whether a panda is currently pregnant.
894     /// @param _pandaId reference the id of the kitten, any user can inquire about it
895     function isPregnant(uint256 _pandaId)
896     public
897     view
898     returns(bool) {
899         require(_pandaId > 0);
900         // A panda is pregnant if and only if this field is set
901         return pandas[_pandaId].siringWithId != 0;
902     }
903 
904     /// @dev Internal check to see if a given sire and matron are a valid mating pair. DOES NOT
905     ///  check ownership permissions (that is up to the caller).
906     /// @param _matron A reference to the Panda struct of the potential matron.
907     /// @param _matronId The matron's ID.
908     /// @param _sire A reference to the Panda struct of the potential sire.
909     /// @param _sireId The sire's ID
910     function _isValidMatingPair(
911         Panda storage _matron,
912         uint256 _matronId,
913         Panda storage _sire,
914         uint256 _sireId
915     )
916     private
917     view
918     returns(bool) {
919         // A Panda can't breed with itself!
920         if (_matronId == _sireId) {
921             return false;
922         }
923 
924         // Pandas can't breed with their parents.
925         if (_matron.matronId == _sireId || _matron.sireId == _sireId) {
926             return false;
927         }
928         if (_sire.matronId == _matronId || _sire.sireId == _matronId) {
929             return false;
930         }
931 
932         // We can short circuit the sibling check (below) if either cat is
933         // gen zero (has a matron ID of zero).
934         if (_sire.matronId == 0 || _matron.matronId == 0) {
935             return true;
936         }
937 
938         // Pandas can't breed with full or half siblings.
939         if (_sire.matronId == _matron.matronId || _sire.matronId == _matron.sireId) {
940             return false;
941         }
942         if (_sire.sireId == _matron.matronId || _sire.sireId == _matron.sireId) {
943             return false;
944         }
945 
946         // male should get breed with female
947         if (geneScience.getSex(_matron.genes) + geneScience.getSex(_sire.genes) != 1) {
948             return false;
949         }
950 
951         // Everything seems cool! Let's get DTF.
952         return true;
953     }
954 
955     /// @dev Internal check to see if a given sire and matron are a valid mating pair for
956     ///  breeding via auction (i.e. skips ownership and siring approval checks).
957     function _canBreedWithViaAuction(uint256 _matronId, uint256 _sireId)
958     internal
959     view
960     returns(bool) {
961         Panda storage matron = pandas[_matronId];
962         Panda storage sire = pandas[_sireId];
963         return _isValidMatingPair(matron, _matronId, sire, _sireId);
964     }
965 
966     /// @notice Checks to see if two cats can breed together, including checks for
967     ///  ownership and siring approvals. Does NOT check that both cats are ready for
968     ///  breeding (i.e. breedWith could still fail until the cooldowns are finished).
969     ///  TODO: Shouldn't this check pregnancy and cooldowns?!?
970     /// @param _matronId The ID of the proposed matron.
971     /// @param _sireId The ID of the proposed sire.
972     function canBreedWith(uint256 _matronId, uint256 _sireId)
973     external
974     view
975     returns(bool) {
976         require(_matronId > 0);
977         require(_sireId > 0);
978         Panda storage matron = pandas[_matronId];
979         Panda storage sire = pandas[_sireId];
980         return _isValidMatingPair(matron, _matronId, sire, _sireId) &&
981             _isSiringPermitted(_sireId, _matronId);
982     }
983 
984     function _exchangeMatronSireId(uint256 _matronId, uint256 _sireId) internal returns(uint256, uint256) {
985         if (geneScience.getSex(pandas[_matronId].genes) == 1) {
986             return (_sireId, _matronId);
987         } else {
988             return (_matronId, _sireId);
989         }
990     }
991 
992     /// @dev Internal utility function to initiate breeding, assumes that all breeding
993     ///  requirements have been checked.
994     function _breedWith(uint256 _matronId, uint256 _sireId, address _owner) internal {
995         // make id point real gender
996         (_matronId, _sireId) = _exchangeMatronSireId(_matronId, _sireId);
997         // Grab a reference to the Pandas from storage.
998         Panda storage sire = pandas[_sireId];
999         Panda storage matron = pandas[_matronId];
1000 
1001         // Mark the matron as pregnant, keeping track of who the sire is.
1002         matron.siringWithId = uint32(_sireId);
1003 
1004         // Trigger the cooldown for both parents.
1005         _triggerCooldown(sire);
1006         _triggerCooldown(matron);
1007 
1008         // Clear siring permission for both parents. This may not be strictly necessary
1009         // but it's likely to avoid confusion!
1010         delete sireAllowedToAddress[_matronId];
1011         delete sireAllowedToAddress[_sireId];
1012 
1013         // Every time a panda gets pregnant, counter is incremented.
1014         pregnantPandas++;
1015 
1016         childOwner[_matronId] = _owner;
1017 
1018         // Emit the pregnancy event.
1019         Pregnant(pandaIndexToOwner[_matronId], _matronId, _sireId, matron.cooldownEndBlock);
1020     }
1021 
1022     /// @notice Breed a Panda you own (as matron) with a sire that you own, or for which you
1023     ///  have previously been given Siring approval. Will either make your cat pregnant, or will
1024     ///  fail entirely. Requires a pre-payment of the fee given out to the first caller of giveBirth()
1025     /// @param _matronId The ID of the Panda acting as matron (will end up pregnant if successful)
1026     /// @param _sireId The ID of the Panda acting as sire (will begin its siring cooldown if successful)
1027     function breedWithAuto(uint256 _matronId, uint256 _sireId)
1028     external
1029     payable
1030     whenNotPaused {
1031         // Checks for payment.
1032         require(msg.value >= autoBirthFee);
1033 
1034         // Caller must own the matron.
1035         require(_owns(msg.sender, _matronId));
1036 
1037         // Neither sire nor matron are allowed to be on auction during a normal
1038         // breeding operation, but we don't need to check that explicitly.
1039         // For matron: The caller of this function can't be the owner of the matron
1040         //   because the owner of a Panda on auction is the auction house, and the
1041         //   auction house will never call breedWith().
1042         // For sire: Similarly, a sire on auction will be owned by the auction house
1043         //   and the act of transferring ownership will have cleared any oustanding
1044         //   siring approval.
1045         // Thus we don't need to spend gas explicitly checking to see if either cat
1046         // is on auction.
1047 
1048         // Check that matron and sire are both owned by caller, or that the sire
1049         // has given siring permission to caller (i.e. matron's owner).
1050         // Will fail for _sireId = 0
1051         require(_isSiringPermitted(_sireId, _matronId));
1052 
1053         // Grab a reference to the potential matron
1054         Panda storage matron = pandas[_matronId];
1055 
1056         // Make sure matron isn't pregnant, or in the middle of a siring cooldown
1057         require(_isReadyToBreed(matron));
1058 
1059         // Grab a reference to the potential sire
1060         Panda storage sire = pandas[_sireId];
1061 
1062         // Make sure sire isn't pregnant, or in the middle of a siring cooldown
1063         require(_isReadyToBreed(sire));
1064 
1065         // Test that these cats are a valid mating pair.
1066         require(_isValidMatingPair(
1067             matron,
1068             _matronId,
1069             sire,
1070             _sireId
1071         ));
1072 
1073         // All checks passed, panda gets pregnant!
1074         _breedWith(_matronId, _sireId, msg.sender);
1075     }
1076 
1077     /// @notice Have a pregnant Panda give birth!
1078     /// @param _matronId A Panda ready to give birth.
1079     /// @return The Panda ID of the new kitten.
1080     /// @dev Looks at a given Panda and, if pregnant and if the gestation period has passed,
1081     ///  combines the genes of the two parents to create a new kitten. The new Panda is assigned
1082     ///  to the current owner of the matron. Upon successful completion, both the matron and the
1083     ///  new kitten will be ready to breed again. Note that anyone can call this function (if they
1084     ///  are willing to pay the gas!), but the new kitten always goes to the mother's owner.
1085     function giveBirth(uint256 _matronId, uint256[2] _childGenes, uint256[2] _factors)
1086     external
1087     whenNotPaused
1088     onlyCLevel
1089     returns(uint256) {
1090         // Grab a reference to the matron in storage.
1091         Panda storage matron = pandas[_matronId];
1092 
1093         // Check that the matron is a valid cat.
1094         require(matron.birthTime != 0);
1095 
1096         // Check that the matron is pregnant, and that its time has come!
1097         require(_isReadyToGiveBirth(matron));
1098 
1099         // Grab a reference to the sire in storage.
1100         uint256 sireId = matron.siringWithId;
1101         Panda storage sire = pandas[sireId];
1102 
1103         // Determine the higher generation number of the two parents
1104         uint16 parentGen = matron.generation;
1105         if (sire.generation > matron.generation) {
1106             parentGen = sire.generation;
1107         }
1108 
1109         // Call the sooper-sekret gene mixing operation.
1110         //uint256[2] memory childGenes = geneScience.mixGenes(matron.genes, sire.genes,matron.generation,sire.generation, matron.cooldownEndBlock - 1);
1111         uint256[2] memory childGenes = _childGenes;
1112 
1113         uint256 kittenId = 0;
1114 
1115         // birth failed
1116         uint256 probability = (geneScience.getPureFromGene(matron.genes) + geneScience.getPureFromGene(sire.genes)) / 2 + _factors[0];
1117         if (probability >= (parentGen + 1) * _factors[1]) {
1118             probability = probability - (parentGen + 1) * _factors[1];
1119         } else {
1120             probability = 0;
1121         }
1122         if (parentGen == 0 && gen0CreatedCount == GEN0_TOTAL_COUNT) {
1123             probability = 0;
1124         }
1125         if (uint256(keccak256(block.blockhash(block.number - 2), now)) % 100 < probability) {
1126             // Make the new kitten!
1127             address owner = childOwner[_matronId];
1128             kittenId = _createPanda(_matronId, matron.siringWithId, parentGen + 1, childGenes, owner);
1129         } else {
1130             Abortion(pandaIndexToOwner[_matronId], _matronId, sireId);
1131         }
1132         // Make the new kitten!
1133         //address owner = pandaIndexToOwner[_matronId];
1134         //address owner = childOwner[_matronId];
1135         //uint256 kittenId = _createPanda(_matronId, matron.siringWithId, parentGen + 1, childGenes, owner);
1136 
1137         // Clear the reference to sire from the matron (REQUIRED! Having siringWithId
1138         // set is what marks a matron as being pregnant.)
1139         delete matron.siringWithId;
1140 
1141         // Every time a panda gives birth counter is decremented.
1142         pregnantPandas--;
1143 
1144         // Send the balance fee to the person who made birth happen.
1145         msg.sender.send(autoBirthFee);
1146 
1147         delete childOwner[_matronId];
1148 
1149         // return the new kitten's ID
1150         return kittenId;
1151     }
1152 }
1153 
1154 
1155 
1156 
1157 
1158 /// @title Auction Core
1159 /// @dev Contains models, variables, and internal methods for the auction.
1160 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1161 contract ClockAuctionBase {
1162 
1163     // Represents an auction on an NFT
1164     struct Auction {
1165         // Current owner of NFT
1166         address seller;
1167         // Price (in wei) at beginning of auction
1168         uint128 startingPrice;
1169         // Price (in wei) at end of auction
1170         uint128 endingPrice;
1171         // Duration (in seconds) of auction
1172         uint64 duration;
1173         // Time when auction started
1174         // NOTE: 0 if this auction has been concluded
1175         uint64 startedAt;
1176         // is this auction for gen0 panda
1177         uint64 isGen0;
1178     }
1179 
1180     // Reference to contract tracking NFT ownership
1181     ERC721 public nonFungibleContract;
1182 
1183     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
1184     // Values 0-10,000 map to 0%-100%
1185     uint256 public ownerCut;
1186 
1187     // Map from token ID to their corresponding auction.
1188     mapping (uint256 => Auction) tokenIdToAuction;
1189 
1190     event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
1191     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
1192     event AuctionCancelled(uint256 tokenId);
1193 
1194     /// @dev Returns true if the claimant owns the token.
1195     /// @param _claimant - Address claiming to own the token.
1196     /// @param _tokenId - ID of token whose ownership to verify.
1197     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
1198         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
1199     }
1200 
1201     /// @dev Escrows the NFT, assigning ownership to this contract.
1202     /// Throws if the escrow fails.
1203     /// @param _owner - Current owner address of token to escrow.
1204     /// @param _tokenId - ID of token whose approval to verify.
1205     function _escrow(address _owner, uint256 _tokenId) internal {
1206         // it will throw if transfer fails
1207         nonFungibleContract.transferFrom(_owner, this, _tokenId);
1208     }
1209 
1210     /// @dev Transfers an NFT owned by this contract to another address.
1211     /// Returns true if the transfer succeeds.
1212     /// @param _receiver - Address to transfer NFT to.
1213     /// @param _tokenId - ID of token to transfer.
1214     function _transfer(address _receiver, uint256 _tokenId) internal {
1215         // it will throw if transfer fails
1216         nonFungibleContract.transfer(_receiver, _tokenId);
1217     }
1218 
1219     /// @dev Adds an auction to the list of open auctions. Also fires the
1220     ///  AuctionCreated event.
1221     /// @param _tokenId The ID of the token to be put on auction.
1222     /// @param _auction Auction to add.
1223     function _addAuction(uint256 _tokenId, Auction _auction) internal {
1224         // Require that all auctions have a duration of
1225         // at least one minute. (Keeps our math from getting hairy!)
1226         require(_auction.duration >= 1 minutes);
1227 
1228         tokenIdToAuction[_tokenId] = _auction;
1229 
1230         AuctionCreated(
1231             uint256(_tokenId),
1232             uint256(_auction.startingPrice),
1233             uint256(_auction.endingPrice),
1234             uint256(_auction.duration)
1235         );
1236     } 
1237 
1238     /// @dev Cancels an auction unconditionally.
1239     function _cancelAuction(uint256 _tokenId, address _seller) internal {
1240         _removeAuction(_tokenId);
1241         _transfer(_seller, _tokenId);
1242         AuctionCancelled(_tokenId);
1243     }
1244 
1245     /// @dev Computes the price and transfers winnings.
1246     /// Does NOT transfer ownership of token.
1247     function _bid(uint256 _tokenId, uint256 _bidAmount)
1248         internal
1249         returns (uint256)
1250     {
1251         // Get a reference to the auction struct
1252         Auction storage auction = tokenIdToAuction[_tokenId];
1253 
1254         // Explicitly check that this auction is currently live.
1255         // (Because of how Ethereum mappings work, we can't just count
1256         // on the lookup above failing. An invalid _tokenId will just
1257         // return an auction object that is all zeros.)
1258         require(_isOnAuction(auction));
1259 
1260         // Check that the bid is greater than or equal to the current price
1261         uint256 price = _currentPrice(auction);
1262         require(_bidAmount >= price);
1263 
1264         // Grab a reference to the seller before the auction struct
1265         // gets deleted.
1266         address seller = auction.seller;
1267 
1268         // The bid is good! Remove the auction before sending the fees
1269         // to the sender so we can't have a reentrancy attack.
1270         _removeAuction(_tokenId);
1271 
1272         // Transfer proceeds to seller (if there are any!)
1273         if (price > 0) {
1274             // Calculate the auctioneer's cut.
1275             // (NOTE: _computeCut() is guaranteed to return a
1276             // value <= price, so this subtraction can't go negative.)
1277             uint256 auctioneerCut = _computeCut(price);
1278             uint256 sellerProceeds = price - auctioneerCut;
1279 
1280             // NOTE: Doing a transfer() in the middle of a complex
1281             // method like this is generally discouraged because of
1282             // reentrancy attacks and DoS attacks if the seller is
1283             // a contract with an invalid fallback function. We explicitly
1284             // guard against reentrancy attacks by removing the auction
1285             // before calling transfer(), and the only thing the seller
1286             // can DoS is the sale of their own asset! (And if it's an
1287             // accident, they can call cancelAuction(). )
1288             seller.transfer(sellerProceeds);
1289         }
1290 
1291         // Calculate any excess funds included with the bid. If the excess
1292         // is anything worth worrying about, transfer it back to bidder.
1293         // NOTE: We checked above that the bid amount is greater than or
1294         // equal to the price so this cannot underflow.
1295         uint256 bidExcess = _bidAmount - price;
1296 
1297         // Return the funds. Similar to the previous transfer, this is
1298         // not susceptible to a re-entry attack because the auction is
1299         // removed before any transfers occur.
1300         msg.sender.transfer(bidExcess);
1301 
1302         // Tell the world!
1303         AuctionSuccessful(_tokenId, price, msg.sender);
1304 
1305         return price;
1306     }
1307 
1308 
1309 
1310     /// @dev Removes an auction from the list of open auctions.
1311     /// @param _tokenId - ID of NFT on auction.
1312     function _removeAuction(uint256 _tokenId) internal {
1313         delete tokenIdToAuction[_tokenId];
1314     }
1315 
1316     /// @dev Returns true if the NFT is on auction.
1317     /// @param _auction - Auction to check.
1318     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
1319         return (_auction.startedAt > 0);
1320     }
1321 
1322     /// @dev Returns current price of an NFT on auction. Broken into two
1323     ///  functions (this one, that computes the duration from the auction
1324     ///  structure, and the other that does the price computation) so we
1325     ///  can easily test that the price computation works correctly.
1326     function _currentPrice(Auction storage _auction)
1327         internal
1328         view
1329         returns (uint256)
1330     {
1331         uint256 secondsPassed = 0;
1332 
1333         // A bit of insurance against negative values (or wraparound).
1334         // Probably not necessary (since Ethereum guarnatees that the
1335         // now variable doesn't ever go backwards).
1336         if (now > _auction.startedAt) {
1337             secondsPassed = now - _auction.startedAt;
1338         }
1339 
1340         return _computeCurrentPrice(
1341             _auction.startingPrice,
1342             _auction.endingPrice,
1343             _auction.duration,
1344             secondsPassed
1345         );
1346     }
1347 
1348     /// @dev Computes the current price of an auction. Factored out
1349     ///  from _currentPrice so we can run extensive unit tests.
1350     ///  When testing, make this function public and turn on
1351     ///  `Current price computation` test suite.
1352     function _computeCurrentPrice(
1353         uint256 _startingPrice,
1354         uint256 _endingPrice,
1355         uint256 _duration,
1356         uint256 _secondsPassed
1357     )
1358         internal
1359         pure
1360         returns (uint256)
1361     {
1362         // NOTE: We don't use SafeMath (or similar) in this function because
1363         //  all of our public functions carefully cap the maximum values for
1364         //  time (at 64-bits) and currency (at 128-bits). _duration is
1365         //  also known to be non-zero (see the require() statement in
1366         //  _addAuction())
1367         if (_secondsPassed >= _duration) {
1368             // We've reached the end of the dynamic pricing portion
1369             // of the auction, just return the end price.
1370             return _endingPrice;
1371         } else {
1372             // Starting price can be higher than ending price (and often is!), so
1373             // this delta can be negative.
1374             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
1375 
1376             // This multiplication can't overflow, _secondsPassed will easily fit within
1377             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
1378             // will always fit within 256-bits.
1379             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
1380 
1381             // currentPriceChange can be negative, but if so, will have a magnitude
1382             // less that _startingPrice. Thus, this result will always end up positive.
1383             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
1384 
1385             return uint256(currentPrice);
1386         }
1387     }
1388 
1389     /// @dev Computes owner's cut of a sale.
1390     /// @param _price - Sale price of NFT.
1391     function _computeCut(uint256 _price) internal view returns (uint256) {
1392         // NOTE: We don't use SafeMath (or similar) in this function because
1393         //  all of our entry functions carefully cap the maximum values for
1394         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
1395         //  statement in the ClockAuction constructor). The result of this
1396         //  function is always guaranteed to be <= _price.
1397         return _price * ownerCut / 10000;
1398     }
1399 
1400 }
1401 
1402 
1403 
1404 
1405 /**
1406  * @title Pausable
1407  * @dev Base contract which allows children to implement an emergency stop mechanism.
1408  */
1409 contract Pausable is Ownable {
1410   event Pause();
1411   event Unpause();
1412 
1413   bool public paused = false;
1414 
1415 
1416   /**
1417    * @dev modifier to allow actions only when the contract IS paused
1418    */
1419   modifier whenNotPaused() {
1420     require(!paused);
1421     _;
1422   }
1423 
1424   /**
1425    * @dev modifier to allow actions only when the contract IS NOT paused
1426    */
1427   modifier whenPaused {
1428     require(paused);
1429     _;
1430   }
1431 
1432   /**
1433    * @dev called by the owner to pause, triggers stopped state
1434    */
1435   function pause() onlyOwner whenNotPaused returns (bool) {
1436     paused = true;
1437     Pause();
1438     return true;
1439   }
1440 
1441   /**
1442    * @dev called by the owner to unpause, returns to normal state
1443    */
1444   function unpause() onlyOwner whenPaused returns (bool) {
1445     paused = false;
1446     Unpause();
1447     return true;
1448   }
1449 }
1450 
1451 
1452 /// @title Clock auction for non-fungible tokens.
1453 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1454 contract ClockAuction is Pausable, ClockAuctionBase {
1455 
1456     /// @dev The ERC-165 interface signature for ERC-721.
1457     ///  Ref: https://github.com/ethereum/EIPs/issues/165
1458     ///  Ref: https://github.com/ethereum/EIPs/issues/721
1459     bytes4 constant InterfaceSignature_ERC721 = bytes4(0x9a20483d);
1460 
1461     /// @dev Constructor creates a reference to the NFT ownership contract
1462     ///  and verifies the owner cut is in the valid range.
1463     /// @param _nftAddress - address of a deployed contract implementing
1464     ///  the Nonfungible Interface.
1465     /// @param _cut - percent cut the owner takes on each auction, must be
1466     ///  between 0-10,000.
1467     function ClockAuction(address _nftAddress, uint256 _cut) public {
1468         require(_cut <= 10000);
1469         ownerCut = _cut;
1470 
1471         ERC721 candidateContract = ERC721(_nftAddress);
1472         require(candidateContract.supportsInterface(InterfaceSignature_ERC721));
1473         nonFungibleContract = candidateContract;
1474     }
1475 
1476     /// @dev Remove all Ether from the contract, which is the owner's cuts
1477     ///  as well as any Ether sent directly to the contract address.
1478     ///  Always transfers to the NFT contract, but can be called either by
1479     ///  the owner or the NFT contract.
1480     function withdrawBalance() external {
1481         address nftAddress = address(nonFungibleContract);
1482 
1483         require(
1484             msg.sender == owner ||
1485             msg.sender == nftAddress
1486         );
1487         // We are using this boolean method to make sure that even if one fails it will still work
1488         bool res = nftAddress.send(this.balance);
1489     }
1490 
1491     /// @dev Creates and begins a new auction.
1492     /// @param _tokenId - ID of token to auction, sender must be owner.
1493     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
1494     /// @param _endingPrice - Price of item (in wei) at end of auction.
1495     /// @param _duration - Length of time to move between starting
1496     ///  price and ending price (in seconds).
1497     /// @param _seller - Seller, if not the message sender
1498     function createAuction(
1499         uint256 _tokenId,
1500         uint256 _startingPrice,
1501         uint256 _endingPrice,
1502         uint256 _duration,
1503         address _seller
1504     )
1505         external
1506         whenNotPaused
1507     {
1508         // Sanity check that no inputs overflow how many bits we've allocated
1509         // to store them in the auction struct.
1510         require(_startingPrice == uint256(uint128(_startingPrice)));
1511         require(_endingPrice == uint256(uint128(_endingPrice)));
1512         require(_duration == uint256(uint64(_duration)));
1513 
1514         require(_owns(msg.sender, _tokenId));
1515         _escrow(msg.sender, _tokenId);
1516         Auction memory auction = Auction(
1517             _seller,
1518             uint128(_startingPrice),
1519             uint128(_endingPrice),
1520             uint64(_duration),
1521             uint64(now),
1522             0
1523         );
1524         _addAuction(_tokenId, auction);
1525     }
1526 
1527     /// @dev Bids on an open auction, completing the auction and transferring
1528     ///  ownership of the NFT if enough Ether is supplied.
1529     /// @param _tokenId - ID of token to bid on.
1530     function bid(uint256 _tokenId)
1531         external
1532         payable
1533         whenNotPaused
1534     {
1535         // _bid will throw if the bid or funds transfer fails
1536         _bid(_tokenId, msg.value);
1537         _transfer(msg.sender, _tokenId);
1538     }
1539 
1540     /// @dev Cancels an auction that hasn't been won yet.
1541     ///  Returns the NFT to original owner.
1542     /// @notice This is a state-modifying function that can
1543     ///  be called while the contract is paused.
1544     /// @param _tokenId - ID of token on auction
1545     function cancelAuction(uint256 _tokenId)
1546         external
1547     {
1548         Auction storage auction = tokenIdToAuction[_tokenId];
1549         require(_isOnAuction(auction));
1550         address seller = auction.seller;
1551         require(msg.sender == seller);
1552         _cancelAuction(_tokenId, seller);
1553     }
1554 
1555     /// @dev Cancels an auction when the contract is paused.
1556     ///  Only the owner may do this, and NFTs are returned to
1557     ///  the seller. This should only be used in emergencies.
1558     /// @param _tokenId - ID of the NFT on auction to cancel.
1559     function cancelAuctionWhenPaused(uint256 _tokenId)
1560         whenPaused
1561         onlyOwner
1562         external
1563     {
1564         Auction storage auction = tokenIdToAuction[_tokenId];
1565         require(_isOnAuction(auction));
1566         _cancelAuction(_tokenId, auction.seller);
1567     }
1568 
1569     /// @dev Returns auction info for an NFT on auction.
1570     /// @param _tokenId - ID of NFT on auction.
1571     function getAuction(uint256 _tokenId)
1572         external
1573         view
1574         returns
1575     (
1576         address seller,
1577         uint256 startingPrice,
1578         uint256 endingPrice,
1579         uint256 duration,
1580         uint256 startedAt
1581     ) {
1582         Auction storage auction = tokenIdToAuction[_tokenId];
1583         require(_isOnAuction(auction));
1584         return (
1585             auction.seller,
1586             auction.startingPrice,
1587             auction.endingPrice,
1588             auction.duration,
1589             auction.startedAt
1590         );
1591     }
1592 
1593     /// @dev Returns the current price of an auction.
1594     /// @param _tokenId - ID of the token price we are checking.
1595     function getCurrentPrice(uint256 _tokenId)
1596         external
1597         view
1598         returns (uint256)
1599     {
1600         Auction storage auction = tokenIdToAuction[_tokenId];
1601         require(_isOnAuction(auction));
1602         return _currentPrice(auction);
1603     }
1604 
1605 }
1606 
1607 
1608 
1609 
1610 /// @title Reverse auction modified for siring
1611 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1612 contract SiringClockAuction is ClockAuction {
1613 
1614     // @dev Sanity check that allows us to ensure that we are pointing to the
1615     //  right auction in our setSiringAuctionAddress() call.
1616     bool public isSiringClockAuction = true;
1617 
1618     // Delegate constructor
1619     function SiringClockAuction(address _nftAddr, uint256 _cut) public
1620         ClockAuction(_nftAddr, _cut) {}
1621 
1622     /// @dev Creates and begins a new auction. Since this function is wrapped,
1623     /// require sender to be PandaCore contract.
1624     /// @param _tokenId - ID of token to auction, sender must be owner.
1625     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
1626     /// @param _endingPrice - Price of item (in wei) at end of auction.
1627     /// @param _duration - Length of auction (in seconds).
1628     /// @param _seller - Seller, if not the message sender
1629     function createAuction(
1630         uint256 _tokenId,
1631         uint256 _startingPrice,
1632         uint256 _endingPrice,
1633         uint256 _duration,
1634         address _seller
1635     )
1636         external
1637     {
1638         // Sanity check that no inputs overflow how many bits we've allocated
1639         // to store them in the auction struct.
1640         require(_startingPrice == uint256(uint128(_startingPrice)));
1641         require(_endingPrice == uint256(uint128(_endingPrice)));
1642         require(_duration == uint256(uint64(_duration)));
1643 
1644         require(msg.sender == address(nonFungibleContract));
1645         _escrow(_seller, _tokenId);
1646         Auction memory auction = Auction(
1647             _seller,
1648             uint128(_startingPrice),
1649             uint128(_endingPrice),
1650             uint64(_duration),
1651             uint64(now),
1652             0
1653         );
1654         _addAuction(_tokenId, auction);
1655     }
1656 
1657     /// @dev Places a bid for siring. Requires the sender
1658     /// is the PandaCore contract because all bid methods
1659     /// should be wrapped. Also returns the panda to the
1660     /// seller rather than the winner.
1661     function bid(uint256 _tokenId)
1662         external
1663         payable
1664     {
1665         require(msg.sender == address(nonFungibleContract));
1666         address seller = tokenIdToAuction[_tokenId].seller;
1667         // _bid checks that token ID is valid and will throw if bid fails
1668         _bid(_tokenId, msg.value);
1669         // We transfer the panda back to the seller, the winner will get
1670         // the offspring
1671         _transfer(seller, _tokenId);
1672     }
1673 
1674 }
1675 
1676 
1677 
1678 
1679 /// @title Clock auction modified for sale of pandas
1680 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1681 contract SaleClockAuction is ClockAuction {
1682 
1683     // @dev Sanity check that allows us to ensure that we are pointing to the
1684     //  right auction in our setSaleAuctionAddress() call.
1685     bool public isSaleClockAuction = true;
1686 
1687     // Tracks last 5 sale price of gen0 panda sales
1688     uint256 public gen0SaleCount;
1689     uint256[5] public lastGen0SalePrices;
1690     uint256 public constant SurpriseValue = 10 finney;
1691 
1692     uint256[] CommonPanda;
1693     uint256[] RarePanda;
1694     uint256   CommonPandaIndex;
1695     uint256   RarePandaIndex;
1696 
1697     // Delegate constructor
1698     function SaleClockAuction(address _nftAddr, uint256 _cut) public
1699         ClockAuction(_nftAddr, _cut) {
1700             CommonPandaIndex = 1;
1701             RarePandaIndex   = 1;
1702     }
1703 
1704     /// @dev Creates and begins a new auction.
1705     /// @param _tokenId - ID of token to auction, sender must be owner.
1706     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
1707     /// @param _endingPrice - Price of item (in wei) at end of auction.
1708     /// @param _duration - Length of auction (in seconds).
1709     /// @param _seller - Seller, if not the message sender
1710     function createAuction(
1711         uint256 _tokenId,
1712         uint256 _startingPrice,
1713         uint256 _endingPrice,
1714         uint256 _duration,
1715         address _seller
1716     )
1717         external
1718     {
1719         // Sanity check that no inputs overflow how many bits we've allocated
1720         // to store them in the auction struct.
1721         require(_startingPrice == uint256(uint128(_startingPrice)));
1722         require(_endingPrice == uint256(uint128(_endingPrice)));
1723         require(_duration == uint256(uint64(_duration)));
1724 
1725         require(msg.sender == address(nonFungibleContract));
1726         _escrow(_seller, _tokenId);
1727         Auction memory auction = Auction(
1728             _seller,
1729             uint128(_startingPrice),
1730             uint128(_endingPrice),
1731             uint64(_duration),
1732             uint64(now),
1733             0
1734         );
1735         _addAuction(_tokenId, auction);
1736     }
1737 
1738     function createGen0Auction(
1739         uint256 _tokenId,
1740         uint256 _startingPrice,
1741         uint256 _endingPrice,
1742         uint256 _duration,
1743         address _seller
1744     )
1745         external
1746     {
1747         // Sanity check that no inputs overflow how many bits we've allocated
1748         // to store them in the auction struct.
1749         require(_startingPrice == uint256(uint128(_startingPrice)));
1750         require(_endingPrice == uint256(uint128(_endingPrice)));
1751         require(_duration == uint256(uint64(_duration)));
1752 
1753         require(msg.sender == address(nonFungibleContract));
1754         _escrow(_seller, _tokenId);
1755         Auction memory auction = Auction(
1756             _seller,
1757             uint128(_startingPrice),
1758             uint128(_endingPrice),
1759             uint64(_duration),
1760             uint64(now),
1761             1
1762         );
1763         _addAuction(_tokenId, auction);
1764     }    
1765 
1766     /// @dev Updates lastSalePrice if seller is the nft contract
1767     /// Otherwise, works the same as default bid method.
1768     function bid(uint256 _tokenId)
1769         external
1770         payable
1771     {
1772         // _bid verifies token ID size
1773         uint64 isGen0 = tokenIdToAuction[_tokenId].isGen0;
1774         uint256 price = _bid(_tokenId, msg.value);
1775         _transfer(msg.sender, _tokenId);
1776 
1777         // If not a gen0 auction, exit
1778         if (isGen0 == 1) {
1779             // Track gen0 sale prices
1780             lastGen0SalePrices[gen0SaleCount % 5] = price;
1781             gen0SaleCount++;
1782         }
1783     }
1784 
1785     function createPanda(uint256 _tokenId,uint256 _type)
1786         external
1787     {
1788         require(msg.sender == address(nonFungibleContract));
1789         if (_type == 0) {
1790             CommonPanda.push(_tokenId);
1791         }else {
1792             RarePanda.push(_tokenId);
1793         }
1794     }
1795 
1796     function surprisePanda()
1797         external
1798         payable
1799     {
1800         bytes32 bHash = keccak256(block.blockhash(block.number),block.blockhash(block.number-1));
1801         uint256 PandaIndex;
1802         if (bHash[25] > 0xC8) {
1803             require(uint256(RarePanda.length) >= RarePandaIndex);
1804             PandaIndex = RarePandaIndex;
1805             RarePandaIndex ++;
1806 
1807         } else{
1808             require(uint256(CommonPanda.length) >= CommonPandaIndex);
1809             PandaIndex = CommonPandaIndex;
1810             CommonPandaIndex ++;
1811         }
1812         _transfer(msg.sender,PandaIndex);
1813     }
1814 
1815     function packageCount() external view returns(uint256 common,uint256 surprise) {
1816         common   = CommonPanda.length + 1 - CommonPandaIndex;
1817         surprise = RarePanda.length + 1 - RarePandaIndex;
1818     }
1819 
1820     function averageGen0SalePrice() external view returns (uint256) {
1821         uint256 sum = 0;
1822         for (uint256 i = 0; i < 5; i++) {
1823             sum += lastGen0SalePrices[i];
1824         }
1825         return sum / 5;
1826     }
1827 
1828 }
1829 
1830 
1831 
1832 /// @title Clock auction modified for sale of pandas
1833 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1834 contract SaleClockAuctionERC20 is ClockAuction {
1835 
1836 
1837     event AuctionERC20Created(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration, address erc20Contract);
1838 
1839     // @dev Sanity check that allows us to ensure that we are pointing to the
1840     //  right auction in our setSaleAuctionAddress() call.
1841     bool public isSaleClockAuctionERC20 = true;
1842 
1843     mapping (uint256 => address) public tokenIdToErc20Address;
1844 
1845     mapping (address => uint256) public erc20ContractsSwitcher;
1846 
1847     mapping (address => uint256) public balances;
1848     
1849     // Delegate constructor
1850     function SaleClockAuctionERC20(address _nftAddr, uint256 _cut) public
1851         ClockAuction(_nftAddr, _cut) {}
1852 
1853     function erc20ContractSwitch(address _erc20address, uint256 _onoff) external{
1854         require (msg.sender == address(nonFungibleContract));
1855 
1856         require (_erc20address != address(0));
1857 
1858         erc20ContractsSwitcher[_erc20address] = _onoff;
1859     }
1860     /// @dev Creates and begins a new auction.
1861     /// @param _tokenId - ID of token to auction, sender must be owner.
1862     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
1863     /// @param _endingPrice - Price of item (in wei) at end of auction.
1864     /// @param _duration - Length of auction (in seconds).
1865     /// @param _seller - Seller, if not the message sender
1866     function createAuction(
1867         uint256 _tokenId,
1868         address _erc20Address,
1869         uint256 _startingPrice,
1870         uint256 _endingPrice,
1871         uint256 _duration,
1872         address _seller
1873     )
1874         external
1875     {
1876         // Sanity check that no inputs overflow how many bits we've allocated
1877         // to store them in the auction struct.
1878         require(_startingPrice == uint256(uint128(_startingPrice)));
1879         require(_endingPrice == uint256(uint128(_endingPrice)));
1880         require(_duration == uint256(uint64(_duration)));
1881 
1882         require(msg.sender == address(nonFungibleContract));
1883 
1884         require (erc20ContractsSwitcher[_erc20Address] > 0);
1885         
1886         _escrow(_seller, _tokenId);
1887         Auction memory auction = Auction(
1888             _seller,
1889             uint128(_startingPrice),
1890             uint128(_endingPrice),
1891             uint64(_duration),
1892             uint64(now),
1893             0
1894         );
1895         _addAuctionERC20(_tokenId, auction, _erc20Address);
1896         tokenIdToErc20Address[_tokenId] = _erc20Address;
1897     }
1898 
1899     /// @dev Adds an auction to the list of open auctions. Also fires the
1900     ///  AuctionCreated event.
1901     /// @param _tokenId The ID of the token to be put on auction.
1902     /// @param _auction Auction to add.
1903     function _addAuctionERC20(uint256 _tokenId, Auction _auction, address _erc20address) internal {
1904         // Require that all auctions have a duration of
1905         // at least one minute. (Keeps our math from getting hairy!)
1906         require(_auction.duration >= 1 minutes);
1907 
1908         tokenIdToAuction[_tokenId] = _auction;
1909 
1910         AuctionERC20Created(
1911             uint256(_tokenId),
1912             uint256(_auction.startingPrice),
1913             uint256(_auction.endingPrice),
1914             uint256(_auction.duration),
1915             _erc20address
1916         );
1917     }   
1918 
1919     function bid(uint256 _tokenId)
1920         external
1921         payable{
1922             // do nothing
1923     }
1924 
1925     /// @dev Updates lastSalePrice if seller is the nft contract
1926     /// Otherwise, works the same as default bid method.
1927     function bidERC20(uint256 _tokenId,uint256 _amount)
1928         external
1929     {
1930         // _bid verifies token ID size
1931         address seller = tokenIdToAuction[_tokenId].seller;
1932         address _erc20address = tokenIdToErc20Address[_tokenId];
1933         require (_erc20address != address(0));
1934         uint256 price = _bidERC20(_erc20address,msg.sender,_tokenId, _amount);
1935         _transfer(msg.sender, _tokenId);
1936         delete tokenIdToErc20Address[_tokenId];
1937     }
1938 
1939     function cancelAuction(uint256 _tokenId)
1940         external
1941     {
1942         Auction storage auction = tokenIdToAuction[_tokenId];
1943         require(_isOnAuction(auction));
1944         address seller = auction.seller;
1945         require(msg.sender == seller);
1946         _cancelAuction(_tokenId, seller);
1947         delete tokenIdToErc20Address[_tokenId];
1948     }
1949 
1950     function withdrawERC20Balance(address _erc20Address, address _to) external returns(bool res)  {
1951         require (balances[_erc20Address] > 0);
1952         require(msg.sender == address(nonFungibleContract));
1953         ERC20(_erc20Address).transfer(_to, balances[_erc20Address]);
1954     }
1955     
1956     /// @dev Computes the price and transfers winnings.
1957     /// Does NOT transfer ownership of token.
1958     function _bidERC20(address _erc20Address,address _buyerAddress, uint256 _tokenId, uint256 _bidAmount)
1959         internal
1960         returns (uint256)
1961     {
1962         // Get a reference to the auction struct
1963         Auction storage auction = tokenIdToAuction[_tokenId];
1964 
1965         // Explicitly check that this auction is currently live.
1966         // (Because of how Ethereum mappings work, we can't just count
1967         // on the lookup above failing. An invalid _tokenId will just
1968         // return an auction object that is all zeros.)
1969         require(_isOnAuction(auction));
1970 
1971 
1972         require (_erc20Address != address(0) && _erc20Address == tokenIdToErc20Address[_tokenId]);
1973         
1974 
1975         // Check that the bid is greater than or equal to the current price
1976         uint256 price = _currentPrice(auction);
1977         require(_bidAmount >= price);
1978 
1979         // Grab a reference to the seller before the auction struct
1980         // gets deleted.
1981         address seller = auction.seller;
1982 
1983         // The bid is good! Remove the auction before sending the fees
1984         // to the sender so we can't have a reentrancy attack.
1985         _removeAuction(_tokenId);
1986 
1987         // Transfer proceeds to seller (if there are any!)
1988         if (price > 0) {
1989             // Calculate the auctioneer's cut.
1990             // (NOTE: _computeCut() is guaranteed to return a
1991             // value <= price, so this subtraction can't go negative.)
1992             uint256 auctioneerCut = _computeCut(price);
1993             uint256 sellerProceeds = price - auctioneerCut;
1994 
1995             // Send Erc20 Token to seller should call Erc20 contract
1996             // Reference to contract
1997             require(ERC20(_erc20Address).transferFrom(_buyerAddress,seller,sellerProceeds));
1998             if (auctioneerCut > 0){
1999                 require(ERC20(_erc20Address).transferFrom(_buyerAddress,address(this),auctioneerCut));
2000                 balances[_erc20Address] += auctioneerCut;
2001             }
2002         }
2003 
2004         // Tell the world!
2005         AuctionSuccessful(_tokenId, price, msg.sender);
2006 
2007         return price;
2008     }
2009 }
2010 
2011 
2012 /// @title Handles creating auctions for sale and siring of pandas.
2013 ///  This wrapper of ReverseAuction exists only so that users can create
2014 ///  auctions with only one transaction.
2015 contract PandaAuction is PandaBreeding {
2016 
2017     // @notice The auction contract variables are defined in PandaBase to allow
2018     //  us to refer to them in PandaOwnership to prevent accidental transfers.
2019     // `saleAuction` refers to the auction for gen0 and p2p sale of pandas.
2020     // `siringAuction` refers to the auction for siring rights of pandas.
2021 
2022     /// @dev Sets the reference to the sale auction.
2023     /// @param _address - Address of sale contract.
2024     function setSaleAuctionAddress(address _address) external onlyCEO {
2025         SaleClockAuction candidateContract = SaleClockAuction(_address);
2026 
2027         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
2028         require(candidateContract.isSaleClockAuction());
2029 
2030         // Set the new contract address
2031         saleAuction = candidateContract;
2032     }
2033 
2034     function setSaleAuctionERC20Address(address _address) external onlyCEO {
2035         SaleClockAuctionERC20 candidateContract = SaleClockAuctionERC20(_address);
2036 
2037         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
2038         require(candidateContract.isSaleClockAuctionERC20());
2039 
2040         // Set the new contract address
2041         saleAuctionERC20 = candidateContract;
2042     }
2043 
2044     /// @dev Sets the reference to the siring auction.
2045     /// @param _address - Address of siring contract.
2046     function setSiringAuctionAddress(address _address) external onlyCEO {
2047         SiringClockAuction candidateContract = SiringClockAuction(_address);
2048 
2049         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
2050         require(candidateContract.isSiringClockAuction());
2051 
2052         // Set the new contract address
2053         siringAuction = candidateContract;
2054     }
2055 
2056     /// @dev Put a panda up for auction.
2057     ///  Does some ownership trickery to create auctions in one tx.
2058     function createSaleAuction(
2059         uint256 _pandaId,
2060         uint256 _startingPrice,
2061         uint256 _endingPrice,
2062         uint256 _duration
2063     )
2064         external
2065         whenNotPaused
2066     {
2067         // Auction contract checks input sizes
2068         // If panda is already on any auction, this will throw
2069         // because it will be owned by the auction contract.
2070         require(_owns(msg.sender, _pandaId));
2071         // Ensure the panda is not pregnant to prevent the auction
2072         // contract accidentally receiving ownership of the child.
2073         // NOTE: the panda IS allowed to be in a cooldown.
2074         require(!isPregnant(_pandaId));
2075         _approve(_pandaId, saleAuction);
2076         // Sale auction throws if inputs are invalid and clears
2077         // transfer and sire approval after escrowing the panda.
2078         saleAuction.createAuction(
2079             _pandaId,
2080             _startingPrice,
2081             _endingPrice,
2082             _duration,
2083             msg.sender
2084         );
2085     }
2086 
2087     /// @dev Put a panda up for auction.
2088     ///  Does some ownership trickery to create auctions in one tx.
2089     function createSaleAuctionERC20(
2090         uint256 _pandaId,
2091         address _erc20address,
2092         uint256 _startingPrice,
2093         uint256 _endingPrice,
2094         uint256 _duration
2095     )
2096         external
2097         whenNotPaused
2098     {
2099         // Auction contract checks input sizes
2100         // If panda is already on any auction, this will throw
2101         // because it will be owned by the auction contract.
2102         require(_owns(msg.sender, _pandaId));
2103         // Ensure the panda is not pregnant to prevent the auction
2104         // contract accidentally receiving ownership of the child.
2105         // NOTE: the panda IS allowed to be in a cooldown.
2106         require(!isPregnant(_pandaId));
2107         _approve(_pandaId, saleAuctionERC20);
2108         // Sale auction throws if inputs are invalid and clears
2109         // transfer and sire approval after escrowing the panda.
2110         saleAuctionERC20.createAuction(
2111             _pandaId,
2112             _erc20address,
2113             _startingPrice,
2114             _endingPrice,
2115             _duration,
2116             msg.sender
2117         );
2118     }
2119 
2120     function switchSaleAuctionERC20For(address _erc20address, uint256 _onoff) external onlyCOO{
2121         saleAuctionERC20.erc20ContractSwitch(_erc20address,_onoff);
2122     }
2123 
2124 
2125     /// @dev Put a panda up for auction to be sire.
2126     ///  Performs checks to ensure the panda can be sired, then
2127     ///  delegates to reverse auction.
2128     function createSiringAuction(
2129         uint256 _pandaId,
2130         uint256 _startingPrice,
2131         uint256 _endingPrice,
2132         uint256 _duration
2133     )
2134         external
2135         whenNotPaused
2136     {
2137         // Auction contract checks input sizes
2138         // If panda is already on any auction, this will throw
2139         // because it will be owned by the auction contract.
2140         require(_owns(msg.sender, _pandaId));
2141         require(isReadyToBreed(_pandaId));
2142         _approve(_pandaId, siringAuction);
2143         // Siring auction throws if inputs are invalid and clears
2144         // transfer and sire approval after escrowing the panda.
2145         siringAuction.createAuction(
2146             _pandaId,
2147             _startingPrice,
2148             _endingPrice,
2149             _duration,
2150             msg.sender
2151         );
2152     }
2153 
2154     /// @dev Completes a siring auction by bidding.
2155     ///  Immediately breeds the winning matron with the sire on auction.
2156     /// @param _sireId - ID of the sire on auction.
2157     /// @param _matronId - ID of the matron owned by the bidder.
2158     function bidOnSiringAuction(
2159         uint256 _sireId,
2160         uint256 _matronId
2161     )
2162         external
2163         payable
2164         whenNotPaused
2165     {
2166         // Auction contract checks input sizes
2167         require(_owns(msg.sender, _matronId));
2168         require(isReadyToBreed(_matronId));
2169         require(_canBreedWithViaAuction(_matronId, _sireId));
2170 
2171         // Define the current price of the auction.
2172         uint256 currentPrice = siringAuction.getCurrentPrice(_sireId);
2173         require(msg.value >= currentPrice + autoBirthFee);
2174 
2175         // Siring auction will throw if the bid fails.
2176         siringAuction.bid.value(msg.value - autoBirthFee)(_sireId);
2177         _breedWith(uint32(_matronId), uint32(_sireId), msg.sender);
2178     }
2179 
2180     /// @dev Transfers the balance of the sale auction contract
2181     /// to the PandaCore contract. We use two-step withdrawal to
2182     /// prevent two transfer calls in the auction bid function.
2183     function withdrawAuctionBalances() external onlyCLevel {
2184         saleAuction.withdrawBalance();
2185         siringAuction.withdrawBalance();
2186     }
2187 
2188 
2189     function withdrawERC20Balance(address _erc20Address, address _to) external onlyCLevel {
2190         require(saleAuctionERC20 != address(0));
2191         saleAuctionERC20.withdrawERC20Balance(_erc20Address,_to);
2192     }    
2193 }
2194 
2195 
2196 
2197 
2198 
2199 /// @title all functions related to creating kittens
2200 contract PandaMinting is PandaAuction {
2201 
2202     // Limits the number of cats the contract owner can ever create.
2203     //uint256 public constant PROMO_CREATION_LIMIT = 5000;
2204     uint256 public constant GEN0_CREATION_LIMIT = 45000;
2205 
2206 
2207     // Constants for gen0 auctions.
2208     uint256 public constant GEN0_STARTING_PRICE = 100 finney;
2209     uint256 public constant GEN0_AUCTION_DURATION = 1 days;
2210     uint256 public constant OPEN_PACKAGE_PRICE = 10 finney;
2211 
2212 
2213     // Counts the number of cats the contract owner has created.
2214     //uint256 public promoCreatedCount;
2215 
2216 
2217     /// @dev we can create promo kittens, up to a limit. Only callable by COO
2218     /// @param _genes the encoded genes of the kitten to be created, any value is accepted
2219     /// @param _owner the future owner of the created kittens. Default to contract COO
2220     function createWizzPanda(uint256[2] _genes, uint256 _generation, address _owner) external onlyCOO {
2221         address pandaOwner = _owner;
2222         if (pandaOwner == address(0)) {
2223             pandaOwner = cooAddress;
2224         }
2225 
2226         _createPanda(0, 0, _generation, _genes, pandaOwner);
2227     }
2228 
2229     /// @dev create pandaWithGenes
2230     /// @param _genes panda genes
2231     /// @param _type  0 common 1 rare
2232     function createPanda(uint256[2] _genes,uint256 _generation,uint256 _type)
2233         external
2234         payable
2235         onlyCOO
2236         whenNotPaused
2237     {
2238         require(msg.value >= OPEN_PACKAGE_PRICE);
2239         uint256 kittenId = _createPanda(0, 0, _generation, _genes, saleAuction);
2240         saleAuction.createPanda(kittenId,_type);
2241     }
2242 
2243     //function buyPandaERC20(address _erc20Address, address _buyerAddress, uint256 _pandaID, uint256 _amount)
2244     //external
2245     //onlyCOO
2246     //whenNotPaused {
2247     //    saleAuctionERC20.bid(_erc20Address, _buyerAddress, _pandaID, _amount);
2248     //}
2249 
2250     /// @dev Creates a new gen0 panda with the given genes and
2251     ///  creates an auction for it.
2252     //function createGen0Auction(uint256[2] _genes) external onlyCOO {
2253     //    require(gen0CreatedCount < GEN0_CREATION_LIMIT);
2254     //
2255     //    uint256 pandaId = _createPanda(0, 0, 0, _genes, address(this));
2256     //    _approve(pandaId, saleAuction);
2257     //
2258     //    saleAuction.createAuction(
2259     //        pandaId,
2260     //        _computeNextGen0Price(),
2261     //        0,
2262     //        GEN0_AUCTION_DURATION,
2263     //        address(this)
2264     //    );
2265     //
2266     //    gen0CreatedCount++;
2267     //}
2268 
2269     function createGen0Auction(uint256 _pandaId) external onlyCOO {
2270         require(_owns(msg.sender, _pandaId));
2271         //require(pandas[_pandaId].generation==1);
2272 
2273         _approve(_pandaId, saleAuction);
2274 
2275         saleAuction.createGen0Auction(
2276             _pandaId,
2277             _computeNextGen0Price(),
2278             0,
2279             GEN0_AUCTION_DURATION,
2280             msg.sender
2281         );
2282     }
2283 
2284     /// @dev Computes the next gen0 auction starting price, given
2285     ///  the average of the past 5 prices + 50%.
2286     function _computeNextGen0Price() internal view returns(uint256) {
2287         uint256 avePrice = saleAuction.averageGen0SalePrice();
2288 
2289         // Sanity check to ensure we don't overflow arithmetic
2290         require(avePrice == uint256(uint128(avePrice)));
2291 
2292         uint256 nextPrice = avePrice + (avePrice / 2);
2293 
2294         // We never auction for less than starting price
2295         if (nextPrice < GEN0_STARTING_PRICE) {
2296             nextPrice = GEN0_STARTING_PRICE;
2297         }
2298 
2299         return nextPrice;
2300     }
2301 }
2302 
2303 
2304 
2305 /// @title CryptoPandas: Collectible, breedable, and oh-so-adorable cats on the Ethereum blockchain.
2306 /// @author Axiom Zen (https://www.axiomzen.co)
2307 /// @dev The main CryptoPandas contract, keeps track of kittens so they don't wander around and get lost.
2308 contract PandaCore is PandaMinting {
2309 
2310     // This is the main CryptoPandas contract. In order to keep our code seperated into logical sections,
2311     // we've broken it up in two ways. First, we have several seperately-instantiated sibling contracts
2312     // that handle auctions and our super-top-secret genetic combination algorithm. The auctions are
2313     // seperate since their logic is somewhat complex and there's always a risk of subtle bugs. By keeping
2314     // them in their own contracts, we can upgrade them without disrupting the main contract that tracks
2315     // panda ownership. The genetic combination algorithm is kept seperate so we can open-source all of
2316     // the rest of our code without making it _too_ easy for folks to figure out how the genetics work.
2317     // Don't worry, I'm sure someone will reverse engineer it soon enough!
2318     //
2319     // Secondly, we break the core contract into multiple files using inheritence, one for each major
2320     // facet of functionality of CK. This allows us to keep related code bundled together while still
2321     // avoiding a single giant file with everything in it. The breakdown is as follows:
2322     //
2323     //      - PandaBase: This is where we define the most fundamental code shared throughout the core
2324     //             functionality. This includes our main data storage, constants and data types, plus
2325     //             internal functions for managing these items.
2326     //
2327     //      - PandaAccessControl: This contract manages the various addresses and constraints for operations
2328     //             that can be executed only by specific roles. Namely CEO, CFO and COO.
2329     //
2330     //      - PandaOwnership: This provides the methods required for basic non-fungible token
2331     //             transactions, following the draft ERC-721 spec (https://github.com/ethereum/EIPs/issues/721).
2332     //
2333     //      - PandaBreeding: This file contains the methods necessary to breed cats together, including
2334     //             keeping track of siring offers, and relies on an external genetic combination contract.
2335     //
2336     //      - PandaAuctions: Here we have the public methods for auctioning or bidding on cats or siring
2337     //             services. The actual auction functionality is handled in two sibling contracts (one
2338     //             for sales and one for siring), while auction creation and bidding is mostly mediated
2339     //             through this facet of the core contract.
2340     //
2341     //      - PandaMinting: This final facet contains the functionality we use for creating new gen0 cats.
2342     //             the community is new), and all others can only be created and then immediately put up
2343     //             for auction via an algorithmically determined starting price. Regardless of how they
2344     //             are created, there is a hard limit of 50k gen0 cats. After that, it's all up to the
2345     //             community to breed, breed, breed!
2346 
2347     // Set in case the core contract is broken and an upgrade is required
2348     address public newContractAddress;
2349 
2350 
2351     /// @notice Creates the main CryptoPandas smart contract instance.
2352     function PandaCore() public {
2353         // Starts paused.
2354         paused = true;
2355 
2356         // the creator of the contract is the initial CEO
2357         ceoAddress = msg.sender;
2358 
2359         // the creator of the contract is also the initial COO
2360         cooAddress = msg.sender;
2361 
2362         // move these code to init(), so we not excceed gas limit
2363         //uint256[2] memory _genes = [uint256(-1),uint256(-1)];
2364 
2365         //wizzPandaQuota[1] = 100;
2366 
2367         //_createPanda(0, 0, 0, _genes, address(0));
2368     }
2369 
2370     /// init contract
2371     function init() external onlyCEO whenPaused {
2372         // make sure init() only run once
2373         require(pandas.length == 0);
2374         // start with the mythical kitten 0 - so we don't have generation-0 parent issues
2375         uint256[2] memory _genes = [uint256(-1),uint256(-1)];
2376 
2377         wizzPandaQuota[1] = 100;
2378        _createPanda(0, 0, 0, _genes, address(0));
2379     }
2380 
2381     /// @dev Used to mark the smart contract as upgraded, in case there is a serious
2382     ///  breaking bug. This method does nothing but keep track of the new contract and
2383     ///  emit a message indicating that the new address is set. It's up to clients of this
2384     ///  contract to update to the new contract address in that case. (This contract will
2385     ///  be paused indefinitely if such an upgrade takes place.)
2386     /// @param _v2Address new address
2387     function setNewAddress(address _v2Address) external onlyCEO whenPaused {
2388         // See README.md for updgrade plan
2389         newContractAddress = _v2Address;
2390         ContractUpgrade(_v2Address);
2391     }
2392     
2393 
2394     /// @notice No tipping!
2395     /// @dev Reject all Ether from being sent here, unless it's from one of the
2396     ///  two auction contracts. (Hopefully, we can prevent user accidents.)
2397     function() external payable {
2398         require(
2399             msg.sender == address(saleAuction) ||
2400             msg.sender == address(siringAuction)
2401         );
2402     }
2403 
2404     /// @notice Returns all the relevant information about a specific panda.
2405     /// @param _id The ID of the panda of interest.
2406     function getPanda(uint256 _id)
2407         external
2408         view
2409         returns (
2410         bool isGestating,
2411         bool isReady,
2412         uint256 cooldownIndex,
2413         uint256 nextActionAt,
2414         uint256 siringWithId,
2415         uint256 birthTime,
2416         uint256 matronId,
2417         uint256 sireId,
2418         uint256 generation,
2419         uint256[2] genes
2420     ) {
2421         Panda storage kit = pandas[_id];
2422 
2423         // if this variable is 0 then it's not gestating
2424         isGestating = (kit.siringWithId != 0);
2425         isReady = (kit.cooldownEndBlock <= block.number);
2426         cooldownIndex = uint256(kit.cooldownIndex);
2427         nextActionAt = uint256(kit.cooldownEndBlock);
2428         siringWithId = uint256(kit.siringWithId);
2429         birthTime = uint256(kit.birthTime);
2430         matronId = uint256(kit.matronId);
2431         sireId = uint256(kit.sireId);
2432         generation = uint256(kit.generation);
2433         genes = kit.genes;
2434     }
2435 
2436     /// @dev Override unpause so it requires all external contract addresses
2437     ///  to be set before contract can be unpaused. Also, we can't have
2438     ///  newContractAddress set either, because then the contract was upgraded.
2439     /// @notice This is public rather than external so we can call super.unpause
2440     ///  without using an expensive CALL.
2441     function unpause() public onlyCEO whenPaused {
2442         require(saleAuction != address(0));
2443         require(siringAuction != address(0));
2444         require(geneScience != address(0));
2445         require(newContractAddress == address(0));
2446 
2447         // Actually unpause the contract.
2448         super.unpause();
2449     }
2450 
2451     // @dev Allows the CFO to capture the balance available to the contract.
2452     function withdrawBalance() external onlyCFO {
2453         uint256 balance = this.balance;
2454         // Subtract all the currently pregnant kittens we have, plus 1 of margin.
2455         uint256 subtractFees = (pregnantPandas + 1) * autoBirthFee;
2456 
2457         if (balance > subtractFees) {
2458             cfoAddress.send(balance - subtractFees);
2459         }
2460     }
2461 }