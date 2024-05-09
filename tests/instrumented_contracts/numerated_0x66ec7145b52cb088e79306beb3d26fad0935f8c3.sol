1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract CardsAccess {
46   address autoAddress;
47   address public owner;
48   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49   function CardsAccess() public {
50     owner = msg.sender;
51   }
52 
53   function setAutoAddress(address _address) external onlyOwner {
54     require(_address != address(0));
55     autoAddress = _address;
56   }
57 
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63   modifier onlyAuto() {
64     require(msg.sender == autoAddress);
65     _;
66   }
67 
68   function transferOwnership(address newOwner) public onlyOwner {
69     require(newOwner != address(0));
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 }
74 
75 interface CardsInterface {
76     function getJadeProduction(address player) external constant returns (uint256);
77     function getUpgradeValue(address player, uint256 upgradeClass, uint256 unitId, uint256 upgradeValue) external view returns (uint256);
78     function getGameStarted() external constant returns (bool);
79     function balanceOf(address player) external constant returns(uint256);
80     function balanceOfUnclaimed(address player) external constant returns (uint256);
81     function coinBalanceOf(address player,uint8 itype) external constant returns(uint256);
82 
83     function setCoinBalance(address player, uint256 eth, uint8 itype, bool iflag) external;
84     function setJadeCoin(address player, uint256 coin, bool iflag) external;
85     function setJadeCoinZero(address player) external;
86 
87     function setLastJadeSaveTime(address player) external;
88     function setRoughSupply(uint256 iroughSupply) external;
89 
90     function updatePlayersCoinByPurchase(address player, uint256 purchaseCost) external;
91     function updatePlayersCoinByOut(address player) external;
92 
93     function increasePlayersJadeProduction(address player, uint256 increase) external;
94     function reducePlayersJadeProduction(address player, uint256 decrease) external;
95 
96     function getUintsOwnerCount(address _address) external view returns (uint256);
97     function setUintsOwnerCount(address _address, uint256 amount, bool iflag) external;
98 
99     function getOwnedCount(address player, uint256 cardId) external view returns (uint256);
100     function setOwnedCount(address player, uint256 cardId, uint256 amount, bool iflag) external;
101 
102     function getUpgradesOwned(address player, uint256 upgradeId) external view returns (uint256);
103     function setUpgradesOwned(address player, uint256 upgradeId) external;
104     
105     function getTotalEtherPool(uint8 itype) external view returns (uint256);
106     function setTotalEtherPool(uint256 inEth, uint8 itype, bool iflag) external;
107 
108     function setNextSnapshotTime(uint256 iTime) external;
109     function getNextSnapshotTime() external view;
110 
111     function AddPlayers(address _address) external;
112     function getTotalUsers()  external view returns (uint256);
113     function getRanking() external view returns (address[] addr, uint256[] _arr);
114     function getAttackRanking() external view returns (address[] addr, uint256[] _arr);
115 
116     function getUnitsProduction(address player, uint256 cardId, uint256 amount) external constant returns (uint256);
117 
118     function getUnitCoinProductionIncreases(address _address, uint256 cardId) external view returns (uint256);
119     function setUnitCoinProductionIncreases(address _address, uint256 cardId, uint256 iValue,bool iflag) external;
120     function getUnitCoinProductionMultiplier(address _address, uint256 cardId) external view returns (uint256);
121     function setUnitCoinProductionMultiplier(address _address, uint256 cardId, uint256 iValue,bool iflag) external;
122     function setUnitAttackIncreases(address _address, uint256 cardId, uint256 iValue,bool iflag) external;
123     function setUnitAttackMultiplier(address _address, uint256 cardId, uint256 iValue,bool iflag) external;
124     function setUnitDefenseIncreases(address _address, uint256 cardId, uint256 iValue,bool iflag) external;
125     function setunitDefenseMultiplier(address _address, uint256 cardId, uint256 iValue,bool iflag) external;
126     
127     function setUnitJadeStealingIncreases(address _address, uint256 cardId, uint256 iValue,bool iflag) external;
128     function setUnitJadeStealingMultiplier(address _address, uint256 cardId, uint256 iValue,bool iflag) external;
129 
130     function setUintCoinProduction(address _address, uint256 cardId, uint256 iValue,bool iflag) external;
131     function getUintCoinProduction(address _address, uint256 cardId) external returns (uint256);
132 
133     function getUnitsInProduction(address player, uint256 unitId, uint256 amount) external constant returns (uint256);
134     function getPlayersBattleStats(address player) public constant returns (
135     uint256 attackingPower, 
136     uint256 defendingPower, 
137     uint256 stealingPower,
138     uint256 battlePower); 
139 }
140 
141 
142 interface GameConfigInterface {
143   function getMaxCAP() external returns (uint256);
144   function unitCoinProduction(uint256 cardId) external constant returns (uint256);
145   function getCostForCards(uint256 cardId, uint256 existing, uint256 amount) external constant returns (uint256);
146   function getUpgradeCardsInfo(uint256 upgradecardId,uint256 existing) external constant returns (
147     uint256 coinCost, 
148     uint256 ethCost, 
149     uint256 upgradeClass, 
150     uint256 cardId, 
151     uint256 upgradeValue,
152     uint256 platCost
153   );
154  function getCardInfo(uint256 cardId, uint256 existing, uint256 amount) external constant returns (uint256, uint256, uint256, uint256, bool);
155  function getBattleCardInfo(uint256 cardId, uint256 existing, uint256 amount) external constant returns (uint256, uint256, uint256, bool);
156   
157 }
158 
159 interface RareInterface {
160   function getRareItemsOwner(uint256 rareId) external view returns (address);
161   function getRareItemsPrice(uint256 rareId) external view returns (uint256);
162     function getRareInfo(uint256 _tokenId) external view returns (
163     uint256 sellingPrice,
164     address owner,
165     uint256 nextPrice,
166     uint256 rareClass,
167     uint256 cardId,
168     uint256 rareValue
169   ); 
170   function transferToken(address _from, address _to, uint256 _tokenId) external;
171   function transferTokenByContract(uint256 _tokenId,address _to) external;
172   function setRarePrice(uint256 _rareId, uint256 _price) external;
173   function rareStartPrice() external view returns (uint256);
174 }
175 
176 contract CardsHelper is CardsAccess {
177   //data contract
178   CardsInterface public cards ;
179   GameConfigInterface public schema;
180   RareInterface public rare;
181 
182   function setCardsAddress(address _address) external onlyOwner {
183     cards = CardsInterface(_address);
184   }
185 
186    //normal cards
187   function setConfigAddress(address _address) external onlyOwner {
188     schema = GameConfigInterface(_address);
189   }
190 
191   //rare cards
192   function setRareAddress(address _address) external onlyOwner {
193     rare = RareInterface(_address);
194   }
195 
196   function upgradeUnitMultipliers(address player, uint256 upgradeClass, uint256 unitId, uint256 upgradeValue) internal {
197     uint256 productionGain;
198     if (upgradeClass == 0) {
199       cards.setUnitCoinProductionIncreases(player, unitId, upgradeValue,true);
200       productionGain = (cards.getOwnedCount(player,unitId) * upgradeValue * (10 + cards.getUnitCoinProductionMultiplier(player,unitId)));
201       cards.setUintCoinProduction(player,unitId,productionGain,true); 
202       cards.increasePlayersJadeProduction(player,productionGain);
203     } else if (upgradeClass == 1) {
204       cards.setUnitCoinProductionMultiplier(player,unitId,upgradeValue,true);
205       productionGain = (cards.getOwnedCount(player,unitId) * upgradeValue * (schema.unitCoinProduction(unitId) + cards.getUnitCoinProductionIncreases(player,unitId)));
206       cards.setUintCoinProduction(player,unitId,productionGain,true);
207       cards.increasePlayersJadeProduction(player,productionGain);
208     } else if (upgradeClass == 2) {
209       cards.setUnitAttackIncreases(player,unitId,upgradeValue,true);
210     } else if (upgradeClass == 3) {
211       cards.setUnitAttackMultiplier(player,unitId,upgradeValue,true);
212     } else if (upgradeClass == 4) {
213       cards.setUnitDefenseIncreases(player,unitId,upgradeValue,true);
214     } else if (upgradeClass == 5) {
215       cards.setunitDefenseMultiplier(player,unitId,upgradeValue,true);
216     } else if (upgradeClass == 6) {
217       cards.setUnitJadeStealingIncreases(player,unitId,upgradeValue,true);
218     } else if (upgradeClass == 7) {
219       cards.setUnitJadeStealingMultiplier(player,unitId,upgradeValue,true);
220     }
221   }
222 
223   function removeUnitMultipliers(address player, uint256 upgradeClass, uint256 unitId, uint256 upgradeValue) internal {
224     uint256 productionLoss;
225     if (upgradeClass == 0) {
226       cards.setUnitCoinProductionIncreases(player, unitId, upgradeValue,false);
227       productionLoss = (cards.getOwnedCount(player,unitId) * upgradeValue * (10 + cards.getUnitCoinProductionMultiplier(player,unitId)));
228       cards.setUintCoinProduction(player,unitId,productionLoss,false); 
229       cards.reducePlayersJadeProduction(player, productionLoss);
230     } else if (upgradeClass == 1) {
231       cards.setUnitCoinProductionMultiplier(player,unitId,upgradeValue,false);
232       productionLoss = (cards.getOwnedCount(player,unitId) * upgradeValue * (schema.unitCoinProduction(unitId) + cards.getUnitCoinProductionIncreases(player,unitId)));
233       cards.setUintCoinProduction(player,unitId,productionLoss,false); 
234       cards.reducePlayersJadeProduction(player, productionLoss);
235     } else if (upgradeClass == 2) {
236       cards.setUnitAttackIncreases(player,unitId,upgradeValue,false);
237     } else if (upgradeClass == 3) {
238       cards.setUnitAttackMultiplier(player,unitId,upgradeValue,false);
239     } else if (upgradeClass == 4) {
240       cards.setUnitDefenseIncreases(player,unitId,upgradeValue,false);
241     } else if (upgradeClass == 5) {
242       cards.setunitDefenseMultiplier(player,unitId,upgradeValue,false);
243     } else if (upgradeClass == 6) { 
244       cards.setUnitJadeStealingIncreases(player,unitId,upgradeValue,false);
245     } else if (upgradeClass == 7) {
246       cards.setUnitJadeStealingMultiplier(player,unitId,upgradeValue,false);
247     }
248   }
249 }
250 
251 contract CardsTrade is CardsHelper {
252    // Minor game events
253   event UnitBought(address player, uint256 unitId, uint256 amount);
254   event UpgradeCardBought(address player, uint256 upgradeId);
255   event BuyRareCard(address player, address previous, uint256 rareId,uint256 iPrice);
256   event UnitSold(address player, uint256 unitId, uint256 amount);
257 
258   mapping(address => mapping(uint256 => uint256)) unitsOwnedOfEth; //cards bought through ether
259 
260   function() external payable {
261     cards.setTotalEtherPool(msg.value,0,true);
262   }
263   
264   /// @notice invite 
265   function sendGiftCard(address _address) external onlyAuto {
266     uint256 existing = cards.getOwnedCount(_address,1);
267     require(existing < schema.getMaxCAP());
268     require(SafeMath.add(existing,1) <= schema.getMaxCAP());
269 
270     // Update players jade
271     cards.updatePlayersCoinByPurchase(_address, 0);
272         
273     if (schema.unitCoinProduction(1) > 0) {
274       cards.increasePlayersJadeProduction(_address,cards.getUnitsProduction(_address, 1, 1)); 
275       cards.setUintCoinProduction(_address,1,cards.getUnitsProduction(_address, 1, 1),true); 
276     }
277     //players
278     if (cards.getUintsOwnerCount(_address) <= 0) {
279       cards.AddPlayers(_address);
280     }
281     cards.setUintsOwnerCount(_address,1,true);
282   
283     cards.setOwnedCount(_address,1,1,true);
284     UnitBought(_address, 1, 1);
285   } 
286   
287   /// buy normal cards with jade
288   function buyBasicCards(uint256 unitId, uint256 amount) external {
289     require(cards.getGameStarted());
290     require(amount>=1);
291     uint256 existing = cards.getOwnedCount(msg.sender,unitId);
292     uint256 iAmount;
293     require(existing < schema.getMaxCAP());
294     if (SafeMath.add(existing, amount) > schema.getMaxCAP()) {
295       iAmount = SafeMath.sub(schema.getMaxCAP(),existing);
296     } else {
297       iAmount = amount;
298     }
299     uint256 coinProduction;
300     uint256 coinCost;
301     uint256 ethCost;
302     if (unitId>=1 && unitId<=39) {    
303       (, coinProduction, coinCost, ethCost,) = schema.getCardInfo(unitId, existing, iAmount);
304     } else if (unitId>=40) {
305       (, coinCost, ethCost,) = schema.getBattleCardInfo(unitId, existing, iAmount);
306     }
307     require(cards.balanceOf(msg.sender) >= coinCost);
308     require(ethCost == 0); // Free ether unit
309         
310     // Update players jade 
311     cards.updatePlayersCoinByPurchase(msg.sender, coinCost);
312     ///****increase production***/
313     if (coinProduction > 0) {
314       cards.increasePlayersJadeProduction(msg.sender,cards.getUnitsProduction(msg.sender, unitId, iAmount)); 
315       cards.setUintCoinProduction(msg.sender,unitId,cards.getUnitsProduction(msg.sender, unitId, iAmount),true); 
316     }
317     //players
318     if (cards.getUintsOwnerCount(msg.sender)<=0) {
319       cards.AddPlayers(msg.sender);
320     }
321     cards.setUintsOwnerCount(msg.sender,iAmount,true);
322     cards.setOwnedCount(msg.sender,unitId,iAmount,true);
323     
324     UnitBought(msg.sender, unitId, iAmount);
325   }
326 
327   /// buy cards with ether
328   function buyEthCards(uint256 unitId, uint256 amount) external payable {
329     require(cards.getGameStarted());
330     require(amount>=1);
331     uint256 existing = cards.getOwnedCount(msg.sender,unitId);
332     require(existing < schema.getMaxCAP());    
333     
334     uint256 iAmount;
335     if (SafeMath.add(existing, amount) > schema.getMaxCAP()) {
336       iAmount = SafeMath.sub(schema.getMaxCAP(),existing);
337     } else {
338       iAmount = amount;
339     }
340     uint256 coinProduction;
341     uint256 coinCost;
342     uint256 ethCost;
343     if (unitId>=1 && unitId<=39) {
344       (,coinProduction, coinCost, ethCost,) = schema.getCardInfo(unitId, existing, iAmount);
345     } else if (unitId>=40){
346       (,coinCost, ethCost,) = schema.getBattleCardInfo(unitId, existing, iAmount);
347     }
348     
349     require(ethCost>0);
350     require(SafeMath.add(cards.coinBalanceOf(msg.sender,0),msg.value) >= ethCost);
351     require(cards.balanceOf(msg.sender) >= coinCost);  
352 
353     // Update players jade  
354     cards.updatePlayersCoinByPurchase(msg.sender, coinCost);
355 
356     if (ethCost > msg.value) {
357       cards.setCoinBalance(msg.sender,SafeMath.sub(ethCost,msg.value),0,false);
358     } else if (msg.value > ethCost) {
359       // Store overbid in their balance
360       cards.setCoinBalance(msg.sender,SafeMath.sub(msg.value,ethCost),0,true);
361     } 
362 
363     uint256 devFund = uint256(SafeMath.div(ethCost,20)); // 5% defund
364     cards.setTotalEtherPool(uint256(SafeMath.div(ethCost,4)),0,true);  // 25% go to pool
365     cards.setCoinBalance(owner,devFund,0,true);  
366   
367     //check procution   
368     if (coinProduction > 0) {
369       cards.increasePlayersJadeProduction(msg.sender, cards.getUnitsProduction(msg.sender, unitId, iAmount)); // increase procuction
370       cards.setUintCoinProduction(msg.sender,unitId,cards.getUnitsProduction(msg.sender, unitId, iAmount),true); 
371     }
372     //players
373     if (cards.getUintsOwnerCount(msg.sender)<=0) {
374       cards.AddPlayers(msg.sender);
375     }
376     cards.setUintsOwnerCount(msg.sender,iAmount,true);
377     cards.setOwnedCount(msg.sender,unitId,iAmount,true);
378     unitsOwnedOfEth[msg.sender][unitId] = SafeMath.add(unitsOwnedOfEth[msg.sender][unitId],iAmount);
379     UnitBought(msg.sender, unitId, iAmount);
380   }
381 
382    /// buy upgrade cards with ether/Jade
383   function buyUpgradeCard(uint256 upgradeId) external payable {
384     require(cards.getGameStarted());
385     require(upgradeId>=1);
386     uint256 existing = cards.getUpgradesOwned(msg.sender,upgradeId);
387     require(existing<=5); 
388     uint256 coinCost;
389     uint256 ethCost;
390     uint256 upgradeClass;
391     uint256 unitId;
392     uint256 upgradeValue;
393     (coinCost, ethCost, upgradeClass, unitId, upgradeValue,) = schema.getUpgradeCardsInfo(upgradeId,existing);
394 
395     if (ethCost > 0) {
396       require(SafeMath.add(cards.coinBalanceOf(msg.sender,0),msg.value) >= ethCost); 
397       
398       if (ethCost > msg.value) { // They can use their balance instead
399         cards.setCoinBalance(msg.sender, SafeMath.sub(ethCost,msg.value),0,false);
400       } else if (ethCost < msg.value) {  
401         cards.setCoinBalance(msg.sender,SafeMath.sub(msg.value,ethCost),0,true);
402       } 
403 
404       // defund 5%
405       uint256 devFund = uint256(SafeMath.div(ethCost, 20)); // 5% fee on purchases (marketing, gameplay & maintenance)
406       cards.setTotalEtherPool(SafeMath.sub(ethCost,devFund),0,true); // go to pool 95%
407       cards.setCoinBalance(owner,devFund,0,true);  
408     }
409     require(cards.balanceOf(msg.sender) >= coinCost);  
410     cards.updatePlayersCoinByPurchase(msg.sender, coinCost);
411 
412     upgradeUnitMultipliers(msg.sender, upgradeClass, unitId, upgradeValue);  
413     cards.setUpgradesOwned(msg.sender,upgradeId); //upgrade cards level
414 
415     UpgradeCardBought(msg.sender, upgradeId);
416   }
417 
418   // Allows someone to send ether and obtain the token
419   function buyRareItem(uint256 rareId) external payable {
420     require(cards.getGameStarted());        
421     address previousOwner = rare.getRareItemsOwner(rareId); 
422     require(previousOwner != 0);
423     require(msg.sender!=previousOwner);  // can not buy from itself
424     
425     uint256 ethCost = rare.getRareItemsPrice(rareId);
426     uint256 totalCost = SafeMath.add(cards.coinBalanceOf(msg.sender,0),msg.value);
427     require(totalCost >= ethCost); 
428         
429     // We have to claim buyer/sellder's goo before updating their production values 
430     cards.updatePlayersCoinByOut(msg.sender);
431     cards.updatePlayersCoinByOut(previousOwner);
432 
433     uint256 upgradeClass;
434     uint256 unitId;
435     uint256 upgradeValue;
436     (,,,,upgradeClass, unitId, upgradeValue) = rare.getRareInfo(rareId);
437     
438     upgradeUnitMultipliers(msg.sender, upgradeClass, unitId, upgradeValue); 
439     removeUnitMultipliers(previousOwner, upgradeClass, unitId, upgradeValue); 
440 
441     // Splitbid/Overbid
442     if (ethCost > msg.value) {
443       cards.setCoinBalance(msg.sender,SafeMath.sub(ethCost,msg.value),0,false);
444     } else if (msg.value > ethCost) {
445       // Store overbid in their balance
446       cards.setCoinBalance(msg.sender,SafeMath.sub(msg.value,ethCost),0,true);
447     }  
448     // Distribute ethCost
449     uint256 devFund = uint256(SafeMath.div(ethCost, 20)); // 5% fee on purchases (marketing, gameplay & maintenance) 
450     uint256 dividends = uint256(SafeMath.div(ethCost,20)); // 5% goes to pool 
451 
452     cards.setTotalEtherPool(dividends,0,true);
453     cards.setCoinBalance(owner,devFund,0,true); 
454         
455     // Transfer / update rare item
456     rare.transferToken(previousOwner,msg.sender,rareId); 
457     rare.setRarePrice(rareId,SafeMath.div(SafeMath.mul(ethCost,5),4));
458 
459     cards.setCoinBalance(previousOwner,SafeMath.sub(ethCost,SafeMath.add(dividends,devFund)),0,true);
460 
461     //players
462     if (cards.getUintsOwnerCount(msg.sender)<=0) {
463       cards.AddPlayers(msg.sender);
464     }
465    
466     cards.setUintsOwnerCount(msg.sender,1,true);
467     cards.setUintsOwnerCount(previousOwner,1,false);
468 
469     //tell the world
470     BuyRareCard(msg.sender, previousOwner, rareId, ethCost);
471   }
472   
473   /// sell out cards ,upgrade cards can not be sold
474   function sellCards(uint256 unitId, uint256 amount) external {
475     require(cards.getGameStarted());
476     uint256 existing = cards.getOwnedCount(msg.sender,unitId);
477     require(existing >= amount && amount>0); 
478     existing = SafeMath.sub(existing,amount);
479 
480     uint256 coinChange;
481     uint256 decreaseCoin;
482     uint256 schemaUnitId;
483     uint256 coinProduction;
484     uint256 coinCost;
485     uint256 ethCost;
486     bool sellable;
487     if (unitId>=40) {
488       (schemaUnitId,coinCost,ethCost, sellable) = schema.getBattleCardInfo(unitId, existing, amount);
489     } else {
490       (schemaUnitId, coinProduction, coinCost, ethCost, sellable) = schema.getCardInfo(unitId, existing, amount);
491     }
492     if (ethCost>0) {
493       require(unitsOwnedOfEth[msg.sender][unitId]>=amount);
494     }
495     //cards can be sold
496     require(sellable);
497     if (coinCost>0) {
498       coinChange = SafeMath.add(cards.balanceOfUnclaimed(msg.sender), SafeMath.div(SafeMath.mul(coinCost,70),100)); // Claim unsaved goo whilst here
499     } else {
500       coinChange = cards.balanceOfUnclaimed(msg.sender); //if 0
501     }
502 
503     cards.setLastJadeSaveTime(msg.sender); 
504     cards.setRoughSupply(coinChange);  
505     cards.setJadeCoin(msg.sender, coinChange, true); //  70% to users
506 
507     decreaseCoin = cards.getUnitsInProduction(msg.sender, unitId, amount); 
508     
509     if (coinProduction > 0) { 
510       cards.reducePlayersJadeProduction(msg.sender, decreaseCoin);
511       //reduct production
512       cards.setUintCoinProduction(msg.sender,unitId,decreaseCoin,false); 
513     }
514 
515     if (ethCost > 0) { // Premium units sell for 70% of buy cost
516       cards.setCoinBalance(msg.sender,SafeMath.div(SafeMath.mul(ethCost,70),100),0,true);
517     }
518 
519     cards.setOwnedCount(msg.sender,unitId,amount,false); //subscriber
520     cards.setUintsOwnerCount(msg.sender,amount,false);
521     if (ethCost>0) {
522       unitsOwnedOfEth[msg.sender][unitId] = SafeMath.sub(unitsOwnedOfEth[msg.sender][unitId],amount);
523     }
524     //tell the world
525     UnitSold(msg.sender, unitId, amount);
526   }
527 
528   // withraw ether
529   function withdrawAmount (uint256 _amount) public onlyOwner {
530     require(_amount<= this.balance);
531     owner.transfer(_amount);
532   }
533    /// withdraw ether to wallet
534   function withdrawEtherFromTrade(uint256 amount) external {
535     require(amount <= cards.coinBalanceOf(msg.sender,0));
536     cards.setCoinBalance(msg.sender,amount,0,false);
537     msg.sender.transfer(amount);
538   }
539 
540   function getCanSellUnit(address _address,uint256 unitId) external view returns (uint256) {
541     return unitsOwnedOfEth[_address][unitId];
542   }
543 }