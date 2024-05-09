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
74     /// @dev given genes of Zodiacs 1 & 2, return a genetic combination - may have a random factor
75     /// @param genes1 genes of mom
76     /// @param genes2 genes of sire
77     /// @return the genes that are supposed to be passed down the child
78     function mixGenes(uint256 genes1, uint256 genes2, uint256 targetBlock) public returns (uint256);
79 }
80 
81 
82 /// @title A facet of ZodiacCore that manages special access privileges.
83 /// @author Axiom Zen (https://www.axiomzen.co)
84 /// @dev See the ZodiacCore contract documentation to understand how the various contract facets are arranged.
85 contract ZodiacACL {
86     // This facet controls access control for Zodiacs. There are four roles managed here:
87     //
88     //     - The CEO: The CEO can reassign other roles and change the addresses of our dependent smart
89     //         contracts. It is also the only role that can unpause the smart contract. It is initially
90     //         set to the address that created the smart contract in the ZodiacCore constructor.
91     //
92     //     - The CFO: The CFO can withdraw funds from ZodiacCore and its auction contracts.
93     //
94     //     - The COO: The COO can release gen0 Zodiacs to auction, and mint promo Zodiacs.
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
197 /// @title Base contract for CryptoZodiac. Holds all common structs, events and base variables.
198 /// @author Axiom Zen (https://www.axiomzen.co)
199 /// @dev See the ZodiacCore contract documentation to understand how the various contract facets are arranged.
200 contract ZodiacBase is ZodiacACL {
201 	/*** EVENTS ***/
202 
203 	/// @dev The Birth event is fired whenever a new Zodiac comes into existence. This obviously
204 	///  includes any time a zodiac is created through the giveBirth method, but it is also called
205 	///  when a new gen0 zodiac is created.
206     event Birth(address owner, uint256 ZodiacId, uint256 matronId, uint256 sireId, uint256 genes, uint256 generation, uint256 zodiacType);
207 
208 	/// @dev Transfer event as defined in current draft of ERC721. Emitted every time a Zodiac
209 	///  ownership is assigned, including births.
210 	event Transfer(address from, address to, uint256 tokenId);
211 
212 	/*** DATA TYPES ***/
213 
214 	/// @dev The main Zodiac struct. Every zodiac in CryptoZodiac is represented by a copy
215 	///  of this structure, so great care was taken to ensure that it fits neatly into
216 	///  exactly two 256-bit words. Note that the order of the members in this structure
217 	///  is important because of the byte-packing rules used by Ethereum.
218 	///  Ref: http://solidity.readthedocs.io/en/develop/miscellaneous.html
219 	struct Zodiac {
220 		// The Zodiac's genetic code is packed into these 256-bits, the format is
221 		// sooper-sekret! A zodiac's genes never change.
222 		uint256 genes;
223 
224 		// The timestamp from the block when this zodiac came into existence.
225 		uint64 birthTime;
226 
227 		// The minimum timestamp after which this zodiac can engage in breeding
228 		// activities again. This same timestamp is used for the pregnancy
229 		// timer (for matrons) as well as the siring cooldown.
230 		uint64 cooldownEndBlock;
231 
232 		// The ID of the parents of this Zodiac, set to 0 for gen0 zodiacs.
233 		// Note that using 32-bit unsigned integers limits us to a "mere"
234 		// 4 billion zodiacs. This number might seem small until you realize
235 		// that Ethereum currently has a limit of about 500 million
236 		// transactions per year! So, this definitely won't be a problem
237 		// for several years (even as Ethereum learns to scale).
238 		uint32 matronId;
239 		uint32 sireId;
240 
241 		// Set to the ID of the sire zodiac for matrons that are pregnant,
242 		// zero otherwise. A non-zero value here is how we know a zodiac
243 		// is pregnant. Used to retrieve the genetic material for the new
244 		// Zodiac when the birth transpires.
245 		uint32 siringWithId;
246 
247 		// Set to the index in the cooldown array (see below) that represents
248 		// the current cooldown duration for this Zodiac. This starts at zero
249 		// for gen0 zodiacs, and is initialized to floor(generation/2) for others.
250 		// Incremented by one for each successful breeding action, regardless
251 		// of whether this zodiac is acting as matron or sire.
252 		uint16 cooldownIndex;
253 
254 		// The "generation number" of this zodiac. zodiacs minted by the CZ contract
255 		// for sale are called "gen0" and have a generation number of 0. The
256 		// generation number of all other zodiacs is the larger of the two generation
257 		// numbers of their parents, plus one.
258 		// (i.e. max(matron.generation, sire.generation) + 1)
259 		uint16 generation;
260 
261 		// The type of this zodiac, including 12 types
262 		uint16 zodiacType;
263 
264 	}
265 
266 	/*** CONSTANTS ***/
267 
268 	/// @dev A lookup table inzodiacing the cooldown duration after any successful
269 	///  breeding action, called "pregnancy time" for matrons and "siring cooldown"
270 	///  for sires. Designed such that the cooldown roughly doubles each time a zodiac
271 	///  is bred, encouraging owners not to just keep breeding the same zodiac over
272 	///  and over again. Caps out at one week (a zodiac can breed an unbounded number
273 	///  of times, and the maximum cooldown is always seven days).
274 	uint32[14] public cooldowns = [
275 		uint32(1 minutes),
276 		uint32(2 minutes),
277 		uint32(5 minutes),
278 		uint32(10 minutes),
279 		uint32(30 minutes),
280 		uint32(1 hours),
281 		uint32(2 hours),
282 		uint32(4 hours),
283 		uint32(8 hours),
284 		uint32(16 hours),
285 		uint32(1 days),
286 		uint32(2 days),
287 		uint32(4 days),
288 		uint32(7 days)
289 	];
290 
291 	// An approximation of currently how many seconds are in between blocks.
292 	uint256 public secondsPerBlock = 15;
293 
294 	/*** STORAGE ***/
295 
296 //    // Limits the number of Zodiacs of different types the contract owner can ever create.
297 //    uint32 public constant OWNER_CREATION_LIMIT = 1000000;
298 
299 
300 	/// @dev An array containing the Zodiac struct for all Zodiacs in existence. The ID
301 	///  of each zodiac is actually an index into this array. Note that ID 0 is a negazodiac,
302 	///  the unZodiac, the mythical beast that is the parent of all gen0 zodiacs. A bizarre
303 	///  creature that is both matron and sire... to itself! Has an invalid genetic code.
304 	///  In other words, zodiac ID 0 is invalid... ;-)
305 	Zodiac[] zodiacs;
306 
307 	/// @dev A mapping from zodiac IDs to the address that owns them. All zodiacs have
308 	///  some valid owner address, even gen0 zodiacs are created with a non-zero owner.
309 	mapping (uint256 => address) public ZodiacIndexToOwner;
310 
311 	// @dev A mapping from owner address to count of tokens that address owns.
312 	//  Used internally inside balanceOf() to resolve ownership count.
313 	mapping (address => uint256) ownershipTokenCount;
314 
315 	/// @dev A mapping from ZodiacIDs to an address that has been approved to call
316 	///  transferFrom(). Each Zodiac can only have one approved address for transfer
317 	///  at any time. A zero value means no approval is outstanding.
318 	mapping (uint256 => address) public ZodiacIndexToApproved;
319 
320 	/// @dev A mapping from ZodiacIDs to an address that has been approved to use
321 	///  this Zodiac for siring via breedWith(). Each Zodiac can only have one approved
322 	///  address for siring at any time. A zero value means no approval is outstanding.
323 	mapping (uint256 => address) public sireAllowedToAddress;
324 
325 	/// @dev The address of the ClockAuction contract that handles sales of Zodiacs. This
326 	///  same contract handles both peer-to-peer sales as well as the gen0 sales which are
327 	///  initiated every 15 minutes.
328 	SaleClockAuction public saleAuction;
329 
330 	/// @dev The address of a custom ClockAuction subclassed contract that handles siring
331 	///  auctions. Needs to be separate from saleAuction because the actions taken on success
332 	///  after a sales and siring auction are quite different.
333 	SiringClockAuction public siringAuction;
334 
335 	/// @dev Assigns ownership of a specific Zodiac to an address.
336 	function _transfer(address _from, address _to, uint256 _tokenId) internal {
337 		// Since the number of Zodiacs is capped to 2^32 we can't overflow this
338 		ownershipTokenCount[_to]++;
339 		// transfer ownership
340 		ZodiacIndexToOwner[_tokenId] = _to;
341 		// When creating new Zodiacs _from is 0x0, but we can't account that address.
342 		if (_from != address(0)) {
343 			ownershipTokenCount[_from]--;
344 			// once the Zodiac is transferred also clear sire allowances
345 			delete sireAllowedToAddress[_tokenId];
346 			// clear any previously approved ownership exchange
347 			delete ZodiacIndexToApproved[_tokenId];
348 		}
349 		// Emit the transfer event.
350 		Transfer(_from, _to, _tokenId);
351 	}
352 
353 	/// @dev An internal method that creates a new Zodiac and stores it. This
354 	///  method doesn't do any checking and should only be called when the
355 	///  input data is known to be valid. Will generate both a Birth event
356 	///  and a Transfer event.
357 	/// @param _matronId The Zodiac ID of the matron of this zodiac (zero for gen0)
358 	/// @param _sireId The Zodiac ID of the sire of this zodiac (zero for gen0)
359 	/// @param _generation The generation number of this zodiac, must be computed by caller.
360 	/// @param _genes The Zodiac's genetic code.
361 	/// @param _owner The inital owner of this zodiac, must be non-zero (except for the unZodiac, ID 0)
362 	/// @param _zodiacType The type of this zodiac
363 	function _createZodiac(
364 		uint256 _matronId,
365 		uint256 _sireId,
366 		uint256 _generation,
367 		uint256 _genes,
368 		address _owner,
369 		uint256 _zodiacType
370 	)
371 		internal
372 		returns (uint)
373 	{
374 		// These requires are not strictly necessary, our calling code should make
375 		// sure that these conditions are never broken. However! _createZodiac() is already
376 		// an expensive call (for storage), and it doesn't hurt to be especially careful
377 		// to ensure our data structures are always valid.
378 		require(_matronId == uint256(uint32(_matronId)));
379 		require(_sireId == uint256(uint32(_sireId)));
380 		require(_generation == uint256(uint16(_generation)));
381         require(_zodiacType == uint256(uint16(_zodiacType)));
382 
383 		// New Zodiac starts with the same cooldown as parent gen/2
384 		uint16 cooldownIndex = uint16(_generation / 2);
385 		if (cooldownIndex > 13) {
386 			cooldownIndex = 13;
387 		}
388 
389 		Zodiac memory _Zodiac = Zodiac({
390 			genes: _genes,
391 			birthTime: uint64(now),
392 			cooldownEndBlock: 0,
393 			matronId: uint32(_matronId),
394 			sireId: uint32(_sireId),
395 			siringWithId: 0,
396 			cooldownIndex: cooldownIndex,
397 			generation: uint16(_generation),
398 			zodiacType: uint16(_zodiacType)
399 		});
400 		uint256 newZodiacId = zodiacs.push(_Zodiac) - 1;
401 
402 		// It's probably never going to happen, 4 billion zodiacs is A LOT, but
403 		// let's just be 100% sure we never let this happen.
404 		require(newZodiacId == uint256(uint32(newZodiacId)));
405 
406 		// emit the birth event
407 		Birth(
408 			_owner,
409 			newZodiacId,
410 			uint256(_Zodiac.matronId),
411 			uint256(_Zodiac.sireId),
412 			_Zodiac.genes,
413 			uint256(_Zodiac.generation),
414 			uint256(_Zodiac.zodiacType)
415 		);
416 
417 		// This will assign ownership, and also emit the Transfer event as
418 		// per ERC721 draft
419 		_transfer(0, _owner, newZodiacId);
420 
421 		return newZodiacId;
422 	}
423 
424 	/// @dev An internal method that creates a new Zodiac and stores it. This
425 	///  method doesn't do any checking and should only be called when the
426 	///  input data is known to be valid. Will generate both a Birth event
427 	///  and a Transfer event.
428 	/// @param _matronId The Zodiac ID of the matron of this zodiac (zero for gen0)
429 	/// @param _sireId The Zodiac ID of the sire of this zodiac (zero for gen0)
430 	/// @param _generation The generation number of this zodiac, must be computed by caller.
431 	/// @param _genes The Zodiac's genetic code.
432 	/// @param _owner The inital owner of this zodiac, must be non-zero (except for the unZodiac, ID 0)
433 	/// @param _time The birth time of zodiac
434 	/// @param _cooldownIndex The cooldownIndex of zodiac
435 	/// @param _zodiacType The type of this zodiac
436 	function _createZodiacWithTime(
437 		uint256 _matronId,
438 		uint256 _sireId,
439 		uint256 _generation,
440 		uint256 _genes,
441 		address _owner,
442 		uint256 _time,
443 		uint256 _cooldownIndex,
444 		uint256 _zodiacType
445 	)
446 	internal
447 	returns (uint)
448 	{
449 		// These requires are not strictly necessary, our calling code should make
450 		// sure that these conditions are never broken. However! _createZodiac() is already
451 		// an expensive call (for storage), and it doesn't hurt to be especially careful
452 		// to ensure our data structures are always valid.
453 		require(_matronId == uint256(uint32(_matronId)));
454 		require(_sireId == uint256(uint32(_sireId)));
455 		require(_generation == uint256(uint16(_generation)));
456 		require(_zodiacType == uint256(uint16(_zodiacType)));
457         require(_time == uint256(uint64(_time)));
458         require(_cooldownIndex == uint256(uint16(_cooldownIndex)));
459 
460 		// Copy down Zodiac cooldownIndex
461 		uint16 cooldownIndex = uint16(_cooldownIndex);
462 		if (cooldownIndex > 13) {
463 			cooldownIndex = 13;
464 		}
465 
466 		Zodiac memory _Zodiac = Zodiac({
467 			genes: _genes,
468 			birthTime: uint64(_time),
469 			cooldownEndBlock: 0,
470 			matronId: uint32(_matronId),
471 			sireId: uint32(_sireId),
472 			siringWithId: 0,
473 			cooldownIndex: cooldownIndex,
474 			generation: uint16(_generation),
475 			zodiacType: uint16(_zodiacType)
476 			});
477 		uint256 newZodiacId = zodiacs.push(_Zodiac) - 1;
478 
479 		// It's probably never going to happen, 4 billion zodiacs is A LOT, but
480 		// let's just be 100% sure we never let this happen.
481 		require(newZodiacId == uint256(uint32(newZodiacId)));
482 
483 		// emit the birth event
484 		Birth(
485 			_owner,
486 			newZodiacId,
487 			uint256(_Zodiac.matronId),
488 			uint256(_Zodiac.sireId),
489 			_Zodiac.genes,
490 			uint256(_Zodiac.generation),
491 			uint256(_Zodiac.zodiacType)
492 		);
493 
494 		// This will assign ownership, and also emit the Transfer event as
495 		// per ERC721 draft
496 		_transfer(0, _owner, newZodiacId);
497 
498 		return newZodiacId;
499 	}
500 
501 	// Any C-level can fix how many seconds per blocks are currently observed.
502 	function setSecondsPerBlock(uint256 secs) external onlyCLevel {
503 		require(secs < cooldowns[0]);
504 		secondsPerBlock = secs;
505 	}
506 }
507 
508 
509 /// @title The external contract that is responsible for generating metadata for the zodiacs,
510 ///  it has one function that will return the data as bytes.
511 contract ERC721Metadata {
512     /// @dev Given a token Id, returns a byte array that is supposed to be converted into string.
513     function getMetadata(uint256 _tokenId, string) public pure returns (bytes32[4] buffer, uint256 count) {
514         if (_tokenId == 1) {
515             buffer[0] = "Hello World! :D";
516             count = 15;
517         } else if (_tokenId == 2) {
518             buffer[0] = "I would definitely choose a medi";
519             buffer[1] = "um length string.";
520             count = 49;
521         } else if (_tokenId == 3) {
522             buffer[0] = "Lorem ipsum dolor sit amet, mi e";
523             buffer[1] = "st accumsan dapibus augue lorem,";
524             buffer[2] = " tristique vestibulum id, libero";
525             buffer[3] = " suscipit varius sapien aliquam.";
526             count = 128;
527         }
528     }
529 }
530 
531 
532 /// @title The facet of the CryptoZodiacs core contract that manages ownership, ERC-721 (draft) compliant.
533 /// @dev Ref: https://github.com/ethereum/EIPs/issues/721
534 ///  See the ZodiacCore contract documentation to understand how the various contract facets are arranged.
535 contract ZodiacOwnership is ZodiacBase, ERC721 {
536 
537     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
538     string public constant name = "CryptoZodiacs";
539     string public constant symbol = "CZ";
540 
541     // The contract that will return Zodiac metadata
542     ERC721Metadata public erc721Metadata;
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
570     /// @dev Set the address of the sibling contract that tracks metadata.
571     ///  CEO only.
572     function setMetadataAddress(address _contractAddress) public onlyCEO {
573         erc721Metadata = ERC721Metadata(_contractAddress);
574     }
575 
576     // Internal utility functions: These functions all assume that their input arguments
577     // are valid. We leave it to public methods to sanitize their inputs and follow
578     // the required logic.
579 
580     /// @dev Checks if a given address is the current owner of a particular Zodiac.
581     /// @param _claimant the address we are validating against.
582     /// @param _tokenId zodiac id, only valid when > 0
583     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
584         return ZodiacIndexToOwner[_tokenId] == _claimant;
585     }
586 
587     /// @dev Checks if a given address currently has transferApproval for a particular Zodiac.
588     /// @param _claimant the address we are confirming zodiac is approved for.
589     /// @param _tokenId zodiac id, only valid when > 0
590     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
591         return ZodiacIndexToApproved[_tokenId] == _claimant;
592     }
593 
594     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
595     ///  approval. Setting _approved to address(0) clears all transfer approval.
596     ///  NOTE: _approve() does NOT send the Approval event. This is intentional because
597     ///  _approve() and transferFrom() are used together for putting Zodiacs on auction, and
598     ///  there is no value in spamming the log with Approval events in that case.
599     function _approve(uint256 _tokenId, address _approved) internal {
600         ZodiacIndexToApproved[_tokenId] = _approved;
601     }
602 
603     /// @notice Returns the number of Zodiacs owned by a specific address.
604     /// @param _owner The owner address to check.
605     /// @dev Required for ERC-721 compliance
606     function balanceOf(address _owner) public view returns (uint256 count) {
607         return ownershipTokenCount[_owner];
608     }
609 
610     /// @notice Transfers a Zodiac to another address. If transferring to a smart
611     ///  contract be VERY CAREFUL to ensure that it is aware of ERC-721 (or
612     ///  CryptoZodiacs specifically) or your Zodiac may be lost forever. Seriously.
613     /// @param _to The address of the recipient, can be a user or contract.
614     /// @param _tokenId The ID of the Zodiac to transfer.
615     /// @dev Required for ERC-721 compliance.
616     function transfer(
617         address _to,
618         uint256 _tokenId
619     )
620         external
621         whenNotPaused
622     {
623         // Safety check to prevent against an unexpected 0x0 default.
624         require(_to != address(0));
625         // Disallow transfers to this contract to prevent accidental misuse.
626         // The contract should never own any Zodiacs (except very briefly
627         // after a gen0 Zodiac is created and before it goes on auction).
628         require(_to != address(this));
629         // Disallow transfers to the auction contracts to prevent accidental
630         // misuse. Auction contracts should only take ownership of Zodiacs
631         // through the allow + transferFrom flow.
632         require(_to != address(saleAuction));
633         require(_to != address(siringAuction));
634 
635         // You can only send your own Zodiac.
636         require(_owns(msg.sender, _tokenId));
637 
638         // Reassign ownership, clear pending approvals, emit Transfer event.
639         _transfer(msg.sender, _to, _tokenId);
640     }
641 
642     /// @notice Grant another address the right to transfer a specific Zodiac via
643     ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
644     /// @param _to The address to be granted transfer approval. Pass address(0) to
645     ///  clear all approvals.
646     /// @param _tokenId The ID of the Zodiac that can be transferred if this call succeeds.
647     /// @dev Required for ERC-721 compliance.
648     function approve(
649         address _to,
650         uint256 _tokenId
651     )
652         external
653         whenNotPaused
654     {
655         // Only an owner can grant transfer approval.
656         require(_owns(msg.sender, _tokenId));
657 
658         // Register the approval (replacing any previous approval).
659         _approve(_tokenId, _to);
660 
661         // Emit approval event.
662         Approval(msg.sender, _to, _tokenId);
663     }
664 
665     /// @notice Transfer a Zodiac owned by another address, for which the calling address
666     ///  has previously been granted transfer approval by the owner.
667     /// @param _from The address that owns the Zodiac to be transfered.
668     /// @param _to The address that should take ownership of the Zodiac. Can be any address,
669     ///  including the caller.
670     /// @param _tokenId The ID of the Zodiac to be transferred.
671     /// @dev Required for ERC-721 compliance.
672     function transferFrom(
673         address _from,
674         address _to,
675         uint256 _tokenId
676     )
677         external
678         whenNotPaused
679     {
680         // Safety check to prevent against an unexpected 0x0 default.
681         require(_to != address(0));
682         // Disallow transfers to this contract to prevent accidental misuse.
683         // The contract should never own any Zodiacs (except very briefly
684         // after a gen0 Zodiac is created and before it goes on auction).
685         require(_to != address(this));
686         // Check for approval and valid ownership
687         require(_approvedFor(msg.sender, _tokenId));
688         require(_owns(_from, _tokenId));
689 
690         // Reassign ownership (also clears pending approvals and emits Transfer event).
691         _transfer(_from, _to, _tokenId);
692     }
693 
694     /// @notice Returns the total number of Zodiacs currently in existence.
695     /// @dev Required for ERC-721 compliance.
696     function totalSupply() public view returns (uint) {
697         return zodiacs.length - 1;
698     }
699 
700     /// @notice Returns the address currently assigned ownership of a given Zodiac.
701     /// @dev Required for ERC-721 compliance.
702     function ownerOf(uint256 _tokenId)
703         external
704         view
705         returns (address owner)
706     {
707         owner = ZodiacIndexToOwner[_tokenId];
708 
709         require(owner != address(0));
710     }
711 
712     /// @notice Returns a list of all Zodiac IDs assigned to an address.
713     /// @param _owner The owner whose Zodiacs we are interested in.
714     /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
715     ///  expensive (it walks the entire Zodiac array looking for Zodiacs belonging to owner),
716     ///  but it also returns a dynamic array, which is only supported for web3 calls, and
717     ///  not contract-to-contract calls.
718     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
719         uint256 tokenCount = balanceOf(_owner);
720 
721         if (tokenCount == 0) {
722             // Return an empty array
723             return new uint256[](0);
724         } else {
725             uint256[] memory result = new uint256[](tokenCount);
726             uint256 totalZods = totalSupply();
727             uint256 resultIndex = 0;
728 
729             // We count on the fact that all Zodiacs have IDs starting at 1 and increasing
730             // sequentially up to the totalZods count.
731             uint256 zodId;
732 
733             for (zodId = 1; zodId <= totalZods; zodId++) {
734                 if (ZodiacIndexToOwner[zodId] == _owner) {
735                     result[resultIndex] = zodId;
736                     resultIndex++;
737                 }
738             }
739 
740             return result;
741         }
742     }
743 
744     /// @dev Adapted from memcpy() by @arachnid (Nick Johnson <arachnid@notdot.net>)
745     ///  This method is licenced under the Apache License.
746     ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
747     function _memcpy(uint _dest, uint _src, uint _len) private view {
748         // Copy word-length chunks while possible
749         for(; _len >= 32; _len -= 32) {
750             assembly {
751                 mstore(_dest, mload(_src))
752             }
753             _dest += 32;
754             _src += 32;
755         }
756 
757         // Copy remaining bytes
758         uint256 mask = 256 ** (32 - _len) - 1;
759         assembly {
760             let srcpart := and(mload(_src), not(mask))
761             let destpart := and(mload(_dest), mask)
762             mstore(_dest, or(destpart, srcpart))
763         }
764     }
765 
766     /// @dev Adapted from toString(slice) by @arachnid (Nick Johnson <arachnid@notdot.net>)
767     ///  This method is licenced under the Apache License.
768     ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
769     function _toString(bytes32[4] _rawBytes, uint256 _stringLength) private view returns (string) {
770         var outputString = new string(_stringLength);
771         uint256 outputPtr;
772         uint256 bytesPtr;
773 
774         assembly {
775             outputPtr := add(outputString, 32)
776             bytesPtr := _rawBytes
777         }
778 
779         _memcpy(outputPtr, bytesPtr, _stringLength);
780 
781         return outputString;
782     }
783 
784     /// @notice Returns a URI pointing to a metadata package for this token conforming to
785     ///  ERC-721 (https://github.com/ethereum/EIPs/issues/721)
786     /// @param _tokenId The ID number of the Zodiac whose metadata should be returned.
787     function tokenMetadata(uint256 _tokenId, string _preferredTransport) external view returns (string infoUrl) {
788         require(erc721Metadata != address(0));
789         bytes32[4] memory buffer;
790         uint256 count;
791         (buffer, count) = erc721Metadata.getMetadata(_tokenId, _preferredTransport);
792 
793         return _toString(buffer, count);
794     }
795 }
796 
797 
798 /// @title A facet of ZodiacCore that manages Zodiac siring, gestation, and birth.
799 /// @author Axiom Zen (https://www.axiomzen.co)
800 /// @dev See the ZodiacCore contract documentation to understand how the various contract facets are arranged.
801 contract ZodiacBreeding is ZodiacOwnership {
802 
803     /// @dev The Pregnant event is fired when two Zodiacs successfully breed and the pregnancy
804     ///  timer begins for the matron.
805     event Pregnant(address owner, uint256 matronId, uint256 sireId, uint256 matronCooldownEndBlock, uint256 sireCooldownEndBlock);
806 
807     /// @notice The minimum payment required to use breedWithAuto(). This fee goes towards
808     ///  the gas cost paid by whatever calls giveBirth(), and can be dynamically updated by
809     ///  the COO role as the gas price changes.
810     uint256 public autoBirthFee = 2 finney;
811 
812     // Keeps track of number of pregnant zodiacs.
813     uint256 public pregnantZodiacs;
814 
815     /// @dev The address of the sibling contract that is used to implement the sooper-sekret
816     ///  genetic combination algorithm.
817     GeneScienceInterface public geneScience;
818 
819     /// @dev Update the address of the genetic contract, can only be called by the CEO.
820     /// @param _address An address of a GeneScience contract instance to be used from this point forward.
821     function setGeneScienceAddress(address _address) external onlyCEO {
822         GeneScienceInterface candidateContract = GeneScienceInterface(_address);
823 
824         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
825         require(candidateContract.isGeneScience());
826 
827         // Set the new contract address
828         geneScience = candidateContract;
829     }
830 
831     /// @dev Checks that a given zodiac is able to breed. Requires that the
832     ///  current cooldown is finished (for sires) and also checks that there is
833     ///  no pending pregnancy.
834     function _isReadyToBreed(Zodiac _zod) internal view returns (bool) {
835         // In addition to checking the cooldownEndBlock, we also need to check to see if
836         // the Zodiac has a pending birth; there can be some period of time between the end
837         // of the pregnacy timer and the birth event.
838         return (_zod.siringWithId == 0) && (_zod.cooldownEndBlock <= uint64(block.number));
839     }
840 
841     /// @dev Check if a sire has authorized breeding with this matron. True if both sire
842     ///  and matron have the same owner, or if the sire has given siring permission to
843     ///  the matron's owner (via approveSiring()).
844     function _isSiringPermitted(uint256 _sireId, uint256 _matronId) internal view returns (bool) {
845         address matronOwner = ZodiacIndexToOwner[_matronId];
846         address sireOwner = ZodiacIndexToOwner[_sireId];
847 
848         // Siring is okay if they have same owner, or if the matron's owner was given
849         // permission to breed with this sire.
850         return (matronOwner == sireOwner || sireAllowedToAddress[_sireId] == matronOwner);
851     }
852 
853     /// @dev Set the cooldownEndTime for the given Zodiac, based on its current cooldownIndex.
854     ///  Also increments the cooldownIndex (unless it has hit the cap).
855     /// @param _zod A reference to the Zodiac in storage which needs its timer started.
856     function _triggerCooldown(Zodiac storage _zod) internal {
857         // Compute an estimation of the cooldown time in blocks (based on current cooldownIndex).
858         _zod.cooldownEndBlock = uint64((cooldowns[_zod.cooldownIndex]/secondsPerBlock) + block.number);
859 
860         // Increment the breeding count, clamping it at 13, which is the length of the
861         // cooldowns array. We could check the array size dynamically, but hard-coding
862         // this as a constant saves gas. Yay, Solidity!
863         if (_zod.cooldownIndex < 13) {
864             _zod.cooldownIndex += 1;
865         }
866     }
867 
868     /// @notice Grants approval to another user to sire with one of your zodiacs.
869     /// @param _addr The address that will be able to sire with your Zodiac. Set to
870     ///  address(0) to clear all siring approvals for this Zodiac.
871     /// @param _sireId A Zodiac that you own that _addr will now be able to sire with.
872     function approveSiring(address _addr, uint256 _sireId)
873         external
874         whenNotPaused
875     {
876         require(_owns(msg.sender, _sireId));
877         sireAllowedToAddress[_sireId] = _addr;
878     }
879 
880     /// @dev Updates the minimum payment required for calling giveBirthAuto(). Can only
881     ///  be called by the COO address. (This fee is used to offset the gas cost incurred
882     ///  by the autobirth daemon).
883     function setAutoBirthFee(uint256 val) external onlyCOO {
884         autoBirthFee = val;
885     }
886 
887     /// @dev Checks to see if a given Zodiac is pregnant and (if so) if the gestation
888     ///  period has passed.
889     function _isReadyToGiveBirth(Zodiac _matron) private view returns (bool) {
890         return (_matron.siringWithId != 0) && (_matron.cooldownEndBlock <= uint64(block.number));
891     }
892 
893     /// @notice Checks that a given zodiac is able to breed (i.e. it is not pregnant or
894     ///  in the middle of a siring cooldown).
895     /// @param _ZodiacId reference the id of the zodiac, any user can inquire about it
896     function isReadyToBreed(uint256 _ZodiacId)
897         public
898         view
899         returns (bool)
900     {
901         require(_ZodiacId > 0);
902         Zodiac storage zod = zodiacs[_ZodiacId];
903         return _isReadyToBreed(zod);
904     }
905 
906     /// @dev Checks whether a Zodiac is currently pregnant.
907     /// @param _ZodiacId reference the id of the zodiac, any user can inquire about it
908     function isPregnant(uint256 _ZodiacId)
909         public
910         view
911         returns (bool)
912     {
913         require(_ZodiacId > 0);
914         // A Zodiac is pregnant if and only if this field is set
915         return zodiacs[_ZodiacId].siringWithId != 0;
916     }
917 
918     /// @dev Internal check to see if a given sire and matron are a valid mating pair. DOES NOT
919     ///  check ownership permissions (that is up to the caller).
920     /// @param _matron A reference to the Zodiac struct of the potential matron.
921     /// @param _matronId The matron's ID.
922     /// @param _sire A reference to the Zodiac struct of the potential sire.
923     /// @param _sireId The sire's ID
924     function _isValidMatingPair(
925         Zodiac storage _matron,
926         uint256 _matronId,
927         Zodiac storage _sire,
928         uint256 _sireId
929     )
930         private
931         view
932         returns(bool)
933     {
934         // Must be same Zodiac type
935         if (_matron.zodiacType != _sire.zodiacType) {
936             return false;
937         }
938 
939         // A Zodiac can't breed with itself!
940         if (_matronId == _sireId) {
941             return false;
942         }
943 
944         // zodiacs can't breed with their parents.
945         if (_matron.matronId == _sireId || _matron.sireId == _sireId) {
946             return false;
947         }
948         if (_sire.matronId == _matronId || _sire.sireId == _matronId) {
949             return false;
950         }
951 
952         // We can short circuit the sibling check (below) if either Zodiac is
953         // gen zero (has a matron ID of zero).
954         if (_sire.matronId == 0 || _matron.matronId == 0) {
955             return true;
956         }
957 
958         // zodiacs can't breed with full or half siblings.
959         if (_sire.matronId == _matron.matronId || _sire.matronId == _matron.sireId) {
960             return false;
961         }
962         if (_sire.sireId == _matron.matronId || _sire.sireId == _matron.sireId) {
963             return false;
964         }
965 
966         // Everything seems cool! Let's get DTF.
967         return true;
968     }
969 
970     /// @dev Internal check to see if a given sire and matron are a valid mating pair for
971     ///  breeding via auction (i.e. skips ownership and siring approval checks).
972     function _canBreedWithViaAuction(uint256 _matronId, uint256 _sireId)
973         internal
974         view
975         returns (bool)
976     {
977         Zodiac storage matron = zodiacs[_matronId];
978         Zodiac storage sire = zodiacs[_sireId];
979         return _isValidMatingPair(matron, _matronId, sire, _sireId);
980     }
981 
982     /// @notice Checks to see if two Zodiacs can breed together, including checks for
983     ///  ownership and siring approvals. Does NOT check that both Zodiacs are ready for
984     ///  breeding (i.e. breedWith could still fail until the cooldowns are finished).
985     ///  TODO: Shouldn't this check pregnancy and cooldowns?!?
986     /// @param _matronId The ID of the proposed matron.
987     /// @param _sireId The ID of the proposed sire.
988     function canBreedWith(uint256 _matronId, uint256 _sireId)
989         external
990         view
991         returns(bool)
992     {
993         require(_matronId > 0);
994         require(_sireId > 0);
995         Zodiac storage matron = zodiacs[_matronId];
996         Zodiac storage sire = zodiacs[_sireId];
997         return _isValidMatingPair(matron, _matronId, sire, _sireId) &&
998             _isSiringPermitted(_sireId, _matronId);
999     }
1000 
1001     /// @dev Internal utility function to initiate breeding, assumes that all breeding
1002     ///  requirements have been checked.
1003     function _breedWith(uint256 _matronId, uint256 _sireId) internal {
1004         // Grab a reference to the zodiacs from storage.
1005         Zodiac storage sire = zodiacs[_sireId];
1006         Zodiac storage matron = zodiacs[_matronId];
1007 
1008         // Mark the matron as pregnant, keeping track of who the sire is.
1009         matron.siringWithId = uint32(_sireId);
1010 
1011         // Trigger the cooldown for both parents.
1012         _triggerCooldown(sire);
1013         _triggerCooldown(matron);
1014 
1015         // Clear siring permission for both parents. This may not be strictly necessary
1016         // but it's likely to avoid confusion!
1017         delete sireAllowedToAddress[_matronId];
1018         delete sireAllowedToAddress[_sireId];
1019 
1020         // Every time a Zodiac gets pregnant, counter is incremented.
1021         pregnantZodiacs++;
1022 
1023         // Emit the pregnancy event.
1024         Pregnant(ZodiacIndexToOwner[_matronId], _matronId, _sireId, matron.cooldownEndBlock, sire.cooldownEndBlock);
1025     }
1026 
1027     /// @notice Breed a Zodiac you own (as matron) with a sire that you own, or for which you
1028     ///  have previously been given Siring approval. Will either make your Zodiac pregnant, or will
1029     ///  fail entirely. Requires a pre-payment of the fee given out to the first caller of giveBirth()
1030     /// @param _matronId The ID of the Zodiac acting as matron (will end up pregnant if successful)
1031     /// @param _sireId The ID of the Zodiac acting as sire (will begin its siring cooldown if successful)
1032     function breedWithAuto(uint256 _matronId, uint256 _sireId)
1033         external
1034         payable
1035         whenNotPaused
1036     {
1037         // Checks for payment.
1038         require(msg.value >= autoBirthFee);
1039 
1040         // Caller must own the matron.
1041         require(_owns(msg.sender, _matronId));
1042 
1043         // Neither sire nor matron are allowed to be on auction during a normal
1044         // breeding operation, but we don't need to check that explicitly.
1045         // For matron: The caller of this function can't be the owner of the matron
1046         //   because the owner of a Zodiac on auction is the auction house, and the
1047         //   auction house will never call breedWith().
1048         // For sire: Similarly, a sire on auction will be owned by the auction house
1049         //   and the act of transferring ownership will have cleared any oustanding
1050         //   siring approval.
1051         // Thus we don't need to spend gas explicitly checking to see if either Zodiac
1052         // is on auction.
1053 
1054         // Check that matron and sire are both owned by caller, or that the sire
1055         // has given siring permission to caller (i.e. matron's owner).
1056         // Will fail for _sireId = 0
1057         require(_isSiringPermitted(_sireId, _matronId));
1058 
1059         // Grab a reference to the potential matron
1060         Zodiac storage matron = zodiacs[_matronId];
1061 
1062         // Make sure matron isn't pregnant, or in the middle of a siring cooldown
1063         require(_isReadyToBreed(matron));
1064 
1065         // Grab a reference to the potential sire
1066         Zodiac storage sire = zodiacs[_sireId];
1067 
1068         // Make sure sire isn't pregnant, or in the middle of a siring cooldown
1069         require(_isReadyToBreed(sire));
1070 
1071         // Test that these Zodiacs are a valid mating pair.
1072         require(_isValidMatingPair(
1073             matron,
1074             _matronId,
1075             sire,
1076             _sireId
1077         ));
1078 
1079         // All checks passed, Zodiac gets pregnant!
1080         _breedWith(_matronId, _sireId);
1081     }
1082 
1083     /// @notice Have a pregnant Zodiac give birth!
1084     /// @param _matronId A Zodiac ready to give birth.
1085     /// @return The Zodiac ID of the new zodiac.
1086     /// @dev Looks at a given Zodiac and, if pregnant and if the gestation period has passed,
1087     ///  combines the genes of the two parents to create a new zodiac. The new Zodiac is assigned
1088     ///  to the current owner of the matron. Upon successful completion, both the matron and the
1089     ///  new zodiac will be ready to breed again. Note that anyone can call this function (if they
1090     ///  are willing to pay the gas!), but the new zodiac always goes to the mother's owner.
1091     function giveBirth(uint256 _matronId)
1092         external
1093         whenNotPaused
1094         returns(uint256)
1095     {
1096         // Grab a reference to the matron in storage.
1097         Zodiac storage matron = zodiacs[_matronId];
1098 
1099         // Check that the matron is a valid Zodiac.
1100         require(matron.birthTime != 0);
1101 
1102         // Check that the matron is pregnant, and that its time has come!
1103         require(_isReadyToGiveBirth(matron));
1104 
1105         // Grab a reference to the sire in storage.
1106         uint256 sireId = matron.siringWithId;
1107         Zodiac storage sire = zodiacs[sireId];
1108 
1109         // Determine the higher generation number of the two parents
1110         uint16 parentGen = matron.generation;
1111         if (sire.generation > matron.generation) {
1112             parentGen = sire.generation;
1113         }
1114 
1115         // Call the sooper-sekret gene mixing operation.
1116         uint256 childGenes = geneScience.mixGenes(matron.genes, sire.genes, matron.cooldownEndBlock - 1);
1117 
1118         // Make the new zodiac!
1119         address owner = ZodiacIndexToOwner[_matronId];
1120         uint256 zodiacId = _createZodiac(_matronId, matron.siringWithId, parentGen + 1, childGenes, owner, matron.zodiacType);
1121 
1122         // Clear the reference to sire from the matron (REQUIRED! Having siringWithId
1123         // set is what marks a matron as being pregnant.)
1124         delete matron.siringWithId;
1125 
1126         // Every time a Zodiac gives birth counter is decremented.
1127         pregnantZodiacs--;
1128 
1129         // Send the balance fee to the person who made birth happen.
1130         msg.sender.transfer(autoBirthFee);
1131 
1132         // return the new zodiac's ID
1133         return zodiacId;
1134     }
1135 }
1136 
1137 
1138 /// @title Auction Core
1139 /// @dev Contains models, variables, and internal methods for the auction.
1140 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1141 contract ClockAuctionBase {
1142 
1143     // Represents an auction on an NFT
1144     struct Auction {
1145         // Current owner of NFT
1146         address seller;
1147         // Price (in wei) at beginning of auction
1148         uint128 startingPrice;
1149         // Price (in wei) at end of auction
1150         uint128 endingPrice;
1151         // Duration (in seconds) of auction
1152         uint64 duration;
1153         // Time when auction started
1154         // NOTE: 0 if this auction has been concluded
1155         uint64 startedAt;
1156     }
1157 
1158     // Reference to contract tracking NFT ownership
1159     ERC721 public nonFungibleContract;
1160 
1161     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
1162     // Values 0-10,000 map to 0%-100%
1163     uint256 public ownerCut;
1164 
1165     // Map from token ID to their corresponding auction.
1166     mapping (uint256 => Auction) tokenIdToAuction;
1167 
1168     event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
1169     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
1170     event AuctionCancelled(uint256 tokenId);
1171 
1172     /// @dev Returns true if the claimant owns the token.
1173     /// @param _claimant - Address claiming to own the token.
1174     /// @param _tokenId - ID of token whose ownership to verify.
1175     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
1176         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
1177     }
1178 
1179     /// @dev Escrows the NFT, assigning ownership to this contract.
1180     /// Throws if the escrow fails.
1181     /// @param _owner - Current owner address of token to escrow.
1182     /// @param _tokenId - ID of token whose approval to verify.
1183     function _escrow(address _owner, uint256 _tokenId) internal {
1184         // it will throw if transfer fails
1185         nonFungibleContract.transferFrom(_owner, this, _tokenId);
1186     }
1187 
1188     /// @dev Transfers an NFT owned by this contract to another address.
1189     /// Returns true if the transfer succeeds.
1190     /// @param _receiver - Address to transfer NFT to.
1191     /// @param _tokenId - ID of token to transfer.
1192     function _transfer(address _receiver, uint256 _tokenId) internal {
1193         // it will throw if transfer fails
1194         nonFungibleContract.transfer(_receiver, _tokenId);
1195     }
1196 
1197     /// @dev Adds an auction to the list of open auctions. Also fires the
1198     ///  AuctionCreated event.
1199     /// @param _tokenId The ID of the token to be put on auction.
1200     /// @param _auction Auction to add.
1201     function _addAuction(uint256 _tokenId, Auction _auction) internal {
1202         // Require that all auctions have a duration of
1203         // at least one minute. (Keeps our math from getting hairy!)
1204         require(_auction.duration >= 1 minutes);
1205 
1206         tokenIdToAuction[_tokenId] = _auction;
1207 
1208         AuctionCreated(
1209             uint256(_tokenId),
1210             uint256(_auction.startingPrice),
1211             uint256(_auction.endingPrice),
1212             uint256(_auction.duration)
1213         );
1214     }
1215 
1216     /// @dev Cancels an auction unconditionally.
1217     function _cancelAuction(uint256 _tokenId, address _seller) internal {
1218         _removeAuction(_tokenId);
1219         _transfer(_seller, _tokenId);
1220         AuctionCancelled(_tokenId);
1221     }
1222 
1223     /// @dev Computes the price and transfers winnings.
1224     /// Does NOT transfer ownership of token.
1225     function _bid(uint256 _tokenId, uint256 _bidAmount)
1226         internal
1227         returns (uint256)
1228     {
1229         // Get a reference to the auction struct
1230         Auction storage auction = tokenIdToAuction[_tokenId];
1231 
1232         // Explicitly check that this auction is currently live.
1233         // (Because of how Ethereum mappings work, we can't just count
1234         // on the lookup above failing. An invalid _tokenId will just
1235         // return an auction object that is all zeros.)
1236         require(_isOnAuction(auction));
1237 
1238         // Check that the bid is greater than or equal to the current price
1239         uint256 price = _currentPrice(auction);
1240         require(_bidAmount >= price);
1241 
1242         // Grab a reference to the seller before the auction struct
1243         // gets deleted.
1244         address seller = auction.seller;
1245 
1246         // The bid is good! Remove the auction before sending the fees
1247         // to the sender so we can't have a reentrancy attack.
1248         _removeAuction(_tokenId);
1249 
1250         // Transfer proceeds to seller (if there are any!)
1251         if (price > 0) {
1252             // Calculate the auctioneer's cut.
1253             // (NOTE: _computeCut() is guaranteed to return a
1254             // value <= price, so this subtraction can't go negative.)
1255             uint256 auctioneerCut = _computeCut(price);
1256             uint256 sellerProceeds = price - auctioneerCut;
1257 
1258             // NOTE: Doing a transfer() in the middle of a complex
1259             // method like this is generally discouraged because of
1260             // reentrancy attacks and DoS attacks if the seller is
1261             // a contract with an invalid fallback function. We explicitly
1262             // guard against reentrancy attacks by removing the auction
1263             // before calling transfer(), and the only thing the seller
1264             // can DoS is the sale of their own asset! (And if it's an
1265             // accident, they can call cancelAuction(). )
1266             seller.transfer(sellerProceeds);
1267         }
1268 
1269         // Calculate any excess funds included with the bid. If the excess
1270         // is anything worth worrying about, transfer it back to bidder.
1271         // NOTE: We checked above that the bid amount is greater than or
1272         // equal to the price so this cannot underflow.
1273         uint256 bidExcess = _bidAmount - price;
1274 
1275         // Return the funds. Similar to the previous transfer, this is
1276         // not susceptible to a re-entry attack because the auction is
1277         // removed before any transfers occur.
1278         msg.sender.transfer(bidExcess);
1279 
1280         // Tell the world!
1281         AuctionSuccessful(_tokenId, price, msg.sender);
1282 
1283         return price;
1284     }
1285 
1286     /// @dev Removes an auction from the list of open auctions.
1287     /// @param _tokenId - ID of NFT on auction.
1288     function _removeAuction(uint256 _tokenId) internal {
1289         delete tokenIdToAuction[_tokenId];
1290     }
1291 
1292     /// @dev Returns true if the NFT is on auction.
1293     /// @param _auction - Auction to check.
1294     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
1295         return (_auction.startedAt > 0);
1296     }
1297 
1298     /// @dev Returns current price of an NFT on auction. Broken into two
1299     ///  functions (this one, that computes the duration from the auction
1300     ///  structure, and the other that does the price computation) so we
1301     ///  can easily test that the price computation works correctly.
1302     function _currentPrice(Auction storage _auction)
1303         internal
1304         view
1305         returns (uint256)
1306     {
1307         uint256 secondsPassed = 0;
1308 
1309         // A bit of insurance against negative values (or wraparound).
1310         // Probably not necessary (since Ethereum guarnatees that the
1311         // now variable doesn't ever go backwards).
1312         if (now > _auction.startedAt) {
1313             secondsPassed = now - _auction.startedAt;
1314         }
1315 
1316         return _computeCurrentPrice(
1317             _auction.startingPrice,
1318             _auction.endingPrice,
1319             _auction.duration,
1320             secondsPassed
1321         );
1322     }
1323 
1324     /// @dev Computes the current price of an auction. Factored out
1325     ///  from _currentPrice so we can run extensive unit tests.
1326     ///  When testing, make this function public and turn on
1327     ///  `Current price computation` test suite.
1328     function _computeCurrentPrice(
1329         uint256 _startingPrice,
1330         uint256 _endingPrice,
1331         uint256 _duration,
1332         uint256 _secondsPassed
1333     )
1334         internal
1335         pure
1336         returns (uint256)
1337     {
1338         // NOTE: We don't use SafeMath (or similar) in this function because
1339         //  all of our public functions carefully cap the maximum values for
1340         //  time (at 64-bits) and currency (at 128-bits). _duration is
1341         //  also known to be non-zero (see the require() statement in
1342         //  _addAuction())
1343         if (_secondsPassed >= _duration) {
1344             // We've reached the end of the dynamic pricing portion
1345             // of the auction, just return the end price.
1346             return _endingPrice;
1347         } else {
1348             // Starting price can be higher than ending price (and often is!), so
1349             // this delta can be negative.
1350             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
1351 
1352             // This multiplication can't overflow, _secondsPassed will easily fit within
1353             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
1354             // will always fit within 256-bits.
1355             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
1356 
1357             // currentPriceChange can be negative, but if so, will have a magnitude
1358             // less that _startingPrice. Thus, this result will always end up positive.
1359             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
1360 
1361             return uint256(currentPrice);
1362         }
1363     }
1364 
1365     /// @dev Computes owner's cut of a sale.
1366     /// @param _price - Sale price of NFT.
1367     function _computeCut(uint256 _price) internal view returns (uint256) {
1368         // NOTE: We don't use SafeMath (or similar) in this function because
1369         //  all of our entry functions carefully cap the maximum values for
1370         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
1371         //  statement in the ClockAuction constructor). The result of this
1372         //  function is always guaranteed to be <= _price.
1373         return _price * ownerCut / 10000;
1374     }
1375 }
1376 
1377 
1378 /**
1379  * @title Pausable
1380  * @dev Base contract which allows children to implement an emergency stop mechanism.
1381  */
1382 contract Pausable is Ownable {
1383 	event Pause();
1384 	event Unpause();
1385 
1386 	bool public paused = false;
1387 
1388 
1389 	/**
1390 	 * @dev modifier to allow actions only when the contract IS paused
1391 	 */
1392 	modifier whenNotPaused() {
1393 		require(!paused);
1394 		_;
1395 	}
1396 
1397 	/**
1398 	 * @dev modifier to allow actions only when the contract IS NOT paused
1399 	 */
1400 	modifier whenPaused {
1401 		require(paused);
1402 		_;
1403 	}
1404 
1405 	/**
1406 	 * @dev called by the owner to pause, triggers stopped state
1407 	 */
1408 	function pause() public onlyOwner whenNotPaused returns (bool) {
1409 		paused = true;
1410 		Pause();
1411 		return true;
1412 	}
1413 
1414 	/**
1415 	 * @dev called by the owner to unpause, returns to normal state
1416 	 */
1417 	function unpause() public onlyOwner whenPaused returns (bool) {
1418 		paused = false;
1419 		Unpause();
1420 		return true;
1421 	}
1422 }
1423 
1424 
1425 /// @title Clock auction for non-fungible tokens.
1426 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1427 contract ClockAuction is Pausable, ClockAuctionBase {
1428 
1429     /// @dev The ERC-165 interface signature for ERC-721.
1430     ///  Ref: https://github.com/ethereum/EIPs/issues/165
1431     ///  Ref: https://github.com/ethereum/EIPs/issues/721
1432     bytes4 constant InterfaceSignature_ERC721 = bytes4(0x9a20483d);
1433 
1434     /// @dev Constructor creates a reference to the NFT ownership contract
1435     ///  and verifies the owner cut is in the valid range.
1436     /// @param _nftAddress - address of a deployed contract implementing
1437     ///  the Nonfungible Interface.
1438     /// @param _cut - percent cut the owner takes on each auction, must be
1439     ///  between 0-10,000.
1440     function ClockAuction(address _nftAddress, uint256 _cut) public {
1441         require(_cut <= 10000);
1442         ownerCut = _cut;
1443 
1444         ERC721 candidateContract = ERC721(_nftAddress);
1445         require(candidateContract.supportsInterface(InterfaceSignature_ERC721));
1446         nonFungibleContract = candidateContract;
1447     }
1448 
1449     /// @dev Remove all Ether from the contract, which is the owner's cuts
1450     ///  as well as any Ether sent directly to the contract address.
1451     ///  Always transfers to the NFT contract, but can be called either by
1452     ///  the owner or the NFT contract.
1453     function withdrawBalance() external {
1454         address nftAddress = address(nonFungibleContract);
1455 
1456         require(
1457             msg.sender == owner ||
1458             msg.sender == nftAddress
1459         );
1460         // We are using this boolean method to make sure that even if one fails it will still work
1461         nftAddress.transfer(this.balance);
1462     }
1463 
1464     /// @dev Creates and begins a new auction.
1465     /// @param _tokenId - ID of token to auction, sender must be owner.
1466     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
1467     /// @param _endingPrice - Price of item (in wei) at end of auction.
1468     /// @param _duration - Length of time to move between starting
1469     ///  price and ending price (in seconds).
1470     /// @param _seller - Seller, if not the message sender
1471     function createAuction(
1472         uint256 _tokenId,
1473         uint256 _startingPrice,
1474         uint256 _endingPrice,
1475         uint256 _duration,
1476         address _seller
1477     )
1478         external
1479         whenNotPaused
1480     {
1481         // Sanity check that no inputs overflow how many bits we've allocated
1482         // to store them in the auction struct.
1483         require(_startingPrice == uint256(uint128(_startingPrice)));
1484         require(_endingPrice == uint256(uint128(_endingPrice)));
1485         require(_duration == uint256(uint64(_duration)));
1486 
1487         require(_owns(msg.sender, _tokenId));
1488         _escrow(msg.sender, _tokenId);
1489         Auction memory auction = Auction(
1490             _seller,
1491             uint128(_startingPrice),
1492             uint128(_endingPrice),
1493             uint64(_duration),
1494             uint64(now)
1495         );
1496         _addAuction(_tokenId, auction);
1497     }
1498 
1499     /// @dev Bids on an open auction, completing the auction and transferring
1500     ///  ownership of the NFT if enough Ether is supplied.
1501     /// @param _tokenId - ID of token to bid on.
1502     function bid(uint256 _tokenId)
1503         external
1504         payable
1505         whenNotPaused
1506     {
1507         // _bid will throw if the bid or funds transfer fails
1508         _bid(_tokenId, msg.value);
1509         _transfer(msg.sender, _tokenId);
1510     }
1511 
1512     /// @dev Cancels an auction that hasn't been won yet.
1513     ///  Returns the NFT to original owner.
1514     /// @notice This is a state-modifying function that can
1515     ///  be called while the contract is paused.
1516     /// @param _tokenId - ID of token on auction
1517     function cancelAuction(uint256 _tokenId)
1518         external
1519     {
1520         Auction storage auction = tokenIdToAuction[_tokenId];
1521         require(_isOnAuction(auction));
1522         address seller = auction.seller;
1523         require(msg.sender == seller);
1524         _cancelAuction(_tokenId, seller);
1525     }
1526 
1527     /// @dev Cancels an auction when the contract is paused.
1528     ///  Only the owner may do this, and NFTs are returned to
1529     ///  the seller. This should only be used in emergencies.
1530     /// @param _tokenId - ID of the NFT on auction to cancel.
1531     function cancelAuctionWhenPaused(uint256 _tokenId)
1532         whenPaused
1533         onlyOwner
1534         external
1535     {
1536         Auction storage auction = tokenIdToAuction[_tokenId];
1537         require(_isOnAuction(auction));
1538         _cancelAuction(_tokenId, auction.seller);
1539     }
1540 
1541     /// @dev Returns auction info for an NFT on auction.
1542     /// @param _tokenId - ID of NFT on auction.
1543     function getAuction(uint256 _tokenId)
1544         external
1545         view
1546         returns
1547     (
1548         address seller,
1549         uint256 startingPrice,
1550         uint256 endingPrice,
1551         uint256 duration,
1552         uint256 startedAt
1553     ) {
1554         Auction storage auction = tokenIdToAuction[_tokenId];
1555         require(_isOnAuction(auction));
1556         return (
1557             auction.seller,
1558             auction.startingPrice,
1559             auction.endingPrice,
1560             auction.duration,
1561             auction.startedAt
1562         );
1563     }
1564 
1565     /// @dev Returns the current price of an auction.
1566     /// @param _tokenId - ID of the token price we are checking.
1567     function getCurrentPrice(uint256 _tokenId)
1568         external
1569         view
1570         returns (uint256)
1571     {
1572         Auction storage auction = tokenIdToAuction[_tokenId];
1573         require(_isOnAuction(auction));
1574         return _currentPrice(auction);
1575     }
1576 
1577 }
1578 
1579 
1580 /// @title Reverse auction modified for siring
1581 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1582 contract SiringClockAuction is ClockAuction {
1583 
1584     // @dev Sanity check that allows us to ensure that we are pointing to the
1585     //  right auction in our setSiringAuctionAddress() call.
1586     bool public isSiringClockAuction = true;
1587 
1588     // Delegate constructor
1589     function SiringClockAuction(address _nftAddr, uint256 _cut) public
1590         ClockAuction(_nftAddr, _cut) {}
1591 
1592     /// @dev Creates and begins a new auction. Since this function is wrapped,
1593     /// require sender to be ZodiacCore contract.
1594     /// @param _tokenId - ID of token to auction, sender must be owner.
1595     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
1596     /// @param _endingPrice - Price of item (in wei) at end of auction.
1597     /// @param _duration - Length of auction (in seconds).
1598     /// @param _seller - Seller, if not the message sender
1599     function createAuction(
1600         uint256 _tokenId,
1601         uint256 _startingPrice,
1602         uint256 _endingPrice,
1603         uint256 _duration,
1604         address _seller
1605     )
1606         external
1607     {
1608         // Sanity check that no inputs overflow how many bits we've allocated
1609         // to store them in the auction struct.
1610         require(_startingPrice == uint256(uint128(_startingPrice)));
1611         require(_endingPrice == uint256(uint128(_endingPrice)));
1612         require(_duration == uint256(uint64(_duration)));
1613 
1614         require(msg.sender == address(nonFungibleContract));
1615         _escrow(_seller, _tokenId);
1616         Auction memory auction = Auction(
1617             _seller,
1618             uint128(_startingPrice),
1619             uint128(_endingPrice),
1620             uint64(_duration),
1621             uint64(now)
1622         );
1623         _addAuction(_tokenId, auction);
1624     }
1625 
1626     /// @dev Places a bid for siring. Requires the sender
1627     /// is the ZodiacCore contract because all bid methods
1628     /// should be wrapped. Also returns the Zodiac to the
1629     /// seller rather than the winner.
1630     function bid(uint256 _tokenId)
1631         external
1632         payable
1633     {
1634         require(msg.sender == address(nonFungibleContract));
1635         address seller = tokenIdToAuction[_tokenId].seller;
1636         // _bid checks that token ID is valid and will throw if bid fails
1637         _bid(_tokenId, msg.value);
1638         // We transfer the Zodiac back to the seller, the winner will get
1639         // the offspring
1640         _transfer(seller, _tokenId);
1641     }
1642 
1643 }
1644 
1645 
1646 /// @title Clock auction modified for sale of Zodiacs
1647 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1648 contract SaleClockAuction is ClockAuction {
1649 
1650     // @dev Sanity check that allows us to ensure that we are pointing to the
1651     //  right auction in our setSaleAuctionAddress() call.
1652     bool public isSaleClockAuction = true;
1653 
1654     // Tracks last 5 sale price of gen0 zodiac sales
1655     uint256 public gen0SaleCount;
1656     uint256[5] public lastGen0SalePrices;
1657 
1658     // Delegate constructor
1659     function SaleClockAuction(address _nftAddr, uint256 _cut) public
1660         ClockAuction(_nftAddr, _cut) {}
1661 
1662     /// @dev Creates and begins a new auction.
1663     /// @param _tokenId - ID of token to auction, sender must be owner.
1664     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
1665     /// @param _endingPrice - Price of item (in wei) at end of auction.
1666     /// @param _duration - Length of auction (in seconds).
1667     /// @param _seller - Seller, if not the message sender
1668     function createAuction(
1669         uint256 _tokenId,
1670         uint256 _startingPrice,
1671         uint256 _endingPrice,
1672         uint256 _duration,
1673         address _seller
1674     )
1675         external
1676     {
1677         // Sanity check that no inputs overflow how many bits we've allocated
1678         // to store them in the auction struct.
1679         require(_startingPrice == uint256(uint128(_startingPrice)));
1680         require(_endingPrice == uint256(uint128(_endingPrice)));
1681         require(_duration == uint256(uint64(_duration)));
1682 
1683         require(msg.sender == address(nonFungibleContract));
1684         _escrow(_seller, _tokenId);
1685         Auction memory auction = Auction(
1686             _seller,
1687             uint128(_startingPrice),
1688             uint128(_endingPrice),
1689             uint64(_duration),
1690             uint64(now)
1691         );
1692         _addAuction(_tokenId, auction);
1693     }
1694 
1695     /// @dev Updates lastSalePrice if seller is the nft contract
1696     /// Otherwise, works the same as default bid method.
1697     function bid(uint256 _tokenId)
1698         external
1699         payable
1700     {
1701         // _bid verifies token ID size
1702         address seller = tokenIdToAuction[_tokenId].seller;
1703         uint256 price = _bid(_tokenId, msg.value);
1704         _transfer(msg.sender, _tokenId);
1705 
1706         // If not a gen0 auction, exit
1707         if (seller == address(nonFungibleContract)) {
1708             // Track gen0 sale prices
1709             lastGen0SalePrices[gen0SaleCount % 5] = price;
1710             gen0SaleCount++;
1711         }
1712     }
1713 
1714     function averageGen0SalePrice() external view returns (uint256) {
1715         uint256 sum = 0;
1716         for (uint256 i = 0; i < 5; i++) {
1717             sum += lastGen0SalePrices[i];
1718         }
1719         return sum / 5;
1720     }
1721 
1722 }
1723 
1724 
1725 /// @title Handles creating auctions for sale and siring of Zodiacs.
1726 ///  This wrapper of ReverseAuction exists only so that users can create
1727 ///  auctions with only one transaction.
1728 contract ZodiacAuction is ZodiacBreeding {
1729 
1730     // @notice The auction contract variables are defined in ZodiacBase to allow
1731     //  us to refer to them in ZodiacOwnership to prevent accidental transfers.
1732     // `saleAuction` refers to the auction for gen0 and p2p sale of Zodiacs.
1733     // `siringAuction` refers to the auction for siring rights of Zodiacs.
1734 
1735     /// @dev Sets the reference to the sale auction.
1736     /// @param _address - Address of sale contract.
1737     function setSaleAuctionAddress(address _address) external onlyCEO {
1738         SaleClockAuction candidateContract = SaleClockAuction(_address);
1739 
1740         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
1741         require(candidateContract.isSaleClockAuction());
1742 
1743         // Set the new contract address
1744         saleAuction = candidateContract;
1745     }
1746 
1747     /// @dev Sets the reference to the siring auction.
1748     /// @param _address - Address of siring contract.
1749     function setSiringAuctionAddress(address _address) external onlyCEO {
1750         SiringClockAuction candidateContract = SiringClockAuction(_address);
1751 
1752         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
1753         require(candidateContract.isSiringClockAuction());
1754 
1755         // Set the new contract address
1756         siringAuction = candidateContract;
1757     }
1758 
1759     /// @dev Put a Zodiac up for auction.
1760     ///  Does some ownership trickery to create auctions in one tx.
1761     function createSaleAuction(
1762         uint256 _ZodiacId,
1763         uint256 _startingPrice,
1764         uint256 _endingPrice,
1765         uint256 _duration
1766     )
1767         external
1768         whenNotPaused
1769     {
1770         // Auction contract checks input sizes
1771         // If Zodiac is already on any auction, this will throw
1772         // because it will be owned by the auction contract.
1773         require(_owns(msg.sender, _ZodiacId));
1774         // Ensure the Zodiac is not pregnant to prevent the auction
1775         // contract accidentally receiving ownership of the child.
1776         // NOTE: the Zodiac IS allowed to be in a cooldown.
1777         require(!isPregnant(_ZodiacId));
1778         _approve(_ZodiacId, saleAuction);
1779         // Sale auction throws if inputs are invalid and clears
1780         // transfer and sire approval after escrowing the Zodiac.
1781         saleAuction.createAuction(
1782             _ZodiacId,
1783             _startingPrice,
1784             _endingPrice,
1785             _duration,
1786             msg.sender
1787         );
1788     }
1789 
1790     /// @dev Put a Zodiac up for auction to be sire.
1791     ///  Performs checks to ensure the Zodiac can be sired, then
1792     ///  delegates to reverse auction.
1793     function createSiringAuction(
1794         uint256 _ZodiacId,
1795         uint256 _startingPrice,
1796         uint256 _endingPrice,
1797         uint256 _duration
1798     )
1799         external
1800         whenNotPaused
1801     {
1802         // Auction contract checks input sizes
1803         // If Zodiac is already on any auction, this will throw
1804         // because it will be owned by the auction contract.
1805         require(_owns(msg.sender, _ZodiacId));
1806         require(isReadyToBreed(_ZodiacId));
1807         _approve(_ZodiacId, siringAuction);
1808         // Siring auction throws if inputs are invalid and clears
1809         // transfer and sire approval after escrowing the Zodiac.
1810         siringAuction.createAuction(
1811             _ZodiacId,
1812             _startingPrice,
1813             _endingPrice,
1814             _duration,
1815             msg.sender
1816         );
1817     }
1818 
1819     /// @dev Completes a siring auction by bidding.
1820     ///  Immediately breeds the winning matron with the sire on auction.
1821     /// @param _sireId - ID of the sire on auction.
1822     /// @param _matronId - ID of the matron owned by the bidder.
1823     function bidOnSiringAuction(
1824         uint256 _sireId,
1825         uint256 _matronId
1826     )
1827         external
1828         payable
1829         whenNotPaused
1830     {
1831         // Auction contract checks input sizes
1832         require(_owns(msg.sender, _matronId));
1833         require(isReadyToBreed(_matronId));
1834         require(_canBreedWithViaAuction(_matronId, _sireId));
1835 
1836         // Define the current price of the auction.
1837         uint256 currentPrice = siringAuction.getCurrentPrice(_sireId);
1838         require(msg.value >= currentPrice + autoBirthFee);
1839 
1840         // Siring auction will throw if the bid fails.
1841         siringAuction.bid.value(msg.value - autoBirthFee)(_sireId);
1842         _breedWith(uint32(_matronId), uint32(_sireId));
1843     }
1844 
1845     /// @dev Transfers the balance of the sale auction contract
1846     /// to the ZodiacCore contract. We use two-step withdrawal to
1847     /// prevent two transfer calls in the auction bid function.
1848     function withdrawAuctionBalances() external onlyCLevel {
1849         saleAuction.withdrawBalance();
1850         siringAuction.withdrawBalance();
1851     }
1852 }
1853 
1854 
1855 /// @title all functions related to creating Zodiacs
1856 contract ZodiacMinting is ZodiacAuction {
1857 
1858     // Limits the number of zodiacs the contract owner can ever create.
1859     uint256 public constant DEFAULT_CREATION_LIMIT = 50000 * 12;
1860 
1861     // Counts the number of zodiacs the contract owner has created.
1862     uint256 public defaultCreatedCount;
1863 
1864     /// @dev we can create zodiacs with different generations. Only callable by COO
1865     /// @param _genes The encoded genes of the zodiac to be created, any value is accepted
1866     /// @param _owner The future owner of the created zodiac. Default to contract COO
1867     /// @param _time The birth time of zodiac
1868     /// @param _cooldownIndex The cooldownIndex of zodiac
1869     /// @param _zodiacType The type of this zodiac
1870     function createDefaultGen0Zodiac(uint256 _genes, address _owner, uint256 _time, uint256 _cooldownIndex, uint256 _zodiacType) external onlyCOO {
1871 
1872         require(_time == uint256(uint64(_time)));
1873         require(_cooldownIndex == uint256(uint16(_cooldownIndex)));
1874         require(_zodiacType == uint256(uint16(_zodiacType)));
1875 
1876         require(_time > 0);
1877         require(_cooldownIndex >= 0 && _cooldownIndex <= 13);
1878         require(_zodiacType >= 1 && _zodiacType <= 12);
1879 
1880         address ZodiacOwner = _owner;
1881         if (ZodiacOwner == address(0)) {
1882             ZodiacOwner = cooAddress;
1883         }
1884         require(defaultCreatedCount < DEFAULT_CREATION_LIMIT);
1885 
1886         defaultCreatedCount++;
1887         _createZodiacWithTime(0, 0, 0, _genes, ZodiacOwner, _time, _cooldownIndex, _zodiacType);
1888     }
1889 
1890 
1891     /// @dev we can create Zodiacs with different generations. Only callable by COO
1892     /// @param _matronId The Zodiac ID of the matron of this Zodiac (zero for gen0)
1893     /// @param _sireId The Zodiac ID of the sire of this Zodiac (zero for gen0)
1894     /// @param _genes The encoded genes of the Zodiac to be created, any value is accepted
1895     /// @param _owner The future owner of the created Zodiacs. Default to contract COO
1896     /// @param _time The birth time of zodiac
1897     /// @param _cooldownIndex The cooldownIndex of zodiac
1898     function createDefaultZodiac(uint256 _matronId, uint256 _sireId, uint256 _genes, address _owner, uint256 _time, uint256 _cooldownIndex) external onlyCOO {
1899 
1900         require(_matronId == uint256(uint32(_matronId)));
1901         require(_sireId == uint256(uint32(_sireId)));
1902         require(_time == uint256(uint64(_time)));
1903         require(_cooldownIndex == uint256(uint16(_cooldownIndex)));
1904 
1905         require(_time > 0);
1906         require(_cooldownIndex >= 0 && _cooldownIndex <= 13);
1907 
1908         address ZodiacOwner = _owner;
1909         if (ZodiacOwner == address(0)) {
1910             ZodiacOwner = cooAddress;
1911         }
1912 
1913         require(_matronId > 0);
1914         require(_sireId > 0);
1915 
1916         // Grab a reference to the matron in storage.
1917         Zodiac storage matron = zodiacs[_matronId];
1918 
1919         // Grab a reference to the sire in storage.
1920         Zodiac storage sire = zodiacs[_sireId];
1921 
1922         // Must be same Zodiac type
1923         require(matron.zodiacType == sire.zodiacType);
1924 
1925         // Determine the higher generation number of the two parents
1926         uint16 parentGen = matron.generation;
1927         if (sire.generation > matron.generation) {
1928             parentGen = sire.generation;
1929         }
1930 
1931         _createZodiacWithTime(_matronId, _sireId, parentGen + 1, _genes, ZodiacOwner, _time, _cooldownIndex, matron.zodiacType);
1932     }
1933 
1934 }
1935 
1936 
1937 /// @title Cryptozodiacs: Collectible, breedable, and oh-so-adorable zodiacs on the Ethereum blockchain.
1938 /// @dev The main Cryptozodiacs contract, keeps track of zodens so they don't wander around and get lost.
1939 contract ZodiacCore is ZodiacMinting {
1940 /* contract ZodiacCore { */
1941     // This is the main Cryptozodiacs contract. In order to keep our code seperated into logical sections,
1942     // we've broken it up in two ways. First, we have several seperately-instantiated sibling contracts
1943     // that handle auctions and our super-top-secret genetic combination algorithm. The auctions are
1944     // seperate since their logic is somewhat complex and there's always a risk of subtle bugs. By keeping
1945     // them in their own contracts, we can upgrade them without disrupting the main contract that tracks
1946     // Zodiac ownership. The genetic combination algorithm is kept seperate so we can open-source all of
1947     // the rest of our code without making it _too_ easy for folks to figure out how the genetics work.
1948     // Don't worry, I'm sure someone will reverse engineer it soon enough!
1949     //
1950     // Secondly, we break the core contract into multiple files using inheritence, one for each major
1951     // facet of functionality of CK. This allows us to keep related code bundled together while still
1952     // avoiding a single giant file with everything in it. The breakdown is as follows:
1953     //
1954     //      - ZodiacBase: This is where we define the most fundamental code shared throughout the core
1955     //             functionality. This includes our main data storage, constants and data types, plus
1956     //             internal functions for managing these items.
1957     //
1958     //      - ZodiacAccessControl: This contract manages the various addresses and constraints for operations
1959     //             that can be executed only by specific roles. Namely CEO, CFO and COO.
1960     //
1961     //      - ZodiacOwnership: This provides the methods required for basic non-fungible token
1962     //             transactions, following the draft ERC-721 spec (https://github.com/ethereum/EIPs/issues/721).
1963     //
1964     //      - ZodiacBreeding: This file contains the methods necessary to breed zodiacs together, including
1965     //             keeping track of siring offers, and relies on an external genetic combination contract.
1966     //
1967     //      - ZodiacAuctions: Here we have the public methods for auctioning or bidding on zodiacs or siring
1968     //             services. The actual auction functionality is handled in two sibling contracts (one
1969     //             for sales and one for siring), while auction creation and bidding is mostly mediated
1970     //             through this facet of the core contract.
1971     //
1972     //      - ZodiacMinting: This final facet contains the functionality we use for creating new gen0 zodiacs.
1973     //             We can make up to 5000 "promo" zodiacs that can be given away (especially important when
1974     //             the community is new), and all others can only be created and then immediately put up
1975     //             for auction via an algorithmically determined starting price. Regardless of how they
1976     //             are created, there is a hard limit of 2400*12*12 gen0 zodiacs. After that, it's all up to the
1977     //             community to breed, breed, breed!
1978 
1979     // Set in case the core contract is broken and an upgrade is required
1980     address public newContractAddress;
1981 
1982     /// @notice Creates the main Cryptozodiacs smart contract instance.
1983     function ZodiacCore() public {
1984         // Starts paused.
1985         paused = true;
1986 
1987         // the creator of the contract is the initial CEO
1988         ceoAddress = msg.sender;
1989 
1990         // the creator of the contract is also the initial COO
1991         cooAddress = msg.sender;
1992 
1993         // start with the mythical zodiac 0 - so we don't have generation-0 parent issues
1994         _createZodiac(0, 0, 0, uint256(-1), address(0), 0);
1995     }
1996 
1997     /// @dev Used to mark the smart contract as upgraded, in case there is a serious
1998     ///  breaking bug. This method does nothing but keep track of the new contract and
1999     ///  emit a message indicating that the new address is set. It's up to clients of this
2000     ///  contract to update to the new contract address in that case. (This contract will
2001     ///  be paused indefinitely if such an upgrade takes place.)
2002     /// @param _v2Address new address
2003     function setNewAddress(address _v2Address) external onlyCEO whenPaused {
2004         // See README.md for updgrade plan
2005         newContractAddress = _v2Address;
2006         ContractUpgrade(_v2Address);
2007     }
2008 
2009     /// @notice No tipping!
2010     /// @dev Reject all Ether from being sent here, unless it's from one of the
2011     ///  two auction contracts. (Hopefully, we can prevent user accidents.)
2012     function() external payable {
2013         require(
2014             msg.sender == address(saleAuction) ||
2015             msg.sender == address(siringAuction)
2016         );
2017     }
2018 
2019     /// @notice Returns all the relevant information about a specific Zodiac.
2020     /// @param _id The ID of the Zodiac of interest.
2021     function getZodiac(uint256 _id)
2022         external
2023         view
2024         returns (
2025         bool isGestating,
2026         bool isReady,
2027         uint256 cooldownIndex,
2028         uint256 nextActionAt,
2029         uint256 siringWithId,
2030         uint256 birthTime,
2031         uint256 matronId,
2032         uint256 sireId,
2033         uint256 generation,
2034         uint256 genes
2035     ) {
2036         Zodiac storage zod = zodiacs[_id];
2037 
2038         // if this variable is 0 then it's not gestating
2039         isGestating = (zod.siringWithId != 0);
2040         isReady = (zod.cooldownEndBlock <= block.number);
2041         cooldownIndex = uint256(zod.cooldownIndex);
2042         nextActionAt = uint256(zod.cooldownEndBlock);
2043         siringWithId = uint256(zod.siringWithId);
2044         birthTime = uint256(zod.birthTime);
2045         matronId = uint256(zod.matronId);
2046         sireId = uint256(zod.sireId);
2047         generation = uint256(zod.generation);
2048         genes = zod.genes;
2049     }
2050 
2051     /// @dev Override unpause so it requires all external contract addresses
2052     ///  to be set before contract can be unpaused. Also, we can't have
2053     ///  newContractAddress set either, because then the contract was upgraded.
2054     /// @notice This is public rather than external so we can call super.unpause
2055     ///  without using an expensive CALL.
2056     function unpause() public onlyCEO whenPaused {
2057         require(saleAuction != address(0));
2058         require(siringAuction != address(0));
2059         require(geneScience != address(0));
2060         require(newContractAddress == address(0));
2061 
2062         // Actually unpause the contract.
2063         super.unpause();
2064     }
2065 
2066     // @dev Allows the CFO to capture the balance available to the contract.
2067     function withdrawBalance() external onlyCFO {
2068         uint256 balance = this.balance;
2069         // Subtract all the currently pregnant zodens we have, plus 1 of margin.
2070         uint256 subtractFees = (pregnantZodiacs + 1) * autoBirthFee;
2071 
2072         if (balance > subtractFees) {
2073             cfoAddress.transfer(balance - subtractFees);
2074         }
2075     }
2076 }