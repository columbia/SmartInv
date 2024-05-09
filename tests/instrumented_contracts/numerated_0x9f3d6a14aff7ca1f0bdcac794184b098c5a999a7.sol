1 pragma solidity ^0.4.23;
2 
3 contract RouletteRules {
4     function getTotalBetAmount(bytes32 first16, bytes32 second16) public pure returns(uint totalBetAmount);
5     function getBetResult(bytes32 betTypes, bytes32 first16, bytes32 second16, uint wheelResult) public view returns(uint wonAmount);
6 }
7 
8 contract OracleRoulette {
9 
10     //*********************************************
11     // Infrastructure
12     //*********************************************
13 
14     RouletteRules rouletteRules;
15     address developer;
16     address operator;
17     // enable or disable contract
18     // cannot place new bets if enabled
19     bool shouldGateGuard;
20     // save timestamp for gate guard
21     uint sinceGateGuarded;
22 
23     constructor(address _rouletteRules) public payable {
24         rouletteRules = RouletteRules(_rouletteRules);
25         developer = msg.sender;
26         operator = msg.sender;
27         shouldGateGuard = false;
28         // set as the max value
29         sinceGateGuarded = ~uint(0);
30     }
31 
32     modifier onlyDeveloper() {
33         require(msg.sender == developer);
34         _;
35     }
36 
37     modifier onlyOperator() {
38         require(msg.sender == operator);
39         _;
40     }
41 
42     modifier onlyDeveloperOrOperator() {
43         require(msg.sender == developer || msg.sender == operator);
44         _;
45     }
46 
47     modifier shouldGateGuardForEffectiveTime() {
48         // This is to protect players
49         // preventing the owner from running away with the contract balance
50         // when players are still playing the game.
51         // This function can only be operated
52         // after specified minutes has passed since gate guard is up.
53         require(shouldGateGuard == true && (sinceGateGuarded - now) > 10 minutes);
54         _;
55     }
56 
57     function changeDeveloper(address newDeveloper) external onlyDeveloper {
58         developer = newDeveloper;
59     }
60 
61     function changeOperator(address newOperator) external onlyDeveloper {
62         operator = newOperator;
63     }
64 
65     function setShouldGateGuard(bool flag) external onlyDeveloperOrOperator {
66         if (flag) sinceGateGuarded = now;
67         shouldGateGuard = flag;
68     }
69 
70     function setRouletteRules(address _newRouletteRules) external onlyDeveloperOrOperator shouldGateGuardForEffectiveTime {
71         rouletteRules = RouletteRules(_newRouletteRules);
72     }
73 
74     // only be called in case the contract may need to be destroyed
75     function destroyContract() external onlyDeveloper shouldGateGuardForEffectiveTime {
76         selfdestruct(developer);
77     }
78 
79     // only be called for maintenance reasons
80     function withdrawFund(uint amount) external onlyDeveloper shouldGateGuardForEffectiveTime {
81         require(address(this).balance >= amount);
82         msg.sender.transfer(amount);
83     }
84 
85     // for fund deposit
86     // make contract payable
87     function () external payable {}
88 
89     //*********************************************
90     // Game Settings & House State Variables
91     //*********************************************
92 
93     uint BET_UNIT = 0.0002 ether;
94     uint BLOCK_TARGET_DELAY = 0;
95     // EVM is only able to store hashes of latest 256 blocks
96     uint constant MAXIMUM_DISTANCE_FROM_BLOCK_TARGET_DELAY = 250;
97     uint MAX_BET = 1 ether;
98     uint MAX_GAME_PER_BLOCK = 10;
99 
100     function setBetUnit(uint newBetUnitInWei) external onlyDeveloperOrOperator shouldGateGuardForEffectiveTime {
101         require(newBetUnitInWei > 0);
102         BET_UNIT = newBetUnitInWei;
103     }
104 
105     function setBlockTargetDelay(uint newTargetDelay) external onlyDeveloperOrOperator {
106         require(newTargetDelay >= 0);
107         BLOCK_TARGET_DELAY = newTargetDelay;
108     }
109 
110     function setMaxBet(uint newMaxBet) external onlyDeveloperOrOperator {
111         MAX_BET = newMaxBet;
112     }
113 
114     function setMaxGamePerBlock(uint newMaxGamePerBlock) external onlyDeveloperOrOperator {
115         MAX_GAME_PER_BLOCK = newMaxGamePerBlock;
116     }
117 
118     //*********************************************
119     // Service Interface
120     //*********************************************
121 
122     event GameError(address player, string message);
123     event GameStarted(address player, uint gameId, uint targetBlock);
124     event GameEnded(address player, uint wheelResult, uint wonAmount);
125 
126     function placeBet(bytes32 betTypes, bytes32 first16, bytes32 second16) external payable {
127         // check gate guard
128         if (shouldGateGuard == true) {
129             emit GameError(msg.sender, "Entrance not allowed!");
130             revert();
131         }
132 
133         // check if the received ether is the same as specified in the bets
134         uint betAmount = rouletteRules.getTotalBetAmount(first16, second16) * BET_UNIT;
135         // if the amount does not match
136         if (betAmount == 0 || msg.value != betAmount || msg.value > MAX_BET) {
137             emit GameError(msg.sender, "Wrong bet amount!");
138             revert();
139         }
140 
141         // set target block
142         // current block number + target delay
143         uint targetBlock = block.number + BLOCK_TARGET_DELAY;
144 
145         // check if MAX_GAME_PER_BLOCK is reached
146         uint historyLength = gameHistory.length;
147         if (historyLength > 0) {
148             uint counter;
149             for (uint i = historyLength - 1; i >= 0; i--) {
150                 if (gameHistory[i].targetBlock == targetBlock) {
151                     counter++;
152                     if (counter > MAX_GAME_PER_BLOCK) {
153                         emit GameError(msg.sender, "Reached max game per block!");
154                         revert();
155                     }
156                 } else break;
157             }
158         }
159 
160         // start a new game
161         // init wheelResult with number 100
162         Game memory newGame = Game(uint8(GameStatus.PENDING), 100, msg.sender, targetBlock, betTypes, first16, second16);
163         uint gameId = gameHistory.push(newGame) - 1;
164         emit GameStarted(msg.sender, gameId, targetBlock);
165     }
166 
167     function resolveBet(uint gameId) external {
168         // get game from history
169         Game storage game = gameHistory[gameId];
170 
171         // should not proceed if game status is not PENDING
172         if (game.status != uint(GameStatus.PENDING)) {
173             emit GameError(game.player, "Game is not pending!");
174             revert();
175         }
176 
177         // see if current block is early/late enough to get the block hash
178         // if it's too early to resolve bet
179         if (block.number <= game.targetBlock) {
180             emit GameError(game.player, "Too early to resolve bet!");
181             revert();
182         }
183         // if it's too late to retrieve the block hash
184         if (block.number - game.targetBlock > MAXIMUM_DISTANCE_FROM_BLOCK_TARGET_DELAY) {
185             // mark game status as rejected
186             game.status = uint8(GameStatus.REJECTED);
187             emit GameError(game.player, "Too late to resolve bet!");
188             revert();
189         }
190 
191         // get hash of set target block
192         bytes32 blockHash = blockhash(game.targetBlock);
193         // double check that the queried hash is not zero
194         if (blockHash == 0) {
195             // mark game status as rejected
196             game.status = uint8(GameStatus.REJECTED);
197             emit GameError(game.player, "blockhash() returned zero!");
198             revert();
199         }
200 
201         // generate random number of 0~36
202         // blockhash of target block, address of game player, address of contract as source of entropy
203         game.wheelResult = uint8(keccak256(blockHash, game.player, address(this))) % 37;
204 
205         // resolve won amount
206         uint wonAmount = rouletteRules.getBetResult(game.betTypes, game.first16, game.second16, game.wheelResult) * BET_UNIT;
207         // set status first to prevent possible reentrancy attack within same transaction
208         game.status = uint8(GameStatus.RESOLVED);
209         // transfer if the amount is bigger than 0
210         if (wonAmount > 0) {
211             game.player.transfer(wonAmount);
212         }
213         emit GameEnded(game.player, game.wheelResult, wonAmount);
214     }
215 
216     //*********************************************
217     // Game Interface
218     //*********************************************
219 
220     Game[] private gameHistory;
221 
222     enum GameStatus {
223         INITIAL,
224         PENDING,
225         RESOLVED,
226         REJECTED
227     }
228 
229     struct Game {
230         uint8 status;
231         uint8 wheelResult;
232         address player;
233         uint256 targetBlock;
234         // one byte specifies one bet type
235         bytes32 betTypes;
236         // two bytes per bet amount on each type
237         bytes32 first16;
238         bytes32 second16;
239     }
240 
241     //*********************************************
242     // Query Functions
243     //*********************************************
244 
245     function queryGameStatus(uint gameId) external view returns(uint8) {
246         Game memory game = gameHistory[gameId];
247         return uint8(game.status);
248     }
249 
250     function queryBetUnit() external view returns(uint) {
251         return BET_UNIT;
252     }
253 
254     function queryGameHistory(uint gameId) external view returns(
255         address player, uint256 targetBlock, uint8 status, uint8 wheelResult,
256         bytes32 betTypes, bytes32 first16, bytes32 second16
257     ) {
258         Game memory g = gameHistory[gameId];
259         player = g.player;
260         targetBlock = g.targetBlock;
261         status = g.status;
262         wheelResult = g.wheelResult;
263         betTypes = g.betTypes;
264         first16 = g.first16;
265         second16 = g.second16;
266     }
267 
268     function queryGameHistoryLength() external view returns(uint length) {
269         return gameHistory.length;
270     }
271 }