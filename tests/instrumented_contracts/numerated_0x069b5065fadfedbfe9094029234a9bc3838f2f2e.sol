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
74     string  public constant name    = "Kassa 400/100";
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
108     uint public unlimitedInvest = 3000 ether;
109     bool public isUnlimitedContractInvest = false;
110     bool public isUnlimitedDayInvest = false;
111 
112     event LogInvestment(address _addr, uint _value, bytes _refData);
113     event LogTransfer(address _addr, uint _amount, uint _contactBalance);
114     event LogSelfInvestment(uint _value);
115 
116     event LogPreparePayment(address _addr, uint _totalInteres, uint _paidInteres, uint _amount);
117     event LogSkipPreparePayment(address _addr, uint _totalInteres, uint _paidInteres);
118 
119     event LogPreparePaymentReferrer(address _addr, uint _totalReferrals, uint _paidReferrals, uint _amount);
120     event LogSkipPreparePaymentReferrer(address _addr, uint _totalReferrals, uint _paidReferrals);
121     event LogNewReferralAtLevel(address _addr, uint[5] _levels);
122 
123     event LogMinimalDepositPayment(address _addr, uint _money, uint _totalPenalty);
124     event LogPenaltyPayment(address _addr, uint currentSenderDeposit, uint referrerAdressLength, address _referrer, uint currentReferrerDeposit, uint _money, uint _sendBackAmount, uint _totalPenalty);
125     event LogExceededRestDepositPerDay(address _addr, address _referrer, uint _money, uint _nDay, uint _restDepositPerDay, uint _badDeposit, uint _sendBackAmount, uint _totalPenalty, uint _willDeposit);
126 
127     event LogUsedRestDepositPerDay(address _addr, address _referrer, uint _money, uint _nDay, uint _restDepositPerDay, uint _realDeposit, uint _usedDepositPerDay);
128     event LogCalcBonusReferrer(address _referrer, uint _money, uint _index, uint _bonusReferrer, uint _amountReferrer, address _nextReferrer);
129 
130 
131     struct User
132     {
133         uint balance;
134         uint paidInteres;
135         uint timestamp;
136         uint countReferrals;
137         uint[5] countReferralsByLevel;
138         uint earnOnReferrals;
139         uint paidReferrals;
140         address referrer;
141     }
142 
143     mapping (address => User) private user;
144 
145     mapping (uint => uint) private usedDeposit;
146 
147     function getInteres(address addr) private view returns(uint interes)
148     {
149         uint diffDays = getNDay(user[addr].timestamp);
150 
151         if( diffDays > maxDepositDays ) diffDays = maxDepositDays;
152 
153         interes = user[addr].balance.mul(perDay).mul(diffDays).div(procKoef);
154     }
155 
156     function getUser(address addr) public view returns(uint balance, uint timestamp, uint paidInteres, uint totalInteres, uint countReferrals, uint[5] countReferralsByLevel, uint earnOnReferrals, uint paidReferrals, address referrer)
157     {
158         address a = addr;
159         return (
160         user[a].balance,
161         user[a].timestamp,
162         user[a].paidInteres,
163         getInteres(a),
164         user[a].countReferrals,
165         user[a].countReferralsByLevel,
166         user[a].earnOnReferrals,
167         user[a].paidReferrals,
168         user[a].referrer
169         );
170     }
171 
172     function getCurrentDay() public view returns(uint nday)
173     {
174         nday = getNDay(startTimestamp);
175     }
176 
177     function getNDay(uint date) public view returns(uint nday)
178     {
179         uint diffTime = date > 0 ? now.sub(date) : 0;
180 
181         nday = diffTime.div(24 hours);
182     }
183 
184     function getCurrentDayDepositLimit() public view returns(uint limit)
185     {
186         if (isUnlimitedDayInvest) {
187             limit = maximalDepositFinish;
188             return limit;
189         }
190 
191         uint nDay = getCurrentDay();
192 
193         uint dayDepositLimit = getDayDepositLimit(nDay);
194 
195         if (dayDepositLimit <= maximalDepositFinish)
196         {
197             limit = dayDepositLimit;
198         }
199         else
200         {
201             limit = maximalDepositFinish;
202         }
203     }
204 
205 
206     function calcProgress(uint start, uint proc, uint nDay) public pure returns(uint res)
207     {
208         uint s = start;
209 
210         uint base = 1 ether;
211 
212         if (proc == 1)
213         {
214             s = s + base.mul(nDay.mul(nDay).mul(35).div(10000)) + base.mul(nDay.mul(4589).div(10000));
215         }
216         else
217         {
218             s = s + base.mul(nDay.mul(nDay).mul(141).div(10000)) + base.mul(nDay.mul(8960).div(10000));
219         }
220 
221         return s;
222     }
223 
224     function getDayDepositLimit(uint nDay) public pure returns(uint limit)
225     {
226         return calcProgress(dayLimitStart, dayLimitProgressProc, nDay );
227     }
228 
229     function getMaximalDeposit(uint nDay) public pure returns(uint limit)
230     {
231         return calcProgress(maximalDepositStart, maxDepositProgressProc, nDay );
232     }
233 
234     function getCurrentDayRestDepositLimit() public view returns(uint restLimit)
235     {
236         uint nDay = getCurrentDay();
237 
238         restLimit = getDayRestDepositLimit(nDay);
239     }
240 
241     function getDayRestDepositLimit(uint nDay) public view returns(uint restLimit)
242     {
243         restLimit = getCurrentDayDepositLimit().sub(usedDeposit[nDay]);
244     }
245 
246 
247     function getCurrentMaximalDeposit() public view returns(uint maximalDeposit)
248     {
249         uint nDay = getCurrentDay();
250 
251         if (isUnlimitedContractInvest)
252         {
253             maximalDeposit = 0;
254         }
255         else
256         {
257             maximalDeposit = getMaximalDeposit(nDay);
258         }
259     }
260 
261 
262     function() external payable
263     {
264         emit LogInvestment(msg.sender, msg.value, msg.data);
265         processPayment(msg.value, msg.data);
266     }
267 
268     function processPayment(uint moneyValue, bytes refData) private
269     {
270         if (msg.sender == laxmi)
271         {
272             totalSelfInvest = totalSelfInvest.add(moneyValue);
273             emit LogSelfInvestment(moneyValue);
274             return;
275         }
276 
277         if (moneyValue == 0)
278         {
279             preparePayment();
280             return;
281         }
282 
283         if (moneyValue < minimalDeposit)
284         {
285             totalPenalty = totalPenalty.add(moneyValue);
286             emit LogMinimalDepositPayment(msg.sender, moneyValue, totalPenalty);
287             return;
288         }
289 
290         checkLimits(moneyValue);
291 
292         address referrer = bytesToAddress(refData);
293 
294         if (user[msg.sender].balance > 0 ||
295         refData.length != 20 ||
296         (!isUnlimitedContractInvest && moneyValue > getCurrentMaximalDeposit()) ||
297         referrer != laxmi &&
298         (
299         user[referrer].balance <= 0 ||
300         referrer == msg.sender)
301         )
302         {
303             uint amount = moneyValue.mul(procReturn).div(procKoef);
304 
305             totalPenalty = totalPenalty.add(moneyValue.sub(amount));
306 
307             emit LogPenaltyPayment(msg.sender, user[msg.sender].balance, refData.length, referrer, user[referrer].balance, moneyValue, amount, totalPenalty);
308 
309             msg.sender.transfer(amount);
310 
311             return;
312         }
313 
314         uint nDay = getCurrentDay();
315 
316         uint restDepositPerDay = getDayRestDepositLimit(nDay);
317 
318         uint addDeposit = moneyValue;
319 
320 
321         if (!isUnlimitedDayInvest && moneyValue > restDepositPerDay)
322         {
323             uint returnDeposit = moneyValue.sub(restDepositPerDay);
324 
325             uint returnAmount = returnDeposit.mul(procReturn).div(procKoef);
326 
327             addDeposit = addDeposit.sub(returnDeposit);
328 
329             totalPenalty = totalPenalty.add(returnDeposit.sub(returnAmount));
330 
331             emit LogExceededRestDepositPerDay(msg.sender, referrer, moneyValue, nDay, restDepositPerDay, returnDeposit, returnAmount, totalPenalty, addDeposit);
332 
333             msg.sender.transfer(returnAmount);
334         }
335 
336         usedDeposit[nDay] = usedDeposit[nDay].add(addDeposit);
337 
338         emit LogUsedRestDepositPerDay(msg.sender, referrer, moneyValue, nDay, restDepositPerDay, addDeposit, usedDeposit[nDay]);
339 
340 
341         registerInvestor(referrer);
342         sendOwnerFee(addDeposit);
343         calcBonusReferrers(referrer, addDeposit);
344         updateInvestBalance(addDeposit);
345 
346     }
347 
348 
349     function registerInvestor(address referrer) private
350     {
351         user[msg.sender].timestamp = now;
352         countInvestors++;
353 
354         user[msg.sender].referrer = referrer;
355 
356         //user[referrer].countReferrals++;
357         countReferralsByLevel(referrer, 0);
358     }
359 
360     function countReferralsByLevel(address referrer, uint level) private
361     {
362         if (level > 4)
363         {
364             return;
365         }
366 
367         uint l = level;
368 
369         user[referrer].countReferralsByLevel[l]++;
370 
371         emit LogNewReferralAtLevel(referrer, user[referrer].countReferralsByLevel);
372 
373         address _nextReferrer = user[referrer].referrer;
374 
375         if (_nextReferrer != 0)
376         {
377             l++;
378 
379             countReferralsByLevel(_nextReferrer, l);
380         }
381 
382         return;
383     }
384 
385     function sendOwnerFee(uint addDeposit) private
386     {
387         transfer(laxmi, addDeposit.mul(ownerFee).div(procKoef));
388     }
389 
390     function calcBonusReferrers(address referrer, uint addDeposit) private
391     {
392         address r = referrer;
393 
394         for (uint i = 0; i < bonusReferrer.length && r != 0; i++)
395         {
396             uint amountReferrer = addDeposit.mul(bonusReferrer[i]).div(procKoef);
397 
398             address nextReferrer = user[r].referrer;
399 
400             emit LogCalcBonusReferrer(r, addDeposit, i, bonusReferrer[i], amountReferrer, nextReferrer);
401 
402             preparePaymentReferrer(r, amountReferrer);
403 
404             r = nextReferrer;
405         }
406     }
407 
408     function checkLimits(uint value) private
409     {
410         if (totalInvest + value > unlimitedInvest)
411         {
412             isUnlimitedContractInvest = true;
413         }
414 
415         uint nDay = getCurrentDay();
416 
417         uint dayDepositLimit = getDayDepositLimit(nDay);
418 
419         if (dayDepositLimit > maximalDepositFinish)
420         {
421             isUnlimitedDayInvest = true;
422         }
423 
424     }
425 
426     function preparePaymentReferrer(address referrer, uint amountReferrer) private
427     {
428         user[referrer].earnOnReferrals = user[referrer].earnOnReferrals.add(amountReferrer);
429 
430         uint totalReferrals = user[referrer].earnOnReferrals;
431         uint paidReferrals = user[referrer].paidReferrals;
432 
433 
434         if (totalReferrals >= paidReferrals.add(minimalDepositForBonusReferrer))
435         {
436             uint amount = totalReferrals.sub(paidReferrals);
437 
438             user[referrer].paidReferrals = user[referrer].paidReferrals.add(amount);
439 
440             emit LogPreparePaymentReferrer(referrer, totalReferrals, paidReferrals, amount);
441 
442             transfer(referrer, amount);
443         }
444         else
445         {
446             emit LogSkipPreparePaymentReferrer(referrer, totalReferrals, paidReferrals);
447         }
448 
449     }
450 
451 
452     function preparePayment() public
453     {
454         uint totalInteres = getInteres(msg.sender);
455         uint paidInteres = user[msg.sender].paidInteres;
456         if (totalInteres > paidInteres)
457         {
458             uint amount = totalInteres.sub(paidInteres);
459 
460             emit LogPreparePayment(msg.sender, totalInteres, paidInteres, amount);
461 
462             user[msg.sender].paidInteres = user[msg.sender].paidInteres.add(amount);
463             transfer(msg.sender, amount);
464         }
465         else
466         {
467             emit LogSkipPreparePayment(msg.sender, totalInteres, paidInteres);
468         }
469     }
470 
471     function updateInvestBalance(uint addDeposit) private
472     {
473         user[msg.sender].balance = user[msg.sender].balance.add(addDeposit);
474         totalInvest = totalInvest.add(addDeposit);
475     }
476 
477     function transfer(address receiver, uint amount) private
478     {
479         if (amount > 0)
480         {
481             if (receiver != laxmi) { totalPaid = totalPaid.add(amount); }
482 
483             uint balance = address(this).balance;
484 
485             emit LogTransfer(receiver, amount, balance);
486 
487             require(amount < balance, "Not enough balance. Please retry later.");
488 
489             receiver.transfer(amount);
490         }
491     }
492 
493     function bytesToAddress(bytes source) private pure returns(address addr)
494     {
495         assembly { addr := mload(add(source,0x14)) }
496         return addr;
497     }
498 
499     function getTotals() public view returns(uint _maxDepositDays,
500         uint _perDay,
501         uint _startTimestamp,
502 
503         uint _minimalDeposit,
504         uint _maximalDeposit,
505         uint[5] _bonusReferrer,
506         uint _minimalDepositForBonusReferrer,
507         uint _ownerFee,
508 
509         uint _countInvestors,
510         uint _totalInvest,
511         uint _totalPenalty,
512     //                                             uint _totalSelfInvest,
513         uint _totalPaid,
514 
515         uint _currentDayDepositLimit,
516         uint _currentDayRestDepositLimit)
517     {
518         return (
519         maxDepositDays,
520         perDay,
521         startTimestamp,
522 
523         minimalDeposit,
524         getCurrentMaximalDeposit(),
525         bonusReferrer,
526         minimalDepositForBonusReferrer,
527         ownerFee,
528 
529         countInvestors,
530         totalInvest,
531         totalPenalty,
532         //                 totalSelfInvest,
533         totalPaid,
534 
535         getCurrentDayDepositLimit(),
536         getCurrentDayRestDepositLimit()
537         );
538     }
539 
540 }