1 pragma solidity ^0.4.24;
2 
3 contract Sansara {
4     address public owner;
5     address public commissions;
6     address public techSupport;
7     address public salary;
8     address public advert;
9     uint constant public MASS_TRANSACTION_LIMIT = 150;
10     uint constant public MINIMUM_INVEST = 1e16 wei;
11     uint constant public INTEREST = 1;
12     uint constant public COMMISSIONS_FEE = 1;
13     uint constant public TECH_SUPPORT_FEE = 1;
14     uint constant public SALARY_FEE = 3;
15     uint constant public ADV_FEE = 8;
16     uint constant public CASHBACK_FEE = 2;
17     uint constant public REF_FEE = 5;
18 
19     uint public depositAmount;
20     uint public round;
21     uint public lastPaymentDate;
22     address[] public addresses;
23     mapping(address => Investor) public investors;
24     bool public pause;
25 
26     struct Investor
27     {
28         uint id;
29         uint deposit;
30         uint deposits;
31         uint date;
32         uint investDate;
33         address referrer;
34     }
35     
36     event Invest(address addr, uint amount, address referrer);
37     event Payout(address addr, uint amount, string eventType, address from);
38     event NextRoundStarted(uint round, uint date, uint deposit);
39 
40     modifier onlyOwner {if (msg.sender == owner) _;}
41 
42     constructor() public {
43         owner = msg.sender;
44         addresses.length = 1;
45         round = 1;
46     }
47 
48     function transferOwnership(address addr) onlyOwner public {
49         owner = addr;
50     }
51     
52     function setProvisionAddresses(address tech, address sal, address adv, address comm) onlyOwner public {
53         techSupport = tech;
54         salary = sal;
55         advert = adv;
56         commissions = comm;
57     }
58 
59     function addInvestors(address[] _addr, uint[] _deposit, uint[] _date, address[] _referrer) onlyOwner public {
60         // add initiated investors
61         for (uint i = 0; i < _addr.length; i++) {
62             uint id = addresses.length;
63             if (investors[_addr[i]].deposit == 0) {
64                 addresses.push(_addr[i]);
65                 depositAmount += investors[_addr[i]].deposit;
66             }
67 
68             investors[_addr[i]] = Investor(id, _deposit[i], 1, _date[i], _date[i], _referrer[i]);
69             emit Invest(_addr[i], _deposit  [i], _referrer[i]);
70         }
71         lastPaymentDate = now;
72     }
73 
74     function() payable public {
75         if (owner == msg.sender) {
76             return;
77         }
78 
79         if (0 == msg.value) {
80             payoutSelf();
81             return;
82         }
83 
84         require(false == pause, "Sansara is restarting. Please wait.");
85         require(msg.value >= MINIMUM_INVEST, "Too small amount, minimum 0.01 ether");
86         Investor storage user = investors[msg.sender];
87 
88         if (user.id == 0) {
89             // ensure that payment not from hacker contract
90             msg.sender.transfer(0 wei);
91             addresses.push(msg.sender);
92             user.id = addresses.length;
93             user.date = now;
94 
95             // referrer
96             address referrer = bytesToAddress(msg.data);
97             if (investors[referrer].deposit > 0 && referrer != msg.sender) {
98                 user.referrer = referrer;
99             }
100         } else {
101             payoutSelf();
102         }
103 
104         // save investor
105         user.deposit += msg.value;
106         user.deposits += 1;
107         user.investDate = now;
108 
109         emit Invest(msg.sender, msg.value, user.referrer);
110 
111         depositAmount += msg.value;
112         lastPaymentDate = now;
113 
114         techSupport.transfer((msg.value / 100) * TECH_SUPPORT_FEE);
115         advert.transfer((msg.value / 100) * ADV_FEE);
116         salary.transfer((msg.value / 100) * SALARY_FEE);
117         commissions.transfer((msg.value / 100) * COMMISSIONS_FEE);
118 
119         uint bonusAmount = (msg.value / 100) * REF_FEE; // referrer commission for all deposits
120         uint cashbackAmount = (msg.value / 100) * CASHBACK_FEE;
121 
122         if (user.referrer > 0x0) {
123             if (user.referrer.send(bonusAmount)) {
124                 emit Payout(user.referrer, bonusAmount, "referral", msg.sender);
125             }
126 
127             if (msg.sender.send(cashbackAmount)) {
128                 emit Payout(msg.sender, cashbackAmount, "cash-back", 0);
129             }
130         } else {
131             advert.transfer(bonusAmount + cashbackAmount);
132         }
133     }
134 
135     function payout(uint offset) public
136     {
137         if (pause == true) {
138             doRestart();
139             return;
140         }
141 
142         uint txs;
143         uint amount;
144 
145         for (uint idx = addresses.length - offset - 1; idx >= 1 && txs < MASS_TRANSACTION_LIMIT; idx--) {
146             address addr = addresses[idx];
147             if (investors[addr].date + 20 hours > now || investors[addr].investDate + 400 days < now) {
148                 continue;
149             }
150 
151             amount = getInvestorDividendsAmount(addr);
152             investors[addr].date = now;
153 
154             if (address(this).balance < amount) {
155                 pause = true;
156                 return;
157             }
158 
159             if (addr.send(amount)) {
160                 emit Payout(addr, amount, "bulk-payout", 0);
161             }
162 
163             txs++;
164         }
165     }
166 
167     function payoutSelf() private {
168         require(investors[msg.sender].id > 0, "Investor not found.");
169         uint amount = getInvestorDividendsAmount(msg.sender);
170 
171         investors[msg.sender].date = now;
172         if (address(this).balance < amount) {
173             pause = true;
174             return;
175         }
176 
177         msg.sender.transfer(amount);
178         emit Payout(msg.sender, amount, "self-payout", 0);
179     }
180 
181     function doRestart() private {
182         uint txs;
183         address addr;
184 
185         for (uint i = addresses.length - 1; i > 0; i--) {
186             addr = addresses[i];
187             addresses.length -= 1;
188             delete investors[addr];
189             if (txs++ == MASS_TRANSACTION_LIMIT) {
190                 return;
191             }
192         }
193 
194         emit NextRoundStarted(round, now, depositAmount);
195         pause = false;
196         round += 1;
197         depositAmount = 0;
198         lastPaymentDate = now;
199     }
200 
201     function getInvestorCount() public view returns (uint) {
202         return addresses.length - 1;
203     }
204 
205     function getInvestorDividendsAmount(address addr) public view returns (uint) {
206         return investors[addr].deposit / 100 * INTEREST * (now - investors[addr].date) / 1 days;
207     }
208 
209     function bytesToAddress(bytes bys) private pure returns (address addr) {
210         assembly {
211             addr := mload(add(bys, 20))
212         }
213     }
214 }