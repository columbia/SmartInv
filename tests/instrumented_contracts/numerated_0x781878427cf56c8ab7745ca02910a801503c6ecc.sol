1 pragma solidity ^0.4.2;
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
49 contract Minewar {
50     bool public initialized = false;
51     uint256 round = 0;
52     uint256 public deadline;
53     uint256 public CRTSTAL_MINING_PERIOD = 86400; 
54     uint256 public SHARE_CRYSTAL = 10 * CRTSTAL_MINING_PERIOD;
55     uint256 public HALF_TIME = 8 hours;
56     uint256 public ROUND_TIME = 86400 * 7;
57     uint256 BASE_PRICE = 0.005 ether;
58     uint256 RANK_LIST_LIMIT = 10000;
59     uint256 MINIMUM_LIMIT_SELL = 5000000;
60     //miner info
61     mapping(uint256 => MinerData) private minerData;
62     uint256 private numberOfMiners;
63     // plyer info
64     mapping(address => PlyerData) private players;
65     //booster info
66     uint256 private numberOfBoosts;
67     mapping(uint256 => BoostData) private boostData;
68     //order info
69     uint256 private numberOfOrders;
70     mapping(uint256 => BuyOrderData) private buyOrderData;
71     mapping(uint256 => SellOrderData) private sellOrderData;
72     uint256 private numberOfRank;
73     address[21] rankList;
74     address public sponsor;
75     uint256 public sponsorLevel;
76     address public administrator;
77     /*** DATATYPES ***/
78     struct PlyerData {
79         uint256 round;
80         mapping(uint256 => uint256) minerCount;
81         uint256 hashrate;
82         uint256 crystals;
83         uint256 lastUpdateTime;
84     }
85     struct MinerData {
86         uint256 basePrice;
87         uint256 baseProduct;
88         uint256 limit;
89     }
90     struct BoostData {
91         address owner;
92         uint256 boostRate;
93         uint256 startingLevel;
94         uint256 startingTime;
95         uint256 halfLife;
96     }
97     struct BuyOrderData {
98         address owner;
99         string title;
100         string description;
101         uint256 unitPrice;
102         uint256 amount;
103     }
104     struct SellOrderData {
105         address owner;
106         string title;
107         string description;
108         uint256 unitPrice;
109         uint256 amount;
110     }
111     modifier isNotOver() 
112     {
113         require(now <= deadline);
114         _;
115     }
116     modifier isCurrentRound() 
117     {
118         require(players[msg.sender].round == round);
119         _;
120     }
121     modifier limitSell() 
122     {
123         PlyerData storage p = players[msg.sender];
124         if(p.hashrate <= MINIMUM_LIMIT_SELL){
125             _;
126         }else{
127             uint256 limit_hashrate = 0;
128             if(rankList[9] != 0){
129                 PlyerData storage rank_player = players[rankList[9]];
130                 limit_hashrate = SafeMath.mul(rank_player.hashrate, 5);
131             }
132             require(p.hashrate <= limit_hashrate);
133             _;
134         }
135     }
136     function Minewar() public payable
137     {
138         administrator = msg.sender;
139         numberOfMiners = 8;
140         numberOfBoosts = 5;
141         numberOfOrders = 5;
142         numberOfRank = 21;
143         //init miner data
144         //                      price,          prod.     limit
145         minerData[0] = MinerData(10,            10,         10);   //lv1
146         minerData[1] = MinerData(100,           200,        2);    //lv2
147         minerData[2] = MinerData(400,           800,        4);    //lv3
148         minerData[3] = MinerData(1600,          3200,       8);    //lv4 
149         minerData[4] = MinerData(6400,          9600,       16);   //lv5 
150         minerData[5] = MinerData(25600,         38400,      32);   //lv6 
151         minerData[6] = MinerData(204800,        204800,     64);   //lv7 
152         minerData[7] = MinerData(1638400,       819200,     65536); //lv8
153     }
154 
155     function startGame() public
156     {
157         require(msg.sender == administrator);
158         require(!initialized);
159         startNewRound();
160         initialized = true;
161     }
162 
163     function startNewRound() private 
164     {
165         deadline = SafeMath.add(now, ROUND_TIME);
166         round = SafeMath.add(round, 1);
167         initData();
168     }
169     function initData() private
170     {
171         sponsor = administrator;
172         sponsorLevel = 6;
173         //init booster data
174         boostData[0] = BoostData(0, 150, 1, now, HALF_TIME);
175         boostData[1] = BoostData(0, 175, 1, now, HALF_TIME);
176         boostData[2] = BoostData(0, 200, 1, now, HALF_TIME);
177         boostData[3] = BoostData(0, 225, 1, now, HALF_TIME);
178         boostData[4] = BoostData(msg.sender, 250, 2, now, HALF_TIME);
179         //init order data
180         uint256 idx;
181         for (idx = 0; idx < numberOfOrders; idx++) {
182             buyOrderData[idx] = BuyOrderData(0, "title", "description", 0, 0);
183             sellOrderData[idx] = SellOrderData(0, "title", "description", 0, 0);
184         }
185         for (idx = 0; idx < numberOfRank; idx++) {
186             rankList[idx] = 0;
187         }
188     }
189     function lottery() public 
190     {
191         require(now > deadline);
192         uint256 balance = SafeMath.div(SafeMath.mul(this.balance, 90), 100);
193         administrator.transfer(SafeMath.div(SafeMath.mul(this.balance, 5), 100));
194         uint8[10] memory profit = [30,20,10,8,7,5,5,5,5,5];
195         for(uint256 idx = 0; idx < 10; idx++){
196             if(rankList[idx] != 0){
197                 rankList[idx].transfer(SafeMath.div(SafeMath.mul(balance,profit[idx]),100));
198             }
199         }
200         startNewRound();
201     }
202     function getRankList() public view returns(address[21])
203     {
204         return rankList;
205     }
206     //sponser
207     function becomeSponsor() public isNotOver isCurrentRound payable
208     {
209         require(msg.value >= getSponsorFee());
210         sponsor.transfer(getCurrentPrice(sponsorLevel));
211         sponsor = msg.sender;
212         sponsorLevel = SafeMath.add(sponsorLevel, 1);
213     }
214     function getSponsorFee() public view returns(uint256 sponsorFee)
215     {
216         sponsorFee = getCurrentPrice(SafeMath.add(sponsorLevel, 1));
217     }
218     //--------------------------------------------------------------------------
219     // Miner 
220     //--------------------------------------------------------------------------
221     function getFreeMiner(address ref) isNotOver public 
222     {
223         require(players[msg.sender].round != round);
224         PlyerData storage p = players[msg.sender];
225         //reset player data
226         if(p.hashrate > 0){
227             for (uint idx = 1; idx < numberOfMiners; idx++) {
228                 p.minerCount[idx] = 0;
229             }
230         }
231         p.crystals = 0;
232         p.round = round;
233         //free miner
234         p.lastUpdateTime = now;
235         p.minerCount[0] = 1;
236         MinerData storage m0 = minerData[0];
237         p.hashrate = m0.baseProduct;
238         //send referral 
239         if (ref != msg.sender) {
240             PlyerData storage referral = players[ref];
241             if(referral.round == round){ 
242                 p.crystals = SafeMath.add(p.crystals, SHARE_CRYSTAL);
243                 referral.crystals = SafeMath.add(referral.crystals, SHARE_CRYSTAL);
244             }
245         }
246     }
247     function buyMiner(uint256[] minerNumbers) public isNotOver isCurrentRound
248     {
249         require(minerNumbers.length == numberOfMiners);
250         uint256 minerIdx = 0;
251         MinerData memory m;
252         for (; minerIdx < numberOfMiners; minerIdx++) {
253             m = minerData[minerIdx];
254             if(minerNumbers[minerIdx] > m.limit || minerNumbers[minerIdx] < 0){
255                 revert();
256             }
257         }
258         updateCrytal(msg.sender);
259         PlyerData storage p = players[msg.sender];
260         uint256 price = 0;
261         uint256 minerNumber = 0;
262         for (minerIdx = 0; minerIdx < numberOfMiners; minerIdx++) {
263             minerNumber = minerNumbers[minerIdx];
264             if (minerNumber > 0) {
265                 m = minerData[minerIdx];
266                 price = SafeMath.add(price, SafeMath.mul(m.basePrice, minerNumber));
267             }
268         }
269         price = SafeMath.mul(price, CRTSTAL_MINING_PERIOD);
270         if(p.crystals < price){
271             revert();
272         }
273         for (minerIdx = 0; minerIdx < numberOfMiners; minerIdx++) {
274             minerNumber = minerNumbers[minerIdx];
275             if (minerNumber > 0) {
276                 m = minerData[minerIdx];
277                 p.minerCount[minerIdx] = SafeMath.min(m.limit, SafeMath.add(p.minerCount[minerIdx], minerNumber));
278             }
279         }
280         p.crystals = SafeMath.sub(p.crystals, price);
281         updateHashrate(msg.sender);
282     }
283     function getPlayerData(address addr) public view 
284     returns (uint256 crystals, uint256 lastupdate, uint256 hashratePerDay, uint256[8] miners, uint256 hasBoost)
285     {
286         PlyerData storage p = players[addr];
287         if(p.round != round){
288             p = players[0];
289         }
290         crystals = SafeMath.div(p.crystals, CRTSTAL_MINING_PERIOD);
291         lastupdate = p.lastUpdateTime;
292         hashratePerDay = p.hashrate;
293         uint256 i = 0;
294         for(i = 0; i < numberOfMiners; i++)
295         {
296             miners[i] = p.minerCount[i];
297         }
298         hasBoost = hasBooster(addr);
299     }
300     function getHashratePerDay(address minerAddr) public view returns (uint256 personalProduction)
301     {
302         PlyerData storage p = players[minerAddr];   
303         personalProduction = p.hashrate;
304         uint256 boosterIdx = hasBooster(minerAddr);
305         if (boosterIdx != 999) {
306             BoostData storage b = boostData[boosterIdx];
307             personalProduction = SafeMath.div(SafeMath.mul(personalProduction, b.boostRate), 100);
308         }
309     }
310     //--------------------------------------------------------------------------
311     // BOOSTER 
312     //--------------------------------------------------------------------------
313     function buyBooster(uint256 idx) public isNotOver isCurrentRound payable 
314     {
315         require(idx < numberOfBoosts);
316         BoostData storage b = boostData[idx];
317         if(msg.value < getBoosterPrice(idx) || msg.sender == b.owner){
318             revert();
319         }
320         address beneficiary = b.owner;
321         sponsor.transfer(devFee(getBoosterPrice(idx)));
322         beneficiary.transfer(SafeMath.div(SafeMath.mul(getBoosterPrice(idx), 55), 100));
323         updateCrytal(msg.sender);
324         updateCrytal(beneficiary);
325         uint256 level = getCurrentLevel(b.startingLevel, b.startingTime, b.halfLife);
326         b.startingLevel = SafeMath.add(level, 1);
327         b.startingTime = now;
328         // transfer ownership    
329         b.owner = msg.sender;
330     }
331     function getBoosterData(uint256 idx) public view returns (address owner,uint256 boostRate, uint256 startingLevel, 
332         uint256 startingTime, uint256 currentPrice, uint256 halfLife)
333     {
334         require(idx < numberOfBoosts);
335         owner            = boostData[idx].owner;
336         boostRate        = boostData[idx].boostRate; 
337         startingLevel    = boostData[idx].startingLevel;
338         startingTime     = boostData[idx].startingTime;
339         currentPrice     = getBoosterPrice(idx);
340         halfLife         = boostData[idx].halfLife;
341     }
342     function getBoosterPrice(uint256 index) public view returns (uint256)
343     {
344         BoostData storage booster = boostData[index];
345         return getCurrentPrice(getCurrentLevel(booster.startingLevel, booster.startingTime, booster.halfLife));
346     }
347     function hasBooster(address addr) public view returns (uint256 boostIdx)
348     {         
349         boostIdx = 999;
350         for(uint256 i = 0; i < numberOfBoosts; i++){
351             uint256 revert_i = numberOfBoosts - i - 1;
352             if(boostData[revert_i].owner == addr){
353                 boostIdx = revert_i;
354                 break;
355             }
356         }
357     }
358     //--------------------------------------------------------------------------
359     // Market 
360     //--------------------------------------------------------------------------
361     function buyCrystalDemand(uint256 amount, uint256 unitPrice,string title, string description) public isNotOver isCurrentRound payable 
362     {
363         require(unitPrice > 0);
364         require(amount >= 1000);
365         require(amount * unitPrice <= msg.value);
366         uint256 lowestIdx = getLowestUnitPriceIdxFromBuy();
367         BuyOrderData storage o = buyOrderData[lowestIdx];
368         if(o.amount > 10 && unitPrice <= o.unitPrice){
369             revert();
370         }
371         uint256 balance = SafeMath.mul(o.amount, o.unitPrice);
372         if (o.owner != 0){
373             o.owner.transfer(balance);
374         }
375         o.owner = msg.sender;
376         o.unitPrice = unitPrice;
377         o.title = title;
378         o.description = description;
379         o.amount = amount;
380     }
381     function sellCrystal(uint256 amount, uint256 index) public isNotOver isCurrentRound limitSell
382     {
383         require(index < numberOfOrders);
384         require(amount > 0);
385         BuyOrderData storage o = buyOrderData[index];
386         require(amount <= o.amount);
387         updateCrytal(msg.sender);
388         PlyerData storage seller = players[msg.sender];
389         PlyerData storage buyer = players[o.owner];
390         require(seller.crystals >= amount * CRTSTAL_MINING_PERIOD);
391         uint256 price = SafeMath.mul(amount, o.unitPrice);
392         uint256 fee = devFee(price);
393         sponsor.transfer(fee);
394         administrator.transfer(fee);
395         buyer.crystals = SafeMath.add(buyer.crystals, amount * CRTSTAL_MINING_PERIOD);
396         seller.crystals = SafeMath.sub(seller.crystals, amount * CRTSTAL_MINING_PERIOD);
397         o.amount = SafeMath.sub(o.amount, amount);
398         msg.sender.transfer(SafeMath.div(price, 2));
399     }
400     function withdrawBuyDemand(uint256 index) public isNotOver isCurrentRound
401     {
402         require(index < numberOfOrders);
403         BuyOrderData storage o = buyOrderData[index];
404         require(o.owner == msg.sender);
405         if(o.amount > 0){
406             uint256 balance = SafeMath.mul(o.amount, o.unitPrice);
407             o.owner.transfer(balance);
408         }
409         o.unitPrice = 0;
410         o.amount = 0;  
411         o.title = "title";
412         o.description = "description";
413         o.owner = 0;
414     }
415     function getBuyDemand(uint256 index) public view returns(address owner, string title, string description,
416      uint256 amount, uint256 unitPrice)
417     {
418         require(index < numberOfOrders);
419         BuyOrderData storage o = buyOrderData[index];
420         owner = o.owner;
421         title = o.title;
422         description = o.description;
423         amount = o.amount;
424         unitPrice = o.unitPrice;
425     }
426     function getLowestUnitPriceIdxFromBuy() public returns(uint256 lowestIdx)
427     {
428         uint256 lowestPrice = 2**256 - 1;
429         for (uint256 idx = 0; idx < numberOfOrders; idx++) {
430             BuyOrderData storage o = buyOrderData[idx];
431             //if empty
432             if (o.unitPrice == 0 || o.amount < 10) {
433                 return idx;
434             }else if (o.unitPrice < lowestPrice) {
435                 lowestPrice = o.unitPrice;
436                 lowestIdx = idx;
437             }
438         }
439     }
440     //-------------------------Sell-----------------------------
441     function sellCrystalDemand(uint256 amount, uint256 unitPrice, string title, string description) 
442     public isNotOver isCurrentRound limitSell
443     {
444         require(amount >= 1000);
445         require(unitPrice > 0);
446         updateCrytal(msg.sender);
447         PlyerData storage seller = players[msg.sender];
448         if(seller.crystals < amount * CRTSTAL_MINING_PERIOD){
449             revert();
450         }
451         uint256 highestIdx = getHighestUnitPriceIdxFromSell();
452         SellOrderData storage o = sellOrderData[highestIdx];
453         if(o.amount > 10 && unitPrice >= o.unitPrice){
454             revert();
455         }
456         if (o.owner != 0){
457             PlyerData storage prev = players[o.owner];
458             prev.crystals = SafeMath.add(prev.crystals, o.amount * CRTSTAL_MINING_PERIOD);
459         }
460         o.owner = msg.sender;
461         o.unitPrice = unitPrice;
462         o.title = title;
463         o.description = description;
464         o.amount = amount;
465         //sub crystals
466         seller.crystals = SafeMath.sub(seller.crystals, amount * CRTSTAL_MINING_PERIOD);
467     }
468     function buyCrystal(uint256 amount, uint256 index) public isNotOver isCurrentRound payable
469     {
470         require(index < numberOfOrders);
471         require(amount > 0);
472         SellOrderData storage o = sellOrderData[index];
473         require(amount <= o.amount);
474         require(msg.value >= amount * o.unitPrice);
475         PlyerData storage buyer = players[msg.sender];
476         uint256 price = SafeMath.mul(amount, o.unitPrice);
477         uint256 fee = devFee(price);
478         sponsor.transfer(fee);
479         administrator.transfer(fee);
480         buyer.crystals = SafeMath.add(buyer.crystals, amount * CRTSTAL_MINING_PERIOD);
481         o.amount = SafeMath.sub(o.amount, amount);
482         o.owner.transfer(SafeMath.div(price, 2));
483     }
484     function withdrawSellDemand(uint256 index) public isNotOver isCurrentRound
485     {
486         require(index < numberOfOrders);
487         SellOrderData storage o = sellOrderData[index];
488         require(o.owner == msg.sender);
489         if(o.amount > 0){
490             PlyerData storage p = players[o.owner];
491             p.crystals = SafeMath.add(p.crystals, o.amount * CRTSTAL_MINING_PERIOD);
492         }
493         o.unitPrice = 0;
494         o.amount = 0; 
495         o.title = "title";
496         o.description = "description";
497         o.owner = 0;
498     }
499     function getSellDemand(uint256 index) public view returns(address owner, string title, string description,
500      uint256 amount, uint256 unitPrice)
501     {
502         require(index < numberOfOrders);
503         SellOrderData storage o = sellOrderData[index];
504         owner = o.owner;
505         title = o.title;
506         description = o.description;
507         amount = o.amount;
508         unitPrice = o.unitPrice;
509     }
510     function getHighestUnitPriceIdxFromSell() public returns(uint256 highestIdx)
511     {
512         uint256 highestPrice = 0;
513         for (uint256 idx = 0; idx < numberOfOrders; idx++) {
514             SellOrderData storage o = sellOrderData[idx];
515             //if empty
516             if (o.unitPrice == 0 || o.amount < 10) {
517                 return idx;
518             }else if (o.unitPrice > highestPrice) {
519                 highestPrice = o.unitPrice;
520                 highestIdx = idx;
521             }
522         }
523     }
524     //--------------------------------------------------------------------------
525     // Other 
526     //--------------------------------------------------------------------------
527     function devFee(uint256 amount) public view returns(uint256)
528     {
529         return SafeMath.div(SafeMath.mul(amount, 5), 100);
530     }
531     function getBalance() public view returns(uint256)
532     {
533         return this.balance;
534     }
535     function upgrade(address addr) public 
536     {
537         require(msg.sender == administrator);
538         require(now > deadline);
539         uint256 balance = SafeMath.div(SafeMath.mul(this.balance, 90), 100);
540         administrator.transfer(SafeMath.div(SafeMath.mul(this.balance, 5), 100));
541         uint8[10] memory profit = [30,20,10,8,7,5,5,5,5,5];
542         for(uint256 idx = 0; idx < 10; idx++){
543             if(rankList[idx] != 0){
544                 rankList[idx].transfer(SafeMath.div(SafeMath.mul(balance,profit[idx]),100));
545             }
546         }
547         selfdestruct(addr);
548     }
549 
550     //--------------------------------------------------------------------------
551     // Private 
552     //--------------------------------------------------------------------------
553     function updateHashrate(address addr) private
554     {
555         PlyerData storage p = players[addr];
556         uint256 hashrate = 0;
557         for (uint idx = 0; idx < numberOfMiners; idx++) {
558             MinerData storage m = minerData[idx];
559             hashrate = SafeMath.add(hashrate, SafeMath.mul(p.minerCount[idx], m.baseProduct));
560         }
561         p.hashrate = hashrate;
562         if(hashrate > RANK_LIST_LIMIT){
563             updateRankList(addr);
564         }
565     }
566     function updateCrytal(address addr) private
567     {
568         require(now > players[addr].lastUpdateTime);
569         if (players[addr].lastUpdateTime != 0) {
570             PlyerData storage p = players[addr];
571             uint256 secondsPassed = SafeMath.sub(now, p.lastUpdateTime);
572             uint256 revenue = getHashratePerDay(addr);
573             p.lastUpdateTime = now;
574             if (revenue > 0) {
575                 revenue = SafeMath.mul(revenue, secondsPassed);
576                 p.crystals = SafeMath.add(p.crystals, revenue);
577             }
578         }
579     }
580     function getCurrentLevel(uint256 startingLevel, uint256 startingTime, uint256 halfLife) private view returns(uint256) 
581     {
582         uint256 timePassed=SafeMath.sub(now, startingTime);
583         uint256 levelsPassed=SafeMath.div(timePassed, halfLife);
584         if (startingLevel < levelsPassed) {
585             return 0;
586         }
587         return SafeMath.sub(startingLevel, levelsPassed);
588     }
589     function getCurrentPrice(uint256 currentLevel) private view returns(uint256) 
590     {
591         return SafeMath.mul(BASE_PRICE, 2**currentLevel);
592     }
593     function updateRankList(address addr) private returns(bool)
594     {
595         uint256 idx = 0;
596         PlyerData storage insert = players[addr];
597         PlyerData storage lastOne = players[rankList[19]];
598         if(insert.hashrate < lastOne.hashrate) {
599             return false;
600         }
601         address[21] memory tempList = rankList;
602         if(!inRankList(addr)){
603             tempList[20] = addr;
604             quickSort(tempList, 0, 20);
605         }else{
606             quickSort(tempList, 0, 19);
607         }
608         for(idx = 0;idx < 21; idx++){
609             if(tempList[idx] != rankList[idx]){
610                 rankList[idx] = tempList[idx];
611             }
612         }
613         
614         return true;
615     }
616     function inRankList(address addr) internal returns(bool)
617     {
618         for(uint256 idx = 0;idx < 20; idx++){
619             if(addr == rankList[idx]){
620                 return true;
621             }
622         }
623         return false;
624     }
625     function quickSort(address[21] list, int left, int right) internal
626     {
627         int i = left;
628         int j = right;
629         if(i == j) return;
630         address addr = list[uint(left + (right - left) / 2)];
631         PlyerData storage p = players[addr];
632         while (i <= j) {
633             while (players[list[uint(i)]].hashrate > p.hashrate) i++;
634             while (p.hashrate > players[list[uint(j)]].hashrate) j--;
635             if (i <= j) {
636                 (list[uint(i)], list[uint(j)]) = (list[uint(j)], list[uint(i)]);
637                 i++;
638                 j--;
639             }
640         }
641         if (left < j)
642             quickSort(list, left, j);
643         if (i < right)
644             quickSort(list, i, right);
645     }
646 }