1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5     /**
6     * @dev Multiplies two numbers, throws on overflow.
7     */
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     /**
18     * @dev Integer division of two numbers, truncating the quotient.
19     */
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return c;
25     }
26 
27     /**
28     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29     */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     /**
36     * @dev Adds two numbers, throws on overflow.
37     */
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 
44     function min(uint256 a, uint256 b) internal pure returns (uint256) {
45         return a < b ? a : b;
46     }
47 }
48 contract PullPayment {
49   using SafeMath for uint256;
50 
51   mapping(address => uint256) public payments;
52   uint256 public totalPayments;
53 
54   /**
55   * @dev Withdraw accumulated balance, called by payee.
56   */
57   function withdrawPayments() public {
58     address payee = msg.sender;
59     uint256 payment = payments[payee];
60 
61     require(payment != 0);
62     require(address(this).balance >= payment);
63 
64     totalPayments = totalPayments.sub(payment);
65     payments[payee] = 0;
66 
67     payee.transfer(payment);
68   }
69 
70   /**
71   * @dev Called by the payer to store the sent amount as credit to be pulled.
72   * @param dest The destination address of the funds.
73   * @param amount The amount to transfer.
74   */
75   function asyncSend(address dest, uint256 amount) internal {
76     payments[dest] = payments[dest].add(amount);
77     totalPayments = totalPayments.add(amount);
78   }
79 }
80 contract CryptoEngineerInterface {
81     uint256 public prizePool = 0;
82 
83     function calculateCurrentVirus(address /*_addr*/) public pure returns(uint256 /*_currentVirus*/) {}
84     function subVirus(address /*_addr*/, uint256 /*_value*/) public {}
85     function claimPrizePool(address /*_addr*/, uint256 /*_value*/) public {} 
86     function fallback() public payable {}
87 }
88 interface CryptoMiningWarInterface {
89     function addCrystal( address /*_addr*/, uint256 /*_value*/ ) external;
90     function subCrystal( address /*_addr*/, uint256 /*_value*/ ) external;
91 }
92 contract CryptoBossWannaCry is PullPayment{
93     bool init = false;
94 	address public administrator;
95     uint256 public bossRoundNumber;
96     uint256 private randNonce;
97     uint256 constant public BOSS_HP_DEFAULT = 100000; 
98     uint256 public HALF_TIME_ATK_BOSS = 0;
99     // engineer game infomation
100     uint256 constant public VIRUS_MINING_PERIOD = 86400; 
101     uint256 public BOSS_DEF_DEFFAULT = 0;
102     CryptoEngineerInterface public EngineerContract;
103     CryptoMiningWarInterface public MiningwarContract;
104     
105     // player information
106     mapping(address => PlayerData) public players;
107     // boss information
108     mapping(uint256 => BossData) public bossData;
109         
110     struct PlayerData {
111         uint256 currentBossRoundNumber;
112         uint256 lastBossRoundNumber;
113         uint256 win;
114         uint256 share;
115         uint256 dame; 
116         uint256 nextTimeAtk;
117     }
118 
119     struct BossData {
120         uint256 bossRoundNumber;
121         uint256 bossHp;
122         uint256 def;
123         uint256 prizePool;
124         address playerLastAtk;
125         uint256 totalDame;
126         bool ended;
127     }
128     event eventAttackBoss(
129         uint256 bossRoundNumber,
130         address playerAtk,
131         uint256 virusAtk,
132         uint256 dame,
133         uint256 timeAtk,
134         bool isLastHit,
135         uint256 crystalsReward
136     );
137     event eventEndAtkBoss(
138         uint256 bossRoundNumber,
139         address playerWin,
140         uint256 ethBonus
141     );
142     modifier disableContract()
143     {
144         require(tx.origin == msg.sender);
145         _;
146     }
147     modifier isAdministrator()
148     {
149         require(msg.sender == administrator);
150         _;
151     }
152 
153     constructor() public {
154         administrator = msg.sender;
155         // set interface main contract
156         EngineerContract = CryptoEngineerInterface(0x69fd0e5d0a93bf8bac02c154d343a8e3709adabf);
157         MiningwarContract = CryptoMiningWarInterface(0xf84c61bb982041c030b8580d1634f00fffb89059);
158     }
159     function () public payable
160     {
161         
162     }
163     function isContractMiniGame() public pure returns( bool _isContractMiniGame )
164     {
165     	_isContractMiniGame = true;
166     }
167 
168     /** 
169     * @dev Main Contract call this function to setup mini game.
170     */
171     function setupMiniGame( uint256 /*_miningWarRoundNumber*/, uint256 /*_miningWarDeadline*/ ) public
172     {
173     
174     }
175      //@dev use this function in case of bug
176     function upgrade(address addr) public 
177     {
178         require(msg.sender == administrator);
179         selfdestruct(addr);
180     }
181 
182     function startGame() public isAdministrator
183     {
184         require(init == false);
185         init = true;
186         bossData[bossRoundNumber].ended = true;
187     
188         startNewBoss();
189     }
190     /**
191     * @dev set defence for boss
192     * @param _value number defence
193     */
194     function setDefenceBoss(uint256 _value) public isAdministrator
195     {
196         BOSS_DEF_DEFFAULT = _value;  
197     }
198     function setHalfTimeAtkBoss(uint256 _value) public isAdministrator
199     {
200         HALF_TIME_ATK_BOSS = _value;  
201     }
202     function startNewBoss() private
203     {
204         require(bossData[bossRoundNumber].ended == true);
205 
206         bossRoundNumber = bossRoundNumber + 1;
207 
208         uint256 bossHp = BOSS_HP_DEFAULT * bossRoundNumber;
209         // claim 5% of current prizePool as rewards.
210         uint256 engineerPrizePool = getEngineerPrizePool();
211         uint256 prizePool = SafeMath.div(SafeMath.mul(engineerPrizePool, 5),100);
212         EngineerContract.claimPrizePool(address(this), prizePool); 
213 
214         bossData[bossRoundNumber] = BossData(bossRoundNumber, bossHp, BOSS_DEF_DEFFAULT, prizePool, 0x0, 0, false);
215     }
216     function endAtkBoss() private 
217     {
218         require(bossData[bossRoundNumber].ended == false);
219         require(bossData[bossRoundNumber].totalDame >= bossData[bossRoundNumber].bossHp);
220 
221         BossData storage b = bossData[bossRoundNumber];
222         b.ended = true;
223          // update eth bonus for player last hit
224         uint256 ethBonus = SafeMath.div( SafeMath.mul(b.prizePool, 5), 100 );
225 
226         if (b.playerLastAtk != 0x0) {
227             PlayerData storage p = players[b.playerLastAtk];
228             p.win =  p.win + ethBonus;
229         }
230 
231         emit eventEndAtkBoss(bossRoundNumber, b.playerLastAtk, ethBonus);
232         startNewBoss();
233     }
234     /**
235     * @dev player atk the boss
236     * @param _value number virus for this attack boss
237     */
238     function atkBoss(uint256 _value) public disableContract
239     {
240         require(bossData[bossRoundNumber].ended == false);
241         require(bossData[bossRoundNumber].totalDame < bossData[bossRoundNumber].bossHp);
242         require(players[msg.sender].nextTimeAtk <= now);
243 
244         uint256 currentVirus = getEngineerCurrentVirus(msg.sender);        
245         if (_value > currentVirus) { revert(); }
246         EngineerContract.subVirus(msg.sender, _value);
247         
248         uint256 rate = 50 + randomNumber(msg.sender, 100); // 50 -150%
249         
250         uint256 atk = SafeMath.div(SafeMath.mul(_value, rate), 100);
251         
252         updateShareETH(msg.sender);
253 
254         // update dame
255         BossData storage b = bossData[bossRoundNumber];
256         
257         uint256 currentTotalDame = b.totalDame;
258         uint256 dame = 0;
259         if (atk > b.def) {
260             dame = SafeMath.sub(atk, b.def);
261         }
262 
263         b.totalDame = SafeMath.min(SafeMath.add(currentTotalDame, dame), b.bossHp);
264         b.playerLastAtk = msg.sender;
265 
266         dame = SafeMath.sub(b.totalDame, currentTotalDame);
267 
268         // bonus crystals
269         uint256 crystalsBonus = SafeMath.div(SafeMath.mul(dame, 5), 100);
270         MiningwarContract.addCrystal(msg.sender, crystalsBonus);
271         // update player
272         PlayerData storage p = players[msg.sender];
273 
274         p.nextTimeAtk = now + HALF_TIME_ATK_BOSS;
275 
276         if (p.currentBossRoundNumber == bossRoundNumber) {
277             p.dame = SafeMath.add(p.dame, dame);
278         } else {
279             p.currentBossRoundNumber = bossRoundNumber;
280             p.dame = dame;
281         }
282 
283         bool isLastHit;
284         if (b.totalDame >= b.bossHp) {
285             isLastHit = true;
286             endAtkBoss();
287         }
288         
289         // emit event attack boss
290         emit eventAttackBoss(b.bossRoundNumber, msg.sender, _value, dame, now, isLastHit, crystalsBonus);
291     }
292  
293     function updateShareETH(address _addr) private
294     {
295         PlayerData storage p = players[_addr];
296         
297         if ( 
298             bossData[p.currentBossRoundNumber].ended == true &&
299             p.lastBossRoundNumber < p.currentBossRoundNumber
300             ) {
301             p.share = SafeMath.add(p.share, calculateShareETH(msg.sender, p.currentBossRoundNumber));
302             p.lastBossRoundNumber = p.currentBossRoundNumber;
303         }
304     }
305 
306     /**
307     * @dev calculate share Eth of player
308     */
309     function calculateShareETH(address _addr, uint256 _bossRoundNumber) public view returns(uint256 _share)
310     {
311         PlayerData memory p = players[_addr];
312         BossData memory b = bossData[_bossRoundNumber];
313         if ( 
314             p.lastBossRoundNumber >= p.currentBossRoundNumber && 
315             p.currentBossRoundNumber != 0 
316             ) {
317             _share = 0;
318         } else {
319             _share = SafeMath.div(SafeMath.mul(SafeMath.mul(b.prizePool, 95), p.dame), SafeMath.mul(b.totalDame, 100)); // prizePool * 95% * playerDame / totalDame 
320         } 
321         if (b.ended == false) {
322             _share = 0;
323         }
324     }
325 
326     function withdrawReward() public disableContract
327     {
328         updateShareETH(msg.sender);
329         PlayerData storage p = players[msg.sender];
330         
331         uint256 reward = SafeMath.add(p.share, p.win);
332         msg.sender.send(reward);
333         // update player
334         p.win = 0;
335         p.share = 0;
336     }
337     //--------------------------------------------------------------------------
338     // INTERNAL FUNCTION
339     //--------------------------------------------------------------------------
340     function devFee(uint256 _amount) private pure returns(uint256)
341     {
342         return SafeMath.div(SafeMath.mul(_amount, 5), 100);
343     }
344     function randomNumber(address _addr, uint256 _maxNumber) private returns(uint256)
345     {
346         randNonce = randNonce + 1;
347         return uint256(keccak256(abi.encodePacked(now, _addr, randNonce))) % _maxNumber;
348     }
349     function getEngineerPrizePool() private view returns(uint256 _prizePool)
350     {
351         _prizePool = EngineerContract.prizePool();
352     }
353     function getEngineerCurrentVirus(address _addr) private view returns(uint256 _currentVirus)
354     {
355         _currentVirus = EngineerContract.calculateCurrentVirus(_addr);
356         _currentVirus = SafeMath.div(_currentVirus, VIRUS_MINING_PERIOD);
357     }
358 }