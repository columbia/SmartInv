1 pragma solidity ^0.4.25;
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
82 
83 
84 
85 
86 
87 /// @title A facet of ArtCore that manages special access privileges.
88 /// @author Axiom Zen (https://www.axiomzen.co)
89 /// @dev See the ArtCore contract documentation to understand how the various contract facets are arranged.
90 contract ArtAccessControl {
91     // This facet controls access control for CryptoKitties. There are four roles managed here:
92     //
93     //     - The CEO: The CEO can reassign other roles and change the addresses of our dependent smart
94     //         contracts. It is also the only role that can unpause the smart contract. It is initially
95     //         set to the address that created the smart contract in the ArtCore constructor.
96     //
97     //     - The CFO: The CFO can withdraw funds from ArtCore and its auction contracts.
98     //
99     //     - The COO: The COO can release gen0 kitties to auction, and mint promo cats.
100     //
101     // It should be noted that these roles are distinct without overlap in their access abilities, the
102     // abilities listed for each role above are exhaustive. In particular, while the CEO can assign any
103     // address to any role, the CEO address itself doesn't have the ability to act in those roles. This
104     // restriction is intentional so that we aren't tempted to use the CEO address frequently out of
105     // convenience. The less we use an address, the less likely it is that we somehow compromise the
106     // account.
107 
108     /// @dev Emited when contract is upgraded - See README.md for updgrade plan
109     event ContractUpgrade(address newContract);
110 
111     // The addresses of the accounts (or contracts) that can execute actions within each roles.
112     address public ceoAddress;
113     address public cfoAddress;
114     address public cooAddress;
115 
116     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
117     bool public paused = false;
118 
119     /// @dev Access modifier for CEO-only functionality
120     modifier onlyCEO() {
121         require(msg.sender == ceoAddress);
122         _;
123     }
124 
125     /// @dev Access modifier for CFO-only functionality
126     modifier onlyCFO() {
127         require(msg.sender == cfoAddress);
128         _;
129     }
130 
131     /// @dev Access modifier for COO-only functionality
132     modifier onlyCOO() {
133         require(msg.sender == cooAddress);
134         _;
135     }
136 
137     modifier onlyCLevel() {
138         require(
139             msg.sender == cooAddress ||
140             msg.sender == ceoAddress ||
141             msg.sender == cfoAddress
142         );
143         _;
144     }
145 
146     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
147     /// @param _newCEO The address of the new CEO
148     function setCEO(address _newCEO) external onlyCEO {
149         require(_newCEO != address(0));
150 
151         ceoAddress = _newCEO;
152     }
153 
154     /// @dev Assigns a new address to act as the CFO. Only available to the current CEO.
155     /// @param _newCFO The address of the new CFO
156     function setCFO(address _newCFO) external onlyCEO {
157         require(_newCFO != address(0));
158 
159         cfoAddress = _newCFO;
160     }
161 
162     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
163     /// @param _newCOO The address of the new COO
164     function setCOO(address _newCOO) external onlyCEO {
165         require(_newCOO != address(0));
166 
167         cooAddress = _newCOO;
168     }
169 
170     /*** Pausable functionality adapted from OpenZeppelin ***/
171 
172     /// @dev Modifier to allow actions only when the contract IS NOT paused
173     modifier whenNotPaused() {
174         require(!paused);
175         _;
176     }
177 
178     /// @dev Modifier to allow actions only when the contract IS paused
179     modifier whenPaused {
180         require(paused);
181         _;
182     }
183 
184     /// @dev Called by any "C-level" role to pause the contract. Used only when
185     ///  a bug or exploit is detected and we need to limit damage.
186     function pause() external onlyCLevel whenNotPaused {
187         paused = true;
188     }
189 
190     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
191     ///  one reason we may pause the contract is when CFO or COO accounts are
192     ///  compromised.
193     /// @notice This is public rather than external so it can be called by
194     ///  derived contracts.
195     function unpause() public onlyCEO whenPaused {
196         // can't unpause if contract was upgraded
197         paused = false;
198     }
199 }
200 
201 
202 
203 
204 /// @title Base contract for CryptoKitties. Holds all common structs, events and base variables.
205 /// @author Axiom Zen (https://www.axiomzen.co)
206 /// @dev See the ArtCore contract documentation to understand how the various contract facets are arranged.
207 contract ArtBase is ArtAccessControl {
208     /*** EVENTS ***/
209 
210     /// @dev The Birth event is fired whenever a new kitten comes into existence. This obviously
211     ///  includes any time a cat is created through the giveBirth method, but it is also called
212     ///  when a new gen0 cat is created.
213     event Create(address owner, uint256 artId, uint16 generator);
214 
215     /// @dev Transfer event as defined in current draft of ERC721. Emitted every time a kitten
216     ///  ownership is assigned, including births.
217     event Transfer(address from, address to, uint256 tokenId);
218 
219     event Vote(uint16 candidate, uint256 voteCount, uint16 currentGenerator, uint256 currentGeneratorVoteCount);
220     event NewRecipient(address recipient, uint256 position);
221     event NewGenerator(uint256 position);
222 
223     /*** DATA TYPES ***/
224 
225     /// @dev The main Art struct. Every cat in CryptoKitties is represented by a copy
226     ///  of this structure, so great care was taken to ensure that it fits neatly into
227     ///  exactly two 256-bit words. Note that the order of the members in this structure
228     ///  is important because of the byte-packing rules used by Ethereum.
229     ///  Ref: http://solidity.readthedocs.io/en/develop/miscellaneous.html
230     struct ArtToken {
231         // The timestamp from the block when this cat came into existence.
232         uint64 birthTime;
233         // The "generator" of this art token.
234         uint16 generator;
235     }
236 
237     /*** STORAGE ***/
238 
239     /// @dev An array containing the Art struct for all Kitties in existence. The ID
240     ///  of each cat is actually an index into this array. Note that ID 0 is a negacat,
241     ///  the unArt, the mythical beast that is the parent of all gen0 cats. A bizarre
242     ///  creature that is both matron and sire... to itself! Has an invalid genetic code.
243     ///  In other words, cat ID 0 is invalid... ;-)
244     ArtToken[] artpieces;
245 
246     /// @dev A mapping from cat IDs to the address that owns them. All cats have
247     ///  some valid owner address, even gen0 cats are created with a non-zero owner.
248     mapping (uint256 => address) public artIndexToOwner;
249 
250     // @dev A mapping from owner address to count of tokens that address owns.
251     //  Used internally inside balanceOf() to resolve ownership count.
252     mapping (address => uint256) ownershipTokenCount;
253 
254     /// @dev A mapping from ArtIDs to an address that has been approved to call
255     ///  transferFrom(). Each Art can only have one approved address for transfer
256     ///  at any time. A zero value means no approval is outstanding.
257     mapping (uint256 => address) public artIndexToApproved;
258 
259 
260     /// @dev Assigns ownership of a specific Art to an address.
261     function _transfer(address _from, address _to, uint256 _tokenId) internal {
262         // Since the number of kittens is capped to 2^32 we can't overflow this
263         ownershipTokenCount[_to]++;
264         // transfer ownership
265         artIndexToOwner[_tokenId] = _to;
266         // When creating new kittens _from is 0x0, but we can't account that address.
267         if (_from != address(0)) {
268             ownershipTokenCount[_from]--;
269             // clear any previously approved ownership exchange
270             delete artIndexToApproved[_tokenId];
271         }
272         // Emit the transfer event.
273         Transfer(_from, _to, _tokenId);
274     }
275 
276     /// @dev An internal method that creates a new art and stores it. This
277     ///  method doesn't do any checking and should only be called when the
278     ///  input data is known to be valid. Will generate both a Birth event
279     ///  and a Transfer event.
280     /// @param _generator The generator number of this cat, must be computed by caller.
281     /// @param _owner The inital owner of this cat, must be non-zero (except for the unArt, ID 0)
282     function _createArt(
283         uint256 _generator,
284         address _owner
285     )
286         internal
287         returns (uint)
288     {
289         // These requires are not strictly necessary, our calling code should make
290         // sure that these conditions are never broken. However! _createArt() is already
291         // an expensive call (for storage), and it doesn't hurt to be especially careful
292         // to ensure our data structures are always valid.
293         require(_generator == uint256(uint16(_generator)));
294 
295         ArtToken memory _art = ArtToken({
296             birthTime: uint64(now),
297             generator: uint16(_generator)
298         });
299         uint256 newArtId = artpieces.push(_art) - 1;
300 
301         // It's probably never going to happen, 4 billion cats is A LOT, but
302         // let's just be 100% sure we never let this happen.
303         require(newArtId == uint256(uint32(newArtId)));
304 
305         // emit the birth event
306         Create(
307             _owner,
308             newArtId,
309             _art.generator
310         );
311 
312         // This will assign ownership, and also emit the Transfer event as
313         // per ERC721 draft
314         _transfer(0, _owner, newArtId);
315 
316         return newArtId;
317     }
318 
319 }
320 
321 
322 
323 
324 
325 /// @title The external contract that is responsible for generating metadata for the kitties,
326 ///  it has one function that will return the data as bytes.
327 contract ERC721Metadata {
328     /// @dev Given a token Id, returns a byte array that is supposed to be converted into string.
329     function getMetadata(uint256 _tokenId, string) public view returns (bytes32[4] buffer, uint256 count) {
330         if (_tokenId == 1) {
331             buffer[0] = "Hello World! :D";
332             count = 15;
333         } else if (_tokenId == 2) {
334             buffer[0] = "I would definitely choose a medi";
335             buffer[1] = "um length string.";
336             count = 49;
337         } else if (_tokenId == 3) {
338             buffer[0] = "Lorem ipsum dolor sit amet, mi e";
339             buffer[1] = "st accumsan dapibus augue lorem,";
340             buffer[2] = " tristique vestibulum id, libero";
341             buffer[3] = " suscipit varius sapien aliquam.";
342             count = 128;
343         }
344     }
345 }
346 
347 
348 /// @title The facet of the CryptoKitties core contract that manages ownership, ERC-721 (draft) compliant.
349 /// @author Axiom Zen (https://www.axiomzen.co)
350 /// @dev Ref: https://github.com/ethereum/EIPs/issues/721
351 ///  See the ArtCore contract documentation to understand how the various contract facets are arranged.
352 contract ArtOwnership is ArtBase, ERC721 {
353 
354     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
355     string public constant name = "Future of Trust 2018 Art Token";
356     string public constant symbol = "FoT2018";
357 
358     // The contract that will return art metadata
359     ERC721Metadata public erc721Metadata;
360 
361     bytes4 constant InterfaceSignature_ERC165 =
362         bytes4(keccak256('supportsInterface(bytes4)'));
363 
364     bytes4 constant InterfaceSignature_ERC721 =
365         bytes4(keccak256('name()')) ^
366         bytes4(keccak256('symbol()')) ^
367         bytes4(keccak256('totalSupply()')) ^
368         bytes4(keccak256('balanceOf(address)')) ^
369         bytes4(keccak256('ownerOf(uint256)')) ^
370         bytes4(keccak256('approve(address,uint256)')) ^
371         bytes4(keccak256('transfer(address,uint256)')) ^
372         bytes4(keccak256('transferFrom(address,address,uint256)')) ^
373         bytes4(keccak256('tokensOfOwner(address)')) ^
374         bytes4(keccak256('tokenMetadata(uint256,string)'));
375 
376     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
377     ///  Returns true for any standardized interfaces implemented by this contract. We implement
378     ///  ERC-165 (obviously!) and ERC-721.
379     function supportsInterface(bytes4 _interfaceID) external view returns (bool)
380     {
381         // DEBUG ONLY
382         //require((InterfaceSignature_ERC165 == 0x01ffc9a7) && (InterfaceSignature_ERC721 == 0x9a20483d));
383 
384         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
385     }
386 
387     /// @dev Set the address of the sibling contract that tracks metadata.
388     ///  CEO only.
389     function setMetadataAddress(address _contractAddress) public onlyCEO {
390         erc721Metadata = ERC721Metadata(_contractAddress);
391     }
392 
393     // Internal utility functions: These functions all assume that their input arguments
394     // are valid. We leave it to public methods to sanitize their inputs and follow
395     // the required logic.
396 
397     /// @dev Checks if a given address is the current owner of a particular Art.
398     /// @param _claimant the address we are validating against.
399     /// @param _tokenId kitten id, only valid when > 0
400     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
401         return artIndexToOwner[_tokenId] == _claimant;
402     }
403 
404     /// @dev Checks if a given address currently has transferApproval for a particular Art.
405     /// @param _claimant the address we are confirming kitten is approved for.
406     /// @param _tokenId kitten id, only valid when > 0
407     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
408         return artIndexToApproved[_tokenId] == _claimant;
409     }
410 
411     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
412     ///  approval. Setting _approved to address(0) clears all transfer approval.
413     ///  NOTE: _approve() does NOT send the Approval event. This is intentional because
414     ///  _approve() and transferFrom() are used together for putting Kitties on auction, and
415     ///  there is no value in spamming the log with Approval events in that case.
416     function _approve(uint256 _tokenId, address _approved) internal {
417         artIndexToApproved[_tokenId] = _approved;
418     }
419 
420     /// @notice Returns the number of Kitties owned by a specific address.
421     /// @param _owner The owner address to check.
422     /// @dev Required for ERC-721 compliance
423     function balanceOf(address _owner) public view returns (uint256 count) {
424         return ownershipTokenCount[_owner];
425     }
426 
427     /// @notice Transfers a Art to another address. If transferring to a smart
428     ///  contract be VERY CAREFUL to ensure that it is aware of ERC-721 (or
429     ///  CryptoKitties specifically) or your Art may be lost forever. Seriously.
430     /// @param _to The address of the recipient, can be a user or contract.
431     /// @param _tokenId The ID of the Art to transfer.
432     /// @dev Required for ERC-721 compliance.
433     function transfer(
434         address _to,
435         uint256 _tokenId
436     )
437         external
438         whenNotPaused
439     {
440         // Safety check to prevent against an unexpected 0x0 default.
441         require(_to != address(0));
442         // Disallow transfers to this contract to prevent accidental misuse.
443         // The contract should never own any kitties (except very briefly
444         // after a gen0 cat is created and before it goes on auction).
445         require(_to != address(this));
446 
447         // You can only send your own cat.
448         require(_owns(msg.sender, _tokenId));
449 
450         // Reassign ownership, clear pending approvals, emit Transfer event.
451         _transfer(msg.sender, _to, _tokenId);
452     }
453 
454     /// @notice Grant another address the right to transfer a specific Art via
455     ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
456     /// @param _to The address to be granted transfer approval. Pass address(0) to
457     ///  clear all approvals.
458     /// @param _tokenId The ID of the Art that can be transferred if this call succeeds.
459     /// @dev Required for ERC-721 compliance.
460     function approve(
461         address _to,
462         uint256 _tokenId
463     )
464         external
465         whenNotPaused
466     {
467         // Only an owner can grant transfer approval.
468         require(_owns(msg.sender, _tokenId));
469 
470         // Register the approval (replacing any previous approval).
471         _approve(_tokenId, _to);
472 
473         // Emit approval event.
474         Approval(msg.sender, _to, _tokenId);
475     }
476 
477     /// @notice Transfer a Art owned by another address, for which the calling address
478     ///  has previously been granted transfer approval by the owner.
479     /// @param _from The address that owns the Art to be transfered.
480     /// @param _to The address that should take ownership of the Art. Can be any address,
481     ///  including the caller.
482     /// @param _tokenId The ID of the Art to be transferred.
483     /// @dev Required for ERC-721 compliance.
484     function transferFrom(
485         address _from,
486         address _to,
487         uint256 _tokenId
488     )
489         external
490         whenNotPaused
491     {
492         // Safety check to prevent against an unexpected 0x0 default.
493         require(_to != address(0));
494         // Disallow transfers to this contract to prevent accidental misuse.
495         // The contract should never own any kitties (except very briefly
496         // after a gen0 cat is created and before it goes on auction).
497         require(_to != address(this));
498         // Check for approval and valid ownership
499         require(_approvedFor(msg.sender, _tokenId));
500         require(_owns(_from, _tokenId));
501 
502         // Reassign ownership (also clears pending approvals and emits Transfer event).
503         _transfer(_from, _to, _tokenId);
504     }
505 
506     /// @notice Returns the total number of Kitties currently in existence.
507     /// @dev Required for ERC-721 compliance.
508     function totalSupply() public view returns (uint) {
509         return artpieces.length - 1;
510     }
511 
512     /// @notice Returns the address currently assigned ownership of a given Art.
513     /// @dev Required for ERC-721 compliance.
514     function ownerOf(uint256 _tokenId)
515         external
516         view
517         returns (address owner)
518     {
519         owner = artIndexToOwner[_tokenId];
520 
521         require(owner != address(0));
522     }
523 
524     /// @notice Returns a list of all Art IDs assigned to an address.
525     /// @param _owner The owner whose Kitties we are interested in.
526     /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
527     ///  expensive (it walks the entire Art array looking for cats belonging to owner),
528     ///  but it also returns a dynamic array, which is only supported for web3 calls, and
529     ///  not contract-to-contract calls.
530     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
531         uint256 tokenCount = balanceOf(_owner);
532 
533         if (tokenCount == 0) {
534             // Return an empty array
535             return new uint256[](0);
536         } else {
537             uint256[] memory result = new uint256[](tokenCount);
538             uint256 totalCats = totalSupply();
539             uint256 resultIndex = 0;
540 
541             // We count on the fact that all cats have IDs starting at 1 and increasing
542             // sequentially up to the totalCat count.
543             uint256 catId;
544 
545             for (catId = 1; catId <= totalCats; catId++) {
546                 if (artIndexToOwner[catId] == _owner) {
547                     result[resultIndex] = catId;
548                     resultIndex++;
549                 }
550             }
551 
552             return result;
553         }
554     }
555 
556     /// @dev Adapted from memcpy() by @arachnid (Nick Johnson <arachnid@notdot.net>)
557     ///  This method is licenced under the Apache License.
558     ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
559     function _memcpy(uint _dest, uint _src, uint _len) private view {
560         // Copy word-length chunks while possible
561         for(; _len >= 32; _len -= 32) {
562             assembly {
563                 mstore(_dest, mload(_src))
564             }
565             _dest += 32;
566             _src += 32;
567         }
568 
569         // Copy remaining bytes
570         uint256 mask = 256 ** (32 - _len) - 1;
571         assembly {
572             let srcpart := and(mload(_src), not(mask))
573             let destpart := and(mload(_dest), mask)
574             mstore(_dest, or(destpart, srcpart))
575         }
576     }
577 
578     /// @dev Adapted from toString(slice) by @arachnid (Nick Johnson <arachnid@notdot.net>)
579     ///  This method is licenced under the Apache License.
580     ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
581     function _toString(bytes32[4] _rawBytes, uint256 _stringLength) private view returns (string) {
582         var outputString = new string(_stringLength);
583         uint256 outputPtr;
584         uint256 bytesPtr;
585 
586         assembly {
587             outputPtr := add(outputString, 32)
588             bytesPtr := _rawBytes
589         }
590 
591         _memcpy(outputPtr, bytesPtr, _stringLength);
592 
593         return outputString;
594     }
595 
596     /// @notice Returns a URI pointing to a metadata package for this token conforming to
597     ///  ERC-721 (https://github.com/ethereum/EIPs/issues/721)
598     /// @param _tokenId The ID number of the Art whose metadata should be returned.
599     function tokenMetadata(uint256 _tokenId, string _preferredTransport) external view returns (string infoUrl) {
600         require(erc721Metadata != address(0));
601         bytes32[4] memory buffer;
602         uint256 count;
603         (buffer, count) = erc721Metadata.getMetadata(_tokenId, _preferredTransport);
604 
605         return _toString(buffer, count);
606     }
607 }
608 
609 
610 
611 /**
612  * @title Pausable
613  * @dev Base contract which allows children to implement an emergency stop mechanism.
614  */
615 contract Pausable is Ownable {
616   event Pause();
617   event Unpause();
618 
619   bool public paused = false;
620 
621 
622   /**
623    * @dev modifier to allow actions only when the contract IS paused
624    */
625   modifier whenNotPaused() {
626     require(!paused);
627     _;
628   }
629 
630   /**
631    * @dev modifier to allow actions only when the contract IS NOT paused
632    */
633   modifier whenPaused {
634     require(paused);
635     _;
636   }
637 
638   /**
639    * @dev called by the owner to pause, triggers stopped state
640    */
641   function pause() onlyOwner whenNotPaused returns (bool) {
642     paused = true;
643     Pause();
644     return true;
645   }
646 
647   /**
648    * @dev called by the owner to unpause, returns to normal state
649    */
650   function unpause() onlyOwner whenPaused returns (bool) {
651     paused = false;
652     Unpause();
653     return true;
654   }
655 }
656 
657 
658 
659 
660 
661 
662 /// @title all functions related to creating art tokens
663 contract ArtMinting is ArtOwnership {
664 
665     // Limits the number of art tokens the contract owner can ever create.
666     uint256 public constant PROMO_CREATION_LIMIT = 300;
667 
668     // Counts the number of cats the contract owner has created.
669     uint256 public promoCreatedCount;
670 
671     /// @dev we can create promo kittens, up to a limit. Only callable by COO
672     function createPromoArt() external onlyCOO {
673         // address artOwner = recipients[promoCreatedCount];
674         // if (artOwner == address(0)) {
675         //      artOwner = cooAddress;
676         // }
677         // address artOwner = cooAddress;
678         require(promoCreatedCount < PROMO_CREATION_LIMIT);
679 
680         promoCreatedCount++;
681         _createArt(curGenerator, cooAddress);
682     }
683     
684     uint256[] public votes;
685     uint16 public curGenerator = 0;
686     uint16 public maxGenerators = 3;
687     
688     function castVote(uint _generator) external {
689         require(_generator < votes.length);
690         votes[_generator] = votes[_generator] + 1;
691         if (votes[_generator] > votes[curGenerator]) {
692             curGenerator = uint16(_generator);
693         }
694         Vote(uint16(_generator), votes[_generator], curGenerator, votes[curGenerator]);
695     }
696     
697     function addGenerator() external {
698         require(votes.length < maxGenerators);
699         uint _id = votes.push(0);
700         NewGenerator(_id);
701     }
702 }
703 
704 
705 /// @title CryptoKitties: Collectible, breedable, and oh-so-adorable cats on the Ethereum blockchain.
706 /// @author Axiom Zen (https://www.axiomzen.co)
707 /// @dev The main CryptoKitties contract, keeps track of kittens so they don't wander around and get lost.
708 contract ArtCore is ArtMinting {
709 
710     // This is the main CryptoKitties contract. In order to keep our code seperated into logical sections,
711     // we've broken it up in two ways. First, we have several seperately-instantiated sibling contracts
712     // that handle auctions and our super-top-secret genetic combination algorithm. The auctions are
713     // seperate since their logic is somewhat complex and there's always a risk of subtle bugs. By keeping
714     // them in their own contracts, we can upgrade them without disrupting the main contract that tracks
715     // art ownership. The genetic combination algorithm is kept seperate so we can open-source all of
716     // the rest of our code without making it _too_ easy for folks to figure out how the genetics work.
717     // Don't worry, I'm sure someone will reverse engineer it soon enough!
718     //
719     // Secondly, we break the core contract into multiple files using inheritence, one for each major
720     // facet of functionality of CK. This allows us to keep related code bundled together while still
721     // avoiding a single giant file with everything in it. The breakdown is as follows:
722     //
723     //      - ArtBase: This is where we define the most fundamental code shared throughout the core
724     //             functionality. This includes our main data storage, constants and data types, plus
725     //             internal functions for managing these items.
726     //
727     //      - ArtAccessControl: This contract manages the various addresses and constraints for operations
728     //             that can be executed only by specific roles. Namely CEO, CFO and COO.
729     //
730     //      - ArtOwnership: This provides the methods required for basic non-fungible token
731     //             transactions, following the draft ERC-721 spec (https://github.com/ethereum/EIPs/issues/721).
732     //
733     //      - ArtBreeding: This file contains the methods necessary to breed cats together, including
734     //             keeping track of siring offers, and relies on an external genetic combination contract.
735     //
736     //      - ArtAuctions: Here we have the public methods for auctioning or bidding on cats or siring
737     //             services. The actual auction functionality is handled in two sibling contracts (one
738     //             for sales and one for siring), while auction creation and bidding is mostly mediated
739     //             through this facet of the core contract.
740     //
741     //      - ArtMinting: This final facet contains the functionality we use for creating new gen0 cats.
742     //             We can make up to 5000 "promo" cats that can be given away (especially important when
743     //             the community is new), and all others can only be created and then immediately put up
744     //             for auction via an algorithmically determined starting price. Regardless of how they
745     //             are created, there is a hard limit of 50k gen0 cats. After that, it's all up to the
746     //             community to breed, breed, breed!
747 
748     
749     /// @notice Creates the main CryptoKitties smart contract instance.
750     function ArtCore() public {
751         // Starts paused.
752         paused = true;
753 
754         // the creator of the contract is the initial CEO
755         ceoAddress = msg.sender;
756 
757         // the creator of the contract is also the initial COO
758         cooAddress = msg.sender;
759 
760         // start with the mythical kitten 0 - so we don't have generator-0 parent issues
761         _createArt(0, address(0));
762     }
763 
764 
765 
766     /// @notice No tipping!
767     /// @dev Reject all Ether from being sent here, unless it's from one of the
768     ///  two auction contracts. (Hopefully, we can prevent user accidents.)
769     function() external payable {
770         require(
771             msg.sender == address(0)
772         );
773     }
774 
775     /// @notice Returns all the relevant information about a specific art.
776     /// @param _id The ID of the art of interest.
777     function getArtToken(uint256 _id)
778         external
779         view
780         returns (
781         uint256 birthTime,
782         uint256 generator
783     ) {
784         ArtToken storage art = artpieces[_id];
785 
786         // if this variable is 0 then it's not gestating
787         birthTime = uint256(art.birthTime);
788         generator = uint256(art.generator);
789     }
790 
791     /// @dev Override unpause so it requires all external contract addresses
792     ///  to be set before contract can be unpaused. Also, we can't have
793     ///  newContractAddress set either, because then the contract was upgraded.
794     /// @notice This is public rather than external so we can call super.unpause
795     ///  without using an expensive CALL.
796     function unpause() public onlyCEO whenPaused {
797         // Actually unpause the contract.
798         super.unpause();
799     }
800 
801     // @dev Allows the CFO to capture the balance available to the contract.
802     function withdrawBalance() external onlyCFO {
803         uint256 balance = this.balance;
804         cfoAddress.send(balance);
805     }
806 }