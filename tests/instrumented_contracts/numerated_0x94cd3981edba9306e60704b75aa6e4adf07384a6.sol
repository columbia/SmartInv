1 /* A contract to store goods with escrowed funds. */
2 
3 /* Deployment:
4 Contract:
5 Owner: seller
6 Last address: dynamic
7 ABI: [{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"escrows","outputs":[{"name":"buyer","type":"address"},{"name":"lockedFunds","type":"uint256"},{"name":"frozenFunds","type":"uint256"},{"name":"frozenTime","type":"uint64"},{"name":"count","type":"uint16"},{"name":"buyerNo","type":"bool"},{"name":"sellerNo","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"count","outputs":[{"name":"","type":"uint16"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_dataInfo","type":"string"},{"name":"_version","type":"uint256"}],"name":"cancel","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"seller","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"freezePeriod","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_lockId","type":"uint256"},{"name":"_dataInfo","type":"string"},{"name":"_version","type":"uint256"},{"name":"_count","type":"uint16"}],"name":"buy","outputs":[],"payable":true,"type":"function"},{"constant":true,"inputs":[],"name":"status","outputs":[{"name":"","type":"uint16"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"rewardPromille","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_lockId","type":"uint256"}],"name":"getMoney","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_lockId","type":"uint256"},{"name":"_dataInfo","type":"string"},{"name":"_version","type":"uint256"}],"name":"no","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"kill","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_lockId","type":"uint256"},{"name":"_dataInfo","type":"string"},{"name":"_version","type":"uint256"}],"name":"reject","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_lockId","type":"uint256"},{"name":"_dataInfo","type":"string"},{"name":"_version","type":"uint256"}],"name":"accept","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalEscrows","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_lockId","type":"uint256"},{"name":"_who","type":"address"},{"name":"_payment","type":"uint256"},{"name":"_dataInfo","type":"string"},{"name":"_version","type":"uint256"}],"name":"arbYes","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"feeFunds","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_lockId","type":"uint256"},{"name":"_dataInfo","type":"string"},{"name":"_version","type":"uint256"}],"name":"yes","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"buyers","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"availableCount","outputs":[{"name":"","type":"uint16"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"price","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"contentCount","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"logsCount","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"unbuy","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"getFees","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"feePromille","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"pendingCount","outputs":[{"name":"","type":"uint16"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_dataInfo","type":"string"},{"name":"_version","type":"uint256"}],"name":"addDescription","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"arbiter","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"inputs":[{"name":"_arbiter","type":"address"},{"name":"_freezePeriod","type":"uint256"},{"name":"_feePromille","type":"uint256"},{"name":"_rewardPromille","type":"uint256"},{"name":"_count","type":"uint16"},{"name":"_price","type":"uint256"}],"type":"constructor"},{"payable":false,"type":"fallback"},{"anonymous":false,"inputs":[{"indexed":false,"name":"message","type":"string"}],"name":"LogDebug","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"lockId","type":"uint256"},{"indexed":false,"name":"dataInfo","type":"string"},{"indexed":true,"name":"version","type":"uint256"},{"indexed":false,"name":"eventType","type":"uint16"},{"indexed":true,"name":"sender","type":"address"},{"indexed":false,"name":"count","type":"uint256"},{"indexed":false,"name":"payment","type":"uint256"}],"name":"LogEvent","type":"event"}]
8 Optimized: yes
9 Solidity version: v0.4.4
10 */
11 
12 pragma solidity ^0.4.0;
13 
14 contract EscrowGoods {
15 
16     struct EscrowInfo {
17 
18         address buyer;
19         uint lockedFunds;
20         uint frozenFunds;
21         uint64 frozenTime;
22         uint16 count;
23         bool buyerNo;
24         bool sellerNo;
25     }
26 
27     //enum GoodsStatus
28     uint16 constant internal None = 0;
29     uint16 constant internal Available = 1;
30     uint16 constant internal Canceled = 2;
31 
32     //enum EventTypes
33     uint16 constant internal Buy = 1;
34     uint16 constant internal Accept = 2;
35     uint16 constant internal Reject = 3;
36     uint16 constant internal Cancel = 4;
37     uint16 constant internal Description = 10;
38     uint16 constant internal Unlock = 11;
39     uint16 constant internal Freeze = 12;
40     uint16 constant internal Resolved = 13;
41 
42     //data
43 
44     uint constant arbitrationPeriod = 30 days;
45     uint constant safeGas = 25000;
46 
47     //seller/owner of the goods
48     address public seller;
49 
50     //event counters
51     uint public contentCount = 0;
52     uint public logsCount = 0;
53 
54     //escrow related
55 
56     address public arbiter;
57 
58     uint public freezePeriod;
59     //each lock fee in promilles.
60     uint public feePromille;
61     //reward in promilles. promille = percent * 10, eg 1,5% reward = 15 rewardPromille
62     uint public rewardPromille;
63 
64     uint public feeFunds;
65     uint public totalEscrows;
66 
67     mapping (uint => EscrowInfo) public escrows;
68 
69     //goods related
70 
71     //status of the goods: see GoodsStatus enum
72     uint16 public status;
73     //how many for sale
74     uint16 public count;
75 
76     uint16 public availableCount;
77     uint16 public pendingCount;
78 
79     //price per item
80     uint public price;
81 
82     mapping (address => bool) public buyers;
83 
84     bool private atomicLock;
85 
86     //events
87 
88     event LogDebug(string message);
89     event LogEvent(uint indexed lockId, string dataInfo, uint indexed version, uint16 eventType, address indexed sender, uint count, uint payment);
90 
91     modifier onlyOwner {
92         if (msg.sender != seller)
93           throw;
94         _;
95     }
96 
97     modifier onlyArbiter {
98         if (msg.sender != arbiter)
99           throw;
100         _;
101     }
102 
103     //modules
104 
105     function EscrowGoods(address _arbiter, uint _freezePeriod, uint _feePromille, uint _rewardPromille,
106                           uint16 _count, uint _price) {
107 
108         seller = msg.sender;
109 
110         // all variables are always initialized to 0, save gas
111 
112         //escrow related
113 
114         arbiter = _arbiter;
115         freezePeriod = _freezePeriod;
116         feePromille = _feePromille;
117         rewardPromille = _rewardPromille;
118 
119         //goods related
120 
121         status = Available;
122         count = _count;
123         price = _price;
124 
125         availableCount = count;
126     }
127 
128     //helpers for events with counter
129     function logDebug(string message) internal {
130         logsCount++;
131         LogDebug(message);
132     }
133 
134     function logEvent(uint lockId, string dataInfo, uint version, uint16 eventType,
135                                 address sender, uint count, uint payment) internal {
136         contentCount++;
137         LogEvent(lockId, dataInfo, version, eventType, sender, count, payment);
138     }
139 
140     function kill() onlyOwner {
141 
142         //do not allow killing contract with active escrows
143         if(totalEscrows > 0) {
144             logDebug("totalEscrows > 0");
145             return;
146         }
147         //do not allow killing contract with unclaimed escrow fees
148         if(feeFunds > 0) {
149             logDebug("feeFunds > 0");
150             return;
151         }
152         suicide(msg.sender);
153     }
154 
155     function safeSend(address addr, uint value) internal {
156 
157         if(atomicLock) throw;
158         atomicLock = true;
159         if (!(addr.call.gas(safeGas).value(value)())) {
160             atomicLock = false;
161             throw;
162         }
163         atomicLock = false;
164     }
165 
166     //escrow API
167 
168     //vote YES - immediately sends funds to the peer
169     function yes(uint _lockId, string _dataInfo, uint _version) {
170 
171         EscrowInfo info = escrows[_lockId];
172 
173         if(info.lockedFunds == 0) {
174             logDebug("info.lockedFunds == 0");
175             return;
176         }
177         if(msg.sender != info.buyer && msg.sender != seller) {
178             logDebug("msg.sender != info.buyer && msg.sender != seller");
179             return;
180         }
181 
182         uint payment = info.lockedFunds;
183         if(payment > this.balance) {
184             //HACK: should not get here - funds cannot be unlocked in this case
185             logDebug("payment > this.balance");
186             return;
187         }
188 
189         if(msg.sender == info.buyer) {
190 
191             //send funds to seller
192             safeSend(seller, payment);
193         } else if(msg.sender == seller) {
194 
195             //send funds to buyer
196             safeSend(info.buyer, payment);
197         } else {
198             //HACK: should not get here
199             logDebug("unknown msg.sender");
200             return;
201         }
202 
203         //remove record from escrows
204         if(totalEscrows > 0) totalEscrows -= 1;
205         info.lockedFunds = 0;
206 
207         logEvent(_lockId, _dataInfo, _version, Unlock, msg.sender, info.count, payment);
208     }
209 
210     //vote NO - freeze funds for arbitration
211     function no(uint _lockId, string _dataInfo, uint _version) {
212 
213         EscrowInfo info = escrows[_lockId];
214 
215         if(info.lockedFunds == 0) {
216             logDebug("info.lockedFunds == 0");
217             return;
218         }
219         if(msg.sender != info.buyer && msg.sender != seller) {
220             logDebug("msg.sender != info.buyer && msg.sender != seller");
221             return;
222         }
223 
224         //freeze funds
225         //only allow one time freeze
226         if(info.frozenFunds == 0) {
227             info.frozenFunds = info.lockedFunds;
228             info.frozenTime = uint64(now);
229         }
230 
231         if(msg.sender == info.buyer) {
232             info.buyerNo = true;
233         }
234         else if(msg.sender == seller) {
235             info.sellerNo = true;
236         } else {
237             //HACK: should not get here
238             logDebug("unknown msg.sender");
239             return;
240         }
241 
242         logEvent(_lockId, _dataInfo, _version, Freeze, msg.sender, info.count, info.lockedFunds);
243     }
244 
245     //arbiter's decision on the case.
246     //arbiter can only decide when both buyer and seller voted NO
247     //arbiter decides on his own reward but not bigger than announced percentage (rewardPromille)
248     function arbYes(uint _lockId, address _who, uint _payment, string _dataInfo, uint _version) onlyArbiter {
249 
250         EscrowInfo info = escrows[_lockId];
251 
252         if(info.lockedFunds == 0) {
253             logDebug("info.lockedFunds == 0");
254             return;
255         }
256         if(info.frozenFunds == 0) {
257             logDebug("info.frozenFunds == 0");
258             return;
259         }
260 
261         if(_who != seller && _who != info.buyer) {
262             logDebug("_who != seller && _who != info.buyer");
263             return;
264         }
265         //requires both NO to arbitration
266         if(!info.buyerNo || !info.sellerNo) {
267             logDebug("!info.buyerNo || !info.sellerNo");
268             return;
269         }
270 
271         if(_payment > info.lockedFunds) {
272             logDebug("_payment > info.lockedFunds");
273             return;
274         }
275         if(_payment > this.balance) {
276             //HACK: should not get here - funds cannot be unlocked in this case
277             logDebug("_payment > this.balance");
278             return;
279         }
280 
281         //limit payment
282         uint reward = (info.lockedFunds * rewardPromille) / 1000;
283         if(reward > (info.lockedFunds - _payment)) {
284             logDebug("reward > (info.lockedFunds - _payment)");
285             return;
286         }
287 
288         //send funds to the winner
289         safeSend(_who, _payment);
290 
291         //send the rest as reward
292         info.lockedFunds -= _payment;
293         feeFunds += info.lockedFunds;
294         info.lockedFunds = 0;
295 
296         logEvent(_lockId, _dataInfo, _version, Resolved, msg.sender, info.count, _payment);
297     }
298 
299     //allow arbiter to get his collected fees
300     function getFees() onlyArbiter {
301 
302         if(feeFunds > this.balance) {
303             //HACK: should not get here - funds cannot be unlocked in this case
304             logDebug("feeFunds > this.balance");
305             return;
306         }
307         
308         safeSend(arbiter, feeFunds);
309 
310         feeFunds = 0;
311     }
312 
313     //allow buyer or seller to take timeouted funds.
314     //buyer can get funds if seller is silent and seller can get funds if buyer is silent (after freezePeriod)
315     //buyer can get back funds under arbitration if arbiter is silent (after arbitrationPeriod)
316     function getMoney(uint _lockId) {
317 
318         EscrowInfo info = escrows[_lockId];
319 
320         if(info.lockedFunds == 0) {
321             logDebug("info.lockedFunds == 0");
322             return;
323         }
324         //HACK: this check is necessary since frozenTime == 0 at escrow creation
325         if(info.frozenFunds == 0) {
326             logDebug("info.frozenFunds == 0");
327             return;
328         }
329 
330         //timout for voting not over yet
331         if(now < (info.frozenTime + freezePeriod)) {
332             logDebug("now < (info.frozenTime + freezePeriod)");
333             return;
334         }
335 
336         uint payment = info.lockedFunds;
337         if(payment > this.balance) {
338             //HACK: should not get here - funds cannot be unlocked in this case
339             logDebug("payment > this.balance");
340             return;
341         }
342 
343         //both has voted - money is under arbitration
344         if(info.buyerNo && info.sellerNo) {
345 
346             //arbitration timeout is not over yet
347             if(now < (info.frozenTime + freezePeriod + arbitrationPeriod)) {
348                 logDebug("now < (info.frozenTime + freezePeriod + arbitrationPeriod)");
349                 return;
350             }
351 
352             //arbiter was silent so redeem the funds to the buyer
353             safeSend(info.buyer, payment);
354 
355             info.lockedFunds = 0;
356             return;
357         }
358 
359         if(info.buyerNo) {
360 
361             safeSend(info.buyer, payment);
362 
363             info.lockedFunds = 0;
364             return;
365         }
366         if(info.sellerNo) {
367 
368             safeSend(seller, payment);
369 
370             info.lockedFunds = 0;
371             return;
372         }
373     }
374 
375     //goods API
376 
377     //add new description to the goods
378     function addDescription(string _dataInfo, uint _version) onlyOwner {
379 
380         //Accept order to event log
381         logEvent(0, _dataInfo, _version, Description, msg.sender, 0, 0);
382     }
383 
384     //buy with escrow. id - escrow info id
385     function buy(uint _lockId, string _dataInfo, uint _version, uint16 _count) payable {
386 
387         //reject money transfers for bad item status
388 
389         if(status != Available) throw;
390         if(msg.value < (price * _count)) throw;
391         if(_count > availableCount) throw;
392         if(_count == 0) throw;
393         if(feePromille > 1000) throw;
394         if(rewardPromille > 1000) throw;
395         if((feePromille + rewardPromille) > 1000) throw;
396 
397         //create default EscrowInfo struct or access existing
398         EscrowInfo info = escrows[_lockId];
399 
400         //lock only once for a given id
401         if(info.lockedFunds > 0) throw;
402 
403         //lock funds
404 
405         uint fee = (msg.value * feePromille) / 1000;
406         //limit fees
407         if(fee > msg.value) throw;
408 
409         uint funds = (msg.value - fee);
410         feeFunds += fee;
411         totalEscrows += 1;
412 
413         info.buyer = msg.sender;
414         info.lockedFunds = funds;
415         info.frozenFunds = 0;
416         info.buyerNo = false;
417         info.sellerNo = false;
418         info.count = _count;
419 
420         pendingCount += _count;
421         buyers[msg.sender] = true;
422 
423         //Buy order to event log
424         logEvent(_lockId, _dataInfo, _version, Buy, msg.sender, _count, msg.value);
425     }
426 
427     function accept(uint _lockId, string _dataInfo, uint _version) onlyOwner {
428 
429         EscrowInfo info = escrows[_lockId];
430         
431         if(info.count > availableCount) {
432             logDebug("info.count > availableCount");
433             return;
434         }
435         if(info.count > pendingCount) {
436             logDebug("info.count > pendingCount");
437             return;
438         }
439 
440         pendingCount -= info.count;
441         availableCount -= info.count;
442 
443         //Accept order to event log
444         logEvent(_lockId, _dataInfo, _version, Accept, msg.sender, info.count, info.lockedFunds);
445     }
446 
447     function reject(uint _lockId, string _dataInfo, uint _version) onlyOwner {
448         
449         EscrowInfo info = escrows[_lockId];
450 
451         if(info.count > pendingCount) {
452             logDebug("info.count > pendingCount");
453             return;
454         }
455 
456         pendingCount -= info.count;
457 
458         //send money back
459         yes(_lockId, _dataInfo, _version);
460 
461         //Reject order to event log
462         //HACK: "yes" call above may fail and this event will be non-relevant. Do not rely on it.
463         logEvent(_lockId, _dataInfo, _version, Reject, msg.sender, info.count, info.lockedFunds);
464     }
465 
466     function cancel(string _dataInfo, uint _version) onlyOwner {
467 
468         //Canceled status
469         status = Canceled;
470 
471         //Cancel order to event log
472         logEvent(0, _dataInfo, _version, Cancel, msg.sender, availableCount, 0);
473     }
474 
475     //remove buyer from the watchlist
476     function unbuy() {
477 
478         buyers[msg.sender] = false;
479     }
480 
481     function () {
482         throw;
483     }
484 }