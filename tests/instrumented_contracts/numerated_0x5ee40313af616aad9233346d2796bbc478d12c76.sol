1 pragma solidity ^0.4.18;
2 /* ==================================================================== */
3 /* Copyright (c) 2018 The MagicAcademy Project.  All rights reserved.
4 /* 
5 /* https://www.magicacademy.io One of the world's first idle strategy games of blockchain 
6 /*  
7 /* authors rainy@livestar.com/Jony.Fu@livestar.com
8 /*                 
9 /* ==================================================================== */
10 /**
11  * @title Ownable
12  * @dev The Ownable contract has an owner address, and provides basic authorization control
13  * functions, this simplifies the implementation of "user permissions".
14  */
15 contract Ownable {
16   address public owner;
17 
18   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20   /*
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   function Ownable() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to transfer control of the contract to a newOwner.
38    * @param newOwner The address to transfer ownership to.
39    */
40   function transferOwnership(address newOwner) public onlyOwner {
41     require(newOwner != address(0));
42     OwnershipTransferred(owner, newOwner);
43     owner = newOwner;
44   }
45 }
46 
47 contract AccessAdmin is Ownable {
48 
49   /// @dev Admin Address
50   mapping (address => bool) adminContracts;
51 
52   /// @dev Trust contract
53   mapping (address => bool) actionContracts;
54 
55   function setAdminContract(address _addr, bool _useful) public onlyOwner {
56     require(_addr != address(0));
57     adminContracts[_addr] = _useful;
58   }
59 
60   modifier onlyAdmin {
61     require(adminContracts[msg.sender]); 
62     _;
63   }
64 
65   function setActionContract(address _actionAddr, bool _useful) public onlyAdmin {
66     actionContracts[_actionAddr] = _useful;
67   }
68 
69   modifier onlyAccess() {
70     require(actionContracts[msg.sender]);
71     _;
72   }
73 }
74 
75 interface ERC20 {
76     function totalSupply() public constant returns (uint);
77     function balanceOf(address tokenOwner) public constant returns (uint balance);
78     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
79     function transfer(address to, uint tokens) public returns (bool success);
80     function approve(address spender, uint tokens) public returns (bool success);
81     function transferFrom(address from, address to, uint tokens) public returns (bool success);
82     event Transfer(address indexed from, address indexed to, uint tokens);
83     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
84 }
85 
86 contract JadeCoin is ERC20, AccessAdmin {
87   using SafeMath for SafeMath;
88   string public constant name  = "MAGICACADEMY JADE";
89   string public constant symbol = "Jade";
90   uint8 public constant decimals = 0;
91   uint256 public roughSupply;
92   uint256 public totalJadeProduction;
93 
94   uint256[] public totalJadeProductionSnapshots; // The total goo production for each prior day past
95      
96   uint256 public nextSnapshotTime;
97   uint256 public researchDivPercent = 10;
98 
99   // Balances for each player
100   mapping(address => uint256) public jadeBalance;
101   mapping(address => mapping(uint8 => uint256)) public coinBalance;
102   mapping(uint8 => uint256) totalEtherPool; //Total Pool
103   
104   mapping(address => mapping(uint256 => uint256)) public jadeProductionSnapshots; // Store player's jade production for given day (snapshot)
105  
106   mapping(address => mapping(uint256 => bool)) private jadeProductionZeroedSnapshots; // This isn't great but we need know difference between 0 production and an unused/inactive day.
107     
108   mapping(address => uint256) public lastJadeSaveTime; // Seconds (last time player claimed their produced jade)
109   mapping(address => uint256) public lastJadeProductionUpdate; // Days (last snapshot player updated their production)
110   mapping(address => uint256) private lastJadeResearchFundClaim; // Days (snapshot number)
111   
112   mapping(address => uint256) private lastJadeDepositFundClaim; // Days (snapshot number)
113   uint256[] private allocatedJadeResearchSnapshots; // Div pot #1 (research eth allocated to each prior day past)
114 
115   // Mapping of approved ERC20 transfers (by player)
116   mapping(address => mapping(address => uint256)) private allowed;
117 
118   event ReferalGain(address player, address referal, uint256 amount);
119 
120   // Constructor
121   function JadeCoin() public {
122   }
123 
124   function() external payable {
125     totalEtherPool[1] += msg.value;
126   }
127 
128   // Incase community prefers goo deposit payments over production %, can be tweaked for balance
129   function tweakDailyDividends(uint256 newResearchPercent) external {
130     require(msg.sender == owner);
131     require(newResearchPercent > 0 && newResearchPercent <= 10);
132         
133     researchDivPercent = newResearchPercent;
134   }
135 
136   function totalSupply() public constant returns(uint256) {
137     return roughSupply; // Stored jade (rough supply as it ignores earned/unclaimed jade)
138   }
139   /// balance of jade in-game
140   function balanceOf(address player) public constant returns(uint256) {
141     return SafeMath.add(jadeBalance[player],balanceOfUnclaimed(player));
142   }
143 
144   /// unclaimed jade
145   function balanceOfUnclaimed(address player) public constant returns (uint256) {
146     uint256 lSave = lastJadeSaveTime[player];
147     if (lSave > 0 && lSave < block.timestamp) { 
148       return SafeMath.mul(getJadeProduction(player),SafeMath.div(SafeMath.sub(block.timestamp,lSave),100));
149     }
150     return 0;
151   }
152 
153   /// production/s
154   function getJadeProduction(address player) public constant returns (uint256){
155     return jadeProductionSnapshots[player][lastJadeProductionUpdate[player]];
156   }
157 
158   /// return totalJadeProduction/s
159   function getTotalJadeProduction() external view returns (uint256) {
160     return totalJadeProduction;
161   }
162 
163   function getlastJadeProductionUpdate(address player) public view returns (uint256) {
164     return lastJadeProductionUpdate[player];
165   }
166     /// increase prodution 
167   function increasePlayersJadeProduction(address player, uint256 increase) public onlyAccess {
168     jadeProductionSnapshots[player][allocatedJadeResearchSnapshots.length] = SafeMath.add(getJadeProduction(player),increase);
169     lastJadeProductionUpdate[player] = allocatedJadeResearchSnapshots.length;
170     totalJadeProduction = SafeMath.add(totalJadeProduction,increase);
171   }
172 
173   /// reduce production  20180702
174   function reducePlayersJadeProduction(address player, uint256 decrease) public onlyAccess {
175     uint256 previousProduction = getJadeProduction(player);
176     uint256 newProduction = SafeMath.sub(previousProduction, decrease);
177 
178     if (newProduction == 0) { 
179       jadeProductionZeroedSnapshots[player][allocatedJadeResearchSnapshots.length] = true;
180       delete jadeProductionSnapshots[player][allocatedJadeResearchSnapshots.length]; // 0
181     } else {
182       jadeProductionSnapshots[player][allocatedJadeResearchSnapshots.length] = newProduction;
183     }   
184     lastJadeProductionUpdate[player] = allocatedJadeResearchSnapshots.length;
185     totalJadeProduction = SafeMath.sub(totalJadeProduction,decrease);
186   }
187 
188   /// update player's jade balance
189   function updatePlayersCoin(address player) internal {
190     uint256 coinGain = balanceOfUnclaimed(player);
191     lastJadeSaveTime[player] = block.timestamp;
192     roughSupply = SafeMath.add(roughSupply,coinGain);  
193     jadeBalance[player] = SafeMath.add(jadeBalance[player],coinGain);  
194   }
195 
196   /// update player's jade balance
197   function updatePlayersCoinByOut(address player) external onlyAccess {
198     uint256 coinGain = balanceOfUnclaimed(player);
199     lastJadeSaveTime[player] = block.timestamp;
200     roughSupply = SafeMath.add(roughSupply,coinGain);  
201     jadeBalance[player] = SafeMath.add(jadeBalance[player],coinGain);  
202   }
203   /// transfer
204   function transfer(address recipient, uint256 amount) public returns (bool) {
205     updatePlayersCoin(msg.sender);
206     require(amount <= jadeBalance[msg.sender]);
207     jadeBalance[msg.sender] = SafeMath.sub(jadeBalance[msg.sender],amount);
208     jadeBalance[recipient] = SafeMath.add(jadeBalance[recipient],amount);
209     //event
210     Transfer(msg.sender, recipient, amount);
211     return true;
212   }
213   /// transferfrom
214   function transferFrom(address player, address recipient, uint256 amount) public returns (bool) {
215     updatePlayersCoin(player);
216     require(amount <= allowed[player][msg.sender] && amount <= jadeBalance[player]);
217         
218     jadeBalance[player] = SafeMath.sub(jadeBalance[player],amount); 
219     jadeBalance[recipient] = SafeMath.add(jadeBalance[recipient],amount); 
220     allowed[player][msg.sender] = SafeMath.sub(allowed[player][msg.sender],amount); 
221         
222     Transfer(player, recipient, amount);  
223     return true;
224   }
225   
226   function approve(address approvee, uint256 amount) public returns (bool) {
227     allowed[msg.sender][approvee] = amount;  
228     Approval(msg.sender, approvee, amount);
229     return true;
230   }
231   
232   function allowance(address player, address approvee) public constant returns(uint256) {
233     return allowed[player][approvee];  
234   }
235   
236   /// update Jade via purchase
237   function updatePlayersCoinByPurchase(address player, uint256 purchaseCost) public onlyAccess {
238     uint256 unclaimedJade = balanceOfUnclaimed(player);
239         
240     if (purchaseCost > unclaimedJade) {
241       uint256 jadeDecrease = SafeMath.sub(purchaseCost, unclaimedJade);
242       require(jadeBalance[player] >= jadeDecrease);
243       roughSupply = SafeMath.sub(roughSupply,jadeDecrease);
244       jadeBalance[player] = SafeMath.sub(jadeBalance[player],jadeDecrease);
245     } else {
246       uint256 jadeGain = SafeMath.sub(unclaimedJade,purchaseCost);
247       roughSupply = SafeMath.add(roughSupply,jadeGain);
248       jadeBalance[player] = SafeMath.add(jadeBalance[player],jadeGain);
249     }
250         
251     lastJadeSaveTime[player] = block.timestamp;
252   }
253 
254   function JadeCoinMining(address _addr, uint256 _amount) external onlyAdmin {
255     roughSupply = SafeMath.add(roughSupply,_amount);
256     jadeBalance[_addr] = SafeMath.add(jadeBalance[_addr],_amount);
257   }
258 
259   function setRoughSupply(uint256 iroughSupply) external onlyAccess {
260     roughSupply = SafeMath.add(roughSupply,iroughSupply);
261   }
262   /// balance of coin  in-game
263   function coinBalanceOf(address player,uint8 itype) external constant returns(uint256) {
264     return coinBalance[player][itype];
265   }
266 
267   function setJadeCoin(address player, uint256 coin, bool iflag) external onlyAccess {
268     if (iflag) {
269       jadeBalance[player] = SafeMath.add(jadeBalance[player],coin);
270     } else if (!iflag) {
271       jadeBalance[player] = SafeMath.sub(jadeBalance[player],coin);
272     }
273   }
274   
275   function setCoinBalance(address player, uint256 eth, uint8 itype, bool iflag) external onlyAccess {
276     if (iflag) {
277       coinBalance[player][itype] = SafeMath.add(coinBalance[player][itype],eth);
278     } else if (!iflag) {
279       coinBalance[player][itype] = SafeMath.sub(coinBalance[player][itype],eth);
280     }
281   }
282 
283   function setLastJadeSaveTime(address player) external onlyAccess {
284     lastJadeSaveTime[player] = block.timestamp;
285   }
286 
287   function setTotalEtherPool(uint256 inEth, uint8 itype, bool iflag) external onlyAccess {
288     if (iflag) {
289       totalEtherPool[itype] = SafeMath.add(totalEtherPool[itype],inEth);
290      } else if (!iflag) {
291       totalEtherPool[itype] = SafeMath.sub(totalEtherPool[itype],inEth);
292     }
293   }
294 
295   function getTotalEtherPool(uint8 itype) external view returns (uint256) {
296     return totalEtherPool[itype];
297   }
298 
299   function setJadeCoinZero(address player) external onlyAccess {
300     jadeBalance[player]=0;
301   }
302 
303   function getNextSnapshotTime() external view returns(uint256) {
304     return nextSnapshotTime;
305   }
306   
307   // To display on website
308   function viewUnclaimedResearchDividends() external constant returns (uint256, uint256, uint256) {
309     uint256 startSnapshot = lastJadeResearchFundClaim[msg.sender];
310     uint256 latestSnapshot = allocatedJadeResearchSnapshots.length - 1; // No snapshots to begin with
311         
312     uint256 researchShare;
313     uint256 previousProduction = jadeProductionSnapshots[msg.sender][lastJadeResearchFundClaim[msg.sender] - 1]; // Underflow won't be a problem as gooProductionSnapshots[][0xfffffffffffff] = 0;
314     for (uint256 i = startSnapshot; i <= latestSnapshot; i++) {     
315     // Slightly complex things by accounting for days/snapshots when user made no tx's
316       uint256 productionDuringSnapshot = jadeProductionSnapshots[msg.sender][i];
317       bool soldAllProduction = jadeProductionZeroedSnapshots[msg.sender][i];
318       if (productionDuringSnapshot == 0 && !soldAllProduction) {
319         productionDuringSnapshot = previousProduction;
320       } else {
321         previousProduction = productionDuringSnapshot;
322     }
323             
324       researchShare += (allocatedJadeResearchSnapshots[i] * productionDuringSnapshot) / totalJadeProductionSnapshots[i];
325     }
326     return (researchShare, startSnapshot, latestSnapshot);
327   }
328       
329   function claimResearchDividends(address referer, uint256 startSnapshot, uint256 endSnapShot) external {
330     require(startSnapshot <= endSnapShot);
331     require(startSnapshot >= lastJadeResearchFundClaim[msg.sender]);
332     require(endSnapShot < allocatedJadeResearchSnapshots.length);
333         
334     uint256 researchShare;
335     uint256 previousProduction = jadeProductionSnapshots[msg.sender][lastJadeResearchFundClaim[msg.sender] - 1]; // Underflow won't be a problem as gooProductionSnapshots[][0xffffffffff] = 0;
336     for (uint256 i = startSnapshot; i <= endSnapShot; i++) {
337             
338     // Slightly complex things by accounting for days/snapshots when user made no tx's
339       uint256 productionDuringSnapshot = jadeProductionSnapshots[msg.sender][i];
340       bool soldAllProduction = jadeProductionZeroedSnapshots[msg.sender][i];
341       if (productionDuringSnapshot == 0 && !soldAllProduction) {
342         productionDuringSnapshot = previousProduction;
343       } else {
344         previousProduction = productionDuringSnapshot;
345       }
346             
347       researchShare += (allocatedJadeResearchSnapshots[i] * productionDuringSnapshot) / totalJadeProductionSnapshots[i];
348       }
349         
350         
351     if (jadeProductionSnapshots[msg.sender][endSnapShot] == 0 && !jadeProductionZeroedSnapshots[msg.sender][endSnapShot] && previousProduction > 0) {
352       jadeProductionSnapshots[msg.sender][endSnapShot] = previousProduction; // Checkpoint for next claim
353     }
354         
355     lastJadeResearchFundClaim[msg.sender] = endSnapShot + 1;
356         
357     uint256 referalDivs;
358     if (referer != address(0) && referer != msg.sender) {
359       referalDivs = researchShare / 100; // 1%
360       coinBalance[referer][1] += referalDivs;
361       ReferalGain(referer, msg.sender, referalDivs);
362     }
363     coinBalance[msg.sender][1] += SafeMath.sub(researchShare,referalDivs);
364   }    
365     
366   // Allocate pot divs for the day (00:00 cron job)
367   function snapshotDailyGooResearchFunding() external onlyAdmin {
368     uint256 todaysGooResearchFund = (totalEtherPool[1] * researchDivPercent) / 100; // 10% of pool daily
369     totalEtherPool[1] -= todaysGooResearchFund;
370         
371     totalJadeProductionSnapshots.push(totalJadeProduction);
372     allocatedJadeResearchSnapshots.push(todaysGooResearchFund);
373     nextSnapshotTime = block.timestamp + 24 hours;
374   }
375 }
376 
377 interface GameConfigInterface {
378   function productionCardIdRange() external constant returns (uint256, uint256);
379   function battleCardIdRange() external constant returns (uint256, uint256);
380   function upgradeIdRange() external constant returns (uint256, uint256);
381   function unitCoinProduction(uint256 cardId) external constant returns (uint256);
382   function unitAttack(uint256 cardId) external constant returns (uint256);
383   function unitDefense(uint256 cardId) external constant returns (uint256);
384   function unitStealingCapacity(uint256 cardId) external constant returns (uint256);
385 }
386 
387 contract CardsBase is JadeCoin {
388 
389   function CardsBase() public {
390     setAdminContract(msg.sender,true);
391     setActionContract(msg.sender,true);
392   }
393   // player  
394   struct Player {
395     address owneraddress;
396   }
397 
398   Player[] players;
399   bool gameStarted;
400   
401   GameConfigInterface public schema;
402 
403   // Stuff owned by each player
404   mapping(address => mapping(uint256 => uint256)) public unitsOwned;  //number of normal card
405   mapping(address => mapping(uint256 => uint256)) public upgradesOwned;  //Lv of upgrade card
406 
407   mapping(address => uint256) public uintsOwnerCount; // total number of cards
408   mapping(address=> mapping(uint256 => uint256)) public uintProduction;  //card's production 
409 
410   // Rares & Upgrades (Increase unit's production / attack etc.)
411   mapping(address => mapping(uint256 => uint256)) public unitCoinProductionIncreases; // Adds to the coin per second
412   mapping(address => mapping(uint256 => uint256)) public unitCoinProductionMultiplier; // Multiplies the coin per second
413   mapping(address => mapping(uint256 => uint256)) public unitAttackIncreases;
414   mapping(address => mapping(uint256 => uint256)) public unitAttackMultiplier;
415   mapping(address => mapping(uint256 => uint256)) public unitDefenseIncreases;
416   mapping(address => mapping(uint256 => uint256)) public unitDefenseMultiplier;
417   mapping(address => mapping(uint256 => uint256)) public unitJadeStealingIncreases;
418   mapping(address => mapping(uint256 => uint256)) public unitJadeStealingMultiplier;
419   mapping(address => mapping(uint256 => uint256)) private unitMaxCap; // external cap
420 
421   //setting configuration
422   function setConfigAddress(address _address) external onlyOwner {
423     schema = GameConfigInterface(_address);
424   }
425 
426 /// start game
427   function beginGame(uint256 firstDivsTime) external payable onlyOwner {
428     require(!gameStarted);
429     gameStarted = true;
430     nextSnapshotTime = firstDivsTime;
431     totalEtherPool[1] = msg.value;  // Seed pot 
432   }
433 
434   function endGame() external payable onlyOwner {
435     require(gameStarted);
436     gameStarted = false;
437   }
438 
439   function getGameStarted() external constant returns (bool) {
440     return gameStarted;
441   }
442   function AddPlayers(address _address) external onlyAccess { 
443     Player memory _player= Player({
444       owneraddress: _address
445     });
446     players.push(_player);
447   }
448 
449   /// @notice ranking of production
450   /// @notice rainysiu
451   function getRanking() external view returns (address[], uint256[],uint256[]) {
452     uint256 len = players.length;
453     uint256[] memory arr = new uint256[](len);
454     address[] memory arr_addr = new address[](len);
455     uint256[] memory arr_def = new uint256[](len);
456   
457     uint counter =0;
458     for (uint k=0;k<len; k++){
459       arr[counter] =  getJadeProduction(players[k].owneraddress);
460       arr_addr[counter] = players[k].owneraddress;
461       (,arr_def[counter],,) = getPlayersBattleStats(players[k].owneraddress);
462       counter++;
463     }
464 
465     for(uint i=0;i<len-1;i++) {
466       for(uint j=0;j<len-i-1;j++) {
467         if(arr[j]<arr[j+1]) {
468           uint256 temp = arr[j];
469           address temp_addr = arr_addr[j];
470           uint256 temp_def = arr_def[j];
471           arr[j] = arr[j+1];
472           arr[j+1] = temp;
473           arr_addr[j] = arr_addr[j+1];
474           arr_addr[j+1] = temp_addr;
475 
476           arr_def[j] = arr_def[j+1];
477           arr_def[j+1] = temp_def;
478         }
479       }
480     }
481     return (arr_addr,arr,arr_def);
482   }
483 
484   //total users
485   function getTotalUsers()  external view returns (uint256) {
486     return players.length;
487   }
488   function getMaxCap(address _addr,uint256 _cardId) external view returns (uint256) {
489     return unitMaxCap[_addr][_cardId];
490   }
491 
492   /// UnitsProuction
493   function getUnitsProduction(address player, uint256 unitId, uint256 amount) external constant returns (uint256) {
494     return (amount * (schema.unitCoinProduction(unitId) + unitCoinProductionIncreases[player][unitId]) * (10 + unitCoinProductionMultiplier[player][unitId])); 
495   } 
496 
497   /// one card's production
498   function getUnitsInProduction(address player, uint256 unitId, uint256 amount) external constant returns (uint256) {
499     return SafeMath.div(SafeMath.mul(amount,uintProduction[player][unitId]),unitsOwned[player][unitId]);
500   } 
501 
502   /// UnitsAttack
503   function getUnitsAttack(address player, uint256 unitId, uint256 amount) internal constant returns (uint256) {
504     return (amount * (schema.unitAttack(unitId) + unitAttackIncreases[player][unitId]) * (10 + unitAttackMultiplier[player][unitId])) / 10;
505   }
506   /// UnitsDefense
507   function getUnitsDefense(address player, uint256 unitId, uint256 amount) internal constant returns (uint256) {
508     return (amount * (schema.unitDefense(unitId) + unitDefenseIncreases[player][unitId]) * (10 + unitDefenseMultiplier[player][unitId])) / 10;
509   }
510   /// UnitsStealingCapacity
511   function getUnitsStealingCapacity(address player, uint256 unitId, uint256 amount) internal constant returns (uint256) {
512     return (amount * (schema.unitStealingCapacity(unitId) + unitJadeStealingIncreases[player][unitId]) * (10 + unitJadeStealingMultiplier[player][unitId])) / 10;
513   }
514  
515   // player's attacking & defending & stealing & battle power
516   function getPlayersBattleStats(address player) public constant returns (
517     uint256 attackingPower, 
518     uint256 defendingPower, 
519     uint256 stealingPower,
520     uint256 battlePower) {
521 
522     uint256 startId;
523     uint256 endId;
524     (startId, endId) = schema.battleCardIdRange();
525 
526     // Not ideal but will only be a small number of units (and saves gas when buying units)
527     while (startId <= endId) {
528       attackingPower = SafeMath.add(attackingPower,getUnitsAttack(player, startId, unitsOwned[player][startId]));
529       stealingPower = SafeMath.add(stealingPower,getUnitsStealingCapacity(player, startId, unitsOwned[player][startId]));
530       defendingPower = SafeMath.add(defendingPower,getUnitsDefense(player, startId, unitsOwned[player][startId]));
531       battlePower = SafeMath.add(attackingPower,defendingPower); 
532       startId++;
533     }
534   }
535 
536   // @nitice number of normal card
537   function getOwnedCount(address player, uint256 cardId) external view returns (uint256) {
538     return unitsOwned[player][cardId];
539   }
540   function setOwnedCount(address player, uint256 cardId, uint256 amount, bool iflag) external onlyAccess {
541     if (iflag) {
542       unitsOwned[player][cardId] = SafeMath.add(unitsOwned[player][cardId],amount);
543      } else if (!iflag) {
544       unitsOwned[player][cardId] = SafeMath.sub(unitsOwned[player][cardId],amount);
545     }
546   }
547 
548   // @notice Lv of upgrade card
549   function getUpgradesOwned(address player, uint256 upgradeId) external view returns (uint256) {
550     return upgradesOwned[player][upgradeId];
551   }
552   //set upgrade
553   function setUpgradesOwned(address player, uint256 upgradeId) external onlyAccess {
554     upgradesOwned[player][upgradeId] = SafeMath.add(upgradesOwned[player][upgradeId],1);
555   }
556 
557   function getUintsOwnerCount(address _address) external view returns (uint256) {
558     return uintsOwnerCount[_address];
559   }
560   function setUintsOwnerCount(address _address, uint256 amount, bool iflag) external onlyAccess {
561     if (iflag) {
562       uintsOwnerCount[_address] = SafeMath.add(uintsOwnerCount[_address],amount);
563     } else if (!iflag) {
564       uintsOwnerCount[_address] = SafeMath.sub(uintsOwnerCount[_address],amount);
565     }
566   }
567 
568   function getUnitCoinProductionIncreases(address _address, uint256 cardId) external view returns (uint256) {
569     return unitCoinProductionIncreases[_address][cardId];
570   }
571 
572   function setUnitCoinProductionIncreases(address _address, uint256 cardId, uint256 iValue,bool iflag) external onlyAccess {
573     if (iflag) {
574       unitCoinProductionIncreases[_address][cardId] = SafeMath.add(unitCoinProductionIncreases[_address][cardId],iValue);
575     } else if (!iflag) {
576       unitCoinProductionIncreases[_address][cardId] = SafeMath.sub(unitCoinProductionIncreases[_address][cardId],iValue);
577     }
578   }
579 
580   function getUnitCoinProductionMultiplier(address _address, uint256 cardId) external view returns (uint256) {
581     return unitCoinProductionMultiplier[_address][cardId];
582   }
583 
584   function setUnitCoinProductionMultiplier(address _address, uint256 cardId, uint256 iValue, bool iflag) external onlyAccess {
585     if (iflag) {
586       unitCoinProductionMultiplier[_address][cardId] = SafeMath.add(unitCoinProductionMultiplier[_address][cardId],iValue);
587     } else if (!iflag) {
588       unitCoinProductionMultiplier[_address][cardId] = SafeMath.sub(unitCoinProductionMultiplier[_address][cardId],iValue);
589     }
590   }
591 
592   function setUnitAttackIncreases(address _address, uint256 cardId, uint256 iValue,bool iflag) external onlyAccess {
593     if (iflag) {
594       unitAttackIncreases[_address][cardId] = SafeMath.add(unitAttackIncreases[_address][cardId],iValue);
595     } else if (!iflag) {
596       unitAttackIncreases[_address][cardId] = SafeMath.sub(unitAttackIncreases[_address][cardId],iValue);
597     }
598   }
599 
600   function getUnitAttackIncreases(address _address, uint256 cardId) external view returns (uint256) {
601     return unitAttackIncreases[_address][cardId];
602   } 
603   function setUnitAttackMultiplier(address _address, uint256 cardId, uint256 iValue,bool iflag) external onlyAccess {
604     if (iflag) {
605       unitAttackMultiplier[_address][cardId] = SafeMath.add(unitAttackMultiplier[_address][cardId],iValue);
606     } else if (!iflag) {
607       unitAttackMultiplier[_address][cardId] = SafeMath.sub(unitAttackMultiplier[_address][cardId],iValue);
608     }
609   }
610   function getUnitAttackMultiplier(address _address, uint256 cardId) external view returns (uint256) {
611     return unitAttackMultiplier[_address][cardId];
612   } 
613 
614   function setUnitDefenseIncreases(address _address, uint256 cardId, uint256 iValue,bool iflag) external onlyAccess {
615     if (iflag) {
616       unitDefenseIncreases[_address][cardId] = SafeMath.add(unitDefenseIncreases[_address][cardId],iValue);
617     } else if (!iflag) {
618       unitDefenseIncreases[_address][cardId] = SafeMath.sub(unitDefenseIncreases[_address][cardId],iValue);
619     }
620   }
621   function getUnitDefenseIncreases(address _address, uint256 cardId) external view returns (uint256) {
622     return unitDefenseIncreases[_address][cardId];
623   }
624   function setunitDefenseMultiplier(address _address, uint256 cardId, uint256 iValue,bool iflag) external onlyAccess {
625     if (iflag) {
626       unitDefenseMultiplier[_address][cardId] = SafeMath.add(unitDefenseMultiplier[_address][cardId],iValue);
627     } else if (!iflag) {
628       unitDefenseMultiplier[_address][cardId] = SafeMath.sub(unitDefenseMultiplier[_address][cardId],iValue);
629     }
630   }
631   function getUnitDefenseMultiplier(address _address, uint256 cardId) external view returns (uint256) {
632     return unitDefenseMultiplier[_address][cardId];
633   }
634   function setUnitJadeStealingIncreases(address _address, uint256 cardId, uint256 iValue,bool iflag) external onlyAccess {
635     if (iflag) {
636       unitJadeStealingIncreases[_address][cardId] = SafeMath.add(unitJadeStealingIncreases[_address][cardId],iValue);
637     } else if (!iflag) {
638       unitJadeStealingIncreases[_address][cardId] = SafeMath.sub(unitJadeStealingIncreases[_address][cardId],iValue);
639     }
640   }
641   function getUnitJadeStealingIncreases(address _address, uint256 cardId) external view returns (uint256) {
642     return unitJadeStealingIncreases[_address][cardId];
643   } 
644 
645   function setUnitJadeStealingMultiplier(address _address, uint256 cardId, uint256 iValue,bool iflag) external onlyAccess {
646     if (iflag) {
647       unitJadeStealingMultiplier[_address][cardId] = SafeMath.add(unitJadeStealingMultiplier[_address][cardId],iValue);
648     } else if (!iflag) {
649       unitJadeStealingMultiplier[_address][cardId] = SafeMath.sub(unitJadeStealingMultiplier[_address][cardId],iValue);
650     }
651   }
652   function getUnitJadeStealingMultiplier(address _address, uint256 cardId) external view returns (uint256) {
653     return unitJadeStealingMultiplier[_address][cardId];
654   } 
655 
656   function setUintCoinProduction(address _address, uint256 cardId, uint256 iValue, bool iflag) external onlyAccess {
657     if (iflag) {
658       uintProduction[_address][cardId] = SafeMath.add(uintProduction[_address][cardId],iValue);
659      } else if (!iflag) {
660       uintProduction[_address][cardId] = SafeMath.sub(uintProduction[_address][cardId],iValue);
661     }
662   }
663 
664   function getUintCoinProduction(address _address, uint256 cardId) external view returns (uint256) {
665     return uintProduction[_address][cardId];
666   }
667 
668   function upgradeUnitMultipliers(address player, uint256 upgradeClass, uint256 unitId, uint256 upgradeValue) external onlyAccess {
669     uint256 productionGain;
670     if (upgradeClass == 0) {
671       unitCoinProductionIncreases[player][unitId] += upgradeValue;
672       productionGain = unitsOwned[player][unitId] * upgradeValue * (10 + unitCoinProductionMultiplier[player][unitId]);
673       increasePlayersJadeProduction(player, productionGain);
674     } else if (upgradeClass == 1) {
675       unitCoinProductionMultiplier[player][unitId] += upgradeValue;
676       productionGain = unitsOwned[player][unitId] * upgradeValue * (schema.unitCoinProduction(unitId) + unitCoinProductionIncreases[player][unitId]);
677       increasePlayersJadeProduction(player, productionGain);
678     } else if (upgradeClass == 2) {
679       unitAttackIncreases[player][unitId] += upgradeValue;
680     } else if (upgradeClass == 3) {
681       unitAttackMultiplier[player][unitId] += upgradeValue;
682     } else if (upgradeClass == 4) {
683       unitDefenseIncreases[player][unitId] += upgradeValue;
684     } else if (upgradeClass == 5) {
685       unitDefenseMultiplier[player][unitId] += upgradeValue;
686     } else if (upgradeClass == 6) {
687       unitJadeStealingIncreases[player][unitId] += upgradeValue;
688     } else if (upgradeClass == 7) {
689       unitJadeStealingMultiplier[player][unitId] += upgradeValue;
690     } else if (upgradeClass == 8) {
691       unitMaxCap[player][unitId] = upgradeValue; // Housing upgrade (new capacity)
692     }
693   }
694     
695   function removeUnitMultipliers(address player, uint256 upgradeClass, uint256 unitId, uint256 upgradeValue) external onlyAccess {
696     uint256 productionLoss;
697     if (upgradeClass == 0) {
698       unitCoinProductionIncreases[player][unitId] -= upgradeValue;
699       productionLoss = unitsOwned[player][unitId] * upgradeValue * (10 + unitCoinProductionMultiplier[player][unitId]);
700       reducePlayersJadeProduction(player, productionLoss);
701     } else if (upgradeClass == 1) {
702       unitCoinProductionMultiplier[player][unitId] -= upgradeValue;
703       productionLoss = unitsOwned[player][unitId] * upgradeValue * (schema.unitCoinProduction(unitId) + unitCoinProductionIncreases[player][unitId]);
704       reducePlayersJadeProduction(player, productionLoss);
705     } else if (upgradeClass == 2) {
706       unitAttackIncreases[player][unitId] -= upgradeValue;
707     } else if (upgradeClass == 3) {
708       unitAttackMultiplier[player][unitId] -= upgradeValue;
709     } else if (upgradeClass == 4) {
710       unitDefenseIncreases[player][unitId] -= upgradeValue;
711     } else if (upgradeClass == 5) {
712       unitDefenseMultiplier[player][unitId] -= upgradeValue;
713     } else if (upgradeClass == 6) {
714       unitJadeStealingIncreases[player][unitId] -= upgradeValue;
715     } else if (upgradeClass == 7) {
716       unitJadeStealingMultiplier[player][unitId] -= upgradeValue;
717     }
718   }
719 }
720 
721 library SafeMath {
722 
723   /**
724   * @dev Multiplies two numbers, throws on overflow.
725   */
726   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
727     if (a == 0) {
728       return 0;
729     }
730     uint256 c = a * b;
731     assert(c / a == b);
732     return c;
733   }
734 
735   /**
736   * @dev Integer division of two numbers, truncating the quotient.
737   */
738   function div(uint256 a, uint256 b) internal pure returns (uint256) {
739     // assert(b > 0); // Solidity automatically throws when dividing by 0
740     uint256 c = a / b;
741     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
742     return c;
743   }
744 
745   /**
746   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
747   */
748   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
749     assert(b <= a);
750     return a - b;
751   }
752 
753   /**
754   * @dev Adds two numbers, throws on overflow.
755   */
756   function add(uint256 a, uint256 b) internal pure returns (uint256) {
757     uint256 c = a + b;
758     assert(c >= a);
759     return c;
760   }
761 }