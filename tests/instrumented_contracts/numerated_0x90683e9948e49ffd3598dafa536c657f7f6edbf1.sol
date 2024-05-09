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
69 /// @title A facet of CobeFriendCore that manages special access privileges.
70 /// @author CybEye (http://www.cybeye.com/us/index.jsp)
71 /// @dev See the CobeFriendCore contract documentation to understand how the various contract facets are arranged.
72 contract CobeFriendACL {
73     // This facet controls access control for CobeFriends. There are four roles managed here:
74     //
75     //     - The CEO: The CEO can reassign other roles and change the addresses of our dependent smart
76     //         contracts. It is also the only role that can unpause the smart contract. It is initially
77     //         set to the address that created the smart contract in the CobeFriendCore constructor.
78     //
79     //     - The CFO: The CFO can withdraw funds from CobeFriendCore and its auction contracts.
80     //
81     //     - The COO: The COO can release gen0 CobeFriends to auction, and mint promo CobeFriends.
82     //
83     // It should be noted that these roles are distinct without overlap in their access abilities, the
84     // abilities listed for each role above are exhaustive. In particular, while the CEO can assign any
85     // address to any role, the CEO address itself doesn't have the ability to act in those roles. This
86     // restriction is intentional so that we aren't tempted to use the CEO address frequently out of
87     // convenience. The less we use an address, the less likely it is that we somehow compromise the
88     // account.
89 
90     /// @dev Emited when contract is upgraded - See README.md for updgrade plan
91     event ContractUpgrade(address newContract);
92 
93     // The addresses of the accounts (or contracts) that can execute actions within each roles.
94     address public ceoAddress;
95     address public cfoAddress;
96     address public cooAddress;
97 
98     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
99     bool public paused = false;
100 
101     /// @dev Access modifier for CEO-only functionality
102     modifier onlyCEO() {
103         require(msg.sender == ceoAddress);
104         _;
105     }
106 
107     /// @dev Access modifier for CFO-only functionality
108     modifier onlyCFO() {
109         require(msg.sender == cfoAddress);
110         _;
111     }
112 
113     /// @dev Access modifier for COO-only functionality
114     modifier onlyCOO() {
115         require(msg.sender == cooAddress);
116         _;
117     }
118 
119     modifier onlyCLevel() {
120         require(
121             msg.sender == cooAddress ||
122             msg.sender == ceoAddress ||
123             msg.sender == cfoAddress
124         );
125         _;
126     }
127 
128     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
129     /// @param _newCEO The address of the new CEO
130     function setCEO(address _newCEO) external onlyCEO {
131         require(_newCEO != address(0));
132 
133         ceoAddress = _newCEO;
134     }
135 
136     /// @dev Assigns a new address to act as the CFO. Only available to the current CEO.
137     /// @param _newCFO The address of the new CFO
138     function setCFO(address _newCFO) external onlyCEO {
139         require(_newCFO != address(0));
140 
141         cfoAddress = _newCFO;
142     }
143 
144     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
145     /// @param _newCOO The address of the new COO
146     function setCOO(address _newCOO) external onlyCEO {
147         require(_newCOO != address(0));
148 
149         cooAddress = _newCOO;
150     }
151 
152     /*** Pausable functionality adapted from OpenZeppelin ***/
153 
154     /// @dev Modifier to allow actions only when the contract IS NOT paused
155     modifier whenNotPaused() {
156         require(!paused);
157         _;
158     }
159 
160     /// @dev Modifier to allow actions only when the contract IS paused
161     modifier whenPaused {
162         require(paused);
163         _;
164     }
165 
166     /// @dev Called by any "C-level" role to pause the contract. Used only when
167     ///  a bug or exploit is detected and we need to limit damage.
168     function pause() external onlyCLevel whenNotPaused {
169         paused = true;
170     }
171 
172     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
173     ///  one reason we may pause the contract is when CFO or COO accounts are
174     ///  compromised.
175     /// @notice This is public rather than external so it can be called by
176     ///  derived contracts.
177     function unpause() public onlyCEO whenPaused {
178         // can't unpause if contract was upgraded
179         paused = false;
180     }
181 }
182 
183 
184 /// @title Base contract for CobeFriend. Holds all common structs, events and base variables.
185 /// @author Axiom Zen (https://www.axiomzen.co)
186 /// @dev See the CobeFriendCore contract documentation to understand how the various contract facets are arranged.
187 contract CobeFriendBase is CobeFriendACL {
188 	/*** EVENTS ***/
189 
190 	/// @dev The Birth event is fired whenever a new CobeFriend comes into existence. This obviously
191 	///  includes any time a CobeFriend is created through the giveBirth method, but it is also called
192 	///  when a new gen0 CobeFriend is created.
193 	event Birth(address owner, uint256 CobeFriendId, uint256 matronId, uint256 sireId, uint256 genes, uint256 generation);
194 
195 	/// @dev Transfer event as defined in current draft of ERC721. Emitted every time a CobeFriend
196 	///  ownership is assigned, including births.
197 	event Transfer(address from, address to, uint256 tokenId);
198 
199 	/*** DATA TYPES ***/
200 
201 	/// @dev The main CobeFriend struct. Every CobeFriend in CobeFriend is represented by a copy
202 	///  of this structure, so great care was taken to ensure that it fits neatly into
203 	///  exactly two 256-bit words. Note that the order of the members in this structure
204 	///  is important because of the byte-packing rules used by Ethereum.
205 	///  Ref: http://solidity.readthedocs.io/en/develop/miscellaneous.html
206 	struct CobeFriend {
207 		// The CobeFriend's genetic code is packed into these 256-bits, the format is
208 		// sooper-sekret! A CobeFriend's genes never change.
209 		uint256 genes;
210 
211 		// The timestamp from the block when this CobeFriend came into existence.
212 		uint64 birthTime;
213 
214 		// The minimum timestamp after which this CobeFriend can engage in breeding
215 		// activities again. This same timestamp is used for the pregnancy
216 		// timer (for matrons) as well as the siring cooldown.
217 		uint64 cooldownEndBlock;
218 
219 		// The ID of the parents of this CobeFriend, set to 0 for gen0 CobeFriends.
220 		// Note that using 32-bit unsigned integers limits us to a "mere"
221 		// 4 billion CobeFriends. This number might seem small until you realize
222 		// that Ethereum currently has a limit of about 500 million
223 		// transactions per year! So, this definitely won't be a problem
224 		// for several years (even as Ethereum learns to scale).
225 		uint32 matronId;
226 		uint32 sireId;
227 
228 		// Set to the ID of the sire CobeFriend for matrons that are pregnant,
229 		// zero otherwise. A non-zero value here is how we know a CobeFriend
230 		// is pregnant. Used to retrieve the genetic material for the new
231 		// CobeFriend when the birth transpires.
232 		uint32 siringWithId;
233 
234 		// Set to the index in the cooldown array (see below) that represents
235 		// the current cooldown duration for this CobeFriend. This starts at zero
236 		// for gen0 CobeFriends, and is initialized to floor(generation/2) for others.
237 		// Incremented by one for each successful breeding action, regardless
238 		// of whether this CobeFriend is acting as matron or sire.
239 		uint16 cooldownIndex;
240 
241 		// The "generation number" of this CobeFriend. CobeFriends minted by the CZ contract
242 		// for sale are called "gen0" and have a generation number of 0. The
243 		// generation number of all other CobeFriends is the larger of the two generation
244 		// numbers of their parents, plus one.
245 		// (i.e. max(matron.generation, sire.generation) + 1)
246 		uint16 generation;
247 	}
248 
249 	/*** CONSTANTS ***/
250 
251 	/// @dev A lookup table inCobeFriending the cooldown duration after any successful
252 	///  breeding action, called "pregnancy time" for matrons and "siring cooldown"
253 	///  for sires. Designed such that the cooldown roughly doubles each time a CobeFriend
254 	///  is bred, encouraging owners not to just keep breeding the same CobeFriend over
255 	///  and over again. Caps out at one week (a CobeFriend can breed an unbounded number
256 	///  of times, and the maximum cooldown is always seven days).
257 	uint32[14] public cooldowns = [
258 		uint32(1 minutes),
259 		uint32(2 minutes),
260 		uint32(5 minutes),
261 		uint32(10 minutes),
262 		uint32(30 minutes),
263 		uint32(1 hours),
264 		uint32(2 hours),
265 		uint32(4 hours),
266 		uint32(8 hours),
267 		uint32(16 hours),
268 		uint32(1 days),
269 		uint32(2 days),
270 		uint32(4 days),
271 		uint32(7 days)
272 	];
273 
274 	// An approximation of currently how many seconds are in between blocks.
275 	uint256 public secondsPerBlock = 15;
276 
277 	/*** STORAGE ***/
278 
279 	/// @dev An array containing the CobeFriend struct for all CobeFriends in existence. The ID
280 	///  of each CobeFriend is actually an index into this array. Note that ID 0 is a negaCobeFriend,
281 	///  the unCobeFriend, the mythical beast that is the parent of all gen0 CobeFriends. A bizarre
282 	///  creature that is both matron and sire... to itself! Has an invalid genetic code.
283 	///  In other words, CobeFriend ID 0 is invalid... ;-)
284 	CobeFriend[] CobeFriends;
285 
286 	/// @dev A mapping from CobeFriend IDs to the address that owns them. All CobeFriends have
287 	///  some valid owner address, even gen0 CobeFriends are created with a non-zero owner.
288 	mapping (uint256 => address) public CobeFriendIndexToOwner;
289 
290 	// @dev A mapping from owner address to count of tokens that address owns.
291 	//  Used internally inside balanceOf() to resolve ownership count.
292 	mapping (address => uint256) ownershipTokenCount;
293 
294 	/// @dev A mapping from CobeFriendIDs to an address that has been approved to call
295 	///  transferFrom(). Each CobeFriend can only have one approved address for transfer
296 	///  at any time. A zero value means no approval is outstanding.
297 	mapping (uint256 => address) public CobeFriendIndexToApproved;
298 
299 	/// @dev A mapping from CobeFriendIDs to an address that has been approved to use
300 	///  this CobeFriend for siring via breedWith(). Each CobeFriend can only have one approved
301 	///  address for siring at any time. A zero value means no approval is outstanding.
302 	mapping (uint256 => address) public sireAllowedToAddress;
303 
304 	/// @dev The address of the ClockAuction contract that handles sales of CobeFriends. This
305 	///  same contract handles both peer-to-peer sales as well as the gen0 sales which are
306 	///  initiated every 15 minutes.
307 	SaleClockAuction public saleAuction;
308 
309 	/// @dev Assigns ownership of a specific CobeFriend to an address.
310 	function _transfer(address _from, address _to, uint256 _tokenId) internal {
311 		// Since the number of CobeFriends is capped to 2^32 we can't overflow this
312 		ownershipTokenCount[_to]++;
313 		// transfer ownership
314 		CobeFriendIndexToOwner[_tokenId] = _to;
315 		// When creating new CobeFriends _from is 0x0, but we can't account that address.
316 		if (_from != address(0)) {
317 			ownershipTokenCount[_from]--;
318 			// once the CobeFriend is transferred also clear sire allowances
319 			delete sireAllowedToAddress[_tokenId];
320 			// clear any previously approved ownership exchange
321 			delete CobeFriendIndexToApproved[_tokenId];
322 		}
323 		// Emit the transfer event.
324 		Transfer(_from, _to, _tokenId);
325 	}
326 
327 	/// @dev An internal method that creates a new CobeFriend and stores it. This
328 	///  method doesn't do any checking and should only be called when the
329 	///  input data is known to be valid. Will generate both a Birth event
330 	///  and a Transfer event.
331 	/// @param _matronId The CobeFriend ID of the matron of this CobeFriend (zero for gen0)
332 	/// @param _sireId The CobeFriend ID of the sire of this CobeFriend (zero for gen0)
333 	/// @param _generation The generation number of this CobeFriend, must be computed by caller.
334 	/// @param _genes The CobeFriend's genetic code.
335 	/// @param _owner The inital owner of this CobeFriend, must be non-zero (except for the unCobeFriend, ID 0)
336 	function _createCobeFriend(
337 		uint256 _matronId,
338 		uint256 _sireId,
339 		uint256 _generation,
340 		uint256 _genes,
341 		address _owner
342 	)
343 		internal
344 		returns (uint)
345 	{
346 		// These requires are not strictly necessary, our calling code should make
347 		// sure that these conditions are never broken. However! _createCobeFriend() is already
348 		// an expensive call (for storage), and it doesn't hurt to be especially careful
349 		// to ensure our data structures are always valid.
350 		require(_matronId == uint256(uint32(_matronId)));
351 		require(_sireId == uint256(uint32(_sireId)));
352 		require(_generation == uint256(uint16(_generation)));
353 
354 		// New CobeFriend starts with the same cooldown as parent gen/2
355 		uint16 cooldownIndex = uint16(_generation / 2);
356 		if (cooldownIndex > 13) {
357 			cooldownIndex = 13;
358 		}
359 
360 		CobeFriend memory _CobeFriend = CobeFriend({
361 			genes: _genes,
362 			birthTime: uint64(now),
363 			cooldownEndBlock: 0,
364 			matronId: uint32(_matronId),
365 			sireId: uint32(_sireId),
366 			siringWithId: 0,
367 			cooldownIndex: cooldownIndex,
368 			generation: uint16(_generation)
369 		});
370 		uint256 newCobeFriendId = CobeFriends.push(_CobeFriend) - 1;
371 
372 		// It's probably never going to happen, 4 billion CobeFriends is A LOT, but
373 		// let's just be 100% sure we never let this happen.
374 		require(newCobeFriendId == uint256(uint32(newCobeFriendId)));
375 
376 		// emit the birth event
377 		Birth(
378 			_owner,
379 			newCobeFriendId,
380 			uint256(_CobeFriend.matronId),
381 			uint256(_CobeFriend.sireId),
382 			_CobeFriend.genes,
383             uint256(_CobeFriend.generation)
384 		);
385 
386 		// This will assign ownership, and also emit the Transfer event as
387 		// per ERC721 draft
388 		_transfer(0, _owner, newCobeFriendId);
389 
390 		return newCobeFriendId;
391 	}
392 
393 	/// @dev An internal method that creates a new CobeFriend and stores it. This
394 	///  method doesn't do any checking and should only be called when the
395 	///  input data is known to be valid. Will generate both a Birth event
396 	///  and a Transfer event.
397 	/// @param _matronId The CobeFriend ID of the matron of this CobeFriend (zero for gen0)
398 	/// @param _sireId The CobeFriend ID of the sire of this CobeFriend (zero for gen0)
399 	/// @param _generation The generation number of this CobeFriend, must be computed by caller.
400 	/// @param _genes The CobeFriend's genetic code.
401 	/// @param _owner The inital owner of this CobeFriend, must be non-zero (except for the unCobeFriend, ID 0)
402     /// @param _time The birth time of CobeFriend
403     /// @param _cooldownIndex The cooldownIndex of CobeFriend
404 	function _createCobeFriendWithTime(
405 		uint256 _matronId,
406 		uint256 _sireId,
407 		uint256 _generation,
408 		uint256 _genes,
409 		address _owner,
410         uint256 _time,
411         uint256 _cooldownIndex
412 	)
413 	internal
414 	returns (uint)
415 	{
416 		// These requires are not strictly necessary, our calling code should make
417 		// sure that these conditions are never broken. However! _createCobeFriend() is already
418 		// an expensive call (for storage), and it doesn't hurt to be especially careful
419 		// to ensure our data structures are always valid.
420 		require(_matronId == uint256(uint32(_matronId)));
421 		require(_sireId == uint256(uint32(_sireId)));
422 		require(_generation == uint256(uint16(_generation)));
423         require(_time == uint256(uint64(_time)));
424         require(_cooldownIndex == uint256(uint16(_cooldownIndex)));
425 
426         // Copy down CobeFriend cooldownIndex
427         uint16 cooldownIndex = uint16(_cooldownIndex);
428 		if (cooldownIndex > 13) {
429 			cooldownIndex = 13;
430 		}
431 
432 		CobeFriend memory _CobeFriend = CobeFriend({
433 			genes: _genes,
434 			birthTime: uint64(_time),
435 			cooldownEndBlock: 0,
436 			matronId: uint32(_matronId),
437 			sireId: uint32(_sireId),
438 			siringWithId: 0,
439 			cooldownIndex: cooldownIndex,
440 			generation: uint16(_generation)
441 			});
442 		uint256 newCobeFriendId = CobeFriends.push(_CobeFriend) - 1;
443 
444 		// It's probably never going to happen, 4 billion CobeFriends is A LOT, but
445 		// let's just be 100% sure we never let this happen.
446 		require(newCobeFriendId == uint256(uint32(newCobeFriendId)));
447 
448 		// emit the birth event
449 		Birth(
450 			_owner,
451 			newCobeFriendId,
452 			uint256(_CobeFriend.matronId),
453 			uint256(_CobeFriend.sireId),
454 			_CobeFriend.genes,
455             uint256(_CobeFriend.generation)
456 		);
457 
458 		// This will assign ownership, and also emit the Transfer event as
459 		// per ERC721 draft
460 		_transfer(0, _owner, newCobeFriendId);
461 
462 		return newCobeFriendId;
463 	}
464 
465 	// Any C-level can fix how many seconds per blocks are currently observed.
466 	function setSecondsPerBlock(uint256 secs) external onlyCLevel {
467 		require(secs < cooldowns[0]);
468 		secondsPerBlock = secs;
469 	}
470 }
471 
472 
473 /// @title The external contract that is responsible for generating metadata for the CobeFriends,
474 ///  it has one function that will return the data as bytes.
475 contract ERC721Metadata {
476     /// @dev Given a token Id, returns a byte array that is supposed to be converted into string.
477     function getMetadata(uint256 _tokenId, string) public pure returns (bytes32[4] buffer, uint256 count) {
478         if (_tokenId == 1) {
479             buffer[0] = "Hello World! :D";
480             count = 15;
481         } else if (_tokenId == 2) {
482             buffer[0] = "I would definitely choose a medi";
483             buffer[1] = "um length string.";
484             count = 49;
485         } else if (_tokenId == 3) {
486             buffer[0] = "Lorem ipsum dolor sit amet, mi e";
487             buffer[1] = "st accumsan dapibus augue lorem,";
488             buffer[2] = " tristique vestibulum id, libero";
489             buffer[3] = " suscipit varius sapien aliquam.";
490             count = 128;
491         }
492     }
493 }
494 
495 
496 /// @title The facet of the CobeFriends core contract that manages ownership, ERC-721 (draft) compliant.
497 /// @dev Ref: https://github.com/ethereum/EIPs/issues/721
498 ///  See the CobeFriendCore contract documentation to understand how the various contract facets are arranged.
499 contract CobeFriendOwnership is CobeFriendBase, ERC721 {
500 
501     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
502     string public constant name = "CobeFriends";
503     string public constant symbol = "CBF";
504 
505     // The contract that will return CobeFriend metadata
506     ERC721Metadata public erc721Metadata;
507 
508     bytes4 constant InterfaceSignature_ERC165 =
509         bytes4(keccak256('supportsInterface(bytes4)'));
510 
511     bytes4 constant InterfaceSignature_ERC721 =
512         bytes4(keccak256('name()')) ^
513         bytes4(keccak256('symbol()')) ^
514         bytes4(keccak256('totalSupply()')) ^
515         bytes4(keccak256('balanceOf(address)')) ^
516         bytes4(keccak256('ownerOf(uint256)')) ^
517         bytes4(keccak256('approve(address,uint256)')) ^
518         bytes4(keccak256('transfer(address,uint256)')) ^
519         bytes4(keccak256('transferFrom(address,address,uint256)')) ^
520         bytes4(keccak256('tokensOfOwner(address)')) ^
521         bytes4(keccak256('tokenMetadata(uint256,string)'));
522 
523     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
524     ///  Returns true for any standardized interfaces implemented by this contract. We implement
525     ///  ERC-165 (obviously!) and ERC-721.
526     function supportsInterface(bytes4 _interfaceID) external view returns (bool)
527     {
528         // DEBUG ONLY
529         //require((InterfaceSignature_ERC165 == 0x01ffc9a7) && (InterfaceSignature_ERC721 == 0x9a20483d));
530 
531         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
532     }
533 
534     /// @dev Set the address of the sibling contract that tracks metadata.
535     ///  CEO only.
536     function setMetadataAddress(address _contractAddress) public onlyCEO {
537         erc721Metadata = ERC721Metadata(_contractAddress);
538     }
539 
540     // Internal utility functions: These functions all assume that their input arguments
541     // are valid. We leave it to public methods to sanitize their inputs and follow
542     // the required logic.
543 
544     /// @dev Checks if a given address is the current owner of a particular CobeFriend.
545     /// @param _claimant the address we are validating against.
546     /// @param _tokenId CobeFriend id, only valid when > 0
547     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
548         return CobeFriendIndexToOwner[_tokenId] == _claimant;
549     }
550 
551     /// @dev Checks if a given address currently has transferApproval for a particular CobeFriend.
552     /// @param _claimant the address we are confirming CobeFriend is approved for.
553     /// @param _tokenId CobeFriend id, only valid when > 0
554     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
555         return CobeFriendIndexToApproved[_tokenId] == _claimant;
556     }
557 
558     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
559     ///  approval. Setting _approved to address(0) clears all transfer approval.
560     ///  NOTE: _approve() does NOT send the Approval event. This is intentional because
561     ///  _approve() and transferFrom() are used together for putting CobeFriends on auction, and
562     ///  there is no value in spamming the log with Approval events in that case.
563     function _approve(uint256 _tokenId, address _approved) internal {
564         CobeFriendIndexToApproved[_tokenId] = _approved;
565     }
566 
567     /// @notice Returns the number of CobeFriends owned by a specific address.
568     /// @param _owner The owner address to check.
569     /// @dev Required for ERC-721 compliance
570     function balanceOf(address _owner) public view returns (uint256 count) {
571         return ownershipTokenCount[_owner];
572     }
573 
574     /// @notice Transfers a CobeFriend to another address. If transferring to a smart
575     ///  contract be VERY CAREFUL to ensure that it is aware of ERC-721 (or
576     ///  CobeFriends specifically) or your CobeFriend may be lost forever. Seriously.
577     /// @param _to The address of the recipient, can be a user or contract.
578     /// @param _tokenId The ID of the CobeFriend to transfer.
579     /// @dev Required for ERC-721 compliance.
580     function transfer(
581         address _to,
582         uint256 _tokenId
583     )
584         external
585         whenNotPaused
586     {
587         // Safety check to prevent against an unexpected 0x0 default.
588         require(_to != address(0));
589         // Disallow transfers to this contract to prevent accidental misuse.
590         // The contract should never own any CobeFriends (except very briefly
591         // after a gen0 cbf is created and before it goes on auction).
592         require(_to != address(this));
593         // Disallow transfers to the auction contracts to prevent accidental
594         // misuse. Auction contracts should only take ownership of CobeFriends
595         // through the allow + transferFrom flow.
596         require(_to != address(saleAuction));
597 
598         // You can only send your own cbf.
599         require(_owns(msg.sender, _tokenId));
600 
601         // Reassign ownership, clear pending approvals, emit Transfer event.
602         _transfer(msg.sender, _to, _tokenId);
603     }
604 
605     /// @notice Grant another address the right to transfer a specific CobeFriend via
606     ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
607     /// @param _to The address to be granted transfer approval. Pass address(0) to
608     ///  clear all approvals.
609     /// @param _tokenId The ID of the CobeFriend that can be transferred if this call succeeds.
610     /// @dev Required for ERC-721 compliance.
611     function approve(
612         address _to,
613         uint256 _tokenId
614     )
615         external
616         whenNotPaused
617     {
618         // Only an owner can grant transfer approval.
619         require(_owns(msg.sender, _tokenId));
620 
621         // Register the approval (replacing any previous approval).
622         _approve(_tokenId, _to);
623 
624         // Emit approval event.
625         Approval(msg.sender, _to, _tokenId);
626     }
627 
628     /// @notice Transfer a CobeFriend owned by another address, for which the calling address
629     ///  has previously been granted transfer approval by the owner.
630     /// @param _from The address that owns the CobeFriend to be transfered.
631     /// @param _to The address that should take ownership of the CobeFriend. Can be any address,
632     ///  including the caller.
633     /// @param _tokenId The ID of the CobeFriend to be transferred.
634     /// @dev Required for ERC-721 compliance.
635     function transferFrom(
636         address _from,
637         address _to,
638         uint256 _tokenId
639     )
640         external
641         whenNotPaused
642     {
643         // Safety check to prevent against an unexpected 0x0 default.
644         require(_to != address(0));
645         // Disallow transfers to this contract to prevent accidental misuse.
646         // The contract should never own any CobeFriends (except very briefly
647         // after a gen0 cbf is created and before it goes on auction).
648         require(_to != address(this));
649         // Check for approval and valid ownership
650         require(_approvedFor(msg.sender, _tokenId));
651         require(_owns(_from, _tokenId));
652 
653         // Reassign ownership (also clears pending approvals and emits Transfer event).
654         _transfer(_from, _to, _tokenId);
655     }
656 
657     /// @notice Returns the total number of CobeFriends currently in existence.
658     /// @dev Required for ERC-721 compliance.
659     function totalSupply() public view returns (uint) {
660         return CobeFriends.length - 1;
661     }
662 
663     /// @notice Returns the address currently assigned ownership of a given CobeFriend.
664     /// @dev Required for ERC-721 compliance.
665     function ownerOf(uint256 _tokenId)
666         external
667         view
668         returns (address owner)
669     {
670         owner = CobeFriendIndexToOwner[_tokenId];
671 
672         require(owner != address(0));
673     }
674 
675     /// @notice Returns a list of all CobeFriend IDs assigned to an address.
676     /// @param _owner The owner whose CobeFriends we are interested in.
677     /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
678     ///  expensive (it walks the entire CobeFriend array looking for cbfs belonging to owner),
679     ///  but it also returns a dynamic array, which is only supported for web3 calls, and
680     ///  not contract-to-contract calls.
681     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
682         uint256 tokenCount = balanceOf(_owner);
683 
684         if (tokenCount == 0) {
685             // Return an empty array
686             return new uint256[](0);
687         } else {
688             uint256[] memory result = new uint256[](tokenCount);
689             uint256 totalcbfs = totalSupply();
690             uint256 resultIndex = 0;
691 
692             // We count on the fact that all cbfs have IDs starting at 1 and increasing
693             // sequentially up to the totalcbf count.
694             uint256 cbfId;
695 
696             for (cbfId = 1; cbfId <= totalcbfs; cbfId++) {
697                 if (CobeFriendIndexToOwner[cbfId] == _owner) {
698                     result[resultIndex] = cbfId;
699                     resultIndex++;
700                 }
701             }
702 
703             return result;
704         }
705     }
706 
707     /// @dev Adapted from memcpy() by @arachnid (Nick Johnson <arachnid@notdot.net>)
708     ///  This method is licenced under the Apache License.
709     ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
710     function _memcpy(uint _dest, uint _src, uint _len) private view {
711         // Copy word-length chunks while possible
712         for(; _len >= 32; _len -= 32) {
713             assembly {
714                 mstore(_dest, mload(_src))
715             }
716             _dest += 32;
717             _src += 32;
718         }
719 
720         // Copy remaining bytes
721         uint256 mask = 256 ** (32 - _len) - 1;
722         assembly {
723             let srcpart := and(mload(_src), not(mask))
724             let destpart := and(mload(_dest), mask)
725             mstore(_dest, or(destpart, srcpart))
726         }
727     }
728 
729     /// @dev Adapted from toString(slice) by @arachnid (Nick Johnson <arachnid@notdot.net>)
730     ///  This method is licenced under the Apache License.
731     ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
732     function _toString(bytes32[4] _rawBytes, uint256 _stringLength) private view returns (string) {
733         var outputString = new string(_stringLength);
734         uint256 outputPtr;
735         uint256 bytesPtr;
736 
737         assembly {
738             outputPtr := add(outputString, 32)
739             bytesPtr := _rawBytes
740         }
741 
742         _memcpy(outputPtr, bytesPtr, _stringLength);
743 
744         return outputString;
745     }
746 
747     /// @notice Returns a URI pointing to a metadata package for this token conforming to
748     ///  ERC-721 (https://github.com/ethereum/EIPs/issues/721)
749     /// @param _tokenId The ID number of the CobeFriend whose metadata should be returned.
750     function tokenMetadata(uint256 _tokenId, string _preferredTransport) external view returns (string infoUrl) {
751         require(erc721Metadata != address(0));
752         bytes32[4] memory buffer;
753         uint256 count;
754         (buffer, count) = erc721Metadata.getMetadata(_tokenId, _preferredTransport);
755 
756         return _toString(buffer, count);
757     }
758 }
759 
760 
761 /// @title Auction Core
762 /// @dev Contains models, variables, and internal methods for the auction.
763 /// @notice We omit a fallback function to prevent accidental sends to this contract.
764 contract ClockAuctionBase {
765 
766     // Represents an auction on an NFT
767     struct Auction {
768         // Current owner of NFT
769         address seller;
770         // Price (in wei) at beginning of auction
771         uint128 startingPrice;
772         // Price (in wei) at end of auction
773         uint128 endingPrice;
774         // Duration (in seconds) of auction
775         uint64 duration;
776         // Time when auction started
777         // NOTE: 0 if this auction has been concluded
778         uint64 startedAt;
779     }
780 
781     // Reference to contract tracking NFT ownership
782     ERC721 public nonFungibleContract;
783 
784     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
785     // Values 0-10,000 map to 0%-100%
786     uint256 public ownerCut;
787 
788     // Map from token ID to their corresponding auction.
789     mapping (uint256 => Auction) tokenIdToAuction;
790 
791     event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
792     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
793     event AuctionCancelled(uint256 tokenId);
794 
795     /// @dev Returns true if the claimant owns the token.
796     /// @param _claimant - Address claiming to own the token.
797     /// @param _tokenId - ID of token whose ownership to verify.
798     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
799         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
800     }
801 
802     /// @dev Escrows the NFT, assigning ownership to this contract.
803     /// Throws if the escrow fails.
804     /// @param _owner - Current owner address of token to escrow.
805     /// @param _tokenId - ID of token whose approval to verify.
806     function _escrow(address _owner, uint256 _tokenId) internal {
807         // it will throw if transfer fails
808         nonFungibleContract.transferFrom(_owner, this, _tokenId);
809     }
810 
811     /// @dev Transfers an NFT owned by this contract to another address.
812     /// Returns true if the transfer succeeds.
813     /// @param _receiver - Address to transfer NFT to.
814     /// @param _tokenId - ID of token to transfer.
815     function _transfer(address _receiver, uint256 _tokenId) internal {
816         // it will throw if transfer fails
817         nonFungibleContract.transfer(_receiver, _tokenId);
818     }
819 
820     /// @dev Adds an auction to the list of open auctions. Also fires the
821     ///  AuctionCreated event.
822     /// @param _tokenId The ID of the token to be put on auction.
823     /// @param _auction Auction to add.
824     function _addAuction(uint256 _tokenId, Auction _auction) internal {
825         // Require that all auctions have a duration of
826         // at least one minute. (Keeps our math from getting hairy!)
827         require(_auction.duration >= 1 minutes);
828 
829         tokenIdToAuction[_tokenId] = _auction;
830 
831         AuctionCreated(
832             uint256(_tokenId),
833             uint256(_auction.startingPrice),
834             uint256(_auction.endingPrice),
835             uint256(_auction.duration)
836         );
837     }
838 
839     /// @dev Cancels an auction unconditionally.
840     function _cancelAuction(uint256 _tokenId, address _seller) internal {
841         _removeAuction(_tokenId);
842         _transfer(_seller, _tokenId);
843         AuctionCancelled(_tokenId);
844     }
845 
846     /// @dev Computes the price and transfers winnings.
847     /// Does NOT transfer ownership of token.
848     function _bid(uint256 _tokenId, uint256 _bidAmount)
849         internal
850         returns (uint256)
851     {
852         // Get a reference to the auction struct
853         Auction storage auction = tokenIdToAuction[_tokenId];
854 
855         // Explicitly check that this auction is currently live.
856         // (Because of how Ethereum mappings work, we can't just count
857         // on the lookup above failing. An invalid _tokenId will just
858         // return an auction object that is all zeros.)
859         require(_isOnAuction(auction));
860 
861         // Check that the bid is greater than or equal to the current price
862         uint256 price = _currentPrice(auction);
863         require(_bidAmount >= price);
864 
865         // Grab a reference to the seller before the auction struct
866         // gets deleted.
867         address seller = auction.seller;
868 
869         // The bid is good! Remove the auction before sending the fees
870         // to the sender so we can't have a reentrancy attack.
871         _removeAuction(_tokenId);
872 
873         // Transfer proceeds to seller (if there are any!)
874         if (price > 0) {
875             // Calculate the auctioneer's cut.
876             // (NOTE: _computeCut() is guaranteed to return a
877             // value <= price, so this subtraction can't go negative.)
878             uint256 auctioneerCut = _computeCut(price);
879             uint256 sellerProceeds = price - auctioneerCut;
880 
881             // NOTE: Doing a transfer() in the middle of a complex
882             // method like this is generally discouraged because of
883             // reentrancy attacks and DoS attacks if the seller is
884             // a contract with an invalid fallback function. We explicitly
885             // guard against reentrancy attacks by removing the auction
886             // before calling transfer(), and the only thing the seller
887             // can DoS is the sale of their own asset! (And if it's an
888             // accident, they can call cancelAuction(). )
889             seller.transfer(sellerProceeds);
890         }
891 
892         // Calculate any excess funds included with the bid. If the excess
893         // is anything worth worrying about, transfer it back to bidder.
894         // NOTE: We checked above that the bid amount is greater than or
895         // equal to the price so this cannot underflow.
896         uint256 bidExcess = _bidAmount - price;
897 
898         // Return the funds. Similar to the previous transfer, this is
899         // not susceptible to a re-entry attack because the auction is
900         // removed before any transfers occur.
901         msg.sender.transfer(bidExcess);
902 
903         // Tell the world!
904         AuctionSuccessful(_tokenId, price, msg.sender);
905 
906         return price;
907     }
908 
909     /// @dev Removes an auction from the list of open auctions.
910     /// @param _tokenId - ID of NFT on auction.
911     function _removeAuction(uint256 _tokenId) internal {
912         delete tokenIdToAuction[_tokenId];
913     }
914 
915     /// @dev Returns true if the NFT is on auction.
916     /// @param _auction - Auction to check.
917     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
918         return (_auction.startedAt > 0);
919     }
920 
921     /// @dev Returns current price of an NFT on auction. Broken into two
922     ///  functions (this one, that computes the duration from the auction
923     ///  structure, and the other that does the price computation) so we
924     ///  can easily test that the price computation works correctly.
925     function _currentPrice(Auction storage _auction)
926         internal
927         view
928         returns (uint256)
929     {
930         uint256 secondsPassed = 0;
931 
932         // A bit of insurance against negative values (or wraparound).
933         // Probably not necessary (since Ethereum guarnatees that the
934         // now variable doesn't ever go backwards).
935         if (now > _auction.startedAt) {
936             secondsPassed = now - _auction.startedAt;
937         }
938 
939         return _computeCurrentPrice(
940             _auction.startingPrice,
941             _auction.endingPrice,
942             _auction.duration,
943             secondsPassed
944         );
945     }
946 
947     /// @dev Computes the current price of an auction. Factored out
948     ///  from _currentPrice so we can run extensive unit tests.
949     ///  When testing, make this function public and turn on
950     ///  `Current price computation` test suite.
951     function _computeCurrentPrice(
952         uint256 _startingPrice,
953         uint256 _endingPrice,
954         uint256 _duration,
955         uint256 _secondsPassed
956     )
957         internal
958         pure
959         returns (uint256)
960     {
961         // NOTE: We don't use SafeMath (or similar) in this function because
962         //  all of our public functions carefully cap the maximum values for
963         //  time (at 64-bits) and currency (at 128-bits). _duration is
964         //  also known to be non-zero (see the require() statement in
965         //  _addAuction())
966         if (_secondsPassed >= _duration) {
967             // We've reached the end of the dynamic pricing portion
968             // of the auction, just return the end price.
969             return _endingPrice;
970         } else {
971             // Starting price can be higher than ending price (and often is!), so
972             // this delta can be negative.
973             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
974 
975             // This multiplication can't overflow, _secondsPassed will easily fit within
976             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
977             // will always fit within 256-bits.
978             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
979 
980             // currentPriceChange can be negative, but if so, will have a magnitude
981             // less that _startingPrice. Thus, this result will always end up positive.
982             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
983 
984             return uint256(currentPrice);
985         }
986     }
987 
988     /// @dev Computes owner's cut of a sale.
989     /// @param _price - Sale price of NFT.
990     function _computeCut(uint256 _price) internal view returns (uint256) {
991         // NOTE: We don't use SafeMath (or similar) in this function because
992         //  all of our entry functions carefully cap the maximum values for
993         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
994         //  statement in the ClockAuction constructor). The result of this
995         //  function is always guaranteed to be <= _price.
996         return _price * ownerCut / 10000;
997     }
998 }
999 
1000 
1001 /**
1002  * @title Pausable
1003  * @dev Base contract which allows children to implement an emergency stop mechanism.
1004  */
1005 contract Pausable is Ownable {
1006 	event Pause();
1007 	event Unpause();
1008 
1009 	bool public paused = false;
1010 
1011 
1012 	/**
1013 	 * @dev modifier to allow actions only when the contract IS paused
1014 	 */
1015 	modifier whenNotPaused() {
1016 		require(!paused);
1017 		_;
1018 	}
1019 
1020 	/**
1021 	 * @dev modifier to allow actions only when the contract IS NOT paused
1022 	 */
1023 	modifier whenPaused {
1024 		require(paused);
1025 		_;
1026 	}
1027 
1028 	/**
1029 	 * @dev called by the owner to pause, triggers stopped state
1030 	 */
1031 	function pause() public onlyOwner whenNotPaused returns (bool) {
1032 		paused = true;
1033 		Pause();
1034 		return true;
1035 	}
1036 
1037 	/**
1038 	 * @dev called by the owner to unpause, returns to normal state
1039 	 */
1040 	function unpause() public onlyOwner whenPaused returns (bool) {
1041 		paused = false;
1042 		Unpause();
1043 		return true;
1044 	}
1045 }
1046 
1047 
1048 /// @title Clock auction for non-fungible tokens.
1049 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1050 contract ClockAuction is Pausable, ClockAuctionBase {
1051 
1052     /// @dev The ERC-165 interface signature for ERC-721.
1053     ///  Ref: https://github.com/ethereum/EIPs/issues/165
1054     ///  Ref: https://github.com/ethereum/EIPs/issues/721
1055     bytes4 constant InterfaceSignature_ERC721 = bytes4(0x9a20483d);
1056 
1057     /// @dev Constructor creates a reference to the NFT ownership contract
1058     ///  and verifies the owner cut is in the valid range.
1059     /// @param _nftAddress - address of a deployed contract implementing
1060     ///  the Nonfungible Interface.
1061     /// @param _cut - percent cut the owner takes on each auction, must be
1062     ///  between 0-10,000.
1063     function ClockAuction(address _nftAddress, uint256 _cut) public {
1064         require(_cut <= 10000);
1065         ownerCut = _cut;
1066 
1067         ERC721 candidateContract = ERC721(_nftAddress);
1068         require(candidateContract.supportsInterface(InterfaceSignature_ERC721));
1069         nonFungibleContract = candidateContract;
1070     }
1071 
1072     /// @dev Remove all Ether from the contract, which is the owner's cuts
1073     ///  as well as any Ether sent directly to the contract address.
1074     ///  Always transfers to the NFT contract, but can be called either by
1075     ///  the owner or the NFT contract.
1076     function withdrawBalance() external {
1077         address nftAddress = address(nonFungibleContract);
1078 
1079         require(
1080             msg.sender == owner ||
1081             msg.sender == nftAddress
1082         );
1083         // We are using this boolean method to make sure that even if one fails it will still work
1084         nftAddress.transfer(this.balance);
1085     }
1086 
1087     /// @dev Creates and begins a new auction.
1088     /// @param _tokenId - ID of token to auction, sender must be owner.
1089     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
1090     /// @param _endingPrice - Price of item (in wei) at end of auction.
1091     /// @param _duration - Length of time to move between starting
1092     ///  price and ending price (in seconds).
1093     /// @param _seller - Seller, if not the message sender
1094     function createAuction(
1095         uint256 _tokenId,
1096         uint256 _startingPrice,
1097         uint256 _endingPrice,
1098         uint256 _duration,
1099         address _seller
1100     )
1101         external
1102         whenNotPaused
1103     {
1104         // Sanity check that no inputs overflow how many bits we've allocated
1105         // to store them in the auction struct.
1106         require(_startingPrice == uint256(uint128(_startingPrice)));
1107         require(_endingPrice == uint256(uint128(_endingPrice)));
1108         require(_duration == uint256(uint64(_duration)));
1109 
1110         require(_owns(msg.sender, _tokenId));
1111         _escrow(msg.sender, _tokenId);
1112         Auction memory auction = Auction(
1113             _seller,
1114             uint128(_startingPrice),
1115             uint128(_endingPrice),
1116             uint64(_duration),
1117             uint64(now)
1118         );
1119         _addAuction(_tokenId, auction);
1120     }
1121 
1122     /// @dev Bids on an open auction, completing the auction and transferring
1123     ///  ownership of the NFT if enough Ether is supplied.
1124     /// @param _tokenId - ID of token to bid on.
1125     function bid(uint256 _tokenId)
1126         external
1127         payable
1128         whenNotPaused
1129     {
1130         // _bid will throw if the bid or funds transfer fails
1131         _bid(_tokenId, msg.value);
1132         _transfer(msg.sender, _tokenId);
1133     }
1134 
1135     /// @dev Cancels an auction that hasn't been won yet.
1136     ///  Returns the NFT to original owner.
1137     /// @notice This is a state-modifying function that can
1138     ///  be called while the contract is paused.
1139     /// @param _tokenId - ID of token on auction
1140     function cancelAuction(uint256 _tokenId)
1141         external
1142     {
1143         Auction storage auction = tokenIdToAuction[_tokenId];
1144         require(_isOnAuction(auction));
1145         address seller = auction.seller;
1146         require(msg.sender == seller);
1147         _cancelAuction(_tokenId, seller);
1148     }
1149 
1150     /// @dev Cancels an auction when the contract is paused.
1151     ///  Only the owner may do this, and NFTs are returned to
1152     ///  the seller. This should only be used in emergencies.
1153     /// @param _tokenId - ID of the NFT on auction to cancel.
1154     function cancelAuctionWhenPaused(uint256 _tokenId)
1155         whenPaused
1156         onlyOwner
1157         external
1158     {
1159         Auction storage auction = tokenIdToAuction[_tokenId];
1160         require(_isOnAuction(auction));
1161         _cancelAuction(_tokenId, auction.seller);
1162     }
1163 
1164     /// @dev Returns auction info for an NFT on auction.
1165     /// @param _tokenId - ID of NFT on auction.
1166     function getAuction(uint256 _tokenId)
1167         external
1168         view
1169         returns
1170     (
1171         address seller,
1172         uint256 startingPrice,
1173         uint256 endingPrice,
1174         uint256 duration,
1175         uint256 startedAt
1176     ) {
1177         Auction storage auction = tokenIdToAuction[_tokenId];
1178         require(_isOnAuction(auction));
1179         return (
1180             auction.seller,
1181             auction.startingPrice,
1182             auction.endingPrice,
1183             auction.duration,
1184             auction.startedAt
1185         );
1186     }
1187 
1188     /// @dev Returns the current price of an auction.
1189     /// @param _tokenId - ID of the token price we are checking.
1190     function getCurrentPrice(uint256 _tokenId)
1191         external
1192         view
1193         returns (uint256)
1194     {
1195         Auction storage auction = tokenIdToAuction[_tokenId];
1196         require(_isOnAuction(auction));
1197         return _currentPrice(auction);
1198     }
1199 
1200 }
1201 
1202 
1203 /// @title Clock auction modified for sale of CobeFriends
1204 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1205 contract SaleClockAuction is ClockAuction {
1206 
1207     // @dev Sanity check that allows us to ensure that we are pointing to the
1208     //  right auction in our setSaleAuctionAddress() call.
1209     bool public isSaleClockAuction = true;
1210 
1211     // Tracks last 5 sale price of gen0 CobeFriend sales
1212     uint256 public gen0SaleCount;
1213     uint256[5] public lastGen0SalePrices;
1214 
1215     // Delegate constructor
1216     function SaleClockAuction(address _nftAddr, uint256 _cut) public
1217         ClockAuction(_nftAddr, _cut) {}
1218 
1219     /// @dev Creates and begins a new auction.
1220     /// @param _tokenId - ID of token to auction, sender must be owner.
1221     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
1222     /// @param _endingPrice - Price of item (in wei) at end of auction.
1223     /// @param _duration - Length of auction (in seconds).
1224     /// @param _seller - Seller, if not the message sender
1225     function createAuction(
1226         uint256 _tokenId,
1227         uint256 _startingPrice,
1228         uint256 _endingPrice,
1229         uint256 _duration,
1230         address _seller
1231     )
1232         external
1233     {
1234         // Sanity check that no inputs overflow how many bits we've allocated
1235         // to store them in the auction struct.
1236         require(_startingPrice == uint256(uint128(_startingPrice)));
1237         require(_endingPrice == uint256(uint128(_endingPrice)));
1238         require(_duration == uint256(uint64(_duration)));
1239 
1240         require(msg.sender == address(nonFungibleContract));
1241         _escrow(_seller, _tokenId);
1242         Auction memory auction = Auction(
1243             _seller,
1244             uint128(_startingPrice),
1245             uint128(_endingPrice),
1246             uint64(_duration),
1247             uint64(now)
1248         );
1249         _addAuction(_tokenId, auction);
1250     }
1251 
1252     /// @dev Updates lastSalePrice if seller is the nft contract
1253     /// Otherwise, works the same as default bid method.
1254     function bid(uint256 _tokenId)
1255         external
1256         payable
1257     {
1258         // _bid verifies token ID size
1259         address seller = tokenIdToAuction[_tokenId].seller;
1260         uint256 price = _bid(_tokenId, msg.value);
1261         _transfer(msg.sender, _tokenId);
1262 
1263         // If not a gen0 auction, exit
1264         if (seller == address(nonFungibleContract)) {
1265             // Track gen0 sale prices
1266             lastGen0SalePrices[gen0SaleCount % 5] = price;
1267             gen0SaleCount++;
1268         }
1269     }
1270 
1271     function averageGen0SalePrice() external view returns (uint256) {
1272         uint256 sum = 0;
1273         for (uint256 i = 0; i < 5; i++) {
1274             sum += lastGen0SalePrices[i];
1275         }
1276         return sum / 5;
1277     }
1278 
1279 }
1280 
1281 
1282 /// @title Handles creating auctions for sale and siring of CobeFriends.
1283 ///  This wrapper of ReverseAuction exists only so that users can create
1284 ///  auctions with only one transaction.
1285 contract CobeFriendAuction is CobeFriendOwnership {
1286 
1287     // @notice The auction contract variables are defined in CobeFriendBase to allow
1288     //  us to refer to them in CobeFriendOwnership to prevent accidental transfers.
1289     // `saleAuction` refers to the auction for gen0 and p2p sale of CobeFriends.
1290     // `siringAuction` refers to the auction for siring rights of CobeFriends.
1291 
1292     /// @dev Sets the reference to the sale auction.
1293     /// @param _address - Address of sale contract.
1294     function setSaleAuctionAddress(address _address) external onlyCEO {
1295         SaleClockAuction candidateContract = SaleClockAuction(_address);
1296 
1297         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
1298         require(candidateContract.isSaleClockAuction());
1299 
1300         // Set the new contract address
1301         saleAuction = candidateContract;
1302     }
1303 
1304     /// @dev Put a CobeFriend up for auction.
1305     ///  Does some ownership trickery to create auctions in one tx.
1306     function createSaleAuction(
1307         uint256 _CobeFriendId,
1308         uint256 _startingPrice,
1309         uint256 _endingPrice,
1310         uint256 _duration
1311     )
1312         external
1313         whenNotPaused
1314     {
1315         // Auction contract checks input sizes
1316         // If CobeFriend is already on any auction, this will throw
1317         // because it will be owned by the auction contract.
1318         require(_owns(msg.sender, _CobeFriendId));
1319         _approve(_CobeFriendId, saleAuction);
1320         // Sale auction throws if inputs are invalid and clears
1321         // transfer and sire approval after escrowing the CobeFriend.
1322         saleAuction.createAuction(
1323             _CobeFriendId,
1324             _startingPrice,
1325             _endingPrice,
1326             _duration,
1327             msg.sender
1328         );
1329     }
1330 
1331 
1332     /// @dev Transfers the balance of the sale auction contract
1333     /// to the CobeFriendCore contract. We use two-step withdrawal to
1334     /// prevent two transfer calls in the auction bid function.
1335     function withdrawAuctionBalances() external onlyCLevel {
1336         saleAuction.withdrawBalance();
1337     }
1338 }
1339 
1340 
1341 /// @title all functions related to creating CobeFriends
1342 contract CobeFriendMinting is CobeFriendAuction {
1343 
1344     // Limits the number of cbfs the contract owner can ever create.
1345     uint256 public constant DEFAULT_CREATION_LIMIT = 50000;
1346 
1347     // Counts the number of cbfs the contract owner has created.
1348     uint256 public defaultCreatedCount;
1349 
1350 
1351     /// @dev we can create CobeFriends with different generations. Only callable by COO
1352     /// @param _genes The encoded genes of the CobeFriend to be created, any value is accepted
1353     /// @param _owner The future owner of the created CobeFriend. Default to contract COO
1354     /// @param _time The birth time of CobeFriend
1355     /// @param _cooldownIndex The cooldownIndex of CobeFriend
1356     function createDefaultGen0CobeFriend(uint256 _genes, address _owner, uint256 _time, uint256 _cooldownIndex) external onlyCOO {
1357 
1358         require(_time == uint256(uint64(_time)));
1359         require(_cooldownIndex == uint256(uint16(_cooldownIndex)));
1360 
1361         require(_time > 0);
1362         require(_cooldownIndex >= 0 && _cooldownIndex <= 13);
1363 
1364         address CobeFriendOwner = _owner;
1365         if (CobeFriendOwner == address(0)) {
1366             CobeFriendOwner = cooAddress;
1367         }
1368         require(defaultCreatedCount < DEFAULT_CREATION_LIMIT);
1369 
1370         defaultCreatedCount++;
1371         _createCobeFriendWithTime(0, 0, 0, _genes, CobeFriendOwner, _time, _cooldownIndex);
1372     }
1373 
1374     /// @dev we can create CobeFriends with different generations. Only callable by COO
1375     /// @param _matronId The CobeFriend ID of the matron of this CobeFriend
1376     /// @param _sireId The CobeFriend ID of the sire of this CobeFriend
1377     /// @param _genes The encoded genes of the CobeFriend to be created, any value is accepted
1378     /// @param _owner The future owner of the created CobeFriend. Default to contract COO
1379     /// @param _time The birth time of CobeFriend
1380     /// @param _cooldownIndex The cooldownIndex of CobeFriend
1381     function createDefaultCobeFriend(uint256 _matronId, uint256 _sireId, uint256 _genes, address _owner, uint256 _time, uint256 _cooldownIndex) external onlyCOO {
1382 
1383         require(_matronId == uint256(uint32(_matronId)));
1384         require(_sireId == uint256(uint32(_sireId)));
1385         require(_time == uint256(uint64(_time)));
1386         require(_cooldownIndex == uint256(uint16(_cooldownIndex)));
1387 
1388         require(_time > 0);
1389         require(_cooldownIndex >= 0 && _cooldownIndex <= 13);
1390 
1391         address CobeFriendOwner = _owner;
1392         if (CobeFriendOwner == address(0)) {
1393             CobeFriendOwner = cooAddress;
1394         }
1395 
1396         require(_matronId > 0);
1397         require(_sireId > 0);
1398 
1399         // Grab a reference to the matron in storage.
1400         CobeFriend storage matron = CobeFriends[_matronId];
1401 
1402         // Grab a reference to the sire in storage.
1403         CobeFriend storage sire = CobeFriends[_sireId];
1404 
1405         // Determine the higher generation number of the two parents
1406         uint16 parentGen = matron.generation;
1407         if (sire.generation > matron.generation) {
1408             parentGen = sire.generation;
1409         }
1410 
1411         _createCobeFriendWithTime(_matronId, _sireId, parentGen + 1, _genes, CobeFriendOwner, _time, _cooldownIndex);
1412     }
1413 
1414 }
1415 
1416 
1417 /// @title CobeFriends: Collectible, breedable, and oh-so-adorable CobeFriends on the Ethereum blockchain.
1418 /// @dev The main CobeFriends contract, keeps track of cbfs so they don't wander around and get lost.
1419 contract CobeFriendCore is CobeFriendMinting {
1420 /* contract CobeFriendCore { */
1421     // This is the main CobeFriends contract. In order to keep our code seperated into logical sections,
1422     // we've broken it up in two ways. First, we have several seperately-instantiated sibling contracts
1423     // that handle auctions and our super-top-secret genetic combination algorithm. The auctions are
1424     // seperate since their logic is somewhat complex and there's always a risk of subtle bugs. By keeping
1425     // them in their own contracts, we can upgrade them without disrupting the main contract that tracks
1426     // CobeFriend ownership. The genetic combination algorithm is kept seperate so we can open-source all of
1427     // the rest of our code without making it _too_ easy for folks to figure out how the genetics work.
1428     // Don't worry, I'm sure someone will reverse engineer it soon enough!
1429     //
1430     // Secondly, we break the core contract into multiple files using inheritence, one for each major
1431     // facet of functionality of CK. This allows us to keep related code bundled together while still
1432     // avoiding a single giant file with everything in it. The breakdown is as follows:
1433     //
1434     //      - CobeFriendBase: This is where we define the most fundamental code shared throughout the core
1435     //             functionality. This includes our main data storage, constants and data types, plus
1436     //             internal functions for managing these items.
1437     //
1438     //      - CobeFriendAccessControl: This contract manages the various addresses and constraints for operations
1439     //             that can be executed only by specific roles. Namely CEO, CFO and COO.
1440     //
1441     //      - CobeFriendOwnership: This provides the methods required for basic non-fungible token
1442     //             transactions, following the draft ERC-721 spec (https://github.com/ethereum/EIPs/issues/721).
1443     //
1444     //      - CobeFriendBreeding: This file contains the methods necessary to breed CobeFriends together, including
1445     //             keeping track of siring offers, and relies on an external genetic combination contract.
1446     //
1447     //      - CobeFriendAuctions: Here we have the public methods for auctioning or bidding on CobeFriends or siring
1448     //             services. The actual auction functionality is handled in two sibling contracts (one
1449     //             for sales and one for siring), while auction creation and bidding is mostly mediated
1450     //             through this facet of the core contract.
1451     //
1452     //      - CobeFriendMinting: This final facet contains the functionality we use for creating new gen0 CobeFriends.
1453     //             We can make up to 5000 "promo" CobeFriends that can be given away (especially important when
1454     //             the community is new), and all others can only be created and then immediately put up
1455     //             for auction via an algorithmically determined starting price. Regardless of how they
1456     //             are created, there is a hard limit of 2400*12*12 gen0 CobeFriends. After that, it's all up to the
1457     //             community to breed, breed, breed!
1458 
1459     // Set in case the core contract is broken and an upgrade is required
1460     address public newContractAddress;
1461 
1462     /// @notice Creates the main CobeFriends smart contract instance.
1463     function CobeFriendCore() public {
1464         // Starts paused.
1465         paused = true;
1466 
1467         // the creator of the contract is the initial CEO
1468         ceoAddress = msg.sender;
1469 
1470         // the creator of the contract is also the initial COO
1471         cooAddress = msg.sender;
1472 
1473         // start with the mythical CobeFriend 0 - so we don't have generation-0 parent issues
1474         _createCobeFriend(0, 0, 0, uint256(-1), address(0));
1475     }
1476 
1477     /// @dev Used to mark the smart contract as upgraded, in case there is a serious
1478     ///  breaking bug. This method does nothing but keep track of the new contract and
1479     ///  emit a message indicating that the new address is set. It's up to clients of this
1480     ///  contract to update to the new contract address in that case. (This contract will
1481     ///  be paused indefinitely if such an upgrade takes place.)
1482     /// @param _v2Address new address
1483     function setNewAddress(address _v2Address) external onlyCEO whenPaused {
1484         // See README.md for updgrade plan
1485         newContractAddress = _v2Address;
1486         ContractUpgrade(_v2Address);
1487     }
1488 
1489     /// @notice No tipping!
1490     /// @dev Reject all Ether from being sent here, unless it's from one of the
1491     ///  two auction contracts. (Hopefully, we can prevent user accidents.)
1492     function() external payable {
1493         require(
1494             msg.sender == address(saleAuction)
1495         );
1496     }
1497 
1498     /// @notice Returns all the relevant information about a specific CobeFriend.
1499     /// @param _id The ID of the CobeFriend of interest.
1500     function getCobeFriend(uint256 _id)
1501         external
1502         view
1503         returns (
1504         bool isGestating,
1505         bool isReady,
1506         uint256 cooldownIndex,
1507         uint256 nextActionAt,
1508         uint256 siringWithId,
1509         uint256 birthTime,
1510         uint256 matronId,
1511         uint256 sireId,
1512         uint256 generation,
1513         uint256 genes
1514     ) {
1515         CobeFriend storage cbf = CobeFriends[_id];
1516 
1517         // if this variable is 0 then it's not gestating
1518         isGestating = (cbf.siringWithId != 0);
1519         isReady = (cbf.cooldownEndBlock <= block.number);
1520         cooldownIndex = uint256(cbf.cooldownIndex);
1521         nextActionAt = uint256(cbf.cooldownEndBlock);
1522         siringWithId = uint256(cbf.siringWithId);
1523         birthTime = uint256(cbf.birthTime);
1524         matronId = uint256(cbf.matronId);
1525         sireId = uint256(cbf.sireId);
1526         generation = uint256(cbf.generation);
1527         genes = cbf.genes;
1528     }
1529 
1530     /// @dev Override unpause so it requires all external contract addresses
1531     ///  to be set before contract can be unpaused. Also, we can't have
1532     ///  newContractAddress set either, because then the contract was upgraded.
1533     /// @notice This is public rather than external so we can call super.unpause
1534     ///  without using an expensive CALL.
1535     function unpause() public onlyCEO whenPaused {
1536         require(saleAuction != address(0));
1537         require(newContractAddress == address(0));
1538 
1539         // Actually unpause the contract.
1540         super.unpause();
1541     }
1542 
1543     // @dev Allows the CFO to capture the balance available to the contract.
1544     function withdrawBalance() external onlyCFO {
1545         uint256 balance = this.balance;
1546         cfoAddress.transfer(balance);
1547     }
1548 }