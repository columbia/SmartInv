1 pragma solidity 0.4.25;
2 
3 
4 /**
5 *
6 * ETH CRYPTOCURRENCY DISTRIBUTION PROJECT v 2.0
7 * Web              - https://333eth.io
8 * GitHub           - https://github.com/Revolution333/
9 * Twitter          - https://twitter.com/333eth_io
10 * Youtube          - https://www.youtube.com/c/333eth
11 * Discord          - https://discord.gg/P87buwT
12 * Telegram_channel - https://t.me/Ethereum333
13 * EN  Telegram_chat: https://t.me/Ethereum333_chat_en
14 * RU  Telegram_chat: https://t.me/Ethereum333_chat_ru
15 * KOR Telegram_chat: https://t.me/Ethereum333_chat_kor
16 * CN  Telegram_chat: https://t.me/Ethereum333_chat_cn
17 * Email:             mailto:support(at sign)333eth.io
18 * 
19 * 
20 *  - GAIN 3,33% - 1% PER 24 HOURS (interest is charges in equal parts every 10 min)
21 *  - Life-long payments
22 *  - The revolutionary reliability
23 *  - Minimal contribution 0.01 eth
24 *  - Currency and payment - ETH
25 *  - Contribution allocation schemes:
26 *    -- 87,5% payments
27 *    --  7,5% marketing
28 *    --  5,0% technical support
29 *
30 *   ---About the Project
31 *  Blockchain-enabled smart contracts have opened a new era of trustless relationships without 
32 *  intermediaries. This technology opens incredible financial possibilities. Our automated investment 
33 *  distribution model is written into a smart contract, uploaded to the Ethereum blockchain and can be 
34 *  freely accessed online. In order to insure our investors' complete security, full control over the 
35 *  project has been transferred from the organizers to the smart contract: nobody can influence the 
36 *  system's permanent autonomous functioning.
37 * 
38 * ---How to use:
39 *  1. Send from ETH wallet to the smart contract address 0x311f71389e3DE68f7B2097Ad02c6aD7B2dDE4C71
40 *     any amount from 0.01 ETH.
41 *  2. Verify your transaction in the history of your application or etherscan.io, specifying the address 
42 *     of your wallet.
43 *  3a. Claim your profit by sending 0 ether transaction (every 10 min, every day, every week, i don't care unless you're 
44 *      spending too much on GAS)
45 *  OR
46 *  3b. For reinvest, you need to deposit the amount that you want to reinvest and the 
47 *      accrued interest automatically summed to your new contribution.
48 *  
49 * RECOMMENDED GAS LIMIT: 200000
50 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
51 * You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.
52 *
53 * ---Refferral system:
54 *     from 0 to 10.000 ethers in the fund - remuneration to each contributor is 3.33%, 
55 *     from 10.000 to 100.000 ethers in the fund - remuneration will be 2%, 
56 *     from 100.000 ethers in the fund - each contributor will get 1%.
57 *
58 * ---It is not allowed to transfer from exchanges, only from your personal ETH wallet, for which you 
59 * have private keys.
60 * 
61 * Contracts reviewed and approved by pros!
62 * 
63 * Main contract - Revolution2. Scroll down to find it.
64 */ 
65 
66 
67 library Math {
68   function min(uint a, uint b) internal pure returns(uint) {
69     if (a > b) {
70       return b;
71     }
72     return a;
73   }
74 }
75 
76 
77 library Zero {
78   function requireNotZero(address addr) internal pure {
79     require(addr != address(0), "require not zero address");
80   }
81 
82   function requireNotZero(uint val) internal pure {
83     require(val != 0, "require not zero value");
84   }
85 
86   function notZero(address addr) internal pure returns(bool) {
87     return !(addr == address(0));
88   }
89 
90   function isZero(address addr) internal pure returns(bool) {
91     return addr == address(0);
92   }
93 
94   function isZero(uint a) internal pure returns(bool) {
95     return a == 0;
96   }
97 
98   function notZero(uint a) internal pure returns(bool) {
99     return a != 0;
100   }
101 }
102 
103 
104 library Percent {
105   // Solidity automatically throws when dividing by 0
106   struct percent {
107     uint num;
108     uint den;
109   }
110   
111   // storage
112   function mul(percent storage p, uint a) internal view returns (uint) {
113     if (a == 0) {
114       return 0;
115     }
116     return a*p.num/p.den;
117   }
118 
119   function div(percent storage p, uint a) internal view returns (uint) {
120     return a/p.num*p.den;
121   }
122 
123   function sub(percent storage p, uint a) internal view returns (uint) {
124     uint b = mul(p, a);
125     if (b >= a) {
126       return 0;
127     }
128     return a - b;
129   }
130 
131   function add(percent storage p, uint a) internal view returns (uint) {
132     return a + mul(p, a);
133   }
134 
135   function toMemory(percent storage p) internal view returns (Percent.percent memory) {
136     return Percent.percent(p.num, p.den);
137   }
138 
139   // memory 
140   function mmul(percent memory p, uint a) internal pure returns (uint) {
141     if (a == 0) {
142       return 0;
143     }
144     return a*p.num/p.den;
145   }
146 
147   function mdiv(percent memory p, uint a) internal pure returns (uint) {
148     return a/p.num*p.den;
149   }
150 
151   function msub(percent memory p, uint a) internal pure returns (uint) {
152     uint b = mmul(p, a);
153     if (b >= a) {
154       return 0;
155     }
156     return a - b;
157   }
158 
159   function madd(percent memory p, uint a) internal pure returns (uint) {
160     return a + mmul(p, a);
161   }
162 }
163 
164 
165 library Address {
166   function toAddress(bytes source) internal pure returns(address addr) {
167     assembly { addr := mload(add(source,0x14)) }
168     return addr;
169   }
170 
171   function isNotContract(address addr) internal view returns(bool) {
172     uint length;
173     assembly { length := extcodesize(addr) }
174     return length == 0;
175   }
176 }
177 
178 
179 /**
180  * @title SafeMath
181  * @dev Math operations with safety checks that revert on error
182  */
183 library SafeMath {
184 
185   /**
186   * @dev Multiplies two numbers, reverts on overflow.
187   */
188   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
189     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
190     // benefit is lost if 'b' is also tested.
191     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
192     if (_a == 0) {
193       return 0;
194     }
195 
196     uint256 c = _a * _b;
197     require(c / _a == _b);
198 
199     return c;
200   }
201 
202   /**
203   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
204   */
205   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
206     require(_b > 0); // Solidity only automatically asserts when dividing by 0
207     uint256 c = _a / _b;
208     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
209 
210     return c;
211   }
212 
213   /**
214   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
215   */
216   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
217     require(_b <= _a);
218     uint256 c = _a - _b;
219 
220     return c;
221   }
222 
223   /**
224   * @dev Adds two numbers, reverts on overflow.
225   */
226   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
227     uint256 c = _a + _b;
228     require(c >= _a);
229 
230     return c;
231   }
232 
233   /**
234   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
235   * reverts when dividing by zero.
236   */
237   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
238     require(b != 0);
239     return a % b;
240   }
241 }
242 
243 
244 contract Accessibility {
245   address private owner;
246   modifier onlyOwner() {
247     require(msg.sender == owner, "access denied");
248     _;
249   }
250 
251   constructor() public {
252     owner = msg.sender;
253   }
254 
255   function disown() internal {
256     delete owner;
257   }
258 }
259 
260 
261 contract Rev1Storage {
262   function investorShortInfo(address addr) public view returns(uint value, uint refBonus); 
263 }
264 
265 
266 contract Rev2Storage {
267   function investorInfo(address addr) public view returns(uint investment, uint paymentTime); 
268 }
269 
270 
271 library PrivateEntrance {
272   using PrivateEntrance for privateEntrance;
273   using Math for uint;
274   struct privateEntrance {
275     Rev1Storage rev1Storage;
276     Rev2Storage rev2Storage;
277     uint investorMaxInvestment;
278     uint endTimestamp;
279     mapping(address=>bool) hasAccess;
280   }
281 
282   function isActive(privateEntrance storage pe) internal view returns(bool) {
283     return pe.endTimestamp > now;
284   }
285 
286   function maxInvestmentFor(privateEntrance storage pe, address investorAddr) internal view returns(uint) {
287     // check if investorAddr has access
288     if (!pe.hasAccess[investorAddr]) {
289       return 0;
290     }
291 
292     // get investor max investment = investment from revolution 1
293     (uint maxInvestment, ) = pe.rev1Storage.investorShortInfo(investorAddr);
294     if (maxInvestment == 0) {
295       return 0;
296     }
297     maxInvestment = Math.min(maxInvestment, pe.investorMaxInvestment);
298 
299     // get current investment from revolution 2
300     (uint currInvestment, ) = pe.rev2Storage.investorInfo(investorAddr);
301     
302     if (currInvestment >= maxInvestment) {
303       return 0;
304     }
305 
306     return maxInvestment-currInvestment;
307   }
308 
309   function provideAccessFor(privateEntrance storage pe, address[] addrs) internal {
310     for (uint16 i; i < addrs.length; i++) {
311       pe.hasAccess[addrs[i]] = true;
312     }
313   }
314 }
315 
316 
317 contract InvestorsStorage is Accessibility {
318   struct Investor {
319     uint investment;
320     uint paymentTime;
321   }
322   uint public size;
323 
324   mapping (address => Investor) private investors;
325 
326   function isInvestor(address addr) public view returns (bool) {
327     return investors[addr].investment > 0;
328   }
329 
330   function investorInfo(address addr) public view returns(uint investment, uint paymentTime) {
331     investment = investors[addr].investment;
332     paymentTime = investors[addr].paymentTime;
333   }
334 
335   function newInvestor(address addr, uint investment, uint paymentTime) public onlyOwner returns (bool) {
336     Investor storage inv = investors[addr];
337     if (inv.investment != 0 || investment == 0) {
338       return false;
339     }
340     inv.investment = investment;
341     inv.paymentTime = paymentTime;
342     size++;
343     return true;
344   }
345 
346   function addInvestment(address addr, uint investment) public onlyOwner returns (bool) {
347     if (investors[addr].investment == 0) {
348       return false;
349     }
350     investors[addr].investment += investment;
351     return true;
352   }
353 
354   function setPaymentTime(address addr, uint paymentTime) public onlyOwner returns (bool) {
355     if (investors[addr].investment == 0) {
356       return false;
357     }
358     investors[addr].paymentTime = paymentTime;
359     return true;
360   }
361 }
362 
363 
364 library RapidGrowthProtection {
365   using RapidGrowthProtection for rapidGrowthProtection;
366   
367   struct rapidGrowthProtection {
368     uint startTimestamp;
369     uint maxDailyTotalInvestment;
370     uint8 activityDays;
371     mapping(uint8 => uint) dailyTotalInvestment;
372   }
373 
374   function maxInvestmentAtNow(rapidGrowthProtection storage rgp) internal view returns(uint) {
375     uint day = rgp.currDay();
376     if (day == 0 || day > rgp.activityDays) {
377       return 0;
378     }
379     if (rgp.dailyTotalInvestment[uint8(day)] >= rgp.maxDailyTotalInvestment) {
380       return 0;
381     }
382     return rgp.maxDailyTotalInvestment - rgp.dailyTotalInvestment[uint8(day)];
383   }
384 
385   function isActive(rapidGrowthProtection storage rgp) internal view returns(bool) {
386     uint day = rgp.currDay();
387     return day != 0 && day <= rgp.activityDays;
388   }
389 
390   function saveInvestment(rapidGrowthProtection storage rgp, uint investment) internal returns(bool) {
391     uint day = rgp.currDay();
392     if (day == 0 || day > rgp.activityDays) {
393       return false;
394     }
395     if (rgp.dailyTotalInvestment[uint8(day)] + investment > rgp.maxDailyTotalInvestment) {
396       return false;
397     }
398     rgp.dailyTotalInvestment[uint8(day)] += investment;
399     return true;
400   }
401 
402   function startAt(rapidGrowthProtection storage rgp, uint timestamp) internal { 
403     rgp.startTimestamp = timestamp;
404 
405     // restart
406     for (uint8 i = 1; i <= rgp.activityDays; i++) {
407       if (rgp.dailyTotalInvestment[i] != 0) {
408         delete rgp.dailyTotalInvestment[i];
409       }
410     }
411   }
412 
413   function currDay(rapidGrowthProtection storage rgp) internal view returns(uint day) {
414     if (rgp.startTimestamp > now) {
415       return 0;
416     }
417     day = (now - rgp.startTimestamp) / 24 hours + 1; // +1 for skip zero day
418   }
419 }
420 
421 
422 
423 
424 
425 
426 
427 
428 contract Revolution2 is Accessibility {
429   using RapidGrowthProtection for RapidGrowthProtection.rapidGrowthProtection;
430   using PrivateEntrance for PrivateEntrance.privateEntrance;
431   using Percent for Percent.percent;
432   using SafeMath for uint;
433   using Math for uint;
434 
435   // easy read for investors
436   using Address for *;
437   using Zero for *; 
438   
439   RapidGrowthProtection.rapidGrowthProtection private m_rgp;
440   PrivateEntrance.privateEntrance private m_privEnter;
441   mapping(address => bool) private m_referrals;
442   InvestorsStorage private m_investors;
443 
444   // automatically generates getters
445   uint public constant minInvesment = 10 finney; //       0.01 eth
446   uint public constant maxBalance = 333e5 ether; // 33 300 000 eth
447   address public advertisingAddress;
448   address public adminsAddress;
449   uint public investmentsNumber;
450   uint public waveStartup;
451 
452   // percents 
453   Percent.percent private m_1_percent = Percent.percent(1, 100);           //   1/100  *100% = 1%
454   Percent.percent private m_2_percent = Percent.percent(2, 100);           //   2/100  *100% = 2%
455   Percent.percent private m_3_33_percent = Percent.percent(333, 10000);    // 333/10000*100% = 3.33%
456   Percent.percent private m_adminsPercent = Percent.percent(5, 100);       //   5/100  *100% = 5%
457   Percent.percent private m_advertisingPercent = Percent.percent(75, 1000);// 75/1000  *100% = 7.5%
458 
459   // more events for easy read from blockchain
460   event LogPEInit(uint when, address rev1Storage, address rev2Storage, uint investorMaxInvestment, uint endTimestamp);
461   event LogSendExcessOfEther(address indexed addr, uint when, uint value, uint investment, uint excess);
462   event LogNewReferral(address indexed addr, address indexed referrerAddr, uint when, uint refBonus);
463   event LogRGPInit(uint when, uint startTimestamp, uint maxDailyTotalInvestment, uint activityDays);
464   event LogRGPInvestment(address indexed addr, uint when, uint investment, uint indexed day);
465   event LogNewInvesment(address indexed addr, uint when, uint investment, uint value);
466   event LogAutomaticReinvest(address indexed addr, uint when, uint investment);
467   event LogPayDividends(address indexed addr, uint when, uint dividends);
468   event LogNewInvestor(address indexed addr, uint when);
469   event LogBalanceChanged(uint when, uint balance);
470   event LogNextWave(uint when);
471   event LogDisown(uint when);
472 
473 
474   modifier balanceChanged {
475     _;
476     emit LogBalanceChanged(now, address(this).balance);
477   }
478 
479   modifier notFromContract() {
480     require(msg.sender.isNotContract(), "only externally accounts");
481     _;
482   }
483 
484   constructor() public {
485     adminsAddress = msg.sender;
486     advertisingAddress = msg.sender;
487     nextWave();
488   }
489 
490   function() public payable {
491     // investor get him dividends
492     if (msg.value.isZero()) {
493       getMyDividends();
494       return;
495     }
496 
497     // sender do invest
498     doInvest(msg.data.toAddress());
499   }
500 
501   function doDisown() public onlyOwner {
502     disown();
503     emit LogDisown(now);
504   }
505 
506   function init(address rev1StorageAddr, uint timestamp) public onlyOwner {
507     // init Rapid Growth Protection
508     m_rgp.startTimestamp = timestamp + 1;
509     m_rgp.maxDailyTotalInvestment = 500 ether;
510     m_rgp.activityDays = 21;
511     emit LogRGPInit(
512       now, 
513       m_rgp.startTimestamp,
514       m_rgp.maxDailyTotalInvestment,
515       m_rgp.activityDays
516     );
517 
518 
519     // init Private Entrance
520     m_privEnter.rev1Storage = Rev1Storage(rev1StorageAddr);
521     m_privEnter.rev2Storage = Rev2Storage(address(m_investors));
522     m_privEnter.investorMaxInvestment = 50 ether;
523     m_privEnter.endTimestamp = timestamp;
524     emit LogPEInit(
525       now, 
526       address(m_privEnter.rev1Storage), 
527       address(m_privEnter.rev2Storage), 
528       m_privEnter.investorMaxInvestment, 
529       m_privEnter.endTimestamp
530     );
531   }
532 
533   function setAdvertisingAddress(address addr) public onlyOwner {
534     addr.requireNotZero();
535     advertisingAddress = addr;
536   }
537 
538   function setAdminsAddress(address addr) public onlyOwner {
539     addr.requireNotZero();
540     adminsAddress = addr;
541   }
542 
543   function privateEntranceProvideAccessFor(address[] addrs) public onlyOwner {
544     m_privEnter.provideAccessFor(addrs);
545   }
546 
547   function rapidGrowthProtectionmMaxInvestmentAtNow() public view returns(uint investment) {
548     investment = m_rgp.maxInvestmentAtNow();
549   }
550 
551   function investorsNumber() public view returns(uint) {
552     return m_investors.size();
553   }
554 
555   function balanceETH() public view returns(uint) {
556     return address(this).balance;
557   }
558 
559   function percent1() public view returns(uint numerator, uint denominator) {
560     (numerator, denominator) = (m_1_percent.num, m_1_percent.den);
561   }
562 
563   function percent2() public view returns(uint numerator, uint denominator) {
564     (numerator, denominator) = (m_2_percent.num, m_2_percent.den);
565   }
566 
567   function percent3_33() public view returns(uint numerator, uint denominator) {
568     (numerator, denominator) = (m_3_33_percent.num, m_3_33_percent.den);
569   }
570 
571   function advertisingPercent() public view returns(uint numerator, uint denominator) {
572     (numerator, denominator) = (m_advertisingPercent.num, m_advertisingPercent.den);
573   }
574 
575   function adminsPercent() public view returns(uint numerator, uint denominator) {
576     (numerator, denominator) = (m_adminsPercent.num, m_adminsPercent.den);
577   }
578 
579   function investorInfo(address investorAddr) public view returns(uint investment, uint paymentTime, bool isReferral) {
580     (investment, paymentTime) = m_investors.investorInfo(investorAddr);
581     isReferral = m_referrals[investorAddr];
582   }
583 
584   function investorDividendsAtNow(address investorAddr) public view returns(uint dividends) {
585     dividends = calcDividends(investorAddr);
586   }
587 
588   function dailyPercentAtNow() public view returns(uint numerator, uint denominator) {
589     Percent.percent memory p = dailyPercent();
590     (numerator, denominator) = (p.num, p.den);
591   }
592 
593   function refBonusPercentAtNow() public view returns(uint numerator, uint denominator) {
594     Percent.percent memory p = refBonusPercent();
595     (numerator, denominator) = (p.num, p.den);
596   }
597 
598   function getMyDividends() public notFromContract balanceChanged {
599     // calculate dividends
600     uint dividends = calcDividends(msg.sender);
601     require (dividends.notZero(), "cannot to pay zero dividends");
602 
603     // update investor payment timestamp
604     assert(m_investors.setPaymentTime(msg.sender, now));
605 
606     // check enough eth - goto next wave if needed
607     if (address(this).balance <= dividends) {
608       nextWave();
609       dividends = address(this).balance;
610     } 
611 
612     // transfer dividends to investor
613     msg.sender.transfer(dividends);
614     emit LogPayDividends(msg.sender, now, dividends);
615   }
616 
617   function doInvest(address referrerAddr) public payable notFromContract balanceChanged {
618     uint investment = msg.value;
619     uint receivedEther = msg.value;
620     require(investment >= minInvesment, "investment must be >= minInvesment");
621     require(address(this).balance <= maxBalance, "the contract eth balance limit");
622 
623     if (m_rgp.isActive()) { 
624       // use Rapid Growth Protection if needed
625       uint rpgMaxInvest = m_rgp.maxInvestmentAtNow();
626       rpgMaxInvest.requireNotZero();
627       investment = Math.min(investment, rpgMaxInvest);
628       assert(m_rgp.saveInvestment(investment));
629       emit LogRGPInvestment(msg.sender, now, investment, m_rgp.currDay());
630       
631     } else if (m_privEnter.isActive()) {
632       // use Private Entrance if needed
633       uint peMaxInvest = m_privEnter.maxInvestmentFor(msg.sender);
634       peMaxInvest.requireNotZero();
635       investment = Math.min(investment, peMaxInvest);
636     }
637 
638     // send excess of ether if needed
639     if (receivedEther > investment) {
640       uint excess = receivedEther - investment;
641       msg.sender.transfer(excess);
642       receivedEther = investment;
643       emit LogSendExcessOfEther(msg.sender, now, msg.value, investment, excess);
644     }
645 
646     // commission
647     advertisingAddress.send(m_advertisingPercent.mul(receivedEther));
648     adminsAddress.send(m_adminsPercent.mul(receivedEther));
649 
650     bool senderIsInvestor = m_investors.isInvestor(msg.sender);
651 
652     // ref system works only once and only on first invest
653     if (referrerAddr.notZero() && !senderIsInvestor && !m_referrals[msg.sender] &&
654       referrerAddr != msg.sender && m_investors.isInvestor(referrerAddr)) {
655       
656       m_referrals[msg.sender] = true;
657       // add referral bonus to investor`s and referral`s investments
658       uint refBonus = refBonusPercent().mmul(investment);
659       assert(m_investors.addInvestment(referrerAddr, refBonus)); // add referrer bonus
660       investment += refBonus;                                    // add referral bonus
661       emit LogNewReferral(msg.sender, referrerAddr, now, refBonus);
662     }
663 
664     // automatic reinvest - prevent burning dividends
665     uint dividends = calcDividends(msg.sender);
666     if (senderIsInvestor && dividends.notZero()) {
667       investment += dividends;
668       emit LogAutomaticReinvest(msg.sender, now, dividends);
669     }
670 
671     if (senderIsInvestor) {
672       // update existing investor
673       assert(m_investors.addInvestment(msg.sender, investment));
674       assert(m_investors.setPaymentTime(msg.sender, now));
675     } else {
676       // create new investor
677       assert(m_investors.newInvestor(msg.sender, investment, now));
678       emit LogNewInvestor(msg.sender, now);
679     }
680 
681     investmentsNumber++;
682     emit LogNewInvesment(msg.sender, now, investment, receivedEther);
683   }
684 
685   function getMemInvestor(address investorAddr) internal view returns(InvestorsStorage.Investor memory) {
686     (uint investment, uint paymentTime) = m_investors.investorInfo(investorAddr);
687     return InvestorsStorage.Investor(investment, paymentTime);
688   }
689 
690   function calcDividends(address investorAddr) internal view returns(uint dividends) {
691     InvestorsStorage.Investor memory investor = getMemInvestor(investorAddr);
692 
693     // safe gas if dividends will be 0
694     if (investor.investment.isZero() || now.sub(investor.paymentTime) < 10 minutes) {
695       return 0;
696     }
697     
698     // for prevent burning daily dividends if 24h did not pass - calculate it per 10 min interval
699     // if daily percent is X, then 10min percent = X / (24h / 10 min) = X / 144
700 
701     // and we must to get numbers of 10 min interval after investor got payment:
702     // (now - investor.paymentTime) / 10min 
703 
704     // finaly calculate dividends = ((now - investor.paymentTime) / 10min) * (X * investor.investment)  / 144) 
705 
706     Percent.percent memory p = dailyPercent();
707     dividends = (now.sub(investor.paymentTime) / 10 minutes) * p.mmul(investor.investment) / 144;
708   }
709 
710   function dailyPercent() internal view returns(Percent.percent memory p) {
711     uint balance = address(this).balance;
712 
713     // (3) 3.33% if balance < 1 000 ETH
714     // (2) 2% if 1 000 ETH <= balance <= 33 333 ETH
715     // (1) 1% if 33 333 ETH < balance
716 
717     if (balance < 1000 ether) { 
718       p = m_3_33_percent.toMemory(); // (3)
719     } else if ( 1000 ether <= balance && balance <= 33333 ether) {
720       p = m_2_percent.toMemory();    // (2)
721     } else {
722       p = m_1_percent.toMemory();    // (1)
723     }
724   }
725 
726   function refBonusPercent() internal view returns(Percent.percent memory p) {
727     uint balance = address(this).balance;
728 
729     // (1) 1% if 100 000 ETH < balance
730     // (2) 2% if 10 000 ETH <= balance <= 100 000 ETH
731     // (3) 3.33% if balance < 10 000 ETH   
732     
733     if (balance < 10000 ether) { 
734       p = m_3_33_percent.toMemory(); // (3)
735     } else if ( 10000 ether <= balance && balance <= 100000 ether) {
736       p = m_2_percent.toMemory();    // (2)
737     } else {
738       p = m_1_percent.toMemory();    // (1)
739     }          
740   }
741 
742   function nextWave() private {
743     m_investors = new InvestorsStorage();
744     investmentsNumber = 0;
745     waveStartup = now;
746     m_rgp.startAt(now);
747     emit LogRGPInit(now , m_rgp.startTimestamp, m_rgp.maxDailyTotalInvestment, m_rgp.activityDays);
748     emit LogNextWave(now);
749   }
750 }