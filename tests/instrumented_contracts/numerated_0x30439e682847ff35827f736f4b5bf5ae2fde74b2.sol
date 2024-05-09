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
11 contract Forging {
12     
13     Clans constant clans = Clans(0xe97b5fd7056d38c85c5f6924461f7055588a53d9);
14     Inventory constant inventory = Inventory(0xb545507080b0f63df02ff9bd9302c2bb2447b826);
15     Material constant clothMaterial = Material(0x8a6014227138556a259e7b2bf1dce668f9bdfd06);
16     Material constant woodMaterial = Material(0x6804bbb708b8af0851e2980c8a5e9abb42adb179);
17     Material constant metalMaterial = Material(0xb334f68bf47c1f1c1556e7034954d389d7fbbf07);
18     
19     address owner;
20     mapping(uint256 => Recipe) public randomRecipeList;
21     mapping(uint256 => Recipe) public upgradeRecipeList;
22     
23     struct Recipe {
24         uint256 rarityRequired; // Serves as id [0,1,2]
25         uint256 clothRequired;
26         uint256 woodRequired;
27         uint256 metalRequired;
28         
29         uint256 rarityItemIdStart; // First item id for produced rarity
30         uint256 rarityItemIdEnd; // Last item id for produced rarity
31     }
32  
33     constructor() public {
34         owner = msg.sender;
35     }
36     
37     function addRandomRecipe(uint256 recipeRarity, uint256 cloth, uint256 wood, uint256 metal, uint256 producedItemIdStart, uint256 producedItemIdEnd) external {
38         require(msg.sender == owner);
39         randomRecipeList[recipeRarity] = Recipe(recipeRarity, cloth, wood, metal, producedItemIdStart, producedItemIdEnd);
40     }
41     
42     function addUpgradeRecipe(uint256 recipeRarity, uint256 cloth, uint256 wood, uint256 metal) external {
43         require(msg.sender == owner);
44         upgradeRecipeList[recipeRarity] = Recipe(recipeRarity, cloth, wood, metal, 0, 0);
45     }
46     
47     function forgeRandomItem(uint256 tokenIdOne, uint256 tokenIdTwo, uint256 tokenIdThree) external {
48         require(inventory.tokenOwner(tokenIdOne) == msg.sender);
49         require(inventory.tokenOwner(tokenIdTwo) == msg.sender);
50         require(inventory.tokenOwner(tokenIdThree) == msg.sender);
51         
52         require(tokenIdOne != tokenIdTwo);
53         require(tokenIdOne != tokenIdThree);
54         
55         uint256 itemId1 = inventory.tokenItems(tokenIdOne);
56         uint256 itemId2 = inventory.tokenItems(tokenIdTwo);
57         uint256 itemId3 = inventory.tokenItems(tokenIdThree);
58         Recipe memory recipe;
59         if (itemId1 == itemId2) {
60             recipe = upgradeRecipeList[inventory.getItemRarity(itemId1)];
61             // Check third item rarity matches
62             require(inventory.getItemRarity(itemId3) == recipe.rarityRequired);
63             
64             // Upgrade itemId1
65             inventory.mintItem(itemId1 + 200, msg.sender);
66         } else if (itemId1 == itemId3) {
67             recipe = upgradeRecipeList[inventory.getItemRarity(itemId1)];
68             // Check third item rarity matches
69             require(inventory.getItemRarity(itemId2) == recipe.rarityRequired);
70             
71             // Upgrade itemId1
72             inventory.mintItem(itemId1 + 200, msg.sender);
73         } else if (itemId2 == itemId3) {
74             recipe = upgradeRecipeList[inventory.getItemRarity(itemId2)];
75             // Check third item rarity matches
76             require(inventory.getItemRarity(itemId1) == recipe.rarityRequired);
77             
78              // Upgrade itemId2
79              inventory.mintItem(itemId2 + 200, msg.sender);
80         } else {
81             // Random forge so check three item's rarity matches
82             recipe = randomRecipeList[inventory.getItemRarity(itemId1)];
83             require(inventory.getItemRarity(itemId2) == recipe.rarityRequired);
84             require(inventory.getItemRarity(itemId3) == recipe.rarityRequired);
85             
86             // Mint random item
87             uint256 rng = pseudoRandom(block.timestamp + block.difficulty, block.coinbase);
88             uint256 numItemsLength = (recipe.rarityItemIdEnd - recipe.rarityItemIdStart) + 1;
89   
90             inventory.mintItem(recipe.rarityItemIdStart + (rng % numItemsLength), msg.sender);
91         }
92         
93         // Clan discount
94         uint224 upgradeDiscount = clans.getPlayersClanUpgrade(msg.sender, 2); // class 2 = crafting discount
95 
96         // Burn materials
97         if (recipe.clothRequired > 0) {
98             clothMaterial.burn(recipe.clothRequired - ((recipe.clothRequired * upgradeDiscount) / 100), msg.sender);
99         }
100         if (recipe.woodRequired > 0) {
101             woodMaterial.burn(recipe.woodRequired - ((recipe.woodRequired * upgradeDiscount) / 100), msg.sender);
102         }
103         if (recipe.metalRequired > 0) {
104             metalMaterial.burn(recipe.metalRequired - ((recipe.metalRequired * upgradeDiscount) / 100), msg.sender);
105         }
106         
107         // Burn items
108         inventory.burn(tokenIdOne);
109         inventory.burn(tokenIdTwo);
110         inventory.burn(tokenIdThree);
111     }
112     
113     function pseudoRandom(uint256 seed, address nonce) internal view returns (uint256) {
114         return uint256(keccak256(abi.encodePacked(seed,  block.coinbase, nonce)));
115     }
116     
117 }
118 
119 contract Clans {
120     function getPlayersClanUpgrade(address player, uint256 upgradeClass) external view returns (uint224 upgradeGain);
121 }
122 
123 contract Inventory {
124     mapping(uint256 => Item) public itemList;
125     mapping(uint256 => uint256) public tokenItems;
126     mapping(uint256 => address) public tokenOwner;
127     function totalSupply() external view returns (uint256 tokens);
128     function mintItem(uint256 itemId, address player) external;
129     function burn(uint256 tokenId) external;
130     function getItemRarity(uint256 itemId) external view returns (uint256);
131     
132     struct Item {
133         string name;
134         uint256 itemId;
135         uint256 unitId;
136         uint256 rarity;
137         uint256 upgradeGains;
138     }
139 }
140 
141 contract Material {
142     function burn(uint256 amount, address player) public;
143 }