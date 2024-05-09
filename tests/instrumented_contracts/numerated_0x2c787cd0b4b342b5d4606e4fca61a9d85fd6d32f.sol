1 pragma solidity 0.4.25;
2 
3 contract Constants {
4     address internal constant OWNER_WALLET_ADDR = address(0x508b828440D72B0De506c86DB79D9E2c19810442);
5     address internal constant COMPANY_WALLET_ADDR = address(0xEE50069c177721fdB06755427Fd19853681E86a2);
6     address internal constant LAST10_WALLET_ADDR = address(0xe7d8Bf9B85EAE450f2153C66cdFDfD31D56750d0);
7     address internal constant FEE_WALLET_ADDR = address(0x6Ba3B9E117F58490eC0e68cf3e48d606C2f2475b);
8     uint internal constant LAST_10_MIN_INVESTMENT = 2 ether;
9 }
10 
11 contract InvestorsStorage {
12     using SafeMath for uint;
13     using Percent for Percent.percent;
14     struct investor {
15         uint keyIndex;
16         uint value;
17         uint paymentTime;
18         uint refs;
19         uint refBonus;
20         uint pendingPayout;
21         uint pendingPayoutTime;
22     }
23     struct recordStats {
24         uint investors;
25         uint invested;
26     }
27     struct itmap {
28         mapping(uint => recordStats) stats;
29         mapping(address => investor) data;
30         address[] keys;
31     }
32     itmap private s;
33 
34     address private owner;
35     
36     Percent.percent private _percent = Percent.percent(1,100);
37 
38     event LogOwnerForInvestorContract(address addr);
39 
40     modifier onlyOwner() {
41         require(msg.sender == owner, "access denied");
42         _;
43     }
44 
45     constructor() public {
46         owner = msg.sender;
47         emit LogOwnerForInvestorContract(msg.sender);
48         s.keys.length++;
49     }
50     
51     function getDividendsPercent(address addr) public view returns(uint num, uint den) {
52         uint amount = s.data[addr].value.add(s.data[addr].refBonus);
53         if(amount <= 10*10**18) { //10 ETH
54             return (15, 1000);
55         } else if(amount <= 50*10**18) { //50 ETH
56             return (16, 1000);
57         } else if(amount <= 100*10**18) { //100 ETH
58             return (17, 1000);
59         } else if(amount <= 300*10**18) { //300 ETH
60             return (185, 10000); //Extra zero for two digits after decimal
61         } else {
62             return (2, 100);
63         }
64     }
65 
66     function insert(address addr, uint value) public onlyOwner returns (bool) {
67         uint keyIndex = s.data[addr].keyIndex;
68         if (keyIndex != 0) return false;
69         s.data[addr].value = value;
70         keyIndex = s.keys.length++;
71         s.data[addr].keyIndex = keyIndex;
72         s.keys[keyIndex] = addr;
73         return true;
74     }
75 
76     function investorFullInfo(address addr) public view returns(uint, uint, uint, uint, uint, uint, uint) {
77         return (
78         s.data[addr].keyIndex,
79         s.data[addr].value,
80         s.data[addr].paymentTime,
81         s.data[addr].refs,
82         s.data[addr].refBonus,
83         s.data[addr].pendingPayout,
84         s.data[addr].pendingPayoutTime
85         );
86     }
87 
88     function investorBaseInfo(address addr) public view returns(uint, uint, uint, uint, uint, uint) {
89         return (
90         s.data[addr].value,
91         s.data[addr].paymentTime,
92         s.data[addr].refs,
93         s.data[addr].refBonus,
94         s.data[addr].pendingPayout,
95         s.data[addr].pendingPayoutTime
96         );
97     }
98 
99     function investorShortInfo(address addr) public view returns(uint, uint) {
100         return (
101         s.data[addr].value,
102         s.data[addr].refBonus
103         );
104     }
105 
106     function addRefBonus(address addr, uint refBonus, uint dividendsPeriod) public onlyOwner returns (bool) {
107         if (s.data[addr].keyIndex == 0) {
108             assert(insert(addr, 0));
109         }
110 
111         uint time;
112         if (s.data[addr].pendingPayoutTime == 0) {
113             time = s.data[addr].paymentTime;
114         } else {
115             time = s.data[addr].pendingPayoutTime;
116         }
117 
118         if(time != 0) {
119             uint value = 0;
120             uint256 daysAfter = now.sub(time).div(dividendsPeriod);
121             if(daysAfter > 0) {
122                 value = _getValueForAddr(addr, daysAfter);
123             }
124             s.data[addr].refBonus += refBonus;
125             uint256 hoursAfter = now.sub(time).mod(dividendsPeriod);
126             if(hoursAfter > 0) {
127                 uint dailyDividends = _getValueForAddr(addr, 1);
128                 uint hourlyDividends = dailyDividends.div(dividendsPeriod).mul(hoursAfter);
129                 value = value.add(hourlyDividends);
130             }
131             if (s.data[addr].pendingPayoutTime == 0) {
132                 s.data[addr].pendingPayout = value;
133             } else {
134                 s.data[addr].pendingPayout = s.data[addr].pendingPayout.add(value);
135             }
136         } else {
137             s.data[addr].refBonus += refBonus;
138             s.data[addr].refs++;
139         }
140         assert(setPendingPayoutTime(addr, now));
141         return true;
142     }
143 
144     function _getValueForAddr(address addr, uint daysAfter) internal returns (uint value) {
145         (uint num, uint den) = getDividendsPercent(addr);
146         _percent = Percent.percent(num, den);
147         value = _percent.mul(s.data[addr].value.add(s.data[addr].refBonus)) * daysAfter;
148     }
149 
150     function addRefBonusWithRefs(address addr, uint refBonus, uint dividendsPeriod) public onlyOwner returns (bool) {
151         if (s.data[addr].keyIndex == 0) {
152             assert(insert(addr, 0));
153         }
154 
155         uint time;
156         if (s.data[addr].pendingPayoutTime == 0) {
157             time = s.data[addr].paymentTime;
158         } else {
159             time = s.data[addr].pendingPayoutTime;
160         }
161 
162         if(time != 0) {
163             uint value = 0;
164             uint256 daysAfter = now.sub(time).div(dividendsPeriod);
165             if(daysAfter > 0) {
166                 value = _getValueForAddr(addr, daysAfter);
167             }
168             s.data[addr].refBonus += refBonus;
169             s.data[addr].refs++;
170             uint256 hoursAfter = now.sub(time).mod(dividendsPeriod);
171             if(hoursAfter > 0) {
172                 uint dailyDividends = _getValueForAddr(addr, 1);
173                 uint hourlyDividends = dailyDividends.div(dividendsPeriod).mul(hoursAfter);
174                 value = value.add(hourlyDividends);
175             }
176             if (s.data[addr].pendingPayoutTime == 0) {
177                 s.data[addr].pendingPayout = value;
178             } else {
179                 s.data[addr].pendingPayout = s.data[addr].pendingPayout.add(value);
180             }
181         } else {
182             s.data[addr].refBonus += refBonus;
183             s.data[addr].refs++;
184         }
185         assert(setPendingPayoutTime(addr, now));
186         return true;
187     }
188 
189     function addValue(address addr, uint value) public onlyOwner returns (bool) {
190         if (s.data[addr].keyIndex == 0) return false;
191         s.data[addr].value += value;       
192         return true;
193     }
194 
195     function updateStats(uint dt, uint invested, uint investors) public {
196         s.stats[dt].invested += invested;
197         s.stats[dt].investors += investors;
198     }
199     
200     function stats(uint dt) public view returns (uint invested, uint investors) {
201         return ( 
202         s.stats[dt].invested,
203         s.stats[dt].investors
204         );
205     }
206 
207     function setPaymentTime(address addr, uint paymentTime) public onlyOwner returns (bool) {
208         if (s.data[addr].keyIndex == 0) return false;
209         s.data[addr].paymentTime = paymentTime;
210         return true;
211     }
212 
213     function setPendingPayoutTime(address addr, uint payoutTime) public onlyOwner returns (bool) {
214         if (s.data[addr].keyIndex == 0) return false;
215         s.data[addr].pendingPayoutTime = payoutTime;
216         return true;
217     }
218 
219     function setPendingPayout(address addr, uint payout) public onlyOwner returns (bool) {
220         if (s.data[addr].keyIndex == 0) return false;
221         s.data[addr].pendingPayout = payout;
222         return true;
223     }
224     
225     function contains(address addr) public view returns (bool) {
226         return s.data[addr].keyIndex > 0;
227     }
228 
229     function size() public view returns (uint) {
230         return s.keys.length;
231     }
232 
233     function iterStart() public pure returns (uint) {
234         return 1;
235     }
236 }
237 
238 contract DT {
239     struct DateTime {
240         uint16 year;
241         uint8 month;
242         uint8 day;
243         uint8 hour;
244         uint8 minute;
245         uint8 second;
246         uint8 weekday;
247     }
248 
249     uint private constant DAY_IN_SECONDS = 86400;
250     uint private constant YEAR_IN_SECONDS = 31536000;
251     uint private constant LEAP_YEAR_IN_SECONDS = 31622400;
252 
253     uint16 private constant ORIGIN_YEAR = 1970;
254 
255     function isLeapYear(uint16 year) internal pure returns (bool) {
256         if (year % 4 != 0) {
257             return false;
258         }
259         if (year % 100 != 0) {
260             return true;
261         }
262         if (year % 400 != 0) {
263             return false;
264         }
265         return true;
266     }
267 
268     function leapYearsBefore(uint year) internal pure returns (uint) {
269         year -= 1;
270         return year / 4 - year / 100 + year / 400;
271     }
272 
273     function getDaysInMonth(uint8 month, uint16 year) internal pure returns (uint8) {
274         if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
275             return 31;
276         } else if (month == 4 || month == 6 || month == 9 || month == 11) {
277             return 30;
278         } else if (isLeapYear(year)) {
279             return 29;
280         } else {
281             return 28;
282         }
283     }
284 
285     function parseTimestamp(uint timestamp) internal pure returns (DateTime dt) {
286         uint secondsAccountedFor = 0;
287         uint buf;
288         uint8 i;
289 
290         // Year
291         dt.year = getYear(timestamp);
292         buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
293 
294         secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
295         secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
296 
297         // Month
298         uint secondsInMonth;
299         for (i = 1; i <= 12; i++) {
300             secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
301             if (secondsInMonth + secondsAccountedFor > timestamp) {
302                 dt.month = i;
303                 break;
304             }
305             secondsAccountedFor += secondsInMonth;
306         }
307 
308         // Day
309         for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
310             if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
311                 dt.day = i;
312                 break;
313             }
314             secondsAccountedFor += DAY_IN_SECONDS;
315         }
316     }
317 
318         
319     function getYear(uint timestamp) internal pure returns (uint16) {
320         uint secondsAccountedFor = 0;
321         uint16 year;
322         uint numLeapYears;
323 
324         // Year
325         year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
326         numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
327 
328         secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
329         secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
330 
331         while (secondsAccountedFor > timestamp) {
332             if (isLeapYear(uint16(year - 1))) {
333                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
334             }
335             else {
336                 secondsAccountedFor -= YEAR_IN_SECONDS;
337             }
338             year -= 1;
339         }
340         return year;
341     }
342 
343     function getMonth(uint timestamp) internal pure returns (uint8) {
344         return parseTimestamp(timestamp).month;
345     }
346 
347     function getDay(uint timestamp) internal pure returns (uint8) {
348         return parseTimestamp(timestamp).day;
349     }
350 }
351 
352 contract _200eth is DT, Constants {
353     using Percent for Percent.percent;
354     using SafeMath for uint;
355     using Zero for *;
356     using ToAddress for *;
357     using Convert for *;
358 
359     // investors storage - iterable map;
360     InvestorsStorage private m_investors = new InvestorsStorage();
361     mapping(address => address) public m_referrals;
362     mapping(address => bool) public m_isInvestor;
363     bool public m_nextWave = false;
364 
365     // last 10 storage who's investment >= 2 ether
366     struct Last10Struct {
367         uint value;
368         uint index;
369     }
370     address[] private m_last10InvestorAddr;
371     mapping(address => Last10Struct) private m_last10Investor;
372 
373     // automatically generates getters
374     address public ownerAddr;
375     uint public totalInvestments = 0;
376     uint public totalInvested = 0;
377     uint public constant minInvesment = 10 finney; // 0.01 eth
378     uint public constant dividendsPeriod = 24 hours; //24 hours
379     uint private gasFee = 0;
380     uint private last10 = 0;
381 
382     //Pyramid Coin instance required to send dividends to coin holders.
383     E2D public e2d;
384 
385     // percents 
386     Percent.percent private m_companyPercent = Percent.percent(10, 100); // 10/100*100% = 10%
387     Percent.percent private m_refPercent1 = Percent.percent(3, 100); // 3/100*100% = 3%
388     Percent.percent private m_refPercent2 = Percent.percent(2, 100); // 2/100*100% = 2%
389     Percent.percent private m_fee = Percent.percent(1, 100); // 1/100*100% = 1%
390     Percent.percent private m_coinHolders = Percent.percent(5, 100); // 5/100*100% = 5%
391     Percent.percent private m_last10 = Percent.percent(4, 100); // 4/100*100% = 4%
392     Percent.percent private _percent = Percent.percent(1,100);
393 
394     // more events for easy read from blockchain
395     event LogNewInvestor(address indexed addr, uint when, uint value);
396     event LogNewInvesment(address indexed addr, uint when, uint value);
397     event LogNewReferral(address indexed addr, uint when, uint value);
398     event LogPayDividends(address indexed addr, uint when, uint value);
399     event LogBalanceChanged(uint when, uint balance);
400     event LogNextWave(uint when);
401     event LogPayLast10(address addr, uint percent, uint amount);
402 
403     modifier balanceChanged {
404         _;
405         emit LogBalanceChanged(now, address(this).balance.sub(last10).sub(gasFee));
406     }
407 
408     constructor(address _tokenAddress) public {
409         ownerAddr = OWNER_WALLET_ADDR;
410         e2d = E2D(_tokenAddress);
411         setup();
412     }
413 
414     function isContract(address _addr) private view returns (bool isWalletAddress){
415         uint32 size;
416         assembly{
417             size := extcodesize(_addr)
418         }
419         return (size > 0);
420     }
421 
422     function setup() internal {
423         m_investors = new InvestorsStorage();
424         totalInvestments = 0;
425         totalInvested = 0;
426         gasFee = 0;
427         last10 = 0;
428         for (uint i = 0; i < m_last10InvestorAddr.length; i++) {
429             delete m_last10Investor[m_last10InvestorAddr[i]];
430         }
431         m_last10InvestorAddr.length = 1;
432     }
433 
434     // start the next round of game only after previous is completed.
435     function startNewWave() public {
436         require(m_nextWave == true, "Game is not stopped yet.");
437         require(msg.sender == ownerAddr, "Only Owner can call this function");
438         m_nextWave = false;
439     }
440 
441     function() public payable {
442         // investor get him dividends
443         if (msg.value == 0) {
444             getMyDividends();
445             return;
446         }
447         // sender do invest
448         address refAddr = msg.data.toAddr();
449         doInvest(refAddr);
450     }
451 
452     function investorsNumber() public view returns(uint) {
453         return m_investors.size() - 1;
454         // -1 because see InvestorsStorage constructor where keys.length++ 
455     }
456 
457     function balanceETH() public view returns(uint) {
458         return address(this).balance.sub(last10).sub(gasFee);
459     }
460 
461     function dividendsPercent() public view returns(uint numerator, uint denominator) {
462         (uint num, uint den) = m_investors.getDividendsPercent(msg.sender);
463         (numerator, denominator) = (num,den);
464     }
465 
466     function companyPercent() public view returns(uint numerator, uint denominator) {
467         (numerator, denominator) = (m_companyPercent.num, m_companyPercent.den);
468     }
469 
470     function coinHolderPercent() public view returns(uint numerator, uint denominator) {
471         (numerator, denominator) = (m_coinHolders.num, m_coinHolders.den);
472     }
473 
474     function last10Percent() public view returns(uint numerator, uint denominator) {
475         (numerator, denominator) = (m_last10.num, m_last10.den);
476     }
477 
478     function feePercent() public view returns(uint numerator, uint denominator) {
479         (numerator, denominator) = (m_fee.num, m_fee.den);
480     }
481 
482     function referrer1Percent() public view returns(uint numerator, uint denominator) {
483         (numerator, denominator) = (m_refPercent1.num, m_refPercent1.den);
484     }
485 
486     function referrer2Percent() public view returns(uint numerator, uint denominator) {
487         (numerator, denominator) = (m_refPercent2.num, m_refPercent2.den);
488     }
489 
490     function stats(uint date) public view returns(uint invested, uint investors) {
491         (invested, investors) = m_investors.stats(date);
492     }
493 
494     function last10Addr() public view returns(address[]) {
495         return m_last10InvestorAddr;
496     }
497 
498     function last10Info(address addr) public view returns(uint value, uint index) {
499         return (
500             m_last10Investor[addr].value,
501             m_last10Investor[addr].index
502         );
503     }
504 
505     function investorInfo(address addr) public view returns(uint value, uint paymentTime, uint refsCount, uint refBonus,
506      uint pendingPayout, uint pendingPayoutTime, bool isReferral, uint dividends) {
507         (value, paymentTime, refsCount, refBonus, pendingPayout, pendingPayoutTime) = m_investors.investorBaseInfo(addr);
508         isReferral = m_referrals[addr].notZero();
509         dividends = checkDividends(addr);
510     }
511 
512     function checkDividends(address addr) internal view returns (uint) {
513         InvestorsStorage.investor memory investor = getMemInvestor(addr);
514         if(investor.keyIndex <= 0){
515             return 0;
516         }
517         uint256 time;
518         uint256 value = 0;
519         if(investor.pendingPayoutTime == 0) {
520             time = investor.paymentTime;
521         } else {
522             time = investor.pendingPayoutTime;
523             value = investor.pendingPayout;
524         }
525         // calculate days after payout time
526         uint256 daysAfter = now.sub(time).div(dividendsPeriod);
527         if(daysAfter > 0){
528             uint256 totalAmount = investor.value.add(investor.refBonus);
529             (uint num, uint den) = m_investors.getDividendsPercent(addr);
530             value = value.add((totalAmount*num/den) * daysAfter);
531         }
532         return value;
533     }
534 
535     function _getMyDividents(bool withoutThrow) private {
536         address addr = msg.sender;
537         require(!isContract(addr),"msg.sender must wallet");
538         // check investor info
539         InvestorsStorage.investor memory investor = getMemInvestor(addr);
540         if(investor.keyIndex <= 0){
541             if(withoutThrow){
542                 return;
543             }
544             revert("sender is not investor");
545         }
546         uint256 time;
547         uint256 value = 0;
548         if(investor.pendingPayoutTime == 0) {
549             time = investor.paymentTime;
550         } else {
551             time = investor.pendingPayoutTime;
552             value = investor.pendingPayout;
553         }
554 
555         // calculate days after payout time
556         uint256 daysAfter = now.sub(time).div(dividendsPeriod);
557         if(daysAfter > 0){
558             uint256 totalAmount = investor.value.add(investor.refBonus);
559             (uint num, uint den) = m_investors.getDividendsPercent(addr);
560             value = value.add((totalAmount*num/den) * daysAfter);
561         }
562         if(value == 0) {
563             if(withoutThrow){
564                 return;
565             }
566             revert("the latest payment was earlier than dividents period");
567         } else {
568             if (checkBalanceState(addr, value)) {
569                 return;
570             }
571         }
572 
573         assert(m_investors.setPaymentTime(msg.sender, now));
574 
575         assert(m_investors.setPendingPayoutTime(msg.sender, 0));
576 
577         assert(m_investors.setPendingPayout(msg.sender, 0));
578 
579         sendDividends(msg.sender, value);
580     }
581 
582     function checkBalanceState(address addr, uint value) private returns(bool) {
583         uint checkBal = address(this).balance.sub(last10).sub(gasFee);
584         if(checkBal < value) {
585             sendDividends(addr, checkBal);
586             return true;
587         }
588         return false;
589     }
590 
591     function getMyDividends() public balanceChanged {
592         _getMyDividents(false);
593     }
594 
595     function doInvest(address _ref) public payable balanceChanged {
596         require(!isContract(msg.sender),"msg.sender must wallet address");
597         require(msg.value >= minInvesment, "msg.value must be >= minInvesment");
598         require(!m_nextWave, "no further investment in this pool");
599         uint value = msg.value;
600         //ref system works only once for sender-referral
601         if ((!m_isInvestor[msg.sender] && !m_referrals[msg.sender].notZero()) || 
602         (m_isInvestor[msg.sender] && m_referrals[msg.sender].notZero())) {
603             address ref = m_referrals[msg.sender].notZero() ? m_referrals[msg.sender] : _ref;
604             // level 1
605             if(notZeroNotSender(ref) && m_isInvestor[ref]) {
606                 // referrer 1 bonus
607                 uint reward = m_refPercent1.mul(value);
608                 if(m_referrals[msg.sender].notZero()) {
609                     assert(m_investors.addRefBonus(ref, reward, dividendsPeriod));
610                 } else {
611                     assert(m_investors.addRefBonusWithRefs(ref, reward, dividendsPeriod));
612                     m_referrals[msg.sender] = ref;
613                 }
614                 emit LogNewReferral(msg.sender, now, value); 
615                 // level 2
616                 if (notZeroNotSender(m_referrals[ref]) && m_isInvestor[m_referrals[ref]] && ref != m_referrals[ref]) { 
617                     reward = m_refPercent2.mul(value);
618                     assert(m_investors.addRefBonus(m_referrals[ref], reward, dividendsPeriod)); // referrer 2 bonus
619                 }
620             }
621         }
622 
623         checkLast10(value);
624 
625         // company commission
626         COMPANY_WALLET_ADDR.transfer(m_companyPercent.mul(value));
627          // coin holder commission
628         e2d.payDividends.value(m_coinHolders.mul(value))();
629          // reserved for last 10 distribution
630         last10 = last10.add(m_last10.mul(value));
631         //reserved for gas fee
632         gasFee = gasFee.add(m_fee.mul(value));
633 
634         _getMyDividents(true);
635 
636         DT.DateTime memory dt = parseTimestamp(now);
637         uint today = dt.year.uintToString().strConcat((dt.month<10 ? "0":""), dt.month.uintToString(), (dt.day<10 ? "0":""), dt.day.uintToString()).stringToUint();
638 
639         //write to investors storage
640         if (m_investors.contains(msg.sender)) {
641             assert(m_investors.addValue(msg.sender, value));
642             m_investors.updateStats(today, value, 0);
643         } else {
644             assert(m_investors.insert(msg.sender, value));
645             m_isInvestor[msg.sender] = true;
646             m_investors.updateStats(today, value, 1);
647             emit LogNewInvestor(msg.sender, now, value); 
648         }
649 
650         assert(m_investors.setPaymentTime(msg.sender, now));
651 
652         emit LogNewInvesment(msg.sender, now, value);   
653         totalInvestments++;
654         totalInvested += msg.value;
655     }
656 
657     function checkLast10(uint value) internal {
658         //check if value is >= 2 then add to last 10 
659         if(value >= LAST_10_MIN_INVESTMENT) {
660             if(m_last10Investor[msg.sender].index != 0) {
661                 uint index = m_last10Investor[msg.sender].index;
662                 removeFromLast10AtIndex(index);
663             } else if(m_last10InvestorAddr.length == 11) {
664                 delete m_last10Investor[m_last10InvestorAddr[1]];
665                 removeFromLast10AtIndex(1);
666             }
667             m_last10InvestorAddr.push(msg.sender);
668             m_last10Investor[msg.sender].index = m_last10InvestorAddr.length - 1;
669             m_last10Investor[msg.sender].value = value;
670         }
671     }
672 
673     function removeFromLast10AtIndex(uint index) internal {
674         for (uint i = index; i < m_last10InvestorAddr.length-1; i++){
675             m_last10InvestorAddr[i] = m_last10InvestorAddr[i+1];
676             m_last10Investor[m_last10InvestorAddr[i]].index = i;
677         }
678         delete m_last10InvestorAddr[m_last10InvestorAddr.length-1];
679         m_last10InvestorAddr.length--;
680     }
681 
682     function getMemInvestor(address addr) internal view returns(InvestorsStorage.investor) {
683         (uint a, uint b, uint c, uint d, uint e, uint f, uint g) = m_investors.investorFullInfo(addr);
684         return InvestorsStorage.investor(a, b, c, d, e, f, g);
685     }
686 
687     function notZeroNotSender(address addr) internal view returns(bool) {
688         return addr.notZero() && addr != msg.sender;
689     }
690 
691     function sendDividends(address addr, uint value) private {
692         if (addr.send(value)) {
693             emit LogPayDividends(addr, now, value);
694             if(address(this).balance.sub(gasFee).sub(last10) <= 0.005 ether) {
695                 nextWave();
696                 return;
697             }
698         }
699     }
700 
701     function sendToLast10() private {
702         uint lastPos = m_last10InvestorAddr.length - 1;
703         uint index = 0;
704         uint distributed = 0;
705         for (uint pos = lastPos; pos > 0 ; pos--) {
706             _percent = getPercentByPosition(index);
707             uint amount = _percent.mul(last10);
708             if( (!isContract(m_last10InvestorAddr[pos]))){
709                 m_last10InvestorAddr[pos].transfer(amount);
710                 emit LogPayLast10(m_last10InvestorAddr[pos], _percent.num, amount);
711                 distributed = distributed.add(amount);
712             }
713             index++;
714         }
715 
716         last10 = last10.sub(distributed);
717         //check if amount is left in last10 and transfer 
718         if(last10 > 0) {
719             LAST10_WALLET_ADDR.transfer(last10);
720             last10 = 0;
721         }
722     }
723 
724     function getPercentByPosition(uint position) internal pure returns(Percent.percent) {
725         if(position == 0) {
726             return Percent.percent(40, 100); // 40%
727         } else if(position == 1) {
728             return Percent.percent(25, 100); // 25%
729         } else if(position == 2) {
730             return Percent.percent(15, 100); // 15%
731         } else if(position == 3) {
732             return Percent.percent(8, 100); // 8%
733         } else if(position == 4) {
734             return Percent.percent(5, 100); // 5%
735         } else if(position == 5) {
736             return Percent.percent(2, 100); // 2%
737         } else if(position == 6) {
738             return Percent.percent(2, 100); // 2%
739         } else if(position == 7) {
740             return Percent.percent(15, 1000); // 1.5%
741         } else if(position == 8) {
742             return Percent.percent(1, 100); // 1%
743         } else if(position == 9) {
744             return Percent.percent(5, 1000); // 0.5%
745         }
746     }
747 
748     function nextWave() private {
749         if(m_nextWave) {
750             return; 
751         }
752         m_nextWave = true;
753         sendToLast10();
754         //send gas fee to wallet
755         FEE_WALLET_ADDR.transfer(gasFee);
756         //send remaining contract balance to company wallet
757         COMPANY_WALLET_ADDR.transfer(address(this).balance);
758         setup();
759         emit LogNextWave(now);
760     }
761 }
762 
763 library Percent {
764   // Solidity automatically throws when dividing by 0
765     struct percent {
766         uint num;
767         uint den;
768     }
769     function mul(percent storage p, uint a) internal view returns (uint) {
770         if (a == 0) {
771             return 0;
772         }
773         return a*p.num/p.den;
774     }
775     
776     function div(percent storage p, uint a) internal view returns (uint) {
777         return a/p.num*p.den;
778     }
779 
780     function sub(percent storage p, uint a) internal view returns (uint) {
781         uint b = mul(p, a);
782         if (b >= a) return 0;
783         return a - b;
784     }
785 
786     function add(percent storage p, uint a) internal view returns (uint) {
787         return a + mul(p, a);
788     }
789 }
790 
791 library Zero {
792     function requireNotZero(uint a) internal pure {
793         require(a != 0, "require not zero");
794     }
795 
796     function requireNotZero(address addr) internal pure {
797         require(addr != address(0), "require not zero address");
798     }
799 
800     function notZero(address addr) internal pure returns(bool) {
801         return !(addr == address(0));
802     }
803 
804     function isZero(address addr) internal pure returns(bool) {
805         return addr == address(0);
806     }
807 }
808 
809 library ToAddress {
810     function toAddr(uint source) internal pure returns(address) {
811         return address(source);
812     }
813 
814     function toAddr(bytes source) internal pure returns(address addr) {
815         assembly { addr := mload(add(source,0x14)) }
816         return addr;
817     }
818 }
819 
820 library Convert {
821     function stringToUint(string s) internal pure returns (uint) {
822         bytes memory b = bytes(s);
823         uint result = 0;
824         for (uint i = 0; i < b.length; i++) { // c = b[i] was not needed
825             if (b[i] >= 48 && b[i] <= 57) {
826                 result = result * 10 + (uint(b[i]) - 48); // bytes and int are not compatible with the operator -.
827             }
828         }
829         return result; // this was missing
830     }
831 
832     function uintToString(uint v) internal pure returns (string) {
833         uint maxlength = 100;
834         bytes memory reversed = new bytes(maxlength);
835         uint i = 0;
836         while (v != 0) {
837             uint remainder = v % 10;
838             v = v / 10;
839             reversed[i++] = byte(48 + remainder);
840         }
841         bytes memory s = new bytes(i); // i + 1 is inefficient
842         for (uint j = 0; j < i; j++) {
843             s[j] = reversed[i - j - 1]; // to avoid the off-by-one error
844         }
845         string memory str = string(s);  // memory isn't implicitly convertible to storage
846         return str; // this was missing
847     }
848 
849     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string){
850         bytes memory _ba = bytes(_a);
851         bytes memory _bb = bytes(_b);
852         bytes memory _bc = bytes(_c);
853         bytes memory _bd = bytes(_d);
854         bytes memory _be = bytes(_e);
855         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
856         bytes memory babcde = bytes(abcde);
857         uint k = 0;
858         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
859         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
860         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
861         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
862         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
863         return string(babcde);
864     }
865     
866     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
867         return strConcat(_a, _b, _c, _d, "");
868     }
869     
870     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
871         return strConcat(_a, _b, _c, "", "");
872     }
873     
874     function strConcat(string _a, string _b) internal pure returns (string) {
875         return strConcat(_a, _b, "", "", "");
876     }
877 }
878 
879 contract E2D {
880     /*=================================
881     =            MODIFIERS            =
882     =================================*/
883     // only people with tokens
884     modifier onlyBagholders() {
885         require(myTokens() > 0);
886         _;
887     }
888 
889     // only people with profits
890     modifier onlyStronghands() {
891         require(myDividends() > 0);
892         _;
893     }
894 
895     // owner can:
896     // -> change the name of the contract
897     // -> change the name of the token
898     // they CANNOT:
899     // -> take funds
900     // -> disable withdrawals
901     // -> kill the contract
902     // -> change the price of tokens
903     modifier onlyOwner(){
904         require(ownerAddr == msg.sender || OWNER_ADDRESS_2 == msg.sender, "only owner can perform this!");
905         _;
906     }
907 
908     modifier onlyInitialInvestors(){
909         if(initialState) {
910             require(initialInvestors[msg.sender] == true, "only allowed investor can invest!");
911             _;
912         } else {
913             _;
914         }
915     }
916 
917     /*==============================
918     =            EVENTS            =
919     ==============================*/
920     event onTokenPurchase(
921         address indexed customerAddress,
922         uint256 incomingEthereum,
923         uint256 tokensMinted
924     );
925 
926     event onTokenSell(
927         address indexed customerAddress,
928         uint256 tokensBurned,
929         uint256 ethereumEarned
930     );
931 
932     event onReinvestment(
933         address indexed customerAddress,
934         uint256 ethereumReinvested,
935         uint256 tokensMinted
936     );
937 
938     event onWithdraw(
939         address indexed customerAddress,
940         uint256 ethereumWithdrawn
941     );
942 
943     event onPayDividends(
944         uint256 dividends,
945         uint256 profitPerShare
946     );
947 
948     // ERC20
949     event Transfer(
950         address indexed from,
951         address indexed to,
952         uint256 tokens
953     );
954 
955     /*=====================================
956     =            CONFIGURABLES            =
957     =====================================*/
958     string public name = "E2D";
959     string public symbol = "E2D";
960     uint8 constant public decimals = 18;
961     uint8 constant internal dividendFee_ = 10;
962     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
963     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
964     uint256 constant internal magnitude = 2**64;
965     address constant internal OWNER_ADDRESS = address(0x508b828440D72B0De506c86DB79D9E2c19810442);
966     address constant internal OWNER_ADDRESS_2 = address(0x508b828440D72B0De506c86DB79D9E2c19810442);
967     uint256 constant public INVESTOR_QUOTA = 0.01 ether;
968 
969    /*================================
970     =            DATASETS            =
971     ================================*/
972     // amount of shares for each address (scaled number)
973     mapping(address => uint256) internal tokenBalanceLedger_;
974     mapping(address => int256) internal payoutsTo_;
975     uint256 internal tokenSupply_ = 0;
976     uint256 internal profitPerShare_;
977     uint256 internal totalInvestment_ = 0;
978     uint256 internal totalGameDividends_ = 0;
979 
980     // smart contract owner address (see above on what they can do)
981     address public ownerAddr;
982 
983     // initial investor list who can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
984     mapping(address => bool) public initialInvestors;
985 
986     // when this is set to true, only allowed initialInvestors can purchase tokens.
987     bool public initialState = true;
988 
989     /*=======================================
990     =            PUBLIC FUNCTIONS            =
991     =======================================*/
992     /*
993     * -- APPLICATION ENTRY POINTS --  
994     */
995 
996     constructor() public {
997         // add initialInvestors here
998         ownerAddr = OWNER_ADDRESS;
999         initialInvestors[OWNER_ADDRESS] = true;
1000         initialInvestors[OWNER_ADDRESS_2] = true;
1001     }
1002 
1003     /**
1004      * Converts all incoming ethereum to tokens for the caller
1005      */
1006     function buy() public payable returns(uint256) {
1007         purchaseTokens(msg.value);
1008     }
1009 
1010     /**
1011      * Fallback function to handle ethereum that was send straight to the contract
1012      */
1013     function() public payable {
1014         purchaseTokens(msg.value);
1015     }
1016 
1017     /**
1018      * Converts all of caller's dividends to tokens.
1019      */
1020     function reinvest() public onlyStronghands() {
1021         // fetch dividends
1022         uint256 _dividends = myDividends();
1023 
1024         // pay out the dividends virtually
1025         address _customerAddress = msg.sender;
1026         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
1027 
1028         // dispatch a buy order with the virtualized "withdrawn dividends"
1029         uint256 _tokens = purchaseTokens(_dividends);
1030 
1031         // fire event
1032         emit onReinvestment(_customerAddress, _dividends, _tokens);
1033     }
1034 
1035     /**
1036      * Alias of sell() and withdraw().
1037      */
1038     function exit() public {
1039         // get token count for caller & sell them all
1040         address _customerAddress = msg.sender;
1041         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
1042         if(_tokens > 0) sell(_tokens);
1043 
1044         // lambo delivery service
1045         withdraw();
1046     }
1047 
1048     /**
1049      * Withdraws all of the callers earnings.
1050      */
1051     function withdraw() public onlyStronghands() {
1052         // setup data
1053         address _customerAddress = msg.sender;
1054         uint256 _dividends = myDividends();
1055 
1056         // update dividend tracker
1057         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
1058 
1059         // lambo delivery service
1060         _customerAddress.transfer(_dividends);
1061 
1062         // fire event
1063         emit onWithdraw(_customerAddress, _dividends);
1064     }
1065 
1066     /**
1067      * Liquifies tokens to ethereum.
1068      */
1069     function sell(uint256 _amountOfTokens) public onlyBagholders() {
1070         // setup data
1071         address _customerAddress = msg.sender;
1072         // russian hackers BTFO
1073         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress], "token to sell should be less then balance!");
1074         uint256 _tokens = _amountOfTokens;
1075         uint256 _ethereum = tokensToEthereum_(_tokens);
1076         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
1077         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
1078 
1079         // burn the sold tokens
1080         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
1081         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
1082 
1083         // update dividends tracker
1084         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
1085         payoutsTo_[_customerAddress] -= _updatedPayouts;      
1086 
1087         // dividing by zero is a bad idea
1088         if (tokenSupply_ > 0) {
1089             // update the amount of dividends per token
1090             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
1091         }
1092 
1093         // fire event
1094         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
1095     }
1096 
1097     /**
1098      * Transfer tokens from the caller to a new holder.
1099      * Remember, there's a 10% fee here as well.
1100      */
1101     function transfer(address _toAddress, uint256 _amountOfTokens) public onlyBagholders() returns(bool) {
1102         // setup
1103         address _customerAddress = msg.sender;
1104 
1105         // make sure we have the requested tokens
1106         // also disables transfers until adminstrator phase is over
1107         require(!initialState && (_amountOfTokens <= tokenBalanceLedger_[_customerAddress]), "initial state or token > balance!");
1108 
1109         // withdraw all outstanding dividends first
1110         if(myDividends() > 0) withdraw();
1111 
1112         // liquify 10% of the tokens that are transfered
1113         // these are dispersed to shareholders
1114         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
1115         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
1116         uint256 _dividends = tokensToEthereum_(_tokenFee);
1117   
1118         // burn the fee tokens
1119         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
1120 
1121         // exchange tokens
1122         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
1123         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
1124 
1125         // update dividend trackers
1126         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
1127         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
1128 
1129         // disperse dividends among holders
1130         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
1131 
1132         // fire event
1133         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
1134 
1135         // ERC20
1136         return true;
1137     }
1138 
1139     function payDividends() external payable {
1140         uint256 _dividends = msg.value;
1141         require(_dividends > 0, "dividends should be greater then 0!");
1142         // dividing by zero is a bad idea
1143         if (tokenSupply_ > 0) {
1144             // update the amount of dividends per token
1145             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
1146             totalGameDividends_ = SafeMath.add(totalGameDividends_, _dividends);
1147             // fire event
1148             emit onPayDividends(_dividends, profitPerShare_);
1149         }
1150     }
1151 
1152     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
1153     /**
1154      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
1155      */
1156     function disableInitialStage() public onlyOwner() {
1157         require(initialState == true, "initial stage is already false!");
1158         initialState = false;
1159     }
1160 
1161     /**
1162      * In case one of us dies, we need to replace ourselves.
1163      */
1164     function setInitialInvestors(address _addr, bool _status) public onlyOwner() {
1165         initialInvestors[_addr] = _status;
1166     }
1167 
1168     /**
1169      * If we want to rebrand, we can.
1170      */
1171     function setName(string _name) public onlyOwner() {
1172         name = _name;
1173     }
1174 
1175     /**
1176      * If we want to rebrand, we can.
1177      */
1178     function setSymbol(string _symbol) public onlyOwner() {
1179         symbol = _symbol;
1180     }
1181 
1182     /*----------  HELPERS AND CALCULATORS  ----------*/
1183     /**
1184      * Method to view the current Ethereum stored in the contract
1185      * Example: totalEthereumBalance()
1186      */
1187     function totalEthereumBalance() public view returns(uint) {
1188         return address(this).balance;
1189     }
1190 
1191     /**
1192      * Retrieve the total token supply.
1193      */
1194     function totalSupply() public view returns(uint256) {
1195         return tokenSupply_;
1196     }
1197 
1198     /**
1199      * Retrieve the total Investment.
1200      */
1201     function totalInvestment() public view returns(uint256) {
1202         return totalInvestment_;
1203     }
1204 
1205     /**
1206      * Retrieve the total Game Dividends Paid.
1207      */
1208     function totalGameDividends() public view returns(uint256) {
1209         return totalGameDividends_;
1210     }
1211 
1212     /**
1213      * Retrieve the tokens owned by the caller.
1214      */
1215     function myTokens() public view returns(uint256) {
1216         address _customerAddress = msg.sender;
1217         return balanceOf(_customerAddress);
1218     }
1219 
1220     /**
1221      * Retrieve the dividends owned by the caller.
1222      */ 
1223     function myDividends() public view returns(uint256) {
1224         address _customerAddress = msg.sender;
1225         return dividendsOf(_customerAddress) ;
1226     }
1227 
1228     /**
1229      * Retrieve the token balance of any single address.
1230      */
1231     function balanceOf(address _customerAddress) public view returns(uint256) {
1232         return tokenBalanceLedger_[_customerAddress];
1233     }
1234 
1235     /**
1236      * Retrieve the dividend balance of any single address.
1237      */
1238     function dividendsOf(address _customerAddress) public view returns(uint256) {
1239         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
1240     }
1241 
1242     /**
1243      * Return the sell price of 1 individual token.
1244      */
1245     function sellPrice() public view returns(uint256) {
1246         // our calculation relies on the token supply, so we need supply.
1247         if(tokenSupply_ == 0){
1248             return 0;
1249         } else {
1250             uint256 _ethereum = tokensToEthereum_(1e18);
1251             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
1252             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
1253             return _taxedEthereum;
1254         }
1255     }
1256 
1257     /**
1258      * Return the buy price of 1 individual token.
1259      */
1260     function buyPrice() public view returns(uint256) {
1261         // our calculation relies on the token supply, so we need supply.
1262         if(tokenSupply_ == 0){
1263             return tokenPriceInitial_ + tokenPriceIncremental_;
1264         } else {
1265             uint256 _ethereum = tokensToEthereum_(1e18);
1266             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
1267             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
1268             return _taxedEthereum;
1269         }
1270     }
1271 
1272     /**
1273      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
1274      */
1275     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns(uint256) {
1276         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
1277         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
1278         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
1279         return _amountOfTokens;
1280     }
1281 
1282     /**
1283      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
1284      */
1285     function calculateEthereumReceived(uint256 _tokensToSell) public view returns(uint256) {
1286         require(_tokensToSell <= tokenSupply_, "token to sell should be less then total supply!");
1287         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
1288         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
1289         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
1290         return _taxedEthereum;
1291     }
1292 
1293     /*==========================================
1294     =            INTERNAL FUNCTIONS            =
1295     ==========================================*/
1296     function purchaseTokens(uint256 _incomingEthereum) internal onlyInitialInvestors() returns(uint256) {
1297         // data setup
1298         address _customerAddress = msg.sender;
1299         uint256 _dividends = SafeMath.div(_incomingEthereum, dividendFee_);
1300         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _dividends);
1301         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
1302         uint256 _fee = _dividends * magnitude;
1303 
1304         require((_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_)), "token should be > 0!");
1305 
1306         // we can't give people infinite ethereum
1307         if(tokenSupply_ > 0) {
1308 
1309             // add tokens to the pool
1310             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
1311  
1312             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
1313             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
1314 
1315             // calculate the amount of tokens the customer receives over his purchase 
1316             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
1317         } else {
1318             // add tokens to the pool
1319             tokenSupply_ = _amountOfTokens;
1320         }
1321 
1322         totalInvestment_ = SafeMath.add(totalInvestment_, _incomingEthereum);
1323 
1324         // update circulating supply & the ledger address for the customer
1325         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
1326 
1327         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
1328         //really i know you think you do but you don't
1329         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
1330         payoutsTo_[_customerAddress] += _updatedPayouts;
1331 
1332         // disable initial stage if investor quota of 0.01 eth is reached
1333         if(address(this).balance >= INVESTOR_QUOTA) {
1334             initialState = false;
1335         }
1336 
1337         // fire event
1338         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens);
1339 
1340         return _amountOfTokens;
1341     }
1342 
1343     /**
1344      * Calculate Token price based on an amount of incoming ethereum
1345      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
1346      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
1347      */
1348     function ethereumToTokens_(uint256 _ethereum) internal view returns(uint256) {
1349         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
1350         uint256 _tokensReceived = 
1351          (
1352             (
1353                 // underflow attempts BTFO
1354                 SafeMath.sub(
1355                     (sqrt
1356                         (
1357                             (_tokenPriceInitial**2)
1358                             +
1359                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
1360                             +
1361                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
1362                             +
1363                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
1364                         )
1365                     ), _tokenPriceInitial
1366                 )
1367             )/(tokenPriceIncremental_)
1368         )-(tokenSupply_);
1369         return _tokensReceived;
1370     }
1371 
1372     /**
1373      * Calculate token sell value.
1374      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
1375      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
1376      */
1377     function tokensToEthereum_(uint256 _tokens) internal view returns(uint256) {
1378         uint256 tokens_ = (_tokens + 1e18);
1379         uint256 _tokenSupply = (tokenSupply_ + 1e18);
1380         uint256 _etherReceived =
1381         (
1382             // underflow attempts BTFO
1383             SafeMath.sub(
1384                 (
1385                     (
1386                         (
1387                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
1388                         )-tokenPriceIncremental_
1389                     )*(tokens_ - 1e18)
1390                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
1391             )
1392         /1e18);
1393         return _etherReceived;
1394     }
1395 
1396     //This is where all your gas goes, sorry
1397     //Not sorry, you probably only paid 1 gwei
1398     function sqrt(uint x) internal pure returns (uint y) {
1399         uint z = (x + 1) / 2;
1400         y = x;
1401         while (z < y) {
1402             y = z;
1403             z = (x / z + z) / 2;
1404         }
1405     }
1406 }
1407 
1408 /**
1409  * @title SafeMath
1410  * @dev Math operations with safety checks that throw on error
1411  */
1412 library SafeMath {
1413     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
1414     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1415     // benefit is lost if 'b' is also tested.
1416     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1417         if (_a == 0) {
1418             return 0;
1419         }
1420         uint256 c = _a * _b;
1421         require(c / _a == _b);
1422         return c;
1423     }
1424 
1425     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
1426         require(_b > 0); // Solidity only automatically asserts when dividing by 0
1427         uint256 c = _a / _b;
1428         return c;
1429     }
1430 
1431     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
1432         require(_b <= _a);
1433         uint256 c = _a - _b;
1434         return c;
1435     }
1436 
1437     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
1438         uint256 c = _a + _b;
1439         require(c >= _a);
1440         return c;
1441     }
1442 
1443     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1444         require(b != 0);
1445         return a % b;
1446     }
1447 }