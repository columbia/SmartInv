1 pragma solidity ^0.4.19;
2 
3 
4 contract Owned {
5     address owner;
6 
7     modifier onlyowner() {
8         if (msg.sender == owner) {
9             _;
10         }
11     }
12 
13     function Owned() internal {
14         owner = msg.sender;
15     }
16 }
17 
18 
19 contract Mortal is Owned {
20     function kill() public onlyowner {
21         selfdestruct(owner);
22     }
23 }
24 
25 
26 contract Slotthereum is Mortal {
27 
28     modifier onlyuser() {
29         if (tx.origin == msg.sender) {
30             _;
31         } else {
32             revert();
33         }
34     }
35 
36     Game[] public games;                                // games
37     mapping (address => uint) private balances;         // balances per address
38     uint public numberOfGames = 0;                      // number of games
39     uint private minBetAmount = 100000000000000;        // minimum amount per bet
40     uint private maxBetAmount = 1000000000000000000;    // maximum amount per bet
41     bytes32 private seed;
42     uint private nonce = 1;
43 
44     struct Game {
45         address player;
46         uint id;
47         uint amount;
48         uint8 start;
49         uint8 end;
50         uint8 number;
51         bool win;
52         uint prize;
53         bytes32 hash;
54         uint blockNumber;
55     }
56 
57     event MinBetAmountChanged(uint amount);
58     event MaxBetAmountChanged(uint amount);
59 
60     event GameRoll(
61         address indexed player,
62         uint indexed gameId,
63         uint8 start,
64         uint8 end,
65         uint amount
66     );
67 
68     event GameWin(
69         address indexed player,
70         uint indexed gameId,
71         uint8 start,
72         uint8 end,
73         uint8 number,
74         uint amount,
75         uint prize
76     );
77 
78     event GameLoose(
79         address indexed player,
80         uint indexed gameId,
81         uint8 start,
82         uint8 end,
83         uint8 number,
84         uint amount,
85         uint prize
86     );
87 
88     // function assert(bool assertion) internal {
89     //     if (!assertion) {
90     //         revert();
91     //     }
92     // }
93 
94     // function add(uint x, uint y) internal constant returns (uint z) {
95     //     assert((z = x + y) >= x);
96     // }
97 
98     function getNumber(bytes32 hash) onlyuser internal returns (uint8) {
99         nonce++;
100         seed = keccak256(block.timestamp, nonce);
101         return uint8(keccak256(hash, seed))%(0+9)-0;
102     }
103 
104     function notify(address player, uint gameId, uint8 start, uint8 end, uint8 number, uint amount, uint prize, bool win) internal {
105         if (win) {
106             GameWin(
107                 player,
108                 gameId,
109                 start,
110                 end,
111                 number,
112                 amount,
113                 prize
114             );
115         } else {
116             GameLoose(
117                 player,
118                 gameId,
119                 start,
120                 end,
121                 number,
122                 amount,
123                 prize
124             );
125         }
126     }
127 
128     function placeBet(uint8 start, uint8 end) onlyuser public payable returns (bool) {
129         if (msg.value < minBetAmount) {
130             return false;
131         }
132 
133         if (msg.value > maxBetAmount) {
134             return false;
135         }
136 
137         uint8 counter = end - start + 1;
138 
139         if (counter > 7) {
140             return false;
141         }
142 
143         if (counter < 1) {
144             return false;
145         }
146 
147         uint gameId = games.length;
148         games.length++;
149         numberOfGames++;
150 
151         GameRoll(msg.sender, gameId, start, end, msg.value);
152 
153         games[gameId].id = gameId;
154         games[gameId].player = msg.sender;
155         games[gameId].amount = msg.value;
156         games[gameId].start = start;
157         games[gameId].end = end;
158         games[gameId].prize = 1;
159         games[gameId].hash = 0x0;
160         games[gameId].blockNumber = block.number;
161 
162         if (gameId > 0) {
163             uint lastGameId = gameId - 1;
164             if (games[lastGameId].blockNumber != games[gameId].blockNumber) {
165                 games[lastGameId].hash = block.blockhash(block.number - 1);
166                 games[lastGameId].number = getNumber(games[lastGameId].hash);
167 
168                 if ((games[lastGameId].number >= games[lastGameId].start) && (games[lastGameId].number <= games[lastGameId].end)) {
169                     games[lastGameId].win = true;
170                     uint dec = games[lastGameId].amount / 10;
171                     uint parts = 10 - counter;
172                     games[lastGameId].prize = games[lastGameId].amount + dec * parts;
173                 }
174 
175                 games[lastGameId].player.transfer(games[lastGameId].prize);
176                 // balances[games[lastGameId].player] = add(balances[games[lastGameId].player], games[lastGameId].prize);
177 
178                 notify(
179                     games[lastGameId].player,
180                     lastGameId,
181                     games[lastGameId].start,
182                     games[lastGameId].end,
183                     games[lastGameId].number,
184                     games[lastGameId].amount,
185                     games[lastGameId].prize,
186                     games[lastGameId].win
187                 );
188 
189                 return true;
190             }
191             else {
192                 return false;
193             }
194         }
195     }
196 
197     function getBalance() public constant returns (uint) {
198         if ((balances[msg.sender] > 0) && (balances[msg.sender] < this.balance)) {
199             return balances[msg.sender];
200         }
201         return 0;
202     }
203 
204     // function withdraw() onlyuser public returns (uint) {
205     //     uint amount = getBalance();
206     //     if (amount > 0) {
207     //         balances[msg.sender] = 0;
208     //         msg.sender.transfer(amount);
209     //         return amount;
210     //     }
211     //     return 0;
212     // }
213 
214     function ownerWithdraw(uint amount) onlyowner public returns (uint) {
215         if (amount <= this.balance) {
216             msg.sender.transfer(amount);
217             return amount;
218         }
219         return 0;
220     }
221 
222     function setMinBetAmount(uint _minBetAmount) onlyowner public returns (uint) {
223         minBetAmount = _minBetAmount;
224         MinBetAmountChanged(minBetAmount);
225         return minBetAmount;
226     }
227 
228     function setMaxBetAmount(uint _maxBetAmount) onlyowner public returns (uint) {
229         maxBetAmount = _maxBetAmount;
230         MaxBetAmountChanged(maxBetAmount);
231         return maxBetAmount;
232     }
233 
234     function getGameIds() public constant returns(uint[]) {
235         uint[] memory ids = new uint[](games.length);
236         for (uint i = 0; i < games.length; i++) {
237             ids[i] = games[i].id;
238         }
239         return ids;
240     }
241 
242     function getGamePlayer(uint gameId) public constant returns(address) {
243         return games[gameId].player;
244     }
245 
246     function getGameHash(uint gameId) public constant returns(bytes32) {
247         return games[gameId].hash;
248     }
249 
250     function getGameBlockNumber(uint gameId) public constant returns(uint) {
251         return games[gameId].blockNumber;
252     }
253 
254     function getGameAmount(uint gameId) public constant returns(uint) {
255         return games[gameId].amount;
256     }
257 
258     function getGameStart(uint gameId) public constant returns(uint8) {
259         return games[gameId].start;
260     }
261 
262     function getGameEnd(uint gameId) public constant returns(uint8) {
263         return games[gameId].end;
264     }
265 
266     function getGameNumber(uint gameId) public constant returns(uint8) {
267         return games[gameId].number;
268     }
269 
270     function getGameWin(uint gameId) public constant returns(bool) {
271         return games[gameId].win;
272     }
273 
274     function getGamePrize(uint gameId) public constant returns(uint) {
275         return games[gameId].prize;
276     }
277 
278     function getMinBetAmount() public constant returns(uint) {
279         return minBetAmount;
280     }
281 
282     function getMaxBetAmount() public constant returns(uint) {
283         return maxBetAmount;
284     }
285 
286     function () public payable {
287     }
288 }