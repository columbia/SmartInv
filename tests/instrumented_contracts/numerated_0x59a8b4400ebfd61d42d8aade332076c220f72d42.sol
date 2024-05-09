1 pragma solidity ^0.4.25;
2 
3 /*
4 * CryptoMiningWar - Mining Contest Game
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
59 }
60 contract CryptoMiningWarInterface {
61     uint256 public deadline; 
62     function subCrystal( address /*_addr*/, uint256 /*_value*/ ) public {}
63 }
64 contract CrystalShare {
65 	using SafeMath for uint256;
66 
67     bool init = false;
68 	address public administrator;
69 	// mini game
70     uint256 public HALF_TIME = 24 hours;
71     uint256 public round = 0;
72     CryptoEngineerInterface public EngineerContract;
73     CryptoMiningWarInterface public MiningWarContract;
74     // mining war info
75     uint256 public miningWarDeadline;
76     uint256 constant public CRTSTAL_MINING_PERIOD = 86400;
77     /** 
78     * @dev mini game information
79     */
80     mapping(uint256 => Game) public games;
81     /** 
82     * @dev player information
83     */
84     mapping(address => Player) public players;
85    
86     struct Game {
87         uint256 round;
88         uint256 crystals;
89         uint256 prizePool;
90         uint256 endTime;
91         bool ended; 
92     }
93     struct Player {
94         uint256 currentRound;
95         uint256 lastRound;
96         uint256 reward;
97         uint256 share; // your crystals share in current round 
98     }
99     event EndRound(uint256 round, uint256 crystals, uint256 prizePool, uint256 endTime);
100     modifier disableContract()
101     {
102         require(tx.origin == msg.sender);
103         _;
104     }
105 
106     constructor() public {
107         administrator = msg.sender;
108         // set interface contract
109         MiningWarContract = CryptoMiningWarInterface(0xf84c61bb982041c030b8580d1634f00fffb89059);
110         EngineerContract = CryptoEngineerInterface(0x69fd0e5d0a93bf8bac02c154d343a8e3709adabf);
111     }
112     function () public payable
113     {
114         
115     }
116     /** 
117     * @dev MainContract used this function to verify game's contract
118     */
119     function isContractMiniGame() public pure returns( bool _isContractMiniGame )
120     {
121     	_isContractMiniGame = true;
122     }
123 
124     /** 
125     * @dev Main Contract call this function to setup mini game.
126     */
127     function setupMiniGame( uint256 /*_miningWarRoundNumber*/, uint256 _miningWarDeadline ) public
128     {
129         miningWarDeadline = _miningWarDeadline;
130     }
131     /**
132     * @dev start the mini game
133     */
134      function startGame() public 
135     {
136         require(msg.sender == administrator);
137         require(init == false);
138         init = true;
139         miningWarDeadline = getMiningWarDealine();
140 
141         games[round].ended = true;
142     
143         startRound();
144     }
145     function startRound() private
146     {
147         require(games[round].ended == true);
148 
149         uint256 crystalsLastRound = games[round].crystals;
150         uint256 prizePoolLastRound= games[round].prizePool; 
151 
152         round = round + 1;
153 
154         uint256 endTime = now + HALF_TIME;
155         // claim 5% of current prizePool as rewards.
156         uint256 engineerPrizePool = getEngineerPrizePool();
157         uint256 prizePool = SafeMath.div(SafeMath.mul(engineerPrizePool, 5),100);
158         if (crystalsLastRound <= 0) {
159             prizePool = SafeMath.add(prizePool, prizePoolLastRound);
160         } 
161 
162         EngineerContract.claimPrizePool(address(this), prizePool);
163         games[round] = Game(round, 0, prizePool, endTime, false);
164     }
165     function endRound() private
166     {
167         require(games[round].ended == false);
168         require(games[round].endTime <= now);
169 
170         Game storage g = games[round];
171         g.ended = true;
172         
173         startRound();
174 
175         emit EndRound(g.round, g.crystals, g.prizePool, g.endTime);
176     }
177     /**
178     * @dev player send crystals to the pot
179     */
180     function share(uint256 _value) public disableContract
181     {
182         require(miningWarDeadline > now);
183         require(games[round].ended == false);
184         require(_value >= 10000);
185 
186         MiningWarContract.subCrystal(msg.sender, _value); 
187 
188         if (games[round].endTime <= now) endRound();
189         
190         updateReward(msg.sender);
191         
192         Game storage g = games[round];
193         uint256 _share = SafeMath.mul(_value, CRTSTAL_MINING_PERIOD);
194         g.crystals = SafeMath.add(g.crystals, _share);
195         Player storage p = players[msg.sender];
196         if (p.currentRound == round) {
197             p.share = SafeMath.add(p.share, _share);
198         } else {
199             p.share = _share;
200             p.currentRound = round;
201         } 
202     }
203     function withdrawReward() public disableContract
204     {
205         if (games[round].endTime <= now) endRound();
206         
207         updateReward(msg.sender);
208         Player storage p = players[msg.sender];
209         
210         msg.sender.send(p.reward);
211         // update player
212         p.reward = 0;
213     }
214     function updateReward(address _addr) private
215     {
216         Player storage p = players[_addr];
217         
218         if ( 
219             games[p.currentRound].ended == true &&
220             p.lastRound < p.currentRound
221             ) {
222             p.reward = SafeMath.add(p.share, calculateReward(msg.sender, p.currentRound));
223             p.lastRound = p.currentRound;
224         }
225     }
226       /**
227     * @dev calculate reward
228     */
229     function calculateReward(address _addr, uint256 _round) public view returns(uint256)
230     {
231         Player memory p = players[_addr];
232         Game memory g = games[_round];
233         if (g.endTime > now) return 0;
234         if (g.crystals == 0) return 0; 
235         return SafeMath.div(SafeMath.mul(g.prizePool, p.share), g.crystals);
236     }
237     function getEngineerPrizePool() private view returns(uint256)
238     {
239         return EngineerContract.prizePool();
240     }
241     function getMiningWarDealine () private view returns(uint256)
242     {
243         return MiningWarContract.deadline();
244     }
245 }