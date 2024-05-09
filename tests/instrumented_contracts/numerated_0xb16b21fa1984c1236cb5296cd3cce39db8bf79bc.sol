1 pragma solidity ^0.4.18;
2 /* ==================================================================== */
3 /* Copyright (c) 2018 The MagicAcademy Project.  All rights reserved.
4 /* 
5 /* https://www.magicacademy.io One of the world's first idle strategy games of blockchain 
6 /*  
7 /* authors rainy@livestar.com/fanny.zheng@livestar.com
8 /*                 
9 /* ==================================================================== */
10 contract GameConfig {
11   using SafeMath for SafeMath;
12   address public owner;
13 
14   /**event**/
15   event newCard(uint256 cardId,uint256 baseCoinCost,uint256 coinCostIncreaseHalf,uint256 ethCost,uint256 baseCoinProduction);
16   event newBattleCard(uint256 cardId,uint256 baseCoinCost,uint256 coinCostIncreaseHalf,uint256 ethCost,uint256 attackValue,uint256 defenseValue,uint256 coinStealingCapacity);
17   event newUpgradeCard(uint256 upgradecardId, uint256 coinCost, uint256 ethCost, uint256 upgradeClass, uint256 cardId, uint256 upgradeValue);
18   
19   struct Card {
20     uint256 cardId;
21     uint256 baseCoinCost;
22     uint256 coinCostIncreaseHalf; // Halfed to make maths slightly less (cancels a 2 out)
23     uint256 ethCost;
24     uint256 baseCoinProduction;
25     bool unitSellable; // Rare units (from raffle) not sellable
26   }
27 
28 
29   struct BattleCard {
30     uint256 cardId;
31     uint256 baseCoinCost;
32     uint256 coinCostIncreaseHalf; // Halfed to make maths slightly less (cancels a 2 out)
33     uint256 ethCost;
34     uint256 attackValue;
35     uint256 defenseValue;
36     uint256 coinStealingCapacity;
37     bool unitSellable; // Rare units (from raffle) not sellable
38   }
39   
40   struct UpgradeCard {
41     uint256 upgradecardId;
42     uint256 coinCost;
43     uint256 ethCost;
44     uint256 upgradeClass;
45     uint256 cardId;
46     uint256 upgradeValue;
47   }
48   
49   /** mapping**/
50   mapping(uint256 => Card) private cardInfo;  //normal card
51   mapping(uint256 => BattleCard) private battlecardInfo;  //battle card
52   mapping(uint256 => UpgradeCard) private upgradeInfo;  //upgrade card
53      
54   uint256 public currNumOfCards = 9;  
55   uint256 public currNumOfBattleCards = 6;  
56   uint256 public currNumOfUpgrades; 
57 
58   uint256 PLATPrice = 65000;
59   string versionNo;
60  
61   // Constructor 
62   function GameConfig() public {
63     owner = msg.sender;
64     versionNo = "20180706";
65     cardInfo[1] = Card(1, 0, 10, 0, 2, true);
66     cardInfo[2] = Card(2, 100, 50, 0, 5, true);
67     cardInfo[3] = Card(3, 0, 0, 0.01 ether, 100, true);
68     cardInfo[4] = Card(4, 200, 100, 0, 10,  true);
69     cardInfo[5] = Card(5, 500, 250, 0, 20,  true);
70     cardInfo[6] = Card(6, 1000, 500, 0, 40, true);
71     cardInfo[7] = Card(7, 0, 1000, 0.05 ether, 500, true);
72     cardInfo[8] = Card(8, 1500, 750, 0, 60,  true);
73     cardInfo[9] = Card(9, 0, 0, 0.99 ether, 5500, false);
74 
75     battlecardInfo[40] = BattleCard(40, 50, 25, 0,  10, 10, 10000, true);
76     battlecardInfo[41] = BattleCard(41, 100, 50, 0,  1, 25, 500, true);
77     battlecardInfo[42] = BattleCard(42, 0, 0, 0.01 ether,  200, 10, 50000, true);
78     battlecardInfo[43] = BattleCard(43, 250, 125, 0, 25, 1, 15000, true);
79     battlecardInfo[44] = BattleCard(44, 500, 250, 0, 20, 40, 5000, true);
80     battlecardInfo[45] = BattleCard(45, 0, 2500, 0.02 ether, 0, 0, 100000, true);
81 
82     //InitUpgradeCard();
83   }
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   function setPLATPrice(uint256 price) external onlyOwner {
90     PLATPrice = price;
91   }
92   function getPLATPrice() external view returns (uint256) {
93     return PLATPrice;
94   }
95   function getVersion() external view returns(string) {
96     return versionNo;
97   }
98 
99   function InitUpgradeCard() external onlyOwner {
100   //upgradecardId,coinCost,ethCost,upgradeClass,cardId,upgradeValue;
101     CreateUpgradeCards(1,500,0,0,1,1);
102     CreateUpgradeCards(2 ,0,0.02 ether,1,1,1);
103     CreateUpgradeCards(3,0,0.1 ether,8,1,999);
104     CreateUpgradeCards(4,0,0.02 ether,0,2,2);
105     CreateUpgradeCards(5,5000,0,1,2,5);
106     CreateUpgradeCards(6,0,0.1 ether,8,2,999);
107     CreateUpgradeCards(7,5000,0,0,3,5);
108     CreateUpgradeCards(8,0,0.1 ether,1,3,5);
109     CreateUpgradeCards(9,5000000,0,8,3,999);
110     CreateUpgradeCards(10,0,0.02 ether,0,4,4);
111     CreateUpgradeCards(11,10000,0,1,4,5);
112     CreateUpgradeCards(12,0,0.1 ether,8,4,999);
113     CreateUpgradeCards(13,15000,0,0,5,6);
114     CreateUpgradeCards(14,0,0.25 ether,1,5,5);
115     CreateUpgradeCards(15,0,0.1 ether,8,5,999);
116     CreateUpgradeCards(16,0,0.02 ether,0,6,8);
117     CreateUpgradeCards(17,30000,0,1,6,5);
118     CreateUpgradeCards(18,0,0.1 ether,8,6,999);
119     CreateUpgradeCards(19,35000,0,0,7,25);
120     CreateUpgradeCards(20,0,0.05 ether,1,7,5);
121     CreateUpgradeCards(21,5000000,0,8,7,999);
122     CreateUpgradeCards(22,0,0.02 ether,0,8,10);
123     CreateUpgradeCards(23,75000,0,1,8,5);
124     CreateUpgradeCards(24,0,0.1 ether,8,8,999);
125 
126     //for battle cards
127     CreateUpgradeCards(25,1000,0,2,40,5);                 
128     CreateUpgradeCards(26,2500,0,4,40,5);       
129     CreateUpgradeCards(27,50000000,0,8,40,999); 
130     CreateUpgradeCards(28,2500,0,4,41,5);       
131     CreateUpgradeCards(29,5000,0,5,41,5);       
132     CreateUpgradeCards(30,50000000,0,8,41,999); 
133     CreateUpgradeCards(31,5000,0,2,42,10);      
134     CreateUpgradeCards(32,7500,0,3,42,5);       
135     CreateUpgradeCards(33,5000000,0,8,42,999);  
136     CreateUpgradeCards(34,7500,0,2,43,5);       
137     CreateUpgradeCards(35,10000,0,6,43,1000);   
138     CreateUpgradeCards(36,50000000,0,8,43,999); 
139     CreateUpgradeCards(37,10000,0,3,44,5);      
140     CreateUpgradeCards(38,15000,0,5,44,5);      
141     CreateUpgradeCards(39,50000000,0,8,44,999); 
142     CreateUpgradeCards(40,25000,0,6,45,10000);  
143     CreateUpgradeCards(41,50000,0,7,45,5);      
144     CreateUpgradeCards(42,5000000,0,8,45,999); 
145   } 
146 
147   function CreateBattleCards(uint256 _cardId, uint256 _baseCoinCost, uint256 _coinCostIncreaseHalf, uint256 _ethCost, uint _attackValue, uint256 _defenseValue, uint256 _coinStealingCapacity, bool _unitSellable) public onlyOwner {
148     BattleCard memory _battlecard = BattleCard({
149       cardId: _cardId,
150       baseCoinCost: _baseCoinCost,
151       coinCostIncreaseHalf: _coinCostIncreaseHalf,
152       ethCost: _ethCost,
153       attackValue: _attackValue,
154       defenseValue: _defenseValue,
155       coinStealingCapacity: _coinStealingCapacity,
156       unitSellable: _unitSellable
157     });
158     battlecardInfo[_cardId] = _battlecard;
159     currNumOfBattleCards = SafeMath.add(currNumOfBattleCards,1);
160     newBattleCard(_cardId,_baseCoinCost,_coinCostIncreaseHalf,_ethCost,_attackValue,_defenseValue,_coinStealingCapacity);
161     
162   }
163 
164   function CreateCards(uint256 _cardId, uint256 _baseCoinCost, uint256 _coinCostIncreaseHalf, uint256 _ethCost, uint256 _baseCoinProduction, bool _unitSellable) public onlyOwner {
165     Card memory _card = Card({
166       cardId: _cardId,
167       baseCoinCost: _baseCoinCost,
168       coinCostIncreaseHalf: _coinCostIncreaseHalf,
169       ethCost: _ethCost,
170       baseCoinProduction: _baseCoinProduction,
171       unitSellable: _unitSellable
172     });
173     cardInfo[_cardId] = _card;
174     currNumOfCards = SafeMath.add(currNumOfCards,1);
175     newCard(_cardId,_baseCoinCost,_coinCostIncreaseHalf,_ethCost,_baseCoinProduction);
176   }
177 
178   function CreateUpgradeCards(uint256 _upgradecardId, uint256 _coinCost, uint256 _ethCost, uint256 _upgradeClass, uint256 _cardId, uint256 _upgradeValue) public onlyOwner {
179     UpgradeCard memory _upgradecard = UpgradeCard({
180       upgradecardId: _upgradecardId,
181       coinCost: _coinCost,
182       ethCost: _ethCost,
183       upgradeClass: _upgradeClass,
184       cardId: _cardId,
185       upgradeValue: _upgradeValue
186     });
187     upgradeInfo[_upgradecardId] = _upgradecard;
188     currNumOfUpgrades = SafeMath.add(currNumOfUpgrades,1);
189     newUpgradeCard(_upgradecardId,_coinCost,_ethCost,_upgradeClass,_cardId,_upgradeValue); 
190   }
191   
192   function getCostForCards(uint256 cardId, uint256 existing, uint256 amount) public constant returns (uint256) {
193     uint256 icount = existing;
194     if (amount == 1) { 
195       if (existing == 0) {  
196         return cardInfo[cardId].baseCoinCost; 
197       } else {
198         return cardInfo[cardId].baseCoinCost + (existing * cardInfo[cardId].coinCostIncreaseHalf * 2);
199             }
200     } else if (amount > 1) { 
201       uint256 existingCost;
202       if (existing > 0) {
203         existingCost = (cardInfo[cardId].baseCoinCost * existing) + (existing * (existing - 1) * cardInfo[cardId].coinCostIncreaseHalf);
204       }
205       icount = SafeMath.add(existing,amount);  
206       uint256 newCost = SafeMath.add(SafeMath.mul(cardInfo[cardId].baseCoinCost, icount), SafeMath.mul(SafeMath.mul(icount, (icount - 1)), cardInfo[cardId].coinCostIncreaseHalf));
207       return newCost - existingCost;
208       }
209   }
210 
211   function getCostForBattleCards(uint256 cardId, uint256 existing, uint256 amount) public constant returns (uint256) {
212     uint256 icount = existing;
213     if (amount == 1) { 
214       if (existing == 0) {  
215         return battlecardInfo[cardId].baseCoinCost; 
216       } else {
217         return battlecardInfo[cardId].baseCoinCost + (existing * battlecardInfo[cardId].coinCostIncreaseHalf * 2);
218             }
219     } else if (amount > 1) {
220       uint256 existingCost;
221       if (existing > 0) {
222         existingCost = (battlecardInfo[cardId].baseCoinCost * existing) + (existing * (existing - 1) * battlecardInfo[cardId].coinCostIncreaseHalf);
223       }
224       icount = SafeMath.add(existing,amount);  
225       uint256 newCost = SafeMath.add(SafeMath.mul(battlecardInfo[cardId].baseCoinCost, icount), SafeMath.mul(SafeMath.mul(icount, (icount - 1)), battlecardInfo[cardId].coinCostIncreaseHalf));
226       return newCost - existingCost;
227     }
228   }
229 
230   function getCostForUprade(uint256 cardId, uint256 existing, uint256 amount) public constant returns (uint256) {
231     if (amount == 1) { 
232       if (existing == 0) {  
233         return upgradeInfo[cardId].coinCost; 
234       } else if (existing == 1 || existing == 4){
235         return 0;
236       }else if (existing == 2) {
237         return upgradeInfo[cardId].coinCost * 50; 
238     }else if (existing == 3) {
239       return upgradeInfo[cardId].coinCost * 50 * 40; 
240     }else if (existing == 5) {
241       return upgradeInfo[cardId].coinCost * 50 * 40 * 30; 
242     }
243   }
244   }
245 
246   function getWeakenedDefensePower(uint256 defendingPower) external pure returns (uint256) {
247     return SafeMath.div(defendingPower,2);
248   }
249  
250     /// @notice get the production card's ether cost
251   function unitEthCost(uint256 cardId) external constant returns (uint256) {
252     return cardInfo[cardId].ethCost;
253   }
254 
255     /// @notice get the battle card's ether cost
256   function unitBattleEthCost(uint256 cardId) external constant returns (uint256) {
257     return battlecardInfo[cardId].ethCost;
258   }
259   /// @notice get the battle card's plat cost
260   function unitBattlePLATCost(uint256 cardId) external constant returns (uint256) {
261     return SafeMath.mul(battlecardInfo[cardId].ethCost,PLATPrice);
262   }
263 
264     /// @notice normal production plat value
265   function unitPLATCost(uint256 cardId) external constant returns (uint256) {
266     return SafeMath.mul(cardInfo[cardId].ethCost,PLATPrice);
267   }
268 
269   function unitCoinProduction(uint256 cardId) external constant returns (uint256) {
270     return cardInfo[cardId].baseCoinProduction;
271   }
272 
273   function unitAttack(uint256 cardId) external constant returns (uint256) {
274     return battlecardInfo[cardId].attackValue;
275   }
276     
277   function unitDefense(uint256 cardId) external constant returns (uint256) {
278     return battlecardInfo[cardId].defenseValue;
279   }
280 
281   function unitStealingCapacity(uint256 cardId) external constant returns (uint256) {
282     return battlecardInfo[cardId].coinStealingCapacity;
283   }
284   
285   function productionCardIdRange() external constant returns (uint256, uint256) {
286     return (1, currNumOfCards);
287   }
288 
289   function battleCardIdRange() external constant returns (uint256, uint256) {
290     uint256 battleMax = SafeMath.add(39,currNumOfBattleCards);
291     return (40, battleMax);
292   }
293 
294   function upgradeIdRange() external constant returns (uint256, uint256) {
295     return (1, currNumOfUpgrades);
296   }
297  
298   function getcurrNumOfCards() external view returns (uint256) {
299     return currNumOfCards;
300   }
301 
302   function getcurrNumOfUpgrades() external view returns (uint256) {
303     return currNumOfUpgrades;
304   }
305   // get the detail info of card 
306   function getCardsInfo(uint256 cardId) external constant returns (
307     uint256 baseCoinCost,
308     uint256 coinCostIncreaseHalf,
309     uint256 ethCost, 
310     uint256 baseCoinProduction,
311     uint256 platCost, 
312     bool  unitSellable
313   ) {
314     baseCoinCost = cardInfo[cardId].baseCoinCost;
315     coinCostIncreaseHalf = cardInfo[cardId].coinCostIncreaseHalf;
316     ethCost = cardInfo[cardId].ethCost;
317     baseCoinProduction = cardInfo[cardId].baseCoinProduction;
318     platCost = SafeMath.mul(ethCost,PLATPrice);
319     unitSellable = cardInfo[cardId].unitSellable;
320   }
321   //for production card
322   function getCardInfo(uint256 cardId, uint256 existing, uint256 amount) external view returns 
323   (uint256, uint256, uint256, uint256, bool) {
324     return (cardInfo[cardId].cardId, 
325     cardInfo[cardId].baseCoinProduction, 
326     getCostForCards(cardId, existing, amount), 
327     SafeMath.mul(cardInfo[cardId].ethCost, amount),
328     cardInfo[cardId].unitSellable);
329   }
330 
331    //for battle card
332   function getBattleCardInfo(uint256 cardId, uint256 existing, uint256 amount) external constant returns 
333   (uint256, uint256, uint256, bool) {
334     return (battlecardInfo[cardId].cardId, 
335     getCostForBattleCards(cardId, existing, amount), 
336     SafeMath.mul(battlecardInfo[cardId].ethCost, amount),
337     battlecardInfo[cardId].unitSellable);
338   }
339 
340   //Battle Cards
341   function getBattleCardsInfo(uint256 cardId) external constant returns (
342     uint256 baseCoinCost,
343     uint256 coinCostIncreaseHalf,
344     uint256 ethCost, 
345     uint256 attackValue,
346     uint256 defenseValue,
347     uint256 coinStealingCapacity,
348     uint256 platCost,
349     bool  unitSellable
350   ) {
351     baseCoinCost = battlecardInfo[cardId].baseCoinCost;
352     coinCostIncreaseHalf = battlecardInfo[cardId].coinCostIncreaseHalf;
353     ethCost = battlecardInfo[cardId].ethCost;
354     attackValue = battlecardInfo[cardId].attackValue;
355     defenseValue = battlecardInfo[cardId].defenseValue;
356     coinStealingCapacity = battlecardInfo[cardId].coinStealingCapacity;
357     platCost = SafeMath.mul(ethCost,PLATPrice);
358     unitSellable = battlecardInfo[cardId].unitSellable;
359   }
360 
361   function getUpgradeInfo(uint256 upgradeId) external constant returns (uint256 coinCost, 
362     uint256 ethCost, 
363     uint256 upgradeClass, 
364     uint256 cardId, 
365     uint256 upgradeValue,
366     uint256 platCost) {
367     
368     coinCost = upgradeInfo[upgradeId].coinCost;
369     ethCost = upgradeInfo[upgradeId].ethCost;
370     upgradeClass = upgradeInfo[upgradeId].upgradeClass;
371     cardId = upgradeInfo[upgradeId].cardId;
372     upgradeValue = upgradeInfo[upgradeId].upgradeValue;
373     platCost = SafeMath.mul(ethCost,PLATPrice);
374   }
375     //upgrade cards
376   function getUpgradeCardsInfo(uint256 upgradecardId, uint256 existing) external constant returns (
377     uint256 coinCost, 
378     uint256 ethCost, 
379     uint256 upgradeClass, 
380     uint256 cardId, 
381     uint256 upgradeValue,
382     uint256 platCost
383     ) {
384     coinCost = upgradeInfo[upgradecardId].coinCost;
385     ethCost = upgradeInfo[upgradecardId].ethCost;
386     upgradeClass = upgradeInfo[upgradecardId].upgradeClass;
387     cardId = upgradeInfo[upgradecardId].cardId;
388     if (upgradeClass==8) {
389       upgradeValue = upgradeInfo[upgradecardId].upgradeValue;
390       if (ethCost>0) {
391         if (existing==1) {
392           ethCost = 0.2 ether;
393         } else if (existing==2) {
394           ethCost = 0.5 ether;
395         }
396       } else {
397         bool bf = false;
398         if (upgradecardId == 27 || upgradecardId==30 || upgradecardId==36) { 
399           bf = true;
400         }
401         if (bf == true) {
402           if (existing==1) {
403             coinCost = 0;
404             ethCost = 0.1 ether;
405           } else if (existing==2) {
406             coinCost = 0;
407             ethCost = 0.1 ether;
408           }
409         }else{
410           if (existing==1) {
411             coinCost = coinCost * 10;
412           } else if (existing==2) {
413             coinCost = coinCost * 100;
414           }
415         }
416       }
417 
418       if (existing ==1) {
419         upgradeValue = 9999;
420       }else if (existing==2){
421         upgradeValue = 99999;
422       }
423     } else {
424       uint8 uflag;
425       if (coinCost >0 ) {
426         if (upgradeClass ==0 || upgradeClass ==1 || upgradeClass == 3) {
427           uflag = 1;
428         } else if (upgradeClass==2 || upgradeClass == 4 || upgradeClass==5 || upgradeClass==7) {
429           uflag = 2;
430         }
431       }
432    
433       if (coinCost>0 && existing>=1) {
434         coinCost = getCostForUprade(upgradecardId, existing, 1);
435       }
436       if (ethCost>0) {
437         if (upgradecardId == 2) {
438           if (existing>=1) { 
439             ethCost = SafeMath.mul(ethCost,2);
440           } 
441         } 
442       } else {
443         if ((existing ==1 || existing ==4)) {
444           if (ethCost<=0) {                                                                                                                                                                                                                                                                                                                                                                                                                                                 
445             ethCost = 0.1 ether;
446             coinCost = 0;
447         }
448       }
449     }
450       upgradeValue = upgradeInfo[upgradecardId].upgradeValue;
451       if (ethCost>0) {
452         if (uflag==1) {
453           upgradeValue = upgradeInfo[upgradecardId].upgradeValue * 2;
454         } else if (uflag==2) {
455           upgradeValue = upgradeInfo[upgradecardId].upgradeValue * 4;
456         } else {
457           if (upgradeClass == 6){
458             if (upgradecardId == 27){
459               upgradeValue = upgradeInfo[upgradecardId].upgradeValue * 5;
460             } else if (upgradecardId == 40) {
461               upgradeValue = upgradeInfo[upgradecardId].upgradeValue * 3;
462             }
463           }
464         }
465       }
466     }
467     platCost = SafeMath.mul(ethCost,PLATPrice);
468 
469   }
470 }
471 
472 library SafeMath {
473 
474   /**
475   * @dev Multiplies two numbers, throws on overflow.
476   */
477   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
478     if (a == 0) {
479       return 0;
480     }
481     uint256 c = a * b;
482     assert(c / a == b);
483     return c;
484   }
485 
486   /**
487   * @dev Integer division of two numbers, truncating the quotient.
488   */
489   function div(uint256 a, uint256 b) internal pure returns (uint256) {
490     // assert(b > 0); // Solidity automatically throws when dividing by 0
491     uint256 c = a / b;
492     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
493     return c;
494   }
495 
496   /**
497   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
498   */
499   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
500     assert(b <= a);
501     return a - b;
502   }
503 
504   /**
505   * @dev Adds two numbers, throws on overflow.
506   */
507   function add(uint256 a, uint256 b) internal pure returns (uint256) {
508     uint256 c = a + b;
509     assert(c >= a);
510     return c;
511   }
512 }