1 pragma solidity ^0.4.18;
2 /* ==================================================================== */
3 /* Copyright (c) 2018 The MagicAcademy Project.  All rights reserved.
4 /* 
5 /* https://www.magicacademy.io One of the world's first idle strategy games of blockchain 
6 /* https://staging.bitguild.com/game/magicacademy 
7 /* authors rainy@livestar.com/fanny.zheng@livestar.com
8 /*         rainy@gmail.com           
9 /* ==================================================================== */
10 
11 library SafeMath {
12 
13   /**
14   * @dev Multiplies two numbers, throws on overflow.
15   */
16   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17     if (a == 0) {
18       return 0;
19     }
20     uint256 c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   /**
36   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256) {
47     uint256 c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63   /*
64    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65    * account.
66    */
67   function Ownable() public {
68     owner = msg.sender;
69   }
70 
71   /**
72    * @dev Throws if called by any account other than the owner.
73    */
74   modifier onlyOwner() {
75     require(msg.sender == owner);
76     _;
77   }
78 
79   /**
80    * @dev Allows the current owner to transfer control of the contract to a newOwner.
81    * @param newOwner The address to transfer ownership to.
82    */
83   function transferOwnership(address newOwner) public onlyOwner {
84     require(newOwner != address(0));
85     OwnershipTransferred(owner, newOwner);
86     owner = newOwner;
87   }
88 
89 }
90 
91 contract OperAccess is Ownable {
92   address tradeAddress;
93   address platAddress;
94   address attackAddress;
95   address raffleAddress;
96   address drawAddress;
97 
98   function setTradeAddress(address _address) external onlyOwner {
99     require(_address != address(0));
100     tradeAddress = _address;
101   }
102 
103   function setPLATAddress(address _address) external onlyOwner {
104     require(_address != address(0));
105     platAddress = _address;
106   }
107 
108   function setAttackAddress(address _address) external onlyOwner {
109     require(_address != address(0));
110     attackAddress = _address;
111   }
112 
113   function setRaffleAddress(address _address) external onlyOwner {
114     require(_address != address(0));
115     raffleAddress = _address;
116   }
117 
118   function setDrawAddress(address _address) external onlyOwner {
119     require(_address != address(0));
120     drawAddress = _address;
121   }
122 
123   modifier onlyAccess() {
124     require(msg.sender == tradeAddress || msg.sender == platAddress || msg.sender == attackAddress || msg.sender == raffleAddress || msg.sender == drawAddress);
125     _;
126   }
127 }
128 
129 interface ERC20 {
130     function totalSupply() public constant returns (uint);
131     function balanceOf(address tokenOwner) public constant returns (uint balance);
132     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
133     function transfer(address to, uint tokens) public returns (bool success);
134     function approve(address spender, uint tokens) public returns (bool success);
135     function transferFrom(address from, address to, uint tokens) public returns (bool success);
136     event Transfer(address indexed from, address indexed to, uint tokens);
137     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
138 }
139 // Jade - Crypto MagicAcacedy Game
140 // https://www.magicAcademy.io
141 
142 contract JadeCoin is ERC20, OperAccess {
143   using SafeMath for SafeMath;
144   string public constant name  = "MAGICACADEMY JADE";
145   string public constant symbol = "Jade";
146   uint8 public constant decimals = 0;
147   uint256 public roughSupply;
148   uint256 public totalJadeProduction;
149 
150   uint256[] public totalJadeProductionSnapshots; // The total goo production for each prior day past
151   uint256[] public allocatedJadeResearchSnapshots; // The research eth allocated to each prior day past
152 
153   // Balances for each player
154   mapping(address => uint256) public jadeBalance;
155   mapping(address => mapping(uint8 => uint256)) public coinBalance;
156   mapping(uint256 => uint256) totalEtherPool; //Total Pool
157   
158   mapping(address => mapping(uint256 => uint256)) private jadeProductionSnapshots; // Store player's jade production for given day (snapshot)
159   mapping(address => mapping(uint256 => bool)) private jadeProductionZeroedSnapshots; // This isn't great but we need know difference between 0 production and an unused/inactive day.
160     
161   mapping(address => uint256) public lastJadeSaveTime; // Seconds (last time player claimed their produced jade)
162   mapping(address => uint256) public lastJadeProductionUpdate; // Days (last snapshot player updated their production)
163   mapping(address => uint256) private lastJadeResearchFundClaim; // Days (snapshot number)
164    
165   // Mapping of approved ERC20 transfers (by player)
166   mapping(address => mapping(address => uint256)) private allowed;
167      
168   // Constructor
169   function JadeCoin() public {
170   }
171 
172   function totalSupply() public constant returns(uint256) {
173     return roughSupply; // Stored jade (rough supply as it ignores earned/unclaimed jade)
174   }
175   /// balance of jade in-game
176   function balanceOf(address player) public constant returns(uint256) {
177     return SafeMath.add(jadeBalance[player],balanceOfUnclaimed(player));
178   }
179   /// unclaimed jade
180   function balanceOfUnclaimed(address player) public constant returns (uint256) {
181     uint256 lSave = lastJadeSaveTime[player];
182     if (lSave > 0 && lSave < block.timestamp) { 
183       return SafeMath.mul(getJadeProduction(player),SafeMath.div(SafeMath.sub(block.timestamp,lSave),60));
184     }
185     return 0;
186   }
187 
188   /// production/s
189   function getJadeProduction(address player) public constant returns (uint256){
190     return jadeProductionSnapshots[player][lastJadeProductionUpdate[player]];
191   }
192 
193   function getlastJadeProductionUpdate(address player) public view returns (uint256) {
194     return lastJadeProductionUpdate[player];
195   }
196     /// increase prodution 
197   function increasePlayersJadeProduction(address player, uint256 increase) external onlyAccess {
198     jadeProductionSnapshots[player][allocatedJadeResearchSnapshots.length] = SafeMath.add(getJadeProduction(player),increase);
199     lastJadeProductionUpdate[player] = allocatedJadeResearchSnapshots.length;
200     totalJadeProduction = SafeMath.add(totalJadeProduction,increase);
201   }
202 
203   /// reduce production
204   function reducePlayersJadeProduction(address player, uint256 decrease) external onlyAccess {
205     uint256 previousProduction = getJadeProduction(player);
206     uint256 newProduction = SafeMath.sub(previousProduction, decrease);
207 
208     if (newProduction == 0) { 
209       jadeProductionZeroedSnapshots[player][allocatedJadeResearchSnapshots.length] = true;
210       delete jadeProductionSnapshots[player][allocatedJadeResearchSnapshots.length]; // 0
211     } else {
212       jadeProductionSnapshots[player][allocatedJadeResearchSnapshots.length] = newProduction;
213     }   
214     lastJadeProductionUpdate[player] = allocatedJadeResearchSnapshots.length;
215     totalJadeProduction = SafeMath.sub(totalJadeProduction,decrease);
216   }
217 
218   /// update player's jade balance
219   function updatePlayersCoin(address player) internal {
220     uint256 coinGain = balanceOfUnclaimed(player);
221     lastJadeSaveTime[player] = block.timestamp;
222     roughSupply = SafeMath.add(roughSupply,coinGain);  
223     jadeBalance[player] = SafeMath.add(jadeBalance[player],coinGain);  
224   }
225 
226   /// update player's jade balance
227   function updatePlayersCoinByOut(address player) external onlyAccess {
228     uint256 coinGain = balanceOfUnclaimed(player);
229     lastJadeSaveTime[player] = block.timestamp;
230     roughSupply = SafeMath.add(roughSupply,coinGain);  
231     jadeBalance[player] = SafeMath.add(jadeBalance[player],coinGain);  
232   }
233   /// transfer
234   function transfer(address recipient, uint256 amount) public returns (bool) {
235     updatePlayersCoin(msg.sender);
236     require(amount <= jadeBalance[msg.sender]);
237     jadeBalance[msg.sender] = SafeMath.sub(jadeBalance[msg.sender],amount);
238     jadeBalance[recipient] = SafeMath.add(jadeBalance[recipient],amount);
239     Transfer(msg.sender, recipient, amount);
240     return true;
241   }
242   /// transferfrom
243   function transferFrom(address player, address recipient, uint256 amount) public returns (bool) {
244     updatePlayersCoin(player);
245     require(amount <= allowed[player][msg.sender] && amount <= jadeBalance[player]);
246         
247     jadeBalance[player] = SafeMath.sub(jadeBalance[player],amount); 
248     jadeBalance[recipient] = SafeMath.add(jadeBalance[recipient],amount); 
249     allowed[player][msg.sender] = SafeMath.sub(allowed[player][msg.sender],amount); 
250         
251     Transfer(player, recipient, amount);  
252     return true;
253   }
254   
255   function approve(address approvee, uint256 amount) public returns (bool) {
256     allowed[msg.sender][approvee] = amount;  
257     Approval(msg.sender, approvee, amount);
258     return true;
259   }
260   
261   function allowance(address player, address approvee) public constant returns(uint256) {
262     return allowed[player][approvee];  
263   }
264   
265   /// update Jade via purchase
266   function updatePlayersCoinByPurchase(address player, uint256 purchaseCost) external onlyAccess {
267     uint256 unclaimedJade = balanceOfUnclaimed(player);
268         
269     if (purchaseCost > unclaimedJade) {
270       uint256 jadeDecrease = SafeMath.sub(purchaseCost, unclaimedJade);
271       require(jadeBalance[player] >= jadeDecrease);
272       roughSupply = SafeMath.sub(roughSupply,jadeDecrease);
273       jadeBalance[player] = SafeMath.sub(jadeBalance[player],jadeDecrease);
274     } else {
275       uint256 jadeGain = SafeMath.sub(unclaimedJade,purchaseCost);
276       roughSupply = SafeMath.add(roughSupply,jadeGain);
277       jadeBalance[player] = SafeMath.add(jadeBalance[player],jadeGain);
278     }
279         
280     lastJadeSaveTime[player] = block.timestamp;
281   }
282 
283   function JadeCoinMining(address _addr, uint256 _amount) external onlyOwner {
284     roughSupply = SafeMath.add(roughSupply,_amount);
285     jadeBalance[_addr] = SafeMath.add(jadeBalance[_addr],_amount);
286   }
287 
288   function setRoughSupply(uint256 iroughSupply) external onlyAccess {
289     roughSupply = SafeMath.add(roughSupply,iroughSupply);
290   }
291   /// balance of coin/eth  in-game
292   function coinBalanceOf(address player,uint8 itype) external constant returns(uint256) {
293     return coinBalance[player][itype];
294   }
295 
296   function setJadeCoin(address player, uint256 coin, bool iflag) external onlyAccess {
297     if (iflag) {
298       jadeBalance[player] = SafeMath.add(jadeBalance[player],coin);
299     } else if (!iflag) {
300       jadeBalance[player] = SafeMath.sub(jadeBalance[player],coin);
301     }
302   }
303   
304   function setCoinBalance(address player, uint256 eth, uint8 itype, bool iflag) external onlyAccess {
305     if (iflag) {
306       coinBalance[player][itype] = SafeMath.add(coinBalance[player][itype],eth);
307     } else if (!iflag) {
308       coinBalance[player][itype] = SafeMath.sub(coinBalance[player][itype],eth);
309     }
310   }
311 
312   function setLastJadeSaveTime(address player) external onlyAccess {
313     lastJadeSaveTime[player] = block.timestamp;
314   }
315 
316   function setTotalEtherPool(uint256 inEth, uint8 itype, bool iflag) external onlyAccess {
317     if (iflag) {
318       totalEtherPool[itype] = SafeMath.add(totalEtherPool[itype],inEth);
319      } else if (!iflag) {
320       totalEtherPool[itype] = SafeMath.sub(totalEtherPool[itype],inEth);
321     }
322   }
323 
324   function getTotalEtherPool(uint8 itype) external view returns (uint256) {
325     return totalEtherPool[itype];
326   }
327 
328   function setJadeCoinZero(address player) external onlyAccess {
329     jadeBalance[player]=0;
330   }
331 }
332 
333 interface GameConfigInterface {
334   function productionCardIdRange() external constant returns (uint256, uint256);
335   function battleCardIdRange() external constant returns (uint256, uint256);
336   function upgradeIdRange() external constant returns (uint256, uint256);
337   function unitCoinProduction(uint256 cardId) external constant returns (uint256);
338   function unitAttack(uint256 cardId) external constant returns (uint256);
339   function unitDefense(uint256 cardId) external constant returns (uint256);
340   function unitStealingCapacity(uint256 cardId) external constant returns (uint256);
341 }
342 
343 /// @notice define the players,cards,jadecoin
344 /// @author rainysiu rainy@livestar.com
345 /// @dev MagicAcademy Games 
346 
347 contract CardsBase is JadeCoin {
348 
349   // player  
350   struct Player {
351     address owneraddress;
352   }
353 
354   Player[] players;
355   bool gameStarted;
356   
357   GameConfigInterface public schema;
358 
359   // Stuff owned by each player
360   mapping(address => mapping(uint256 => uint256)) public unitsOwned;  //number of normal card
361   mapping(address => mapping(uint256 => uint256)) public upgradesOwned;  //Lv of upgrade card
362 
363   mapping(address => uint256) public uintsOwnerCount; // total number of cards
364   mapping(address=> mapping(uint256 => uint256)) public uintProduction;  //card's production
365 
366   // Rares & Upgrades (Increase unit's production / attack etc.)
367   mapping(address => mapping(uint256 => uint256)) public unitCoinProductionIncreases; // Adds to the coin per second
368   mapping(address => mapping(uint256 => uint256)) public unitCoinProductionMultiplier; // Multiplies the coin per second
369   mapping(address => mapping(uint256 => uint256)) public unitAttackIncreases;
370   mapping(address => mapping(uint256 => uint256)) public unitAttackMultiplier;
371   mapping(address => mapping(uint256 => uint256)) public unitDefenseIncreases;
372   mapping(address => mapping(uint256 => uint256)) public unitDefenseMultiplier;
373   mapping(address => mapping(uint256 => uint256)) public unitJadeStealingIncreases;
374   mapping(address => mapping(uint256 => uint256)) public unitJadeStealingMultiplier;
375 
376   //setting configuration
377   function setConfigAddress(address _address) external onlyOwner {
378     schema = GameConfigInterface(_address);
379   }
380 
381   /// start game
382   function beginGame() external onlyOwner {
383     require(!gameStarted);
384     gameStarted = true; 
385   }
386   function getGameStarted() external constant returns (bool) {
387     return gameStarted;
388   }
389   function AddPlayers(address _address) external onlyAccess { 
390     Player memory _player= Player({
391       owneraddress: _address
392     });
393     players.push(_player);
394   }
395 
396   /// @notice ranking of production
397   function getRanking() external view returns (address[], uint256[]) {
398     uint256 len = players.length;
399     uint256[] memory arr = new uint256[](len);
400     address[] memory arr_addr = new address[](len);
401 
402     uint counter =0;
403     for (uint k=0;k<len; k++){
404       arr[counter] =  getJadeProduction(players[k].owneraddress);
405       arr_addr[counter] = players[k].owneraddress;
406       counter++;
407     }
408 
409     for(uint i=0;i<len-1;i++) {
410       for(uint j=0;j<len-i-1;j++) {
411         if(arr[j]<arr[j+1]) {
412           uint256 temp = arr[j];
413           address temp_addr = arr_addr[j];
414           arr[j] = arr[j+1];
415           arr[j+1] = temp;
416           arr_addr[j] = arr_addr[j+1];
417           arr_addr[j+1] = temp_addr;
418         }
419       }
420     }
421     return (arr_addr,arr);
422   }
423 
424   /// @notice battle power ranking
425   function getAttackRanking() external view returns (address[], uint256[]) {
426     uint256 len = players.length;
427     uint256[] memory arr = new uint256[](len);
428     address[] memory arr_addr = new address[](len);
429 
430     uint counter =0;
431     for (uint k=0;k<len; k++){
432       (,,,arr[counter]) = getPlayersBattleStats(players[k].owneraddress);
433       arr_addr[counter] = players[k].owneraddress;
434       counter++;
435     }
436 
437     for(uint i=0;i<len-1;i++) {
438       for(uint j=0;j<len-i-1;j++) {
439         if(arr[j]<arr[j+1]) {
440           uint256 temp = arr[j];
441           address temp_addr = arr_addr[j];
442           arr[j] = arr[j+1];
443           arr[j+1] = temp;
444           arr_addr[j] = arr_addr[j+1];
445           arr_addr[j+1] = temp_addr;
446         }
447       }
448     }
449     return(arr_addr,arr);
450   } 
451 
452   //total users
453   function getTotalUsers()  external view returns (uint256) {
454     return players.length;
455   }
456  
457   /// UnitsProuction
458   function getUnitsProduction(address player, uint256 unitId, uint256 amount) external constant returns (uint256) {
459     return (amount * (schema.unitCoinProduction(unitId) + unitCoinProductionIncreases[player][unitId]) * (10 + unitCoinProductionMultiplier[player][unitId])) / 10; 
460   } 
461 
462   /// one card's production
463   function getUnitsInProduction(address player, uint256 unitId, uint256 amount) external constant returns (uint256) {
464     return SafeMath.div(SafeMath.mul(amount,uintProduction[player][unitId]),unitsOwned[player][unitId]);
465   } 
466 
467   /// UnitsAttack
468   function getUnitsAttack(address player, uint256 unitId, uint256 amount) internal constant returns (uint256) {
469     return (amount * (schema.unitAttack(unitId) + unitAttackIncreases[player][unitId]) * (10 + unitAttackMultiplier[player][unitId])) / 10;
470   }
471   /// UnitsDefense
472   function getUnitsDefense(address player, uint256 unitId, uint256 amount) internal constant returns (uint256) {
473     return (amount * (schema.unitDefense(unitId) + unitDefenseIncreases[player][unitId]) * (10 + unitDefenseMultiplier[player][unitId])) / 10;
474   }
475   /// UnitsStealingCapacity
476   function getUnitsStealingCapacity(address player, uint256 unitId, uint256 amount) internal constant returns (uint256) {
477     return (amount * (schema.unitStealingCapacity(unitId) + unitJadeStealingIncreases[player][unitId]) * (10 + unitJadeStealingMultiplier[player][unitId])) / 10;
478   }
479  
480   // player's attacking & defending & stealing & battle power
481   function getPlayersBattleStats(address player) public constant returns (
482     uint256 attackingPower, 
483     uint256 defendingPower, 
484     uint256 stealingPower,
485     uint256 battlePower) {
486 
487     uint256 startId;
488     uint256 endId;
489     (startId, endId) = schema.battleCardIdRange();
490 
491     // Not ideal but will only be a small number of units (and saves gas when buying units)
492     while (startId <= endId) {
493       attackingPower = SafeMath.add(attackingPower,getUnitsAttack(player, startId, unitsOwned[player][startId]));
494       stealingPower = SafeMath.add(stealingPower,getUnitsStealingCapacity(player, startId, unitsOwned[player][startId]));
495       defendingPower = SafeMath.add(defendingPower,getUnitsDefense(player, startId, unitsOwned[player][startId]));
496       battlePower = SafeMath.add(attackingPower,defendingPower); 
497       startId++;
498     }
499   }
500 
501   // @nitice number of normal card
502   function getOwnedCount(address player, uint256 cardId) external view returns (uint256) {
503     return unitsOwned[player][cardId];
504   }
505   function setOwnedCount(address player, uint256 cardId, uint256 amount, bool iflag) external onlyAccess {
506     if (iflag) {
507       unitsOwned[player][cardId] = SafeMath.add(unitsOwned[player][cardId],amount);
508      } else if (!iflag) {
509       unitsOwned[player][cardId] = SafeMath.sub(unitsOwned[player][cardId],amount);
510     }
511   }
512 
513   // @notice Lv of upgrade card
514   function getUpgradesOwned(address player, uint256 upgradeId) external view returns (uint256) {
515     return upgradesOwned[player][upgradeId];
516   }
517   //set upgrade
518   function setUpgradesOwned(address player, uint256 upgradeId) external onlyAccess {
519     upgradesOwned[player][upgradeId] = SafeMath.add(upgradesOwned[player][upgradeId],1);
520   }
521 
522   function getUintsOwnerCount(address _address) external view returns (uint256) {
523     return uintsOwnerCount[_address];
524   }
525   function setUintsOwnerCount(address _address, uint256 amount, bool iflag) external onlyAccess {
526     if (iflag) {
527       uintsOwnerCount[_address] = SafeMath.add(uintsOwnerCount[_address],amount);
528     } else if (!iflag) {
529       uintsOwnerCount[_address] = SafeMath.sub(uintsOwnerCount[_address],amount);
530     }
531   }
532 
533   function getUnitCoinProductionIncreases(address _address, uint256 cardId) external view returns (uint256) {
534     return unitCoinProductionIncreases[_address][cardId];
535   }
536 
537   function setUnitCoinProductionIncreases(address _address, uint256 cardId, uint256 iValue,bool iflag) external onlyAccess {
538     if (iflag) {
539       unitCoinProductionIncreases[_address][cardId] = SafeMath.add(unitCoinProductionIncreases[_address][cardId],iValue);
540     } else if (!iflag) {
541       unitCoinProductionIncreases[_address][cardId] = SafeMath.sub(unitCoinProductionIncreases[_address][cardId],iValue);
542     }
543   }
544 
545   function getUnitCoinProductionMultiplier(address _address, uint256 cardId) external view returns (uint256) {
546     return unitCoinProductionMultiplier[_address][cardId];
547   }
548 
549   function setUnitCoinProductionMultiplier(address _address, uint256 cardId, uint256 iValue, bool iflag) external onlyAccess {
550     if (iflag) {
551       unitCoinProductionMultiplier[_address][cardId] = SafeMath.add(unitCoinProductionMultiplier[_address][cardId],iValue);
552     } else if (!iflag) {
553       unitCoinProductionMultiplier[_address][cardId] = SafeMath.sub(unitCoinProductionMultiplier[_address][cardId],iValue);
554     }
555   }
556 
557   function setUnitAttackIncreases(address _address, uint256 cardId, uint256 iValue,bool iflag) external onlyAccess {
558     if (iflag) {
559       unitAttackIncreases[_address][cardId] = SafeMath.add(unitAttackIncreases[_address][cardId],iValue);
560     } else if (!iflag) {
561       unitAttackIncreases[_address][cardId] = SafeMath.sub(unitAttackIncreases[_address][cardId],iValue);
562     }
563   }
564 
565   function getUnitAttackIncreases(address _address, uint256 cardId) external view returns (uint256) {
566     return unitAttackIncreases[_address][cardId];
567   } 
568   function setUnitAttackMultiplier(address _address, uint256 cardId, uint256 iValue,bool iflag) external onlyAccess {
569     if (iflag) {
570       unitAttackMultiplier[_address][cardId] = SafeMath.add(unitAttackMultiplier[_address][cardId],iValue);
571     } else if (!iflag) {
572       unitAttackMultiplier[_address][cardId] = SafeMath.sub(unitAttackMultiplier[_address][cardId],iValue);
573     }
574   }
575   function getUnitAttackMultiplier(address _address, uint256 cardId) external view returns (uint256) {
576     return unitAttackMultiplier[_address][cardId];
577   } 
578 
579   function setUnitDefenseIncreases(address _address, uint256 cardId, uint256 iValue,bool iflag) external onlyAccess {
580     if (iflag) {
581       unitDefenseIncreases[_address][cardId] = SafeMath.add(unitDefenseIncreases[_address][cardId],iValue);
582     } else if (!iflag) {
583       unitDefenseIncreases[_address][cardId] = SafeMath.sub(unitDefenseIncreases[_address][cardId],iValue);
584     }
585   }
586   function getUnitDefenseIncreases(address _address, uint256 cardId) external view returns (uint256) {
587     return unitDefenseIncreases[_address][cardId];
588   }
589   function setunitDefenseMultiplier(address _address, uint256 cardId, uint256 iValue,bool iflag) external onlyAccess {
590     if (iflag) {
591       unitDefenseMultiplier[_address][cardId] = SafeMath.add(unitDefenseMultiplier[_address][cardId],iValue);
592     } else if (!iflag) {
593       unitDefenseMultiplier[_address][cardId] = SafeMath.sub(unitDefenseMultiplier[_address][cardId],iValue);
594     }
595   }
596   function getUnitDefenseMultiplier(address _address, uint256 cardId) external view returns (uint256) {
597     return unitDefenseMultiplier[_address][cardId];
598   }
599   function setUnitJadeStealingIncreases(address _address, uint256 cardId, uint256 iValue,bool iflag) external onlyAccess {
600     if (iflag) {
601       unitJadeStealingIncreases[_address][cardId] = SafeMath.add(unitJadeStealingIncreases[_address][cardId],iValue);
602     } else if (!iflag) {
603       unitJadeStealingIncreases[_address][cardId] = SafeMath.sub(unitJadeStealingIncreases[_address][cardId],iValue);
604     }
605   }
606   function getUnitJadeStealingIncreases(address _address, uint256 cardId) external view returns (uint256) {
607     return unitJadeStealingIncreases[_address][cardId];
608   } 
609 
610   function setUnitJadeStealingMultiplier(address _address, uint256 cardId, uint256 iValue,bool iflag) external onlyAccess {
611     if (iflag) {
612       unitJadeStealingMultiplier[_address][cardId] = SafeMath.add(unitJadeStealingMultiplier[_address][cardId],iValue);
613     } else if (!iflag) {
614       unitJadeStealingMultiplier[_address][cardId] = SafeMath.sub(unitJadeStealingMultiplier[_address][cardId],iValue);
615     }
616   }
617   function getUnitJadeStealingMultiplier(address _address, uint256 cardId) external view returns (uint256) {
618     return unitJadeStealingMultiplier[_address][cardId];
619   } 
620 
621   function setUintCoinProduction(address _address, uint256 cardId, uint256 iValue, bool iflag) external onlyAccess {
622     if (iflag) {
623       uintProduction[_address][cardId] = SafeMath.add(uintProduction[_address][cardId],iValue);
624      } else if (!iflag) {
625       uintProduction[_address][cardId] = SafeMath.sub(uintProduction[_address][cardId],iValue);
626     }
627   }
628 
629   function getUintCoinProduction(address _address, uint256 cardId) external view returns (uint256) {
630     return uintProduction[_address][cardId];
631   }
632 }