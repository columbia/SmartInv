1 pragma solidity 0.4.24;
2 
3 /**
4 * @title SafeMath
5 * @dev Math operations with safety checks that throw on error
6 */
7 
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a * b;
11         require(a == 0 || c / a == b, "mul overflow");
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         require(b > 0, "div by 0"); // Solidity automatically throws for div by 0 but require to emit reason
17         uint256 c = a / b;
18         // require(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         require(b <= a, "sub underflow");
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "add overflow");
30         return c;
31     }
32 
33     function roundedDiv(uint a, uint b) internal pure returns (uint256) {
34         require(b > 0, "div by 0"); // Solidity automatically throws for div by 0 but require to emit reason
35         uint256 z = a / b;
36         if (a % b >= b / 2) {
37             z++;  // no need for safe add b/c it can happen only if we divided the input
38         }
39         return z;
40     }
41 }
42 
43 /*
44     Generic contract to authorise calls to certain functions only from a given address.
45     The address authorised must be a contract (multisig or not, depending on the permission), except for local test
46 
47     deployment works as:
48            1. contract deployer account deploys contracts
49            2. constructor grants "PermissionGranter" permission to deployer account
50            3. deployer account executes initial setup (no multiSig)
51            4. deployer account grants PermissionGranter permission for the MultiSig contract
52                 (e.g. StabilityBoardProxy or PreTokenProxy)
53            5. deployer account revokes its own PermissionGranter permission
54 */
55 
56 contract Restricted {
57 
58     // NB: using bytes32 rather than the string type because it's cheaper gas-wise:
59     mapping (address => mapping (bytes32 => bool)) public permissions;
60 
61     event PermissionGranted(address indexed agent, bytes32 grantedPermission);
62     event PermissionRevoked(address indexed agent, bytes32 revokedPermission);
63 
64     modifier restrict(bytes32 requiredPermission) {
65         require(permissions[msg.sender][requiredPermission], "msg.sender must have permission");
66         _;
67     }
68 
69     constructor(address permissionGranterContract) public {
70         require(permissionGranterContract != address(0), "permissionGranterContract must be set");
71         permissions[permissionGranterContract]["PermissionGranter"] = true;
72         emit PermissionGranted(permissionGranterContract, "PermissionGranter");
73     }
74 
75     function grantPermission(address agent, bytes32 requiredPermission) public {
76         require(permissions[msg.sender]["PermissionGranter"],
77             "msg.sender must have PermissionGranter permission");
78         permissions[agent][requiredPermission] = true;
79         emit PermissionGranted(agent, requiredPermission);
80     }
81 
82     function grantMultiplePermissions(address agent, bytes32[] requiredPermissions) public {
83         require(permissions[msg.sender]["PermissionGranter"],
84             "msg.sender must have PermissionGranter permission");
85         uint256 length = requiredPermissions.length;
86         for (uint256 i = 0; i < length; i++) {
87             grantPermission(agent, requiredPermissions[i]);
88         }
89     }
90 
91     function revokePermission(address agent, bytes32 requiredPermission) public {
92         require(permissions[msg.sender]["PermissionGranter"],
93             "msg.sender must have PermissionGranter permission");
94         permissions[agent][requiredPermission] = false;
95         emit PermissionRevoked(agent, requiredPermission);
96     }
97 
98     function revokeMultiplePermissions(address agent, bytes32[] requiredPermissions) public {
99         uint256 length = requiredPermissions.length;
100         for (uint256 i = 0; i < length; i++) {
101             revokePermission(agent, requiredPermissions[i]);
102         }
103     }
104 
105 }
106 
107 interface ERC20Interface {
108     event Approval(address indexed _owner, address indexed _spender, uint _value);
109     event Transfer(address indexed from, address indexed to, uint amount);
110 
111     function transfer(address to, uint value) external returns (bool); // solhint-disable-line no-simple-event-func-name
112     function transferFrom(address from, address to, uint value) external returns (bool);
113     function approve(address spender, uint value) external returns (bool);
114     function balanceOf(address who) external view returns (uint);
115     function allowance(address _owner, address _spender) external view returns (uint remaining);
116 
117 }
118 
119 interface TransferFeeInterface {
120     function calculateTransferFee(address from, address to, uint amount) external view returns (uint256 fee);
121 }
122 
123 interface TokenReceiver {
124     function transferNotification(address from, uint256 amount, uint data) external;
125 }
126 
127 
128 contract AugmintTokenInterface is Restricted, ERC20Interface {
129     using SafeMath for uint256;
130 
131     string public name;
132     string public symbol;
133     bytes32 public peggedSymbol;
134     uint8 public decimals;
135 
136     uint public totalSupply;
137     mapping(address => uint256) public balances; // Balances for each account
138     mapping(address => mapping (address => uint256)) public allowed; // allowances added with approve()
139 
140     address public stabilityBoardProxy;
141     TransferFeeInterface public feeAccount;
142     mapping(bytes32 => bool) public delegatedTxHashesUsed; // record txHashes used by delegatedTransfer
143 
144     event TransferFeesChanged(uint transferFeePt, uint transferFeeMin, uint transferFeeMax);
145     event Transfer(address indexed from, address indexed to, uint amount);
146     event AugmintTransfer(address indexed from, address indexed to, uint amount, string narrative, uint fee);
147     event TokenIssued(uint amount);
148     event TokenBurned(uint amount);
149     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
150 
151     function transfer(address to, uint value) external returns (bool); // solhint-disable-line no-simple-event-func-name
152     function transferFrom(address from, address to, uint value) external returns (bool);
153     function approve(address spender, uint value) external returns (bool);
154 
155     function delegatedTransfer(address from, address to, uint amount, string narrative,
156                                     uint maxExecutorFeeInToken, /* client provided max fee for executing the tx */
157                                     bytes32 nonce, /* random nonce generated by client */
158                                     /* ^^^^ end of signed data ^^^^ */
159                                     bytes signature,
160                                     uint requestedExecutorFeeInToken /* the executor can decide to request lower fee */
161                                 ) external;
162 
163     function delegatedTransferAndNotify(address from, TokenReceiver target, uint amount, uint data,
164                                     uint maxExecutorFeeInToken, /* client provided max fee for executing the tx */
165                                     bytes32 nonce, /* random nonce generated by client */
166                                     /* ^^^^ end of signed data ^^^^ */
167                                     bytes signature,
168                                     uint requestedExecutorFeeInToken /* the executor can decide to request lower fee */
169                                 ) external;
170 
171     function increaseApproval(address spender, uint addedValue) external returns (bool);
172     function decreaseApproval(address spender, uint subtractedValue) external returns (bool);
173 
174     function issueTo(address to, uint amount) external; // restrict it to "MonetarySupervisor" in impl.;
175     function burn(uint amount) external;
176 
177     function transferAndNotify(TokenReceiver target, uint amount, uint data) external;
178 
179     function transferWithNarrative(address to, uint256 amount, string narrative) external;
180     function transferFromWithNarrative(address from, address to, uint256 amount, string narrative) external;
181 
182     function allowance(address owner, address spender) external view returns (uint256 remaining);
183 
184     function balanceOf(address who) external view returns (uint);
185 
186 
187 }
188 
189 contract Rates is Restricted {
190     using SafeMath for uint256;
191 
192     struct RateInfo {
193         uint rate; // how much 1 WEI worth 1 unit , i.e. symbol/ETH rate
194                     // 0 rate means no rate info available
195         uint lastUpdated;
196     }
197 
198     // mapping currency symbol => rate. all rates are stored with 4 decimals. i.e. ETH/EUR = 989.12 then rate = 989,1200
199     mapping(bytes32 => RateInfo) public rates;
200 
201     event RateChanged(bytes32 symbol, uint newRate);
202 
203     constructor(address permissionGranterContract) public Restricted(permissionGranterContract) {} // solhint-disable-line no-empty-blocks
204 
205     function setRate(bytes32 symbol, uint newRate) external restrict("RatesFeeder") {
206         rates[symbol] = RateInfo(newRate, now);
207         emit RateChanged(symbol, newRate);
208     }
209 
210     function setMultipleRates(bytes32[] symbols, uint[] newRates) external restrict("RatesFeeder") {
211         require(symbols.length == newRates.length, "symobls and newRates lengths must be equal");
212         for (uint256 i = 0; i < symbols.length; i++) {
213             rates[symbols[i]] = RateInfo(newRates[i], now);
214             emit RateChanged(symbols[i], newRates[i]);
215         }
216     }
217 
218     function convertFromWei(bytes32 bSymbol, uint weiValue) external view returns(uint value) {
219         require(rates[bSymbol].rate > 0, "rates[bSymbol] must be > 0");
220         return weiValue.mul(rates[bSymbol].rate).roundedDiv(1000000000000000000);
221     }
222 
223     function convertToWei(bytes32 bSymbol, uint value) external view returns(uint weiValue) {
224         // next line would revert with div by zero but require to emit reason
225         require(rates[bSymbol].rate > 0, "rates[bSymbol] must be > 0");
226         /* TODO: can we make this not loosing max scale? */
227         return value.mul(1000000000000000000).roundedDiv(rates[bSymbol].rate);
228     }
229 
230 }
231 
232 /* Augmint's Internal Exchange
233 
234   For flows see: https://github.com/Augmint/augmint-contracts/blob/master/docs/exchangeFlow.png
235 
236     TODO:
237         - change to wihtdrawal pattern, see: https://github.com/Augmint/augmint-contracts/issues/17
238         - deduct fee
239         - consider take funcs (frequent rate changes with takeBuyToken? send more and send back remainder?)
240         - use Rates interface?
241 */
242 contract Exchange is Restricted {
243     using SafeMath for uint256;
244 
245     AugmintTokenInterface public augmintToken;
246     Rates public rates;
247 
248     uint public constant CHUNK_SIZE = 100;
249 
250     struct Order {
251         uint64 index;
252         address maker;
253 
254         // % of published current peggedSymbol/ETH rates published by Rates contract. Stored as parts per million
255         // I.e. 1,000,000 = 100% (parity), 990,000 = 1% below parity
256         uint32 price;
257 
258         // buy order: amount in wei
259         // sell order: token amount
260         uint amount;
261     }
262 
263     uint64 public orderCount;
264     mapping(uint64 => Order) public buyTokenOrders;
265     mapping(uint64 => Order) public sellTokenOrders;
266 
267     uint64[] private activeBuyOrders;
268     uint64[] private activeSellOrders;
269 
270     /* used to stop executing matchMultiple when running out of gas.
271         actual is much less, just leaving enough matchMultipleOrders() to finish TODO: fine tune & test it*/
272     uint32 private constant ORDER_MATCH_WORST_GAS = 100000;
273 
274     event NewOrder(uint64 indexed orderId, address indexed maker, uint32 price, uint tokenAmount, uint weiAmount);
275 
276     event OrderFill(address indexed tokenBuyer, address indexed tokenSeller, uint64 buyTokenOrderId,
277         uint64 sellTokenOrderId, uint publishedRate, uint32 price, uint fillRate, uint weiAmount, uint tokenAmount);
278 
279     event CancelledOrder(uint64 indexed orderId, address indexed maker, uint tokenAmount, uint weiAmount);
280 
281     event RatesContractChanged(Rates newRatesContract);
282 
283     constructor(address permissionGranterContract, AugmintTokenInterface _augmintToken, Rates _rates)
284     public Restricted(permissionGranterContract) {
285         augmintToken = _augmintToken;
286         rates = _rates;
287     }
288 
289     /* to allow upgrade of Rates  contract */
290     function setRatesContract(Rates newRatesContract)
291     external restrict("StabilityBoard") {
292         rates = newRatesContract;
293         emit RatesContractChanged(newRatesContract);
294     }
295 
296     function placeBuyTokenOrder(uint32 price) external payable returns (uint64 orderId) {
297         require(price > 0, "price must be > 0");
298         require(msg.value > 0, "msg.value must be > 0");
299 
300         orderId = ++orderCount;
301         buyTokenOrders[orderId] = Order(uint64(activeBuyOrders.length), msg.sender, price, msg.value);
302         activeBuyOrders.push(orderId);
303 
304         emit NewOrder(orderId, msg.sender, price, 0, msg.value);
305     }
306 
307     /* this function requires previous approval to transfer tokens */
308     function placeSellTokenOrder(uint32 price, uint tokenAmount) external returns (uint orderId) {
309         augmintToken.transferFrom(msg.sender, this, tokenAmount);
310         return _placeSellTokenOrder(msg.sender, price, tokenAmount);
311     }
312 
313     /* place sell token order called from AugmintToken's transferAndNotify
314      Flow:
315         1) user calls token contract's transferAndNotify price passed in data arg
316         2) transferAndNotify transfers tokens to the Exchange contract
317         3) transferAndNotify calls Exchange.transferNotification with lockProductId
318     */
319     function transferNotification(address maker, uint tokenAmount, uint price) external {
320         require(msg.sender == address(augmintToken), "msg.sender must be augmintToken");
321         _placeSellTokenOrder(maker, uint32(price), tokenAmount);
322     }
323 
324     function cancelBuyTokenOrder(uint64 buyTokenId) external {
325         Order storage order = buyTokenOrders[buyTokenId];
326         require(order.maker == msg.sender, "msg.sender must be order.maker");
327         require(order.amount > 0, "buy order already removed");
328 
329         uint amount = order.amount;
330         order.amount = 0;
331         _removeBuyOrder(order);
332 
333         msg.sender.transfer(amount);
334 
335         emit CancelledOrder(buyTokenId, msg.sender, 0, amount);
336     }
337 
338     function cancelSellTokenOrder(uint64 sellTokenId) external {
339         Order storage order = sellTokenOrders[sellTokenId];
340         require(order.maker == msg.sender, "msg.sender must be order.maker");
341         require(order.amount > 0, "sell order already removed");
342 
343         uint amount = order.amount;
344         order.amount = 0;
345         _removeSellOrder(order);
346 
347         augmintToken.transferWithNarrative(msg.sender, amount, "Sell token order cancelled");
348 
349         emit CancelledOrder(sellTokenId, msg.sender, amount, 0);
350     }
351 
352     /* matches any two orders if the sell price >= buy price
353         trade price is the price of the maker (the order placed earlier)
354         reverts if any of the orders have been removed
355     */
356     function matchOrders(uint64 buyTokenId, uint64 sellTokenId) external {
357         require(_fillOrder(buyTokenId, sellTokenId), "fill order failed");
358     }
359 
360     /*  matches as many orders as possible from the passed orders
361         Runs as long as gas is available for the call.
362         Reverts if any match is invalid (e.g sell price > buy price)
363         Skips match if any of the matched orders is removed / already filled (i.e. amount = 0)
364     */
365     function matchMultipleOrders(uint64[] buyTokenIds, uint64[] sellTokenIds) external returns(uint matchCount) {
366         uint len = buyTokenIds.length;
367         require(len == sellTokenIds.length, "buyTokenIds and sellTokenIds lengths must be equal");
368 
369         for (uint i = 0; i < len && gasleft() > ORDER_MATCH_WORST_GAS; i++) {
370             if(_fillOrder(buyTokenIds[i], sellTokenIds[i])) {
371                 matchCount++;
372             }
373         }
374     }
375 
376     function getActiveOrderCounts() external view returns(uint buyTokenOrderCount, uint sellTokenOrderCount) {
377         return(activeBuyOrders.length, activeSellOrders.length);
378     }
379 
380     // returns CHUNK_SIZE orders starting from offset
381     // orders are encoded as [id, maker, price, amount]
382     function getActiveBuyOrders(uint offset) external view returns (uint[4][CHUNK_SIZE] response) {
383         for (uint8 i = 0; i < CHUNK_SIZE && i + offset < activeBuyOrders.length; i++) {
384             uint64 orderId = activeBuyOrders[offset + i];
385             Order storage order = buyTokenOrders[orderId];
386             response[i] = [orderId, uint(order.maker), order.price, order.amount];
387         }
388     }
389 
390     function getActiveSellOrders(uint offset) external view returns (uint[4][CHUNK_SIZE] response) {
391         for (uint8 i = 0; i < CHUNK_SIZE && i + offset < activeSellOrders.length; i++) {
392             uint64 orderId = activeSellOrders[offset + i];
393             Order storage order = sellTokenOrders[orderId];
394             response[i] = [orderId, uint(order.maker), order.price, order.amount];
395         }
396     }
397 
398     function _fillOrder(uint64 buyTokenId, uint64 sellTokenId) private returns(bool success) {
399         Order storage buy = buyTokenOrders[buyTokenId];
400         Order storage sell = sellTokenOrders[sellTokenId];
401         if( buy.amount == 0 || sell.amount == 0 ) {
402             return false; // one order is already filled and removed.
403                           // we let matchMultiple continue, indivudal match will revert
404         }
405 
406         require(buy.price >= sell.price, "buy price must be >= sell price");
407 
408         // pick maker's price (whoever placed order sooner considered as maker)
409         uint32 price = buyTokenId > sellTokenId ? sell.price : buy.price;
410 
411         uint publishedRate;
412         (publishedRate, ) = rates.rates(augmintToken.peggedSymbol());
413         uint fillRate = publishedRate.mul(price).roundedDiv(1000000);
414 
415         uint sellWei = sell.amount.mul(1 ether).roundedDiv(fillRate);
416 
417         uint tradedWei;
418         uint tradedTokens;
419         if (sellWei <= buy.amount) {
420             tradedWei = sellWei;
421             tradedTokens = sell.amount;
422         } else {
423             tradedWei = buy.amount;
424             tradedTokens = buy.amount.mul(fillRate).roundedDiv(1 ether);
425         }
426 
427         buy.amount = buy.amount.sub(tradedWei);
428         if (buy.amount == 0) {
429             _removeBuyOrder(buy);
430         }
431 
432         sell.amount = sell.amount.sub(tradedTokens);
433         if (sell.amount == 0) {
434             _removeSellOrder(sell);
435         }
436 
437         augmintToken.transferWithNarrative(buy.maker, tradedTokens, "Buy token order fill");
438         sell.maker.transfer(tradedWei);
439 
440         emit OrderFill(buy.maker, sell.maker, buyTokenId,
441             sellTokenId, publishedRate, price, fillRate, tradedWei, tradedTokens);
442 
443         return true;
444     }
445 
446     function _placeSellTokenOrder(address maker, uint32 price, uint tokenAmount)
447     private returns (uint64 orderId) {
448         require(price > 0, "price must be > 0");
449         require(tokenAmount > 0, "tokenAmount must be > 0");
450 
451         orderId = ++orderCount;
452         sellTokenOrders[orderId] = Order(uint64(activeSellOrders.length), maker, price, tokenAmount);
453         activeSellOrders.push(orderId);
454 
455         emit NewOrder(orderId, maker, price, tokenAmount, 0);
456     }
457 
458     function _removeBuyOrder(Order storage order) private {
459         _removeOrder(activeBuyOrders, order.index);
460     }
461 
462     function _removeSellOrder(Order storage order) private {
463         _removeOrder(activeSellOrders, order.index);
464     }
465 
466     function _removeOrder(uint64[] storage orders, uint64 index) private {
467         if (index < orders.length - 1) {
468             orders[index] = orders[orders.length - 1];
469         }
470         orders.length--;
471     }
472 
473 }