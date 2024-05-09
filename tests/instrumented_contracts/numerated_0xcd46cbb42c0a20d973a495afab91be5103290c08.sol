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
87     uint public constant maximalDeposit = 25 ether;
88 
89     uint public constant minimalDepositForBonusReferrer = 0.015 ether;
90 
91     uint public countInvestors = 0;
92     uint public totalInvest = 0;
93     uint public totalPenalty = 0;
94     uint public totalSelfInvest = 0;
95     uint public totalPaid = 0;
96 
97     event LogInvestment(address _addr, uint _value, bytes _refData);
98     event LogTransfer(address _addr, uint _amount, uint _contactBalance);
99     event LogSelfInvestment(uint _value);
100 
101     event LogPreparePayment(address _addr, uint _totalInteres, uint _paidInteres, uint _amount);
102     event LogSkipPreparePayment(address _addr, uint _totalInteres, uint _paidInteres);
103 
104     event LogPreparePaymentReferrer(address _addr, uint _totalReferrals, uint _paidReferrals, uint _amount);
105     event LogSkipPreparePaymentReferrer(address _addr, uint _totalReferrals, uint _paidReferrals);
106 
107     event LogMinimalDepositPayment(address _addr, uint _money, uint _totalPenalty);
108     event LogPenaltyPayment(address _addr, uint currentSenderDeposit, uint referrerAdressLength, address _referrer, uint currentReferrerDeposit, uint _money, uint _sendBackAmount, uint _totalPenalty);
109     event LogExceededRestDepositPerDay(address _addr, address _referrer, uint _money, uint _nDay, uint _restDepositPerDay, uint _badDeposit, uint _sendBackAmount, uint _totalPenalty, uint _willDeposit);
110 
111     event LogUsedRestDepositPerDay(address _addr, address _referrer, uint _money, uint _nDay, uint _restDepositPerDay, uint _realDeposit, uint _usedDepositPerDay);
112     event LogCalcBonusReferrer(address _referrer, uint _money, uint _index, uint _bonusReferrer, uint _amountReferrer, address _nextReferrer);
113 
114 
115     struct User
116     {
117         uint balance;
118         uint paidInteres;
119         uint timestamp;
120         uint countReferrals;
121         uint earnOnReferrals;
122         uint paidReferrals;
123         address referrer;
124     }
125 
126     mapping (address => User) private user;
127 
128     mapping (uint => uint) private usedDeposit;
129 
130     function getInteres(address addr) private view returns(uint interes) 
131     {
132         uint diffDays = getNDay(user[addr].timestamp);
133 
134         if( diffDays > maxDepositDays ) diffDays = maxDepositDays;
135 
136         interes = user[addr].balance.mul(perDay).mul(diffDays).div(procKoef);
137     }
138 
139     function getUser(address addr) public view returns(uint balance, uint timestamp, uint paidInteres, uint totalInteres, uint countReferrals, uint earnOnReferrals, uint paidReferrals, address referrer) 
140     {
141         address a = addr;
142         return (
143             user[a].balance,
144             user[a].timestamp,
145             user[a].paidInteres,
146             getInteres(a),
147             user[a].countReferrals,
148             user[a].earnOnReferrals,
149             user[a].paidReferrals,
150             user[a].referrer
151         );
152     }
153 
154     function getCurrentDay() public view returns(uint nday) 
155     {
156         nday = getNDay(startTimestamp);
157     }
158 
159     function getNDay(uint date) public view returns(uint nday) 
160     {
161         uint diffTime = date > 0 ? now.sub(date) : 0;
162 
163         nday = diffTime.div(24 hours);
164     }
165 
166     function getCurrentDayDepositLimit() public view returns(uint limit) 
167     {
168         uint nDay = getCurrentDay();
169 
170         limit = getDayDepositLimit(nDay);
171     }
172 
173     function getDayDepositLimit(uint nDay) public pure returns(uint limit) 
174     {                         
175         if(nDay <= 30) return 25.5 ether;
176         if(nDay <= 60) return 51 ether;
177         if(nDay <= 150) return 151 ether;
178         if(nDay <= 270) return 201 ether;
179 
180         return 301 ether;
181     }
182 
183     function getCurrentDayRestDepositLimit() public view returns(uint restLimit) 
184     {
185         uint nDay = getCurrentDay();
186 
187         restLimit = getDayRestDepositLimit(nDay);
188     }
189 
190     function getDayRestDepositLimit(uint nDay) public view returns(uint restLimit) 
191     {
192         restLimit = getCurrentDayDepositLimit().sub(usedDeposit[nDay]);
193     }
194 
195     function() external payable 
196     {
197         emit LogInvestment(msg.sender, msg.value, msg.data);
198         processPayment(msg.value, msg.data);
199     }
200 
201     function processPayment(uint moneyValue, bytes refData) private
202     {
203         if (msg.sender == owner) 
204         { 
205             totalSelfInvest = totalSelfInvest.add(moneyValue);
206             emit LogSelfInvestment(moneyValue);
207             return; 
208         }
209 
210         if (moneyValue == 0) 
211         { 
212             preparePayment();
213             return; 
214         }
215 
216         if (moneyValue < minimalDeposit) 
217         { 
218             totalPenalty = totalPenalty.add(moneyValue);
219             emit LogMinimalDepositPayment(msg.sender, moneyValue, totalPenalty);
220             return; 
221         }
222 
223         address referrer = bytesToAddress(refData);
224 
225         if (user[msg.sender].balance > 0 || 
226             refData.length != 20 || 
227             moneyValue > maximalDeposit ||
228             referrer != owner &&
229               (
230                  user[referrer].balance <= 0 || 
231                  referrer == msg.sender) 
232               )
233         { 
234             uint amount = moneyValue.mul(procReturn).div(procKoef);
235 
236             totalPenalty = totalPenalty.add(moneyValue.sub(amount));
237 
238             emit LogPenaltyPayment(msg.sender, user[msg.sender].balance, refData.length, referrer, user[referrer].balance, moneyValue, amount, totalPenalty);
239 
240             msg.sender.transfer(amount);
241 
242             return; 
243         }
244 
245 
246 
247         uint nDay = getCurrentDay();
248 
249         uint restDepositPerDay = getDayRestDepositLimit(nDay);
250 
251         uint addDeposit = moneyValue;
252 
253 
254         if (moneyValue > restDepositPerDay)
255         {
256             uint returnDeposit = moneyValue.sub(restDepositPerDay);
257 
258             uint returnAmount = returnDeposit.mul(procReturn).div(procKoef);
259 
260             addDeposit = addDeposit.sub(returnDeposit);
261 
262             totalPenalty = totalPenalty.add(returnDeposit.sub(returnAmount));
263 
264             emit LogExceededRestDepositPerDay(msg.sender, referrer, moneyValue, nDay, restDepositPerDay, returnDeposit, returnAmount, totalPenalty, addDeposit);
265 
266             msg.sender.transfer(returnAmount);
267         }
268 
269         usedDeposit[nDay] = usedDeposit[nDay].add(addDeposit);
270 
271         emit LogUsedRestDepositPerDay(msg.sender, referrer, moneyValue, nDay, restDepositPerDay, addDeposit, usedDeposit[nDay]);
272 
273 
274         registerInvestor(referrer);
275         sendOwnerFee(addDeposit);
276         calcBonusReferrers(referrer, addDeposit);
277         updateInvestBalance(addDeposit);
278     }
279 
280 
281     function registerInvestor(address referrer) private 
282     {
283         user[msg.sender].timestamp = now;
284         countInvestors++;
285 
286         user[msg.sender].referrer = referrer;
287         user[referrer].countReferrals++;
288     }
289 
290     function sendOwnerFee(uint addDeposit) private 
291     {
292         transfer(owner, addDeposit.mul(ownerFee).div(procKoef));
293     }
294 
295     function calcBonusReferrers(address referrer, uint addDeposit) private 
296     {
297         for (uint i = 0; i < bonusReferrer.length && referrer != 0; i++)
298         {
299             uint amountReferrer = addDeposit.mul(bonusReferrer[i]).div(procKoef);
300 
301             address nextReferrer = user[referrer].referrer;
302 
303             emit LogCalcBonusReferrer(referrer, addDeposit, i, bonusReferrer[i], amountReferrer, nextReferrer);
304 
305             preparePaymentReferrer(referrer, amountReferrer);
306 
307             referrer = nextReferrer;
308         }
309     }
310 
311 
312     function preparePaymentReferrer(address referrer, uint amountReferrer) private 
313     {
314         user[referrer].earnOnReferrals = user[referrer].earnOnReferrals.add(amountReferrer);
315 
316         uint totalReferrals = user[referrer].earnOnReferrals;
317         uint paidReferrals = user[referrer].paidReferrals;
318 
319 
320         if (totalReferrals >= paidReferrals.add(minimalDepositForBonusReferrer)) 
321         {
322             uint amount = totalReferrals.sub(paidReferrals);
323 
324             user[referrer].paidReferrals = user[referrer].paidReferrals.add(amount);
325 
326             emit LogPreparePaymentReferrer(referrer, totalReferrals, paidReferrals, amount);
327 
328             transfer(referrer, amount);
329         }
330         else
331         {
332             emit LogSkipPreparePaymentReferrer(referrer, totalReferrals, paidReferrals);
333         }
334 
335     }
336 
337 
338     function preparePayment() public 
339     {
340         uint totalInteres = getInteres(msg.sender);
341         uint paidInteres = user[msg.sender].paidInteres;
342         if (totalInteres > paidInteres) 
343         {
344             uint amount = totalInteres.sub(paidInteres);
345 
346             emit LogPreparePayment(msg.sender, totalInteres, paidInteres, amount);
347 
348             user[msg.sender].paidInteres = user[msg.sender].paidInteres.add(amount);
349             transfer(msg.sender, amount);
350         }
351         else
352         {
353             emit LogSkipPreparePayment(msg.sender, totalInteres, paidInteres);
354         }
355     }
356 
357     function updateInvestBalance(uint addDeposit) private 
358     {
359         user[msg.sender].balance = user[msg.sender].balance.add(addDeposit);
360         totalInvest = totalInvest.add(addDeposit);
361     }
362 
363     function transfer(address receiver, uint amount) private 
364     {
365         if (amount > 0) 
366         {
367             if (receiver != owner) { totalPaid = totalPaid.add(amount); }
368 
369             uint balance = address(this).balance;
370 
371             emit LogTransfer(receiver, amount, balance);
372 
373             require(amount < balance, "Not enough balance. Please retry later.");
374 
375             receiver.transfer(amount);
376         }
377     }
378 
379     function bytesToAddress(bytes source) private pure returns(address addr) 
380     {
381         assembly { addr := mload(add(source,0x14)) }
382         return addr;
383     }
384 
385     function getTotals() public view returns(uint _maxDepositDays, 
386                                              uint _perDay, 
387                                              uint _startTimestamp, 
388 
389                                              uint _minimalDeposit, 
390                                              uint _maximalDeposit, 
391                                              uint[4] _bonusReferrer, 
392                                              uint _minimalDepositForBonusReferrer, 
393                                              uint _ownerFee, 
394 
395                                              uint _countInvestors, 
396                                              uint _totalInvest, 
397                                              uint _totalPenalty, 
398 //                                             uint _totalSelfInvest, 
399                                              uint _totalPaid, 
400 
401                                              uint _currentDayDepositLimit, 
402                                              uint _currentDayRestDepositLimit)
403     {
404         return (
405                  maxDepositDays,
406                  perDay,
407                  startTimestamp,
408 
409                  minimalDeposit,
410                  maximalDeposit,
411                  bonusReferrer,
412                  minimalDepositForBonusReferrer,
413                  ownerFee,
414 
415                  countInvestors,
416                  totalInvest,
417                  totalPenalty,
418 //                 totalSelfInvest,
419                  totalPaid,
420 
421                  getCurrentDayDepositLimit(),
422                  getCurrentDayRestDepositLimit()
423                );
424     }
425 
426 }