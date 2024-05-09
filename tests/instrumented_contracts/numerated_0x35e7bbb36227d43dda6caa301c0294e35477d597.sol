1 pragma solidity ^0.4.18;
2 /* ==================================================================== */
3 /* Copyright (c) 2018 The MagicAcademy Project.  All rights reserved.
4 /* 
5 /* https://www.magicacademy.io One of the world's first idle strategy games of blockchain 
6 /*  
7 /* authors rainy@livestar.com/fanny.zheng@livestar.com
8 /*                 
9 /* ==================================================================== */
10 
11 /**
12  * @title Ownable
13  * @dev The Ownable contract has an owner address, and provides basic authorization control
14  * functions, this simplifies the implementation of "user permissions".
15  */
16 contract Ownable {
17   address public owner;
18 
19   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21   /*
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   function Ownable() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to transfer control of the contract to a newOwner.
39    * @param newOwner The address to transfer ownership to.
40    */
41   function transferOwnership(address newOwner) public onlyOwner {
42     require(newOwner != address(0));
43     OwnershipTransferred(owner, newOwner);
44     owner = newOwner;
45   }
46 }
47 library SafeMath {
48 
49   /**
50   * @dev Multiplies two numbers, throws on overflow.
51   */
52   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53     if (a == 0) {
54       return 0;
55     }
56     uint256 c = a * b;
57     assert(c / a == b);
58     return c;
59   }
60 
61   /**
62   * @dev Integer division of two numbers, truncating the quotient.
63   */
64   function div(uint256 a, uint256 b) internal pure returns (uint256) {
65     // assert(b > 0); // Solidity automatically throws when dividing by 0
66     uint256 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68     return c;
69   }
70 
71   /**
72   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
73   */
74   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75     assert(b <= a);
76     return a - b;
77   }
78 
79   /**
80   * @dev Adds two numbers, throws on overflow.
81   */
82   function add(uint256 a, uint256 b) internal pure returns (uint256) {
83     uint256 c = a + b;
84     assert(c >= a);
85     return c;
86   }
87 }
88 
89 interface CardsInterface {
90     function getJadeProduction(address player) external constant returns (uint256);
91     function getUpgradeValue(address player, uint256 upgradeClass, uint256 unitId, uint256 upgradeValue) external view returns (uint256);
92     function getGameStarted() external constant returns (bool);
93     function balanceOf(address player) external constant returns(uint256);
94     function balanceOfUnclaimed(address player) external constant returns (uint256);
95     function coinBalanceOf(address player,uint8 itype) external constant returns(uint256);
96 
97     function setCoinBalance(address player, uint256 eth, uint8 itype, bool iflag) external;
98     function setJadeCoin(address player, uint256 coin, bool iflag) external;
99     function setJadeCoinZero(address player) external;
100 
101     function setLastJadeSaveTime(address player) external;
102     function setRoughSupply(uint256 iroughSupply) external;
103 
104     function updatePlayersCoinByPurchase(address player, uint256 purchaseCost) external;
105     function updatePlayersCoinByOut(address player) external;
106 
107     function increasePlayersJadeProduction(address player, uint256 increase) external;
108     function reducePlayersJadeProduction(address player, uint256 decrease) external;
109 
110     function getUintsOwnerCount(address _address) external view returns (uint256);
111     function setUintsOwnerCount(address _address, uint256 amount, bool iflag) external;
112 
113     function getOwnedCount(address player, uint256 cardId) external view returns (uint256);
114     function setOwnedCount(address player, uint256 cardId, uint256 amount, bool iflag) external;
115 
116     function getUpgradesOwned(address player, uint256 upgradeId) external view returns (uint256);
117     function setUpgradesOwned(address player, uint256 upgradeId) external;
118     
119     function getTotalEtherPool(uint8 itype) external view returns (uint256);
120     function setTotalEtherPool(uint256 inEth, uint8 itype, bool iflag) external;
121 
122     function setNextSnapshotTime(uint256 iTime) external;
123     function getNextSnapshotTime() external view;
124 
125     function AddPlayers(address _address) external;
126     function getTotalUsers()  external view returns (uint256);
127     function getRanking() external view returns (address[] addr, uint256[] _arr);
128     function getAttackRanking() external view returns (address[] addr, uint256[] _arr);
129 
130     function getUnitsProduction(address player, uint256 cardId, uint256 amount) external constant returns (uint256);
131 
132     function getUnitCoinProductionIncreases(address _address, uint256 cardId) external view returns (uint256);
133     function setUnitCoinProductionIncreases(address _address, uint256 cardId, uint256 iValue,bool iflag) external;
134      function getUnitCoinProductionMultiplier(address _address, uint256 cardId) external view returns (uint256);
135     function setUnitCoinProductionMultiplier(address _address, uint256 cardId, uint256 iValue,bool iflag) external;
136      function setUnitAttackIncreases(address _address, uint256 cardId, uint256 iValue,bool iflag) external;
137     function setUnitAttackMultiplier(address _address, uint256 cardId, uint256 iValue,bool iflag) external;
138     function setUnitDefenseIncreases(address _address, uint256 cardId, uint256 iValue,bool iflag) external;
139     function setunitDefenseMultiplier(address _address, uint256 cardId, uint256 iValue,bool iflag) external;
140     
141     function setUnitJadeStealingIncreases(address _address, uint256 cardId, uint256 iValue,bool iflag) external;
142     function setUnitJadeStealingMultiplier(address _address, uint256 cardId, uint256 iValue,bool iflag) external;
143 
144     function setUintCoinProduction(address _address, uint256 cardId, uint256 iValue,bool iflag) external;
145     function getUintCoinProduction(address _address, uint256 cardId) external returns (uint256);
146 
147     function getUnitsInProduction(address player, uint256 unitId, uint256 amount) external constant returns (uint256);
148     function getPlayersBattleStats(address player) public constant returns (
149     uint256 attackingPower, 
150     uint256 defendingPower, 
151     uint256 stealingPower,
152     uint256 battlePower); 
153 }
154 
155 interface GameConfigInterface {
156   function getMaxCAP() external returns (uint256);
157   function unitCoinProduction(uint256 cardId) external constant returns (uint256);
158   function unitPLATCost(uint256 cardId) external constant returns (uint256);
159   function getCostForCards(uint256 cardId, uint256 existing, uint256 amount) external constant returns (uint256);
160   function getCostForBattleCards(uint256 cardId, uint256 existing, uint256 amount) external constant returns (uint256);
161   function unitBattlePLATCost(uint256 cardId) external constant returns (uint256);
162   function getUpgradeCardsInfo(uint256 upgradecardId,uint256 existing) external constant returns (
163     uint256 coinCost, 
164     uint256 ethCost, 
165     uint256 upgradeClass, 
166     uint256 cardId, 
167     uint256 upgradeValue,
168     uint256 platCost
169   );
170  function getCardInfo(uint256 cardId, uint256 existing, uint256 amount) external constant returns (uint256, uint256, uint256, uint256, bool);
171  function getBattleCardInfo(uint256 cardId, uint256 existing, uint256 amount) external constant returns (uint256, uint256, uint256, bool);
172 }
173 interface RareInterface {
174   function getRareItemsOwner(uint256 rareId) external view returns (address);
175   function getRareItemsPrice(uint256 rareId) external view returns (uint256);
176   function getRareItemsPLATPrice(uint256 rareId) external view returns (uint256);
177    function getRarePLATInfo(uint256 _tokenId) external view returns (
178     uint256 sellingPrice,
179     address owner,
180     uint256 nextPrice,
181     uint256 rareClass,
182     uint256 cardId,
183     uint256 rareValue
184   );
185   function transferToken(address _from, address _to, uint256 _tokenId) external;
186   function setRarePrice(uint256 _rareId, uint256 _price) external;
187 }
188 
189 contract BitGuildHelper is Ownable {
190   //data contract
191   CardsInterface public cards ;
192   GameConfigInterface public schema;
193   RareInterface public rare;
194 
195   function setCardsAddress(address _address) external onlyOwner {
196     cards = CardsInterface(_address);
197   }
198 
199    //normal cards
200   function setConfigAddress(address _address) external onlyOwner {
201     schema = GameConfigInterface(_address);
202   }
203 
204   //rare cards
205   function setRareAddress(address _address) external onlyOwner {
206     rare = RareInterface(_address);
207   }
208   
209 /// add multiplier
210   function upgradeUnitMultipliers(address player, uint256 upgradeClass, uint256 unitId, uint256 upgradeValue) internal {
211     uint256 productionGain;
212     if (upgradeClass == 0) {
213       cards.setUnitCoinProductionIncreases(player, unitId, upgradeValue,true);
214       productionGain = (cards.getOwnedCount(player,unitId) * upgradeValue * (10 + cards.getUnitCoinProductionMultiplier(player,unitId)));
215       cards.setUintCoinProduction(player,unitId,productionGain,true); 
216       cards.increasePlayersJadeProduction(player,productionGain);
217     } else if (upgradeClass == 1) {
218       cards.setUnitCoinProductionMultiplier(player,unitId,upgradeValue,true);
219       productionGain = (cards.getOwnedCount(player,unitId) * upgradeValue * (schema.unitCoinProduction(unitId) + cards.getUnitCoinProductionIncreases(player,unitId)));
220       cards.setUintCoinProduction(player,unitId,productionGain,true);
221       cards.increasePlayersJadeProduction(player,productionGain);
222     } else if (upgradeClass == 2) {
223       cards.setUnitAttackIncreases(player,unitId,upgradeValue,true);
224     } else if (upgradeClass == 3) {
225       cards.setUnitAttackMultiplier(player,unitId,upgradeValue,true);
226     } else if (upgradeClass == 4) {
227       cards.setUnitDefenseIncreases(player,unitId,upgradeValue,true);
228     } else if (upgradeClass == 5) {
229       cards.setunitDefenseMultiplier(player,unitId,upgradeValue,true);
230     } else if (upgradeClass == 6) {
231       cards.setUnitJadeStealingIncreases(player,unitId,upgradeValue,true);
232     } else if (upgradeClass == 7) {
233       cards.setUnitJadeStealingMultiplier(player,unitId,upgradeValue,true);
234     }
235   }
236   /// move multipliers
237   function removeUnitMultipliers(address player, uint256 upgradeClass, uint256 unitId, uint256 upgradeValue) internal {
238     uint256 productionLoss;
239     if (upgradeClass == 0) {
240       cards.setUnitCoinProductionIncreases(player, unitId, upgradeValue,false);
241       productionLoss = (cards.getOwnedCount(player,unitId) * upgradeValue * (10 + cards.getUnitCoinProductionMultiplier(player,unitId)));
242       cards.setUintCoinProduction(player,unitId,productionLoss,false); 
243       cards.reducePlayersJadeProduction(player, productionLoss);
244     } else if (upgradeClass == 1) {
245       cards.setUnitCoinProductionMultiplier(player,unitId,upgradeValue,false);
246       productionLoss = (cards.getOwnedCount(player,unitId) * upgradeValue * (schema.unitCoinProduction(unitId) + cards.getUnitCoinProductionIncreases(player,unitId)));
247       cards.setUintCoinProduction(player,unitId,productionLoss,false); 
248       cards.reducePlayersJadeProduction(player, productionLoss);
249     } else if (upgradeClass == 2) {
250       cards.setUnitAttackIncreases(player,unitId,upgradeValue,false);
251     } else if (upgradeClass == 3) {
252       cards.setUnitAttackMultiplier(player,unitId,upgradeValue,false);
253     } else if (upgradeClass == 4) {
254       cards.setUnitDefenseIncreases(player,unitId,upgradeValue,false);
255     } else if (upgradeClass == 5) {
256       cards.setunitDefenseMultiplier(player,unitId,upgradeValue,false);
257     } else if (upgradeClass == 6) { 
258       cards.setUnitJadeStealingIncreases(player,unitId,upgradeValue,false);
259     } else if (upgradeClass == 7) {
260       cards.setUnitJadeStealingMultiplier(player,unitId,upgradeValue,false);
261     }
262   }
263 }
264 
265 interface BitGuildTokenInterface { // implements ERC20Interface
266   function totalSupply() public constant returns (uint);
267   function balanceOf(address tokenOwner) public constant returns (uint balance);
268   function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
269   function transfer(address to, uint tokens) public returns (bool success);
270   function approve(address spender, uint tokens) public returns (bool success);
271   function transferFrom(address from, address to, uint tokens) public returns (bool success);
272 
273   event Transfer(address indexed from, address indexed to, uint tokens);
274   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
275 }
276 /// @notice Purchase on BitGuild
277 contract BitGuildTrade is BitGuildHelper {
278   BitGuildTokenInterface public tokenContract;
279 
280   event UnitBought(address player, uint256 unitId, uint256 amount);
281   event UpgradeCardBought(address player, uint256 upgradeId);
282   event BuyRareCard(address player, address previous, uint256 rareId,uint256 iPrice);
283   event UnitSold(address player, uint256 unitId, uint256 amount);
284 
285   mapping(address => mapping(uint256 => uint256)) unitsOwnedOfPLAT; //cards bought through plat
286   function() external payable {
287     revert();
288   }
289   function setBitGuildToken(address _tokenContract) external {
290     tokenContract = BitGuildTokenInterface(_tokenContract);
291   } 
292 
293   function kill() public onlyOwner {
294     tokenContract.transferFrom(this, msg.sender, tokenContract.balanceOf(this));
295     selfdestruct(msg.sender); //end execution, destroy current contract and send funds to a
296   }  
297   /// @notice Returns all the relevant information about a specific tokenId.
298   /// val1:flag,val2:id,val3:amount
299   function _getExtraParam(bytes _extraData) private pure returns(uint256 val1,uint256 val2,uint256 val3) {
300     if (_extraData.length == 2) {
301       val1 = uint256(_extraData[0]);
302       val2 = uint256(_extraData[1]);
303       val3 = 1; 
304     } else if (_extraData.length == 3) {
305       val1 = uint256(_extraData[0]);
306       val2 = uint256(_extraData[1]);
307       val3 = uint256(_extraData[2]);
308     }
309     
310   }
311   
312   function receiveApproval(address _player, uint256 _value, address _tokenContractAddr, bytes _extraData) external {
313     require(msg.sender == _tokenContractAddr);
314     require(_extraData.length >=1);
315     require(tokenContract.transferFrom(_player, address(this), _value));
316     uint256 flag;
317     uint256 unitId;
318     uint256 amount;
319     (flag,unitId,amount) = _getExtraParam(_extraData);
320 
321     if (flag==1) {
322       buyPLATCards(_player, _value, unitId, amount);  // 1-39
323     } else if (flag==3) {
324       buyUpgradeCard(_player, _value, unitId);  // >=1
325     } else if (flag==4) {
326       buyRareItem(_player, _value, unitId); //rarecard
327     } 
328   } 
329 
330   function buyPLATCards(address _player, uint256 _platValue, uint256 _cardId, uint256 _amount) internal {
331     require(cards.getGameStarted());
332     require(_amount>=1);
333     uint256 existing = cards.getOwnedCount(_player,_cardId);
334     require(existing < schema.getMaxCAP());    
335     
336     uint256 iAmount;
337     if (SafeMath.add(existing, _amount) > schema.getMaxCAP()) {
338       iAmount = SafeMath.sub(schema.getMaxCAP(),existing);
339     } else {
340       iAmount = _amount;
341     }
342     uint256 coinProduction;
343     uint256 coinCost;
344     uint256 ethCost;
345 
346     if (_cardId>=1 && _cardId<=39) {
347       coinProduction = schema.unitCoinProduction(_cardId);
348       coinCost = schema.getCostForCards(_cardId, existing, iAmount);
349       ethCost = SafeMath.mul(schema.unitPLATCost(_cardId),iAmount);  // get platprice
350     } else if (_cardId>=40) {
351       coinCost = schema.getCostForBattleCards(_cardId, existing, iAmount);
352       ethCost = SafeMath.mul(schema.unitBattlePLATCost(_cardId),iAmount);  // get platprice
353     }
354     require(ethCost>0);
355     require(SafeMath.add(cards.coinBalanceOf(_player,1),_platValue) >= ethCost);
356     require(cards.balanceOf(_player) >= coinCost);   
357 
358     // Update players jade  
359     cards.updatePlayersCoinByPurchase(_player, coinCost);
360 
361     if (ethCost > _platValue) {
362       cards.setCoinBalance(_player,SafeMath.sub(ethCost,_platValue),1,false);
363     } else if (_platValue > ethCost) {
364       // Store overbid in their balance
365       cards.setCoinBalance(_player,SafeMath.sub(_platValue,ethCost),1,true);
366     } 
367 
368     uint256 devFund = uint256(SafeMath.div(ethCost,20)); // 5% fee
369     cards.setTotalEtherPool(uint256(SafeMath.div(ethCost,4)),1,true);  // 20% to pool
370     cards.setCoinBalance(owner,devFund,1,true);  
371     
372     if (coinProduction > 0) {
373       cards.increasePlayersJadeProduction(_player, cards.getUnitsProduction(_player, _cardId, iAmount)); 
374       cards.setUintCoinProduction(_player,_cardId,cards.getUnitsProduction(_player, _cardId, iAmount),true); 
375     }
376     
377     if (cards.getUintsOwnerCount(_player)<=0) {
378       cards.AddPlayers(_player);
379     }
380     cards.setUintsOwnerCount(_player,iAmount, true);
381     cards.setOwnedCount(_player,_cardId,iAmount,true);
382     unitsOwnedOfPLAT[_player][_cardId] = SafeMath.add(unitsOwnedOfPLAT[_player][_cardId],iAmount);
383     //event
384     UnitBought(_player, _cardId, iAmount);
385   }
386 
387   /// upgrade cards-- jade + plat
388   function buyUpgradeCard(address _player, uint256 _platValue,uint256 _upgradeId) internal {
389     require(cards.getGameStarted());
390     require(_upgradeId>=1);
391     uint256 existing = cards.getUpgradesOwned(_player,_upgradeId);
392     require(existing<=5);  // v1 - v6
393     uint256 coinCost;
394     uint256 ethCost;
395     uint256 upgradeClass;
396     uint256 unitId;
397     uint256 upgradeValue;
398     uint256 platCost;
399     (coinCost, ethCost, upgradeClass, unitId, upgradeValue,platCost) = schema.getUpgradeCardsInfo(_upgradeId,existing);
400 
401     require(platCost>0);
402     if (platCost > 0) {
403       require(SafeMath.add(cards.coinBalanceOf(_player,1),_platValue) >= platCost); 
404 
405       if (platCost > _platValue) { // They can use their balance instead
406         cards.setCoinBalance(_player, SafeMath.sub(platCost,_platValue),1,false);
407       } else if (platCost < _platValue) {  
408         cards.setCoinBalance(_player,SafeMath.sub(_platValue,platCost),1,true);
409     } 
410       
411 
412       // defund 5%，upgrade card can not be sold，
413       uint256 devFund = uint256(SafeMath.div(platCost, 20)); // 5% fee on purchases (marketing, gameplay & maintenance)
414       cards.setTotalEtherPool(SafeMath.sub(platCost,devFund),1,true); // Rest goes to div pool (Can't sell upgrades)
415       cards.setCoinBalance(owner,devFund,1,true);  
416     }
417         
418      // Update 
419     require(cards.balanceOf(_player) >= coinCost);  
420     cards.updatePlayersCoinByPurchase(_player, coinCost);
421     
422     //add weight
423     upgradeUnitMultipliers(_player, upgradeClass, unitId, upgradeValue);  
424     cards.setUpgradesOwned(_player,_upgradeId); // upgrade level up
425 
426      //add user to userlist
427     if (cards.getUintsOwnerCount(_player)<=0) {
428       cards.AddPlayers(_player);
429     }
430  
431     UpgradeCardBought(_player, _upgradeId);
432   }
433 
434   // Allows someone to send ether and obtain the token
435   function buyRareItem(address _player, uint256 _platValue,uint256 _rareId) internal {
436     require(cards.getGameStarted());        
437     address previousOwner = rare.getRareItemsOwner(_rareId);  // rare card
438     require(previousOwner != 0);
439     require(_player!=previousOwner);  // can not buy from itself
440     
441     uint256 ethCost = rare.getRareItemsPLATPrice(_rareId); // get plat cost
442     uint256 totalCost = SafeMath.add(cards.coinBalanceOf(_player,1),_platValue);
443     require(totalCost >= ethCost); 
444     // We have to claim buyer/sellder's goo before updating their production values 
445     cards.updatePlayersCoinByOut(_player);
446     cards.updatePlayersCoinByOut(previousOwner);
447 
448     uint256 upgradeClass;
449     uint256 unitId;
450     uint256 upgradeValue;
451     (,,,,upgradeClass, unitId, upgradeValue) = rare.getRarePLATInfo(_rareId);
452     
453     // modify weight
454     upgradeUnitMultipliers(_player, upgradeClass, unitId, upgradeValue); 
455     removeUnitMultipliers(previousOwner, upgradeClass, unitId, upgradeValue); 
456 
457     // Splitbid/Overbid
458     if (ethCost > _platValue) {
459       cards.setCoinBalance(_player,SafeMath.sub(ethCost,_platValue),1,false);
460     } else if (_platValue > ethCost) {
461       // Store overbid in their balance
462       cards.setCoinBalance(_player,SafeMath.sub(_platValue,ethCost),1,true);
463     }  
464     // Distribute ethCost  uint256 devFund = ethCost / 50; 
465     uint256 devFund = uint256(SafeMath.div(ethCost, 20)); // 5% fee on purchases (marketing, gameplay & maintenance)  抽成2%
466     uint256 dividends = uint256(SafeMath.div(ethCost,20)); // 5% goes to pool 
467 
468     cards.setTotalEtherPool(dividends,1,true);  // 5% to pool
469     cards.setCoinBalance(owner,devFund,1,true);  // 5% fee
470         
471     // Transfer / update rare item
472     rare.transferToken(previousOwner,_player,_rareId); 
473     rare.setRarePrice(_rareId,SafeMath.div(SafeMath.mul(rare.getRareItemsPrice(_rareId),5),4));
474     
475     cards.setCoinBalance(previousOwner,SafeMath.sub(ethCost,SafeMath.add(dividends,devFund)),1,true);
476     
477     if (cards.getUintsOwnerCount(_player)<=0) {
478       cards.AddPlayers(_player);
479     }
480    
481     cards.setUintsOwnerCount(_player,1,true);
482     cards.setUintsOwnerCount(previousOwner,1,true);
483 
484     //tell the world
485     BuyRareCard(_player, previousOwner, _rareId, ethCost);
486   }
487 
488   /// refunds 75% since no transfer between bitguild and player,no need to call approveAndCall
489   function sellCards( uint256 _unitId, uint256 _amount) external {
490     require(cards.getGameStarted());
491     uint256 existing = cards.getOwnedCount(msg.sender,_unitId);
492     require(existing >= _amount && _amount>0); 
493     existing = SafeMath.sub(existing,_amount);
494     uint256 coinChange;
495     uint256 decreaseCoin;
496     uint256 schemaUnitId;
497     uint256 coinProduction;
498     uint256 coinCost;
499     uint256 ethCost;
500     bool sellable;
501     if (_unitId>=40) { // upgrade card
502       (schemaUnitId,coinCost,, sellable) = schema.getBattleCardInfo(_unitId, existing, _amount);
503       ethCost = SafeMath.mul(schema.unitBattlePLATCost(_unitId),_amount);
504     } else {
505       (schemaUnitId, coinProduction, coinCost, , sellable) = schema.getCardInfo(_unitId, existing, _amount);
506       ethCost = SafeMath.mul(schema.unitPLATCost(_unitId),_amount); // plat 
507     }
508     require(sellable);  // can be refunded
509     if (ethCost>0) {
510       require(unitsOwnedOfPLAT[msg.sender][_unitId]>=_amount);
511     }
512     if (coinCost>0) {
513       coinChange = SafeMath.add(cards.balanceOfUnclaimed(msg.sender), SafeMath.div(SafeMath.mul(coinCost,70),100)); // Claim unsaved goo whilst here
514     } else {
515       coinChange = cards.balanceOfUnclaimed(msg.sender); 
516     }
517 
518     cards.setLastJadeSaveTime(msg.sender); 
519     cards.setRoughSupply(coinChange);  
520     cards.setJadeCoin(msg.sender, coinChange, true); // refund 75% Jadecoin to player 
521 
522     decreaseCoin = cards.getUnitsInProduction(msg.sender, _unitId, _amount);
523   
524     if (coinProduction > 0) { 
525       cards.reducePlayersJadeProduction(msg.sender, decreaseCoin);
526       //update the speed of jade minning
527       cards.setUintCoinProduction(msg.sender,_unitId,decreaseCoin,false); 
528     }
529 
530     if (ethCost > 0) { // Premium units sell for 75% of buy cost
531       cards.setCoinBalance(msg.sender,SafeMath.div(SafeMath.mul(ethCost,70),100),1,true);
532     }
533 
534     cards.setOwnedCount(msg.sender,_unitId,_amount,false); 
535     cards.setUintsOwnerCount(msg.sender,_amount,false);
536     if (ethCost>0) {
537       unitsOwnedOfPLAT[msg.sender][_unitId] = SafeMath.sub(unitsOwnedOfPLAT[msg.sender][_unitId],_amount);
538     }
539     //tell the world
540     UnitSold(msg.sender, _unitId, _amount);
541   }
542 
543   //@notice for player withdraw
544   function withdrawEtherFromTrade(uint256 amount) external {
545     require(amount <= cards.coinBalanceOf(msg.sender,1));
546     cards.setCoinBalance(msg.sender,amount,1,false);
547     tokenContract.transfer(msg.sender,amount);
548   } 
549 
550   //@notice withraw all PLAT by dev
551   function withdrawToken(uint256 amount) external onlyOwner {
552     uint256 balance = tokenContract.balanceOf(this);
553     require(balance > 0 && balance >= amount);
554     cards.setCoinBalance(msg.sender,amount,1,false);
555     tokenContract.transfer(msg.sender, amount);
556   }
557 
558   function getCanSellUnit(address _address, uint256 unitId) external view returns (uint256) {
559     return unitsOwnedOfPLAT[_address][unitId];
560   }
561 }