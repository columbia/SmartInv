1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11   /**
12    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13    * account.
14    */
15     function Ownable() public {
16         owner = msg.sender;
17     }
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22     modifier onlyOwner() {
23         require(msg.sender == owner);
24         _;
25     }
26 
27   /**
28    * @dev Allows the current owner to transfer control of the contract to a newOwner.
29    * @param newOwner The address to transfer ownership to.
30    */
31     function transferOwnership(address newOwner) public onlyOwner {
32         if (newOwner != address(0)) {
33             owner = newOwner;
34         }
35     }
36 }
37 
38 
39 
40 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
41 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
42 contract ERC721 {
43     // Required methods
44     function totalSupply() public view returns (uint256 total);
45     function balanceOf(address _owner) public view returns (uint256 balance);
46     function ownerOf(uint256 _tokenId) external view returns (address owner);
47     function approve(address _to, uint256 _tokenId) external;
48     function transfer(address _to, uint256 _tokenId) external;
49     function transferFrom(address _from, address _to, uint256 _tokenId) external;
50 
51     // Events
52     event Transfer(address from, address to, uint256 tokenId);
53     event Approval(address owner, address approved, uint256 tokenId);
54 
55     // Optional
56     // function name() public view returns (string name);
57     // function symbol() public view returns (string symbol);
58     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
59     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
60 
61     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
62     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
63 }
64 
65 
66 // // Auction wrapper functions
67 
68 
69 // Auction wrapper functions
70 
71 
72 
73 
74 
75 
76 
77 /// @title SEKRETOOOO
78 contract GeneScienceInterface {
79     /// @dev simply a boolean to indicate this is the contract we expect to be
80     function isGeneScience() public pure returns (bool);
81 
82     /// @dev given genes of kitten 1 & 2, return a genetic combination - may have a random factor
83     /// @param genes1 genes of mom
84     /// @param genes2 genes of sire
85     /// @return the genes that are supposed to be passed down the child
86     function mixGenes(uint256 genes1, uint256 genes2, uint256 targetBlock) public returns (uint256);
87 }
88 
89 
90 
91 contract VariationInterface {
92 
93     function isVariation() public pure returns(bool);
94     
95     function createVariation(uint256 _gene, uint256 _totalSupply) public returns (uint8);
96     
97     function registerVariation(uint256 _dogId, address _owner) public;
98 }
99 
100 
101 contract LotteryInterface {
102     
103     function isLottery() public pure returns (bool);
104 
105     function checkLottery(uint256 genes) public pure returns (uint8 lotclass);
106     
107     function registerLottery(uint256 _dogId) public payable returns (uint8);
108 
109     function getCLottery() 
110         public 
111         view 
112         returns (
113             uint8[7]        luckyGenes1,
114             uint256         totalAmount1,
115             uint256         openBlock1,
116             bool            isReward1,
117             uint256         term1,
118             uint8           currentGenes1,
119             uint256         tSupply,
120             uint256         sPoolAmount1,
121             uint256[]       reward1
122         );
123 }
124 
125 
126 
127 
128 /// @title A facet of KittyCore that manages special access privileges.
129 /// @author Axiom Zen (https://www.axiomzen.co)
130 /// @dev See the KittyCore contract documentation to understand how the various contract facets are arranged.
131 contract DogAccessControl {
132     // This facet controls access control for Cryptodogs. There are four roles managed here:
133     //
134     //     - The CEO: The CEO can reassign other roles and change the addresses of our dependent smart
135     //         contracts. It is also the only role that can unpause the smart contract. It is initially
136     //         set to the address that created the smart contract in the KittyCore constructor.
137     //
138     //     - The CFO: The CFO can withdraw funds from KittyCore and its auction contracts.
139     //
140     //     - The COO: The COO can release gen0 dogs to auction, and mint promo cats.
141     //
142     // It should be noted that these roles are distinct without overlap in their access abilities, the
143     // abilities listed for each role above are exhaustive. In particular, while the CEO can assign any
144     // address to any role, the CEO address itself doesn't have the ability to act in those roles. This
145     // restriction is intentional so that we aren't tempted to use the CEO address frequently out of
146     // convenience. The less we use an address, the less likely it is that we somehow compromise the
147     // account.
148 
149     /// @dev Emited when contract is upgraded - See README.md for updgrade plan
150     event ContractUpgrade(address newContract);
151 
152     // The addresses of the accounts (or contracts) that can execute actions within each roles.
153     address public ceoAddress;
154     address public cfoAddress;
155     address public cooAddress;
156 
157     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
158     bool public paused = false;
159 
160     /// @dev Access modifier for CEO-only functionality
161     modifier onlyCEO() {
162         require(msg.sender == ceoAddress);
163         _;
164     }
165 
166     /// @dev Access modifier for CFO-only functionality
167     modifier onlyCFO() {
168         require(msg.sender == cfoAddress);
169         _;
170     }
171 
172     /// @dev Access modifier for COO-only functionality
173     modifier onlyCOO() {
174         require(msg.sender == cooAddress);
175         _;
176     }
177 
178     modifier onlyCLevel() {
179         require(msg.sender == cooAddress || msg.sender == ceoAddress || msg.sender == cfoAddress);
180         _;
181     }
182 
183     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
184     /// @param _newCEO The address of the new CEO
185     function setCEO(address _newCEO) external onlyCEO {
186         require(_newCEO != address(0));
187 
188         ceoAddress = _newCEO;
189     }
190 
191     /// @dev Assigns a new address to act as the CFO. Only available to the current CEO.
192     /// @param _newCFO The address of the new CFO
193     function setCFO(address _newCFO) external onlyCEO {
194         require(_newCFO != address(0));
195 
196         cfoAddress = _newCFO;
197     }
198 
199     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
200     /// @param _newCOO The address of the new COO
201     function setCOO(address _newCOO) external onlyCEO {
202         require(_newCOO != address(0));
203 
204         cooAddress = _newCOO;
205     }
206 
207     /*** Pausable functionality adapted from OpenZeppelin ***/
208 
209     /// @dev Modifier to allow actions only when the contract IS NOT paused
210     modifier whenNotPaused() {
211         require(!paused);
212         _;
213     }
214 
215     /// @dev Modifier to allow actions only when the contract IS paused
216     modifier whenPaused {
217         require(paused);
218         _;
219     }
220 
221     /// @dev Called by any "C-level" role to pause the contract. Used only when
222     ///  a bug or exploit is detected and we need to limit damage.
223     function pause() external onlyCLevel whenNotPaused {
224         paused = true;
225     }
226 
227     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
228     ///  one reason we may pause the contract is when CFO or COO accounts are
229     ///  compromised.
230     /// @notice This is public rather than external so it can be called by
231     ///  derived contracts.
232     function unpause() public onlyCEO whenPaused {
233         // can't unpause if contract was upgraded
234         paused = false;
235     }
236 }
237 
238 
239 
240 
241 /// @title Base contract for Cryptodogs. Holds all common structs, events and base variables.
242 /// @author Axiom Zen (https://www.axiomzen.co)
243 /// @dev See the KittyCore contract documentation to understand how the various contract facets are arranged.
244 contract DogBase is DogAccessControl {
245     /*** EVENTS ***/
246 
247     /// @dev The Birth event is fired whenever a new kitten comes into existence. This obviously
248     ///  includes any time a cat is created through the giveBirth method, but it is also called
249     ///  when a new gen0 cat is created.
250     event Birth(address owner, uint256 dogId, uint256 matronId, uint256 sireId, uint256 genes, uint16 generation, uint8 variation, uint256 gen0, uint256 birthTime, uint256 income, uint16 cooldownIndex);
251 
252     /// @dev Transfer event as defined in current draft of ERC721. Emitted every time a kitten
253     ///  ownership is assigned, including births.
254     event Transfer(address from, address to, uint256 tokenId);
255 
256     /*** DATA TYPES ***/
257 
258     /// @dev The main Dog struct. Every cat in Cryptodogs is represented by a copy
259     ///  of this structure, so great care was taken to ensure that it fits neatly into
260     ///  exactly two 256-bit words. Note that the order of the members in this structure
261     ///  is important because of the byte-packing rules used by Ethereum.
262     ///  Ref: http://solidity.readthedocs.io/en/develop/miscellaneous.html
263     struct Dog {
264         // The Dog's genetic code is packed into these 256-bits, the format is
265         // sooper-sekret! A cat's genes never change.
266         uint256 genes;
267 
268         // The timestamp from the block when this cat came into existence.
269         uint256 birthTime;
270 
271         // The minimum timestamp after which this cat can engage in breeding
272         // activities again. This same timestamp is used for the pregnancy
273         // timer (for matrons) as well as the siring cooldown.
274         uint64 cooldownEndBlock;
275 
276         // The ID of the parents of this Dog, set to 0 for gen0 cats.
277         // Note that using 32-bit unsigned integers limits us to a "mere"
278         // 4 billion cats. This number might seem small until you realize
279         // that Ethereum currently has a limit of about 500 million
280         // transactions per year! So, this definitely won't be a problem
281         // for several years (even as Ethereum learns to scale).
282         uint32 matronId;
283         uint32 sireId;
284 
285         // Set to the ID of the sire cat for matrons that are pregnant,
286         // zero otherwise. A non-zero value here is how we know a cat
287         // is pregnant. Used to retrieve the genetic material for the new
288         // kitten when the birth transpires.
289         uint32 siringWithId;
290 
291         // Set to the index in the cooldown array (see below) that represents
292         // the current cooldown duration for this Dog. This starts at zero
293         // for gen0 cats, and is initialized to floor(generation/2) for others.
294         // Incremented by one for each successful breeding action, regardless
295         // of whether this cat is acting as matron or sire.
296         uint16 cooldownIndex;
297 
298         // The "generation number" of this cat. Cats minted by the CK contract
299         // for sale are called "gen0" and have a generation number of 0. The
300         // generation number of all other cats is the larger of the two generation
301         // numbers of their parents, plus one.
302         // (i.e. max(matron.generation, sire.generation) + 1)
303         uint16 generation;
304 
305         //zhangyong
306         //变异系数
307         uint8  variation;
308 
309         //zhangyong
310         //0代狗祖先
311         uint256 gen0;
312     }
313 
314     /*** CONSTANTS ***/
315 
316     /// @dev A lookup table indicating the cooldown duration after any successful
317     ///  breeding action, called "pregnancy time" for matrons and "siring cooldown"
318     ///  for sires. Designed such that the cooldown roughly doubles each time a cat
319     ///  is bred, encouraging owners not to just keep breeding the same cat over
320     ///  and over again. Caps out at one week (a cat can breed an unbounded number
321     ///  of times, and the maximum cooldown is always seven days).
322     uint32[14] public cooldowns = [
323         uint32(1 minutes),
324         uint32(2 minutes),
325         uint32(5 minutes),
326         uint32(10 minutes),
327         uint32(30 minutes),
328         uint32(1 hours),
329         uint32(2 hours),
330         uint32(4 hours),
331         uint32(8 hours),
332         uint32(16 hours),
333         uint32(24 hours),
334         uint32(2 days),
335         uint32(3 days),
336         uint32(5 days)
337     ];
338 
339     // An approximation of currently how many seconds are in between blocks.
340     uint256 public secondsPerBlock = 15;
341 
342     /*** STORAGE ***/
343 
344     /// @dev An array containing the Dog struct for all dogs in existence. The ID
345     ///  of each cat is actually an index into this array. Note that ID 0 is a negacat,
346     ///  the unKitty, the mythical beast that is the parent of all gen0 cats. A bizarre
347     ///  creature that is both matron and sire... to itself! Has an invalid genetic code.
348     ///  In other words, cat ID 0 is invalid... ;-)
349     Dog[] dogs;
350 
351     /// @dev A mapping from cat IDs to the address that owns them. All cats have
352     ///  some valid owner address, even gen0 cats are created with a non-zero owner.
353     mapping (uint256 => address) dogIndexToOwner;
354 
355     // @dev A mapping from owner address to count of tokens that address owns.
356     //  Used internally inside balanceOf() to resolve ownership count.
357     mapping (address => uint256) ownershipTokenCount;
358 
359     /// @dev A mapping from KittyIDs to an address that has been approved to call
360     ///  transferFrom(). Each Dog can only have one approved address for transfer
361     ///  at any time. A zero value means no approval is outstanding.
362     mapping (uint256 => address) public dogIndexToApproved;
363 
364     /// @dev A mapping from KittyIDs to an address that has been approved to use
365     ///  this Dog for siring via breedWith(). Each Dog can only have one approved
366     ///  address for siring at any time. A zero value means no approval is outstanding.
367     mapping (uint256 => address) public sireAllowedToAddress;
368 
369     /// @dev The address of the ClockAuction contract that handles sales of dogs. This
370     ///  same contract handles both peer-to-peer sales as well as the gen0 sales which are
371     ///  initiated every 15 minutes.
372     SaleClockAuction public saleAuction;
373 
374     /// @dev The address of a custom ClockAuction subclassed contract that handles siring
375     ///  auctions. Needs to be separate from saleAuction because the actions taken on success
376     ///  after a sales and siring auction are quite different.
377     SiringClockAuction public siringAuction;
378   
379     uint256 public autoBirthFee = 5000 szabo;
380 
381     //zhangyong
382     //0代狗获取的繁殖收益
383     uint256 public gen0Profit = 500 szabo;
384 
385     //zhangyong
386     //0代狗获取繁殖收益的系数，可以动态调整，取值范围0到100
387     function setGen0Profit(uint256 _value) public onlyCOO{        
388         uint256 ration = _value * 100 / autoBirthFee;
389         require(ration > 0);
390         require(_value <= 100);
391         gen0Profit = _value;
392     }
393 
394     /// @dev Assigns ownership of a specific Dog to an address.
395     function _transfer(address _from, address _to, uint256 _tokenId) internal {
396         // Since the number of kittens is capped to 2^32 we can't overflow this
397         ownershipTokenCount[_to]++;
398         // transfer ownership
399         dogIndexToOwner[_tokenId] = _to;
400         // When creating new kittens _from is 0x0, but we can't account that address.
401         if (_from != address(0)) {
402             ownershipTokenCount[_from]--;
403             // once the kitten is transferred also clear sire allowances
404             delete sireAllowedToAddress[_tokenId];
405             // clear any previously approved ownership exchange
406             delete dogIndexToApproved[_tokenId];
407         }
408 
409         // Emit the transfer event.
410         Transfer(_from, _to, _tokenId);
411     }
412 
413     /// @dev An internal method that creates a new Dog and stores it. This
414     ///  method doesn't do any checking and should only be called when the
415     ///  input data is known to be valid. Will generate both a Birth event
416     ///  and a Transfer event.
417     /// @param _matronId The Dog ID of the matron of this cat (zero for gen0)
418     /// @param _sireId The Dog ID of the sire of this cat (zero for gen0)
419     /// @param _generation The generation number of this cat, must be computed by caller.
420     /// @param _genes The Dog's genetic code.
421     /// @param _owner The inital owner of this cat, must be non-zero (except for the unKitty, ID 0)
422     //zhangyong
423     //增加变异系数与0代狗祖先作为参数
424     function _createDog(
425         uint256 _matronId,
426         uint256 _sireId,
427         uint256 _generation,
428         uint256 _genes,
429         address _owner,
430         uint8 _variation,
431         uint256 _gen0,
432         bool _isGen0Siring
433     )
434         internal
435         returns (uint)
436     {
437         // These requires are not strictly necessary, our calling code should make
438         // sure that these conditions are never broken. However! _createDog() is already
439         // an expensive call (for storage), and it doesn't hurt to be especially careful
440         // to ensure our data structures are always valid.
441         require(_matronId == uint256(uint32(_matronId)));
442         require(_sireId == uint256(uint32(_sireId)));
443         require(_generation == uint256(uint16(_generation)));
444 
445         // New Dog starts with the same cooldown as parent gen/2
446         uint16 cooldownIndex = uint16(_generation / 2);
447         if (cooldownIndex > 13) {
448             cooldownIndex = 13;
449         }
450 
451         Dog memory _dog = Dog({
452             genes: _genes,
453             birthTime: block.number,
454             cooldownEndBlock: 0,
455             matronId: uint32(_matronId),
456             sireId: uint32(_sireId),
457             siringWithId: 0,
458             cooldownIndex: cooldownIndex,
459             generation: uint16(_generation),
460             variation : uint8(_variation),
461             gen0 : _gen0
462         });
463         uint256 newDogId = dogs.push(_dog) - 1;
464 
465         // It's probably never going to happen, 4 billion cats is A LOT, but
466         // let's just be 100% sure we never let this happen.
467         // require(newDogId == uint256(uint32(newDogId)));
468         require(newDogId < 23887872);
469 
470         // emit the birth event
471         Birth(
472             _owner,
473             newDogId,
474             uint256(_dog.matronId),
475             uint256(_dog.sireId),
476             _dog.genes,
477             uint16(_generation),
478             _variation,
479             _gen0,
480             block.number,
481             _isGen0Siring ? 0 : gen0Profit,
482             cooldownIndex
483         );
484 
485         // This will assign ownership, and also emit the Transfer event as
486         // per ERC721 draft
487         _transfer(0, _owner, newDogId);
488 
489         return newDogId;
490     }
491 
492     // Any C-level can fix how many seconds per blocks are currently observed.
493     function setSecondsPerBlock(uint256 secs) external onlyCLevel {
494         require(secs < cooldowns[0]);
495         secondsPerBlock = secs;
496     }
497 }
498 
499 
500 
501 
502 
503 /// @title The external contract that is responsible for generating metadata for the dogs,
504 ///  it has one function that will return the data as bytes.
505 // contract ERC721Metadata {
506 //     /// @dev Given a token Id, returns a byte array that is supposed to be converted into string.
507 //     function getMetadata(uint256 _tokenId, string) public view returns (bytes32[4] buffer, uint256 count) {
508 //         if (_tokenId == 1) {
509 //             buffer[0] = "Hello World! :D";
510 //             count = 15;
511 //         } else if (_tokenId == 2) {
512 //             buffer[0] = "I would definitely choose a medi";
513 //             buffer[1] = "um length string.";
514 //             count = 49;
515 //         } else if (_tokenId == 3) {
516 //             buffer[0] = "Lorem ipsum dolor sit amet, mi e";
517 //             buffer[1] = "st accumsan dapibus augue lorem,";
518 //             buffer[2] = " tristique vestibulum id, libero";
519 //             buffer[3] = " suscipit varius sapien aliquam.";
520 //             count = 128;
521 //         }
522 //     }
523 // }
524 
525 
526 /// @title The facet of the Cryptodogs core contract that manages ownership, ERC-721 (draft) compliant.
527 /// @author Axiom Zen (https://www.axiomzen.co)
528 /// @dev Ref: https://github.com/ethereum/EIPs/issues/721
529 ///  See the KittyCore contract documentation to understand how the various contract facets are arranged.
530 contract DogOwnership is DogBase, ERC721 {
531 
532     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
533     string public constant name = "HelloDog";
534     string public constant symbol = "HD";
535 
536     // The contract that will return Dog metadata
537     // ERC721Metadata public erc721Metadata;
538 
539     bytes4 constant InterfaceSignature_ERC165 = bytes4(keccak256("supportsInterface(bytes4)"));
540 
541     bytes4 constant InterfaceSignature_ERC721 =
542         bytes4(keccak256("name()")) ^
543         bytes4(keccak256("symbol()")) ^
544         bytes4(keccak256("totalSupply()")) ^
545         bytes4(keccak256("balanceOf(address)")) ^
546         bytes4(keccak256("ownerOf(uint256)")) ^
547         bytes4(keccak256("approve(address,uint256)")) ^
548         bytes4(keccak256("transfer(address,uint256)")) ^
549     bytes4(keccak256("transferFrom(address,address,uint256)"));
550         // bytes4(keccak256("tokensOfOwner(address)")) ^
551         // bytes4(keccak256("tokenMetadata(uint256,string)"));
552 
553     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
554     ///  Returns true for any standardized interfaces implemented by this contract. We implement
555     ///  ERC-165 (obviously!) and ERC-721.
556     function supportsInterface(bytes4 _interfaceID) external view returns (bool)
557     {
558         // DEBUG ONLY
559         //require((InterfaceSignature_ERC165 == 0x01ffc9a7) && (InterfaceSignature_ERC721 == 0x9a20483d));
560 
561         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
562     }
563 
564     /// @dev Set the address of the sibling contract that tracks metadata.
565     ///  CEO only.
566     // function setMetadataAddress(address _contractAddress) public onlyCEO {
567     //     erc721Metadata = ERC721Metadata(_contractAddress);
568     // }
569 
570     // Internal utility functions: These functions all assume that their input arguments
571     // are valid. We leave it to public methods to sanitize their inputs and follow
572     // the required logic.
573 
574     /// @dev Checks if a given address is the current owner of a particular Dog.
575     /// @param _claimant the address we are validating against.
576     /// @param _tokenId kitten id, only valid when > 0
577     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
578         return dogIndexToOwner[_tokenId] == _claimant;
579     }
580 
581     /// @dev Checks if a given address currently has transferApproval for a particular Dog.
582     /// @param _claimant the address we are confirming kitten is approved for.
583     /// @param _tokenId kitten id, only valid when > 0
584     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
585         return dogIndexToApproved[_tokenId] == _claimant;
586     }
587 
588     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
589     ///  approval. Setting _approved to address(0) clears all transfer approval.
590     ///  NOTE: _approve() does NOT send the Approval event. This is intentional because
591     ///  _approve() and transferFrom() are used together for putting dogs on auction, and
592     ///  there is no value in spamming the log with Approval events in that case.
593     function _approve(uint256 _tokenId, address _approved) internal {
594         dogIndexToApproved[_tokenId] = _approved;
595     }
596 
597     /// @notice Returns the number of dogs owned by a specific address.
598     /// @param _owner The owner address to check.
599     /// @dev Required for ERC-721 compliance
600     function balanceOf(address _owner) public view returns (uint256 count) {
601         return ownershipTokenCount[_owner];
602     }
603 
604     /// @notice Transfers a Dog to another address. If transferring to a smart
605     ///  contract be VERY CAREFUL to ensure that it is aware of ERC-721 (or
606     ///  Cryptodogs specifically) or your Dog may be lost forever. Seriously.
607     /// @param _to The address of the recipient, can be a user or contract.
608     /// @param _tokenId The ID of the Dog to transfer.
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
620         // The contract should never own any dogs (except very briefly
621         // after a gen0 cat is created and before it goes on auction).
622         require(_to != address(this));
623         // Disallow transfers to the auction contracts to prevent accidental
624         // misuse. Auction contracts should only take ownership of dogs
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
636     /// @notice Grant another address the right to transfer a specific Dog via
637     ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
638     /// @param _to The address to be granted transfer approval. Pass address(0) to
639     ///  clear all approvals.
640     /// @param _tokenId The ID of the Dog that can be transferred if this call succeeds.
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
659     /// @notice Transfer a Dog owned by another address, for which the calling address
660     ///  has previously been granted transfer approval by the owner.
661     /// @param _from The address that owns the Dog to be transfered.
662     /// @param _to The address that should take ownership of the Dog. Can be any address,
663     ///  including the caller.
664     /// @param _tokenId The ID of the Dog to be transferred.
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
677         // The contract should never own any dogs (except very briefly
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
688     /// @notice Returns the total number of dogs currently in existence.
689     /// @dev Required for ERC-721 compliance.
690     function totalSupply() public view returns (uint) {
691         return dogs.length - 1;
692     }
693 
694     /// @notice Returns the address currently assigned ownership of a given Dog.
695     /// @dev Required for ERC-721 compliance.
696     function ownerOf(uint256 _tokenId)
697         external
698         view
699         returns (address owner)
700     {
701         owner = dogIndexToOwner[_tokenId];
702 
703         require(owner != address(0));
704     }
705 
706     /// @notice Returns a list of all Dog IDs assigned to an address.
707     /// @param _owner The owner whose dogs we are interested in.
708     /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
709     ///  expensive (it walks the entire Dog array looking for cats belonging to owner),
710     ///  but it also returns a dynamic array, which is only supported for web3 calls, and
711     ///  not contract-to-contract calls.
712     // function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
713     //     uint256 tokenCount = balanceOf(_owner);
714 
715     //     if (tokenCount == 0) {
716     //         // Return an empty array
717     //         return new uint256[](0);
718     //     } else {
719     //         uint256[] memory result = new uint256[](tokenCount);
720     //         uint256 totalCats = totalSupply();
721     //         uint256 resultIndex = 0;
722 
723     //         // We count on the fact that all cats have IDs starting at 1 and increasing
724     //         // sequentially up to the totalCat count.
725     //         uint256 catId;
726 
727     //         for (catId = 1; catId <= totalCats; catId++) {
728     //             if (dogIndexToOwner[catId] == _owner) {
729     //                 result[resultIndex] = catId;
730     //                 resultIndex++;
731     //             }
732     //         }
733 
734     //         return result;
735     //     }
736     // }
737 
738     /// @dev Adapted from memcpy() by @arachnid (Nick Johnson <arachnid@notdot.net>)
739     ///  This method is licenced under the Apache License.
740     ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
741     // function _memcpy(uint _dest, uint _src, uint _len) private view {
742     //     // Copy word-length chunks while possible
743     //     for(; _len >= 32; _len -= 32) {
744     //         assembly {
745     //             mstore(_dest, mload(_src))
746     //         }
747     //         _dest += 32;
748     //         _src += 32;
749     //     }
750 
751     //     // Copy remaining bytes
752     //     uint256 mask = 256 ** (32 - _len) - 1;
753     //     assembly {
754     //         let srcpart := and(mload(_src), not(mask))
755     //         let destpart := and(mload(_dest), mask)
756     //         mstore(_dest, or(destpart, srcpart))
757     //     }
758     // }
759 
760     /// @dev Adapted from toString(slice) by @arachnid (Nick Johnson <arachnid@notdot.net>)
761     ///  This method is licenced under the Apache License.
762     ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
763     // function _toString(bytes32[4] _rawBytes, uint256 _stringLength) private view returns (string) {
764     //     var outputString = new string(_stringLength);
765     //     uint256 outputPtr;
766     //     uint256 bytesPtr;
767 
768     //     assembly {
769     //         outputPtr := add(outputString, 32)
770     //         bytesPtr := _rawBytes
771     //     }
772 
773     //     _memcpy(outputPtr, bytesPtr, _stringLength);
774 
775     //     return outputString;
776     // }
777 
778     /// @notice Returns a URI pointing to a metadata package for this token conforming to
779     ///  ERC-721 (https://github.com/ethereum/EIPs/issues/721)
780     /// @param _tokenId The ID number of the Dog whose metadata should be returned.
781     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) external view returns (string infoUrl) {
782     //     require(erc721Metadata != address(0));
783     //     bytes32[4] memory buffer;
784     //     uint256 count;
785     //     (buffer, count) = erc721Metadata.getMetadata(_tokenId, _preferredTransport);
786 
787     //     return _toString(buffer, count);
788     // }
789 }
790 
791 
792 
793 /// @title A facet of KittyCore that manages Dog siring, gestation, and birth.
794 /// @author Axiom Zen (https://www.axiomzen.co)
795 /// @dev See the KittyCore contract documentation to understand how the various contract facets are arranged.
796 contract DogBreeding is DogOwnership {
797 
798     /// @dev The Pregnant event is fired when two cats successfully breed and the pregnancy
799     ///  timer begins for the matron.
800     event Pregnant(address owner, uint256 matronId, uint256 sireId, uint256 matronCooldownEndBlock, uint256 sireCooldownEndBlock, uint256 matronCooldownIndex, uint256 sireCooldownIndex);
801 
802     /// @notice The minimum payment required to use breedWithAuto(). This fee goes towards
803     ///  the gas cost paid by whatever calls giveBirth(), and can be dynamically updated by
804     ///  the COO role as the gas price changes.
805     // uint256 public autoBirthFee = 2 finney;
806 
807     // Keeps track of number of pregnant dogs.
808     uint256 public pregnantDogs;
809 
810     /// @dev The address of the sibling contract that is used to implement the sooper-sekret
811     ///  genetic combination algorithm.
812     GeneScienceInterface public geneScience;
813     
814     VariationInterface public variation;
815 
816     LotteryInterface public lottery;
817 
818     /// @dev Update the address of the genetic contract, can only be called by the CEO.
819     /// @param _address An address of a GeneScience contract instance to be used from this point forward.
820     function setGeneScienceAddress(address _address) external onlyCEO {
821         GeneScienceInterface candidateContract = GeneScienceInterface(_address);
822 
823         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
824         require(candidateContract.isGeneScience());
825 
826         // Set the new contract address
827         geneScience = candidateContract;
828     }
829 
830     /// @dev Checks that a given kitten is able to breed. Requires that the
831     ///  current cooldown is finished (for sires) and also checks that there is
832     ///  no pending pregnancy.
833     function _isReadyToBreed(Dog _dog) internal view returns (bool) {
834         // In addition to checking the cooldownEndBlock, we also need to check to see if
835         // the cat has a pending birth; there can be some period of time between the end
836         // of the pregnacy timer and the birth event.
837         return (_dog.siringWithId == 0) && (_dog.cooldownEndBlock <= uint64(block.number));
838     }
839 
840     /// @dev Check if a sire has authorized breeding with this matron. True if both sire
841     ///  and matron have the same owner, or if the sire has given siring permission to
842     ///  the matron's owner (via approveSiring()).
843     function _isSiringPermitted(uint256 _sireId, uint256 _matronId) internal view returns (bool) {
844         address matronOwner = dogIndexToOwner[_matronId];
845         address sireOwner = dogIndexToOwner[_sireId];
846 
847         // Siring is okay if they have same owner, or if the matron's owner was given
848         // permission to breed with this sire.
849         return (matronOwner == sireOwner || sireAllowedToAddress[_sireId] == matronOwner);
850     }
851 
852     /// @dev Set the cooldownEndTime for the given Dog, based on its current cooldownIndex.
853     ///  Also increments the cooldownIndex (unless it has hit the cap).
854     /// @param _dog A reference to the Dog in storage which needs its timer started.
855     function _triggerCooldown(Dog storage _dog) internal {
856         // Compute an estimation of the cooldown time in blocks (based on current cooldownIndex).
857         _dog.cooldownEndBlock = uint64((cooldowns[_dog.cooldownIndex]/secondsPerBlock) + block.number);
858 
859         // Increment the breeding count, clamping it at 13, which is the length of the
860         // cooldowns array. We could check the array size dynamically, but hard-coding
861         // this as a constant saves gas. Yay, Solidity!
862         if (_dog.cooldownIndex < 13) {
863             _dog.cooldownIndex += 1;
864         }
865     }
866 
867     /// @notice Grants approval to another user to sire with one of your dogs.
868     /// @param _addr The address that will be able to sire with your Dog. Set to
869     ///  address(0) to clear all siring approvals for this Dog.
870     /// @param _sireId A Dog that you own that _addr will now be able to sire with.
871     function approveSiring(address _addr, uint256 _sireId)
872         external
873         whenNotPaused
874     {
875         require(_owns(msg.sender, _sireId));
876         sireAllowedToAddress[_sireId] = _addr;
877     }
878 
879     /// @dev Updates the minimum payment required for calling giveBirthAuto(). Can only
880     ///  be called by the COO address. (This fee is used to offset the gas cost incurred
881     ///  by the autobirth daemon).
882     function setAutoBirthFee(uint256 val) external onlyCOO {
883         require(val > 0);
884         autoBirthFee = val;
885     }
886 
887     /// @dev Checks to see if a given Dog is pregnant and (if so) if the gestation
888     ///  period has passed.
889     function _isReadyToGiveBirth(Dog _matron) private view returns (bool) {
890         return (_matron.siringWithId != 0) && (_matron.cooldownEndBlock <= uint64(block.number));
891     }
892 
893     /// @notice Checks that a given kitten is able to breed (i.e. it is not pregnant or
894     ///  in the middle of a siring cooldown).
895     /// @param _dogId reference the id of the kitten, any user can inquire about it
896     function isReadyToBreed(uint256 _dogId)
897         public
898         view
899         returns (bool)
900     {
901         //zhangyong
902         //创世狗有两只
903         require(_dogId > 1);
904         Dog storage dog = dogs[_dogId];
905         return _isReadyToBreed(dog);
906     }
907 
908     /// @dev Checks whether a Dog is currently pregnant.
909     /// @param _dogId reference the id of the kitten, any user can inquire about it
910     function isPregnant(uint256 _dogId)
911         public
912         view
913         returns (bool)
914     {
915         // A Dog is pregnant if and only if this field is set
916         return dogs[_dogId].siringWithId != 0;
917     }
918 
919     /// @dev Internal check to see if a given sire and matron are a valid mating pair. DOES NOT
920     ///  check ownership permissions (that is up to the caller).
921     /// @param _matron A reference to the Dog struct of the potential matron.
922     /// @param _matronId The matron's ID.
923     /// @param _sire A reference to the Dog struct of the potential sire.
924     /// @param _sireId The sire's ID
925     function _isValidMatingPair(
926         Dog storage _matron,
927         uint256 _matronId,
928         Dog storage _sire,
929         uint256 _sireId
930     )
931         private
932         view
933         returns(bool)
934     {
935         // A Dog can't breed with itself!
936         if (_matronId == _sireId) {
937             return false;
938         }
939 
940         // dogs can't breed with their parents.
941         if (_matron.matronId == _sireId || _matron.sireId == _sireId) {
942             return false;
943         }
944         if (_sire.matronId == _matronId || _sire.sireId == _matronId) {
945             return false;
946         }
947 
948         // We can short circuit the sibling check (below) if either cat is
949         // gen zero (has a matron ID of zero).
950         if (_sire.matronId == 0 || _matron.matronId == 0) {
951             return true;
952         }
953 
954         // dogs can't breed with full or half siblings.
955         if (_sire.matronId == _matron.matronId || _sire.matronId == _matron.sireId) {
956             return false;
957         }
958         if (_sire.sireId == _matron.matronId || _sire.sireId == _matron.sireId) {
959             return false;
960         }
961 
962         // Everything seems cool! Let's get DTF.
963         return true;
964     }
965 
966     /// @dev Internal check to see if a given sire and matron are a valid mating pair for
967     ///  breeding via auction (i.e. skips ownership and siring approval checks).
968     function _canBreedWithViaAuction(uint256 _matronId, uint256 _sireId)
969         internal
970         view
971         returns (bool)
972     {
973         Dog storage matron = dogs[_matronId];
974         Dog storage sire = dogs[_sireId];
975         return _isValidMatingPair(matron, _matronId, sire, _sireId);
976     }
977 
978     // @notice Checks to see if two cats can breed together, including checks for
979     //  ownership and siring approvals. Does NOT check that both cats are ready for
980     //  breeding (i.e. breedWith could still fail until the cooldowns are finished).
981     //  TODO: Shouldn't this check pregnancy and cooldowns?!?
982     // @param _matronId The ID of the proposed matron.
983     // @param _sireId The ID of the proposed sire.
984     // function canBreedWith(uint256 _matronId, uint256 _sireId)
985     //     external
986     //     view
987     //     returns(bool)
988     // {
989     //     require(_matronId > 1);
990     //     require(_sireId > 1);
991     //     Dog storage matron = dogs[_matronId];
992     //     Dog storage sire = dogs[_sireId];
993     //     return _isValidMatingPair(matron, _matronId, sire, _sireId) &&
994     //         _isSiringPermitted(_sireId, _matronId);
995     // }
996 
997     /// @dev Internal utility function to initiate breeding, assumes that all breeding
998     ///  requirements have been checked.
999     function _breedWith(uint256 _matronId, uint256 _sireId) internal {
1000         //zhangyong
1001         //创世狗不能繁殖
1002         require(_matronId > 1);
1003         require(_sireId > 1);
1004         
1005         // Grab a reference to the dogs from storage.
1006         Dog storage sire = dogs[_sireId];
1007         Dog storage matron = dogs[_matronId];
1008 
1009         //zhangyong
1010         //变异狗不能繁殖
1011         require(sire.variation == 0);
1012         require(matron.variation == 0);
1013 
1014         if (matron.generation > 0) {
1015             var(,,openBlock,,,,,,) = lottery.getCLottery();
1016             if (matron.birthTime < openBlock) {
1017                 require(lottery.checkLottery(matron.genes) == 100);
1018             }
1019         }
1020 
1021         // Mark the matron as pregnant, keeping track of who the sire is.
1022         matron.siringWithId = uint32(_sireId);
1023 
1024         // Trigger the cooldown for both parents.
1025         _triggerCooldown(sire);
1026         _triggerCooldown(matron);
1027 
1028         // Clear siring permission for both parents. This may not be strictly necessary
1029         // but it's likely to avoid confusion!
1030         delete sireAllowedToAddress[_matronId];
1031         delete sireAllowedToAddress[_sireId];
1032 
1033         // Every time a Dog gets pregnant, counter is incremented.
1034         pregnantDogs++;
1035 
1036         //zhangyong
1037         //只能由系统接生，接生费转给公司作为开发费用
1038         cfoAddress.transfer(autoBirthFee);
1039 
1040         //zhangyong
1041         //如果母狗是0代狗，那么小狗的祖先就是母狗的ID,否则跟母狗的祖先相同
1042         if (matron.generation > 0) {
1043             dogIndexToOwner[matron.gen0].transfer(gen0Profit);
1044         }
1045 
1046         // Emit the pregnancy event.
1047         Pregnant(dogIndexToOwner[_matronId], _matronId, _sireId, matron.cooldownEndBlock, sire.cooldownEndBlock, matron.cooldownIndex, sire.cooldownIndex);
1048     }
1049 
1050     /// @notice Breed a Dog you own (as matron) with a sire that you own, or for which you
1051     ///  have previously been given Siring approval. Will either make your cat pregnant, or will
1052     ///  fail entirely. Requires a pre-payment of the fee given out to the first caller of giveBirth()
1053     /// @param _matronId The ID of the Dog acting as matron (will end up pregnant if successful)
1054     /// @param _sireId The ID of the Dog acting as sire (will begin its siring cooldown if successful)
1055     function breedWithAuto(uint256 _matronId, uint256 _sireId)
1056         external
1057         payable
1058         whenNotPaused
1059     {        
1060         // zhangyong
1061         // 如果不是0代狗繁殖，则多收0代狗的繁殖收益
1062         uint256 totalFee = autoBirthFee;
1063         Dog storage matron = dogs[_matronId];
1064         if (matron.generation > 0) {
1065             totalFee += gen0Profit;
1066         }
1067 
1068         // Checks for payment.
1069         require(msg.value >= totalFee);
1070 
1071         // Caller must own the matron.
1072         require(_owns(msg.sender, _matronId));
1073 
1074         // Neither sire nor matron are allowed to be on auction during a normal
1075         // breeding operation, but we don't need to check that explicitly.
1076         // For matron: The caller of this function can't be the owner of the matron
1077         //   because the owner of a Dog on auction is the auction house, and the
1078         //   auction house will never call breedWith().
1079         // For sire: Similarly, a sire on auction will be owned by the auction house
1080         //   and the act of transferring ownership will have cleared any oustanding
1081         //   siring approval.
1082         // Thus we don't need to spend gas explicitly checking to see if either cat
1083         // is on auction.
1084 
1085         // Check that matron and sire are both owned by caller, or that the sire
1086         // has given siring permission to caller (i.e. matron's owner).
1087         // Will fail for _sireId = 0
1088         require(_isSiringPermitted(_sireId, _matronId));
1089 
1090         // Grab a reference to the potential matron
1091         // Dog storage matron = dogs[_matronId];
1092 
1093         // Make sure matron isn't pregnant, or in the middle of a siring cooldown
1094         require(_isReadyToBreed(matron));
1095 
1096         // Grab a reference to the potential sire
1097         Dog storage sire = dogs[_sireId];
1098 
1099         // Make sure sire isn't pregnant, or in the middle of a siring cooldown
1100         require(_isReadyToBreed(sire));
1101 
1102         // Test that these cats are a valid mating pair.
1103         require(_isValidMatingPair(matron, _matronId, sire, _sireId));
1104 
1105         // All checks passed, Dog gets pregnant!
1106         _breedWith(_matronId, _sireId);
1107 
1108         // zhangyong
1109         // 多余的费用返还给用户
1110         uint256 breedExcess = msg.value - totalFee;
1111         if (breedExcess > 0) {
1112             msg.sender.transfer(breedExcess);
1113         }
1114     }
1115 
1116     /// @notice Have a pregnant Dog give birth!
1117     /// @param _matronId A Dog ready to give birth.
1118     /// @return The Dog ID of the new kitten.
1119     /// @dev Looks at a given Dog and, if pregnant and if the gestation period has passed,
1120     ///  combines the genes of the two parents to create a new kitten. The new Dog is assigned
1121     ///  to the current owner of the matron. Upon successful completion, both the matron and the
1122     ///  new kitten will be ready to breed again. Note that anyone can call this function (if they
1123     ///  are willing to pay the gas!), but the new kitten always goes to the mother's owner.
1124     //zhangyong
1125     //只能由系统接生，接生费转给公司作为开发费用,同时避免其他人帮助接生后，后台不知如何处理
1126     function giveBirth(uint256 _matronId)
1127         external
1128         whenNotPaused
1129         returns(uint256)
1130     {
1131         // Grab a reference to the matron in storage.
1132         Dog storage matron = dogs[_matronId];
1133 
1134         // Check that the matron is a valid cat.
1135         require(matron.birthTime != 0);
1136 
1137         // Check that the matron is pregnant, and that its time has come!
1138         require(_isReadyToGiveBirth(matron));
1139 
1140         // Grab a reference to the sire in storage.
1141         uint256 sireId = matron.siringWithId;
1142         Dog storage sire = dogs[sireId];
1143 
1144         // Determine the higher generation number of the two parents
1145         uint16 parentGen = matron.generation;
1146         if (sire.generation > matron.generation) {
1147             parentGen = sire.generation;
1148         }
1149 
1150         //zhangyong
1151         //如果母狗是0代狗，那么小狗的祖先就是母狗的ID,否则跟母狗的祖先相同
1152         uint256 gen0 = matron.generation == 0 ? _matronId : matron.gen0;
1153 
1154         // Call the sooper-sekret gene mixing operation.
1155         uint256 childGenes = geneScience.mixGenes(matron.genes, sire.genes, matron.cooldownEndBlock - 1);
1156 
1157         // Make the new kitten!
1158         address owner = dogIndexToOwner[_matronId];
1159 
1160         uint8 _variation = variation.createVariation(childGenes, dogs.length);
1161 
1162         bool isGen0Siring = matron.generation == 0;
1163 
1164         uint256 kittenId = _createDog(_matronId, matron.siringWithId, parentGen + 1, childGenes, owner, _variation, gen0, isGen0Siring);
1165 
1166         // Clear the reference to sire from the matron (REQUIRED! Having siringWithId
1167         // set is what marks a matron as being pregnant.)
1168         delete matron.siringWithId;
1169 
1170         // Every time a Dog gives birth counter is decremented.
1171         pregnantDogs--;
1172 
1173         // Send the balance fee to the person who made birth happen.
1174        
1175         if(_variation != 0){
1176             variation.registerVariation(kittenId, owner);      
1177             _transfer(owner, address(variation), kittenId);
1178         }
1179 
1180         // return the new kitten's ID
1181         return kittenId;
1182     }
1183 }
1184 
1185 
1186 
1187 
1188 /// @title Auction Core
1189 /// @dev Contains models, variables, and internal methods for the auction.
1190 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1191 contract ClockAuctionBase {
1192 
1193     // Represents an auction on an NFT
1194     struct Auction {
1195         // Current owner of NFT
1196         address seller;
1197         // Price (in wei) at beginning of auction
1198         uint128 startingPrice;
1199         // Price (in wei) at end of auction
1200         uint128 endingPrice;
1201         // Duration (in seconds) of auction
1202         uint64 duration;
1203         // Time when auction started
1204         // NOTE: 0 if this auction has been concluded
1205         uint64 startedAt;
1206     }
1207 
1208     // Reference to contract tracking NFT ownership
1209     ERC721 public nonFungibleContract;
1210 
1211     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
1212     // Values 0-10,000 map to 0%-100%
1213     uint256 public ownerCut;
1214 
1215     // Map from token ID to their corresponding auction.
1216     mapping (uint256 => Auction) tokenIdToAuction;
1217 
1218     event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
1219     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
1220     event AuctionCancelled(uint256 tokenId);
1221 
1222     /// @dev Returns true if the claimant owns the token.
1223     /// @param _claimant - Address claiming to own the token.
1224     /// @param _tokenId - ID of token whose ownership to verify.
1225     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
1226         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
1227     }
1228 
1229     /// @dev Escrows the NFT, assigning ownership to this contract.
1230     /// Throws if the escrow fails.
1231     /// @param _owner - Current owner address of token to escrow.
1232     /// @param _tokenId - ID of token whose approval to verify.
1233     function _escrow(address _owner, uint256 _tokenId) internal {
1234         // it will throw if transfer fails
1235         nonFungibleContract.transferFrom(_owner, this, _tokenId);
1236     }
1237 
1238     /// @dev Transfers an NFT owned by this contract to another address.
1239     /// Returns true if the transfer succeeds.
1240     /// @param _receiver - Address to transfer NFT to.
1241     /// @param _tokenId - ID of token to transfer.
1242     function _transfer(address _receiver, uint256 _tokenId) internal {
1243         // it will throw if transfer fails
1244         nonFungibleContract.transfer(_receiver, _tokenId);
1245     }
1246 
1247     /// @dev Adds an auction to the list of open auctions. Also fires the
1248     ///  AuctionCreated event.
1249     /// @param _tokenId The ID of the token to be put on auction.
1250     /// @param _auction Auction to add.
1251     function _addAuction(uint256 _tokenId, Auction _auction) internal {
1252         // Require that all auctions have a duration of
1253         // at least one minute. (Keeps our math from getting hairy!)
1254         require(_auction.duration >= 1 minutes);
1255 
1256         tokenIdToAuction[_tokenId] = _auction;
1257 
1258         AuctionCreated(
1259             uint256(_tokenId),
1260             uint256(_auction.startingPrice),
1261             uint256(_auction.endingPrice),
1262             uint256(_auction.duration)
1263         );
1264     }
1265 
1266     /// @dev Cancels an auction unconditionally.
1267     function _cancelAuction(uint256 _tokenId, address _seller) internal {
1268         _removeAuction(_tokenId);
1269         _transfer(_seller, _tokenId);
1270         AuctionCancelled(_tokenId);
1271     }
1272 
1273     /// @dev Computes the price and transfers winnings.
1274     /// Does NOT transfer ownership of token.
1275     function _bid(uint256 _tokenId, uint256 _bidAmount, address _to)
1276         internal
1277         returns (uint256)
1278     {
1279         // Get a reference to the auction struct
1280         Auction storage auction = tokenIdToAuction[_tokenId];
1281 
1282         // Explicitly check that this auction is currently live.
1283         // (Because of how Ethereum mappings work, we can't just count
1284         // on the lookup above failing. An invalid _tokenId will just
1285         // return an auction object that is all zeros.)
1286         require(_isOnAuction(auction));
1287 
1288         // Check that the bid is greater than or equal to the current price
1289         uint256 price = _currentPrice(auction);
1290         uint256 auctioneerCut = computeCut(price);
1291 
1292         //zhangyong
1293         //两只创世狗每次交易需要收取10%的手续费
1294         //创世狗无法繁殖，所以只有创世狗交易才会进入到这个方法
1295         uint256 fee = 0;
1296         if (_tokenId == 0 || _tokenId == 1) {
1297             fee = price / 5;
1298         }        
1299         require((_bidAmount + auctioneerCut + fee) >= price);
1300 
1301         // Grab a reference to the seller before the auction struct
1302         // gets deleted.
1303         address seller = auction.seller;
1304 
1305         // The bid is good! Remove the auction before sending the fees
1306         // to the sender so we can't have a reentrancy attack.
1307         _removeAuction(_tokenId);
1308 
1309         // Transfer proceeds to seller (if there are any!)
1310         if (price > 0) {
1311             // Calculate the auctioneer's cut.
1312             // (NOTE: _computeCut() is guaranteed to return a
1313             // value <= price, so this subtraction can't go negative.)
1314             uint256 sellerProceeds = price - auctioneerCut - fee;
1315 
1316             // NOTE: Doing a transfer() in the middle of a complex
1317             // method like this is generally discouraged because of
1318             // reentrancy attacks and DoS attacks if the seller is
1319             // a contract with an invalid fallback function. We explicitly
1320             // guard against reentrancy attacks by removing the auction
1321             // before calling transfer(), and the only thing the seller
1322             // can DoS is the sale of their own asset! (And if it's an
1323             // accident, they can call cancelAuction(). )
1324             seller.transfer(sellerProceeds);
1325         }
1326 
1327         // Calculate any excess funds included with the bid. If the excess
1328         // is anything worth worrying about, transfer it back to bidder.
1329         // NOTE: We checked above that the bid amount is greater than or
1330         // equal to the price so this cannot underflow.
1331         // zhangyong
1332         // _bidAmount在进入这个方法之前已经扣掉了fee，所以买者需要加上这笔费用才等于开始出价
1333         // uint256 bidExcess = _bidAmount + fee - price;
1334 
1335         // Return the funds. Similar to the previous transfer, this is
1336         // not susceptible to a re-entry attack because the auction is
1337         // removed before any transfers occur.
1338         // zhangyong
1339         // msg.sender是主合约地址，并不是出价人的地址
1340         // msg.sender.transfer(bidExcess);
1341 
1342         // Tell the world!
1343         AuctionSuccessful(_tokenId, price, _to);
1344 
1345         return price;
1346     }
1347 
1348     /// @dev Removes an auction from the list of open auctions.
1349     /// @param _tokenId - ID of NFT on auction.
1350     function _removeAuction(uint256 _tokenId) internal {
1351         delete tokenIdToAuction[_tokenId];
1352     }
1353 
1354     /// @dev Returns true if the NFT is on auction.
1355     /// @param _auction - Auction to check.
1356     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
1357         return (_auction.startedAt > 0);
1358     }
1359 
1360     /// @dev Returns current price of an NFT on auction. Broken into two
1361     ///  functions (this one, that computes the duration from the auction
1362     ///  structure, and the other that does the price computation) so we
1363     ///  can easily test that the price computation works correctly.
1364     function _currentPrice(Auction storage _auction)
1365         internal
1366         view
1367         returns (uint256)
1368     {
1369         uint256 secondsPassed = 0;
1370 
1371         // A bit of insurance against negative values (or wraparound).
1372         // Probably not necessary (since Ethereum guarnatees that the
1373         // now variable doesn't ever go backwards).
1374         if (now > _auction.startedAt) {
1375             secondsPassed = now - _auction.startedAt;
1376         }
1377 
1378         return _computeCurrentPrice(
1379             _auction.startingPrice,
1380             _auction.endingPrice,
1381             _auction.duration,
1382             secondsPassed
1383         );
1384     }
1385 
1386     /// @dev Computes the current price of an auction. Factored out
1387     ///  from _currentPrice so we can run extensive unit tests.
1388     ///  When testing, make this function public and turn on
1389     ///  `Current price computation` test suite.
1390     function _computeCurrentPrice(
1391         uint256 _startingPrice,
1392         uint256 _endingPrice,
1393         uint256 _duration,
1394         uint256 _secondsPassed
1395     )
1396         internal
1397         pure
1398         returns (uint256)
1399     {
1400         // NOTE: We don't use SafeMath (or similar) in this function because
1401         //  all of our public functions carefully cap the maximum values for
1402         //  time (at 64-bits) and currency (at 128-bits). _duration is
1403         //  also known to be non-zero (see the require() statement in
1404         //  _addAuction())
1405         if (_secondsPassed >= _duration) {
1406             // We've reached the end of the dynamic pricing portion
1407             // of the auction, just return the end price.
1408             return _endingPrice;
1409         } else {
1410             // Starting price can be higher than ending price (and often is!), so
1411             // this delta can be negative.
1412             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
1413 
1414             // This multiplication can't overflow, _secondsPassed will easily fit within
1415             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
1416             // will always fit within 256-bits.
1417             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
1418 
1419             // currentPriceChange can be negative, but if so, will have a magnitude
1420             // less that _startingPrice. Thus, this result will always end up positive.
1421             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
1422 
1423             return uint256(currentPrice);
1424         }
1425     }
1426 
1427     /// @dev Computes owner's cut of a sale.
1428     /// @param _price - Sale price of NFT.
1429     function computeCut(uint256 _price) public view returns (uint256) {
1430         // NOTE: We don't use SafeMath (or similar) in this function because
1431         //  all of our entry functions carefully cap the maximum values for
1432         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
1433         //  statement in the ClockAuction constructor). The result of this
1434         //  function is always guaranteed to be <= _price.
1435         return _price * ownerCut / 10000;
1436     }
1437 
1438 }
1439 
1440 
1441 
1442 
1443 
1444 
1445 
1446 /**
1447  * @title Pausable
1448  * @dev Base contract which allows children to implement an emergency stop mechanism.
1449  */
1450 contract Pausable is Ownable {
1451     event Pause();
1452     event Unpause();
1453 
1454     bool public paused = false;
1455 
1456 
1457   /**
1458    * @dev modifier to allow actions only when the contract IS paused
1459    */
1460     modifier whenNotPaused() {
1461         require(!paused);
1462         _;
1463     }
1464 
1465   /**
1466    * @dev modifier to allow actions only when the contract IS NOT paused
1467    */
1468     modifier whenPaused {
1469         require(paused);
1470         _;
1471     }
1472 
1473   /**
1474    * @dev called by the owner to pause, triggers stopped state
1475    */
1476     function pause() public onlyOwner whenNotPaused returns (bool) {
1477         paused = true;
1478         Pause();
1479         return true;
1480     }
1481 
1482   /**
1483    * @dev called by the owner to unpause, returns to normal state
1484    */
1485     function unpause() public onlyOwner whenPaused returns (bool) {
1486         paused = false;
1487         Unpause();
1488         return true;
1489     }
1490 }
1491 
1492 
1493 /// @title Clock auction for non-fungible tokens.
1494 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1495 contract ClockAuction is Pausable, ClockAuctionBase {
1496 
1497     /// @dev The ERC-165 interface signature for ERC-721.
1498     ///  Ref: https://github.com/ethereum/EIPs/issues/165
1499     ///  Ref: https://github.com/ethereum/EIPs/issues/721
1500     // bytes4 constant InterfaceSignature_ERC721 = bytes4(0x9a20483d);
1501     bytes4 constant InterfaceSignature_ERC721 =
1502         bytes4(keccak256("name()")) ^
1503         bytes4(keccak256("symbol()")) ^
1504         bytes4(keccak256("totalSupply()")) ^
1505         bytes4(keccak256("balanceOf(address)")) ^
1506         bytes4(keccak256("ownerOf(uint256)")) ^
1507         bytes4(keccak256("approve(address,uint256)")) ^
1508         bytes4(keccak256("transfer(address,uint256)")) ^
1509     bytes4(keccak256("transferFrom(address,address,uint256)"));
1510 
1511     /// @dev Constructor creates a reference to the NFT ownership contract
1512     ///  and verifies the owner cut is in the valid range.
1513     /// @param _nftAddress - address of a deployed contract implementing
1514     ///  the Nonfungible Interface.
1515     /// @param _cut - percent cut the owner takes on each auction, must be
1516     ///  between 0-10,000.
1517     function ClockAuction(address _nftAddress, uint256 _cut) public {
1518         require(_cut <= 10000);
1519         ownerCut = _cut;
1520 
1521         ERC721 candidateContract = ERC721(_nftAddress);
1522         require(candidateContract.supportsInterface(InterfaceSignature_ERC721));
1523         nonFungibleContract = candidateContract;
1524     }
1525 
1526     /// @dev Remove all Ether from the contract, which is the owner's cuts
1527     ///  as well as any Ether sent directly to the contract address.
1528     ///  Always transfers to the NFT contract, but can be called either by
1529     ///  the owner or the NFT contract.
1530     function withdrawBalance() external {
1531         address nftAddress = address(nonFungibleContract);
1532 
1533         require(
1534             msg.sender == owner ||
1535             msg.sender == nftAddress
1536         );
1537         // We are using this boolean method to make sure that even if one fails it will still work
1538         nftAddress.transfer(address(this).balance);
1539     }
1540 
1541     // @dev Creates and begins a new auction.
1542     // @param _tokenId - ID of token to auction, sender must be owner.
1543     // @param _startingPrice - Price of item (in wei) at beginning of auction.
1544     // @param _endingPrice - Price of item (in wei) at end of auction.
1545     // @param _duration - Length of time to move between starting
1546     //  price and ending price (in seconds).
1547     // @param _seller - Seller, if not the message sender
1548     // function createAuction(
1549     //     uint256 _tokenId,
1550     //     uint256 _startingPrice,
1551     //     uint256 _endingPrice,
1552     //     uint256 _duration,
1553     //     address _seller
1554     // )
1555     //     external
1556     //     whenNotPaused
1557     // {
1558     //     // Sanity check that no inputs overflow how many bits we've allocated
1559     //     // to store them in the auction struct.
1560     //     require(_startingPrice == uint256(uint128(_startingPrice)));
1561     //     require(_endingPrice == uint256(uint128(_endingPrice)));
1562     //     require(_duration == uint256(uint64(_duration)));
1563 
1564     //     require(_owns(msg.sender, _tokenId));
1565     //     _escrow(msg.sender, _tokenId);
1566     //     Auction memory auction = Auction(
1567     //         _seller,
1568     //         uint128(_startingPrice),
1569     //         uint128(_endingPrice),
1570     //         uint64(_duration),
1571     //         uint64(now)
1572     //     );
1573     //     _addAuction(_tokenId, auction);
1574     // }
1575 
1576     // @dev Bids on an open auction, completing the auction and transferring
1577     //  ownership of the NFT if enough Ether is supplied.
1578     // @param _tokenId - ID of token to bid on.
1579     // function bid(uint256 _tokenId)
1580     //     external
1581     //     payable
1582     //     whenNotPaused
1583     // {
1584     //     // _bid will throw if the bid or funds transfer fails
1585     //     _bid(_tokenId, msg.value);
1586     //     _transfer(msg.sender, _tokenId);
1587     // }
1588 
1589     /// @dev Cancels an auction that hasn't been won yet.
1590     ///  Returns the NFT to original owner.
1591     /// @notice This is a state-modifying function that can
1592     ///  be called while the contract is paused.
1593     /// @param _tokenId - ID of token on auction
1594     function cancelAuction(uint256 _tokenId)
1595         external
1596     {
1597         // zhangyong
1598         // 普通用户无法下架创世狗
1599         require(_tokenId > 1);
1600 
1601         Auction storage auction = tokenIdToAuction[_tokenId];
1602         require(_isOnAuction(auction));
1603         address seller = auction.seller;
1604         require(msg.sender == seller);
1605         _cancelAuction(_tokenId, seller);
1606     }
1607 
1608     /// @dev Cancels an auction when the contract is paused.
1609     ///  Only the owner may do this, and NFTs are returned to
1610     ///  the seller. This should only be used in emergencies.
1611     /// @param _tokenId - ID of the NFT on auction to cancel.
1612     function cancelAuctionWhenPaused(uint256 _tokenId)
1613         whenPaused
1614         onlyOwner
1615         external
1616     {
1617         Auction storage auction = tokenIdToAuction[_tokenId];
1618         require(_isOnAuction(auction));
1619         _cancelAuction(_tokenId, auction.seller);
1620     }
1621 
1622     /// @dev Returns auction info for an NFT on auction.
1623     /// @param _tokenId - ID of NFT on auction.
1624     function getAuction(uint256 _tokenId)
1625         external
1626         view
1627         returns
1628     (
1629         address seller,
1630         uint256 startingPrice,
1631         uint256 endingPrice,
1632         uint256 duration,
1633         uint256 startedAt
1634     ) {
1635         Auction storage auction = tokenIdToAuction[_tokenId];
1636         require(_isOnAuction(auction));
1637         return (
1638             auction.seller,
1639             auction.startingPrice,
1640             auction.endingPrice,
1641             auction.duration,
1642             auction.startedAt
1643         );
1644     }
1645 
1646     /// @dev Returns the current price of an auction.
1647     /// @param _tokenId - ID of the token price we are checking.
1648     function getCurrentPrice(uint256 _tokenId)
1649         external
1650         view
1651         returns (uint256)
1652     {
1653         Auction storage auction = tokenIdToAuction[_tokenId];
1654         require(_isOnAuction(auction));
1655         return _currentPrice(auction);
1656     }
1657 
1658 }
1659 
1660 
1661 /// @title Reverse auction modified for siring
1662 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1663 contract SiringClockAuction is ClockAuction {
1664 
1665     // @dev Sanity check that allows us to ensure that we are pointing to the
1666     //  right auction in our setSiringAuctionAddress() call.
1667     bool public isSiringClockAuction = true;
1668 
1669     // Delegate constructor
1670     function SiringClockAuction(address _nftAddr, uint256 _cut) public ClockAuction(_nftAddr, _cut) {}
1671 
1672     /// @dev Creates and begins a new auction. Since this function is wrapped,
1673     /// require sender to be KittyCore contract.
1674     /// @param _tokenId - ID of token to auction, sender must be owner.
1675     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
1676     /// @param _endingPrice - Price of item (in wei) at end of auction.
1677     /// @param _duration - Length of auction (in seconds).
1678     /// @param _seller - Seller, if not the message sender
1679     function createAuction(
1680         uint256 _tokenId,
1681         uint256 _startingPrice,
1682         uint256 _endingPrice,
1683         uint256 _duration,
1684         address _seller
1685     )
1686         external
1687     {
1688         // Sanity check that no inputs overflow how many bits we've allocated
1689         // to store them in the auction struct.
1690         require(_startingPrice == uint256(uint128(_startingPrice)));
1691         require(_endingPrice == uint256(uint128(_endingPrice)));
1692         require(_duration == uint256(uint64(_duration)));
1693 
1694         require(msg.sender == address(nonFungibleContract));
1695         _escrow(_seller, _tokenId);
1696         Auction memory auction = Auction(
1697             _seller,
1698             uint128(_startingPrice),
1699             uint128(_endingPrice),
1700             uint64(_duration),
1701             uint64(now)
1702         );
1703         _addAuction(_tokenId, auction);
1704     }
1705 
1706     /// @dev Places a bid for siring. Requires the sender
1707     /// is the KittyCore contract because all bid methods
1708     /// should be wrapped. Also returns the Dog to the
1709     /// seller rather than the winner.
1710     function bid(uint256 _tokenId, address _to)
1711         external
1712         payable
1713     {
1714         require(msg.sender == address(nonFungibleContract));
1715         address seller = tokenIdToAuction[_tokenId].seller;
1716         // _bid checks that token ID is valid and will throw if bid fails
1717         _bid(_tokenId, msg.value, _to);
1718         // We transfer the Dog back to the seller, the winner will get
1719         // the offspring
1720         _transfer(seller, _tokenId);
1721     }
1722 
1723 }
1724 
1725 
1726 
1727 
1728 
1729 /// @title Clock auction modified for sale of dogs
1730 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1731 contract SaleClockAuction is ClockAuction {
1732 
1733     // @dev Sanity check that allows us to ensure that we are pointing to the
1734     //  right auction in our setSaleAuctionAddress() call.
1735     bool public isSaleClockAuction = true;
1736 
1737     // Tracks last 5 sale price of gen0 Dog sales
1738     uint256 public gen0SaleCount;
1739     uint256[5] public lastGen0SalePrices;
1740 
1741     // Delegate constructor
1742     function SaleClockAuction(address _nftAddr, uint256 _cut) public ClockAuction(_nftAddr, _cut) {}
1743 
1744     /// @dev Creates and begins a new auction.
1745     /// @param _tokenId - ID of token to auction, sender must be owner.
1746     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
1747     /// @param _endingPrice - Price of item (in wei) at end of auction.
1748     /// @param _duration - Length of auction (in seconds).
1749     /// @param _seller - Seller, if not the message sender
1750     function createAuction(
1751         uint256 _tokenId,
1752         uint256 _startingPrice,
1753         uint256 _endingPrice,
1754         uint256 _duration,
1755         address _seller
1756     )
1757         external
1758     {
1759         // Sanity check that no inputs overflow how many bits we've allocated
1760         // to store them in the auction struct.
1761         require(_startingPrice == uint256(uint128(_startingPrice)));
1762         require(_endingPrice == uint256(uint128(_endingPrice)));
1763         require(_duration == uint256(uint64(_duration)));
1764 
1765         require(msg.sender == address(nonFungibleContract));
1766         _escrow(_seller, _tokenId);
1767         Auction memory auction = Auction(
1768             _seller,
1769             uint128(_startingPrice),
1770             uint128(_endingPrice),
1771             uint64(_duration),
1772             uint64(now)
1773         );
1774         _addAuction(_tokenId, auction);
1775     }
1776 
1777     /// @dev Updates lastSalePrice if seller is the nft contract
1778     /// Otherwise, works the same as default bid method.
1779     function bid(uint256 _tokenId, address _to)
1780         external
1781         payable
1782     {
1783         //zhangyong
1784         //只能由主合约调用出价竞购,因为要判断当期中奖了的狗无法买卖
1785         require(msg.sender == address(nonFungibleContract));
1786 
1787         // _bid verifies token ID size
1788         address seller = tokenIdToAuction[_tokenId].seller;  
1789 
1790         // zhangyong
1791         // 自己不能买自己卖的同一只狗
1792         require(seller != _to);
1793 
1794         uint256 price = _bid(_tokenId, msg.value, _to);
1795         
1796         //zhangyong
1797         //当狗被拍卖后，主人变成拍卖合约，主合约并不是狗的购买人，需要额外传入
1798         _transfer(_to, _tokenId);
1799    
1800         // If not a gen0 auction, exit
1801         if (seller == address(nonFungibleContract)) {
1802             // Track gen0 sale prices
1803             lastGen0SalePrices[gen0SaleCount % 5] = price;
1804             gen0SaleCount++;
1805         }
1806     }
1807 
1808     function averageGen0SalePrice() external view returns (uint256) {
1809         uint256 sum = 0;
1810         for (uint256 i = 0; i < 5; i++) {
1811             sum += lastGen0SalePrices[i];
1812         }
1813         return sum / 5;
1814     }
1815 
1816 }
1817 
1818 
1819 /// @title Handles creating auctions for sale and siring of dogs.
1820 ///  This wrapper of ReverseAuction exists only so that users can create
1821 ///  auctions with only one transaction.
1822 contract DogAuction is DogBreeding {
1823 
1824     uint256 public constant GEN0_AUCTION_DURATION = 1 days;
1825 
1826     // @notice The auction contract variables are defined in KittyBase to allow
1827     //  us to refer to them in KittyOwnership to prevent accidental transfers.
1828     // `saleAuction` refers to the auction for gen0 and p2p sale of dogs.
1829     // `siringAuction` refers to the auction for siring rights of dogs.
1830 
1831     /// @dev Sets the reference to the sale auction.
1832     /// @param _address - Address of sale contract.
1833     function setSaleAuctionAddress(address _address) external onlyCEO {
1834         SaleClockAuction candidateContract = SaleClockAuction(_address);
1835 
1836         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
1837         require(candidateContract.isSaleClockAuction());
1838 
1839         // Set the new contract address
1840         saleAuction = candidateContract;
1841     }
1842 
1843     /// @dev Sets the reference to the siring auction.
1844     /// @param _address - Address of siring contract.
1845     function setSiringAuctionAddress(address _address) external onlyCEO {
1846         SiringClockAuction candidateContract = SiringClockAuction(_address);
1847 
1848         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
1849         require(candidateContract.isSiringClockAuction());
1850 
1851         // Set the new contract address
1852         siringAuction = candidateContract;
1853     }
1854 
1855     /// @dev Put a Dog up for auction.
1856     ///  Does some ownership trickery to create auctions in one tx.
1857     function createSaleAuction(
1858         uint256 _dogId,
1859         uint256 _startingPrice,
1860         uint256 _endingPrice,
1861         uint256 _duration
1862     )
1863         external
1864         whenNotPaused
1865     {
1866         // Auction contract checks input sizes
1867         // If Dog is already on any auction, this will throw
1868         // because it will be owned by the auction contract.
1869         require(_owns(msg.sender, _dogId) || _approvedFor(msg.sender, _dogId));
1870         // Ensure the Dog is not pregnant to prevent the auction
1871         // contract accidentally receiving ownership of the child.
1872         // NOTE: the Dog IS allowed to be in a cooldown.
1873         require(!isPregnant(_dogId));
1874         _approve(_dogId, saleAuction);
1875         // Sale auction throws if inputs are invalid and clears
1876         // transfer and sire approval after escrowing the Dog.
1877         saleAuction.createAuction(
1878             _dogId,
1879             _startingPrice,
1880             _endingPrice,
1881             _duration,
1882             dogIndexToOwner[_dogId]
1883         );
1884     }
1885 
1886     /// @dev Put a Dog up for auction to be sire.
1887     ///  Performs checks to ensure the Dog can be sired, then
1888     ///  delegates to reverse auction.
1889     function createSiringAuction(
1890         uint256 _dogId,
1891         uint256 _startingPrice,
1892         uint256 _endingPrice,
1893         uint256 _duration
1894     )
1895         external
1896         whenNotPaused
1897     {    
1898         //zhangyong
1899         Dog storage dog = dogs[_dogId];    
1900         //变异狗不能繁殖
1901         require(dog.variation == 0);
1902 
1903         // Auction contract checks input sizes
1904         // If Dog is already on any auction, this will throw
1905         // because it will be owned by the auction contract.
1906         require(_owns(msg.sender, _dogId));
1907         require(isReadyToBreed(_dogId));
1908         _approve(_dogId, siringAuction);
1909         // Siring auction throws if inputs are invalid and clears
1910         // transfer and sire approval after escrowing the Dog.
1911         siringAuction.createAuction(
1912             _dogId,
1913             _startingPrice,
1914             _endingPrice,
1915             _duration,
1916             msg.sender
1917         );
1918     }
1919 
1920     /// @dev Completes a siring auction by bidding.
1921     ///  Immediately breeds the winning matron with the sire on auction.
1922     /// @param _sireId - ID of the sire on auction.
1923     /// @param _matronId - ID of the matron owned by the bidder.
1924     function bidOnSiringAuction(
1925         uint256 _sireId,
1926         uint256 _matronId
1927     )
1928         external
1929         payable
1930         whenNotPaused
1931     {
1932         // Auction contract checks input sizes
1933         require(_owns(msg.sender, _matronId));
1934         require(isReadyToBreed(_matronId));
1935         require(_canBreedWithViaAuction(_matronId, _sireId));
1936 
1937         // Define the current price of the auction.
1938         uint256 currentPrice = siringAuction.getCurrentPrice(_sireId);
1939         
1940         // zhangyong
1941         // 如果不是0代狗繁殖，则多收0代狗的繁殖收益
1942         uint256 totalFee = currentPrice + autoBirthFee;
1943         Dog storage matron = dogs[_matronId];
1944         if (matron.generation > 0) {
1945             totalFee += gen0Profit;
1946         }        
1947         require(msg.value >= totalFee);
1948 
1949         uint256 auctioneerCut = saleAuction.computeCut(currentPrice);
1950         // Siring auction will throw if the bid fails.
1951         siringAuction.bid.value(currentPrice - auctioneerCut)(_sireId, msg.sender);
1952         _breedWith(uint32(_matronId), uint32(_sireId));
1953 
1954         // zhangyong
1955         // 额外的钱返还给用户
1956         uint256 bidExcess = msg.value - totalFee;
1957         if (bidExcess > 0) {
1958             msg.sender.transfer(bidExcess);
1959         }
1960     }
1961 
1962     // zhangyong
1963     // 创世狗交易需要收取10%的手续费给CFO
1964     // 所有交易都要收取3.75%的手续费给买卖合约
1965     function bidOnSaleAuction(
1966         uint256 _dogId
1967     )
1968         external
1969         payable
1970         whenNotPaused
1971     {
1972         Dog storage dog = dogs[_dogId];
1973 
1974         //中奖的狗无法交易
1975         if (dog.generation > 0) {
1976             var(,,openBlock,,,,,,) = lottery.getCLottery();
1977             if (dog.birthTime < openBlock) {
1978                 require(lottery.checkLottery(dog.genes) == 100);
1979             }
1980         }
1981 
1982         //交易成功之后，买卖合约会被删除，无法获取到当前价格
1983         uint256 currentPrice = saleAuction.getCurrentPrice(_dogId);
1984 
1985         require(msg.value >= currentPrice);
1986 
1987         //创世狗交易需要收取10%的手续费
1988         bool isCreationKitty = _dogId == 0 || _dogId == 1;
1989         uint256 fee = 0;
1990         if (isCreationKitty) {
1991             fee = currentPrice / 5;
1992         }
1993         uint256 auctioneerCut = saleAuction.computeCut(currentPrice);
1994         saleAuction.bid.value(currentPrice - (auctioneerCut + fee))(_dogId, msg.sender);
1995 
1996         // 创世狗被交易之后，下次的价格为当前成交价的2倍
1997         if (isCreationKitty) {
1998             //转账到主合约进行，因为买卖合约访问不了cfoAddress
1999             cfoAddress.transfer(fee);
2000 
2001             uint256 nextPrice = uint256(uint128(2 * currentPrice));
2002             if (nextPrice < currentPrice) {
2003                 nextPrice = currentPrice;
2004             }
2005             _approve(_dogId, saleAuction);
2006             saleAuction.createAuction(
2007                 _dogId,
2008                 nextPrice,
2009                 nextPrice,                                               
2010                 GEN0_AUCTION_DURATION,
2011                 msg.sender);
2012         }
2013 
2014         uint256 bidExcess = msg.value - currentPrice;
2015         if (bidExcess > 0) {
2016             msg.sender.transfer(bidExcess);
2017         }
2018     }
2019 
2020     // @dev Transfers the balance of the sale auction contract
2021     // to the KittyCore contract. We use two-step withdrawal to
2022     // prevent two transfer calls in the auction bid function.
2023     // function withdrawAuctionBalances() external onlyCLevel {
2024     //     saleAuction.withdrawBalance();
2025     //     siringAuction.withdrawBalance();
2026     // }
2027 }
2028 
2029 
2030 /// @title all functions related to creating kittens
2031 contract DogMinting is DogAuction {
2032 
2033     // Limits the number of cats the contract owner can ever create.
2034     // uint256 public constant PROMO_CREATION_LIMIT = 5000;
2035     uint256 public constant GEN0_CREATION_LIMIT = 40000;
2036 
2037     // Constants for gen0 auctions.
2038     uint256 public constant GEN0_STARTING_PRICE = 200 finney;
2039     // uint256 public constant GEN0_AUCTION_DURATION = 1 days;
2040     // Counts the number of cats the contract owner has created.
2041     // uint256 public promoCreatedCount;
2042     uint256 public gen0CreatedCount;
2043 
2044     // @dev we can create promo kittens, up to a limit. Only callable by COO
2045     // @param _genes the encoded genes of the kitten to be created, any value is accepted
2046     // @param _owner the future owner of the created kittens. Default to contract COO
2047     // function createPromoKitty(uint256 _genes, address _owner) external onlyCOO {
2048     //     address kittyOwner = _owner;
2049     //     if (kittyOwner == address(0)) {
2050     //         kittyOwner = cooAddress;
2051     //     }
2052     //     require(promoCreatedCount < PROMO_CREATION_LIMIT);
2053 
2054     //     promoCreatedCount++;
2055     //     //zhangyong
2056     //     //增加变异系数与0代狗祖先作为参数
2057     //     _createDog(0, 0, 0, _genes, kittyOwner, 0, 0, false);
2058     // }
2059 
2060     // @dev Creates a new gen0 Dog with the given genes
2061     function createGen0Dog(uint256 _genes) external onlyCLevel returns(uint256) {
2062         require(gen0CreatedCount < GEN0_CREATION_LIMIT);
2063         //zhangyong
2064         //增加变异系数与0代狗祖先作为参数
2065         uint256 dogId = _createDog(0, 0, 0, _genes, address(this), 0, 0, false);
2066         
2067         _approve(dogId, msg.sender);
2068 
2069         gen0CreatedCount++;
2070         return dogId;
2071     }
2072 
2073     /// @dev creates an auction for it.
2074     // function createGen0Auction(uint256 _dogId) external onlyCOO {
2075     //     require(_owns(address(this), _dogId));
2076 
2077     //     _approve(_dogId, saleAuction);
2078 
2079     //     //zhangyong
2080     //     //0代狗的价格随时间递减到最低价，起始价与前5只价格相关
2081     //     uint256 price = _computeNextGen0Price();
2082     //     saleAuction.createAuction(
2083     //         _dogId,
2084     //         price,
2085     //         price,
2086     //         GEN0_AUCTION_DURATION,
2087     //         address(this)
2088     //     );
2089     // }
2090 
2091     /// @dev Computes the next gen0 auction starting price, given
2092     ///  the average of the past 5 prices + 50%.
2093     function computeNextGen0Price() public view returns (uint256) {
2094         uint256 avePrice = saleAuction.averageGen0SalePrice();
2095 
2096         // Sanity check to ensure we don't overflow arithmetic
2097         require(avePrice == uint256(uint128(avePrice)));
2098 
2099         uint256 nextPrice = avePrice + (avePrice / 2);
2100 
2101         // We never auction for less than starting price
2102         if (nextPrice < GEN0_STARTING_PRICE) {
2103             nextPrice = GEN0_STARTING_PRICE;
2104         }
2105 
2106         return nextPrice;
2107     }
2108 }
2109 
2110 
2111 /// @title Cryptodogs: Collectible, breedable, and oh-so-adorable cats on the Ethereum blockchain.
2112 /// @author Axiom Zen (https://www.axiomzen.co)
2113 /// @dev The main Cryptodogs contract, keeps track of kittens so they don't wander around and get lost.
2114 contract DogCore is DogMinting {
2115 
2116     // This is the main Cryptodogs contract. In order to keep our code seperated into logical sections,
2117     // we've broken it up in two ways. First, we have several seperately-instantiated sibling contracts
2118     // that handle auctions and our super-top-secret genetic combination algorithm. The auctions are
2119     // seperate since their logic is somewhat complex and there's always a risk of subtle bugs. By keeping
2120     // them in their own contracts, we can upgrade them without disrupting the main contract that tracks
2121     // Dog ownership. The genetic combination algorithm is kept seperate so we can open-source all of
2122     // the rest of our code without making it _too_ easy for folks to figure out how the genetics work.
2123     // Don't worry, I'm sure someone will reverse engineer it soon enough!
2124     //
2125     // Secondly, we break the core contract into multiple files using inheritence, one for each major
2126     // facet of functionality of CK. This allows us to keep related code bundled together while still
2127     // avoiding a single giant file with everything in it. The breakdown is as follows:
2128     //
2129     //      - KittyBase: This is where we define the most fundamental code shared throughout the core
2130     //             functionality. This includes our main data storage, constants and data types, plus
2131     //             internal functions for managing these items.
2132     //
2133     //      - KittyAccessControl: This contract manages the various addresses and constraints for operations
2134     //             that can be executed only by specific roles. Namely CEO, CFO and COO.
2135     //
2136     //      - KittyOwnership: This provides the methods required for basic non-fungible token
2137     //             transactions, following the draft ERC-721 spec (https://github.com/ethereum/EIPs/issues/721).
2138     //
2139     //      - KittyBreeding: This file contains the methods necessary to breed cats together, including
2140     //             keeping track of siring offers, and relies on an external genetic combination contract.
2141     //
2142     //      - KittyAuctions: Here we have the public methods for auctioning or bidding on cats or siring
2143     //             services. The actual auction functionality is handled in two sibling contracts (one
2144     //             for sales and one for siring), while auction creation and bidding is mostly mediated
2145     //             through this facet of the core contract.
2146     //
2147     //      - KittyMinting: This final facet contains the functionality we use for creating new gen0 cats.
2148     //             We can make up to 5000 "promo" cats that can be given away (especially important when
2149     //             the community is new), and all others can only be created and then immediately put up
2150     //             for auction via an algorithmically determined starting price. Regardless of how they
2151     //             are created, there is a hard limit of 50k gen0 cats. After that, it's all up to the
2152     //             community to breed, breed, breed!
2153 
2154     // Set in case the core contract is broken and an upgrade is required
2155     address public newContractAddress;
2156 
2157     /// @notice Creates the main Cryptodogs smart contract instance.
2158     function DogCore() public {
2159         // Starts paused.
2160         paused = true;
2161 
2162         // the creator of the contract is the initial CEO
2163         ceoAddress = msg.sender;
2164 
2165         // the creator of the contract is also the initial COO
2166         cooAddress = msg.sender;
2167 
2168         // start with the mythical kitten 0 - so we don't have generation-0 parent issues
2169         //zhangyong
2170         //增加变异系数与0代狗祖先作为参数
2171         _createDog(0, 0, 0, uint256(0), address(this), 0, 0, false);   
2172         _approve(0, cooAddress);     
2173         _createDog(0, 0, 0, uint256(0), address(this), 0, 0, false);   
2174         _approve(1, cooAddress);
2175     }
2176 
2177     /// @dev Used to mark the smart contract as upgraded, in case there is a serious
2178     ///  breaking bug. This method does nothing but keep track of the new contract and
2179     ///  emit a message indicating that the new address is set. It's up to clients of this
2180     ///  contract to update to the new contract address in that case. (This contract will
2181     ///  be paused indefinitely if such an upgrade takes place.)
2182     /// @param _v2Address new address
2183     function setNewAddress(address _v2Address) external onlyCEO whenPaused {
2184         // See README.md for updgrade plan
2185         newContractAddress = _v2Address;
2186         ContractUpgrade(_v2Address);
2187     }
2188 
2189     /// @notice No tipping!
2190     /// @dev Reject all Ether from being sent here, unless it's from one of the
2191     ///  two auction contracts. (Hopefully, we can prevent user accidents.)
2192     function() external payable {
2193         require(
2194             msg.sender == address(saleAuction) ||
2195             msg.sender == address(siringAuction) ||
2196             msg.sender == ceoAddress
2197         );
2198     }
2199 
2200     /// @notice Returns all the relevant information about a specific Dog.
2201     /// @param _id The ID of the Dog of interest.
2202     function getDog(uint256 _id)
2203         external
2204         view
2205         returns (
2206         uint256 cooldownIndex,
2207         uint256 nextActionAt,
2208         uint256 siringWithId,
2209         uint256 birthTime,
2210         uint256 matronId,
2211         uint256 sireId,
2212         uint256 generation,
2213         uint256 genes,
2214         uint8 variation,
2215         uint256 gen0
2216     ) {
2217         Dog storage dog = dogs[_id];
2218 
2219         // if this variable is 0 then it's not gestating
2220         cooldownIndex = uint256(dog.cooldownIndex);
2221         nextActionAt = uint256(dog.cooldownEndBlock);
2222         siringWithId = uint256(dog.siringWithId);
2223         birthTime = uint256(dog.birthTime);
2224         matronId = uint256(dog.matronId);
2225         sireId = uint256(dog.sireId);
2226         generation = uint256(dog.generation);
2227         genes = uint256(dog.genes);
2228         variation = uint8(dog.variation);
2229         gen0 = uint256(dog.gen0);
2230     }
2231 
2232     /// @dev Override unpause so it requires all external contract addresses
2233     ///  to be set before contract can be unpaused. Also, we can't have
2234     ///  newContractAddress set either, because then the contract was upgraded.
2235     /// @notice This is public rather than external so we can call super.unpause
2236     ///  without using an expensive CALL.
2237     function unpause() public onlyCEO whenPaused {
2238         require(saleAuction != address(0));
2239         require(siringAuction != address(0));
2240         require(geneScience != address(0));
2241         require(lottery != address(0));
2242         require(variation != address(0));
2243         require(newContractAddress == address(0));
2244 
2245         // Actually unpause the contract.
2246         super.unpause();
2247     }
2248       
2249     function setLotteryAddress(address _address) external onlyCEO {
2250         LotteryInterface candidateContract = LotteryInterface(_address);
2251 
2252         require(candidateContract.isLottery());
2253 
2254         lottery = candidateContract;
2255     }  
2256       
2257     function setVariationAddress(address _address) external onlyCEO {
2258         VariationInterface candidateContract = VariationInterface(_address);
2259 
2260         require(candidateContract.isVariation());
2261 
2262         variation = candidateContract;
2263     }  
2264 
2265     function registerLottery(uint256 _dogId) external returns (uint8) {
2266         require(_owns(msg.sender, _dogId));
2267         require(lottery.registerLottery(_dogId) == 0);    
2268         _transfer(msg.sender, address(lottery), _dogId);
2269     }
2270 
2271     function sendMoney(address _to, uint256 _money) external {
2272         require(msg.sender == address(lottery) || msg.sender == address(variation));
2273         require(address(this).balance >= _money);
2274         _to.transfer(_money);
2275     }
2276 
2277 }