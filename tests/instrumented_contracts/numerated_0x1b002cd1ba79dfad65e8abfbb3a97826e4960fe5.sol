1 pragma solidity ^0.4.25;
2 
3 /*
4 * CryptoMiningWar - Blockchain-based strategy game
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
53 
54 /**
55  * @title PullPayment
56  * @dev Base contract supporting async send for pull payments. Inherit from this
57  * contract and use asyncSend instead of send or transfer.
58  */
59 contract PullPayment {
60   using SafeMath for uint256;
61 
62   mapping(address => uint256) public payments;
63   uint256 public totalPayments;
64 
65   /**
66   * @dev Withdraw accumulated balance, called by payee.
67   */
68   function withdrawPayments() public {
69     address payee = msg.sender;
70     uint256 payment = payments[payee];
71 
72     require(payment != 0);
73     require(address(this).balance >= payment);
74 
75     totalPayments = totalPayments.sub(payment);
76     payments[payee] = 0;
77 
78     payee.transfer(payment);
79   }
80 
81   /**
82   * @dev Called by the payer to store the sent amount as credit to be pulled.
83   * @param dest The destination address of the funds.
84   * @param amount The amount to transfer.
85   */
86   function asyncSend(address dest, uint256 amount) internal {
87     payments[dest] = payments[dest].add(amount);
88     totalPayments = totalPayments.add(amount);
89   }
90 }
91 interface MiniGameInterface {
92      function setupMiniGame(uint256 _miningWarRoundNumber, uint256 _miningWarDeadline) external;
93      function isContractMiniGame() external pure returns( bool _isContractMiniGame );
94 }
95 contract CryptoEngineerInterface {
96     address public gameSponsor;
97     function isEngineerContract() external pure returns(bool) {}
98     function isContractMiniGame() external pure returns( bool /*_isContractMiniGame*/ ) {}
99 }
100 
101 
102 contract CryptoMiningWar is PullPayment {
103     bool public initialized = false;
104     uint256 public roundNumber = 0;
105     uint256 public deadline;
106     uint256 public CRTSTAL_MINING_PERIOD = 86400; 
107     uint256 public HALF_TIME = 8 hours;
108     uint256 public ROUND_TIME = 86400 * 7;
109 	uint256 public prizePool = 0;
110     uint256 BASE_PRICE = 0.005 ether;
111     uint256 RANK_LIST_LIMIT = 10000;
112     uint256 public totalMiniGame = 0;
113 
114     uint256 private numberOfMiners = 8;
115     uint256 private numberOfBoosts = 5;
116     uint256 private numberOfRank   = 21;
117     
118     CryptoEngineerInterface  public Engineer;
119     
120     mapping(uint256 => address) public miniGameAddress;
121     //miner info
122     mapping(uint256 => MinerData) private minerData;
123     
124     // plyer info
125     mapping(address => Player) public players;
126     mapping(address => uint256) public boosterReward;
127     //booster info
128     mapping(uint256 => BoostData) private boostData;
129     //mini game contract info
130     mapping(address => bool) public miniGames;   
131     
132     
133     address[21] rankList;
134     address public administrator;
135     /*** DATATYPES ***/
136     struct Player {
137         uint256 roundNumber;
138         mapping(uint256 => uint256) minerCount;
139         uint256 hashrate;
140         uint256 crystals;
141         uint256 lastUpdateTime;
142     }
143     struct MinerData {
144         uint256 basePrice;
145         uint256 baseProduct;
146         uint256 limit;
147     }
148     struct BoostData {
149         address owner;
150         uint256 boostRate;
151         uint256 startingLevel;
152         uint256 startingTime;
153         uint256 halfLife;
154     }
155     modifier isNotOver() 
156     {
157         require(now <= deadline);
158         _;
159     }
160     modifier disableContract()
161     {
162         require(tx.origin == msg.sender);
163         _;
164     }
165     modifier isCurrentRound(address _addr) 
166     {
167         require(players[_addr].roundNumber == roundNumber);
168         _;
169     }
170     modifier isAdministrator()
171     {
172         require(msg.sender == administrator);
173         _;
174     }
175     modifier onlyContractsMiniGame() 
176     {
177         require(miniGames[msg.sender] == true);
178         _;
179     }
180     event GetFreeMiner(address _addr, uint256 _miningWarRound, uint256 _deadline);
181     event BuyMiner(address _addr, uint256[8] minerNumbers, uint256 _crystalsPrice, uint256 _hashrateBuy, uint256 _miningWarRound);
182     event ChangeHasrate(address _addr, uint256 _hashrate, uint256 _miningWarRound);
183     event ChangeCrystal(address _addr, uint256 _crystal, uint256 _type, uint256 _miningWarRound); //_type: 1 add crystal , 2: sub crystal
184     event BuyBooster(address _addr, uint256 _miningWarRound, uint256 _boosterId, uint256 _price, address beneficiary, uint256 refundPrize);
185     event Lottery(address[10] _topAddr, uint256[10] _reward, uint256 _miningWarRound);
186     event WithdrawReward(address _addr, uint256 _reward);
187     constructor() public {
188         administrator = msg.sender;
189         initMinerData();
190     }
191     function initMinerData() private 
192     {
193          //                      price,          prod.     limit
194         minerData[0] = MinerData(10,            10,         10);   //lv1
195         minerData[1] = MinerData(100,           200,        2);    //lv2
196         minerData[2] = MinerData(400,           800,        4);    //lv3
197         minerData[3] = MinerData(1600,          3200,       8);    //lv4 
198         minerData[4] = MinerData(6400,          9600,       16);   //lv5 
199         minerData[5] = MinerData(25600,         38400,      32);   //lv6 
200         minerData[6] = MinerData(204800,        204800,     64);   //lv7 
201         minerData[7] = MinerData(1638400,       819200,     65536); //lv8   
202     }
203     function () public payable
204     {
205 		prizePool = SafeMath.add(prizePool, msg.value);
206     }
207 
208     function isMiningWarContract() public pure returns(bool)
209     {
210         return true;
211     }
212 
213     function startGame() public isAdministrator
214     {
215         require(!initialized);
216         
217         startNewRound();
218         initialized = true;
219     }
220     function addMiner(address _addr, uint256 idx, uint256 _value) public isNotOver isCurrentRound(_addr) isAdministrator
221     {
222         require(idx < numberOfMiners);
223         require(_value != 0);
224 
225         Player storage p = players[_addr];
226         MinerData memory m = minerData[idx];
227 
228         if (SafeMath.add(p.minerCount[idx], _value) > m.limit) revert();
229 
230         updateCrystal( _addr );
231 
232         p.minerCount[idx] = SafeMath.add(p.minerCount[idx], _value);
233 
234         updateHashrate(_addr, SafeMath.mul(_value, m.baseProduct));
235     }
236     /**
237     * @dev add crystals to a player
238     * msg.sender should be in the list of mini game
239     * @param _addr player address 
240     */
241     function addCrystal( address _addr, uint256 _value ) public onlyContractsMiniGame isNotOver isCurrentRound(_addr)
242     {
243         uint256 crystals = SafeMath.mul(_value, CRTSTAL_MINING_PERIOD);
244         Player storage p = players[_addr];
245         p.crystals =  SafeMath.add( p.crystals, crystals ); 
246 
247         emit ChangeCrystal(_addr, _value, 1, roundNumber);
248     }
249     /**
250     * @dev sub player's crystals
251     * msg.sender should be in the list of mini game
252     * @param _addr player address
253     */
254     function subCrystal( address _addr, uint256 _value ) public onlyContractsMiniGame isNotOver isCurrentRound(_addr)
255     {
256         updateCrystal( _addr );
257         uint256 crystals = SafeMath.mul(_value,CRTSTAL_MINING_PERIOD);
258         require(crystals <= players[_addr].crystals);
259 
260         Player storage p = players[_addr];
261         p.crystals =  SafeMath.sub( p.crystals, crystals ); 
262 
263          emit ChangeCrystal(_addr, _value, 2, roundNumber);
264     }
265     /**
266     * @dev add hashrate to a player.
267     * msg.sender should be in the list of mini game
268     */
269     function addHashrate( address _addr, uint256 _value ) public onlyContractsMiniGame isNotOver isCurrentRound(_addr)
270     {
271         Player storage p = players[_addr];
272         p.hashrate =  SafeMath.add( p.hashrate, _value );
273 
274         emit ChangeHasrate(_addr, p.hashrate, roundNumber); 
275     }
276     /**
277     * @dev sub player's hashrate
278     * msg.sender should be in the list of mini game
279     */
280     function subHashrate( address _addr, uint256 _value ) public onlyContractsMiniGame isNotOver isCurrentRound(_addr)
281     {
282         require(players[_addr].hashrate >= _value);
283 
284         Player storage p = players[_addr];
285         
286         p.hashrate = SafeMath.sub( p.hashrate, _value ); 
287 
288         emit ChangeHasrate(_addr, p.hashrate, roundNumber);
289     }
290     function setEngineerInterface(address _addr) public isAdministrator
291     {
292         CryptoEngineerInterface engineerInterface = CryptoEngineerInterface(_addr);
293         
294         require(engineerInterface.isEngineerContract() == true);
295 
296         Engineer = engineerInterface;
297     }   
298     function setRoundNumber(uint256 _value) public isAdministrator
299     {
300         roundNumber = _value;
301     } 
302     function setContractsMiniGame( address _addr ) public  isAdministrator
303     {
304         require(miniGames[_addr] == false);
305         MiniGameInterface MiniGame = MiniGameInterface( _addr );
306         require(MiniGame.isContractMiniGame() == true );
307 
308         miniGames[_addr] = true;
309         miniGameAddress[totalMiniGame] = _addr;
310         totalMiniGame = totalMiniGame + 1;
311     }
312     /**
313     * @dev remove mini game contract from main contract
314     * @param _addr mini game contract address
315     */
316     function removeContractMiniGame(address _addr) public isAdministrator
317     {
318         miniGames[_addr] = false;
319     }
320 
321     function startNewRound() private 
322     {
323         deadline = SafeMath.add(now, ROUND_TIME);
324         roundNumber = SafeMath.add(roundNumber, 1);
325         initBoostData();
326         setupMiniGame();
327     }
328     function setupMiniGame() private 
329     {
330         for ( uint256 index = 0; index < totalMiniGame; index++ ) {
331             if (miniGames[miniGameAddress[index]] == true) {
332                 MiniGameInterface MiniGame = MiniGameInterface( miniGameAddress[index] );
333                 MiniGame.setupMiniGame(roundNumber,deadline);
334             }   
335         }
336     }
337     function initBoostData() private
338     {
339         //init booster data
340         boostData[0] = BoostData(0, 150, 1, now, HALF_TIME);
341         boostData[1] = BoostData(0, 175, 1, now, HALF_TIME);
342         boostData[2] = BoostData(0, 200, 1, now, HALF_TIME);
343         boostData[3] = BoostData(0, 225, 1, now, HALF_TIME);
344         boostData[4] = BoostData(msg.sender, 250, 2, now, HALF_TIME);
345         for (uint256 idx = 0; idx < numberOfRank; idx++) {
346             rankList[idx] = 0;
347         }
348     }
349     function lottery() public disableContract
350     {
351         require(now > deadline);
352         uint256 balance = SafeMath.div(SafeMath.mul(prizePool, 90), 100);
353 		uint256 devFee = SafeMath.div(SafeMath.mul(prizePool, 5), 100);
354         administrator.transfer(devFee);
355         uint8[10] memory profit = [30,20,10,8,7,5,5,5,5,5];
356 		uint256 totalPayment = 0;
357 		uint256 rankPayment = 0;
358         address[10] memory _topAddr;
359         uint256[10] memory _reward;
360         for(uint256 idx = 0; idx < 10; idx++){
361             if(rankList[idx] != 0){
362 
363 				rankPayment = SafeMath.div(SafeMath.mul(balance, profit[idx]),100);
364 				asyncSend(rankList[idx], rankPayment);
365 				totalPayment = SafeMath.add(totalPayment, rankPayment);
366 
367                 _topAddr[idx] = rankList[idx];
368                 _reward[idx] = rankPayment;
369             }
370         }
371 		prizePool = SafeMath.add(devFee, SafeMath.sub(balance, totalPayment));
372         
373         emit Lottery(_topAddr, _reward, roundNumber);
374 
375         startNewRound();
376     }
377     function getRankList() public view returns(address[21])
378     {
379         return rankList;
380     }
381     //--------------------------------------------------------------------------
382     // Miner 
383     //--------------------------------------------------------------------------
384     /**
385     * @dev get a free miner
386     */
387     function getFreeMiner(address _addr) public isNotOver disableContract
388     {
389         require(msg.sender == _addr);
390         require(players[_addr].roundNumber != roundNumber);
391         Player storage p = players[_addr];
392         //reset player data
393         if(p.hashrate > 0){
394             for (uint idx = 1; idx < numberOfMiners; idx++) {
395                 p.minerCount[idx] = 0;
396             }
397         }
398         MinerData storage m0 = minerData[0];
399         p.crystals = 0;
400         p.roundNumber = roundNumber;
401         //free miner
402         p.lastUpdateTime = now;
403         p.minerCount[0] = 1;
404         p.hashrate = m0.baseProduct;
405 
406         emit GetFreeMiner(_addr, roundNumber, deadline);
407     }
408     function getFreeMinerForMiniGame(address _addr) public isNotOver onlyContractsMiniGame
409     {
410         require(players[_addr].roundNumber != roundNumber);
411         Player storage p = players[_addr];
412         //reset player data
413         if(p.hashrate > 0){
414             for (uint idx = 1; idx < numberOfMiners; idx++) {
415                 p.minerCount[idx] = 0;
416             }
417         }
418         MinerData storage m0 = minerData[0];
419         p.crystals = 0;
420         p.roundNumber = roundNumber;
421         //free miner
422         p.lastUpdateTime = now;
423         p.minerCount[0] = 1;
424         p.hashrate = m0.baseProduct;
425 
426         emit GetFreeMiner(_addr, roundNumber, deadline);
427     }
428     function buyMiner(uint256[8] minerNumbers) public isNotOver isCurrentRound(msg.sender)
429     {           
430         updateCrystal(msg.sender);
431 
432         Player storage p = players[msg.sender];
433         uint256 price = 0;
434         uint256 hashrate = 0;
435 
436         for (uint256 minerIdx = 0; minerIdx < numberOfMiners; minerIdx++) {
437             MinerData memory m = minerData[minerIdx];
438             uint256 minerNumber = minerNumbers[minerIdx];
439            
440             if(minerNumbers[minerIdx] > m.limit || minerNumbers[minerIdx] < 0) revert();
441            
442             if (minerNumber > 0) {
443                 price = SafeMath.add(price, SafeMath.mul(m.basePrice, minerNumber));
444 
445                 uint256 currentMinerCount = p.minerCount[minerIdx];
446                 p.minerCount[minerIdx] = SafeMath.min(m.limit, SafeMath.add(p.minerCount[minerIdx], minerNumber));
447                 // calculate no hashrate you want buy
448                 hashrate = SafeMath.add(hashrate, SafeMath.mul(SafeMath.sub(p.minerCount[minerIdx],currentMinerCount), m.baseProduct));
449             }
450         }
451         
452         price = SafeMath.mul(price, CRTSTAL_MINING_PERIOD);
453         if(p.crystals < price) revert();
454         
455         p.crystals = SafeMath.sub(p.crystals, price);
456 
457         updateHashrate(msg.sender, hashrate);
458 
459         emit BuyMiner(msg.sender, minerNumbers, SafeMath.div(price, CRTSTAL_MINING_PERIOD), hashrate, roundNumber);
460     }
461     function getPlayerData(address addr) public view
462     returns (uint256 crystals, uint256 lastupdate, uint256 hashratePerDay, uint256[8] miners, uint256 hasBoost, uint256 playerBalance )
463     {
464         Player storage p = players[addr];
465 
466         if(p.roundNumber != roundNumber) p = players[0x0];
467         
468         crystals   = SafeMath.div(p.crystals, CRTSTAL_MINING_PERIOD);
469         lastupdate = p.lastUpdateTime;
470         hashratePerDay = p.hashrate;
471         uint256 i = 0;
472         for(i = 0; i < numberOfMiners; i++)
473         {
474             miners[i] = p.minerCount[i];
475         }
476         hasBoost = hasBooster(addr);
477 		playerBalance = payments[addr];
478     }
479     function getData(address _addr) 
480     public 
481     view 
482     returns (
483         uint256 crystals, 
484         uint256 lastupdate, 
485         uint256 hashratePerDay, 
486         uint256[8] miners, 
487         uint256 hasBoost, 
488         uint256 playerBalance, 
489 
490         uint256 _miningWarRound,
491         uint256 _miningWarDeadline,
492         uint256 _miningWarPrizePool 
493     ){
494         (, lastupdate, hashratePerDay, miners, hasBoost, playerBalance) = getPlayerData(_addr);
495         crystals = SafeMath.div(calCurrentCrystals(_addr), CRTSTAL_MINING_PERIOD);
496         _miningWarRound     = roundNumber;
497         _miningWarDeadline  = deadline;
498         _miningWarPrizePool = prizePool;
499     }
500     function getHashratePerDay(address _addr) public view returns (uint256 personalProduction)
501     {
502         Player memory p = players[_addr];
503         personalProduction =  p.hashrate;
504         uint256 boosterIdx = hasBooster(_addr);
505         if (boosterIdx != 999) {
506             BoostData memory b = boostData[boosterIdx];
507             personalProduction = SafeMath.div(SafeMath.mul(personalProduction, b.boostRate), 100);
508         } 
509     }
510     function getCurrentReward(address _addr) public view returns(uint256)
511     {
512         return payments[_addr];
513     }
514     function withdrawReward(address _addr) public 
515     {
516         uint256 currentReward = payments[_addr];
517         if (address(this).balance >= currentReward && currentReward > 0) {
518             _addr.transfer(currentReward);
519             payments[_addr]      = 0;
520             boosterReward[_addr] = 0;
521             emit WithdrawReward(_addr, currentReward);
522         }
523     } 
524     //--------------------------------------------------------------------------
525     // BOOSTER 
526     //--------------------------------------------------------------------------
527     function buyBooster(uint256 idx) public isNotOver isCurrentRound(msg.sender) payable 
528     {
529         require(idx < numberOfBoosts);
530         BoostData storage b = boostData[idx];
531         if(msg.value < getBoosterPrice(idx) || msg.sender == b.owner){
532             revert();
533         }
534         address beneficiary = b.owner;
535 		uint256 devFeePrize = devFee(getBoosterPrice(idx));
536         address gameSponsor = Engineer.gameSponsor();
537         gameSponsor.transfer(devFeePrize);
538 		uint256 refundPrize = 0;
539         if(beneficiary != 0){
540 			refundPrize = SafeMath.div(SafeMath.mul(getBoosterPrice(idx), 55), 100);
541 			asyncSend(beneficiary, refundPrize);
542             boosterReward[beneficiary] = SafeMath.add(boosterReward[beneficiary], refundPrize);
543         }
544 		prizePool = SafeMath.add(prizePool, SafeMath.sub(msg.value, SafeMath.add(devFeePrize, refundPrize)));
545         updateCrystal(msg.sender);
546         updateCrystal(beneficiary);
547         uint256 level   = getCurrentLevel(b.startingLevel, b.startingTime, b.halfLife);
548         b.startingLevel = SafeMath.add(level, 1);
549         b.startingTime = now;
550         // transfer ownership    
551         b.owner = msg.sender;
552 
553         emit BuyBooster(msg.sender, roundNumber, idx, msg.value, beneficiary, refundPrize);
554     }
555     function getBoosterData(uint256 idx) public view returns (address owner,uint256 boostRate, uint256 startingLevel, 
556         uint256 startingTime, uint256 currentPrice, uint256 halfLife)
557     {
558         require(idx < numberOfBoosts);
559         owner            = boostData[idx].owner;
560         boostRate        = boostData[idx].boostRate; 
561         startingLevel    = boostData[idx].startingLevel;
562         startingTime     = boostData[idx].startingTime;
563         currentPrice     = getBoosterPrice(idx);
564         halfLife         = boostData[idx].halfLife;
565     }
566     function getBoosterPrice(uint256 index) public view returns (uint256)
567     {
568         BoostData storage booster = boostData[index];
569         return getCurrentPrice(getCurrentLevel(booster.startingLevel, booster.startingTime, booster.halfLife));
570     }
571     function hasBooster(address addr) public view returns (uint256 boostIdx)
572     {         
573         boostIdx = 999;
574         for(uint256 i = 0; i < numberOfBoosts; i++){
575             uint256 revert_i = numberOfBoosts - i - 1;
576             if(boostData[revert_i].owner == addr){
577                 boostIdx = revert_i;
578                 break;
579             }
580         }
581     }
582     //--------------------------------------------------------------------------
583     // Other 
584     //--------------------------------------------------------------------------
585     function devFee(uint256 amount) public pure returns(uint256)
586     {
587         return SafeMath.div(SafeMath.mul(amount, 5), 100);
588     }
589     function getBalance() public view returns(uint256)
590     {
591         return address(this).balance;
592     }
593 	//@dev use this function in case of bug
594     function upgrade(address addr) public isAdministrator
595     {
596         selfdestruct(addr);
597     }
598 
599     //--------------------------------------------------------------------------
600     // Private 
601     //--------------------------------------------------------------------------
602     /**
603     * @param addr is player address you want add hash rate
604     * @param _hashrate is no hashrate you want add for this player
605     */
606     function updateHashrate(address addr, uint256 _hashrate) private
607     {
608         Player storage p = players[addr];
609        
610         p.hashrate = SafeMath.add(p.hashrate, _hashrate);
611        
612         if(p.hashrate > RANK_LIST_LIMIT) updateRankList(addr);
613         
614         emit ChangeHasrate(addr, p.hashrate, roundNumber);
615     }
616     function updateCrystal(address _addr) private
617     {
618         require(now > players[_addr].lastUpdateTime);
619 
620         Player storage p = players[_addr]; 
621         p.crystals = calCurrentCrystals(_addr);
622         p.lastUpdateTime = now;
623     }
624      /**
625     * @dev calculate current crystals of player
626     * @param _addr player address
627     */
628     function calCurrentCrystals(address _addr) public view returns(uint256 _currentCrystals)
629     {
630         Player memory p = players[_addr];
631 
632         if(p.roundNumber != roundNumber) p = players[0x0];
633 
634         uint256 hashratePerDay = getHashratePerDay(_addr);     
635         uint256 secondsPassed = SafeMath.sub(now, p.lastUpdateTime);      
636         
637         if (hashratePerDay > 0) _currentCrystals = SafeMath.add(p.crystals, SafeMath.mul(hashratePerDay, secondsPassed));
638     }
639     function getCurrentLevel(uint256 startingLevel, uint256 startingTime, uint256 halfLife) private view returns(uint256) 
640     {
641         uint256 timePassed=SafeMath.sub(now, startingTime);
642         uint256 levelsPassed=SafeMath.div(timePassed, halfLife);
643         if (startingLevel < levelsPassed) {
644             return 0;
645         }
646         return SafeMath.sub(startingLevel, levelsPassed);
647     }
648     function getCurrentPrice(uint256 currentLevel) private view returns(uint256) 
649     {
650         return SafeMath.mul(BASE_PRICE, 2**currentLevel);
651     }
652     function updateRankList(address addr) private returns(bool)
653     {
654         uint256 idx = 0;
655         Player storage insert = players[addr];
656         Player storage lastOne = players[rankList[19]];
657         if(insert.hashrate < lastOne.hashrate) {
658             return false;
659         }
660         address[21] memory tempList = rankList;
661         if(!inRankList(addr)){
662             tempList[20] = addr;
663             quickSort(tempList, 0, 20);
664         }else{
665             quickSort(tempList, 0, 19);
666         }
667         for(idx = 0;idx < 21; idx++){
668             if(tempList[idx] != rankList[idx]){
669                 rankList[idx] = tempList[idx];
670             }
671         }
672         
673         return true;
674     }
675     function inRankList(address addr) internal view returns(bool)
676     {
677         for(uint256 idx = 0;idx < 20; idx++){
678             if(addr == rankList[idx]){
679                 return true;
680             }
681         }
682         return false;
683     }
684     function quickSort(address[21] list, int left, int right) internal
685     {
686         int i = left;
687         int j = right;
688         if(i == j) return;
689         address addr = list[uint(left + (right - left) / 2)];
690         Player storage p = players[addr];
691         while (i <= j) {
692             while (players[list[uint(i)]].hashrate > p.hashrate) i++;
693             while (p.hashrate > players[list[uint(j)]].hashrate) j--;
694             if (i <= j) {
695                 (list[uint(i)], list[uint(j)]) = (list[uint(j)], list[uint(i)]);
696                 i++;
697                 j--;
698             }
699         }
700         if (left < j)
701             quickSort(list, left, j);
702         if (i < right)
703             quickSort(list, i, right);
704     }
705 }