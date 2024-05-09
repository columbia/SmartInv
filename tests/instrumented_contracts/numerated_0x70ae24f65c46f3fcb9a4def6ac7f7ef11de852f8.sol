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
30  * RECOMMENDED GAS LIMIT: 150000
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
102     mapping (address => uint256) internal timestamps;
103 
104     function getUserInvestBalance(address addr) public view returns(uint) {
105         return balances[addr];
106     }
107 
108     function getUserPayoutBalance(address addr) public view returns(uint) {
109         if (timestamps[addr] > 0) {
110             uint time = now.sub(timestamps[addr]);
111             return getUserInvestBalance(addr).mul(profit).div(100).mul(time).div(1 days);
112         } else {
113             return 0;
114         }
115     }
116 
117 }
118 
119 contract Leprechaun is Storage {
120 
121     using Addr for *;
122 
123     modifier onlyHuman() {
124         address addr = msg.sender;
125         uint size;
126         assembly { size := extcodesize(addr) }
127         require(size == 0, "You're not a human!");
128         _;
129     }
130 
131     modifier checkFirstDeposit() {
132         require(
133             !(getUserInvestBalance(msg.sender) == 0 && msg.value > 0 && msg.value < minimalDeposit),
134             "The first deposit is less than the minimum amount"
135         );
136         _;
137     }
138 
139     modifier fromPartner() {
140         if (getUserInvestBalance(msg.sender) == 0 && msg.value > 0) {
141             address ref = msg.data.toAddr();
142             if (ref.notZero() && ref != msg.sender && balances[ref] > 0) {
143                 _;
144             }
145         }
146     }
147 
148     constructor() public payable {}
149 
150     function() public payable onlyHuman checkFirstDeposit {
151         cashback();
152         sendCommission();
153         sendPayout();
154         updateUserInvestBalance();
155     }
156 
157     function cashback() internal fromPartner {
158 
159         uint amountPartner = msg.value.mul(cashbackPartner).div(100);
160         transfer(msg.data.toAddr(), amountPartner);
161 
162         uint amountInvestor = msg.value.mul(cashbackInvestor).div(100);
163         transfer(msg.sender, amountInvestor);
164 
165         totalPaid = totalPaid.add(amountPartner).add(amountInvestor);
166     }
167 
168     function sendCommission() internal {
169         if (msg.value > 0) {
170             uint commission = msg.value.mul(projectCommission).div(100);
171             if (commission > 0) {
172                 transfer(addrCommission, commission);
173             }
174         }
175     }
176 
177     function sendPayout() internal {
178 
179         if (getUserInvestBalance(msg.sender) > 0) {
180 
181             uint profit = getUserPayoutBalance(msg.sender);
182 
183             if (profit >= minimalPayout) {
184                 transfer(msg.sender, profit);
185                 timestamps[msg.sender] = now;
186                 totalPaid = totalPaid.add(profit);
187             }
188 
189         } else if (msg.value > 0) {
190             // new user with first deposit
191             timestamps[msg.sender] = now;
192             countInvestors++;
193         }
194 
195     }
196 
197     function updateUserInvestBalance() internal {
198         balances[msg.sender] = balances[msg.sender].add(msg.value);
199         totalInvest = totalInvest.add(msg.value);
200     }
201 
202     function transfer(address addr, uint amount) internal {
203 
204         if (amount <= 0 || addr.isZero()) { return; }
205 
206         require(gasleft() > 3500, "Need more gas for transaction");
207 
208         if (addr.send(amount) == false) {
209             // The contract does not have more money and it will be destroyed
210             selfdestruct(addrCommission);
211         }
212 
213     }
214 
215 }