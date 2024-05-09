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
12         uint8 exp;
13         uint8 next;
14         bool inBattle;
15         
16         // stats
17         address tankOwner;
18         uint256 earningsIndex; 
19         
20         // buying & selling 
21         bool inAuction;
22         uint256 currAuction;
23     }
24 
25     struct TankType{
26         uint256 startPrice;
27         uint256 currPrice;
28         uint256 earnings;
29 
30         // battle stats
31         uint32 baseHealth;
32         uint32 baseAttack;
33         uint32 baseArmor;
34         uint32 baseSpeed;
35 
36         uint32 numTanks;
37     }
38     
39     struct AuctionObject{
40         uint tank; // tank id
41         uint startPrice;
42         uint endPrice;
43         uint startTime;
44         uint duration;
45         bool alive;
46     }
47     
48     // EVENTS HERE
49     event EventWithdraw (
50        address indexed player,
51        uint256 amount
52     ); 
53 
54     event EventUpgradeTank (
55         address indexed player,
56         uint256 tankID,
57         uint8 upgradeChoice
58     ); 
59     
60     event EventAuction (
61         address indexed player,
62         uint256 tankID,
63         uint256 startPrice,
64         uint256 endPrice,
65         uint256 duration,
66         uint256 currentTime
67     );
68         
69     event EventCancelAuction (
70         uint256 indexed tankID,
71         address owner
72     ); 
73     
74     event EventBid (
75         uint256 indexed tankID,
76         address indexed buyer
77     ); 
78     
79     event EventBuyTank (
80         address indexed player,
81         uint256 productID,
82         uint256 tankID,
83         uint256 newPrice
84     ); 
85 
86     event EventCashOutTank(
87         address indexed player,
88         uint256 amount
89     );
90 
91     event EventJoinedBattle(
92         address indexed player,
93         uint256 indexed tankID
94     );
95 
96     event EventQuitBattle(
97         address indexed player,
98         uint256 indexed tankID
99     );
100     
101     event EventBattleOver();
102     
103     // FIELDS HERE
104     
105     // contract fields 
106     uint8 feeAmt = 3;
107     uint8 tournamentTaxRate = 5;
108     address owner;
109 
110 
111     // battle!
112     uint256 tournamentAmt = 0;
113     uint8 teamSize = 5;
114     uint256 battleFee = 1 ether / 1000;
115     uint256[] battleTeams;
116 
117     // tank fields
118     uint256 newTypeID = 1;
119     uint256 newTankID = 1;
120     uint256 newAuctionID = 1;
121     
122     mapping (uint256 => TankType) baseTanks;
123     mapping (uint256 => TankObject) tanks; //maps tankID to tanks
124     mapping (address => uint256[]) userTanks;
125     mapping (uint => AuctionObject) auctions; //maps auctionID to auction
126     mapping (address => uint) balances; 
127 
128     // MODIFIERS HERE
129     modifier isOwner {
130         require(msg.sender == owner);
131         _;
132     }
133     
134     // CTOR
135     function EZTanks() public payable{
136         // init owner
137         owner = msg.sender;
138         balances[owner] += msg.value;
139 
140         // basic tank
141         newTankType(1 ether / 80, 1 ether / 1000, 2500, 50, 40, 3);
142 
143         // bulky tank
144         newTankType(1 ether / 50, 1 ether / 1000, 5500, 50, 41, 3);
145 
146         // speeder tank
147         newTankType(1 ether / 50, 1 ether / 1000, 2000, 50, 40, 5);
148 
149         // powerful tank
150         newTankType(1 ether / 50, 1 ether / 1000, 3000, 53, 39, 3);
151 
152         // armor tank
153         newTankType(1 ether / 50, 1 ether / 1000, 4000, 51, 43, 2);
154 
155         // better than basic tank
156         newTankType(1 ether / 40, 1 ether / 200, 3000, 52, 41, 4);
157     }
158 
159     // ADMINISTRATIVE FUNCTIONS
160 
161     function setNewOwner(address newOwner) public isOwner{
162         owner = newOwner;
163     }
164 
165     // create a new tank type 
166     function newTankType ( 
167         uint256 _startPrice,
168         uint256 _earnings,
169         uint32 _baseHealth,
170         uint32 _baseAttack,
171         uint32 _baseArmor,
172         uint32 _baseSpeed
173     ) public isOwner {
174         baseTanks[newTypeID++] = TankType({
175             startPrice : _startPrice,
176             currPrice : _startPrice,
177             earnings : _earnings,
178             baseAttack : _baseAttack,
179             baseArmor : _baseArmor,
180             baseSpeed : _baseSpeed,
181             baseHealth : _baseHealth,
182             numTanks : 0
183         });
184 
185     }
186     
187     // fee from auctioning
188     function changeFeeAmt (uint8 _amt) public isOwner {
189         require(_amt > 0 && _amt < 100);
190         feeAmt = _amt;
191     }
192 
193     // rate to fund tournament
194     function changeTournamentTaxAmt (uint8 _rate) public isOwner {
195         require(_rate > 0 && _rate < 100);
196         tournamentTaxRate = _rate;
197     }
198 
199     function changeTeamSize(uint8 _size) public isOwner {
200         require(_size > 0);
201         teamSize = _size;
202     }
203 
204     // cost to enter battle
205     function changeBattleFee(uint256 _fee) public isOwner {
206         require(_fee > 0);
207         battleFee = _fee;
208     }
209     
210     // INTERNAL FUNCTIONS
211 
212     function delTankFromUser(address user, uint256 value) internal {
213         uint l = userTanks[user].length;
214 
215         for(uint i=0; i<l; i++){
216             if(userTanks[user][i] == value){
217                 delete userTanks[user][i];
218                 userTanks[user][i] = userTanks[user][l-1];
219                 userTanks[user].length = l-1;
220                 return;
221             }
222         }
223     }
224 
225     // USER FUNCTIONS
226 
227     function withdraw (uint256 _amount) public payable {
228         // validity checks
229         require (_amount >= 0); 
230         require (this.balance >= _amount); 
231         require (balances[msg.sender] >= _amount); 
232         
233         // return everything is withdrawing 0
234         if (_amount == 0){
235             _amount = balances[msg.sender];
236         }
237         
238         require(msg.sender.send(_amount));
239         balances[msg.sender] -= _amount; 
240         
241         EventWithdraw (msg.sender, _amount);
242     }
243     
244     
245     function auctionTank (uint _tankID, uint _startPrice, uint _endPrice, uint256 _duration) public {
246         require (_tankID > 0 && _tankID < newTankID);
247         require (tanks[_tankID].tankOwner == msg.sender);
248         require (!tanks[_tankID].inBattle);
249         require (!tanks[_tankID].inAuction);
250         require (tanks[_tankID].currAuction == 0);
251         require (_startPrice >= _endPrice);
252         require (_startPrice > 0 && _endPrice >= 0);
253         require (_duration > 0);
254         
255         auctions[newAuctionID] = AuctionObject(_tankID, _startPrice, _endPrice, now, _duration, true);
256         tanks[_tankID].inAuction = true;
257         tanks[_tankID].currAuction = newAuctionID;
258         
259         newAuctionID++;
260 
261         EventAuction (msg.sender, _tankID, _startPrice, _endPrice, _duration, now);
262     }
263     
264     // buy tank from auction
265     function bid (uint256 _tankID) public payable {
266         // validity checks
267         require (_tankID > 0 && _tankID < newTankID); // check if tank is valid
268         require (tanks[_tankID].inAuction == true); // check if tank is currently in auction
269         
270         
271         uint256 auctionID = tanks[_tankID].currAuction;
272         uint256 currPrice = getCurrAuctionPriceAuctionID(auctionID);
273         
274         require (currPrice >= 0); 
275         require (msg.value >= currPrice); 
276         
277         if(msg.value > currPrice){
278             balances[msg.sender] += (msg.value - currPrice);
279         }
280 
281 
282         // calculate new balances
283         uint256 fee = (currPrice*feeAmt) / 100; 
284 
285         //update tournamentAmt
286         uint256 tournamentTax = (fee*tournamentTaxRate) / 100;
287         tournamentAmt += tournamentTax;
288     
289         balances[tanks[_tankID].tankOwner] += currPrice - fee;
290         balances[owner] += (fee - tournamentTax); 
291 
292         // update object fields
293         address formerOwner = tanks[_tankID].tankOwner;
294 
295         tanks[_tankID].tankOwner = msg.sender;
296         tanks[_tankID].inAuction = false; 
297         auctions[tanks[_tankID].currAuction].alive = false; 
298         tanks[_tankID].currAuction = 0; 
299 
300         // update userTanks
301         userTanks[msg.sender].push(_tankID);
302         delTankFromUser(formerOwner, _tankID);
303 
304         EventBid (_tankID, msg.sender);
305     }
306     
307     function cancelAuction (uint256 _tankID) public {
308         require (_tankID > 0 && _tankID < newTankID); 
309         require (tanks[_tankID].inAuction); 
310         require (tanks[_tankID].tankOwner == msg.sender); 
311         
312         // update tank object
313         tanks[_tankID].inAuction = false; 
314         auctions[tanks[_tankID].currAuction].alive = false; 
315         tanks[_tankID].currAuction = 0; 
316 
317         EventCancelAuction (_tankID, msg.sender);
318     }
319 
320     function buyTank (uint32 _typeID) public payable {
321         require(_typeID > 0 && _typeID < newTypeID);
322         require (baseTanks[_typeID].currPrice > 0 && msg.value > 0); 
323         require (msg.value >= baseTanks[_typeID].currPrice); 
324         
325         if (msg.value > baseTanks[_typeID].currPrice){
326             balances[msg.sender] += msg.value - baseTanks[_typeID].currPrice;
327         }
328         
329         baseTanks[_typeID].currPrice += baseTanks[_typeID].earnings;
330         
331         uint256 earningsIndex = baseTanks[_typeID].numTanks + 1;
332         baseTanks[_typeID].numTanks += 1;
333 
334         tanks[newTankID++] = TankObject ({
335             typeID : _typeID,
336             upgrades : [0,0,0,0],
337             exp: 0,
338             next: 0,
339             inBattle : false,
340             tankOwner : msg.sender,
341             earningsIndex : earningsIndex,
342             inAuction : false,
343             currAuction : 0
344         });
345 
346         uint256 price = baseTanks[_typeID].startPrice;
347         uint256 tournamentProceeds = (price * tournamentTaxRate) / 100;
348 
349         balances[owner] += baseTanks[_typeID].startPrice - tournamentProceeds;
350         tournamentAmt += tournamentProceeds;
351 
352         userTanks[msg.sender].push(newTankID-1);
353         
354         EventBuyTank (msg.sender, _typeID, newTankID-1, baseTanks[_typeID].currPrice);
355     }
356 
357     //cashing out the money that a tank has earned
358     function cashOutTank (uint256 _tankID) public {
359         // validity checks
360         require (_tankID > 0 && _tankID < newTankID); 
361         require (tanks[_tankID].tankOwner == msg.sender);
362         require (!tanks[_tankID].inAuction && tanks[_tankID].currAuction == 0);
363         require (!tanks[_tankID].inBattle);
364 
365         
366         uint256 tankType = tanks[_tankID].typeID;
367         uint256 numTanks = baseTanks[tankType].numTanks;
368 
369         uint256 amount = getCashOutAmount(_tankID);
370 
371         require (this.balance >= amount); 
372         require (amount > 0);
373         
374         require(tanks[_tankID].tankOwner.send(amount));
375         tanks[_tankID].earningsIndex = numTanks;
376         
377         EventCashOutTank (msg.sender, amount);
378     }
379     
380     // 0 -> health, 1 -> attack, 2 -> armor, 3 -> speed
381     function upgradeTank (uint256 _tankID, uint8 _upgradeChoice) public payable {
382         // validity checks
383         require (_tankID > 0 && _tankID < newTankID); 
384         require (tanks[_tankID].tankOwner == msg.sender); 
385         require (!tanks[_tankID].inAuction);
386         require (!tanks[_tankID].inBattle);
387         require (_upgradeChoice >= 0 && _upgradeChoice < 4); 
388         
389         // no overflow!
390         require(tanks[_tankID].upgrades[_upgradeChoice] + 1 > tanks[_tankID].upgrades[_upgradeChoice]);
391 
392         uint256 upgradePrice = baseTanks[tanks[_tankID].typeID].startPrice / 4;
393         require (msg.value >= upgradePrice); 
394 
395         tanks[_tankID].upgrades[_upgradeChoice]++; 
396 
397         if(msg.value > upgradePrice){
398             balances[msg.sender] += msg.value-upgradePrice; 
399         }
400 
401         uint256 tournamentProceeds = (upgradePrice * tournamentTaxRate) / 100;
402 
403         balances[owner] += (upgradePrice - tournamentProceeds); 
404         tournamentAmt += tournamentProceeds;
405         
406         EventUpgradeTank (msg.sender, _tankID, _upgradeChoice);
407     }
408 
409     function battle(uint256 _tankID) public payable {
410         require(_tankID >0 && _tankID < newTankID);
411         require(tanks[_tankID].tankOwner == msg.sender);
412         require(!tanks[_tankID].inAuction);
413         require(!tanks[_tankID].inBattle);
414         require(msg.value >= battleFee);
415 
416         if(msg.value > battleFee){
417             balances[msg.sender] += (msg.value - battleFee);
418         }
419 
420         tournamentAmt += battleFee;
421         
422         EventJoinedBattle(msg.sender, _tankID);
423 
424         // upgrade from exp
425         if(tanks[_tankID].exp == 5){
426             tanks[_tankID].upgrades[tanks[_tankID].next++]++;
427             tanks[_tankID].exp = 0;
428             if(tanks[_tankID].next == 4){
429                 tanks[_tankID].next = 0;
430             }
431         }
432 
433         // add to teams
434         if(battleTeams.length < 2*teamSize - 1){
435             battleTeams.push(_tankID);
436             tanks[_tankID].inBattle = true;
437 
438         // time to battle!
439         } else {
440             battleTeams.push(_tankID);
441 
442             uint256[4] memory teamA;
443             uint256[4] memory teamB;
444             uint256[4] memory temp;
445 
446             for(uint i=0; i<teamSize; i++){
447                 temp = getCurrentStats(battleTeams[i]);
448                 teamA[0] += temp[0];
449                 teamA[1] += temp[1];
450                 teamA[2] += temp[2];
451                 teamA[3] += temp[3];
452 
453                 temp = getCurrentStats(battleTeams[teamSize+i]);
454                 teamB[0] += temp[0];
455                 teamB[1] += temp[1];
456                 teamB[2] += temp[2];
457                 teamB[3] += temp[3];
458             }
459 
460             // lower score is better
461             uint256 diffA = teamA[1] - teamB[2];
462             uint256 diffB = teamB[1] - teamA[2];
463             
464             diffA = diffA > 0 ? diffA : 1;
465             diffB = diffB > 0 ? diffB : 1;
466 
467             uint256 teamAScore = teamB[0] / (diffA * teamA[3]);
468             uint256 teamBScore = teamA[0] / (diffB * teamB[3]);
469 
470             if((teamB[0] % (diffA * teamA[3])) != 0) {
471                 teamAScore += 1;
472             }
473 
474             if((teamA[0] % (diffB * teamB[3])) != 0) {
475                 teamBScore += 1;
476             }
477 
478             uint256 toDistribute = tournamentAmt / teamSize;
479             tournamentAmt -= teamSize*toDistribute;
480 
481             if(teamAScore <= teamBScore){
482                 for(i=0; i<teamSize; i++){
483                     balances[tanks[battleTeams[i]].tankOwner] += toDistribute;   
484                 }
485             } else {
486                 for(i=0; i<teamSize; i++){
487                     balances[tanks[battleTeams[teamSize+i]].tankOwner] += toDistribute;   
488                 }
489                    
490             }
491 
492             for(i=0; i<2*teamSize; i++){
493                 tanks[battleTeams[i]].inBattle = false;
494                 tanks[battleTeams[i]].exp++;
495             }
496 
497             EventBattleOver();
498 
499             battleTeams.length = 0;
500         }
501     }
502 
503     function quitBattle(uint256 _tankID) public {
504         require(_tankID >0 && _tankID < newTankID);
505         require(tanks[_tankID].tankOwner == msg.sender);
506         require(tanks[_tankID].inBattle);
507         
508         uint l = battleTeams.length;
509 
510         for(uint i=0; i<l; i++){
511             if(battleTeams[i] == _tankID){
512                 EventQuitBattle(msg.sender, _tankID);
513 
514                 delete battleTeams[i];
515                 battleTeams[i] = battleTeams[l-1];
516                 battleTeams.length = l-1;
517                 tanks[_tankID].inBattle = false;
518 
519                 return;
520             }
521         }
522     }
523 
524     // CONVENIENCE GETTER METHODS
525     
526     function getCurrAuctionPriceTankID (uint256 _tankID) public constant returns (uint256 price){
527         require (tanks[_tankID].inAuction);
528         uint256 auctionID = tanks[_tankID].currAuction;
529 
530         return getCurrAuctionPriceAuctionID(auctionID);
531     }
532     
533     function getPlayerBalance(address _playerID) public constant returns (uint256 balance){
534         return balances[_playerID];
535     }
536     
537     function getContractBalance() public constant isOwner returns (uint256){
538         return this.balance;
539     }
540 
541     function getTankOwner(uint256 _tankID) public constant returns (address) {
542         require(_tankID > 0 && _tankID < newTankID);
543         return tanks[_tankID].tankOwner;
544     }
545 
546     function getOwnedTanks(address _add) public constant returns (uint256[]){
547         return userTanks[_add];
548     }
549 
550     function getTankType(uint256 _tankID) public constant returns (uint256) {
551         require(_tankID > 0 && _tankID < newTankID);
552         return tanks[_tankID].typeID;
553     }
554 
555     function getCurrTypePrice(uint256 _typeID) public constant returns (uint256) {
556         require(_typeID > 0 && _typeID < newTypeID);
557         return baseTanks[_typeID].currPrice;
558     }
559 
560     function getNumTanksType(uint256 _typeID) public constant returns (uint256) {
561         require(_typeID > 0 && _typeID < newTypeID);
562         return baseTanks[_typeID].numTanks;
563     }
564     
565     function getNumTanks() public constant returns(uint256){
566         return newTankID-1;
567     }
568 
569     function checkTankAuction(uint256 _tankID) public constant returns (bool) {
570         require(0 < _tankID && _tankID < newTankID);
571         return tanks[_tankID].inAuction;
572     }
573 
574     function getCurrAuctionPriceAuctionID(uint256 _auctionID) public constant returns (uint256){
575         require(_auctionID > 0 && _auctionID < newAuctionID);
576 
577         AuctionObject memory currAuction = auctions[_auctionID];
578 
579         // calculate the current auction price       
580         uint256 currPrice = currAuction.startPrice;
581         uint256 diff = ((currAuction.startPrice-currAuction.endPrice) / (currAuction.duration)) * (now-currAuction.startTime);
582 
583 
584         if (currPrice-diff < currAuction.endPrice || diff > currPrice){ 
585             currPrice = currAuction.endPrice;  
586         } else {
587             currPrice -= diff;
588         }
589 
590         return currPrice;
591     }
592 
593     // returns [tankID, currPrice, alive]
594     function getAuction(uint256 _auctionID) public constant returns (uint256[3]){
595         require(_auctionID > 0 && _auctionID < newAuctionID);
596 
597         uint256 tankID = auctions[_auctionID].tank;
598         uint256 currPrice = getCurrAuctionPriceAuctionID(_auctionID);
599         bool alive = auctions[_auctionID].alive;
600 
601         uint256[3] memory out;
602         out[0] = tankID;
603         out[1] = currPrice;
604         out[2] = alive ? 1 : 0;
605 
606         return out;
607     }
608  
609     function getUpgradePrice(uint256 _tankID) public constant returns (uint256) {
610         require(_tankID >0 && _tankID < newTankID);
611         return baseTanks[tanks[_tankID].typeID].startPrice / 4;
612     }
613 
614     // [health, attack, armor, speed]
615     function getUpgradeAmt(uint256 _tankID) public constant returns (uint8[4]) {
616         require(_tankID > 0 && _tankID < newTankID);
617 
618         return tanks[_tankID].upgrades;
619     }
620 
621     // [health, attack, armor, speed]
622     function getCurrentStats(uint256 _tankID) public constant returns (uint256[4]) {
623         require(_tankID > 0 && _tankID < newTankID);
624 
625         TankType memory baseType = baseTanks[tanks[_tankID].typeID];
626         uint8[4] memory upgrades = tanks[_tankID].upgrades;
627         uint256[4] memory out;
628 
629         out[0] = baseType.baseHealth + (upgrades[0] * baseType.baseHealth / 4);
630         out[1] = baseType.baseAttack + upgrades[1]; 
631         out[2] = baseType.baseArmor + upgrades[2];
632         out[3] = baseType.baseSpeed + upgrades[3];
633         
634         return out;
635     }
636 
637     function inBattle(uint256 _tankID) public constant returns (bool) {
638         require(_tankID > 0 && _tankID < newTankID);
639         return tanks[_tankID].inBattle;
640     }
641 
642     function getCurrTeamSizes() public constant returns (uint) {
643         return battleTeams.length;
644     }
645 
646     function getBattleTeamSize() public constant returns (uint8) {
647         return teamSize;
648     }
649 
650     function donate() public payable {
651         require(msg.value > 0);
652         tournamentAmt += msg.value;
653     }
654 
655     function getTournamentAmt() public constant returns (uint256) {
656         return tournamentAmt;
657     }
658 
659     function getBattleFee() public constant returns (uint256){
660         return battleFee;
661     }
662 
663     function getTournamentRate() public constant returns (uint8){
664         return tournamentTaxRate;
665     }
666 
667     function getCurrFeeRate() public constant returns (uint8) {
668         return feeAmt;
669     }
670     
671     // [startPrice, currPrice, earnings, baseHealth, baseAttack, baseArmor, baseSpeed, numTanks] 
672     function getBaseTypeStats(uint256 _typeID) public constant returns (uint256[8]){
673         require(0 < _typeID && _typeID < newTypeID);
674         uint256[8] memory out;
675 
676         out[0] = baseTanks[_typeID].startPrice;
677         out[1] = baseTanks[_typeID].currPrice;
678         out[2] = baseTanks[_typeID].earnings;
679         out[3] = baseTanks[_typeID].baseHealth;
680         out[4] = baseTanks[_typeID].baseAttack;
681         out[5] = baseTanks[_typeID].baseArmor;
682         out[6] = baseTanks[_typeID].baseSpeed;
683         out[7] = baseTanks[_typeID].numTanks;
684 
685         return out;
686     }
687 
688     function getCashOutAmount(uint256 _tankID) public constant returns (uint256) {
689         require(0 < _tankID && _tankID < newTankID);
690 
691         uint256 tankType = tanks[_tankID].typeID;
692         uint256 earnings = baseTanks[tankType].earnings;
693         uint256 earningsIndex = tanks[_tankID].earningsIndex;
694         uint256 numTanks = baseTanks[tankType].numTanks;
695 
696         return earnings * (numTanks - earningsIndex);
697     }
698 
699     // returns [exp, next]
700     function getExp(uint256 _tankID) public constant returns (uint8[2]){
701         require(0<_tankID && _tankID < newTankID);
702 
703         uint8[2] memory out;
704         out[0] = tanks[_tankID].exp;
705         out[1] = tanks[_tankID].next;
706 
707         return out;
708     }
709 }