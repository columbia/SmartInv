1 pragma solidity 0.4.21;
2 pragma experimental "v0.5.0";
3 
4 interface Token {
5   function totalSupply() external returns (uint256);
6   function balanceOf(address) external returns (uint256);
7   function transfer(address, uint256) external returns (bool);
8   function transferFrom(address, address, uint256) external returns (bool);
9   function approve(address, uint256) external returns (bool);
10   function allowance(address, address) external returns (uint256);
11 
12   event Transfer(address indexed _from, address indexed _to, uint256 _value);
13   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
14 }
15 
16 contract Dex2 {
17   //------------------------------ Struct Definitions: ---------------------------------------------
18 
19   struct TokenInfo {
20     string  symbol;       // e.g., "ETH", "ADX"
21     address tokenAddr;    // ERC20 token address
22     uint64  scaleFactor;  // <original token amount> = <scaleFactor> x <DEx amountE8> / 1e8
23     uint    minDeposit;   // mininum deposit (original token amount) allowed for this token
24   }
25 
26   struct TraderInfo {
27     address withdrawAddr;
28     uint8   feeRebatePercent;  // range: [0, 100]
29   }
30 
31   struct TokenAccount {
32     uint64 balanceE8;          // available amount for trading
33     uint64 pendingWithdrawE8;  // the amount to be transferred out from this contract to the trader
34   }
35 
36   struct Order {
37     uint32 pairId;  // <cashId>(16) <stockId>(16)
38     uint8  action;  // 0 means BUY; 1 means SELL
39     uint8  ioc;     // 0 means a regular order; 1 means an immediate-or-cancel (IOC) order
40     uint64 priceE8;
41     uint64 amountE8;
42     uint64 expireTimeSec;
43   }
44 
45   struct Deposit {
46     address traderAddr;
47     uint16  tokenCode;
48     uint64  pendingAmountE8;   // amount to be confirmed for trading purpose
49   }
50 
51   struct DealInfo {
52     uint16 stockCode;          // stock token code
53     uint16 cashCode;           // cash token code
54     uint64 stockDealAmountE8;
55     uint64 cashDealAmountE8;
56   }
57 
58   struct ExeStatus {
59     uint64 logicTimeSec;       // logic timestamp for checking order expiration
60     uint64 lastOperationIndex; // index of the last executed operation
61   }
62 
63   //----------------- Constants: -------------------------------------------------------------------
64 
65   uint constant MAX_UINT256 = 2**256 - 1;
66   uint16 constant MAX_FEE_RATE_E4 = 60;  // the upper limit of a fee rate is 0.6%
67 
68   // <original ETH amount in Wei> = <DEx amountE8> * <ETH_SCALE_FACTOR> / 1e8
69   uint64 constant ETH_SCALE_FACTOR = 10**18;
70 
71   uint8 constant ACTIVE = 0;
72   uint8 constant CLOSED = 2;
73 
74   bytes32 constant HASHTYPES =
75       keccak256('string title', 'address market_address', 'uint64 nonce', 'uint64 expire_time_sec',
76                 'uint64 amount_e8', 'uint64 price_e8', 'uint8 immediate_or_cancel', 'uint8 action',
77                 'uint16 cash_token_code', 'uint16 stock_token_code');
78 
79   //----------------- States that cannot be changed once set: --------------------------------------
80 
81   address public admin;                         // admin address, and it cannot be changed
82   mapping (uint16 => TokenInfo) public tokens;  // mapping of token code to token information
83 
84   //----------------- Other states: ----------------------------------------------------------------
85 
86   uint8 public marketStatus;        // market status: 0 - Active; 1 - Suspended; 2 - Closed
87 
88   uint16 public makerFeeRateE4;     // maker fee rate (* 10**4)
89   uint16 public takerFeeRateE4;     // taker fee rate (* 10**4)
90   uint16 public withdrawFeeRateE4;  // withdraw fee rate (* 10**4)
91 
92   uint64 public lastDepositIndex;   // index of the last deposit operation
93 
94   ExeStatus public exeStatus;       // status of operation execution
95 
96   mapping (address => TraderInfo) public traders;     // mapping of trade address to trader information
97   mapping (uint176 => TokenAccount) public accounts;  // mapping of trader token key to its account information
98   mapping (uint224 => Order) public orders;           // mapping of order key to order information
99   mapping (uint64  => Deposit) public deposits;       // mapping of deposit index to deposit information
100 
101   //------------------------------ Dex2 Events: ----------------------------------------------------
102 
103   event DeployMarketEvent();
104   event ChangeMarketStatusEvent(uint8 status);
105   event SetTokenInfoEvent(uint16 tokenCode, string symbol, address tokenAddr, uint64 scaleFactor, uint minDeposit);
106   event SetWithdrawAddrEvent(address trader, address withdrawAddr);
107 
108   event DepositEvent(address trader, uint16 tokenCode, string symbol, uint64 amountE8, uint64 depositIndex);
109   event WithdrawEvent(address trader, uint16 tokenCode, string symbol, uint64 amountE8, uint64 lastOpIndex);
110   event TransferFeeEvent(uint16 tokenCode, uint64 amountE8, address toAddr);
111 
112   // `balanceE8` is the total balance after this deposit confirmation
113   event ConfirmDepositEvent(address trader, uint16 tokenCode, uint64 balanceE8);
114   // `amountE8` is the post-fee initiated withdraw amount
115   // `pendingWithdrawE8` is the total pending withdraw amount after this withdraw initiation
116   event InitiateWithdrawEvent(address trader, uint16 tokenCode, uint64 amountE8, uint64 pendingWithdrawE8);
117   event MatchOrdersEvent(address trader1, uint64 nonce1, address trader2, uint64 nonce2);
118   event HardCancelOrderEvent(address trader, uint64 nonce);
119   event SetFeeRatesEvent(uint16 makerFeeRateE4, uint16 takerFeeRateE4, uint16 withdrawFeeRateE4);
120   event SetFeeRebatePercentEvent(address trader, uint8 feeRebatePercent);
121 
122   //------------------------------ Contract Initialization: ----------------------------------------
123 
124   function Dex2(address admin_) public {
125     admin = admin_;
126     setTokenInfo(0 /*tokenCode*/, "ETH", 0 /*tokenAddr*/, ETH_SCALE_FACTOR, 0 /*minDeposit*/);
127     emit DeployMarketEvent();
128   }
129 
130   //------------------------------ External Functions: ---------------------------------------------
131 
132   function() external {
133     revert();
134   }
135 
136   // Change the market status of DEX.
137   function changeMarketStatus(uint8 status_) external {
138     if (msg.sender != admin) revert();
139     if (marketStatus == CLOSED) revert();  // closed is forever
140 
141     marketStatus = status_;
142     emit ChangeMarketStatusEvent(status_);
143   }
144 
145   function setWithdrawAddr(address withdrawAddr) external {
146     if (withdrawAddr == 0) revert();
147     if (traders[msg.sender].withdrawAddr != 0) revert();  // cannot change withdrawAddr once set
148     traders[msg.sender].withdrawAddr = withdrawAddr;
149     emit SetWithdrawAddrEvent(msg.sender, withdrawAddr);
150   }
151 
152   // Deposits ETH from msg.sender for the given trader.
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
167   // Deposits token (other than ETH) from msg.sender for a specified trader.
168   //
169   // After this deposit has been confirmed enough times on the blockchain, it will be added to
170   // the trader's token account for trading.
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
181     // Remember to call Token(address).approve(this, amount) from msg.sender in advance.
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
259   function exeSequence(uint header, uint[] body) external {
260     if (msg.sender != admin) revert();
261 
262     uint64 nextOperationIndex = uint64(header);
263     if (nextOperationIndex != exeStatus.lastOperationIndex + 1) revert();  // check index
264 
265     uint64 newLogicTimeSec = uint64(header >> 64);
266     if (newLogicTimeSec < exeStatus.logicTimeSec) revert();
267 
268     for (uint i = 0; i < body.length; nextOperationIndex++) {
269       uint bits = body[i];
270       uint opcode = bits & 0xFFFF;
271       bits >>= 16;
272       if ((opcode >> 8) != 0xDE) revert();  // check the magic number
273 
274       // ConfirmDeposit: <depositIndex>(64)
275       if (opcode == 0xDE01) {
276         confirmDeposit(uint64(bits));
277         i += 1;
278         continue;
279       }
280 
281       // InitiateWithdraw: <amountE8>(64) <tokenCode>(16) <traderAddr>(160)
282       if (opcode == 0xDE02) {
283         initiateWithdraw(uint176(bits), uint64(bits >> 176));
284         i += 1;
285         continue;
286       }
287 
288       //-------- The rest operation types are allowed only when the market is active ---------
289       if (marketStatus != ACTIVE) revert();
290 
291       // MatchOrders
292       if (opcode == 0xDE03) {
293         uint8 v1 = uint8(bits);
294         bits >>= 8;            // bits is now the key of the maker order
295 
296         Order memory makerOrder;
297         if (v1 == 0) {         // the order is already in storage
298           if (i + 1 >= body.length) revert();  // at least 1 body element left
299           makerOrder = orders[uint224(bits)];
300           i += 1;
301         } else {
302           if (orders[uint224(bits)].pairId != 0) revert();  // the order must not be already in storage
303           if (i + 4 >= body.length) revert();  // at least 4 body elements left
304           makerOrder = parseNewOrder(uint224(bits) /*makerOrderKey*/, v1, body, i);
305           i += 4;
306         }
307 
308         uint8 v2 = uint8(body[i]);
309         uint224 takerOrderKey = uint224(body[i] >> 8);
310         Order memory takerOrder;
311         if (v2 == 0) {         // the order is already in storage
312           takerOrder = orders[takerOrderKey];
313           i += 1;
314         } else {
315           if (orders[takerOrderKey].pairId != 0) revert();  // the order must not be already in storage
316           if (i + 3 >= body.length) revert();  // at least 3 body elements left
317           takerOrder = parseNewOrder(takerOrderKey, v2, body, i);
318           i += 4;
319         }
320 
321         matchOrder(uint224(bits) /*makerOrderKey*/, makerOrder, takerOrderKey, takerOrder);
322         continue;
323       }
324 
325       // HardCancelOrder: <nonce>(64) <traderAddr>(160)
326       if (opcode == 0xDE04) {
327         hardCancelOrder(uint224(bits) /*orderKey*/);
328         i += 1;
329         continue;
330       }
331 
332       // SetFeeRates: <withdrawFeeRateE4>(16) <takerFeeRateE4>(16) <makerFeeRateE4>(16)
333       if (opcode == 0xDE05) {
334         setFeeRates(uint16(bits), uint16(bits >> 16), uint16(bits >> 32));
335         i += 1;
336         continue;
337       }
338 
339       // SetFeeRebatePercent: <rebatePercent>(8) <traderAddr>(160)
340       if (opcode == 0xDE06) {
341         setFeeRebatePercent(address(bits) /*traderAddr*/, uint8(bits >> 160) /*rebatePercent*/);
342         i += 1;
343         continue;
344       }
345     } // for loop
346 
347     setExeStatus(newLogicTimeSec, nextOperationIndex - 1);
348   } // function exeSequence
349 
350   //------------------------------ Public Functions: -----------------------------------------------
351 
352   // Set token information.
353   function setTokenInfo(uint16 tokenCode, string symbol, address tokenAddr, uint64 scaleFactor,
354                         uint minDeposit) public {
355     if (msg.sender != admin) revert();
356     if (marketStatus != ACTIVE) revert();
357     if (scaleFactor == 0) revert();
358 
359     TokenInfo memory info = tokens[tokenCode];
360     if (info.scaleFactor != 0) {  // this token already exists
361       // For an existing token only the minDeposit field can be updated.
362       tokens[tokenCode].minDeposit = minDeposit;
363       emit SetTokenInfoEvent(tokenCode, info.symbol, info.tokenAddr, info.scaleFactor, minDeposit);
364       return;
365     }
366 
367     tokens[tokenCode].symbol = symbol;
368     tokens[tokenCode].tokenAddr = tokenAddr;
369     tokens[tokenCode].scaleFactor = scaleFactor;
370     tokens[tokenCode].minDeposit = minDeposit;
371     emit SetTokenInfoEvent(tokenCode, symbol, tokenAddr, scaleFactor, minDeposit);
372   }
373 
374   //------------------------------ Private Functions: ----------------------------------------------
375 
376   function setDeposits(uint64 depositIndex, address traderAddr, uint16 tokenCode, uint64 amountE8) private {
377     deposits[depositIndex].traderAddr = traderAddr;
378     deposits[depositIndex].tokenCode = tokenCode;
379     deposits[depositIndex].pendingAmountE8 = amountE8;
380   }
381 
382   function setExeStatus(uint64 logicTimeSec, uint64 lastOperationIndex) private {
383     exeStatus.logicTimeSec = logicTimeSec;
384     exeStatus.lastOperationIndex = lastOperationIndex;
385   }
386 
387   function confirmDeposit(uint64 depositIndex) private {
388     Deposit memory deposit = deposits[depositIndex];
389     uint176 accountKey = (uint176(deposit.tokenCode) << 160) | uint176(deposit.traderAddr);
390     TokenAccount memory account = accounts[accountKey];
391 
392     // Check that pending amount is non-zero and no overflow would happen.
393     if (account.balanceE8 + deposit.pendingAmountE8 <= account.balanceE8) revert();
394     account.balanceE8 += deposit.pendingAmountE8;
395 
396     deposits[depositIndex].pendingAmountE8 = 0;
397     accounts[accountKey].balanceE8 += deposit.pendingAmountE8;
398     emit ConfirmDepositEvent(deposit.traderAddr, deposit.tokenCode, account.balanceE8);
399   }
400 
401   function initiateWithdraw(uint176 tokenAccountKey, uint64 amountE8) private {
402     uint64 balanceE8 = accounts[tokenAccountKey].balanceE8;
403     uint64 pendingWithdrawE8 = accounts[tokenAccountKey].pendingWithdrawE8;
404 
405     if (balanceE8 < amountE8 || amountE8 == 0) revert();
406     balanceE8 -= amountE8;
407 
408     uint64 feeE8 = calcFeeE8(amountE8, withdrawFeeRateE4, address(tokenAccountKey));
409     amountE8 -= feeE8;
410 
411     if (pendingWithdrawE8 + amountE8 < amountE8) revert();  // check overflow
412     pendingWithdrawE8 += amountE8;
413 
414     accounts[tokenAccountKey].balanceE8 = balanceE8;
415     accounts[tokenAccountKey].pendingWithdrawE8 = pendingWithdrawE8;
416 
417     // Note that the fee account has a dummy trader address of 0.
418     if (accounts[tokenAccountKey & (0xffff << 160)].pendingWithdrawE8 + feeE8 >= feeE8) {  // no overflow
419       accounts[tokenAccountKey & (0xffff << 160)].pendingWithdrawE8 += feeE8;
420     }
421 
422     emit InitiateWithdrawEvent(address(tokenAccountKey), uint16(tokenAccountKey >> 160) /*tokenCode*/,
423                                amountE8, pendingWithdrawE8);
424   }
425 
426   function getDealInfo(uint32 pairId, uint64 priceE8, uint64 amount1E8, uint64 amount2E8)
427       private pure returns (DealInfo deal) {
428     deal.stockCode = uint16(pairId);
429     deal.cashCode = uint16(pairId >> 16);
430     if (deal.stockCode == deal.cashCode) revert();  // we disallow homogeneous trading
431 
432     deal.stockDealAmountE8 = amount1E8 < amount2E8 ? amount1E8 : amount2E8;
433 
434     uint cashDealAmountE8 = uint(priceE8) * uint(deal.stockDealAmountE8) / 10**8;
435     if (cashDealAmountE8 >= 2**64) revert();
436     deal.cashDealAmountE8 = uint64(cashDealAmountE8);
437   }
438 
439   function calcFeeE8(uint64 amountE8, uint feeRateE4, address traderAddr)
440       private view returns (uint64) {
441     uint feeE8 = uint(amountE8) * feeRateE4 / 10000;
442     feeE8 -= feeE8 * uint(traders[traderAddr].feeRebatePercent) / 100;
443     return uint64(feeE8);
444   }
445 
446   function settleAccounts(DealInfo deal, address traderAddr, uint feeRateE4, bool isBuyer) private {
447     uint16 giveTokenCode = isBuyer ? deal.cashCode : deal.stockCode;
448     uint16 getTokenCode = isBuyer ? deal.stockCode : deal.cashCode;
449 
450     uint64 giveAmountE8 = isBuyer ? deal.cashDealAmountE8 : deal.stockDealAmountE8;
451     uint64 getAmountE8 = isBuyer ? deal.stockDealAmountE8 : deal.cashDealAmountE8;
452 
453     uint176 giveAccountKey = uint176(giveTokenCode) << 160 | uint176(traderAddr);
454     uint176 getAccountKey = uint176(getTokenCode) << 160 | uint176(traderAddr);
455 
456     uint64 feeE8 = calcFeeE8(getAmountE8, feeRateE4, traderAddr);
457     getAmountE8 -= feeE8;
458 
459     // Check overflow.
460     if (accounts[giveAccountKey].balanceE8 < giveAmountE8) revert();
461     if (accounts[getAccountKey].balanceE8 + getAmountE8 < getAmountE8) revert();
462 
463     // Write storage.
464     accounts[giveAccountKey].balanceE8 -= giveAmountE8;
465     accounts[getAccountKey].balanceE8 += getAmountE8;
466 
467     if (accounts[uint176(getTokenCode) << 160].pendingWithdrawE8 + feeE8 >= feeE8) {  // no overflow
468       accounts[uint176(getTokenCode) << 160].pendingWithdrawE8 += feeE8;
469     }
470   }
471 
472   function setOrders(uint224 orderKey, uint32 pairId, uint8 action, uint8 ioc,
473                      uint64 priceE8, uint64 amountE8, uint64 expireTimeSec) private {
474     orders[orderKey].pairId = pairId;
475     orders[orderKey].action = action;
476     orders[orderKey].ioc = ioc;
477     orders[orderKey].priceE8 = priceE8;
478     orders[orderKey].amountE8 = amountE8;
479     orders[orderKey].expireTimeSec = expireTimeSec;
480   }
481 
482   function matchOrder(uint224 makerOrderKey, Order makerOrder,
483                       uint224 takerOrderKey, Order takerOrder) private {
484     // Check trading conditions.
485     if (marketStatus != ACTIVE) revert();
486     if (makerOrderKey == takerOrderKey) revert();  // the two orders must not have the same key
487     if (makerOrder.pairId != takerOrder.pairId) revert();
488     if (makerOrder.action == takerOrder.action) revert();
489     if (makerOrder.priceE8 == 0 || takerOrder.priceE8 == 0) revert();
490     if (makerOrder.action == 0 && makerOrder.priceE8 < takerOrder.priceE8) revert();
491     if (takerOrder.action == 0 && takerOrder.priceE8 < makerOrder.priceE8) revert();
492     if (makerOrder.amountE8 == 0 || takerOrder.amountE8 == 0) revert();
493     if (makerOrder.expireTimeSec <= exeStatus.logicTimeSec) revert();
494     if (takerOrder.expireTimeSec <= exeStatus.logicTimeSec) revert();
495 
496     DealInfo memory deal = getDealInfo(
497         makerOrder.pairId, makerOrder.priceE8, makerOrder.amountE8, takerOrder.amountE8);
498 
499     // Update accounts.
500     settleAccounts(deal, address(makerOrderKey), makerFeeRateE4, (makerOrder.action == 0));
501     settleAccounts(deal, address(takerOrderKey), takerFeeRateE4, (takerOrder.action == 0));
502 
503     // Update orders.
504     if (makerOrder.ioc == 1) {  // IOC order
505       makerOrder.amountE8 = 0;
506     } else {
507       makerOrder.amountE8 -= deal.stockDealAmountE8;
508     }
509     if (takerOrder.ioc == 1) {  // IOC order
510       takerOrder.amountE8 = 0;
511     } else {
512       takerOrder.amountE8 -= deal.stockDealAmountE8;
513     }
514 
515     // Write orders back to storage.
516     setOrders(makerOrderKey, makerOrder.pairId, makerOrder.action, makerOrder.ioc,
517               makerOrder.priceE8, makerOrder.amountE8, makerOrder.expireTimeSec);
518     setOrders(takerOrderKey, takerOrder.pairId, takerOrder.action, takerOrder.ioc,
519               takerOrder.priceE8, takerOrder.amountE8, takerOrder.expireTimeSec);
520 
521     emit MatchOrdersEvent(address(makerOrderKey), uint64(makerOrderKey >> 160) /*nonce*/,
522                           address(takerOrderKey), uint64(takerOrderKey >> 160) /*nonce*/);
523   }
524 
525   function hardCancelOrder(uint224 orderKey) private {
526     orders[orderKey].pairId = 0xFFFFFFFF;
527     orders[orderKey].amountE8 = 0;
528     emit HardCancelOrderEvent(address(orderKey) /*traderAddr*/, uint64(orderKey >> 160) /*nonce*/);
529   }
530 
531   function setFeeRates(uint16 makerE4, uint16 takerE4, uint16 withdrawE4) private {
532     if (makerE4 > MAX_FEE_RATE_E4) revert();
533     if (takerE4 > MAX_FEE_RATE_E4) revert();
534     if (withdrawE4 > MAX_FEE_RATE_E4) revert();
535 
536     makerFeeRateE4 = makerE4;
537     takerFeeRateE4 = takerE4;
538     withdrawFeeRateE4 = withdrawE4;
539     emit SetFeeRatesEvent(makerE4, takerE4, withdrawE4);
540   }
541 
542   function setFeeRebatePercent(address traderAddr, uint8 feeRebatePercent) private {
543     if (feeRebatePercent > 100) revert();
544 
545     traders[traderAddr].feeRebatePercent = feeRebatePercent;
546     emit SetFeeRebatePercentEvent(traderAddr, feeRebatePercent);
547   }
548 
549   function parseNewOrder(uint224 orderKey, uint8 v, uint[] body, uint i) private view returns (Order) {
550     // bits: <expireTimeSec>(64) <amountE8>(64) <priceE8>(64) <ioc>(8) <action>(8) <pairId>(32)
551     uint240 bits = uint240(body[i + 1]);
552     uint64 nonce = uint64(orderKey >> 160);
553     address traderAddr = address(orderKey);
554     if (traderAddr == 0) revert();  // check zero addr early since `ecrecover` returns 0 on error
555 
556     // verify the signature of the trader
557     bytes32 hash1 = keccak256("\x19Ethereum Signed Message:\n70DEx2 Order: ", address(this), nonce, bits);
558     if (traderAddr != ecrecover(hash1, v, bytes32(body[i + 2]), bytes32(body[i + 3]))) {
559       bytes32 hashValues = keccak256("DEx2 Order", address(this), nonce, bits);
560       bytes32 hash2 = keccak256(HASHTYPES, hashValues);
561       if (traderAddr != ecrecover(hash2, v, bytes32(body[i + 2]), bytes32(body[i + 3]))) revert();
562     }
563 
564     Order memory order;
565     order.pairId = uint32(bits); bits >>= 32;
566     order.action = uint8(bits); bits >>= 8;
567     order.ioc = uint8(bits); bits >>= 8;
568     order.priceE8 = uint64(bits); bits >>= 64;
569     order.amountE8 = uint64(bits); bits >>= 64;
570     order.expireTimeSec = uint64(bits);
571     return order;
572   }
573 
574 }  // contract