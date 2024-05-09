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
57     function getPlayerData(address /*_addr*/) 
58     public 
59     pure 
60     returns(
61         uint256 /*_engineerRoundNumber*/, 
62         uint256 /*_virusNumber*/, 
63         uint256 /*_virusDefence*/, 
64         uint256 /*_research*/, 
65         uint256 /*_researchPerDay*/, 
66         uint256 /*_lastUpdateTime*/, 
67         uint256[8] /*_engineersCount*/, 
68         uint256 /*_nextTimeAtk*/,
69         uint256 /*_endTimeUnequalledDef*/
70     ) {}
71     function fallback() public payable {}
72     function claimPrizePool(address /*_addr*/, uint256 /*_value*/) public pure {} 
73     function isContractMiniGame() public pure returns( bool /*_isContractMiniGame*/) {}
74 }
75 contract CryptoMiningWarInterface {
76     uint256 public deadline; 
77     mapping(address => PlayerData) public players;
78     struct PlayerData {
79         uint256 roundNumber;
80         mapping(uint256 => uint256) minerCount;
81         uint256 hashrate;
82         uint256 crystals;
83         uint256 lastUpdateTime;
84         uint256 referral_count;
85         uint256 noQuest;
86     }
87     function getPlayerData(address /*addr*/) public pure
88     returns (
89         uint256 /*crystals*/, 
90         uint256 /*lastupdate*/, 
91         uint256 /*hashratePerDay*/, 
92         uint256[8] /*miners*/, 
93         uint256 /*hasBoost*/, 
94         uint256 /*referral_count*/, 
95         uint256 /*playerBalance*/, 
96         uint256 /*noQuest*/ 
97         ) {}
98     function subCrystal( address /*_addr*/, uint256 /*_value*/ ) public pure {}
99 }
100 contract CryptoAirdropGameInterface {
101     mapping(address => PlayerData) public players;
102     struct PlayerData {
103         uint256 currentMiniGameId;
104         uint256 lastMiniGameId; 
105         uint256 win;
106         uint256 share;
107         uint256 totalJoin;
108         uint256 miningWarRoundNumber;
109     }
110     function isContractMiniGame() public pure returns( bool /*_isContractMiniGame*/ ) {}
111 }
112 contract CryptoBossWannaCryInterface {
113     mapping(address => PlayerData) public players;
114     struct PlayerData {
115         uint256 currentBossRoundNumber;
116         uint256 lastBossRoundNumber;
117         uint256 win;
118         uint256 share;
119         uint256 dame; 
120         uint256 nextTimeAtk;
121     }
122     function isContractMiniGame() public pure returns( bool /*_isContractMiniGame*/ ) {}
123 }
124 contract CrystalDeposit {
125     using SafeMath for uint256;
126 
127     bool private init = false;
128     address private administrator;
129     // mini game
130     uint256 private round = 0;
131     uint256 private HALF_TIME       = 1 days;
132     uint256 private RESET_QUEST_TIME= 4 hours;
133     uint256 constant private RESET_QUEST_FEE = 0.005 ether; 
134     address private engineerAddress;
135 
136     CryptoEngineerInterface     public Engineer;
137     CryptoMiningWarInterface    public MiningWar;
138     CryptoAirdropGameInterface  public AirdropGame;
139     CryptoBossWannaCryInterface public BossWannaCry;
140     
141     // mining war info
142     uint256 private miningWarDeadline;
143     uint256 constant private CRTSTAL_MINING_PERIOD = 86400;
144     /** 
145     * @dev mini game information
146     */
147     mapping(uint256 => Game) public games;
148     // quest info 
149     mapping(uint256 => Quest) public quests;
150 
151     mapping(address => PlayerQuest) public playersQuests;
152     /** 
153     * @dev player information
154     */
155     mapping(address => Player) public players;
156    
157     struct Game {
158         uint256 round;
159         uint256 crystals;
160         uint256 prizePool;
161         uint256 endTime;
162         bool ended; 
163     }
164     struct Player {
165         uint256 currentRound;
166         uint256 lastRound;
167         uint256 reward;
168         uint256 share; // your crystals share in current round 
169         uint256 questSequence;
170         uint256 totalQuestFinish;
171         uint256 resetFreeTime;
172     }
173     struct Quest {
174         uint256 typeQuest;
175         uint256 levelOne;
176         uint256 levelTwo;
177         uint256 levelThree;
178         uint256 levelFour;
179     }
180     struct PlayerQuest {
181         bool haveQuest;
182         uint256 questId;
183         uint256 level;
184         uint256 numberOfTimes;
185         uint256 deposit;
186         uint256 miningWarRound;   // current mining war round player join
187         uint256 referralCount;    // current referral_count
188         uint256 totalMiner;       // current total miner
189         uint256 totalEngineer;    // current total engineer
190         uint256 airdropGameId;    // current airdrop game id
191         uint256 totalJoinAirdrop; // total join the airdrop game
192         uint256 nextTimeAtkPlayer; // 
193         uint256 dameBossWannaCry; // current dame boss
194         uint256 levelBossWannaCry; // current boss player atk
195     }
196     event EndRound(uint256 round, uint256 crystals, uint256 prizePool, uint256 endTime);
197     event AddPlayerQuest(address player, uint256 questId, uint256 questLv, uint256 deposit);
198     event ConfirmQuest(address player, uint256 questId, uint256 questLv, uint256 deposit, uint256 bonus, uint256 percent);
199     modifier isAdministrator()
200     {
201         require(msg.sender == administrator);
202         _;
203     }
204     modifier disableContract()
205     {
206         require(tx.origin == msg.sender);
207         _;
208     }
209 
210     constructor() public {
211         administrator = msg.sender;
212         initQuests();
213         engineerAddress = address(0x69fd0e5d0a93bf8bac02c154d343a8e3709adabf);
214         setMiningWarInterface(0xf84c61bb982041c030b8580d1634f00fffb89059);
215         setEngineerInterface(engineerAddress);
216         setAirdropGameInterface(0x5b813a2f4b58183d270975ab60700740af00a3c9);
217         setBossWannaCryInterface(0x54e96d609b183196de657fc7380032a96f27f384);
218     }
219     function initQuests() private
220     {
221                   //     type   level 1   level 2   level 3   level 4
222         quests[0] = Quest(1     , 5       , 10      , 15      , 20   ); // Win x Starter Quest
223         quests[1] = Quest(2     , 1       , 2       , 3       , 4    ); // Buy x Miner
224         quests[2] = Quest(3     , 1       , 2       , 3       , 4    ); // Buy x Engineer
225         quests[3] = Quest(4     , 1       , 1       , 1       , 1    ); // Join An Airdrop Game
226         quests[4] = Quest(5     , 1       , 1       , 1       , 1    ); // Attack x Player
227         quests[5] = Quest(6     , 100     , 1000    , 10000   ,100000); // Attack x Hp Boss WannaCry
228     }
229     function () public payable
230     {
231         if (engineerAddress != msg.sender) addCurrentPrizePool(msg.value);   
232     }
233     // ---------------------------------------------------------------------------------------
234     // SET INTERFACE CONTRACT
235     // ---------------------------------------------------------------------------------------
236     
237     function setMiningWarInterface(address _addr) public isAdministrator
238     {
239         MiningWar = CryptoMiningWarInterface(_addr);
240     }
241     function setEngineerInterface(address _addr) public isAdministrator
242     {
243         CryptoEngineerInterface engineerInterface = CryptoEngineerInterface(_addr);
244         
245         require(engineerInterface.isContractMiniGame() == true);
246 
247         engineerAddress = _addr;
248         Engineer = engineerInterface;
249     }
250     function setAirdropGameInterface(address _addr) public isAdministrator
251     {
252         CryptoAirdropGameInterface airdropGameInterface = CryptoAirdropGameInterface(_addr);
253         
254         require(airdropGameInterface.isContractMiniGame() == true);
255 
256         AirdropGame = airdropGameInterface;
257     }
258     function setBossWannaCryInterface(address _addr) public isAdministrator
259     {
260         CryptoBossWannaCryInterface bossWannaCryInterface = CryptoBossWannaCryInterface(_addr);
261         
262         require(bossWannaCryInterface.isContractMiniGame() == true);
263 
264         BossWannaCry = bossWannaCryInterface;
265     }
266     /** 
267     * @dev MainContract used this function to verify game's contract
268     */
269     function isContractMiniGame() public pure returns( bool _isContractMiniGame )
270     {
271         _isContractMiniGame = true;
272     }
273     function upgrade(address addr) public isAdministrator
274     {
275         selfdestruct(addr);
276     }
277     // ---------------------------------------------------------------------------------------------
278     // SETUP GAME
279     // ---------------------------------------------------------------------------------------------
280     function setHalfTime(uint256 _time) public isAdministrator
281     {
282         HALF_TIME = _time;
283     }
284     function setResetQuestTime(uint256 _time) public isAdministrator
285     {
286         RESET_QUEST_TIME = _time;
287     }
288     /** 
289     * @dev Main Contract call this function to setup mini game.
290     */
291     function setupMiniGame( uint256 /*_miningWarRoundNumber*/, uint256 _miningWarDeadline ) public
292     {
293         miningWarDeadline = _miningWarDeadline;
294     }
295     /**
296     * @dev start the mini game
297     */
298     function startGame() public 
299     {
300         require(msg.sender == administrator);
301         require(init == false);
302         init = true;
303         miningWarDeadline = getMiningWarDealine();
304 
305         games[round].ended = true;
306     
307         startRound();
308     }
309     function startRound() private
310     {
311         require(games[round].ended == true);
312 
313         uint256 crystalsLastRound = games[round].crystals;
314         uint256 prizePoolLastRound= games[round].prizePool; 
315 
316         round = round + 1;
317 
318         uint256 endTime = now + HALF_TIME;
319         // claim 5% of current prizePool as rewards.
320         uint256 engineerPrizePool = getEngineerPrizePool();
321         uint256 prizePool = SafeMath.div(SafeMath.mul(engineerPrizePool, 5),100); 
322 
323         Engineer.claimPrizePool(address(this), prizePool);
324         
325         if (crystalsLastRound <= 0) prizePool = SafeMath.add(prizePool, prizePoolLastRound);
326         
327         games[round] = Game(round, 0, prizePool, endTime, false);
328     }
329     function endRound() private
330     {
331         require(games[round].ended == false);
332         require(games[round].endTime <= now);
333 
334         Game storage g = games[round];
335         g.ended = true;
336         
337         startRound();
338 
339         emit EndRound(g.round, g.crystals, g.prizePool, g.endTime);
340     }
341     /**
342     * @dev player send crystals to the pot
343     */
344     function share(uint256 _value) public disableContract
345     {
346         require(miningWarDeadline > now);
347         require(games[round].ended == false);
348         require(_value >= 10000);
349         require(playersQuests[msg.sender].haveQuest == false);
350 
351         MiningWar.subCrystal(msg.sender, _value); 
352 
353         if (games[round].endTime <= now) endRound();
354         
355         updateReward(msg.sender);
356 
357         uint256 _share = SafeMath.mul(_value, CRTSTAL_MINING_PERIOD);
358         
359         addPlayerQuest(msg.sender, _share);
360     }
361     function freeResetQuest(address _addr) public disableContract
362     {
363         _addr = msg.sender;
364         resetQuest(_addr);
365     }
366     function instantResetQuest(address _addr) public payable disableContract
367     {
368         require(msg.value >= RESET_QUEST_FEE);
369 
370         _addr = msg.sender;
371 
372         uint256 fee = devFee(msg.value);
373         address gameSponsor = getGameSponsor();
374         gameSponsor.transfer(fee);
375         administrator.transfer(fee);
376 
377         uint256 prizePool = msg.value - (fee * 2);
378         addEngineerPrizePool(prizePool);
379         resetQuest(_addr);
380     }
381     function confirmQuest(address _addr) public disableContract
382     {
383         _addr = msg.sender;
384         bool _isFinish;
385         (_isFinish, ,) = checkQuest(_addr);
386         require(_isFinish == true);
387         require(playersQuests[_addr].haveQuest  == true);
388 
389         if (games[round].endTime <= now) endRound();
390         
391         updateReward(_addr);
392 
393         Player storage p      = players[_addr];
394         Game storage g        = games[round];
395         PlayerQuest storage pQ = playersQuests[_addr];
396 
397         uint256 _share = pQ.deposit;
398         uint256 rate = 0;
399         // bonus
400         // lv 4 50 - 100 %
401         if (pQ.questId == 2) rate = 50 + randomNumber(_addr, 0, 51);
402         if (pQ.questId == 0 && pQ.level == 4) rate = 50 + randomNumber(_addr, 0, 51); 
403         if (pQ.questId == 1 && pQ.level == 4) rate = 50 + randomNumber(_addr, 0, 51);
404         if (pQ.questId == 5 && pQ.level == 4) rate = 50 + randomNumber(_addr, 0, 51);
405         // lv 3 25 - 75 %
406         if (pQ.questId == 0 && pQ.level == 3) rate = 25 + randomNumber(_addr, 0, 51); 
407         if (pQ.questId == 1 && pQ.level == 3) rate = 25 + randomNumber(_addr, 0, 51);
408         if (pQ.questId == 5 && pQ.level == 3) rate = 25 + randomNumber(_addr, 0, 51);
409         // lv 2 10 - 50 %
410         if (pQ.questId == 0 && pQ.level == 2) rate = 10 + randomNumber(_addr, 0, 41); 
411         if (pQ.questId == 1 && pQ.level == 2) rate = 10 + randomNumber(_addr, 0, 41);
412         if (pQ.questId == 5 && pQ.level == 2) rate = 10 + randomNumber(_addr, 0, 41);
413         if (pQ.questId == 3) rate = 10 + randomNumber(_addr, 0, 51);
414         // lv 1 0 - 25 %
415         if (pQ.questId == 0 && pQ.level == 1) rate = randomNumber(_addr, 0, 26); 
416         if (pQ.questId == 1 && pQ.level == 1) rate = randomNumber(_addr, 0, 26);
417         if (pQ.questId == 5 && pQ.level == 1) rate = randomNumber(_addr, 0, 26);
418         if (pQ.questId == 4) rate = randomNumber(_addr, 0, 26);
419 
420         if (rate > 0) _share += SafeMath.div(SafeMath.mul(_share, rate), 100);
421 
422         g.crystals = SafeMath.add(g.crystals, _share);
423         
424         if (p.currentRound == round) {
425             p.share = SafeMath.add(p.share, _share);
426         } else {
427             p.share = _share;
428             p.currentRound = round;
429         }
430 
431         p.questSequence += 1; 
432         p.totalQuestFinish += 1; 
433         pQ.haveQuest = false;
434 
435         emit ConfirmQuest(_addr, pQ.questId, pQ.level, pQ.deposit, SafeMath.sub(_share, pQ.deposit), rate);
436 
437         pQ.deposit = 0; 
438     }
439     function checkQuest(address _addr) public view returns(bool _isFinish, uint256 _numberOfTimes, uint256 _number) 
440     {
441         PlayerQuest memory pQ = playersQuests[_addr];
442 
443         if (pQ.questId == 0) (_isFinish, _numberOfTimes, _number ) = checkWonStarterQuest(_addr); 
444         if (pQ.questId == 1) (_isFinish, _numberOfTimes, _number ) = checkBuyMinerQuest(_addr); 
445         if (pQ.questId == 2) (_isFinish, _numberOfTimes, _number ) = checkBuyEngineerQuest(_addr); 
446         if (pQ.questId == 3) (_isFinish, _numberOfTimes, _number ) = checkJoinAirdropQuest(_addr); 
447         if (pQ.questId == 4) (_isFinish, _numberOfTimes, _number ) = checkAtkPlayerQuest(_addr); 
448         if (pQ.questId == 5) (_isFinish, _numberOfTimes, _number ) = ckeckAtkBossWannaCryQuest(_addr); 
449     }
450     
451     function getData(address _addr) 
452     public
453     view
454     returns(
455         // current game
456         uint256 _prizePool,
457         uint256 _crystals,
458         uint256 _endTime,
459         // player info
460         uint256 _reward,
461         uint256 _share,
462         uint256 _questSequence,
463         // current quest of player
464         uint256 _deposit,
465         uint256 _resetFreeTime,
466         uint256 _typeQuest,
467         uint256 _numberOfTimes, 
468         uint256 _number,
469         bool _isFinish,
470         bool _haveQuest
471     ) {
472          (_prizePool, _crystals, _endTime) = getCurrentGame();
473          (_reward, _share, _questSequence, , _resetFreeTime)   = getPlayerData(_addr);
474          (_haveQuest, _typeQuest, _isFinish, _numberOfTimes, _number, _deposit) = getCurrentQuest(_addr);
475          
476     }
477     function withdrawReward() public disableContract
478     {
479         if (games[round].endTime <= now) endRound();
480         
481         updateReward(msg.sender);
482         Player storage p = players[msg.sender];
483         uint256 balance  = p.reward; 
484         if (address(this).balance >= balance) {
485              msg.sender.transfer(balance);
486             // update player
487             p.reward = 0;     
488         }
489     }
490     // ---------------------------------------------------------------------------------------------------------------------------------
491     // INTERNAL
492     // ---------------------------------------------------------------------------------------------------------------------------------
493     function addCurrentPrizePool(uint256 _value) private
494     {
495         require(games[round].ended == false);
496         require(init == true);
497         games[round].prizePool += _value; 
498     }
499     function devFee(uint256 _amount) private pure returns(uint256)
500     {
501         return SafeMath.div(SafeMath.mul(_amount, 5), 100);
502     }
503     function resetQuest(address _addr) private 
504     {
505         if (games[round].endTime <= now) endRound();
506         
507         updateReward(_addr);
508 
509         uint256 currentQuestId= playersQuests[_addr].questId; 
510         uint256 questId       = randomNumber(_addr, 0, 6);
511 
512         if (currentQuestId == questId && questId < 5) questId += 1; 
513         if (currentQuestId == questId && questId >= 5) questId -= 1; 
514 
515         uint256 level         = 1 + randomNumber(_addr, questId + 1, 4);
516         uint256 numberOfTimes = getNumberOfTimesQuest(questId, level);
517 
518         if (questId == 0) addWonStarterQuest(_addr); // won x starter quest
519         if (questId == 1) addBuyMinerQuest(_addr); // buy x miner
520         if (questId == 2) addBuyEngineerQuest(_addr); // buy x engineer
521         if (questId == 3) addJoinAirdropQuest(_addr); // join airdrop game
522         if (questId == 4) addAtkPlayerQuest(_addr); // atk a player
523         if (questId == 5) addAtkBossWannaCryQuest(_addr); // atk hp boss
524 
525         PlayerQuest storage pQ = playersQuests[_addr];
526         
527         players[_addr].questSequence = 0;
528         players[_addr].resetFreeTime = now + RESET_QUEST_TIME;
529 
530         pQ.questId       = questId;
531         pQ.level         = level;
532         pQ.numberOfTimes = numberOfTimes;
533         emit AddPlayerQuest(_addr, questId, level, pQ.deposit);
534     }
535     function getCurrentGame() private view returns(uint256 _prizePool, uint256 _crystals, uint256 _endTime)
536     {
537         Game memory g = games[round];
538         _prizePool = g.prizePool;
539         _crystals  = g.crystals;
540         _endTime   = g.endTime;
541     }
542     function getCurrentQuest(address _addr) private view returns(bool _haveQuest, uint256 _typeQuest, bool _isFinish, uint256 _numberOfTimes, uint256 _number, uint256 _deposit)
543     {   
544         PlayerQuest memory pQ = playersQuests[_addr];
545         _haveQuest     = pQ.haveQuest;
546         _deposit       = pQ.deposit;
547         _typeQuest = quests[pQ.questId].typeQuest;
548         (_isFinish, _numberOfTimes, _number) = checkQuest(_addr);
549     }
550     function getPlayerData(address _addr) private view returns(uint256 _reward, uint256 _share, uint256 _questSequence, uint256 _totalQuestFinish, uint256 _resetFreeTime)
551     {
552         Player memory p = players[_addr];
553         _reward           = p.reward;
554         _questSequence    = p.questSequence;
555         _totalQuestFinish = p.totalQuestFinish;
556         _resetFreeTime    = p.resetFreeTime;
557         if (p.currentRound == round) _share = players[_addr].share; 
558         if (p.currentRound != p.lastRound) _reward += calculateReward(_addr, p.currentRound);
559     }
560     function updateReward(address _addr) private
561     {
562         Player storage p = players[_addr];
563         
564         if ( 
565             games[p.currentRound].ended == true &&
566             p.lastRound < p.currentRound
567             ) {
568             p.reward = SafeMath.add(p.reward, calculateReward(msg.sender, p.currentRound));
569             p.lastRound = p.currentRound;
570         }
571     }
572       /**
573     * @dev calculate reward
574     */
575     function randomNumber(address _addr, uint256 randNonce, uint256 _maxNumber) private view returns(uint256)
576     {
577         return uint256(keccak256(abi.encodePacked(now, _addr, randNonce))) % _maxNumber;
578     }
579     function calculateReward(address _addr, uint256 _round) private view returns(uint256)
580     {
581         Player memory p = players[_addr];
582         Game memory g = games[_round];
583         if (g.endTime > now) return 0;
584         if (g.crystals == 0) return 0; 
585         return SafeMath.div(SafeMath.mul(g.prizePool, p.share), g.crystals);
586     }
587     // --------------------------------------------------------------------------------------------------------------
588     // ADD QUEST INTERNAL
589     // --------------------------------------------------------------------------------------------------------------
590     function addPlayerQuest(address _addr, uint256 _share) private
591     {
592         uint256 questId       = randomNumber(_addr, 0, 6);
593         uint256 level         = 1 + randomNumber(_addr, questId + 1, 4);
594         uint256 numberOfTimes = getNumberOfTimesQuest(questId, level);
595 
596         if (questId == 0) addWonStarterQuest(_addr); // won x starter quest
597         if (questId == 1) addBuyMinerQuest(_addr); // buy x miner
598         if (questId == 2) addBuyEngineerQuest(_addr); // buy x engineer
599         if (questId == 3) addJoinAirdropQuest(_addr); // join airdrop game
600         if (questId == 4) addAtkPlayerQuest(_addr); // atk a player
601         if (questId == 5) addAtkBossWannaCryQuest(_addr); // atk hp boss
602 
603         PlayerQuest storage pQ = playersQuests[_addr];
604         pQ.deposit       = _share;
605         pQ.haveQuest     = true;
606         pQ.questId       = questId;
607         pQ.level         = level;
608         pQ.numberOfTimes = numberOfTimes;
609 
610         players[_addr].resetFreeTime = now + RESET_QUEST_TIME;
611 
612         emit AddPlayerQuest(_addr, questId, level, _share);
613     }
614     function getNumberOfTimesQuest(uint256 _questId, uint256 _level) private view returns(uint256)
615     {
616         Quest memory q = quests[_questId];
617 
618         if (_level == 1) return q.levelOne;
619         if (_level == 2) return q.levelTwo;
620         if (_level == 3) return q.levelThree;
621         if (_level == 4) return q.levelFour;
622 
623         return 0;
624     } 
625     function addWonStarterQuest(address _addr) private
626     {
627         uint256 miningWarRound;
628         uint256 referralCount;
629         (miningWarRound, referralCount) = getPlayerMiningWarData(_addr);
630 
631         playersQuests[_addr].miningWarRound = miningWarRound;
632         playersQuests[_addr].referralCount  = referralCount;
633     }
634     
635     function addBuyMinerQuest(address _addr) private
636     {
637         uint256 miningWarRound;
638         (miningWarRound, ) = getPlayerMiningWarData(_addr);
639 
640         playersQuests[_addr].totalMiner     = getTotalMiner(_addr);
641         playersQuests[_addr].miningWarRound = miningWarRound;
642     }
643     function addBuyEngineerQuest(address _addr) private
644     {
645         playersQuests[_addr].totalEngineer = getTotalEngineer(_addr);
646     }
647     function addJoinAirdropQuest(address _addr) private
648     {
649         uint256 airdropGameId;    // current airdrop game id
650         uint256 totalJoinAirdrop;
651         (airdropGameId , totalJoinAirdrop) = getPlayerAirdropGameData(_addr);
652 
653         playersQuests[_addr].airdropGameId    = airdropGameId;
654         playersQuests[_addr].totalJoinAirdrop = totalJoinAirdrop;
655         
656     }
657     function addAtkPlayerQuest(address _addr) private
658     {        
659         playersQuests[_addr].nextTimeAtkPlayer = getNextTimeAtkPlayer(_addr);
660     }
661     function addAtkBossWannaCryQuest(address _addr) private
662     {
663         uint256 dameBossWannaCry; // current dame boss
664         uint256 levelBossWannaCry;
665         (levelBossWannaCry, dameBossWannaCry) = getPlayerBossWannaCryData(_addr);
666 
667         playersQuests[_addr].levelBossWannaCry = levelBossWannaCry;
668         playersQuests[_addr].dameBossWannaCry  = dameBossWannaCry;
669     }
670     // --------------------------------------------------------------------------------------------------------------
671     // CHECK QUEST INTERNAL
672     // --------------------------------------------------------------------------------------------------------------
673     function checkWonStarterQuest(address _addr) private view returns(bool _isFinish, uint256 _numberOfTimes, uint256 _number)
674     {
675         PlayerQuest memory pQ = playersQuests[_addr];
676 
677         uint256 miningWarRound;
678         uint256 referralCount;
679         (miningWarRound, referralCount) = getPlayerMiningWarData(_addr);
680 
681         _numberOfTimes = pQ.numberOfTimes;
682         if (pQ.miningWarRound != miningWarRound) _number = referralCount;
683         if (pQ.miningWarRound == miningWarRound) _number = SafeMath.sub(referralCount, pQ.referralCount);    
684         if (
685             (pQ.miningWarRound != miningWarRound && referralCount >= pQ.numberOfTimes) ||
686             (pQ.miningWarRound == miningWarRound && referralCount >= SafeMath.add(pQ.referralCount, pQ.numberOfTimes)) 
687             ) {
688             _isFinish = true;
689         } 
690         
691     }
692     function checkBuyMinerQuest(address _addr) private view returns(bool _isFinish, uint256 _numberOfTimes, uint256 _number)
693     {
694         PlayerQuest memory pQ = playersQuests[_addr];
695         uint256 miningWarRound;
696         (miningWarRound, ) = getPlayerMiningWarData(_addr);
697         uint256 totalMiner = getTotalMiner(_addr);
698 
699         _numberOfTimes = pQ.numberOfTimes;
700         if (pQ.miningWarRound != miningWarRound) _number = totalMiner;
701         if (pQ.miningWarRound == miningWarRound) _number = SafeMath.sub(totalMiner, pQ.totalMiner); 
702         if (
703             (pQ.miningWarRound != miningWarRound && totalMiner >= pQ.numberOfTimes) ||
704             (pQ.miningWarRound == miningWarRound && totalMiner >= SafeMath.add(pQ.totalMiner, pQ.numberOfTimes))
705             ) {
706             _isFinish = true;
707         }
708     }
709     function checkBuyEngineerQuest(address _addr) private view returns(bool _isFinish, uint256 _numberOfTimes, uint256 _number)
710     {
711         PlayerQuest memory pQ = playersQuests[_addr];
712 
713         uint256 totalEngineer = getTotalEngineer(_addr);
714         _numberOfTimes = pQ.numberOfTimes;
715         _number = SafeMath.sub(totalEngineer, pQ.totalEngineer); 
716         if (totalEngineer >= SafeMath.add(pQ.totalEngineer, pQ.numberOfTimes)) {
717             _isFinish = true;
718         }
719     }
720     function checkJoinAirdropQuest(address _addr) private view returns(bool _isFinish, uint256 _numberOfTimes, uint256 _number)
721     {
722         PlayerQuest memory pQ = playersQuests[_addr];
723 
724         uint256 airdropGameId;    // current airdrop game id
725         uint256 totalJoinAirdrop;
726         (airdropGameId , totalJoinAirdrop) = getPlayerAirdropGameData(_addr);
727         _numberOfTimes = pQ.numberOfTimes;
728         if (
729             (pQ.airdropGameId != airdropGameId) ||
730             (pQ.airdropGameId == airdropGameId && totalJoinAirdrop >= SafeMath.add(pQ.totalJoinAirdrop, pQ.numberOfTimes))
731             ) {
732             _isFinish = true;
733             _number = _numberOfTimes;
734         }
735     }
736     function checkAtkPlayerQuest(address _addr) private view returns(bool _isFinish, uint256 _numberOfTimes, uint256 _number)
737     {
738         PlayerQuest memory pQ = playersQuests[_addr];
739 
740         uint256 nextTimeAtkPlayer = getNextTimeAtkPlayer(_addr);
741         _numberOfTimes = pQ.numberOfTimes;
742         if (nextTimeAtkPlayer > pQ.nextTimeAtkPlayer) {
743             _isFinish = true;
744             _number = _numberOfTimes;
745         }
746     }
747     function ckeckAtkBossWannaCryQuest(address _addr) private view returns(bool _isFinish, uint256 _numberOfTimes, uint256 _number)
748     {
749         PlayerQuest memory pQ = playersQuests[_addr];
750 
751         uint256 dameBossWannaCry; // current dame boss
752         uint256 levelBossWannaCry;
753         (levelBossWannaCry, dameBossWannaCry) = getPlayerBossWannaCryData(_addr);
754         _numberOfTimes = pQ.numberOfTimes;
755         if (pQ.levelBossWannaCry != levelBossWannaCry) _number = dameBossWannaCry;
756         if (pQ.levelBossWannaCry == levelBossWannaCry) _number = SafeMath.sub(dameBossWannaCry, pQ.dameBossWannaCry);
757         if (
758             (pQ.levelBossWannaCry != levelBossWannaCry && dameBossWannaCry >= pQ.numberOfTimes) ||
759             (pQ.levelBossWannaCry == levelBossWannaCry && dameBossWannaCry >= SafeMath.add(pQ.dameBossWannaCry, pQ.numberOfTimes))
760             ) {
761             _isFinish = true;
762         }
763     }
764 
765     // --------------------------------------------------------------------------------------------------------------
766     // INTERFACE FUNCTION INTERNAL
767     // --------------------------------------------------------------------------------------------------------------
768     // Mining War
769     function getMiningWarDealine () private view returns(uint256)
770     {
771         return MiningWar.deadline();
772     }
773     
774     function getTotalMiner(address _addr) private view returns(uint256 _total)
775     {
776         uint256[8] memory _minersCount;
777         (, , , _minersCount, , , , ) = MiningWar.getPlayerData(_addr);
778         for (uint256 idx = 0; idx < 8; idx ++) {
779             _total += _minersCount[idx];
780         }
781     }
782     function getPlayerMiningWarData(address _addr) private view returns(uint256 _roundNumber, uint256 _referral_count) 
783     {
784         (_roundNumber, , , , _referral_count, ) = MiningWar.players(_addr);
785     }
786     // ENGINEER
787     function addEngineerPrizePool(uint256 _value) private 
788     {
789         Engineer.fallback.value(_value)();
790     }
791     function getGameSponsor() public view returns(address)
792     {
793         return Engineer.gameSponsor();
794     }
795     function getEngineerPrizePool() private view returns(uint256)
796     {
797         return Engineer.prizePool();
798     }
799     function getNextTimeAtkPlayer(address _addr) private view returns(uint256 _nextTimeAtk)
800     {
801         (, , , , , , , _nextTimeAtk,) = Engineer.getPlayerData(_addr);
802     }
803     function getTotalEngineer(address _addr) private view returns(uint256 _total)
804     {
805         uint256[8] memory _engineersCount;
806         (, , , , , , _engineersCount, ,) = Engineer.getPlayerData(_addr);
807         for (uint256 idx = 0; idx < 8; idx ++) {
808             _total += _engineersCount[idx];
809         }
810     }
811     // AIRDROP GAME
812     function getPlayerAirdropGameData(address _addr) private view returns(uint256 _currentGameId, uint256 _totalJoin)
813     {
814         (_currentGameId, , , , _totalJoin, ) = AirdropGame.players(_addr);
815     }
816     // BOSS WANNACRY
817     function getPlayerBossWannaCryData(address _addr) private view returns(uint256 _currentBossRoundNumber, uint256 _dame)
818     {
819         (_currentBossRoundNumber, , , , _dame, ) = BossWannaCry.players(_addr);
820     }
821 }