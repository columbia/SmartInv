1 pragma solidity ^0.4.18;
2 
3 contract EtherTower {
4   using SafeMath for uint256;
5 
6   // Contract owner address
7   address public owner;
8 
9   // Game constants
10   uint256 private constant TOWER_BOSS_TOKEN_ID = 0;
11   uint256 private constant APARTMENT_MANAGER_ID = 1;
12   uint256 private constant HOTEL_MANAGER_ID = 2;
13   uint256 private constant CONDO_MANAGER_ID = 3;
14 
15   uint256 private constant BOTTOM_FLOOR_ID = 4;
16   uint256 private constant APARTMENT_INDEX_MIN = 4;
17   uint256 private constant APARTMENT_INDEX_MAX = 9;
18   uint256 private constant HOTEL_INDEX_MIN = 10;
19   uint256 private constant HOTEL_INDEX_MAX = 15;
20   uint256 private constant CONDO_INDEX_MIN = 16;
21   uint256 private constant CONDO_INDEX_MAX = 21;
22 
23   uint256 private firstStepLimit = 0.04 ether;
24   uint256 private secondStepLimit = 0.2 ether;
25 
26   // Game start time
27   uint256 public gameStartTime = 1520647080;
28 
29   // Tokens
30   struct Token {
31     uint256 price;
32     address owner;
33   }
34 
35   mapping (uint256 => Token) public tokens;
36 
37   // Player earnings
38   mapping (address => uint256) public earnings;
39 
40   event TokenPurchased(
41     uint256 tokenId,
42     address oldOwner,
43     address newOwner,
44     uint256 oldPrice,
45     uint256 newPrice,
46     uint256 timestamp
47   );
48 
49   modifier onlyOwner {
50     require(msg.sender == owner);
51     _;
52   }
53 
54   modifier onlyGameStarted {
55     require(now >= gameStartTime);
56     _;
57   }
58 
59   function EtherTower() public {
60     owner = msg.sender;
61     createToken(0, 2 ether); // Tower Boss
62     createToken(1, 0.5 ether); // Apartment Manager
63     createToken(2, 0.5 ether); // Hotel Manager
64     createToken(3, 0.5 ether); // Condo Manager
65 
66     // Apartments
67     createToken(4, 0.05 ether);
68     createToken(5, 0.005 ether);
69     createToken(6, 0.005 ether);
70     createToken(7, 0.005 ether);
71     createToken(8, 0.005 ether);
72     createToken(9, 0.05 ether);
73 
74     // Hotel
75     createToken(10, 0.05 ether);
76     createToken(11, 0.005 ether);
77     createToken(12, 0.005 ether);
78     createToken(13, 0.005 ether);
79     createToken(14, 0.005 ether);
80     createToken(15, 0.05 ether);
81 
82     // Condos
83     createToken(16, 0.05 ether);
84     createToken(17, 0.005 ether);
85     createToken(18, 0.005 ether);
86     createToken(19, 0.005 ether);
87     createToken(20, 0.005 ether);
88     createToken(21, 0.1 ether); // Penthouse
89   }
90 
91   // PUBLIC
92 
93   function createToken(uint256 _tokenId, uint256 _startingPrice) public onlyOwner {
94     Token memory token = Token({
95       price: _startingPrice,
96       owner: owner
97     });
98 
99     tokens[_tokenId] = token;
100   }
101 
102   function getToken(uint256 _tokenId) public view returns (
103     uint256 _price,
104     uint256 _nextPrice,
105     address _owner
106   ) {
107     Token memory token = tokens[_tokenId];
108     _price = token.price;
109     _nextPrice = getNextPrice(token.price);
110     _owner = token.owner;
111   }
112 
113   function setGameStartTime(uint256 _gameStartTime) public onlyOwner {
114     gameStartTime = _gameStartTime;
115   }
116 
117   function purchase(uint256 _tokenId) public payable onlyGameStarted {
118     Token storage token = tokens[_tokenId];
119 
120     // Value must be greater than or equal to the token price
121     require(msg.value >= token.price);
122 
123     // Prevent user from buying their own token
124     require(msg.sender != token.owner);
125 
126     uint256 purchaseExcess = msg.value.sub(token.price);
127 
128     address newOwner = msg.sender;
129     address oldOwner = token.owner;
130 
131     uint256 devCut = token.price.mul(4).div(100); // 4%
132     uint256 towerBossCut = token.price.mul(3).div(100); // 3%
133     uint256 managerCut = getManagerCut(_tokenId, token.price); // 0% - 3%
134     uint256 oldOwnerProfit = token.price.sub(devCut).sub(towerBossCut).sub(managerCut);
135 
136     // Update token
137     uint256 oldPrice = token.price;
138     token.owner = newOwner;
139     token.price = getNextPrice(token.price);
140 
141     // send funds to the dev
142     earnings[owner] = earnings[owner].add(devCut);
143 
144     // send funds to the big boss
145     earnings[tokens[TOWER_BOSS_TOKEN_ID].owner] = earnings[tokens[TOWER_BOSS_TOKEN_ID].owner].add(towerBossCut);
146 
147     // send funds to the manager (if applicable)
148     if (managerCut > 0) {
149       address managerAddress = getManagerAddress(_tokenId);
150       earnings[managerAddress] = earnings[managerAddress].add(managerCut);
151     }
152 
153     // send profit to the previous owner
154     sendFunds(oldOwner, oldOwnerProfit);
155 
156     // refund any excess to the sender
157     if (purchaseExcess > 0) {
158       sendFunds(newOwner, purchaseExcess);
159     }
160 
161     TokenPurchased(_tokenId, oldOwner, newOwner, oldPrice, token.price, now);
162   }
163 
164   function withdrawEarnings() public {
165     uint256 amount = earnings[msg.sender];
166     earnings[msg.sender] = 0;
167     msg.sender.transfer(amount);
168   }
169 
170   /// PRIVATE
171 
172   /// @dev Managers only get a cut of floor sales
173   function getManagerCut(uint256 _tokenId, uint256 _price) private pure returns (uint256) {
174     if (_tokenId >= BOTTOM_FLOOR_ID) {
175       return _price.mul(3).div(100); // 3%
176     } else {
177       return 0;
178     }
179   }
180 
181   function getManagerAddress(uint256 _tokenId) private view returns (address) {
182     if (_tokenId >= APARTMENT_INDEX_MIN && _tokenId <= APARTMENT_INDEX_MAX) {
183       return tokens[APARTMENT_MANAGER_ID].owner;
184     } else if (_tokenId >= HOTEL_INDEX_MIN && _tokenId <= HOTEL_INDEX_MAX) {
185       return tokens[HOTEL_MANAGER_ID].owner;
186     } else if (_tokenId >= CONDO_INDEX_MIN && _tokenId <= CONDO_INDEX_MAX) {
187       return tokens[CONDO_MANAGER_ID].owner;
188     } else {
189       // This should never happen
190       return owner;
191     }
192   }
193 
194   function getNextPrice(uint256 _price) private view returns (uint256) {
195     if (_price <= firstStepLimit) {
196       return _price.mul(2); // increase by 100%
197     } else if (_price <= secondStepLimit) {
198       return _price.mul(125).div(100); // increase by 25%
199     } else {
200       return _price.mul(118).div(100); // increase by 18%
201     }
202   }
203 
204   /**
205     * @dev Attempt to send the funds immediately.
206     * If that fails for any reason, force the user
207     * to manually withdraw.
208     */
209   function sendFunds(address _recipient, uint256 _amount) private {
210     if (!_recipient.send(_amount)) {
211       earnings[_recipient] = earnings[_recipient].add(_amount);
212     }
213   }
214 }
215 
216 library SafeMath {
217 
218   /**
219   * @dev Multiplies two numbers, throws on overflow.
220   */
221   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
222     if (a == 0) {
223       return 0;
224     }
225     uint256 c = a * b;
226     assert(c / a == b);
227     return c;
228   }
229 
230   /**
231   * @dev Integer division of two numbers, truncating the quotient.
232   */
233   function div(uint256 a, uint256 b) internal pure returns (uint256) {
234     // assert(b > 0); // Solidity automatically throws when dividing by 0
235     uint256 c = a / b;
236     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
237     return c;
238   }
239 
240   /**
241   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
242   */
243   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
244     assert(b <= a);
245     return a - b;
246   }
247 
248   /**
249   * @dev Adds two numbers, throws on overflow.
250   */
251   function add(uint256 a, uint256 b) internal pure returns (uint256) {
252     uint256 c = a + b;
253     assert(c >= a);
254     return c;
255   }
256 }