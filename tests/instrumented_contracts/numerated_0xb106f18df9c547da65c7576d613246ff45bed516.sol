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
75         }));
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
101         require(safeTransferFrom(token, msg.sender, this, toTokenAmount(token, amount)));
102         increaseBalance(msg.sender, token, amount);
103     }
104 
105     function depositTokenByAdmin(address user, address token, uint256 amount)
106         external onlyAdmin {
107         require(amount > 0);
108         require(safeTransferFrom(token, user, this, toTokenAmount(token, amount)));
109         increaseBalance(user, token, amount);
110     }
111 
112     function sendTips() external payable {
113         uint amount = safeDiv(msg.value, 10**10);//wei to 8 decimals
114         require(amount > 0);
115         increaseBalance(feeAddress, address(0), amount);
116     }
117 
118     function transferTips(address token, uint256 amount, address fromUser, uint nonce, uint8 v, bytes32 r, bytes32 s)
119         external onlyAdmin {
120 
121         require(amount > 0);
122 
123         bytes32 hash = keccak256(abi.encode(TIPS_TYPEHASH, token, amount, nonce));
124         require(ecrecover(keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, hash)), v, r, s) == fromUser);
125 
126         require(!transfers[hash]);
127         transfers[hash] = true;
128 
129         require(reduceBalance(fromUser, token, amount));
130         increaseBalance(feeAddress, token, amount);
131     }
132 
133     function transfer(address token, uint256 amount, address fromUser, address toUser, uint nonce, uint8 v, bytes32 r, bytes32 s)
134         external onlyAdmin {
135 
136         require(amount > 0);
137 
138         bytes32 hash = keccak256(abi.encode(TRANSFER_TYPEHASH, token, toUser, amount, nonce));
139         require(ecrecover(keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, hash)), v, r, s) == fromUser);
140         transfers[hash] = true;
141 
142         require(reduceBalance(fromUser, token, amount));
143         increaseBalance(toUser, token, amount);
144     }
145 
146     function withdrawByAdmin(address token, uint256 amount, address user, uint nonce, uint8 v, bytes32 r, bytes32 s)
147         external onlyAdmin {
148 
149         require(amount > 0);
150         bytes32 hash = keccak256(abi.encode(WITHDRAWAL_TYPEHASH, token, amount, nonce));
151         require(ecrecover(keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, hash)), v, r, s) == user);
152 
153         require(!withdrawn[hash]);
154         withdrawn[hash] = true;
155 
156         require(reduceBalance(user, token, amount));
157         require(sendToUser(user, token, amount));
158     }
159 
160     function withdraw(address token, uint256 amount) external {
161 
162         require(amount > 0);
163         require(tradesLocked[msg.sender] > block.number);
164         require(reduceBalance(msg.sender, token, amount));
165 
166         require(sendToUser(msg.sender, token, amount));
167     }
168 
169     function reduceBalance(address user, address token, uint256 amount) private returns(bool) {
170         if (balances[token][user] < amount) return false;
171         balances[token][user] = safeSub(balances[token][user], amount);
172         return true;
173     }
174 
175     function increaseBalanceOrWithdraw(address user, address token, uint256 amount, uint256 _withdraw) private returns(bool) {
176         if (_withdraw == 1) {
177             return sendToUser(user, token, amount);
178         } else {
179             return increaseBalance(user, token, amount);
180         }
181     }
182 
183     function increaseBalance(address user, address token, uint256 amount) private returns(bool) {
184         balances[token][user] = safeAdd(balances[token][user], amount);
185         return true;
186     }
187 
188     function sendToUser(address user, address token, uint256 amount) private returns(bool) {
189         if (token == address(0)) {
190             return user.send(toTokenAmount(address(0), amount));
191         } else {
192             return safeTransfer(token, user, toTokenAmount(token, amount));
193         }
194     }
195 
196     function toTokenAmount(address token, uint256 amount) private view returns (uint256) {
197 
198         require(tokenRegistered[token]);
199         uint256 decimals = token == address(0)
200             ? 18
201             : tokenDecimals[token];
202 
203         if (decimals == 8) {
204             return amount;
205         }
206 
207         if (decimals > 8) {
208             return safeMul(amount, 10**(decimals - 8));
209         } else {
210             return safeDiv(amount, 10**(8 - decimals));
211         }
212     }
213 
214     function setTakerFeeRate(uint256 feeRate) external onlyAdmin {
215         require(feeRate == 0 || feeRate >= feeRateLimit);
216         takerFeeRate = feeRate;
217     }
218 
219     function setMakerFeeRate(uint256 feeRate) external onlyAdmin {
220         require(feeRate == 0 || feeRate >= feeRateLimit);
221         makerFeeRate = feeRate;
222     }
223 
224     function setFeeAddress(address _feeAddress) external onlyAdmin {
225         require(_feeAddress != address(0));
226         feeAddress = _feeAddress;
227     }
228 
229     function disableFeesForUser(address user, uint256 timestamp) external onlyAdmin {
230         require(timestamp > block.timestamp);
231         disableFees[user] = timestamp;
232     }
233 
234     function registerToken(address token, uint256 decimals) external onlyAdmin {
235         require(!tokenRegistered[token]);
236         tokenRegistered[token] = true;
237         tokenDecimals[token] = decimals;
238     }
239 
240     function tradesLock(address user) external {
241         require(user == msg.sender);
242         tradesLocked[user] = block.number + 20000;
243         emit TradesLock(user);
244     }
245 
246     function tradesUnlock(address user) external {
247         require(user == msg.sender);
248         tradesLocked[user] = 0;
249         emit TradesUnlock(user);
250     }
251 
252     function isUserMakerFeeEnabled(address user, uint256 disableFee) private view returns(bool) {
253         return disableFee == 0 && makerFeeRate > 0 && disableFees[user] < block.timestamp;
254     }
255 
256     function isUserTakerFeeEnabled(address user, uint256 disableFee) private view returns(bool) {
257         return disableFee == 0 && takerFeeRate > 0 && disableFees[user] < block.timestamp;
258     }
259 
260     function calculateRate(uint256 offerAmount, uint256 wantAmount) private pure returns(uint256) {
261         return safeDiv(safeMul(10**8, wantAmount), offerAmount);
262     }
263 
264     function trade(
265         uint256[10] amounts,
266         address[4] addresses,
267         uint256[6] values,
268         bytes32[4] rs
269     ) external onlyAdmin {
270         /**
271             amounts: 0-offerAmount, 1-wantAmount, 2-orderExpires, 3-orderNonce, 4-offerAmount2, 5-wantAmount2, 6-orderExpires2, 7-orderNonce2, 8-offerAmountToFill, 9-wantAmountToFill
272             addresses: 0-maker, 1-taker, 2-offerToken, 3-wantToken
273             values: 2-withdrawMaker, 3-withdrawTaker, 4-disableMakerFee, 5-disableTakerFee
274         */
275         require(tradesLocked[addresses[0]] < block.number);
276         require(block.timestamp <= amounts[2]);
277         bytes32 orderHash = keccak256(abi.encode(ORDER_TYPEHASH, addresses[2], amounts[0], addresses[3], amounts[1], values[2], amounts[2], amounts[3]));
278         require(ecrecover(keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, orderHash)), uint8(values[0]), rs[0], rs[1]) == addresses[0]);
279         orderFills[orderHash] = safeAdd(orderFills[orderHash], amounts[8]);
280         require(orderFills[orderHash] <= amounts[0]);
281 
282         require(tradesLocked[addresses[1]] < block.number);
283         require(block.timestamp <= amounts[6]);
284         bytes32 orderHash2 = keccak256(abi.encode(ORDER_TYPEHASH, addresses[3], amounts[4], addresses[2], amounts[5], values[3], amounts[6], amounts[7]));
285         require(ecrecover(keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, orderHash2)), uint8(values[1]), rs[2], rs[3]) == addresses[1]);
286 
287         uint256 makerRate = calculateRate(amounts[0], amounts[1]);
288         uint256 takerRate = calculateRate(amounts[5], amounts[4]);
289         require(makerRate <= takerRate);
290         require(makerRate == calculateRate(amounts[8], amounts[9]));
291 
292         orderFills[orderHash2] = safeAdd(orderFills[orderHash2], amounts[9]);
293         require(orderFills[orderHash2] <= amounts[4]);
294 
295         require(reduceBalance(addresses[0], addresses[2], amounts[8]));
296         require(reduceBalance(addresses[1], addresses[3], amounts[9]));
297 
298         if (isUserMakerFeeEnabled(addresses[0], values[4])) {
299             require(increaseBalanceOrWithdraw(addresses[0], addresses[3], safeSub(amounts[9], safeDiv(amounts[9], makerFeeRate)), values[2]));
300             increaseBalance(feeAddress, addresses[3], safeDiv(amounts[9], makerFeeRate));
301         } else {
302             require(increaseBalanceOrWithdraw(addresses[0], addresses[3], amounts[9], values[2]));
303         }
304 
305         if (isUserTakerFeeEnabled(addresses[1], values[5])) {
306             require(increaseBalanceOrWithdraw(addresses[1], addresses[2], safeSub(amounts[8], safeDiv(amounts[8], takerFeeRate)), values[3]));
307             increaseBalance(feeAddress, addresses[2], safeDiv(amounts[8], takerFeeRate));
308         } else {
309             require(increaseBalanceOrWithdraw(addresses[1], addresses[2], amounts[8], values[3]));
310         }
311     }
312 
313     function exchangeAndPay(
314         uint256[10] amounts,
315         address[5] addresses,
316         uint256[4] values,
317         bytes32[4] rs
318     ) external onlyAdmin {
319         /**
320             amounts: 0-merchantReceiveAmount, 1-spendAmount, 2-orderExpires, 3-orderNonce, 4-offerAmount2, 5-wantAmount2, 6-orderExpires2, 7-orderNonce2, 8-offerAmountToFill, 9-wantAmountToFill
321             addresses: 0-exchanger, 1-user, 2-merchantReceiveToken, 3-spendToken, 4-merchant
322             values: 2-withdrawExchanger, 3-withdrawMerchant
323         */
324         require(tradesLocked[addresses[0]] < block.number);
325         require(block.timestamp <= amounts[2]);
326         bytes32 orderHash = keccak256(abi.encode(ORDER_TYPEHASH, addresses[2], amounts[0], addresses[3], amounts[1], values[3], amounts[2], amounts[3]));
327         require(ecrecover(keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, orderHash)), uint8(values[0]), rs[0], rs[1]) == addresses[0]);
328         orderFills[orderHash] = safeAdd(orderFills[orderHash], amounts[8]);
329         require(orderFills[orderHash] <= amounts[0]);
330 
331         require(tradesLocked[addresses[1]] < block.number);
332         require(block.timestamp <= amounts[6]);
333         bytes32 orderHash2 = keccak256(abi.encode(ORDER_PAYMENT_TYPEHASH, addresses[3], amounts[4], addresses[2], amounts[5], addresses[4], amounts[6], amounts[7]));
334         require(ecrecover(keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, orderHash2)), uint8(values[1]), rs[2], rs[3]) == addresses[1]);
335 
336         uint256 makerRate = calculateRate(amounts[0], amounts[1]);
337         uint256 takerRate = calculateRate(amounts[5], amounts[4]);
338         require(makerRate <= takerRate);
339         require(makerRate == calculateRate(amounts[8], amounts[9]));
340 
341         orderPaymentFills[orderHash2] = safeAdd(orderPaymentFills[orderHash2], amounts[9]);
342         require(orderPaymentFills[orderHash2] <= amounts[4]);
343 
344         require(reduceBalance(addresses[0], addresses[2], amounts[8]));
345         require(reduceBalance(addresses[1], addresses[3], amounts[9]));
346 
347         require(increaseBalanceOrWithdraw(addresses[0], addresses[3], amounts[9], values[2]));
348         require(increaseBalanceOrWithdraw(addresses[4], addresses[2], amounts[8], values[3]));
349         //    event OrderPayment(address indexed user, address spendToken, uint256 spendAmount, address indexed merchant, address merchantReceiveToken, uint256 merchantReceiveAmount);
350         emit OrderPayment(addresses[1], addresses[1], amounts[9], addresses[4], addresses[2], amounts[2]);
351     }
352 
353     function tradeWithTips(
354         uint256[10] amounts,
355         address[4] addresses,
356         uint256[10] values,
357         bytes32[4] rs
358     ) external onlyAdmin {
359         /**
360             amounts: 0-offerAmount, 1-wantAmount, 2-orderExpires, 3-orderNonce, 4-offerAmount2, 5-wantAmount2, 6-orderExpires2, 7-orderNonce2, 8-offerAmountToFill, 9-wantAmountToFill
361             addresses: 0-maker, 1-taker, 2-offerToken, 3-wantToken
362             values: 2-withdrawMaker, 3-withdrawTaker, 4-orderMakerTips, 5-orderTakerTips, 6-orderMakerTips2, 7-orderTakerTips2, 8-disableMakerFee, 9-disableTakerFee
363         */
364         require(tradesLocked[addresses[0]] < block.number);
365         require(block.timestamp <= amounts[2]);
366         bytes32 orderHash = values[4] > 0 || values[5] > 0
367             ? keccak256(abi.encode(ORDER_WITH_TIPS_TYPEHASH, addresses[2], amounts[0], addresses[3], amounts[1], values[2], amounts[2], amounts[3], values[4], values[5]))
368             : keccak256(abi.encode(ORDER_TYPEHASH, addresses[2], amounts[0], addresses[3], amounts[1], values[2], amounts[2], amounts[3]));
369         require(ecrecover(keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, orderHash)), uint8(values[0]), rs[0], rs[1]) == addresses[0]);
370         orderFills[orderHash] = safeAdd(orderFills[orderHash], amounts[8]);
371         require(orderFills[orderHash] <= amounts[0]);
372 
373         require(tradesLocked[addresses[1]] < block.number);
374         require(block.timestamp <= amounts[6]);
375         bytes32 orderHash2 = values[6] > 0 || values[7] > 0
376             ? keccak256(abi.encode(ORDER_WITH_TIPS_TYPEHASH, addresses[3], amounts[4], addresses[2], amounts[5], values[3], amounts[6], amounts[7], values[6], values[7]))
377             : keccak256(abi.encode(ORDER_TYPEHASH, addresses[3], amounts[4], addresses[2], amounts[5], values[3], amounts[6], amounts[7]));
378         require(ecrecover(keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, orderHash2)), uint8(values[1]), rs[2], rs[3]) == addresses[1]);
379 
380         uint256 makerRate = calculateRate(amounts[0], amounts[1]);
381         uint256 takerRate = calculateRate(amounts[5], amounts[4]);
382         require(makerRate <= takerRate);
383         require(makerRate == calculateRate(amounts[8], amounts[9]));
384 
385         orderFills[orderHash2] = safeAdd(orderFills[orderHash2], amounts[9]);
386         require(orderFills[orderHash2] <= amounts[4]);
387 
388         require(reduceBalance(addresses[0], addresses[2], amounts[8]));
389         require(reduceBalance(addresses[1], addresses[3], amounts[9]));
390 
391         if (values[4] > 0 && !isUserMakerFeeEnabled(addresses[0], values[8])) {
392             increaseBalanceOrWithdraw(addresses[0], addresses[3], safeSub(amounts[9], safeDiv(amounts[9], values[4])), values[2]);
393             increaseBalance(feeAddress, addresses[3], safeDiv(amounts[9], values[4]));
394         } else if (values[4] == 0 && isUserMakerFeeEnabled(addresses[0], values[8])) {
395             increaseBalanceOrWithdraw(addresses[0], addresses[3], safeSub(amounts[9], safeDiv(amounts[9], makerFeeRate)), values[2]);
396             increaseBalance(feeAddress, addresses[3], safeDiv(amounts[9], makerFeeRate));
397         } else if (values[4] > 0 && isUserMakerFeeEnabled(addresses[0], values[8])) {
398             increaseBalanceOrWithdraw(addresses[0], addresses[3], safeSub(amounts[9], safeAdd(safeDiv(amounts[9], values[4]), safeDiv(amounts[9], makerFeeRate))), values[2]);
399             increaseBalance(feeAddress, addresses[3], safeAdd(safeDiv(amounts[9], values[4]), safeDiv(amounts[9], makerFeeRate)));
400         } else {
401             increaseBalanceOrWithdraw(addresses[0], addresses[3], amounts[9], values[2]);
402         }
403 
404         if (values[7] > 0 && !isUserTakerFeeEnabled(addresses[1], values[9])) {
405             increaseBalanceOrWithdraw(addresses[1], addresses[2], safeSub(amounts[8], safeDiv(amounts[8], values[7])), values[3]);
406             increaseBalance(feeAddress, addresses[2], safeDiv(amounts[8], values[7]));
407         } else if (values[7] == 0 && isUserTakerFeeEnabled(addresses[1], values[9])) {
408             increaseBalanceOrWithdraw(addresses[1], addresses[2], safeSub(amounts[8], safeDiv(amounts[8], takerFeeRate)), values[3]);
409             increaseBalance(feeAddress, addresses[2], safeDiv(amounts[8], takerFeeRate));
410         } else if (values[7] > 0 && isUserTakerFeeEnabled(addresses[1], values[9])) {
411             increaseBalanceOrWithdraw(addresses[1], addresses[2], safeSub(amounts[8], safeAdd(safeDiv(amounts[8], values[7]), safeDiv(amounts[8], takerFeeRate))), values[3]);
412             increaseBalance(feeAddress, addresses[2], safeAdd(safeDiv(amounts[8], values[7]), safeDiv(amounts[8], takerFeeRate)));
413         } else {
414             increaseBalanceOrWithdraw(addresses[1], addresses[2], amounts[8], values[3]);
415         }
416     }
417 
418     function() public payable {
419         revert();
420     }
421 
422     function safeMul(uint a, uint b) internal pure returns (uint) {
423         uint c = a * b;
424         assert(a == 0 || c / a == b);
425         return c;
426     }
427 
428     function safeSub(uint a, uint b) internal pure returns (uint) {
429         assert(b <= a);
430         return a - b;
431     }
432 
433     function safeAdd(uint a, uint b) internal pure returns (uint) {
434         uint c = a + b;
435         assert(c>=a && c>=b);
436         return c;
437     }
438 
439     function safeDiv(uint a, uint b) internal pure returns (uint) {
440         assert(b > 0);
441         uint c = a / b;
442         assert(a == b * c + a % b);
443         return c;
444     }
445 
446     function safeTransfer(
447         address token,
448         address to,
449         uint256 value)
450     private
451     returns (bool success)
452     {
453         // A transfer is successful when 'call' is successful and depending on the token:
454         // - No value is returned: we assume a revert when the transfer failed (i.e. 'call' returns false)
455         // - A single boolean is returned: this boolean needs to be true (non-zero)
456 
457         // bytes4(keccak256("transfer(address,uint256)")) = 0xa9059cbb
458         success = token.call(0xa9059cbb, to, value);
459         return checkReturnValue(success);
460     }
461 
462     function safeTransferFrom(
463         address token,
464         address from,
465         address to,
466         uint256 value)
467     private
468     returns (bool success)
469     {
470         // A transferFrom is successful when 'call' is successful and depending on the token:
471         // - No value is returned: we assume a revert when the transfer failed (i.e. 'call' returns false)
472         // - A single boolean is returned: this boolean needs to be true (non-zero)
473 
474 //         bytes4(keccak256("transferFrom(address,address,uint256)")) = 0x23b872dd
475         success = token.call(0x23b872dd, from, to, value);
476         return checkReturnValue(success);
477     }
478 
479     function checkReturnValue(
480         bool success
481     )
482     private
483     pure
484     returns (bool)
485     {
486         // A transfer/transferFrom is successful when 'call' is successful and depending on the token:
487         // - No value is returned: we assume a revert when the transfer failed (i.e. 'call' returns false)
488         // - A single boolean is returned: this boolean needs to be true (non-zero)
489         if (success) {
490             assembly {
491                 switch returndatasize()
492                 // Non-standard ERC20: nothing is returned so if 'call' was successful we assume the transfer succeeded
493                 case 0 {
494                     success := 1
495                 }
496                 // Standard ERC20: a single boolean value is returned which needs to be true
497                 case 32 {
498                     returndatacopy(0, 0, 32)
499                     success := mload(0)
500                 }
501                 // None of the above: not successful
502                 default {
503                     success := 0
504                 }
505             }
506         }
507         return success;
508     }
509 }