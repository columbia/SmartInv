1 //
2 //                    %(/************/#&
3 //               (**,                 ,**/#
4 //            %/*,                        **(&
5 //          (*,                              //%
6 //        %*,                                  /(
7 //       (*      ,************************/      /*%
8 //      //         /(                  (/,        ,/%
9 //     (*           //(               //            /%
10 //    //             */%             //             //
11 //    /*         (((((///(((( ((((((//(((((,         /(
12 //    /           ,/%   //        (/    /*           //
13 //    /             //   //(    %//   (/*            ,/
14 //    /              //   ,/%   //   (/,             (/
15 //    /             %(//%   / //    ///(             //
16 //    //          %(/, ,/(   /   %//  //(           /(
17 //    (/         (//     /#      (/,     //(        (/
18 //     ((     %(/,        (/    (/,        //(      /,
19 //      ((    /,           *(*#(/            /*   %/,
20 //      /((                 /*((                 ((/
21 //        *(%                                  #(
22 //          ((%                              #(,
23 //            *((%                        #((,
24 //               (((%                   ((/
25 //                   *(((###*#&%###((((*
26 //
27 //
28 //                       GORGONA.IO
29 //
30 // Earn on investment 3% daily!
31 // Receive your 3% cash-back when invest with referrer!
32 // Earn 3% from each referral deposit!
33 //
34 //
35 // HOW TO TAKE PARTICIPANT:
36 // Just send ETH to contract address (min. 0.01 ETH)
37 //
38 //
39 // HOW TO RECEIVE MY DIVIDENDS?
40 // Send 0 ETH to contract. No limits.
41 //
42 //
43 // INTEREST
44 // IF contract balance > 0 ETH = 3% per day
45 // IF contract balance > 1000 ETH = 2% per day
46 // IF contract balance > 4000 ETH = 1% per day
47 //
48 //
49 // DO NOT HOLD YOUR DIVIDENDS ON CONTRACT ACCOUNT!
50 // Max one-time payout is your dividends for 3 days of work.
51 // It would be better if your will request your dividends each day.
52 //
53 // For more information visit https://gorgona.io/
54 //
55 // Telegram chat (ru): https://t.me/gorgona_io
56 // Telegram chat (en): https://t.me/gorgona_io_en
57 //
58 // For support and requests telegram: @alex_gorgona_io
59 
60 pragma solidity ^0.4.24;
61 
62 
63 // service which controls amount of investments per day
64 // this service does not allow fast grow!
65 library GrowingControl {
66     using GrowingControl for data;
67 
68     // base structure for control investments per day
69     struct data {
70         uint min;
71         uint max;
72 
73         uint startAt;
74         uint maxAmountPerDay;
75         mapping(uint => uint) investmentsPerDay;
76     }
77 
78     // increase day investments
79     function addInvestment(data storage control, uint amount) internal
80     {
81         control.investmentsPerDay[getCurrentDay()] += amount;
82     }
83 
84     // get today current max investment
85     function getMaxInvestmentToday(data storage control) internal view returns (uint)
86     {
87         if (control.startAt == 0) {
88             return 10000 ether; // disabled controlling, allow 10000 eth
89         }
90 
91         if (control.startAt > now) {
92             return 10000 ether; // not started, allow 10000 eth
93         }
94 
95         return control.maxAmountPerDay - control.getTodayInvestment();
96     }
97 
98     function getCurrentDay() internal view returns (uint)
99     {
100         return now / 24 hours;
101     }
102 
103     // get amount of today investments
104     function getTodayInvestment(data storage control) internal view returns (uint)
105     {
106         return control.investmentsPerDay[getCurrentDay()];
107     }
108 }
109 
110 
111 // in the first days investments are allowed only for investors from Gorgona.v1
112 // if you was a member of Gorgona.v1, you can invest
113 library PreEntrance {
114     using PreEntrance for data;
115 
116     struct data {
117         mapping(address => bool) members;
118 
119         uint from;
120         uint to;
121         uint cnt;
122     }
123 
124     function isActive(data storage preEntrance) internal view returns (bool)
125     {
126         if (now < preEntrance.from) {
127             return false;
128         }
129 
130         if (now > preEntrance.to) {
131             return false;
132         }
133 
134         return true;
135     }
136 
137     // add new allowed to invest member
138     function add(data storage preEntrance, address[] addr) internal
139     {
140         for (uint i = 0; i < addr.length; i++) {
141             preEntrance.members[addr[i]] = true;
142             preEntrance.cnt ++;
143         }
144     }
145 
146     // check that addr is a member
147     function isMember(data storage preEntrance, address addr) internal view returns (bool)
148     {
149         return preEntrance.members[addr];
150     }
151 }
152 
153 contract Gorgona {
154     using GrowingControl for GrowingControl.data;
155     using PreEntrance for PreEntrance.data;
156 
157     // contract owner, must be 0x0000000000000000000,
158     // use Read Contract tab to check it!
159     address public owner;
160 
161     uint constant public MINIMUM_INVEST = 10000000000000000 wei;
162 
163     // current interest
164     uint public currentInterest = 3;
165 
166     // total deposited eth
167     uint public depositAmount;
168 
169     // total paid out eth
170     uint public paidAmount;
171 
172     // current round (restart)
173     uint public round = 1;
174 
175     // last investment date
176     uint public lastPaymentDate;
177 
178     // fee for advertising purposes
179     uint public advertFee = 10;
180 
181     // project admins fee
182     uint public devFee = 5;
183 
184     // maximum profit per investor (x2)
185     uint public profitThreshold = 2;
186 
187     // addr of project admins (not owner of the contract)
188     address public devAddr;
189 
190     // advert addr
191     address public advertAddr;
192 
193     // investors addresses
194     address[] public addresses;
195 
196     // mapping address to Investor
197     mapping(address => Investor) public investors;
198 
199     // currently on restart phase or not?
200     bool public pause;
201 
202     // Perseus structure
203     struct Perseus {
204         address addr;
205         uint deposit;
206         uint from;
207     }
208 
209     // Investor structure
210     struct Investor
211     {
212         uint id;
213         uint deposit; // deposit amount
214         uint deposits; // deposits count
215         uint paidOut; // total paid out
216         uint date; // last date of investment or paid out
217         address referrer;
218     }
219 
220     event Invest(address indexed addr, uint amount, address referrer);
221     event Payout(address indexed addr, uint amount, string eventType, address from);
222     event NextRoundStarted(uint indexed round, uint date, uint deposit);
223     event PerseusUpdate(address addr, string eventType);
224 
225     Perseus public perseus;
226     GrowingControl.data private growingControl;
227     PreEntrance.data private preEntrance;
228 
229     // only contract creator access
230     modifier onlyOwner {if (msg.sender == owner) _;}
231 
232     constructor() public {
233         owner = msg.sender;
234         devAddr = msg.sender;
235 
236         addresses.length = 1;
237 
238         // set bounces for growingControl service
239         growingControl.min = 30 ether;
240         growingControl.max = 500 ether;
241     }
242 
243     // change advert address, only admin access (works before ownership resignation)
244     function setAdvertAddr(address addr) onlyOwner public {
245         advertAddr = addr;
246     }
247 
248     // change owner, only admin access (works before ownership resignation)
249     function transferOwnership(address addr) onlyOwner public {
250         owner = addr;
251     }
252 
253     // set date which enables control of growing function (limitation of investments per day)
254     function setGrowingControlStartAt(uint startAt) onlyOwner public {
255         growingControl.startAt = startAt;
256     }
257 
258     function getGrowingControlStartAt() public view returns (uint) {
259         return growingControl.startAt;
260     }
261 
262     // set max of investments per day. Only devAddr have access to this function
263     function setGrowingMaxPerDay(uint maxAmountPerDay) public {
264         require(maxAmountPerDay >= growingControl.min && maxAmountPerDay <= growingControl.max, "incorrect amount");
265         require(msg.sender == devAddr, "Only dev team have access to this function");
266         growingControl.maxAmountPerDay = maxAmountPerDay;
267     }
268 
269     // add members to  PreEntrance, only these addresses will be allowed to invest in the first days
270     function addPreEntranceMembers(address[] addr, uint from, uint to) onlyOwner public
271     {
272         preEntrance.from = from;
273         preEntrance.to = to;
274         preEntrance.add(addr);
275     }
276 
277     function getPreEntranceFrom() public view returns (uint)
278     {
279         return preEntrance.from;
280     }
281 
282     function getPreEntranceTo() public view returns (uint)
283     {
284         return preEntrance.to;
285     }
286 
287     function getPreEntranceMemberCount() public view returns (uint)
288     {
289         return preEntrance.cnt;
290     }
291 
292     // main function, which accept new investments and do dividends payouts
293     // if you send 0 ETH to this function, you will receive your dividends
294     function() payable public {
295 
296         // ensure that payment not from contract
297         if (isContract()) {
298             revert();
299         }
300 
301         // if contract is on restarting phase - do some work before restart
302         if (pause) {
303             doRestart();
304             msg.sender.transfer(msg.value); // return all money to sender
305 
306             return;
307         }
308 
309         if (0 == msg.value) {
310             payDividends(); // do pay out
311             return;
312         }
313 
314         // if it is currently preEntrance phase
315         if (preEntrance.isActive()) {
316             require(preEntrance.isMember(msg.sender), "Only predefined members can make deposit");
317         }
318 
319         require(msg.value >= MINIMUM_INVEST, "Too small amount, minimum 0.01 ether");
320         Investor storage user = investors[msg.sender];
321 
322         if (user.id == 0) { // if no saved address, save it
323             user.id = addresses.push(msg.sender);
324             user.date = now;
325 
326             // check referrer
327             address referrer = bytesToAddress(msg.data);
328             if (investors[referrer].deposit > 0 && referrer != msg.sender) {
329                 user.referrer = referrer;
330             }
331         } else {
332             payDividends(); // else pay dividends before reinvest
333         }
334 
335         // get max investment amount for the current day, according to sent amount
336         // all excesses will be returned to sender later
337         uint investment = min(growingControl.getMaxInvestmentToday(), msg.value);
338         require(investment > 0, "Too much investments today");
339 
340         // update investor
341         user.deposit += investment;
342         user.deposits += 1;
343 
344         emit Invest(msg.sender, investment, user.referrer);
345 
346         depositAmount += investment;
347         lastPaymentDate = now;
348 
349 
350         if (devAddr.send(investment / 100 * devFee)) {
351             // project fee
352         }
353 
354         if (advertAddr.send(investment / 100 * advertFee)) {
355             // advert fee
356         }
357 
358         // referrer commission for all deposits
359         uint bonusAmount = investment / 100 * currentInterest;
360 
361         // user have referrer
362         if (user.referrer > 0x0) {
363             if (user.referrer.send(bonusAmount)) { // pay referrer commission
364                 emit Payout(user.referrer, bonusAmount, "referral", msg.sender);
365             }
366 
367             if (user.deposits == 1) { // only the first deposit cashback
368                 if (msg.sender.send(bonusAmount)) {
369                     emit Payout(msg.sender, bonusAmount, "cash-back", 0);
370                 }
371             }
372         } else if (perseus.addr > 0x0 && perseus.from + 24 hours > now) { // if investor does not have referrer, Perseus takes the bonus
373             // also check Perseus is active
374             if (perseus.addr.send(bonusAmount)) { // pay bonus to current Perseus
375                 emit Payout(perseus.addr, bonusAmount, "perseus", msg.sender);
376             }
377         }
378 
379         // check and maybe update current interest rate
380         considerCurrentInterest();
381         // add investment to the growingControl service
382         growingControl.addInvestment(investment);
383         // Perseus has changed? do some checks
384         considerPerseus(investment);
385 
386         // return excess eth (if growingControl is active)
387         if (msg.value > investment) {
388             msg.sender.transfer(msg.value - investment);
389         }
390     }
391 
392     function getTodayInvestment() view public returns (uint)
393     {
394         return growingControl.getTodayInvestment();
395     }
396 
397     function getMaximumInvestmentPerDay() view public returns (uint)
398     {
399         return growingControl.maxAmountPerDay;
400     }
401 
402     function payDividends() private {
403         require(investors[msg.sender].id > 0, "Investor not found");
404         uint amount = getInvestorDividendsAmount(msg.sender);
405 
406         if (amount == 0) {
407             return;
408         }
409 
410         // save last paid out date
411         investors[msg.sender].date = now;
412 
413         // save total paid out for investor
414         investors[msg.sender].paidOut += amount;
415 
416         // save total paid out for contract
417         paidAmount += amount;
418 
419         uint balance = address(this).balance;
420 
421         // check contract balance, if not enough - do restart
422         if (balance < amount) {
423             pause = true;
424             amount = balance;
425         }
426 
427         msg.sender.transfer(amount);
428         emit Payout(msg.sender, amount, "payout", 0);
429 
430         // if investor has reached the limit (x2 profit) - delete him
431         if (investors[msg.sender].paidOut >= investors[msg.sender].deposit * profitThreshold) {
432             delete investors[msg.sender];
433         }
434     }
435 
436     // remove all investors and prepare data for the new round!
437     function doRestart() private {
438         uint txs;
439 
440         for (uint i = addresses.length - 1; i > 0; i--) {
441             delete investors[addresses[i]]; // remove investor
442             addresses.length -= 1; // decrease addr length
443             if (txs++ == 150) { // stop on 150 investors (to prevent out of gas exception)
444                 return;
445             }
446         }
447 
448         emit NextRoundStarted(round, now, depositAmount);
449         pause = false; // stop pause, play
450         round += 1; // increase round number
451         depositAmount = 0;
452         paidAmount = 0;
453         lastPaymentDate = now;
454     }
455 
456     function getInvestorCount() public view returns (uint) {
457         return addresses.length - 1;
458     }
459 
460     function considerCurrentInterest() internal
461     {
462         uint interest;
463 
464         // if balance is over 4k ETH - set interest rate for 1%
465         if (depositAmount >= 4000 ether) {
466             interest = 1;
467         } else if (depositAmount >= 1000 ether) { // if balance is more than 1k ETH - set interest rate for 2%
468             interest = 2;
469         } else {
470             interest = 3; // base = 3%
471         }
472 
473         // if interest has not changed, return
474         if (interest >= currentInterest) {
475             return;
476         }
477 
478         currentInterest = interest;
479     }
480 
481     // Perseus!
482     // make the biggest investment today - and receive ref-commissions from ALL investors who not have a referrer in the next 24h
483     function considerPerseus(uint amount) internal {
484         // if current Perseus dead, delete him
485         if (perseus.addr > 0x0 && perseus.from + 24 hours < now) {
486             perseus.addr = 0x0;
487             perseus.deposit = 0;
488             emit PerseusUpdate(msg.sender, "expired");
489         }
490 
491         // if the investment bigger than current Perseus made - change Perseus
492         if (amount > perseus.deposit) {
493             perseus = Perseus(msg.sender, amount, now);
494             emit PerseusUpdate(msg.sender, "change");
495         }
496     }
497 
498     // calculate total dividends for investor from the last investment/payout date
499     // be careful  - max. one-time amount can cover 3 days of work
500     function getInvestorDividendsAmount(address addr) public view returns (uint) {
501         uint time = min(now - investors[addr].date, 3 days);
502         return investors[addr].deposit / 100 * currentInterest * time / 1 days;
503     }
504 
505     function bytesToAddress(bytes bys) private pure returns (address addr) {
506         assembly {
507             addr := mload(add(bys, 20))
508         }
509     }
510 
511     // check that there is no contract in the middle
512     function isContract() internal view returns (bool) {
513         return msg.sender != tx.origin;
514     }
515 
516     // get min value from a and b
517     function min(uint a, uint b) public pure returns (uint) {
518         if (a < b) return a;
519         else return b;
520     }
521 }