1 pragma solidity ^0.4.23;
2 
3 /**
4 *
5 * ETH CRYPTOCURRENCY DISTRIBUTION PROJECT
6 * Web              - https://444eth.com
7 
8 * 
9 *  - GAIN 4,44% PER 24 HOURS (every 5900 blocks)
10 *  - Life-long payments
11 *  - The revolutionary reliability
12 *  - Minimal contribution 0.01 eth
13 *  - Currency and payment - ETH
14 *  - Contribution allocation schemes:
15 *    -- 83% payments
16 *    -- 17% Marketing + Operating Expenses
17 *
18 *   ---About the Project
19 *  Blockchain-enabled smart contracts have opened a new era of trustless relationships without 
20 *  intermediaries. This technology opens incredible financial possibilities. Our automated investment 
21 *  distribution model is written into a smart contract, uploaded to the Ethereum blockchain and can be 
22 *  freely accessed online. In order to insure our investors' complete security, full control over the 
23 *  project has been transferred from the organizers to the smart contract: nobody can influence the 
24 *  system's permanent autonomous functioning.
25 * 
26 * ---How to use:
27 *  1. Send from ETH wallet to the smart contract address
28 *     any amount from 0.01 ETH.
29 *  2. Verify your transaction in the history of your application or etherscan.io, specifying the address 
30 *     of your wallet.
31 *  3a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're 
32 *      spending too much on GAS)
33 *  OR
34 *  3b. For reinvest, you need to first remove the accumulated percentage of charges (by sending 0 ether 
35 *      transaction), and only after that, deposit the amount that you want to reinvest.
36 *  
37 * RECOMMENDED GAS LIMIT: 200000
38 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
39 * You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.
40 *
41 * ---It is not allowed to transfer from exchanges, only from your personal ETH wallet, for which you 
42 * have private keys.
43 * 
44 * Contracts reviewed and approved by pros!
45 * 
46 * Main contract - Revolution. Scroll down to find it.
47 */
48 
49 
50 contract InvestorsStorage {
51   struct investor {
52     uint keyIndex;
53     uint value;
54     uint paymentTime;
55     uint refBonus;
56   }
57   struct itmap {
58     mapping(address => investor) data;
59     address[] keys;
60   }
61   itmap private s;
62   address private owner;
63 
64   modifier onlyOwner() {
65     require(msg.sender == owner, "access denied");
66     _;
67   }
68 
69   constructor() public {
70     owner = msg.sender;
71     s.keys.length++;
72   }
73 
74   function insert(address addr, uint value) public onlyOwner returns (bool) {
75     uint keyIndex = s.data[addr].keyIndex;
76     if (keyIndex != 0) return false;
77     s.data[addr].value = value;
78     keyIndex = s.keys.length++;
79     s.data[addr].keyIndex = keyIndex;
80     s.keys[keyIndex] = addr;
81     return true;
82   }
83 
84   function investorFullInfo(address addr) public view returns(uint, uint, uint, uint) {
85     return (
86       s.data[addr].keyIndex,
87       s.data[addr].value,
88       s.data[addr].paymentTime,
89       s.data[addr].refBonus
90     );
91   }
92 
93   function investorBaseInfo(address addr) public view returns(uint, uint, uint) {
94     return (
95       s.data[addr].value,
96       s.data[addr].paymentTime,
97       s.data[addr].refBonus
98     );
99   }
100 
101   function investorShortInfo(address addr) public view returns(uint, uint) {
102     return (
103       s.data[addr].value,
104       s.data[addr].refBonus
105     );
106   }
107 
108   function addRefBonus(address addr, uint refBonus) public onlyOwner returns (bool) {
109     if (s.data[addr].keyIndex == 0) return false;
110     s.data[addr].refBonus += refBonus;
111     return true;
112   }
113 
114   function addValue(address addr, uint value) public onlyOwner returns (bool) {
115     if (s.data[addr].keyIndex == 0) return false;
116     s.data[addr].value += value;
117     return true;
118   }
119 
120   function setPaymentTime(address addr, uint paymentTime) public onlyOwner returns (bool) {
121     if (s.data[addr].keyIndex == 0) return false;
122     s.data[addr].paymentTime = paymentTime;
123     return true;
124   }
125 
126   function setRefBonus(address addr, uint refBonus) public onlyOwner returns (bool) {
127     if (s.data[addr].keyIndex == 0) return false;
128     s.data[addr].refBonus = refBonus;
129     return true;
130   }
131 
132   function keyFromIndex(uint i) public view returns (address) {
133     return s.keys[i];
134   }
135 
136   function contains(address addr) public view returns (bool) {
137     return s.data[addr].keyIndex > 0;
138   }
139 
140   function size() public view returns (uint) {
141     return s.keys.length;
142   }
143 
144   function iterStart() public pure returns (uint) {
145     return 1;
146   }
147 }
148 
149 
150 library SafeMath {
151   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
152     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
153     // benefit is lost if 'b' is also tested.
154     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
155     if (_a == 0) {
156       return 0;
157     }
158 
159     uint256 c = _a * _b;
160     require(c / _a == _b);
161 
162     return c;
163   }
164 
165   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
166     require(_b > 0); // Solidity only automatically asserts when dividing by 0
167     uint256 c = _a / _b;
168     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
169 
170     return c;
171   }
172 
173   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
174     require(_b <= _a);
175     uint256 c = _a - _b;
176 
177     return c;
178   }
179 
180   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
181     uint256 c = _a + _b;
182     require(c >= _a);
183 
184     return c;
185   }
186 
187   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
188     require(b != 0);
189     return a % b;
190   }
191 }
192 
193 
194 
195 library Percent {
196   // Solidity automatically throws when dividing by 0
197   struct percent {
198     uint num;
199     uint den;
200   }
201   function mul(percent storage p, uint a) internal view returns (uint) {
202     if (a == 0) {
203       return 0;
204     }
205     return a*p.num/p.den;
206   }
207 
208   function div(percent storage p, uint a) internal view returns (uint) {
209     return a/p.num*p.den;
210   }
211 
212   function sub(percent storage p, uint a) internal view returns (uint) {
213     uint b = mul(p, a);
214     if (b >= a) return 0;
215     return a - b;
216   }
217 
218   function add(percent storage p, uint a) internal view returns (uint) {
219     return a + mul(p, a);
220   }
221 }
222 
223 
224 contract Accessibility {
225   enum AccessRank { None, Payout, Paymode, Full }
226   mapping(address => AccessRank) internal m_admins;
227   modifier onlyAdmin(AccessRank  r) {
228     require(
229       m_admins[msg.sender] == r || m_admins[msg.sender] == AccessRank.Full,
230       "access denied"
231     );
232     _;
233   }
234   event LogProvideAccess(address indexed whom, uint when,  AccessRank rank);
235 
236   constructor() public {
237     m_admins[msg.sender] = AccessRank.Full;
238     emit LogProvideAccess(msg.sender, now, AccessRank.Full);
239   }
240   
241   function provideAccess(address addr, AccessRank rank) public onlyAdmin(AccessRank.Full) {
242     require(rank <= AccessRank.Full, "invalid access rank");
243     require(m_admins[addr] != AccessRank.Full, "cannot change full access rank");
244     if (m_admins[addr] != rank) {
245       m_admins[addr] = rank;
246       emit LogProvideAccess(addr, now, rank);
247     }
248   }
249 
250   function access(address addr) public view returns(AccessRank rank) {
251     rank = m_admins[addr];
252   }
253 }
254 
255 
256 contract PaymentSystem {
257   // https://consensys.github.io/smart-contract-best-practices/recommendations/#favor-pull-over-push-for-external-calls
258   enum Paymode { Push, Pull }
259   struct PaySys {
260     uint latestTime;
261     uint latestKeyIndex;
262     Paymode mode; 
263   }
264   PaySys internal m_paysys;
265 
266   modifier atPaymode(Paymode mode) {
267     require(m_paysys.mode == mode, "pay mode does not the same");
268     _;
269   }
270   event LogPaymodeChanged(uint when, Paymode indexed mode);
271   
272   function paymode() public view returns(Paymode mode) {
273     mode = m_paysys.mode;
274   }
275 
276   function changePaymode(Paymode mode) internal {
277     require(mode <= Paymode.Pull, "invalid pay mode");
278     if (mode == m_paysys.mode ) return; 
279     if (mode == Paymode.Pull) require(m_paysys.latestTime != 0, "cannot set pull pay mode if latest time is 0");
280     if (mode == Paymode.Push) m_paysys.latestTime = 0;
281     m_paysys.mode = mode;
282     emit LogPaymodeChanged(now, m_paysys.mode);
283   }
284 }
285 
286 
287 library Zero {
288   function requireNotZero(uint a) internal pure {
289     require(a != 0, "require not zero");
290   }
291 
292   function requireNotZero(address addr) internal pure {
293     require(addr != address(0), "require not zero address");
294   }
295 
296   function notZero(address addr) internal pure returns(bool) {
297     return !(addr == address(0));
298   }
299 
300   function isZero(address addr) internal pure returns(bool) {
301     return addr == address(0);
302   }
303 }
304 
305 
306 library ToAddress {
307   function toAddr(uint source) internal pure returns(address) {
308     return address(source);
309   }
310 
311   function toAddr(bytes source) internal pure returns(address addr) {
312     assembly { addr := mload(add(source,0x14)) }
313     return addr;
314   }
315 }
316 
317 
318 contract Revolution is Accessibility, PaymentSystem {
319   using Percent for Percent.percent;
320   using SafeMath for uint;
321   using Zero for *;
322   using ToAddress for *;
323 
324   // investors storage - iterable map;
325   InvestorsStorage private m_investors;
326   mapping(address => bool) private m_referrals;
327   bool private m_nextWave;
328 
329   // automatically generates getters
330   address public adminAddr;
331   address public payerAddr;
332   uint public waveStartup;
333   uint public investmentsNum;
334   uint public constant minInvesment = 50 finney; // 0.01 eth
335   uint public constant maxBalance = 333e5 ether; // 33,300,000 eth
336   uint public constant pauseOnNextWave = 168 hours; 
337 
338   // percents 
339   Percent.percent private m_dividendsPercent = Percent.percent(444, 10000); // 444/10000*100% = 4.44%
340   Percent.percent private m_adminPercent = Percent.percent(1, 10); // 1/10*100% = 10%
341   Percent.percent private m_payerPercent = Percent.percent(7, 100); // 7/100*100% = 7%
342   Percent.percent private m_refPercent = Percent.percent(3, 100); // 3/100*100% = 3%
343 
344   // more events for easy read from blockchain
345   event LogNewInvestor(address indexed addr, uint when, uint value);
346   event LogNewInvesment(address indexed addr, uint when, uint value);
347   event LogNewReferral(address indexed addr, uint when, uint value);
348   event LogPayDividends(address indexed addr, uint when, uint value);
349   event LogPayReferrerBonus(address indexed addr, uint when, uint value);
350   event LogBalanceChanged(uint when, uint balance);
351   event LogAdminAddrChanged(address indexed addr, uint when);
352   event LogPayerAddrChanged(address indexed addr, uint when);
353   event LogNextWave(uint when);
354 
355   modifier balanceChanged {
356     _;
357     emit LogBalanceChanged(now, address(this).balance);
358   }
359 
360   modifier notOnPause() {
361     require(waveStartup+pauseOnNextWave <= now, "pause on next wave not expired");
362     _;
363   }
364 
365   constructor(address admin) public {
366     adminAddr = admin;
367     emit LogAdminAddrChanged(msg.sender, now);
368 
369     payerAddr = admin;
370     emit LogPayerAddrChanged(msg.sender, now);
371 
372     nextWave();
373     waveStartup = waveStartup.sub(pauseOnNextWave);
374   }
375 
376   function() public payable {
377     // investor get him dividends
378     if (msg.value == 0) {
379       getMyDividends();
380       return;
381     }
382 
383     // sender do invest
384     address a = msg.data.toAddr();
385     address[3] memory refs;
386     if (a.notZero()) {
387       refs[0] = a;
388       doInvest(refs); 
389     } else {
390       doInvest(refs);
391     }
392   }
393 
394   function investorsNumber() public view returns(uint) {
395     return m_investors.size()-1;
396     // -1 because see InvestorsStorage constructor where keys.length++ 
397   }
398 
399   function balanceETH() public view returns(uint) {
400     return address(this).balance;
401   }
402 
403   function payerPercent() public view returns(uint numerator, uint denominator) {
404     (numerator, denominator) = (m_payerPercent.num, m_payerPercent.den);
405   }
406 
407   function dividendsPercent() public view returns(uint numerator, uint denominator) {
408     (numerator, denominator) = (m_dividendsPercent.num, m_dividendsPercent.den);
409   }
410 
411   function adminPercent() public view returns(uint numerator, uint denominator) {
412     (numerator, denominator) = (m_adminPercent.num, m_adminPercent.den);
413   }
414 
415   function referrerPercent() public view returns(uint numerator, uint denominator) {
416     (numerator, denominator) = (m_refPercent.num, m_refPercent.den);
417   }
418 
419   function investorInfo(address addr) public view returns(uint value, uint paymentTime, uint refBonus, bool isReferral) {
420     (value, paymentTime, refBonus) = m_investors.investorBaseInfo(addr);
421     isReferral = m_referrals[addr];
422   }
423 
424   function latestPayout() public view returns(uint timestamp) {
425     return m_paysys.latestTime;
426   }
427 
428   function getMyDividends() public notOnPause atPaymode(Paymode.Pull) balanceChanged {
429     // check investor info
430     InvestorsStorage.investor memory investor = getMemInvestor(msg.sender);
431     require(investor.keyIndex > 0, "sender is not investor"); 
432     if (investor.paymentTime < m_paysys.latestTime) {
433       assert(m_investors.setPaymentTime(msg.sender, m_paysys.latestTime));
434       investor.paymentTime = m_paysys.latestTime;
435     }
436 
437     // calculate days after latest payment
438     uint256 daysAfter = now.sub(investor.paymentTime).div(24 hours);
439     require(daysAfter > 0, "the latest payment was earlier than 24 hours");
440     assert(m_investors.setPaymentTime(msg.sender, now));
441 
442     // check enough eth 
443     uint value = m_dividendsPercent.mul(investor.value) * daysAfter;
444     if (address(this).balance < value + investor.refBonus) {
445       nextWave();
446       return;
447     }
448 
449     // send dividends and ref bonus
450     if (investor.refBonus > 0) {
451       assert(m_investors.setRefBonus(msg.sender, 0));
452       sendDividendsWithRefBonus(msg.sender, value, investor.refBonus);
453     } else {
454       sendDividends(msg.sender, value);
455     }
456   }
457 
458   function doInvest(address[3] refs) public payable notOnPause balanceChanged {
459     require(msg.value >= minInvesment, "msg.value must be >= minInvesment");
460     require(address(this).balance <= maxBalance, "the contract eth balance limit");
461 
462     uint value = msg.value;
463     // ref system works only once for sender-referral
464     if (!m_referrals[msg.sender]) {
465       // level 1
466       if (notZeroNotSender(refs[0]) && m_investors.contains(refs[0])) {
467         uint reward = m_refPercent.mul(value);
468         assert(m_investors.addRefBonus(refs[0], reward)); // referrer 1 bonus
469         m_referrals[msg.sender] = true;
470         value = m_dividendsPercent.add(value); // referral bonus
471         emit LogNewReferral(msg.sender, now, value);
472         // level 2
473         if (notZeroNotSender(refs[1]) && m_investors.contains(refs[1]) && refs[0] != refs[1]) { 
474           assert(m_investors.addRefBonus(refs[1], reward)); // referrer 2 bonus
475           // level 3
476           if (notZeroNotSender(refs[2]) && m_investors.contains(refs[2]) && refs[0] != refs[2] && refs[1] != refs[2]) { 
477             assert(m_investors.addRefBonus(refs[2], reward)); // referrer 3 bonus
478           }
479         }
480       }
481     }
482 
483     // commission
484     adminAddr.transfer(m_adminPercent.mul(msg.value));
485     payerAddr.transfer(m_payerPercent.mul(msg.value));    
486     
487     // write to investors storage
488     if (m_investors.contains(msg.sender)) {
489       assert(m_investors.addValue(msg.sender, value));
490     } else {
491       assert(m_investors.insert(msg.sender, value));
492       emit LogNewInvestor(msg.sender, now, value); 
493     }
494     
495     if (m_paysys.mode == Paymode.Pull)
496       assert(m_investors.setPaymentTime(msg.sender, now));
497 
498     emit LogNewInvesment(msg.sender, now, value);   
499     investmentsNum++;
500   }
501 
502   function payout() public notOnPause onlyAdmin(AccessRank.Payout) atPaymode(Paymode.Push) balanceChanged {
503     if (m_nextWave) {
504       nextWave(); 
505       return;
506     }
507    
508     // if m_paysys.latestKeyIndex == m_investors.iterStart() then payout NOT in process and we must check latest time of payment.
509     if (m_paysys.latestKeyIndex == m_investors.iterStart()) {
510       require(now>m_paysys.latestTime+12 hours, "the latest payment was earlier than 12 hours");
511       m_paysys.latestTime = now;
512     }
513 
514     uint i = m_paysys.latestKeyIndex;
515     uint value;
516     uint refBonus;
517     uint size = m_investors.size();
518     address investorAddr;
519     
520     // gasleft and latest key index  - prevent gas block limit 
521     for (i; i < size && gasleft() > 50000; i++) {
522       investorAddr = m_investors.keyFromIndex(i);
523       (value, refBonus) = m_investors.investorShortInfo(investorAddr);
524       value = m_dividendsPercent.mul(value);
525 
526       if (address(this).balance < value + refBonus) {
527         m_nextWave = true;
528         break;
529       }
530 
531       if (refBonus > 0) {
532         require(m_investors.setRefBonus(investorAddr, 0), "internal error");
533         sendDividendsWithRefBonus(investorAddr, value, refBonus);
534         continue;
535       }
536 
537       sendDividends(investorAddr, value);
538     }
539 
540     if (i == size) 
541       m_paysys.latestKeyIndex = m_investors.iterStart();
542     else 
543       m_paysys.latestKeyIndex = i;
544   }
545 
546   function setAdminAddr(address addr) public onlyAdmin(AccessRank.Full) {
547     addr.requireNotZero();
548     if (adminAddr != addr) {
549       adminAddr = addr;
550       emit LogAdminAddrChanged(addr, now);
551     }    
552   }
553 
554   function setPayerAddr(address addr) public onlyAdmin(AccessRank.Full) {
555     addr.requireNotZero();
556     if (payerAddr != addr) {
557       payerAddr = addr;
558       emit LogPayerAddrChanged(addr, now);
559     }  
560   }
561 
562   function setPullPaymode() public onlyAdmin(AccessRank.Paymode) atPaymode(Paymode.Push) {
563     changePaymode(Paymode.Pull);
564   }
565 
566   function getMemInvestor(address addr) internal view returns(InvestorsStorage.investor) {
567     (uint a, uint b, uint c, uint d) = m_investors.investorFullInfo(addr);
568     return InvestorsStorage.investor(a, b, c, d);
569   }
570 
571   function notZeroNotSender(address addr) internal view returns(bool) {
572     return addr.notZero() && addr != msg.sender;
573   }
574 
575   function sendDividends(address addr, uint value) private {
576     if (addr.send(value)) emit LogPayDividends(addr, now, value); 
577   }
578 
579   function sendDividendsWithRefBonus(address addr, uint value,  uint refBonus) private {
580     if (addr.send(value+refBonus)) {
581       emit LogPayDividends(addr, now, value);
582       emit LogPayReferrerBonus(addr, now, refBonus);
583     }
584   }
585 
586   function nextWave() private {
587     m_investors = new InvestorsStorage();
588     changePaymode(Paymode.Push);
589     m_paysys.latestKeyIndex = m_investors.iterStart();
590     investmentsNum = 0;
591     waveStartup = now;
592     m_nextWave = false;
593     emit LogNextWave(now);
594   }
595 }