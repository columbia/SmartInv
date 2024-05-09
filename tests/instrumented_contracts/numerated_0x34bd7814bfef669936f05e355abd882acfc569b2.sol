1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: zeppelin-solidity/contracts/lifecycle/Destructible.sol
46 
47 /**
48  * @title Destructible
49  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
50  */
51 contract Destructible is Ownable {
52 
53   function Destructible() public payable { }
54 
55   /**
56    * @dev Transfers the current balance to the owner and terminates the contract.
57    */
58   function destroy() onlyOwner public {
59     selfdestruct(owner);
60   }
61 
62   function destroyAndSend(address _recipient) onlyOwner public {
63     selfdestruct(_recipient);
64   }
65 }
66 
67 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
68 
69 /**
70  * @title Pausable
71  * @dev Base contract which allows children to implement an emergency stop mechanism.
72  */
73 contract Pausable is Ownable {
74   event Pause();
75   event Unpause();
76 
77   bool public paused = false;
78 
79 
80   /**
81    * @dev Modifier to make a function callable only when the contract is not paused.
82    */
83   modifier whenNotPaused() {
84     require(!paused);
85     _;
86   }
87 
88   /**
89    * @dev Modifier to make a function callable only when the contract is paused.
90    */
91   modifier whenPaused() {
92     require(paused);
93     _;
94   }
95 
96   /**
97    * @dev called by the owner to pause, triggers stopped state
98    */
99   function pause() onlyOwner whenNotPaused public {
100     paused = true;
101     Pause();
102   }
103 
104   /**
105    * @dev called by the owner to unpause, returns to normal state
106    */
107   function unpause() onlyOwner whenPaused public {
108     paused = false;
109     Unpause();
110   }
111 }
112 
113 // File: zeppelin-solidity/contracts/math/SafeMath.sol
114 
115 /**
116  * @title SafeMath
117  * @dev Math operations with safety checks that throw on error
118  */
119 library SafeMath {
120 
121   /**
122   * @dev Multiplies two numbers, throws on overflow.
123   */
124   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
125     if (a == 0) {
126       return 0;
127     }
128     uint256 c = a * b;
129     assert(c / a == b);
130     return c;
131   }
132 
133   /**
134   * @dev Integer division of two numbers, truncating the quotient.
135   */
136   function div(uint256 a, uint256 b) internal pure returns (uint256) {
137     // assert(b > 0); // Solidity automatically throws when dividing by 0
138     uint256 c = a / b;
139     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
140     return c;
141   }
142 
143   /**
144   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
145   */
146   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
147     assert(b <= a);
148     return a - b;
149   }
150 
151   /**
152   * @dev Adds two numbers, throws on overflow.
153   */
154   function add(uint256 a, uint256 b) internal pure returns (uint256) {
155     uint256 c = a + b;
156     assert(c >= a);
157     return c;
158   }
159 }
160 
161 // File: zeppelin-solidity/contracts/payment/PullPayment.sol
162 
163 /**
164  * @title PullPayment
165  * @dev Base contract supporting async send for pull payments. Inherit from this
166  * contract and use asyncSend instead of send.
167  */
168 contract PullPayment {
169   using SafeMath for uint256;
170 
171   mapping(address => uint256) public payments;
172   uint256 public totalPayments;
173 
174   /**
175   * @dev withdraw accumulated balance, called by payee.
176   */
177   function withdrawPayments() public {
178     address payee = msg.sender;
179     uint256 payment = payments[payee];
180 
181     require(payment != 0);
182     require(this.balance >= payment);
183 
184     totalPayments = totalPayments.sub(payment);
185     payments[payee] = 0;
186 
187     assert(payee.send(payment));
188   }
189 
190   /**
191   * @dev Called by the payer to store the sent amount as credit to be pulled.
192   * @param dest The destination address of the funds.
193   * @param amount The amount to transfer.
194   */
195   function asyncSend(address dest, uint256 amount) internal {
196     payments[dest] = payments[dest].add(amount);
197     totalPayments = totalPayments.add(amount);
198   }
199 }
200 
201 // File: contracts/GoGlobals.sol
202 
203 /// @title The base contract for EthernalGo, contains the admin functions and the globals used throught the game
204 /// @author https://www.EthernalGo.com
205 /// @dev See the GoGameLogic and GoBoardMetaDetails contract documentation to understand the actual game mechanics.
206 contract GoGlobals is Ownable, PullPayment, Destructible, Pausable {
207 
208     // Used for simplifying capture calculations
209     uint8 constant MAX_UINT8 = 255;
210 
211     // Used to dermine player color and who is up next
212     enum PlayerColor {None, Black, White}
213 
214     ///    @dev Board status is a critical concept that determines which actions can be taken within each phase
215     ///        WaitForOpponent - When the first player has registered and waiting for a second player
216     ///        InProgress - The match is on! The acting player can choose between placing a stone or passing (or resigning)
217     ///        WaitingToResolve - Both players chose to pass their turn and we are waiting for the winner to ask the contract for  score count
218     ///        BlackWin, WhiteWin, Draw - Pretty self explanatory
219     ///        Canceled - The first player who joined the board is allowed to cancel a match if no opponent has joined yet
220     enum BoardStatus {WaitForOpponent, InProgress, WaitingToResolve, BlackWin, WhiteWin, Draw, Canceled}
221 
222     // We staretd with a 9x9 rows
223     uint8 constant BOARD_ROW_SIZE = 9;
224     uint8 constant BOARD_SIZE = BOARD_ROW_SIZE ** 2;
225 
226     // We use a shrinked board size to optimize gas costs
227     uint8 constant SHRINKED_BOARD_SIZE = 21;
228 
229     // These are the shares each player and EthernalGo are getting for each game
230     uint public WINNER_SHARE;
231     uint public HOST_SHARE;
232     uint public HONORABLE_LOSS_BONUS;
233 
234     // Each player gets PLAYER_TURN_SINGLE_PERIOD x PLAYER_START_PERIODS to act. These may change according to player feedback and network conjunction to optimize the playing experience
235     uint  public PLAYER_TURN_SINGLE_PERIOD = 4 minutes;
236     uint8 public PLAYER_START_PERIODS = 5;
237     
238     // We decided to restrict the table stakes to several options to allow for easier match-making
239     uint[] public tableStakesOptions;
240 
241     // This is the main data field that contains access to all of the GoBoards that were created
242     GoBoard[] internal allBoards;
243 
244     // The CFO is the only account that is allowed to withdraw funds
245     address public CFO;
246 
247     // This is the main board structure and is instantiated for every new game
248     struct GoBoard {        
249         // We use the last update to determine how long has it been since the player could act
250         uint lastUpdate;
251         
252         // The table stakes marks how much ETH each participant needs to pay to register for the board
253         uint tableStakes;
254         
255         // The board balance keeps track of how much ETH this board has in order to see if we already distributed the payments for this match
256         uint boardBalance;
257 
258         // Black and white player addresses
259         address blackAddress;
260         address whiteAddress;
261 
262         // Black and white time periods remaining (initially they will be PLAYER_START_PERIODS)
263         uint8 blackPeriodsRemaining;
264         uint8 whitePeriodsRemaining;
265 
266         // Keep track of double pass to finish the game
267         bool didPassPrevTurn;
268         
269         // Keep track of double pass to finish the game
270         bool isHonorableLoss;
271 
272         // Who's next
273         PlayerColor nextTurnColor;
274 
275         // Use a mapping to figure out which stone is set in which position. (Positions can be 0-BOARD_SIZE)
276         // @dev We decided not use an array to minimize the storage cost
277         mapping(uint8=>uint8) positionToColor;
278 
279         // The board's current status        
280         BoardStatus status;
281     }
282 
283     /// @notice The constructor is called with our inital values, they will probably change but this is what had in mind when developing the game.
284     function GoGlobals() public Ownable() PullPayment() Destructible() {
285 
286         // Add initial price tiers so from variouos ranges
287         addPriceTier(0.5 ether);
288         addPriceTier(1 ether);
289         addPriceTier(5 ether);
290 
291         // These are the inital shares we've had in mind when developing the game
292         updateShares(950, 50, 5);
293         
294         // The CFO will be the owner, but it will change soon after the contract is deployed
295         CFO = owner;
296     }
297 
298     /// @notice In case we need extra price tiers (table stakes where people can play) we can add additional ones
299     /// @param price the price for the new price tier in WEI
300     function addPriceTier(uint price) public onlyOwner {
301         tableStakesOptions.push(price);
302     }
303 
304     /// If we need to update price tiers
305     /// @param priceTier the tier index from the array
306     /// @param price the new price to set
307     function updatePriceTier(uint8 priceTier, uint price) public onlyOwner {
308         tableStakesOptions[priceTier] = price;
309     }
310 
311     /// @notice If we need to adjust the amounts players or EthernalGo gets for each game
312     /// @param newWinnerShare the winner's share (out of 1000)
313     /// @param newHostShare EthernalGo's share (out of 1000)
314     /// @param newBonusShare Bonus that comes our of EthernalGo and goes to the loser in case of an honorable loss (out of 1000)
315     function updateShares(uint newWinnerShare, uint newHostShare, uint newBonusShare) public onlyOwner {
316         require(newWinnerShare + newHostShare == 1000);
317         WINNER_SHARE = newWinnerShare;
318         HOST_SHARE = newHostShare;
319         HONORABLE_LOSS_BONUS = newBonusShare;
320     }
321 
322     /// @notice Separating the CFO and the CEO responsibilities requires the ability to set the CFO account
323     /// @param newCFO the new CFO
324     function setNewCFO(address newCFO) public onlyOwner {
325         require(newCFO != 0);
326         CFO = newCFO;
327     }
328 
329     /// @notice Separating the CFO and the CEO responsibilities requires the ability to set the CFO account
330     /// @param secondsPerPeriod The number of seconds we would like each period to last
331     /// @param numberOfPeriods The number of of periods each player initially has
332     function updateGameTimes(uint secondsPerPeriod, uint8 numberOfPeriods) public onlyOwner {
333 
334         PLAYER_TURN_SINGLE_PERIOD = secondsPerPeriod;
335         PLAYER_START_PERIODS = numberOfPeriods;
336     }
337 
338     /// @dev Convinience function to access the shares
339     function getShares() public view returns(uint, uint, uint) {
340         return (WINNER_SHARE, HOST_SHARE, HONORABLE_LOSS_BONUS);
341     }
342 }
343 
344 // File: contracts/GoBoardMetaDetails.sol
345 
346 /// @title This contract manages the meta details of EthernalGo. 
347 ///     Registering to a board, splitting the revenues and other day-to-day actions that are unrelated to the actual game
348 /// @author https://www.EthernalGo.com
349 /// @dev See the GoGameLogic to understand the actual game mechanics and rules
350 contract GoBoardMetaDetails is GoGlobals {
351     
352     /// @dev The player added to board event can be used to check upon registration success
353     event PlayerAddedToBoard(uint boardId, address playerAddress);
354     
355     /// @dev The board updated status can be used to get the new board status
356     event BoardStatusUpdated(uint boardId, BoardStatus newStatus);
357     
358     /// @dev The player withdrawn his accumulated balance 
359     event PlayerWithdrawnBalance(address playerAddress);
360     
361     /// @dev Simple wrapper to return the number of boards in total
362     function getTotalNumberOfBoards() public view returns(uint) {
363         return allBoards.length;
364     }
365 
366     /// @notice We would like to easily and transparantly share the game's statistics with anyone and present on the web-app
367     function getCompletedGamesStatistics() public view returns(uint, uint) {
368         uint completed = 0;
369         uint ethPaid = 0;
370         
371         // @dev Go through all the boards, we start with 1 as it's an unsigned int
372         for (uint i = 1; i <= allBoards.length; i++) {
373 
374             // Get the current board
375             GoBoard storage board = allBoards[i - 1];
376             
377             // Check if it was a victory, otherwise it's not interesting as the players just got their deposit back
378             if ((board.status == BoardStatus.BlackWin) || (board.status == BoardStatus.WhiteWin)) {
379                 ++completed;
380 
381                 // We need to query the table stakes as the board's balance will be zero once a game is finished
382                 ethPaid += board.tableStakes.mul(2);
383             }
384         }
385 
386         return (completed, ethPaid);
387     }
388 
389     /// @dev At this point there is no support for returning dynamic arrays (it's supported for web3 calls but not for internal testing) so we will "only" present the recent 50 games per player.
390     uint8 constant PAGE_SIZE = 50;
391 
392     /// @dev Make sure this board is in waiting for result status
393     modifier boardWaitingToResolve(uint boardId){
394         require(allBoards[boardId].status == BoardStatus.WaitingToResolve);
395         _;
396     }
397 
398     /// @dev Make sure this board is in one of the end of game states
399     modifier boardGameEnded(GoBoard storage board){
400         require(isEndGameStatus(board.status));
401         _;
402     }
403 
404     /// @dev Make sure this board still has balance
405     modifier boardNotPaid(GoBoard storage board){
406         require(board.boardBalance > 0);
407         _;
408     }
409 
410     /// @dev Make sure this board still has a spot for at least one player to join
411     modifier boardWaitingForPlayers(uint boardId){
412         require(allBoards[boardId].status == BoardStatus.WaitForOpponent &&
413                 (allBoards[boardId].blackAddress == 0 || 
414                  allBoards[boardId].whiteAddress == 0));
415         _;
416     }
417 
418     /// @dev Restricts games for the allowed table stakes
419     /// @param value the value we are looking for to register
420     modifier allowedValuesOnly(uint value){
421         bool didFindValue = false;
422         
423         // The number of tableStakesOptions can change hence it has to be dynamic
424         for (uint8 i = 0; i < tableStakesOptions.length; ++ i) {
425            if (value == tableStakesOptions[i])
426             didFindValue = true;
427         }
428 
429         require (didFindValue);
430         _;
431     }
432 
433     /// @dev Checks a status if and returns if it's an end game
434     /// @param status the value we are checking
435     /// @return true if it's an end-game status
436     function isEndGameStatus(BoardStatus status) public pure returns(bool) {
437         return (status == BoardStatus.BlackWin) || (status == BoardStatus.WhiteWin) || (status == BoardStatus.Draw) || (status == BoardStatus.Canceled);
438     }
439 
440     /// @dev Gets the update time for a board
441     /// @param boardId The id of the board to check
442     /// @return the update timestamp in seconds
443     function getBoardUpdateTime(uint boardId) public view returns(uint) {
444         GoBoard storage board = allBoards[boardId];
445         return (board.lastUpdate);
446     }
447 
448     /// @dev Gets the current board status
449     /// @param boardId The id of the board to check
450     /// @return the current board status
451     function getBoardStatus(uint boardId) public view returns(BoardStatus) {
452         GoBoard storage board = allBoards[boardId];
453         return (board.status);
454     }
455 
456     /// @dev Gets the current balance of the board
457     /// @param boardId The id of the board to check
458     /// @return the current board balance in WEI
459     function getBoardBalance(uint boardId) public view returns(uint) {
460         GoBoard storage board = allBoards[boardId];
461         return (board.boardBalance);
462     }
463 
464     /// @dev Sets the current balance of the board, this is internal and is triggerred by functions run by external player actions
465     /// @param board The board to update
466     /// @param boardId The board's Id
467     /// @param newStatus The new status to set
468     function updateBoardStatus(GoBoard storage board, uint boardId, BoardStatus newStatus) internal {    
469         
470         // Save gas if we accidentally are trying to update to an existing update
471         if (newStatus != board.status) {
472             
473             // Set the new board status
474             board.status = newStatus;
475             
476             // Update the time (important for start and finish states)
477             board.lastUpdate = now;
478 
479             // If this is an end game status
480             if (isEndGameStatus(newStatus)) {
481 
482                 // Credit the players accoriding to the board score
483                 creditBoardGameRevenues(board);
484             }
485 
486             // Notify status update
487             BoardStatusUpdated(boardId, newStatus);
488         }
489     }
490 
491     /// @dev Overload to set the board status when we only have a boardId
492     /// @param boardId The boardId to update
493     /// @param newStatus The new status to set
494     function updateBoardStatus(uint boardId, BoardStatus newStatus) internal {
495         updateBoardStatus(allBoards[boardId], boardId, newStatus);
496     }
497 
498     /// @dev Gets the player color given an address and board (overload for when we only have boardId)
499     /// @param boardId The boardId to check
500     /// @param searchAddress The player's address we are searching for
501     /// @return the player's color
502     function getPlayerColor(uint boardId, address searchAddress) internal view returns (PlayerColor) {
503         return (getPlayerColor(allBoards[boardId], searchAddress));
504     }
505     
506     /// @dev Gets the player color given an address and board
507     /// @param board The board to check
508     /// @param searchAddress The player's address we are searching for
509     /// @return the player's color
510     function getPlayerColor(GoBoard storage board, address searchAddress) internal view returns (PlayerColor) {
511 
512         // Check if this is the black player
513         if (board.blackAddress == searchAddress) {
514             return (PlayerColor.Black);
515         }
516 
517         // Check if this is the white player
518         if (board.whiteAddress == searchAddress) {
519             return (PlayerColor.White);
520         }
521 
522         // We aren't suppose to try and get the color of a player if they aren't on the board
523         revert();
524     }
525 
526     /// @dev Gets the player address given a color on the board
527     /// @param boardId The board to check
528     /// @param color The color of the player we want
529     /// @return the player's address
530     function getPlayerAddress(uint boardId, PlayerColor color) public view returns(address) {
531 
532         // If it's the black player
533         if (color == PlayerColor.Black) {
534             return allBoards[boardId].blackAddress;
535         }
536 
537         // If it's the white player
538         if (color == PlayerColor.White) {
539             return allBoards[boardId].whiteAddress;
540         }
541 
542         // We aren't suppose to try and get the color of a player if they aren't on the board
543         revert();
544     }
545 
546     /// @dev Check if a player is on board (overload for boardId)
547     /// @param boardId The board to check
548     /// @param searchAddress the player's address we want to check
549     /// @return true if the player is playing in the board
550     function isPlayerOnBoard(uint boardId, address searchAddress) public view returns(bool) {
551         return (isPlayerOnBoard(allBoards[boardId], searchAddress));
552     }
553 
554     /// @dev Check if a player is on board
555     /// @param board The board to check
556     /// @param searchAddress the player's address we want to check
557     /// @return true if the player is playing in the board
558     function isPlayerOnBoard(GoBoard storage board, address searchAddress) private view returns(bool) {
559         return (board.blackAddress == searchAddress || board.whiteAddress == searchAddress);
560     }
561 
562     /// @dev Check which player acts next
563     /// @param boardId The board to check
564     /// @return The color of the current player to act
565     function getNextTurnColor(uint boardId) public view returns(PlayerColor) {
566         return allBoards[boardId].nextTurnColor;
567     }
568 
569     /// @notice This is the first function a player will be using in order to start playing. This function allows 
570     ///  to register to an existing or a new board, depending on the current available boards.
571     ///  Upon registeration the player will pay the board's stakes and will be the black or white player.
572     ///  The black player also creates the board, and is the first player which gives a small advantage in the
573     ///  game, therefore we decided that the black player will be the one paying for the additional gas
574     ///  that is required to create the board.
575     /// @param  tableStakes The tablestakes to use, although this appears in the "value" of the message, we preferred to
576     ///  add it as an additional parameter for client use for clients that allow to customize the value parameter.
577     /// @return The boardId the player registered to (either a new board or an existing board)
578     function registerPlayerToBoard(uint tableStakes) external payable allowedValuesOnly(msg.value) whenNotPaused returns(uint) {
579         // Make sure the value and tableStakes are the same
580         require (msg.value == tableStakes);
581         GoBoard storage boardToJoin;
582         uint boardIDToJoin;
583         
584         // Check which board to connect to
585         (boardIDToJoin, boardToJoin) = getOrCreateWaitingBoard(tableStakes);
586         
587         // Add the player to the board (they already paid)
588         bool shouldStartGame = addPlayerToBoard(boardToJoin, tableStakes);
589 
590         // Fire the event for anyone listening
591         PlayerAddedToBoard(boardIDToJoin, msg.sender);
592 
593         // If we have both players, start the game
594         if (shouldStartGame) {
595 
596             // Start the game
597             startBoardGame(boardToJoin, boardIDToJoin);
598         }
599 
600         return boardIDToJoin;
601     }
602 
603     /// @notice This function allows a player to cancel a match in the case they were waiting for an opponent for
604     ///  a long time but didn't find anyone and would want to get their deposit of table stakes back.
605     ///  That player may cancel the game as long as no opponent was found and the deposit will be returned in full (though gas fees still apply). The player will also need to withdraw funds from the contract after this action.
606     /// @param boardId The board to cancel
607     function cancelMatch(uint boardId) external {
608         
609         // Get the player
610         GoBoard storage board = allBoards[boardId];
611 
612         // Make sure this player is on board
613         require(isPlayerOnBoard(boardId, msg.sender));
614 
615         // Make sure that the game hasn't started
616         require(board.status == BoardStatus.WaitForOpponent);
617 
618         // Update the board status to cancel (which also triggers the revenue sharing function)
619         updateBoardStatus(board, boardId, BoardStatus.Canceled);
620     }
621 
622     /// @dev Gets the current player boards to present to the player as needed
623     /// @param activeTurnsOnly We might want to highlight the boards where the player is expected to act
624     /// @return an array of PAGE_SIZE with the number of boards found and the actual IDs
625     function getPlayerBoardsIDs(bool activeTurnsOnly) public view returns (uint, uint[PAGE_SIZE]) {
626         uint[PAGE_SIZE] memory playerBoardIDsToReturn;
627         uint numberOfPlayerBoardsToReturn = 0;
628         
629         // Look at the recent boards until you find a player board
630         for (uint currBoard = allBoards.length; currBoard > 0 && numberOfPlayerBoardsToReturn < PAGE_SIZE; currBoard--) {
631             uint boardID = currBoard - 1;            
632 
633             // We only care about boards the player is in
634             if (isPlayerOnBoard(boardID, msg.sender)) {
635 
636                 // Check if the player is the next to act, or just include it if it wasn't requested
637                 if (!activeTurnsOnly || getNextTurnColor(boardID) == getPlayerColor(boardID, msg.sender)) {
638                     playerBoardIDsToReturn[numberOfPlayerBoardsToReturn] = boardID;
639                     ++numberOfPlayerBoardsToReturn;
640                 }
641             }
642         }
643 
644         return (numberOfPlayerBoardsToReturn, playerBoardIDsToReturn);
645     }
646 
647     /// @dev Creates a new board in case no board was found for a player to register
648     /// @param tableStakesToUse The value used to set the board
649     /// @return the id of new board (which is it's position in the allBoards array)
650     function createNewGoBoard(uint tableStakesToUse) private returns(uint, GoBoard storage) {
651         GoBoard memory newBoard = GoBoard({lastUpdate: now,
652                                            isHonorableLoss: false,
653                                            tableStakes: tableStakesToUse,
654                                            boardBalance: 0,
655                                            blackAddress: 0,
656                                            whiteAddress: 0,
657                                            blackPeriodsRemaining: PLAYER_START_PERIODS,
658                                            whitePeriodsRemaining: PLAYER_START_PERIODS,
659                                            nextTurnColor: PlayerColor.None,
660                                            status:BoardStatus.WaitForOpponent,
661                                            didPassPrevTurn:false});
662 
663         uint boardId = allBoards.push(newBoard) - 1;
664         return (boardId, allBoards[boardId]);
665     }
666 
667     /// @dev Creates a new board in case no board was found for a player to register
668     /// @param tableStakes The value used to set the board
669     /// @return the id of new board (which is it's position in the allBoards array)
670     function getOrCreateWaitingBoard(uint tableStakes) private returns(uint, GoBoard storage) {
671         bool wasFound = false;
672         uint selectedBoardId = 0;
673         GoBoard storage board;
674 
675         // First, try to find a board that has an empty spot and the right table stakes
676         for (uint i = allBoards.length; i > 0 && !wasFound; --i) {
677             board = allBoards[i - 1];
678 
679             // Make sure this board is already waiting and it's stakes are the same
680             if (board.tableStakes == tableStakes) {
681                 
682                 // If this board is waiting for an opponent
683                 if (board.status == BoardStatus.WaitForOpponent) {
684                     
685                     // Awesome, we have the board and we are done
686                     wasFound = true;
687                     selectedBoardId = i - 1;
688                 }
689 
690                 // If we found the rights stakes board but it isn't waiting for player we won't have another empty board.
691                 // We need to create a new one
692                 break;
693             }
694         }
695 
696         // Create a new board if we couldn't find one
697         if (!wasFound) {
698             (selectedBoardId, board) = createNewGoBoard(tableStakes);
699         }
700 
701         return (selectedBoardId, board);
702     }
703 
704     /// @dev Starts the game and sets everything up for the match
705     /// @param board The board to update with the starting data
706     /// @param boardId The board's Id
707     function startBoardGame(GoBoard storage board, uint boardId) private {
708         
709         // Make sure both players are present
710         require(board.blackAddress != 0 && board.whiteAddress != 0);
711         
712         // The black is always the first player in GO
713         board.nextTurnColor = PlayerColor.Black;
714 
715         // Save the game start time and set the game status to in progress
716         updateBoardStatus(board, boardId, BoardStatus.InProgress);
717     }
718 
719     /// @dev Handles the registration of a player to a board
720     /// @param board The board to update with the starting data
721     /// @param paidAmount The amount the player paid to start playing (will be added to the board balance)
722     /// @return true if the game should be started
723     function addPlayerToBoard(GoBoard storage board, uint paidAmount) private returns(bool) {
724         
725         // Make suew we are still waitinf for opponent (otherwise we can't add players)
726         bool shouldStartTheGame = false;
727         require(board.status == BoardStatus.WaitForOpponent);
728 
729         // Check that the player isn't already on the board, otherwise they would pay twice for a single board... :( 
730         require(!isPlayerOnBoard(board, msg.sender));
731 
732         // We always add the black player first as they created the board
733         if (board.blackAddress == 0) {
734             board.blackAddress = msg.sender;
735         
736         // If we have a black player, add the white player
737         } else if (board.whiteAddress == 0) {
738             board.whiteAddress = msg.sender;
739         
740             // Once the white player has been added, we can start the match
741             shouldStartTheGame = true;           
742 
743         // If both addresses are occuipied and we got here, it's a problem
744         } else {
745             revert();
746         }
747 
748         // Credit the board with what we know 
749         board.boardBalance += paidAmount;
750 
751         return shouldStartTheGame;
752     }
753 
754     /// @dev Helper function to caclulate how much time a player used since now
755     /// @param lastUpdate the timestamp of last update of the board
756     /// @return the number of periods used for this time
757     function getTimePeriodsUsed(uint lastUpdate) private view returns(uint8) {
758         return uint8(now.sub(lastUpdate).div(PLAYER_TURN_SINGLE_PERIOD));
759     }
760 
761     /// @notice Convinience function to help present how much time a player has.
762     /// @param boardId the board to check.
763     /// @param color the color of the player to check.
764     /// @return The number of time periods the player has, the number of seconds per each period and the total number of seconds for convinience.
765     function getPlayerRemainingTime(uint boardId, PlayerColor color) view external returns (uint, uint, uint) {
766         GoBoard storage board = allBoards[boardId];
767 
768         // Always verify we can act
769         require(board.status == BoardStatus.InProgress);
770 
771         // Get the total remaining time:
772         uint timePeriods = getPlayerTimePeriods(board, color);
773         uint totalTimeRemaining = timePeriods * PLAYER_TURN_SINGLE_PERIOD;
774 
775         // If this is the acting player
776         if (color == board.nextTurnColor) {
777 
778             // Calc time periods for player
779             uint timePeriodsUsed = getTimePeriodsUsed(board.lastUpdate);
780             if (timePeriods > timePeriodsUsed) {
781                 timePeriods -= timePeriodsUsed;
782             } else {
783                 timePeriods = 0;
784             }
785 
786             // Calc total time remaining  for player
787             uint timeUsed = (now - board.lastUpdate);
788             
789             // Safely reduce the time used
790             if (totalTimeRemaining > timeUsed) {
791                 totalTimeRemaining -= timeUsed;
792             
793             // A player can't have less than zero time to act
794             } else {
795                 totalTimeRemaining = 0;
796             }
797         }
798         
799         return (timePeriods, PLAYER_TURN_SINGLE_PERIOD, totalTimeRemaining);
800     }
801 
802     /// @dev After a player acted we might need to reduce the number of remaining time periods.
803     /// @param board The board the player acted upon.
804     /// @param color the color of the player that acted.
805     /// @param timePeriodsUsed the number of periods the player used.
806     function updatePlayerTimePeriods(GoBoard storage board, PlayerColor color, uint8 timePeriodsUsed) internal {
807 
808         // Reduce from the black player
809         if (color == PlayerColor.Black) {
810 
811             // The player can't have less than 0 periods remaining
812             board.blackPeriodsRemaining = board.blackPeriodsRemaining > timePeriodsUsed ? board.blackPeriodsRemaining - timePeriodsUsed : 0;
813         // Reduce from the white player
814         } else if (color == PlayerColor.White) {
815             
816             // The player can't have less than 0 periods remaining
817             board.whitePeriodsRemaining = board.whitePeriodsRemaining > timePeriodsUsed ? board.whitePeriodsRemaining - timePeriodsUsed : 0;
818 
819         // We are not supposed to get here
820         } else {
821             revert();
822         }
823     }
824 
825     /// @dev Helper function to access the time periods of a player in a board.
826     /// @param board The board to check.
827     /// @param color the color of the player to check.
828     /// @return The number of time periods remaining for this player
829     function getPlayerTimePeriods(GoBoard storage board, PlayerColor color) internal view returns (uint8) {
830 
831         // For the black player
832         if (color == PlayerColor.Black) {
833             return board.blackPeriodsRemaining;
834 
835         // For the white player
836         } else if (color == PlayerColor.White) {
837             return board.whitePeriodsRemaining;
838 
839         // We are not supposed to get here
840         } else {
841 
842             revert();
843         }
844     }
845 
846     /// @notice The main function to split game revenues, this is triggered only by changing the game's state
847     ///  to one of the ending game states.
848     ///  We make sure this board has a balance and that it's only running once a board game has ended
849     ///  We used numbers for easier read through as this function is critical for the revenue sharing model
850     /// @param board The board the credit will come from.
851     function creditBoardGameRevenues(GoBoard storage board) private boardGameEnded(board) boardNotPaid(board) {
852                 
853         // Get the shares from the globals
854         uint updatedHostShare = HOST_SHARE;
855         uint updatedLoserShare = 0;
856 
857         // Start accumulating funds for each participant and EthernalGo's CFO
858         uint amountBlack = 0;
859         uint amountWhite = 0;
860         uint amountCFO = 0;
861         uint fullAmount = 1000;
862 
863         // Incentivize resigns and quick end-games for the loser
864         if (board.status == BoardStatus.BlackWin || board.status == BoardStatus.WhiteWin) {
865             
866             // In case the game ended honorably (not by time out), the loser will get credit (from the CFO's share)
867             if (board.isHonorableLoss) {
868                 
869                 // Reduce the credit from the CFO
870                 updatedHostShare = HOST_SHARE - HONORABLE_LOSS_BONUS;
871                 
872                 // Add to the loser share
873                 updatedLoserShare = HONORABLE_LOSS_BONUS;
874             }
875 
876             // If black won
877             if (board.status == BoardStatus.BlackWin) {
878                 
879                 // Black should get the winner share
880                 amountBlack = board.boardBalance.mul(WINNER_SHARE).div(fullAmount);
881                 
882                 // White player should get the updated loser share (with or without the bonus)
883                 amountWhite = board.boardBalance.mul(updatedLoserShare).div(fullAmount);
884             }
885 
886             // If white won
887             if (board.status == BoardStatus.WhiteWin) {
888 
889                 // White should get the winner share
890                 amountWhite = board.boardBalance.mul(WINNER_SHARE).div(fullAmount);
891                 
892                 // Black should get the updated loser share (with or without the bonus)
893                 amountBlack = board.boardBalance.mul(updatedLoserShare).div(fullAmount);
894             }
895 
896             // The CFO should get the updates share if the game ended as expected
897             amountCFO = board.boardBalance.mul(updatedHostShare).div(fullAmount);
898         }
899 
900         // If the match ended in a draw or it was cancelled
901         if (board.status == BoardStatus.Draw || board.status == BoardStatus.Canceled) {
902             
903             // The CFO is not taking a share from draw or a cancelled match
904             amountCFO = 0;
905 
906             // If the white player was on board, we should split the balance in half
907             if (board.whiteAddress != 0) {
908 
909                 // Each player gets half of the balance
910                 amountBlack = board.boardBalance.div(2);
911                 amountWhite = board.boardBalance.div(2);
912 
913             // If there was only the black player, they should get the entire balance
914             } else {
915                 amountBlack = board.boardBalance;
916             }
917         }
918 
919         // Make sure we are going to split the entire amount and nothing gets left behind
920         assert(amountBlack + amountWhite + amountCFO == board.boardBalance);
921         
922         // Reset the balance
923         board.boardBalance = 0;
924 
925         // Async sends to the participants (this means each participant will be required to withdraw funds)
926         asyncSend(board.blackAddress, amountBlack);
927         asyncSend(board.whiteAddress, amountWhite);
928         asyncSend(CFO, amountCFO);
929     }
930 
931     /// @dev withdraw accumulated balance, called by payee.
932     function withdrawPayments() public {
933 
934         // Call Zeppelin's withdrawPayments
935         super.withdrawPayments();
936 
937         // Send an event
938         PlayerWithdrawnBalance(msg.sender);
939     }
940 }
941 
942 // File: contracts/GoGameLogic.sol
943 
944 /// @title The actual game logic for EthernalGo - setting stones, capturing, etc.
945 /// @author https://www.EthernalGo.com
946 contract GoGameLogic is GoBoardMetaDetails {
947 
948     /// @dev The StoneAddedToBoard event is fired when a new stone is added to the board, 
949     ///  and includes the board Id, stone color, row & column. This event will fire even if it was a suicide stone.
950     event StoneAddedToBoard(uint boardId, PlayerColor color, uint8 row, uint8 col);
951 
952     /// @dev The PlayerPassedTurn event is fired when a player passes turn 
953     ///  and includes the board Id, color.
954     event PlayerPassedTurn(uint boardId, PlayerColor color);
955     
956     /// @dev Updating the player's time periods left, according to the current time - board last update time.
957     ///  If the player does not have enough time and chose to act, the game will end and the player will lose.
958     /// @param board is the relevant board.
959     /// @param boardId is the board's Id.
960     /// @param color is the color of the player we want to update.
961     /// @return true if the player can continue playing, otherwise false.
962     function updatePlayerTime(GoBoard storage board, uint boardId, PlayerColor color) private returns(bool) {
963 
964         // Verify that the board is in progress and that it's the current player
965         require(board.status == BoardStatus.InProgress && board.nextTurnColor == color);
966 
967         // Calculate time periods used by the player
968         uint timePeriodsUsed = uint(now.sub(board.lastUpdate).div(PLAYER_TURN_SINGLE_PERIOD));
969 
970         // Subtract time periods if needed
971         if (timePeriodsUsed > 0) {
972 
973             // Can't spend more than MAX_UINT8
974             updatePlayerTimePeriods(board, color, timePeriodsUsed > MAX_UINT8 ? MAX_UINT8 : uint8(timePeriodsUsed));
975 
976             // The player losses when there aren't any time periods left
977             if (getPlayerTimePeriods(board, color) == 0) {
978                 playerLost(board, boardId, color);
979                 return false;
980             }
981         }
982 
983         return true;
984     }
985 
986     /// @notice Updates the board status according to the players score.
987     ///  Can only be called when the board is in a 'waitingToResolve' status.
988     /// @param boardId is the board to check and update
989     function checkVictoryByScore(uint boardId) external boardWaitingToResolve(boardId) {
990         
991         uint8 blackScore;
992         uint8 whiteScore;
993 
994         // Get the players' score
995         (blackScore, whiteScore) = calculateBoardScore(boardId);
996 
997         // Default to Draw
998         BoardStatus status = BoardStatus.Draw;
999 
1000         // If black's score is bigger than white's score, black is the winner
1001         if (blackScore > whiteScore) {
1002 
1003             status = BoardStatus.BlackWin;
1004         // If white's score is bigger, white is the winner
1005         } else if (whiteScore > blackScore) {
1006 
1007             status = BoardStatus.WhiteWin;
1008         }
1009 
1010         // Update the board's status
1011         updateBoardStatus(boardId, status);
1012     }
1013 
1014     /// @notice Performs a pass action on a psecific board, only by the current active color player.
1015     /// @param boardId is the board to perform pass on.
1016     function passTurn(uint boardId) external {
1017 
1018         // Get the board & player
1019         GoBoard storage board = allBoards[boardId];
1020         PlayerColor activeColor = getPlayerColor(board, msg.sender);
1021 
1022         // Verify the player can act
1023         require(board.status == BoardStatus.InProgress && board.nextTurnColor == activeColor);
1024         
1025         // Check if this player can act
1026         if (updatePlayerTime(board, boardId, activeColor)) {
1027 
1028             // If it's the second straight pass, the game is over
1029             if (board.didPassPrevTurn) {
1030 
1031                 // Finishing the game like this is considered honorable
1032                 board.isHonorableLoss = true;
1033 
1034                 // On second pass, the board status changes to 'WaitingToResolve'
1035                 updateBoardStatus(board, boardId, BoardStatus.WaitingToResolve);
1036 
1037             // If it's the first pass, we can simply continue
1038             } else {
1039 
1040                 // Move to the next player, flag that it was a pass action
1041                 nextTurn(board);
1042                 board.didPassPrevTurn = true;
1043 
1044                 // Notify the player passed turn
1045                 PlayerPassedTurn(boardId, activeColor);
1046             }
1047         }
1048     }
1049 
1050     /// @notice Resigns a player from a specific board, can get called by either player on the board.
1051     /// @param boardId is the board to resign from.
1052     function resignFromMatch(uint boardId) external {
1053 
1054         // Get the board, make sure it's in progress
1055         GoBoard storage board = allBoards[boardId];
1056         require(board.status == BoardStatus.InProgress);
1057 
1058         // Get the sender's color
1059         PlayerColor activeColor = getPlayerColor(board, msg.sender);
1060                 
1061         // Finishing the game like this is considered honorable
1062         board.isHonorableLoss = true;
1063 
1064         // Set that color as the losing player
1065         playerLost(board, boardId, activeColor);
1066     }
1067 
1068     /// @notice Claiming the current acting player on the board is out of time, thus losses the game.
1069     /// @param boardId is the board to claim it on.
1070     function claimActingPlayerOutOfTime(uint boardId) external {
1071 
1072         // Get the board, make sure it's in progress
1073         GoBoard storage board = allBoards[boardId];
1074         require(board.status == BoardStatus.InProgress);
1075 
1076         // Get the acting player color
1077         PlayerColor actingPlayerColor = getNextTurnColor(boardId);
1078 
1079         // Calculate remaining allowed time for the acting player
1080         uint playerTimeRemaining = PLAYER_TURN_SINGLE_PERIOD * getPlayerTimePeriods(board, actingPlayerColor);
1081 
1082         // If the player doesn't have enough time left, the player losses
1083         if (playerTimeRemaining < now - board.lastUpdate) {
1084             playerLost(board, boardId, actingPlayerColor);
1085         }
1086     }
1087 
1088     /// @dev Update a board status with a losing color
1089     /// @param board is the board to update.
1090     /// @param boardId is the board's Id.
1091     /// @param color is the losing player's color.
1092     function playerLost(GoBoard storage board, uint boardId, PlayerColor color) private {
1093 
1094         // If black is the losing color, white wins
1095         if (color == PlayerColor.Black) {
1096             updateBoardStatus(board, boardId, BoardStatus.WhiteWin);
1097         
1098         // If white is the losing color, black wins
1099         } else if (color == PlayerColor.White) {
1100             updateBoardStatus(board, boardId, BoardStatus.BlackWin);
1101 
1102         // There's an error, revert
1103         } else {
1104             revert();
1105         }
1106     }
1107 
1108     /// @dev Internally used to move to the next turn, by switching sides and updating the board last update time.
1109     /// @param board is the board to update.
1110     function nextTurn(GoBoard storage board) private {
1111         
1112         // Switch sides
1113         board.nextTurnColor = board.nextTurnColor == PlayerColor.Black ? PlayerColor.White : PlayerColor.Black;
1114 
1115         // Last update time
1116         board.lastUpdate = now;
1117     }
1118     
1119     /// @notice Adding a stone to a specific board and position (row & col).
1120     ///  Requires the board to be in progress, that the caller is the acting player, 
1121     ///  and that the spot on the board is empty.
1122     /// @param boardId is the board to add the stone to.
1123     /// @param row is the row for the new stone.
1124     /// @param col is the column for the new stone.
1125     function addStoneToBoard(uint boardId, uint8 row, uint8 col) external {
1126         
1127         // Get the board & sender's color
1128         GoBoard storage board = allBoards[boardId];
1129         PlayerColor activeColor = getPlayerColor(board, msg.sender);
1130 
1131         // Verify the player can act
1132         require(board.status == BoardStatus.InProgress && board.nextTurnColor == activeColor);
1133 
1134         // Calculate the position
1135         uint8 position = row * BOARD_ROW_SIZE + col;
1136         
1137         // Check that it's an empty spot
1138         require(board.positionToColor[position] == 0);
1139 
1140         // Update the player timeout (if the player doesn't have time left, discontinue)
1141         if (updatePlayerTime(board, boardId, activeColor)) {
1142 
1143             // Set the stone on the board
1144             board.positionToColor[position] = uint8(activeColor);
1145 
1146             // Run capture / suidice logic
1147             updateCaptures(board, position, uint8(activeColor));
1148             
1149             // Next turn logic
1150             nextTurn(board);
1151 
1152             // Clear the pass flag
1153             if (board.didPassPrevTurn) {
1154                 board.didPassPrevTurn = false;
1155             }
1156 
1157             // Fire the event
1158             StoneAddedToBoard(boardId, activeColor, row, col);
1159         }
1160     }
1161 
1162     /// @notice Returns a board's row details, specifies which color occupies which cell in that row.
1163     /// @dev It returns a row and not the entire board because some nodes might fail to return arrays larger than ~50.
1164     /// @param boardId is the board to inquire.
1165     /// @param row is the row to get details on.
1166     /// @return an array that contains the colors occupying each cell in that row.
1167     function getBoardRowDetails(uint boardId, uint8 row) external view returns (uint8[BOARD_ROW_SIZE]) {
1168         
1169         // The array to return
1170         uint8[BOARD_ROW_SIZE] memory rowToReturn;
1171 
1172         // For all columns, calculate the position and get the current status
1173         for (uint8 col = 0; col < BOARD_ROW_SIZE; col++) {
1174             
1175             uint8 position = row * BOARD_ROW_SIZE + col;
1176             rowToReturn[col] = allBoards[boardId].positionToColor[position];
1177         }
1178 
1179         // Return the array
1180         return (rowToReturn);
1181     }
1182 
1183     /// @notice Returns the current color of a specific position in a board.
1184     /// @param boardId is the board to inquire.
1185     /// @param row is part of the position to get details on.
1186     /// @param col is part of the position to get details on.
1187     /// @return the color occupying that position.
1188     function getBoardSingleSpaceDetails(uint boardId, uint8 row, uint8 col) external view returns (uint8) {
1189 
1190         uint8 position = row * BOARD_ROW_SIZE + col;
1191         return allBoards[boardId].positionToColor[position];
1192     }
1193 
1194     /// @dev Calcultes whether a position captures an enemy group, or whether it's a suicide. 
1195     ///  Updates the board accoridngly (clears captured groups, or the suiciding stone).
1196     /// @param board the board to check and update
1197     /// @param position the position of the new stone
1198     /// @param positionColor the color of the new stone (this param is sent to spare another reading op)
1199     function updateCaptures(GoBoard storage board, uint8 position, uint8 positionColor) private {
1200 
1201         // Group positions, used later
1202         uint8[BOARD_SIZE] memory group;
1203 
1204         // Is group captured, or free
1205         bool isGroupCaptured;
1206 
1207         // In order to save gas, we check suicide only if the position is fully surrounded and doesn't capture enemy groups 
1208         bool shouldCheckSuicide = true;
1209 
1210         // Get the position's adjacent cells
1211         uint8[MAX_ADJACENT_CELLS] memory adjacentArray = getAdjacentCells(position);
1212 
1213         // Run as long as there an adjacent cell, or until we reach the end of the array
1214         for (uint8 currAdjacentIndex = 0; currAdjacentIndex < MAX_ADJACENT_CELLS && adjacentArray[currAdjacentIndex] < MAX_UINT8; currAdjacentIndex++) {
1215 
1216             // Get the adjacent cell's color
1217             uint8 currColor = board.positionToColor[adjacentArray[currAdjacentIndex]];
1218 
1219             // If the enemy's color
1220             if (currColor != 0 && currColor != positionColor) {
1221 
1222                 // Get the group's info
1223                 (group, isGroupCaptured) = getGroup(board, adjacentArray[currAdjacentIndex], currColor);
1224 
1225                 // Captured a group
1226                 if (isGroupCaptured) {
1227                     
1228                     // Clear the group from the board
1229                     for (uint8 currGroupIndex = 0; currGroupIndex < BOARD_SIZE && group[currGroupIndex] < MAX_UINT8; currGroupIndex++) {
1230 
1231                         board.positionToColor[group[currGroupIndex]] = 0;
1232                     }
1233 
1234                     // Shouldn't check suicide
1235                     shouldCheckSuicide = false;
1236                 }
1237             // There's an empty adjacent cell
1238             } else if (currColor == 0) {
1239 
1240                 // Shouldn't check suicide
1241                 shouldCheckSuicide = false;
1242             }
1243         }
1244 
1245         // Detect suicide if needed
1246         if (shouldCheckSuicide) {
1247 
1248             // Get the new stone's surrounding group
1249             (group, isGroupCaptured) = getGroup(board, position, positionColor);
1250 
1251             // If the group is captured, it's a suicide move, remove it
1252             if (isGroupCaptured) {
1253 
1254                 // Clear added stone
1255                 board.positionToColor[position] = 0;
1256             }
1257         }
1258     }
1259 
1260     /// @dev Internally used to set a flag in a shrinked board array (used to save gas costs).
1261     /// @param visited the array to update.
1262     /// @param position the position on the board we want to flag.
1263     /// @param flag the flag we want to set (either 1 or 2).
1264     function setFlag(uint8[SHRINKED_BOARD_SIZE] visited, uint8 position, uint8 flag) private pure {
1265         visited[position / 4] |= flag << ((position % 4) * 2);
1266     }
1267 
1268     /// @dev Internally used to check whether a flag in a shrinked board array is set.
1269     /// @param visited the array to check.
1270     /// @param position the position on the board we want to check.
1271     /// @param flag the flag we want to check (either 1 or 2).
1272     /// @return true if that flag is set, false otherwise.
1273     function isFlagSet(uint8[SHRINKED_BOARD_SIZE] visited, uint8 position, uint8 flag) private pure returns (bool) {
1274         return (visited[position / 4] & (flag << ((position % 4) * 2)) > 0);
1275     }
1276 
1277     // Get group visited flags
1278     uint8 constant FLAG_POSITION_WAS_IN_STACK = 1;
1279     uint8 constant FLAG_DID_VISIT_POSITION = 2;
1280 
1281     /// @dev Gets a group starting from the position & color sent. In order for a stone to be part of the group,
1282     ///  it must match the original stone's color, and be connected to it - either directly, or through adjacent cells.
1283     ///  A group is captured if there aren't any empty cells around it.
1284     ///  The function supports both returning colored groups - white/black, and empty groups (for that case, isGroupCaptured isn't relevant).
1285     /// @param board the board to check and update
1286     /// @param position the position of the starting stone
1287     /// @param positionColor the color of the starting stone (this param is sent to spare another reading op)
1288     /// @return an array that contains the positions of the group, 
1289     ///  a boolean that specifies whether the group is captured or not.
1290     ///  In order to save gas, if a group isn't captured, the array might not contain the enitre group.
1291     function getGroup(GoBoard storage board, uint8 position, uint8 positionColor) private view returns (uint8[BOARD_SIZE], bool isGroupCaptured) {
1292 
1293         // The return array, and its size
1294         uint8[BOARD_SIZE] memory groupPositions;
1295         uint8 groupSize = 0;
1296         
1297         // Flagging visited locations
1298         uint8[SHRINKED_BOARD_SIZE] memory visited;
1299 
1300         // Stack of waiting positions, the first position to check is the sent position
1301         uint8[BOARD_SIZE] memory stack;
1302         stack[0] = position;
1303         uint8 stackSize = 1;
1304 
1305         // That position was added to the stack
1306         setFlag(visited, position, FLAG_POSITION_WAS_IN_STACK);
1307 
1308         // Run as long as there are positions in the stack
1309         while (stackSize > 0) {
1310 
1311             // Take the last position and clear it
1312             position = stack[--stackSize];
1313             stack[stackSize] = 0;
1314 
1315             // Only if we didn't visit that stone before
1316             if (!isFlagSet(visited, position, FLAG_DID_VISIT_POSITION)) {
1317                 
1318                 // Set the flag so we won't visit it again
1319                 setFlag(visited, position, FLAG_DID_VISIT_POSITION);
1320 
1321                 // Add that position to the return value
1322                 groupPositions[groupSize++] = position;
1323 
1324                 // Get that position adjacent cells
1325                 uint8[MAX_ADJACENT_CELLS] memory adjacentArray = getAdjacentCells(position);
1326 
1327                 // Run over the adjacent cells
1328                 for (uint8 currAdjacentIndex = 0; currAdjacentIndex < MAX_ADJACENT_CELLS && adjacentArray[currAdjacentIndex] < MAX_UINT8; currAdjacentIndex++) {
1329                     
1330                     // Get the current adjacent cell color
1331                     uint8 currColor = board.positionToColor[adjacentArray[currAdjacentIndex]];
1332                     
1333                     // If it's the same color as the original position color
1334                     if (currColor == positionColor) {
1335 
1336                         // Add that position to the stack
1337                         if (!isFlagSet(visited, adjacentArray[currAdjacentIndex], FLAG_POSITION_WAS_IN_STACK)) {
1338                             stack[stackSize++] = adjacentArray[currAdjacentIndex];
1339                             setFlag(visited, adjacentArray[currAdjacentIndex], FLAG_POSITION_WAS_IN_STACK);
1340                         }
1341                     // If that position is empty, the group isn't captured, no need to continue running
1342                     } else if (currColor == 0) {
1343                         
1344                         return (groupPositions, false);
1345                     }
1346                 }
1347             }
1348         }
1349 
1350         // Flag the end of the group array only if needed
1351         if (groupSize < BOARD_SIZE) {
1352             groupPositions[groupSize] = MAX_UINT8;
1353         }
1354         
1355         // The group is captured, return it
1356         return (groupPositions, true);
1357     }
1358     
1359     /// The max number of adjacent cells is 4
1360     uint8 constant MAX_ADJACENT_CELLS = 4;
1361 
1362     /// @dev returns the adjacent positions for a given position.
1363     /// @param position to get its adjacents.
1364     /// @return the adjacent positions array, filled with MAX_INT8 in case there aren't 4 adjacent positions.
1365     function getAdjacentCells(uint8 position) private pure returns (uint8[MAX_ADJACENT_CELLS]) {
1366 
1367         // Init the return array and current index
1368         uint8[MAX_ADJACENT_CELLS] memory returnCells = [MAX_UINT8, MAX_UINT8, MAX_UINT8, MAX_UINT8];
1369         uint8 adjacentCellsIndex = 0;
1370 
1371         // Set the up position, if relevant
1372         if (position / BOARD_ROW_SIZE > 0) {
1373             returnCells[adjacentCellsIndex++] = position - BOARD_ROW_SIZE;
1374         }
1375 
1376         // Set the down position, if relevant
1377         if (position / BOARD_ROW_SIZE < BOARD_ROW_SIZE - 1) {
1378             returnCells[adjacentCellsIndex++] = position + BOARD_ROW_SIZE;
1379         }
1380 
1381         // Set the left position, if relevant
1382         if (position % BOARD_ROW_SIZE > 0) {
1383             returnCells[adjacentCellsIndex++] = position - 1;
1384         }
1385 
1386         // Set the right position, if relevant
1387         if (position % BOARD_ROW_SIZE < BOARD_ROW_SIZE - 1) {
1388             returnCells[adjacentCellsIndex++] = position + 1;
1389         }
1390 
1391         return returnCells;
1392     }
1393 
1394     /// @notice Calculates the board's score, using area scoring.
1395     /// @param boardId the board to calculate the score for.
1396     /// @return blackScore & whiteScore, the players' scores.
1397     function calculateBoardScore(uint boardId) public view returns (uint8 blackScore, uint8 whiteScore) {
1398 
1399         GoBoard storage board = allBoards[boardId];
1400         uint8[BOARD_SIZE] memory boardEmptyGroups;
1401         uint8 maxEmptyGroupId;
1402         (boardEmptyGroups, maxEmptyGroupId) = getBoardEmptyGroups(board);
1403         uint8[BOARD_SIZE] memory groupsSize;
1404         uint8[BOARD_SIZE] memory groupsState;
1405         
1406         blackScore = 0;
1407         whiteScore = 0;
1408 
1409         // Count stones and find empty territories
1410         for (uint8 position = 0; position < BOARD_SIZE; position++) {
1411 
1412             if (PlayerColor(board.positionToColor[position]) == PlayerColor.Black) {
1413 
1414                 blackScore++;
1415             } else if (PlayerColor(board.positionToColor[position]) == PlayerColor.White) {
1416 
1417                 whiteScore++;
1418             } else {
1419 
1420                 uint8 groupId = boardEmptyGroups[position];
1421                 groupsSize[groupId]++;
1422 
1423                 // Checking is needed only if we didn't find the group is adjacent to the two colors already
1424                 if ((groupsState[groupId] & uint8(PlayerColor.Black) == 0) || (groupsState[groupId] & uint8(PlayerColor.White) == 0)) {
1425 
1426                     uint8[MAX_ADJACENT_CELLS] memory adjacentArray = getAdjacentCells(position);
1427 
1428                     // Check adjacent cells to mark the group's bounderies
1429                     for (uint8 currAdjacentIndex = 0; currAdjacentIndex < MAX_ADJACENT_CELLS && adjacentArray[currAdjacentIndex] < MAX_UINT8; currAdjacentIndex++) {
1430 
1431                         // Check if the group has a black boundry
1432                         if ((PlayerColor(board.positionToColor[adjacentArray[currAdjacentIndex]]) == PlayerColor.Black) && 
1433                             (groupsState[groupId] & uint8(PlayerColor.Black) == 0)) {
1434 
1435                             groupsState[groupId] |= uint8(PlayerColor.Black);
1436 
1437                         // Check if the group has a white boundry
1438                         } else if ((PlayerColor(board.positionToColor[adjacentArray[currAdjacentIndex]]) == PlayerColor.White) && 
1439                                    (groupsState[groupId] & uint8(PlayerColor.White) == 0)) {
1440 
1441                             groupsState[groupId] |= uint8(PlayerColor.White);
1442                         }
1443                     }
1444                 }
1445             }
1446         }
1447 
1448         // Add territories size to the relevant player
1449         for (uint8 currGroupId = 1; currGroupId < maxEmptyGroupId; currGroupId++) {
1450             
1451             // Check if it's a black territory
1452             if ((groupsState[currGroupId] & uint8(PlayerColor.Black) > 0) &&
1453                 (groupsState[currGroupId] & uint8(PlayerColor.White) == 0)) {
1454 
1455                 blackScore += groupsSize[currGroupId];
1456 
1457             // Check if it's a white territory
1458             } else if ((groupsState[currGroupId] & uint8(PlayerColor.White) > 0) &&
1459                        (groupsState[currGroupId] & uint8(PlayerColor.Black) == 0)) {
1460 
1461                 whiteScore += groupsSize[currGroupId];
1462             }
1463         }
1464 
1465         return (blackScore, whiteScore);
1466     }
1467 
1468     /// @dev IDs empty groups on the board.
1469     /// @param board the board to map.
1470     /// @return an array that contains the mapped empty group ids, and the max empty group id
1471     function getBoardEmptyGroups(GoBoard storage board) private view returns (uint8[BOARD_SIZE], uint8) {
1472 
1473         uint8[BOARD_SIZE] memory boardEmptyGroups;
1474         uint8 nextGroupId = 1;
1475 
1476         for (uint8 position = 0; position < BOARD_SIZE; position++) {
1477 
1478             PlayerColor currPositionColor = PlayerColor(board.positionToColor[position]);
1479 
1480             if ((currPositionColor == PlayerColor.None) && (boardEmptyGroups[position] == 0)) {
1481 
1482                 uint8[BOARD_SIZE] memory emptyGroup;
1483                 bool isGroupCaptured;
1484                 (emptyGroup, isGroupCaptured) = getGroup(board, position, 0);
1485 
1486                 for (uint8 currGroupIndex = 0; currGroupIndex < BOARD_SIZE && emptyGroup[currGroupIndex] < MAX_UINT8; currGroupIndex++) {
1487 
1488                     boardEmptyGroups[emptyGroup[currGroupIndex]] = nextGroupId;
1489                 }
1490 
1491                 nextGroupId++;
1492             }
1493         }
1494 
1495         return (boardEmptyGroups, nextGroupId);
1496     }
1497 }