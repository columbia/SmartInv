1 pragma solidity ^0.4.21;
2 
3 contract TwoXJackpot {
4   using SafeMath for uint256;
5   address public contractOwner;  // Address of the contract creator
6 
7   // BuyIn Object, holding information of each Buy In
8   // Also used to store information about winners in each game
9   struct BuyIn {
10     uint256 value;
11     address owner;
12   }
13 
14   // Game Object, holding information of each Game played
15   struct Game {
16     BuyIn[] buyIns;            // FIFO queue
17     address[] winners;         // Jackpot Winners addresses
18     uint256[] winnerPayouts;   // Jackpot Winner Payouts
19     uint256 gameTotalInvested; // Total Invested in game
20     uint256 gameTotalPaidOut;  // Total Paid Out in game
21     uint256 gameTotalBacklog;  // Total Amount waiting to payout
22     uint256 index;             // The current BuyIn queue index
23 
24     mapping (address => uint256) totalInvested; // Total invested for a given address
25     mapping (address => uint256) totalValue;    // Total value for a given address
26     mapping (address => uint256) totalPaidOut;  // Total paid out for a given address
27   }
28 
29   mapping (uint256 => Game) public games;  // Map game index to the game
30   uint256 public gameIndex;    // The current Game Index
31 
32   // Timestamp of the last action.
33 
34   // Jackpot
35   uint256 public jackpotBalance;        // Total balance of Jackpot (before re-seed deduction)
36   address public jackpotLastQualified;  // Last Purchaser, in running for Jackpot claim
37   address public jackpotLastWinner;     // Last Winner Address
38   uint256 public jackpotLastPayout;     // Last Payout Amount (after re-seed deduction)
39   uint256 public jackpotCount;          // Number of jackpots for sliding payout.
40 
41 
42   // Timestamp of Game Start
43   uint256 public gameStartTime;     // Game Start Time
44   uint256 public roundStartTime;    // Round Start Time, used to pause the game
45   uint256 public lastAction;        // Last Action Timestamp
46   uint256 public timeBetweenGames = 24 hours;       // Time between games (4 Jackpots hit = 1 game)
47   uint256 public timeBeforeJackpot = 30 minutes;    // Time between last purchase and jackpot payout (increases)
48   uint256 public timeBeforeJackpotReset = timeBeforeJackpot; // To reset the jackpot timer
49   uint256 public timeIncreasePerTx = 1 minutes;     // How much time to increment the jackpot for each buy
50   uint256 public timeBetweenRounds = 5 minutes;  // Time between rounds (each Round has 5 minute timeout)
51 
52 
53   // Buy In configuration logic
54   uint256 public buyFee = 90;       // This ends up being a 10% fee towards Jackpot
55   uint256 public minBuy = 50;       // Jackpot / 50 = 2% Min buy
56   uint256 public maxBuy = 2;        // Jackpot / 2 = 50% Max buy
57   uint256 public minMinBuyETH = 0.02 ether; // Min buy in should be more then 0.02 ETH
58   uint256 public minMaxBuyETH = 0.5 ether; // Max buy in should be more then 0.5 ETH
59   uint256[] public gameReseeds = [90, 80, 60, 20]; // How much money reseeds to the next round
60 
61 
62   modifier onlyContractOwner() {
63     require(msg.sender == contractOwner);
64     _;
65   }
66 
67   modifier isStarted() {
68       require(now >= gameStartTime); // Check game started
69       require(now >= roundStartTime); // Check round started
70       _;
71   }
72 
73 
74   /**
75    * Events
76    */
77   event Purchase(uint256 amount, address depositer);
78   event Seed(uint256 amount, address seeder);
79 
80   function TwoXJackpot() public {
81     contractOwner = msg.sender;
82     gameStartTime = now + timeBetweenGames;
83     lastAction = gameStartTime;
84   }
85 
86   //                 //
87   // ADMIN FUNCTIONS //
88   //                 //
89 
90   // Change the start time for fair launch
91   function changeStartTime(uint256 _time) public onlyContractOwner {
92     require(now < _time); // only allow changing it to something in the future
93     gameStartTime = _time;
94     lastAction = gameStartTime; // Don't forget to update last action too :)
95   }
96 
97   // Change the start time for fair launch
98   function updateTimeBetweenGames(uint256 _time) public onlyContractOwner {
99     timeBetweenGames = _time; // Time after Jackpot claim we allow new buys.
100   }
101 
102   //                //
103   // User Functions //
104   //                //
105 
106   // Anyone can seed the jackpot, since its non-refundable. It will pay 10% forward to next game.
107   // Beware, there is no way to get your seed back unless you win the jackpot.
108   function seed() public payable {
109     jackpotBalance += msg.value; // Increase the value of the jackpot by this much.
110     //emit Seed event
111     emit Seed(msg.value, msg.sender);
112   }
113 
114   function purchase() public payable isStarted  {
115     // Check if the game is still running
116     if (now > lastAction + timeBeforeJackpot &&
117       jackpotLastQualified != 0x0) {
118       claim();
119       // Next game/round will start, return back money to user
120       if (msg.value > 0) {
121         msg.sender.transfer(msg.value);
122       }
123       return;
124     }
125 
126     // Check if JackPot is less then 1 ETH, then
127     // use predefined minimum and maximum buy in values
128     if (jackpotBalance <= 1 ether) {
129       require(msg.value >= minMinBuyETH); // >= 0.02 ETH
130       require(msg.value <= minMaxBuyETH); // <= 0.5 ETH
131     } else {
132       uint256 purchaseMin = SafeMath.mul(msg.value, minBuy);
133       uint256 purchaseMax = SafeMath.mul(msg.value, maxBuy);
134       require(purchaseMin >= jackpotBalance);
135       require(purchaseMax <= jackpotBalance);
136     }
137 
138     uint256 valueAfterTax = SafeMath.div(SafeMath.mul(msg.value, buyFee), 100);     // Take a 10% fee for Jackpot, example on 1ETH Buy:  0.9 = (1.0 * 90) / 100
139     uint256 potFee = SafeMath.sub(msg.value, valueAfterTax);                        // Calculate the absolute number to put into pot.
140 
141 
142     jackpotBalance += potFee;           // Add it to the jackpot
143     jackpotLastQualified = msg.sender;  // You are now the rightly heir to the Jackpot...for now...
144     lastAction = now;                   //  Reset jackpot timer
145     timeBeforeJackpot += timeIncreasePerTx;                // Increase Jackpot Timer by 1 minute.
146     uint256 valueMultiplied = SafeMath.mul(msg.value, 2);  // Double it
147 
148     // Update Global Investing Information
149     games[gameIndex].gameTotalInvested += msg.value;
150     games[gameIndex].gameTotalBacklog += valueMultiplied;
151 
152     // Update Game Investing Information
153     games[gameIndex].totalInvested[msg.sender] += msg.value;
154     games[gameIndex].totalValue[msg.sender] += valueMultiplied;
155 
156     // Push new Buy In information in our game list of buy ins
157     games[gameIndex].buyIns.push(BuyIn({
158       value: valueMultiplied,
159       owner: msg.sender
160     }));
161     //Emit a deposit event.
162     emit Purchase(msg.value, msg.sender);
163 
164     while (games[gameIndex].index < games[gameIndex].buyIns.length
165             && valueAfterTax > 0) {
166 
167       BuyIn storage buyIn = games[gameIndex].buyIns[games[gameIndex].index];
168 
169       if (valueAfterTax < buyIn.value) {
170         buyIn.owner.transfer(valueAfterTax);
171 
172         // Update game information
173         games[gameIndex].gameTotalBacklog -= valueAfterTax;
174         games[gameIndex].gameTotalPaidOut += valueAfterTax;
175 
176         // game paid out and value update
177         games[gameIndex].totalPaidOut[buyIn.owner] += valueAfterTax;
178         games[gameIndex].totalValue[buyIn.owner] -= valueAfterTax;
179         buyIn.value -= valueAfterTax;
180         valueAfterTax = 0;
181       } else {
182         buyIn.owner.transfer(buyIn.value);
183 
184         // Update game information
185         games[gameIndex].gameTotalBacklog -= buyIn.value;
186         games[gameIndex].gameTotalPaidOut += buyIn.value;
187 
188         // game paid out and value update
189         games[gameIndex].totalPaidOut[buyIn.owner] += buyIn.value;
190         games[gameIndex].totalValue[buyIn.owner] -= buyIn.value;
191         valueAfterTax -= buyIn.value;
192         buyIn.value = 0;
193         games[gameIndex].index++;
194       }
195     }
196   }
197 
198 
199   // Claim the Jackpot
200   function claim() public payable isStarted {
201     require(now > lastAction + timeBeforeJackpot);
202     require(jackpotLastQualified != 0x0); // make sure last jackpotLastQualified is not 0x0
203 
204     // Each game has 4 Jackpot payouts, increasing in payout percentage.
205     // Funds owed to you do not reset between Jackpots, but will reset after 1 game (4 Jackpots)
206     uint256 reseed = SafeMath.div(SafeMath.mul(jackpotBalance, gameReseeds[jackpotCount]), 100);
207     uint256 payout = jackpotBalance - reseed;
208 
209 
210     jackpotLastQualified.transfer(payout); // payout entire jackpot minus seed.
211     jackpotBalance = reseed;
212     jackpotLastWinner = jackpotLastQualified;
213     jackpotLastPayout = payout;
214 
215     // Let's store now new winner in list of game winners
216     games[gameIndex].winners.push(jackpotLastQualified);
217     games[gameIndex].winnerPayouts.push(payout);
218 
219     // RESET all the settings
220     timeBeforeJackpot = timeBeforeJackpotReset; // reset to 30 min on each round timer
221     jackpotLastQualified = 0x0; // set last qualified to 0x0
222 
223     if(jackpotCount == gameReseeds.length - 1){
224       // Reset all outstanding owed money after 4 claimed jackpots to officially restart the game.
225       gameStartTime = now + timeBetweenGames;    // Restart the game in a specified period (24h)
226       lastAction = gameStartTime; // Reset last action to the start of the game
227       gameIndex += 1; // Next Game!
228       jackpotCount = 0;  // Reset Jackpots back to 0 after game end.
229 
230     } else {
231       lastAction = now + timeBetweenRounds;
232       roundStartTime = lastAction;
233       jackpotCount += 1;
234     }
235   }
236 
237   // Fallback, sending any ether will call purchase()
238   function () public payable {
239     purchase();
240   }
241 
242   // PUBLIC METHODS TO RETRIEVE DATA IN UI
243   // Return Current Jackpot Info
244   // [ JackPotBalance, jackpotLastQualified, jackpotLastWinner, jackpotLastPayout,
245   //  jackpotCount, gameIndex, gameStartTime, timeTillRoundEnd, roundStartTime]
246   function getJackpotInfo() public view returns (uint256, address, address, uint256, uint256, uint256, uint256, uint256, uint256) {
247     return (
248         jackpotBalance,
249         jackpotLastQualified,
250         jackpotLastWinner,
251         jackpotLastPayout,
252         jackpotCount,
253         gameIndex,
254         gameStartTime,
255         lastAction + timeBeforeJackpot,
256         roundStartTime
257       );
258   }
259 
260   // Return player game info based on game index and player address
261   // [ totalInvested, totalValue, totalPaidOut]
262   function getPlayerGameInfo(uint256 _gameIndex, address _player) public view returns (uint256, uint256, uint256) {
263     return (
264         games[_gameIndex].totalInvested[_player],
265         games[_gameIndex].totalValue[_player],
266         games[_gameIndex].totalPaidOut[_player]
267       );
268   }
269 
270   // Get user game info connected to current game
271   function getMyGameInfo() public view returns (uint256, uint256, uint256) {
272     return getPlayerGameInfo(gameIndex, msg.sender);
273   }
274 
275   // Return all the game constants, setting the game
276   function getGameConstants() public view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256[]) {
277     return (
278         timeBetweenGames,
279         timeBeforeJackpot,
280         minMinBuyETH,
281         minMaxBuyETH,
282         minBuy,
283         maxBuy,
284         gameReseeds
285       );
286   }
287 
288   // Return game information based on game index
289   function getGameInfo(uint256 _gameIndex) public view returns (uint256, uint256, uint256, address[], uint256[]) {
290     return (
291         games[_gameIndex].gameTotalInvested,
292         games[_gameIndex].gameTotalPaidOut,
293         games[_gameIndex].gameTotalBacklog,
294         games[_gameIndex].winners,
295         games[_gameIndex].winnerPayouts
296       );
297   }
298 
299   // Return current running game info
300   function getCurrentGameInfo() public view returns (uint256, uint256, uint256, address[], uint256[]) {
301     return getGameInfo(gameIndex);
302   }
303 
304   // Return time when next game will start
305   function getGameStartTime() public view returns (uint256) {
306     return gameStartTime;
307   }
308 
309   // Return end time for the jackpot round
310   function getJackpotRoundEndTime() public view returns (uint256) {
311     return lastAction + timeBeforeJackpot;
312   }
313 }
314 
315 
316 /**
317  * @title SafeMath
318  * @dev Math operations with safety checks that throw on error
319  */
320 library SafeMath {
321 
322   /**
323   * @dev Multiplies two numbers, throws on overflow.
324   */
325   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
326     if (a == 0) {
327       return 0;
328     }
329     uint256 c = a * b;
330     assert(c / a == b);
331     return c;
332   }
333 
334   /**
335   * @dev Integer division of two numbers, truncating the quotient.
336   */
337   function div(uint256 a, uint256 b) internal pure returns (uint256) {
338     // assert(b > 0); // Solidity automatically throws when dividing by 0
339     uint256 c = a / b;
340     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
341     return c;
342   }
343 
344   /**
345   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
346   */
347   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
348     assert(b <= a);
349     return a - b;
350   }
351 
352   /**
353   * @dev Adds two numbers, throws on overflow.
354   */
355   function add(uint256 a, uint256 b) internal pure returns (uint256) {
356     uint256 c = a + b;
357     assert(c >= a);
358     return c;
359   }
360 }