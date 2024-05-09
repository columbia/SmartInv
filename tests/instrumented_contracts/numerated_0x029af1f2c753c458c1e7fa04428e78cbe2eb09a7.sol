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
67         uint256 /*_virusNumber*/, 
68         uint256 /*_currentVirus*/, 
69         uint256 /*_research*/, 
70         uint256 /*_researchPerDay*/, 
71         uint256 /*_lastUpdateTime*/, 
72         uint256[8] /*_engineersCount*/
73     ) {}
74     function fallback() public payable {}
75     function addVirus(address /*_addr*/, uint256 /*_value*/) public pure {}
76     function claimPrizePool(address /*_addr*/, uint256 /*_value*/) public pure {} 
77     function isContractMiniGame() public pure returns( bool /*_isContractMiniGame*/) {}
78     function isEngineerContract() external pure returns(bool) {}
79 }
80 contract CryptoMiningWarInterface {
81     uint256 public deadline; 
82     uint256 public roundNumber = 0;
83     mapping(address => Player) public players;
84     struct Player {
85         uint256 roundNumber;
86         mapping(uint256 => uint256) minerCount;
87         uint256 hashrate;
88         uint256 crystals;
89         uint256 lastUpdateTime;
90     }
91     function getPlayerData(address /*addr*/) public pure
92     returns (
93         uint256 /*crystals*/, 
94         uint256 /*lastupdate*/, 
95         uint256 /*hashratePerDay*/, 
96         uint256[8] /*miners*/, 
97         uint256 /*hasBoost*/, 
98         uint256 /*playerBalance*/
99         ) {}
100     function getBoosterData(uint256 /*idx*/) public pure returns (address /*owner*/,uint256 /*boostRate*/, uint256 /*startingLevel*/, 
101         uint256 /*startingTime*/, uint256 /*currentPrice*/, uint256 /*halfLife*/) {}
102     function addHashrate( address /*_addr*/, uint256 /*_value*/ ) public pure {}
103     function addCrystal( address /*_addr*/, uint256 /*_value*/ ) public pure {}
104     function subCrystal( address /*_addr*/, uint256 /*_value*/ ) public pure {}
105     function isMiningWarContract() external pure returns(bool) {}
106 }
107 contract CryptoAirdropGameInterface {
108     mapping(address => Player) public players;
109    
110     struct Player {
111         uint256 miningWarRound;
112         uint256 noJoinAirdrop; 
113         uint256 lastDayJoin;
114     }
115     function isContractMiniGame() public pure returns( bool /*_isContractMiniGame*/ ) {}
116     function isAirdropContract() external pure returns(bool) {}
117 }
118 contract CryptoDepositInterface {
119     uint256 public round = 0;
120     mapping(address => Player) public players;
121     struct Player {
122         uint256 currentRound;
123         uint256 lastRound;
124         uint256 reward;
125         uint256 share; // your crystals share in current round 
126     }
127     function isContractMiniGame() public pure returns( bool /*_isContractMiniGame*/ ) {}
128     function isDepositContract() external pure returns(bool) {}
129 }
130 contract CryptoBossWannaCryInterface {
131     mapping(address => PlayerData) public players;
132     struct PlayerData {
133         uint256 currentBossRoundNumber;
134         uint256 lastBossRoundNumber;
135         uint256 win;
136         uint256 share;
137         uint256 dame; 
138         uint256 nextTimeAtk;
139     }
140     function isContractMiniGame() public pure returns( bool /*_isContractMiniGame*/ ) {}
141     function isBossWannaCryContract() external pure returns(bool) {}
142 }
143 contract CryptoArenaInterface {
144     function getData(address /*_addr*/) public view returns(uint256 /*_virusDef*/, uint256 /*_nextTimeAtk*/, uint256 /*_endTimeUnequalledDef*/, bool    /*_canAtk*/, uint256 /*_currentVirus*/, uint256 /*_currentCrystals*/) {}
145     function isContractMiniGame() public pure returns( bool /*_isContractMiniGame*/ ) {}
146     function isArenaContract() external pure returns(bool) {}
147 }
148 contract CryptoBeginnerQuest {
149     using SafeMath for uint256;
150 
151     address private administrator;
152     // mini game
153     CryptoEngineerInterface     public Engineer;
154     CryptoDepositInterface      public Deposit;
155     CryptoMiningWarInterface    public MiningWar;
156     CryptoAirdropGameInterface  public AirdropGame;
157     CryptoBossWannaCryInterface public BossWannaCry;
158     CryptoArenaInterface        public Arena;
159     
160     // mining war info
161     address public  miningWarAddress;
162     uint256 private miningWarDeadline;
163     uint256 private miningWarRound;
164 
165     /** 
166     * @dev player information
167     */
168     mapping(address => Player)           private players;
169     // quest information
170     mapping(address => MinerQuest)       private minerQuests;
171     mapping(address => EngineerQuest)    private engineerQuests;
172     mapping(address => DepositQuest)     private depositQuests;
173     mapping(address => JoinAirdropQuest) private joinAirdropQuests;
174     mapping(address => AtkBossQuest)     private atkBossQuests;
175     mapping(address => AtkPlayerQuest)   private atkPlayerQuests;
176     mapping(address => BoosterQuest)     private boosterQuests;
177     mapping(address => RedbullQuest)     private redbullQuests;
178    
179     struct Player {
180         uint256 miningWarRound;
181         uint256 currentQuest;
182     }
183     struct MinerQuest {
184         bool ended;
185     }
186     struct EngineerQuest {
187         bool ended;
188     }
189     struct DepositQuest {
190         uint256 currentDepositRound;
191         uint256 share; // current deposit of player
192         bool ended;
193     }
194     struct JoinAirdropQuest {
195         uint256 miningWarRound;    // current airdrop game id
196         uint256 noJoinAirdrop; // total join the airdrop game
197         bool ended;
198     }
199     struct AtkBossQuest {
200         uint256 dameBossWannaCry; // current dame boss
201         uint256 levelBossWannaCry; // current boss player atk
202         bool ended;
203     }
204     struct AtkPlayerQuest {
205         uint256 nextTimeAtkPlayer; // 
206         bool ended;
207     }
208     struct BoosterQuest {
209         bool ended;
210     }
211     struct RedbullQuest {
212         bool ended;
213     }
214 
215     event ConfirmQuest(address player, uint256 questType, uint256 reward, uint256 typeReward); // 1 : crystals, 2: hashrate, 3: virus
216     modifier isAdministrator()
217     {
218         require(msg.sender == administrator);
219         _;
220     }
221     
222     constructor() public {
223         administrator = msg.sender;
224         // init contract interface  
225         setMiningWarInterface(0x1b002cd1ba79dfad65e8abfbb3a97826e4960fe5);
226 
227         setEngineerInterface(0xd7afbf5141a7f1d6b0473175f7a6b0a7954ed3d2);
228         
229         setAirdropGameInterface(0x465efa69a42273e3e368cfe3b6483ab97b3c33eb);
230         
231         setBossWannaCryInterface(0x7ea4af9805b8a0a58ce67c4b6b14cce0a1834491);
232         
233         setDepositInterface(0x134d3c5575eaaa1365d9268bb2a4b4d8fd1c5907);
234         
235         setArenaInterface(0x77c9acc811e4cf4b51dc3a3e05dc5d62fa887767);
236     }
237     function () public payable
238     {
239         
240     }
241     // ---------------------------------------------------------------------------------------
242     // SET INTERFACE CONTRACT
243     // ---------------------------------------------------------------------------------------
244     
245     function setMiningWarInterface(address _addr) public isAdministrator
246     {
247         CryptoMiningWarInterface miningWarInterface = CryptoMiningWarInterface(_addr);
248 
249         require(miningWarInterface.isMiningWarContract() == true);
250         
251         miningWarAddress = _addr;
252         
253         MiningWar = miningWarInterface;
254     }
255     function setEngineerInterface(address _addr) public isAdministrator
256     {
257         CryptoEngineerInterface engineerInterface = CryptoEngineerInterface(_addr);
258         
259         require(engineerInterface.isEngineerContract() == true);
260 
261         Engineer = engineerInterface;
262     }
263     function setAirdropGameInterface(address _addr) public isAdministrator
264     {
265         CryptoAirdropGameInterface airdropGameInterface = CryptoAirdropGameInterface(_addr);
266         
267         require(airdropGameInterface.isAirdropContract() == true);
268 
269         AirdropGame = airdropGameInterface;
270     }
271     function setBossWannaCryInterface(address _addr) public isAdministrator
272     {
273         CryptoBossWannaCryInterface bossWannaCryInterface = CryptoBossWannaCryInterface(_addr);
274         
275         require(bossWannaCryInterface.isBossWannaCryContract() == true);
276 
277         BossWannaCry = bossWannaCryInterface;
278     }
279     function setDepositInterface(address _addr) public isAdministrator
280     {
281         CryptoDepositInterface depositInterface = CryptoDepositInterface(_addr);
282         
283         require(depositInterface.isDepositContract() == true);
284 
285         Deposit = depositInterface;
286     }
287     function setArenaInterface(address _addr) public isAdministrator
288     {
289         CryptoArenaInterface arenaInterface = CryptoArenaInterface(_addr);
290         
291         require(arenaInterface.isArenaContract() == true);
292 
293         Arena = arenaInterface;
294     }
295     /** 
296     * @dev MainContract used this function to verify game's contract
297     */
298     function isContractMiniGame() public pure returns( bool _isContractMiniGame )
299     {
300         _isContractMiniGame = true;
301     }
302     function isBeginnerQuestContract() public pure returns(bool)
303     {
304         return true;
305     }
306     function upgrade(address addr) public isAdministrator
307     {
308         selfdestruct(addr);
309     }
310     function addLevelQuest(address _addr, uint256 _level) public isAdministrator
311     {
312         require(_level >= 1 && _level <= 9);
313 
314         Player storage p      = players[_addr];
315 
316         p.currentQuest = _level - 1;
317 
318         if (p.currentQuest == 1) addMinerQuest(_addr); 
319         if (p.currentQuest == 2) addEngineerQuest(_addr); 
320         if (p.currentQuest == 3) addDepositQuest(_addr); 
321         if (p.currentQuest == 4) addJoinAirdropQuest(_addr); 
322         if (p.currentQuest == 5) addAtkBossQuest(_addr); 
323         if (p.currentQuest == 6) addAtkPlayerQuest(_addr); 
324         if (p.currentQuest == 7) addBoosterQuest(_addr); 
325         if (p.currentQuest == 8) addRedbullQuest(_addr); 
326     }
327     /** 
328     * @dev Main Contract call this function to setup mini game.
329     */
330     function setupMiniGame( uint256 _miningWarRoundNumber, uint256 _miningWarDeadline ) public
331     {
332         require(msg.sender == miningWarAddress);
333 
334         miningWarDeadline = _miningWarDeadline;
335         miningWarRound    = _miningWarRoundNumber;
336     }
337     /**
338     * @dev start the mini game
339     */
340     function startGame() public 
341     {
342         require(msg.sender == administrator);
343         miningWarDeadline = getMiningWarDealine();
344         miningWarRound    = getMiningWarRound();
345     }
346     function confirmQuest() public 
347     {
348         if (miningWarRound != players[msg.sender].miningWarRound) {
349             players[msg.sender].currentQuest = 0;
350             players[msg.sender].miningWarRound = miningWarRound;
351         }    
352         bool _isFinish;
353         bool _ended;
354         (_isFinish, _ended) = checkQuest(msg.sender);
355         require(miningWarDeadline > now);
356         require(_isFinish == true);
357         require(_ended == false);
358 
359         if (players[msg.sender].currentQuest == 0) confirmGetFreeQuest(msg.sender);
360         if (players[msg.sender].currentQuest == 1) confirmMinerQuest(msg.sender);
361         if (players[msg.sender].currentQuest == 2) confirmEngineerQuest(msg.sender);
362         if (players[msg.sender].currentQuest == 3) confirmDepositQuest(msg.sender);
363         if (players[msg.sender].currentQuest == 4) confirmJoinAirdropQuest(msg.sender);
364         if (players[msg.sender].currentQuest == 5) confirmAtkBossQuest(msg.sender);
365         if (players[msg.sender].currentQuest == 6) confirmAtkPlayerQuest(msg.sender);
366         if (players[msg.sender].currentQuest == 7) confirmBoosterQuest(msg.sender);
367         if (players[msg.sender].currentQuest == 8) confirmRedbullQuest(msg.sender);
368 
369         if (players[msg.sender].currentQuest <= 7) addQuest(msg.sender);
370     }
371     function checkQuest(address _addr) public view returns(bool _isFinish, bool _ended) 
372     {
373         if (players[_addr].currentQuest == 0) (_isFinish, _ended) = checkGetFreeQuest(_addr);
374         if (players[_addr].currentQuest == 1) (_isFinish, _ended) = checkMinerQuest(_addr);
375         if (players[_addr].currentQuest == 2) (_isFinish, _ended) = checkEngineerQuest(_addr);
376         if (players[_addr].currentQuest == 3) (_isFinish, _ended) = checkDepositQuest(_addr);
377         if (players[_addr].currentQuest == 4) (_isFinish, _ended) = checkJoinAirdropQuest(_addr);
378         if (players[_addr].currentQuest == 5) (_isFinish, _ended) = checkAtkBossQuest(_addr);
379         if (players[_addr].currentQuest == 6) (_isFinish, _ended) = checkAtkPlayerQuest(_addr);
380         if (players[_addr].currentQuest == 7) (_isFinish, _ended) = checkBoosterQuest(_addr);
381         if (players[_addr].currentQuest == 8) (_isFinish, _ended) = checkRedbullQuest(_addr);
382     }
383     
384     function getData(address _addr) 
385     public
386     view
387     returns(
388         uint256 _miningWarRound,
389         uint256 _currentQuest,
390         bool _isFinish,
391         bool _endedQuest
392     ) {
393         Player memory p          = players[_addr];
394         _miningWarRound          = p.miningWarRound;
395         _currentQuest            = p.currentQuest;
396         if (_miningWarRound != miningWarRound) _currentQuest = 0;
397         (_isFinish, _endedQuest) = checkQuest(_addr);
398     }
399     // ---------------------------------------------------------------------------------------------------------------------------------
400     // INTERNAL 
401     // ---------------------------------------------------------------------------------------------------------------------------------
402     function addQuest(address _addr) private
403     {
404         Player storage p      = players[_addr];
405         p.currentQuest += 1;
406 
407         if (p.currentQuest == 1) addMinerQuest(_addr); 
408         if (p.currentQuest == 2) addEngineerQuest(_addr); 
409         if (p.currentQuest == 3) addDepositQuest(_addr); 
410         if (p.currentQuest == 4) addJoinAirdropQuest(_addr); 
411         if (p.currentQuest == 5) addAtkBossQuest(_addr); 
412         if (p.currentQuest == 6) addAtkPlayerQuest(_addr); 
413         if (p.currentQuest == 7) addBoosterQuest(_addr); 
414         if (p.currentQuest == 8) addRedbullQuest(_addr); 
415     }
416     // ---------------------------------------------------------------------------------------------------------------------------------
417     // CONFIRM QUEST INTERNAL 
418     // ---------------------------------------------------------------------------------------------------------------------------------
419     function confirmGetFreeQuest(address _addr) private
420     {
421         MiningWar.addCrystal(_addr, 100);
422 
423         emit ConfirmQuest(_addr, 1, 100, 1);
424     }
425     function confirmMinerQuest(address _addr) private
426     {
427         MinerQuest storage pQ = minerQuests[_addr];
428         pQ.ended = true;
429         MiningWar.addCrystal(_addr, 100);
430 
431         emit ConfirmQuest(_addr, 2, 100, 1);
432     }
433     function confirmEngineerQuest(address _addr) private
434     {
435         EngineerQuest storage pQ = engineerQuests[_addr];
436         pQ.ended = true;
437         MiningWar.addCrystal(_addr, 400);
438 
439         emit ConfirmQuest(_addr, 3, 400, 1);
440     }
441     function confirmDepositQuest(address _addr) private
442     {
443         DepositQuest storage pQ = depositQuests[_addr];
444         pQ.ended = true;
445         MiningWar.addHashrate(_addr, 200);
446 
447         emit ConfirmQuest(_addr, 4, 200, 2);
448     }
449     function confirmJoinAirdropQuest(address _addr) private
450     {
451         JoinAirdropQuest storage pQ = joinAirdropQuests[_addr];
452         pQ.ended = true;
453         Engineer.addVirus(_addr, 10);
454 
455         emit ConfirmQuest(_addr, 5, 10, 3);
456     }
457     function confirmAtkBossQuest(address _addr) private
458     {
459         AtkBossQuest storage pQ = atkBossQuests[_addr];
460         pQ.ended = true;
461         Engineer.addVirus(_addr, 10);
462 
463         emit ConfirmQuest(_addr, 6, 10, 3);
464     }
465     function confirmAtkPlayerQuest(address _addr) private
466     {
467         AtkPlayerQuest storage pQ = atkPlayerQuests[_addr];
468         pQ.ended = true;
469         MiningWar.addCrystal(_addr, 10000);
470 
471         emit ConfirmQuest(_addr, 7, 10000, 1);
472     }   
473     function confirmBoosterQuest(address _addr) private
474     {
475         BoosterQuest storage pQ = boosterQuests[_addr];
476         pQ.ended = true;
477         Engineer.addVirus(_addr, 100);
478 
479         emit ConfirmQuest(_addr, 8, 100, 3);
480     }
481     function confirmRedbullQuest(address _addr) private
482     {
483         RedbullQuest storage pQ = redbullQuests[_addr];
484         pQ.ended = true;
485         Engineer.addVirus(_addr, 100);
486 
487         emit ConfirmQuest(_addr, 9, 100, 3);
488     }
489     // --------------------------------------------------------------------------------------------------------------
490     // ADD QUEST INTERNAL
491     // --------------------------------------------------------------------------------------------------------------
492     function addMinerQuest(address _addr) private
493     {
494          MinerQuest storage pQ = minerQuests[_addr];
495          pQ.ended = false;
496     }
497     function addEngineerQuest(address _addr) private
498     {
499          EngineerQuest storage pQ = engineerQuests[_addr];
500          pQ.ended = false;
501     }
502     function addDepositQuest(address _addr) private
503     {
504         DepositQuest storage pQ = depositQuests[_addr];
505         uint256 currentDepositRound;
506         uint256 share;
507         (currentDepositRound, share) = getPlayerDepositData(_addr);
508         pQ.currentDepositRound       = currentDepositRound;
509         pQ.share                     = share;
510         pQ.ended = false;
511     }
512     function addJoinAirdropQuest(address _addr) private
513     {
514 
515         uint256 miningWarRound;    // current airdrop game id
516         uint256 noJoinAirdrop;
517         (miningWarRound , noJoinAirdrop) = getPlayerAirdropGameData(_addr);
518         JoinAirdropQuest storage pQ = joinAirdropQuests[_addr];
519 
520         pQ.miningWarRound= miningWarRound;
521         pQ.noJoinAirdrop = noJoinAirdrop;
522         pQ.ended = false;
523     }
524     function addAtkBossQuest(address _addr) private
525     {
526         uint256 dameBossWannaCry; // current dame boss
527         uint256 levelBossWannaCry;
528         (levelBossWannaCry, dameBossWannaCry) = getPlayerBossWannaCryData(_addr);
529 
530         AtkBossQuest storage pQ = atkBossQuests[_addr];
531         pQ.levelBossWannaCry = levelBossWannaCry;
532         pQ.dameBossWannaCry  = dameBossWannaCry;
533         pQ.ended = false;
534     }
535     function addAtkPlayerQuest(address _addr) private
536     {
537         AtkPlayerQuest storage pQ = atkPlayerQuests[_addr];
538         pQ.nextTimeAtkPlayer = getNextTimeAtkPlayer(_addr);
539         pQ.ended = false;
540     }   
541     function addBoosterQuest(address _addr) private
542     {
543         BoosterQuest storage pQ = boosterQuests[_addr];
544         pQ.ended = false;
545     }
546     function addRedbullQuest(address _addr) private
547     {
548         RedbullQuest storage pQ = redbullQuests[_addr];
549         pQ.ended = false;
550     }
551     // --------------------------------------------------------------------------------------------------------------
552     // CHECK QUEST INTERNAL
553     // --------------------------------------------------------------------------------------------------------------
554     function checkGetFreeQuest(address _addr) private view returns(bool _isFinish, bool _ended)
555     {
556         if (players[_addr].currentQuest > 0) _ended = true;
557         if (miningWarRound == getMiningWarRoundOfPlayer(_addr)) _isFinish = true;
558     }
559     function checkMinerQuest(address _addr) private view returns(bool _isFinish, bool _ended)
560     {
561         MinerQuest memory pQ = minerQuests[_addr];
562         _ended = pQ.ended;
563         if (getMinerLv1(_addr) >= 10) _isFinish = true;
564     }
565     function checkEngineerQuest(address _addr) private view returns(bool _isFinish, bool _ended)
566     {
567         EngineerQuest memory pQ = engineerQuests[_addr];
568         _ended = pQ.ended;
569         if (getEngineerLv1(_addr) >= 10) _isFinish = true;
570     }
571     function checkDepositQuest(address _addr) private view returns(bool _isFinish, bool _ended)
572     {
573         DepositQuest memory pQ = depositQuests[_addr];
574         _ended = pQ.ended;
575         uint256 currentDepositRound;
576         uint256 share;
577         (currentDepositRound, share) = getPlayerDepositData(_addr);
578         if ((currentDepositRound != pQ.currentDepositRound) || (share > pQ.share)) _isFinish = true;
579     }
580     function checkJoinAirdropQuest(address _addr) private view returns(bool _isFinish, bool _ended)
581     {
582         JoinAirdropQuest memory pQ = joinAirdropQuests[_addr];
583         _ended = pQ.ended;
584         uint256 miningWarRound;    // current airdrop game id
585         uint256 noJoinAirdrop;
586         (miningWarRound , noJoinAirdrop) = getPlayerAirdropGameData(_addr);
587         if (
588             (pQ.miningWarRound != miningWarRound) ||
589             (pQ.miningWarRound == miningWarRound && noJoinAirdrop > pQ.noJoinAirdrop)
590             ) {
591             _isFinish = true;
592         }
593     }
594     function checkAtkBossQuest(address _addr) private view returns(bool _isFinish, bool _ended)
595     {
596         AtkBossQuest memory pQ = atkBossQuests[_addr];
597         _ended = pQ.ended;
598         uint256 dameBossWannaCry; // current dame boss
599         uint256 levelBossWannaCry;
600         (levelBossWannaCry, dameBossWannaCry) = getPlayerBossWannaCryData(_addr);
601         if (
602             (pQ.levelBossWannaCry != levelBossWannaCry) ||
603             (pQ.levelBossWannaCry == levelBossWannaCry && dameBossWannaCry > pQ.dameBossWannaCry)
604             ) {
605             _isFinish = true;
606         }
607     }
608     function checkAtkPlayerQuest(address _addr) private view returns(bool _isFinish, bool _ended)
609     {
610         AtkPlayerQuest memory pQ = atkPlayerQuests[_addr];
611         _ended = pQ.ended;
612         uint256 nextTimeAtkPlayer = getNextTimeAtkPlayer(_addr);
613         if (nextTimeAtkPlayer > pQ.nextTimeAtkPlayer) _isFinish = true;
614     }   
615     function checkBoosterQuest(address _addr) private view returns(bool _isFinish, bool _ended)
616     {
617         BoosterQuest memory pQ = boosterQuests[_addr];
618         _ended = pQ.ended;
619         address[5] memory boosters = getBoosters();
620         for(uint256 idx = 0; idx < 5; idx++) {
621             if (boosters[idx] == _addr) _isFinish = true;
622         }
623 
624     }
625     function checkRedbullQuest(address _addr) private view returns(bool _isFinish, bool _ended)
626     {
627         RedbullQuest memory pQ = redbullQuests[_addr];
628         _ended = pQ.ended;
629         address[5] memory redbulls = getRedbulls();
630         for(uint256 idx = 0; idx < 5; idx++) {
631             if (redbulls[idx] == _addr) _isFinish = true;
632         }
633     }
634     // --------------------------------------------------------------------------------------------------------------
635     // INTERFACE FUNCTION INTERNAL
636     // --------------------------------------------------------------------------------------------------------------
637     // Mining War
638     function getMiningWarDealine () private view returns(uint256)
639     {
640         return MiningWar.deadline();
641     }
642     function getMiningWarRound() private view returns(uint256)
643     {
644         return MiningWar.roundNumber();
645     }
646     function getBoosters() public view returns(address[5] _boosters)
647     {
648         for (uint256 idx = 0; idx < 5; idx++) {
649             address owner;
650             (owner, , , , , ) = MiningWar.getBoosterData(idx);
651             _boosters[idx] = owner;
652         }
653     }
654     function getMinerLv1(address _addr) private view returns(uint256 _total)
655     {
656         uint256[8] memory _minersCount;
657         (, , , _minersCount, , ) = MiningWar.getPlayerData(_addr);
658         _total = _minersCount[0];
659     }
660     function getMiningWarRoundOfPlayer(address _addr) private view returns(uint256 _roundNumber) 
661     {
662         (_roundNumber, , , ) = MiningWar.players(_addr);
663     }
664     // ENGINEER
665     function getRedbulls() public view returns(address[5] _redbulls)
666     {
667         for (uint256 idx = 0; idx < 5; idx++) {
668             address owner;
669             (owner, , ) = Engineer.boostData(idx);
670             _redbulls[idx] = owner;
671         }
672     }
673     function getNextTimeAtkPlayer(address _addr) private view returns(uint256 _nextTimeAtk)
674     {
675         (, _nextTimeAtk, , , , ) = Arena.getData(_addr);
676     }
677     function getEngineerLv1(address _addr) private view returns(uint256 _total)
678     {
679         uint256[8] memory _engineersCount;
680         (, , , , , _engineersCount) = Engineer.getPlayerData(_addr);
681         _total = _engineersCount[0];
682     }
683     // AIRDROP GAME
684     function getPlayerAirdropGameData(address _addr) private view returns(uint256 miningWarRound, uint256 noJoinAirdrop)
685     {
686         (miningWarRound, noJoinAirdrop, ) = AirdropGame.players(_addr);
687     }
688     // BOSS WANNACRY
689     function getPlayerBossWannaCryData(address _addr) private view returns(uint256 _currentBossRoundNumber, uint256 _dame)
690     {
691         (_currentBossRoundNumber, , , , _dame, ) = BossWannaCry.players(_addr);
692     }
693     // DEPOSIT
694     function getPlayerDepositData(address _addr) private view returns(uint256 _currentRound, uint256 _share)
695     {
696         (_currentRound, , , _share ) = Deposit.players(_addr);
697     }
698 }