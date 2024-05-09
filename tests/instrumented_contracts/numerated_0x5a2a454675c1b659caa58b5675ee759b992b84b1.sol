1 pragma solidity ^0.4.11;
2 
3 
4 contract SafeMath {
5 
6     function add(uint x, uint y) internal constant returns (uint z) {
7         assert((z = x + y) >= x);
8     }
9  
10     function subtract(uint x, uint y) internal constant returns (uint z) {
11         assert((z = x - y) <= x);
12     }
13 
14     function multiply(uint x, uint y) internal constant returns (uint z) {
15         z = x * y;
16         assert(x == 0 || z / x == y);
17         return z;
18     }
19 
20     function divide(uint x, uint y) internal constant returns (uint z) {
21         z = x / y;
22         assert(x == ( (y * z) + (x % y) ));
23         return z;
24     }
25     
26     function min64(uint64 x, uint64 y) internal constant returns (uint64) {
27         return x < y ? x: y;
28     }
29     
30     function max64(uint64 x, uint64 y) internal constant returns (uint64) {
31         return x >= y ? x : y;
32     }
33 
34     function min(uint x, uint y) internal constant returns (uint) {
35         return (x <= y) ? x : y;
36     }
37 
38     function max(uint x, uint y) internal constant returns (uint) {
39         return (x >= y) ? x : y;
40     }
41 
42     function assert(bool assertion) internal {
43         if (!assertion) {
44             revert();
45         }
46     }
47 }
48 
49 
50 contract Owned {
51     address owner;
52 
53     modifier onlyowner() {
54         if (msg.sender == owner) {
55             _;
56         }
57     }
58 
59     function Owned() {
60         owner = msg.sender;
61     }
62 }
63 
64 
65 contract Mortal is Owned {
66     
67     function kill() {
68         if (msg.sender == owner)
69             selfdestruct(owner);
70     }
71 }
72 
73 
74 contract Lotthereum is Mortal, SafeMath {
75 
76     Game[] private games;
77     mapping (address => uint) private balances;  // balances per address
78 
79     struct Game {
80         uint id;
81         bool open;
82         uint pointer;
83         uint maxNumberOfBets;
84         uint minAmountByBet;
85         uint prize;
86         uint currentRound;
87         Round[] rounds;
88     }
89 
90     struct Round {
91         uint id;
92         uint pointer;
93         bytes32 hash;
94         bool open;
95         uint8 number;
96         Bet[] bets;
97         address[] winners;
98     }
99 
100     struct Bet {
101         uint id;
102         address origin;
103         uint amount;
104         uint8 bet;
105         uint round;
106     }
107 
108     event RoundOpen(
109         uint indexed gameId,
110         uint indexed roundId
111     );
112     event RoundClose(
113         uint indexed gameId,
114         uint indexed roundId,
115         uint8 number
116     );
117     event MaxNumberOfBetsChanged(
118         uint maxNumberOfBets
119     );
120     event MinAmountByBetChanged(
121         uint minAmountByBet
122     );
123     event BetPlaced(
124         uint indexed gameId,
125         uint indexed roundId,
126         address indexed origin,
127         uint betId
128     );
129     event RoundWinner(
130         uint indexed gameId,
131         uint indexed roundId,
132         address indexed winnerAddress,
133         uint amount
134     );
135     event GameOpened(
136         uint indexed gameId
137     );
138     event GameClosed(
139         uint indexed gameId
140     );
141 
142     function createGame(
143         uint pointer,
144         uint maxNumberOfBets,
145         uint minAmountByBet,
146         uint prize
147     ) onlyowner returns (uint id) {
148         id = games.length;
149         games.length += 1;
150         games[id].id = id;
151         games[id].pointer = pointer;
152         games[id].maxNumberOfBets = maxNumberOfBets;
153         games[id].minAmountByBet = minAmountByBet;
154         games[id].prize = prize;
155         games[id].open = true;
156         games[id].currentRound = createGameRound(id);
157     }
158 
159     function closeGame(uint gameId) onlyowner returns (bool) {
160         games[gameId].open = false;
161         GameClosed(gameId);
162         return true;
163     }
164 
165     function openGame(uint gameId) onlyowner returns (bool) {
166         games[gameId].open = true;
167         GameOpened(gameId);
168         return true;
169     }
170 
171     function createGameRound(uint gameId) internal returns (uint id) {
172         id = games[gameId].rounds.length;
173         games[gameId].rounds.length += 1;
174         games[gameId].rounds[id].id = id;
175         games[gameId].rounds[id].open = true;
176         RoundOpen(gameId, id);
177     }
178 
179     function payout(uint gameId) internal {
180         address[] winners = games[gameId].rounds[games[gameId].currentRound].winners;
181         for (uint i = 0; i < games[gameId].maxNumberOfBets -1; i++) {
182             if (games[gameId].rounds[games[gameId].currentRound].bets[i].bet == games[gameId].rounds[games[gameId].currentRound].number) {
183                 uint id = winners.length;
184                 winners.length += 1;
185                 winners[id] = games[gameId].rounds[games[gameId].currentRound].bets[i].origin;
186             }
187         }
188 
189         if (winners.length > 0) {
190             uint prize = divide(games[gameId].prize, winners.length);
191             for (i = 0; i < winners.length; i++) {
192                 balances[winners[i]] = add(balances[winners[i]], prize);
193                 RoundWinner(gameId, games[gameId].currentRound, winners[i], prize);
194             }
195         }
196     }
197 
198     function closeRound(uint gameId) constant internal {
199         games[gameId].rounds[games[gameId].currentRound].open = false;
200         games[gameId].rounds[games[gameId].currentRound].hash = getBlockHash(games[gameId].pointer);
201         games[gameId].rounds[games[gameId].currentRound].number = getNumber(games[gameId].rounds[games[gameId].currentRound].hash);
202         // games[gameId].pointer = games[gameId].rounds[games[gameId].currentRound].number;
203         payout(gameId);
204         RoundClose(
205             gameId,
206             games[gameId].rounds[games[gameId].currentRound].id,
207             games[gameId].rounds[games[gameId].currentRound].number
208         );
209         games[gameId].currentRound = createGameRound(gameId);
210     }
211 
212     function getBlockHash(uint i) constant returns (bytes32 blockHash) {
213         if (i > 255) {
214             i = 255;
215         }
216         blockHash = block.blockhash(block.number - i);
217     }
218 
219     function getNumber(bytes32 _a) constant returns (uint8) {
220         uint8 _b = 1;
221         uint8 mint = 0;
222         bool decimals = false;
223         for (uint i = _a.length - 1; i >= 0; i--) {
224             if ((_a[i] >= 48) && (_a[i] <= 57)) {
225                 if (decimals) {
226                     if (_b == 0) {
227                         break;
228                     } else {
229                         _b--;
230                     }
231                 }
232                 mint *= 10;
233                 mint += uint8(_a[i]) - 48;
234                 return mint;
235             } else if (_a[i] == 46) {
236                 decimals = true;
237             }
238         }
239         return mint;
240     }
241 
242     function placeBet(uint gameId, uint8 bet) public payable returns (bool) {
243         if (!games[gameId].rounds[games[gameId].currentRound].open) {
244             return false;
245         }
246 
247         if (msg.value < games[gameId].minAmountByBet) {
248             return false;
249         }
250 
251         if (games[gameId].rounds[games[gameId].currentRound].bets.length < games[gameId].maxNumberOfBets) {
252             uint id = games[gameId].rounds[games[gameId].currentRound].bets.length;
253             games[gameId].rounds[games[gameId].currentRound].bets.length += 1;
254             games[gameId].rounds[games[gameId].currentRound].bets[id].id = id;
255             games[gameId].rounds[games[gameId].currentRound].bets[id].round = games[gameId].rounds[games[gameId].currentRound].id;
256             games[gameId].rounds[games[gameId].currentRound].bets[id].bet = bet;
257             games[gameId].rounds[games[gameId].currentRound].bets[id].origin = msg.sender;
258             games[gameId].rounds[games[gameId].currentRound].bets[id].amount = msg.value;
259             BetPlaced(gameId, games[gameId].rounds[games[gameId].currentRound].id, msg.sender, id);
260         }
261 
262         if (games[gameId].rounds[games[gameId].currentRound].bets.length >= games[gameId].maxNumberOfBets) {
263             closeRound(gameId);
264         }
265 
266         return true;
267     }
268 
269     function withdraw() public returns (uint) {
270         uint amount = getBalance();
271         if (amount > 0) {
272             balances[msg.sender] = 0;
273             msg.sender.transfer(amount);
274             return amount;
275         }
276         return 0;
277     }
278 
279     function getBalance() constant returns (uint) {
280         if ((balances[msg.sender] > 0) && (balances[msg.sender] < this.balance)) {
281             return balances[msg.sender];
282         }
283         return 0;
284     }
285 
286     function numberOfClosedGames() constant returns(uint numberOfClosedGames) {
287         numberOfClosedGames = 0;
288         for (uint i = 0; i < games.length; i++) {
289             if (games[i].open != true) {
290                 numberOfClosedGames++;
291             }
292         }
293         return numberOfClosedGames;
294     }
295 
296     function getGames() constant returns(uint[] memory ids) {
297         ids = new uint[](games.length - numberOfClosedGames());
298         for (uint i = 0; i < games.length; i++) {
299             if (games[i].open == true) {
300                 ids[i] = games[i].id;
301             }
302         }
303     }
304 
305     function getGameCurrentRoundId(uint gameId) constant returns(uint) {
306         return games[gameId].currentRound;
307     }
308 
309     function getGameRoundOpen(uint gameId, uint roundId) constant returns(bool) {
310         return games[gameId].rounds[roundId].open;
311     }
312 
313     function getGameMaxNumberOfBets(uint gameId) constant returns(uint) {
314         return games[gameId].maxNumberOfBets;
315     }
316 
317     function getGameMinAmountByBet(uint gameId) constant returns(uint) {
318         return games[gameId].minAmountByBet;
319     }
320 
321     function getGamePrize(uint gameId) constant returns(uint) {
322         return games[gameId].prize;
323     }
324 
325     function getRoundNumberOfBets(uint gameId, uint roundId) constant returns(uint) {
326         return games[gameId].rounds[roundId].bets.length;
327     }
328 
329     function getRoundBetOrigin(uint gameId, uint roundId, uint betId) constant returns(address) {
330         return games[gameId].rounds[roundId].bets[betId].origin;
331     }
332 
333     function getRoundBetAmount(uint gameId, uint roundId, uint betId) constant returns(uint) {
334         return games[gameId].rounds[roundId].bets[betId].amount;
335     }
336 
337     function getRoundBetNumber(uint gameId, uint roundId, uint betId) constant returns(uint) {
338         return games[gameId].rounds[roundId].bets[betId].bet;
339     }
340 
341     function getRoundNumber(uint gameId, uint roundId) constant returns(uint8) {
342         return games[gameId].rounds[roundId].number;
343     }
344 
345     function getRoundPointer(uint gameId, uint roundId) constant returns(uint) {
346         return games[gameId].rounds[roundId].pointer;
347     }
348 
349     function getPointer(uint gameId) constant returns(uint) {
350         return games[gameId].pointer;
351     }
352 
353     function () payable {
354     }
355 }