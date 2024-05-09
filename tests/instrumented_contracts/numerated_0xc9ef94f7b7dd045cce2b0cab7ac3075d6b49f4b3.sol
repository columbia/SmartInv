1 pragma solidity ^0.4.24;
2 
3 contract SmartGrowup {
4     address public owner;
5     address public support;
6     uint public depAmount;
7     uint public stage;
8     uint public lastPayDate;
9     
10     uint constant public MASS_LIMIT = 150;
11     uint constant public MIN_INVEST = 10000000000000000 wei;
12 
13     address[] public addresses;
14     mapping(address => Depositor) public depositors;
15     bool public pause;
16 
17     struct Depositor
18     {
19         uint id;
20         uint deposit;
21         uint deposits;
22         uint date;
23         address referrer;
24     }
25 
26     event Deposit(address addr, uint amount, address referrer);
27     event Payout(address addr, uint amount, string eventType, address from);
28     event NextStageStarted(uint round, uint date, uint deposit);
29 
30     modifier onlyOwner {if (msg.sender == owner) _;}
31 
32     constructor() public {
33         owner = msg.sender;
34         support = msg.sender;
35         addresses.length = 1;
36         stage = 1;
37     }
38 
39     function transferOwnership(address addr) onlyOwner public {
40         owner = addr;
41     }
42 
43     function addDepositors(address[] _addr, uint[] _deposit, uint[] _date, address[] _referrer) onlyOwner public {
44         // add initiated investors
45         for (uint i = 0; i < _addr.length; i++) {
46             uint id = addresses.length;
47             if (depositors[_addr[i]].deposit == 0) {
48                 addresses.push(_addr[i]);
49                 depAmount += _deposit[i];
50             }
51 
52             depositors[_addr[i]] = Depositor(id, _deposit[i], 1, _date[i], _referrer[i]);
53             emit Deposit(_addr[i], _deposit  [i], _referrer[i]);
54         }
55         lastPayDate = now;
56     }
57 
58     function() payable public {
59         if (owner == msg.sender) {
60             return;
61         }
62 
63         if (0 == msg.value) {
64             payoutSelf();
65             return;
66         }
67 
68         require(false == pause, "Restarting. Please wait.");
69         require(msg.value >= MIN_INVEST, "Small amount, minimum 0.01 ether");
70         Depositor storage user = depositors[msg.sender];
71 
72         if (user.id == 0) {
73             // ensure that payment not from hacker contract
74             msg.sender.transfer(0 wei);
75             addresses.push(msg.sender);
76             user.id = addresses.length;
77             user.date = now;
78 
79             // referrer
80             address referrer = transferBytestoAddress(msg.data);
81             if (depositors[referrer].deposit > 0 && referrer != msg.sender) {
82                 user.referrer = referrer;
83             }
84         } else {
85             payoutSelf();
86         }
87 
88         // counter deposits and value deposits
89         user.deposit += msg.value;
90         user.deposits += 1;
91 
92         emit Deposit(msg.sender, msg.value, user.referrer);
93 
94         depAmount += msg.value;
95         lastPayDate = now;
96 
97         support.transfer(msg.value / 5); // project fee for supporting
98         uint bonusAmount = (msg.value / 100) * 3; // referrer commission for all deposits
99 
100         if (user.referrer > 0x0) {
101             if (user.referrer.send(bonusAmount)) {
102                 emit Payout(user.referrer, bonusAmount, "referral", msg.sender);
103             }
104 
105             if (user.deposits == 1) { // cashback only for the first deposit 3%
106                 if (msg.sender.send(bonusAmount)) {
107                     emit Payout(msg.sender, bonusAmount, "CashBack", 0);
108                 }
109             }
110         } 
111 
112 
113     }
114 
115     function payout(uint removal) public
116     {
117         if (pause == true) {
118             goRestart();
119             return;
120         }
121 
122         uint txs;
123         uint amount;
124 
125         for (uint idx = addresses.length - removal - 1; idx >= 1 && txs < MASS_LIMIT; idx--) {
126             address addr = addresses[idx];
127             if (depositors[addr].date + 20 hours > now) {
128                 continue;
129             }
130 
131             amount = getDividendsAmount(addr);
132             depositors[addr].date = now;
133 
134             if (address(this).balance < amount) {
135                 pause = true;
136                 return;
137             }
138 
139             if (addr.send(amount)) {
140                 emit Payout(addr, amount, "Payout", 0);
141             }
142 
143             txs++;
144         }
145     }
146 
147     function payoutSelf() private {
148         require(depositors[msg.sender].id > 0, "Investor not found.");
149         uint amount = getDividendsAmount(msg.sender);
150 
151         depositors[msg.sender].date = now;
152         if (address(this).balance < amount) {
153             pause = true;
154             return;
155         }
156 
157         msg.sender.transfer(amount);
158         emit Payout(msg.sender, amount, "Autopayout", 0);
159     }
160 
161 
162     function getCount() public view returns (uint) {
163         return addresses.length - 1;
164     }
165 
166     function getDividendsAmount(address addr) public view returns (uint) {
167         return depositors[addr].deposit / 100 * 4 * (now - depositors[addr].date) / 1 days;
168     }
169 
170     function transferBytestoAddress(bytes byt) private pure returns (address addr) {
171         assembly {
172             addr := mload(add(byt, 20))
173         }
174     }
175     
176     function goRestart() private {
177         uint txs;
178         address addr;
179 
180         for (uint i = addresses.length - 1; i > 0; i--) {
181             addr = addresses[i];
182             addresses.length -= 1;
183             delete depositors[addr];
184             if (txs++ == MASS_LIMIT) {
185                 return;
186             }
187         }
188 
189         emit NextStageStarted(stage, now, depAmount);
190         pause = false;
191         stage += 1;
192         depAmount = 0;
193         lastPayDate = now;
194 
195     }
196 
197 }