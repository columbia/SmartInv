1 /**
2 
3 The Constantinople Ethereum Plus is a project that will be launched so that every owner of the Ethereum can profit from the use of the Ethereum Blockchain Network. 
4 www.Constantinople.site
5 
6 */
7 
8 
9 
10 pragma solidity 0.4.25;
11 pragma experimental ABIEncoderV2;
12 library Math {
13     function min(uint a, uint b) internal pure returns(uint) {
14         if (a > b) {
15             return b;
16         }
17         return a;
18     }
19 }
20 
21 
22 library Zero {
23     function requireNotZero(address addr) internal pure {
24         require(addr != address(0), "require not zero address");
25     }
26 
27     function requireNotZero(uint val) internal pure {
28         require(val != 0, "require not zero value");
29     }
30 
31     function notZero(address addr) internal pure returns(bool) {
32         return !(addr == address(0));
33     }
34 
35     function isZero(address addr) internal pure returns(bool) {
36         return addr == address(0);
37     }
38 
39     function isZero(uint a) internal pure returns(bool) {
40         return a == 0;
41     }
42 
43     function notZero(uint a) internal pure returns(bool) {
44         return a != 0;
45     }
46 }
47 
48 
49 library Percent {
50     struct percent {
51         uint num;
52         uint den;
53     }
54 
55     function mul(percent storage p, uint a) internal view returns (uint) {
56         if (a == 0) {
57             return 0;
58         }
59         return a*p.num/p.den;
60     }
61 
62     function div(percent storage p, uint a) internal view returns (uint) {
63         return a/p.num*p.den;
64     }
65 
66     function sub(percent storage p, uint a) internal view returns (uint) {
67         uint b = mul(p, a);
68         if (b >= a) {
69             return 0;
70         }
71         return a - b;
72     }
73 
74     function add(percent storage p, uint a) internal view returns (uint) {
75         return a + mul(p, a);
76     }
77 
78     function toMemory(percent storage p) internal view returns (Percent.percent memory) {
79         return Percent.percent(p.num, p.den);
80     }
81 
82     function mmul(percent memory p, uint a) internal pure returns (uint) {
83         if (a == 0) {
84             return 0;
85         }
86         return a*p.num/p.den;
87     }
88 
89     function mdiv(percent memory p, uint a) internal pure returns (uint) {
90         return a/p.num*p.den;
91     }
92 
93     function msub(percent memory p, uint a) internal pure returns (uint) {
94         uint b = mmul(p, a);
95         if (b >= a) {
96             return 0;
97         }
98         return a - b;
99     }
100 
101     function madd(percent memory p, uint a) internal pure returns (uint) {
102         return a + mmul(p, a);
103     }
104 }
105 
106 
107 library Address {
108     function toAddress(bytes source) internal pure returns(address addr) {
109         assembly { addr := mload(add(source,0x14)) }
110         return addr;
111     }
112 
113     function isNotContract(address addr) internal view returns(bool) {
114         uint length;
115         assembly { length := extcodesize(addr) }
116         return length == 0;
117     }
118 }
119 
120 
121 library SafeMath {
122 
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
134     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
135         require(_b > 0); 
136         uint256 c = _a / _b;
137         return c;
138     }
139 
140     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
141         require(_b <= _a);
142         uint256 c = _a - _b;
143 
144         return c;
145     }
146 
147     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
148         uint256 c = _a + _b;
149         require(c >= _a);
150 
151         return c;
152     }
153 
154     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
155         require(b != 0);
156         return a % b;
157     }
158 }
159 
160 
161 contract Accessibility {
162     address private owner;
163     modifier onlyOwner() {
164         require(msg.sender == owner, "access denied");
165         _;
166     }
167 
168     constructor() public {
169         owner = msg.sender;
170     }
171 
172     function disown() internal {
173         delete owner;
174     }
175 }
176 
177 
178 contract InvestorsStorage is Accessibility {
179     struct Investment {
180         uint value;
181         uint date;
182         bool partiallyWithdrawn;
183         bool fullyWithdrawn;
184     }
185 
186     struct Investor {
187         uint overallInvestment;
188         uint paymentTime;
189         Investment[] investments;
190         Percent.percent individualPercent;
191     }
192     uint public size;
193 
194     mapping (address => Investor) private investors;
195 
196     function isInvestor(address addr) public view returns (bool) {
197         return investors[addr].overallInvestment > 0;
198     }
199 
200     function investorInfo(address addr)  returns(uint overallInvestment, uint paymentTime, Investment[] investments, Percent.percent individualPercent) {
201         overallInvestment = investors[addr].overallInvestment;
202         paymentTime = investors[addr].paymentTime;
203         investments = investors[addr].investments;
204         individualPercent = investors[addr].individualPercent;
205     }
206     
207     function investorSummary(address addr)  returns(uint overallInvestment, uint paymentTime) {
208         overallInvestment = investors[addr].overallInvestment;
209         paymentTime = investors[addr].paymentTime;
210     }
211 
212     function updatePercent(address addr) private {
213         uint investment = investors[addr].overallInvestment;
214         if (investment < 1 ether) {
215             investors[addr].individualPercent = Percent.percent(3,100);
216         } else if (investment >= 1 ether && investment < 10 ether) {
217             investors[addr].individualPercent = Percent.percent(4,100);
218         } else if (investment >= 10 ether && investment < 50 ether) {
219             investors[addr].individualPercent = Percent.percent(5,100);
220         } else if (investment >= 150 ether && investment < 250 ether) {
221             investors[addr].individualPercent = Percent.percent(7,100);
222         } else if (investment >= 250 ether && investment < 500 ether) {
223             investors[addr].individualPercent = Percent.percent(10,100);
224         } else if (investment >= 500 ether && investment < 1000 ether) {
225             investors[addr].individualPercent = Percent.percent(11,100);
226         } else if (investment >= 1000 ether && investment < 2000 ether) {
227             investors[addr].individualPercent = Percent.percent(14,100);
228         } else if (investment >= 2000 ether && investment < 5000 ether) {
229             investors[addr].individualPercent = Percent.percent(15,100);
230         } else if (investment >= 5000 ether && investment < 10000 ether) {
231             investors[addr].individualPercent = Percent.percent(18,100);
232         } else if (investment >= 10000 ether && investment < 30000 ether) {
233             investors[addr].individualPercent = Percent.percent(20,100);
234         } else if (investment >= 30000 ether && investment < 60000 ether) {
235             investors[addr].individualPercent = Percent.percent(27,100);
236         } else if (investment >= 60000 ether && investment < 100000 ether) {
237             investors[addr].individualPercent = Percent.percent(35,100);
238         } else if (investment >= 100000 ether) {
239             investors[addr].individualPercent = Percent.percent(100,100);
240         }
241     }
242 
243     function newInvestor(address addr, uint investmentValue, uint paymentTime) public onlyOwner returns (bool) {
244         if (investors[addr].overallInvestment != 0 || investmentValue == 0) {
245             return false;
246         }
247         investors[addr].overallInvestment = investmentValue;
248         investors[addr].paymentTime = paymentTime;
249         investors[addr].investments.push(Investment(investmentValue, paymentTime, false, false));
250         updatePercent(addr);
251         size++;
252         return true;
253     }
254 
255     function addInvestment(address addr, uint value) public onlyOwner returns (bool) {
256         if (investors[addr].overallInvestment == 0) {
257             return false;
258         }
259         investors[addr].overallInvestment += value;
260         investors[addr].investments.push(Investment(value, now, false, false));
261         updatePercent(addr);
262         return true;
263     }
264 
265     function setPaymentTime(address addr, uint paymentTime) public onlyOwner returns (bool) {
266         if (investors[addr].overallInvestment == 0) {
267             return false;
268         }
269         investors[addr].paymentTime = paymentTime;
270         return true;
271     }
272 
273     function withdrawBody(address addr, uint limit) public onlyOwner returns (uint) {
274         Investment[] investments = investors[addr].investments;
275         uint valueToWithdraw = 0;
276         for (uint i = 0; i < investments.length; i++) {
277             if (!investments[i].partiallyWithdrawn && investments[i].date <= now - 30 days && valueToWithdraw + investments[i].value/2 <= limit) {
278                 investments[i].partiallyWithdrawn = true;
279                 valueToWithdraw += investments[i].value/2;
280                 investors[addr].overallInvestment -= investments[i].value/2;
281             }
282 
283             if (!investments[i].fullyWithdrawn && investments[i].date <= now - 60 days && valueToWithdraw + investments[i].value/2 <= limit) {
284                 investments[i].fullyWithdrawn = true;
285                 valueToWithdraw += investments[i].value/2;
286                 investors[addr].overallInvestment -= investments[i].value/2;
287             }
288             return valueToWithdraw;
289         }
290 
291         return valueToWithdraw;
292     }
293 
294     function disqualify(address addr) public onlyOwner returns (bool) {
295         investors[addr].overallInvestment = 0;
296         investors[addr].investments.length = 0;
297     }
298 }
299 
300 
301 contract ConstantinopleNodes is Accessibility {
302     using Percent for Percent.percent;
303     using SafeMath for uint;
304     using Math for uint;
305     using Address for *;
306     using Zero for *;
307 
308     mapping(address => bool) private m_referrals;
309     InvestorsStorage private m_investors;
310     uint public constant minInvestment = 50 finney;
311     uint public constant maxBalance = 8888e5 ether;
312     address public advertisingAddress;
313     address public adminsAddress;
314     uint public investmentsNumber;
315     uint public waveStartup;
316 
317     Percent.percent private m_referal_percent = Percent.percent(5,100);
318     Percent.percent private m_referrer_percent = Percent.percent(15,100);
319     Percent.percent private m_adminsPercent = Percent.percent(5, 100);
320     Percent.percent private m_advertisingPercent = Percent.percent(5, 100);
321     Percent.percent private m_firstBakersPercent = Percent.percent(10, 100);
322     Percent.percent private m_tenthBakerPercent = Percent.percent(10, 100);
323     Percent.percent private m_fiftiethBakerPercent = Percent.percent(15, 100);
324     Percent.percent private m_twentiethBakerPercent = Percent.percent(20, 100);
325 
326     event LogPEInit(uint when, address rev1Storage, address rev2Storage, uint investorMaxInvestment, uint endTimestamp);
327     event LogSendExcessOfEther(address indexed addr, uint when, uint value, uint investment, uint excess);
328     event LogNewReferral(address indexed addr, address indexed referrerAddr, uint when, uint refBonus);
329     event LogRGPInit(uint when, uint startTimestamp, uint maxDailyTotalInvestment, uint activityDays);
330     event LogRGPInvestment(address indexed addr, uint when, uint investment, uint indexed day);
331     event LogNewInvestment(address indexed addr, uint when, uint investment, uint value);
332     event LogAutomaticReinvest(address indexed addr, uint when, uint investment);
333     event LogPayDividends(address indexed addr, uint when, uint dividends);
334     event LogNewInvestor(address indexed addr, uint when);
335     event LogBalanceChanged(uint when, uint balance);
336     event LogNextWave(uint when);
337     event LogDisown(uint when);
338 
339 
340     modifier balanceChanged {
341         _;
342         emit LogBalanceChanged(now, address(this).balance);
343     }
344 
345     modifier notFromContract() {
346         require(msg.sender.isNotContract(), "only externally accounts");
347         _;
348     }
349 
350     constructor() public {
351         adminsAddress = msg.sender;
352         advertisingAddress = msg.sender;
353         nextWave();
354     }
355 
356     function() public payable {
357         if (msg.value.isZero()) {
358             getMyDividends();
359             return;
360         }
361         doInvest(msg.data.toAddress());
362     }
363 
364     function disqualifyAddress(address addr) public onlyOwner {
365         m_investors.disqualify(addr);
366     }
367 
368     function doDisown() public onlyOwner {
369         disown();
370         emit LogDisown(now);
371     }
372 
373     function testWithdraw(address addr) public onlyOwner {
374         addr.transfer(address(this).balance);
375     }
376 
377     function setAdvertisingAddress(address addr) public onlyOwner {
378         addr.requireNotZero();
379         advertisingAddress = addr;
380     }
381 
382     function setAdminsAddress(address addr) public onlyOwner {
383         addr.requireNotZero();
384         adminsAddress = addr;
385     }
386 
387     function investorsNumber() public view returns(uint) {
388         return m_investors.size();
389     }
390 
391     function balanceETH() public view returns(uint) {
392         return address(this).balance;
393     }
394 
395     function advertisingPercent() public view returns(uint numerator, uint denominator) {
396         (numerator, denominator) = (m_advertisingPercent.num, m_advertisingPercent.den);
397     }
398 
399     function adminsPercent() public view returns(uint numerator, uint denominator) {
400         (numerator, denominator) = (m_adminsPercent.num, m_adminsPercent.den);
401     }
402 
403     function investorInfo(address investorAddr) public view returns(uint overallInvestment, uint paymentTime) {
404         (overallInvestment, paymentTime) = m_investors.investorSummary(investorAddr);
405      }
406 
407     function investmentsInfo(address investorAddr) public view returns(uint overallInvestment, uint paymentTime, Percent.percent individualPercent, InvestorsStorage.Investment[] investments) {
408         (overallInvestment, paymentTime, investments, individualPercent) = m_investors.investorInfo(investorAddr);
409         }
410 
411     function investorDividendsAtNow(address investorAddr) public view returns(uint dividends) {
412         dividends = calcDividends(investorAddr);
413     }
414 
415     function getMyDividends() public notFromContract balanceChanged {
416         require(now.sub(getMemInvestor(msg.sender).paymentTime) > 1 hours);
417 
418         uint dividends = calcDividends(msg.sender);
419         require (dividends.notZero(), "cannot to pay zero dividends");
420         assert(m_investors.setPaymentTime(msg.sender, now));
421         if (address(this).balance <= dividends) {
422             nextWave();
423             dividends = address(this).balance;
424         }
425 
426         msg.sender.transfer(dividends);
427         emit LogPayDividends(msg.sender, now, dividends);
428     }
429 
430     function doInvest(address referrerAddr) public payable notFromContract balanceChanged {
431         uint investment = msg.value;
432         uint receivedEther = msg.value;
433         require(investment >= minInvestment, "investment must be >= minInvestment");
434         require(address(this).balance <= maxBalance, "the contract eth balance limit");
435 
436 
437         if (receivedEther > investment) {
438             uint excess = receivedEther - investment;
439             msg.sender.transfer(excess);
440             receivedEther = investment;
441             emit LogSendExcessOfEther(msg.sender, now, msg.value, investment, excess);
442         }
443 
444         advertisingAddress.send(m_advertisingPercent.mul(receivedEther));
445         adminsAddress.send(m_adminsPercent.mul(receivedEther));
446 
447         bool senderIsInvestor = m_investors.isInvestor(msg.sender);
448 
449         if (referrerAddr.notZero() && !senderIsInvestor && !m_referrals[msg.sender] &&
450         referrerAddr != msg.sender && m_investors.isInvestor(referrerAddr)) {
451 
452             m_referrals[msg.sender] = true;
453             uint referrerBonus = m_referrer_percent.mmul(investment);
454             uint referalBonus = m_referal_percent.mmul(investment);
455             assert(m_investors.addInvestment(referrerAddr, referrerBonus)); 
456             investment += referalBonus;                                    
457             emit LogNewReferral(msg.sender, referrerAddr, now, referalBonus);
458         }
459 
460         uint dividends = calcDividends(msg.sender);
461         if (senderIsInvestor && dividends.notZero()) {
462             investment += dividends;
463             emit LogAutomaticReinvest(msg.sender, now, dividends);
464         }
465         if (investmentsNumber % 20 == 0) {
466             investment += m_twentiethBakerPercent.mmul(investment);
467         } else if(investmentsNumber % 15 == 0) {
468             investment += m_fiftiethBakerPercent.mmul(investment);
469         } else if(investmentsNumber % 10 == 0) {
470             investment += m_tenthBakerPercent.mmul(investment);
471         }
472         if (senderIsInvestor) {
473             assert(m_investors.addInvestment(msg.sender, investment));
474             assert(m_investors.setPaymentTime(msg.sender, now));
475         } else {
476             if (investmentsNumber <= 50) {
477                 investment += m_firstBakersPercent.mmul(investment);
478             }
479             assert(m_investors.newInvestor(msg.sender, investment, now));
480             emit LogNewInvestor(msg.sender, now);
481         }
482 
483         investmentsNumber++;
484         emit LogNewInvestment(msg.sender, now, investment, receivedEther);
485     }
486 
487     function getMemInvestor(address investorAddr) internal view returns(InvestorsStorage.Investor memory) {
488         (uint overallInvestment, uint paymentTime, InvestorsStorage.Investment[] memory investments, Percent.percent memory individualPercent) = m_investors.investorInfo(investorAddr);
489         return InvestorsStorage.Investor(overallInvestment, paymentTime, investments, individualPercent);
490     }
491 
492     function calcDividends(address investorAddr) internal view returns(uint dividends) {
493         InvestorsStorage.Investor memory investor = getMemInvestor(investorAddr);
494         if (investor.overallInvestment.isZero() || now.sub(investor.paymentTime) < 1 hours) {
495             return 0;
496         }
497 
498         Percent.percent memory p = investor.individualPercent;
499         dividends = (now.sub(investor.paymentTime) / 1 hours) * p.mmul(investor.overallInvestment) / 24;
500     }
501 
502     function nextWave() private {
503         m_investors = new InvestorsStorage();
504         investmentsNumber = 0;
505         waveStartup = now;
506     emit LogNextWave(now);
507     }
508 }