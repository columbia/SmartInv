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
49 //--------------------------------------------------------------------------
50 // EtherMinewar
51 // copyright by mark_hu 
52 // http://www.etherminewar.com/
53 //--------------------------------------------------------------------------
54 contract Minewar {
55     bool public initialized = false;
56     uint256 public roundNumber = 0;
57     uint256 public deadline;
58     uint256 public CRTSTAL_MINING_PERIOD = 86400; 
59     uint256 public HALF_TIME = 8 hours;
60     uint256 public ROUND_TIME = 86400 * 7;
61     uint256 BASE_PRICE = 0.005 ether;
62     uint256 RANK_LIST_LIMIT = 10000;
63     uint256 MINIMUM_LIMIT_SELL = 5000000;
64     //miner info
65     mapping(uint256 => MinerData) private minerData;
66     uint256 private numberOfMiners;
67     // plyer info
68     mapping(address => PlyerData) private players;
69     //booster info
70     uint256 private numberOfBoosts;
71     mapping(uint256 => BoostData) private boostData;
72     //order info
73     uint256 private numberOfOrders;
74     mapping(uint256 => BuyOrderData) private buyOrderData;
75     mapping(uint256 => SellOrderData) private sellOrderData;
76     uint256 private numberOfRank;
77     address[21] rankList;
78     address public sponsor;
79     uint256 public sponsorLevel;
80     address public administrator;
81     /*** DATATYPES ***/
82     struct PlyerData {
83         uint256 roundNumber;
84         mapping(uint256 => uint256) minerCount;
85         uint256 hashrate;
86         uint256 crystals;
87         uint256 lastUpdateTime;
88         uint256 referral_count;
89     }
90     struct MinerData {
91         uint256 basePrice;
92         uint256 baseProduct;
93         uint256 limit;
94     }
95     struct BoostData {
96         address owner;
97         uint256 boostRate;
98         uint256 startingLevel;
99         uint256 startingTime;
100         uint256 halfLife;
101     }
102     struct BuyOrderData {
103         address owner;
104         string title;
105         string description;
106         uint256 unitPrice;
107         uint256 amount;
108     }
109     struct SellOrderData {
110         address owner;
111         string title;
112         string description;
113         uint256 unitPrice;
114         uint256 amount;
115     }
116     modifier isNotOver() 
117     {
118         require(now <= deadline);
119         require(tx.origin == msg.sender);
120         _;
121     }
122     modifier isCurrentRound() 
123     {
124         require(players[msg.sender].roundNumber == roundNumber);
125         _;
126     }
127     modifier limitSell() 
128     {
129         PlyerData storage p = players[msg.sender];
130         if(p.hashrate <= MINIMUM_LIMIT_SELL){
131             _;
132         }else{
133             uint256 limit_hashrate = 0;
134             if(rankList[9] != 0){
135                 PlyerData storage rank_player = players[rankList[9]];
136                 limit_hashrate = SafeMath.mul(rank_player.hashrate, 5);
137             }
138             require(p.hashrate <= limit_hashrate);
139             _;
140         }
141     }
142     function Minewar() public
143     {
144         administrator = msg.sender;
145         numberOfMiners = 8;
146         numberOfBoosts = 5;
147         numberOfOrders = 5;
148         numberOfRank = 21;
149         //init miner data
150         //                      price,          prod.     limit
151         minerData[0] = MinerData(10,            10,         10);   //lv1
152         minerData[1] = MinerData(100,           200,        2);    //lv2
153         minerData[2] = MinerData(400,           800,        4);    //lv3
154         minerData[3] = MinerData(1600,          3200,       8);    //lv4 
155         minerData[4] = MinerData(6400,          9600,       16);   //lv5 
156         minerData[5] = MinerData(25600,         38400,      32);   //lv6 
157         minerData[6] = MinerData(204800,        204800,     64);   //lv7 
158         minerData[7] = MinerData(1638400,       819200,     65536); //lv8
159     }
160     function () public payable
161     {
162 
163     }
164     function startGame() public
165     {
166         require(msg.sender == administrator);
167         require(!initialized);
168         startNewRound();
169         initialized = true;
170     }
171 
172     function startNewRound() private 
173     {
174         deadline = SafeMath.add(now, ROUND_TIME);
175         roundNumber = SafeMath.add(roundNumber, 1);
176         initData();
177     }
178     function initData() private
179     {
180         sponsor = administrator;
181         sponsorLevel = 6;
182         //init booster data
183         boostData[0] = BoostData(0, 150, 1, now, HALF_TIME);
184         boostData[1] = BoostData(0, 175, 1, now, HALF_TIME);
185         boostData[2] = BoostData(0, 200, 1, now, HALF_TIME);
186         boostData[3] = BoostData(0, 225, 1, now, HALF_TIME);
187         boostData[4] = BoostData(msg.sender, 250, 2, now, HALF_TIME);
188         //init order data
189         uint256 idx;
190         for (idx = 0; idx < numberOfOrders; idx++) {
191             buyOrderData[idx] = BuyOrderData(0, "title", "description", 0, 0);
192             sellOrderData[idx] = SellOrderData(0, "title", "description", 0, 0);
193         }
194         for (idx = 0; idx < numberOfRank; idx++) {
195             rankList[idx] = 0;
196         }
197     }
198     function lottery() public 
199     {
200         require(now > deadline);
201         require(tx.origin == msg.sender);
202         uint256 balance = SafeMath.div(SafeMath.mul(this.balance, 90), 100);
203         administrator.send(SafeMath.div(SafeMath.mul(this.balance, 5), 100));
204         uint8[10] memory profit = [30,20,10,8,7,5,5,5,5,5];
205         for(uint256 idx = 0; idx < 10; idx++){
206             if(rankList[idx] != 0){
207                 rankList[idx].send(SafeMath.div(SafeMath.mul(balance,profit[idx]),100));
208             }
209         }
210         startNewRound();
211     }
212     function getRankList() public view returns(address[21])
213     {
214         return rankList;
215     }
216     //sponser
217     function becomeSponsor() public isNotOver isCurrentRound payable
218     {
219         require(msg.value >= getSponsorFee());
220         sponsor.send(getCurrentPrice(sponsorLevel));
221         sponsor = msg.sender;
222         sponsorLevel = SafeMath.add(sponsorLevel, 1);
223     }
224     function getSponsorFee() public view returns(uint256 sponsorFee)
225     {
226         sponsorFee = getCurrentPrice(SafeMath.add(sponsorLevel, 1));
227     }
228     //--------------------------------------------------------------------------
229     // Miner 
230     //--------------------------------------------------------------------------
231     function getFreeMiner(address ref) isNotOver public 
232     {
233         require(players[msg.sender].roundNumber != roundNumber);
234         PlyerData storage p = players[msg.sender];
235         //reset player data
236         if(p.hashrate > 0){
237             for (uint idx = 1; idx < numberOfMiners; idx++) {
238                 p.minerCount[idx] = 0;
239             }
240         }
241         p.crystals = 0;
242         p.roundNumber = roundNumber;
243         //free miner
244         p.lastUpdateTime = now;
245         p.referral_count = 0;
246         p.minerCount[0] = 1;
247         MinerData storage m0 = minerData[0];
248         p.hashrate = m0.baseProduct;
249         //send referral 
250         if (ref != msg.sender) {
251             PlyerData storage referral = players[ref];
252             if(referral.roundNumber == roundNumber){ 
253                 updateCrytal(ref);
254                 p.referral_count = 1;
255                 referral.referral_count = SafeMath.add(referral.referral_count, 1);
256             }
257         }
258     }
259     function buyMiner(uint256[] minerNumbers) public isNotOver isCurrentRound
260     {   
261         require(minerNumbers.length == numberOfMiners);
262         uint256 minerIdx = 0;
263         MinerData memory m;
264         for (; minerIdx < numberOfMiners; minerIdx++) {
265             m = minerData[minerIdx];
266             if(minerNumbers[minerIdx] > m.limit || minerNumbers[minerIdx] < 0){
267                 revert();
268             }
269         }
270         updateCrytal(msg.sender);
271         PlyerData storage p = players[msg.sender];
272         uint256 price = 0;
273         uint256 minerNumber = 0;
274         for (minerIdx = 0; minerIdx < numberOfMiners; minerIdx++) {
275             minerNumber = minerNumbers[minerIdx];
276             if (minerNumber > 0) {
277                 m = minerData[minerIdx];
278                 price = SafeMath.add(price, SafeMath.mul(m.basePrice, minerNumber));
279             }
280         }
281         price = SafeMath.mul(price, CRTSTAL_MINING_PERIOD);
282         if(p.crystals < price){
283             revert();
284         }
285         for (minerIdx = 0; minerIdx < numberOfMiners; minerIdx++) {
286             minerNumber = minerNumbers[minerIdx];
287             if (minerNumber > 0) {
288                 m = minerData[minerIdx];
289                 p.minerCount[minerIdx] = SafeMath.min(m.limit, SafeMath.add(p.minerCount[minerIdx], minerNumber));
290             }
291         }
292         p.crystals = SafeMath.sub(p.crystals, price);
293         updateHashrate(msg.sender);
294     }
295     function getPlayerData(address addr) public view
296     returns (uint256 crystals, uint256 lastupdate, uint256 hashratePerDay, uint256[8] miners, uint256 hasBoost, uint256 referral_count)
297     {
298         PlyerData storage p = players[addr];
299         if(p.roundNumber != roundNumber){
300             p = players[0];
301         }
302         crystals = SafeMath.div(p.crystals, CRTSTAL_MINING_PERIOD);
303         lastupdate = p.lastUpdateTime;
304         hashratePerDay = addReferralHashrate(addr, p.hashrate);
305         uint256 i = 0;
306         for(i = 0; i < numberOfMiners; i++)
307         {
308             miners[i] = p.minerCount[i];
309         }
310         hasBoost = hasBooster(addr);
311         referral_count = p.referral_count;
312     }
313     function getHashratePerDay(address minerAddr) public view returns (uint256 personalProduction)
314     {
315         PlyerData storage p = players[minerAddr];   
316         personalProduction = addReferralHashrate(minerAddr, p.hashrate);
317         uint256 boosterIdx = hasBooster(minerAddr);
318         if (boosterIdx != 999) {
319             BoostData storage b = boostData[boosterIdx];
320             personalProduction = SafeMath.div(SafeMath.mul(personalProduction, b.boostRate), 100);
321         }
322     }
323     //--------------------------------------------------------------------------
324     // BOOSTER 
325     //--------------------------------------------------------------------------
326     function buyBooster(uint256 idx) public isNotOver isCurrentRound payable 
327     {
328         require(idx < numberOfBoosts);
329         BoostData storage b = boostData[idx];
330         if(msg.value < getBoosterPrice(idx) || msg.sender == b.owner){
331             revert();
332         }
333         address beneficiary = b.owner;
334         sponsor.send(devFee(getBoosterPrice(idx)));
335         if(beneficiary != 0){
336             beneficiary.send(SafeMath.div(SafeMath.mul(getBoosterPrice(idx), 55), 100));
337         }
338         updateCrytal(msg.sender);
339         updateCrytal(beneficiary);
340         uint256 level = getCurrentLevel(b.startingLevel, b.startingTime, b.halfLife);
341         b.startingLevel = SafeMath.add(level, 1);
342         b.startingTime = now;
343         // transfer ownership    
344         b.owner = msg.sender;
345     }
346     function getBoosterData(uint256 idx) public view returns (address owner,uint256 boostRate, uint256 startingLevel, 
347         uint256 startingTime, uint256 currentPrice, uint256 halfLife)
348     {
349         require(idx < numberOfBoosts);
350         owner            = boostData[idx].owner;
351         boostRate        = boostData[idx].boostRate; 
352         startingLevel    = boostData[idx].startingLevel;
353         startingTime     = boostData[idx].startingTime;
354         currentPrice     = getBoosterPrice(idx);
355         halfLife         = boostData[idx].halfLife;
356     }
357     function getBoosterPrice(uint256 index) public view returns (uint256)
358     {
359         BoostData storage booster = boostData[index];
360         return getCurrentPrice(getCurrentLevel(booster.startingLevel, booster.startingTime, booster.halfLife));
361     }
362     function hasBooster(address addr) public view returns (uint256 boostIdx)
363     {         
364         boostIdx = 999;
365         for(uint256 i = 0; i < numberOfBoosts; i++){
366             uint256 revert_i = numberOfBoosts - i - 1;
367             if(boostData[revert_i].owner == addr){
368                 boostIdx = revert_i;
369                 break;
370             }
371         }
372     }
373     //--------------------------------------------------------------------------
374     // Market 
375     //--------------------------------------------------------------------------
376     function buyCrystalDemand(uint256 amount, uint256 unitPrice,string title, string description) public isNotOver isCurrentRound payable 
377     {
378         require(unitPrice > 0);
379         require(amount >= 1000);
380         require(amount * unitPrice <= msg.value);
381         uint256 lowestIdx = getLowestUnitPriceIdxFromBuy();
382         BuyOrderData storage o = buyOrderData[lowestIdx];
383         if(o.amount > 10 && unitPrice <= o.unitPrice){
384             revert();
385         }
386         uint256 balance = SafeMath.mul(o.amount, o.unitPrice);
387         if (o.owner != 0){
388             o.owner.send(balance);
389         }
390         o.owner = msg.sender;
391         o.unitPrice = unitPrice;
392         o.title = title;
393         o.description = description;
394         o.amount = amount;
395     }
396     function sellCrystal(uint256 amount, uint256 index) public isNotOver isCurrentRound limitSell
397     {
398         require(index < numberOfOrders);
399         require(amount > 0);
400         BuyOrderData storage o = buyOrderData[index];
401         require(amount <= o.amount);
402         updateCrytal(msg.sender);
403         PlyerData storage seller = players[msg.sender];
404         PlyerData storage buyer = players[o.owner];
405         require(seller.crystals >= amount * CRTSTAL_MINING_PERIOD);
406         uint256 price = SafeMath.mul(amount, o.unitPrice);
407         uint256 fee = devFee(price);
408         sponsor.send(fee);
409         administrator.send(fee);
410         buyer.crystals = SafeMath.add(buyer.crystals, amount * CRTSTAL_MINING_PERIOD);
411         seller.crystals = SafeMath.sub(seller.crystals, amount * CRTSTAL_MINING_PERIOD);
412         o.amount = SafeMath.sub(o.amount, amount);
413         msg.sender.send(SafeMath.div(price, 2));
414     }
415     function withdrawBuyDemand(uint256 index) public isNotOver isCurrentRound
416     {
417         require(index < numberOfOrders);
418         BuyOrderData storage o = buyOrderData[index];
419         require(o.owner == msg.sender);
420         if(o.amount > 0){
421             uint256 balance = SafeMath.mul(o.amount, o.unitPrice);
422             o.owner.send(balance);
423         }
424         o.unitPrice = 0;
425         o.amount = 0;  
426         o.title = "title";
427         o.description = "description";
428         o.owner = 0;
429     }
430     function getBuyDemand(uint256 index) public view returns(address owner, string title, string description,
431      uint256 amount, uint256 unitPrice)
432     {
433         require(index < numberOfOrders);
434         BuyOrderData storage o = buyOrderData[index];
435         owner = o.owner;
436         title = o.title;
437         description = o.description;
438         amount = o.amount;
439         unitPrice = o.unitPrice;
440     }
441     function getLowestUnitPriceIdxFromBuy() public returns(uint256 lowestIdx)
442     {
443         uint256 lowestPrice = 2**256 - 1;
444         for (uint256 idx = 0; idx < numberOfOrders; idx++) {
445             BuyOrderData storage o = buyOrderData[idx];
446             //if empty
447             if (o.unitPrice == 0 || o.amount < 10) {
448                 return idx;
449             }else if (o.unitPrice < lowestPrice) {
450                 lowestPrice = o.unitPrice;
451                 lowestIdx = idx;
452             }
453         }
454     }
455     //-------------------------Sell-----------------------------
456     function sellCrystalDemand(uint256 amount, uint256 unitPrice, string title, string description) 
457     public isNotOver isCurrentRound limitSell
458     {
459         require(amount >= 1000);
460         require(unitPrice > 0);
461         updateCrytal(msg.sender);
462         PlyerData storage seller = players[msg.sender];
463         if(seller.crystals < amount * CRTSTAL_MINING_PERIOD){
464             revert();
465         }
466         uint256 highestIdx = getHighestUnitPriceIdxFromSell();
467         SellOrderData storage o = sellOrderData[highestIdx];
468         if(o.amount > 10 && unitPrice >= o.unitPrice){
469             revert();
470         }
471         if (o.owner != 0){
472             PlyerData storage prev = players[o.owner];
473             prev.crystals = SafeMath.add(prev.crystals, o.amount * CRTSTAL_MINING_PERIOD);
474         }
475         o.owner = msg.sender;
476         o.unitPrice = unitPrice;
477         o.title = title;
478         o.description = description;
479         o.amount = amount;
480         //sub crystals
481         seller.crystals = SafeMath.sub(seller.crystals, amount * CRTSTAL_MINING_PERIOD);
482     }
483     function buyCrystal(uint256 amount, uint256 index) public isNotOver isCurrentRound payable
484     {
485         require(index < numberOfOrders);
486         require(amount > 0);
487         SellOrderData storage o = sellOrderData[index];
488         require(amount <= o.amount);
489         require(msg.value >= amount * o.unitPrice);
490         PlyerData storage buyer = players[msg.sender];
491         uint256 price = SafeMath.mul(amount, o.unitPrice);
492         uint256 fee = devFee(price);
493         sponsor.send(fee);
494         administrator.transfer(fee);
495         buyer.crystals = SafeMath.add(buyer.crystals, amount * CRTSTAL_MINING_PERIOD);
496         o.amount = SafeMath.sub(o.amount, amount);
497         o.owner.send(SafeMath.div(price, 2));
498     }
499     function withdrawSellDemand(uint256 index) public isNotOver isCurrentRound
500     {
501         require(index < numberOfOrders);
502         SellOrderData storage o = sellOrderData[index];
503         require(o.owner == msg.sender);
504         if(o.amount > 0){
505             PlyerData storage p = players[o.owner];
506             p.crystals = SafeMath.add(p.crystals, o.amount * CRTSTAL_MINING_PERIOD);
507         }
508         o.unitPrice = 0;
509         o.amount = 0; 
510         o.title = "title";
511         o.description = "description";
512         o.owner = 0;
513     }
514     function getSellDemand(uint256 index) public view returns(address owner, string title, string description,
515      uint256 amount, uint256 unitPrice)
516     {
517         require(index < numberOfOrders);
518         SellOrderData storage o = sellOrderData[index];
519         owner = o.owner;
520         title = o.title;
521         description = o.description;
522         amount = o.amount;
523         unitPrice = o.unitPrice;
524     }
525     function getHighestUnitPriceIdxFromSell() public returns(uint256 highestIdx)
526     {
527         uint256 highestPrice = 0;
528         for (uint256 idx = 0; idx < numberOfOrders; idx++) {
529             SellOrderData storage o = sellOrderData[idx];
530             //if empty
531             if (o.unitPrice == 0 || o.amount < 10) {
532                 return idx;
533             }else if (o.unitPrice > highestPrice) {
534                 highestPrice = o.unitPrice;
535                 highestIdx = idx;
536             }
537         }
538     }
539     //--------------------------------------------------------------------------
540     // Other 
541     //--------------------------------------------------------------------------
542     function devFee(uint256 amount) public view returns(uint256)
543     {
544         return SafeMath.div(SafeMath.mul(amount, 5), 100);
545     }
546     function getBalance() public view returns(uint256)
547     {
548         return this.balance;
549     }
550     function upgrade(address addr) public 
551     {
552         require(msg.sender == administrator);
553         require(now < deadline - 82800);
554         uint256 balance = SafeMath.div(SafeMath.mul(this.balance, 90), 100);
555         administrator.send(SafeMath.div(SafeMath.mul(this.balance, 5), 100));
556         uint8[10] memory profit = [30,20,10,8,7,5,5,5,5,5];
557         for(uint256 idx = 0; idx < 10; idx++){
558             if(rankList[idx] != 0){
559                 rankList[idx].send(SafeMath.div(SafeMath.mul(balance,profit[idx]),100));
560             }
561         }
562         selfdestruct(addr);
563     }
564 
565     //--------------------------------------------------------------------------
566     // Private 
567     //--------------------------------------------------------------------------
568     function updateHashrate(address addr) private
569     {
570         PlyerData storage p = players[addr];
571         uint256 hashrate = 0;
572         for (uint idx = 0; idx < numberOfMiners; idx++) {
573             MinerData storage m = minerData[idx];
574             hashrate = SafeMath.add(hashrate, SafeMath.mul(p.minerCount[idx], m.baseProduct));
575         }
576         p.hashrate = hashrate;
577         if(hashrate > RANK_LIST_LIMIT){
578             updateRankList(addr);
579         }
580     }
581     function updateCrytal(address addr) private
582     {
583         require(now > players[addr].lastUpdateTime);
584         if (players[addr].lastUpdateTime != 0) {
585             PlyerData storage p = players[addr];
586             uint256 secondsPassed = SafeMath.sub(now, p.lastUpdateTime);
587             uint256 revenue = getHashratePerDay(addr);
588             p.lastUpdateTime = now;
589             if (revenue > 0) {
590                 revenue = SafeMath.mul(revenue, secondsPassed);
591                 p.crystals = SafeMath.add(p.crystals, revenue);
592             }
593         }
594     }
595     function addReferralHashrate(address addr, uint256 hashrate) private view returns(uint256 personalProduction) 
596     {
597         PlyerData storage p = players[addr];
598         if(p.referral_count < 5){
599             personalProduction = SafeMath.add(hashrate, p.referral_count * 10);
600         }else if(p.referral_count < 10){
601             personalProduction = SafeMath.add(hashrate, 50 + p.referral_count * 10);
602         }else{
603             personalProduction = SafeMath.add(hashrate, 200);
604         }
605     }
606     function getCurrentLevel(uint256 startingLevel, uint256 startingTime, uint256 halfLife) private view returns(uint256) 
607     {
608         uint256 timePassed=SafeMath.sub(now, startingTime);
609         uint256 levelsPassed=SafeMath.div(timePassed, halfLife);
610         if (startingLevel < levelsPassed) {
611             return 0;
612         }
613         return SafeMath.sub(startingLevel, levelsPassed);
614     }
615     function getCurrentPrice(uint256 currentLevel) private view returns(uint256) 
616     {
617         return SafeMath.mul(BASE_PRICE, 2**currentLevel);
618     }
619     function updateRankList(address addr) private returns(bool)
620     {
621         uint256 idx = 0;
622         PlyerData storage insert = players[addr];
623         PlyerData storage lastOne = players[rankList[19]];
624         if(insert.hashrate < lastOne.hashrate) {
625             return false;
626         }
627         address[21] memory tempList = rankList;
628         if(!inRankList(addr)){
629             tempList[20] = addr;
630             quickSort(tempList, 0, 20);
631         }else{
632             quickSort(tempList, 0, 19);
633         }
634         for(idx = 0;idx < 21; idx++){
635             if(tempList[idx] != rankList[idx]){
636                 rankList[idx] = tempList[idx];
637             }
638         }
639         
640         return true;
641     }
642     function inRankList(address addr) internal returns(bool)
643     {
644         for(uint256 idx = 0;idx < 20; idx++){
645             if(addr == rankList[idx]){
646                 return true;
647             }
648         }
649         return false;
650     }
651     function quickSort(address[21] list, int left, int right) internal
652     {
653         int i = left;
654         int j = right;
655         if(i == j) return;
656         address addr = list[uint(left + (right - left) / 2)];
657         PlyerData storage p = players[addr];
658         while (i <= j) {
659             while (players[list[uint(i)]].hashrate > p.hashrate) i++;
660             while (p.hashrate > players[list[uint(j)]].hashrate) j--;
661             if (i <= j) {
662                 (list[uint(i)], list[uint(j)]) = (list[uint(j)], list[uint(i)]);
663                 i++;
664                 j--;
665             }
666         }
667         if (left < j)
668             quickSort(list, left, j);
669         if (i < right)
670             quickSort(list, i, right);
671     }
672 }