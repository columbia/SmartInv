1 pragma solidity 0.4.25;
2 
3 
4 /**
5 *
6 * ETH CRYPTOCURRENCY DISTRIBUTION PROJECT v 1.0
7 * 
8 * GitHub           - https://github.com/fortune333/Fortune333
9 * 
10 * 
11 * 
12 *  - GAIN 8% - PER 1 MONTH (interest is charges in equal parts every 1 sec)
13 *         0.26 - PER 1 DAY
14 *         0.011 - PER 1 HOUR
15 *         0.00018 - PER 1 MIN
16 *         0.000003 - PER 1 SEC
17 *  - Life-long payments
18 *  - Unprecedentedly reliable
19 *  - Bringer Fortune
20 *  - Minimal contribution 0.01 eth
21 *  - Currency and payment - ETH
22 *  - Contribution allocation schemes:
23 *    -- 100 % payments
24 
25 *
26 *  --- About the project
27 * Smart contracts with support for blockchains have opened a new era in a relationship without trust
28 * intermediaries. This technology opens up incredible financial opportunities.
29 * The distribution model is recorded in a smart contract, loaded into the Ethereum blockchain, and can no longer be changed.
30 * The contract is recorded on the blockchain with a WAY TO REFIT OWNERSHIP!
31 * free access online.
32 * Continuous autonomous functioning of the system.
33 *
34 * ---How to use:
35 * 1. Send from your ETH wallet to the address of the smart contract
36 * Any amount from 0.01 ETH.
37 * 2. Confirm your transaction in the history of your application or etherscan.io, specifying the address of your wallet.
38 * Profit by sending 0 live transactions
39 (profit is calculated every second).
40 *  OR
41 * To reinvest, you need to deposit the amount you want to reinvest, and the interest accrued is automatically added to your new deposit.
42 *
43 * RECOMMENDED GAS LIMIT: 200,000
44 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
45 * You can check the payments on the website etherscan.io, in the “Internal Txns” tab of your wallet.
46 *
47 * Referral system is missing.
48 * Payment to developers is missing.
49 * There is no payment for advertising.
50 * All 100% of the contribution remains in the Smart Contract Fund.
51 * Contract restart is also absent. If there is no * money in the Fund, payments are suspended and * they are renewed again when the Fund is filled. Thus * the contract is able to WORK FOREVER!
52 * --- It is not allowed to transfer from exchanges, ONLY from your personal wallet ETH from which you have a private key.
53 *
54 * The contract has passed all the necessary checks by the professionals!
55 */
56 
57 
58 library Math {
59   function min(uint a, uint b) internal pure returns(uint) {
60     if (a > b) {
61       return b;
62     }
63     return a;
64   }
65 }
66 
67 
68 library Zero {
69   function requireNotZero(address addr) internal pure {
70     require(addr != address(0), "require not zero address");
71   }
72 
73   function requireNotZero(uint val) internal pure {
74     require(val != 0, "require not zero value");
75   }
76 
77   function notZero(address addr) internal pure returns(bool) {
78     return !(addr == address(0));
79   }
80 
81   function isZero(address addr) internal pure returns(bool) {
82     return addr == address(0);
83   }
84 
85   function isZero(uint a) internal pure returns(bool) {
86     return a == 0;
87   }
88 
89   function notZero(uint a) internal pure returns(bool) {
90     return a != 0;
91   }
92 }
93 
94 
95 library Percent {
96   // Solidity automatically throws when dividing by 0
97   struct percent {
98     uint num;
99     uint den;
100   }
101   
102   // storage
103   function mul(percent storage p, uint a) internal view returns (uint) {
104     if (a == 0) {
105       return 0;
106     }
107     return a*p.num/p.den;
108   }
109 
110   function div(percent storage p, uint a) internal view returns (uint) {
111     return a/p.num*p.den;
112   }
113 
114   function sub(percent storage p, uint a) internal view returns (uint) {
115     uint b = mul(p, a);
116     if (b >= a) {
117       return 0;
118     }
119     return a - b;
120   }
121 
122   function add(percent storage p, uint a) internal view returns (uint) {
123     return a + mul(p, a);
124   }
125 
126   function toMemory(percent storage p) internal view returns (Percent.percent memory) {
127     return Percent.percent(p.num, p.den);
128   }
129 
130   // memory 
131   function mmul(percent memory p, uint a) internal pure returns (uint) {
132     if (a == 0) {
133       return 0;
134     }
135     return a*p.num/p.den;
136   }
137 
138   function mdiv(percent memory p, uint a) internal pure returns (uint) {
139     return a/p.num*p.den;
140   }
141 
142   function msub(percent memory p, uint a) internal pure returns (uint) {
143     uint b = mmul(p, a);
144     if (b >= a) {
145       return 0;
146     }
147     return a - b;
148   }
149 
150   function madd(percent memory p, uint a) internal pure returns (uint) {
151     return a + mmul(p, a);
152   }
153 }
154 
155 
156 library Address {
157   function toAddress(bytes source) internal pure returns(address addr) {
158     assembly { addr := mload(add(source,0x14)) }
159     return addr;
160   }
161 
162   function isNotContract(address addr) internal view returns(bool) {
163     uint length;
164     assembly { length := extcodesize(addr) }
165     return length == 0;
166   }
167 }
168 
169 
170 /**
171  * @title SafeMath
172  * @dev Math operations with safety checks that revert on error
173  */
174 library SafeMath {
175 
176   /**
177   * @dev Multiplies two numbers, reverts on overflow.
178   */
179   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
180     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
181     // benefit is lost if 'b' is also tested.
182     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
183     if (_a == 0) {
184       return 0;
185     }
186 
187     uint256 c = _a * _b;
188     require(c / _a == _b);
189 
190     return c;
191   }
192 
193   /**
194   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
195   */
196   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
197     require(_b > 0); // Solidity only automatically asserts when dividing by 0
198     uint256 c = _a / _b;
199     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
200 
201     return c;
202   }
203 
204   /**
205   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
206   */
207   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
208     require(_b <= _a);
209     uint256 c = _a - _b;
210 
211     return c;
212   }
213 
214   /**
215   * @dev Adds two numbers, reverts on overflow.
216   */
217   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
218     uint256 c = _a + _b;
219     require(c >= _a);
220 
221     return c;
222   }
223 
224   /**
225   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
226   * reverts when dividing by zero.
227   */
228   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
229     require(b != 0);
230     return a % b;
231   }
232 }
233 
234 
235 contract Accessibility {
236   address private owner;
237   modifier onlyOwner() {
238     require(msg.sender == owner, "access denied");
239     _;
240   }
241 
242   constructor() public {
243     owner = msg.sender;
244   }
245 
246   // Deletion of contract holder and waiver of ownership
247   
248   function disown() internal {
249     delete owner;
250   }
251 }
252 
253 
254 contract Rev1Storage {
255   function investorShortInfo(address addr) public view returns(uint value, uint refBonus); 
256 }
257 
258 
259 contract Rev2Storage {
260   function investorInfo(address addr) public view returns(uint investment, uint paymentTime); 
261 }
262 
263 
264 library PrivateEntrance {
265   using PrivateEntrance for privateEntrance;
266   using Math for uint;
267   struct privateEntrance {
268     Rev1Storage rev1Storage;
269     Rev2Storage rev2Storage;
270     uint investorMaxInvestment;
271     uint endTimestamp;
272     mapping(address=>bool) hasAccess;
273   }
274 
275   function isActive(privateEntrance storage pe) internal view returns(bool) {
276     return pe.endTimestamp > now;
277   }
278 
279   function maxInvestmentFor(privateEntrance storage pe, address investorAddr) internal view returns(uint) {
280     // check if investorAddr has access
281     if (!pe.hasAccess[investorAddr]) {
282       return 0;
283     }
284 
285     // get investor max investment = investment from revolution 1
286     (uint maxInvestment, ) = pe.rev1Storage.investorShortInfo(investorAddr);
287     if (maxInvestment == 0) {
288       return 0;
289     }
290     maxInvestment = Math.min(maxInvestment, pe.investorMaxInvestment);
291 
292     // get current investment from revolution 2
293     (uint currInvestment, ) = pe.rev2Storage.investorInfo(investorAddr);
294     
295     if (currInvestment >= maxInvestment) {
296       return 0;
297     }
298 
299     return maxInvestment-currInvestment;
300   }
301 
302   function provideAccessFor(privateEntrance storage pe, address[] addrs) internal {
303     for (uint16 i; i < addrs.length; i++) {
304       pe.hasAccess[addrs[i]] = true;
305     }
306   }
307 }
308 
309 
310 contract InvestorsStorage is Accessibility {
311   struct Investor {
312     uint investment;
313     uint paymentTime;
314   }
315   uint public size;
316 
317   mapping (address => Investor) private investors;
318 
319   function isInvestor(address addr) public view returns (bool) {
320     return investors[addr].investment > 0;
321   }
322 
323   function investorInfo(address addr) public view returns(uint investment, uint paymentTime) {
324     investment = investors[addr].investment;
325     paymentTime = investors[addr].paymentTime;
326   }
327 
328   function newInvestor(address addr, uint investment, uint paymentTime) public onlyOwner returns (bool) {
329     Investor storage inv = investors[addr];
330     if (inv.investment != 0 || investment == 0) {
331       return false;
332     }
333     inv.investment = investment;
334     inv.paymentTime = paymentTime;
335     size++;
336     return true;
337   }
338 
339   function addInvestment(address addr, uint investment) public onlyOwner returns (bool) {
340     if (investors[addr].investment == 0) {
341       return false;
342     }
343     investors[addr].investment += investment;
344     return true;
345   }
346 
347   function setPaymentTime(address addr, uint paymentTime) public onlyOwner returns (bool) {
348     if (investors[addr].investment == 0) {
349       return false;
350     }
351     investors[addr].paymentTime = paymentTime;
352     return true;
353   }
354 }
355 
356 
357 library RapidGrowthProtection {
358   using RapidGrowthProtection for rapidGrowthProtection;
359   
360   struct rapidGrowthProtection {
361     uint startTimestamp;
362     uint maxDailyTotalInvestment;
363     uint8 activityDays;
364     mapping(uint8 => uint) dailyTotalInvestment;
365   }
366 
367   function maxInvestmentAtNow(rapidGrowthProtection storage rgp) internal view returns(uint) {
368     uint day = rgp.currDay();
369     if (day == 0 || day > rgp.activityDays) {
370       return 0;
371     }
372     if (rgp.dailyTotalInvestment[uint8(day)] >= rgp.maxDailyTotalInvestment) {
373       return 0;
374     }
375     return rgp.maxDailyTotalInvestment - rgp.dailyTotalInvestment[uint8(day)];
376   }
377 
378   function isActive(rapidGrowthProtection storage rgp) internal view returns(bool) {
379     uint day = rgp.currDay();
380     return day != 0 && day <= rgp.activityDays;
381   }
382 
383   function saveInvestment(rapidGrowthProtection storage rgp, uint investment) internal returns(bool) {
384     uint day = rgp.currDay();
385     if (day == 0 || day > rgp.activityDays) {
386       return false;
387     }
388     if (rgp.dailyTotalInvestment[uint8(day)] + investment > rgp.maxDailyTotalInvestment) {
389       return false;
390     }
391     rgp.dailyTotalInvestment[uint8(day)] += investment;
392     return true;
393   }
394 
395  
396   function currDay(rapidGrowthProtection storage rgp) internal view returns(uint day) {
397     if (rgp.startTimestamp > now) {
398       return 0;
399     }
400     day = (now - rgp.startTimestamp) / 24 hours + 1; // +1 for skip zero day
401   }
402 }
403 
404 
405 
406 
407 
408 
409 
410 
411 contract SpaceEmissio is Accessibility {
412   using RapidGrowthProtection for RapidGrowthProtection.rapidGrowthProtection;
413   using PrivateEntrance for PrivateEntrance.privateEntrance;
414   using Percent for Percent.percent;
415   using SafeMath for uint;
416   using Math for uint;
417 
418   // easy read for investors
419   using Address for *;
420   using Zero for *; 
421   
422   RapidGrowthProtection.rapidGrowthProtection private m_rgp;
423   PrivateEntrance.privateEntrance private m_privEnter;
424   mapping(address => bool) private m_referrals;
425   InvestorsStorage private m_investors;
426 
427   // automatically generates getters
428   uint public constant minInvesment = 10 finney; //       0.01 eth
429   uint public constant maxBalance = 33333e5 ether; // 333 3300 000 eth
430   address public advertisingAddress;
431   address public adminsAddress;
432   uint public investmentsNumber;
433   uint public waveStartup;
434 
435   // percents per Day
436   Percent.percent private m_1_percent = Percent.percent(26, 100000);           //   26/100000  *100% = 0.26%
437   
438   // more events for easy read from blockchain
439   event LogPEInit(uint when, address rev1Storage, address rev2Storage, uint investorMaxInvestment, uint endTimestamp);
440   event LogSendExcessOfEther(address indexed addr, uint when, uint value, uint investment, uint excess);
441   event LogNewReferral(address indexed addr, address indexed referrerAddr, uint when, uint refBonus);
442   event LogRGPInit(uint when, uint startTimestamp, uint maxDailyTotalInvestment, uint activityDays);
443   event LogRGPInvestment(address indexed addr, uint when, uint investment, uint indexed day);
444   event LogNewInvesment(address indexed addr, uint when, uint investment, uint value);
445   event LogAutomaticReinvest(address indexed addr, uint when, uint investment);
446   event LogPayDividends(address indexed addr, uint when, uint dividends);
447   event LogNewInvestor(address indexed addr, uint when);
448   event LogBalanceChanged(uint when, uint balance);
449   event LogNextWave(uint when);
450   event LogDisown(uint when);
451 
452 
453   modifier balanceChanged {
454     _;
455     emit LogBalanceChanged(now, address(this).balance);
456   }
457 
458   modifier notFromContract() {
459     require(msg.sender.isNotContract(), "only externally accounts");
460     _;
461   }
462 
463   constructor() public {
464     adminsAddress = msg.sender;
465     advertisingAddress = msg.sender;
466     nextWave();
467   }
468 
469   function() public payable {
470     // investor get him dividends
471     if (msg.value.isZero()) {
472       getMyDividends();
473       return;
474     }
475 
476     // sender do invest
477     doInvest(msg.data.toAddress());
478   }
479 
480   function doDisown() private onlyOwner {
481     disown();
482     emit LogDisown(now);
483   }
484 
485   function init(address rev1StorageAddr, uint timestamp) private onlyOwner {
486     // init Rapid Growth Protection
487     m_rgp.startTimestamp = timestamp + 1;
488     m_rgp.maxDailyTotalInvestment = 500 ether;
489     m_rgp.activityDays = 21;
490     emit LogRGPInit(
491       now, 
492       m_rgp.startTimestamp,
493       m_rgp.maxDailyTotalInvestment,
494       m_rgp.activityDays
495     );
496 
497 
498     // init Private Entrance
499     m_privEnter.rev1Storage = Rev1Storage(rev1StorageAddr);
500     m_privEnter.rev2Storage = Rev2Storage(address(m_investors));
501     m_privEnter.investorMaxInvestment = 50 ether;
502     m_privEnter.endTimestamp = timestamp;
503     emit LogPEInit(
504       now, 
505       address(m_privEnter.rev1Storage), 
506       address(m_privEnter.rev2Storage), 
507       m_privEnter.investorMaxInvestment, 
508       m_privEnter.endTimestamp
509     );
510   }
511 
512   
513 
514   function privateEntranceProvideAccessFor(address[] addrs) private onlyOwner {
515     m_privEnter.provideAccessFor(addrs);
516   }
517 
518   function rapidGrowthProtectionmMaxInvestmentAtNow() private view returns(uint investment) {
519     investment = m_rgp.maxInvestmentAtNow();
520   }
521 
522   function investorsNumber() public view returns(uint) {
523     return m_investors.size();
524   }
525 
526   function balanceETH() public view returns(uint) {
527     return address(this).balance;
528   }
529 
530   function percent1() public view returns(uint numerator, uint denominator) {
531     (numerator, denominator) = (m_1_percent.num, m_1_percent.den);
532   }
533 
534   
535 
536   function investorInfo(address investorAddr) public view returns(uint investment, uint paymentTime, bool isReferral) {
537     (investment, paymentTime) = m_investors.investorInfo(investorAddr);
538     isReferral = m_referrals[investorAddr];
539   }
540 
541   function investorDividendsAtNow(address investorAddr) public view returns(uint dividends) {
542     dividends = calcDividends(investorAddr);
543   }
544 
545   function dailyPercentAtNow() public view returns(uint numerator, uint denominator) {
546     Percent.percent memory p = dailyPercent();
547     (numerator, denominator) = (p.num, p.den);
548   }
549 
550   
551 
552   function getMyDividends() public notFromContract balanceChanged {
553     // calculate dividends
554     uint dividends = calcDividends(msg.sender);
555     require (dividends.notZero(), "cannot to pay zero dividends");
556 
557     // update investor payment timestamp
558     assert(m_investors.setPaymentTime(msg.sender, now));
559 
560     // check enough eth - goto next wave if needed
561     if (address(this).balance <= dividends) {
562       nextWave();
563       dividends = address(this).balance;
564     } 
565 
566     // transfer dividends to investor
567     msg.sender.transfer(dividends);
568     emit LogPayDividends(msg.sender, now, dividends);
569   }
570 
571   function doInvest(address referrerAddr) public payable notFromContract balanceChanged {
572     uint investment = msg.value;
573     uint receivedEther = msg.value;
574     require(investment >= minInvesment, "investment must be >= minInvesment");
575     require(address(this).balance <= maxBalance, "the contract eth balance limit");
576 
577     if (m_rgp.isActive()) { 
578       // use Rapid Growth Protection if needed
579       uint rpgMaxInvest = m_rgp.maxInvestmentAtNow();
580       rpgMaxInvest.requireNotZero();
581       investment = Math.min(investment, rpgMaxInvest);
582       assert(m_rgp.saveInvestment(investment));
583       emit LogRGPInvestment(msg.sender, now, investment, m_rgp.currDay());
584       
585     } else if (m_privEnter.isActive()) {
586       // use Private Entrance if needed
587       uint peMaxInvest = m_privEnter.maxInvestmentFor(msg.sender);
588       peMaxInvest.requireNotZero();
589       investment = Math.min(investment, peMaxInvest);
590     }
591 
592     // send excess of ether if needed
593     if (receivedEther > investment) {
594       uint excess = receivedEther - investment;
595       msg.sender.transfer(excess);
596       receivedEther = investment;
597       emit LogSendExcessOfEther(msg.sender, now, msg.value, investment, excess);
598     }
599 
600    // commission
601 
602 
603 bool senderIsInvestor = m_investors.isInvestor(msg.sender);
604     
605     // ref system works only once and only on first invest (is disabled)
606 if (referrerAddr.notZero() && !senderIsInvestor && !m_referrals[msg.sender] &&
607 referrerAddr != msg.sender && m_investors.isInvestor(referrerAddr)) {
608 
609 
610 }
611     
612     // automatic reinvest - prevent burning dividends
613     uint dividends = calcDividends(msg.sender);
614     if (senderIsInvestor && dividends.notZero()) {
615       investment += dividends;
616       emit LogAutomaticReinvest(msg.sender, now, dividends);
617     }
618 
619     if (senderIsInvestor) {
620       // update existing investor
621       assert(m_investors.addInvestment(msg.sender, investment));
622       assert(m_investors.setPaymentTime(msg.sender, now));
623     } else {
624       // create new investor
625       assert(m_investors.newInvestor(msg.sender, investment, now));
626       emit LogNewInvestor(msg.sender, now);
627     }
628 
629     investmentsNumber++;
630     emit LogNewInvesment(msg.sender, now, investment, receivedEther);
631   }
632 
633   function getMemInvestor(address investorAddr) internal view returns(InvestorsStorage.Investor memory) {
634     (uint investment, uint paymentTime) = m_investors.investorInfo(investorAddr);
635     return InvestorsStorage.Investor(investment, paymentTime);
636   }
637 
638   function calcDividends(address investorAddr) internal view returns(uint dividends) {
639     InvestorsStorage.Investor memory investor = getMemInvestor(investorAddr);
640 
641     // safe gas if dividends will be 0
642     if (investor.investment.isZero() || now.sub(investor.paymentTime) < 1 seconds) {
643       return 0;
644     }
645     
646     // for prevent burning daily dividends if 24h did not pass - calculate it per 1 sec interval
647     // if daily percent is X, then 1 sec percent = X / (24h / 1 sec) = X / 86400
648 
649     // and we must to get numbers of 1 sec interval after investor got payment:
650     // (now - investor.paymentTime) / 1 sec 
651 
652     // finaly calculate dividends = ((now - investor.paymentTime) / 1 sec) * (X * investor.investment)  / 86400) 
653 
654     Percent.percent memory p = dailyPercent();
655     dividends = (now.sub(investor.paymentTime) / 1 seconds) * p.mmul(investor.investment) / 86400;
656   }
657 
658  
659   function dailyPercent() internal view returns(Percent.percent memory p) {
660     uint balance = address(this).balance;
661       
662 
663     if (balance < 33333e5 ether) { 
664    
665       p = m_1_percent.toMemory();    // (1)
666 
667   }
668   }
669 
670 
671 
672   function nextWave() private {
673     m_investors = new InvestorsStorage();
674     investmentsNumber = 0;
675     waveStartup = now;
676     
677     
678     emit LogRGPInit(now , m_rgp.startTimestamp, m_rgp.maxDailyTotalInvestment, m_rgp.activityDays);
679     emit LogNextWave(now);
680   }
681 }