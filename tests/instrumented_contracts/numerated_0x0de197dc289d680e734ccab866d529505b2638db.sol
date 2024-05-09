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
48 
49 /**
50  * @title PullPayment
51  * @dev Base contract supporting async send for pull payments. Inherit from this
52  * contract and use asyncSend instead of send or transfer.
53  */
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
86 
87 contract CryptoMiningWar is PullPayment {
88     bool public initialized = false;
89     uint256 public roundNumber = 0;
90     uint256 public deadline;
91     uint256 public CRTSTAL_MINING_PERIOD = 86400; 
92     uint256 public HALF_TIME = 8 hours;
93     uint256 public ROUND_TIME = 86400 * 7;
94 	uint256 public prizePool = 0;
95     uint256 BASE_PRICE = 0.005 ether;
96     uint256 RANK_LIST_LIMIT = 10000;
97     uint256 MINIMUM_LIMIT_SELL = 5000000;
98     uint256 randNonce = 0;
99     //miner info
100     mapping(uint256 => MinerData) private minerData;
101     uint256 private numberOfMiners;
102     // plyer info
103     mapping(address => PlayerData) private players;
104     //booster info
105     uint256 private numberOfBoosts;
106     mapping(uint256 => BoostData) private boostData;
107     //order info
108     uint256 private numberOfOrders;
109     mapping(uint256 => BuyOrderData) private buyOrderData;
110     mapping(uint256 => SellOrderData) private sellOrderData;
111     uint256 private numberOfRank;
112     address[21] rankList;
113     address public sponsor;
114     uint256 public sponsorLevel;
115     address public administrator;
116     /*** DATATYPES ***/
117     struct PlayerData {
118         uint256 roundNumber;
119         mapping(uint256 => uint256) minerCount;
120         uint256 hashrate;
121         uint256 crystals;
122         uint256 lastUpdateTime;
123         uint256 referral_count;
124         uint256 noQuest;
125     }
126     struct MinerData {
127         uint256 basePrice;
128         uint256 baseProduct;
129         uint256 limit;
130     }
131     struct BoostData {
132         address owner;
133         uint256 boostRate;
134         uint256 startingLevel;
135         uint256 startingTime;
136         uint256 halfLife;
137     }
138     struct BuyOrderData {
139         address owner;
140         string title;
141         string description;
142         uint256 unitPrice;
143         uint256 amount;
144     }
145     struct SellOrderData {
146         address owner;
147         string title;
148         string description;
149         uint256 unitPrice;
150         uint256 amount;
151     }
152     event eventDoQuest(
153         uint clientNumber,
154         uint randomNumber
155     );
156     modifier isNotOver() 
157     {
158         require(now <= deadline);
159         _;
160     }
161     modifier disableContract()
162     {
163         require(tx.origin == msg.sender);
164         _;
165     }
166     modifier isCurrentRound() 
167     {
168         require(players[msg.sender].roundNumber == roundNumber);
169         _;
170     }
171     modifier limitSell() 
172     {
173         PlayerData storage p = players[msg.sender];
174         if(p.hashrate <= MINIMUM_LIMIT_SELL){
175             _;
176         }else{
177             uint256 limit_hashrate = 0;
178             if(rankList[9] != 0){
179                 PlayerData storage rank_player = players[rankList[9]];
180                 limit_hashrate = SafeMath.mul(rank_player.hashrate, 5);
181             }
182             require(p.hashrate <= limit_hashrate);
183             _;
184         }
185     }
186     constructor() public {
187         administrator = msg.sender;
188         numberOfMiners = 8;
189         numberOfBoosts = 5;
190         numberOfOrders = 5;
191         numberOfRank = 21;
192         //init miner data
193         //                      price,          prod.     limit
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
207     function startGame() public
208     {
209         require(msg.sender == administrator);
210         require(!initialized);
211         startNewRound();
212         initialized = true;
213     }
214 
215     function startNewRound() private 
216     {
217         deadline = SafeMath.add(now, ROUND_TIME);
218         roundNumber = SafeMath.add(roundNumber, 1);
219         initData();
220     }
221     function initData() private
222     {
223         sponsor = administrator;
224         sponsorLevel = 6;
225         //init booster data
226         boostData[0] = BoostData(0, 150, 1, now, HALF_TIME);
227         boostData[1] = BoostData(0, 175, 1, now, HALF_TIME);
228         boostData[2] = BoostData(0, 200, 1, now, HALF_TIME);
229         boostData[3] = BoostData(0, 225, 1, now, HALF_TIME);
230         boostData[4] = BoostData(msg.sender, 250, 2, now, HALF_TIME);
231         //init order data
232         uint256 idx;
233         for (idx = 0; idx < numberOfOrders; idx++) {
234             buyOrderData[idx] = BuyOrderData(0, "title", "description", 0, 0);
235             sellOrderData[idx] = SellOrderData(0, "title", "description", 0, 0);
236         }
237         for (idx = 0; idx < numberOfRank; idx++) {
238             rankList[idx] = 0;
239         }
240     }
241     function lottery() public disableContract
242     {
243         require(now > deadline);
244         uint256 balance = SafeMath.div(SafeMath.mul(prizePool, 90), 100);
245 		uint256 devFee = SafeMath.div(SafeMath.mul(prizePool, 5), 100);
246 		asyncSend(administrator, devFee);
247         uint8[10] memory profit = [30,20,10,8,7,5,5,5,5,5];
248 		uint256 totalPayment = 0;
249 		uint256 rankPayment = 0;
250         for(uint256 idx = 0; idx < 10; idx++){
251             if(rankList[idx] != 0){
252 				rankPayment = SafeMath.div(SafeMath.mul(balance, profit[idx]),100);
253 				asyncSend(rankList[idx], rankPayment);
254 				totalPayment = SafeMath.add(totalPayment, rankPayment);
255             }
256         }
257 		prizePool = SafeMath.add(devFee, SafeMath.sub(balance, totalPayment));
258         startNewRound();
259     }
260     function getRankList() public view returns(address[21])
261     {
262         return rankList;
263     }
264     //sponser
265     function becomeSponsor() public isNotOver payable
266     {
267         require(msg.value >= getSponsorFee());
268 		require(msg.sender != sponsor);
269 		uint256 sponsorPrice = getCurrentPrice(sponsorLevel);
270 		asyncSend(sponsor, sponsorPrice);
271 		prizePool = SafeMath.add(prizePool, SafeMath.sub(msg.value, sponsorPrice));
272         sponsor = msg.sender;
273         sponsorLevel = SafeMath.add(sponsorLevel, 1);
274     }
275     function getSponsorFee() public view returns(uint256 sponsorFee)
276     {
277         sponsorFee = getCurrentPrice(SafeMath.add(sponsorLevel, 1));
278     }
279     //--------------------------------------------------------------------------
280     // Miner 
281     //--------------------------------------------------------------------------
282     function getFreeMiner(address ref) public disableContract isNotOver
283     {
284         require(players[msg.sender].roundNumber != roundNumber);
285         PlayerData storage p = players[msg.sender];
286         //reset player data
287         if(p.hashrate > 0){
288             for (uint idx = 1; idx < numberOfMiners; idx++) {
289                 p.minerCount[idx] = 0;
290             }
291         }
292         p.crystals = 0;
293         p.roundNumber = roundNumber;
294         //free miner
295         p.lastUpdateTime = now;
296         p.referral_count = 0;
297         p.noQuest        = 0;
298         p.minerCount[0] = 1;
299         MinerData storage m0 = minerData[0];
300         p.hashrate = m0.baseProduct;
301     }
302 	function doQuest(uint256 clientNumber) disableContract isCurrentRound isNotOver public
303 	{
304 		PlayerData storage p = players[msg.sender];
305         p.noQuest            = SafeMath.add(p.noQuest, 1);
306 		uint256 randomNumber = getRandomNumber(msg.sender);
307 		if(clientNumber == randomNumber) {
308             p.referral_count = SafeMath.add(p.referral_count, 1);
309 		}
310 		emit eventDoQuest(clientNumber, randomNumber);
311 	}
312     function buyMiner(uint256[] minerNumbers) public isNotOver isCurrentRound
313     {   
314         require(minerNumbers.length == numberOfMiners);
315         uint256 minerIdx = 0;
316         MinerData memory m;
317         for (; minerIdx < numberOfMiners; minerIdx++) {
318             m = minerData[minerIdx];
319             if(minerNumbers[minerIdx] > m.limit || minerNumbers[minerIdx] < 0){
320                 revert();
321             }
322         }
323         updateCrytal(msg.sender);
324         PlayerData storage p = players[msg.sender];
325         uint256 price = 0;
326         uint256 minerNumber = 0;
327         for (minerIdx = 0; minerIdx < numberOfMiners; minerIdx++) {
328             minerNumber = minerNumbers[minerIdx];
329             if (minerNumber > 0) {
330                 m = minerData[minerIdx];
331                 price = SafeMath.add(price, SafeMath.mul(m.basePrice, minerNumber));
332             }
333         }
334         price = SafeMath.mul(price, CRTSTAL_MINING_PERIOD);
335         if(p.crystals < price){
336             revert();
337         }
338         for (minerIdx = 0; minerIdx < numberOfMiners; minerIdx++) {
339             minerNumber = minerNumbers[minerIdx];
340             if (minerNumber > 0) {
341                 m = minerData[minerIdx];
342                 p.minerCount[minerIdx] = SafeMath.min(m.limit, SafeMath.add(p.minerCount[minerIdx], minerNumber));
343             }
344         }
345         p.crystals = SafeMath.sub(p.crystals, price);
346         updateHashrate(msg.sender);
347     }
348     function getPlayerData(address addr) public view
349     returns (uint256 crystals, uint256 lastupdate, uint256 hashratePerDay, uint256[8] miners, uint256 hasBoost, uint256 referral_count, uint256 playerBalance, uint256 noQuest )
350     {
351         PlayerData storage p = players[addr];
352         if(p.roundNumber != roundNumber){
353             p = players[0];
354         }
355         crystals   = SafeMath.div(p.crystals, CRTSTAL_MINING_PERIOD);
356         lastupdate = p.lastUpdateTime;
357         hashratePerDay = addReferralHashrate(addr, p.hashrate);
358         uint256 i = 0;
359         for(i = 0; i < numberOfMiners; i++)
360         {
361             miners[i] = p.minerCount[i];
362         }
363         hasBoost = hasBooster(addr);
364         referral_count = p.referral_count;
365         noQuest        = p.noQuest; 
366 		playerBalance = payments[addr];
367     }
368     function getHashratePerDay(address minerAddr) public view returns (uint256 personalProduction)
369     {
370         PlayerData storage p = players[minerAddr];   
371         personalProduction = addReferralHashrate(minerAddr, p.hashrate);
372         uint256 boosterIdx = hasBooster(minerAddr);
373         if (boosterIdx != 999) {
374             BoostData storage b = boostData[boosterIdx];
375             personalProduction = SafeMath.div(SafeMath.mul(personalProduction, b.boostRate), 100);
376         }
377     }
378     //--------------------------------------------------------------------------
379     // BOOSTER 
380     //--------------------------------------------------------------------------
381     function buyBooster(uint256 idx) public isNotOver isCurrentRound payable 
382     {
383         require(idx < numberOfBoosts);
384         BoostData storage b = boostData[idx];
385         if(msg.value < getBoosterPrice(idx) || msg.sender == b.owner){
386             revert();
387         }
388         address beneficiary = b.owner;
389 		uint256 devFeePrize = devFee(getBoosterPrice(idx));
390 		asyncSend(sponsor, devFeePrize);
391 		uint256 refundPrize = 0;
392         if(beneficiary != 0){
393 			refundPrize = SafeMath.div(SafeMath.mul(getBoosterPrice(idx), 55), 100);
394 			asyncSend(beneficiary, refundPrize);
395         }
396 		prizePool = SafeMath.add(prizePool, SafeMath.sub(msg.value, SafeMath.add(devFeePrize, refundPrize)));
397         updateCrytal(msg.sender);
398         updateCrytal(beneficiary);
399         uint256 level = getCurrentLevel(b.startingLevel, b.startingTime, b.halfLife);
400         b.startingLevel = SafeMath.add(level, 1);
401         b.startingTime = now;
402         // transfer ownership    
403         b.owner = msg.sender;
404     }
405     function getBoosterData(uint256 idx) public view returns (address owner,uint256 boostRate, uint256 startingLevel, 
406         uint256 startingTime, uint256 currentPrice, uint256 halfLife)
407     {
408         require(idx < numberOfBoosts);
409         owner            = boostData[idx].owner;
410         boostRate        = boostData[idx].boostRate; 
411         startingLevel    = boostData[idx].startingLevel;
412         startingTime     = boostData[idx].startingTime;
413         currentPrice     = getBoosterPrice(idx);
414         halfLife         = boostData[idx].halfLife;
415     }
416     function getBoosterPrice(uint256 index) public view returns (uint256)
417     {
418         BoostData storage booster = boostData[index];
419         return getCurrentPrice(getCurrentLevel(booster.startingLevel, booster.startingTime, booster.halfLife));
420     }
421     function hasBooster(address addr) public view returns (uint256 boostIdx)
422     {         
423         boostIdx = 999;
424         for(uint256 i = 0; i < numberOfBoosts; i++){
425             uint256 revert_i = numberOfBoosts - i - 1;
426             if(boostData[revert_i].owner == addr){
427                 boostIdx = revert_i;
428                 break;
429             }
430         }
431     }
432     //--------------------------------------------------------------------------
433     // Market 
434     //--------------------------------------------------------------------------
435     function buyCrystalDemand(uint256 amount, uint256 unitPrice,string title, string description) public isNotOver isCurrentRound payable 
436     {
437         require(unitPrice >= 100000000000);
438         require(amount >= 1000);
439         require(SafeMath.mul(amount, unitPrice) <= msg.value);
440         uint256 lowestIdx = getLowestUnitPriceIdxFromBuy();
441         BuyOrderData storage o = buyOrderData[lowestIdx];
442         if(o.amount > 10 && unitPrice <= o.unitPrice){
443             revert();
444         }
445         uint256 balance = SafeMath.mul(o.amount, o.unitPrice);
446         if (o.owner != 0){
447 			asyncSend(o.owner, balance);
448         }
449         o.owner = msg.sender;
450         o.unitPrice = unitPrice;
451         o.title = title;
452         o.description = description;
453         o.amount = amount;
454     }
455     function sellCrystal(uint256 amount, uint256 index) public isNotOver isCurrentRound limitSell
456     {
457         require(index < numberOfOrders);
458         require(amount > 0);
459         BuyOrderData storage o = buyOrderData[index];
460 		require(o.owner != msg.sender);
461         require(amount <= o.amount);
462         updateCrytal(msg.sender);
463         PlayerData storage seller = players[msg.sender];
464         PlayerData storage buyer = players[o.owner];
465         require(seller.crystals >= SafeMath.mul(amount, CRTSTAL_MINING_PERIOD));
466         uint256 price = SafeMath.mul(amount, o.unitPrice);
467         uint256 fee = devFee(price);
468 		asyncSend(sponsor, fee);
469 		asyncSend(administrator, fee);
470 		prizePool = SafeMath.add(prizePool, SafeMath.div(SafeMath.mul(price, 40), 100));
471         buyer.crystals = SafeMath.add(buyer.crystals, SafeMath.mul(amount, CRTSTAL_MINING_PERIOD));
472         seller.crystals = SafeMath.sub(seller.crystals, SafeMath.mul(amount, CRTSTAL_MINING_PERIOD));
473         o.amount = SafeMath.sub(o.amount, amount);
474 		asyncSend(msg.sender, SafeMath.div(price, 2));
475     }
476     function withdrawBuyDemand(uint256 index) public isNotOver isCurrentRound
477     {
478         require(index < numberOfOrders);
479         BuyOrderData storage o = buyOrderData[index];
480         require(o.owner == msg.sender);
481         if(o.amount > 0){
482             uint256 balance = SafeMath.mul(o.amount, o.unitPrice);
483 			asyncSend(o.owner, balance);
484         }
485         o.unitPrice = 0;
486         o.amount = 0;  
487         o.title = "title";
488         o.description = "description";
489         o.owner = 0;
490     }
491     function getBuyDemand(uint256 index) public view returns(address owner, string title, string description,
492      uint256 amount, uint256 unitPrice)
493     {
494         require(index < numberOfOrders);
495         BuyOrderData storage o = buyOrderData[index];
496         owner = o.owner;
497         title = o.title;
498         description = o.description;
499         amount = o.amount;
500         unitPrice = o.unitPrice;
501     }
502     function getLowestUnitPriceIdxFromBuy() public view returns(uint256 lowestIdx)
503     {
504         uint256 lowestPrice = 2**256 - 1;
505         for (uint256 idx = 0; idx < numberOfOrders; idx++) {
506             BuyOrderData storage o = buyOrderData[idx];
507             //if empty
508             if (o.unitPrice == 0 || o.amount < 10) {
509                 return idx;
510             }else if (o.unitPrice < lowestPrice) {
511                 lowestPrice = o.unitPrice;
512                 lowestIdx = idx;
513             }
514         }
515     }
516     //-------------------------Sell-----------------------------
517     function sellCrystalDemand(uint256 amount, uint256 unitPrice, string title, string description) 
518     public isNotOver isCurrentRound limitSell
519     {
520         require(amount >= 1000);
521         updateCrytal(msg.sender);
522         PlayerData storage seller = players[msg.sender];
523         if(seller.crystals < SafeMath.mul(amount, CRTSTAL_MINING_PERIOD)){
524             revert();
525         }
526         uint256 highestIdx = getHighestUnitPriceIdxFromSell();
527         SellOrderData storage o = sellOrderData[highestIdx];
528         if(o.amount > 10 && unitPrice >= o.unitPrice){
529             revert();
530         }
531         if (o.owner != 0){
532             PlayerData storage prev = players[o.owner];
533             prev.crystals = SafeMath.add(prev.crystals, SafeMath.mul(o.amount, CRTSTAL_MINING_PERIOD));
534         }
535         o.owner = msg.sender;
536         o.unitPrice = unitPrice;
537         o.title = title;
538         o.description = description;
539         o.amount = amount;
540         //sub crystals
541         seller.crystals = SafeMath.sub(seller.crystals, SafeMath.mul(amount, CRTSTAL_MINING_PERIOD));
542     }
543     function buyCrystal(uint256 amount, uint256 index) public isNotOver isCurrentRound payable
544     {
545         require(index < numberOfOrders);
546         require(amount > 0);
547         SellOrderData storage o = sellOrderData[index];
548 		require(o.owner != msg.sender);
549         require(amount <= o.amount);
550 		uint256 price = SafeMath.mul(amount, o.unitPrice);
551         require(msg.value >= price);
552         PlayerData storage buyer = players[msg.sender];        
553         uint256 fee = devFee(price);
554 		asyncSend(sponsor, fee);
555 		asyncSend(administrator, fee);
556 		prizePool = SafeMath.add(prizePool, SafeMath.div(SafeMath.mul(price, 40), 100));
557         buyer.crystals = SafeMath.add(buyer.crystals, SafeMath.mul(amount, CRTSTAL_MINING_PERIOD));
558         o.amount = SafeMath.sub(o.amount, amount);
559 		asyncSend(o.owner, SafeMath.div(price, 2));
560     }
561     function withdrawSellDemand(uint256 index) public isNotOver isCurrentRound
562     {
563         require(index < numberOfOrders);
564         SellOrderData storage o = sellOrderData[index];
565         require(o.owner == msg.sender);
566         if(o.amount > 0){
567             PlayerData storage p = players[o.owner];
568             p.crystals = SafeMath.add(p.crystals, SafeMath.mul(o.amount, CRTSTAL_MINING_PERIOD));
569         }
570         o.unitPrice = 0;
571         o.amount = 0; 
572         o.title = "title";
573         o.description = "description";
574         o.owner = 0;
575     }
576     function getSellDemand(uint256 index) public view returns(address owner, string title, string description,
577      uint256 amount, uint256 unitPrice)
578     {
579         require(index < numberOfOrders);
580         SellOrderData storage o = sellOrderData[index];
581         owner = o.owner;
582         title = o.title;
583         description = o.description;
584         amount = o.amount;
585         unitPrice = o.unitPrice;
586     }
587     function getHighestUnitPriceIdxFromSell() public view returns(uint256 highestIdx)
588     {
589         uint256 highestPrice = 0;
590         for (uint256 idx = 0; idx < numberOfOrders; idx++) {
591             SellOrderData storage o = sellOrderData[idx];
592             //if empty
593             if (o.unitPrice == 0 || o.amount < 10) {
594                 return idx;
595             }else if (o.unitPrice > highestPrice) {
596                 highestPrice = o.unitPrice;
597                 highestIdx = idx;
598             }
599         }
600     }
601     //--------------------------------------------------------------------------
602     // Other 
603     //--------------------------------------------------------------------------
604     function devFee(uint256 amount) public pure returns(uint256)
605     {
606         return SafeMath.div(SafeMath.mul(amount, 5), 100);
607     }
608     function getBalance() public view returns(uint256)
609     {
610         return address(this).balance;
611     }
612 	//@dev use this function in case of bug
613     function upgrade(address addr) public 
614     {
615         require(msg.sender == administrator);
616         selfdestruct(addr);
617     }
618 
619     //--------------------------------------------------------------------------
620     // Private 
621     //--------------------------------------------------------------------------
622     function updateHashrate(address addr) private
623     {
624         PlayerData storage p = players[addr];
625         uint256 hashrate = 0;
626         for (uint idx = 0; idx < numberOfMiners; idx++) {
627             MinerData storage m = minerData[idx];
628             hashrate = SafeMath.add(hashrate, SafeMath.mul(p.minerCount[idx], m.baseProduct));
629         }
630         p.hashrate = hashrate;
631         if(hashrate > RANK_LIST_LIMIT){
632             updateRankList(addr);
633         }
634     }
635     function updateCrytal(address addr) private
636     {
637         require(now > players[addr].lastUpdateTime);
638         if (players[addr].lastUpdateTime != 0) {
639             PlayerData storage p = players[addr];
640             uint256 secondsPassed = SafeMath.sub(now, p.lastUpdateTime);
641             uint256 revenue = getHashratePerDay(addr);
642             p.lastUpdateTime = now;
643             if (revenue > 0) {
644                 revenue = SafeMath.mul(revenue, secondsPassed);
645                 p.crystals = SafeMath.add(p.crystals, revenue);
646             }
647         }
648     }
649     function addReferralHashrate(address addr, uint256 hashrate) private view returns(uint256 personalProduction) 
650     {
651         PlayerData storage p = players[addr];
652         if(p.referral_count < 5){
653             personalProduction = SafeMath.add(hashrate, SafeMath.mul(p.referral_count, 10));
654         }else if(p.referral_count < 10){
655             personalProduction = SafeMath.add(hashrate, SafeMath.add(50, SafeMath.mul(p.referral_count, 10)));
656         }else{
657             personalProduction = SafeMath.add(hashrate, 200);
658         }
659     }
660     function getCurrentLevel(uint256 startingLevel, uint256 startingTime, uint256 halfLife) private view returns(uint256) 
661     {
662         uint256 timePassed=SafeMath.sub(now, startingTime);
663         uint256 levelsPassed=SafeMath.div(timePassed, halfLife);
664         if (startingLevel < levelsPassed) {
665             return 0;
666         }
667         return SafeMath.sub(startingLevel, levelsPassed);
668     }
669     function getCurrentPrice(uint256 currentLevel) private view returns(uint256) 
670     {
671         return SafeMath.mul(BASE_PRICE, 2**currentLevel);
672     }
673     function updateRankList(address addr) private returns(bool)
674     {
675         uint256 idx = 0;
676         PlayerData storage insert = players[addr];
677         PlayerData storage lastOne = players[rankList[19]];
678         if(insert.hashrate < lastOne.hashrate) {
679             return false;
680         }
681         address[21] memory tempList = rankList;
682         if(!inRankList(addr)){
683             tempList[20] = addr;
684             quickSort(tempList, 0, 20);
685         }else{
686             quickSort(tempList, 0, 19);
687         }
688         for(idx = 0;idx < 21; idx++){
689             if(tempList[idx] != rankList[idx]){
690                 rankList[idx] = tempList[idx];
691             }
692         }
693         
694         return true;
695     }
696     function inRankList(address addr) internal view returns(bool)
697     {
698         for(uint256 idx = 0;idx < 20; idx++){
699             if(addr == rankList[idx]){
700                 return true;
701             }
702         }
703         return false;
704     }
705 	function getRandomNumber(address playerAddress) internal returns(uint256 randomNumber) {
706         randNonce++;
707         randomNumber = uint256(keccak256(now, playerAddress, randNonce)) % 3;
708     }
709     function quickSort(address[21] list, int left, int right) internal
710     {
711         int i = left;
712         int j = right;
713         if(i == j) return;
714         address addr = list[uint(left + (right - left) / 2)];
715         PlayerData storage p = players[addr];
716         while (i <= j) {
717             while (players[list[uint(i)]].hashrate > p.hashrate) i++;
718             while (p.hashrate > players[list[uint(j)]].hashrate) j--;
719             if (i <= j) {
720                 (list[uint(i)], list[uint(j)]) = (list[uint(j)], list[uint(i)]);
721                 i++;
722                 j--;
723             }
724         }
725         if (left < j)
726             quickSort(list, left, j);
727         if (i < right)
728             quickSort(list, i, right);
729     }
730 }