1 pragma solidity 0.4.25;
2 
3 
4 /**
5 *
6 * ETH INVESTMENT SMART PLATFORM - ETHUP
7 * Web              - https://ethup.io
8 * GitHub           - https://github.com/ethup/ethup
9 * Twitter          - https://twitter.com/ethup1
10 * Youtube          - https://www.youtube.com/channel/UC4JMZcpySACj4lGbXLJm9KQ
11 * Telegram_channel - https://t.me/Ethereum333
12 * EN  Telegram_chat: https://t.me/Ethup_en
13 * RU  Telegram_chat: https://t.me/Ethup_ru
14 * KOR Telegram_chat: https://t.me/Ethup_kor
15 * CN  Telegram_chat: https://t.me/Ethup_cn
16 * Email:             mailto:info(at sign)ethup.io
17 * 
18 * 
19 *  - GAIN 1% - 4% PER 24 HOURS
20 *  - Life-long payments
21 *  - The revolutionary reliability
22 *  - Minimal contribution 0.01 eth
23 *  - Currency and payment - ETH
24 *  - Contribution allocation schemes:
25 *    -- 85,0% payments
26 *    --   10% marketing
27 *    --    5% technical support
28 *
29 *   ---About the Project
30 *  Blockchain-enabled smart contracts have opened a new era of trustless relationships without 
31 *  intermediaries. This technology opens incredible financial possibilities. Our automated investment 
32 *  smart platform is written into a smart contract, uploaded to the Ethereum blockchain and can be 
33 *  freely accessed online. In order to insure our investors' complete security, full control over the 
34 *  project has been transferred from the organizers to the smart contract: nobody can influence the 
35 *  system's permanent autonomous functioning.
36 * 
37 * ---How to use:
38 *  1. Select a level and send from ETH wallet to the smart contract address 0xeccf2a50fca80391b0380188255866f0fc7fe852
39 *     any amount from 0.01 to 50 ETH.
40 *
41 *       Level 1: from 0.01 to 0.1 ETH - 1%
42 *       Level 2: from 0.1 to 1 ETH - 1.5%
43 *       Level 3: from 1 to 5 ETH - 2.0%
44 *       Level 4: from 5 to 10 ETH - 2.5%
45 *       Level 5: from 10 to 20 ETH - 3%.
46 *       Level 6: from 20 to 30 ETH - 3.5%
47 *       Level 7: from 30 to 50 ETH - 4%
48 *
49 *  2. Verify your transaction in the history of your application (wallet) or etherscan.io, specifying the address 
50 *     of your wallet.
51 *  3a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're 
52 *      spending too much on GAS) to the smart contract address 0xeccf2a50fca80391b0380188255866f0fc7fe852.
53 *  OR
54 *  3b. For add investment, you need to deposit the amount that you want to add and the 
55 *      accrued interest automatically summed to your new contribution.
56 *  
57 * RECOMMENDED GAS LIMIT: 200000
58 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
59 * You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.
60 *
61 * Every 24 hours from the moment of the deposit or from the last successful write-off of the accrued interest, 
62 * the smart contract will transfer your dividends to your account that corresponds to the number of your wallet. 
63 * Dividends are accrued until 150% of the investment is paid.
64 * After receiving 150% of all invested funds (or 50% of profits), your wallet will disconnected from payments. 
65 * You can make reinvestment by receiving an additional + 10% for the deposit amount and continue the participation. 
66 * The bonus will received only by the participant who has already received 150% of the profits and invests again.
67 *
68 * The amount of daily charges depends on the sum of all the participant's contributions to the smart contract.
69 *
70 * In case you make a contribution without first removing the accrued interest,
71 * it is added to your new contribution and credited to your account in smart contract
72 *
73 * ---Additional tools embedded in the smart contract:
74 *     - Referral program 5%. The same bonus gets referral and referrer.
75 *     - Reinvestment. After full payment of your first investment, you can receive a 10% bonus for reinvesting funds. 
76 *       You can reinvest any amount.
77 *     - BOOST mode. Get the percentage of your funds remaining in the system. 
78 *
79 * ---It is not allowed to transfer from exchanges, only from your personal ETH wallet, for which you 
80 * have private keys.
81 * 
82 * Contracts reviewed and approved by pros!
83 * 
84 * Main contract - EthUp. Scroll down to find it.
85 */ 
86 
87 
88 library Zero {
89     function requireNotZero(address addr) internal pure {
90         require(addr != address(0), "require not zero address");
91     }
92 
93     function requireNotZero(uint val) internal pure {
94         require(val != 0, "require not zero value");
95     }
96 
97     function notZero(address addr) internal pure returns(bool) {
98         return !(addr == address(0));
99     }
100 
101     function isZero(address addr) internal pure returns(bool) {
102         return addr == address(0);
103     }
104 
105     function isZero(uint a) internal pure returns(bool) {
106         return a == 0;
107     }
108 
109     function notZero(uint a) internal pure returns(bool) {
110         return a != 0;
111     }
112 }
113 
114 /**
115  * @title SafeMath
116  * @dev Math operations with safety checks that revert on error
117  */
118 library SafeMath {
119 
120     /**
121     * @dev Multiplies two numbers, reverts on overflow.
122     */
123     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
124         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
125         // benefit is lost if 'b' is also tested.
126         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
127         if (_a == 0) {
128             return 0;
129         }
130 
131         uint256 c = _a * _b;
132         require(c / _a == _b);
133 
134         return c;
135     }
136 
137     /**
138     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
139     */
140     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
141         require(_b > 0); // Solidity only automatically asserts when dividing by 0
142         uint256 c = _a / _b;
143         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
144 
145         return c;
146     }
147 
148     /**
149     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
150     */
151     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
152         require(_b <= _a);
153         uint256 c = _a - _b;
154 
155         return c;
156     }
157 
158     /**
159     * @dev Adds two numbers, reverts on overflow.
160     */
161     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
162         uint256 c = _a + _b;
163         require(c >= _a);
164 
165         return c;
166     }
167 
168     /**
169     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
170     * reverts when dividing by zero.
171     */
172     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
173         require(b != 0);
174         return a % b;
175     }
176 }
177 
178 library Percent {
179     using SafeMath for uint;
180 
181     // Solidity automatically throws when dividing by 0
182     struct percent {
183         uint num;
184         uint den;
185     }
186 
187     function mul(percent storage p, uint a) internal view returns (uint) {
188         if (a == 0) {
189             return 0;
190         }
191         return a.mul(p.num).div(p.den);
192     }
193 
194     function div(percent storage p, uint a) internal view returns (uint) {
195         return a.div(p.num).mul(p.den);
196     }
197 
198     function sub(percent storage p, uint a) internal view returns (uint) {
199         uint b = mul(p, a);
200         if (b >= a) {
201             return 0; // solium-disable-line lbrace
202         }
203         return a.sub(b);
204     }
205 
206     function add(percent storage p, uint a) internal view returns (uint) {
207         return a.add(mul(p, a));
208     }
209 
210     function toMemory(percent storage p) internal view returns (Percent.percent memory) {
211         return Percent.percent(p.num, p.den);
212     }
213 
214     // memory
215     function mmul(percent memory p, uint a) internal pure returns (uint) {
216         if (a == 0) {
217             return 0;
218         }
219         return a.mul(p.num).div(p.den);
220     }
221 
222     function mdiv(percent memory p, uint a) internal pure returns (uint) {
223         return a.div(p.num).mul(p.den);
224     }
225 
226     function msub(percent memory p, uint a) internal pure returns (uint) {
227         uint b = mmul(p, a);
228         if (b >= a) {
229             return 0;
230         }
231         return a.sub(b);
232     }
233 
234     function madd(percent memory p, uint a) internal pure returns (uint) {
235         return a.add(mmul(p, a));
236     }
237 }
238 
239 library ToAddress {
240 
241     function toAddress(bytes source) internal pure returns(address addr) {
242         assembly { addr := mload(add(source, 0x14)) }
243         return addr;
244     }
245 
246     function isNotContract(address addr) internal view returns(bool) {
247         uint length;
248         assembly { length := extcodesize(addr) }
249         return length == 0;
250     }
251 }
252 
253 contract Accessibility {
254 
255     address private owner;
256 
257     modifier onlyOwner() {
258         require(msg.sender == owner, "access denied");
259         _;
260     }
261 
262     constructor() public {
263         owner = msg.sender;
264     }
265 
266     function disown() internal {
267         delete owner;
268     }
269 }
270 
271 contract InvestorsStorage is Accessibility {
272     using SafeMath for uint;
273 
274     struct Dividends {
275         uint value;     //paid
276         uint limit;
277         uint deferred;  //not paid yet
278     }
279 
280     struct Investor {
281         uint investment;
282         uint paymentTime;
283         Dividends dividends;
284     }
285 
286     uint public size;
287 
288     mapping (address => Investor) private investors;
289 
290     function isInvestor(address addr) public view returns (bool) {
291         return investors[addr].investment > 0;
292     }
293 
294     function investorInfo(
295         address addr
296     )
297         public
298         view
299         returns (
300             uint investment,
301             uint paymentTime,
302             uint value,
303             uint limit,
304             uint deferred
305         )
306     {
307         investment = investors[addr].investment;
308         paymentTime = investors[addr].paymentTime;
309         value = investors[addr].dividends.value;
310         limit = investors[addr].dividends.limit;
311         deferred = investors[addr].dividends.deferred;
312     }
313 
314     function newInvestor(
315         address addr,
316         uint investment,
317         uint paymentTime,
318         uint dividendsLimit
319     )
320         public
321         onlyOwner
322         returns (
323             bool
324         )
325     {
326         Investor storage inv = investors[addr];
327         if (inv.investment != 0 || investment == 0) {
328             return false;
329         }
330         inv.investment = investment;
331         inv.paymentTime = paymentTime;
332         inv.dividends.limit = dividendsLimit;
333         size++;
334         return true;
335     }
336 
337     function addInvestment(address addr, uint investment) public onlyOwner returns (bool) {
338         if (investors[addr].investment == 0) {
339             return false;
340         }
341         investors[addr].investment = investors[addr].investment.add(investment);
342         return true;
343     }
344 
345     function setPaymentTime(address addr, uint paymentTime) public onlyOwner returns (bool) {
346         if (investors[addr].investment == 0) {
347             return false;
348         }
349         investors[addr].paymentTime = paymentTime;
350         return true;
351     }
352 
353     function addDeferredDividends(address addr, uint dividends) public onlyOwner returns (bool) {
354         if (investors[addr].investment == 0) {
355             return false;
356         }
357         investors[addr].dividends.deferred = investors[addr].dividends.deferred.add(dividends);
358         return true;
359     }
360 
361     function addDividends(address addr, uint dividends) public onlyOwner returns (bool) {
362         if (investors[addr].investment == 0) {
363             return false;
364         }
365         if (investors[addr].dividends.value + dividends > investors[addr].dividends.limit) {
366             investors[addr].dividends.value = investors[addr].dividends.limit;
367         } else {
368             investors[addr].dividends.value = investors[addr].dividends.value.add(dividends);
369         }
370         return true;
371     }
372 
373     function setNewInvestment(address addr, uint investment, uint limit) public onlyOwner returns (bool) {
374         if (investors[addr].investment == 0) {
375             return false;
376         }
377         investors[addr].investment = investment;
378         investors[addr].dividends.limit = limit;
379         // reset payment dividends
380         investors[addr].dividends.value = 0;
381         investors[addr].dividends.deferred = 0;
382 
383         return true;
384     }
385 
386     function addDividendsLimit(address addr, uint limit) public onlyOwner returns (bool) {
387         if (investors[addr].investment == 0) {
388             return false;
389         }
390         investors[addr].dividends.limit = investors[addr].dividends.limit.add(limit);
391 
392         return true;
393     }
394 }
395 
396 contract EthUp is Accessibility {
397     using Percent for Percent.percent;
398     using SafeMath for uint;
399     using Zero for *;
400     using ToAddress for *;
401 
402     // investors storage - iterable map;
403     InvestorsStorage private m_investors;
404     mapping(address => bool) private m_referrals;
405 
406     // automatically generates getters
407     address public advertisingAddress;
408     address public adminsAddress;
409     uint public investmentsNumber;
410     uint public constant MIN_INVESTMENT = 10 finney; // 0.01 eth
411     uint public constant MAX_INVESTMENT = 50 ether;
412     uint public constant MAX_BALANCE = 1e5 ether; // 100 000 eth
413 
414     // percents
415     Percent.percent private m_1_percent = Percent.percent(1, 100);          //  1/100   *100% = 1%
416     Percent.percent private m_1_5_percent = Percent.percent(15, 1000);      //  15/1000 *100% = 1.5%
417     Percent.percent private m_2_percent = Percent.percent(2, 100);          //  2/100   *100% = 2%
418     Percent.percent private m_2_5_percent = Percent.percent(25, 1000);      //  25/1000 *100% = 2.5%
419     Percent.percent private m_3_percent = Percent.percent(3, 100);          //  3/100   *100% = 3%
420     Percent.percent private m_3_5_percent = Percent.percent(35, 1000);      //  35/1000 *100% = 3.5%
421     Percent.percent private m_4_percent = Percent.percent(4, 100);          //  4/100   *100% = 4%
422 
423     Percent.percent private m_refPercent = Percent.percent(5, 100);         //  5/100   *100% = 5%
424     Percent.percent private m_adminsPercent = Percent.percent(5, 100);      //  5/100   *100% = 5%
425     Percent.percent private m_advertisingPercent = Percent.percent(1, 10);  //  1/10    *100% = 10%
426 
427     Percent.percent private m_maxDepositPercent = Percent.percent(15, 10);  //  15/10   *100% = 150%
428     Percent.percent private m_reinvestPercent = Percent.percent(1, 10);     //  10/100  *100% = 10%
429 
430     // more events for easy read from blockchain
431     event LogSendExcessOfEther(address indexed addr, uint when, uint value, uint investment, uint excess);
432     event LogNewInvestor(address indexed addr, uint when);
433     event LogNewInvestment(address indexed addr, uint when, uint investment, uint value);
434     event LogNewReferral(address indexed addr, address indexed referrerAddr, uint when, uint refBonus);
435     event LogReinvest(address indexed addr, uint when, uint investment);
436     event LogPayDividends(address indexed addr, uint when, uint value);
437     event LogPayReferrerBonus(address indexed addr, uint when, uint value);
438     event LogBalanceChanged(uint when, uint balance);
439     event LogDisown(uint when);
440 
441     modifier balanceChanged() {
442         _;
443         emit LogBalanceChanged(now, address(this).balance);
444     }
445 
446     modifier notFromContract() {
447         require(msg.sender.isNotContract(), "only externally accounts");
448         _;
449     }
450 
451     constructor() public {
452         adminsAddress = msg.sender;
453         advertisingAddress = msg.sender;
454 
455         m_investors = new InvestorsStorage();
456         investmentsNumber = 0;
457     }
458 
459     function() public payable {
460         // investor get him dividends
461         if (msg.value.isZero()) {
462             getMyDividends();
463             return;
464         }
465 
466         // sender do invest
467         doInvest(msg.data.toAddress());
468     }
469 
470     function doDisown() public onlyOwner {
471         disown();
472         emit LogDisown(now);
473     }
474 
475     function investorsNumber() public view returns(uint) {
476         return m_investors.size();
477     }
478 
479     function balanceETH() public view returns(uint) {
480         return address(this).balance;
481     }
482 
483     function percent1() public view returns(uint numerator, uint denominator) {
484         (numerator, denominator) = (m_1_percent.num, m_1_percent.den);
485     }
486 
487     function percent1_5() public view returns(uint numerator, uint denominator) {
488         (numerator, denominator) = (m_1_5_percent.num, m_1_5_percent.den);
489     }
490 
491     function percent2() public view returns(uint numerator, uint denominator) {
492         (numerator, denominator) = (m_2_percent.num, m_2_percent.den);
493     }
494 
495     function percent2_5() public view returns(uint numerator, uint denominator) {
496         (numerator, denominator) = (m_2_5_percent.num, m_2_5_percent.den);
497     }
498 
499     function percent3() public view returns(uint numerator, uint denominator) {
500         (numerator, denominator) = (m_3_percent.num, m_3_percent.den);
501     }
502 
503     function percent3_5() public view returns(uint numerator, uint denominator) {
504         (numerator, denominator) = (m_3_5_percent.num, m_3_5_percent.den);
505     }
506 
507     function percent4() public view returns(uint numerator, uint denominator) {
508         (numerator, denominator) = (m_4_percent.num, m_4_percent.den);
509     }
510 
511     function advertisingPercent() public view returns(uint numerator, uint denominator) {
512         (numerator, denominator) = (m_advertisingPercent.num, m_advertisingPercent.den);
513     }
514 
515     function adminsPercent() public view returns(uint numerator, uint denominator) {
516         (numerator, denominator) = (m_adminsPercent.num, m_adminsPercent.den);
517     }
518 
519     function maxDepositPercent() public view returns(uint numerator, uint denominator) {
520         (numerator, denominator) = (m_maxDepositPercent.num, m_maxDepositPercent.den);
521     }
522 
523     function investorInfo(
524         address investorAddr
525     )
526         public
527         view
528         returns (
529             uint investment,
530             uint paymentTime,
531             uint dividends,
532             uint dividendsLimit,
533             uint dividendsDeferred,
534             bool isReferral
535         )
536     {
537         (
538             investment,
539             paymentTime,
540             dividends,
541             dividendsLimit,
542             dividendsDeferred
543         ) = m_investors.investorInfo(investorAddr);
544 
545         isReferral = m_referrals[investorAddr];
546     }
547 
548     function getInvestorDividendsAtNow(
549         address investorAddr
550     )
551         public
552         view
553         returns (
554             uint dividends
555         )
556     {
557         dividends = calcDividends(investorAddr);
558     }
559 
560     function getDailyPercentAtNow(
561         address investorAddr
562     )
563         public
564         view
565         returns (
566             uint numerator,
567             uint denominator
568         )
569     {
570         InvestorsStorage.Investor memory investor = getMemInvestor(investorAddr);
571 
572         Percent.percent memory p = getDailyPercent(investor.investment);
573         (numerator, denominator) = (p.num, p.den);
574     }
575 
576     function getRefBonusPercentAtNow() public view returns(uint numerator, uint denominator) {
577         Percent.percent memory p = getRefBonusPercent();
578         (numerator, denominator) = (p.num, p.den);
579     }
580 
581     function getMyDividends() public notFromContract balanceChanged {
582         // calculate dividends
583         uint dividends = calcDividends(msg.sender);
584         require(dividends.notZero(), "cannot to pay zero dividends");
585 
586         // update investor payment timestamp
587         assert(m_investors.setPaymentTime(msg.sender, now));
588 
589         // check enough eth
590         if (address(this).balance < dividends) {
591             dividends = address(this).balance;
592         }
593 
594         // update payouts dividends
595         assert(m_investors.addDividends(msg.sender, dividends));
596 
597         // transfer dividends to investor
598         msg.sender.transfer(dividends);
599         emit LogPayDividends(msg.sender, now, dividends);
600     }
601 
602     function doInvest(address referrerAddr) public payable notFromContract balanceChanged {
603         uint investment = msg.value;
604         uint receivedEther = msg.value;
605 
606         require(investment >= MIN_INVESTMENT, "investment must be >= MIN_INVESTMENT");
607         require(address(this).balance + investment <= MAX_BALANCE, "the contract eth balance limit");
608 
609         // send excess of ether if needed
610         if (receivedEther > MAX_INVESTMENT) {
611             uint excess = receivedEther - MAX_INVESTMENT;
612             investment = MAX_INVESTMENT;
613             msg.sender.transfer(excess);
614             emit LogSendExcessOfEther(msg.sender, now, receivedEther, investment, excess);
615         }
616 
617         // commission
618         uint advertisingCommission = m_advertisingPercent.mul(investment);
619         uint adminsCommission = m_adminsPercent.mul(investment);
620 
621         bool senderIsInvestor = m_investors.isInvestor(msg.sender);
622 
623         // ref system works only once and only on first invest
624         if (referrerAddr.notZero() &&
625             !senderIsInvestor &&
626             !m_referrals[msg.sender] &&
627             referrerAddr != msg.sender &&
628             m_investors.isInvestor(referrerAddr)) {
629 
630             // add referral bonus to investor`s and referral`s investments
631             uint refBonus = getRefBonusPercent().mmul(investment);
632             assert(m_investors.addInvestment(referrerAddr, refBonus)); // add referrer bonus
633             investment = investment.add(refBonus);                     // add referral bonus
634             m_referrals[msg.sender] = true;
635             emit LogNewReferral(msg.sender, referrerAddr, now, refBonus);
636         }
637 
638         // Dividends cannot be greater then 150% from investor investment
639         uint maxDividends = getMaxDepositPercent().mmul(investment);
640 
641         if (senderIsInvestor) {
642             // check for reinvest
643             InvestorsStorage.Investor memory investor = getMemInvestor(msg.sender);
644             if (investor.dividends.value == investor.dividends.limit) {
645                 uint reinvestBonus = getReinvestBonusPercent().mmul(investment);
646                 investment = investment.add(reinvestBonus);
647                 maxDividends = getMaxDepositPercent().mmul(investment);
648                 // reinvest
649                 assert(m_investors.setNewInvestment(msg.sender, investment, maxDividends));
650                 emit LogReinvest(msg.sender, now, investment);
651             } else {
652                 // prevent burning dividends
653                 uint dividends = calcDividends(msg.sender);
654                 if (dividends.notZero()) {
655                     assert(m_investors.addDeferredDividends(msg.sender, dividends));
656                 }
657                 // update existing investor investment
658                 assert(m_investors.addInvestment(msg.sender, investment));
659                 assert(m_investors.addDividendsLimit(msg.sender, maxDividends));
660             }
661             assert(m_investors.setPaymentTime(msg.sender, now));
662         } else {
663             // create new investor
664             assert(m_investors.newInvestor(msg.sender, investment, now, maxDividends));
665             emit LogNewInvestor(msg.sender, now);
666         }
667 
668         investmentsNumber++;
669         advertisingAddress.transfer(advertisingCommission);
670         adminsAddress.transfer(adminsCommission);
671         emit LogNewInvestment(msg.sender, now, investment, receivedEther);
672     }
673 
674     function setAdvertisingAddress(address addr) public onlyOwner {
675         addr.requireNotZero();
676         advertisingAddress = addr;
677     }
678 
679     function setAdminsAddress(address addr) public onlyOwner {
680         addr.requireNotZero();
681         adminsAddress = addr;
682     }
683 
684     function getMemInvestor(
685         address investorAddr
686     )
687         internal
688         view
689         returns (
690             InvestorsStorage.Investor memory
691         )
692     {
693         (
694             uint investment,
695             uint paymentTime,
696             uint dividends,
697             uint dividendsLimit,
698             uint dividendsDeferred
699         ) = m_investors.investorInfo(investorAddr);
700 
701         return InvestorsStorage.Investor(
702             investment,
703             paymentTime,
704             InvestorsStorage.Dividends(
705                 dividends,
706                 dividendsLimit,
707                 dividendsDeferred)
708         );
709     }
710 
711     function calcDividends(address investorAddr) internal view returns(uint dividends) {
712         InvestorsStorage.Investor memory investor = getMemInvestor(investorAddr);
713         uint interval = 1 days;
714         uint pastTime = now.sub(investor.paymentTime);
715 
716         // safe gas if dividends will be 0
717         if (investor.investment.isZero() || pastTime < interval) {
718             return 0;
719         }
720 
721         // paid dividends cannot be greater then 150% from investor investment
722         if (investor.dividends.value >= investor.dividends.limit) {
723             return 0;
724         }
725 
726         Percent.percent memory p = getDailyPercent(investor.investment);
727         Percent.percent memory c = Percent.percent(p.num + p.den, p.den);
728 
729         uint intervals = pastTime.div(interval);
730         uint totalDividends = investor.dividends.limit.add(investor.investment).sub(investor.dividends.value).sub(investor.dividends.deferred);
731 
732         dividends = investor.investment;
733         for (uint i = 0; i < intervals; i++) {
734             dividends = c.mmul(dividends);
735             if (dividends > totalDividends) {
736                 dividends = totalDividends.add(investor.dividends.deferred);
737                 break;
738             }
739         }
740 
741         dividends = dividends.sub(investor.investment);
742 
743         //uint totalDividends = dividends + investor.dividends;
744         //if (totalDividends >= investor.dividendsLimit) {
745         //    dividends = investor.dividendsLimit - investor.dividends;
746         //}
747     }
748 
749     function getMaxDepositPercent() internal view returns(Percent.percent memory p) {
750         p = m_maxDepositPercent.toMemory();
751     }
752 
753     function getDailyPercent(uint value) internal view returns(Percent.percent memory p) {
754         // (1) 1% if 0.01 ETH <= value < 0.1 ETH
755         // (2) 1.5% if 0.1 ETH <= value < 1 ETH
756         // (3) 2% if 1 ETH <= value < 5 ETH
757         // (4) 2.5% if 5 ETH <= value < 10 ETH
758         // (5) 3% if 10 ETH <= value < 20 ETH
759         // (6) 3.5% if 20 ETH <= value < 30 ETH
760         // (7) 4% if 30 ETH <= value <= 50 ETH
761 
762         if (MIN_INVESTMENT <= value && value < 100 finney) {
763             p = m_1_percent.toMemory();                     // (1)
764         } else if (100 finney <= value && value < 1 ether) {
765             p = m_1_5_percent.toMemory();                   // (2)
766         } else if (1 ether <= value && value < 5 ether) {
767             p = m_2_percent.toMemory();                     // (3)
768         } else if (5 ether <= value && value < 10 ether) {
769             p = m_2_5_percent.toMemory();                   // (4)
770         } else if (10 ether <= value && value < 20 ether) {
771             p = m_3_percent.toMemory();                     // (5)
772         } else if (20 ether <= value && value < 30 ether) {
773             p = m_3_5_percent.toMemory();                   // (6)
774         } else if (30 ether <= value && value <= MAX_INVESTMENT) {
775             p = m_4_percent.toMemory();                     // (7)
776         }
777     }
778 
779     function getRefBonusPercent() internal view returns(Percent.percent memory p) {
780         p = m_refPercent.toMemory();
781     }
782 
783     function getReinvestBonusPercent() internal view returns(Percent.percent memory p) {
784         p = m_reinvestPercent.toMemory();
785     }
786 }