1 pragma solidity 0.4.24;
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
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to relinquish control of the contract.
38    */
39   function renounceOwnership() public onlyOwner {
40     emit OwnershipRenounced(owner);
41     owner = address(0);
42   }
43 
44   /**
45    * @dev Allows the current owner to transfer control of the contract to a newOwner.
46    * @param _newOwner The address to transfer ownership to.
47    */
48   function transferOwnership(address _newOwner) public onlyOwner {
49     _transferOwnership(_newOwner);
50   }
51 
52   /**
53    * @dev Transfers control of the contract to a newOwner.
54    * @param _newOwner The address to transfer ownership to.
55    */
56   function _transferOwnership(address _newOwner) internal {
57     require(_newOwner != address(0));
58     emit OwnershipTransferred(owner, _newOwner);
59     owner = _newOwner;
60   }
61 }
62 
63 
64 /**
65  * @title Beths base contract
66  * @author clemlak (https://www.beths.co)
67  * @notice Place bets using Ether, based on the "pari mutuel" principle
68  * Only the owner of the contract can create bets, he can also take a cut on every payouts
69  * @dev This is the base contract for our dapp, we manage here all the things related to the "house"
70  */
71 contract BethsHouse is Ownable {
72   /**
73    * @notice Emitted when the house cut percentage is changed
74    * @param newHouseCutPercentage The new percentage
75    */
76   event HouseCutPercentageChanged(uint newHouseCutPercentage);
77 
78   /**
79    * @notice The percentage taken by the house on every game
80    * @dev Can be changed later with the changeHouseCutPercentage() function
81    */
82   uint public houseCutPercentage = 10;
83 
84   /**
85    * @notice Changes the house cut percentage
86    * @dev To prevent abuses, the new percentage is checked
87    * @param newHouseCutPercentage The new house cut percentage
88    */
89   function changeHouseCutPercentage(uint newHouseCutPercentage) external onlyOwner {
90     // This prevents us from being too greedy ;)
91     if (newHouseCutPercentage >= 0 && newHouseCutPercentage < 20) {
92       houseCutPercentage = newHouseCutPercentage;
93       emit HouseCutPercentageChanged(newHouseCutPercentage);
94     }
95   }
96 }
97 
98 
99 /**
100  * @title SafeMath
101  * @dev Math operations with safety checks that throw on error
102  */
103 library SafeMath {
104 
105   /**
106   * @dev Multiplies two numbers, throws on overflow.
107   */
108   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
109     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
110     // benefit is lost if 'b' is also tested.
111     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
112     if (a == 0) {
113       return 0;
114     }
115 
116     c = a * b;
117     assert(c / a == b);
118     return c;
119   }
120 
121   /**
122   * @dev Integer division of two numbers, truncating the quotient.
123   */
124   function div(uint256 a, uint256 b) internal pure returns (uint256) {
125     // assert(b > 0); // Solidity automatically throws when dividing by 0
126     // uint256 c = a / b;
127     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
128     return a / b;
129   }
130 
131   /**
132   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
133   */
134   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
135     assert(b <= a);
136     return a - b;
137   }
138 
139   /**
140   * @dev Adds two numbers, throws on overflow.
141   */
142   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
143     c = a + b;
144     assert(c >= a);
145     return c;
146   }
147 }
148 
149 
150 /**
151  * @title We manage all the things related to our games here
152  * @author Clemlak (https://www.beths.co)
153  */
154 contract BethsGame is BethsHouse {
155   /**
156    * @notice We use the SafeMath library in order to prevent overflow errors
157    * @dev Don't forget to use add(), sub(), ... instead of +, -, ...
158    */
159   using SafeMath for uint256;
160 
161   /**
162    * @notice Emitted when a new game is opened
163    * @param gameId The id of the corresponding game
164    * @param teamA The name of the team A
165    * @param teamB The name of the team B
166    * @param description A small description of the game
167    * @param frozenTimestamp The exact moment when the game will be frozen
168    */
169   event GameHasOpened(uint gameId, string teamA, string teamB, string description, uint frozenTimestamp);
170 
171   /**
172    * @notice Emitted when a game is frozen
173    * @param gameId The id of the corresponding game
174    */
175   event GameHasFrozen(uint gameId);
176 
177   /**
178    * @notice Emitted when a game is closed
179    * @param gameId The id of the corresponding game
180    * @param result The result of the game (see: enum GameResults)
181    */
182   event GameHasClosed(uint gameId, GameResults result);
183 
184   /**
185    * @notice All the different states a game can have (only 1 at a time)
186    */
187   enum GameStates { Open, Frozen, Closed }
188 
189   /**
190    * @notice All the possible results (only 1 at a time)
191    * @dev All new games are initialized with a NotYet result
192    */
193   enum GameResults { NotYet, TeamA, Draw, TeamB }
194 
195   /**
196    * @notice This struct defines what a game is
197    */
198   struct Game {
199     string teamA;
200     uint amountToTeamA;
201     string teamB;
202     uint amountToTeamB;
203     uint amountToDraw;
204     string description;
205     uint frozenTimestamp;
206     uint bettorsCount;
207     GameResults result;
208     GameStates state;
209     bool isHouseCutWithdrawn;
210   }
211 
212   /**
213   * @notice We store all our games in an array
214   */
215   Game[] public games;
216 
217   /**
218    * @notice This function creates a new game
219    * @dev Can only be called externally by the owner
220    * @param teamA The name of the team A
221    * @param teamB The name of the team B
222    * @param description A small description of the game
223    * @param frozenTimestamp A timestamp representing when the game will be frozen
224    */
225   function createNewGame(
226     string teamA,
227     string teamB,
228     string description,
229     uint frozenTimestamp
230   ) external onlyOwner {
231     // We push the new game directly into our array
232     uint gameId = games.push(Game(
233       teamA, 0, teamB, 0, 0, description, frozenTimestamp, 0, GameResults.NotYet, GameStates.Open, false
234     )) - 1;
235 
236     emit GameHasOpened(gameId, teamA, teamB, description, frozenTimestamp);
237   }
238 
239   /**
240    * @notice We use this function to froze a game
241    * @dev Can only be called externally by the owner
242    * @param gameId The id of the corresponding game
243    */
244   function freezeGame(uint gameId) external onlyOwner whenGameIsOpen(gameId) {
245     games[gameId].state = GameStates.Frozen;
246 
247     emit GameHasFrozen(gameId);
248   }
249 
250   /**
251    * @notice We use this function to close a game
252    * @dev Can only be called by the owner when a game is frozen
253    * @param gameId The id of a specific game
254    * @param result The result of the game (see: enum GameResults)
255    */
256   function closeGame(uint gameId, GameResults result) external onlyOwner whenGameIsFrozen(gameId) {
257     games[gameId].state = GameStates.Closed;
258     games[gameId].result = result;
259 
260     emit GameHasClosed(gameId, result);
261   }
262 
263   /**
264    * @notice Returns some basic information about a specific game
265    * @dev This function DOES NOT return the bets-related info, the current state or the result of the game
266    * @param gameId The id of the corresponding game
267    */
268   function getGameInfo(uint gameId) public view returns (
269     string,
270     string,
271     string
272   ) {
273     return (
274       games[gameId].teamA,
275       games[gameId].teamB,
276       games[gameId].description
277     );
278   }
279 
280   /**
281    * @notice Returns all the info related to the bets
282    * @dev Use other functions for more info
283    * @param gameId The id of the corresponding game
284    */
285   function getGameAmounts(uint gameId) public view returns (
286     uint,
287     uint,
288     uint,
289     uint,
290     uint
291   ) {
292     return (
293       games[gameId].amountToTeamA,
294       games[gameId].amountToDraw,
295       games[gameId].amountToTeamB,
296       games[gameId].bettorsCount,
297       games[gameId].frozenTimestamp
298     );
299   }
300 
301   /**
302    * @notice Returns the state of a specific game
303    * @dev Use other functions for more info
304    * @param gameId The id of the corresponding game
305    */
306   function getGameState(uint gameId) public view returns (GameStates) {
307     return games[gameId].state;
308   }
309 
310   /**
311    * @notice Returns the result of a specific game
312    * @dev Use other functions for more info
313    * @param gameId The id of the corresponding game
314    */
315   function getGameResult(uint gameId) public view returns (GameResults) {
316     return games[gameId].result;
317   }
318 
319   /**
320    * @notice Returns the total number of games
321    */
322   function getTotalGames() public view returns (uint) {
323     return games.length;
324   }
325 
326   /**
327    * @dev Compare 2 strings and returns true if they are identical
328    * This function even work if a string is in memory and the other in storage
329    * @param a The first string
330    * @param b The second string
331    */
332   function compareStrings(string a, string b) internal pure returns (bool) {
333     return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
334   }
335 
336   /**
337    * @dev Prevent to interact if the game is not open
338    * @param gameId The id of a specific game
339    */
340   modifier whenGameIsOpen(uint gameId) {
341     require(games[gameId].state == GameStates.Open);
342     _;
343   }
344 
345   /**
346    * @dev Prevent to interact if the game is not frozen
347    * @param gameId The id of a specific game
348    */
349   modifier whenGameIsFrozen(uint gameId) {
350     require(games[gameId].state == GameStates.Frozen);
351     _;
352   }
353 
354   /**
355    * @dev Prevent to interact if the game is not closed
356    * @param gameId The id of a specific game
357    */
358   modifier whenGameIsClosed(uint gameId) {
359     require(games[gameId].state == GameStates.Closed);
360     _;
361   }
362 }
363 
364 
365 /**
366  * @title We manage all the things related to our bets here
367  * @author Clemlak (https://www.beths.co)
368  */
369 contract BethsBet is BethsGame {
370   /**
371    * @notice Emitted when a new bet is placed
372    * @param gameId The name of the corresponding game
373    * @param result The result expected by the bettor (see: enum GameResults)
374    * @param amount How much the bettor placed
375    */
376   event NewBetPlaced(uint gameId, GameResults result, uint amount);
377 
378   /**
379    * @notice The minimum amount needed to place bet (in Wei)
380    * @dev Can be changed later by the changeMinimumBetAmount() function
381    */
382   uint public minimumBetAmount = 1000000000;
383 
384   /**
385    * @notice This struct defines what a bet is
386    */
387   struct Bet {
388     uint gameId;
389     GameResults result;
390     uint amount;
391     bool isPayoutWithdrawn;
392   }
393 
394   /**
395    * @notice We store all our bets in an array
396    */
397   Bet[] public bets;
398 
399   /**
400    * @notice This links bets with bettors
401    */
402   mapping (uint => address) public betToAddress;
403 
404   /**
405    * @notice This links the bettor to their bets
406    */
407   mapping (address => uint[]) public addressToBets;
408 
409   /**
410    * @notice Changes the minimum amount needed to place a bet
411    * @dev The amount is in Wei and must be greater than 0 (can only be changed by the owner)
412    * @param newMinimumBetAmount The new amount
413    */
414   function changeMinimumBetAmount(uint newMinimumBetAmount) external onlyOwner {
415     if (newMinimumBetAmount > 0) {
416       minimumBetAmount = newMinimumBetAmount;
417     }
418   }
419 
420   /**
421    * @notice Place a new bet
422    * @dev This function is payable and we'll use the amount we receive as the bet amount
423    * Bets can only be placed while the game is open
424    * @param gameId The id of the corresponding game
425    * @param result The result expected by the bettor (see enum GameResults)
426    */
427   function placeNewBet(uint gameId, GameResults result) public whenGameIsOpen(gameId) payable {
428     // We check if the bet amount is greater or equal to our minimum
429     if (msg.value >= minimumBetAmount) {
430       // We push our bet in our main array
431       uint betId = bets.push(Bet(gameId, result, msg.value, false)) - 1;
432 
433       // We link the bet with the bettor
434       betToAddress[betId] = msg.sender;
435 
436       // We link the address with their bets
437       addressToBets[msg.sender].push(betId);
438 
439       // Then we update our game
440       games[gameId].bettorsCount = games[gameId].bettorsCount.add(1);
441 
442       // And we update the amount bet on the expected result
443       if (result == GameResults.TeamA) {
444         games[gameId].amountToTeamA = games[gameId].amountToTeamA.add(msg.value);
445       } else if (result == GameResults.Draw) {
446         games[gameId].amountToDraw = games[gameId].amountToDraw.add(msg.value);
447       } else if (result == GameResults.TeamB) {
448         games[gameId].amountToTeamB = games[gameId].amountToTeamB.add(msg.value);
449       }
450 
451       // And finally we emit the corresponding event
452       emit NewBetPlaced(gameId, result, msg.value);
453     }
454   }
455 
456   /**
457    * @notice Returns an array containing the ids of the bets placed by a specific address
458    * @dev This function is meant to be used with the getBetInfo() function
459    * @param bettorAddress The address of the bettor
460    */
461   function getBetsFromAddress(address bettorAddress) public view returns (uint[]) {
462     return addressToBets[bettorAddress];
463   }
464 
465   /**
466    * @notice Returns the info of a specific bet
467    * @dev This function is meant to be used with the getBetsFromAddress() function
468    * @param betId The id of the specific bet
469    */
470   function getBetInfo(uint betId) public view returns (uint, GameResults, uint, bool) {
471     return (bets[betId].gameId, bets[betId].result, bets[betId].amount, bets[betId].isPayoutWithdrawn);
472   }
473 }
474 
475 
476 /**
477  * @title This contract handles all the functions related to the payouts
478  * @author Clemlak (https://www.beths.co)
479  * @dev This contract is still in progress
480  */
481 contract BethsPayout is BethsBet {
482   /**
483    * @notice We use this function to withdraw the house cut from a game
484    * @dev Can only be called externally by the owner when a game is closed
485    * @param gameId The id of a specific game
486    */
487   function withdrawHouseCutFromGame(uint gameId) external onlyOwner whenGameIsClosed(gameId) {
488     // We check if we haven't already withdrawn the cut
489     if (!games[gameId].isHouseCutWithdrawn) {
490       games[gameId].isHouseCutWithdrawn = true;
491       uint houseCutAmount = calculateHouseCutAmount(gameId);
492       owner.transfer(houseCutAmount);
493     }
494   }
495 
496   /**
497    * @notice This function is called by a bettor to withdraw his payout
498    * @dev This function can only be called externally
499    * @param betId The id of a specific bet
500    */
501   function withdrawPayoutFromBet(uint betId) external whenGameIsClosed(bets[betId].gameId) {
502     // We check if the bettor has won
503     require(games[bets[betId].gameId].result == bets[betId].result);
504 
505     // If he won, but we want to be sure that he didn't already withdraw his payout
506     if (!bets[betId].isPayoutWithdrawn) {
507       // Everything seems okay, so now we give the bettor his payout
508       uint payout = calculatePotentialPayout(betId);
509 
510       // We prevent the bettor to withdraw his payout more than once
511       bets[betId].isPayoutWithdrawn = true;
512 
513       address bettorAddress = betToAddress[betId];
514 
515       // We send the payout
516       bettorAddress.transfer(payout);
517     }
518   }
519 
520   /**
521    * @notice Returns the "raw" pool amount (including the amount of the house cut)
522    * @dev Can be called at any state of a game
523    * @param gameId The id of a specific game
524    */
525   function calculateRawPoolAmount(uint gameId) internal view returns (uint) {
526     return games[gameId].amountToDraw.add(games[gameId].amountToTeamA.add(games[gameId].amountToTeamB));
527   }
528 
529   /**
530    * @notice Returns the amount the house will take
531    * @dev Can be called at any state of a game
532    * @param gameId The id of a specific game
533    */
534   function calculateHouseCutAmount(uint gameId) internal view returns (uint) {
535     uint rawPoolAmount = calculateRawPoolAmount(gameId);
536     return houseCutPercentage.mul(rawPoolAmount.div(100));
537   }
538 
539   /**
540    * @notice Returns the total of the pool (minus the house part)
541    * @dev This value will be used to calculate the bettors' payouts
542    * @param gameId the id of a specific game
543    */
544   function calculatePoolAmount(uint gameId) internal view returns (uint) {
545     uint rawPoolAmount = calculateRawPoolAmount(gameId);
546     uint houseCutAmount = calculateHouseCutAmount(gameId);
547 
548     return rawPoolAmount.sub(houseCutAmount);
549   }
550 
551   /**
552    * @notice Returns the potential payout from a bet
553    * @dev Warning! This function DOES NOT check if the game is open/frozen/closed or if the bettor has won
554    * @param betId The id of a specific bet
555    */
556   function calculatePotentialPayout(uint betId) internal view returns (uint) {
557     uint betAmount = bets[betId].amount;
558 
559     uint poolAmount = calculatePoolAmount(bets[betId].gameId);
560 
561     uint temp = betAmount.mul(poolAmount);
562 
563     uint betAmountToWinningTeam = 0;
564 
565     if (games[bets[betId].gameId].result == GameResults.TeamA) {
566       betAmountToWinningTeam = games[bets[betId].gameId].amountToTeamA;
567     } else if (games[bets[betId].gameId].result == GameResults.TeamB) {
568       betAmountToWinningTeam = games[bets[betId].gameId].amountToTeamB;
569     } else if (games[bets[betId].gameId].result == GameResults.Draw) {
570       betAmountToWinningTeam = games[bets[betId].gameId].amountToDraw;
571     }
572 
573     return temp.div(betAmountToWinningTeam);
574   }
575 }