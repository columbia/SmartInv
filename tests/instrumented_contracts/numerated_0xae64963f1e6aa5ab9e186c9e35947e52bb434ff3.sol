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
20     mapping (bytes32 => bool) public withdrawn;
21     mapping (bytes32 => bool) public transfers;
22     mapping (address => mapping (address => uint256)) public balances;
23     mapping (address => uint256) public tradesLocked;
24     mapping (address => uint256) public disableFees;
25     mapping (address => uint256) public tokenDecimals;
26     mapping (address => bool) public tokenRegistered;
27 
28     struct EIP712Domain {
29         string  name;
30         string  version;
31         uint256 chainId;
32         address verifyingContract;
33     }
34 
35     event Deposit(address token, address user, uint256 amount, uint256 balance);
36     event Withdraw(address token, address user, uint256 amount, uint256 balance);
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
51     bytes32 constant ORDER_TYPEHASH = keccak256("Order(address sell,address buy,uint256 sellAmount,uint256 buyAmount,uint256 withdrawOnTrade,uint256 sellSide,uint256 expires,uint256 nonce)");
52     bytes32 constant ORDER_WITH_TIPS_TYPEHASH = keccak256("OrderWithTips(address sell,address buy,uint256 sellAmount,uint256 buyAmount,uint256 withdrawOnTrade,uint256 sellSide,uint256 expires,uint256 nonce,uint256 makerTips,uint256 takerTips)");
53     bytes32 constant WITHDRAWAL_TYPEHASH = keccak256("Withdrawal(address withdrawToken,uint256 amount,uint256 nonce)");
54     bytes32 constant TIPS_TYPEHASH = keccak256("Tips(address tipsToken,uint256 amount,uint256 nonce)");
55     bytes32 constant TRANSFER_TYPEHASH = keccak256("Transfer(address transferToken,address to,uint256 amount,uint256 nonce)");
56     bytes32 DOMAIN_SEPARATOR;
57 
58     function domainHash(EIP712Domain eip712Domain) internal pure returns (bytes32) {
59         return keccak256(abi.encode(
60                 EIP712DOMAIN_TYPEHASH,
61                 keccak256(bytes(eip712Domain.name)),
62                 keccak256(bytes(eip712Domain.version)),
63                 eip712Domain.chainId,
64                 eip712Domain.verifyingContract
65             ));
66     }
67 
68     constructor() public {
69         DOMAIN_SEPARATOR = domainHash(EIP712Domain({
70             name: "Nescrow Exchange",
71             version: '1',
72             chainId: 1,
73             verifyingContract: this
74         }));
75 
76         tokenRegistered[0x0] = true;
77         tokenDecimals[0x0] = 18;
78     }
79 
80     function setOwner(address newOwner) external onlyOwner {
81         owner = newOwner;
82     }
83 
84     function getOwner() public view returns (address out) {
85         return owner;
86     }
87 
88     function setAdmin(address admin, bool isAdmin) external onlyOwner {
89         admins[admin] = isAdmin;
90     }
91 
92     function deposit() external payable {
93         uint amount = safeDiv(msg.value, 10**10);//wei to 8 decimals
94         require(amount > 0);
95         increaseBalance(msg.sender, address(0), amount);
96     }
97 
98     function depositToken(address token, uint256 amount) external {
99         require(amount > 0);
100         require(safeTransferFrom(token, msg.sender, this, toTokenAmount(token, amount)));
101         increaseBalance(msg.sender, token, amount);
102     }
103 
104     function depositTokenByAdmin(address user, address token, uint256 amount)
105         external onlyAdmin {
106         require(amount > 0);
107         require(safeTransferFrom(token, user, this, toTokenAmount(token, amount)));
108         increaseBalance(user, token, amount);
109     }
110 
111     function sendTips() external payable {
112         uint amount = safeDiv(msg.value, 10**10);//wei to 8 decimals
113         require(amount > 0);
114         increaseBalance(feeAddress, address(0), amount);
115     }
116 
117     function transferTips(address token, uint256 amount, address fromUser, uint nonce, uint8 v, bytes32 r, bytes32 s)
118         external onlyAdmin {
119 
120         require(amount > 0);
121 
122         bytes32 hash = keccak256(abi.encode(TIPS_TYPEHASH, token, amount, nonce));
123         require(ecrecover(keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, hash)), v, r, s) == fromUser);
124 
125         require(!transfers[hash]);
126         transfers[hash] = true;
127 
128         require(reduceBalance(fromUser, token, amount));
129         increaseBalance(feeAddress, token, amount);
130     }
131 
132     function transfer(address token, uint256 amount, address fromUser, address toUser, uint nonce, uint8 v, bytes32 r, bytes32 s)
133         external onlyAdmin {
134 
135         require(amount > 0);
136 
137         bytes32 hash = keccak256(abi.encode(TRANSFER_TYPEHASH, token, toUser, amount, nonce));
138         require(ecrecover(keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, hash)), v, r, s) == fromUser);
139         transfers[hash] = true;
140 
141         require(reduceBalance(fromUser, token, amount));
142         increaseBalance(toUser, token, amount);
143     }
144 
145     function withdrawByAdmin(address token, uint256 amount, address user, uint nonce, uint8 v, bytes32 r, bytes32 s)
146         external onlyAdmin {
147 
148         require(amount > 0);
149         bytes32 hash = keccak256(abi.encode(WITHDRAWAL_TYPEHASH, token, amount, nonce));
150         require(ecrecover(keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, hash)), v, r, s) == user);
151 
152         require(!withdrawn[hash]);
153         withdrawn[hash] = true;
154 
155         require(reduceBalance(user, token, amount));
156         require(sendToUser(user, token, amount));
157     }
158 
159     function withdraw(address token, uint256 amount) external {
160 
161         require(amount > 0);
162         require(tradesLocked[msg.sender] > block.number);
163         require(reduceBalance(msg.sender, token, amount));
164 
165         require(sendToUser(msg.sender, token, amount));
166         emit Withdraw(token, msg.sender, amount, balances[token][msg.sender]);
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
252     function isUserMakerFeeEnabled(address user) private view returns(bool) {
253         return makerFeeRate > 0 && disableFees[user] < block.timestamp;
254     }
255 
256     function isUserTakerFeeEnabled(address user) private view returns(bool) {
257         return takerFeeRate > 0 && disableFees[user] < block.timestamp;
258     }
259 
260     function calculatePrice(uint256 offerAmount, uint256 wantAmount, uint256 sellSide) private pure returns(uint256) {
261         return sellSide == 0
262             ? safeDiv(safeMul(10**8, offerAmount), wantAmount)
263             : safeDiv(safeMul(10**8, wantAmount), offerAmount);
264     }
265 
266     function trade(
267         uint256[10] amounts,
268         address[4] addresses,
269         uint256[5] values,
270         bytes32[4] rs
271     ) external onlyAdmin {
272         /**
273             amounts: 0-offerAmount, 1-wantAmount, 2-orderExpires, 3-orderNonce, 4-offerAmount2, 5-wantAmount2, 6-orderExpires2, 7-orderNonce2, 8-offerAmountToFill, 9-wantAmountToFill
274             addresses: 0-maker, 1-taker, 2-offerToken, 3-wantToken
275             values: 2-withdrawMaker, 3-withdrawTaker, 4-sellSide
276         */
277         require(tradesLocked[addresses[0]] < block.number);
278         require(block.timestamp <= amounts[2]);
279         bytes32 orderHash = keccak256(abi.encode(ORDER_TYPEHASH, addresses[2], addresses[3], amounts[0], amounts[1], values[2], values[4], amounts[2], amounts[3]));
280         require(ecrecover(keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, orderHash)), uint8(values[0]), rs[0], rs[1]) == addresses[0]);
281         orderFills[orderHash] = safeAdd(orderFills[orderHash], amounts[8]);
282         require(orderFills[orderHash] <= amounts[0]);
283 
284         require(tradesLocked[addresses[1]] < block.number);
285         require(block.timestamp <= amounts[6]);
286         bytes32 orderHash2 = keccak256(abi.encode(ORDER_TYPEHASH, addresses[3], addresses[2], amounts[4], amounts[5], values[3], values[4] == 0 ? 1 : 0, amounts[6], amounts[7]));
287         require(ecrecover(keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, orderHash2)), uint8(values[1]), rs[2], rs[3]) == addresses[1]);
288 
289         uint256 makerPrice = calculatePrice(amounts[0], amounts[1], values[4]);
290         uint256 takerPrice = calculatePrice(amounts[4], amounts[5], values[4] == 0 ? 1 : 0);
291         require(values[4] == 0 && makerPrice >= takerPrice
292             || values[4] == 1 && makerPrice <= takerPrice);
293         require(makerPrice == calculatePrice(amounts[8], amounts[9], values[4]));
294 
295         orderFills[orderHash2] = safeAdd(orderFills[orderHash2], amounts[9]);
296         require(orderFills[orderHash2] <= amounts[4]);
297 
298         require(reduceBalance(addresses[0], addresses[2], amounts[8]));
299         require(reduceBalance(addresses[1], addresses[3], amounts[9]));
300 
301         if (isUserMakerFeeEnabled(addresses[0])) {
302             require(increaseBalanceOrWithdraw(addresses[0], addresses[3], safeSub(amounts[9], safeDiv(amounts[9], makerFeeRate)), values[2]));
303             increaseBalance(feeAddress, addresses[3], safeDiv(amounts[9], makerFeeRate));
304         } else {
305             require(increaseBalanceOrWithdraw(addresses[0], addresses[3], amounts[9], values[2]));
306         }
307 
308         if (isUserTakerFeeEnabled(addresses[1])) {
309             require(increaseBalanceOrWithdraw(addresses[1], addresses[2], safeSub(amounts[8], safeDiv(amounts[8], takerFeeRate)), values[3]));
310             increaseBalance(feeAddress, addresses[2], safeDiv(amounts[8], takerFeeRate));
311         } else {
312             require(increaseBalanceOrWithdraw(addresses[1], addresses[2], amounts[8], values[3]));
313         }
314     }
315 
316     function tradeWithTips(
317         uint256[10] amounts,
318         address[4] addresses,
319         uint256[9] values,
320         bytes32[4] rs
321     ) external onlyAdmin {
322         /**
323             amounts: 0-offerAmount, 1-wantAmount, 2-orderExpires, 3-orderNonce, 4-offerAmount2, 5-wantAmount2, 6-orderExpires2, 7-orderNonce2, 8-offerAmountToFill, 9-wantAmountToFill
324             addresses: 0-maker, 1-taker, 2-offerToken, 3-wantToken
325             values: 2-withdrawMaker, 3-withdrawTaker, 4-sellSide, 5-orderMakerTips, 6-orderTakerTips, 7-orderMakerTips2, 8-orderTakerTips2
326         */
327         require(tradesLocked[addresses[0]] < block.number);
328         require(block.timestamp <= amounts[2]);
329         bytes32 orderHash = values[5] > 0 || values[6] > 0
330             ? keccak256(abi.encode(ORDER_WITH_TIPS_TYPEHASH, addresses[2], addresses[3], amounts[0], amounts[1], values[2], values[4], amounts[2], amounts[3], values[5], values[6]))
331             : keccak256(abi.encode(ORDER_TYPEHASH, addresses[2], addresses[3], amounts[0], amounts[1], values[2], values[4], amounts[2], amounts[3]));
332         require(ecrecover(keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, orderHash)), uint8(values[0]), rs[0], rs[1]) == addresses[0]);
333         orderFills[orderHash] = safeAdd(orderFills[orderHash], amounts[8]);
334         require(orderFills[orderHash] <= amounts[0]);
335 
336         require(tradesLocked[addresses[1]] < block.number);
337         require(block.timestamp <= amounts[6]);
338         bytes32 orderHash2 = values[7] > 0 || values[8] > 0
339             ? keccak256(abi.encode(ORDER_WITH_TIPS_TYPEHASH, addresses[3], addresses[2], amounts[4], amounts[5], values[3], values[4] == 0 ? 1 : 0, amounts[6], amounts[7], values[7], values[8]))
340             : keccak256(abi.encode(ORDER_TYPEHASH, addresses[3], addresses[2], amounts[4], amounts[5], values[3], values[4] == 0 ? 1 : 0, amounts[6], amounts[7]));
341         require(ecrecover(keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, orderHash2)), uint8(values[1]), rs[2], rs[3]) == addresses[1]);
342 
343         uint256 makerPrice = calculatePrice(amounts[0], amounts[1], values[4]);
344         uint256 takerPrice = calculatePrice(amounts[4], amounts[5], values[4] == 0 ? 1 : 0);
345         require(values[4] == 0 && makerPrice >= takerPrice
346             || values[4] == 1 && makerPrice <= takerPrice);
347         require(makerPrice == calculatePrice(amounts[8], amounts[9], values[4]));
348 
349         orderFills[orderHash2] = safeAdd(orderFills[orderHash2], amounts[9]);
350         require(orderFills[orderHash2] <= amounts[4]);
351 
352         require(reduceBalance(addresses[0], addresses[2], amounts[8]));
353         require(reduceBalance(addresses[1], addresses[3], amounts[9]));
354 
355         if (values[5] > 0 && !isUserMakerFeeEnabled(addresses[0])) {
356             increaseBalanceOrWithdraw(addresses[0], addresses[3], safeSub(amounts[9], safeDiv(amounts[9], values[5])), values[2]);
357             increaseBalance(feeAddress, addresses[3], safeDiv(amounts[9], values[5]));
358         } else if (values[5] == 0 && isUserMakerFeeEnabled(addresses[0])) {
359             increaseBalanceOrWithdraw(addresses[0], addresses[3], safeSub(amounts[9], safeDiv(amounts[9], makerFeeRate)), values[2]);
360             increaseBalance(feeAddress, addresses[3], safeDiv(amounts[9], makerFeeRate));
361         } else if (values[5] > 0 && isUserMakerFeeEnabled(addresses[0])) {
362             increaseBalanceOrWithdraw(addresses[0], addresses[3], safeSub(amounts[9], safeAdd(safeDiv(amounts[9], values[5]), safeDiv(amounts[9], makerFeeRate))), values[2]);
363             increaseBalance(feeAddress, addresses[3], safeAdd(safeDiv(amounts[9], values[5]), safeDiv(amounts[9], makerFeeRate)));
364         } else {
365             increaseBalanceOrWithdraw(addresses[0], addresses[3], amounts[9], values[2]);
366         }
367 
368         if (values[8] > 0 && !isUserTakerFeeEnabled(addresses[1])) {
369             increaseBalanceOrWithdraw(addresses[1], addresses[2], safeSub(amounts[8], safeDiv(amounts[8], values[8])), values[3]);
370             increaseBalance(feeAddress, addresses[2], safeDiv(amounts[8], values[8]));
371         } else if (values[8] == 0 && isUserTakerFeeEnabled(addresses[1])) {
372             increaseBalanceOrWithdraw(addresses[1], addresses[2], safeSub(amounts[8], safeDiv(amounts[8], takerFeeRate)), values[3]);
373             increaseBalance(feeAddress, addresses[2], safeDiv(amounts[8], takerFeeRate));
374         } else if (values[8] > 0 && isUserTakerFeeEnabled(addresses[1])) {
375             increaseBalanceOrWithdraw(addresses[1], addresses[2], safeSub(amounts[8], safeAdd(safeDiv(amounts[8], values[8]), safeDiv(amounts[8], takerFeeRate))), values[3]);
376             increaseBalance(feeAddress, addresses[2], safeAdd(safeDiv(amounts[8], values[8]), safeDiv(amounts[8], takerFeeRate)));
377         } else {
378             increaseBalanceOrWithdraw(addresses[1], addresses[2], amounts[8], values[3]);
379         }
380     }
381 
382     function() public payable {
383         revert();
384     }
385 
386     function safeMul(uint a, uint b) internal pure returns (uint) {
387         uint c = a * b;
388         assert(a == 0 || c / a == b);
389         return c;
390     }
391 
392     function safeSub(uint a, uint b) internal pure returns (uint) {
393         assert(b <= a);
394         return a - b;
395     }
396 
397     function safeAdd(uint a, uint b) internal pure returns (uint) {
398         uint c = a + b;
399         assert(c>=a && c>=b);
400         return c;
401     }
402 
403     function safeDiv(uint a, uint b) internal pure returns (uint) {
404         assert(b > 0);
405         uint c = a / b;
406         assert(a == b * c + a % b);
407         return c;
408     }
409 
410     function safeTransfer(
411         address token,
412         address to,
413         uint256 value)
414     private
415     returns (bool success)
416     {
417         // A transfer is successful when 'call' is successful and depending on the token:
418         // - No value is returned: we assume a revert when the transfer failed (i.e. 'call' returns false)
419         // - A single boolean is returned: this boolean needs to be true (non-zero)
420 
421         // bytes4(keccak256("transfer(address,uint256)")) = 0xa9059cbb
422         success = token.call(0xa9059cbb, to, value);
423         return checkReturnValue(success);
424     }
425 
426     function safeTransferFrom(
427         address token,
428         address from,
429         address to,
430         uint256 value)
431     private
432     returns (bool success)
433     {
434         // A transferFrom is successful when 'call' is successful and depending on the token:
435         // - No value is returned: we assume a revert when the transfer failed (i.e. 'call' returns false)
436         // - A single boolean is returned: this boolean needs to be true (non-zero)
437 
438 //         bytes4(keccak256("transferFrom(address,address,uint256)")) = 0x23b872dd
439         success = token.call(0x23b872dd, from, to, value);
440         return checkReturnValue(success);
441     }
442 
443     function checkReturnValue(
444         bool success
445     )
446     private
447     pure
448     returns (bool)
449     {
450         // A transfer/transferFrom is successful when 'call' is successful and depending on the token:
451         // - No value is returned: we assume a revert when the transfer failed (i.e. 'call' returns false)
452         // - A single boolean is returned: this boolean needs to be true (non-zero)
453         if (success) {
454             assembly {
455                 switch returndatasize()
456                 // Non-standard ERC20: nothing is returned so if 'call' was successful we assume the transfer succeeded
457                 case 0 {
458                     success := 1
459                 }
460                 // Standard ERC20: a single boolean value is returned which needs to be true
461                 case 32 {
462                     returndatacopy(0, 0, 32)
463                     success := mload(0)
464                 }
465                 // None of the above: not successful
466                 default {
467                     success := 0
468                 }
469             }
470         }
471         return success;
472     }
473 }