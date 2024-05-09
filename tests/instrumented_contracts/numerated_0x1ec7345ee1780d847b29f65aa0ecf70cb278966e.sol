1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11   /**
12    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13    * account.
14    */
15   function Ownable() public {
16     owner = msg.sender;
17   }
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27 }
28 
29 /**
30  * @title SafeMath
31  * @dev Math operations with safety checks that throw on error
32  */
33 library SafeMath {
34   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35     uint256 c = a * b;
36     assert(a == 0 || c / a == b);
37     return c;
38   }
39 
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return c;
45   }
46 
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51   
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     assert(c >= a);
55     return c;
56   }
57 }
58 
59 /**
60  * @title ERC721Token
61  * Generic implementation for the required functionality of the ERC721 standard
62  */
63 contract EtherTv is Ownable {
64   using SafeMath for uint256;
65 
66   Show[] private shows;
67   uint256 public devOwed;
68 
69   // dividends
70   mapping (address => uint256) public userDividends;
71 
72   // Events
73   event ShowPurchased(
74     uint256 _tokenId,
75     address oldOwner,
76     address newOwner,
77     uint256 price,
78     uint256 nextPrice
79   );
80 
81   // Purchasing Caps for Determining Next Pool Cut
82   uint256 constant private FIRST_CAP  = 0.5 ether;
83   uint256 constant private SECOND_CAP = 1.0 ether;
84   uint256 constant private THIRD_CAP  = 3.0 ether;
85   uint256 constant private FINAL_CAP  = 5.0 ether;
86 
87   // Struct to store Show Data
88   struct Show {
89     uint256 price;  // Current price of the item.
90     uint256 payout; // The percent of the pool rewarded.
91     address owner;  // Current owner of the item.
92   }
93 
94   function createShow(uint256 _payoutPercentage) onlyOwner() public {
95     // payout must be greater than 0
96     require(_payoutPercentage > 0);
97     
98     // create new token
99     var show = Show({
100       price: 0.005 ether,
101       payout: _payoutPercentage,
102       owner: this
103     });
104 
105     shows.push(show);
106   }
107 
108   function createMultipleShows(uint256[] _payoutPercentages) onlyOwner() public {
109     for (uint256 i = 0; i < _payoutPercentages.length; i++) {
110       createShow(_payoutPercentages[i]);
111     }
112   }
113 
114   function getShow(uint256 _showId) public view returns (
115     uint256 price,
116     uint256 nextPrice,
117     uint256 payout,
118     uint256 effectivePayout,
119     address owner
120   ) {
121     var show = shows[_showId];
122     price = show.price;
123     nextPrice = getNextPrice(show.price);
124     payout = show.payout;
125     effectivePayout = show.payout.mul(10000).div(getTotalPayout());
126     owner = show.owner;
127   }
128 
129   /**
130   * @dev Determines next price of token
131   * @param _price uint256 ID of current price
132   */
133   function getNextPrice (uint256 _price) private pure returns (uint256 _nextPrice) {
134     if (_price < FIRST_CAP) {
135       return _price.mul(200).div(100);
136     } else if (_price < SECOND_CAP) {
137       return _price.mul(135).div(100);
138     } else if (_price < THIRD_CAP) {
139       return _price.mul(125).div(100);
140     } else if (_price < FINAL_CAP) {
141       return _price.mul(117).div(100);
142     } else {
143       return _price.mul(115).div(100);
144     }
145   }
146 
147   function calculatePoolCut (uint256 _price) private pure returns (uint256 _poolCut) {
148     if (_price < FIRST_CAP) {
149       return _price.mul(7).div(100); // 7%
150     } else if (_price < SECOND_CAP) {
151       return _price.mul(6).div(100); // 6%
152     } else if (_price < THIRD_CAP) {
153       return _price.mul(5).div(100); // 5%
154     } else if (_price < FINAL_CAP) {
155       return _price.mul(4).div(100); // 4%
156     } else {
157       return _price.mul(3).div(100); // 3%
158     }
159   }
160 
161   /**
162   * @dev Purchase show from previous owner
163   * @param _tokenId uint256 of token
164   */
165   function purchaseShow(uint256 _tokenId) public payable {
166     var show = shows[_tokenId];
167     uint256 price = show.price;
168     address oldOwner = show.owner;
169     address newOwner = msg.sender;
170 
171     // revert checks
172     require(price > 0);
173     require(msg.value >= price);
174     require(oldOwner != msg.sender);
175 
176     uint256 purchaseExcess = msg.value.sub(price);
177 
178     // Calculate pool cut for taxes.
179     
180     // 4% goes to developers
181     uint256 devCut = price.mul(4).div(100);
182     devOwed = devOwed.add(devCut);
183 
184     // 3 - 7% goes to shareholders
185     uint256 shareholderCut = calculatePoolCut(price);
186     distributeDividends(shareholderCut);
187 
188     // Transfer payment to old owner minus the developer's and pool's cut.
189     uint256 excess = price.sub(devCut).sub(shareholderCut);
190 
191     if (oldOwner != address(this)) {
192       oldOwner.transfer(excess);
193     }
194 
195     // set new price
196     uint256 nextPrice = getNextPrice(price);
197     show.price = nextPrice;
198 
199     // set new owner
200     show.owner = newOwner;
201 
202     // Send refund to owner if needed
203     if (purchaseExcess > 0) {
204       newOwner.transfer(purchaseExcess);
205     }
206 
207     // raise event
208     ShowPurchased(_tokenId, oldOwner, newOwner, price, nextPrice);
209   }
210 
211   function distributeDividends(uint256 _shareholderCut) private {
212     uint256 totalPayout = getTotalPayout();
213 
214     for (uint256 i = 0; i < shows.length; i++) {
215       var show = shows[i];
216       var payout = _shareholderCut.mul(show.payout).div(totalPayout);
217       userDividends[show.owner] = userDividends[show.owner].add(payout);
218     }
219   }
220 
221   function getTotalPayout() private view returns(uint256) {
222     uint256 totalPayout = 0;
223 
224     for (uint256 i = 0; i < shows.length; i++) {
225       var show = shows[i];
226       totalPayout = totalPayout.add(show.payout);
227     }
228 
229     return totalPayout;
230   }
231 
232   /**
233   * @dev Withdraw dev's cut
234   */
235   function withdraw() onlyOwner public {
236     owner.transfer(devOwed);
237     devOwed = 0;
238   }
239 
240   /**
241   * @dev Owner can withdraw their accumulated dividends
242   */
243   function withdrawDividends() public {
244     uint256 dividends = userDividends[msg.sender];
245     userDividends[msg.sender] = 0;
246     msg.sender.transfer(dividends);
247   }
248 
249 }