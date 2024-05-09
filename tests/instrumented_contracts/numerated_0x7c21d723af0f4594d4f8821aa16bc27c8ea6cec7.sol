1 pragma solidity 0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21   function allowance(address owner, address spender) public view returns (uint256);
22   function transferFrom(address from, address to, uint256 value) public returns (bool);
23   function approve(address spender, uint256 value) public returns (bool);
24   event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 
28 /**
29  * @title SafeERC20
30  * @dev Wrappers around ERC20 operations that throw on failure.
31  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
32  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
33  */
34 library SafeERC20 {
35   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
36     assert(token.transfer(to, value));
37   }
38 
39   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
40     assert(token.transferFrom(from, to, value));
41   }
42 
43   function safeApprove(ERC20 token, address spender, uint256 value) internal {
44     assert(token.approve(spender, value));
45   }
46 }
47 
48 
49 /**
50  * @title SafeMath
51  * @dev Math operations with safety checks that throw on error
52  */
53 library SafeMath {
54 
55   /**
56   * @dev Multiplies two numbers, throws on overflow.
57   */
58   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59     if (a == 0) {
60       return 0;
61     }
62     uint256 c = a * b;
63     assert(c / a == b);
64     return c;
65   }
66 
67   /**
68   * @dev Integer division of two numbers, truncating the quotient.
69   */
70   function div(uint256 a, uint256 b) internal pure returns (uint256) {
71     // assert(b > 0); // Solidity automatically throws when dividing by 0
72     uint256 c = a / b;
73     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74     return c;
75   }
76 
77   /**
78   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
79   */
80   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81     assert(b <= a);
82     return a - b;
83   }
84 
85   /**
86   * @dev Adds two numbers, throws on overflow.
87   */
88   function add(uint256 a, uint256 b) internal pure returns (uint256) {
89     uint256 c = a + b;
90     assert(c >= a);
91     return c;
92   }
93 }
94 
95 
96 /**
97  * @title Helps contracts guard agains reentrancy attacks.
98  * @author Remco Bloemen <remco@2π.com>
99  * @notice If you mark a function `nonReentrant`, you should also
100  * mark it `external`.
101  */
102 contract ReentrancyGuard {
103 
104   /**
105    * @dev We use a single lock for the whole contract.
106    */
107   bool private reentrancy_lock = false;
108 
109   /**
110    * @dev Prevents a contract from calling itself, directly or indirectly.
111    * @notice If you mark a function `nonReentrant`, you should also
112    * mark it `external`. Calling one nonReentrant function from
113    * another is not supported. Instead, you can implement a
114    * `private` function doing the actual work, and a `external`
115    * wrapper marked as `nonReentrant`.
116    */
117   modifier nonReentrant() {
118     require(!reentrancy_lock);
119     reentrancy_lock = true;
120     _;
121     reentrancy_lock = false;
122   }
123 
124 }
125 
126 library Utils {
127   function isEther(address addr) internal pure returns (bool) {
128     return addr == address(0x0);
129   }
130 }
131 
132 
133 contract DUBIex is ReentrancyGuard {
134   using SafeMath for uint256;
135   using SafeERC20 for ERC20;
136   
137   // order
138   struct Order {
139     uint256 id;
140     address maker;
141     uint256 amount;
142     address pairA;
143     address pairB;
144     uint256 priceA;
145     uint256 priceB;
146   }
147 
148   // order id -> order
149   mapping(uint256 => Order) public orders;
150 
151   // weiSend of current tx
152   uint256 private weiSend = 0;
153 
154   // makes sure weiSend of current tx is reset
155   modifier weiSendGuard() {
156     weiSend = msg.value;
157     _;
158     weiSend = 0;
159   }
160 
161   // logs
162   event LogMakeOrder(uint256 id, address indexed maker, uint256 amount, address indexed pairA, address indexed pairB, uint256 priceA, uint256 priceB);
163   event LogTakeOrder(uint256 indexed id, address indexed taker, uint256 amount);
164   event LogCancelOrder(uint256 indexed id);
165 
166   // internal
167   function _makeOrder(uint256 id, uint256 amount, address pairA, address pairB, uint256 priceA, uint256 priceB, address maker) internal returns (bool) {
168     // validate input
169     if (
170       id <= 0 ||
171       amount <= 0 ||
172       pairA == pairB ||
173       priceA <= 0 ||
174       priceB <= 0 ||
175       orders[id].id == id
176     ) return false;
177 
178     bool pairAisEther = Utils.isEther(pairA);
179     ERC20 tokenA = ERC20(pairA);
180 
181     // validate maker's deposit
182     if (pairAisEther && (weiSend <= 0 || weiSend < amount)) return false;
183     else if (!pairAisEther && (tokenA.allowance(maker, this) < amount || tokenA.balanceOf(maker) < amount)) return false;
184 
185     // update state
186     orders[id] = Order(id, maker, amount, pairA, pairB, priceA, priceB);
187 
188     // retrieve makers amount
189     if (pairAisEther) {
190       // eth already received, subtract used wei
191       weiSend = weiSend.sub(amount);
192     } else {
193       // pull tokens
194       tokenA.safeTransferFrom(maker, this, amount);
195     }
196 
197     LogMakeOrder(id, maker, amount, pairA, pairB, priceA, priceB);
198 
199     return true;
200   }
201 
202   function _takeOrder(uint256 id, uint256 amount, address taker) internal returns (bool) {
203     // validate inputs
204     if (
205       id <= 0 ||
206       amount <= 0
207     ) return false;
208     
209     // get order
210     Order storage order = orders[id];
211     // validate order
212     if (order.id != id) return false;
213     
214     bool pairAisEther = Utils.isEther(order.pairA);
215     bool pairBisEther = Utils.isEther(order.pairB);
216     // amount of pairA usable
217     uint256 usableAmount = amount > order.amount ? order.amount : amount;
218     // amount of pairB maker will receive
219     uint256 totalB = usableAmount.mul(order.priceB).div(order.priceA);
220 
221     // token interfaces
222     ERC20 tokenA = ERC20(order.pairA);
223     ERC20 tokenB = ERC20(order.pairB);
224 
225     // validate taker's deposit
226     if (pairBisEther && (weiSend <= 0 || weiSend < totalB)) return false;
227     else if (!pairBisEther && (tokenB.allowance(taker, this) < totalB || tokenB.balanceOf(taker) < amount)) return false;
228 
229     // update state
230     order.amount = order.amount.sub(usableAmount);
231 
232     // pay maker
233     if (pairBisEther) {
234       weiSend = weiSend.sub(totalB);
235       order.maker.transfer(totalB);
236     } else {
237       tokenB.safeTransferFrom(taker, order.maker, totalB);
238     }
239 
240     // pay taker
241     if (pairAisEther) {
242       taker.transfer(usableAmount);
243     } else {
244       tokenA.safeTransfer(taker, usableAmount);
245     }
246 
247     LogTakeOrder(id, taker, usableAmount);
248 
249     return true;
250   }
251 
252   function _cancelOrder(uint256 id, address maker) internal returns (bool) {
253     // validate inputs
254     if (id <= 0) return false;
255 
256     // get order
257     Order storage order = orders[id];
258     if (
259       order.id != id ||
260       order.maker != maker
261     ) return false;
262 
263     uint256 amount = order.amount;
264     bool pairAisEther = Utils.isEther(order.pairA);
265 
266     // update state
267     order.amount = 0;
268 
269     // actions
270     if (pairAisEther) {
271       order.maker.transfer(amount);
272     } else {
273       ERC20(order.pairA).safeTransfer(order.maker, amount);
274     }
275 
276     LogCancelOrder(id);
277 
278     return true;
279   }
280 
281   // single
282   function makeOrder(uint256 id, uint256 amount, address pairA, address pairB, uint256 priceA, uint256 priceB) external payable weiSendGuard nonReentrant returns (bool) {
283     bool success = _makeOrder(id, amount, pairA, pairB, priceA, priceB, msg.sender);
284 
285     if (weiSend > 0) msg.sender.transfer(weiSend);
286 
287     return success;
288   }
289 
290   function takeOrder(uint256 id, uint256 amount) external payable weiSendGuard nonReentrant returns (bool) {
291     bool success = _takeOrder(id, amount, msg.sender);
292 
293     if (weiSend > 0) msg.sender.transfer(weiSend);
294 
295     return success;
296   }
297 
298   function cancelOrder(uint256 id) external nonReentrant returns (bool) {
299     return _cancelOrder(id, msg.sender);
300   }
301 
302   // multi
303   function makeOrders(uint256[] ids, uint256[] amounts, address[] pairAs, address[] pairBs, uint256[] priceAs, uint256[] priceBs) external payable weiSendGuard nonReentrant returns (bool) {
304     require(
305       amounts.length == ids.length &&
306       pairAs.length == ids.length &&
307       pairBs.length == ids.length &&
308       priceAs.length == ids.length &&
309       priceBs.length == ids.length
310     );
311 
312     bool allSuccess = true;
313 
314     for (uint256 i = 0; i < ids.length; i++) {
315       // update if any of the orders failed
316       // the function is like this because "stack too deep" error
317       if (allSuccess && !_makeOrder(ids[i], amounts[i], pairAs[i], pairBs[i], priceAs[i], priceBs[i], msg.sender)) allSuccess = false;
318     }
319 
320     if (weiSend > 0) msg.sender.transfer(weiSend);
321 
322     return allSuccess;
323   }
324 
325   function takeOrders(uint256[] ids, uint256[] amounts) external payable weiSendGuard nonReentrant returns (bool) {
326     require(ids.length == amounts.length);
327 
328     bool allSuccess = true;
329 
330     for (uint256 i = 0; i < ids.length; i++) {
331       bool success = _takeOrder(ids[i], amounts[i], msg.sender);
332 
333       // update if any of the orders failed
334       if (allSuccess && !success) allSuccess = success;
335     }
336 
337     if (weiSend > 0) msg.sender.transfer(weiSend);
338 
339     return allSuccess;
340   }
341 
342   function cancelOrders(uint256[] ids) external nonReentrant returns (bool) {
343     bool allSuccess = true;
344 
345     for (uint256 i = 0; i < ids.length; i++) {
346       bool success = _cancelOrder(ids[i], msg.sender);
347 
348       // update if any of the orders failed
349       if (allSuccess && !success) allSuccess = success;
350     }
351 
352     return allSuccess;
353   }
354 }