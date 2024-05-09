1 contract BCFBaseCompetition {
2     address public owner;
3     address public referee;
4 
5     bool public paused = false;
6 
7     modifier onlyOwner() {
8         require(msg.sender == owner);
9         _;
10     }
11 
12     modifier onlyReferee() {
13         require(msg.sender == referee);
14         _;
15     }
16 
17     function setOwner(address newOwner) public onlyOwner {
18         require(newOwner != address(0));
19         owner = newOwner;
20     }
21 
22     function setReferee(address newReferee) public onlyOwner {
23         require(newReferee != address(0));
24         referee = newReferee;
25     }
26     
27     modifier whenNotPaused() {
28         require(!paused);
29         _;
30     }
31     
32     modifier whenPaused() {
33         require(paused);
34         _;
35     }
36     
37     function pause() onlyOwner whenNotPaused public {
38         paused = true;
39     }
40     
41     function unpause() onlyOwner whenPaused public {
42         paused = false;
43     }
44 }
45 
46 contract BCFMain {
47     function isOwnerOfAllPlayerCards(uint256[], address) public pure returns (bool) {}
48     function implementsERC721() public pure returns (bool) {}
49     function getPlayerForCard(uint) 
50         external
51         pure
52         returns (
53         uint8,
54         uint8,
55         uint8,
56         uint8,
57         uint8,
58         uint8,
59         uint8,
60         uint8,
61         bytes,
62         string,
63         uint8
64     ) {}
65 }
66 
67 // TODO: Validate that the user has sent the correct ENTRY_FEE and refund them if more, revert if less
68 // TODO: Validate formation type
69 // TODO: Validate that there's at least 1 goalkeeper?
70 // TODO: Validate the team name is under a certain number of characters?
71 // TODO: Do we need to copy these values across to the contract storage?
72 // TODO: Should the frontend do the sorting and league tables? We still need the business logic to determine final positions, 
73 //       but we don't need to calculate this every round, not doing so would reduce gas consumption
74 // TODO: Need to work out whether it's more gas effecient to read player info every round or store it once and have it?
75 contract BCFLeague is BCFBaseCompetition {
76     
77     struct Team {
78         address manager;
79         bytes name;
80         uint[] cardIds;
81         uint gkCardId;
82         uint8 wins;
83         uint8 losses;
84         uint8 draws;
85         uint16 goalsFor;
86         uint16 goalsAgainst;
87     }
88 
89     struct Match {
90         uint8 homeTeamId;
91         uint8 awayTeamId;
92         uint[] homeScorerIds;
93         uint[] awayScorerIds;
94         bool isFinished;
95     }
96 
97     // Configuration - this will be set in the constructor, hence not being constants
98     uint public TEAMS_TOTAL;
99     uint public ENTRY_FEE;
100     uint public SQUAD_SIZE;
101     uint public TOTAL_ROUNDS;
102     uint public MATCHES_PER_ROUND;
103     uint public SECONDS_BETWEEN_ROUNDS;
104 
105     // Status
106     enum CompetitionStatuses { Upcoming, OpenForEntry, PendingStart, Started, Finished, Settled }
107     CompetitionStatuses public competitionStatus;
108     uint public startedAt;
109     uint public nextRoundStartsAt;
110     int public currentRoundId = -1; // As we may have a round 0 so we don't want to default there
111 
112     // Local Data Lookups
113     Team[] public teams;
114     mapping(address => uint) internal managerToTeamId;
115     mapping(uint => bool) internal cardIdToEntryStatus;
116     mapping(uint => Match[]) internal roundIdToMatches;
117 
118     // Data Source
119     BCFMain public mainContract;
120 
121     // Prize Pool
122     uint public constant PRIZE_POT_PERCENTAGE_MAX = 10000; // 10,000 = 100% so we get 2 digits of precision, 375 = 3.75%
123     uint public prizePool; // Holds the total prize pool
124     uint[] public prizeBreakdown; // Max 10,000 across all indexes. Holds breakdown by index, e.g. [0] 5000 = 50%, [1] 3500 = 35%, [2] 1500 = 15%
125     address[] public winners; // Corresponding array of winners for the prize pot, [0] = first placed winner
126 
127     function BCFLeague(address dataStoreAddress, uint teamsTotal, uint entryFee, uint squadSize, uint roundTimeSecs) public {
128         require(teamsTotal % 2 == 0); // We only allow an even number of teams, this reduces complexity
129         require(teamsTotal > 0);
130         require(roundTimeSecs > 30 seconds && roundTimeSecs < 60 minutes);
131         require(entryFee >= 0);
132         require(squadSize > 0);
133         
134         // Initial state
135         owner = msg.sender;
136         referee = msg.sender;
137         
138         // League configuration
139         TEAMS_TOTAL = teamsTotal;
140         ENTRY_FEE = entryFee;
141         SQUAD_SIZE = squadSize;
142         TOTAL_ROUNDS = TEAMS_TOTAL - 1;
143         MATCHES_PER_ROUND = TEAMS_TOTAL / 2;
144         SECONDS_BETWEEN_ROUNDS = roundTimeSecs;
145 
146         // Always start it as an upcoming league
147         competitionStatus = CompetitionStatuses.Upcoming;
148 
149         // Set the data source
150         BCFMain candidateDataStoreContract = BCFMain(dataStoreAddress);
151         require(candidateDataStoreContract.implementsERC721());
152         mainContract = candidateDataStoreContract;
153     }
154 
155     // **Gas guzzler**
156     // CURRENT GAS CONSUMPTION: 6339356
157     function generateFixtures() external onlyOwner {
158         require(competitionStatus == CompetitionStatuses.Upcoming);
159 
160         // Generate the fixtures using a cycling algorithm:
161         for (uint round = 0; round < TOTAL_ROUNDS; round++) {
162             for (uint matchIndex = 0; matchIndex < MATCHES_PER_ROUND; matchIndex++) {
163                 uint home = (round + matchIndex) % (TEAMS_TOTAL - 1);
164                 uint away = (TEAMS_TOTAL - 1 - matchIndex + round) % (TEAMS_TOTAL - 1);
165 
166                 if (matchIndex == 0) {
167                     away = TEAMS_TOTAL - 1;
168                 }
169 
170                  Match memory _match;
171                  _match.homeTeamId = uint8(home);
172                  _match.awayTeamId = uint8(away);
173 
174                 roundIdToMatches[round].push(_match);
175             }
176         }
177     }
178 
179     function createPrizePool(uint[] prizeStructure) external payable onlyOwner {
180         require(competitionStatus == CompetitionStatuses.Upcoming);
181         require(msg.value > 0 && msg.value <= 2 ether); // Set some sensible top and bottom values
182         require(prizeStructure.length > 0); // Can't create a prize pool with no breakdown structure
183 
184         uint allocationTotal = 0;
185         for (uint i = 0; i < prizeStructure.length; i++) {
186             allocationTotal += prizeStructure[i];
187         }
188 
189         require(allocationTotal > 0 && allocationTotal <= PRIZE_POT_PERCENTAGE_MAX); // Make sure we don't allocate more than 100% of the prize pool or 0%
190         prizePool += msg.value;
191         prizeBreakdown = prizeStructure;
192     }
193 
194     function openCompetition() external onlyOwner whenNotPaused {
195         competitionStatus = CompetitionStatuses.OpenForEntry;
196     }
197 
198     function startCompetition() external onlyReferee whenNotPaused {
199         require(competitionStatus == CompetitionStatuses.PendingStart);
200 
201         // Move the status into Started
202         competitionStatus = CompetitionStatuses.Started;
203         
204         // Mark the startedAt to now
205         startedAt = now;
206         nextRoundStartsAt = now + 60 seconds;
207     }
208 
209     function calculateMatchOutcomesForRoundId(int roundId) external onlyReferee whenNotPaused {
210         require(competitionStatus == CompetitionStatuses.Started);
211         require(nextRoundStartsAt > 0);
212         require(roundId == currentRoundId + 1); // We're only allowed to process the next round, we can't skip ahead
213         require(now > nextRoundStartsAt);
214 
215         // Increment the round counter
216         // We complete the below first as during the calculateScorersForTeamIds we go off to another contract to fetch the 
217         // current player attributes so to avoid re-entrancy we bump this first 
218         currentRoundId++;
219 
220         // As the total rounds aren't index based we need to compare it to the index+1
221         // this should never overrun as the gas cost of generating a league with more 20 teams makes this impossible
222         if (TOTAL_ROUNDS == uint(currentRoundId + 1)) {
223             competitionStatus = CompetitionStatuses.Finished;
224         } else {
225             nextRoundStartsAt = now + SECONDS_BETWEEN_ROUNDS;
226         }
227 
228         // Actually calculate some of the outcomes 
229         Match[] memory matches = roundIdToMatches[uint(roundId)];
230         for (uint i = 0; i < matches.length; i++) {
231             Match memory _match = matches[i];
232             var (homeScorers, awayScorers) = calculateScorersForTeamIds(_match.homeTeamId, _match.awayTeamId);
233 
234             // Adjust the table values
235             updateTeamsTableAttributes(_match.homeTeamId, homeScorers.length, _match.awayTeamId, awayScorers.length);
236 
237             // Save the goal scorers for this match and mark as finished
238             roundIdToMatches[uint(roundId)][i].isFinished = true;
239             roundIdToMatches[uint(roundId)][i].homeScorerIds = homeScorers;
240             roundIdToMatches[uint(roundId)][i].awayScorerIds = awayScorers;
241         }
242     }
243 
244     function updateTeamsTableAttributes(uint homeTeamId, uint homeGoals, uint awayTeamId, uint awayGoals) internal {
245 
246         // GOALS FOR
247         teams[homeTeamId].goalsFor += uint16(homeGoals);
248         teams[awayTeamId].goalsFor += uint16(awayGoals);
249 
250         // GOALS AGAINST
251         teams[homeTeamId].goalsAgainst += uint16(awayGoals);
252         teams[awayTeamId].goalsAgainst += uint16(homeGoals);
253 
254         // WINS / LOSSES / DRAWS
255         if (homeGoals == awayGoals) {            
256             teams[homeTeamId].draws++;
257             teams[awayTeamId].draws++;
258         } else if (homeGoals > awayGoals) {
259             teams[homeTeamId].wins++;
260             teams[awayTeamId].losses++;
261         } else {
262             teams[awayTeamId].wins++;
263             teams[homeTeamId].losses++;
264         }
265     }
266 
267     function getAllMatchesForRoundId(uint roundId) public view returns (uint[], uint[], bool[]) {
268         Match[] memory matches = roundIdToMatches[roundId];
269         
270         uint[] memory _homeTeamIds = new uint[](matches.length);
271         uint[] memory _awayTeamIds = new uint[](matches.length);
272         bool[] memory matchStates = new bool[](matches.length);
273 
274         for (uint i = 0; i < matches.length; i++) {
275             _homeTeamIds[i] = matches[i].homeTeamId;
276             _awayTeamIds[i] = matches[i].awayTeamId;
277             matchStates[i] = matches[i].isFinished;
278         }
279 
280         return (_homeTeamIds, _awayTeamIds, matchStates);
281     }
282 
283     function getMatchAtRoundIdAtIndex(uint roundId, uint index) public view returns (uint, uint, uint[], uint[], bool) {
284         Match[] memory matches = roundIdToMatches[roundId];
285         Match memory _match = matches[index];
286         return (_match.homeTeamId, _match.awayTeamId, _match.homeScorerIds, _match.awayScorerIds, _match.isFinished);
287     }
288 
289     function getPlayerCardIdsForTeam(uint teamId) public view returns (uint[]) {
290         Team memory _team = teams[teamId];
291         return _team.cardIds;
292     }
293 
294     function enterLeague(uint[] cardIds, uint gkCardId, bytes teamName) public payable whenNotPaused {
295         require(mainContract != address(0)); // Must have a valid data store to check card ownership
296         require(competitionStatus == CompetitionStatuses.OpenForEntry); // Competition must be open for entry
297         require(cardIds.length == SQUAD_SIZE); // Require a valid number of players
298         require(teamName.length > 3 && teamName.length < 18); // Require a valid team name
299         require(!hasEntered(msg.sender)); // Make sure the address hasn't already entered
300         require(!hasPreviouslyEnteredCardIds(cardIds)); // Require that none of the players have previously entered, avoiding managers swapping players between accounts
301         require(mainContract.isOwnerOfAllPlayerCards(cardIds, msg.sender)); // User must actually own these cards
302         require(teams.length < TEAMS_TOTAL); // We shouldn't ever hit this as the state should be managed, but just as a fallback
303         require(msg.value >= ENTRY_FEE); // User must have paid a valid entry fee
304 
305         // Create a team and hold the teamId
306         Team memory _team;
307         _team.name = teamName;
308         _team.manager = msg.sender;
309         _team.cardIds = cardIds;
310         _team.gkCardId = gkCardId;
311         uint teamId = teams.push(_team) - 1;
312 
313         // Keep track of who the manager is managing
314         managerToTeamId[msg.sender] = teamId;
315 
316         // Track which team each card plays for
317         for (uint i = 0; i < cardIds.length; i++) {
318             cardIdToEntryStatus[cardIds[i]] = true;
319         }
320 
321         // If we've hit the team limit we can move the contract into the PendingStart status
322         if (teams.length == TEAMS_TOTAL) {
323             competitionStatus = CompetitionStatuses.PendingStart;
324         }
325     }
326 
327     function hasPreviouslyEnteredCardIds(uint[] cardIds) view internal returns (bool) {
328         if (teams.length == 0) {
329             return false;
330         }
331 
332         // This should only ever be a maximum of 5 iterations or 11
333         for (uint i = 0; i < cardIds.length; i++) {
334             uint cardId = cardIds[i];
335             bool hasEnteredCardPreviously = cardIdToEntryStatus[cardId];
336             if (hasEnteredCardPreviously) {
337                 return true;
338             }
339         }
340 
341         return false;
342     }
343 
344     function hasEntered(address manager) view internal returns (bool) {
345         if (teams.length == 0) {
346             return false;
347         }
348 
349         // We have to lookup the team AND check the fields because of some of the workings of solidity
350         // 1. We could have a team at index 0, so we CAN'T just check the index is > 0
351         // 2. Solidity intializes with an empty set of struct values, so we need to do equality on the manager field
352         uint teamIndex = managerToTeamId[manager];
353         Team memory team = teams[teamIndex];
354         if (team.manager == manager) {
355             return true;
356         }
357 
358         return false;
359     }
360 
361     function setMainContract(address _address) external onlyOwner {
362         BCFMain candidateContract = BCFMain(_address);
363         require(candidateContract.implementsERC721());
364         mainContract = candidateContract;
365     }
366 
367     // ** Match Simulator **
368     function calculateScorersForTeamIds(uint homeTeamId, uint awayTeamId) internal view returns (uint[], uint[]) {
369         
370         var (homeTotals, homeCardsShootingAttributes) = calculateAttributeTotals(homeTeamId);
371         var (awayTotals, awayCardsShootingAttributes) = calculateAttributeTotals(awayTeamId); 
372         
373         uint startSeed = now;
374         var (homeGoals, awayGoals) = calculateGoalsFromAttributeTotals(homeTeamId, awayTeamId, homeTotals, awayTotals, startSeed);
375 
376         uint[] memory homeScorers = new uint[](homeGoals);
377         uint[] memory awayScorers = new uint[](awayGoals);
378 
379         // Home Scorers
380         for (uint i = 0; i < homeScorers.length; i++) {
381             homeScorers[i] = determineGoalScoringCardIds(teams[homeTeamId].cardIds, homeCardsShootingAttributes, i);
382         }
383 
384         // Away Scorers
385         for (i = 0; i < awayScorers.length; i++) {
386             awayScorers[i] = determineGoalScoringCardIds(teams[awayTeamId].cardIds, awayCardsShootingAttributes, i);
387         }
388 
389         return (homeScorers, awayScorers);
390     }
391 
392     function calculateGoalsFromAttributeTotals(uint homeTeamId, uint awayTeamId, uint[] homeTotals, uint[] awayTotals, uint startSeed) internal view returns (uint _homeGoals, uint _awayGoals) {
393 
394         uint[] memory atkAttributes = new uint[](3); // 0 = possession, 1 = chance, 2 = shooting
395         uint[] memory defAttributes = new uint[](3); // 0 = regain posession, 1 = prevent chance, 3 = save shot
396 
397         uint attackingTeamId = 0;
398         uint defendingTeamId = 0;
399         uint outcome = 0;
400         uint seed = startSeed * homeTotals[0] * awayTotals[0];
401 
402         for (uint i = 0; i < 45; i++) {
403             
404             attackingTeamId = determineAttackingOrDefendingOutcomeForAttributes(homeTeamId, awayTeamId, homeTotals[0], awayTotals[0], seed+now);
405             seed++;
406 
407             if (attackingTeamId == homeTeamId) {
408                 defendingTeamId = awayTeamId;
409                 atkAttributes[0] = homeTotals[3]; // Passing
410                 atkAttributes[1] = homeTotals[4]; // Dribbling
411                 atkAttributes[2] = homeTotals[2]; // Shooting
412                 defAttributes[0] = awayTotals[1]; // Pace
413                 defAttributes[1] = awayTotals[6]; // Physical
414                 defAttributes[2] = awayTotals[5]; // Defending
415             } else {
416                 defendingTeamId = homeTeamId;
417                 atkAttributes[0] = awayTotals[3]; // Passing
418                 atkAttributes[1] = awayTotals[4]; // Dribbling
419                 atkAttributes[2] = awayTotals[2]; // Shooting
420                 defAttributes[0] = homeTotals[1]; // Pace
421                 defAttributes[1] = homeTotals[6]; // Physical
422                 defAttributes[2] = homeTotals[5]; // Defending
423             }
424 
425             outcome = determineAttackingOrDefendingOutcomeForAttributes(attackingTeamId, defendingTeamId, atkAttributes[0], defAttributes[0], seed);
426 			if (outcome == defendingTeamId) {
427                 // Attack broken up
428 				continue;
429 			}
430             seed++;
431 
432             outcome = determineAttackingOrDefendingOutcomeForAttributes(attackingTeamId, defendingTeamId, atkAttributes[1], defAttributes[1], seed);
433 			if (outcome == defendingTeamId) {
434                 // Chance prevented
435 				continue;
436 			}
437             seed++;
438 
439             outcome = determineAttackingOrDefendingOutcomeForAttributes(attackingTeamId, defendingTeamId, atkAttributes[2], defAttributes[2], seed);
440 			if (outcome == defendingTeamId) {
441                 // Shot saved
442 				continue;
443 			}
444 
445             // GOAL - determine whether it was the home team who scored or the away team
446             if (attackingTeamId == homeTeamId) {
447                 // Home goal
448                 _homeGoals += 1;
449             } else {
450                 // Away goal
451                 _awayGoals += 1;
452             }
453         }
454     }
455 
456     function calculateAttributeTotals(uint teamId) internal view returns (uint[], uint[]) {
457         
458         // NOTE: We store these in an array because of stack too deep errors from Solidity, 
459         // We could seperate these out but in the end it will end up being uniweildly
460         // this is the case in subsquent arrays too, while not perfect does give us a bit more flexibility
461         uint[] memory totals = new uint[](7);
462         uint[] memory cardsShootingAttributes = new uint[](SQUAD_SIZE);
463         Team memory _team = teams[teamId];
464         
465         for (uint i = 0; i < SQUAD_SIZE; i++) {
466             var (overall,pace,shooting,passing,dribbling,defending,physical,,,,) = mainContract.getPlayerForCard(_team.cardIds[i]);
467 
468             // If it's a goalie we forego attack for increased shot stopping avbility
469             if (_team.cardIds[i] == _team.gkCardId && _team.gkCardId > 0) {
470                 totals[5] += (overall * 5);
471                 totals[6] += overall;
472                 cardsShootingAttributes[i] = 1; // Almost no chance for the GK to score
473             } else {
474                 totals[0] += overall;
475                 totals[1] += pace;
476                 totals[2] += shooting;
477                 totals[3] += passing;
478                 totals[4] += dribbling;
479                 totals[5] += defending;
480                 totals[6] += physical;
481 
482                 cardsShootingAttributes[i] = shooting + dribbling; // Chance to score by combining shooting and dribbling
483             }
484         }
485 
486         return (totals, cardsShootingAttributes);
487     }
488 
489     function determineAttackingOrDefendingOutcomeForAttributes(uint attackingTeamId, uint defendingTeamId, uint atkAttributeTotal, uint defAttributeTotal, uint seed) internal view returns (uint) {
490         
491         uint max = atkAttributeTotal + defAttributeTotal;
492         uint randValue = uint(keccak256(block.blockhash(block.number-1), seed))%max;
493 
494         if (randValue <= atkAttributeTotal) {
495 		    return attackingTeamId;
496 	    }
497 
498 	    return defendingTeamId;
499     }
500 
501     function determineGoalScoringCardIds(uint[] cardIds, uint[] shootingAttributes, uint seed) internal view returns(uint) {
502 
503         uint max = 0;
504         uint min = 0;
505         for (uint i = 0; i < shootingAttributes.length; i++) {
506             max += shootingAttributes[i];
507         }
508 
509         bytes32 randHash = keccak256(seed, now, block.blockhash(block.number - 1));
510         uint randValue = uint(randHash) % max + min;
511 
512         for (i = 0; i < cardIds.length; i++) {
513             uint cardId = cardIds[i];
514             randValue -= shootingAttributes[i];
515 
516             // We do the more than to handle wrap arounds on uint
517             if (randValue <= 0 || randValue >= max) {
518                 return cardId;
519             }
520         }
521 
522         return cardIds[0];
523     }
524 
525     // ** Settlement **
526     function calculateWinningEntries() external onlyReferee {
527         require(competitionStatus == CompetitionStatuses.Finished);
528 
529         address[] memory winningAddresses = new address[](prizeBreakdown.length);
530         uint[] memory winningTeamIds = new uint[](prizeBreakdown.length);
531         uint[] memory winningTeamPoints = new uint[](prizeBreakdown.length);
532 
533         // League table position priority
534         // 1. Most Points
535         // 2. Biggest Goal Difference
536         // 3. Most Goals Scored
537         // 4. Number of Wins
538         // 5. First to Enter
539 
540         // 1. Loop over all teams
541         bool isReplacementWinner = false;
542         for (uint i = 0; i < teams.length; i++) {
543             Team memory _team = teams[i];
544 
545             // 2. Grab their current points
546             uint currPoints = (_team.wins * 3) + _team.draws;
547 
548             // 3. Compare the points to each team in the winning team points array
549             for (uint x = 0; x < winningTeamPoints.length; x++) {
550                 
551                 // 4. Check if the current entry is more
552                 isReplacementWinner = false;
553                 if (currPoints > winningTeamPoints[x]) {
554                     isReplacementWinner = true;
555                 // 5. We need to handle tie-break rules if 2 teams have the same number of points
556                 } else if (currPoints == winningTeamPoints[x]) {
557                     
558                     // 5a. Unfortunately in this scenario we need to refetch the team we're comparing
559                     Team memory _comparisonTeam = teams[winningTeamIds[x]];
560 
561                     int gdTeam = _team.goalsFor - _team.goalsAgainst;
562                     int gdComparedTeam = _comparisonTeam.goalsFor - _comparisonTeam.goalsAgainst;
563 
564                     // 5b. GOAL DIFFERENCE
565                     if (gdTeam > gdComparedTeam) {
566                         isReplacementWinner = true;
567                     } else if (gdTeam == gdComparedTeam) {
568 
569                         // 5c. MOST GOALS
570                         if (_team.goalsFor > _comparisonTeam.goalsFor) {
571                             isReplacementWinner = true;
572                         } else if (_team.goalsFor == _comparisonTeam.goalsFor) {
573 
574                             // 5d. NUMBER OF WINS
575                             if (_team.wins > _comparisonTeam.wins) {
576                                 isReplacementWinner = true;
577                             } else if (_team.wins == _comparisonTeam.wins) {
578 
579                                 // 5e. FIRST TO ENTER (LOWER INDEX)
580                                 if (i < winningTeamIds[x]) {
581                                     isReplacementWinner = true;
582                                 }
583                             }
584                         }
585                     }
586                 }
587 
588                 // 6. Now we need to shift all elements down for the "paid places" for winning entries
589                 if (isReplacementWinner) {
590                     
591                     // 7. We need to start by copying the current index into next one down, assuming it exists
592                     for (uint y = winningAddresses.length - 1; y > x; y--) {
593                         winningAddresses[y] = winningAddresses[y-1];
594                         winningTeamPoints[y] = winningTeamPoints[y-1];
595                         winningTeamIds[y] = winningTeamIds[y-1];
596                     }
597                     
598                     // 8. Set the current team and points as a replacemenet for the current entry
599                     winningAddresses[x] = _team.manager;
600                     winningTeamPoints[x] = currPoints;
601                     winningTeamIds[x] = i;
602                     break; // We don't need to compare values further down the chain
603                 }
604             }
605         }
606 
607         // Set the winning entries
608         winners = winningAddresses;
609     }
610 
611     function settleLeague() external onlyOwner {
612         require(competitionStatus == CompetitionStatuses.Finished);
613         require(winners.length > 0);
614         require(prizeBreakdown.length == winners.length);
615         require(prizePool >= this.balance);
616 
617         // Mark the contest as settled
618         competitionStatus = CompetitionStatuses.Settled;
619         
620         // Payout each winner
621         for (uint i = 0; i < winners.length; i++) {
622             address winner = winners[i];
623             uint percentageCut = prizeBreakdown[i]; // We can assume this index exists as we've checked the lengths in the require
624 
625             uint winningAmount = calculateWinnerCut(prizePool, percentageCut);
626             winner.transfer(winningAmount);
627         }
628     }
629 
630     function calculateWinnerCut(uint totalPot, uint cut) internal pure returns (uint256) {
631         // PRIZE_POT_PERCENTAGE_MAX = 10,000 = 100%, required'd <= PRIZE_POT_PERCENTAGE_MAX in the constructor so no requirement to validate here
632         uint finalCut = totalPot * cut / PRIZE_POT_PERCENTAGE_MAX;
633         return finalCut;
634     }  
635 
636     function withdrawBalance() external onlyOwner {
637         owner.transfer(this.balance);
638     }
639 
640     // Utils
641     function hasStarted() external view returns (bool) {
642         if (competitionStatus == CompetitionStatuses.Upcoming || competitionStatus == CompetitionStatuses.OpenForEntry || competitionStatus == CompetitionStatuses.PendingStart) {
643             return false;
644         }
645 
646         return true;
647     }
648 
649     function winningTeamId() external view returns (uint) {
650         require(competitionStatus == CompetitionStatuses.Finished || competitionStatus == CompetitionStatuses.Settled);
651 
652         uint winningTeamId = 0;
653         for (uint i = 0; i < teams.length; i++) {
654             if (teams[i].manager == winners[0]) {
655                 winningTeamId = i;
656                 break;
657             }
658         }
659 
660         return winningTeamId;
661     }
662 }