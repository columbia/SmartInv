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
75 interface BitGuildTokenInterface { // implements ERC20Interface
76   function totalSupply() public constant returns (uint);
77   function balanceOf(address tokenOwner) public constant returns (uint balance);
78   function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
79   function transfer(address to, uint tokens) public returns (bool success);
80   function approve(address spender, uint tokens) public returns (bool success);
81   function transferFrom(address from, address to, uint tokens) public returns (bool success);
82 
83   event Transfer(address indexed from, address indexed to, uint tokens);
84   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
85 }
86 
87 interface CardsInterface {
88   function getGameStarted() external constant returns (bool);
89   function getOwnedCount(address player, uint256 cardId) external view returns (uint256);
90   function getMaxCap(address _addr,uint256 _cardId) external view returns (uint256);
91   function upgradeUnitMultipliers(address player, uint256 upgradeClass, uint256 unitId, uint256 upgradeValue) external;
92   function removeUnitMultipliers(address player, uint256 upgradeClass, uint256 unitId, uint256 upgradeValue) external;
93   function balanceOf(address player) public constant returns(uint256);
94   function coinBalanceOf(address player,uint8 itype) external constant returns(uint256);
95   function updatePlayersCoinByPurchase(address player, uint256 purchaseCost) external;
96   function getUnitsProduction(address player, uint256 unitId, uint256 amount) external constant returns (uint256);
97   function increasePlayersJadeProduction(address player, uint256 increase) public;
98   function setUintCoinProduction(address _address, uint256 cardId, uint256 iValue, bool iflag) external;
99   function getUintsOwnerCount(address _address) external view returns (uint256);
100   function AddPlayers(address _address) external;
101   function setUintsOwnerCount(address _address, uint256 amount, bool iflag) external;
102   function setOwnedCount(address player, uint256 cardId, uint256 amount, bool iflag) external;
103   function setCoinBalance(address player, uint256 eth, uint8 itype, bool iflag) external;
104   function setTotalEtherPool(uint256 inEth, uint8 itype, bool iflag) external;
105   function getUpgradesOwned(address player, uint256 upgradeId) external view returns (uint256);
106   function setUpgradesOwned(address player, uint256 upgradeId) external;
107   function updatePlayersCoinByOut(address player) external;
108   function balanceOfUnclaimed(address player) public constant returns (uint256);
109   function setLastJadeSaveTime(address player) external;
110   function setRoughSupply(uint256 iroughSupply) external;
111   function setJadeCoin(address player, uint256 coin, bool iflag) external;
112   function getUnitsInProduction(address player, uint256 unitId, uint256 amount) external constant returns (uint256);
113   function reducePlayersJadeProduction(address player, uint256 decrease) public;
114 }
115 interface GameConfigInterface {
116   function unitCoinProduction(uint256 cardId) external constant returns (uint256);
117   function unitPLATCost(uint256 cardId) external constant returns (uint256);
118   function getCostForCards(uint256 cardId, uint256 existing, uint256 amount) external constant returns (uint256);
119   function getCostForBattleCards(uint256 cardId, uint256 existing, uint256 amount) external constant returns (uint256);
120   function unitBattlePLATCost(uint256 cardId) external constant returns (uint256);
121   function getUpgradeCardsInfo(uint256 upgradecardId,uint256 existing) external constant returns (
122     uint256 coinCost, 
123     uint256 ethCost, 
124     uint256 upgradeClass, 
125     uint256 cardId, 
126     uint256 upgradeValue,
127     uint256 platCost
128   );
129  function getCardInfo(uint256 cardId, uint256 existing, uint256 amount) external constant returns (uint256, uint256, uint256, uint256, bool);
130  function getBattleCardInfo(uint256 cardId, uint256 existing, uint256 amount) external constant returns (uint256, uint256, uint256, bool);
131 
132 }
133 interface RareInterface {
134   function getRareItemsOwner(uint256 rareId) external view returns (address);
135   function getRareItemsPrice(uint256 rareId) external view returns (uint256);
136   function getRareItemsPLATPrice(uint256 rareId) external view returns (uint256);
137    function getRarePLATInfo(uint256 _tokenId) external view returns (
138     uint256 sellingPrice,
139     address owner,
140     uint256 nextPrice,
141     uint256 rareClass,
142     uint256 cardId,
143     uint256 rareValue
144   );
145   function transferToken(address _from, address _to, uint256 _tokenId) external;
146   function setRarePrice(uint256 _rareId, uint256 _price) external;
147 }
148 
149 contract BitGuildTrade is AccessAdmin {
150   BitGuildTokenInterface public tokenContract;
151    //data contract
152   CardsInterface public cards ;
153   GameConfigInterface public schema;
154   RareInterface public rare;
155 
156   
157   function BitGuildTrade() public {
158     setAdminContract(msg.sender,true);
159     setActionContract(msg.sender,true);
160   }
161 
162   event UnitBought(address player, uint256 unitId, uint256 amount);
163   event UpgradeCardBought(address player, uint256 upgradeId);
164   event BuyRareCard(address player, address previous, uint256 rareId,uint256 iPrice);
165   event UnitSold(address player, uint256 unitId, uint256 amount);
166 
167   mapping(address => mapping(uint256 => uint256)) unitsOwnedOfPLAT; //cards bought through plat
168   function() external payable {
169     revert();
170   }
171   function setBitGuildToken(address _tokenContract) external onlyOwner {
172     tokenContract = BitGuildTokenInterface(_tokenContract);
173   } 
174 
175   function setCardsAddress(address _address) external onlyOwner {
176     cards = CardsInterface(_address);
177   }
178 
179    //normal cards
180   function setConfigAddress(address _address) external onlyOwner {
181     schema = GameConfigInterface(_address);
182   }
183 
184   //rare cards
185   function setRareAddress(address _address) external onlyOwner {
186     rare = RareInterface(_address);
187   }
188   function kill() public onlyOwner {
189     tokenContract.transferFrom(this, msg.sender, tokenContract.balanceOf(this));
190     selfdestruct(msg.sender); //end execution, destroy current contract and send funds to a
191   }  
192   /// @notice Returns all the relevant information about a specific tokenId.
193   /// val1:flag,val2:id,val3:amount
194   function _getExtraParam(bytes _extraData) private pure returns(uint256 val1,uint256 val2,uint256 val3) {
195     if (_extraData.length == 2) {
196       val1 = uint256(_extraData[0]);
197       val2 = uint256(_extraData[1]);
198       val3 = 1; 
199     } else if (_extraData.length == 3) {
200       val1 = uint256(_extraData[0]);
201       val2 = uint256(_extraData[1]);
202       val3 = uint256(_extraData[2]);
203     }  
204   }
205   
206   function receiveApproval(address _player, uint256 _value, address _tokenContractAddr, bytes _extraData) external {
207     require(msg.sender == _tokenContractAddr);
208     require(_extraData.length >=1);
209     require(tokenContract.transferFrom(_player, address(this), _value));
210     uint256 flag;
211     uint256 unitId;
212     uint256 amount;
213     (flag,unitId,amount) = _getExtraParam(_extraData);
214 
215     if (flag==1) {
216       buyPLATCards(_player, _value, unitId, amount);  // 1-39
217     } else if (flag==3) {
218       buyUpgradeCard(_player, _value, unitId);  // >=1
219     } else if (flag==4) {
220       buyRareItem(_player, _value, unitId); //rarecard
221     } 
222   } 
223 
224   /// buy normal cards via jade
225   function buyBasicCards(uint256 unitId, uint256 amount) external {
226     require(cards.getGameStarted());
227     require(amount>=1);
228     uint256 existing = cards.getOwnedCount(msg.sender,unitId);
229     uint256 total = SafeMath.add(existing, amount);
230     if (total > 99) { // Default unit limit
231       require(total <= cards.getMaxCap(msg.sender,unitId)); // Housing upgrades (allow more units)
232     }
233 
234     uint256 coinProduction;
235     uint256 coinCost;
236     uint256 ethCost;
237     if (unitId>=1 && unitId<=39) {    
238       (, coinProduction, coinCost, ethCost,) = schema.getCardInfo(unitId, existing, amount);
239     } else if (unitId>=40) {
240       (, coinCost, ethCost,) = schema.getBattleCardInfo(unitId, existing, amount);
241     }
242     require(cards.balanceOf(msg.sender) >= coinCost);
243     require(ethCost == 0); // Free ether unit
244         
245     // Update players jade 
246     cards.updatePlayersCoinByPurchase(msg.sender, coinCost);
247     ///****increase production***/
248     if (coinProduction > 0) {
249       cards.increasePlayersJadeProduction(msg.sender,cards.getUnitsProduction(msg.sender, unitId, amount)); 
250       cards.setUintCoinProduction(msg.sender,unitId,cards.getUnitsProduction(msg.sender, unitId, amount),true); 
251     }
252     //players
253     if (cards.getUintsOwnerCount(msg.sender)<=0) {
254       cards.AddPlayers(msg.sender);
255     }
256     cards.setUintsOwnerCount(msg.sender,amount,true);
257     cards.setOwnedCount(msg.sender,unitId,amount,true);
258     
259     UnitBought(msg.sender, unitId, amount);
260   }
261 
262   function buyBasicCards_Migrate(address _addr, uint256 _unitId, uint256 _amount) external onlyAdmin {
263     require(cards.getGameStarted());
264     require(_amount>=1);
265     uint256 existing = cards.getOwnedCount(_addr,_unitId);
266     uint256 total = SafeMath.add(existing, _amount);
267     if (total > 99) { // Default unit limit
268       require(total <= cards.getMaxCap(_addr,_unitId)); // Housing upgrades (allow more units)
269     }
270     require (_unitId == 41);
271     uint256 coinCost;
272     uint256 ethCost;
273     (, coinCost, ethCost,) = schema.getBattleCardInfo(_unitId, existing, _amount);
274     //players
275     if (cards.getUintsOwnerCount(_addr)<=0) {
276       cards.AddPlayers(_addr);
277     }
278     cards.setUintsOwnerCount(_addr,_amount,true);
279     cards.setOwnedCount(_addr,_unitId,_amount,true);
280     
281     UnitBought(_addr, _unitId, _amount);
282   }
283 
284   function buyPLATCards(address _player, uint256 _platValue, uint256 _cardId, uint256 _amount) internal {
285     require(cards.getGameStarted());
286     require(_amount>=1);
287     uint256 existing = cards.getOwnedCount(_player,_cardId);
288     uint256 total = SafeMath.add(existing, _amount);
289     if (total > 99) { // Default unit limit
290       require(total <= cards.getMaxCap(msg.sender,_cardId)); // Housing upgrades (allow more units)
291     }
292 
293     uint256 coinProduction;
294     uint256 coinCost;
295     uint256 ethCost;
296 
297     if (_cardId>=1 && _cardId<=39) {
298       coinProduction = schema.unitCoinProduction(_cardId);
299       coinCost = schema.getCostForCards(_cardId, existing, _amount);
300       ethCost = SafeMath.mul(schema.unitPLATCost(_cardId),_amount);  // get platprice
301     } else if (_cardId>=40) {
302       coinCost = schema.getCostForBattleCards(_cardId, existing, _amount);
303       ethCost = SafeMath.mul(schema.unitBattlePLATCost(_cardId),_amount);  // get platprice
304     }
305 
306     require(ethCost>0);
307     require(SafeMath.add(cards.coinBalanceOf(_player,1),_platValue) >= ethCost);
308     require(cards.balanceOf(_player) >= coinCost);   
309 
310     // Update players jade  
311     cards.updatePlayersCoinByPurchase(_player, coinCost);
312 
313     if (ethCost > _platValue) {
314       cards.setCoinBalance(_player,SafeMath.sub(ethCost,_platValue),1,false);
315     } else if (_platValue > ethCost) {
316       // Store overbid in their balance
317       cards.setCoinBalance(_player,SafeMath.sub(_platValue,ethCost),1,true);
318     } 
319 
320     uint256 devFund = uint256(SafeMath.div(ethCost,20)); // 5% fee
321     cards.setTotalEtherPool(uint256(SafeMath.div(ethCost,4)),1,true);  // 20% to pool
322     cards.setCoinBalance(owner,devFund,1,true);  
323     
324     if (coinProduction > 0) {
325       cards.increasePlayersJadeProduction(_player, cards.getUnitsProduction(_player, _cardId, _amount)); 
326       cards.setUintCoinProduction(_player,_cardId,cards.getUnitsProduction(_player, _cardId, _amount),true); 
327     }
328     
329     if (cards.getUintsOwnerCount(_player)<=0) {
330       cards.AddPlayers(_player);
331     }
332     cards.setUintsOwnerCount(_player,_amount, true);
333     cards.setOwnedCount(_player,_cardId,_amount,true);
334     unitsOwnedOfPLAT[_player][_cardId] = SafeMath.add(unitsOwnedOfPLAT[_player][_cardId],_amount);
335     //event
336     UnitBought(_player, _cardId, _amount);
337   }
338 
339   /// buy upgrade cards with ether/Jade
340   function buyUpgradeCard(uint256 upgradeId) external payable {
341     require(cards.getGameStarted());
342     require(upgradeId>=1);
343     uint256 existing = cards.getUpgradesOwned(msg.sender,upgradeId);
344     
345     uint256 coinCost;
346     uint256 ethCost;
347     uint256 upgradeClass;
348     uint256 unitId;
349     uint256 upgradeValue;
350     (coinCost, ethCost, upgradeClass, unitId, upgradeValue,) = schema.getUpgradeCardsInfo(upgradeId,existing);
351     if (upgradeClass<8) {
352       require(existing<=5); 
353     } else {
354       require(existing<=2); 
355     }
356     require (coinCost>0 && ethCost==0);
357     require(cards.balanceOf(msg.sender) >= coinCost);  
358     cards.updatePlayersCoinByPurchase(msg.sender, coinCost);
359 
360     cards.upgradeUnitMultipliers(msg.sender, upgradeClass, unitId, upgradeValue);  
361     cards.setUpgradesOwned(msg.sender,upgradeId); //upgrade cards level
362 
363     UpgradeCardBought(msg.sender, upgradeId);
364   }
365 
366   /// upgrade cards-- jade + plat
367   function buyUpgradeCard(address _player, uint256 _platValue,uint256 _upgradeId) internal {
368     require(cards.getGameStarted());
369     require(_upgradeId>=1);
370     uint256 existing = cards.getUpgradesOwned(_player,_upgradeId);
371     require(existing<=5);  // v1 - v6
372     uint256 coinCost;
373     uint256 ethCost;
374     uint256 upgradeClass;
375     uint256 unitId;
376     uint256 upgradeValue;
377     uint256 platCost;
378     (coinCost, ethCost, upgradeClass, unitId, upgradeValue,platCost) = schema.getUpgradeCardsInfo(_upgradeId,existing);
379 
380     require(platCost>0);
381     if (platCost > 0) {
382       require(SafeMath.add(cards.coinBalanceOf(_player,1),_platValue) >= platCost); 
383 
384       if (platCost > _platValue) { // They can use their balance instead
385         cards.setCoinBalance(_player, SafeMath.sub(platCost,_platValue),1,false);
386       } else if (platCost < _platValue) {  
387         cards.setCoinBalance(_player,SafeMath.sub(_platValue,platCost),1,true);
388     } 
389       // defund 5%，upgrade card can not be sold，
390       uint256 devFund = uint256(SafeMath.div(platCost, 20)); // 5% fee on purchases (marketing, gameplay & maintenance)
391       cards.setTotalEtherPool(SafeMath.sub(platCost,devFund),1,true); // Rest goes to div pool (Can't sell upgrades)
392       cards.setCoinBalance(owner,devFund,1,true);  
393     }
394         
395      // Update 
396     require(cards.balanceOf(_player) >= coinCost);  
397     cards.updatePlayersCoinByPurchase(_player, coinCost);
398     
399     //add weight
400     cards.upgradeUnitMultipliers(_player, upgradeClass, unitId, upgradeValue);  
401     cards.setUpgradesOwned(_player,_upgradeId); // upgrade level up
402 
403      //add user to userlist
404     if (cards.getUintsOwnerCount(_player)<=0) {
405       cards.AddPlayers(_player);
406     }
407  
408     UpgradeCardBought(_player, _upgradeId);
409   }
410 
411 
412   // Allows someone to send ether and obtain the token
413   function buyRareItem(address _player, uint256 _platValue,uint256 _rareId) internal {
414     require(cards.getGameStarted());        
415     address previousOwner = rare.getRareItemsOwner(_rareId);  // rare card
416     require(previousOwner != 0);
417     require(_player!=previousOwner);  // can not buy from itself
418     
419     uint256 ethCost = rare.getRareItemsPLATPrice(_rareId); // get plat cost
420     uint256 totalCost = SafeMath.add(cards.coinBalanceOf(_player,1),_platValue);
421     require(totalCost >= ethCost); 
422     // We have to claim buyer/sellder's goo before updating their production values 
423     cards.updatePlayersCoinByOut(_player);
424     cards.updatePlayersCoinByOut(previousOwner);
425 
426     uint256 upgradeClass;
427     uint256 unitId;
428     uint256 upgradeValue;
429     (,,,,upgradeClass, unitId, upgradeValue) = rare.getRarePLATInfo(_rareId);
430     
431     // modify weight
432     cards.upgradeUnitMultipliers(_player, upgradeClass, unitId, upgradeValue); 
433     cards.removeUnitMultipliers(previousOwner, upgradeClass, unitId, upgradeValue); 
434 
435     // Splitbid/Overbid
436     if (ethCost > _platValue) {
437       cards.setCoinBalance(_player,SafeMath.sub(ethCost,_platValue),1,false);
438     } else if (_platValue > ethCost) {
439       // Store overbid in their balance
440       cards.setCoinBalance(_player,SafeMath.sub(_platValue,ethCost),1,true);
441     }  
442     // Distribute ethCost  uint256 devFund = ethCost / 50; 
443     uint256 devFund = uint256(SafeMath.div(ethCost, 20)); // 5% fee on purchases (marketing, gameplay & maintenance)  抽成2%
444     uint256 dividends = uint256(SafeMath.div(ethCost,20)); // 5% goes to pool 
445 
446     cards.setTotalEtherPool(dividends,1,true);  // 5% to pool
447     cards.setCoinBalance(owner,devFund,1,true);  // 5% fee
448         
449     // Transfer / update rare item
450     rare.transferToken(previousOwner,_player,_rareId); 
451     rare.setRarePrice(_rareId,SafeMath.div(SafeMath.mul(rare.getRareItemsPrice(_rareId),5),4));
452     
453     cards.setCoinBalance(previousOwner,SafeMath.sub(ethCost,SafeMath.add(dividends,devFund)),1,true);
454     
455     if (cards.getUintsOwnerCount(_player)<=0) {
456       cards.AddPlayers(_player);
457     }
458    
459     cards.setUintsOwnerCount(_player,1,true);
460     cards.setUintsOwnerCount(previousOwner,1,true);
461 
462     //tell the world
463     BuyRareCard(_player, previousOwner, _rareId, ethCost);
464   }
465 
466   /// refunds 75% since no transfer between bitguild and player,no need to call approveAndCall
467   function sellCards( uint256 _unitId, uint256 _amount) external {
468     require(cards.getGameStarted());
469     uint256 existing = cards.getOwnedCount(msg.sender,_unitId);
470     require(existing >= _amount && _amount>0); 
471     existing = SafeMath.sub(existing,_amount);
472     uint256 coinChange;
473     uint256 decreaseCoin;
474     uint256 schemaUnitId;
475     uint256 coinProduction;
476     uint256 coinCost;
477     uint256 ethCost;
478     bool sellable;
479     if (_unitId>=40) { // upgrade card
480       (schemaUnitId,coinCost,, sellable) = schema.getBattleCardInfo(_unitId, existing, _amount);
481       ethCost = SafeMath.mul(schema.unitBattlePLATCost(_unitId),_amount);
482     } else {
483       (schemaUnitId, coinProduction, coinCost, , sellable) = schema.getCardInfo(_unitId, existing, _amount);
484       ethCost = SafeMath.mul(schema.unitPLATCost(_unitId),_amount); // plat 
485     }
486     require(sellable);  // can be refunded
487     if (ethCost>0) {
488       require(unitsOwnedOfPLAT[msg.sender][_unitId]>=_amount);
489     }
490     if (coinCost>0) {
491       coinChange = SafeMath.add(cards.balanceOfUnclaimed(msg.sender), SafeMath.div(SafeMath.mul(coinCost,70),100)); // Claim unsaved goo whilst here
492     } else {
493       coinChange = cards.balanceOfUnclaimed(msg.sender); 
494     }
495 
496     cards.setLastJadeSaveTime(msg.sender); 
497     cards.setRoughSupply(coinChange);  
498     cards.setJadeCoin(msg.sender, coinChange, true); // refund 75% Jadecoin to player 
499 
500     decreaseCoin = cards.getUnitsInProduction(msg.sender, _unitId, _amount);
501   
502     if (coinProduction > 0) { 
503       cards.reducePlayersJadeProduction(msg.sender, decreaseCoin);
504       //update the speed of jade minning
505       cards.setUintCoinProduction(msg.sender,_unitId,decreaseCoin,false); 
506     }
507 
508     if (ethCost > 0) { // Premium units sell for 75% of buy cost
509       cards.setCoinBalance(msg.sender,SafeMath.div(SafeMath.mul(ethCost,70),100),1,true);
510     }
511 
512     cards.setOwnedCount(msg.sender,_unitId,_amount,false); 
513     cards.setUintsOwnerCount(msg.sender,_amount,false);
514     if (ethCost>0) {
515       unitsOwnedOfPLAT[msg.sender][_unitId] = SafeMath.sub(unitsOwnedOfPLAT[msg.sender][_unitId],_amount);
516     }
517     //tell the world
518     UnitSold(msg.sender, _unitId, _amount);
519   }
520 
521   //@notice for player withdraw
522   function withdrawEtherFromTrade(uint256 amount) external {
523     require(amount <= cards.coinBalanceOf(msg.sender,1));
524     cards.setCoinBalance(msg.sender,amount,1,false);
525     tokenContract.transfer(msg.sender,amount);
526   } 
527 
528   //@notice withraw all PLAT by dev
529   function withdrawToken(uint256 amount) external onlyOwner {
530     uint256 balance = tokenContract.balanceOf(this);
531     require(balance > 0 && balance >= amount);
532     tokenContract.transfer(msg.sender, amount);
533   }
534 
535   function getCanSellUnit(address _address, uint256 unitId) external view returns (uint256) {
536     return unitsOwnedOfPLAT[_address][unitId];
537   }
538 
539 }
540 
541 library SafeMath {
542 
543   /**
544   * @dev Multiplies two numbers, throws on overflow.
545   */
546   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
547     if (a == 0) {
548       return 0;
549     }
550     uint256 c = a * b;
551     assert(c / a == b);
552     return c;
553   }
554 
555   /**
556   * @dev Integer division of two numbers, truncating the quotient.
557   */
558   function div(uint256 a, uint256 b) internal pure returns (uint256) {
559     // assert(b > 0); // Solidity automatically throws when dividing by 0
560     uint256 c = a / b;
561     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
562     return c;
563   }
564 
565   /**
566   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
567   */
568   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
569     assert(b <= a);
570     return a - b;
571   }
572 
573   /**
574   * @dev Adds two numbers, throws on overflow.
575   */
576   function add(uint256 a, uint256 b) internal pure returns (uint256) {
577     uint256 c = a + b;
578     assert(c >= a);
579     return c;
580   }
581 }