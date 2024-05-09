1 pragma solidity ^0.4.25;
2 
3 
4 contract Ownable 
5 {
6     address public owner;
7     address public newOwner;
8     
9     constructor() public 
10     {
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner() 
15     {
16         require(msg.sender == owner, "Can used only by owner");
17         _;
18     }
19 
20     function changeOwner(address _owner) onlyOwner public 
21     {
22         require(_owner != 0, "Please provide new owner address");
23         newOwner = _owner;
24     }
25     
26     function confirmOwner() public 
27     {
28         require(newOwner == msg.sender, "Please call from new owner");
29         owner = newOwner;
30         delete newOwner;
31     }
32 }
33 
34 library SafeMath 
35 {
36 
37     function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) 
38     {
39         if (_a == 0) { return 0; }
40 
41         c = _a * _b;
42         assert(c / _a == _b);
43         return c;
44     }
45 
46     function div(uint256 _a, uint256 _b) internal pure returns (uint256) 
47     {
48         return _a / _b;
49     }
50 
51 
52     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) 
53     {
54         assert(_b <= _a);
55         return _a - _b;
56     }
57 
58 
59     function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) 
60     {
61         c = _a + _b;
62         assert(c >= _a);
63         return c;
64     }
65 }
66 
67 
68 contract KassaNetwork is Ownable 
69 {
70     using SafeMath for uint;
71 
72     string  public constant name    = 'Kassa 200/100';
73     uint public startTimestamp = now;
74 
75     uint public constant procKoef = 10000;
76     uint public constant perDay = 100;
77     uint public constant ownerFee = 400;
78     uint[4] public bonusReferrer = [600, 200, 100, 50];
79 
80     uint public constant procReturn = 9000;
81 
82 
83     uint public constant maxDepositDays = 200;
84 
85 
86     uint public constant minimalDeposit = 0.5 ether;
87     uint public constant maximalDepositStart = 20 ether;
88 
89     uint public constant minimalDepositForBonusReferrer = 0.015 ether;
90 
91 
92     uint public constant dayLimitStart = 50 ether;
93 
94 
95     uint public constant progressProcKoef = 100;
96     uint public constant dayLimitProgressProc = 2;
97     uint public constant maxDepositProgressProc = 1;
98 
99 
100     uint public countInvestors = 0;
101     uint public totalInvest = 0;
102     uint public totalPenalty = 0;
103     uint public totalSelfInvest = 0;
104     uint public totalPaid = 0;
105 
106     event LogInvestment(address _addr, uint _value, bytes _refData);
107     event LogTransfer(address _addr, uint _amount, uint _contactBalance);
108     event LogSelfInvestment(uint _value);
109 
110     event LogPreparePayment(address _addr, uint _totalInteres, uint _paidInteres, uint _amount);
111     event LogSkipPreparePayment(address _addr, uint _totalInteres, uint _paidInteres);
112 
113     event LogPreparePaymentReferrer(address _addr, uint _totalReferrals, uint _paidReferrals, uint _amount);
114     event LogSkipPreparePaymentReferrer(address _addr, uint _totalReferrals, uint _paidReferrals);
115 
116     event LogMinimalDepositPayment(address _addr, uint _money, uint _totalPenalty);
117     event LogPenaltyPayment(address _addr, uint currentSenderDeposit, uint referrerAdressLength, address _referrer, uint currentReferrerDeposit, uint _money, uint _sendBackAmount, uint _totalPenalty);
118     event LogExceededRestDepositPerDay(address _addr, address _referrer, uint _money, uint _nDay, uint _restDepositPerDay, uint _badDeposit, uint _sendBackAmount, uint _totalPenalty, uint _willDeposit);
119 
120     event LogUsedRestDepositPerDay(address _addr, address _referrer, uint _money, uint _nDay, uint _restDepositPerDay, uint _realDeposit, uint _usedDepositPerDay);
121     event LogCalcBonusReferrer(address _referrer, uint _money, uint _index, uint _bonusReferrer, uint _amountReferrer, address _nextReferrer);
122 
123 
124     struct User
125     {
126         uint balance;
127         uint paidInteres;
128         uint timestamp;
129         uint countReferrals;
130         uint earnOnReferrals;
131         uint paidReferrals;
132         address referrer;
133     }
134 
135     mapping (address => User) private user;
136 
137     mapping (uint => uint) private usedDeposit;
138 
139     function getInteres(address addr) private view returns(uint interes) 
140     {
141         uint diffDays = getNDay(user[addr].timestamp);
142 
143         if( diffDays > maxDepositDays ) diffDays = maxDepositDays;
144 
145         interes = user[addr].balance.mul(perDay).mul(diffDays).div(procKoef);
146     }
147 
148     function getUser(address addr) public view returns(uint balance, uint timestamp, uint paidInteres, uint totalInteres, uint countReferrals, uint earnOnReferrals, uint paidReferrals, address referrer) 
149     {
150         address a = addr;
151         return (
152             user[a].balance,
153             user[a].timestamp,
154             user[a].paidInteres,
155             getInteres(a),
156             user[a].countReferrals,
157             user[a].earnOnReferrals,
158             user[a].paidReferrals,
159             user[a].referrer
160         );
161     }
162 
163     function getCurrentDay() public view returns(uint nday) 
164     {
165         nday = getNDay(startTimestamp);
166     }
167 
168     function getNDay(uint date) public view returns(uint nday) 
169     {
170         uint diffTime = date > 0 ? now.sub(date) : 0;
171 
172         nday = diffTime.div(24 hours);
173     }
174 
175     function getCurrentDayDepositLimit() public view returns(uint limit) 
176     {
177         uint nDay = getCurrentDay();
178 
179         limit = getDayDepositLimit(nDay);
180     }
181 
182 
183     function calcProgress(uint start, uint proc, uint nDay) public pure returns(uint res) 
184     {
185         uint s = start;
186 
187         for (uint i = 0; i < nDay; i++)
188         {
189             s = s.mul(progressProcKoef + proc).div(progressProcKoef);
190         }
191 
192         return s;
193     }
194 
195     function getDayDepositLimit(uint nDay) public pure returns(uint limit) 
196     {                         
197         return calcProgress(dayLimitStart, dayLimitProgressProc, nDay );
198     }
199 
200     function getMaximalDeposit(uint nDay) public pure returns(uint limit) 
201     {                 
202         return calcProgress(maximalDepositStart, maxDepositProgressProc, nDay );
203     }
204 
205     function getCurrentDayRestDepositLimit() public view returns(uint restLimit) 
206     {
207         uint nDay = getCurrentDay();
208 
209         restLimit = getDayRestDepositLimit(nDay);
210     }
211 
212     function getDayRestDepositLimit(uint nDay) public view returns(uint restLimit) 
213     {
214         restLimit = getCurrentDayDepositLimit().sub(usedDeposit[nDay]);
215     }
216 
217 
218     function getCurrentMaximalDeposit() public view returns(uint maximalDeposit) 
219     {
220         uint nDay = getCurrentDay();
221 
222         maximalDeposit = getMaximalDeposit(nDay);
223     }
224 
225 
226     function() external payable 
227     {
228         emit LogInvestment(msg.sender, msg.value, msg.data);
229         processPayment(msg.value, msg.data);
230     }
231 
232     function processPayment(uint moneyValue, bytes refData) private
233     {
234         if (msg.sender == owner) 
235         { 
236             totalSelfInvest = totalSelfInvest.add(moneyValue);
237             emit LogSelfInvestment(moneyValue);
238             return; 
239         }
240 
241         if (moneyValue == 0) 
242         { 
243             preparePayment();
244             return; 
245         }
246 
247         if (moneyValue < minimalDeposit) 
248         { 
249             totalPenalty = totalPenalty.add(moneyValue);
250             emit LogMinimalDepositPayment(msg.sender, moneyValue, totalPenalty);
251             return; 
252         }
253 
254         address referrer = bytesToAddress(refData);
255 
256         if (user[msg.sender].balance > 0 || 
257             refData.length != 20 || 
258             moneyValue > getCurrentMaximalDeposit() ||
259             referrer != owner &&
260               (
261                  user[referrer].balance <= 0 || 
262                  referrer == msg.sender) 
263               )
264         { 
265             uint amount = moneyValue.mul(procReturn).div(procKoef);
266 
267             totalPenalty = totalPenalty.add(moneyValue.sub(amount));
268 
269             emit LogPenaltyPayment(msg.sender, user[msg.sender].balance, refData.length, referrer, user[referrer].balance, moneyValue, amount, totalPenalty);
270 
271             msg.sender.transfer(amount);
272 
273             return; 
274         }
275 
276 
277 
278         uint nDay = getCurrentDay();
279 
280         uint restDepositPerDay = getDayRestDepositLimit(nDay);
281 
282         uint addDeposit = moneyValue;
283 
284 
285         if (moneyValue > restDepositPerDay)
286         {
287             uint returnDeposit = moneyValue.sub(restDepositPerDay);
288 
289             uint returnAmount = returnDeposit.mul(procReturn).div(procKoef);
290 
291             addDeposit = addDeposit.sub(returnDeposit);
292 
293             totalPenalty = totalPenalty.add(returnDeposit.sub(returnAmount));
294 
295             emit LogExceededRestDepositPerDay(msg.sender, referrer, moneyValue, nDay, restDepositPerDay, returnDeposit, returnAmount, totalPenalty, addDeposit);
296 
297             msg.sender.transfer(returnAmount);
298         }
299 
300         usedDeposit[nDay] = usedDeposit[nDay].add(addDeposit);
301 
302         emit LogUsedRestDepositPerDay(msg.sender, referrer, moneyValue, nDay, restDepositPerDay, addDeposit, usedDeposit[nDay]);
303 
304 
305         registerInvestor(referrer);
306         sendOwnerFee(addDeposit);
307         calcBonusReferrers(referrer, addDeposit);
308         updateInvestBalance(addDeposit);
309     }
310 
311 
312     function registerInvestor(address referrer) private 
313     {
314         user[msg.sender].timestamp = now;
315         countInvestors++;
316 
317         user[msg.sender].referrer = referrer;
318         user[referrer].countReferrals++;
319     }
320 
321     function sendOwnerFee(uint addDeposit) private 
322     {
323         transfer(owner, addDeposit.mul(ownerFee).div(procKoef));
324     }
325 
326     function calcBonusReferrers(address referrer, uint addDeposit) private 
327     {
328         for (uint i = 0; i < bonusReferrer.length && referrer != 0; i++)
329         {
330             uint amountReferrer = addDeposit.mul(bonusReferrer[i]).div(procKoef);
331 
332             address nextReferrer = user[referrer].referrer;
333 
334             emit LogCalcBonusReferrer(referrer, addDeposit, i, bonusReferrer[i], amountReferrer, nextReferrer);
335 
336             preparePaymentReferrer(referrer, amountReferrer);
337 
338             referrer = nextReferrer;
339         }
340     }
341 
342 
343     function preparePaymentReferrer(address referrer, uint amountReferrer) private 
344     {
345         user[referrer].earnOnReferrals = user[referrer].earnOnReferrals.add(amountReferrer);
346 
347         uint totalReferrals = user[referrer].earnOnReferrals;
348         uint paidReferrals = user[referrer].paidReferrals;
349 
350 
351         if (totalReferrals >= paidReferrals.add(minimalDepositForBonusReferrer)) 
352         {
353             uint amount = totalReferrals.sub(paidReferrals);
354 
355             user[referrer].paidReferrals = user[referrer].paidReferrals.add(amount);
356 
357             emit LogPreparePaymentReferrer(referrer, totalReferrals, paidReferrals, amount);
358 
359             transfer(referrer, amount);
360         }
361         else
362         {
363             emit LogSkipPreparePaymentReferrer(referrer, totalReferrals, paidReferrals);
364         }
365 
366     }
367 
368 
369     function preparePayment() public 
370     {
371         uint totalInteres = getInteres(msg.sender);
372         uint paidInteres = user[msg.sender].paidInteres;
373         if (totalInteres > paidInteres) 
374         {
375             uint amount = totalInteres.sub(paidInteres);
376 
377             emit LogPreparePayment(msg.sender, totalInteres, paidInteres, amount);
378 
379             user[msg.sender].paidInteres = user[msg.sender].paidInteres.add(amount);
380             transfer(msg.sender, amount);
381         }
382         else
383         {
384             emit LogSkipPreparePayment(msg.sender, totalInteres, paidInteres);
385         }
386     }
387 
388     function updateInvestBalance(uint addDeposit) private 
389     {
390         user[msg.sender].balance = user[msg.sender].balance.add(addDeposit);
391         totalInvest = totalInvest.add(addDeposit);
392     }
393 
394     function transfer(address receiver, uint amount) private 
395     {
396         if (amount > 0) 
397         {
398             if (receiver != owner) { totalPaid = totalPaid.add(amount); }
399 
400             uint balance = address(this).balance;
401 
402             emit LogTransfer(receiver, amount, balance);
403 
404             require(amount < balance, "Not enough balance. Please retry later.");
405 
406             receiver.transfer(amount);
407         }
408     }
409 
410     function bytesToAddress(bytes source) private pure returns(address addr) 
411     {
412         assembly { addr := mload(add(source,0x14)) }
413         return addr;
414     }
415 
416     function getTotals() public view returns(uint _maxDepositDays, 
417                                              uint _perDay, 
418                                              uint _startTimestamp, 
419 
420                                              uint _minimalDeposit, 
421                                              uint _maximalDeposit, 
422                                              uint[4] _bonusReferrer, 
423                                              uint _minimalDepositForBonusReferrer, 
424                                              uint _ownerFee, 
425 
426                                              uint _countInvestors, 
427                                              uint _totalInvest, 
428                                              uint _totalPenalty, 
429 //                                             uint _totalSelfInvest, 
430                                              uint _totalPaid, 
431 
432                                              uint _currentDayDepositLimit, 
433                                              uint _currentDayRestDepositLimit)
434     {
435         return (
436                  maxDepositDays,
437                  perDay,
438                  startTimestamp,
439 
440                  minimalDeposit,
441                  getCurrentMaximalDeposit(),
442                  bonusReferrer,
443                  minimalDepositForBonusReferrer,
444                  ownerFee,
445 
446                  countInvestors,
447                  totalInvest,
448                  totalPenalty,
449 //                 totalSelfInvest,
450                  totalPaid,
451 
452                  getCurrentDayDepositLimit(),
453                  getCurrentDayRestDepositLimit()
454                );
455     }
456 
457 }