1 // File: contracts/generic/Restricted.sol
2 
3 /*
4     Generic contract to authorise calls to certain functions only from a given address.
5     The address authorised must be a contract (multisig or not, depending on the permission), except for local test
6 
7     deployment works as:
8            1. contract deployer account deploys contracts
9            2. constructor grants "PermissionGranter" permission to deployer account
10            3. deployer account executes initial setup (no multiSig)
11            4. deployer account grants PermissionGranter permission for the MultiSig contract
12                 (e.g. StabilityBoardProxy or PreTokenProxy)
13            5. deployer account revokes its own PermissionGranter permission
14 */
15 
16 pragma solidity 0.4.24;
17 
18 
19 contract Restricted {
20 
21     // NB: using bytes32 rather than the string type because it's cheaper gas-wise:
22     mapping (address => mapping (bytes32 => bool)) public permissions;
23 
24     event PermissionGranted(address indexed agent, bytes32 grantedPermission);
25     event PermissionRevoked(address indexed agent, bytes32 revokedPermission);
26 
27     modifier restrict(bytes32 requiredPermission) {
28         require(permissions[msg.sender][requiredPermission], "msg.sender must have permission");
29         _;
30     }
31 
32     constructor(address permissionGranterContract) public {
33         require(permissionGranterContract != address(0), "permissionGranterContract must be set");
34         permissions[permissionGranterContract]["PermissionGranter"] = true;
35         emit PermissionGranted(permissionGranterContract, "PermissionGranter");
36     }
37 
38     function grantPermission(address agent, bytes32 requiredPermission) public {
39         require(permissions[msg.sender]["PermissionGranter"],
40             "msg.sender must have PermissionGranter permission");
41         permissions[agent][requiredPermission] = true;
42         emit PermissionGranted(agent, requiredPermission);
43     }
44 
45     function grantMultiplePermissions(address agent, bytes32[] requiredPermissions) public {
46         require(permissions[msg.sender]["PermissionGranter"],
47             "msg.sender must have PermissionGranter permission");
48         uint256 length = requiredPermissions.length;
49         for (uint256 i = 0; i < length; i++) {
50             grantPermission(agent, requiredPermissions[i]);
51         }
52     }
53 
54     function revokePermission(address agent, bytes32 requiredPermission) public {
55         require(permissions[msg.sender]["PermissionGranter"],
56             "msg.sender must have PermissionGranter permission");
57         permissions[agent][requiredPermission] = false;
58         emit PermissionRevoked(agent, requiredPermission);
59     }
60 
61     function revokeMultiplePermissions(address agent, bytes32[] requiredPermissions) public {
62         uint256 length = requiredPermissions.length;
63         for (uint256 i = 0; i < length; i++) {
64             revokePermission(agent, requiredPermissions[i]);
65         }
66     }
67 
68 }
69 
70 // File: contracts/generic/SafeMath.sol
71 
72 /**
73 * @title SafeMath
74 * @dev Math operations with safety checks that throw on error
75 
76     TODO: check against ds-math: https://blog.dapphub.com/ds-math/
77     TODO: move roundedDiv to a sep lib? (eg. Math.sol)
78     TODO: more unit tests!
79 */
80 pragma solidity 0.4.24;
81 
82 
83 library SafeMath {
84     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
85         uint256 c = a * b;
86         require(a == 0 || c / a == b, "mul overflow");
87         return c;
88     }
89 
90     function div(uint256 a, uint256 b) internal pure returns (uint256) {
91         require(b > 0, "div by 0"); // Solidity automatically throws for div by 0 but require to emit reason
92         uint256 c = a / b;
93         // require(a == b * c + a % b); // There is no case in which this doesn't hold
94         return c;
95     }
96 
97     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98         require(b <= a, "sub underflow");
99         return a - b;
100     }
101 
102     function add(uint256 a, uint256 b) internal pure returns (uint256) {
103         uint256 c = a + b;
104         require(c >= a, "add overflow");
105         return c;
106     }
107 
108     // Division, round to nearest integer, round half up
109     function roundedDiv(uint256 a, uint256 b) internal pure returns (uint256) {
110         require(b > 0, "div by 0"); // Solidity automatically throws for div by 0 but require to emit reason
111         uint256 halfB = (b % 2 == 0) ? (b / 2) : (b / 2 + 1);
112         return (a % b >= halfB) ? (a / b + 1) : (a / b);
113     }
114 
115     // Division, always rounds up
116     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
117         require(b > 0, "div by 0"); // Solidity automatically throws for div by 0 but require to emit reason
118         return (a % b != 0) ? (a / b + 1) : (a / b);
119     }
120 
121     function min(uint256 a, uint256 b) internal pure returns (uint256) {
122         return a < b ? a : b;
123     }
124 
125     function max(uint256 a, uint256 b) internal pure returns (uint256) {
126         return a < b ? b : a;
127     }    
128 }
129 
130 // File: contracts/Rates.sol
131 
132 /*
133  Generic symbol / WEI rates contract.
134  only callable by trusted price oracles.
135  Being regularly called by a price oracle
136     TODO: trustless/decentrilezed price Oracle
137     TODO: shall we use blockNumber instead of now for lastUpdated?
138     TODO: consider if we need storing rates with variable decimals instead of fixed 4
139     TODO: could we emit 1 RateChanged event from setMultipleRates (symbols and newrates arrays)?
140 */
141 pragma solidity 0.4.24;
142 
143 
144 
145 
146 contract Rates is Restricted {
147     using SafeMath for uint256;
148 
149     struct RateInfo {
150         uint rate; // how much 1 WEI worth 1 unit , i.e. symbol/ETH rate
151                     // 0 rate means no rate info available
152         uint lastUpdated;
153     }
154 
155     // mapping currency symbol => rate. all rates are stored with 2 decimals. i.e. EUR/ETH = 989.12 then rate = 98912
156     mapping(bytes32 => RateInfo) public rates;
157 
158     event RateChanged(bytes32 symbol, uint newRate);
159 
160     constructor(address permissionGranterContract) public Restricted(permissionGranterContract) {} // solhint-disable-line no-empty-blocks
161 
162     function setRate(bytes32 symbol, uint newRate) external restrict("RatesFeeder") {
163         rates[symbol] = RateInfo(newRate, now);
164         emit RateChanged(symbol, newRate);
165     }
166 
167     function setMultipleRates(bytes32[] symbols, uint[] newRates) external restrict("RatesFeeder") {
168         require(symbols.length == newRates.length, "symobls and newRates lengths must be equal");
169         for (uint256 i = 0; i < symbols.length; i++) {
170             rates[symbols[i]] = RateInfo(newRates[i], now);
171             emit RateChanged(symbols[i], newRates[i]);
172         }
173     }
174 
175     function convertFromWei(bytes32 bSymbol, uint weiValue) external view returns(uint value) {
176         require(rates[bSymbol].rate > 0, "rates[bSymbol] must be > 0");
177         return weiValue.mul(rates[bSymbol].rate).roundedDiv(1000000000000000000);
178     }
179 
180     function convertToWei(bytes32 bSymbol, uint value) external view returns(uint weiValue) {
181         // next line would revert with div by zero but require to emit reason
182         require(rates[bSymbol].rate > 0, "rates[bSymbol] must be > 0");
183         /* TODO: can we make this not loosing max scale? */
184         return value.mul(1000000000000000000).roundedDiv(rates[bSymbol].rate);
185     }
186 
187 }
188 
189 // File: contracts/interfaces/TransferFeeInterface.sol
190 
191 /*
192  *  transfer fee calculation interface
193  *
194  */
195 pragma solidity 0.4.24;
196 
197 
198 interface TransferFeeInterface {
199     function calculateTransferFee(address from, address to, uint amount) external view returns (uint256 fee);
200 }
201 
202 // File: contracts/interfaces/ERC20Interface.sol
203 
204 /*
205  * ERC20 interface
206  * see https://github.com/ethereum/EIPs/issues/20
207  */
208 pragma solidity 0.4.24;
209 
210 
211 interface ERC20Interface {
212     event Approval(address indexed _owner, address indexed _spender, uint _value);
213     event Transfer(address indexed from, address indexed to, uint amount);
214 
215     function transfer(address to, uint value) external returns (bool); // solhint-disable-line no-simple-event-func-name
216     function transferFrom(address from, address to, uint value) external returns (bool);
217     function approve(address spender, uint value) external returns (bool);
218     function balanceOf(address who) external view returns (uint);
219     function allowance(address _owner, address _spender) external view returns (uint remaining);
220 
221 }
222 
223 // File: contracts/interfaces/TokenReceiver.sol
224 
225 /*
226  *  receiver contract interface
227  * see https://github.com/ethereum/EIPs/issues/677
228  */
229 pragma solidity 0.4.24;
230 
231 
232 interface TokenReceiver {
233     function transferNotification(address from, uint256 amount, uint data) external;
234 }
235 
236 // File: contracts/interfaces/AugmintTokenInterface.sol
237 
238 /* Augmint Token interface (abstract contract)
239 
240 TODO: overload transfer() & transferFrom() instead of transferWithNarrative() & transferFromWithNarrative()
241       when this fix available in web3& truffle also uses that web3: https://github.com/ethereum/web3.js/pull/1185
242 TODO: shall we use bytes for narrative?
243  */
244 pragma solidity 0.4.24;
245 
246 
247 
248 
249 
250 
251 
252 contract AugmintTokenInterface is Restricted, ERC20Interface {
253     using SafeMath for uint256;
254 
255     string public name;
256     string public symbol;
257     bytes32 public peggedSymbol;
258     uint8 public decimals;
259 
260     uint public totalSupply;
261     mapping(address => uint256) public balances; // Balances for each account
262     mapping(address => mapping (address => uint256)) public allowed; // allowances added with approve()
263 
264     TransferFeeInterface public feeAccount;
265     mapping(bytes32 => bool) public delegatedTxHashesUsed; // record txHashes used by delegatedTransfer
266 
267     event TransferFeesChanged(uint transferFeePt, uint transferFeeMin, uint transferFeeMax);
268     event Transfer(address indexed from, address indexed to, uint amount);
269     event AugmintTransfer(address indexed from, address indexed to, uint amount, string narrative, uint fee);
270     event TokenIssued(uint amount);
271     event TokenBurned(uint amount);
272     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
273 
274     function transfer(address to, uint value) external returns (bool); // solhint-disable-line no-simple-event-func-name
275     function transferFrom(address from, address to, uint value) external returns (bool);
276     function approve(address spender, uint value) external returns (bool);
277 
278     function delegatedTransfer(address from, address to, uint amount, string narrative,
279                                     uint maxExecutorFeeInToken, /* client provided max fee for executing the tx */
280                                     bytes32 nonce, /* random nonce generated by client */
281                                     /* ^^^^ end of signed data ^^^^ */
282                                     bytes signature,
283                                     uint requestedExecutorFeeInToken /* the executor can decide to request lower fee */
284                                 ) external;
285 
286     function delegatedTransferAndNotify(address from, TokenReceiver target, uint amount, uint data,
287                                     uint maxExecutorFeeInToken, /* client provided max fee for executing the tx */
288                                     bytes32 nonce, /* random nonce generated by client */
289                                     /* ^^^^ end of signed data ^^^^ */
290                                     bytes signature,
291                                     uint requestedExecutorFeeInToken /* the executor can decide to request lower fee */
292                                 ) external;
293 
294     function increaseApproval(address spender, uint addedValue) external;
295     function decreaseApproval(address spender, uint subtractedValue) external;
296 
297     function issueTo(address to, uint amount) external; // restrict it to "MonetarySupervisor" in impl.;
298     function burn(uint amount) external;
299 
300     function transferAndNotify(TokenReceiver target, uint amount, uint data) external;
301 
302     function transferWithNarrative(address to, uint256 amount, string narrative) external;
303     function transferFromWithNarrative(address from, address to, uint256 amount, string narrative) external;
304 
305     function setName(string _name) external;
306     function setSymbol(string _symbol) external;
307 
308     function allowance(address owner, address spender) external view returns (uint256 remaining);
309 
310     function balanceOf(address who) external view returns (uint);
311 
312 
313 }
314 
315 // File: contracts/Exchange.sol
316 
317 /* Augmint's Internal Exchange
318 
319   For flows see: https://github.com/Augmint/augmint-contracts/blob/master/docs/exchangeFlow.png
320 
321     TODO:
322         - change to wihtdrawal pattern, see: https://github.com/Augmint/augmint-contracts/issues/17
323         - deduct fee
324         - consider take funcs (frequent rate changes with takeBuyToken? send more and send back remainder?)
325         - use Rates interface?
326 */
327 pragma solidity 0.4.24;
328 
329 
330 
331 
332 
333 
334 contract Exchange is Restricted {
335     using SafeMath for uint256;
336 
337     AugmintTokenInterface public augmintToken;
338     Rates public rates;
339 
340     struct Order {
341         uint64 index;
342         address maker;
343 
344         // % of published current peggedSymbol/ETH rates published by Rates contract. Stored as parts per million
345         // I.e. 1,000,000 = 100% (parity), 990,000 = 1% below parity
346         uint32 price;
347 
348         // buy order: amount in wei
349         // sell order: token amount
350         uint amount;
351     }
352 
353     uint64 public orderCount;
354     mapping(uint64 => Order) public buyTokenOrders;
355     mapping(uint64 => Order) public sellTokenOrders;
356 
357     uint64[] private activeBuyOrders;
358     uint64[] private activeSellOrders;
359 
360     /* used to stop executing matchMultiple when running out of gas.
361         actual is much less, just leaving enough matchMultipleOrders() to finish TODO: fine tune & test it*/
362     uint32 private constant ORDER_MATCH_WORST_GAS = 100000;
363 
364     event NewOrder(uint64 indexed orderId, address indexed maker, uint32 price, uint tokenAmount, uint weiAmount);
365 
366     event OrderFill(address indexed tokenBuyer, address indexed tokenSeller, uint64 buyTokenOrderId,
367         uint64 sellTokenOrderId, uint publishedRate, uint32 price, uint weiAmount, uint tokenAmount);
368 
369     event CancelledOrder(uint64 indexed orderId, address indexed maker, uint tokenAmount, uint weiAmount);
370 
371     event RatesContractChanged(Rates newRatesContract);
372 
373     constructor(address permissionGranterContract, AugmintTokenInterface _augmintToken, Rates _rates)
374     public Restricted(permissionGranterContract) {
375         augmintToken = _augmintToken;
376         rates = _rates;
377     }
378 
379     /* to allow upgrade of Rates  contract */
380     function setRatesContract(Rates newRatesContract)
381     external restrict("StabilityBoard") {
382         rates = newRatesContract;
383         emit RatesContractChanged(newRatesContract);
384     }
385 
386     function placeBuyTokenOrder(uint32 price) external payable returns (uint64 orderId) {
387         require(price > 0, "price must be > 0");
388         require(msg.value > 0, "msg.value must be > 0");
389 
390         orderId = ++orderCount;
391         buyTokenOrders[orderId] = Order(uint64(activeBuyOrders.length), msg.sender, price, msg.value);
392         activeBuyOrders.push(orderId);
393 
394         emit NewOrder(orderId, msg.sender, price, 0, msg.value);
395     }
396 
397     /* this function requires previous approval to transfer tokens */
398     function placeSellTokenOrder(uint32 price, uint tokenAmount) external returns (uint orderId) {
399         augmintToken.transferFrom(msg.sender, this, tokenAmount);
400         return _placeSellTokenOrder(msg.sender, price, tokenAmount);
401     }
402 
403     /* place sell token order called from AugmintToken's transferAndNotify
404      Flow:
405         1) user calls token contract's transferAndNotify price passed in data arg
406         2) transferAndNotify transfers tokens to the Exchange contract
407         3) transferAndNotify calls Exchange.transferNotification with lockProductId
408     */
409     function transferNotification(address maker, uint tokenAmount, uint price) external {
410         require(msg.sender == address(augmintToken), "msg.sender must be augmintToken");
411         _placeSellTokenOrder(maker, uint32(price), tokenAmount);
412     }
413 
414     function cancelBuyTokenOrder(uint64 buyTokenId) external {
415         Order storage order = buyTokenOrders[buyTokenId];
416         require(order.maker == msg.sender, "msg.sender must be order.maker");
417         require(order.amount > 0, "buy order already removed");
418 
419         uint amount = order.amount;
420         order.amount = 0;
421         _removeBuyOrder(order);
422 
423         msg.sender.transfer(amount);
424 
425         emit CancelledOrder(buyTokenId, msg.sender, 0, amount);
426     }
427 
428     function cancelSellTokenOrder(uint64 sellTokenId) external {
429         Order storage order = sellTokenOrders[sellTokenId];
430         require(order.maker == msg.sender, "msg.sender must be order.maker");
431         require(order.amount > 0, "sell order already removed");
432 
433         uint amount = order.amount;
434         order.amount = 0;
435         _removeSellOrder(order);
436 
437         augmintToken.transferWithNarrative(msg.sender, amount, "Sell token order cancelled");
438 
439         emit CancelledOrder(sellTokenId, msg.sender, amount, 0);
440     }
441 
442     /* matches any two orders if the sell price >= buy price
443         trade price is the price of the maker (the order placed earlier)
444         reverts if any of the orders have been removed
445     */
446     function matchOrders(uint64 buyTokenId, uint64 sellTokenId) external {
447         require(_fillOrder(buyTokenId, sellTokenId), "fill order failed");
448     }
449 
450     /*  matches as many orders as possible from the passed orders
451         Runs as long as gas is available for the call.
452         Reverts if any match is invalid (e.g sell price > buy price)
453         Skips match if any of the matched orders is removed / already filled (i.e. amount = 0)
454     */
455     function matchMultipleOrders(uint64[] buyTokenIds, uint64[] sellTokenIds) external returns(uint matchCount) {
456         uint len = buyTokenIds.length;
457         require(len == sellTokenIds.length, "buyTokenIds and sellTokenIds lengths must be equal");
458 
459         for (uint i = 0; i < len && gasleft() > ORDER_MATCH_WORST_GAS; i++) {
460             if(_fillOrder(buyTokenIds[i], sellTokenIds[i])) {
461                 matchCount++;
462             }
463         }
464     }
465 
466     function getActiveOrderCounts() external view returns(uint buyTokenOrderCount, uint sellTokenOrderCount) {
467         return(activeBuyOrders.length, activeSellOrders.length);
468     }
469 
470     // returns <chunkSize> active buy orders starting from <offset>
471     // orders are encoded as [id, maker, price, amount]
472     function getActiveBuyOrders(uint offset, uint16 chunkSize)
473     external view returns (uint[4][]) {
474         uint limit = SafeMath.min(offset.add(chunkSize), activeBuyOrders.length);
475         uint[4][] memory response = new uint[4][](limit.sub(offset));
476         for (uint i = offset; i < limit; i++) {
477             uint64 orderId = activeBuyOrders[i];
478             Order storage order = buyTokenOrders[orderId];
479             response[i - offset] = [orderId, uint(order.maker), order.price, order.amount];
480         }
481         return response;
482     }
483 
484     // returns <chunkSize> active sell orders starting from <offset>
485     // orders are encoded as [id, maker, price, amount]
486     function getActiveSellOrders(uint offset, uint16 chunkSize)
487     external view returns (uint[4][]) {
488         uint limit = SafeMath.min(offset.add(chunkSize), activeSellOrders.length);
489         uint[4][] memory response = new uint[4][](limit.sub(offset));
490         for (uint i = offset; i < limit; i++) {
491             uint64 orderId = activeSellOrders[i];
492             Order storage order = sellTokenOrders[orderId];
493             response[i - offset] = [orderId, uint(order.maker), order.price, order.amount];
494         }
495         return response;
496     }
497 
498     uint private constant E12 = 1000000000000;
499 
500     function _fillOrder(uint64 buyTokenId, uint64 sellTokenId) private returns(bool success) {
501         Order storage buy = buyTokenOrders[buyTokenId];
502         Order storage sell = sellTokenOrders[sellTokenId];
503         if( buy.amount == 0 || sell.amount == 0 ) {
504             return false; // one order is already filled and removed.
505                           // we let matchMultiple continue, indivudal match will revert
506         }
507 
508         require(buy.price >= sell.price, "buy price must be >= sell price");
509 
510         // pick maker's price (whoever placed order sooner considered as maker)
511         uint32 price = buyTokenId > sellTokenId ? sell.price : buy.price;
512 
513         uint publishedRate;
514         (publishedRate, ) = rates.rates(augmintToken.peggedSymbol());
515         // fillRate = publishedRate * 1000000 / price
516 
517         uint sellWei = sell.amount.mul(uint(price)).mul(E12).roundedDiv(publishedRate);
518 
519         uint tradedWei;
520         uint tradedTokens;
521         if (sellWei <= buy.amount) {
522             tradedWei = sellWei;
523             tradedTokens = sell.amount;
524         } else {
525             tradedWei = buy.amount;
526             tradedTokens = buy.amount.mul(publishedRate).roundedDiv(uint(price).mul(E12));
527         }
528 
529         buy.amount = buy.amount.sub(tradedWei);
530         if (buy.amount == 0) {
531             _removeBuyOrder(buy);
532         }
533 
534         sell.amount = sell.amount.sub(tradedTokens);
535         if (sell.amount == 0) {
536             _removeSellOrder(sell);
537         }
538 
539         augmintToken.transferWithNarrative(buy.maker, tradedTokens, "Buy token order fill");
540         sell.maker.transfer(tradedWei);
541 
542         emit OrderFill(buy.maker, sell.maker, buyTokenId,
543             sellTokenId, publishedRate, price, tradedWei, tradedTokens);
544 
545         return true;
546     }
547 
548     function _placeSellTokenOrder(address maker, uint32 price, uint tokenAmount)
549     private returns (uint64 orderId) {
550         require(price > 0, "price must be > 0");
551         require(tokenAmount > 0, "tokenAmount must be > 0");
552 
553         orderId = ++orderCount;
554         sellTokenOrders[orderId] = Order(uint64(activeSellOrders.length), maker, price, tokenAmount);
555         activeSellOrders.push(orderId);
556 
557         emit NewOrder(orderId, maker, price, tokenAmount, 0);
558     }
559 
560     function _removeBuyOrder(Order storage order) private {
561         uint lastIndex = activeBuyOrders.length - 1;
562         if (order.index < lastIndex) {
563             uint64 movedOrderId = activeBuyOrders[lastIndex];
564             activeBuyOrders[order.index] = movedOrderId;
565             buyTokenOrders[movedOrderId].index = order.index;
566         }
567         activeBuyOrders.length--;
568     }
569 
570     function _removeSellOrder(Order storage order) private {
571         uint lastIndex = activeSellOrders.length - 1;
572         if (order.index < lastIndex) {
573             uint64 movedOrderId = activeSellOrders[lastIndex];
574             activeSellOrders[order.index] = movedOrderId;
575             sellTokenOrders[movedOrderId].index = order.index;
576         }
577         activeSellOrders.length--;
578     }
579 }