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
83     //Daily dividend ratio
84     uint256 public bonusDivPercent = 20;
85 
86     //Recommendation ratio
87     uint256 constant refererPercent = 5;
88 
89     
90 
91     address[] public playerList;
92     //Verifying whether duplication is repeated
93    // mapping(address => uint256) public isProduction;
94 
95 
96     uint256 public totalEtherPool; // Eth dividends to be split between players' race coin production
97     uint256[] private totalRaceCoinProductionSnapshots; // The total race coin production for each prior day past
98     uint256[] private allocatedRaceCoinSnapshots; // The amount of EHT that can be allocated daily
99     uint256[] private totalRaceCoinSnapshots; // The total race coin for each prior day past
100     uint256 public nextSnapshotTime;
101 
102 
103 
104     // Balances for each player
105     mapping(address => uint256) private ethBalance;
106     mapping(address => uint256) private raceCoinBalance;
107     mapping(address => uint256) private refererDivsBalance;
108 
109     mapping(address => uint256) private productionBaseValue; //Player production base value
110     mapping(address => uint256) private productionMultiplier; //Player production multiplier
111 
112     mapping(address => uint256) private attackBaseValue; //Player attack base value
113     mapping(address => uint256) private attackMultiplier; //Player attack multiplier
114     mapping(address => uint256) private attackPower; //Player attack Power
115 
116     mapping(address => uint256) private defendBaseValue; //Player defend base value
117     mapping(address => uint256) private defendMultiplier; //Player defend multiplier
118     mapping(address => uint256) private defendPower; //Player defend Power
119 
120     mapping(address => uint256) private plunderBaseValue; //Player plunder base value
121     mapping(address => uint256) private plunderMultiplier; //Player plunder multiplier
122     mapping(address => uint256) private plunderPower; //Player plunder Power
123 
124 
125 
126 
127     mapping(address => mapping(uint256 => uint256)) private raceCoinProductionSnapshots; // Store player's race coin production for given day (snapshot)
128     mapping(address => mapping(uint256 => bool)) private raceCoinProductionZeroedSnapshots; // This isn't great but we need know difference between 0 production and an unused/inactive day.
129     mapping(address => mapping(uint256 => uint256)) private raceCoinSnapshots;// Store player's race coin for given day (snapshot)
130 
131 
132 
133     mapping(address => uint256) private lastRaceCoinSaveTime; // Seconds (last time player claimed their produced race coin)
134     mapping(address => uint256) public lastRaceCoinProductionUpdate; // Days (last snapshot player updated their production)
135     mapping(address => uint256) private lastRaceCoinFundClaim; // Days (snapshot number)
136     mapping(address => uint256) private battleCooldown; // If user attacks they cannot attack again for short time
137 
138 
139     // Computational correlation
140 
141 
142     // Mapping of approved ERC20 transfers (by player)
143     mapping(address => mapping(address => uint256)) private allowed;
144 
145 
146     event ReferalGain(address referal, address player, uint256 amount);
147     event PlayerAttacked(address attacker, address target, bool success, uint256 raceCoinPlunder);
148 
149 
150      /// @dev Trust contract
151     mapping (address => bool) actionContracts;
152 
153     function setActionContract(address _actionAddr, bool _useful) external onlyAdmin {
154         actionContracts[_actionAddr] = _useful;
155     }
156 
157     function getActionContract(address _actionAddr) external view onlyAdmin returns(bool) {
158         return actionContracts[_actionAddr];
159     }
160     
161    
162 
163 
164     function RaceCoin() public {
165         addrAdmin = msg.sender;
166     }
167     
168 
169     function() external payable {
170 
171     }
172 
173 
174     function beginWork(uint256 firstDivsTime) external onlyAdmin {
175 
176         nextSnapshotTime = firstDivsTime;
177     }
178 
179 
180      // We will adjust to achieve a balance.
181     function adjustDailyDividends(uint256 newBonusPercent) external onlyAdmin whenNotPaused {
182 
183         require(newBonusPercent > 0 && newBonusPercent <= 80);
184        
185         bonusDivPercent = newBonusPercent;
186 
187     }
188 
189     // Stored race coin (rough supply as it ignores earned/unclaimed RaceCoin)
190     function totalSupply() public view returns(uint256) {
191         return roughSupply; 
192     }
193 
194 
195     function balanceOf(address player) public view returns(uint256) {
196         return raceCoinBalance[player] + balanceOfUnclaimedRaceCoin(player);
197     }
198 
199 
200     function balanceOfUnclaimedRaceCoin(address player) internal view returns (uint256) {
201         uint256 lastSave = lastRaceCoinSaveTime[player];
202         if (lastSave > 0 && lastSave < block.timestamp) {
203             return (getRaceCoinProduction(player) * (block.timestamp - lastSave)) / 100;
204         }
205         return 0;
206     }
207 
208 
209     function getRaceCoinProduction(address player) public view returns (uint256){
210         return raceCoinProductionSnapshots[player][lastRaceCoinProductionUpdate[player]];
211     }
212 
213 
214     function etherBalanceOf(address player) public view returns(uint256) {
215         return ethBalance[player];
216     }
217 
218 
219     function transfer(address recipient, uint256 amount) public returns (bool) {
220         updatePlayersRaceCoin(msg.sender);
221         require(amount <= raceCoinBalance[msg.sender]);
222         
223         raceCoinBalance[msg.sender] -= amount;
224         raceCoinBalance[recipient] += amount;
225         
226         emit Transfer(msg.sender, recipient, amount);
227         return true;
228     }
229 
230     function transferFrom(address player, address recipient, uint256 amount) public returns (bool) {
231         updatePlayersRaceCoin(player);
232         require(amount <= allowed[player][msg.sender] && amount <= raceCoinBalance[player]);
233         
234         raceCoinBalance[player] -= amount;
235         raceCoinBalance[recipient] += amount;
236         allowed[player][msg.sender] -= amount;
237         
238         emit Transfer(player, recipient, amount);
239         return true;
240     }
241 
242 
243     function approve(address approvee, uint256 amount) public returns (bool){
244         allowed[msg.sender][approvee] = amount;
245         emit Approval(msg.sender, approvee, amount);
246         return true;
247     }
248 
249     function allowance(address player, address approvee) public view returns(uint256){
250         return allowed[player][approvee];
251     }
252 
253 
254     function addPlayerToList(address player) external{
255         
256         require(actionContracts[msg.sender]);
257         require(player != address(0));
258 
259         bool b = false;
260 
261         //Judge whether or not to repeat
262         for (uint256 i = 0; i < playerList.length; i++) {
263             if(playerList[i] == player){
264                b = true;
265                break;
266             }
267         } 
268 
269         if(!b){
270             playerList.push(player);
271         }   
272     }
273 
274 
275     function getPlayerList() external view returns ( address[] ){
276         return playerList;
277     }
278 
279 
280 
281 
282 
283     function updatePlayersRaceCoin(address player) internal {
284         uint256 raceCoinGain = balanceOfUnclaimedRaceCoin(player);
285         lastRaceCoinSaveTime[player] = block.timestamp;
286         roughSupply += raceCoinGain;
287         raceCoinBalance[player] += raceCoinGain;
288     }
289 
290     //Increase attribute
291     function increasePlayersAttribute(address player, uint16[13] param) external{
292 
293 
294         require(actionContracts[msg.sender]);
295         require(player != address(0));
296 
297 
298         //Production
299         updatePlayersRaceCoin(player);
300         uint256 increase;
301         uint256 newProduction;
302         uint256 previousProduction;
303 
304         previousProduction = getRaceCoinProduction(player);
305 
306         productionBaseValue[player] = productionBaseValue[player].add(param[3]);
307         productionMultiplier[player] = productionMultiplier[player].add(param[7]);
308 
309         newProduction = productionBaseValue[player].mul(100 + productionMultiplier[player]).div(100);
310 
311         increase = newProduction.sub(previousProduction);
312 
313         raceCoinProductionSnapshots[player][allocatedRaceCoinSnapshots.length] = newProduction;
314         lastRaceCoinProductionUpdate[player] = allocatedRaceCoinSnapshots.length;
315         totalRaceCoinProduction += increase;
316 
317 
318 
319 
320         //Attack
321         attackBaseValue[player] = attackBaseValue[player].add(param[4]);
322         attackMultiplier[player] = attackMultiplier[player].add(param[8]);
323         attackPower[player] = attackBaseValue[player].mul(100 + attackMultiplier[player]).div(100);
324 
325 
326         //Defend
327         defendBaseValue[player] = defendBaseValue[player].add(param[5]);
328         defendMultiplier[player] = defendMultiplier[player].add(param[9]);
329         defendPower[player] = defendBaseValue[player].mul(100 + defendMultiplier[player]).div(100);
330 
331 
332         //Plunder
333         plunderBaseValue[player] = plunderBaseValue[player].add(param[6]);
334         plunderMultiplier[player] = plunderMultiplier[player].add(param[10]);
335 
336         plunderPower[player] = plunderBaseValue[player].mul(100 + plunderMultiplier[player]).div(100);
337 
338 
339     }
340 
341 
342     //Reduce attribute
343     function reducePlayersAttribute(address player, uint16[13] param) external{
344 
345         require(actionContracts[msg.sender]);
346         require(player != address(0));
347 
348 
349         //Production
350         updatePlayersRaceCoin(player);
351 
352 
353         uint256 decrease;
354         uint256 newProduction;
355         uint256 previousProduction;
356 
357 
358         previousProduction = getRaceCoinProduction(player);
359 
360         productionBaseValue[player] = productionBaseValue[player].sub(param[3]);
361         productionMultiplier[player] = productionMultiplier[player].sub(param[7]);
362 
363         newProduction = productionBaseValue[player].mul(100 + productionMultiplier[player]).div(100);
364 
365         decrease = previousProduction.sub(newProduction);
366         
367         if (newProduction == 0) { // Special case which tangles with "inactive day" snapshots (claiming divs)
368             raceCoinProductionZeroedSnapshots[player][allocatedRaceCoinSnapshots.length] = true;
369             delete raceCoinProductionSnapshots[player][allocatedRaceCoinSnapshots.length]; // 0
370         } else {
371             raceCoinProductionSnapshots[player][allocatedRaceCoinSnapshots.length] = newProduction;
372         }
373         
374         lastRaceCoinProductionUpdate[player] = allocatedRaceCoinSnapshots.length;
375         totalRaceCoinProduction -= decrease;
376 
377 
378 
379 
380         //Attack
381         attackBaseValue[player] = attackBaseValue[player].sub(param[4]);
382         attackMultiplier[player] = attackMultiplier[player].sub(param[8]);
383         attackPower[player] = attackBaseValue[player].mul(100 + attackMultiplier[player]).div(100);
384 
385 
386         //Defend
387         defendBaseValue[player] = defendBaseValue[player].sub(param[5]);
388         defendMultiplier[player] = defendMultiplier[player].sub(param[9]);
389         defendPower[player] = defendBaseValue[player].mul(100 + defendMultiplier[player]).div(100);
390 
391 
392         //Plunder
393         plunderBaseValue[player] = plunderBaseValue[player].sub(param[6]);
394         plunderMultiplier[player] = plunderMultiplier[player].sub(param[10]);
395         plunderPower[player] = plunderBaseValue[player].mul(100 + plunderMultiplier[player]).div(100);
396 
397 
398     }
399 
400 
401     function attackPlayer(address player,address target) external {
402         require(battleCooldown[player] < block.timestamp);
403         require(target != player);
404 
405         updatePlayersRaceCoin(target);
406         require(balanceOf(target) > 0);
407         
408         uint256 attackerAttackPower = attackPower[player];
409         uint256 attackerplunderPower = plunderPower[player];
410         uint256 defenderDefendPower = defendPower[target];
411         
412 
413         if (battleCooldown[target] > block.timestamp) { // When on battle cooldown, the defense is reduced by 50%
414             defenderDefendPower = defenderDefendPower.div(2);
415         }
416         
417         if (attackerAttackPower > defenderDefendPower) {
418             battleCooldown[player] = block.timestamp + 30 minutes;
419             if (balanceOf(target) > attackerplunderPower) {
420                
421                 uint256 unclaimedRaceCoin = balanceOfUnclaimedRaceCoin(target);
422                 if (attackerplunderPower > unclaimedRaceCoin) {
423                     uint256 raceCoinDecrease = attackerplunderPower - unclaimedRaceCoin;
424                     raceCoinBalance[target] -= raceCoinDecrease;
425                     roughSupply -= raceCoinDecrease;
426                 } else {
427                     uint256 raceCoinGain = unclaimedRaceCoin - attackerplunderPower;
428                     raceCoinBalance[target] += raceCoinGain;
429                     roughSupply += raceCoinGain;
430                 }
431                 raceCoinBalance[player] += attackerplunderPower;
432                 emit PlayerAttacked(player, target, true, attackerplunderPower);
433             } else {
434                 emit PlayerAttacked(player, target, true, balanceOf(target));
435                 raceCoinBalance[player] += balanceOf(target);
436                 raceCoinBalance[target] = 0;
437             }
438             
439             lastRaceCoinSaveTime[target] = block.timestamp;
440             lastRaceCoinSaveTime[player] = block.timestamp;
441            
442         } else {
443             battleCooldown[player] = block.timestamp + 10 minutes;
444             emit PlayerAttacked(player, target, false, 0);
445         }
446     }
447 
448 
449 
450     function getPlayersBattleStats(address player) external view returns (uint256, uint256, uint256, uint256){
451 
452         return (attackPower[player], defendPower[player], plunderPower[player], battleCooldown[player]);
453     }
454 
455     
456     function getPlayersAttributesInt(address player) external view returns (uint256, uint256, uint256, uint256){
457         return (getRaceCoinProduction(player), attackPower[player], defendPower[player], plunderPower[player]); 
458     }
459 
460 
461     function getPlayersAttributesMult(address player) external view returns (uint256, uint256, uint256, uint256){
462         return (productionMultiplier[player], attackMultiplier[player], defendMultiplier[player], plunderMultiplier[player]);
463     }
464     
465 
466     function withdrawEther(uint256 amount) external {
467         require(amount <= ethBalance[msg.sender]);
468         ethBalance[msg.sender] -= amount;
469         msg.sender.transfer(amount);
470     }
471 
472 
473     function getBalance() external view returns(uint256) {
474         return totalEtherPool;
475     }
476 
477 
478     function addTotalEtherPool(uint256 amount) external{
479         require(amount > 0);
480         totalEtherPool += amount;
481     }
482 
483 
484     // To display 
485     function getGameInfo(address player) external view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256){
486        
487         return (block.timestamp, totalEtherPool, totalRaceCoinProduction,nextSnapshotTime, balanceOf(player), ethBalance[player], getRaceCoinProduction(player));
488     }
489 
490 
491    
492 
493 
494 
495     function claimRaceCoinDividends(address referer, uint256 startSnapshot, uint256 endSnapShot) external {
496         require(startSnapshot <= endSnapShot);
497         require(startSnapshot >= lastRaceCoinFundClaim[msg.sender]);
498         require(endSnapShot < allocatedRaceCoinSnapshots.length);
499         
500         uint256 dividendsShare;
501 
502 
503         for (uint256 i = startSnapshot; i <= endSnapShot; i++) {
504 
505             uint256 raceCoinDuringSnapshot = raceCoinSnapshots[msg.sender][i];
506 
507             dividendsShare += (allocatedRaceCoinSnapshots[i] * raceCoinDuringSnapshot) / totalRaceCoinSnapshots[i];
508         }
509 
510         
511         lastRaceCoinFundClaim[msg.sender] = endSnapShot + 1;
512         
513         uint256 referalDivs;
514         if (referer != address(0) && referer != msg.sender) {
515             referalDivs = dividendsShare.mul(refererPercent).div(100); // 5%
516             ethBalance[referer] += referalDivs;
517             refererDivsBalance[referer] += referalDivs;
518             emit ReferalGain(referer, msg.sender, referalDivs);
519         }
520         
521         ethBalance[msg.sender] += dividendsShare - referalDivs;
522     }
523 
524     // To display 
525     function viewUnclaimedRaceCoinDividends(address player) external view returns (uint256, uint256, uint256) {
526         uint256 startSnapshot = lastRaceCoinFundClaim[player];
527         uint256 latestSnapshot = allocatedRaceCoinSnapshots.length - 1; // No snapshots to begin with
528         
529         uint256 dividendsShare;
530         
531         for (uint256 i = startSnapshot; i <= latestSnapshot; i++) {
532 
533             uint256 raceCoinDuringSnapshot = raceCoinSnapshots[player][i];
534 
535             dividendsShare += (allocatedRaceCoinSnapshots[i] * raceCoinDuringSnapshot) / totalRaceCoinSnapshots[i];
536         }
537 
538         return (dividendsShare, startSnapshot, latestSnapshot);
539     }
540 
541 
542     function getRefererDivsBalance(address player)  external view returns (uint256){
543         return refererDivsBalance[player];
544     }
545 
546 
547 
548     // Allocate  divs for the day (00:00 cron job)
549     function snapshotDailyRaceCoinFunding() external onlyAdmin whenNotPaused {
550        
551         uint256 todaysRaceCoinFund = (totalEtherPool * bonusDivPercent) / 100; // 20% of pool daily
552         totalEtherPool -= todaysRaceCoinFund;
553         
554         totalRaceCoinProductionSnapshots.push(totalRaceCoinProduction);
555         allocatedRaceCoinSnapshots.push(todaysRaceCoinFund);
556         nextSnapshotTime = block.timestamp + 24 hours;
557 
558         
559         for (uint256 i = 0; i < playerList.length; i++) {
560             updatePlayersRaceCoin(playerList[i]);
561             raceCoinSnapshots[playerList[i]][lastRaceCoinProductionUpdate[playerList[i]]] = raceCoinBalance[playerList[i]];
562         } 
563         totalRaceCoinSnapshots.push(roughSupply);
564     }
565 
566 }
567 
568 library SafeMath {
569 
570   /**
571   * @dev Multiplies two numbers, throws on overflow.
572   */
573   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
574     if (a == 0) {
575       return 0;
576     }
577     uint256 c = a * b;
578     assert(c / a == b);
579     return c;
580   }
581 
582   /**
583   * @dev Integer division of two numbers, truncating the quotient.
584   */
585   function div(uint256 a, uint256 b) internal pure returns (uint256) {
586     // assert(b > 0); // Solidity automatically throws when dividing by 0
587     uint256 c = a / b;
588     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
589     return c;
590   }
591 
592   /**
593   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
594   */
595   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
596     assert(b <= a);
597     return a - b;
598   }
599 
600   /**
601   * @dev Adds two numbers, throws on overflow.
602   */
603   function add(uint256 a, uint256 b) internal pure returns (uint256) {
604     uint256 c = a + b;
605     assert(c >= a);
606     return c;
607   }
608 }