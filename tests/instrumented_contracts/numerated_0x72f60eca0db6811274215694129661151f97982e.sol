1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity\contracts\math\SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
56 
57 /**
58  * @title ERC20Basic
59  * @dev Simpler version of ERC20 interface
60  * See https://github.com/ethereum/EIPs/issues/179
61  */
62 contract ERC20Basic {
63   function totalSupply() public view returns (uint256);
64   function balanceOf(address who) public view returns (uint256);
65   function transfer(address to, uint256 value) public returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 // File: openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
70 
71 /**
72  * @title ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/20
74  */
75 contract ERC20 is ERC20Basic {
76   function allowance(address owner, address spender)
77     public view returns (uint256);
78 
79   function transferFrom(address from, address to, uint256 value)
80     public returns (bool);
81 
82   function approve(address spender, uint256 value) public returns (bool);
83   event Approval(
84     address indexed owner,
85     address indexed spender,
86     uint256 value
87   );
88 }
89 
90 // File: openzeppelin-solidity\contracts\token\ERC20\SafeERC20.sol
91 
92 /**
93  * @title SafeERC20
94  * @dev Wrappers around ERC20 operations that throw on failure.
95  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
96  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
97  */
98 library SafeERC20 {
99   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
100     require(token.transfer(to, value));
101   }
102 
103   function safeTransferFrom(
104     ERC20 token,
105     address from,
106     address to,
107     uint256 value
108   )
109     internal
110   {
111     require(token.transferFrom(from, to, value));
112   }
113 
114   function safeApprove(ERC20 token, address spender, uint256 value) internal {
115     require(token.approve(spender, value));
116   }
117 }
118 
119 // File: contracts\DecentralizedExchanges2.sol
120 
121 contract SpecialERC20 {
122     function transfer(address to, uint256 value) public;
123 }
124 
125 contract DecentralizedExchanges {
126 
127     using SafeMath for uint;
128     using SafeERC20 for ERC20;
129 
130     string public name = "DecentralizedExchanges";
131 
132     event Order(bytes32 hash);
133     event Trade(bytes32 hash, address seller, address token, uint amount, address purchaser, uint eth);
134     event Cancel(bytes32 hash, uint amount, bool isSell);
135 
136     struct OrderInfo {
137         bool isSell;
138         bool isSpecialERC20;
139         uint eth;
140         uint amount;
141         uint expires;
142         uint nonce;
143         uint createdAt;
144         uint fill;
145         address token;
146         address[] limitUser;
147         address owner;
148     }
149 
150     mapping (bytes32 => OrderInfo) public orderInfos;
151     mapping (address => bytes32[]) public userOrders;
152 
153     function getOrderInfo(bytes32 hash) public view returns (bool, uint, address, uint, uint, uint, address[], uint, address, uint, bool) {
154         OrderInfo storage info = orderInfos[hash];
155         return (info.isSell, info.eth, info.token, info.amount, info.expires, info.nonce, info.limitUser, info.createdAt, info.owner, info.fill, info.isSpecialERC20);
156     }
157 
158     // 创建买单,用eth买token
159     function createPurchaseOrder(bool isSpecialERC20, uint eth, address token, uint amount, uint expires, address[] seller, uint nonce) payable public {
160         require(msg.value >= eth);
161         bytes32 hash = sha256(abi.encodePacked(this, eth, token, amount, expires, seller, nonce, msg.sender, now));
162         orderInfos[hash] = OrderInfo(false, isSpecialERC20, eth, amount, expires, nonce, now, 0, token, seller, msg.sender);
163         for (uint i = 0; i < userOrders[msg.sender].length; i++) {
164             require(userOrders[msg.sender][i] != hash);
165         }
166         userOrders[msg.sender].push(hash);
167         emit Order(hash);
168     }
169 
170     // 创建卖单,卖token得eth
171     function createSellOrder(bool isSpecialERC20, address token, uint amount, uint eth, uint expires, address[] purchaser, uint nonce) public {
172         ERC20(token).safeTransferFrom(msg.sender, this, amount);
173         bytes32 hash = sha256(abi.encodePacked(this, eth, token, amount, expires, purchaser, nonce, msg.sender, now));
174         orderInfos[hash] = OrderInfo(true, isSpecialERC20, eth, amount, expires, nonce, now, 0, token, purchaser, msg.sender);
175         for (uint i = 0; i < userOrders[msg.sender].length; i++) {
176             require(userOrders[msg.sender][i] != hash);
177         }
178         userOrders[msg.sender].push(hash);
179         emit Order(hash);
180     }
181 
182     function cancelOrder(bytes32 hash) public {
183         OrderInfo storage info = orderInfos[hash];
184         require(info.owner == msg.sender);
185         if (info.isSell) {
186             if (info.fill < info.amount) {
187                 uint amount = info.amount;
188                 uint remain = amount - info.fill;
189                 info.fill = info.amount;
190                 if (info.isSpecialERC20) {
191                     SpecialERC20(info.token).transfer(msg.sender, remain);
192                 } else {
193                     ERC20(info.token).transfer(msg.sender, remain);
194                 }
195                 emit Cancel(hash, remain, info.isSell);
196             } else {
197                 emit Cancel(hash, 0, info.isSell);
198             }
199         } else {
200             if (info.fill < info.eth) {
201                 uint eth = info.eth;
202                 remain = eth - info.fill;
203                 info.fill = info.eth;
204                 msg.sender.transfer(eth);
205                 emit Cancel(hash, remain, info.isSell);
206             } else {
207                 emit Cancel(hash, 0, info.isSell);
208             }
209         }
210     }
211 
212     // 卖token,针对创建的买单
213     function sell(bytes32 hash, uint amount) public {
214         OrderInfo storage info = orderInfos[hash];
215         bool find = false;
216         if (info.limitUser.length > 0) {
217             for (uint i = 0; i < info.limitUser.length; i++) {
218                 if (info.limitUser[i] == msg.sender) {
219                     find = true;
220                     break;
221                 }
222             }
223             require(find);
224         }
225 
226         // 确保订单还有剩余eth
227         require(info.fill < info.eth);
228         require(info.expires >= now);
229 
230         uint remain = info.eth - info.fill;
231 
232         uint remainAmount = remain.mul(info.amount).div(info.eth);
233         
234         uint tradeAmount = remainAmount < amount ? remainAmount : amount;
235         // token从卖家转到合约
236         ERC20(info.token).safeTransferFrom(msg.sender, this, tradeAmount);
237 
238         uint total = info.eth.mul(tradeAmount).div(info.amount);
239 
240         msg.sender.transfer(total);
241         
242         // token从合约转到买家
243         ERC20(info.token).transfer(info.owner, tradeAmount);
244         info.fill = info.fill.add(total);
245 
246         emit Trade(hash, msg.sender, info.token, tradeAmount, info.owner, total);
247     }
248 
249     // 买token,针对创建的卖单
250     function purchase(bytes32 hash, uint amount) payable public {
251         OrderInfo storage info = orderInfos[hash];
252         bool find = false;
253         if (info.limitUser.length > 0) {
254             for (uint i = 0; i < info.limitUser.length; i++) {
255                 if (info.limitUser[i] == msg.sender) {
256                     find = true;
257                     break;
258                 }
259             }
260             require(find);
261         }
262 
263         // 确保订单还有剩余token
264         require(info.fill < info.amount);
265         require(info.expires >= now);
266 
267         uint remainAmount = info.amount - info.fill;
268 
269         uint tradeAmount = remainAmount < amount ? remainAmount : amount;
270 
271         uint total = info.eth.mul(tradeAmount).div(info.amount);
272 
273         require(msg.value >= total);
274         if (msg.value > total) { // 多余的eth转回去
275             msg.sender.transfer(msg.value - total);
276         }
277 
278         info.owner.transfer(total);
279         if (info.isSpecialERC20) {
280             SpecialERC20(info.token).transfer(msg.sender, tradeAmount);
281         } else {
282             ERC20(info.token).transfer(msg.sender, tradeAmount);
283         }
284         info.fill = info.fill.add(tradeAmount);
285 
286         emit Trade(hash, info.owner, info.token, tradeAmount, msg.sender, total);
287     }
288   
289 }