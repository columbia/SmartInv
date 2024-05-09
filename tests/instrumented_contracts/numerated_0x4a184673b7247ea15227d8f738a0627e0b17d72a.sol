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
50     uint256 round = 0;
51     uint256 public deadline;
52     uint256 public CRTSTAL_MINING_PERIOD = 86400; 
53     uint256 public SHARE_CRYSTAL = 10 * CRTSTAL_MINING_PERIOD;
54     uint256 public HALF_TIME = 12 hours;
55     uint256 public ROUND_TIME = 7 days;
56     uint256 BASE_PRICE = 0.005 ether;
57     uint256 RANK_LIST_LIMIT = 1000;
58     //miner info
59     mapping(uint256 => MinerData) private minerData;
60     uint256 private numberOfMiners;
61     // plyer info
62     mapping(address => PlyerData) private players;
63     //booster info
64     uint256 private numberOfBoosts;
65     mapping(uint256 => BoostData) private boostData;
66     //order info
67     uint256 private numberOfOrders;
68     mapping(uint256 => BuyOrderData) private buyOrderData;
69     mapping(uint256 => SellOrderData) private sellOrderData;
70     uint256 private numberOfRank;
71     address[21] rankList;
72     address public sponsor;
73     uint256 public sponsorLevel;
74     address public administrator;
75     /*** DATATYPES ***/
76     struct PlyerData {
77         uint256 round;
78         mapping(uint256 => uint256) minerCount;
79         uint256 hashrate;
80         uint256 crystals;
81         uint256 lastUpdateTime;
82     }
83     struct MinerData {
84         uint256 basePrice;
85         uint256 baseProduct;
86         uint256 limit;
87     }
88     struct BoostData {
89         address owner;
90         uint256 boostRate;
91         uint256 startingLevel;
92         uint256 startingTime;
93         uint256 halfLife;
94     }
95     struct BuyOrderData {
96         address owner;
97         string title;
98         string description;
99         uint256 unitPrice;
100         uint256 amount;
101     }
102     struct SellOrderData {
103         address owner;
104         string title;
105         string description;
106         uint256 unitPrice;
107         uint256 amount;
108     }
109     function Minewar() public
110     {
111         administrator = msg.sender;
112         numberOfMiners = 8;
113         numberOfBoosts = 5;
114         numberOfOrders = 5;
115         numberOfRank = 21;
116         //init miner data
117         //                      price,          prod.     limit
118         minerData[0] = MinerData(10,            10,         10);   //lv1
119         minerData[1] = MinerData(100,           200,        2);    //lv2
120         minerData[2] = MinerData(400,           800,        4);    //lv3
121         minerData[3] = MinerData(1600,          3200,       8);    //lv4 
122         minerData[4] = MinerData(6400,          12800,      16);   //lv5 
123         minerData[5] = MinerData(25600,         51200,      32);   //lv6 
124         minerData[6] = MinerData(204800,        409600,     64);   //lv7 
125         minerData[7] = MinerData(1638400,       1638400,    65536); //lv8
126         startNewRound();
127     }
128     function startNewRound() private 
129     {
130         deadline = SafeMath.add(now, ROUND_TIME);
131         round = SafeMath.add(round, 1);
132         initData();
133     }
134     function initData() private
135     {
136         sponsor = administrator;
137         sponsorLevel = 5;
138         //init booster data
139         boostData[0] = BoostData(0, 150, 1, now, HALF_TIME);
140         boostData[1] = BoostData(0, 175, 1, now, HALF_TIME);
141         boostData[2] = BoostData(0, 200, 1, now, HALF_TIME);
142         boostData[3] = BoostData(0, 225, 1, now, HALF_TIME);
143         boostData[4] = BoostData(msg.sender, 250, 2, now, HALF_TIME);
144         //init order data
145         uint256 idx;
146         for (idx = 0; idx < numberOfOrders; idx++) {
147             buyOrderData[idx] = BuyOrderData(0, "title", "description", 0, 0);
148             sellOrderData[idx] = SellOrderData(0, "title", "description", 0, 0);
149         }
150         for (idx = 0; idx < numberOfRank; idx++) {
151             rankList[idx] = 0;
152         }
153     }
154     function lottery() public 
155     {
156         require(now >= deadline);
157         uint256 balance = SafeMath.div(SafeMath.mul(this.balance, 90), 100);
158         administrator.transfer(SafeMath.div(SafeMath.mul(this.balance, 5), 100));
159         uint8[10] memory profit = [30,20,10,8,7,5,5,5,5,5];
160         for(uint256 idx = 0; idx < 10; idx++){
161             if(rankList[idx] != 0){
162                 rankList[idx].transfer(SafeMath.div(SafeMath.mul(balance,profit[idx]),100));
163             }
164         }
165         startNewRound();
166     }
167     function getRankList() public view returns(address[21])
168     {
169         return rankList;
170     }
171     //sponser
172     function becomeSponsor() public payable
173     {
174         require(now <= deadline);
175         require(msg.value >= getSponsorFee());
176         sponsor.transfer(getCurrentPrice(sponsorLevel));
177         sponsor = msg.sender;
178         sponsorLevel = SafeMath.add(sponsorLevel, 1);
179     }
180     function getSponsorFee() public view returns(uint256 sponsorFee)
181     {
182         sponsorFee = getCurrentPrice(SafeMath.add(sponsorLevel, 1));
183     }
184     //--------------------------------------------------------------------------
185     // Miner 
186     //--------------------------------------------------------------------------
187     function getFreeMiner(address ref) public 
188     {
189         require(now <= deadline);
190         PlyerData storage p = players[msg.sender];
191         require(p.round != round);
192         //reset player data
193         if(p.hashrate > 0){
194             for (uint idx = 1; idx < numberOfMiners; idx++) {
195                 p.minerCount[idx] = 0;
196             }
197         }
198         p.crystals = 0;
199         p.round = round;
200         //free miner
201         p.lastUpdateTime = now;
202         p.minerCount[0] = 1;
203         MinerData storage m0 = minerData[0];
204         p.hashrate = m0.baseProduct;
205         //send referral 
206         if (ref != msg.sender) {
207             PlyerData storage referral = players[ref];
208             if(referral.round == round){ 
209                 p.crystals = SafeMath.add(p.crystals, SHARE_CRYSTAL);
210                 referral.crystals = SafeMath.add(referral.crystals, SHARE_CRYSTAL);
211             }
212         }
213     }
214     function buyMiner(uint256[] minerNumbers) public
215     {
216         require(now <= deadline);
217         require(players[msg.sender].round == round);
218         require(minerNumbers.length == numberOfMiners);
219         uint256 minerIdx = 0;
220         MinerData memory m;
221         for (; minerIdx < numberOfMiners; minerIdx++) {
222             m = minerData[minerIdx];
223             if(minerNumbers[minerIdx] > m.limit || minerNumbers[minerIdx] < 0){
224                 revert();
225             }
226         }
227         updateCrytal(msg.sender);
228         PlyerData storage p = players[msg.sender];
229         uint256 price = 0;
230         uint256 minerNumber = 0;
231         for (minerIdx = 0; minerIdx < numberOfMiners; minerIdx++) {
232             minerNumber = minerNumbers[minerIdx];
233             if (minerNumber > 0) {
234                 m = minerData[minerIdx];
235                 price = SafeMath.add(price, SafeMath.mul(m.basePrice, minerNumber));
236             }
237         }
238         price = SafeMath.mul(price, CRTSTAL_MINING_PERIOD);
239         if(p.crystals < price){
240             revert();
241         }
242         for (minerIdx = 0; minerIdx < numberOfMiners; minerIdx++) {
243             minerNumber = minerNumbers[minerIdx];
244             if (minerNumber > 0) {
245                 m = minerData[minerIdx];
246                 p.minerCount[minerIdx] = SafeMath.min(m.limit, SafeMath.add(p.minerCount[minerIdx], minerNumber));
247             }
248         }
249         p.crystals = SafeMath.sub(p.crystals, price);
250         updateHashrate(msg.sender);
251     }
252     function getPlayerData(address addr) public view returns (uint256 crystals, uint256 lastupdate, uint256 hashratePerDay,
253      uint256[8] miners, uint256 hasBoost)
254     {
255         PlyerData storage p = players[addr];
256         if(p.round != round){
257             p = players[0];
258         }
259         crystals = SafeMath.div(p.crystals, CRTSTAL_MINING_PERIOD);
260         lastupdate = p.lastUpdateTime;
261         hashratePerDay = p.hashrate;
262         uint256 i = 0;
263         for(i = 0; i < numberOfMiners; i++)
264         {
265             miners[i] = p.minerCount[i];
266         }
267         hasBoost = hasBooster(addr);
268     }
269     function getHashratePerDay(address minerAddr) public view returns (uint256 personalProduction)
270     {
271         PlyerData storage p = players[minerAddr];   
272         personalProduction = p.hashrate;
273         uint256 boosterIdx = hasBooster(minerAddr);
274         if (boosterIdx != 999) {
275             BoostData storage b = boostData[boosterIdx];
276             personalProduction = SafeMath.div(SafeMath.mul(personalProduction, b.boostRate), 100);
277         }
278     }
279     //--------------------------------------------------------------------------
280     // BOOSTER 
281     //--------------------------------------------------------------------------
282     function buyBooster(uint256 idx) public payable 
283     {
284         require(now <= deadline);
285         require(players[msg.sender].round == round);
286         require(idx < numberOfBoosts);
287         BoostData storage b = boostData[idx];
288         if(msg.value < getBoosterPrice(idx) || msg.sender == b.owner){
289             revert();
290         }
291         address beneficiary = b.owner;
292         sponsor.transfer(devFee(getBoosterPrice(idx)));
293         beneficiary.transfer(getBoosterPrice(idx) / 2);
294         updateCrytal(msg.sender);
295         updateCrytal(beneficiary);
296         uint256 level = getCurrentLevel(b.startingLevel, b.startingTime, b.halfLife);
297         b.startingLevel = SafeMath.add(level, 1);
298         b.startingTime = now;
299         // transfer ownership    
300         b.owner = msg.sender;
301     }
302     function getBoosterData(uint256 idx) public view returns (address owner,uint256 boostRate, uint256 startingLevel, 
303         uint256 startingTime, uint256 currentPrice, uint256 halfLife)
304     {
305         require(idx < numberOfBoosts);
306         owner            = boostData[idx].owner;
307         boostRate        = boostData[idx].boostRate; 
308         startingLevel    = boostData[idx].startingLevel;
309         startingTime     = boostData[idx].startingTime;
310         currentPrice     = getBoosterPrice(idx);
311         halfLife         = boostData[idx].halfLife;
312     }
313     function getBoosterPrice(uint256 index) public view returns (uint256)
314     {
315         BoostData storage booster = boostData[index];
316         return getCurrentPrice(getCurrentLevel(booster.startingLevel, booster.startingTime, booster.halfLife));
317     }
318     function hasBooster(address addr) public view returns (uint256 boostIdx)
319     {         
320         boostIdx = 999;
321         for(uint256 i = 0; i < numberOfBoosts; i++){
322             uint256 revert_i = numberOfBoosts - i - 1;
323             if(boostData[revert_i].owner == addr){
324                 boostIdx = revert_i;
325                 break;
326             }
327         }
328     }
329     //--------------------------------------------------------------------------
330     // Market 
331     //--------------------------------------------------------------------------
332     function buyCrystalDemand(uint256 amount, uint256 unitPrice,string title, string description) public payable 
333     {
334         require(now <= deadline);
335         require(players[msg.sender].round == round);
336         require(unitPrice > 0);
337         require(amount >= 1000);
338         require(amount * unitPrice <= msg.value);
339         uint256 lowestIdx = getLowestUnitPriceIdxFromBuy();
340         BuyOrderData storage o = buyOrderData[lowestIdx];
341         if(o.amount > 10 && unitPrice <= o.unitPrice){
342             revert();
343         }
344         uint256 balance = SafeMath.mul(o.amount, o.unitPrice);
345         if (o.owner != 0){
346             o.owner.transfer(balance);
347         }
348         o.owner = msg.sender;
349         o.unitPrice = unitPrice;
350         o.title = title;
351         o.description = description;
352         o.amount = amount;
353     }
354     function sellCrystal(uint256 amount, uint256 index) public 
355     {
356         require(now <= deadline);
357         require(players[msg.sender].round == round);
358         require(index < numberOfOrders);
359         require(amount > 0);
360         BuyOrderData storage o = buyOrderData[index];
361         require(amount <= o.amount);
362         updateCrytal(msg.sender);
363         PlyerData storage seller = players[msg.sender];
364         PlyerData storage buyer = players[o.owner];
365         require(seller.crystals >= amount * CRTSTAL_MINING_PERIOD);
366         uint256 price = SafeMath.mul(amount, o.unitPrice);
367         uint256 fee = devFee(price);
368         sponsor.transfer(fee);
369         administrator.transfer(fee);
370         buyer.crystals = SafeMath.add(buyer.crystals, amount * CRTSTAL_MINING_PERIOD);
371         seller.crystals = SafeMath.sub(seller.crystals, amount * CRTSTAL_MINING_PERIOD);
372         o.amount = SafeMath.sub(o.amount, amount);
373         msg.sender.transfer(SafeMath.div(price, 2));
374     }
375     function withdrawBuyDemand(uint256 index) public 
376     {
377         require(now <= deadline);
378         require(index < numberOfOrders);
379         require(players[msg.sender].round == round);
380         BuyOrderData storage o = buyOrderData[index];
381         require(o.owner == msg.sender);
382         if(o.amount > 0){
383             uint256 balance = SafeMath.mul(o.amount, o.unitPrice);
384             o.owner.transfer(balance);
385         }
386         o.unitPrice = 0;
387         o.amount = 0;  
388         o.title = "title";
389         o.description = "description";
390         o.owner = 0;
391     }
392     function getBuyDemand(uint256 index) public view returns(address owner, string title, string description,
393      uint256 amount, uint256 unitPrice)
394     {
395         require(index < numberOfOrders);
396         BuyOrderData storage o = buyOrderData[index];
397         owner = o.owner;
398         title = o.title;
399         description = o.description;
400         amount = o.amount;
401         unitPrice = o.unitPrice;
402     }
403     function getLowestUnitPriceIdxFromBuy() public returns(uint256 lowestIdx)
404     {
405         uint256 lowestPrice = 2**256 - 1;
406         for (uint256 idx = 0; idx < numberOfOrders; idx++) {
407             BuyOrderData storage o = buyOrderData[idx];
408             //if empty
409             if (o.unitPrice == 0 || o.amount < 10) {
410                 return idx;
411             }else if (o.unitPrice < lowestPrice) {
412                 lowestPrice = o.unitPrice;
413                 lowestIdx = idx;
414             }
415         }
416     }
417     //-------------------------Sell-----------------------------
418     function sellCrystalDemand(uint256 amount, uint256 unitPrice, string title, string description) public 
419     {
420         require(now <= deadline);
421         require(players[msg.sender].round == round);
422         require(amount >= 1000);
423         require(unitPrice > 0);
424         updateCrytal(msg.sender);
425         PlyerData storage seller = players[msg.sender];
426         if(seller.crystals < amount * CRTSTAL_MINING_PERIOD){
427             revert();
428         }
429         uint256 highestIdx = getHighestUnitPriceIdxFromSell();
430         SellOrderData storage o = sellOrderData[highestIdx];
431         if(o.amount > 10 && unitPrice >= o.unitPrice){
432             revert();
433         }
434         if (o.owner != 0){
435             PlyerData storage prev = players[o.owner];
436             prev.crystals = SafeMath.add(prev.crystals, o.amount * CRTSTAL_MINING_PERIOD);
437         }
438         o.owner = msg.sender;
439         o.unitPrice = unitPrice;
440         o.title = title;
441         o.description = description;
442         o.amount = amount;
443         //sub crystals
444         seller.crystals = SafeMath.sub(seller.crystals, amount * CRTSTAL_MINING_PERIOD);
445     }
446     function buyCrystal(uint256 amount, uint256 index) public payable
447     {
448         require(now <= deadline);
449         require(players[msg.sender].round == round);
450         require(index < numberOfOrders);
451         require(amount > 0);
452         SellOrderData storage o = sellOrderData[index];
453         require(amount <= o.amount);
454         require(msg.value >= amount * o.unitPrice);
455         PlyerData storage buyer = players[msg.sender];
456         uint256 price = SafeMath.mul(amount, o.unitPrice);
457         uint256 fee = devFee(price);
458         sponsor.transfer(fee);
459         administrator.transfer(fee);
460         buyer.crystals = SafeMath.add(buyer.crystals, amount * CRTSTAL_MINING_PERIOD);
461         o.amount = SafeMath.sub(o.amount, amount);
462         o.owner.transfer(SafeMath.div(price, 2));
463     }
464     function withdrawSellDemand(uint256 index) public 
465     {
466         require(now <= deadline);
467         require(index < numberOfOrders);
468         require(players[msg.sender].round == round);
469         SellOrderData storage o = sellOrderData[index];
470         require(o.owner == msg.sender);
471         if(o.amount > 0){
472             PlyerData storage p = players[o.owner];
473             p.crystals = SafeMath.add(p.crystals, o.amount * CRTSTAL_MINING_PERIOD);
474         }
475         o.unitPrice = 0;
476         o.amount = 0; 
477         o.title = "title";
478         o.description = "description";
479         o.owner = 0;
480     }
481     function getSellDemand(uint256 index) public view returns(address owner, string title, string description,
482      uint256 amount, uint256 unitPrice)
483     {
484         require(index < numberOfOrders);
485         SellOrderData storage o = sellOrderData[index];
486         owner = o.owner;
487         title = o.title;
488         description = o.description;
489         amount = o.amount;
490         unitPrice = o.unitPrice;
491     }
492     function getHighestUnitPriceIdxFromSell() public returns(uint256 highestIdx)
493     {
494         uint256 highestPrice = 0;
495         for (uint256 idx = 0; idx < numberOfOrders; idx++) {
496             SellOrderData storage o = sellOrderData[idx];
497             //if empty
498             if (o.unitPrice == 0 || o.amount < 10) {
499                 return idx;
500             }else if (o.unitPrice > highestPrice) {
501                 highestPrice = o.unitPrice;
502                 highestIdx = idx;
503             }
504         }
505     }
506     //--------------------------------------------------------------------------
507     // Other 
508     //--------------------------------------------------------------------------
509     function devFee(uint256 amount) public view returns(uint256)
510     {
511         return SafeMath.div(SafeMath.mul(amount, 5), 100);
512     }
513     function getBalance() public view returns(uint256)
514     {
515         return this.balance;
516     }
517     //--------------------------------------------------------------------------
518     // Private 
519     //--------------------------------------------------------------------------
520     function updateHashrate(address addr) private
521     {
522         PlyerData storage p = players[addr];
523         uint256 hashrate = 0;
524         for (uint idx = 0; idx < numberOfMiners; idx++) {
525             MinerData storage m = minerData[idx];
526             hashrate = SafeMath.add(hashrate, SafeMath.mul(p.minerCount[idx], m.baseProduct));
527         }
528         p.hashrate = hashrate;
529         if(hashrate > RANK_LIST_LIMIT){
530             updateRankList(addr);
531         }
532     }
533     function updateCrytal(address addr) private
534     {
535         require(now > players[addr].lastUpdateTime);
536         if (players[addr].lastUpdateTime != 0) {
537             PlyerData storage p = players[addr];
538             uint256 secondsPassed = SafeMath.sub(now, p.lastUpdateTime);
539             uint256 revenue = getHashratePerDay(addr);
540             p.lastUpdateTime = now;
541             if (revenue > 0) {
542                 revenue = SafeMath.mul(revenue, secondsPassed);
543                 p.crystals = SafeMath.add(p.crystals, revenue);
544             }
545         }
546     }
547     function getCurrentLevel(uint256 startingLevel, uint256 startingTime, uint256 halfLife) private view returns(uint256) 
548     {
549         uint256 timePassed=SafeMath.sub(now, startingTime);
550         uint256 levelsPassed=SafeMath.div(timePassed, halfLife);
551         if (startingLevel < levelsPassed) {
552             return 0;
553         }
554         return SafeMath.sub(startingLevel, levelsPassed);
555     }
556     function getCurrentPrice(uint256 currentLevel) private view returns(uint256) 
557     {
558         return SafeMath.mul(BASE_PRICE, 2**currentLevel);
559     }
560     function updateRankList(address addr) private returns(bool)
561     {
562         uint256 idx = 0;
563         PlyerData storage insert = players[addr];
564         PlyerData storage lastOne = players[rankList[19]];
565         if(insert.hashrate < lastOne.hashrate) {
566             return false;
567         }
568         address[21] memory tempList = rankList;
569         if(!inRankList(addr)){
570             tempList[20] = addr;
571             quickSort(tempList, 0, 20);
572         }else{
573             quickSort(tempList, 0, 19);
574         }
575         for(idx = 0;idx < 21; idx++){
576             if(tempList[idx] != rankList[idx]){
577                 rankList[idx] = tempList[idx];
578             }
579         }
580         
581         return true;
582     }
583     function inRankList(address addr) internal returns(bool)
584     {
585         for(uint256 idx = 0;idx < 20; idx++){
586             if(addr == rankList[idx]){
587                 return true;
588             }
589         }
590         return false;
591     }
592     function quickSort(address[21] list, int left, int right) internal
593     {
594         int i = left;
595         int j = right;
596         if(i == j) return;
597         address addr = list[uint(left + (right - left) / 2)];
598         PlyerData storage p = players[addr];
599         while (i <= j) {
600             while (players[list[uint(i)]].hashrate > p.hashrate) i++;
601             while (p.hashrate > players[list[uint(j)]].hashrate) j--;
602             if (i <= j) {
603                 (list[uint(i)], list[uint(j)]) = (list[uint(j)], list[uint(i)]);
604                 i++;
605                 j--;
606             }
607         }
608         if (left < j)
609             quickSort(list, left, j);
610         if (i < right)
611             quickSort(list, i, right);
612     }
613 }