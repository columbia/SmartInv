1 /* ==================================================================== */
2 /* Copyright (c) 2018 The CryptoRacing Project.  All rights reserved.
3 /* 
4 /*   The first idle car race game of blockchain                 
5 /* ==================================================================== */
6 pragma solidity ^0.4.20;
7 
8 interface ERC20 {
9     function totalSupply() public view returns (uint);
10     function balanceOf(address tokenOwner) public view returns (uint balance);
11     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
12     function transfer(address to, uint tokens) public returns (bool success);
13     function approve(address spender, uint tokens) public returns (bool success);
14     function transferFrom(address from, address to, uint tokens) public returns (bool success);
15 
16     event Transfer(address indexed from, address indexed to, uint tokens);
17     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
18 }
19 
20 // RaceCoin - Crypto Idle Raceing Game
21 // https://cryptoracing.online
22 
23 
24 contract AccessAdmin {
25     bool public isPaused = false;
26     address public addrAdmin;  
27 
28     event AdminTransferred(address indexed preAdmin, address indexed newAdmin);
29 
30     function AccessAdmin() public {
31         addrAdmin = msg.sender;
32     }  
33 
34 
35     modifier onlyAdmin() {
36         require(msg.sender == addrAdmin);
37         _;
38     }
39 
40     modifier whenNotPaused() {
41         require(!isPaused);
42         _;
43     }
44 
45     modifier whenPaused {
46         require(isPaused);
47         _;
48     }
49 
50     function setAdmin(address _newAdmin) external onlyAdmin {
51         require(_newAdmin != address(0));
52         emit AdminTransferred(addrAdmin, _newAdmin);
53         addrAdmin = _newAdmin;
54     }
55 
56     function doPause() external onlyAdmin whenNotPaused {
57         isPaused = true;
58     }
59 
60     function doUnpause() external onlyAdmin whenPaused {
61         isPaused = false;
62     }
63 }
64 
65 
66 interface IRaceCoin {
67     function addTotalEtherPool(uint256 amount) external;
68     function addPlayerToList(address player) external;
69     function increasePlayersAttribute(address player, uint16[13] param) external;
70     function reducePlayersAttribute(address player, uint16[13] param) external;
71 }
72 
73 contract RaceCoin is ERC20, AccessAdmin, IRaceCoin {
74 
75     using SafeMath for uint256;
76 
77     string public constant name  = "Race Coin";
78     string public constant symbol = "Coin";
79     uint8 public constant decimals = 0;
80     uint256 private roughSupply;
81     uint256 public totalRaceCoinProduction;
82    
83     //Daily match fun dividend ratio
84     uint256 public bonusMatchFunPercent = 10;
85 
86     //Daily off-line dividend ratio
87     uint256 public bonusOffLinePercent = 10;
88 
89     //Recommendation ratio
90     uint256 constant refererPercent = 5;
91 
92     
93 
94     address[] public playerList;
95     //Verifying whether duplication is repeated
96    // mapping(address => uint256) public isProduction;
97 
98 
99     uint256 public totalEtherPool; // Eth dividends to be split between players' race coin production
100     uint256[] private totalRaceCoinProductionSnapshots; // The total race coin production for each prior day past
101     uint256[] private allocatedProductionSnapshots; // The amount of EHT that can be allocated daily
102     uint256[] private allocatedRaceCoinSnapshots; // The amount of EHT that can be allocated daily
103     uint256[] private totalRaceCoinSnapshots; // The total race coin for each prior day past
104     uint256 public nextSnapshotTime;
105 
106 
107 
108     // Balances for each player
109     mapping(address => uint256) private ethBalance;
110     mapping(address => uint256) private raceCoinBalance;
111     mapping(address => uint256) private refererDivsBalance;
112 
113     mapping(address => uint256) private productionBaseValue; //Player production base value
114     mapping(address => uint256) private productionMultiplier; //Player production multiplier
115 
116     mapping(address => uint256) private attackBaseValue; //Player attack base value
117     mapping(address => uint256) private attackMultiplier; //Player attack multiplier
118     mapping(address => uint256) private attackPower; //Player attack Power
119 
120     mapping(address => uint256) private defendBaseValue; //Player defend base value
121     mapping(address => uint256) private defendMultiplier; //Player defend multiplier
122     mapping(address => uint256) private defendPower; //Player defend Power
123 
124     mapping(address => uint256) private plunderBaseValue; //Player plunder base value
125     mapping(address => uint256) private plunderMultiplier; //Player plunder multiplier
126     mapping(address => uint256) private plunderPower; //Player plunder Power
127 
128 
129 
130 
131     mapping(address => mapping(uint256 => uint256)) private raceCoinProductionSnapshots; // Store player's race coin production for given day (snapshot)
132     mapping(address => mapping(uint256 => bool)) private raceCoinProductionZeroedSnapshots; // This isn't great but we need know difference between 0 production and an unused/inactive day.
133     mapping(address => mapping(uint256 => uint256)) private raceCoinSnapshots;// Store player's race coin for given day (snapshot)
134 
135 
136 
137     mapping(address => uint256) private lastRaceCoinSaveTime; // Seconds (last time player claimed their produced race coin)
138     mapping(address => uint256) public lastRaceCoinProductionUpdate; // Days (last snapshot player updated their production)
139     mapping(address => uint256) private lastProductionFundClaim; // Days (snapshot number)
140     mapping(address => uint256) private lastRaceCoinFundClaim; // Days (snapshot number)
141     mapping(address => uint256) private battleCooldown; // If user attacks they cannot attack again for short time
142 
143 
144     // Computational correlation
145 
146 
147     // Mapping of approved ERC20 transfers (by player)
148     mapping(address => mapping(address => uint256)) private allowed;
149 
150 
151     event ReferalGain(address referal, address player, uint256 amount);
152     event PlayerAttacked(address attacker, address target, bool success, uint256 raceCoinPlunder);
153 
154 
155      /// @dev Trust contract
156     mapping (address => bool) actionContracts;
157 
158     function setActionContract(address _actionAddr, bool _useful) external onlyAdmin {
159         actionContracts[_actionAddr] = _useful;
160     }
161 
162     function getActionContract(address _actionAddr) external view onlyAdmin returns(bool) {
163         return actionContracts[_actionAddr];
164     }
165     
166    
167 
168 
169     function RaceCoin() public {
170         addrAdmin = msg.sender;
171         totalRaceCoinSnapshots.push(0);
172     }
173     
174 
175     function() external payable {
176 
177     }
178 
179 
180     function beginGame(uint256 firstDivsTime) external onlyAdmin {
181         nextSnapshotTime = firstDivsTime;  
182     }
183 
184 
185      // We will adjust to achieve a balance.
186     function adjustDailyMatchFunDividends(uint256 newBonusPercent) external onlyAdmin whenNotPaused {
187 
188         require(newBonusPercent > 0 && newBonusPercent <= 80);
189        
190         bonusMatchFunPercent = newBonusPercent;
191 
192     }
193 
194      // We will adjust to achieve a balance.
195     function adjustDailyOffLineDividends(uint256 newBonusPercent) external onlyAdmin whenNotPaused {
196 
197         require(newBonusPercent > 0 && newBonusPercent <= 80);
198        
199         bonusOffLinePercent = newBonusPercent;
200 
201     }
202 
203     // Stored race coin (rough supply as it ignores earned/unclaimed RaceCoin)
204     function totalSupply() public view returns(uint256) {
205         return roughSupply; 
206     }
207 
208 
209     function balanceOf(address player) public view returns(uint256) {
210         return raceCoinBalance[player] + balanceOfUnclaimedRaceCoin(player);
211     }
212 
213     function raceCionBalance(address player) public view returns(uint256) {
214         return raceCoinBalance[player];
215     }
216 
217 
218     function balanceOfUnclaimedRaceCoin(address player) internal view returns (uint256) {
219         uint256 lastSave = lastRaceCoinSaveTime[player];
220         if (lastSave > 0 && lastSave < block.timestamp) {
221             return (getRaceCoinProduction(player) * (block.timestamp - lastSave)) / 100;
222         }
223         return 0;
224     }
225 
226 
227     function getRaceCoinProduction(address player) public view returns (uint256){
228         return raceCoinProductionSnapshots[player][lastRaceCoinProductionUpdate[player]];
229     }
230 
231 
232     function etherBalanceOf(address player) public view returns(uint256) {
233         return ethBalance[player];
234     }
235 
236 
237     function transfer(address recipient, uint256 amount) public returns (bool) {
238         updatePlayersRaceCoin(msg.sender);
239         require(amount <= raceCoinBalance[msg.sender]);
240         
241         raceCoinBalance[msg.sender] -= amount;
242         raceCoinBalance[recipient] += amount;
243         
244         emit Transfer(msg.sender, recipient, amount);
245         return true;
246     }
247 
248     function transferFrom(address player, address recipient, uint256 amount) public returns (bool) {
249         updatePlayersRaceCoin(player);
250         require(amount <= allowed[player][msg.sender] && amount <= raceCoinBalance[player]);
251         
252         raceCoinBalance[player] -= amount;
253         raceCoinBalance[recipient] += amount;
254         allowed[player][msg.sender] -= amount;
255         
256         emit Transfer(player, recipient, amount);
257         return true;
258     }
259 
260 
261     function approve(address approvee, uint256 amount) public returns (bool){
262         allowed[msg.sender][approvee] = amount;
263         emit Approval(msg.sender, approvee, amount);
264         return true;
265     }
266 
267     function allowance(address player, address approvee) public view returns(uint256){
268         return allowed[player][approvee];
269     }
270 
271 
272     function addPlayerToList(address player) external{
273         
274         require(actionContracts[msg.sender]);
275         require(player != address(0));
276 
277         bool b = false;
278 
279         //Judge whether or not to repeat
280         for (uint256 i = 0; i < playerList.length; i++) {
281             if(playerList[i] == player){
282                b = true;
283                break;
284             }
285         } 
286 
287         if(!b){
288             playerList.push(player);
289         }   
290     }
291 
292 
293     function getPlayerList() external view returns ( address[] ){
294         return playerList;
295     }
296 
297 
298 
299 
300 
301     function updatePlayersRaceCoin(address player) internal {
302         uint256 raceCoinGain = balanceOfUnclaimedRaceCoin(player);
303         lastRaceCoinSaveTime[player] = block.timestamp;
304         roughSupply += raceCoinGain;
305         raceCoinBalance[player] += raceCoinGain;
306     }
307 
308     //Increase attribute
309     function increasePlayersAttribute(address player, uint16[13] param) external{
310 
311 
312         require(actionContracts[msg.sender]);
313         require(player != address(0));
314 
315 
316         //Production
317         updatePlayersRaceCoin(player);
318         uint256 increase;
319         uint256 newProduction;
320         uint256 previousProduction;
321 
322         previousProduction = getRaceCoinProduction(player);
323 
324         productionBaseValue[player] = productionBaseValue[player].add(param[3]);
325         productionMultiplier[player] = productionMultiplier[player].add(param[7]);
326 
327         newProduction = productionBaseValue[player].mul(100 + productionMultiplier[player]).div(100);
328 
329         increase = newProduction.sub(previousProduction);
330 
331         raceCoinProductionSnapshots[player][allocatedProductionSnapshots.length] = newProduction;
332         lastRaceCoinProductionUpdate[player] = allocatedProductionSnapshots.length;
333         totalRaceCoinProduction += increase;
334 
335 
336 
337 
338         //Attack
339         attackBaseValue[player] = attackBaseValue[player].add(param[4]);
340         attackMultiplier[player] = attackMultiplier[player].add(param[8]);
341         attackPower[player] = attackBaseValue[player].mul(100 + attackMultiplier[player]).div(100);
342 
343 
344         //Defend
345         defendBaseValue[player] = defendBaseValue[player].add(param[5]);
346         defendMultiplier[player] = defendMultiplier[player].add(param[9]);
347         defendPower[player] = defendBaseValue[player].mul(100 + defendMultiplier[player]).div(100);
348 
349 
350         //Plunder
351         plunderBaseValue[player] = plunderBaseValue[player].add(param[6]);
352         plunderMultiplier[player] = plunderMultiplier[player].add(param[10]);
353 
354         plunderPower[player] = plunderBaseValue[player].mul(100 + plunderMultiplier[player]).div(100);
355 
356 
357     }
358 
359 
360     //Reduce attribute
361     function reducePlayersAttribute(address player, uint16[13] param) external{
362 
363         require(actionContracts[msg.sender]);
364         require(player != address(0));
365 
366 
367         //Production
368         updatePlayersRaceCoin(player);
369 
370 
371         uint256 decrease;
372         uint256 newProduction;
373         uint256 previousProduction;
374 
375 
376         previousProduction = getRaceCoinProduction(player);
377 
378         productionBaseValue[player] = productionBaseValue[player].sub(param[3]);
379         productionMultiplier[player] = productionMultiplier[player].sub(param[7]);
380 
381         newProduction = productionBaseValue[player].mul(100 + productionMultiplier[player]).div(100);
382 
383         decrease = previousProduction.sub(newProduction);
384         
385         if (newProduction == 0) { // Special case which tangles with "inactive day" snapshots (claiming divs)
386             raceCoinProductionZeroedSnapshots[player][allocatedProductionSnapshots.length] = true;
387             delete raceCoinProductionSnapshots[player][allocatedProductionSnapshots.length]; // 0
388         } else {
389             raceCoinProductionSnapshots[player][allocatedProductionSnapshots.length] = newProduction;
390         }
391         
392         lastRaceCoinProductionUpdate[player] = allocatedProductionSnapshots.length;
393         totalRaceCoinProduction -= decrease;
394 
395 
396 
397 
398         //Attack
399         attackBaseValue[player] = attackBaseValue[player].sub(param[4]);
400         attackMultiplier[player] = attackMultiplier[player].sub(param[8]);
401         attackPower[player] = attackBaseValue[player].mul(100 + attackMultiplier[player]).div(100);
402 
403 
404         //Defend
405         defendBaseValue[player] = defendBaseValue[player].sub(param[5]);
406         defendMultiplier[player] = defendMultiplier[player].sub(param[9]);
407         defendPower[player] = defendBaseValue[player].mul(100 + defendMultiplier[player]).div(100);
408 
409 
410         //Plunder
411         plunderBaseValue[player] = plunderBaseValue[player].sub(param[6]);
412         plunderMultiplier[player] = plunderMultiplier[player].sub(param[10]);
413         plunderPower[player] = plunderBaseValue[player].mul(100 + plunderMultiplier[player]).div(100);
414 
415 
416     }
417 
418 
419     function attackPlayer(address player,address target) external {
420         require(battleCooldown[player] < block.timestamp);
421         require(target != player);
422         require(balanceOf(target) > 0);
423         
424         uint256 attackerAttackPower = attackPower[player];
425         uint256 attackerplunderPower = plunderPower[player];
426         uint256 defenderDefendPower = defendPower[target];
427         
428 
429         if (battleCooldown[target] > block.timestamp) { // When on battle cooldown, the defense is reduced by 50%
430             defenderDefendPower = defenderDefendPower.div(2);
431         }
432         
433         if (attackerAttackPower > defenderDefendPower) {
434             battleCooldown[player] = block.timestamp + 30 minutes;
435             if (balanceOf(target) > attackerplunderPower) {
436                
437                 uint256 unclaimedRaceCoin = balanceOfUnclaimedRaceCoin(target);
438                 if (attackerplunderPower > unclaimedRaceCoin) {
439                     uint256 raceCoinDecrease = attackerplunderPower - unclaimedRaceCoin;
440                     raceCoinBalance[target] -= raceCoinDecrease;
441                     roughSupply -= raceCoinDecrease;
442                 } else {
443                     uint256 raceCoinGain = unclaimedRaceCoin - attackerplunderPower;
444                     raceCoinBalance[target] += raceCoinGain;
445                     roughSupply += raceCoinGain;
446                 }
447                 raceCoinBalance[player] += attackerplunderPower;
448                 emit PlayerAttacked(player, target, true, attackerplunderPower);
449             } else {
450                 emit PlayerAttacked(player, target, true, balanceOf(target));
451                 raceCoinBalance[player] += balanceOf(target);
452                 raceCoinBalance[target] = 0;
453             }
454             
455             lastRaceCoinSaveTime[target] = block.timestamp;
456         
457            
458         } else {
459             battleCooldown[player] = block.timestamp + 10 minutes;
460             emit PlayerAttacked(player, target, false, 0);
461         }
462     }
463 
464 
465 
466     function getPlayersBattleStats(address player) external view returns (uint256, uint256, uint256, uint256){
467 
468         return (attackPower[player], defendPower[player], plunderPower[player], battleCooldown[player]);
469     }
470 
471 
472     function getPlayersBaseAttributesInt(address player) external view returns (uint256, uint256, uint256, uint256){
473         return (productionBaseValue[player], attackBaseValue[player], defendBaseValue[player], plunderBaseValue[player]); 
474     }
475     
476     function getPlayersAttributesInt(address player) external view returns (uint256, uint256, uint256, uint256){
477         return (getRaceCoinProduction(player), attackPower[player], defendPower[player], plunderPower[player]); 
478     }
479 
480 
481     function getPlayersAttributesMult(address player) external view returns (uint256, uint256, uint256, uint256){
482         return (productionMultiplier[player], attackMultiplier[player], defendMultiplier[player], plunderMultiplier[player]);
483     }
484     
485 
486     function withdrawEther(uint256 amount) external {
487         require(amount <= ethBalance[msg.sender]);
488         ethBalance[msg.sender] -= amount;
489         msg.sender.transfer(amount);
490     }
491 
492 
493     function getBalance() external view returns(uint256) {
494         return totalEtherPool;
495     }
496 
497 
498     function addTotalEtherPool(uint256 amount) external{
499         require(actionContracts[msg.sender]);
500         require(amount > 0);
501         totalEtherPool += amount;
502     }
503 
504     function correctPool(uint256 _count) external onlyAdmin {
505         require( _count > 0);
506         totalEtherPool += _count;
507     }
508 
509 
510     // To display 
511     function getGameInfo(address player) external view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256){
512            
513         return ( totalEtherPool, totalRaceCoinProduction,nextSnapshotTime, balanceOf(player), ethBalance[player], 
514                     getRaceCoinProduction(player),raceCoinBalance[player]);
515     }
516 
517     function getMatchFunInfo(address player) external view returns (uint256, uint256){
518         return (raceCoinSnapshots[player][totalRaceCoinSnapshots.length - 1], 
519         totalRaceCoinSnapshots[totalRaceCoinSnapshots.length - 1]);
520     }
521 
522 
523     function getGameCurrTime(address player) external view returns (uint256){
524         return block.timestamp;
525     }
526 
527 
528     function claimOffLineDividends(address referer, uint256 startSnapshot, uint256 endSnapShot) external {
529         require(startSnapshot <= endSnapShot);
530         require(startSnapshot >= lastProductionFundClaim[msg.sender]);
531         require(endSnapShot < allocatedProductionSnapshots.length);
532 
533         uint256 offLineShare;
534         uint256 previousProduction = raceCoinProductionSnapshots[msg.sender][lastProductionFundClaim[msg.sender] - 1]; 
535         for (uint256 i = startSnapshot; i <= endSnapShot; i++) {
536             
537             uint256 productionDuringSnapshot = raceCoinProductionSnapshots[msg.sender][i];
538             bool soldAllProduction = raceCoinProductionZeroedSnapshots[msg.sender][i];
539             if (productionDuringSnapshot == 0 && !soldAllProduction) {
540                 productionDuringSnapshot = previousProduction;
541             } else {
542                previousProduction = productionDuringSnapshot;
543             }
544             
545             offLineShare += (allocatedProductionSnapshots[i] * productionDuringSnapshot) / totalRaceCoinProductionSnapshots[i];
546         }
547         
548         
549         if (raceCoinProductionSnapshots[msg.sender][endSnapShot] == 0 && !raceCoinProductionZeroedSnapshots[msg.sender][endSnapShot] && previousProduction > 0) {
550             raceCoinProductionSnapshots[msg.sender][endSnapShot] = previousProduction; // Checkpoint for next claim
551         }
552         
553         lastProductionFundClaim[msg.sender] = endSnapShot + 1;
554         
555        
556         uint256 referalDivs;
557         if (referer != address(0) && referer != msg.sender) {
558             referalDivs = offLineShare.mul(refererPercent).div(100); // 5%
559             ethBalance[referer] += referalDivs;
560             refererDivsBalance[referer] += referalDivs;
561             emit ReferalGain(referer, msg.sender, referalDivs);
562         }
563 
564 
565         
566         ethBalance[msg.sender] += offLineShare - referalDivs;
567     }
568 
569 
570     // To display on website
571     function viewOffLineDividends(address player) external view returns (uint256, uint256, uint256) {
572         uint256 startSnapshot = lastProductionFundClaim[player];
573         uint256 latestSnapshot = allocatedProductionSnapshots.length - 1; 
574         
575         uint256 offLineShare;
576         uint256 previousProduction = raceCoinProductionSnapshots[player][lastProductionFundClaim[player] - 1];
577         for (uint256 i = startSnapshot; i <= latestSnapshot; i++) {
578             
579             uint256 productionDuringSnapshot = raceCoinProductionSnapshots[player][i];
580             bool soldAllProduction = raceCoinProductionZeroedSnapshots[player][i];
581             if (productionDuringSnapshot == 0 && !soldAllProduction) {
582                 productionDuringSnapshot = previousProduction;
583             } else {
584                previousProduction = productionDuringSnapshot;
585             }
586             
587             offLineShare += (allocatedProductionSnapshots[i] * productionDuringSnapshot) / totalRaceCoinProductionSnapshots[i];
588         }
589         return (offLineShare, startSnapshot, latestSnapshot);
590     }
591 
592    
593 
594 
595 
596     function claimRaceCoinDividends(address referer, uint256 startSnapshot, uint256 endSnapShot) external {
597         require(startSnapshot <= endSnapShot);
598         require(startSnapshot >= lastRaceCoinFundClaim[msg.sender]);
599         require(endSnapShot < allocatedRaceCoinSnapshots.length);
600         
601         uint256 dividendsShare;
602 
603 
604         for (uint256 i = startSnapshot; i <= endSnapShot; i++) {
605 
606             dividendsShare += (allocatedRaceCoinSnapshots[i] * raceCoinSnapshots[msg.sender][i]) / (totalRaceCoinSnapshots[i] + 1);
607         }
608 
609         
610         lastRaceCoinFundClaim[msg.sender] = endSnapShot + 1;
611         
612         uint256 referalDivs;
613         if (referer != address(0) && referer != msg.sender) {
614             referalDivs = dividendsShare.mul(refererPercent).div(100); // 5%
615             ethBalance[referer] += referalDivs;
616             refererDivsBalance[referer] += referalDivs;
617             emit ReferalGain(referer, msg.sender, referalDivs);
618         }
619         
620         ethBalance[msg.sender] += dividendsShare - referalDivs;
621     }
622 
623     // To display 
624     function viewUnclaimedRaceCoinDividends(address player) external view returns (uint256, uint256, uint256) {
625         uint256 startSnapshot = lastRaceCoinFundClaim[player];
626         uint256 latestSnapshot = allocatedRaceCoinSnapshots.length - 1; // No snapshots to begin with
627         
628         uint256 dividendsShare;
629         
630         for (uint256 i = startSnapshot; i <= latestSnapshot; i++) {
631 
632             dividendsShare += (allocatedRaceCoinSnapshots[i] * raceCoinSnapshots[player][i]) / (totalRaceCoinSnapshots[i] + 1);
633         }
634 
635         return (dividendsShare, startSnapshot, latestSnapshot);
636     }
637 
638 
639     function getRefererDivsBalance(address player)  external view returns (uint256){
640         return refererDivsBalance[player];
641     }
642 
643 
644     function updatePlayersRaceCoinFromPurchase(address player, uint256 purchaseCost) internal {
645         uint256 unclaimedRaceCoin = balanceOfUnclaimedRaceCoin(player);
646         
647         if (purchaseCost > unclaimedRaceCoin) {
648             uint256 raceCoinDecrease = purchaseCost - unclaimedRaceCoin;
649             require(raceCoinBalance[player] >= raceCoinDecrease);
650             roughSupply -= raceCoinDecrease;
651             raceCoinBalance[player] -= raceCoinDecrease;
652         } else {
653             uint256 raceCoinGain = unclaimedRaceCoin - purchaseCost;
654             roughSupply += raceCoinGain;
655             raceCoinBalance[player] += raceCoinGain;
656         }
657         
658         lastRaceCoinSaveTime[player] = block.timestamp;
659     }
660 
661 
662     function fundRaceCoinDeposit(uint256 amount) external {
663         updatePlayersRaceCoinFromPurchase(msg.sender, amount);
664         raceCoinSnapshots[msg.sender][totalRaceCoinSnapshots.length - 1] += amount;
665         totalRaceCoinSnapshots[totalRaceCoinSnapshots.length - 1] += amount;
666     }
667 
668 
669 
670     // Allocate  divs for the day (00:00 cron job)
671     function snapshotDailyRaceCoinFunding() external onlyAdmin whenNotPaused {
672        
673         uint256 todaysRaceCoinFund = (totalEtherPool * bonusMatchFunPercent) / 100; // 10% of pool daily
674         uint256 todaysOffLineFund = (totalEtherPool * bonusOffLinePercent) / 100; // 10% of pool daily
675 
676         if(totalRaceCoinSnapshots[totalRaceCoinSnapshots.length - 1] > 0){
677             totalEtherPool -= todaysRaceCoinFund;
678         }
679 
680         totalEtherPool -= todaysOffLineFund;
681 
682 
683         totalRaceCoinSnapshots.push(0);
684         allocatedRaceCoinSnapshots.push(todaysRaceCoinFund);
685         
686         totalRaceCoinProductionSnapshots.push(totalRaceCoinProduction);
687         allocatedProductionSnapshots.push(todaysOffLineFund);
688         
689         nextSnapshotTime = block.timestamp + 24 hours;
690     }
691 
692 }
693 
694 library SafeMath {
695 
696   /**
697   * @dev Multiplies two numbers, throws on overflow.
698   */
699   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
700     if (a == 0) {
701       return 0;
702     }
703     uint256 c = a * b;
704     assert(c / a == b);
705     return c;
706   }
707 
708   /**
709   * @dev Integer division of two numbers, truncating the quotient.
710   */
711   function div(uint256 a, uint256 b) internal pure returns (uint256) {
712     // assert(b > 0); // Solidity automatically throws when dividing by 0
713     uint256 c = a / b;
714     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
715     return c;
716   }
717 
718   /**
719   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
720   */
721   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
722     assert(b <= a);
723     return a - b;
724   }
725 
726   /**
727   * @dev Adds two numbers, throws on overflow.
728   */
729   function add(uint256 a, uint256 b) internal pure returns (uint256) {
730     uint256 c = a + b;
731     assert(c >= a);
732     return c;
733   }
734 }