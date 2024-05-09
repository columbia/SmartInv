1 pragma solidity ^0.4.18;
2 /* ==================================================================== */
3 /* Copyright (c) 2018 The MagicAcademy Project.  All rights reserved.
4 /* 
5 /* https://www.magicacademy.io One of the world's first idle strategy games of blockchain 
6 /*  
7 /* authors rainy@livestar.com/fanny.zheng@livestar.com
8 /*                 
9 /* ==================================================================== */
10 interface CardsInterface {
11   function getJadeProduction(address player) external constant returns (uint256);
12   function getOwnedCount(address player, uint256 cardId) external view returns (uint256);
13   function getUpgradesOwned(address player, uint256 upgradeId) external view returns (uint256);
14   function getUintCoinProduction(address _address, uint256 cardId) external view returns (uint256);
15   function getUnitCoinProductionMultiplier(address _address, uint256 cardId) external view returns (uint256);
16   function getUnitCoinProductionIncreases(address _address, uint256 cardId) external view returns (uint256);
17   function getUnitAttackIncreases(address _address, uint256 cardId) external view returns (uint256);
18   function getUnitAttackMultiplier(address _address, uint256 cardId) external view returns (uint256);
19   function getUnitDefenseIncreases(address _address, uint256 cardId) external view returns (uint256);
20   function getUnitDefenseMultiplier(address _address, uint256 cardId) external view returns (uint256);
21   function getUnitJadeStealingIncreases(address _address, uint256 cardId) external view returns (uint256);
22   function getUnitJadeStealingMultiplier(address _address, uint256 cardId) external view returns (uint256);
23   function getUnitsProduction(address player, uint256 cardId, uint256 amount) external constant returns (uint256);
24   function getTotalEtherPool(uint8 itype) external view returns (uint256);
25   function coinBalanceOf(address player,uint8 itype) external constant returns(uint256);
26   function balanceOf(address player) public constant returns(uint256);
27    function getPlayersBattleStats(address player) public constant returns (
28     uint256 attackingPower, 
29     uint256 defendingPower, 
30     uint256 stealingPower,
31     uint256 battlePower);
32   function getTotalJadeProduction() external view returns (uint256);
33   function getNextSnapshotTime() external view returns(uint256);
34 }
35 
36 interface GameConfigInterface {
37   function productionCardIdRange() external constant returns (uint256, uint256);
38   function battleCardIdRange() external constant returns (uint256, uint256);
39   function upgradeIdRange() external constant returns (uint256, uint256); 
40   function unitCoinProduction(uint256 cardId) external constant returns (uint256);
41   function unitAttack(uint256 cardId) external constant returns (uint256);
42   function unitDefense(uint256 cardId) external constant returns (uint256); 
43   function unitStealingCapacity(uint256 cardId) external constant returns (uint256);
44 }
45 
46 contract CardsRead {
47   using SafeMath for SafeMath;
48 
49   CardsInterface public cards;
50   GameConfigInterface public schema;
51   address owner;
52   
53 
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59   function CardsRead() public {
60     owner = msg.sender;
61   }
62     //setting configuration
63   function setConfigAddress(address _address) external onlyOwner {
64     schema = GameConfigInterface(_address);
65   }
66 
67      //setting configuration
68   function setCardsAddress(address _address) external onlyOwner {
69     cards = CardsInterface(_address);
70   }
71 
72   // get normal cardlist;
73   function getNormalCardList(address _owner) external view returns(uint256[],uint256[]){
74     uint256 startId;
75     uint256 endId;
76     (startId,endId) = schema.productionCardIdRange(); 
77     uint256 len = SafeMath.add(SafeMath.sub(endId,startId),1);
78     uint256[] memory itemId = new uint256[](len);
79     uint256[] memory itemNumber = new uint256[](len);
80 
81     uint256 i;
82     while (startId <= endId) {
83       itemId[i] = startId;
84       itemNumber[i] = cards.getOwnedCount(_owner,startId);
85       i++;
86       startId++;
87       }   
88     return (itemId, itemNumber);
89   }
90 
91   // get normal cardlist;
92   function getBattleCardList(address _owner) external view returns(uint256[],uint256[]){
93     uint256 startId;
94     uint256 endId;
95     (startId,endId) = schema.battleCardIdRange();
96     uint256 len = SafeMath.add(SafeMath.sub(endId,startId),1);
97     uint256[] memory itemId = new uint256[](len);
98     uint256[] memory itemNumber = new uint256[](len);
99 
100     uint256 i;
101     while (startId <= endId) {
102       itemId[i] = startId;
103       itemNumber[i] = cards.getOwnedCount(_owner,startId);
104       i++;
105       startId++;
106       }   
107     return (itemId, itemNumber);
108   }
109 
110   // get upgrade cardlist;
111   function getUpgradeCardList(address _owner) external view returns(uint256[],uint256[]){
112     uint256 startId;
113     uint256 endId;
114     (startId, endId) = schema.upgradeIdRange();
115     uint256 len = SafeMath.add(SafeMath.sub(endId,startId),1);
116     uint256[] memory itemId = new uint256[](len);
117     uint256[] memory itemNumber = new uint256[](len);
118 
119     uint256 i;
120     while (startId <= endId) {
121       itemId[i] = startId;
122       itemNumber[i] = cards.getUpgradesOwned(_owner,startId);
123       i++;
124       startId++;
125       }   
126     return (itemId, itemNumber);
127   }
128 
129     //get up value
130   function getUpgradeValue(address player, uint256 upgradeClass, uint256 unitId, uint256 upgradeValue) external view returns (
131     uint256 productionGain ,uint256 preValue,uint256 afterValue) {
132     if (cards.getOwnedCount(player,unitId) == 0) {
133       if (upgradeClass == 0) {
134         productionGain = upgradeValue * 10;
135         preValue = schema.unitCoinProduction(unitId);
136         afterValue   = preValue + productionGain;
137       } else if (upgradeClass == 1){
138         productionGain = upgradeValue * schema.unitCoinProduction(unitId);
139         preValue = schema.unitCoinProduction(unitId);
140         afterValue   = preValue + productionGain;
141       } 
142     }else { // >= 1
143       if (upgradeClass == 0) {
144         productionGain = (cards.getOwnedCount(player,unitId) * upgradeValue * (10 + cards.getUnitCoinProductionMultiplier(player,unitId)));
145         preValue = cards.getUintCoinProduction(player,unitId);
146         afterValue   = preValue + productionGain;
147      } else if (upgradeClass == 1) {
148         productionGain = (cards.getOwnedCount(player,unitId) * upgradeValue * (schema.unitCoinProduction(unitId) + cards.getUnitCoinProductionIncreases(player,unitId)));
149         preValue = cards.getUintCoinProduction(player,unitId);
150         afterValue   = preValue + productionGain;
151      }
152     }
153   }
154 
155  // To display on website
156   function getGameInfo() external view returns (uint256,  uint256, uint256, uint256, uint256, uint256, uint256[], uint256[], uint256[]){  
157     uint256 startId;
158     uint256 endId;
159     (startId,endId) = schema.productionCardIdRange();
160     uint256 len = SafeMath.add(SafeMath.sub(endId,startId),1); 
161     uint256[] memory units = new uint256[](len);
162         
163     uint256 i;
164     while (startId <= endId) {
165       units[i] = cards.getOwnedCount(msg.sender,startId);
166       i++;
167       startId++;
168     }
169       
170     (startId,endId) = schema.battleCardIdRange();
171     len = SafeMath.add(SafeMath.sub(endId,startId),1);
172     uint256[] memory battles = new uint256[](len);
173     
174     i=0; //reset for battle cards
175     while (startId <= endId) {
176       battles[i] = cards.getOwnedCount(msg.sender,startId);
177       i++;
178       startId++;
179     }
180         
181     // Reset for upgrades
182     i = 0;
183     (startId, endId) = schema.upgradeIdRange();
184     len = SafeMath.add(SafeMath.sub(endId,startId),1);
185     uint256[] memory upgrades = new uint256[](len);
186 
187     while (startId <= endId) {
188       upgrades[i] = cards.getUpgradesOwned(msg.sender,startId);
189       i++;
190       startId++;
191     }
192     return (
193     cards.getTotalEtherPool(1), 
194     cards.getJadeProduction(msg.sender),
195     cards.balanceOf(msg.sender), 
196     cards.coinBalanceOf(msg.sender,1),
197     cards.getTotalJadeProduction(),
198     cards.getNextSnapshotTime(), 
199     units, battles,upgrades
200     );
201   }
202 }
203 
204 library SafeMath {
205 
206   /**
207   * @dev Multiplies two numbers, throws on overflow.
208   */
209   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
210     if (a == 0) {
211       return 0;
212     }
213     uint256 c = a * b;
214     assert(c / a == b);
215     return c;
216   }
217 
218   /**
219   * @dev Integer division of two numbers, truncating the quotient.
220   */
221   function div(uint256 a, uint256 b) internal pure returns (uint256) {
222     // assert(b > 0); // Solidity automatically throws when dividing by 0
223     uint256 c = a / b;
224     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
225     return c;
226   }
227 
228   /**
229   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
230   */
231   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
232     assert(b <= a);
233     return a - b;
234   }
235 
236   /**
237   * @dev Adds two numbers, throws on overflow.
238   */
239   function add(uint256 a, uint256 b) internal pure returns (uint256) {
240     uint256 c = a + b;
241     assert(c >= a);
242     return c;
243   }
244 }