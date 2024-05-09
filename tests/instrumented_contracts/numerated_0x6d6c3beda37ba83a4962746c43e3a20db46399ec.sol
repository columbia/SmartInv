1 pragma solidity >=0.5.6 <0.6.0;
2 
3 
4 /// @title ERC165Interface
5 /// @dev https://eips.ethereum.org/EIPS/eip-165
6 interface ERC165Interface {
7     /// @notice Query if a contract implements an interface
8     /// @param interfaceId The interface identifier, as specified in ERC-165
9     /// @dev Interface identification is specified in ERC-165. This function
10     ///      uses less than 30,000 gas.
11     function supportsInterface(bytes4 interfaceId) external view returns (bool);
12 }
13 
14 
15 /// @title Shared constants used throughout the Cheeze Wizards contracts
16 contract WizardConstants {
17     // Wizards normally have their affinity set when they are first created,
18     // but for example Exclusive Wizards can be created with no set affinity.
19     // In this case the affinity can be set by the owner.
20     uint8 internal constant ELEMENT_NOTSET = 0; //000
21     // A neutral Wizard has no particular strength or weakness with specific
22     // elements.
23     uint8 internal constant ELEMENT_NEUTRAL = 1; //001
24     // The fire, water and wind elements are used both to reflect an affinity
25     // of Elemental Wizards for a specific element, and as the moves a
26     // Wizard can make during a duel.
27     // Note that if these values change then `moveMask` and `moveDelta` in
28     // ThreeAffinityDuelResolver would need to be updated accordingly.
29     uint8 internal constant ELEMENT_FIRE = 2; //010
30     uint8 internal constant ELEMENT_WATER = 3; //011
31     uint8 internal constant ELEMENT_WIND = 4; //100
32     uint8 internal constant MAX_ELEMENT = ELEMENT_WIND;
33 }
34 
35 
36 
37 
38 contract ERC1654 {
39 
40     /// @dev bytes4(keccak256("isValidSignature(bytes32,bytes)")
41     bytes4 public constant ERC1654_VALIDSIGNATURE = 0x1626ba7e;
42 
43     /// @dev Should return whether the signature provided is valid for the provided data
44     /// @param hash 32-byte hash of the data that is signed
45     /// @param _signature Signature byte array associated with _data
46     ///  MUST return the bytes4 magic value 0x1626ba7e when function passes.
47     ///  MUST NOT modify state (using STATICCALL for solc < 0.5, view modifier for solc > 0.5)
48     ///  MUST allow external calls
49     function isValidSignature(
50         bytes32 hash,
51         bytes calldata _signature)
52         external
53         view
54         returns (bytes4);
55 }
56 
57 
58 
59 
60 
61 
62 
63 
64 /**
65  * @title IERC165
66  * @dev https://eips.ethereum.org/EIPS/eip-165
67  */
68 interface IERC165 {
69     /**
70      * @notice Query if a contract implements an interface
71      * @param interfaceId The interface identifier, as specified in ERC-165
72      * @dev Interface identification is specified in ERC-165. This function
73      * uses less than 30,000 gas.
74      */
75     function supportsInterface(bytes4 interfaceId) external view returns (bool);
76 }
77 
78 
79 /**
80  * @title ERC721 Non-Fungible Token Standard basic interface
81  * @dev see https://eips.ethereum.org/EIPS/eip-721
82  */
83 contract IERC721 is IERC165 {
84     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
85     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
86     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
87 
88     function balanceOf(address owner) public view returns (uint256 balance);
89     function ownerOf(uint256 tokenId) public view returns (address owner);
90 
91     function approve(address to, uint256 tokenId) public;
92     function getApproved(uint256 tokenId) public view returns (address operator);
93 
94     function setApprovalForAll(address operator, bool _approved) public;
95     function isApprovedForAll(address owner, address operator) public view returns (bool);
96 
97     function transferFrom(address from, address to, uint256 tokenId) public;
98     function safeTransferFrom(address from, address to, uint256 tokenId) public;
99 
100     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
101 }
102 
103 
104 contract WizardGuildInterfaceId {
105     bytes4 internal constant _INTERFACE_ID_WIZARDGUILD = 0x41d4d437;
106 }
107 
108 /// @title The public interface of the Wizard Guild
109 /// @notice The methods listed in this interface (including the inherited ERC-721 interface),
110 ///         make up the public interface of the Wizard Guild contract. Any contracts that wish
111 ///         to make use of Cheeze Wizard NFTs (such as Cheeze Wizards Tournaments!) should use
112 ///         these methods to ensure they are working correctly with the base NFTs.
113 contract WizardGuildInterface is IERC721, WizardGuildInterfaceId {
114 
115     /// @notice Returns the information associated with the given Wizard
116     ///         owner - The address that owns this Wizard
117     ///         innatePower - The innate power level of this Wizard, set when minted and entirely
118     ///               immutable
119     ///         affinity - The Elemental Affinity of this Wizard. For most Wizards, this is set
120     ///               when they are minted, but some exclusive Wizards are minted with an affinity
121     ///               of 0 (ELEMENT_NOTSET). A Wizard with an NOTSET affinity should NOT be able
122     ///               to participate in Tournaments. Once the affinity of a Wizard is set to a non-zero
123     ///               value, it can never be changed again.
124     ///         metadata - A 256-bit hash of the Wizard's metadata, which is stored off chain. This
125     ///               contract doesn't specify format of this hash, nor the off-chain storage mechanism
126     ///               but, let's be honest, it's probably an IPFS SHA-256 hash.
127     ///
128     ///         NOTE: Series zero Wizards have one of four Affinities:  Neutral (1), Fire (2), Water (3)
129     ///               or Air (4, sometimes called "Wind" in the code). Future Wizard Series may have
130     ///               additional Affinities, and clients of this API should be prepared for that
131     ///               eventuality.
132     function getWizard(uint256 id) external view returns (address owner, uint88 innatePower, uint8 affinity, bytes32 metadata);
133 
134     /// @notice Sets the affinity for a Wizard that doesn't already have its elemental affinity chosen.
135     ///         Only usable for Exclusive Wizards (all non-Exclusives must have their affinity chosen when
136     ///         conjured.) Even Exclusives can't change their affinity once it's been chosen.
137     ///
138     ///         NOTE: This function can only be called by the series minter, and (therefore) only while the
139     ///         series is open. A Wizard that has no affinity when a series is closed will NEVER have an Affinity.
140     ///         BTW- This implies that a minter is responsible for either never minting ELEMENT_NOTSET
141     ///         Wizards, or having some public mechanism for a Wizard owner to set the Affinity after minting.
142     /// @param wizardId The id of the wizard
143     /// @param newAffinity The new affinity of the wizard
144     function setAffinity(uint256 wizardId, uint8 newAffinity) external;
145 
146     /// @notice A function to be called that conjures a whole bunch of Wizards at once! You know how
147     ///         there's "a pride of lions", "a murder of crows", and "a parliament of owls"? Well, with this
148     ///         here function you can conjure yourself "a stench of Cheeze Wizards"!
149     ///
150     ///         Unsurprisingly, this method can only be called by the registered minter for a Series.
151     /// @param powers the power level of each wizard
152     /// @param affinities the Elements of the wizards to create
153     /// @param owner the address that will own the newly created Wizards
154     function mintWizards(
155         uint88[] calldata powers,
156         uint8[] calldata affinities,
157         address owner
158         ) external returns (uint256[] memory wizardIds);
159 
160     /// @notice A function to be called that conjures a series of Wizards in the reserved ID range.
161     /// @param wizardIds the ID values to use for each Wizard, must be in the reserved range of the current Series
162     /// @param affinities the Elements of the wizards to create
163     /// @param powers the power level of each wizard
164     /// @param owner the address that will own the newly created Wizards
165     function mintReservedWizards(
166         uint256[] calldata wizardIds,
167         uint88[] calldata powers,
168         uint8[] calldata affinities,
169         address owner
170         ) external;
171 
172     /// @notice Sets the metadata values for a list of Wizards. The metadata for a Wizard can only be set once,
173     ///         can only be set by the COO or Minter, and can only be set while the Series is still open. Once
174     ///         a Series is closed, the metadata is locked forever!
175     /// @param wizardIds the ID values of the Wizards to apply metadata changes to.
176     /// @param metadata the raw metadata values for each Wizard. This contract does not define how metadata
177     ///         should be interpreted, but it is likely to be a 256-bit hash of a complete metadata package
178     ///         accessible via IPFS or similar.
179     function setMetadata(uint256[] calldata wizardIds, bytes32[] calldata metadata) external;
180 
181     /// @notice Returns true if the given "spender" address is allowed to manipulate the given token
182     ///         (either because it is the owner of that token, has been given approval to manage that token)
183     function isApprovedOrOwner(address spender, uint256 tokenId) external view returns (bool);
184 
185     /// @notice Verifies that a given signature represents authority to control the given Wizard ID,
186     ///         reverting otherwise. It handles three cases:
187     ///             - The simplest case: The signature was signed with the private key associated with
188     ///               an external address that is the owner of this Wizard.
189     ///             - The signature was generated with the private key associated with an external address
190     ///               that is "approved" for working with this Wizard ID. (See the Wizard Guild and/or
191     ///               the ERC-721 spec for more information on "approval".)
192     ///             - The owner or approval address (as in cases one or two) is a smart contract
193     ///               that conforms to ERC-1654, and accepts the given signature as being valid
194     ///               using its own internal logic.
195     ///
196     ///        NOTE: This function DOES NOT accept a signature created by an address that was given "operator
197     ///               status" (as granted by ERC-721's setApprovalForAll() functionality). Doing so is
198     ///               considered an extreme edge case that can be worked around where necessary.
199     /// @param wizardId The Wizard ID whose control is in question
200     /// @param hash The message hash we are authenticating against
201     /// @param sig the signature data; can be longer than 65 bytes for ERC-1654
202     function verifySignature(uint256 wizardId, bytes32 hash, bytes calldata sig) external view;
203 
204     /// @notice Convenience function that verifies signatures for two wizards using equivalent logic to
205     ///         verifySignature(). Included to save on cross-contract calls in the common case where we
206     ///         are verifying the signatures of two Wizards who wish to enter into a Duel.
207     /// @param wizardId1 The first Wizard ID whose control is in question
208     /// @param wizardId2 The second Wizard ID whose control is in question
209     /// @param hash1 The message hash we are authenticating against for the first Wizard
210     /// @param hash2 The message hash we are authenticating against for the first Wizard
211     /// @param sig1 the signature data corresponding to the first Wizard; can be longer than 65 bytes for ERC-1654
212     /// @param sig2 the signature data corresponding to the second Wizard; can be longer than 65 bytes for ERC-1654
213     function verifySignatures(
214         uint256 wizardId1,
215         uint256 wizardId2,
216         bytes32 hash1,
217         bytes32 hash2,
218         bytes calldata sig1,
219         bytes calldata sig2) external view;
220 }
221 
222 
223 
224 
225 
226 // We use a contract and multiple inheritance to expose this constant.
227 // It's the best that Solidity offers at the moment.
228 contract DuelResolverInterfaceId {
229     /// @notice The erc165 interface ID
230     bytes4 internal constant _INTERFACE_ID_DUELRESOLVER = 0x41fc4f1e;
231 }
232 
233 /// @notice An interface for contracts that resolve duels between Cheeze Wizards. Abstracting this out
234 ///         into its own interface and instance allows for different tournaments to use
235 ///         different duel mechanics while keeping the core tournament logic unchanged.
236 contract DuelResolverInterface is DuelResolverInterfaceId, ERC165Interface {
237     /// @notice Indicates if the given move set is a valid input for this duel resolver.
238     ///         It's important that this method is called before a move set is committed to
239     ///         because resolveDuel() will abort if it the moves are invalid, making it
240     ///         impossible to resolve the duel.
241     function isValidMoveSet(bytes32 moveSet) public pure returns(bool);
242 
243     /// @notice Indicates that a particular affinity is a valid input for this duel resolver.
244     ///         Should be called before a Wizard is entered into a tournament. As a rule, Wizard
245     ///         Affinities don't change, so there's not point in checking for each duel.
246     ///
247     /// @dev    This method should _only_ return false for affinities that are
248     ///         known to cause problems with your duel resolver. If your resolveDuel() function
249     ///         can safely work with any affinity value (even if it just ignores the values that
250     ///         it doesn't know about), it should return true.
251     function isValidAffinity(uint256 affinity) external pure returns(bool);
252 
253     /// @notice Resolves the duel between two Cheeze Wizards given their chosen move sets, their
254     ///         powers, and each Wizard's affinity. It is the responsibility of the Tournament contract
255     ///         to ensure that ALL Wizards in a Tournament have an affinity value that is compatible with
256     ///         the logic of this DuelResolver. It must also ensure that both move sets are valid before
257     ///         those move sets are locked in, otherwise the duel can never be resolved!
258     ///
259     ///         Returns the amount of power to be transferred from the first Wizard to the second Wizard
260     ///         (which will be a negative number if the second Wizard wins the duel), zero in the case of
261     ///         a tie.
262     /// @param moveSet1 The move set for the first Wizard. The interpretation and therefore valid
263     ///                 values for this are determined by the individual duel resolver.
264     /// @param moveSet2 The move set for the second Wizard.
265     function resolveDuel(
266         bytes32 moveSet1,
267         bytes32 moveSet2,
268         uint256 power1,
269         uint256 power2,
270         uint256 affinity1,
271         uint256 affinity2)
272         public pure returns(int256);
273 }
274 
275 
276 
277 
278 
279 /// @title Contract that manages addresses and access modifiers for certain operations.
280 /// @author Dapper Labs Inc. (https://www.dapperlabs.com)
281 contract AccessControl {
282 
283     /// @dev The address of the master administrator account that has the power to
284     ///      update itself and all of the other administrator addresses.
285     ///      The CEO account is not expected to be used regularly, and is intended to
286     ///      be stored offline (i.e. a hardware device kept in a safe).
287     address public ceoAddress;
288 
289     /// @dev The address of the "day-to-day" operator of various privileged
290     ///      functions inside the smart contract. Although the CEO has the power
291     ///      to replace the COO, the CEO address doesn't actually have the power
292     ///      to do "COO-only" operations. This is to discourage the regular use
293     ///      of the CEO account.
294     address public cooAddress;
295 
296     /// @dev The address that is allowed to move money around. Kept separate from
297     ///      the COO because the COO address typically lives on an internet-connected
298     ///      computer.
299     address payable public cfoAddress;
300 
301     // Events to indicate when access control role addresses are updated.
302     event CEOTransferred(address previousCeo, address newCeo);
303     event COOTransferred(address previousCoo, address newCoo);
304     event CFOTransferred(address previousCfo, address newCfo);
305 
306     /// @dev The AccessControl constructor sets the `ceoAddress` to the sender account. Also
307     ///      initializes the COO and CFO to the passed values (CFO is optional and can be address(0)).
308     /// @param newCooAddress The initial COO address to set
309     /// @param newCfoAddress The initial CFO to set (optional)
310     constructor(address newCooAddress, address payable newCfoAddress) public {
311         _setCeo(msg.sender);
312         setCoo(newCooAddress);
313 
314         if (newCfoAddress != address(0)) {
315             setCfo(newCfoAddress);
316         }
317     }
318 
319     /// @notice Access modifier for CEO-only functionality
320     modifier onlyCEO() {
321         require(msg.sender == ceoAddress, "Only CEO");
322         _;
323     }
324 
325     /// @notice Access modifier for COO-only functionality
326     modifier onlyCOO() {
327         require(msg.sender == cooAddress, "Only COO");
328         _;
329     }
330 
331     /// @notice Access modifier for CFO-only functionality
332     modifier onlyCFO() {
333         require(msg.sender == cfoAddress, "Only CFO");
334         _;
335     }
336 
337     function checkControlAddress(address newController) internal view {
338         require(newController != address(0) && newController != ceoAddress, "Invalid CEO address");
339     }
340 
341     /// @notice Assigns a new address to act as the CEO. Only available to the current CEO.
342     /// @param newCeo The address of the new CEO
343     function setCeo(address newCeo) external onlyCEO {
344         checkControlAddress(newCeo);
345         _setCeo(newCeo);
346     }
347 
348     /// @dev An internal utility function that updates the CEO variable and emits the
349     ///      transfer event. Used from both the public setCeo function and the constructor.
350     function _setCeo(address newCeo) private {
351         emit CEOTransferred(ceoAddress, newCeo);
352         ceoAddress = newCeo;
353     }
354 
355     /// @notice Assigns a new address to act as the COO. Only available to the current CEO.
356     /// @param newCoo The address of the new COO
357     function setCoo(address newCoo) public onlyCEO {
358         checkControlAddress(newCoo);
359         emit COOTransferred(cooAddress, newCoo);
360         cooAddress = newCoo;
361     }
362 
363     /// @notice Assigns a new address to act as the CFO. Only available to the current CEO.
364     /// @param newCfo The address of the new CFO
365     function setCfo(address payable newCfo) public onlyCEO {
366         checkControlAddress(newCfo);
367         emit CFOTransferred(cfoAddress, newCfo);
368         cfoAddress = newCfo;
369     }
370 }
371 
372 
373 
374 /// @title TournamentTimeAbstract - abstract contract for controlling time for Cheeze Wizards.
375 /// @notice Time is important in Cheeze Wizards, and there are a variety of different ways of
376 /// slicing up time that we should clarify here at the outset:
377 ///
378 ///  1. The tournament is split into three major PHASES:
379 ///      - The first Phase is the Admission Phase. During this time, Wizards can be entered into
380 ///        the tournament with their admission fee, and will be given a power level commensurate
381 ///        with that fee. Their power level can not exceed the base power level encoded into the NFT.
382 ///        No duels take place during this phase.
383 ///      - The second Phase is the Revival Phase. During this time, new Wizards can enter the tournament,
384 ///        eliminated Wizards can be revived, and the dueling commences!
385 ///      - The third phase is the Elimination Phase. It's all duels, all the time. No new Wizards can enter,
386 ///        all eliminations are _final_. It's at this time that the Blue Mold begins to grow, forcing
387 ///        Wizards to engage in battle or be summarily eliminated.
388 ///      - Collectively the phases where Wizards can enter the tournament (i.e. Admission Phase and
389 ///        Revival Phase) are the Enter Phases.
390 ///      - Collectively the phases where Wizards can duel (i.e. Revival Phase and Elimination Phase)
391 ///        are the Battle Phases.
392 ///
393 ///  2. During the Battle Phases, where Wizards can duel, we break time up into a series of repeating WINDOWS:
394 ///      - The first Window is the Ascension Window. During the Elimination Phase, Ascension Windows are critically
395 ///        important: Any Wizard which is in danger of being eliminated by the next Blue Mold power increase
396 ///        can attempt to Ascend during this time. If multiple Wizards attempt to Ascend, they are paired
397 ///        off into Duels to Exhaustion: A one-time, winner-takes-all battle that sees one Wizard triumphant
398 ///        and the other Wizard eliminated from the tournament. If an odd number of Wizards attempt to Ascend,
399 ///        the last Wizard to attempt to Ascend remains in the Ascension Chamber where they _must_ accept the
400 ///        first duel challenge offered to them in the following Fight Window. During the Revival Phase, the time
401 ///        slice which would be an Ascension Windows is counted as more or less nothing.
402 ///      - The second Window is the Fight Window. This is where all the fun happens! Wizards challenge Wizards,
403 ///        and their duels result in power transfers. But beware! If your power level drops to zero (or below
404 ///        the Blue Mold level), you will be eliminated during the Elimination Phase!
405 ///      - The third Window is the Resolution Window. This is a period of time after the Fight Window equal
406 ///        to the maximum length of a duel. During the Resolution Window, the only action that most Wizards
407 ///        can take is to reveal moves for duels initiated during the Fight Window. However, this is also the
408 ///        time slice during which a successfully Ascending Wizard is able to power up!
409 ///      - The fourth Window is the Culling Window. During the Elimination Phase, the Culling Window is used
410 ///        to permanently remove all Wizards who have been reduced to zero power (are tired), or who have fallen below
411 ///        the power level of the inexorable Blue Mold.
412 ///
413 ///      Note that since Wizards can't ascend or be culled during Revival Phase, the Ascension and Culling windows
414 ///        during Revival Phase don't have any utility/meaning until the Revival Phase is over.
415 ///
416 /// 3. A complete sequence of four Windows is called a SESSION. During the official Cheeze Wizard tournament,
417 ///    we will set the Session length to as close to 8 hours as possible (while still using blocks as time
418 ///    keeping mechanism), ensuring three Sessions per day. Other Tournaments may have very different time limits.
419 ///
420 /// A Handy Diagram!
421 ///        ...--|--asc.--|------fight------|--res--|-----cull------|--asc.--|------fight------|--res--|-----cull--...
422 ///        .....|^^^^^^^^^^^^^^^^^^ 1 session ^^^^^^^^^^^^^^^^^^^^^|...
423 contract TournamentTimeAbstract is AccessControl {
424 
425     event Paused(uint256 pauseEndedBlock);
426 
427     /// @dev We pack these parameters into a struct to save storage costs.
428     struct TournamentTimeParameters {
429         // The block height at which the tournament begins. Starts in the Admission Phase.
430         uint48 tournamentStartBlock;
431 
432         // The block height after which the pause will end.
433         uint48 pauseEndedBlock;
434 
435         // The duration (in blocks) of the Admission Phase.
436         uint32 admissionDuration;
437 
438         // The duration (in blocks) of the Revival Phase; the Elimination Phase has no time limit.
439         uint32 revivalDuration;
440 
441         // The maximum duration (in blocks) between the second commit in a normal duel and when it times out.
442         // Ascension Duels always time out at the end of the Resolution Phase following the Fight or Ascension
443         // Window in which they were initiated.
444         uint32 duelTimeoutDuration;
445     }
446 
447     TournamentTimeParameters internal tournamentTimeParameters;
448 
449     // Returns all the time related variables that are stored internally.
450     function getTimeParameters() external view returns (
451         uint256 tournamentStartBlock,
452         uint256 pauseEndedBlock,
453         uint256 admissionDuration,
454         uint256 revivalDuration,
455         uint256 duelTimeoutDuration,
456         uint256 ascensionWindowStart,
457         uint256 ascensionWindowDuration,
458         uint256 fightWindowStart,
459         uint256 fightWindowDuration,
460         uint256 resolutionWindowStart,
461         uint256 resolutionWindowDuration,
462         uint256 cullingWindowStart,
463         uint256 cullingWindowDuration) {
464         return (
465             uint256(tournamentTimeParameters.tournamentStartBlock),
466             uint256(tournamentTimeParameters.pauseEndedBlock),
467             uint256(tournamentTimeParameters.admissionDuration),
468             uint256(tournamentTimeParameters.revivalDuration),
469             uint256(tournamentTimeParameters.duelTimeoutDuration),
470             uint256(ascensionWindowParameters.firstWindowStartBlock),
471             uint256(ascensionWindowParameters.windowDuration),
472             uint256(fightWindowParameters.firstWindowStartBlock),
473             uint256(fightWindowParameters.windowDuration),
474             uint256(resolutionWindowParameters.firstWindowStartBlock),
475             uint256(resolutionWindowParameters.windowDuration),
476             uint256(cullingWindowParameters.firstWindowStartBlock),
477             uint256(cullingWindowParameters.windowDuration));
478     }
479 
480     // This probably looks insane, but there is a method to our madness!
481     //
482     // Checking which window we are in is something that happens A LOT, especially during duels.
483     // The naive way of checking this is gas intensive, as it either involves data stored in
484     // multiple storage slots, or by performing a number of computations for each check. By caching all
485     // of the data needed to compute if we're in a window in a single struct means that
486     // we can do the check cost effectively using a single SLOAD. Unfortunately, different windows need different
487     // data, so we end up storing A LOT of duplicate data. This is a classic example of
488     // optimizing for one part of the code (fast checking if we're in a window) at the expense of another
489     // part of the code (overall storage footprint and deployment gas cost). In
490     // the common case this is a significant improvement in terms of gas usage, over the
491     // course of an entire Tournament.
492 
493     // The data needed to check if we are in a given Window
494     struct WindowParameters {
495         // The block number that the first window of this type begins
496         uint48 firstWindowStartBlock;
497 
498         // A copy of the pause ending block, copied into this storage slot to save gas
499         uint48 pauseEndedBlock;
500 
501         // The length of an entire "session" (see above for definitions), ALL windows
502         // repeat with a period of one session.
503         uint32 sessionDuration;
504 
505         // The duration of this window
506         uint32 windowDuration;
507     }
508 
509     WindowParameters internal ascensionWindowParameters;
510     WindowParameters internal fightWindowParameters;
511     WindowParameters internal resolutionWindowParameters;
512     WindowParameters internal cullingWindowParameters;
513 
514 
515     // Another struct, with another copy of some of the same parameters as above. This time we are
516     // collecting everything related to computing the power of the Blue Mold into one place.
517     struct BlueMoldParameters {
518         uint48 blueMoldStartBlock;
519         uint32 sessionDuration;
520         uint32 moldDoublingDuration;
521         uint88 blueMoldBasePower;
522     }
523 
524     BlueMoldParameters internal blueMoldParameters;
525 
526     function getBlueMoldParameters() external view returns (uint256, uint256, uint256, uint256) {
527         return (
528             blueMoldParameters.blueMoldStartBlock,
529             blueMoldParameters.sessionDuration,
530             blueMoldParameters.moldDoublingDuration,
531             blueMoldParameters.blueMoldBasePower
532         );
533     }
534 
535     constructor(
536         address _cooAddress,
537         uint40 tournamentStartBlock,
538         uint32 admissionDuration,
539         uint32 revivalDuration,
540         uint24 ascensionDuration,
541         uint24 fightDuration,
542         uint24 cullingDuration,
543         uint24 duelTimeoutDuration,
544         uint88 blueMoldBasePower,
545         uint24 sessionsBetweenMoldDoubling
546     )
547     internal AccessControl(_cooAddress, address(0)) {
548         require(tournamentStartBlock > block.number, "Invalid start time");
549 
550         // Even if you want to have a very fast Tournament, a timeout of fewer than 20 blocks
551         // is asking for trouble. We would always recommend a value >100.
552         require(duelTimeoutDuration >= 20, "Timeout too short");
553 
554         // Rather than checking all of these inputs against zero, we just multiply them all together and exploit
555         // the fact that if any of them are zero, their product will also be zero.
556         // Theoretically, you can find five non-zero numbers that multiply to zero because of overflow.
557         // However, at least one of those numbers would need to be >50 bits long which is not the case here.
558         // Note: BasicTournament.revive() depends on blueMoldBasePower always being
559         // positive, so if this constraint somehow ever changes, that function
560         // will need to be verified for correctness.
561         // sessionsBetweenMoldDoubling must be > 0 so that the mold doubles!
562         require(
563             (uint256(admissionDuration) *
564             uint256(revivalDuration) *
565             uint256(ascensionDuration) *
566             uint256(fightDuration) *
567             uint256(cullingDuration) *
568             uint256(blueMoldBasePower) *
569             uint256(sessionsBetweenMoldDoubling)) != 0,
570             "Constructor arguments must be non-0");
571 
572         // The Fight Window needs to be at least twice as long as the Duel Timeout. Necessary to
573         // ensure there is enough time to challenge an Ascending Wizard.
574         require(fightDuration >= uint256(duelTimeoutDuration) * 2, "Fight window too short");
575 
576         // Make sure the Culling Window is at least as big as a Fight Window
577         require(cullingDuration >= duelTimeoutDuration, "Culling window too short");
578         // The sum of 4 uint24 values is always less than uint32. So it won't overflow.
579         uint32 sessionDuration = ascensionDuration + fightDuration + duelTimeoutDuration + cullingDuration;
580 
581         // Make sure that the end of the Revival Phase coincides with the start of a
582         // new session. Many of our calculations depend on this fact!
583         require((revivalDuration % sessionDuration) == 0, "Revival/Session length mismatch");
584 
585         tournamentTimeParameters = TournamentTimeParameters({
586             tournamentStartBlock: uint48(tournamentStartBlock),
587             pauseEndedBlock: uint48(0),
588             admissionDuration: admissionDuration,
589             revivalDuration: revivalDuration,
590             duelTimeoutDuration: duelTimeoutDuration
591         });
592 
593         // tournamentStartBlock is 40 bits, admissionDuration is 32 bits,
594         // so firstSessionStartBlock is less than 41 bits, which protects the calculations
595         // of the firstWindowStartBlock as below from overflow.
596         uint256 firstSessionStartBlock = uint256(tournamentStartBlock) + uint256(admissionDuration);
597 
598         // NOTE: ascension windows don't begin until after the Revival Phase is over
599         ascensionWindowParameters = WindowParameters({
600             firstWindowStartBlock: uint48(firstSessionStartBlock + revivalDuration),
601             pauseEndedBlock: uint48(0),
602             sessionDuration: sessionDuration,
603             windowDuration: ascensionDuration
604         });
605 
606         fightWindowParameters = WindowParameters({
607             firstWindowStartBlock: uint48(firstSessionStartBlock + ascensionDuration),
608             pauseEndedBlock: uint48(0),
609             sessionDuration: sessionDuration,
610             windowDuration: fightDuration
611         });
612 
613         resolutionWindowParameters = WindowParameters({
614             firstWindowStartBlock: uint48(firstSessionStartBlock + ascensionDuration + fightDuration),
615             pauseEndedBlock: uint48(0),
616             sessionDuration: sessionDuration,
617             windowDuration: duelTimeoutDuration
618         });
619 
620         cullingWindowParameters = WindowParameters({
621             // NOTE: The first Culling Window only occurs after the first Revival Phase is over.
622             firstWindowStartBlock: uint48(firstSessionStartBlock + revivalDuration + ascensionDuration + fightDuration + duelTimeoutDuration),
623             pauseEndedBlock: uint48(0),
624             sessionDuration: sessionDuration,
625             windowDuration: cullingDuration
626         });
627 
628         blueMoldParameters = BlueMoldParameters({
629             blueMoldStartBlock: uint48(firstSessionStartBlock + revivalDuration),
630             sessionDuration: sessionDuration,
631             // uint24 * uint25
632             moldDoublingDuration: uint32(sessionsBetweenMoldDoubling) * uint32(sessionDuration),
633             blueMoldBasePower: blueMoldBasePower
634         });
635     }
636 
637     /// @notice Returns true if the current block is in the Revival Phase
638     function _isRevivalPhase() internal view returns (bool) {
639         // Copying the structure into memory once saves gas. Each access to a member variable
640         // counts as a new read!
641         TournamentTimeParameters memory localParams = tournamentTimeParameters;
642 
643         if (block.number < localParams.pauseEndedBlock) {
644             return false;
645         }
646 
647         return ((block.number >= localParams.tournamentStartBlock + localParams.admissionDuration) &&
648             (block.number < localParams.tournamentStartBlock + localParams.admissionDuration + localParams.revivalDuration));
649     }
650 
651     /// @notice Returns true if the current block is in the Elimination Phase
652     function _isEliminationPhase() internal view returns (bool) {
653         // Copying the structure into memory once saves gas. Each access to a member variable
654         // counts as a new read!
655         TournamentTimeParameters memory localParams = tournamentTimeParameters;
656 
657         if (block.number < localParams.pauseEndedBlock) {
658             return false;
659         }
660 
661         return (block.number >= localParams.tournamentStartBlock + localParams.admissionDuration + localParams.revivalDuration);
662     }
663 
664     /// @dev Returns true if the current block is a valid time to enter a Wizard into the Tournament. As in,
665     ///      it's either the Admission Phase or the Revival Phase.
666     function _isEnterPhase() internal view returns (bool) {
667         // Copying the structure into memory once saves gas. Each access to a member variable
668         // counts as a new read!
669         TournamentTimeParameters memory localParams = tournamentTimeParameters;
670 
671         if (block.number < localParams.pauseEndedBlock) {
672             return false;
673         }
674 
675         return ((block.number >= localParams.tournamentStartBlock) &&
676             (block.number < localParams.tournamentStartBlock + localParams.admissionDuration + localParams.revivalDuration));
677     }
678 
679     // An internal convenience function that checks to see if we are currently in the Window
680     // defined by the WindowParameters struct passed as an argument.
681     function _isInWindow(WindowParameters memory localParams) internal view returns (bool) {
682         // We are never "in a window" if the contract is paused
683         if (block.number < localParams.pauseEndedBlock) {
684             return false;
685         }
686 
687         // If we are before the first window of this type, we are obviously NOT in this window!
688         if (block.number < localParams.firstWindowStartBlock) {
689             return false;
690         }
691 
692         // Use modulus to figure out how far we are past the beginning of the most recent window
693         // of this type
694         uint256 windowOffset = (block.number - localParams.firstWindowStartBlock) % localParams.sessionDuration;
695 
696         // If we are in the window, we will be within duration of the start of the most recent window
697         return windowOffset < localParams.windowDuration;
698     }
699 
700     /// @notice Requires the current block is in an Ascension Window
701     function checkAscensionWindow() internal view {
702         require(_isInWindow(ascensionWindowParameters), "Only during Ascension Window");
703     }
704 
705     /// @notice Requires the current block is in a Fight Window
706     function checkFightWindow() internal view {
707         require(_isInWindow(fightWindowParameters), "Only during Fight Window");
708     }
709 
710     /// @notice Requires the current block is in a Resolution Window
711     function checkResolutionWindow() internal view {
712         require(_isInWindow(resolutionWindowParameters), "Only during Resolution Window");
713     }
714 
715     /// @notice Requires the current block is in a Culling Window
716     function checkCullingWindow() internal view {
717         require(_isInWindow(cullingWindowParameters), "Only during Culling Window");
718     }
719 
720     /// @notice Returns the block number when an Ascension Battle initiated in the current block
721     ///         should time out. This is always the end of the upcoming Resolution Window.
722     ///
723     ///         NOTE: This function is only designed to be called during an Ascension or
724     ///               Fight Window, after we have entered the Elimination Phase.
725     ///               Behaviour at other times is not defined.
726     function _ascensionDuelTimeout() internal view returns (uint256) {
727         WindowParameters memory localParams = cullingWindowParameters;
728 
729         // The end of the next Resolution Window is the same as the start of the next
730         // Culling Window.
731 
732         // First we count the number of COMPLETE sessions that will have passed between
733         // the start of the first Culling Window and the block one full session duration
734         // past the current block height. We are looking into the future to ensure that
735         // we with any negative values.
736         uint256 sessionCount = (block.number + localParams.sessionDuration -
737             localParams.firstWindowStartBlock) / localParams.sessionDuration;
738 
739         return localParams.firstWindowStartBlock + sessionCount * localParams.sessionDuration;
740     }
741 
742     /// @notice Returns true if there is at least one full duel timeout duration between
743     ///         now and the end of the current Fight Window. To be used to ensure that
744     ///         someone challenging an Ascending Wizard is given the Ascending Wizard
745     ///         enough time to respond.
746     ///
747     ///         NOTE: This function is only designed to be called during a Fight Window,
748     ///               after we have entered the Elimination Phase.
749     ///               Behaviour at other times is not defined.
750     function canChallengeAscendingWizard() internal view returns (bool) {
751         // We start by computing the start on the next Resolution Window, using the same
752         // logic as in _ascensionDuelTimeout().
753         WindowParameters memory localParams = resolutionWindowParameters;
754 
755         uint256 sessionCount = (block.number + localParams.sessionDuration -
756             localParams.firstWindowStartBlock) / localParams.sessionDuration;
757 
758         uint256 resolutionWindowStart = localParams.firstWindowStartBlock + sessionCount * localParams.sessionDuration;
759 
760         // Remember that the Resolution Window has the same duration as the duel time out
761         return resolutionWindowStart - localParams.windowDuration > block.number;
762     }
763 
764     /// @notice Returns the power level of the Blue Mold at the current block.
765     function _blueMoldPower() internal view returns (uint256) {
766         BlueMoldParameters memory localParams = blueMoldParameters;
767 
768         if (block.number <= localParams.blueMoldStartBlock) {
769             return localParams.blueMoldBasePower;
770         } else {
771             uint256 moldDoublings = (block.number - localParams.blueMoldStartBlock) / localParams.moldDoublingDuration;
772 
773             // In the initialization function, we cap the maximum Blue Mold base power to a value under 1 << 88
774             // (which is the maximum Wizard power level, and would result in all Wizards INSTANTLY being moldy!)
775             // Here, we cap the number of "mold doublings" to 88. This ensures that the mold power
776             // can't overflow, while also ensuring that, even if blueMoldBasePower starts at 1
777             // that it will exceed the max power of any Wizard. This guarantees that the tournament
778             // will ALWAYS terminate.
779             if (moldDoublings > 88) {
780                 moldDoublings = 88;
781             }
782 
783             return localParams.blueMoldBasePower << moldDoublings;
784         }
785     }
786 
787 
788     modifier duringEnterPhase() {
789         require(_isEnterPhase(), "Only during Enter Phases");
790         _;
791     }
792 
793     modifier duringRevivalPhase() {
794         require(_isRevivalPhase(), "Only during Revival Phases");
795         _;
796     }
797 
798     modifier duringAscensionWindow() {
799         checkAscensionWindow();
800         _;
801     }
802 
803     modifier duringFightWindow() {
804         checkFightWindow();
805         _;
806     }
807 
808     modifier duringResolutionWindow() {
809         checkResolutionWindow();
810         _;
811     }
812 
813     modifier duringCullingWindow() {
814         checkCullingWindow();
815         _;
816     }
817 
818     /// @notice Pauses the Tournament, starting immediately, for a duration specified in blocks.
819     /// This function can be called if the Tournament is already paused, but only to extend the pause
820     /// period until at most `(block.number + sessionDuration)`. In other words, the Tournament can't be
821     /// paused indefinitely unless this function is called periodically, at least once every session length.
822     ///
823     /// NOTE: This function is reasonably expensive and inefficient because it has to update so many storage
824     ///       variables. This is done intentionally because pausing should be rare and it's far more important
825     ///       to optimize the hot paths (which are the modifiers above).
826     ///
827     /// @param pauseDuration the number of blocks to pause for. CAN NOT exceed the length of one Session.
828     function pause(uint256 pauseDuration) external onlyCOO {
829         uint256 sessionDuration = ascensionWindowParameters.sessionDuration;
830 
831         // Require all pauses be less than one session in length
832         require(pauseDuration <= sessionDuration, "Invalid pause duration");
833 
834         // Figure out when our pause will be done
835         uint48 newPauseEndedBlock = uint48(block.number + pauseDuration);
836         uint48 tournamentExtensionAmount = uint48(pauseDuration);
837 
838         if (block.number < tournamentTimeParameters.pauseEndedBlock) {
839             // If we are already paused, we need to adjust the tournamentExtension
840             // amount to reflect that we are only extending the pause amount, not
841             // setting it anew
842             require(tournamentTimeParameters.pauseEndedBlock < newPauseEndedBlock);
843 
844             tournamentExtensionAmount = uint48(newPauseEndedBlock - tournamentTimeParameters.pauseEndedBlock);
845         }
846 
847         // We now need to update all of the various structures where we cached time information
848         // to make sure they reflect the new information
849         tournamentTimeParameters.tournamentStartBlock += tournamentExtensionAmount;
850         tournamentTimeParameters.pauseEndedBlock = newPauseEndedBlock;
851 
852         ascensionWindowParameters.firstWindowStartBlock += tournamentExtensionAmount;
853         ascensionWindowParameters.pauseEndedBlock = newPauseEndedBlock;
854 
855         fightWindowParameters.firstWindowStartBlock += tournamentExtensionAmount;
856         fightWindowParameters.pauseEndedBlock = newPauseEndedBlock;
857 
858         resolutionWindowParameters.firstWindowStartBlock += tournamentExtensionAmount;
859         resolutionWindowParameters.pauseEndedBlock = newPauseEndedBlock;
860 
861         cullingWindowParameters.firstWindowStartBlock += tournamentExtensionAmount;
862         cullingWindowParameters.pauseEndedBlock = newPauseEndedBlock;
863 
864         blueMoldParameters.blueMoldStartBlock += tournamentExtensionAmount;
865 
866         emit Paused(newPauseEndedBlock);
867     }
868 
869     function isPaused() external view returns (bool) {
870         return block.number < tournamentTimeParameters.pauseEndedBlock;
871     }
872 }
873 
874 
875 
876 
877 
878 // This is kind of a hacky way to expose this constant, but it's the best that Solidity offers!
879 contract TournamentInterfaceId {
880     bytes4 internal constant _INTERFACE_ID_TOURNAMENT = 0xbd059098;
881 }
882 
883 /// @title Tournament interface, known to GateKeeper
884 contract TournamentInterface is TournamentInterfaceId, ERC165Interface {
885 
886     // function enter(uint256 tokenId, uint96 power, uint8 affinity) external payable;
887     function revive(uint256 wizardId) external payable;
888 
889     function enterWizards(uint256[] calldata wizardIds, uint88[] calldata powers) external payable;
890 
891     // Returns true if the Tournament is currently running and active.
892     function isActive() external view returns (bool);
893 
894     function powerScale() external view returns (uint256);
895 
896     function destroy() external;
897 }
898 
899 
900 
901 /// @title A basic Cheeze Wizards Tournament
902 /// @notice This contract mediates a Tournament between any number of Cheeze Wizards with
903 ///         the following features:
904 ///               - All Wizards who enter the Tournament are required to provide a contribution
905 ///                 to the Big Cheeze prize pool that is directly proportional to their power
906 ///                 level. There is no way for some Wizards to have a power level that is disproportionate
907 ///                 to their pot contribution amount; not even for the Tournament creators.
908 ///               - All Tournaments created with this contract follow the time constraints set out in the
909 ///                 TournamentTimeAbstract contract. While different Tournament instances might run more
910 ///                 quickly or more slowly than others, the basic cadence of the Tournament is consistent
911 ///                 across all instances.
912 ///               - The Tournament contract is designed such that, once the contract is set up, that
913 ///                 all participants can trustlessly enjoy the Tournament without fear of being ripped
914 ///                 off by the organizers. Some care needs to be taken _before_ you enter your Wizard
915 ///                 in the Tournament (including ensuring that you are actually entering into a copy
916 ///                 of this Tournament contract that hasn't been modified!), but once your Wizard has
917 ///                 been entered, you can have confidence that the rules of the contest will be followed
918 ///                 correctly, without fear of manipulation or fraud on the part of the contest creators.
919 contract BasicTournament is TournamentInterface, TournamentTimeAbstract, WizardConstants,
920     DuelResolverInterfaceId {
921 
922     // A Duel officially starts (both commits are locked in on-chain)
923     event DuelStart(
924         bytes32 duelId,
925         uint256 wizardId1,
926         uint256 wizardId2,
927         uint256 timeoutBlock,
928         bool isAscensionBattle,
929         bytes32 commit1,
930         bytes32 commit2
931     );
932 
933     // A Duel resolves normally, powers are post-resolution values
934     event DuelEnd(
935         bytes32 duelId,
936         uint256 wizardId1,
937         uint256 wizardId2,
938         bytes32 moveSet1,
939         bytes32 moveSet2,
940         uint256 power1,
941         uint256 power2
942     );
943 
944     // A Wizard challenges its opponent with the commitment of its moves.
945     event OneSidedCommitAdded(
946         uint256 committingWizardId,
947         uint256 otherWizardId,
948         uint256 committingWizardNonce,
949         uint256 otherWizardNonce,
950         bytes32 commitment
951     );
952 
953     // A Wizard cancelled the commitment against its opponent.
954     event OneSidedCommitCancelled(
955         uint256 wizardId
956     );
957 
958     // A Wizard revealed its own moves for a Duel.
959     event OneSidedRevealAdded(
960         bytes32 duelId,
961         uint256 committingWizardId,
962         uint256 otherWizardId
963     );
964 
965     // A Duel times out, powers are post-resolution values
966     event DuelTimeOut(bytes32 duelId, uint256 wizardId1, uint256 wizardId2, uint256 power1, uint256 power2);
967 
968     // A Wizard has been formally eliminated. Note that Elimination can only happen in the Elimination phase, and
969     // is NOT necessarily associated with a Wizard going to power zero.
970     event WizardElimination(uint256 wizardId);
971 
972     // A Wizard in the "danger zone" has opted to try to Ascend
973     event AscensionStart(uint256 wizardId);
974 
975     // A Wizard tried to Ascend when someone was in the Ascension Chamber; locked into a fight with each other.
976     event AscensionPairUp(uint256 wizardId1, uint256 wizardId2);
977 
978     // A Wizard in the Ascension Chamber wasn't challenged during the Fight Window, their power triples!
979     event AscensionComplete(uint256 wizardId, uint256 power);
980 
981     // A Wizard is challenging the ascending Wizard with the commitment of its moves.
982     event AscensionChallenged(uint256 ascendingWizardId, uint256 challengingWizardId, bytes32 commitment);
983 
984     // A Wizard has been revived; power is the revival amount chosen (above Blue Mold level, below maxPower)
985     event Revive(uint256 wizId, uint256 power);
986 
987     uint8 internal constant REASON_COMPLETE_ASCENSION = 1;
988     uint8 internal constant REASON_RESOLVE_ONE_SIDED_ASCENSION_BATTLE = 2;
989     uint8 internal constant REASON_GIFT_POWER = 3;
990     // One Wizard sent all of its power to another. "sendingWizId" has zero power after this
991     // reason is a enum type to distinguish between the different reasons that caused the power transfer.
992     //   1: The power transfer was caused by the completeAscension function.
993     //        An ascending wizard did not respond to a challenge, and loses all its power to the challenging wizard
994     //   2: The power transfer was caused by the resolveOneSidedAscensionBattle function.
995     //        A wizard in an ascension pair up did not commit moves during the fight window,
996     //        and the other wizard who did commit moves will take all of the non-committing wizard’s power
997     //   3: The power transfer was caused by the giftPower function.
998     //        The controller of a wizard elected to call a function that donates all of their wizard’s power
999     //        to another wizard of their choosing
1000     event PowerTransferred(uint256 sendingWizId, uint256 receivingWizId, uint256 amountTransferred, uint8 reason);
1001 
1002     // The winner (or one of the winners) has claimed their portion of the prize.
1003     event PrizeClaimed(uint256 claimingWinnerId, uint256 prizeAmount);
1004 
1005     // Used to prefix signed data blobs to prevent from signing a transaction
1006     byte internal constant EIP191_PREFIX = byte(0x19);
1007     byte internal constant EIP191_VERSION_DATA = byte(0);
1008 
1009     /// @dev The ratio between the cost of a Wizard (in wei) and the power of the wizard.
1010     ///      power = cost / powerScale
1011     ///      cost = power * powerScale
1012     /// @dev Note the "cost" here is the cost for the GateKeeper to mint a wizard in Tournament, not the
1013     ///      cost for a user to acquire a certain power of wizard.
1014     ///      GateKeeper has a hardcoded MAX_POWER_SCALE, which is 1000, so Tournament's powerScale is usually
1015     ///      lower than MAX_POWER_SCALE in order for the GateKeeper to be profitable. Also see the comments on the
1016     ///      powerScale_ argument in Tournament's constructor function.
1017     uint256 public powerScale;
1018 
1019     /// @dev The maximum power level attainable by a Wizard
1020     uint88 internal constant MAX_POWER = uint88(-1);
1021 
1022     // Address of the GateKeeper, likely to be a smart contract, but we don't care if it is
1023     // TODO: Update this address once the Gate Keeper is deployed.
1024     address public constant GATE_KEEPER = address(0x68132EB4BfD84b2D6A23ec4fB1B106F5C8574F2D);
1025 
1026     // The Wizard Guild contract. This is a variable so subclasses can modify it for
1027     // testing, but by default it cannot change from this default.
1028     // TODO: Update this address once the Wizard Guild is deployed.
1029     WizardGuildInterface public constant WIZARD_GUILD = WizardGuildInterface(address(0x0d8c864DA1985525e0af0acBEEF6562881827bd5));
1030 
1031     // The Duel Resolver contract
1032     DuelResolverInterface public duelResolver;
1033 
1034     /// @notice Power and other data while the Wizard is participating in the Tournament
1035     /// @dev fits into two words
1036     struct BattleWizard {
1037         /// @notice the wizards current power
1038         uint88 power;
1039 
1040         /// @notice the highest power a Wizard ever reached during a tournament
1041         uint88 maxPower;
1042 
1043         /// @notice a nonce value incremented when the Wizard's power level changes
1044         uint32 nonce;
1045 
1046         /// @notice a cached copy of the affinity of the Wizard - how handy!
1047         uint8 affinity;
1048 
1049         /// @notice The "id" of the Duel the Wizard is currently engaged in (which is actually
1050         ///         the hash of the duel's parameters, see _beginDuel().)
1051         bytes32 currentDuel;
1052     }
1053 
1054     mapping(uint256 => BattleWizard) internal wizards;
1055 
1056     /// @notice The total number of Wizards in this tournament. Goes up as new Wizards are entered
1057     ///         (during the Enter Phases), and goes down as Wizards get eliminated. We know we can
1058     ///         look for winners once this gets down to 5 or less!
1059     uint256 internal remainingWizards;
1060 
1061     function getRemainingWizards() external view returns(uint256) {
1062         return remainingWizards;
1063     }
1064 
1065     /// @notice A structure used to keep track of one-sided commitments that have been made on chain.
1066     ///         We anticipate most duels will make use of the doubleCommitment mechanism (because it
1067     ///         uses less gas), but that requires a trusted intermediary, so we provide one-sided commitments
1068     ///         for fully trustless interactions.
1069     struct SingleCommitment {
1070         uint256 opponentId;
1071         bytes32 commitmentHash;
1072     }
1073 
1074     // Key is Wizard ID, value is their selected opponent and their commitment hash
1075     mapping(uint256 => SingleCommitment) internal pendingCommitments;
1076 
1077     /// @notice A mapping that keeps track of one-sided reveals that have been made on chain. Like one-sided
1078     ///         commits, we expect one-sided reveals to be rare. But not quite as rare! If a player takes too
1079     ///         long to submit their reveal, their opponent will want to do a one-sided reveal to win the duel!
1080     ///         First key is Duel ID, second key is Wizard ID, value is the revealed moveset. (This structure
1081     ///         might seem odd if you aren't familiar with how Solidity handles storage-based mappings. If you
1082     ///         are confused, it's worth looking into; it's non-obvious, but quite efficient and clever!)
1083     mapping(bytes32 => mapping(uint256 => bytes32)) internal revealedMoves;
1084 
1085     // There can be at most 1 ascending Wizard at a time, who's ID is stored in this variable. If a second
1086     // Wizard tries to ascend when someone is already in the chamber, we make 'em fight!
1087     uint256 internal ascendingWizardId;
1088 
1089     function getAscendingWizardId() external view returns (uint256) {
1090         return ascendingWizardId;
1091     }
1092 
1093     // If there is a Wizard in the growth chamber when a second Wizard attempts to ascend, those two
1094     // Wizards are paired off into an Ascension Battle. This dictionary keeps track of the IDs of these
1095     // paired off Wizards. Wizard 1's ID maps to Wizard 2, and vice versa. (This means that each Ascension
1096     // Battle requires the storage of two words, which is kinda lame... ¯\_(ツ)_/¯ )
1097     mapping(uint256 => uint256) internal ascensionOpponents;
1098 
1099     // If there are an odd number of Wizards that attempt to ascend, one of them will be left in the
1100     // Ascension Chamber when the Fighting Window starts. ANY Wizard can challenge them, and they MUST
1101     // accept! This structure stores the commitment from the first challenger (if there is one).
1102     //
1103     // NOTE: The fields in this version of the structure are used subtly different than in the pending
1104     // commitments mapping. In pendingCommitments, the opponentId is the ID of the person you want to fight
1105     // and the commitmentHash is the commitment of YOUR moves. In the ascensionCommitment variable, the
1106     // opponentId is the Wizard that has challenged the ascending Wizard, and the commitmentHash is their
1107     // own moves. It makes sense in context, but it is technically a semantic switch worth being explicit about.
1108     SingleCommitment internal ascensionCommitment;
1109 
1110     struct Duel {
1111         uint128 timeout;
1112         bool isAscensionBattle;
1113     }
1114 
1115     /// @notice All of the currently active Duels, keyed by Duel ID
1116     mapping(bytes32 => Duel) internal duels;
1117 
1118     constructor(
1119         address cooAddress_,
1120         address duelResolver_,
1121         // Note the InauguralGateKeeper defines the MAX_POWER_SCALE to be 1000. And the power scale here is supposed to be
1122         // less than MAX_POWER_SCALE in order for the GateKeeper to be profitable.
1123         // For example, If the Tournament uses 500 as the powerScale_, then 50% of the ether sent with the conjureWizard call will
1124         // go to the GateKeeper and the other 50% will be forwarded to the Tournament.
1125         // That means, with 500 as the powerScale_ of the Tournament, if a user calls GateKeeper's conjureWizard with 1 ether,
1126         // then 0.5 ether will be forwarded to the Tournament contract as the pot prize to mint a wizard with 1000 power,
1127         // and 0.5 ether will be retained in the GateKeeper contract as its earning.
1128         // So using 1000 as the powerScale_ of the Tournament would make the GateKeeper unprofitable.
1129         uint256 powerScale_,
1130         uint40 tournamentStartBlock_,
1131         uint32 admissionDuration_,
1132         uint32 revivalDuration_,
1133         uint24 ascensionDuration_,
1134         uint24 fightDuration_,
1135         uint24 cullingDuration_,
1136         uint88 blueMoldBasePower_,
1137         uint24 sessionsBetweenMoldDoubling_,
1138         uint24 duelTimeoutBlocks_
1139     )
1140         public
1141         TournamentTimeAbstract(
1142             cooAddress_,
1143             tournamentStartBlock_,
1144             admissionDuration_,
1145             revivalDuration_,
1146             ascensionDuration_,
1147             fightDuration_,
1148             cullingDuration_,
1149             duelTimeoutBlocks_,
1150             blueMoldBasePower_,
1151             sessionsBetweenMoldDoubling_
1152         )
1153     {
1154         duelResolver = DuelResolverInterface(duelResolver_);
1155         require(
1156             duelResolver_ != address(0) &&
1157             duelResolver.supportsInterface(_INTERFACE_ID_DUELRESOLVER));
1158 
1159         powerScale = powerScale_;
1160     }
1161 
1162     /// @notice We allow this contract to accept any payments. All Eth sent in this way
1163     ///         automatically becomes part of the prize pool. This is useful in cases
1164     ///         where the Tournament organizers want to "seed the pot" with more funds
1165     ///         than are contributed by the players.
1166     function() external payable {}
1167 
1168     /// @notice Query if a contract implements an interface
1169     /// @param interfaceId The interface identifier, as specified in ERC-165
1170     /// @dev Interface identification is specified in ERC-165. This function
1171     ///      uses less than 30,000 gas.
1172     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
1173         return
1174             interfaceId == this.supportsInterface.selector || // ERC165
1175             interfaceId == _INTERFACE_ID_TOURNAMENT; // Tournament
1176     }
1177 
1178     /// @notice Returns true if the Tournament is currently active.
1179     ///
1180     ///         NOTE: This will return false (not active) either before the Tournament
1181     ///               begins (before any Wizards enter), or after it is over (after all
1182     ///               Wizards have been eliminated.) It also considers a Tournament inactive
1183     ///               if 200 * blueWallDoubling blocks have passed. (After 100 doublings
1184     ///               ALL of the Wizards will have succumbed to the Blue Wall, and another
1185     ///               100 doublings should be enough time for the winners to withdraw their
1186     ///               winnings. Anything left after that is fair game for the GateKeeper to take.)
1187     function isActive() public view returns (bool) {
1188         uint256 maximumTournamentLength = blueMoldParameters.moldDoublingDuration * 200;
1189 
1190         if (block.number > blueMoldParameters.blueMoldStartBlock + maximumTournamentLength) {
1191             return false;
1192         } else {
1193             return remainingWizards != 0;
1194         }
1195     }
1196 
1197 
1198     // NOTE: This might seem a like a slightly odd pattern. Typical smart contract code
1199     //       (including other smart contracts that are part of Cheeze Wizards) would
1200     //       just include the require() statement in the modifier itself instead of
1201     //       creating an additional function.
1202     //
1203     //       Unfortunately, this contract is very close to the maximum size limit
1204     //       for Ethereum (which is 24576 bytes, as per EIP-170). Modifiers work by
1205     //       more-or-less copy-and-pasting the code in them into the functions they
1206     //       decorate. It turns out that copying these modifiers (especially the
1207     //       contents of checkController() into every function that uses them adds
1208     //       up to a very large amount of space. By defining the modifier to be
1209     //       no more than a function call, we can save several KBs of contract size
1210     //       at a very small gas cost (an internal branch is just 10 gas)).
1211 
1212     function checkGateKeeper() internal view {
1213         require(msg.sender == GATE_KEEPER, "Only GateKeeper can call");
1214     }
1215 
1216 
1217     // Modifier for functions only exposed to the GateKeeper
1218     modifier onlyGateKeeper() {
1219         checkGateKeeper();
1220         _;
1221     }
1222 
1223     function checkExists(uint256 wizardId) internal view {
1224         require(wizards[wizardId].maxPower != 0, "Wizard does not exist");
1225     }
1226 
1227     // Modifier to ensure a specific Wizard is currently entered into the Tournament
1228     modifier exists(uint256 wizardId) {
1229         checkExists(wizardId);
1230         _;
1231     }
1232 
1233     function checkController(uint256 wizardId) internal view {
1234         require(wizards[wizardId].maxPower != 0, "Wizard does not exist");
1235         require(WIZARD_GUILD.isApprovedOrOwner(msg.sender, wizardId), "Must be Wizard controller");
1236     }
1237 
1238     // Modifier for functions that only the owner (or an approved operator) should be able to call
1239     // Also checks that the Wizard exists!
1240     modifier onlyWizardController(uint256 wizardId) {
1241         checkController(wizardId);
1242         _;
1243     }
1244 
1245     /// @notice A function to get the current state of the Wizard, includes the computed properties:
1246     ///         ascending (is this Wizard in the ascension chamber), ascensionOpponent (the ID of
1247     ///         an ascensionChallenger, if any) molded (this Wizard's power below the Blue Mold power
1248     ///         level), and ready (see the isReady() method for definition). You can tell if a Wizard
1249     ///         is in a battle by checking "currentDuel" against 0.
1250     function getWizard(uint256 wizardId) public view exists(wizardId) returns(
1251         uint256 affinity,
1252         uint256 power,
1253         uint256 maxPower,
1254         uint256 nonce,
1255         bytes32 currentDuel,
1256         bool ascending,
1257         uint256 ascensionOpponent,
1258         bool molded,
1259         bool ready
1260     ) {
1261         BattleWizard memory wizard = wizards[wizardId];
1262 
1263         affinity = wizard.affinity;
1264         power = wizard.power;
1265         maxPower = wizard.maxPower;
1266         nonce = wizard.nonce;
1267         currentDuel = wizard.currentDuel;
1268 
1269         ascending = ascendingWizardId == wizardId;
1270         ascensionOpponent = ascensionOpponents[wizardId];
1271         molded = _blueMoldPower() > wizard.power;
1272         ready = _isReady(wizardId, wizard);
1273     }
1274 
1275     /// @notice A finger printing function to capture the important state data about a Wizard into
1276     ///         a secure hash. This is especially useful during sales and trading to be sure that the Wizard's
1277     ///         state hasn't changed materially between the time the trade/purchase decision was made and
1278     ///         when the actual transfer is executed on-chain.
1279     function wizardFingerprint(uint256 wizardId) external view returns (bytes32) {
1280         (uint256 affinity,
1281         uint256 power,
1282         uint256 maxPower,
1283         uint256 nonce,
1284         bytes32 currentDuel,
1285         bool ascending,
1286         uint256 ascensionOpponent,
1287         bool molded,
1288         ) = getWizard(wizardId);
1289 
1290         uint256 pendingOpponent = pendingCommitments[wizardId].opponentId;
1291 
1292         // Includes all Wizard state (including computed properties) plus the Wizard ID
1293         // TODO: remove all pending commitment code
1294         return keccak256(
1295             abi.encodePacked(
1296                 wizardId,
1297                 affinity,
1298                 power,
1299                 maxPower,
1300                 nonce,
1301                 currentDuel,
1302                 ascending,
1303                 ascensionOpponent,
1304                 molded,
1305                 pendingOpponent
1306             ));
1307     }
1308 
1309     /// @notice Returns true if a Wizard is "ready", meaning it can participate in a battle, ascension, or power
1310     ///         transfer. A "ready" Wizard is not ascending, not battling, not moldy, hasn't committed to an ascension
1311     ///         battle, and has a valid affinity.
1312     function isReady(uint256 wizardId) public view exists(wizardId) returns (bool) {
1313         BattleWizard memory wizard = wizards[wizardId];
1314 
1315         return _isReady(wizardId, wizard);
1316     }
1317 
1318     /// @notice An internal version of the isReady function that leverages a BattleWizard struct
1319     ///         that is already in memory
1320     function _isReady(uint256 wizardId, BattleWizard memory wizard) internal view returns (bool) {
1321         // IMPORTANT NOTE: oneSidedCommit() needs to recreate 90% of this logic, because it needs to check to
1322         //     see if a Wizard is ready, but it allows the Wizard to have an ascension opponent. If you make any
1323         //     changes to this function, you should double check that the same edit doesn't need to be made
1324         //     to oneSidedCommit().
1325         return ((wizardId != ascendingWizardId) &&
1326             (ascensionOpponents[wizardId] == 0) &&
1327             (ascensionCommitment.opponentId != wizardId) &&
1328             (_blueMoldPower() <= wizard.power) &&
1329             (wizard.affinity != ELEMENT_NOTSET) &&
1330             (wizard.currentDuel == 0));
1331     }
1332 
1333     /// @notice The function called by the GateKeeper to enter wizards into the tournament. Only the GateKeeper can
1334     ///         call this function, meaning that the GateKeeper gets to decide who can enter. However! The Tournament
1335     ///         enforces that ALL Wizards that are entered into the Tournament have paid the same pro-rata share of
1336     ///         the prize pool as matches their starting power. Additionally, the starting power for each Wizard
1337     ///         in the Tournament can't exceed the innate power of the Wizard when it was created. This is done to
1338     ///         ensure the Tournament is possible.
1339     /// @param wizardIds The IDs of the Wizards to enter into the Tournament, can be length 1.
1340     /// @param powers The list of powers for each of the Wizards (one-to-one mapping by index).
1341     function enterWizards(uint256[] calldata wizardIds, uint88[] calldata powers) external payable duringEnterPhase onlyGateKeeper {
1342         require(wizardIds.length == powers.length, "Mismatched parameter lengths");
1343 
1344         uint256 totalCost = 0;
1345 
1346         for (uint256 i = 0; i < wizardIds.length; i++) {
1347             uint256 wizardId = wizardIds[i];
1348             uint88 power = powers[i];
1349 
1350             require(wizards[wizardId].maxPower == 0, "Wizard already in tournament");
1351 
1352             (, uint88 innatePower, uint8 affinity, ) = WIZARD_GUILD.getWizard(wizardId);
1353 
1354             require(power > 0 && power <= innatePower, "Invalid power");
1355 
1356             wizards[wizardId] = BattleWizard({
1357                 power: power,
1358                 maxPower: power,
1359                 nonce: 0,
1360                 affinity: affinity,
1361                 currentDuel: 0
1362             });
1363 
1364             totalCost += power * powerScale;
1365         }
1366 
1367         remainingWizards += wizardIds.length;
1368 
1369         require(msg.value >= totalCost, "Insufficient funds");
1370     }
1371 
1372     /// @dev Brings a tired Wizard back to fightin' strength. Can only be used during the revival
1373     ///      phase. The buy-back can be to any power level between the Blue Wall power (at the low end)
1374     ///      and the previous max power achieved by this Wizard in this tournament. This does mean a revival
1375     ///      can bring a Wizard back above their innate power! The contribution into the pot MUST be equivalent
1376     ///      to the cost that would be needed to bring in a new Wizard at the same power level. Can only
1377     ///      be called by the GateKeeper to allow the GateKeeper to manage the pot contribution rate and
1378     ///      potentially apply other rules or requirements to revival.
1379     function revive(uint256 wizardId) external payable exists(wizardId) duringRevivalPhase onlyGateKeeper {
1380         BattleWizard storage wizard = wizards[wizardId];
1381 
1382         uint88 maxPower = wizard.maxPower;
1383         uint88 revivalPower = uint88(msg.value / powerScale);
1384 
1385         require((revivalPower > _blueMoldPower()) && (revivalPower <= maxPower), "Invalid power level");
1386         require(wizard.power == 0, "Can only revive tired Wizards");
1387 
1388         // There is no scenario in which a Wizard can be "not ready" and have a zero power.
1389         // require(isReady(wizardId), "Can't revive a busy Wizard");
1390 
1391         wizard.power = revivalPower;
1392         wizard.nonce += 1;
1393 
1394         emit Revive(wizardId, revivalPower);
1395     }
1396 
1397     /// @notice Updates the cached value of a Wizard's affinity with the value from the Wizard Guild.
1398     ///         Only useful for Exclusive Wizards that initially have no elemental affinity, and which
1399     ///         is then selected by the owner. When the Wizard enters the Tournament it might not have
1400     ///         it's affinity set yet, and this will copy the affinity from the Guild contract if it's
1401     ///         been updated. Can be called by anyone since it can't be abused.
1402     /// @param wizardId The id of the Wizard to update
1403     function updateAffinity(uint256 wizardId) external exists(wizardId) {
1404         (, , uint8 newAffinity, ) = WIZARD_GUILD.getWizard(wizardId);
1405         BattleWizard storage wizard = wizards[wizardId];
1406         require(wizard.affinity == ELEMENT_NOTSET, "Affinity already updated");
1407         wizard.affinity = newAffinity;
1408     }
1409 
1410     function startAscension(uint256 wizardId) external duringAscensionWindow onlyWizardController(wizardId) {
1411         BattleWizard memory wizard = wizards[wizardId];
1412 
1413         require(_isReady(wizardId, wizard), "Can't ascend a busy wizard!");
1414 
1415         require(wizard.power < _blueMoldPower() * 2, "Not eligible for ascension");
1416 
1417         if (ascendingWizardId != 0) {
1418             // there is already a Wizard ascending! Pair up the incoming Wizard with the
1419             // Wizard in the Ascension Chamber and make them fight it out!
1420             ascensionOpponents[ascendingWizardId] = wizardId;
1421             ascensionOpponents[wizardId] = ascendingWizardId;
1422 
1423             emit AscensionPairUp(ascendingWizardId, wizardId);
1424 
1425             // Empty out the Ascension Chamber for the next Ascension
1426             ascendingWizardId = 0;
1427         } else {
1428             // the chamber is empty, get in!
1429             ascendingWizardId = wizardId;
1430 
1431             emit AscensionStart(wizardId);
1432         }
1433     }
1434 
1435     function _checkChallenge(uint256 challengerId, uint256 recipientId) internal view {
1436         require(pendingCommitments[challengerId].opponentId == 0, "Pending battle already exists");
1437         require(recipientId > 0, "No Wizard is ascending");
1438         require(challengerId != recipientId, "Cannot duel oneself!");
1439     }
1440 
1441     /// @notice Any live Wizard can challenge an ascending Wizard during the fight phase. They must
1442     ///         provide a commitment of their moves (which is totally reasonable, since they know
1443     ///         exactly who they will be fighting!)
1444     function challengeAscending(uint256 wizardId, bytes32 commitment) external duringFightWindow onlyWizardController(wizardId) {
1445         require(ascensionCommitment.opponentId == 0, "Wizard already challenged");
1446 
1447         _checkChallenge(wizardId, ascendingWizardId);
1448 
1449         // Ascension Battles MUST come well before the end of the fight window to give the
1450         // ascending Wizard a chance to respond with their own commitment.
1451         require(canChallengeAscendingWizard(), "Challenge too late");
1452 
1453         BattleWizard memory wizard = wizards[wizardId];
1454 
1455         require(_isReady(wizardId, wizard), "Wizard not ready");
1456         // We don't need to call isReady() on the ascendingWizard: It's definitionally ready for a challenge!
1457 
1458         // Store a pending commitment that the ascending Wizard can accept
1459         ascensionCommitment = SingleCommitment({opponentId: wizardId, commitmentHash: commitment});
1460         emit AscensionChallenged(ascendingWizardId, wizardId, commitment);
1461     }
1462 
1463     /// @notice Allows the Ascending Wizard to respond to an ascension commitment with their own move commitment,
1464     //          thereby starting an Ascension Battle.
1465     function acceptAscensionChallenge(bytes32 commitment) external duringFightWindow onlyWizardController(ascendingWizardId) {
1466         uint256 challengerId = ascensionCommitment.opponentId;
1467         require(challengerId != 0, "No challenge to accept");
1468 
1469         if (challengerId < ascendingWizardId) {
1470             _beginDuel(challengerId, ascendingWizardId, ascensionCommitment.commitmentHash, commitment, true);
1471         } else {
1472             _beginDuel(ascendingWizardId, challengerId, commitment, ascensionCommitment.commitmentHash, true);
1473         }
1474 
1475         // The duel has begun! THERE CAN BE ONLY ONE!!!
1476         delete ascensionCommitment;
1477         delete ascendingWizardId;
1478     }
1479 
1480     /// @notice Completes the Ascension for the Wizard in the Ascension Chamber. Note that this can only be called
1481     ///         during a Resolution Window, and a Wizard can only enter the Ascension Chamber during the Ascension Window,
1482     ///         and there is _always_ a Fight Window between the Ascension Window and the Resolution Window. In other
1483     ///         words, there is a always a chance for a challenger to battle the Ascending Wizard before the
1484     ///         ascension can complete.
1485     function completeAscension() external duringResolutionWindow {
1486         require(ascendingWizardId != 0, "No Wizard to ascend");
1487 
1488         BattleWizard storage ascendingWiz = wizards[ascendingWizardId];
1489 
1490         if (ascensionCommitment.opponentId != 0) {
1491             // Someone challenged the ascending Wizard, but the ascending Wizard didn't fight!
1492             // You. Are. Outtahere!
1493             _transferPower(ascendingWizardId, ascensionCommitment.opponentId, REASON_COMPLETE_ASCENSION);
1494         }
1495         else {
1496             // Oh lucky day! The Wizard survived a complete fight cycle without any challengers
1497             // coming along! Let's just triple their power.
1498             //
1499             // A note to the naive: THIS WILL NEVER ACTUALLY HAPPEN.
1500             _updatePower(ascendingWiz, ascendingWiz.power * 3);
1501             ascendingWiz.nonce += 1;
1502         }
1503 
1504         emit AscensionComplete(ascendingWizardId, ascendingWiz.power);
1505 
1506         ascendingWizardId = 0;
1507     }
1508 
1509     function oneSidedCommit(uint256 committingWizardId, uint256 otherWizardId, bytes32 commitment)
1510             external duringFightWindow onlyWizardController(committingWizardId) exists(otherWizardId)
1511     {
1512         _checkChallenge(committingWizardId, otherWizardId);
1513 
1514         bool isAscensionBattle = false;
1515 
1516         if ((ascensionOpponents[committingWizardId] != 0) || (ascensionOpponents[otherWizardId] != 0)) {
1517             require(
1518                 (ascensionOpponents[committingWizardId] == otherWizardId) &&
1519                 (ascensionOpponents[otherWizardId] == committingWizardId), "Must resolve Ascension Battle");
1520 
1521             isAscensionBattle = true;
1522         }
1523 
1524         BattleWizard memory committingWiz = wizards[committingWizardId];
1525         BattleWizard memory otherWiz = wizards[otherWizardId];
1526 
1527         // Ideally, we'd use the isReady() function here, but it will return false if the caller has an
1528         // ascension opponent, which, of course, our Wizards just might!
1529         require(
1530             (committingWizardId != ascendingWizardId) &&
1531             (ascensionCommitment.opponentId != committingWizardId) &&
1532             (_blueMoldPower() <= committingWiz.power) &&
1533             (committingWiz.affinity != ELEMENT_NOTSET) &&
1534             (committingWiz.currentDuel == 0), "Wizard not ready");
1535 
1536         require(
1537             (otherWizardId != ascendingWizardId) &&
1538             (ascensionCommitment.opponentId != otherWizardId) &&
1539             (_blueMoldPower() <= otherWiz.power) &&
1540             (otherWiz.affinity != ELEMENT_NOTSET) &&
1541             (otherWiz.currentDuel == 0), "Wizard not ready.");
1542 
1543         SingleCommitment memory otherCommitment = pendingCommitments[otherWizardId];
1544 
1545         if (otherCommitment.opponentId == 0) {
1546             // The other Wizard does not currently have any pending commitments, we will store a
1547             // pending commitment so that the other Wizard can pick it up later.
1548             pendingCommitments[committingWizardId] = SingleCommitment({opponentId: otherWizardId, commitmentHash: commitment});
1549 
1550             emit OneSidedCommitAdded(
1551                 committingWizardId,
1552                 otherWizardId,
1553                 committingWiz.nonce,
1554                 otherWiz.nonce,
1555                 commitment);
1556         } else if (otherCommitment.opponentId == committingWizardId) {
1557             // We've found a matching commitment! Be sure to order them correctly...
1558             if (committingWizardId < otherWizardId) {
1559                 _beginDuel(committingWizardId, otherWizardId, commitment, otherCommitment.commitmentHash, isAscensionBattle);
1560             } else {
1561                 _beginDuel(otherWizardId, committingWizardId, otherCommitment.commitmentHash, commitment, isAscensionBattle);
1562             }
1563 
1564             delete pendingCommitments[otherWizardId];
1565 
1566             if (isAscensionBattle) {
1567                 delete ascensionOpponents[committingWizardId];
1568                 delete ascensionOpponents[otherWizardId];
1569             }
1570         }
1571         else {
1572             revert("Opponent has a pending challenge");
1573         }
1574     }
1575 
1576     function cancelCommitment(uint256 wizardId) external onlyWizardController(wizardId) {
1577         require(ascensionOpponents[wizardId] == 0, "Can't cancel Ascension Battle");
1578 
1579         // Only emit the event when pendingCommitment exists.
1580         if (pendingCommitments[wizardId].opponentId != 0) {
1581             emit OneSidedCommitCancelled(wizardId);
1582         }
1583 
1584         delete pendingCommitments[wizardId];
1585     }
1586 
1587     /// @notice Commits two Wizards into a duel with a single transaction. Both Wizards must be "ready"
1588     ///      (not ascending, not battling, not moldy, and having a valid affinity), and it must be during a
1589     ///      Fight Window.
1590     /// @dev A note on implementation: Each duel is identified by a hash that combines both Wizard IDs,
1591     ///      both Wizard nonces, and both commits. Just the IDs and nonces are sufficient to ensure a unique
1592     ///      identifier of the duel, but by including the commits in the hash, we don't need to store the commits
1593     ///      on-chain (which is pretty expensive, given that they each take up 32 bytes). This does mean that
1594     ///      the duel resolution functions require the caller to pass in both commits in order to be resolved, but
1595     ///      the commit data is publicly available. Overall, this results in a pretty significant gas savings.
1596     ///
1597     ///      Earlier versions of this function provided convenience functionality, such as checking to see if a
1598     ///      Wizard was ready to ascend, or needed to be removed from a timed-out duel before starting this duel.
1599     ///      Each of those checks took more gas, required more code, and ultimately just tested conditions that are
1600     ///      trivial to check off-chain (where code is cheap and gas is for cars). This results in clearer
1601     ///      on-chain code, and very little extra effort off-chain.
1602     /// @param wizardId1 The id of the 1st wizard
1603     /// @param wizardId2 The id of the 2nd wizard
1604     /// @param commit1 The commitment hash of the 1st Wizard's moves
1605     /// @param commit2 The commitment hash of the 2nd Wizard's moves
1606     /// @param sig1 The signature corresponding to wizard1
1607     /// @param sig2 The signature corresponding to wizard2
1608     function doubleCommit(
1609         uint256 wizardId1,
1610         uint256 wizardId2,
1611         bytes32 commit1,
1612         bytes32 commit2,
1613         bytes calldata sig1,
1614         bytes calldata sig2) external duringFightWindow returns (bytes32 duelId) {
1615 
1616         // Ideally, we'd use the exists() modifiers instead of this code, but doing so runs over
1617         // Solidity's stack limit
1618         checkExists(wizardId1);
1619         checkExists(wizardId2);
1620 
1621         // The Wizard IDs must be strictly in ascending order so that we don't treat a battle between
1622         // "wizard 3 and wizard 5" as different than the battle between "wizard 5 and wizard 3".
1623         // This also ensures that a Wizards isn't trying to duel itself!
1624         require(wizardId1 < wizardId2, "Wizard IDs must be ordered");
1625 
1626         bool isAscensionBattle = false;
1627 
1628         if ((ascensionOpponents[wizardId1] != 0) || (ascensionOpponents[wizardId2] != 0)) {
1629             require(
1630                 (ascensionOpponents[wizardId1] == wizardId2) &&
1631                 (ascensionOpponents[wizardId2] == wizardId1), "Must resolve Ascension Battle");
1632 
1633             isAscensionBattle = true;
1634 
1635             // We can safely delete the ascensionOpponents values now because either this function
1636             // will culminate in a committed duel, or it will revert entirely. It also lets us
1637             // use the _isReady() convenience function (which treats a Wizard with a non-zero
1638             // ascension opponent as not ready).
1639             delete ascensionOpponents[wizardId1];
1640             delete ascensionOpponents[wizardId2];
1641         }
1642 
1643         // Get in-memory copies of the wizards
1644         BattleWizard memory wiz1 = wizards[wizardId1];
1645         BattleWizard memory wiz2 = wizards[wizardId2];
1646 
1647         require(_isReady(wizardId1, wiz1) && _isReady(wizardId2, wiz2), "Wizard not ready");
1648 
1649         // Check that the signatures match the duel data and commitments
1650         bytes32 signedHash1 = _signedHash(wizardId1, wizardId2, wiz1.nonce, wiz2.nonce, commit1);
1651         bytes32 signedHash2 = _signedHash(wizardId1, wizardId2, wiz1.nonce, wiz2.nonce, commit2);
1652         WIZARD_GUILD.verifySignatures(wizardId1, wizardId2, signedHash1, signedHash2, sig1, sig2);
1653 
1654         // If both signatures have passed, we can begin the duel!
1655         duelId = _beginDuel(wizardId1, wizardId2, commit1, commit2, isAscensionBattle);
1656 
1657         // Remove any potential commitments so that they won't be reused
1658         delete pendingCommitments[wizardId1];
1659         delete pendingCommitments[wizardId2];
1660     }
1661 
1662     /// @notice An internal utility function that computes the hash that is used for the commitment signature
1663     ///         from each Wizard.
1664     function _signedHash(uint256 wizardId1, uint256 wizardId2, uint32 nonce1, uint32 nonce2, bytes32 commit)
1665         internal view returns(bytes32)
1666     {
1667         return keccak256(
1668             abi.encodePacked(
1669             EIP191_PREFIX,
1670             EIP191_VERSION_DATA,
1671             this,
1672             wizardId1,
1673             wizardId2,
1674             nonce1,
1675             nonce2,
1676             commit
1677         ));
1678     }
1679 
1680     /// @notice The internal utility function to create the duel structure on chain, requires Commitments
1681     ///         from both Wizards.
1682     function _beginDuel(uint256 wizardId1, uint256 wizardId2, bytes32 commit1, bytes32 commit2, bool isAscensionBattle)
1683             internal returns (bytes32 duelId)
1684     {
1685         // Get a reference to the Wizard objects in storage
1686         BattleWizard storage wiz1 = wizards[wizardId1];
1687         BattleWizard storage wiz2 = wizards[wizardId2];
1688 
1689         // Compute a unique ID for this battle, this ID can't be reused because we strictly increase
1690         // the nonce for each Wizard whenever a battle is recreated. (Includes the contract address
1691         // to avoid replay attacks between different tournaments).
1692         duelId = keccak256(
1693             abi.encodePacked(
1694             this,
1695             wizardId1,
1696             wizardId2,
1697             wiz1.nonce,
1698             wiz2.nonce,
1699             commit1,
1700             commit2
1701         ));
1702 
1703         // Store the duel ID in each Wizard, to mark the fact that they are fighting
1704         wiz1.currentDuel = duelId;
1705         wiz2.currentDuel = duelId;
1706 
1707         // Keep track of the timeout for this duel
1708         uint256 duelTimeout;
1709 
1710         if (isAscensionBattle) {
1711             // Ascension Battles always last for a while after the current fight window to ensure
1712             // both sides have a well-defined timeframe for revealing their moves (Ascension Battles)
1713             // are inherently more asynchronous than normal battles.
1714             duelTimeout = _ascensionDuelTimeout();
1715         } else {
1716             // Normal battles just timeout starting .... NOW!
1717             duelTimeout = block.number + tournamentTimeParameters.duelTimeoutDuration;
1718         }
1719 
1720         duels[duelId] = Duel({timeout: uint128(duelTimeout), isAscensionBattle: isAscensionBattle});
1721 
1722         emit DuelStart(duelId, wizardId1, wizardId2, duelTimeout, isAscensionBattle, commit1, commit2);
1723     }
1724 
1725     /// @notice Reveals the moves for one of the Wizards in a duel. This should be called rarely, but
1726     ///         is necessary in order to resolve a duel where one player is unwilling or unable to reveal
1727     ///         their moves (also useful if a coordinating intermediary is unavailable or unwanted for some reason).
1728     ///         It's worth noting that this method doesn't check any signatures or filter on msg.sender because
1729     ///         it is cryptographically impossible for someone to submit a moveset and salt that matches the
1730     ///         commitment (which was signed, don't forget!).
1731     ///
1732     ///         Note: This function doesn't need exists(wizardId) because an eliminated Wizard would have
1733     ///               currentDuel == 0
1734     /// @param committingWizardId The Wizard whose moves are being revealed
1735     /// @param commit A copy of the commitment used previously, not stored on-chain to save gas
1736     /// @param moveSet The revealed move set
1737     /// @param salt The salt used to secure the commitment hash
1738     /// @param otherWizardId The other Wizard in this battle
1739     /// @param otherCommit The other Wizard's commitment, not stored on-chain to save gas
1740     function oneSidedReveal(
1741         uint256 committingWizardId,
1742         bytes32 commit,
1743         bytes32 moveSet,
1744         bytes32 salt,
1745         uint256 otherWizardId,
1746         bytes32 otherCommit) external
1747     {
1748         BattleWizard memory wizard = wizards[committingWizardId];
1749         BattleWizard memory otherWizard = wizards[otherWizardId];
1750 
1751         bytes32 duelId = wizard.currentDuel;
1752 
1753         require(duelId != 0, "Wizard not dueling");
1754 
1755         // Check that the passed data matches the duel hash
1756         bytes32 computedDuelId;
1757 
1758         // Make sure we compute the duel ID with the Wizards sorted in ascending order
1759         if (committingWizardId < otherWizardId) {
1760             computedDuelId = keccak256(
1761                 abi.encodePacked(
1762                 this,
1763                 committingWizardId,
1764                 otherWizardId,
1765                 wizard.nonce,
1766                 otherWizard.nonce,
1767                 commit,
1768                 otherCommit
1769             ));
1770         } else {
1771             computedDuelId = keccak256(
1772                 abi.encodePacked(
1773                 this,
1774                 otherWizardId,
1775                 committingWizardId,
1776                 otherWizard.nonce,
1777                 wizard.nonce,
1778                 otherCommit,
1779                 commit
1780             ));
1781         }
1782 
1783         require(computedDuelId == duelId, "Invalid duel data");
1784 
1785         // Confirm that the revealed data matches the commitment
1786         require(keccak256(abi.encodePacked(moveSet, salt)) == commit, "Moves don't match commitment");
1787 
1788         // We need to verify that the provided moveset is valid here. Otherwise the duel resolution will
1789         // fail later, and the duel can never be resolved. We treat a _valid_ commit/reveal of an _invalid_
1790         // moveset as being equivalent of not providing a reveal (which is subject to automatic loss). I mean,
1791         // you really should have known better!
1792         require(duelResolver.isValidMoveSet(moveSet), "Invalid moveset");
1793 
1794         if (revealedMoves[duelId][otherWizardId] != 0) {
1795             // We have the revealed moves for the other Wizard also, we can resolve the duel now
1796             if (committingWizardId < otherWizardId) {
1797                 _resolveDuel(duelId, committingWizardId, otherWizardId, moveSet, revealedMoves[duelId][otherWizardId]);
1798             } else {
1799                 _resolveDuel(duelId, otherWizardId, committingWizardId, revealedMoves[duelId][otherWizardId], moveSet);
1800             }
1801         }
1802         else {
1803             require(block.number < duels[duelId].timeout, "Duel expired");
1804             // Store our revealed moves for later resolution
1805             revealedMoves[duelId][committingWizardId] = moveSet;
1806             emit OneSidedRevealAdded(duelId, committingWizardId, otherWizardId);
1807         }
1808     }
1809 
1810     /// @notice Reveals the moves for both Wizards at once, saving lots of gas and lowering the number
1811     ///         of required transactions. As with oneSidedReveal(), no authentication is required other
1812     ///         than matching the reveals to the commits. It is not an error if oneSidedReveal is called
1813     ///         and then doubleReveal, although we do ignore the previous one-sided reveal if it exists.
1814     ///         The _resolvedDuel utility function will clean up any cached revealedMoves for BOTH Wizards.
1815     ///
1816     ///         NOTE: As with the doubleCommit() method, the Wizards must be provided in _strict_ ascending
1817     ///         order for this function to work correctly.
1818     ///
1819     ///         NOTE: This function will fail if _either_ of the Wizards have submitted an invalid moveset.
1820     ///         The correct way of handling this situation is to use oneSidedReveal() (if one moveset is valid
1821     ///         and the other is not) and then let the Battle timeout, or -- if both movesets are invalid --
1822     ///         don't do any reveals and let the Battle timeout.
1823     ///
1824     ///         Note: This function doesn't need exists(wizardId1) exists(wizardId2) because an
1825     ///               eliminated Wizard would have currentDuel == 0
1826     /// @param wizardId1 The id of the 1st wizard
1827     /// @param wizardId2 The id of the 2nd wizard
1828     /// @param commit1 A copy of the 1st Wizard's commitment, not stored on-chain to save gas
1829     /// @param commit2 A copy of the 2nd Wizard's commitment, not stored on-chain to save gas
1830     /// @param moveSet1 The plaintext reveal (moveset) of the 1st wizard
1831     /// @param moveSet2 The plaintext reveal (moveset) of the 2nd wizard
1832     /// @param salt1 The secret salt of the 1st wizard
1833     /// @param salt2 The secret salt of the 2nd wizard
1834     function doubleReveal(
1835         uint256 wizardId1,
1836         uint256 wizardId2,
1837         bytes32 commit1,
1838         bytes32 commit2,
1839         bytes32 moveSet1,
1840         bytes32 moveSet2,
1841         bytes32 salt1,
1842         bytes32 salt2) external
1843     {
1844         // Get a reference to the Wizard objects in storage
1845         BattleWizard storage wiz1 = wizards[wizardId1];
1846         BattleWizard storage wiz2 = wizards[wizardId2];
1847 
1848         // In order to match the duel ID generated by the commit functions, the Wizard IDs must be strictly
1849         // in ascending order. However! We don't actually check that here because that just wastes gas
1850         // to perform a check that the duel ID comparison below will have to do anyway. But, we're leaving
1851         // this commented out here as a reminder...
1852         // require(wizardId1 < wizardId2, "Wizard IDs must be ordered");
1853 
1854         // Confirm that the duel data passed into the function matches the duel ID in the Wizard
1855         bytes32 duelId = keccak256(
1856             abi.encodePacked(
1857             this,
1858             wizardId1,
1859             wizardId2,
1860             wiz1.nonce,
1861             wiz2.nonce,
1862             commit1,
1863             commit2
1864         ));
1865 
1866         // NOTE: We don't actually need to check the currentDuel field of the other Wizard because
1867         // we trust the hash function.
1868         require(wiz1.currentDuel == duelId, "Invalid duel data");
1869 
1870         // Confirm that the reveals match the commitments
1871         require(
1872             (keccak256(abi.encodePacked(moveSet1, salt1)) == commit1) &&
1873             (keccak256(abi.encodePacked(moveSet2, salt2)) == commit2), "Moves don't match commitment");
1874 
1875         // Resolve the duel!
1876         _resolveDuel(duelId, wizardId1, wizardId2, moveSet1, moveSet2);
1877     }
1878 
1879     /// @notice An utility function to resolve a duel once both movesets have been revealed.
1880     function _resolveDuel(bytes32 duelId, uint256 wizardId1, uint256 wizardId2, bytes32 moveSet1, bytes32 moveSet2) internal {
1881         Duel memory duelInfo = duels[duelId];
1882 
1883         require(block.number < duelInfo.timeout, "Duel expired");
1884 
1885         // Get a reference to the Wizard objects in storage
1886         BattleWizard storage wiz1 = wizards[wizardId1];
1887         BattleWizard storage wiz2 = wizards[wizardId2];
1888 
1889         int256 battlePower1 = wiz1.power;
1890         int256 battlePower2 = wiz2.power;
1891 
1892         int256 moldPower = int256(_blueMoldPower());
1893 
1894         if (duelInfo.isAscensionBattle) {
1895             // In Ascension Battles, if one Wizard is more powerful than the other Wizard by
1896             // more than double the current blue mold level, we cap the at-risk power of that
1897             // more powerful Wizard to match the power level of the weaker wizard. This probably
1898             // isn't clear, so here are some examples. In all of these examples, the second wizard
1899             // is more powerful than the first, but the logic is equivalent in both directions.
1900             // In each case, we assume the blue mold level is 100. (The non-intuitive lines are
1901             // marked with an arrow.)
1902             //
1903             //  power1   |   power2   |   battlePower2
1904             //   100     |    100     |     100
1905             //   100     |    200     |     200
1906             //   100     |    300     |     300
1907             //   100     |    301     |     100  <==
1908             //   199     |    200     |     200
1909             //   199     |    300     |     300
1910             //   199     |    399     |     399
1911             //   199     |    400     |     199  <==
1912             //
1913             // This technique is necessary to achieve three somewhat conflicting goals
1914             // simultaneously:
1915             //    - Anyone should be able to battle an ascending Wizard, regardless of the
1916             //      power differential
1917             //    - Your probability of winning an Ascension Battle should be proportional to
1918             //      the amount of power you put at risk
1919             //    - A Wizard that is Ascending should be _guaranteed_ that, if they manage to
1920             //      win the Ascension Battle, they will have enough power to escape the next
1921             //      Blue Mold increase. (And if they lose, at least they had a fair shot.)
1922             //
1923             // Note that although a very powerful Wizard becomes less likely to win under this
1924             // scheme (because they aren't using their entire power in this battle), they are
1925             // putting much less power at risk (while the ascending Wizard is risking EVERYTHING).
1926             if (battlePower1 > battlePower2 + 2*moldPower) {
1927                 battlePower1 = battlePower2;
1928             } else if (battlePower2 > battlePower1 + 2*moldPower) {
1929                 battlePower2 = battlePower1;
1930             }
1931         }
1932 
1933         int256 powerDiff = duelResolver.resolveDuel(
1934             moveSet1,
1935             moveSet2,
1936             uint256(battlePower1),
1937             uint256(battlePower2),
1938             wiz1.affinity,
1939             wiz2.affinity);
1940 
1941         // A duel resolver should never return a negative value with a magnitude greater than the
1942         // first wizard's power, or a positive value with a magnitude greater than the second
1943         // wizard's power. We enforce that here to be safe (since it is an external contract).
1944         if (powerDiff < -battlePower1) {
1945             powerDiff = -battlePower1;
1946         } else if (powerDiff > battlePower2) {
1947             powerDiff = battlePower2;
1948         }
1949 
1950         // Given the checks above, both of these values will resolve to >= 0
1951         battlePower1 += powerDiff;
1952         battlePower2 -= powerDiff;
1953 
1954         if (duelInfo.isAscensionBattle) {
1955             // In an Ascension Battle, we always transfer 100% of the power-at-risk. Give it
1956             // to the Wizard with the highest power after the battle (which might not be the
1957             // Wizard who got the higher score!)
1958             if (battlePower1 >= battlePower2) {
1959                 // NOTE! The comparison above is very carefully chosen: In the case of a
1960                 // tie in the power level after the battle (exceedingly unlikely, but possible!)
1961                 // we want the win to go to the Wizard with the lower ID. Since all of the duel
1962                 // functions require the wizards to be strictly ascending ID order, that's
1963                 // wizardId1, which means we want a tie to land in this leg of the if-else statement.
1964                 powerDiff += battlePower2;
1965             } else {
1966                 powerDiff -= battlePower1;
1967             }
1968         }
1969 
1970         // We now apply the power differential to the _actual_ Wizard powers (and not just
1971         // the power-at-risk).
1972         int256 power1 = wiz1.power + powerDiff;
1973         int256 power2 = wiz2.power - powerDiff;
1974 
1975         // We now check to see if either of the wizards ended up under the blue mold level.
1976         // If so, we transfer ALL of the rest of the power from the weaker Wizard to the winner.
1977         if (power1 < moldPower) {
1978             power2 += power1;
1979             power1 = 0;
1980         }
1981         else if (power2 < moldPower) {
1982             power1 += power2;
1983             power2 = 0;
1984         }
1985 
1986         _updatePower(wiz1, power1);
1987         _updatePower(wiz2, power2);
1988 
1989         // unlock wizards
1990         wiz1.currentDuel = 0;
1991         wiz2.currentDuel = 0;
1992 
1993         // Increment the Wizard nonces
1994         wiz1.nonce += 1;
1995         wiz2.nonce += 1;
1996 
1997         // Clean up old data
1998         delete duels[duelId];
1999         delete revealedMoves[duelId][wizardId1];
2000         delete revealedMoves[duelId][wizardId2];
2001 
2002         // emit event
2003         emit DuelEnd(duelId, wizardId1, wizardId2, moveSet1, moveSet2, wiz1.power, wiz2.power);
2004     }
2005 
2006     /// @notice Utility function to update the power on a Wizard, ensuring it doesn't overflow
2007     ///         a uint88 and also updates maxPower as appropriate.
2008     // solium-disable-next-line security/no-assign-params
2009     function _updatePower(BattleWizard storage wizard, int256 newPower) internal {
2010         if (newPower > MAX_POWER) {
2011             newPower = MAX_POWER;
2012         }
2013 
2014         wizard.power = uint88(newPower);
2015 
2016         if (wizard.maxPower < newPower) {
2017             wizard.maxPower = uint88(newPower);
2018         }
2019     }
2020 
2021     /// @notice Utility function to transfer all power from sending Wizard to receiving Wizard
2022     /// and emit a PowerTransferred event
2023     function _transferPower(uint256 sendingWizardId, uint256 receivingWizardId, uint8 reason) internal {
2024         BattleWizard storage sendingWiz = wizards[sendingWizardId];
2025         BattleWizard storage receivingWiz = wizards[receivingWizardId];
2026 
2027         _updatePower(receivingWiz, receivingWiz.power + sendingWiz.power);
2028 
2029         emit PowerTransferred(sendingWizardId, receivingWizardId, sendingWiz.power, reason);
2030 
2031         sendingWiz.power = 0;
2032         // update the nonces to reflect the state change and invalidate any pending commitments
2033         sendingWiz.nonce += 1;
2034         receivingWiz.nonce += 1;
2035     }
2036 
2037     /// @notice used for when wizards locked in an ascension battle but one wizard didn't submit their commit
2038     function resolveOneSidedAscensionBattle(uint256 wizardId) external duringResolutionWindow {
2039         uint256 opponentId = ascensionOpponents[wizardId];
2040         require(opponentId != 0, "No opponent");
2041 
2042         SingleCommitment memory commit = pendingCommitments[wizardId];
2043         require(commit.opponentId == opponentId, "No commit");
2044 
2045         _transferPower(opponentId, wizardId, REASON_RESOLVE_ONE_SIDED_ASCENSION_BATTLE);
2046 
2047         // clean up state
2048         delete pendingCommitments[wizardId];
2049         delete ascensionOpponents[wizardId];
2050         delete ascensionOpponents[opponentId];
2051     }
2052 
2053     /// @notice Resolves a duel that has timed out. This can only happen if one or both players
2054     ///         didn't reveal their moves. If both don't reveal, there is no power transfer, if one
2055     ///         revealed, they win ALL the power.
2056     ///
2057     ///         Note: This function doesn't need exists(wizardId1) exists(wizardId2) because an
2058     ///               eliminated Wizard would have currentDuel == 0
2059     function resolveTimedOutDuel(uint256 wizardId1, uint256 wizardId2) external {
2060         // This check is required in order to prevent attackers from wiping out wizards in a timed out duels.
2061         require(wizardId1 != wizardId2, "Same Wizard");
2062         BattleWizard storage wiz1 = wizards[wizardId1];
2063         BattleWizard storage wiz2 = wizards[wizardId2];
2064 
2065         bytes32 duelId = wiz1.currentDuel;
2066 
2067         require(duelId != 0 && wiz2.currentDuel == duelId);
2068         require(block.number >= duels[duelId].timeout);
2069 
2070         int256 allPower = wiz1.power + wiz2.power;
2071 
2072         if (revealedMoves[duelId][wizardId1] != 0) {
2073             // The first Wizard revealed their moves, but the second one didn't (otherwise it
2074             // would have been resolved). Transfer all of the power from two to one.
2075             _updatePower(wiz1, allPower);
2076             wiz2.power = 0;
2077         } else if (revealedMoves[duelId][wizardId2] != 0) {
2078             // The second Wizard revealed, so it drains the first.
2079             _updatePower(wiz2, allPower);
2080             wiz1.power = 0;
2081         }
2082         // NOTE: If neither Wizard did a reveal, we just end the battle with no power transfer.
2083 
2084         // unlock wizards
2085         wiz1.currentDuel = 0;
2086         wiz2.currentDuel = 0;
2087 
2088         // Increment the Wizard nonces
2089         wiz1.nonce += 1;
2090         wiz2.nonce += 1;
2091 
2092         // Clean up old data
2093         delete duels[duelId];
2094         delete revealedMoves[duelId][wizardId1];
2095         delete revealedMoves[duelId][wizardId2];
2096 
2097         // emit event
2098         emit DuelTimeOut(duelId, wizardId1, wizardId2, wiz1.power, wiz2.power);
2099     }
2100 
2101     /// @notice Transfer the power of one Wizard to another. The caller has to be the owner
2102     ///         or have approval of the sending Wizard. Both Wizards must be ready (not moldy,
2103     ///         ascending or in a duel), and we limit power transfers to happen during Fight
2104     ///         Windows (this is important so that power transfers don't interfere with Culling
2105     ///         or Ascension operations).
2106     /// @param sendingWizardId The Wizard to transfer power from. After the transfer,
2107     ///        this Wizard will have no power.
2108     /// @param receivingWizardId The Wizard to transfer power to.
2109     function giftPower(uint256 sendingWizardId, uint256 receivingWizardId) external
2110         onlyWizardController(sendingWizardId) exists(receivingWizardId) duringFightWindow
2111     {
2112         require(sendingWizardId != receivingWizardId);
2113         require(isReady(sendingWizardId) && isReady(receivingWizardId));
2114 
2115         _transferPower(sendingWizardId, receivingWizardId, REASON_GIFT_POWER);
2116     }
2117 
2118     /// @notice A function that will permanently remove eliminated Wizards from the smart contract.
2119     ///
2120     ///         The way that this (and cullMoldedWithMolded()) works isn't entirely obvious, so please settle
2121     ///         down for story time!
2122     ///
2123     ///         The "obvious" solution to eliminating Wizards from the Tournament is to simply delete
2124     ///         them from the wizards mapping when they are beaten into submission (Oh! Sorry! Marketing
2125     ///         team says I should say "tired".) But we can't do this during the revival phase, because
2126     ///         maybe that player wants to revive their Wizard. What's more is that when the Blue Mold
2127     ///         starts, there is no on-chain event that fires when the Blue Mold power level doubles
2128     ///         (which can also lead to Wizard elimination).
2129     ///
2130     ///         The upshot is that we could have a bunch of Wizards sitting around in the wizards mapping
2131     ///         that are below the Blue Mold level, possibly even with a power level of zero. If we can't
2132     ///         get rid of them somehow, we can't know when the Tournament is over (which would make for
2133     ///         a pretty crappy tournament, huh?).
2134     ///
2135     ///         The next obvious solution? If a Wizard is below the Blue Mold level, just let anyone come
2136     ///         along and delete that sucker. Whoa, there, Cowboy! Maybe you should think it through for
2137     ///         a minute before you jump to any conclusions. Give it a minute, you'll see what I mean.
2138     ///
2139     ///         Yup. I knew you'd see it. If we start deleting ALL the Wizards below the Blue Mold level,
2140     ///         there's a not-so-rare edge case where the last two or three or ten Wizards decide not
2141     ///         to fight each other, and they all get molded. Eek! Another great way to make for a crappy
2142     ///         tournament! No winner!
2143     ///
2144     ///         So, if we do end up with ALL of the Wizards molded, how do we resolve the Tournament? Our
2145     ///         solution is to let the 5 most powerful molded Wizards split the pot pro-rata (so, if you have
2146     ///         60% of the total power represented in the 5 winning Wizards, you get 60% of the pot.)
2147     ///
2148     ///         But this puts us in a bit of a pickle. How can we delete a molded Wizard if it might just
2149     ///         be a winner?!
2150     ///
2151     ///         Simple! If someone wants to permanently remove a Wizard from the tournament, they just have
2152     ///         to pass in a reference to _another_ Wizard (or Wizards) that _prove_ that the Wizard they
2153     ///         want to eliminate can't possibly be the winner.
2154     ///
2155     ///         This function handles the simpler of the two cases: If the caller can point to a Wizard
2156     ///         that is _above_ the Blue Mold level, then _any_ Wizard that is below the Blue
2157     ///         mold level can be safely eliminated.
2158     ///
2159     ///         Note that there are no restrictions on who can cull moldy Wizards. Anyone can call, so
2160     ///         long as they have the necessary proof!
2161     /// @param wizardIds A list of moldy Wizards to permanently remove from the Tournament
2162     /// @param survivor The ID of a surviving Wizard, as proof that it's safe to remove those moldy folks
2163     function cullMoldedWithSurvivor(uint256[] calldata wizardIds, uint256 survivor) external
2164         exists(survivor) duringCullingWindow
2165     {
2166         uint256 moldLevel = _blueMoldPower();
2167 
2168         require(wizards[survivor].power >= moldLevel, "Survivor isn't alive");
2169 
2170         for (uint256 i = 0; i < wizardIds.length; i++) {
2171             uint256 wizardId = wizardIds[i];
2172             if (wizards[wizardId].maxPower != 0 && wizards[wizardId].power < moldLevel) {
2173                 _deleteWizard(wizardId);
2174             }
2175         }
2176     }
2177 
2178     /// @notice Another function to remove eliminated Wizards from the smart contract.
2179     ///
2180     ///         Well, partner, it's good to see you back again. I hope you've recently read the comments
2181     ///         on cullMoldedWithSurvivor() because that'll provide you with some much needed context here.
2182     ///
2183     ///         This function handles the other case, what if there IS no unmolded Wizard to point to, how do
2184     ///         you cull the excess moldy Wizards to pare it down to the five final survivors that should split
2185     ///         the pot?
2186     ///
2187     ///         Well, the answer is much the same as before, only instead of pointing to a single example of
2188     ///         a Wizard that has a better claim to the pot, we require that the caller provides a reference
2189     ///         to FIVE other Wizards who have a better claim to the pot.
2190     ///
2191     ///         It would be pretty easy to write this function in a way that was very expensive, so in order
2192     ///         to save ourselves a lot of gas, we require that the list of Wizards is in strictly descending
2193     ///         order of power (if two wizards have identical power levels, we consider the one with the
2194     ///         lower ID as being more powerful).
2195     ///
2196     ///         We also require that the first (i.e. most powerful) Wizard in the list is moldy, even though
2197     ///         it's not going to be eliminated! This may not seem strictly necessary, but it makes the
2198     ///         logic simpler (because then we can just assume that ALL the Wizards are moldy, without any
2199     ///         further checks). If it isn't moldy, the caller should just use the cullMoldedWithSurvivor()
2200     ///         method instead!
2201     ///
2202     ///         "Oh ho!" you say, taking great pleasure in your clever insight. "How can you be so sure that
2203     ///         the first five Wizards passed in as 'leaders' are _actually_ the five most powerful molded
2204     ///         Wizards?" Well, my dear friend... you are right: We can't!
2205     ///
2206     ///         However it turns out that's actually fine! If the caller (for some reason) decides to start the list
2207     ///         with the Wizards ranked 6-10 in the Tournament, they can do it that and we'd never know the
2208     ///         difference.... Except that's not actually a problem, because they'd still only be able to remove
2209     ///         molded Wizards ranked 11th or higher, all of which are due for removal anyway. (It's the same
2210     ///         argument that we don't actually know -- inside this function -- if there's a non-molded Wizard;
2211     ///         it's still safe to allow the caller to eliminate molded Wizards ranked 6th or higher.)
2212     /// @param moldyWizardIds A list of moldy Wizards, in strictly decreasing power order. Entries 5+ in this list
2213     ///         will be permanently removed from the Tournament
2214     function cullMoldedWithMolded(uint256[] calldata moldyWizardIds) external duringCullingWindow {
2215         require(moldyWizardIds.length > 0, "Empty ids");
2216 
2217         uint256 currentId;
2218         uint256 currentPower;
2219         uint256 previousId = moldyWizardIds[0];
2220         uint256 previousPower = wizards[previousId].power;
2221 
2222         // It's dumb to call this function with fewer than 5 wizards, but nothing bad will happen
2223         // so we don't waste gas preventing it.
2224         // require(moldyWizardsIds.length > 5, "No wizards to eliminate");
2225 
2226         require(previousPower < _blueMoldPower(), "Not moldy");
2227         // The power of a dueling molded Wizard isn't finalized. So shouldn't be used for culling other wizards.
2228         require(wizards[previousId].currentDuel == 0, "Dueling");
2229 
2230         for (uint256 i = 1; i < moldyWizardIds.length; i++) {
2231             currentId = moldyWizardIds[i];
2232             checkExists(currentId);
2233             currentPower = wizards[currentId].power;
2234 
2235             // Confirm that this new Wizard has a worse claim on the prize than the previous Wizard
2236             require(
2237                 (currentPower < previousPower) ||
2238                 ((currentPower == previousPower) && (currentId > previousId)),
2239                 "Wizards not strictly ordered");
2240 
2241             if (i >= 5) {
2242                 _deleteWizard(currentId);
2243             } else {
2244                 // Preventing a dueling molded wizards from culling other wizards.
2245                 require(wizards[currentId].currentDuel == 0, "Dueling");
2246             }
2247 
2248             previousId = currentId;
2249             previousPower = currentPower;
2250         }
2251     }
2252 
2253     // @notice Utility function to delete a wizard from storage.
2254     //         It makes sure the wizard is not current dueling,
2255     //         because deleting a dueling wizard will lock the other wizard forever.
2256     function _deleteWizard(uint256 wizardId) internal {
2257         require(wizards[wizardId].currentDuel == 0, "Wizard is dueling");
2258         delete wizards[wizardId];
2259         remainingWizards--;
2260         emit WizardElimination(wizardId);
2261     }
2262 
2263     /// @notice One last culling function that simply removes Wizards with zero power. They can't
2264     ///         even get a cut of the final pot... (Worth noting: Culling Windows are only available
2265     ///         during the Elimination Phase, so even Wizards that go to zero can't be removed during
2266     ///         the Revival Phase.)
2267     function cullTiredWizards(uint256[] calldata wizardIds) external duringCullingWindow {
2268         for (uint256 i = 0; i < wizardIds.length; i++) {
2269             uint256 wizardId = wizardIds[i];
2270             if (wizards[wizardId].maxPower != 0 && wizards[wizardId].power == 0) {
2271                 _deleteWizard(wizardId);
2272             }
2273         }
2274     }
2275 
2276     /// @notice This is a pretty important function! When the Tournament has a single remaining Wizard left
2277     ///         we can send them ALL of the funds in this smart contract. Notice that we don't actually check
2278     ///         to see if the claimant is moldy: If there is a single remaining Wizard in the Tournament, they
2279     ///         get to take the pot, regardless of the mold level.
2280     function claimTheBigCheeze(uint256 claimingWinnerId) external duringCullingWindow onlyWizardController(claimingWinnerId) {
2281         require(remainingWizards == 1, "Keep fighting!");
2282 
2283         // They did it! They were the final survivor. They get all the money!
2284         emit PrizeClaimed(claimingWinnerId, address(this).balance);
2285 
2286         remainingWizards = 0;
2287         delete wizards[claimingWinnerId];
2288 
2289         msg.sender.transfer(address(this).balance);
2290     }
2291 
2292     /// @notice A function that allows one of the 5 most powerful Wizards to claim their pro-rata share of
2293     ///         the pot if the Tournament ends with all Wizards succumbing to the Blue Mold. Note that
2294     ///         all but five of the Moldy Wizards need to first be eliminated with cullMoldedWithMolded().
2295     ///
2296     ///         It might seem like it would be tricky to split the pot one player at a time. Imagine that
2297     ///         there are just three winners, with power levels 20, 30, and 50. If the third player claims
2298     ///         first, they will get 50% of the (remaining) pot, but if they claim last, they will get
2299     ///         100% of the remaining pot! If you run some examples, you'll see that by decreasing the pot
2300     ///         size by a value exactly proportional to the power of the removed Wizard, everyone gets
2301     ///         the same amount of winnings, regardless of the order in which they claim (plus or minus
2302     ///         a wei or two due to rounding).
2303     /// @param claimingWinnerId The Wizard who's share is currently being claimed
2304     /// @param allWinners The complete set of all remaining Wizards in the tournament. This set MUST
2305     ///                   be ordered by ascending ID.
2306     function claimSharedWinnings(uint256 claimingWinnerId, uint256[] calldata allWinners)
2307         external duringCullingWindow onlyWizardController(claimingWinnerId)
2308     {
2309         require(remainingWizards <= 5, "Too soon to claim");
2310         require(remainingWizards == allWinners.length, "Must provide all winners");
2311         require(wizards[claimingWinnerId].power != 0, "No cheeze for you!");
2312 
2313         uint256 moldLevel = _blueMoldPower();
2314         uint256 totalPower = 0;
2315         uint256 lastWizard = 0;
2316 
2317         // Check to see that all of the remaining Wizards are molded and not yet eliminated,
2318         // assuming they are, keep track of the total power level of the remaining entrants
2319         for (uint256 i = 0; i < allWinners.length; i++) {
2320             uint256 wizardId = allWinners[i];
2321             uint256 wizardPower = wizards[wizardId].power;
2322 
2323             require(wizardId > lastWizard, "Winners not unique and ordered");
2324             require(wizards[wizardId].maxPower != 0, "Wizard already eliminated");
2325             require(wizardPower < moldLevel, "Wizard not moldy");
2326 
2327             lastWizard = wizardId;
2328             totalPower += wizardPower;
2329         }
2330 
2331         uint256 claimingWinnerShare = address(this).balance * wizards[claimingWinnerId].power / totalPower;
2332 
2333         // Be sure to delete their claim on the prize before sending them the balance!
2334         delete wizards[claimingWinnerId];
2335         remainingWizards--;
2336 
2337         emit PrizeClaimed(claimingWinnerId, claimingWinnerShare);
2338 
2339         msg.sender.transfer(claimingWinnerShare);
2340     }
2341 
2342     /// @notice Allows the GateKeeper to destroy this contract if it's not needed anymore.
2343     function destroy() external onlyGateKeeper {
2344         require(isActive() == false);
2345 
2346         selfdestruct(msg.sender);
2347     }
2348 }