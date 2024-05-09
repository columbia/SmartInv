1 // exchange.xsapphire.com - Instant Trading on Chain
2 //
3 // Author: xsapphire.com Team
4 
5 pragma solidity >=0.4.20;
6 
7 interface Token {
8   function transfer(address to, uint256 value) external returns (bool success);
9   function transferFrom(address from, address to, uint256 value) external returns (bool success);
10 }
11 
12 contract XDEX {
13   //------------------------------ Struct Definitions: ---------------------------------------------
14 
15   struct TokenInfo {
16     string  symbol;       // e.g., "ETH", "XSAP"
17     address tokenAddr;    // ERC20 token address
18     uint64  scaleFactor;  // <original token amount> = <scaleFactor> x <DEx amountE8> / 1e8
19     uint    minDeposit;   // mininum deposit (original token amount) allowed for this token
20   }
21 
22   struct TraderInfo {
23     address withdrawAddr;
24     uint8   feeRebatePercent;  // range: [0, 100]
25   }
26 
27   struct TokenAccount {
28     uint64 balanceE8;          // available amount for trading
29     uint64 pendingWithdrawE8;  // the amount to be transferred out from this contract to the trader
30   }
31 
32   struct Order {
33     uint32 pairId;  // <cashId>(16) <stockId>(16)
34     uint8  action;  // 0 means BUY; 1 means SELL
35     uint8  ioc;     // 0 means a regular order; 1 means an immediate-or-cancel (IOC) order
36     uint64 priceE8;
37     uint64 amountE8;
38     uint64 expireTimeSec;
39   }
40 
41   struct Deposit {
42     address traderAddr;
43     uint16  tokenCode;
44     uint64  pendingAmountE8;   // amount to be confirmed for trading purpose
45   }
46 
47   struct DealInfo {
48     uint16 stockCode;          // stock token code
49     uint16 cashCode;           // cash token code
50     uint64 stockDealAmountE8;
51     uint64 cashDealAmountE8;
52   }
53 
54   struct ExeStatus {
55     uint64 logicTimeSec;       // logic timestamp for checking order expiration
56     uint64 lastOperationIndex; // index of the last executed operation
57   }
58 
59   //----------------- Constants: -------------------------------------------------------------------
60 
61   uint constant MAX_UINT256 = 2**256 - 1;
62   uint16 constant MAX_FEE_RATE_E4 = 60;  // upper limit of fee rate is 0.6% (60 / 1e4)
63 
64   // <original ETH amount in Wei> = <DEx amountE8> * <ETH_SCALE_FACTOR> / 1e8
65   uint64 constant ETH_SCALE_FACTOR = 10**18;
66 
67   uint8 constant ACTIVE = 0;
68   uint8 constant CLOSED = 2;
69 
70   bytes32 constant HASHTYPES =
71       keccak256(abi.encodePacked('string title', 'address market_address', 'uint64 nonce', 'uint64 expire_time_sec',
72                 'uint64 amount_e8', 'uint64 price_e8', 'uint8 immediate_or_cancel', 'uint8 action',
73                 'uint16 cash_token_code', 'uint16 stock_token_code'));
74 
75   //----------------- States that cannot be changed once set: --------------------------------------
76 
77   address public admin;                         // admin address, and it cannot be changed
78   mapping (uint16 => TokenInfo) public tokens;  // mapping of token code to token information
79 
80   //----------------- Other states: ----------------------------------------------------------------
81 
82   uint8 public marketStatus;        // market status: 0 - Active; 1 - Suspended; 2 - Closed
83 
84   uint16 public makerFeeRateE4;     // maker fee rate (* 10**4)
85   uint16 public takerFeeRateE4;     // taker fee rate (* 10**4)
86   uint16 public withdrawFeeRateE4;  // withdraw fee rate (* 10**4)
87 
88   uint64 public lastDepositIndex;   // index of the last deposit operation
89 
90   ExeStatus public exeStatus;       // status of operation execution
91 
92   mapping (address => TraderInfo) public traders;     // mapping of trade address to trader information
93   mapping (uint176 => TokenAccount) public accounts;  // mapping of trader token key to its account information
94   mapping (uint224 => Order) public orders;           // mapping of order key to order information
95   mapping (uint64  => Deposit) public deposits;       // mapping of deposit index to deposit information
96 
97   //------------------------------ Dex2 Events: ----------------------------------------------------
98 
99   event DeployMarketEvent();
100   event ChangeMarketStatusEvent(uint8 status);
101   event SetTokenInfoEvent(uint16 tokenCode, string symbol, address tokenAddr, uint64 scaleFactor, uint minDeposit);
102   event SetWithdrawAddrEvent(address trader, address withdrawAddr);
103 
104   event DepositEvent(address trader, uint16 tokenCode, string symbol, uint64 amountE8, uint64 depositIndex);
105   event WithdrawEvent(address trader, uint16 tokenCode, string symbol, uint64 amountE8, uint64 lastOpIndex);
106   event TransferFeeEvent(uint16 tokenCode, uint64 amountE8, address toAddr);
107 
108   // `balanceE8` is the total balance after this deposit confirmation
109   event ConfirmDepositEvent(address trader, uint16 tokenCode, uint64 balanceE8);
110   // `amountE8` is the post-fee initiated withdraw amount
111   // `pendingWithdrawE8` is the total pending withdraw amount after this withdraw initiation
112   event InitiateWithdrawEvent(address trader, uint16 tokenCode, uint64 amountE8, uint64 pendingWithdrawE8);
113   event MatchOrdersEvent(address trader1, uint64 nonce1, address trader2, uint64 nonce2);
114   event HardCancelOrderEvent(address trader, uint64 nonce);
115   event SetFeeRatesEvent(uint16 makerFeeRateE4, uint16 takerFeeRateE4, uint16 withdrawFeeRateE4);
116   event SetFeeRebatePercentEvent(address trader, uint8 feeRebatePercent);
117 
118   //------------------------------ Contract Initialization: ----------------------------------------
119 
120   function XSAPDEX(address admin_) public {
121     admin = admin_;
122     setTokenInfo(0 /*tokenCode*/, "ETH", 0 /*tokenAddr*/, ETH_SCALE_FACTOR, 0 /*minDeposit*/);
123     emit DeployMarketEvent();
124   }
125 
126   //------------------------------ External Functions: ---------------------------------------------
127 
128   function() external {
129     revert();
130   }
131 
132   // Change the market status of DEX.
133   function changeMarketStatus(uint8 status_) external {
134     if (msg.sender != admin) revert();
135     if (marketStatus == CLOSED) revert();  // closed is forever
136 
137     marketStatus = status_;
138     emit ChangeMarketStatusEvent(status_);
139   }
140 
141   // Each trader can specify a withdraw address (but cannot change it later). Once a trader's
142   // withdraw address is set, following withdrawals of this trader will go to the withdraw address
143   // instead of the trader's address.
144   function setWithdrawAddr(address withdrawAddr) external {
145     if (withdrawAddr == 0) revert();
146     if (traders[msg.sender].withdrawAddr != 0) revert();  // cannot change withdrawAddr once set
147     traders[msg.sender].withdrawAddr = withdrawAddr;
148     emit SetWithdrawAddrEvent(msg.sender, withdrawAddr);
149   }
150 
151   // Deposit ETH from msg.sender for the given trader.
152   function depositEth(address traderAddr) external payable {
153     if (marketStatus != ACTIVE) revert();
154     if (traderAddr == 0) revert();
155     if (msg.value < tokens[0].minDeposit) revert();
156     if (msg.data.length != 4 + 32) revert();  // length condition of param count
157 
158     uint64 pendingAmountE8 = uint64(msg.value / (ETH_SCALE_FACTOR / 10**8));  // msg.value is in Wei
159     if (pendingAmountE8 == 0) revert();
160 
161     uint64 depositIndex = ++lastDepositIndex;
162     setDeposits(depositIndex, traderAddr, 0, pendingAmountE8);
163     emit DepositEvent(traderAddr, 0, "ETH", pendingAmountE8, depositIndex);
164   }
165 
166   // Deposit token (other than ETH) from msg.sender for a specified trader.
167   //
168   // After the deposit has been confirmed enough times on the blockchain, it will be added to the
169   // trader's token account for trading.
170   function depositToken(address traderAddr, uint16 tokenCode, uint originalAmount) external {
171     if (marketStatus != ACTIVE) revert();
172     if (traderAddr == 0) revert();
173     if (tokenCode == 0) revert();  // this function does not handle ETH
174     if (msg.data.length != 4 + 32 + 32 + 32) revert();  // length condition of param count
175 
176     TokenInfo memory tokenInfo = tokens[tokenCode];
177     if (originalAmount < tokenInfo.minDeposit) revert();
178     if (tokenInfo.scaleFactor == 0) revert();  // unsupported token
179 
180     // Need to make approval by calling Token(address).approve() in advance for ERC-20 Tokens.
181     if (!Token(tokenInfo.tokenAddr).transferFrom(msg.sender, this, originalAmount)) revert();
182 
183     if (originalAmount > MAX_UINT256 / 10**8) revert();  // avoid overflow
184     uint amountE8 = originalAmount * 10**8 / uint(tokenInfo.scaleFactor);
185     if (amountE8 >= 2**64 || amountE8 == 0) revert();
186 
187     uint64 depositIndex = ++lastDepositIndex;
188     setDeposits(depositIndex, traderAddr, tokenCode, uint64(amountE8));
189     emit DepositEvent(traderAddr, tokenCode, tokens[tokenCode].symbol, uint64(amountE8), depositIndex);
190   }
191 
192   // Withdraw ETH from the contract.
193   function withdrawEth(address traderAddr) external {
194     if (traderAddr == 0) revert();
195     if (msg.data.length != 4 + 32) revert();  // length condition of param count
196 
197     uint176 accountKey = uint176(traderAddr);
198     uint amountE8 = accounts[accountKey].pendingWithdrawE8;
199     if (amountE8 == 0) return;
200 
201     // Write back to storage before making the transfer.
202     accounts[accountKey].pendingWithdrawE8 = 0;
203 
204     uint truncatedWei = amountE8 * (ETH_SCALE_FACTOR / 10**8);
205     address withdrawAddr = traders[traderAddr].withdrawAddr;
206     if (withdrawAddr == 0) withdrawAddr = traderAddr;
207     withdrawAddr.transfer(truncatedWei);
208     emit WithdrawEvent(traderAddr, 0, "ETH", uint64(amountE8), exeStatus.lastOperationIndex);
209   }
210 
211   // Withdraw token (other than ETH) from the contract.
212   function withdrawToken(address traderAddr, uint16 tokenCode) external {
213     if (traderAddr == 0) revert();
214     if (tokenCode == 0) revert();  // this function does not handle ETH
215     if (msg.data.length != 4 + 32 + 32) revert();  // length condition of param count
216 
217     TokenInfo memory tokenInfo = tokens[tokenCode];
218     if (tokenInfo.scaleFactor == 0) revert();  // unsupported token
219 
220     uint176 accountKey = uint176(tokenCode) << 160 | uint176(traderAddr);
221     uint amountE8 = accounts[accountKey].pendingWithdrawE8;
222     if (amountE8 == 0) return;
223 
224     // Write back to storage before making the transfer.
225     accounts[accountKey].pendingWithdrawE8 = 0;
226 
227     uint truncatedAmount = amountE8 * uint(tokenInfo.scaleFactor) / 10**8;
228     address withdrawAddr = traders[traderAddr].withdrawAddr;
229     if (withdrawAddr == 0) withdrawAddr = traderAddr;
230     if (!Token(tokenInfo.tokenAddr).transfer(withdrawAddr, truncatedAmount)) revert();
231     emit WithdrawEvent(traderAddr, tokenCode, tokens[tokenCode].symbol, uint64(amountE8),
232                        exeStatus.lastOperationIndex);
233   }
234 
235   // Transfer the collected fee out of the contract.
236   function transferFee(uint16 tokenCode, uint64 amountE8, address toAddr) external {
237     if (msg.sender != admin) revert();
238     if (toAddr == 0) revert();
239     if (msg.data.length != 4 + 32 + 32 + 32) revert();
240 
241     TokenAccount memory feeAccount = accounts[uint176(tokenCode) << 160];
242     uint64 withdrawE8 = feeAccount.pendingWithdrawE8;
243     if (amountE8 < withdrawE8) {
244       withdrawE8 = amountE8;
245     }
246     feeAccount.pendingWithdrawE8 -= withdrawE8;
247     accounts[uint176(tokenCode) << 160] = feeAccount;
248 
249     TokenInfo memory tokenInfo = tokens[tokenCode];
250     uint originalAmount = uint(withdrawE8) * uint(tokenInfo.scaleFactor) / 10**8;
251     if (tokenCode == 0) {  // ETH
252       toAddr.transfer(originalAmount);
253     } else {
254       if (!Token(tokenInfo.tokenAddr).transfer(toAddr, originalAmount)) revert();
255     }
256     emit TransferFeeEvent(tokenCode, withdrawE8, toAddr);
257   }
258 
259   // Replay the trading sequence from the off-chain ledger exactly onto the on-chain ledger.
260   function exeSequence(uint header, uint[] body) external {
261     if (msg.sender != admin) revert();
262 
263     uint64 nextOperationIndex = uint64(header);
264     if (nextOperationIndex != exeStatus.lastOperationIndex + 1) revert();  // check sequence index
265 
266     uint64 newLogicTimeSec = uint64(header >> 64);
267     if (newLogicTimeSec < exeStatus.logicTimeSec) revert();
268 
269     for (uint i = 0; i < body.length; nextOperationIndex++) {
270       uint bits = body[i];
271       uint opcode = bits & 0xFFFF;
272       bits >>= 16;
273       if ((opcode >> 8) != 0xDE) revert();  // check the magic number
274 
275       // ConfirmDeposit: <depositIndex>(64)
276       if (opcode == 0xDE01) {
277         confirmDeposit(uint64(bits));
278         i += 1;
279         continue;
280       }
281 
282       // InitiateWithdraw: <amountE8>(64) <tokenCode>(16) <traderAddr>(160)
283       if (opcode == 0xDE02) {
284         initiateWithdraw(uint176(bits), uint64(bits >> 176));
285         i += 1;
286         continue;
287       }
288 
289       //-------- The rest operation types are allowed only when the market is active ---------
290       if (marketStatus != ACTIVE) revert();
291 
292       // MatchOrders
293       if (opcode == 0xDE03) {
294         uint8 v1 = uint8(bits);
295         bits >>= 8;            // bits is now the key of the maker order
296 
297         Order memory makerOrder;
298         if (v1 == 0) {         // order already in storage
299           if (i + 1 >= body.length) revert();  // at least 1 body element left
300           makerOrder = orders[uint224(bits)];
301           i += 1;
302         } else {
303           if (orders[uint224(bits)].pairId != 0) revert();  // order must not be already in storage
304           if (i + 4 >= body.length) revert();  // at least 4 body elements left
305           makerOrder = parseNewOrder(uint224(bits) /*makerOrderKey*/, v1, body, i);
306           i += 4;
307         }
308 
309         uint8 v2 = uint8(body[i]);
310         uint224 takerOrderKey = uint224(body[i] >> 8);
311         Order memory takerOrder;
312         if (v2 == 0) {         // order already in storage
313           takerOrder = orders[takerOrderKey];
314           i += 1;
315         } else {
316           if (orders[takerOrderKey].pairId != 0) revert();  // order must not be already in storage
317           if (i + 3 >= body.length) revert();  // at least 3 body elements left
318           takerOrder = parseNewOrder(takerOrderKey, v2, body, i);
319           i += 4;
320         }
321 
322         matchOrder(uint224(bits) /*makerOrderKey*/, makerOrder, takerOrderKey, takerOrder);
323         continue;
324       }
325 
326       // HardCancelOrder: <nonce>(64) <traderAddr>(160)
327       if (opcode == 0xDE04) {
328         hardCancelOrder(uint224(bits) /*orderKey*/);
329         i += 1;
330         continue;
331       }
332 
333       // SetFeeRates: <withdrawFeeRateE4>(16) <takerFeeRateE4>(16) <makerFeeRateE4>(16)
334       if (opcode == 0xDE05) {
335         setFeeRates(uint16(bits), uint16(bits >> 16), uint16(bits >> 32));
336         i += 1;
337         continue;
338       }
339 
340       // SetFeeRebatePercent: <rebatePercent>(8) <traderAddr>(160)
341       if (opcode == 0xDE06) {
342         setFeeRebatePercent(address(bits) /*traderAddr*/, uint8(bits >> 160) /*rebatePercent*/);
343         i += 1;
344         continue;
345       }
346     } // for loop
347 
348     setExeStatus(newLogicTimeSec, nextOperationIndex - 1);
349   } // function exeSequence
350 
351   //------------------------------ Public Functions: -----------------------------------------------
352 
353   // Set information of a token.
354   function setTokenInfo(uint16 tokenCode, string symbol, address tokenAddr, uint64 scaleFactor,
355                         uint minDeposit) public {
356     if (msg.sender != admin) revert();
357     if (marketStatus != ACTIVE) revert();
358     if (scaleFactor == 0) revert();
359 
360     TokenInfo memory info = tokens[tokenCode];
361     if (info.scaleFactor != 0) {  // this token already exists
362       // For an existing token only the minDeposit field can be updated.
363       tokens[tokenCode].minDeposit = minDeposit;
364       emit SetTokenInfoEvent(tokenCode, info.symbol, info.tokenAddr, info.scaleFactor, minDeposit);
365       return;
366     }
367 
368     tokens[tokenCode].symbol = symbol;
369     tokens[tokenCode].tokenAddr = tokenAddr;
370     tokens[tokenCode].scaleFactor = scaleFactor;
371     tokens[tokenCode].minDeposit = minDeposit;
372     emit SetTokenInfoEvent(tokenCode, symbol, tokenAddr, scaleFactor, minDeposit);
373   }
374 
375   //------------------------------ Private Functions: ----------------------------------------------
376 
377   function setDeposits(uint64 depositIndex, address traderAddr, uint16 tokenCode, uint64 amountE8) private {
378     deposits[depositIndex].traderAddr = traderAddr;
379     deposits[depositIndex].tokenCode = tokenCode;
380     deposits[depositIndex].pendingAmountE8 = amountE8;
381   }
382 
383   function setExeStatus(uint64 logicTimeSec, uint64 lastOperationIndex) private {
384     exeStatus.logicTimeSec = logicTimeSec;
385     exeStatus.lastOperationIndex = lastOperationIndex;
386   }
387 
388   function confirmDeposit(uint64 depositIndex) private {
389     Deposit memory deposit = deposits[depositIndex];
390     uint176 accountKey = (uint176(deposit.tokenCode) << 160) | uint176(deposit.traderAddr);
391     TokenAccount memory account = accounts[accountKey];
392 
393     // Check that pending amount is non-zero and no overflow would happen.
394     if (account.balanceE8 + deposit.pendingAmountE8 <= account.balanceE8) revert();
395     account.balanceE8 += deposit.pendingAmountE8;
396 
397     deposits[depositIndex].pendingAmountE8 = 0;
398     accounts[accountKey].balanceE8 += deposit.pendingAmountE8;
399     emit ConfirmDepositEvent(deposit.traderAddr, deposit.tokenCode, account.balanceE8);
400   }
401 
402   function initiateWithdraw(uint176 tokenAccountKey, uint64 amountE8) private {
403     uint64 balanceE8 = accounts[tokenAccountKey].balanceE8;
404     uint64 pendingWithdrawE8 = accounts[tokenAccountKey].pendingWithdrawE8;
405 
406     if (balanceE8 < amountE8 || amountE8 == 0) revert();
407     balanceE8 -= amountE8;
408 
409     uint64 feeE8 = calcFeeE8(amountE8, withdrawFeeRateE4, address(tokenAccountKey));
410     amountE8 -= feeE8;
411 
412     if (pendingWithdrawE8 + amountE8 < amountE8) revert();  // check overflow
413     pendingWithdrawE8 += amountE8;
414 
415     accounts[tokenAccountKey].balanceE8 = balanceE8;
416     accounts[tokenAccountKey].pendingWithdrawE8 = pendingWithdrawE8;
417 
418     // Note that the fee account has a dummy trader address of 0.
419     if (accounts[tokenAccountKey & (0xffff << 160)].pendingWithdrawE8 + feeE8 >= feeE8) {  // no overflow
420       accounts[tokenAccountKey & (0xffff << 160)].pendingWithdrawE8 += feeE8;
421     }
422 
423     emit InitiateWithdrawEvent(address(tokenAccountKey), uint16(tokenAccountKey >> 160) /*tokenCode*/,
424                                amountE8, pendingWithdrawE8);
425   }
426 
427   function getDealInfo(uint32 pairId, uint64 priceE8, uint64 amount1E8, uint64 amount2E8)
428       private pure returns (DealInfo deal) {
429     deal.stockCode = uint16(pairId);
430     deal.cashCode = uint16(pairId >> 16);
431     if (deal.stockCode == deal.cashCode) revert();  // we disallow homogeneous trading
432 
433     deal.stockDealAmountE8 = amount1E8 < amount2E8 ? amount1E8 : amount2E8;
434 
435     uint cashDealAmountE8 = uint(priceE8) * uint(deal.stockDealAmountE8) / 10**8;
436     if (cashDealAmountE8 >= 2**64) revert();
437     deal.cashDealAmountE8 = uint64(cashDealAmountE8);
438   }
439 
440   function calcFeeE8(uint64 amountE8, uint feeRateE4, address traderAddr)
441       private view returns (uint64) {
442     uint feeE8 = uint(amountE8) * feeRateE4 / 10000;
443     feeE8 -= feeE8 * uint(traders[traderAddr].feeRebatePercent) / 100;
444     return uint64(feeE8);
445   }
446 
447   function settleAccounts(DealInfo deal, address traderAddr, uint feeRateE4, bool isBuyer) private {
448     uint16 giveTokenCode = isBuyer ? deal.cashCode : deal.stockCode;
449     uint16 getTokenCode = isBuyer ? deal.stockCode : deal.cashCode;
450 
451     uint64 giveAmountE8 = isBuyer ? deal.cashDealAmountE8 : deal.stockDealAmountE8;
452     uint64 getAmountE8 = isBuyer ? deal.stockDealAmountE8 : deal.cashDealAmountE8;
453 
454     uint176 giveAccountKey = uint176(giveTokenCode) << 160 | uint176(traderAddr);
455     uint176 getAccountKey = uint176(getTokenCode) << 160 | uint176(traderAddr);
456 
457     uint64 feeE8 = calcFeeE8(getAmountE8, feeRateE4, traderAddr);
458     getAmountE8 -= feeE8;
459 
460     // Check overflow.
461     if (accounts[giveAccountKey].balanceE8 < giveAmountE8) revert();
462     if (accounts[getAccountKey].balanceE8 + getAmountE8 < getAmountE8) revert();
463 
464     // Write storage.
465     accounts[giveAccountKey].balanceE8 -= giveAmountE8;
466     accounts[getAccountKey].balanceE8 += getAmountE8;
467 
468     if (accounts[uint176(getTokenCode) << 160].pendingWithdrawE8 + feeE8 >= feeE8) {  // no overflow
469       accounts[uint176(getTokenCode) << 160].pendingWithdrawE8 += feeE8;
470     }
471   }
472 
473   function setOrders(uint224 orderKey, uint32 pairId, uint8 action, uint8 ioc,
474                      uint64 priceE8, uint64 amountE8, uint64 expireTimeSec) private {
475     orders[orderKey].pairId = pairId;
476     orders[orderKey].action = action;
477     orders[orderKey].ioc = ioc;
478     orders[orderKey].priceE8 = priceE8;
479     orders[orderKey].amountE8 = amountE8;
480     orders[orderKey].expireTimeSec = expireTimeSec;
481   }
482 
483   function matchOrder(uint224 makerOrderKey, Order makerOrder,
484                       uint224 takerOrderKey, Order takerOrder) private {
485     // Check trading conditions.
486     if (marketStatus != ACTIVE) revert();
487     if (makerOrderKey == takerOrderKey) revert();  // the two orders must not have the same key
488     if (makerOrder.pairId != takerOrder.pairId) revert();
489     if (makerOrder.action == takerOrder.action) revert();
490     if (makerOrder.priceE8 == 0 || takerOrder.priceE8 == 0) revert();
491     if (makerOrder.action == 0 && makerOrder.priceE8 < takerOrder.priceE8) revert();
492     if (takerOrder.action == 0 && takerOrder.priceE8 < makerOrder.priceE8) revert();
493     if (makerOrder.amountE8 == 0 || takerOrder.amountE8 == 0) revert();
494     if (makerOrder.expireTimeSec <= exeStatus.logicTimeSec) revert();
495     if (takerOrder.expireTimeSec <= exeStatus.logicTimeSec) revert();
496 
497     DealInfo memory deal = getDealInfo(
498         makerOrder.pairId, makerOrder.priceE8, makerOrder.amountE8, takerOrder.amountE8);
499 
500     // Update accounts.
501     settleAccounts(deal, address(makerOrderKey), makerFeeRateE4, (makerOrder.action == 0));
502     settleAccounts(deal, address(takerOrderKey), takerFeeRateE4, (takerOrder.action == 0));
503 
504     // Update orders.
505     if (makerOrder.ioc == 1) {  // IOC order
506       makerOrder.amountE8 = 0;
507     } else {
508       makerOrder.amountE8 -= deal.stockDealAmountE8;
509     }
510     if (takerOrder.ioc == 1) {  // IOC order
511       takerOrder.amountE8 = 0;
512     } else {
513       takerOrder.amountE8 -= deal.stockDealAmountE8;
514     }
515 
516     // Write orders back to storage.
517     setOrders(makerOrderKey, makerOrder.pairId, makerOrder.action, makerOrder.ioc,
518               makerOrder.priceE8, makerOrder.amountE8, makerOrder.expireTimeSec);
519     setOrders(takerOrderKey, takerOrder.pairId, takerOrder.action, takerOrder.ioc,
520               takerOrder.priceE8, takerOrder.amountE8, takerOrder.expireTimeSec);
521 
522     emit MatchOrdersEvent(address(makerOrderKey), uint64(makerOrderKey >> 160) /*nonce*/,
523                           address(takerOrderKey), uint64(takerOrderKey >> 160) /*nonce*/);
524   }
525 
526   function hardCancelOrder(uint224 orderKey) private {
527     orders[orderKey].pairId = 0xFFFFFFFF;
528     orders[orderKey].amountE8 = 0;
529     emit HardCancelOrderEvent(address(orderKey) /*traderAddr*/, uint64(orderKey >> 160) /*nonce*/);
530   }
531 
532   function setFeeRates(uint16 makerE4, uint16 takerE4, uint16 withdrawE4) private {
533     if (makerE4 > MAX_FEE_RATE_E4) revert();
534     if (takerE4 > MAX_FEE_RATE_E4) revert();
535     if (withdrawE4 > MAX_FEE_RATE_E4) revert();
536 
537     makerFeeRateE4 = makerE4;
538     takerFeeRateE4 = takerE4;
539     withdrawFeeRateE4 = withdrawE4;
540     emit SetFeeRatesEvent(makerE4, takerE4, withdrawE4);
541   }
542 
543   function setFeeRebatePercent(address traderAddr, uint8 feeRebatePercent) private {
544     if (feeRebatePercent > 100) revert();
545 
546     traders[traderAddr].feeRebatePercent = feeRebatePercent;
547     emit SetFeeRebatePercentEvent(traderAddr, feeRebatePercent);
548   }
549 
550   function parseNewOrder(uint224 orderKey, uint8 v, uint[] body, uint i) private view returns (Order) {
551     // bits: <expireTimeSec>(64) <amountE8>(64) <priceE8>(64) <ioc>(8) <action>(8) <pairId>(32)
552     uint240 bits = uint240(body[i + 1]);
553     uint64 nonce = uint64(orderKey >> 160);
554     address traderAddr = address(orderKey);
555     if (traderAddr == 0) revert();  // check zero addr early since `ecrecover` returns 0 on error
556 
557     // verify the signature of the trader
558     bytes32 hash1 = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n70DEx2 Order: ", address(this), nonce, bits));
559     if (traderAddr != ecrecover(hash1, v, bytes32(body[i + 2]), bytes32(body[i + 3]))) {
560       bytes32 hashValues = keccak256(abi.encodePacked("DEx2 Order", address(this), nonce, bits));
561       bytes32 hash2 = keccak256(abi.encodePacked(HASHTYPES, hashValues));
562       if (traderAddr != ecrecover(hash2, v, bytes32(body[i + 2]), bytes32(body[i + 3]))) revert();
563     }
564 
565     Order memory order;
566     order.pairId = uint32(bits); bits >>= 32;
567     order.action = uint8(bits); bits >>= 8;
568     order.ioc = uint8(bits); bits >>= 8;
569     order.priceE8 = uint64(bits); bits >>= 64;
570     order.amountE8 = uint64(bits); bits >>= 64;
571     order.expireTimeSec = uint64(bits);
572     return order;
573   }
574 
575 }  // contract