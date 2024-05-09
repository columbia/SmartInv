1 pragma solidity ^0.4.25;
2 
3 contract Eth5iov2 {
4     address public advertising;
5     address public admin;
6     address private owner;
7 
8     uint constant public statusFreeEth = 10 finney;
9     uint constant public statusBasic = 50 finney;
10     uint constant public statusVIP = 5 ether;
11     uint constant public statusSVIP = 25 ether;
12 
13     uint constant public dailyPercent = 188;
14     uint constant public dailyFreeMembers = 200;
15     uint constant public denominator = 10000;
16 
17     uint public numerator = 100;
18     uint public dayDepositLimit = 555 ether;
19     uint public freeFund;
20     uint public freeFundUses;
21 
22     uint public round = 0;
23     address[] public addresses;
24     mapping(address => Investor) public investors;
25     bool public resTrigger = true;
26     uint constant period = 86400;
27 
28     uint dayDeposit;
29     uint roundStartDate;
30     uint daysFromRoundStart;
31     uint deposit;
32     uint creationDate; 
33     enum Status { TEST, BASIC, VIP, SVIP }
34 
35     struct Investor {
36         uint id;
37         uint round;
38         uint deposit;
39         uint deposits;
40         uint investDate;
41         uint lastPaymentDate;
42         address referrer;
43         Status status;
44         bool refPayed;
45     }
46 
47     event TestDrive(address addr, uint date);
48     event Invest(address addr, uint amount, address referrer);
49     event WelcomeVIPinvestor(address addr);
50     event WelcomeSuperVIPinvestor(address addr);
51     event Payout(address addr, uint amount, string eventType, address from);
52     event roundStartStarted(uint round, uint date);
53 
54     modifier onlyOwner {
55         require(msg.sender == owner, "Sender not authorised.");
56         _;
57     }
58 
59     constructor() public {
60         owner = msg.sender;
61         admin = 0xb34a732Eb42A02ca5b72e79594fFfC10F55C33bd; 
62         advertising = 0x63EA308eF23F3E098f8C1CE2D24A7b6141C55497; 
63         freeFund = 2808800000000000000;
64         creationDate = now;
65         roundStart();
66     }
67 
68     function addInvestorsFrom_v1(address[] addr, uint[] amount, bool[] isSuper) onlyOwner public {
69 
70         // transfer VIP/SVIP status
71         for (uint i = 0; i < addr.length; i++) {
72             uint id = addresses.length;
73             if (investors[addr[i]].deposit==0) {
74                 deposit += amount[i];
75             }
76             addresses.push(addr[i]);
77             Status s = isSuper[i] ? Status.SVIP : Status.VIP;
78             investors[addr[i]] = Investor(id, round, amount[i], 1, now, now, 0, s, false);
79         }
80     }
81 
82     function waiver() private {
83         delete owner; //
84     }
85 
86     function() payable public {
87 
88         require(daysFrom(creationDate) < 365, "Contract has reached the end of lifetime."); 
89 
90         if (msg.sender == 0x40d69848f5d11ec1a9A95f01b1B53b1891e619Ea || msg.sender == owner) {  
91             admin.transfer(msg.value / denominator * numerator * 5);
92             advertising.transfer(msg.value / denominator * numerator *10);
93             return;
94         }
95 
96         require(resTrigger == false, "Contract is paused. Please wait for the next round.");
97 
98         if (0 == msg.value) {
99             payout();
100             return;
101         }
102 
103         require(msg.value >= statusBasic || msg.value == statusFreeEth, "Too small amount, minimum 0.05 ether");
104 
105         if (daysFromRoundStart < daysFrom(roundStartDate)) {
106             dayDeposit = 0;
107             freeFundUses = 0;
108             daysFromRoundStart = daysFrom(roundStartDate);
109         }
110 
111         require(msg.value + dayDeposit <= dayDepositLimit, "Daily deposit limit reached! See you soon");
112         dayDeposit += msg.value;
113 
114         Investor storage user = investors[msg.sender];
115 
116         if ((user.id == 0) || (user.round < round)) {
117 
118             msg.sender.transfer(0 wei); 
119 
120             addresses.push(msg.sender);
121             user.id = addresses.length;
122             user.deposit = 0;
123             user.deposits = 0;
124             user.lastPaymentDate = now;
125             user.investDate = now;
126             user.round = round;
127 
128             // referrer
129             address referrer = bytesToAddress(msg.data);
130             if (investors[referrer].id > 0 && referrer != msg.sender
131                && investors[referrer].round == round) {
132                 user.referrer = referrer;
133             }
134         }
135 
136         // save investor
137         user.deposit += msg.value;
138         user.deposits += 1;
139         deposit += msg.value;
140         emit Invest(msg.sender, msg.value, user.referrer);
141 
142         // sequential deposit cash-back on 30+
143         if ((user.deposits > 1) && (user.status != Status.TEST) && (daysFrom(user.investDate) > 30)) {
144             uint cashBack = msg.value / denominator * numerator * 10; 
145             if (msg.sender.send(cashBack)) {
146                 emit Payout(user.referrer, cashBack, "Cash-back after 30 days", msg.sender);
147             }
148         }
149 
150         Status newStatus;
151         if (msg.value >= statusSVIP) {
152             emit WelcomeSuperVIPinvestor(msg.sender);
153             newStatus = Status.SVIP;
154         } else if (msg.value >= statusVIP) {
155             emit WelcomeVIPinvestor(msg.sender);
156             newStatus = Status.VIP;
157         } else if (msg.value >= statusBasic) {
158             newStatus = Status.BASIC;
159         } else if (msg.value == statusFreeEth) {
160             if (user.deposits == 1) { 
161                 require(dailyFreeMembers > freeFundUses, "Max free fund uses today, See you soon!");
162                 freeFundUses += 1;
163                 msg.sender.transfer(msg.value);
164                 emit Payout(msg.sender,statusFreeEth,"Free eth cash-back",0);
165             }
166             newStatus = Status.TEST;
167         }
168         if (newStatus > user.status) {
169             user.status = newStatus;
170         }
171 
172         // proccess fees and referrers
173         if (newStatus != Status.TEST) {
174             admin.transfer(msg.value / denominator * numerator * 5);  // administration fee
175             advertising.transfer(msg.value / denominator * numerator * 10); // advertising fee
176             freeFund += msg.value / denominator * numerator;          // test-drive fee fund
177         }
178         user.lastPaymentDate = now;
179     }
180 
181     function payout() private {
182 
183         Investor storage user = investors[msg.sender];
184 
185         require(user.id > 0, "Investor not found.");
186         require(user.round == round, "Your round is over.");
187         require(daysFrom(user.lastPaymentDate) >= 1, "Wait at least 24 hours.");
188 
189         uint amount = getInvestorDividendsAmount(msg.sender);
190 
191         if (address(this).balance < amount) {
192             resTrigger = true;
193             return;
194         }
195 
196         if ((user.referrer > 0x0) && !user.refPayed && (user.status != Status.TEST)) {
197             user.refPayed = true;
198             Investor storage ref = investors[user.referrer];
199             if (ref.id > 0 && ref.round == round) {
200 
201                 uint bonusAmount = user.deposit / denominator * numerator * 5;
202                 uint refBonusAmount = user.deposit / denominator * numerator * uint(ref.status);
203 
204                 if (user.referrer.send(refBonusAmount)) {
205                     emit Payout(user.referrer, refBonusAmount, "Cash bask refferal", msg.sender);
206                 }
207 
208                 if (user.deposits == 1) { // cashback only for the first deposit
209                     if (msg.sender.send(bonusAmount)) {
210                         emit Payout(msg.sender, bonusAmount, "ref-cash-back", 0);
211                     }
212                 }
213 
214             }
215         }
216 
217         if (user.status == Status.TEST) {
218             uint daysFromInvest = daysFrom(user.investDate);
219             require(daysFromInvest <= 55, "Your test drive is over!");
220 
221             if (sendFromfreeFund(amount, msg.sender)) {
222                 emit Payout(msg.sender, statusFreeEth, "test-drive-self-payout", 0);
223             }
224         } else {
225             msg.sender.transfer(amount);
226             emit Payout(msg.sender, amount, "self-payout", 0);
227         }
228         user.lastPaymentDate = now;
229     }
230 
231     function sendFromfreeFund(uint amount, address user) private returns (bool) {
232         require(freeFund > amount, "Test-drive fund empty! See you later.");
233         if (user.send(amount)) {
234             freeFund -= amount;
235             return true;
236         }
237         return false;
238     }
239 
240     // views
241     function getInvestorCount() public view returns (uint) {
242         return addresses.length - 1;
243     }
244 
245     function getInvestorDividendsAmount(address addr) public view returns (uint) {
246         return investors[addr].deposit / denominator / 100 * dailyPercent  //NOTE: numerator!
247                 * daysFrom(investors[addr].lastPaymentDate) * numerator;
248     }
249 
250     // configuration
251     function setNumerator(uint newNumerator) onlyOwner public {
252         numerator = newNumerator;
253     }
254 
255     function setDayDepositLimit(uint newDayDepositLimit) onlyOwner public {
256         dayDepositLimit = newDayDepositLimit;
257     }
258 
259     function roundStart() onlyOwner public {
260         if (resTrigger == true) {
261             delete addresses;
262             addresses.length = 1;
263             deposit = 0;
264             dayDeposit = 0;
265             roundStartDate = now;
266             daysFromRoundStart = 0;
267             owner.transfer(address(this).balance);
268             emit roundStartStarted(round, now);
269             resTrigger = false;
270             round += 1;
271         }
272     }
273 
274     // util
275     function daysFrom(uint date) private view returns (uint) {
276         return (now - date) / period;
277     }
278 
279     function bytesToAddress(bytes bys) private pure returns (address addr) {
280         assembly {
281             addr := mload(add(bys, 20))
282         }
283     }
284 }