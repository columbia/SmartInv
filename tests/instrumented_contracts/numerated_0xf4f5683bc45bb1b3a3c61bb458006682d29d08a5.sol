1 pragma solidity ^0.4.15;
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
32     uint private minBetAmount = 1;                    // minimum amount per bet
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
50 
51     event GameWin(
52         address indexed player,
53         uint indexed gameId,
54         uint8 start,
55         uint8 end,
56         uint8 number,
57         uint amount,
58         uint prize
59     );
60 
61     event GameLoose(
62         address indexed player,
63         uint indexed gameId,
64         uint8 start,
65         uint8 end,
66         uint8 number,
67         uint amount,
68         uint prize
69     );
70 
71     function notify(address player, uint gameId, uint8 start, uint8 end, uint8 number, uint amount, uint prize, bool win) internal {
72         if (win) {
73             GameWin(
74                 player,
75                 gameId,
76                 start,
77                 end,
78                 number,
79                 amount,
80                 prize
81             );
82         } else {
83             GameLoose(
84                 player,
85                 gameId,
86                 start,
87                 end,
88                 number,
89                 amount,
90                 prize
91             );
92         }
93     }
94 
95     function getBlockHash(uint i) internal constant returns (bytes32 blockHash) {
96         if (i > 255) {
97             i = 255;
98         }
99         if (i < 0) {
100             i = 1;
101         }
102         blockHash = block.blockhash(block.number - i);
103     }
104 
105     function getNumber(bytes32 _a) internal constant returns (uint8) {
106         uint8 mint = pointer;
107         for (uint i = 31; i >= 1; i--) {
108             if ((uint8(_a[i]) >= 48) && (uint8(_a[i]) <= 57)) {
109                 return uint8(_a[i]) - 48;
110             }
111         }
112         return mint;
113     }
114 
115     function placeBet(uint8 start, uint8 end) public payable returns (bool) {
116         if (msg.value < minBetAmount) {
117             return false;
118         }
119 
120         if (msg.value > maxBetAmount) {
121             return false;
122         }
123 
124         uint8 counter = end - start + 1;
125 
126         if (counter > 9) {
127             return false;
128         }
129 
130         if (counter < 1) {
131             return false;
132         }
133 
134         uint gameId = games.length;
135         games.length += 1;
136 
137         games[gameId].id = gameId;
138         games[gameId].player = msg.sender;
139         games[gameId].amount = msg.value;
140         games[gameId].start = start;
141         games[gameId].end = end;
142         games[gameId].hash = getBlockHash(pointer);
143         games[gameId].number = getNumber(games[gameId].hash);
144         pointer = games[gameId].number;
145 
146         if ((games[gameId].number >= start) && (games[gameId].number <= end)) {
147             games[gameId].win = true;
148             uint dec = msg.value / 10;
149             uint parts = 10 - counter;
150             games[gameId].prize = msg.value + dec * parts;
151         } else {
152             games[gameId].prize = 1;
153         }
154 
155         msg.sender.transfer(games[gameId].prize);
156 
157         notify(
158             msg.sender,
159             gameId,
160             start,
161             end,
162             games[gameId].number,
163             msg.value,
164             games[gameId].prize,
165             games[gameId].win
166         );
167 
168         return true;
169     }
170 
171     function setMinBetAmount(uint _minBetAmount) onlyowner returns (uint) {
172         minBetAmount = _minBetAmount;
173         MinBetAmountChanged(minBetAmount);
174         return minBetAmount;
175     }
176 
177     function setMaxBetAmount(uint _maxBetAmount) onlyowner returns (uint) {
178         maxBetAmount = _maxBetAmount;
179         MaxBetAmountChanged(maxBetAmount);
180         return maxBetAmount;
181     }
182 
183     function getGameIds() constant returns(uint[]) {
184         uint[] memory ids = new uint[](games.length);
185         for (uint i = 0; i < games.length; i++) {
186             ids[i] = games[i].id;
187         }
188         return ids;
189     }
190 
191     function getGamePlayer(uint gameId) constant returns(address) {
192         return games[gameId].player;
193     }
194 
195     function getGameAmount(uint gameId) constant returns(uint) {
196         return games[gameId].amount;
197     }
198 
199     function getGameStart(uint gameId) constant returns(uint8) {
200         return games[gameId].start;
201     }
202 
203     function getGameEnd(uint gameId) constant returns(uint8) {
204         return games[gameId].end;
205     }
206 
207     function getGameHash(uint gameId) constant returns(bytes32) {
208         return games[gameId].hash;
209     }
210 
211     function getGameNumber(uint gameId) constant returns(uint8) {
212         return games[gameId].number;
213     }
214 
215     function getGameWin(uint gameId) constant returns(bool) {
216         return games[gameId].win;
217     }
218 
219     function getGamePrize(uint gameId) constant returns(uint) {
220         return games[gameId].prize;
221     }
222 
223     function getMinBetAmount() constant returns(uint) {
224         return minBetAmount;
225     }
226 
227     function getMaxBetAmount() constant returns(uint) {
228         return maxBetAmount;
229     }
230 
231     function () payable {
232     }
233 }