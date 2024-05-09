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
20     mapping(uint256 => Recipe) public recipeList;
21     
22     struct Recipe {
23         uint256 rarityRequired; // Serves as id [0,1,2,3]
24         uint256 clothRequired;
25         uint256 woodRequired;
26         uint256 metalRequired;
27         
28         uint256 rarityItemIdStart; // First item id for produced rarity
29         uint256 rarityItemIdEnd; // Last item id for produced rarity
30     }
31  
32     
33     constructor() public {
34         owner = msg.sender;
35     }
36     
37     function addRecipe(uint256 recipeRarity, uint256 cloth, uint256 wood, uint256 metal, uint256 producedItemIdStart, uint256 producedItemIdEnd) external {
38         require(msg.sender == owner);
39         require(inventory.getItemRarity(producedItemIdStart) == recipeRarity + 1);
40         require(inventory.getItemRarity(producedItemIdEnd) == recipeRarity + 1);
41         recipeList[recipeRarity] = Recipe(recipeRarity, cloth, wood, metal, producedItemIdStart, producedItemIdEnd);
42     }
43     
44     function forgeRandomItem(uint256 tokenIdOne, uint256 tokenIdTwo, uint256 tokenIdThree) external {
45         require(inventory.tokenOwner(tokenIdOne) == msg.sender);
46         require(inventory.tokenOwner(tokenIdTwo) == msg.sender);
47         require(inventory.tokenOwner(tokenIdThree) == msg.sender);
48         
49         require(tokenIdOne != tokenIdTwo);
50         require(tokenIdOne != tokenIdThree);
51         
52         // Check item rarity matches
53         Recipe memory recipe = recipeList[inventory.getItemRarity(inventory.tokenItems(tokenIdOne))];
54         require(inventory.getItemRarity(inventory.tokenItems(tokenIdTwo)) == recipe.rarityRequired);
55         require(inventory.getItemRarity(inventory.tokenItems(tokenIdThree)) == recipe.rarityRequired);
56         
57         // Clan discount
58         uint224 upgradeDiscount = clans.getPlayersClanUpgrade(msg.sender, 2); // class 2 = crafting discount
59 
60         // Burn materials
61         if (recipe.clothRequired > 0) {
62             clothMaterial.burn(recipe.clothRequired - ((recipe.clothRequired * upgradeDiscount) / 100), msg.sender);
63         }
64         if (recipe.woodRequired > 0) {
65             woodMaterial.burn(recipe.woodRequired - ((recipe.woodRequired * upgradeDiscount) / 100), msg.sender);
66         }
67         if (recipe.metalRequired > 0) {
68             metalMaterial.burn(recipe.metalRequired - ((recipe.metalRequired * upgradeDiscount) / 100), msg.sender);
69         }
70         
71         // Burn items
72         inventory.burn(tokenIdOne);
73         inventory.burn(tokenIdTwo);
74         inventory.burn(tokenIdThree);
75         
76         // Mint item
77         uint256 rng = pseudoRandom(block.timestamp + block.difficulty, inventory.totalSupply());
78         uint256 numItemsLength = (recipe.rarityItemIdEnd - recipe.rarityItemIdStart) + 1;
79   
80         inventory.mintItem(recipe.rarityItemIdStart + (rng % numItemsLength), msg.sender);
81     }
82     
83     function pseudoRandom(uint256 seed, uint256 nonce) internal view returns (uint256) {
84         return uint256(keccak256(abi.encodePacked(seed,  block.coinbase, nonce)));
85     }
86     
87 }
88 
89 
90 
91 contract Clans {
92     function getPlayersClanUpgrade(address player, uint256 upgradeClass) external view returns (uint224 upgradeGain);
93 }
94 
95 contract Inventory {
96     mapping(uint256 => Item) public itemList;
97     mapping(uint256 => uint256) public tokenItems;
98     mapping(uint256 => address) public tokenOwner;
99     function totalSupply() external view returns (uint256 tokens);
100     function mintItem(uint256 itemId, address player) external;
101     function burn(uint256 tokenId) external;
102     function getItemRarity(uint256 itemId) external view returns (uint256);
103     
104     struct Item {
105         string name;
106         uint256 itemId;
107         uint256 unitId;
108         uint256 rarity;
109         uint256 upgradeGains;
110     }
111 }
112 
113 contract Material {
114     function burn(uint256 amount, address player) public;
115 }