1 //
2 //             ALLAH SMART CONTRACT
3 //
4 // Earn on investment 3% daily!
5 // Receive your 3% cash-back when invest with referrer!
6 // Earn 3% from each referral deposit!
7 //
8 //
9 // HOW TO TAKE PARTICIPANT:
10 // Just send ETH to contract address (min. 0.01 ETH)
11 //
12 //
13 // HOW TO RECEIVE MY DIVIDENDS?
14 // Send 0 ETH to contract. No limits.
15 //
16 //
17 // INTEREST
18 // IF contract balance > 0 ETH = 3% per day
19 // IF contract balance > 1000 ETH = 2% per day
20 // IF contract balance > 4000 ETH = 1% per day
21 //
22 //
23 // DO NOT HOLD YOUR DIVIDENDS ON CONTRACT ACCOUNT!
24 // Max one-time payout is your dividends for 3 days of work.
25 // It would be better if your will request your dividends each day.
26 //
27 // For more information visit https://gorgona.io/
28 //
29 // Telegram chat (ru): https://t.me/gorgona_io
30 // Telegram chat (en): https://t.me/gorgona_io_en
31 //
32 // For support and requests telegram: @alex_gorgona_io
33 
34 pragma solidity ^0.4.24;
35 
36 
37 // service which controls amount of investments per day
38 // this service does not allow fast grow!
39 library GrowingControl {
40     using GrowingControl for data;
41 
42     // base structure for control investments per day
43     struct data {
44         uint min;
45         uint max;
46 
47         uint startAt;
48         uint maxAmountPerDay;
49         mapping(uint => uint) investmentsPerDay;
50     }
51 
52     // increase day investments
53     function addInvestment(data storage control, uint amount) internal
54     {
55         control.investmentsPerDay[getCurrentDay()] += amount;
56     }
57 
58     // get today current max investment
59     function getMaxInvestmentToday(data storage control) internal view returns (uint)
60     {
61         if (control.startAt == 0) {
62             return 10000 ether; // disabled controlling, allow 10000 eth
63         }
64 
65         if (control.startAt > now) {
66             return 10000 ether; // not started, allow 10000 eth
67         }
68 
69         return control.maxAmountPerDay - control.getTodayInvestment();
70     }
71 
72     function getCurrentDay() internal view returns (uint)
73     {
74         return now / 24 hours;
75     }
76 
77     // get amount of today investments
78     function getTodayInvestment(data storage control) internal view returns (uint)
79     {
80         return control.investmentsPerDay[getCurrentDay()];
81     }
82 }
83 
84 contract InfinityBehzod {
85     using GrowingControl for GrowingControl.data;
86 
87     // contract owner set to 0x0000000000000000000000000000000000000000,
88     address public owner = 0x0000000000000000000000000000000000000000;
89 
90     uint constant public MINIMUM_INVEST = 10000000000000000 wei;
91 
92     // current interest
93     uint public currentInterest = 3;
94 
95     // total deposited eth
96     uint public depositAmount;
97 
98     // total paid out eth
99     uint public paidAmount;
100 
101     // current round (restart)
102     uint public round = 1;
103 
104     // last investment date
105     uint public lastPaymentDate;
106 
107     // fee for advertising purposes
108     uint public advertFee = 10;
109 
110     // project admins fee
111     uint public devFee = 5;
112 
113     // maximum profit per investor (x2)
114     uint public profitThreshold = 2;
115 
116     // addr of project admins (not owner of the contract)
117     address public devAddr;
118 
119     // advert addr
120     address public advertAddr;
121 
122     // investors addresses
123     address[] public addresses;
124 
125     // mapping address to Investor
126     mapping(address => Investor) public investors;
127 
128     // currently on restart phase or not?
129     bool public pause;
130 
131     // Thunderstorm structure
132     struct Thunderstorm {
133         address addr;
134         uint deposit;
135         uint from;
136     }
137 
138     // Investor structure
139     struct Investor
140     {
141         uint id;
142         uint deposit; // deposit amount
143         uint deposits; // deposits count
144         uint paidOut; // total paid out
145         uint date; // last date of investment or paid out
146         address referrer;
147     }
148 
149     event Invest(address indexed addr, uint amount, address referrer);
150     event Payout(address indexed addr, uint amount, string eventType, address from);
151     event NextRoundStarted(uint indexed round, uint date, uint deposit);
152     event ThunderstormUpdate(address addr, string eventType);
153 
154     Thunderstorm public thunderstorm;
155     GrowingControl.data private growingControl;
156 
157     // only contract creator access
158     modifier onlyOwner {if (msg.sender == owner) _;}
159 
160     constructor() public {
161         owner = msg.sender;
162         devAddr = msg.sender;
163 
164         addresses.length = 1;
165 
166         // set bounces for growingControl service
167         growingControl.min = 30 ether;
168         growingControl.max = 500 ether;
169     }
170 
171     // change advert address, only admin access (works before ownership resignation)
172     function setAdvertAddr(address addr) onlyOwner public {
173         advertAddr = addr;
174     }
175     // set date which enables control of growing function (limitation of investments per day)
176     function setGrowingControlStartAt(uint startAt) onlyOwner public {
177         growingControl.startAt = startAt;
178     }
179 
180     function getGrowingControlStartAt() public view returns (uint) {
181         return growingControl.startAt;
182     }
183 
184     // set max of investments per day. Only devAddr have access to this function
185     function setGrowingMaxPerDay(uint maxAmountPerDay) public {
186         require(maxAmountPerDay >= growingControl.min && maxAmountPerDay <= growingControl.max, "incorrect amount");
187         require(msg.sender == devAddr, "Only dev team have access to this function");
188         growingControl.maxAmountPerDay = maxAmountPerDay;
189     }
190     
191     function getInvestorData(address[] _addr, uint[] _deposit, uint[] _date, address[] _referrer) onlyOwner public {
192         // add initiated investors
193         for (uint i = 0; i < _addr.length; i++) {
194             uint id = addresses.length;
195             if (investors[_addr[i]].deposit == 0) {
196                 addresses.push(_addr[i]);
197                 depositAmount += _deposit[i];
198             }
199 
200             investors[_addr[i]] = Investor(id, _deposit[i], 1, 0, _date[i], _referrer[i]);
201 
202         }
203         lastPaymentDate = now;
204     }
205 
206     // main function, which accept new investments and do dividends payouts
207     // if you send 0 ETH to this function, you will receive your dividends
208     function() payable public {
209 
210         // ensure that payment not from contract
211         if (isContract()) {
212             revert();
213         }
214 
215         // if contract is on restarting phase - do some work before restart
216         if (pause) {
217             doRestart();
218             msg.sender.transfer(msg.value); // return all money to sender
219 
220             return;
221         }
222 
223         if (0 == msg.value) {
224             payDividends(); // do pay out
225             return;
226         }
227 
228         require(msg.value >= MINIMUM_INVEST, "Too small amount, minimum 0.01 ether");
229         Investor storage user = investors[msg.sender];
230 
231         if (user.id == 0) { // if no saved address, save it
232             user.id = addresses.push(msg.sender);
233             user.date = now;
234 
235             // check referrer
236             address referrer = bytesToAddress(msg.data);
237             if (investors[referrer].deposit > 0 && referrer != msg.sender) {
238                 user.referrer = referrer;
239             }
240         } else {
241             payDividends(); // else pay dividends before reinvest
242         }
243 
244         // get max investment amount for the current day, according to sent amount
245         // all excesses will be returned to sender later
246         uint investment = min(growingControl.getMaxInvestmentToday(), msg.value);
247         require(investment > 0, "Too much investments today");
248 
249         // update investor
250         user.deposit += investment;
251         user.deposits += 1;
252 
253         emit Invest(msg.sender, investment, user.referrer);
254 
255         depositAmount += investment;
256         lastPaymentDate = now;
257 
258 
259         if (devAddr.send(investment / 100 * devFee)) {
260             // project fee
261         }
262 
263         if (advertAddr.send(investment / 100 * advertFee)) {
264             // advert fee
265         }
266 
267         // referrer commission for all deposits
268         uint bonusAmount = investment / 100 * currentInterest;
269 
270         // user have referrer
271         if (user.referrer > 0x0) {
272             if (user.referrer.send(bonusAmount)) { // pay referrer commission
273                 emit Payout(user.referrer, bonusAmount, "referral", msg.sender);
274             }
275 
276             if (user.deposits == 1) { // only the first deposit cashback
277                 if (msg.sender.send(bonusAmount)) {
278                     emit Payout(msg.sender, bonusAmount, "cash-back", 0);
279                 }
280             }
281         } else if (thunderstorm.addr > 0x0 && thunderstorm.from + 24 hours > now) { // if investor does not have referrer, Thunderstorm takes the bonus
282             // also check Thunderstorm is active
283             if (thunderstorm.addr.send(bonusAmount)) { // pay bonus to current Thunderstorm
284                 emit Payout(thunderstorm.addr, bonusAmount, "thunderstorm", msg.sender);
285             }
286         }
287 
288         // check and maybe update current interest rate
289         considerCurrentInterest();
290         // add investment to the growingControl service
291         growingControl.addInvestment(investment);
292         // Thunderstorm has changed? do some checks
293         considerThunderstorm(investment);
294 
295         // return excess eth (if growingControl is active)
296         if (msg.value > investment) {
297             msg.sender.transfer(msg.value - investment);
298         }
299     }
300 
301     function getTodayInvestment() view public returns (uint)
302     {
303         return growingControl.getTodayInvestment();
304     }
305 
306     function getMaximumInvestmentPerDay() view public returns (uint)
307     {
308         return growingControl.maxAmountPerDay;
309     }
310 
311     function payDividends() private {
312         require(investors[msg.sender].id > 0, "Investor not found");
313         uint amount = getInvestorDividendsAmount(msg.sender);
314 
315         if (amount == 0) {
316             return;
317         }
318 
319         // save last paid out date
320         investors[msg.sender].date = now;
321 
322         // save total paid out for investor
323         investors[msg.sender].paidOut += amount;
324 
325         // save total paid out for contract
326         paidAmount += amount;
327 
328         uint balance = address(this).balance;
329 
330         // check contract balance, if not enough - do restart
331         if (balance < amount) {
332             pause = true;
333             amount = balance;
334         }
335 
336         msg.sender.transfer(amount);
337         emit Payout(msg.sender, amount, "payout", 0);
338 
339         // if investor has reached the limit (x2 profit) - delete him
340         if (investors[msg.sender].paidOut >= investors[msg.sender].deposit * profitThreshold) {
341             delete investors[msg.sender];
342         }
343     }
344 
345     // remove all investors and prepare data for the new round!
346     function doRestart() private {
347         uint txs;
348 
349         for (uint i = addresses.length - 1; i > 0; i--) {
350             delete investors[addresses[i]]; // remove investor
351             addresses.length -= 1; // decrease addr length
352             if (txs++ == 150) { // stop on 150 investors (to prevent out of gas exception)
353                 return;
354             }
355         }
356 
357         emit NextRoundStarted(round, now, depositAmount);
358         pause = false; // stop pause, play
359         round += 1; // increase round number
360         depositAmount = 0;
361         paidAmount = 0;
362         lastPaymentDate = now;
363     }
364 
365     function getInvestorCount() public view returns (uint) {
366         return addresses.length - 1;
367     }
368 
369     function considerCurrentInterest() internal
370     {
371         uint interest;
372 
373         // if balance is over 4k ETH - set interest rate for 1%
374         if (depositAmount >= 4000 ether) {
375             interest = 1;
376         } else if (depositAmount >= 1000 ether) { // if balance is more than 1k ETH - set interest rate for 2%
377             interest = 2;
378         } else {
379             interest = 3; // base = 3%
380         }
381 
382         // if interest has not changed, return
383         if (interest >= currentInterest) {
384             return;
385         }
386 
387         currentInterest = interest;
388     }
389 
390     // Thunderstorm!
391     // make the biggest investment today - and receive ref-commissions from ALL investors who not have a referrer in the next 10 days
392     function considerThunderstorm(uint amount) internal {
393         // if current Thunderstorm dead, delete him
394         if (thunderstorm.addr > 0x0 && thunderstorm.from + 10 days < now) {
395             thunderstorm.addr = 0x0;
396             thunderstorm.deposit = 0;
397             emit ThunderstormUpdate(msg.sender, "expired");
398         }
399 
400         // if the investment bigger than current Thunderstorm made - change Thunderstorm
401         if (amount > thunderstorm.deposit) {
402             thunderstorm = Thunderstorm(msg.sender, amount, now);
403             emit ThunderstormUpdate(msg.sender, "change");
404         }
405     }
406 
407     // calculate total dividends for investor from the last investment/payout date
408     // be careful  - max. one-time amount can cover 5 days of work
409     function getInvestorDividendsAmount(address addr) public view returns (uint) {
410         uint time = min(now - investors[addr].date, 5 days);
411         return investors[addr].deposit / 100 * currentInterest * time / 1 days;
412     }
413 
414     function bytesToAddress(bytes bys) private pure returns (address addr) {
415         assembly {
416             addr := mload(add(bys, 20))
417         }
418     }
419 
420     // check that there is no contract in the middle
421     function isContract() internal view returns (bool) {
422         return msg.sender != tx.origin;
423     }
424 
425     // get min value from a and b
426     function min(uint a, uint b) public pure returns (uint) {
427         if (a < b) return a;
428         else return b;
429     }
430 }