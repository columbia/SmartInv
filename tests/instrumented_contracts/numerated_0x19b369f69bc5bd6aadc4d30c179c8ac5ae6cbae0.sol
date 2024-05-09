1 pragma solidity ^0.4.25;
2 
3 /**
4 *
5 * ETH CRYPTOCURRENCY DISTRIBUTION PROJECT
6 * Web              - https://255eth.club
7 * Our partners telegram_channel - https://t.me/invest_to_smartcontract
8 * EN  Telegram_chat: https://t.me/club_255eth_en
9 * RU  Telegram_chat: https://t.me/club_255eth_ru
10 * Email:             mailto:support(at sign)255eth.club
11 * 
12 *  - GAIN 2,55% PER 24 HOURS (every 5900 blocks)
13 *  - Life-long payments
14 *  - The revolutionary reliability
15 *  - Minimal contribution 0.01 eth
16 *  - Currency and payment - ETH
17 *  - Contribution allocation schemes:
18 *    -- 90% payments
19 *    -- 5% Referral program (3% first level, 2% second level)
20 *    -- 5% (4% Marketing, 1% Operating Expenses)
21 * 
22 *  - Referral will be rewarded
23 *    -- Your referral will receive 3% of his first investment to deposit.
24 * 
25 *  - HOW TO GET MORE INCOME?
26 *    -- Marathon "The Best Investor"
27 *       Current winner becomes common referrer for investors without 
28 *       referrer and get a lump sum of 3% of their deposits. 
29 *       To become winner you must invest more than previous winner.
30 *       
31 *       How to check: see bestInvestorInfo in the contract
32 * 
33 *    -- Marathon "The Best Promoter"
34 *       Current winner becomes common referrer for investors without 
35 *       referrer and get a lump sum of 2% of their deposits. 
36 *       To become winner you must invite more than previous winner.
37 *
38 *       How to check: see bestPromouterInfo in the contract
39 * 
40 *    -- Send advertise tokens with contract method massAdvertiseTransfer or transfer 
41 *       and get 1% from first investments of invited wallets.
42 *       Advertise tokens free for all but you will pay gas fee for call methods.
43 *
44 *   ---About the Project
45 *  Blockchain-enabled smart contracts have opened a new era of trustless relationships without 
46 *  intermediaries. This technology opens incredible financial possibilities. Our automated investment 
47 *  distribution model is written into a smart contract, uploaded to the Ethereum blockchain and can be 
48 *  freely accessed online. In order to insure our investors' complete security, full control over the 
49 *  project has been transferred from the organizers to the smart contract: nobody can influence the 
50 *  system's permanent autonomous functioning.
51 * 
52 * ---How to use:
53 *  1. Send from ETH wallet to the smart contract address 0x19b369f69bc5bd6aadc4d30c179c8ac5ae6cbae0
54 *     any amount from 0.01 ETH.
55 *  2. Verify your transaction in the history of your application or etherscan.io, specifying the address 
56 *     of your wallet.
57 *  3a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're 
58 *      spending too much on GAS). But not early then 24 hours from last time claim or invest.
59 *  OR
60 *  3b. For reinvest, you need to first remove the accumulated percentage of charges (by sending 0 ether 
61 *      transaction), and only after that, deposit the amount that you want to reinvest.
62 *  
63 * RECOMMENDED GAS LIMIT: 350000
64 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
65 * You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.
66 *
67 * ---It is not allowed to transfer from exchanges, only from your personal ETH wallet, for which you 
68 * have private keys.
69 * 
70 * Contracts reviewed and approved by pros!
71 * 
72 * Main contract - Revolution. Scroll down to find it.
73 */
74 
75 
76 contract InvestorsStorage {
77   struct investor {
78     uint keyIndex;
79     uint value;
80     uint paymentTime;
81     uint refs;
82     uint refBonus;
83   }
84   struct bestAddress {
85       uint value;
86       address addr;
87   }
88   struct recordStats {
89     uint investors;
90     uint invested;
91   }
92   struct itmap {
93     mapping(uint => recordStats) stats;
94     mapping(address => investor) data;
95     address[] keys;
96     bestAddress bestInvestor;
97     bestAddress bestPromouter;
98   }
99   itmap private s;
100   
101   address private owner;
102   
103   event LogBestInvestorChanged(address indexed addr, uint when, uint invested);
104   event LogBestPromouterChanged(address indexed addr, uint when, uint refs);
105 
106   modifier onlyOwner() {
107     require(msg.sender == owner, "access denied");
108     _;
109   }
110 
111   constructor() public {
112     owner = msg.sender;
113     s.keys.length++;
114   }
115 
116   function insert(address addr, uint value) public onlyOwner returns (bool) {
117     uint keyIndex = s.data[addr].keyIndex;
118     if (keyIndex != 0) return false;
119     s.data[addr].value = value;
120     keyIndex = s.keys.length++;
121     s.data[addr].keyIndex = keyIndex;
122     s.keys[keyIndex] = addr;
123     updateBestInvestor(addr, s.data[addr].value);
124     
125     return true;
126   }
127 
128   function investorFullInfo(address addr) public view returns(uint, uint, uint, uint, uint) {
129     return (
130       s.data[addr].keyIndex,
131       s.data[addr].value,
132       s.data[addr].paymentTime,
133       s.data[addr].refs,
134       s.data[addr].refBonus
135     );
136   }
137 
138   function investorBaseInfo(address addr) public view returns(uint, uint, uint, uint) {
139     return (
140       s.data[addr].value,
141       s.data[addr].paymentTime,
142       s.data[addr].refs,
143       s.data[addr].refBonus
144     );
145   }
146 
147   function investorShortInfo(address addr) public view returns(uint, uint) {
148     return (
149       s.data[addr].value,
150       s.data[addr].refBonus
151     );
152   }
153 
154   function getBestInvestor() public view returns(uint, address) {
155     return (
156       s.bestInvestor.value,
157       s.bestInvestor.addr
158     );
159   }
160   
161   function getBestPromouter() public view returns(uint, address) {
162     return (
163       s.bestPromouter.value,
164       s.bestPromouter.addr
165     );
166   }
167 
168   function addRefBonus(address addr, uint refBonus) public onlyOwner returns (bool) {
169     if (s.data[addr].keyIndex == 0) return false;
170     s.data[addr].refBonus += refBonus;
171     return true;
172   }
173   
174   function addRefBonusWithRefs(address addr, uint refBonus) public onlyOwner returns (bool) {
175     if (s.data[addr].keyIndex == 0) return false;
176     s.data[addr].refBonus += refBonus;
177     s.data[addr].refs++;
178     updateBestPromouter(addr, s.data[addr].refs);
179     
180     return true;
181   }
182 
183   function addValue(address addr, uint value) public onlyOwner returns (bool) {
184     if (s.data[addr].keyIndex == 0) return false;
185     s.data[addr].value += value;
186     updateBestInvestor(addr, s.data[addr].value);
187     
188     return true;
189   }
190   
191   function updateStats(uint dt, uint invested, uint investors) public {
192     s.stats[dt].invested += invested;
193     s.stats[dt].investors += investors;
194   }
195   
196   function stats(uint dt) public view returns (uint invested, uint investors) {
197     return ( 
198       s.stats[dt].invested,
199       s.stats[dt].investors
200     );
201   }
202   
203   function updateBestInvestor(address addr, uint investorValue) internal {
204     if(investorValue > s.bestInvestor.value){
205         s.bestInvestor.value = investorValue;
206         s.bestInvestor.addr = addr;
207         emit LogBestInvestorChanged(addr, now, s.bestInvestor.value);
208     }      
209   }
210   
211   function updateBestPromouter(address addr, uint investorRefs) internal {
212     if(investorRefs > s.bestPromouter.value){
213         s.bestPromouter.value = investorRefs;
214         s.bestPromouter.addr = addr;
215         emit LogBestPromouterChanged(addr, now, s.bestPromouter.value);
216     }      
217   }
218 
219   function setPaymentTime(address addr, uint paymentTime) public onlyOwner returns (bool) {
220     if (s.data[addr].keyIndex == 0) return false;
221     s.data[addr].paymentTime = paymentTime;
222     return true;
223   }
224 
225   function setRefBonus(address addr, uint refBonus) public onlyOwner returns (bool) {
226     if (s.data[addr].keyIndex == 0) return false;
227     s.data[addr].refBonus = refBonus;
228     return true;
229   }
230 
231   function keyFromIndex(uint i) public view returns (address) {
232     return s.keys[i];
233   }
234 
235   function contains(address addr) public view returns (bool) {
236     return s.data[addr].keyIndex > 0;
237   }
238 
239   function size() public view returns (uint) {
240     return s.keys.length;
241   }
242 
243   function iterStart() public pure returns (uint) {
244     return 1;
245   }
246 }
247 
248 
249 contract DT {
250         struct DateTime {
251                 uint16 year;
252                 uint8 month;
253                 uint8 day;
254                 uint8 hour;
255                 uint8 minute;
256                 uint8 second;
257                 uint8 weekday;
258         }
259 
260         uint private constant DAY_IN_SECONDS = 86400;
261         uint private constant YEAR_IN_SECONDS = 31536000;
262         uint private constant LEAP_YEAR_IN_SECONDS = 31622400;
263 
264         uint private constant HOUR_IN_SECONDS = 3600;
265         uint private constant MINUTE_IN_SECONDS = 60;
266 
267         uint16 private constant ORIGIN_YEAR = 1970;
268 
269         function isLeapYear(uint16 year) internal pure returns (bool) {
270                 if (year % 4 != 0) {
271                         return false;
272                 }
273                 if (year % 100 != 0) {
274                         return true;
275                 }
276                 if (year % 400 != 0) {
277                         return false;
278                 }
279                 return true;
280         }
281 
282         function leapYearsBefore(uint year) internal pure returns (uint) {
283                 year -= 1;
284                 return year / 4 - year / 100 + year / 400;
285         }
286 
287         function getDaysInMonth(uint8 month, uint16 year) internal pure returns (uint8) {
288                 if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
289                         return 31;
290                 }
291                 else if (month == 4 || month == 6 || month == 9 || month == 11) {
292                         return 30;
293                 }
294                 else if (isLeapYear(year)) {
295                         return 29;
296                 }
297                 else {
298                         return 28;
299                 }
300         }
301 
302         function parseTimestamp(uint timestamp) internal pure returns (DateTime dt) {
303                 uint secondsAccountedFor = 0;
304                 uint buf;
305                 uint8 i;
306 
307                 // Year
308                 dt.year = getYear(timestamp);
309                 buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
310 
311                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
312                 secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
313 
314                 // Month
315                 uint secondsInMonth;
316                 for (i = 1; i <= 12; i++) {
317                         secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
318                         if (secondsInMonth + secondsAccountedFor > timestamp) {
319                                 dt.month = i;
320                                 break;
321                         }
322                         secondsAccountedFor += secondsInMonth;
323                 }
324 
325                 // Day
326                 for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
327                         if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
328                                 dt.day = i;
329                                 break;
330                         }
331                         secondsAccountedFor += DAY_IN_SECONDS;
332                 }
333         }
334         
335         function getYear(uint timestamp) internal pure returns (uint16) {
336                 uint secondsAccountedFor = 0;
337                 uint16 year;
338                 uint numLeapYears;
339 
340                 // Year
341                 year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
342                 numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
343 
344                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
345                 secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
346 
347                 while (secondsAccountedFor > timestamp) {
348                         if (isLeapYear(uint16(year - 1))) {
349                                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
350                         }
351                         else {
352                                 secondsAccountedFor -= YEAR_IN_SECONDS;
353                         }
354                         year -= 1;
355                 }
356                 return year;
357         }
358 
359         function getMonth(uint timestamp) internal pure returns (uint8) {
360                 return parseTimestamp(timestamp).month;
361         }
362 
363         function getDay(uint timestamp) internal pure returns (uint8) {
364                 return parseTimestamp(timestamp).day;
365         }
366 
367 }
368 /**
369     ERC20 Token standart for contract advetising
370 **/
371 contract ERC20AdToken {
372     using SafeMath for uint;
373     using Zero for *;
374 
375     string public symbol;
376     string public  name;
377     uint8 public decimals = 0;
378     uint256 public totalSupply;
379     
380     mapping (address => uint256) public balanceOf;
381     mapping(address => address) public adtransfers;
382     
383     event Transfer(address indexed from, address indexed to, uint tokens);
384     
385     // ------------------------------------------------------------------------
386     // Constructor
387     // ------------------------------------------------------------------------
388     constructor(string _symbol, string _name) public {
389         symbol = _symbol;
390         name = _name;
391         balanceOf[this] = 10000000000;
392         totalSupply = 10000000000;
393         emit Transfer(address(0), this, 10000000000);
394     }
395 
396     function transfer(address to, uint tokens) public returns (bool success) {
397         //This method do not send anything. It is only notify blockchain that Advertise Token Transfered
398         //You can call this method for advertise this contract and invite new investors and gain 1% from each first investments.
399         if(!adtransfers[to].notZero()){
400             adtransfers[to] = msg.sender;
401             emit Transfer(this, to, tokens);
402         }
403         return true;
404     }
405     
406     function massAdvertiseTransfer(address[] addresses, uint tokens) public returns (bool success) {
407         for (uint i = 0; i < addresses.length; i++) {
408             if(!adtransfers[addresses[i]].notZero()){
409                 adtransfers[addresses[i]] = msg.sender;
410                 emit Transfer(this, addresses[i], tokens);
411             }
412         }
413         
414         return true;
415     }
416 
417     function () public payable {
418         revert();
419     }
420 
421 }
422 
423 contract EarnEveryDay_255 is ERC20AdToken, DT {
424   using Percent for Percent.percent;
425   using SafeMath for uint;
426   using Zero for *;
427   using ToAddress for *;
428   using Convert for *;
429 
430   // investors storage - iterable map;
431   InvestorsStorage private m_investors;
432   mapping(address => address) private m_referrals;
433   bool private m_nextWave;
434 
435   // automatically generates getters
436   address public adminAddr;
437   uint public waveStartup;
438   uint public totalInvestments;
439   uint public totalInvested;
440   uint public constant minInvesment = 10 finney; // 0.01 eth
441   uint public constant maxBalance = 255e5 ether; // 25,500,000 eth
442   uint public constant dividendsPeriod = 24 hours; //24 hours
443 
444   // percents 
445   Percent.percent private m_dividendsPercent = Percent.percent(255, 10000); // 255/10000*100% = 2.55%
446   Percent.percent private m_adminPercent = Percent.percent(5, 100); // 5/100*100% = 5%
447   Percent.percent private m_refPercent1 = Percent.percent(3, 100); // 3/100*100% = 3%
448   Percent.percent private m_refPercent2 = Percent.percent(2, 100); // 2/100*100% = 2%
449   Percent.percent private m_adBonus = Percent.percent(1, 100); // 1/100*100% = 1%
450 
451   // more events for easy read from blockchain
452   event LogNewInvestor(address indexed addr, uint when, uint value);
453   event LogNewInvesment(address indexed addr, uint when, uint value);
454   event LogNewReferral(address indexed addr, uint when, uint value);
455   event LogPayDividends(address indexed addr, uint when, uint value);
456   event LogPayReferrerBonus(address indexed addr, uint when, uint value);
457   event LogBalanceChanged(uint when, uint balance);
458   event LogNextWave(uint when);
459 
460   modifier balanceChanged {
461     _;
462     emit LogBalanceChanged(now, address(this).balance);
463   }
464 
465   constructor() ERC20AdToken("Earn 2.55% Every Day. https://255eth.club", 
466                             "Send your ETH to this contract and earn 2.55% every day for Live-long. https://255eth.club") public {
467     adminAddr = msg.sender;
468 
469     nextWave();
470   }
471 
472   function() public payable {
473     // investor get him dividends
474     if (msg.value == 0) {
475       getMyDividends();
476       return;
477     }
478 
479     // sender do invest
480     address a = msg.data.toAddr();
481     doInvest(a);
482   }
483 
484   function investorsNumber() public view returns(uint) {
485     return m_investors.size()-1;
486     // -1 because see InvestorsStorage constructor where keys.length++ 
487   }
488 
489   function balanceETH() public view returns(uint) {
490     return address(this).balance;
491   }
492 
493   function dividendsPercent() public view returns(uint numerator, uint denominator) {
494     (numerator, denominator) = (m_dividendsPercent.num, m_dividendsPercent.den);
495   }
496 
497   function adminPercent() public view returns(uint numerator, uint denominator) {
498     (numerator, denominator) = (m_adminPercent.num, m_adminPercent.den);
499   }
500 
501   function referrer1Percent() public view returns(uint numerator, uint denominator) {
502     (numerator, denominator) = (m_refPercent1.num, m_refPercent1.den);
503   }
504   
505   function referrer2Percent() public view returns(uint numerator, uint denominator) {
506     (numerator, denominator) = (m_refPercent2.num, m_refPercent2.den);
507   }
508   
509   function stats(uint date) public view returns(uint invested, uint investors) {
510     (invested, investors) = m_investors.stats(date);
511   }
512 
513   function investorInfo(address addr) public view returns(uint value, uint paymentTime, uint refsCount, uint refBonus, bool isReferral) {
514     (value, paymentTime, refsCount, refBonus) = m_investors.investorBaseInfo(addr);
515     isReferral = m_referrals[addr].notZero();
516   }
517   
518   function bestInvestorInfo() public view returns(uint invested, address addr) {
519     (invested, addr) = m_investors.getBestInvestor();
520   }
521   
522   function bestPromouterInfo() public view returns(uint refs, address addr) {
523     (refs, addr) = m_investors.getBestPromouter();
524   }
525   
526   function _getMyDividents(bool withoutThrow) private {
527     // check investor info
528     InvestorsStorage.investor memory investor = getMemInvestor(msg.sender);
529     if(investor.keyIndex <= 0){
530         if(withoutThrow){
531             return;
532         }
533         
534         revert("sender is not investor");
535     }
536 
537     // calculate days after latest payment
538     uint256 daysAfter = now.sub(investor.paymentTime).div(dividendsPeriod);
539     if(daysAfter <= 0){
540         if(withoutThrow){
541             return;
542         }
543         
544         revert("the latest payment was earlier than dividents period");
545     }
546     assert(m_investors.setPaymentTime(msg.sender, now));
547 
548     // check enough eth 
549     uint value = m_dividendsPercent.mul(investor.value) * daysAfter;
550     if (address(this).balance < value + investor.refBonus) {
551       nextWave();
552       return;
553     }
554 
555     // send dividends and ref bonus
556     if (investor.refBonus > 0) {
557       assert(m_investors.setRefBonus(msg.sender, 0));
558       sendDividendsWithRefBonus(msg.sender, value, investor.refBonus);
559     } else {
560       sendDividends(msg.sender, value);
561     }      
562   }
563   
564   function getMyDividends() public balanceChanged {
565     _getMyDividents(false);
566   }
567 
568   function doInvest(address ref) public payable balanceChanged {
569     require(msg.value >= minInvesment, "msg.value must be >= minInvesment");
570     require(address(this).balance <= maxBalance, "the contract eth balance limit");
571 
572     uint value = msg.value;
573     // ref system works only once for sender-referral
574     if (!m_referrals[msg.sender].notZero()) {
575       // level 1
576       if (notZeroNotSender(ref) && m_investors.contains(ref)) {
577         uint reward = m_refPercent1.mul(value);
578         assert(m_investors.addRefBonusWithRefs(ref, reward)); // referrer 1 bonus
579         m_referrals[msg.sender] = ref;
580         value = m_dividendsPercent.add(value); // referral bonus
581         emit LogNewReferral(msg.sender, now, value); 
582         // level 2
583         if (notZeroNotSender(m_referrals[ref]) && m_investors.contains(m_referrals[ref]) && ref != m_referrals[ref]) { 
584           reward = m_refPercent2.mul(value);
585           assert(m_investors.addRefBonus(m_referrals[ref], reward)); // referrer 2 bonus
586         }
587       }else{
588         InvestorsStorage.bestAddress memory bestInvestor = getMemBestInvestor();
589         InvestorsStorage.bestAddress memory bestPromouter = getMemBestPromouter();
590         if(notZeroNotSender(bestInvestor.addr)){
591           assert(m_investors.addRefBonus(bestInvestor.addr, m_refPercent1.mul(value) )); // referrer 1 bonus
592           m_referrals[msg.sender] = bestInvestor.addr;
593         }
594         if(notZeroNotSender(bestPromouter.addr)){
595           assert(m_investors.addRefBonus(bestPromouter.addr, m_refPercent2.mul(value) )); // referrer 2 bonus
596           m_referrals[msg.sender] = bestPromouter.addr;
597         }
598       }
599       
600       if(notZeroNotSender(adtransfers[msg.sender]) && m_investors.contains(adtransfers[msg.sender])){
601           assert(m_investors.addRefBonus(adtransfers[msg.sender], m_adBonus.mul(msg.value) )); // advertise transfer bonud
602       }
603     }
604 
605     _getMyDividents(true);
606 
607     // commission
608     adminAddr.transfer(m_adminPercent.mul(msg.value));
609     
610     DT.DateTime memory dt = parseTimestamp(now);
611     uint today = dt.year.uintToString().strConcat((dt.month<10 ? "0":""), dt.month.uintToString(), (dt.day<10 ? "0":""), dt.day.uintToString()).stringToUint();
612     
613     // write to investors storage
614     if (m_investors.contains(msg.sender)) {
615       assert(m_investors.addValue(msg.sender, value));
616       m_investors.updateStats(today, value, 0);
617     } else {
618       assert(m_investors.insert(msg.sender, value));
619       m_investors.updateStats(today, value, 1);
620       emit LogNewInvestor(msg.sender, now, value); 
621     }
622     
623     assert(m_investors.setPaymentTime(msg.sender, now));
624 
625     emit LogNewInvesment(msg.sender, now, value);   
626     totalInvestments++;
627     totalInvested += msg.value;
628   }
629 
630 
631   function getMemInvestor(address addr) internal view returns(InvestorsStorage.investor) {
632     (uint a, uint b, uint c, uint d, uint e) = m_investors.investorFullInfo(addr);
633     return InvestorsStorage.investor(a, b, c, d, e);
634   }
635   
636   function getMemBestInvestor() internal view returns(InvestorsStorage.bestAddress) {
637     (uint value, address addr) = m_investors.getBestInvestor();
638     return InvestorsStorage.bestAddress(value, addr);
639   }
640   
641   function getMemBestPromouter() internal view returns(InvestorsStorage.bestAddress) {
642     (uint value, address addr) = m_investors.getBestPromouter();
643     return InvestorsStorage.bestAddress(value, addr);
644   }
645 
646   function notZeroNotSender(address addr) internal view returns(bool) {
647     return addr.notZero() && addr != msg.sender;
648   }
649 
650   function sendDividends(address addr, uint value) private {
651     if (addr.send(value)) emit LogPayDividends(addr, now, value); 
652   }
653 
654   function sendDividendsWithRefBonus(address addr, uint value,  uint refBonus) private {
655     if (addr.send(value+refBonus)) {
656       emit LogPayDividends(addr, now, value);
657       emit LogPayReferrerBonus(addr, now, refBonus);
658     }
659   }
660 
661   function nextWave() private {
662     m_investors = new InvestorsStorage();
663     totalInvestments = 0;
664     waveStartup = now;
665     m_nextWave = false;
666     emit LogNextWave(now);
667   }
668 }
669 
670 
671 library SafeMath {
672   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
673     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
674     // benefit is lost if 'b' is also tested.
675     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
676     if (_a == 0) {
677       return 0;
678     }
679 
680     uint256 c = _a * _b;
681     require(c / _a == _b);
682 
683     return c;
684   }
685 
686   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
687     require(_b > 0); // Solidity only automatically asserts when dividing by 0
688     uint256 c = _a / _b;
689     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
690 
691     return c;
692   }
693 
694   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
695     require(_b <= _a);
696     uint256 c = _a - _b;
697 
698     return c;
699   }
700 
701   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
702     uint256 c = _a + _b;
703     require(c >= _a);
704 
705     return c;
706   }
707 
708   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
709     require(b != 0);
710     return a % b;
711   }
712 }
713 
714 library Percent {
715   // Solidity automatically throws when dividing by 0
716   struct percent {
717     uint num;
718     uint den;
719   }
720   function mul(percent storage p, uint a) internal view returns (uint) {
721     if (a == 0) {
722       return 0;
723     }
724     return a*p.num/p.den;
725   }
726 
727   function div(percent storage p, uint a) internal view returns (uint) {
728     return a/p.num*p.den;
729   }
730 
731   function sub(percent storage p, uint a) internal view returns (uint) {
732     uint b = mul(p, a);
733     if (b >= a) return 0;
734     return a - b;
735   }
736 
737   function add(percent storage p, uint a) internal view returns (uint) {
738     return a + mul(p, a);
739   }
740 }
741 
742 library Zero {
743   function requireNotZero(uint a) internal pure {
744     require(a != 0, "require not zero");
745   }
746 
747   function requireNotZero(address addr) internal pure {
748     require(addr != address(0), "require not zero address");
749   }
750 
751   function notZero(address addr) internal pure returns(bool) {
752     return !(addr == address(0));
753   }
754 
755   function isZero(address addr) internal pure returns(bool) {
756     return addr == address(0);
757   }
758 }
759 
760 library ToAddress {
761   function toAddr(uint source) internal pure returns(address) {
762     return address(source);
763   }
764 
765   function toAddr(bytes source) internal pure returns(address addr) {
766     assembly { addr := mload(add(source,0x14)) }
767     return addr;
768   }
769 }
770 
771 library Convert {
772     function stringToUint(string s) internal pure returns (uint) {
773         bytes memory b = bytes(s);
774         uint result = 0;
775         for (uint i = 0; i < b.length; i++) { // c = b[i] was not needed
776             if (b[i] >= 48 && b[i] <= 57) {
777                 result = result * 10 + (uint(b[i]) - 48); // bytes and int are not compatible with the operator -.
778             }
779         }
780         return result; // this was missing
781     }
782     
783     function uintToString(uint v) internal pure returns (string) {
784         uint maxlength = 100;
785         bytes memory reversed = new bytes(maxlength);
786         uint i = 0;
787         while (v != 0) {
788             uint remainder = v % 10;
789             v = v / 10;
790             reversed[i++] = byte(48 + remainder);
791         }
792         bytes memory s = new bytes(i); // i + 1 is inefficient
793         for (uint j = 0; j < i; j++) {
794             s[j] = reversed[i - j - 1]; // to avoid the off-by-one error
795         }
796         string memory str = string(s);  // memory isn't implicitly convertible to storage
797         return str; // this was missing
798     }
799     
800     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string){
801         bytes memory _ba = bytes(_a);
802         bytes memory _bb = bytes(_b);
803         bytes memory _bc = bytes(_c);
804         bytes memory _bd = bytes(_d);
805         bytes memory _be = bytes(_e);
806         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
807         bytes memory babcde = bytes(abcde);
808         uint k = 0;
809         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
810         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
811         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
812         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
813         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
814         return string(babcde);
815     }
816     
817     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
818         return strConcat(_a, _b, _c, _d, "");
819     }
820     
821     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
822         return strConcat(_a, _b, _c, "", "");
823     }
824     
825     function strConcat(string _a, string _b) internal pure returns (string) {
826         return strConcat(_a, _b, "", "", "");
827     }
828 }