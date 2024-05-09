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
74     string  public constant name    = 'Kassa 200/50';
75     uint public startTimestamp = now;
76 
77     uint public constant procKoef = 10000;
78     uint public constant perDay = 75;
79     uint public constant ownerFee = 700;
80     uint[3] public bonusReferrer = [500, 200, 100];
81 
82     uint public constant procReturn = 9000;
83 
84 
85     uint public constant maxDepositDays = 200;
86 
87 
88     uint public constant minimalDeposit = 0.5 ether;
89     uint public constant maximalDepositStart = 30 ether;
90     uint public constant maximalDepositFinish = 100 ether;
91 
92     uint public constant minimalDepositForBonusReferrer = 0.015 ether;
93 
94     uint public constant dayLimitStart = 50 ether;
95 
96 
97     uint public constant progressProcKoef = 100;
98     uint public constant dayLimitProgressProc = 2;
99     uint public constant maxDepositProgressProc = 1;
100 
101     uint public countInvestors = 0;
102     uint public totalInvest = 0;
103     uint public totalPenalty = 0;
104     uint public totalSelfInvest = 0;
105     uint public totalPaid = 0;
106     uint public unlimitedInvest = 3000 ether;
107     bool public isUnlimitedContractInvest = false;
108     bool public isUnlimitedDayInvest = false;
109 
110     event LogInvestment(address _addr, uint _value, bytes _refData);
111     event LogTransfer(address _addr, uint _amount, uint _contactBalance);
112     event LogSelfInvestment(uint _value);
113 
114     event LogPreparePayment(address _addr, uint _totalInteres, uint _paidInteres, uint _amount);
115     event LogSkipPreparePayment(address _addr, uint _totalInteres, uint _paidInteres);
116 
117     event LogPreparePaymentReferrer(address _addr, uint _totalReferrals, uint _paidReferrals, uint _amount);
118     event LogSkipPreparePaymentReferrer(address _addr, uint _totalReferrals, uint _paidReferrals);
119     event LogNewReferralAtLevel(address _addr, uint[3] _levels);
120 
121     event LogMinimalDepositPayment(address _addr, uint _money, uint _totalPenalty);
122     event LogPenaltyPayment(address _addr, uint currentSenderDeposit, uint referrerAdressLength, address _referrer, uint currentReferrerDeposit, uint _money, uint _sendBackAmount, uint _totalPenalty);
123     event LogExceededRestDepositPerDay(address _addr, address _referrer, uint _money, uint _nDay, uint _restDepositPerDay, uint _badDeposit, uint _sendBackAmount, uint _totalPenalty, uint _willDeposit);
124 
125     event LogUsedRestDepositPerDay(address _addr, address _referrer, uint _money, uint _nDay, uint _restDepositPerDay, uint _realDeposit, uint _usedDepositPerDay);
126     event LogCalcBonusReferrer(address _referrer, uint _money, uint _index, uint _bonusReferrer, uint _amountReferrer, address _nextReferrer);
127 
128 
129     struct User
130     {
131         uint balance;
132         uint paidInteres;
133         uint timestamp;
134         uint countReferrals;
135         uint[3] countReferralsByLevel;
136         uint earnOnReferrals;
137         uint paidReferrals;
138         address referrer;
139     }
140 
141     mapping (address => User) private user;
142 
143     mapping (uint => uint) private usedDeposit;
144 
145     function getInteres(address addr) private view returns(uint interes)
146     {
147         uint diffDays = getNDay(user[addr].timestamp);
148 
149         if( diffDays > maxDepositDays ) diffDays = maxDepositDays;
150 
151         interes = user[addr].balance.mul(perDay).mul(diffDays).div(procKoef);
152     }
153 
154     function getUser(address addr) public view returns(uint balance, uint timestamp, uint paidInteres, uint totalInteres, uint countReferrals, uint[3] countReferralsByLevel, uint earnOnReferrals, uint paidReferrals, address referrer)
155     {
156         address a = addr;
157         return (
158         user[a].balance,
159         user[a].timestamp,
160         user[a].paidInteres,
161         getInteres(a),
162         user[a].countReferrals,
163         user[a].countReferralsByLevel,
164         user[a].earnOnReferrals,
165         user[a].paidReferrals,
166         user[a].referrer
167         );
168     }
169 
170     function getCurrentDay() public view returns(uint nday)
171     {
172         nday = getNDay(startTimestamp);
173     }
174 
175     function getNDay(uint date) public view returns(uint nday)
176     {
177         uint diffTime = date > 0 ? now.sub(date) : 0;
178 
179         nday = diffTime.div(24 hours);
180     }
181 
182     function getCurrentDayDepositLimit() public view returns(uint limit)
183     {
184         if (isUnlimitedDayInvest) {
185             limit = maximalDepositFinish;
186             return limit;
187         }
188 
189         uint nDay = getCurrentDay();
190 
191         uint dayDepositLimit = getDayDepositLimit(nDay);
192 
193         if (dayDepositLimit <= maximalDepositFinish)
194         {
195             limit = dayDepositLimit;
196         }
197         else
198         {
199             limit = maximalDepositFinish;
200         }
201     }
202 
203     function calcProgress(uint start, uint proc, uint nDay) public pure returns(uint res)
204     {
205         uint s = start;
206 
207         uint base = 1 ether;
208 
209         if (proc == 1)
210         {
211             s = s + base.mul(nDay.mul(nDay).mul(35).div(10000)) + base.mul(nDay.mul(4589).div(10000));
212         }
213         else
214         {
215             s = s + base.mul(nDay.mul(nDay).mul(141).div(10000)) + base.mul(nDay.mul(8960).div(10000));
216         }
217 
218         return s;
219     }
220 
221     function getDayDepositLimit(uint nDay) public pure returns(uint limit)
222     {
223         return calcProgress(dayLimitStart, dayLimitProgressProc, nDay );
224     }
225 
226     function getMaximalDeposit(uint nDay) public pure returns(uint limit)
227     {
228         return calcProgress(maximalDepositStart, maxDepositProgressProc, nDay );
229     }
230 
231     function getCurrentDayRestDepositLimit() public view returns(uint restLimit)
232     {
233         uint nDay = getCurrentDay();
234 
235         restLimit = getDayRestDepositLimit(nDay);
236     }
237 
238     function getDayRestDepositLimit(uint nDay) public view returns(uint restLimit)
239     {
240         restLimit = getCurrentDayDepositLimit().sub(usedDeposit[nDay]);
241     }
242 
243     function getCurrentMaximalDeposit() public view returns(uint maximalDeposit)
244     {
245         uint nDay = getCurrentDay();
246 
247         if (isUnlimitedContractInvest)
248         {
249             maximalDeposit = 0;
250         }
251         else
252         {
253             maximalDeposit = getMaximalDeposit(nDay);
254         }
255     }
256 
257     function() external payable
258     {
259         emit LogInvestment(msg.sender, msg.value, msg.data);
260         processPayment(msg.value, msg.data);
261     }
262 
263     function processPayment(uint moneyValue, bytes refData) private
264     {
265         if (msg.sender == laxmi)
266         {
267             totalSelfInvest = totalSelfInvest.add(moneyValue);
268             emit LogSelfInvestment(moneyValue);
269             return;
270         }
271 
272         if (moneyValue == 0)
273         {
274             preparePayment();
275             return;
276         }
277 
278         if (moneyValue < minimalDeposit)
279         {
280             totalPenalty = totalPenalty.add(moneyValue);
281             emit LogMinimalDepositPayment(msg.sender, moneyValue, totalPenalty);
282 
283             return;
284         }
285 
286         checkLimits(moneyValue);
287 
288         address referrer = bytesToAddress(refData);
289 
290         if (user[msg.sender].balance > 0 ||
291         refData.length != 20 ||
292         (!isUnlimitedContractInvest && moneyValue > getCurrentMaximalDeposit()) ||
293         referrer != laxmi &&
294         (
295         user[referrer].balance <= 0 ||
296         referrer == msg.sender)
297         )
298         {
299             uint amount = moneyValue.mul(procReturn).div(procKoef);
300 
301             totalPenalty = totalPenalty.add(moneyValue.sub(amount));
302 
303             emit LogPenaltyPayment(msg.sender, user[msg.sender].balance, refData.length, referrer, user[referrer].balance, moneyValue, amount, totalPenalty);
304 
305             msg.sender.transfer(amount);
306 
307             return;
308         }
309 
310 
311 
312         uint nDay = getCurrentDay();
313 
314         uint restDepositPerDay = getDayRestDepositLimit(nDay);
315 
316         uint addDeposit = moneyValue;
317 
318 
319         if (!isUnlimitedDayInvest && moneyValue > restDepositPerDay)
320         {
321             uint returnDeposit = moneyValue.sub(restDepositPerDay);
322 
323             uint returnAmount = returnDeposit.mul(procReturn).div(procKoef);
324 
325             addDeposit = addDeposit.sub(returnDeposit);
326 
327             totalPenalty = totalPenalty.add(returnDeposit.sub(returnAmount));
328 
329             emit LogExceededRestDepositPerDay(msg.sender, referrer, moneyValue, nDay, restDepositPerDay, returnDeposit, returnAmount, totalPenalty, addDeposit);
330 
331             msg.sender.transfer(returnAmount);
332         }
333 
334         usedDeposit[nDay] = usedDeposit[nDay].add(addDeposit);
335 
336         emit LogUsedRestDepositPerDay(msg.sender, referrer, moneyValue, nDay, restDepositPerDay, addDeposit, usedDeposit[nDay]);
337 
338 
339         registerInvestor(referrer);
340         sendOwnerFee(addDeposit);
341         calcBonusReferrers(referrer, addDeposit);
342         updateInvestBalance(addDeposit);
343 
344     }
345 
346 
347     function registerInvestor(address referrer) private
348     {
349         user[msg.sender].timestamp = now;
350         countInvestors++;
351 
352         user[msg.sender].referrer = referrer;
353         //user[referrer].countReferrals++;
354         countReferralsByLevel(referrer, 0);
355     }
356 
357     function countReferralsByLevel(address referrer, uint level) private
358     {
359         if (level > 2)
360         {
361             return;
362         }
363 
364         uint l = level;
365 
366         user[referrer].countReferralsByLevel[l]++;
367 
368         emit LogNewReferralAtLevel(referrer, user[referrer].countReferralsByLevel);
369 
370         address _nextReferrer = user[referrer].referrer;
371 
372         if (_nextReferrer != 0)
373         {
374             l++;
375             countReferralsByLevel(_nextReferrer, l);
376         }
377 
378         return;
379     }
380 
381     function sendOwnerFee(uint addDeposit) private
382     {
383         transfer(laxmi, addDeposit.mul(ownerFee).div(procKoef));
384     }
385 
386     function calcBonusReferrers(address referrer, uint addDeposit) private
387     {
388         address r = referrer;
389 
390         for (uint i = 0; i < bonusReferrer.length && r != 0; i++)
391         {
392             uint amountReferrer = addDeposit.mul(bonusReferrer[i]).div(procKoef);
393 
394             address nextReferrer = user[r].referrer;
395 
396             emit LogCalcBonusReferrer(r, addDeposit, i, bonusReferrer[i], amountReferrer, nextReferrer);
397 
398             preparePaymentReferrer(r, amountReferrer);
399 
400             r = nextReferrer;
401         }
402     }
403 
404     function checkLimits(uint value) private
405     {
406         if (totalInvest + value > unlimitedInvest)
407         {
408             isUnlimitedContractInvest = true;
409         }
410 
411         uint nDay = getCurrentDay();
412 
413         uint dayDepositLimit = getDayDepositLimit(nDay);
414 
415         if (dayDepositLimit > maximalDepositFinish)
416         {
417             isUnlimitedDayInvest = true;
418         }
419 
420     }
421 
422     function preparePaymentReferrer(address referrer, uint amountReferrer) private
423     {
424         user[referrer].earnOnReferrals = user[referrer].earnOnReferrals.add(amountReferrer);
425 
426         uint totalReferrals = user[referrer].earnOnReferrals;
427         uint paidReferrals = user[referrer].paidReferrals;
428 
429 
430         if (totalReferrals >= paidReferrals.add(minimalDepositForBonusReferrer))
431         {
432             uint amount = totalReferrals.sub(paidReferrals);
433 
434             user[referrer].paidReferrals = user[referrer].paidReferrals.add(amount);
435 
436             emit LogPreparePaymentReferrer(referrer, totalReferrals, paidReferrals, amount);
437 
438             transfer(referrer, amount);
439         }
440         else
441         {
442             emit LogSkipPreparePaymentReferrer(referrer, totalReferrals, paidReferrals);
443         }
444 
445     }
446 
447 
448     function preparePayment() public
449     {
450         uint totalInteres = getInteres(msg.sender);
451         uint paidInteres = user[msg.sender].paidInteres;
452         if (totalInteres > paidInteres)
453         {
454             uint amount = totalInteres.sub(paidInteres);
455 
456             emit LogPreparePayment(msg.sender, totalInteres, paidInteres, amount);
457 
458             user[msg.sender].paidInteres = user[msg.sender].paidInteres.add(amount);
459             transfer(msg.sender, amount);
460         }
461         else
462         {
463             emit LogSkipPreparePayment(msg.sender, totalInteres, paidInteres);
464         }
465     }
466 
467     function updateInvestBalance(uint addDeposit) private
468     {
469         user[msg.sender].balance = user[msg.sender].balance.add(addDeposit);
470         totalInvest = totalInvest.add(addDeposit);
471     }
472 
473     function transfer(address receiver, uint amount) private
474     {
475         if (amount > 0)
476         {
477             if (receiver != laxmi) { totalPaid = totalPaid.add(amount); }
478 
479             uint balance = address(this).balance;
480 
481             emit LogTransfer(receiver, amount, balance);
482 
483             require(amount < balance, "Not enough balance. Please retry later.");
484 
485             receiver.transfer(amount);
486         }
487     }
488 
489     function bytesToAddress(bytes source) private pure returns(address addr)
490     {
491         assembly { addr := mload(add(source,0x14)) }
492         return addr;
493     }
494 
495     function getTotals() public view returns(uint _maxDepositDays,
496         uint _perDay,
497         uint _startTimestamp,
498 
499         uint _minimalDeposit,
500         uint _maximalDeposit,
501         uint[3] _bonusReferrer,
502         uint _minimalDepositForBonusReferrer,
503         uint _ownerFee,
504 
505         uint _countInvestors,
506         uint _totalInvest,
507         uint _totalPenalty,
508     //                                             uint _totalSelfInvest,
509         uint _totalPaid,
510 
511         uint _currentDayDepositLimit,
512         uint _currentDayRestDepositLimit)
513     {
514         return (
515         maxDepositDays,
516         perDay,
517         startTimestamp,
518 
519         minimalDeposit,
520         getCurrentMaximalDeposit(),
521         bonusReferrer,
522         minimalDepositForBonusReferrer,
523         ownerFee,
524 
525         countInvestors,
526         totalInvest,
527         totalPenalty,
528         //                 totalSelfInvest,
529         totalPaid,
530 
531         getCurrentDayDepositLimit(),
532         getCurrentDayRestDepositLimit()
533         );
534     }
535 
536 }