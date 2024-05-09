1 /**
2  * @title Ownable
3  * @dev The Ownable contract has an owner address, and provides basic authorization control
4  * functions, this simplifies the implementation of "user permissions".
5  */
6 contract Ownable {
7   address public owner;
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() {
15     owner = msg.sender;
16   }
17 
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address newOwner) onlyOwner {
33     if (newOwner != address(0)) {
34       owner = newOwner;
35     }
36   }
37 
38 }
39 
40 
41 contract Champion is Ownable {
42     uint8 constant NUMBER = 1;
43     uint8 constant STRING = 0;
44     
45     /** game statuses **/
46     uint8 constant GS_NOT_STARTED = 0;
47     uint8 constant GS_IN_PROCESS = 1;
48     uint8 constant GS_WAITING_USERS = 2;
49     
50     uint256 public game = 0;
51     
52     uint256 public gamePlayerNumber = 0;
53     
54     uint8 public currentGameStatus;
55     
56     uint256 public currentGameBlockNumber;
57     
58     uint256[] public allGames;
59     
60     mapping(uint256 => uint256[]) internal games;
61     
62     mapping(uint256 => Rules) internal gamesRules;
63     
64     mapping(uint256 => address[]) internal gamePlayers;
65     
66     /** game => user **/
67     mapping(uint256 => address) public winners;
68     
69     mapping(uint256 => mapping(address => uint256[])) internal playerNumbersInGame;
70 
71     mapping(uint256 => uint256) gamePrize;
72     
73     struct Rules {
74         uint8 right;
75         uint8 left;
76     }
77     
78     function Champion() {
79         currentGameStatus = GS_NOT_STARTED;
80         game = block.number;
81     }
82 
83     function getAllGames() constant returns(uint256[]) {
84         uint256[] memory allgames = new uint256[](allGames.length);
85         allgames = allGames;
86         return allgames;
87     }
88 
89     function getAllGamesCount() constant returns(uint256) {
90         return allGames.length;
91     }
92 
93     function getWinner(uint256 _game) constant returns (address) {
94         return winners[_game];
95     }
96     
97     function setWinner(uint256 _game, address _winner) private returns (bool) {
98         winners[_game] = _winner;
99     }
100     
101     function getGameRules(uint256 _game) 
102             constant returns (uint8 leftSide, uint8 rightSide) 
103     {
104         return (leftSideRule(_game), rightSideRule(_game));
105     }
106     
107     function leftSideRule(uint256 _game) 
108             private constant returns (uint8) 
109     {
110         return gamesRules[getStartBlock(_game)].left;
111     }
112     
113     function rightSideRule(uint256 _game) 
114             private constant returns (uint8) 
115     {
116         return gamesRules[getStartBlock(_game)].right;
117     }
118     
119     function getStartBlock(uint256 _game) 
120             constant returns (uint256) 
121     {
122         return games[_game][0];
123     }
124 
125     function getPlayersCountByGame(uint256 _game) 
126             constant returns (uint256)
127     {
128         return gamePlayers[_game].length;
129     }
130     
131     function getPlayerNumbersInGame(uint256 _gameBlock, address _palayer) 
132             constant returns (uint256[])
133     {
134         return playerNumbersInGame[_gameBlock][_palayer];
135     }
136     
137     function setGamePrize(uint256 _game, uint256 _amount) {
138         gamePrize[_game] = _amount;
139     }
140 
141     function getGamePrize(uint256 _game) constant returns (uint256) {
142         return gamePrize[_game];
143     }
144 
145     /** define game rules **/
146     function defineGameRules(uint256 _game) private returns (bool) {
147         
148         Rules memory rules;
149         
150         if (isNumber(_game)) {
151             rules.left = NUMBER;
152             rules.right = STRING;
153         } else {
154             rules.left = STRING;
155             rules.right = NUMBER;
156         }
157         
158         gamesRules[_game] = rules;
159         
160         return true;
161     }
162     
163     function isNumber(uint256 _game) private constant returns (bool) {
164         bytes32 hash = block.blockhash(_game);
165         require(hash != 0x0);
166         
167         byte b = byte(hash[31]);
168         uint hi = uint8(b) / 16;
169         uint lo = uint8(b) - 16 * uint8(hi);
170         
171         if (lo <= 9) {
172             return true;
173         }
174         
175         return false;
176     }
177     
178     function startGame() returns (bool) {
179         require(currentGameStatus == GS_WAITING_USERS);
180         currentGameStatus = GS_IN_PROCESS;
181         currentGameBlockNumber = game;
182         game = block.number;
183         gamePlayerNumber = 0;
184         
185         allGames.push(currentGameBlockNumber);
186         
187         uint256 startBlock = block.number - 1;
188         defineGameRules(startBlock);
189         games[currentGameBlockNumber].push(startBlock);
190         
191         return true;
192     }
193 
194     function finishCurrentGame() returns (address) {
195         return finishGame(currentGameBlockNumber);
196     }
197 
198     function finishGame(uint256 _game) onlyOwner returns (address) {
199         require(currentGameBlockNumber != 0);
200         require(winners[_game] == 0x0);
201         require(currentGameStatus == GS_IN_PROCESS);
202 
203         uint256 steps = getCurrentGameSteps();
204         uint256 startBlock = getStartBlock(currentGameBlockNumber);
205         require(startBlock + steps < block.number);
206         
207         uint256 lMin = 1;
208         uint256 lMax = 2;
209         uint256 rMin = 3;
210         uint256 rMax = 4;
211         
212         for (uint8 i = 1; i <= steps; i++) {
213             require(block.blockhash(_game + i) != 0x0);
214             (lMin, lMax, rMin, rMax) = processSteps(currentGameBlockNumber, i);
215         
216             if (lMin == lMax && rMin == rMax && lMin == rMin) {
217                 address winner = gamePlayers[currentGameBlockNumber][rMax];
218                 
219                 setWinner(
220                     currentGameBlockNumber, 
221                     winner
222                 );
223                                 
224                 currentGameBlockNumber = 0;
225                 currentGameStatus = GS_WAITING_USERS;
226                 
227                 return winner;
228             }
229         }
230         
231         return 0x0;
232     }
233     
234     function getCurrentGameSteps() constant returns (uint256) {
235         return getStepsCount(currentGameBlockNumber);
236     }
237 
238     function getStepsCount(uint256 _game) 
239             constant returns (uint256 y) {
240         uint256 x = getPlayersCountByGame(_game);
241         assembly {
242             let arg := x
243             x := sub(x,1)
244             x := or(x, div(x, 0x02))
245             x := or(x, div(x, 0x04))
246             x := or(x, div(x, 0x10))
247             x := or(x, div(x, 0x100))
248             x := or(x, div(x, 0x10000))
249             x := or(x, div(x, 0x100000000))
250             x := or(x, div(x, 0x10000000000000000))
251             x := or(x, div(x, 0x100000000000000000000000000000000))
252             x := add(x, 1)
253             let m := mload(0x40)
254             mstore(m,           0xf8f9cbfae6cc78fbefe7cdc3a1793dfcf4f0e8bbd8cec470b6a28a7a5a3e1efd)
255             mstore(add(m,0x20), 0xf5ecf1b3e9debc68e1d9cfabc5997135bfb7a7a3938b7b606b5b4b3f2f1f0ffe)
256             mstore(add(m,0x40), 0xf6e4ed9ff2d6b458eadcdf97bd91692de2d4da8fd2d0ac50c6ae9a8272523616)
257             mstore(add(m,0x60), 0xc8c0b887b0a8a4489c948c7f847c6125746c645c544c444038302820181008ff)
258             mstore(add(m,0x80), 0xf7cae577eec2a03cf3bad76fb589591debb2dd67e0aa9834bea6925f6a4a2e0e)
259             mstore(add(m,0xa0), 0xe39ed557db96902cd38ed14fad815115c786af479b7e83247363534337271707)
260             mstore(add(m,0xc0), 0xc976c13bb96e881cb166a933a55e490d9d56952b8d4e801485467d2362422606)
261             mstore(add(m,0xe0), 0x753a6d1b65325d0c552a4d1345224105391a310b29122104190a110309020100)
262             mstore(0x40, add(m, 0x100))
263             let value := 0x818283848586878898a8b8c8d8e8f929395969799a9b9d9e9faaeb6bedeeff
264             let shift := 0x100000000000000000000000000000000000000000000000000000000000000
265             let a := div(mul(x, value), shift)
266             y := div(mload(add(m,sub(255,a))), shift)
267             y := add(y, mul(256, gt(arg, 0x8000000000000000000000000000000000000000000000000000000000000000)))
268         }
269     }
270 
271     function processSteps(uint256 _gameBlock, uint256 step) 
272             constant returns (uint256, uint256, uint256, uint256) {
273         require(_gameBlock != 0);
274         require((getStartBlock(_gameBlock) + i) < block.number);
275         // TODO check 
276         
277         uint256 lMin = 0;
278         uint256 lMax = 0;
279         uint256 rMin = 0;
280         uint256 rMax = gamePlayers[_gameBlock].length - 1;
281         
282         if (isEvenNumber(rMax)) {
283             lMax = rMax / 2;
284             rMin = rMax / 2 + 1;
285         } else {
286             lMax = rMax / 2;
287             rMin = rMax / 2 + 1;
288         }
289         
290         if (step == 0) {
291             return (lMin, lMax, rMin, rMax);
292         } 
293         
294         for (uint i = 1; i <= step; i++) {
295             bool isNumberRes = isNumber(getStartBlock(_gameBlock) + i);
296             
297             if ((isNumberRes && leftSideRule(_gameBlock) == NUMBER) ||
298                 (!isNumberRes && leftSideRule(_gameBlock) == STRING)
299             ) {
300                 if (lMin == lMax) {
301                     rMin = lMin;
302                     rMax = lMax;
303                     break;
304                 }
305                 
306                 rMax = lMax;
307             } else if (isNumberRes && rightSideRule(_gameBlock) == NUMBER ||
308                 (!isNumberRes && rightSideRule(_gameBlock) == STRING)
309             ) {
310                 if (rMin == rMax) {
311                     lMin = rMin;
312                     lMax = rMax;
313                     break;
314                 }
315                 
316                 lMin = rMin;
317             }
318             
319             if ((rMax - lMin != 1) && isEvenNumber(rMax)) {
320                 lMax = rMax / 2;
321                 rMin = rMax / 2 + 1;
322             } else if (rMax - lMin != 1) {
323                 lMax = rMax / 2;
324                 rMin = rMax / 2 + 1;
325             } else {
326                 lMax = lMin;
327                 rMin = rMax;
328             }
329         }
330         
331         return (lMin, lMax, rMin, rMax);
332     }
333     
334     function isEvenNumber(uint _v1) 
335             internal constant returns (bool) {
336         uint v1u = _v1 * 100;
337         uint v2 = 2;
338         
339         uint vuResult = v1u / v2;
340         uint vResult = _v1 / v2;
341         
342         if (vuResult != vResult * 100) {
343             return false;
344         }
345         
346         return true;
347     }
348     
349     /** buy ticket && start game | init game by conditions **/
350     function buyTicket(address _player) onlyOwner 
351             returns (uint256 playerNumber, uint256 gameNumber) {
352         if (currentGameStatus == GS_NOT_STARTED) {
353             currentGameStatus = GS_WAITING_USERS;
354         }
355         
356         gamePlayers[game].push(_player);
357         
358         playerNumber = gamePlayerNumber;
359         
360         playerNumbersInGame[game][_player].push(playerNumber);
361         
362         gamePlayerNumber++;
363         
364         return (playerNumber, game);
365     }
366 }