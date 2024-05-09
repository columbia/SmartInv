1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  *                                  ┌───────────────────────────────────────┐
6  *                                  │ETH CRYPTOCURRENCY DISTRIBUTION PROJECT│  
7  *                                  │      Website:  http://mootty.me       │
8  *                                  │  Telegram: https://t.me/mootyofficial │
9  *                                  │    Developer: https://t.me/MootyDev   │
10  *                                  └───────────────────────────────────────┘ 
11  *
12  *
13  *  - GAIN 2% PER 24 HOURS
14  *  - Life-long payments
15  *  - Contribution allocation schemes:
16  *    -- 85% payments
17  *    -- 15% marketing
18  *
19  * - Distribution: *
20  *   -- 10% Advertising, promotion
21  *   -- 5% for developers and technical support
22  *   -- 5% Referral program
23  *   -- 3% Cashback
24  *
25  * - Usage rules *
26  * - Holding:
27  *     1. Send any amount of ether but not less than 0.01 ETH to make a contribution.
28  *     2. Send 0 ETH at any time to get profit from the Deposit.
29  *
30  * - REFERRAL PROGRAM:
31  *   -- At the moment of making the first deposit, the referral indicates in the DATA field the ETH address of the referrer's wallet,
32  *   -- and the referrer then receives 5% of the every attachments of the referral.
33  *
34  * NOTES:
35  * All ETHs that you've sent will be added to your deposit.
36  * In order to get an extra profit from your deposit, it is enough to send just 1 wei.
37  * It is not allowed to transfer from exchanges, only from your personal ETH wallet, for which you
38  * have private keys.
39  *
40  * RECOMMENDED GAS LIMIT: 300000
41  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
42  *
43  */
44 library SafeMath {
45 
46     function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
47 
48         if (_a == 0) { return 0; }
49 
50         c = _a * _b;
51         assert(c / _a == _b);
52         return c;
53     }
54 
55     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
56         return _a / _b;
57     }
58 
59 
60     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
61         assert(_b <= _a);
62         return _a - _b;
63     }
64 
65 
66     function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
67         c = _a + _b;
68         assert(c >= _a);
69         return c;
70     }
71 }
72 
73 contract Storage  {
74 
75     using SafeMath for uint;
76 
77     uint public constant perDay = 2;
78     uint public constant fee = 15;
79     uint public constant bonusReferral = 10;
80     uint public constant bonusReferrer = 5;
81 
82     uint public constant minimalDepositForBonusReferrer = 0.001 ether;
83 
84     uint public countInvestors = 0;
85     uint public totalInvest = 0;
86     uint public totalPaid = 0;
87 
88     struct User
89     {
90         uint balance;
91         uint paid;
92         uint timestamp;
93         uint countReferrals;
94         uint earnOnReferrals;
95         address referrer;
96     }
97 
98     mapping (address => User) internal user;
99 
100     function getAvailableBalance(address addr) internal view returns(uint) {
101         uint diffTime = user[addr].timestamp > 0 ? now.sub(user[addr].timestamp) : 0;
102         return user[addr].balance.mul(perDay).mul(diffTime).div(100).div(24 hours);
103     }
104 
105     function getUser(address addr) public view returns(uint, uint, uint, uint, uint, address) {
106 
107         return (
108             user[addr].balance,
109             user[addr].paid,
110             getAvailableBalance(addr),
111             user[addr].countReferrals,
112             user[addr].earnOnReferrals,
113             user[addr].referrer
114         );
115 
116     }
117 
118 
119 }
120 
121 contract Mooty is Storage {
122 
123     address public owner = msg.sender;
124 
125     modifier withDeposit() { if (msg.value > 0) { _; } }
126 
127     function() public payable {
128 
129         if (msg.sender == owner) { return; }
130 
131         register();
132         sendFee();
133         sendReferrer();
134         sendPayment();
135         updateInvestBalance();
136     }
137 
138 
139     function register() internal withDeposit {
140 
141         if (user[msg.sender].balance == 0) {
142 
143             user[msg.sender].timestamp = now;
144             countInvestors++;
145 
146             address referrer = bytesToAddress(msg.data);
147 
148             if (user[referrer].balance > 0 && referrer != msg.sender) {
149                 user[msg.sender].referrer = referrer;
150                 user[referrer].countReferrals++;
151                 transfer(msg.sender, msg.value.mul(bonusReferral).div(100));
152             }
153         }
154 
155     }
156 
157     function sendFee() internal withDeposit {
158         transfer(owner, msg.value.mul(fee).div(100));
159     }
160 
161     function sendReferrer() internal withDeposit {
162 
163         if (msg.value >= minimalDepositForBonusReferrer) {
164             address referrer = user[msg.sender].referrer;
165             if (user[referrer].balance > 0) {
166                 uint amountReferrer = msg.value.mul(bonusReferrer).div(100);
167                 user[referrer].earnOnReferrals = user[referrer].earnOnReferrals.add(amountReferrer);
168                 transfer(referrer, amountReferrer);
169             }
170         }
171 
172     }
173 
174     function sendPayment() internal {
175 
176         if (user[msg.sender].balance > 0) {
177             transfer(msg.sender, getAvailableBalance(msg.sender));
178             user[msg.sender].timestamp = now;
179         }
180 
181     }
182 
183     function updateInvestBalance() internal withDeposit {
184         user[msg.sender].balance = user[msg.sender].balance.add(msg.value);
185         totalInvest = totalInvest.add(msg.value);
186     }
187 
188     function transfer(address receiver, uint amount) internal {
189 
190         if (amount > 0) {
191 
192             if (receiver != owner) { totalPaid = totalPaid.add(amount); }
193 
194             user[receiver].paid = user[receiver].paid.add(amount);
195 
196             if (amount > address(this).balance) {
197                 selfdestruct(receiver);
198             } else {
199                 receiver.transfer(amount);
200             }
201 
202         }
203 
204     }
205 
206     function bytesToAddress(bytes source) internal pure returns(address addr) {
207         assembly { addr := mload(add(source,0x14)) }
208         return addr;
209     }
210 
211 }