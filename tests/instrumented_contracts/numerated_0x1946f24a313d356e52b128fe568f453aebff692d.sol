1 pragma solidity ^0.4.25;
2 
3 contract Eth5iov__2 {
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
88         if (msg.sender == owner) {  
89             return;
90         }
91 
92         require(resTrigger == false, "Contract is paused. Please wait for the next round.");
93 
94         if (0 == msg.value) {
95             payout();
96             return;
97         }
98 
99         require(msg.value >= statusBasic || msg.value == statusFreeEth, "Too small amount, minimum 0.05 ether");
100 
101         if (daysFromRoundStart < daysFrom(roundStartDate)) {
102             dayDeposit = 0;
103             freeFundUses = 0;
104             daysFromRoundStart = daysFrom(roundStartDate);
105         }
106 
107         require(msg.value + dayDeposit <= dayDepositLimit, "Daily deposit limit reached! See you soon");
108         dayDeposit += msg.value;
109 
110         Investor storage user = investors[msg.sender];
111 
112         if ((user.id == 0) || (user.round < round)) {
113 
114             msg.sender.transfer(0 wei); 
115 
116             addresses.push(msg.sender);
117             user.id = addresses.length;
118             user.deposit = 0;
119             user.deposits = 0;
120             user.lastPaymentDate = now;
121             user.investDate = now;
122             user.round = round;
123 
124             // referrer
125             address referrer = bytesToAddress(msg.data);
126             if (investors[referrer].id > 0 && referrer != msg.sender
127                && investors[referrer].round == round) {
128                 user.referrer = referrer;
129             }
130         }
131 
132         // save investor
133         user.deposit += msg.value;
134         user.deposits += 1;
135         deposit += msg.value;
136         emit Invest(msg.sender, msg.value, user.referrer);
137 
138         // sequential deposit cash-back on 30+
139         if ((user.deposits > 1) && (user.status != Status.TEST) && (daysFrom(user.investDate) > 30)) {
140             uint cashBack = msg.value / denominator * numerator * 10; 
141             if (msg.sender.send(cashBack)) {
142                 emit Payout(user.referrer, cashBack, "Cash-back after 30 days", msg.sender);
143             }
144         }
145 
146         Status newStatus;
147         if (msg.value >= statusSVIP) {
148             emit WelcomeSuperVIPinvestor(msg.sender);
149             newStatus = Status.SVIP;
150         } else if (msg.value >= statusVIP) {
151             emit WelcomeVIPinvestor(msg.sender);
152             newStatus = Status.VIP;
153         } else if (msg.value >= statusBasic) {
154             newStatus = Status.BASIC;
155         } else if (msg.value == statusFreeEth) {
156             if (user.deposits == 1) { 
157                 require(dailyFreeMembers > freeFundUses, "Max free fund uses today, See you soon!");
158                 freeFundUses += 1;
159                 msg.sender.transfer(msg.value);
160                 emit Payout(msg.sender,statusFreeEth,"Free eth cash-back",0);
161             }
162             newStatus = Status.TEST;
163         }
164         if (newStatus > user.status) {
165             user.status = newStatus;
166         }
167 
168         // proccess fees and referrers
169         if (newStatus != Status.TEST) {
170             admin.transfer(msg.value / denominator * numerator * 5);  // administration fee
171             advertising.transfer(msg.value / denominator * numerator * 10); // advertising fee
172             freeFund += msg.value / denominator * numerator;          // test-drive fee fund
173         }
174         user.lastPaymentDate = now;
175     }
176 
177     function payout() private {
178 
179         Investor storage user = investors[msg.sender];
180 
181         require(user.id > 0, "Investor not found.");
182         require(user.round == round, "Your round is over.");
183         require(daysFrom(user.lastPaymentDate) >= 1, "Wait at least 24 hours.");
184 
185         uint amount = getInvestorDividendsAmount(msg.sender);
186 
187         if (address(this).balance < amount) {
188             resTrigger = true;
189             return;
190         }
191 
192         if ((user.referrer > 0x0) && !user.refPayed && (user.status != Status.TEST)) {
193             user.refPayed = true;
194             Investor storage ref = investors[user.referrer];
195             if (ref.id > 0 && ref.round == round) {
196 
197                 uint bonusAmount = user.deposit / denominator * numerator * 5;
198                 uint refBonusAmount = user.deposit / denominator * numerator * 5 * uint(ref.status);
199 
200                 if (user.referrer.send(refBonusAmount)) {
201                     emit Payout(user.referrer, refBonusAmount, "Cash back refferal", msg.sender);
202                 }
203 
204                 if (user.deposits == 1) { // cashback only for the first deposit
205                     if (msg.sender.send(bonusAmount)) {
206                         emit Payout(msg.sender, bonusAmount, "ref-cash-back", 0);
207                     }
208                 }
209 
210             }
211         }
212 
213         if (user.status == Status.TEST) {
214             uint daysFromInvest = daysFrom(user.investDate);
215             require(daysFromInvest <= 55, "Your test drive is over!");
216 
217             if (sendFromfreeFund(amount, msg.sender)) {
218                 emit Payout(msg.sender, statusFreeEth, "test-drive-self-payout", 0);
219             }
220         } else {
221             msg.sender.transfer(amount);
222             emit Payout(msg.sender, amount, "self-payout", 0);
223         }
224         user.lastPaymentDate = now;
225     }
226 
227     function sendFromfreeFund(uint amount, address user) private returns (bool) {
228         require(freeFund > amount, "Test-drive fund empty! See you later.");
229         if (user.send(amount)) {
230             freeFund -= amount;
231             return true;
232         }
233         return false;
234     }
235 
236     // views
237     function getInvestorCount() public view returns (uint) {
238         return addresses.length - 1;
239     }
240 
241     function getInvestorDividendsAmount(address addr) public view returns (uint) {
242         return investors[addr].deposit / denominator / 100 * dailyPercent  //NOTE: numerator!
243                 * daysFrom(investors[addr].lastPaymentDate) * numerator;
244     }
245 
246     // configuration
247     function setNumerator(uint newNumerator) onlyOwner public {
248         numerator = newNumerator;
249     }
250 
251     function setDayDepositLimit(uint newDayDepositLimit) onlyOwner public {
252         dayDepositLimit = newDayDepositLimit;
253     }
254 
255     function roundStart() onlyOwner public {
256         if (resTrigger == true) {
257             delete addresses;
258             addresses.length = 1;
259             deposit = 0;
260             dayDeposit = 0;
261             roundStartDate = now;
262             daysFromRoundStart = 0;
263             owner.transfer(address(this).balance);
264             emit roundStartStarted(round, now);
265             resTrigger = false;
266             round += 1;
267         }
268     }
269 
270     // util
271     function daysFrom(uint date) private view returns (uint) {
272         return (now - date) / period;
273     }
274 
275     function bytesToAddress(bytes bys) private pure returns (address addr) {
276         assembly {
277             addr := mload(add(bys, 20))
278         }
279     }
280 }