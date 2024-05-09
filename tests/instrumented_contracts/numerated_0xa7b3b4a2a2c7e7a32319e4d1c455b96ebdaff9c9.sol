1 pragma solidity 0.4.25;
2 
3 
4 /**
5 *
6 * ETH CRYPTOCURRENCY DISTRIBUTION PROJECT v 3.0
7 * Web              - https://ether3.io
8 * Twitter          - https://twitter.com/ether3_io
9 * Telegram_channel - https://t.me/ether3
10 * EN  Telegram_chat: https://t.me/ether3_chat_en
11 * Email:             mailto:support(at sign)ether3.io
12 *
13 *
14 *  - GAIN 3% - 1% PER 24 HOURS (interest is charges in equal parts every 10 min)
15 *  - Life-long payments
16 *  - The revolutionary reliability
17 *  - Minimal contribution 0.01 eth
18 *  - Currency and payment - ETH
19 *  - Contribution allocation schemes:
20 *    -- 88% payments
21 *    --  7% marketing
22 *    --  5,0% technical support
23 *
24 *   ---About the Project
25 *  Blockchain-enabled smart contracts have opened a new era of trustless relationships without
26 *  intermediaries. This technology opens incredible financial possibilities. Our automated investment
27 *  distribution model is written into a smart contract, uploaded to the Ethereum blockchain and can be
28 *  freely accessed online. In order to insure our investors' complete security, full control over the
29 *  project has been transferred from the organizers to the smart contract: nobody can influence the
30 *  system's permanent autonomous functioning.
31 *
32 * ---How to use:
33 *  1. Send from ETH wallet to the smart contract address 0xA7B3b4a2a2C7E7a32319E4D1c455B96ebDaFf9c9
34 *     any amount from 0.01 ETH.
35 *  2. Verify your transaction in the history of your application or etherscan.io, specifying the address
36 *     of your wallet.
37 *  3a. Claim your profit by sending 0 ether transaction (every 10 min, every day, every week, i don't care unless you're
38 *      spending too much on GAS)
39 *  OR
40 *  3b. For reinvest, you need to deposit the amount that you want to reinvest and the
41 *      accrued interest automatically summed to your new contribution.
42 *
43 * RECOMMENDED GAS LIMIT: 200000
44 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
45 * You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.
46 *
47 * ---Refferral system:
48 *     from 0 to 10.000 ethers in the fund - remuneration to each contributor is 3%,
49 *     from 10.000 to 100.000 ethers in the fund - remuneration will be 2%,
50 *     from 100.000 ethers in the fund - each contributor will get 1%.
51 *
52 * ---It is not allowed to transfer from exchanges, only from your personal ETH wallet, for which you
53 * have private keys.
54 *
55 * Contracts reviewed and approved by pros!
56 *
57 * Main contract - Ether3. Scroll down to find it.
58 */
59 
60 
61 library Math {
62     function min(uint a, uint b) internal pure returns(uint) {
63         if (a > b) {
64             return b;
65         }
66         return a;
67     }
68 }
69 
70 
71 library Zero {
72     function requireNotZero(address addr) internal pure {
73         require(addr != address(0), "require not zero address");
74     }
75 
76     function requireNotZero(uint val) internal pure {
77         require(val != 0, "require not zero value");
78     }
79 
80     function notZero(address addr) internal pure returns(bool) {
81         return !(addr == address(0));
82     }
83 
84     function isZero(address addr) internal pure returns(bool) {
85         return addr == address(0);
86     }
87 
88     function isZero(uint a) internal pure returns(bool) {
89         return a == 0;
90     }
91 
92     function notZero(uint a) internal pure returns(bool) {
93         return a != 0;
94     }
95 }
96 
97 
98 library Percent {
99     // Solidity automatically throws when dividing by 0
100     struct percent {
101         uint num;
102         uint den;
103     }
104 
105     // storage
106     function mul(percent storage p, uint a) internal view returns (uint) {
107         if (a == 0) {
108             return 0;
109         }
110         return a*p.num/p.den;
111     }
112 
113     function div(percent storage p, uint a) internal view returns (uint) {
114         return a/p.num*p.den;
115     }
116 
117     function sub(percent storage p, uint a) internal view returns (uint) {
118         uint b = mul(p, a);
119         if (b >= a) {
120             return 0;
121         }
122         return a - b;
123     }
124 
125     function add(percent storage p, uint a) internal view returns (uint) {
126         return a + mul(p, a);
127     }
128 
129     function toMemory(percent storage p) internal view returns (Percent.percent memory) {
130         return Percent.percent(p.num, p.den);
131     }
132 
133     // memory
134     function mmul(percent memory p, uint a) internal pure returns (uint) {
135         if (a == 0) {
136             return 0;
137         }
138         return a*p.num/p.den;
139     }
140 
141     function mdiv(percent memory p, uint a) internal pure returns (uint) {
142         return a/p.num*p.den;
143     }
144 
145     function msub(percent memory p, uint a) internal pure returns (uint) {
146         uint b = mmul(p, a);
147         if (b >= a) {
148             return 0;
149         }
150         return a - b;
151     }
152 
153     function madd(percent memory p, uint a) internal pure returns (uint) {
154         return a + mmul(p, a);
155     }
156 }
157 
158 
159 library Address {
160     function toAddress(bytes source) internal pure returns(address addr) {
161         assembly { addr := mload(add(source,0x14)) }
162         return addr;
163     }
164 
165     function isNotContract(address addr) internal view returns(bool) {
166         uint length;
167         assembly { length := extcodesize(addr) }
168         return length == 0;
169     }
170 }
171 
172 
173 /**
174  * @title SafeMath
175  * @dev Math operations with safety checks that revert on error
176  */
177 library SafeMath {
178 
179     /**
180     * @dev Multiplies two numbers, reverts on overflow.
181     */
182     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
183         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
184         // benefit is lost if 'b' is also tested.
185         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
186         if (_a == 0) {
187             return 0;
188         }
189 
190         uint256 c = _a * _b;
191         require(c / _a == _b);
192 
193         return c;
194     }
195 
196     /**
197     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
198     */
199     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
200         require(_b > 0); // Solidity only automatically asserts when dividing by 0
201         uint256 c = _a / _b;
202         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
203 
204         return c;
205     }
206 
207     /**
208     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
209     */
210     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
211         require(_b <= _a);
212         uint256 c = _a - _b;
213 
214         return c;
215     }
216 
217     /**
218     * @dev Adds two numbers, reverts on overflow.
219     */
220     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
221         uint256 c = _a + _b;
222         require(c >= _a);
223 
224         return c;
225     }
226 
227     /**
228     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
229     * reverts when dividing by zero.
230     */
231     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
232         require(b != 0);
233         return a % b;
234     }
235 }
236 
237 
238 contract Accessibility {
239     address private owner;
240     modifier onlyOwner() {
241         require(msg.sender == owner, "access denied");
242         _;
243     }
244 
245     constructor() public {
246         owner = msg.sender;
247     }
248 
249     function disown() internal {
250         delete owner;
251     }
252 }
253 
254 
255 contract Rev1Storage {
256     function investorShortInfo(address addr) public view returns(uint value, uint refBonus);
257 }
258 
259 
260 contract Rev2Storage {
261     function investorInfo(address addr) public view returns(uint investment, uint paymentTime);
262 }
263 
264 
265 library PrivateEntrance {
266     using PrivateEntrance for privateEntrance;
267     using Math for uint;
268     struct privateEntrance {
269         Rev1Storage rev1Storage;
270         Rev2Storage rev2Storage;
271         uint investorMaxInvestment;
272         uint endTimestamp;
273         mapping(address=>bool) hasAccess;
274     }
275 
276     function isActive(privateEntrance storage pe) internal view returns(bool) {
277         return pe.endTimestamp > now;
278     }
279 
280     function maxInvestmentFor(privateEntrance storage pe, address investorAddr) internal view returns(uint) {
281         // check if investorAddr has access
282         if (!pe.hasAccess[investorAddr]) {
283             return 0;
284         }
285 
286         // get investor max investment = investment from revolution 1
287         (uint maxInvestment, ) = pe.rev1Storage.investorShortInfo(investorAddr);
288         if (maxInvestment == 0) {
289             return 0;
290         }
291         maxInvestment = Math.min(maxInvestment, pe.investorMaxInvestment);
292 
293         // get current investment from revolution 2
294         (uint currInvestment, ) = pe.rev2Storage.investorInfo(investorAddr);
295 
296         if (currInvestment >= maxInvestment) {
297             return 0;
298         }
299 
300         return maxInvestment-currInvestment;
301     }
302 
303     function provideAccessFor(privateEntrance storage pe, address[] addrs) internal {
304         for (uint16 i; i < addrs.length; i++) {
305             pe.hasAccess[addrs[i]] = true;
306         }
307     }
308 }
309 
310 
311 contract InvestorsStorage is Accessibility {
312     struct Investor {
313         uint investment;
314         uint paymentTime;
315     }
316     uint public size;
317 
318     mapping (address => Investor) private investors;
319 
320     function isInvestor(address addr) public view returns (bool) {
321         return investors[addr].investment > 0;
322     }
323 
324     function investorInfo(address addr) public view returns(uint investment, uint paymentTime) {
325         investment = investors[addr].investment;
326         paymentTime = investors[addr].paymentTime;
327     }
328 
329     function newInvestor(address addr, uint investment, uint paymentTime) public onlyOwner returns (bool) {
330         Investor storage inv = investors[addr];
331         if (inv.investment != 0 || investment == 0) {
332             return false;
333         }
334         inv.investment = investment;
335         inv.paymentTime = paymentTime;
336         size++;
337         return true;
338     }
339 
340     function addInvestment(address addr, uint investment) public onlyOwner returns (bool) {
341         if (investors[addr].investment == 0) {
342             return false;
343         }
344         investors[addr].investment += investment;
345         return true;
346     }
347 
348     function setPaymentTime(address addr, uint paymentTime) public onlyOwner returns (bool) {
349         if (investors[addr].investment == 0) {
350             return false;
351         }
352         investors[addr].paymentTime = paymentTime;
353         return true;
354     }
355 }
356 
357 
358 library RapidGrowthProtection {
359     using RapidGrowthProtection for rapidGrowthProtection;
360 
361     struct rapidGrowthProtection {
362         uint startTimestamp;
363         uint maxDailyTotalInvestment;
364         uint8 activityDays;
365         mapping(uint8 => uint) dailyTotalInvestment;
366     }
367 
368     function maxInvestmentAtNow(rapidGrowthProtection storage rgp) internal view returns(uint) {
369         uint day = rgp.currDay();
370         if (day == 0 || day > rgp.activityDays) {
371             return 0;
372         }
373         if (rgp.dailyTotalInvestment[uint8(day)] >= rgp.maxDailyTotalInvestment) {
374             return 0;
375         }
376         return rgp.maxDailyTotalInvestment - rgp.dailyTotalInvestment[uint8(day)];
377     }
378 
379     function isActive(rapidGrowthProtection storage rgp) internal view returns(bool) {
380         uint day = rgp.currDay();
381         return day != 0 && day <= rgp.activityDays;
382     }
383 
384     function saveInvestment(rapidGrowthProtection storage rgp, uint investment) internal returns(bool) {
385         uint day = rgp.currDay();
386         if (day == 0 || day > rgp.activityDays) {
387             return false;
388         }
389         if (rgp.dailyTotalInvestment[uint8(day)] + investment > rgp.maxDailyTotalInvestment) {
390             return false;
391         }
392         rgp.dailyTotalInvestment[uint8(day)] += investment;
393         return true;
394     }
395 
396     function startAt(rapidGrowthProtection storage rgp, uint timestamp) internal {
397         rgp.startTimestamp = timestamp;
398 
399         // restart
400         for (uint8 i = 1; i <= rgp.activityDays; i++) {
401             if (rgp.dailyTotalInvestment[i] != 0) {
402                 delete rgp.dailyTotalInvestment[i];
403             }
404         }
405     }
406 
407     function currDay(rapidGrowthProtection storage rgp) internal view returns(uint day) {
408         if (rgp.startTimestamp > now) {
409             return 0;
410         }
411         day = (now - rgp.startTimestamp) / 24 hours + 1; // +1 for skip zero day
412     }
413 }
414 
415 
416 
417 
418 
419 
420 
421 
422 contract Ether3 is Accessibility {
423     using RapidGrowthProtection for RapidGrowthProtection.rapidGrowthProtection;
424     using PrivateEntrance for PrivateEntrance.privateEntrance;
425     using Percent for Percent.percent;
426     using SafeMath for uint;
427     using Math for uint;
428 
429     // easy read for investors
430     using Address for *;
431     using Zero for *;
432 
433     RapidGrowthProtection.rapidGrowthProtection private m_rgp;
434     PrivateEntrance.privateEntrance private m_privEnter;
435     mapping(address => bool) private m_referrals;
436     InvestorsStorage private m_investors;
437 
438     // automatically generates getters
439     uint public constant minInvesment = 10 finney; //       0.01 eth
440     uint public constant maxBalance = 300e5 ether; // 30 000 000 eth
441     address public advertisingAddress;
442     address public adminsAddress;
443     uint public investmentsNumber;
444     uint public waveStartup;
445 
446     // percents
447     Percent.percent private m_1_percent = Percent.percent(1, 100);           //   1/100  *100% = 1%
448     Percent.percent private m_2_percent = Percent.percent(2, 100);           //   2/100  *100% = 2%
449     Percent.percent private m_3_percent = Percent.percent(3, 100);    			 //   3/100  *100% = 3%
450     Percent.percent private m_adminsPercent = Percent.percent(5, 100);       //   5/100  *100% = 5%
451     Percent.percent private m_advertisingPercent = Percent.percent(7, 100);  //   7/100  *100% = 7%
452 
453     // more events for easy read from blockchain
454     event LogPEInit(uint when, address rev1Storage, address rev2Storage, uint investorMaxInvestment, uint endTimestamp);
455     event LogSendExcessOfEther(address indexed addr, uint when, uint value, uint investment, uint excess);
456     event LogNewReferral(address indexed addr, address indexed referrerAddr, uint when, uint refBonus);
457     event LogRGPInit(uint when, uint startTimestamp, uint maxDailyTotalInvestment, uint activityDays);
458     event LogRGPInvestment(address indexed addr, uint when, uint investment, uint indexed day);
459     event LogNewInvesment(address indexed addr, uint when, uint investment, uint value);
460     event LogAutomaticReinvest(address indexed addr, uint when, uint investment);
461     event LogPayDividends(address indexed addr, uint when, uint dividends);
462     event LogNewInvestor(address indexed addr, uint when);
463     event LogBalanceChanged(uint when, uint balance);
464     event LogNextWave(uint when);
465     event LogDisown(uint when);
466 
467 
468     modifier balanceChanged {
469         _;
470         emit LogBalanceChanged(now, address(this).balance);
471     }
472 
473     modifier notFromContract() {
474         require(msg.sender.isNotContract(), "only externally accounts");
475         _;
476     }
477 
478     constructor() public {
479         adminsAddress = msg.sender;
480         advertisingAddress = msg.sender;
481         nextWave();
482     }
483 
484     function() public payable {
485         // investor get him dividends
486         if (msg.value.isZero()) {
487             getMyDividends();
488             return;
489         }
490 
491         // sender do invest
492         doInvest(msg.data.toAddress());
493     }
494 
495     function doDisown() public onlyOwner {
496         disown();
497         emit LogDisown(now);
498     }
499 
500     function init(address rev1StorageAddr, uint timestamp) public onlyOwner {
501         // init Rapid Growth Protection
502         m_rgp.startTimestamp = timestamp + 1;
503         m_rgp.maxDailyTotalInvestment = 500 ether;
504         m_rgp.activityDays = 21;
505         emit LogRGPInit(
506             now,
507             m_rgp.startTimestamp,
508             m_rgp.maxDailyTotalInvestment,
509             m_rgp.activityDays
510         );
511 
512 
513         // init Private Entrance
514         m_privEnter.rev1Storage = Rev1Storage(rev1StorageAddr);
515         m_privEnter.rev2Storage = Rev2Storage(address(m_investors));
516         m_privEnter.investorMaxInvestment = 50 ether;
517         m_privEnter.endTimestamp = timestamp;
518         emit LogPEInit(
519             now,
520             address(m_privEnter.rev1Storage),
521             address(m_privEnter.rev2Storage),
522             m_privEnter.investorMaxInvestment,
523             m_privEnter.endTimestamp
524         );
525     }
526 
527     function setAdvertisingAddress(address addr) public onlyOwner {
528         addr.requireNotZero();
529         advertisingAddress = addr;
530     }
531 
532     function setAdminsAddress(address addr) public onlyOwner {
533         addr.requireNotZero();
534         adminsAddress = addr;
535     }
536 
537     function privateEntranceProvideAccessFor(address[] addrs) public onlyOwner {
538         m_privEnter.provideAccessFor(addrs);
539     }
540 
541     function rapidGrowthProtectionmMaxInvestmentAtNow() public view returns(uint investment) {
542         investment = m_rgp.maxInvestmentAtNow();
543     }
544 
545     function investorsNumber() public view returns(uint) {
546         return m_investors.size();
547     }
548 
549     function balanceETH() public view returns(uint) {
550         return address(this).balance;
551     }
552 
553     function percent1() public view returns(uint numerator, uint denominator) {
554         (numerator, denominator) = (m_1_percent.num, m_1_percent.den);
555     }
556 
557     function percent2() public view returns(uint numerator, uint denominator) {
558         (numerator, denominator) = (m_2_percent.num, m_2_percent.den);
559     }
560 
561     function percent3() public view returns(uint numerator, uint denominator) {
562         (numerator, denominator) = (m_3_percent.num, m_3_percent.den);
563     }
564 
565     function advertisingPercent() public view returns(uint numerator, uint denominator) {
566         (numerator, denominator) = (m_advertisingPercent.num, m_advertisingPercent.den);
567     }
568 
569     function adminsPercent() public view returns(uint numerator, uint denominator) {
570         (numerator, denominator) = (m_adminsPercent.num, m_adminsPercent.den);
571     }
572 
573     function investorInfo(address investorAddr) public view returns(uint investment, uint paymentTime, bool isReferral) {
574         (investment, paymentTime) = m_investors.investorInfo(investorAddr);
575         isReferral = m_referrals[investorAddr];
576     }
577 
578     function investorDividendsAtNow(address investorAddr) public view returns(uint dividends) {
579         dividends = calcDividends(investorAddr);
580     }
581 
582     function dailyPercentAtNow() public view returns(uint numerator, uint denominator) {
583         Percent.percent memory p = dailyPercent();
584         (numerator, denominator) = (p.num, p.den);
585     }
586 
587     function refBonusPercentAtNow() public view returns(uint numerator, uint denominator) {
588         Percent.percent memory p = refBonusPercent();
589         (numerator, denominator) = (p.num, p.den);
590     }
591 
592     function getMyDividends() public notFromContract balanceChanged {
593         // calculate dividends
594         uint dividends = calcDividends(msg.sender);
595         require (dividends.notZero(), "cannot to pay zero dividends");
596 
597         // update investor payment timestamp
598         assert(m_investors.setPaymentTime(msg.sender, now));
599 
600         // check enough eth - goto next wave if needed
601         if (address(this).balance <= dividends) {
602             nextWave();
603             dividends = address(this).balance;
604         }
605 
606         // transfer dividends to investor
607         msg.sender.transfer(dividends);
608         emit LogPayDividends(msg.sender, now, dividends);
609     }
610 
611     function doInvest(address referrerAddr) public payable notFromContract balanceChanged {
612         uint investment = msg.value;
613         uint receivedEther = msg.value;
614         require(investment >= minInvesment, "investment must be >= minInvesment");
615         require(address(this).balance <= maxBalance, "the contract eth balance limit");
616 
617         if (m_rgp.isActive()) {
618             // use Rapid Growth Protection if needed
619             uint rpgMaxInvest = m_rgp.maxInvestmentAtNow();
620             rpgMaxInvest.requireNotZero();
621             investment = Math.min(investment, rpgMaxInvest);
622             assert(m_rgp.saveInvestment(investment));
623             emit LogRGPInvestment(msg.sender, now, investment, m_rgp.currDay());
624 
625         } else if (m_privEnter.isActive()) {
626             // use Private Entrance if needed
627             uint peMaxInvest = m_privEnter.maxInvestmentFor(msg.sender);
628             peMaxInvest.requireNotZero();
629             investment = Math.min(investment, peMaxInvest);
630         }
631 
632         // send excess of ether if needed
633         if (receivedEther > investment) {
634             uint excess = receivedEther - investment;
635             msg.sender.transfer(excess);
636             receivedEther = investment;
637             emit LogSendExcessOfEther(msg.sender, now, msg.value, investment, excess);
638         }
639 
640         // commission
641         advertisingAddress.send(m_advertisingPercent.mul(receivedEther));
642         adminsAddress.send(m_adminsPercent.mul(receivedEther));
643 
644         bool senderIsInvestor = m_investors.isInvestor(msg.sender);
645 
646         // ref system works only once and only on first invest
647         if (referrerAddr.notZero() && !senderIsInvestor && !m_referrals[msg.sender] &&
648         referrerAddr != msg.sender && m_investors.isInvestor(referrerAddr)) {
649 
650             m_referrals[msg.sender] = true;
651             // add referral bonus to investor`s and referral`s investments
652             uint refBonus = refBonusPercent().mmul(investment);
653             assert(m_investors.addInvestment(referrerAddr, refBonus)); // add referrer bonus
654             investment += refBonus;                                    // add referral bonus
655             emit LogNewReferral(msg.sender, referrerAddr, now, refBonus);
656         }
657 
658         // automatic reinvest - prevent burning dividends
659         uint dividends = calcDividends(msg.sender);
660         if (senderIsInvestor && dividends.notZero()) {
661             investment += dividends;
662             emit LogAutomaticReinvest(msg.sender, now, dividends);
663         }
664 
665         if (senderIsInvestor) {
666             // update existing investor
667             assert(m_investors.addInvestment(msg.sender, investment));
668             assert(m_investors.setPaymentTime(msg.sender, now));
669         } else {
670             // create new investor
671             assert(m_investors.newInvestor(msg.sender, investment, now));
672             emit LogNewInvestor(msg.sender, now);
673         }
674 
675         investmentsNumber++;
676         emit LogNewInvesment(msg.sender, now, investment, receivedEther);
677     }
678 
679     function getMemInvestor(address investorAddr) internal view returns(InvestorsStorage.Investor memory) {
680         (uint investment, uint paymentTime) = m_investors.investorInfo(investorAddr);
681         return InvestorsStorage.Investor(investment, paymentTime);
682     }
683 
684     function calcDividends(address investorAddr) internal view returns(uint dividends) {
685         InvestorsStorage.Investor memory investor = getMemInvestor(investorAddr);
686 
687         // safe gas if dividends will be 0
688         if (investor.investment.isZero() || now.sub(investor.paymentTime) < 10 minutes) {
689             return 0;
690         }
691 
692         // for prevent burning daily dividends if 24h did not pass - calculate it per 10 min interval
693         // if daily percent is X, then 10min percent = X / (24h / 10 min) = X / 144
694 
695         // and we must to get numbers of 10 min interval after investor got payment:
696         // (now - investor.paymentTime) / 10min
697 
698         // finaly calculate dividends = ((now - investor.paymentTime) / 10min) * (X * investor.investment)  / 144)
699 
700         Percent.percent memory p = dailyPercent();
701         dividends = (now.sub(investor.paymentTime) / 10 minutes) * p.mmul(investor.investment) / 144;
702     }
703 
704     function dailyPercent() internal view returns(Percent.percent memory p) {
705         uint balance = address(this).balance;
706 
707         // (3) 3% if balance < 1 000 ETH
708         // (2) 2% if 1 000 ETH <= balance <= 30 000 ETH
709         // (1) 1% if 30 000 ETH < balance
710 
711         if (balance < 1000 ether) {
712             p = m_3_percent.toMemory(); // (3)
713         } else if ( 1000 ether <= balance && balance <= 30000 ether) {
714             p = m_2_percent.toMemory();    // (2)
715         } else {
716             p = m_1_percent.toMemory();    // (1)
717         }
718     }
719 
720     function refBonusPercent() internal view returns(Percent.percent memory p) {
721         uint balance = address(this).balance;
722 
723         // (1) 1% if 100 000 ETH < balance
724         // (2) 2% if 10 000 ETH <= balance <= 100 000 ETH
725         // (3) 3% if balance < 10 000 ETH
726 
727         if (balance < 10000 ether) {
728             p = m_3_percent.toMemory(); // (3)
729         } else if ( 10000 ether <= balance && balance <= 100000 ether) {
730             p = m_2_percent.toMemory();    // (2)
731         } else {
732             p = m_1_percent.toMemory();    // (1)
733         }
734     }
735 
736     function nextWave() private {
737         m_investors = new InvestorsStorage();
738         investmentsNumber = 0;
739         waveStartup = now;
740         m_rgp.startAt(now);
741         emit LogRGPInit(now , m_rgp.startTimestamp, m_rgp.maxDailyTotalInvestment, m_rgp.activityDays);
742         emit LogNextWave(now);
743     }
744 }