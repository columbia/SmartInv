1 pragma solidity ^0.4.25;
2 
3 contract eth5io {
4     address public owner;
5     address public admin;
6     uint constant public TEST_DRIVE_INVEST = 5 finney;
7     uint constant public MINIMUM_INVEST = 50 finney;
8     uint constant public MINIMUM_VIP_INVEST = 5 ether;
9     uint constant public MINIMUM_SVIP_INVEST = 25 ether;
10     uint constant public OWNER_FEE_DENOMINATOR = 100;
11     uint constant public FUND_FEE_DENOMINATOR = 100;
12     uint constant public INTEREST = 5;
13     uint constant public FUND_DAILY_USER = 500;
14     uint public multiplier = 1;
15     uint public dailyDepositLimit = 555 ether;
16     uint public fund;
17     uint  public funduser;
18     
19     uint public round = 0;
20     address[] public addresses;
21     mapping(address => Investor) public investors;
22     bool public pause = true;
23     uint constant period = 60 * 60 * 24;
24     
25     
26     uint dailyDeposit;
27     uint roundStartDate;
28     uint daysFromRoundStart;
29     uint deposit;
30     enum Status { TEST, BASIC, VIP, SVIP }
31 
32     struct Investor {
33         uint id;
34         uint round;
35         uint deposit;
36         uint deposits;
37         uint investDate;
38         uint lastPaymentDate;
39         address referrer;
40         Status status;
41         bool refPayed;
42     }
43 
44     event TestDrive(address addr, uint date);
45     event Invest(address addr, uint amount, address referrer);
46     event WelcomeVIP(address addr);
47     event WelcomeSuperVIP(address addr);
48     event Payout(address addr, uint amount, string eventType, address from);
49     event NextRoundStarted(uint round, uint date);
50 
51     modifier onlyOwner {
52         require(msg.sender == owner, "Sender not authorised.");
53         _;
54     }
55 
56     constructor() public {
57 
58         owner = msg.sender;
59         admin = msg.sender;
60         
61         nextRound();
62     }
63 
64     function() payable public {
65 
66         if((msg.sender == owner) || (msg.sender == admin)) {
67             return;
68         }
69 
70         require(pause == false, "5eth.io is paused. Please wait for the next round.");
71 
72         if (0 == msg.value) {
73             payout();
74             return;
75         }
76 
77         require(msg.value >= MINIMUM_INVEST || msg.value == TEST_DRIVE_INVEST, "Too small amount, minimum 0.005 ether");
78         
79         if (daysFromRoundStart < daysFrom(roundStartDate)) {
80             dailyDeposit = 0;
81             funduser = 0;
82             daysFromRoundStart = daysFrom(roundStartDate);
83         }
84         
85         require(msg.value + dailyDeposit <= dailyDepositLimit, "Daily deposit limit reached! See you soon");
86         dailyDeposit += msg.value;
87         
88         Investor storage user = investors[msg.sender];
89 
90         if ((user.id == 0) || (user.round < round)) {
91             
92             msg.sender.transfer(0 wei); 
93 
94             addresses.push(msg.sender);
95             user.id = addresses.length;
96             user.deposit = 0;
97             user.deposits = 0;
98             user.lastPaymentDate = now;
99             user.investDate = now;
100             user.round = round;
101 
102             // referrer
103             address referrer = bytesToAddress(msg.data);
104             if (investors[referrer].id > 0 && referrer != msg.sender
105                && investors[referrer].round == round) {
106                 user.referrer = referrer;
107             }
108         }
109 
110         // save investor
111         user.deposit += msg.value;
112         user.deposits += 1;
113         deposit += msg.value;
114         emit Invest(msg.sender, msg.value, user.referrer);
115 
116         // sequential deposit cash-back on 20+ day
117         if ((user.deposits > 1) && (user.status != Status.TEST) && (daysFrom(user.investDate) > 20)) {
118             uint mul = daysFrom(user.investDate) > 40 ? 4 : 2;
119             uint cashBack = (msg.value / 100) *INTEREST* mul;
120             if (msg.sender.send(cashBack)) {
121                 emit Payout(user.referrer, cashBack, "seq-deposit-cash-back", msg.sender);
122             }
123         }
124         
125         Status newStatus;
126         if (msg.value >= MINIMUM_SVIP_INVEST) {
127             emit WelcomeSuperVIP(msg.sender);
128             newStatus = Status.SVIP;
129         } else if (msg.value >= MINIMUM_VIP_INVEST) {
130             emit WelcomeVIP(msg.sender);
131             newStatus = Status.VIP;
132         } else if (msg.value >= MINIMUM_INVEST) {
133             newStatus = Status.BASIC;
134         } else if (msg.value == TEST_DRIVE_INVEST) {
135             if (user.deposits == 1){
136                 funduser += 1;
137                 require(FUND_DAILY_USER>funduser,"Fund full, See you soon!");
138                 emit TestDrive(msg.sender, now);
139                 fund += msg.value;
140                 if(sendFromFund(TEST_DRIVE_INVEST, msg.sender)){
141                     
142                     emit Payout(msg.sender,TEST_DRIVE_INVEST,"test-drive-cashback",0);
143                 }
144             }
145             newStatus = Status.TEST;
146         }
147         if (newStatus > user.status) {
148             user.status = newStatus;
149         }
150         // proccess fees and referrers
151         if(newStatus!=Status.TEST){
152             admin.transfer(msg.value / OWNER_FEE_DENOMINATOR * 4); // administration fee
153             owner.transfer(msg.value / OWNER_FEE_DENOMINATOR * 10); // owners fee
154             fund += msg.value / FUND_FEE_DENOMINATOR;          // test-drive fund
155         }
156         user.lastPaymentDate = now;
157     }
158 
159     function payout() private {
160         
161         Investor storage user = investors[msg.sender];
162 
163         require(user.id > 0, "Investor not found.");
164         require(user.round == round, "Your round is over.");
165 
166         require(daysFrom(user.lastPaymentDate) >= 1, "Wait at least 24 hours.");
167         
168         uint amount = getInvestorDividendsAmount(msg.sender);
169         if (address(this).balance < amount) {
170             pause = true;
171             return;
172         }
173         
174         if ((user.referrer > 0x0) && !user.refPayed && (user.status != Status.TEST)) {
175             user.refPayed = true;
176             Investor storage ref = investors[user.referrer];
177             if (ref.id > 0 && ref.round == round) {
178                 uint bonusAmount = (user.deposit / 100) * INTEREST;
179                 uint refBonusAmount = bonusAmount * uint(ref.status);
180             
181                 if (user.referrer.send(refBonusAmount)) {
182                     emit Payout(user.referrer, refBonusAmount, "referral", msg.sender);
183                 }
184             
185                 if (user.deposits == 1) { // cashback only for the first deposit
186                     if (msg.sender.send(bonusAmount)) {
187                         emit Payout(msg.sender, bonusAmount, "ref-cash-back", 0);
188                     }
189                 }
190             }
191         }
192         
193         if (user.status == Status.TEST) {
194             uint daysFromInvest = daysFrom(user.investDate);
195             require(daysFromInvest <= 20, "Your test drive is over!");
196 
197             if (sendFromFund(amount, msg.sender)) {
198                 emit Payout(msg.sender, TEST_DRIVE_INVEST, "test-drive-self-payout", 0);
199             }
200         } else {
201             msg.sender.transfer(amount);
202             emit Payout(msg.sender, amount, "self-payout", 0);
203         }
204         user.lastPaymentDate = now;
205     }
206 
207     function sendFromFund(uint amount, address user) private returns (bool) {
208 
209         require(fund > amount, "Test-drive fund empty! See you later.");
210         if (user.send(amount)) {
211             fund -= amount;
212             return true;
213         }
214         return false;
215     }
216 
217     // views
218     
219     function getInvestorCount() public view returns (uint) {
220 
221         return addresses.length - 1;
222     }
223 
224     function getInvestorDividendsAmount(address addr) public view returns (uint) {
225 
226         return investors[addr].deposit / 100 * INTEREST 
227                 * daysFrom(investors[addr].lastPaymentDate) * multiplier;
228     }
229 
230     // configuration
231     
232     function setMultiplier(uint newMultiplier) onlyOwner public {
233 
234         multiplier = newMultiplier;
235     }
236 
237     function setDailyDepositLimit(uint newDailyDepositLimit) onlyOwner public {
238 
239         dailyDepositLimit = newDailyDepositLimit;
240     }
241 
242     function setAdminAddress(address newAdmin) onlyOwner public {
243 
244         admin = newAdmin;
245     }
246 
247     function addInvestors(address[] addr, uint[] amount, bool[] isSuper) onlyOwner public {
248 
249         // create VIP/SVIP refs
250         for (uint i = 0; i < addr.length; i++) {
251             uint id = addresses.length;
252             if (investors[addr[i]].deposit == 0) {
253                 addresses.push(addr[i]);
254                 deposit += amount[i];
255             }
256             
257             Status s = isSuper[i] ? Status.SVIP : Status.VIP;
258             investors[addr[i]] = Investor(id, round, amount[i], 1, now, now, 0, s, false);
259 
260         }
261     }
262 
263     function nextRound() onlyOwner public {
264             if(pause==true){
265                 delete addresses;
266                 addresses.length = 1;
267                 deposit = 0;
268                 fund = 0;
269         
270                 dailyDeposit = 0;
271                 roundStartDate = now;
272                 daysFromRoundStart = 0;
273 
274                 owner.transfer(address(this).balance);
275 
276                 emit NextRoundStarted(round, now);
277                 pause = false;
278                 round += 1;
279             }
280         
281     }
282 
283     // util
284     
285     function daysFrom(uint date) private view returns (uint) {
286         return (now - date) / period;
287     }
288 
289     function bytesToAddress(bytes bys) private pure returns (address addr) {
290 
291         assembly {
292             addr := mload(add(bys, 20))
293         }
294     }
295 }