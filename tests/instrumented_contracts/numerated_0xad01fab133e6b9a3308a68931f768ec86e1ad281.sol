1 pragma solidity ^0.4.11;
2 
3 contract Roshambo {
4     enum State { Unrealized, Created, Joined, Ended }
5     enum Result { Unfinished, Draw, Win, Loss, Forfeit }
6     enum ResultType { None, StraightUp, Tiebroken, SuperDraw } 
7     struct Game {
8         address player1;
9         address player2;
10         uint value;
11         bytes32 hiddenMove1;
12         uint8 move1; // 0 = not set, 1 = Rock, 2 = Paper, 3 = Scissors
13         uint8 move2;
14         uint gameStart;
15         uint8 tiebreaker;
16         uint8 tiebreaker1;
17         uint8 tiebreaker2;
18         State state;
19         Result result;
20         ResultType resultType;
21     }
22     
23     address public owner1;
24     uint8 constant feeDivisor = 100;
25     uint constant revealTime = 7 days;
26     bool paused;
27     bool expired;
28     uint gameIdCounter;
29     
30     event Deposit(address indexed player, uint amount);
31     event Withdraw(address indexed player, uint amount);
32     event GameCreated(address indexed player1, address indexed player2, uint indexed gameId, uint value, bytes32 hiddenMove1);
33     event GameJoined(address indexed player1, address indexed player2, uint indexed gameId, uint value, uint8 move2, uint gameStart);
34     event GameEnded(address indexed player1, address indexed player2, uint indexed gameId, uint value, Result result, ResultType resultType);
35     
36     mapping(address => uint) public balances;
37     mapping(address => uint) public totalWon;
38     mapping(address => uint) public totalLost;
39     
40     Game [] public games;
41     mapping(address => string) public playerNames;
42     mapping(uint => bool) public nameTaken;
43     mapping(bytes32 => bool) public secretTaken;
44     
45     modifier onlyOwner { require(msg.sender == owner1); _; }
46     modifier notPaused { require(!paused); _; }
47     modifier notExpired { require(!expired); _; }
48 
49     function Roshambo() public {
50         owner1 = msg.sender;
51         paused = true;
52     }
53 
54     function rand(uint8 min, uint8 max) constant internal returns (uint8){
55         return uint8(block.blockhash(block.number-min))% max + min;
56     }
57     
58     function getGames() constant internal returns (Game []) {
59         return games;
60     }
61     
62     function totalProfit(address player) constant internal returns (int) {
63         if (totalLost[player] > totalWon[player]) {
64             return -int(totalLost[player] - totalWon[player]);
65         }
66         else {
67             return int(totalWon[player] - totalLost[player]);
68         }
69     }
70     
71     function createGame(bytes32 move, uint val, address player2) public
72     payable notPaused notExpired returns (uint gameId) {
73         deposit();
74         require(balances[msg.sender] >= val);
75         require(!secretTaken[move]);
76         secretTaken[move] = true;
77         balances[msg.sender] -= val;
78         gameId = gameIdCounter;
79         games.push(Game(msg.sender, player2, val, move, 0, 0, 0, 0, 0, 0, State.Created, Result(0), ResultType(0)));
80 
81         GameCreated(msg.sender, player2, gameId, val, move);
82         gameIdCounter++;
83     }
84     
85     function abortGame(uint gameId) public notPaused returns (bool success) {
86         Game storage thisGame = games[gameId];
87         require(thisGame.player1 == msg.sender);
88         require(thisGame.state == State.Created);
89         thisGame.state = State.Ended;
90 
91         GameEnded(thisGame.player1, thisGame.player2, gameId, thisGame.value, Result(0), ResultType.StraightUp);
92 
93         msg.sender.transfer(thisGame.value);
94         return true;
95     }
96     
97     function joinGame(uint gameId, uint8 move, uint8 tiebreaker) public payable notPaused returns (bool success) {
98         Game storage thisGame = games[gameId];
99         require(thisGame.state == State.Created);
100         require(move > 0 && move <= 3);
101         if (thisGame.player2 == 0x0) {
102             thisGame.player2 = msg.sender;
103         }
104         else {
105             require(thisGame.player2 == msg.sender);
106         }
107         require(thisGame.value == msg.value);
108         thisGame.gameStart = now;
109         thisGame.state = State.Joined;
110         thisGame.move2 = move;
111         thisGame.tiebreaker2 = tiebreaker;
112 
113         GameJoined(thisGame.player1, thisGame.player2, gameId, thisGame.value, thisGame.move2, thisGame.gameStart);
114         return true;
115     }
116     
117     function revealMove(uint gameId, uint8 move, uint8 tiebreaker, string secret) public notPaused returns (Result result) {
118         Game storage thisGame = games[gameId];
119         ResultType resultType = ResultType.None;
120         require(thisGame.state == State.Joined);
121         require(thisGame.player1 == msg.sender);
122         require(thisGame.hiddenMove1 == keccak256(uint(move), uint(tiebreaker), secret));
123         thisGame.move1 = move;
124         thisGame.tiebreaker1 = tiebreaker;
125         if (move > 0 && move <= 3) {
126             result = Result(((3 + move - thisGame.move2) % 3) + 1); 
127         }
128         else { // Player 1 submitted invalid move
129             result = Result.Loss;
130         }
131         thisGame.state = State.Ended;
132         address winner;
133         if (result != Result.Draw) {
134             resultType = ResultType.StraightUp;
135         }
136 
137         if (result == Result.Draw) {
138             thisGame.tiebreaker = rand(1, 100);
139 
140             int8 player1Tiebreaker =  int8(thisGame.tiebreaker) - int8(thisGame.tiebreaker1);
141             if(player1Tiebreaker < 0) {
142                 player1Tiebreaker = player1Tiebreaker * int8(-1);
143             }
144             int8 player2Tiebreaker = int8(thisGame.tiebreaker) - int8(thisGame.tiebreaker2);
145             if(player2Tiebreaker < 0) {
146                 player2Tiebreaker = player2Tiebreaker * int8(-1);
147             }
148 
149             if(player1Tiebreaker == player2Tiebreaker) {
150                 resultType = ResultType.SuperDraw;
151                 balances[thisGame.player1] += thisGame.value;
152                 balances[thisGame.player2] += thisGame.value;
153             }else{
154                 resultType = ResultType.Tiebroken;
155                 if(player1Tiebreaker < player2Tiebreaker) {
156                     result = Result.Win;
157                 }else{
158                     result = Result.Loss;
159                 }
160             }
161         }
162         
163         if(resultType != ResultType.SuperDraw) {
164             if (result == Result.Win) {
165                 winner = thisGame.player1;
166                 totalLost[thisGame.player2] += thisGame.value;
167             }
168             else {
169                 winner = thisGame.player2;
170                 totalLost[thisGame.player1] += thisGame.value;
171             }
172             uint fee = (thisGame.value) / feeDivisor;
173             balances[owner1] += fee*2;
174             totalWon[winner] += thisGame.value - fee*2;
175             // No re-entrancy attack is possible because
176             // the state has already been set to State.Ended
177             winner.transfer((thisGame.value*2) - fee*2);
178         }
179 
180         thisGame.result = result;
181         thisGame.resultType = resultType;
182 
183         GameEnded(thisGame.player1, thisGame.player2, gameId, thisGame.value, result, resultType);
184     }
185     
186     function forfeitGame(uint gameId) public notPaused returns (bool success) {
187         Game storage thisGame = games[gameId];
188         require(thisGame.state == State.Joined);
189         require(thisGame.player1 == msg.sender);
190         
191         uint fee = (thisGame.value) / feeDivisor; 
192         balances[owner1] += fee*2;
193         totalLost[thisGame.player1] += thisGame.value;
194         totalWon[thisGame.player2] += thisGame.value - fee*2;
195         thisGame.state = State.Ended;
196         thisGame.result = Result.Forfeit; // Loss for player 1
197 
198         GameEnded(thisGame.player1, thisGame.player2, gameId, thisGame.value, thisGame.result, ResultType.StraightUp);
199         
200         thisGame.player2.transfer((thisGame.value*2) - fee*2);
201         return true;
202     }
203     
204     function claimGame(uint gameId) public notPaused returns (bool success) {
205         Game storage thisGame = games[gameId];
206         require(thisGame.state == State.Joined);
207         require(thisGame.player2 == msg.sender);
208         require(thisGame.gameStart + revealTime < now); 
209         
210         uint fee = (thisGame.value) / feeDivisor;
211         balances[owner1] += fee*2;
212         totalLost[thisGame.player1] += thisGame.value;
213         totalWon[thisGame.player2] += thisGame.value - fee*2;
214         thisGame.state = State.Ended;
215         thisGame.result = Result.Forfeit; // Loss for player 1
216         
217         GameEnded(thisGame.player1, thisGame.player2, gameId, thisGame.value, thisGame.result, ResultType.StraightUp);
218 
219         thisGame.player2.transfer((thisGame.value*2) - fee*2);
220         return true;
221     }
222     
223     function donate() public payable returns (bool success) {
224         require(msg.value != 0);
225         balances[owner1] += msg.value;
226 
227         return true;
228     }
229     function deposit() public payable returns (bool success) {
230         require(msg.value != 0);
231         balances[msg.sender] += msg.value;
232 
233         Deposit(msg.sender, msg.value);
234         return true;
235     }
236     function withdraw() public returns (bool success) {
237         uint amount = balances[msg.sender];
238         if (amount == 0) return false;
239         balances[msg.sender] = 0;
240         msg.sender.transfer(amount);
241 
242         Withdraw(msg.sender, amount);
243         return true;
244     }
245     
246     function pause(bool setpause) public onlyOwner {
247         paused = setpause;
248     }
249     
250     function expire(bool setexpire) public onlyOwner {
251         expired = setexpire;
252     }
253     
254     function setOwner(address newOwner) public {
255         require(msg.sender == owner1);
256         owner1 = newOwner;
257     }
258     
259 }