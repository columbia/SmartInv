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
56     address public gameSponsor;
57     struct BoostData {
58         address owner;
59         uint256 boostRate;
60         uint256 basePrice;
61     }
62     mapping(uint256 => BoostData) public boostData;
63     function getPlayerData(address /*_addr*/) 
64     public 
65     pure 
66     returns(
67         uint256 /*_engineerRoundNumber*/, 
68         uint256 /*_virusNumber*/, 
69         uint256 /*_virusDefence*/, 
70         uint256 /*_research*/, 
71         uint256 /*_researchPerDay*/, 
72         uint256 /*_lastUpdateTime*/, 
73         uint256[8] /*_engineersCount*/, 
74         uint256 /*_nextTimeAtk*/,
75         uint256 /*_endTimeUnequalledDef*/
76     ) {}
77     function fallback() public payable {}
78     function addVirus(address /*_addr*/, uint256 /*_value*/) public pure {}
79     function claimPrizePool(address /*_addr*/, uint256 /*_value*/) public pure {} 
80     function isContractMiniGame() public pure returns( bool /*_isContractMiniGame*/) {}
81 }
82 contract CryptoMiningWarInterface {
83     uint256 public deadline; 
84     uint256 public roundNumber = 0;
85     mapping(address => PlayerData) public players;
86     struct PlayerData {
87         uint256 roundNumber;
88         mapping(uint256 => uint256) minerCount;
89         uint256 hashrate;
90         uint256 crystals;
91         uint256 lastUpdateTime;
92         uint256 referral_count;
93         uint256 noQuest;
94     }
95     function getPlayerData(address /*addr*/) public pure
96     returns (
97         uint256 /*crystals*/, 
98         uint256 /*lastupdate*/, 
99         uint256 /*hashratePerDay*/, 
100         uint256[8] /*miners*/, 
101         uint256 /*hasBoost*/, 
102         uint256 /*referral_count*/, 
103         uint256 /*playerBalance*/, 
104         uint256 /*noQuest*/ 
105         ) {}
106     function getBoosterData(uint256 /*idx*/) public pure returns (address /*owner*/,uint256 /*boostRate*/, uint256 /*startingLevel*/, 
107         uint256 /*startingTime*/, uint256 /*currentPrice*/, uint256 /*halfLife*/) {}
108     function addHashrate( address /*_addr*/, uint256 /*_value*/ ) public pure {}
109     function addCrystal( address /*_addr*/, uint256 /*_value*/ ) public pure {}
110     function subCrystal( address /*_addr*/, uint256 /*_value*/ ) public pure {}
111 }
112 contract CryptoAirdropGameInterface {
113     mapping(address => PlayerData) public players;
114     struct PlayerData {
115         uint256 currentMiniGameId;
116         uint256 lastMiniGameId; 
117         uint256 win;
118         uint256 share;
119         uint256 totalJoin;
120         uint256 miningWarRoundNumber;
121     }
122     function isContractMiniGame() public pure returns( bool /*_isContractMiniGame*/ ) {}
123 }
124 contract CryptoDepositInterface {
125     uint256 public round = 0;
126     mapping(address => Player) public players;
127     struct Player {
128         uint256 currentRound;
129         uint256 lastRound;
130         uint256 reward;
131         uint256 share; // your crystals share in current round 
132     }
133     function isContractMiniGame() public pure returns( bool /*_isContractMiniGame*/ ) {}
134 }
135 contract CryptoBossWannaCryInterface {
136     mapping(address => PlayerData) public players;
137     struct PlayerData {
138         uint256 currentBossRoundNumber;
139         uint256 lastBossRoundNumber;
140         uint256 win;
141         uint256 share;
142         uint256 dame; 
143         uint256 nextTimeAtk;
144     }
145     function isContractMiniGame() public pure returns( bool /*_isContractMiniGame*/ ) {}
146 }
147 contract CryptoBeginnerQuest {
148     using SafeMath for uint256;
149 
150     address private administrator;
151     // mini game
152     CryptoEngineerInterface     public Engineer;
153     CryptoDepositInterface      public Deposit;
154     CryptoMiningWarInterface    public MiningWar;
155     CryptoAirdropGameInterface  public AirdropGame;
156     CryptoBossWannaCryInterface public BossWannaCry;
157     
158     // mining war info
159     uint256 private miningWarDeadline;
160     uint256 private miningWarRound;
161 
162     /** 
163     * @dev player information
164     */
165     mapping(address => Player)           private players;
166     // quest information
167     mapping(address => MinerQuest)       private minerQuests;
168     mapping(address => EngineerQuest)    private engineerQuests;
169     mapping(address => DepositQuest)     private depositQuests;
170     mapping(address => JoinAirdropQuest) private joinAirdropQuests;
171     mapping(address => AtkBossQuest)     private atkBossQuests;
172     mapping(address => AtkPlayerQuest)   private atkPlayerQuests;
173     mapping(address => BoosterQuest)     private boosterQuests;
174     mapping(address => RedbullQuest)     private redbullQuests;
175    
176     struct Player {
177         uint256 miningWarRound;
178         uint256 currentQuest;
179     }
180     struct MinerQuest {
181         bool ended;
182     }
183     struct EngineerQuest {
184         bool ended;
185     }
186     struct DepositQuest {
187         uint256 currentDepositRound;
188         uint256 share; // current deposit of player
189         bool ended;
190     }
191     struct JoinAirdropQuest {
192         uint256 airdropGameId;    // current airdrop game id
193         uint256 totalJoinAirdrop; // total join the airdrop game
194         bool ended;
195     }
196     struct AtkBossQuest {
197         uint256 dameBossWannaCry; // current dame boss
198         uint256 levelBossWannaCry; // current boss player atk
199         bool ended;
200     }
201     struct AtkPlayerQuest {
202         uint256 nextTimeAtkPlayer; // 
203         bool ended;
204     }
205     struct BoosterQuest {
206         bool ended;
207     }
208     struct RedbullQuest {
209         bool ended;
210     }
211 
212     event ConfirmQuest(address player, uint256 questType, uint256 reward, uint256 typeReward); // 1 : crystals, 2: hashrate, 3: virus
213     modifier isAdministrator()
214     {
215         require(msg.sender == administrator);
216         _;
217     }
218     
219     constructor() public {
220         administrator = msg.sender;
221         // init contract interface  
222         setMiningWarInterface(0xf84c61bb982041c030b8580d1634f00fffb89059);
223         setEngineerInterface(0x69fd0e5d0a93bf8bac02c154d343a8e3709adabf);
224         setAirdropGameInterface(0x5b813a2f4b58183d270975ab60700740af00a3c9);
225         setBossWannaCryInterface(0x54e96d609b183196de657fc7380032a96f27f384);
226         setDepositInterface(0xd67f271c2d3112d86d6991bfdfc8f9f27286bc4b);
227     }
228     function () public payable
229     {
230         
231     }
232     // ---------------------------------------------------------------------------------------
233     // SET INTERFACE CONTRACT
234     // ---------------------------------------------------------------------------------------
235     
236     function setMiningWarInterface(address _addr) public isAdministrator
237     {
238         MiningWar = CryptoMiningWarInterface(_addr);
239     }
240     function setEngineerInterface(address _addr) public isAdministrator
241     {
242         CryptoEngineerInterface engineerInterface = CryptoEngineerInterface(_addr);
243         
244         require(engineerInterface.isContractMiniGame() == true);
245 
246         Engineer = engineerInterface;
247     }
248     function setAirdropGameInterface(address _addr) public isAdministrator
249     {
250         CryptoAirdropGameInterface airdropGameInterface = CryptoAirdropGameInterface(_addr);
251         
252         require(airdropGameInterface.isContractMiniGame() == true);
253 
254         AirdropGame = airdropGameInterface;
255     }
256     function setBossWannaCryInterface(address _addr) public isAdministrator
257     {
258         CryptoBossWannaCryInterface bossWannaCryInterface = CryptoBossWannaCryInterface(_addr);
259         
260         require(bossWannaCryInterface.isContractMiniGame() == true);
261 
262         BossWannaCry = bossWannaCryInterface;
263     }
264     function setDepositInterface(address _addr) public isAdministrator
265     {
266         CryptoDepositInterface depositInterface = CryptoDepositInterface(_addr);
267         
268         require(depositInterface.isContractMiniGame() == true);
269 
270         Deposit = depositInterface;
271     }
272     /** 
273     * @dev MainContract used this function to verify game's contract
274     */
275     function isContractMiniGame() public pure returns( bool _isContractMiniGame )
276     {
277         _isContractMiniGame = true;
278     }
279     function upgrade(address addr) public isAdministrator
280     {
281         selfdestruct(addr);
282     }
283     /** 
284     * @dev Main Contract call this function to setup mini game.
285     */
286     function setupMiniGame( uint256 _miningWarRoundNumber, uint256 _miningWarDeadline ) public
287     {
288         miningWarDeadline = _miningWarDeadline;
289         miningWarRound    = _miningWarRoundNumber;
290     }
291     /**
292     * @dev start the mini game
293     */
294     function setupGame() public 
295     {
296         require(msg.sender == administrator);
297         require(miningWarDeadline == 0);
298         miningWarDeadline = getMiningWarDealine();
299         miningWarRound    = getMiningWarRound();
300     }
301     function confirmQuest() public 
302     {
303         if (miningWarRound != players[msg.sender].miningWarRound) {
304             players[msg.sender].currentQuest = 0;
305             players[msg.sender].miningWarRound = miningWarRound;
306         }    
307         bool _isFinish;
308         bool _ended;
309         (_isFinish, _ended) = checkQuest(msg.sender);
310         require(miningWarDeadline > now);
311         require(_isFinish == true);
312         require(_ended == false);
313 
314         if (players[msg.sender].currentQuest == 0) confirmGetFreeQuest(msg.sender);
315         if (players[msg.sender].currentQuest == 1) confirmMinerQuest(msg.sender);
316         if (players[msg.sender].currentQuest == 2) confirmEngineerQuest(msg.sender);
317         if (players[msg.sender].currentQuest == 3) confirmDepositQuest(msg.sender);
318         if (players[msg.sender].currentQuest == 4) confirmJoinAirdropQuest(msg.sender);
319         if (players[msg.sender].currentQuest == 5) confirmAtkBossQuest(msg.sender);
320         if (players[msg.sender].currentQuest == 6) confirmAtkPlayerQuest(msg.sender);
321         if (players[msg.sender].currentQuest == 7) confirmBoosterQuest(msg.sender);
322         if (players[msg.sender].currentQuest == 8) confirmRedbullQuest(msg.sender);
323 
324         if (players[msg.sender].currentQuest <= 7) addQuest(msg.sender);
325     }
326     function checkQuest(address _addr) public view returns(bool _isFinish, bool _ended) 
327     {
328         if (players[_addr].currentQuest == 0) (_isFinish, _ended) = checkGetFreeQuest(_addr);
329         if (players[_addr].currentQuest == 1) (_isFinish, _ended) = checkMinerQuest(_addr);
330         if (players[_addr].currentQuest == 2) (_isFinish, _ended) = checkEngineerQuest(_addr);
331         if (players[_addr].currentQuest == 3) (_isFinish, _ended) = checkDepositQuest(_addr);
332         if (players[_addr].currentQuest == 4) (_isFinish, _ended) = checkJoinAirdropQuest(_addr);
333         if (players[_addr].currentQuest == 5) (_isFinish, _ended) = checkAtkBossQuest(_addr);
334         if (players[_addr].currentQuest == 6) (_isFinish, _ended) = checkAtkPlayerQuest(_addr);
335         if (players[_addr].currentQuest == 7) (_isFinish, _ended) = checkBoosterQuest(_addr);
336         if (players[_addr].currentQuest == 8) (_isFinish, _ended) = checkRedbullQuest(_addr);
337     }
338     
339     function getData(address _addr) 
340     public
341     view
342     returns(
343         uint256 _miningWarRound,
344         uint256 _currentQuest,
345         bool _isFinish,
346         bool _endedQuest
347     ) {
348         Player memory p          = players[_addr];
349         _miningWarRound          = p.miningWarRound;
350         _currentQuest            = p.currentQuest;
351         if (_miningWarRound != miningWarRound) _currentQuest = 0;
352         (_isFinish, _endedQuest) = checkQuest(_addr);
353     }
354     // ---------------------------------------------------------------------------------------------------------------------------------
355     // INTERNAL 
356     // ---------------------------------------------------------------------------------------------------------------------------------
357     function addQuest(address _addr) private
358     {
359         Player storage p      = players[_addr];
360         p.currentQuest += 1;
361 
362         if (p.currentQuest == 1) addMinerQuest(_addr); 
363         if (p.currentQuest == 2) addEngineerQuest(_addr); 
364         if (p.currentQuest == 3) addDepositQuest(_addr); 
365         if (p.currentQuest == 4) addJoinAirdropQuest(_addr); 
366         if (p.currentQuest == 5) addAtkBossQuest(_addr); 
367         if (p.currentQuest == 6) addAtkPlayerQuest(_addr); 
368         if (p.currentQuest == 7) addBoosterQuest(_addr); 
369         if (p.currentQuest == 8) addRedbullQuest(_addr); 
370     }
371     // ---------------------------------------------------------------------------------------------------------------------------------
372     // CONFIRM QUEST INTERNAL 
373     // ---------------------------------------------------------------------------------------------------------------------------------
374     function confirmGetFreeQuest(address _addr) private
375     {
376         MiningWar.addCrystal(_addr, 100);
377 
378         emit ConfirmQuest(_addr, 1, 100, 1);
379     }
380     function confirmMinerQuest(address _addr) private
381     {
382         MinerQuest storage pQ = minerQuests[_addr];
383         pQ.ended = true;
384         MiningWar.addCrystal(_addr, 100);
385 
386         emit ConfirmQuest(_addr, 2, 100, 1);
387     }
388     function confirmEngineerQuest(address _addr) private
389     {
390         EngineerQuest storage pQ = engineerQuests[_addr];
391         pQ.ended = true;
392         MiningWar.addCrystal(_addr, 400);
393 
394         emit ConfirmQuest(_addr, 3, 400, 1);
395     }
396     function confirmDepositQuest(address _addr) private
397     {
398         DepositQuest storage pQ = depositQuests[_addr];
399         pQ.ended = true;
400         MiningWar.addHashrate(_addr, 200);
401 
402         emit ConfirmQuest(_addr, 4, 200, 2);
403     }
404     function confirmJoinAirdropQuest(address _addr) private
405     {
406         JoinAirdropQuest storage pQ = joinAirdropQuests[_addr];
407         pQ.ended = true;
408         Engineer.addVirus(_addr, 10);
409 
410         emit ConfirmQuest(_addr, 5, 10, 3);
411     }
412     function confirmAtkBossQuest(address _addr) private
413     {
414         AtkBossQuest storage pQ = atkBossQuests[_addr];
415         pQ.ended = true;
416         Engineer.addVirus(_addr, 10);
417 
418         emit ConfirmQuest(_addr, 6, 10, 3);
419     }
420     function confirmAtkPlayerQuest(address _addr) private
421     {
422         AtkPlayerQuest storage pQ = atkPlayerQuests[_addr];
423         pQ.ended = true;
424         MiningWar.addCrystal(_addr, 10000);
425 
426         emit ConfirmQuest(_addr, 7, 10000, 1);
427     }   
428     function confirmBoosterQuest(address _addr) private
429     {
430         BoosterQuest storage pQ = boosterQuests[_addr];
431         pQ.ended = true;
432         Engineer.addVirus(_addr, 100);
433 
434         emit ConfirmQuest(_addr, 8, 100, 3);
435     }
436     function confirmRedbullQuest(address _addr) private
437     {
438         RedbullQuest storage pQ = redbullQuests[_addr];
439         pQ.ended = true;
440         Engineer.addVirus(_addr, 100);
441 
442         emit ConfirmQuest(_addr, 9, 100, 3);
443     }
444     // --------------------------------------------------------------------------------------------------------------
445     // ADD QUEST INTERNAL
446     // --------------------------------------------------------------------------------------------------------------
447     function addMinerQuest(address _addr) private
448     {
449          MinerQuest storage pQ = minerQuests[_addr];
450          pQ.ended = false;
451     }
452     function addEngineerQuest(address _addr) private
453     {
454          EngineerQuest storage pQ = engineerQuests[_addr];
455          pQ.ended = false;
456     }
457     function addDepositQuest(address _addr) private
458     {
459         DepositQuest storage pQ = depositQuests[_addr];
460         uint256 currentDepositRound;
461         uint256 share;
462         (currentDepositRound, share) = getPlayerDepositData(_addr);
463         pQ.currentDepositRound       = currentDepositRound;
464         pQ.share                     = share;
465         pQ.ended = false;
466     }
467     function addJoinAirdropQuest(address _addr) private
468     {
469         uint256 airdropGameId;    // current airdrop game id
470         uint256 totalJoinAirdrop;
471         (airdropGameId , totalJoinAirdrop) = getPlayerAirdropGameData(_addr);
472         JoinAirdropQuest storage pQ = joinAirdropQuests[_addr];
473 
474         pQ.airdropGameId    = airdropGameId;
475         pQ.totalJoinAirdrop = totalJoinAirdrop;
476         pQ.ended = false;
477     }
478     function addAtkBossQuest(address _addr) private
479     {
480         uint256 dameBossWannaCry; // current dame boss
481         uint256 levelBossWannaCry;
482         (levelBossWannaCry, dameBossWannaCry) = getPlayerBossWannaCryData(_addr);
483 
484         AtkBossQuest storage pQ = atkBossQuests[_addr];
485         pQ.levelBossWannaCry = levelBossWannaCry;
486         pQ.dameBossWannaCry  = dameBossWannaCry;
487         pQ.ended = false;
488     }
489     function addAtkPlayerQuest(address _addr) private
490     {
491         AtkPlayerQuest storage pQ = atkPlayerQuests[_addr];
492         pQ.nextTimeAtkPlayer = getNextTimeAtkPlayer(_addr);
493         pQ.ended = false;
494     }   
495     function addBoosterQuest(address _addr) private
496     {
497         BoosterQuest storage pQ = boosterQuests[_addr];
498         pQ.ended = false;
499     }
500     function addRedbullQuest(address _addr) private
501     {
502         RedbullQuest storage pQ = redbullQuests[_addr];
503         pQ.ended = false;
504     }
505     // --------------------------------------------------------------------------------------------------------------
506     // CHECK QUEST INTERNAL
507     // --------------------------------------------------------------------------------------------------------------
508     function checkGetFreeQuest(address _addr) private view returns(bool _isFinish, bool _ended)
509     {
510         if (players[_addr].currentQuest > 0) _ended = true;
511         if (miningWarRound == getMiningWarRoundOfPlayer(_addr)) _isFinish = true;
512     }
513     function checkMinerQuest(address _addr) private view returns(bool _isFinish, bool _ended)
514     {
515         MinerQuest memory pQ = minerQuests[_addr];
516         _ended = pQ.ended;
517         if (getMinerLv1(_addr) >= 10) _isFinish = true;
518     }
519     function checkEngineerQuest(address _addr) private view returns(bool _isFinish, bool _ended)
520     {
521         EngineerQuest memory pQ = engineerQuests[_addr];
522         _ended = pQ.ended;
523         if (getEngineerLv1(_addr) >= 10) _isFinish = true;
524     }
525     function checkDepositQuest(address _addr) private view returns(bool _isFinish, bool _ended)
526     {
527         DepositQuest memory pQ = depositQuests[_addr];
528         _ended = pQ.ended;
529         uint256 currentDepositRound;
530         uint256 share;
531         (currentDepositRound, share) = getPlayerDepositData(_addr);
532         if ((currentDepositRound != pQ.currentDepositRound) || (share > pQ.share)) _isFinish = true;
533     }
534     function checkJoinAirdropQuest(address _addr) private view returns(bool _isFinish, bool _ended)
535     {
536         JoinAirdropQuest memory pQ = joinAirdropQuests[_addr];
537         _ended = pQ.ended;
538         uint256 airdropGameId;    // current airdrop game id
539         uint256 totalJoinAirdrop;
540         (airdropGameId , totalJoinAirdrop) = getPlayerAirdropGameData(_addr);
541         if (
542             (pQ.airdropGameId != airdropGameId) ||
543             (pQ.airdropGameId == airdropGameId && totalJoinAirdrop > pQ.totalJoinAirdrop)
544             ) {
545             _isFinish = true;
546         }
547     }
548     function checkAtkBossQuest(address _addr) private view returns(bool _isFinish, bool _ended)
549     {
550         AtkBossQuest memory pQ = atkBossQuests[_addr];
551         _ended = pQ.ended;
552         uint256 dameBossWannaCry; // current dame boss
553         uint256 levelBossWannaCry;
554         (levelBossWannaCry, dameBossWannaCry) = getPlayerBossWannaCryData(_addr);
555         if (
556             (pQ.levelBossWannaCry != levelBossWannaCry) ||
557             (pQ.levelBossWannaCry == levelBossWannaCry && dameBossWannaCry > pQ.dameBossWannaCry)
558             ) {
559             _isFinish = true;
560         }
561     }
562     function checkAtkPlayerQuest(address _addr) private view returns(bool _isFinish, bool _ended)
563     {
564         AtkPlayerQuest memory pQ = atkPlayerQuests[_addr];
565         _ended = pQ.ended;
566         uint256 nextTimeAtkPlayer = getNextTimeAtkPlayer(_addr);
567         if (nextTimeAtkPlayer > pQ.nextTimeAtkPlayer) _isFinish = true;
568     }   
569     function checkBoosterQuest(address _addr) private view returns(bool _isFinish, bool _ended)
570     {
571         BoosterQuest memory pQ = boosterQuests[_addr];
572         _ended = pQ.ended;
573         address[5] memory boosters = getBoosters();
574         for(uint256 idx = 0; idx < 5; idx++) {
575             if (boosters[idx] == _addr) _isFinish = true;
576         }
577 
578     }
579     function checkRedbullQuest(address _addr) private view returns(bool _isFinish, bool _ended)
580     {
581         RedbullQuest memory pQ = redbullQuests[_addr];
582         _ended = pQ.ended;
583         address[5] memory redbulls = getRedbulls();
584         for(uint256 idx = 0; idx < 5; idx++) {
585             if (redbulls[idx] == _addr) _isFinish = true;
586         }
587     }
588     // --------------------------------------------------------------------------------------------------------------
589     // INTERFACE FUNCTION INTERNAL
590     // --------------------------------------------------------------------------------------------------------------
591     // Mining War
592     function getMiningWarDealine () private view returns(uint256)
593     {
594         return MiningWar.deadline();
595     }
596     function getMiningWarRound() private view returns(uint256)
597     {
598         return MiningWar.roundNumber();
599     }
600     function getBoosters() public view returns(address[5] _boosters)
601     {
602         for (uint256 idx = 0; idx < 5; idx++) {
603             address owner;
604             (owner, , , , , ) = MiningWar.getBoosterData(idx);
605             _boosters[idx] = owner;
606         }
607     }
608     function getMinerLv1(address _addr) private view returns(uint256 _total)
609     {
610         uint256[8] memory _minersCount;
611         (, , , _minersCount, , , , ) = MiningWar.getPlayerData(_addr);
612         _total = _minersCount[0];
613     }
614     function getMiningWarRoundOfPlayer(address _addr) private view returns(uint256 _roundNumber) 
615     {
616         (_roundNumber, , , , , ) = MiningWar.players(_addr);
617     }
618     // ENGINEER
619     function getRedbulls() public view returns(address[5] _redbulls)
620     {
621         for (uint256 idx = 0; idx < 5; idx++) {
622             address owner;
623             (owner, , ) = Engineer.boostData(idx);
624             _redbulls[idx] = owner;
625         }
626     }
627     function getNextTimeAtkPlayer(address _addr) private view returns(uint256 _nextTimeAtk)
628     {
629         (, , , , , , , _nextTimeAtk,) = Engineer.getPlayerData(_addr);
630     }
631     function getEngineerLv1(address _addr) private view returns(uint256 _total)
632     {
633         uint256[8] memory _engineersCount;
634         (, , , , , , _engineersCount, ,) = Engineer.getPlayerData(_addr);
635         _total = _engineersCount[0];
636     }
637     // AIRDROP GAME
638     function getPlayerAirdropGameData(address _addr) private view returns(uint256 _currentGameId, uint256 _totalJoin)
639     {
640         (_currentGameId, , , , _totalJoin, ) = AirdropGame.players(_addr);
641     }
642     // BOSS WANNACRY
643     function getPlayerBossWannaCryData(address _addr) private view returns(uint256 _currentBossRoundNumber, uint256 _dame)
644     {
645         (_currentBossRoundNumber, , , , _dame, ) = BossWannaCry.players(_addr);
646     }
647     // DEPOSIT
648     function getPlayerDepositData(address _addr) private view returns(uint256 _currentRound, uint256 _share)
649     {
650         (_currentRound, , , _share ) = Deposit.players(_addr);
651     }
652 }