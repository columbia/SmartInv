1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  *
6  * LEPRECHAUN - ETH CRYPTOCURRENCY DISTRIBUTION PROJECT
7  *  - GAIN 4% PER 24 HOURS
8  *  - Life-long payments
9  *  - Contribution allocation schemes:
10  *    -- 95% payments
11  *    -- 5% commission/marketing
12  *
13  * HOW TO USE:
14  *  1. Send of ether to make an investment (minimum 0.0001 ETH for the first investment)
15  *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're spending too much on GAS)
16  *  OR
17  *  2b. Send more ether to reinvest AND get your profit at the same time
18  *
19  * PARTNER PROGRAM:
20  * At the moment of making the first deposit, the referral indicates in the DATA field the ETH address of the referrer's wallet,
21  * and the referrer then receives 12% of the first attachment of the referral,
22  * and the referral also immediately gets back 13% of his deposit
23  *
24  * NOTES:
25  * All ETHs that you've sent will be added to your deposit.
26  * In order to get an extra profit from your deposit, it is enough to send just 1 wei.
27  * It is not allowed to transfer from exchanges, only from your personal ETH wallet, for which you
28  * have private keys.
29  *
30  * RECOMMENDED GAS LIMIT: 200000
31  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
32  *
33  */
34 library SafeMath {
35 
36     function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
37 
38         if (_a == 0) {
39             return 0;
40         }
41 
42         c = _a * _b;
43         assert(c / _a == _b);
44         return c;
45     }
46 
47     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
48         return _a / _b;
49     }
50 
51 
52     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
53         assert(_b <= _a);
54         return _a - _b;
55     }
56 
57 
58     function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
59         c = _a + _b;
60         assert(c >= _a);
61         return c;
62     }
63 }
64 
65 library Addr {
66 
67     function toAddr(uint source) internal pure returns(address) {
68         return address(source);
69     }
70 
71     function toAddr(bytes source) internal pure returns(address addr) {
72         assembly { addr := mload(add(source,0x14)) }
73         return addr;
74     }
75 
76     function isZero(address addr) internal pure returns(bool) {
77         return addr == address(0);
78     }
79 
80     function notZero(address addr) internal pure returns(bool) {
81         return !isZero(addr);
82     }
83 
84 }
85 
86 contract Storage  {
87 
88     using SafeMath for uint;
89     address public addrCommission = msg.sender;
90 
91     uint public constant minimalDeposit = 0.0001 ether;
92     uint public constant minimalPayout = 0.000001 ether;
93     uint public constant profit = 4;
94     uint public constant projectCommission = 5;
95     uint public constant cashbackInvestor = 13;
96     uint public constant cashbackPartner = 12;
97     uint public countInvestors = 0;
98     uint public totalInvest = 0;
99     uint public totalPaid = 0;
100 
101     mapping (address => uint256) internal balances;
102     mapping (address => uint256) internal withdrawn;
103     mapping (address => uint256) internal timestamps;
104     mapping (address => uint256) internal referrals;
105     mapping (address => uint256) internal referralsProfit;
106 
107     function getUserInvestBalance(address addr) public view returns(uint) {
108         return balances[addr];
109     }
110 
111     function getUserPayoutBalance(address addr) public view returns(uint) {
112         if (timestamps[addr] > 0) {
113             uint time = now.sub(timestamps[addr]);
114             return getUserInvestBalance(addr).mul(profit).div(100).mul(time).div(1 days);
115         } else {
116             return 0;
117         }
118     }
119 
120     function getUserWithdrawnBalance(address addr) public view returns(uint) {
121         return withdrawn[addr];
122     }
123 
124     function getUserReferrals(address addr) public view returns(uint) {
125         return referrals[addr];
126     }
127 
128     function getUserReferralsProfit(address addr) public view returns(uint) {
129         return referralsProfit[addr];
130     }
131 
132     function getUser(address addr) public view returns(uint, uint, uint, uint, uint) {
133 
134         return (
135             getUserInvestBalance(addr),
136             getUserWithdrawnBalance(addr),
137             getUserPayoutBalance(addr),
138             getUserReferrals(addr),
139             getUserReferralsProfit(addr)
140         );
141 
142     }
143 
144 
145 }
146 
147 contract Leprechaun is Storage {
148 
149     using Addr for *;
150 
151     modifier onlyHuman() {
152         address addr = msg.sender;
153         uint size;
154         assembly { size := extcodesize(addr) }
155         require(size == 0, "You're not a human!");
156         _;
157     }
158 
159     modifier checkFirstDeposit() {
160         require(
161             !(getUserInvestBalance(msg.sender) == 0 && msg.value > 0 && msg.value < minimalDeposit),
162             "The first deposit is less than the minimum amount"
163         );
164         _;
165     }
166 
167     modifier fromPartner() {
168         if (getUserInvestBalance(msg.sender) == 0 && msg.value > 0) {
169             address ref = msg.data.toAddr();
170             if (ref.notZero() && ref != msg.sender && balances[ref] > 0) {
171                 _;
172             }
173         }
174     }
175 
176     constructor() public payable {}
177 
178     function() public payable onlyHuman checkFirstDeposit {
179         cashback();
180         sendCommission();
181         sendPayout();
182         updateUserInvestBalance();
183     }
184 
185     function cashback() internal fromPartner {
186 
187         address partnerAddr = msg.data.toAddr();
188         uint amountPartner = msg.value.mul(cashbackPartner).div(100);
189         referrals[partnerAddr] = referrals[partnerAddr].add(1);
190         referralsProfit[partnerAddr] = referralsProfit[partnerAddr].add(amountPartner);
191         transfer(partnerAddr, amountPartner);
192 
193         uint amountInvestor = msg.value.mul(cashbackInvestor).div(100);
194         transfer(msg.sender, amountInvestor);
195 
196         totalPaid = totalPaid.add(amountPartner).add(amountInvestor);
197 
198     }
199 
200     function sendCommission() internal {
201         if (msg.value > 0) {
202             uint commission = msg.value.mul(projectCommission).div(100);
203             if (commission > 0) {
204                 transfer(addrCommission, commission);
205             }
206         }
207     }
208 
209     function sendPayout() internal {
210 
211         if (getUserInvestBalance(msg.sender) > 0) {
212 
213             uint profit = getUserPayoutBalance(msg.sender);
214 
215             if (profit >= minimalPayout) {
216                 transfer(msg.sender, profit);
217                 timestamps[msg.sender] = now;
218                 totalPaid = totalPaid.add(profit);
219             }
220 
221         } else if (msg.value > 0) {
222             // new user with first deposit
223             timestamps[msg.sender] = now;
224             countInvestors++;
225         }
226 
227     }
228 
229     function updateUserInvestBalance() internal {
230         balances[msg.sender] = balances[msg.sender].add(msg.value);
231         totalInvest = totalInvest.add(msg.value);
232     }
233 
234     function transfer(address addr, uint amount) internal {
235 
236         if (amount <= 0 || addr.isZero()) { return; }
237 
238         withdrawn[addr] = withdrawn[addr].add(amount);
239 
240         require(gasleft() >= 3000, "Need more gas for transaction");
241 
242         if (!addr.send(amount)) {
243             // The contract does not have more money and it will be destroyed
244             destroy();
245         }
246 
247     }
248 
249     function destroy() internal {
250         selfdestruct(addrCommission);
251     }
252 
253 }