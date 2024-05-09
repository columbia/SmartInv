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
11 interface CardsInterface {
12   function getJadeProduction(address player) external constant returns (uint256);
13   function getOwnedCount(address player, uint256 cardId) external view returns (uint256);
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
24 }
25 
26 interface GameConfigInterface {
27   function productionCardIdRange() external constant returns (uint256, uint256);
28   function battleCardIdRange() external constant returns (uint256, uint256);
29   function unitCoinProduction(uint256 cardId) external constant returns (uint256);
30   function unitAttack(uint256 cardId) external constant returns (uint256);
31   function unitDefense(uint256 cardId) external constant returns (uint256); 
32   function unitStealingCapacity(uint256 cardId) external constant returns (uint256);
33 }
34 
35 contract CardsRead {
36   CardsInterface public cards;
37   GameConfigInterface public schema;
38   address owner;
39 
40   modifier onlyOwner() {
41     require(msg.sender == owner);
42     _;
43   }
44 
45   function CardsRead() public {
46     owner = msg.sender;
47   }
48     //setting configuration
49   function setConfigAddress(address _address) external onlyOwner {
50     schema = GameConfigInterface(_address);
51   }
52 
53      //setting configuration
54   function setCardsAddress(address _address) external onlyOwner {
55     cards = CardsInterface(_address);
56   }
57   function getNormalCard(address _owner) private view returns (uint256) {
58     uint256 startId;
59     uint256 endId;
60     (startId,endId) = schema.productionCardIdRange(); 
61     uint256 icount;
62     while (startId <= endId) {
63       if (cards.getOwnedCount(_owner,startId)>=1) {
64         icount++;
65       }
66       startId++;
67     }
68     return icount;
69   }
70 
71   function getBattleCard(address _owner) private view returns (uint256) {
72     uint256 startId;
73     uint256 endId;
74     (startId,endId) = schema.battleCardIdRange(); 
75     uint256 icount;
76     while (startId <= endId) {
77       if (cards.getOwnedCount(_owner,startId)>=1) {
78         icount++;
79       }
80       startId++;
81     }
82     return icount;
83   }
84   // get normal cardlist;
85   function getNormalCardList(address _owner) external view returns(uint256[],uint256[]){
86     uint256 len = getNormalCard(_owner);
87     uint256[] memory itemId = new uint256[](len);
88     uint256[] memory itemNumber = new uint256[](len);
89     uint256 startId;
90     uint256 endId;
91     (startId,endId) = schema.productionCardIdRange(); 
92     uint256 i;
93     while (startId <= endId) {
94       if (cards.getOwnedCount(_owner,startId)>=1) {
95         itemId[i] = startId;
96         itemNumber[i] = cards.getOwnedCount(_owner,startId);
97         i++;
98       }
99       startId++;
100       }   
101     return (itemId, itemNumber);
102   }
103 
104   // get normal cardlist;
105   function getBattleCardList(address _owner) external view returns(uint256[],uint256[]){
106     uint256 len = getBattleCard(_owner);
107     uint256[] memory itemId = new uint256[](len);
108     uint256[] memory itemNumber = new uint256[](len);
109 
110     uint256 startId;
111     uint256 endId;
112     (startId,endId) = schema.battleCardIdRange(); 
113 
114     uint256 i;
115     while (startId <= endId) {
116       if (cards.getOwnedCount(_owner,startId)>=1) {
117         itemId[i] = startId;
118         itemNumber[i] = cards.getOwnedCount(_owner,startId);
119         i++;
120       }
121       startId++;
122       }   
123     return (itemId, itemNumber);
124   }
125 
126   //get up value
127   function getUpgradeValue(address player, uint256 upgradeClass, uint256 unitId, uint256 upgradeValue) external view returns (uint256) {
128     uint256 icount = cards.getOwnedCount(player,unitId);
129     uint256 unitProduction = cards.getUintCoinProduction(player,unitId);
130     if (upgradeClass == 0) {
131       if (icount!=0) {
132         return (icount * upgradeValue * 10000 * (10 + cards.getUnitCoinProductionMultiplier(player, unitId))/unitProduction);
133       } else {
134         return (upgradeValue * 10000) / schema.unitCoinProduction(unitId);
135       }
136      } else if (upgradeClass == 1) {
137       if (icount!=0) {
138         return (icount * upgradeValue * 10000 * (schema.unitCoinProduction(unitId) + cards.getUnitCoinProductionIncreases(player,unitId))/unitProduction);
139       }else{
140         return (upgradeValue * 10000) / schema.unitCoinProduction(unitId);  
141       }
142     } else if (upgradeClass == 2) {
143       return (upgradeValue  * 10000)/(schema.unitAttack(unitId) + cards.getUnitAttackIncreases(player,unitId));
144     } else if (upgradeClass == 3) {
145       return (upgradeValue  * 10000)/(10 + cards.getUnitAttackMultiplier(player,unitId));
146     } else if (upgradeClass == 4) {
147       return (upgradeValue  * 10000)/(schema.unitDefense(unitId) + cards.getUnitDefenseIncreases(player,unitId));
148     } else if (upgradeClass == 5) {
149       return (upgradeValue  * 10000)/(10 + cards.getUnitDefenseMultiplier(player,unitId));
150     } else if (upgradeClass == 6) {
151       return (upgradeValue  * 10000)/(schema.unitStealingCapacity(unitId) + cards.getUnitJadeStealingIncreases(player,unitId));
152     } else if (upgradeClass == 7) {
153       return (upgradeValue  * 10000)/(10 + cards.getUnitJadeStealingMultiplier(player,unitId));
154       
155     }
156   }
157 }