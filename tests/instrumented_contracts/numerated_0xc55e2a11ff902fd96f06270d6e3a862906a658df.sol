1 pragma solidity ^0.5.7;
2 
3 library MyEtherFundControl {
4     using MyEtherFundControl for data;
5 
6     struct data {
7         uint min;
8         uint max;
9 
10         uint startAt;
11         uint maxAmountPerDay;
12         mapping(uint => uint) investmentsPerDay;
13     }
14 
15     function addInvestment(data storage control, uint amount) internal{
16         control.investmentsPerDay[getCurrentDay()] += amount;
17     }
18 
19     function getMaxInvestmentToday(data storage control) internal view returns (uint){
20         if (control.startAt == 0) {
21             return 10000 ether;
22         }
23 
24         if (control.startAt > now) {
25             return 10000 ether;
26         }
27 
28         return control.maxAmountPerDay - control.getTodayInvestment();
29     }
30 
31     function getCurrentDay() internal view returns (uint){
32         return now / 24 hours;
33     }
34 
35     function getTodayInvestment(data storage control) internal view returns (uint){
36         return control.investmentsPerDay[getCurrentDay()];
37     }
38 }
39 
40 
41 contract MyEtherFund {
42     using MyEtherFundControl for MyEtherFundControl.data;
43 
44     address public owner;
45 
46     uint constant public MIN_INVEST = 10000000000000000 wei;
47 
48     uint public currentInterest = 3;
49 
50     uint public depositAmount;
51 
52     uint public paidAmount;
53 
54     uint public round = 1;
55 
56     uint public lastPaymentDate;
57 
58     uint public advertisingCommission = 10;
59 
60     uint public devCommission = 5;
61 
62     uint public profitThreshold = 2;
63 
64     address payable public devAddress;
65 
66     address payable public advertiserAddress;
67 
68     // investors addresses
69     address[] public addresses;
70 
71     // mapping address to Investor
72     mapping(address => Investor) public investors;
73 
74     // currently on restart phase or not?
75     bool public pause;
76 
77     struct TopInvestor {
78         address payable addr;
79         uint deposit;
80         uint from;
81     }
82 
83     struct Investor{
84         uint id;
85         uint deposit;
86         uint deposits;
87         uint paidOut;
88         uint date;
89         address payable referrer;
90     }
91 
92     event Invest(address indexed addr, uint amount, address referrer);
93     event Payout(address indexed addr, uint amount, string eventType, address from);
94     event NextRoundStarted(uint indexed round, uint date, uint deposit);
95     event PerseusUpdate(address addr, string eventType);
96 
97     TopInvestor public top_investor;
98     MyEtherFundControl.data private myEtherFundControl;
99 
100     // only contract creator access
101     modifier onlyOwner {if (msg.sender == owner) _;}
102 
103     constructor() public {
104         owner = msg.sender;
105         devAddress = msg.sender;
106         advertiserAddress = msg.sender;
107 
108         addresses.length = 1;
109 
110         myEtherFundControl.min = 30 ether;
111         myEtherFundControl.max = 500 ether;
112     }
113 
114     // change advertiser address
115     function setAdvertiserAddr(address payable addr) onlyOwner public {
116         advertiserAddress = addr;
117     }
118 
119     // change owner
120     function transferOwnership(address payable addr) onlyOwner public {
121         owner = addr;
122     }
123 
124     function setMyEtherFundControlStartAt(uint startAt) onlyOwner public {
125         myEtherFundControl.startAt = startAt;
126     }
127 
128     function getMyEtherFundControlStartAt() public view returns (uint) {
129         return myEtherFundControl.startAt;
130     }
131 
132     // set max of investments per day. Only devAddress have access to this function
133     function setGrowingMaxPerDay(uint maxAmountPerDay) public {
134         require(maxAmountPerDay >= myEtherFundControl.min && maxAmountPerDay <= myEtherFundControl.max, "incorrect amount");
135         require(msg.sender == devAddress, "Only dev team have access to this function");
136         myEtherFundControl.maxAmountPerDay = maxAmountPerDay;
137     }
138 
139     // main function, which accept new investments and do dividends payouts
140     // if you send 0 ETH to this function, you will receive your dividends
141     function() payable external {
142 
143         // ensure that payment not from contract
144         if (isContract()) {
145             revert();
146         }
147 
148         // if contract is on restarting phase - do some work before restart
149         if (pause) {
150             doRestart();
151             msg.sender.transfer(msg.value); // return all money to sender
152 
153             return;
154         }
155 
156         if (0 == msg.value) {
157             payoutDividends(); // do pay out
158             return;
159         }
160         
161 
162         require(msg.value >= MIN_INVEST, "Too small amount, minimum 0.01 ether");
163         Investor storage user = investors[msg.sender];
164 
165         if (user.id == 0) { // if no saved address, save it
166             user.id = addresses.push(msg.sender);
167             user.date = now;
168 
169             // check referrer
170             address payable referrer = bytesToAddress(msg.data);
171             if (investors[referrer].deposit > 0 && referrer != msg.sender) {
172                 user.referrer = referrer;
173             }
174         } else {
175             payoutDividends(); // else pay dividends before reinvest
176         }
177 
178         uint investment = min(myEtherFundControl.getMaxInvestmentToday(), msg.value);
179         require(investment > 0, "Too much investments today");
180 
181         // update investor
182         user.deposit += investment;
183         user.deposits += 1;
184 
185         emit Invest(msg.sender, investment, user.referrer);
186 
187         depositAmount += investment;
188         lastPaymentDate = now;
189 
190 
191         if (devAddress.send(investment / 100 * devCommission)) {
192             // project fee
193         }
194 
195         if (advertiserAddress.send(investment / 100 * advertisingCommission)) {
196             // advert fee
197         }
198 
199         // referrer commission for all deposits
200         uint bonusAmount = investment / 100 * currentInterest;
201 
202         // user have referrer
203         if (user.referrer != address(0)) {
204             if (user.referrer.send(bonusAmount)) { // pay referrer commission
205                 emit Payout(user.referrer, bonusAmount, "referral", msg.sender);
206             }
207 
208             if (user.deposits == 1) { // only the first deposit cashback
209                 if (msg.sender.send(bonusAmount)) {
210                     emit Payout(msg.sender, bonusAmount, "cash-back", address(0));
211                 }
212             }
213         } else if (top_investor.addr != address(0) && top_investor.from + 24 hours > now) {
214             if (top_investor.addr.send(bonusAmount)) { // pay bonus to current Perseus
215                 emit Payout(top_investor.addr, bonusAmount, "perseus", msg.sender);
216             }
217         }
218 
219         // check and maybe update current interest rate
220         considerCurrentInterest();
221         // add investment to the myEtherFundControl service
222         myEtherFundControl.addInvestment(investment);
223         // Perseus has changed? do some checks
224         considerTopInvestor(investment);
225 
226         // return excess eth (if myEtherFundControl is active)
227         if (msg.value > investment) {
228             msg.sender.transfer(msg.value - investment);
229         }
230     }
231 
232     function getTodayInvestment() view public returns (uint){
233         return myEtherFundControl.getTodayInvestment();
234     }
235 
236     function getMaximumInvestmentPerDay() view public returns (uint){
237         return myEtherFundControl.maxAmountPerDay;
238     }
239 
240     function payoutDividends() private {
241         require(investors[msg.sender].id > 0, "Investor not found");
242         uint amount = getInvestorDividendsAmount(msg.sender);
243 
244         if (amount == 0) {
245             return;
246         }
247 
248         // save last paid out date
249         investors[msg.sender].date = now;
250 
251         // save total paid out for investor
252         investors[msg.sender].paidOut += amount;
253 
254         // save total paid out for contract
255         paidAmount += amount;
256 
257         uint balance = address(this).balance;
258 
259         // check contract balance, if not enough - do restart
260         if (balance < amount) {
261             pause = true;
262             amount = balance;
263         }
264 
265         msg.sender.transfer(amount);
266         emit Payout(msg.sender, amount, "payout", address(0));
267 
268         // if investor has reached the limit (x2 profit) - delete him
269         if (investors[msg.sender].paidOut >= investors[msg.sender].deposit * profitThreshold) {
270             delete investors[msg.sender];
271         }
272     }
273 
274     // remove all investors and prepare data for the new round!
275     function doRestart() private {
276         uint txs;
277 
278         for (uint i = addresses.length - 1; i > 0; i--) {
279             delete investors[addresses[i]]; // remove investor
280             addresses.length -= 1; // decrease addr length
281             if (txs++ == 150) { // 150 to prevent gas over use
282                 return;
283             }
284         }
285 
286         emit NextRoundStarted(round, now, depositAmount);
287         pause = false; // stop pause, play
288         round += 1; // increase round number
289         depositAmount = 0;
290         paidAmount = 0;
291         lastPaymentDate = now;
292     }
293 
294     function getInvestorCount() public view returns (uint) {
295         return addresses.length - 1;
296     }
297 
298     function considerCurrentInterest() internal{
299         uint interest;
300 
301         // if 4000 ETH - set interest rate for 1%
302         if (depositAmount >= 4000 ether) {
303             interest = 1;
304         } else if (depositAmount >= 1000 ether) { // if 1000 ETH - set interest rate for 2%
305             interest = 2;
306         } else {
307             interest = 3; // base = 3%
308         }
309 
310         // if interest has not changed, return
311         if (interest >= currentInterest) {
312             return;
313         }
314 
315         currentInterest = interest;
316     }
317 
318     // top investor in 24 hours
319     function considerTopInvestor(uint amount) internal {
320         // if current dead, delete him
321         if (top_investor.addr != address(0) && top_investor.from + 24 hours < now) {
322             top_investor.addr = address(0);
323             top_investor.deposit = 0;
324             emit PerseusUpdate(msg.sender, "expired");
325         }
326 
327         // if the investment bigger than current made - change top investor
328         if (amount > top_investor.deposit) {
329             top_investor = TopInvestor(msg.sender, amount, now);
330             emit PerseusUpdate(msg.sender, "change");
331         }
332     }
333     
334     function getInvestorDividendsAmount(address addr) public view returns (uint) {
335         uint time = now - investors[addr].date;
336         return investors[addr].deposit / 100 * currentInterest * time / 1 days;
337     }
338 
339     function bytesToAddress(bytes memory bys) private pure returns (address payable addr) {
340         assembly {
341             addr := mload(add(bys, 20))
342         }
343     }
344 
345     // check that there is no contract in the middle
346     function isContract() internal view returns (bool) {
347         return msg.sender != tx.origin;
348     }
349 
350     // get min value from a and b
351     function min(uint a, uint b) public pure returns (uint) {
352         if (a < b) return a;
353         else return b;
354     }
355 }