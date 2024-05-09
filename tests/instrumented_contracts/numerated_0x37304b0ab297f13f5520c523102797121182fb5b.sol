1 pragma solidity ^0.4.18;
2 
3 contract SportCrypt {
4     address private owner;
5     mapping(address => bool) private admins;
6 
7     function SportCrypt() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner() {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function changeOwner(address newOwner) external onlyOwner {
17         owner = newOwner;
18     }
19 
20     function addAdmin(address addr) external onlyOwner {
21         admins[addr] = true;
22     }
23 
24     function removeAdmin(address addr) external onlyOwner {
25         admins[addr] = false;
26     }
27 
28 
29     // Events
30 
31     event LogBalanceChange(address indexed account, uint oldAmount, uint newAmount);
32     event LogDeposit(address indexed account);
33     event LogWithdraw(address indexed account);
34     event LogTrade(address indexed takerAccount, address indexed makerAccount, uint indexed matchId, uint orderHash, uint8 orderDirection, uint8 price, uint longAmount, int newLongPosition, uint shortAmount, int newShortPosition);
35     event LogTradeError(address indexed takerAccount, address indexed makerAccount, uint indexed matchId, uint orderHash, uint16 status);
36     event LogOrderCancel(address indexed account, uint indexed matchId, uint orderHash);
37     event LogFinalizeMatch(uint indexed matchId, uint8 finalPrice);
38     event LogClaim(address indexed account, uint indexed matchId, uint amount);
39 
40 
41     // Storage
42 
43     struct Match {
44         mapping(address => int) positions;
45         uint64 firstTradeTimestamp;
46         bool finalized;
47         uint8 finalPrice;
48     }
49 
50     mapping(address => uint) private balances;
51     mapping(uint => Match) private matches;
52     mapping(uint => uint) private filledAmounts;
53 
54 
55     // Memory
56 
57     uint constant MAX_SANE_AMOUNT = 2**128;
58 
59     enum Status {
60         OK,
61         MATCH_FINALIZED,
62         ORDER_EXPIRED,
63         ORDER_MALFORMED,
64         ORDER_BAD_SIG,
65         AMOUNT_MALFORMED,
66         SELF_TRADE,
67         ZERO_VALUE_TRADE
68     }
69 
70     struct Order {
71         uint orderHash;
72         uint matchId;
73         uint amount;
74         uint expiry;
75         address addr;
76         uint8 price;
77         uint8 direction;
78     }
79 
80     // [0]: match hash
81     // [1]: amount
82     // [2]: 5-byte expiry, 5-byte nonce, 1-byte price, 1-byte direction, 20-byte address
83 
84     function parseOrder(uint[3] memory rawOrder) private constant returns(Order memory o) {
85         o.orderHash = uint(keccak256(this, rawOrder));
86 
87         o.matchId = rawOrder[0];
88         o.amount = rawOrder[1];
89 
90         uint packed = rawOrder[2];
91         o.expiry = packed >> (8*27);
92         o.addr = address(packed & 0x00ffffffffffffffffffffffffffffffffffffffff);
93         o.price = uint8((packed >> (8*21)) & 0xff);
94         o.direction = uint8((packed >> (8*20)) & 0xff);
95     }
96 
97     function validateOrderParams(Order memory o) private pure returns(bool) {
98         if (o.amount > MAX_SANE_AMOUNT) return false;
99         if (o.price == 0 || o.price > 99) return false;
100         if (o.direction > 1) return false;
101         return true;
102     }
103 
104     function validateOrderSig(Order memory o, bytes32 r, bytes32 s, uint8 v) private pure returns(bool) {
105         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", o.orderHash), v, r, s) != o.addr) return false;
106         return true;
107     }
108 
109     struct Trade {
110         Status status;
111         address longAddr;
112         address shortAddr;
113         int newLongPosition;
114         int newShortPosition;
115         int longBalanceDelta;
116         int shortBalanceDelta;
117         uint shortAmount;
118         uint longAmount;
119     }
120 
121 
122     // User methods
123 
124     function() external payable {
125         revert();
126     }
127 
128     function deposit() external payable {
129         if (msg.value > 0) {
130             uint origAmount = balances[msg.sender];
131             uint newAmount = safeAdd(origAmount, msg.value);
132             balances[msg.sender] = newAmount;
133 
134             LogDeposit(msg.sender);
135             LogBalanceChange(msg.sender, origAmount, newAmount);
136         }
137     }
138 
139     function withdraw(uint amount) external {
140         uint origAmount = balances[msg.sender];
141         uint amountToWithdraw = minu256(origAmount, amount);
142 
143         if (amountToWithdraw > 0) {
144             uint newAmount = origAmount - amountToWithdraw;
145             balances[msg.sender] = newAmount;
146 
147             LogWithdraw(msg.sender);
148             LogBalanceChange(msg.sender, origAmount, newAmount);
149 
150             msg.sender.transfer(amountToWithdraw);
151         }
152     }
153 
154     function cancelOrder(uint[3] order, bytes32 r, bytes32 s, uint8 v) external {
155         Order memory o = parseOrder(order);
156 
157         // Don't bother validating order params.
158         require(validateOrderSig(o, r, s, v));
159         require(o.addr == msg.sender);
160 
161         if (block.timestamp < o.expiry) {
162             filledAmounts[o.orderHash] = o.amount;
163             LogOrderCancel(msg.sender, o.matchId, o.orderHash);
164         }
165     }
166 
167     function trade(uint amount, uint[3] order, bytes32 r, bytes32 s, uint8 v) external {
168         Order memory o = parseOrder(order);
169 
170         if (!validateOrderParams(o)) {
171             LogTradeError(msg.sender, o.addr, o.matchId, o.orderHash, uint16(Status.ORDER_MALFORMED));
172             return;
173         }
174 
175         if (!validateOrderSig(o, r, s, v)) {
176             LogTradeError(msg.sender, o.addr, o.matchId, o.orderHash, uint16(Status.ORDER_BAD_SIG));
177             return;
178         }
179 
180         Trade memory t = tradeCore(amount, o);
181 
182         if (t.status != Status.OK) {
183             LogTradeError(msg.sender, o.addr, o.matchId, o.orderHash, uint16(t.status));
184             return;
185         }
186 
187         // Modify storage to reflect trade:
188 
189         var m = matches[o.matchId];
190 
191         if (m.firstTradeTimestamp == 0) {
192             assert(block.timestamp > 0);
193             m.firstTradeTimestamp = uint64(block.timestamp);
194         }
195 
196         m.positions[t.longAddr] = t.newLongPosition;
197         m.positions[t.shortAddr] = t.newShortPosition;
198 
199         adjustBalance(t.longAddr, t.longBalanceDelta);
200         adjustBalance(t.shortAddr, t.shortBalanceDelta);
201 
202         filledAmounts[o.orderHash] += (o.direction == 0 ? t.shortAmount : t.longAmount);
203 
204         LogTrade(msg.sender, o.addr, o.matchId, o.orderHash, o.direction, o.price, t.longAmount, t.newLongPosition, t.shortAmount, t.newShortPosition);
205     }
206 
207     function claim(uint matchId, uint8 finalPrice, bytes32 r, bytes32 s, uint8 v) external {
208         var m = matches[matchId];
209 
210         if (m.finalized) {
211             require(m.finalPrice == finalPrice);
212         } else {
213             uint messageHash = uint(keccak256(this, matchId, finalPrice));
214             address signer = ecrecover(keccak256("\x19Ethereum Signed Message:\n32", messageHash), v, r, s);
215             require(admins[signer]);
216             require(finalPrice <= 100);
217 
218             m.finalized = true;
219             m.finalPrice = finalPrice;
220             LogFinalizeMatch(matchId, finalPrice);
221         }
222 
223         // NOTE: final prices other than 0 and 100 may leave very small amounts of unrecoverable dust in the contract due to rounding.
224 
225         int delta = 0;
226         int senderPosition = m.positions[msg.sender];
227 
228         if (senderPosition > 0) {
229             delta = priceDivide(senderPosition, finalPrice);
230         } else if (senderPosition < 0) {
231             delta = priceDivide(-senderPosition, 100 - finalPrice);
232         } else {
233             return;
234         }
235 
236         assert(delta >= 0);
237 
238         m.positions[msg.sender] = 0;
239         adjustBalance(msg.sender, delta);
240 
241         LogClaim(msg.sender, matchId, uint(delta));
242     }
243 
244     function recoverFunds(uint matchId) external {
245         var m = matches[matchId];
246 
247         if (m.finalized || m.firstTradeTimestamp == 0) {
248             return;
249         }
250 
251         uint recoveryTimestamp = uint(m.firstTradeTimestamp) + ((matchId & 0xFF) * 7 * 86400);
252 
253         if (uint(block.timestamp) > recoveryTimestamp) {
254             uint8 finalPrice = uint8((matchId & 0xFF00) >> 8);
255             require(finalPrice <= 100);
256 
257             m.finalized = true;
258             m.finalPrice = finalPrice;
259             LogFinalizeMatch(matchId, finalPrice);
260         }
261     }
262 
263 
264     // Private utilities
265 
266     function adjustBalance(address addr, int delta) private {
267         uint origAmount = balances[addr];
268         uint newAmount = delta >= 0 ? safeAdd(origAmount, uint(delta)) : safeSub(origAmount, uint(-delta));
269         balances[addr] = newAmount;
270 
271         LogBalanceChange(addr, origAmount, newAmount);
272     }
273 
274     function priceDivide(int amount, uint8 price) private pure returns(int) {
275         assert(amount >= 0);
276         return int(safeMul(uint(amount), price) / 100);
277     }
278 
279     function computeEffectiveBalance(uint balance, int position, uint8 price, bool isLong) private pure returns(uint) {
280         uint effectiveBalance = balance;
281 
282         if (isLong) {
283             if (position < 0) effectiveBalance += uint(priceDivide(-position, price));
284         } else {
285             if (position > 0) effectiveBalance += uint(priceDivide(position, 100 - price));
286         }
287 
288         return effectiveBalance;
289     }
290 
291     function computePriceWeightedAmounts(uint longAmount, uint shortAmount, uint price) private pure returns(uint, uint) {
292         uint totalLongAmount;
293         uint totalShortAmount;
294 
295         totalLongAmount = longAmount + (safeMul(longAmount, 100 - price) / price);
296         totalShortAmount = shortAmount + (safeMul(shortAmount, price) / (100 - price));
297 
298         if (totalLongAmount > totalShortAmount) {
299             return (totalShortAmount - shortAmount, shortAmount);
300         } else {
301             return (longAmount, totalLongAmount - longAmount);
302         }
303     }
304 
305     function computeExposureDelta(int longBalanceDelta, int shortBalanceDelta, int oldLongPosition, int newLongPosition, int oldShortPosition, int newShortPosition) private pure returns(int) {
306         int positionDelta = 0;
307         if (newLongPosition > 0) positionDelta += newLongPosition - max256(0, oldLongPosition);
308         if (oldShortPosition > 0) positionDelta -= oldShortPosition - max256(0, newShortPosition);
309 
310         return positionDelta + longBalanceDelta + shortBalanceDelta;
311     }
312 
313     function tradeCore(uint amount, Order memory o) private constant returns(Trade t) {
314         var m = matches[o.matchId];
315 
316         if (block.timestamp >= o.expiry) {
317             t.status = Status.ORDER_EXPIRED;
318             return;
319         }
320 
321         if (m.finalized) {
322             t.status = Status.MATCH_FINALIZED;
323             return;
324         }
325 
326         if (msg.sender == o.addr) {
327             t.status = Status.SELF_TRADE;
328             return;
329         }
330 
331         if (amount > MAX_SANE_AMOUNT) {
332             t.status = Status.AMOUNT_MALFORMED;
333             return;
334         }
335 
336         t.status = Status.OK;
337 
338 
339         uint longAmount;
340         uint shortAmount;
341 
342         if (o.direction == 0) {
343             // maker short, taker long
344             t.longAddr = msg.sender;
345             longAmount = amount;
346 
347             t.shortAddr = o.addr;
348             shortAmount = safeSub(o.amount, filledAmounts[o.orderHash]);
349         } else {
350             // maker long, taker short 
351             t.longAddr = o.addr;
352             longAmount = safeSub(o.amount, filledAmounts[o.orderHash]);
353 
354             t.shortAddr = msg.sender;
355             shortAmount = amount;
356         }
357 
358         int oldLongPosition = m.positions[t.longAddr];
359         int oldShortPosition = m.positions[t.shortAddr];
360 
361         longAmount = minu256(longAmount, computeEffectiveBalance(balances[t.longAddr], oldLongPosition, o.price, true));
362         shortAmount = minu256(shortAmount, computeEffectiveBalance(balances[t.shortAddr], oldShortPosition, o.price, false));
363 
364         (longAmount, shortAmount) = computePriceWeightedAmounts(longAmount, shortAmount, o.price);
365 
366         if (longAmount == 0 || shortAmount == 0) {
367             t.status = Status.ZERO_VALUE_TRADE;
368             return;
369         }
370 
371 
372         int newLongPosition = oldLongPosition + (int(longAmount) + int(shortAmount));
373         int newShortPosition = oldShortPosition - (int(longAmount) + int(shortAmount));
374 
375 
376         t.longBalanceDelta = 0;
377         t.shortBalanceDelta = 0;
378 
379         if (oldLongPosition < 0) t.longBalanceDelta += priceDivide(-oldLongPosition + min256(0, newLongPosition), 100 - o.price);
380         if (newLongPosition > 0) t.longBalanceDelta -= priceDivide(newLongPosition - max256(0, oldLongPosition), o.price);
381 
382         if (oldShortPosition > 0) t.shortBalanceDelta += priceDivide(oldShortPosition - max256(0, newShortPosition), o.price);
383         if (newShortPosition < 0) t.shortBalanceDelta -= priceDivide(-newShortPosition + min256(0, oldShortPosition), 100 - o.price);
384 
385         int exposureDelta = computeExposureDelta(t.longBalanceDelta, t.shortBalanceDelta, oldLongPosition, newLongPosition, oldShortPosition, newShortPosition);
386 
387         if (exposureDelta != 0) {
388             if (exposureDelta == 1) {
389                 newLongPosition--;
390                 newShortPosition++;
391             } else if (exposureDelta == -1) {
392                 t.longBalanceDelta++; // one left-over wei: arbitrarily give it to long
393             } else {
394                 assert(false);
395             }
396 
397             exposureDelta = computeExposureDelta(t.longBalanceDelta, t.shortBalanceDelta, oldLongPosition, newLongPosition, oldShortPosition, newShortPosition);
398             assert(exposureDelta == 0);
399         }
400 
401 
402         t.newLongPosition = newLongPosition;
403         t.newShortPosition = newShortPosition;
404         t.shortAmount = shortAmount;
405         t.longAmount = longAmount;
406     }
407 
408 
409     // External views
410 
411     function getOwner() external view returns(address) {
412         return owner;
413     }
414 
415     function isAdmin(address addr) external view returns(bool) {
416         return admins[addr];
417     }
418 
419     function getBalance(address addr) external view returns(uint) {
420         return balances[addr];
421     }
422 
423     function getMatchInfo(uint matchId) external view returns(uint64, bool, uint8) {
424         var m = matches[matchId];
425         return (m.firstTradeTimestamp, m.finalized, m.finalPrice);
426     }
427 
428     function getPosition(uint matchId, address addr) external view returns(int) {
429         return matches[matchId].positions[addr];
430     }
431 
432     function getFilledAmount(uint orderHash) external view returns(uint) {
433         return filledAmounts[orderHash];
434     }
435 
436     function checkMatchBatch(address myAddr, uint[16] matchIds) external view returns(int[16] myPosition, bool[16] finalized, uint8[16] finalPrice) {
437         for (uint i = 0; i < 16; i++) {
438             if (matchIds[i] == 0) break;
439 
440             var m = matches[matchIds[i]];
441 
442             myPosition[i] = m.positions[myAddr];
443             finalized[i] = m.finalized;
444             finalPrice[i] = m.finalPrice;
445         }
446     }
447 
448     function checkOrderBatch(uint[48] input) external view returns(uint16[16] status, uint[16] amount) {
449         for (uint i = 0; i < 16; i++) {
450             uint[3] memory rawOrder;
451             rawOrder[0] = input[(i*3)];
452             rawOrder[1] = input[(i*3) + 1];
453             rawOrder[2] = input[(i*3) + 2];
454 
455             if (rawOrder[0] == 0) break;
456 
457             Order memory o = parseOrder(rawOrder);
458 
459             if (!validateOrderParams(o)) {
460                 status[i] = uint16(Status.ORDER_MALFORMED);
461                 amount[i] = 0;
462                 continue;
463             }
464 
465             // Not validating order signatures or timestamps: should be done by clients
466 
467             var m = matches[o.matchId];
468 
469             if (m.finalized) {
470                 status[i] = uint16(Status.MATCH_FINALIZED);
471                 amount[i] = 0;
472                 continue;
473             }
474 
475             uint longAmount;
476             uint shortAmount;
477 
478             if (o.direction == 0) {
479                 shortAmount = safeSub(o.amount, filledAmounts[o.orderHash]);
480                 longAmount = safeMul(shortAmount, 100);
481                 shortAmount = minu256(shortAmount, computeEffectiveBalance(balances[o.addr], m.positions[o.addr], o.price, false));
482                 (longAmount, shortAmount) = computePriceWeightedAmounts(longAmount, shortAmount, o.price);
483                 status[i] = uint16(Status.OK);
484                 amount[i] = shortAmount;
485             } else {
486                 longAmount = safeSub(o.amount, filledAmounts[o.orderHash]);
487                 shortAmount = safeMul(longAmount, 100);
488                 longAmount = minu256(longAmount, computeEffectiveBalance(balances[o.addr], m.positions[o.addr], o.price, true));
489                 (longAmount, shortAmount) = computePriceWeightedAmounts(longAmount, shortAmount, o.price);
490                 status[i] = uint16(Status.OK);
491                 amount[i] = longAmount;
492             }
493         }
494     }
495 
496 
497     // Math utilities
498 
499     function safeMul(uint a, uint b) private pure returns(uint) {
500         uint c = a * b;
501         assert(a == 0 || c / a == b);
502         return c;
503     }
504 
505     function safeSub(uint a, uint b) private pure returns(uint) {
506         assert(b <= a);
507         return a - b;
508     }
509 
510     function safeAdd(uint a, uint b) private pure returns(uint) {
511         uint c = a + b;
512         assert(c >= a && c >= b);
513         return c;
514     }
515 
516     function minu256(uint a, uint b) private pure returns(uint) {
517         return a < b ? a : b;
518     }
519 
520     function max256(int a, int b) private pure returns(int) {
521         return a >= b ? a : b;
522     }
523 
524     function min256(int a, int b) private pure returns(int) {
525         return a < b ? a : b;
526     }
527 }