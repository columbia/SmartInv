1 pragma solidity ^0.4.18;
2 
3 
4 contract DayTrader {
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
18   // Default timeout is 4 hours
19   uint256 public timeout = 24 hours;
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
41     createBag(150);
42 	createBag(150);
43 	createBag(150);
44 	createBag(200);
45 	createBag(200);
46 	createBag(200);
47   }
48 
49   function createBag(uint256 multiplier) public onlyContractOwner {
50     Bag memory bag = Bag({
51       owner: this,
52       level: 0,
53       multiplier: multiplier,
54       purchasedAt: 0
55     });
56 
57     bags.push(bag);
58   }
59 
60   function setTimeout(uint256 _timeout) public onlyContractOwner {
61     timeout = _timeout;
62   }
63   
64   function setStartingPrice(uint256 _startingPrice) public onlyContractOwner {
65     startingPrice = _startingPrice;
66   }
67 
68   function setBagMultiplier(uint256 bagId, uint256 multiplier) public onlyContractOwner {
69     Bag storage bag = bags[bagId];
70     bag.multiplier = multiplier;
71   }
72 
73   function getBag(uint256 bagId) public view returns (
74     address owner,
75     uint256 sellingPrice,
76     uint256 nextSellingPrice,
77     uint256 level,
78     uint256 multiplier,
79     uint256 purchasedAt
80   ) {
81     Bag storage bag = bags[bagId];
82 
83     owner = getOwner(bag);
84     level = getBagLevel(bag);
85     sellingPrice = getBagSellingPrice(bag);
86     nextSellingPrice = getNextBagSellingPrice(bag);
87     multiplier = bag.multiplier;
88     purchasedAt = bag.purchasedAt;
89   }
90 
91   function getBagCount() public view returns (uint256 bagCount) {
92     return bags.length;
93   }
94 
95   function deleteBag(uint256 bagId) public onlyContractOwner {
96     delete bags[bagId];
97   }
98 
99   function purchase(uint256 bagId) public payable {
100     Bag storage bag = bags[bagId];
101 
102     address oldOwner = bag.owner;
103     address newOwner = msg.sender;
104 
105     // Making sure token owner is not sending to self
106     require(oldOwner != newOwner);
107 
108     // Safety check to prevent against an unexpected 0x0 default.
109     require(_addressNotNull(newOwner));
110     
111     uint256 sellingPrice = getBagSellingPrice(bag);
112 
113     // Making sure sent amount is greater than or equal to the sellingPrice
114     require(msg.value >= sellingPrice);
115 
116     // Take a transaction fee
117     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 90), 100));
118     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
119 
120     uint256 level = getBagLevel(bag);
121     bag.level = SafeMath.add(level, 1);
122     bag.owner = newOwner;
123     bag.purchasedAt = now;
124 
125     
126     // Pay previous tokenOwner if owner is not contract
127     if (oldOwner != address(this)) {
128       oldOwner.transfer(payment);
129       
130     }
131 
132     // Trigger BagSold event
133     BagSold(bagId, bag.multiplier, sellingPrice, getBagSellingPrice(bag), oldOwner, newOwner);
134 
135     newOwner.transfer(purchaseExcess);
136   }
137 
138   function payout() public onlyContractOwner {
139     contractOwner.transfer(this.balance);
140   }
141 
142   /*** PRIVATE FUNCTIONS ***/
143 
144   // If a bag hasn't been purchased in over $timeout,
145   // reset its level back to 0 but retain the existing owner
146   function getBagLevel(Bag bag) private view returns (uint256) {
147     if (now <= (SafeMath.add(bag.purchasedAt, timeout))) {
148       return bag.level;
149     } else {
150       return 0;
151     }
152   }
153   
154    function getOwner(Bag bag) private view returns (address) {
155     if (now <= (SafeMath.add(bag.purchasedAt, timeout))) {
156       return bag.owner;
157     } else {
158       return address(this);
159     }
160   }
161 
162   function getBagSellingPrice(Bag bag) private view returns (uint256) {
163     uint256 level = getBagLevel(bag);
164     return getPriceForLevel(bag, level);
165   }
166 
167   function getNextBagSellingPrice(Bag bag) private view returns (uint256) {
168     uint256 level = SafeMath.add(getBagLevel(bag), 1);
169     return getPriceForLevel(bag, level);
170   }
171 
172   function getPriceForLevel(Bag bag, uint256 level) private view returns (uint256) {
173     uint256 sellingPrice = startingPrice;
174 
175     for (uint256 i = 0; i < level; i++) {
176       sellingPrice = SafeMath.div(SafeMath.mul(sellingPrice, bag.multiplier), 100);
177     }
178 
179     return sellingPrice;
180   }
181 
182   /// Safety check on _to address to prevent against an unexpected 0x0 default.
183   function _addressNotNull(address _to) private pure returns (bool) {
184     return _to != address(0);
185   }
186 }
187 
188 library SafeMath {
189 
190   /**
191   * @dev Multiplies two numbers, throws on overflow.
192   */
193   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
194     if (a == 0) {
195       return 0;
196     }
197     uint256 c = a * b;
198     assert(c / a == b);
199     return c;
200   }
201 
202   /**
203   * @dev Integer division of two numbers, truncating the quotient.
204   */
205   function div(uint256 a, uint256 b) internal pure returns (uint256) {
206     // assert(b > 0); // Solidity automatically throws when dividing by 0
207     uint256 c = a / b;
208     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
209     return c;
210   }
211 
212   /**
213   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
214   */
215   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
216     assert(b <= a);
217     return a - b;
218   }
219 
220   /**
221   * @dev Adds two numbers, throws on overflow.
222   */
223   function add(uint256 a, uint256 b) internal pure returns (uint256) {
224     uint256 c = a + b;
225     assert(c >= a);
226     return c;
227   }
228 }