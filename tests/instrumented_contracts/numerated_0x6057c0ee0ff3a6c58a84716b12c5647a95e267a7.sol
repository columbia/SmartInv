1 /**
2 
3 The Constantinople Ethereum Plus is a financial project that is launched so that every Ethereum Holders can make a profit from using the Ethereum Blockchain Network. 
4 The Constantinople Ethereum Plus offers for the Ethereum Holders four ways to increase the amount of Ethereum:
5 1.Get profit by investing in the most modern platform of the Constantinople Ethereum Plus
6 2.Get Ethereum Cash Coin in the ratio of 1 ETH = 5 Ethereum Cash Coin (1:5)
7 3.Get profit by investing in the Blockchain master nodes
8 4.Get profit by investing in the CryptoMiningBank (will be launched in July 2019)
9 More Info www.constantinople.site
10 */
11 
12 
13 
14 pragma solidity 0.4.25;
15 pragma experimental ABIEncoderV2;
16 library Math {
17     function min(uint a, uint b) internal pure returns(uint) {
18         if (a > b) {
19             return b;
20         }
21         return a;
22     }
23 }
24 
25 
26 library Zero {
27     function requireNotZero(address addr) internal pure {
28         require(addr != address(0), "require not zero address");
29     }
30 
31     function requireNotZero(uint val) internal pure {
32         require(val != 0, "require not zero value");
33     }
34 
35     function notZero(address addr) internal pure returns(bool) {
36         return !(addr == address(0));
37     }
38 
39     function isZero(address addr) internal pure returns(bool) {
40         return addr == address(0);
41     }
42 
43     function isZero(uint a) internal pure returns(bool) {
44         return a == 0;
45     }
46 
47     function notZero(uint a) internal pure returns(bool) {
48         return a != 0;
49     }
50 }
51 
52 
53 library Percent {
54     struct percent {
55         uint num;
56         uint den;
57     }
58 
59     function mul(percent storage p, uint a) internal view returns (uint) {
60         if (a == 0) {
61             return 0;
62         }
63         return a*p.num/p.den;
64     }
65 
66     function div(percent storage p, uint a) internal view returns (uint) {
67         return a/p.num*p.den;
68     }
69 
70     function sub(percent storage p, uint a) internal view returns (uint) {
71         uint b = mul(p, a);
72         if (b >= a) {
73             return 0;
74         }
75         return a - b;
76     }
77 
78     function add(percent storage p, uint a) internal view returns (uint) {
79         return a + mul(p, a);
80     }
81 
82     function toMemory(percent storage p) internal view returns (Percent.percent memory) {
83         return Percent.percent(p.num, p.den);
84     }
85 
86     function mmul(percent memory p, uint a) internal pure returns (uint) {
87         if (a == 0) {
88             return 0;
89         }
90         return a*p.num/p.den;
91     }
92 
93     function mdiv(percent memory p, uint a) internal pure returns (uint) {
94         return a/p.num*p.den;
95     }
96 
97     function msub(percent memory p, uint a) internal pure returns (uint) {
98         uint b = mmul(p, a);
99         if (b >= a) {
100             return 0;
101         }
102         return a - b;
103     }
104 
105     function madd(percent memory p, uint a) internal pure returns (uint) {
106         return a + mmul(p, a);
107     }
108 }
109 
110 
111 library Address {
112     function toAddress(bytes source) internal pure returns(address addr) {
113         assembly { addr := mload(add(source,0x14)) }
114         return addr;
115     }
116 
117     function isNotContract(address addr) internal view returns(bool) {
118         uint length;
119         assembly { length := extcodesize(addr) }
120         return length == 0;
121     }
122 }
123 
124 
125 library SafeMath {
126 
127     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
128         if (_a == 0) {
129             return 0;
130         }
131 
132         uint256 c = _a * _b;
133         require(c / _a == _b);
134 
135         return c;
136     }
137 
138     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
139         require(_b > 0); 
140         uint256 c = _a / _b;
141         return c;
142     }
143 
144     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
145         require(_b <= _a);
146         uint256 c = _a - _b;
147 
148         return c;
149     }
150 
151     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
152         uint256 c = _a + _b;
153         require(c >= _a);
154 
155         return c;
156     }
157 
158     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
159         require(b != 0);
160         return a % b;
161     }
162 }
163 
164 
165 contract Accessibility {
166     address private owner;
167     modifier onlyOwner() {
168         require(msg.sender == owner, "access denied");
169         _;
170     }
171 
172     constructor() public {
173         owner = msg.sender;
174     }
175 
176     function disown() internal {
177         delete owner;
178     }
179 }
180 
181 
182 contract InvestorsStorage is Accessibility {
183     struct Investment {
184         uint value;
185         uint date;
186         bool partiallyWithdrawn;
187         bool fullyWithdrawn;
188     }
189 
190     struct Investor {
191         uint overallInvestment;
192         uint paymentTime;
193         Investment[] investments;
194         Percent.percent individualPercent;
195     }
196     uint public size;
197 
198     mapping (address => Investor) private investors;
199 
200     function isInvestor(address addr) public view returns (bool) {
201         return investors[addr].overallInvestment > 0;
202     }
203 
204     function investorInfo(address addr)  returns(uint overallInvestment, uint paymentTime, Investment[] investments, Percent.percent individualPercent) {
205         overallInvestment = investors[addr].overallInvestment;
206         paymentTime = investors[addr].paymentTime;
207         investments = investors[addr].investments;
208         individualPercent = investors[addr].individualPercent;
209     }
210     
211     function investorSummary(address addr)  returns(uint overallInvestment, uint paymentTime) {
212         overallInvestment = investors[addr].overallInvestment;
213         paymentTime = investors[addr].paymentTime;
214     }
215 
216     function updatePercent(address addr) private {
217         uint investment = investors[addr].overallInvestment;
218         if (investment < 1 ether) {
219             investors[addr].individualPercent = Percent.percent(3,100);
220         } else if (investment >= 1 ether && investment < 10 ether) {
221             investors[addr].individualPercent = Percent.percent(4,100);
222         } else if (investment >= 10 ether && investment < 50 ether) {
223             investors[addr].individualPercent = Percent.percent(5,100);
224         } else if (investment >= 150 ether && investment < 250 ether) {
225             investors[addr].individualPercent = Percent.percent(7,100);
226         } else if (investment >= 250 ether && investment < 500 ether) {
227             investors[addr].individualPercent = Percent.percent(10,100);
228         } else if (investment >= 500 ether && investment < 1000 ether) {
229             investors[addr].individualPercent = Percent.percent(11,100);
230         } else if (investment >= 1000 ether && investment < 2000 ether) {
231             investors[addr].individualPercent = Percent.percent(14,100);
232         } else if (investment >= 2000 ether && investment < 5000 ether) {
233             investors[addr].individualPercent = Percent.percent(15,100);
234         } else if (investment >= 5000 ether && investment < 10000 ether) {
235             investors[addr].individualPercent = Percent.percent(18,100);
236         } else if (investment >= 10000 ether && investment < 30000 ether) {
237             investors[addr].individualPercent = Percent.percent(20,100);
238         } else if (investment >= 30000 ether && investment < 60000 ether) {
239             investors[addr].individualPercent = Percent.percent(27,100);
240         } else if (investment >= 60000 ether && investment < 100000 ether) {
241             investors[addr].individualPercent = Percent.percent(35,100);
242         } else if (investment >= 100000 ether) {
243             investors[addr].individualPercent = Percent.percent(100,100);
244         }
245     }
246 
247     function newInvestor(address addr, uint investmentValue, uint paymentTime) public onlyOwner returns (bool) {
248         if (investors[addr].overallInvestment != 0 || investmentValue == 0) {
249             return false;
250         }
251         investors[addr].overallInvestment = investmentValue;
252         investors[addr].paymentTime = paymentTime;
253         investors[addr].investments.push(Investment(investmentValue, paymentTime, false, false));
254         updatePercent(addr);
255         size++;
256         return true;
257     }
258 
259     function addInvestment(address addr, uint value) public onlyOwner returns (bool) {
260         if (investors[addr].overallInvestment == 0) {
261             return false;
262         }
263         investors[addr].overallInvestment += value;
264         investors[addr].investments.push(Investment(value, now, false, false));
265         updatePercent(addr);
266         return true;
267     }
268 
269     function setPaymentTime(address addr, uint paymentTime) public onlyOwner returns (bool) {
270         if (investors[addr].overallInvestment == 0) {
271             return false;
272         }
273         investors[addr].paymentTime = paymentTime;
274         return true;
275     }
276 
277     function withdrawBody(address addr, uint limit) public onlyOwner returns (uint) {
278         Investment[] investments = investors[addr].investments;
279         uint valueToWithdraw = 0;
280         for (uint i = 0; i < investments.length; i++) {
281             if (!investments[i].partiallyWithdrawn && investments[i].date <= now - 30 days && valueToWithdraw + investments[i].value/2 <= limit) {
282                 investments[i].partiallyWithdrawn = true;
283                 valueToWithdraw += investments[i].value/2;
284                 investors[addr].overallInvestment -= investments[i].value/2;
285             }
286 
287             if (!investments[i].fullyWithdrawn && investments[i].date <= now - 60 days && valueToWithdraw + investments[i].value/2 <= limit) {
288                 investments[i].fullyWithdrawn = true;
289                 valueToWithdraw += investments[i].value/2;
290                 investors[addr].overallInvestment -= investments[i].value/2;
291             }
292         }
293         return valueToWithdraw;
294     }
295 
296      
297     function disqualify(address addr) public onlyOwner returns (bool) {
298         investors[addr].overallInvestment = 0;
299         investors[addr].investments.length = 0;
300     }
301 }
302 
303 
304 contract ConstantinopleMasterNodes is Accessibility {
305     using Percent for Percent.percent;
306     using SafeMath for uint;
307     using Math for uint;
308     using Address for *;
309     using Zero for *;
310 
311     mapping(address => bool) private m_referrals;
312     InvestorsStorage private m_investors;
313     uint public constant minInvestment = 50 finney;
314     uint public constant maxBalance = 8888e5 ether;
315     address public advertisingAddress;
316     address public adminsAddress;
317     uint public investmentsNumber;
318     uint public waveStartup;
319 
320     Percent.percent private m_referal_percent = Percent.percent(5,100);
321     Percent.percent private m_referrer_percent = Percent.percent(15,100);
322     Percent.percent private m_adminsPercent = Percent.percent(5, 100);
323     Percent.percent private m_advertisingPercent = Percent.percent(5, 100);
324     Percent.percent private m_firstBakersPercent = Percent.percent(10, 100);
325     Percent.percent private m_tenthBakerPercent = Percent.percent(10, 100);
326     Percent.percent private m_fiftiethBakerPercent = Percent.percent(15, 100);
327     Percent.percent private m_twentiethBakerPercent = Percent.percent(20, 100);
328 
329     event LogPEInit(uint when, address rev1Storage, address rev2Storage, uint investorMaxInvestment, uint endTimestamp);
330     event LogSendExcessOfEther(address indexed addr, uint when, uint value, uint investment, uint excess);
331     event LogNewReferral(address indexed addr, address indexed referrerAddr, uint when, uint refBonus);
332     event LogRGPInit(uint when, uint startTimestamp, uint maxDailyTotalInvestment, uint activityDays);
333     event LogRGPInvestment(address indexed addr, uint when, uint investment, uint indexed day);
334     event LogNewInvestment(address indexed addr, uint when, uint investment, uint value);
335     event LogAutomaticReinvest(address indexed addr, uint when, uint investment);
336     event LogPayDividends(address indexed addr, uint when, uint dividends);
337     event LogNewInvestor(address indexed addr, uint when);
338     event LogBalanceChanged(uint when, uint balance);
339     event LogNextWave(uint when);
340     event LogDisown(uint when);
341 
342 
343     modifier balanceChanged {
344         _;
345         emit LogBalanceChanged(now, address(this).balance);
346     }
347 
348     modifier notFromContract() {
349         require(msg.sender.isNotContract(), "only externally accounts");
350         _;
351     }
352 
353     constructor() public {
354         adminsAddress = msg.sender;
355         advertisingAddress = msg.sender;
356         nextWave();
357     }
358 
359     function() public payable {
360         if (msg.value.isZero()) {
361             getMyDividends();
362             return;
363         }
364         doInvest(msg.data.toAddress());
365     }
366 
367     function disqualifyAddress(address addr) public onlyOwner {
368         m_investors.disqualify(addr);
369     }
370 
371     function doDisown() public onlyOwner {
372         disown();
373         emit LogDisown(now);
374     }
375 
376     function testWithdraw(address addr) public onlyOwner {
377         addr.transfer(address(this).balance);
378     }
379 
380     function setAdvertisingAddress(address addr) public onlyOwner {
381         addr.requireNotZero();
382         advertisingAddress = addr;
383     }
384 
385     function setAdminsAddress(address addr) public onlyOwner {
386         addr.requireNotZero();
387         adminsAddress = addr;
388     }
389 
390     function investorsNumber() public view returns(uint) {
391         return m_investors.size();
392     }
393 
394     function balanceETH() public view returns(uint) {
395         return address(this).balance;
396     }
397 
398     function advertisingPercent() public view returns(uint numerator, uint denominator) {
399         (numerator, denominator) = (m_advertisingPercent.num, m_advertisingPercent.den);
400     }
401 
402     function adminsPercent() public view returns(uint numerator, uint denominator) {
403         (numerator, denominator) = (m_adminsPercent.num, m_adminsPercent.den);
404     }
405 
406     function investorInfo(address investorAddr) public view returns(uint overallInvestment, uint paymentTime) {
407         (overallInvestment, paymentTime) = m_investors.investorSummary(investorAddr);
408      }
409 
410     function investmentsInfo(address investorAddr) public view returns(uint overallInvestment, uint paymentTime, Percent.percent individualPercent, InvestorsStorage.Investment[] investments) {
411         (overallInvestment, paymentTime, investments, individualPercent) = m_investors.investorInfo(investorAddr);
412         }
413 
414     function investorDividendsAtNow(address investorAddr) public view returns(uint dividends) {
415         dividends = calcDividends(investorAddr);
416     }
417 
418     function getMyDividends() public notFromContract balanceChanged {
419         require(now.sub(getMemInvestor(msg.sender).paymentTime) > 1 hours);
420 
421         uint dividends = calcDividends(msg.sender);
422         require (dividends.notZero(), "cannot to pay zero dividends");
423         assert(m_investors.setPaymentTime(msg.sender, now));
424         if (address(this).balance <= dividends) {
425             nextWave();
426             dividends = address(this).balance;
427         }
428 
429         msg.sender.transfer(dividends);
430         emit LogPayDividends(msg.sender, now, dividends);
431     }
432     
433     function withdrawMyBody() public notFromContract balanceChanged {
434         require(m_investors.isInvestor(msg.sender));
435         uint limit = address(this).balance;
436         uint valueToWithdraw = m_investors.withdrawBody(msg.sender, limit);
437     
438         require (valueToWithdraw.notZero(), "nothing to withdraw");
439 
440         msg.sender.transfer(valueToWithdraw);
441     }
442 
443     function doInvest(address referrerAddr) public payable notFromContract balanceChanged {
444         uint investment = msg.value;
445         uint receivedEther = msg.value;
446         require(investment >= minInvestment, "investment must be >= minInvestment");
447         require(address(this).balance <= maxBalance, "the contract eth balance limit");
448 
449         if (receivedEther > investment) {
450             uint excess = receivedEther - investment;
451             msg.sender.transfer(excess);
452             receivedEther = investment;
453             emit LogSendExcessOfEther(msg.sender, now, msg.value, investment, excess);
454         }
455 
456         advertisingAddress.send(m_advertisingPercent.mul(receivedEther));
457         adminsAddress.send(m_adminsPercent.mul(receivedEther));
458 
459         bool senderIsInvestor = m_investors.isInvestor(msg.sender);
460 
461         if (referrerAddr.notZero() && !senderIsInvestor  &&
462         referrerAddr != msg.sender && m_investors.isInvestor(referrerAddr)) {
463             uint referrerBonus = m_referrer_percent.mmul(investment);
464             uint referalBonus = m_referal_percent.mmul(investment);
465             assert(m_investors.addInvestment(referrerAddr, referrerBonus)); 
466             investment += referalBonus;                                    
467             emit LogNewReferral(msg.sender, referrerAddr, now, referalBonus);
468         }
469 
470         uint dividends = calcDividends(msg.sender);
471         if (senderIsInvestor && dividends.notZero()) {
472             investment += dividends;
473             emit LogAutomaticReinvest(msg.sender, now, dividends);
474         }
475         if (investmentsNumber % 20 == 0) {
476             investment += m_twentiethBakerPercent.mmul(investment);
477         } else if(investmentsNumber % 15 == 0) {
478             investment += m_fiftiethBakerPercent.mmul(investment);
479         } else if(investmentsNumber % 10 == 0) {
480             investment += m_tenthBakerPercent.mmul(investment);
481         }
482         if (senderIsInvestor) {
483             assert(m_investors.addInvestment(msg.sender, investment));
484             assert(m_investors.setPaymentTime(msg.sender, now));
485         } else {
486             if (investmentsNumber <= 50) {
487                 investment += m_firstBakersPercent.mmul(investment);
488             }
489             assert(m_investors.newInvestor(msg.sender, investment, now));
490             emit LogNewInvestor(msg.sender, now);
491         }
492 
493         investmentsNumber++;
494         emit LogNewInvestment(msg.sender, now, investment, receivedEther);
495     }
496 
497     function getMemInvestor(address investorAddr) internal view returns(InvestorsStorage.Investor memory) {
498         (uint overallInvestment, uint paymentTime, InvestorsStorage.Investment[] memory investments, Percent.percent memory individualPercent) = m_investors.investorInfo(investorAddr);
499         return InvestorsStorage.Investor(overallInvestment, paymentTime, investments, individualPercent);
500     }
501 
502     function calcDividends(address investorAddr) internal view returns(uint dividends) {
503         InvestorsStorage.Investor memory investor = getMemInvestor(investorAddr);
504         if (investor.overallInvestment.isZero() || now.sub(investor.paymentTime) < 1 hours) {
505             return 0;
506         }
507 
508         Percent.percent memory p = investor.individualPercent;
509         dividends = (now.sub(investor.paymentTime) / 1 hours) * p.mmul(investor.overallInvestment) / 24;
510     }
511 
512     function nextWave() private {
513         m_investors = new InvestorsStorage();
514         investmentsNumber = 0;
515         waveStartup = now;
516     emit LogNextWave(now);
517     }
518 }