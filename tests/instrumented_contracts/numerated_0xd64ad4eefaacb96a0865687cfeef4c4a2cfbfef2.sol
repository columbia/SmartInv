1 pragma solidity ^0.4.11;
2 
3 contract SafeMath {
4     function add(uint x, uint y) internal constant returns (uint z) {
5         assert((z = x + y) >= x);
6     }
7  
8     function subtract(uint x, uint y) internal constant returns (uint z) {
9         assert((z = x - y) <= x);
10     }
11 
12     function multiply(uint x, uint y) internal constant returns (uint z) {
13         z = x * y;
14         assert(x == 0 || z / x == y);
15         return z;
16     }
17 
18     function divide(uint x, uint y) internal constant returns (uint z) {
19         z = x / y;
20         assert(x == ( (y * z) + (x % y) ));
21         return z;
22     }
23     
24     function min64(uint64 x, uint64 y) internal constant returns (uint64) {
25         return x < y ? x: y;
26     }
27     
28     function max64(uint64 x, uint64 y) internal constant returns (uint64) {
29         return x >= y ? x : y;
30     }
31 
32     function min(uint x, uint y) internal constant returns (uint) {
33         return (x <= y) ? x : y;
34     }
35 
36     function max(uint x, uint y) internal constant returns (uint) {
37         return (x >= y) ? x : y;
38     }
39 
40     function assert(bool assertion) internal {
41         if (!assertion) {
42             revert();
43         }
44     }
45 }
46 
47 
48 contract Owned {
49     address owner;
50 
51     modifier onlyowner() {
52         if (msg.sender == owner) {
53             _;
54         }
55     }
56 
57     function Owned() {
58         owner = msg.sender;
59     }
60 }
61 
62 
63 contract Mortal is Owned {
64     
65     function kill() {
66         if (msg.sender == owner)
67             selfdestruct(owner);
68     }
69 }
70 
71 
72 contract Lotthereum is Mortal, SafeMath {
73     Game[] private games;
74     mapping (address => uint) private balances;  // balances per address
75 
76     struct Game {
77         uint id;
78         uint pointer;
79         uint maxNumberOfBets;
80         uint minAmountByBet;
81         uint prize;
82         uint currentRound;
83         Round[] rounds;
84     }
85 
86     struct Round {
87         uint id;
88         uint pointer;
89         bytes32 hash;
90         bool open;
91         uint8 number;
92         Bet[] bets;
93         address[] winners;
94     }
95 
96     struct Bet {
97         uint id;
98         address origin;
99         uint amount;
100         uint8 bet;
101         uint round;
102     }
103 
104     event RoundOpen(
105         uint indexed gameId,
106         uint indexed roundId
107     );
108     event RoundClose(
109         uint indexed gameId,
110         uint indexed roundId,
111         uint8 number
112     );
113     event MaxNumberOfBetsChanged(
114         uint maxNumberOfBets
115     );
116     event MinAmountByBetChanged(
117         uint minAmountByBet
118     );
119     event BetPlaced(
120         uint indexed gameId,
121         uint indexed roundId,
122         address indexed origin,
123         uint betId
124     );
125     event RoundWinner(
126         uint indexed gameId,
127         uint indexed roundId,
128         address indexed winnerAddress,
129         uint amount
130     );
131 
132     function createGame(
133         uint pointer,
134         uint maxNumberOfBets,
135         uint minAmountByBet,
136         uint prize
137     ) onlyowner returns (uint id) {
138         id = games.length;
139         games.length += 1;
140         games[id].id = id;
141         games[id].pointer = pointer;
142         games[id].maxNumberOfBets = maxNumberOfBets;
143         games[id].minAmountByBet = minAmountByBet;
144         games[id].prize = prize;
145         games[id].currentRound = createGameRound(id);
146     }
147 
148     function createGameRound(uint gameId) internal returns (uint id) {
149         Game game = games[gameId];
150         id = games[gameId].rounds.length;
151         game.rounds.length += 1;
152         game.rounds[id].id = id;
153         game.rounds[id].open = true;
154         RoundOpen(gameId, id);
155     }
156 
157     function payout(uint gameId) internal {
158         Game game = games[gameId];
159         Round round = game.rounds[game.currentRound];
160         Bet[] bets = round.bets;
161         address[] winners = round.winners;
162         for (uint i = 0; i < bets.length; i++) {
163             if (bets[i].bet == round.number) {
164                 uint id = winners.length;
165                 winners.length += 1;
166                 winners[id] = bets[i].origin;
167             }
168         }
169 
170         if (winners.length > 0) {
171             uint prize = divide(game.prize, winners.length);
172             for (i = 0; i < winners.length; i++) {
173                 balances[winners[i]] = add(balances[winners[i]], prize);
174                 RoundWinner(game.id, game.currentRound, winners[i], prize);
175             }
176         }
177     }
178 
179     function closeRound(uint gameId) constant internal {
180         Game game = games[gameId];
181         Round round = game.rounds[game.currentRound];
182         round.open = false;
183         round.hash = getBlockHash(game.pointer);
184         round.number = getNumber(game.rounds[game.currentRound].hash);
185         game.pointer = game.rounds[game.currentRound].number;
186         payout(gameId);
187         RoundClose(game.id, round.id, round.number);
188         game.currentRound = createGameRound(game.id);
189     }
190 
191     function getBlockHash(uint i) constant returns (bytes32 blockHash) {
192         if (i > 255) {
193             i = 255;
194         }
195         uint blockNumber = block.number - i;
196         blockHash = block.blockhash(blockNumber);
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
223         Game game = games[gameId];
224         Round round = game.rounds[game.currentRound];
225         Bet[] bets = round.bets;
226 
227         if (!round.open) {
228             return false;
229         }
230 
231         if (msg.value < game.minAmountByBet) {
232             return false;
233         }
234 
235         uint id = bets.length;
236         bets.length += 1;
237         bets[id].id = id;
238         bets[id].round = round.id;
239         bets[id].bet = bet;
240         bets[id].origin = msg.sender;
241         bets[id].amount = msg.value;
242         BetPlaced(game.id, round.id, msg.sender, id);
243 
244         if (bets.length == game.maxNumberOfBets) {
245             closeRound(game.id);
246         }
247 
248         return true;
249     }
250 
251     function withdraw() public returns (uint) {
252         uint amount = getBalance();
253         if (amount > 0) {
254             balances[msg.sender] = 0;
255             msg.sender.transfer(amount);
256             return amount;
257         }
258         return 0;
259     }
260 
261     function getBalance() constant returns (uint) {
262         uint amount = balances[msg.sender];
263         if ((amount > 0) && (amount < this.balance)) {
264             return amount;
265         }
266         return 0;
267     }
268 
269     function getGames() constant returns(uint[] memory ids) {
270         ids = new uint[](games.length);
271         for (uint i = 0; i < games.length; i++) {
272             ids[i] = games[i].id;
273         }
274     }
275 
276     function getGameCurrentRoundId(uint gameId) constant returns(uint) {
277         return games[gameId].currentRound;
278     }
279 
280     function getGameRoundOpen(uint gameId, uint roundId) constant returns(bool) {
281         return games[gameId].rounds[roundId].open;
282     }
283 
284     function getGameMaxNumberOfBets(uint gameId) constant returns(uint) {
285         return games[gameId].maxNumberOfBets;
286     }
287 
288     function getGameMinAmountByBet(uint gameId) constant returns(uint) {
289         return games[gameId].minAmountByBet;
290     }
291 
292     function getGamePrize(uint gameId) constant returns(uint) {
293         return games[gameId].prize;
294     }
295 
296     function getRoundNumberOfBets(uint gameId, uint roundId) constant returns(uint) {
297         return games[gameId].rounds[roundId].bets.length;
298     }
299 
300     function getRoundBetOrigin(uint gameId, uint roundId, uint betId) constant returns(address) {
301         return games[gameId].rounds[roundId].bets[betId].origin;
302     }
303 
304     function getRoundBetAmount(uint gameId, uint roundId, uint betId) constant returns(uint) {
305         return games[gameId].rounds[roundId].bets[betId].amount;
306     }
307 
308     function getRoundBetNumber(uint gameId, uint roundId, uint betId) constant returns(uint) {
309         return games[gameId].rounds[roundId].bets[betId].bet;
310     }
311 
312     function getRoundNumber(uint gameId, uint roundId) constant returns(uint8) {
313         return games[gameId].rounds[roundId].number;
314     }
315 
316     function getRoundPointer(uint gameId, uint roundId) constant returns(uint) {
317         return games[gameId].rounds[roundId].pointer;
318     }
319 
320     function getPointer(uint gameId) constant returns(uint) {
321         return games[gameId].pointer;
322     }
323 
324     function () payable {
325     }
326 }