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
119 contract Ownable {
120   address public owner;
121 
122 
123   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
124 
125 
126   /**
127    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
128    * account.
129    */
130   function Ownable() public {
131     owner = msg.sender;
132   }
133 
134 
135   /**
136    * @dev Throws if called by any account other than the owner.
137    */
138   modifier onlyOwner() {
139     require(msg.sender == owner);
140     _;
141   }
142 
143 
144   /**
145    * @dev Allows the current owner to transfer control of the contract to a newOwner.
146    * @param newOwner The address to transfer ownership to.
147    */
148   function transferOwnership(address newOwner) public onlyOwner {
149     require(newOwner != address(0));
150     OwnershipTransferred(owner, newOwner);
151     owner = newOwner;
152   }
153 
154 }
155 
156 
157 
158 /**
159  * @title Pausable
160  * @dev Base contract which allows children to implement an emergency stop mechanism.
161  */
162 contract Pausable is Ownable {
163   event Pause();
164   event Unpause();
165 
166   bool public paused = false;
167 
168 
169   /**
170    * @dev Modifier to make a function callable only when the contract is not paused.
171    */
172   modifier whenNotPaused() {
173     require(!paused);
174     _;
175   }
176 
177   /**
178    * @dev Modifier to make a function callable only when the contract is paused.
179    */
180   modifier whenPaused() {
181     require(paused);
182     _;
183   }
184 
185   /**
186    * @dev called by the owner to pause, triggers stopped state
187    */
188   function pause() onlyOwner whenNotPaused public {
189     paused = true;
190     Pause();
191   }
192 
193   /**
194    * @dev called by the owner to unpause, returns to normal state
195    */
196   function unpause() onlyOwner whenPaused public {
197     paused = false;
198     Unpause();
199   }
200 }
201 
202 
203 // File: contracts\DecentralizedExchanges2.sol
204 
205 contract SpecialERC20 {
206     function transfer(address to, uint256 value) public;
207 }
208 
209 contract DecentralizedExchanges is Pausable {
210 
211     using SafeMath for uint;
212     using SafeERC20 for ERC20;
213 
214     string public name = "DecentralizedExchanges";
215 
216     event Order(bytes32 hash);
217     event Trade(bytes32 hash, address seller, address token, uint amount, address purchaser, uint eth);
218     event Cancel(bytes32 hash, uint amount, bool isSell);
219 
220     struct OrderInfo {
221         bool isSell;
222         bool isSpecialERC20;
223         uint eth;
224         uint amount;
225         uint expires;
226         uint nonce;
227         uint createdAt;
228         uint fill;
229         address token;
230         address[] limitUser;
231         address owner;
232     }
233 
234     mapping (bytes32 => OrderInfo) public orderInfos;
235     mapping (address => bytes32[]) public userOrders;
236     mapping (address => bool) public tokenWhiteList;
237 
238     modifier isHuman() {
239         address _addr = msg.sender;
240         uint256 _codeLength;
241         
242         assembly {_codeLength := extcodesize(_addr)}
243         require(_codeLength == 0, "sorry humans only");
244         _;
245     }
246 
247     function enableToken(address[] addr, bool[] enable) public onlyOwner() {
248         require(addr.length == enable.length);
249         for (uint i = 0; i < addr.length; i++) {
250             tokenWhiteList[addr[i]] = enable[i];
251         }
252     }
253 
254     function tokenIsEnable(address addr) public view returns (bool) {
255         return tokenWhiteList[addr];
256     }
257 
258     function getOrderInfo(bytes32 hash) public view returns (bool, uint, address, uint, uint, uint, address[], uint, address, uint, bool) {
259         OrderInfo storage info = orderInfos[hash];
260         return (info.isSell, info.eth, info.token, info.amount, info.expires, info.nonce, info.limitUser, info.createdAt, info.owner, info.fill, info.isSpecialERC20);
261     }
262 
263 
264     // 创建买单,用eth买token
265     function createPurchaseOrder(bool isSpecialERC20, uint eth, address token, uint amount, uint expires, address[] seller, uint nonce) payable public isHuman() whenNotPaused(){
266         require(msg.value >= eth);
267         require(tokenWhiteList[token]);
268 
269         bytes32 hash = sha256(abi.encodePacked(this, eth, token, amount, expires, seller, nonce, msg.sender, now));
270         orderInfos[hash] = OrderInfo(false, isSpecialERC20, eth, amount, expires, nonce, now, 0, token, seller, msg.sender);
271         for (uint i = 0; i < userOrders[msg.sender].length; i++) {
272             require(userOrders[msg.sender][i] != hash);
273         }
274         userOrders[msg.sender].push(hash);
275         emit Order(hash);
276     }
277 
278     // 创建卖单,卖token得eth
279     function createSellOrder(bool isSpecialERC20, address token, uint amount, uint eth, uint expires, address[] purchaser, uint nonce) public isHuman() whenNotPaused() {
280         require(tokenWhiteList[token]);
281 
282         ERC20(token).safeTransferFrom(msg.sender, this, amount);
283         bytes32 hash = sha256(abi.encodePacked(this, eth, token, amount, expires, purchaser, nonce, msg.sender, now));
284         orderInfos[hash] = OrderInfo(true, isSpecialERC20, eth, amount, expires, nonce, now, 0, token, purchaser, msg.sender);
285         for (uint i = 0; i < userOrders[msg.sender].length; i++) {
286             require(userOrders[msg.sender][i] != hash);
287         }
288         userOrders[msg.sender].push(hash);
289         emit Order(hash);
290     }
291 
292     function cancelOrder(bytes32 hash) public isHuman() {
293         OrderInfo storage info = orderInfos[hash];
294         require(info.owner == msg.sender);
295         if (info.isSell) {
296             if (info.fill < info.amount) {
297                 uint amount = info.amount;
298                 uint remain = amount.sub(info.fill);
299                 info.fill = info.amount;
300                 if (info.isSpecialERC20) {
301                     SpecialERC20(info.token).transfer(msg.sender, remain);
302                 } else {
303                     ERC20(info.token).transfer(msg.sender, remain);
304                 }
305                 emit Cancel(hash, remain, info.isSell);
306             } else {
307                 emit Cancel(hash, 0, info.isSell);
308             }
309         } else {
310             if (info.fill < info.eth) {
311                 uint eth = info.eth;
312                 remain = eth.sub(info.fill);
313                 info.fill = info.eth;
314                 msg.sender.transfer(eth);
315                 emit Cancel(hash, remain, info.isSell);
316             } else {
317                 emit Cancel(hash, 0, info.isSell);
318             }
319         }
320     }
321 
322     // 卖token,针对创建的买单
323     function sell(bytes32 hash, uint amount) public isHuman() whenNotPaused(){
324         OrderInfo storage info = orderInfos[hash];
325         bool find = false;
326         if (info.limitUser.length > 0) {
327             for (uint i = 0; i < info.limitUser.length; i++) {
328                 if (info.limitUser[i] == msg.sender) {
329                     find = true;
330                     break;
331                 }
332             }
333             require(find);
334         }
335 
336         // 确保订单还有剩余eth
337         require(info.fill < info.eth);
338         require(info.expires >= now);
339         require(info.isSell == false); // 只能针对挂的买单操作
340 
341         uint remain = info.eth.sub(info.fill);
342 
343         uint remainAmount = remain.mul(info.amount).div(info.eth);
344         
345         uint tradeAmount = remainAmount < amount ? remainAmount : amount;
346         // token从卖家转到合约
347         ERC20(info.token).safeTransferFrom(msg.sender, this, tradeAmount);
348 
349         uint total = info.eth.mul(tradeAmount).div(info.amount);
350         require(total > 0);
351 
352         info.fill = info.fill.add(total);
353         
354         msg.sender.transfer(total);
355         
356         // token从合约转到买家
357         if (info.isSpecialERC20) {
358             SpecialERC20(info.token).transfer(info.owner, tradeAmount);
359         } else {
360             ERC20(info.token).transfer(info.owner, tradeAmount);
361         }
362 
363 
364         emit Trade(hash, msg.sender, info.token, tradeAmount, info.owner, total);
365     }
366 
367     // 买token,针对创建的卖单
368     function purchase(bytes32 hash, uint amount) payable public isHuman() whenNotPaused() {
369         OrderInfo storage info = orderInfos[hash];
370         bool find = false;
371         if (info.limitUser.length > 0) {
372             for (uint i = 0; i < info.limitUser.length; i++) {
373                 if (info.limitUser[i] == msg.sender) {
374                     find = true;
375                     break;
376                 }
377             }
378             require(find);
379         }
380 
381         // 确保订单还有剩余token
382         require(info.fill < info.amount);
383         require(info.expires >= now);
384         require(info.isSell); // 只能针对挂卖单操作
385 
386         uint remainAmount = info.amount.sub(info.fill);
387 
388         uint tradeAmount = remainAmount < amount ? remainAmount : amount;
389 
390         uint total = info.eth.mul(tradeAmount).div(info.amount);
391         require(total > 0);
392 
393         require(msg.value >= total);
394         if (msg.value > total) { // 多余的eth转回去
395             msg.sender.transfer(msg.value.sub(total));
396         }
397 
398         info.fill = info.fill.add(tradeAmount);
399 
400         info.owner.transfer(total);
401 
402         if (info.isSpecialERC20) {
403             SpecialERC20(info.token).transfer(msg.sender, tradeAmount);
404         } else {
405             ERC20(info.token).transfer(msg.sender, tradeAmount);
406         }
407 
408         emit Trade(hash, info.owner, info.token, tradeAmount, msg.sender, total);
409     }
410   
411 }