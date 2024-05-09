1 pragma solidity ^0.4.24;
2 
3 contract Gorgona {
4     address public owner;
5     address public adminAddr;
6     uint constant public MASS_TRANSACTION_LIMIT = 150;
7     uint constant public MINIMUM_INVEST = 10000000000000000 wei;
8     uint constant public INTEREST = 3;
9     uint public depositAmount;
10     uint public round;
11     uint public lastPaymentDate;
12     GorgonaKiller public gorgonaKiller;
13     address[] public addresses;
14     mapping(address => Investor) public investors;
15     bool public pause;
16 
17     struct Investor
18     {
19         uint id;
20         uint deposit;
21         uint deposits;
22         uint date;
23         address referrer;
24     }
25 
26     struct GorgonaKiller
27     {
28         address addr;
29         uint deposit;
30     }
31 
32     event Invest(address addr, uint amount, address referrer);
33     event Payout(address addr, uint amount, string eventType, address from);
34     event NextRoundStarted(uint round, uint date, uint deposit);
35     event GorgonaKillerChanged(address addr, uint deposit);
36 
37     modifier onlyOwner {if (msg.sender == owner) _;}
38 
39     constructor() public {
40         owner = msg.sender;
41         adminAddr = msg.sender;
42         addresses.length = 1;
43         round = 1;
44     }
45 
46     function transferOwnership(address addr) onlyOwner public {
47         owner = addr;
48     }
49 
50     function addInvestors(address[] _addr, uint[] _deposit, uint[] _date, address[] _referrer) onlyOwner public {
51         // add initiated investors
52         for (uint i = 0; i < _addr.length; i++) {
53             uint id = addresses.length;
54             if (investors[_addr[i]].deposit == 0) {
55                 addresses.push(_addr[i]);
56                 depositAmount += _deposit[i];
57             }
58 
59             investors[_addr[i]] = Investor(id, _deposit[i], 1, _date[i], _referrer[i]);
60             emit Invest(_addr[i], _deposit  [i], _referrer[i]);
61 
62             if (investors[_addr[i]].deposit > gorgonaKiller.deposit) {
63                 gorgonaKiller = GorgonaKiller(_addr[i], investors[_addr[i]].deposit);
64             }
65         }
66         lastPaymentDate = now;
67     }
68 
69     function() payable public {
70         if (owner == msg.sender) {
71             return;
72         }
73 
74         if (0 == msg.value) {
75             payoutSelf();
76             return;
77         }
78 
79         require(false == pause, "Gorgona is restarting. Please wait.");
80         require(msg.value >= MINIMUM_INVEST, "Too small amount, minimum 0.01 ether");
81         Investor storage user = investors[msg.sender];
82 
83         if (user.id == 0) {
84             // ensure that payment not from hacker contract
85             msg.sender.transfer(0 wei);
86             addresses.push(msg.sender);
87             user.id = addresses.length;
88             user.date = now;
89 
90             // referrer
91             address referrer = bytesToAddress(msg.data);
92             if (investors[referrer].deposit > 0 && referrer != msg.sender) {
93                 user.referrer = referrer;
94             }
95         } else {
96             payoutSelf();
97         }
98 
99         // save investor
100         user.deposit += msg.value;
101         user.deposits += 1;
102 
103         emit Invest(msg.sender, msg.value, user.referrer);
104 
105         depositAmount += msg.value;
106         lastPaymentDate = now;
107 
108         adminAddr.transfer(msg.value / 5); // project fee
109         uint bonusAmount = (msg.value / 100) * INTEREST; // referrer commission for all deposits
110 
111         if (user.referrer > 0x0) {
112             if (user.referrer.send(bonusAmount)) {
113                 emit Payout(user.referrer, bonusAmount, "referral", msg.sender);
114             }
115 
116             if (user.deposits == 1) { // cashback only for the first deposit
117                 if (msg.sender.send(bonusAmount)) {
118                     emit Payout(msg.sender, bonusAmount, "cash-back", 0);
119                 }
120             }
121         } else if (gorgonaKiller.addr > 0x0) {
122             if (gorgonaKiller.addr.send(bonusAmount)) {
123                 emit Payout(gorgonaKiller.addr, bonusAmount, "killer", msg.sender);
124             }
125         }
126 
127         if (user.deposit > gorgonaKiller.deposit) {
128             gorgonaKiller = GorgonaKiller(msg.sender, user.deposit);
129             emit GorgonaKillerChanged(msg.sender, user.deposit);
130         }
131     }
132 
133     function payout(uint offset) public
134     {
135         if (pause == true) {
136             doRestart();
137             return;
138         }
139 
140         uint txs;
141         uint amount;
142 
143         for (uint idx = addresses.length - offset - 1; idx >= 1 && txs < MASS_TRANSACTION_LIMIT; idx--) {
144             address addr = addresses[idx];
145             if (investors[addr].date + 20 hours > now) {
146                 continue;
147             }
148 
149             amount = getInvestorDividendsAmount(addr);
150             investors[addr].date = now;
151 
152             if (address(this).balance < amount) {
153                 pause = true;
154                 return;
155             }
156 
157             if (addr.send(amount)) {
158                 emit Payout(addr, amount, "bulk-payout", 0);
159             }
160 
161             txs++;
162         }
163     }
164 
165     function payoutSelf() private {
166         require(investors[msg.sender].id > 0, "Investor not found.");
167         uint amount = getInvestorDividendsAmount(msg.sender);
168 
169         investors[msg.sender].date = now;
170         if (address(this).balance < amount) {
171             pause = true;
172             return;
173         }
174 
175         msg.sender.transfer(amount);
176         emit Payout(msg.sender, amount, "self-payout", 0);
177     }
178 
179     function doRestart() private {
180         uint txs;
181         address addr;
182 
183         for (uint i = addresses.length - 1; i > 0; i--) {
184             addr = addresses[i];
185             addresses.length -= 1;
186             delete investors[addr];
187             if (txs++ == MASS_TRANSACTION_LIMIT) {
188                 return;
189             }
190         }
191 
192         emit NextRoundStarted(round, now, depositAmount);
193         pause = false;
194         round += 1;
195         depositAmount = 0;
196         lastPaymentDate = now;
197 
198         delete gorgonaKiller;
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