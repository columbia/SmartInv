1 pragma solidity ^0.4.19;
2 
3 pragma solidity ^0.4.19;
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10     // precision of division
11     uint constant private DIV_PRECISION = 3;
12 
13     /**
14     * @dev Multiplies two numbers, throws on overflow.
15     */
16     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17         if (a == 0) {
18             return 0;
19         }
20         uint256 c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     /**
26     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
27     */
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         assert(b <= a);
30         return a - b;
31     }
32 
33     /**
34     * @dev Adds two numbers, throws on overflow.
35     */
36     function add(uint256 a, uint256 b) internal pure returns (uint256) {
37         uint256 c = a + b;
38         assert(c >= a);
39         return c;
40     }
41 
42     function percent(uint numerator, uint denominator, uint precision)
43     internal
44     pure
45     returns (uint quotient) {
46         // caution, check safe-to-multiply here
47         uint _numerator = mul(numerator, 10 ** (precision + 1));
48 
49         // with rounding of last digit
50         uint _quotient = add((_numerator / denominator), 5) / 10;
51         return (_quotient);
52     }
53 }
54 
55 contract HotPotato {
56     using SafeMath for uint;
57 
58     event GameStarted(uint indexed gameId, address hotPotatoOwner, uint gameStart);
59     event GameEnded(uint indexed gameId);
60     event HotPotatoPassed(uint indexed gameId, address receiver);
61     event PlayerJoined(uint indexed gameId, address player, uint stake, uint totalStake, uint players);
62     event PlayerWithdrew(address indexed player);
63     event NewMaxTimeHolder(uint indexed gameId, address maxTimeHolder);
64     event AddressHeldFor(uint indexed gameId, address player, uint timeHeld);
65 
66     struct Game {
67         // whether the game is running and the timer has started
68         bool running;
69 
70         // game has completed it's whole run
71         bool finished;
72 
73         // who owns the hot potato in the game
74         address hotPotatoOwner;
75 
76         // the unix timestamp of when the game when started
77         uint gameStart;
78 
79         // players to their stakes (a stake >0 indicates the address is playing)
80         mapping(address => uint) stakes;
81 
82         // the total amount of Ether staked on the game
83         uint totalStake;
84 
85         // players in the game
86         uint players;
87 
88         // whether an address has withdrawed there stake or not
89         mapping(address => bool) withdrawals;
90 
91         // the time the addresses held the potato for in seconds
92         mapping(address => uint) holdTimes;
93 
94         // the block the game was created on (i.e. when players could join it)
95         uint blockCreated;
96 
97         // the time the hot potato was received last
98         uint hotPotatoReceiveTime;
99 
100         // the address which has held the hot potato the longest so far
101         address maxTimeHolder;
102     }
103 
104     // fees taken per stake as a percent of 1 ether
105     uint constant private FEE_TAKE = 0.02 ether;
106 
107     // the degree of precision for division
108     uint constant private DIV_DEGREE_PRECISION = 3;
109 
110     // the minimum amount of ether to enter the game
111     uint constant public MIN_STAKE = 0.01 ether;
112 
113     // the minimum amount of players to start a game
114     uint constant public MIN_PLAYERS = 3;
115 
116     // duration of a game in seconds (10 mins)
117     uint constant public GAME_DURATION = 600;
118 
119     // who owns/publishes the contract
120     address private contractOwner;
121 
122     // the amount of fees collected
123     uint public feesTaken;
124 
125     // the current game id
126     uint public currentGameId;
127 
128     // game ids to games
129     mapping(uint => Game) public games;
130 
131     modifier gameRunning(uint gameId) {
132         require(games[gameId].running);
133 
134         _;
135     }
136 
137     modifier gameStopped(uint gameId) {
138         require(!games[gameId].running);
139 
140         _;
141     }
142 
143     modifier gameFinished(uint gameId) {
144         require(games[gameId].finished);
145 
146         _;
147     }
148 
149     modifier hasValue(uint amount) {
150         require(msg.value >= amount);
151 
152         _;
153     }
154 
155     modifier notInGame(uint gameId, address player) {
156         require(games[gameId].stakes[player] == 0);
157 
158         _;
159     }
160 
161     modifier inGame(uint gameId, address player) {
162         require(games[gameId].stakes[player] > 0);
163 
164         _;
165     }
166 
167     modifier enoughPlayers(uint gameId) {
168         require(games[gameId].players >= MIN_PLAYERS);
169 
170         _;
171     }
172 
173     modifier hasHotPotato(uint gameId, address player) {
174         require(games[gameId].hotPotatoOwner == player);
175 
176         _;
177     }
178 
179     modifier notLost(uint gameId, address player) {
180         require(games[gameId].hotPotatoOwner != player && games[gameId].maxTimeHolder != player);
181 
182         _;
183     }
184 
185     modifier gameTerminable(uint gameId) {
186         require(block.timestamp.sub(games[gameId].gameStart) >= GAME_DURATION);
187 
188         _;
189     }
190 
191     modifier notWithdrew(uint gameId) {
192         require(!games[gameId].withdrawals[msg.sender]);
193 
194         _;
195     }
196 
197     modifier onlyContractOwner() {
198         require(msg.sender == contractOwner);
199 
200         _;
201     }
202 
203     function HotPotato()
204     public
205     payable {
206         contractOwner = msg.sender;
207         games[0].blockCreated = block.number;
208     }
209 
210     function enterGame()
211     public
212     payable
213     gameStopped(currentGameId)
214     hasValue(MIN_STAKE)
215     notInGame(currentGameId, msg.sender) {
216         Game storage game = games[currentGameId];
217 
218         uint feeTake = msg.value.mul(FEE_TAKE) / (1 ether);
219 
220         feesTaken = feesTaken.add(feeTake);
221 
222         game.stakes[msg.sender] = msg.value.sub(feeTake);
223         game.totalStake = game.totalStake.add(msg.value.sub(feeTake));
224         game.players = game.players.add(1);
225 
226         PlayerJoined(currentGameId, msg.sender, msg.value.sub(feeTake),
227             game.totalStake, game.players);
228     }
229 
230     function startGame(address receiver)
231     public
232     payable
233     gameStopped(currentGameId)
234     inGame(currentGameId, msg.sender)
235     inGame(currentGameId, receiver)
236     enoughPlayers(currentGameId) {
237         Game storage game = games[currentGameId];
238 
239         game.running = true;
240         game.hotPotatoOwner = receiver;
241         game.hotPotatoReceiveTime = block.timestamp;
242         game.gameStart = block.timestamp;
243         game.maxTimeHolder = receiver;
244 
245         GameStarted(currentGameId, game.hotPotatoOwner, game.gameStart);
246     }
247 
248     function passHotPotato(address receiver)
249     public
250     payable
251     gameRunning(currentGameId)
252     hasHotPotato(currentGameId, msg.sender)
253     inGame(currentGameId, receiver) {
254         Game storage game = games[currentGameId];
255 
256         game.hotPotatoOwner = receiver;
257 
258         uint timeHeld = block.timestamp.sub(game.hotPotatoReceiveTime);
259         game.holdTimes[msg.sender] = game.holdTimes[msg.sender].add(timeHeld);
260         AddressHeldFor(currentGameId, msg.sender, game.holdTimes[msg.sender]);
261 
262         if (game.holdTimes[msg.sender] > game.holdTimes[game.maxTimeHolder]) {
263             game.maxTimeHolder = msg.sender;
264             NewMaxTimeHolder(currentGameId, game.maxTimeHolder);
265         }
266 
267         game.hotPotatoReceiveTime = block.timestamp;
268 
269         HotPotatoPassed(currentGameId, receiver);
270     }
271 
272     function endGame()
273     public
274     payable
275     gameRunning(currentGameId)
276     inGame(currentGameId, msg.sender)
277     gameTerminable(currentGameId) {
278         Game storage game = games[currentGameId];
279 
280         game.running = false;
281         game.finished = true;
282 
283         uint timeHeld = block.timestamp.sub(game.hotPotatoReceiveTime);
284         game.holdTimes[game.hotPotatoOwner] = game.holdTimes[game.hotPotatoOwner].add(timeHeld);
285         AddressHeldFor(currentGameId, game.hotPotatoOwner, game.holdTimes[msg.sender]);
286 
287         if (game.holdTimes[game.hotPotatoOwner] > game.holdTimes[game.maxTimeHolder]) {
288             game.maxTimeHolder = game.hotPotatoOwner;
289             NewMaxTimeHolder(currentGameId, game.maxTimeHolder);
290         }
291 
292         GameEnded(currentGameId);
293 
294         currentGameId = currentGameId.add(1);
295         games[currentGameId].blockCreated = block.number;
296     }
297 
298     function withdraw(uint gameId)
299     public
300     payable
301     gameFinished(gameId)
302     inGame(gameId, msg.sender)
303     notLost(gameId, msg.sender)
304     notWithdrew(gameId) {
305         Game storage game = games[gameId];
306 
307         uint banishedStake = 0;
308 
309         if (game.hotPotatoOwner == game.maxTimeHolder) {
310             banishedStake = game.stakes[game.hotPotatoOwner];
311         } else {
312             banishedStake = game.stakes[game.hotPotatoOwner].add(game.stakes[game.maxTimeHolder]);
313         }
314 
315         uint collectiveStake = game.totalStake.sub(banishedStake);
316 
317         uint stake = game.stakes[msg.sender];
318 
319         uint percentageClaim = SafeMath.percent(stake, collectiveStake, DIV_DEGREE_PRECISION);
320 
321         uint claim = stake.add(banishedStake.mul(percentageClaim) / (10 ** DIV_DEGREE_PRECISION));
322 
323         game.withdrawals[msg.sender] = true;
324 
325         msg.sender.transfer(claim);
326 
327         PlayerWithdrew(msg.sender);
328     }
329 
330     function withdrawFees()
331     public
332     payable
333     onlyContractOwner {
334         uint feesToTake = feesTaken;
335         feesTaken = 0;
336         contractOwner.transfer(feesToTake);
337     }
338 
339     // GETTERS
340     function getGame(uint gameId)
341     public
342     constant
343     returns (bool, bool, address, uint, uint, uint, uint, address, uint) {
344         Game storage game = games[gameId];
345         return (
346         game.running,
347         game.finished,
348         game.hotPotatoOwner,
349         game.gameStart,
350         game.totalStake,
351         game.players,
352         game.blockCreated,
353         game.maxTimeHolder,
354         currentGameId);
355     }
356 }