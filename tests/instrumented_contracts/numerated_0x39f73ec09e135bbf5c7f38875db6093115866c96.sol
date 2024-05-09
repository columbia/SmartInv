1 pragma solidity ^0.4.0;
2 
3 contract EZTanks{
4     
5     // STRUCTS HERE
6     struct TankObject{
7         // type of tank 
8         uint256 typeID; 
9 
10         // tank quality
11         uint8[4] upgrades;
12 
13         bool inBattle;
14         
15         // stats
16         address tankOwner;
17         uint256 earningsIndex; 
18         
19         // buying & selling 
20         bool inAuction;
21         uint256 currAuction;
22     }
23 
24     struct TankType{
25         uint256 startPrice;
26         uint256 currPrice;
27         uint256 earnings;
28 
29         // battle stats
30         uint32 baseHealth;
31         uint32 baseAttack;
32         uint32 baseArmor;
33         uint32 baseSpeed;
34 
35         uint32 numTanks;
36     }
37     
38     struct AuctionObject{
39         uint tank; // tank id
40         uint startPrice;
41         uint endPrice;
42         uint startTime;
43         uint duration;
44         bool alive;
45     }
46     
47     // EVENTS HERE
48     event EventWithdraw (
49        address indexed player,
50        uint256 amount
51     ); 
52 
53     event EventUpgradeTank (
54         address indexed player,
55         uint256 tankID,
56         uint8 upgradeChoice
57     ); 
58     
59     event EventAuction (
60         address indexed player,
61         uint256 tankID,
62         uint256 startPrice,
63         uint256 endPrice,
64         uint256 duration,
65         uint256 currentTime
66     );
67         
68     event EventCancelAuction (
69         uint256 indexed tankID,
70         address owner
71     ); 
72     
73     event EventBid (
74         uint256 indexed tankID,
75         address indexed buyer
76     ); 
77     
78     event EventBuyTank (
79         address indexed player,
80         uint256 productID,
81         uint256 tankID,
82         uint256 newPrice
83     ); 
84 
85     event EventCashOutTank(
86         address indexed player,
87         uint256 amount
88     );
89 
90     event EventJoinedBattle(
91         address indexed player,
92         uint256 indexed tankID
93     );
94 
95     event EventQuitBattle(
96         address indexed player,
97         uint256 indexed tankID
98     );
99     
100     event EventBattleOver();
101     
102     // FIELDS HERE
103     
104     // contract fields 
105     uint8 feeAmt = 3;
106     uint8 tournamentTaxRate = 5;
107     address owner;
108 
109 
110     // battle!
111     uint256 tournamentAmt = 0;
112     uint8 teamSize = 5;
113     uint256 battleFee = 1 ether / 1000;
114     uint256[] battleTeams;
115 
116     // tank fields
117     uint256 newTypeID = 1;
118     uint256 newTankID = 1;
119     uint256 newAuctionID = 1;
120     
121     mapping (uint256 => TankType) baseTanks;
122     mapping (uint256 => TankObject) tanks; //maps tankID to tanks
123     mapping (address => uint256[]) userTanks;
124     mapping (uint => AuctionObject) auctions; //maps auctionID to auction
125     mapping (address => uint) balances; 
126 
127     // MODIFIERS HERE
128     modifier isOwner {
129         require(msg.sender == owner);
130         _;
131     }
132     
133     // CTOR
134     function EZTanks() public payable{
135         // init owner
136         owner = msg.sender;
137         balances[owner] += msg.value;
138 
139         // basic tank
140         newTankType(1 ether / 80, 1 ether / 1000, 2500, 50, 40, 3);
141 
142         // bulky tank
143         newTankType(1 ether / 50, 1 ether / 1000, 5500, 50, 41, 3);
144 
145         // speeder tank
146         newTankType(1 ether / 50, 1 ether / 1000, 2000, 50, 40, 5);
147 
148         // powerful tank
149         newTankType(1 ether / 50, 1 ether / 1000, 3000, 53, 39, 3);
150 
151         // armor tank
152         newTankType(1 ether / 50, 1 ether / 1000, 4000, 51, 43, 2);
153 
154         // better than basic tank
155         newTankType(1 ether / 40, 1 ether / 200, 3000, 52, 41, 4);
156     }
157 
158     // ADMINISTRATIVE FUNCTIONS
159 
160     function setNewOwner(address newOwner) public isOwner{
161         owner = newOwner;
162     }
163 
164     // create a new tank type 
165     function newTankType ( 
166         uint256 _startPrice,
167         uint256 _earnings,
168         uint32 _baseHealth,
169         uint32 _baseAttack,
170         uint32 _baseArmor,
171         uint32 _baseSpeed
172     ) public isOwner {
173         baseTanks[newTypeID++] = TankType({
174             startPrice : _startPrice,
175             currPrice : _startPrice,
176             earnings : _earnings,
177             baseAttack : _baseAttack,
178             baseArmor : _baseArmor,
179             baseSpeed : _baseSpeed,
180             baseHealth : _baseHealth,
181             numTanks : 0
182         });
183 
184     }
185     
186     // fee from auctioning
187     function changeFeeAmt (uint8 _amt) public isOwner {
188         require(_amt > 0 && _amt < 100);
189         feeAmt = _amt;
190     }
191 
192     // rate to fund tournament
193     function changeTournamentTaxAmt (uint8 _rate) public isOwner {
194         require(_rate > 0 && _rate < 100);
195         tournamentTaxRate = _rate;
196     }
197 
198     function changeTeamSize(uint8 _size) public isOwner {
199         require(_size > 0);
200         teamSize = _size;
201     }
202 
203     // cost to enter battle
204     function changeBattleFee(uint256 _fee) public isOwner {
205         require(_fee > 0);
206         battleFee = _fee;
207     }
208     
209     // INTERNAL FUNCTIONS
210 
211     function delTankFromUser(address user, uint256 value) internal {
212         uint l = userTanks[user].length;
213 
214         for(uint i=0; i<l; i++){
215             if(userTanks[user][i] == value){
216                 delete userTanks[user][i];
217                 userTanks[user][i] = userTanks[user][l-1];
218                 userTanks[user].length = l-1;
219                 return;
220             }
221         }
222     }
223 
224     // USER FUNCTIONS
225 
226     function withdraw (uint256 _amount) public payable {
227         // validity checks
228         require (_amount >= 0); 
229         require (this.balance >= _amount); 
230         require (balances[msg.sender] >= _amount); 
231         
232         // return everything is withdrawing 0
233         if (_amount == 0){
234             _amount = balances[msg.sender];
235         }
236         
237         require(msg.sender.send(_amount));
238         balances[msg.sender] -= _amount; 
239         
240         EventWithdraw (msg.sender, _amount);
241     }
242     
243     
244     function auctionTank (uint _tankID, uint _startPrice, uint _endPrice, uint256 _duration) public {
245         require (_tankID > 0 && _tankID < newTankID);
246         require (tanks[_tankID].tankOwner == msg.sender);
247         require (!tanks[_tankID].inBattle);
248         require (!tanks[_tankID].inAuction);
249         require (tanks[_tankID].currAuction == 0);
250         require (_startPrice >= _endPrice);
251         require (_startPrice > 0 && _endPrice >= 0);
252         require (_duration > 0);
253         
254         auctions[newAuctionID] = AuctionObject(_tankID, _startPrice, _endPrice, now, _duration, true);
255         tanks[_tankID].inAuction = true;
256         tanks[_tankID].currAuction = newAuctionID;
257         
258         newAuctionID++;
259 
260         EventAuction (msg.sender, _tankID, _startPrice, _endPrice, _duration, now);
261     }
262     
263     // buy tank from auction
264     function bid (uint256 _tankID) public payable {
265         // validity checks
266         require (_tankID > 0 && _tankID < newTankID); // check if tank is valid
267         require (tanks[_tankID].inAuction == true); // check if tank is currently in auction
268         
269         
270         uint256 auctionID = tanks[_tankID].currAuction;
271         uint256 currPrice = getCurrAuctionPriceAuctionID(auctionID);
272         
273         require (currPrice >= 0); 
274         require (msg.value >= currPrice); 
275         
276         if(msg.value > currPrice){
277             balances[msg.sender] += (msg.value - currPrice);
278         }
279 
280 
281         // calculate new balances
282         uint256 fee = (currPrice*feeAmt) / 100; 
283 
284         //update tournamentAmt
285         uint256 tournamentTax = (fee*tournamentTaxRate) / 100;
286         tournamentAmt += tournamentTax;
287     
288         balances[tanks[_tankID].tankOwner] += currPrice - fee;
289         balances[owner] += (fee - tournamentTax); 
290 
291         // update object fields
292         address formerOwner = tanks[_tankID].tankOwner;
293 
294         tanks[_tankID].tankOwner = msg.sender;
295         tanks[_tankID].inAuction = false; 
296         auctions[tanks[_tankID].currAuction].alive = false; 
297         tanks[_tankID].currAuction = 0; 
298 
299         // update userTanks
300         userTanks[msg.sender].push(_tankID);
301         delTankFromUser(formerOwner, _tankID);
302 
303         EventBid (_tankID, msg.sender);
304     }
305     
306     function cancelAuction (uint256 _tankID) public {
307         require (_tankID > 0 && _tankID < newTankID); 
308         require (tanks[_tankID].inAuction); 
309         require (tanks[_tankID].tankOwner == msg.sender); 
310         
311         // update tank object
312         tanks[_tankID].inAuction = false; 
313         auctions[tanks[_tankID].currAuction].alive = false; 
314         tanks[_tankID].currAuction = 0; 
315 
316         EventCancelAuction (_tankID, msg.sender);
317     }
318 
319     function buyTank (uint32 _typeID) public payable {
320         require(_typeID > 0 && _typeID < newTypeID);
321         require (baseTanks[_typeID].currPrice > 0 && msg.value > 0); 
322         require (msg.value >= baseTanks[_typeID].currPrice); 
323         
324         if (msg.value > baseTanks[_typeID].currPrice){
325             balances[msg.sender] += msg.value - baseTanks[_typeID].currPrice;
326         }
327         
328         baseTanks[_typeID].currPrice += baseTanks[_typeID].earnings;
329         
330         uint256 earningsIndex = baseTanks[_typeID].numTanks + 1;
331         baseTanks[_typeID].numTanks += 1;
332 
333         tanks[newTankID++] = TankObject ({
334             typeID : _typeID,
335             upgrades : [0,0,0,0],
336             inBattle : false,
337             tankOwner : msg.sender,
338             earningsIndex : earningsIndex,
339             inAuction : false,
340             currAuction : 0
341         });
342 
343         uint256 price = baseTanks[_typeID].startPrice;
344         uint256 tournamentProceeds = (price * tournamentTaxRate) / 100;
345 
346         balances[owner] += baseTanks[_typeID].startPrice - tournamentProceeds;
347         tournamentAmt += tournamentProceeds;
348 
349         userTanks[msg.sender].push(newTankID-1);
350         
351         EventBuyTank (msg.sender, _typeID, newTankID-1, baseTanks[_typeID].currPrice);
352     }
353 
354     //cashing out the money that a tank has earned
355     function cashOutTank (uint256 _tankID) public {
356         // validity checks
357         require (_tankID > 0 && _tankID < newTankID); 
358         require (tanks[_tankID].tankOwner == msg.sender);
359         require (!tanks[_tankID].inAuction && tanks[_tankID].currAuction == 0);
360         require (!tanks[_tankID].inBattle);
361 
362         
363         uint256 tankType = tanks[_tankID].typeID;
364         uint256 numTanks = baseTanks[tankType].numTanks;
365 
366         uint256 amount = getCashOutAmount(_tankID);
367 
368         require (this.balance >= amount); 
369         require (amount > 0);
370         
371         require(tanks[_tankID].tankOwner.send(amount));
372         tanks[_tankID].earningsIndex = numTanks;
373         
374         EventCashOutTank (msg.sender, amount);
375     }
376     
377     // 0 -> health, 1 -> attack, 2 -> armor, 3 -> speed
378     function upgradeTank (uint256 _tankID, uint8 _upgradeChoice) public payable {
379         // validity checks
380         require (_tankID > 0 && _tankID < newTankID); 
381         require (tanks[_tankID].tankOwner == msg.sender); 
382         require (!tanks[_tankID].inAuction);
383         require (!tanks[_tankID].inBattle);
384         require (_upgradeChoice >= 0 && _upgradeChoice < 4); 
385         
386         // no overflow!
387         require(tanks[_tankID].upgrades[_upgradeChoice] + 1 > tanks[_tankID].upgrades[_upgradeChoice]);
388 
389         uint256 upgradePrice = baseTanks[tanks[_tankID].typeID].startPrice / 4;
390         require (msg.value >= upgradePrice); 
391 
392         tanks[_tankID].upgrades[_upgradeChoice]++; 
393 
394         if(msg.value > upgradePrice){
395             balances[msg.sender] += msg.value-upgradePrice; 
396         }
397 
398         uint256 tournamentProceeds = (upgradePrice * tournamentTaxRate) / 100;
399 
400         balances[owner] += (upgradePrice - tournamentProceeds); 
401         tournamentAmt += tournamentProceeds;
402         
403         EventUpgradeTank (msg.sender, _tankID, _upgradeChoice);
404     }
405 
406     function battle(uint256 _tankID) public payable {
407         require(_tankID >0 && _tankID < newTankID);
408         require(tanks[_tankID].tankOwner == msg.sender);
409         require(!tanks[_tankID].inAuction);
410         require(!tanks[_tankID].inBattle);
411         require(msg.value >= battleFee);
412 
413         if(msg.value > battleFee){
414             balances[msg.sender] += (msg.value - battleFee);
415         }
416 
417         tournamentAmt += battleFee;
418         
419         EventJoinedBattle(msg.sender, _tankID);
420 
421         // add to teams
422         if(battleTeams.length < 2*teamSize - 1){
423             battleTeams.push(_tankID);
424             tanks[_tankID].inBattle = true;
425 
426         // time to battle!
427         } else {
428             battleTeams.push(_tankID);
429 
430             uint256[4] memory teamA;
431             uint256[4] memory teamB;
432             uint256[4] memory temp;
433 
434             for(uint i=0; i<teamSize; i++){
435                 temp = getCurrentStats(battleTeams[i]);
436                 teamA[0] += temp[0];
437                 teamA[1] += temp[1];
438                 teamA[2] += temp[2];
439                 teamA[3] += temp[3];
440 
441                 temp = getCurrentStats(battleTeams[teamSize+i]);
442                 teamB[0] += temp[0];
443                 teamB[1] += temp[1];
444                 teamB[2] += temp[2];
445                 teamB[3] += temp[3];
446             }
447 
448             // lower score is better
449             uint256 diffA = teamA[1] - teamB[2];
450             uint256 diffB = teamB[1] - teamA[2];
451             
452             diffA = diffA > 0 ? diffA : 1;
453             diffB = diffB > 0 ? diffB : 1;
454 
455             uint256 teamAScore = teamB[0] / (diffA * teamA[3]);
456             uint256 teamBScore = teamA[0] / (diffB * teamB[3]);
457 
458             if((teamB[0] % (diffA * teamA[3])) != 0) {
459                 teamAScore += 1;
460             }
461 
462             if((teamA[0] % (diffB * teamB[3])) != 0) {
463                 teamBScore += 1;
464             }
465 
466             uint256 toDistribute = tournamentAmt / teamSize;
467             tournamentAmt -= teamSize*toDistribute;
468 
469             if(teamAScore <= teamBScore){
470                 for(i=0; i<teamSize; i++){
471                     balances[tanks[battleTeams[i]].tankOwner] += toDistribute;   
472                 }
473             } else {
474                 for(i=0; i<teamSize; i++){
475                     balances[tanks[battleTeams[teamSize+i]].tankOwner] += toDistribute;   
476                 }
477                    
478             }
479 
480             for(i=0; i<2*teamSize; i++){
481                 tanks[battleTeams[i]].inBattle = false;
482             }
483 
484             EventBattleOver();
485 
486             battleTeams.length = 0;
487         }
488     }
489 
490     function quitBattle(uint256 _tankID) public {
491         require(_tankID >0 && _tankID < newTankID);
492         require(tanks[_tankID].tankOwner == msg.sender);
493         require(tanks[_tankID].inBattle);
494         
495         uint l = battleTeams.length;
496 
497         for(uint i=0; i<l; i++){
498             if(battleTeams[i] == _tankID){
499                 EventQuitBattle(msg.sender, _tankID);
500 
501                 delete battleTeams[i];
502                 battleTeams[i] = battleTeams[l-1];
503                 battleTeams.length = l-1;
504                 tanks[_tankID].inBattle = false;
505 
506                 return;
507             }
508         }
509     }
510 
511     // CONVENIENCE GETTER METHODS
512     
513     function getCurrAuctionPriceTankID (uint256 _tankID) public constant returns (uint256 price){
514         require (tanks[_tankID].inAuction);
515         uint256 auctionID = tanks[_tankID].currAuction;
516 
517         return getCurrAuctionPriceAuctionID(auctionID);
518     }
519     
520     function getPlayerBalance(address _playerID) public constant returns (uint256 balance){
521         return balances[_playerID];
522     }
523     
524     function getContractBalance() public constant isOwner returns (uint256){
525         return this.balance;
526     }
527 
528     function getTankOwner(uint256 _tankID) public constant returns (address) {
529         require(_tankID > 0 && _tankID < newTankID);
530         return tanks[_tankID].tankOwner;
531     }
532 
533     function getOwnedTanks(address _add) public constant returns (uint256[]){
534         return userTanks[_add];
535     }
536 
537     function getTankType(uint256 _tankID) public constant returns (uint256) {
538         require(_tankID > 0 && _tankID < newTankID);
539         return tanks[_tankID].typeID;
540     }
541 
542     function getCurrTypePrice(uint256 _typeID) public constant returns (uint256) {
543         require(_typeID > 0 && _typeID < newTypeID);
544         return baseTanks[_typeID].currPrice;
545     }
546 
547     function getNumTanksType(uint256 _typeID) public constant returns (uint256) {
548         require(_typeID > 0 && _typeID < newTypeID);
549         return baseTanks[_typeID].numTanks;
550     }
551     
552     function getNumTanks() public constant returns(uint256){
553         return newTankID-1;
554     }
555 
556     function checkTankAuction(uint256 _tankID) public constant returns (bool) {
557         require(0 < _tankID && _tankID < newTankID);
558         return tanks[_tankID].inAuction;
559     }
560 
561     function getCurrAuctionPriceAuctionID(uint256 _auctionID) public constant returns (uint256){
562         require(_auctionID > 0 && _auctionID < newAuctionID);
563 
564         AuctionObject memory currAuction = auctions[_auctionID];
565 
566         // calculate the current auction price       
567         uint256 currPrice = currAuction.startPrice;
568         uint256 diff = ((currAuction.startPrice-currAuction.endPrice) / (currAuction.duration)) * (now-currAuction.startTime);
569 
570 
571         if (currPrice-diff < currAuction.endPrice || diff > currPrice){ 
572             currPrice = currAuction.endPrice;  
573         } else {
574             currPrice -= diff;
575         }
576 
577         return currPrice;
578     }
579 
580     // returns [tankID, currPrice, alive]
581     function getAuction(uint256 _auctionID) public constant returns (uint256[3]){
582         require(_auctionID > 0 && _auctionID < newAuctionID);
583 
584         uint256 tankID = auctions[_auctionID].tank;
585         uint256 currPrice = getCurrAuctionPriceAuctionID(_auctionID);
586         bool alive = auctions[_auctionID].alive;
587 
588         uint256[3] memory out;
589         out[0] = tankID;
590         out[1] = currPrice;
591         out[2] = alive ? 1 : 0;
592 
593         return out;
594     }
595  
596     function getUpgradePrice(uint256 _tankID) public constant returns (uint256) {
597         require(_tankID >0 && _tankID < newTankID);
598         return baseTanks[tanks[_tankID].typeID].startPrice / 4;
599     }
600 
601     // [health, attack, armor, speed]
602     function getUpgradeAmt(uint256 _tankID) public constant returns (uint8[4]) {
603         require(_tankID > 0 && _tankID < newTankID);
604 
605         return tanks[_tankID].upgrades;
606     }
607 
608     // [health, attack, armor, speed]
609     function getCurrentStats(uint256 _tankID) public constant returns (uint256[4]) {
610         require(_tankID > 0 && _tankID < newTankID);
611 
612         TankType memory baseType = baseTanks[tanks[_tankID].typeID];
613         uint8[4] memory upgrades = tanks[_tankID].upgrades;
614         uint256[4] memory out;
615 
616         out[0] = baseType.baseHealth + (upgrades[0] * baseType.baseHealth / 4);
617         out[1] = baseType.baseAttack + upgrades[1]; 
618         out[2] = baseType.baseArmor + upgrades[2];
619         out[3] = baseType.baseSpeed + upgrades[3];
620         
621         return out;
622     }
623 
624     function inBattle(uint256 _tankID) public constant returns (bool) {
625         require(_tankID > 0 && _tankID < newTankID);
626         return tanks[_tankID].inBattle;
627     }
628 
629     function getCurrTeamSizes() public constant returns (uint) {
630         return battleTeams.length;
631     }
632 
633     function getBattleTeamSize() public constant returns (uint8) {
634         return teamSize;
635     }
636 
637     function donate() public payable {
638         require(msg.value > 0);
639         tournamentAmt += msg.value;
640     }
641 
642     function getTournamentAmt() public constant returns (uint256) {
643         return tournamentAmt;
644     }
645 
646     function getBattleFee() public constant returns (uint256){
647         return battleFee;
648     }
649 
650     function getTournamentRate() public constant returns (uint8){
651         return tournamentTaxRate;
652     }
653 
654     function getCurrFeeRate() public constant returns (uint8) {
655         return feeAmt;
656     }
657     
658     // [startPrice, currPrice, earnings, baseHealth, baseAttack, baseArmor, baseSpeed, numTanks] 
659     function getBaseTypeStats(uint256 _typeID) public constant returns (uint256[8]){
660         require(0 < _typeID && _typeID < newTypeID);
661         uint256[8] memory out;
662 
663         out[0] = baseTanks[_typeID].startPrice;
664         out[1] = baseTanks[_typeID].currPrice;
665         out[2] = baseTanks[_typeID].earnings;
666         out[3] = baseTanks[_typeID].baseHealth;
667         out[4] = baseTanks[_typeID].baseAttack;
668         out[5] = baseTanks[_typeID].baseArmor;
669         out[6] = baseTanks[_typeID].baseSpeed;
670         out[7] = baseTanks[_typeID].numTanks;
671 
672         return out;
673     }
674 
675     function getCashOutAmount(uint256 _tankID) public constant returns (uint256) {
676         require(0 < _tankID && _tankID < newTankID);
677 
678         uint256 tankType = tanks[_tankID].typeID;
679         uint256 earnings = baseTanks[tankType].earnings;
680         uint256 earningsIndex = tanks[_tankID].earningsIndex;
681         uint256 numTanks = baseTanks[tankType].numTanks;
682 
683         return earnings * (numTanks - earningsIndex);
684     }
685 }