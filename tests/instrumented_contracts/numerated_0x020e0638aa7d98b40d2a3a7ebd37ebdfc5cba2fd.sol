1 pragma solidity ^0.4.18;
2 
3 contract EtherBags {
4   // Bag sold event
5   event BagSold(
6     uint256 bagId,
7     uint256 multiplier,
8     uint256 oldPrice,
9     uint256 newPrice,
10     address prevOwner,
11     address newOwner
12   );
13 
14   // Address of the contract creator
15   address public contractOwner;
16 
17   // Default timeout is 4 hours
18   uint256 public timeout = 4 hours;
19 
20   // Default starting price is 0.005 ether
21   uint256 public startingPrice = 0.005 ether;
22 
23   Bag[] private bags;
24 
25   struct Bag {
26     address owner;
27     uint256 level;
28     uint256 multiplier; // Multiplier must be rate * 100. example: 1.5x == 150
29     uint256 purchasedAt;
30   }
31 
32   /// Access modifier for contract owner only functionality
33   modifier onlyContractOwner() {
34     require(msg.sender == contractOwner);
35     _;
36   }
37 
38   function EtherBags() public {
39     contractOwner = msg.sender;
40     createBag(200);
41     createBag(200);
42     createBag(200);
43     createBag(200);
44     createBag(150);
45     createBag(150);
46     createBag(150);
47     createBag(150);
48     createBag(125);
49     createBag(125);
50     createBag(125);
51     createBag(125);
52   }
53 
54   function createBag(uint256 multiplier) public onlyContractOwner {
55     Bag memory bag = Bag({
56       owner: this,
57       level: 0,
58       multiplier: multiplier,
59       purchasedAt: 0
60     });
61 
62     bags.push(bag);
63   }
64 
65   function setTimeout(uint256 _timeout) public onlyContractOwner {
66     timeout = _timeout;
67   }
68 
69   function setStartingPrice(uint256 _startingPrice) public onlyContractOwner {
70     startingPrice = _startingPrice;
71   }
72 
73   function setBagMultiplier(uint256 bagId, uint256 multiplier) public onlyContractOwner {
74     Bag storage bag = bags[bagId];
75     bag.multiplier = multiplier;
76   }
77 
78   function getBag(uint256 bagId) public view returns (
79     address owner,
80     uint256 sellingPrice,
81     uint256 nextSellingPrice,
82     uint256 level,
83     uint256 multiplier,
84     uint256 purchasedAt
85   ) {
86     Bag storage bag = bags[bagId];
87 
88     owner = bag.owner;
89     level = getBagLevel(bag);
90     sellingPrice = getBagSellingPrice(bag);
91     nextSellingPrice = getNextBagSellingPrice(bag);
92     multiplier = bag.multiplier;
93     purchasedAt = bag.purchasedAt;
94   }
95 
96   function getBagCount() public view returns (uint256 bagCount) {
97     return bags.length;
98   }
99 
100   function deleteBag(uint256 bagId) public onlyContractOwner {
101     delete bags[bagId];
102   }
103 
104   function purchase(uint256 bagId) public payable {
105     Bag storage bag = bags[bagId];
106 
107     address oldOwner = bag.owner;
108     address newOwner = msg.sender;
109 
110     // Making sure token owner is not sending to self
111     require(oldOwner != newOwner);
112 
113     // Safety check to prevent against an unexpected 0x0 default.
114     require(_addressNotNull(newOwner));
115     
116     uint256 sellingPrice = getBagSellingPrice(bag);
117 
118     // Making sure sent amount is greater than or equal to the sellingPrice
119     require(msg.value >= sellingPrice);
120 
121     // Take a transaction fee
122     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 92), 100));
123     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
124 
125     uint256 level = getBagLevel(bag);
126     bag.level = SafeMath.add(level, 1);
127     bag.owner = newOwner;
128     bag.purchasedAt = now;
129 
130     // Pay previous tokenOwner if owner is not contract
131     if (oldOwner != address(this)) {
132       oldOwner.transfer(payment);
133     }
134 
135     // Trigger BagSold event
136     BagSold(bagId, bag.multiplier, sellingPrice, getBagSellingPrice(bag), oldOwner, newOwner);
137 
138     newOwner.transfer(purchaseExcess);
139   }
140 
141   function payout() public onlyContractOwner {
142     contractOwner.transfer(this.balance);
143   }
144 
145   /*** PRIVATE FUNCTIONS ***/
146 
147   // If a bag hasn't been purchased in over $timeout,
148   // reset its level back to 0 but retain the existing owner
149   function getBagLevel(Bag bag) private view returns (uint256) {
150     if (now <= (SafeMath.add(bag.purchasedAt, timeout))) {
151       return bag.level;
152     } else {
153       return 0;
154     }
155   }
156 
157   function getBagSellingPrice(Bag bag) private view returns (uint256) {
158     uint256 level = getBagLevel(bag);
159     return getPriceForLevel(bag, level);
160   }
161 
162   function getNextBagSellingPrice(Bag bag) private view returns (uint256) {
163     uint256 level = SafeMath.add(getBagLevel(bag), 1);
164     return getPriceForLevel(bag, level);
165   }
166 
167   function getPriceForLevel(Bag bag, uint256 level) private view returns (uint256) {
168     uint256 sellingPrice = startingPrice;
169 
170     for (uint256 i = 0; i < level; i++) {
171       sellingPrice = SafeMath.div(SafeMath.mul(sellingPrice, bag.multiplier), 100);
172     }
173 
174     return sellingPrice;
175   }
176 
177   /// Safety check on _to address to prevent against an unexpected 0x0 default.
178   function _addressNotNull(address _to) private pure returns (bool) {
179     return _to != address(0);
180   }
181 }
182 
183 library SafeMath {
184 
185   /**
186   * @dev Multiplies two numbers, throws on overflow.
187   */
188   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
189     if (a == 0) {
190       return 0;
191     }
192     uint256 c = a * b;
193     assert(c / a == b);
194     return c;
195   }
196 
197   /**
198   * @dev Integer division of two numbers, truncating the quotient.
199   */
200   function div(uint256 a, uint256 b) internal pure returns (uint256) {
201     // assert(b > 0); // Solidity automatically throws when dividing by 0
202     uint256 c = a / b;
203     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
204     return c;
205   }
206 
207   /**
208   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
209   */
210   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
211     assert(b <= a);
212     return a - b;
213   }
214 
215   /**
216   * @dev Adds two numbers, throws on overflow.
217   */
218   function add(uint256 a, uint256 b) internal pure returns (uint256) {
219     uint256 c = a + b;
220     assert(c >= a);
221     return c;
222   }
223 }