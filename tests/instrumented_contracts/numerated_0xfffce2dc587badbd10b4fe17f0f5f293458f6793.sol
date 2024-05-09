1 pragma solidity ^0.4.18;
2 
3 contract Admin {
4   address public owner;
5   mapping(address => bool) public isAdmin;
6 
7   modifier onlyOwner() {
8     require(msg.sender == owner);
9     _;
10   }
11 
12   modifier onlyAdmin() {
13     require(isAdmin[msg.sender]);
14     _;
15   }
16 
17   function Admin() public {
18     owner = msg.sender;
19     addAdmin(owner);
20   }
21 
22   function addAdmin(address _admin) public onlyOwner {
23     isAdmin[_admin] = true;
24   }
25 
26   function removeAdmin(address _admin) public onlyOwner {
27     isAdmin[_admin] = false;
28   }
29 }
30 
31 // To add a tree do the following:
32 // - Create a new Tree with the ID, owner, treeValue and power to generate fruits
33 // - Update the treeBalances and treeOwner mappings
34 contract Trees is Admin {
35   event LogWaterTree(uint256 indexed treeId, address indexed owner, uint256 date);
36   event LogRewardPicked(uint256 indexed treeId, address indexed owner, uint256 date, uint256 amount);
37 
38   // Get the tree information given the id
39   mapping(uint256 => Tree) public treeDetails;
40   // A mapping with all the tree IDs of that owner
41   mapping(address => uint256[]) public ownerTreesIds;
42   // Tree id and the days the tree has been watered
43   // Tree id => day number => isWatered
44   mapping(uint256 => mapping(uint256 => bool)) public treeWater;
45 
46   struct Tree {
47     uint256 ID;
48     address owner;
49     uint256 purchaseDate;
50     uint256 treePower; // How much ether that tree is generating from 0 to 100 where 100 is the total power combined of all the trees
51     uint256 salePrice;
52     uint256 timesExchanged;
53     uint256[] waterTreeDates;
54     bool onSale;
55     uint256 lastRewardPickedDate; // When did you take the last reward
56   }
57 
58   uint256[] public trees;
59   uint256[] public treesOnSale;
60   uint256 public lastTreeId;
61   address public defaultTreesOwner = msg.sender;
62   uint256 public defaultTreesPower = 1; // 10% of the total power
63   uint256 public defaultSalePrice = 1 ether;
64   uint256 public totalTreePower;
65   uint256 public timeBetweenRewards = 1 days;
66 
67   // This will be called automatically by the server
68   // The contract itself will hold the initial trees
69   function generateTrees(uint256 _amountToGenerate) public onlyAdmin {
70     for(uint256 i = 0; i < _amountToGenerate; i++) {
71         uint256 newTreeId = lastTreeId + 1;
72         lastTreeId += 1;
73         uint256[] memory emptyArray;
74         Tree memory newTree = Tree(newTreeId, defaultTreesOwner, now, defaultTreesPower, defaultSalePrice, 0, emptyArray, true, 0);
75 
76         // Update the treeBalances and treeOwner mappings
77         // We add the tree to the same array position to find it easier
78         ownerTreesIds[defaultTreesOwner].push(newTreeId);
79         treeDetails[newTreeId] = newTree;
80         treesOnSale.push(newTreeId);
81         totalTreePower += defaultTreesPower;
82     }
83   }
84 
85   // This is payable, the user will send the payment here
86   // We delete the tree from the owner first and we add that to the receiver
87   // When you sell you're actually putting the tree on the market, not losing it yet
88   function putTreeOnSale(uint256 _treeNumber, uint256 _salePrice) public {
89     require(msg.sender == treeDetails[_treeNumber].owner);
90     require(!treeDetails[_treeNumber].onSale);
91     require(_salePrice > 0);
92 
93     treesOnSale.push(_treeNumber);
94     treeDetails[_treeNumber].salePrice = _salePrice;
95     treeDetails[_treeNumber].onSale = true;
96   }
97 
98   // To buy a tree paying ether
99   function buyTree(uint256 _treeNumber, address _originalOwner) public payable {
100     require(msg.sender != treeDetails[_treeNumber].owner);
101     require(treeDetails[_treeNumber].onSale);
102     require(msg.value >= treeDetails[_treeNumber].salePrice);
103     address newOwner = msg.sender;
104     // Move id from old to new owner
105     // Find the tree of that user and delete it
106     for(uint256 i = 0; i < ownerTreesIds[_originalOwner].length; i++) {
107         if(ownerTreesIds[_originalOwner][i] == _treeNumber) delete ownerTreesIds[_originalOwner][i];
108     }
109     // Remove the tree from the array of trees on sale
110     for(uint256 a = 0; a < treesOnSale.length; a++) {
111         if(treesOnSale[a] == _treeNumber) {
112             delete treesOnSale[a];
113             break;
114         }
115     }
116     ownerTreesIds[newOwner].push(_treeNumber);
117     treeDetails[_treeNumber].onSale = false;
118     if(treeDetails[_treeNumber].timesExchanged == 0) {
119         // Reward the owner for the initial trees as a way of monetization. Keep half for the treasury
120         owner.transfer(msg.value / 2);
121     } else {
122         treeDetails[_treeNumber].owner.transfer(msg.value * 90 / 100); // Keep 0.1% in the treasury
123     }
124     treeDetails[_treeNumber].owner = newOwner;
125     treeDetails[_treeNumber].timesExchanged += 1;
126   }
127 
128   // To take a tree out of the market without selling it
129   function cancelTreeSell(uint256 _treeId) public {
130     require(msg.sender == treeDetails[_treeId].owner);
131     require(treeDetails[_treeId].onSale);
132     // Remove the tree from the array of trees on sale
133     for(uint256 a = 0; a < treesOnSale.length; a++) {
134         if(treesOnSale[a] == _treeId) {
135             delete treesOnSale[a];
136             break;
137         }
138     }
139     treeDetails[_treeId].onSale = false;
140   }
141 
142   // Improves the treePower
143   function waterTree(uint256 _treeId) public {
144     require(_treeId > 0);
145     require(msg.sender == treeDetails[_treeId].owner);
146     uint256[] memory waterDates = treeDetails[_treeId].waterTreeDates;
147     uint256 timeSinceLastWater;
148     // We want to store at what day the tree was watered
149     uint256 day;
150     if(waterDates.length > 0) {
151         timeSinceLastWater = now - waterDates[waterDates.length - 1];
152         day = waterDates[waterDates.length - 1] / 1 days;
153     }else {
154         timeSinceLastWater = timeBetweenRewards;
155         day = 1;
156     }
157     require(timeSinceLastWater >= timeBetweenRewards);
158     treeWater[_treeId][day] = true;
159     treeDetails[_treeId].waterTreeDates.push(now);
160     treeDetails[_treeId].treePower += 1;
161     totalTreePower += 1;
162     LogWaterTree(_treeId, msg.sender, now);
163   }
164 
165   // To get the ether from the rewards
166   function pickReward(uint256 _treeId) public {
167     require(msg.sender == treeDetails[_treeId].owner);
168     require(now - treeDetails[_treeId].lastRewardPickedDate > timeBetweenRewards);
169 
170     uint256[] memory formatedId = new uint256[](1);
171     formatedId[0] = _treeId;
172     uint256[] memory rewards = checkRewards(formatedId);
173     treeDetails[_treeId].lastRewardPickedDate = now;
174     msg.sender.transfer(rewards[0]);
175     LogRewardPicked(_treeId, msg.sender, now, rewards[0]);
176   }
177 
178   // To see if a tree is already watered or not
179   function checkTreesWatered(uint256[] _treeIds) public constant returns(bool[]) {
180     bool[] memory results = new bool[](_treeIds.length);
181     uint256 timeSinceLastWater;
182     for(uint256 i = 0; i < _treeIds.length; i++) {
183         uint256[] memory waterDates = treeDetails[_treeIds[i]].waterTreeDates;
184         if(waterDates.length > 0) {
185             timeSinceLastWater = now - waterDates[waterDates.length - 1];
186             results[i] = timeSinceLastWater < timeBetweenRewards;
187         } else {
188             results[i] = false;
189         }
190     }
191     return results;
192   }
193 
194   // Returns an array of how much ether all those trees have generated today
195   // All the tree power combiined for instance 10293
196   // The tree power for this tree for instance 298
197   // What percentage do you get: 2%
198   // Total money in the treasury: 102 ETH
199   // A 10% of the total is distributed daily across all the users
200   // For instance 10.2 ETH today
201   // So if you pick your rewards right now, you'll get a 2% of 10.2 ETH which is 0.204 ETH
202   function checkRewards(uint256[] _treeIds) public constant returns(uint256[]) {
203     uint256 amountInTreasuryToDistribute = this.balance / 10;
204     uint256[] memory results = new uint256[](_treeIds.length);
205     for(uint256 i = 0; i < _treeIds.length; i++) {
206         // Important to multiply by 100 to
207         uint256 yourPercentage = treeDetails[_treeIds[i]].treePower * 1 ether / totalTreePower;
208         uint256 amountYouGet = yourPercentage * amountInTreasuryToDistribute / 1 ether;
209         results[i] = amountYouGet;
210     }
211     return results;
212   }
213 
214   // To get all the tree IDs of one user
215   function getTreeIds(address _account) public constant returns(uint256[]) {
216     if(_account != address(0)) return ownerTreesIds[_account];
217     else return ownerTreesIds[msg.sender];
218   }
219 
220   // To get all the trees on sale
221   function getTreesOnSale() public constant returns(uint256[]) {
222       return treesOnSale;
223   }
224 
225   // To extract the ether in an emergency
226   function emergencyExtract() public onlyOwner {
227     owner.transfer(this.balance);
228   }
229 }