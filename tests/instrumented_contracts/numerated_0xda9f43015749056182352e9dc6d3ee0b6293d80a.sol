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
56     // Optional methods used by ServiceStation contract
57     function tuneLambo(uint256 _newattributes, uint256 _tokenId) external;
58     function getLamboAttributes(uint256 _id) external view returns (uint256 attributes);
59     function getLamboModel(uint256 _tokenId) external view returns (uint64 _model);
60     // Events
61     event Transfer(address from, address to, uint256 tokenId);
62     event Approval(address owner, address approved, uint256 tokenId);
63 
64     // Optional
65     // function name() public view returns (string name);
66     // function symbol() public view returns (string symbol);
67     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
68     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
69 
70     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
71     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
72 }
73 
74 
75 
76 /// @title A facet of EtherLamboCore that manages special access privileges.
77 /// @author Axiom Zen (https://www.axiomzen.co) adapted by Kenny Bania
78 /// @dev ...
79 contract EtherLambosAccessControl {
80     // This facet controls access control for Etherlambos. There are four roles managed here:
81     //
82     //     - The CEO: The CEO can reassign other roles and change the addresses of our dependent smart
83     //         contracts. It is also the only role that can unpause the smart contract. It is initially
84     //         set to the address that created the smart contract in the EtherLamboCore constructor.
85     //
86     //     - The CFO: The CFO can withdraw funds from EtherLamboCore and its auction contracts.
87     //
88     //     - The COO: The COO can release new models for sale.
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
192 /// @title Base contract for EtherLambos. Holds all common structs, events and base variables.
193 /// @author Axiom Zen (https://www.axiomzen.co) adapted by Kenny Bania
194 /// @dev ...
195 contract EtherLambosBase is EtherLambosAccessControl {
196     /*** EVENTS ***/
197 
198     /// @dev The Build event is fired whenever a new car model is build by the COO
199     event Build(address owner, uint256 lamboId, uint256 attributes);
200 
201     /// @dev Transfer event as defined in current draft of ERC721. Emitted every time a car
202     ///  ownership is assigned, including builds.
203     event Transfer(address from, address to, uint256 tokenId);
204 
205     event Tune(uint256 _newattributes, uint256 _tokenId);
206     
207     /*** DATA TYPES ***/
208 
209     /// @dev The main EtherLambos struct. Every car in EtherLambos is represented by a copy
210     ///  of this structure, so great care was taken to ensure that it fits neatly into
211     ///  exactly two 256-bit words. Note that the order of the members in this structure
212     ///  is important because of the byte-packing rules used by Ethereum.
213     ///  Ref: http://solidity.readthedocs.io/en/develop/miscellaneous.html
214     struct Lambo {
215         // sports-car attributes like max speed, weight etc. are stored here.
216         // These attributes can be changed due to tuning/upgrades
217         uint256 attributes;
218 
219         // The timestamp from the block when this car came was constructed.
220         uint64 buildTime;
221         
222         // the Lambo model identifier
223         uint64 model;
224 
225     }
226 
227 
228     // An approximation of currently how many seconds are in between blocks.
229     uint256 public secondsPerBlock = 15;
230 
231     /*** STORAGE ***/
232 
233     /// @dev An array containing the Lambo struct for all Lambos in existence. The ID
234     ///  of each car is actually an index into this array. Note that 0 is invalid index.
235     Lambo[] lambos;
236 
237     /// @dev A mapping from car IDs to the address that owns them. All cars have
238     ///  some valid owner address.
239     mapping (uint256 => address) public lamboIndexToOwner;
240 
241     // @dev A mapping from owner address to count of tokens that address owns.
242     //  Used internally inside balanceOf() to resolve ownership count.
243     mapping (address => uint256) ownershipTokenCount;
244 
245     /// @dev A mapping from LamboIDs to an address that has been approved to call
246     ///  transferFrom(). Each Lambo can only have one approved address for transfer
247     ///  at any time. A zero value means no approval is outstanding.
248     mapping (uint256 => address) public lamboIndexToApproved;
249 
250     /// @dev The address of the MarketPlace contract that handles sales of Lambos. This
251     ///  same contract handles both peer-to-peer sales as well as new model sales. 
252     MarketPlace public marketPlace;
253     ServiceStation public serviceStation;
254     /// @dev Assigns ownership of a specific Lambo to an address.
255     function _transfer(address _from, address _to, uint256 _tokenId) internal {
256         // Since the number of lambos is capped to 2^32 we can't overflow this
257         ownershipTokenCount[_to]++;
258         // transfer ownership
259         lamboIndexToOwner[_tokenId] = _to;
260         // When creating new lambos _from is 0x0, but we can't account that address.
261         if (_from != address(0)) {
262             ownershipTokenCount[_from]--;
263             // clear any previously approved ownership exchange
264             delete lamboIndexToApproved[_tokenId];
265         }
266         // Emit the transfer event.
267         Transfer(_from, _to, _tokenId);
268     }
269 
270     /// @dev An internal method that creates a new lambo and stores it. This
271     ///  method doesn't do any checking and should only be called when the
272     ///  input data is known to be valid. Will generate both a Build event
273     ///  and a Transfer event.
274     /// @param _attributes The lambo's attributes.
275     /// @param _owner The inital owner of this car, must be non-zero
276     function _createLambo(
277         uint256 _attributes,
278         address _owner,
279         uint64  _model
280     )
281         internal
282         returns (uint)
283     {
284 
285         
286         Lambo memory _lambo = Lambo({
287             attributes: _attributes,
288             buildTime: uint64(now),
289             model:_model
290         });
291         uint256 newLamboId = lambos.push(_lambo) - 1;
292 
293         // It's probably never going to happen, 4 billion cars is A LOT, but
294         // let's just be 100% sure we never let this happen.
295         require(newLamboId == uint256(uint32(newLamboId)));
296 
297         // emit the build event
298         Build(
299             _owner,
300             newLamboId,
301             _lambo.attributes
302         );
303 
304         // This will assign ownership, and also emit the Transfer event as
305         // per ERC721 draft
306         _transfer(0, _owner, newLamboId);
307 
308         return newLamboId;
309     }
310      /// @dev An internal method that tunes an existing lambo. This
311     ///  method doesn't do any checking and should only be called when the
312     ///  input data is known to be valid. Will generate a Tune event
313     /// @param _newattributes The lambo's new attributes.
314     /// @param _tokenId The car to be tuned.
315     function _tuneLambo(
316         uint256 _newattributes,
317         uint256 _tokenId
318     )
319         internal
320     {
321         lambos[_tokenId].attributes=_newattributes;
322      
323         // emit the tune event
324         Tune(
325             _tokenId,
326             _newattributes
327         );
328 
329     }
330     // Any C-level can fix how many seconds per blocks are currently observed.
331     function setSecondsPerBlock(uint256 secs) external onlyCLevel {
332         //require(secs < cooldowns[0]);
333         secondsPerBlock = secs;
334     }
335 }
336 
337 /// @title The external contract that is responsible for generating metadata for the cars,
338 ///  it has one function that will return the data as bytes.
339 contract ERC721Metadata {
340     /// @dev Given a token Id, returns a byte array that is supposed to be converted into string.
341     function getMetadata(uint256 _tokenId, string) public view returns (bytes32[4] buffer, uint256 count) {
342         if (_tokenId == 1) {
343             buffer[0] = "Hello World! :D";
344             count = 15;
345         } else if (_tokenId == 2) {
346             buffer[0] = "I would definitely choose a medi";
347             buffer[1] = "um length string.";
348             count = 49;
349         } else if (_tokenId == 3) {
350             buffer[0] = "Lorem ipsum dolor sit amet, mi e";
351             buffer[1] = "st accumsan dapibus augue lorem,";
352             buffer[2] = " tristique vestibulum id, libero";
353             buffer[3] = " suscipit varius sapien aliquam.";
354             count = 128;
355         }
356     }
357 }
358 
359 /// @title The facet of the EtherLambosCore contract that manages ownership, ERC-721 (draft) compliant.
360 /// @author Axiom Zen (https://www.axiomzen.co) adapted by Cryptoknights
361 /// @dev Ref: https://github.com/ethereum/EIPs/issues/721
362 
363 contract EtherLambosOwnership is EtherLambosBase, ERC721 {
364 
365     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
366     string public constant name = "EtherLambos";
367     string public constant symbol = "EL";
368 
369     // The contract that will return lambo metadata
370     ERC721Metadata public erc721Metadata;
371 
372     bytes4 constant InterfaceSignature_ERC165 =
373         bytes4(keccak256('supportsInterface(bytes4)'));
374 
375     bytes4 constant InterfaceSignature_ERC721 =
376         bytes4(keccak256('name()')) ^
377         bytes4(keccak256('symbol()')) ^
378         bytes4(keccak256('totalSupply()')) ^
379         bytes4(keccak256('balanceOf(address)')) ^
380         bytes4(keccak256('ownerOf(uint256)')) ^
381         bytes4(keccak256('approve(address,uint256)')) ^
382         bytes4(keccak256('transfer(address,uint256)')) ^
383         bytes4(keccak256('transferFrom(address,address,uint256)')) ^
384         bytes4(keccak256('tokensOfOwner(address)')) ^
385         bytes4(keccak256('tokenMetadata(uint256,string)'));
386 
387     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
388     ///  Returns true for any standardized interfaces implemented by this contract. We implement
389     ///  ERC-165 (obviously!) and ERC-721.
390     function supportsInterface(bytes4 _interfaceID) external view returns (bool)
391     {
392         // DEBUG ONLY
393         //require((InterfaceSignature_ERC165 == 0x01ffc9a7) && (InterfaceSignature_ERC721 == 0x9a20483d));
394 
395         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
396     }
397 
398     /// @dev Set the address of the sibling contract that tracks metadata.
399     ///  CEO only.
400     function setMetadataAddress(address _contractAddress) public onlyCEO {
401         erc721Metadata = ERC721Metadata(_contractAddress);
402     }
403 
404     // Internal utility functions: These functions all assume that their input arguments
405     // are valid. We leave it to public methods to sanitize their inputs and follow
406     // the required logic.
407 
408     /// @dev Checks if a given address is the current owner of a particular Lambo.
409     /// @param _claimant the address we are validating against.
410     /// @param _tokenId kitten id, only valid when > 0
411     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
412         return lamboIndexToOwner[_tokenId] == _claimant;
413     }
414 
415     /// @dev Checks if a given address currently has transferApproval for a particular Lambo.
416     /// @param _claimant the address we are confirming Lambo is approved for.
417     /// @param _tokenId lambo id, only valid when > 0
418     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
419         return lamboIndexToApproved[_tokenId] == _claimant;
420     }
421 
422     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
423     ///  approval. Setting _approved to address(0) clears all transfer approval.
424     ///  NOTE: _approve() does NOT send the Approval event. This is intentional because
425     ///  _approve() and transferFrom() are used together for putting Lambos on sale, and
426     ///  there is no value in spamming the log with Approval events in that case.
427     function _approve(uint256 _tokenId, address _approved) internal {
428         lamboIndexToApproved[_tokenId] = _approved;
429     }
430 
431     /// @notice Returns the number of Lambos owned by a specific address.
432     /// @param _owner The owner address to check.
433     /// @dev Required for ERC-721 compliance
434     function balanceOf(address _owner) public view returns (uint256 count) {
435         return ownershipTokenCount[_owner];
436     }
437 
438     /// @notice Transfers a Lambo to another address. If transferring to a smart
439     ///  contract be VERY CAREFUL to ensure that it is aware of ERC-721 (or
440     ///  EtherLambos specifically) or your Lambo may be lost forever. Seriously.
441     /// @param _to The address of the recipient, can be a user or contract.
442     /// @param _tokenId The ID of the Lambo to transfer.
443     /// @dev Required for ERC-721 compliance.
444     function transfer(
445         address _to,
446         uint256 _tokenId
447     )
448         external
449         whenNotPaused
450     {
451         // Safety check to prevent against an unexpected 0x0 default.
452         require(_to != address(0));
453         // Disallow transfers to this contract to prevent accidental misuse.
454         // The contract should never own any lambos.
455         require(_to != address(this));
456         // Disallow transfers to the auction contracts to prevent accidental
457         // misuse. Marketplace contracts should only take ownership of Lambos
458         // through the allow + transferFrom flow.
459         require(_to != address(marketPlace));
460 
461         // You can only send your own car.
462         require(_owns(msg.sender, _tokenId));
463 
464         // Reassign ownership, clear pending approvals, emit Transfer event.
465         _transfer(msg.sender, _to, _tokenId);
466     }
467 
468     /// @notice Grant another address the right to transfer a specific Lambo via
469     ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
470     /// @param _to The address to be granted transfer approval. Pass address(0) to
471     ///  clear all approvals.
472     /// @param _tokenId The ID of the Lambo that can be transferred if this call succeeds.
473     /// @dev Required for ERC-721 compliance.
474     function approve(
475         address _to,
476         uint256 _tokenId
477     )
478         external
479         whenNotPaused
480     {
481         // Only an owner can grant transfer approval.
482         require(_owns(msg.sender, _tokenId));
483 
484         // Register the approval (replacing any previous approval).
485         _approve(_tokenId, _to);
486 
487         // Emit approval event.
488         Approval(msg.sender, _to, _tokenId);
489     }
490 
491     /// @notice Transfer a Lambo owned by another address, for which the calling address
492     ///  has previously been granted transfer approval by the owner.
493     /// @param _from The address that owns the Lambo to be transfered.
494     /// @param _to The address that should take ownership of the Lambo. Can be any address,
495     ///  including the caller.
496     /// @param _tokenId The ID of the Lambo to be transferred.
497     /// @dev Required for ERC-721 compliance.
498     function transferFrom(
499         address _from,
500         address _to,
501         uint256 _tokenId
502     )
503         external
504         whenNotPaused
505     {
506         // Safety check to prevent against an unexpected 0x0 default.
507         require(_to != address(0));
508         // Disallow transfers to this contract to prevent accidental misuse.
509         // The contract should never own any lambos.
510         require(_to != address(this));
511         // Check for approval and valid ownership
512         require(_approvedFor(msg.sender, _tokenId));
513         require(_owns(_from, _tokenId));
514 
515         // Reassign ownership (also clears pending approvals and emits Transfer event).
516         _transfer(_from, _to, _tokenId);
517     }
518 
519     /// @notice Returns the total number of Lambos currently in existence.
520     /// @dev Required for ERC-721 compliance.
521     function totalSupply() public view returns (uint) {
522         return lambos.length - 1;
523     }
524 
525     /// @notice Returns the address currently assigned ownership of a given Lambo.
526     /// @dev Required for ERC-721 compliance.
527     function ownerOf(uint256 _tokenId)
528         external
529         view
530         returns (address owner)
531     {
532         owner = lamboIndexToOwner[_tokenId];
533 
534         require(owner != address(0));
535     }
536 
537     /// @notice Returns a list of all Lambo IDs assigned to an address.
538     /// @param _owner The owner whose Lambo we are interested in.
539     /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
540     ///  expensive (it walks the entire Lambo array looking for cars belonging to owner),
541     ///  but it also returns a dynamic array, which is only supported for web3 calls, and
542     ///  not contract-to-contract calls.
543     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
544         uint256 tokenCount = balanceOf(_owner);
545 
546         if (tokenCount == 0) {
547             // Return an empty array
548             return new uint256[](0);
549         } else {
550             uint256[] memory result = new uint256[](tokenCount);
551             uint256 totalCars = totalSupply();
552             uint256 resultIndex = 0;
553 
554             // We count on the fact that all cars have IDs starting at 1 and increasing
555             // sequentially up to the totalCat count.
556             uint256 carId;
557 
558             for (carId = 1; carId <= totalCars; carId++) {
559                 if (lamboIndexToOwner[carId] == _owner) {
560                     result[resultIndex] = carId;
561                     resultIndex++;
562                 }
563             }
564 
565             return result;
566         }
567     }
568 
569     /// @dev Adapted from memcpy() by @arachnid (Nick Johnson <arachnid@notdot.net>)
570     ///  This method is licenced under the Apache License.
571     ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
572     function _memcpy(uint _dest, uint _src, uint _len) private view {
573         // Copy word-length chunks while possible
574         for(; _len >= 32; _len -= 32) {
575             assembly {
576                 mstore(_dest, mload(_src))
577             }
578             _dest += 32;
579             _src += 32;
580         }
581 
582         // Copy remaining bytes
583         uint256 mask = 256 ** (32 - _len) - 1;
584         assembly {
585             let srcpart := and(mload(_src), not(mask))
586             let destpart := and(mload(_dest), mask)
587             mstore(_dest, or(destpart, srcpart))
588         }
589     }
590 
591     /// @dev Adapted from toString(slice) by @arachnid (Nick Johnson <arachnid@notdot.net>)
592     ///  This method is licenced under the Apache License.
593     ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
594     function _toString(bytes32[4] _rawBytes, uint256 _stringLength) private view returns (string) {
595         var outputString = new string(_stringLength);
596         uint256 outputPtr;
597         uint256 bytesPtr;
598 
599         assembly {
600             outputPtr := add(outputString, 32)
601             bytesPtr := _rawBytes
602         }
603 
604         _memcpy(outputPtr, bytesPtr, _stringLength);
605 
606         return outputString;
607     }
608 
609     /// @notice Returns a URI pointing to a metadata package for this token conforming to
610     ///  ERC-721 (https://github.com/ethereum/EIPs/issues/721)
611     /// @param _tokenId The ID number of the Lambos whose metadata should be returned.
612     function tokenMetadata(uint256 _tokenId, string _preferredTransport) external view returns (string infoUrl) {
613         require(erc721Metadata != address(0));
614         bytes32[4] memory buffer;
615         uint256 count;
616         (buffer, count) = erc721Metadata.getMetadata(_tokenId, _preferredTransport);
617 
618         return _toString(buffer, count);
619     }
620 }
621 
622 
623 /// @title MarketPlace core
624 /// @dev Contains models, variables, and internal methods for the marketplace.
625 /// @notice We omit a fallback function to prevent accidental sends to this contract.
626 contract MarketPlaceBase is Ownable {
627 
628     // Represents an sale on an NFT
629     struct Sale {
630         // Current owner of NFT
631         address seller;
632         // Price (in wei) 
633         uint128 price;
634         // Time when sale started
635         // NOTE: 0 if this sale has been concluded
636         uint64 startedAt;
637     }
638     
639     struct Affiliates {
640         address affiliate_address;
641         uint64 commission;
642         uint64 pricecut;
643     }
644     
645     //Affiliates[] affiliates;
646     // Reference to contract tracking NFT ownership
647     ERC721 public nonFungibleContract;
648 
649     // Cut owner takes on each sale, measured in basis points (1/100 of a percent).
650     // Values 0-10,000 map to 0%-100%
651     uint256 public ownerCut;
652 
653     //map the Affiliate Code to the Affiliate
654     mapping (uint256 => Affiliates) codeToAffiliate;
655 
656     // Map from token ID to their corresponding sale.
657     mapping (uint256 => Sale) tokenIdToSale;
658 
659     event SaleCreated(uint256 tokenId, uint256 price);
660     event SaleSuccessful(uint256 tokenId, uint256 price, address buyer);
661     event SaleCancelled(uint256 tokenId);
662 
663     /// @dev Returns true if the claimant owns the token.
664     /// @param _claimant - Address claiming to own the token.
665     /// @param _tokenId - ID of token whose ownership to verify.
666     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
667         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
668     }
669 
670     /// @dev Escrows the NFT, assigning ownership to this contract.
671     /// Throws if the escrow fails.
672     /// @param _owner - Current owner address of token to escrow.
673     /// @param _tokenId - ID of token whose approval to verify.
674     function _escrow(address _owner, uint256 _tokenId) internal {
675         // it will throw if transfer fails
676         nonFungibleContract.transferFrom(_owner, this, _tokenId);
677     }
678 
679     /// @dev Transfers an NFT owned by this contract to another address.
680     /// Returns true if the transfer succeeds.
681     /// @param _receiver - Address to transfer NFT to.
682     /// @param _tokenId - ID of token to transfer.
683     function _transfer(address _receiver, uint256 _tokenId) internal {
684         // it will throw if transfer fails
685         nonFungibleContract.transfer(_receiver, _tokenId);
686     }
687 
688     /// @dev Adds an sale to the list of open sales. Also fires the
689     ///  SaleCreated event.
690     /// @param _tokenId The ID of the token to be put on sale.
691     /// @param _sale Sale to add.
692     function _addSale(uint256 _tokenId, Sale _sale) internal {
693         
694 
695         tokenIdToSale[_tokenId] = _sale;
696 
697         SaleCreated(
698             uint256(_tokenId),
699             uint256(_sale.price)
700         );
701     }
702 
703     /// @dev Cancels a sale unconditionally.
704     function _cancelSale(uint256 _tokenId, address _seller) internal {
705         _removeSale(_tokenId);
706         _transfer(_seller, _tokenId);
707         SaleCancelled(_tokenId);
708     }
709 
710     /// @dev Computes the price and transfers winnings.
711     /// Does NOT transfer ownership of token.
712     function _bid(uint256 _tokenId, uint256 _bidAmount)
713         internal
714         returns (uint256)
715     {
716         // Get a reference to the sale struct
717         Sale storage sale = tokenIdToSale[_tokenId];
718 
719         // Explicitly check that this sale is currently live.
720         // (Because of how Ethereum mappings work, we can't just count
721         // on the lookup above failing. An invalid _tokenId will just
722         // return a sale object that is all zeros.)
723         require(_isOnSale(sale));
724 
725         // Check that the bid is greater than or equal to the current price
726         uint256 price = sale.price;
727         require(_bidAmount >= price);
728 
729         // Grab a reference to the seller before the sale struct
730         // gets deleted.
731         address seller = sale.seller;
732 
733         // The bid is good! Remove the sale before sending the fees
734         // to the sender so we can't have a reentrancy attack.
735         _removeSale(_tokenId);
736 
737         // Transfer proceeds to seller (if there are any!)
738         if (price > 0) {
739             // Calculate the Marketplace's cut.
740             // (NOTE: _computeCut() is guaranteed to return a
741             // value <= price, so this subtraction can't go negative.)
742             uint256 marketplaceCut = _computeCut(price);
743             uint256 sellerProceeds = price - marketplaceCut;
744 
745             // NOTE: Doing a transfer() in the middle of a complex
746             // method like this is generally discouraged because of
747             // reentrancy attacks and DoS attacks if the seller is
748             // a contract with an invalid fallback function. We explicitly
749             // guard against reentrancy attacks by removing the auction
750             // before calling transfer(), and the only thing the seller
751             // can DoS is the sale of their own asset! (And if it's an
752             // accident, they can call cancelAuction(). )
753             seller.transfer(sellerProceeds);
754         }
755 
756         // Calculate any excess funds included with the bid. If the excess
757         // is anything worth worrying about, transfer it back to bidder.
758         // NOTE: We checked above that the bid amount is greater than or
759         // equal to the price so this cannot underflow.
760         uint256 bidExcess = _bidAmount - price;
761 
762         // Return the funds. Similar to the previous transfer, this is
763         // not susceptible to a re-entry attack because the auction is
764         // removed before any transfers occur.
765         msg.sender.transfer(bidExcess);
766 
767         // Tell the world!
768         SaleSuccessful(_tokenId, price, msg.sender);
769 
770         return price;
771     }
772 
773     /// @dev Removes a sale from the list of open sales.
774     /// @param _tokenId - ID of NFT on sale.
775     function _removeSale(uint256 _tokenId) internal {
776         delete tokenIdToSale[_tokenId];
777     }
778 
779     /// @dev Returns true if the NFT is on sale.
780     /// @param _sale - Sale to check.
781     function _isOnSale(Sale storage _sale) internal view returns (bool) {
782         return (_sale.startedAt > 0);
783     }
784 
785 
786     /// @dev Computes owner's cut of a sale.
787     /// @param _price - Sale price of NFT.
788     function _computeCut(uint256 _price) internal view returns (uint256) {
789         // NOTE: We don't use SafeMath (or similar) in this function because
790         //  all of our entry functions carefully cap the maximum values for
791         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
792         //  statement in the Marketplace constructor). The result of this
793         //  function is always guaranteed to be <= _price.
794         return _price * ownerCut / 10000;
795     }
796     function _computeAffiliateCut(uint256 _price,Affiliates affiliate) internal view returns (uint256) {
797         // NOTE: We don't use SafeMath (or similar) in this function because
798         //  all of our entry functions carefully cap the maximum values for
799         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
800         //  statement in the Marketplace constructor). The result of this
801         //  function is always guaranteed to be <= _price.
802         return _price * affiliate.commission / 10000;
803     }
804     /// @dev Adds an affiliate to the list.
805     /// @param _code The referall code of the affiliate.
806     /// @param _affiliate Affiliate to add.
807     function _addAffiliate(uint256 _code, Affiliates _affiliate) internal {
808         codeToAffiliate[_code] = _affiliate;
809    
810     }
811     
812     /// @dev Removes a affiliate from the list.
813     /// @param _code - The referall code of the affiliate.
814     function _removeAffiliate(uint256 _code) internal {
815         delete codeToAffiliate[_code];
816     }
817     
818     
819     //_bidReferral(_tokenId, msg.value);
820     /// @dev Computes the price and transfers winnings.
821     /// Does NOT transfer ownership of token.
822     function _bidReferral(uint256 _tokenId, uint256 _bidAmount,Affiliates _affiliate)
823         internal
824         returns (uint256)
825     {
826         
827         // Get a reference to the sale struct
828         Sale storage sale = tokenIdToSale[_tokenId];
829 
830         //Only Owner of Contract can sell referrals
831         require(sale.seller==owner);
832 
833         // Explicitly check that this sale is currently live.
834         // (Because of how Ethereum mappings work, we can't just count
835         // on the lookup above failing. An invalid _tokenId will just
836         // return a sale object that is all zeros.)
837         require(_isOnSale(sale));
838         // Check that the bid is greater than or equal to the current price
839         
840         uint256 price = sale.price;
841         
842         //deduce the affiliate pricecut
843         price=price * _affiliate.pricecut / 10000;  
844         require(_bidAmount >= price);
845 
846         // Grab a reference to the seller before the sale struct
847         // gets deleted.
848         address seller = sale.seller;
849         address affiliate_address = _affiliate.affiliate_address;
850         
851         // The bid is good! Remove the sale before sending the fees
852         // to the sender so we can't have a reentrancy attack.
853         _removeSale(_tokenId);
854 
855         // Transfer proceeds to seller (if there are any!)
856         if (price > 0) {
857             // Calculate the Marketplace's cut.
858             // (NOTE: _computeCut() is guaranteed to return a
859             // value <= price, so this subtraction can't go negative.)
860             uint256 affiliateCut = _computeAffiliateCut(price,_affiliate);
861             uint256 sellerProceeds = price - affiliateCut;
862 
863             // NOTE: Doing a transfer() in the middle of a complex
864             // method like this is generally discouraged because of
865             // reentrancy attacks and DoS attacks if the seller is
866             // a contract with an invalid fallback function. We explicitly
867             // guard against reentrancy attacks by removing the auction
868             // before calling transfer(), and the only thing the seller
869             // can DoS is the sale of their own asset! (And if it's an
870             // accident, they can call cancelAuction(). )
871             seller.transfer(sellerProceeds);
872             affiliate_address.transfer(affiliateCut);
873         }
874 
875         // Calculate any excess funds included with the bid. If the excess
876         // is anything worth worrying about, transfer it back to bidder.
877         // NOTE: We checked above that the bid amount is greater than or
878         // equal to the price so this cannot underflow.
879         uint256 bidExcess = _bidAmount - price;
880 
881         // Return the funds. Similar to the previous transfer, this is
882         // not susceptible to a re-entry attack because the auction is
883         // removed before any transfers occur.
884         msg.sender.transfer(bidExcess);
885 
886         // Tell the world!
887         SaleSuccessful(_tokenId, price, msg.sender);
888 
889         return price;
890     }
891 }
892 
893 /**
894  * @title Pausable
895  * @dev Base contract which allows children to implement an emergency stop mechanism.
896  */
897 contract Pausable is Ownable {
898   event Pause();
899   event Unpause();
900 
901   bool public paused = false;
902 
903 
904   /**
905    * @dev modifier to allow actions only when the contract IS paused
906    */
907   modifier whenNotPaused() {
908     require(!paused);
909     _;
910   }
911 
912   /**
913    * @dev modifier to allow actions only when the contract IS NOT paused
914    */
915   modifier whenPaused {
916     require(paused);
917     _;
918   }
919 
920   /**
921    * @dev called by the owner to pause, triggers stopped state
922    */
923   function pause() onlyOwner whenNotPaused returns (bool) {
924     paused = true;
925     Pause();
926     return true;
927   }
928 
929   /**
930    * @dev called by the owner to unpause, returns to normal state
931    */
932   function unpause() onlyOwner whenPaused returns (bool) {
933     paused = false;
934     Unpause();
935     return true;
936   }
937 }
938 
939 /// @title MarketPlace for non-fungible tokens.
940 /// @notice We omit a fallback function to prevent accidental sends to this contract.
941 contract MarketPlace is Pausable, MarketPlaceBase {
942 
943 	// @dev Sanity check that allows us to ensure that we are pointing to the
944     //  right auction in our setSaleMarketplaceAddress() call.
945     bool public isMarketplace = true;
946 	
947     /// @dev The ERC-165 interface signature for ERC-721.
948     ///  Ref: https://github.com/ethereum/EIPs/issues/165
949     ///  Ref: https://github.com/ethereum/EIPs/issues/721
950     bytes4 constant InterfaceSignature_ERC721 = bytes4(0x9a20483d);
951 
952     /// @dev Constructor creates a reference to the NFT ownership contract
953     ///  and verifies the owner cut is in the valid range.
954     /// @param _nftAddress - address of a deployed contract implementing
955     ///  the Nonfungible Interface.
956     /// @param _cut - percent cut the owner takes on each sale, must be
957     ///  between 0-10,000.
958     function MarketPlace(address _nftAddress, uint256 _cut) public {
959         require(_cut <= 10000);
960         ownerCut = _cut;
961 
962         ERC721 candidateContract = ERC721(_nftAddress);
963         //require(candidateContract.supportsInterface(InterfaceSignature_ERC721));
964         nonFungibleContract = candidateContract;
965     }
966     function setNFTAddress(address _nftAddress, uint256 _cut) external onlyOwner {
967         require(_cut <= 10000);
968         ownerCut = _cut;
969         ERC721 candidateContract = ERC721(_nftAddress);
970         //require(candidateContract.supportsInterface(InterfaceSignature_ERC721));
971         nonFungibleContract = candidateContract;
972     }
973     /// @dev Remove all Ether from the contract, which is the owner's cuts
974     ///  as well as any Ether sent directly to the contract address.
975     ///  Always transfers to the NFT contract, but can be called either by
976     ///  the owner or the NFT contract.
977     function withdrawBalance() external {
978         address nftAddress = address(nonFungibleContract);
979 
980         require(
981             msg.sender == owner ||
982             msg.sender == nftAddress
983         );
984         // We are using this boolean method to make sure that even if one fails it will still work
985         bool res = nftAddress.send(this.balance);
986     }
987 
988     /// @dev Creates and begins a new sale.
989     /// @param _tokenId - ID of token to sale, sender must be owner.
990     /// @param _price - Price of item (in wei)
991     /// @param _seller - Seller, if not the message sender
992     function createSale(
993         uint256 _tokenId,
994         uint256 _price,
995         address _seller
996     )
997         external
998         whenNotPaused
999     {
1000         // Sanity check that no inputs overflow how many bits we've allocated
1001         // to store them in the auction struct.
1002         require(_price == uint256(uint128(_price)));
1003         
1004         //require(_owns(msg.sender, _tokenId));
1005         //_escrow(msg.sender, _tokenId);
1006         
1007         require(msg.sender == address(nonFungibleContract));
1008         _escrow(_seller, _tokenId);
1009         
1010         Sale memory sale = Sale(
1011             _seller,
1012             uint128(_price),
1013             uint64(now)
1014         );
1015         _addSale(_tokenId, sale);
1016     }
1017 
1018 
1019     
1020 
1021     /// @dev Bids on a sale, completing the sale and transferring
1022     ///  ownership of the NFT if enough Ether is supplied.
1023     /// @param _tokenId - ID of token to bid on.
1024     function bid(uint256 _tokenId)
1025         external
1026         payable
1027         whenNotPaused
1028     {
1029         // _bid will throw if the bid or funds transfer fails
1030        _bid(_tokenId, msg.value); 
1031        _transfer(msg.sender, _tokenId);
1032       
1033     }
1034 
1035     /// @dev Bids on a sale, completing the sale and transferring
1036     ///  ownership of the NFT if enough Ether is supplied.
1037     /// @param _tokenId - ID of token to bid on.
1038     function bidReferral(uint256 _tokenId,uint256 _code)
1039         external
1040         payable
1041         whenNotPaused
1042     {
1043         // _bid will throw if the bid or funds transfer fails
1044         Affiliates storage affiliate = codeToAffiliate[_code];
1045         
1046         require(affiliate.affiliate_address!=0&&_code>0);
1047         _bidReferral(_tokenId, msg.value,affiliate);
1048         _transfer(msg.sender, _tokenId);
1049 
1050        
1051     }
1052     
1053     /// @dev Cancels an sale that hasn't been won yet.
1054     ///  Returns the NFT to original owner.
1055     /// @notice This is a state-modifying function that can
1056     ///  be called while the contract is paused.
1057     /// @param _tokenId - ID of token on sale
1058     function cancelSale(uint256 _tokenId)
1059         external
1060     {
1061         Sale storage sale = tokenIdToSale[_tokenId];
1062         require(_isOnSale(sale));
1063         address seller = sale.seller;
1064         require(msg.sender == seller);
1065         _cancelSale(_tokenId, seller);
1066     }
1067 
1068     /// @dev Cancels a sale when the contract is paused.
1069     ///  Only the owner may do this, and NFTs are returned to
1070     ///  the seller. This should only be used in emergencies.
1071     /// @param _tokenId - ID of the NFT on sale to cancel.
1072     function cancelSaleWhenPaused(uint256 _tokenId)
1073         whenPaused
1074         onlyOwner
1075         external
1076     {
1077         Sale storage sale = tokenIdToSale[_tokenId];
1078         require(_isOnSale(sale));
1079         _cancelSale(_tokenId, sale.seller);
1080     }
1081 
1082     /// @dev Returns sale info for an NFT on sale.
1083     /// @param _tokenId - ID of NFT on sale.
1084     function getSale(uint256 _tokenId)
1085         external
1086         view
1087         returns
1088     (
1089         address seller,
1090         uint256 price,
1091         uint256 startedAt
1092     ) {
1093         Sale storage sale = tokenIdToSale[_tokenId];
1094         require(_isOnSale(sale));
1095         return (
1096             sale.seller,
1097             sale.price,
1098             sale.startedAt
1099         );
1100     }
1101 
1102     /// @dev Returns the current price of a sale.
1103     /// @param _tokenId - ID of the token price we are checking.
1104     function getCurrentPrice(uint256 _tokenId)
1105         external
1106         view
1107         returns (uint256)
1108     {
1109         Sale storage sale = tokenIdToSale[_tokenId];
1110         require(_isOnSale(sale));
1111         return sale.price;
1112     }
1113 
1114 
1115     /// @dev Creates and begins a new sale.
1116     /// @param _code - ID of token to sale, sender must be owner.
1117     /// @param _commission - percentage of commission for affiliate
1118     /// @param _pricecut - percentage of sell price cut for buyer
1119     /// @param _affiliate_address - affiliate address 
1120     function createAffiliate(
1121         uint256 _code,
1122         uint64  _commission,
1123         uint64  _pricecut,
1124         address _affiliate_address
1125     )
1126         external
1127         onlyOwner
1128     {
1129 
1130         Affiliates memory affiliate = Affiliates(
1131             address(_affiliate_address),
1132             uint64(_commission),
1133             uint64(_pricecut)
1134         );
1135         _addAffiliate(_code, affiliate);
1136     }
1137     
1138     /// @dev Returns affiliate info for an affiliate code.
1139     /// @param _code - code for an affiliate.
1140     function getAffiliate(uint256 _code)
1141         external
1142         view
1143         onlyOwner
1144         returns
1145     (
1146          address affiliate_address,
1147          uint64 commission,
1148          uint64 pricecut
1149     ) {
1150         Affiliates storage affiliate = codeToAffiliate[_code];
1151         
1152         return (
1153             affiliate.affiliate_address,
1154             affiliate.commission,
1155             affiliate.pricecut
1156         );
1157     }
1158      /// @dev Removes affiliate.
1159     ///  Only the owner may do this
1160     /// @param _code - code for an affiliate.
1161     function removeAffiliate(uint256 _code)
1162         onlyOwner
1163         external
1164     {
1165         _removeAffiliate(_code); 
1166         
1167     }
1168 }
1169 
1170 
1171 /// @title ServiceStationBase core
1172 /// @dev Contains models, variables, and internal methods for the ServiceStation.
1173 contract ServiceStationBase {
1174 
1175     // Reference to contract tracking NFT ownership
1176     ERC721 public nonFungibleContract;
1177 
1178     struct Tune{
1179         uint256 startChange;
1180         uint256 rangeChange;
1181         uint256 attChange;
1182         bool plusMinus;
1183         bool replace;
1184         uint128 price;
1185         bool active;
1186         uint64 model;
1187     }
1188     Tune[] options;
1189     
1190    
1191     
1192     /// @dev Returns true if the claimant owns the token.
1193     /// @param _claimant - Address claiming to own the token.
1194     /// @param _tokenId - ID of token whose ownership to verify.
1195     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
1196         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
1197     }
1198   
1199     /// @dev Calls the NFT Contract with the tuned attributes 
1200     function _tune(uint256 _newattributes, uint256 _tokenId) internal {
1201     nonFungibleContract.tuneLambo(_newattributes, _tokenId);
1202     }
1203     
1204     function _changeAttributes(uint256 _tokenId,uint256 _optionIndex) internal {
1205     
1206     //Get model from token
1207     uint64 model = nonFungibleContract.getLamboModel(_tokenId);
1208     //throw if tune option is not made for model
1209     require(options[_optionIndex].model==model);
1210     
1211     //Get original attributes
1212     uint256 attributes = nonFungibleContract.getLamboAttributes(_tokenId);
1213     uint256 part=0;
1214     
1215     //Dissect for options
1216     part=(attributes/(10 ** options[_optionIndex].startChange)) % (10 ** options[_optionIndex].rangeChange);
1217     //part=1544;
1218     //Change attributes & verify
1219     //Should attChange be added,subtracted or replaced?
1220     if(options[_optionIndex].replace == false)
1221         {
1222             
1223             //change should be added
1224             if(options[_optionIndex].plusMinus == false)
1225             {
1226                 //e.g. if range = 4 then value can not be higher then 9999 - overflow check
1227                 require((part+options[_optionIndex].attChange)<(10**options[_optionIndex].rangeChange));
1228                 //add to attributes
1229                 attributes=attributes+options[_optionIndex].attChange*(10 ** options[_optionIndex].startChange);
1230             }
1231             else{
1232                 //do some subtraction
1233                 //e.g. value must be greater then 0
1234                 require(part>options[_optionIndex].attChange);
1235                 //substract from attributes 
1236                 attributes-=options[_optionIndex].attChange*(10 ** options[_optionIndex].startChange);
1237             }
1238         }
1239     else
1240         {
1241             //do some replacing
1242             attributes=attributes-part*(10 ** options[_optionIndex].startChange);
1243             attributes+=options[_optionIndex].attChange*(10 ** options[_optionIndex].startChange);
1244         }
1245     
1246   
1247    
1248     //Tune Lambo in NFT contract
1249     _tune(uint256(attributes), _tokenId);
1250        
1251         
1252     }
1253     
1254     
1255 }
1256 
1257 
1258 /// @title ServiceStation for non-fungible tokens.
1259 contract ServiceStation is Pausable, ServiceStationBase {
1260 
1261 	// @dev Sanity check that allows us to ensure that we are pointing to the right call.
1262     bool public isServicestation = true;
1263 	
1264     /// @dev The ERC-165 interface signature for ERC-721.
1265     ///  Ref: https://github.com/ethereum/EIPs/issues/165
1266     ///  Ref: https://github.com/ethereum/EIPs/issues/721
1267     bytes4 constant InterfaceSignature_ERC721 = bytes4(0x9a20483d);
1268 
1269     uint256 public optionCount;
1270     mapping (uint64 => uint256) public modelIndexToOptionCount;
1271     /// @dev Constructor creates a reference to the NFT ownership contract
1272     ///  and verifies the owner cut is in the valid range.
1273     /// @param _nftAddress - address of a deployed contract implementing
1274     ///  the Nonfungible Interface.
1275     function ServiceStation(address _nftAddress) public {
1276 
1277         ERC721 candidateContract = ERC721(_nftAddress);
1278         //require(candidateContract.supportsInterface(InterfaceSignature_ERC721));
1279         nonFungibleContract = candidateContract;
1280         _newTuneOption(0,0,0,false,false,0,0);
1281         
1282     }
1283     function setNFTAddress(address _nftAddress) external onlyOwner {
1284         
1285         ERC721 candidateContract = ERC721(_nftAddress);
1286         //require(candidateContract.supportsInterface(InterfaceSignature_ERC721));
1287         nonFungibleContract = candidateContract;
1288     }
1289     
1290     function newTuneOption(
1291         uint32 _startChange,
1292         uint32 _rangeChange,
1293         uint256 _attChange,
1294         bool _plusMinus,
1295         bool _replace,
1296         uint128 _price,
1297         uint64 _model
1298         )
1299         external
1300         {
1301            //Only allow owner to add new options
1302            require(msg.sender == owner ); 
1303            optionCount++;
1304            modelIndexToOptionCount[_model]++;
1305            _newTuneOption(_startChange,_rangeChange,_attChange,_plusMinus, _replace,_price,_model);
1306        
1307         }
1308     function changeTuneOption(
1309         uint32 _startChange,
1310         uint32 _rangeChange,
1311         uint256 _attChange,
1312         bool _plusMinus,
1313         bool _replace,
1314         uint128 _price,
1315         bool _isactive,
1316         uint64 _model,
1317         uint256 _optionIndex
1318         )
1319         external
1320         {
1321            //Only allow owner to add new options
1322            require(msg.sender == owner ); 
1323            
1324            
1325            _changeTuneOption(_startChange,_rangeChange,_attChange,_plusMinus, _replace,_price,_isactive,_model,_optionIndex);
1326        
1327         }
1328         
1329     function _newTuneOption( uint32 _startChange,
1330         uint32 _rangeChange,
1331         uint256 _attChange,
1332         bool _plusMinus,
1333         bool _replace,
1334         uint128 _price,
1335         uint64 _model
1336         ) 
1337         internal
1338         {
1339         
1340            Tune memory _option = Tune({
1341             startChange: _startChange,
1342             rangeChange: _rangeChange,
1343             attChange: _attChange,
1344             plusMinus: _plusMinus,
1345             replace: _replace,
1346             price: _price,
1347             active: true,
1348             model: _model
1349             });
1350         
1351         options.push(_option);
1352     }
1353     
1354     function _changeTuneOption( uint32 _startChange,
1355         uint32 _rangeChange,
1356         uint256 _attChange,
1357         bool _plusMinus,
1358         bool _replace,
1359         uint128 _price,
1360         bool _isactive,
1361         uint64 _model,
1362         uint256 _optionIndex
1363         ) 
1364         internal
1365         {
1366         
1367            Tune memory _option = Tune({
1368             startChange: _startChange,
1369             rangeChange: _rangeChange,
1370             attChange: _attChange,
1371             plusMinus: _plusMinus,
1372             replace: _replace,
1373             price: _price,
1374             active: _isactive,
1375             model: _model
1376             });
1377         
1378         options[_optionIndex]=_option;
1379     }
1380     
1381     function disableTuneOption(uint256 index) external
1382     {
1383         require(msg.sender == owner ); 
1384         options[index].active=false;
1385     }
1386     
1387     function enableTuneOption(uint256 index) external
1388     {
1389         require(msg.sender == owner ); 
1390         options[index].active=true;
1391     }
1392     function getOption(uint256 _index) 
1393     external view
1394     returns (
1395         uint256 _startChange,
1396         uint256 _rangeChange,
1397         uint256 _attChange,
1398         bool _plusMinus,
1399         uint128 _price,
1400         bool active,
1401         uint64 model
1402     ) 
1403     {
1404       
1405         //require(options[_index].active);
1406         return (
1407             options[_index].startChange,
1408             options[_index].rangeChange,
1409             options[_index].attChange,
1410             options[_index].plusMinus,
1411             options[_index].price,
1412             options[_index].active,
1413             options[_index].model
1414         );  
1415     }
1416     
1417     function getOptionCount() external view returns (uint256 _optionCount)
1418         {
1419         return optionCount;    
1420         }
1421     
1422     function tuneLambo(uint256 _tokenId,uint256 _optionIndex) external payable
1423     {
1424        //Caller needs to own Lambo
1425        require(_owns(msg.sender, _tokenId)); 
1426        //Tuning Option needs to be enabled
1427        require(options[_optionIndex].active);
1428        //Enough money for tuning to spend?
1429        require(msg.value>=options[_optionIndex].price);
1430        
1431        _changeAttributes(_tokenId,_optionIndex);
1432     }
1433     /// @dev Remove all Ether from the contract, which is the owner's cuts
1434     ///  as well as any Ether sent directly to the contract address.
1435     ///  Always transfers to the NFT contract, but can be called either by
1436     ///  the owner or the NFT contract.
1437     function withdrawBalance() external {
1438         address nftAddress = address(nonFungibleContract);
1439 
1440         require(
1441             msg.sender == owner ||
1442             msg.sender == nftAddress
1443         );
1444         // We are using this boolean method to make sure that even if one fails it will still work
1445         bool res = owner.send(this.balance);
1446     }
1447 
1448     function getOptionsForModel(uint64 _model) external view returns(uint256[] _optionsModel) {
1449         //uint256 tokenCount = balanceOf(_owner);
1450 
1451         //if (tokenCount == 0) {
1452             // Return an empty array
1453         //    return new uint256[](0);
1454         //} else {
1455             uint256[] memory result = new uint256[](modelIndexToOptionCount[_model]);
1456             //uint256 totalCars = totalSupply();
1457             uint256 resultIndex = 0;
1458 
1459             // We count on the fact that all cars have IDs starting at 0 and increasing
1460             // sequentially up to the optionCount count.
1461             uint256 optionId;
1462 
1463             for (optionId = 1; optionId <= optionCount; optionId++) {
1464                 if (options[optionId].model == _model && options[optionId].active == true) {
1465                     result[resultIndex] = optionId;
1466                     resultIndex++;
1467                 }
1468             }
1469 
1470             return result;
1471        // }
1472     }
1473 
1474 }
1475 
1476 
1477 
1478 ////No SiringClockAuction needed for Lambos
1479 ////No separate modification for SaleContract needed
1480 
1481 /// @title Handles creating sales for sale of lambos.
1482 ///  This wrapper of ReverseSale exists only so that users can create
1483 ///  sales with only one transaction.
1484 contract EtherLambosSale is EtherLambosOwnership {
1485 
1486     // @notice The sale contract variables are defined in EtherLambosBase to allow
1487     //  us to refer to them in EtherLambosOwnership to prevent accidental transfers.
1488     // `saleMarketplace` refers to the auction for p2p sale of cars.
1489    
1490 
1491     /// @dev Sets the reference to the sale auction.
1492     /// @param _address - Address of sale contract.
1493     function setMarketplaceAddress(address _address) external onlyCEO {
1494         MarketPlace candidateContract = MarketPlace(_address);
1495 
1496         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
1497         require(candidateContract.isMarketplace());
1498 
1499         // Set the new contract address
1500         marketPlace = candidateContract;
1501     }
1502 
1503 
1504     /// @dev Put a lambo up for sale.
1505     ///  Does some ownership trickery to create auctions in one tx.
1506     function createLamboSale(
1507         uint256 _carId,
1508         uint256 _price
1509     )
1510         external
1511         whenNotPaused
1512     {
1513         // Sale contract checks input sizes
1514         // If lambo is already on any sale, this will throw
1515         // because it will be owned by the sale contract.
1516         require(_owns(msg.sender, _carId));
1517         
1518         _approve(_carId, marketPlace);
1519         // Sale throws if inputs are invalid and clears
1520         // transfer after escrowing the lambo.
1521         marketPlace.createSale(
1522             _carId,
1523             _price,
1524             msg.sender
1525         );
1526     }
1527     
1528     
1529     function bulkCreateLamboSale(
1530         uint256 _price,
1531         uint256 _tokenIdStart,
1532         uint256 _tokenCount
1533     )
1534         external
1535         onlyCOO
1536     {
1537         // Sale contract checks input sizes
1538         // If lambo is already on any sale, this will throw
1539         // because it will be owned by the sale contract.
1540         for(uint256 i=0;i<_tokenCount;i++)
1541             {
1542             require(_owns(msg.sender, _tokenIdStart+i));
1543         
1544             _approve(_tokenIdStart+i, marketPlace);
1545             // Sale throws if inputs are invalid and clears
1546             // transfer after escrowing the lambo.
1547             marketPlace.createSale(
1548                 _tokenIdStart+i,
1549                 _price,
1550              msg.sender
1551             );
1552         }
1553     }
1554     /// @dev Transfers the balance of the marketPlace contract
1555     /// to the EtherLambosCore contract. We use two-step withdrawal to
1556     /// prevent two transfer calls in the auction bid function.
1557     function withdrawSaleBalances() external onlyCLevel {
1558         marketPlace.withdrawBalance();
1559         
1560     }
1561 }
1562 
1563 /// @title all functions related to creating lambos
1564 contract EtherLambosBuilding is EtherLambosSale {
1565 
1566     // Limits the number of cars the contract owner can ever create.
1567     //uint256 public constant PROMO_CREATION_LIMIT = 5000;
1568     //uint256 public constant GEN0_CREATION_LIMIT = 45000;
1569 
1570 
1571     // Counts the number of cars the contract owner has created.
1572     uint256 public lambosBuildCount;
1573 
1574 
1575     /// @dev we can build lambos. Only callable by COO
1576     /// @param _attributes the encoded attributes of the lambo to be created, any value is accepted
1577     /// @param _owner the future owner of the created lambo. Default to contract COO
1578     /// @param _model the model of the created lambo. 
1579     function createLambo(uint256 _attributes, address _owner, uint64 _model) external onlyCOO {
1580         address lamboOwner = _owner;
1581         if (lamboOwner == address(0)) {
1582              lamboOwner = cooAddress;
1583         }
1584         //require(promoCreatedCount < PROMO_CREATION_LIMIT);
1585 
1586         lambosBuildCount++;
1587         _createLambo(_attributes, lamboOwner, _model);
1588     }
1589 
1590     function bulkCreateLambo(uint256 _attributes, address _owner, uint64 _model,uint256 count, uint256 startNo) external onlyCOO {
1591         address lamboOwner = _owner;
1592         uint256 att=_attributes;
1593         if (lamboOwner == address(0)) {
1594              lamboOwner = cooAddress;
1595         }
1596         
1597         //do some replacing
1598             //_attributes=_attributes-part*(10 ** 66);
1599         
1600         
1601         //require(promoCreatedCount < PROMO_CREATION_LIMIT);
1602         for(uint256 i=0;i<count;i++)
1603             {
1604             lambosBuildCount++;
1605             att=_attributes+(startNo+i)*(10 ** 66);
1606             _createLambo(att, lamboOwner, _model);
1607             }
1608     }
1609 }
1610 
1611 /// @title all functions related to tuning lambos
1612 contract EtherLambosTuning is EtherLambosBuilding {
1613 
1614     // Counts the number of tunings have been done.
1615     uint256 public lambosTuneCount;
1616 
1617     function setServicestationAddress(address _address) external onlyCEO {
1618         ServiceStation candidateContract = ServiceStation(_address);
1619 
1620         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
1621         require(candidateContract.isServicestation());
1622 
1623         // Set the new contract address
1624         serviceStation = candidateContract;
1625     }
1626     /// @dev we can tune lambos. Only callable by ServiceStation contract
1627     /// @param _newattributes the new encoded attributes of the lambo to be updated
1628     /// @param _tokenId the lambo to be tuned.
1629     function tuneLambo(uint256 _newattributes, uint256 _tokenId) external {
1630         
1631         //Tuning can only be done by the ServiceStation Contract. 
1632         require(
1633             msg.sender == address(serviceStation)
1634         );
1635         
1636         
1637         lambosTuneCount++;
1638         _tuneLambo(_newattributes, _tokenId);
1639     }
1640     function withdrawTuneBalances() external onlyCLevel {
1641         serviceStation.withdrawBalance();
1642         
1643     }
1644 
1645 }
1646 
1647 /// @title EtherLambos: Collectible, tuneable, and super stylish lambos on the Ethereum blockchain.
1648 /// @author Cryptoknights code adapted from Axiom Zen (https://www.axiomzen.co)
1649 /// @dev The main EtherLambos contract, keeps track of lambos.
1650 contract EtherLambosCore is EtherLambosTuning {
1651 
1652     // This is the main EtherLambos contract. In order to keep our code seperated into logical sections,
1653     // we've broken it up in two ways. First, we have several seperately-instantiated sibling contracts
1654     // that handle sales. The sales are
1655     // seperate since their logic is somewhat complex and there's always a risk of subtle bugs. By keeping
1656     // them in their own contracts, we can upgrade them without disrupting the main contract that tracks
1657     // lambo ownership. 
1658     //
1659     // Secondly, we break the core contract into multiple files using inheritence, one for each major
1660     // facet of functionality of EtherLambos. This allows us to keep related code bundled together while still
1661     // avoiding a single giant file with everything in it. The breakdown is as follows:
1662     //
1663     //      - EtherLambosBase: This is where we define the most fundamental code shared throughout the core
1664     //             functionality. This includes our main data storage, constants and data types, plus
1665     //             internal functions for managing these items.
1666     //
1667     //      - EtherLambosAccessControl: This contract manages the various addresses and constraints for operations
1668     //             that can be executed only by specific roles. Namely CEO, CFO and COO.
1669     //
1670     //      - EtherLambosOwnership: This provides the methods required for basic non-fungible token
1671     //             transactions, following the draft ERC-721 spec (https://github.com/ethereum/EIPs/issues/721).
1672     //
1673     //      - EtherLambosSale: Here we have the public methods for sales. 
1674     //
1675     //      - EtherLambosBuilding: This final facet contains the functionality we use for creating new cars.
1676     //             
1677 
1678     // Set in case the core contract is broken and an upgrade is required
1679     address public newContractAddress;
1680 
1681     /// @notice Creates the main EtherLambos smart contract instance.
1682     function EtherLambosCore() public {
1683         // Starts paused.
1684         paused = true;
1685 
1686         // the creator of the contract is the initial CEO
1687         ceoAddress = msg.sender;
1688 
1689         // the creator of the contract is also the initial COO
1690         cooAddress = msg.sender;
1691 
1692         // start with the car 0 
1693         _createLambo(uint256(-1), address(0),0);
1694     }
1695 
1696     /// @dev Used to mark the smart contract as upgraded, in case there is a serious
1697     ///  breaking bug. This method does nothing but keep track of the new contract and
1698     ///  emit a message indicating that the new address is set. It's up to clients of this
1699     ///  contract to update to the new contract address in that case. (This contract will
1700     ///  be paused indefinitely if such an upgrade takes place.)
1701     /// @param _v2Address new address
1702     function setNewAddress(address _v2Address) external onlyCEO whenPaused {
1703         // See README.md for updgrade plan
1704         newContractAddress = _v2Address;
1705         ContractUpgrade(_v2Address);
1706     }
1707 
1708     /// @notice No tipping!
1709     /// @dev Reject all Ether from being sent here, unless it's from the marketPlace contract.
1710     /// (Hopefully, we can prevent user accidents.)
1711     function() external payable {
1712         require(
1713             msg.sender == address(marketPlace)
1714         );
1715     }
1716 
1717     /// @notice Returns all the relevant information about a specific lambo.
1718     /// @param _id The ID of the lambo of interest.
1719     function getLambo(uint256 _id)
1720         external
1721         view
1722         returns (
1723         uint256 buildTime,
1724         uint256 attributes
1725     ) {
1726         Lambo storage kit = lambos[_id];
1727 
1728         buildTime = uint256(kit.buildTime);
1729         attributes = kit.attributes;
1730     }
1731     /// @notice Returns all the relevant information about a specific lambo.
1732     /// @param _id The ID of the lambo of interest.
1733     function getLamboAttributes(uint256 _id)
1734         external
1735         view
1736         returns (
1737         uint256 attributes
1738     ) {
1739         Lambo storage kit = lambos[_id];
1740         attributes = kit.attributes;
1741         return attributes;
1742     }
1743     
1744     /// @notice Returns all the relevant information about a specific lambo.
1745     /// @param _id The ID of the lambo of interest.
1746     function getLamboModel(uint256 _id)
1747         external
1748         view
1749         returns (
1750         uint64 model
1751     ) {
1752         Lambo storage kit = lambos[_id];
1753         model = kit.model;
1754         return model;
1755     }
1756     /// @dev Override unpause so it requires all external contract addresses
1757     ///  to be set before contract can be unpaused. Also, we can't have
1758     ///  newContractAddress set either, because then the contract was upgraded.
1759     /// @notice This is public rather than external so we can call super.unpause
1760     ///  without using an expensive CALL.
1761     function unpause() public onlyCEO whenPaused {
1762         require(marketPlace != address(0));
1763         require(serviceStation != address(0));
1764         require(newContractAddress == address(0));
1765 
1766         // Actually unpause the contract.
1767         super.unpause();
1768     }
1769 
1770     // @dev Allows the CFO to capture the balance available to the contract.
1771     function withdrawBalance() external onlyCFO {
1772         uint256 balance = this.balance;
1773         cfoAddress.send(balance);
1774      
1775     }
1776 }