1 pragma solidity ^0.4.25;
2 
3 /// @dev Interface required by league roster contract to access
4 /// the mintPlayers(...) function
5 interface CSportsRosterInterface {
6 
7     /// @dev Called by core contract as a sanity check
8     function isLeagueRosterContract() external pure returns (bool);
9 
10     /// @dev Called to indicate that a commissioner auction has completed
11     function commissionerAuctionComplete(uint32 _rosterIndex, uint128 _price) external;
12 
13     /// @dev Called to indicate that a commissioner auction was canceled
14     function commissionerAuctionCancelled(uint32 _rosterIndex) external view;
15 
16     /// @dev Returns the metadata for a specific real world player token
17     function getMetadata(uint128 _md5Token) external view returns (string);
18 
19     /// @dev Called to return a roster index given the MD5
20     function getRealWorldPlayerRosterIndex(uint128 _md5Token) external view returns (uint128);
21 
22     /// @dev Returns a player structure given its index
23     function realWorldPlayerFromIndex(uint128 idx) external view returns (uint128 md5Token, uint128 prevCommissionerSalePrice, uint64 lastMintedTime, uint32 mintedCount, bool hasActiveCommissionerAuction, bool mintingEnabled);
24 
25     /// @dev Called to update a real world player entry - only used dureing development
26     function updateRealWorldPlayer(uint32 _rosterIndex, uint128 _prevCommissionerSalePrice, uint64 _lastMintedTime, uint32 _mintedCount, bool _hasActiveCommissionerAuction, bool _mintingEnabled) external;
27 
28 }
29 
30 /// @title A facet of CSportsCore that holds all important constants and modifiers
31 /// @author CryptoSports, Inc. (https://cryptosports.team))
32 /// @dev See the CSportsCore contract documentation to understand how the various CSports contract facets are arranged.
33 contract CSportsConstants {
34 
35     /// @dev The maximum # of marketing tokens that can ever be created
36     /// by the commissioner.
37     uint16 public MAX_MARKETING_TOKENS = 2500;
38 
39     /// @dev The starting price for commissioner auctions (if the average
40     ///   of the last 2 is less than this, we will use this value)
41     ///   A finney is 1/1000 of an ether.
42     uint256 public COMMISSIONER_AUCTION_FLOOR_PRICE = 5 finney; // 5 finney for production, 15 for script testing and 1 finney for Rinkeby
43 
44     /// @dev The duration of commissioner auctions
45     uint256 public COMMISSIONER_AUCTION_DURATION = 14 days; // 30 days for testing;
46 
47     /// @dev Number of seconds in a week
48     uint32 constant WEEK_SECS = 1 weeks;
49 
50 }
51 
52 /// @title A facet of CSportsCore that manages an individual's authorized role against access privileges.
53 /// @author CryptoSports, Inc. (https://cryptosports.team))
54 /// @dev See the CSportsCore contract documentation to understand how the various CSports contract facets are arranged.
55 contract CSportsAuth is CSportsConstants {
56     // This facet controls access control for CryptoSports. There are four roles managed here:
57     //
58     //     - The CEO: The CEO can reassign other roles and change the addresses of our dependent smart
59     //         contracts. It is also the only role that can unpause the smart contract. It is initially
60     //         set to the address that created the smart contract in the CSportsCore constructor.
61     //
62     //     - The CFO: The CFO can withdraw funds from CSportsCore and its auction contracts.
63     //
64     //     - The COO: The COO can perform administrative functions.
65     //
66     //     - The Commisioner can perform "oracle" functions like adding new real world players,
67     //       setting players active/inactive, and scoring contests.
68     //
69 
70     /// @dev Emited when contract is upgraded - See README.md for updgrade plan
71     event ContractUpgrade(address newContract);
72 
73     /// The addresses of the accounts (or contracts) that can execute actions within each roles.
74     address public ceoAddress;
75     address public cfoAddress;
76     address public cooAddress;
77     address public commissionerAddress;
78 
79     /// @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
80     bool public paused = false;
81 
82     /// @dev Flag that identifies whether or not we are in development and should allow development
83     /// only functions to be called.
84     bool public isDevelopment = true;
85 
86     /// @dev Access modifier to allow access to development mode functions
87     modifier onlyUnderDevelopment() {
88       require(isDevelopment == true);
89       _;
90     }
91 
92     /// @dev Access modifier for CEO-only functionality
93     modifier onlyCEO() {
94         require(msg.sender == ceoAddress);
95         _;
96     }
97 
98     /// @dev Access modifier for CFO-only functionality
99     modifier onlyCFO() {
100         require(msg.sender == cfoAddress);
101         _;
102     }
103 
104     /// @dev Access modifier for COO-only functionality
105     modifier onlyCOO() {
106         require(msg.sender == cooAddress);
107         _;
108     }
109 
110     /// @dev Access modifier for Commissioner-only functionality
111     modifier onlyCommissioner() {
112         require(msg.sender == commissionerAddress);
113         _;
114     }
115 
116     /// @dev Requires any one of the C level addresses
117     modifier onlyCLevel() {
118         require(
119             msg.sender == cooAddress ||
120             msg.sender == ceoAddress ||
121             msg.sender == cfoAddress ||
122             msg.sender == commissionerAddress
123         );
124         _;
125     }
126 
127     /// @dev prevents contracts from hitting the method
128     modifier notContract() {
129         address _addr = msg.sender;
130         uint256 _codeLength;
131 
132         assembly {_codeLength := extcodesize(_addr)}
133         require(_codeLength == 0);
134         _;
135     }
136 
137     /// @dev One way switch to set the contract into prodution mode. This is one
138     /// way in that the contract can never be set back into development mode. Calling
139     /// this function will block all future calls to functions that are meant for
140     /// access only while we are under development. It will also enable more strict
141     /// additional checking on various parameters and settings.
142     function setProduction() public onlyCEO onlyUnderDevelopment {
143       isDevelopment = false;
144     }
145 
146     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
147     /// @param _newCEO The address of the new CEO
148     function setCEO(address _newCEO) public onlyCEO {
149         require(_newCEO != address(0));
150         ceoAddress = _newCEO;
151     }
152 
153     /// @dev Assigns a new address to act as the CFO. Only available to the current CEO.
154     /// @param _newCFO The address of the new CFO
155     function setCFO(address _newCFO) public onlyCEO {
156         require(_newCFO != address(0));
157 
158         cfoAddress = _newCFO;
159     }
160 
161     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
162     /// @param _newCOO The address of the new COO
163     function setCOO(address _newCOO) public onlyCEO {
164         require(_newCOO != address(0));
165 
166         cooAddress = _newCOO;
167     }
168 
169     /// @dev Assigns a new address to act as the Commissioner. Only available to the current CEO.
170     /// @param _newCommissioner The address of the new COO
171     function setCommissioner(address _newCommissioner) public onlyCEO {
172         require(_newCommissioner != address(0));
173 
174         commissionerAddress = _newCommissioner;
175     }
176 
177     /// @dev Assigns all C-Level addresses
178     /// @param _ceo CEO address
179     /// @param _cfo CFO address
180     /// @param _coo COO address
181     /// @param _commish Commissioner address
182     function setCLevelAddresses(address _ceo, address _cfo, address _coo, address _commish) public onlyCEO {
183         require(_ceo != address(0));
184         require(_cfo != address(0));
185         require(_coo != address(0));
186         require(_commish != address(0));
187         ceoAddress = _ceo;
188         cfoAddress = _cfo;
189         cooAddress = _coo;
190         commissionerAddress = _commish;
191     }
192 
193     /// @dev Transfers the balance of this contract to the CFO
194     function withdrawBalance() external onlyCFO {
195         cfoAddress.transfer(address(this).balance);
196     }
197 
198     /*** Pausable functionality adapted from OpenZeppelin ***/
199 
200     /// @dev Modifier to allow actions only when the contract IS NOT paused
201     modifier whenNotPaused() {
202         require(!paused);
203         _;
204     }
205 
206     /// @dev Modifier to allow actions only when the contract IS paused
207     modifier whenPaused {
208         require(paused);
209         _;
210     }
211 
212     /// @dev Called by any "C-level" role to pause the contract. Used only when
213     ///  a bug or exploit is detected and we need to limit damage.
214     function pause() public onlyCLevel whenNotPaused {
215         paused = true;
216     }
217 
218     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
219     ///  one reason we may pause the contract is when CFO or COO accounts are
220     ///  compromised.
221     function unpause() public onlyCEO whenPaused {
222         paused = false;
223     }
224 }
225 
226 /// @title CSportsTeam Interface
227 /// @dev This interface defines methods required by the CSportsContestCore
228 ///   in implementing a contest.
229 /// @author CryptoSports
230 contract CSportsTeam {
231 
232     bool public isTeamContract;
233 
234     /// @dev Define team events
235     event TeamCreated(uint256 teamId, address owner);
236     event TeamUpdated(uint256 teamId);
237     event TeamReleased(uint256 teamId);
238     event TeamScored(uint256 teamId, int32 score, uint32 place);
239     event TeamPaid(uint256 teamId);
240 
241     function setCoreContractAddress(address _address) public;
242     function setLeagueRosterContractAddress(address _address) public;
243     function setContestContractAddress(address _address) public;
244     function createTeam(address _owner, uint32[] _tokenIds) public returns (uint32);
245     function updateTeam(address _owner, uint32 _teamId, uint8[] _indices, uint32[] _tokenIds) public;
246     function releaseTeam(uint32 _teamId) public;
247     function getTeamOwner(uint32 _teamId) public view returns (address);
248     function scoreTeams(uint32[] _teamIds, int32[] _scores, uint32[] _places) public;
249     function getScore(uint32 _teamId) public view returns (int32);
250     function getPlace(uint32 _teamId) public view returns (uint32);
251     function ownsPlayerTokens(uint32 _teamId) public view returns (bool);
252     function refunded(uint32 _teamId) public;
253     function tokenIdsForTeam(uint32 _teamId) public view returns (uint32, uint32[50]);
254     function getTeam(uint32 _teamId) public view returns (
255         address _owner,
256         int32 _score,
257         uint32 _place,
258         bool _holdsEntryFee,
259         bool _ownsPlayerTokens);
260 }
261 
262 /// @title CSportsContestBase base class for contests and teams contracts
263 /// @dev This interface defines base class for contests and teams contracts
264 /// @author CryptoSports
265 contract CSportsContestBase {
266 
267     /// @dev Structure holding the player token IDs for a team
268     struct Team {
269       address owner;              // Address of the owner of the player tokens
270       int32 score;                // Score assigned to this team after a contest
271       uint32 place;               // Place this team finished in its contest
272       bool holdsEntryFee;         // TRUE if this team currently holds an entry fee
273       bool ownsPlayerTokens;      // True if the tokens are being escrowed by the Team contract
274       uint32[] playerTokenIds;    // IDs of the tokens held by this team
275     }
276 
277 }
278 
279 /// @dev Interface required by league roster contract to access
280 /// the mintPlayers(...) function
281 interface CSportsCoreInterface {
282 
283     /// @dev Called as a sanity check to make sure we have linked the core contract
284     function isCoreContract() external pure returns (bool);
285 
286     /// @dev Escrows all of the tokensIds passed by transfering ownership
287     ///   to the teamContract. CAN ONLY BE CALLED BY THE CURRENT TEAM CONTRACT.
288     /// @param _owner - Current owner of the token being authorized for transfer
289     /// @param _tokenIds The IDs of the PlayerTokens that can be transferred if this call succeeds.
290     function batchEscrowToTeamContract(address _owner, uint32[] _tokenIds) external;
291 
292     /// @dev Change or reaffirm the approved address for an NFT
293     /// @dev The zero address indicates there is no approved address.
294     ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
295     ///  operator of the current owner.
296     /// @param _to The new approved NFT controller
297     /// @param _tokenId The NFT to approve
298     function approve(address _to, uint256 _tokenId) external;
299 
300     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
301     ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
302     ///  THEY MAY BE PERMANENTLY LOST
303     /// @dev Throws unless `msg.sender` is the current owner, an authorized
304     ///  operator, or the approved address for this NFT. Throws if `_from` is
305     ///  not the current owner. Throws if `_to` is the zero address. Throws if
306     ///  `_tokenId` is not a valid NFT.
307     /// @param _from The current owner of the NFT
308     /// @param _to The new owner
309     /// @param _tokenId The NFT to transfer
310     function transferFrom(address _from, address _to, uint256 _tokenId) external;
311 }
312 /// @title Generic CSports Team Contract
313 /// @dev Implementation of interface CSportsTeam for a generic team contract
314 /// that supports a variable # players per team (set in constructor)
315 contract CSportsTeamGeneric is CSportsAuth, CSportsTeam,  CSportsContestBase {
316 
317   /// STORAGE
318 
319   /// @dev Reference to core contract ownership of player tokens
320   CSportsCoreInterface public coreContract;
321 
322   /// @dev Reference to contest contract ownership of player tokens
323   address public contestContractAddress;
324 
325   /// @dev Instance of our CSportsLeagueRoster contract. Can be set by
326   ///   the CEO.
327   CSportsRosterInterface public leagueRosterContract;
328 
329   // Next team ID to assign
330   uint64 uniqueTeamId;
331 
332   // Number of players on a team
333   uint32 playersPerTeam;
334 
335   /// @dev Structure to hold our active teams
336   mapping (uint32 => Team) teamIdToTeam;
337 
338   /// PUBLIC METHODS
339 
340   /// @dev Class constructor creates the main CSportsTeamMlb smart contract instance.
341   constructor(uint32 _playersPerTeam) public {
342 
343       // All C-level roles are the message sender
344       ceoAddress = msg.sender;
345       cfoAddress = msg.sender;
346       cooAddress = msg.sender;
347       commissionerAddress = msg.sender;
348 
349       // Notice our uniqueTeamId starts at 1, making a 0 value indicate
350       // a non-existent team.
351       uniqueTeamId = 1;
352 
353       // Initialize parent properties
354       isTeamContract = true;
355 
356       // Players per team
357       playersPerTeam = _playersPerTeam;
358   }
359 
360   /// @dev Sets the contestContractAddress that we interact with
361   /// @param _address - Address of our contest contract
362   function setContestContractAddress(address _address) public onlyCEO {
363     contestContractAddress = _address;
364   }
365 
366   /// @dev Sets the coreContract that we interact with
367   /// @param _address - Address of our core contract
368   function setCoreContractAddress(address _address) public onlyCEO {
369     CSportsCoreInterface candidateContract = CSportsCoreInterface(_address);
370     require(candidateContract.isCoreContract());
371     coreContract = candidateContract;
372   }
373 
374   /// @dev Sets the leagueRosterContract that we interact with
375   /// @param _address - The address of our league roster contract
376   function setLeagueRosterContractAddress(address _address) public onlyCEO {
377     CSportsRosterInterface candidateContract = CSportsRosterInterface(_address);
378     require(candidateContract.isLeagueRosterContract());
379     leagueRosterContract = candidateContract;
380   }
381 
382   /// @dev Consolidates setting of contract links into a single call for deployment expediency
383   function setLeagueRosterAndCoreAndContestContractAddress(address _league, address _core, address _contest) public onlyCEO {
384     setLeagueRosterContractAddress(_league);
385     setCoreContractAddress(_core);
386     setContestContractAddress(_contest);
387   }
388 
389   /// @dev Called to create a team for use in CSports.
390   ///   _escrow(...) Verifies that all of the tokens presented
391   ///   are owned by the sender, and transfers ownership to this contract. This
392   ///   assures that the PlayerTokens cannot be sold in an auction, or entered
393   ///   into a different contest. CALLED ONLY BY CONTEST CONTRACT
394   ///
395   ///   Also note that the size of the _tokenIds array passed must be 10. This is
396   ///   particular to the kind of contest we are running (10 players fielded).
397   /// @param _owner - Owner of the team, must own all of the player tokens being
398   ///   associated with the team.
399   /// @param _tokenIds - Player token IDs to associate with the team, must be owned
400   ///   by _owner and will be held in escrow unless released through an update
401   ///   or the team is destroyed.
402   function createTeam(address _owner, uint32[] _tokenIds) public returns (uint32) {
403     require(msg.sender == contestContractAddress);
404     require(_tokenIds.length == playersPerTeam);
405 
406     // Escrow the player tokens held by this team
407     // it will throw if _owner does not own any of the tokens or this CSportsTeam contract
408     // has not been set in the CSportsCore contract.
409     coreContract.batchEscrowToTeamContract(_owner, _tokenIds);
410 
411     uint32 _teamId =  _createTeam(_owner, _tokenIds);
412 
413     emit TeamCreated(_teamId, _owner);
414 
415     return _teamId;
416   }
417 
418   /// @dev Upates the player tokens held by a specific team. Throws if the
419   ///   message sender does not own the team, or if the team does not
420   ///   exist. CALLED ONLY BY CONTEST CONTRACT
421   /// @param _owner - Owner of the team
422   /// @param _teamId - ID of the team we wish to update
423   /// @param _indices - Indices of playerTokens to be replaced
424   /// @param _tokenIds - Array of player token IDs that will replace those
425   ///   currently held at the indices specified.
426   function updateTeam(address _owner, uint32 _teamId, uint8[] _indices, uint32[] _tokenIds) public {
427     require(msg.sender == contestContractAddress);
428     require(_owner != address(0));
429     require(_tokenIds.length <= playersPerTeam);
430     require(_indices.length <= playersPerTeam);
431     require(_indices.length == _tokenIds.length);
432 
433     Team storage _team = teamIdToTeam[_teamId];
434     require(_owner == _team.owner);
435 
436     // Escrow the player tokens that will replace those in the team currently -
437     // it will throw if _owner does not own any of the tokens or this CSportsTeam contract
438     // has not been set in the CSportsCore contract.
439     coreContract.batchEscrowToTeamContract(_owner, _tokenIds);
440 
441     // Loop through the indices we are updating, and make the update
442     for (uint8 i = 0; i < _indices.length; i++) {
443       require(_indices[i] <= playersPerTeam);
444 
445       uint256 _oldTokenId = uint256(_team.playerTokenIds[_indices[i]]);
446       uint256 _newTokenId = _tokenIds[i];
447 
448       // Release the _oldToken back to its original owner.
449       // (note _owner == _team.owner == original owner of token we are returning)
450       coreContract.approve(_owner, _oldTokenId);
451       coreContract.transferFrom(address(this), _owner, _oldTokenId);
452 
453       // Update the token ID in the team at the same index as the player token removed.
454       _team.playerTokenIds[_indices[i]] = uint32(_newTokenId);
455 
456     }
457 
458     emit TeamUpdated(_teamId);
459   }
460 
461   /// @dev Releases the team by returning all of the tokens held by the team and removing
462   ///   the team from our mapping. CALLED ONLY BY CONTEST CONTRACT
463   /// @param _teamId - team id of the team being destroyed
464   function releaseTeam(uint32 _teamId) public {
465 
466     require(msg.sender == contestContractAddress);
467     Team storage _team = teamIdToTeam[_teamId];
468     require(_team.owner != address(0));
469 
470     if (_team.ownsPlayerTokens) {
471       // Loop through all of the player tokens held by the team, and
472       // release them back to the original owner.
473       for (uint32 i = 0; i < _team.playerTokenIds.length; i++) {
474         uint32 _tokenId = _team.playerTokenIds[i];
475         coreContract.approve(_team.owner, _tokenId);
476         coreContract.transferFrom(address(this), _team.owner, _tokenId);
477       }
478 
479       // This team's player tokens are no longer held in escrow
480       _team.ownsPlayerTokens = false;
481 
482       emit TeamReleased(_teamId);
483     }
484 
485   }
486 
487   /// @dev Marks the team as having its entry fee refunded
488   ///   CALLED ONLY BY CONTEST CONTRACT
489   /// @param _teamId - ID of team to refund entry fee.
490   function refunded(uint32 _teamId) public {
491     require(msg.sender == contestContractAddress);
492     Team storage _team = teamIdToTeam[_teamId];
493     require(_team.owner != address(0));
494     _team.holdsEntryFee = false;
495   }
496 
497   /// @dev Assigns a score and place for an array of teams. The indexes into the
498   ///   arrays are what tie a particular teamId to score and place.
499   ///   CALLED ONLY BY CONTEST CONTRACT
500   /// @param _teamIds - IDs of the teams we are scoring
501   /// @param _scores - Scores to assign
502   /// @param _places - Places to assign
503   function scoreTeams(uint32[] _teamIds, int32[] _scores, uint32[] _places) public {
504 
505     require(msg.sender == contestContractAddress);
506     require ((_teamIds.length == _scores.length) && (_teamIds.length == _places.length)) ;
507     for (uint i = 0; i < _teamIds.length; i++) {
508       Team storage _team = teamIdToTeam[_teamIds[i]];
509       if (_team.owner != address(0)) {
510         _team.score = _scores[i];
511         _team.place = _places[i];
512       }
513     }
514   }
515 
516   /// @dev Returns the score assigned to a particular team.
517   /// @param _teamId ID of the team we are inquiring about
518   function getScore(uint32 _teamId) public view returns (int32) {
519     Team storage _team = teamIdToTeam[_teamId];
520     require(_team.owner != address(0));
521     return _team.score;
522   }
523 
524   /// @dev Returns the place assigned to a particular team.
525   /// @param _teamId ID of the team we are inquiring about
526   function getPlace(uint32 _teamId) public view returns (uint32) {
527     Team storage _team = teamIdToTeam[_teamId];
528     require(_team.owner != address(0));
529     return _team.place;
530   }
531 
532   /// @dev Returns whether or not this team owns the player tokens it
533   ///   references in the playerTokenIds property.
534   /// @param _teamId ID of the team we are inquiring about
535   function ownsPlayerTokens(uint32 _teamId) public view returns (bool) {
536     Team storage _team = teamIdToTeam[_teamId];
537     require(_team.owner != address(0));
538     return _team.ownsPlayerTokens;
539   }
540 
541   /// @dev Returns the owner of a specific team
542   /// @param _teamId - ID of team we are inquiring about
543   function getTeamOwner(uint32 _teamId) public view returns (address) {
544     Team storage _team = teamIdToTeam[_teamId];
545     require(_team.owner != address(0));
546     return _team.owner;
547   }
548 
549   /// @dev Returns all of the token id held by a particular team. Throws if the
550   ///   _teamId isn't valid. Anybody can call this, making teams visible to the
551   ///   world.
552   /// @param _teamId - ID of the team we are looking to get player tokens for.
553   function tokenIdsForTeam(uint32 _teamId) public view returns (uint32 count, uint32[50]) {
554 
555      /// @dev A fixed array we can return current auction price information in.
556      uint32[50] memory _tokenIds;
557 
558      Team storage _team = teamIdToTeam[_teamId];
559      require(_team.owner != address(0));
560 
561      for (uint32 i = 0; i < _team.playerTokenIds.length; i++) {
562        _tokenIds[i] = _team.playerTokenIds[i];
563      }
564 
565      return (uint32(_team.playerTokenIds.length), _tokenIds);
566   }
567 
568   /// @dev Returns the entire team structure (less the token IDs) for a specific team
569   /// @param _teamId - ID of team we are inquiring about
570   function getTeam(uint32 _teamId) public view returns (
571       address _owner,
572       int32 _score,
573       uint32 _place,
574       bool _holdsEntryFee,
575       bool _ownsPlayerTokens
576     ) {
577     Team storage t = teamIdToTeam[_teamId];
578     require(t.owner != address(0));
579     _owner = t.owner;
580     _score = t.score;
581     _place = t.place;
582     _holdsEntryFee = t.holdsEntryFee;
583     _ownsPlayerTokens = t.ownsPlayerTokens;
584   }
585 
586   /// INTERNAL METHODS
587 
588   /// @dev Internal function that creates a new team entry. We know that the
589   ///   size of the _tokenIds array is correct at this point (checked in calling method)
590   /// @param _owner - Account address of team owner (should own all _playerTokenIds)
591   /// @param _playerTokenIds - Token IDs of team players
592   function _createTeam(address _owner, uint32[] _playerTokenIds) internal returns (uint32) {
593 
594     Team memory _team = Team({
595       owner: _owner,
596       score: 0,
597       place: 0,
598       holdsEntryFee: true,
599       ownsPlayerTokens: true,
600       playerTokenIds: _playerTokenIds
601     });
602 
603     uint32 teamIdToReturn = uint32(uniqueTeamId);
604     teamIdToTeam[teamIdToReturn] = _team;
605 
606     // Increment our team ID for the next one.
607     uniqueTeamId++;
608 
609     // It's probably never going to happen, 4 billion teams is A LOT, but
610     // let's just be 100% sure we never let this happen because teamIds are
611     // often cast as uint32.
612     require(uniqueTeamId < 4294967295);
613 
614     // We should do additional validation on the team here (like are the player
615     // positions correct, etc.)
616 
617     return teamIdToReturn;
618   }
619 
620 }