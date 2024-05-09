1 pragma solidity ^0.4.25;
2 
3 /// @title A facet of CSportsCore that holds all important constants and modifiers
4 /// @author CryptoSports, Inc. (https://cryptosports.team))
5 /// @dev See the CSportsCore contract documentation to understand how the various CSports contract facets are arranged.
6 contract CSportsConstants {
7 
8     /// @dev The maximum # of marketing tokens that can ever be created
9     /// by the commissioner.
10     uint16 public MAX_MARKETING_TOKENS = 2500;
11 
12     /// @dev The starting price for commissioner auctions (if the average
13     ///   of the last 2 is less than this, we will use this value)
14     ///   A finney is 1/1000 of an ether.
15     uint256 public COMMISSIONER_AUCTION_FLOOR_PRICE = 5 finney; // 5 finney for production, 15 for script testing and 1 finney for Rinkeby
16 
17     /// @dev The duration of commissioner auctions
18     uint256 public COMMISSIONER_AUCTION_DURATION = 14 days; // 30 days for testing;
19 
20     /// @dev Number of seconds in a week
21     uint32 constant WEEK_SECS = 1 weeks;
22 
23 }
24 
25 /// @title A facet of CSportsCore that manages an individual's authorized role against access privileges.
26 /// @author CryptoSports, Inc. (https://cryptosports.team))
27 /// @dev See the CSportsCore contract documentation to understand how the various CSports contract facets are arranged.
28 contract CSportsAuth is CSportsConstants {
29     // This facet controls access control for CryptoSports. There are four roles managed here:
30     //
31     //     - The CEO: The CEO can reassign other roles and change the addresses of our dependent smart
32     //         contracts. It is also the only role that can unpause the smart contract. It is initially
33     //         set to the address that created the smart contract in the CSportsCore constructor.
34     //
35     //     - The CFO: The CFO can withdraw funds from CSportsCore and its auction contracts.
36     //
37     //     - The COO: The COO can perform administrative functions.
38     //
39     //     - The Commisioner can perform "oracle" functions like adding new real world players,
40     //       setting players active/inactive, and scoring contests.
41     //
42 
43     /// @dev Emited when contract is upgraded - See README.md for updgrade plan
44     event ContractUpgrade(address newContract);
45 
46     /// The addresses of the accounts (or contracts) that can execute actions within each roles.
47     address public ceoAddress;
48     address public cfoAddress;
49     address public cooAddress;
50     address public commissionerAddress;
51 
52     /// @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
53     bool public paused = false;
54 
55     /// @dev Flag that identifies whether or not we are in development and should allow development
56     /// only functions to be called.
57     bool public isDevelopment = true;
58 
59     /// @dev Access modifier to allow access to development mode functions
60     modifier onlyUnderDevelopment() {
61       require(isDevelopment == true);
62       _;
63     }
64 
65     /// @dev Access modifier for CEO-only functionality
66     modifier onlyCEO() {
67         require(msg.sender == ceoAddress);
68         _;
69     }
70 
71     /// @dev Access modifier for CFO-only functionality
72     modifier onlyCFO() {
73         require(msg.sender == cfoAddress);
74         _;
75     }
76 
77     /// @dev Access modifier for COO-only functionality
78     modifier onlyCOO() {
79         require(msg.sender == cooAddress);
80         _;
81     }
82 
83     /// @dev Access modifier for Commissioner-only functionality
84     modifier onlyCommissioner() {
85         require(msg.sender == commissionerAddress);
86         _;
87     }
88 
89     /// @dev Requires any one of the C level addresses
90     modifier onlyCLevel() {
91         require(
92             msg.sender == cooAddress ||
93             msg.sender == ceoAddress ||
94             msg.sender == cfoAddress ||
95             msg.sender == commissionerAddress
96         );
97         _;
98     }
99 
100     /// @dev prevents contracts from hitting the method
101     modifier notContract() {
102         address _addr = msg.sender;
103         uint256 _codeLength;
104 
105         assembly {_codeLength := extcodesize(_addr)}
106         require(_codeLength == 0);
107         _;
108     }
109 
110     /// @dev One way switch to set the contract into prodution mode. This is one
111     /// way in that the contract can never be set back into development mode. Calling
112     /// this function will block all future calls to functions that are meant for
113     /// access only while we are under development. It will also enable more strict
114     /// additional checking on various parameters and settings.
115     function setProduction() public onlyCEO onlyUnderDevelopment {
116       isDevelopment = false;
117     }
118 
119     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
120     /// @param _newCEO The address of the new CEO
121     function setCEO(address _newCEO) public onlyCEO {
122         require(_newCEO != address(0));
123         ceoAddress = _newCEO;
124     }
125 
126     /// @dev Assigns a new address to act as the CFO. Only available to the current CEO.
127     /// @param _newCFO The address of the new CFO
128     function setCFO(address _newCFO) public onlyCEO {
129         require(_newCFO != address(0));
130 
131         cfoAddress = _newCFO;
132     }
133 
134     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
135     /// @param _newCOO The address of the new COO
136     function setCOO(address _newCOO) public onlyCEO {
137         require(_newCOO != address(0));
138 
139         cooAddress = _newCOO;
140     }
141 
142     /// @dev Assigns a new address to act as the Commissioner. Only available to the current CEO.
143     /// @param _newCommissioner The address of the new COO
144     function setCommissioner(address _newCommissioner) public onlyCEO {
145         require(_newCommissioner != address(0));
146 
147         commissionerAddress = _newCommissioner;
148     }
149 
150     /// @dev Assigns all C-Level addresses
151     /// @param _ceo CEO address
152     /// @param _cfo CFO address
153     /// @param _coo COO address
154     /// @param _commish Commissioner address
155     function setCLevelAddresses(address _ceo, address _cfo, address _coo, address _commish) public onlyCEO {
156         require(_ceo != address(0));
157         require(_cfo != address(0));
158         require(_coo != address(0));
159         require(_commish != address(0));
160         ceoAddress = _ceo;
161         cfoAddress = _cfo;
162         cooAddress = _coo;
163         commissionerAddress = _commish;
164     }
165 
166     /// @dev Transfers the balance of this contract to the CFO
167     function withdrawBalance() external onlyCFO {
168         cfoAddress.transfer(address(this).balance);
169     }
170 
171     /*** Pausable functionality adapted from OpenZeppelin ***/
172 
173     /// @dev Modifier to allow actions only when the contract IS NOT paused
174     modifier whenNotPaused() {
175         require(!paused);
176         _;
177     }
178 
179     /// @dev Modifier to allow actions only when the contract IS paused
180     modifier whenPaused {
181         require(paused);
182         _;
183     }
184 
185     /// @dev Called by any "C-level" role to pause the contract. Used only when
186     ///  a bug or exploit is detected and we need to limit damage.
187     function pause() public onlyCLevel whenNotPaused {
188         paused = true;
189     }
190 
191     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
192     ///  one reason we may pause the contract is when CFO or COO accounts are
193     ///  compromised.
194     function unpause() public onlyCEO whenPaused {
195         paused = false;
196     }
197 }
198 
199 /// @title CSportsContestBase base class for contests and teams contracts
200 /// @dev This interface defines base class for contests and teams contracts
201 /// @author CryptoSports
202 contract CSportsContestBase {
203 
204     /// @dev Structure holding the player token IDs for a team
205     struct Team {
206       address owner;              // Address of the owner of the player tokens
207       int32 score;                // Score assigned to this team after a contest
208       uint32 place;               // Place this team finished in its contest
209       bool holdsEntryFee;         // TRUE if this team currently holds an entry fee
210       bool ownsPlayerTokens;      // True if the tokens are being escrowed by the Team contract
211       uint32[] playerTokenIds;    // IDs of the tokens held by this team
212     }
213 
214 }
215 
216 /// @title CSportsTeam Interface
217 /// @dev This interface defines methods required by the CSportsContestCore
218 ///   in implementing a contest.
219 /// @author CryptoSports
220 contract CSportsTeam {
221 
222     bool public isTeamContract;
223 
224     /// @dev Define team events
225     event TeamCreated(uint256 teamId, address owner);
226     event TeamUpdated(uint256 teamId);
227     event TeamReleased(uint256 teamId);
228     event TeamScored(uint256 teamId, int32 score, uint32 place);
229     event TeamPaid(uint256 teamId);
230 
231     function setCoreContractAddress(address _address) public;
232     function setLeagueRosterContractAddress(address _address) public;
233     function setContestContractAddress(address _address) public;
234     function createTeam(address _owner, uint32[] _tokenIds) public returns (uint32);
235     function updateTeam(address _owner, uint32 _teamId, uint8[] _indices, uint32[] _tokenIds) public;
236     function releaseTeam(uint32 _teamId) public;
237     function getTeamOwner(uint32 _teamId) public view returns (address);
238     function scoreTeams(uint32[] _teamIds, int32[] _scores, uint32[] _places) public;
239     function getScore(uint32 _teamId) public view returns (int32);
240     function getPlace(uint32 _teamId) public view returns (uint32);
241     function ownsPlayerTokens(uint32 _teamId) public view returns (bool);
242     function refunded(uint32 _teamId) public;
243     function tokenIdsForTeam(uint32 _teamId) public view returns (uint32, uint32[50]);
244     function getTeam(uint32 _teamId) public view returns (
245         address _owner,
246         int32 _score,
247         uint32 _place,
248         bool _holdsEntryFee,
249         bool _ownsPlayerTokens);
250 }
251 
252 /// @title CSports Contest
253 /// @dev Implementation of a fantasy sports contest using tokens managed
254 ///   by a CSportsCore contract. This class implements functionality that
255 ///   is generic to any sport that involves teams. The specifics of how
256 ///   teams are structured, validated, and scored happen in the attached
257 ///   contract that implements the CSportsTeam interface.
258 contract CSportsContest is CSportsAuth, CSportsContestBase {
259 
260   enum ContestStatus { Invalid, Active, Scoring, Paying, Paid, Canceled }
261   enum PayoutKey { Invalid, WinnerTakeAll, FiftyFifty, TopTen }
262 
263   /// @dev Used as sanity check by other contracts
264   bool public isContestContract = true;
265 
266   /// @dev Instance of the team contract connected to this contest. It is
267   ///   the team contract that implements most of the specific rules for
268   ///   this contrest.
269   CSportsTeam public teamContract;
270 
271   /// @dev Cut owner takes of the entry fees paid into a contest as a fee for
272   ///   scoring the contest (measured in basis points (1/100 of a percent).
273   ///   Values 0-10,000 map to 0%-100%
274   uint256 public ownerCut;
275 
276   /// @dev Structure for the definition of a single contest.
277   struct Contest {
278     address scoringOracleAddress;                 // Eth address of scoring oracle, if == 0, it's our commissioner address
279     address creator;                              // Address of the creator of the contest
280     uint32 gameSetId;                             // ID of the gameset associated with this contest
281     uint32 numWinners;                            // Number of winners in this contest
282     uint32 winnersToPay;                          // Number of winners that remain to be paid
283     uint64 startTime;                             // Starting time for the contest (lock time)
284     uint64 endTime;                               // Ending time for  the contest (can score after this time)
285     uint128 entryFee;                             // Fee to enter the contest
286     uint128 prizeAmount;                          // Fee to enter the contest
287     uint128 remainingPrizeAmount;                 // Remaining amount of prize money to payout
288     uint64 maxMinEntries;                         // Maximum and minimum number of entries allowed in the contest
289     ContestStatus status;                         // 1 = active, 2 = scoring, 3 = paying, 4 = paid, 5 = canceled
290     PayoutKey payoutKey;                          // Identifies the payout structure for the contest (see comments above)
291     uint32[] teamIds;                             // An array of teams entered into this contest
292     string name;                                  // Name of contest
293     mapping (uint32 => uint32) placeToWinner;     // Winners list mapping place to teamId
294     mapping (uint32 => uint32) teamIdToIdx;       // Maps a team ID to its index into the teamIds array
295   }
296 
297   /// @dev Holds all of our contests (public)
298   Contest[] public contests;
299 
300   /// @dev Maps team IDs to contest IDs
301   mapping (uint32 => uint32) public teamIdToContestId;
302 
303   /// @dev We do not transfer funds directly to users when making any kind of payout. We
304   ///   require the user to pull his own funds. This is to eliminate DoS and reentrancy problems.
305   mapping (address => uint128) public authorizedUserPayment;
306 
307   /// @dev Always has the total amount this contract is authorized to pay out to
308   ///   users.
309   uint128 public totalAuthorizedForPayment;
310 
311   /// @dev Define contest events
312   event ContestCreated(uint256 contestId);
313   event ContestCanceled(uint256 contestId);
314   event ContestEntered(uint256 contestId, uint256 teamId);
315   event ContestExited(uint256 contestId, uint256 teamId);
316   event ContestClosed(uint32 contestId);
317   event ContestTeamWinningsPaid(uint32 contestId, uint32 teamId, uint128 amount);
318   event ContestTeamRefundPaid(uint32 contestId, uint32 teamId, uint128 amount);
319   event ContestCreatorEntryFeesPaid(uint32 contestId, uint128 amount);
320   event ContestApprovedFundsDelivered(address toAddress, uint128 amount);
321 
322   /// @dev Class constructor creates the main CSportsContest smart contract instance.
323   constructor(uint256 _cut) public {
324       require(_cut <= 10000);
325       ownerCut = _cut;
326 
327       // All C-level roles are the message sender
328       ceoAddress = msg.sender;
329       cfoAddress = msg.sender;
330       cooAddress = msg.sender;
331       commissionerAddress = msg.sender;
332 
333       // Create a contest to take up the 0th slot.
334       // Create it in the canceled state with no teams.
335       // This is to deal with the fact that mappings return 0
336       // when queried with non-existent keys.
337       Contest memory _contest = Contest({
338           scoringOracleAddress: commissionerAddress,
339           gameSetId: 0,
340           maxMinEntries: 0,
341           numWinners: 0,
342           winnersToPay: 0,
343           startTime: 0,
344           endTime: 0,
345           creator: msg.sender,
346           entryFee: 0,
347           prizeAmount: 0,
348           remainingPrizeAmount: 0,
349           status: ContestStatus.Canceled,
350           payoutKey: PayoutKey(0),
351           name: "mythical",
352           teamIds: new uint32[](0)
353         });
354 
355         contests.push(_contest);
356   }
357 
358   /// @dev Called by any "C-level" role to pause the contract. Used only when
359   ///  a bug or exploit is detected and we need to limit damage.
360   function pause() public onlyCLevel whenNotPaused {
361     paused = true;
362   }
363 
364   /// @dev Unpauses the smart contract. Can only be called by the CEO, since
365   ///  one reason we may pause the contract is when CFO or COO accounts are
366   ///  compromised.
367   function unpause() public onlyCEO whenPaused {
368     // can't unpause if contract was upgraded
369     paused = false;
370   }
371 
372   /// @dev Sets the teamContract that will manage teams for this contest
373   /// @param _address - Address of our team contract
374   function setTeamContractAddress(address _address) public onlyCEO {
375     CSportsTeam candidateContract = CSportsTeam(_address);
376     require(candidateContract.isTeamContract());
377     teamContract = candidateContract;
378   }
379 
380   /// @dev Allows anyone who has funds approved to receive them. We use this
381   ///   "pull" funds mechanism to eliminate problems resulting from malicious behavior.
382   function transferApprovedFunds() public {
383     uint128 amount = authorizedUserPayment[msg.sender];
384     if (amount > 0) {
385 
386       // Shouldn't have to check this, but if for any reason things got screwed up,
387       // this prevents anyone from withdrawing more than has been approved in total
388       // on the contract.
389       if (totalAuthorizedForPayment >= amount) {
390 
391         // Imporant to do the delete before the transfer to eliminate re-entrancy attacks
392         delete authorizedUserPayment[msg.sender];
393         totalAuthorizedForPayment -= amount;
394         msg.sender.transfer(amount);
395 
396         // Create log entry
397         emit ContestApprovedFundsDelivered(msg.sender, amount);
398       }
399     }
400   }
401 
402   /// @dev Returns the amount of funds available for a given sender
403   function authorizedFundsAvailable() public view returns (uint128) {
404     return authorizedUserPayment[msg.sender];
405   }
406 
407   /// @dev Returns the total amount of ether held by this contract
408   /// that has been approved for dispursement to contest creators
409   /// and participants.
410   function getTotalAuthorizedForPayment() public view returns (uint128) {
411     return totalAuthorizedForPayment;
412   }
413 
414   /// @dev Creates a team for this contest. Called by an end-user of the CSportsCore
415   ///   contract. If the contract is paused, no additional contests can be created (although
416   ///   all other contract functionality remains valid.
417   /// @param _gameSetId - Identifes the games associated with contest. Used by the scoring oracle.
418   /// @param _startTime - Start time for the contest, used to determine locking of the teams
419   /// @param _endTime - End time representing the earliest this contest can be scored by the oracle
420   /// @param _entryFee - Entry fee paid to enter a team into this contest
421   /// @param _prizeAmount - Prize amount awarded to the winner
422   /// @param _maxEntries - Maximum number of entries in the contest
423   /// @param _minEntries - If false, we will return all ether and release all players
424   /// @param _payoutKey - Identifes the payout structure for the contest
425   ///   if we hit the start time with fewer than _maxEntries teams entered into the contest.
426   /// @param _tokenIds - Player token ids to be associated with the creator's team.
427   function createContest
428   (
429     string _name,
430     address _scoringOracleAddress,
431     uint32 _gameSetId,
432     uint64 _startTime,
433     uint64 _endTime,
434     uint128 _entryFee,
435     uint128 _prizeAmount,
436     uint32 _maxEntries,
437     uint32 _minEntries,
438     uint8 _payoutKey,
439     uint32[] _tokenIds
440   ) public payable whenNotPaused {
441 
442       require (msg.sender != address(0));
443       require (_endTime > _startTime);
444       require (_maxEntries != 1);
445       require (_minEntries <= _maxEntries);
446       require(_startTime > uint64(now));
447 
448       // The commissioner is allowed to create contests with no initial entry
449       require((msg.sender == commissionerAddress) || (_tokenIds.length > 0));
450 
451       // Make sure we don't overflow
452       require(((_prizeAmount + _entryFee) >= _prizeAmount) && ((_prizeAmount + _entryFee) >= _entryFee));
453 
454       // Creator must put up the correct amount of ether to cover the prize as well
455       // as his own entry fee if a team has been entered.
456       if (_tokenIds.length > 0) {
457         require(msg.value == (_prizeAmount + _entryFee));
458       } else {
459         require(msg.value == _prizeAmount);
460       }
461 
462       // The default scoring oracle address will be set to the commissionerAddress
463       if (_scoringOracleAddress == address(0)) {
464         _scoringOracleAddress = commissionerAddress;
465       }
466 
467       // Pack our maxMinEntries (due to stack limitations on struct sizes)
468       // uint64 maxMinEntries = (uint64(_maxEntries) << 32) | uint64(_minEntries);
469 
470       // Create the contest object in memory
471       Contest memory _contest = Contest({
472           scoringOracleAddress: _scoringOracleAddress,
473           gameSetId: _gameSetId,
474           maxMinEntries: (uint64(_maxEntries) << 32) | uint64(_minEntries),
475           numWinners: 0,
476           winnersToPay: 0,
477           startTime: _startTime,
478           endTime: _endTime,
479           creator: msg.sender,
480           entryFee: _entryFee,
481           prizeAmount: _prizeAmount,
482           remainingPrizeAmount: _prizeAmount,
483           status: ContestStatus.Active,
484           payoutKey: PayoutKey(_payoutKey),
485           name: _name,
486           teamIds: new uint32[](0)
487         });
488 
489       // We only create a team if we have tokens
490       uint32 uniqueTeamId = 0;
491       if (_tokenIds.length > 0) {
492         // Create the team for the creator of this contest. This
493         // will throw if msg.sender does not own all _tokenIds. The result
494         // of this call is that the team contract will now own the tokens.
495         //
496         // Note that the _tokenIds MUST BE OWNED by the msg.sender, and
497         // there may be other conditions enforced by the CSportsTeam contract's
498         // createTeam(...) method.
499         uniqueTeamId = teamContract.createTeam(msg.sender, _tokenIds);
500 
501         // Again, we make sure our unique teamId stays within bounds
502         require(uniqueTeamId < 4294967295);
503         _contest.teamIds = new uint32[](1);
504         _contest.teamIds[0] = uniqueTeamId;
505 
506         // We do not have to do this mapping here because 0 is returned from accessing
507         // a non existent member of a mapping (we deal with this when we use this
508         // structure in removing a team from the teamIds array). Can't do it anyway because
509         // mappings can't be accessed outside of storage.
510         //
511         // _contest.teamIdToIdx[uniqueTeamId] = 0;
512       }
513 
514       // Save our contest
515       //
516       // It's probably never going to happen, 4 billion contests and teams is A LOT, but
517       // let's just be 100% sure we never let this happen because teamIds are
518       // often cast as uint32.
519       uint256 _contestId = contests.push(_contest) - 1;
520       require(_contestId < 4294967295);
521 
522       // Map our entered teamId if we in fact entered a team
523       if (_tokenIds.length > 0) {
524         teamIdToContestId[uniqueTeamId] = uint32(_contestId);
525       }
526 
527       // Fire events
528       emit ContestCreated(_contestId);
529       if (_tokenIds.length > 0) {
530         emit ContestEntered(_contestId, uniqueTeamId);
531       }
532   }
533 
534   /// @dev Method to enter an existing contest. The msg.sender must own
535   ///   all of the player tokens on the team.
536   /// @param _contestId - ID of contest being entered
537   /// @param _tokenIds - IDs of player tokens on the team being entered
538   function enterContest(uint32 _contestId, uint32[] _tokenIds) public  payable whenNotPaused {
539 
540     require (msg.sender != address(0));
541     require ((_contestId > 0) && (_contestId < contests.length));
542 
543     // Grab the contest and make sure it is available to enter
544     Contest storage _contestToEnter = contests[_contestId];
545     require (_contestToEnter.status == ContestStatus.Active);
546     require(_contestToEnter.startTime > uint64(now));
547 
548     // Participant must put up the entry fee.
549     require(msg.value >= _contestToEnter.entryFee);
550 
551     // Cannot exceed the contest's max entry requirement
552     uint32 maxEntries = uint32(_contestToEnter.maxMinEntries >> 32);
553     if (maxEntries > 0) {
554       require(_contestToEnter.teamIds.length < maxEntries);
555     }
556 
557     // Note that the _tokenIds MUST BE OWNED by the msg.sender, and
558     // there may be other conditions enforced by the CSportsTeam contract's
559     // createTeam(...) method.
560     uint32 _newTeamId = teamContract.createTeam(msg.sender, _tokenIds);
561 
562     // Add the new team to our contest
563     uint256 _teamIndex = _contestToEnter.teamIds.push(_newTeamId) - 1;
564     require(_teamIndex < 4294967295);
565 
566     // Map the team's ID to its index in the teamIds array
567     _contestToEnter.teamIdToIdx[_newTeamId] = uint32(_teamIndex);
568 
569     // Map the team to the contest
570     teamIdToContestId[_newTeamId] = uint32(_contestId);
571 
572     // Fire event
573     emit ContestEntered(_contestId, _newTeamId);
574 
575   }
576 
577   /// @dev Removes a team from a contest. The msg.sender must be the owner
578   ///   of the team being removed.
579   function exitContest(uint32 _teamId) public {
580 
581     // Get the team from the team contract
582     address owner;
583     int32 score;
584     uint32 place;
585     bool holdsEntryFee;
586     bool ownsPlayerTokens;
587     (owner, score, place, holdsEntryFee, ownsPlayerTokens) = teamContract.getTeam(_teamId);
588 
589     // Caller must own the team
590     require (owner == msg.sender);
591 
592     uint32 _contestId = teamIdToContestId[_teamId];
593     require(_contestId > 0);
594     Contest storage _contestToExitFrom = contests[_contestId];
595 
596     // Cannot exit a contest that has already begun
597     require(_contestToExitFrom.startTime > uint64(now));
598 
599     // Return the entry fee to the owner and release the team
600     if (holdsEntryFee) {
601       teamContract.refunded(_teamId);
602       if (_contestToExitFrom.entryFee > 0) {
603         _authorizePayment(owner, _contestToExitFrom.entryFee);
604         emit ContestTeamRefundPaid(_contestId, _teamId, _contestToExitFrom.entryFee);
605       }
606     }
607     teamContract.releaseTeam(_teamId);  // Will throw if _teamId does not exist
608 
609     // Remove the team from our list of teams participating in the contest
610     //
611     // Note that this mechanism works even if the teamId to be removed is the last
612     // entry in the teamIds array. In this case, the lastTeamIdx == toRemoveIdx so
613     // we would overwrite the last entry with itself. This last entry is subsequently
614     // removed from the teamIds array.
615     //
616     // Note that because of this method of removing a team from the teamIds array,
617     // the teamIds array is not guaranteed to be in an order that maps to the order of
618     // teams entering the contest (the order is now arbitrary).
619     uint32 lastTeamIdx = uint32(_contestToExitFrom.teamIds.length) - 1;
620     uint32 lastTeamId = _contestToExitFrom.teamIds[lastTeamIdx];
621     uint32 toRemoveIdx = _contestToExitFrom.teamIdToIdx[_teamId];
622 
623     require(_contestToExitFrom.teamIds[toRemoveIdx] == _teamId);      // Sanity check (handle's Solidity's mapping of non-existing entries to 0)
624 
625     _contestToExitFrom.teamIds[toRemoveIdx] = lastTeamId;             // Overwriting the teamIds array entry for the team
626                                                                       // being removed with the last entry's teamId
627     _contestToExitFrom.teamIdToIdx[lastTeamId] = toRemoveIdx;         // Re-map the lastTeamId to the removed teamId's index
628 
629     delete _contestToExitFrom.teamIds[lastTeamIdx];                   // Remove the last entry that is now repositioned
630     _contestToExitFrom.teamIds.length--;                              // Shorten the array
631     delete _contestToExitFrom.teamIdToIdx[_teamId];                   // Remove the index mapping for the removed team
632 
633     // Remove the team from our list of teams participating in the contest
634     // (OLD way that would limit the # of teams in a contest due to gas consumption)
635 //    for (uint i = 0; i < _contestToExitFrom.teamIds.length; i++) {
636 //      if (_contestToExitFrom.teamIds[i] == _teamId) {
637 //        uint32 stopAt = uint32(_contestToExitFrom.teamIds.length - 1);
638 //        for (uint  j = i; j < stopAt; j++) {
639 //          _contestToExitFrom.teamIds[j] = _contestToExitFrom.teamIds[j+1];
640 //        }
641 //        delete _contestToExitFrom.teamIds[_contestToExitFrom.teamIds.length-1];
642 //        _contestToExitFrom.teamIds.length--;
643 //        break;
644 //      }
645 //    }
646 
647     // This _teamId will no longer map to any contest
648     delete teamIdToContestId[_teamId];
649 
650     // Fire event
651     emit ContestExited(_contestId, _teamId);
652   }
653 
654   /// @dev Method that allows a contest creator to cancel his/her contest.
655   ///   Throws if we try to cancel a contest not owned by the msg.sender
656   ///   or by contract's scoring oracle. Also throws if we try to cancel a contest that
657   ///   is not int the ContestStatus.Active state.
658   function cancelContest(uint32 _contestId) public {
659 
660     require(_contestId > 0);
661     Contest storage _toCancel = contests[_contestId];
662 
663     // The a contest can only be canceled if it is in the active state.
664     require (_toCancel.status == ContestStatus.Active);
665 
666     // Now make sure the calling entity is authorized to cancel the contest
667     // based on the state of the contest.
668     if (_toCancel.startTime > uint64(now)) {
669       // This is a contest that starts in the future. The creator of
670       // the contest or the scoringOracle can cancel it.
671       require((msg.sender == _toCancel.creator) || (msg.sender == _toCancel.scoringOracleAddress));
672     } else {
673       // This is a contest that has passed its lock time (i.e. started).
674       if (_toCancel.teamIds.length >= uint32(_toCancel.maxMinEntries & 0x00000000FFFFFFFF)) {
675 
676         // A contest that has met its minimum entry count can only be canceled
677         // by the scoringOracle.
678         require(msg.sender == _toCancel.scoringOracleAddress);
679       }
680     }
681 
682     // Note: Contests that have not met their minimum entry requirement
683     // can be canceled by anyone since they cannot be scored or paid out. Once canceled,
684     // anyone can release the teams back to their owners and refund any entry
685     // fees. Otherwise, it would require the contests' ending time to pass
686     // before anyone could release and refund as implemented in the
687     // releaseTeams(...) method.
688 
689     // Return the creator's prizeAmount
690     if (_toCancel.prizeAmount > 0) {
691       _authorizePayment(_toCancel.creator, _toCancel.prizeAmount);
692       _toCancel.remainingPrizeAmount = 0;
693     }
694 
695     // Mark the contest as canceled, which then will allow anyone to
696     // release the teams (and refund the entryFees if any) for this contest.
697     // Generally, this is automatically done by the scoring oracle.
698     _toCancel.status = ContestStatus.Canceled;
699 
700     // Fire event
701     emit ContestCanceled(_contestId);
702   }
703 
704   /// @dev - Releases a set of teams if the contest has passed its ending
705   //    time (or has been canceled). This method can be called by the general
706   ///   public, but should called by our scoring oracle automatically.
707   /// @param _contestId - The ID of the contest the teams belong to
708   /// @param _teamIds - TeamIds of the teams we want to release. Array should
709   ///   be short enough in length so as not to run out of gas
710   function releaseTeams(uint32 _contestId, uint32[] _teamIds) public {
711     require((_contestId < contests.length) && (_contestId > 0));
712     Contest storage c = contests[_contestId];
713 
714     // Teams can only be released for canceled contests or contests that have
715     // passed their end times.
716     require ((c.status == ContestStatus.Canceled) || (c.endTime <= uint64(now)));
717 
718     for (uint32 i = 0; i < _teamIds.length; i++) {
719       uint32 teamId = _teamIds[i];
720       uint32 teamContestId = teamIdToContestId[teamId];
721       if (teamContestId == _contestId) {
722         address owner;
723         int32 score;
724         uint32 place;
725         bool holdsEntryFee;
726         bool ownsPlayerTokens;
727         (owner, score, place, holdsEntryFee, ownsPlayerTokens) = teamContract.getTeam(teamId);
728         if ((c.status == ContestStatus.Canceled) && holdsEntryFee) {
729           teamContract.refunded(teamId);
730           if (c.entryFee > 0) {
731             emit ContestTeamRefundPaid(_contestId, teamId, c.entryFee);
732             _authorizePayment(owner, c.entryFee);
733           }
734         }
735         if (ownsPlayerTokens) {
736           teamContract.releaseTeam(teamId);
737         }
738       }
739     }
740   }
741 
742   /// @dev - Updates a team with new player tokens, releasing ones that are replaced back
743   ///   to the owner. New player tokens must be approved for transfer to the team contract.
744   /// @param _contestId - ID of the contest we are working on
745   /// @param _teamId - Team ID of the team being updated
746   /// @param _indices - Indices of playerTokens to be replaced
747   /// @param _tokenIds - Array of player token IDs that will replace those
748   ///   currently held at the indices specified.
749   function updateContestTeam(uint32 _contestId, uint32 _teamId, uint8[] _indices, uint32[] _tokenIds) public whenNotPaused {
750     require((_contestId > 0) && (_contestId < contests.length));
751     Contest storage c = contests[_contestId];
752     require (c.status == ContestStatus.Active);
753 
754     // To prevent a form of sniping, we do not allow you to update your
755     // team within 1 hour of the starting time of the contest.
756     require(c.startTime > uint64(now + 1 hours));
757 
758     teamContract.updateTeam(msg.sender, _teamId, _indices, _tokenIds);
759   }
760 
761   /// @dev Returns the contest data for a specific contest
762   ///@param _contestId - contest ID we are seeking the full info for
763   function getContest(uint32 _contestId) public view returns (
764     string name,                    // Name of this contest
765     address scoringOracleAddress,   // Address of the scoring oracle for this contest
766     uint32 gameSetId,               // ID of the gameset associated with this contest
767     uint32 maxEntries,              // Maximum number of entries allowed in the contest
768     uint64 startTime,               // Starting time for the contest (lock time)
769     uint64 endTime,                 // Ending time for the contest (lock time)
770     address creator,                // Address of the creator of the contest
771     uint128 entryFee,               // Fee to enter the contest
772     uint128 prizeAmount,            // Fee to enter the contest
773     uint32 minEntries,              // Wide receivers
774     uint8 status,                   // 1 = active, 2 = scored, 3-paying, 4 = paid, 5 = canceled
775     uint8 payoutKey,                // Identifies the payout structure for the contest (see comments above)
776     uint32 entryCount               // Current number of entries in the contest
777   )
778   {
779     require((_contestId > 0) && (_contestId < contests.length));
780 
781     // Unpack max & min entries (packed in struct due to stack limitations)
782     // Couldn't create these local vars due to stack limitation too.
783     /* uint32 _maxEntries = uint32(c.maxMinEntries >> 32);
784     uint32 _minEntries = uint32(c.maxMinEntries & 0x00000000FFFFFFFF); */
785 
786     Contest storage c = contests[_contestId];
787     scoringOracleAddress = c.scoringOracleAddress;
788     gameSetId = c.gameSetId;
789     maxEntries = uint32(c.maxMinEntries >> 32);
790     startTime = c.startTime;
791     endTime = c.endTime;
792     creator = c.creator;
793     entryFee = c.entryFee;
794     prizeAmount = c.prizeAmount;
795     minEntries = uint32(c.maxMinEntries & 0x00000000FFFFFFFF);
796     status = uint8(c.status);
797     payoutKey = uint8(c.payoutKey);
798     name = c.name;
799     entryCount = uint32(c.teamIds.length);
800   }
801 
802   /// @dev Returns the number of teams in a particular contest
803   /// @param _contestId ID of contest we are inquiring about
804   function getContestTeamCount(uint32 _contestId) public view returns (uint32 count) {
805     require((_contestId > 0) && (_contestId < contests.length));
806     Contest storage c = contests[_contestId];
807     count = uint32(c.teamIds.length);
808   }
809 
810   /// @dev Returns the index into the teamIds array of a contest a particular teamId sits at
811   /// @param _contestId ID of contest we are inquiring about
812   /// @param _teamId The team ID within the contest that we are interested in learning its teamIds index
813   function getIndexForTeamId(uint32 _contestId, uint32 _teamId) public view returns (uint32 idx) {
814     require((_contestId > 0) && (_contestId < contests.length));
815     Contest storage c = contests[_contestId];
816     idx = c.teamIdToIdx[_teamId];
817 
818     require (idx < c.teamIds.length);  // Handles the Solidity returning 0 from mapping for non-existent entries
819     require(c.teamIds[idx] == _teamId);
820   }
821 
822   /// @dev Returns the team data for a particular team entered into the contest
823   /// @param _contestId - ID of contest we are getting a team from
824   /// @param _teamIndex - Index of team we are getting from the contest
825   function getContestTeam(uint32 _contestId, uint32 _teamIndex) public view returns (
826     uint32 teamId,
827     address owner,
828     int score,
829     uint place,
830     bool holdsEntryFee,
831     bool ownsPlayerTokens,
832     uint32 count,
833     uint32[50] playerTokenIds
834   )
835   {
836     require((_contestId > 0) && (_contestId < contests.length));
837     Contest storage c = contests[_contestId];
838     require(_teamIndex < c.teamIds.length);
839 
840     uint32 _teamId = c.teamIds[_teamIndex];
841     (teamId) = _teamId;
842     (owner, score, place, holdsEntryFee, ownsPlayerTokens) = teamContract.getTeam(_teamId);
843     (count, playerTokenIds) = teamContract.tokenIdsForTeam(_teamId);
844   }
845 
846   /// @dev - Puts the contest into a state where the scoring oracle can
847   ///   now score the contest. CAN ONLY BE CALLED BY THE SCORING ORACLE
848   ///   for the given contest.
849   function prepareToScore(uint32 _contestId) public {
850     require((_contestId > 0) && (_contestId < contests.length));
851     Contest storage c = contests[_contestId];
852     require ((c.scoringOracleAddress == msg.sender) && (c.status == ContestStatus.Active) && (c.endTime <= uint64(now)));
853 
854     // Cannot score a contest that has not met its minimum entry count
855     require (uint32(c.teamIds.length) >= uint32(c.maxMinEntries & 0x00000000FFFFFFFF));
856 
857     c.status = ContestStatus.Scoring;
858 
859     // Calculate the # of winners to payout
860     uint32 numWinners = 1;
861     if (c.payoutKey == PayoutKey.TopTen) {
862         numWinners = 10;
863     } else if (c.payoutKey == PayoutKey.FiftyFifty) {
864         numWinners = uint32(c.teamIds.length) / 2;
865     }
866     c.winnersToPay = numWinners;
867     c.numWinners = numWinners;
868 
869     // We must have at least as many entries into the contest as there are
870     // number of winners. i.e. must have 10 or more entries in a top ten
871     // payout contest.
872     require(c.numWinners <= c.teamIds.length);
873   }
874 
875   /// @dev Assigns a score and place for an array of teams. The indexes into the
876   ///   arrays are what tie a particular teamId to score and place. The contest being
877   ///   scored must (a) be in the ContestStatus.Scoring state, and (b) have its
878   ///   scoringOracleAddress == the msg.sender.
879   /// @param _contestId - ID of contest the teams being scored belong to
880   /// @param _teamIds - IDs of the teams we are scoring
881   /// @param _scores - Scores to assign
882   /// @param _places - Places to assign
883   /// @param _startingPlaceOffset - Offset the _places[0] is from first place
884   /// @param _totalWinners - Total number of winners including ties
885   function scoreTeams(uint32 _contestId, uint32[] _teamIds, int32[] _scores, uint32[] _places, uint32 _startingPlaceOffset, uint32 _totalWinners) public {
886     require ((_teamIds.length == _scores.length) && (_teamIds.length == _places.length));
887     require((_contestId > 0) && (_contestId < contests.length));
888     Contest storage c = contests[_contestId];
889     require ((c.scoringOracleAddress == msg.sender) && (c.status == ContestStatus.Scoring));
890 
891     // Deal with validating the teams all belong to the contest,
892     // and assign to winners list if we have a prizeAmount.
893     for (uint32 i = 0; i < _places.length; i++) {
894       uint32 teamId = _teamIds[i];
895 
896       // Make sure ALL TEAMS PASED IN BELONG TO THE CONTEST BEING SCORED
897       uint32 contestIdForTeamBeingScored = teamIdToContestId[teamId];
898       require(contestIdForTeamBeingScored == _contestId);
899 
900       // Add the team to the winners list if we have a prize
901       if (c.prizeAmount > 0) {
902         if ((_places[i] <= _totalWinners - _startingPlaceOffset) && (_places[i] > 0)) {
903           c.placeToWinner[_places[i] + _startingPlaceOffset] = teamId;
904         }
905       }
906     }
907 
908     // Relay request over to the team contract
909     teamContract.scoreTeams(_teamIds, _scores, _places);
910   }
911 
912   /// @dev Returns the place a particular team finished in (or is currently
913   ///   recorded as being in). Mostly used just to verify things during dev.
914   /// @param _teamId - Team ID of the team we are inquiring about
915   function getWinningPosition(uint32 _teamId) public view returns (uint32) {
916     uint32 _contestId = teamIdToContestId[_teamId];
917     require(_contestId > 0);
918     Contest storage c = contests[_contestId];
919     for (uint32 i = 1; i <= c.teamIds.length; i++) {
920       if (c.placeToWinner[i] == _teamId) {
921         return i;
922       }
923     }
924     return 0;
925   }
926 
927   /// @dev - Puts the contest into a state where the scoring oracle can
928   ///   pay the winners of a contest. CAN ONLY BE CALLED BY THE SCORING ORACLE
929   ///   for the given contest. Contest must be in the ContestStatus.Scoring state.
930   /// @param _contestId - ID of contest being prepared to payout.
931   function prepareToPayWinners(uint32 _contestId) public {
932     require((_contestId > 0) && (_contestId < contests.length));
933     Contest storage c = contests[_contestId];
934     require ((c.scoringOracleAddress == msg.sender) && (c.status == ContestStatus.Scoring) && (c.endTime < uint64(now)));
935     c.status = ContestStatus.Paying;
936   }
937 
938   /// @dev Returns the # of winners to pay if we are in the paying state.
939   /// @param _contestId - ID of contestId we are inquiring about
940   function numWinnersToPay(uint32 _contestId) public view returns (uint32) {
941     require((_contestId > 0) && (_contestId < contests.length));
942     Contest memory c = contests[_contestId];
943     if (c.status == ContestStatus.Paying) {
944       return c.winnersToPay;
945     } else {
946       return 0;
947     }
948   }
949 
950   /// @dev Pays the next batch of winners (authorizes payment) and return TRUE if there
951   ///   more to pay, otherwise FALSE. Contest must be in the ContestStatus.Paying state
952   ///   and CAN ONLY BE CALLED BY THE SCORING ORACLE. The scoring oracle is intended to
953   ///   loop on this until it returns FALSE.
954   /// @param _contestId - ID of contest being paid out.
955   /// @param _payingStartingIndex - Starting index of winner being paid. Equal to the number
956   /// of winners paid in previous calls to this method. Starts at 0 and goes up by numToPay
957   /// each time the method is called.
958   /// @param _numToPay - The number of winners to pay this time, can exceed the number
959   ///   left to pay.
960   /// @param _isFirstPlace - True if the first entry at the place being scored is a first
961   ///   place winner
962   /// @param _prevTies - # of places prior to the first place being paid in this call that
963   ///   had a tied value to the first place being paid in this call
964   /// @param _nextTies - # of places after to the last place being scored in this call that
965   ///   had a tied value to the last place paid in this call
966   function payWinners(uint32 _contestId, uint32 _payingStartingIndex, uint _numToPay, bool _isFirstPlace, uint32 _prevTies, uint32 _nextTies) public {
967     require((_contestId > 0) && (_contestId < contests.length));
968     Contest storage c = contests[_contestId];
969     require ((c.scoringOracleAddress == msg.sender) && (c.status == ContestStatus.Paying));
970 
971     // Due to EVM stack restrictings, certain local variables are packed into
972     // an array that is stored in memory as opposed to the stack.
973     //
974     // localVars index 0 = placeBeingPaid (
975     // localVars index 1 = nextBeingPaid
976     uint32[] memory localVars = new uint32[](2);
977     localVars[0] = _payingStartingIndex + 1;
978 
979     // We have to add _prevTies here to handle the case where a batch holding the final
980     // winner to pay position (1, 10, or 50%) finishes processing its batch size, but
981     // the final position is a tie and the next batch is a tie of the final position.
982     // When the next batch is called, the c.winnersToPay would be 0 but there are still
983     // positions to be paid as ties to last place. This is where _prevTies comes in
984     // and keeps us going. However, a rogue scoring oracle could keep calling this
985     // payWinners method with a positive _prevTies value, which could cause us to
986     // pay out too much. This is why we have the c.remainingPrizeAmount check when
987     // we loop and actually payout the winners.
988     if (c.winnersToPay + _prevTies > 0) {
989       // Calculation of place amount:
990       //
991       // let n = c.numWinners
992       //
993       // s = sum of numbers 1 through c.numWinners
994       // m = (2*prizeAmount) / c.numWinners * (c.numWinners + 1);
995       // payout = placeBeingPaid*m
996       //
997       uint32 s = (c.numWinners * (c.numWinners + 1)) / 2;
998       uint128 m = c.prizeAmount / uint128(s);
999       while ((c.winnersToPay + _prevTies > 0) && (_numToPay > 0)) {
1000 
1001         uint128 totalPayout = 0;
1002         uint32 totalNumWinnersWithTies = _prevTies;
1003         if (_prevTies > 0) {
1004           // Adding the prize money associated with the _prevTies number of
1005           // places that are getting aggregated into this tied position.
1006           totalPayout = m*(_prevTies * c.winnersToPay + (_prevTies * (_prevTies + 1)) / 2);
1007         }
1008 
1009         // nextBeingPaid = placeBeingPaid;
1010         localVars[1] = localVars[0];
1011 
1012         // This loop accumulates the payouts associated with a string of tied scores.
1013         // It always executes at least once.
1014         uint32 numProcessedThisTime = 0;
1015         while (teamContract.getScore(c.placeToWinner[localVars[1]]) == teamContract.getScore(c.placeToWinner[localVars[0]])) {
1016 
1017           // Accumulate the prize money for each place in a string of tied scores
1018           // (but only if there are winners left to pay)
1019           if (c.winnersToPay > 0) {
1020             totalPayout += m*c.winnersToPay;
1021           }
1022 
1023           // This value represents the number of ties at a particular score
1024           totalNumWinnersWithTies++;
1025 
1026           // Incerement the number processed in this call
1027           numProcessedThisTime++;
1028 
1029           // We decrement our winnersToPay value for each team at the same
1030           // score, but we don't let it go negative.
1031           if (c.winnersToPay > 0) {
1032             c.winnersToPay--;
1033           }
1034 
1035           localVars[1]++;
1036           _numToPay -= 1;
1037           if ((_numToPay == 0) || (c.placeToWinner[localVars[1]] == 0)) {
1038             break;
1039           }
1040         }
1041 
1042         // Deal with first place getting the distributed rounding error
1043         if (_isFirstPlace) {
1044           totalPayout += c.prizeAmount - m * s;
1045         }
1046         _isFirstPlace = false;
1047 
1048         // If we are on the last loop of this call, we need to deal
1049         // with the _nextTies situation
1050         if ((_numToPay == 0) && (_nextTies > 0)) {
1051           totalNumWinnersWithTies += _nextTies;
1052           if (_nextTies < c.winnersToPay) {
1053             totalPayout += m*(_nextTies * (c.winnersToPay + 1) - (_nextTies * (_nextTies + 1)) / 2);
1054           } else {
1055             totalPayout += m*(c.winnersToPay * (c.winnersToPay + 1) - (c.winnersToPay * (c.winnersToPay + 1)) / 2);
1056           }
1057         }
1058 
1059         // Payout is evenly distributed to all players with the same score
1060         uint128 payout = totalPayout / totalNumWinnersWithTies;
1061 
1062         // If this is the last place being paid, we are going to evenly distribute
1063         // the remaining amount this contest holds in prize money evenly over other
1064         // the number of folks remaining to be paid.
1065         if (c.winnersToPay == 0) {
1066           payout = c.remainingPrizeAmount / (numProcessedThisTime + _nextTies);
1067         }
1068 
1069         for (uint32 i = _prevTies; (i < (numProcessedThisTime + _prevTies)) && (c.remainingPrizeAmount > 0); i++) {
1070 
1071           // Deals with rounding error in the last payout in a group of ties since the totalPayout
1072           // was divided among tied players.
1073           if (i == (totalNumWinnersWithTies - 1)) {
1074             if ((c.winnersToPay == 0) && (_nextTies == 0)) {
1075               payout = c.remainingPrizeAmount;
1076             } else {
1077               payout = totalPayout - (totalNumWinnersWithTies - 1)*payout;
1078             }
1079           }
1080 
1081           // This is a safety check. Shouldn't be needed but this prevents a rogue scoringOracle
1082           // from draining anything more than the prize amount for the contest they are oracle of.
1083           if (payout > c.remainingPrizeAmount) {
1084             payout = c.remainingPrizeAmount;
1085           }
1086           c.remainingPrizeAmount -= payout;
1087 
1088           _authorizePayment(teamContract.getTeamOwner(c.placeToWinner[localVars[0]]), payout);
1089 
1090           // Fire the event
1091           emit ContestTeamWinningsPaid(_contestId, c.placeToWinner[localVars[0]], payout);
1092 
1093           // Increment our placeBeingPaid value
1094           localVars[0]++;
1095         }
1096 
1097         // We only initialize with _prevTies the first time through the loop
1098         _prevTies = 0;
1099 
1100       }
1101     }
1102   }
1103 
1104   /// @dev Closes out a contest that is currently in the ContestStatus.Paying state.
1105   ///   The contest being closed must (a) be in the ContestStatus.Paying state, and (b) have its
1106   ///   scoringOracleAddress == the msg.sender, and (c) have no more winners to payout.
1107   ///   Will then allow for the player tokens associated with any team in this contest to be released.
1108   ///   Also authorizes the payment of all entry fees to the contest creator (less ownerCut if
1109   ///   cryptosports was the scoring oracle)
1110   /// @param _contestId - ID of the contest to close
1111   function closeContest(uint32 _contestId) public {
1112     require((_contestId > 0) && (_contestId < contests.length));
1113     Contest storage c = contests[_contestId];
1114     require ((c.scoringOracleAddress == msg.sender) && (c.status == ContestStatus.Paying) && (c.winnersToPay == 0));
1115 
1116     // Move to the Paid state so we can only close the contest once
1117     c.status = ContestStatus.Paid;
1118 
1119     uint128 totalEntryFees = c.entryFee * uint128(c.teamIds.length);
1120 
1121     // Transfer owner cut to the CFO address if the contest was scored by the commissioner
1122     if (c.scoringOracleAddress == commissionerAddress) {
1123       uint128 cut = _computeCut(totalEntryFees);
1124       totalEntryFees -= cut;
1125       cfoAddress.transfer(cut);
1126     }
1127 
1128     // Payout the contest creator
1129     if (totalEntryFees > 0) {
1130       _authorizePayment(c.creator, totalEntryFees);
1131       emit ContestCreatorEntryFeesPaid(_contestId, totalEntryFees);
1132     }
1133 
1134     emit ContestClosed(_contestId);
1135   }
1136 
1137   // ---------------------------------------------------------------------------
1138   // PRIVATE METHODS -----------------------------------------------------------
1139   // ---------------------------------------------------------------------------
1140 
1141   /// @dev Authorizes a user to receive payment from this contract.
1142   /// @param _to - Address authorized to withdraw funds
1143   /// @param _amount - Amount to authorize
1144   function _authorizePayment(address _to, uint128 _amount) private {
1145     totalAuthorizedForPayment += _amount;
1146     uint128 _currentlyAuthorized = authorizedUserPayment[_to];
1147     authorizedUserPayment[_to] = _currentlyAuthorized + _amount;
1148   }
1149 
1150   /// @dev Computes owner's cut of a contest's entry fees.
1151   /// @param _amount - Amount owner is getting cut of
1152   function _computeCut(uint128 _amount) internal view returns (uint128) {
1153       // NOTE: We don't use SafeMath (or similar) in this function because
1154       //  all of our entry functions carefully cap the maximum values for
1155       //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
1156       //  statement in the CSportsContest constructor). The result of this
1157       //  function is always guaranteed to be <= _amount.
1158       return uint128(_amount * ownerCut / 10000);
1159   }
1160 
1161 }