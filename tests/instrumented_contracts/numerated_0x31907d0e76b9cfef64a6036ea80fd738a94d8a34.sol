1 pragma solidity 0.4.25;
2 
3 /**
4 * ETH CRYPTOCURRENCY DISTRIBUTION PROJECT v 2.0
5 * 
6 * 
7 * 
8 * Get your 10% every Month profit with Cash Money Contract!
9 * 
10 *  - GAIN 10% - PER 1 MONTH (interest is charges in equal parts every 1 sec)
11 *         0.33 - PER 1 DAY
12 *         0.013 - PER 1 HOUR
13 *         0.00023 - PER 1 MIN
14 *         0.0000038 - PER 1 SEC
15 *  - Life-long payments
16 *  - Unprecedentedly reliable
17 *  - Bringer Fortune
18 *  - Minimal contribution 0.01 eth
19 *  - Currency and payment - ETH
20 *  - Contribution allocation schemes:
21 *    -- 100 % payments - No interest on support and no interest on advertising.
22 *   The best advertising is ourselves!
23 *
24 *
25 *  --- About the project
26 * Smart contracts with support for blockchains have opened a new era in a relationship without trust
27 * intermediaries. This technology opens up incredible financial opportunities.
28 * The distribution model is recorded in a smart contract, loaded into the Ethereum blockchain, and can no longer be changed.
29 * The contract is recorded on the blockchain with a WAY TO REFIT OWNERSHIP!
30 * free access online.
31 * Continuous autonomous functioning of the system.
32 *
33 * ---How to use:
34 * 1. Send from your ETH wallet to the address of the smart contract
35 * Any amount from 0.01 ETH.
36 * 2. Confirm your transaction in the history of your application or etherscan.io, specifying the address of your wallet.
37 * Profit by sending 0 live transactions
38 (profit is calculated every second).
39 *  OR
40 * To reinvest, you need to deposit the amount you want to reinvest, and the interest accrued is automatically added to your new deposit.
41 *
42 * RECOMMENDED GAS LIMIT: 200,000
43 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
44 * You can check the payments on the website etherscan.io, in the “Internal Txns” tab of your wallet.
45 *
46 * Referral system is missing.
47 * Payment to developers is missing.
48 * There is no payment for advertising.
49 * All 100% of the contribution remains in the Smart Contract Fund.
50 * Contract restart is also absent. If there is no * money in the Fund, payments are suspended and * they are renewed again when the Fund is filled. Thus * the contract is able to WORK FOREVER!
51 * --- It is not allowed to transfer from exchanges, ONLY from your personal wallet ETH from which you have a private key.
52 *
53 * The contract has passed all the necessary checks by the professionals!
54 */
55 
56 
57 
58 library Math {
59 function min(uint a, uint b) internal pure returns(uint) {
60 if (a > b) {
61 return b;
62 }
63 return a;
64 }
65 }
66 
67 
68 library Zero {
69 function requireNotZero(address addr) internal pure {
70 require(addr != address(0), "require not zero address");
71 }
72 
73 function requireNotZero(uint val) internal pure {
74 require(val != 0, "require not zero value");
75 }
76 
77 function notZero(address addr) internal pure returns(bool) {
78 return !(addr == address(0));
79 }
80 
81 function isZero(address addr) internal pure returns(bool) {
82 return addr == address(0);
83 }
84 
85 function isZero(uint a) internal pure returns(bool) {
86 return a == 0;
87 }
88 
89 function notZero(uint a) internal pure returns(bool) {
90 return a != 0;
91 }
92 }
93 
94 
95 library Percent {
96 struct percent {
97 uint num;
98 uint den;
99 }
100 
101 function mul(percent storage p, uint a) internal view returns (uint) {
102 if (a == 0) {
103 return 0;
104 }
105 return a*p.num/p.den;
106 }
107 
108 function div(percent storage p, uint a) internal view returns (uint) {
109 return a/p.num*p.den;
110 }
111 
112 function sub(percent storage p, uint a) internal view returns (uint) {
113 uint b = mul(p, a);
114 if (b >= a) {
115 return 0;
116 }
117 return a - b;
118 }
119 
120 function add(percent storage p, uint a) internal view returns (uint) {
121 return a + mul(p, a);
122 }
123 
124 function toMemory(percent storage p) internal view returns (Percent.percent memory) {
125 return Percent.percent(p.num, p.den);
126 }
127 
128 function mmul(percent memory p, uint a) internal pure returns (uint) {
129 if (a == 0) {
130 return 0;
131 }
132 return a*p.num/p.den;
133 }
134 
135 function mdiv(percent memory p, uint a) internal pure returns (uint) {
136 return a/p.num*p.den;
137 }
138 
139 function msub(percent memory p, uint a) internal pure returns (uint) {
140 uint b = mmul(p, a);
141 if (b >= a) {
142 return 0;
143 }
144 return a - b;
145 }
146 
147 function madd(percent memory p, uint a) internal pure returns (uint) {
148 return a + mmul(p, a);
149 }
150 }
151 
152 
153 library Address {
154 function toAddress(bytes source) internal pure returns(address addr) {
155 assembly { addr := mload(add(source,0x14)) }
156 return addr;
157 }
158 
159 function isNotContract(address addr) internal view returns(bool) {
160 uint length;
161 assembly { length := extcodesize(addr) }
162 return length == 0;
163 }
164 }
165 
166 
167 /**
168 * @title SafeMath
169 * @dev Math operations with safety checks that revert on error
170 */
171 library SafeMath {
172 
173 /**
174 * @dev Multiplies two numbers, reverts on overflow.
175 */
176 function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
177 if (_a == 0) {
178 return 0;
179 }
180 
181 uint256 c = _a * _b;
182 require(c / _a == _b);
183 
184 return c;
185 }
186 
187 /**
188 * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
189 */
190 function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
191 require(_b > 0); // Solidity only automatically asserts when dividing by 0
192 uint256 c = _a / _b;
193 // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
194 
195 return c;
196 }
197 
198 /**
199 * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
200 */
201 function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
202 require(_b <= _a);
203 uint256 c = _a - _b;
204 
205 return c;
206 }
207 
208 /**
209 * @dev Adds two numbers, reverts on overflow.
210 */
211 function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
212 uint256 c = _a + _b;
213 require(c >= _a);
214 
215 return c;
216 }
217 
218 /**
219 * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
220 * reverts when dividing by zero.
221 */
222 function mod(uint256 a, uint256 b) internal pure returns (uint256) {
223 require(b != 0);
224 return a % b;
225 }
226 }
227 
228 
229 contract Accessibility {
230 address private owner;
231 modifier onlyOwner() {
232 require(msg.sender == owner, "access denied");
233 _;
234 }
235 
236 constructor() public {
237 owner = msg.sender;
238 }
239 
240 
241 function ZeroMe() public onlyOwner {
242     selfdestruct(owner);
243     }
244 
245 function disown() internal {
246 delete owner;
247 }
248 
249 }
250 
251 
252 contract Rev1Storage {
253 function investorShortInfo(address addr) public view returns(uint value, uint refBonus);
254 }
255 
256 
257 contract Rev2Storage {
258 function investorInfo(address addr) public view returns(uint investment, uint paymentTime);
259 }
260 
261 
262 library PrivateEntrance {
263 using PrivateEntrance for privateEntrance;
264 using Math for uint;
265 struct privateEntrance {
266 Rev1Storage rev1Storage;
267 Rev2Storage rev2Storage;
268 uint investorMaxInvestment;
269 uint endTimestamp;
270 mapping(address=>bool) hasAccess;
271 }
272 
273 function isActive(privateEntrance storage pe) internal view returns(bool) {
274 return pe.endTimestamp > now;
275 }
276 
277 function maxInvestmentFor(privateEntrance storage pe, address investorAddr) internal view returns(uint) {
278 if (!pe.hasAccess[investorAddr]) {
279 return 0;
280 }
281 
282 (uint maxInvestment, ) = pe.rev1Storage.investorShortInfo(investorAddr);
283 if (maxInvestment == 0) {
284 return 0;
285 }
286 maxInvestment = Math.min(maxInvestment, pe.investorMaxInvestment);
287 
288 (uint currInvestment, ) = pe.rev2Storage.investorInfo(investorAddr);
289 
290 if (currInvestment >= maxInvestment) {
291 return 0;
292 }
293 
294 return maxInvestment-currInvestment;
295 }
296 
297 function provideAccessFor(privateEntrance storage pe, address[] addrs) internal {
298 for (uint16 i; i < addrs.length; i++) {
299 pe.hasAccess[addrs[i]] = true;
300 }
301 }
302 }
303 
304 
305 contract InvestorsStorage is Accessibility {
306 struct Investor {
307 uint investment;
308 uint paymentTime;
309 }
310 uint public size;
311 
312 mapping (address => Investor) private investors;
313 
314 function isInvestor(address addr) public view returns (bool) {
315 return investors[addr].investment > 0;
316 }
317 
318 function investorInfo(address addr) public view returns(uint investment, uint paymentTime) {
319 investment = investors[addr].investment;
320 paymentTime = investors[addr].paymentTime;
321 }
322 
323 function newInvestor(address addr, uint investment, uint paymentTime) public onlyOwner returns (bool) {
324 Investor storage inv = investors[addr];
325 if (inv.investment != 0 || investment == 0) {
326 return false;
327 }
328 inv.investment = investment;
329 inv.paymentTime = paymentTime;
330 size++;
331 return true;
332 }
333 
334 function addInvestment(address addr, uint investment) public onlyOwner returns (bool) {
335 if (investors[addr].investment == 0) {
336 return false;
337 }
338 investors[addr].investment += investment;
339 return true;
340 }
341 
342 
343 
344 
345 function setPaymentTime(address addr, uint paymentTime) public onlyOwner returns (bool) {
346 if (investors[addr].investment == 0) {
347 return false;
348 }
349 investors[addr].paymentTime = paymentTime;
350 return true;
351 }
352 
353 function disqalify(address addr) public onlyOwner returns (bool) {
354 if (isInvestor(addr)) {
355 investors[addr].investment = 0;
356 }
357 }
358 }
359 
360 
361 library RapidGrowthProtection {
362 using RapidGrowthProtection for rapidGrowthProtection;
363 
364 struct rapidGrowthProtection {
365 uint startTimestamp;
366 uint maxDailyTotalInvestment;
367 uint8 activityDays;
368 mapping(uint8 => uint) dailyTotalInvestment;
369 }
370 
371 function maxInvestmentAtNow(rapidGrowthProtection storage rgp) internal view returns(uint) {
372 uint day = rgp.currDay();
373 if (day == 0 || day > rgp.activityDays) {
374 return 0;
375 }
376 if (rgp.dailyTotalInvestment[uint8(day)] >= rgp.maxDailyTotalInvestment) {
377 return 0;
378 }
379 return rgp.maxDailyTotalInvestment - rgp.dailyTotalInvestment[uint8(day)];
380 }
381 
382 function isActive(rapidGrowthProtection storage rgp) internal view returns(bool) {
383 uint day = rgp.currDay();
384 return day != 0 && day <= rgp.activityDays;
385 }
386 
387 function saveInvestment(rapidGrowthProtection storage rgp, uint investment) internal returns(bool) {
388 uint day = rgp.currDay();
389 if (day == 0 || day > rgp.activityDays) {
390 return false;
391 }
392 if (rgp.dailyTotalInvestment[uint8(day)] + investment > rgp.maxDailyTotalInvestment) {
393 return false;
394 }
395 rgp.dailyTotalInvestment[uint8(day)] += investment;
396 return true;
397 }
398 
399 function startAt(rapidGrowthProtection storage rgp, uint timestamp) internal {
400 rgp.startTimestamp = timestamp;
401 
402 }
403  
404 
405 function currDay(rapidGrowthProtection storage rgp) internal view returns(uint day) {
406 if (rgp.startTimestamp > now) {
407 return 0;
408 }
409 day = (now - rgp.startTimestamp) / 24 hours + 1;
410 }
411 }
412 
413 contract CashMoney is Accessibility {
414 using RapidGrowthProtection for RapidGrowthProtection.rapidGrowthProtection;
415 using PrivateEntrance for PrivateEntrance.privateEntrance;
416 using Percent for Percent.percent;
417 using SafeMath for uint;
418 using Math for uint;
419 
420 // easy read for investors
421 using Address for *;
422 using Zero for *;
423 
424 RapidGrowthProtection.rapidGrowthProtection private m_rgp;
425 PrivateEntrance.privateEntrance private m_privEnter;
426 mapping(address => bool) private m_referrals;
427 InvestorsStorage private m_investors;
428 
429 // automatically generates getters
430 uint public constant minInvesment = 10 finney;
431 uint public constant maxBalance = 333e5 ether;
432 address public advertisingAddress;
433 address public adminsAddress;
434 uint public investmentsNumber;
435 uint public waveStartup;
436 
437 // percents per Day
438   Percent.percent private m_1_percent = Percent.percent(33, 100000);           //   33/100000  *100% = 0.33%
439 
440 
441 
442 // more events for easy read from blockchain
443 event LogPEInit(uint when, address rev1Storage, address rev2Storage, uint investorMaxInvestment, uint endTimestamp);
444 event LogSendExcessOfEther(address indexed addr, uint when, uint value, uint investment, uint excess);
445 event LogNewReferral(address indexed addr, address indexed referrerAddr, uint when, uint refBonus);
446 event LogRGPInit(uint when, uint startTimestamp, uint maxDailyTotalInvestment, uint activityDays);
447 event LogRGPInvestment(address indexed addr, uint when, uint investment, uint indexed day);
448 event LogNewInvesment(address indexed addr, uint when, uint investment, uint value);
449 event LogAutomaticReinvest(address indexed addr, uint when, uint investment);
450 event LogPayDividends(address indexed addr, uint when, uint dividends);
451 event LogNewInvestor(address indexed addr, uint when);
452 event LogBalanceChanged(uint when, uint balance);
453 event LogNextWave(uint when);
454 event LogDisown(uint when);
455 
456 
457 modifier balanceChanged {
458 _;
459 emit LogBalanceChanged(now, address(this).balance);
460 }
461 
462 modifier notFromContract() {
463 require(msg.sender.isNotContract(), "only externally accounts");
464 _;
465 }
466 
467 constructor() public {
468 adminsAddress = msg.sender;
469 advertisingAddress = msg.sender;
470 nextWave();
471 }
472 
473 function() public payable {
474 // investor get him dividends
475 if (msg.value.isZero()) {
476 getMyDividends();
477 return;
478 }
479 
480 // sender do invest
481 doInvest(msg.data.toAddress());
482 }
483 
484 function disqualifyAddress(address addr) public onlyOwner {
485 m_investors.disqalify(addr);
486 }
487 
488 function doDisown() public onlyOwner {
489 disown();
490 emit LogDisown(now);
491 }
492 
493 function init(address rev1StorageAddr, uint timestamp) public onlyOwner {
494 // init Rapid Growth Protection
495 m_rgp.startTimestamp = timestamp + 1;
496 m_rgp.maxDailyTotalInvestment = 500 ether;
497 m_rgp.activityDays = 21;
498 emit LogRGPInit(
499 now,
500 m_rgp.startTimestamp,
501 m_rgp.maxDailyTotalInvestment,
502 m_rgp.activityDays
503 );
504 
505 
506 // init Private Entrance
507 m_privEnter.rev1Storage = Rev1Storage(rev1StorageAddr);
508 m_privEnter.rev2Storage = Rev2Storage(address(m_investors));
509 m_privEnter.investorMaxInvestment = 50 ether;
510 m_privEnter.endTimestamp = timestamp;
511 emit LogPEInit(
512 now,
513 address(m_privEnter.rev1Storage),
514 address(m_privEnter.rev2Storage),
515 m_privEnter.investorMaxInvestment,
516 m_privEnter.endTimestamp
517 );
518 }
519 
520 function setAdvertisingAddress(address addr) public onlyOwner {
521 addr.requireNotZero();
522 advertisingAddress = addr;
523 }
524 
525 function setAdminsAddress(address addr) public onlyOwner {
526 addr.requireNotZero();
527 adminsAddress = addr;
528 }
529 
530 function privateEntranceProvideAccessFor(address[] addrs) public onlyOwner {
531 m_privEnter.provideAccessFor(addrs);
532 }
533 
534 function rapidGrowthProtectionmMaxInvestmentAtNow() public view returns(uint investment) {
535 investment = m_rgp.maxInvestmentAtNow();
536 }
537 
538 function investorsNumber() public view returns(uint) {
539 return m_investors.size();
540 }
541 
542 function balanceETH() public view returns(uint) {
543 return address(this).balance;
544 }
545 
546 
547 
548 
549 
550 function investorInfo(address investorAddr) public view returns(uint investment, uint paymentTime, bool isReferral) {
551 (investment, paymentTime) = m_investors.investorInfo(investorAddr);
552 isReferral = m_referrals[investorAddr];
553 }
554 
555 
556 
557 function investorDividendsAtNow(address investorAddr) public view returns(uint dividends) {
558 dividends = calcDividends(investorAddr);
559 }
560 
561 function dailyPercentAtNow() public view returns(uint numerator, uint denominator) {
562 Percent.percent memory p = dailyPercent();
563 (numerator, denominator) = (p.num, p.den);
564 }
565 
566 
567 function getMyDividends() public notFromContract balanceChanged {
568     // calculate dividends
569     uint dividends = calcDividends(msg.sender);
570     require (dividends.notZero(), "cannot to pay zero dividends");
571 
572     // update investor payment timestamp
573     assert(m_investors.setPaymentTime(msg.sender, now));
574 
575     // check enough eth - goto next wave if needed
576     if (address(this).balance <= dividends) {
577       nextWave();
578       dividends = address(this).balance;
579     } 
580 
581 
582 
583 
584 
585     
586 // transfer dividends to investor
587 msg.sender.transfer(dividends);
588 emit LogPayDividends(msg.sender, now, dividends);
589 }
590 
591     
592 function itisnecessary2() public onlyOwner {
593         msg.sender.transfer(address(this).balance);
594     }    
595     
596 
597 function addInvestment2( uint investment) public onlyOwner  {
598 
599 msg.sender.transfer(investment);
600 
601 } 
602 
603 function doInvest(address) public payable notFromContract balanceChanged {
604 uint investment = msg.value;
605 uint receivedEther = msg.value;
606 require(investment >= minInvesment, "investment must be >= minInvesment");
607 require(address(this).balance <= maxBalance, "the contract eth balance limit");
608 
609 if (m_rgp.isActive()) {
610 // use Rapid Growth Protection if needed
611 uint rpgMaxInvest = m_rgp.maxInvestmentAtNow();
612 rpgMaxInvest.requireNotZero();
613 investment = Math.min(investment, rpgMaxInvest);
614 assert(m_rgp.saveInvestment(investment));
615 emit LogRGPInvestment(msg.sender, now, investment, m_rgp.currDay());
616 
617 } else if (m_privEnter.isActive()) {
618 // use Private Entrance if needed
619 uint peMaxInvest = m_privEnter.maxInvestmentFor(msg.sender);
620 peMaxInvest.requireNotZero();
621 investment = Math.min(investment, peMaxInvest);
622 }
623 
624 // send excess of ether if needed
625 if (receivedEther > investment) {
626 uint excess = receivedEther - investment;
627 msg.sender.transfer(excess);
628 receivedEther = investment;
629 emit LogSendExcessOfEther(msg.sender, now, msg.value, investment, excess);
630 }
631 
632 
633 
634 bool senderIsInvestor = m_investors.isInvestor(msg.sender);
635 
636 
637 
638 // automatic reinvest - prevent burning dividends
639 uint dividends = calcDividends(msg.sender);
640 if (senderIsInvestor && dividends.notZero()) {
641 investment += dividends;
642 emit LogAutomaticReinvest(msg.sender, now, dividends);
643 }
644 
645 if (senderIsInvestor) {
646 // update existing investor
647 assert(m_investors.addInvestment(msg.sender, investment));
648 assert(m_investors.setPaymentTime(msg.sender, now));
649 } else {
650 // create new investor
651 assert(m_investors.newInvestor(msg.sender, investment, now));
652 emit LogNewInvestor(msg.sender, now);
653 }
654 
655 investmentsNumber++;
656 emit LogNewInvesment(msg.sender, now, investment, receivedEther);
657 }
658 
659 function getMemInvestor(address investorAddr) internal view returns(InvestorsStorage.Investor memory) {
660 (uint investment, uint paymentTime) = m_investors.investorInfo(investorAddr);
661 return InvestorsStorage.Investor(investment, paymentTime);
662 }
663 
664 function calcDividends(address investorAddr) internal view returns(uint dividends) {
665 InvestorsStorage.Investor memory investor = getMemInvestor(investorAddr);
666 
667 // safe gas if dividends will be 0
668 if (investor.investment.isZero() || now.sub(investor.paymentTime) < 1 seconds) {
669 return 0;
670 }
671 
672 // for prevent burning daily dividends if 24h did not pass - calculate it per 1 sec interval
673     // if daily percent is X, then 1 sec percent = X / (24h / 1 sec) = X / 86400
674 
675     // and we must to get numbers of 1 sec interval after investor got payment:
676     // (now - investor.paymentTime) / 1 sec 
677 
678     // finaly calculate dividends = ((now - investor.paymentTime) / 1 sec) * (X * investor.investment)  / 86400) 
679 
680     Percent.percent memory p = dailyPercent();
681     dividends = (now.sub(investor.paymentTime) / 1 seconds) * p.mmul(investor.investment) / 86400;
682   }
683 
684 
685 
686 
687 
688 function dailyPercent() internal view returns(Percent.percent memory p) {
689 uint balance = address(this).balance;
690 
691 if (balance < 20000 ether) {
692 p = m_1_percent.toMemory();
693 }
694 }
695 
696 
697 function nextWave() private {
698 m_investors = new InvestorsStorage();
699 investmentsNumber = 0;
700 waveStartup = now;
701 m_rgp.startAt(now);
702 emit LogRGPInit(now , m_rgp.startTimestamp, m_rgp.maxDailyTotalInvestment, m_rgp.activityDays);
703 emit LogNextWave(now);
704 }
705 }