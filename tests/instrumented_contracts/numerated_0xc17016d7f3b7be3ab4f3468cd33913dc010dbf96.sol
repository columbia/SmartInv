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
81         uint pointer;
82         uint maxNumberOfBets;
83         uint minAmountByBet;
84         uint prize;
85         uint currentRound;
86         Round[] rounds;
87     }
88 
89     struct Round {
90         uint id;
91         uint pointer;
92         bytes32 hash;
93         bool open;
94         uint8 number;
95         Bet[] bets;
96         address[] winners;
97     }
98 
99     struct Bet {
100         uint id;
101         address origin;
102         uint amount;
103         uint8 bet;
104         uint round;
105     }
106 
107     event RoundOpen(
108         uint indexed gameId,
109         uint indexed roundId
110     );
111     event RoundClose(
112         uint indexed gameId,
113         uint indexed roundId,
114         uint8 number
115     );
116     event MaxNumberOfBetsChanged(
117         uint maxNumberOfBets
118     );
119     event MinAmountByBetChanged(
120         uint minAmountByBet
121     );
122     event BetPlaced(
123         uint indexed gameId,
124         uint indexed roundId,
125         address indexed origin,
126         uint betId
127     );
128     event RoundWinner(
129         uint indexed gameId,
130         uint indexed roundId,
131         address indexed winnerAddress,
132         uint amount
133     );
134 
135     function createGame(
136         uint pointer,
137         uint maxNumberOfBets,
138         uint minAmountByBet,
139         uint prize
140     ) onlyowner returns (uint id) {
141         id = games.length;
142         games.length += 1;
143         games[id].id = id;
144         games[id].pointer = pointer;
145         games[id].maxNumberOfBets = maxNumberOfBets;
146         games[id].minAmountByBet = minAmountByBet;
147         games[id].prize = prize;
148         games[id].currentRound = createGameRound(id);
149     }
150 
151     function createGameRound(uint gameId) internal returns (uint id) {
152         id = games[gameId].rounds.length;
153         games[gameId].rounds.length += 1;
154         games[gameId].rounds[id].id = id;
155         games[gameId].rounds[id].open = true;
156         RoundOpen(gameId, id);
157     }
158 
159     function payout(uint gameId) internal {
160         address[] winners = games[gameId].rounds[games[gameId].currentRound].winners;
161         for (uint i = 0; i < games[gameId].maxNumberOfBets -1; i++) {
162             if (games[gameId].rounds[games[gameId].currentRound].bets[i].bet == games[gameId].rounds[games[gameId].currentRound].number) {
163                 uint id = winners.length;
164                 winners.length += 1;
165                 winners[id] = games[gameId].rounds[games[gameId].currentRound].bets[i].origin;
166             }
167         }
168 
169         if (winners.length > 0) {
170             uint prize = divide(games[gameId].prize, winners.length);
171             for (i = 0; i < winners.length; i++) {
172                 balances[winners[i]] = add(balances[winners[i]], prize);
173                 RoundWinner(gameId, games[gameId].currentRound, winners[i], prize);
174             }
175         }
176     }
177 
178     function closeRound(uint gameId) constant internal {
179         games[gameId].rounds[games[gameId].currentRound].open = false;
180         games[gameId].rounds[games[gameId].currentRound].hash = getBlockHash(games[gameId].pointer);
181         games[gameId].rounds[games[gameId].currentRound].number = getNumber(games[gameId].rounds[games[gameId].currentRound].hash);
182         // games[gameId].pointer = games[gameId].rounds[games[gameId].currentRound].number;
183         payout(gameId);
184         RoundClose(
185             gameId,
186             games[gameId].rounds[games[gameId].currentRound].id,
187             games[gameId].rounds[games[gameId].currentRound].number
188         );
189         games[gameId].currentRound = createGameRound(gameId);
190     }
191 
192     function getBlockHash(uint i) constant returns (bytes32 blockHash) {
193         if (i > 255) {
194             i = 255;
195         }
196         blockHash = block.blockhash(block.number - i);
197     }
198 
199     function getNumber(bytes32 _a) constant returns (uint8) {
200         uint8 _b = 1;
201         uint8 mint = 0;
202         bool decimals = false;
203         for (uint i = _a.length - 1; i >= 0; i--) {
204             if ((_a[i] >= 48) && (_a[i] <= 57)) {
205                 if (decimals) {
206                     if (_b == 0) {
207                         break;
208                     } else {
209                         _b--;
210                     }
211                 }
212                 mint *= 10;
213                 mint += uint8(_a[i]) - 48;
214                 return mint;
215             } else if (_a[i] == 46) {
216                 decimals = true;
217             }
218         }
219         return mint;
220     }
221 
222     function placeBet(uint gameId, uint8 bet) public payable returns (bool) {
223         if (!games[gameId].rounds[games[gameId].currentRound].open) {
224             return false;
225         }
226 
227         if (msg.value < games[gameId].minAmountByBet) {
228             return false;
229         }
230 
231         if (games[gameId].rounds[games[gameId].currentRound].bets.length < games[gameId].maxNumberOfBets) {
232             uint id = games[gameId].rounds[games[gameId].currentRound].bets.length;
233             games[gameId].rounds[games[gameId].currentRound].bets.length += 1;
234             games[gameId].rounds[games[gameId].currentRound].bets[id].id = id;
235             games[gameId].rounds[games[gameId].currentRound].bets[id].round = games[gameId].rounds[games[gameId].currentRound].id;
236             games[gameId].rounds[games[gameId].currentRound].bets[id].bet = bet;
237             games[gameId].rounds[games[gameId].currentRound].bets[id].origin = msg.sender;
238             games[gameId].rounds[games[gameId].currentRound].bets[id].amount = msg.value;
239             BetPlaced(gameId, games[gameId].rounds[games[gameId].currentRound].id, msg.sender, id);
240         }
241 
242         if (games[gameId].rounds[games[gameId].currentRound].bets.length >= games[gameId].maxNumberOfBets) {
243             closeRound(gameId);
244         }
245 
246         return true;
247     }
248 
249     function withdraw() public returns (uint) {
250         uint amount = getBalance();
251         if (amount > 0) {
252             balances[msg.sender] = 0;
253             msg.sender.transfer(amount);
254             return amount;
255         }
256         return 0;
257     }
258 
259     function getBalance() constant returns (uint) {
260         if ((balances[msg.sender] > 0) && (balances[msg.sender] < this.balance)) {
261             return balances[msg.sender];
262         }
263         return 0;
264     }
265 
266     function getGames() constant returns(uint[] memory ids) {
267         ids = new uint[](games.length);
268         for (uint i = 0; i < games.length; i++) {
269             ids[i] = games[i].id;
270         }
271     }
272 
273     function getGameCurrentRoundId(uint gameId) constant returns(uint) {
274         return games[gameId].currentRound;
275     }
276 
277     function getGameRoundOpen(uint gameId, uint roundId) constant returns(bool) {
278         return games[gameId].rounds[roundId].open;
279     }
280 
281     function getGameMaxNumberOfBets(uint gameId) constant returns(uint) {
282         return games[gameId].maxNumberOfBets;
283     }
284 
285     function getGameMinAmountByBet(uint gameId) constant returns(uint) {
286         return games[gameId].minAmountByBet;
287     }
288 
289     function getGamePrize(uint gameId) constant returns(uint) {
290         return games[gameId].prize;
291     }
292 
293     function getRoundNumberOfBets(uint gameId, uint roundId) constant returns(uint) {
294         return games[gameId].rounds[roundId].bets.length;
295     }
296 
297     function getRoundBetOrigin(uint gameId, uint roundId, uint betId) constant returns(address) {
298         return games[gameId].rounds[roundId].bets[betId].origin;
299     }
300 
301     function getRoundBetAmount(uint gameId, uint roundId, uint betId) constant returns(uint) {
302         return games[gameId].rounds[roundId].bets[betId].amount;
303     }
304 
305     function getRoundBetNumber(uint gameId, uint roundId, uint betId) constant returns(uint) {
306         return games[gameId].rounds[roundId].bets[betId].bet;
307     }
308 
309     function getRoundNumber(uint gameId, uint roundId) constant returns(uint8) {
310         return games[gameId].rounds[roundId].number;
311     }
312 
313     function getRoundPointer(uint gameId, uint roundId) constant returns(uint) {
314         return games[gameId].rounds[roundId].pointer;
315     }
316 
317     function getPointer(uint gameId) constant returns(uint) {
318         return games[gameId].pointer;
319     }
320 
321     function () payable {
322     }
323 }