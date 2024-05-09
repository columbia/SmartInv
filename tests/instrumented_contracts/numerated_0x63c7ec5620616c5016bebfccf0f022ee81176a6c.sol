1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address public owner;
11 
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17     //function Ownable() public {
18     constructor () public {
19         owner = msg.sender;
20     }
21 
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26     modifier onlyOwner() {
27         require(msg.sender == owner);
28         _;
29     }
30 
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36     function transferOwnership(address newOwner) onlyOwner public {
37         if (newOwner != address(0)) {
38             owner = newOwner;
39         }
40     }
41 
42 }
43 
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
73 
74 
75 
76 /// @title A facet of KittyCore that manages special access privileges.
77 /// @author Axiom Zen (https://www.axiomzen.co)
78 /// @dev See the KittyCore contract documentation to understand how the various contract facets are arranged.
79 contract AccessControl {
80     // This facet controls access control for CryptoKitties. There are four roles managed here:
81     //
82     //     - The CEO: The CEO can reassign other roles and change the addresses of our dependent smart
83     //         contracts. It is also the only role that can unpause the smart contract. It is initially
84     //         set to the address that created the smart contract in the KittyCore constructor.
85     //
86     //     - The CFO: The CFO can withdraw funds from KittyCore and its auction contracts.
87     //
88     //     - The COO: The COO can release gen0 kitties to auction, and mint promo cats.
89     //
90     // It should be noted that these roles are distinct without overlap in their access abilities, the
91     // abilities listed for each role above are exhaustive. In particular, while the CEO can assign any
92     // address to any role, the CEO address itself doesn't have the ability to act in those roles. This
93     // restriction is intentional so that we aren't tempted to use the CEO address frequently out of
94     // convenience. The less we use an address, the less likely it is that we somehow compromise the
95     // account.
96 
97     /// @dev Emited when contract is upgraded - See README.md for updgrade plan
98     event ContractUpgrade(address newContract);
99 
100     // The addresses of the accounts (or contracts) that can execute actions within each roles.
101     address public ceoAddress;
102     address public cfoAddress;
103     address public cooAddress;
104 
105     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
106     bool public paused = false;
107 
108     /// @dev Access modifier for CEO-only functionality
109     modifier onlyCEO() {
110         require(msg.sender == ceoAddress);
111         _;
112     }
113 
114     /// @dev Access modifier for CFO-only functionality
115     modifier onlyCFO() {
116         require(msg.sender == cfoAddress);
117         _;
118     }
119 
120     /// @dev Access modifier for COO-only functionality
121     modifier onlyCOO() {
122         require(msg.sender == cooAddress);
123         _;
124     }
125 
126     modifier onlyCLevel() {
127         require(
128             msg.sender == cooAddress ||
129             msg.sender == ceoAddress ||
130             msg.sender == cfoAddress
131         );
132         _;
133     }
134 
135     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
136     /// @param _newCEO The address of the new CEO
137     function setCEO(address _newCEO) external onlyCEO {
138         require(_newCEO != address(0));
139 
140         ceoAddress = _newCEO;
141     }
142 
143     /// @dev Assigns a new address to act as the CFO. Only available to the current CEO.
144     /// @param _newCFO The address of the new CFO
145     function setCFO(address _newCFO) external onlyCEO {
146         require(_newCFO != address(0));
147 
148         cfoAddress = _newCFO;
149     }
150 
151     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
152     /// @param _newCOO The address of the new COO
153     function setCOO(address _newCOO) external onlyCEO {
154         require(_newCOO != address(0));
155 
156         cooAddress = _newCOO;
157     }
158 
159     /*** Pausable functionality adapted from OpenZeppelin ***/
160 
161     /// @dev Modifier to allow actions only when the contract IS NOT paused
162     modifier whenNotPaused() {
163         require(!paused);
164         _;
165     }
166 
167     /// @dev Modifier to allow actions only when the contract IS paused
168     modifier whenPaused {
169         require(paused);
170         _;
171     }
172 
173     /// @dev Called by any "C-level" role to pause the contract. Used only when
174     ///  a bug or exploit is detected and we need to limit damage.
175     function pause() external onlyCLevel whenNotPaused {
176         paused = true;
177     }
178 
179     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
180     ///  one reason we may pause the contract is when CFO or COO accounts are
181     ///  compromised.
182     /// @notice This is public rather than external so it can be called by
183     ///  derived contracts.
184     function unpause() public onlyCEO whenPaused {
185         // can't unpause if contract was upgraded
186         paused = false;
187     }
188 }
189 
190 
191 
192 
193 /// @title Base contract for CryptoKitties. Holds all common structs, events and base variables.
194 /// @author Axiom Zen (https://www.axiomzen.co)
195 /// @dev See the KittyCore contract documentation to understand how the various contract facets are arranged.
196 contract PetBase is AccessControl {
197     /*** EVENTS ***/
198 
199     /// @dev The Birth event is fired whenever a new kitten comes into existence. This obviously
200     ///  includes any time a cat is created through the giveBirth method, but it is also called
201     ///  when a new gen0 cat is created.
202     event Birth(address owner, uint256 monsterId, uint256 genes);
203 
204     /// @dev Transfer event as defined in current draft of ERC721. Emitted every time a kitten
205     ///  ownership is assigned, including births.
206     event Transfer(address from, address to, uint256 tokenId);
207 
208     /*** DATA TYPES ***/
209 
210     /// @dev The main Kitty struct. Every cat in CryptoKitties is represented by a copy
211     ///  of this structure, so great care was taken to ensure that it fits neatly into
212     ///  exactly two 256-bit words. Note that the order of the members in this structure
213     ///  is important because of the byte-packing rules used by Ethereum.
214     ///  Ref: http://solidity.readthedocs.io/en/develop/miscellaneous.html
215     struct Pet {
216         // The Kitty's genetic code is packed into these 256-bits, the format is
217         // sooper-sekret! A cat's genes never change.
218         uint256 genes;
219         
220         // The timestamp from the block when this cat came into existence.
221         uint64 birthTime;     
222 		
223         // The "generation number" of this cat. Cats minted by the CK contract
224         // for sale are called "gen0" and have a generation number of 0. The
225         // generation number of all other cats is the larger of the two generation
226         // numbers of their parents, plus one.
227         // (i.e. max(matron.generation, sire.generation) + 1)
228         uint16 generation;
229 
230         uint16 grade;
231         uint16 level;
232         uint16 params;
233         uint16 skills;
234 
235     }
236 
237 
238     // An approximation of currently how many seconds are in between blocks.
239     uint256 public secondsPerBlock = 15;
240 
241     /*** STORAGE ***/
242 
243     /// @dev An array containing the Pet struct for all pets (cats & dogs) in existence. The ID
244     ///  of each pet is actually an index into this array. Note that ID 0 is a negapet,
245     ///  the unPet, the mythical beast that is the parent of all gen0 pets. A bizarre
246     ///  creature that is both matron and sire... to itself! Has an invalid genetic code.
247     ///  In other words, pet ID 0 is invalid... ;-)
248     Pet[] pets; //Monster[] monsters;
249 
250     /// @dev A mapping from pet IDs to the address that owns them. All pets have
251     ///  some valid owner address, even gen0 pets are created with a non-zero owner.
252     mapping (uint256 => address) public petIndexToOwner;
253 
254     // @dev A mapping from owner address to count of tokens that address owns.
255     //  Used internally inside balanceOf() to resolve ownership count.
256     mapping (address => uint256) ownershipTokenCount;
257 
258     /// @dev A mapping from KittyIDs to an address that has been approved to call
259     ///  transferFrom(). Each Kitty can only have one approved address for transfer
260     ///  at any time. A zero value means no approval is outstanding.
261     mapping (uint256 => address) public petIndexToApproved;
262     
263     /// @dev The address of the ClockAuction contract that handles sales of Kitties. This
264     ///  same contract handles both peer-to-peer sales as well as the gen0 sales which are
265     ///  initiated every 15 minutes.
266     SaleClockAuction public saleAuction;
267 
268 
269 	/// @dev Assigns ownership of a specific Kitty to an address.
270     function _transfer(address _from, address _to, uint256 _tokenId) internal {
271         // Since the number of kittens is capped to 2^32 we can't overflow this
272         ownershipTokenCount[_to]++;
273         // transfer ownership
274         petIndexToOwner[_tokenId] = _to;
275         // When creating new kittens _from is 0x0, but we can't account that address.
276         if (_from != address(0)) {
277             ownershipTokenCount[_from]--;
278             // clear any previously approved ownership exchange
279             delete petIndexToApproved[_tokenId];
280         }
281         // Emit the transfer event.
282         emit Transfer(_from, _to, _tokenId);
283     }
284 	
285         /// @dev An internal method that creates a new kitty and stores it. This
286     ///  method doesn't do any checking and should only be called when the
287     ///  input data is known to be valid. Will generate both a Birth event
288     ///  and a Transfer event.
289     /// @param _generation The generation number of this cat, must be computed by caller.
290     /// @param _genes The kitty's genetic code.
291     /// @param _owner The inital owner of this cat, must be non-zero (except for the unKitty, ID 0)
292     function _createPet(
293         uint256 _generation,
294         uint256 _genes,
295         address _owner,
296         uint256 _grade,
297         uint256 _level,
298         uint256 _params,
299         uint256 _skills
300     )
301         internal
302         returns (uint)
303     {
304         // These requires are not strictly necessary, our calling code should make
305         // sure that these conditions are never broken. However! _createKitty() is already
306         // an expensive call (for storage), and it doesn't hurt to be especially careful
307         // to ensure our data structures are always valid.
308         require(_generation == uint256(uint16(_generation)));
309 
310         // New pet starts with the same cooldown as parent gen/2
311         uint16 cooldownIndex = uint16(_generation / 2);
312         if (cooldownIndex > 13) {
313             cooldownIndex = 13;
314         }
315 
316         Pet memory _pet = Pet({
317             genes: _genes,
318             birthTime: uint64(now),            
319             generation: uint16(_generation),
320             grade: uint16(_grade), 
321             level: uint16(_level), 
322             params: uint16(_params),            
323             skills: uint16(_skills)
324         });
325         uint256 newPetId = pets.push(_pet) - 1;
326 
327         // It's probably never going to happen, 4 billion cats is A LOT, but
328         // let's just be 100% sure we never let this happen.
329         require(newPetId == uint256(uint32(newPetId)));
330 
331         // emit the birth event
332         emit Birth(
333             _owner,
334             newPetId,
335             _pet.genes
336         );
337 
338         // This will assign ownership, and also emit the Transfer event as
339         // per ERC721 draft
340         _transfer(0, _owner, newPetId);
341 
342         return newPetId;
343     }
344 
345 }
346 
347 
348 
349 /// @title The external contract that is responsible for generating metadata for the kitties,
350 ///  it has one function that will return the data as bytes.
351 contract ERC721Metadata {
352     /// @dev Given a token Id, returns a byte array that is supposed to be converted into string.
353     function getMetadata(uint256 _tokenId, string) public pure returns (bytes32[4] buffer, uint256 count) {
354         if (_tokenId == 1) {
355             buffer[0] = "Hello World! :D";
356             count = 15;
357         } else if (_tokenId == 2) {
358             buffer[0] = "I would definitely choose a medi";
359             buffer[1] = "um length string.";
360             count = 49;
361         } else if (_tokenId == 3) {
362             buffer[0] = "Lorem ipsum dolor sit amet, mi e";
363             buffer[1] = "st accumsan dapibus augue lorem,";
364             buffer[2] = " tristique vestibulum id, libero";
365             buffer[3] = " suscipit varius sapien aliquam.";
366             count = 128;
367         }
368     }
369 }
370 
371 
372 
373 /// @title The facet of the CryptoKitties core contract that manages ownership, ERC-721 (draft) compliant.
374 /// @author Axiom Zen (https://www.axiomzen.co)
375 /// @dev Ref: https://github.com/ethereum/EIPs/issues/721
376 ///  See the KittyCore contract documentation to understand how the various contract facets are arranged.
377 contract PetOwnership is PetBase, ERC721 {
378 
379     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
380     string public constant name = "CatsVsDogs";
381     string public constant symbol = "CD";
382 
383     // The contract that will return kitty metadata
384     ERC721Metadata public erc721Metadata;
385 
386     bytes4 constant InterfaceSignature_ERC165 =
387         bytes4(keccak256('supportsInterface(bytes4)'));
388 
389     bytes4 constant InterfaceSignature_ERC721 =
390         bytes4(keccak256('name()')) ^
391         bytes4(keccak256('symbol()')) ^
392         bytes4(keccak256('totalSupply()')) ^
393         bytes4(keccak256('balanceOf(address)')) ^
394         bytes4(keccak256('ownerOf(uint256)')) ^
395         bytes4(keccak256('approve(address,uint256)')) ^
396         bytes4(keccak256('transfer(address,uint256)')) ^
397         bytes4(keccak256('transferFrom(address,address,uint256)')) ^
398         bytes4(keccak256('tokensOfOwner(address)')) ^
399         bytes4(keccak256('tokenMetadata(uint256,string)'));
400 
401     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
402     ///  Returns true for any standardized interfaces implemented by this contract. We implement
403     ///  ERC-165 (obviously!) and ERC-721.
404     function supportsInterface(bytes4 _interfaceID) external view returns (bool)
405     {
406         // DEBUG ONLY
407         //require((InterfaceSignature_ERC165 == 0x01ffc9a7) && (InterfaceSignature_ERC721 == 0x9a20483d));
408 
409         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
410     }
411 
412     /// @dev Set the address of the sibling contract that tracks metadata.
413     ///  CEO only.
414     function setMetadataAddress(address _contractAddress) public onlyCEO {
415         erc721Metadata = ERC721Metadata(_contractAddress);
416     }
417 
418     // Internal utility functions: These functions all assume that their input arguments
419     // are valid. We leave it to public methods to sanitize their inputs and follow
420     // the required logic.
421 
422     /// @dev Checks if a given address is the current owner of a particular Kitty.
423     /// @param _claimant the address we are validating against.
424     /// @param _tokenId kitten id, only valid when > 0
425     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
426         return petIndexToOwner[_tokenId] == _claimant;
427     }
428 
429     /// @dev Checks if a given address currently has transferApproval for a particular Kitty.
430     /// @param _claimant the address we are confirming kitten is approved for.
431     /// @param _tokenId kitten id, only valid when > 0
432     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
433         return petIndexToApproved[_tokenId] == _claimant;
434     }
435 
436     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
437     ///  approval. Setting _approved to address(0) clears all transfer approval.
438     ///  NOTE: _approve() does NOT send the Approval event. This is intentional because
439     ///  _approve() and transferFrom() are used together for putting Kitties on auction, and
440     ///  there is no value in spamming the log with Approval events in that case.
441     function _approve(uint256 _tokenId, address _approved) internal {
442         petIndexToApproved[_tokenId] = _approved;
443     }
444 
445     /// @notice Returns the number of Kitties owned by a specific address.
446     /// @param _owner The owner address to check.
447     /// @dev Required for ERC-721 compliance
448     function balanceOf(address _owner) public view returns (uint256 count) {
449         return ownershipTokenCount[_owner];
450     }
451 
452     /// @notice Transfers a Kitty to another address. If transferring to a smart
453     ///  contract be VERY CAREFUL to ensure that it is aware of ERC-721 (or
454     ///  CryptoKitties specifically) or your Kitty may be lost forever. Seriously.
455     /// @param _to The address of the recipient, can be a user or contract.
456     /// @param _tokenId The ID of the Kitty to transfer.
457     /// @dev Required for ERC-721 compliance.
458     function transfer(
459         address _to,
460         uint256 _tokenId
461     )
462         external
463         whenNotPaused
464     {
465         // Safety check to prevent against an unexpected 0x0 default.
466         require(_to != address(0));
467         // Disallow transfers to this contract to prevent accidental misuse.
468         // The contract should never own any kitties (except very briefly
469         // after a gen0 cat is created and before it goes on auction).
470         require(_to != address(this));
471         // Disallow transfers to the auction contracts to prevent accidental
472         // misuse. Auction contracts should only take ownership of kitties
473         // through the allow + transferFrom flow.
474         require(_to != address(saleAuction));
475         
476         // You can only send your own cat.
477         require(_owns(msg.sender, _tokenId));
478 
479         // Reassign ownership, clear pending approvals, emit Transfer event.
480         _transfer(msg.sender, _to, _tokenId);
481     }
482 
483     /// @notice Grant another address the right to transfer a specific Kitty via
484     ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
485     /// @param _to The address to be granted transfer approval. Pass address(0) to
486     ///  clear all approvals.
487     /// @param _tokenId The ID of the Kitty that can be transferred if this call succeeds.
488     /// @dev Required for ERC-721 compliance.
489     function approve(
490         address _to,
491         uint256 _tokenId
492     )
493         external
494         whenNotPaused
495     {
496         // Only an owner can grant transfer approval.
497         require(_owns(msg.sender, _tokenId));
498 
499         // Register the approval (replacing any previous approval).
500         _approve(_tokenId, _to);
501 
502         // Emit approval event.
503         emit Approval(msg.sender, _to, _tokenId);
504     }
505 
506     /// @notice Transfer a Kitty owned by another address, for which the calling address
507     ///  has previously been granted transfer approval by the owner.
508     /// @param _from The address that owns the Kitty to be transfered.
509     /// @param _to The address that should take ownership of the Kitty. Can be any address,
510     ///  including the caller.
511     /// @param _tokenId The ID of the Kitty to be transferred.
512     /// @dev Required for ERC-721 compliance.
513     function transferFrom(
514         address _from,
515         address _to,
516         uint256 _tokenId
517     )
518         external
519         whenNotPaused
520     {
521         // Safety check to prevent against an unexpected 0x0 default.
522         require(_to != address(0));
523         // Disallow transfers to this contract to prevent accidental misuse.
524         // The contract should never own any kitties (except very briefly
525         // after a gen0 cat is created and before it goes on auction).
526         require(_to != address(this));
527         // Check for approval and valid ownership
528         require(_approvedFor(msg.sender, _tokenId));
529         require(_owns(_from, _tokenId));
530 
531         // Reassign ownership (also clears pending approvals and emits Transfer event).
532         _transfer(_from, _to, _tokenId);
533     }
534 
535     /// @notice Returns the total number of Kitties currently in existence.
536     /// @dev Required for ERC-721 compliance.
537     function totalSupply() public view returns (uint) {
538         return pets.length - 1;
539     }
540 
541     /// @notice Returns the address currently assigned ownership of a given Kitty.
542     /// @dev Required for ERC-721 compliance.
543     function ownerOf(uint256 _tokenId)
544         external
545         view
546         returns (address owner)
547     {
548         owner = petIndexToOwner[_tokenId];
549 
550         require(owner != address(0));
551     }
552 
553     /// @notice Returns a list of all Kitty IDs assigned to an address.
554     /// @param _owner The owner whose Kitties we are interested in.
555     /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
556     ///  expensive (it walks the entire Kitty array looking for cats belonging to owner),
557     ///  but it also returns a dynamic array, which is only supported for web3 calls, and
558     ///  not contract-to-contract calls.
559     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
560         uint256 tokenCount = balanceOf(_owner);
561 
562         if (tokenCount == 0) {
563             // Return an empty array
564             return new uint256[](0);
565         } else {
566             uint256[] memory result = new uint256[](tokenCount);
567             uint256 totalCats = totalSupply();
568             uint256 resultIndex = 0;
569 
570             // We count on the fact that all cats have IDs starting at 1 and increasing
571             // sequentially up to the totalCat count.
572             uint256 catId;
573 
574             for (catId = 1; catId <= totalCats; catId++) {
575                 if (petIndexToOwner[catId] == _owner) {
576                     result[resultIndex] = catId;
577                     resultIndex++;
578                 }
579             }
580 
581             return result;
582         }
583     }
584 
585     /// @dev Adapted from memcpy() by @arachnid (Nick Johnson <arachnid@notdot.net>)
586     ///  This method is licenced under the Apache License.
587     ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
588     function _memcpy(uint _dest, uint _src, uint _len) private pure {
589         // Copy word-length chunks while possible
590         for(; _len >= 32; _len -= 32) {
591             assembly {
592                 mstore(_dest, mload(_src))
593             }
594             _dest += 32;
595             _src += 32;
596         }
597 
598         // Copy remaining bytes
599         uint256 mask = 256 ** (32 - _len) - 1;
600         assembly {
601             let srcpart := and(mload(_src), not(mask))
602             let destpart := and(mload(_dest), mask)
603             mstore(_dest, or(destpart, srcpart))
604         }
605     }
606 
607     /// @dev Adapted from toString(slice) by @arachnid (Nick Johnson <arachnid@notdot.net>)
608     ///  This method is licenced under the Apache License.
609     ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
610     function _toString(bytes32[4] _rawBytes, uint256 _stringLength) private pure returns (string) {
611         //var outputString = new string(_stringLength);
612         string memory outputString = new string(_stringLength);
613         uint256 outputPtr;
614         uint256 bytesPtr;
615 
616         assembly {
617             outputPtr := add(outputString, 32)
618             bytesPtr := _rawBytes
619         }
620 
621         _memcpy(outputPtr, bytesPtr, _stringLength);
622 
623         return outputString;
624     }
625 
626     /// @notice Returns a URI pointing to a metadata package for this token conforming to
627     ///  ERC-721 (https://github.com/ethereum/EIPs/issues/721)
628     /// @param _tokenId The ID number of the Kitty whose metadata should be returned.
629     function tokenMetadata(uint256 _tokenId, string _preferredTransport) external view returns (string infoUrl) {
630         require(erc721Metadata != address(0));
631         bytes32[4] memory buffer;
632         uint256 count;
633         (buffer, count) = erc721Metadata.getMetadata(_tokenId, _preferredTransport);
634 
635         return _toString(buffer, count);
636     }
637 }	
638 	
639 	
640 
641 
642 /// @title Auction Core
643 /// @dev Contains models, variables, and internal methods for the auction.
644 /// @notice We omit a fallback function to prevent accidental sends to this contract.
645 contract ClockAuctionBase {
646 
647     // Represents an auction on an NFT
648     struct Auction {
649         // Current owner of NFT
650         address seller;
651         // Price (in wei) at beginning of auction
652         uint128 startingPrice;
653         // Price (in wei) at end of auction
654         uint128 endingPrice;
655         // Duration (in seconds) of auction
656         uint64 duration;
657         // Time when auction started
658         // NOTE: 0 if this auction has been concluded
659         uint64 startedAt;
660     }
661 
662     // Reference to contract tracking NFT ownership
663     ERC721 public nonFungibleContract;
664 
665     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
666     // Values 0-10,000 map to 0%-100%
667     uint256 public ownerCut;
668 
669     // Map from token ID to their corresponding auction.
670     mapping (uint256 => Auction) tokenIdToAuction;
671 
672     event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
673     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
674     event AuctionCancelled(uint256 tokenId);
675 
676     /// @dev Returns true if the claimant owns the token.
677     /// @param _claimant - Address claiming to own the token.
678     /// @param _tokenId - ID of token whose ownership to verify.
679     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
680         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
681     }
682 
683     /// @dev Escrows the NFT, assigning ownership to this contract.
684     /// Throws if the escrow fails.
685     /// @param _owner - Current owner address of token to escrow.
686     /// @param _tokenId - ID of token whose approval to verify.
687     function _escrow(address _owner, uint256 _tokenId) internal {
688         // it will throw if transfer fails
689         nonFungibleContract.transferFrom(_owner, this, _tokenId);
690     }
691 
692     /// @dev Transfers an NFT owned by this contract to another address.
693     /// Returns true if the transfer succeeds.
694     /// @param _receiver - Address to transfer NFT to.
695     /// @param _tokenId - ID of token to transfer.
696     function _transfer(address _receiver, uint256 _tokenId) internal {
697         // it will throw if transfer fails
698         nonFungibleContract.transfer(_receiver, _tokenId);
699     }
700 
701     /// @dev Adds an auction to the list of open auctions. Also fires the
702     ///  AuctionCreated event.
703     /// @param _tokenId The ID of the token to be put on auction.
704     /// @param _auction Auction to add.
705     function _addAuction(uint256 _tokenId, Auction _auction) internal {
706         // Require that all auctions have a duration of
707         // at least one minute. (Keeps our math from getting hairy!)
708         require(_auction.duration >= 1 minutes);
709 
710         tokenIdToAuction[_tokenId] = _auction;
711 
712         emit AuctionCreated(
713             uint256(_tokenId),
714             uint256(_auction.startingPrice),
715             uint256(_auction.endingPrice),
716             uint256(_auction.duration)
717         );
718     }
719 
720     /// @dev Cancels an auction unconditionally.
721     function _cancelAuction(uint256 _tokenId, address _seller) internal {
722         _removeAuction(_tokenId);
723         _transfer(_seller, _tokenId);
724         emit AuctionCancelled(_tokenId);
725     }
726 
727     /// @dev Computes the price and transfers winnings.
728     /// Does NOT transfer ownership of token.
729     function _bid(uint256 _tokenId, uint256 _bidAmount)
730         internal
731         returns (uint256)
732     {
733         // Get a reference to the auction struct
734         Auction storage auction = tokenIdToAuction[_tokenId];
735 
736         // Explicitly check that this auction is currently live.
737         // (Because of how Ethereum mappings work, we can't just count
738         // on the lookup above failing. An invalid _tokenId will just
739         // return an auction object that is all zeros.)
740         require(_isOnAuction(auction));
741 
742         // Check that the bid is greater than or equal to the current price
743         uint256 price = _currentPrice(auction);
744         require(_bidAmount >= price);
745 
746         // Grab a reference to the seller before the auction struct
747         // gets deleted.
748         address seller = auction.seller;
749 
750         // The bid is good! Remove the auction before sending the fees
751         // to the sender so we can't have a reentrancy attack.
752         _removeAuction(_tokenId);
753 
754         // Transfer proceeds to seller (if there are any!)
755         if (price > 0) {
756             // Calculate the auctioneer's cut.
757             // (NOTE: _computeCut() is guaranteed to return a
758             // value <= price, so this subtraction can't go negative.)
759             uint256 auctioneerCut = _computeCut(price);
760             uint256 sellerProceeds = price - auctioneerCut;
761 
762             // NOTE: Doing a transfer() in the middle of a complex
763             // method like this is generally discouraged because of
764             // reentrancy attacks and DoS attacks if the seller is
765             // a contract with an invalid fallback function. We explicitly
766             // guard against reentrancy attacks by removing the auction
767             // before calling transfer(), and the only thing the seller
768             // can DoS is the sale of their own asset! (And if it's an
769             // accident, they can call cancelAuction(). )
770             seller.transfer(sellerProceeds);
771         }
772 
773         // Calculate any excess funds included with the bid. If the excess
774         // is anything worth worrying about, transfer it back to bidder.
775         // NOTE: We checked above that the bid amount is greater than or
776         // equal to the price so this cannot underflow.
777         uint256 bidExcess = _bidAmount - price;
778 
779         // Return the funds. Similar to the previous transfer, this is
780         // not susceptible to a re-entry attack because the auction is
781         // removed before any transfers occur.
782         msg.sender.transfer(bidExcess);
783 
784         // Tell the world!
785         emit AuctionSuccessful(_tokenId, price, msg.sender);
786 
787         return price;
788     }
789 
790     /// @dev Removes an auction from the list of open auctions.
791     /// @param _tokenId - ID of NFT on auction.
792     function _removeAuction(uint256 _tokenId) internal {
793         delete tokenIdToAuction[_tokenId];
794     }
795 
796     /// @dev Returns true if the NFT is on auction.
797     /// @param _auction - Auction to check.
798     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
799         return (_auction.startedAt > 0);
800     }
801 
802     /// @dev Returns current price of an NFT on auction. Broken into two
803     ///  functions (this one, that computes the duration from the auction
804     ///  structure, and the other that does the price computation) so we
805     ///  can easily test that the price computation works correctly.
806     function _currentPrice(Auction storage _auction)
807         internal
808         view
809         returns (uint256)
810     {
811         uint256 secondsPassed = 0;
812 
813         // A bit of insurance against negative values (or wraparound).
814         // Probably not necessary (since Ethereum guarnatees that the
815         // now variable doesn't ever go backwards).
816         if (now > _auction.startedAt) {
817             secondsPassed = now - _auction.startedAt;
818         }
819 
820         return _computeCurrentPrice(
821             _auction.startingPrice,
822             _auction.endingPrice,
823             _auction.duration,
824             secondsPassed
825         );
826     }
827 
828     /// @dev Computes the current price of an auction. Factored out
829     ///  from _currentPrice so we can run extensive unit tests.
830     ///  When testing, make this function public and turn on
831     ///  `Current price computation` test suite.
832     function _computeCurrentPrice(
833         uint256 _startingPrice,
834         uint256 _endingPrice,
835         uint256 _duration,
836         uint256 _secondsPassed
837     )
838         internal
839         pure
840         returns (uint256)
841     {
842         // NOTE: We don't use SafeMath (or similar) in this function because
843         //  all of our public functions carefully cap the maximum values for
844         //  time (at 64-bits) and currency (at 128-bits). _duration is
845         //  also known to be non-zero (see the require() statement in
846         //  _addAuction())
847         if (_secondsPassed >= _duration) {
848             // We've reached the end of the dynamic pricing portion
849             // of the auction, just return the end price.
850             return _endingPrice;
851         } else {
852             // Starting price can be higher than ending price (and often is!), so
853             // this delta can be negative.
854             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
855 
856             // This multiplication can't overflow, _secondsPassed will easily fit within
857             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
858             // will always fit within 256-bits.
859             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
860 
861             // currentPriceChange can be negative, but if so, will have a magnitude
862             // less that _startingPrice. Thus, this result will always end up positive.
863             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
864 
865             return uint256(currentPrice);
866         }
867     }
868 
869     /// @dev Computes owner's cut of a sale.
870     /// @param _price - Sale price of NFT.
871     function _computeCut(uint256 _price) internal view returns (uint256) {
872         // NOTE: We don't use SafeMath (or similar) in this function because
873         //  all of our entry functions carefully cap the maximum values for
874         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
875         //  statement in the ClockAuction constructor). The result of this
876         //  function is always guaranteed to be <= _price.
877         return _price * ownerCut / 10000;
878     }
879 
880 }
881 
882 
883 
884 /**
885  * @title Pausable
886  * @dev Base contract which allows children to implement an emergency stop mechanism.
887  */
888 contract Pausable is Ownable {
889     event Pause();
890     event Unpause();
891 
892     bool public paused = false;
893 
894 
895     /**
896      * @dev modifier to allow actions only when the contract IS paused
897      */
898     modifier whenNotPaused() {
899         require(!paused);
900         _;
901     }
902 
903     /**
904      * @dev modifier to allow actions only when the contract IS NOT paused
905      */
906     modifier whenPaused {
907         require(paused);
908         _;
909     }
910 
911     /**
912      * @dev called by the owner to pause, triggers stopped state
913      */
914     function pause() onlyOwner whenNotPaused public returns (bool) {
915         paused = true;
916         emit Pause();
917         return true;
918     }
919 
920     /**
921      * @dev called by the owner to unpause, returns to normal state
922      */
923     function unpause() onlyOwner whenPaused public returns (bool) {
924         paused = false;
925         emit Unpause();
926         return true;
927     }
928 }
929 
930 
931 
932 /// @title Clock auction for non-fungible tokens.
933 /// @notice We omit a fallback function to prevent accidental sends to this contract.
934 contract ClockAuction is Pausable, ClockAuctionBase {
935 
936     /// @dev The ERC-165 interface signature for ERC-721.
937     ///  Ref: https://github.com/ethereum/EIPs/issues/165
938     ///  Ref: https://github.com/ethereum/EIPs/issues/721
939     bytes4 constant InterfaceSignature_ERC721 = bytes4(0x9a20483d);
940 
941     /// @dev Constructor creates a reference to the NFT ownership contract
942     ///  and verifies the owner cut is in the valid range.
943     /// @param _nftAddress - address of a deployed contract implementing
944     ///  the Nonfungible Interface.
945     /// @param _cut - percent cut the owner takes on each auction, must be
946     ///  between 0-10,000.
947     //function ClockAuction(address _nftAddress, uint256 _cut) public {
948     constructor (address _nftAddress, uint256 _cut) public {    
949         require(_cut <= 10000);
950         ownerCut = _cut;
951 
952         ERC721 candidateContract = ERC721(_nftAddress);
953         require(candidateContract.supportsInterface(InterfaceSignature_ERC721));
954         nonFungibleContract = candidateContract;
955     }
956 
957     /// @dev Remove all Ether from the contract, which is the owner's cuts
958     ///  as well as any Ether sent directly to the contract address.
959     ///  Always transfers to the NFT contract, but can be called either by
960     ///  the owner or the NFT contract.
961     function withdrawBalance() external {
962         address nftAddress = address(nonFungibleContract);
963 
964         require(
965             msg.sender == owner ||
966             msg.sender == nftAddress
967         );
968         // We are using this boolean method to make sure that even if one fails it will still work
969         uint256 balance = address(this).balance;
970         nftAddress.transfer(balance);
971     }
972 
973     /// @dev Creates and begins a new auction.
974     /// @param _tokenId - ID of token to auction, sender must be owner.
975     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
976     /// @param _endingPrice - Price of item (in wei) at end of auction.
977     /// @param _duration - Length of time to move between starting
978     ///  price and ending price (in seconds).
979     /// @param _seller - Seller, if not the message sender
980     function createAuction(
981         uint256 _tokenId,
982         uint256 _startingPrice,
983         uint256 _endingPrice,
984         uint256 _duration,
985         address _seller
986     )
987         external
988         whenNotPaused
989     {
990         // Sanity check that no inputs overflow how many bits we've allocated
991         // to store them in the auction struct.
992         require(_startingPrice == uint256(uint128(_startingPrice)));
993         require(_endingPrice == uint256(uint128(_endingPrice)));
994         require(_duration == uint256(uint64(_duration)));
995 
996         require(_owns(msg.sender, _tokenId));
997         _escrow(msg.sender, _tokenId);
998         Auction memory auction = Auction(
999             _seller,
1000             uint128(_startingPrice),
1001             uint128(_endingPrice),
1002             uint64(_duration),
1003             uint64(now)
1004         );
1005         _addAuction(_tokenId, auction);
1006     }
1007 
1008     /// @dev Bids on an open auction, completing the auction and transferring
1009     ///  ownership of the NFT if enough Ether is supplied.
1010     /// @param _tokenId - ID of token to bid on.
1011     function bid(uint256 _tokenId)
1012         external
1013         payable
1014         whenNotPaused
1015     {
1016         // _bid will throw if the bid or funds transfer fails
1017         _bid(_tokenId, msg.value);
1018         _transfer(msg.sender, _tokenId);
1019     }
1020 
1021     /// @dev Cancels an auction that hasn't been won yet.
1022     ///  Returns the NFT to original owner.
1023     /// @notice This is a state-modifying function that can
1024     ///  be called while the contract is paused.
1025     /// @param _tokenId - ID of token on auction
1026     function cancelAuction(uint256 _tokenId)
1027         external
1028     {
1029         Auction storage auction = tokenIdToAuction[_tokenId];
1030         require(_isOnAuction(auction));
1031         address seller = auction.seller;
1032         require(msg.sender == seller);
1033         _cancelAuction(_tokenId, seller);
1034     }
1035 
1036     /// @dev Cancels an auction when the contract is paused.
1037     ///  Only the owner may do this, and NFTs are returned to
1038     ///  the seller. This should only be used in emergencies.
1039     /// @param _tokenId - ID of the NFT on auction to cancel.
1040     function cancelAuctionWhenPaused(uint256 _tokenId)
1041         whenPaused
1042         onlyOwner
1043         external
1044     {
1045         Auction storage auction = tokenIdToAuction[_tokenId];
1046         require(_isOnAuction(auction));
1047         _cancelAuction(_tokenId, auction.seller);
1048     }
1049 
1050     /// @dev Returns auction info for an NFT on auction.
1051     /// @param _tokenId - ID of NFT on auction.
1052     function getAuction(uint256 _tokenId)
1053         external
1054         view
1055         returns
1056     (
1057         address seller,
1058         uint256 startingPrice,
1059         uint256 endingPrice,
1060         uint256 duration,
1061         uint256 startedAt
1062     ) {
1063         Auction storage auction = tokenIdToAuction[_tokenId];
1064         require(_isOnAuction(auction));
1065         return (
1066             auction.seller,
1067             auction.startingPrice,
1068             auction.endingPrice,
1069             auction.duration,
1070             auction.startedAt
1071         );
1072     }
1073 
1074     /// @dev Returns the current price of an auction.
1075     /// @param _tokenId - ID of the token price we are checking.
1076     function getCurrentPrice(uint256 _tokenId)
1077         external
1078         view
1079         returns (uint256)
1080     {
1081         Auction storage auction = tokenIdToAuction[_tokenId];
1082         require(_isOnAuction(auction));
1083         return _currentPrice(auction);
1084     }
1085 
1086 }
1087 
1088 
1089 
1090 
1091 /// @title Clock auction modified for sale of kitties
1092 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1093 contract SaleClockAuction is ClockAuction {
1094 
1095     // @dev Sanity check that allows us to ensure that we are pointing to the
1096     //  right auction in our setSaleAuctionAddress() call.
1097     bool public isSaleClockAuction = true;
1098 
1099     // Tracks last 5 sale price of gen0 kitty sales
1100     uint256 public gen0SaleCount;
1101     uint256[5] public lastGen0SalePrices;
1102 
1103     // Delegate constructor
1104     //function SaleClockAuction(address _nftAddr, uint256 _cut) public
1105     constructor (address _nftAddr, uint256 _cut) public
1106         ClockAuction(_nftAddr, _cut) {}
1107 
1108     /// @dev Creates and begins a new auction.
1109     /// @param _tokenId - ID of token to auction, sender must be owner.
1110     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
1111     /// @param _endingPrice - Price of item (in wei) at end of auction.
1112     /// @param _duration - Length of auction (in seconds).
1113     /// @param _seller - Seller, if not the message sender
1114     function createAuction(
1115         uint256 _tokenId,
1116         uint256 _startingPrice,
1117         uint256 _endingPrice,
1118         uint256 _duration,
1119         address _seller
1120     )
1121         external
1122     {
1123         // Sanity check that no inputs overflow how many bits we've allocated
1124         // to store them in the auction struct.
1125         require(_startingPrice == uint256(uint128(_startingPrice)));
1126         require(_endingPrice == uint256(uint128(_endingPrice)));
1127         require(_duration == uint256(uint64(_duration)));
1128 
1129         require(msg.sender == address(nonFungibleContract));
1130         _escrow(_seller, _tokenId);
1131         Auction memory auction = Auction(
1132             _seller,
1133             uint128(_startingPrice),
1134             uint128(_endingPrice),
1135             uint64(_duration),
1136             uint64(now)
1137         );
1138         _addAuction(_tokenId, auction);
1139     }
1140 
1141     /// @dev Updates lastSalePrice if seller is the nft contract
1142     /// Otherwise, works the same as default bid method.
1143     function bid(uint256 _tokenId)
1144         external
1145         payable
1146     {
1147         // _bid verifies token ID size
1148         address seller = tokenIdToAuction[_tokenId].seller;
1149         uint256 price = _bid(_tokenId, msg.value);
1150         _transfer(msg.sender, _tokenId);
1151 
1152         // If not a gen0 auction, exit
1153         if (seller == address(nonFungibleContract)) {
1154             // Track gen0 sale prices
1155             lastGen0SalePrices[gen0SaleCount % 5] = price;
1156             gen0SaleCount++;
1157         }
1158     }
1159 
1160     function averageGen0SalePrice() external view returns (uint256) {
1161         uint256 sum = 0;
1162         for (uint256 i = 0; i < 5; i++) {
1163             sum += lastGen0SalePrices[i];
1164         }
1165         return sum / 5;
1166     }
1167 
1168 }
1169 
1170 
1171 
1172 
1173 
1174 /// @title Handles creating auctions for sale and siring of kitties.
1175 ///  This wrapper of ReverseAuction exists only so that users can create
1176 ///  auctions with only one transaction.
1177 contract PetAuction is PetOwnership {
1178 
1179     // @notice The auction contract variables are defined in KittyBase to allow
1180     //  us to refer to them in KittyOwnership to prevent accidental transfers.
1181     // `saleAuction` refers to the auction for gen0 and p2p sale of kitties.
1182     // `siringAuction` refers to the auction for siring rights of kitties.
1183 
1184     /// @dev Sets the reference to the sale auction.
1185     /// @param _address - Address of sale contract.
1186     function setSaleAuctionAddress(address _address) external onlyCEO {
1187         SaleClockAuction candidateContract = SaleClockAuction(_address);
1188 
1189         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
1190         require(candidateContract.isSaleClockAuction());
1191 
1192         // Set the new contract address
1193         saleAuction = candidateContract;
1194     }
1195 
1196 
1197     /// @dev Put a kitty up for auction.
1198     ///  Does some ownership trickery to create auctions in one tx.
1199     function createSaleAuction(
1200         uint256 _petId,
1201         uint256 _startingPrice,
1202         uint256 _endingPrice,
1203         uint256 _duration
1204     )
1205         external
1206         whenNotPaused
1207     {
1208         // Auction contract checks input sizes
1209         // If kitty is already on any auction, this will throw
1210         // because it will be owned by the auction contract.
1211         require(_owns(msg.sender, _petId));
1212         
1213 
1214 
1215         _approve(_petId, saleAuction);
1216         // Sale auction throws if inputs are invalid and clears
1217         // transfer and sire approval after escrowing the kitty.
1218         saleAuction.createAuction(
1219             _petId,
1220             _startingPrice,
1221             _endingPrice,
1222             _duration,
1223             msg.sender
1224         );
1225     }    
1226 
1227 
1228     /// @dev Transfers the balance of the sale auction contract
1229     /// to the KittyCore contract. We use two-step withdrawal to
1230     /// prevent two transfer calls in the auction bid function.
1231     function withdrawAuctionBalances() external onlyCLevel {
1232         saleAuction.withdrawBalance();
1233     }
1234 }
1235 
1236 	
1237 /// @title all functions related to creating kittens
1238 contract PetMinting is PetAuction {
1239 
1240     // Limits the number of cats the contract owner can ever create.
1241     uint256 public constant PROMO_CREATION_LIMIT = 5000;
1242     uint256 public constant GEN0_CREATION_LIMIT = 45000;
1243 
1244     // Constants for gen0 auctions.
1245     uint256 public constant GEN0_STARTING_PRICE = 100 szabo; //1 finney;
1246     uint256 public constant GEN0_AUCTION_DURATION = 14 days;
1247 
1248 
1249     // Counts the number of cats the contract owner has created.
1250     uint256 public promoCreatedCount;
1251     uint256 public gen0CreatedCount;
1252 
1253     /// @dev we can create promo kittens, up to a limit. Only callable by COO
1254     /// @param _genes the encoded genes of the kitten to be created, any value is accepted
1255     /// @param _owner the future owner of the created kittens. Default to contract COO
1256     function createPromoPet(uint256 _genes, address _owner, uint256 _grade, uint256 _level, uint256 _params, uint256 _skills) external onlyCOO {
1257         address petOwner = _owner;
1258         if (petOwner == address(0)) {
1259             petOwner = cooAddress;
1260         }
1261         require(promoCreatedCount < PROMO_CREATION_LIMIT);
1262 
1263         promoCreatedCount++;
1264         _createPet(0, _genes, petOwner, _grade, _level, _params, _skills);
1265     }
1266 
1267     /// @dev Creates a new gen0 kitty with the given genes and
1268     ///  creates an auction for it.
1269     function createGen0Auction(uint256 _genes, uint256 _grade, uint256 _level, uint256 _params, uint256 _skills) external onlyCOO {
1270         require(gen0CreatedCount < GEN0_CREATION_LIMIT);
1271 
1272         uint256 petId = _createPet(0, _genes, address(this), _grade, _level, _params, _skills);
1273         _approve(petId, saleAuction);
1274 
1275         saleAuction.createAuction(
1276             petId,
1277             GEN0_STARTING_PRICE,
1278             0,
1279             GEN0_AUCTION_DURATION,
1280             address(this)
1281         );
1282 
1283         gen0CreatedCount++;
1284     }
1285 
1286 }
1287 	
1288 	
1289 	
1290 /// @title CryptoKitties: Collectible, breedable, and oh-so-adorable cats on the Ethereum blockchain.
1291 /// @author Axiom Zen (https://www.axiomzen.co)
1292 /// @dev The main CryptoKitties contract, keeps track of kittens so they don't wander around and get lost.
1293 contract PetCore is PetMinting {
1294 
1295     // This is the main CryptoKitties contract. In order to keep our code seperated into logical sections,
1296     // we've broken it up in two ways. First, we have several seperately-instantiated sibling contracts
1297     // that handle auctions and our super-top-secret genetic combination algorithm. The auctions are
1298     // seperate since their logic is somewhat complex and there's always a risk of subtle bugs. By keeping
1299     // them in their own contracts, we can upgrade them without disrupting the main contract that tracks
1300     // kitty ownership. The genetic combination algorithm is kept seperate so we can open-source all of
1301     // the rest of our code without making it _too_ easy for folks to figure out how the genetics work.
1302     // Don't worry, I'm sure someone will reverse engineer it soon enough!
1303     //
1304     // Secondly, we break the core contract into multiple files using inheritence, one for each major
1305     // facet of functionality of CK. This allows us to keep related code bundled together while still
1306     // avoiding a single giant file with everything in it. The breakdown is as follows:
1307     //
1308     //      - KittyBase: This is where we define the most fundamental code shared throughout the core
1309     //             functionality. This includes our main data storage, constants and data types, plus
1310     //             internal functions for managing these items.
1311     //
1312     //      - KittyAccessControl: This contract manages the various addresses and constraints for operations
1313     //             that can be executed only by specific roles. Namely CEO, CFO and COO.
1314     //
1315     //      - KittyOwnership: This provides the methods required for basic non-fungible token
1316     //             transactions, following the draft ERC-721 spec (https://github.com/ethereum/EIPs/issues/721).
1317     //
1318     //      - KittyBreeding: This file contains the methods necessary to breed cats together, including
1319     //             keeping track of siring offers, and relies on an external genetic combination contract.
1320     //
1321     //      - KittyAuctions: Here we have the public methods for auctioning or bidding on cats or siring
1322     //             services. The actual auction functionality is handled in two sibling contracts (one
1323     //             for sales and one for siring), while auction creation and bidding is mostly mediated
1324     //             through this facet of the core contract.
1325     //
1326     //      - KittyMinting: This final facet contains the functionality we use for creating new gen0 cats.
1327     //             We can make up to 5000 "promo" cats that can be given away (especially important when
1328     //             the community is new), and all others can only be created and then immediately put up
1329     //             for auction via an algorithmically determined starting price. Regardless of how they
1330     //             are created, there is a hard limit of 50k gen0 cats. After that, it's all up to the
1331     //             community to breed, breed, breed!
1332 
1333     // Set in case the core contract is broken and an upgrade is required
1334     address public newContractAddress;
1335 
1336     /// @notice Creates the main CryptoKitties smart contract instance.
1337     //function PetCore() public {
1338     constructor() public {
1339         // Starts paused.
1340         paused = true;
1341 
1342         // the creator of the contract is the initial CEO
1343         ceoAddress = msg.sender;
1344 
1345         // the creator of the contract is also the initial COO
1346         cooAddress = msg.sender;
1347 
1348         // start with the mythical catdog 0 - so we don't have generation-0 parent issues
1349         _createPet(0, uint256(-1), address(0), uint256(-1), uint256(-1), uint256(-1), uint256(-1));
1350     }
1351 
1352     /// @dev Used to mark the smart contract as upgraded, in case there is a serious
1353     ///  breaking bug. This method does nothing but keep track of the new contract and
1354     ///  emit a message indicating that the new address is set. It's up to clients of this
1355     ///  contract to update to the new contract address in that case. (This contract will
1356     ///  be paused indefinitely if such an upgrade takes place.)
1357     /// @param _v2Address new address
1358     function setNewAddress(address _v2Address) external onlyCEO whenPaused {
1359         // See README.md for updgrade plan
1360         newContractAddress = _v2Address;
1361         emit ContractUpgrade(_v2Address);
1362     }
1363 
1364     /// @notice No tipping!
1365     /// @dev Reject all Ether from being sent here, unless it's from one of the
1366     ///  two auction contracts. (Hopefully, we can prevent user accidents.)
1367     function() external payable {
1368         require(
1369             msg.sender == address(saleAuction) 
1370         );
1371     }
1372 
1373     /// @notice Returns all the relevant information about a specific kitty.
1374     /// @param _id The ID of the kitty of interest.
1375     function getPet(uint256 _id)
1376         external
1377         view
1378         returns (
1379         uint256 birthTime,
1380         uint256 generation,
1381         uint256 genes,
1382         uint256 grade,
1383         uint256 level,
1384         uint256 params,
1385         uint256 skills
1386     ) {
1387         Pet storage pet = pets[_id];
1388 
1389         // if this variable is 0 then it's not gestating
1390         birthTime = uint256(pet.birthTime);
1391         generation = uint256(pet.generation);
1392         genes = pet.genes;
1393         grade = pet.grade;
1394         level = pet.level;
1395         params = pet.params;
1396         skills = pet.skills;
1397     }
1398 
1399     /// @dev Override unpause so it requires all external contract addresses
1400     ///  to be set before contract can be unpaused. Also, we can't have
1401     ///  newContractAddress set either, because then the contract was upgraded.
1402     /// @notice This is public rather than external so we can call super.unpause
1403     ///  without using an expensive CALL.
1404     function unpause() public onlyCEO whenPaused {
1405         require(saleAuction != address(0));
1406         require(newContractAddress == address(0));
1407 
1408         // Actually unpause the contract.
1409         super.unpause();
1410     }
1411 
1412     // @dev Allows the CFO to capture the balance available to the contract.
1413     function withdrawBalance() external onlyCFO {
1414         uint256 balance = address(this).balance;
1415         cfoAddress.transfer(balance);        
1416     }
1417 
1418     // @dev Allows the CFO to capture the balance available to the contract.
1419     function withdrawBalanceCut(uint256 amount) external onlyCFO {
1420         uint256 balance = address(this).balance;
1421         require (balance > amount);
1422 
1423         cfoAddress.transfer(amount);        
1424     }
1425 }