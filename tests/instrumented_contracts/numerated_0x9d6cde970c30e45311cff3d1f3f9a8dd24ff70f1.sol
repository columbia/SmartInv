1 pragma solidity ^0.4.11;
2 
3 contract Grid {
4   // The account address with admin privilege to this contract
5   // This is also the default owner of all unowned pixels
6   address admin;
7 
8   // The default price of unowned pixels
9   uint public defaultPrice;
10 
11   // The price-fee ratio used in the following formula:
12   //   salePrice / feeRatio = fee
13   //   payout = salePrice - fee
14   // Higher feeRatio equates to lower fee percentage
15   uint public feeRatio;
16 
17   // The price increment rate used in the following formula:
18   //   price = prevPrice + (prevPrice * incrementRate / 100);
19   uint public incrementRate;
20 
21   struct Pixel {
22     // User with permission to modify the pixel. A successful sale of the
23     // pixel will result in payouts being credited to the pendingWithdrawal of
24     // the User
25     address owner;
26 
27     // Current listed price of the pixel
28     uint price;
29 
30     // Current color of the pixel. A valid of 0 is considered transparent and
31     // not black. Use 1 for black.
32     uint24 color;
33   }
34 
35   // The state of the pixel grid
36   /*mapping(uint32 => Pixel) pixels;*/
37   Pixel[1000][1000] pixels;
38 
39   // The state of all users who have transacted with this contract
40   mapping(address => uint) pendingWithdrawals;
41 
42   // An optional message that is shown in some parts of the UI and in the
43   // details pane of every owned pixel
44   mapping(address => string) messages;
45 
46   //============================================================================
47   // Events
48   //============================================================================
49 
50   event PixelTransfer(uint16 row, uint16 col, uint price, address prevOwner, address newOwner);
51   event PixelColor(uint16 row, uint16 col, address owner, uint24 color);
52   event PixelPrice(uint16 row, uint16 col, address owner, uint price);
53 
54   //============================================================================
55   // Basic API and helper functions
56   //============================================================================
57 
58   function Grid(
59     uint _defaultPrice,
60     uint _feeRatio,
61     uint _incrementRate) {
62     admin = msg.sender;
63     defaultPrice = _defaultPrice;
64     feeRatio = _feeRatio;
65     incrementRate = _incrementRate;
66   }
67 
68   modifier onlyAdmin {
69     require(msg.sender == admin);
70     _;
71   }
72 
73   modifier onlyOwner(uint16 row, uint16 col) {
74     require(msg.sender == getPixelOwner(row, col));
75     _;
76   }
77 
78   modifier validPixel(uint16 row, uint16 col) {
79     require(row < 1000 && col < 1000);
80     _;
81   }
82 
83   function() payable {}
84 
85   //============================================================================
86   // Admin API
87   //============================================================================
88 
89   function setAdmin(address _admin) onlyAdmin {
90     admin = _admin;
91   }
92 
93   function setFeeRatio(uint _feeRatio) onlyAdmin {
94     feeRatio = _feeRatio;
95   }
96 
97   function setDefaultPrice(uint _defaultPrice) onlyAdmin {
98     defaultPrice = _defaultPrice;
99   }
100 
101   //============================================================================
102   // Public Querying API
103   //============================================================================
104 
105   function getPixelColor(uint16 row, uint16 col) constant
106     validPixel(row, col) returns (uint24) {
107     return pixels[row][col].color;
108   }
109 
110   function getPixelOwner(uint16 row, uint16 col) constant
111     validPixel(row, col) returns (address) {
112     if (pixels[row][col].owner == 0) {
113       return admin;
114     }
115     return pixels[row][col].owner;
116   }
117 
118   function getPixelPrice(uint16 row, uint16 col) constant
119     validPixel(row,col) returns (uint) {
120     if (pixels[row][col].owner == 0) {
121       return defaultPrice;
122     }
123     return pixels[row][col].price;
124   }
125 
126   function getUserMessage(address user) constant returns (string) {
127     return messages[user];
128   }
129 
130   //============================================================================
131   // Public Transaction API
132   //============================================================================
133 
134   function checkPendingWithdrawal() constant returns (uint) {
135     return pendingWithdrawals[msg.sender];
136   }
137 
138   function withdraw() {
139     if (pendingWithdrawals[msg.sender] > 0) {
140       uint amount = pendingWithdrawals[msg.sender];
141       pendingWithdrawals[msg.sender] = 0;
142       msg.sender.transfer(amount);
143     }
144   }
145 
146   function buyPixel(uint16 row, uint16 col, uint24 newColor) payable {
147     uint balance = pendingWithdrawals[msg.sender];
148     // Return instead of letting getKey throw here to correctly refund the
149     // transaction by updating the user balance in user.pendingWithdrawal
150     if (row >= 1000 || col >= 1000) {
151       pendingWithdrawals[msg.sender] = SafeMath.add(balance, msg.value);
152       return;
153     }
154 
155     uint price = getPixelPrice(row, col);
156     address owner = getPixelOwner(row, col);
157 
158     // Return instead of throw here to correctly refund the transaction by
159     // updating the user balance in user.pendingWithdrawal
160     if (msg.value < price) {
161       pendingWithdrawals[msg.sender] = SafeMath.add(balance, msg.value);
162       return;
163     }
164 
165     uint fee = SafeMath.div(msg.value, feeRatio);
166     uint payout = SafeMath.sub(msg.value, fee);
167 
168     uint adminBalance = pendingWithdrawals[admin];
169     pendingWithdrawals[admin] = SafeMath.add(adminBalance, fee);
170 
171     uint ownerBalance = pendingWithdrawals[owner];
172     pendingWithdrawals[owner] = SafeMath.add(ownerBalance, payout);
173 
174     // Increase the price automatically based on the global incrementRate
175     uint increase = SafeMath.div(SafeMath.mul(price, incrementRate), 100);
176     pixels[row][col].price = SafeMath.add(price, increase);
177     pixels[row][col].owner = msg.sender;
178 
179     PixelTransfer(row, col, price, owner, msg.sender);
180     setPixelColor(row, col, newColor);
181   }
182 
183   //============================================================================
184   // Owner Management API
185   //============================================================================
186 
187   function setPixelColor(uint16 row, uint16 col, uint24 color)
188     validPixel(row, col) onlyOwner(row, col) {
189     if (pixels[row][col].color != color) {
190       pixels[row][col].color = color;
191       PixelColor(row, col, pixels[row][col].owner, color);
192     }
193   }
194 
195   function setPixelPrice(uint16 row, uint16 col, uint newPrice)
196     validPixel(row, col) onlyOwner(row, col) {
197     // The owner can only lower the price. Price increases are determined by
198     // the global incrementRate
199     require(pixels[row][col].price > newPrice);
200 
201     pixels[row][col].price = newPrice;
202     PixelPrice(row, col, pixels[row][col].owner, newPrice);
203   }
204 
205   //============================================================================
206   // User Management API
207   //============================================================================
208 
209   function setUserMessage(string message) {
210     messages[msg.sender] = message;
211   }
212 }
213 
214 library SafeMath {
215   function mul(uint256 a, uint256 b) internal returns (uint256) {
216     uint256 c = a * b;
217     assert(a == 0 || c / a == b);
218     return c;
219   }
220 
221   function div(uint256 a, uint256 b) internal returns (uint256) {
222     // assert(b > 0); // Solidity automatically throws when dividing by 0
223     uint256 c = a / b;
224     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
225     return c;
226   }
227 
228   function sub(uint256 a, uint256 b) internal returns (uint256) {
229     assert(b <= a);
230     return a - b;
231   }
232 
233   function add(uint256 a, uint256 b) internal returns (uint256) {
234     uint256 c = a + b;
235     assert(c >= a);
236     return c;
237   }
238 }