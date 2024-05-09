1 pragma solidity ^0.4.24;
2 
3 /*
4 *
5 * EthCash_V2 Contract Source
6 *~~~~~~~~~~~~~~~~~~~~~~~
7 * Web: ethcash.online
8 * Web mirrors: ethcash.global | ethcash.club
9 * Email: online@ethcash.online
10 * Telergam: ETHCash_Online
11 *~~~~~~~~~~~~~~~~~~~~~~~
12 *  - GAIN 3,50% PER 24 HOURS
13 *  - Life-long payments
14 *  - Minimal 0.03 ETH
15 *  - Can payouts yourself every 30 minutes - send 0 eth (> 0.001 ETH must accumulate on balance)
16 *  - Affiliate 7.00%
17 *    -- 3.50% Cashback (first payment with ref adress DATA)
18 *~~~~~~~~~~~~~~~~~~~~~~~
19 * RECOMMENDED GAS LIMIT: 250000
20 * RECOMMENDED GAS PRICE: ethgasstation.info
21 *
22 */
23 
24 library SafeMath {
25     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
26         if(a == 0) {
27             return 0;
28         }
29 
30         uint256 c = a * b;
31         require(c / a == b);
32 
33         return c;
34     }
35 
36     function div(uint256 a, uint256 b) internal pure returns(uint256) {
37         require(b > 0);
38         uint256 c = a / b;
39 
40         return c;
41     }
42 
43     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
44         require(b <= a);
45         uint256 c = a - b;
46 
47         return c;
48     }
49 
50     function add(uint256 a, uint256 b) internal pure returns(uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     function mod(uint256 a, uint256 b) internal pure returns(uint256) {
58         require(b != 0);
59 
60         return a % b;
61     }
62 }
63 
64 contract EthCash_V2 {
65     using SafeMath for uint;
66 
67     struct Investor {
68         uint id;
69         uint deposit;
70         uint deposits;
71         uint date;
72         address referrer;
73     }
74 
75     uint private MIN_INVEST = 0.03 ether;
76     uint private OWN_COMMISSION_PERCENT = 15;
77     uint private COMPENSATION_COMMISSION_PERCENT = 5;
78     uint private REF_BONUS_PERCENT = 7;
79     uint private CASHBACK_PERCENT = 35;
80     uint private PAYOUT_INTERVAL = 10 minutes;
81     uint private PAYOUT_SELF_INTERVAL = 30 minutes;
82     uint private INTEREST = 35;
83 
84     address constant public ADMIN_COMMISSION_ADDRESS = 0x54E14eaaCffF244c82a1EDc3778F9A0391E7e615;
85     address constant public COMPENSATION_COMMISSION_ADDRESS = 0x8e30A300c73CD8107280f5Af04E90C1F815086E1;
86     uint public depositAmount;
87     uint public payoutDate;
88     uint public paymentDate;
89 
90     address[] public addresses;
91     mapping(address => Investor) public investors;
92 
93     event Invest(address holder, uint amount);
94     event ReferrerBonus(address holder, uint amount);
95     event Cashback(address holder, uint amount);
96     event PayoutCumulative(uint amount, uint txs);
97     event PayoutSelf(address addr, uint amount);
98 
99     constructor() public {
100         payoutDate = now;
101     }
102 
103     function() payable public {
104 
105         if (0 == msg.value) {
106             payoutSelf();
107             return;
108         }
109 
110         require(msg.value >= MIN_INVEST, "Too small amount");
111 
112         Investor storage user = investors[msg.sender];
113 
114         if(user.id == 0) {
115             user.id = addresses.length + 1;
116             addresses.push(msg.sender);
117 
118             address ref = bytesToAddress(msg.data);
119             if(investors[ref].deposit > 0 && ref != msg.sender) {
120                 user.referrer = ref;
121             }
122         }
123 
124         user.deposit = user.deposit.add(msg.value);
125         user.deposits = user.deposits.add(1);
126         user.date = now;
127         emit Invest(msg.sender, msg.value);
128 
129         paymentDate = now;
130         depositAmount = depositAmount.add(msg.value);
131 
132         uint own_com = msg.value.div(100).mul(OWN_COMMISSION_PERCENT);
133         uint com_com = msg.value.div(100).mul(COMPENSATION_COMMISSION_PERCENT);
134         ADMIN_COMMISSION_ADDRESS.transfer(own_com);
135         COMPENSATION_COMMISSION_ADDRESS.transfer(com_com);
136 
137         if(user.referrer != address(0)) {
138             uint bonus = msg.value.div(100).mul(REF_BONUS_PERCENT);
139             user.referrer.transfer(bonus);
140             emit ReferrerBonus(user.referrer, bonus);
141 
142             if(user.deposits == 1) {
143                 uint cashback = msg.value.div(1000).mul(CASHBACK_PERCENT);
144                 msg.sender.transfer(cashback);
145                 emit Cashback(msg.sender, cashback);
146             }
147         }
148     }
149 
150     function payout(uint limit) public {
151 
152         require(now >= payoutDate + PAYOUT_INTERVAL, "Too fast payout request");
153 
154         uint sum;
155         uint txs;
156 
157         for(uint i = addresses.length ; i > 0; i--) {
158             address addr = addresses[i - 1];
159 
160             if(investors[addr].date + 20 hours > now) continue;
161 
162             uint amount = getInvestorUnPaidAmount(addr);
163             investors[addr].date = now;
164 
165             if(address(this).balance < amount) {
166                 return;
167             }
168 
169             addr.transfer(amount);
170 
171             sum = sum.add(amount);
172 
173             if(++txs >= limit) break;
174         }
175 
176         payoutDate = now;
177 
178         emit PayoutCumulative(sum, txs);
179     }
180 
181     function payoutSelf() public {
182         address addr = msg.sender;
183 
184         require(investors[addr].deposit > 0, "Deposit not found");
185         require(now >= investors[addr].date + PAYOUT_SELF_INTERVAL, "Too fast payout request");
186 
187         uint amount = getInvestorUnPaidAmount(addr);
188         require(amount >= 1 finney, "Too small unpaid amount");
189 
190         investors[addr].date = now;
191 
192         if(address(this).balance < amount) {
193             return;
194         }
195 
196         addr.transfer(amount);
197 
198         emit PayoutSelf(addr, amount);
199     }
200 
201     function bytesToAddress(bytes bys) private pure returns(address addr) {
202         assembly {
203             addr := mload(add(bys, 20))
204         }
205     }
206 
207     function getInvestorUnPaidAmount(address addr) public view returns(uint) {
208         return investors[addr].deposit.div(1000).mul(INTEREST).div(100).mul(now.sub(investors[addr].date).mul(100)).div(1 days);
209     }
210 
211     function getInvestorCount() public view returns(uint) { return addresses.length; }
212 }