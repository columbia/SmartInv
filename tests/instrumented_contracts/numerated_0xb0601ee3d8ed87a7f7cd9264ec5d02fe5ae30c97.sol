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
74     string  public constant name    = 'Kassa 100/30';
75     uint public startTimestamp = now;
76 
77     uint public constant procKoef = 10000;
78     uint public constant perDay = 130;
79     uint public constant ownerFee = 800;
80     uint[1] public bonusReferrer = [700];
81 
82     uint public constant procReturn = 9000;
83 
84 
85     uint public constant maxDepositDays = 100;
86 
87 
88     uint public constant minimalDeposit = 0.25 ether;
89     uint public constant maximalDepositStart = 15 ether;
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
119 
120     event LogMinimalDepositPayment(address _addr, uint _money, uint _totalPenalty);
121     event LogPenaltyPayment(address _addr, uint currentSenderDeposit, uint referrerAdressLength, address _referrer, uint currentReferrerDeposit, uint _money, uint _sendBackAmount, uint _totalPenalty);
122     event LogExceededRestDepositPerDay(address _addr, address _referrer, uint _money, uint _nDay, uint _restDepositPerDay, uint _badDeposit, uint _sendBackAmount, uint _totalPenalty, uint _willDeposit);
123 
124     event LogUsedRestDepositPerDay(address _addr, address _referrer, uint _money, uint _nDay, uint _restDepositPerDay, uint _realDeposit, uint _usedDepositPerDay);
125     event LogCalcBonusReferrer(address _referrer, uint _money, uint _index, uint _bonusReferrer, uint _amountReferrer, address _nextReferrer);
126 
127 
128     struct User
129     {
130         uint balance;
131         uint paidInteres;
132         uint timestamp;
133         uint countReferrals;
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
152     function getUser(address addr) public view returns(uint balance, uint timestamp, uint paidInteres, uint totalInteres, uint countReferrals, uint earnOnReferrals, uint paidReferrals, address referrer)
153     {
154         address a = addr;
155         return (
156         user[a].balance,
157         user[a].timestamp,
158         user[a].paidInteres,
159         getInteres(a),
160         user[a].countReferrals,
161         user[a].earnOnReferrals,
162         user[a].paidReferrals,
163         user[a].referrer
164         );
165     }
166 
167     function getCurrentDay() public view returns(uint nday)
168     {
169         nday = getNDay(startTimestamp);
170     }
171 
172     function getNDay(uint date) public view returns(uint nday)
173     {
174         uint diffTime = date > 0 ? now.sub(date) : 0;
175 
176         nday = diffTime.div(24 hours);
177     }
178 
179     function getCurrentDayDepositLimit() public view returns(uint limit)
180     {
181         if (isUnlimitedDayInvest) {
182             limit = maximalDepositFinish;
183             return limit;
184         }
185 
186         uint nDay = getCurrentDay();
187 
188         uint dayDepositLimit = getDayDepositLimit(nDay);
189 
190         if (dayDepositLimit <= maximalDepositFinish)
191         {
192             limit = dayDepositLimit;
193         }
194         else
195         {
196             limit = maximalDepositFinish;
197         }
198 
199     }
200 
201     function calcProgress(uint start, uint proc, uint nDay) public pure returns(uint res)
202     {
203         uint s = start;
204 
205         uint base = 1 ether;
206 
207         if (proc == 1)
208         {
209             s = s + base.mul(nDay.mul(nDay).mul(35).div(10000)) + base.mul(nDay.mul(4589).div(10000));
210         }
211         else
212         {
213             s = s + base.mul(nDay.mul(nDay).mul(141).div(10000)) + base.mul(nDay.mul(8960).div(10000));
214         }
215 
216         return s;
217     }
218 
219     function getDayDepositLimit(uint nDay) public pure returns(uint limit)
220     {
221         return calcProgress(dayLimitStart, dayLimitProgressProc, nDay );
222     }
223 
224     function getMaximalDeposit(uint nDay) public pure returns(uint limit)
225     {
226         return calcProgress(maximalDepositStart, maxDepositProgressProc, nDay );
227     }
228 
229     function getCurrentDayRestDepositLimit() public view returns(uint restLimit)
230     {
231         uint nDay = getCurrentDay();
232 
233         restLimit = getDayRestDepositLimit(nDay);
234     }
235 
236     function getDayRestDepositLimit(uint nDay) public view returns(uint restLimit)
237     {
238         restLimit = getCurrentDayDepositLimit().sub(usedDeposit[nDay]);
239     }
240 
241     function getCurrentMaximalDeposit() public view returns(uint maximalDeposit)
242     {
243         uint nDay = getCurrentDay();
244 
245         if (isUnlimitedContractInvest)
246         {
247             maximalDeposit = 0;
248         }
249         else
250         {
251             maximalDeposit = getMaximalDeposit(nDay);
252         }
253     }
254 
255     function() external payable
256     {
257         emit LogInvestment(msg.sender, msg.value, msg.data);
258         processPayment(msg.value, msg.data);
259     }
260 
261     function processPayment(uint moneyValue, bytes refData) private
262     {
263         if (msg.sender == laxmi)
264         {
265             totalSelfInvest = totalSelfInvest.add(moneyValue);
266             emit LogSelfInvestment(moneyValue);
267             return;
268         }
269 
270         if (moneyValue == 0)
271         {
272             preparePayment();
273             return;
274         }
275 
276         if (moneyValue < minimalDeposit)
277         {
278             totalPenalty = totalPenalty.add(moneyValue);
279             emit LogMinimalDepositPayment(msg.sender, moneyValue, totalPenalty);
280 
281             return;
282         }
283 
284         checkLimits(moneyValue);
285 
286         address referrer = bytesToAddress(refData);
287 
288         if (user[msg.sender].balance > 0 ||
289         refData.length != 20 ||
290         (!isUnlimitedContractInvest && moneyValue > getCurrentMaximalDeposit()) ||
291         referrer != laxmi &&
292         (
293         user[referrer].balance <= 0 ||
294         referrer == msg.sender)
295         )
296         {
297             uint amount = moneyValue.mul(procReturn).div(procKoef);
298 
299             totalPenalty = totalPenalty.add(moneyValue.sub(amount));
300 
301             emit LogPenaltyPayment(msg.sender, user[msg.sender].balance, refData.length, referrer, user[referrer].balance, moneyValue, amount, totalPenalty);
302 
303             msg.sender.transfer(amount);
304 
305             return;
306         }
307 
308 
309 
310         uint nDay = getCurrentDay();
311 
312         uint restDepositPerDay = getDayRestDepositLimit(nDay);
313 
314         uint addDeposit = moneyValue;
315 
316 
317         if (!isUnlimitedDayInvest && moneyValue > restDepositPerDay)
318         {
319             uint returnDeposit = moneyValue.sub(restDepositPerDay);
320 
321             uint returnAmount = returnDeposit.mul(procReturn).div(procKoef);
322 
323             addDeposit = addDeposit.sub(returnDeposit);
324 
325             totalPenalty = totalPenalty.add(returnDeposit.sub(returnAmount));
326 
327             emit LogExceededRestDepositPerDay(msg.sender, referrer, moneyValue, nDay, restDepositPerDay, returnDeposit, returnAmount, totalPenalty, addDeposit);
328 
329             msg.sender.transfer(returnAmount);
330         }
331 
332         usedDeposit[nDay] = usedDeposit[nDay].add(addDeposit);
333 
334         emit LogUsedRestDepositPerDay(msg.sender, referrer, moneyValue, nDay, restDepositPerDay, addDeposit, usedDeposit[nDay]);
335 
336 
337         registerInvestor(referrer);
338         sendOwnerFee(addDeposit);
339         calcBonusReferrers(referrer, addDeposit);
340         updateInvestBalance(addDeposit);
341     }
342 
343 
344     function registerInvestor(address referrer) private
345     {
346         user[msg.sender].timestamp = now;
347         countInvestors++;
348 
349         user[msg.sender].referrer = referrer;
350         user[referrer].countReferrals++;
351     }
352 
353     function sendOwnerFee(uint addDeposit) private
354     {
355         transfer(laxmi, addDeposit.mul(ownerFee).div(procKoef));
356     }
357 
358     function calcBonusReferrers(address referrer, uint addDeposit) private
359     {
360         address r = referrer;
361 
362         for (uint i = 0; i < bonusReferrer.length && r != 0; i++)
363         {
364             uint amountReferrer = addDeposit.mul(bonusReferrer[i]).div(procKoef);
365 
366             address nextReferrer = user[r].referrer;
367 
368             emit LogCalcBonusReferrer(r, addDeposit, i, bonusReferrer[i], amountReferrer, nextReferrer);
369 
370             preparePaymentReferrer(r, amountReferrer);
371 
372             r = nextReferrer;
373         }
374     }
375 
376     function checkLimits(uint value) private
377     {
378         if (totalInvest + value > unlimitedInvest)
379         {
380             isUnlimitedContractInvest = true;
381         }
382 
383         uint nDay = getCurrentDay();
384 
385         uint dayDepositLimit = getDayDepositLimit(nDay);
386 
387         if (dayDepositLimit > maximalDepositFinish)
388         {
389             isUnlimitedDayInvest = true;
390         }
391 
392     }
393 
394     function preparePaymentReferrer(address referrer, uint amountReferrer) private
395     {
396         user[referrer].earnOnReferrals = user[referrer].earnOnReferrals.add(amountReferrer);
397 
398         uint totalReferrals = user[referrer].earnOnReferrals;
399         uint paidReferrals = user[referrer].paidReferrals;
400 
401 
402         if (totalReferrals >= paidReferrals.add(minimalDepositForBonusReferrer))
403         {
404             uint amount = totalReferrals.sub(paidReferrals);
405 
406             user[referrer].paidReferrals = user[referrer].paidReferrals.add(amount);
407 
408             emit LogPreparePaymentReferrer(referrer, totalReferrals, paidReferrals, amount);
409 
410             transfer(referrer, amount);
411         }
412         else
413         {
414             emit LogSkipPreparePaymentReferrer(referrer, totalReferrals, paidReferrals);
415         }
416 
417     }
418 
419 
420     function preparePayment() public
421     {
422         uint totalInteres = getInteres(msg.sender);
423         uint paidInteres = user[msg.sender].paidInteres;
424         if (totalInteres > paidInteres)
425         {
426             uint amount = totalInteres.sub(paidInteres);
427 
428             emit LogPreparePayment(msg.sender, totalInteres, paidInteres, amount);
429 
430             user[msg.sender].paidInteres = user[msg.sender].paidInteres.add(amount);
431             transfer(msg.sender, amount);
432         }
433         else
434         {
435             emit LogSkipPreparePayment(msg.sender, totalInteres, paidInteres);
436         }
437     }
438 
439     function updateInvestBalance(uint addDeposit) private
440     {
441         user[msg.sender].balance = user[msg.sender].balance.add(addDeposit);
442         totalInvest = totalInvest.add(addDeposit);
443     }
444 
445     function transfer(address receiver, uint amount) private
446     {
447         if (amount > 0)
448         {
449             if (receiver != laxmi) { totalPaid = totalPaid.add(amount); }
450 
451             uint balance = address(this).balance;
452 
453             emit LogTransfer(receiver, amount, balance);
454 
455             require(amount < balance, "Not enough balance. Please retry later.");
456 
457             receiver.transfer(amount);
458         }
459     }
460 
461     function bytesToAddress(bytes source) private pure returns(address addr)
462     {
463         assembly { addr := mload(add(source,0x14)) }
464         return addr;
465     }
466 
467     function getTotals() public view returns(uint _maxDepositDays,
468         uint _perDay,
469         uint _startTimestamp,
470 
471         uint _minimalDeposit,
472         uint _maximalDeposit,
473         uint[1] _bonusReferrer,
474         uint _minimalDepositForBonusReferrer,
475         uint _ownerFee,
476 
477         uint _countInvestors,
478         uint _totalInvest,
479         uint _totalPenalty,
480     //                                             uint _totalSelfInvest,
481         uint _totalPaid,
482 
483         uint _currentDayDepositLimit,
484         uint _currentDayRestDepositLimit)
485     {
486         return (
487         maxDepositDays,
488         perDay,
489         startTimestamp,
490 
491         minimalDeposit,
492         getCurrentMaximalDeposit(),
493         bonusReferrer,
494         minimalDepositForBonusReferrer,
495         ownerFee,
496 
497         countInvestors,
498         totalInvest,
499         totalPenalty,
500         //                 totalSelfInvest,
501         totalPaid,
502 
503         getCurrentDayDepositLimit(),
504         getCurrentDayRestDepositLimit()
505         );
506     }
507 
508 }