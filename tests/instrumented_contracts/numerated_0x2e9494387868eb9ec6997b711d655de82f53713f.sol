1 /** 
2 *   ________  __                  __          __      __                        _______             __        __        __    __     
3 *  |        \|  \                |  \        |  \    |  \                      |       \           |  \      |  \      |  \  |  \    
4 *  | $$$$$$$$ \$$ _______    ____| $$       _| $$_   | $$____    ______        | $$$$$$$\  ______  | $$____  | $$____   \$$ _| $$_   
5 *  | $$__    |  \|       \  /      $$      |   $$ \  | $$    \  /      \       | $$__| $$ |      \ | $$    \ | $$    \ |  \|   $$ \  
6 *  | $$  \   | $$| $$$$$$$\|  $$$$$$$       \$$$$$$  | $$$$$$$\|  $$$$$$\      | $$    $$  \$$$$$$\| $$$$$$$\| $$$$$$$\| $$ \$$$$$$  
7 *  | $$$$$   | $$| $$  | $$| $$  | $$        | $$ __ | $$  | $$| $$    $$      | $$$$$$$\ /      $$| $$  | $$| $$  | $$| $$  | $$ __ 
8 *  | $$      | $$| $$  | $$| $$__| $$        | $$|  \| $$  | $$| $$$$$$$$      | $$  | $$|  $$$$$$$| $$__/ $$| $$__/ $$| $$  | $$|  \
9 *  | $$      | $$| $$  | $$ \$$    $$         \$$  $$| $$  | $$ \$$     \      | $$  | $$ \$$    $$| $$    $$| $$    $$| $$   \$$  $$
10 *   \$$       \$$ \$$   \$$  \$$$$$$$          \$$$$  \$$   \$$  \$$$$$$$       \$$   \$$  \$$$$$$$ \$$$$$$$  \$$$$$$$  \$$    \$$$$
11 *
12 *
13 *             ╔═╗┌─┐┌─┐┬┌─┐┬┌─┐┬   ┌─────────────────────────┐ ╦ ╦┌─┐┌┐ ╔═╗┬┌┬┐┌─┐ 
14 *             ║ ║├┤ ├┤ ││  │├─┤│   │https://findtherabbit.me │ ║║║├┤ ├┴┐╚═╗│ │ ├┤  
15 *             ╚═╝└  └  ┴└─┘┴┴ ┴┴─┘ └─┬─────────────────────┬─┘ ╚╩╝└─┘└─┘╚═╝┴ ┴ └─┘      
16 */
17 
18 
19 // File: contracts/lib/SafeMath.sol
20 
21 pragma solidity 0.5.4;
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that revert on error
26  */
27 library SafeMath {
28 
29   /**
30   * @dev Multiplies two numbers, reverts on overflow.
31   */
32   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
34     // benefit is lost if 'b' is also tested.
35     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
36     if (a == 0) {
37       return 0;
38     }
39 
40     uint256 c = a * b;
41     require(c / a == b);
42 
43     return c;
44   }
45 
46   /**
47   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
48   */
49   function div(uint256 a, uint256 b) internal pure returns (uint256) {
50     require(b > 0); // Solidity only automatically asserts when dividing by 0
51     uint256 c = a / b;
52     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
53 
54     return c;
55   }
56 
57   /**
58   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
59   */
60   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61     require(b <= a);
62     uint256 c = a - b;
63 
64     return c;
65   }
66 
67   /**
68   * @dev Adds two numbers, reverts on overflow.
69   */
70   function add(uint256 a, uint256 b) internal pure returns (uint256) {
71     uint256 c = a + b;
72     require(c >= a);
73 
74     return c;
75   }
76 
77   /**
78   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
79   * reverts when dividing by zero.
80   */
81   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
82     require(b != 0);
83     return a % b;
84   }
85 }
86 
87 // File: contracts/Messages.sol
88 
89 pragma solidity 0.5.4;
90 
91 /**
92  * EIP712 Ethereum typed structured data hashing and signing
93 */
94 contract Messages {
95     struct AcceptGame {
96         uint256 bet;
97         bool isHost;
98         address opponentAddress;
99         bytes32 hashOfMySecret;
100         bytes32 hashOfOpponentSecret;
101     }
102     
103     struct SecretData {
104         bytes32 salt;
105         uint8 secret;
106     }
107 
108     /**
109      * Domain separator encoding per EIP 712.
110      * keccak256(
111      *     "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract,bytes32 salt)"
112      * )
113      */
114     bytes32 public constant EIP712_DOMAIN_TYPEHASH = 0xd87cd6ef79d4e2b95e15ce8abf732db51ec771f1ca2edccf22a46c729ac56472;
115 
116     /**
117      * AcceptGame struct type encoding per EIP 712
118      * keccak256(
119      *     "AcceptGame(uint256 bet,bool isHost,address opponentAddress,bytes32 hashOfMySecret,bytes32 hashOfOpponentSecret)"
120      * )
121      */
122     bytes32 private constant ACCEPTGAME_TYPEHASH = 0x5ceee84403c984fbd9fb4ebf11b09c4f28f87290116c8b7f24a3e2a89d26588f;
123 
124     /**
125      * Domain separator per EIP 712
126      */
127     bytes32 public DOMAIN_SEPARATOR;
128 
129     /**
130      * @notice Calculates acceptGameHash according to EIP 712.
131      * @param _acceptGame AcceptGame instance to hash.
132      * @return bytes32 EIP 712 hash of _acceptGame.
133      */
134     function _hash(AcceptGame memory _acceptGame) internal pure returns (bytes32) {
135         return keccak256(abi.encode(
136             ACCEPTGAME_TYPEHASH,
137             _acceptGame.bet,
138             _acceptGame.isHost,
139             _acceptGame.opponentAddress,
140             _acceptGame.hashOfMySecret,
141             _acceptGame.hashOfOpponentSecret
142         ));
143     }
144 
145     /**
146      * @notice Calculates secretHash according to EIP 712.
147      * @param _salt Salt of the gamer.
148      * @param _secret Secret of the gamer.
149      */
150     function _hashOfSecret(bytes32 _salt, uint8 _secret) internal pure returns (bytes32) {
151         return keccak256(abi.encodePacked(_salt, _secret));
152     }
153 
154     /**
155      * @return the recovered address from the signature
156      */
157     function _recoverAddress(
158         bytes32 messageHash,
159         bytes memory signature
160     )
161         internal
162         view
163         returns (address) 
164     {
165         bytes32 r;
166         bytes32 s;
167         bytes1 v;
168         // solium-disable-next-line security/no-inline-assembly
169         assembly {
170             r := mload(add(signature, 0x20))
171             s := mload(add(signature, 0x40))
172             v := mload(add(signature, 0x60))
173         }
174         bytes32 digest = keccak256(abi.encodePacked(
175             "\x19\x01",
176             DOMAIN_SEPARATOR,
177             messageHash
178         ));
179         return ecrecover(digest, uint8(v), r, s);
180     }
181 
182     /**
183      * @return the address of the gamer signing the AcceptGameMessage
184      */
185     function _getSignerAddress(
186         uint256 _value,
187         bool _isHost,
188         address _opponentAddress,
189         bytes32 _hashOfMySecret,
190         bytes32 _hashOfOpponentSecret,
191         bytes memory signature
192     ) 
193         internal
194         view
195         returns (address playerAddress) 
196     {   
197         AcceptGame memory message = AcceptGame({
198             bet: _value,
199             isHost: _isHost,
200             opponentAddress: _opponentAddress,
201             hashOfMySecret: _hashOfMySecret,
202             hashOfOpponentSecret: _hashOfOpponentSecret
203         });
204         bytes32 messageHash = _hash(message);
205         playerAddress = _recoverAddress(messageHash, signature);
206     }
207 }
208 
209 // File: contracts/Ownable.sol
210 
211 pragma solidity 0.5.4;
212 
213 /**
214  * @title Ownable
215  * @dev The Ownable contract has an owner address, and provides basic authorization control
216  * functions, this simplifies the implementation of "user permissions".
217  */
218 contract Ownable {
219     address public _owner;
220 
221     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
222 
223     /**
224      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
225      * account.
226      */
227     constructor () internal {
228         _owner = msg.sender;
229         emit OwnershipTransferred(address(0), _owner);
230     }
231 
232     /**
233      * @return the address of the owner.
234      */
235     function owner() public view returns (address) {
236         return _owner;
237     }
238 
239     /**
240      * @dev Throws if called by any account other than the owner.
241      */
242     modifier onlyOwner() {
243         require(isOwner(), "not owner");
244         _;
245     }
246 
247     /**
248      * @return true if `msg.sender` is the owner of the contract.
249      */
250     function isOwner() public view returns (bool) {
251         return msg.sender == _owner;
252     }
253 
254     /**
255      * @dev Allows the current owner to transfer control of the contract to a newOwner.
256      * @param newOwner The address to transfer ownership to.
257      */
258     function transferOwnership(address newOwner) public onlyOwner {
259         _transferOwnership(newOwner);
260     }
261 
262     /**
263      * @dev Transfers control of the contract to a newOwner.
264      * @param newOwner The address to transfer ownership to.
265      */
266     function _transferOwnership(address newOwner) internal {
267         require(newOwner != address(0));
268         emit OwnershipTransferred(_owner, newOwner);
269         _owner = newOwner;
270     }
271 }
272 
273 // File: contracts/Claimable.sol
274 
275 pragma solidity 0.5.4;
276 
277 
278 /**
279  * @title Claimable
280  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
281  * This allows the new owner to accept the transfer.
282  */
283 contract Claimable is Ownable {
284   address public pendingOwner;
285 
286   /**
287    * @dev Modifier throws if called by any account other than the pendingOwner.
288    */
289   modifier onlyPendingOwner() {
290     require(msg.sender == pendingOwner, "not pending owner");
291     _;
292   }
293 
294   /**
295    * @dev Allows the current owner to set the pendingOwner address.
296    * @param newOwner The address to transfer ownership to.
297    */
298   function transferOwnership(address newOwner) public onlyOwner {
299     pendingOwner = newOwner;
300   }
301 
302   /**
303    * @dev Allows the pendingOwner address to finalize the transfer.
304    */
305   function claimOwnership() public onlyPendingOwner {
306     emit OwnershipTransferred(_owner, pendingOwner);
307     _owner = pendingOwner;
308     pendingOwner = address(0);
309   }
310 }
311 
312 // File: contracts/lib/ERC20Basic.sol
313 
314 pragma solidity 0.5.4;
315 
316 /**
317  * @title ERC20Basic
318  * @dev Simpler version of ERC20 interface
319  * @dev see https://github.com/ethereum/EIPs/issues/179
320  */
321 contract ERC20Basic {
322     function balanceOf(address who) public view returns (uint256);
323     function transfer(address to, uint256 value) public returns (bool);
324 }
325 
326 // File: contracts/FindTheRabbit.sol
327 
328 pragma solidity 0.5.4;
329 
330 
331 
332 
333 
334 /**
335  * @title FindTheRabbit
336  * @dev Base game contract
337  */
338 contract FindTheRabbit is Messages, Claimable {
339     using SafeMath for uint256;
340     enum GameState { 
341         Invalid, // Default value for a non-created game
342         HostBetted, // A player, who initiated an offchain game and made a bet
343         JoinBetted, // A player, who joined the game and made a bet
344         Filled, // Both players made bets
345         DisputeOpenedByHost, // Dispute is opened by the initiating player
346         DisputeOpenedByJoin, // Dispute is opened by the joining player
347         DisputeWonOnTimeoutByHost, // Dispute is closed on timeout and the prize was taken by the initiating player 
348         DisputeWonOnTimeoutByJoin, // Dispute is closed on timeout and the prize was taken by the joining player 
349         CanceledByHost, // The joining player has not made a bet and the game is closed by the initiating player
350         CanceledByJoin, // The initiating player has not made a bet and the game is closed by the joining player
351         WonByHost, // The initiating has won the game
352         WonByJoin // The joining player has won the game
353     }
354     //Event is triggered after both players have placed their bets
355     event GameCreated(
356         address indexed host, 
357         address indexed join, 
358         uint256 indexed bet, 
359         bytes32 gameId, 
360         GameState state
361     );
362     //Event is triggered after the first bet has been placed
363     event GameOpened(bytes32 gameId, address indexed player);
364     //Event is triggered after the game has been closed
365     event GameCanceled(bytes32 gameId, address indexed player, address indexed opponent);
366     /**
367      * @dev Event triggered after after opening a dispute
368      * @param gameId 32 byte game identifier
369      * @param disputeOpener is a player who opened a dispute
370      * @param defendant is a player against whom a dispute is opened
371      */
372     event DisputeOpened(bytes32 gameId, address indexed disputeOpener, address indexed defendant);
373     //Event is triggered after a dispute is resolved by the function resolveDispute()
374     event DisputeResolved(bytes32 gameId, address indexed player);
375     //Event is triggered after a dispute is closed after the amount of time specified in disputeTimer
376     event DisputeClosedOnTimeout(bytes32 gameId, address indexed player);
377     //Event is triggered after sending the winning to the winner
378     event WinnerReward(address indexed winner, uint256 amount);
379     //Event is triggered after the jackpot is sent to the winner
380     event JackpotReward(bytes32 gameId, address player, uint256 amount);
381     //Event is triggered after changing the gameId that claims the jackpot
382     event CurrentJackpotGame(bytes32 gameId);
383     //Event is triggered after sending the reward to the referrer
384     event ReferredReward(address referrer, uint256 amount);
385     // Emitted when calimTokens function is invoked.
386     event ClaimedTokens(address token, address owner, uint256 amount);
387     
388     //The address of the contract that will verify the signature per EIP 712.
389     //In this case, the current address of the contract.
390     address public verifyingContract = address(this);
391     //An disambiguating salt for the protocol per EIP 712.
392     //Set through the constructor.
393     bytes32 public salt;
394 
395     //An address of the creators' account receiving the percentage of Commission for the game
396     address payable public teamWallet;
397     
398     //Percentage of commission from the game that is sent to the creators
399     uint256 public commissionPercent;
400     
401     //Percentage of reward to the player who invited new players
402     //0.1% is equal 1
403     //0.5% is equal 5
404     //1% is equal 10
405     //10% is equal 100
406     uint256 public referralPercent;
407 
408     //Maximum allowed value of the referralPercent. (10% = 100)
409     uint256 public maxReferralPercent = 100;
410     
411     //Minimum bet value to create a new game
412     uint256 public minBet = 0.01 ether; 
413     
414     //Percentage of game commission added to the jackpot value
415     uint256 public jackpotPercent;
416     
417     //Jackpot draw time in UNIX time stamp format.
418     uint256 public jackpotDrawTime;
419     
420     //Current jackpot value
421     uint256 public jackpotValue;
422     
423     //The current value of the gameId of the applicant for the jackpot.
424     bytes32 public jackpotGameId;
425     
426     //Number of seconds added to jackpotDrawTime each time a new game is added to the jackpot.
427     uint256 public jackpotGameTimerAddition;
428     
429     //Initial timeout for a new jackpot round.
430     uint256 public jackpotAccumulationTimer;
431     
432     //Timeout in seconds during which the dispute cannot be opened.
433     uint256 public revealTimer;
434     
435     //Maximum allowed value of the minRevealTimer in seconds. 
436     uint256 public maxRevealTimer;
437     
438     //Minimum allowed value of the minRevealTimer in seconds. 
439     uint256 public minRevealTimer;
440     
441     //Timeout in seconds during which the dispute cannot be closed 
442     //and players can call the functions win() and resolveDispute().
443     uint256 public disputeTimer; 
444     
445     //Maximum allowed value of the maxDisputeTimer in seconds. 
446     uint256 public maxDisputeTimer;
447     
448     //Minimum allowed value of the minDisputeTimer in seconds. 
449     uint256 public minDisputeTimer; 
450 
451     //Timeout in seconds after the first bet 
452     //during which the second player's bet is expected 
453     //and the game cannot be closed.
454     uint256 public waitingBetTimer;
455     
456     //Maximum allowed value of the waitingBetTimer in seconds. 
457     uint256 public maxWaitingBetTimer;
458     
459     //Minimum allowed value of the waitingBetTimer in seconds. 
460     uint256 public minWaitingBetTimer;
461     
462     //The time during which the game must be completed to qualify for the jackpot.
463     uint256 public gameDurationForJackpot;
464 
465     uint256 public chainId;
466 
467     //Mapping for storing information about all games
468     mapping(bytes32 => Game) public games;
469     //Mapping for storing information about all disputes
470     mapping(bytes32 => Dispute) public disputes;
471     //Mapping for storing information about all players
472     mapping(address => Statistics) public players;
473 
474     struct Game {
475         uint256 bet; // bet value for the game
476         address payable host; // address of the initiating player
477         address payable join; // address of the joining player
478         uint256 creationTime; // the time of the last bet in the game.
479         GameState state; // current state of the game
480         bytes hostSignature; // the value of the initiating player's signature
481         bytes joinSignature; // the value of the joining player's signature
482         bytes32 gameId; // 32 byte game identifier
483     }
484 
485     struct Dispute {
486         address payable disputeOpener; //  address of the player, who opened the dispute.
487         uint256 creationTime; // dispute opening time of the dispute.
488         bytes32 opponentHash; // hash from an opponent's secret and salt
489         uint256 secret; // secret value of the player, who opened the dispute
490         bytes32 salt; // salt value of the player, who opened the dispute
491         bool isHost; // true if the player initiated the game.
492     }
493 
494     struct Statistics {
495         uint256 totalGames; // totalGames played by the player
496         uint256 totalUnrevealedGames; // total games that have been disputed against a player for unrevealing the secret on time
497         uint256 totalNotFundedGames; // total number of games a player has not send funds on time
498         uint256 totalOpenedDisputes; // total number of disputed games created by a player against someone for unrevealing the secret on time
499         uint256 avgBetAmount; //  average bet value
500     }
501 
502     /**
503      * @dev Throws if the game state is not Filled. 
504      */
505     modifier isFilled(bytes32 _gameId) {
506         require(games[_gameId].state == GameState.Filled, "game state is not Filled");
507         _;
508     }
509 
510     /**
511      * @dev Throws if the game is not Filled or dispute has not been opened.
512      */
513     modifier verifyGameState(bytes32 _gameId) {
514         require(
515             games[_gameId].state == GameState.DisputeOpenedByHost ||
516             games[_gameId].state == GameState.DisputeOpenedByJoin || 
517             games[_gameId].state == GameState.Filled,
518             "game state are not Filled or OpenedDispute"
519         );
520         _;
521     }
522 
523     /**
524      * @dev Throws if at least one player has not made a bet.
525      */
526     modifier isOpen(bytes32 _gameId) {
527         require(
528             games[_gameId].state == GameState.HostBetted ||
529             games[_gameId].state == GameState.JoinBetted,
530             "game state is not Open");
531         _;
532     }
533 
534     /**
535      * @dev Throws if called by any account other than the participant's one in this game.
536      */
537     modifier onlyParticipant(bytes32 _gameId) {
538         require(
539             games[_gameId].host == msg.sender || games[_gameId].join == msg.sender,
540             "you are not a participant of this game"
541         );
542         _;
543     }
544 
545     /**
546      * @dev Setting the parameters of the contract.
547      * Description of the main parameters can be found above.
548      * @param _chainId Id of the current chain.
549      * @param _maxValueOfTimer maximum value for revealTimer, disputeTimer and waitingBetTimer.
550      * Minimum values are set with revealTimer, disputeTimer, and waitingBetTimer values passed to the constructor.
551      */
552     constructor (
553         uint256 _chainId, 
554         address payable _teamWallet,
555         uint256 _commissionPercent,
556         uint256 _jackpotPercent,
557         uint256 _referralPercent,
558         uint256 _jackpotGameTimerAddition,
559         uint256 _jackpotAccumulationTimer,
560         uint256 _revealTimer,
561         uint256 _disputeTimer,
562         uint256 _waitingBetTimer,
563         uint256 _gameDurationForJackpot,
564         bytes32 _salt,
565         uint256 _maxValueOfTimer
566     ) public {
567         teamWallet = _teamWallet;
568         jackpotDrawTime = getTime().add(_jackpotAccumulationTimer);
569         jackpotAccumulationTimer = _jackpotAccumulationTimer;
570         commissionPercent = _commissionPercent;
571         jackpotPercent = _jackpotPercent;
572         referralPercent = _referralPercent;
573         jackpotGameTimerAddition = _jackpotGameTimerAddition;
574         revealTimer = _revealTimer;
575         minRevealTimer = _revealTimer;
576         maxRevealTimer = _maxValueOfTimer;
577         disputeTimer = _disputeTimer;
578         minDisputeTimer = _disputeTimer;
579         maxDisputeTimer = _maxValueOfTimer;
580         waitingBetTimer = _waitingBetTimer;
581         minWaitingBetTimer = _waitingBetTimer;
582         maxWaitingBetTimer = _maxValueOfTimer;
583         gameDurationForJackpot = _gameDurationForJackpot;
584         salt = _salt;
585         chainId = _chainId;
586         DOMAIN_SEPARATOR = keccak256(abi.encode(
587             EIP712_DOMAIN_TYPEHASH,
588             keccak256("Find The Rabbit"),
589             keccak256("0.1"),
590             _chainId,
591             verifyingContract,
592             salt
593         ));
594     }
595 
596     /**
597      * @dev Change the current waitingBetTimer value. 
598      * Change can be made only within the maximum and minimum values.
599      * @param _waitingBetTimer is a new value of waitingBetTimer
600      */
601     function setWaitingBetTimerValue(uint256 _waitingBetTimer) external onlyOwner {
602         require(_waitingBetTimer >= minWaitingBetTimer, "must be more than minWaitingBetTimer");
603         require(_waitingBetTimer <= maxWaitingBetTimer, "must be less than maxWaitingBetTimer");
604         waitingBetTimer = _waitingBetTimer;
605     }
606 
607     /**
608      * @dev Change the current disputeTimer value. 
609      * Change can be made only within the maximum and minimum values.
610      * @param _disputeTimer is a new value of disputeTimer.
611      */
612     function setDisputeTimerValue(uint256 _disputeTimer) external onlyOwner {
613         require(_disputeTimer >= minDisputeTimer, "must be more than minDisputeTimer");
614         require(_disputeTimer <= maxDisputeTimer, "must be less than maxDisputeTimer");
615         disputeTimer = _disputeTimer;
616     }
617 
618     /**
619      * @dev Change the current revealTimer value. 
620      * Change can be made only within the maximum and minimum values.
621      * @param _revealTimer is a new value of revealTimer
622      */
623     function setRevealTimerValue(uint256 _revealTimer) external onlyOwner {
624         require(_revealTimer >= minRevealTimer, "must be more than minRevealTimer");
625         require(_revealTimer <= maxRevealTimer, "must be less than maxRevealTimer");
626         revealTimer = _revealTimer;
627     }
628 
629     /**
630      * @dev Change the current minBet value. 
631      * @param _newValue is a new value of minBet.
632      */
633     function setMinBetValue(uint256 _newValue) external onlyOwner {
634         require(_newValue != 0, "must be greater than 0");
635         minBet = _newValue;
636     }
637 
638     /**
639      * @dev Change the current jackpotGameTimerAddition.
640      * Change can be made only within the maximum and minimum values.
641      * Jackpot should not hold significant value
642      * @param _jackpotGameTimerAddition is a new value of jackpotGameTimerAddition
643      */
644     function setJackpotGameTimerAddition(uint256 _jackpotGameTimerAddition) external onlyOwner {
645         if (chainId == 1) {
646             // jackpot must be less than 150 DAI. 1 ether = 150 DAI
647             require(jackpotValue <= 1 ether);
648         }
649         if (chainId == 99) {
650             // jackpot must be less than 150 DAI. 1 POA = 0.03 DAI
651             require(jackpotValue <= 4500 ether);
652         }
653         require(_jackpotGameTimerAddition >= 2 minutes, "must be more than 2 minutes");
654         require(_jackpotGameTimerAddition <= 1 hours, "must be less than 1 hour");
655         jackpotGameTimerAddition = _jackpotGameTimerAddition;
656     }
657 
658     /**
659      * @dev Change the current referralPercent value.
660      * Example:
661      * 1  = 0.1%
662      * 5  = 0.5%
663      * 10 = 1%
664      * @param _newValue is a new value of referralPercent.
665      */
666     function setReferralPercentValue(uint256 _newValue) external onlyOwner {
667         require(_newValue <= maxReferralPercent, "must be less than maxReferralPercent");
668         referralPercent = _newValue;
669     }
670 
671     /**
672      * @dev Change the current commissionPercent value.
673      * Example:
674      * 1  = 1%
675      * @param _newValue is a new value of commissionPercent.
676      */
677     function setCommissionPercent(uint256 _newValue) external onlyOwner {
678         require(_newValue <= 20, "must be less than 20");
679         commissionPercent = _newValue;
680     }
681 
682     /**
683      * @dev Change the current teamWallet address. 
684      * @param _newTeamWallet is a new teamWallet address.
685      */
686     function setTeamWalletAddress(address payable _newTeamWallet) external onlyOwner {
687         require(_newTeamWallet != address(0));
688         teamWallet = _newTeamWallet;
689     }
690 
691     /**
692      * @return information about the jackpot.
693      */
694     function getJackpotInfo() 
695         external 
696         view 
697         returns (
698             uint256 _jackpotDrawTime, 
699             uint256 _jackpotValue, 
700             bytes32 _jackpotGameId
701         ) 
702     {
703         _jackpotDrawTime = jackpotDrawTime;
704         _jackpotValue = jackpotValue;
705         _jackpotGameId = jackpotGameId;
706     }
707 
708     /**
709      * @return timers used for games.
710      */
711     function getTimers() 
712         external
713         view 
714         returns (
715             uint256 _revealTimer,
716             uint256 _disputeTimer, 
717             uint256 _waitingBetTimer, 
718             uint256 _jackpotAccumulationTimer 
719         )
720     {
721         _revealTimer = revealTimer;
722         _disputeTimer = disputeTimer;
723         _waitingBetTimer = waitingBetTimer;
724         _jackpotAccumulationTimer = jackpotAccumulationTimer;
725     }
726 
727     /**
728      * @dev Transfer of tokens from the contract  
729      * @param _token the address of the tokens to be transferred.
730      */
731     function claimTokens(address _token) public onlyOwner {
732         ERC20Basic erc20token = ERC20Basic(_token);
733         uint256 balance = erc20token.balanceOf(address(this));
734         erc20token.transfer(owner(), balance);
735         emit ClaimedTokens(_token, owner(), balance);
736     }
737 
738     /**
739      * @dev Allows to create a game and place a bet. 
740      * @param _isHost True if the sending account initiated the game.
741      * @param _hashOfMySecret Hash value of the sending account's secret and salt.
742      * @param _hashOfOpponentSecret Hash value of the opponent account's secret and salt.
743      * @param _hostSignature Signature of the initiating player from the following values:
744      *   bet,
745      *   isHost,                 // true
746      *   opponentAddress,        // join address
747      *   hashOfMySecret,         // hash of host secret
748      *   hashOfOpponentSecret    // hash of join secret
749      * @param _joinSignature Signature of the joining player from the following values:
750      *   bet,
751      *   isHost,                 // false
752      *   opponentAddress,        // host address
753      *   hashOfMySecret,         // hash of join secret
754      *   hashOfOpponentSecret    // hash of host secret
755      */
756     function createGame(
757         bool _isHost,
758         bytes32 _hashOfMySecret,
759         bytes32 _hashOfOpponentSecret,
760         bytes memory _hostSignature,
761         bytes memory _joinSignature
762     )
763         public 
764         payable
765     {       
766         require(msg.value >= minBet, "must be greater than the minimum value");
767         bytes32 gameId = getGameId(_hostSignature, _joinSignature);
768         address opponent = _getSignerAddress(
769             msg.value,
770             !_isHost, 
771             msg.sender,
772             _hashOfOpponentSecret, 
773             _hashOfMySecret,
774             _isHost ? _joinSignature : _hostSignature);
775         require(opponent != msg.sender, "send your opponent's signature");
776         Game storage game = games[gameId];
777         if (game.gameId == 0){
778             _recordGameInfo(msg.value, _isHost, gameId, opponent, _hostSignature, _joinSignature);
779             emit GameOpened(game.gameId, msg.sender);
780         } else {
781             require(game.host == msg.sender || game.join == msg.sender, "you are not paticipant in this game");
782             require(game.state == GameState.HostBetted || game.state == GameState.JoinBetted, "the game is not Opened");
783             if (_isHost) {
784                 require(game.host == msg.sender, "you are not the host in this game");
785                 require(game.join == opponent, "invalid join signature");
786                 require(game.state == GameState.JoinBetted, "you have already made a bet");
787             } else {
788                 require(game.join == msg.sender, "you are not the join in this game.");
789                 require(game.host == opponent, "invalid host signature");
790                 require(game.state == GameState.HostBetted, "you have already made a bet");
791             }
792             game.creationTime = getTime();
793             game.state = GameState.Filled;
794             emit GameCreated(game.host, game.join, game.bet, game.gameId, game.state);
795         }
796     }
797 
798     /**
799      * @dev If the disclosure is true, the winner gets a prize. 
800      * @notice a referrer will be sent a reward to.
801      * only if the referrer has previously played the game and the sending account has not.
802      * @param _gameId 32 byte game identifier.
803      * @param _hostSecret The initiating player's secret.
804      * @param _hostSalt The initiating player's salt.
805      * @param _joinSecret The joining player's secret.
806      * @param _joinSalt The joining player's salt.
807      * @param _referrer The winning player's referrer. The referrer must have played games.
808      */
809     function win(
810         bytes32 _gameId,
811         uint8 _hostSecret,
812         bytes32 _hostSalt,
813         uint8 _joinSecret,
814         bytes32 _joinSalt,
815         address payable _referrer
816     ) 
817         public
818         verifyGameState(_gameId)
819         onlyParticipant(_gameId)
820     {
821         Game storage game = games[_gameId];
822         bytes32 hashOfHostSecret = _hashOfSecret(_hostSalt, _hostSecret);
823         bytes32 hashOfJoinSecret = _hashOfSecret(_joinSalt, _joinSecret);
824 
825         address host = _getSignerAddress(
826             game.bet,
827             true, 
828             game.join,
829             hashOfHostSecret,
830             hashOfJoinSecret, 
831             game.hostSignature
832         );
833         address join = _getSignerAddress(
834             game.bet,
835             false, 
836             game.host,
837             hashOfJoinSecret,
838             hashOfHostSecret,
839             game.joinSignature
840         );
841         require(host == game.host && join == game.join, "invalid reveals");
842         address payable winner;
843         if (_hostSecret == _joinSecret){
844             winner = game.join;
845             game.state = GameState.WonByJoin;
846         } else {
847             winner = game.host;
848             game.state = GameState.WonByHost;
849         }
850         if (isPlayerExist(_referrer) && _referrer != msg.sender) {
851             _processPayments(game.bet, winner, _referrer);
852         }
853         else {
854             _processPayments(game.bet, winner, address(0));
855         }
856         _jackpotPayoutProcessing(_gameId); 
857         _recordStatisticInfo(game.host, game.join, game.bet);
858     }
859 
860     /**
861      * @dev If during the time specified in revealTimer one of the players does not send 
862      * the secret and salt to the opponent, the player can open a dispute.
863      * @param _gameId 32 byte game identifier
864      * @param _secret Secret of the player, who opens the dispute.
865      * @param _salt Salt of the player, who opens the dispute.
866      * @param _isHost True if the sending account initiated the game.
867      * @param _hashOfOpponentSecret The hash value of the opponent account's secret and salt.
868      */
869     function openDispute(
870         bytes32 _gameId,
871         uint8 _secret,
872         bytes32 _salt,
873         bool _isHost,
874         bytes32 _hashOfOpponentSecret
875     )
876         public
877         onlyParticipant(_gameId)
878     {
879         require(timeUntilOpenDispute(_gameId) == 0, "the waiting time for revealing is not over yet");
880         Game storage game = games[_gameId];
881         require(isSecretDataValid(
882             _gameId,
883             _secret,
884             _salt,
885             _isHost,
886             _hashOfOpponentSecret
887         ), "invalid salt or secret");
888         _recordDisputeInfo(_gameId, msg.sender, _hashOfOpponentSecret, _secret, _salt, _isHost);
889         game.state = _isHost ? GameState.DisputeOpenedByHost : GameState.DisputeOpenedByJoin;
890         address defendant = _isHost ? game.join : game.host;
891         players[msg.sender].totalOpenedDisputes = (players[msg.sender].totalOpenedDisputes).add(1);
892         players[defendant].totalUnrevealedGames = (players[defendant].totalUnrevealedGames).add(1);
893         emit DisputeOpened(_gameId, msg.sender, defendant);
894     }
895 
896     /**
897      * @dev Allows the accused player to make a secret disclosure 
898      * and pick up the winnings in case of victory.
899      * @param _gameId 32 byte game identifier.
900      * @param _secret An accused player's secret.
901      * @param _salt An accused player's salt.
902      * @param _isHost True if the sending account initiated the game.
903      * @param _hashOfOpponentSecret The hash value of the opponent account's secret and salt.
904      */
905     function resolveDispute(
906         bytes32 _gameId,
907         uint8 _secret,
908         bytes32 _salt,
909         bool _isHost,
910         bytes32 _hashOfOpponentSecret
911     ) 
912         public
913         returns(address payable winner)
914     {
915         require(isDisputeOpened(_gameId), "there is no dispute");
916         Game storage game = games[_gameId];
917         Dispute memory dispute = disputes[_gameId];
918         require(msg.sender != dispute.disputeOpener, "only for the opponent");
919         require(isSecretDataValid(
920             _gameId,
921             _secret,
922             _salt,
923             _isHost,
924             _hashOfOpponentSecret
925         ), "invalid salt or secret");
926         if (_secret == dispute.secret) {
927             winner = game.join;
928             game.state = GameState.WonByJoin;
929         } else {
930             winner = game.host;
931             game.state = GameState.WonByHost;
932         }
933         _processPayments(game.bet, winner, address(0));
934         _jackpotPayoutProcessing(_gameId);
935         _recordStatisticInfo(game.host, game.join, game.bet);
936         emit DisputeResolved(_gameId, msg.sender);
937     }
938 
939     /**
940      * @dev If during the time specified in disputeTimer the accused player does not manage to resolve a dispute
941      * the player, who has opened the dispute, can close the dispute and get the win.
942      * @param _gameId 32 byte game identifier.
943      * @return address of the winning player.
944      */
945     function closeDisputeOnTimeout(bytes32 _gameId) public returns (address payable winner) {
946         Game storage game = games[_gameId];
947         Dispute memory dispute = disputes[_gameId];
948         require(timeUntilCloseDispute(_gameId) == 0, "the time has not yet come out");
949         winner = dispute.disputeOpener;
950         game.state = (winner == game.host) ? GameState.DisputeWonOnTimeoutByHost : GameState.DisputeWonOnTimeoutByJoin;
951         _processPayments(game.bet, winner, address(0));
952         _jackpotPayoutProcessing(_gameId);
953         _recordStatisticInfo(game.host, game.join, game.bet);
954         emit DisputeClosedOnTimeout(_gameId, msg.sender);
955     }
956 
957     /**
958      * @dev If one of the player made a bet and during the time specified in waitingBetTimer
959      * the opponent does not make a bet too, the player can take his bet back.
960      * @param _gameId 32 byte game identifier.
961      */
962     function cancelGame(
963         bytes32 _gameId
964     ) 
965         public
966         onlyParticipant(_gameId) 
967     {
968         require(timeUntilCancel(_gameId) == 0, "the waiting time for the second player's bet is not over yet");
969         Game storage game = games[_gameId];
970         address payable recipient;
971         recipient = game.state == GameState.HostBetted ? game.host : game.join;
972         address defendant = game.state == GameState.HostBetted ? game.join : game.host;
973         game.state = (recipient == game.host) ? GameState.CanceledByHost : GameState.CanceledByJoin;
974         recipient.transfer(game.bet);
975         players[defendant].totalNotFundedGames = (players[defendant].totalNotFundedGames).add(1);
976         emit GameCanceled(_gameId, msg.sender, defendant);
977     }
978 
979     /**
980      * @dev Jackpot draw if the time has come and there is a winner.
981      */
982     function drawJackpot() public {
983         require(isJackpotAvailable(), "is not avaliable yet");
984         require(jackpotGameId != 0, "no game to claim on the jackpot");
985         require(jackpotValue != 0, "jackpot's empty");
986         _payoutJackpot();
987     }
988 
989     /**
990      * @return true if there is open dispute for given `_gameId`
991      */
992     function isDisputeOpened(bytes32 _gameId) public view returns(bool) {
993         return (
994             games[_gameId].state == GameState.DisputeOpenedByHost ||
995             games[_gameId].state == GameState.DisputeOpenedByJoin
996         );
997     }
998     
999     /**
1000      * @return true if a player played at least one game and did not Cancel it.
1001      */
1002     function isPlayerExist(address _player) public view returns (bool) {
1003         return players[_player].totalGames != 0;
1004     }
1005 
1006     /**
1007      * @return the time after which a player can close the game.
1008      * @param _gameId 32 byte game identifier.
1009      */
1010     function timeUntilCancel(
1011         bytes32 _gameId
1012     )
1013         public
1014         view 
1015         isOpen(_gameId) 
1016         returns (uint256 remainingTime) 
1017     {
1018         uint256 timePassed = getTime().sub(games[_gameId].creationTime);
1019         if (waitingBetTimer > timePassed) {
1020             return waitingBetTimer.sub(timePassed);
1021         } else {
1022             return 0;
1023         }
1024     }
1025 
1026     /**
1027      * @return the time after which a player can open the dispute.
1028      * @param _gameId 32 byte game identifier.
1029      */
1030     function timeUntilOpenDispute(
1031         bytes32 _gameId
1032     )
1033         public
1034         view 
1035         isFilled(_gameId) 
1036         returns (uint256 remainingTime) 
1037     {
1038         uint256 timePassed = getTime().sub(games[_gameId].creationTime);
1039         if (revealTimer > timePassed) {
1040             return revealTimer.sub(timePassed);
1041         } else {
1042             return 0;
1043         }
1044     }
1045 
1046     /**
1047      * @return the time after which a player can close the dispute opened by him.
1048      * @param _gameId 32 byte game identifier.
1049      */
1050     function timeUntilCloseDispute(
1051         bytes32 _gameId
1052     )
1053         public
1054         view 
1055         returns (uint256 remainingTime) 
1056     {
1057         require(isDisputeOpened(_gameId), "there is no open dispute");
1058         uint256 timePassed = getTime().sub(disputes[_gameId].creationTime);
1059         if (disputeTimer > timePassed) {
1060             return disputeTimer.sub(timePassed);
1061         } else {
1062             return 0;
1063         }
1064     }
1065 
1066     /**
1067      * @return the current time in UNIX timestamp format. 
1068      */
1069     function getTime() public view returns(uint) {
1070         return block.timestamp;
1071     }
1072 
1073     /**
1074      * @return the current game state.
1075      * @param _gameId 32 byte game identifier
1076      */
1077     function getGameState(bytes32 _gameId) public view returns(GameState) {
1078         return games[_gameId].state;
1079     }
1080 
1081     /**
1082      * @return true if the sent secret and salt match the genuine ones.
1083      * @param _gameId 32 byte game identifier.
1084      * @param _secret A player's secret.
1085      * @param _salt A player's salt.
1086      * @param _isHost True if the sending account initiated the game.
1087      * @param _hashOfOpponentSecret The hash value of the opponent account's secret and salt.
1088      */
1089     function isSecretDataValid(
1090         bytes32 _gameId,
1091         uint8 _secret,
1092         bytes32 _salt,
1093         bool _isHost,
1094         bytes32 _hashOfOpponentSecret
1095     )
1096         public
1097         view
1098         returns (bool)
1099     {
1100         Game memory game = games[_gameId];
1101         bytes32 hashOfPlayerSecret = _hashOfSecret(_salt, _secret);
1102         address player = _getSignerAddress(
1103             game.bet,
1104             _isHost, 
1105             _isHost ? game.join : game.host,
1106             hashOfPlayerSecret,
1107             _hashOfOpponentSecret, 
1108             _isHost ? game.hostSignature : game.joinSignature
1109         );
1110         require(msg.sender == player, "the received address does not match with msg.sender");
1111         if (_isHost) {
1112             return player == game.host;
1113         } else {
1114             return player == game.join;
1115         }
1116     }
1117 
1118     /**
1119      * @return true if the jackpotDrawTime has come.
1120      */
1121     function isJackpotAvailable() public view returns (bool) {
1122         return getTime() >= jackpotDrawTime;
1123     }
1124 
1125     function isGameAllowedForJackpot(bytes32 _gameId) public view returns (bool) {
1126         return getTime() - games[_gameId].creationTime < gameDurationForJackpot;
1127     }
1128 
1129     /**
1130      * @return an array of statuses for the listed games.
1131      * @param _games array of games identifier.
1132      */
1133     function getGamesStates(bytes32[] memory _games) public view returns(GameState[] memory) {
1134         GameState[] memory _states = new GameState[](_games.length);
1135         for (uint i=0; i<_games.length; i++) {
1136             Game storage game = games[_games[i]];
1137             _states[i] = game.state;
1138         }
1139         return _states;
1140     }
1141 
1142     /**
1143      * @return an array of Statistics for the listed players.
1144      * @param _players array of players' addresses.
1145      */
1146     function getPlayersStatistic(address[] memory _players) public view returns(uint[] memory) {
1147         uint[] memory _statistics = new uint[](_players.length * 5);
1148         for (uint i=0; i<_players.length; i++) {
1149             Statistics storage player = players[_players[i]];
1150             _statistics[5*i + 0] = player.totalGames;
1151             _statistics[5*i + 1] = player.totalUnrevealedGames;
1152             _statistics[5*i + 2] = player.totalNotFundedGames;
1153             _statistics[5*i + 3] = player.totalOpenedDisputes;
1154             _statistics[5*i + 4] = player.avgBetAmount;
1155         }
1156         return _statistics;
1157     }
1158 
1159     /**
1160      * @return GameId generated for current values of the signatures.
1161      * @param _signatureHost Signature of the initiating player.
1162      * @param _signatureJoin Signature of the joining player.
1163      */
1164     function getGameId(bytes memory _signatureHost, bytes memory _signatureJoin) public pure returns (bytes32) {
1165         return keccak256(abi.encodePacked(_signatureHost, _signatureJoin));
1166     }
1167 
1168     /**
1169      * @dev jackpot draw.
1170      */
1171     function _payoutJackpot() internal {
1172         Game storage jackpotGame = games[jackpotGameId];
1173         uint256 reward = jackpotValue.div(2);
1174         jackpotValue = 0;
1175         jackpotGameId = 0;
1176         jackpotDrawTime = (getTime()).add(jackpotAccumulationTimer);
1177         if (jackpotGame.host.send(reward)) {
1178             emit JackpotReward(jackpotGame.gameId, jackpotGame.host, reward.mul(2));
1179         }
1180         if (jackpotGame.join.send(reward)) {
1181             emit JackpotReward(jackpotGame.gameId, jackpotGame.join, reward.mul(2));
1182         }
1183     }
1184     /**
1185      * @dev adds the completed game to the jackpot draw.
1186      * @param _gameId 32 byte game identifier.
1187      */ 
1188     function _addGameToJackpot(bytes32 _gameId) internal {
1189         jackpotDrawTime = jackpotDrawTime.add(jackpotGameTimerAddition);
1190         jackpotGameId = _gameId;
1191         emit CurrentJackpotGame(_gameId);
1192     }
1193 
1194     /**
1195      * @dev update jackpot info.
1196      * @param _gameId 32 byte game identifier.
1197      */ 
1198     function _jackpotPayoutProcessing(bytes32 _gameId) internal {
1199         if (isJackpotAvailable()) {
1200             if (jackpotGameId != 0 && jackpotValue != 0) {
1201                 _payoutJackpot();
1202             }
1203             else {
1204                 jackpotDrawTime = (getTime()).add(jackpotAccumulationTimer);
1205             }
1206         }
1207         if (isGameAllowedForJackpot(_gameId)) {
1208             _addGameToJackpot(_gameId);
1209         }
1210     }
1211     
1212     /**
1213      * @dev take a commission to the creators, reward to referrer, and commission for the jackpot from the winning amount.
1214      * Sending prize to winner.
1215      * @param _bet bet in the current game.
1216      * @param _winner the winner's address.
1217      * @param _referrer the referrer's address.
1218      */ 
1219     function _processPayments(uint256 _bet, address payable _winner, address payable _referrer) internal {
1220         uint256 doubleBet = (_bet).mul(2);
1221         uint256 commission = (doubleBet.mul(commissionPercent)).div(100);        
1222         uint256 jackpotPart = (doubleBet.mul(jackpotPercent)).div(100);
1223         uint256 winnerStake;
1224         if (_referrer != address(0) && referralPercent != 0 ) {
1225             uint256 referrerPart = (doubleBet.mul(referralPercent)).div(1000);
1226             winnerStake = doubleBet.sub(commission).sub(jackpotPart).sub(referrerPart);
1227             if (_referrer.send(referrerPart)) {
1228                 emit ReferredReward(_referrer, referrerPart);
1229             }
1230         }
1231         else {
1232             winnerStake = doubleBet.sub(commission).sub(jackpotPart);
1233         }
1234         jackpotValue = jackpotValue.add(jackpotPart);
1235         _winner.transfer(winnerStake);
1236         teamWallet.transfer(commission);
1237         emit WinnerReward(_winner, winnerStake);
1238     }
1239 
1240     /**
1241      * @dev filling in the "Game" structure.
1242      */ 
1243     function _recordGameInfo(
1244         uint256 _value,
1245         bool _isHost, 
1246         bytes32 _gameId, 
1247         address _opponent,
1248         bytes memory _hostSignature,
1249         bytes memory _joinSignature
1250     ) internal {
1251         Game memory _game = Game({
1252             bet: _value,
1253             host: _isHost ? msg.sender : address(uint160(_opponent)),
1254             join: _isHost ? address(uint160(_opponent)) : msg.sender,
1255             creationTime: getTime(),
1256             state: _isHost ? GameState.HostBetted : GameState.JoinBetted ,
1257             gameId: _gameId,
1258             hostSignature: _hostSignature,
1259             joinSignature: _joinSignature
1260         });
1261         games[_gameId] = _game;  
1262     }
1263 
1264     /**
1265      * @dev filling in the "Dispute" structure.
1266      */ 
1267     function _recordDisputeInfo(
1268         bytes32 _gameId,
1269         address payable _disputeOpener,
1270         bytes32 _hashOfOpponentSecret,
1271         uint8 _secret,
1272         bytes32 _salt,
1273         bool _isHost 
1274     ) internal {
1275         Dispute memory _dispute = Dispute({
1276             disputeOpener: _disputeOpener,
1277             creationTime: getTime(),
1278             opponentHash: _hashOfOpponentSecret,
1279             secret: _secret,
1280             salt: _salt,
1281             isHost: _isHost
1282         });
1283         disputes[_gameId] = _dispute;
1284     }
1285 
1286     /**
1287      * @dev filling in the "Statistics" structure.
1288      */ 
1289     function _recordStatisticInfo(address _host, address _join, uint256 _bet) internal {
1290         Statistics storage statHost = players[_host];
1291         Statistics storage statJoin = players[_join];
1292         statHost.avgBetAmount = _calculateAvgBet(_host, _bet);
1293         statJoin.avgBetAmount = _calculateAvgBet(_join, _bet);
1294         statHost.totalGames = (statHost.totalGames).add(1);
1295         statJoin.totalGames = (statJoin.totalGames).add(1);
1296     }
1297 
1298     /**
1299      * @dev recalculation of an average bet value for a player.
1300      * @param _player the address of the player.
1301      * @param _bet bet from the last played game.
1302      */ 
1303     function _calculateAvgBet(address _player, uint256 _bet) internal view returns (uint256 newAvgBetValue){
1304         Statistics storage statistics = players[_player];
1305         uint256 totalBets = (statistics.avgBetAmount).mul(statistics.totalGames).add(_bet);
1306         newAvgBetValue = totalBets.div(statistics.totalGames.add(1));
1307     }
1308 
1309 }