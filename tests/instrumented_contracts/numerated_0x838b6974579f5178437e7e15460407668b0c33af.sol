1 pragma solidity >0.4.99 <0.6.0;
2 
3 
4 library Zero {
5     function requireNotZero(address addr) internal pure {
6         require(addr != address(0), "require not zero address");
7     }
8 
9     function requireNotZero(uint val) internal pure {
10         require(val != 0, "require not zero value");
11     }
12 
13     function notZero(address addr) internal pure returns(bool) {
14         return !(addr == address(0));
15     }
16 
17     function isZero(address addr) internal pure returns(bool) {
18         return addr == address(0);
19     }
20 
21     function isZero(uint a) internal pure returns(bool) {
22         return a == 0;
23     }
24 
25     function notZero(uint a) internal pure returns(bool) {
26         return a != 0;
27     }
28 }
29 
30 
31 library Percent {
32     struct percent {
33         uint num;
34         uint den;
35     }
36 
37     function mul(percent storage p, uint a) internal view returns (uint) {
38         if (a == 0) {
39             return 0;
40         }
41         return a*p.num/p.den;
42     }
43 
44     function div(percent storage p, uint a) internal view returns (uint) {
45         return a/p.num*p.den;
46     }
47 
48     function sub(percent storage p, uint a) internal view returns (uint) {
49         uint b = mul(p, a);
50         if (b >= a) {
51             return 0;
52         }
53         return a - b;
54     }
55 
56     function add(percent storage p, uint a) internal view returns (uint) {
57         return a + mul(p, a);
58     }
59 
60     function toMemory(percent storage p) internal view returns (Percent.percent memory) {
61         return Percent.percent(p.num, p.den);
62     }
63 
64     function mmul(percent memory p, uint a) internal pure returns (uint) {
65         if (a == 0) {
66             return 0;
67         }
68         return a*p.num/p.den;
69     }
70 
71     function mdiv(percent memory p, uint a) internal pure returns (uint) {
72         return a/p.num*p.den;
73     }
74 
75     function msub(percent memory p, uint a) internal pure returns (uint) {
76         uint b = mmul(p, a);
77         if (b >= a) {
78             return 0;
79         }
80         return a - b;
81     }
82 
83     function madd(percent memory p, uint a) internal pure returns (uint) {
84         return a + mmul(p, a);
85     }
86 }
87 
88 
89 library Address {
90     function toAddress(bytes memory source) internal pure returns(address addr) {
91         assembly { addr := mload(add(source,0x14)) }
92         return addr;
93     }
94 
95     function isNotContract(address addr) internal view returns(bool) {
96         uint length;
97         assembly { length := extcodesize(addr) }
98         return length == 0;
99     }
100 }
101 
102 
103 /**
104  * @title SafeMath
105  * @dev Math operations with safety checks that revert on error
106  */
107 library SafeMath {
108 
109     /**
110     * @dev Multiplies two numbers, reverts on overflow.
111     */
112     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
113         if (_a == 0) {
114             return 0;
115         }
116 
117         uint256 c = _a * _b;
118         require(c / _a == _b);
119 
120         return c;
121     }
122 
123     /**
124     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
125     */
126     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
127         require(_b > 0); // Solidity only automatically asserts when dividing by 0
128         uint256 c = _a / _b;
129         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
130 
131         return c;
132     }
133 
134     /**
135     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
136     */
137     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
138         require(_b <= _a);
139         uint256 c = _a - _b;
140 
141         return c;
142     }
143 
144     /**
145     * @dev Adds two numbers, reverts on overflow.
146     */
147     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
148         uint256 c = _a + _b;
149         require(c >= _a);
150 
151         return c;
152     }
153 
154     /**
155     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
156     * reverts when dividing by zero.
157     */
158     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
159         require(b != 0);
160         return a % b;
161     }
162 }
163 
164 
165 contract Accessibility {
166     address private owner;
167     event OwnerChanged(address indexed previousOwner, address indexed newOwner);
168 
169     modifier onlyOwner() {
170         require(msg.sender == owner, "access denied");
171         _;
172     }
173 	
174 	constructor() public {
175 		owner = msg.sender;
176     }
177 
178     function changeOwner(address _newOwner) onlyOwner public {
179         require(_newOwner != address(0));
180         emit OwnerChanged(owner, _newOwner);
181         owner = _newOwner;
182     }
183 }
184 
185 
186 contract InvestorsStorage is Accessibility {
187     using SafeMath for uint;
188 
189     struct Investor {
190         uint paymentTime;
191         uint fundDepositType_1;
192         uint fundDepositType_2;
193         uint fundDepositType_3;
194         uint referrerBonus;
195         uint numberReferral;
196     }
197     uint public size;
198 
199     mapping (address => Investor) private investors;
200 
201     function isInvestor(address addr) public view returns (bool) {
202         uint fundDeposit = investors[addr].fundDepositType_1.add(investors[addr].fundDepositType_2).add(investors[addr].fundDepositType_3);
203         return fundDeposit > 0;
204     }
205 
206     function investorInfo(address addr) public view returns(uint paymentTime,
207         uint fundDepositType_1, uint fundDepositType_2, uint fundDepositType_3,
208         uint referrerBonus, uint numberReferral) {
209         paymentTime = investors[addr].paymentTime;
210         fundDepositType_1 = investors[addr].fundDepositType_1;
211         fundDepositType_2 = investors[addr].fundDepositType_2;
212         fundDepositType_3 = investors[addr].fundDepositType_3;
213         referrerBonus = investors[addr].referrerBonus;
214         numberReferral = investors[addr].numberReferral;
215     }
216 
217     function newInvestor(address addr, uint investment, uint paymentTime, uint typeDeposit) public onlyOwner returns (bool) {
218         Investor storage inv = investors[addr];
219         uint fundDeposit = inv.fundDepositType_1.add(inv.fundDepositType_2).add(inv.fundDepositType_3);
220         if (fundDeposit != 0 || investment == 0) {
221             return false;
222         }
223         if (typeDeposit < 0 || typeDeposit > 2) {
224             return false;
225         }
226 
227         if (typeDeposit == 0) {
228             inv.fundDepositType_1 = investment;
229         } else if (typeDeposit == 1) {
230             inv.fundDepositType_2 = investment;
231         } else if (typeDeposit == 2) {
232             inv.fundDepositType_3 = investment;
233         }
234 
235         inv.paymentTime = paymentTime;
236         size++;
237         return true;
238     }
239 
240     function checkSetZeroFund(address addr, uint currentTime) public onlyOwner {
241         uint numberDays = currentTime.sub(investors[addr].paymentTime) / 1 days;
242 
243         if (investors[addr].fundDepositType_1 > 0 && numberDays > 30) {
244             investors[addr].fundDepositType_1 = 0;
245         }
246         if (investors[addr].fundDepositType_2 > 0 && numberDays > 90) {
247             investors[addr].fundDepositType_2 = 0;
248         }
249         if (investors[addr].fundDepositType_3 > 0 && numberDays > 180) {
250             investors[addr].fundDepositType_3 = 0;
251         }
252     }
253 
254     function addInvestment(address addr, uint investment, uint typeDeposit) public onlyOwner returns (bool) {
255         if (typeDeposit == 0) {
256             investors[addr].fundDepositType_1 = investors[addr].fundDepositType_1.add(investment);
257         } else if (typeDeposit == 1) {
258             investors[addr].fundDepositType_2 = investors[addr].fundDepositType_2.add(investment);
259         } else if (typeDeposit == 2) {
260             investors[addr].fundDepositType_3 = investors[addr].fundDepositType_3.add(investment);
261         } else if (typeDeposit == 10) {
262             investors[addr].referrerBonus = investors[addr].referrerBonus.add(investment);
263         }
264 
265         return true;
266     }
267 
268     function addReferral(address addr) public onlyOwner {
269         investors[addr].numberReferral++;
270     }
271 
272     function getCountReferral(address addr) public view onlyOwner returns (uint) {
273         return investors[addr].numberReferral;
274     }
275 
276     function getReferrerBonus(address addr) public onlyOwner returns (uint) {
277         uint referrerBonus = investors[addr].referrerBonus;
278         investors[addr].referrerBonus = 0;
279         return referrerBonus;
280     }
281 
282     function setPaymentTime(address addr, uint paymentTime) public onlyOwner returns (bool) {
283         uint fundDeposit = investors[addr].fundDepositType_1.add(investors[addr].fundDepositType_2).add(investors[addr].fundDepositType_3);
284         if (fundDeposit == 0) {
285             return false;
286         }
287         investors[addr].paymentTime = paymentTime;
288         return true;
289     }
290 }
291 
292 contract Ethbank is Accessibility {
293     using Percent for Percent.percent;
294     using SafeMath for uint;
295 
296     // easy read for investors
297     using Address for *;
298     using Zero for *;
299 
300     bool public isDemo;
301 	uint public simulateDate;
302 
303     mapping(address => bool) private m_referrals;
304     InvestorsStorage private m_investors;
305 
306     // automatically generates getters
307     uint public constant minInvesment = 10 finney;
308     address payable public advertisingAddress;
309     uint public investmentsNumber;
310     uint public totalEthRaised;
311 
312 
313     // percents tariff
314     Percent.percent private m_1_percent = Percent.percent(1,100);            // 1/100 *100% = 1%
315     Percent.percent private m_2_percent = Percent.percent(2,100);            // 2/100 *100% = 2%
316     Percent.percent private m_3_percent = Percent.percent(3,100);            // 3/100 *100% = 3%
317 
318     // percents referal
319     Percent.percent private m_3_referal_percent = Percent.percent(3,100);        // 3/100 *100% = 3%
320     Percent.percent private m_3_referrer_percent = Percent.percent(3,100);       // 3/100 *100% = 3%
321 
322     Percent.percent private m_5_referal_percent = Percent.percent(5,100);        // 5/100 *100% = 5%
323     Percent.percent private m_4_referrer_percent = Percent.percent(4,100);       // 4/100 *100% = 4%
324 
325     Percent.percent private m_10_referal_percent = Percent.percent(10,100);      // 10/100 *100% = 10%
326     Percent.percent private m_5_referrer_percent = Percent.percent(5,100);       // 5/100 *100% = 5%
327 
328     // percents advertising
329     Percent.percent private m_advertisingPercent = Percent.percent(10, 100);      // 10/100  *100% = 10%
330 
331     // more events for easy read from blockchain
332     event LogNewReferral(address indexed addr, address indexed referrerAddr, uint when, uint referralBonus);
333     event LogNewInvesment(address indexed addr, uint when, uint investment, uint typeDeposit);
334     event LogAutomaticReinvest(address indexed addr, uint when, uint investment, uint typeDeposit);
335     event LogPayDividends(address indexed addr, uint when, uint dividends);
336     event LogPayReferrerBonus(address indexed addr, uint when, uint referrerBonus);
337     event LogNewInvestor(address indexed addr, uint when, uint typeDeposit);
338     event LogBalanceChanged(uint when, uint balance);
339     event ChangeTime(uint256 _newDate, uint256 simulateDate);
340 
341     modifier balanceChanged {
342         _;
343         emit LogBalanceChanged(getCurrentDate(), address(this).balance);
344     }
345 
346     modifier notFromContract() {
347         require(msg.sender.isNotContract(), "only externally accounts");
348         _;
349     }
350 
351     constructor(address payable _advertisingAddress) public {
352         advertisingAddress = _advertisingAddress;
353         m_investors = new InvestorsStorage();
354         investmentsNumber = 0;
355     }
356 
357     function() external payable {
358         if (msg.value.isZero()) {
359             getMyDividends();
360             return;
361         } else {
362 			doInvest(msg.data.toAddress(), 0);
363 		}
364     }
365 
366     function setAdvertisingAddress(address payable addr) public onlyOwner {
367         addr.requireNotZero();
368         advertisingAddress = addr;
369     }
370 
371     function investorsNumber() public view returns(uint) {
372         return m_investors.size();
373     }
374 
375     function balanceETH() public view returns(uint) {
376         return address(this).balance;
377     }
378 
379     function advertisingPercent() public view returns(uint numerator, uint denominator) {
380         (numerator, denominator) = (m_advertisingPercent.num, m_advertisingPercent.den);
381     }
382 
383     function investorInfo(address investorAddr) public view returns(uint paymentTime, bool isReferral,
384                         uint fundDepositType_1, uint fundDepositType_2, uint fundDepositType_3,
385                         uint referrerBonus, uint numberReferral) {
386         (paymentTime, fundDepositType_1, fundDepositType_2, fundDepositType_3, referrerBonus, numberReferral) = m_investors.investorInfo(investorAddr);
387         isReferral = m_referrals[investorAddr];
388     }
389 
390     function investorDividendsAtNow(address investorAddr) public view returns(uint dividends) {
391         dividends = calcDividends(investorAddr);
392     }
393 
394     function doInvest(address referrerAddr, uint typeDeposit) public payable notFromContract balanceChanged {
395         uint investment = msg.value;
396         require(investment >= minInvesment, "investment must be >= minInvesment");
397         require(typeDeposit >= 0 && typeDeposit < 3, "wrong deposit type");
398 
399         bool senderIsInvestor = m_investors.isInvestor(msg.sender);
400 
401         if (referrerAddr.notZero() && !senderIsInvestor && !m_referrals[msg.sender] &&
402         referrerAddr != msg.sender && m_investors.isInvestor(referrerAddr)) {
403 
404             m_referrals[msg.sender] = true;
405             m_investors.addReferral(referrerAddr);
406             uint countReferral = m_investors.getCountReferral(referrerAddr);
407             uint referrerBonus = 0;
408             uint referralBonus = 0;
409 
410             if (countReferral <= 9) {
411                 referrerBonus = m_3_referrer_percent.mmul(investment);
412                 referralBonus = m_3_referal_percent.mmul(investment);
413             }
414             if (countReferral > 9 && countReferral <= 29) {
415                 referrerBonus = m_4_referrer_percent.mmul(investment);
416                 referralBonus = m_5_referal_percent.mmul(investment);
417             }
418             if (countReferral > 29) {
419                 referrerBonus = m_5_referrer_percent.mmul(investment);
420                 referralBonus = m_10_referal_percent.mmul(investment);
421             }
422 
423             assert(m_investors.addInvestment(referrerAddr, referrerBonus, 10)); // add referrer bonus
424             assert(m_investors.addInvestment(msg.sender, referralBonus, 10)); // add referral bonus
425             emit LogNewReferral(msg.sender, referrerAddr, getCurrentDate(), referralBonus);
426         } else {
427             // commission
428             advertisingAddress.transfer(m_advertisingPercent.mul(investment));
429         }
430 
431         // automatic reinvest - prevent burning dividends
432         uint dividends = calcDividends(msg.sender);
433         if (senderIsInvestor && dividends.notZero()) {
434             investment = investment.add(dividends);
435             emit LogAutomaticReinvest(msg.sender, getCurrentDate(), dividends, typeDeposit);
436         }
437 
438         if (senderIsInvestor) {
439             // update existing investor
440             assert(m_investors.addInvestment(msg.sender, investment, typeDeposit));
441             assert(m_investors.setPaymentTime(msg.sender, getCurrentDate()));
442         } else {
443             // create new investor
444             assert(m_investors.newInvestor(msg.sender, investment, getCurrentDate(), typeDeposit));
445             emit LogNewInvestor(msg.sender, getCurrentDate(), typeDeposit);
446         }
447 
448         investmentsNumber++;
449         totalEthRaised = totalEthRaised.add(msg.value);
450         emit LogNewInvesment(msg.sender, getCurrentDate(), investment, typeDeposit);
451     }
452 
453     function getMemInvestor(address investorAddr) internal view returns(InvestorsStorage.Investor memory) {
454         (uint paymentTime,
455         uint fundDepositType_1, uint fundDepositType_2,
456         uint fundDepositType_3, uint referrerBonus, uint numberReferral) = m_investors.investorInfo(investorAddr);
457         return InvestorsStorage.Investor(paymentTime, fundDepositType_1, fundDepositType_2, fundDepositType_3, referrerBonus, numberReferral);
458     }
459 
460     function getMyDividends() public payable notFromContract balanceChanged {
461         address payable investor = msg.sender;
462         require(investor.notZero(), "require not zero address");
463         uint currentTime = getCurrentDate();
464 
465         uint receivedEther = msg.value;
466         require(receivedEther.isZero(), "amount ETH must be 0");
467 
468         //check if 1 day passed after last payment
469         require(currentTime.sub(getMemInvestor(investor).paymentTime) > 24 hours, "must pass 24 hours after the investment");
470 
471         // calculate dividends
472         uint dividends = calcDividends(msg.sender);
473         require (dividends.notZero(), "cannot to pay zero dividends");
474 
475         m_investors.checkSetZeroFund(investor, currentTime);
476 
477         // update investor payment timestamp
478         assert(m_investors.setPaymentTime(investor, currentTime));
479 
480         // transfer dividends to investor
481         investor.transfer(dividends);
482         emit LogPayDividends(investor, currentTime, dividends);
483     }
484 
485     function getMyReferrerBonus() public notFromContract balanceChanged {
486         uint referrerBonus = m_investors.getReferrerBonus(msg.sender);
487         require (referrerBonus.notZero(), "cannot to pay zero referrer bonus");
488 
489         // transfer referrer bonus to investor
490         msg.sender.transfer(referrerBonus);
491         emit LogPayReferrerBonus(msg.sender, getCurrentDate(), referrerBonus);
492     }
493 
494     function calcDividends(address investorAddress) internal view returns(uint dividends) {
495         InvestorsStorage.Investor memory inv = getMemInvestor(investorAddress);
496         dividends = 0;
497         uint fundDeposit = inv.fundDepositType_1.add(inv.fundDepositType_2).add(inv.fundDepositType_3);
498         uint numberDays = getCurrentDate().sub(inv.paymentTime) / 1 days;
499 
500         // safe gas if dividends will be 0
501         if (fundDeposit.isZero() || numberDays.isZero()) {
502             return 0;
503         }
504 
505         if (inv.fundDepositType_1 > 0) {
506             if (numberDays > 30) {
507                 dividends = 30 * m_1_percent.mmul(inv.fundDepositType_1);
508                 dividends = dividends.add(inv.fundDepositType_1);
509             } else {
510                 dividends = numberDays * m_1_percent.mmul(inv.fundDepositType_1);
511             }
512         }
513         if (inv.fundDepositType_2 > 0) {
514             if (numberDays > 90) {
515                 dividends = dividends.add(90 * m_2_percent.mmul(inv.fundDepositType_2));
516                 dividends = dividends.add(inv.fundDepositType_2);
517             } else {
518                 dividends = dividends.add(numberDays * m_2_percent.mmul(inv.fundDepositType_2));
519             }
520         }
521         if (inv.fundDepositType_3 > 0) {
522             if (numberDays > 180) {
523                 dividends = dividends.add(180 * m_3_percent.mmul(inv.fundDepositType_3));
524                 dividends = dividends.add(inv.fundDepositType_3);
525             } else {
526                 dividends = dividends.add(numberDays * m_3_percent.mmul(inv.fundDepositType_3));
527             }
528         }
529     }
530 
531     function getCurrentDate() public view returns (uint) {
532         if (isDemo) {
533             return simulateDate;
534         }
535         return now;
536     }
537 	
538     function setSimulateDate(uint256 _newDate) public onlyOwner {
539         if (isDemo) {
540             require(_newDate > simulateDate);
541             emit ChangeTime(_newDate, simulateDate);
542             simulateDate = _newDate;
543         } 
544     }
545 
546     function setDemo() public onlyOwner {
547         if (investorsNumber() == 0) {
548             isDemo = true;
549         }
550     }
551 
552 
553 }