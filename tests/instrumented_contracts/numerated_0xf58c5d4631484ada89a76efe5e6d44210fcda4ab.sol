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
11 contract Salvaging {
12     
13     Inventory constant inventory = Inventory(0xb545507080b0f63df02ff9bd9302c2bb2447b826);
14     Crafting constant crafting = Crafting(0x29789c9abebc185f1876af10c38ee47ee0c6ed48);
15     ClothMaterial constant clothMaterial = ClothMaterial(0x8a6014227138556a259e7b2bf1dce668f9bdfd06);
16     WoodMaterial constant woodMaterial = WoodMaterial(0x6804bbb708b8af0851e2980c8a5e9abb42adb179);
17     MetalMaterial constant metalMaterial = MetalMaterial(0xb334f68bf47c1f1c1556e7034954d389d7fbbf07);
18     
19     address owner;
20     mapping(uint256 => Recipe) public recipeList;
21     
22     struct Recipe {
23         uint256 itemRarity; // Serves as id [0,1,2,3]
24         uint256 clothRecieved;
25         uint256 woodRecieved;
26         uint256 metalRecieved;
27     }
28     
29     constructor() public {
30         owner = msg.sender;
31     }
32     
33     function salvageItem(uint256 tokenId) external {
34         require(inventory.tokenOwner(tokenId) == msg.sender);
35 
36         uint256 itemId = inventory.tokenItems(tokenId);
37         uint256 rarity = inventory.getItemRarity(itemId);
38         Recipe memory recipe = recipeList[rarity];
39         
40         uint256 clothRecieved = recipe.clothRecieved;
41         uint256 woodRecieved = recipe.woodRecieved;
42         uint256 metalRecieved = recipe.metalRecieved;
43         
44         // Common items return 50% crafting
45         if (rarity == 0) {
46             (uint256 id,,uint256 clothCost, uint256 woodCost, uint256 metalCost) = crafting.recipeList(itemId);
47             require(id > 0);
48             clothRecieved = clothCost / 2;
49             woodRecieved = woodCost / 2;
50             metalRecieved = metalCost / 2;
51         }
52         
53         // Grant materials
54         if (clothRecieved > 0) {
55             clothMaterial.mintCloth(clothRecieved, msg.sender);
56         }
57         
58         if (woodRecieved > 0) {
59             woodMaterial.mintWood(woodRecieved, msg.sender);
60         }
61         
62         if (metalRecieved > 0) {
63             metalMaterial.mintMetal(metalRecieved, msg.sender);
64         }
65         
66         // Finally burn item
67         inventory.burn(tokenId);
68     }
69     
70     function addRecipe(uint256 itemRarity, uint256 cloth, uint256 wood, uint256 metal) external {
71         require(msg.sender == owner);
72         recipeList[itemRarity] = Recipe(itemRarity, cloth, wood, metal);
73     }
74     
75 }
76 
77 
78 contract Inventory {
79     mapping(uint256 => Item) public itemList;
80     mapping(uint256 => uint256) public tokenItems;
81     mapping(uint256 => address) public tokenOwner;
82     function getItemRarity(uint256 itemId) external view returns (uint256);
83     function burn(uint256 tokenId) external;
84     
85     struct Item {
86         uint256 itemId;
87         uint256 unitId;
88         uint256 rarity;
89         uint32[8] upgradeGains;
90     }
91 }
92 
93 contract ClothMaterial {
94     function mintCloth(uint256 amount, address player) external;
95 }
96 
97 contract WoodMaterial {
98     function mintWood(uint256 amount, address player) external;
99 }
100 
101 contract MetalMaterial {
102     function mintMetal(uint256 amount, address player) external;
103 }
104 
105 contract Crafting {
106     mapping(uint256 => Recipe) public recipeList;
107 
108     struct Recipe {
109         uint256 id;
110         uint256 itemId;
111 
112         uint256 clothRequired;
113         uint256 woodRequired;
114         uint256 metalRequired;
115     }
116     
117 }