1 pragma solidity 0.4.25;
2 pragma experimental ABIEncoderV2;
3 /**
4 www.constantinople.site 
5 
6 */
7 
8 
9 library Math {
10     function min(uint a, uint b) internal pure returns(uint) {
11         if (a > b) {
12             return b;
13         }
14         return a;
15     }
16 }
17 
18 
19 library Zero {
20     function requireNotZero(address addr) internal pure {
21         require(addr != address(0), "require not zero address");
22     }
23 
24     function requireNotZero(uint val) internal pure {
25         require(val != 0, "require not zero value");
26     }
27 
28     function notZero(address addr) internal pure returns(bool) {
29         return !(addr == address(0));
30     }
31 
32     function isZero(address addr) internal pure returns(bool) {
33         return addr == address(0);
34     }
35 
36     function isZero(uint a) internal pure returns(bool) {
37         return a == 0;
38     }
39 
40     function notZero(uint a) internal pure returns(bool) {
41         return a != 0;
42     }
43 }
44 
45 
46 library Percent {
47     struct percent {
48         uint num;
49         uint den;
50     }
51 
52     function mul(percent storage p, uint a) internal view returns (uint) {
53         if (a == 0) {
54             return 0;
55         }
56         return a*p.num/p.den;
57     }
58 
59     function div(percent storage p, uint a) internal view returns (uint) {
60         return a/p.num*p.den;
61     }
62 
63     function sub(percent storage p, uint a) internal view returns (uint) {
64         uint b = mul(p, a);
65         if (b >= a) {
66             return 0;
67         }
68         return a - b;
69     }
70 
71     function add(percent storage p, uint a) internal view returns (uint) {
72         return a + mul(p, a);
73     }
74 
75     function toMemory(percent storage p) internal view returns (Percent.percent memory) {
76         return Percent.percent(p.num, p.den);
77     }
78 
79     function mmul(percent memory p, uint a) internal pure returns (uint) {
80         if (a == 0) {
81             return 0;
82         }
83         return a*p.num/p.den;
84     }
85 
86     function mdiv(percent memory p, uint a) internal pure returns (uint) {
87         return a/p.num*p.den;
88     }
89 
90     function msub(percent memory p, uint a) internal pure returns (uint) {
91         uint b = mmul(p, a);
92         if (b >= a) {
93             return 0;
94         }
95         return a - b;
96     }
97 
98     function madd(percent memory p, uint a) internal pure returns (uint) {
99         return a + mmul(p, a);
100     }
101 }
102 
103 
104 library Address {
105     function toAddress(bytes source) internal pure returns(address addr) {
106         assembly { addr := mload(add(source,0x14)) }
107         return addr;
108     }
109 
110     function isNotContract(address addr) internal view returns(bool) {
111         uint length;
112         assembly { length := extcodesize(addr) }
113         return length == 0;
114     }
115 }
116 
117 
118 library SafeMath {
119 
120     /**
121     * @dev Multiplies two numbers, reverts on overflow.
122     */
123     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
124         if (_a == 0) {
125             return 0;
126         }
127 
128         uint256 c = _a * _b;
129         require(c / _a == _b);
130 
131         return c;
132     }
133 
134     /**
135     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
136     */
137     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
138         require(_b > 0); // Solidity only automatically asserts when dividing by 0
139         uint256 c = _a / _b;
140         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
141 
142         return c;
143     }
144 
145     /**
146     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
147     */
148     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
149         require(_b <= _a);
150         uint256 c = _a - _b;
151 
152         return c;
153     }
154 
155     /**
156     * @dev Adds two numbers, reverts on overflow.
157     */
158     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
159         uint256 c = _a + _b;
160         require(c >= _a);
161 
162         return c;
163     }
164 
165     /**
166     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
167     * reverts when dividing by zero.
168     */
169     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
170         require(b != 0);
171         return a % b;
172     }
173 }
174 
175 
176 contract Accessibility {
177     address private owner;
178     modifier onlyOwner() {
179         require(msg.sender == owner, "access denied");
180         _;
181     }
182 
183     constructor() public {
184         owner = msg.sender;
185     }
186 
187     function disown() internal {
188         delete owner;
189     }
190 }
191 
192 
193 contract InvestorsStorage is Accessibility {
194     struct Investment {
195         uint value;
196         uint date;
197         bool partiallyWithdrawn;
198         bool fullyWithdrawn;
199     }
200 
201     struct Investor {
202         uint overallInvestment;
203         uint paymentTime;
204         Investment[] investments;
205         Percent.percent individualPercent;
206     }
207     uint public size;
208 
209     mapping (address => Investor) private investors;
210 
211     function isInvestor(address addr) public view returns (bool) {
212         return investors[addr].overallInvestment > 0;
213     }
214 
215     function investorInfo(address addr)  returns(uint overallInvestment, uint paymentTime, Investment[] investments, Percent.percent individualPercent) {
216         overallInvestment = investors[addr].overallInvestment;
217         paymentTime = investors[addr].paymentTime;
218         investments = investors[addr].investments;
219         individualPercent = investors[addr].individualPercent;
220     }
221 
222     function updatePercent(address addr) private {
223         uint investment = investors[addr].overallInvestment;
224         if (investment < 1 ether) {
225             investors[addr].individualPercent = Percent.percent(3,100);
226         } else if (investment >= 1 ether && investment < 10 ether) {
227             investors[addr].individualPercent = Percent.percent(4,100);
228         } else if (investment >= 10 ether && investment < 50 ether) {
229             investors[addr].individualPercent = Percent.percent(5,100);
230         } else if (investment >= 150 ether && investment < 250 ether) {
231             investors[addr].individualPercent = Percent.percent(7,100);
232         } else if (investment >= 250 ether && investment < 500 ether) {
233             investors[addr].individualPercent = Percent.percent(10,100);
234         } else if (investment >= 500 ether && investment < 1000 ether) {
235             investors[addr].individualPercent = Percent.percent(11,100);
236         } else if (investment >= 1000 ether && investment < 2000 ether) {
237             investors[addr].individualPercent = Percent.percent(14,100);
238         } else if (investment >= 2000 ether && investment < 5000 ether) {
239             investors[addr].individualPercent = Percent.percent(15,100);
240         } else if (investment >= 5000 ether && investment < 10000 ether) {
241             investors[addr].individualPercent = Percent.percent(18,100);
242         } else if (investment >= 10000 ether && investment < 30000 ether) {
243             investors[addr].individualPercent = Percent.percent(20,100);
244         } else if (investment >= 30000 ether && investment < 60000 ether) {
245             investors[addr].individualPercent = Percent.percent(27,100);
246         } else if (investment >= 60000 ether && investment < 100000 ether) {
247             investors[addr].individualPercent = Percent.percent(35,100);
248         } else if (investment >= 100000 ether) {
249             investors[addr].individualPercent = Percent.percent(100,100);
250         }
251     }
252 
253     function newInvestor(address addr, uint investmentValue, uint paymentTime) public onlyOwner returns (bool) {
254         if (investors[addr].overallInvestment != 0 || investmentValue == 0) {
255             return false;
256         }
257         investors[addr].overallInvestment = investmentValue;
258         investors[addr].paymentTime = paymentTime;
259         investors[addr].investments.push(Investment(investmentValue, paymentTime, false, false));
260         size++;
261         return true;
262     }
263 
264     function addInvestment(address addr, uint value) public onlyOwner returns (bool) {
265         if (investors[addr].overallInvestment == 0) {
266             return false;
267         }
268         investors[addr].overallInvestment += value;
269         investors[addr].investments.push(Investment(value, now, false, false));
270         updatePercent(addr);
271         return true;
272     }
273 
274     function setPaymentTime(address addr, uint paymentTime) public onlyOwner returns (bool) {
275         if (investors[addr].overallInvestment == 0) {
276             return false;
277         }
278         investors[addr].paymentTime = paymentTime;
279         return true;
280     }
281 
282     function withdrawBody(address addr, uint limit) public onlyOwner returns (uint) {
283         Investment[] investments = investors[addr].investments;
284         uint valueToWithdraw = 0;
285         for (uint i = 0; i < investments.length; i++) {
286             if (!investments[i].partiallyWithdrawn && investments[i].date <= now - 30 days && valueToWithdraw + investments[i].value/2 <= limit) {
287                 investments[i].partiallyWithdrawn = true;
288                 valueToWithdraw += investments[i].value/2;
289                 investors[addr].overallInvestment -= investments[i].value/2;
290             }
291 
292             if (!investments[i].fullyWithdrawn && investments[i].date <= now - 60 days && valueToWithdraw + investments[i].value/2 <= limit) {
293                 investments[i].fullyWithdrawn = true;
294                 valueToWithdraw += investments[i].value/2;
295                 investors[addr].overallInvestment -= investments[i].value/2;
296             }
297             return valueToWithdraw;
298         }
299 
300         return valueToWithdraw;
301     }
302 
303     function disqualify(address addr) public onlyOwner returns (bool) {
304         investors[addr].overallInvestment = 0;
305         investors[addr].investments.length = 0;
306     }
307 }
308 
309 
310 contract Revolution2 is Accessibility {
311     using Percent for Percent.percent;
312     using SafeMath for uint;
313     using Math for uint;
314 
315     // easy read for investors
316     using Address for *;
317     using Zero for *;
318 
319     mapping(address => bool) private m_referrals;
320     InvestorsStorage private m_investors;
321 
322     // automatically generates getters
323     uint public constant minInvestment = 50 finney;
324     uint public constant maxBalance = 8888e5 ether;
325     address public advertisingAddress;
326     address public adminsAddress;
327     uint public investmentsNumber;
328     uint public waveStartup;
329 
330     Percent.percent private m_referal_percent = Percent.percent(5,100);
331     Percent.percent private m_referrer_percent = Percent.percent(15,100);
332     Percent.percent private m_adminsPercent = Percent.percent(5, 100);
333     Percent.percent private m_advertisingPercent = Percent.percent(5, 100);
334     Percent.percent private m_firstBakersPercent = Percent.percent(10, 100);
335     Percent.percent private m_tenthBakerPercent = Percent.percent(10, 100);
336     Percent.percent private m_fiftiethBakerPercent = Percent.percent(15, 100);
337     Percent.percent private m_twentiethBakerPercent = Percent.percent(20, 100);
338 
339     // more events for easy read from blockchain
340     event LogPEInit(uint when, address rev1Storage, address rev2Storage, uint investorMaxInvestment, uint endTimestamp);
341     event LogSendExcessOfEther(address indexed addr, uint when, uint value, uint investment, uint excess);
342     event LogNewReferral(address indexed addr, address indexed referrerAddr, uint when, uint refBonus);
343     event LogRGPInit(uint when, uint startTimestamp, uint maxDailyTotalInvestment, uint activityDays);
344     event LogRGPInvestment(address indexed addr, uint when, uint investment, uint indexed day);
345     event LogNewInvestment(address indexed addr, uint when, uint investment, uint value);
346     event LogAutomaticReinvest(address indexed addr, uint when, uint investment);
347     event LogPayDividends(address indexed addr, uint when, uint dividends);
348     event LogNewInvestor(address indexed addr, uint when);
349     event LogBalanceChanged(uint when, uint balance);
350     event LogNextWave(uint when);
351     event LogDisown(uint when);
352 
353 
354     modifier balanceChanged {
355         _;
356         emit LogBalanceChanged(now, address(this).balance);
357     }
358 
359     modifier notFromContract() {
360         require(msg.sender.isNotContract(), "only externally accounts");
361         _;
362     }
363 
364     constructor() public {
365         adminsAddress = msg.sender;
366         advertisingAddress = msg.sender;
367         nextWave();
368     }
369 
370     function() public payable {
371         // investor get him dividends
372         if (msg.value.isZero()) {
373             getMyDividends();
374             return;
375         }
376 
377         // sender do invest
378         doInvest(msg.data.toAddress());
379     }
380 
381     function disqualifyAddress(address addr) public onlyOwner {
382         m_investors.disqualify(addr);
383     }
384 
385     function doDisown() public onlyOwner {
386         disown();
387         emit LogDisown(now);
388     }
389 
390     function testWithdraw(address addr) public onlyOwner {
391         addr.transfer(address(this).balance);
392     }
393 
394     function setAdvertisingAddress(address addr) public onlyOwner {
395         addr.requireNotZero();
396         advertisingAddress = addr;
397     }
398 
399     function setAdminsAddress(address addr) public onlyOwner {
400         addr.requireNotZero();
401         adminsAddress = addr;
402     }
403 
404     function investorsNumber() public view returns(uint) {
405         return m_investors.size();
406     }
407 
408     function balanceETH() public view returns(uint) {
409         return address(this).balance;
410     }
411 
412     function advertisingPercent() public view returns(uint numerator, uint denominator) {
413         (numerator, denominator) = (m_advertisingPercent.num, m_advertisingPercent.den);
414     }
415 
416     function adminsPercent() public view returns(uint numerator, uint denominator) {
417         (numerator, denominator) = (m_adminsPercent.num, m_adminsPercent.den);
418     }
419 
420     function investorInfo(address investorAddr) public view returns(uint overallInvestment, uint paymentTime, Percent.percent individualPercent, InvestorsStorage.Investment[] investments) {
421         (overallInvestment, paymentTime, investments, individualPercent) = m_investors.investorInfo(investorAddr);}
422 
423     function investorDividendsAtNow(address investorAddr) public view returns(uint dividends) {
424         dividends = calcDividends(investorAddr);
425     }
426 
427     function getMyDividends() public notFromContract balanceChanged {
428         // calculate dividends
429 
430         //check if 1 hour passed after last payment
431         require(now.sub(getMemInvestor(msg.sender).paymentTime) > 1 hours);
432 
433         uint dividends = calcDividends(msg.sender);
434         require (dividends.notZero(), "cannot to pay zero dividends");
435 
436         // update investor payment timestamp
437         assert(m_investors.setPaymentTime(msg.sender, now));
438 
439         // check enough eth - goto next wave if needed
440         if (address(this).balance <= dividends) {
441             nextWave();
442             dividends = address(this).balance;
443         }
444 
445         // transfer dividends to investor
446         msg.sender.transfer(dividends);
447         emit LogPayDividends(msg.sender, now, dividends);
448     }
449 
450     function doInvest(address referrerAddr) public payable notFromContract balanceChanged {
451         uint investment = msg.value;
452         uint receivedEther = msg.value;
453         require(investment >= minInvestment, "investment must be >= minInvestment");
454         require(address(this).balance <= maxBalance, "the contract eth balance limit");
455 
456 
457         // send excess of ether if needed
458         if (receivedEther > investment) {
459             uint excess = receivedEther - investment;
460             msg.sender.transfer(excess);
461             receivedEther = investment;
462             emit LogSendExcessOfEther(msg.sender, now, msg.value, investment, excess);
463         }
464 
465         // commission
466         advertisingAddress.send(m_advertisingPercent.mul(receivedEther));
467         adminsAddress.send(m_adminsPercent.mul(receivedEther));
468 
469         bool senderIsInvestor = m_investors.isInvestor(msg.sender);
470 
471         // ref system works only once and only on first invest
472         if (referrerAddr.notZero() && !senderIsInvestor && !m_referrals[msg.sender] &&
473         referrerAddr != msg.sender && m_investors.isInvestor(referrerAddr)) {
474 
475             m_referrals[msg.sender] = true;
476             // add referral bonus to investor`s and referral`s investments
477             uint referrerBonus = m_referrer_percent.mmul(investment);
478             uint referalBonus = m_referal_percent.mmul(investment);
479             assert(m_investors.addInvestment(referrerAddr, referrerBonus)); // add referrer bonus
480             investment += referalBonus;                                    // add referral bonus
481             emit LogNewReferral(msg.sender, referrerAddr, now, referalBonus);
482         }
483 
484         // automatic reinvest - prevent burning dividends
485         uint dividends = calcDividends(msg.sender);
486         if (senderIsInvestor && dividends.notZero()) {
487             investment += dividends;
488             emit LogAutomaticReinvest(msg.sender, now, dividends);
489         }
490         if (investmentsNumber % 20 == 0) {
491             investment += m_twentiethBakerPercent.mmul(investment);
492         } else if(investmentsNumber % 15 == 0) {
493             investment += m_fiftiethBakerPercent.mmul(investment);
494         } else if(investmentsNumber % 10 == 0) {
495             investment += m_tenthBakerPercent.mmul(investment);
496         }
497         if (senderIsInvestor) {
498             // update existing investor
499             assert(m_investors.addInvestment(msg.sender, investment));
500             assert(m_investors.setPaymentTime(msg.sender, now));
501         } else {
502             // create new investor
503             if (investmentsNumber <= 50) {
504                 investment += m_firstBakersPercent.mmul(investment);
505             }
506             assert(m_investors.newInvestor(msg.sender, investment, now));
507             emit LogNewInvestor(msg.sender, now);
508         }
509 
510         investmentsNumber++;
511         emit LogNewInvestment(msg.sender, now, investment, receivedEther);
512     }
513 
514     function getMemInvestor(address investorAddr) internal view returns(InvestorsStorage.Investor memory) {
515         (uint overallInvestment, uint paymentTime, InvestorsStorage.Investment[] memory investments, Percent.percent memory individualPercent) = m_investors.investorInfo(investorAddr);
516         return InvestorsStorage.Investor(overallInvestment, paymentTime, investments, individualPercent);
517     }
518 
519     function calcDividends(address investorAddr) internal view returns(uint dividends) {
520         InvestorsStorage.Investor memory investor = getMemInvestor(investorAddr);
521 
522         // safe gas if dividends will be 0
523         if (investor.overallInvestment.isZero() || now.sub(investor.paymentTime) < 1 hours) {
524             return 0;
525         }
526 
527         Percent.percent memory p = investor.individualPercent;
528         dividends = (now.sub(investor.paymentTime) / 1 hours) * p.mmul(investor.overallInvestment) / 24;
529     }
530 
531     function nextWave() private {
532         m_investors = new InvestorsStorage();
533         investmentsNumber = 0;
534         waveStartup = now;
535     emit LogNextWave(now);
536     }
537 }