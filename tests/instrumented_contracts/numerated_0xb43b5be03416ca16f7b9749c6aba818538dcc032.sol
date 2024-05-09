1 pragma solidity ^0.4.16;
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
13     function Owned() {
14         owner = msg.sender;
15     }
16 }
17 
18 
19 contract Mortal is Owned {
20     
21     function kill() {
22         if (msg.sender == owner)
23             selfdestruct(owner);
24     }
25 }
26 
27 
28 contract Slotthereum is Mortal {
29 
30     Game[] public games;                              // games
31     uint public numberOfGames = 0;                    // number of games
32     uint private minBetAmount = 100000000000000;      // minimum amount per bet
33     uint private maxBetAmount = 1000000000000000000;  // maximum amount per bet
34     uint8 private pointer = 1;                        // block pointer
35 
36     struct Game {
37         address player;
38         uint id;
39         uint amount;
40         uint8 start;
41         uint8 end;
42         bytes32 hash;
43         uint8 number;
44         bool win;
45         uint prize;
46     }
47 
48     event MinBetAmountChanged(uint amount);
49     event MaxBetAmountChanged(uint amount);
50     event PointerChanged(uint8 value);
51 
52     event GameRoll(
53         address indexed player,
54         uint indexed gameId,
55         uint8 start,
56         uint8 end,
57         uint amount
58     );
59 
60     event GameWin(
61         address indexed player,
62         uint indexed gameId,
63         uint8 start,
64         uint8 end,
65         uint8 number,
66         uint amount,
67         uint prize
68     );
69 
70     event GameLoose(
71         address indexed player,
72         uint indexed gameId,
73         uint8 start,
74         uint8 end,
75         uint8 number,
76         uint amount,
77         uint prize
78     );
79 
80     function notify(address player, uint gameId, uint8 start, uint8 end, uint8 number, uint amount, uint prize, bool win) internal {
81         if (win) {
82             GameWin(
83                 player,
84                 gameId,
85                 start,
86                 end,
87                 number,
88                 amount,
89                 prize
90             );
91         } else {
92             GameLoose(
93                 player,
94                 gameId,
95                 start,
96                 end,
97                 number,
98                 amount,
99                 prize
100             );
101         }
102     }
103 
104     function getBlockHash(uint i) internal constant returns (bytes32 blockHash) {
105         if (i >= 255) {
106             i = 255;
107         }
108         if (i <= 0) {
109             i = 1;
110         }
111         blockHash = block.blockhash(block.number - i);
112     }
113 
114     function getNumber(bytes32 _a) internal constant returns (uint8) {
115         uint8 mint = pointer;
116         for (uint i = 31; i >= 1; i--) {
117             if ((uint8(_a[i]) >= 48) && (uint8(_a[i]) <= 57)) {
118                 return uint8(_a[i]) - 48;
119             }
120         }
121         return mint;
122     }
123 
124     function placeBet(uint8 start, uint8 end) public payable returns (bool) {
125         if (msg.value < minBetAmount) {
126             return false;
127         }
128 
129         if (msg.value > maxBetAmount) {
130             return false;
131         }
132 
133         uint8 counter = end - start + 1;
134 
135         if (counter > 7) {
136             return false;
137         }
138 
139         if (counter < 1) {
140             return false;
141         }
142 
143         uint gameId = games.length;
144         games.length++;
145         numberOfGames++;
146 
147         GameRoll(msg.sender, gameId, start, end, msg.value);
148 
149         games[gameId].id = gameId;
150         games[gameId].player = msg.sender;
151         games[gameId].amount = msg.value;
152         games[gameId].start = start;
153         games[gameId].end = end;
154         games[gameId].hash = getBlockHash(pointer);
155         games[gameId].number = getNumber(games[gameId].hash);
156         
157         if (pointer == games[gameId].number) {
158             if (pointer <= 4) {
159                 pointer++;
160             } else {
161                 pointer--;
162             }
163         } else {
164             pointer = games[gameId].number;
165         }
166 
167         if ((games[gameId].number >= start) && (games[gameId].number <= end)) {
168             games[gameId].win = true;
169             uint dec = msg.value / 10;
170             uint parts = 10 - counter;
171             games[gameId].prize = msg.value + dec * parts;
172         } else {
173             games[gameId].prize = 1;
174         }
175 
176         msg.sender.transfer(games[gameId].prize);
177 
178         notify(
179             msg.sender,
180             gameId,
181             start,
182             end,
183             games[gameId].number,
184             msg.value,
185             games[gameId].prize,
186             games[gameId].win
187         );
188 
189         return true;
190     }
191 
192     function withdraw(uint amount) onlyowner returns (uint) {
193         if (amount <= this.balance) {
194             msg.sender.transfer(amount);
195             return amount;
196         }
197         return 0;
198     }
199 
200     function setMinBetAmount(uint _minBetAmount) onlyowner returns (uint) {
201         minBetAmount = _minBetAmount;
202         MinBetAmountChanged(minBetAmount);
203         return minBetAmount;
204     }
205 
206     function setMaxBetAmount(uint _maxBetAmount) onlyowner returns (uint) {
207         maxBetAmount = _maxBetAmount;
208         MaxBetAmountChanged(maxBetAmount);
209         return maxBetAmount;
210     }
211 
212     function setPointer(uint8 _pointer) onlyowner returns (uint) {
213         pointer = _pointer;
214         PointerChanged(pointer);
215         return pointer;
216     }
217 
218     function getGameIds() constant returns(uint[]) {
219         uint[] memory ids = new uint[](games.length);
220         for (uint i = 0; i < games.length; i++) {
221             ids[i] = games[i].id;
222         }
223         return ids;
224     }
225 
226     function getGamePlayer(uint gameId) constant returns(address) {
227         return games[gameId].player;
228     }
229 
230     function getGameAmount(uint gameId) constant returns(uint) {
231         return games[gameId].amount;
232     }
233 
234     function getGameStart(uint gameId) constant returns(uint8) {
235         return games[gameId].start;
236     }
237 
238     function getGameEnd(uint gameId) constant returns(uint8) {
239         return games[gameId].end;
240     }
241 
242     function getGameHash(uint gameId) constant returns(bytes32) {
243         return games[gameId].hash;
244     }
245 
246     function getGameNumber(uint gameId) constant returns(uint8) {
247         return games[gameId].number;
248     }
249 
250     function getGameWin(uint gameId) constant returns(bool) {
251         return games[gameId].win;
252     }
253 
254     function getGamePrize(uint gameId) constant returns(uint) {
255         return games[gameId].prize;
256     }
257 
258     function getMinBetAmount() constant returns(uint) {
259         return minBetAmount;
260     }
261 
262     function getMaxBetAmount() constant returns(uint) {
263         return maxBetAmount;
264     }
265 
266     function () payable {
267     }
268 }