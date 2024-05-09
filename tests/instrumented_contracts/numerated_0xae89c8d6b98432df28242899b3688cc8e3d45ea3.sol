1 pragma solidity ^0.4.11;
2 
3 contract Grid {
4   // The account address with admin privilege to this contract
5   // This is also the default owner of all unowned pixels
6   address admin;
7 
8   // The size in number of pixels of the square grid on each side
9   uint16 public size;
10 
11   // The default price of unowned pixels
12   uint public defaultPrice;
13 
14   // The price-fee ratio used in the following formula:
15   //   salePrice / feeRatio = fee
16   //   payout = salePrice - fee
17   // Higher feeRatio equates to lower fee percentage
18   uint public feeRatio;
19 
20   // The price increment rate used in the following formula:
21   //   price = prevPrice + (prevPrice * incrementRate / 100);
22   uint public incrementRate;
23 
24   // A record of a user who may at any time be an owner of pixels or simply has
25   // unclaimed withdrawal from a failed purchase or a successful sale
26   struct User {
27     // Number of Wei that can be withdrawn by the user
28     uint pendingWithdrawal;
29 
30     // Number of Wei in total ever credited to the user as a result of a
31     // successful sale
32     uint totalSales;
33   }
34 
35   struct Pixel {
36     // User with permission to modify the pixel. A successful sale of the
37     // pixel will result in payouts being credited to the pendingWithdrawal of
38     // the User
39     address owner;
40 
41     // Current listed price of the pixel
42     uint price;
43 
44     // Current color of the pixel. A valid of 0 is considered transparent and
45     // not black. Use 1 for black.
46     uint24 color;
47   }
48 
49   // The state of the pixel grid
50   mapping(uint32 => Pixel) pixels;
51 
52   // The state of all users who have transacted with this contract
53   mapping(address => User) users;
54 
55   // An optional message that is shown in some parts of the UI and in the
56   // details pane of every owned pixel
57   mapping(address => string) messages;
58 
59   //============================================================================
60   // Events
61   //============================================================================
62 
63   event PixelTransfer(uint16 row, uint16 col, uint price, address prevOwner, address newOwner);
64   event PixelColor(uint16 row, uint16 col, address owner, uint24 color);
65   event PixelPrice(uint16 row, uint16 col, address owner, uint price);
66   event UserMessage(address user, string message);
67 
68   //============================================================================
69   // Basic API and helper functions
70   //============================================================================
71 
72   function Grid(
73     uint16 _size,
74     uint _defaultPrice,
75     uint _feeRatio,
76     uint _incrementRate) {
77     admin = msg.sender;
78     defaultPrice = _defaultPrice;
79     feeRatio = _feeRatio;
80     size = _size;
81     incrementRate = _incrementRate;
82   }
83 
84   modifier onlyAdmin {
85     require(msg.sender == admin);
86     _;
87   }
88 
89   modifier onlyOwner(uint16 row, uint16 col) {
90     require(msg.sender == getPixelOwner(row, col));
91     _;
92   }
93 
94   function getKey(uint16 row, uint16 col) constant returns (uint32) {
95     require(row < size && col < size);
96     return uint32(SafeMath.add(SafeMath.mul(row, size), col));
97   }
98 
99   function() payable {}
100 
101   //============================================================================
102   // Admin API
103   //============================================================================
104 
105   function setAdmin(address _admin) onlyAdmin {
106     admin = _admin;
107   }
108 
109   function setFeeRatio(uint _feeRatio) onlyAdmin {
110     feeRatio = _feeRatio;
111   }
112 
113   function setDefaultPrice(uint _defaultPrice) onlyAdmin {
114     defaultPrice = _defaultPrice;
115   }
116 
117   //============================================================================
118   // Public Querying API
119   //============================================================================
120 
121   function getPixelColor(uint16 row, uint16 col) constant returns (uint24) {
122     uint32 key = getKey(row, col);
123     return pixels[key].color;
124   }
125 
126   function getPixelOwner(uint16 row, uint16 col) constant returns (address) {
127     uint32 key = getKey(row, col);
128     if (pixels[key].owner == 0) {
129       return admin;
130     }
131     return pixels[key].owner;
132   }
133 
134   function getPixelPrice(uint16 row, uint16 col) constant returns (uint) {
135     uint32 key = getKey(row, col);
136     if (pixels[key].owner == 0) {
137       return defaultPrice;
138     }
139     return pixels[key].price;
140   }
141 
142   function getUserMessage(address user) constant returns (string) {
143     return messages[user];
144   }
145 
146   function getUserTotalSales(address user) constant returns (uint) {
147     return users[user].totalSales;
148   }
149 
150   //============================================================================
151   // Public Transaction API
152   //============================================================================
153 
154   function checkPendingWithdrawal() constant returns (uint) {
155     return users[msg.sender].pendingWithdrawal;
156   }
157 
158   function withdraw() {
159     if (users[msg.sender].pendingWithdrawal > 0) {
160       uint amount = users[msg.sender].pendingWithdrawal;
161       users[msg.sender].pendingWithdrawal = 0;
162       msg.sender.transfer(amount);
163     }
164   }
165 
166   function buyPixel(uint16 row, uint16 col, uint24 newColor) payable {
167     uint balance = users[msg.sender].pendingWithdrawal;
168     // Return instead of letting getKey throw here to correctly refund the
169     // transaction by updating the user balance in user.pendingWithdrawal
170     if (row >= size || col >= size) {
171       users[msg.sender].pendingWithdrawal = SafeMath.add(balance, msg.value);
172       return;
173     }
174 
175     uint32 key = getKey(row, col);
176     uint price = getPixelPrice(row, col);
177     address owner = getPixelOwner(row, col);
178 
179     // Return instead of throw here to correctly refund the transaction by
180     // updating the user balance in user.pendingWithdrawal
181     if (msg.value < price) {
182       users[msg.sender].pendingWithdrawal = SafeMath.add(balance, msg.value);
183       return;
184     }
185 
186     uint fee = SafeMath.div(msg.value, feeRatio);
187     uint payout = SafeMath.sub(msg.value, fee);
188 
189     uint adminBalance = users[admin].pendingWithdrawal;
190     users[admin].pendingWithdrawal = SafeMath.add(adminBalance, fee);
191 
192     uint ownerBalance = users[owner].pendingWithdrawal;
193     users[owner].pendingWithdrawal = SafeMath.add(ownerBalance, payout);
194     users[owner].totalSales = SafeMath.add(users[owner].totalSales, payout);
195 
196     // Increase the price automatically based on the global incrementRate
197     uint increase = SafeMath.div(SafeMath.mul(price, incrementRate), 100);
198     pixels[key].price = SafeMath.add(price, increase);
199     pixels[key].owner = msg.sender;
200 
201     PixelTransfer(row, col, price, owner, msg.sender);
202     setPixelColor(row, col, newColor);
203   }
204 
205   //============================================================================
206   // Owner Management API
207   //============================================================================
208 
209   function transferPixel(uint16 row, uint16 col, address newOwner) onlyOwner(row, col) {
210     uint32 key = getKey(row, col);
211     address owner = pixels[key].owner;
212     if (owner != newOwner) {
213       pixels[key].owner = newOwner;
214       PixelTransfer(row, col, 0, owner, newOwner);
215     }
216   }
217 
218   function setPixelColor(uint16 row, uint16 col, uint24 color) onlyOwner(row, col) {
219     uint32 key = getKey(row, col);
220     if (pixels[key].color != color) {
221       pixels[key].color = color;
222       PixelColor(row, col, pixels[key].owner, color);
223     }
224   }
225 
226   function setPixelPrice(uint16 row, uint16 col, uint newPrice) onlyOwner(row, col) {
227     uint32 key = getKey(row, col);
228     // The owner can only lower the price. Price increases are determined by
229     // the global incrementRate
230     require(pixels[key].price > newPrice);
231 
232     pixels[key].price = newPrice;
233     PixelPrice(row, col, pixels[key].owner, newPrice);
234   }
235 
236   //============================================================================
237   // User Management API
238   //============================================================================
239 
240   function setUserMessage(string message) {
241     messages[msg.sender] = message;
242     UserMessage(msg.sender, message);
243   }
244 }
245 
246 library SafeMath {
247   function mul(uint256 a, uint256 b) internal returns (uint256) {
248     uint256 c = a * b;
249     assert(a == 0 || c / a == b);
250     return c;
251   }
252 
253   function div(uint256 a, uint256 b) internal returns (uint256) {
254     // assert(b > 0); // Solidity automatically throws when dividing by 0
255     uint256 c = a / b;
256     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
257     return c;
258   }
259 
260   function sub(uint256 a, uint256 b) internal returns (uint256) {
261     assert(b <= a);
262     return a - b;
263   }
264 
265   function add(uint256 a, uint256 b) internal returns (uint256) {
266     uint256 c = a + b;
267     assert(c >= a);
268     return c;
269   }
270 }