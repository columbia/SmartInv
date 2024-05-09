1 pragma solidity ^0.4.25;
2 
3 contract Token {
4     function transfer(address _to, uint256 _value) public returns (bool success);
5     function approve(address _spender, uint256 _value) public returns (bool success);
6     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
7 }
8 
9 contract NescrowExchangeService {
10 
11     address owner = msg.sender;
12 
13     uint256 public feeRateLimit = 200;//100/200 = 0.5% max fee
14     uint256 public takerFeeRate = 0;
15     uint256 public makerFeeRate = 0;
16     address public feeAddress;
17 
18     mapping (address => bool) public admins;
19     mapping (bytes32 => uint256) public orderFills;
20     mapping (bytes32 => uint256) public orderPaymentFills;
21     mapping (bytes32 => bool) public withdrawn;
22     mapping (bytes32 => bool) public transfers;
23     mapping (address => mapping (address => uint256)) public balances;
24     mapping (address => uint256) public tradesLocked;
25     mapping (address => uint256) public disableFees;
26     mapping (address => uint256) public tokenDecimals;
27     mapping (address => bool) public tokenRegistered;
28 
29     struct EIP712Domain {
30         string  name;
31         string  version;
32         uint256 chainId;
33         address verifyingContract;
34     }
35 
36     event OrderPayment(address indexed user, address spendToken, uint256 spendAmount, address indexed merchant, address merchantReceiveToken, uint256 merchantReceiveAmount);
37     event TradesLock(address user);
38     event TradesUnlock(address user);
39 
40     modifier onlyOwner {
41         assert(msg.sender == owner);
42         _;
43     }
44 
45     modifier onlyAdmin {
46         require(msg.sender == owner || admins[msg.sender]);
47         _;
48     }
49 
50     bytes32 constant EIP712DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
51     bytes32 constant ORDER_TYPEHASH = keccak256("Order(address fromToken,uint256 fromAmount,address toToken,uint256 toAmount,uint256 autoWithdraw,uint256 expires,uint256 nonce)");
52     bytes32 constant ORDER_WITH_TIPS_TYPEHASH = keccak256("OrderWithTips(address fromToken,uint256 fromAmount,address toToken,uint256 toAmount,uint256 autoWithdraw,uint256 expires,uint256 nonce,uint256 makerTips,uint256 takerTips)");
53     bytes32 constant ORDER_PAYMENT_TYPEHASH = keccak256("OrderPayment(address spendToken,uint256 spendAmount,address merchantReceiveToken,uint256 merchantReceiveAmount,address merchant,uint256 expires,uint256 nonce)");
54     bytes32 constant WITHDRAWAL_TYPEHASH = keccak256("Withdrawal(address withdrawToken,uint256 amount,uint256 nonce)");
55     bytes32 constant TIPS_TYPEHASH = keccak256("Tips(address tipsToken,uint256 amount,uint256 nonce)");
56     bytes32 constant TRANSFER_TYPEHASH = keccak256("Transfer(address transferToken,address to,uint256 amount,uint256 nonce)");
57     bytes32 DOMAIN_SEPARATOR;
58 
59     function domainHash(EIP712Domain eip712Domain) internal pure returns (bytes32) {
60         return keccak256(abi.encode(
61                 EIP712DOMAIN_TYPEHASH,
62                 keccak256(bytes(eip712Domain.name)),
63                 keccak256(bytes(eip712Domain.version)),
64                 eip712Domain.chainId,
65                 eip712Domain.verifyingContract
66             ));
67     }
68 
69     constructor() public {
70         DOMAIN_SEPARATOR = domainHash(EIP712Domain({
71             name: "Nescrow Exchange",
72             version: '2',
73             chainId: 1,
74             verifyingContract: this
75             }));
76 
77         tokenRegistered[0x0] = true;
78         tokenDecimals[0x0] = 18;
79     }
80 
81     function setOwner(address newOwner) external onlyOwner {
82         owner = newOwner;
83     }
84 
85     function getOwner() public view returns (address out) {
86         return owner;
87     }
88 
89     function setAdmin(address admin, bool isAdmin) external onlyOwner {
90         admins[admin] = isAdmin;
91     }
92 
93     function deposit() external payable {
94         uint amount = safeDiv(msg.value, 10**10);//wei to 8 decimals
95         require(amount > 0);
96         increaseBalance(msg.sender, address(0), amount);
97     }
98 
99     function depositToken(address token, uint256 amount) external {
100         require(amount > 0);
101         require(token != address(0) && tokenRegistered[token]);
102         require(safeTransferFrom(token, msg.sender, this, toTokenAmount(token, amount)));
103         increaseBalance(msg.sender, token, amount);
104     }
105 
106     function depositTokenByAdmin(address user, address token, uint256 amount)
107     external onlyAdmin {
108         require(amount > 0);
109         require(token != address(0) && tokenRegistered[token]);
110         require(safeTransferFrom(token, user, this, toTokenAmount(token, amount)));
111         increaseBalance(user, token, amount);
112     }
113 
114     function sendTips() external payable {
115         uint amount = safeDiv(msg.value, 10**10);//wei to 8 decimals
116         require(amount > 0);
117         increaseBalance(feeAddress, address(0), amount);
118     }
119 
120     function transferTips(address token, uint256 amount, address fromUser, uint nonce, uint8 v, bytes32 r, bytes32 s)
121     external onlyAdmin {
122 
123         require(amount > 0);
124 
125         bytes32 hash = keccak256(abi.encode(TIPS_TYPEHASH, token, amount, nonce));
126         require(ecrecover(keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, hash)), v, r, s) == fromUser);
127 
128         require(!transfers[hash]);
129         transfers[hash] = true;
130 
131         require(reduceBalance(fromUser, token, amount));
132         increaseBalance(feeAddress, token, amount);
133     }
134 
135     function transfer(address token, uint256 amount, address fromUser, address toUser, uint nonce, uint8 v, bytes32 r, bytes32 s)
136     external onlyAdmin {
137 
138         require(amount > 0);
139 
140         bytes32 hash = keccak256(abi.encode(TRANSFER_TYPEHASH, token, toUser, amount, nonce));
141         require(ecrecover(keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, hash)), v, r, s) == fromUser);
142         transfers[hash] = true;
143 
144         require(reduceBalance(fromUser, token, amount));
145         increaseBalance(toUser, token, amount);
146     }
147 
148     function withdrawByAdmin(address token, uint256 amount, address user, uint nonce, uint8 v, bytes32 r, bytes32 s)
149     external onlyAdmin {
150 
151         require(amount > 0);
152         bytes32 hash = keccak256(abi.encode(WITHDRAWAL_TYPEHASH, token, amount, nonce));
153         require(ecrecover(keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, hash)), v, r, s) == user);
154 
155         require(!withdrawn[hash]);
156         withdrawn[hash] = true;
157 
158         require(reduceBalance(user, token, amount));
159         require(sendToUser(user, token, amount));
160     }
161 
162     function withdraw(address token, uint256 amount) external {
163 
164         require(amount > 0);
165         require(tradesLocked[msg.sender] > block.number);
166         require(reduceBalance(msg.sender, token, amount));
167 
168         require(sendToUser(msg.sender, token, amount));
169     }
170 
171     function reduceBalance(address user, address token, uint256 amount) private returns(bool) {
172         if (balances[token][user] < amount) return false;
173         balances[token][user] = safeSub(balances[token][user], amount);
174         return true;
175     }
176 
177     function increaseBalanceOrWithdraw(address user, address token, uint256 amount, uint256 _withdraw) private returns(bool) {
178         if (_withdraw == 1) {
179             return sendToUser(user, token, amount);
180         } else {
181             return increaseBalance(user, token, amount);
182         }
183     }
184 
185     function increaseBalance(address user, address token, uint256 amount) private returns(bool) {
186         balances[token][user] = safeAdd(balances[token][user], amount);
187         return true;
188     }
189 
190     function sendToUser(address user, address token, uint256 amount) private returns(bool) {
191         if (token == address(0)) {
192             return user.send(toTokenAmount(address(0), amount));
193         } else {
194             return safeTransfer(token, user, toTokenAmount(token, amount));
195         }
196     }
197 
198     function toTokenAmount(address token, uint256 amount) private view returns (uint256) {
199 
200         require(tokenRegistered[token]);
201         uint256 decimals = token == address(0)
202             ? 18
203             : tokenDecimals[token];
204 
205         if (decimals == 8) {
206             return amount;
207         }
208 
209         if (decimals > 8) {
210             return safeMul(amount, 10**(decimals - 8));
211         } else {
212             return safeDiv(amount, 10**(8 - decimals));
213         }
214     }
215 
216     function setTakerFeeRate(uint256 feeRate) external onlyAdmin {
217         require(feeRate == 0 || feeRate >= feeRateLimit);
218         takerFeeRate = feeRate;
219     }
220 
221     function setMakerFeeRate(uint256 feeRate) external onlyAdmin {
222         require(feeRate == 0 || feeRate >= feeRateLimit);
223         makerFeeRate = feeRate;
224     }
225 
226     function setFeeAddress(address _feeAddress) external onlyAdmin {
227         require(_feeAddress != address(0));
228         feeAddress = _feeAddress;
229     }
230 
231     function disableFeesForUser(address user, uint256 timestamp) external onlyAdmin {
232         require(timestamp > block.timestamp);
233         disableFees[user] = timestamp;
234     }
235 
236     function registerToken(address token, uint256 decimals) external onlyAdmin {
237         require(!tokenRegistered[token]);
238         tokenRegistered[token] = true;
239         tokenDecimals[token] = decimals;
240     }
241 
242     function tradesLock(address user) external {
243         require(user == msg.sender);
244         tradesLocked[user] = block.number + 20000;
245         emit TradesLock(user);
246     }
247 
248     function tradesUnlock(address user) external {
249         require(user == msg.sender);
250         tradesLocked[user] = 0;
251         emit TradesUnlock(user);
252     }
253 
254     function isUserMakerFeeEnabled(address user, uint256 disableFee) private view returns(bool) {
255         return disableFee == 0 && makerFeeRate > 0 && disableFees[user] < block.timestamp;
256     }
257 
258     function isUserTakerFeeEnabled(address user, uint256 disableFee) private view returns(bool) {
259         return disableFee == 0 && takerFeeRate > 0 && disableFees[user] < block.timestamp;
260     }
261 
262     function calculateRate(uint256 offerAmount, uint256 wantAmount) private pure returns(uint256) {
263         return safeDiv(safeMul(10**8, wantAmount), offerAmount);
264     }
265 
266     function trade(
267         uint256[10] amounts,
268         address[4] addresses,
269         uint256[6] values,
270         bytes32[4] rs
271     ) external onlyAdmin {
272         /**
273             amounts: 0-offerAmount, 1-wantAmount, 2-orderExpires, 3-orderNonce, 4-offerAmount2, 5-wantAmount2, 6-orderExpires2, 7-orderNonce2, 8-offerAmountToFill, 9-wantAmountToFill
274             addresses: 0-maker, 1-taker, 2-offerToken, 3-wantToken
275             values: 2-withdrawMaker, 3-withdrawTaker, 4-disableMakerFee, 5-disableTakerFee
276         */
277         require(tradesLocked[addresses[0]] < block.number);
278         require(block.timestamp <= amounts[2]);
279         bytes32 orderHash = keccak256(abi.encode(ORDER_TYPEHASH, addresses[2], amounts[0], addresses[3], amounts[1], values[2], amounts[2], amounts[3]));
280         require(ecrecover(keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, orderHash)), uint8(values[0]), rs[0], rs[1]) == addresses[0]);
281         orderFills[orderHash] = safeAdd(orderFills[orderHash], amounts[8]);
282         require(orderFills[orderHash] <= amounts[0]);
283 
284         require(tradesLocked[addresses[1]] < block.number);
285         require(block.timestamp <= amounts[6]);
286         bytes32 orderHash2 = keccak256(abi.encode(ORDER_TYPEHASH, addresses[3], amounts[4], addresses[2], amounts[5], values[3], amounts[6], amounts[7]));
287         require(ecrecover(keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, orderHash2)), uint8(values[1]), rs[2], rs[3]) == addresses[1]);
288 
289         uint256 makerRate = calculateRate(amounts[0], amounts[1]);
290         uint256 takerRate = calculateRate(amounts[5], amounts[4]);
291         require(makerRate <= takerRate);
292         require(makerRate == calculateRate(amounts[8], amounts[9]));
293 
294         orderFills[orderHash2] = safeAdd(orderFills[orderHash2], amounts[9]);
295         require(orderFills[orderHash2] <= amounts[4]);
296 
297         require(reduceBalance(addresses[0], addresses[2], amounts[8]));
298         require(reduceBalance(addresses[1], addresses[3], amounts[9]));
299 
300         if (isUserMakerFeeEnabled(addresses[0], values[4])) {
301             require(increaseBalanceOrWithdraw(addresses[0], addresses[3], safeSub(amounts[9], safeDiv(amounts[9], makerFeeRate)), values[2]));
302             increaseBalance(feeAddress, addresses[3], safeDiv(amounts[9], makerFeeRate));
303         } else {
304             require(increaseBalanceOrWithdraw(addresses[0], addresses[3], amounts[9], values[2]));
305         }
306 
307         if (isUserTakerFeeEnabled(addresses[1], values[5])) {
308             require(increaseBalanceOrWithdraw(addresses[1], addresses[2], safeSub(amounts[8], safeDiv(amounts[8], takerFeeRate)), values[3]));
309             increaseBalance(feeAddress, addresses[2], safeDiv(amounts[8], takerFeeRate));
310         } else {
311             require(increaseBalanceOrWithdraw(addresses[1], addresses[2], amounts[8], values[3]));
312         }
313     }
314 
315     function exchangeAndPay(
316         uint256[10] amounts,
317         address[5] addresses,
318         uint256[4] values,
319         bytes32[4] rs
320     ) external onlyAdmin {
321         /**
322             amounts: 0-merchantReceiveAmount, 1-spendAmount, 2-orderExpires, 3-orderNonce, 4-offerAmount2, 5-wantAmount2, 6-orderExpires2, 7-orderNonce2, 8-offerAmountToFill, 9-wantAmountToFill
323             addresses: 0-exchanger, 1-user, 2-merchantReceiveToken, 3-spendToken, 4-merchant
324             values: 2-withdrawExchanger, 3-withdrawMerchant
325         */
326         require(tradesLocked[addresses[0]] < block.number);
327         require(block.timestamp <= amounts[2]);
328         bytes32 orderHash = keccak256(abi.encode(ORDER_TYPEHASH, addresses[2], amounts[0], addresses[3], amounts[1], values[3], amounts[2], amounts[3]));
329         require(ecrecover(keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, orderHash)), uint8(values[0]), rs[0], rs[1]) == addresses[0]);
330         orderFills[orderHash] = safeAdd(orderFills[orderHash], amounts[8]);
331         require(orderFills[orderHash] <= amounts[0]);
332 
333         require(tradesLocked[addresses[1]] < block.number);
334         require(block.timestamp <= amounts[6]);
335         bytes32 orderHash2 = keccak256(abi.encode(ORDER_PAYMENT_TYPEHASH, addresses[3], amounts[4], addresses[2], amounts[5], addresses[4], amounts[6], amounts[7]));
336         require(ecrecover(keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, orderHash2)), uint8(values[1]), rs[2], rs[3]) == addresses[1]);
337 
338         uint256 makerRate = calculateRate(amounts[0], amounts[1]);
339         uint256 takerRate = calculateRate(amounts[5], amounts[4]);
340         require(makerRate <= takerRate);
341         require(makerRate == calculateRate(amounts[8], amounts[9]));
342 
343         orderPaymentFills[orderHash2] = safeAdd(orderPaymentFills[orderHash2], amounts[9]);
344         require(orderPaymentFills[orderHash2] <= amounts[4]);
345 
346         require(reduceBalance(addresses[0], addresses[2], amounts[8]));
347         require(reduceBalance(addresses[1], addresses[3], amounts[9]));
348 
349         require(increaseBalanceOrWithdraw(addresses[0], addresses[3], amounts[9], values[2]));
350         require(increaseBalanceOrWithdraw(addresses[4], addresses[2], amounts[8], values[3]));
351         //    event OrderPayment(address indexed user, address spendToken, uint256 spendAmount, address indexed merchant, address merchantReceiveToken, uint256 merchantReceiveAmount);
352         emit OrderPayment(addresses[1], addresses[1], amounts[9], addresses[4], addresses[2], amounts[2]);
353     }
354 
355     function tradeWithTips(
356         uint256[10] amounts,
357         address[4] addresses,
358         uint256[10] values,
359         bytes32[4] rs
360     ) external onlyAdmin {
361         /**
362             amounts: 0-offerAmount, 1-wantAmount, 2-orderExpires, 3-orderNonce, 4-offerAmount2, 5-wantAmount2, 6-orderExpires2, 7-orderNonce2, 8-offerAmountToFill, 9-wantAmountToFill
363             addresses: 0-maker, 1-taker, 2-offerToken, 3-wantToken
364             values: 2-withdrawMaker, 3-withdrawTaker, 4-orderMakerTips, 5-orderTakerTips, 6-orderMakerTips2, 7-orderTakerTips2, 8-disableMakerFee, 9-disableTakerFee
365         */
366         require(tradesLocked[addresses[0]] < block.number);
367         require(block.timestamp <= amounts[2]);
368         bytes32 orderHash = values[4] > 0 || values[5] > 0
369             ? keccak256(abi.encode(ORDER_WITH_TIPS_TYPEHASH, addresses[2], amounts[0], addresses[3], amounts[1], values[2], amounts[2], amounts[3], values[4], values[5]))
370             : keccak256(abi.encode(ORDER_TYPEHASH, addresses[2], amounts[0], addresses[3], amounts[1], values[2], amounts[2], amounts[3]));
371         require(ecrecover(keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, orderHash)), uint8(values[0]), rs[0], rs[1]) == addresses[0]);
372         orderFills[orderHash] = safeAdd(orderFills[orderHash], amounts[8]);
373         require(orderFills[orderHash] <= amounts[0]);
374 
375         require(tradesLocked[addresses[1]] < block.number);
376         require(block.timestamp <= amounts[6]);
377         bytes32 orderHash2 = values[6] > 0 || values[7] > 0
378             ? keccak256(abi.encode(ORDER_WITH_TIPS_TYPEHASH, addresses[3], amounts[4], addresses[2], amounts[5], values[3], amounts[6], amounts[7], values[6], values[7]))
379             : keccak256(abi.encode(ORDER_TYPEHASH, addresses[3], amounts[4], addresses[2], amounts[5], values[3], amounts[6], amounts[7]));
380         require(ecrecover(keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, orderHash2)), uint8(values[1]), rs[2], rs[3]) == addresses[1]);
381 
382         uint256 makerRate = calculateRate(amounts[0], amounts[1]);
383         uint256 takerRate = calculateRate(amounts[5], amounts[4]);
384         require(makerRate <= takerRate);
385         require(makerRate == calculateRate(amounts[8], amounts[9]));
386 
387         orderFills[orderHash2] = safeAdd(orderFills[orderHash2], amounts[9]);
388         require(orderFills[orderHash2] <= amounts[4]);
389 
390         require(reduceBalance(addresses[0], addresses[2], amounts[8]));
391         require(reduceBalance(addresses[1], addresses[3], amounts[9]));
392 
393         if (values[4] > 0 && !isUserMakerFeeEnabled(addresses[0], values[8])) {
394             increaseBalanceOrWithdraw(addresses[0], addresses[3], safeSub(amounts[9], safeDiv(amounts[9], values[4])), values[2]);
395             increaseBalance(feeAddress, addresses[3], safeDiv(amounts[9], values[4]));
396         } else if (values[4] == 0 && isUserMakerFeeEnabled(addresses[0], values[8])) {
397             increaseBalanceOrWithdraw(addresses[0], addresses[3], safeSub(amounts[9], safeDiv(amounts[9], makerFeeRate)), values[2]);
398             increaseBalance(feeAddress, addresses[3], safeDiv(amounts[9], makerFeeRate));
399         } else if (values[4] > 0 && isUserMakerFeeEnabled(addresses[0], values[8])) {
400             increaseBalanceOrWithdraw(addresses[0], addresses[3], safeSub(amounts[9], safeAdd(safeDiv(amounts[9], values[4]), safeDiv(amounts[9], makerFeeRate))), values[2]);
401             increaseBalance(feeAddress, addresses[3], safeAdd(safeDiv(amounts[9], values[4]), safeDiv(amounts[9], makerFeeRate)));
402         } else {
403             increaseBalanceOrWithdraw(addresses[0], addresses[3], amounts[9], values[2]);
404         }
405 
406         if (values[7] > 0 && !isUserTakerFeeEnabled(addresses[1], values[9])) {
407             increaseBalanceOrWithdraw(addresses[1], addresses[2], safeSub(amounts[8], safeDiv(amounts[8], values[7])), values[3]);
408             increaseBalance(feeAddress, addresses[2], safeDiv(amounts[8], values[7]));
409         } else if (values[7] == 0 && isUserTakerFeeEnabled(addresses[1], values[9])) {
410             increaseBalanceOrWithdraw(addresses[1], addresses[2], safeSub(amounts[8], safeDiv(amounts[8], takerFeeRate)), values[3]);
411             increaseBalance(feeAddress, addresses[2], safeDiv(amounts[8], takerFeeRate));
412         } else if (values[7] > 0 && isUserTakerFeeEnabled(addresses[1], values[9])) {
413             increaseBalanceOrWithdraw(addresses[1], addresses[2], safeSub(amounts[8], safeAdd(safeDiv(amounts[8], values[7]), safeDiv(amounts[8], takerFeeRate))), values[3]);
414             increaseBalance(feeAddress, addresses[2], safeAdd(safeDiv(amounts[8], values[7]), safeDiv(amounts[8], takerFeeRate)));
415         } else {
416             increaseBalanceOrWithdraw(addresses[1], addresses[2], amounts[8], values[3]);
417         }
418     }
419 
420     function() public payable {
421         revert();
422     }
423 
424     function safeMul(uint a, uint b) internal pure returns (uint) {
425         uint c = a * b;
426         assert(a == 0 || c / a == b);
427         return c;
428     }
429 
430     function safeSub(uint a, uint b) internal pure returns (uint) {
431         assert(b <= a);
432         return a - b;
433     }
434 
435     function safeAdd(uint a, uint b) internal pure returns (uint) {
436         uint c = a + b;
437         assert(c>=a && c>=b);
438         return c;
439     }
440 
441     function safeDiv(uint a, uint b) internal pure returns (uint) {
442         assert(b > 0);
443         uint c = a / b;
444         assert(a == b * c + a % b);
445         return c;
446     }
447 
448     function safeTransfer(
449         address token,
450         address to,
451         uint256 value)
452     private
453     returns (bool success)
454     {
455         // A transfer is successful when 'call' is successful and depending on the token:
456         // - No value is returned: we assume a revert when the transfer failed (i.e. 'call' returns false)
457         // - A single boolean is returned: this boolean needs to be true (non-zero)
458 
459         // bytes4(keccak256("transfer(address,uint256)")) = 0xa9059cbb
460         success = token.call(0xa9059cbb, to, value);
461         return checkReturnValue(success);
462     }
463 
464     function safeTransferFrom(
465         address token,
466         address from,
467         address to,
468         uint256 value)
469     private
470     returns (bool success)
471     {
472         // A transferFrom is successful when 'call' is successful and depending on the token:
473         // - No value is returned: we assume a revert when the transfer failed (i.e. 'call' returns false)
474         // - A single boolean is returned: this boolean needs to be true (non-zero)
475 
476         //bytes4(keccak256("transferFrom(address,address,uint256)")) = 0x23b872dd
477         success = token.call(0x23b872dd, from, to, value);
478         return checkReturnValue(success);
479     }
480 
481     function checkReturnValue(
482         bool success
483     )
484     private
485     pure
486     returns (bool)
487     {
488         // A transfer/transferFrom is successful when 'call' is successful and depending on the token:
489         // - No value is returned: we assume a revert when the transfer failed (i.e. 'call' returns false)
490         // - A single boolean is returned: this boolean needs to be true (non-zero)
491         if (success) {
492             assembly {
493                 switch returndatasize()
494                 // Non-standard ERC20: nothing is returned so if 'call' was successful we assume the transfer succeeded
495                 case 0 {
496                     success := 1
497                 }
498                 // Standard ERC20: a single boolean value is returned which needs to be true
499                 case 32 {
500                     returndatacopy(0, 0, 32)
501                     success := mload(0)
502                 }
503                 // None of the above: not successful
504                 default {
505                     success := 0
506                 }
507             }
508         }
509         return success;
510     }
511 }