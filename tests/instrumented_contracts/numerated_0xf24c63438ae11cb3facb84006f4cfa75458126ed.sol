1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9 	address public owner;
10 
11 
12 	/**
13 	 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14 	 * account.
15 	 */
16 	function Ownable() public {
17 		owner = msg.sender;
18 	}
19 
20 
21 	/**
22 	 * @dev Throws if called by any account other than the owner.
23 	 */
24 	modifier onlyOwner() {
25 		require(msg.sender == owner);
26 		_;
27 	}
28 
29 
30 	/**
31 	 * @dev Allows the current owner to transfer control of the contract to a newOwner.
32 	 * @param newOwner The address to transfer ownership to.
33 	 */
34 	function transferOwnership(address newOwner) public onlyOwner {
35 		if (newOwner != address(0)) {
36 			owner = newOwner;
37 		}
38 	}
39 
40 }
41 
42 
43 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
44 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
45 contract ERC721 {
46     // Required methods
47     function totalSupply() public view returns (uint256 total);
48     function balanceOf(address _owner) public view returns (uint256 balance);
49     function ownerOf(uint256 _tokenId) external view returns (address owner);
50     function approve(address _to, uint256 _tokenId) external;
51     function transfer(address _to, uint256 _tokenId) external;
52     function transferFrom(address _from, address _to, uint256 _tokenId) external;
53 
54     // Events
55     event Transfer(address from, address to, uint256 tokenId);
56     event Approval(address owner, address approved, uint256 tokenId);
57 
58     // Optional
59     // function name() public view returns (string name);
60     // function symbol() public view returns (string symbol);
61     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
62     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
63 
64     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
65     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
66 }
67 
68 
69 /// @title SEKRETs
70 contract GeneScienceInterface {
71     /// @dev simply a boolean to indicate this is the contract we expect to be
72     function isGeneScience() public pure returns (bool);
73 
74     /// @dev given genes of EtherDog 1 & 2, return a genetic combination - may have a random factor
75     /// @param genes1 genes of mom
76     /// @param genes2 genes of sire
77     /// @return the genes that are supposed to be passed down the child
78     function mixGenes(uint256 genes1, uint256 genes2, uint256 targetBlock) public returns (uint256);
79 }
80 
81 
82 /// @title A facet of EtherDogCore that manages special access privileges.
83 /// @author CybEye (http://www.cybeye.com/us/index.jsp)
84 /// @dev See the EtherDogCore contract documentation to understand how the various contract facets are arranged.
85 contract EtherDogACL {
86     // This facet controls access control for EtherDogs. There are four roles managed here:
87     //
88     //     - The CEO: The CEO can reassign other roles and change the addresses of our dependent smart
89     //         contracts. It is also the only role that can unpause the smart contract. It is initially
90     //         set to the address that created the smart contract in the EtherDogCore constructor.
91     //
92     //     - The CFO: The CFO can withdraw funds from EtherDogCore and its auction contracts.
93     //
94     //     - The COO: The COO can release gen0 EtherDogs to auction, and mint promo dogs.
95     //
96     // It should be noted that these roles are distinct without overlap in their access abilities, the
97     // abilities listed for each role above are exhaustive. In particular, while the CEO can assign any
98     // address to any role, the CEO address itself doesn't have the ability to act in those roles. This
99     // restriction is intentional so that we aren't tempted to use the CEO address frequently out of
100     // convenience. The less we use an address, the less likely it is that we somehow compromise the
101     // account.
102 
103     /// @dev Emited when contract is upgraded - See README.md for updgrade plan
104     event ContractUpgrade(address newContract);
105 
106     // The addresses of the accounts (or contracts) that can execute actions within each roles.
107     address public ceoAddress;
108     address public cfoAddress;
109     address public cooAddress;
110 
111     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
112     bool public paused = false;
113 
114     /// @dev Access modifier for CEO-only functionality
115     modifier onlyCEO() {
116         require(msg.sender == ceoAddress);
117         _;
118     }
119 
120     /// @dev Access modifier for CFO-only functionality
121     modifier onlyCFO() {
122         require(msg.sender == cfoAddress);
123         _;
124     }
125 
126     /// @dev Access modifier for COO-only functionality
127     modifier onlyCOO() {
128         require(msg.sender == cooAddress);
129         _;
130     }
131 
132     modifier onlyCLevel() {
133         require(
134             msg.sender == cooAddress ||
135             msg.sender == ceoAddress ||
136             msg.sender == cfoAddress
137         );
138         _;
139     }
140 
141     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
142     /// @param _newCEO The address of the new CEO
143     function setCEO(address _newCEO) external onlyCEO {
144         require(_newCEO != address(0));
145 
146         ceoAddress = _newCEO;
147     }
148 
149     /// @dev Assigns a new address to act as the CFO. Only available to the current CEO.
150     /// @param _newCFO The address of the new CFO
151     function setCFO(address _newCFO) external onlyCEO {
152         require(_newCFO != address(0));
153 
154         cfoAddress = _newCFO;
155     }
156 
157     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
158     /// @param _newCOO The address of the new COO
159     function setCOO(address _newCOO) external onlyCEO {
160         require(_newCOO != address(0));
161 
162         cooAddress = _newCOO;
163     }
164 
165     /*** Pausable functionality adapted from OpenZeppelin ***/
166 
167     /// @dev Modifier to allow actions only when the contract IS NOT paused
168     modifier whenNotPaused() {
169         require(!paused);
170         _;
171     }
172 
173     /// @dev Modifier to allow actions only when the contract IS paused
174     modifier whenPaused {
175         require(paused);
176         _;
177     }
178 
179     /// @dev Called by any "C-level" role to pause the contract. Used only when
180     ///  a bug or exploit is detected and we need to limit damage.
181     function pause() external onlyCLevel whenNotPaused {
182         paused = true;
183     }
184 
185     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
186     ///  one reason we may pause the contract is when CFO or COO accounts are
187     ///  compromised.
188     /// @notice This is public rather than external so it can be called by
189     ///  derived contracts.
190     function unpause() public onlyCEO whenPaused {
191         // can't unpause if contract was upgraded
192         paused = false;
193     }
194 }
195 
196 
197 /// @title Base contract for EtherDog. Holds all common structs, events and base variables.
198 /// @author Axiom Zen (https://www.axiomzen.co)
199 /// @dev See the EtherDogCore contract documentation to understand how the various contract facets are arranged.
200 contract EtherDogBase is EtherDogACL {
201 	/*** EVENTS ***/
202 
203 	/// @dev The Birth event is fired whenever a new EtherDog comes into existence. This obviously
204 	///  includes any time a EtherDog is created through the giveBirth method, but it is also called
205 	///  when a new gen0 EtherDog is created.
206 	event Birth(address owner, uint256 EtherDogId, uint256 matronId, uint256 sireId, uint256 genes, uint256 generation);
207 
208 	/// @dev Transfer event as defined in current draft of ERC721. Emitted every time a EtherDog
209 	///  ownership is assigned, including births.
210 	event Transfer(address from, address to, uint256 tokenId);
211 
212 	/*** DATA TYPES ***/
213 
214 	/// @dev The main EtherDog struct. Every EtherDog in EtherDog is represented by a copy
215 	///  of this structure, so great care was taken to ensure that it fits neatly into
216 	///  exactly two 256-bit words. Note that the order of the members in this structure
217 	///  is important because of the byte-packing rules used by Ethereum.
218 	///  Ref: http://solidity.readthedocs.io/en/develop/miscellaneous.html
219 	struct EtherDog {
220 		// The EtherDog's genetic code is packed into these 256-bits, the format is
221 		// sooper-sekret! A EtherDog's genes never change.
222 		uint256 genes;
223 
224 		// The timestamp from the block when this EtherDog came into existence.
225 		uint64 birthTime;
226 
227 		// The minimum timestamp after which this EtherDog can engage in breeding
228 		// activities again. This same timestamp is used for the pregnancy
229 		// timer (for matrons) as well as the siring cooldown.
230 		uint64 cooldownEndBlock;
231 
232 		// The ID of the parents of this EtherDog, set to 0 for gen0 EtherDogs.
233 		// Note that using 32-bit unsigned integers limits us to a "mere"
234 		// 4 billion EtherDogs. This number might seem small until you realize
235 		// that Ethereum currently has a limit of about 500 million
236 		// transactions per year! So, this definitely won't be a problem
237 		// for several years (even as Ethereum learns to scale).
238 		uint32 matronId;
239 		uint32 sireId;
240 
241 		// Set to the ID of the sire EtherDog for matrons that are pregnant,
242 		// zero otherwise. A non-zero value here is how we know a EtherDog
243 		// is pregnant. Used to retrieve the genetic material for the new
244 		// EtherDog when the birth transpires.
245 		uint32 siringWithId;
246 
247 		// Set to the index in the cooldown array (see below) that represents
248 		// the current cooldown duration for this EtherDog. This starts at zero
249 		// for gen0 EtherDogs, and is initialized to floor(generation/2) for others.
250 		// Incremented by one for each successful breeding action, regardless
251 		// of whether this EtherDog is acting as matron or sire.
252 		uint16 cooldownIndex;
253 
254 		// The "generation number" of this EtherDog. EtherDogs minted by the CZ contract
255 		// for sale are called "gen0" and have a generation number of 0. The
256 		// generation number of all other EtherDogs is the larger of the two generation
257 		// numbers of their parents, plus one.
258 		// (i.e. max(matron.generation, sire.generation) + 1)
259 		uint16 generation;
260 	}
261 
262 	/*** CONSTANTS ***/
263 
264 	/// @dev A lookup table inEtherDoging the cooldown duration after any successful
265 	///  breeding action, called "pregnancy time" for matrons and "siring cooldown"
266 	///  for sires. Designed such that the cooldown roughly doubles each time a EtherDog
267 	///  is bred, encouraging owners not to just keep breeding the same EtherDog over
268 	///  and over again. Caps out at one week (a EtherDog can breed an unbounded number
269 	///  of times, and the maximum cooldown is always seven days).
270 	uint32[14] public cooldowns = [
271 		uint32(1 minutes),
272 		uint32(2 minutes),
273 		uint32(5 minutes),
274 		uint32(10 minutes),
275 		uint32(30 minutes),
276 		uint32(1 hours),
277 		uint32(2 hours),
278 		uint32(4 hours),
279 		uint32(8 hours),
280 		uint32(16 hours),
281 		uint32(1 days),
282 		uint32(2 days),
283 		uint32(4 days),
284 		uint32(7 days)
285 	];
286 
287 	// An approximation of currently how many seconds are in between blocks.
288 	uint256 public secondsPerBlock = 15;
289 
290 	/*** STORAGE ***/
291 
292 	/// @dev An array containing the EtherDog struct for all EtherDogs in existence. The ID
293 	///  of each EtherDog is actually an index into this array. Note that ID 0 is a negaEtherDog,
294 	///  the unEtherDog, the mythical beast that is the parent of all gen0 EtherDogs. A bizarre
295 	///  creature that is both matron and sire... to itself! Has an invalid genetic code.
296 	///  In other words, EtherDog ID 0 is invalid... ;-)
297 	EtherDog[] EtherDogs;
298 
299 	/// @dev A mapping from EtherDog IDs to the address that owns them. All EtherDogs have
300 	///  some valid owner address, even gen0 EtherDogs are created with a non-zero owner.
301 	mapping (uint256 => address) public EtherDogIndexToOwner;
302 
303 	// @dev A mapping from owner address to count of tokens that address owns.
304 	//  Used internally inside balanceOf() to resolve ownership count.
305 	mapping (address => uint256) ownershipTokenCount;
306 
307 	/// @dev A mapping from EtherDogIDs to an address that has been approved to call
308 	///  transferFrom(). Each EtherDog can only have one approved address for transfer
309 	///  at any time. A zero value means no approval is outstanding.
310 	mapping (uint256 => address) public EtherDogIndexToApproved;
311 
312 	/// @dev A mapping from EtherDogIDs to an address that has been approved to use
313 	///  this EtherDog for siring via breedWith(). Each EtherDog can only have one approved
314 	///  address for siring at any time. A zero value means no approval is outstanding.
315 	mapping (uint256 => address) public sireAllowedToAddress;
316 
317 	/// @dev The address of the ClockAuction contract that handles sales of EtherDogs. This
318 	///  same contract handles both peer-to-peer sales as well as the gen0 sales which are
319 	///  initiated every 15 minutes.
320 	SaleClockAuction public saleAuction;
321 
322 	/// @dev The address of a custom ClockAuction subclassed contract that handles siring
323 	///  auctions. Needs to be separate from saleAuction because the actions taken on success
324 	///  after a sales and siring auction are quite different.
325 	SiringClockAuction public siringAuction;
326 
327 	/// @dev Assigns ownership of a specific EtherDog to an address.
328 	function _transfer(address _from, address _to, uint256 _tokenId) internal {
329 		// Since the number of EtherDogs is capped to 2^32 we can't overflow this
330 		ownershipTokenCount[_to]++;
331 		// transfer ownership
332 		EtherDogIndexToOwner[_tokenId] = _to;
333 		// When creating new EtherDogs _from is 0x0, but we can't account that address.
334 		if (_from != address(0)) {
335 			ownershipTokenCount[_from]--;
336 			// once the EtherDog is transferred also clear sire allowances
337 			delete sireAllowedToAddress[_tokenId];
338 			// clear any previously approved ownership exchange
339 			delete EtherDogIndexToApproved[_tokenId];
340 		}
341 		// Emit the transfer event.
342 		Transfer(_from, _to, _tokenId);
343 	}
344 
345 	/// @dev An internal method that creates a new EtherDog and stores it. This
346 	///  method doesn't do any checking and should only be called when the
347 	///  input data is known to be valid. Will generate both a Birth event
348 	///  and a Transfer event.
349 	/// @param _matronId The EtherDog ID of the matron of this EtherDog (zero for gen0)
350 	/// @param _sireId The EtherDog ID of the sire of this EtherDog (zero for gen0)
351 	/// @param _generation The generation number of this EtherDog, must be computed by caller.
352 	/// @param _genes The EtherDog's genetic code.
353 	/// @param _owner The inital owner of this EtherDog, must be non-zero (except for the unEtherDog, ID 0)
354 	function _createEtherDog(
355 		uint256 _matronId,
356 		uint256 _sireId,
357 		uint256 _generation,
358 		uint256 _genes,
359 		address _owner
360 	)
361 		internal
362 		returns (uint)
363 	{
364 		// These requires are not strictly necessary, our calling code should make
365 		// sure that these conditions are never broken. However! _createEtherDog() is already
366 		// an expensive call (for storage), and it doesn't hurt to be especially careful
367 		// to ensure our data structures are always valid.
368 		require(_matronId == uint256(uint32(_matronId)));
369 		require(_sireId == uint256(uint32(_sireId)));
370 		require(_generation == uint256(uint16(_generation)));
371 
372 		// New EtherDog starts with the same cooldown as parent gen/2
373 		uint16 cooldownIndex = uint16(_generation / 2);
374 		if (cooldownIndex > 13) {
375 			cooldownIndex = 13;
376 		}
377 
378 		EtherDog memory _EtherDog = EtherDog({
379 			genes: _genes,
380 			birthTime: uint64(now),
381 			cooldownEndBlock: 0,
382 			matronId: uint32(_matronId),
383 			sireId: uint32(_sireId),
384 			siringWithId: 0,
385 			cooldownIndex: cooldownIndex,
386 			generation: uint16(_generation)
387 		});
388 		uint256 newEtherDogId = EtherDogs.push(_EtherDog) - 1;
389 
390 		// It's probably never going to happen, 4 billion EtherDogs is A LOT, but
391 		// let's just be 100% sure we never let this happen.
392 		require(newEtherDogId == uint256(uint32(newEtherDogId)));
393 
394 		// emit the birth event
395 		Birth(
396 			_owner,
397 			newEtherDogId,
398 			uint256(_EtherDog.matronId),
399 			uint256(_EtherDog.sireId),
400 			_EtherDog.genes,
401             uint256(_EtherDog.generation)
402 		);
403 
404 		// This will assign ownership, and also emit the Transfer event as
405 		// per ERC721 draft
406 		_transfer(0, _owner, newEtherDogId);
407 
408 		return newEtherDogId;
409 	}
410 
411 	/// @dev An internal method that creates a new EtherDog and stores it. This
412 	///  method doesn't do any checking and should only be called when the
413 	///  input data is known to be valid. Will generate both a Birth event
414 	///  and a Transfer event.
415 	/// @param _matronId The EtherDog ID of the matron of this EtherDog (zero for gen0)
416 	/// @param _sireId The EtherDog ID of the sire of this EtherDog (zero for gen0)
417 	/// @param _generation The generation number of this EtherDog, must be computed by caller.
418 	/// @param _genes The EtherDog's genetic code.
419 	/// @param _owner The inital owner of this EtherDog, must be non-zero (except for the unEtherDog, ID 0)
420     /// @param _time The birth time of EtherDog
421     /// @param _cooldownIndex The cooldownIndex of EtherDog
422 	function _createEtherDogWithTime(
423 		uint256 _matronId,
424 		uint256 _sireId,
425 		uint256 _generation,
426 		uint256 _genes,
427 		address _owner,
428         uint256 _time,
429         uint256 _cooldownIndex
430 	)
431 	internal
432 	returns (uint)
433 	{
434 		// These requires are not strictly necessary, our calling code should make
435 		// sure that these conditions are never broken. However! _createEtherDog() is already
436 		// an expensive call (for storage), and it doesn't hurt to be especially careful
437 		// to ensure our data structures are always valid.
438 		require(_matronId == uint256(uint32(_matronId)));
439 		require(_sireId == uint256(uint32(_sireId)));
440 		require(_generation == uint256(uint16(_generation)));
441         require(_time == uint256(uint64(_time)));
442         require(_cooldownIndex == uint256(uint16(_cooldownIndex)));
443 
444         // Copy down EtherDog cooldownIndex
445         uint16 cooldownIndex = uint16(_cooldownIndex);
446 		if (cooldownIndex > 13) {
447 			cooldownIndex = 13;
448 		}
449 
450 		EtherDog memory _EtherDog = EtherDog({
451 			genes: _genes,
452 			birthTime: uint64(_time),
453 			cooldownEndBlock: 0,
454 			matronId: uint32(_matronId),
455 			sireId: uint32(_sireId),
456 			siringWithId: 0,
457 			cooldownIndex: cooldownIndex,
458 			generation: uint16(_generation)
459 			});
460 		uint256 newEtherDogId = EtherDogs.push(_EtherDog) - 1;
461 
462 		// It's probably never going to happen, 4 billion EtherDogs is A LOT, but
463 		// let's just be 100% sure we never let this happen.
464 		require(newEtherDogId == uint256(uint32(newEtherDogId)));
465 
466 		// emit the birth event
467 		Birth(
468 			_owner,
469 			newEtherDogId,
470 			uint256(_EtherDog.matronId),
471 			uint256(_EtherDog.sireId),
472 			_EtherDog.genes,
473             uint256(_EtherDog.generation)
474 		);
475 
476 		// This will assign ownership, and also emit the Transfer event as
477 		// per ERC721 draft
478 		_transfer(0, _owner, newEtherDogId);
479 
480 		return newEtherDogId;
481 	}
482 
483 	// Any C-level can fix how many seconds per blocks are currently observed.
484 	function setSecondsPerBlock(uint256 secs) external onlyCLevel {
485 		require(secs < cooldowns[0]);
486 		secondsPerBlock = secs;
487 	}
488 }
489 
490 
491 /// @title The external contract that is responsible for generating metadata for the EtherDogs,
492 ///  it has one function that will return the data as bytes.
493 contract ERC721Metadata {
494     /// @dev Given a token Id, returns a byte array that is supposed to be converted into string.
495     function getMetadata(uint256 _tokenId, string) public pure returns (bytes32[4] buffer, uint256 count) {
496         if (_tokenId == 1) {
497             buffer[0] = "Hello World! :D";
498             count = 15;
499         } else if (_tokenId == 2) {
500             buffer[0] = "I would definitely choose a medi";
501             buffer[1] = "um length string.";
502             count = 49;
503         } else if (_tokenId == 3) {
504             buffer[0] = "Lorem ipsum dolor sit amet, mi e";
505             buffer[1] = "st accumsan dapibus augue lorem,";
506             buffer[2] = " tristique vestibulum id, libero";
507             buffer[3] = " suscipit varius sapien aliquam.";
508             count = 128;
509         }
510     }
511 }
512 
513 
514 /// @title The facet of the EtherDogs core contract that manages ownership, ERC-721 (draft) compliant.
515 /// @dev Ref: https://github.com/ethereum/EIPs/issues/721
516 ///  See the EtherDogCore contract documentation to understand how the various contract facets are arranged.
517 contract EtherDogOwnership is EtherDogBase, ERC721 {
518 
519     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
520     string public constant name = "EtherDogs";
521     string public constant symbol = "EDOG";
522 
523     // The contract that will return EtherDog metadata
524     ERC721Metadata public erc721Metadata;
525 
526     bytes4 constant InterfaceSignature_ERC165 =
527         bytes4(keccak256('supportsInterface(bytes4)'));
528 
529     bytes4 constant InterfaceSignature_ERC721 =
530         bytes4(keccak256('name()')) ^
531         bytes4(keccak256('symbol()')) ^
532         bytes4(keccak256('totalSupply()')) ^
533         bytes4(keccak256('balanceOf(address)')) ^
534         bytes4(keccak256('ownerOf(uint256)')) ^
535         bytes4(keccak256('approve(address,uint256)')) ^
536         bytes4(keccak256('transfer(address,uint256)')) ^
537         bytes4(keccak256('transferFrom(address,address,uint256)')) ^
538         bytes4(keccak256('tokensOfOwner(address)')) ^
539         bytes4(keccak256('tokenMetadata(uint256,string)'));
540 
541     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
542     ///  Returns true for any standardized interfaces implemented by this contract. We implement
543     ///  ERC-165 (obviously!) and ERC-721.
544     function supportsInterface(bytes4 _interfaceID) external view returns (bool)
545     {
546         // DEBUG ONLY
547         //require((InterfaceSignature_ERC165 == 0x01ffc9a7) && (InterfaceSignature_ERC721 == 0x9a20483d));
548 
549         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
550     }
551 
552     /// @dev Set the address of the sibling contract that tracks metadata.
553     ///  CEO only.
554     function setMetadataAddress(address _contractAddress) public onlyCEO {
555         erc721Metadata = ERC721Metadata(_contractAddress);
556     }
557 
558     // Internal utility functions: These functions all assume that their input arguments
559     // are valid. We leave it to public methods to sanitize their inputs and follow
560     // the required logic.
561 
562     /// @dev Checks if a given address is the current owner of a particular EtherDog.
563     /// @param _claimant the address we are validating against.
564     /// @param _tokenId EtherDog id, only valid when > 0
565     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
566         return EtherDogIndexToOwner[_tokenId] == _claimant;
567     }
568 
569     /// @dev Checks if a given address currently has transferApproval for a particular EtherDog.
570     /// @param _claimant the address we are confirming EtherDog is approved for.
571     /// @param _tokenId EtherDog id, only valid when > 0
572     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
573         return EtherDogIndexToApproved[_tokenId] == _claimant;
574     }
575 
576     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
577     ///  approval. Setting _approved to address(0) clears all transfer approval.
578     ///  NOTE: _approve() does NOT send the Approval event. This is intentional because
579     ///  _approve() and transferFrom() are used together for putting EtherDogs on auction, and
580     ///  there is no value in spamming the log with Approval events in that case.
581     function _approve(uint256 _tokenId, address _approved) internal {
582         EtherDogIndexToApproved[_tokenId] = _approved;
583     }
584 
585     /// @notice Returns the number of EtherDogs owned by a specific address.
586     /// @param _owner The owner address to check.
587     /// @dev Required for ERC-721 compliance
588     function balanceOf(address _owner) public view returns (uint256 count) {
589         return ownershipTokenCount[_owner];
590     }
591 
592     /// @notice Transfers a EtherDog to another address. If transferring to a smart
593     ///  contract be VERY CAREFUL to ensure that it is aware of ERC-721 (or
594     ///  EtherDogs specifically) or your EtherDog may be lost forever. Seriously.
595     /// @param _to The address of the recipient, can be a user or contract.
596     /// @param _tokenId The ID of the EtherDog to transfer.
597     /// @dev Required for ERC-721 compliance.
598     function transfer(
599         address _to,
600         uint256 _tokenId
601     )
602         external
603         whenNotPaused
604     {
605         // Safety check to prevent against an unexpected 0x0 default.
606         require(_to != address(0));
607         // Disallow transfers to this contract to prevent accidental misuse.
608         // The contract should never own any EtherDogs (except very briefly
609         // after a gen0 dog is created and before it goes on auction).
610         require(_to != address(this));
611         // Disallow transfers to the auction contracts to prevent accidental
612         // misuse. Auction contracts should only take ownership of EtherDogs
613         // through the allow + transferFrom flow.
614         require(_to != address(saleAuction));
615         require(_to != address(siringAuction));
616 
617         // You can only send your own dog.
618         require(_owns(msg.sender, _tokenId));
619 
620         // Reassign ownership, clear pending approvals, emit Transfer event.
621         _transfer(msg.sender, _to, _tokenId);
622     }
623 
624     /// @notice Grant another address the right to transfer a specific EtherDog via
625     ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
626     /// @param _to The address to be granted transfer approval. Pass address(0) to
627     ///  clear all approvals.
628     /// @param _tokenId The ID of the EtherDog that can be transferred if this call succeeds.
629     /// @dev Required for ERC-721 compliance.
630     function approve(
631         address _to,
632         uint256 _tokenId
633     )
634         external
635         whenNotPaused
636     {
637         // Only an owner can grant transfer approval.
638         require(_owns(msg.sender, _tokenId));
639 
640         // Register the approval (replacing any previous approval).
641         _approve(_tokenId, _to);
642 
643         // Emit approval event.
644         Approval(msg.sender, _to, _tokenId);
645     }
646 
647     /// @notice Transfer a EtherDog owned by another address, for which the calling address
648     ///  has previously been granted transfer approval by the owner.
649     /// @param _from The address that owns the EtherDog to be transfered.
650     /// @param _to The address that should take ownership of the EtherDog. Can be any address,
651     ///  including the caller.
652     /// @param _tokenId The ID of the EtherDog to be transferred.
653     /// @dev Required for ERC-721 compliance.
654     function transferFrom(
655         address _from,
656         address _to,
657         uint256 _tokenId
658     )
659         external
660         whenNotPaused
661     {
662         // Safety check to prevent against an unexpected 0x0 default.
663         require(_to != address(0));
664         // Disallow transfers to this contract to prevent accidental misuse.
665         // The contract should never own any EtherDogs (except very briefly
666         // after a gen0 dog is created and before it goes on auction).
667         require(_to != address(this));
668         // Check for approval and valid ownership
669         require(_approvedFor(msg.sender, _tokenId));
670         require(_owns(_from, _tokenId));
671 
672         // Reassign ownership (also clears pending approvals and emits Transfer event).
673         _transfer(_from, _to, _tokenId);
674     }
675 
676     /// @notice Returns the total number of EtherDogs currently in existence.
677     /// @dev Required for ERC-721 compliance.
678     function totalSupply() public view returns (uint) {
679         return EtherDogs.length - 1;
680     }
681 
682     /// @notice Returns the address currently assigned ownership of a given EtherDog.
683     /// @dev Required for ERC-721 compliance.
684     function ownerOf(uint256 _tokenId)
685         external
686         view
687         returns (address owner)
688     {
689         owner = EtherDogIndexToOwner[_tokenId];
690 
691         require(owner != address(0));
692     }
693 
694     /// @notice Returns a list of all EtherDog IDs assigned to an address.
695     /// @param _owner The owner whose EtherDogs we are interested in.
696     /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
697     ///  expensive (it walks the entire EtherDog array looking for dogs belonging to owner),
698     ///  but it also returns a dynamic array, which is only supported for web3 calls, and
699     ///  not contract-to-contract calls.
700     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
701         uint256 tokenCount = balanceOf(_owner);
702 
703         if (tokenCount == 0) {
704             // Return an empty array
705             return new uint256[](0);
706         } else {
707             uint256[] memory result = new uint256[](tokenCount);
708             uint256 totalDogs = totalSupply();
709             uint256 resultIndex = 0;
710 
711             // We count on the fact that all dogs have IDs starting at 1 and increasing
712             // sequentially up to the totalDog count.
713             uint256 dogId;
714 
715             for (dogId = 1; dogId <= totalDogs; dogId++) {
716                 if (EtherDogIndexToOwner[dogId] == _owner) {
717                     result[resultIndex] = dogId;
718                     resultIndex++;
719                 }
720             }
721 
722             return result;
723         }
724     }
725 
726     /// @dev Adapted from memcpy() by @arachnid (Nick Johnson <arachnid@notdot.net>)
727     ///  This method is licenced under the Apache License.
728     ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
729     function _memcpy(uint _dest, uint _src, uint _len) private view {
730         // Copy word-length chunks while possible
731         for(; _len >= 32; _len -= 32) {
732             assembly {
733                 mstore(_dest, mload(_src))
734             }
735             _dest += 32;
736             _src += 32;
737         }
738 
739         // Copy remaining bytes
740         uint256 mask = 256 ** (32 - _len) - 1;
741         assembly {
742             let srcpart := and(mload(_src), not(mask))
743             let destpart := and(mload(_dest), mask)
744             mstore(_dest, or(destpart, srcpart))
745         }
746     }
747 
748     /// @dev Adapted from toString(slice) by @arachnid (Nick Johnson <arachnid@notdot.net>)
749     ///  This method is licenced under the Apache License.
750     ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
751     function _toString(bytes32[4] _rawBytes, uint256 _stringLength) private view returns (string) {
752         var outputString = new string(_stringLength);
753         uint256 outputPtr;
754         uint256 bytesPtr;
755 
756         assembly {
757             outputPtr := add(outputString, 32)
758             bytesPtr := _rawBytes
759         }
760 
761         _memcpy(outputPtr, bytesPtr, _stringLength);
762 
763         return outputString;
764     }
765 
766     /// @notice Returns a URI pointing to a metadata package for this token conforming to
767     ///  ERC-721 (https://github.com/ethereum/EIPs/issues/721)
768     /// @param _tokenId The ID number of the EtherDog whose metadata should be returned.
769     function tokenMetadata(uint256 _tokenId, string _preferredTransport) external view returns (string infoUrl) {
770         require(erc721Metadata != address(0));
771         bytes32[4] memory buffer;
772         uint256 count;
773         (buffer, count) = erc721Metadata.getMetadata(_tokenId, _preferredTransport);
774 
775         return _toString(buffer, count);
776     }
777 }
778 
779 
780 /// @title A facet of EtherDogCore that manages EtherDog siring, gestation, and birth.
781 /// @author Axiom Zen (https://www.axiomzen.co)
782 /// @dev See the EtherDogCore contract documentation to understand how the various contract facets are arranged.
783 contract EtherDogBreeding is EtherDogOwnership {
784 
785     /// @dev The Pregnant event is fired when two dogs successfully breed and the pregnancy
786     ///  timer begins for the matron.
787     event Pregnant(address owner, uint256 matronId, uint256 sireId, uint256 matronCooldownEndBlock, uint256 sireCooldownEndBlock);
788 
789     /// @notice The minimum payment required to use breedWithAuto(). This fee goes towards
790     ///  the gas cost paid by whatever calls giveBirth(), and can be dynamically updated by
791     ///  the COO role as the gas price changes.
792     uint256 public autoBirthFee = 2 finney;
793 
794     // Keeps track of number of pregnant EtherDogs.
795     uint256 public pregnantEtherDogs;
796 
797     /// @dev The address of the sibling contract that is used to implement the sooper-sekret
798     ///  genetic combination algorithm.
799     GeneScienceInterface public geneScience;
800 
801     /// @dev Update the address of the genetic contract, can only be called by the CEO.
802     /// @param _address An address of a GeneScience contract instance to be used from this point forward.
803     function setGeneScienceAddress(address _address) external onlyCEO {
804         GeneScienceInterface candidateContract = GeneScienceInterface(_address);
805 
806         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
807         require(candidateContract.isGeneScience());
808 
809         // Set the new contract address
810         geneScience = candidateContract;
811     }
812 
813     /// @dev Checks that a given EtherDog is able to breed. Requires that the
814     ///  current cooldown is finished (for sires) and also checks that there is
815     ///  no pending pregnancy.
816     function _isReadyToBreed(EtherDog _dog) internal view returns (bool) {
817         // In addition to checking the cooldownEndBlock, we also need to check to see if
818         // the dog has a pending birth; there can be some period of time between the end
819         // of the pregnacy timer and the birth event.
820         return (_dog.siringWithId == 0) && (_dog.cooldownEndBlock <= uint64(block.number));
821     }
822 
823     /// @dev Check if a sire has authorized breeding with this matron. True if both sire
824     ///  and matron have the same owner, or if the sire has given siring permission to
825     ///  the matron's owner (via approveSiring()).
826     function _isSiringPermitted(uint256 _sireId, uint256 _matronId) internal view returns (bool) {
827         address matronOwner = EtherDogIndexToOwner[_matronId];
828         address sireOwner = EtherDogIndexToOwner[_sireId];
829 
830         // Siring is okay if they have same owner, or if the matron's owner was given
831         // permission to breed with this sire.
832         return (matronOwner == sireOwner || sireAllowedToAddress[_sireId] == matronOwner);
833     }
834 
835     /// @dev Set the cooldownEndTime for the given EtherDog, based on its current cooldownIndex.
836     ///  Also increments the cooldownIndex (unless it has hit the cap).
837     /// @param _dog A reference to the EtherDog in storage which needs its timer started.
838     function _triggerCooldown(EtherDog storage _dog) internal {
839         // Compute an estimation of the cooldown time in blocks (based on current cooldownIndex).
840         _dog.cooldownEndBlock = uint64((cooldowns[_dog.cooldownIndex]/secondsPerBlock) + block.number);
841 
842         // Increment the breeding count, clamping it at 13, which is the length of the
843         // cooldowns array. We could check the array size dynamically, but hard-coding
844         // this as a constant saves gas. Yay, Solidity!
845         if (_dog.cooldownIndex < 13) {
846             _dog.cooldownIndex += 1;
847         }
848     }
849 
850     /// @notice Grants approval to another user to sire with one of your EtherDogs.
851     /// @param _addr The address that will be able to sire with your EtherDog. Set to
852     ///  address(0) to clear all siring approvals for this EtherDog.
853     /// @param _sireId A EtherDog that you own that _addr will now be able to sire with.
854     function approveSiring(address _addr, uint256 _sireId)
855         external
856         whenNotPaused
857     {
858         require(_owns(msg.sender, _sireId));
859         sireAllowedToAddress[_sireId] = _addr;
860     }
861 
862     /// @dev Updates the minimum payment required for calling giveBirthAuto(). Can only
863     ///  be called by the COO address. (This fee is used to offset the gas cost incurred
864     ///  by the autobirth daemon).
865     function setAutoBirthFee(uint256 val) external onlyCOO {
866         autoBirthFee = val;
867     }
868 
869     /// @dev Checks to see if a given EtherDog is pregnant and (if so) if the gestation
870     ///  period has passed.
871     function _isReadyToGiveBirth(EtherDog _matron) private view returns (bool) {
872         return (_matron.siringWithId != 0) && (_matron.cooldownEndBlock <= uint64(block.number));
873     }
874 
875     /// @notice Checks that a given EtherDog is able to breed (i.e. it is not pregnant or
876     ///  in the middle of a siring cooldown).
877     /// @param _EtherDogId reference the id of the EtherDog, any user can inquire about it
878     function isReadyToBreed(uint256 _EtherDogId)
879         public
880         view
881         returns (bool)
882     {
883         require(_EtherDogId > 0);
884         EtherDog storage kit = EtherDogs[_EtherDogId];
885         return _isReadyToBreed(kit);
886     }
887 
888     /// @dev Checks whether a EtherDog is currently pregnant.
889     /// @param _EtherDogId reference the id of the EtherDog, any user can inquire about it
890     function isPregnant(uint256 _EtherDogId)
891         public
892         view
893         returns (bool)
894     {
895         require(_EtherDogId > 0);
896         // A EtherDog is pregnant if and only if this field is set
897         return EtherDogs[_EtherDogId].siringWithId != 0;
898     }
899 
900     /// @dev Internal check to see if a given sire and matron are a valid mating pair. DOES NOT
901     ///  check ownership permissions (that is up to the caller).
902     /// @param _matron A reference to the EtherDog struct of the potential matron.
903     /// @param _matronId The matron's ID.
904     /// @param _sire A reference to the EtherDog struct of the potential sire.
905     /// @param _sireId The sire's ID
906     function _isValidMatingPair(
907         EtherDog storage _matron,
908         uint256 _matronId,
909         EtherDog storage _sire,
910         uint256 _sireId
911     )
912         private
913         view
914         returns(bool)
915     {
916         // A EtherDog can't breed with itself!
917         if (_matronId == _sireId) {
918             return false;
919         }
920 
921         // EtherDogs can't breed with their parents.
922         if (_matron.matronId == _sireId || _matron.sireId == _sireId) {
923             return false;
924         }
925         if (_sire.matronId == _matronId || _sire.sireId == _matronId) {
926             return false;
927         }
928 
929         // We can short circuit the sibling check (below) if either dog is
930         // gen zero (has a matron ID of zero).
931         if (_sire.matronId == 0 || _matron.matronId == 0) {
932             return true;
933         }
934 
935         // EtherDogs can't breed with full or half siblings.
936         if (_sire.matronId == _matron.matronId || _sire.matronId == _matron.sireId) {
937             return false;
938         }
939         if (_sire.sireId == _matron.matronId || _sire.sireId == _matron.sireId) {
940             return false;
941         }
942 
943         // Everything seems cool! Let's get DTF.
944         return true;
945     }
946 
947     /// @dev Internal check to see if a given sire and matron are a valid mating pair for
948     ///  breeding via auction (i.e. skips ownership and siring approval checks).
949     function _canBreedWithViaAuction(uint256 _matronId, uint256 _sireId)
950         internal
951         view
952         returns (bool)
953     {
954         EtherDog storage matron = EtherDogs[_matronId];
955         EtherDog storage sire = EtherDogs[_sireId];
956         return _isValidMatingPair(matron, _matronId, sire, _sireId);
957     }
958 
959     /// @notice Checks to see if two dogs can breed together, including checks for
960     ///  ownership and siring approvals. Does NOT check that both dogs are ready for
961     ///  breeding (i.e. breedWith could still fail until the cooldowns are finished).
962     ///  TODO: Shouldn't this check pregnancy and cooldowns?!?
963     /// @param _matronId The ID of the proposed matron.
964     /// @param _sireId The ID of the proposed sire.
965     function canBreedWith(uint256 _matronId, uint256 _sireId)
966         external
967         view
968         returns(bool)
969     {
970         require(_matronId > 0);
971         require(_sireId > 0);
972         EtherDog storage matron = EtherDogs[_matronId];
973         EtherDog storage sire = EtherDogs[_sireId];
974         return _isValidMatingPair(matron, _matronId, sire, _sireId) &&
975             _isSiringPermitted(_sireId, _matronId);
976     }
977 
978     /// @dev Internal utility function to initiate breeding, assumes that all breeding
979     ///  requirements have been checked.
980     function _breedWith(uint256 _matronId, uint256 _sireId) internal {
981         // Grab a reference to the EtherDogs from storage.
982         EtherDog storage sire = EtherDogs[_sireId];
983         EtherDog storage matron = EtherDogs[_matronId];
984 
985         // Mark the matron as pregnant, keeping track of who the sire is.
986         matron.siringWithId = uint32(_sireId);
987 
988         // Trigger the cooldown for both parents.
989         _triggerCooldown(sire);
990         _triggerCooldown(matron);
991 
992         // Clear siring permission for both parents. This may not be strictly necessary
993         // but it's likely to avoid confusion!
994         delete sireAllowedToAddress[_matronId];
995         delete sireAllowedToAddress[_sireId];
996 
997         // Every time a EtherDog gets pregnant, counter is incremented.
998         pregnantEtherDogs++;
999 
1000         // Emit the pregnancy event.
1001         Pregnant(EtherDogIndexToOwner[_matronId], _matronId, _sireId, matron.cooldownEndBlock, sire.cooldownEndBlock);
1002     }
1003 
1004     /// @notice Breed a EtherDog you own (as matron) with a sire that you own, or for which you
1005     ///  have previously been given Siring approval. Will either make your dog pregnant, or will
1006     ///  fail entirely. Requires a pre-payment of the fee given out to the first caller of giveBirth()
1007     /// @param _matronId The ID of the EtherDog acting as matron (will end up pregnant if successful)
1008     /// @param _sireId The ID of the EtherDog acting as sire (will begin its siring cooldown if successful)
1009     function breedWithAuto(uint256 _matronId, uint256 _sireId)
1010         external
1011         payable
1012         whenNotPaused
1013     {
1014         // Checks for payment.
1015         require(msg.value >= autoBirthFee);
1016 
1017         // Caller must own the matron.
1018         require(_owns(msg.sender, _matronId));
1019 
1020         // Neither sire nor matron are allowed to be on auction during a normal
1021         // breeding operation, but we don't need to check that explicitly.
1022         // For matron: The caller of this function can't be the owner of the matron
1023         //   because the owner of a EtherDog on auction is the auction house, and the
1024         //   auction house will never call breedWith().
1025         // For sire: Similarly, a sire on auction will be owned by the auction house
1026         //   and the act of transferring ownership will have cleared any oustanding
1027         //   siring approval.
1028         // Thus we don't need to spend gas explicitly checking to see if either dog
1029         // is on auction.
1030 
1031         // Check that matron and sire are both owned by caller, or that the sire
1032         // has given siring permission to caller (i.e. matron's owner).
1033         // Will fail for _sireId = 0
1034         require(_isSiringPermitted(_sireId, _matronId));
1035 
1036         // Grab a reference to the potential matron
1037         EtherDog storage matron = EtherDogs[_matronId];
1038 
1039         // Make sure matron isn't pregnant, or in the middle of a siring cooldown
1040         require(_isReadyToBreed(matron));
1041 
1042         // Grab a reference to the potential sire
1043         EtherDog storage sire = EtherDogs[_sireId];
1044 
1045         // Make sure sire isn't pregnant, or in the middle of a siring cooldown
1046         require(_isReadyToBreed(sire));
1047 
1048         // Test that these dogs are a valid mating pair.
1049         require(_isValidMatingPair(
1050             matron,
1051             _matronId,
1052             sire,
1053             _sireId
1054         ));
1055 
1056         // All checks passed, EtherDog gets pregnant!
1057         _breedWith(_matronId, _sireId);
1058     }
1059 
1060     /// @notice Have a pregnant EtherDog give birth!
1061     /// @param _matronId A EtherDog ready to give birth.
1062     /// @return The EtherDog ID of the new EtherDog.
1063     /// @dev Looks at a given EtherDog and, if pregnant and if the gestation period has passed,
1064     ///  combines the genes of the two parents to create a new EtherDog. The new EtherDog is assigned
1065     ///  to the current owner of the matron. Upon successful completion, both the matron and the
1066     ///  new EtherDog will be ready to breed again. Note that anyone can call this function (if they
1067     ///  are willing to pay the gas!), but the new EtherDog always goes to the mother's owner.
1068     function giveBirth(uint256 _matronId)
1069         external
1070         whenNotPaused
1071         returns(uint256)
1072     {
1073         // Grab a reference to the matron in storage.
1074         EtherDog storage matron = EtherDogs[_matronId];
1075 
1076         // Check that the matron is a valid dog.
1077         require(matron.birthTime != 0);
1078 
1079         // Check that the matron is pregnant, and that its time has come!
1080         require(_isReadyToGiveBirth(matron));
1081 
1082         // Grab a reference to the sire in storage.
1083         uint256 sireId = matron.siringWithId;
1084         EtherDog storage sire = EtherDogs[sireId];
1085 
1086         // Determine the higher generation number of the two parents
1087         uint16 parentGen = matron.generation;
1088         if (sire.generation > matron.generation) {
1089             parentGen = sire.generation;
1090         }
1091 
1092         // Call the sooper-sekret gene mixing operation.
1093         uint256 childGenes = geneScience.mixGenes(matron.genes, sire.genes, matron.cooldownEndBlock - 1);
1094 
1095         // Make the new EtherDog!
1096         address owner = EtherDogIndexToOwner[_matronId];
1097         uint256 EtherDogId = _createEtherDog(_matronId, matron.siringWithId, parentGen + 1, childGenes, owner);
1098 
1099         // Clear the reference to sire from the matron (REQUIRED! Having siringWithId
1100         // set is what marks a matron as being pregnant.)
1101         delete matron.siringWithId;
1102 
1103         // Every time a EtherDog gives birth counter is decremented.
1104         pregnantEtherDogs--;
1105 
1106         // Send the balance fee to the person who made birth happen.
1107         msg.sender.transfer(autoBirthFee);
1108 
1109         // return the new EtherDog's ID
1110         return EtherDogId;
1111     }
1112 }
1113 
1114 
1115 
1116 
1117 
1118 
1119 /// @title Auction Core
1120 /// @dev Contains models, variables, and internal methods for the auction.
1121 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1122 contract ClockAuctionBase {
1123 
1124     // Represents an auction on an NFT
1125     struct Auction {
1126         // Current owner of NFT
1127         address seller;
1128         // Price (in wei) at beginning of auction
1129         uint128 startingPrice;
1130         // Price (in wei) at end of auction
1131         uint128 endingPrice;
1132         // Duration (in seconds) of auction
1133         uint64 duration;
1134         // Time when auction started
1135         // NOTE: 0 if this auction has been concluded
1136         uint64 startedAt;
1137     }
1138 
1139     // Reference to contract tracking NFT ownership
1140     ERC721 public nonFungibleContract;
1141 
1142     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
1143     // Values 0-10,000 map to 0%-100%
1144     uint256 public ownerCut;
1145 
1146     // Map from token ID to their corresponding auction.
1147     mapping (uint256 => Auction) tokenIdToAuction;
1148 
1149     event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
1150     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
1151     event AuctionCancelled(uint256 tokenId);
1152 
1153     /// @dev Returns true if the claimant owns the token.
1154     /// @param _claimant - Address claiming to own the token.
1155     /// @param _tokenId - ID of token whose ownership to verify.
1156     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
1157         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
1158     }
1159 
1160     /// @dev Escrows the NFT, assigning ownership to this contract.
1161     /// Throws if the escrow fails.
1162     /// @param _owner - Current owner address of token to escrow.
1163     /// @param _tokenId - ID of token whose approval to verify.
1164     function _escrow(address _owner, uint256 _tokenId) internal {
1165         // it will throw if transfer fails
1166         nonFungibleContract.transferFrom(_owner, this, _tokenId);
1167     }
1168 
1169     /// @dev Transfers an NFT owned by this contract to another address.
1170     /// Returns true if the transfer succeeds.
1171     /// @param _receiver - Address to transfer NFT to.
1172     /// @param _tokenId - ID of token to transfer.
1173     function _transfer(address _receiver, uint256 _tokenId) internal {
1174         // it will throw if transfer fails
1175         nonFungibleContract.transfer(_receiver, _tokenId);
1176     }
1177 
1178     /// @dev Adds an auction to the list of open auctions. Also fires the
1179     ///  AuctionCreated event.
1180     /// @param _tokenId The ID of the token to be put on auction.
1181     /// @param _auction Auction to add.
1182     function _addAuction(uint256 _tokenId, Auction _auction) internal {
1183         // Require that all auctions have a duration of
1184         // at least one minute. (Keeps our math from getting hairy!)
1185         require(_auction.duration >= 1 minutes);
1186 
1187         tokenIdToAuction[_tokenId] = _auction;
1188 
1189         AuctionCreated(
1190             uint256(_tokenId),
1191             uint256(_auction.startingPrice),
1192             uint256(_auction.endingPrice),
1193             uint256(_auction.duration)
1194         );
1195     }
1196 
1197     /// @dev Cancels an auction unconditionally.
1198     function _cancelAuction(uint256 _tokenId, address _seller) internal {
1199         _removeAuction(_tokenId);
1200         _transfer(_seller, _tokenId);
1201         AuctionCancelled(_tokenId);
1202     }
1203 
1204     /// @dev Computes the price and transfers winnings.
1205     /// Does NOT transfer ownership of token.
1206     function _bid(uint256 _tokenId, uint256 _bidAmount)
1207         internal
1208         returns (uint256)
1209     {
1210         // Get a reference to the auction struct
1211         Auction storage auction = tokenIdToAuction[_tokenId];
1212 
1213         // Explicitly check that this auction is currently live.
1214         // (Because of how Ethereum mappings work, we can't just count
1215         // on the lookup above failing. An invalid _tokenId will just
1216         // return an auction object that is all zeros.)
1217         require(_isOnAuction(auction));
1218 
1219         // Check that the bid is greater than or equal to the current price
1220         uint256 price = _currentPrice(auction);
1221         require(_bidAmount >= price);
1222 
1223         // Grab a reference to the seller before the auction struct
1224         // gets deleted.
1225         address seller = auction.seller;
1226 
1227         // The bid is good! Remove the auction before sending the fees
1228         // to the sender so we can't have a reentrancy attack.
1229         _removeAuction(_tokenId);
1230 
1231         // Transfer proceeds to seller (if there are any!)
1232         if (price > 0) {
1233             // Calculate the auctioneer's cut.
1234             // (NOTE: _computeCut() is guaranteed to return a
1235             // value <= price, so this subtraction can't go negative.)
1236             uint256 auctioneerCut = _computeCut(price);
1237             uint256 sellerProceeds = price - auctioneerCut;
1238 
1239             // NOTE: Doing a transfer() in the middle of a complex
1240             // method like this is generally discouraged because of
1241             // reentrancy attacks and DoS attacks if the seller is
1242             // a contract with an invalid fallback function. We explicitly
1243             // guard against reentrancy attacks by removing the auction
1244             // before calling transfer(), and the only thing the seller
1245             // can DoS is the sale of their own asset! (And if it's an
1246             // accident, they can call cancelAuction(). )
1247             seller.transfer(sellerProceeds);
1248         }
1249 
1250         // Calculate any excess funds included with the bid. If the excess
1251         // is anything worth worrying about, transfer it back to bidder.
1252         // NOTE: We checked above that the bid amount is greater than or
1253         // equal to the price so this cannot underflow.
1254         uint256 bidExcess = _bidAmount - price;
1255 
1256         // Return the funds. Similar to the previous transfer, this is
1257         // not susceptible to a re-entry attack because the auction is
1258         // removed before any transfers occur.
1259         msg.sender.transfer(bidExcess);
1260 
1261         // Tell the world!
1262         AuctionSuccessful(_tokenId, price, msg.sender);
1263 
1264         return price;
1265     }
1266 
1267     /// @dev Removes an auction from the list of open auctions.
1268     /// @param _tokenId - ID of NFT on auction.
1269     function _removeAuction(uint256 _tokenId) internal {
1270         delete tokenIdToAuction[_tokenId];
1271     }
1272 
1273     /// @dev Returns true if the NFT is on auction.
1274     /// @param _auction - Auction to check.
1275     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
1276         return (_auction.startedAt > 0);
1277     }
1278 
1279     /// @dev Returns current price of an NFT on auction. Broken into two
1280     ///  functions (this one, that computes the duration from the auction
1281     ///  structure, and the other that does the price computation) so we
1282     ///  can easily test that the price computation works correctly.
1283     function _currentPrice(Auction storage _auction)
1284         internal
1285         view
1286         returns (uint256)
1287     {
1288         uint256 secondsPassed = 0;
1289 
1290         // A bit of insurance against negative values (or wraparound).
1291         // Probably not necessary (since Ethereum guarnatees that the
1292         // now variable doesn't ever go backwards).
1293         if (now > _auction.startedAt) {
1294             secondsPassed = now - _auction.startedAt;
1295         }
1296 
1297         return _computeCurrentPrice(
1298             _auction.startingPrice,
1299             _auction.endingPrice,
1300             _auction.duration,
1301             secondsPassed
1302         );
1303     }
1304 
1305     /// @dev Computes the current price of an auction. Factored out
1306     ///  from _currentPrice so we can run extensive unit tests.
1307     ///  When testing, make this function public and turn on
1308     ///  `Current price computation` test suite.
1309     function _computeCurrentPrice(
1310         uint256 _startingPrice,
1311         uint256 _endingPrice,
1312         uint256 _duration,
1313         uint256 _secondsPassed
1314     )
1315         internal
1316         pure
1317         returns (uint256)
1318     {
1319         // NOTE: We don't use SafeMath (or similar) in this function because
1320         //  all of our public functions carefully cap the maximum values for
1321         //  time (at 64-bits) and currency (at 128-bits). _duration is
1322         //  also known to be non-zero (see the require() statement in
1323         //  _addAuction())
1324         if (_secondsPassed >= _duration) {
1325             // We've reached the end of the dynamic pricing portion
1326             // of the auction, just return the end price.
1327             return _endingPrice;
1328         } else {
1329             // Starting price can be higher than ending price (and often is!), so
1330             // this delta can be negative.
1331             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
1332 
1333             // This multiplication can't overflow, _secondsPassed will easily fit within
1334             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
1335             // will always fit within 256-bits.
1336             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
1337 
1338             // currentPriceChange can be negative, but if so, will have a magnitude
1339             // less that _startingPrice. Thus, this result will always end up positive.
1340             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
1341 
1342             return uint256(currentPrice);
1343         }
1344     }
1345 
1346     /// @dev Computes owner's cut of a sale.
1347     /// @param _price - Sale price of NFT.
1348     function _computeCut(uint256 _price) internal view returns (uint256) {
1349         // NOTE: We don't use SafeMath (or similar) in this function because
1350         //  all of our entry functions carefully cap the maximum values for
1351         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
1352         //  statement in the ClockAuction constructor). The result of this
1353         //  function is always guaranteed to be <= _price.
1354         return _price * ownerCut / 10000;
1355     }
1356 }
1357 
1358 
1359 
1360 
1361 
1362 
1363 /**
1364  * @title Pausable
1365  * @dev Base contract which allows children to implement an emergency stop mechanism.
1366  */
1367 contract Pausable is Ownable {
1368 	event Pause();
1369 	event Unpause();
1370 
1371 	bool public paused = false;
1372 
1373 
1374 	/**
1375 	 * @dev modifier to allow actions only when the contract IS paused
1376 	 */
1377 	modifier whenNotPaused() {
1378 		require(!paused);
1379 		_;
1380 	}
1381 
1382 	/**
1383 	 * @dev modifier to allow actions only when the contract IS NOT paused
1384 	 */
1385 	modifier whenPaused {
1386 		require(paused);
1387 		_;
1388 	}
1389 
1390 	/**
1391 	 * @dev called by the owner to pause, triggers stopped state
1392 	 */
1393 	function pause() public onlyOwner whenNotPaused returns (bool) {
1394 		paused = true;
1395 		Pause();
1396 		return true;
1397 	}
1398 
1399 	/**
1400 	 * @dev called by the owner to unpause, returns to normal state
1401 	 */
1402 	function unpause() public onlyOwner whenPaused returns (bool) {
1403 		paused = false;
1404 		Unpause();
1405 		return true;
1406 	}
1407 }
1408 
1409 
1410 /// @title Clock auction for non-fungible tokens.
1411 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1412 contract ClockAuction is Pausable, ClockAuctionBase {
1413 
1414     /// @dev The ERC-165 interface signature for ERC-721.
1415     ///  Ref: https://github.com/ethereum/EIPs/issues/165
1416     ///  Ref: https://github.com/ethereum/EIPs/issues/721
1417     bytes4 constant InterfaceSignature_ERC721 = bytes4(0x9a20483d);
1418 
1419     /// @dev Constructor creates a reference to the NFT ownership contract
1420     ///  and verifies the owner cut is in the valid range.
1421     /// @param _nftAddress - address of a deployed contract implementing
1422     ///  the Nonfungible Interface.
1423     /// @param _cut - percent cut the owner takes on each auction, must be
1424     ///  between 0-10,000.
1425     function ClockAuction(address _nftAddress, uint256 _cut) public {
1426         require(_cut <= 10000);
1427         ownerCut = _cut;
1428 
1429         ERC721 candidateContract = ERC721(_nftAddress);
1430         require(candidateContract.supportsInterface(InterfaceSignature_ERC721));
1431         nonFungibleContract = candidateContract;
1432     }
1433 
1434     /// @dev Remove all Ether from the contract, which is the owner's cuts
1435     ///  as well as any Ether sent directly to the contract address.
1436     ///  Always transfers to the NFT contract, but can be called either by
1437     ///  the owner or the NFT contract.
1438     function withdrawBalance() external {
1439         address nftAddress = address(nonFungibleContract);
1440 
1441         require(
1442             msg.sender == owner ||
1443             msg.sender == nftAddress
1444         );
1445         // We are using this boolean method to make sure that even if one fails it will still work
1446         nftAddress.transfer(this.balance);
1447     }
1448 
1449     /// @dev Creates and begins a new auction.
1450     /// @param _tokenId - ID of token to auction, sender must be owner.
1451     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
1452     /// @param _endingPrice - Price of item (in wei) at end of auction.
1453     /// @param _duration - Length of time to move between starting
1454     ///  price and ending price (in seconds).
1455     /// @param _seller - Seller, if not the message sender
1456     function createAuction(
1457         uint256 _tokenId,
1458         uint256 _startingPrice,
1459         uint256 _endingPrice,
1460         uint256 _duration,
1461         address _seller
1462     )
1463         external
1464         whenNotPaused
1465     {
1466         // Sanity check that no inputs overflow how many bits we've allocated
1467         // to store them in the auction struct.
1468         require(_startingPrice == uint256(uint128(_startingPrice)));
1469         require(_endingPrice == uint256(uint128(_endingPrice)));
1470         require(_duration == uint256(uint64(_duration)));
1471 
1472         require(_owns(msg.sender, _tokenId));
1473         _escrow(msg.sender, _tokenId);
1474         Auction memory auction = Auction(
1475             _seller,
1476             uint128(_startingPrice),
1477             uint128(_endingPrice),
1478             uint64(_duration),
1479             uint64(now)
1480         );
1481         _addAuction(_tokenId, auction);
1482     }
1483 
1484     /// @dev Bids on an open auction, completing the auction and transferring
1485     ///  ownership of the NFT if enough Ether is supplied.
1486     /// @param _tokenId - ID of token to bid on.
1487     function bid(uint256 _tokenId)
1488         external
1489         payable
1490         whenNotPaused
1491     {
1492         // _bid will throw if the bid or funds transfer fails
1493         _bid(_tokenId, msg.value);
1494         _transfer(msg.sender, _tokenId);
1495     }
1496 
1497     /// @dev Cancels an auction that hasn't been won yet.
1498     ///  Returns the NFT to original owner.
1499     /// @notice This is a state-modifying function that can
1500     ///  be called while the contract is paused.
1501     /// @param _tokenId - ID of token on auction
1502     function cancelAuction(uint256 _tokenId)
1503         external
1504     {
1505         Auction storage auction = tokenIdToAuction[_tokenId];
1506         require(_isOnAuction(auction));
1507         address seller = auction.seller;
1508         require(msg.sender == seller);
1509         _cancelAuction(_tokenId, seller);
1510     }
1511 
1512     /// @dev Cancels an auction when the contract is paused.
1513     ///  Only the owner may do this, and NFTs are returned to
1514     ///  the seller. This should only be used in emergencies.
1515     /// @param _tokenId - ID of the NFT on auction to cancel.
1516     function cancelAuctionWhenPaused(uint256 _tokenId)
1517         whenPaused
1518         onlyOwner
1519         external
1520     {
1521         Auction storage auction = tokenIdToAuction[_tokenId];
1522         require(_isOnAuction(auction));
1523         _cancelAuction(_tokenId, auction.seller);
1524     }
1525 
1526     /// @dev Returns auction info for an NFT on auction.
1527     /// @param _tokenId - ID of NFT on auction.
1528     function getAuction(uint256 _tokenId)
1529         external
1530         view
1531         returns
1532     (
1533         address seller,
1534         uint256 startingPrice,
1535         uint256 endingPrice,
1536         uint256 duration,
1537         uint256 startedAt
1538     ) {
1539         Auction storage auction = tokenIdToAuction[_tokenId];
1540         require(_isOnAuction(auction));
1541         return (
1542             auction.seller,
1543             auction.startingPrice,
1544             auction.endingPrice,
1545             auction.duration,
1546             auction.startedAt
1547         );
1548     }
1549 
1550     /// @dev Returns the current price of an auction.
1551     /// @param _tokenId - ID of the token price we are checking.
1552     function getCurrentPrice(uint256 _tokenId)
1553         external
1554         view
1555         returns (uint256)
1556     {
1557         Auction storage auction = tokenIdToAuction[_tokenId];
1558         require(_isOnAuction(auction));
1559         return _currentPrice(auction);
1560     }
1561 
1562 }
1563 
1564 
1565 /// @title Reverse auction modified for siring
1566 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1567 contract SiringClockAuction is ClockAuction {
1568 
1569     // @dev Sanity check that allows us to ensure that we are pointing to the
1570     //  right auction in our setSiringAuctionAddress() call.
1571     bool public isSiringClockAuction = true;
1572 
1573     // Delegate constructor
1574     function SiringClockAuction(address _nftAddr, uint256 _cut) public
1575         ClockAuction(_nftAddr, _cut) {}
1576 
1577     /// @dev Creates and begins a new auction. Since this function is wrapped,
1578     /// require sender to be EtherDogCore contract.
1579     /// @param _tokenId - ID of token to auction, sender must be owner.
1580     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
1581     /// @param _endingPrice - Price of item (in wei) at end of auction.
1582     /// @param _duration - Length of auction (in seconds).
1583     /// @param _seller - Seller, if not the message sender
1584     function createAuction(
1585         uint256 _tokenId,
1586         uint256 _startingPrice,
1587         uint256 _endingPrice,
1588         uint256 _duration,
1589         address _seller
1590     )
1591         external
1592     {
1593         // Sanity check that no inputs overflow how many bits we've allocated
1594         // to store them in the auction struct.
1595         require(_startingPrice == uint256(uint128(_startingPrice)));
1596         require(_endingPrice == uint256(uint128(_endingPrice)));
1597         require(_duration == uint256(uint64(_duration)));
1598 
1599         require(msg.sender == address(nonFungibleContract));
1600         _escrow(_seller, _tokenId);
1601         Auction memory auction = Auction(
1602             _seller,
1603             uint128(_startingPrice),
1604             uint128(_endingPrice),
1605             uint64(_duration),
1606             uint64(now)
1607         );
1608         _addAuction(_tokenId, auction);
1609     }
1610 
1611     /// @dev Places a bid for siring. Requires the sender
1612     /// is the EtherDogCore contract because all bid methods
1613     /// should be wrapped. Also returns the EtherDog to the
1614     /// seller rather than the winner.
1615     function bid(uint256 _tokenId)
1616         external
1617         payable
1618     {
1619         require(msg.sender == address(nonFungibleContract));
1620         address seller = tokenIdToAuction[_tokenId].seller;
1621         // _bid checks that token ID is valid and will throw if bid fails
1622         _bid(_tokenId, msg.value);
1623         // We transfer the EtherDog back to the seller, the winner will get
1624         // the offspring
1625         _transfer(seller, _tokenId);
1626     }
1627 
1628 }
1629 
1630 
1631 /// @title Clock auction modified for sale of EtherDogs
1632 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1633 contract SaleClockAuction is ClockAuction {
1634 
1635     // @dev Sanity check that allows us to ensure that we are pointing to the
1636     //  right auction in our setSaleAuctionAddress() call.
1637     bool public isSaleClockAuction = true;
1638 
1639     // Tracks last 5 sale price of gen0 EtherDog sales
1640     uint256 public gen0SaleCount;
1641     uint256[5] public lastGen0SalePrices;
1642 
1643     // Delegate constructor
1644     function SaleClockAuction(address _nftAddr, uint256 _cut) public
1645         ClockAuction(_nftAddr, _cut) {}
1646 
1647     /// @dev Creates and begins a new auction.
1648     /// @param _tokenId - ID of token to auction, sender must be owner.
1649     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
1650     /// @param _endingPrice - Price of item (in wei) at end of auction.
1651     /// @param _duration - Length of auction (in seconds).
1652     /// @param _seller - Seller, if not the message sender
1653     function createAuction(
1654         uint256 _tokenId,
1655         uint256 _startingPrice,
1656         uint256 _endingPrice,
1657         uint256 _duration,
1658         address _seller
1659     )
1660         external
1661     {
1662         // Sanity check that no inputs overflow how many bits we've allocated
1663         // to store them in the auction struct.
1664         require(_startingPrice == uint256(uint128(_startingPrice)));
1665         require(_endingPrice == uint256(uint128(_endingPrice)));
1666         require(_duration == uint256(uint64(_duration)));
1667 
1668         require(msg.sender == address(nonFungibleContract));
1669         _escrow(_seller, _tokenId);
1670         Auction memory auction = Auction(
1671             _seller,
1672             uint128(_startingPrice),
1673             uint128(_endingPrice),
1674             uint64(_duration),
1675             uint64(now)
1676         );
1677         _addAuction(_tokenId, auction);
1678     }
1679 
1680     /// @dev Updates lastSalePrice if seller is the nft contract
1681     /// Otherwise, works the same as default bid method.
1682     function bid(uint256 _tokenId)
1683         external
1684         payable
1685     {
1686         // _bid verifies token ID size
1687         address seller = tokenIdToAuction[_tokenId].seller;
1688         uint256 price = _bid(_tokenId, msg.value);
1689         _transfer(msg.sender, _tokenId);
1690 
1691         // If not a gen0 auction, exit
1692         if (seller == address(nonFungibleContract)) {
1693             // Track gen0 sale prices
1694             lastGen0SalePrices[gen0SaleCount % 5] = price;
1695             gen0SaleCount++;
1696         }
1697     }
1698 
1699     function averageGen0SalePrice() external view returns (uint256) {
1700         uint256 sum = 0;
1701         for (uint256 i = 0; i < 5; i++) {
1702             sum += lastGen0SalePrices[i];
1703         }
1704         return sum / 5;
1705     }
1706 
1707 }
1708 
1709 
1710 /// @title Handles creating auctions for sale and siring of EtherDogs.
1711 ///  This wrapper of ReverseAuction exists only so that users can create
1712 ///  auctions with only one transaction.
1713 contract EtherDogAuction is EtherDogBreeding {
1714 
1715     // @notice The auction contract variables are defined in EtherDogBase to allow
1716     //  us to refer to them in EtherDogOwnership to prevent accidental transfers.
1717     // `saleAuction` refers to the auction for gen0 and p2p sale of EtherDogs.
1718     // `siringAuction` refers to the auction for siring rights of EtherDogs.
1719 
1720     /// @dev Sets the reference to the sale auction.
1721     /// @param _address - Address of sale contract.
1722     function setSaleAuctionAddress(address _address) external onlyCEO {
1723         SaleClockAuction candidateContract = SaleClockAuction(_address);
1724 
1725         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
1726         require(candidateContract.isSaleClockAuction());
1727 
1728         // Set the new contract address
1729         saleAuction = candidateContract;
1730     }
1731 
1732     /// @dev Sets the reference to the siring auction.
1733     /// @param _address - Address of siring contract.
1734     function setSiringAuctionAddress(address _address) external onlyCEO {
1735         SiringClockAuction candidateContract = SiringClockAuction(_address);
1736 
1737         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
1738         require(candidateContract.isSiringClockAuction());
1739 
1740         // Set the new contract address
1741         siringAuction = candidateContract;
1742     }
1743 
1744     /// @dev Put a EtherDog up for auction.
1745     ///  Does some ownership trickery to create auctions in one tx.
1746     function createSaleAuction(
1747         uint256 _EtherDogId,
1748         uint256 _startingPrice,
1749         uint256 _endingPrice,
1750         uint256 _duration
1751     )
1752         external
1753         whenNotPaused
1754     {
1755         // Auction contract checks input sizes
1756         // If EtherDog is already on any auction, this will throw
1757         // because it will be owned by the auction contract.
1758         require(_owns(msg.sender, _EtherDogId));
1759         // Ensure the EtherDog is not pregnant to prevent the auction
1760         // contract accidentally receiving ownership of the child.
1761         // NOTE: the EtherDog IS allowed to be in a cooldown.
1762         require(!isPregnant(_EtherDogId));
1763         _approve(_EtherDogId, saleAuction);
1764         // Sale auction throws if inputs are invalid and clears
1765         // transfer and sire approval after escrowing the EtherDog.
1766         saleAuction.createAuction(
1767             _EtherDogId,
1768             _startingPrice,
1769             _endingPrice,
1770             _duration,
1771             msg.sender
1772         );
1773     }
1774 
1775     /// @dev Put a EtherDog up for auction to be sire.
1776     ///  Performs checks to ensure the EtherDog can be sired, then
1777     ///  delegates to reverse auction.
1778     function createSiringAuction(
1779         uint256 _EtherDogId,
1780         uint256 _startingPrice,
1781         uint256 _endingPrice,
1782         uint256 _duration
1783     )
1784         external
1785         whenNotPaused
1786     {
1787         // Auction contract checks input sizes
1788         // If EtherDog is already on any auction, this will throw
1789         // because it will be owned by the auction contract.
1790         require(_owns(msg.sender, _EtherDogId));
1791         require(isReadyToBreed(_EtherDogId));
1792         _approve(_EtherDogId, siringAuction);
1793         // Siring auction throws if inputs are invalid and clears
1794         // transfer and sire approval after escrowing the EtherDog.
1795         siringAuction.createAuction(
1796             _EtherDogId,
1797             _startingPrice,
1798             _endingPrice,
1799             _duration,
1800             msg.sender
1801         );
1802     }
1803 
1804     /// @dev Completes a siring auction by bidding.
1805     ///  Immediately breeds the winning matron with the sire on auction.
1806     /// @param _sireId - ID of the sire on auction.
1807     /// @param _matronId - ID of the matron owned by the bidder.
1808     function bidOnSiringAuction(
1809         uint256 _sireId,
1810         uint256 _matronId
1811     )
1812         external
1813         payable
1814         whenNotPaused
1815     {
1816         // Auction contract checks input sizes
1817         require(_owns(msg.sender, _matronId));
1818         require(isReadyToBreed(_matronId));
1819         require(_canBreedWithViaAuction(_matronId, _sireId));
1820 
1821         // Define the current price of the auction.
1822         uint256 currentPrice = siringAuction.getCurrentPrice(_sireId);
1823         require(msg.value >= currentPrice + autoBirthFee);
1824 
1825         // Siring auction will throw if the bid fails.
1826         siringAuction.bid.value(msg.value - autoBirthFee)(_sireId);
1827         _breedWith(uint32(_matronId), uint32(_sireId));
1828     }
1829 
1830     /// @dev Transfers the balance of the sale auction contract
1831     /// to the EtherDogCore contract. We use two-step withdrawal to
1832     /// prevent two transfer calls in the auction bid function.
1833     function withdrawAuctionBalances() external onlyCLevel {
1834         saleAuction.withdrawBalance();
1835         siringAuction.withdrawBalance();
1836     }
1837 }
1838 
1839 
1840 /// @title all functions related to creating EtherDogs
1841 contract EtherDogMinting is EtherDogAuction {
1842 
1843     // Limits the number of dogs the contract owner can ever create.
1844     uint256 public constant DEFAULT_CREATION_LIMIT = 50000;
1845 
1846     // Counts the number of dogs the contract owner has created.
1847     uint256 public defaultCreatedCount;
1848 
1849 
1850     /// @dev we can create EtherDogs with different generations. Only callable by COO
1851     /// @param _genes The encoded genes of the EtherDog to be created, any value is accepted
1852     /// @param _owner The future owner of the created EtherDog. Default to contract COO
1853     /// @param _time The birth time of EtherDog
1854     /// @param _cooldownIndex The cooldownIndex of EtherDog
1855     function createDefaultGen0EtherDog(uint256 _genes, address _owner, uint256 _time, uint256 _cooldownIndex) external onlyCOO {
1856 
1857         require(_time == uint256(uint64(_time)));
1858         require(_cooldownIndex == uint256(uint16(_cooldownIndex)));
1859 
1860         require(_time > 0);
1861         require(_cooldownIndex >= 0 && _cooldownIndex <= 13);
1862 
1863         address EtherDogOwner = _owner;
1864         if (EtherDogOwner == address(0)) {
1865             EtherDogOwner = cooAddress;
1866         }
1867         require(defaultCreatedCount < DEFAULT_CREATION_LIMIT);
1868 
1869         defaultCreatedCount++;
1870         _createEtherDogWithTime(0, 0, 0, _genes, EtherDogOwner, _time, _cooldownIndex);
1871     }
1872 
1873     /// @dev we can create EtherDogs with different generations. Only callable by COO
1874     /// @param _matronId The EtherDog ID of the matron of this EtherDog
1875     /// @param _sireId The EtherDog ID of the sire of this EtherDog
1876     /// @param _genes The encoded genes of the EtherDog to be created, any value is accepted
1877     /// @param _owner The future owner of the created EtherDog. Default to contract COO
1878     /// @param _time The birth time of EtherDog
1879     /// @param _cooldownIndex The cooldownIndex of EtherDog
1880     function createDefaultEtherDog(uint256 _matronId, uint256 _sireId, uint256 _genes, address _owner, uint256 _time, uint256 _cooldownIndex) external onlyCOO {
1881 
1882         require(_matronId == uint256(uint32(_matronId)));
1883         require(_sireId == uint256(uint32(_sireId)));
1884         require(_time == uint256(uint64(_time)));
1885         require(_cooldownIndex == uint256(uint16(_cooldownIndex)));
1886 
1887         require(_time > 0);
1888         require(_cooldownIndex >= 0 && _cooldownIndex <= 13);
1889 
1890         address EtherDogOwner = _owner;
1891         if (EtherDogOwner == address(0)) {
1892             EtherDogOwner = cooAddress;
1893         }
1894 
1895         require(_matronId > 0);
1896         require(_sireId > 0);
1897 
1898         // Grab a reference to the matron in storage.
1899         EtherDog storage matron = EtherDogs[_matronId];
1900 
1901         // Grab a reference to the sire in storage.
1902         EtherDog storage sire = EtherDogs[_sireId];
1903 
1904         // Determine the higher generation number of the two parents
1905         uint16 parentGen = matron.generation;
1906         if (sire.generation > matron.generation) {
1907             parentGen = sire.generation;
1908         }
1909 
1910         _createEtherDogWithTime(_matronId, _sireId, parentGen + 1, _genes, EtherDogOwner, _time, _cooldownIndex);
1911     }
1912 
1913 }
1914 
1915 
1916 /// @title EtherDogs: Collectible, breedable, and oh-so-adorable EtherDogs on the Ethereum blockchain.
1917 /// @dev The main EtherDogs contract, keeps track of dogs so they don't wander around and get lost.
1918 contract EtherDogCore is EtherDogMinting {
1919 /* contract EtherDogCore { */
1920     // This is the main EtherDogs contract. In order to keep our code seperated into logical sections,
1921     // we've broken it up in two ways. First, we have several seperately-instantiated sibling contracts
1922     // that handle auctions and our super-top-secret genetic combination algorithm. The auctions are
1923     // seperate since their logic is somewhat complex and there's always a risk of subtle bugs. By keeping
1924     // them in their own contracts, we can upgrade them without disrupting the main contract that tracks
1925     // EtherDog ownership. The genetic combination algorithm is kept seperate so we can open-source all of
1926     // the rest of our code without making it _too_ easy for folks to figure out how the genetics work.
1927     // Don't worry, I'm sure someone will reverse engineer it soon enough!
1928     //
1929     // Secondly, we break the core contract into multiple files using inheritence, one for each major
1930     // facet of functionality of CK. This allows us to keep related code bundled together while still
1931     // avoiding a single giant file with everything in it. The breakdown is as follows:
1932     //
1933     //      - EtherDogBase: This is where we define the most fundamental code shared throughout the core
1934     //             functionality. This includes our main data storage, constants and data types, plus
1935     //             internal functions for managing these items.
1936     //
1937     //      - EtherDogAccessControl: This contract manages the various addresses and constraints for operations
1938     //             that can be executed only by specific roles. Namely CEO, CFO and COO.
1939     //
1940     //      - EtherDogOwnership: This provides the methods required for basic non-fungible token
1941     //             transactions, following the draft ERC-721 spec (https://github.com/ethereum/EIPs/issues/721).
1942     //
1943     //      - EtherDogBreeding: This file contains the methods necessary to breed EtherDogs together, including
1944     //             keeping track of siring offers, and relies on an external genetic combination contract.
1945     //
1946     //      - EtherDogAuctions: Here we have the public methods for auctioning or bidding on EtherDogs or siring
1947     //             services. The actual auction functionality is handled in two sibling contracts (one
1948     //             for sales and one for siring), while auction creation and bidding is mostly mediated
1949     //             through this facet of the core contract.
1950     //
1951     //      - EtherDogMinting: This final facet contains the functionality we use for creating new gen0 EtherDogs.
1952     //             We can make up to 5000 "promo" EtherDogs that can be given away (especially important when
1953     //             the community is new), and all others can only be created and then immediately put up
1954     //             for auction via an algorithmically determined starting price. Regardless of how they
1955     //             are created, there is a hard limit of 2400*12*12 gen0 EtherDogs. After that, it's all up to the
1956     //             community to breed, breed, breed!
1957 
1958     // Set in case the core contract is broken and an upgrade is required
1959     address public newContractAddress;
1960 
1961     /// @notice Creates the main EtherDogs smart contract instance.
1962     function EtherDogCore() public {
1963         // Starts paused.
1964         paused = true;
1965 
1966         // the creator of the contract is the initial CEO
1967         ceoAddress = msg.sender;
1968 
1969         // the creator of the contract is also the initial COO
1970         cooAddress = msg.sender;
1971 
1972         // start with the mythical EtherDog 0 - so we don't have generation-0 parent issues
1973         _createEtherDog(0, 0, 0, uint256(-1), address(0));
1974     }
1975 
1976     /// @dev Used to mark the smart contract as upgraded, in case there is a serious
1977     ///  breaking bug. This method does nothing but keep track of the new contract and
1978     ///  emit a message indicating that the new address is set. It's up to clients of this
1979     ///  contract to update to the new contract address in that case. (This contract will
1980     ///  be paused indefinitely if such an upgrade takes place.)
1981     /// @param _v2Address new address
1982     function setNewAddress(address _v2Address) external onlyCEO whenPaused {
1983         // See README.md for updgrade plan
1984         newContractAddress = _v2Address;
1985         ContractUpgrade(_v2Address);
1986     }
1987 
1988     /// @notice No tipping!
1989     /// @dev Reject all Ether from being sent here, unless it's from one of the
1990     ///  two auction contracts. (Hopefully, we can prevent user accidents.)
1991     function() external payable {
1992         require(
1993             msg.sender == address(saleAuction) ||
1994             msg.sender == address(siringAuction)
1995         );
1996     }
1997 
1998     /// @notice Returns all the relevant information about a specific EtherDog.
1999     /// @param _id The ID of the EtherDog of interest.
2000     function getEtherDog(uint256 _id)
2001         external
2002         view
2003         returns (
2004         bool isGestating,
2005         bool isReady,
2006         uint256 cooldownIndex,
2007         uint256 nextActionAt,
2008         uint256 siringWithId,
2009         uint256 birthTime,
2010         uint256 matronId,
2011         uint256 sireId,
2012         uint256 generation,
2013         uint256 genes
2014     ) {
2015         EtherDog storage dog = EtherDogs[_id];
2016 
2017         // if this variable is 0 then it's not gestating
2018         isGestating = (dog.siringWithId != 0);
2019         isReady = (dog.cooldownEndBlock <= block.number);
2020         cooldownIndex = uint256(dog.cooldownIndex);
2021         nextActionAt = uint256(dog.cooldownEndBlock);
2022         siringWithId = uint256(dog.siringWithId);
2023         birthTime = uint256(dog.birthTime);
2024         matronId = uint256(dog.matronId);
2025         sireId = uint256(dog.sireId);
2026         generation = uint256(dog.generation);
2027         genes = dog.genes;
2028     }
2029 
2030     /// @dev Override unpause so it requires all external contract addresses
2031     ///  to be set before contract can be unpaused. Also, we can't have
2032     ///  newContractAddress set either, because then the contract was upgraded.
2033     /// @notice This is public rather than external so we can call super.unpause
2034     ///  without using an expensive CALL.
2035     function unpause() public onlyCEO whenPaused {
2036         require(saleAuction != address(0));
2037         require(siringAuction != address(0));
2038         require(geneScience != address(0));
2039         require(newContractAddress == address(0));
2040 
2041         // Actually unpause the contract.
2042         super.unpause();
2043     }
2044 
2045     // @dev Allows the CFO to capture the balance available to the contract.
2046     function withdrawBalance() external onlyCFO {
2047         uint256 balance = this.balance;
2048         // Subtract all the currently pregnant dogs we have, plus 1 of margin.
2049         uint256 subtractFees = (pregnantEtherDogs + 1) * autoBirthFee;
2050 
2051         if (balance > subtractFees) {
2052             cfoAddress.transfer(balance - subtractFees);
2053         }
2054     }
2055 }