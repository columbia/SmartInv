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
11 contract Crafting {
12 
13     Clans clans = Clans(0x0);
14     Inventory constant inventory = Inventory(0xb545507080b0f63df02ff9bd9302c2bb2447b826);
15     Material constant clothMaterial = Material(0x8a6014227138556a259e7b2bf1dce668f9bdfd06);
16     Material constant woodMaterial = Material(0x6804bbb708b8af0851e2980c8a5e9abb42adb179);
17     Material constant metalMaterial = Material(0xb334f68bf47c1f1c1556e7034954d389d7fbbf07);
18 
19     address owner;
20     mapping(uint256 => Recipe) public recipeList;
21     mapping(address => bool) operator;
22 
23     struct Recipe {
24         uint256 id;
25         uint256 itemId;
26 
27         uint256 clothRequired;
28         uint256 woodRequired;
29         uint256 metalRequired;
30     }
31 
32     constructor() public {
33         owner = msg.sender;
34     }
35 
36     function setClans(address clansContract) external {
37         require(msg.sender == owner); // TODO hardcode for launch?
38         clans = Clans(clansContract);
39     }
40 
41     function setOperator(address gameContract, bool isOperator) external {
42         require(msg.sender == owner);
43         operator[gameContract] = isOperator;
44     }
45 
46     function craftItem(uint256 recipeId) external {
47         Recipe memory recipe = recipeList[recipeId];
48         require(recipe.itemId > 0); // Valid recipe
49 
50         // Clan discount
51         uint224 upgradeDiscount = clans.getPlayersClanUpgrade(msg.sender, 2); // class 2 = crafting discount
52 
53         // Burn materials
54         if (recipe.clothRequired > 0) {
55             clothMaterial.burn(recipe.clothRequired - ((recipe.clothRequired * upgradeDiscount) / 100), msg.sender);
56         }
57         if (recipe.woodRequired > 0) {
58             woodMaterial.burn(recipe.woodRequired - ((recipe.woodRequired * upgradeDiscount) / 100), msg.sender);
59         }
60         if (recipe.metalRequired > 0) {
61             metalMaterial.burn(recipe.metalRequired - ((recipe.metalRequired * upgradeDiscount) / 100), msg.sender);
62         }
63 
64         // Mint item
65         inventory.mintItem(recipe.itemId, msg.sender);
66     }
67 
68     function addRecipe(uint256 id, uint256 itemId, uint256 clothRequired, uint256 woodRequired, uint256 metalRequired) external {
69         require(operator[msg.sender]);
70         recipeList[id] = Recipe(id, itemId, clothRequired, woodRequired, metalRequired);
71     }
72 
73 }
74 
75 
76 contract Clans {
77     function getPlayersClanUpgrade(address player, uint256 upgradeClass) external view returns (uint224 upgradeGain);
78 }
79 
80 contract Inventory {
81     function mintItem(uint256 itemId, address player) external;
82 }
83 
84 contract Material {
85     function burn(uint256 amount, address player) public;
86 }