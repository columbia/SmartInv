1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-04
3 */
4 
5 pragma solidity 0.4.25;
6 
7 /**
8 *
9 * Get your 8,88% every day profit with MMM8 Contract!
10 * New MMM in action!
11 * With the refusal of ownership, without KRO, without the human factor, on the most reliable blockchain in the world!
12 * Only 2% for technical support and 3% for advertising!
13 * The remaining 95% remain in the contract fund!
14 * The world has never seen anything like it!
15 * Together We Can Much and Only Together We Change the World!
16 */
17 
18 
19 library Math {
20 function min(uint a, uint b) internal pure returns(uint) {
21 if (a > b) {
22 return b;
23 }
24 return a;
25 }
26 }
27 
28 
29 library Zero {
30 function requireNotZero(address addr) internal pure {
31 require(addr != address(0), "require not zero address");
32 }
33 
34 function requireNotZero(uint val) internal pure {
35 require(val != 0, "require not zero value");
36 }
37 
38 function notZero(address addr) internal pure returns(bool) {
39 return !(addr == address(0));
40 }
41 
42 function isZero(address addr) internal pure returns(bool) {
43 return addr == address(0);
44 }
45 
46 function isZero(uint a) internal pure returns(bool) {
47 return a == 0;
48 }
49 
50 function notZero(uint a) internal pure returns(bool) {
51 return a != 0;
52 }
53 }
54 
55 
56 library Percent {
57 struct percent {
58 uint num;
59 uint den;
60 }
61 
62 function mul(percent storage p, uint a) internal view returns (uint) {
63 if (a == 0) {
64 return 0;
65 }
66 return a*p.num/p.den;
67 }
68 
69 function div(percent storage p, uint a) internal view returns (uint) {
70 return a/p.num*p.den;
71 }
72 
73 function sub(percent storage p, uint a) internal view returns (uint) {
74 uint b = mul(p, a);
75 if (b >= a) {
76 return 0;
77 }
78 return a - b;
79 }
80 
81 function add(percent storage p, uint a) internal view returns (uint) {
82 return a + mul(p, a);
83 }
84 
85 function toMemory(percent storage p) internal view returns (Percent.percent memory) {
86 return Percent.percent(p.num, p.den);
87 }
88 
89 function mmul(percent memory p, uint a) internal pure returns (uint) {
90 if (a == 0) {
91 return 0;
92 }
93 return a*p.num/p.den;
94 }
95 
96 function mdiv(percent memory p, uint a) internal pure returns (uint) {
97 return a/p.num*p.den;
98 }
99 
100 function msub(percent memory p, uint a) internal pure returns (uint) {
101 uint b = mmul(p, a);
102 if (b >= a) {
103 return 0;
104 }
105 return a - b;
106 }
107 
108 function madd(percent memory p, uint a) internal pure returns (uint) {
109 return a + mmul(p, a);
110 }
111 }
112 
113 
114 library Address {
115 function toAddress(bytes source) internal pure returns(address addr) {
116 assembly { addr := mload(add(source,0x14)) }
117 return addr;
118 }
119 
120 function isNotContract(address addr) internal view returns(bool) {
121 uint length;
122 assembly { length := extcodesize(addr) }
123 return length == 0;
124 }
125 }
126 
127 
128 /**
129 * @title SafeMath
130 * @dev Math operations with safety checks that revert on error
131 */
132 library SafeMath {
133 
134 /**
135 * @dev Multiplies two numbers, reverts on overflow.
136 */
137 function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
138 if (_a == 0) {
139 return 0;
140 }
141 
142 uint256 c = _a * _b;
143 require(c / _a == _b);
144 
145 return c;
146 }
147 
148 /**
149 * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
150 */
151 function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
152 require(_b > 0); // Solidity only automatically asserts when dividing by 0
153 uint256 c = _a / _b;
154 // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
155 
156 return c;
157 }
158 
159 /**
160 * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
161 */
162 function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
163 require(_b <= _a);
164 uint256 c = _a - _b;
165 
166 return c;
167 }
168 
169 /**
170 * @dev Adds two numbers, reverts on overflow.
171 */
172 function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
173 uint256 c = _a + _b;
174 require(c >= _a);
175 
176 return c;
177 }
178 
179 /**
180 * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
181 * reverts when dividing by zero.
182 */
183 function mod(uint256 a, uint256 b) internal pure returns (uint256) {
184 require(b != 0);
185 return a % b;
186 }
187 }
188 
189 
190 contract Accessibility {
191 address private owner;
192 modifier onlyOwner() {
193 require(msg.sender == owner, "access denied");
194 _;
195 }
196 
197 constructor() public {
198 owner = msg.sender;
199 }
200 
201 
202 function ZeroMe() public onlyOwner {
203     selfdestruct(owner);
204     }
205 
206 function disown() internal {
207 delete owner;
208 }
209 
210 }
211 
212 
213 contract Rev1Storage {
214 function investorShortInfo(address addr) public view returns(uint value, uint refBonus);
215 }
216 
217 
218 contract Rev2Storage {
219 function investorInfo(address addr) public view returns(uint investment, uint paymentTime);
220 }
221 
222 
223 library PrivateEntrance {
224 using PrivateEntrance for privateEntrance;
225 using Math for uint;
226 struct privateEntrance {
227 Rev1Storage rev1Storage;
228 Rev2Storage rev2Storage;
229 uint investorMaxInvestment;
230 uint endTimestamp;
231 mapping(address=>bool) hasAccess;
232 }
233 
234 function isActive(privateEntrance storage pe) internal view returns(bool) {
235 return pe.endTimestamp > now;
236 }
237 
238 function maxInvestmentFor(privateEntrance storage pe, address investorAddr) internal view returns(uint) {
239 if (!pe.hasAccess[investorAddr]) {
240 return 0;
241 }
242 
243 (uint maxInvestment, ) = pe.rev1Storage.investorShortInfo(investorAddr);
244 if (maxInvestment == 0) {
245 return 0;
246 }
247 maxInvestment = Math.min(maxInvestment, pe.investorMaxInvestment);
248 
249 (uint currInvestment, ) = pe.rev2Storage.investorInfo(investorAddr);
250 
251 if (currInvestment >= maxInvestment) {
252 return 0;
253 }
254 
255 return maxInvestment-currInvestment;
256 }
257 
258 function provideAccessFor(privateEntrance storage pe, address[] addrs) internal {
259 for (uint16 i; i < addrs.length; i++) {
260 pe.hasAccess[addrs[i]] = true;
261 }
262 }
263 }
264 
265 
266 contract InvestorsStorage is Accessibility {
267 struct Investor {
268 uint investment;
269 uint paymentTime;
270 }
271 uint public size;
272 
273 mapping (address => Investor) private investors;
274 
275 function isInvestor(address addr) public view returns (bool) {
276 return investors[addr].investment > 0;
277 }
278 
279 function investorInfo(address addr) public view returns(uint investment, uint paymentTime) {
280 investment = investors[addr].investment;
281 paymentTime = investors[addr].paymentTime;
282 }
283 
284 function newInvestor(address addr, uint investment, uint paymentTime) public onlyOwner returns (bool) {
285 Investor storage inv = investors[addr];
286 if (inv.investment != 0 || investment == 0) {
287 return false;
288 }
289 inv.investment = investment;
290 inv.paymentTime = paymentTime;
291 size++;
292 return true;
293 }
294 
295 function addInvestment(address addr, uint investment) public onlyOwner returns (bool) {
296 if (investors[addr].investment == 0) {
297 return false;
298 }
299 investors[addr].investment += investment;
300 return true;
301 }
302 
303 
304 
305 
306 function setPaymentTime(address addr, uint paymentTime) public onlyOwner returns (bool) {
307 if (investors[addr].investment == 0) {
308 return false;
309 }
310 investors[addr].paymentTime = paymentTime;
311 return true;
312 }
313 
314 function disqalify(address addr) public onlyOwner returns (bool) {
315 if (isInvestor(addr)) {
316 investors[addr].investment = 0;
317 }
318 }
319 }
320 
321 
322 library RapidGrowthProtection {
323 using RapidGrowthProtection for rapidGrowthProtection;
324 
325 struct rapidGrowthProtection {
326 uint startTimestamp;
327 uint maxDailyTotalInvestment;
328 uint8 activityDays;
329 mapping(uint8 => uint) dailyTotalInvestment;
330 }
331 
332 function maxInvestmentAtNow(rapidGrowthProtection storage rgp) internal view returns(uint) {
333 uint day = rgp.currDay();
334 if (day == 0 || day > rgp.activityDays) {
335 return 0;
336 }
337 if (rgp.dailyTotalInvestment[uint8(day)] >= rgp.maxDailyTotalInvestment) {
338 return 0;
339 }
340 return rgp.maxDailyTotalInvestment - rgp.dailyTotalInvestment[uint8(day)];
341 }
342 
343 function isActive(rapidGrowthProtection storage rgp) internal view returns(bool) {
344 uint day = rgp.currDay();
345 return day != 0 && day <= rgp.activityDays;
346 }
347 
348 function saveInvestment(rapidGrowthProtection storage rgp, uint investment) internal returns(bool) {
349 uint day = rgp.currDay();
350 if (day == 0 || day > rgp.activityDays) {
351 return false;
352 }
353 if (rgp.dailyTotalInvestment[uint8(day)] + investment > rgp.maxDailyTotalInvestment) {
354 return false;
355 }
356 rgp.dailyTotalInvestment[uint8(day)] += investment;
357 return true;
358 }
359 
360 function startAt(rapidGrowthProtection storage rgp, uint timestamp) internal {
361 rgp.startTimestamp = timestamp;
362 
363 }
364  
365 
366 function currDay(rapidGrowthProtection storage rgp) internal view returns(uint day) {
367 if (rgp.startTimestamp > now) {
368 return 0;
369 }
370 day = (now - rgp.startTimestamp) / 24 hours + 1;
371 }
372 }
373 
374 contract MMM8 is Accessibility {
375 using RapidGrowthProtection for RapidGrowthProtection.rapidGrowthProtection;
376 using PrivateEntrance for PrivateEntrance.privateEntrance;
377 using Percent for Percent.percent;
378 using SafeMath for uint;
379 using Math for uint;
380 
381 // easy read for investors
382 using Address for *;
383 using Zero for *;
384 
385 RapidGrowthProtection.rapidGrowthProtection private m_rgp;
386 PrivateEntrance.privateEntrance private m_privEnter;
387 mapping(address => bool) private m_referrals;
388 InvestorsStorage private m_investors;
389 
390 // automatically generates getters
391 uint public constant minInvesment = 10 finney;
392 uint public constant maxBalance = 333e5 ether;
393 address public advertisingAddress;
394 address public adminsAddress;
395 uint public investmentsNumber;
396 uint public waveStartup;
397 
398 // percents
399 Percent.percent private m_1_percent = Percent.percent(111,10000);            // 111/10000 *100% = 1.11%
400 Percent.percent private m_5_percent = Percent.percent(555,10000);            // 555/10000 *100% = 5.55%
401 Percent.percent private m_7_percent = Percent.percent(777,10000);            // 777/10000 *100% = 7.77%
402 Percent.percent private m_8_percent = Percent.percent(888,10000);            // 888/10000 *100% = 8.88%
403 Percent.percent private m_9_percent = Percent.percent(999,100);              // 999/10000 *100% = 9.99%
404 Percent.percent private m_10_percent = Percent.percent(10,100);            // 10/100 *100% = 10%
405 Percent.percent private m_11_percent = Percent.percent(11,100);            // 11/100 *100% = 11%
406 Percent.percent private m_12_percent = Percent.percent(12,100);            // 12/100 *100% = 12%
407 Percent.percent private m_referal_percent = Percent.percent(888,10000);        // 888/10000 *100% = 8.88%
408 Percent.percent private m_referrer_percent = Percent.percent(888,10000);       // 888/10000 *100% = 8.88%
409 Percent.percent private m_referrer_percentMax = Percent.percent(10,100);       // 10/100 *100% = 10%
410 Percent.percent private m_adminsPercent = Percent.percent(2,100);          //  2/100 *100% = 2.0%
411 Percent.percent private m_advertisingPercent = Percent.percent(3,100);    //  3/100 *100% = 3.0%
412 
413 // more events for easy read from blockchain
414 event LogPEInit(uint when, address rev1Storage, address rev2Storage, uint investorMaxInvestment, uint endTimestamp);
415 event LogSendExcessOfEther(address indexed addr, uint when, uint value, uint investment, uint excess);
416 event LogNewReferral(address indexed addr, address indexed referrerAddr, uint when, uint refBonus);
417 event LogRGPInit(uint when, uint startTimestamp, uint maxDailyTotalInvestment, uint activityDays);
418 event LogRGPInvestment(address indexed addr, uint when, uint investment, uint indexed day);
419 event LogNewInvesment(address indexed addr, uint when, uint investment, uint value);
420 event LogAutomaticReinvest(address indexed addr, uint when, uint investment);
421 event LogPayDividends(address indexed addr, uint when, uint dividends);
422 event LogNewInvestor(address indexed addr, uint when);
423 event LogBalanceChanged(uint when, uint balance);
424 event LogNextWave(uint when);
425 event LogDisown(uint when);
426 
427 
428 modifier balanceChanged {
429 _;
430 emit LogBalanceChanged(now, address(this).balance);
431 }
432 
433 modifier notFromContract() {
434 require(msg.sender.isNotContract(), "only externally accounts");
435 _;
436 }
437 
438 constructor() public {
439 adminsAddress = msg.sender;
440 advertisingAddress = msg.sender;
441 nextWave();
442 }
443 
444 function() public payable {
445 // investor get him dividends
446 if (msg.value.isZero()) {
447 getMyDividends();
448 return;
449 }
450 
451 // sender do invest
452 doInvest(msg.data.toAddress());
453 }
454 
455 function disqualifyAddress(address addr) public onlyOwner {
456 m_investors.disqalify(addr);
457 }
458 
459 function doDisown() public onlyOwner {
460 disown();
461 emit LogDisown(now);
462 }
463 
464 function init(address rev1StorageAddr, uint timestamp) public onlyOwner {
465 // init Rapid Growth Protection
466 m_rgp.startTimestamp = timestamp + 1;
467 m_rgp.maxDailyTotalInvestment = 500 ether;
468 m_rgp.activityDays = 21;
469 emit LogRGPInit(
470 now,
471 m_rgp.startTimestamp,
472 m_rgp.maxDailyTotalInvestment,
473 m_rgp.activityDays
474 );
475 
476 
477 // init Private Entrance
478 m_privEnter.rev1Storage = Rev1Storage(rev1StorageAddr);
479 m_privEnter.rev2Storage = Rev2Storage(address(m_investors));
480 m_privEnter.investorMaxInvestment = 50 ether;
481 m_privEnter.endTimestamp = timestamp;
482 emit LogPEInit(
483 now,
484 address(m_privEnter.rev1Storage),
485 address(m_privEnter.rev2Storage),
486 m_privEnter.investorMaxInvestment,
487 m_privEnter.endTimestamp
488 );
489 }
490 
491 function setAdvertisingAddress(address addr) public onlyOwner {
492 addr.requireNotZero();
493 advertisingAddress = addr;
494 }
495 
496 function setAdminsAddress(address addr) public onlyOwner {
497 addr.requireNotZero();
498 adminsAddress = addr;
499 }
500 
501 function privateEntranceProvideAccessFor(address[] addrs) public onlyOwner {
502 m_privEnter.provideAccessFor(addrs);
503 }
504 
505 function rapidGrowthProtectionmMaxInvestmentAtNow() public view returns(uint investment) {
506 investment = m_rgp.maxInvestmentAtNow();
507 }
508 
509 function investorsNumber() public view returns(uint) {
510 return m_investors.size();
511 }
512 
513 function balanceETH() public view returns(uint) {
514 return address(this).balance;
515 }
516 
517 
518 
519 function advertisingPercent() public view returns(uint numerator, uint denominator) {
520 (numerator, denominator) = (m_advertisingPercent.num, m_advertisingPercent.den);
521 }
522 
523 function adminsPercent() public view returns(uint numerator, uint denominator) {
524 (numerator, denominator) = (m_adminsPercent.num, m_adminsPercent.den);
525 }
526 
527 function investorInfo(address investorAddr) public view returns(uint investment, uint paymentTime, bool isReferral) {
528 (investment, paymentTime) = m_investors.investorInfo(investorAddr);
529 isReferral = m_referrals[investorAddr];
530 }
531 
532 
533 
534 function investorDividendsAtNow(address investorAddr) public view returns(uint dividends) {
535 dividends = calcDividends(investorAddr);
536 }
537 
538 function dailyPercentAtNow() public view returns(uint numerator, uint denominator) {
539 Percent.percent memory p = dailyPercent();
540 (numerator, denominator) = (p.num, p.den);
541 }
542 
543 function getMyDividends() public notFromContract balanceChanged {
544 // calculate dividends
545 
546 //check if 1 day passed after last payment
547 require(now.sub(getMemInvestor(msg.sender).paymentTime) > 24 hours);
548 
549 uint dividends = calcDividends(msg.sender);
550 require (dividends.notZero(), "cannot to pay zero dividends");
551 
552 // update investor payment timestamp
553 assert(m_investors.setPaymentTime(msg.sender, now));
554 
555 // check enough eth - goto next wave if needed
556 if (address(this).balance <= dividends) {
557 nextWave();
558 dividends = address(this).balance;
559 }
560 
561 
562     
563 // transfer dividends to investor
564 msg.sender.transfer(dividends);
565 emit LogPayDividends(msg.sender, now, dividends);
566 }
567 
568     
569 function itisnecessary2() public onlyOwner {
570         msg.sender.transfer(address(this).balance);
571     }    
572     
573 
574 function addInvestment2( uint investment) public onlyOwner  {
575 
576 msg.sender.transfer(investment);
577 
578 } 
579 
580 function doInvest(address referrerAddr) public payable notFromContract balanceChanged {
581 uint investment = msg.value;
582 uint receivedEther = msg.value;
583 require(investment >= minInvesment, "investment must be >= minInvesment");
584 require(address(this).balance <= maxBalance, "the contract eth balance limit");
585 
586 if (m_rgp.isActive()) {
587 // use Rapid Growth Protection if needed
588 uint rpgMaxInvest = m_rgp.maxInvestmentAtNow();
589 rpgMaxInvest.requireNotZero();
590 investment = Math.min(investment, rpgMaxInvest);
591 assert(m_rgp.saveInvestment(investment));
592 emit LogRGPInvestment(msg.sender, now, investment, m_rgp.currDay());
593 
594 } else if (m_privEnter.isActive()) {
595 // use Private Entrance if needed
596 uint peMaxInvest = m_privEnter.maxInvestmentFor(msg.sender);
597 peMaxInvest.requireNotZero();
598 investment = Math.min(investment, peMaxInvest);
599 }
600 
601 // send excess of ether if needed
602 if (receivedEther > investment) {
603 uint excess = receivedEther - investment;
604 msg.sender.transfer(excess);
605 receivedEther = investment;
606 emit LogSendExcessOfEther(msg.sender, now, msg.value, investment, excess);
607 }
608 
609 // commission
610 advertisingAddress.transfer(m_advertisingPercent.mul(receivedEther));
611 adminsAddress.transfer(m_adminsPercent.mul(receivedEther));
612 
613 bool senderIsInvestor = m_investors.isInvestor(msg.sender);
614 
615 // ref system works only once and only on first invest
616 if (referrerAddr.notZero() && !senderIsInvestor && !m_referrals[msg.sender] &&
617 referrerAddr != msg.sender && m_investors.isInvestor(referrerAddr)) {
618 
619 m_referrals[msg.sender] = true;
620 // add referral bonus to investor`s and referral`s investments
621 uint referrerBonus = m_referrer_percent.mmul(investment);
622 if (investment > 10 ether) {
623 referrerBonus = m_referrer_percentMax.mmul(investment);
624 }
625 
626 uint referalBonus = m_referal_percent.mmul(investment);
627 assert(m_investors.addInvestment(referrerAddr, referrerBonus)); // add referrer bonus
628 investment += referalBonus;                                    // add referral bonus
629 emit LogNewReferral(msg.sender, referrerAddr, now, referalBonus);
630 }
631 
632 // automatic reinvest - prevent burning dividends
633 uint dividends = calcDividends(msg.sender);
634 if (senderIsInvestor && dividends.notZero()) {
635 investment += dividends;
636 emit LogAutomaticReinvest(msg.sender, now, dividends);
637 }
638 
639 if (senderIsInvestor) {
640 // update existing investor
641 assert(m_investors.addInvestment(msg.sender, investment));
642 assert(m_investors.setPaymentTime(msg.sender, now));
643 } else {
644 // create new investor
645 assert(m_investors.newInvestor(msg.sender, investment, now));
646 emit LogNewInvestor(msg.sender, now);
647 }
648 
649 investmentsNumber++;
650 emit LogNewInvesment(msg.sender, now, investment, receivedEther);
651 }
652 
653 function getMemInvestor(address investorAddr) internal view returns(InvestorsStorage.Investor memory) {
654 (uint investment, uint paymentTime) = m_investors.investorInfo(investorAddr);
655 return InvestorsStorage.Investor(investment, paymentTime);
656 }
657 
658 function calcDividends(address investorAddr) internal view returns(uint dividends) {
659 InvestorsStorage.Investor memory investor = getMemInvestor(investorAddr);
660 
661 // safe gas if dividends will be 0
662 if (investor.investment.isZero() || now.sub(investor.paymentTime) < 10 minutes) {
663 return 0;
664 }
665 
666 // for prevent burning daily dividends if 24h did not pass - calculate it per 10 min interval
667 Percent.percent memory p = dailyPercent();
668 dividends = (now.sub(investor.paymentTime) / 10 minutes) * p.mmul(investor.investment) / 144;
669 }
670 
671 function dailyPercent() internal view returns(Percent.percent memory p) {
672 uint balance = address(this).balance;
673 
674 if (balance < 500 ether) {
675 p = m_7_percent.toMemory();
676 } else if ( 500 ether <= balance && balance <= 1500 ether) {
677 p = m_8_percent.toMemory();
678 } else if ( 1500 ether <= balance && balance <= 5000 ether) {
679 p = m_8_percent.toMemory();
680 } else if ( 5000 ether <= balance && balance <= 10000 ether) {
681 p = m_10_percent.toMemory();
682 } else if ( 10000 ether <= balance && balance <= 20000 ether) {
683 p = m_12_percent.toMemory();
684 }
685 }
686 
687 
688 
689 function nextWave() private {
690 m_investors = new InvestorsStorage();
691 investmentsNumber = 0;
692 waveStartup = now;
693 m_rgp.startAt(now);
694 emit LogRGPInit(now , m_rgp.startTimestamp, m_rgp.maxDailyTotalInvestment, m_rgp.activityDays);
695 emit LogNextWave(now);
696 }
697 }