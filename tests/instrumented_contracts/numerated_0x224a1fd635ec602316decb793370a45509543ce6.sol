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
24   struct Pixel {
25     // User with permission to modify the pixel. A successful sale of the
26     // pixel will result in payouts being credited to the pendingWithdrawal of
27     // the User
28     address owner;
29 
30     // Current listed price of the pixel
31     uint price;
32 
33     // Current color of the pixel. A valid of 0 is considered transparent and
34     // not black. Use 1 for black.
35     uint24 color;
36   }
37 
38   // The state of the pixel grid
39   mapping(uint32 => Pixel) pixels;
40 
41   // The state of all users who have transacted with this contract
42   mapping(address => uint) pendingWithdrawals;
43 
44   // An optional message that is shown in some parts of the UI and in the
45   // details pane of every owned pixel
46   mapping(address => string) messages;
47 
48   //============================================================================
49   // Events
50   //============================================================================
51 
52   event PixelTransfer(uint16 row, uint16 col, uint price, address prevOwner, address newOwner);
53   event PixelColor(uint16 row, uint16 col, address owner, uint24 color);
54   event PixelPrice(uint16 row, uint16 col, address owner, uint price);
55 
56   //============================================================================
57   // Basic API and helper functions
58   //============================================================================
59 
60   function Grid(
61     uint16 _size,
62     uint _defaultPrice,
63     uint _feeRatio,
64     uint _incrementRate) {
65     admin = msg.sender;
66     defaultPrice = _defaultPrice;
67     feeRatio = _feeRatio;
68     size = _size;
69     incrementRate = _incrementRate;
70   }
71 
72   modifier onlyAdmin {
73     require(msg.sender == admin);
74     _;
75   }
76 
77   modifier onlyOwner(uint16 row, uint16 col) {
78     require(msg.sender == getPixelOwner(row, col));
79     _;
80   }
81 
82   function getKey(uint16 row, uint16 col) constant returns (uint32) {
83     require(row < size && col < size);
84     return uint32(SafeMath.add(SafeMath.mul(row, size), col));
85   }
86 
87   function() payable {}
88 
89   //============================================================================
90   // Admin API
91   //============================================================================
92 
93   function setAdmin(address _admin) onlyAdmin {
94     admin = _admin;
95   }
96 
97   function setFeeRatio(uint _feeRatio) onlyAdmin {
98     feeRatio = _feeRatio;
99   }
100 
101   function setDefaultPrice(uint _defaultPrice) onlyAdmin {
102     defaultPrice = _defaultPrice;
103   }
104 
105   //============================================================================
106   // Public Querying API
107   //============================================================================
108 
109   function getPixelColor(uint16 row, uint16 col) constant returns (uint24) {
110     uint32 key = getKey(row, col);
111     return pixels[key].color;
112   }
113 
114   function getPixelOwner(uint16 row, uint16 col) constant returns (address) {
115     uint32 key = getKey(row, col);
116     if (pixels[key].owner == 0) {
117       return admin;
118     }
119     return pixels[key].owner;
120   }
121 
122   function getPixelPrice(uint16 row, uint16 col) constant returns (uint) {
123     uint32 key = getKey(row, col);
124     if (pixels[key].owner == 0) {
125       return defaultPrice;
126     }
127     return pixels[key].price;
128   }
129 
130   function getUserMessage(address user) constant returns (string) {
131     return messages[user];
132   }
133 
134   //============================================================================
135   // Public Transaction API
136   //============================================================================
137 
138   function checkPendingWithdrawal() constant returns (uint) {
139     return pendingWithdrawals[msg.sender];
140   }
141 
142   function withdraw() {
143     if (pendingWithdrawals[msg.sender] > 0) {
144       uint amount = pendingWithdrawals[msg.sender];
145       pendingWithdrawals[msg.sender] = 0;
146       msg.sender.transfer(amount);
147     }
148   }
149 
150   function buyPixel(uint16 row, uint16 col, uint24 newColor) payable {
151     uint balance = pendingWithdrawals[msg.sender];
152     // Return instead of letting getKey throw here to correctly refund the
153     // transaction by updating the user balance in user.pendingWithdrawal
154     if (row >= size || col >= size) {
155       pendingWithdrawals[msg.sender] = SafeMath.add(balance, msg.value);
156       return;
157     }
158 
159     uint32 key = getKey(row, col);
160     uint price = getPixelPrice(row, col);
161     address owner = getPixelOwner(row, col);
162 
163     // Return instead of throw here to correctly refund the transaction by
164     // updating the user balance in user.pendingWithdrawal
165     if (msg.value < price) {
166       pendingWithdrawals[msg.sender] = SafeMath.add(balance, msg.value);
167       return;
168     }
169 
170     uint fee = SafeMath.div(msg.value, feeRatio);
171     uint payout = SafeMath.sub(msg.value, fee);
172 
173     uint adminBalance = pendingWithdrawals[admin];
174     pendingWithdrawals[admin] = SafeMath.add(adminBalance, fee);
175 
176     uint ownerBalance = pendingWithdrawals[owner];
177     pendingWithdrawals[owner] = SafeMath.add(ownerBalance, payout);
178 
179     // Increase the price automatically based on the global incrementRate
180     uint increase = SafeMath.div(SafeMath.mul(price, incrementRate), 100);
181     pixels[key].price = SafeMath.add(price, increase);
182     pixels[key].owner = msg.sender;
183 
184     PixelTransfer(row, col, price, owner, msg.sender);
185     setPixelColor(row, col, newColor);
186   }
187 
188   //============================================================================
189   // Owner Management API
190   //============================================================================
191 
192   function setPixelColor(uint16 row, uint16 col, uint24 color) onlyOwner(row, col) {
193     uint32 key = getKey(row, col);
194     if (pixels[key].color != color) {
195       pixels[key].color = color;
196       PixelColor(row, col, pixels[key].owner, color);
197     }
198   }
199 
200   function setPixelPrice(uint16 row, uint16 col, uint newPrice) onlyOwner(row, col) {
201     uint32 key = getKey(row, col);
202     // The owner can only lower the price. Price increases are determined by
203     // the global incrementRate
204     require(pixels[key].price > newPrice);
205 
206     pixels[key].price = newPrice;
207     PixelPrice(row, col, pixels[key].owner, newPrice);
208   }
209 
210   //============================================================================
211   // User Management API
212   //============================================================================
213 
214   function setUserMessage(string message) {
215     messages[msg.sender] = message;
216   }
217 }
218 
219 library SafeMath {
220   function mul(uint256 a, uint256 b) internal returns (uint256) {
221     uint256 c = a * b;
222     assert(a == 0 || c / a == b);
223     return c;
224   }
225 
226   function div(uint256 a, uint256 b) internal returns (uint256) {
227     // assert(b > 0); // Solidity automatically throws when dividing by 0
228     uint256 c = a / b;
229     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
230     return c;
231   }
232 
233   function sub(uint256 a, uint256 b) internal returns (uint256) {
234     assert(b <= a);
235     return a - b;
236   }
237 
238   function add(uint256 a, uint256 b) internal returns (uint256) {
239     uint256 c = a + b;
240     assert(c >= a);
241     return c;
242   }
243 }