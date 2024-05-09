1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://eips.ethereum.org/EIPS/eip-20
6  */
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 /**
26  * @title Ownable
27  * @dev The Ownable contract has an owner address, and provides basic authorization control
28  * functions, this simplifies the implementation of "user permissions".
29  */
30 contract Ownable {
31     address private _owner;
32 
33     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35     /**
36      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
37      * account.
38      */
39     constructor () internal {
40         _owner = msg.sender;
41         emit OwnershipTransferred(address(0), _owner);
42     }
43 
44     /**
45      * @return the address of the owner.
46      */
47     function owner() public view returns (address) {
48         return _owner;
49     }
50 
51     /**
52      * @dev Throws if called by any account other than the owner.
53      */
54     modifier onlyOwner() {
55         require(isOwner());
56         _;
57     }
58 
59     /**
60      * @return true if `msg.sender` is the owner of the contract.
61      */
62     function isOwner() public view returns (bool) {
63         return msg.sender == _owner;
64     }
65 
66     /**
67      * @dev Allows the current owner to relinquish control of the contract.
68      * It will not be possible to call the functions with the `onlyOwner`
69      * modifier anymore.
70      * @notice Renouncing ownership will leave the contract without an owner,
71      * thereby removing any functionality that is only available to the owner.
72      */
73     function renounceOwnership() public onlyOwner {
74         emit OwnershipTransferred(_owner, address(0));
75         _owner = address(0);
76     }
77 
78     /**
79      * @dev Allows the current owner to transfer control of the contract to a newOwner.
80      * @param newOwner The address to transfer ownership to.
81      */
82     function transferOwnership(address newOwner) public onlyOwner {
83         _transferOwnership(newOwner);
84     }
85 
86     /**
87      * @dev Transfers control of the contract to a newOwner.
88      * @param newOwner The address to transfer ownership to.
89      */
90     function _transferOwnership(address newOwner) internal {
91         require(newOwner != address(0));
92         emit OwnershipTransferred(_owner, newOwner);
93         _owner = newOwner;
94     }
95 }
96 
97 contract EthMadness is Ownable {
98     
99     // Represents the submission to the contest.
100     struct Entrant {
101         // The user who submitted this entry
102         address submitter;
103         
104         // The "index" of this entry. Used to break ties incase two submissions are the same. (earlier submission wins)
105         uint48 entryIndex;
106     }
107     
108     // Represents a current top score in the contest
109     struct TopScore {
110         // The index of this entry (used for tie-breakas a de-dups)
111         uint48 entryIndex;
112 
113         // This bracket's score
114         uint32 score;
115 
116         // The total point differential for this bracket
117         uint64 difference;
118 
119         // The account which submitted this bracket
120         address submitter;
121     }
122     
123     // Represents the results of the contest. 
124     struct Result {
125         // The encoded results of the tournament
126         bytes16 winners;
127 
128         // Team A's score in the final
129         uint8 scoreA;
130 
131         // Team B's score in the final
132         uint8 scoreB;
133 
134         // Whether or not this is the final Results (used to tell if a vote is real or not)
135         bool isFinal;
136     }
137     
138     // Represents the various states that the contest will go through.
139     enum ContestState {
140         // The contest is open for people to submit entries. Oracles can also be added during this period.
141         OPEN_FOR_ENTRIES,
142         
143         // The tournament is in progress, no more entries can be received and no oracles can vote
144         TOURNAMENT_IN_PROGRESS,
145         
146         // The tournament is over and we're waiting for all the oracles to submit the results
147         WAITING_FOR_ORACLES,
148         
149         // The oracels have submitted the results and we're waiting for winners to claim their prize
150         WAITING_FOR_WINNING_CLAIMS,
151         
152         // The contest has completed and the winners have been paid out
153         COMPLETED
154     }
155     
156     // Maximum number of entries that will be allowed
157     uint constant MAX_ENTRIES = 2**48;
158     
159     // The number of entries which have been received.
160     uint48 entryCount = 0;
161     
162     // Map of the encoded entry to the user who crreated it.
163     mapping (uint256 => Entrant) public entries;
164     
165     // The times where we're allowed to transition the contract's state
166     mapping (uint => uint) public transitionTimes;
167     
168     // The current state of the contest
169     ContestState public currentState;
170     
171     // The recorded votes of our oracles
172     mapping (address => Result) public oracleVotes;
173     
174     // The oracles who will submit the results of the tournament
175     address[] public oracles;
176     
177     // The maximum number of oracles we'll allow vote in our contest
178     uint constant MAX_ORACLES = 10;
179     
180     // The final result of the tournament that the oracles agreed on
181     Result public finalResult;
182     
183     // Keeps the current top 3 best scores and who submitted them. When the contest ends, they'll be paid out
184     TopScore[3] public topThree;
185     
186     // The address of the ERC20 token that defines our prize
187     address public prizeERC20TokenAddress;
188     
189     // The amount of the prize to reward
190     uint public prizeAmount;
191     
192     // Event emitted when a new entry gets submitted to the contest
193     event EntrySubmitted(
194         // The account who submitted this bracket
195         address indexed submitter,
196 
197         // A compressed representation of the entry combining the picks and final game scores
198         uint256 indexed entryCompressed,
199 
200         // The order this entry was received. Used for tiebreaks
201         uint48 indexed entryIndex,
202 
203         // Optional bracket name provided by the submitter
204         string bracketName
205     );
206 
207     // Constructs a new instance of the EthMadness contract with the given transition times
208     constructor(uint[] memory times, address erc20Token, uint erc20Amount) public {
209         
210         // Initialize the oracles array with the sender's address
211         oracles = [msg.sender];
212         
213         // Set up our prize info
214         prizeERC20TokenAddress = erc20Token;
215         prizeAmount = erc20Amount;
216         
217         // Set up our transition times
218         require(times.length == 4);
219         transitionTimes[uint(ContestState.TOURNAMENT_IN_PROGRESS)] = times[0];
220         transitionTimes[uint(ContestState.WAITING_FOR_ORACLES)] = times[1];
221         transitionTimes[uint(ContestState.WAITING_FOR_WINNING_CLAIMS)] = times[2];
222         transitionTimes[uint(ContestState.COMPLETED)] = times[3];
223         
224         // The initial state should be allowing people to make entries
225         currentState = ContestState.OPEN_FOR_ENTRIES;
226     }
227 
228     // Gets the total number of entries we've received
229     function getEntryCount() public view returns (uint256) {
230         return entryCount;
231     }
232     
233     // Gets the number of Oracles we have registered
234     function getOracleCount() public view returns(uint256) {
235         return oracles.length;
236     }
237     
238     // Returns the transition times for our contest
239     function getTransitionTimes() public view returns (uint256, uint256, uint256, uint256) {
240         return (
241             transitionTimes[uint(ContestState.TOURNAMENT_IN_PROGRESS)],
242             transitionTimes[uint(ContestState.WAITING_FOR_ORACLES)],
243             transitionTimes[uint(ContestState.WAITING_FOR_WINNING_CLAIMS)],
244             transitionTimes[uint(ContestState.COMPLETED)]
245         );
246     }
247     
248     // Internal function for advancing the state of the bracket
249     function advanceState(ContestState nextState) private {
250         require(uint(nextState) == uint(currentState) + 1, "Can only advance state by 1");
251         require(now > transitionTimes[uint(nextState)], "Transition time hasn't happened yet");
252         
253         currentState = nextState;
254     }
255 
256     // Helper to make sure the picks submitted are legal
257     function arePicksOrResultsValid(bytes16 picksOrResults) public pure returns (bool) {
258         // Go through and make sure that this entry has 1 pick for each game
259         for (uint8 gameId = 0; gameId < 63; gameId++) {
260             uint128 currentPick = extractResult(picksOrResults, gameId);
261             if (currentPick != 2 && currentPick != 1) {
262                 return false;
263             }
264         }
265 
266         return true;
267     }
268     
269     // Submits a new entry to the tournament
270     function submitEntry(bytes16 picks, uint64 scoreA, uint64 scoreB, string memory bracketName) public {
271         require(currentState == ContestState.OPEN_FOR_ENTRIES, "Must be in the open for entries state");
272         require(arePicksOrResultsValid(picks), "The supplied picks are not valid");
273 
274         // Do some work to encode the picks and scores into a single uint256 which becomes a key
275         uint256 scoreAShifted = uint256(scoreA) * (2 ** (24 * 8));
276         uint256 scoreBShifted = uint256(scoreB) * (2 ** (16 * 8));
277         uint256 picksAsNumber = uint128(picks);
278         uint256 entryCompressed = scoreAShifted | scoreBShifted | picksAsNumber;
279 
280         require(entries[entryCompressed].submitter == address(0), "This exact bracket & score has already been submitted");
281         
282         // Emit the event that this entry was received and save the entry
283         emit EntrySubmitted(msg.sender, entryCompressed, entryCount, bracketName);
284         Entrant memory entrant = Entrant(msg.sender, entryCount);
285         entries[entryCompressed] = entrant;
286         entryCount++;
287     }
288 
289     // Adds an allowerd oracle who will vote on the results of the contest. Only the contract owner can do this
290     // and it can only be done while the tournament is still open for entries
291     function addOracle(address oracle) public onlyOwner {
292         require(currentState == ContestState.OPEN_FOR_ENTRIES, "Must be accepting entries");
293         require(oracles.length < MAX_ORACLES - 1, "Must be less than max number of oracles");
294         oracles.push(oracle);
295     }
296 
297     // In case something goes wrong, allow the owner to eject from the contract
298     // but only while picks are still being made or after the contest completes
299     function refundRemaining(uint256 amount) public onlyOwner {
300         require(currentState == ContestState.OPEN_FOR_ENTRIES || currentState == ContestState.COMPLETED, "Must be accepting entries");
301         
302         IERC20 erc20 = IERC20(prizeERC20TokenAddress);
303         erc20.transfer(msg.sender, amount);
304     }
305     
306     // Submits a new oracle's vote describing the results of the tournament
307     function submitOracleVote(uint oracleIndex, bytes16 winners, uint8 scoreA, uint8 scoreB) public {
308         require(currentState == ContestState.WAITING_FOR_ORACLES, "Must be in waiting for oracles state");
309         require(oracles[oracleIndex] == msg.sender, "Wrong oracle index");
310         require(arePicksOrResultsValid(winners), "Results are not valid");
311         oracleVotes[msg.sender] = Result(winners, scoreA, scoreB, true);
312     }
313     
314     // Close the voting and set the final result. Pass in what should be the consensus agreed by the
315     // 70% of the oracles
316     function closeOracleVoting(bytes16 winners, uint8 scoreA, uint8 scoreB) public {
317         require(currentState == ContestState.WAITING_FOR_ORACLES);
318 
319         // Count up how many oracles agree with this result
320         uint confirmingOracles = 0;
321         for (uint i = 0; i < oracles.length; i++) {
322             Result memory oracleVote = oracleVotes[oracles[i]];
323             if (oracleVote.isFinal &&
324                 oracleVote.winners == winners &&
325                 oracleVote.scoreA == scoreA &&
326                 oracleVote.scoreB == scoreB) {
327 
328                 confirmingOracles++;
329             }
330         }
331         
332         // Require 70%+ of Oracles to have voted and agree on the result
333         uint percentAggreement = (confirmingOracles * 100) / oracles.length;
334         require(percentAggreement > 70, "To close oracle voting, > 70% of oracles must agree");
335         
336         // Change the state and set our final result which will be used to compute scores
337         advanceState(ContestState.WAITING_FOR_WINNING_CLAIMS);
338         finalResult = Result(winners, scoreA, scoreB, true);
339     }
340     
341     // Closes the entry period and marks that the actual tournament is in progress
342     function markTournamentInProgress() public {
343         advanceState(ContestState.TOURNAMENT_IN_PROGRESS);
344         
345         require(oracles.length > 0, "Must have at least 1 oracle registered");
346         
347         // Require that we have the amount of funds locked in the contract we expect
348         IERC20 erc20 = IERC20(prizeERC20TokenAddress);
349         require(erc20.balanceOf(address(this)) >= prizeAmount, "Must have a balance in this contract");
350     }
351     
352     // Mark that the tournament has completed and oracles can start submitting results
353     function markTournamentFinished() public {
354         advanceState(ContestState.WAITING_FOR_ORACLES);
355     }
356     
357     // After the oracles have voted and winners have claimed their prizes, this closes the contest and
358     // pays out the winnings to the 3 winners
359     function closeContestAndPayWinners() public {
360         advanceState(ContestState.COMPLETED);
361         require(topThree[0].submitter != address(0), "Not enough claims");
362         require(topThree[1].submitter != address(0), "Not enough claims");
363         require(topThree[2].submitter != address(0), "Not enough claims");
364         
365         uint firstPrize = (prizeAmount * 70) / 100;
366         uint secondPrize = (prizeAmount * 20) / 100;
367         uint thirdPrize = (prizeAmount * 10) / 100;
368         IERC20 erc20 = IERC20(prizeERC20TokenAddress);
369         erc20.transfer(topThree[0].submitter, firstPrize);
370         erc20.transfer(topThree[1].submitter, secondPrize);
371         erc20.transfer(topThree[2].submitter, thirdPrize);
372     }
373     
374     // Scores an entry and places it in the right sort order
375     function scoreAndSortEntry(uint256 entryCompressed, bytes16 results, uint64 scoreAActual, uint64 scoreBActual) private returns (uint32) {
376         require(currentState == ContestState.WAITING_FOR_WINNING_CLAIMS, "Must be in the waiting for claims state");
377         require(entries[entryCompressed].submitter != address(0), "The entry must have actually been submitted");
378 
379         // Pull out the pick information from the compressed entry
380         bytes16 picks = bytes16(uint128((entryCompressed & uint256((2 ** 128) - 1))));
381         uint256 shifted = entryCompressed / (2 ** 128); // shift over 128 bits
382         uint64 scoreA = uint64((shifted & uint256((2 ** 64) - 1)));
383         shifted = entryCompressed / (2 ** 192);
384         uint64 scoreB = uint64((shifted & uint256((2 ** 64) - 1)));
385 
386         // Compute the score and the total difference
387         uint32 score = scoreEntry(picks, results);
388         uint64 difference = computeFinalGameDifference(scoreA, scoreB, scoreAActual, scoreBActual);
389 
390         // Make a score and place it in the right sort order
391         TopScore memory scoreResult = TopScore(entries[entryCompressed].entryIndex, score, difference, entries[entryCompressed].submitter);
392         if (isScoreBetter(scoreResult, topThree[0])) {
393             topThree[2] = topThree[1];
394             topThree[1] = topThree[0];
395             topThree[0] = scoreResult;
396         } else if (isScoreBetter(scoreResult, topThree[1])) {
397             topThree[2] = topThree[1];
398             topThree[1] = scoreResult;
399         } else if (isScoreBetter(scoreResult, topThree[2])) {
400             topThree[2] = scoreResult;
401         }
402         
403         return score;
404     }
405     
406     function claimTopEntry(uint256 entryCompressed) public {
407         require(currentState == ContestState.WAITING_FOR_WINNING_CLAIMS, "Must be in the waiting for winners state");
408         require(finalResult.isFinal, "The final result must be marked as final");
409         scoreAndSortEntry(entryCompressed, finalResult.winners, finalResult.scoreA, finalResult.scoreB);
410     }
411     
412     function computeFinalGameDifference(
413         uint64 scoreAGuess, uint64 scoreBGuess, uint64 scoreAActual, uint64 scoreBActual) private pure returns (uint64) {
414         
415         // Don't worry about overflow here, not much you can really do with it
416         uint64 difference = 0;
417         difference += ((scoreAActual > scoreAGuess) ? (scoreAActual - scoreAGuess) : (scoreAGuess - scoreAActual));
418         difference += ((scoreBActual > scoreBGuess) ? (scoreBActual - scoreBGuess) : (scoreBGuess - scoreBActual));
419         return difference;
420     }
421     
422     // Gets the bit at index n in a
423     function getBit16(bytes16 a, uint16 n) private pure returns (bool) {
424         uint128 mask = uint128(2) ** n;
425         return uint128(a) & mask != 0;
426     }
427     
428     // Sets the bit at index n to 1 in a
429     function setBit16(bytes16 a, uint16 n) private pure returns (bytes16) {
430         uint128 mask = uint128(2) ** n;
431         return a | bytes16(mask);
432     }
433     
434     // Sets the bit at index n to 0 in a
435     function clearBit16(bytes16 a, uint16 n) private pure returns (bytes16) {
436         uint128 mask = uint128(2) ** n;
437         mask = mask ^ uint128(-1);
438         return a & bytes16(mask);
439     }
440     
441     // Returns either 0 if there is no possible winner, 1 if team B is chosen, or 2 if team A is chosen
442     function extractResult(bytes16 a, uint8 n) private pure returns (uint128) {
443         uint128 mask = uint128(0x00000000000000000000000000000003) * uint128(2) ** (n * 2);
444         uint128 masked = uint128(a) & mask;
445         
446         // Shift back to get either 0, 1 or 2
447         return (masked / (uint128(2) ** (n * 2)));
448     }
449     
450     // Gets which round a game belongs to based on its id
451     function getRoundForGame(uint8 gameId) private pure returns (uint8) {
452         if (gameId < 32) {
453             return 0;
454         } else if (gameId < 48) {
455             return 1;
456         } else if (gameId < 56) {
457             return 2;
458         } else if (gameId < 60) {
459             return 3;
460         } else if (gameId < 62) {
461             return 4;
462         } else {
463             return 5;
464         }
465     }
466     
467     // Gets the first game in a round given the round number
468     function getFirstGameIdOfRound(uint8 round) private pure returns (uint8) {
469         if (round == 0) {
470             return 0;
471         } else if (round == 1) {
472             return 32;
473         } else if (round == 2) {
474             return 48;
475         } else if (round == 3) {
476             return 56;
477         } else if (round == 4) {
478             return 60;
479         } else {
480             return 62;
481         }
482     }
483     
484     // Looks at two scores and decided whether newScore is a better score than old score
485     function isScoreBetter(TopScore memory newScore, TopScore memory oldScore) private pure returns (bool) {
486         if (newScore.score > oldScore.score) {
487             return true;
488         }
489         
490         if (newScore.score < oldScore.score) {
491             return false;
492         }
493         
494         // Case where we have a tie
495         if (newScore.difference < oldScore.difference) {
496             return true;
497         }
498         
499         if (newScore.difference < oldScore.difference) {
500             return false;
501         }
502 
503         require(newScore.entryIndex != oldScore.entryIndex, "This entry has already claimed a prize");
504         
505         // Crazy case where we have the same score and same diference. Return the earlier entry as the winnner
506         return newScore.entryIndex < oldScore.entryIndex;
507     }
508     
509     // Scores an entry given the picks and the results
510     function scoreEntry(bytes16 picks, bytes16 results) private pure returns (uint32) {
511         uint32 score = 0;
512         uint8 round = 0;
513         bytes16 currentPicks = picks;
514         for (uint8 gameId = 0; gameId < 63; gameId++) {
515             
516             // Update which round we're in when on the transitions
517             round = getRoundForGame(gameId);
518             
519             uint128 currentPick = extractResult(currentPicks, gameId);
520             if (currentPick == extractResult(results, gameId)) {
521                 score += (uint32(2) ** round);
522             } else if (currentPick != 0) { // If we actually had a pick, propagate forward
523                 // Mark all the future currentPicks which required this team winning as null
524                 uint16 currentPickId = (gameId * 2) + (currentPick == 2 ? 1 : 0);
525                 for (uint8 futureRound = round + 1; futureRound < 6; futureRound++) {
526                     uint16 currentPickOffset = currentPickId - (getFirstGameIdOfRound(futureRound - 1) * 2);
527                     currentPickId = (getFirstGameIdOfRound(futureRound) * 2) + (currentPickOffset / 2);
528                     
529                     bool pickedLoser = getBit16(currentPicks, currentPickId);
530                     if (pickedLoser) {
531                         currentPicks = clearBit16(currentPicks, currentPickId);
532                     } else {
533                         break;
534                     }
535                 }
536             }
537         }
538         
539         return score;
540     }
541 }