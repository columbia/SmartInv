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
156         pointer = games[gameId].number;
157 
158         if ((games[gameId].number >= start) && (games[gameId].number <= end)) {
159             games[gameId].win = true;
160             uint dec = msg.value / 10;
161             uint parts = 10 - counter;
162             games[gameId].prize = msg.value + dec * parts;
163         } else {
164             games[gameId].prize = 1;
165         }
166 
167         msg.sender.transfer(games[gameId].prize);
168 
169         notify(
170             msg.sender,
171             gameId,
172             start,
173             end,
174             games[gameId].number,
175             msg.value,
176             games[gameId].prize,
177             games[gameId].win
178         );
179 
180         return true;
181     }
182 
183     function withdraw(uint amount) onlyowner returns (uint) {
184         if (amount <= this.balance) {
185             msg.sender.transfer(amount);
186             return amount;
187         }
188         return 0;
189     }
190 
191     function setMinBetAmount(uint _minBetAmount) onlyowner returns (uint) {
192         minBetAmount = _minBetAmount;
193         MinBetAmountChanged(minBetAmount);
194         return minBetAmount;
195     }
196 
197     function setMaxBetAmount(uint _maxBetAmount) onlyowner returns (uint) {
198         maxBetAmount = _maxBetAmount;
199         MaxBetAmountChanged(maxBetAmount);
200         return maxBetAmount;
201     }
202 
203     function setPointer(uint8 _pointer) onlyowner returns (uint) {
204         pointer = _pointer;
205         PointerChanged(pointer);
206         return pointer;
207     }
208 
209     function getGameIds() constant returns(uint[]) {
210         uint[] memory ids = new uint[](games.length);
211         for (uint i = 0; i < games.length; i++) {
212             ids[i] = games[i].id;
213         }
214         return ids;
215     }
216 
217     function getGamePlayer(uint gameId) constant returns(address) {
218         return games[gameId].player;
219     }
220 
221     function getGameAmount(uint gameId) constant returns(uint) {
222         return games[gameId].amount;
223     }
224 
225     function getGameStart(uint gameId) constant returns(uint8) {
226         return games[gameId].start;
227     }
228 
229     function getGameEnd(uint gameId) constant returns(uint8) {
230         return games[gameId].end;
231     }
232 
233     function getGameHash(uint gameId) constant returns(bytes32) {
234         return games[gameId].hash;
235     }
236 
237     function getGameNumber(uint gameId) constant returns(uint8) {
238         return games[gameId].number;
239     }
240 
241     function getGameWin(uint gameId) constant returns(bool) {
242         return games[gameId].win;
243     }
244 
245     function getGamePrize(uint gameId) constant returns(uint) {
246         return games[gameId].prize;
247     }
248 
249     function getMinBetAmount() constant returns(uint) {
250         return minBetAmount;
251     }
252 
253     function getMaxBetAmount() constant returns(uint) {
254         return maxBetAmount;
255     }
256 
257     function () payable {
258     }
259 }