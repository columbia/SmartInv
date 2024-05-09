1 pragma solidity ^0.4.18;
2 
3 /// @notice define the game's configuration
4 /// @author rainysiu rainy@livestar.com
5 /// @dev MagicAcademy Games 
6 contract GameConfig {
7   using SafeMath for SafeMath;
8   address public owner;
9 
10   /**event**/
11   event newCard(uint256 cardId,uint256 baseCoinCost,uint256 coinCostIncreaseHalf,uint256 ethCost,uint256 baseCoinProduction);
12   event newBattleCard(uint256 cardId,uint256 baseCoinCost,uint256 coinCostIncreaseHalf,uint256 ethCost,uint256 attackValue,uint256 defenseValue,uint256 coinStealingCapacity);
13   event newUpgradeCard(uint256 upgradecardId, uint256 coinCost, uint256 ethCost, uint256 upgradeClass, uint256 cardId, uint256 upgradeValue, uint256 increase);
14   
15   struct Card {
16     uint256 cardId;
17     uint256 baseCoinCost;
18     uint256 coinCostIncreaseHalf; // Halfed to make maths slightly less (cancels a 2 out)
19     uint256 ethCost;
20     uint256 baseCoinProduction;
21     bool unitSellable; // Rare units (from raffle) not sellable
22   }
23 
24   struct BattleCard {
25     uint256 cardId;
26     uint256 baseCoinCost;
27     uint256 coinCostIncreaseHalf; // Halfed to make maths slightly less (cancels a 2 out)
28     uint256 ethCost;
29     uint256 attackValue;
30     uint256 defenseValue;
31     uint256 coinStealingCapacity;
32     bool unitSellable; // Rare units (from raffle) not sellable
33   }
34   
35   struct UpgradeCard {
36     uint256 upgradecardId;
37     uint256 coinCost;
38     uint256 ethCost;
39     uint256 upgradeClass;
40     uint256 cardId;
41     uint256 upgradeValue;
42     uint256 increase;
43   }
44   
45   /** mapping**/
46   mapping(uint256 => Card) private cardInfo;  //normal card
47   mapping(uint256 => BattleCard) private battlecardInfo;  //battle card
48   mapping(uint256 => UpgradeCard) private upgradeInfo;  //upgrade card
49      
50   uint256 public currNumOfCards;  
51   uint256 public currNumOfBattleCards;  
52   uint256 public currNumOfUpgrades; 
53 
54   uint256 public Max_CAP = 99;
55   uint256 PLATPrice = 65000;
56     
57   // Constructor 
58   function GameConfig() public {
59     owner = msg.sender;
60   }
61   modifier onlyOwner() {
62     require(msg.sender == owner);
63     _;
64   }
65 
66   address allowed; 
67   function setAllowedAddress(address _address) external onlyOwner {
68     require(_address != address(0));
69     allowed = _address;
70   }
71   modifier onlyAccess() {
72     require(msg.sender == allowed || msg.sender == owner);
73     _;
74   }
75 
76   function setMaxCAP(uint256 iMax) external onlyOwner {
77     Max_CAP = iMax;
78   }
79   function getMaxCAP() external view returns (uint256) {
80     return Max_CAP;
81   }
82   function setPLATPrice(uint256 price) external onlyOwner {
83     PLATPrice = price;
84   }
85   function getPLATPrice() external view returns (uint256) {
86     return PLATPrice;
87   }
88 
89   function CreateBattleCards(uint256 _cardId, uint256 _baseCoinCost, uint256 _coinCostIncreaseHalf, uint256 _ethCost, uint _attackValue, uint256 _defenseValue, uint256 _coinStealingCapacity, bool _unitSellable) external onlyAccess {
90     BattleCard memory _battlecard = BattleCard({
91       cardId: _cardId,
92       baseCoinCost: _baseCoinCost,
93       coinCostIncreaseHalf: _coinCostIncreaseHalf,
94       ethCost: _ethCost,
95       attackValue: _attackValue,
96       defenseValue: _defenseValue,
97       coinStealingCapacity: _coinStealingCapacity,
98       unitSellable: _unitSellable
99     });
100     battlecardInfo[_cardId] = _battlecard;
101     currNumOfBattleCards = SafeMath.add(currNumOfBattleCards,1);
102     newBattleCard(_cardId,_baseCoinCost,_coinCostIncreaseHalf,_ethCost,_attackValue,_defenseValue,_coinStealingCapacity);
103     
104   }
105 
106   function CreateCards(uint256 _cardId, uint256 _baseCoinCost, uint256 _coinCostIncreaseHalf, uint256 _ethCost, uint256 _baseCoinProduction, bool _unitSellable) external onlyAccess {
107     Card memory _card = Card({
108       cardId: _cardId,
109       baseCoinCost: _baseCoinCost,
110       coinCostIncreaseHalf: _coinCostIncreaseHalf,
111       ethCost: _ethCost,
112       baseCoinProduction: _baseCoinProduction,
113       unitSellable: _unitSellable
114     });
115     cardInfo[_cardId] = _card;
116     currNumOfCards = SafeMath.add(currNumOfCards,1);
117     newCard(_cardId,_baseCoinCost,_coinCostIncreaseHalf,_ethCost,_baseCoinProduction);
118   }
119 
120   function CreateUpgradeCards(uint256 _upgradecardId, uint256 _coinCost, uint256 _ethCost, uint256 _upgradeClass, uint256 _cardId, uint256 _upgradeValue, uint256 _increase) external onlyAccess {
121     UpgradeCard memory _upgradecard = UpgradeCard({
122       upgradecardId: _upgradecardId,
123       coinCost: _coinCost,
124       ethCost: _ethCost,
125       upgradeClass: _upgradeClass,
126       cardId: _cardId,
127       upgradeValue: _upgradeValue,
128       increase: _increase
129     });
130     upgradeInfo[_upgradecardId] = _upgradecard;
131     currNumOfUpgrades = SafeMath.add(currNumOfUpgrades,1);
132     newUpgradeCard(_upgradecardId,_coinCost,_ethCost,_upgradeClass,_cardId,_upgradeValue,_increase); 
133   }
134 
135   function getCostForCards(uint256 cardId, uint256 existing, uint256 amount) public constant returns (uint256) {
136     uint256 icount = existing;
137     if (amount == 1) { 
138       if (existing == 0) {  
139         return cardInfo[cardId].baseCoinCost; 
140       } else {
141         return cardInfo[cardId].baseCoinCost + (existing * cardInfo[cardId].coinCostIncreaseHalf * 2);
142             }
143     } else if (amount > 1) { 
144       uint256 existingCost;
145       if (existing > 0) {
146         existingCost = (cardInfo[cardId].baseCoinCost * existing) + (existing * (existing - 1) * cardInfo[cardId].coinCostIncreaseHalf);
147       }
148       icount = SafeMath.add(existing,amount);  
149       uint256 newCost = SafeMath.add(SafeMath.mul(cardInfo[cardId].baseCoinCost, icount), SafeMath.mul(SafeMath.mul(icount, (icount - 1)), cardInfo[cardId].coinCostIncreaseHalf));
150       return newCost - existingCost;
151       }
152   }
153 
154   function getCostForBattleCards(uint256 cardId, uint256 existing, uint256 amount) public constant returns (uint256) {
155     uint256 icount = existing;
156     if (amount == 1) { 
157       if (existing == 0) {  
158         return battlecardInfo[cardId].baseCoinCost; 
159       } else {
160         return battlecardInfo[cardId].baseCoinCost + (existing * battlecardInfo[cardId].coinCostIncreaseHalf * 2);
161             }
162     } else if (amount > 1) {
163       uint256 existingCost;
164       if (existing > 0) {
165         existingCost = (battlecardInfo[cardId].baseCoinCost * existing) + (existing * (existing - 1) * battlecardInfo[cardId].coinCostIncreaseHalf);
166       }
167       icount = SafeMath.add(existing,amount);  
168       uint256 newCost = SafeMath.add(SafeMath.mul(battlecardInfo[cardId].baseCoinCost, icount), SafeMath.mul(SafeMath.mul(icount, (icount - 1)), battlecardInfo[cardId].coinCostIncreaseHalf));
169       return newCost - existingCost;
170     }
171   }
172 
173   function getCostForUprade(uint256 cardId, uint256 existing, uint256 amount) public constant returns (uint256) {
174     if (amount == 1) { 
175       if (existing == 0) {  
176         return upgradeInfo[cardId].coinCost; 
177       } else {
178         return upgradeInfo[cardId].coinCost + (existing * upgradeInfo[cardId].increase * 2);
179       }
180     } 
181   }
182 
183   function getWeakenedDefensePower(uint256 defendingPower) external pure returns (uint256) {
184     return SafeMath.div(defendingPower,2);
185   }
186  
187     /// @notice get the production card's ether cost
188   function unitEthCost(uint256 cardId) external constant returns (uint256) {
189     return cardInfo[cardId].ethCost;
190   }
191 
192     /// @notice get the battle card's ether cost
193   function unitBattleEthCost(uint256 cardId) external constant returns (uint256) {
194     return battlecardInfo[cardId].ethCost;
195   }
196   /// @notice get the battle card's plat cost
197   function unitBattlePLATCost(uint256 cardId) external constant returns (uint256) {
198     return SafeMath.mul(battlecardInfo[cardId].ethCost,PLATPrice);
199   }
200 
201     /// @notice normal production plat value
202   function unitPLATCost(uint256 cardId) external constant returns (uint256) {
203     return SafeMath.mul(cardInfo[cardId].ethCost,PLATPrice);
204   }
205 
206   function unitCoinProduction(uint256 cardId) external constant returns (uint256) {
207     return cardInfo[cardId].baseCoinProduction;
208   }
209 
210   function unitAttack(uint256 cardId) external constant returns (uint256) {
211     return battlecardInfo[cardId].attackValue;
212   }
213     
214   function unitDefense(uint256 cardId) external constant returns (uint256) {
215     return battlecardInfo[cardId].defenseValue;
216   }
217 
218   function unitStealingCapacity(uint256 cardId) external constant returns (uint256) {
219     return battlecardInfo[cardId].coinStealingCapacity;
220   }
221   
222   function productionCardIdRange() external constant returns (uint256, uint256) {
223     return (1, currNumOfCards);
224   }
225 
226   function battleCardIdRange() external constant returns (uint256, uint256) {
227     uint256 battleMax = SafeMath.add(39,currNumOfBattleCards);
228     return (40, battleMax);
229   }
230 
231   function upgradeIdRange() external constant returns (uint256, uint256) {
232     return (1, currNumOfUpgrades);
233   }
234  
235   // get the detail info of card 
236   function getCardsInfo(uint256 cardId) external constant returns (
237     uint256 baseCoinCost,
238     uint256 coinCostIncreaseHalf,
239     uint256 ethCost, 
240     uint256 baseCoinProduction,
241     uint256 platCost, 
242     bool  unitSellable
243   ) {
244     baseCoinCost = cardInfo[cardId].baseCoinCost;
245     coinCostIncreaseHalf = cardInfo[cardId].coinCostIncreaseHalf;
246     ethCost = cardInfo[cardId].ethCost;
247     baseCoinProduction = cardInfo[cardId].baseCoinProduction;
248     platCost = SafeMath.mul(ethCost,PLATPrice);
249     unitSellable = cardInfo[cardId].unitSellable;
250   }
251   //for production card
252   function getCardInfo(uint256 cardId, uint256 existing, uint256 amount) external constant returns (uint256, uint256, uint256, uint256, bool) {
253     return (cardInfo[cardId].cardId, cardInfo[cardId].baseCoinProduction, getCostForCards(cardId, existing, amount), SafeMath.mul(cardInfo[cardId].ethCost, amount),cardInfo[cardId].unitSellable);
254   }
255 
256    //for battle card
257   function getBattleCardInfo(uint256 cardId, uint256 existing, uint256 amount) external constant returns (uint256, uint256, uint256, bool) {
258     return (battlecardInfo[cardId].cardId, getCostForBattleCards(cardId, existing, amount), SafeMath.mul(battlecardInfo[cardId].ethCost, amount),battlecardInfo[cardId].unitSellable);
259   }
260 
261   //Battle Cards
262   function getBattleCardsInfo(uint256 cardId) external constant returns (
263     uint256 baseCoinCost,
264     uint256 coinCostIncreaseHalf,
265     uint256 ethCost, 
266     uint256 attackValue,
267     uint256 defenseValue,
268     uint256 coinStealingCapacity,
269     uint256 platCost,
270     bool  unitSellable
271   ) {
272     baseCoinCost = battlecardInfo[cardId].baseCoinCost;
273     coinCostIncreaseHalf = battlecardInfo[cardId].coinCostIncreaseHalf;
274     ethCost = battlecardInfo[cardId].ethCost;
275     attackValue = battlecardInfo[cardId].attackValue;
276     defenseValue = battlecardInfo[cardId].defenseValue;
277     coinStealingCapacity = battlecardInfo[cardId].coinStealingCapacity;
278     platCost = SafeMath.mul(ethCost,PLATPrice);
279     unitSellable = battlecardInfo[cardId].unitSellable;
280   }
281 
282   //upgrade cards
283   function getUpgradeCardsInfo(uint256 upgradecardId, uint256 existing) external constant returns (
284     uint256 coinCost, 
285     uint256 ethCost, 
286     uint256 upgradeClass, 
287     uint256 cardId, 
288     uint256 upgradeValue,
289     uint256 platCost
290     ) {  
291     coinCost = getCostForUprade(upgradecardId, existing, 1);
292     ethCost = upgradeInfo[upgradecardId].ethCost * (100 + 10 * existing)/100;
293     upgradeClass = upgradeInfo[upgradecardId].upgradeClass;
294     cardId = upgradeInfo[upgradecardId].cardId;
295     upgradeValue = upgradeInfo[upgradecardId].upgradeValue + existing;
296     platCost = SafeMath.mul(ethCost,PLATPrice);
297   }
298 }
299 
300 library SafeMath {
301 
302   /**
303   * @dev Multiplies two numbers, throws on overflow.
304   */
305   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
306     if (a == 0) {
307       return 0;
308     }
309     uint256 c = a * b;
310     assert(c / a == b);
311     return c;
312   }
313 
314   /**
315   * @dev Integer division of two numbers, truncating the quotient.
316   */
317   function div(uint256 a, uint256 b) internal pure returns (uint256) {
318     // assert(b > 0); // Solidity automatically throws when dividing by 0
319     uint256 c = a / b;
320     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
321     return c;
322   }
323 
324   /**
325   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
326   */
327   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
328     assert(b <= a);
329     return a - b;
330   }
331 
332   /**
333   * @dev Adds two numbers, throws on overflow.
334   */
335   function add(uint256 a, uint256 b) internal pure returns (uint256) {
336     uint256 c = a + b;
337     assert(c >= a);
338     return c;
339   }
340 }