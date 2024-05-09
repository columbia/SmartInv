1 pragma solidity ^0.4.23;
2 
3 /**
4 *
5 * ETH CRYPTOCURRENCY DISTRIBUTION PROJECT
6 * Web              - https://222eth.io
7 * Twitter          - https://twitter.com/222eth_io
8 * Telegram_channel - https://t.me/Ethereum222
9 * EN  Telegram_chat: https://t.me/Ethereum222_chat_en
10 * RU  Telegram_chat: https://t.me/Ethereum222_chat_ru
11 * KOR Telegram_chat: https://t.me/Ethereum222_chat_kor
12 * Email:             mailto:support(at sign)222eth.io
13 * 
14 *  - GAIN 2,22% PER 24 HOURS (every 5900 blocks)
15 *  - Life-long payments
16 *  - The revolutionary reliability
17 *  - Minimal contribution 0.01 eth
18 *  - Currency and payment - ETH
19 *  - Contribution allocation schemes:
20 *    -- 83% payments
21 *    -- 17% Marketing + Operating Expenses
22 *
23 *   ---About the Project
24 *  Blockchain-enabled smart contracts have opened a new era of trustless relationships without 
25 *  intermediaries. This technology opens incredible financial possibilities. Our automated investment 
26 *  distribution model is written into a smart contract, uploaded to the Ethereum blockchain and can be 
27 *  freely accessed online. In order to insure our investors' complete security, full control over the 
28 *  project has been transferred from the organizers to the smart contract: nobody can influence the 
29 *  system's permanent autonomous functioning.
30 * 
31 * ---How to use:
32 *  1. Send from ETH wallet to the smart contract address 0x5c5ddfe49572287c6Cb44b99C5daec0DBD7B84F5
33 *     any amount from 0.01 ETH.
34 *  2. Verify your transaction in the history of your application or etherscan.io, specifying the address 
35 *     of your wallet.
36 *  3a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're 
37 *      spending too much on GAS)
38 *  OR
39 *  3b. For reinvest, you need to first remove the accumulated percentage of charges (by sending 0 ether 
40 *      transaction), and only after that, deposit the amount that you want to reinvest.
41 *  
42 * RECOMMENDED GAS LIMIT: 200000
43 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
44 * You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.
45 *
46 * ---It is not allowed to transfer from exchanges, only from your personal ETH wallet, for which you 
47 * have private keys.
48 * 
49 * Contracts reviewed and approved by pros!
50 * 
51 * Main contract - Revolution. Scroll down to find it.
52 */
53 
54 
55 contract InvestorsStorage {
56   struct investor {
57     uint keyIndex;
58     uint value;
59     uint paymentTime;
60     uint refBonus;
61   }
62   struct itmap {
63     mapping(address => investor) data;
64     address[] keys;
65   }
66   itmap private s;
67   address private owner;
68 
69   modifier onlyOwner() {
70     require(msg.sender == owner, "access denied");
71     _;
72   }
73 
74   constructor() public {
75     owner = msg.sender;
76     s.keys.length++;
77   }
78 
79   function insert(address addr, uint value) public onlyOwner returns (bool) {
80     uint keyIndex = s.data[addr].keyIndex;
81     if (keyIndex != 0) return false;
82     s.data[addr].value = value;
83     keyIndex = s.keys.length++;
84     s.data[addr].keyIndex = keyIndex;
85     s.keys[keyIndex] = addr;
86     return true;
87   }
88 
89   function investorFullInfo(address addr) public view returns(uint, uint, uint, uint) {
90     return (
91       s.data[addr].keyIndex,
92       s.data[addr].value,
93       s.data[addr].paymentTime,
94       s.data[addr].refBonus
95     );
96   }
97 
98   function investorBaseInfo(address addr) public view returns(uint, uint, uint) {
99     return (
100       s.data[addr].value,
101       s.data[addr].paymentTime,
102       s.data[addr].refBonus
103     );
104   }
105 
106   function investorShortInfo(address addr) public view returns(uint, uint) {
107     return (
108       s.data[addr].value,
109       s.data[addr].refBonus
110     );
111   }
112 
113   function addRefBonus(address addr, uint refBonus) public onlyOwner returns (bool) {
114     if (s.data[addr].keyIndex == 0) return false;
115     s.data[addr].refBonus += refBonus;
116     return true;
117   }
118 
119   function addValue(address addr, uint value) public onlyOwner returns (bool) {
120     if (s.data[addr].keyIndex == 0) return false;
121     s.data[addr].value += value;
122     return true;
123   }
124 
125   function setPaymentTime(address addr, uint paymentTime) public onlyOwner returns (bool) {
126     if (s.data[addr].keyIndex == 0) return false;
127     s.data[addr].paymentTime = paymentTime;
128     return true;
129   }
130 
131   function setRefBonus(address addr, uint refBonus) public onlyOwner returns (bool) {
132     if (s.data[addr].keyIndex == 0) return false;
133     s.data[addr].refBonus = refBonus;
134     return true;
135   }
136 
137   function keyFromIndex(uint i) public view returns (address) {
138     return s.keys[i];
139   }
140 
141   function contains(address addr) public view returns (bool) {
142     return s.data[addr].keyIndex > 0;
143   }
144 
145   function size() public view returns (uint) {
146     return s.keys.length;
147   }
148 
149   function iterStart() public pure returns (uint) {
150     return 1;
151   }
152 }
153 
154 
155 library SafeMath {
156   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
157     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
158     // benefit is lost if 'b' is also tested.
159     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
160     if (_a == 0) {
161       return 0;
162     }
163 
164     uint256 c = _a * _b;
165     require(c / _a == _b);
166 
167     return c;
168   }
169 
170   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
171     require(_b > 0); // Solidity only automatically asserts when dividing by 0
172     uint256 c = _a / _b;
173     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
174 
175     return c;
176   }
177 
178   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
179     require(_b <= _a);
180     uint256 c = _a - _b;
181 
182     return c;
183   }
184 
185   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
186     uint256 c = _a + _b;
187     require(c >= _a);
188 
189     return c;
190   }
191 
192   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
193     require(b != 0);
194     return a % b;
195   }
196 }
197 
198 
199 
200 library Percent {
201   // Solidity automatically throws when dividing by 0
202   struct percent {
203     uint num;
204     uint den;
205   }
206   function mul(percent storage p, uint a) internal view returns (uint) {
207     if (a == 0) {
208       return 0;
209     }
210     return a*p.num/p.den;
211   }
212 
213   function div(percent storage p, uint a) internal view returns (uint) {
214     return a/p.num*p.den;
215   }
216 
217   function sub(percent storage p, uint a) internal view returns (uint) {
218     uint b = mul(p, a);
219     if (b >= a) return 0;
220     return a - b;
221   }
222 
223   function add(percent storage p, uint a) internal view returns (uint) {
224     return a + mul(p, a);
225   }
226 }
227 
228 
229 contract Accessibility {
230   enum AccessRank { None, Payout, Paymode, Full }
231   mapping(address => AccessRank) internal m_admins;
232   modifier onlyAdmin(AccessRank  r) {
233     require(
234       m_admins[msg.sender] == r || m_admins[msg.sender] == AccessRank.Full,
235       "access denied"
236     );
237     _;
238   }
239   event LogProvideAccess(address indexed whom, uint when,  AccessRank rank);
240 
241   constructor() public {
242     m_admins[msg.sender] = AccessRank.Full;
243     emit LogProvideAccess(msg.sender, now, AccessRank.Full);
244   }
245   
246   function provideAccess(address addr, AccessRank rank) public onlyAdmin(AccessRank.Full) {
247     require(rank <= AccessRank.Full, "invalid access rank");
248     require(m_admins[addr] != AccessRank.Full, "cannot change full access rank");
249     if (m_admins[addr] != rank) {
250       m_admins[addr] = rank;
251       emit LogProvideAccess(addr, now, rank);
252     }
253   }
254 
255   function access(address addr) public view returns(AccessRank rank) {
256     rank = m_admins[addr];
257   }
258 }
259 
260 
261 contract PaymentSystem {
262   // https://consensys.github.io/smart-contract-best-practices/recommendations/#favor-pull-over-push-for-external-calls
263   enum Paymode { Push, Pull }
264   struct PaySys {
265     uint latestTime;
266     uint latestKeyIndex;
267     Paymode mode; 
268   }
269   PaySys internal m_paysys;
270 
271   modifier atPaymode(Paymode mode) {
272     require(m_paysys.mode == mode, "pay mode does not the same");
273     _;
274   }
275   event LogPaymodeChanged(uint when, Paymode indexed mode);
276   
277   function paymode() public view returns(Paymode mode) {
278     mode = m_paysys.mode;
279   }
280 
281   function changePaymode(Paymode mode) internal {
282     require(mode <= Paymode.Pull, "invalid pay mode");
283     if (mode == m_paysys.mode ) return; 
284     if (mode == Paymode.Pull) require(m_paysys.latestTime != 0, "cannot set pull pay mode if latest time is 0");
285     if (mode == Paymode.Push) m_paysys.latestTime = 0;
286     m_paysys.mode = mode;
287     emit LogPaymodeChanged(now, m_paysys.mode);
288   }
289 }
290 
291 
292 library Zero {
293   function requireNotZero(uint a) internal pure {
294     require(a != 0, "require not zero");
295   }
296 
297   function requireNotZero(address addr) internal pure {
298     require(addr != address(0), "require not zero address");
299   }
300 
301   function notZero(address addr) internal pure returns(bool) {
302     return !(addr == address(0));
303   }
304 
305   function isZero(address addr) internal pure returns(bool) {
306     return addr == address(0);
307   }
308 }
309 
310 
311 library ToAddress {
312   function toAddr(uint source) internal pure returns(address) {
313     return address(source);
314   }
315 
316   function toAddr(bytes source) internal pure returns(address addr) {
317     assembly { addr := mload(add(source,0x14)) }
318     return addr;
319   }
320 }
321 
322 
323 contract Revolution is Accessibility, PaymentSystem {
324   using Percent for Percent.percent;
325   using SafeMath for uint;
326   using Zero for *;
327   using ToAddress for *;
328 
329   // investors storage - iterable map;
330   InvestorsStorage private m_investors;
331   mapping(address => bool) private m_referrals;
332   bool private m_nextWave;
333 
334   // automatically generates getters
335   address public adminAddr;
336   address public payerAddr;
337   uint public waveStartup;
338   uint public investmentsNum;
339   uint public constant minInvesment = 10 finney; // 0.01 eth
340   uint public constant maxBalance = 333e5 ether; // 33,300,000 eth
341   uint public constant pauseOnNextWave = 168 hours; 
342 
343   // percents 
344   Percent.percent private m_dividendsPercent = Percent.percent(222, 10000); // 222/10000*100% = 2.22%
345   Percent.percent private m_adminPercent = Percent.percent(1, 10); // 1/10*100% = 10%
346   Percent.percent private m_payerPercent = Percent.percent(7, 100); // 7/100*100% = 7%
347   Percent.percent private m_refPercent = Percent.percent(2, 100); // 2/100*100% = 2%
348 
349   // more events for easy read from blockchain
350   event LogNewInvestor(address indexed addr, uint when, uint value);
351   event LogNewInvesment(address indexed addr, uint when, uint value);
352   event LogNewReferral(address indexed addr, uint when, uint value);
353   event LogPayDividends(address indexed addr, uint when, uint value);
354   event LogPayReferrerBonus(address indexed addr, uint when, uint value);
355   event LogBalanceChanged(uint when, uint balance);
356   event LogAdminAddrChanged(address indexed addr, uint when);
357   event LogPayerAddrChanged(address indexed addr, uint when);
358   event LogNextWave(uint when);
359 
360   modifier balanceChanged {
361     _;
362     emit LogBalanceChanged(now, address(this).balance);
363   }
364 
365   modifier notOnPause() {
366     require(waveStartup+pauseOnNextWave <= now, "pause on next wave not expired");
367     _;
368   }
369 
370   constructor() public {
371     adminAddr = msg.sender;
372     emit LogAdminAddrChanged(msg.sender, now);
373 
374     payerAddr = msg.sender;
375     emit LogPayerAddrChanged(msg.sender, now);
376 
377     nextWave();
378     waveStartup = waveStartup.sub(pauseOnNextWave);
379   }
380 
381   function() public payable {
382     // investor get him dividends
383     if (msg.value == 0) {
384       getMyDividends();
385       return;
386     }
387 
388     // sender do invest
389     address a = msg.data.toAddr();
390     address[3] memory refs;
391     if (a.notZero()) {
392       refs[0] = a;
393       doInvest(refs); 
394     } else {
395       doInvest(refs);
396     }
397   }
398 
399   function investorsNumber() public view returns(uint) {
400     return m_investors.size()-1;
401     // -1 because see InvestorsStorage constructor where keys.length++ 
402   }
403 
404   function balanceETH() public view returns(uint) {
405     return address(this).balance;
406   }
407 
408   function payerPercent() public view returns(uint numerator, uint denominator) {
409     (numerator, denominator) = (m_payerPercent.num, m_payerPercent.den);
410   }
411 
412   function dividendsPercent() public view returns(uint numerator, uint denominator) {
413     (numerator, denominator) = (m_dividendsPercent.num, m_dividendsPercent.den);
414   }
415 
416   function adminPercent() public view returns(uint numerator, uint denominator) {
417     (numerator, denominator) = (m_adminPercent.num, m_adminPercent.den);
418   }
419 
420   function referrerPercent() public view returns(uint numerator, uint denominator) {
421     (numerator, denominator) = (m_refPercent.num, m_refPercent.den);
422   }
423 
424   function investorInfo(address addr) public view returns(uint value, uint paymentTime, uint refBonus, bool isReferral) {
425     (value, paymentTime, refBonus) = m_investors.investorBaseInfo(addr);
426     isReferral = m_referrals[addr];
427   }
428 
429   function latestPayout() public view returns(uint timestamp) {
430     return m_paysys.latestTime;
431   }
432 
433   function getMyDividends() public notOnPause atPaymode(Paymode.Pull) balanceChanged {
434     // check investor info
435     InvestorsStorage.investor memory investor = getMemInvestor(msg.sender);
436     require(investor.keyIndex > 0, "sender is not investor"); 
437     if (investor.paymentTime < m_paysys.latestTime) {
438       assert(m_investors.setPaymentTime(msg.sender, m_paysys.latestTime));
439       investor.paymentTime = m_paysys.latestTime;
440     }
441 
442     // calculate days after latest payment
443     uint256 daysAfter = now.sub(investor.paymentTime).div(24 hours);
444     require(daysAfter > 0, "the latest payment was earlier than 24 hours");
445     assert(m_investors.setPaymentTime(msg.sender, now));
446 
447     // check enough eth 
448     uint value = m_dividendsPercent.mul(investor.value) * daysAfter;
449     if (address(this).balance < value + investor.refBonus) {
450       nextWave();
451       return;
452     }
453 
454     // send dividends and ref bonus
455     if (investor.refBonus > 0) {
456       assert(m_investors.setRefBonus(msg.sender, 0));
457       sendDividendsWithRefBonus(msg.sender, value, investor.refBonus);
458     } else {
459       sendDividends(msg.sender, value);
460     }
461   }
462 
463   function doInvest(address[3] refs) private notOnPause balanceChanged {
464     require(msg.value >= minInvesment, "msg.value must be >= minInvesment");
465     require(address(this).balance <= maxBalance, "the contract eth balance limit");
466 
467     uint value = msg.value;
468     // ref system works only once for sender-referral
469     if (!m_referrals[msg.sender]) {
470       // level 1
471       if (notZeroNotSender(refs[0]) && m_investors.contains(refs[0])) {
472         uint reward = m_refPercent.mul(value);
473         assert(m_investors.addRefBonus(refs[0], reward)); // referrer 1 bonus
474         m_referrals[msg.sender] = true;
475         value = m_dividendsPercent.add(value); // referral bonus
476         emit LogNewReferral(msg.sender, now, value);
477         // level 2
478         if (notZeroNotSender(refs[1]) && m_investors.contains(refs[1]) && refs[0] != refs[1]) { 
479           assert(m_investors.addRefBonus(refs[1], reward)); // referrer 2 bonus
480           // level 3
481           if (notZeroNotSender(refs[2]) && m_investors.contains(refs[2]) && refs[0] != refs[2] && refs[1] != refs[2]) { 
482             assert(m_investors.addRefBonus(refs[2], reward)); // referrer 3 bonus
483           }
484         }
485       }
486     }
487 
488     // commission
489     adminAddr.transfer(m_adminPercent.mul(msg.value));
490     payerAddr.transfer(m_payerPercent.mul(msg.value));    
491     
492     // write to investors storage
493     if (m_investors.contains(msg.sender)) {
494       assert(m_investors.addValue(msg.sender, value));
495     } else {
496       assert(m_investors.insert(msg.sender, value));
497       emit LogNewInvestor(msg.sender, now, value); 
498     }
499     
500     if (m_paysys.mode == Paymode.Pull)
501       assert(m_investors.setPaymentTime(msg.sender, now));
502 
503     emit LogNewInvesment(msg.sender, now, value);   
504     investmentsNum++;
505   }
506 
507   function payout() public notOnPause onlyAdmin(AccessRank.Payout) atPaymode(Paymode.Push) balanceChanged {
508     if (m_nextWave) {
509       nextWave(); 
510       return;
511     }
512    
513     // if m_paysys.latestKeyIndex == m_investors.iterStart() then payout NOT in process and we must check latest time of payment.
514     if (m_paysys.latestKeyIndex == m_investors.iterStart()) {
515       require(now>m_paysys.latestTime+12 hours, "the latest payment was earlier than 12 hours");
516       m_paysys.latestTime = now;
517     }
518 
519     uint i = m_paysys.latestKeyIndex;
520     uint value;
521     uint refBonus;
522     uint size = m_investors.size();
523     address investorAddr;
524     
525     // gasleft and latest key index  - prevent gas block limit 
526     for (i; i < size && gasleft() > 50000; i++) {
527       investorAddr = m_investors.keyFromIndex(i);
528       (value, refBonus) = m_investors.investorShortInfo(investorAddr);
529       value = m_dividendsPercent.mul(value);
530 
531       if (address(this).balance < value + refBonus) {
532         m_nextWave = true;
533         break;
534       }
535 
536       if (refBonus > 0) {
537         require(m_investors.setRefBonus(investorAddr, 0), "internal error");
538         sendDividendsWithRefBonus(investorAddr, value, refBonus);
539         continue;
540       }
541 
542       sendDividends(investorAddr, value);
543     }
544 
545     if (i == size) 
546       m_paysys.latestKeyIndex = m_investors.iterStart();
547     else 
548       m_paysys.latestKeyIndex = i;
549   }
550 
551   function setAdminAddr(address addr) public onlyAdmin(AccessRank.Full) {
552     addr.requireNotZero();
553     if (adminAddr != addr) {
554       adminAddr = addr;
555       emit LogAdminAddrChanged(addr, now);
556     }    
557   }
558 
559   function setPayerAddr(address addr) public onlyAdmin(AccessRank.Full) {
560     addr.requireNotZero();
561     if (payerAddr != addr) {
562       payerAddr = addr;
563       emit LogPayerAddrChanged(addr, now);
564     }  
565   }
566 
567   function setPullPaymode() public onlyAdmin(AccessRank.Paymode) atPaymode(Paymode.Push) {
568     changePaymode(Paymode.Pull);
569   }
570 
571   function getMemInvestor(address addr) internal view returns(InvestorsStorage.investor) {
572     (uint a, uint b, uint c, uint d) = m_investors.investorFullInfo(addr);
573     return InvestorsStorage.investor(a, b, c, d);
574   }
575 
576   function notZeroNotSender(address addr) internal view returns(bool) {
577     return addr.notZero() && addr != msg.sender;
578   }
579 
580   function sendDividends(address addr, uint value) private {
581     if (addr.send(value)) emit LogPayDividends(addr, now, value); 
582   }
583 
584   function sendDividendsWithRefBonus(address addr, uint value,  uint refBonus) private {
585     if (addr.send(value+refBonus)) {
586       emit LogPayDividends(addr, now, value);
587       emit LogPayReferrerBonus(addr, now, refBonus);
588     }
589   }
590 
591   function nextWave() private {
592     m_investors = new InvestorsStorage();
593     changePaymode(Paymode.Push);
594     m_paysys.latestKeyIndex = m_investors.iterStart();
595     investmentsNum = 0;
596     waveStartup = now;
597     m_nextWave = false;
598     emit LogNextWave(now);
599   }
600 }