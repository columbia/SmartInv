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
72     string  public constant name    = 'Kassa 100/40';
73     uint public startTimestamp = now;
74 
75     uint public constant procKoef = 10000;
76     uint public constant perDay = 140;
77     uint public constant ownerFee = 700;
78     uint[3] public bonusReferrer = [600, 200, 100];
79 
80     uint public constant procReturn = 9000;
81 
82 
83     uint public constant maxDepositDays = 100;
84 
85 
86     uint public constant minimalDeposit = 0.25 ether;
87     uint public constant maximalDepositStart = 15 ether;
88 
89     uint public constant minimalDepositForBonusReferrer = 0.015 ether;
90 
91     uint public constant dayLimitStart = 50 ether;
92 
93 
94     uint public constant progressProcKoef = 100;
95     uint public constant dayLimitProgressProc = 3;
96     uint public constant maxDepositProgressProc = 2;
97 
98     uint public countInvestors = 0;
99     uint public totalInvest = 0;
100     uint public totalPenalty = 0;
101     uint public totalSelfInvest = 0;
102     uint public totalPaid = 0;
103 
104     event LogInvestment(address _addr, uint _value, bytes _refData);
105     event LogTransfer(address _addr, uint _amount, uint _contactBalance);
106     event LogSelfInvestment(uint _value);
107 
108     event LogPreparePayment(address _addr, uint _totalInteres, uint _paidInteres, uint _amount);
109     event LogSkipPreparePayment(address _addr, uint _totalInteres, uint _paidInteres);
110 
111     event LogPreparePaymentReferrer(address _addr, uint _totalReferrals, uint _paidReferrals, uint _amount);
112     event LogSkipPreparePaymentReferrer(address _addr, uint _totalReferrals, uint _paidReferrals);
113 
114     event LogMinimalDepositPayment(address _addr, uint _money, uint _totalPenalty);
115     event LogPenaltyPayment(address _addr, uint currentSenderDeposit, uint referrerAdressLength, address _referrer, uint currentReferrerDeposit, uint _money, uint _sendBackAmount, uint _totalPenalty);
116     event LogExceededRestDepositPerDay(address _addr, address _referrer, uint _money, uint _nDay, uint _restDepositPerDay, uint _badDeposit, uint _sendBackAmount, uint _totalPenalty, uint _willDeposit);
117 
118     event LogUsedRestDepositPerDay(address _addr, address _referrer, uint _money, uint _nDay, uint _restDepositPerDay, uint _realDeposit, uint _usedDepositPerDay);
119     event LogCalcBonusReferrer(address _referrer, uint _money, uint _index, uint _bonusReferrer, uint _amountReferrer, address _nextReferrer);
120 
121 
122     struct User
123     {
124         uint balance;
125         uint paidInteres;
126         uint timestamp;
127         uint countReferrals;
128         uint earnOnReferrals;
129         uint paidReferrals;
130         address referrer;
131     }
132 
133     mapping (address => User) private user;
134 
135     mapping (uint => uint) private usedDeposit;
136 
137     function getInteres(address addr) private view returns(uint interes) 
138     {
139         uint diffDays = getNDay(user[addr].timestamp);
140 
141         if( diffDays > maxDepositDays ) diffDays = maxDepositDays;
142 
143         interes = user[addr].balance.mul(perDay).mul(diffDays).div(procKoef);
144     }
145 
146     function getUser(address addr) public view returns(uint balance, uint timestamp, uint paidInteres, uint totalInteres, uint countReferrals, uint earnOnReferrals, uint paidReferrals, address referrer) 
147     {
148         address a = addr;
149         return (
150             user[a].balance,
151             user[a].timestamp,
152             user[a].paidInteres,
153             getInteres(a),
154             user[a].countReferrals,
155             user[a].earnOnReferrals,
156             user[a].paidReferrals,
157             user[a].referrer
158         );
159     }
160 
161     function getCurrentDay() public view returns(uint nday) 
162     {
163         nday = getNDay(startTimestamp);
164     }
165 
166     function getNDay(uint date) public view returns(uint nday) 
167     {
168         uint diffTime = date > 0 ? now.sub(date) : 0;
169 
170         nday = diffTime.div(24 hours);
171     }
172 
173     function getCurrentDayDepositLimit() public view returns(uint limit) 
174     {
175         uint nDay = getCurrentDay();
176 
177         limit = getDayDepositLimit(nDay);
178     }
179 
180     function calcProgress(uint start, uint proc, uint nDay) public pure returns(uint res) 
181     {
182         uint s = start;
183 
184         for (uint i = 0; i < nDay; i++)
185         {
186             s = s.mul(progressProcKoef + proc).div(progressProcKoef);
187         }
188 
189         return s;
190     }
191 
192     function getDayDepositLimit(uint nDay) public pure returns(uint limit) 
193     {                         
194         return calcProgress(dayLimitStart, dayLimitProgressProc, nDay );
195     }
196 
197     function getMaximalDeposit(uint nDay) public pure returns(uint limit) 
198     {                 
199         return calcProgress(maximalDepositStart, maxDepositProgressProc, nDay );
200     }
201 
202     function getCurrentDayRestDepositLimit() public view returns(uint restLimit) 
203     {
204         uint nDay = getCurrentDay();
205 
206         restLimit = getDayRestDepositLimit(nDay);
207     }
208 
209     function getDayRestDepositLimit(uint nDay) public view returns(uint restLimit) 
210     {
211         restLimit = getCurrentDayDepositLimit().sub(usedDeposit[nDay]);
212     }
213 
214     function getCurrentMaximalDeposit() public view returns(uint maximalDeposit) 
215     {
216         uint nDay = getCurrentDay();
217 
218         maximalDeposit = getMaximalDeposit(nDay);
219     }
220 
221     function() external payable 
222     {
223         emit LogInvestment(msg.sender, msg.value, msg.data);
224         processPayment(msg.value, msg.data);
225     }
226 
227     function processPayment(uint moneyValue, bytes refData) private
228     {
229         if (msg.sender == owner) 
230         { 
231             totalSelfInvest = totalSelfInvest.add(moneyValue);
232             emit LogSelfInvestment(moneyValue);
233             return; 
234         }
235 
236         if (moneyValue == 0) 
237         { 
238             preparePayment();
239             return; 
240         }
241 
242         if (moneyValue < minimalDeposit) 
243         { 
244             totalPenalty = totalPenalty.add(moneyValue);
245             emit LogMinimalDepositPayment(msg.sender, moneyValue, totalPenalty);
246             return; 
247         }
248 
249         address referrer = bytesToAddress(refData);
250 
251         if (user[msg.sender].balance > 0 || 
252             refData.length != 20 || 
253             moneyValue > getCurrentMaximalDeposit() ||
254             referrer != owner &&
255               (
256                  user[referrer].balance <= 0 || 
257                  referrer == msg.sender) 
258               )
259         { 
260             uint amount = moneyValue.mul(procReturn).div(procKoef);
261 
262             totalPenalty = totalPenalty.add(moneyValue.sub(amount));
263 
264             emit LogPenaltyPayment(msg.sender, user[msg.sender].balance, refData.length, referrer, user[referrer].balance, moneyValue, amount, totalPenalty);
265 
266             msg.sender.transfer(amount);
267 
268             return; 
269         }
270 
271 
272 
273         uint nDay = getCurrentDay();
274 
275         uint restDepositPerDay = getDayRestDepositLimit(nDay);
276 
277         uint addDeposit = moneyValue;
278 
279 
280         if (moneyValue > restDepositPerDay)
281         {
282             uint returnDeposit = moneyValue.sub(restDepositPerDay);
283 
284             uint returnAmount = returnDeposit.mul(procReturn).div(procKoef);
285 
286             addDeposit = addDeposit.sub(returnDeposit);
287 
288             totalPenalty = totalPenalty.add(returnDeposit.sub(returnAmount));
289 
290             emit LogExceededRestDepositPerDay(msg.sender, referrer, moneyValue, nDay, restDepositPerDay, returnDeposit, returnAmount, totalPenalty, addDeposit);
291 
292             msg.sender.transfer(returnAmount);
293         }
294 
295         usedDeposit[nDay] = usedDeposit[nDay].add(addDeposit);
296 
297         emit LogUsedRestDepositPerDay(msg.sender, referrer, moneyValue, nDay, restDepositPerDay, addDeposit, usedDeposit[nDay]);
298 
299 
300         registerInvestor(referrer);
301         sendOwnerFee(addDeposit);
302         calcBonusReferrers(referrer, addDeposit);
303         updateInvestBalance(addDeposit);
304     }
305 
306 
307     function registerInvestor(address referrer) private 
308     {
309         user[msg.sender].timestamp = now;
310         countInvestors++;
311 
312         user[msg.sender].referrer = referrer;
313         user[referrer].countReferrals++;
314     }
315 
316     function sendOwnerFee(uint addDeposit) private 
317     {
318         transfer(owner, addDeposit.mul(ownerFee).div(procKoef));
319     }
320 
321     function calcBonusReferrers(address referrer, uint addDeposit) private 
322     {
323         for (uint i = 0; i < bonusReferrer.length && referrer != 0; i++)
324         {
325             uint amountReferrer = addDeposit.mul(bonusReferrer[i]).div(procKoef);
326 
327             address nextReferrer = user[referrer].referrer;
328 
329             emit LogCalcBonusReferrer(referrer, addDeposit, i, bonusReferrer[i], amountReferrer, nextReferrer);
330 
331             preparePaymentReferrer(referrer, amountReferrer);
332 
333             referrer = nextReferrer;
334         }
335     }
336 
337 
338     function preparePaymentReferrer(address referrer, uint amountReferrer) private 
339     {
340         user[referrer].earnOnReferrals = user[referrer].earnOnReferrals.add(amountReferrer);
341 
342         uint totalReferrals = user[referrer].earnOnReferrals;
343         uint paidReferrals = user[referrer].paidReferrals;
344 
345 
346         if (totalReferrals >= paidReferrals.add(minimalDepositForBonusReferrer)) 
347         {
348             uint amount = totalReferrals.sub(paidReferrals);
349 
350             user[referrer].paidReferrals = user[referrer].paidReferrals.add(amount);
351 
352             emit LogPreparePaymentReferrer(referrer, totalReferrals, paidReferrals, amount);
353 
354             transfer(referrer, amount);
355         }
356         else
357         {
358             emit LogSkipPreparePaymentReferrer(referrer, totalReferrals, paidReferrals);
359         }
360 
361     }
362 
363 
364     function preparePayment() public 
365     {
366         uint totalInteres = getInteres(msg.sender);
367         uint paidInteres = user[msg.sender].paidInteres;
368         if (totalInteres > paidInteres) 
369         {
370             uint amount = totalInteres.sub(paidInteres);
371 
372             emit LogPreparePayment(msg.sender, totalInteres, paidInteres, amount);
373 
374             user[msg.sender].paidInteres = user[msg.sender].paidInteres.add(amount);
375             transfer(msg.sender, amount);
376         }
377         else
378         {
379             emit LogSkipPreparePayment(msg.sender, totalInteres, paidInteres);
380         }
381     }
382 
383     function updateInvestBalance(uint addDeposit) private 
384     {
385         user[msg.sender].balance = user[msg.sender].balance.add(addDeposit);
386         totalInvest = totalInvest.add(addDeposit);
387     }
388 
389     function transfer(address receiver, uint amount) private 
390     {
391         if (amount > 0) 
392         {
393             if (receiver != owner) { totalPaid = totalPaid.add(amount); }
394 
395             uint balance = address(this).balance;
396 
397             emit LogTransfer(receiver, amount, balance);
398 
399             require(amount < balance, "Not enough balance. Please retry later.");
400 
401             receiver.transfer(amount);
402         }
403     }
404 
405     function bytesToAddress(bytes source) private pure returns(address addr) 
406     {
407         assembly { addr := mload(add(source,0x14)) }
408         return addr;
409     }
410 
411     function getTotals() public view returns(uint _maxDepositDays, 
412                                              uint _perDay, 
413                                              uint _startTimestamp, 
414 
415                                              uint _minimalDeposit, 
416                                              uint _maximalDeposit, 
417                                              uint[3] _bonusReferrer, 
418                                              uint _minimalDepositForBonusReferrer, 
419                                              uint _ownerFee, 
420 
421                                              uint _countInvestors, 
422                                              uint _totalInvest, 
423                                              uint _totalPenalty, 
424 //                                             uint _totalSelfInvest, 
425                                              uint _totalPaid, 
426 
427                                              uint _currentDayDepositLimit, 
428                                              uint _currentDayRestDepositLimit)
429     {
430         return (
431                  maxDepositDays,
432                  perDay,
433                  startTimestamp,
434 
435                  minimalDeposit,
436                  getCurrentMaximalDeposit(),
437                  bonusReferrer,
438                  minimalDepositForBonusReferrer,
439                  ownerFee,
440 
441                  countInvestors,
442                  totalInvest,
443                  totalPenalty,
444 //                 totalSelfInvest,
445                  totalPaid,
446 
447                  getCurrentDayDepositLimit(),
448                  getCurrentDayRestDepositLimit()
449                );
450     }
451 
452 }