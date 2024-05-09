1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() {
17     owner = msg.sender;
18   }
19 
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) onlyOwner {
35     if (newOwner != address(0)) {
36       owner = newOwner;
37     }
38   }
39 
40 }
41 
42 contract Champion is Ownable {
43     uint8 constant NUMBER = 1;
44     uint8 constant STRING = 0;
45     
46     uint8 constant GS_NOT_STARTED = 0;
47     uint8 constant GS_IN_PROCESS = 1;
48     uint8 constant GS_WAITING_USERS = 2;
49     uint8 constant BILLIONS_STEP = 35; 
50     
51     uint256 public game = 0;
52     
53     uint8 public currentGameStatus;
54     
55     uint256 public currentGameBlockNumber;
56     
57     uint256[] public allGames;
58     
59     mapping(uint256 => uint256) internal gameStartBlock;
60     
61     mapping(uint256 => address[]) internal gamePlayers;
62     
63     mapping(uint256 => address) public winners;
64     
65     mapping(uint256 => mapping(address => uint256[])) internal playerNumbersInGame;
66 
67     mapping(uint256 => uint256) gamePrize;
68     
69     function Champion() {
70         currentGameStatus = GS_NOT_STARTED;
71         game = block.number;
72     }
73 
74     function getAllGamesCount() constant returns(uint256) {
75         return allGames.length;
76     }
77 
78     function getWinner(uint256 _game) constant returns (address) {
79         return winners[_game];
80     }
81     
82     function setWinner(uint256 _game, address _winner) private returns (bool) {
83         winners[_game] = _winner;
84     }
85     
86     function getStartBlock(uint256 _game) 
87             constant returns (uint256) 
88     {
89         return gameStartBlock[_game];
90     }
91 
92     function getPlayersCountByGame(uint256 _game) 
93             constant returns (uint256)
94     {
95         return gamePlayers[_game].length;
96     }
97     
98     function getPlayerNumbersInGame(uint256 _gameBlock, address _palayer) 
99             constant returns (uint256[])
100     {
101         return playerNumbersInGame[_gameBlock][_palayer];
102     }
103 
104     function getGamePrize(uint256 _game) constant returns (uint256) {
105         return gamePrize[_game];
106     }
107     
108     function setGamePrize(uint256 _game, uint256 _amount) onlyOwner {
109         gamePrize[_game] = _amount;
110     }
111 
112     function isNumber(uint256 _game) private constant returns (bool) {
113         bytes32 hash = block.blockhash(_game);
114         require(hash != 0x0);
115         
116         byte b = byte(hash[31]);
117         uint hi = uint8(b) / 16;
118         uint lo = uint8(b) - 16 * uint8(hi);
119         
120         if (lo <= 9) {
121             return true;
122         }
123         
124         return false;
125     }
126     
127     function startGame() onlyOwner returns (bool) {
128         require(currentGameStatus == GS_WAITING_USERS);
129         currentGameStatus = GS_IN_PROCESS;
130         currentGameBlockNumber = game;
131         game = block.number;
132         
133         allGames.push(currentGameBlockNumber);
134         
135         uint256 startBlock = block.number - 1;
136         gameStartBlock[currentGameBlockNumber] = startBlock;
137         
138         return true;
139     }
140 
141     function finishCurrentGame() onlyOwner returns (address) {
142         return finishGame(currentGameBlockNumber);
143     }
144 
145     function finishGame(uint256 _game) onlyOwner returns (address) {
146         require(_game != 0);
147         require(winners[_game] == 0x0);
148         require(currentGameStatus == GS_IN_PROCESS);
149 
150         uint256 steps = getCurrentGameSteps();
151         uint256 startBlock = getStartBlock(_game);
152         require(startBlock + steps < block.number);
153         
154         uint256 lMin = 0;
155         uint256 lMax = 0;
156         uint256 rMin = 0;
157         uint256 rMax = 0;
158         
159         (lMin, lMax, rMin, rMax) = processSteps(_game);
160         
161         address winner = gamePlayers[_game][rMax];
162             
163         setWinner(
164             _game, 
165             winner
166         );
167                         
168         currentGameBlockNumber = 0;
169         currentGameStatus = GS_WAITING_USERS;
170         
171         return winner;
172     }
173     
174     function getCurrentGameSteps() constant returns (uint256) {
175         return getStepsCount(currentGameBlockNumber);
176     }
177 
178     function getStepsCount(uint256 _game) 
179             constant returns (uint256 y) {
180         uint256 x = getPlayersCountByGame(_game);
181         assembly {
182             let arg := x
183             x := sub(x,1)
184             x := or(x, div(x, 0x02))
185             x := or(x, div(x, 0x04))
186             x := or(x, div(x, 0x10))
187             x := or(x, div(x, 0x100))
188             x := or(x, div(x, 0x10000))
189             x := or(x, div(x, 0x100000000))
190             x := or(x, div(x, 0x10000000000000000))
191             x := or(x, div(x, 0x100000000000000000000000000000000))
192             x := add(x, 1)
193             let m := mload(0x40)
194             mstore(m,           0xf8f9cbfae6cc78fbefe7cdc3a1793dfcf4f0e8bbd8cec470b6a28a7a5a3e1efd)
195             mstore(add(m,0x20), 0xf5ecf1b3e9debc68e1d9cfabc5997135bfb7a7a3938b7b606b5b4b3f2f1f0ffe)
196             mstore(add(m,0x40), 0xf6e4ed9ff2d6b458eadcdf97bd91692de2d4da8fd2d0ac50c6ae9a8272523616)
197             mstore(add(m,0x60), 0xc8c0b887b0a8a4489c948c7f847c6125746c645c544c444038302820181008ff)
198             mstore(add(m,0x80), 0xf7cae577eec2a03cf3bad76fb589591debb2dd67e0aa9834bea6925f6a4a2e0e)
199             mstore(add(m,0xa0), 0xe39ed557db96902cd38ed14fad815115c786af479b7e83247363534337271707)
200             mstore(add(m,0xc0), 0xc976c13bb96e881cb166a933a55e490d9d56952b8d4e801485467d2362422606)
201             mstore(add(m,0xe0), 0x753a6d1b65325d0c552a4d1345224105391a310b29122104190a110309020100)
202             mstore(0x40, add(m, 0x100))
203             let value := 0x818283848586878898a8b8c8d8e8f929395969799a9b9d9e9faaeb6bedeeff
204             let shift := 0x100000000000000000000000000000000000000000000000000000000000000
205             let a := div(mul(x, value), shift)
206             y := div(mload(add(m,sub(255,a))), shift)
207             y := add(y, mul(256, gt(arg, 0x8000000000000000000000000000000000000000000000000000000000000000)))
208         }
209     }
210     
211     function getGameRules(uint256 _game) 
212             constant returns (uint8 left, uint8 right) {
213         if (isNumber(_game)) {
214             left = NUMBER;
215             right = STRING;
216         } else {
217             left = STRING;
218             right = NUMBER;
219         }
220 
221         return (left, right);
222     }
223 
224     function processSteps(uint256 _gameBlock) 
225             internal returns (uint256 lMin, uint256 lMax, uint256 rMin, uint256 rMax) {
226         require(_gameBlock != 0);
227         
228         lMin = 0;
229         lMax = 0;
230         rMin = 0;
231         rMax = gamePlayers[_gameBlock].length - 1;
232         
233         if (isEvenNumber(rMax)) {
234             lMax = rMax / 2;
235             rMin = rMax / 2 + 1;
236         } else {
237             lMax = rMax / 2;
238             rMin = rMax / 2 + 1;
239         }
240 
241         uint8 left = 0;
242         uint8 right = 0;
243         (left, right) = getGameRules(_gameBlock);
244 
245         for (uint8 i = 1; i <= BILLIONS_STEP; i++) {
246             bool isNumberRes = isNumber(getStartBlock(_gameBlock) + i);
247             
248             if ((isNumberRes && left == NUMBER) ||
249                 (!isNumberRes && left == STRING)
250             ) {
251                 if (lMin == lMax) {
252                     rMin = lMin;
253                     rMax = lMax;
254                     break;
255                 }
256                 
257                 rMax = lMax;
258             } else if (isNumberRes && right == NUMBER ||
259                 (!isNumberRes && right == STRING)
260             ) {
261                 if (rMin == rMax) {
262                     lMin = rMin;
263                     lMax = rMax;
264                     break;
265                 }
266                 
267                 lMin = rMin;
268             }
269             
270             if (rMax - lMin != 1) {
271                 lMax = lMin + (rMax - lMin) / 2;
272                 rMin = lMin + (rMax - lMin) / 2 + 1;
273             } else {
274                 lMax = lMin;
275                 rMin = rMax;
276             }
277         }
278         
279         return (lMin, lMax, rMin, rMax);
280     }
281 
282     function processStepsByStep(uint256 _gameBlock, uint256 step) 
283             constant returns (uint256 lMin, uint256 lMax, uint256 rMin, uint256 rMax) {
284         require(_gameBlock != 0);
285         require((getStartBlock(_gameBlock) + i) < block.number);
286         
287         lMin = 0;
288         lMax = 0;
289         rMin = 0;
290         rMax = gamePlayers[_gameBlock].length - 1;
291         
292         if (isEvenNumber(rMax)) {
293             lMax = rMax / 2;
294             rMin = rMax / 2 + 1;
295         } else {
296             lMax = rMax / 2;
297             rMin = rMax / 2 + 1;
298         }
299         
300         if (step == 0) {
301             return (lMin, lMax, rMin, rMax);
302         } 
303         
304         uint8 left = 0;
305         uint8 right = 0;
306         (left, right) = getGameRules(_gameBlock);
307 
308         for (uint i = 1; i <= step; i++) {
309             bool isNumberRes = isNumber(getStartBlock(_gameBlock) + i);
310             
311             if ((isNumberRes && left == NUMBER) ||
312                 (!isNumberRes && left == STRING)
313             ) {
314                 if (lMin == lMax) {
315                     rMin = lMin;
316                     rMax = lMax;
317                     break;
318                 }
319                 
320                 rMax = lMax;
321             } else if (isNumberRes && right == NUMBER ||
322                 (!isNumberRes && right == STRING)
323             ) {
324                 if (rMin == rMax) {
325                     lMin = rMin;
326                     lMax = rMax;
327                     break;
328                 }
329                 
330                 lMin = rMin;
331             }
332             
333             if (rMax - lMin != 1) {
334                 lMax = lMin + (rMax - lMin) / 2;
335                 rMin = lMin + (rMax - lMin) / 2 + 1;
336             } else {
337                 lMax = lMin;
338                 rMin = rMax;
339             }
340         }
341         
342         return (lMin, lMax, rMin, rMax);
343     }
344 
345     function isEvenNumber(uint _v1) 
346             internal constant returns (bool) {
347         uint v1u = _v1 * 100;
348         uint v2 = 2;
349         
350         uint vuResult = v1u / v2;
351         uint vResult = _v1 / v2;
352         
353         if (vuResult != vResult * 100) {
354             return false;
355         }
356         
357         return true;
358     }
359     
360     function buyTicket(address _player) onlyOwner 
361             returns (uint256 playerNumber, uint256 gameNumber) {
362         if (currentGameStatus == GS_NOT_STARTED) {
363             currentGameStatus = GS_WAITING_USERS;
364         }
365         
366         playerNumber = gamePlayers[game].length;
367 
368         gamePlayers[game].push(_player);
369         
370         playerNumbersInGame[game][_player].push(playerNumber);
371                 
372         return (playerNumber, game);
373     }
374 }