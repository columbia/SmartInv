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
80 contract CryptoMiningWarInterface {
81     address public sponsor;
82     address public administrator;
83     mapping(address => PlayerData) public players;
84     struct PlayerData {
85         uint256 roundNumber;
86         mapping(uint256 => uint256) minerCount;
87         uint256 hashrate;
88         uint256 crystals;
89         uint256 lastUpdateTime;
90         uint256 referral_count;
91         uint256 noQuest;
92     }
93     function getHashratePerDay(address /*minerAddr*/) public pure returns (uint256 /*personalProduction*/) {}
94     function addCrystal( address /*_addr*/, uint256 /*_value*/ ) public pure {}
95     function subCrystal( address /*_addr*/, uint256 /*_value*/ ) public pure {}
96     function fallback() public payable {}
97 }
98 interface MiniGameInterface {
99     function isContractMiniGame() external pure returns( bool _isContractMiniGame );
100     function fallback() external payable;
101 }
102 contract CryptoEngineer is PullPayment{
103     // engineer info
104 	address public administrator;
105     uint256 public prizePool = 0;
106     uint256 public engineerRoundNumber = 0;
107     uint256 public numberOfEngineer;
108     uint256 public numberOfBoosts;
109     address public gameSponsor;
110     uint256 public gameSponsorPrice;
111     uint256 private randNonce;
112     uint256 constant public VIRUS_MINING_PERIOD = 86400; 
113     uint256 constant public VIRUS_NORMAL = 0;
114     uint256 constant public HALF_TIME_ATK = 60 * 15;   
115     
116     // mining war game infomation
117     address public miningWarContractAddress;
118     address public miningWarAdministrator;
119     uint256 constant public CRTSTAL_MINING_PERIOD = 86400;
120     uint256 constant public BASE_PRICE = 0.01 ether;
121 
122     CryptoMiningWarInterface public MiningWarContract;
123     
124     // engineer player information
125     mapping(address => PlayerData) public players;
126     // engineer boost information
127     mapping(uint256 => BoostData) public boostData;
128     // engineer information
129     mapping(uint256 => EngineerData) public engineers;
130     // engineer virut information
131     mapping(uint256 => VirusData) public virus;
132     
133     // minigame info
134     mapping(address => bool) public miniGames; 
135     
136     struct PlayerData {
137         uint256 engineerRoundNumber;
138         mapping(uint256 => uint256) engineersCount;
139         uint256 virusNumber;
140         uint256 virusDefence;
141         uint256 research;
142         uint256 lastUpdateTime;
143         uint256 nextTimeAtk;
144         uint256 endTimeUnequalledDef;
145     }
146     struct BoostData {
147         address owner;
148         uint256 boostRate;
149         uint256 basePrice;
150     }
151     struct EngineerData {
152         uint256 basePrice;
153         uint256 baseETH;
154         uint256 baseResearch;
155         uint256 limit;
156     }
157     struct VirusData {
158         uint256 atk;
159         uint256 def;
160     }
161     event eventEndAttack(
162         address playerAtk,
163         address playerDef,
164         bool isWin,
165         uint256 winCrystals,
166         uint256 virusPlayerAtkDead,
167         uint256 virusPlayerDefDead,
168         uint256 timeAtk,
169         uint256 engineerRoundNumber,
170         uint256 atk,
171         uint256 def // def of player 
172     );
173     modifier disableContract()
174     {
175         require(tx.origin == msg.sender);
176         _;
177     }
178     modifier isAdministrator()
179     {
180         require(msg.sender == administrator);
181         _;
182     }
183     modifier onlyContractsMiniGame() 
184     {
185         require(miniGames[msg.sender] == true);
186         _;
187     }
188 
189     constructor() public {
190         administrator = msg.sender;
191 
192         //default game sponsor
193         gameSponsor = administrator;
194         gameSponsorPrice = 0.32 ether;
195         // set interface main contract
196         miningWarContractAddress = address(0xf84c61bb982041c030b8580d1634f00fffb89059);
197         MiningWarContract = CryptoMiningWarInterface(miningWarContractAddress);
198         miningWarAdministrator = MiningWarContract.administrator();
199         
200         numberOfEngineer = 8;
201         numberOfBoosts = 5;
202         // setting virusupd
203         virus[VIRUS_NORMAL] = VirusData(1,1);
204 
205         //                          price crystals    price ETH         research  limit                         
206         engineers[0] = EngineerData(10,               BASE_PRICE * 0,   10,       10   );   //lv1 
207         engineers[1] = EngineerData(50,               BASE_PRICE * 1,   200,      2    );   //lv2
208         engineers[2] = EngineerData(200,              BASE_PRICE * 2,   800,      4    );   //lv3
209         engineers[3] = EngineerData(800,              BASE_PRICE * 4,   3200,     8    );   //lv4
210         engineers[4] = EngineerData(3200,             BASE_PRICE * 8,   9600,     16   );   //lv5
211         engineers[5] = EngineerData(12800,            BASE_PRICE * 16,  38400,    32   );   //lv6
212         engineers[6] = EngineerData(102400,           BASE_PRICE * 32,  204800,   64   );   //lv7
213         engineers[7] = EngineerData(819200,           BASE_PRICE * 64,  819200,   65536);   //lv8
214         initData();
215     }
216     function () public payable
217     {
218         addPrizePool(msg.value);
219     }
220     function initData() private
221     {
222         //init booster data
223         boostData[0] = BoostData(0x0, 150, BASE_PRICE * 1);
224         boostData[1] = BoostData(0x0, 175, BASE_PRICE * 2);
225         boostData[2] = BoostData(0x0, 200, BASE_PRICE * 4);
226         boostData[3] = BoostData(0x0, 225, BASE_PRICE * 8);
227         boostData[4] = BoostData(0x0, 250, BASE_PRICE * 16);
228     }
229     /** 
230     * @dev MainContract used this function to verify game's contract
231     */
232     function isContractMiniGame() public pure returns( bool _isContractMiniGame )
233     {
234     	_isContractMiniGame = true;
235     }
236 
237     /** 
238     * @dev Main Contract call this function to setup mini game.
239     */
240     function setupMiniGame( uint256 /*_miningWarRoundNumber*/, uint256 /*_miningWarDeadline*/ ) public
241     {
242     
243     }
244     //--------------------------------------------------------------------------
245     // SETTING CONTRACT MINI GAME 
246     //--------------------------------------------------------------------------
247     function setContractsMiniGame( address _contractMiniGameAddress ) public isAdministrator 
248     {
249         MiniGameInterface MiniGame = MiniGameInterface( _contractMiniGameAddress );
250         if( MiniGame.isContractMiniGame() == false ) { revert(); }
251 
252         miniGames[_contractMiniGameAddress] = true;
253     }
254     /**
255     * @dev remove mini game contract from main contract
256     * @param _contractMiniGameAddress mini game contract address
257     */
258     function removeContractMiniGame(address _contractMiniGameAddress) public isAdministrator
259     {
260         miniGames[_contractMiniGameAddress] = false;
261     }
262     //@dev use this function in case of bug
263     function upgrade(address addr) public 
264     {
265         require(msg.sender == administrator);
266         selfdestruct(addr);
267     }
268 
269     //--------------------------------------------------------------------------
270     // BOOSTER 
271     //--------------------------------------------------------------------------
272     function buyBooster(uint256 idx) public payable 
273     {
274         require(idx < numberOfBoosts);
275         BoostData storage b = boostData[idx];
276         if (msg.value < b.basePrice || msg.sender == b.owner) {
277             revert();
278         }
279         address beneficiary = b.owner;
280         uint256 devFeePrize = devFee(b.basePrice);
281         
282         distributedToOwner(devFeePrize);
283         addMiningWarPrizePool(devFeePrize);
284         addPrizePool(SafeMath.sub(msg.value, SafeMath.mul(devFeePrize,3)));
285         
286         updateVirus(msg.sender);
287         if ( beneficiary != 0x0 ) {
288             updateVirus(beneficiary);
289         }
290         // transfer ownership    
291         b.owner = msg.sender;
292     }
293     function getBoosterData(uint256 idx) public view returns (address _owner,uint256 _boostRate, uint256 _basePrice)
294     {
295         require(idx < numberOfBoosts);
296         BoostData memory b = boostData[idx];
297         _owner = b.owner;
298         _boostRate = b.boostRate; 
299         _basePrice = b.basePrice;
300     }
301     function hasBooster(address addr) public view returns (uint256 _boostIdx)
302     {         
303         _boostIdx = 999;
304         for(uint256 i = 0; i < numberOfBoosts; i++){
305             uint256 revert_i = numberOfBoosts - i - 1;
306             if(boostData[revert_i].owner == addr){
307                 _boostIdx = revert_i;
308                 break;
309             }
310         }
311     }
312     //--------------------------------------------------------------------------
313     // GAME SPONSOR
314     //--------------------------------------------------------------------------
315     /**
316     */
317     function becomeGameSponsor() public payable disableContract
318     {
319         uint256 gameSponsorPriceFee = SafeMath.div(SafeMath.mul(gameSponsorPrice, 150), 100);
320         require(msg.value >= gameSponsorPriceFee);
321         require(msg.sender != gameSponsor);
322         // 
323         uint256 repayPrice = SafeMath.div(SafeMath.mul(gameSponsorPrice, 110), 100);
324         gameSponsor.send(repayPrice);
325         
326         // add to prize pool
327         addPrizePool(SafeMath.sub(msg.value, repayPrice));
328         // update game sponsor info
329         gameSponsor = msg.sender;
330         gameSponsorPrice = gameSponsorPriceFee;
331     }
332     /**
333     * @dev add virus for player
334     * @param _addr player address
335     * @param _value number of virus
336     */
337     function addVirus(address _addr, uint256 _value) public onlyContractsMiniGame
338     {
339         PlayerData storage p = players[_addr];
340         uint256 additionalVirus = SafeMath.mul(_value,VIRUS_MINING_PERIOD);
341         p.virusNumber = SafeMath.add(p.virusNumber, additionalVirus);
342     }
343     /**
344     * @dev subtract virus of player
345     * @param _addr player address 
346     * @param _value number virus subtract 
347     */
348     function subVirus(address _addr, uint256 _value) public onlyContractsMiniGame
349     {
350         updateVirus(_addr);
351         PlayerData storage p = players[_addr];
352         uint256 subtractVirus = SafeMath.mul(_value,VIRUS_MINING_PERIOD);
353         if ( p.virusNumber < subtractVirus ) { revert(); }
354 
355         p.virusNumber = SafeMath.sub(p.virusNumber, subtractVirus);
356     }
357     /**
358     * @dev additional time unequalled defence 
359     * @param _addr player address 
360     */
361     function setAtkNowForPlayer(address _addr) public onlyContractsMiniGame
362     {
363         PlayerData storage p = players[_addr];
364         p.nextTimeAtk = now;
365     }
366     function addTimeUnequalledDefence(address _addr, uint256 _value) public onlyContractsMiniGame
367     {
368         PlayerData storage p = players[_addr];
369         uint256 currentTimeUnequalled = p.endTimeUnequalledDef;
370         if (currentTimeUnequalled < now) {
371             currentTimeUnequalled = now;
372         }
373         p.endTimeUnequalledDef = SafeMath.add(currentTimeUnequalled, _value);
374     }
375     /**
376     * @dev claim price pool to next new game
377     * @param _addr mini game contract address
378     * @param _value eth claim;
379     */
380     function claimPrizePool(address _addr, uint256 _value) public onlyContractsMiniGame 
381     {
382         require(prizePool > _value);
383 
384         prizePool = SafeMath.sub(prizePool, _value);
385         MiniGameInterface MiniGame = MiniGameInterface( _addr );
386         MiniGame.fallback.value(_value)();
387     }
388     //--------------------------------------------------------------------------
389     // WARS
390     //--------------------------------------------------------------------------
391     function setVirusInfo(uint256 _atk, uint256 _def) public isAdministrator
392     {
393         VirusData storage v = virus[VIRUS_NORMAL];
394         v.atk = _atk;
395         v.def = _def;
396     }
397     /**
398     * @dev add virus defence 
399     * @param _value number of virus defence
400     */
401     function addVirusDefence(uint256 _value) public disableContract 
402     {        
403         updateVirus(msg.sender);
404         PlayerData storage p = players[msg.sender];
405         uint256 _virus = SafeMath.mul(_value,VIRUS_MINING_PERIOD);
406 
407         if ( p.virusNumber < _virus ) { revert(); }
408 
409         p.virusDefence = SafeMath.add(p.virusDefence, _virus);
410         p.virusNumber  = SafeMath.sub(p.virusNumber, _virus);
411     }
412     /**
413     * @dev atk and def ramdom from 50% to 150%
414     * @param _defAddress player address to attack
415     * @param _value number of virus send to attack
416     */
417     function attack( address _defAddress, uint256 _value) public disableContract
418     {
419         require(canAttack(msg.sender, _defAddress) == true);
420 
421         updateVirus(msg.sender);
422 
423         PlayerData storage pAtk = players[msg.sender];
424         PlayerData storage pDef = players[_defAddress];
425         uint256 virusAtk = SafeMath.mul(_value,VIRUS_MINING_PERIOD);
426 
427         if (pAtk.virusNumber < virusAtk) { revert(); }
428         // current crystals of defence geater 5000 crystals
429         if (calCurrentCrystals(_defAddress) < 5000) { revert(); }
430 
431         // virus normal info
432         VirusData memory v = virus[VIRUS_NORMAL];
433         // ramdom attack and defence for players from 50% to 150%
434         uint256 rateAtk = 50 + randomNumber(msg.sender, 100);
435         uint256 rateDef = 50 + randomNumber(_defAddress, 100);
436         // calculate attack of player attack and defence of player defence
437         uint256 atk = SafeMath.div(SafeMath.mul(SafeMath.mul(virusAtk, v.atk), rateAtk), 100);
438         uint256 def = SafeMath.div(SafeMath.mul(SafeMath.mul(pDef.virusDefence, v.def), rateDef), 100);
439         bool isWin = false;
440         uint256 virusPlayerAtkDead = 0;
441         uint256 virusPlayerDefDead = 0;
442         /**
443         * @dev calculate virus dead in war 
444         */
445         // if attack > defense, sub virus of player atk and player def.
446         // number virus for kin
447         if (atk > def) {
448             virusPlayerAtkDead = SafeMath.min(virusAtk, SafeMath.div(SafeMath.mul(def, 100), SafeMath.mul(v.atk, rateAtk)));
449             virusPlayerDefDead = pDef.virusDefence;
450             isWin = true;
451         }
452         /**
453         * @dev update result of war and call end attack
454         */
455         pAtk.virusNumber = SafeMath.sub(pAtk.virusNumber, virusPlayerAtkDead);
456         pDef.virusDefence = SafeMath.sub(pDef.virusDefence, virusPlayerDefDead);
457         //update player attack
458         pAtk.nextTimeAtk = now + HALF_TIME_ATK;
459 
460         endAttack(msg.sender,_defAddress,isWin, virusPlayerAtkDead, virusPlayerDefDead, atk, def);
461     }
462     /**
463     * @dev check player can atk or not
464     * @param _atkAddress player address attack
465     * @param _defAddress player address defence
466     */
467     function canAttack(address _atkAddress, address _defAddress) public view returns(bool _canAtk)
468     {
469         if ( 
470             _atkAddress != _defAddress &&
471             players[_atkAddress].nextTimeAtk <= now &&
472             players[_defAddress].endTimeUnequalledDef < now
473         ) 
474         {
475             _canAtk = true;
476         }
477     }
478     /**
479     * @dev result of war
480     * @param _atkAddress player address attack
481     * @param _defAddress player address defence
482     */
483     function endAttack(
484         address _atkAddress, 
485         address _defAddress, 
486         bool _isWin, 
487         uint256 _virusPlayerAtkDead, 
488         uint256 _virusPlayerDefDead, 
489         uint256 _atk,
490         uint256 _def
491     ) private
492     {
493         uint256 winCrystals;
494         if ( _isWin == true ) {
495             uint256 pDefCrystals = calCurrentCrystals(_defAddress);
496             // subtract random 10% to 50% current crystals of player defence
497             uint256 rate =10 + randomNumber(_defAddress, 40);
498             winCrystals = SafeMath.div(SafeMath.mul(pDefCrystals,rate),100);
499 
500             if (winCrystals > 0) {
501                 MiningWarContract.subCrystal(_defAddress, winCrystals);    
502                 MiningWarContract.addCrystal(_atkAddress, winCrystals);
503             }
504         }
505         emit eventEndAttack(_atkAddress, _defAddress, _isWin, winCrystals, _virusPlayerAtkDead, _virusPlayerDefDead, now, engineerRoundNumber, _atk, _def);
506     }
507     //--------------------------------------------------------------------------
508     // PLAYERS
509     //--------------------------------------------------------------------------
510     /**
511     */
512     function buyEngineer(uint256[] engineerNumbers) public payable disableContract
513     {
514         require(engineerNumbers.length == numberOfEngineer);
515         
516         updateVirus(msg.sender);
517         PlayerData storage p = players[msg.sender];
518         
519         uint256 priceCrystals = 0;
520         uint256 priceEth = 0;
521         uint256 research = 0;
522         for (uint256 engineerIdx = 0; engineerIdx < numberOfEngineer; engineerIdx++) {
523             uint256 engineerNumber = engineerNumbers[engineerIdx];
524             EngineerData memory e = engineers[engineerIdx];
525             // require for engineerNumber 
526             if(engineerNumber > e.limit || engineerNumber < 0) {
527                 revert();
528             }
529             // engineer you want buy
530             if (engineerNumber > 0) {
531                 uint256 currentEngineerCount = p.engineersCount[engineerIdx];
532                 // update player data
533                 p.engineersCount[engineerIdx] = SafeMath.min(e.limit, SafeMath.add(p.engineersCount[engineerIdx], engineerNumber));
534                 // calculate no research you want buy
535                 research = SafeMath.add(research, SafeMath.mul(SafeMath.sub(p.engineersCount[engineerIdx],currentEngineerCount), e.baseResearch));
536                 // calculate price crystals and eth you will pay
537                 priceCrystals = SafeMath.add(priceCrystals, SafeMath.mul(e.basePrice, engineerNumber));
538                 priceEth = SafeMath.add(priceEth, SafeMath.mul(e.baseETH, engineerNumber));
539             }
540         }
541         // check price eth
542         if (priceEth < msg.value) {
543             revert();
544         }
545 
546         uint256 devFeePrize = devFee(priceEth);
547         distributedToOwner(devFeePrize);
548         addMiningWarPrizePool(devFeePrize);
549         addPrizePool(SafeMath.sub(msg.value, SafeMath.mul(devFeePrize,3)));        
550 
551         // pay and update
552         MiningWarContract.subCrystal(msg.sender, priceCrystals);
553         updateResearch(msg.sender, research);
554     }
555      /**
556     * @dev update virus for player 
557     * @param _addr player address
558     */
559     function updateVirus(address _addr) private
560     {
561         if (players[_addr].engineerRoundNumber != engineerRoundNumber) {
562             return resetPlayer(_addr);
563         }
564         PlayerData storage p = players[_addr]; 
565         p.virusNumber = calculateCurrentVirus(_addr);
566         p.lastUpdateTime = now;
567     }
568     function calculateCurrentVirus(address _addr) public view returns(uint256 _currentVirus)
569     {
570         PlayerData memory p = players[_addr]; 
571         uint256 secondsPassed = SafeMath.sub(now, p.lastUpdateTime);
572         uint256 researchPerDay = getResearchPerDay(_addr);   
573         _currentVirus = p.virusNumber;
574         if (researchPerDay > 0) {
575             _currentVirus = SafeMath.add(_currentVirus, SafeMath.mul(researchPerDay, secondsPassed));
576         }   
577     }
578     /**
579     * @dev reset player data
580     * @param _addr player address
581     */
582     function resetPlayer(address _addr) private
583     {
584         require(players[_addr].engineerRoundNumber != engineerRoundNumber);
585 
586         PlayerData storage p = players[_addr];
587         p.engineerRoundNumber = engineerRoundNumber;
588         p.virusNumber = 0;
589         p.virusDefence = 0;
590         p.research = 0;        
591         p.lastUpdateTime = now;
592         p.nextTimeAtk = now;
593         p.endTimeUnequalledDef = now;
594         // reset player engineer data
595         for ( uint256 idx = 0; idx < numberOfEngineer; idx++ ) {
596             p.engineersCount[idx] = 0;
597         }   
598     }
599     /**
600     * @dev update research for player
601     * @param _addr player address
602     * @param _research number research want to add
603     */
604     function updateResearch(address _addr, uint256 _research) private 
605     {
606         PlayerData storage p = players[_addr];
607         p.research = SafeMath.add(p.research, _research);
608     }
609     function getResearchPerDay(address _addr) public view returns( uint256 _researchPerDay)
610     {
611         PlayerData memory p = players[_addr];
612         _researchPerDay =  p.research;
613         uint256 boosterIdx = hasBooster(_addr);
614         if (boosterIdx != 999) {
615             BoostData memory b = boostData[boosterIdx];
616             _researchPerDay = SafeMath.div(SafeMath.mul(_researchPerDay, b.boostRate), 100);
617         } 
618     }
619     /**
620     * @dev get player data
621     * @param _addr player address
622     */
623     function getPlayerData(address _addr) 
624     public 
625     view 
626     returns(
627         uint256 _engineerRoundNumber, 
628         uint256 _virusNumber, 
629         uint256 _virusDefence, 
630         uint256 _research, 
631         uint256 _researchPerDay, 
632         uint256 _lastUpdateTime, 
633         uint256[8] _engineersCount, 
634         uint256 _nextTimeAtk,
635         uint256 _endTimeUnequalledDef
636     )
637     {
638         PlayerData storage p = players[_addr];
639         for ( uint256 idx = 0; idx < numberOfEngineer; idx++ ) {
640             _engineersCount[idx] = p.engineersCount[idx];
641         }
642         _engineerRoundNumber = p.engineerRoundNumber;
643         _virusNumber = SafeMath.div(p.virusNumber, VIRUS_MINING_PERIOD);
644         _virusDefence = SafeMath.div(p.virusDefence, VIRUS_MINING_PERIOD);
645         _nextTimeAtk = p.nextTimeAtk;
646         _lastUpdateTime = p.lastUpdateTime;
647         _endTimeUnequalledDef = p.endTimeUnequalledDef;
648         _research = p.research;
649         _researchPerDay = getResearchPerDay(_addr);
650     }
651     //--------------------------------------------------------------------------
652     // INTERNAL 
653     //--------------------------------------------------------------------------
654     function addPrizePool(uint256 _value) private 
655     {
656         prizePool = SafeMath.add(prizePool, _value);
657     }
658     /**
659     * @dev add 5% value of transaction payable
660     */
661     function addMiningWarPrizePool(uint256 _value) private
662     {
663         MiningWarContract.fallback.value(_value)();
664     }
665     /**
666     * @dev calculate current crystals of player
667     * @param _addr player address
668     */
669     function calCurrentCrystals(address _addr) public view returns(uint256 _currentCrystals)
670     {
671         uint256 lastUpdateTime;
672         (,, _currentCrystals, lastUpdateTime) = getMiningWarPlayerData(_addr);
673         uint256 hashratePerDay = getHashratePerDay(_addr);     
674         uint256 secondsPassed = SafeMath.sub(now, lastUpdateTime);      
675         if (hashratePerDay > 0) {
676             _currentCrystals = SafeMath.add(_currentCrystals, SafeMath.mul(hashratePerDay, secondsPassed));
677         }
678         _currentCrystals = SafeMath.div(_currentCrystals, CRTSTAL_MINING_PERIOD);
679     }
680     function devFee(uint256 _amount) private pure returns(uint256)
681     {
682         return SafeMath.div(SafeMath.mul(_amount, 5), 100);
683     }
684     /**
685     * @dev with transaction payable send 5% value for admin and sponsor
686     * @param _value fee 
687     */
688     function distributedToOwner(uint256 _value) private
689     {
690         gameSponsor.send(_value);
691         miningWarAdministrator.send(_value);
692     }
693     function randomNumber(address _addr, uint256 _maxNumber) private returns(uint256)
694     {
695         randNonce = randNonce + 1;
696         return uint256(keccak256(abi.encodePacked(now, _addr, randNonce))) % _maxNumber;
697     }
698     function getMiningWarPlayerData(address _addr) private view returns(uint256 _roundNumber, uint256 _hashrate, uint256 _crytals, uint256 _lastUpdateTime)
699     {
700         (_roundNumber,_hashrate,_crytals,_lastUpdateTime,,)= MiningWarContract.players(_addr);
701     }
702     function getHashratePerDay(address _addr) private view returns(uint256)
703     {
704         return MiningWarContract.getHashratePerDay(_addr);
705     }
706 }