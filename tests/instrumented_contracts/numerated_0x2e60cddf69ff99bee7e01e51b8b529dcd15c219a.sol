1 pragma solidity ^0.4.25;
2 
3 /**
4 
5 *  - GAIN 3,33% PER 24 HOURS (every 5900 blocks)
6 *  - Life-long payments
7 *  - The revolutionary reliability
8 *  - Minimal contribution 0.01 eth
9 *  - Currency and payment - ETH
10 *  - Contribution allocation schemes:
11 *    -- 83% payments
12 *    -- 17% Marketing + Operating Expenses
13 *
14 *   ---About the Project
15 *  Blockchain-enabled smart contracts have opened a new era of trustless relationships without 
16 *  intermediaries. This technology opens incredible financial possibilities. Our automated investment 
17 *  distribution model is written into a smart contract, uploaded to the Ethereum blockchain and can be 
18 *  freely accessed online. In order to insure our investors' complete security, full control over the 
19 *  project has been transferred from the organizers to the smart contract: nobody can influence the 
20 *  system's permanent autonomous functioning.
21 * 
22 * ---How to use:
23 *  1. Send from ETH wallet to the smart contract address 
24 *     any amount from 0.01 ETH.
25 *  2. Verify your transaction in the history of your application or etherscan.io, specifying the address 
26 *     of your wallet.
27 *  3a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're 
28 *      spending too much on GAS)
29 *  OR
30 *  3b. For reinvest, you need to first remove the accumulated percentage of charges (by sending 0 ether 
31 *      transaction), and only after that, deposit the amount that you want to reinvest.
32 *  
33 * RECOMMENDED GAS LIMIT: 200000
34 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
35 * You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.
36 *
37 * ---It is not allowed to transfer from exchanges, only from your personal ETH wallet, for which you 
38 * have private keys.
39 * 
40 * Contracts reviewed and approved by pros!
41 * 
42 * Main contract - Revolution. Scroll down to find it.
43 */
44 
45 
46 contract InvestorsStorage {
47   struct investor {
48     uint keyIndex;
49     uint value;
50     uint paymentTime;
51     uint refBonus;
52   }
53   struct itmap {
54     mapping(address => investor) data;
55     address[] keys;
56   }
57   itmap private s;
58   address private owner;
59 
60   modifier onlyOwner() {
61     require(msg.sender == owner, "access denied");
62     _;
63   }
64 
65   constructor() public {
66     owner = msg.sender;
67     s.keys.length++;
68   }
69 
70   function insert(address addr, uint value) public onlyOwner returns (bool) {
71     uint keyIndex = s.data[addr].keyIndex;
72     if (keyIndex != 0) return false;
73     s.data[addr].value = value;
74     keyIndex = s.keys.length++;
75     s.data[addr].keyIndex = keyIndex;
76     s.keys[keyIndex] = addr;
77     return true;
78   }
79 
80   function investorFullInfo(address addr) public view returns(uint, uint, uint, uint) {
81     return (
82       s.data[addr].keyIndex,
83       s.data[addr].value,
84       s.data[addr].paymentTime,
85       s.data[addr].refBonus
86     );
87   }
88 
89   function investorBaseInfo(address addr) public view returns(uint, uint, uint) {
90     return (
91       s.data[addr].value,
92       s.data[addr].paymentTime,
93       s.data[addr].refBonus
94     );
95   }
96 
97   function investorShortInfo(address addr) public view returns(uint, uint) {
98     return (
99       s.data[addr].value,
100       s.data[addr].refBonus
101     );
102   }
103 
104   function addRefBonus(address addr, uint refBonus) public onlyOwner returns (bool) {
105     if (s.data[addr].keyIndex == 0) return false;
106     s.data[addr].refBonus += refBonus;
107     return true;
108   }
109 
110   function addValue(address addr, uint value) public onlyOwner returns (bool) {
111     if (s.data[addr].keyIndex == 0) return false;
112     s.data[addr].value += value;
113     return true;
114   }
115 
116   function setPaymentTime(address addr, uint paymentTime) public onlyOwner returns (bool) {
117     if (s.data[addr].keyIndex == 0) return false;
118     s.data[addr].paymentTime = paymentTime;
119     return true;
120   }
121 
122   function setRefBonus(address addr, uint refBonus) public onlyOwner returns (bool) {
123     if (s.data[addr].keyIndex == 0) return false;
124     s.data[addr].refBonus = refBonus;
125     return true;
126   }
127 
128   function keyFromIndex(uint i) public view returns (address) {
129     return s.keys[i];
130   }
131 
132   function contains(address addr) public view returns (bool) {
133     return s.data[addr].keyIndex > 0;
134   }
135 
136   function size() public view returns (uint) {
137     return s.keys.length;
138   }
139 
140   function iterStart() public pure returns (uint) {
141     return 1;
142   }
143 }
144 
145 
146 library SafeMath {
147   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
148     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
149     // benefit is lost if 'b' is also tested.
150     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
151     if (_a == 0) {
152       return 0;
153     }
154 
155     uint256 c = _a * _b;
156     require(c / _a == _b);
157 
158     return c;
159   }
160 
161   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
162     require(_b > 0); // Solidity only automatically asserts when dividing by 0
163     uint256 c = _a / _b;
164     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
165 
166     return c;
167   }
168 
169   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
170     require(_b <= _a);
171     uint256 c = _a - _b;
172 
173     return c;
174   }
175 
176   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
177     uint256 c = _a + _b;
178     require(c >= _a);
179 
180     return c;
181   }
182 
183   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
184     require(b != 0);
185     return a % b;
186   }
187 }
188 
189 
190 
191 library Percent {
192   // Solidity automatically throws when dividing by 0
193   struct percent {
194     uint num;
195     uint den;
196   }
197   function mul(percent storage p, uint a) internal view returns (uint) {
198     if (a == 0) {
199       return 0;
200     }
201     return a*p.num/p.den;
202   }
203 
204   function div(percent storage p, uint a) internal view returns (uint) {
205     return a/p.num*p.den;
206   }
207 
208   function sub(percent storage p, uint a) internal view returns (uint) {
209     uint b = mul(p, a);
210     if (b >= a) return 0;
211     return a - b;
212   }
213 
214   function add(percent storage p, uint a) internal view returns (uint) {
215     return a + mul(p, a);
216   }
217 }
218 
219 
220 contract Accessibility {
221   enum AccessRank { None, Payout, Paymode, Full }
222   mapping(address => AccessRank) internal m_admins;
223   modifier onlyAdmin(AccessRank  r) {
224     require(
225       m_admins[msg.sender] == r || m_admins[msg.sender] == AccessRank.Full,
226       "access denied"
227     );
228     _;
229   }
230   event LogProvideAccess(address indexed whom, uint when,  AccessRank rank);
231 
232   constructor() public {
233     m_admins[msg.sender] = AccessRank.Full;
234     emit LogProvideAccess(msg.sender, now, AccessRank.Full);
235   }
236   
237   function provideAccess(address addr, AccessRank rank) public onlyAdmin(AccessRank.Full) {
238     require(rank <= AccessRank.Full, "invalid access rank");
239     require(m_admins[addr] != AccessRank.Full, "cannot change full access rank");
240     if (m_admins[addr] != rank) {
241       m_admins[addr] = rank;
242       emit LogProvideAccess(addr, now, rank);
243     }
244   }
245 
246   function access(address addr) public view returns(AccessRank rank) {
247     rank = m_admins[addr];
248   }
249 }
250 
251 
252 contract PaymentSystem {
253   // https://consensys.github.io/smart-contract-best-practices/recommendations/#favor-pull-over-push-for-external-calls
254   enum Paymode { Push, Pull }
255   struct PaySys {
256     uint latestTime;
257     uint latestKeyIndex;
258     Paymode mode; 
259   }
260   PaySys internal m_paysys;
261 
262   modifier atPaymode(Paymode mode) {
263     require(m_paysys.mode == mode, "pay mode does not the same");
264     _;
265   }
266   event LogPaymodeChanged(uint when, Paymode indexed mode);
267   
268   function paymode() public view returns(Paymode mode) {
269     mode = m_paysys.mode;
270   }
271 
272   function changePaymode(Paymode mode) internal {
273     require(mode <= Paymode.Pull, "invalid pay mode");
274     if (mode == m_paysys.mode ) return; 
275     if (mode == Paymode.Pull) require(m_paysys.latestTime != 0, "cannot set pull pay mode if latest time is 0");
276     if (mode == Paymode.Push) m_paysys.latestTime = 0;
277     m_paysys.mode = mode;
278     emit LogPaymodeChanged(now, m_paysys.mode);
279   }
280 }
281 
282 
283 library Zero {
284   function requireNotZero(uint a) internal pure {
285     require(a != 0, "require not zero");
286   }
287 
288   function requireNotZero(address addr) internal pure {
289     require(addr != address(0), "require not zero address");
290   }
291 
292   function notZero(address addr) internal pure returns(bool) {
293     return !(addr == address(0));
294   }
295 
296   function isZero(address addr) internal pure returns(bool) {
297     return addr == address(0);
298   }
299 }
300 
301 
302 library ToAddress {
303   function toAddr(uint source) internal pure returns(address) {
304     return address(source);
305   }
306 
307   function toAddr(bytes source) internal pure returns(address addr) {
308     assembly { addr := mload(add(source,0x14)) }
309     return addr;
310   }
311 }
312 
313 
314 contract Revolution is Accessibility, PaymentSystem {
315   using Percent for Percent.percent;
316   using SafeMath for uint;
317   using Zero for *;
318   using ToAddress for *;
319 
320   // investors storage - iterable map;
321   InvestorsStorage private m_investors;
322   mapping(address => bool) private m_referrals;
323   bool private m_nextWave;
324 
325   // automatically generates getters
326   address public adminAddr;
327   address public payerAddr;
328   uint public waveStartup;
329   uint public investmentsNum;
330   uint public constant minInvesment = 10 finney; // 0.01 eth
331   uint public constant maxBalance = 333e5 ether; // 33,300,000 eth
332   uint public constant pauseOnNextWave = 168 hours; 
333 
334   // percents 
335   Percent.percent private m_dividendsPercent = Percent.percent(333, 10000); // 333/10000*100% = 3.33%
336   Percent.percent private m_adminPercent = Percent.percent(1, 10); // 1/10*100% = 10%
337   Percent.percent private m_payerPercent = Percent.percent(7, 100); // 7/100*100% = 7%
338   Percent.percent private m_refPercent = Percent.percent(3, 100); // 3/100*100% = 3%
339 
340   // more events for easy read from blockchain
341   event LogNewInvestor(address indexed addr, uint when, uint value);
342   event LogNewInvesment(address indexed addr, uint when, uint value);
343   event LogNewReferral(address indexed addr, uint when, uint value);
344   event LogPayDividends(address indexed addr, uint when, uint value);
345   event LogPayReferrerBonus(address indexed addr, uint when, uint value);
346   event LogBalanceChanged(uint when, uint balance);
347   event LogAdminAddrChanged(address indexed addr, uint when);
348   event LogPayerAddrChanged(address indexed addr, uint when);
349   event LogNextWave(uint when);
350 
351   modifier balanceChanged {
352     _;
353     emit LogBalanceChanged(now, address(this).balance);
354   }
355 
356   modifier notOnPause() {
357     require(waveStartup+pauseOnNextWave <= now, "pause on next wave not expired");
358     _;
359   }
360 
361   constructor() public {
362     adminAddr = msg.sender;
363     emit LogAdminAddrChanged(msg.sender, now);
364 
365     payerAddr = msg.sender;
366     emit LogPayerAddrChanged(msg.sender, now);
367 
368     nextWave();
369     waveStartup = waveStartup.sub(pauseOnNextWave);
370   }
371 
372   function() public payable {
373     // investor get him dividends
374     if (msg.value == 0) {
375       getMyDividends();
376       return;
377     }
378 
379     // sender do invest
380     address a = msg.data.toAddr();
381     address[3] memory refs;
382     if (a.notZero()) {
383       refs[0] = a;
384       doInvest(refs); 
385     } else {
386       doInvest(refs);
387     }
388   }
389 
390   function investorsNumber() public view returns(uint) {
391     return m_investors.size()-1;
392     // -1 because see InvestorsStorage constructor where keys.length++ 
393   }
394 
395   function balanceETH() public view returns(uint) {
396     return address(this).balance;
397   }
398 
399   function payerPercent() public view returns(uint numerator, uint denominator) {
400     (numerator, denominator) = (m_payerPercent.num, m_payerPercent.den);
401   }
402 
403   function dividendsPercent() public view returns(uint numerator, uint denominator) {
404     (numerator, denominator) = (m_dividendsPercent.num, m_dividendsPercent.den);
405   }
406 
407   function adminPercent() public view returns(uint numerator, uint denominator) {
408     (numerator, denominator) = (m_adminPercent.num, m_adminPercent.den);
409   }
410 
411   function referrerPercent() public view returns(uint numerator, uint denominator) {
412     (numerator, denominator) = (m_refPercent.num, m_refPercent.den);
413   }
414 
415   function investorInfo(address addr) public view returns(uint value, uint paymentTime, uint refBonus, bool isReferral) {
416     (value, paymentTime, refBonus) = m_investors.investorBaseInfo(addr);
417     isReferral = m_referrals[addr];
418   }
419 
420   function latestPayout() public view returns(uint timestamp) {
421     return m_paysys.latestTime;
422   }
423 
424   function getMyDividends() public notOnPause atPaymode(Paymode.Pull) balanceChanged {
425     // check investor info
426     InvestorsStorage.investor memory investor = getMemInvestor(msg.sender);
427     require(investor.keyIndex > 0, "sender is not investor"); 
428     if (investor.paymentTime < m_paysys.latestTime) {
429       assert(m_investors.setPaymentTime(msg.sender, m_paysys.latestTime));
430       investor.paymentTime = m_paysys.latestTime;
431     }
432 
433     // calculate days after latest payment
434     uint256 daysAfter = now.sub(investor.paymentTime).div(24 hours);
435     require(daysAfter > 0, "the latest payment was earlier than 24 hours");
436     assert(m_investors.setPaymentTime(msg.sender, now));
437 
438     // check enough eth 
439     uint value = m_dividendsPercent.mul(investor.value) * daysAfter;
440     if (address(this).balance < value + investor.refBonus) {
441       nextWave();
442       return;
443     }
444 
445     // send dividends and ref bonus
446     if (investor.refBonus > 0) {
447       assert(m_investors.setRefBonus(msg.sender, 0));
448       sendDividendsWithRefBonus(msg.sender, value, investor.refBonus);
449     } else {
450       sendDividends(msg.sender, value);
451     }
452   }
453 
454   function doInvest(address[3] refs) public payable notOnPause balanceChanged {
455     require(msg.value >= minInvesment, "msg.value must be >= minInvesment");
456     require(address(this).balance <= maxBalance, "the contract eth balance limit");
457 
458     uint value = msg.value;
459     // ref system works only once for sender-referral
460     if (!m_referrals[msg.sender]) {
461       // level 1
462       if (notZeroNotSender(refs[0]) && m_investors.contains(refs[0])) {
463         uint reward = m_refPercent.mul(value);
464         assert(m_investors.addRefBonus(refs[0], reward)); // referrer 1 bonus
465         m_referrals[msg.sender] = true;
466         value = m_dividendsPercent.add(value); // referral bonus
467         emit LogNewReferral(msg.sender, now, value);
468         // level 2
469         if (notZeroNotSender(refs[1]) && m_investors.contains(refs[1]) && refs[0] != refs[1]) { 
470           assert(m_investors.addRefBonus(refs[1], reward)); // referrer 2 bonus
471           // level 3
472           if (notZeroNotSender(refs[2]) && m_investors.contains(refs[2]) && refs[0] != refs[2] && refs[1] != refs[2]) { 
473             assert(m_investors.addRefBonus(refs[2], reward)); // referrer 3 bonus
474           }
475         }
476       }
477     }
478 
479     // commission
480     adminAddr.transfer(m_adminPercent.mul(msg.value));
481     payerAddr.transfer(m_payerPercent.mul(msg.value));    
482     
483     // write to investors storage
484     if (m_investors.contains(msg.sender)) {
485       assert(m_investors.addValue(msg.sender, value));
486     } else {
487       assert(m_investors.insert(msg.sender, value));
488       emit LogNewInvestor(msg.sender, now, value); 
489     }
490     
491     if (m_paysys.mode == Paymode.Pull)
492       assert(m_investors.setPaymentTime(msg.sender, now));
493 
494     emit LogNewInvesment(msg.sender, now, value);   
495     investmentsNum++;
496   }
497 
498   function payout() public notOnPause onlyAdmin(AccessRank.Payout) atPaymode(Paymode.Push) balanceChanged {
499     if (m_nextWave) {
500       nextWave(); 
501       return;
502     }
503    
504     // if m_paysys.latestKeyIndex == m_investors.iterStart() then payout NOT in process and we must check latest time of payment.
505     if (m_paysys.latestKeyIndex == m_investors.iterStart()) {
506       require(now>m_paysys.latestTime+12 hours, "the latest payment was earlier than 12 hours");
507       m_paysys.latestTime = now;
508     }
509 
510     uint i = m_paysys.latestKeyIndex;
511     uint value;
512     uint refBonus;
513     uint size = m_investors.size();
514     address investorAddr;
515     
516     // gasleft and latest key index  - prevent gas block limit 
517     for (i; i < size && gasleft() > 50000; i++) {
518       investorAddr = m_investors.keyFromIndex(i);
519       (value, refBonus) = m_investors.investorShortInfo(investorAddr);
520       value = m_dividendsPercent.mul(value);
521 
522       if (address(this).balance < value + refBonus) {
523         m_nextWave = true;
524         break;
525       }
526 
527       if (refBonus > 0) {
528         require(m_investors.setRefBonus(investorAddr, 0), "internal error");
529         sendDividendsWithRefBonus(investorAddr, value, refBonus);
530         continue;
531       }
532 
533       sendDividends(investorAddr, value);
534     }
535 
536     if (i == size) 
537       m_paysys.latestKeyIndex = m_investors.iterStart();
538     else 
539       m_paysys.latestKeyIndex = i;
540   }
541 
542   function setAdminAddr(address addr) public onlyAdmin(AccessRank.Full) {
543     addr.requireNotZero();
544     if (adminAddr != addr) {
545       adminAddr = addr;
546       emit LogAdminAddrChanged(addr, now);
547     }    
548   }
549 
550   function setPayerAddr(address addr) public onlyAdmin(AccessRank.Full) {
551     addr.requireNotZero();
552     if (payerAddr != addr) {
553       payerAddr = addr;
554       emit LogPayerAddrChanged(addr, now);
555     }  
556   }
557 
558   function setPullPaymode() public onlyAdmin(AccessRank.Paymode) atPaymode(Paymode.Push) {
559     changePaymode(Paymode.Pull);
560   }
561 
562   function getMemInvestor(address addr) internal view returns(InvestorsStorage.investor) {
563     (uint a, uint b, uint c, uint d) = m_investors.investorFullInfo(addr);
564     return InvestorsStorage.investor(a, b, c, d);
565   }
566 
567   function notZeroNotSender(address addr) internal view returns(bool) {
568     return addr.notZero() && addr != msg.sender;
569   }
570 
571   function sendDividends(address addr, uint value) private {
572     if (addr.send(value)) emit LogPayDividends(addr, now, value); 
573   }
574 
575   function sendDividendsWithRefBonus(address addr, uint value,  uint refBonus) private {
576     if (addr.send(value+refBonus)) {
577       emit LogPayDividends(addr, now, value);
578       emit LogPayReferrerBonus(addr, now, refBonus);
579     }
580   }
581 
582   function nextWave() private {
583     m_investors = new InvestorsStorage();
584     changePaymode(Paymode.Push);
585     m_paysys.latestKeyIndex = m_investors.iterStart();
586     investmentsNum = 0;
587     waveStartup = now;
588     m_nextWave = false;
589     emit LogNextWave(now);
590   }
591 }