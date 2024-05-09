1 pragma solidity ^0.4.23;
2 
3 /**
4 *  - Full clone V2, restart
5 * -  Call it greed.. Or not
6 *  - GAIN 3,33% PER 24 HOURS (every 5900 blocks)
7 *  - Life-long payments
8 *  - The revolutionary reliability
9 *  - Minimal contribution 0.01 eth
10 *  - Currency and payment - ETH
11 *  - Contribution allocation schemes:
12 *    -- 83% payments
13 *    -- 17% Marketing + Operating Expenses
14 
15 * RECOMMENDED GAS LIMIT: 200000
16 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
17 
18 */
19 
20 
21 contract InvestorsStorage {
22   struct investor {
23     uint keyIndex;
24     uint value;
25     uint paymentTime;
26     uint refBonus;
27   }
28   struct itmap {
29     mapping(address => investor) data;
30     address[] keys;
31   }
32   itmap private s;
33   address private owner;
34 
35   modifier onlyOwner() {
36     require(msg.sender == owner, "access denied");
37     _;
38   }
39 
40   constructor() public {
41     owner = msg.sender;
42     s.keys.length++;
43   }
44 
45   function insert(address addr, uint value) public onlyOwner returns (bool) {
46     uint keyIndex = s.data[addr].keyIndex;
47     if (keyIndex != 0) return false;
48     s.data[addr].value = value;
49     keyIndex = s.keys.length++;
50     s.data[addr].keyIndex = keyIndex;
51     s.keys[keyIndex] = addr;
52     return true;
53   }
54 
55   function investorFullInfo(address addr) public view returns(uint, uint, uint, uint) {
56     return (
57       s.data[addr].keyIndex,
58       s.data[addr].value,
59       s.data[addr].paymentTime,
60       s.data[addr].refBonus
61     );
62   }
63 
64   function investorBaseInfo(address addr) public view returns(uint, uint, uint) {
65     return (
66       s.data[addr].value,
67       s.data[addr].paymentTime,
68       s.data[addr].refBonus
69     );
70   }
71 
72   function investorShortInfo(address addr) public view returns(uint, uint) {
73     return (
74       s.data[addr].value,
75       s.data[addr].refBonus
76     );
77   }
78 
79   function addRefBonus(address addr, uint refBonus) public onlyOwner returns (bool) {
80     if (s.data[addr].keyIndex == 0) return false;
81     s.data[addr].refBonus += refBonus;
82     return true;
83   }
84 
85   function addValue(address addr, uint value) public onlyOwner returns (bool) {
86     if (s.data[addr].keyIndex == 0) return false;
87     s.data[addr].value += value;
88     return true;
89   }
90 
91   function setPaymentTime(address addr, uint paymentTime) public onlyOwner returns (bool) {
92     if (s.data[addr].keyIndex == 0) return false;
93     s.data[addr].paymentTime = paymentTime;
94     return true;
95   }
96 
97   function setRefBonus(address addr, uint refBonus) public onlyOwner returns (bool) {
98     if (s.data[addr].keyIndex == 0) return false;
99     s.data[addr].refBonus = refBonus;
100     return true;
101   }
102 
103   function keyFromIndex(uint i) public view returns (address) {
104     return s.keys[i];
105   }
106 
107   function contains(address addr) public view returns (bool) {
108     return s.data[addr].keyIndex > 0;
109   }
110 
111   function size() public view returns (uint) {
112     return s.keys.length;
113   }
114 
115   function iterStart() public pure returns (uint) {
116     return 1;
117   }
118 }
119 
120 
121 library SafeMath {
122   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
123     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
124     // benefit is lost if 'b' is also tested.
125     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
126     if (_a == 0) {
127       return 0;
128     }
129 
130     uint256 c = _a * _b;
131     require(c / _a == _b);
132 
133     return c;
134   }
135 
136   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
137     require(_b > 0); // Solidity only automatically asserts when dividing by 0
138     uint256 c = _a / _b;
139     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
140 
141     return c;
142   }
143 
144   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
145     require(_b <= _a);
146     uint256 c = _a - _b;
147 
148     return c;
149   }
150 
151   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
152     uint256 c = _a + _b;
153     require(c >= _a);
154 
155     return c;
156   }
157 
158   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
159     require(b != 0);
160     return a % b;
161   }
162 }
163 
164 
165 
166 library Percent {
167   // Solidity automatically throws when dividing by 0
168   struct percent {
169     uint num;
170     uint den;
171   }
172   function mul(percent storage p, uint a) internal view returns (uint) {
173     if (a == 0) {
174       return 0;
175     }
176     return a*p.num/p.den;
177   }
178 
179   function div(percent storage p, uint a) internal view returns (uint) {
180     return a/p.num*p.den;
181   }
182 
183   function sub(percent storage p, uint a) internal view returns (uint) {
184     uint b = mul(p, a);
185     if (b >= a) return 0;
186     return a - b;
187   }
188 
189   function add(percent storage p, uint a) internal view returns (uint) {
190     return a + mul(p, a);
191   }
192 }
193 
194 
195 contract Accessibility {
196   enum AccessRank { None, Payout, Paymode, Full }
197   mapping(address => AccessRank) internal m_admins;
198   modifier onlyAdmin(AccessRank  r) {
199     require(
200       m_admins[msg.sender] == r || m_admins[msg.sender] == AccessRank.Full,
201       "access denied"
202     );
203     _;
204   }
205   event LogProvideAccess(address indexed whom, uint when,  AccessRank rank);
206 
207   constructor() public {
208     m_admins[msg.sender] = AccessRank.Full;
209     emit LogProvideAccess(msg.sender, now, AccessRank.Full);
210   }
211   
212   function provideAccess(address addr, AccessRank rank) public onlyAdmin(AccessRank.Full) {
213     require(rank <= AccessRank.Full, "invalid access rank");
214     require(m_admins[addr] != AccessRank.Full, "cannot change full access rank");
215     if (m_admins[addr] != rank) {
216       m_admins[addr] = rank;
217       emit LogProvideAccess(addr, now, rank);
218     }
219   }
220 
221   function access(address addr) public view returns(AccessRank rank) {
222     rank = m_admins[addr];
223   }
224 }
225 
226 
227 contract PaymentSystem {
228   // https://consensys.github.io/smart-contract-best-practices/recommendations/#favor-pull-over-push-for-external-calls
229   enum Paymode { Push, Pull }
230   struct PaySys {
231     uint latestTime;
232     uint latestKeyIndex;
233     Paymode mode; 
234   }
235   PaySys internal m_paysys;
236 
237   modifier atPaymode(Paymode mode) {
238     require(m_paysys.mode == mode, "pay mode does not the same");
239     _;
240   }
241   event LogPaymodeChanged(uint when, Paymode indexed mode);
242   
243   function paymode() public view returns(Paymode mode) {
244     mode = m_paysys.mode;
245   }
246 
247   function changePaymode(Paymode mode) internal {
248     require(mode <= Paymode.Pull, "invalid pay mode");
249     if (mode == m_paysys.mode ) return; 
250     if (mode == Paymode.Pull) require(m_paysys.latestTime != 0, "cannot set pull pay mode if latest time is 0");
251     if (mode == Paymode.Push) m_paysys.latestTime = 0;
252     m_paysys.mode = mode;
253     emit LogPaymodeChanged(now, m_paysys.mode);
254   }
255 }
256 
257 
258 library Zero {
259   function requireNotZero(uint a) internal pure {
260     require(a != 0, "require not zero");
261   }
262 
263   function requireNotZero(address addr) internal pure {
264     require(addr != address(0), "require not zero address");
265   }
266 
267   function notZero(address addr) internal pure returns(bool) {
268     return !(addr == address(0));
269   }
270 
271   function isZero(address addr) internal pure returns(bool) {
272     return addr == address(0);
273   }
274 }
275 
276 
277 library ToAddress {
278   function toAddr(uint source) internal pure returns(address) {
279     return address(source);
280   }
281 
282   function toAddr(bytes source) internal pure returns(address addr) {
283     assembly { addr := mload(add(source,0x14)) }
284     return addr;
285   }
286 }
287 
288 
289 contract Revolution is Accessibility, PaymentSystem {
290   using Percent for Percent.percent;
291   using SafeMath for uint;
292   using Zero for *;
293   using ToAddress for *;
294 
295   // investors storage - iterable map;
296   InvestorsStorage private m_investors;
297   mapping(address => bool) private m_referrals;
298   bool private m_nextWave;
299 
300   // automatically generates getters
301   address public adminAddr;
302   address public payerAddr;
303   uint public waveStartup;
304   uint public investmentsNum;
305   uint public constant minInvesment = 50 finney; // 0.05 eth
306   uint public constant maxBalance = 333e5 ether; // 33,300,000 eth
307   uint public constant pauseOnNextWave = 168 hours; 
308 
309   // percents 
310   Percent.percent private m_dividendsPercent = Percent.percent(333, 10000); // 333/10000*100% = 3.33%
311   Percent.percent private m_adminPercent = Percent.percent(1, 10); // 1/10*100% = 10%
312   Percent.percent private m_payerPercent = Percent.percent(7, 100); // 7/100*100% = 7%
313   Percent.percent private m_refPercent = Percent.percent(3, 100); // 3/100*100% = 3%
314 
315   // more events for easy read from blockchain
316   event LogNewInvestor(address indexed addr, uint when, uint value);
317   event LogNewInvesment(address indexed addr, uint when, uint value);
318   event LogNewReferral(address indexed addr, uint when, uint value);
319   event LogPayDividends(address indexed addr, uint when, uint value);
320   event LogPayReferrerBonus(address indexed addr, uint when, uint value);
321   event LogBalanceChanged(uint when, uint balance);
322   event LogAdminAddrChanged(address indexed addr, uint when);
323   event LogPayerAddrChanged(address indexed addr, uint when);
324   event LogNextWave(uint when);
325 
326   modifier balanceChanged {
327     _;
328     emit LogBalanceChanged(now, address(this).balance);
329   }
330 
331   modifier notOnPause() {
332     require(waveStartup+pauseOnNextWave <= now, "pause on next wave not expired");
333     _;
334   }
335 
336   constructor() public {
337     adminAddr = msg.sender;
338     emit LogAdminAddrChanged(msg.sender, now);
339 
340     payerAddr = msg.sender;
341     emit LogPayerAddrChanged(msg.sender, now);
342 
343     nextWave();
344     waveStartup = waveStartup.sub(pauseOnNextWave);
345   }
346 
347   function() public payable {
348     // investor get him dividends
349     if (msg.value == 0) {
350       getMyDividends();
351       return;
352     }
353 
354     // sender do invest
355     address a = msg.data.toAddr();
356     address[3] memory refs;
357     if (a.notZero()) {
358       refs[0] = a;
359       doInvest(refs); 
360     } else {
361       doInvest(refs);
362     }
363   }
364 
365   function investorsNumber() public view returns(uint) {
366     return m_investors.size()-1;
367     // -1 because see InvestorsStorage constructor where keys.length++ 
368   }
369 
370   function balanceETH() public view returns(uint) {
371     return address(this).balance;
372   }
373 
374   function payerPercent() public view returns(uint numerator, uint denominator) {
375     (numerator, denominator) = (m_payerPercent.num, m_payerPercent.den);
376   }
377 
378   function dividendsPercent() public view returns(uint numerator, uint denominator) {
379     (numerator, denominator) = (m_dividendsPercent.num, m_dividendsPercent.den);
380   }
381 
382   function adminPercent() public view returns(uint numerator, uint denominator) {
383     (numerator, denominator) = (m_adminPercent.num, m_adminPercent.den);
384   }
385 
386   function referrerPercent() public view returns(uint numerator, uint denominator) {
387     (numerator, denominator) = (m_refPercent.num, m_refPercent.den);
388   }
389 
390   function investorInfo(address addr) public view returns(uint value, uint paymentTime, uint refBonus, bool isReferral) {
391     (value, paymentTime, refBonus) = m_investors.investorBaseInfo(addr);
392     isReferral = m_referrals[addr];
393   }
394 
395   function latestPayout() public view returns(uint timestamp) {
396     return m_paysys.latestTime;
397   }
398 
399   function getMyDividends() public notOnPause atPaymode(Paymode.Pull) balanceChanged {
400     // check investor info
401     InvestorsStorage.investor memory investor = getMemInvestor(msg.sender);
402     require(investor.keyIndex > 0, "sender is not investor"); 
403     if (investor.paymentTime < m_paysys.latestTime) {
404       assert(m_investors.setPaymentTime(msg.sender, m_paysys.latestTime));
405       investor.paymentTime = m_paysys.latestTime;
406     }
407 
408     // calculate days after latest payment
409     uint256 daysAfter = now.sub(investor.paymentTime).div(24 hours);
410     require(daysAfter > 0, "the latest payment was earlier than 24 hours");
411     assert(m_investors.setPaymentTime(msg.sender, now));
412 
413     // check enough eth 
414     uint value = m_dividendsPercent.mul(investor.value) * daysAfter;
415     if (address(this).balance < value + investor.refBonus) {
416       nextWave();
417       return;
418     }
419 
420     // send dividends and ref bonus
421     if (investor.refBonus > 0) {
422       assert(m_investors.setRefBonus(msg.sender, 0));
423       sendDividendsWithRefBonus(msg.sender, value, investor.refBonus);
424     } else {
425       sendDividends(msg.sender, value);
426     }
427   }
428 
429   function doInvest(address[3] refs) public payable notOnPause balanceChanged {
430     require(msg.value >= minInvesment, "msg.value must be >= minInvesment");
431     require(address(this).balance <= maxBalance, "the contract eth balance limit");
432 
433     uint value = msg.value;
434     // ref system works only once for sender-referral
435     if (!m_referrals[msg.sender]) {
436       // level 1
437       if (notZeroNotSender(refs[0]) && m_investors.contains(refs[0])) {
438         uint reward = m_refPercent.mul(value);
439         assert(m_investors.addRefBonus(refs[0], reward)); // referrer 1 bonus
440         m_referrals[msg.sender] = true;
441         value = m_dividendsPercent.add(value); // referral bonus
442         emit LogNewReferral(msg.sender, now, value);
443         // level 2
444         if (notZeroNotSender(refs[1]) && m_investors.contains(refs[1]) && refs[0] != refs[1]) { 
445           assert(m_investors.addRefBonus(refs[1], reward)); // referrer 2 bonus
446           // level 3
447           if (notZeroNotSender(refs[2]) && m_investors.contains(refs[2]) && refs[0] != refs[2] && refs[1] != refs[2]) { 
448             assert(m_investors.addRefBonus(refs[2], reward)); // referrer 3 bonus
449           }
450         }
451       }
452     }
453 
454     // commission
455     adminAddr.transfer(m_adminPercent.mul(msg.value));
456     payerAddr.transfer(m_payerPercent.mul(msg.value));    
457     
458     // write to investors storage
459     if (m_investors.contains(msg.sender)) {
460       assert(m_investors.addValue(msg.sender, value));
461     } else {
462       assert(m_investors.insert(msg.sender, value));
463       emit LogNewInvestor(msg.sender, now, value); 
464     }
465     
466     if (m_paysys.mode == Paymode.Pull)
467       assert(m_investors.setPaymentTime(msg.sender, now));
468 
469     emit LogNewInvesment(msg.sender, now, value);   
470     investmentsNum++;
471   }
472 
473   function payout() public notOnPause onlyAdmin(AccessRank.Payout) atPaymode(Paymode.Push) balanceChanged {
474     if (m_nextWave) {
475       nextWave(); 
476       return;
477     }
478    
479     // if m_paysys.latestKeyIndex == m_investors.iterStart() then payout NOT in process and we must check latest time of payment.
480     if (m_paysys.latestKeyIndex == m_investors.iterStart()) {
481       require(now>m_paysys.latestTime+12 hours, "the latest payment was earlier than 12 hours");
482       m_paysys.latestTime = now;
483     }
484 
485     uint i = m_paysys.latestKeyIndex;
486     uint value;
487     uint refBonus;
488     uint size = m_investors.size();
489     address investorAddr;
490     
491     // gasleft and latest key index  - prevent gas block limit 
492     for (i; i < size && gasleft() > 50000; i++) {
493       investorAddr = m_investors.keyFromIndex(i);
494       (value, refBonus) = m_investors.investorShortInfo(investorAddr);
495       value = m_dividendsPercent.mul(value);
496 
497       if (address(this).balance < value + refBonus) {
498         m_nextWave = true;
499         break;
500       }
501 
502       if (refBonus > 0) {
503         require(m_investors.setRefBonus(investorAddr, 0), "internal error");
504         sendDividendsWithRefBonus(investorAddr, value, refBonus);
505         continue;
506       }
507 
508       sendDividends(investorAddr, value);
509     }
510 
511     if (i == size) 
512       m_paysys.latestKeyIndex = m_investors.iterStart();
513     else 
514       m_paysys.latestKeyIndex = i;
515   }
516 
517   function setAdminAddr(address addr) public onlyAdmin(AccessRank.Full) {
518     addr.requireNotZero();
519     if (adminAddr != addr) {
520       adminAddr = addr;
521       emit LogAdminAddrChanged(addr, now);
522     }    
523   }
524 
525   function setPayerAddr(address addr) public onlyAdmin(AccessRank.Full) {
526     addr.requireNotZero();
527     if (payerAddr != addr) {
528       payerAddr = addr;
529       emit LogPayerAddrChanged(addr, now);
530     }  
531   }
532 
533   function setPullPaymode() public onlyAdmin(AccessRank.Paymode) atPaymode(Paymode.Push) {
534     changePaymode(Paymode.Pull);
535   }
536 
537   function getMemInvestor(address addr) internal view returns(InvestorsStorage.investor) {
538     (uint a, uint b, uint c, uint d) = m_investors.investorFullInfo(addr);
539     return InvestorsStorage.investor(a, b, c, d);
540   }
541 
542   function notZeroNotSender(address addr) internal view returns(bool) {
543     return addr.notZero() && addr != msg.sender;
544   }
545 
546   function sendDividends(address addr, uint value) private {
547     if (addr.send(value)) emit LogPayDividends(addr, now, value); 
548   }
549 
550   function sendDividendsWithRefBonus(address addr, uint value,  uint refBonus) private {
551     if (addr.send(value+refBonus)) {
552       emit LogPayDividends(addr, now, value);
553       emit LogPayReferrerBonus(addr, now, refBonus);
554     }
555   }
556 
557   function nextWave() private {
558     m_investors = new InvestorsStorage();
559     changePaymode(Paymode.Push);
560     m_paysys.latestKeyIndex = m_investors.iterStart();
561     investmentsNum = 0;
562     waveStartup = now;
563     m_nextWave = false;
564     emit LogNextWave(now);
565   }
566 }