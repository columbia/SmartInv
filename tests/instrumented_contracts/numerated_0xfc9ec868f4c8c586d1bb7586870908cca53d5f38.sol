1 pragma solidity ^0.4.8;
2 
3 /**
4  * @title KittyItemToken interface 
5  */
6 contract KittyItemToken {
7   function transfer(address, uint256) public pure returns (bool) {}
8   function transferAndApply(address, uint256) public pure returns (bool) {}
9   function balanceOf(address) public pure returns (uint256) {}
10 }
11 
12 /**
13  * @title KittyItemMarket is a market contract for buying KittyItemTokens and 
14  */
15 contract KittyItemMarket {
16 
17   struct Item {
18     address itemContract;
19     uint256 cost;  // in wei
20     address artist;
21     uint128 split;  // the percentage split the artist gets vs. KittyItemMarket.owner. A split of "6666" would mean the artist gets 66.66% of the funds
22     uint256 totalFunds;
23   }
24 
25   address public owner;
26   mapping (string => Item) items;
27   bool public paused = false;
28 
29   // events
30   event Buy(string itemName);
31 
32   /**
33    * KittyItemMarket constructor
34    */
35   function KittyItemMarket() public {
36     owner = msg.sender;
37   }
38 
39   /**
40    * @dev Allows the current owner to transfer control of the contract to a newOwner.
41    * @param newOwner The address to transfer ownership to.
42    */
43   function transferOwnership(address newOwner) public {
44     require(msg.sender == owner);
45     if (newOwner != address(0)) {
46       owner = newOwner;
47     }
48   }
49 
50   /**
51    * @dev Pauses the market, not allowing any buyItem and buyItemAndApply
52    * @param _paused the paused state of the contract
53    */
54   function setPaused(bool _paused) public {
55     require(msg.sender == owner);
56     paused = _paused;
57   }
58 
59   /**
60    * @dev You cannot return structs, return each attribute in Item struct
61    * @param _itemName the KittyItemToken name in items
62    */
63   function getItem(string _itemName) view public returns (address, uint256, address, uint256, uint256) {
64     return (items[_itemName].itemContract, items[_itemName].cost, items[_itemName].artist, items[_itemName].split, items[_itemName].totalFunds);
65   }
66 
67   /**
68    * @dev Add a KittyItemToken contract to be sold in the market
69    * @param _itemName Name for items mapping
70    * @param _itemContract contract address of KittyItemToken we're adding
71    * @param _cost  cost of item in wei
72    * @param _artist  artist addess to send funds to
73    * @param _split  artist split. "6666" would be a 66.66% split.
74    */
75   function addItem(string _itemName, address _itemContract, uint256 _cost, address _artist, uint128 _split) public {
76     require(msg.sender == owner);
77     require(items[_itemName].itemContract == 0x0);  // item can't already exist
78     items[_itemName] = Item(_itemContract, _cost, _artist, _split, 0);
79   }
80 
81   /**
82    * @dev Modify an item that is in the market
83    * @param _itemName Name of item to modify
84    * @param _itemContract modify KittyItemtoken contract address for item
85    * @param _cost modify cost of item
86    * @param _artist  modify artist addess to send funds to
87    * @param _split  modify artist split
88    */
89   function modifyItem(string _itemName, address _itemContract, uint256 _cost, address _artist, uint128 _split) public {
90     require(msg.sender == owner);
91     require(items[_itemName].itemContract != 0x0);  // item should already exist
92     Item storage item = items[_itemName];
93     item.itemContract = _itemContract;
94     item.cost = _cost;
95     item.artist = _artist;
96     item.split = _split;
97   }
98 
99   /**
100    * @dev Buy item from the market
101    * @param _itemName Name of item to buy
102    * @param _amount amount of item to buy
103    */
104   function buyItem(string _itemName, uint256 _amount) public payable {
105     require(paused == false);
106     require(items[_itemName].itemContract != 0x0);  // item should already exist
107     Item storage item = items[_itemName];  // we're going to modify the item in storage
108     require(msg.value >= item.cost * _amount);  // make sure user sent enough eth for the number of items they want
109     item.totalFunds += msg.value;
110     KittyItemToken kit = KittyItemToken(item.itemContract);
111     kit.transfer(msg.sender, _amount);
112     // emit events
113     Buy(_itemName);
114   }
115 
116   /**
117    * @dev Buy item from the market and apply to kittyId
118    * @param _itemName Name of item to buy
119    * @param _kittyId  KittyId to apply the item
120    */
121   function buyItemAndApply(string _itemName, uint256 _kittyId) public payable {
122     require(paused == false);
123     // NOTE - can only be used to buy and apply 1 item
124     require(items[_itemName].itemContract != 0x0);  // item should already exist
125     Item storage item = items[_itemName];  // we're going to modify the item in storage
126     require(msg.value >= item.cost);  // make sure user sent enough eth for 1 item
127     item.totalFunds += msg.value;
128     KittyItemToken kit = KittyItemToken(item.itemContract);
129     kit.transferAndApply(msg.sender, _kittyId);
130     // emit events
131     Buy(_itemName);
132   }
133 
134   /**
135    * @dev split funds from Item sales between contract owner and artist
136    * @param _itemName Item to split funds for
137    */
138   function splitFunds(string _itemName) public {
139     require(msg.sender == owner);
140     Item storage item = items[_itemName];  // we're going to modify the item in storage
141     uint256 amountToArtist = item.totalFunds * item.split / 10000;
142     uint256 amountToOwner = item.totalFunds - amountToArtist;
143     item.artist.transfer(amountToArtist);
144     owner.transfer(amountToOwner);
145     item.totalFunds = 0;
146   }
147 
148   /**
149    * @dev return all _itemName tokens help by contract to contract owner
150    * @param _itemName Item to return tokens to contract owner
151    * @return whether the transfer was successful or not
152    */
153   function returnTokensToOwner(string _itemName) public returns (bool) {
154     require(msg.sender == owner);
155     Item storage item = items[_itemName];  // we're going to modify the item in storage
156     KittyItemToken kit = KittyItemToken(item.itemContract);
157     uint256 contractBalance = kit.balanceOf(this);
158     kit.transfer(msg.sender, contractBalance);
159     return true;
160   }
161 
162 }