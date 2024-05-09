1 pragma solidity ^0.4.25;
2 
3 //This smart-contract was developed exclusively for kassa.network
4 //if you need smart-contracts like this, more complicated or more simple, please contact vijaya108@pm.me
5 
6 contract Ownable 
7 {
8     address public laxmi;
9     address public newLaxmi;
10     
11     constructor() public 
12     {
13         laxmi = msg.sender;
14     }
15 
16     modifier onlyLaxmi() 
17     {
18         require(msg.sender == laxmi, "Can used only by owner");
19         _;
20     }
21 
22     function changeLaxmi(address _laxmi) onlyLaxmi public 
23     {
24         require(_laxmi != 0, "Please provide new owner address");
25         newLaxmi = _laxmi;
26     }
27     
28     function confirmLaxmi() public 
29     {
30         require(newLaxmi == msg.sender, "Please call from new owner");
31         laxmi = newLaxmi;
32         delete newLaxmi;
33     }
34 }
35 
36 library SafeMath 
37 {
38 
39     function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) 
40     {
41         if (_a == 0) { return 0; }
42 
43         c = _a * _b;
44         assert(c / _a == _b);
45         return c;
46     }
47 
48     function div(uint256 _a, uint256 _b) internal pure returns (uint256) 
49     {
50         return _a / _b;
51     }
52 
53 
54     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) 
55     {
56         assert(_b <= _a);
57         return _a - _b;
58     }
59 
60 
61     function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) 
62     {
63         c = _a + _b;
64         assert(c >= _a);
65         return c;
66     }
67 }
68 
69 
70 contract KassaNetwork is Ownable 
71 {
72     using SafeMath for uint;
73 
74     string  public constant name    = 'Kassa 400/100';
75     uint public startTimestamp = now;
76 
77     uint public constant procKoef = 10000;
78     uint public constant perDay = 50;
79     uint public constant ownerFee = 500;
80     uint[5] public bonusReferrer = [500, 100, 100, 100, 200];
81 
82     uint public constant procReturn = 9000;
83 
84 
85     uint public constant maxDepositDays = 400;
86 
87 
88     uint public constant minimalDeposit = 1 ether;
89     uint public constant maximalDepositStart = 50 ether;
90     uint public constant maximalDepositFinish = 100 ether;
91 
92     uint public constant minimalDepositForBonusReferrer = 0.015 ether;
93 
94 
95     uint public constant dayLimitStart = 50 ether;
96 
97 
98     uint public constant progressProcKoef = 100;
99     uint public constant dayLimitProgressProc = 2;
100     uint public constant maxDepositProgressProc = 1;
101 
102 
103     uint public countInvestors = 0;
104     uint public totalInvest = 0;
105     uint public totalPenalty = 0;
106     uint public totalSelfInvest = 0;
107     uint public totalPaid = 0;
108 
109     event LogInvestment(address _addr, uint _value, bytes _refData);
110     event LogTransfer(address _addr, uint _amount, uint _contactBalance);
111     event LogSelfInvestment(uint _value);
112 
113     event LogPreparePayment(address _addr, uint _totalInteres, uint _paidInteres, uint _amount);
114     event LogSkipPreparePayment(address _addr, uint _totalInteres, uint _paidInteres);
115 
116     event LogPreparePaymentReferrer(address _addr, uint _totalReferrals, uint _paidReferrals, uint _amount);
117     event LogSkipPreparePaymentReferrer(address _addr, uint _totalReferrals, uint _paidReferrals);
118 
119     event LogMinimalDepositPayment(address _addr, uint _money, uint _totalPenalty);
120     event LogPenaltyPayment(address _addr, uint currentSenderDeposit, uint referrerAdressLength, address _referrer, uint currentReferrerDeposit, uint _money, uint _sendBackAmount, uint _totalPenalty);
121     event LogExceededRestDepositPerDay(address _addr, address _referrer, uint _money, uint _nDay, uint _restDepositPerDay, uint _badDeposit, uint _sendBackAmount, uint _totalPenalty, uint _willDeposit);
122 
123     event LogUsedRestDepositPerDay(address _addr, address _referrer, uint _money, uint _nDay, uint _restDepositPerDay, uint _realDeposit, uint _usedDepositPerDay);
124     event LogCalcBonusReferrer(address _referrer, uint _money, uint _index, uint _bonusReferrer, uint _amountReferrer, address _nextReferrer);
125 
126 
127     struct User
128     {
129         uint balance;
130         uint paidInteres;
131         uint timestamp;
132         uint countReferrals;
133         uint[5] countReferralsByLevel;
134         uint earnOnReferrals;
135         uint paidReferrals;
136         address referrer;
137     }
138 
139     mapping (address => User) private user;
140 
141     mapping (uint => uint) private usedDeposit;
142 
143     function getInteres(address addr) private view returns(uint interes) 
144     {
145         uint diffDays = getNDay(user[addr].timestamp);
146 
147         if( diffDays > maxDepositDays ) diffDays = maxDepositDays;
148 
149         interes = user[addr].balance.mul(perDay).mul(diffDays).div(procKoef);
150     }
151 
152     function getUser(address addr) public view returns(uint balance, uint timestamp, uint paidInteres, uint totalInteres, uint countReferrals, uint[5] countReferralsByLevel, uint earnOnReferrals, uint paidReferrals, address referrer) 
153     {
154         address a = addr;
155         return (
156             user[a].balance,
157             user[a].timestamp,
158             user[a].paidInteres,
159             getInteres(a),
160             user[a].countReferrals,
161             user[a].countReferralsByLevel,
162             user[a].earnOnReferrals,
163             user[a].paidReferrals,
164             user[a].referrer
165         );
166     }
167 
168     function getCurrentDay() public view returns(uint nday) 
169     {
170         nday = getNDay(startTimestamp);
171     }
172 
173     function getNDay(uint date) public view returns(uint nday) 
174     {
175         uint diffTime = date > 0 ? now.sub(date) : 0;
176 
177         nday = diffTime.div(24 hours);
178     }
179 
180     function getCurrentDayDepositLimit() public view returns(uint limit) 
181     {
182         uint nDay = getCurrentDay();
183         
184         uint dayDepositLimit = getDayDepositLimit(nDay);
185 
186         if (dayDepositLimit <= maximalDepositFinish) 
187         {
188             limit = getDayDepositLimit(nDay);
189         } 
190         else 
191         {
192             limit = maximalDepositFinish;
193         }
194     }
195 
196 
197     function calcProgress(uint start, uint proc, uint nDay) public pure returns(uint res) 
198     {
199         uint s = start;
200 
201         for (uint i = 0; i < nDay; i++)
202         {
203             s = s.mul(progressProcKoef + proc).div(progressProcKoef);
204         }
205 
206         return s;
207     }
208 
209     function getDayDepositLimit(uint nDay) public pure returns(uint limit) 
210     {                         
211         return calcProgress(dayLimitStart, dayLimitProgressProc, nDay );
212     }
213 
214     function getMaximalDeposit(uint nDay) public pure returns(uint limit) 
215     {                 
216         return calcProgress(maximalDepositStart, maxDepositProgressProc, nDay );
217     }
218 
219     function getCurrentDayRestDepositLimit() public view returns(uint restLimit) 
220     {
221         uint nDay = getCurrentDay();
222 
223         restLimit = getDayRestDepositLimit(nDay);
224     }
225 
226     function getDayRestDepositLimit(uint nDay) public view returns(uint restLimit) 
227     {
228         restLimit = getCurrentDayDepositLimit().sub(usedDeposit[nDay]);
229     }
230 
231 
232     function getCurrentMaximalDeposit() public view returns(uint maximalDeposit) 
233     {
234         uint nDay = getCurrentDay();
235 
236         maximalDeposit = getMaximalDeposit(nDay);
237         
238         if (totalInvest > 3000 ether)
239         {
240             maximalDeposit = 0;
241         }
242     }
243 
244 
245     function() external payable 
246     {
247         emit LogInvestment(msg.sender, msg.value, msg.data);
248         processPayment(msg.value, msg.data);
249     }
250 
251     function processPayment(uint moneyValue, bytes refData) private
252     {
253         if (msg.sender == laxmi) 
254         { 
255             totalSelfInvest = totalSelfInvest.add(moneyValue);
256             emit LogSelfInvestment(moneyValue);
257             return; 
258         }
259 
260         if (moneyValue == 0) 
261         { 
262             preparePayment();
263             return; 
264         }
265 
266         if (moneyValue < minimalDeposit) 
267         { 
268             totalPenalty = totalPenalty.add(moneyValue);
269             emit LogMinimalDepositPayment(msg.sender, moneyValue, totalPenalty);
270             return; 
271         }
272 
273         address referrer = bytesToAddress(refData);
274 
275         if (user[msg.sender].balance > 0 || 
276             refData.length != 20 || 
277             moneyValue > getCurrentMaximalDeposit() ||
278             referrer != laxmi &&
279               (
280                  user[referrer].balance <= 0 || 
281                  referrer == msg.sender) 
282               )
283         { 
284             uint amount = moneyValue.mul(procReturn).div(procKoef);
285 
286             totalPenalty = totalPenalty.add(moneyValue.sub(amount));
287 
288             emit LogPenaltyPayment(msg.sender, user[msg.sender].balance, refData.length, referrer, user[referrer].balance, moneyValue, amount, totalPenalty);
289 
290             msg.sender.transfer(amount);
291 
292             return; 
293         }
294 
295 
296 
297         uint nDay = getCurrentDay();
298 
299         uint restDepositPerDay = getDayRestDepositLimit(nDay);
300 
301         uint addDeposit = moneyValue;
302 
303 
304         if (moneyValue > restDepositPerDay)
305         {
306             uint returnDeposit = moneyValue.sub(restDepositPerDay);
307 
308             uint returnAmount = returnDeposit.mul(procReturn).div(procKoef);
309 
310             addDeposit = addDeposit.sub(returnDeposit);
311 
312             totalPenalty = totalPenalty.add(returnDeposit.sub(returnAmount));
313 
314             emit LogExceededRestDepositPerDay(msg.sender, referrer, moneyValue, nDay, restDepositPerDay, returnDeposit, returnAmount, totalPenalty, addDeposit);
315 
316             msg.sender.transfer(returnAmount);
317         }
318 
319         usedDeposit[nDay] = usedDeposit[nDay].add(addDeposit);
320 
321         emit LogUsedRestDepositPerDay(msg.sender, referrer, moneyValue, nDay, restDepositPerDay, addDeposit, usedDeposit[nDay]);
322 
323 
324         registerInvestor(referrer);
325         sendOwnerFee(addDeposit);
326         calcBonusReferrers(referrer, addDeposit);
327         updateInvestBalance(addDeposit);
328     }
329 
330 
331     function registerInvestor(address referrer) private 
332     {
333         user[msg.sender].timestamp = now;
334         countInvestors++;
335 
336         user[msg.sender].referrer = referrer;
337         
338         //user[referrer].countReferrals++;
339         countReferralsByLevel(referrer, 0);
340     }
341     
342     function countReferralsByLevel(address referrer, uint level) private
343     {
344         if (level > 5) 
345         {
346             return;
347         }
348         
349         user[referrer].countReferralsByLevel[level]++;
350         
351         address _nextReferrer = user[referrer].referrer;
352         
353         if (_nextReferrer != 0) 
354         {
355             level++;
356             countReferralsByLevel(_nextReferrer, level);
357         }
358         
359         return;
360     }
361 
362     function sendOwnerFee(uint addDeposit) private 
363     {
364         transfer(laxmi, addDeposit.mul(ownerFee).div(procKoef));
365     }
366 
367     function calcBonusReferrers(address referrer, uint addDeposit) private 
368     {
369         for (uint i = 0; i < bonusReferrer.length && referrer != 0; i++)
370         {
371             uint amountReferrer = addDeposit.mul(bonusReferrer[i]).div(procKoef);
372 
373             address nextReferrer = user[referrer].referrer;
374 
375             emit LogCalcBonusReferrer(referrer, addDeposit, i, bonusReferrer[i], amountReferrer, nextReferrer);
376 
377             preparePaymentReferrer(referrer, amountReferrer);
378 
379             referrer = nextReferrer;
380         }
381     }
382 
383 
384     function preparePaymentReferrer(address referrer, uint amountReferrer) private 
385     {
386         user[referrer].earnOnReferrals = user[referrer].earnOnReferrals.add(amountReferrer);
387 
388         uint totalReferrals = user[referrer].earnOnReferrals;
389         uint paidReferrals = user[referrer].paidReferrals;
390 
391 
392         if (totalReferrals >= paidReferrals.add(minimalDepositForBonusReferrer)) 
393         {
394             uint amount = totalReferrals.sub(paidReferrals);
395 
396             user[referrer].paidReferrals = user[referrer].paidReferrals.add(amount);
397 
398             emit LogPreparePaymentReferrer(referrer, totalReferrals, paidReferrals, amount);
399 
400             transfer(referrer, amount);
401         }
402         else
403         {
404             emit LogSkipPreparePaymentReferrer(referrer, totalReferrals, paidReferrals);
405         }
406 
407     }
408 
409 
410     function preparePayment() public 
411     {
412         uint totalInteres = getInteres(msg.sender);
413         uint paidInteres = user[msg.sender].paidInteres;
414         if (totalInteres > paidInteres) 
415         {
416             uint amount = totalInteres.sub(paidInteres);
417 
418             emit LogPreparePayment(msg.sender, totalInteres, paidInteres, amount);
419 
420             user[msg.sender].paidInteres = user[msg.sender].paidInteres.add(amount);
421             transfer(msg.sender, amount);
422         }
423         else
424         {
425             emit LogSkipPreparePayment(msg.sender, totalInteres, paidInteres);
426         }
427     }
428 
429     function updateInvestBalance(uint addDeposit) private 
430     {
431         user[msg.sender].balance = user[msg.sender].balance.add(addDeposit);
432         totalInvest = totalInvest.add(addDeposit);
433     }
434 
435     function transfer(address receiver, uint amount) private 
436     {
437         if (amount > 0) 
438         {
439             if (receiver != laxmi) { totalPaid = totalPaid.add(amount); }
440 
441             uint balance = address(this).balance;
442 
443             emit LogTransfer(receiver, amount, balance);
444 
445             require(amount < balance, "Not enough balance. Please retry later.");
446 
447             receiver.transfer(amount);
448         }
449     }
450 
451     function bytesToAddress(bytes source) private pure returns(address addr) 
452     {
453         assembly { addr := mload(add(source,0x14)) }
454         return addr;
455     }
456 
457     function getTotals() public view returns(uint _maxDepositDays, 
458                                              uint _perDay, 
459                                              uint _startTimestamp, 
460 
461                                              uint _minimalDeposit, 
462                                              uint _maximalDeposit, 
463                                              uint[5] _bonusReferrer, 
464                                              uint _minimalDepositForBonusReferrer, 
465                                              uint _ownerFee, 
466 
467                                              uint _countInvestors, 
468                                              uint _totalInvest, 
469                                              uint _totalPenalty, 
470 //                                             uint _totalSelfInvest, 
471                                              uint _totalPaid, 
472 
473                                              uint _currentDayDepositLimit, 
474                                              uint _currentDayRestDepositLimit)
475     {
476         return (
477                  maxDepositDays,
478                  perDay,
479                  startTimestamp,
480 
481                  minimalDeposit,
482                  getCurrentMaximalDeposit(),
483                  bonusReferrer,
484                  minimalDepositForBonusReferrer,
485                  ownerFee,
486 
487                  countInvestors,
488                  totalInvest,
489                  totalPenalty,
490 //                 totalSelfInvest,
491                  totalPaid,
492 
493                  getCurrentDayDepositLimit(),
494                  getCurrentDayRestDepositLimit()
495                );
496     }
497 
498 }