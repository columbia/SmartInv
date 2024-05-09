1 pragma solidity ^0.4.25;
2 
3 /*
4 * CryptoMiningWar - Blockchain-based strategy game
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
60     function isEngineerContract() external pure returns(bool) {}
61 }
62 contract CryptoMiningWarInterface {
63     uint256 public deadline; 
64     function subCrystal( address /*_addr*/, uint256 /*_value*/ ) public {}
65     function isMiningWarContract() external pure returns(bool) {}
66 }
67 interface MiniGameInterface {
68      function isContractMiniGame() external pure returns( bool _isContractMiniGame );
69 }
70 contract CrystalDeposit {
71 	using SafeMath for uint256;
72 
73 	address public administrator;
74 	// mini game
75     uint256 public HALF_TIME = 48 hours;
76     uint256 public MIN_TIME_WITH_DEADLINE = 12 hours;
77     uint256 public round = 0;
78     CryptoEngineerInterface public Engineer;
79     CryptoMiningWarInterface public MiningWar;
80     // mining war info
81     address miningWarAddress;
82     uint256 miningWarDeadline;
83     uint256 constant private CRTSTAL_MINING_PERIOD = 86400;
84     /** 
85     * @dev mini game information
86     */
87     mapping(uint256 => Game) public games;
88     /** 
89     * @dev player information
90     */
91     mapping(address => Player) public players;
92 
93     mapping(address => bool)   public miniGames;
94    
95     struct Game {
96         uint256 round;
97         uint256 crystals;
98         uint256 prizePool;
99         uint256 startTime;
100         uint256 endTime;
101         bool ended; 
102     }
103     struct Player {
104         uint256 currentRound;
105         uint256 lastRound;
106         uint256 reward;
107         uint256 share; // your crystals share in current round 
108     }
109     event EndRound(uint256 round, uint256 crystals, uint256 prizePool, uint256 startTime, uint256 endTime);
110     event Deposit(address player, uint256 currentRound, uint256 deposit, uint256 currentShare);
111     modifier isAdministrator()
112     {
113         require(msg.sender == administrator);
114         _;
115     }
116     modifier disableContract()
117     {
118         require(tx.origin == msg.sender);
119         _;
120     }
121 
122     constructor() public {
123         administrator = msg.sender;
124         // set interface contract
125         setMiningWarInterface(0x65c347702b66ff8f1a28cf9a9768487fbe97765f);
126         setEngineerInterface(0xb2d6000d4a7fe8b1358d54a9bc21f2badf91d849);
127     }
128     function () public payable
129     {
130         
131     }
132     /** 
133     * @dev MainContract used this function to verify game's contract
134     */
135     function isContractMiniGame() public pure returns( bool _isContractMiniGame )
136     {
137     	_isContractMiniGame = true;
138     }
139     function isDepositContract() public pure returns(bool)
140     {
141         return true;
142     }
143     function upgrade(address addr) public isAdministrator
144     {
145         selfdestruct(addr);
146     }
147     function setContractsMiniGame( address _addr ) public isAdministrator 
148     {
149         MiniGameInterface MiniGame = MiniGameInterface( _addr );
150         if( MiniGame.isContractMiniGame() == false ) { revert(); }
151 
152         miniGames[_addr] = true;
153     }
154     /**
155     * @dev remove mini game contract from main contract
156     * @param _addr mini game contract address
157     */
158     function removeContractMiniGame(address _addr) public isAdministrator
159     {
160         miniGames[_addr] = false;
161     }
162     /** 
163     * @dev Main Contract call this function to setup mini game.
164     */
165     function setupMiniGame( uint256 /*_miningWarRoundNumber*/, uint256 _miningWarDeadline ) public
166     {
167         require(msg.sender == miningWarAddress);
168         miningWarDeadline = _miningWarDeadline;
169     }
170     function setMiningWarInterface(address _addr) public isAdministrator
171     {
172         CryptoMiningWarInterface miningWarInterface = CryptoMiningWarInterface(_addr);
173 
174         require(miningWarInterface.isMiningWarContract() == true);
175         
176         miningWarAddress = _addr;
177         
178         MiningWar = miningWarInterface;
179     }
180     function setEngineerInterface(address _addr) public isAdministrator
181     {
182         CryptoEngineerInterface engineerInterface = CryptoEngineerInterface(_addr);
183         
184         require(engineerInterface.isEngineerContract() == true);
185 
186         Engineer = engineerInterface;
187     }
188     /**
189     * @dev start the mini game
190     */
191      function startGame() public isAdministrator
192     {
193 
194         miningWarDeadline = MiningWar.deadline();
195 
196         games[round].ended = true;
197     
198         startRound();
199     }
200     function startRound() private
201     {
202         require(games[round].ended == true);
203 
204         uint256 crystalsLastRound = games[round].crystals;
205         uint256 prizePoolLastRound= games[round].prizePool; 
206 
207         round = round + 1;
208 
209         uint256 startTime = now;
210 
211         if (miningWarDeadline < SafeMath.add(startTime, MIN_TIME_WITH_DEADLINE)) startTime = miningWarDeadline;
212 
213         uint256 endTime = startTime + HALF_TIME;
214         // claim 5% of current prizePool as rewards.
215         uint256 engineerPrizePool = getEngineerPrizePool();
216         
217         uint256 prizePool = SafeMath.div(SafeMath.mul(engineerPrizePool, 5),100);
218 
219         Engineer.claimPrizePool(address(this), prizePool);
220         
221         if (crystalsLastRound == 0) prizePool = SafeMath.add(prizePool, prizePoolLastRound);
222 
223         games[round] = Game(round, 0, prizePool, startTime, endTime, false);
224     }
225     function endRound() private
226     {
227         require(games[round].ended == false);
228         require(games[round].endTime <= now);
229 
230         Game storage g = games[round];
231         g.ended = true;
232         
233         startRound();
234 
235         emit EndRound(g.round, g.crystals, g.prizePool, g.startTime, g.endTime);
236     }
237     /**
238     * @dev player send crystals to the pot
239     */
240     function share(uint256 _value) public disableContract
241     {
242         require(games[round].ended == false);
243         require(games[round].startTime <= now);
244         require(_value >= 1);
245 
246         MiningWar.subCrystal(msg.sender, _value); 
247 
248         if (games[round].endTime <= now) endRound();
249         
250         updateReward(msg.sender);
251         
252         Game storage g = games[round];
253         uint256 _share = SafeMath.mul(_value, CRTSTAL_MINING_PERIOD);
254         g.crystals = SafeMath.add(g.crystals, _share);
255         Player storage p = players[msg.sender];
256         if (p.currentRound == round) {
257             p.share = SafeMath.add(p.share, _share);
258         } else {
259             p.share = _share;
260             p.currentRound = round;
261         }
262 
263         emit Deposit(msg.sender, p.currentRound, _value, p.share); 
264     }
265     function getCurrentReward(address _addr) public view returns(uint256 _currentReward)
266     {
267         Player memory p = players[_addr];
268         _currentReward = p.reward;
269         _currentReward += calculateReward(_addr, p.currentRound);
270     }
271     function withdrawReward(address _addr) public 
272     {
273         // require(miniGames[msg.sender] == true);
274 
275         if (games[round].endTime <= now) endRound();
276         
277         updateReward(_addr);
278         Player storage p = players[_addr];
279         uint256 balance  = p.reward; 
280         if (address(this).balance >= balance && balance > 0) {
281              _addr.transfer(balance);
282             // update player
283             p.reward = 0;     
284         }
285     }
286     function updateReward(address _addr) private
287     {
288         Player storage p = players[_addr];
289         
290         if ( 
291             games[p.currentRound].ended == true &&
292             p.lastRound < p.currentRound
293             ) {
294             p.reward = SafeMath.add(p.reward, calculateReward(msg.sender, p.currentRound));
295             p.lastRound = p.currentRound;
296         }
297     }
298     function getData(address _addr) 
299     public
300     view
301     returns(
302         // current game
303         uint256 _prizePool,
304         uint256 _crystals,
305         uint256 _startTime,
306         uint256 _endTime,
307         // player info
308         uint256 _reward,
309         uint256 _share
310     ) {
311          (_prizePool, _crystals, _startTime, _endTime) = getCurrentGame();
312          (_reward, _share)                 = getPlayerData(_addr);         
313     }
314       /**
315     * @dev calculate reward
316     */
317     function calculateReward(address _addr, uint256 _round) public view returns(uint256)
318     {
319         Player memory p = players[_addr];
320         Game memory g = games[_round];
321         if (g.endTime > now) return 0;
322         if (g.crystals == 0) return 0;
323         if (p.lastRound >= _round) return 0; 
324         return SafeMath.div(SafeMath.mul(g.prizePool, p.share), g.crystals);
325     }
326     function getCurrentGame() private view returns(uint256 _prizePool, uint256 _crystals, uint256 _startTime, uint256 _endTime)
327     {
328         Game memory g = games[round];
329         _prizePool = g.prizePool;
330         _crystals  = g.crystals;
331         _startTime = g.startTime;
332         _endTime   = g.endTime;
333     }
334     function getPlayerData(address _addr) private view returns(uint256 _reward, uint256 _share)
335     {
336         Player memory p = players[_addr];
337         _reward           = p.reward;
338         if (p.currentRound == round) _share = players[_addr].share; 
339         if (p.currentRound != p.lastRound) _reward += calculateReward(_addr, p.currentRound);
340     }
341     function getEngineerPrizePool() private view returns(uint256)
342     {
343         return Engineer.prizePool();
344     }
345 }