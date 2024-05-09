1 //
2 //             ZEUS SMART CONTRACT
3 //
4 // Earn on investment 4% daily!
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
18 // IF contract balance < 500 ETH = 4% per day
19 // IF contract balance > 500 ETH = 3% per day
20 // IF contract balance > 2000 ETH = 2% per day
21 //
22 //
23 // DO NOT HOLD YOUR DIVIDENDS ON CONTRACT ACCOUNT!
24 // Max one-time payout is your dividends for 3 days of work.
25 // It would be better if your will request your dividends each day.
26 //
27 // For more information visit http://zeus-contract.com
28 //
29 // Telegram channel: https://t.me/gorgona_io
30 //
31 // For support and requests telegram: @ZAURMAHEAMEDSHUIN
32 
33 pragma solidity ^0.4.24;
34 
35 
36 // service which controls amount of investments per day
37 // this service does not allow fast grow!
38 library GrowingControl {
39     using GrowingControl for data;
40 
41     // base structure for control investments per day
42     struct data {
43         uint min;
44         uint max;
45 
46         uint startAt;
47         uint maxAmountPerDay;
48         mapping(uint => uint) investmentsPerDay;
49     }
50 
51     // increase day investments
52     function addInvestment(data storage control, uint amount) internal
53     {
54         control.investmentsPerDay[getCurrentDay()] += amount;
55     }
56 
57     // get today current max investment
58     function getMaxInvestmentToday(data storage control) internal view returns (uint)
59     {
60         if (control.startAt == 0) {
61             return 10000 ether; // disabled controlling, allow 10000 eth
62         }
63 
64         if (control.startAt > now) {
65             return 10000 ether; // not started, allow 10000 eth
66         }
67 
68         return control.maxAmountPerDay - control.getTodayInvestment();
69     }
70 
71     function getCurrentDay() internal view returns (uint)
72     {
73         return now / 24 hours;
74     }
75 
76     // get amount of today investments
77     function getTodayInvestment(data storage control) internal view returns (uint)
78     {
79         return control.investmentsPerDay[getCurrentDay()];
80     }
81 }
82 
83 contract Zeus {
84     using GrowingControl for GrowingControl.data;
85 
86     // contract owner set to 0x0000000000000000000000000000000000000000,
87     address owner = 0x0000000000000000000000000000000000000000;
88 
89     uint constant public MINIMUM_INVEST = 10000000000000000 wei;
90 
91     // current interest
92     uint public currentInterest = 3;
93 
94     // total deposited eth
95     uint public depositAmount;
96 
97     // total paid out eth
98     uint public paidAmount;
99 
100     // current round (restart)
101     uint public round = 1;
102 
103     // last investment date
104     uint public lastPaymentDate;
105 
106     // fee for advertising purposes
107     uint public advertFee = 10;
108 
109     // project admins fee
110     uint public devFee = 5;
111 
112     // maximum profit per investor (x2)
113     uint public profitThreshold = 2;
114 
115     // addr of project admins (not owner of the contract)
116     address public devAddr;
117 
118     // advert addr
119     address public advertAddr;
120 
121     // investors addresses
122     address[] public addresses;
123 
124     // mapping address to Investor
125     mapping(address => Investor) public investors;
126 
127     // currently on restart phase or not?
128     bool public pause;
129 
130     // Thunderstorm structure
131     struct Thunderstorm {
132         address addr;
133         uint deposit;
134         uint from;
135     }
136 
137     // Investor structure
138     struct Investor
139     {
140         uint id;
141         uint deposit; // deposit amount
142         uint deposits; // deposits count
143         uint paidOut; // total paid out
144         uint date; // last date of investment or paid out
145         address referrer;
146     }
147 
148     event Invest(address indexed addr, uint amount, address referrer);
149     event Payout(address indexed addr, uint amount, string eventType, address from);
150     event NextRoundStarted(uint indexed round, uint date, uint deposit);
151     event ThunderstormUpdate(address addr, string eventType);
152 
153     Thunderstorm public thunderstorm;
154     GrowingControl.data private growingControl;
155 
156     // only contract creator access
157     modifier onlyOwner {if (msg.sender == owner) _;}
158 
159     constructor() public {
160         owner = msg.sender;
161         devAddr = msg.sender;
162 
163         addresses.length = 1;
164 
165         // set bounces for growingControl service
166         growingControl.min = 30 ether;
167         growingControl.max = 500 ether;
168         
169         advertAddr = 0x404648C63D19DB0d23203CB146C0b573D4E79E0c;
170     }
171 
172     // change advert address, only admin access (works before ownership resignation)
173     function setAdvertAddr(address addr) onlyOwner public {
174         advertAddr = addr;
175     }
176     // set date which enables control of growing function (limitation of investments per day)
177     function setGrowingControlStartAt(uint startAt) onlyOwner public {
178         growingControl.startAt = startAt;
179     }
180 
181     function getGrowingControlStartAt() public view returns (uint) {
182         return growingControl.startAt;
183     }
184 
185     // set max of investments per day. Only devAddr have access to this function
186     function setGrowingMaxPerDay(uint maxAmountPerDay) public {
187         require(maxAmountPerDay >= growingControl.min && maxAmountPerDay <= growingControl.max, "incorrect amount");
188         require(msg.sender == devAddr, "Only dev team have access to this function");
189         growingControl.maxAmountPerDay = maxAmountPerDay;
190     }
191     
192     function getInvestorData(address[] _addr, uint[] _deposit, uint[] _date, address[] _referrer) onlyOwner public {
193         // add initiated investors
194         for (uint i = 0; i < _addr.length; i++) {
195             uint id = addresses.length;
196             if (investors[_addr[i]].deposit == 0) {
197                 addresses.push(_addr[i]);
198                 depositAmount += _deposit[i];
199             }
200 
201             investors[_addr[i]] = Investor(id, _deposit[i], 1, 0, _date[i], _referrer[i]);
202 
203         }
204         lastPaymentDate = now;
205     }
206 
207     // main function, which accept new investments and do dividends payouts
208     // if you send 0 ETH to this function, you will receive your dividends
209     function() payable public {
210 
211         // ensure that payment not from contract
212         if (isContract()) {
213             revert();
214         }
215 
216         // if contract is on restarting phase - do some work before restart
217         if (pause) {
218             doRestart();
219             msg.sender.transfer(msg.value); // return all money to sender
220 
221             return;
222         }
223 
224         if (0 == msg.value) {
225             payDividends(); // do pay out
226             return;
227         }
228 
229         require(msg.value >= MINIMUM_INVEST, "Too small amount, minimum 0.01 ether");
230         Investor storage user = investors[msg.sender];
231 
232         if (user.id == 0) { // if no saved address, save it
233             user.id = addresses.push(msg.sender);
234             user.date = now;
235 
236             // check referrer
237             address referrer = bytesToAddress(msg.data);
238             if (investors[referrer].deposit > 0 && referrer != msg.sender) {
239                 user.referrer = referrer;
240             }
241         } else {
242             payDividends(); // else pay dividends before reinvest
243         }
244 
245         // get max investment amount for the current day, according to sent amount
246         // all excesses will be returned to sender later
247         uint investment = min(growingControl.getMaxInvestmentToday(), msg.value);
248         require(investment > 0, "Too much investments today");
249 
250         // update investor
251         user.deposit += investment;
252         user.deposits += 1;
253 
254         emit Invest(msg.sender, investment, user.referrer);
255 
256         depositAmount += investment;
257         lastPaymentDate = now;
258 
259 
260         if (devAddr.send(investment / 100 * devFee)) {
261             // project fee
262         }
263 
264         if (advertAddr.send(investment / 100 * advertFee)) {
265             // advert fee
266         }
267 
268         // referrer commission for all deposits
269         uint bonusAmount = investment / 100 * currentInterest;
270 
271         // user have referrer
272         if (user.referrer > 0x0) {
273             if (user.referrer.send(bonusAmount)) { // pay referrer commission
274                 emit Payout(user.referrer, bonusAmount, "referral", msg.sender);
275             }
276 
277             if (user.deposits == 1) { // only the first deposit cashback
278                 if (msg.sender.send(bonusAmount)) {
279                     emit Payout(msg.sender, bonusAmount, "cash-back", 0);
280                 }
281             }
282         } else if (thunderstorm.addr > 0x0 && thunderstorm.from + 10 days > now) { // if investor does not have referrer, Thunderstorm takes the bonus
283             // also check Thunderstorm is active
284             if (thunderstorm.addr.send(bonusAmount)) { // pay bonus to current Thunderstorm
285                 emit Payout(thunderstorm.addr, bonusAmount, "thunderstorm", msg.sender);
286             }
287         }
288 
289         // check and maybe update current interest rate
290         considerCurrentInterest();
291         // add investment to the growingControl service
292         growingControl.addInvestment(investment);
293         // Thunderstorm has changed? do some checks
294         considerThunderstorm(investment);
295 
296         // return excess eth (if growingControl is active)
297         if (msg.value > investment) {
298             msg.sender.transfer(msg.value - investment);
299         }
300     }
301 
302     function getTodayInvestment() view public returns (uint)
303     {
304         return growingControl.getTodayInvestment();
305     }
306 
307     function getMaximumInvestmentPerDay() view public returns (uint)
308     {
309         return growingControl.maxAmountPerDay;
310     }
311 
312     function payDividends() private {
313         require(investors[msg.sender].id > 0, "Investor not found");
314         uint amount = getInvestorDividendsAmount(msg.sender);
315 
316         if (amount == 0) {
317             return;
318         }
319 
320         // save last paid out date
321         investors[msg.sender].date = now;
322 
323         // save total paid out for investor
324         investors[msg.sender].paidOut += amount;
325 
326         // save total paid out for contract
327         paidAmount += amount;
328 
329         uint balance = address(this).balance;
330 
331         // check contract balance, if not enough - do restart
332         if (balance < amount) {
333             pause = true;
334             amount = balance;
335         }
336 
337         msg.sender.transfer(amount);
338         emit Payout(msg.sender, amount, "payout", 0);
339 
340         // if investor has reached the limit (x2 profit) - delete him
341         if (investors[msg.sender].paidOut >= investors[msg.sender].deposit * profitThreshold) {
342             delete investors[msg.sender];
343         }
344     }
345 
346     // remove all investors and prepare data for the new round!
347     function doRestart() private {
348         uint txs;
349 
350         for (uint i = addresses.length - 1; i > 0; i--) {
351             delete investors[addresses[i]]; // remove investor
352             addresses.length -= 1; // decrease addr length
353             if (txs++ == 150) { // stop on 150 investors (to prevent out of gas exception)
354                 return;
355             }
356         }
357 
358         emit NextRoundStarted(round, now, depositAmount);
359         pause = false; // stop pause, play
360         round += 1; // increase round number
361         depositAmount = 0;
362         paidAmount = 0;
363         lastPaymentDate = now;
364     }
365 
366     function getInvestorCount() public view returns (uint) {
367         return addresses.length - 1;
368     }
369 
370     function considerCurrentInterest() internal
371     {
372         uint interest;
373 
374         // if balance is over 2k ETH - set interest rate for 2%
375         if (depositAmount >= 2000 ether) {
376             interest = 2;
377         } else if (depositAmount >= 500 ether) { // if balance is more than 500 ETH - set interest rate for 3%
378             interest = 3;
379         } else {
380             interest = 4; // base = 4%
381         }
382 
383         // if interest has not changed, return
384         if (interest >= currentInterest) {
385             return;
386         }
387 
388         currentInterest = interest;
389     }
390 
391     // Thunderstorm!
392     // make the biggest investment today - and receive ref-commissions from ALL investors who not have a referrer in the next 10 days
393     function considerThunderstorm(uint amount) internal {
394         // if current Thunderstorm dead, delete him
395         if (thunderstorm.addr > 0x0 && thunderstorm.from + 10 days < now) {
396             thunderstorm.addr = 0x0;
397             thunderstorm.deposit = 0;
398             emit ThunderstormUpdate(msg.sender, "expired");
399         }
400 
401         // if the investment bigger than current Thunderstorm made - change Thunderstorm
402         if (amount > thunderstorm.deposit) {
403             thunderstorm = Thunderstorm(msg.sender, amount, now);
404             emit ThunderstormUpdate(msg.sender, "change");
405         }
406     }
407 
408     // calculate total dividends for investor from the last investment/payout date
409     // be careful  - max. one-time amount can cover 5 days of work
410     function getInvestorDividendsAmount(address addr) public view returns (uint) {
411         uint time = min(now - investors[addr].date, 5 days);
412         return investors[addr].deposit / 100 * currentInterest * time / 1 days;
413     }
414 
415     function bytesToAddress(bytes bys) private pure returns (address addr) {
416         assembly {
417             addr := mload(add(bys, 20))
418         }
419     }
420 
421     // check that there is no contract in the middle
422     function isContract() internal view returns (bool) {
423         return msg.sender != tx.origin;
424     }
425 
426     // get min value from a and b
427     function min(uint a, uint b) public pure returns (uint) {
428         if (a < b) return a;
429         else return b;
430     }
431 }