1 pragma solidity ^0.4.24;
2 
3 /*
4 *
5 * EthCash Contract Source
6 *~~~~~~~~~~~~~~~~~~~~~~~
7 * Web: ethcash.fun
8 *~~~~~~~~~~~~~~~~~~~~~~~
9 *  - GAIN 1,5% PER 24 HOURS
10 *  - Life-long payments
11 *  - Minimal 0.03 ETH
12 *  - Can payouts yourself every 30 minutes - send 0 eth (> 0.001 ETH must accumulate on balance)
13 *  - Affiliate 7.00%
14 *    -- 3.50% Cashback (first payment with ref adress DATA)
15 *~~~~~~~~~~~~~~~~~~~~~~~   
16 * RECOMMENDED GAS LIMIT: 250000
17 * RECOMMENDED GAS PRICE: ethgasstation.info
18 *
19 */
20 
21 library SafeMath {
22     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
23         if(a == 0) {
24             return 0;
25         }
26 
27         uint256 c = a * b;
28         require(c / a == b);
29 
30         return c;
31     }
32 
33     function div(uint256 a, uint256 b) internal pure returns(uint256) {
34         require(b > 0);
35         uint256 c = a / b;
36 
37         return c;
38     }
39 
40     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     function add(uint256 a, uint256 b) internal pure returns(uint256) {
48         uint256 c = a + b;
49         require(c >= a);
50 
51         return c;
52     }
53 
54     function mod(uint256 a, uint256 b) internal pure returns(uint256) {
55         require(b != 0);
56 
57         return a % b;
58     }
59 }
60 
61 contract Ownable {
62     address private _owner;
63 
64     event OwnershipRenounced(address indexed previousOwner);
65     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67     modifier onlyOwner() { require(isOwner()); _; }
68 
69     constructor() public {
70         _owner = msg.sender;
71     }
72 
73     function owner() public view returns(address) {
74         return _owner;
75     }
76 
77     function isOwner() public view returns(bool) {
78         return msg.sender == _owner;
79     }
80 
81     function renounceOwnership() public onlyOwner {
82         _owner = address(0);
83 
84         emit OwnershipRenounced(_owner);
85     }
86 
87     function transferOwnership(address newOwner) public onlyOwner {
88         _transferOwnership(newOwner);
89     }
90 
91     function _transferOwnership(address newOwner) internal {
92         require(newOwner != address(0));
93 
94         _owner = newOwner;
95         
96         emit OwnershipTransferred(_owner, newOwner);
97     }
98 }
99 
100 contract EthCashonline is Ownable {
101     using SafeMath for uint;
102     
103     struct Investor {
104         uint id;
105         uint deposit;
106         uint deposits;
107         uint date;
108         address referrer;
109     }
110 
111     uint private MIN_INVEST = 0.03 ether;
112     uint private OWN_COMMISSION_PERCENT = 12;
113     uint private REF_BONUS_PERCENT = 7;
114     uint private CASHBACK_PERCENT = 35;
115     uint private PAYOUT_INTERVAL = 1 minutes; 
116     uint private PAYOUT_SELF_INTERVAL = 30 minutes;
117     uint private INTEREST = 15;
118 
119     uint public depositAmount;
120     uint public payoutDate;
121     uint public paymentDate;
122 
123     address[] public addresses;
124     mapping(address => Investor) public investors;
125 
126     event Invest(address holder, uint amount);
127     event ReferrerBonus(address holder, uint amount);
128     event Cashback(address holder, uint amount);
129     event PayoutCumulative(uint amount, uint txs);
130     event PayoutSelf(address addr, uint amount);
131     
132     constructor() public {
133         payoutDate = now;
134     }
135     
136     function() payable public {
137 
138         if (0 == msg.value) {
139             payoutSelf();
140             return;
141         }
142 
143         require(msg.value >= MIN_INVEST, "Too small amount");
144 
145         Investor storage user = investors[msg.sender];
146 
147         if(user.id == 0) {
148             user.id = addresses.length + 1;
149             addresses.push(msg.sender);
150 
151             address ref = bytesToAddress(msg.data);
152             if(investors[ref].deposit > 0 && ref != msg.sender) {
153                 user.referrer = ref;
154             }
155         }
156 
157         user.deposit = user.deposit.add(msg.value);
158         user.deposits = user.deposits.add(1);
159         user.date = now;
160         emit Invest(msg.sender, msg.value);
161 
162         paymentDate = now;
163         depositAmount = depositAmount.add(msg.value);
164 
165         uint own_com = msg.value.div(100).mul(OWN_COMMISSION_PERCENT);
166         owner().transfer(own_com);
167 
168         if(user.referrer != address(0)) {
169             uint bonus = msg.value.div(100).mul(REF_BONUS_PERCENT);
170             user.referrer.transfer(bonus);
171             emit ReferrerBonus(user.referrer, bonus);
172 
173             if(user.deposits == 1) {
174                 uint cashback = msg.value.div(1000).mul(CASHBACK_PERCENT);
175                 msg.sender.transfer(cashback);
176                 emit Cashback(msg.sender, cashback);
177             }
178         }
179     }
180     
181     function payout(uint limit) public {
182 
183         require(now >= payoutDate + PAYOUT_INTERVAL, "Too fast payout request");
184 
185         uint sum;
186         uint txs;
187 
188         for(uint i = addresses.length ; i > 0; i--) {
189             address addr = addresses[i - 1];
190 
191             if(investors[addr].date + 24 hours > now) continue;
192 
193             uint amount = getInvestorUnPaidAmount(addr);
194             investors[addr].date = now;
195 
196             if(address(this).balance < amount) {
197                 selfdestruct(owner());
198                 return;
199             }
200 
201             addr.transfer(amount);
202 
203             sum = sum.add(amount);
204 
205             if(++txs >= limit) break;
206         }
207 
208         payoutDate = now;
209 
210         emit PayoutCumulative(sum, txs);
211     }
212     
213     function payoutSelf() public {
214         address addr = msg.sender;
215 
216         require(investors[addr].deposit > 0, "Deposit not found");
217         require(now >= investors[addr].date + PAYOUT_SELF_INTERVAL, "Too fast payout request");
218 
219         uint amount = getInvestorUnPaidAmount(addr);
220         require(amount >= 1 finney, "Too small unpaid amount");
221 
222         investors[addr].date = now;
223 
224         if(address(this).balance < amount) {
225             selfdestruct(owner());
226             return;
227         }
228 
229         addr.transfer(amount);
230 
231         emit PayoutSelf(addr, amount);
232     }
233     
234     function bytesToAddress(bytes bys) private pure returns(address addr) {
235         assembly {
236             addr := mload(add(bys, 20))
237         }
238     }
239 
240     function getInvestorUnPaidAmount(address addr) public view returns(uint) {
241         return investors[addr].deposit.div(1000).mul(INTEREST).div(100).mul(now.sub(investors[addr].date).mul(100)).div(1 days);
242     }
243 
244     function getInvestorCount() public view returns(uint) { return addresses.length; }
245 }