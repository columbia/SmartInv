1 pragma solidity ^0.4.24;
2 
3 /*
4 * CryptoMiningWar - Mining Contest Game
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
91 
92 interface MiniGameInterface {
93      function setupMiniGame(uint256 _miningWarRoundNumber, uint256 _miningWarDeadline) external;
94      function isContractMiniGame() external pure returns( bool _isContractMiniGame );
95 }
96 
97 contract CryptoMiningWar is PullPayment {
98     bool public initialized = false;
99     uint256 public roundNumber = 0;
100     uint256 public deadline;
101     uint256 public CRTSTAL_MINING_PERIOD = 86400; 
102     uint256 public HALF_TIME = 8 hours;
103     uint256 public ROUND_TIME = 86400 * 7;
104 	uint256 public prizePool = 0;
105     uint256 BASE_PRICE = 0.005 ether;
106     uint256 RANK_LIST_LIMIT = 10000;
107     uint256 randNonce = 0;
108     uint256 public totalContractMiniGame = 0;
109     
110     mapping(uint256 => address) public contractsMiniGameAddress;
111     //miner info
112     mapping(uint256 => MinerData) private minerData;
113     uint256 private numberOfMiners;
114     // plyer info
115     mapping(address => PlayerData) public players;
116     //booster info
117     uint256 private numberOfBoosts;
118     mapping(uint256 => BoostData) private boostData;
119     //mini game contract info
120     mapping(address => bool) public miniGames;   
121     
122     uint256 private numberOfRank;
123     address[21] rankList;
124     address public sponsor;
125     uint256 public sponsorLevel;
126     address public administrator;
127     /*** DATATYPES ***/
128     struct PlayerData {
129         uint256 roundNumber;
130         mapping(uint256 => uint256) minerCount;
131         uint256 hashrate;
132         uint256 crystals;
133         uint256 lastUpdateTime;
134         uint256 referral_count;
135         uint256 noQuest;
136     }
137     struct MinerData {
138         uint256 basePrice;
139         uint256 baseProduct;
140         uint256 limit;
141     }
142     struct BoostData {
143         address owner;
144         uint256 boostRate;
145         uint256 startingLevel;
146         uint256 startingTime;
147         uint256 halfLife;
148     }
149     modifier isNotOver() 
150     {
151         require(now <= deadline);
152         _;
153     }
154     modifier disableContract()
155     {
156         require(tx.origin == msg.sender);
157         _;
158     }
159     modifier isCurrentRound() 
160     {
161         require(players[msg.sender].roundNumber == roundNumber);
162         _;
163     }
164     modifier onlyContractsMiniGame() 
165     {
166         require(miniGames[msg.sender] == true);
167         _;
168     }
169     event eventDoQuest(
170         uint clientNumber,
171         uint randomNumber
172     );
173     constructor() public {
174         administrator = msg.sender;
175         numberOfMiners = 8;
176         numberOfBoosts = 5;
177         numberOfRank = 21;
178         //init miner data
179         //                      price,          prod.     limit
180         minerData[0] = MinerData(10,            10,         10);   //lv1
181         minerData[1] = MinerData(100,           200,        2);    //lv2
182         minerData[2] = MinerData(400,           800,        4);    //lv3
183         minerData[3] = MinerData(1600,          3200,       8);    //lv4 
184         minerData[4] = MinerData(6400,          9600,       16);   //lv5 
185         minerData[5] = MinerData(25600,         38400,      32);   //lv6 
186         minerData[6] = MinerData(204800,        204800,     64);   //lv7 
187         minerData[7] = MinerData(1638400,       819200,     65536); //lv8
188     }
189     function () public payable
190     {
191 		prizePool = SafeMath.add(prizePool, msg.value);
192     }
193     function startGame() public
194     {
195         require(msg.sender == administrator);
196         require(!initialized);
197         
198         startNewRound();
199         initialized = true;
200     }
201     /**
202     * @dev add crystals to a player
203     * msg.sender should be in the list of mini game
204     */
205     function addCrystal( address _addr, uint256 _value ) public onlyContractsMiniGame
206     {
207         require(players[_addr].roundNumber == roundNumber);
208 
209         uint256 crystals = SafeMath.mul(_value, CRTSTAL_MINING_PERIOD);
210         PlayerData storage p = players[_addr];
211         p.crystals =  SafeMath.add( p.crystals, crystals ); 
212     }
213     /**
214     * @dev sub player's crystals
215     * msg.sender should be in the list of mini game
216     * @param _addr player address
217     */
218     function subCrystal( address _addr, uint256 _value ) public onlyContractsMiniGame
219     {
220         require(players[_addr].roundNumber == roundNumber);
221         updateCrystal( _addr );
222         uint256 crystals = SafeMath.mul(_value,CRTSTAL_MINING_PERIOD);
223         require(crystals <= players[_addr].crystals);
224 
225         PlayerData storage p = players[_addr];
226         p.crystals =  SafeMath.sub( p.crystals, crystals ); 
227     }
228     /**
229     * @dev add hashrate to a player.
230     * msg.sender should be in the list of mini game
231     */
232     function addHashrate( address _addr, uint256 _value ) public onlyContractsMiniGame
233     {
234         require(players[_addr].roundNumber == roundNumber);
235 
236         PlayerData storage p = players[_addr];
237         p.hashrate =  SafeMath.add( p.hashrate, _value ); 
238     }
239     /**
240     * @dev sub player's hashrate
241     * msg.sender should be in the list of mini game
242     */
243     function subHashrate( address _addr, uint256 _value ) public onlyContractsMiniGame
244     {
245         require(players[_addr].roundNumber == roundNumber && players[_addr].hashrate >= _value);
246 
247         PlayerData storage p = players[_addr];
248         
249         p.hashrate = SafeMath.sub( p.hashrate, _value ); 
250     }
251     function setContractsMiniGame( address _contractMiniGameAddress ) public  
252     {
253         require(administrator == msg.sender);
254 
255         MiniGameInterface MiniGame = MiniGameInterface( _contractMiniGameAddress );
256         bool isContractMiniGame = MiniGame.isContractMiniGame();
257         require( isContractMiniGame == true );
258 
259         if ( miniGames[_contractMiniGameAddress] == false ) {
260             miniGames[_contractMiniGameAddress] = true;
261             contractsMiniGameAddress[totalContractMiniGame] = _contractMiniGameAddress;
262             totalContractMiniGame = totalContractMiniGame + 1;
263         }
264     }
265     /**
266     * @dev remove mini game contract from main contract
267     * @param _contractMiniGameAddress mini game contract address
268     */
269     function removeContractMiniGame(address _contractMiniGameAddress) public
270     {
271         require(administrator == msg.sender);        
272         miniGames[_contractMiniGameAddress] = false;
273     }
274 
275     function startNewRound() private 
276     {
277         deadline = SafeMath.add(now, ROUND_TIME);
278         roundNumber = SafeMath.add(roundNumber, 1);
279         initData();
280         setupMiniGame();
281     }
282     function setupMiniGame() private 
283     {
284         for ( uint256 index = 0; index < totalContractMiniGame; index++ ) {
285             if (miniGames[contractsMiniGameAddress[index]] == true) {
286                 MiniGameInterface MiniGame = MiniGameInterface( contractsMiniGameAddress[index] );
287                 MiniGame.setupMiniGame(roundNumber,deadline);
288             }   
289         }
290     }
291     function initData() private
292     {
293         sponsor = administrator;
294         sponsorLevel = 6;
295         //init booster data
296         boostData[0] = BoostData(0, 150, 1, now, HALF_TIME);
297         boostData[1] = BoostData(0, 175, 1, now, HALF_TIME);
298         boostData[2] = BoostData(0, 200, 1, now, HALF_TIME);
299         boostData[3] = BoostData(0, 225, 1, now, HALF_TIME);
300         boostData[4] = BoostData(msg.sender, 250, 2, now, HALF_TIME);
301         for (uint256 idx = 0; idx < numberOfRank; idx++) {
302             rankList[idx] = 0;
303         }
304     }
305     function lottery() public disableContract
306     {
307         require(now > deadline);
308         uint256 balance = SafeMath.div(SafeMath.mul(prizePool, 90), 100);
309 		uint256 devFee = SafeMath.div(SafeMath.mul(prizePool, 5), 100);
310 		asyncSend(administrator, devFee);
311         uint8[10] memory profit = [30,20,10,8,7,5,5,5,5,5];
312 		uint256 totalPayment = 0;
313 		uint256 rankPayment = 0;
314         for(uint256 idx = 0; idx < 10; idx++){
315             if(rankList[idx] != 0){
316 				rankPayment = SafeMath.div(SafeMath.mul(balance, profit[idx]),100);
317 				asyncSend(rankList[idx], rankPayment);
318 				totalPayment = SafeMath.add(totalPayment, rankPayment);
319             }
320         }
321 		prizePool = SafeMath.add(devFee, SafeMath.sub(balance, totalPayment));
322         startNewRound();
323     }
324     function getRankList() public view returns(address[21])
325     {
326         return rankList;
327     }
328     //sponser
329     function becomeSponsor() public isNotOver payable
330     {
331         require(msg.value >= getSponsorFee());
332 		require(msg.sender != sponsor);
333 		uint256 sponsorPrice = getCurrentPrice(sponsorLevel);
334 		asyncSend(sponsor, sponsorPrice);
335 		prizePool = SafeMath.add(prizePool, SafeMath.sub(msg.value, sponsorPrice));
336         sponsor = msg.sender;
337         sponsorLevel = SafeMath.add(sponsorLevel, 1);
338     }
339     function getSponsorFee() public view returns(uint256 sponsorFee)
340     {
341         sponsorFee = getCurrentPrice(SafeMath.add(sponsorLevel, 1));
342     }
343     //--------------------------------------------------------------------------
344     // Miner 
345     //--------------------------------------------------------------------------
346     /**
347     * @dev get a free miner
348     */
349     function getFreeMiner() public disableContract isNotOver
350     {
351         require(players[msg.sender].roundNumber != roundNumber);
352         PlayerData storage p = players[msg.sender];
353         //reset player data
354         if(p.hashrate > 0){
355             for (uint idx = 1; idx < numberOfMiners; idx++) {
356                 p.minerCount[idx] = 0;
357             }
358         }
359         MinerData storage m0 = minerData[0];
360         p.crystals = 0;
361         p.roundNumber = roundNumber;
362         //free miner
363         p.lastUpdateTime = now;
364         p.referral_count = 0;
365         p.noQuest        = 0;
366         p.minerCount[0] = 1;
367         p.hashrate = m0.baseProduct;
368     }
369 	function doQuest(uint256 clientNumber) disableContract isCurrentRound isNotOver public
370 	{
371 		PlayerData storage p = players[msg.sender];
372         p.noQuest            = SafeMath.add(p.noQuest, 1);
373 		uint256 randomNumber = getRandomNumber(msg.sender);
374 		if(clientNumber == randomNumber) {
375             p.referral_count = SafeMath.add(p.referral_count, 1);
376 		}
377 		emit eventDoQuest(clientNumber, randomNumber);
378 	}
379     function buyMiner(uint256[] minerNumbers) public isNotOver isCurrentRound
380     {   
381         require(minerNumbers.length == numberOfMiners);
382         uint256 minerIdx = 0;
383         MinerData memory m;
384         for (; minerIdx < numberOfMiners; minerIdx++) {
385             m = minerData[minerIdx];
386             if(minerNumbers[minerIdx] > m.limit || minerNumbers[minerIdx] < 0){
387                 revert();
388             }
389         }
390         updateCrystal(msg.sender);
391         PlayerData storage p = players[msg.sender];
392         uint256 price = 0;
393         uint256 minerNumber = 0;
394         for (minerIdx = 0; minerIdx < numberOfMiners; minerIdx++) {
395             minerNumber = minerNumbers[minerIdx];
396             if (minerNumber > 0) {
397                 m = minerData[minerIdx];
398                 price = SafeMath.add(price, SafeMath.mul(m.basePrice, minerNumber));
399             }
400         }
401         price = SafeMath.mul(price, CRTSTAL_MINING_PERIOD);
402         if(p.crystals < price){
403             revert();
404         }
405         p.crystals = SafeMath.sub(p.crystals, price);
406         uint256 hashrate = 0;
407         for (minerIdx = 0; minerIdx < numberOfMiners; minerIdx++) {
408             minerNumber = minerNumbers[minerIdx];
409             if (minerNumber > 0) {
410                 m = minerData[minerIdx];
411                 uint256 currentMinerCount = p.minerCount[minerIdx];
412                 p.minerCount[minerIdx] = SafeMath.min(m.limit, SafeMath.add(p.minerCount[minerIdx], minerNumber));
413                 // calculate no hashrate you want buy
414                 hashrate = SafeMath.add(hashrate, SafeMath.mul(SafeMath.sub(p.minerCount[minerIdx],currentMinerCount), minerData[minerIdx].baseProduct));
415             }
416         }
417 
418         updateHashrate(msg.sender, hashrate);
419     }
420     function getPlayerData(address addr) public view
421     returns (uint256 crystals, uint256 lastupdate, uint256 hashratePerDay, uint256[8] miners, uint256 hasBoost, uint256 referral_count, uint256 playerBalance, uint256 noQuest )
422     {
423         PlayerData storage p = players[addr];
424         if(p.roundNumber != roundNumber){
425             p = players[0];
426         }
427         crystals   = SafeMath.div(p.crystals, CRTSTAL_MINING_PERIOD);
428         lastupdate = p.lastUpdateTime;
429         hashratePerDay = addReferralHashrate(addr, p.hashrate);
430         uint256 i = 0;
431         for(i = 0; i < numberOfMiners; i++)
432         {
433             miners[i] = p.minerCount[i];
434         }
435         hasBoost = hasBooster(addr);
436         referral_count = p.referral_count;
437         noQuest        = p.noQuest; 
438 		playerBalance = payments[addr];
439     }
440     function getHashratePerDay(address minerAddr) public view returns (uint256 personalProduction)
441     {
442         PlayerData storage p = players[minerAddr];   
443         personalProduction = addReferralHashrate(minerAddr, p.hashrate);
444         uint256 boosterIdx = hasBooster(minerAddr);
445         if (boosterIdx != 999) {
446             BoostData storage b = boostData[boosterIdx];
447             personalProduction = SafeMath.div(SafeMath.mul(personalProduction, b.boostRate), 100);
448         }
449     }
450     //--------------------------------------------------------------------------
451     // BOOSTER 
452     //--------------------------------------------------------------------------
453     function buyBooster(uint256 idx) public isNotOver isCurrentRound payable 
454     {
455         require(idx < numberOfBoosts);
456         BoostData storage b = boostData[idx];
457         if(msg.value < getBoosterPrice(idx) || msg.sender == b.owner){
458             revert();
459         }
460         address beneficiary = b.owner;
461 		uint256 devFeePrize = devFee(getBoosterPrice(idx));
462 		asyncSend(sponsor, devFeePrize);
463 		uint256 refundPrize = 0;
464         if(beneficiary != 0){
465 			refundPrize = SafeMath.div(SafeMath.mul(getBoosterPrice(idx), 55), 100);
466 			asyncSend(beneficiary, refundPrize);
467         }
468 		prizePool = SafeMath.add(prizePool, SafeMath.sub(msg.value, SafeMath.add(devFeePrize, refundPrize)));
469         updateCrystal(msg.sender);
470         updateCrystal(beneficiary);
471         uint256 level = getCurrentLevel(b.startingLevel, b.startingTime, b.halfLife);
472         b.startingLevel = SafeMath.add(level, 1);
473         b.startingTime = now;
474         // transfer ownership    
475         b.owner = msg.sender;
476     }
477     function getBoosterData(uint256 idx) public view returns (address owner,uint256 boostRate, uint256 startingLevel, 
478         uint256 startingTime, uint256 currentPrice, uint256 halfLife)
479     {
480         require(idx < numberOfBoosts);
481         owner            = boostData[idx].owner;
482         boostRate        = boostData[idx].boostRate; 
483         startingLevel    = boostData[idx].startingLevel;
484         startingTime     = boostData[idx].startingTime;
485         currentPrice     = getBoosterPrice(idx);
486         halfLife         = boostData[idx].halfLife;
487     }
488     function getBoosterPrice(uint256 index) public view returns (uint256)
489     {
490         BoostData storage booster = boostData[index];
491         return getCurrentPrice(getCurrentLevel(booster.startingLevel, booster.startingTime, booster.halfLife));
492     }
493     function hasBooster(address addr) public view returns (uint256 boostIdx)
494     {         
495         boostIdx = 999;
496         for(uint256 i = 0; i < numberOfBoosts; i++){
497             uint256 revert_i = numberOfBoosts - i - 1;
498             if(boostData[revert_i].owner == addr){
499                 boostIdx = revert_i;
500                 break;
501             }
502         }
503     }
504     //--------------------------------------------------------------------------
505     // Other 
506     //--------------------------------------------------------------------------
507     function devFee(uint256 amount) public pure returns(uint256)
508     {
509         return SafeMath.div(SafeMath.mul(amount, 5), 100);
510     }
511     function getBalance() public view returns(uint256)
512     {
513         return address(this).balance;
514     }
515 	//@dev use this function in case of bug
516     function upgrade(address addr) public 
517     {
518         require(msg.sender == administrator);
519         selfdestruct(addr);
520     }
521 
522     //--------------------------------------------------------------------------
523     // Private 
524     //--------------------------------------------------------------------------
525     /**
526     * @param addr is player address you want add hash rate
527     * @param _hashrate is no hashrate you want add for this player
528     */
529     function updateHashrate(address addr, uint256 _hashrate) private
530     {
531         PlayerData storage p = players[addr];
532         p.hashrate = SafeMath.add(p.hashrate, _hashrate);
533         if(p.hashrate > RANK_LIST_LIMIT){
534             updateRankList(addr);
535         }
536     }
537     function updateCrystal(address addr) private
538     {
539         require(now > players[addr].lastUpdateTime);
540         if (players[addr].lastUpdateTime != 0) {
541             PlayerData storage p = players[addr];
542             uint256 secondsPassed = SafeMath.sub(now, p.lastUpdateTime);
543             uint256 revenue = getHashratePerDay(addr);
544             p.lastUpdateTime = now;
545             if (revenue > 0) {
546                 revenue = SafeMath.mul(revenue, secondsPassed);
547                 p.crystals = SafeMath.add(p.crystals, revenue);
548             }
549         }
550     }
551     function addReferralHashrate(address addr, uint256 hashrate) private view returns(uint256 personalProduction) 
552     {
553         PlayerData storage p = players[addr];
554         if(p.referral_count < 5){
555             personalProduction = SafeMath.add(hashrate, SafeMath.mul(p.referral_count, 10));
556         }else if(p.referral_count < 10){
557             personalProduction = SafeMath.add(hashrate, SafeMath.add(50, SafeMath.mul(p.referral_count, 10)));
558         }else{
559             personalProduction = SafeMath.add(hashrate, 200);
560         }
561     }
562     function getCurrentLevel(uint256 startingLevel, uint256 startingTime, uint256 halfLife) private view returns(uint256) 
563     {
564         uint256 timePassed=SafeMath.sub(now, startingTime);
565         uint256 levelsPassed=SafeMath.div(timePassed, halfLife);
566         if (startingLevel < levelsPassed) {
567             return 0;
568         }
569         return SafeMath.sub(startingLevel, levelsPassed);
570     }
571     function getCurrentPrice(uint256 currentLevel) private view returns(uint256) 
572     {
573         return SafeMath.mul(BASE_PRICE, 2**currentLevel);
574     }
575     function updateRankList(address addr) private returns(bool)
576     {
577         uint256 idx = 0;
578         PlayerData storage insert = players[addr];
579         PlayerData storage lastOne = players[rankList[19]];
580         if(insert.hashrate < lastOne.hashrate) {
581             return false;
582         }
583         address[21] memory tempList = rankList;
584         if(!inRankList(addr)){
585             tempList[20] = addr;
586             quickSort(tempList, 0, 20);
587         }else{
588             quickSort(tempList, 0, 19);
589         }
590         for(idx = 0;idx < 21; idx++){
591             if(tempList[idx] != rankList[idx]){
592                 rankList[idx] = tempList[idx];
593             }
594         }
595         
596         return true;
597     }
598     function inRankList(address addr) internal view returns(bool)
599     {
600         for(uint256 idx = 0;idx < 20; idx++){
601             if(addr == rankList[idx]){
602                 return true;
603             }
604         }
605         return false;
606     }
607 	function getRandomNumber(address playerAddress) internal returns(uint256 randomNumber) {
608         randNonce++;
609         randomNumber = uint256(keccak256(abi.encodePacked(now, playerAddress, randNonce))) % 3;
610     }
611     function quickSort(address[21] list, int left, int right) internal
612     {
613         int i = left;
614         int j = right;
615         if(i == j) return;
616         address addr = list[uint(left + (right - left) / 2)];
617         PlayerData storage p = players[addr];
618         while (i <= j) {
619             while (players[list[uint(i)]].hashrate > p.hashrate) i++;
620             while (p.hashrate > players[list[uint(j)]].hashrate) j--;
621             if (i <= j) {
622                 (list[uint(i)], list[uint(j)]) = (list[uint(j)], list[uint(i)]);
623                 i++;
624                 j--;
625             }
626         }
627         if (left < j)
628             quickSort(list, left, j);
629         if (i < right)
630             quickSort(list, i, right);
631     }
632 }