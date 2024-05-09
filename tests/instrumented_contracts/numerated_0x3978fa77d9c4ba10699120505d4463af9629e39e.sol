1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 
52 /**
53  * @title Ownable
54  * @dev The Ownable contract has an owner address, and provides basic authorization control
55  * functions, this simplifies the implementation of "user permissions".
56  */
57 contract Ownable {
58   address public owner;
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   constructor() public {
65     owner = msg.sender;
66   }
67 
68   /**
69    * @dev Throws if called by any account other than the owner.
70    */
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 
76   /**
77    * @dev Allows the current owner to transfer control of the contract to a newOwner.
78    * @param newOwner The address to transfer ownership to.
79    */
80   function transferOwnership(address newOwner) public onlyOwner {
81     require(newOwner != address(0));
82     owner = newOwner;
83   }
84 }
85 
86 /**
87  * @title Destructible
88  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
89  */
90 contract Destructible is Ownable {
91 
92   /**
93    * @dev Transfers the current balance to the owner and terminates the contract.
94    */
95   function destroy() onlyOwner public {
96     selfdestruct(owner);
97   }
98 
99   function destroyAndSend(address _recipient) onlyOwner public {
100     selfdestruct(_recipient);
101   }
102 }
103 
104 contract Adminable is Ownable {
105   mapping(address => bool) public admins;
106 
107   modifier onlyAdmin() {
108     require(admins[msg.sender]);
109     _;
110   }
111 
112   function addAdmin(address user) onlyOwner public {
113     require(user != address(0));
114     admins[user] = true;
115   }
116 
117   function removeAdmin(address user) onlyOwner public {
118     require(user != address(0));
119     admins[user] = false;
120   }
121 }
122 
123 contract WorldCup2018Betsman is Destructible, Adminable {
124 
125   using SafeMath for uint256;
126 
127   struct Bet {
128     uint256 amount;
129     uint8 result;
130     bool isReverted;
131     bool isFree;
132     bool isClaimed;
133   }
134 
135   struct Game {
136     string team1;
137     string team2;
138     uint date;
139     bool ended;
140     uint256 firstWinResultSum;
141     uint256 drawResultSum;
142     uint256 secondWinResultSum;
143     uint8 result;
144   }
145 
146   struct User {
147     uint freeBets;
148     uint totalGames;
149     uint256[] games;
150     uint statisticBets;
151     uint statisticBetsSum;
152   }
153 
154   mapping (uint => Game) public games;
155   mapping (uint => uint[]) public gamesByDayOfYear;
156   
157   mapping (address => mapping(uint => Bet)) public bets;
158   mapping (address => User) public users;
159   
160 
161   uint public lastGameId = 0;
162 
163   uint public minBet = 0.001 ether;
164   uint public maxBet = 1 ether;
165   uint public betsCountToUseFreeBet = 3;
166 
167   Game game;
168   Bet bet;
169   
170   modifier biggerMinBet() { 
171     require (msg.value >= minBet, "Bet value is lower min bet value."); 
172     _; 
173   }
174 
175   modifier lowerMaxBet() { 
176     require (msg.value <= maxBet, "Bet value is bigger max bet value.");
177     _; 
178   }
179 
180   function hasBet(uint256 _gameId) view internal returns(bool){
181     return bets[msg.sender][_gameId].amount > 0;
182   }
183   
184   modifier hasUserBet(uint256 _gameId) { 
185     require (hasBet(_gameId), "User did not bet this game."); 
186     _; 
187   }
188   
189   modifier hasNotUserBet(uint256 _gameId) { 
190     require(!hasBet(_gameId), "User has already bet this game.");
191     _; 
192   }
193 
194   modifier hasFreeBets() { 
195     require (users[msg.sender].freeBets > 0, "User does not have free bets."); 
196     _; 
197   }
198 
199   modifier isGameExist(uint256 _gameId) { 
200     require(!(games[_gameId].ended), "Game does not exist.");
201     _; 
202   }
203 
204   modifier isGameNotStarted(uint256 _gameId) { 
205     // stop making bets when 5 minutes till game start 
206     // 300000 = 1000 * 60 * 5 - 5 minutes
207     require(games[_gameId].date > now + 300000, "Game has started.");
208     _; 
209   }
210 
211   modifier isRightBetResult(uint8 _betResult) { 
212     require (_betResult > 0 && _betResult < 4);
213     _; 
214   }
215   
216   function setMinBet(uint256 _minBet) external onlyAdmin {
217     minBet = _minBet;
218   }
219 
220   function setMaxBet(uint256 _maxBet) external onlyAdmin {
221     maxBet = _maxBet;
222   }
223 
224   function addFreeBet(address _gambler, uint _count) external onlyAdmin  {
225     users[_gambler].freeBets += _count;
226   }
227 
228   function addGame(string _team1, string _team2, uint _date, uint _dayOfYear) 
229     external
230     onlyAdmin
231   {
232     lastGameId += 1;
233     games[lastGameId] = Game(_team1, _team2, _date, false, 0, 0, 0, 0);
234     gamesByDayOfYear[_dayOfYear].push(lastGameId);
235   }
236 
237   function setGameResult(uint _gameId, uint8 _result)
238     external
239     isGameExist(_gameId)
240     isRightBetResult(_result)
241     onlyAdmin
242   {
243     games[_gameId].ended = true;
244     games[_gameId].result = _result;
245   }
246 
247   function addBet(uint _gameId, uint8 _betResult, uint256 _amount, bool _isFree) internal{
248     bets[msg.sender][_gameId] = Bet(_amount, _betResult, false, _isFree, false);
249     if(_betResult == 1){
250       games[_gameId].firstWinResultSum += _amount;
251     } else if(_betResult == 2) {
252       games[_gameId].drawResultSum += _amount;
253     } else if(_betResult == 3) {
254       games[_gameId].secondWinResultSum += _amount;
255     }
256     users[msg.sender].games.push(_gameId);
257     users[msg.sender].totalGames += 1;
258   }
259   
260   function betGame (
261     uint _gameId,
262     uint8 _betResult
263   ) 
264     external
265     biggerMinBet
266     lowerMaxBet
267     isGameExist(_gameId)
268     isGameNotStarted(_gameId)
269     hasNotUserBet(_gameId)
270     isRightBetResult(_betResult)
271     payable
272   {
273     addBet(_gameId, _betResult, msg.value, false);
274     users[msg.sender].statisticBets += 1;
275     users[msg.sender].statisticBetsSum += msg.value;
276   }
277 
278   function betFreeGame(
279     uint _gameId,
280     uint8 _betResult
281   ) 
282     hasFreeBets
283     isGameExist(_gameId)
284     isGameNotStarted(_gameId)
285     hasNotUserBet(_gameId)
286     isRightBetResult(_betResult)
287     external 
288   {
289     require(users[msg.sender].statisticBets >= betsCountToUseFreeBet, "You need more bets to use free bet");
290     users[msg.sender].statisticBets -= betsCountToUseFreeBet;
291     users[msg.sender].freeBets -= 1;
292     addBet(_gameId, _betResult, minBet, true);
293   }
294 
295   function revertBet(uint _gameId)
296     hasUserBet(_gameId)
297     isGameNotStarted(_gameId)
298     external 
299   {
300     bool isFree = bets[msg.sender][_gameId].isFree;
301     require(!isFree, "You can not revert free bet");
302     bool isReverted = bets[msg.sender][_gameId].isReverted;
303     require(!isReverted, "You can not revert already reverted bet");
304     uint256 amount = bets[msg.sender][_gameId].amount;
305     uint256 betResult = bets[msg.sender][_gameId].result;
306     if(betResult == 1){
307       games[_gameId].firstWinResultSum -= amount;
308     } else if(betResult == 2) {
309       games[_gameId].drawResultSum -= amount;
310     } else if(betResult == 3) {
311       games[_gameId].secondWinResultSum -= amount;
312     }
313     bets[msg.sender][_gameId].isReverted = true;
314     msg.sender.transfer(amount.mul(9).div(10)); // return 90% of bet
315   }
316 
317   function claimPrize(uint _gameId) 
318     hasUserBet(_gameId)
319     public
320   {
321     address gambler = msg.sender;
322     game = games[_gameId];
323     bet = bets[gambler][_gameId];
324     require(game.ended, "Game has not ended yet.");
325     require(bet.result == game.result, "You did not win this game");
326     require(!bet.isReverted, "You can not claim reverted bet");
327     require(!bet.isClaimed, "You can not claim already claimed bet");
328     bets[gambler][_gameId].isClaimed = true;
329     uint winResultSum = 0;
330     uint prize = 0;
331     if(game.result == 1){
332       winResultSum = game.firstWinResultSum;
333       prize = game.drawResultSum + game.secondWinResultSum;
334     } else if(game.result == 2) {
335       winResultSum = game.drawResultSum;
336       prize = game.firstWinResultSum + game.secondWinResultSum;
337     } else if(game.result == 3) {
338       winResultSum = game.secondWinResultSum;
339       prize = game.firstWinResultSum + game.drawResultSum;
340     }
341     // prize = bet amount + (prize * (total result amount / bet amount)) * 80 %;
342     uint gamblerPrize = prize.mul(bet.amount).mul(8).div(10).div(winResultSum);
343     if(!bet.isFree){
344       gamblerPrize = bet.amount + gamblerPrize;
345     }
346     gambler.transfer(gamblerPrize);
347     winResultSum = 0;
348     prize = 0;
349     gamblerPrize = 0;
350     delete game;
351     delete bet;
352   }
353 
354   function getGamblerGameIds(address _gambler) public constant returns (uint256[]){
355     return users[_gambler].games;
356   }
357 
358   function getGamesByDay(uint _dayOfYear) public constant returns (uint256[]){
359     return gamesByDayOfYear[_dayOfYear];
360   }
361 
362   function getGamblerBet(address _gambler, uint _gameId) public constant returns(uint, uint256, uint8, bool, bool, bool){
363     Bet storage tempBet = bets[_gambler][_gameId];
364     return (
365       _gameId,
366       tempBet.amount,
367       tempBet.result,
368       tempBet.isReverted,
369       tempBet.isFree,
370       tempBet.isClaimed
371     );
372   }
373 
374   function withdraw(uint amount) public onlyOwner {
375     owner.transfer(amount);
376   }
377   
378   constructor() public payable {
379     addAdmin(msg.sender);
380     games[1] = Game("RUS", "SAU", 1528984800000, false, 0, 0, 0, 0);
381     gamesByDayOfYear[165] = [1];
382     games[2] = Game("EGY", "URG", 1529060400000, false, 0, 0, 0, 0);
383     games[3] = Game("MAR", "IRN", 1529071200000, false, 0, 0, 0, 0);
384     games[4] = Game("POR", "SPA", 1529082000000, false, 0, 0, 0, 0);
385     gamesByDayOfYear[166] = [2,3,4];
386     games[5] = Game("FRA", "AUS", 1529139600000, false, 0, 0, 0, 0);
387     games[6] = Game("ARG", "ISL", 1529150400000, false, 0, 0, 0, 0);
388     games[7] = Game("PER", "DAN", 1529161200000, false, 0, 0, 0, 0);
389     games[8] = Game("CRO", "NIG", 1529172000000, false, 0, 0, 0, 0);
390     gamesByDayOfYear[167] = [5,6,7,8];
391     lastGameId = 8;
392   }
393 }