1 pragma solidity 0.4.25;
2 
3 
4 /**
5 *
6 * ETH INVESTMENT SMART PLATFORM - ETHUP
7 * Web               - https://ethup.io
8 * GitHub            - https://github.com/ethup/ethup
9 * Twitter           - https://twitter.com/ethup1
10 * Youtube           - https://www.youtube.com/channel/UC4JMZcpySACj4lGbXLJm9KQ
11 * EN  Telegram_chat: https://t.me/Ethup_en
12 * RU  Telegram_chat: https://t.me/Ethup_ru
13 * KOR Telegram_chat: https://t.me/Ethup_kor
14 * CN  Telegram_chat: https://t.me/Ethup_cn
15 * Email:             mailto:info(at sign)ethup.io
16 * 
17 * 
18 *  - GAIN 1% - 4% PER 24 HOURS
19 *  - Life-long payments
20 *  - The revolutionary reliability
21 *  - Minimal contribution 0.01 ETH
22 *  - Currency and payment - ETH
23 *  - Contribution allocation schemes:
24 *    -- 85,0% payments
25 *    --   10% marketing
26 *    --    5% technical support
27 *
28 *   ---About the Project
29 *  Blockchain-enabled smart contracts have opened a new era of trustless relationships without 
30 *  intermediaries. This technology opens incredible financial possibilities. Our automated investment 
31 *  smart platform is written into a smart contract, uploaded to the Ethereum blockchain and can be 
32 *  freely accessed online. In order to insure our investors' complete security, full control over the 
33 *  project has been transferred from the organizers to the smart contract: nobody can influence the 
34 *  system's permanent autonomous functioning.
35 * 
36 * ---How to use:
37 *  1. Select a level and send from ETH wallet to the smart contract address 0xeccf2a50fca80391b0380188255866f0fc7fe852
38 *     any amount from 0.01 to 50 ETH.
39 *
40 *       Level 1: from 0.01 to 0.1 ETH - 1%
41 *       Level 2: from 0.1 to 1 ETH - 1.5%
42 *       Level 3: from 1 to 5 ETH - 2.0%
43 *       Level 4: from 5 to 10 ETH - 2.5%
44 *       Level 5: from 10 to 20 ETH - 3%.
45 *       Level 6: from 20 to 30 ETH - 3.5%
46 *       Level 7: from 30 to 50 ETH - 4%
47 *
48 *  2. Verify your transaction in the history of your application (wallet) or etherscan.io, specifying the address 
49 *     of your wallet.
50 *  3a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're 
51 *      spending too much on GAS) to the smart contract address 0xeccf2a50fca80391b0380188255866f0fc7fe852.
52 *  OR
53 *  3b. For add investment, you need to deposit the amount that you want to add and the 
54 *      accrued interest automatically summed to your new contribution.
55 *  
56 * RECOMMENDED GAS LIMIT: 210000
57 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
58 * You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.
59 *
60 * Every 24 hours from the moment of the deposit or from the last successful write-off of the accrued interest, 
61 * the smart contract will transfer your dividends to your account that corresponds to the number of your wallet. 
62 * Dividends are accrued until 150% of the investment is paid.
63 * After receiving 150% of all invested funds (or 50% of profits), your wallet will disconnected from payments. 
64 * You can make reinvestment by receiving an additional + 10% for the deposit amount and continue the participation. 
65 * The bonus will received only by the participant who has already received 150% of the profits and invests again.
66 *
67 * The amount of daily charges depends on the sum of all the participant's contributions to the smart contract.
68 *
69 * In case you make a contribution without first removing the accrued interest,
70 * it is added to your new contribution and credited to your account in smart contract
71 *
72 * ---Additional tools embedded in the smart contract:
73 *     - Referral program 5%. The same bonus gets referral and referrer.
74 *     - Reinvestment. After full payment of your first investment, you can receive a 10% bonus for reinvesting funds. 
75 *       You can reinvest any amount.
76 *     - BOOST mode. Get the percentage of your funds remaining in the system. 
77 *
78 * ---It is not allowed to transfer from exchanges, only from your personal ETH wallet, for which you 
79 * have private keys.
80 * 
81 * Contracts reviewed and approved by pros!
82 * 
83 * Main contract - EthUp. Scroll down to find it.
84 */ 
85 
86 
87 library Zero {
88     function requireNotZero(address addr) internal pure {
89         require(addr != address(0), "require not zero address");
90     }
91 
92     function requireNotZero(uint val) internal pure {
93         require(val != 0, "require not zero value");
94     }
95 
96     function notZero(address addr) internal pure returns(bool) {
97         return !(addr == address(0));
98     }
99 
100     function isZero(address addr) internal pure returns(bool) {
101         return addr == address(0);
102     }
103 
104     function isZero(uint a) internal pure returns(bool) {
105         return a == 0;
106     }
107 
108     function notZero(uint a) internal pure returns(bool) {
109         return a != 0;
110     }
111 }
112 
113 /**
114  * @title SafeMath
115  * @dev Math operations with safety checks that revert on error
116  */
117 library SafeMath {
118 
119     /**
120     * @dev Multiplies two numbers, reverts on overflow.
121     */
122     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
123         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
124         // benefit is lost if 'b' is also tested.
125         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
126         if (_a == 0) {
127             return 0;
128         }
129 
130         uint256 c = _a * _b;
131         require(c / _a == _b);
132 
133         return c;
134     }
135 
136     /**
137     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
138     */
139     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
140         require(_b > 0); // Solidity only automatically asserts when dividing by 0
141         uint256 c = _a / _b;
142         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
143 
144         return c;
145     }
146 
147     /**
148     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
149     */
150     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
151         require(_b <= _a);
152         uint256 c = _a - _b;
153 
154         return c;
155     }
156 
157     /**
158     * @dev Adds two numbers, reverts on overflow.
159     */
160     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
161         uint256 c = _a + _b;
162         require(c >= _a);
163 
164         return c;
165     }
166 
167     /**
168     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
169     * reverts when dividing by zero.
170     */
171     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
172         require(b != 0);
173         return a % b;
174     }
175 }
176 
177 library Percent {
178     using SafeMath for uint;
179 
180     // Solidity automatically throws when dividing by 0
181     struct percent {
182         uint num;
183         uint den;
184     }
185 
186     function mul(percent storage p, uint a) internal view returns (uint) {
187         if (a == 0) {
188             return 0;
189         }
190         return a.mul(p.num).div(p.den);
191     }
192 
193     function div(percent storage p, uint a) internal view returns (uint) {
194         return a.div(p.num).mul(p.den);
195     }
196 
197     function sub(percent storage p, uint a) internal view returns (uint) {
198         uint b = mul(p, a);
199         if (b >= a) {
200             return 0; // solium-disable-line lbrace
201         }
202         return a.sub(b);
203     }
204 
205     function add(percent storage p, uint a) internal view returns (uint) {
206         return a.add(mul(p, a));
207     }
208 
209     function toMemory(percent storage p) internal view returns (Percent.percent memory) {
210         return Percent.percent(p.num, p.den);
211     }
212 
213     // memory
214     function mmul(percent memory p, uint a) internal pure returns (uint) {
215         if (a == 0) {
216             return 0;
217         }
218         return a.mul(p.num).div(p.den);
219     }
220 
221     function mdiv(percent memory p, uint a) internal pure returns (uint) {
222         return a.div(p.num).mul(p.den);
223     }
224 
225     function msub(percent memory p, uint a) internal pure returns (uint) {
226         uint b = mmul(p, a);
227         if (b >= a) {
228             return 0;
229         }
230         return a.sub(b);
231     }
232 
233     function madd(percent memory p, uint a) internal pure returns (uint) {
234         return a.add(mmul(p, a));
235     }
236 }
237 
238 library ToAddress {
239 
240     function toAddress(bytes source) internal pure returns(address addr) {
241         assembly { addr := mload(add(source, 0x14)) }
242         return addr;
243     }
244 
245     function isNotContract(address addr) internal view returns(bool) {
246         uint length;
247         assembly { length := extcodesize(addr) }
248         return length == 0;
249     }
250 }
251 
252 contract Accessibility {
253 
254     address private owner;
255 
256     modifier onlyOwner() {
257         require(msg.sender == owner, "access denied");
258         _;
259     }
260 
261     constructor() public {
262         owner = msg.sender;
263     }
264 
265     function disown() internal {
266         delete owner;
267     }
268 }
269 
270 contract InvestorsStorage is Accessibility {
271     using SafeMath for uint;
272 
273     struct Dividends {
274         uint value;     //paid
275         uint limit;
276         uint deferred;  //not paid yet
277     }
278 
279     struct Investor {
280         uint investment;
281         uint paymentTime;
282         Dividends dividends;
283     }
284 
285     uint public size;
286 
287     mapping (address => Investor) private investors;
288 
289     function isInvestor(address addr) public view returns (bool) {
290         return investors[addr].investment > 0;
291     }
292 
293     function investorInfo(
294         address addr
295     )
296         public
297         view
298         returns (
299             uint investment,
300             uint paymentTime,
301             uint value,
302             uint limit,
303             uint deferred
304         )
305     {
306         investment = investors[addr].investment;
307         paymentTime = investors[addr].paymentTime;
308         value = investors[addr].dividends.value;
309         limit = investors[addr].dividends.limit;
310         deferred = investors[addr].dividends.deferred;
311     }
312 
313     function newInvestor(
314         address addr,
315         uint investment,
316         uint paymentTime,
317         uint dividendsLimit
318     )
319         public
320         onlyOwner
321         returns (
322             bool
323         )
324     {
325         Investor storage inv = investors[addr];
326         if (inv.investment != 0 || investment == 0) {
327             return false;
328         }
329         inv.investment = investment;
330         inv.paymentTime = paymentTime;
331         inv.dividends.limit = dividendsLimit;
332         size++;
333         return true;
334     }
335 
336     function addInvestment(address addr, uint investment) public onlyOwner returns (bool) {
337         if (investors[addr].investment == 0) {
338             return false;
339         }
340         investors[addr].investment = investors[addr].investment.add(investment);
341         return true;
342     }
343 
344     function setPaymentTime(address addr, uint paymentTime) public onlyOwner returns (bool) {
345         if (investors[addr].investment == 0) {
346             return false;
347         }
348         investors[addr].paymentTime = paymentTime;
349         return true;
350     }
351 
352     function addDeferredDividends(address addr, uint dividends) public onlyOwner returns (bool) {
353         if (investors[addr].investment == 0) {
354             return false;
355         }
356         investors[addr].dividends.deferred = investors[addr].dividends.deferred.add(dividends);
357         return true;
358     }
359 
360     function addDividends(address addr, uint dividends) public onlyOwner returns (bool) {
361         if (investors[addr].investment == 0) {
362             return false;
363         }
364         if (investors[addr].dividends.value + dividends > investors[addr].dividends.limit) {
365             investors[addr].dividends.value = investors[addr].dividends.limit;
366         } else {
367             investors[addr].dividends.value = investors[addr].dividends.value.add(dividends);
368         }
369         return true;
370     }
371 
372     function setNewInvestment(address addr, uint investment, uint limit) public onlyOwner returns (bool) {
373         if (investors[addr].investment == 0) {
374             return false;
375         }
376         investors[addr].investment = investment;
377         investors[addr].dividends.limit = limit;
378         // reset payment dividends
379         investors[addr].dividends.value = 0;
380         investors[addr].dividends.deferred = 0;
381 
382         return true;
383     }
384 
385     function addDividendsLimit(address addr, uint limit) public onlyOwner returns (bool) {
386         if (investors[addr].investment == 0) {
387             return false;
388         }
389         investors[addr].dividends.limit = investors[addr].dividends.limit.add(limit);
390 
391         return true;
392     }
393 }
394 
395 contract EthUp is Accessibility {
396     using Percent for Percent.percent;
397     using SafeMath for uint;
398     using Zero for *;
399     using ToAddress for *;
400 
401     // investors storage - iterable map;
402     InvestorsStorage private m_investors;
403     mapping(address => bool) private m_referrals;
404 
405     // automatically generates getters
406     address public advertisingAddress;
407     address public adminsAddress;
408     uint public investmentsNumber;
409     uint public constant MIN_INVESTMENT = 10 finney; // 0.01 eth
410     uint public constant MAX_INVESTMENT = 50 ether;
411     uint public constant MAX_BALANCE = 1e5 ether; // 100 000 eth
412 
413     // percents
414     Percent.percent private m_1_percent = Percent.percent(1, 100);          //  1/100   *100% = 1%
415     Percent.percent private m_1_5_percent = Percent.percent(15, 1000);      //  15/1000 *100% = 1.5%
416     Percent.percent private m_2_percent = Percent.percent(2, 100);          //  2/100   *100% = 2%
417     Percent.percent private m_2_5_percent = Percent.percent(25, 1000);      //  25/1000 *100% = 2.5%
418     Percent.percent private m_3_percent = Percent.percent(3, 100);          //  3/100   *100% = 3%
419     Percent.percent private m_3_5_percent = Percent.percent(35, 1000);      //  35/1000 *100% = 3.5%
420     Percent.percent private m_4_percent = Percent.percent(4, 100);          //  4/100   *100% = 4%
421 
422     Percent.percent private m_refPercent = Percent.percent(5, 100);         //  5/100   *100% = 5%
423     Percent.percent private m_adminsPercent = Percent.percent(5, 100);      //  5/100   *100% = 5%
424     Percent.percent private m_advertisingPercent = Percent.percent(1, 10);  //  1/10    *100% = 10%
425 
426     Percent.percent private m_maxDepositPercent = Percent.percent(15, 10);  //  15/10   *100% = 150%
427     Percent.percent private m_reinvestPercent = Percent.percent(1, 10);     //  10/100  *100% = 10%
428 
429     // more events for easy read from blockchain
430     event LogSendExcessOfEther(address indexed addr, uint when, uint value, uint investment, uint excess);
431     event LogNewInvestor(address indexed addr, uint when);
432     event LogNewInvestment(address indexed addr, uint when, uint investment, uint value);
433     event LogNewReferral(address indexed addr, address indexed referrerAddr, uint when, uint refBonus);
434     event LogReinvest(address indexed addr, uint when, uint investment);
435     event LogPayDividends(address indexed addr, uint when, uint value);
436     event LogPayReferrerBonus(address indexed addr, uint when, uint value);
437     event LogBalanceChanged(uint when, uint balance);
438     event LogDisown(uint when);
439 
440     modifier balanceChanged() {
441         _;
442         emit LogBalanceChanged(now, address(this).balance);
443     }
444 
445     modifier notFromContract() {
446         require(msg.sender.isNotContract(), "only externally accounts");
447         _;
448     }
449 
450     modifier checkPayloadSize(uint size) {
451         require(msg.data.length >= size + 4);
452         _;
453     }
454 
455     constructor() public {
456         adminsAddress = msg.sender;
457         advertisingAddress = msg.sender;
458 
459         m_investors = new InvestorsStorage();
460         investmentsNumber = 0;
461     }
462 
463     function() public payable {
464         // investor get him dividends
465         if (msg.value.isZero()) {
466             getMyDividends();
467             return;
468         }
469 
470         // sender do invest
471         doInvest(msg.sender, msg.data.toAddress());
472     }
473 
474     function doDisown() public onlyOwner {
475         disown();
476         emit LogDisown(now);
477     }
478 
479     function investorsNumber() public view returns(uint) {
480         return m_investors.size();
481     }
482 
483     function balanceETH() public view returns(uint) {
484         return address(this).balance;
485     }
486 
487     function percent1() public view returns(uint numerator, uint denominator) {
488         (numerator, denominator) = (m_1_percent.num, m_1_percent.den);
489     }
490 
491     function percent1_5() public view returns(uint numerator, uint denominator) {
492         (numerator, denominator) = (m_1_5_percent.num, m_1_5_percent.den);
493     }
494 
495     function percent2() public view returns(uint numerator, uint denominator) {
496         (numerator, denominator) = (m_2_percent.num, m_2_percent.den);
497     }
498 
499     function percent2_5() public view returns(uint numerator, uint denominator) {
500         (numerator, denominator) = (m_2_5_percent.num, m_2_5_percent.den);
501     }
502 
503     function percent3() public view returns(uint numerator, uint denominator) {
504         (numerator, denominator) = (m_3_percent.num, m_3_percent.den);
505     }
506 
507     function percent3_5() public view returns(uint numerator, uint denominator) {
508         (numerator, denominator) = (m_3_5_percent.num, m_3_5_percent.den);
509     }
510 
511     function percent4() public view returns(uint numerator, uint denominator) {
512         (numerator, denominator) = (m_4_percent.num, m_4_percent.den);
513     }
514 
515     function advertisingPercent() public view returns(uint numerator, uint denominator) {
516         (numerator, denominator) = (m_advertisingPercent.num, m_advertisingPercent.den);
517     }
518 
519     function adminsPercent() public view returns(uint numerator, uint denominator) {
520         (numerator, denominator) = (m_adminsPercent.num, m_adminsPercent.den);
521     }
522 
523     function maxDepositPercent() public view returns(uint numerator, uint denominator) {
524         (numerator, denominator) = (m_maxDepositPercent.num, m_maxDepositPercent.den);
525     }
526 
527     function investorInfo(
528         address investorAddr
529     )
530         public
531         view
532         returns (
533             uint investment,
534             uint paymentTime,
535             uint dividends,
536             uint dividendsLimit,
537             uint dividendsDeferred,
538             bool isReferral
539         )
540     {
541         (
542             investment,
543             paymentTime,
544             dividends,
545             dividendsLimit,
546             dividendsDeferred
547         ) = m_investors.investorInfo(investorAddr);
548 
549         isReferral = m_referrals[investorAddr];
550     }
551 
552     function getInvestorDividendsAtNow(
553         address investorAddr
554     )
555         public
556         view
557         returns (
558             uint dividends
559         )
560     {
561         dividends = calcDividends(investorAddr);
562     }
563 
564     function getDailyPercentAtNow(
565         address investorAddr
566     )
567         public
568         view
569         returns (
570             uint numerator,
571             uint denominator
572         )
573     {
574         InvestorsStorage.Investor memory investor = getMemInvestor(investorAddr);
575 
576         Percent.percent memory p = getDailyPercent(investor.investment);
577         (numerator, denominator) = (p.num, p.den);
578     }
579 
580     function getRefBonusPercentAtNow() public view returns(uint numerator, uint denominator) {
581         Percent.percent memory p = getRefBonusPercent();
582         (numerator, denominator) = (p.num, p.den);
583     }
584 
585     function getMyDividends() public notFromContract balanceChanged {
586         // calculate dividends
587         uint dividends = calcDividends(msg.sender);
588         require(dividends.notZero(), "cannot to pay zero dividends");
589 
590         // update investor payment timestamp
591         assert(m_investors.setPaymentTime(msg.sender, now));
592 
593         // check enough eth
594         if (address(this).balance < dividends) {
595             dividends = address(this).balance;
596         }
597 
598         // update payouts dividends
599         assert(m_investors.addDividends(msg.sender, dividends));
600 
601         // transfer dividends to investor
602         msg.sender.transfer(dividends);
603         emit LogPayDividends(msg.sender, now, dividends);
604     }
605 
606     // for fiat investors and bounty program
607     function createInvest(
608         address investorAddress,
609         address referrerAddr
610     )
611         public
612         payable
613         notFromContract
614         balanceChanged
615         onlyOwner
616     {
617         //require(adminsAddress == msg.sender, "only admin can do invest from new investor");
618         doInvest(investorAddress, referrerAddr);
619     }
620 
621     function doInvest(
622         address investorAddress,
623         address referrerAddr
624     )
625         public
626         payable
627         notFromContract
628         balanceChanged
629     {
630         uint investment = msg.value;
631         uint receivedEther = msg.value;
632 
633         require(investment >= MIN_INVESTMENT, "investment must be >= MIN_INVESTMENT");
634         require(address(this).balance + investment <= MAX_BALANCE, "the contract eth balance limit");
635 
636         // send excess of ether if needed
637         if (receivedEther > MAX_INVESTMENT) {
638             uint excess = receivedEther - MAX_INVESTMENT;
639             investment = MAX_INVESTMENT;
640             investorAddress.transfer(excess);
641             emit LogSendExcessOfEther(investorAddress, now, receivedEther, investment, excess);
642         }
643 
644         // commission
645         uint advertisingCommission = m_advertisingPercent.mul(investment);
646         uint adminsCommission = m_adminsPercent.mul(investment);
647         advertisingAddress.transfer(advertisingCommission);
648         adminsAddress.transfer(adminsCommission);
649 
650         bool senderIsInvestor = m_investors.isInvestor(investorAddress);
651 
652         // ref system works only once and only on first invest
653         if (referrerAddr.notZero() &&
654             !senderIsInvestor &&
655             !m_referrals[investorAddress] &&
656             referrerAddr != investorAddress &&
657             m_investors.isInvestor(referrerAddr)) {
658 
659             // add referral bonus to investor`s and referral`s investments
660             uint refBonus = getRefBonusPercent().mmul(investment);
661             assert(m_investors.addInvestment(referrerAddr, refBonus)); // add referrer bonus
662             investment = investment.add(refBonus);                     // add referral bonus
663             m_referrals[investorAddress] = true;
664             emit LogNewReferral(investorAddress, referrerAddr, now, refBonus);
665         }
666 
667         // Dividends cannot be greater then 150% from investor investment
668         uint maxDividends = getMaxDepositPercent().mmul(investment);
669 
670         if (senderIsInvestor) {
671             // check for reinvest
672             InvestorsStorage.Investor memory investor = getMemInvestor(investorAddress);
673             if (investor.dividends.value == investor.dividends.limit) {
674                 uint reinvestBonus = getReinvestBonusPercent().mmul(investment);
675                 investment = investment.add(reinvestBonus);
676                 maxDividends = getMaxDepositPercent().mmul(investment);
677                 // reinvest
678                 assert(m_investors.setNewInvestment(investorAddress, investment, maxDividends));
679                 emit LogReinvest(investorAddress, now, investment);
680             } else {
681                 // prevent burning dividends
682                 uint dividends = calcDividends(investorAddress);
683                 if (dividends.notZero()) {
684                     assert(m_investors.addDeferredDividends(investorAddress, dividends));
685                 }
686                 // update existing investor investment
687                 assert(m_investors.addInvestment(investorAddress, investment));
688                 assert(m_investors.addDividendsLimit(investorAddress, maxDividends));
689             }
690             assert(m_investors.setPaymentTime(investorAddress, now));
691         } else {
692             // create new investor
693             assert(m_investors.newInvestor(investorAddress, investment, now, maxDividends));
694             emit LogNewInvestor(investorAddress, now);
695         }
696 
697         investmentsNumber++;
698         emit LogNewInvestment(investorAddress, now, investment, receivedEther);
699     }
700 
701     function setAdvertisingAddress(address addr) public onlyOwner {
702         addr.requireNotZero();
703         advertisingAddress = addr;
704     }
705 
706     function setAdminsAddress(address addr) public onlyOwner {
707         addr.requireNotZero();
708         adminsAddress = addr;
709     }
710 
711     function getMemInvestor(
712         address investorAddr
713     )
714         internal
715         view
716         returns (
717             InvestorsStorage.Investor memory
718         )
719     {
720         (
721             uint investment,
722             uint paymentTime,
723             uint dividends,
724             uint dividendsLimit,
725             uint dividendsDeferred
726         ) = m_investors.investorInfo(investorAddr);
727 
728         return InvestorsStorage.Investor(
729             investment,
730             paymentTime,
731             InvestorsStorage.Dividends(
732                 dividends,
733                 dividendsLimit,
734                 dividendsDeferred)
735         );
736     }
737 
738     function calcDividends(address investorAddr) internal view returns(uint dividends) {
739         InvestorsStorage.Investor memory investor = getMemInvestor(investorAddr);
740         uint interval = 1 days;
741         uint pastTime = now.sub(investor.paymentTime);
742 
743         // safe gas if dividends will be 0
744         if (investor.investment.isZero() || pastTime < interval) {
745             return 0;
746         }
747 
748         // paid dividends cannot be greater then 150% from investor investment
749         if (investor.dividends.value >= investor.dividends.limit) {
750             return 0;
751         }
752 
753         Percent.percent memory p = getDailyPercent(investor.investment);
754         Percent.percent memory c = Percent.percent(p.num + p.den, p.den);
755 
756         uint intervals = pastTime.div(interval);
757         uint totalDividends = investor.dividends.limit.add(investor.investment).sub(investor.dividends.value).sub(investor.dividends.deferred);
758 
759         dividends = investor.investment;
760         for (uint i = 0; i < intervals; i++) {
761             dividends = c.mmul(dividends);
762             if (dividends > totalDividends) {
763                 dividends = totalDividends.add(investor.dividends.deferred);
764                 break;
765             }
766         }
767 
768         dividends = dividends.sub(investor.investment);
769 
770         //uint totalDividends = dividends + investor.dividends;
771         //if (totalDividends >= investor.dividendsLimit) {
772         //    dividends = investor.dividendsLimit - investor.dividends;
773         //}
774     }
775 
776     function getMaxDepositPercent() internal view returns(Percent.percent memory p) {
777         p = m_maxDepositPercent.toMemory();
778     }
779 
780     function getDailyPercent(uint value) internal view returns(Percent.percent memory p) {
781         // (1) 1% if 0.01 ETH <= value < 0.1 ETH
782         // (2) 1.5% if 0.1 ETH <= value < 1 ETH
783         // (3) 2% if 1 ETH <= value < 5 ETH
784         // (4) 2.5% if 5 ETH <= value < 10 ETH
785         // (5) 3% if 10 ETH <= value < 20 ETH
786         // (6) 3.5% if 20 ETH <= value < 30 ETH
787         // (7) 4% if 30 ETH <= value <= 50 ETH
788 
789         if (MIN_INVESTMENT <= value && value < 100 finney) {
790             p = m_1_percent.toMemory();                     // (1)
791         } else if (100 finney <= value && value < 1 ether) {
792             p = m_1_5_percent.toMemory();                   // (2)
793         } else if (1 ether <= value && value < 5 ether) {
794             p = m_2_percent.toMemory();                     // (3)
795         } else if (5 ether <= value && value < 10 ether) {
796             p = m_2_5_percent.toMemory();                   // (4)
797         } else if (10 ether <= value && value < 20 ether) {
798             p = m_3_percent.toMemory();                     // (5)
799         } else if (20 ether <= value && value < 30 ether) {
800             p = m_3_5_percent.toMemory();                   // (6)
801         } else if (30 ether <= value && value <= MAX_INVESTMENT) {
802             p = m_4_percent.toMemory();                     // (7)
803         }
804     }
805 
806     function getRefBonusPercent() internal view returns(Percent.percent memory p) {
807         p = m_refPercent.toMemory();
808     }
809 
810     function getReinvestBonusPercent() internal view returns(Percent.percent memory p) {
811         p = m_reinvestPercent.toMemory();
812     }
813 }