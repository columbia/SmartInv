1 pragma solidity ^0.4.25;
2 
3 /**
4  * 
5  * World War Goo - Competitive Idle Game
6  * 
7  * https://ethergoo.io
8  * 
9  */
10 
11 contract Factories {
12 
13     GooToken constant goo = GooToken(0xdf0960778c6e6597f197ed9a25f12f5d971da86c);
14     Units units = Units(0x0);
15     Inventory inventory = Inventory(0x0);
16 
17     mapping(address => uint256[]) private playerFactories;
18     mapping(uint256 => mapping(uint256 => uint32[8])) public tileBonuses; // Tile -> UnitId -> Bonus
19     mapping(address => bool) operator;
20 
21     address owner; // Minor management
22     uint256 public constant MAX_SIZE = 40;
23 
24     constructor() public {
25         owner = msg.sender;
26     }
27 
28     function setUnits(address unitsContract) external {
29         require(msg.sender == owner); // TODO hardcode for launch?
30         units = Units(unitsContract);
31     }
32 
33     function setInventory(address inventoryContract) external {
34         require(msg.sender == owner); // TODO hardcode for launch?
35         inventory = Inventory(inventoryContract);
36     }
37 
38     function setOperator(address gameContract, bool isOperator) external {
39         require(msg.sender == owner);
40         operator[gameContract] = isOperator;
41     }
42 
43     function getFactories(address player) external view returns (uint256[]) {
44         return playerFactories[player];
45     }
46 
47     // For website
48     function getPlayersUnits(address player) external view returns (uint256[], uint80[], uint224[], uint32[], uint256[]) {
49         uint80[] memory unitsOwnedByFactory = new uint80[](playerFactories[player].length);
50         uint224[] memory unitsExperience = new uint224[](playerFactories[player].length);
51         uint32[] memory unitsLevel = new uint32[](playerFactories[player].length);
52         uint256[] memory unitsEquipment = new uint256[](playerFactories[player].length);
53 
54         for (uint256 i = 0; i < playerFactories[player].length; i++) {
55             (unitsOwnedByFactory[i],) = units.unitsOwned(player, playerFactories[player][i]);
56             (unitsExperience[i], unitsLevel[i]) = units.unitExp(player, playerFactories[player][i]);
57             unitsEquipment[i] = inventory.getEquippedItemId(player, playerFactories[player][i]);
58         }
59 
60         return (playerFactories[player], unitsOwnedByFactory, unitsExperience, unitsLevel, unitsEquipment);
61     }
62 
63     function addFactory(address player, uint8 position, uint256 unitId) external {
64         require(position < MAX_SIZE);
65         require(msg.sender == address(units));
66 
67         uint256[] storage factories = playerFactories[player];
68         if (factories.length > position) {
69             require(factories[position] == 0); // Empty space
70         } else {
71             factories.length = position + 1; // Make space
72         }
73         factories[position] = unitId;
74 
75         // Grant buff to unit
76         uint32[8] memory upgradeGains = tileBonuses[getAddressDigit(player, position)][unitId];
77         if (upgradeGains[0] > 0 || upgradeGains[1] > 0 || upgradeGains[2] > 0 || upgradeGains[3] > 0 || upgradeGains[4] > 0 || upgradeGains[5] > 0 || upgradeGains[6] > 0 || upgradeGains[7] > 0) {
78             units.increaseUpgradesExternal(player, unitId, upgradeGains[0], upgradeGains[1], upgradeGains[2], upgradeGains[3], upgradeGains[4], upgradeGains[5], upgradeGains[6], upgradeGains[7]);
79         }
80     }
81 
82     function moveFactory(uint8 position, uint8 newPosition) external {
83         require(newPosition < MAX_SIZE);
84 
85         uint256[] storage factories = playerFactories[msg.sender];
86         uint256 existingFactory = factories[position];
87         require(existingFactory > 0); // Existing factory
88 
89         if (factories.length > newPosition) {
90             require(factories[newPosition] == 0); // Empty space
91         } else {
92             factories.length = newPosition + 1; // Make space
93         }
94 
95         factories[newPosition] = existingFactory;
96         delete factories[position];
97 
98         uint32[8] memory newBonus = tileBonuses[getAddressDigit(msg.sender, newPosition)][existingFactory];
99         uint32[8] memory oldBonus = tileBonuses[getAddressDigit(msg.sender, position)][existingFactory];
100         units.swapUpgradesExternal(msg.sender, existingFactory, newBonus, oldBonus);
101     }
102 
103     function getAddressDigit(address player, uint8 position) public pure returns (uint) {
104         return (uint(player) >> (156 - position * 4)) & 0x0f;
105     }
106 
107     function addTileBonus(uint256 tile, uint256 unit, uint32[8] upgradeGains) external {
108         require(operator[msg.sender]);
109         tileBonuses[tile][unit] = upgradeGains;
110     }
111 
112 }
113 
114 
115 
116 contract GooToken {
117     function updatePlayersGoo(address player) external;
118     function increasePlayersGooProduction(address player, uint256 increase) external;
119 }
120 
121 contract Units {
122     mapping(address => mapping(uint256 => UnitsOwned)) public unitsOwned;
123     mapping(address => mapping(uint256 => UnitExperience)) public unitExp;
124     function increaseUpgradesExternal(address player, uint256 unitId, uint32 prodIncrease, uint32 prodMultiplier, uint32 attackIncrease, uint32 attackMultiplier, uint32 defenseIncrease, uint32 defenseMultiplier, uint32 lootingIncrease, uint32 lootingMultiplier) external;
125     function swapUpgradesExternal(address player, uint256 unitId, uint32[8] upgradeGains, uint32[8] upgradeLosses) external;
126     
127     struct UnitsOwned {
128         uint80 units;
129         uint8 factoryBuiltFlag; // Incase user sells units, we still want to keep factory
130     }
131     
132     struct UnitExperience {
133         uint224 experience;
134         uint32 level;
135     }
136 }
137 
138 contract Inventory {
139     function getEquippedItemId(address player, uint256 unitId) external view returns (uint256);
140 }