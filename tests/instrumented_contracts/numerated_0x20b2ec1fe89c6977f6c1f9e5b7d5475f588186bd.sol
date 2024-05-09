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
75 
76 interface BitGuildTokenInterface { // implements ERC20Interface
77   function totalSupply() public constant returns (uint);
78   function balanceOf(address tokenOwner) public constant returns (uint balance);
79   function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
80   function transfer(address to, uint tokens) public returns (bool success);
81   function approve(address spender, uint tokens) public returns (bool success);
82   function transferFrom(address from, address to, uint tokens) public returns (bool success);
83 
84   event Transfer(address indexed from, address indexed to, uint tokens);
85   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
86 }
87 
88 interface CardsInterface {
89   function getGameStarted() external constant returns (bool);
90   function getOwnedCount(address player, uint256 cardId) external view returns (uint256);
91   function getMaxCap(address _addr,uint256 _cardId) external view returns (uint256);
92   function upgradeUnitMultipliers(address player, uint256 upgradeClass, uint256 unitId, uint256 upgradeValue) external;
93   function removeUnitMultipliers(address player, uint256 upgradeClass, uint256 unitId, uint256 upgradeValue) external;
94   function balanceOf(address player) public constant returns(uint256);
95   function coinBalanceOf(address player,uint8 itype) external constant returns(uint256);
96   function updatePlayersCoinByPurchase(address player, uint256 purchaseCost) external;
97   function getUnitsProduction(address player, uint256 unitId, uint256 amount) external constant returns (uint256);
98   function increasePlayersJadeProduction(address player, uint256 increase) public;
99   function setUintCoinProduction(address _address, uint256 cardId, uint256 iValue, bool iflag) external;
100   function getUintsOwnerCount(address _address) external view returns (uint256);
101   function AddPlayers(address _address) external;
102   function setUintsOwnerCount(address _address, uint256 amount, bool iflag) external;
103   function setOwnedCount(address player, uint256 cardId, uint256 amount, bool iflag) external;
104   function setCoinBalance(address player, uint256 eth, uint8 itype, bool iflag) external;
105   function setTotalEtherPool(uint256 inEth, uint8 itype, bool iflag) external;
106   function getUpgradesOwned(address player, uint256 upgradeId) external view returns (uint256);
107   function setUpgradesOwned(address player, uint256 upgradeId) external;
108   function updatePlayersCoinByOut(address player) external;
109   function balanceOfUnclaimed(address player) public constant returns (uint256);
110   function setLastJadeSaveTime(address player) external;
111   function setRoughSupply(uint256 iroughSupply) external;
112   function setJadeCoin(address player, uint256 coin, bool iflag) external;
113   function getUnitsInProduction(address player, uint256 unitId, uint256 amount) external constant returns (uint256);
114   function reducePlayersJadeProduction(address player, uint256 decrease) public;
115 }
116 interface GameConfigInterface {
117   function unitCoinProduction(uint256 cardId) external constant returns (uint256);
118   function unitPLATCost(uint256 cardId) external constant returns (uint256);
119   function getCostForCards(uint256 cardId, uint256 existing, uint256 amount) external constant returns (uint256);
120   function getCostForBattleCards(uint256 cardId, uint256 existing, uint256 amount) external constant returns (uint256);
121   function unitBattlePLATCost(uint256 cardId) external constant returns (uint256);
122   function getUpgradeCardsInfo(uint256 upgradecardId,uint256 existing) external constant returns (
123     uint256 coinCost, 
124     uint256 ethCost, 
125     uint256 upgradeClass, 
126     uint256 cardId, 
127     uint256 upgradeValue,
128     uint256 platCost
129   );
130  function getCardInfo(uint256 cardId, uint256 existing, uint256 amount) external constant returns (uint256, uint256, uint256, uint256, bool);
131  function getBattleCardInfo(uint256 cardId, uint256 existing, uint256 amount) external constant returns (uint256, uint256, uint256, bool);
132 
133 }
134 interface RareInterface {
135   function getRareItemsOwner(uint256 rareId) external view returns (address);
136   function getRareItemsPrice(uint256 rareId) external view returns (uint256);
137   function getRareItemsPLATPrice(uint256 rareId) external view returns (uint256);
138    function getRarePLATInfo(uint256 _tokenId) external view returns (
139     uint256 sellingPrice,
140     address owner,
141     uint256 nextPrice,
142     uint256 rareClass,
143     uint256 cardId,
144     uint256 rareValue
145   );
146   function transferToken(address _from, address _to, uint256 _tokenId) external;
147   function setRarePrice(uint256 _rareId, uint256 _price) external;
148 }
149 /// @notice Purchase on BitGuild
150 /// @author rainysiu rainy@livestar.com
151 contract BitGuildTrade is AccessAdmin {
152   BitGuildTokenInterface public tokenContract;
153    //data contract
154   CardsInterface public cards ;
155   GameConfigInterface public schema;
156   RareInterface public rare;
157 
158   
159   function BitGuildTrade() public {
160     setAdminContract(msg.sender,true);
161     setActionContract(msg.sender,true);
162   }
163 
164   event UnitBought(address player, uint256 unitId, uint256 amount);
165   event UpgradeCardBought(address player, uint256 upgradeId);
166   event BuyRareCard(address player, address previous, uint256 rareId,uint256 iPrice);
167   event UnitSold(address player, uint256 unitId, uint256 amount);
168 
169  
170   function() external payable {
171     revert();
172   }
173   function setBitGuildToken(address _tokenContract) external onlyOwner {
174     tokenContract = BitGuildTokenInterface(_tokenContract);
175   } 
176 
177   function setCardsAddress(address _address) external onlyOwner {
178     cards = CardsInterface(_address);
179   }
180 
181    //normal cards
182   function setConfigAddress(address _address) external onlyOwner {
183     schema = GameConfigInterface(_address);
184   }
185 
186   //rare cards
187   function setRareAddress(address _address) external onlyOwner {
188     rare = RareInterface(_address);
189   }
190   function kill() public onlyOwner {
191     tokenContract.transferFrom(this, msg.sender, tokenContract.balanceOf(this));
192     selfdestruct(msg.sender); //end execution, destroy current contract and send funds to a
193   }  
194   /// @notice Returns all the relevant information about a specific tokenId.
195   /// val1:flag,val2:id,val3:amount
196   function _getExtraParam(bytes _extraData) private pure returns(uint256 val1,uint256 val2,uint256 val3) {
197     if (_extraData.length == 2) {
198       val1 = uint256(_extraData[0]);
199       val2 = uint256(_extraData[1]);
200       val3 = 1; 
201     } else if (_extraData.length == 3) {
202       val1 = uint256(_extraData[0]);
203       val2 = uint256(_extraData[1]);
204       val3 = uint256(_extraData[2]);
205     }  
206   }
207   
208   function receiveApproval(address _player, uint256 _value, address _tokenContractAddr, bytes _extraData) external {
209     require(msg.sender == _tokenContractAddr);
210     require(_extraData.length >=1);
211     require(tokenContract.transferFrom(_player, address(this), _value));
212     uint256 flag;
213     uint256 unitId;
214     uint256 amount;
215     (flag,unitId,amount) = _getExtraParam(_extraData);
216 
217     if (flag==1) {
218       buyPLATCards(_player, _value, unitId, amount);  // 1-39
219     } else if (flag==3) {
220       buyUpgradeCard(_player, _value, unitId);  // >=1
221     } else if (flag==4) {
222       buyRareItem(_player, _value, unitId); //rarecard
223     } 
224   } 
225 
226   /// buy normal cards via jade
227   function buyBasicCards(uint256 unitId, uint256 amount) external {
228     require(cards.getGameStarted());
229     require(amount>=1);
230     uint256 existing = cards.getOwnedCount(msg.sender,unitId);
231     uint256 total = SafeMath.add(existing, amount);
232     if (total > 99) { // Default unit limit
233       require(total <= cards.getMaxCap(msg.sender,unitId)); // Housing upgrades (allow more units)
234     }
235 
236     uint256 coinProduction;
237     uint256 coinCost;
238     uint256 ethCost;
239     if (unitId>=1 && unitId<=39) {    
240       (, coinProduction, coinCost, ethCost,) = schema.getCardInfo(unitId, existing, amount);
241     } else if (unitId>=40) {
242       (, coinCost, ethCost,) = schema.getBattleCardInfo(unitId, existing, amount);
243     }
244     require(cards.balanceOf(msg.sender) >= coinCost);
245     require(ethCost == 0); // Free ether unit
246         
247     // Update players jade 
248     cards.updatePlayersCoinByPurchase(msg.sender, coinCost);
249     ///****increase production***/
250     if (coinProduction > 0) {
251       cards.increasePlayersJadeProduction(msg.sender,cards.getUnitsProduction(msg.sender, unitId, amount)); 
252       cards.setUintCoinProduction(msg.sender,unitId,cards.getUnitsProduction(msg.sender, unitId, amount),true); 
253     }
254     //players
255     if (cards.getUintsOwnerCount(msg.sender)<=0) {
256       cards.AddPlayers(msg.sender);
257     }
258     cards.setUintsOwnerCount(msg.sender,amount,true);
259     cards.setOwnedCount(msg.sender,unitId,amount,true);
260     
261     UnitBought(msg.sender, unitId, amount);
262   }
263 
264   function buyBasicCards_Migrate(address _addr, uint256 _unitId, uint256 _amount) external onlyAdmin {
265     require(cards.getGameStarted());
266     require(_amount>=1);
267     uint256 existing = cards.getOwnedCount(_addr,_unitId);
268     uint256 total = SafeMath.add(existing, _amount);
269     if (total > 99) { // Default unit limit
270       require(total <= cards.getMaxCap(_addr,_unitId)); // Housing upgrades (allow more units)
271     }
272     require (_unitId == 41);
273     uint256 coinCost;
274     uint256 ethCost;
275     (, coinCost, ethCost,) = schema.getBattleCardInfo(_unitId, existing, _amount);
276     //players
277     if (cards.getUintsOwnerCount(_addr)<=0) {
278       cards.AddPlayers(_addr);
279     }
280     cards.setUintsOwnerCount(_addr,_amount,true);
281     cards.setOwnedCount(_addr,_unitId,_amount,true);
282     
283     UnitBought(_addr, _unitId, _amount);
284   }
285 
286   function buyPLATCards(address _player, uint256 _platValue, uint256 _cardId, uint256 _amount) internal {
287     require(cards.getGameStarted());
288     require(_amount>=1);
289     uint256 existing = cards.getOwnedCount(_player,_cardId);
290     uint256 total = SafeMath.add(existing, _amount);
291     if (total > 99) { // Default unit limit
292       require(total <= cards.getMaxCap(_player,_cardId)); // Housing upgrades (allow more units)
293     }
294 
295     uint256 coinProduction;
296     uint256 coinCost;
297     uint256 ethCost;
298 
299     if (_cardId>=1 && _cardId<=39) {
300       coinProduction = schema.unitCoinProduction(_cardId);
301       coinCost = schema.getCostForCards(_cardId, existing, _amount);
302       ethCost = SafeMath.mul(schema.unitPLATCost(_cardId),_amount);  // get platprice
303     } else if (_cardId>=40) {
304       coinCost = schema.getCostForBattleCards(_cardId, existing, _amount);
305       ethCost = SafeMath.mul(schema.unitBattlePLATCost(_cardId),_amount);  // get platprice
306     }
307 
308     require(ethCost>0);
309     require(SafeMath.add(cards.coinBalanceOf(_player,1),_platValue) >= ethCost);
310     require(cards.balanceOf(_player) >= coinCost);   
311 
312     // Update players jade  
313     cards.updatePlayersCoinByPurchase(_player, coinCost);
314 
315     if (ethCost > _platValue) {
316       cards.setCoinBalance(_player,SafeMath.sub(ethCost,_platValue),1,false);
317     } else if (_platValue > ethCost) {
318       // Store overbid in their balance
319       cards.setCoinBalance(_player,SafeMath.sub(_platValue,ethCost),1,true);
320     } 
321 
322     uint256 devFund = uint256(SafeMath.div(ethCost,20)); // 5% fee
323     cards.setTotalEtherPool(uint256(SafeMath.div(ethCost,4)),1,true);  // 20% to pool
324     cards.setCoinBalance(owner,devFund,1,true);  
325     
326     if (coinProduction > 0) {
327       cards.increasePlayersJadeProduction(_player, cards.getUnitsProduction(_player, _cardId, _amount)); 
328       cards.setUintCoinProduction(_player,_cardId,cards.getUnitsProduction(_player, _cardId, _amount),true); 
329     }
330     
331     if (cards.getUintsOwnerCount(_player)<=0) {
332       cards.AddPlayers(_player);
333     }
334     cards.setUintsOwnerCount(_player,_amount, true);
335     cards.setOwnedCount(_player,_cardId,_amount,true);
336     //event
337     UnitBought(_player, _cardId, _amount);
338   }
339 
340   /// buy upgrade cards with ether/Jade
341   function buyUpgradeCard(uint256 upgradeId) external payable {
342     require(cards.getGameStarted());
343     require(upgradeId>=1);
344     uint256 existing = cards.getUpgradesOwned(msg.sender,upgradeId);
345     
346     uint256 coinCost;
347     uint256 ethCost;
348     uint256 upgradeClass;
349     uint256 unitId;
350     uint256 upgradeValue;
351     (coinCost, ethCost, upgradeClass, unitId, upgradeValue,) = schema.getUpgradeCardsInfo(upgradeId,existing);
352     if (upgradeClass<8) {
353       require(existing<=5); 
354     } else {
355       require(existing<=2); 
356     }
357     require (coinCost>0 && ethCost==0);
358     require(cards.balanceOf(msg.sender) >= coinCost);  
359     cards.updatePlayersCoinByPurchase(msg.sender, coinCost);
360 
361     cards.upgradeUnitMultipliers(msg.sender, upgradeClass, unitId, upgradeValue);  
362     cards.setUpgradesOwned(msg.sender,upgradeId); //upgrade cards level
363 
364     UpgradeCardBought(msg.sender, upgradeId);
365   }
366 
367   /// upgrade cards-- jade + plat
368   function buyUpgradeCard(address _player, uint256 _platValue,uint256 _upgradeId) internal {
369     require(cards.getGameStarted());
370     require(_upgradeId>=1);
371     uint256 existing = cards.getUpgradesOwned(_player,_upgradeId);
372     require(existing<=5);  // v1 - v6
373     uint256 coinCost;
374     uint256 ethCost;
375     uint256 upgradeClass;
376     uint256 unitId;
377     uint256 upgradeValue;
378     uint256 platCost;
379     (coinCost, ethCost, upgradeClass, unitId, upgradeValue,platCost) = schema.getUpgradeCardsInfo(_upgradeId,existing);
380 
381     require(platCost>0);
382     if (platCost > 0) {
383       require(SafeMath.add(cards.coinBalanceOf(_player,1),_platValue) >= platCost); 
384 
385       if (platCost > _platValue) { // They can use their balance instead
386         cards.setCoinBalance(_player, SafeMath.sub(platCost,_platValue),1,false);
387       } else if (platCost < _platValue) {  
388         cards.setCoinBalance(_player,SafeMath.sub(_platValue,platCost),1,true);
389     } 
390       // defund 5%，upgrade card can not be sold，
391       uint256 devFund = uint256(SafeMath.div(platCost, 20)); // 5% fee on purchases (marketing, gameplay & maintenance)
392       cards.setTotalEtherPool(SafeMath.sub(platCost,devFund),1,true); // Rest goes to div pool (Can't sell upgrades)
393       cards.setCoinBalance(owner,devFund,1,true);  
394     }
395         
396      // Update 
397     require(cards.balanceOf(_player) >= coinCost);  
398     cards.updatePlayersCoinByPurchase(_player, coinCost);
399     
400     //add weight
401     cards.upgradeUnitMultipliers(_player, upgradeClass, unitId, upgradeValue);  
402     cards.setUpgradesOwned(_player,_upgradeId); // upgrade level up
403 
404      //add user to userlist
405     if (cards.getUintsOwnerCount(_player)<=0) {
406       cards.AddPlayers(_player);
407     }
408  
409     UpgradeCardBought(_player, _upgradeId);
410   }
411 
412 
413   // Allows someone to send ether and obtain the token
414   function buyRareItem(address _player, uint256 _platValue,uint256 _rareId) internal {
415     require(cards.getGameStarted());        
416     address previousOwner = rare.getRareItemsOwner(_rareId);  // rare card
417     require(previousOwner != 0);
418     require(_player!=previousOwner);  // can not buy from itself
419     
420     uint256 ethCost = rare.getRareItemsPLATPrice(_rareId); // get plat cost
421     uint256 totalCost = SafeMath.add(cards.coinBalanceOf(_player,1),_platValue);
422     require(totalCost >= ethCost); 
423     // We have to claim buyer/sellder's goo before updating their production values 
424     cards.updatePlayersCoinByOut(_player);
425     cards.updatePlayersCoinByOut(previousOwner);
426 
427     uint256 upgradeClass;
428     uint256 unitId;
429     uint256 upgradeValue;
430     (,,,,upgradeClass, unitId, upgradeValue) = rare.getRarePLATInfo(_rareId);
431     
432     // modify weight
433     cards.upgradeUnitMultipliers(_player, upgradeClass, unitId, upgradeValue); 
434     cards.removeUnitMultipliers(previousOwner, upgradeClass, unitId, upgradeValue); 
435 
436     // Splitbid/Overbid
437     if (ethCost > _platValue) {
438       cards.setCoinBalance(_player,SafeMath.sub(ethCost,_platValue),1,false);
439     } else if (_platValue > ethCost) {
440       // Store overbid in their balance
441       cards.setCoinBalance(_player,SafeMath.sub(_platValue,ethCost),1,true);
442     }  
443     // Distribute ethCost  uint256 devFund = ethCost / 50; 
444     uint256 devFund = uint256(SafeMath.div(ethCost, 20)); // 5% fee on purchases (marketing, gameplay & maintenance)  抽成2%
445     uint256 dividends = uint256(SafeMath.div(ethCost,20)); // 5% goes to pool 
446 
447     cards.setTotalEtherPool(dividends,1,true);  // 5% to pool
448     cards.setCoinBalance(owner,devFund,1,true);  // 5% fee
449         
450     // Transfer / update rare item
451     rare.transferToken(previousOwner,_player,_rareId); 
452     rare.setRarePrice(_rareId,SafeMath.div(SafeMath.mul(rare.getRareItemsPrice(_rareId),5),4));
453     
454     cards.setCoinBalance(previousOwner,SafeMath.sub(ethCost,SafeMath.add(dividends,devFund)),1,true);
455     
456     if (cards.getUintsOwnerCount(_player)<=0) {
457       cards.AddPlayers(_player);
458     }
459    
460     cards.setUintsOwnerCount(_player,1,true);
461     cards.setUintsOwnerCount(previousOwner,1,true);
462 
463     //tell the world
464     BuyRareCard(_player, previousOwner, _rareId, ethCost);
465   }
466 
467   /// refunds 75% since no transfer between bitguild and player,no need to call approveAndCall
468   function sellCards( uint256 _unitId, uint256 _amount) external {
469     require(cards.getGameStarted());
470     uint256 existing = cards.getOwnedCount(msg.sender,_unitId);
471     require(existing >= _amount && _amount>0); 
472     existing = SafeMath.sub(existing,_amount);
473     uint256 coinChange;
474     uint256 decreaseCoin;
475     uint256 schemaUnitId;
476     uint256 coinProduction;
477     uint256 coinCost;
478     uint256 ethCost;
479     bool sellable;
480     if (_unitId>=40) { // upgrade card
481       (schemaUnitId,coinCost,, sellable) = schema.getBattleCardInfo(_unitId, existing, _amount);
482       ethCost = SafeMath.mul(schema.unitBattlePLATCost(_unitId),_amount);
483     } else {
484       (schemaUnitId, coinProduction, coinCost, , sellable) = schema.getCardInfo(_unitId, existing, _amount);
485       ethCost = SafeMath.mul(schema.unitPLATCost(_unitId),_amount); // plat 
486     }
487     require(sellable);  // can be refunded
488     if (coinCost>0) {
489       coinChange = SafeMath.add(cards.balanceOfUnclaimed(msg.sender), SafeMath.div(SafeMath.mul(coinCost,70),100)); // Claim unsaved goo whilst here
490     } else {
491       coinChange = cards.balanceOfUnclaimed(msg.sender); 
492     }
493 
494     cards.setLastJadeSaveTime(msg.sender); 
495     cards.setRoughSupply(coinChange);  
496     cards.setJadeCoin(msg.sender, coinChange, true); // refund 75% Jadecoin to player 
497 
498     decreaseCoin = cards.getUnitsInProduction(msg.sender, _unitId, _amount);
499   
500     if (coinProduction > 0) { 
501       cards.reducePlayersJadeProduction(msg.sender, decreaseCoin);
502       //update the speed of jade minning
503       cards.setUintCoinProduction(msg.sender,_unitId,decreaseCoin,false); 
504     }
505 
506     if (ethCost > 0) { // Premium units sell for 75% of buy cost
507       cards.setCoinBalance(msg.sender,SafeMath.div(SafeMath.mul(ethCost,70),100),1,true);
508     }
509 
510     cards.setOwnedCount(msg.sender,_unitId,_amount,false); 
511     cards.setUintsOwnerCount(msg.sender,_amount,false);
512 
513     //tell the world
514     UnitSold(msg.sender, _unitId, _amount);
515   }
516 
517   //@notice for player withdraw
518   function withdrawEtherFromTrade(uint256 amount) external {
519     require(amount <= cards.coinBalanceOf(msg.sender,1));
520     cards.setCoinBalance(msg.sender,amount,1,false);
521     tokenContract.transfer(msg.sender,amount);
522   } 
523 
524   //@notice withraw all PLAT by dev
525   function withdrawToken(uint256 amount) external onlyOwner {
526     uint256 balance = tokenContract.balanceOf(this);
527     require(balance > 0 && balance >= amount);
528     tokenContract.transfer(msg.sender, amount);
529   }
530 
531 }
532 
533 
534 library SafeMath {
535 
536   /**
537   * @dev Multiplies two numbers, throws on overflow.
538   */
539   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
540     if (a == 0) {
541       return 0;
542     }
543     uint256 c = a * b;
544     assert(c / a == b);
545     return c;
546   }
547 
548   /**
549   * @dev Integer division of two numbers, truncating the quotient.
550   */
551   function div(uint256 a, uint256 b) internal pure returns (uint256) {
552     // assert(b > 0); // Solidity automatically throws when dividing by 0
553     uint256 c = a / b;
554     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
555     return c;
556   }
557 
558   /**
559   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
560   */
561   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
562     assert(b <= a);
563     return a - b;
564   }
565 
566   /**
567   * @dev Adds two numbers, throws on overflow.
568   */
569   function add(uint256 a, uint256 b) internal pure returns (uint256) {
570     uint256 c = a + b;
571     assert(c >= a);
572     return c;
573   }
574 }