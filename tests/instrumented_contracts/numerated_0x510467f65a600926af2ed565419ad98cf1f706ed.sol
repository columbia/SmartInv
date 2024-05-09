1 pragma solidity ^0.4.15;
2 
3 contract Owned {
4     address owner;
5 
6     modifier onlyowner() {
7         if (msg.sender == owner) {
8             _;
9         }
10     }
11 
12     function Owned() {
13         owner = msg.sender;
14     }
15 }
16 
17 
18 contract Mortal is Owned {
19     
20     function kill() {
21         if (msg.sender == owner)
22             selfdestruct(owner);
23     }
24 }
25 
26 
27 contract Slotthereum is Mortal {
28 
29     mapping (address => Game[]) private games;      // games per address
30 
31     uint private minBetAmount = 10000000000000000;  // minimum amount per bet
32     uint private maxBetAmount = 5000000000000000000;  // maximum amount per bet
33     uint private pointer = 1;                       // block pointer
34     uint private numberOfPlayers = 0;               // number of players
35 
36     struct Game {
37         uint id;
38         uint amount;
39         uint8 start;
40         uint8 end;
41         bytes32 hash;
42         uint8 number;
43         bool win;
44         uint prize;
45     }
46 
47     event MinBetAmountChanged(uint amount);
48     event MaxBetAmountChanged(uint amount);
49 
50     event GameWin(
51         address indexed player,
52         uint indexed gameId,
53         uint8 start,
54         uint8 end,
55         uint8 number,
56         uint amount,
57         uint prize
58     );
59 
60     event GameLoose(
61         address indexed player,
62         uint indexed gameId,
63         uint8 start,
64         uint8 end,
65         uint8 number,
66         uint amount,
67         uint prize
68     );
69 
70     function notify(address player, uint gameId, uint8 start, uint8 end, uint8 number, uint amount, uint prize, bool win) internal {
71         if (win) {
72             GameWin(
73                 player,
74                 gameId,
75                 start,
76                 end,
77                 number,
78                 amount,
79                 prize
80             );
81         } else {
82             GameLoose(
83                 player,
84                 gameId,
85                 start,
86                 end,
87                 number,
88                 amount,
89                 prize
90             );
91         }
92     }
93 
94     function getBlockHash(uint i) internal constant returns (bytes32 blockHash) {
95         if (i > 255) {
96             i = 255;
97         }
98         if (i < 0) {
99             i = 1;
100         }
101         blockHash = block.blockhash(block.number - i);
102     }
103 
104     function getNumber(bytes32 _a) internal constant returns (uint8) {
105         uint8 mint = 0; // pointer?
106         for (uint i = 31; i >= 1; i--) {
107             if ((uint8(_a[i]) >= 48) && (uint8(_a[i]) <= 57)) {
108                 return uint8(_a[i]) - 48;
109             }
110         }
111         return mint;
112     }
113 
114     function placeBet(uint8 start, uint8 end) public payable returns (bool) {
115         if (msg.value < minBetAmount) {
116             return false;
117         }
118 
119         if (msg.value > maxBetAmount) {
120             return false;
121         }
122 
123         uint8 counter = end - start + 1;
124 
125         if (counter > 9) {
126             return false;
127         }
128 
129         if (counter < 1) {
130             return false;
131         }
132 
133         uint gameId = games[msg.sender].length;
134         games[msg.sender].length += 1;
135         games[msg.sender][gameId].id = gameId;
136         games[msg.sender][gameId].amount = msg.value;
137         games[msg.sender][gameId].start = start;
138         games[msg.sender][gameId].end = end;
139         games[msg.sender][gameId].hash = getBlockHash(pointer);
140         games[msg.sender][gameId].number = getNumber(games[msg.sender][gameId].hash);
141         // set pointer to number ?
142 
143         games[msg.sender][gameId].prize = 1;
144         if ((games[msg.sender][gameId].number >= start) && (games[msg.sender][gameId].number <= end)) {
145             games[msg.sender][gameId].win = true;
146             uint dec = msg.value / 10;
147             uint parts = 10 - counter;
148             games[msg.sender][gameId].prize = msg.value + dec * parts;
149         }
150 
151         msg.sender.transfer(games[msg.sender][gameId].prize);
152 
153         notify(
154             msg.sender,
155             gameId,
156             start,
157             end,
158             games[msg.sender][gameId].number,
159             msg.value,
160             games[msg.sender][gameId].prize,
161             games[msg.sender][gameId].win
162         );
163 
164         return true;
165     }
166 
167     function setMinBetAmount(uint _minBetAmount) onlyowner returns (uint) {
168         minBetAmount = _minBetAmount;
169         MinBetAmountChanged(minBetAmount);
170         return minBetAmount;
171     }
172 
173     function setMaxBetAmount(uint _maxBetAmount) onlyowner returns (uint) {
174         maxBetAmount = _maxBetAmount;
175         MaxBetAmountChanged(maxBetAmount);
176         return maxBetAmount;
177     }
178 
179     function getGameIds(address player) constant returns(uint[] memory ids) {
180         ids = new uint[](games[player].length);
181         for (uint i = 0; i < games[player].length; i++) {
182             ids[i] = games[player][i].id;
183         }
184     }
185 
186     function getGameAmount(address player, uint gameId) constant returns(uint) {
187         return games[player][gameId].amount;
188     }
189 
190     function getGameStart(address player, uint gameId) constant returns(uint8) {
191         return games[player][gameId].start;
192     }
193 
194     function getGameEnd(address player, uint gameId) constant returns(uint8) {
195         return games[player][gameId].end;
196     }
197 
198     function getGameHash(address player, uint gameId) constant returns(bytes32) {
199         return games[player][gameId].hash;
200     }
201 
202     function getGameNumber(address player, uint gameId) constant returns(uint8) {
203         return games[player][gameId].number;
204     }
205 
206     function getGameWin(address player, uint gameId) constant returns(bool) {
207         return games[player][gameId].win;
208     }
209 
210     function getGamePrize(address player, uint gameId) constant returns(uint) {
211         return games[player][gameId].prize;
212     }
213 
214     function getMinBetAmount() constant returns(uint) {
215         return minBetAmount;
216     }
217 
218     function getMaxBetAmount() constant returns(uint) {
219         return maxBetAmount;
220     }
221 
222     function () payable {
223     }
224 }