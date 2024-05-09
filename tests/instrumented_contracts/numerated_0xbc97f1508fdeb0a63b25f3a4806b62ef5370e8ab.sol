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
147 contract CryptoArenaInterface {
148     function getData(address /*_addr*/) public view returns(uint256 /*_virusDef*/, uint256 /*_nextTimeAtk*/, uint256 /*_endTimeUnequalledDef*/, bool    /*_canAtk*/, uint256 /*_currentVirus*/, uint256 /*_currentCrystals*/) {}
149     function isContractMiniGame() public pure returns( bool /*_isContractMiniGame*/ ) {}
150 }
151 contract CryptoBeginnerQuest {
152     using SafeMath for uint256;
153 
154     address private administrator;
155     address public miningWarAddress;
156     // mini game
157     CryptoEngineerInterface     public Engineer;
158     CryptoDepositInterface      public Deposit;
159     CryptoMiningWarInterface    public MiningWar;
160     CryptoAirdropGameInterface  public AirdropGame;
161     CryptoBossWannaCryInterface public BossWannaCry;
162     CryptoArenaInterface        public Arena;
163     
164     // mining war info
165     uint256 private miningWarDeadline;
166     uint256 private miningWarRound;
167 
168     /** 
169     * @dev player information
170     */
171     mapping(address => Player)           private players;
172     // quest information
173     mapping(address => MinerQuest)       private minerQuests;
174     mapping(address => EngineerQuest)    private engineerQuests;
175     mapping(address => DepositQuest)     private depositQuests;
176     mapping(address => JoinAirdropQuest) private joinAirdropQuests;
177     mapping(address => AtkBossQuest)     private atkBossQuests;
178     mapping(address => AtkPlayerQuest)   private atkPlayerQuests;
179     mapping(address => BoosterQuest)     private boosterQuests;
180     mapping(address => RedbullQuest)     private redbullQuests;
181    
182     struct Player {
183         uint256 miningWarRound;
184         uint256 currentQuest;
185     }
186     struct MinerQuest {
187         bool ended;
188     }
189     struct EngineerQuest {
190         bool ended;
191     }
192     struct DepositQuest {
193         uint256 currentDepositRound;
194         uint256 share; // current deposit of player
195         bool ended;
196     }
197     struct JoinAirdropQuest {
198         uint256 airdropGameId;    // current airdrop game id
199         uint256 totalJoinAirdrop; // total join the airdrop game
200         bool ended;
201     }
202     struct AtkBossQuest {
203         uint256 dameBossWannaCry; // current dame boss
204         uint256 levelBossWannaCry; // current boss player atk
205         bool ended;
206     }
207     struct AtkPlayerQuest {
208         uint256 nextTimeAtkPlayer; // 
209         bool ended;
210     }
211     struct BoosterQuest {
212         bool ended;
213     }
214     struct RedbullQuest {
215         bool ended;
216     }
217 
218     event ConfirmQuest(address player, uint256 questType, uint256 reward, uint256 typeReward); // 1 : crystals, 2: hashrate, 3: virus
219     modifier isAdministrator()
220     {
221         require(msg.sender == administrator);
222         _;
223     }
224     
225     constructor() public {
226         administrator = msg.sender;
227         // init contract interface  
228         setMiningWarInterface(0xf84c61bb982041c030b8580d1634f00fffb89059);
229         setEngineerInterface(0x69fd0e5d0a93bf8bac02c154d343a8e3709adabf);
230         setAirdropGameInterface(0x5b813a2f4b58183d270975ab60700740af00a3c9);
231         setBossWannaCryInterface(0x54e96d609b183196de657fc7380032a96f27f384);
232         setDepositInterface(0x9712f804721078550656f7868aa58a16b63592c3);
233         setArenaInterface(0xce6c5ef2ed8f6171331830c018900171dcbd65ac);
234     }
235     function () public payable
236     {
237         
238     }
239     // ---------------------------------------------------------------------------------------
240     // SET INTERFACE CONTRACT
241     // ---------------------------------------------------------------------------------------
242     
243     function setMiningWarInterface(address _addr) public isAdministrator
244     {
245         miningWarAddress = _addr;
246         MiningWar = CryptoMiningWarInterface(_addr);
247     }
248     function setEngineerInterface(address _addr) public isAdministrator
249     {
250         CryptoEngineerInterface engineerInterface = CryptoEngineerInterface(_addr);
251         
252         require(engineerInterface.isContractMiniGame() == true);
253 
254         Engineer = engineerInterface;
255     }
256     function setAirdropGameInterface(address _addr) public isAdministrator
257     {
258         CryptoAirdropGameInterface airdropGameInterface = CryptoAirdropGameInterface(_addr);
259         
260         require(airdropGameInterface.isContractMiniGame() == true);
261 
262         AirdropGame = airdropGameInterface;
263     }
264     function setBossWannaCryInterface(address _addr) public isAdministrator
265     {
266         CryptoBossWannaCryInterface bossWannaCryInterface = CryptoBossWannaCryInterface(_addr);
267         
268         require(bossWannaCryInterface.isContractMiniGame() == true);
269 
270         BossWannaCry = bossWannaCryInterface;
271     }
272     function setDepositInterface(address _addr) public isAdministrator
273     {
274         CryptoDepositInterface depositInterface = CryptoDepositInterface(_addr);
275         
276         require(depositInterface.isContractMiniGame() == true);
277 
278         Deposit = depositInterface;
279     }
280     function setArenaInterface(address _addr) public isAdministrator
281     {
282         CryptoArenaInterface arenaInterface = CryptoArenaInterface(_addr);
283         
284         require(arenaInterface.isContractMiniGame() == true);
285 
286         Arena = arenaInterface;
287     }
288     /** 
289     * @dev MainContract used this function to verify game's contract
290     */
291     function isContractMiniGame() public pure returns( bool _isContractMiniGame )
292     {
293         _isContractMiniGame = true;
294     }
295     function upgrade(address addr) public isAdministrator
296     {
297         selfdestruct(addr);
298     }
299     function addLevelQuest(address _addr, uint256 _level) public isAdministrator
300     {
301         require(_level >= 1 && _level <= 9);
302 
303         Player storage p      = players[_addr];
304 
305         p.currentQuest = _level - 1;
306 
307         if (p.currentQuest == 1) addMinerQuest(_addr); 
308         if (p.currentQuest == 2) addEngineerQuest(_addr); 
309         if (p.currentQuest == 3) addDepositQuest(_addr); 
310         if (p.currentQuest == 4) addJoinAirdropQuest(_addr); 
311         if (p.currentQuest == 5) addAtkBossQuest(_addr); 
312         if (p.currentQuest == 6) addAtkPlayerQuest(_addr); 
313         if (p.currentQuest == 7) addBoosterQuest(_addr); 
314         if (p.currentQuest == 8) addRedbullQuest(_addr); 
315     }
316     /** 
317     * @dev Main Contract call this function to setup mini game.
318     */
319     function setupMiniGame( uint256 _miningWarRoundNumber, uint256 _miningWarDeadline ) public
320     {
321         require(msg.sender == miningWarAddress);
322 
323         miningWarDeadline = _miningWarDeadline;
324         miningWarRound    = _miningWarRoundNumber;
325     }
326     /**
327     * @dev start the mini game
328     */
329     function setupGame() public 
330     {
331         require(msg.sender == administrator);
332         require(miningWarDeadline == 0);
333         miningWarDeadline = getMiningWarDealine();
334         miningWarRound    = getMiningWarRound();
335     }
336     function confirmQuest() public 
337     {
338         if (miningWarRound != players[msg.sender].miningWarRound) {
339             players[msg.sender].currentQuest = 0;
340             players[msg.sender].miningWarRound = miningWarRound;
341         }    
342         bool _isFinish;
343         bool _ended;
344         (_isFinish, _ended) = checkQuest(msg.sender);
345         require(miningWarDeadline > now);
346         require(_isFinish == true);
347         require(_ended == false);
348 
349         if (players[msg.sender].currentQuest == 0) confirmGetFreeQuest(msg.sender);
350         if (players[msg.sender].currentQuest == 1) confirmMinerQuest(msg.sender);
351         if (players[msg.sender].currentQuest == 2) confirmEngineerQuest(msg.sender);
352         if (players[msg.sender].currentQuest == 3) confirmDepositQuest(msg.sender);
353         if (players[msg.sender].currentQuest == 4) confirmJoinAirdropQuest(msg.sender);
354         if (players[msg.sender].currentQuest == 5) confirmAtkBossQuest(msg.sender);
355         if (players[msg.sender].currentQuest == 6) confirmAtkPlayerQuest(msg.sender);
356         if (players[msg.sender].currentQuest == 7) confirmBoosterQuest(msg.sender);
357         if (players[msg.sender].currentQuest == 8) confirmRedbullQuest(msg.sender);
358 
359         if (players[msg.sender].currentQuest <= 7) addQuest(msg.sender);
360     }
361     function checkQuest(address _addr) public view returns(bool _isFinish, bool _ended) 
362     {
363         if (players[_addr].currentQuest == 0) (_isFinish, _ended) = checkGetFreeQuest(_addr);
364         if (players[_addr].currentQuest == 1) (_isFinish, _ended) = checkMinerQuest(_addr);
365         if (players[_addr].currentQuest == 2) (_isFinish, _ended) = checkEngineerQuest(_addr);
366         if (players[_addr].currentQuest == 3) (_isFinish, _ended) = checkDepositQuest(_addr);
367         if (players[_addr].currentQuest == 4) (_isFinish, _ended) = checkJoinAirdropQuest(_addr);
368         if (players[_addr].currentQuest == 5) (_isFinish, _ended) = checkAtkBossQuest(_addr);
369         if (players[_addr].currentQuest == 6) (_isFinish, _ended) = checkAtkPlayerQuest(_addr);
370         if (players[_addr].currentQuest == 7) (_isFinish, _ended) = checkBoosterQuest(_addr);
371         if (players[_addr].currentQuest == 8) (_isFinish, _ended) = checkRedbullQuest(_addr);
372     }
373     
374     function getData(address _addr) 
375     public
376     view
377     returns(
378         uint256 _miningWarRound,
379         uint256 _currentQuest,
380         bool _isFinish,
381         bool _endedQuest
382     ) {
383         Player memory p          = players[_addr];
384         _miningWarRound          = p.miningWarRound;
385         _currentQuest            = p.currentQuest;
386         if (_miningWarRound != miningWarRound) _currentQuest = 0;
387         (_isFinish, _endedQuest) = checkQuest(_addr);
388     }
389     // ---------------------------------------------------------------------------------------------------------------------------------
390     // INTERNAL 
391     // ---------------------------------------------------------------------------------------------------------------------------------
392     function addQuest(address _addr) private
393     {
394         Player storage p      = players[_addr];
395         p.currentQuest += 1;
396 
397         if (p.currentQuest == 1) addMinerQuest(_addr); 
398         if (p.currentQuest == 2) addEngineerQuest(_addr); 
399         if (p.currentQuest == 3) addDepositQuest(_addr); 
400         if (p.currentQuest == 4) addJoinAirdropQuest(_addr); 
401         if (p.currentQuest == 5) addAtkBossQuest(_addr); 
402         if (p.currentQuest == 6) addAtkPlayerQuest(_addr); 
403         if (p.currentQuest == 7) addBoosterQuest(_addr); 
404         if (p.currentQuest == 8) addRedbullQuest(_addr); 
405     }
406     // ---------------------------------------------------------------------------------------------------------------------------------
407     // CONFIRM QUEST INTERNAL 
408     // ---------------------------------------------------------------------------------------------------------------------------------
409     function confirmGetFreeQuest(address _addr) private
410     {
411         MiningWar.addCrystal(_addr, 100);
412 
413         emit ConfirmQuest(_addr, 1, 100, 1);
414     }
415     function confirmMinerQuest(address _addr) private
416     {
417         MinerQuest storage pQ = minerQuests[_addr];
418         pQ.ended = true;
419         MiningWar.addCrystal(_addr, 100);
420 
421         emit ConfirmQuest(_addr, 2, 100, 1);
422     }
423     function confirmEngineerQuest(address _addr) private
424     {
425         EngineerQuest storage pQ = engineerQuests[_addr];
426         pQ.ended = true;
427         MiningWar.addCrystal(_addr, 400);
428 
429         emit ConfirmQuest(_addr, 3, 400, 1);
430     }
431     function confirmDepositQuest(address _addr) private
432     {
433         DepositQuest storage pQ = depositQuests[_addr];
434         pQ.ended = true;
435         MiningWar.addHashrate(_addr, 200);
436 
437         emit ConfirmQuest(_addr, 4, 200, 2);
438     }
439     function confirmJoinAirdropQuest(address _addr) private
440     {
441         JoinAirdropQuest storage pQ = joinAirdropQuests[_addr];
442         pQ.ended = true;
443         Engineer.addVirus(_addr, 10);
444 
445         emit ConfirmQuest(_addr, 5, 10, 3);
446     }
447     function confirmAtkBossQuest(address _addr) private
448     {
449         AtkBossQuest storage pQ = atkBossQuests[_addr];
450         pQ.ended = true;
451         Engineer.addVirus(_addr, 10);
452 
453         emit ConfirmQuest(_addr, 6, 10, 3);
454     }
455     function confirmAtkPlayerQuest(address _addr) private
456     {
457         AtkPlayerQuest storage pQ = atkPlayerQuests[_addr];
458         pQ.ended = true;
459         MiningWar.addCrystal(_addr, 10000);
460 
461         emit ConfirmQuest(_addr, 7, 10000, 1);
462     }   
463     function confirmBoosterQuest(address _addr) private
464     {
465         BoosterQuest storage pQ = boosterQuests[_addr];
466         pQ.ended = true;
467         Engineer.addVirus(_addr, 100);
468 
469         emit ConfirmQuest(_addr, 8, 100, 3);
470     }
471     function confirmRedbullQuest(address _addr) private
472     {
473         RedbullQuest storage pQ = redbullQuests[_addr];
474         pQ.ended = true;
475         Engineer.addVirus(_addr, 100);
476 
477         emit ConfirmQuest(_addr, 9, 100, 3);
478     }
479     // --------------------------------------------------------------------------------------------------------------
480     // ADD QUEST INTERNAL
481     // --------------------------------------------------------------------------------------------------------------
482     function addMinerQuest(address _addr) private
483     {
484          MinerQuest storage pQ = minerQuests[_addr];
485          pQ.ended = false;
486     }
487     function addEngineerQuest(address _addr) private
488     {
489          EngineerQuest storage pQ = engineerQuests[_addr];
490          pQ.ended = false;
491     }
492     function addDepositQuest(address _addr) private
493     {
494         DepositQuest storage pQ = depositQuests[_addr];
495         uint256 currentDepositRound;
496         uint256 share;
497         (currentDepositRound, share) = getPlayerDepositData(_addr);
498         pQ.currentDepositRound       = currentDepositRound;
499         pQ.share                     = share;
500         pQ.ended = false;
501     }
502     function addJoinAirdropQuest(address _addr) private
503     {
504         uint256 airdropGameId;    // current airdrop game id
505         uint256 totalJoinAirdrop;
506         (airdropGameId , totalJoinAirdrop) = getPlayerAirdropGameData(_addr);
507         JoinAirdropQuest storage pQ = joinAirdropQuests[_addr];
508 
509         pQ.airdropGameId    = airdropGameId;
510         pQ.totalJoinAirdrop = totalJoinAirdrop;
511         pQ.ended = false;
512     }
513     function addAtkBossQuest(address _addr) private
514     {
515         uint256 dameBossWannaCry; // current dame boss
516         uint256 levelBossWannaCry;
517         (levelBossWannaCry, dameBossWannaCry) = getPlayerBossWannaCryData(_addr);
518 
519         AtkBossQuest storage pQ = atkBossQuests[_addr];
520         pQ.levelBossWannaCry = levelBossWannaCry;
521         pQ.dameBossWannaCry  = dameBossWannaCry;
522         pQ.ended = false;
523     }
524     function addAtkPlayerQuest(address _addr) private
525     {
526         AtkPlayerQuest storage pQ = atkPlayerQuests[_addr];
527         pQ.nextTimeAtkPlayer = getNextTimeAtkPlayer(_addr);
528         pQ.ended = false;
529     }   
530     function addBoosterQuest(address _addr) private
531     {
532         BoosterQuest storage pQ = boosterQuests[_addr];
533         pQ.ended = false;
534     }
535     function addRedbullQuest(address _addr) private
536     {
537         RedbullQuest storage pQ = redbullQuests[_addr];
538         pQ.ended = false;
539     }
540     // --------------------------------------------------------------------------------------------------------------
541     // CHECK QUEST INTERNAL
542     // --------------------------------------------------------------------------------------------------------------
543     function checkGetFreeQuest(address _addr) private view returns(bool _isFinish, bool _ended)
544     {
545         if (players[_addr].currentQuest > 0) _ended = true;
546         if (miningWarRound == getMiningWarRoundOfPlayer(_addr)) _isFinish = true;
547     }
548     function checkMinerQuest(address _addr) private view returns(bool _isFinish, bool _ended)
549     {
550         MinerQuest memory pQ = minerQuests[_addr];
551         _ended = pQ.ended;
552         if (getMinerLv1(_addr) >= 10) _isFinish = true;
553     }
554     function checkEngineerQuest(address _addr) private view returns(bool _isFinish, bool _ended)
555     {
556         EngineerQuest memory pQ = engineerQuests[_addr];
557         _ended = pQ.ended;
558         if (getEngineerLv1(_addr) >= 10) _isFinish = true;
559     }
560     function checkDepositQuest(address _addr) private view returns(bool _isFinish, bool _ended)
561     {
562         DepositQuest memory pQ = depositQuests[_addr];
563         _ended = pQ.ended;
564         uint256 currentDepositRound;
565         uint256 share;
566         (currentDepositRound, share) = getPlayerDepositData(_addr);
567         if ((currentDepositRound != pQ.currentDepositRound) || (share > pQ.share)) _isFinish = true;
568     }
569     function checkJoinAirdropQuest(address _addr) private view returns(bool _isFinish, bool _ended)
570     {
571         JoinAirdropQuest memory pQ = joinAirdropQuests[_addr];
572         _ended = pQ.ended;
573         uint256 airdropGameId;    // current airdrop game id
574         uint256 totalJoinAirdrop;
575         (airdropGameId , totalJoinAirdrop) = getPlayerAirdropGameData(_addr);
576         if (
577             (pQ.airdropGameId != airdropGameId) ||
578             (pQ.airdropGameId == airdropGameId && totalJoinAirdrop > pQ.totalJoinAirdrop)
579             ) {
580             _isFinish = true;
581         }
582     }
583     function checkAtkBossQuest(address _addr) private view returns(bool _isFinish, bool _ended)
584     {
585         AtkBossQuest memory pQ = atkBossQuests[_addr];
586         _ended = pQ.ended;
587         uint256 dameBossWannaCry; // current dame boss
588         uint256 levelBossWannaCry;
589         (levelBossWannaCry, dameBossWannaCry) = getPlayerBossWannaCryData(_addr);
590         if (
591             (pQ.levelBossWannaCry != levelBossWannaCry) ||
592             (pQ.levelBossWannaCry == levelBossWannaCry && dameBossWannaCry > pQ.dameBossWannaCry)
593             ) {
594             _isFinish = true;
595         }
596     }
597     function checkAtkPlayerQuest(address _addr) private view returns(bool _isFinish, bool _ended)
598     {
599         AtkPlayerQuest memory pQ = atkPlayerQuests[_addr];
600         _ended = pQ.ended;
601         uint256 nextTimeAtkPlayer = getNextTimeAtkPlayer(_addr);
602         if (nextTimeAtkPlayer > pQ.nextTimeAtkPlayer) _isFinish = true;
603     }   
604     function checkBoosterQuest(address _addr) private view returns(bool _isFinish, bool _ended)
605     {
606         BoosterQuest memory pQ = boosterQuests[_addr];
607         _ended = pQ.ended;
608         address[5] memory boosters = getBoosters();
609         for(uint256 idx = 0; idx < 5; idx++) {
610             if (boosters[idx] == _addr) _isFinish = true;
611         }
612 
613     }
614     function checkRedbullQuest(address _addr) private view returns(bool _isFinish, bool _ended)
615     {
616         RedbullQuest memory pQ = redbullQuests[_addr];
617         _ended = pQ.ended;
618         address[5] memory redbulls = getRedbulls();
619         for(uint256 idx = 0; idx < 5; idx++) {
620             if (redbulls[idx] == _addr) _isFinish = true;
621         }
622     }
623     // --------------------------------------------------------------------------------------------------------------
624     // INTERFACE FUNCTION INTERNAL
625     // --------------------------------------------------------------------------------------------------------------
626     // Mining War
627     function getMiningWarDealine () private view returns(uint256)
628     {
629         return MiningWar.deadline();
630     }
631     function getMiningWarRound() private view returns(uint256)
632     {
633         return MiningWar.roundNumber();
634     }
635     function getBoosters() public view returns(address[5] _boosters)
636     {
637         for (uint256 idx = 0; idx < 5; idx++) {
638             address owner;
639             (owner, , , , , ) = MiningWar.getBoosterData(idx);
640             _boosters[idx] = owner;
641         }
642     }
643     function getMinerLv1(address _addr) private view returns(uint256 _total)
644     {
645         uint256[8] memory _minersCount;
646         (, , , _minersCount, , , , ) = MiningWar.getPlayerData(_addr);
647         _total = _minersCount[0];
648     }
649     function getMiningWarRoundOfPlayer(address _addr) private view returns(uint256 _roundNumber) 
650     {
651         (_roundNumber, , , , , ) = MiningWar.players(_addr);
652     }
653     // ENGINEER
654     function getRedbulls() public view returns(address[5] _redbulls)
655     {
656         for (uint256 idx = 0; idx < 5; idx++) {
657             address owner;
658             (owner, , ) = Engineer.boostData(idx);
659             _redbulls[idx] = owner;
660         }
661     }
662     function getNextTimeAtkPlayer(address _addr) private view returns(uint256 _nextTimeAtk)
663     {
664         (, _nextTimeAtk, , , , ) = Arena.getData(_addr);
665     }
666     function getEngineerLv1(address _addr) private view returns(uint256 _total)
667     {
668         uint256[8] memory _engineersCount;
669         (, , , , , , _engineersCount, ,) = Engineer.getPlayerData(_addr);
670         _total = _engineersCount[0];
671     }
672     // AIRDROP GAME
673     function getPlayerAirdropGameData(address _addr) private view returns(uint256 _currentGameId, uint256 _totalJoin)
674     {
675         (_currentGameId, , , , _totalJoin, ) = AirdropGame.players(_addr);
676     }
677     // BOSS WANNACRY
678     function getPlayerBossWannaCryData(address _addr) private view returns(uint256 _currentBossRoundNumber, uint256 _dame)
679     {
680         (_currentBossRoundNumber, , , , _dame, ) = BossWannaCry.players(_addr);
681     }
682     // DEPOSIT
683     function getPlayerDepositData(address _addr) private view returns(uint256 _currentRound, uint256 _share)
684     {
685         (_currentRound, , , _share ) = Deposit.players(_addr);
686     }
687 }