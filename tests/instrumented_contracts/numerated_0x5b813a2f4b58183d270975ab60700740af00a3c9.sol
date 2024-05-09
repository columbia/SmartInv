1 pragma solidity ^0.4.24;
2 
3 /*
4 * CrystalAirdropGame
5 * Author: InspiGames
6 * Website: https://cryptominingwar.github.io/
7 */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32     /**
33     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41     * @dev Adds two numbers, throws on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 
49     function min(uint256 a, uint256 b) internal pure returns (uint256) {
50         return a < b ? a : b;
51     }
52 }
53 contract CryptoMiningWarInterface {
54 	uint256 public roundNumber;
55     uint256 public deadline; 
56     function addCrystal( address _addr, uint256 _value ) public {}
57 }
58 contract CrystalAirdropGame {
59 	using SafeMath for uint256;
60 
61 	address public administrator;
62 	// mini game
63     uint256 public MINI_GAME_TIME_DEFAULT = 60 * 5;
64     uint256 public MINI_GAME_PRIZE_CRYSTAL = 100;
65     uint256 public MINI_GAME_BETWEEN_TIME = 8 hours;
66     uint256 public MINI_GAME_ADD_TIME_DEFAULT = 15;
67     address public miningWarContractAddress;
68     uint256 public miniGameId = 0;
69     uint256 public noRoundMiniGame;
70     CryptoMiningWarInterface public MiningWarContract;
71     /** 
72     * Admin can set the bonus of game's reward
73     */
74     uint256 public MINI_GAME_BONUS = 100;
75     /** 
76     * @dev mini game information
77     */
78     mapping(uint256 => MiniGame) public minigames;
79     /** 
80     * @dev player information
81     */
82     mapping(address => PlayerData) public players;
83    
84     struct MiniGame {
85         uint256 miningWarRoundNumber;
86         bool ended; 
87         uint256 prizeCrystal;
88         uint256 startTime;
89         uint256 endTime;
90         address playerWin;
91         uint256 totalPlayer;
92     }
93     struct PlayerData {
94         uint256 currentMiniGameId;
95         uint256 lastMiniGameId; 
96         uint256 win;
97         uint256 share;
98         uint256 totalJoin;
99         uint256 miningWarRoundNumber;
100     }
101     event eventEndMiniGame(
102         address playerWin,
103         uint256 crystalBonus
104     );
105     event eventJoinMiniGame(
106         uint256 totalJoin
107     );
108     modifier disableContract()
109     {
110         require(tx.origin == msg.sender);
111         _;
112     }
113 
114     constructor() public {
115         administrator = msg.sender;
116         // set interface main contract
117         miningWarContractAddress = address(0xf84c61bb982041c030b8580d1634f00fffb89059);
118         MiningWarContract = CryptoMiningWarInterface(miningWarContractAddress);
119     }
120 
121     /** 
122     * @dev MainContract used this function to verify game's contract
123     */
124     function isContractMiniGame() public pure returns( bool _isContractMiniGame )
125     {
126     	_isContractMiniGame = true;
127     }
128 
129     /** 
130     * @dev set discount bonus for game 
131     * require is administrator
132     */
133     function setDiscountBonus( uint256 _discountBonus ) public 
134     {
135         require( administrator == msg.sender );
136         MINI_GAME_BONUS = _discountBonus;
137     }
138 
139     /** 
140     * @dev Main Contract call this function to setup mini game.
141     * @param _miningWarRoundNumber is current main game round number
142     * @param _miningWarDeadline Main game's end time
143     */
144     function setupMiniGame( uint256 _miningWarRoundNumber, uint256 _miningWarDeadline ) public
145     {
146         require(minigames[ miniGameId ].miningWarRoundNumber < _miningWarRoundNumber && msg.sender == miningWarContractAddress);
147         // rerest current mini game to default
148         minigames[ miniGameId ] = MiniGame(0, true, 0, 0, 0, 0x0, 0);
149         noRoundMiniGame = 0;         
150         startMiniGame();	
151     }
152 
153     /**
154     * @dev start the mini game
155     */
156     function startMiniGame() private 
157     {      
158         uint256 miningWarRoundNumber = getMiningWarRoundNumber();
159 
160         require(minigames[ miniGameId ].ended == true);
161         // caculate information for next mini game
162         uint256 currentPrizeCrystal;
163         if ( noRoundMiniGame == 0 ) {
164             currentPrizeCrystal = SafeMath.div(SafeMath.mul(MINI_GAME_PRIZE_CRYSTAL, MINI_GAME_BONUS),100);
165         } else {
166             uint256 rate = 168 * MINI_GAME_BONUS;
167 
168             currentPrizeCrystal = SafeMath.div(SafeMath.mul(minigames[miniGameId].prizeCrystal, rate), 10000); // price * 168 / 100 * MINI_GAME_BONUS / 100 
169         }
170 
171         uint256 startTime = now + MINI_GAME_BETWEEN_TIME;
172         uint256 endTime = startTime + MINI_GAME_TIME_DEFAULT;
173         noRoundMiniGame = noRoundMiniGame + 1;
174         // start new round mini game
175         miniGameId = miniGameId + 1;
176         minigames[ miniGameId ] = MiniGame(miningWarRoundNumber, false, currentPrizeCrystal, startTime, endTime, 0x0, 0);
177     }
178 
179     /**
180     * @dev end Mini Game's round
181     */
182     function endMiniGame() private  
183     {  
184         require(minigames[ miniGameId ].ended == false && (minigames[ miniGameId ].endTime <= now ));
185         
186         uint256 crystalBonus = SafeMath.div( SafeMath.mul(minigames[ miniGameId ].prizeCrystal, 50), 100 );
187         // update crystal bonus for player win
188         if (minigames[ miniGameId ].playerWin != 0x0) {
189             PlayerData storage p = players[minigames[ miniGameId ].playerWin];
190             p.win =  p.win + crystalBonus;
191         }
192         // end current mini game
193         minigames[ miniGameId ].ended = true;
194         emit eventEndMiniGame(minigames[ miniGameId ].playerWin, crystalBonus);
195         // start new mini game
196         startMiniGame();
197     }
198 
199     /**
200     * @dev player join this round
201     */
202     function joinMiniGame() public disableContract
203     {        
204         require(now >= minigames[ miniGameId ].startTime && minigames[ miniGameId ].ended == false);
205         
206         PlayerData storage p = players[msg.sender];
207         if (now <= minigames[ miniGameId ].endTime) {
208             // update player data in current mini game
209             if (p.currentMiniGameId == miniGameId) {
210                 p.totalJoin = p.totalJoin + 1;
211             } else {
212                 // if player join an new mini game then update share of last mini game for this player 
213                 updateShareCrystal();
214                 p.currentMiniGameId = miniGameId;
215                 p.totalJoin = 1;
216                 p.miningWarRoundNumber = minigames[ miniGameId ].miningWarRoundNumber;
217             }
218             // update information for current mini game 
219             if ( p.totalJoin <= 1 ) { // this player into the current mini game for the first time 
220                 minigames[ miniGameId ].totalPlayer = minigames[ miniGameId ].totalPlayer + 1;
221             }
222             minigames[ miniGameId ].playerWin = msg.sender;
223             minigames[ miniGameId ].endTime = minigames[ miniGameId ].endTime + MINI_GAME_ADD_TIME_DEFAULT;
224             emit eventJoinMiniGame(p.totalJoin);
225         } else {
226             // need run end round
227             if (minigames[ miniGameId ].playerWin == 0x0) {
228                 updateShareCrystal();
229                 p.currentMiniGameId = miniGameId;
230                 p.lastMiniGameId = miniGameId;
231                 p.totalJoin = 1;
232                 p.miningWarRoundNumber = minigames[ miniGameId ].miningWarRoundNumber;
233 
234                 minigames[ miniGameId ].playerWin = msg.sender;
235             }
236             endMiniGame();
237         }
238     }
239 
240     /**
241     * @dev update share bonus for player who join the game
242     */
243     function updateShareCrystal() private
244     {
245         uint256 miningWarRoundNumber = getMiningWarRoundNumber();
246         PlayerData storage p = players[msg.sender];
247         // check current mini game of player join. if mining war start new round then reset player data 
248         if ( p.miningWarRoundNumber != miningWarRoundNumber) {
249             p.share = 0;
250             p.win = 0;
251         } else if (minigames[ p.currentMiniGameId ].ended == true && p.lastMiniGameId < p.currentMiniGameId && minigames[ p.currentMiniGameId ].miningWarRoundNumber == miningWarRoundNumber) {
252             // check current mini game of player join, last update mini game and current mining war round id
253             // require this mini game is children of mining war game( is current mining war round id ) 
254             p.share = SafeMath.add(p.share, calculateShareCrystal(p.currentMiniGameId));
255             p.lastMiniGameId = p.currentMiniGameId;
256         }
257     }
258 
259     /**
260     * @dev claim crystals
261     */
262     function claimCrystal() public
263     {
264         // should run end round
265         if ( minigames[miniGameId].endTime < now ) {
266             endMiniGame();
267         }
268         updateShareCrystal(); 
269         // update crystal for this player to main game
270         uint256 crystalBonus = players[msg.sender].win + players[msg.sender].share;
271         MiningWarContract.addCrystal(msg.sender,crystalBonus); 
272         // update player data. reset value win and share of player
273         PlayerData storage p = players[msg.sender];
274         p.win = 0;
275         p.share = 0;
276     	
277     }
278 
279     /**
280     * @dev calculate share crystal of player
281     */
282     function calculateShareCrystal(uint256 _miniGameId) public view returns(uint256 _share)
283     {
284         PlayerData memory p = players[msg.sender];
285         if ( p.lastMiniGameId >= p.currentMiniGameId && p.currentMiniGameId != 0) {
286             _share = 0;
287         } else {
288             _share = SafeMath.div( SafeMath.div( SafeMath.mul(minigames[ _miniGameId ].prizeCrystal, 50), 100 ), minigames[ _miniGameId ].totalPlayer );
289         }
290     }
291 
292     function getMiningWarDealine () private view returns( uint256 _dealine )
293     {
294         _dealine = MiningWarContract.deadline();
295     }
296 
297     function getMiningWarRoundNumber () private view returns( uint256 _roundNumber )
298     {
299         _roundNumber = MiningWarContract.roundNumber();
300     }
301 }