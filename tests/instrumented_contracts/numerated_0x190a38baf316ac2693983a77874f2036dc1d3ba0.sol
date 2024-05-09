1 pragma solidity 0.4.25;
2 
3 /**
4 *
5 * Get your 1,11% every day profit with Fortune 111 Contract!
6 * GitHub https://github.com/fortune333/fortune111
7 * Site https://fortune333.online/
8 */
9 
10 
11 library Math {
12 function min(uint a, uint b) internal pure returns(uint) {
13 if (a > b) {
14 return b;
15 }
16 return a;
17 }
18 }
19 
20 
21 library Zero {
22 function requireNotZero(address addr) internal pure {
23 require(addr != address(0), "require not zero address");
24 }
25 
26 function requireNotZero(uint val) internal pure {
27 require(val != 0, "require not zero value");
28 }
29 
30 function notZero(address addr) internal pure returns(bool) {
31 return !(addr == address(0));
32 }
33 
34 function isZero(address addr) internal pure returns(bool) {
35 return addr == address(0);
36 }
37 
38 function isZero(uint a) internal pure returns(bool) {
39 return a == 0;
40 }
41 
42 function notZero(uint a) internal pure returns(bool) {
43 return a != 0;
44 }
45 }
46 
47 
48 library Percent {
49 struct percent {
50 uint num;
51 uint den;
52 }
53 
54 function mul(percent storage p, uint a) internal view returns (uint) {
55 if (a == 0) {
56 return 0;
57 }
58 return a*p.num/p.den;
59 }
60 
61 function div(percent storage p, uint a) internal view returns (uint) {
62 return a/p.num*p.den;
63 }
64 
65 function sub(percent storage p, uint a) internal view returns (uint) {
66 uint b = mul(p, a);
67 if (b >= a) {
68 return 0;
69 }
70 return a - b;
71 }
72 
73 function add(percent storage p, uint a) internal view returns (uint) {
74 return a + mul(p, a);
75 }
76 
77 function toMemory(percent storage p) internal view returns (Percent.percent memory) {
78 return Percent.percent(p.num, p.den);
79 }
80 
81 function mmul(percent memory p, uint a) internal pure returns (uint) {
82 if (a == 0) {
83 return 0;
84 }
85 return a*p.num/p.den;
86 }
87 
88 function mdiv(percent memory p, uint a) internal pure returns (uint) {
89 return a/p.num*p.den;
90 }
91 
92 function msub(percent memory p, uint a) internal pure returns (uint) {
93 uint b = mmul(p, a);
94 if (b >= a) {
95 return 0;
96 }
97 return a - b;
98 }
99 
100 function madd(percent memory p, uint a) internal pure returns (uint) {
101 return a + mmul(p, a);
102 }
103 }
104 
105 
106 library Address {
107 function toAddress(bytes source) internal pure returns(address addr) {
108 assembly { addr := mload(add(source,0x14)) }
109 return addr;
110 }
111 
112 function isNotContract(address addr) internal view returns(bool) {
113 uint length;
114 assembly { length := extcodesize(addr) }
115 return length == 0;
116 }
117 }
118 
119 
120 /**
121 * @title SafeMath
122 * @dev Math operations with safety checks that revert on error
123 */
124 library SafeMath {
125 
126 /**
127 * @dev Multiplies two numbers, reverts on overflow.
128 */
129 function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
130 if (_a == 0) {
131 return 0;
132 }
133 
134 uint256 c = _a * _b;
135 require(c / _a == _b);
136 
137 return c;
138 }
139 
140 /**
141 * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
142 */
143 function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
144 require(_b > 0); // Solidity only automatically asserts when dividing by 0
145 uint256 c = _a / _b;
146 // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
147 
148 return c;
149 }
150 
151 /**
152 * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
153 */
154 function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
155 require(_b <= _a);
156 uint256 c = _a - _b;
157 
158 return c;
159 }
160 
161 /**
162 * @dev Adds two numbers, reverts on overflow.
163 */
164 function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
165 uint256 c = _a + _b;
166 require(c >= _a);
167 
168 return c;
169 }
170 
171 /**
172 * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
173 * reverts when dividing by zero.
174 */
175 function mod(uint256 a, uint256 b) internal pure returns (uint256) {
176 require(b != 0);
177 return a % b;
178 }
179 }
180 
181 
182 contract Accessibility {
183 address private owner;
184 modifier onlyOwner() {
185 require(msg.sender == owner, "access denied");
186 _;
187 }
188 
189 constructor() public {
190 owner = msg.sender;
191 }
192 
193 function disown() internal {
194 delete owner;
195 }
196 }
197 
198 
199 contract Rev1Storage {
200 function investorShortInfo(address addr) public view returns(uint value, uint refBonus);
201 }
202 
203 
204 contract Rev2Storage {
205 function investorInfo(address addr) public view returns(uint investment, uint paymentTime);
206 }
207 
208 
209 library PrivateEntrance {
210 using PrivateEntrance for privateEntrance;
211 using Math for uint;
212 struct privateEntrance {
213 Rev1Storage rev1Storage;
214 Rev2Storage rev2Storage;
215 uint investorMaxInvestment;
216 uint endTimestamp;
217 mapping(address=>bool) hasAccess;
218 }
219 
220 function isActive(privateEntrance storage pe) internal view returns(bool) {
221 return pe.endTimestamp > now;
222 }
223 
224 function maxInvestmentFor(privateEntrance storage pe, address investorAddr) internal view returns(uint) {
225 if (!pe.hasAccess[investorAddr]) {
226 return 0;
227 }
228 
229 (uint maxInvestment, ) = pe.rev1Storage.investorShortInfo(investorAddr);
230 if (maxInvestment == 0) {
231 return 0;
232 }
233 maxInvestment = Math.min(maxInvestment, pe.investorMaxInvestment);
234 
235 (uint currInvestment, ) = pe.rev2Storage.investorInfo(investorAddr);
236 
237 if (currInvestment >= maxInvestment) {
238 return 0;
239 }
240 
241 return maxInvestment-currInvestment;
242 }
243 
244 function provideAccessFor(privateEntrance storage pe, address[] addrs) internal {
245 for (uint16 i; i < addrs.length; i++) {
246 pe.hasAccess[addrs[i]] = true;
247 }
248 }
249 }
250 
251 
252 contract InvestorsStorage is Accessibility {
253 struct Investor {
254 uint investment;
255 uint paymentTime;
256 }
257 uint public size;
258 
259 mapping (address => Investor) private investors;
260 
261 function isInvestor(address addr) public view returns (bool) {
262 return investors[addr].investment > 0;
263 }
264 
265 function investorInfo(address addr) public view returns(uint investment, uint paymentTime) {
266 investment = investors[addr].investment;
267 paymentTime = investors[addr].paymentTime;
268 }
269 
270 function newInvestor(address addr, uint investment, uint paymentTime) public onlyOwner returns (bool) {
271 Investor storage inv = investors[addr];
272 if (inv.investment != 0 || investment == 0) {
273 return false;
274 }
275 inv.investment = investment;
276 inv.paymentTime = paymentTime;
277 size++;
278 return true;
279 }
280 
281 function addInvestment(address addr, uint investment) public onlyOwner returns (bool) {
282 if (investors[addr].investment == 0) {
283 return false;
284 }
285 investors[addr].investment += investment;
286 return true;
287 }
288 
289 function setPaymentTime(address addr, uint paymentTime) public onlyOwner returns (bool) {
290 if (investors[addr].investment == 0) {
291 return false;
292 }
293 investors[addr].paymentTime = paymentTime;
294 return true;
295 }
296 
297 function disqalify(address addr) public onlyOwner returns (bool) {
298 if (isInvestor(addr)) {
299 investors[addr].investment = 0;
300 }
301 }
302 }
303 
304 
305 library RapidGrowthProtection {
306 using RapidGrowthProtection for rapidGrowthProtection;
307 
308 struct rapidGrowthProtection {
309 uint startTimestamp;
310 uint maxDailyTotalInvestment;
311 uint8 activityDays;
312 mapping(uint8 => uint) dailyTotalInvestment;
313 }
314 
315 function maxInvestmentAtNow(rapidGrowthProtection storage rgp) internal view returns(uint) {
316 uint day = rgp.currDay();
317 if (day == 0 || day > rgp.activityDays) {
318 return 0;
319 }
320 if (rgp.dailyTotalInvestment[uint8(day)] >= rgp.maxDailyTotalInvestment) {
321 return 0;
322 }
323 return rgp.maxDailyTotalInvestment - rgp.dailyTotalInvestment[uint8(day)];
324 }
325 
326 function isActive(rapidGrowthProtection storage rgp) internal view returns(bool) {
327 uint day = rgp.currDay();
328 return day != 0 && day <= rgp.activityDays;
329 }
330 
331 function saveInvestment(rapidGrowthProtection storage rgp, uint investment) internal returns(bool) {
332 uint day = rgp.currDay();
333 if (day == 0 || day > rgp.activityDays) {
334 return false;
335 }
336 if (rgp.dailyTotalInvestment[uint8(day)] + investment > rgp.maxDailyTotalInvestment) {
337 return false;
338 }
339 rgp.dailyTotalInvestment[uint8(day)] += investment;
340 return true;
341 }
342 
343 function startAt(rapidGrowthProtection storage rgp, uint timestamp) internal {
344 rgp.startTimestamp = timestamp;
345 
346 // restart
347 for (uint8 i = 1; i <= rgp.activityDays; i++) {
348 if (rgp.dailyTotalInvestment[i] != 0) {
349 delete rgp.dailyTotalInvestment[i];
350 }
351 }
352 }
353 
354 function currDay(rapidGrowthProtection storage rgp) internal view returns(uint day) {
355 if (rgp.startTimestamp > now) {
356 return 0;
357 }
358 day = (now - rgp.startTimestamp) / 24 hours + 1;
359 }
360 }
361 
362 contract Fortune111 is Accessibility {
363 using RapidGrowthProtection for RapidGrowthProtection.rapidGrowthProtection;
364 using PrivateEntrance for PrivateEntrance.privateEntrance;
365 using Percent for Percent.percent;
366 using SafeMath for uint;
367 using Math for uint;
368 
369 // easy read for investors
370 using Address for *;
371 using Zero for *;
372 
373 RapidGrowthProtection.rapidGrowthProtection private m_rgp;
374 PrivateEntrance.privateEntrance private m_privEnter;
375 mapping(address => bool) private m_referrals;
376 InvestorsStorage private m_investors;
377 
378 // automatically generates getters
379 uint public constant minInvesment = 10 finney;
380 uint public constant maxBalance = 333e5 ether;
381 address public advertisingAddress;
382 address public adminsAddress;
383 uint public investmentsNumber;
384 uint public waveStartup;
385 
386 // percents
387 Percent.percent private m_1_percent = Percent.percent(111,10000);            // 111/10000 *100% = 1.11%
388 Percent.percent private m_5_percent = Percent.percent(555,10000);            // 555/10000 *100% = 5.55%
389 Percent.percent private m_7_percent = Percent.percent(777,10000);            // 777/10000 *100% = 7.77%
390 Percent.percent private m_8_percent = Percent.percent(888,10000);            // 888/10000 *100% = 8.88%
391 Percent.percent private m_9_percent = Percent.percent(999,100);              // 999/10000 *100% = 9.99%
392 Percent.percent private m_10_percent = Percent.percent(10,100);            // 10/100 *100% = 10%
393 Percent.percent private m_11_percent = Percent.percent(11,100);            // 11/100 *100% = 11%
394 Percent.percent private m_12_percent = Percent.percent(12,100);            // 12/100 *100% = 12%
395 Percent.percent private m_referal_percent = Percent.percent(111,10000);        // 111/10000 *100% = 1.11%
396 Percent.percent private m_referrer_percent = Percent.percent(111,10000);       // 111/10000 *100% = 1.11%
397 Percent.percent private m_referrer_percentMax = Percent.percent(10,100);       // 10/100 *100% = 10%
398 Percent.percent private m_adminsPercent = Percent.percent(5,100);          //  5/100 *100% = 5.0%
399 Percent.percent private m_advertisingPercent = Percent.percent(10,100);    // 10/100 *100% = 10.0%
400 
401 // more events for easy read from blockchain
402 event LogPEInit(uint when, address rev1Storage, address rev2Storage, uint investorMaxInvestment, uint endTimestamp);
403 event LogSendExcessOfEther(address indexed addr, uint when, uint value, uint investment, uint excess);
404 event LogNewReferral(address indexed addr, address indexed referrerAddr, uint when, uint refBonus);
405 event LogRGPInit(uint when, uint startTimestamp, uint maxDailyTotalInvestment, uint activityDays);
406 event LogRGPInvestment(address indexed addr, uint when, uint investment, uint indexed day);
407 event LogNewInvesment(address indexed addr, uint when, uint investment, uint value);
408 event LogAutomaticReinvest(address indexed addr, uint when, uint investment);
409 event LogPayDividends(address indexed addr, uint when, uint dividends);
410 event LogNewInvestor(address indexed addr, uint when);
411 event LogBalanceChanged(uint when, uint balance);
412 event LogNextWave(uint when);
413 event LogDisown(uint when);
414 
415 
416 modifier balanceChanged {
417 _;
418 emit LogBalanceChanged(now, address(this).balance);
419 }
420 
421 modifier notFromContract() {
422 require(msg.sender.isNotContract(), "only externally accounts");
423 _;
424 }
425 
426 constructor() public {
427 adminsAddress = msg.sender;
428 advertisingAddress = msg.sender;
429 nextWave();
430 }
431 
432 function() public payable {
433 // investor get him dividends
434 if (msg.value.isZero()) {
435 getMyDividends();
436 return;
437 }
438 
439 // sender do invest
440 doInvest(msg.data.toAddress());
441 }
442 
443 function disqualifyAddress(address addr) public onlyOwner {
444 m_investors.disqalify(addr);
445 }
446 
447 function doDisown() public onlyOwner {
448 disown();
449 emit LogDisown(now);
450 }
451 
452 function init(address rev1StorageAddr, uint timestamp) public onlyOwner {
453 // init Rapid Growth Protection
454 m_rgp.startTimestamp = timestamp + 1;
455 m_rgp.maxDailyTotalInvestment = 500 ether;
456 m_rgp.activityDays = 21;
457 emit LogRGPInit(
458 now,
459 m_rgp.startTimestamp,
460 m_rgp.maxDailyTotalInvestment,
461 m_rgp.activityDays
462 );
463 
464 
465 // init Private Entrance
466 m_privEnter.rev1Storage = Rev1Storage(rev1StorageAddr);
467 m_privEnter.rev2Storage = Rev2Storage(address(m_investors));
468 m_privEnter.investorMaxInvestment = 50 ether;
469 m_privEnter.endTimestamp = timestamp;
470 emit LogPEInit(
471 now,
472 address(m_privEnter.rev1Storage),
473 address(m_privEnter.rev2Storage),
474 m_privEnter.investorMaxInvestment,
475 m_privEnter.endTimestamp
476 );
477 }
478 
479 function setAdvertisingAddress(address addr) public onlyOwner {
480 addr.requireNotZero();
481 advertisingAddress = addr;
482 }
483 
484 function setAdminsAddress(address addr) public onlyOwner {
485 addr.requireNotZero();
486 adminsAddress = addr;
487 }
488 
489 function privateEntranceProvideAccessFor(address[] addrs) public onlyOwner {
490 m_privEnter.provideAccessFor(addrs);
491 }
492 
493 function rapidGrowthProtectionmMaxInvestmentAtNow() public view returns(uint investment) {
494 investment = m_rgp.maxInvestmentAtNow();
495 }
496 
497 function investorsNumber() public view returns(uint) {
498 return m_investors.size();
499 }
500 
501 function balanceETH() public view returns(uint) {
502 return address(this).balance;
503 }
504 
505 function advertisingPercent() public view returns(uint numerator, uint denominator) {
506 (numerator, denominator) = (m_advertisingPercent.num, m_advertisingPercent.den);
507 }
508 
509 function adminsPercent() public view returns(uint numerator, uint denominator) {
510 (numerator, denominator) = (m_adminsPercent.num, m_adminsPercent.den);
511 }
512 
513 function investorInfo(address investorAddr) public view returns(uint investment, uint paymentTime, bool isReferral) {
514 (investment, paymentTime) = m_investors.investorInfo(investorAddr);
515 isReferral = m_referrals[investorAddr];
516 }
517 
518 function investorDividendsAtNow(address investorAddr) public view returns(uint dividends) {
519 dividends = calcDividends(investorAddr);
520 }
521 
522 function dailyPercentAtNow() public view returns(uint numerator, uint denominator) {
523 Percent.percent memory p = dailyPercent();
524 (numerator, denominator) = (p.num, p.den);
525 }
526 
527 function getMyDividends() public notFromContract balanceChanged {
528 // calculate dividends
529 
530 //check if 1 day passed after last payment
531 require(now.sub(getMemInvestor(msg.sender).paymentTime) > 24 hours);
532 
533 uint dividends = calcDividends(msg.sender);
534 require (dividends.notZero(), "cannot to pay zero dividends");
535 
536 // update investor payment timestamp
537 assert(m_investors.setPaymentTime(msg.sender, now));
538 
539 // check enough eth - goto next wave if needed
540 if (address(this).balance <= dividends) {
541 nextWave();
542 dividends = address(this).balance;
543 }
544 
545 // transfer dividends to investor
546 msg.sender.transfer(dividends);
547 emit LogPayDividends(msg.sender, now, dividends);
548 }
549 
550 function doInvest(address referrerAddr) public payable notFromContract balanceChanged {
551 uint investment = msg.value;
552 uint receivedEther = msg.value;
553 require(investment >= minInvesment, "investment must be >= minInvesment");
554 require(address(this).balance <= maxBalance, "the contract eth balance limit");
555 
556 if (m_rgp.isActive()) {
557 // use Rapid Growth Protection if needed
558 uint rpgMaxInvest = m_rgp.maxInvestmentAtNow();
559 rpgMaxInvest.requireNotZero();
560 investment = Math.min(investment, rpgMaxInvest);
561 assert(m_rgp.saveInvestment(investment));
562 emit LogRGPInvestment(msg.sender, now, investment, m_rgp.currDay());
563 
564 } else if (m_privEnter.isActive()) {
565 // use Private Entrance if needed
566 uint peMaxInvest = m_privEnter.maxInvestmentFor(msg.sender);
567 peMaxInvest.requireNotZero();
568 investment = Math.min(investment, peMaxInvest);
569 }
570 
571 // send excess of ether if needed
572 if (receivedEther > investment) {
573 uint excess = receivedEther - investment;
574 msg.sender.transfer(excess);
575 receivedEther = investment;
576 emit LogSendExcessOfEther(msg.sender, now, msg.value, investment, excess);
577 }
578 
579 // commission
580 advertisingAddress.transfer(m_advertisingPercent.mul(receivedEther));
581 adminsAddress.transfer(m_adminsPercent.mul(receivedEther));
582 
583 bool senderIsInvestor = m_investors.isInvestor(msg.sender);
584 
585 // ref system works only once and only on first invest
586 if (referrerAddr.notZero() && !senderIsInvestor && !m_referrals[msg.sender] &&
587 referrerAddr != msg.sender && m_investors.isInvestor(referrerAddr)) {
588 
589 m_referrals[msg.sender] = true;
590 // add referral bonus to investor`s and referral`s investments
591 uint referrerBonus = m_referrer_percent.mmul(investment);
592 if (investment > 10 ether) {
593 referrerBonus = m_referrer_percentMax.mmul(investment);
594 }
595 
596 uint referalBonus = m_referal_percent.mmul(investment);
597 assert(m_investors.addInvestment(referrerAddr, referrerBonus)); // add referrer bonus
598 investment += referalBonus;                                    // add referral bonus
599 emit LogNewReferral(msg.sender, referrerAddr, now, referalBonus);
600 }
601 
602 // automatic reinvest - prevent burning dividends
603 uint dividends = calcDividends(msg.sender);
604 if (senderIsInvestor && dividends.notZero()) {
605 investment += dividends;
606 emit LogAutomaticReinvest(msg.sender, now, dividends);
607 }
608 
609 if (senderIsInvestor) {
610 // update existing investor
611 assert(m_investors.addInvestment(msg.sender, investment));
612 assert(m_investors.setPaymentTime(msg.sender, now));
613 } else {
614 // create new investor
615 assert(m_investors.newInvestor(msg.sender, investment, now));
616 emit LogNewInvestor(msg.sender, now);
617 }
618 
619 investmentsNumber++;
620 emit LogNewInvesment(msg.sender, now, investment, receivedEther);
621 }
622 
623 function getMemInvestor(address investorAddr) internal view returns(InvestorsStorage.Investor memory) {
624 (uint investment, uint paymentTime) = m_investors.investorInfo(investorAddr);
625 return InvestorsStorage.Investor(investment, paymentTime);
626 }
627 
628 function calcDividends(address investorAddr) internal view returns(uint dividends) {
629 InvestorsStorage.Investor memory investor = getMemInvestor(investorAddr);
630 
631 // safe gas if dividends will be 0
632 if (investor.investment.isZero() || now.sub(investor.paymentTime) < 10 minutes) {
633 return 0;
634 }
635 
636 // for prevent burning daily dividends if 24h did not pass - calculate it per 10 min interval
637 Percent.percent memory p = dailyPercent();
638 dividends = (now.sub(investor.paymentTime) / 10 minutes) * p.mmul(investor.investment) / 144;
639 }
640 
641 function dailyPercent() internal view returns(Percent.percent memory p) {
642 uint balance = address(this).balance;
643 
644 if (balance < 500 ether) {
645 p = m_1_percent.toMemory();
646 } else if ( 500 ether <= balance && balance <= 1500 ether) {
647 p = m_5_percent.toMemory();
648 } else if ( 1500 ether <= balance && balance <= 5000 ether) {
649 p = m_7_percent.toMemory();
650 } else if ( 5000 ether <= balance && balance <= 10000 ether) {
651 p = m_8_percent.toMemory();
652 } else if ( 10000 ether <= balance && balance <= 20000 ether) {
653 p = m_9_percent.toMemory();
654 } else if ( 20000 ether <= balance && balance <= 30000 ether) {
655 p = m_10_percent.toMemory();
656 } else if ( 30000 ether <= balance && balance <= 50000 ether) {
657 p = m_11_percent.toMemory();
658 } else {
659 p = m_12_percent.toMemory();
660 }
661 }
662 
663 function nextWave() private {
664 m_investors = new InvestorsStorage();
665 investmentsNumber = 0;
666 waveStartup = now;
667 m_rgp.startAt(now);
668 emit LogRGPInit(now , m_rgp.startTimestamp, m_rgp.maxDailyTotalInvestment, m_rgp.activityDays);
669 emit LogNextWave(now);
670 }
671 }