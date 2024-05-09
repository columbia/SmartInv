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
33     uint private maxBetAmount = 5000000000000000000;  // maximum amount per bet
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
105         if (i > 255) {
106             i = 255;
107         }
108         if (i < 0) {
109             i = 1;
110         }
111         blockHash = block.blockhash(block.number - i);
112     }
113 
114     function getNumber(bytes32 _a) internal constant returns (uint8) {
115         // uint8 mint = pointer;
116         uint8 mint = 0;
117         for (uint i = 31; i >= 1; i--) {
118             if ((uint8(_a[i]) >= 48) && (uint8(_a[i]) <= 57)) {
119                 return uint8(_a[i]) - 48;
120             }
121         }
122         return mint;
123     }
124 
125     function placeBet(uint8 start, uint8 end) public payable returns (bool) {
126         if (msg.value < minBetAmount) {
127             return false;
128         }
129 
130         if (msg.value > maxBetAmount) {
131             return false;
132         }
133 
134         uint8 counter = end - start + 1;
135 
136         if (counter > 9) {
137             return false;
138         }
139 
140         if (counter < 1) {
141             return false;
142         }
143 
144         uint gameId = games.length;
145         games.length++;
146         numberOfGames++;
147 
148         GameRoll(msg.sender, gameId, start, end, msg.value);
149 
150         games[gameId].id = gameId;
151         games[gameId].player = msg.sender;
152         games[gameId].amount = msg.value;
153         games[gameId].start = start;
154         games[gameId].end = end;
155         games[gameId].hash = getBlockHash(pointer);
156         games[gameId].number = getNumber(games[gameId].hash);
157         // pointer = games[gameId].number;
158 
159         if ((games[gameId].number >= start) && (games[gameId].number <= end)) {
160             games[gameId].win = true;
161             uint dec = msg.value / 10;
162             uint parts = 10 - counter;
163             games[gameId].prize = msg.value + dec * parts;
164         } else {
165             games[gameId].prize = 1;
166         }
167 
168         msg.sender.transfer(games[gameId].prize);
169 
170         notify(
171             msg.sender,
172             gameId,
173             start,
174             end,
175             games[gameId].number,
176             msg.value,
177             games[gameId].prize,
178             games[gameId].win
179         );
180 
181         return true;
182     }
183 
184     function setMinBetAmount(uint _minBetAmount) onlyowner returns (uint) {
185         minBetAmount = _minBetAmount;
186         MinBetAmountChanged(minBetAmount);
187         return minBetAmount;
188     }
189 
190     function setMaxBetAmount(uint _maxBetAmount) onlyowner returns (uint) {
191         maxBetAmount = _maxBetAmount;
192         MaxBetAmountChanged(maxBetAmount);
193         return maxBetAmount;
194     }
195 
196     function setPointer(uint8 _pointer) onlyowner returns (uint) {
197         pointer = _pointer;
198         PointerChanged(pointer);
199         return pointer;
200     }
201 
202     function getGameIds() constant returns(uint[]) {
203         uint[] memory ids = new uint[](games.length);
204         for (uint i = 0; i < games.length; i++) {
205             ids[i] = games[i].id;
206         }
207         return ids;
208     }
209 
210     function getGamePlayer(uint gameId) constant returns(address) {
211         return games[gameId].player;
212     }
213 
214     function getGameAmount(uint gameId) constant returns(uint) {
215         return games[gameId].amount;
216     }
217 
218     function getGameStart(uint gameId) constant returns(uint8) {
219         return games[gameId].start;
220     }
221 
222     function getGameEnd(uint gameId) constant returns(uint8) {
223         return games[gameId].end;
224     }
225 
226     function getGameHash(uint gameId) constant returns(bytes32) {
227         return games[gameId].hash;
228     }
229 
230     function getGameNumber(uint gameId) constant returns(uint8) {
231         return games[gameId].number;
232     }
233 
234     function getGameWin(uint gameId) constant returns(bool) {
235         return games[gameId].win;
236     }
237 
238     function getGamePrize(uint gameId) constant returns(uint) {
239         return games[gameId].prize;
240     }
241 
242     function getMinBetAmount() constant returns(uint) {
243         return minBetAmount;
244     }
245 
246     function getMaxBetAmount() constant returns(uint) {
247         return maxBetAmount;
248     }
249 
250     function () payable {
251     }
252 }