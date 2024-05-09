1 pragma solidity 0.5.16;
2 
3 // @title SelfDestructingSender
4 // @notice Sends funds to any address using selfdestruct to bypass fallbacks.
5 // @dev Is invoked by the _forceTransfer() function in the Game contract.
6 contract SelfDestructingSender {
7     constructor(address payable payee) public payable {
8         selfdestruct(payee);
9     }
10 }
11 
12 
13 // @title Game
14 // @notice A money game in which only one player can lose. Everyone else leaves with more money than they started with.
15 // Dozens may play. Only one will lose.
16 // @dev The UI will initially launch at playescalation.com. If that site ever goes down, look for an `Announce` event at
17 // https://etherscan.io/address/0xbea62796855548154464f6c8e7bc92672c9f87b8#events for where to find the latest UI.
18 // IMPORTANT: This is not an investment scheme. This is a game. There is up to one loser per game and that could be you.
19 // IMPORTANT: Do not play with more money than you are comfortable losing.
20 // IMPORTANT: It is *impossible* to get back any money you lose, because that money is used to pay out all the other players.
21 // IMPORTANT: The creators of this game have no control over this game or the payouts. This code is autonomous.
22 // IMPORTANT: By interacting with this contract you agree to not hold the creators responsible for any loses you may incur. Use it at your own risk.
23 // IMPORTANT: Have fun and play responsibly!
24 // @dev This game works as follows:
25 // - To ready the game, at least 0.0435 ETH is donated to the contract. Anyone can do this. It will probably be done by the game creators.
26 // - Then anyone can start the game by calling the `firstPlay` function, which requires staking exactly 0.05 ETH with this contract.
27 // - This starts a countdown clock that counts down from 30 minutes.
28 // - During the 30 minutes, anyone can play by calling the `play` function, which requires staking funds with this contract.
29 // - Each play of the game causes the countdown timer to be reset back to 30 minutes.
30 // - Each successive play of the game requires a stake that is exactly 15% larger than the previous stake.
31 // - The game ends when the countdown clock gets to 0.
32 // - If two or more people play after you then you are a "small winner" and you are instantly given your stake back plus an additional 10% profit.
33 // -    This "small winner" payout happens automatically, as soon as the second player after you plays.
34 // -    You do not need to wait until the game ends to get paid. You are paid out instantly, with no need to send a withdrawal transaction.
35 // - If nobody plays after you then you are a "big winner" and, when the clock gets to 0, you are given your stake back plus an additional 20% profit.
36 // -    This "big winner" payout happens automatically when the game is reset.
37 // -    Anyone can reset the game by calling the `reset` function. It costs only gas.
38 // - If *exactly one* other person has played after you when the countdown clock gets to 0 then you are the game's only loser. You lose your stake.
39 // -    That is, if you are the one sorry bastard who ends up in second place when the countdown clock gets to 0, you lose.
40 // -    The only way to lose money in this game is to be the second to last person who played.
41 // - TL;DR: So long as you are not in second place when the countdown clock gets to 0, you will leave with more money that you started with.
42 //
43 // NOTES:
44 // - It is okay for a person to play more than once during a game. Each deposit is treated as a distinct play. The identity of the depositor is not important.
45 //      For example, if you want to, you can put the profit won from an earlier play towards a later play. Or even play several times in a row.
46 // - If the countdown clock is getting close to 0 and you are in second place, one possible way to avoid losing your stake
47 //      is to play again (but only if you are comfortable putting more money at risk). This would knock your old play out of second place
48 //      so you would get it back immediately, along with 10% profit, and your new deposit would have a chance at being the "big winner".
49 // - This contract itself can accumulate funds over time. These funds are used to seed future rounds of the game.
50 //      This seeding of the next round happens automatically when the `reset` function is called.
51 // - If you ever find that nobody is paying attention to this contract and it has money in it, you can profit from that by being
52 //      the first player. If nobody else is paying attention then you will also be the last player because nobody will play after you.
53 //      This means you'll get your deposit back plus 20% profit. You can repeat this over and over until this contract is drained of all its funds.
54 // - To any copycats thinking of offering similar games and just tweaking the constants: please be very careful.
55 //      The maths behind the choice of constants is extremely sensitive, and it is easy to introduce critical insolvency vulnerabilities if you
56 //      don't know what you are doing. This contract was created and rigorously tested by experienced contract developers. If you want to make
57 //      changes to it please write full integration tests to be sure your choice of constants will not cause security issues.
58 contract Game {
59     using SafeMath for uint256;
60 
61     // ======
62     // EVENTS
63     // ======
64 
65     event Action(
66         uint256 indexed gameNumber,
67         uint256 indexed depositNumber,
68         address indexed depositorAddress,
69         uint256 block,
70         uint256 time,
71         address payoutProof, // address of the SelfDestructingSender contract that paid out the `(depositNumber - 2)th` deposit
72         bool gameOver
73     );
74 
75     // ======================================================================
76     // CONSTANTS
77     // SECURITY: DO NOT CHANGE THESE CONSTANTS! THEY ARE NOT ARBITRARY!
78     // CHANGING THESE CONSTANTS MAY RESULT IN AN INSOLVENCY VULNERABILITY!
79     // ======================================================================
80 
81     uint256 constant internal DEPOSIT_INCREMENT_PERCENT = 15;
82     uint256 constant internal BIG_REWARD_PERCENT = 20;
83     uint256 constant internal SMALL_REWARD_PERCENT = 10;
84     uint256 constant internal MAX_TIME = 30 minutes;
85     uint256 constant internal NEVER = uint256(-1);
86     uint256 constant internal INITIAL_INCENTIVE = 0.0435 ether;
87     address payable constant internal _designers = 0xBea62796855548154464F6C8E7BC92672C9F87b8; // address has no power
88 
89     // =========
90     // VARIABLES
91     // =========
92 
93     uint256 public endTime; // UNIX timestamp of when the current game ends
94     uint256 public escrow; // the amount of ETH (in wei) currently held in the game's escrow
95     uint256 public currentGameNumber;
96     uint256 public currentDepositNumber;
97     address payable[2] public topDepositors; // stores the addresses of the 2 most recent depositors
98     // NOTE: topDepositors[0] is the most recent depositor
99     mapping (uint256 => uint256) public requiredDeposit; // maps `n` to the required deposit size (in wei) required for the `n`th play
100     // NOTE: in practice, the parameter `n` should never exceed 200, since by then the required deposit would be more ETH than exists.
101     uint256[] internal _startBlocks; // for front-end use only: game number i starts at _startBlocks[i]
102     bool internal _gameStarted;
103 
104     // ============
105     // CUSTOM TYPES
106     // ============
107 
108     // the states of the state machine
109     enum GameState {NEEDS_DONATION, READY_FOR_FIRST_PLAY, IN_PROGRESS, GAME_OVER}
110 
111     // =========
112     // MODIFIERS
113     // =========
114 
115     // prevents transactions meant for one game from being used in a subsequent game
116     modifier currentGame(uint256 gameNumber) {
117         require(gameNumber == currentGameNumber, "Wrong game number.");
118         _;
119     }
120 
121     // ensures that the deposit provided is exactly the amount of the current required deposit
122     modifier exactDeposit() {
123         require(
124             msg.value == requiredDeposit[currentDepositNumber],
125             "Incorrect deposit amount. Perhaps another player got their txn mined before you. Try again."
126         );
127         _;
128     }
129 
130     // ========================
131     // FALLBACK AND CONSTRUCTOR
132     // ========================
133 
134     // SECURITY: Fallback must NOT be payable
135     // This prevents players from losing money if they attempt to play by sending money directly to
136     // this contract instead of calling one of the play functions
137     // Any funds sent to this contract via self-destruct will be applied to the INITIAL_INCENTIVE of subsequent games
138     function() external { }
139 
140     constructor() public {
141         endTime = NEVER;
142         currentGameNumber = 1;
143         currentDepositNumber = 1;
144         _startBlocks.push(0);
145 
146         // Here we are precomputing and storing values that we will use later
147         // These values will be needed during every play of the game and they are expensive to compute
148         // So we compute them up front and store them to save the players gas later
149         // These are the required sizes (in wei) of the `depositNumber`th deposit
150         // This computes and stores `INITIAL_INCENTIVE * (100 + DEPOSIT_INCREMENT_PERCENT / 100) ^ n`,
151         // rounded to 4 (ETH) decimal places, for n=0 to 200.  It must be done using a loop because solidity 0.5 does not
152         // support raising fractions to integer powers.
153         // SECURITY: The argument `depositNumber` will never be larger than 200 (since then the
154         // required deposit would be far more ETH than exists).
155         // SECURITY: SafeMath not used here for gas efficiency reasons.
156         // Since `depositNumber` will never be > 200 and since `INITIAL_INCENTIVE` and
157         // `DEPOSIT_INCREMENT_PERCENT` are small and constant, there is no risk of overflow here.
158         uint256 value = INITIAL_INCENTIVE;
159         uint256 r = DEPOSIT_INCREMENT_PERCENT;
160         requiredDeposit[0] = INITIAL_INCENTIVE;
161         for (uint256 i = 1; i <= 200; i++) { // `depositNumber` will never exceed 200
162             value += value * r / 100;
163             requiredDeposit[i] = value / 1e14 * 1e14; // round output to 4 (ETH) decimal places
164         }
165         // SECURITY: No entries in the requiredDeposit mapping should ever change again
166         // SECURITY: After the constructor runs, requiredDeposit should be read-only
167     }
168 
169     // ============================
170     // PRIVATE / INTERNAL FUNCTIONS
171     // ============================
172 
173     // @notice Transfers ETH to an address without any possibility of failing
174     // @param payee The address to which the ETH will be sent
175     // @param amount The amount of ETH (in wei) to be sent
176     // @return address The address of the SelfDestructingSender contract that delivered the funds
177     // @dev This allows us to use a push-payments pattern with no security risk
178     // For most applications the gas cost is too high to do this, but for this game
179     // the winnings on every deposit (other than the one losing deposit) far exceed the
180     // gas costs of this transfer method when players use reasonable gas prices -- for example, under 40 gwei for `firstPlay`
181     // @dev NOTE the following security concerns:
182     // SECURITY: MUST BE PRIVATE OR INTERNAL!
183     // SECURITY: THE PLAYERS MUST BE ABLE TO VERIFY SelfDestructingSender CONTRACT CODE!
184     function _forceTransfer(address payable payee, uint256 amount) internal returns (address) {
185         return address((new SelfDestructingSender).value(amount)(payee));
186     }
187 
188     // @notice Computes the current game state
189     // @return The current game state
190     function _gameState() private view returns (GameState) {
191         if (!_gameStarted) {
192             // then the game state is either NEEDS_DONATION or READY_FOR_FIRST_PLAY
193             if (escrow < INITIAL_INCENTIVE) {
194                 return GameState.NEEDS_DONATION;
195             } else {
196                 return GameState.READY_FOR_FIRST_PLAY;
197             }
198         } else {
199             // then the game state is either IN_PROGRESS or GAME_OVER
200             if (now >= endTime) {
201                 return GameState.GAME_OVER;
202             } else {
203                 return GameState.IN_PROGRESS;
204             }
205         }
206     }
207 
208     // =============================================
209     // EXTERNAL FUNCTIONS THAT MODIFY CONTRACT STATE
210     // =============================================
211 
212     // @notice This is a function used to donate money that will be used to incentivize the first player to play
213     // Anyone can donate money, though in practice only the `_designers` likely will since nobody directly benefits from it
214     // Donations can be accepted only when the game is in the NEEDS_DONATION state
215     // Donations are added to escrow until escrow == INITIAL_INCENTIVE
216     // Any remaining donations are kept in address(this).balance and are used to seed future games
217     // SECURITY: Can be called only when the game state is NEEDS_DONATION
218     function donate() external payable {
219         require(_gameState() == GameState.NEEDS_DONATION, "No donations needed.");
220         // NOTE: if the game is in the NEEDS_DONATION state then escrow < INITIAL_INCENTIVE
221         uint256 maxAmountToPutInEscrow = INITIAL_INCENTIVE.sub(escrow);
222         if (msg.value > maxAmountToPutInEscrow) {
223             escrow = escrow.add(maxAmountToPutInEscrow);
224         } else {
225             escrow = escrow.add(msg.value);
226         }
227     }
228 
229     // @notice Used to make the first play of a game
230     // @param gameNumber The current gameNumber
231     // SECURITY: Can be called only when the game state is READY_FOR_FIRST_PLAY
232     // SECURITY: Function call can be front-run. That is acceptable and may be part of game dynamics during competitive play.
233     function firstPlay(uint256 gameNumber) external payable currentGame(gameNumber) exactDeposit {
234         require(_gameState() == GameState.READY_FOR_FIRST_PLAY, "Game not ready for first play.");
235 
236         emit Action(currentGameNumber, currentDepositNumber, msg.sender, block.number, now, address(0), false);
237 
238         topDepositors[0] = msg.sender;
239         endTime = now.add(MAX_TIME);
240         escrow = escrow.add(msg.value);
241         currentDepositNumber++;
242         _gameStarted = true;
243         _startBlocks.push(block.number);
244     }
245 
246     // @notice Used to make any subsequent play of the game
247     // @param gameNumber The current gameNumber
248     // SECURITY: Can be called only when the game state is IN_PROGRESS
249     // SECURITY: Function call can be front-run. That is acceptable and may be part of game dynamics during competitive play.
250     function play(uint256 gameNumber) external payable currentGame(gameNumber) exactDeposit {
251         require(_gameState() == GameState.IN_PROGRESS, "Game is not in progress.");
252 
253         // We pay out the person who will no longer be the second-largest depositor
254         address payable addressToPay = topDepositors[1];
255         // They will receive their original deposit back plus SMALL_REWARD_PERCENT percent more
256         // NOTE: The first time the `play` function is called `currentDepositNumber` is at least 2, so
257         // the subtraction here will never cause a revert
258         uint256 amountToPay = requiredDeposit[currentDepositNumber.sub(2)].mul(SMALL_REWARD_PERCENT.add(100)).div(100);
259 
260         address payoutProof = address(0);
261         if (addressToPay != address(0)) { // we never send money to the zero address
262             payoutProof = _forceTransfer(addressToPay, amountToPay);
263         }
264 
265         // tell the front end what happened
266         emit Action(currentGameNumber, currentDepositNumber, msg.sender, block.number, now, payoutProof, false);
267 
268         // store the new top depositors
269         topDepositors[1] = topDepositors[0];
270         topDepositors[0] = msg.sender;
271         // reset the clock
272         endTime = now.add(MAX_TIME);
273         // track the changes to escrow
274         // NOTE: even if addressToPay is address(0) we still reduce escrow by amountToPay
275         // Any money that would have gone to address(0) is is later put towards the INITIAL_INCENTIVE
276         // for the next game (see the end of the `reset` function)
277         escrow = escrow.sub(amountToPay).add(msg.value);
278         currentDepositNumber++;
279     }
280 
281     // @notice Used to pay out the final depositor of a game and reset variables for the next game
282     // SECURITY: Can be called only when the game state is GAME_OVER
283     function reset() external {
284         require(_gameState() == GameState.GAME_OVER, "Game is not over.");
285         // We pay out the largest depositor
286         address payable addressToPay = topDepositors[0];
287 
288         // They will receive their original deposit back plus BIG_REWARD_PERCENT percent more
289         uint256 amountToPay = requiredDeposit[currentDepositNumber.sub(1)].mul(BIG_REWARD_PERCENT.add(100)).div(100);
290         address payoutProof = _forceTransfer(addressToPay, amountToPay);
291 
292         // track the payout in escrow
293         escrow = escrow.sub(amountToPay);
294 
295         // tell the front end what happened
296         emit Action(currentGameNumber, currentDepositNumber, address(0), block.number, now, payoutProof, true);
297 
298         // if there is anything left in escrow, give it to the _designers as a reward for maintaining the game
299         if (escrow > 0) {
300             _forceTransfer(_designers, escrow);
301         }
302 
303         // reset the game vars for the next game
304         endTime = NEVER;
305         escrow = 0;
306         currentGameNumber++;
307         currentDepositNumber = 1;
308         _gameStarted = false;
309         topDepositors[0] = address(0);
310         topDepositors[1] = address(0);
311 
312         // apply anything left over in address(this).balance to the next game's escrow
313         // being sure not to exceed INITIAL_INCENTIVE
314         if (address(this).balance > INITIAL_INCENTIVE) {
315             escrow = INITIAL_INCENTIVE;
316         } else {
317             escrow = address(this).balance;
318         }
319     }
320 
321     // =======================
322     // EXTERNAL VIEW FUNCTIONS
323     // =======================
324 
325     // @notice Returns the required deposit size (in wei) required for the next deposit of the game
326     function currentRequiredDeposit() external view returns (uint256) {
327         return requiredDeposit[currentDepositNumber];
328     }
329 
330     // @notice Returns the current state of the game
331     function gameState() external view returns (GameState) {
332         return _gameState();
333     }
334 
335     // @notice returns the block at which game number `index` began, or 0 if referring to
336     // a game that has not yet started
337     function startBlocks(uint256 index) external view returns (uint256) {
338         if (index >= _startBlocks.length) {
339             return 0; // the front-end will handle this properly
340         } else {
341             return _startBlocks[index];
342         }
343     }
344 }
345 
346 
347 
348 
349 /**
350  * @title SafeMath
351  * @dev Unsigned math operations with safety checks that revert on error
352  */
353 library SafeMath {
354     /**
355      * @dev Multiplies two unsigned integers, reverts on overflow.
356      */
357     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
358         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
359         // benefit is lost if 'b' is also tested.
360         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
361         if (a == 0) {
362             return 0;
363         }
364 
365         uint256 c = a * b;
366         require(c / a == b);
367 
368         return c;
369     }
370 
371     /**
372      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
373      */
374     function div(uint256 a, uint256 b) internal pure returns (uint256) {
375         // Solidity only automatically asserts when dividing by 0
376         require(b > 0);
377         uint256 c = a / b;
378         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
379 
380         return c;
381     }
382 
383     /**
384      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
385      */
386     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
387         require(b <= a);
388         uint256 c = a - b;
389 
390         return c;
391     }
392 
393     /**
394      * @dev Adds two unsigned integers, reverts on overflow.
395      */
396     function add(uint256 a, uint256 b) internal pure returns (uint256) {
397         uint256 c = a + b;
398         require(c >= a);
399 
400         return c;
401     }
402 
403     /**
404      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
405      * reverts when dividing by zero.
406      */
407     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
408         require(b != 0);
409         return a % b;
410     }
411 }