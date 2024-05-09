1 pragma solidity ^0.4.23;
2 
3 /**
4 *
5 * Investment project for the distribution of cryptocurrency Ethereum
6 * Web              - http://magic-eth.com/ 
7 * Youtube          - https://www.youtube.com/channel/UCZ2P-5NMSHdveoK9e_BRUBw/ 
8 * Email:           - support(at sign)magic-eth.com 
9 * 
10 * 
11 * - Payments from 3% to 6% every 24 hours
12 * - Lifetime payments
13 * - Reliability Smart Contract
14 * - Minimum deposit 0.03 ETH
15 * - Currency and Payment - Ethereum (ETH)
16 * - Distribution of deposits:
17 * - 80% For payments to participants of the Fund
18 * - 5% INSURANCE FUND
19 * - 10% Advertising and project development
20 * - 1% Commission services and transactions
21 * - 2% Payroll fund
22 * - 2% Technical support
23 *    
24 *
25 *   ---About the Project
26 * Intellectual contracts with Blockchain support have opened a new era of secure relationships without intermediaries.
27 This technology opens up incredible financial opportunities. Our automated investment model
28 and asset allocation is written in a smart contract, loaded into the Ethereum blockchain and opened for public access on the Internet and in Blockchain. To ensure the complete safety of all our investors and safe investments, full control over the project was transferred from the organizers to the Smart contract - and now no one can influence continuous autonomous functioning of the system.
29 * 
30 * ---How to use:
31 *  1. Send from ETH wallet to the smart contract address
32 *     any amount from 0.03 ETH.
33 *  2. Verify your transaction in the history of your application or etherscan.io, specifying the address 
34 *     of your wallet.
35 *  3. Get your profit by sending 0 live transactions (every day, every week, at any time, but not more often than once per 24 hours.
36 *  4. To reinvest, you need to deposit the amount you want to reinvest, and the interest accrued is automatically added to your new deposit.
37 *  
38 * RECOMMENDED GAS LIMIT: 200000
39 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
40 * You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.
41 *
42 * ---Referral system:
43 *   Affiliate program has 3 levels: First level - 3%, second level - 2%, third level - 1%.
44 *
45 * Attention! It is not allowed to transfer from exchanges, only from your personal wallet ETH, for which you have private keys.
46 * 
47 * More information can be found on the website - http://magic-eth.com/ 
48 *
49 * Main contract - Magic. Scroll down to find it.
50 */ 
51 
52 
53 
54 contract InvestorsStorage {
55   struct investor {
56     uint keyIndex;
57     uint value;
58     uint paymentTime;
59     uint refBonus;
60   }
61   struct itmap {
62     mapping(address => investor) data;
63     address[] keys;
64   }
65   itmap private s;
66   address private owner;
67 
68   modifier onlyOwner() {
69     require(msg.sender == owner, "access denied");
70     _;
71   }
72 
73   constructor() public {
74     owner = msg.sender;
75     s.keys.length++;
76   }
77 
78   function insert(address addr, uint value) public onlyOwner returns (bool) {
79     uint keyIndex = s.data[addr].keyIndex;
80     if (keyIndex != 0) return false;
81     s.data[addr].value = value;
82     keyIndex = s.keys.length++;
83     s.data[addr].keyIndex = keyIndex;
84     s.keys[keyIndex] = addr;
85     return true;
86   }
87 
88   function investorFullInfo(address addr) public view returns(uint, uint, uint, uint) {
89     return (
90       s.data[addr].keyIndex,
91       s.data[addr].value,
92       s.data[addr].paymentTime,
93       s.data[addr].refBonus
94     );
95   }
96 
97   function investorBaseInfo(address addr) public view returns(uint, uint, uint) {
98     return (
99       s.data[addr].value,
100       s.data[addr].paymentTime,
101       s.data[addr].refBonus
102     );
103   }
104 
105   function investorShortInfo(address addr) public view returns(uint, uint) {
106     return (
107       s.data[addr].value,
108       s.data[addr].refBonus
109     );
110   }
111 
112   function addRefBonus(address addr, uint refBonus) public onlyOwner returns (bool) {
113     if (s.data[addr].keyIndex == 0) return false;
114     s.data[addr].refBonus += refBonus;
115     return true;
116   }
117 
118   function addValue(address addr, uint value) public onlyOwner returns (bool) {
119     if (s.data[addr].keyIndex == 0) return false;
120     s.data[addr].value += value;
121     return true;
122   }
123 
124   function setPaymentTime(address addr, uint paymentTime) public onlyOwner returns (bool) {
125     if (s.data[addr].keyIndex == 0) return false;
126     s.data[addr].paymentTime = paymentTime;
127     return true;
128   }
129 
130   function setRefBonus(address addr, uint refBonus) public onlyOwner returns (bool) {
131     if (s.data[addr].keyIndex == 0) return false;
132     s.data[addr].refBonus = refBonus;
133     return true;
134   }
135 
136   function keyFromIndex(uint i) public view returns (address) {
137     return s.keys[i];
138   }
139 
140   function contains(address addr) public view returns (bool) {
141     return s.data[addr].keyIndex > 0;
142   }
143 
144   function size() public view returns (uint) {
145     return s.keys.length;
146   }
147 
148   function iterStart() public pure returns (uint) {
149     return 1;
150   }
151 }
152 
153 
154 library SafeMath {
155   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
156     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
157     // benefit is lost if 'b' is also tested.
158     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
159     if (_a == 0) {
160       return 0;
161     }
162 
163     uint256 c = _a * _b;
164     require(c / _a == _b);
165 
166     return c;
167   }
168 
169   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
170     require(_b > 0); // Solidity only automatically asserts when dividing by 0
171     uint256 c = _a / _b;
172     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
173 
174     return c;
175   }
176 
177   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
178     require(_b <= _a);
179     uint256 c = _a - _b;
180 
181     return c;
182   }
183 
184   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
185     uint256 c = _a + _b;
186     require(c >= _a);
187 
188     return c;
189   }
190 
191   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
192     require(b != 0);
193     return a % b;
194   }
195 }
196 
197 
198 
199 library Percent {
200   // Solidity automatically throws when dividing by 0
201   struct percent {
202     uint num;
203     uint den;
204   }
205   function mul(percent storage p, uint a) internal view returns (uint) {
206     if (a == 0) {
207       return 0;
208     }
209     return a*p.num/p.den;
210   }
211 
212   function div(percent storage p, uint a) internal view returns (uint) {
213     return a/p.num*p.den;
214   }
215 
216   function sub(percent storage p, uint a) internal view returns (uint) {
217     uint b = mul(p, a);
218     if (b >= a) return 0;
219     return a - b;
220   }
221 
222   function add(percent storage p, uint a) internal view returns (uint) {
223     return a + mul(p, a);
224   }
225 }
226 
227 
228 contract Accessibility {
229   enum AccessRank { None, Payout, Paymode, Full }
230   mapping(address => AccessRank) internal m_admins;
231   modifier onlyAdmin(AccessRank  r) {
232     require(
233       m_admins[msg.sender] == r || m_admins[msg.sender] == AccessRank.Full,
234       "access denied"
235     );
236     _;
237   }
238   event LogProvideAccess(address indexed whom, uint when,  AccessRank rank);
239 
240   constructor() public {
241     m_admins[msg.sender] = AccessRank.Full;
242     emit LogProvideAccess(msg.sender, now, AccessRank.Full);
243   }
244 
245   function provideAccess(address addr, AccessRank rank) public onlyAdmin(AccessRank.Full) {
246     require(rank <= AccessRank.Full, "invalid access rank");
247     require(m_admins[addr] != AccessRank.Full, "cannot change full access rank");
248     if (m_admins[addr] != rank) {
249       m_admins[addr] = rank;
250       emit LogProvideAccess(addr, now, rank);
251     }
252   }
253 
254   function access(address addr) public view returns(AccessRank rank) {
255     rank = m_admins[addr];
256   }
257 }
258 
259 
260 contract PaymentSystem {
261   // https://consensys.github.io/smart-contract-best-practices/recommendations/#favor-pull-over-push-for-external-calls
262   enum Paymode { Push, Pull }
263   struct PaySys {
264     uint latestTime;
265     uint latestKeyIndex;
266     Paymode mode;
267   }
268   PaySys internal m_paysys;
269 
270   modifier atPaymode(Paymode mode) {
271     require(m_paysys.mode == mode, "pay mode does not the same");
272     _;
273   }
274   event LogPaymodeChanged(uint when, Paymode indexed mode);
275 
276   function paymode() public view returns(Paymode mode) {
277     mode = m_paysys.mode;
278   }
279 
280   function changePaymode(Paymode mode) internal {
281     require(mode <= Paymode.Pull, "invalid pay mode");
282     if (mode == m_paysys.mode ) return;
283     if (mode == Paymode.Pull) require(m_paysys.latestTime != 0, "cannot set pull pay mode if latest time is 0");
284     if (mode == Paymode.Push) m_paysys.latestTime = 0;
285     m_paysys.mode = mode;
286     emit LogPaymodeChanged(now, m_paysys.mode);
287   }
288 }
289 
290 
291 library Zero {
292   function requireNotZero(uint a) internal pure {
293     require(a != 0, "require not zero");
294   }
295 
296   function requireNotZero(address addr) internal pure {
297     require(addr != address(0), "require not zero address");
298   }
299 
300   function notZero(address addr) internal pure returns(bool) {
301     return !(addr == address(0));
302   }
303 
304   function isZero(address addr) internal pure returns(bool) {
305     return addr == address(0);
306   }
307 }
308 
309 
310 library ToAddress {
311   function toAddr(uint source) internal pure returns(address) {
312     return address(source);
313   }
314 
315   function toAddr(bytes source) internal pure returns(address addr) {
316     assembly { addr := mload(add(source,0x14)) }
317     return addr;
318   }
319 }
320 
321 
322 contract Magic is Accessibility, PaymentSystem {
323   using Percent for Percent.percent;
324   using SafeMath for uint;
325   using Zero for *;
326   using ToAddress for *;
327 
328   // investors storage - iterable map;
329   InvestorsStorage private m_investors;
330   mapping(address => bool) private m_referrals;
331   bool private m_nextWave;
332 
333   // automatically generates getters
334   address public adminAddr;
335   address public payerAddr;
336   uint public waveStartup;
337   uint public investmentsNum;
338   uint public constant minInvesment = 30 finney; // 0.03 eth
339   uint public constant maxBalance = 333e5 ether; // 33,300,000 eth
340   uint public constant pauseOnNextWave = 168 hours;
341 
342     //float percents
343     Percent.percent private m_dividendsPercent30 = Percent.percent(30, 1000); // 30/1000*100% = 3%
344     Percent.percent private m_dividendsPercent35 = Percent.percent(35, 1000); // 35/1000*100% = 3.5%
345     Percent.percent private m_dividendsPercent40 = Percent.percent(40, 1000); // 40/1000*100% = 4%
346     Percent.percent private m_dividendsPercent45 = Percent.percent(45, 1000); // 45/1000*100% = 4.5%
347     Percent.percent private m_dividendsPercent50 = Percent.percent(50, 1000); // 50/1000*100% = 5%
348     Percent.percent private m_dividendsPercent55 = Percent.percent(55, 1000); // 55/1000*100% = 5.5%
349     Percent.percent private m_dividendsPercent60 = Percent.percent(60, 1000); // 60/1000*100% = 6%
350 
351 
352   Percent.percent private m_adminPercent = Percent.percent(15, 100); // 15/100*100% = 15%
353   Percent.percent private m_payerPercent = Percent.percent(5, 100); // 5/100*100% = 5%
354 
355   Percent.percent private m_refLvlOnePercent = Percent.percent(3, 100); // 3/100*100% = 3%
356   Percent.percent private m_refLvlTwoPercent = Percent.percent(2, 100); // 2/100*100% = 2%
357   Percent.percent private m_refLvlThreePercent = Percent.percent(1, 100); // 1/100*100% = 1%
358 
359 
360   // more events for easy read from blockchain
361   event LogNewInvestor(address indexed addr, uint when, uint value);
362   event LogNewInvesment(address indexed addr, uint when, uint value);
363   event LogNewReferral(address indexed addr, uint when, uint value);
364   event LogPayDividends(address indexed addr, uint when, uint value);
365   event LogPayReferrerBonus(address indexed addr, uint when, uint value);
366   event LogBalanceChanged(uint when, uint balance);
367   event LogAdminAddrChanged(address indexed addr, uint when);
368   event LogPayerAddrChanged(address indexed addr, uint when);
369   event LogNextWave(uint when);
370 
371   modifier balanceChanged {
372     _;
373     emit LogBalanceChanged(now, address(this).balance);
374   }
375 
376   modifier notOnPause() {
377     require(waveStartup+pauseOnNextWave <= now, "pause on next wave not expired");
378     _;
379   }
380 
381   constructor() public {
382     adminAddr = msg.sender;
383     emit LogAdminAddrChanged(msg.sender, now);
384 
385     payerAddr = msg.sender;
386     emit LogPayerAddrChanged(msg.sender, now);
387 
388     nextWave();
389     waveStartup = waveStartup.sub(pauseOnNextWave);
390   }
391 
392   function() public payable {
393     // investor get him dividends
394     if (msg.value == 0) {
395       getMyDividends();
396       return;
397     }
398 
399     // sender do invest
400     address a = msg.data.toAddr();
401     address[3] memory refs;
402     if (a.notZero()) {
403       refs[0] = a;
404       doInvest(refs);
405     } else {
406       doInvest(refs);
407     }
408   }
409 
410   function investorsNumber() public view returns(uint) {
411     return m_investors.size()-1;
412     // -1 because see InvestorsStorage constructor where keys.length++
413   }
414 
415   function balanceETH() public view returns(uint) {
416     return address(this).balance;
417   }
418 
419 
420   function payerPercent() public view returns(uint numerator, uint denominator) {
421     (numerator, denominator) = (m_payerPercent.num, m_payerPercent.den);
422   }
423   function dividendsPercent30() public view returns(uint numerator, uint denominator) {
424     (numerator, denominator) = (m_dividendsPercent30.num, m_dividendsPercent30.den);
425   }
426   function dividendsPercent35() public view returns(uint numerator, uint denominator) {
427     (numerator, denominator) = (m_dividendsPercent35.num, m_dividendsPercent35.den);
428   }
429   function dividendsPercent40() public view returns(uint numerator, uint denominator) {
430     (numerator, denominator) = (m_dividendsPercent40.num, m_dividendsPercent40.den);
431   }
432   function dividendsPercent45() public view returns(uint numerator, uint denominator) {
433     (numerator, denominator) = (m_dividendsPercent45.num, m_dividendsPercent45.den);
434   }
435   function dividendsPercent50() public view returns(uint numerator, uint denominator) {
436     (numerator, denominator) = (m_dividendsPercent50.num, m_dividendsPercent50.den);
437   }
438   function dividendsPercent55() public view returns(uint numerator, uint denominator) {
439     (numerator, denominator) = (m_dividendsPercent55.num, m_dividendsPercent55.den);
440   }
441   function dividendsPercent60() public view returns(uint numerator, uint denominator) {
442     (numerator, denominator) = (m_dividendsPercent60.num, m_dividendsPercent60.den);
443   }
444   function adminPercent() public view returns(uint numerator, uint denominator) {
445     (numerator, denominator) = (m_adminPercent.num, m_adminPercent.den);
446   }
447   function referrerLvlOnePercent() public view returns(uint numerator, uint denominator) {
448     (numerator, denominator) = (m_refLvlOnePercent.num, m_refLvlOnePercent.den);
449   }
450   function referrerLvlTwoPercent() public view returns(uint numerator, uint denominator) {
451     (numerator, denominator) = (m_refLvlTwoPercent.num, m_refLvlTwoPercent.den);
452   }
453   function referrerLvlThreePercent() public view returns(uint numerator, uint denominator) {
454     (numerator, denominator) = (m_refLvlThreePercent.num, m_refLvlThreePercent.den);
455   }
456 
457   function investorInfo(address addr) public view returns(uint value, uint paymentTime, uint refBonus, bool isReferral) {
458     (value, paymentTime, refBonus) = m_investors.investorBaseInfo(addr);
459     isReferral = m_referrals[addr];
460   }
461 
462   function latestPayout() public view returns(uint timestamp) {
463     return m_paysys.latestTime;
464   }
465 
466   function getMyDividends() public notOnPause atPaymode(Paymode.Pull) balanceChanged {
467     // check investor info
468     InvestorsStorage.investor memory investor = getMemInvestor(msg.sender);
469     require(investor.keyIndex > 0, "sender is not investor");
470     if (investor.paymentTime < m_paysys.latestTime) {
471       assert(m_investors.setPaymentTime(msg.sender, m_paysys.latestTime));
472       investor.paymentTime = m_paysys.latestTime;
473     }
474 
475     // calculate days after latest payment
476     uint256 daysAfter = now.sub(investor.paymentTime).div(24 hours);
477     require(daysAfter > 0, "the latest payment was earlier than 24 hours");
478     assert(m_investors.setPaymentTime(msg.sender, now));
479 
480     uint value = 0;
481 
482     if (address(this).balance < 500 ether){
483       value = m_dividendsPercent30.mul(investor.value) * daysAfter;
484     }
485     if (500 ether <= address(this).balance && address(this).balance < 1000 ether){
486       value = m_dividendsPercent35.mul(investor.value) * daysAfter;
487     }
488     if (1000 ether <= address(this).balance && address(this).balance < 2000 ether){
489       value = m_dividendsPercent40.mul(investor.value) * daysAfter;
490     }
491     if (2000 ether <= address(this).balance && address(this).balance < 3000 ether){
492       value = m_dividendsPercent45.mul(investor.value) * daysAfter;
493     }
494     if (3000 ether <= address(this).balance && address(this).balance < 4000 ether){
495       value = m_dividendsPercent50.mul(investor.value) * daysAfter;
496     }
497     if (4000 ether <= address(this).balance && address(this).balance < 5000 ether){
498       value = m_dividendsPercent55.mul(investor.value) * daysAfter;
499     }
500     if (5000 ether <= address(this).balance){
501       value = m_dividendsPercent60.mul(investor.value) * daysAfter;
502     }
503 
504     // check enough eth
505     if (address(this).balance < value + investor.refBonus) {
506       nextWave();
507       return;
508     }
509 
510     // send dividends and ref bonus
511     if (investor.refBonus > 0) {
512       assert(m_investors.setRefBonus(msg.sender, 0));
513       sendDividendsWithRefBonus(msg.sender, value, investor.refBonus);
514     } else {
515       sendDividends(msg.sender, value);
516     }
517   }
518 
519   function doInvest(address[3] refs) public payable notOnPause balanceChanged {
520     require(msg.value >= minInvesment, "msg.value must be >= minInvesment");
521     require(address(this).balance <= maxBalance, "the contract eth balance limit");
522 
523     uint value = msg.value;
524     // ref system works only once for sender-referral
525     if (!m_referrals[msg.sender]) {
526       // level 1
527       if (notZeroNotSender(refs[0]) && m_investors.contains(refs[0])) {
528         uint rewardL1 = m_refLvlOnePercent.mul(value);
529         assert(m_investors.addRefBonus(refs[0], rewardL1)); // referrer 1 bonus
530         m_referrals[msg.sender] = true;
531         value = m_dividendsPercent30.add(value); // referral bonus
532         emit LogNewReferral(msg.sender, now, value);
533         // level 2
534         if (notZeroNotSender(refs[1]) && m_investors.contains(refs[1]) && refs[0] != refs[1]) {
535           uint rewardL2 = m_refLvlTwoPercent.mul(value);
536           assert(m_investors.addRefBonus(refs[1], rewardL2)); // referrer 2 bonus
537           // level 3
538           if (notZeroNotSender(refs[2]) && m_investors.contains(refs[2]) && refs[0] != refs[2] && refs[1] != refs[2]) {
539             uint rewardL3 = m_refLvlThreePercent.mul(value);
540             assert(m_investors.addRefBonus(refs[2], rewardL3)); // referrer 3 bonus
541           }
542         }
543       }
544     }
545 
546     // commission
547     adminAddr.transfer(m_adminPercent.mul(msg.value));
548     payerAddr.transfer(m_payerPercent.mul(msg.value));
549 
550     // write to investors storage
551     if (m_investors.contains(msg.sender)) {
552       assert(m_investors.addValue(msg.sender, value));
553     } else {
554       assert(m_investors.insert(msg.sender, value));
555       emit LogNewInvestor(msg.sender, now, value);
556     }
557 
558     if (m_paysys.mode == Paymode.Pull)
559       assert(m_investors.setPaymentTime(msg.sender, now));
560 
561     emit LogNewInvesment(msg.sender, now, value);
562     investmentsNum++;
563   }
564 
565   function payout() public notOnPause onlyAdmin(AccessRank.Payout) atPaymode(Paymode.Push) balanceChanged {
566     if (m_nextWave) {
567       nextWave();
568       return;
569     }
570 
571     // if m_paysys.latestKeyIndex == m_investors.iterStart() then payout NOT in process and we must check latest time of payment.
572     if (m_paysys.latestKeyIndex == m_investors.iterStart()) {
573       require(now>m_paysys.latestTime+12 hours, "the latest payment was earlier than 12 hours");
574       m_paysys.latestTime = now;
575     }
576 
577     uint i = m_paysys.latestKeyIndex;
578     uint value;
579     uint refBonus;
580     uint size = m_investors.size();
581     address investorAddr;
582 
583     // gasleft and latest key index  - prevent gas block limit
584     for (i; i < size && gasleft() > 50000; i++) {
585       investorAddr = m_investors.keyFromIndex(i);
586       (value, refBonus) = m_investors.investorShortInfo(investorAddr);
587       value = m_dividendsPercent30.mul(value);
588 
589       if (address(this).balance < value + refBonus) {
590         m_nextWave = true;
591         break;
592       }
593 
594       if (refBonus > 0) {
595         require(m_investors.setRefBonus(investorAddr, 0), "internal error");
596         sendDividendsWithRefBonus(investorAddr, value, refBonus);
597         continue;
598       }
599 
600       sendDividends(investorAddr, value);
601     }
602 
603     if (i == size)
604       m_paysys.latestKeyIndex = m_investors.iterStart();
605     else
606       m_paysys.latestKeyIndex = i;
607   }
608 
609   function setAdminAddr(address addr) public onlyAdmin(AccessRank.Full) {
610     addr.requireNotZero();
611     if (adminAddr != addr) {
612       adminAddr = addr;
613       emit LogAdminAddrChanged(addr, now);
614     }
615   }
616 
617   function setPayerAddr(address addr) public onlyAdmin(AccessRank.Full) {
618     addr.requireNotZero();
619     if (payerAddr != addr) {
620       payerAddr = addr;
621       emit LogPayerAddrChanged(addr, now);
622     }
623   }
624 
625   function setPullPaymode() public onlyAdmin(AccessRank.Paymode) atPaymode(Paymode.Push) {
626     changePaymode(Paymode.Pull);
627   }
628 
629   function getMemInvestor(address addr) internal view returns(InvestorsStorage.investor) {
630     (uint a, uint b, uint c, uint d) = m_investors.investorFullInfo(addr);
631     return InvestorsStorage.investor(a, b, c, d);
632   }
633 
634   function notZeroNotSender(address addr) internal view returns(bool) {
635     return addr.notZero() && addr != msg.sender;
636   }
637 
638   function sendDividends(address addr, uint value) private {
639     if (addr.send(value)) emit LogPayDividends(addr, now, value);
640   }
641 
642   function sendDividendsWithRefBonus(address addr, uint value,  uint refBonus) private {
643     if (addr.send(value+refBonus)) {
644       emit LogPayDividends(addr, now, value);
645       emit LogPayReferrerBonus(addr, now, refBonus);
646     }
647   }
648 
649   function nextWave() private {
650     m_investors = new InvestorsStorage();
651     changePaymode(Paymode.Push);
652     m_paysys.latestKeyIndex = m_investors.iterStart();
653     investmentsNum = 0;
654     waveStartup = now;
655     m_nextWave = false;
656     emit LogNextWave(now);
657   }
658 }