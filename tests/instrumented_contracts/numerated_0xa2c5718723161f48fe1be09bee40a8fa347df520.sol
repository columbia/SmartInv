1 pragma solidity ^0.4.23;
2 
3 
4 contract DayTrader{
5   // Bag sold event
6   event BagSold(
7     uint256 bagId,
8     uint256 multiplier,
9     uint256 oldPrice,
10     uint256 newPrice,
11     address prevOwner,
12     address newOwner
13   );
14 
15   // Address of the contract creator
16   address public contractOwner;
17 
18   uint256 public timeout = 24 hours;
19   // Default timeout is 4 hours
20 
21   // Default starting price is 0.005 ether
22   uint256 public startingPrice = 0.005 ether;
23 
24   Bag[] private bags;
25 
26   struct Bag {
27     address owner;
28     uint256 level;
29     uint256 multiplier; // Multiplier must be rate * 100. example: 1.5x == 150
30     uint256 purchasedAt;
31   }
32 
33   /// Access modifier for contract owner only functionality
34   modifier onlyContractOwner() {
35     require(msg.sender == contractOwner);
36     _;
37   }
38 
39   function DayTrader() public {
40     contractOwner = msg.sender;
41     createBag(125);
42     createBag(150);
43 	createBag(200);
44   }
45 
46   function createBag(uint256 multiplier) public onlyContractOwner {
47     Bag memory bag = Bag({
48       owner: this,
49       level: 0,
50       multiplier: multiplier,
51       purchasedAt: 0
52     });
53 
54     bags.push(bag);
55   }
56 
57   function setTimeout(uint256 _timeout) public onlyContractOwner {
58     timeout = _timeout;
59   }
60   
61   function setStartingPrice(uint256 _startingPrice) public onlyContractOwner {
62     startingPrice = _startingPrice;
63   }
64 
65   function setBagMultiplier(uint256 bagId, uint256 multiplier) public onlyContractOwner {
66     Bag storage bag = bags[bagId];
67     bag.multiplier = multiplier;
68   }
69 
70   function getBag(uint256 bagId) public view returns (
71     address owner,
72     uint256 sellingPrice,
73     uint256 nextSellingPrice,
74     uint256 level,
75     uint256 multiplier,
76     uint256 purchasedAt
77   ) {
78     Bag storage bag = bags[bagId];
79 
80     owner = getOwner(bag);
81     level = getBagLevel(bag);
82     sellingPrice = getBagSellingPrice(bag);
83     nextSellingPrice = getNextBagSellingPrice(bag);
84     multiplier = bag.multiplier;
85     purchasedAt = bag.purchasedAt;
86   }
87 
88   function getBagCount() public view returns (uint256 bagCount) {
89     return bags.length;
90   }
91 
92   function deleteBag(uint256 bagId) public onlyContractOwner {
93     delete bags[bagId];
94   }
95 
96   function purchase(uint256 bagId) public payable {
97     Bag storage bag = bags[bagId];
98 
99     address oldOwner = bag.owner;
100     address newOwner = msg.sender;
101 
102     // Making sure token owner is not sending to self
103     require(oldOwner != newOwner);
104 
105     // Safety check to prevent against an unexpected 0x0 default.
106     require(_addressNotNull(newOwner));
107     
108     uint256 sellingPrice = getBagSellingPrice(bag);
109 
110     // Making sure sent amount is greater than or equal to the sellingPrice
111     require(msg.value >= sellingPrice);
112 
113     // Take a transaction fee
114     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 90), 100));
115     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
116 
117     uint256 level = getBagLevel(bag);
118     bag.level = SafeMath.add(level, 1);
119     bag.owner = newOwner;
120     bag.purchasedAt = now;
121 
122     
123     // Pay previous tokenOwner if owner is not contract
124     if (oldOwner != address(this)) {
125       oldOwner.transfer(payment);
126     }
127 
128     // Trigger BagSold event
129     BagSold(bagId, bag.multiplier, sellingPrice, getBagSellingPrice(bag), oldOwner, newOwner);
130 
131     newOwner.transfer(purchaseExcess);
132   }
133 
134   function payout() public onlyContractOwner {
135     contractOwner.transfer(this.balance);
136   }
137 
138   /*** PRIVATE FUNCTIONS ***/
139 
140   // If a bag hasn't been purchased in over $timeout,
141   // reset its level back to 0 but retain the existing owner
142   function getBagLevel(Bag bag) private view returns (uint256) {
143     if (now <= (SafeMath.add(bag.purchasedAt, timeout))) {
144       return bag.level;
145     } else {
146       return 0;
147     }
148   }
149   
150    function getOwner(Bag bag) private view returns (address) {
151     if (now <= (SafeMath.add(bag.purchasedAt, timeout))) {
152       return bag.owner;
153     } else {
154       return address(this);
155     }
156   }
157 
158   function getBagSellingPrice(Bag bag) private view returns (uint256) {
159     uint256 level = getBagLevel(bag);
160     return getPriceForLevel(bag, level);
161   }
162 
163   function getNextBagSellingPrice(Bag bag) private view returns (uint256) {
164     uint256 level = SafeMath.add(getBagLevel(bag), 1);
165     return getPriceForLevel(bag, level);
166   }
167 
168   function getPriceForLevel(Bag bag, uint256 level) private view returns (uint256) {
169     uint256 sellingPrice = startingPrice;
170 
171     for (uint256 i = 0; i < level; i++) {
172       sellingPrice = SafeMath.div(SafeMath.mul(sellingPrice, bag.multiplier), 100);
173     }
174 
175     return sellingPrice;
176   }
177 
178   /// Safety check on _to address to prevent against an unexpected 0x0 default.
179   function _addressNotNull(address _to) private pure returns (bool) {
180     return _to != address(0);
181   }
182 }
183 
184 library SafeMath {
185 
186   /**
187   * @dev Multiplies two numbers, throws on overflow.
188   */
189   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
190     if (a == 0) {
191       return 0;
192     }
193     uint256 c = a * b;
194     assert(c / a == b);
195     return c;
196   }
197 
198   /**
199   * @dev Integer division of two numbers, truncating the quotient.
200   */
201   function div(uint256 a, uint256 b) internal pure returns (uint256) {
202     // assert(b > 0); // Solidity automatically throws when dividing by 0
203     uint256 c = a / b;
204     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
205     return c;
206   }
207 
208   /**
209   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
210   */
211   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
212     assert(b <= a);
213     return a - b;
214   }
215 
216   /**
217   * @dev Adds two numbers, throws on overflow.
218   */
219   function add(uint256 a, uint256 b) internal pure returns (uint256) {
220     uint256 c = a + b;
221     assert(c >= a);
222     return c;
223   }
224 }