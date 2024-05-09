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
11 contract GameConfig {
12   using SafeMath for SafeMath;
13   address public owner;
14 
15   /**event**/
16   event newCard(uint256 cardId,uint256 baseCoinCost,uint256 coinCostIncreaseHalf,uint256 ethCost,uint256 baseCoinProduction);
17   event newBattleCard(uint256 cardId,uint256 baseCoinCost,uint256 coinCostIncreaseHalf,uint256 ethCost,uint256 attackValue,uint256 defenseValue,uint256 coinStealingCapacity);
18   event newUpgradeCard(uint256 upgradecardId, uint256 coinCost, uint256 ethCost, uint256 upgradeClass, uint256 cardId, uint256 upgradeValue, uint256 increase);
19   
20   struct Card {
21     uint256 cardId;
22     uint256 baseCoinCost;
23     uint256 coinCostIncreaseHalf; // Halfed to make maths slightly less (cancels a 2 out)
24     uint256 ethCost;
25     uint256 baseCoinProduction;
26     bool unitSellable; // Rare units (from raffle) not sellable
27   }
28 
29 
30   struct BattleCard {
31     uint256 cardId;
32     uint256 baseCoinCost;
33     uint256 coinCostIncreaseHalf; // Halfed to make maths slightly less (cancels a 2 out)
34     uint256 ethCost;
35     uint256 attackValue;
36     uint256 defenseValue;
37     uint256 coinStealingCapacity;
38     bool unitSellable; // Rare units (from raffle) not sellable
39   }
40   
41   struct UpgradeCard {
42     uint256 upgradecardId;
43     uint256 coinCost;
44     uint256 ethCost;
45     uint256 upgradeClass;
46     uint256 cardId;
47     uint256 upgradeValue;
48     uint256 increase;
49   }
50   
51   /** mapping**/
52   mapping(uint256 => Card) private cardInfo;  //normal card
53   mapping(uint256 => BattleCard) private battlecardInfo;  //battle card
54   mapping(uint256 => UpgradeCard) private upgradeInfo;  //upgrade card
55      
56   uint256 public currNumOfCards;  
57   uint256 public currNumOfBattleCards;  
58   uint256 public currNumOfUpgrades; 
59 
60   uint256 public Max_CAP = 99;
61   uint256 PLATPrice = 65000;
62   string versionNo;
63  
64   // Constructor 
65   function GameConfig() public {
66     owner = msg.sender;
67     versionNo = "20180523";
68   }
69   modifier onlyOwner() {
70     require(msg.sender == owner);
71     _;
72   }
73 
74   address allowed; 
75   function setAllowedAddress(address _address) external onlyOwner {
76     require(_address != address(0));
77     allowed = _address;
78   }
79   modifier onlyAccess() {
80     require(msg.sender == allowed || msg.sender == owner);
81     _;
82   }
83 
84   function setMaxCAP(uint256 iMax) external onlyOwner {
85     Max_CAP = iMax;
86   }
87   function getMaxCAP() external view returns (uint256) {
88     return Max_CAP;
89   }
90   function setPLATPrice(uint256 price) external onlyOwner {
91     PLATPrice = price;
92   }
93   function getPLATPrice() external view returns (uint256) {
94     return PLATPrice;
95   }
96   function getVersion() external view returns(string) {
97     return versionNo;
98   }
99   function setVersion(string _versionNo) external onlyOwner {
100     versionNo = _versionNo;
101   }
102   function CreateBattleCards(uint256 _cardId, uint256 _baseCoinCost, uint256 _coinCostIncreaseHalf, uint256 _ethCost, uint _attackValue, uint256 _defenseValue, uint256 _coinStealingCapacity, bool _unitSellable) external onlyAccess {
103     BattleCard memory _battlecard = BattleCard({
104       cardId: _cardId,
105       baseCoinCost: _baseCoinCost,
106       coinCostIncreaseHalf: _coinCostIncreaseHalf,
107       ethCost: _ethCost,
108       attackValue: _attackValue,
109       defenseValue: _defenseValue,
110       coinStealingCapacity: _coinStealingCapacity,
111       unitSellable: _unitSellable
112     });
113     battlecardInfo[_cardId] = _battlecard;
114     currNumOfBattleCards = SafeMath.add(currNumOfBattleCards,1);
115     newBattleCard(_cardId,_baseCoinCost,_coinCostIncreaseHalf,_ethCost,_attackValue,_defenseValue,_coinStealingCapacity);
116     
117   }
118 
119   function CreateCards(uint256 _cardId, uint256 _baseCoinCost, uint256 _coinCostIncreaseHalf, uint256 _ethCost, uint256 _baseCoinProduction, bool _unitSellable) external onlyAccess {
120     Card memory _card = Card({
121       cardId: _cardId,
122       baseCoinCost: _baseCoinCost,
123       coinCostIncreaseHalf: _coinCostIncreaseHalf,
124       ethCost: _ethCost,
125       baseCoinProduction: _baseCoinProduction,
126       unitSellable: _unitSellable
127     });
128     cardInfo[_cardId] = _card;
129     currNumOfCards = SafeMath.add(currNumOfCards,1);
130     newCard(_cardId,_baseCoinCost,_coinCostIncreaseHalf,_ethCost,_baseCoinProduction);
131   }
132 
133   function CreateUpgradeCards(uint256 _upgradecardId, uint256 _coinCost, uint256 _ethCost, uint256 _upgradeClass, uint256 _cardId, uint256 _upgradeValue, uint256 _increase) external onlyAccess {
134     UpgradeCard memory _upgradecard = UpgradeCard({
135       upgradecardId: _upgradecardId,
136       coinCost: _coinCost,
137       ethCost: _ethCost,
138       upgradeClass: _upgradeClass,
139       cardId: _cardId,
140       upgradeValue: _upgradeValue,
141       increase: _increase
142     });
143     upgradeInfo[_upgradecardId] = _upgradecard;
144     currNumOfUpgrades = SafeMath.add(currNumOfUpgrades,1);
145     newUpgradeCard(_upgradecardId,_coinCost,_ethCost,_upgradeClass,_cardId,_upgradeValue,_increase); 
146   }
147 
148   function getCostForCards(uint256 cardId, uint256 existing, uint256 amount) public constant returns (uint256) {
149     uint256 icount = existing;
150     if (amount == 1) { 
151       if (existing == 0) {  
152         return cardInfo[cardId].baseCoinCost; 
153       } else {
154         return cardInfo[cardId].baseCoinCost + (existing * cardInfo[cardId].coinCostIncreaseHalf * 2);
155             }
156     } else if (amount > 1) { 
157       uint256 existingCost;
158       if (existing > 0) {
159         existingCost = (cardInfo[cardId].baseCoinCost * existing) + (existing * (existing - 1) * cardInfo[cardId].coinCostIncreaseHalf);
160       }
161       icount = SafeMath.add(existing,amount);  
162       uint256 newCost = SafeMath.add(SafeMath.mul(cardInfo[cardId].baseCoinCost, icount), SafeMath.mul(SafeMath.mul(icount, (icount - 1)), cardInfo[cardId].coinCostIncreaseHalf));
163       return newCost - existingCost;
164       }
165   }
166 
167   function getCostForBattleCards(uint256 cardId, uint256 existing, uint256 amount) public constant returns (uint256) {
168     uint256 icount = existing;
169     if (amount == 1) { 
170       if (existing == 0) {  
171         return battlecardInfo[cardId].baseCoinCost; 
172       } else {
173         return battlecardInfo[cardId].baseCoinCost + (existing * battlecardInfo[cardId].coinCostIncreaseHalf * 2);
174             }
175     } else if (amount > 1) {
176       uint256 existingCost;
177       if (existing > 0) {
178         existingCost = (battlecardInfo[cardId].baseCoinCost * existing) + (existing * (existing - 1) * battlecardInfo[cardId].coinCostIncreaseHalf);
179       }
180       icount = SafeMath.add(existing,amount);  
181       uint256 newCost = SafeMath.add(SafeMath.mul(battlecardInfo[cardId].baseCoinCost, icount), SafeMath.mul(SafeMath.mul(icount, (icount - 1)), battlecardInfo[cardId].coinCostIncreaseHalf));
182       return newCost - existingCost;
183     }
184   }
185 
186   function getCostForUprade(uint256 cardId, uint256 existing, uint256 amount) public constant returns (uint256) {
187     if (amount == 1) { 
188       if (existing == 0) {  
189         return upgradeInfo[cardId].coinCost; 
190       } else if (existing == 1 || existing == 4){
191         return 0;
192       }else if (existing == 2) {
193         return upgradeInfo[cardId].coinCost * 50; 
194     }else if (existing == 3) {
195       return upgradeInfo[cardId].coinCost * 50 * 40; 
196     }else if (existing == 5) {
197       return upgradeInfo[cardId].coinCost * 50 * 40 * 30; 
198     }
199   }
200   }
201 
202   function getWeakenedDefensePower(uint256 defendingPower) external pure returns (uint256) {
203     return SafeMath.div(defendingPower,2);
204   }
205  
206     /// @notice get the production card's ether cost
207   function unitEthCost(uint256 cardId) external constant returns (uint256) {
208     return cardInfo[cardId].ethCost;
209   }
210 
211     /// @notice get the battle card's ether cost
212   function unitBattleEthCost(uint256 cardId) external constant returns (uint256) {
213     return battlecardInfo[cardId].ethCost;
214   }
215   /// @notice get the battle card's plat cost
216   function unitBattlePLATCost(uint256 cardId) external constant returns (uint256) {
217     return SafeMath.mul(battlecardInfo[cardId].ethCost,PLATPrice);
218   }
219 
220     /// @notice normal production plat value
221   function unitPLATCost(uint256 cardId) external constant returns (uint256) {
222     return SafeMath.mul(cardInfo[cardId].ethCost,PLATPrice);
223   }
224 
225   function unitCoinProduction(uint256 cardId) external constant returns (uint256) {
226     return cardInfo[cardId].baseCoinProduction;
227   }
228 
229   function unitAttack(uint256 cardId) external constant returns (uint256) {
230     return battlecardInfo[cardId].attackValue;
231   }
232     
233   function unitDefense(uint256 cardId) external constant returns (uint256) {
234     return battlecardInfo[cardId].defenseValue;
235   }
236 
237   function unitStealingCapacity(uint256 cardId) external constant returns (uint256) {
238     return battlecardInfo[cardId].coinStealingCapacity;
239   }
240   
241   function productionCardIdRange() external constant returns (uint256, uint256) {
242     return (1, currNumOfCards);
243   }
244 
245   function battleCardIdRange() external constant returns (uint256, uint256) {
246     uint256 battleMax = SafeMath.add(39,currNumOfBattleCards);
247     return (40, battleMax);
248   }
249 
250   function upgradeIdRange() external constant returns (uint256, uint256) {
251     return (1, currNumOfUpgrades);
252   }
253  
254   // get the detail info of card 
255   function getCardsInfo(uint256 cardId) external constant returns (
256     uint256 baseCoinCost,
257     uint256 coinCostIncreaseHalf,
258     uint256 ethCost, 
259     uint256 baseCoinProduction,
260     uint256 platCost, 
261     bool  unitSellable
262   ) {
263     baseCoinCost = cardInfo[cardId].baseCoinCost;
264     coinCostIncreaseHalf = cardInfo[cardId].coinCostIncreaseHalf;
265     ethCost = cardInfo[cardId].ethCost;
266     baseCoinProduction = cardInfo[cardId].baseCoinProduction;
267     platCost = SafeMath.mul(ethCost,PLATPrice);
268     unitSellable = cardInfo[cardId].unitSellable;
269   }
270   //for production card
271   function getCardInfo(uint256 cardId, uint256 existing, uint256 amount) external constant returns (uint256, uint256, uint256, uint256, bool) {
272     return (cardInfo[cardId].cardId, cardInfo[cardId].baseCoinProduction, getCostForCards(cardId, existing, amount), SafeMath.mul(cardInfo[cardId].ethCost, amount),cardInfo[cardId].unitSellable);
273   }
274 
275    //for battle card
276   function getBattleCardInfo(uint256 cardId, uint256 existing, uint256 amount) external constant returns (uint256, uint256, uint256, bool) {
277     return (battlecardInfo[cardId].cardId, getCostForBattleCards(cardId, existing, amount), SafeMath.mul(battlecardInfo[cardId].ethCost, amount),battlecardInfo[cardId].unitSellable);
278   }
279 
280   //Battle Cards
281   function getBattleCardsInfo(uint256 cardId) external constant returns (
282     uint256 baseCoinCost,
283     uint256 coinCostIncreaseHalf,
284     uint256 ethCost, 
285     uint256 attackValue,
286     uint256 defenseValue,
287     uint256 coinStealingCapacity,
288     uint256 platCost,
289     bool  unitSellable
290   ) {
291     baseCoinCost = battlecardInfo[cardId].baseCoinCost;
292     coinCostIncreaseHalf = battlecardInfo[cardId].coinCostIncreaseHalf;
293     ethCost = battlecardInfo[cardId].ethCost;
294     attackValue = battlecardInfo[cardId].attackValue;
295     defenseValue = battlecardInfo[cardId].defenseValue;
296     coinStealingCapacity = battlecardInfo[cardId].coinStealingCapacity;
297     platCost = SafeMath.mul(ethCost,PLATPrice);
298     unitSellable = battlecardInfo[cardId].unitSellable;
299   }
300 
301     //upgrade cards
302   function getUpgradeCardsInfo(uint256 upgradecardId, uint256 existing) external constant returns (
303     uint256 coinCost, 
304     uint256 ethCost, 
305     uint256 upgradeClass, 
306     uint256 cardId, 
307     uint256 upgradeValue,
308     uint256 platCost
309     ) {
310     coinCost = upgradeInfo[upgradecardId].coinCost;
311     ethCost = upgradeInfo[upgradecardId].ethCost;
312     upgradeClass = upgradeInfo[upgradecardId].upgradeClass;
313     cardId = upgradeInfo[upgradecardId].cardId;
314     uint8 uflag;
315     if (coinCost >0 ) {
316       if (upgradeClass ==0 || upgradeClass ==1 || upgradeClass == 3) {
317         uflag = 1;
318       } else if (upgradeClass==2 || upgradeClass == 4 || upgradeClass==5 || upgradeClass==7) {
319         uflag = 2;
320       } 
321     }
322   
323     if (coinCost>0 && existing>=1) {
324       coinCost = getCostForUprade(upgradecardId, existing, 1);
325     }                                                        
326     if (ethCost>0) {
327       if (upgradecardId == 2) {
328         if (existing>=1) { 
329           ethCost = SafeMath.mul(ethCost,2);
330         } 
331       }
332     }else {
333       if ((existing ==1 || existing ==4)) {
334         if (ethCost<=0) {                                                                                                                                                                                                                                                                                                                                                                                                                                                 
335           ethCost = 0.1 ether;
336           coinCost = 0;
337       }
338     }
339     }
340     upgradeValue = upgradeInfo[upgradecardId].upgradeValue;
341     if (ethCost>0) {
342       if (uflag==1) {
343         upgradeValue = upgradeInfo[upgradecardId].upgradeValue * 2;
344       } else if (uflag==2) {
345         upgradeValue = upgradeInfo[upgradecardId].upgradeValue * 4;
346       } else {
347         if (upgradeClass == 6){
348           if (upgradecardId == 27){
349             upgradeValue = upgradeInfo[upgradecardId].upgradeValue * 5;
350           } else if (upgradecardId == 40) {
351             upgradeValue = upgradeInfo[upgradecardId].upgradeValue * 3;
352           }
353         }
354         
355       }
356     }
357 
358     platCost = SafeMath.mul(ethCost,PLATPrice);
359   }
360 }
361 
362 
363 library SafeMath {
364 
365   /**
366   * @dev Multiplies two numbers, throws on overflow.
367   */
368   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
369     if (a == 0) {
370       return 0;
371     }
372     uint256 c = a * b;
373     assert(c / a == b);
374     return c;
375   }
376 
377   /**
378   * @dev Integer division of two numbers, truncating the quotient.
379   */
380   function div(uint256 a, uint256 b) internal pure returns (uint256) {
381     // assert(b > 0); // Solidity automatically throws when dividing by 0
382     uint256 c = a / b;
383     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
384     return c;
385   }
386 
387   /**
388   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
389   */
390   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
391     assert(b <= a);
392     return a - b;
393   }
394 
395   /**
396   * @dev Adds two numbers, throws on overflow.
397   */
398   function add(uint256 a, uint256 b) internal pure returns (uint256) {
399     uint256 c = a + b;
400     assert(c >= a);
401     return c;
402   }
403 }