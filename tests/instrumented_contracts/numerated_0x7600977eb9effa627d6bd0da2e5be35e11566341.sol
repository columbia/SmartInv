1 // DEx.top - Instant Trading on Chain
2 //
3 // Author: DEx.top Team
4 
5 pragma solidity 0.4.21;
6 pragma experimental "v0.5.0";
7 
8 interface Token {
9   function transfer(address to, uint256 value) external returns (bool success);
10   function transferFrom(address from, address to, uint256 value) external returns (bool success);
11 }
12 
13 contract Dex2 {
14   //------------------------------ Struct Definitions: ---------------------------------------------
15 
16   struct TokenInfo {
17     string  symbol;       // e.g., "ETH", "ADX"
18     address tokenAddr;    // ERC20 token address
19     uint64  scaleFactor;  // <original token amount> = <scaleFactor> x <DEx amountE8> / 1e8
20     uint    minDeposit;   // mininum deposit (original token amount) allowed for this token
21   }
22 
23   struct TraderInfo {
24     address withdrawAddr;
25     uint8   feeRebatePercent;  // range: [0, 100]
26   }
27 
28   struct TokenAccount {
29     uint64 balanceE8;          // available amount for trading
30     uint64 pendingWithdrawE8;  // the amount to be transferred out from this contract to the trader
31   }
32 
33   struct Order {
34     uint32 pairId;  // <cashId>(16) <stockId>(16)
35     uint8  action;  // 0 means BUY; 1 means SELL
36     uint8  ioc;     // 0 means a regular order; 1 means an immediate-or-cancel (IOC) order
37     uint64 priceE8;
38     uint64 amountE8;
39     uint64 expireTimeSec;
40   }
41 
42   struct Deposit {
43     address traderAddr;
44     uint16  tokenCode;
45     uint64  pendingAmountE8;   // amount to be confirmed for trading purpose
46   }
47 
48   struct DealInfo {
49     uint16 stockCode;          // stock token code
50     uint16 cashCode;           // cash token code
51     uint64 stockDealAmountE8;
52     uint64 cashDealAmountE8;
53   }
54 
55   struct ExeStatus {
56     uint64 logicTimeSec;       // logic timestamp for checking order expiration
57     uint64 lastOperationIndex; // index of the last executed operation
58   }
59 
60   //----------------- Constants: -------------------------------------------------------------------
61 
62   uint constant MAX_UINT256 = 2**256 - 1;
63   uint16 constant MAX_FEE_RATE_E4 = 60;  // upper limit of fee rate is 0.6% (60 / 1e4)
64 
65   // <original ETH amount in Wei> = <DEx amountE8> * <ETH_SCALE_FACTOR> / 1e8
66   uint64 constant ETH_SCALE_FACTOR = 10**18;
67 
68   uint8 constant ACTIVE = 0;
69   uint8 constant CLOSED = 2;
70 
71   bytes32 constant HASHTYPES =
72       keccak256('string title', 'address market_address', 'uint64 nonce', 'uint64 expire_time_sec',
73                 'uint64 amount_e8', 'uint64 price_e8', 'uint8 immediate_or_cancel', 'uint8 action',
74                 'uint16 cash_token_code', 'uint16 stock_token_code');
75 
76   //----------------- States that cannot be changed once set: --------------------------------------
77 
78   address public admin;                         // admin address, and it cannot be changed
79   mapping (uint16 => TokenInfo) public tokens;  // mapping of token code to token information
80 
81   //----------------- Other states: ----------------------------------------------------------------
82 
83   uint8 public marketStatus;        // market status: 0 - Active; 1 - Suspended; 2 - Closed
84 
85   uint16 public makerFeeRateE4;     // maker fee rate (* 10**4)
86   uint16 public takerFeeRateE4;     // taker fee rate (* 10**4)
87   uint16 public withdrawFeeRateE4;  // withdraw fee rate (* 10**4)
88 
89   uint64 public lastDepositIndex;   // index of the last deposit operation
90 
91   ExeStatus public exeStatus;       // status of operation execution
92 
93   mapping (address => TraderInfo) public traders;     // mapping of trade address to trader information
94   mapping (uint176 => TokenAccount) public accounts;  // mapping of trader token key to its account information
95   mapping (uint224 => Order) public orders;           // mapping of order key to order information
96   mapping (uint64  => Deposit) public deposits;       // mapping of deposit index to deposit information
97 
98   //------------------------------ Dex2 Events: ----------------------------------------------------
99 
100   event DeployMarketEvent();
101   event ChangeMarketStatusEvent(uint8 status);
102   event SetTokenInfoEvent(uint16 tokenCode, string symbol, address tokenAddr, uint64 scaleFactor, uint minDeposit);
103   event SetWithdrawAddrEvent(address trader, address withdrawAddr);
104 
105   event DepositEvent(address trader, uint16 tokenCode, string symbol, uint64 amountE8, uint64 depositIndex);
106   event WithdrawEvent(address trader, uint16 tokenCode, string symbol, uint64 amountE8, uint64 lastOpIndex);
107   event TransferFeeEvent(uint16 tokenCode, uint64 amountE8, address toAddr);
108 
109   // `balanceE8` is the total balance after this deposit confirmation
110   event ConfirmDepositEvent(address trader, uint16 tokenCode, uint64 balanceE8);
111   // `amountE8` is the post-fee initiated withdraw amount
112   // `pendingWithdrawE8` is the total pending withdraw amount after this withdraw initiation
113   event InitiateWithdrawEvent(address trader, uint16 tokenCode, uint64 amountE8, uint64 pendingWithdrawE8);
114   event MatchOrdersEvent(address trader1, uint64 nonce1, address trader2, uint64 nonce2);
115   event HardCancelOrderEvent(address trader, uint64 nonce);
116   event SetFeeRatesEvent(uint16 makerFeeRateE4, uint16 takerFeeRateE4, uint16 withdrawFeeRateE4);
117   event SetFeeRebatePercentEvent(address trader, uint8 feeRebatePercent);
118 
119   //------------------------------ Contract Initialization: ----------------------------------------
120 
121   function Dex2(address admin_) public {
122     admin = admin_;
123     setTokenInfo(0 /*tokenCode*/, "ETH", 0 /*tokenAddr*/, ETH_SCALE_FACTOR, 0 /*minDeposit*/);
124     emit DeployMarketEvent();
125   }
126 
127   //------------------------------ External Functions: ---------------------------------------------
128 
129   function() external {
130     revert();
131   }
132 
133   // Change the market status of DEX.
134   function changeMarketStatus(uint8 status_) external {
135     if (msg.sender != admin) revert();
136     if (marketStatus == CLOSED) revert();  // closed is forever
137 
138     marketStatus = status_;
139     emit ChangeMarketStatusEvent(status_);
140   }
141 
142   // Each trader can specify a withdraw address (but cannot change it later). Once a trader's
143   // withdraw address is set, following withdrawals of this trader will go to the withdraw address
144   // instead of the trader's address.
145   function setWithdrawAddr(address withdrawAddr) external {
146     if (withdrawAddr == 0) revert();
147     if (traders[msg.sender].withdrawAddr != 0) revert();  // cannot change withdrawAddr once set
148     traders[msg.sender].withdrawAddr = withdrawAddr;
149     emit SetWithdrawAddrEvent(msg.sender, withdrawAddr);
150   }
151 
152   // Deposit ETH from msg.sender for the given trader.
153   function depositEth(address traderAddr) external payable {
154     if (marketStatus != ACTIVE) revert();
155     if (traderAddr == 0) revert();
156     if (msg.value < tokens[0].minDeposit) revert();
157     if (msg.data.length != 4 + 32) revert();  // length condition of param count
158 
159     uint64 pendingAmountE8 = uint64(msg.value / (ETH_SCALE_FACTOR / 10**8));  // msg.value is in Wei
160     if (pendingAmountE8 == 0) revert();
161 
162     uint64 depositIndex = ++lastDepositIndex;
163     setDeposits(depositIndex, traderAddr, 0, pendingAmountE8);
164     emit DepositEvent(traderAddr, 0, "ETH", pendingAmountE8, depositIndex);
165   }
166 
167   // Deposit token (other than ETH) from msg.sender for a specified trader.
168   //
169   // After the deposit has been confirmed enough times on the blockchain, it will be added to the
170   // trader's token account for trading.
171   function depositToken(address traderAddr, uint16 tokenCode, uint originalAmount) external {
172     if (marketStatus != ACTIVE) revert();
173     if (traderAddr == 0) revert();
174     if (tokenCode == 0) revert();  // this function does not handle ETH
175     if (msg.data.length != 4 + 32 + 32 + 32) revert();  // length condition of param count
176 
177     TokenInfo memory tokenInfo = tokens[tokenCode];
178     if (originalAmount < tokenInfo.minDeposit) revert();
179     if (tokenInfo.scaleFactor == 0) revert();  // unsupported token
180 
181     // Need to make approval by calling Token(address).approve() in advance for ERC-20 Tokens.
182     if (!Token(tokenInfo.tokenAddr).transferFrom(msg.sender, this, originalAmount)) revert();
183 
184     if (originalAmount > MAX_UINT256 / 10**8) revert();  // avoid overflow
185     uint amountE8 = originalAmount * 10**8 / uint(tokenInfo.scaleFactor);
186     if (amountE8 >= 2**64 || amountE8 == 0) revert();
187 
188     uint64 depositIndex = ++lastDepositIndex;
189     setDeposits(depositIndex, traderAddr, tokenCode, uint64(amountE8));
190     emit DepositEvent(traderAddr, tokenCode, tokens[tokenCode].symbol, uint64(amountE8), depositIndex);
191   }
192 
193   // Withdraw ETH from the contract.
194   function withdrawEth(address traderAddr) external {
195     if (traderAddr == 0) revert();
196     if (msg.data.length != 4 + 32) revert();  // length condition of param count
197 
198     uint176 accountKey = uint176(traderAddr);
199     uint amountE8 = accounts[accountKey].pendingWithdrawE8;
200     if (amountE8 == 0) return;
201 
202     // Write back to storage before making the transfer.
203     accounts[accountKey].pendingWithdrawE8 = 0;
204 
205     uint truncatedWei = amountE8 * (ETH_SCALE_FACTOR / 10**8);
206     address withdrawAddr = traders[traderAddr].withdrawAddr;
207     if (withdrawAddr == 0) withdrawAddr = traderAddr;
208     withdrawAddr.transfer(truncatedWei);
209     emit WithdrawEvent(traderAddr, 0, "ETH", uint64(amountE8), exeStatus.lastOperationIndex);
210   }
211 
212   // Withdraw token (other than ETH) from the contract.
213   function withdrawToken(address traderAddr, uint16 tokenCode) external {
214     if (traderAddr == 0) revert();
215     if (tokenCode == 0) revert();  // this function does not handle ETH
216     if (msg.data.length != 4 + 32 + 32) revert();  // length condition of param count
217 
218     TokenInfo memory tokenInfo = tokens[tokenCode];
219     if (tokenInfo.scaleFactor == 0) revert();  // unsupported token
220 
221     uint176 accountKey = uint176(tokenCode) << 160 | uint176(traderAddr);
222     uint amountE8 = accounts[accountKey].pendingWithdrawE8;
223     if (amountE8 == 0) return;
224 
225     // Write back to storage before making the transfer.
226     accounts[accountKey].pendingWithdrawE8 = 0;
227 
228     uint truncatedAmount = amountE8 * uint(tokenInfo.scaleFactor) / 10**8;
229     address withdrawAddr = traders[traderAddr].withdrawAddr;
230     if (withdrawAddr == 0) withdrawAddr = traderAddr;
231     if (!Token(tokenInfo.tokenAddr).transfer(withdrawAddr, truncatedAmount)) revert();
232     emit WithdrawEvent(traderAddr, tokenCode, tokens[tokenCode].symbol, uint64(amountE8),
233                        exeStatus.lastOperationIndex);
234   }
235 
236   // Transfer the collected fee out of the contract.
237   function transferFee(uint16 tokenCode, uint64 amountE8, address toAddr) external {
238     if (msg.sender != admin) revert();
239     if (toAddr == 0) revert();
240     if (msg.data.length != 4 + 32 + 32 + 32) revert();
241 
242     TokenAccount memory feeAccount = accounts[uint176(tokenCode) << 160];
243     uint64 withdrawE8 = feeAccount.pendingWithdrawE8;
244     if (amountE8 < withdrawE8) {
245       withdrawE8 = amountE8;
246     }
247     feeAccount.pendingWithdrawE8 -= withdrawE8;
248     accounts[uint176(tokenCode) << 160] = feeAccount;
249 
250     TokenInfo memory tokenInfo = tokens[tokenCode];
251     uint originalAmount = uint(withdrawE8) * uint(tokenInfo.scaleFactor) / 10**8;
252     if (tokenCode == 0) {  // ETH
253       toAddr.transfer(originalAmount);
254     } else {
255       if (!Token(tokenInfo.tokenAddr).transfer(toAddr, originalAmount)) revert();
256     }
257     emit TransferFeeEvent(tokenCode, withdrawE8, toAddr);
258   }
259 
260   // Replay the trading sequence from the off-chain ledger exactly onto the on-chain ledger.
261   function exeSequence(uint header, uint[] body) external {
262     if (msg.sender != admin) revert();
263 
264     uint64 nextOperationIndex = uint64(header);
265     if (nextOperationIndex != exeStatus.lastOperationIndex + 1) revert();  // check sequence index
266 
267     uint64 newLogicTimeSec = uint64(header >> 64);
268     if (newLogicTimeSec < exeStatus.logicTimeSec) revert();
269 
270     for (uint i = 0; i < body.length; nextOperationIndex++) {
271       uint bits = body[i];
272       uint opcode = bits & 0xFFFF;
273       bits >>= 16;
274       if ((opcode >> 8) != 0xDE) revert();  // check the magic number
275 
276       // ConfirmDeposit: <depositIndex>(64)
277       if (opcode == 0xDE01) {
278         confirmDeposit(uint64(bits));
279         i += 1;
280         continue;
281       }
282 
283       // InitiateWithdraw: <amountE8>(64) <tokenCode>(16) <traderAddr>(160)
284       if (opcode == 0xDE02) {
285         initiateWithdraw(uint176(bits), uint64(bits >> 176));
286         i += 1;
287         continue;
288       }
289 
290       //-------- The rest operation types are allowed only when the market is active ---------
291       if (marketStatus != ACTIVE) revert();
292 
293       // MatchOrders
294       if (opcode == 0xDE03) {
295         uint8 v1 = uint8(bits);
296         bits >>= 8;            // bits is now the key of the maker order
297 
298         Order memory makerOrder;
299         if (v1 == 0) {         // order already in storage
300           if (i + 1 >= body.length) revert();  // at least 1 body element left
301           makerOrder = orders[uint224(bits)];
302           i += 1;
303         } else {
304           if (orders[uint224(bits)].pairId != 0) revert();  // order must not be already in storage
305           if (i + 4 >= body.length) revert();  // at least 4 body elements left
306           makerOrder = parseNewOrder(uint224(bits) /*makerOrderKey*/, v1, body, i);
307           i += 4;
308         }
309 
310         uint8 v2 = uint8(body[i]);
311         uint224 takerOrderKey = uint224(body[i] >> 8);
312         Order memory takerOrder;
313         if (v2 == 0) {         // order already in storage
314           takerOrder = orders[takerOrderKey];
315           i += 1;
316         } else {
317           if (orders[takerOrderKey].pairId != 0) revert();  // order must not be already in storage
318           if (i + 3 >= body.length) revert();  // at least 3 body elements left
319           takerOrder = parseNewOrder(takerOrderKey, v2, body, i);
320           i += 4;
321         }
322 
323         matchOrder(uint224(bits) /*makerOrderKey*/, makerOrder, takerOrderKey, takerOrder);
324         continue;
325       }
326 
327       // HardCancelOrder: <nonce>(64) <traderAddr>(160)
328       if (opcode == 0xDE04) {
329         hardCancelOrder(uint224(bits) /*orderKey*/);
330         i += 1;
331         continue;
332       }
333 
334       // SetFeeRates: <withdrawFeeRateE4>(16) <takerFeeRateE4>(16) <makerFeeRateE4>(16)
335       if (opcode == 0xDE05) {
336         setFeeRates(uint16(bits), uint16(bits >> 16), uint16(bits >> 32));
337         i += 1;
338         continue;
339       }
340 
341       // SetFeeRebatePercent: <rebatePercent>(8) <traderAddr>(160)
342       if (opcode == 0xDE06) {
343         setFeeRebatePercent(address(bits) /*traderAddr*/, uint8(bits >> 160) /*rebatePercent*/);
344         i += 1;
345         continue;
346       }
347     } // for loop
348 
349     setExeStatus(newLogicTimeSec, nextOperationIndex - 1);
350   } // function exeSequence
351 
352   //------------------------------ Public Functions: -----------------------------------------------
353 
354   // Set information of a token.
355   function setTokenInfo(uint16 tokenCode, string symbol, address tokenAddr, uint64 scaleFactor,
356                         uint minDeposit) public {
357     if (msg.sender != admin) revert();
358     if (marketStatus != ACTIVE) revert();
359     if (scaleFactor == 0) revert();
360 
361     TokenInfo memory info = tokens[tokenCode];
362     if (info.scaleFactor != 0) {  // this token already exists
363       // For an existing token only the minDeposit field can be updated.
364       tokens[tokenCode].minDeposit = minDeposit;
365       emit SetTokenInfoEvent(tokenCode, info.symbol, info.tokenAddr, info.scaleFactor, minDeposit);
366       return;
367     }
368 
369     tokens[tokenCode].symbol = symbol;
370     tokens[tokenCode].tokenAddr = tokenAddr;
371     tokens[tokenCode].scaleFactor = scaleFactor;
372     tokens[tokenCode].minDeposit = minDeposit;
373     emit SetTokenInfoEvent(tokenCode, symbol, tokenAddr, scaleFactor, minDeposit);
374   }
375 
376   //------------------------------ Private Functions: ----------------------------------------------
377 
378   function setDeposits(uint64 depositIndex, address traderAddr, uint16 tokenCode, uint64 amountE8) private {
379     deposits[depositIndex].traderAddr = traderAddr;
380     deposits[depositIndex].tokenCode = tokenCode;
381     deposits[depositIndex].pendingAmountE8 = amountE8;
382   }
383 
384   function setExeStatus(uint64 logicTimeSec, uint64 lastOperationIndex) private {
385     exeStatus.logicTimeSec = logicTimeSec;
386     exeStatus.lastOperationIndex = lastOperationIndex;
387   }
388 
389   function confirmDeposit(uint64 depositIndex) private {
390     Deposit memory deposit = deposits[depositIndex];
391     uint176 accountKey = (uint176(deposit.tokenCode) << 160) | uint176(deposit.traderAddr);
392     TokenAccount memory account = accounts[accountKey];
393 
394     // Check that pending amount is non-zero and no overflow would happen.
395     if (account.balanceE8 + deposit.pendingAmountE8 <= account.balanceE8) revert();
396     account.balanceE8 += deposit.pendingAmountE8;
397 
398     deposits[depositIndex].pendingAmountE8 = 0;
399     accounts[accountKey].balanceE8 += deposit.pendingAmountE8;
400     emit ConfirmDepositEvent(deposit.traderAddr, deposit.tokenCode, account.balanceE8);
401   }
402 
403   function initiateWithdraw(uint176 tokenAccountKey, uint64 amountE8) private {
404     uint64 balanceE8 = accounts[tokenAccountKey].balanceE8;
405     uint64 pendingWithdrawE8 = accounts[tokenAccountKey].pendingWithdrawE8;
406 
407     if (balanceE8 < amountE8 || amountE8 == 0) revert();
408     balanceE8 -= amountE8;
409 
410     uint64 feeE8 = calcFeeE8(amountE8, withdrawFeeRateE4, address(tokenAccountKey));
411     amountE8 -= feeE8;
412 
413     if (pendingWithdrawE8 + amountE8 < amountE8) revert();  // check overflow
414     pendingWithdrawE8 += amountE8;
415 
416     accounts[tokenAccountKey].balanceE8 = balanceE8;
417     accounts[tokenAccountKey].pendingWithdrawE8 = pendingWithdrawE8;
418 
419     // Note that the fee account has a dummy trader address of 0.
420     if (accounts[tokenAccountKey & (0xffff << 160)].pendingWithdrawE8 + feeE8 >= feeE8) {  // no overflow
421       accounts[tokenAccountKey & (0xffff << 160)].pendingWithdrawE8 += feeE8;
422     }
423 
424     emit InitiateWithdrawEvent(address(tokenAccountKey), uint16(tokenAccountKey >> 160) /*tokenCode*/,
425                                amountE8, pendingWithdrawE8);
426   }
427 
428   function getDealInfo(uint32 pairId, uint64 priceE8, uint64 amount1E8, uint64 amount2E8)
429       private pure returns (DealInfo deal) {
430     deal.stockCode = uint16(pairId);
431     deal.cashCode = uint16(pairId >> 16);
432     if (deal.stockCode == deal.cashCode) revert();  // we disallow homogeneous trading
433 
434     deal.stockDealAmountE8 = amount1E8 < amount2E8 ? amount1E8 : amount2E8;
435 
436     uint cashDealAmountE8 = uint(priceE8) * uint(deal.stockDealAmountE8) / 10**8;
437     if (cashDealAmountE8 >= 2**64) revert();
438     deal.cashDealAmountE8 = uint64(cashDealAmountE8);
439   }
440 
441   function calcFeeE8(uint64 amountE8, uint feeRateE4, address traderAddr)
442       private view returns (uint64) {
443     uint feeE8 = uint(amountE8) * feeRateE4 / 10000;
444     feeE8 -= feeE8 * uint(traders[traderAddr].feeRebatePercent) / 100;
445     return uint64(feeE8);
446   }
447 
448   function settleAccounts(DealInfo deal, address traderAddr, uint feeRateE4, bool isBuyer) private {
449     uint16 giveTokenCode = isBuyer ? deal.cashCode : deal.stockCode;
450     uint16 getTokenCode = isBuyer ? deal.stockCode : deal.cashCode;
451 
452     uint64 giveAmountE8 = isBuyer ? deal.cashDealAmountE8 : deal.stockDealAmountE8;
453     uint64 getAmountE8 = isBuyer ? deal.stockDealAmountE8 : deal.cashDealAmountE8;
454 
455     uint176 giveAccountKey = uint176(giveTokenCode) << 160 | uint176(traderAddr);
456     uint176 getAccountKey = uint176(getTokenCode) << 160 | uint176(traderAddr);
457 
458     uint64 feeE8 = calcFeeE8(getAmountE8, feeRateE4, traderAddr);
459     getAmountE8 -= feeE8;
460 
461     // Check overflow.
462     if (accounts[giveAccountKey].balanceE8 < giveAmountE8) revert();
463     if (accounts[getAccountKey].balanceE8 + getAmountE8 < getAmountE8) revert();
464 
465     // Write storage.
466     accounts[giveAccountKey].balanceE8 -= giveAmountE8;
467     accounts[getAccountKey].balanceE8 += getAmountE8;
468 
469     if (accounts[uint176(getTokenCode) << 160].pendingWithdrawE8 + feeE8 >= feeE8) {  // no overflow
470       accounts[uint176(getTokenCode) << 160].pendingWithdrawE8 += feeE8;
471     }
472   }
473 
474   function setOrders(uint224 orderKey, uint32 pairId, uint8 action, uint8 ioc,
475                      uint64 priceE8, uint64 amountE8, uint64 expireTimeSec) private {
476     orders[orderKey].pairId = pairId;
477     orders[orderKey].action = action;
478     orders[orderKey].ioc = ioc;
479     orders[orderKey].priceE8 = priceE8;
480     orders[orderKey].amountE8 = amountE8;
481     orders[orderKey].expireTimeSec = expireTimeSec;
482   }
483 
484   function matchOrder(uint224 makerOrderKey, Order makerOrder,
485                       uint224 takerOrderKey, Order takerOrder) private {
486     // Check trading conditions.
487     if (marketStatus != ACTIVE) revert();
488     if (makerOrderKey == takerOrderKey) revert();  // the two orders must not have the same key
489     if (makerOrder.pairId != takerOrder.pairId) revert();
490     if (makerOrder.action == takerOrder.action) revert();
491     if (makerOrder.priceE8 == 0 || takerOrder.priceE8 == 0) revert();
492     if (makerOrder.action == 0 && makerOrder.priceE8 < takerOrder.priceE8) revert();
493     if (takerOrder.action == 0 && takerOrder.priceE8 < makerOrder.priceE8) revert();
494     if (makerOrder.amountE8 == 0 || takerOrder.amountE8 == 0) revert();
495     if (makerOrder.expireTimeSec <= exeStatus.logicTimeSec) revert();
496     if (takerOrder.expireTimeSec <= exeStatus.logicTimeSec) revert();
497 
498     DealInfo memory deal = getDealInfo(
499         makerOrder.pairId, makerOrder.priceE8, makerOrder.amountE8, takerOrder.amountE8);
500 
501     // Update accounts.
502     settleAccounts(deal, address(makerOrderKey), makerFeeRateE4, (makerOrder.action == 0));
503     settleAccounts(deal, address(takerOrderKey), takerFeeRateE4, (takerOrder.action == 0));
504 
505     // Update orders.
506     if (makerOrder.ioc == 1) {  // IOC order
507       makerOrder.amountE8 = 0;
508     } else {
509       makerOrder.amountE8 -= deal.stockDealAmountE8;
510     }
511     if (takerOrder.ioc == 1) {  // IOC order
512       takerOrder.amountE8 = 0;
513     } else {
514       takerOrder.amountE8 -= deal.stockDealAmountE8;
515     }
516 
517     // Write orders back to storage.
518     setOrders(makerOrderKey, makerOrder.pairId, makerOrder.action, makerOrder.ioc,
519               makerOrder.priceE8, makerOrder.amountE8, makerOrder.expireTimeSec);
520     setOrders(takerOrderKey, takerOrder.pairId, takerOrder.action, takerOrder.ioc,
521               takerOrder.priceE8, takerOrder.amountE8, takerOrder.expireTimeSec);
522 
523     emit MatchOrdersEvent(address(makerOrderKey), uint64(makerOrderKey >> 160) /*nonce*/,
524                           address(takerOrderKey), uint64(takerOrderKey >> 160) /*nonce*/);
525   }
526 
527   function hardCancelOrder(uint224 orderKey) private {
528     orders[orderKey].pairId = 0xFFFFFFFF;
529     orders[orderKey].amountE8 = 0;
530     emit HardCancelOrderEvent(address(orderKey) /*traderAddr*/, uint64(orderKey >> 160) /*nonce*/);
531   }
532 
533   function setFeeRates(uint16 makerE4, uint16 takerE4, uint16 withdrawE4) private {
534     if (makerE4 > MAX_FEE_RATE_E4) revert();
535     if (takerE4 > MAX_FEE_RATE_E4) revert();
536     if (withdrawE4 > MAX_FEE_RATE_E4) revert();
537 
538     makerFeeRateE4 = makerE4;
539     takerFeeRateE4 = takerE4;
540     withdrawFeeRateE4 = withdrawE4;
541     emit SetFeeRatesEvent(makerE4, takerE4, withdrawE4);
542   }
543 
544   function setFeeRebatePercent(address traderAddr, uint8 feeRebatePercent) private {
545     if (feeRebatePercent > 100) revert();
546 
547     traders[traderAddr].feeRebatePercent = feeRebatePercent;
548     emit SetFeeRebatePercentEvent(traderAddr, feeRebatePercent);
549   }
550 
551   function parseNewOrder(uint224 orderKey, uint8 v, uint[] body, uint i) private view returns (Order) {
552     // bits: <expireTimeSec>(64) <amountE8>(64) <priceE8>(64) <ioc>(8) <action>(8) <pairId>(32)
553     uint240 bits = uint240(body[i + 1]);
554     uint64 nonce = uint64(orderKey >> 160);
555     address traderAddr = address(orderKey);
556     if (traderAddr == 0) revert();  // check zero addr early since `ecrecover` returns 0 on error
557 
558     // verify the signature of the trader
559     bytes32 hash1 = keccak256("\x19Ethereum Signed Message:\n70DEx2 Order: ", address(this), nonce, bits);
560     if (traderAddr != ecrecover(hash1, v, bytes32(body[i + 2]), bytes32(body[i + 3]))) {
561       bytes32 hashValues = keccak256("DEx2 Order", address(this), nonce, bits);
562       bytes32 hash2 = keccak256(HASHTYPES, hashValues);
563       if (traderAddr != ecrecover(hash2, v, bytes32(body[i + 2]), bytes32(body[i + 3]))) revert();
564     }
565 
566     Order memory order;
567     order.pairId = uint32(bits); bits >>= 32;
568     order.action = uint8(bits); bits >>= 8;
569     order.ioc = uint8(bits); bits >>= 8;
570     order.priceE8 = uint64(bits); bits >>= 64;
571     order.amountE8 = uint64(bits); bits >>= 64;
572     order.expireTimeSec = uint64(bits);
573     return order;
574   }
575 
576 }  // contract