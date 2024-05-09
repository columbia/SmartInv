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
54 contract PullPayment {
55   using SafeMath for uint256;
56 
57   mapping(address => uint256) public payments;
58   uint256 public totalPayments;
59 
60   /**
61   * @dev Withdraw accumulated balance, called by payee.
62   */
63   function withdrawPayments() public {
64     address payee = msg.sender;
65     uint256 payment = payments[payee];
66 
67     require(payment != 0);
68     require(address(this).balance >= payment);
69 
70     totalPayments = totalPayments.sub(payment);
71     payments[payee] = 0;
72 
73     payee.transfer(payment);
74   }
75 
76   /**
77   * @dev Called by the payer to store the sent amount as credit to be pulled.
78   * @param dest The destination address of the funds.
79   * @param amount The amount to transfer.
80   */
81   function asyncSend(address dest, uint256 amount) internal {
82     payments[dest] = payments[dest].add(amount);
83     totalPayments = totalPayments.add(amount);
84   }
85 }
86 contract CryptoEngineerInterface {
87     uint256 public prizePool = 0;
88 
89     function subVirus(address /*_addr*/, uint256 /*_value*/) public pure {}
90     function claimPrizePool(address /*_addr*/, uint256 /*_value*/) public pure {} 
91     function fallback() public payable {}
92 
93     function isEngineerContract() external pure returns(bool) {}
94 }
95 interface CryptoMiningWarInterface {
96     function addCrystal( address /*_addr*/, uint256 /*_value*/ ) external pure;
97     function subCrystal( address /*_addr*/, uint256 /*_value*/ ) external pure;
98     function isMiningWarContract() external pure returns(bool);
99 }
100 interface MiniGameInterface {
101      function isContractMiniGame() external pure returns( bool _isContractMiniGame );
102 }
103 contract CryptoBossWannaCry is PullPayment{
104     bool init = false;
105 	address public administrator;
106     uint256 public bossRoundNumber;
107     uint256 public BOSS_HP_DEFAULT = 10000000; 
108     uint256 public HALF_TIME_ATK_BOSS = 0;
109     // engineer game infomation
110     uint256 constant public VIRUS_MINING_PERIOD = 86400; 
111     uint256 public BOSS_DEF_DEFFAULT = 0;
112     CryptoEngineerInterface public Engineer;
113     CryptoMiningWarInterface public MiningWar;
114     
115     // player information
116     mapping(address => PlayerData) public players;
117     // boss information
118     mapping(uint256 => BossData) public bossData;
119 
120     mapping(address => bool)   public miniGames;
121         
122     struct PlayerData {
123         uint256 currentBossRoundNumber;
124         uint256 lastBossRoundNumber;
125         uint256 win;
126         uint256 share;
127         uint256 dame;
128         uint256 nextTimeAtk;
129     }
130 
131     struct BossData {
132         uint256 bossRoundNumber;
133         uint256 bossHp;
134         uint256 def;
135         uint256 prizePool;
136         address playerLastAtk;
137         uint256 totalDame;
138         bool ended;
139     }
140     event eventAttackBoss(
141         uint256 bossRoundNumber,
142         address playerAtk,
143         uint256 virusAtk,
144         uint256 dame,
145         uint256 totalDame,
146         uint256 timeAtk,
147         bool isLastHit,
148         uint256 crystalsReward
149     );
150     event eventEndAtkBoss(
151         uint256 bossRoundNumber,
152         address playerWin,
153         uint256 ethBonus,
154         uint256 bossHp,
155         uint256 prizePool
156     );
157     modifier disableContract()
158     {
159         require(tx.origin == msg.sender);
160         _;
161     }
162     modifier isAdministrator()
163     {
164         require(msg.sender == administrator);
165         _;
166     }
167 
168     constructor() public {
169         administrator = msg.sender;
170         // set interface contract
171         setMiningWarInterface(0x65c347702b66ff8f1a28cf9a9768487fbe97765f);
172         setEngineerInterface(0xb2d6000d4a7fe8b1358d54a9bc21f2badf91d849);
173     }
174     function () public payable
175     {
176         
177     }
178     function isContractMiniGame() public pure returns( bool _isContractMiniGame )
179     {
180     	_isContractMiniGame = true;
181     }
182     function isBossWannaCryContract() public pure returns(bool)
183     {
184         return true;
185     }
186     /** 
187     * @dev Main Contract call this function to setup mini game.
188     */
189     function setupMiniGame( uint256 /*_miningWarRoundNumber*/, uint256 /*_miningWarDeadline*/ ) public
190     {
191     
192     }
193      //@dev use this function in case of bug
194     function upgrade(address addr) public isAdministrator
195     {
196         selfdestruct(addr);
197     }
198     // ---------------------------------------------------------------------------------------
199     // SET INTERFACE CONTRACT
200     // ---------------------------------------------------------------------------------------
201     
202     function setMiningWarInterface(address _addr) public isAdministrator
203     {
204         CryptoMiningWarInterface miningWarInterface = CryptoMiningWarInterface(_addr);
205 
206         require(miningWarInterface.isMiningWarContract() == true);
207                 
208         MiningWar = miningWarInterface;
209     }
210     function setEngineerInterface(address _addr) public isAdministrator
211     {
212         CryptoEngineerInterface engineerInterface = CryptoEngineerInterface(_addr);
213         
214         require(engineerInterface.isEngineerContract() == true);
215 
216         Engineer = engineerInterface;
217     }
218     function setContractsMiniGame( address _addr ) public isAdministrator 
219     {
220         MiniGameInterface MiniGame = MiniGameInterface( _addr );
221         if( MiniGame.isContractMiniGame() == false ) { revert(); }
222 
223         miniGames[_addr] = true;
224     }
225 
226     function setBossRoundNumber(uint256 _value) public isAdministrator
227     {
228         bossRoundNumber = _value;
229     } 
230     /**
231     * @dev remove mini game contract from main contract
232     * @param _addr mini game contract address
233     */
234     function removeContractMiniGame(address _addr) public isAdministrator
235     {
236         miniGames[_addr] = false;
237     }
238 
239     function startGame() public isAdministrator
240     {
241         require(init == false);
242         init = true;
243         bossData[bossRoundNumber].ended = true;
244     
245         startNewBoss();
246     }
247     /**
248     * @dev set defence for boss
249     * @param _value number defence
250     */
251     function setDefenceBoss(uint256 _value) public isAdministrator
252     {
253         BOSS_DEF_DEFFAULT = _value;  
254     }
255     /**
256     * @dev set HP for boss
257     * @param _value number HP default
258     */
259     function setBossHPDefault(uint256 _value) public isAdministrator
260     {
261         BOSS_HP_DEFAULT = _value;  
262     }
263     function setHalfTimeAtkBoss(uint256 _value) public isAdministrator
264     {
265         HALF_TIME_ATK_BOSS = _value;  
266     }
267     function startNewBoss() private
268     {
269         require(bossData[bossRoundNumber].ended == true);
270 
271         bossRoundNumber = bossRoundNumber + 1;
272 
273         uint256 bossHp = BOSS_HP_DEFAULT * bossRoundNumber;
274         // claim 5% of current prizePool as rewards.
275         uint256 engineerPrizePool = Engineer.prizePool();
276         uint256 prizePool = SafeMath.div(SafeMath.mul(engineerPrizePool, 5),100);
277         Engineer.claimPrizePool(address(this), prizePool); 
278 
279         bossData[bossRoundNumber] = BossData(bossRoundNumber, bossHp, BOSS_DEF_DEFFAULT, prizePool, 0x0, 0, false);
280     }
281     function endAtkBoss() private 
282     {
283         require(bossData[bossRoundNumber].ended == false);
284         require(bossData[bossRoundNumber].totalDame >= bossData[bossRoundNumber].bossHp);
285 
286         BossData storage b = bossData[bossRoundNumber];
287         b.ended = true;
288          // update eth bonus for player last hit
289         uint256 ethBonus = SafeMath.div( SafeMath.mul(b.prizePool, 5), 100 );
290 
291         if (b.playerLastAtk != 0x0) {
292             PlayerData storage p = players[b.playerLastAtk];
293             p.win =  p.win + ethBonus;
294 
295             uint256 share = SafeMath.div(SafeMath.mul(SafeMath.mul(b.prizePool, 95), p.dame), SafeMath.mul(b.totalDame, 100));
296             ethBonus += share;
297         }
298 
299         emit eventEndAtkBoss(bossRoundNumber, b.playerLastAtk, ethBonus, b.bossHp, b.prizePool);
300         startNewBoss();
301     }
302     /**
303     * @dev player atk the boss
304     * @param _value number virus for this attack boss
305     */
306     function atkBoss(uint256 _value) public disableContract
307     {
308         require(bossData[bossRoundNumber].ended == false);
309         require(bossData[bossRoundNumber].totalDame < bossData[bossRoundNumber].bossHp);
310         require(players[msg.sender].nextTimeAtk <= now);
311 
312         Engineer.subVirus(msg.sender, _value);
313         
314         uint256 rate = 50 + randomNumber(msg.sender, now, 60); // 50 - 110%
315         
316         uint256 atk = SafeMath.div(SafeMath.mul(_value, rate), 100);
317         
318         updateShareETH(msg.sender);
319 
320         // update dame
321         BossData storage b = bossData[bossRoundNumber];
322         
323         uint256 currentTotalDame = b.totalDame;
324         uint256 dame = 0;
325         if (atk > b.def) {
326             dame = SafeMath.sub(atk, b.def);
327         }
328 
329         b.totalDame = SafeMath.min(SafeMath.add(currentTotalDame, dame), b.bossHp);
330         b.playerLastAtk = msg.sender;
331 
332         dame = SafeMath.sub(b.totalDame, currentTotalDame);
333 
334         // bonus crystals
335         uint256 crystalsBonus = SafeMath.div(SafeMath.mul(dame, 5), 100);
336         MiningWar.addCrystal(msg.sender, crystalsBonus);
337         // update player
338         PlayerData storage p = players[msg.sender];
339 
340         p.nextTimeAtk = now + HALF_TIME_ATK_BOSS;
341 
342         if (p.currentBossRoundNumber == bossRoundNumber) {
343             p.dame = SafeMath.add(p.dame, dame);
344         } else {
345             p.currentBossRoundNumber = bossRoundNumber;
346             p.dame = dame;
347         }
348 
349         bool isLastHit;
350         if (b.totalDame >= b.bossHp) {
351             isLastHit = true;
352             endAtkBoss();
353         }
354         
355         // emit event attack boss
356         emit eventAttackBoss(b.bossRoundNumber, msg.sender, _value, dame, p.dame, now, isLastHit, crystalsBonus);
357     }
358  
359     function updateShareETH(address _addr) private
360     {
361         PlayerData storage p = players[_addr];
362         
363         if ( 
364             bossData[p.currentBossRoundNumber].ended == true &&
365             p.lastBossRoundNumber < p.currentBossRoundNumber
366             ) {
367             p.share = SafeMath.add(p.share, calculateShareETH(msg.sender, p.currentBossRoundNumber));
368             p.lastBossRoundNumber = p.currentBossRoundNumber;
369         }
370     }
371 
372     /**
373     * @dev calculate share Eth of player
374     */
375     function calculateShareETH(address _addr, uint256 _bossRoundNumber) public view returns(uint256 _share)
376     {
377         PlayerData memory p = players[_addr];
378         BossData memory b = bossData[_bossRoundNumber];
379         if ( 
380             p.lastBossRoundNumber >= p.currentBossRoundNumber && 
381             p.currentBossRoundNumber != 0 
382             ) {
383             _share = 0;
384         } else {
385             if (b.totalDame == 0) return 0;
386             _share = SafeMath.div(SafeMath.mul(SafeMath.mul(b.prizePool, 95), p.dame), SafeMath.mul(b.totalDame, 100)); // prizePool * 95% * playerDame / totalDame 
387         } 
388         if (b.ended == false)  _share = 0;
389     }
390     function getCurrentReward(address _addr) public view returns(uint256 _currentReward)
391     {
392         PlayerData memory p = players[_addr];
393         _currentReward = SafeMath.add(p.win, p.share);
394         _currentReward += calculateShareETH(_addr, p.currentBossRoundNumber);
395     }
396 
397     function withdrawReward(address _addr) public 
398     {
399         updateShareETH(_addr);
400         
401         PlayerData storage p = players[_addr];
402         
403         uint256 reward = SafeMath.add(p.share, p.win);
404         if (address(this).balance >= reward && reward > 0) {
405             _addr.transfer(reward);
406             // update player
407             p.win = 0;
408             p.share = 0;
409         }
410     }
411     //--------------------------------------------------------------------------
412     // INTERNAL FUNCTION
413     //--------------------------------------------------------------------------
414     function devFee(uint256 _amount) private pure returns(uint256)
415     {
416         return SafeMath.div(SafeMath.mul(_amount, 5), 100);
417     }
418     function randomNumber(address _addr, uint256 randNonce, uint256 _maxNumber) private returns(uint256)
419     {
420         return uint256(keccak256(abi.encodePacked(now, _addr, randNonce))) % _maxNumber;
421     }
422 }