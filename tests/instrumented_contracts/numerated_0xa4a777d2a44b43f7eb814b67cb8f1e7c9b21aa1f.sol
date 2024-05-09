1 pragma solidity ^0.4.24;
2 
3 pragma solidity ^0.4.24;
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10 
11     /**
12     * @dev Multiplies two numbers, reverts on overflow.
13     */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16         // benefit is lost if 'b' is also tested.
17         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18         if (a == 0) {
19             return 0;
20         }
21 
22         uint256 c = a * b;
23         require(c / a == b);
24 
25         return c;
26     }
27 
28     /**
29     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
30     */
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         require(b > 0); // Solidity only automatically asserts when dividing by 0
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50     * @dev Adds two numbers, reverts on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61     * reverts when dividing by zero.
62     */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 pragma solidity ^0.4.24;
69 
70 /**
71  * @title Ownable
72  * @dev The Ownable contract has an owner address, and provides basic authorization control
73  * functions, this simplifies the implementation of "user permissions".
74  */
75 contract Ownable {
76     address private _owner;
77 
78     event OwnershipTransferred(
79         address indexed previousOwner,
80         address indexed newOwner
81     );
82 
83     /**
84      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
85      * account.
86      */
87     constructor() internal {
88         _owner = msg.sender;
89         emit OwnershipTransferred(address(0), _owner);
90     }
91 
92     /**
93      * @return the address of the owner.
94      */
95     function owner() public view returns(address) {
96         return _owner;
97     }
98 
99     /**
100      * @dev Throws if called by any account other than the owner.
101      */
102     modifier onlyOwner() {
103         require(isOwner());
104         _;
105     }
106 
107     /**
108      * @return true if `msg.sender` is the owner of the contract.
109      */
110     function isOwner() public view returns(bool) {
111         return msg.sender == _owner;
112     }
113 
114     /**
115      * @dev Allows the current owner to relinquish control of the contract.
116      * @notice Renouncing to ownership will leave the contract without an owner.
117      * It will not be possible to call the functions with the `onlyOwner`
118      * modifier anymore.
119      */
120     function renounceOwnership() public onlyOwner {
121         emit OwnershipTransferred(_owner, address(0));
122         _owner = address(0);
123     }
124 
125     /**
126      * @dev Allows the current owner to transfer control of the contract to a newOwner.
127      * @param newOwner The address to transfer ownership to.
128      */
129     function transferOwnership(address newOwner) public onlyOwner {
130         _transferOwnership(newOwner);
131     }
132 
133     /**
134      * @dev Transfers control of the contract to a newOwner.
135      * @param newOwner The address to transfer ownership to.
136      */
137     function _transferOwnership(address newOwner) internal {
138         require(newOwner != address(0));
139         emit OwnershipTransferred(_owner, newOwner);
140         _owner = newOwner;
141     }
142 }
143 pragma solidity ^0.4.24;
144 
145 interface EtherHiLoRandomNumberRequester {
146 
147     function incomingRandomNumber(address player, uint8 randomNumber) external;
148 
149     function incomingRandomNumberError(address player) external;
150 
151 }
152 
153 interface EtherHiLoRandomNumberGenerator {
154 
155     function generateRandomNumber(address player, uint8 max) payable external returns (bool);
156 
157 }
158 
159 /// @title EtherHiLo
160 /// @dev the contract than handles the EtherHiLo app
161 contract EtherHiLo is Ownable, EtherHiLoRandomNumberRequester {
162 
163     uint8 constant NUM_DICE_SIDES = 13;
164 
165     uint public minBet;
166     uint public maxBetThresholdPct;
167     bool public gameRunning;
168     uint public balanceInPlay;
169 
170     EtherHiLoRandomNumberGenerator private random;
171     mapping(address => Game) private gamesInProgress;
172 
173     event GameFinished(address indexed player, uint indexed playerGameNumber, uint bet, uint8 firstRoll, uint8 finalRoll, uint winnings, uint payout);
174     event GameError(address indexed player, uint indexed playerGameNumber);
175 
176     enum BetDirection {
177         None,
178         Low,
179         High
180     }
181 
182     enum GameState {
183         None,
184         WaitingForFirstCard,
185         WaitingForDirection,
186         WaitingForFinalCard,
187         Finished
188     }
189 
190     // the game object
191     struct Game {
192         address player;
193         GameState state;
194         uint id;
195         BetDirection direction;
196         uint bet;
197         uint8 firstRoll;
198         uint8 finalRoll;
199         uint winnings;
200     }
201 
202     // the constructor
203     constructor() public {
204         setMinBet(100 finney);
205         setGameRunning(true);
206         setMaxBetThresholdPct(75);
207     }
208 
209     /// Default function
210     function() external payable {
211 
212     }
213 
214 
215     /// =======================
216     /// EXTERNAL GAME RELATED FUNCTIONS
217 
218     // begins a game
219     function beginGame() public payable {
220         address player = msg.sender;
221         uint bet = msg.value;
222 
223         require(player != address(0));
224         require(gamesInProgress[player].state == GameState.None || gamesInProgress[player].state == GameState.Finished);
225         require(gameRunning);
226         require(bet >= minBet && bet <= getMaxBet());
227 
228         Game memory game = Game({
229                 id:         uint(keccak256(block.number, player, bet)),
230                 player:     player,
231                 state:      GameState.WaitingForFirstCard,
232                 bet:        bet,
233                 firstRoll:  0,
234                 finalRoll:  0,
235                 winnings:   0,
236                 direction:  BetDirection.None
237             });
238 
239         if (!random.generateRandomNumber(player, NUM_DICE_SIDES)) {
240             player.transfer(msg.value);
241             return;
242         }
243 
244         balanceInPlay = balanceInPlay + game.bet;
245         gamesInProgress[player] = game;
246     }
247 
248     // finishes a game that is in progress
249     function finishGame(BetDirection direction) public {
250         address player = msg.sender;
251 
252         require(player != address(0));
253         require(gamesInProgress[player].state != GameState.None && gamesInProgress[player].state != GameState.Finished);
254 
255         if (!random.generateRandomNumber(player, NUM_DICE_SIDES)) {
256             return;
257         }
258 
259         Game storage game = gamesInProgress[player];
260         game.direction = direction;
261         game.state = GameState.WaitingForFinalCard;
262         gamesInProgress[player] = game;
263     }
264 
265     // returns current game state
266     function getGameState(address player) public view returns
267             (GameState, uint, BetDirection, uint, uint8, uint8, uint) {
268         return (
269             gamesInProgress[player].state,
270             gamesInProgress[player].id,
271             gamesInProgress[player].direction,
272             gamesInProgress[player].bet,
273             gamesInProgress[player].firstRoll,
274             gamesInProgress[player].finalRoll,
275             gamesInProgress[player].winnings
276         );
277     }
278 
279     // Returns the minimum bet
280     function getMinBet() public view returns (uint) {
281         return minBet;
282     }
283 
284     // Returns the maximum bet
285     function getMaxBet() public view returns (uint) {
286         return SafeMath.div(SafeMath.div(SafeMath.mul(this.balance - balanceInPlay, maxBetThresholdPct), 100), 12);
287     }
288 
289     // calculates winnings for the given bet and percent
290     function calculateWinnings(uint bet, uint percent) public pure returns (uint) {
291         return SafeMath.div(SafeMath.mul(bet, percent), 100);
292     }
293 
294     // Returns the win percent when going low on the given number
295     function getLowWinPercent(uint number) public pure returns (uint) {
296         require(number >= 2 && number <= NUM_DICE_SIDES);
297         if (number == 2) {
298             return 1200;
299         } else if (number == 3) {
300             return 500;
301         } else if (number == 4) {
302             return 300;
303         } else if (number == 5) {
304             return 300;
305         } else if (number == 6) {
306             return 200;
307         } else if (number == 7) {
308             return 180;
309         } else if (number == 8) {
310             return 150;
311         } else if (number == 9) {
312             return 140;
313         } else if (number == 10) {
314             return 130;
315         } else if (number == 11) {
316             return 120;
317         } else if (number == 12) {
318             return 110;
319         } else if (number == 13) {
320             return 100;
321         }
322     }
323 
324     // Returns the win percent when going high on the given number
325     function getHighWinPercent(uint number) public pure returns (uint) {
326         require(number >= 1 && number < NUM_DICE_SIDES);
327         if (number == 1) {
328             return 100;
329         } else if (number == 2) {
330             return 110;
331         } else if (number == 3) {
332             return 120;
333         } else if (number == 4) {
334             return 130;
335         } else if (number == 5) {
336             return 140;
337         } else if (number == 6) {
338             return 150;
339         } else if (number == 7) {
340             return 180;
341         } else if (number == 8) {
342             return 200;
343         } else if (number == 9) {
344             return 300;
345         } else if (number == 10) {
346             return 300;
347         } else if (number == 11) {
348             return 500;
349         } else if (number == 12) {
350             return 1200;
351         }
352     }
353 
354 
355     /// =======================
356     /// RANDOM NUMBER CALLBACKS
357 
358     function incomingRandomNumberError(address player) public {
359         require(msg.sender == address(random));
360 
361         Game storage game = gamesInProgress[player];
362         if (game.bet > 0) {
363             game.player.transfer(game.bet);
364         }
365 
366         delete gamesInProgress[player];
367         GameError(player, game.id);
368     }
369 
370     function incomingRandomNumber(address player, uint8 randomNumber) public {
371         require(msg.sender == address(random));
372 
373         Game storage game = gamesInProgress[player];
374 
375         if (game.firstRoll == 0) {
376 
377             game.firstRoll = randomNumber;
378             game.state = GameState.WaitingForDirection;
379             gamesInProgress[player] = game;
380 
381             return;
382         }
383 
384         uint8 finalRoll = randomNumber;
385         uint winnings = 0;
386 
387         if (game.direction == BetDirection.High && finalRoll > game.firstRoll) {
388             winnings = calculateWinnings(game.bet, getHighWinPercent(game.firstRoll));
389         } else if (game.direction == BetDirection.Low && finalRoll < game.firstRoll) {
390             winnings = calculateWinnings(game.bet, getLowWinPercent(game.firstRoll));
391         }
392 
393         // this should never happen according to the odds,
394         // and the fact that we don't allow people to bet
395         // so large that they can take the whole pot in one
396         // fell swoop - however, a number of people could
397         // theoretically all win simultaneously and cause
398         // this scenario.  This will try to at a minimum
399         // send them back what they bet and then since it
400         // is recorded on the blockchain we can verify that
401         // the winnings sent don't match what they should be
402         // and we can manually send the rest to the player.
403         uint transferAmount = winnings;
404         if (transferAmount > this.balance) {
405             if (game.bet < this.balance) {
406                 transferAmount = game.bet;
407             } else {
408                 transferAmount = SafeMath.div(SafeMath.mul(this.balance, 90), 100);
409             }
410         }
411 
412         balanceInPlay = balanceInPlay - game.bet;
413 
414         if (transferAmount > 0) {
415             game.player.transfer(transferAmount);
416         }
417 
418         game.finalRoll = finalRoll;
419         game.winnings = winnings;
420         game.state = GameState.Finished;
421         gamesInProgress[player] = game;
422 
423         GameFinished(player, game.id, game.bet, game.firstRoll, finalRoll, winnings, transferAmount);
424     }
425 
426 
427     /// OWNER / MANAGEMENT RELATED FUNCTIONS
428 
429     // fail safe for balance transfer
430     function transferBalance(address to, uint amount) public onlyOwner {
431         to.transfer(amount);
432     }
433 
434     // cleans up a player abandoned game, but only if it's
435     // greater than 24 hours old.
436     function cleanupAbandonedGame(address player) public onlyOwner {
437         require(player != address(0));
438 
439         Game storage game = gamesInProgress[player];
440         require(game.player != address(0));
441 
442         game.player.transfer(game.bet);
443         delete gamesInProgress[game.player];
444     }
445 
446     function setRandomAddress(address _address) public onlyOwner {
447         random = EtherHiLoRandomNumberGenerator(_address);
448     }
449 
450     // set the minimum bet
451     function setMinBet(uint bet) public onlyOwner {
452         minBet = bet;
453     }
454 
455     // set whether or not the game is running
456     function setGameRunning(bool v) public onlyOwner {
457         gameRunning = v;
458     }
459 
460     // set the max bet threshold percent
461     function setMaxBetThresholdPct(uint v) public onlyOwner {
462         maxBetThresholdPct = v;
463     }
464 
465     // Transfers the current balance to the recepient and terminates the contract.
466     function destroyAndSend(address _recipient) public onlyOwner {
467         selfdestruct(_recipient);
468     }
469 
470 }