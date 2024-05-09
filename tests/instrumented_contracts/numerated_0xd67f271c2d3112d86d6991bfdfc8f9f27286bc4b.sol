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
72     uint256 public PRIZE_MAX = 0.25 ether;
73     uint256 public round = 0;
74     CryptoEngineerInterface public Engineer;
75     CryptoMiningWarInterface public MiningWar;
76     // mining war info
77     uint256 public miningWarDeadline;
78     uint256 constant private CRTSTAL_MINING_PERIOD = 86400;
79     /** 
80     * @dev mini game information
81     */
82     mapping(uint256 => Game) public games;
83     /** 
84     * @dev player information
85     */
86     mapping(address => Player) public players;
87    
88     struct Game {
89         uint256 round;
90         uint256 crystals;
91         uint256 prizePool;
92         uint256 endTime;
93         bool ended; 
94     }
95     struct Player {
96         uint256 currentRound;
97         uint256 lastRound;
98         uint256 reward;
99         uint256 share; // your crystals share in current round 
100     }
101     event EndRound(uint256 round, uint256 crystals, uint256 prizePool, uint256 endTime);
102     event Deposit(address player, uint256 questId, uint256 questLv, uint256 deposit, uint256 bonus, uint256 percent);
103     modifier isAdministrator()
104     {
105         require(msg.sender == administrator);
106         _;
107     }
108     modifier disableContract()
109     {
110         require(tx.origin == msg.sender);
111         _;
112     }
113 
114     constructor() public {
115         administrator = msg.sender;
116         // set interface contract
117         setMiningWarInterface(0xf84c61bb982041c030b8580d1634f00fffb89059);
118         setEngineerInterface(0x69fd0e5d0a93bf8bac02c154d343a8e3709adabf);
119     }
120     function () public payable
121     {
122         
123     }
124     /** 
125     * @dev MainContract used this function to verify game's contract
126     */
127     function isContractMiniGame() public pure returns( bool _isContractMiniGame )
128     {
129     	_isContractMiniGame = true;
130     }
131     function upgrade(address addr) public isAdministrator
132     {
133         selfdestruct(addr);
134     }
135     /** 
136     * @dev Main Contract call this function to setup mini game.
137     */
138     function setupMiniGame( uint256 /*_miningWarRoundNumber*/, uint256 _miningWarDeadline ) public
139     {
140         miningWarDeadline = _miningWarDeadline;
141     }
142     function setMiningWarInterface(address _addr) public isAdministrator
143     {
144         MiningWar = CryptoMiningWarInterface(_addr);
145     }
146     function setEngineerInterface(address _addr) public isAdministrator
147     {
148         CryptoEngineerInterface engineerInterface = CryptoEngineerInterface(_addr);
149         
150         require(engineerInterface.isContractMiniGame() == true);
151 
152         Engineer = engineerInterface;
153     }
154     /**
155     * @dev start the mini game
156     */
157      function startGame() public 
158     {
159         require(msg.sender == administrator);
160         require(init == false);
161         init = true;
162         miningWarDeadline = getMiningWarDealine();
163 
164         games[round].ended = true;
165     
166         startRound();
167     }
168     function startRound() private
169     {
170         require(games[round].ended == true);
171 
172         uint256 crystalsLastRound = games[round].crystals;
173         uint256 prizePoolLastRound= games[round].prizePool; 
174 
175         round = round + 1;
176 
177         uint256 endTime = now + HALF_TIME;
178         // claim 5% of current prizePool as rewards.
179         uint256 engineerPrizePool = getEngineerPrizePool();
180         uint256 prizePool = SafeMath.div(SafeMath.mul(engineerPrizePool, 5),100);
181 
182         if (prizePool >= PRIZE_MAX) prizePool = PRIZE_MAX;
183 
184         Engineer.claimPrizePool(address(this), prizePool);
185         if (crystalsLastRound <= 0) prizePool = SafeMath.add(prizePool, prizePoolLastRound);
186         games[round] = Game(round, 0, prizePool, endTime, false);
187     }
188     function endRound() private
189     {
190         require(games[round].ended == false);
191         require(games[round].endTime <= now);
192 
193         Game storage g = games[round];
194         g.ended = true;
195         
196         startRound();
197 
198         emit EndRound(g.round, g.crystals, g.prizePool, g.endTime);
199     }
200     /**
201     * @dev player send crystals to the pot
202     */
203     function share(uint256 _value) public disableContract
204     {
205         require(miningWarDeadline > now);
206         require(games[round].ended == false);
207         require(_value >= 10000);
208 
209         MiningWar.subCrystal(msg.sender, _value); 
210 
211         if (games[round].endTime <= now) endRound();
212         
213         updateReward(msg.sender);
214         
215         Game storage g = games[round];
216         uint256 _share = SafeMath.mul(_value, CRTSTAL_MINING_PERIOD);
217         g.crystals = SafeMath.add(g.crystals, _share);
218         Player storage p = players[msg.sender];
219         if (p.currentRound == round) {
220             p.share = SafeMath.add(p.share, _share);
221         } else {
222             p.share = _share;
223             p.currentRound = round;
224         }
225 
226         emit Deposit(msg.sender, 1, 1, _value, 0, 0); 
227     }
228     function withdrawReward() public disableContract
229     {
230         if (games[round].endTime <= now) endRound();
231         
232         updateReward(msg.sender);
233         Player storage p = players[msg.sender];
234         uint256 balance  = p.reward; 
235         if (address(this).balance >= balance) {
236              msg.sender.transfer(balance);
237             // update player
238             p.reward = 0;     
239         }
240     }
241     function updateReward(address _addr) private
242     {
243         Player storage p = players[_addr];
244         
245         if ( 
246             games[p.currentRound].ended == true &&
247             p.lastRound < p.currentRound
248             ) {
249             p.reward = SafeMath.add(p.reward, calculateReward(msg.sender, p.currentRound));
250             p.lastRound = p.currentRound;
251         }
252     }
253     function getData(address _addr) 
254     public
255     view
256     returns(
257         // current game
258         uint256 _prizePool,
259         uint256 _crystals,
260         uint256 _endTime,
261         // player info
262         uint256 _reward,
263         uint256 _share
264     ) {
265          (_prizePool, _crystals, _endTime) = getCurrentGame();
266          (_reward, _share)                 = getPlayerData(_addr);         
267     }
268       /**
269     * @dev calculate reward
270     */
271     function calculateReward(address _addr, uint256 _round) public view returns(uint256)
272     {
273         Player memory p = players[_addr];
274         Game memory g = games[_round];
275         if (g.endTime > now) return 0;
276         if (g.crystals == 0) return 0; 
277         return SafeMath.div(SafeMath.mul(g.prizePool, p.share), g.crystals);
278     }
279     function getCurrentGame() private view returns(uint256 _prizePool, uint256 _crystals, uint256 _endTime)
280     {
281         Game memory g = games[round];
282         _prizePool = g.prizePool;
283         _crystals  = g.crystals;
284         _endTime   = g.endTime;
285     }
286     function getPlayerData(address _addr) private view returns(uint256 _reward, uint256 _share)
287     {
288         Player memory p = players[_addr];
289         _reward           = p.reward;
290         if (p.currentRound == round) _share = players[_addr].share; 
291         if (p.currentRound != p.lastRound) _reward += calculateReward(_addr, p.currentRound);
292     }
293     function getEngineerPrizePool() private view returns(uint256)
294     {
295         return Engineer.prizePool();
296     }
297     function getMiningWarDealine () private view returns(uint256)
298     {
299         return MiningWar.deadline();
300     }
301 }