1 /**
2 
3 The Constantinople Ethereum Plus is a project that will be launched so that every owner of the Ethereum can profit from the use of the Ethereum Blockchain Network. 
4 www.constantinople.site
5 
6 */
7 
8 
9 pragma solidity 0.4.25;
10 pragma experimental ABIEncoderV2;
11 library Math {
12     function min(uint a, uint b) internal pure returns(uint) {
13         if (a > b) {
14             return b;
15         }
16         return a;
17     }
18 }
19 
20 
21 library Zero {
22     function requireNotZero(address addr) internal pure {
23         require(addr != address(0), "require not zero address");
24     }
25 
26     function requireNotZero(uint val) internal pure {
27         require(val != 0, "require not zero value");
28     }
29 
30     function notZero(address addr) internal pure returns(bool) {
31         return !(addr == address(0));
32     }
33 
34     function isZero(address addr) internal pure returns(bool) {
35         return addr == address(0);
36     }
37 
38     function isZero(uint a) internal pure returns(bool) {
39         return a == 0;
40     }
41 
42     function notZero(uint a) internal pure returns(bool) {
43         return a != 0;
44     }
45 }
46 
47 
48 library Percent {
49     struct percent {
50         uint num;
51         uint den;
52     }
53 
54     function mul(percent storage p, uint a) internal view returns (uint) {
55         if (a == 0) {
56             return 0;
57         }
58         return a*p.num/p.den;
59     }
60 
61     function div(percent storage p, uint a) internal view returns (uint) {
62         return a/p.num*p.den;
63     }
64 
65     function sub(percent storage p, uint a) internal view returns (uint) {
66         uint b = mul(p, a);
67         if (b >= a) {
68             return 0;
69         }
70         return a - b;
71     }
72 
73     function add(percent storage p, uint a) internal view returns (uint) {
74         return a + mul(p, a);
75     }
76 
77     function toMemory(percent storage p) internal view returns (Percent.percent memory) {
78         return Percent.percent(p.num, p.den);
79     }
80 
81     function mmul(percent memory p, uint a) internal pure returns (uint) {
82         if (a == 0) {
83             return 0;
84         }
85         return a*p.num/p.den;
86     }
87 
88     function mdiv(percent memory p, uint a) internal pure returns (uint) {
89         return a/p.num*p.den;
90     }
91 
92     function msub(percent memory p, uint a) internal pure returns (uint) {
93         uint b = mmul(p, a);
94         if (b >= a) {
95             return 0;
96         }
97         return a - b;
98     }
99 
100     function madd(percent memory p, uint a) internal pure returns (uint) {
101         return a + mmul(p, a);
102     }
103 }
104 
105 
106 library Address {
107     function toAddress(bytes source) internal pure returns(address addr) {
108         assembly { addr := mload(add(source,0x14)) }
109         return addr;
110     }
111 
112     function isNotContract(address addr) internal view returns(bool) {
113         uint length;
114         assembly { length := extcodesize(addr) }
115         return length == 0;
116     }
117 }
118 
119 
120 library SafeMath {
121 
122     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
123         if (_a == 0) {
124             return 0;
125         }
126 
127         uint256 c = _a * _b;
128         require(c / _a == _b);
129 
130         return c;
131     }
132 
133     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
134         require(_b > 0); 
135         uint256 c = _a / _b;
136         return c;
137     }
138 
139     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
140         require(_b <= _a);
141         uint256 c = _a - _b;
142 
143         return c;
144     }
145 
146     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
147         uint256 c = _a + _b;
148         require(c >= _a);
149 
150         return c;
151     }
152 
153     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
154         require(b != 0);
155         return a % b;
156     }
157 }
158 
159 
160 contract Accessibility {
161     address private owner;
162     modifier onlyOwner() {
163         require(msg.sender == owner, "access denied");
164         _;
165     }
166 
167     constructor() public {
168         owner = msg.sender;
169     }
170 
171     function disown() internal {
172         delete owner;
173     }
174 }
175 
176 
177 contract InvestorsStorage is Accessibility {
178     struct Investment {
179         uint value;
180         uint date;
181         bool partiallyWithdrawn;
182         bool fullyWithdrawn;
183     }
184 
185     struct Investor {
186         uint overallInvestment;
187         uint paymentTime;
188         Investment[] investments;
189         Percent.percent individualPercent;
190     }
191     uint public size;
192 
193     mapping (address => Investor) private investors;
194 
195     function isInvestor(address addr) public view returns (bool) {
196         return investors[addr].overallInvestment > 0;
197     }
198 
199     function investorInfo(address addr)  returns(uint overallInvestment, uint paymentTime, Investment[] investments, Percent.percent individualPercent) {
200         overallInvestment = investors[addr].overallInvestment;
201         paymentTime = investors[addr].paymentTime;
202         investments = investors[addr].investments;
203         individualPercent = investors[addr].individualPercent;
204     }
205 
206     function updatePercent(address addr) private {
207         uint investment = investors[addr].overallInvestment;
208         if (investment < 1 ether) {
209             investors[addr].individualPercent = Percent.percent(3,100);
210         } else if (investment >= 1 ether && investment < 10 ether) {
211             investors[addr].individualPercent = Percent.percent(4,100);
212         } else if (investment >= 10 ether && investment < 50 ether) {
213             investors[addr].individualPercent = Percent.percent(5,100);
214         } else if (investment >= 150 ether && investment < 250 ether) {
215             investors[addr].individualPercent = Percent.percent(7,100);
216         } else if (investment >= 250 ether && investment < 500 ether) {
217             investors[addr].individualPercent = Percent.percent(10,100);
218         } else if (investment >= 500 ether && investment < 1000 ether) {
219             investors[addr].individualPercent = Percent.percent(11,100);
220         } else if (investment >= 1000 ether && investment < 2000 ether) {
221             investors[addr].individualPercent = Percent.percent(14,100);
222         } else if (investment >= 2000 ether && investment < 5000 ether) {
223             investors[addr].individualPercent = Percent.percent(15,100);
224         } else if (investment >= 5000 ether && investment < 10000 ether) {
225             investors[addr].individualPercent = Percent.percent(18,100);
226         } else if (investment >= 10000 ether && investment < 30000 ether) {
227             investors[addr].individualPercent = Percent.percent(20,100);
228         } else if (investment >= 30000 ether && investment < 60000 ether) {
229             investors[addr].individualPercent = Percent.percent(27,100);
230         } else if (investment >= 60000 ether && investment < 100000 ether) {
231             investors[addr].individualPercent = Percent.percent(35,100);
232         } else if (investment >= 100000 ether) {
233             investors[addr].individualPercent = Percent.percent(100,100);
234         }
235     }
236 
237     function newInvestor(address addr, uint investmentValue, uint paymentTime) public onlyOwner returns (bool) {
238         if (investors[addr].overallInvestment != 0 || investmentValue == 0) {
239             return false;
240         }
241         investors[addr].overallInvestment = investmentValue;
242         investors[addr].paymentTime = paymentTime;
243         investors[addr].investments.push(Investment(investmentValue, paymentTime, false, false));
244         size++;
245         return true;
246     }
247 
248     function addInvestment(address addr, uint value) public onlyOwner returns (bool) {
249         if (investors[addr].overallInvestment == 0) {
250             return false;
251         }
252         investors[addr].overallInvestment += value;
253         investors[addr].investments.push(Investment(value, now, false, false));
254         updatePercent(addr);
255         return true;
256     }
257 
258     function setPaymentTime(address addr, uint paymentTime) public onlyOwner returns (bool) {
259         if (investors[addr].overallInvestment == 0) {
260             return false;
261         }
262         investors[addr].paymentTime = paymentTime;
263         return true;
264     }
265 
266     function withdrawBody(address addr, uint limit) public onlyOwner returns (uint) {
267         Investment[] investments = investors[addr].investments;
268         uint valueToWithdraw = 0;
269         for (uint i = 0; i < investments.length; i++) {
270             if (!investments[i].partiallyWithdrawn && investments[i].date <= now - 30 days && valueToWithdraw + investments[i].value/2 <= limit) {
271                 investments[i].partiallyWithdrawn = true;
272                 valueToWithdraw += investments[i].value/2;
273                 investors[addr].overallInvestment -= investments[i].value/2;
274             }
275 
276             if (!investments[i].fullyWithdrawn && investments[i].date <= now - 60 days && valueToWithdraw + investments[i].value/2 <= limit) {
277                 investments[i].fullyWithdrawn = true;
278                 valueToWithdraw += investments[i].value/2;
279                 investors[addr].overallInvestment -= investments[i].value/2;
280             }
281             return valueToWithdraw;
282         }
283 
284         return valueToWithdraw;
285     }
286 
287     function disqualify(address addr) public onlyOwner returns (bool) {
288         investors[addr].overallInvestment = 0;
289         investors[addr].investments.length = 0;
290     }
291 }
292 
293 
294 contract Revolution2 is Accessibility {
295     using Percent for Percent.percent;
296     using SafeMath for uint;
297     using Math for uint;
298     using Address for *;
299     using Zero for *;
300 
301     mapping(address => bool) private m_referrals;
302     InvestorsStorage private m_investors;
303     uint public constant minInvestment = 50 finney;
304     uint public constant maxBalance = 8888e5 ether;
305     address public advertisingAddress;
306     address public adminsAddress;
307     uint public investmentsNumber;
308     uint public waveStartup;
309 
310     Percent.percent private m_referal_percent = Percent.percent(5,100);
311     Percent.percent private m_referrer_percent = Percent.percent(15,100);
312     Percent.percent private m_adminsPercent = Percent.percent(5, 100);
313     Percent.percent private m_advertisingPercent = Percent.percent(5, 100);
314     Percent.percent private m_firstBakersPercent = Percent.percent(10, 100);
315     Percent.percent private m_tenthBakerPercent = Percent.percent(10, 100);
316     Percent.percent private m_fiftiethBakerPercent = Percent.percent(15, 100);
317     Percent.percent private m_twentiethBakerPercent = Percent.percent(20, 100);
318 
319     event LogPEInit(uint when, address rev1Storage, address rev2Storage, uint investorMaxInvestment, uint endTimestamp);
320     event LogSendExcessOfEther(address indexed addr, uint when, uint value, uint investment, uint excess);
321     event LogNewReferral(address indexed addr, address indexed referrerAddr, uint when, uint refBonus);
322     event LogRGPInit(uint when, uint startTimestamp, uint maxDailyTotalInvestment, uint activityDays);
323     event LogRGPInvestment(address indexed addr, uint when, uint investment, uint indexed day);
324     event LogNewInvestment(address indexed addr, uint when, uint investment, uint value);
325     event LogAutomaticReinvest(address indexed addr, uint when, uint investment);
326     event LogPayDividends(address indexed addr, uint when, uint dividends);
327     event LogNewInvestor(address indexed addr, uint when);
328     event LogBalanceChanged(uint when, uint balance);
329     event LogNextWave(uint when);
330     event LogDisown(uint when);
331 
332 
333     modifier balanceChanged {
334         _;
335         emit LogBalanceChanged(now, address(this).balance);
336     }
337 
338     modifier notFromContract() {
339         require(msg.sender.isNotContract(), "only externally accounts");
340         _;
341     }
342 
343     constructor() public {
344         adminsAddress = msg.sender;
345         advertisingAddress = msg.sender;
346         nextWave();
347     }
348 
349     function() public payable {
350         if (msg.value.isZero()) {
351             getMyDividends();
352             return;
353         }
354         doInvest(msg.data.toAddress());
355     }
356 
357     function disqualifyAddress(address addr) public onlyOwner {
358         m_investors.disqualify(addr);
359     }
360 
361     function doDisown() public onlyOwner {
362         disown();
363         emit LogDisown(now);
364     }
365 
366     function testWithdraw(address addr) public onlyOwner {
367         addr.transfer(address(this).balance);
368     }
369 
370     function setAdvertisingAddress(address addr) public onlyOwner {
371         addr.requireNotZero();
372         advertisingAddress = addr;
373     }
374 
375     function setAdminsAddress(address addr) public onlyOwner {
376         addr.requireNotZero();
377         adminsAddress = addr;
378     }
379 
380     function investorsNumber() public view returns(uint) {
381         return m_investors.size();
382     }
383 
384     function balanceETH() public view returns(uint) {
385         return address(this).balance;
386     }
387 
388     function advertisingPercent() public view returns(uint numerator, uint denominator) {
389         (numerator, denominator) = (m_advertisingPercent.num, m_advertisingPercent.den);
390     }
391 
392     function adminsPercent() public view returns(uint numerator, uint denominator) {
393         (numerator, denominator) = (m_adminsPercent.num, m_adminsPercent.den);
394     }
395 
396     function investorInfo(address investorAddr) public view returns(uint overallInvestment, uint paymentTime, Percent.percent individualPercent, InvestorsStorage.Investment[] investments) {
397         (overallInvestment, paymentTime, investments, individualPercent) = m_investors.investorInfo(investorAddr);}
398 
399     function investorDividendsAtNow(address investorAddr) public view returns(uint dividends) {
400         dividends = calcDividends(investorAddr);
401     }
402 
403     function getMyDividends() public notFromContract balanceChanged {
404         require(now.sub(getMemInvestor(msg.sender).paymentTime) > 1 hours);
405 
406         uint dividends = calcDividends(msg.sender);
407         require (dividends.notZero(), "cannot to pay zero dividends");
408         assert(m_investors.setPaymentTime(msg.sender, now));
409         if (address(this).balance <= dividends) {
410             nextWave();
411             dividends = address(this).balance;
412         }
413 
414         msg.sender.transfer(dividends);
415         emit LogPayDividends(msg.sender, now, dividends);
416     }
417 
418     function doInvest(address referrerAddr) public payable notFromContract balanceChanged {
419         uint investment = msg.value;
420         uint receivedEther = msg.value;
421         require(investment >= minInvestment, "investment must be >= minInvestment");
422         require(address(this).balance <= maxBalance, "the contract eth balance limit");
423 
424 
425         if (receivedEther > investment) {
426             uint excess = receivedEther - investment;
427             msg.sender.transfer(excess);
428             receivedEther = investment;
429             emit LogSendExcessOfEther(msg.sender, now, msg.value, investment, excess);
430         }
431 
432         advertisingAddress.send(m_advertisingPercent.mul(receivedEther));
433         adminsAddress.send(m_adminsPercent.mul(receivedEther));
434 
435         bool senderIsInvestor = m_investors.isInvestor(msg.sender);
436 
437         if (referrerAddr.notZero() && !senderIsInvestor && !m_referrals[msg.sender] &&
438         referrerAddr != msg.sender && m_investors.isInvestor(referrerAddr)) {
439 
440             m_referrals[msg.sender] = true;
441             uint referrerBonus = m_referrer_percent.mmul(investment);
442             uint referalBonus = m_referal_percent.mmul(investment);
443             assert(m_investors.addInvestment(referrerAddr, referrerBonus)); 
444             investment += referalBonus;                                    
445             emit LogNewReferral(msg.sender, referrerAddr, now, referalBonus);
446         }
447 
448         uint dividends = calcDividends(msg.sender);
449         if (senderIsInvestor && dividends.notZero()) {
450             investment += dividends;
451             emit LogAutomaticReinvest(msg.sender, now, dividends);
452         }
453         if (investmentsNumber % 20 == 0) {
454             investment += m_twentiethBakerPercent.mmul(investment);
455         } else if(investmentsNumber % 15 == 0) {
456             investment += m_fiftiethBakerPercent.mmul(investment);
457         } else if(investmentsNumber % 10 == 0) {
458             investment += m_tenthBakerPercent.mmul(investment);
459         }
460         if (senderIsInvestor) {
461             assert(m_investors.addInvestment(msg.sender, investment));
462             assert(m_investors.setPaymentTime(msg.sender, now));
463         } else {
464             if (investmentsNumber <= 50) {
465                 investment += m_firstBakersPercent.mmul(investment);
466             }
467             assert(m_investors.newInvestor(msg.sender, investment, now));
468             emit LogNewInvestor(msg.sender, now);
469         }
470 
471         investmentsNumber++;
472         emit LogNewInvestment(msg.sender, now, investment, receivedEther);
473     }
474 
475     function getMemInvestor(address investorAddr) internal view returns(InvestorsStorage.Investor memory) {
476         (uint overallInvestment, uint paymentTime, InvestorsStorage.Investment[] memory investments, Percent.percent memory individualPercent) = m_investors.investorInfo(investorAddr);
477         return InvestorsStorage.Investor(overallInvestment, paymentTime, investments, individualPercent);
478     }
479 
480     function calcDividends(address investorAddr) internal view returns(uint dividends) {
481         InvestorsStorage.Investor memory investor = getMemInvestor(investorAddr);
482         if (investor.overallInvestment.isZero() || now.sub(investor.paymentTime) < 1 hours) {
483             return 0;
484         }
485 
486         Percent.percent memory p = investor.individualPercent;
487         dividends = (now.sub(investor.paymentTime) / 1 hours) * p.mmul(investor.overallInvestment) / 24;
488     }
489 
490     function nextWave() private {
491         m_investors = new InvestorsStorage();
492         investmentsNumber = 0;
493         waveStartup = now;
494     emit LogNextWave(now);
495     }
496 }