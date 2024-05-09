1 pragma solidity ^0.4.25;
2 
3 /*
4 * CryptoMiningWar - Build your own empire on Blockchain
5 * Author: InspiGames
6 * Website: https://cryptominingwar.github.io/
7 */
8 
9 library SafeMath {
10 
11     /**
12     * @dev Multiplies two numbers, throws on overflow.
13     */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         if (a == 0) {
16             return 0;
17         }
18         uint256 c = a * b;
19         assert(c / a == b);
20         return c;
21     }
22 
23     /**
24     * @dev Integer division of two numbers, truncating the quotient.
25     */
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         // assert(b > 0); // Solidity automatically throws when dividing by 0
28         uint256 c = a / b;
29         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30         return c;
31     }
32 
33     /**
34     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35     */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         assert(b <= a);
38         return a - b;
39     }
40 
41     /**
42     * @dev Adds two numbers, throws on overflow.
43     */
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         assert(c >= a);
47         return c;
48     }
49 
50     function min(uint256 a, uint256 b) internal pure returns (uint256) {
51         return a < b ? a : b;
52     }
53 }
54 contract CryptoEngineerInterface {
55     uint256 public prizePool = 0;
56 
57     function subVirus(address /*_addr*/, uint256 /*_value*/) public {}
58     function claimPrizePool(address /*_addr*/, uint256 /*_value*/) public {} 
59     function isContractMiniGame() public pure returns( bool /*_isContractMiniGame*/) {}
60 }
61 contract CryptoMiningWarInterface {
62     uint256 public deadline; 
63     function subCrystal( address /*_addr*/, uint256 /*_value*/ ) public {}
64 }
65 contract CrystalDeposit {
66 	using SafeMath for uint256;
67 
68     bool init = false;
69 	address public administrator;
70 	// mini game
71     uint256 public HALF_TIME = 48 hours;
72     uint256 public round = 0;
73     CryptoEngineerInterface public Engineer;
74     CryptoMiningWarInterface public MiningWar;
75     // mining war info
76     uint256 public miningWarDeadline;
77     uint256 constant private CRTSTAL_MINING_PERIOD = 86400;
78     /** 
79     * @dev mini game information
80     */
81     mapping(uint256 => Game) public games;
82     /** 
83     * @dev player information
84     */
85     mapping(address => Player) public players;
86    
87     struct Game {
88         uint256 round;
89         uint256 crystals;
90         uint256 prizePool;
91         uint256 endTime;
92         bool ended; 
93     }
94     struct Player {
95         uint256 currentRound;
96         uint256 lastRound;
97         uint256 reward;
98         uint256 share; // your crystals share in current round 
99     }
100     event EndRound(uint256 round, uint256 crystals, uint256 prizePool, uint256 endTime);
101     event Deposit(address player, uint256 questId, uint256 questLv, uint256 deposit, uint256 bonus, uint256 percent);
102     modifier isAdministrator()
103     {
104         require(msg.sender == administrator);
105         _;
106     }
107     modifier disableContract()
108     {
109         require(tx.origin == msg.sender);
110         _;
111     }
112 
113     constructor() public {
114         administrator = msg.sender;
115         // set interface contract
116         setMiningWarInterface(0xf84c61bb982041c030b8580d1634f00fffb89059);
117         setEngineerInterface(0x69fd0e5d0a93bf8bac02c154d343a8e3709adabf);
118     }
119     function () public payable
120     {
121         
122     }
123     /** 
124     * @dev MainContract used this function to verify game's contract
125     */
126     function isContractMiniGame() public pure returns( bool _isContractMiniGame )
127     {
128     	_isContractMiniGame = true;
129     }
130     function upgrade(address addr) public isAdministrator
131     {
132         selfdestruct(addr);
133     }
134     /** 
135     * @dev Main Contract call this function to setup mini game.
136     */
137     function setupMiniGame( uint256 /*_miningWarRoundNumber*/, uint256 _miningWarDeadline ) public
138     {
139         miningWarDeadline = getMiningWarDealine();
140     }
141     function setMiningWarInterface(address _addr) public isAdministrator
142     {
143         MiningWar = CryptoMiningWarInterface(_addr);
144     }
145     function setEngineerInterface(address _addr) public isAdministrator
146     {
147         CryptoEngineerInterface engineerInterface = CryptoEngineerInterface(_addr);
148         
149         require(engineerInterface.isContractMiniGame() == true);
150 
151         Engineer = engineerInterface;
152     }
153     /**
154     * @dev start the mini game
155     */
156      function startGame() public 
157     {
158         require(msg.sender == administrator);
159         require(init == false);
160         init = true;
161         miningWarDeadline = getMiningWarDealine();
162 
163         games[round].ended = true;
164     
165         startRound();
166     }
167     function startRound() private
168     {
169         require(games[round].ended == true);
170 
171         uint256 crystalsLastRound = games[round].crystals;
172         uint256 prizePoolLastRound= games[round].prizePool; 
173 
174         round = round + 1;
175 
176         uint256 endTime = now + HALF_TIME;
177         // claim 5% of current prizePool as rewards.
178         uint256 engineerPrizePool = getEngineerPrizePool();
179         uint256 prizePool = SafeMath.div(SafeMath.mul(engineerPrizePool, 5),100);
180 
181         Engineer.claimPrizePool(address(this), prizePool);
182         if (crystalsLastRound <= 0) prizePool = SafeMath.add(prizePool, prizePoolLastRound);
183         games[round] = Game(round, 0, prizePool, endTime, false);
184     }
185     function endRound() private
186     {
187         require(games[round].ended == false);
188         require(games[round].endTime <= now);
189 
190         Game storage g = games[round];
191         g.ended = true;
192         
193         startRound();
194 
195         emit EndRound(g.round, g.crystals, g.prizePool, g.endTime);
196     }
197     /**
198     * @dev player send crystals to the pot
199     */
200     function share(uint256 _value) public disableContract
201     {
202         require(miningWarDeadline > now);
203         require(games[round].ended == false);
204         require(_value >= 10000);
205 
206         MiningWar.subCrystal(msg.sender, _value); 
207 
208         if (games[round].endTime <= now) endRound();
209         
210         updateReward(msg.sender);
211         
212         Game storage g = games[round];
213         uint256 _share = SafeMath.mul(_value, CRTSTAL_MINING_PERIOD);
214         g.crystals = SafeMath.add(g.crystals, _share);
215         Player storage p = players[msg.sender];
216         if (p.currentRound == round) {
217             p.share = SafeMath.add(p.share, _share);
218         } else {
219             p.share = _share;
220             p.currentRound = round;
221         }
222 
223         emit Deposit(msg.sender, 1, 1, _value, 0, 0); 
224     }
225     function withdrawReward() public disableContract
226     {
227         if (games[round].endTime <= now) endRound();
228         
229         updateReward(msg.sender);
230         Player storage p = players[msg.sender];
231         uint256 balance  = p.reward; 
232         if (address(this).balance >= balance) {
233              msg.sender.transfer(balance);
234             // update player
235             p.reward = 0;     
236         }
237     }
238     function updateReward(address _addr) private
239     {
240         Player storage p = players[_addr];
241         
242         if ( 
243             games[p.currentRound].ended == true &&
244             p.lastRound < p.currentRound
245             ) {
246             p.reward = SafeMath.add(p.reward, calculateReward(msg.sender, p.currentRound));
247             p.lastRound = p.currentRound;
248         }
249     }
250     function getData(address _addr) 
251     public
252     view
253     returns(
254         // current game
255         uint256 _prizePool,
256         uint256 _crystals,
257         uint256 _endTime,
258         // player info
259         uint256 _reward,
260         uint256 _share
261     ) {
262          (_prizePool, _crystals, _endTime) = getCurrentGame();
263          (_reward, _share)                 = getPlayerData(_addr);         
264     }
265       /**
266     * @dev calculate reward
267     */
268     function calculateReward(address _addr, uint256 _round) public view returns(uint256)
269     {
270         Player memory p = players[_addr];
271         Game memory g = games[_round];
272         if (g.endTime > now) return 0;
273         if (g.crystals == 0) return 0; 
274         return SafeMath.div(SafeMath.mul(g.prizePool, p.share), g.crystals);
275     }
276     function getCurrentGame() private view returns(uint256 _prizePool, uint256 _crystals, uint256 _endTime)
277     {
278         Game memory g = games[round];
279         _prizePool = g.prizePool;
280         _crystals  = g.crystals;
281         _endTime   = g.endTime;
282     }
283     function getPlayerData(address _addr) private view returns(uint256 _reward, uint256 _share)
284     {
285         Player memory p = players[_addr];
286         _reward           = p.reward;
287         if (p.currentRound == round) _share = players[_addr].share; 
288         if (p.currentRound != p.lastRound) _reward += calculateReward(_addr, p.currentRound);
289     }
290     function getEngineerPrizePool() private view returns(uint256)
291     {
292         return Engineer.prizePool();
293     }
294     function getMiningWarDealine () private view returns(uint256)
295     {
296         return MiningWar.deadline();
297     }
298 }